Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1F76AA7C0
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 04:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjCDDHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 22:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDDHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 22:07:41 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DAB1ABEC;
        Fri,  3 Mar 2023 19:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677899259; x=1709435259;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=p9wuUBRJAuSisbmC0MWSa/lJzRmQ5d5xrSZ5zn9hbAk=;
  b=YsMIL3I6IQxHiWbUS2LYvMpQ4yxeMtwwN00qZVqnI8rkENF0Fc/MHdRU
   UNnDiv2WQ50giFiNIW5WAvFpd5hnWShewxzRViEUVmiu1VWoGZ1blSccW
   kxHeH2aSiZ4PkHmilrCerzzvw9C3Z17eNw3WN2OLG32P4ZFSnn49FvHMj
   88aGKqJQ/XieIIrH5gmMiOmskeGtTueAUqAQ9xs6M5D78UNpIHY4mghJq
   a5rhM7fcbDlPzBjqwjVtZxrZjo70/nkR9V5NEMQ7GInBenCQGJvmDTgyZ
   eYNmusTEneDxNk8FvwFdSWOe1srH3Qu2opsSjMRcl8Roniu6RYLdtkTjm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="421485942"
X-IronPort-AV: E=Sophos;i="5.98,232,1673942400"; 
   d="scan'208";a="421485942"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 19:07:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="744450365"
X-IronPort-AV: E=Sophos;i="5.98,232,1673942400"; 
   d="scan'208";a="744450365"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 03 Mar 2023 19:07:32 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pYIF9-0001oW-2T;
        Sat, 04 Mar 2023 03:07:31 +0000
Date:   Sat, 4 Mar 2023 11:06:54 +0800
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
Message-ID: <202303041027.GxlLyldN-lkp@intel.com>
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

I love your patch! Yet something to improve:

[auto build test ERROR on v6.2]
[also build test ERROR on next-20230303]
[cannot apply to net/master net-next/master horms-ipvs/master linus/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/K-ry-Maincent/net-ethtool-Refactor-identical-get_ts_info-implementations/20230304-004527
patch link:    https://lore.kernel.org/r/20230303164248.499286-4-kory.maincent%40bootlin.com
patch subject: [PATCH v2 3/4] net: Let the active time stamping layer be selectable.
config: csky-defconfig (https://download.01.org/0day-ci/archive/20230304/202303041027.GxlLyldN-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/00a0656f9b222cfeb7c1253a4a2771b1f63b5c9b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review K-ry-Maincent/net-ethtool-Refactor-identical-get_ts_info-implementations/20230304-004527
        git checkout 00a0656f9b222cfeb7c1253a4a2771b1f63b5c9b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=csky olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=csky SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303041027.GxlLyldN-lkp@intel.com/

All errors (new ones prefixed by >>):

   csky-linux-ld: net/core/dev_ioctl.o: in function `dev_ifsioc':
>> dev_ioctl.c:(.text+0x292): undefined reference to `phy_mii_ioctl'
>> csky-linux-ld: dev_ioctl.c:(.text+0x370): undefined reference to `phy_do_ioctl'
>> csky-linux-ld: dev_ioctl.c:(.text+0x374): undefined reference to `phy_mii_ioctl'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
