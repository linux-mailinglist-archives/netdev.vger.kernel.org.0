Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49269475A43
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243152AbhLOOEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:04:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:43325 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243142AbhLOOEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 09:04:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639577049; x=1671113049;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2Up2jDEYXke6v6z8WRRwDnkt2e/mpyh4/QrYQZCrST4=;
  b=cSJULkQkqM2rA/VmQlUc4xfnwuvPn8aJjPTOR4aV1miuZeDOBsvBVYf7
   9hcs+qUIAcLltZqNm590jwrcOpco70X+QQ0Vl1tKPlKM3qHU1M7qem+J/
   j0Rmaqw2N37E3PRoiHEbLZH06O5kHHJH77WUF79mOehJG0FK5dtpVDn0U
   V9xxPhG/fNzHqNaYyLNAuJiH02OtkqpMmn6Brfpgfnah/nOtFBd/A30ka
   oQYsHYI6WiERRdx9U3DL8d29wjWV/MwwqYoUsv82KgWaUZsRcdl9wtkUg
   yHLdUZN7r5InFtV+7nM2/7UOHC9ZVKHjbUtC//+wFZP7mPHE340j9kqNc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="237970334"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="237970334"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 06:04:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="464277492"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 15 Dec 2021 06:04:03 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mxUt0-0001rI-DS; Wed, 15 Dec 2021 14:04:02 +0000
Date:   Wed, 15 Dec 2021 22:03:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: [PATCH] sfc_ef100: potential dereference of null pointer
Message-ID: <202112152115.lNKRy4uk-lkp@intel.com>
References: <20211215094141.164417-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215094141.164417-1-jiasheng@iscas.ac.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiasheng,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.16-rc5 next-20211214]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Jiasheng-Jiang/sfc_ef100-potential-dereference-of-null-pointer/20211215-174422
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 5472f14a37421d1bca3dddf33cabd3bd6dbefbbc
config: microblaze-allyesconfig (https://download.01.org/0day-ci/archive/20211215/202112152115.lNKRy4uk-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/fc56ac03164889a206ee1b65187a8be7aa7b0f04
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jiasheng-Jiang/sfc_ef100-potential-dereference-of-null-pointer/20211215-174422
        git checkout fc56ac03164889a206ee1b65187a8be7aa7b0f04
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=microblaze SHELL=/bin/bash drivers/net/ethernet/sfc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/sfc/ef100_nic.c: In function 'ef100_update_stats':
>> drivers/net/ethernet/sfc/ef100_nic.c:608:9: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     608 |         struct ef100_nic_data *nic_data = efx->nic_data;
         |         ^~~~~~


vim +608 drivers/net/ethernet/sfc/ef100_nic.c

b593b6f1b492170 Edward Cree    2020-08-03  599  
b593b6f1b492170 Edward Cree    2020-08-03  600  static size_t ef100_update_stats(struct efx_nic *efx,
b593b6f1b492170 Edward Cree    2020-08-03  601  				 u64 *full_stats,
b593b6f1b492170 Edward Cree    2020-08-03  602  				 struct rtnl_link_stats64 *core_stats)
b593b6f1b492170 Edward Cree    2020-08-03  603  {
b593b6f1b492170 Edward Cree    2020-08-03  604  	__le64 *mc_stats = kmalloc(array_size(efx->num_mac_stats, sizeof(__le64)), GFP_ATOMIC);
fc56ac03164889a Jiasheng Jiang 2021-12-15  605  	if (!mc_stats)
fc56ac03164889a Jiasheng Jiang 2021-12-15  606  		return 0;
fc56ac03164889a Jiasheng Jiang 2021-12-15  607  
b593b6f1b492170 Edward Cree    2020-08-03 @608  	struct ef100_nic_data *nic_data = efx->nic_data;
b593b6f1b492170 Edward Cree    2020-08-03  609  	DECLARE_BITMAP(mask, EF100_STAT_COUNT) = {};
b593b6f1b492170 Edward Cree    2020-08-03  610  	u64 *stats = nic_data->stats;
b593b6f1b492170 Edward Cree    2020-08-03  611  
b593b6f1b492170 Edward Cree    2020-08-03  612  	ef100_common_stat_mask(mask);
b593b6f1b492170 Edward Cree    2020-08-03  613  	ef100_ethtool_stat_mask(mask);
b593b6f1b492170 Edward Cree    2020-08-03  614  
b593b6f1b492170 Edward Cree    2020-08-03  615  	efx_nic_copy_stats(efx, mc_stats);
b593b6f1b492170 Edward Cree    2020-08-03  616  	efx_nic_update_stats(ef100_stat_desc, EF100_STAT_COUNT, mask,
b593b6f1b492170 Edward Cree    2020-08-03  617  			     stats, mc_stats, false);
b593b6f1b492170 Edward Cree    2020-08-03  618  
b593b6f1b492170 Edward Cree    2020-08-03  619  	kfree(mc_stats);
b593b6f1b492170 Edward Cree    2020-08-03  620  
b593b6f1b492170 Edward Cree    2020-08-03  621  	return ef100_update_stats_common(efx, full_stats, core_stats);
b593b6f1b492170 Edward Cree    2020-08-03  622  }
b593b6f1b492170 Edward Cree    2020-08-03  623  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
