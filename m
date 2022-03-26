Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CC54E7EAB
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 03:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiCZCy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 22:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiCZCyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 22:54:55 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C161F2E9D5;
        Fri, 25 Mar 2022 19:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648263198; x=1679799198;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=DJNH6W+7LdBOCZcGma6QMCD5bEDfVfVMxATszIZfMvE=;
  b=YCrQ7PjusJXPfOmOGMPe8N1usnFH2lHuyznzIkMxf9XZCNbZZFrla5ls
   VKtxlYLz7T6yeDtBP6Q+PqZFOKR2FkYizrl0gXeJa0Tsjex8zIZEMW0Ty
   LZxLZVzbPYlys5Xnsj14TQuIgYMTYyZAsDUZiqEOB2WgAZ2dRFsRsNCfK
   RzKsHw5ufUa2NkeyeiVEK7GanAvmzJw/mqnurQ5f4N0cRCnN3vNQy9i5y
   9yjy/YHpnUXOVhvaZyVk7iPzJ5OHZgXRTXmtK/RUXjiqrjrlvlJsQmzVc
   X3mRrxByD13lxVeiJCkrRMJ+7mwHIJdzvPxw5vjrKlOYG46a8rTrkUqOb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10297"; a="258720631"
X-IronPort-AV: E=Sophos;i="5.90,211,1643702400"; 
   d="scan'208";a="258720631"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 19:53:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,211,1643702400"; 
   d="scan'208";a="826203605"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 25 Mar 2022 19:53:13 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nXwYD-000MvO-4c; Sat, 26 Mar 2022 02:53:13 +0000
Date:   Sat, 26 Mar 2022 10:52:30 +0800
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
Message-ID: <202203261037.wkZLCKMl-lkp@intel.com>
References: <20220325172234.1259667-2-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220325172234.1259667-2-clement.leger@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
config: x86_64-randconfig-c007 (https://download.01.org/0day-ci/archive/20220326/202203261037.wkZLCKMl-lkp@intel.com/config)
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
