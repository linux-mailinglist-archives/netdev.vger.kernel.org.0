Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1C76B2C1C
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjCIRdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCIRdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:33:44 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9446F1FE1;
        Thu,  9 Mar 2023 09:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678383223; x=1709919223;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=kBuk/qbo+wS0XQ/dFeyx8JguJDt+9dG8zDXc8OBOCnk=;
  b=Q6WZDTBGq8VnVY4zJsvKQiOJY539J9omDyD+BiKBKc5ZB+pZQQEOc7/X
   ZQ4rlzkj83cIv5CvkL+1+O3vINGU/WZ9jsVkTp3mcuBguPtctOr9EpAjB
   gSIqiVQuUxMpTQoqNscBqgSd2+oYZRh1qsE34kk3LMBVNaaQEOBy8ylBf
   8h74ozU3DIgDumUTMxV/5ZaSH1yKUNLyVpur9pZOp2PqLF1UmdtMuvgHL
   7yEs2T+BVMpRAgpoR4g/ub2nflgdFNylfvJGvIMqtFfjhFs0hf5IAPWa2
   P0GUvpzBauC4pAxSGRMZdCi4vzpSu8MNeqIt+L/s0OJyaYxHd7+YGkebj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="364156732"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="364156732"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 09:33:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="707697340"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="707697340"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 09 Mar 2023 09:33:36 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1paK91-00037N-0T;
        Thu, 09 Mar 2023 17:33:35 +0000
Date:   Fri, 10 Mar 2023 01:33:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Michael Walle <michael@walle.cc>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kory Maincent <kory.maincent@bootlin.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Minghao Chi <chi.minghao@zte.com.cn>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <202303100154.iqj4R4fL-lkp@intel.com>
References: <20230308135936.761794-4-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230308135936.761794-4-kory.maincent@bootlin.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Köry,

I love your patch! Perhaps something to improve:

[auto build test WARNING on v6.2]
[cannot apply to robh/for-next horms-ipvs/master net/master net-next/master linus/master v6.3-rc1 next-20230309]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/K-ry-Maincent/net-ethtool-Refactor-identical-get_ts_info-implementations/20230308-220453
patch link:    https://lore.kernel.org/r/20230308135936.761794-4-kory.maincent%40bootlin.com
patch subject: [PATCH v3 3/5] net: Let the active time stamping layer be selectable.
config: x86_64-randconfig-a003 (https://download.01.org/0day-ci/archive/20230310/202303100154.iqj4R4fL-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d81a36f239360e7e3b9ca2633e52b3cb12205590
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review K-ry-Maincent/net-ethtool-Refactor-identical-get_ts_info-implementations/20230308-220453
        git checkout d81a36f239360e7e3b9ca2633e52b3cb12205590
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/phy/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303100154.iqj4R4fL-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/phy/phy_device.c:1384:6: warning: no previous prototype for function 'of_set_timestamp' [-Wmissing-prototypes]
   void of_set_timestamp(struct net_device *netdev, struct phy_device *phydev)
        ^
   drivers/net/phy/phy_device.c:1384:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void of_set_timestamp(struct net_device *netdev, struct phy_device *phydev)
   ^
   static 
   1 warning generated.


vim +/of_set_timestamp +1384 drivers/net/phy/phy_device.c

  1383	
> 1384	void of_set_timestamp(struct net_device *netdev, struct phy_device *phydev)
  1385	{
  1386		struct device_node *node = phydev->mdio.dev.of_node;
  1387		const struct ethtool_ops *ops = netdev->ethtool_ops;
  1388		const char *s;
  1389		enum timestamping_layer ts_layer = 0;
  1390	
  1391		if (phy_has_hwtstamp(phydev))
  1392			ts_layer = PHY_TIMESTAMPING;
  1393		else if (ops->get_ts_info)
  1394			ts_layer = MAC_TIMESTAMPING;
  1395	
  1396		if (of_property_read_string(node, "preferred-timestamp", &s))
  1397			goto out;
  1398	
  1399		if (!s)
  1400			goto out;
  1401	
  1402		if (phy_has_hwtstamp(phydev) && !strcmp(s, "phy"))
  1403			ts_layer = PHY_TIMESTAMPING;
  1404	
  1405		if (ops->get_ts_info && !strcmp(s, "mac"))
  1406			ts_layer = MAC_TIMESTAMPING;
  1407	
  1408	out:
  1409		netdev->selected_timestamping_layer = ts_layer;
  1410	}
  1411	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
