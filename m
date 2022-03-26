Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DDD4E7EAE
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 03:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiCZCy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 22:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiCZCyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 22:54:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860ED2DD70;
        Fri, 25 Mar 2022 19:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648263197; x=1679799197;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=uI+S8wJngH0DegLJABgjbAsMLT1fPpAdxr5wiQNUH04=;
  b=R3ewHIzcYSX84Bd5JI9CFtn9TCr9GSkuiHCeca4tnXPtQt7bzPXp+Jkd
   +XgNmK+rmRYRj4AfFJbJrKjlIQhHQddS66r0wrXYdpwCPSK+8pOYTBl7y
   eniV+z8vfX661yivUD85bZmrsb8A7q3KlvPpBcrR1zLK5/hzc/Ozw0DGn
   eTIPDFFbL1o09CM5gXDuTVUXStWbXOP8fwQPyxOaRLyoOmLiM4wRx5lUc
   Res09ob3H81VM8SLUVbSYXQLoydP2ipLPA5TuuTHUkomYOIxrtpdoO3+d
   qeg94ABnMq6au20yV7Lz0MWR9dmxVcJ6ZP5C0A94wUVcJv9bPf7ph/JrO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10297"; a="345188336"
X-IronPort-AV: E=Sophos;i="5.90,211,1643702400"; 
   d="scan'208";a="345188336"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 19:53:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,211,1643702400"; 
   d="scan'208";a="648456233"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 25 Mar 2022 19:53:13 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nXwYD-000MvT-6Q; Sat, 26 Mar 2022 02:53:13 +0000
Date:   Sat, 26 Mar 2022 10:52:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Subject: Re: [net-next 1/5] net: mdio: fwnode: add fwnode_mdiobus_register()
Message-ID: <202203261007.nhIuHNPd-lkp@intel.com>
References: <20220325172234.1259667-2-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220325172234.1259667-2-clement.leger@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Clément,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Cl-ment-L-ger/net-mdio-fwnode-add-fwnode_mdiobus_register/20220326-040146
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 89695196f0ba78a17453f9616355f2ca6b293402
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220326/202203261007.nhIuHNPd-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 0f6d9501cf49ce02937099350d08f20c4af86f3d)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/8ed21cbab4f71b382b70d22da18e9331bd9b714f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Cl-ment-L-ger/net-mdio-fwnode-add-fwnode_mdiobus_register/20220326-040146
        git checkout 8ed21cbab4f71b382b70d22da18e9331bd9b714f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/mdio/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/mdio/fwnode_mdio.c:154:34: warning: unused variable 'whitelist_phys' [-Wunused-const-variable]
   static const struct of_device_id whitelist_phys[] = {
                                    ^
   1 warning generated.


vim +/whitelist_phys +154 drivers/net/mdio/fwnode_mdio.c

   147	
   148	/* The following is a list of PHY compatible strings which appear in
   149	 * some DTBs. The compatible string is never matched against a PHY
   150	 * driver, so is pointless. We only expect devices which are not PHYs
   151	 * to have a compatible string, so they can be matched to an MDIO
   152	 * driver.  Encourage users to upgrade their DT blobs to remove these.
   153	 */
 > 154	static const struct of_device_id whitelist_phys[] = {
   155		{ .compatible = "brcm,40nm-ephy" },
   156		{ .compatible = "broadcom,bcm5241" },
   157		{ .compatible = "marvell,88E1111", },
   158		{ .compatible = "marvell,88e1116", },
   159		{ .compatible = "marvell,88e1118", },
   160		{ .compatible = "marvell,88e1145", },
   161		{ .compatible = "marvell,88e1149r", },
   162		{ .compatible = "marvell,88e1310", },
   163		{ .compatible = "marvell,88E1510", },
   164		{ .compatible = "marvell,88E1514", },
   165		{ .compatible = "moxa,moxart-rtl8201cp", },
   166		{}
   167	};
   168	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
