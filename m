Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D3E547727
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 20:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiFKSqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 14:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiFKSqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 14:46:34 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D963F329;
        Sat, 11 Jun 2022 11:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654973192; x=1686509192;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kyT6KKWjC/OdmE81Ef78B9jpCvknrCcdviqYlOzkN2I=;
  b=dPCjKtaMJCYzLrmviWFc7ufW8qG9ZMrQ1RvuAvnHlqI1+HhvVBbxdgX7
   /ubTuIq8hrsP3CyGlop4p1/3IAaLWK0fFiMkz2uQXfCqBUqXjkd+DaE+s
   UhzHwuQNojP031oY1GMGXgE2IUGcdOdFxQ5ph838dZVRFNi1jNFx0yl+i
   zWAJIIse+lIZ2drYQ/MoYzqPVHltnIJ2qX2b7hVlep6djXwK2oteEyWU6
   EGLBCbKLVJ72PirOJmmzcovOe0AMoKM5eajPZGSlO0dJTE4sJAocjZaig
   XmO41jAsA26Q4wiI5oJ/BoQ/8qiJkLP8kP6qfkIizYJKaGJQEdC2btug3
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10375"; a="266661910"
X-IronPort-AV: E=Sophos;i="5.91,294,1647327600"; 
   d="scan'208";a="266661910"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2022 11:46:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,294,1647327600"; 
   d="scan'208";a="760973379"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2022 11:46:26 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o067t-000JCD-Fy;
        Sat, 11 Jun 2022 18:46:25 +0000
Date:   Sun, 12 Jun 2022 02:45:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Colin Foster <colin.foster@in-advantage.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
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
Subject: Re: [PATCH v10 net-next 7/7] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <202206120247.2zx79Zg9-lkp@intel.com>
References: <20220610202330.799510-8-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610202330.799510-8-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Colin-Foster/add-support-for-VSC7512-control-over-SPI/20220611-042931
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b97dcb85750b7e8bc5aaed5403ddf4b0552c7993
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20220612/202206120247.2zx79Zg9-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project ff4abe755279a3a47cc416ef80dbc900d9a98a19)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/60523f7239bade660c86be121bd29954c24f53df
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Colin-Foster/add-support-for-VSC7512-control-over-SPI/20220611-042931
        git checkout 60523f7239bade660c86be121bd29954c24f53df
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/mfd/ocelot-core.c:118:40: error: initializer element is not a compile-time constant
                   .of_reg = vsc7512_miim0_resources[0].start,
                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~
   1 error generated.


vim +118 drivers/mfd/ocelot-core.c

   103	
   104	static const struct mfd_cell vsc7512_devs[] = {
   105		{
   106			.name = "ocelot-pinctrl",
   107			.of_compatible = "mscc,ocelot-pinctrl",
   108			.num_resources = ARRAY_SIZE(vsc7512_pinctrl_resources),
   109			.resources = vsc7512_pinctrl_resources,
   110		}, {
   111			.name = "ocelot-sgpio",
   112			.of_compatible = "mscc,ocelot-sgpio",
   113			.num_resources = ARRAY_SIZE(vsc7512_sgpio_resources),
   114			.resources = vsc7512_sgpio_resources,
   115		}, {
   116			.name = "ocelot-miim0",
   117			.of_compatible = "mscc,ocelot-miim",
 > 118			.of_reg = vsc7512_miim0_resources[0].start,
   119			.use_of_reg = true,
   120			.num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
   121			.resources = vsc7512_miim0_resources,
   122		}, {
   123			.name = "ocelot-miim1",
   124			.of_compatible = "mscc,ocelot-miim",
   125			.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
   126			.of_reg = vsc7512_miim1_resources[0].start,
   127			.use_of_reg = true,
   128			.resources = vsc7512_miim1_resources,
   129		},
   130	};
   131	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
