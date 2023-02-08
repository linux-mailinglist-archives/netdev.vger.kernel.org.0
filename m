Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F2368F514
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjBHRem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjBHRd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:33:59 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC4B3A879;
        Wed,  8 Feb 2023 09:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675877636; x=1707413636;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sDFh6JeR2XcTkYhVvLPcaBAq4Ze0UO0qz9+CSTh3saw=;
  b=JbPfNKlaEydECMI6+evwBtvDm6bjbLxL+YElsZTG2IE7x/yyWy5y8lrK
   5L7ngYhPKO4/SC0nrWOkifHpGnVF/2n16wW6CQaPDwTSu+ELs/UIedzmH
   +/9uywjUWRqFc0uaveUh1peuOp5+huPD6+lrwxdbewoBW2g6TvyqAR5Aw
   AKC8yPoE27mBasgbZiQBIxK7EUUkRTP2ve4yyzbQcbawjQ7szQK2ks7Az
   n8cQsy0wHvw2NZnVilqgnHVnyeJNSS79YloFiprywi6hF2enSluO6xFHV
   tuzpj8etp3f/dPrrMdTitJjQ1xZD/+a9Z4oE80/kC9uN8FCU8nh2KAPbk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="310225204"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="310225204"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 09:33:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="697722955"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="697722955"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 08 Feb 2023 09:33:08 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 6543F1A6; Wed,  8 Feb 2023 19:33:47 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Devarsh Thakkar <devarsht@ti.com>,
        Michael Walle <michael@walle.cc>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dipen Patel <dipenp@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Lee Jones <lee@kernel.org>, linux-gpio@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Jonathan Corbet <corbet@lwn.net>, Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Keerthy <j-keerthy@ti.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, Qiang Zhao <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: [PATCH v4 00/18] gpiolib cleanups
Date:   Wed,  8 Feb 2023 19:33:25 +0200
Message-Id: <20230208173343.37582-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are some older patches Arnd did last year, rebased to
linux-next-20230208. On top there are Andy's patches regarding
similar topic. The series starts with Linus Walleij's patches.

The main goal is to remove some of the legacy bits of the gpiolib
interfaces, where the corner cases are easily avoided or replaced
with gpio descriptor based interfaces.

The idea is to get an immutable branch and route the whole series
via GPIO tree.

Changes in v4:
- incorporated Linus Walleij's patches
- reworked touchscreen patch to have bare minimum changes (Dmitry)
- described changes in gpio-aggregator in full (Geert)
- addressed compilation errors (LKP)
- added tags (Geert, Lee, Vincenzo)

Changes in v3:
- reworked touchscreen patch in accordance with Dmitry's comments
- rebased on the latest Linux Next
- added on top Andy's series

Changes in v2:
- dropped patch 8 after Andy's identical patch was merged
- rebase on latest gpio tree
- leave unused gpio_cansleep() in place for now
- address feedback from Andy Shevchenko

Andy Shevchenko (7):
  gpio: aggregator: Add missing header(s)
  gpio: reg: Add missing header(s)
  gpio: regmap: Add missing header(s)
  gpiolib: Drop unused forward declaration from driver.h
  gpiolib: Deduplicate forward declarations in consumer.h
  gpiolib: Group forward declarations in consumer.h
  gpiolib: Clean up headers

Arnd Bergmann (7):
  gpiolib: remove empty asm/gpio.h files
  gpiolib: coldfire: remove custom asm/gpio.h
  gpiolib: remove asm-generic/gpio.h
  gpiolib: remove gpio_set_debounce()
  gpiolib: remove legacy gpio_export()
  gpiolib: split linux/gpio/driver.h out of linux/gpio.h
  gpiolib: split of_mm_gpio_chip out of linux/of_gpio.h

Linus Walleij (4):
  ARM: orion/gpio: Use the right include
  ARM: s3c24xx: Use the right include
  hte: tegra-194: Use proper includes
  gpiolib: Make the legacy <linux/gpio.h> consumer-only

 Documentation/admin-guide/gpio/sysfs.rst      |   2 +-
 Documentation/driver-api/gpio/legacy.rst      |  23 ---
 .../zh_CN/driver-api/gpio/legacy.rst          |  20 ---
 Documentation/translations/zh_TW/gpio.txt     |  19 ---
 MAINTAINERS                                   |   1 -
 arch/arm/Kconfig                              |   1 -
 arch/arm/include/asm/gpio.h                   |  21 ---
 arch/arm/mach-omap1/irq.c                     |   1 +
 arch/arm/mach-omap2/pdata-quirks.c            |   9 +-
 arch/arm/mach-orion5x/board-rd88f5182.c       |   1 +
 arch/arm/mach-s3c/s3c64xx.c                   |   2 +-
 arch/arm/mach-sa1100/assabet.c                |   1 +
 arch/arm/plat-orion/gpio.c                    |   5 +-
 arch/m68k/Kconfig.cpu                         |   1 -
 arch/m68k/include/asm/gpio.h                  |  95 -----------
 arch/m68k/include/asm/mcfgpio.h               |   2 +-
 arch/powerpc/platforms/44x/Kconfig            |   1 +
 arch/powerpc/platforms/4xx/gpio.c             |   2 +-
 arch/powerpc/platforms/8xx/Kconfig            |   1 +
 arch/powerpc/platforms/8xx/cpm1.c             |   2 +-
 arch/powerpc/platforms/Kconfig                |   2 +
 arch/powerpc/sysdev/cpm_common.c              |   2 +-
 arch/sh/Kconfig                               |   1 -
 arch/sh/boards/board-magicpanelr2.c           |   1 +
 arch/sh/boards/mach-ap325rxa/setup.c          |   7 +-
 arch/sh/include/asm/gpio.h                    |  45 ------
 drivers/gpio/Kconfig                          |  19 ++-
 drivers/gpio/TODO                             |  15 +-
 drivers/gpio/gpio-aggregator.c                |   9 +-
 drivers/gpio/gpio-altera.c                    |   2 +-
 drivers/gpio/gpio-davinci.c                   |   2 -
 drivers/gpio/gpio-mm-lantiq.c                 |   2 +-
 drivers/gpio/gpio-mpc5200.c                   |   2 +-
 drivers/gpio/gpio-reg.c                       |  12 +-
 drivers/gpio/gpio-regmap.c                    |  12 +-
 drivers/gpio/gpiolib-acpi.c                   |  10 +-
 drivers/gpio/gpiolib-acpi.h                   |   1 -
 drivers/gpio/gpiolib-of.c                     |   9 +-
 drivers/gpio/gpiolib-of.h                     |   1 -
 drivers/gpio/gpiolib-swnode.c                 |   5 +-
 drivers/gpio/gpiolib-sysfs.c                  |  25 ++-
 drivers/gpio/gpiolib.c                        |   9 +-
 drivers/hte/hte-tegra194-test.c               |  10 +-
 drivers/input/touchscreen/ads7846.c           |   5 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c       |  10 +-
 drivers/net/ieee802154/ca8210.c               |   3 +-
 .../broadcom/brcm80211/brcmsmac/led.c         |   1 +
 drivers/pinctrl/core.c                        |   1 -
 drivers/soc/fsl/qe/gpio.c                     |   2 +-
 include/asm-generic/gpio.h                    | 147 ------------------
 include/linux/gpio.h                          | 104 ++++++++-----
 include/linux/gpio/consumer.h                 |  24 +--
 include/linux/gpio/driver.h                   |  31 +++-
 .../legacy-of-mm-gpiochip.h}                  |  33 +---
 include/linux/mfd/ucb1x00.h                   |   1 +
 include/linux/of_gpio.h                       |  21 ---
 56 files changed, 240 insertions(+), 556 deletions(-)
 delete mode 100644 arch/arm/include/asm/gpio.h
 delete mode 100644 arch/m68k/include/asm/gpio.h
 delete mode 100644 arch/sh/include/asm/gpio.h
 delete mode 100644 include/asm-generic/gpio.h
 copy include/linux/{of_gpio.h => gpio/legacy-of-mm-gpiochip.h} (50%)

-- 
2.39.1

