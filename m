Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B48954725B
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 08:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345965AbiFKGYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 02:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiFKGYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 02:24:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293D314095;
        Fri, 10 Jun 2022 23:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654928650; x=1686464650;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5fULlUWTJ0Mpiasmhrqi3Eiepoj/IWBoziXzyJOlRYA=;
  b=M2uy9sCvqaTs2XQEi0HVTvu05MaEI3bBQmYmHvnD3t5ZSatZnbno8JE5
   k3aYyilsqbup2aGrJZgU7LVnfERWdiRTkvTS4KURO+Olo/UH1oMRjWz0F
   Wz5O2tn+pNb7lT+B9kd8LyqgcZWfueObEMRLk8wAgduD5wcUDAxPju2RL
   xFTxV0Q0ydsgicf96S894qkirNjgNx8whwpUGA7wz/cOGEDDyIxB/HLJ+
   QO0AcAM2fvmCy+eINdUu/eQ1hv4eZRQVSzTIyT6RQyBKuzmYjC9jSk/qB
   Ou4t0xlQYdwekIqtthbLXdFK7IrzKBWyuy6VcPq0ndo+zP2dmnTe7LfTQ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="260947526"
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="260947526"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 23:24:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="611036523"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 10 Jun 2022 23:24:04 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzuXU-000Ibz-1s;
        Sat, 11 Jun 2022 06:24:04 +0000
Date:   Sat, 11 Jun 2022 14:23:50 +0800
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
Subject: Re: [PATCH v10 net-next 7/7] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <202206111455.xaWNrJPX-lkp@intel.com>
References: <20220610202330.799510-8-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610202330.799510-8-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
config: riscv-allmodconfig (https://download.01.org/0day-ci/archive/20220611/202206111455.xaWNrJPX-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/60523f7239bade660c86be121bd29954c24f53df
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Colin-Foster/add-support-for-VSC7512-control-over-SPI/20220611-042931
        git checkout 60523f7239bade660c86be121bd29954c24f53df
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "ocelot_platform_init_regmap_from_resource" [drivers/net/mdio/mdio-mscc-miim.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
