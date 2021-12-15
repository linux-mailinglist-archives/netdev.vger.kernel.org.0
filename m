Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5785475D7F
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 17:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244858AbhLOQd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 11:33:59 -0500
Received: from mga18.intel.com ([134.134.136.126]:6801 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244873AbhLOQd6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 11:33:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639586038; x=1671122038;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xVwV5bDwNAHd5wvevs2R/tBM06hGD6mjpwxu1vCLbVw=;
  b=hApAc/F1KjLouLmes3JAa5pCHreU681+hgSnTaNby0GX8u5gCtJVVSgu
   CHwCnjjDwJ4bNEzlNNZEJiAd7iuWfw26OoSoU15GI2YJNHLjS0tIxKYLU
   UPS5TfpO/9cvuwbpFpHnHasGKSj+VTMPy70XXhFkLuyCzj6MNISJ5OkUb
   m17x+ryq688FnRL96+yI0x9zyCTzEtfcxza2/hvfvCzv313S2p0pgOuY8
   /hy70SaGgFVuqpkfwPaZMpjSIFSFtwDqEDT8PhozHMjYkZ9w4A1h9TTeK
   znAIIDbkbJ2Tsa0rTY76U7WtzrPdkutWQDNNjSjhoiaLi7QZc0pwbw72q
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226124334"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="226124334"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 08:28:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="464325693"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 15 Dec 2021 08:28:07 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mxX8Q-00022W-7S; Wed, 15 Dec 2021 16:28:06 +0000
Date:   Thu, 16 Dec 2021 00:27:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: [PATCH] sfc_ef100: potential dereference of null pointer
Message-ID: <202112160025.8uELAreL-lkp@intel.com>
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
config: arm64-randconfig-r021-20211214 (https://download.01.org/0day-ci/archive/20211216/202112160025.8uELAreL-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project dd245bab9fbb364faa1581e4f92ba3119a872fba)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/0day-ci/linux/commit/fc56ac03164889a206ee1b65187a8be7aa7b0f04
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jiasheng-Jiang/sfc_ef100-potential-dereference-of-null-pointer/20211215-174422
        git checkout fc56ac03164889a206ee1b65187a8be7aa7b0f04
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/net/ethernet/sfc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/sfc/ef100_nic.c:608:25: warning: ISO C90 forbids mixing declarations and code [-Wdeclaration-after-statement]
           struct ef100_nic_data *nic_data = efx->nic_data;
                                  ^
   1 warning generated.


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
