Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5546C687D50
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjBBM1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjBBM1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:27:43 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57EB8BDD8;
        Thu,  2 Feb 2023 04:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675340860; x=1706876860;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w2lVTIW1/udEtdMV6XUbh7yDPvBpVMFqx5/NHCHIrmI=;
  b=B2XXZvUOUMBS5mIUcNHvnDQnuGA0klvDEKPSzLOg+8v+wQRT9tUYWbRs
   +zCamsLdnLyWycBrhrUTr7oDxKieIUYUHiNWXr7vEbuzJeULzFMPDh49H
   buhiWGGFWZxob8QPBc286CaeXr16k76Xhd17aWlpQau2LNRQZb9r/5M/Y
   szi4gBgoQiRaadD02dLVLrSfYKnPsZ6UG3Xgu7I9OlUxCsGggO2gaNIVs
   Kcz3sISvs4bqWYd8602n9r26IH3gcBNStAx5HpjBuSITf29hxSSnVuqjN
   jGSeto4MbX4q35DcXXrwCGoqCB7LJkr1fyi1aQNXN6GRVCPDa0r5vzPKn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="328448106"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="328448106"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 04:27:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="733916022"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="733916022"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 02 Feb 2023 04:27:35 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNYgb-0006Us-1Y;
        Thu, 02 Feb 2023 12:27:29 +0000
Date:   Thu, 2 Feb 2023 20:26:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Clark Wang <xiaoning.wang@nxp.com>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V2 1/2] net: phylink: add a function to resume phy alone
 to fix resume issue with WoL enabled
Message-ID: <202302022040.NzeFwwSF-lkp@intel.com>
References: <20230201103837.3258752-1-xiaoning.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201103837.3258752-1-xiaoning.wang@nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clark,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master linus/master v6.2-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Clark-Wang/net-stmmac-resume-phy-separately-before-calling-stmmac_hw_setup/20230201-184223
patch link:    https://lore.kernel.org/r/20230201103837.3258752-1-xiaoning.wang%40nxp.com
patch subject: [PATCH V2 1/2] net: phylink: add a function to resume phy alone to fix resume issue with WoL enabled
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20230202/202302022040.NzeFwwSF-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6df0562fc6133175ff3932188af0d9126858c42c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Clark-Wang/net-stmmac-resume-phy-separately-before-calling-stmmac_hw_setup/20230201-184223
        git checkout 6df0562fc6133175ff3932188af0d9126858c42c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/phy/ kernel/bpf/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/phy/phylink.c:1952:3: warning: add explicit braces to avoid dangling else [-Wdangling-else]
                   else
                   ^
   1 warning generated.


vim +1952 drivers/net/phy/phylink.c

  1887	
  1888	/**
  1889	 * phylink_start() - start a phylink instance
  1890	 * @pl: a pointer to a &struct phylink returned from phylink_create()
  1891	 *
  1892	 * Start the phylink instance specified by @pl, configuring the MAC for the
  1893	 * desired link mode(s) and negotiation style. This should be called from the
  1894	 * network device driver's &struct net_device_ops ndo_open() method.
  1895	 */
  1896	void phylink_start(struct phylink *pl)
  1897	{
  1898		bool poll = false;
  1899	
  1900		ASSERT_RTNL();
  1901	
  1902		phylink_info(pl, "configuring for %s/%s link mode\n",
  1903			     phylink_an_mode_str(pl->cur_link_an_mode),
  1904			     phy_modes(pl->link_config.interface));
  1905	
  1906		/* Always set the carrier off */
  1907		if (pl->netdev)
  1908			netif_carrier_off(pl->netdev);
  1909	
  1910		/* Apply the link configuration to the MAC when starting. This allows
  1911		 * a fixed-link to start with the correct parameters, and also
  1912		 * ensures that we set the appropriate advertisement for Serdes links.
  1913		 *
  1914		 * Restart autonegotiation if using 802.3z to ensure that the link
  1915		 * parameters are properly negotiated.  This is necessary for DSA
  1916		 * switches using 802.3z negotiation to ensure they see our modes.
  1917		 */
  1918		phylink_mac_initial_config(pl, true);
  1919	
  1920		phylink_enable_and_run_resolve(pl, PHYLINK_DISABLE_STOPPED);
  1921	
  1922		if (pl->cfg_link_an_mode == MLO_AN_FIXED && pl->link_gpio) {
  1923			int irq = gpiod_to_irq(pl->link_gpio);
  1924	
  1925			if (irq > 0) {
  1926				if (!request_irq(irq, phylink_link_handler,
  1927						 IRQF_TRIGGER_RISING |
  1928						 IRQF_TRIGGER_FALLING,
  1929						 "netdev link", pl))
  1930					pl->link_irq = irq;
  1931				else
  1932					irq = 0;
  1933			}
  1934			if (irq <= 0)
  1935				poll = true;
  1936		}
  1937	
  1938		switch (pl->cfg_link_an_mode) {
  1939		case MLO_AN_FIXED:
  1940			poll |= pl->config->poll_fixed_state;
  1941			break;
  1942		case MLO_AN_INBAND:
  1943			if (pl->pcs)
  1944				poll |= pl->pcs->poll;
  1945			break;
  1946		}
  1947		if (poll)
  1948			mod_timer(&pl->link_poll, jiffies + HZ);
  1949		if (pl->phydev)
  1950			if (!pl->mac_resume_phy_separately)
  1951				phy_start(pl->phydev);
> 1952			else
  1953				pl->mac_resume_phy_separately = false;
  1954		if (pl->sfp_bus)
  1955			sfp_upstream_start(pl->sfp_bus);
  1956	}
  1957	EXPORT_SYMBOL_GPL(phylink_start);
  1958	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
