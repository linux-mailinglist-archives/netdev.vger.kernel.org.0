Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE3C6865C7
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjBAMOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjBAMOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:14:32 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451D14AA5E;
        Wed,  1 Feb 2023 04:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675253670; x=1706789670;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cE+cLNAyV4b6aq/dBlGT8jrUCZO9/iBOFhYmJ4u2C1I=;
  b=VIvZ4chBjeeY4EjIEXZOAYxo9iEZO5iDrRIHouWVQE9r5jQKlz8fyp1j
   pLcTMxsbjqjjKdp0L3b3Qa4v6Yj5O1ec8Yc5sODCElqwy4nh5d05xDGww
   Ra0lJw4BAfRKd/JMAEqQyYQPZKSoGMFuetO+Ko+RzbuyBSrncF5KvFOQ3
   yJFoI+mKr7ARlED2DkGaMTwtEJG5NcgIR5CzO1EWWsXC91nDN/a5oYhAI
   u9Cjh++pdHI8MqJ9MBt6eeYaH6kYFuYc0DGCHBLnRctZ+MWna7aHSTQ6u
   oLTuGgjKqeFay2clQatz3R5kzmw6SFTW+JIMQKl41QdLAdm7EBKUO/J3s
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="325826425"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="325826425"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 04:14:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="993670359"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="993670359"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2023 04:14:25 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNC0O-0005Po-2x;
        Wed, 01 Feb 2023 12:14:24 +0000
Date:   Wed, 1 Feb 2023 20:14:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Clark Wang <xiaoning.wang@nxp.com>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V2 1/2] net: phylink: add a function to resume phy alone
 to fix resume issue with WoL enabled
Message-ID: <202302012009.TmS9IEE9-lkp@intel.com>
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
[also build test WARNING on net/master linus/master v6.2-rc6 next-20230201]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Clark-Wang/net-stmmac-resume-phy-separately-before-calling-stmmac_hw_setup/20230201-184223
patch link:    https://lore.kernel.org/r/20230201103837.3258752-1-xiaoning.wang%40nxp.com
patch subject: [PATCH V2 1/2] net: phylink: add a function to resume phy alone to fix resume issue with WoL enabled
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230201/202302012009.TmS9IEE9-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6df0562fc6133175ff3932188af0d9126858c42c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Clark-Wang/net-stmmac-resume-phy-separately-before-calling-stmmac_hw_setup/20230201-184223
        git checkout 6df0562fc6133175ff3932188af0d9126858c42c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/phy/phylink.c: In function 'phylink_start':
>> drivers/net/phy/phylink.c:1949:12: warning: suggest explicit braces to avoid ambiguous 'else' [-Wdangling-else]
    1949 |         if (pl->phydev)
         |            ^


vim +/else +1949 drivers/net/phy/phylink.c

7b3b0e89bcf3ac Russell King   2019-05-28  1887  
8796c8923d9c42 Russell King   2017-12-01  1888  /**
8796c8923d9c42 Russell King   2017-12-01  1889   * phylink_start() - start a phylink instance
8796c8923d9c42 Russell King   2017-12-01  1890   * @pl: a pointer to a &struct phylink returned from phylink_create()
8796c8923d9c42 Russell King   2017-12-01  1891   *
8796c8923d9c42 Russell King   2017-12-01  1892   * Start the phylink instance specified by @pl, configuring the MAC for the
8796c8923d9c42 Russell King   2017-12-01  1893   * desired link mode(s) and negotiation style. This should be called from the
8796c8923d9c42 Russell King   2017-12-01  1894   * network device driver's &struct net_device_ops ndo_open() method.
8796c8923d9c42 Russell King   2017-12-01  1895   */
9525ae83959b60 Russell King   2017-07-25  1896  void phylink_start(struct phylink *pl)
9525ae83959b60 Russell King   2017-07-25  1897  {
5c05c1dbb17729 Russell King   2020-04-23  1898  	bool poll = false;
5c05c1dbb17729 Russell King   2020-04-23  1899  
8b874514c11d6f Russell King   2017-12-15  1900  	ASSERT_RTNL();
9525ae83959b60 Russell King   2017-07-25  1901  
17091180b1521e Ioana Ciornei  2019-05-28  1902  	phylink_info(pl, "configuring for %s/%s link mode\n",
24cf0e693bb50a Russell King   2019-12-11  1903  		     phylink_an_mode_str(pl->cur_link_an_mode),
9525ae83959b60 Russell King   2017-07-25  1904  		     phy_modes(pl->link_config.interface));
9525ae83959b60 Russell King   2017-07-25  1905  
aeeb2e8fdefdd5 Antoine Tenart 2018-09-19  1906  	/* Always set the carrier off */
43de61959b9992 Ioana Ciornei  2019-05-28  1907  	if (pl->netdev)
aeeb2e8fdefdd5 Antoine Tenart 2018-09-19  1908  		netif_carrier_off(pl->netdev);
aeeb2e8fdefdd5 Antoine Tenart 2018-09-19  1909  
9525ae83959b60 Russell King   2017-07-25  1910  	/* Apply the link configuration to the MAC when starting. This allows
9525ae83959b60 Russell King   2017-07-25  1911  	 * a fixed-link to start with the correct parameters, and also
cc1122b00d624e Colin Ian King 2018-03-01  1912  	 * ensures that we set the appropriate advertisement for Serdes links.
4c0d6d3a7a81fc Russell King   2020-03-30  1913  	 *
4c0d6d3a7a81fc Russell King   2020-03-30  1914  	 * Restart autonegotiation if using 802.3z to ensure that the link
85b43945cf7587 Russell King   2017-12-01  1915  	 * parameters are properly negotiated.  This is necessary for DSA
85b43945cf7587 Russell King   2017-12-01  1916  	 * switches using 802.3z negotiation to ensure they see our modes.
85b43945cf7587 Russell King   2017-12-01  1917  	 */
4c0d6d3a7a81fc Russell King   2020-03-30  1918  	phylink_mac_initial_config(pl, true);
85b43945cf7587 Russell King   2017-12-01  1919  
aa729c439441aa Russell King   2021-11-30  1920  	phylink_enable_and_run_resolve(pl, PHYLINK_DISABLE_STOPPED);
9525ae83959b60 Russell King   2017-07-25  1921  
24cf0e693bb50a Russell King   2019-12-11  1922  	if (pl->cfg_link_an_mode == MLO_AN_FIXED && pl->link_gpio) {
7b3b0e89bcf3ac Russell King   2019-05-28  1923  		int irq = gpiod_to_irq(pl->link_gpio);
7b3b0e89bcf3ac Russell King   2019-05-28  1924  
7b3b0e89bcf3ac Russell King   2019-05-28  1925  		if (irq > 0) {
7b3b0e89bcf3ac Russell King   2019-05-28  1926  			if (!request_irq(irq, phylink_link_handler,
7b3b0e89bcf3ac Russell King   2019-05-28  1927  					 IRQF_TRIGGER_RISING |
7b3b0e89bcf3ac Russell King   2019-05-28  1928  					 IRQF_TRIGGER_FALLING,
7b3b0e89bcf3ac Russell King   2019-05-28  1929  					 "netdev link", pl))
7b3b0e89bcf3ac Russell King   2019-05-28  1930  				pl->link_irq = irq;
7b3b0e89bcf3ac Russell King   2019-05-28  1931  			else
7b3b0e89bcf3ac Russell King   2019-05-28  1932  				irq = 0;
7b3b0e89bcf3ac Russell King   2019-05-28  1933  		}
7b3b0e89bcf3ac Russell King   2019-05-28  1934  		if (irq <= 0)
5c05c1dbb17729 Russell King   2020-04-23  1935  			poll = true;
5c05c1dbb17729 Russell King   2020-04-23  1936  	}
5c05c1dbb17729 Russell King   2020-04-23  1937  
5c05c1dbb17729 Russell King   2020-04-23  1938  	switch (pl->cfg_link_an_mode) {
5c05c1dbb17729 Russell King   2020-04-23  1939  	case MLO_AN_FIXED:
5c05c1dbb17729 Russell King   2020-04-23  1940  		poll |= pl->config->poll_fixed_state;
5c05c1dbb17729 Russell King   2020-04-23  1941  		break;
5c05c1dbb17729 Russell King   2020-04-23  1942  	case MLO_AN_INBAND:
7137e18f6f889a Russell King   2020-07-21  1943  		if (pl->pcs)
7137e18f6f889a Russell King   2020-07-21  1944  			poll |= pl->pcs->poll;
5c05c1dbb17729 Russell King   2020-04-23  1945  		break;
7b3b0e89bcf3ac Russell King   2019-05-28  1946  	}
5c05c1dbb17729 Russell King   2020-04-23  1947  	if (poll)
9cd00a8aa42e44 Russell King   2018-05-10  1948  		mod_timer(&pl->link_poll, jiffies + HZ);
9525ae83959b60 Russell King   2017-07-25 @1949  	if (pl->phydev)
6df0562fc61331 Clark Wang     2023-02-01  1950  		if (!pl->mac_resume_phy_separately)
9525ae83959b60 Russell King   2017-07-25  1951  			phy_start(pl->phydev);
6df0562fc61331 Clark Wang     2023-02-01  1952  		else
6df0562fc61331 Clark Wang     2023-02-01  1953  			pl->mac_resume_phy_separately = false;
c7fa7f567cab65 Arseny Solokha 2019-07-24  1954  	if (pl->sfp_bus)
c7fa7f567cab65 Arseny Solokha 2019-07-24  1955  		sfp_upstream_start(pl->sfp_bus);
9525ae83959b60 Russell King   2017-07-25  1956  }
9525ae83959b60 Russell King   2017-07-25  1957  EXPORT_SYMBOL_GPL(phylink_start);
9525ae83959b60 Russell King   2017-07-25  1958  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
