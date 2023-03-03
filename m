Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A4F6A9FCA
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 19:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjCCSzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 13:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbjCCSze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 13:55:34 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08781421B;
        Fri,  3 Mar 2023 10:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677869731; x=1709405731;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=r9iSxYed7V91NJekvh25QrQIYpH26KBADuAyQA9VZsI=;
  b=Hq5HrMLMC4xx4M9hODUc10R3cTYd0945n6/6h6yyciamMMHHJNlgNaiz
   agaKe0j2aYf3zOnxlOR37tWfJx3zbVbseVgSj5E28ht9VR8hHvz0jNN3c
   mftleVC3A6KEBwGxrj3dkqc7qZHbdBt53oXOoE/PFXJT8DxaljcusOcj3
   dkVfIFu09OV6rqxpY+A6FQ4YUs3mhtLyu1vL6E07SxMID3yH+17e2BByX
   P0itpajaNQRgybDaeev30VmV2nRqlHVBziNclRuOwr2EKeVOMTzrEftfO
   HIY1FVTXd0z7D/dhuiA7bMisGx6Gw2ArbHkN5ygZIXTBVxavtYzP5l/Dg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="333849459"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="333849459"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 10:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="707940969"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="707940969"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 03 Mar 2023 10:55:23 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pYAYs-0001cE-1U;
        Fri, 03 Mar 2023 18:55:22 +0000
Date:   Sat, 4 Mar 2023 02:54:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>,
        Kory Maincent <kory.maincent@bootlin.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH v2 3/4] net: Let the active time stamping layer be
 selectable.
Message-ID: <202303040219.nmNWbGrY-lkp@intel.com>
References: <20230303164248.499286-4-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230303164248.499286-4-kory.maincent@bootlin.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Köry,

I love your patch! Perhaps something to improve:

[auto build test WARNING on v6.2]
[also build test WARNING on next-20230303]
[cannot apply to net/master net-next/master horms-ipvs/master linus/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/K-ry-Maincent/net-ethtool-Refactor-identical-get_ts_info-implementations/20230304-004527
patch link:    https://lore.kernel.org/r/20230303164248.499286-4-kory.maincent%40bootlin.com
patch subject: [PATCH v2 3/4] net: Let the active time stamping layer be selectable.
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230304/202303040219.nmNWbGrY-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/00a0656f9b222cfeb7c1253a4a2771b1f63b5c9b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review K-ry-Maincent/net-ethtool-Refactor-identical-get_ts_info-implementations/20230304-004527
        git checkout 00a0656f9b222cfeb7c1253a4a2771b1f63b5c9b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303040219.nmNWbGrY-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/core/net-sysfs.c: In function 'available_timestamping_providers_show':
   net/core/net-sysfs.c:627:35: warning: variable 'ops' set but not used [-Wunused-but-set-variable]
     627 |         const struct ethtool_ops *ops;
         |                                   ^~~
   net/core/net-sysfs.c: In function 'current_timestamping_provider_show':
>> net/core/net-sysfs.c:659:28: warning: variable 'phydev' set but not used [-Wunused-but-set-variable]
     659 |         struct phy_device *phydev;
         |                            ^~~~~~
   net/core/net-sysfs.c:657:35: warning: variable 'ops' set but not used [-Wunused-but-set-variable]
     657 |         const struct ethtool_ops *ops;
         |                                   ^~~


vim +/phydev +659 net/core/net-sysfs.c

90d54e1c6ed12a Richard Cochran 2023-03-03  652  
90d54e1c6ed12a Richard Cochran 2023-03-03  653  static ssize_t current_timestamping_provider_show(struct device *dev,
90d54e1c6ed12a Richard Cochran 2023-03-03  654  						  struct device_attribute *attr,
90d54e1c6ed12a Richard Cochran 2023-03-03  655  						  char *buf)
90d54e1c6ed12a Richard Cochran 2023-03-03  656  {
90d54e1c6ed12a Richard Cochran 2023-03-03  657  	const struct ethtool_ops *ops;
90d54e1c6ed12a Richard Cochran 2023-03-03  658  	struct net_device *netdev;
90d54e1c6ed12a Richard Cochran 2023-03-03 @659  	struct phy_device *phydev;
90d54e1c6ed12a Richard Cochran 2023-03-03  660  	int ret;
90d54e1c6ed12a Richard Cochran 2023-03-03  661  
90d54e1c6ed12a Richard Cochran 2023-03-03  662  	netdev = to_net_dev(dev);
90d54e1c6ed12a Richard Cochran 2023-03-03  663  	phydev = netdev->phydev;
90d54e1c6ed12a Richard Cochran 2023-03-03  664  	ops = netdev->ethtool_ops;
90d54e1c6ed12a Richard Cochran 2023-03-03  665  
90d54e1c6ed12a Richard Cochran 2023-03-03  666  	if (!rtnl_trylock())
90d54e1c6ed12a Richard Cochran 2023-03-03  667  		return restart_syscall();
90d54e1c6ed12a Richard Cochran 2023-03-03  668  
00a0656f9b222c Richard Cochran 2023-03-03  669  	switch (netdev->selected_timestamping_layer) {
00a0656f9b222c Richard Cochran 2023-03-03  670  	case MAC_TIMESTAMPING:
90d54e1c6ed12a Richard Cochran 2023-03-03  671  		ret = sprintf(buf, "%s\n", "mac");
00a0656f9b222c Richard Cochran 2023-03-03  672  		break;
00a0656f9b222c Richard Cochran 2023-03-03  673  	case PHY_TIMESTAMPING:
00a0656f9b222c Richard Cochran 2023-03-03  674  		ret = sprintf(buf, "%s\n", "phy");
00a0656f9b222c Richard Cochran 2023-03-03  675  		break;
90d54e1c6ed12a Richard Cochran 2023-03-03  676  	}
90d54e1c6ed12a Richard Cochran 2023-03-03  677  
90d54e1c6ed12a Richard Cochran 2023-03-03  678  	rtnl_unlock();
90d54e1c6ed12a Richard Cochran 2023-03-03  679  
90d54e1c6ed12a Richard Cochran 2023-03-03  680  	return ret;
90d54e1c6ed12a Richard Cochran 2023-03-03  681  }
00a0656f9b222c Richard Cochran 2023-03-03  682  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
