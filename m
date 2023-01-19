Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEC367430E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjASTsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjASTsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:48:15 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A7D7A53B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 11:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674157693; x=1705693693;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r3frNLJx/8tkQ3XOoDV2BjOvJvEf1oUMfhHDiNIrhmE=;
  b=gsp01lWVisQsBy8pfit+5gp/BjQYYrPeOvp5Mg/0A4h5Xvn3ep3F24jU
   uHtzstw0/IMJOvfxR4lafodG8jgf+udOX93uYhlCXwv9x2BfNPQCD03h8
   ru3OfqqtSOvUbYgxyxgTOSR4FWzo9jE+55TgRQN7rU5ji80s6B9zMfmUn
   ZewWtiExCLxQSkdCg3f0QEBRACKQ6EKypD/RxfVZivkcjFdpxywH+ezrm
   BgfCGux71iQiqtyhPZb3XrmdYM4MRzJBKoRvRh6HtgeSfMlPEF3bnSPgl
   OeLx5wMRtL24A+LioiKiEFyRzosHxf34BX/wX/BH/RvuKV2Tckc536MZc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="324087778"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="324087778"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 11:48:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="989110098"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="989110098"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 19 Jan 2023 11:48:10 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pIatN-0001ng-0v;
        Thu, 19 Jan 2023 19:48:09 +0000
Date:   Fri, 20 Jan 2023 03:47:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm@gmail.com, ecree.xilinx@gmail.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH net-next 5/7] sfc: obtain device mac address based on
 firmware handle for ef100
Message-ID: <202301200333.BjjkOStI-lkp@intel.com>
References: <20230119113140.20208-6-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119113140.20208-6-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230119-193440
patch link:    https://lore.kernel.org/r/20230119113140.20208-6-alejandro.lucero-palau%40amd.com
patch subject: [PATCH net-next 5/7] sfc: obtain device mac address based on firmware handle for ef100
config: i386-randconfig-a015 (https://download.01.org/0day-ci/archive/20230120/202301200333.BjjkOStI-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/94535fc2c87743925490d5ce0573b8e9b4b2690c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230119-193440
        git checkout 94535fc2c87743925490d5ce0573b8e9b4b2690c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/sfc/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/sfc/ef100_nic.c:1127:21: warning: unused variable 'net_dev' [-Wunused-variable]
           struct net_device *net_dev = efx->net_dev;
                              ^
>> drivers/net/ethernet/sfc/ef100_nic.c:1172:9: warning: variable 'rc' is uninitialized when used here [-Wuninitialized]
           return rc;
                  ^~
   drivers/net/ethernet/sfc/ef100_nic.c:1128:8: note: initialize the variable 'rc' to silence this warning
           int rc;
                 ^
                  = 0
   2 warnings generated.


vim +/net_dev +1127 drivers/net/ethernet/sfc/ef100_nic.c

51b35a454efdcd Edward Cree      2020-07-27  1123  
98ff4c7c8ac7f5 Jonathan Cooper  2022-06-28  1124  int ef100_probe_netdev_pf(struct efx_nic *efx)
51b35a454efdcd Edward Cree      2020-07-27  1125  {
98ff4c7c8ac7f5 Jonathan Cooper  2022-06-28  1126  	struct ef100_nic_data *nic_data = efx->nic_data;
29ec1b27e73990 Edward Cree      2020-07-27 @1127  	struct net_device *net_dev = efx->net_dev;
98ff4c7c8ac7f5 Jonathan Cooper  2022-06-28  1128  	int rc;
29ec1b27e73990 Edward Cree      2020-07-27  1129  
6f6838aabff5ea Edward Cree      2022-07-28  1130  	if (!nic_data->grp_mae)
6f6838aabff5ea Edward Cree      2022-07-28  1131  		return 0;
6f6838aabff5ea Edward Cree      2022-07-28  1132  
6f6838aabff5ea Edward Cree      2022-07-28  1133  #ifdef CONFIG_SFC_SRIOV
67ab160ed08f5b Edward Cree      2022-07-28  1134  	rc = efx_init_struct_tc(efx);
67ab160ed08f5b Edward Cree      2022-07-28  1135  	if (rc)
67ab160ed08f5b Edward Cree      2022-07-28  1136  		return rc;
67ab160ed08f5b Edward Cree      2022-07-28  1137  
6f6838aabff5ea Edward Cree      2022-07-28  1138  	rc = efx_ef100_get_base_mport(efx);
6f6838aabff5ea Edward Cree      2022-07-28  1139  	if (rc) {
6f6838aabff5ea Edward Cree      2022-07-28  1140  		netif_warn(efx, probe, net_dev,
6f6838aabff5ea Edward Cree      2022-07-28  1141  			   "Failed to probe base mport rc %d; representors will not function\n",
6f6838aabff5ea Edward Cree      2022-07-28  1142  			   rc);
f393f2642abb0e Alejandro Lucero 2023-01-19  1143  	} else {
f393f2642abb0e Alejandro Lucero 2023-01-19  1144  		if (efx_probe_devlink(efx))
f393f2642abb0e Alejandro Lucero 2023-01-19  1145  			netif_warn(efx, probe, net_dev,
f393f2642abb0e Alejandro Lucero 2023-01-19  1146  				   "Failed to register devlink\n");
1542af777ce523 Alejandro Lucero 2023-01-19  1147  		rc = efx_init_mae(efx);
1542af777ce523 Alejandro Lucero 2023-01-19  1148  		if (rc)
1542af777ce523 Alejandro Lucero 2023-01-19  1149  			pci_warn(efx->pci_dev,
1542af777ce523 Alejandro Lucero 2023-01-19  1150  				 "Failed to init MAE rc %d; representors will not function\n",
1542af777ce523 Alejandro Lucero 2023-01-19  1151  				 rc);
1542af777ce523 Alejandro Lucero 2023-01-19  1152  		else
1542af777ce523 Alejandro Lucero 2023-01-19  1153  			efx_ef100_init_reps(efx);
6f6838aabff5ea Edward Cree      2022-07-28  1154  	}
67ab160ed08f5b Edward Cree      2022-07-28  1155  
67ab160ed08f5b Edward Cree      2022-07-28  1156  	rc = efx_init_tc(efx);
67ab160ed08f5b Edward Cree      2022-07-28  1157  	if (rc) {
67ab160ed08f5b Edward Cree      2022-07-28  1158  		/* Either we don't have an MAE at all (i.e. legacy v-switching),
67ab160ed08f5b Edward Cree      2022-07-28  1159  		 * or we do but we failed to probe it.  In the latter case, we
67ab160ed08f5b Edward Cree      2022-07-28  1160  		 * may not have set up default rules, in which case we won't be
67ab160ed08f5b Edward Cree      2022-07-28  1161  		 * able to pass any traffic.  However, we don't fail the probe,
67ab160ed08f5b Edward Cree      2022-07-28  1162  		 * because the user might need to use the netdevice to apply
67ab160ed08f5b Edward Cree      2022-07-28  1163  		 * configuration changes to fix whatever's wrong with the MAE.
67ab160ed08f5b Edward Cree      2022-07-28  1164  		 */
67ab160ed08f5b Edward Cree      2022-07-28  1165  		netif_warn(efx, probe, net_dev, "Failed to probe MAE rc %d\n",
67ab160ed08f5b Edward Cree      2022-07-28  1166  			   rc);
9dc0cad203ab57 Edward Cree      2022-09-26  1167  	} else {
9dc0cad203ab57 Edward Cree      2022-09-26  1168  		net_dev->features |= NETIF_F_HW_TC;
9dc0cad203ab57 Edward Cree      2022-09-26  1169  		efx->fixed_features |= NETIF_F_HW_TC;
67ab160ed08f5b Edward Cree      2022-07-28  1170  	}
6f6838aabff5ea Edward Cree      2022-07-28  1171  #endif
29ec1b27e73990 Edward Cree      2020-07-27 @1172  	return rc;
51b35a454efdcd Edward Cree      2020-07-27  1173  }
51b35a454efdcd Edward Cree      2020-07-27  1174  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
