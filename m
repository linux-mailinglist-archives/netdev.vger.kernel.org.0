Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EAA598C95
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345559AbiHRTcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343991AbiHRTcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:32:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE403CD500;
        Thu, 18 Aug 2022 12:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660851128; x=1692387128;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j5aa8Bz4WTZLjYv/eCo4jooseNT5Z+r4Y3IYqy1YzIw=;
  b=cRi6oNh37bIKtP3fZauO/qFjQ9hz95ggb0D02PDZaDtLo4ti1w6BbTH/
   7qK9WBdpAGAy3G6Fy62sb/5XbWLClZZAPdk49jT0n78ZmVUjUuXzZCo81
   xMwEy2o4Y+dA6B1imFY767yy1+bg4mYWz+yv/mHasFpOPg8IaGoBll3it
   Dzb5tBf+GzBrUo9LCTgkGnL43PIuuT1/cnt9hpIujcOt9f1+cmVTodQsJ
   aDunEZ3ifepaLpLtI7dRv7FgESg5m464RJZH+WyAi8s22oZN1vJUMv8+Y
   vOJLxN5n1uy9XYjsu+gr0L/5SQBoVhnYJHIlk4OWZJVZsWTfk0YXnILjg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="292852561"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="292852561"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 12:32:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="783891296"
Received: from lkp-server01.sh.intel.com (HELO 44b6dac04a33) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 18 Aug 2022 12:32:04 -0700
Received: from kbuild by 44b6dac04a33 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oOlFM-0000T9-0S;
        Thu, 18 Aug 2022 19:32:04 +0000
Date:   Fri, 19 Aug 2022 03:31:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next v4 08/10] net: phylink: Adjust advertisement
 based on rate adaptation
Message-ID: <202208190347.I3rrGqW3-lkp@intel.com>
References: <20220818164616.2064242-9-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818164616.2064242-9-sean.anderson@seco.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Anderson/net-phy-Add-support-for-rate-adaptation/20220819-005121
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git e34cfee65ec891a319ce79797dda18083af33a76
config: arm-randconfig-r026-20220818 (https://download.01.org/0day-ci/archive/20220819/202208190347.I3rrGqW3-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project aed5e3bea138ce581d682158eb61c27b3cfdd6ec)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/f4857d8d4f852b1cc3ae278785c209a7a0da0f67
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Anderson/net-phy-Add-support-for-rate-adaptation/20220819-005121
        git checkout f4857d8d4f852b1cc3ae278785c209a7a0da0f67
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/net/phy/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/phy/phylink.c:543:7: error: call to undeclared function 'phylink_cap_from_speed_duplex'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                       phylink_cap_from_speed_duplex(max_speed, DUPLEX_FULL)) {
                       ^
   drivers/net/phy/phylink.c:559:7: error: call to undeclared function 'phylink_cap_from_speed_duplex'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                       phylink_cap_from_speed_duplex(max_speed, DUPLEX_HALF)) {
                       ^
   2 errors generated.


vim +/phylink_cap_from_speed_duplex +543 drivers/net/phy/phylink.c

   431	
   432	/**
   433	 * phylink_get_capabilities() - get capabilities for a given MAC
   434	 * @interface: phy interface mode defined by &typedef phy_interface_t
   435	 * @mac_capabilities: bitmask of MAC capabilities
   436	 * @rate_adaptation: type of rate adaptation being performed
   437	 *
   438	 * Get the MAC capabilities that are supported by the @interface mode and
   439	 * @mac_capabilities.
   440	 */
   441	unsigned long phylink_get_capabilities(phy_interface_t interface,
   442					       unsigned long mac_capabilities,
   443					       int rate_adaptation)
   444	{
   445		int max_speed = phylink_interface_max_speed(interface);
   446		unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
   447		unsigned long adapted_caps = 0;
   448	
   449		switch (interface) {
   450		case PHY_INTERFACE_MODE_USXGMII:
   451			caps |= MAC_10000FD | MAC_5000FD | MAC_2500FD;
   452			fallthrough;
   453	
   454		case PHY_INTERFACE_MODE_RGMII_TXID:
   455		case PHY_INTERFACE_MODE_RGMII_RXID:
   456		case PHY_INTERFACE_MODE_RGMII_ID:
   457		case PHY_INTERFACE_MODE_RGMII:
   458		case PHY_INTERFACE_MODE_QSGMII:
   459		case PHY_INTERFACE_MODE_SGMII:
   460		case PHY_INTERFACE_MODE_GMII:
   461			caps |= MAC_1000HD | MAC_1000FD;
   462			fallthrough;
   463	
   464		case PHY_INTERFACE_MODE_REVRMII:
   465		case PHY_INTERFACE_MODE_RMII:
   466		case PHY_INTERFACE_MODE_SMII:
   467		case PHY_INTERFACE_MODE_REVMII:
   468		case PHY_INTERFACE_MODE_MII:
   469			caps |= MAC_10HD | MAC_10FD;
   470			fallthrough;
   471	
   472		case PHY_INTERFACE_MODE_100BASEX:
   473			caps |= MAC_100HD | MAC_100FD;
   474			break;
   475	
   476		case PHY_INTERFACE_MODE_TBI:
   477		case PHY_INTERFACE_MODE_MOCA:
   478		case PHY_INTERFACE_MODE_RTBI:
   479		case PHY_INTERFACE_MODE_1000BASEX:
   480			caps |= MAC_1000HD;
   481			fallthrough;
   482		case PHY_INTERFACE_MODE_1000BASEKX:
   483		case PHY_INTERFACE_MODE_TRGMII:
   484			caps |= MAC_1000FD;
   485			break;
   486	
   487		case PHY_INTERFACE_MODE_2500BASEX:
   488			caps |= MAC_2500FD;
   489			break;
   490	
   491		case PHY_INTERFACE_MODE_5GBASER:
   492			caps |= MAC_5000FD;
   493			break;
   494	
   495		case PHY_INTERFACE_MODE_XGMII:
   496		case PHY_INTERFACE_MODE_RXAUI:
   497		case PHY_INTERFACE_MODE_XAUI:
   498		case PHY_INTERFACE_MODE_10GBASER:
   499		case PHY_INTERFACE_MODE_10GKR:
   500			caps |= MAC_10000FD;
   501			break;
   502	
   503		case PHY_INTERFACE_MODE_25GBASER:
   504			caps |= MAC_25000FD;
   505			break;
   506	
   507		case PHY_INTERFACE_MODE_XLGMII:
   508			caps |= MAC_40000FD;
   509			break;
   510	
   511		case PHY_INTERFACE_MODE_INTERNAL:
   512			caps |= ~0;
   513			break;
   514	
   515		case PHY_INTERFACE_MODE_NA:
   516		case PHY_INTERFACE_MODE_MAX:
   517			break;
   518		}
   519	
   520		switch (rate_adaptation) {
   521		case RATE_ADAPT_OPEN_LOOP:
   522			/* TODO */
   523			fallthrough;
   524		case RATE_ADAPT_NONE:
   525			adapted_caps = 0;
   526			break;
   527		case RATE_ADAPT_PAUSE: {
   528			/* The MAC must support asymmetric pause towards the local
   529			 * device for this. We could allow just symmetric pause, but
   530			 * then we might have to renegotiate if the link partner
   531			 * doesn't support pause. This is because there's no way to
   532			 * accept pause frames without transmitting them if we only
   533			 * support symmetric pause.
   534			 */
   535			if (!(mac_capabilities & MAC_SYM_PAUSE) ||
   536			    !(mac_capabilities & MAC_ASYM_PAUSE))
   537				break;
   538	
   539			/* We can't adapt if the MAC doesn't support the interface's
   540			 * max speed at full duplex.
   541			 */
   542			if (mac_capabilities &
 > 543			    phylink_cap_from_speed_duplex(max_speed, DUPLEX_FULL)) {
   544				/* Although a duplex-adapting phy might exist, we
   545				 * conservatively remove these modes because the MAC
   546				 * will not be aware of the half-duplex nature of the
   547				 * link.
   548				 */
   549				adapted_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
   550				adapted_caps &= ~(MAC_1000HD | MAC_100HD | MAC_10HD);
   551			}
   552			break;
   553		}
   554		case RATE_ADAPT_CRS:
   555			/* The MAC must support half duplex at the interface's max
   556			 * speed.
   557			 */
   558			if (mac_capabilities &
   559			    phylink_cap_from_speed_duplex(max_speed, DUPLEX_HALF)) {
   560				adapted_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
   561				adapted_caps &= mac_capabilities;
   562			}
   563			break;
   564		}
   565	
   566		return (caps & mac_capabilities) | adapted_caps;
   567	}
   568	EXPORT_SYMBOL_GPL(phylink_get_capabilities);
   569	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
