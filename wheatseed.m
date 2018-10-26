clear
clc
load wheatseeds.mat  %共210*7维数据
%wheatseeds.mat可以分为3类(1,2,3);
%第一类为第1-70行数据，第二类为第71-140行数据，第三类为第141-210行数据;
%将wheatseeds.mat的数据分成两个矩阵：训练数据trdata和测试数据tedata;
%trdata包含每类数据的前40行;tedata包含每类数据的后30行；
%数据分类如下：

trdata1=wheatseeds(1:40,1:7);
tedata1=wheatseeds(41:70,1:7);
trdata2=wheatseeds(71:110,1:7);
tedata2=wheatseeds(111:140,1:7);
trdata3=wheatseeds(141:180,1:7);
tedata3=wheatseeds(181:210,1:7);
trdata=[trdata1;trdata2;trdata3];
tedata=[tedata1;tedata2;tedata3];


%假设wheatseeds.mat中每一类、每一维都服从正态分布;
%分别计算3类种子的7种评估标准的均值和方差;
mean=zeros(3,7);    %均值
sigma=zeros(3,7);   %方差
for i=1:7
    [mean(1,i),sigma(1,i)]=normfit(trdata1(:,i));
    [mean(2,i),sigma(2,i)]=normfit(trdata2(:,i));
    [mean(3,i),sigma(3,i)]=normfit(trdata3(:,i));
end

%用朴素贝叶斯计算似然函数;
posterior=zeros(3,90); %后验概率
priori=zeros(3,1);     %先验概率
class=zeros(90,1);
for i=1:90
    for j=1:3
        if j==1
           priori(j,1)=70/210;  %类别1的先验概率
        elseif j==2
            priori(j,1)=70/210;  %类别2的先验概率
        else 
            priori(j,1)=70/210;  %类别3的先验概率
        end
        likelihood=ones(3,1);   %计算似然函数
        for d=1:7
            likelihood(j,1)=likelihood(j,1)*normpdf(tedata(i,d),mean(j,d),sigma(j,d));
        end
        posterior(j,i)=likelihood(j,1)*priori(j,1);  %计算后验概率
    end
    C=posterior(:,i);  
    [m,n]=max(C);   %选择最大后验概率对应的类别
    class(i,1)=n;   %对90个测试数据分类，产生90*1的矩阵
end

%计算分类正确的概率：a代表分类正确，b代表分类错误
a1=0;
a2=0;
a3=0;
b1=0;
b2=0;
b3=0;
for k=1:30
    if class(k)==1
        a1=a1+1;
    else 
        b1=b1+1;
    end
end
for k=31:60
    if class(k)==2
        a2=a2+1;
    else 
        b2=b2+1;
    end
end
for k=61:90
    if class(k)==3
        a3=a3+1;
    else 
        b3=b3+1;
    end
end
a=a1+a2+a3;
b=b1+b2+b3;
true_per=a/90;
false_per=b/90;

%作图展示在7种标准下数据的分类情况;
%第一类数据为蓝色，第二类数据为绿色，第三类数据为黄色;
figure; 
subplot(3,3,1);
hold on
scatter(1:90,tedata(:,1),20,class,'filled');
plot([30,30],[0,25],'--k');%分割线
plot([60,60],[0,25],'--k');
xlabel('sample');
ylabel('area');            %标准1：区域
hold off

subplot(3,3,2);
hold on
scatter(1:90,tedata(:,2),20,class,'filled');
plot([30,30],[0,20],'--k');%分割线
plot([60,60],[0,20],'--k');
xlabel('sample');
ylabel('girth');           %标准2：周长

subplot(3,3,3);
hold on
scatter(1:90,tedata(:,3),20,class,'filled');
plot([30,30],[0,20],'--k');%分割线
plot([60,60],[0,20],'--k');
xlabel('sample');
ylabel('puddlability');    %标准3：压实度
hold off

subplot(3,3,4);
hold on
scatter(1:90,tedata(:,4),20,class,'filled');
plot([30,30],[0,20],'--k');%分割线
plot([60,60],[0,20],'--k');
xlabel('sample');
ylabel('grainlength');
hold off

subplot(3,3,5);
hold on
scatter(1:90,tedata(:,5),20,class,'filled');
plot([30,30],[0,20],'--k');%分割线
plot([60,60],[0,20],'--k');
xlabel('sample');
ylabel('grainwidth');
hold off

subplot(3,3,6);
hold on
scatter(1:90,tedata(:,6),20,class,'filled');
plot([30,30],[0,20],'--k');%分割线
plot([60,60],[0,20],'--k');
xlabel('sample');
ylabel('dissymmetry coefficient');
hold off

subplot(3,3,7);
hold on
scatter(1:90,tedata(:,7),20,class,'filled');
plot([30,30],[0,20],'--k');%分割线
plot([60,60],[0,20],'--k');
xlabel('sample');
ylabel('grain ventral length');
hold off



