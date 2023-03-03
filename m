Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF436A9E37
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 19:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjCCSNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 13:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjCCSNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 13:13:49 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561F410274;
        Fri,  3 Mar 2023 10:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677867228; x=1709403228;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dYCqJAu7NE86wpACnSHZguSCICf843ZaprjjEMo0Bkg=;
  b=n9lP0EtPuO0vLOgajQCzkSU12Y2uM7aAvGOlpFJ5Cm739cuYeZDk/RWS
   b2oQIR/UxnZmx6uvFfLVcbSDeq97qqZaJX9ZDnc8k8SWJm5q1PgDCQN7O
   /lWgvhiQyHpvAtHoVncueFqGyqqmF6URcut+EEvT4Kq1G35H/7Y0fp6NM
   Z1l60m6EzCzvCzwslZ1fZu1ls2kxixp+UmWIW/qlJG7hKtymdiJtWJq72
   3TAbi5fGJjwwLn1UOXf4j7T6iBry9F0sx4vnM2DfTSL8I+ObEfMLRlU9F
   7ro9q8nFrFdr9rTtdsYP/NKl9/j2/cbbjs2K6NTT/79cPDmqrP+oQWA5K
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="332596164"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="332596164"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 10:13:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="849545256"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="849545256"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 03 Mar 2023 10:13:22 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pY9uD-0001bD-2E;
        Fri, 03 Mar 2023 18:13:21 +0000
Date:   Sat, 4 Mar 2023 02:13:17 +0800
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
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Sven Eckelmann <sven@narfation.org>,
        Wang Yufen <wangyufen@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: Re: [PATCH v2 2/4] net: Expose available time stamping layers to
 user space.
Message-ID: <202303040133.slT4slaW-lkp@intel.com>
References: <20230303164248.499286-3-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230303164248.499286-3-kory.maincent@bootlin.com>
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
patch link:    https://lore.kernel.org/r/20230303164248.499286-3-kory.maincent%40bootlin.com
patch subject: [PATCH v2 2/4] net: Expose available time stamping layers to user space.
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230304/202303040133.slT4slaW-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/90d54e1c6ed12a0b55c868e7808d93f61dad3534
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review K-ry-Maincent/net-ethtool-Refactor-identical-get_ts_info-implementations/20230304-004527
        git checkout 90d54e1c6ed12a0b55c868e7808d93f61dad3534
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303040133.slT4slaW-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/core/net-sysfs.c: In function 'available_timestamping_providers_show':
>> net/core/net-sysfs.c:627:35: warning: variable 'ops' set but not used [-Wunused-but-set-variable]
     627 |         const struct ethtool_ops *ops;
         |                                   ^~~
   net/core/net-sysfs.c: In function 'current_timestamping_provider_show':
   net/core/net-sysfs.c:657:35: warning: variable 'ops' set but not used [-Wunused-but-set-variable]
     657 |         const struct ethtool_ops *ops;
         |                                   ^~~


vim +/ops +627 net/core/net-sysfs.c

   622	
   623	static ssize_t available_timestamping_providers_show(struct device *dev,
   624							     struct device_attribute *attr,
   625							     char *buf)
   626	{
 > 627		const struct ethtool_ops *ops;
   628		struct net_device *netdev;
   629		struct phy_device *phydev;
   630		int ret = 0;
   631	
   632		netdev = to_net_dev(dev);
   633		phydev = netdev->phydev;
   634		ops = netdev->ethtool_ops;
   635	
   636		if (!rtnl_trylock())
   637			return restart_syscall();
   638	
   639		ret += sprintf(buf, "%s\n", "mac");
   640		buf += 4;
   641	
   642		if (phy_has_tsinfo(phydev)) {
   643			ret += sprintf(buf, "%s\n", "phy");
   644			buf += 4;
   645		}
   646	
   647		rtnl_unlock();
   648	
   649		return ret;
   650	}
   651	static DEVICE_ATTR_RO(available_timestamping_providers);
   652	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
