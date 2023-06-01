Return-Path: <netdev+bounces-6986-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 345F671923A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B37801C20E90
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40EC923D9;
	Thu,  1 Jun 2023 05:36:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD5023BD
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 05:36:38 +0000 (UTC)
Received: from forward103c.mail.yandex.net (forward103c.mail.yandex.net [178.154.239.214])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA3B12C;
	Wed, 31 May 2023 22:36:33 -0700 (PDT)
Received: from mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net [IPv6:2a02:6b8:c14:c83:0:640:84f9:0])
	by forward103c.mail.yandex.net (Yandex) with ESMTP id 876CE60034;
	Thu,  1 Jun 2023 08:36:31 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id OaGNfZvWv8c0-rplx70Eu;
	Thu, 01 Jun 2023 08:36:29 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maquefel.me; s=mail; t=1685597789;
	bh=rKQamNImlHihihpCtMqa3NY6MH0zfAt9r9tz/gnwKhU=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=o7eo6GHX+CIkTm9XpERfV5KmgewSkfhAGjpH+qged8wI9HIvSeQK6CKQsunVh2WIS
	 3darRHyfPqrLqK1akxKMExkio1no9yS55iTd0E1JNR6uK3ykW0XZNimKJxx1Xo0JfL
	 qtH6YU9ygcZbO9L8bdSh8KaLkTD+keRMb44jcTrM=
Authentication-Results: mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net; dkim=pass header.i=@maquefel.me
From: Nikita Shubin <nikita.shubin@maquefel.me>
To: Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Hartley Sweeten <hsweeten@visionengravers.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>,
	Jean Delvare <jdelvare@suse.de>,
	Joel Stanley <joel@jms.id.au>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Le Moal <dlemoal@kernel.org>,
	Liang Yang <liang.yang@amlogic.com>,
	Mark Brown <broonie@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Nicolas Saenz Julienne <nsaenz@kernel.org>,
	Nikita Shubin <nikita.shubin@maquefel.me>,
	Richard Weinberger <richard@nod.at>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Walker Chen <walker.chen@starfivetech.com>,
	Yinbo Zhu <zhuyinbo@loongson.cn>
Cc: Michael Peters <mpeters@embeddedTS.com>,
	Kris Bahnsen <kris@embeddedTS.com>,
	alsa-devel@alsa-project.org,
	devicetree@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-clk@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-pm@vger.kernel.org,
	linux-pwm@vger.kernel.org,
	linux-rtc@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-watchdog@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v1 00/43] ep93xx device tree conversion
Date: Thu,  1 Jun 2023 08:33:51 +0300
Message-Id: <20230601053546.9574-1-nikita.shubin@maquefel.me>
X-Mailer: git-send-email 2.37.4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series aims to convert ep93xx from platform to full device tree support.

Alexander, Kris - there are some significant changes in clk and pinctrl so can i ask you to tests all once again.

So i am not applying:

Tested-by: Michael Peters <mpeters@embeddedTS.com>
Reviewed-by: Kris Bahnsen <kris@embeddedTS.com>

Tags yet.

Major changes from v0 to v1:

- I totally forgot to include dts bindings for USB, they are working, including in this version
- retinkered ep93xx keypad, the stange thing about it that it always used zeroed 
  platform data from the very beginning - my first impulse was to remove it entirely, espesially 
  it's ep9307+ variant, which Alexander and me doesn't have
- major YAML bindings overhaul according to Krzysztof comments
- nand helper converted to LEGACY nand controller
- cleanup clk
- cleanup pinctrl

Sorry if i missed something, first time handling such a big (at least for me) chunk of patches.

Next version should be much faster spin.

Alexandre Belloni:
 st,m48t86 is totally trivial, but it has 2 regs instead of one, so dt_binding_check doesn't allow it in trivial.yaml,
 regs should be increased to "maxItems: 2"

Miquel Raynal:
 Currently made it LEGACY as a more easier way for now, as this series will merge - it will be much 
 easier to cleanup the rest one by one, i hope it's ok.
 
Stephen Boyd:
 Majory of issues fixed, but:
     - removing dma from init section requires converting it from half dt/platform monstrosity 
       into fully dt compatible
     - i would like to have ep93xx_clk_data and ep93xx_map global for now - they can be removed 
       once dma subsys_initcall removed

Andrew Lunn:
  I've tinkered with the preferred way, however this involves turning on
     - CONFIG_PHYLIB
     - CONFIG_MDIO_DEVICE

  And maybe CONFIG_MICREL_PHY (at least for me, unless i can use some
  common phy driver) which implies a kernel size increase - which is
  undesirable for us.
  
  Can we slip by getting phyid directly from device tree in ep93xx_eth ?

Link: https://lore.kernel.org/all/20230424123522.18302-1-nikita.shubin@maquefel.me/
  
Cc: kris@embeddedTS.com

Alexander Sverdlin (3):
  ARM: dts: ep93xx: Add I2S and AC97 nodes
  ARM: dts: ep93xx: Add EDB9302 DT
  ASoC: cirrus: edb93xx: Delete driver

Nikita Shubin (40):
  gpio: ep93xx: split device in multiple
  dt-bindings: soc: Add Cirrus EP93xx
  soc: Add SoC driver for Cirrus ep93xx
  dt-bindings: clock: Add Cirrus EP93xx
  clk: ep93xx: add DT support for Cirrus EP93xx
  dt-bindings: pinctrl: Add Cirrus EP93xx
  pinctrl: add a Cirrus ep93xx SoC pin controller
  dt-bindings: timers: Add Cirrus EP93xx
  clocksource: ep93xx: Add driver for Cirrus Logic EP93xx
  dt-bindings: rtc: Add Cirrus EP93xx
  rtc: ep93xx: add DT support for Cirrus EP93xx
  dt-bindings: watchdog: Add Cirrus EP93x
  watchdog: ep93xx: add DT support for Cirrus EP93xx
  power: reset: Add a driver for the ep93xx reset
  dt-bindings: pwm: Add Cirrus EP93xx
  pwm: ep93xx: add DT support for Cirrus EP93xx
  dt-bindings: spi: Add Cirrus EP93xx
  spi: ep93xx: add DT support for Cirrus EP93xx
  dt-bindings: net: Add Cirrus EP93xx
  net: cirrus: add DT support for Cirrus EP93xx
  dt-bindings: dma: Add Cirrus EP93xx
  dma: cirrus: add DT support for Cirrus EP93xx
  dt-bindings: mtd: Add ts7250 nand-controller
  mtd: nand: add support for ts72xx
  dt-bindings: ata: Add Cirrus EP93xx
  pata: cirrus: add DT support for Cirrus EP93xx
  dt-bindings: input: Add Cirrus EP93xx keypad
  input: keypad: ep93xx: add DT support for Cirrus EP93xx
  dt-bindings: rtc: Add ST M48T86
  rtc: m48t86: add DT support for m48t86
  dt-bindings: wdt: Add ts72xx
  wdt: ts72xx: add DT support for ts72xx
  dt-bindings: gpio: Add Cirrus EP93xx
  gpio: ep93xx: add DT support for gpio-ep93xx
  ARM: dts: add device tree for ep93xx Soc
  ARM: ep93xx: DT for the Cirrus ep93xx SoC platforms
  pwm: ep93xx: drop legacy pinctrl
  pata: cirrus: drop legacy pinctrl
  ARM: ep93xx: delete all boardfiles
  ARM: ep93xx: soc: drop defines

 .../devicetree/bindings/arm/ep93xx.yaml       |  107 ++
 .../bindings/ata/cirrus,ep9312-pata.yaml      |   44 +
 .../bindings/clock/cirrus,ep9301.yaml         |   64 +
 .../bindings/dma/cirrus,ep9301-dma-m2m.yaml   |   72 +
 .../bindings/dma/cirrus,ep9301-dma-m2p.yaml   |  124 ++
 .../devicetree/bindings/gpio/gpio-ep9301.yaml |  154 ++
 .../bindings/input/cirrus,ep9307-keypad.yaml  |   86 +
 .../bindings/mtd/technologic,nand.yaml        |   47 +
 .../bindings/net/cirrus,ep9301-eth.yaml       |   61 +
 .../pinctrl/cirrus,ep9301-pinctrl.yaml        |   66 +
 .../bindings/pwm/cirrus,ep9301-pwm.yaml       |   48 +
 .../bindings/rtc/cirrus,ep9301-rtc.yaml       |   40 +
 .../bindings/rtc/st,m48t86-rtc.yaml           |   38 +
 .../devicetree/bindings/spi/spi-ep9301.yaml   |   69 +
 .../bindings/timer/cirrus,ep9301-timer.yaml   |   49 +
 .../bindings/watchdog/cirrus,ep9301-wdt.yaml  |   46 +
 .../watchdog/technologic,ts7200-wdt.yaml      |   46 +
 arch/arm/Makefile                             |    1 -
 arch/arm/boot/dts/Makefile                    |    1 +
 arch/arm/boot/dts/ep93xx-bk3.dts              |  119 ++
 arch/arm/boot/dts/ep93xx-edb9302.dts          |  160 ++
 arch/arm/boot/dts/ep93xx-ts7250.dts           |  132 ++
 arch/arm/boot/dts/ep93xx.dtsi                 |  477 +++++
 arch/arm/mach-ep93xx/Kconfig                  |   20 +-
 arch/arm/mach-ep93xx/Makefile                 |   11 -
 arch/arm/mach-ep93xx/clock.c                  |  733 --------
 arch/arm/mach-ep93xx/core.c                   | 1017 ----------
 arch/arm/mach-ep93xx/dma.c                    |  114 --
 arch/arm/mach-ep93xx/edb93xx.c                |  344 ----
 arch/arm/mach-ep93xx/ep93xx-regs.h            |   38 -
 arch/arm/mach-ep93xx/gpio-ep93xx.h            |  111 --
 arch/arm/mach-ep93xx/hardware.h               |   25 -
 arch/arm/mach-ep93xx/irqs.h                   |   76 -
 arch/arm/mach-ep93xx/platform.h               |   42 -
 arch/arm/mach-ep93xx/soc.h                    |  212 ---
 arch/arm/mach-ep93xx/ts72xx.c                 |  422 -----
 arch/arm/mach-ep93xx/ts72xx.h                 |   94 -
 arch/arm/mach-ep93xx/vision_ep9307.c          |  311 ---
 drivers/ata/pata_ep93xx.c                     |   33 +-
 drivers/clk/Kconfig                           |    8 +
 drivers/clk/Makefile                          |    1 +
 drivers/clk/clk-ep93xx.c                      |  850 +++++++++
 drivers/clocksource/Kconfig                   |   11 +
 drivers/clocksource/Makefile                  |    1 +
 .../clocksource}/timer-ep93xx.c               |  141 +-
 drivers/dma/ep93xx_dma.c                      |  136 +-
 drivers/gpio/gpio-ep93xx.c                    |  329 ++--
 drivers/input/keyboard/ep93xx_keypad.c        |   78 +-
 drivers/mtd/nand/raw/Kconfig                  |    7 +
 drivers/mtd/nand/raw/Makefile                 |    1 +
 .../nand/raw/technologic-nand-controller.c    |  151 ++
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |   67 +-
 drivers/pinctrl/Kconfig                       |    7 +
 drivers/pinctrl/Makefile                      |    1 +
 drivers/pinctrl/pinctrl-ep93xx.c              | 1672 +++++++++++++++++
 drivers/power/reset/Kconfig                   |   10 +
 drivers/power/reset/Makefile                  |    1 +
 drivers/power/reset/ep93xx-restart.c          |   65 +
 drivers/pwm/pwm-ep93xx.c                      |   26 +-
 drivers/rtc/rtc-ep93xx.c                      |    8 +
 drivers/rtc/rtc-m48t86.c                      |    8 +
 drivers/soc/Kconfig                           |    1 +
 drivers/soc/Makefile                          |    1 +
 drivers/soc/cirrus/Kconfig                    |   11 +
 drivers/soc/cirrus/Makefile                   |    2 +
 drivers/soc/cirrus/soc-ep93xx.c               |  134 ++
 drivers/spi/spi-ep93xx.c                      |   31 +-
 drivers/watchdog/ep93xx_wdt.c                 |    8 +
 drivers/watchdog/ts72xx_wdt.c                 |    8 +
 .../dt-bindings/clock/cirrus,ep93xx-clock.h   |   53 +
 include/linux/platform_data/dma-ep93xx.h      |    3 +
 include/linux/platform_data/eth-ep93xx.h      |   10 -
 include/linux/platform_data/keypad-ep93xx.h   |   32 -
 include/linux/soc/cirrus/ep93xx.h             |   40 +-
 sound/soc/cirrus/Kconfig                      |    9 -
 sound/soc/cirrus/Makefile                     |    4 -
 sound/soc/cirrus/edb93xx.c                    |  117 --
 77 files changed, 5575 insertions(+), 4122 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/ep93xx.yaml
 create mode 100644 Documentation/devicetree/bindings/ata/cirrus,ep9312-pata.yaml
 create mode 100644 Documentation/devicetree/bindings/clock/cirrus,ep9301.yaml
 create mode 100644 Documentation/devicetree/bindings/dma/cirrus,ep9301-dma-m2m.yaml
 create mode 100644 Documentation/devicetree/bindings/dma/cirrus,ep9301-dma-m2p.yaml
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-ep9301.yaml
 create mode 100644 Documentation/devicetree/bindings/input/cirrus,ep9307-keypad.yaml
 create mode 100644 Documentation/devicetree/bindings/mtd/technologic,nand.yaml
 create mode 100644 Documentation/devicetree/bindings/net/cirrus,ep9301-eth.yaml
 create mode 100644 Documentation/devicetree/bindings/pinctrl/cirrus,ep9301-pinctrl.yaml
 create mode 100644 Documentation/devicetree/bindings/pwm/cirrus,ep9301-pwm.yaml
 create mode 100644 Documentation/devicetree/bindings/rtc/cirrus,ep9301-rtc.yaml
 create mode 100644 Documentation/devicetree/bindings/rtc/st,m48t86-rtc.yaml
 create mode 100644 Documentation/devicetree/bindings/spi/spi-ep9301.yaml
 create mode 100644 Documentation/devicetree/bindings/timer/cirrus,ep9301-timer.yaml
 create mode 100644 Documentation/devicetree/bindings/watchdog/cirrus,ep9301-wdt.yaml
 create mode 100644 Documentation/devicetree/bindings/watchdog/technologic,ts7200-wdt.yaml
 create mode 100644 arch/arm/boot/dts/ep93xx-bk3.dts
 create mode 100644 arch/arm/boot/dts/ep93xx-edb9302.dts
 create mode 100644 arch/arm/boot/dts/ep93xx-ts7250.dts
 create mode 100644 arch/arm/boot/dts/ep93xx.dtsi
 delete mode 100644 arch/arm/mach-ep93xx/Makefile
 delete mode 100644 arch/arm/mach-ep93xx/clock.c
 delete mode 100644 arch/arm/mach-ep93xx/core.c
 delete mode 100644 arch/arm/mach-ep93xx/dma.c
 delete mode 100644 arch/arm/mach-ep93xx/edb93xx.c
 delete mode 100644 arch/arm/mach-ep93xx/ep93xx-regs.h
 delete mode 100644 arch/arm/mach-ep93xx/gpio-ep93xx.h
 delete mode 100644 arch/arm/mach-ep93xx/hardware.h
 delete mode 100644 arch/arm/mach-ep93xx/irqs.h
 delete mode 100644 arch/arm/mach-ep93xx/platform.h
 delete mode 100644 arch/arm/mach-ep93xx/soc.h
 delete mode 100644 arch/arm/mach-ep93xx/ts72xx.c
 delete mode 100644 arch/arm/mach-ep93xx/ts72xx.h
 delete mode 100644 arch/arm/mach-ep93xx/vision_ep9307.c
 create mode 100644 drivers/clk/clk-ep93xx.c
 rename {arch/arm/mach-ep93xx => drivers/clocksource}/timer-ep93xx.c (52%)
 create mode 100644 drivers/mtd/nand/raw/technologic-nand-controller.c
 create mode 100644 drivers/pinctrl/pinctrl-ep93xx.c
 create mode 100644 drivers/power/reset/ep93xx-restart.c
 create mode 100644 drivers/soc/cirrus/Kconfig
 create mode 100644 drivers/soc/cirrus/Makefile
 create mode 100644 drivers/soc/cirrus/soc-ep93xx.c
 create mode 100644 include/dt-bindings/clock/cirrus,ep93xx-clock.h
 delete mode 100644 include/linux/platform_data/eth-ep93xx.h
 delete mode 100644 include/linux/platform_data/keypad-ep93xx.h
 delete mode 100644 sound/soc/cirrus/edb93xx.c

-- 
2.37.4


