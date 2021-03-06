function nii_stat_svm(les,beh, beh_names, statname, les_names, subj_data)
if ~exist('statname','var')
    statname = 'anonymous';
end
if ~exist('subj_data','var')
    subj_data = [];
end;
chDirSub([statname '_svm']);
diary ([deblank(statname) 'svm.txt']);
for j = 1:size(beh_names,2) %for each beahvioral variable
    beh_name1 = beh_names{j};
    beh1 = beh(:,j);
    fnm = tabFileSub(les,beh1, beh_name1,  les_names, subj_data);
    nii_stat_svm_core(fnm, min(beh1(:)), 0.5+min(beh1(:)) );
    %nii_stat_svm_core(fnm, min(beh1(:)), max(beh1(:)) );
end
diary off %stop logging text
cd .. %leave the folder created by chDirSub
%end nii_stat_svm() LOCAL FUNCTIONS FOLLOW

function fnm = tabFileSub(les,beh1, beh_name1,  les_names, subj_data)  
if size(les,1) ~= size(beh1,1)
    error('nii_stat_svm confused');
end
fnm = [beh_name1  '.tab'];
fid = fopen(fnm, 'w');
n_subj = size(les,1);
fprintf(fid,'filename\t');
for j = 1:numel(les_names)
     fprintf(fid,'%s\t', les_names{j}); 
end
fprintf(fid,'%s\t', beh_name1);
fprintf(fid,'\n');
for i = 1:n_subj
    if ~isempty('subj_data')
       fprintf(fid,'%s\t',subj_data{i}.filename); 
    else
        fprintf(fid,'%s\t',num2str(i));
    end
    for j = 1:numel(les_names)
         fprintf(fid,'%g\t',les(i, j));
    end
    fprintf(fid,'%g\t',beh1(i));
    fprintf(fid,'\n');
end
fclose(fid);
%end tabFileSub()

function chDirSub(statname)
datetime=datestr(now);
datetime=strrep(datetime,':',''); %Replace colon with underscore
datetime=strrep(datetime,'-','');%Replace minus sign with underscore
datetime=strrep(datetime,' ','_');%Replace space with underscore
newdir = [datetime statname];
mkdir(newdir);
cd(newdir);
%chDirSub()