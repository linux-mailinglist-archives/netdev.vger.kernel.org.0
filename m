Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060E66CB4F4
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 05:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjC1Dgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 23:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjC1Dgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 23:36:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9296AF;
        Mon, 27 Mar 2023 20:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679974612; x=1711510612;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j5hmjjyKk5Psz1U4nuya4ZEXu6xtodg5+e6026qUC0c=;
  b=TZLGBKioFd/8YPRMwZ85330ZmhrHYnwg+rKYSCP0gGOn2xnGPcHnRhYG
   Gf4qtNuCabgTSYQ8W2kMn7qf/m0uCxZkQUPYoMsgzOXNedt+oOsh0Ms9w
   yGfPRr/NX3Paq6qnUmThVfSjwpxt77TlhrPGjsZvLb751OURENb5vtRpz
   AAD2SWv3TuDrjHMuDzaG2cgWtOQDhKnHAAXg9WLQvikCs1eAoByTdfBmx
   te0nx4we7WyuvaVBH3lYaUR3URQKmEJ9oEYLIt45bT0u821haWPieV1db
   5SS8qqBTeAa+h4yL1HIb9uQyaOMEjBJYzgbpDWa+Zyj3Wa3lCposCuRrP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="320861202"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="320861202"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 20:36:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="807715325"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="807715325"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 27 Mar 2023 20:36:47 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ph08c-000IFb-1y;
        Tue, 28 Mar 2023 03:36:46 +0000
Date:   Tue, 28 Mar 2023 11:36:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Amit Cohen <amcohen@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v2 4/8] ethtool: eee: Rework get/set handler for
 SmartEEE-capable PHYs with non-EEE MACs
Message-ID: <202303281117.3288i7kT-lkp@intel.com>
References: <20230327142202.3754446-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327142202.3754446-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Oleksij-Rempel/net-phy-Add-driver-specific-get-set_eee-support-for-non-standard-PHYs/20230327-222630
patch link:    https://lore.kernel.org/r/20230327142202.3754446-5-o.rempel%40pengutronix.de
patch subject: [PATCH net-next v2 4/8] ethtool: eee: Rework get/set handler for SmartEEE-capable PHYs with non-EEE MACs
config: csky-defconfig (https://download.01.org/0day-ci/archive/20230328/202303281117.3288i7kT-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fcee3230c8abb824746744ba0fc39dfd626faa65
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Oleksij-Rempel/net-phy-Add-driver-specific-get-set_eee-support-for-non-standard-PHYs/20230327-222630
        git checkout fcee3230c8abb824746744ba0fc39dfd626faa65
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=csky olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=csky SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303281117.3288i7kT-lkp@intel.com/

All errors (new ones prefixed by >>):

   csky-linux-ld: net/ethtool/common.o: in function `__ethtool_get_eee':
   common.c:(.text+0x45c): undefined reference to `phy_ethtool_get_eee'
   csky-linux-ld: net/ethtool/common.o: in function `__ethtool_set_eee':
   common.c:(.text+0x49c): undefined reference to `phy_ethtool_set_eee'
>> csky-linux-ld: common.c:(.text+0x4b8): undefined reference to `phy_ethtool_get_eee'
>> csky-linux-ld: common.c:(.text+0x4bc): undefined reference to `phy_ethtool_set_eee'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
