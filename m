Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C843D5B52F7
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 05:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiILD5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 23:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiILD5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 23:57:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFF12314D
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 20:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662955054; x=1694491054;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rYTPX+EL1YgJBaJsjbqTRejR1gPyzEuOTMOdAE5paXc=;
  b=aFI1mMf9vikBLt0QcL+abGREKaR2gYcO5oAhqyD/vTiBESaXs4pm/UZ0
   TA7ltCg5I5KqKyp8TmGuH1Nb1vCEvYq51EAsVx8qtop9CLH68KeJk/YNY
   rE4AuE5C6y5r4CFjh7RCQFEMlm1mj6vqyTtWV+lQEeNvHTmoOgIH9hioF
   a6XcUQBeYWqN8s/bJPhxWYrjKT208W2G3wr0YCaqokADMLDVSe+le1IPE
   rLLyIpwqgzjr/w0aOub2nVopSF9pf262rHYK70VpXEJexiD2kT/uNRQT/
   cO1nK3RBuQnqQ664Up+0meei/oyQRps5rrM3pb1fmHq+UnfDLrOp6JYoA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10467"; a="280798504"
X-IronPort-AV: E=Sophos;i="5.93,308,1654585200"; 
   d="scan'208";a="280798504"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2022 20:57:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,308,1654585200"; 
   d="scan'208";a="944470404"
Received: from lkp-server02.sh.intel.com (HELO 4011df4f4fd3) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 11 Sep 2022 20:57:30 -0700
Received: from kbuild by 4011df4f4fd3 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oXaZd-00028r-38;
        Mon, 12 Sep 2022 03:57:29 +0000
Date:   Mon, 12 Sep 2022 11:57:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next 09/10] net/mlx5e: Support MACsec offload
 extended packet number (EPN)
Message-ID: <202209121134.cIwqQMz7-lkp@intel.com>
References: <20220911234059.98624-10-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220911234059.98624-10-saeed@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Saeed-Mahameed/mlx5-MACSec-Extended-packet-number-and-replay-window-offload/20220912-074318
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 169ccf0e40825d9e465863e4707d8e8546d3c3cb
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220912/202209121134.cIwqQMz7-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2a128479cc7dc9483c0d677fdcb532ae2ea4b056
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Saeed-Mahameed/mlx5-MACSec-Extended-packet-number-and-replay-window-offload/20220912-074318
        git checkout 2a128479cc7dc9483c0d677fdcb532ae2ea4b056
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash drivers/net/ethernet/mellanox/mlx5/core/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/byteorder/big_endian.h:5,
                    from arch/powerpc/include/uapi/asm/byteorder.h:14,
                    from include/asm-generic/bitops/le.h:6,
                    from arch/powerpc/include/asm/bitops.h:336,
                    from include/linux/bitops.h:68,
                    from include/linux/bitmap.h:8,
                    from include/linux/ethtool.h:16,
                    from include/rdma/ib_verbs.h:15,
                    from include/linux/mlx5/device.h:37,
                    from drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:4:
   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c: In function 'macsec_aso_build_wqe_ctrl_seg':
>> drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:1313:73: warning: right shift count >= width of type [-Wshift-count-overflow]
    1313 |                 aso_ctrl->va_h  = cpu_to_be32(macsec_aso->umr->dma_addr >> 32);
         |                                                                         ^~
   include/uapi/linux/byteorder/big_endian.h:40:51: note: in definition of macro '__cpu_to_be32'
      40 | #define __cpu_to_be32(x) ((__force __be32)(__u32)(x))
         |                                                   ^
   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:1313:35: note: in expansion of macro 'cpu_to_be32'
    1313 |                 aso_ctrl->va_h  = cpu_to_be32(macsec_aso->umr->dma_addr >> 32);
         |                                   ^~~~~~~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c: In function 'macsec_aso_build_ctrl':
>> drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:1389:46: warning: left shift count >= width of type [-Wshift-count-overflow]
    1389 |                 param.bitwise_data = BIT(22) << 32;
         |                                              ^~


vim +1313 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c

  1305	
  1306	static void macsec_aso_build_wqe_ctrl_seg(struct mlx5e_macsec_aso *macsec_aso,
  1307						  struct mlx5_wqe_aso_ctrl_seg *aso_ctrl,
  1308						  struct mlx5_aso_ctrl_param *param)
  1309	{
  1310		memset(aso_ctrl, 0, sizeof(*aso_ctrl));
  1311		if (macsec_aso->umr->dma_addr) {
  1312			aso_ctrl->va_l  = cpu_to_be32(macsec_aso->umr->dma_addr | ASO_CTRL_READ_EN);
> 1313			aso_ctrl->va_h  = cpu_to_be32(macsec_aso->umr->dma_addr >> 32);
  1314			aso_ctrl->l_key = cpu_to_be32(macsec_aso->umr->mkey);
  1315		}
  1316	
  1317		if (!param)
  1318			return;
  1319	
  1320		aso_ctrl->data_mask_mode = param->data_mask_mode << 6;
  1321		aso_ctrl->condition_1_0_operand = param->condition_1_operand |
  1322							param->condition_0_operand << 4;
  1323		aso_ctrl->condition_1_0_offset = param->condition_1_offset |
  1324							param->condition_0_offset << 4;
  1325		aso_ctrl->data_offset_condition_operand = param->data_offset |
  1326							param->condition_operand << 6;
  1327		aso_ctrl->condition_0_data = cpu_to_be32(param->condition_0_data);
  1328		aso_ctrl->condition_0_mask = cpu_to_be32(param->condition_0_mask);
  1329		aso_ctrl->condition_1_data = cpu_to_be32(param->condition_1_data);
  1330		aso_ctrl->condition_1_mask = cpu_to_be32(param->condition_1_mask);
  1331		aso_ctrl->bitwise_data = cpu_to_be64(param->bitwise_data);
  1332		aso_ctrl->data_mask = cpu_to_be64(param->data_mask);
  1333	}
  1334	
  1335	static int mlx5e_macsec_modify_obj(struct mlx5_core_dev *mdev, struct mlx5_macsec_obj_attrs *attrs,
  1336					   u32 macsec_id)
  1337	{
  1338		u32 in[MLX5_ST_SZ_DW(modify_macsec_obj_in)] = {};
  1339		u32 out[MLX5_ST_SZ_DW(query_macsec_obj_out)];
  1340		u64 modify_field_select = 0;
  1341		void *obj;
  1342		int err;
  1343	
  1344		/* General object fields set */
  1345		MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
  1346		MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_GENERAL_OBJECT_TYPES_MACSEC);
  1347		MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, macsec_id);
  1348		err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
  1349		if (err) {
  1350			mlx5_core_err(mdev, "Query MACsec object failed (Object id %d), err = %d\n",
  1351				      macsec_id, err);
  1352			return err;
  1353		}
  1354	
  1355		obj = MLX5_ADDR_OF(query_macsec_obj_out, out, macsec_object);
  1356		modify_field_select = MLX5_GET64(macsec_offload_obj, obj, modify_field_select);
  1357	
  1358		/* EPN */
  1359		if (!(modify_field_select & MLX5_MODIFY_MACSEC_BITMASK_EPN_OVERLAP) ||
  1360		    !(modify_field_select & MLX5_MODIFY_MACSEC_BITMASK_EPN_MSB)) {
  1361			mlx5_core_dbg(mdev, "MACsec object field is not modifiable (Object id %d)\n",
  1362				      macsec_id);
  1363			return -EOPNOTSUPP;
  1364		}
  1365	
  1366		obj = MLX5_ADDR_OF(modify_macsec_obj_in, in, macsec_object);
  1367		MLX5_SET64(macsec_offload_obj, obj, modify_field_select,
  1368			   MLX5_MODIFY_MACSEC_BITMASK_EPN_OVERLAP | MLX5_MODIFY_MACSEC_BITMASK_EPN_MSB);
  1369		MLX5_SET(macsec_offload_obj, obj, epn_msb, attrs->epn_state.epn_msb);
  1370		MLX5_SET(macsec_offload_obj, obj, epn_overlap, attrs->epn_state.overlap);
  1371	
  1372		/* General object fields set */
  1373		MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_MODIFY_GENERAL_OBJECT);
  1374	
  1375		return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
  1376	}
  1377	
  1378	static void macsec_aso_build_ctrl(struct mlx5e_macsec_aso *aso,
  1379					  struct mlx5_wqe_aso_ctrl_seg *aso_ctrl,
  1380					  struct mlx5e_macsec_aso_in *in)
  1381	{
  1382		struct mlx5_aso_ctrl_param param = {};
  1383	
  1384		param.data_mask_mode = MLX5_ASO_DATA_MASK_MODE_BITWISE_64BIT;
  1385		param.condition_0_operand = MLX5_ASO_ALWAYS_TRUE;
  1386		param.condition_1_operand = MLX5_ASO_ALWAYS_TRUE;
  1387		if (in->mode == MLX5_MACSEC_EPN) {
  1388			param.data_offset = MLX5_MACSEC_ASO_REMOVE_FLOW_PKT_CNT_OFFSET;
> 1389			param.bitwise_data = BIT(22) << 32;
  1390			param.data_mask = param.bitwise_data;
  1391		}
  1392	
  1393		macsec_aso_build_wqe_ctrl_seg(aso, aso_ctrl, &param);
  1394	}
  1395	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
