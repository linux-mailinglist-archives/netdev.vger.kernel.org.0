Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02444563F5D
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 12:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiGBKFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 06:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiGBKE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 06:04:59 -0400
Received: from mga17.intel.com (unknown [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86835186C1;
        Sat,  2 Jul 2022 03:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656756298; x=1688292298;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AZl8HN5oDnj9aknNKQSHbkKjT0Qvlv4fnPi+jb+GiQQ=;
  b=Jb4vS8FXieNFrA1YDcAyeFC59Zyj5vtvhKIP2LkeS9kySti9k3ttuM6F
   m0pU1MLrMXLG0DkPwldEz2D6hDgn2gHhiYQvRYZlygMsr58ukOlP0cqIf
   yBBZOEqjx4rCkughh4PhY5RyalYOeT3LlHiH1wfLyC7AVLJ5B0UXFAm54
   oMwfXrWDAV78JiYoUYPvBZFj2PzY+imy9QNB5/7XIkDBvyNo7kDOI7nW5
   YgyaZkxknIQ1RpF42UwT2b+EqpXEh8YVXDr2G6conAJrafevpfJGlAFf6
   4K2X8+GrrXOd2Hi0NP9ZV3H5qUVrAYupOQeFnWOgfFk18WECohBfBtwcR
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10395"; a="263209557"
X-IronPort-AV: E=Sophos;i="5.92,239,1650956400"; 
   d="scan'208";a="263209557"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2022 03:04:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,239,1650956400"; 
   d="scan'208";a="596534543"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 02 Jul 2022 03:04:53 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o7Zzb-000F7b-KF;
        Sat, 02 Jul 2022 10:04:47 +0000
Date:   Sat, 2 Jul 2022 18:04:44 +0800
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
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v12 net-next 9/9] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <202207021703.v9TWwjUK-lkp@intel.com>
References: <20220701192609.3970317-10-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701192609.3970317-10-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RDNS_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Colin-Foster/add-support-for-VSC7512-control-over-SPI/20220702-032824
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dbdd9a28e1406ab8218a69e60f10a168b968c81d
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220702/202207021703.v9TWwjUK-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/86c3be9af85a12a7b190790d80944693dd07a132
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Colin-Foster/add-support-for-VSC7512-control-over-SPI/20220702-032824
        git checkout 86c3be9af85a12a7b190790d80944693dd07a132
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "ocelot_spi_init_regmap" [drivers/mfd/ocelot-core.ko] undefined!
WARNING: modpost: module ocelot-spi uses symbol ocelot_chip_reset from namespace MFD_OCELOT, but does not import it.
WARNING: modpost: module ocelot-spi uses symbol ocelot_core_init from namespace MFD_OCELOT, but does not import it.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
