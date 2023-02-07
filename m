Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB9D68DAD9
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbjBGO3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbjBGO33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:29:29 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693F3190;
        Tue,  7 Feb 2023 06:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675780168; x=1707316168;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=slc0KZtNoZ1bsJm/e5gBRrLuxfQ5uLgrlphY9y9ttTg=;
  b=lpiMw+Bj0CmC8rQDkHxuRJRcqbqGh5mJ1leqs4iGwudehS+pojE39vvU
   6ccy9coHWxN94L3+2Y4tRFFTOScYKWknUgvwm7t8LM2YbtQx2gd2qqQeQ
   z+/ePK5laZ7hfRnru1ZbEYlq5ko8KlFQoSnq3XpHWyqfwaVPoJAR6gmIh
   bRIW5cOl7/0k6e4G5SM0YdkQw0EQaz9MXmaT0tMISgBCQVt3xIXqLc/Nj
   OwahdjmUl6Tf+gi+7pmOlu0SHgVrAJ7iNg1NoScMS06EhxUx3G4RxOAh9
   6WsVz1p7c9WYZnMSHQ39ynhAZF1AfcL5Rxrkj3ooUBue/uvog+2hqDPcn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="329537327"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="329537327"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 06:29:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="790811308"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="790811308"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 07 Feb 2023 06:29:22 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 95C3D1C5; Tue,  7 Feb 2023 16:30:00 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Devarsh Thakkar <devarsht@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
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
        Li Yang <leoyang.li@nxp.com>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: [PATCH v3 00/12] gpiolib cleanups
Date:   Tue,  7 Feb 2023 16:29:40 +0200
Message-Id: <20230207142952.51844-1-andriy.shevchenko@linux.intel.com>
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
linux-next-20230207. On top there are Andy's patches regarding
similar topic.

The main goal is to remove some of the legacy bits of the gpiolib
interfaces, where the corner cases are easily avoided or replaced
with gpio descriptor based interfaces.

Changes in v3:
- reworked touchscreen patch in accordance with Dmitry's comments
- rebased on the latest Linux Next
- added on top Andy's series

Changes in v2:
- dropped patch 8 after Andy's identical patch was merged
- rebase on latest gpio tree
- leave unused gpio_cansleep() in place for now
- address feedback from Andy Shevchenko

Andy Shevchenko (5):
  gpio: aggregator: Add missing header(s)
  gpiolib: Drop unused forward declaration from driver.h
  gpiolib: Deduplicate forward declarations in consumer.h
  gpiolib: Group forward declarations in consumer.h
  gpiolib: Clean up headers

Arnd Bergmann (7):
  gpiolib: remove empty asm/gpio.h files
  gpiolib: coldfire: remove custom asm/gpio.h
  gpiolib: remove asm-generic/gpio.h
  gpiolib: remove gpio_set_debounce
  gpiolib: remove legacy gpio_export
  gpiolib: split linux/gpio/driver.h out of linux/gpio.h
  gpiolib: split of_mm_gpio_chip out of linux/of_gpio.h

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
 arch/arm/mach-s3c/s3c64xx.c                   |   1 +
 arch/arm/mach-sa1100/assabet.c                |   1 +
 arch/arm/plat-orion/gpio.c                    |   1 +
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
 drivers/gpio/gpiolib-acpi.c                   |  10 +-
 drivers/gpio/gpiolib-acpi.h                   |   1 -
 drivers/gpio/gpiolib-of.c                     |   9 +-
 drivers/gpio/gpiolib-of.h                     |   1 -
 drivers/gpio/gpiolib-swnode.c                 |   5 +-
 drivers/gpio/gpiolib-sysfs.c                  |  25 ++-
 drivers/gpio/gpiolib.c                        |   9 +-
 drivers/input/touchscreen/ads7846.c           |  24 +--
 drivers/media/pci/sta2x11/sta2x11_vip.c       |  10 +-
 drivers/net/ieee802154/ca8210.c               |   3 +-
 .../broadcom/brcm80211/brcmsmac/led.c         |   1 +
 drivers/pinctrl/core.c                        |   1 -
 drivers/soc/fsl/qe/gpio.c                     |   2 +-
 include/asm-generic/gpio.h                    | 147 ------------------
 include/linux/gpio.h                          | 100 +++++++-----
 include/linux/gpio/consumer.h                 |  24 +--
 include/linux/gpio/driver.h                   |  31 +++-
 .../legacy-of-mm-gpiochip.h}                  |  33 +---
 include/linux/mfd/ucb1x00.h                   |   1 +
 include/linux/of_gpio.h                       |  21 ---
 53 files changed, 223 insertions(+), 549 deletions(-)
 delete mode 100644 arch/arm/include/asm/gpio.h
 delete mode 100644 arch/m68k/include/asm/gpio.h
 delete mode 100644 arch/sh/include/asm/gpio.h
 delete mode 100644 include/asm-generic/gpio.h
 copy include/linux/{of_gpio.h => gpio/legacy-of-mm-gpiochip.h} (50%)

-- 
2.39.1

