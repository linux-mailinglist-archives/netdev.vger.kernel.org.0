Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C71C577186
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 23:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiGPV2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 17:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGPV2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 17:28:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B918518C;
        Sat, 16 Jul 2022 14:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658006921; x=1689542921;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EEL23caroc+d4CCnU9uw3CMXv5macOIBlqJPu2/nrTM=;
  b=QQ5dCgU1GzsekqA+TB1CWpnOBRXVDmNIeidWOvwcDU2Q7QiH4FPV7Apu
   seaPGt5yQ35QB4Pp1nCydw1b/Tyxpgepx1IyN48NiMWMOqmA9PP68Ex5e
   GT1AHKwzqhLGJd9afNt94IkJ7+TN7x+rQNMc+JmKjp6cjNezIxqNXQPoI
   grnxp2TPI8UxAtK0BH0hI66iRGmOeGbfxvTJqs8WBvzP5eSD+GFTB6WP2
   9ItwccsQ8Ngvudfxlv1/7Bw4RZKiOxhyvdzdCwuxTc/BzC8yswXA37mI8
   L2M0m6F8qzZC5SJv8nOLnWOzdRQ6JH1IHBiIAdR0pX8NH2EvNwWxUdJ5y
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10410"; a="286743295"
X-IronPort-AV: E=Sophos;i="5.92,277,1650956400"; 
   d="scan'208";a="286743295"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2022 14:28:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,277,1650956400"; 
   d="scan'208";a="547047135"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 16 Jul 2022 14:28:37 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oCpL3-0002AQ-8W;
        Sat, 16 Jul 2022 21:28:37 +0000
Date:   Sun, 17 Jul 2022 05:27:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next v3 41/47] [RFT] net: dpaa: Convert to phylink
Message-ID: <202207170518.RygxqhFI-lkp@intel.com>
References: <20220715215954.1449214-42-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715215954.1449214-42-sean.anderson@seco.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Anderson/net-dpaa-Convert-to-phylink/20220717-002036
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 2acd1022549e210edc4cfc9fc65b07b88751f0d9
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220717/202207170518.RygxqhFI-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4411e66d2bb3fe21094f63ed67d2c2ebce69eaee
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Anderson/net-dpaa-Convert-to-phylink/20220717-002036
        git checkout 4411e66d2bb3fe21094f63ed67d2c2ebce69eaee
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash drivers/net/ethernet/freescale/fman/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/freescale/fman/fman_dtsec.c: In function 'init.constprop':
>> drivers/net/ethernet/freescale/fman/fman_dtsec.c:368:21: warning: 'tmp' is used uninitialized [-Wuninitialized]
     368 |                 tmp |= cfg->tx_pause_time;
         |                 ~~~~^~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/freescale/fman/fman_dtsec.c:360:13: note: 'tmp' was declared here
     360 |         u32 tmp;
         |             ^~~


vim +/tmp +368 drivers/net/ethernet/freescale/fman/fman_dtsec.c

6b995bdefc10b4 Madalin Bucur  2020-03-05  354  
57ba4c9b56d898 Igal Liberman  2015-12-21  355  static int init(struct dtsec_regs __iomem *regs, struct dtsec_cfg *cfg,
6b995bdefc10b4 Madalin Bucur  2020-03-05  356  		phy_interface_t iface, u16 iface_speed, u64 addr,
57ba4c9b56d898 Igal Liberman  2015-12-21  357  		u32 exception_mask, u8 tbi_addr)
57ba4c9b56d898 Igal Liberman  2015-12-21  358  {
6b995bdefc10b4 Madalin Bucur  2020-03-05  359  	enet_addr_t eth_addr;
57ba4c9b56d898 Igal Liberman  2015-12-21  360  	u32 tmp;
6b995bdefc10b4 Madalin Bucur  2020-03-05  361  	int i;
57ba4c9b56d898 Igal Liberman  2015-12-21  362  
57ba4c9b56d898 Igal Liberman  2015-12-21  363  	/* Soft reset */
57ba4c9b56d898 Igal Liberman  2015-12-21  364  	iowrite32be(MACCFG1_SOFT_RESET, &regs->maccfg1);
57ba4c9b56d898 Igal Liberman  2015-12-21  365  	iowrite32be(0, &regs->maccfg1);
57ba4c9b56d898 Igal Liberman  2015-12-21  366  
57ba4c9b56d898 Igal Liberman  2015-12-21  367  	if (cfg->tx_pause_time)
57ba4c9b56d898 Igal Liberman  2015-12-21 @368  		tmp |= cfg->tx_pause_time;
57ba4c9b56d898 Igal Liberman  2015-12-21  369  	if (cfg->tx_pause_time_extd)
57ba4c9b56d898 Igal Liberman  2015-12-21  370  		tmp |= cfg->tx_pause_time_extd << PTV_PTE_SHIFT;
57ba4c9b56d898 Igal Liberman  2015-12-21  371  	iowrite32be(tmp, &regs->ptv);
57ba4c9b56d898 Igal Liberman  2015-12-21  372  
57ba4c9b56d898 Igal Liberman  2015-12-21  373  	tmp = 0;
57ba4c9b56d898 Igal Liberman  2015-12-21  374  	tmp |= (cfg->rx_prepend << RCTRL_PAL_SHIFT) & RCTRL_PAL_MASK;
57ba4c9b56d898 Igal Liberman  2015-12-21  375  	/* Accept short frames */
57ba4c9b56d898 Igal Liberman  2015-12-21  376  	tmp |= RCTRL_RSF;
57ba4c9b56d898 Igal Liberman  2015-12-21  377  
57ba4c9b56d898 Igal Liberman  2015-12-21  378  	iowrite32be(tmp, &regs->rctrl);
57ba4c9b56d898 Igal Liberman  2015-12-21  379  
57ba4c9b56d898 Igal Liberman  2015-12-21  380  	/* Assign a Phy Address to the TBI (TBIPA).
57ba4c9b56d898 Igal Liberman  2015-12-21  381  	 * Done also in cases where TBI is not selected to avoid conflict with
57ba4c9b56d898 Igal Liberman  2015-12-21  382  	 * the external PHY's Physical address
57ba4c9b56d898 Igal Liberman  2015-12-21  383  	 */
57ba4c9b56d898 Igal Liberman  2015-12-21  384  	iowrite32be(tbi_addr, &regs->tbipa);
57ba4c9b56d898 Igal Liberman  2015-12-21  385  
57ba4c9b56d898 Igal Liberman  2015-12-21  386  	iowrite32be(0, &regs->tmr_ctrl);
57ba4c9b56d898 Igal Liberman  2015-12-21  387  
57ba4c9b56d898 Igal Liberman  2015-12-21  388  	if (cfg->ptp_tsu_en) {
57ba4c9b56d898 Igal Liberman  2015-12-21  389  		tmp = 0;
57ba4c9b56d898 Igal Liberman  2015-12-21  390  		tmp |= TMR_PEVENT_TSRE;
57ba4c9b56d898 Igal Liberman  2015-12-21  391  		iowrite32be(tmp, &regs->tmr_pevent);
57ba4c9b56d898 Igal Liberman  2015-12-21  392  
57ba4c9b56d898 Igal Liberman  2015-12-21  393  		if (cfg->ptp_exception_en) {
57ba4c9b56d898 Igal Liberman  2015-12-21  394  			tmp = 0;
57ba4c9b56d898 Igal Liberman  2015-12-21  395  			tmp |= TMR_PEMASK_TSREEN;
57ba4c9b56d898 Igal Liberman  2015-12-21  396  			iowrite32be(tmp, &regs->tmr_pemask);
57ba4c9b56d898 Igal Liberman  2015-12-21  397  		}
57ba4c9b56d898 Igal Liberman  2015-12-21  398  	}
57ba4c9b56d898 Igal Liberman  2015-12-21  399  
57ba4c9b56d898 Igal Liberman  2015-12-21  400  	tmp = 0;
57ba4c9b56d898 Igal Liberman  2015-12-21  401  	tmp |= MACCFG1_RX_FLOW;
57ba4c9b56d898 Igal Liberman  2015-12-21  402  	tmp |= MACCFG1_TX_FLOW;
57ba4c9b56d898 Igal Liberman  2015-12-21  403  	iowrite32be(tmp, &regs->maccfg1);
57ba4c9b56d898 Igal Liberman  2015-12-21  404  
57ba4c9b56d898 Igal Liberman  2015-12-21  405  	tmp = 0;
57ba4c9b56d898 Igal Liberman  2015-12-21  406  
57ba4c9b56d898 Igal Liberman  2015-12-21  407  	tmp |= (cfg->preamble_len << MACCFG2_PREAMBLE_LENGTH_SHIFT) &
57ba4c9b56d898 Igal Liberman  2015-12-21  408  		MACCFG2_PREAMBLE_LENGTH_MASK;
57ba4c9b56d898 Igal Liberman  2015-12-21  409  	if (cfg->tx_pad_crc)
57ba4c9b56d898 Igal Liberman  2015-12-21  410  		tmp |= MACCFG2_PAD_CRC_EN;
57ba4c9b56d898 Igal Liberman  2015-12-21  411  	iowrite32be(tmp, &regs->maccfg2);
57ba4c9b56d898 Igal Liberman  2015-12-21  412  
57ba4c9b56d898 Igal Liberman  2015-12-21  413  	tmp = (((cfg->non_back_to_back_ipg1 <<
57ba4c9b56d898 Igal Liberman  2015-12-21  414  		 IPGIFG_NON_BACK_TO_BACK_IPG_1_SHIFT)
57ba4c9b56d898 Igal Liberman  2015-12-21  415  		& IPGIFG_NON_BACK_TO_BACK_IPG_1)
57ba4c9b56d898 Igal Liberman  2015-12-21  416  	       | ((cfg->non_back_to_back_ipg2 <<
57ba4c9b56d898 Igal Liberman  2015-12-21  417  		   IPGIFG_NON_BACK_TO_BACK_IPG_2_SHIFT)
57ba4c9b56d898 Igal Liberman  2015-12-21  418  		 & IPGIFG_NON_BACK_TO_BACK_IPG_2)
57ba4c9b56d898 Igal Liberman  2015-12-21  419  	       | ((cfg->min_ifg_enforcement << IPGIFG_MIN_IFG_ENFORCEMENT_SHIFT)
57ba4c9b56d898 Igal Liberman  2015-12-21  420  		 & IPGIFG_MIN_IFG_ENFORCEMENT)
57ba4c9b56d898 Igal Liberman  2015-12-21  421  	       | (cfg->back_to_back_ipg & IPGIFG_BACK_TO_BACK_IPG));
57ba4c9b56d898 Igal Liberman  2015-12-21  422  	iowrite32be(tmp, &regs->ipgifg);
57ba4c9b56d898 Igal Liberman  2015-12-21  423  
57ba4c9b56d898 Igal Liberman  2015-12-21  424  	tmp = 0;
57ba4c9b56d898 Igal Liberman  2015-12-21  425  	tmp |= HAFDUP_EXCESS_DEFER;
57ba4c9b56d898 Igal Liberman  2015-12-21  426  	tmp |= ((cfg->halfdup_retransmit << HAFDUP_RETRANSMISSION_MAX_SHIFT)
57ba4c9b56d898 Igal Liberman  2015-12-21  427  		& HAFDUP_RETRANSMISSION_MAX);
57ba4c9b56d898 Igal Liberman  2015-12-21  428  	tmp |= (cfg->halfdup_coll_window & HAFDUP_COLLISION_WINDOW);
57ba4c9b56d898 Igal Liberman  2015-12-21  429  
57ba4c9b56d898 Igal Liberman  2015-12-21  430  	iowrite32be(tmp, &regs->hafdup);
57ba4c9b56d898 Igal Liberman  2015-12-21  431  
57ba4c9b56d898 Igal Liberman  2015-12-21  432  	/* Initialize Maximum frame length */
57ba4c9b56d898 Igal Liberman  2015-12-21  433  	iowrite32be(cfg->maximum_frame, &regs->maxfrm);
57ba4c9b56d898 Igal Liberman  2015-12-21  434  
57ba4c9b56d898 Igal Liberman  2015-12-21  435  	iowrite32be(0xffffffff, &regs->cam1);
57ba4c9b56d898 Igal Liberman  2015-12-21  436  	iowrite32be(0xffffffff, &regs->cam2);
57ba4c9b56d898 Igal Liberman  2015-12-21  437  
57ba4c9b56d898 Igal Liberman  2015-12-21  438  	iowrite32be(exception_mask, &regs->imask);
57ba4c9b56d898 Igal Liberman  2015-12-21  439  
57ba4c9b56d898 Igal Liberman  2015-12-21  440  	iowrite32be(0xffffffff, &regs->ievent);
57ba4c9b56d898 Igal Liberman  2015-12-21  441  
f3353b99022583 Madalin Bucur  2020-03-05  442  	if (addr) {
6b995bdefc10b4 Madalin Bucur  2020-03-05  443  		MAKE_ENET_ADDR_FROM_UINT64(addr, eth_addr);
766607570becbd Jakub Kicinski 2021-10-14  444  		set_mac_address(regs, (const u8 *)eth_addr);
f3353b99022583 Madalin Bucur  2020-03-05  445  	}
57ba4c9b56d898 Igal Liberman  2015-12-21  446  
57ba4c9b56d898 Igal Liberman  2015-12-21  447  	/* HASH */
57ba4c9b56d898 Igal Liberman  2015-12-21  448  	for (i = 0; i < NUM_OF_HASH_REGS; i++) {
57ba4c9b56d898 Igal Liberman  2015-12-21  449  		/* Initialize IADDRx */
57ba4c9b56d898 Igal Liberman  2015-12-21  450  		iowrite32be(0, &regs->igaddr[i]);
57ba4c9b56d898 Igal Liberman  2015-12-21  451  		/* Initialize GADDRx */
57ba4c9b56d898 Igal Liberman  2015-12-21  452  		iowrite32be(0, &regs->gaddr[i]);
57ba4c9b56d898 Igal Liberman  2015-12-21  453  	}
57ba4c9b56d898 Igal Liberman  2015-12-21  454  
57ba4c9b56d898 Igal Liberman  2015-12-21  455  	return 0;
57ba4c9b56d898 Igal Liberman  2015-12-21  456  }
57ba4c9b56d898 Igal Liberman  2015-12-21  457  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
