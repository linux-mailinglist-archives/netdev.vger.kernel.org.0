Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3AD546DA2
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 21:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350227AbiFJTwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 15:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348190AbiFJTv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 15:51:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB8C207EE2;
        Fri, 10 Jun 2022 12:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654890716; x=1686426716;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D95rmZyOn6FJr0xwZXFlkslFyxEjbwH6lMFM0MSberU=;
  b=m01hox7GjOLOLv+G4dKCO8kq4PHW3ABr3gQ9F/ddsqonTX7t3wZJYKD0
   HXrlCJpYwwBo4J5IFq42ErZqUZ0/AfUKx5C/5u/NiYKPfNUkrGZSwQ5Au
   eMWANQwd2ByT/ErMAyK36h9T4lrz5wn+0mFpXaffcS0XQ1/qDbN3B7Yhg
   W7wXCy3oQRGuvGA94l6TQKf986QaQIdv8dAtIpfWvZSEaRvTww6mOIamC
   gCmSUSWwjcCnh0RyKOVth0s0lEJUnD9i+iAhRK3Sl+fPSLpcxePb7GEwc
   zxt+mo4+AKjU9qPCJPYF9S+018VxpBoyAUUJgodw95kErkxNcedTV28wi
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="258164393"
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="258164393"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 12:51:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="760646311"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 10 Jun 2022 12:51:50 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzkfe-000IEe-2x;
        Fri, 10 Jun 2022 19:51:50 +0000
Date:   Sat, 11 Jun 2022 03:51:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Colin Foster <colin.foster@in-advantage.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v9 net-next 7/7] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <202206110358.2hO4gzbU-lkp@intel.com>
References: <20220610175655.776153-8-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610175655.776153-8-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Colin-Foster/add-support-for-VSC7512-control-over-SPI/20220611-015854
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 7defbc9aed2b1fdf21586b78e085c468fd95a2d1
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220611/202206110358.2hO4gzbU-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/be13bccb3f0b376d8d189aa8d14e5b461701f4db
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Colin-Foster/add-support-for-VSC7512-control-over-SPI/20220611-015854
        git checkout be13bccb3f0b376d8d189aa8d14e5b461701f4db
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash drivers/mfd/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/mfd/ocelot-core.c:81:16: warning: no previous prototype for 'ocelot_init_regmap_from_resource' [-Wmissing-prototypes]
      81 | struct regmap *ocelot_init_regmap_from_resource(struct device *child,
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/ocelot_init_regmap_from_resource +81 drivers/mfd/ocelot-core.c

    80	
  > 81	struct regmap *ocelot_init_regmap_from_resource(struct device *child,
    82							const struct resource *res)
    83	{
    84		struct device *dev = child->parent;
    85	
    86		return ocelot_spi_init_regmap(dev, child, res);
    87	}
    88	EXPORT_SYMBOL_NS(ocelot_init_regmap_from_resource, MFD_OCELOT);
    89	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
