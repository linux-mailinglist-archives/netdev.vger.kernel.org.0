Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0175547B9
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352262AbiFVK3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 06:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354748AbiFVK2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 06:28:50 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65D531201;
        Wed, 22 Jun 2022 03:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655893730; x=1687429730;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dj28N6SLVUB4mV+mjREMiUuxJGVVRloqCn6LP2R95QY=;
  b=lb5VlZYmpFdBmRZmxjnu27chn8+phMMHlj14j4qg/s9M7iAVCD57jCQL
   sq35iQaYhbS9Au360Q5RsRd2tfsGlHJXPq4/d1HgZOfYppo7/ndMzcd4K
   bgm6yv4CMd2ZRH64KGFT3BpZIvGicj4hBhBimNrzKYEHjKzzXSp+wEVM5
   Aa2U6djPtxPJ5L91c0CD5wQ9p2HJO2yNsMqX/gsBqRdfEPO/mmz+G7bEr
   4DYD3K9ji49OM39ACNXrSgS1PTIgWZg37ykQk9piGs3spgaov5T+q7c3l
   qqLqVWlkwiNM72WtTjyh7J6nbDnmy5wKZuBQYuXQRM6mU3gOCOUWyoSVZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="269099673"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="269099673"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 03:28:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="592120346"
Received: from lkp-server02.sh.intel.com (HELO a67cc04a5eeb) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jun 2022 03:28:43 -0700
Received: from kbuild by a67cc04a5eeb with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o3xbG-00018z-Gn;
        Wed, 22 Jun 2022 10:28:42 +0000
Date:   Wed, 22 Jun 2022 18:27:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     kbuild-all@lists.01.org,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v8 05/16] net: pcs: add Renesas MII converter
 driver
Message-ID: <202206221821.YTh0dW9N-lkp@intel.com>
References: <20220620110846.374787-6-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220620110846.374787-6-clement.leger@bootlin.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Clément,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Cl-ment-L-ger/add-support-for-Renesas-RZ-N1-ethernet-subsystem-devices/20220620-191343
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dbca1596bbb08318f5e3b3b99f8ca0a0d3830a65
config: ia64-randconfig-r003-20220622 (https://download.01.org/0day-ci/archive/20220622/202206221821.YTh0dW9N-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fd8100fa88a9cffefe76f27b683803108d39c253
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Cl-ment-L-ger/add-support-for-Renesas-RZ-N1-ethernet-subsystem-devices/20220620-191343
        git checkout fd8100fa88a9cffefe76f27b683803108d39c253
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/net/pcs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/pcs/pcs-rzn1-miic.c:501:34: warning: 'miic_of_mtable' defined but not used [-Wunused-const-variable=]
     501 | static const struct of_device_id miic_of_mtable[] = {
         |                                  ^~~~~~~~~~~~~~
   drivers/net/pcs/pcs-rzn1-miic.c: In function 'miic_probe':
>> drivers/net/pcs/pcs-rzn1-miic.c:430:19: warning: 'conf' is used uninitialized [-Wuninitialized]
     430 |         dt_val[0] = conf;
         |         ~~~~~~~~~~^~~~~~
   drivers/net/pcs/pcs-rzn1-miic.c:424:13: note: 'conf' was declared here
     424 |         u32 conf;
         |             ^~~~


vim +/conf +430 drivers/net/pcs/pcs-rzn1-miic.c

   418	
   419	static int miic_parse_dt(struct device *dev, u32 *mode_cfg)
   420	{
   421		s8 dt_val[MIIC_MODCTRL_CONF_CONV_NUM];
   422		struct device_node *np = dev->of_node;
   423		struct device_node *conv;
   424		u32 conf;
   425		int port;
   426	
   427		memset(dt_val, MIIC_MODCTRL_CONF_NONE, sizeof(dt_val));
   428	
   429		of_property_read_u32(np, "renesas,miic-switch-portin", &conf);
 > 430		dt_val[0] = conf;
   431	
   432		for_each_child_of_node(np, conv) {
   433			if (of_property_read_u32(conv, "reg", &port))
   434				continue;
   435	
   436			if (!of_device_is_available(conv))
   437				continue;
   438	
   439			if (of_property_read_u32(conv, "renesas,miic-input", &conf) == 0)
   440				dt_val[port] = conf;
   441		}
   442	
   443		return miic_match_dt_conf(dev, dt_val, mode_cfg);
   444	}
   445	
   446	static int miic_probe(struct platform_device *pdev)
   447	{
   448		struct device *dev = &pdev->dev;
   449		struct miic *miic;
   450		u32 mode_cfg;
   451		int ret;
   452	
   453		ret = miic_parse_dt(dev, &mode_cfg);
   454		if (ret < 0)
   455			return -EINVAL;
   456	
   457		miic = devm_kzalloc(dev, sizeof(*miic), GFP_KERNEL);
   458		if (!miic)
   459			return -ENOMEM;
   460	
   461		spin_lock_init(&miic->lock);
   462		miic->dev = dev;
   463		miic->base = devm_platform_ioremap_resource(pdev, 0);
   464		if (!miic->base)
   465			return -EINVAL;
   466	
   467		ret = devm_pm_runtime_enable(dev);
   468		if (ret < 0)
   469			return ret;
   470	
   471		ret = pm_runtime_resume_and_get(dev);
   472		if (ret < 0)
   473			return ret;
   474	
   475		ret = miic_init_hw(miic, mode_cfg);
   476		if (ret)
   477			goto disable_runtime_pm;
   478	
   479		/* miic_create() relies on that fact that data are attached to the
   480		 * platform device to determine if the driver is ready so this needs to
   481		 * be the last thing to be done after everything is initialized
   482		 * properly.
   483		 */
   484		platform_set_drvdata(pdev, miic);
   485	
   486		return 0;
   487	
   488	disable_runtime_pm:
   489		pm_runtime_put(dev);
   490	
   491		return ret;
   492	}
   493	
   494	static int miic_remove(struct platform_device *pdev)
   495	{
   496		pm_runtime_put(&pdev->dev);
   497	
   498		return 0;
   499	}
   500	
 > 501	static const struct of_device_id miic_of_mtable[] = {
   502		{ .compatible = "renesas,rzn1-miic" },
   503		{ /* sentinel */ },
   504	};
   505	MODULE_DEVICE_TABLE(of, miic_of_mtable);
   506	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
