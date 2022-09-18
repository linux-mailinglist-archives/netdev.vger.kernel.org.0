Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568585BC07A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiIRXA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiIRXAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:00:55 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485E11582D
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 16:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663542054; x=1695078054;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4U/bZFIwVA1BZPON+IwR2MATxVxLR/hHV5rKMHwsVIo=;
  b=LBm31yktFtlPjp44Y/GqS46dXvQhr+U9ANL8OmRJHxQawQcgMb66FyQc
   9DCRagyg5PGsAz12CtlyLkM6eOzE1QHfGgDByrP5wpNgrhneuCg+oLkNR
   T7Zn+2zgpX94zqtMzDVtppt53dEJt83u3NKEuT9pecEotmc5LZvqrWXlj
   k+X3fBDf5+TcKqvdCqjEyEZOo/pcAREtEHTT/HoVysZOmytsD8dzgBG4t
   k1B/LJDNUxeDcdmmItnskwKLMX9yQaldzIAk597XmXdHyKdSwBBOVsq4h
   gSDRNx/lGNyB3N5PkJxJqBEgNiRmIzR4CHuypN3e8jMXVBgyEHrszbjOL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10474"; a="296861934"
X-IronPort-AV: E=Sophos;i="5.93,325,1654585200"; 
   d="scan'208";a="296861934"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2022 16:00:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,325,1654585200"; 
   d="scan'208";a="760656262"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 18 Sep 2022 16:00:51 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oa3HO-0001XN-17;
        Sun, 18 Sep 2022 23:00:50 +0000
Date:   Mon, 19 Sep 2022 07:00:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next 09/10] net/mlx5e: Support MACsec offload
 extended packet number (EPN)
Message-ID: <202209190643.05Qx70aL-lkp@intel.com>
References: <20220911234059.98624-10-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220911234059.98624-10-saeed@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20220919/202209190643.05Qx70aL-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2a128479cc7dc9483c0d677fdcb532ae2ea4b056
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Saeed-Mahameed/mlx5-MACSec-Extended-packet-number-and-replay-window-offload/20220912-074318
        git checkout 2a128479cc7dc9483c0d677fdcb532ae2ea4b056
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:1313:59: warning: shift count >= width of type [-Wshift-count-overflow]
                   aso_ctrl->va_h  = cpu_to_be32(macsec_aso->umr->dma_addr >> 32);
                                                                           ^  ~~
   include/linux/byteorder/generic.h:94:21: note: expanded from macro 'cpu_to_be32'
   #define cpu_to_be32 __cpu_to_be32
                       ^
   include/uapi/linux/byteorder/little_endian.h:40:53: note: expanded from macro '__cpu_to_be32'
   #define __cpu_to_be32(x) ((__force __be32)__swab32((x)))
                                                       ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:1389:32: warning: shift count >= width of type [-Wshift-count-overflow]
                   param.bitwise_data = BIT(22) << 32;
                                                ^  ~~
   2 warnings generated.


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

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
