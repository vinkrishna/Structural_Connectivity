

#Connectivity
probtrackx --mode=seedmask -x $diff_dir/roi_right/$j -l -c 0.2 -S 2000 --steplength=0.5 -P 5000 --forcedir --opd -s $bedpostx_dir/merged -m $diff_dir/nodif_brain_mask --waypoints=$diff_dir/nodif_brain_mask --dir=$bedpostx_dir/${r2}/${y} --pd


#Normlization

j=$(cat $bedpostx_dir/${r1}/${y}/waytotal)
fslmaths $bedpostx_dir/${r1}/${y}/fdt_paths.nii.gz -div $j -mul 100 $bedpostx_dir/${r1}/${y}/${y}_t


#Fdtpaths in to MNI space
echo "2mm MNI to diffusion space transformation"
flirt -in $diff_dir/nodif_brain.nii.gz -ref $FSLDIR/data/standard/MNI152_T1_1mm_brain -out $diff_dir/diff_MNI_space.nii.gz -omat $diff_dir/diff2MNI.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12 -interp trilinear

echo "Tranforming Diff tracts in MNI space.."
flirt -in $bedpostx_dir/${r1}/$v -applyxfm -init $diff_dir/diff2MNI.mat -out $result_dir/$r1/"${i}"_"${y}" -paddingsize 0.0 -interp trilinear -ref $FSLDIR/data/standard/MNI152_T1_1mm_brain


#Number of connection
echo "number of connections"
echo "$j is fdt_paths"
fslstats $j -M >> "$i"_Number_of_connections.txt
fslstats $j -V >> "$i"_Number_of_voxels.txt
