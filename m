Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77A06CB1DD
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 00:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjC0Wjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 18:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjC0Wjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 18:39:42 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F6A1BD1;
        Mon, 27 Mar 2023 15:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679956781; x=1711492781;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jw64NH9VCniTv6ZR3b7VgSIWKTfRI77qXUm0pHRQSQ0=;
  b=VWl/td5ddrvr5+saf3tWVNst+2QrcaRRf4vj4AaI2TcYWrplF8hLpchf
   /n+Fb06gYewrKr/wsDaRHzDwayERkGSRqLsQ0wWngwOJ06io1fJf+yh6h
   wNpzDzeav/8eqsugpPhisGflcGL3QwPu+oyZu691bsZPA18O7JNjHgTJ8
   ir6Iv7YS13uv/N8WQk5HGtFhZ6pqD3t5CW6sWwEaz0zttJ6ZFVmJQLHf0
   YVMYqt4zArVxqu2KvNNOSr4Z+f+86d3ZaILMu/AZt0J+wBwdm3Z3GEhMB
   l1Y+JCfVyzlWx1mV/y8CGIylPtDiv3twAHDeRmm6MyaF3NxUgZoMl+9L3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="328853604"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="328853604"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 15:39:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="827218608"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="827218608"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 27 Mar 2023 15:39:37 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pgvV2-000I4F-2w;
        Mon, 27 Mar 2023 22:39:36 +0000
Date:   Tue, 28 Mar 2023 06:39:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Harini Katakam <harini.katakam@amd.com>,
        nicolas.ferre@microchip.com, davem@davemloft.net,
        richardcochran@gmail.com, claudiu.beznea@microchip.com,
        andrei.pistirica@microchip.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@amd.com, harinikatakamlinux@gmail.com,
        harini.katakam@amd.com
Subject: Re: [PATCH net-next v3 1/3] net: macb: Update gem PTP support check
Message-ID: <202303280600.LarprmhI-lkp@intel.com>
References: <20230327110607.21964-2-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327110607.21964-2-harini.katakam@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harini,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Harini-Katakam/net-macb-Update-gem-PTP-support-check/20230327-190937
patch link:    https://lore.kernel.org/r/20230327110607.21964-2-harini.katakam%40amd.com
patch subject: [PATCH net-next v3 1/3] net: macb: Update gem PTP support check
config: powerpc-randconfig-r021-20230327 (https://download.01.org/0day-ci/archive/20230328/202303280600.LarprmhI-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install powerpc cross compiling tool for clang build
        # apt-get install binutils-powerpc-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/0a2f03b6a91caa746dfd1b56b998534464dae83d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Harini-Katakam/net-macb-Update-gem-PTP-support-check/20230327-190937
        git checkout 0a2f03b6a91caa746dfd1b56b998534464dae83d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=powerpc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash drivers/net/ethernet/cadence/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303280600.LarprmhI-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/cadence/macb_main.c:3897:9: error: no member named 'hw_dma_cap' in 'struct macb'
                                   bp->hw_dma_cap |= HW_DMA_CAP_PTP;
                                   ~~  ^
>> drivers/net/ethernet/cadence/macb_main.c:3897:23: error: use of undeclared identifier 'HW_DMA_CAP_PTP'
                                   bp->hw_dma_cap |= HW_DMA_CAP_PTP;
                                                     ^
>> drivers/net/ethernet/cadence/macb_main.c:3898:21: error: use of undeclared identifier 'gem_ptp_info'; did you mean 'gem_ptp_init'?
                                   bp->ptp_info = &gem_ptp_info;
                                                   ^~~~~~~~~~~~
                                                   gem_ptp_init
   drivers/net/ethernet/cadence/macb.h:1352:20: note: 'gem_ptp_init' declared here
   static inline void gem_ptp_init(struct net_device *ndev) { }
                      ^
   3 errors generated.


vim +3897 drivers/net/ethernet/cadence/macb_main.c

5f1fa992382cf8 drivers/net/macb.c                       Alexander Beregalov 2009-04-11  3866  
64ec42fe272322 drivers/net/ethernet/cadence/macb.c      Moritz Fischer      2016-03-29  3867  /* Configure peripheral capabilities according to device tree
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3868   * and integration options used
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3869   */
64ec42fe272322 drivers/net/ethernet/cadence/macb.c      Moritz Fischer      2016-03-29  3870  static void macb_configure_caps(struct macb *bp,
64ec42fe272322 drivers/net/ethernet/cadence/macb.c      Moritz Fischer      2016-03-29  3871  				const struct macb_config *dt_conf)
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3872  {
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3873  	u32 dcfg;
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3874  
f6970505defd0e drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2015-03-31  3875  	if (dt_conf)
f6970505defd0e drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2015-03-31  3876  		bp->caps = dt_conf->caps;
f6970505defd0e drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2015-03-31  3877  
f2ce8a9e48385f drivers/net/ethernet/cadence/macb.c      Andy Shevchenko     2015-07-24  3878  	if (hw_is_gem(bp->regs, bp->native_io)) {
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3879  		bp->caps |= MACB_CAPS_MACB_IS_GEM;
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3880  
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3881  		dcfg = gem_readl(bp, DCFG1);
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3882  		if (GEM_BFEXT(IRQCOR, dcfg) == 0)
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3883  			bp->caps |= MACB_CAPS_ISR_CLEAR_ON_WRITE;
e4e143e26ce8f5 drivers/net/ethernet/cadence/macb_main.c Parshuram Thombare  2020-10-29  3884  		if (GEM_BFEXT(NO_PCS, dcfg) == 0)
e4e143e26ce8f5 drivers/net/ethernet/cadence/macb_main.c Parshuram Thombare  2020-10-29  3885  			bp->caps |= MACB_CAPS_PCS;
e4e143e26ce8f5 drivers/net/ethernet/cadence/macb_main.c Parshuram Thombare  2020-10-29  3886  		dcfg = gem_readl(bp, DCFG12);
e4e143e26ce8f5 drivers/net/ethernet/cadence/macb_main.c Parshuram Thombare  2020-10-29  3887  		if (GEM_BFEXT(HIGH_SPEED, dcfg) == 1)
e4e143e26ce8f5 drivers/net/ethernet/cadence/macb_main.c Parshuram Thombare  2020-10-29  3888  			bp->caps |= MACB_CAPS_HIGH_SPEED;
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3889  		dcfg = gem_readl(bp, DCFG2);
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3890  		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3891  			bp->caps |= MACB_CAPS_FIFO_MODE;
ab91f0a9b5f4b9 drivers/net/ethernet/cadence/macb_main.c Rafal Ozieblo       2017-06-29  3892  		if (gem_has_ptp(bp)) {
7b4296148066f1 drivers/net/ethernet/cadence/macb.c      Rafal Ozieblo       2017-06-29  3893  			if (!GEM_BFEXT(TSU, gem_readl(bp, DCFG5)))
7897b071ac3b45 drivers/net/ethernet/cadence/macb_main.c Antoine Tenart      2019-11-13  3894  				dev_err(&bp->pdev->dev,
7897b071ac3b45 drivers/net/ethernet/cadence/macb_main.c Antoine Tenart      2019-11-13  3895  					"GEM doesn't support hardware ptp.\n");
ab91f0a9b5f4b9 drivers/net/ethernet/cadence/macb_main.c Rafal Ozieblo       2017-06-29  3896  			else {
7b4296148066f1 drivers/net/ethernet/cadence/macb.c      Rafal Ozieblo       2017-06-29 @3897  				bp->hw_dma_cap |= HW_DMA_CAP_PTP;
ab91f0a9b5f4b9 drivers/net/ethernet/cadence/macb_main.c Rafal Ozieblo       2017-06-29 @3898  				bp->ptp_info = &gem_ptp_info;
7b4296148066f1 drivers/net/ethernet/cadence/macb.c      Rafal Ozieblo       2017-06-29  3899  			}
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3900  		}
ab91f0a9b5f4b9 drivers/net/ethernet/cadence/macb_main.c Rafal Ozieblo       2017-06-29  3901  	}
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3902  
a35919e174350d drivers/net/ethernet/cadence/macb.c      Andy Shevchenko     2015-07-24  3903  	dev_dbg(&bp->pdev->dev, "Cadence caps 0x%08x\n", bp->caps);
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3904  }
e175587f4d32de drivers/net/ethernet/cadence/macb.c      Nicolas Ferre       2014-07-24  3905  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
