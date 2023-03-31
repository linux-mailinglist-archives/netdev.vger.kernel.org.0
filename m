Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995336D19F7
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjCaIev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjCaIes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:34:48 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E397DB474
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:45 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e18so21583083wra.9
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251684;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wKmFDwBzmqKaD1W7wuLHbQZgTpJgWQagzC13l4DdTqw=;
        b=ez7Y8DKhU9m8mENWYc8eLh3UjQj04JKUYpk8LZc0Cgj82lGXgAqKThXbmY29WwZFpa
         8iJCKddXPmrHzPzXLQ682kWfEp0XTxPc6/GH5fWihQi5njtBGVCzQSKchgik6ZjPxGVs
         LJ6kI8ENaL4ylviyHLejBooWU1vyhc5pUBM2V6BzXIypiwp1tF0C80ee0BcHRFohBjvs
         PS3KjixZZ5L0SEv7mF4LYg/aatUGXQwxrjYjN3GBCSHubljOca4C/g7Smtoai9yEYKM2
         MPuBgGNvstDtP1p1JijRIUW+SkbLI/c5/0B4ugSh+dx2vHET0l1a/8etg25rGkrvIHls
         EkFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251684;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wKmFDwBzmqKaD1W7wuLHbQZgTpJgWQagzC13l4DdTqw=;
        b=gLI/C4x7qb2tdf5m9LftTcrXhdfnInlA241mUGI2VpsXbr6PwrgoRxix0lkpiG/pQw
         NdEPfoQTnf1NVstflZRtouOIobK31fCQ+m+HBdR0cACIN/9krbuHME7/TGKWnWagscSz
         8eA2u1M5QybPA4Lbalp27EMCLaW6WASR2mWMm07tyJw7w3WK+SOxuEX1SzmuJEQrt9p/
         gsRo28kzPMPnP0ak/GgzGIT9MfPebvgcf32CNGDt5hze+oowMnh2IcGNRVdn8rlvln4z
         IYEA0s2fH6EvP3AAmk0DOFouaXuSHinsxo87THVMqJwkcFUhdEOVPp1jOSFXMuDP8dbD
         +Svg==
X-Gm-Message-State: AAQBX9fE7wu/3rBOicmvkFKHAZ43svEgB9ACgDAEkSRPA8whlM2iWBVs
        BLUbTdVGQRtS+8hXkZXSm4T24g==
X-Google-Smtp-Source: AKy350ZffcjiZSGBVm/JblhOGFpZodzn92ieAjz2v27srUZ+zaxOkeHyJPQUex2yEMscYYMGa2NW2w==
X-Received: by 2002:a5d:58c9:0:b0:2cf:e34c:a229 with SMTP id o9-20020a5d58c9000000b002cfe34ca229mr22477632wrf.8.1680251684116;
        Fri, 31 Mar 2023 01:34:44 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:34:43 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH RFC 00/20] ARM: oxnas support removal
Date:   Fri, 31 Mar 2023 10:34:38 +0200
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB6bJmQC/x2NwQqDMBAFf0X23AVNQLDXQj+g19JDjM+6oEnIq
 gjivzf0OHOYOUmRBUr36qSMXVRiKNDcKvKTC1+wDIXJ1MbW1ja8xiSe4xGc8pZ0zXALZyxxB7v
 WoBu6dgRApdA7BffZBT+VRtjmuciUMcrxX77p9XzQ57p+JL2B/4cAAAA=
To:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sebastian Reichel <sre@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With [1] removing MPCore SMP support, this makes the OX820 barely usable,
associated with a clear lack of maintainance, development and migration to
dt-schema it's clear that Linux support for OX810 and OX820 should be removed.

In addition, the OX810 hasn't been booted for years and isn't even present
in an ARM config file.

For the OX820, lack of USB and SATA support makes the platform not usable
in the current Linux support and relies on off-tree drivers hacked from the
vendor (defunct for years) sources.

The last users are in the OpenWRT distribution, and today's removal means
support will still be in stable 6.1 LTS kernel until end of 2026.

If someone wants to take over the development even with lack of SMP, I'll
be happy to hand off maintainance.

The plan is to apply the first 4 patches first, then the drivers
followed by bindings. Finally the MAINTAINANCE entry can be removed.

I'm not sure about the process of bindings removal, but perhaps the bindings
should be marked as deprecated first then removed later on ?

It has been a fun time adding support for this architecture, but it's time
to get over!

Patch 2 obviously depends on [1].

[1] https://lore.kernel.org/all/20230327121317.4081816-1-arnd@kernel.org/

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
Neil Armstrong (20):
      ARM: dts: oxnas: remove obsolete device tree files
      ARM: oxnas: remove OXNAS support
      ARM: configs: remove oxnas_v6_defconfig
      dt-bindings: arm: oxnas: remove obsolete bindings
      clk: oxnas: remove obsolete clock driver
      dt-bindings: clk: oxnas: remove obsolete bindings
      clksource: timer-oxnas-rps: remove obsolete timer driver
      dt-bindings: timer: oxsemi,rps-timer: remove obsolete bindings
      nand: oxnas_nand: remove obsolete raw nand driver
      dt-bindings: mtd: oxnas-nand: remove obsolete bindings
      net: stmmac: dwmac-oxnas: remove obsolete dwmac glue driver
      dt-bindings: net: oxnas-dwmac: remove obsolete bindings
      pinctrl: pinctrl-oxnas: remove obsolete pinctrl driver
      dt-bindings: pinctrl: oxnas,pinctrl: remove obsolete bindings
      dt-bindings: gpio: gpio_oxnas: remove obsolete bindings
      power: reset: oxnas-restart: remove obsolete restart driver
      reset: oxnas: remove obsolete reset driver
      irqchip: irq-versatile-fpga: remove obsolete oxnas compatible
      dt-bindings: interrupt-controller: arm,versatile-fpga-irq: mark oxnas compatible as deprecated
      MAINTAINERS: remove OXNAS entry

 Documentation/devicetree/bindings/arm/oxnas.txt    |   14 -
 .../devicetree/bindings/clock/oxnas,stdclk.txt     |   28 -
 .../devicetree/bindings/gpio/gpio_oxnas.txt        |   47 -
 .../arm,versatile-fpga-irq.txt                     |    4 +-
 .../devicetree/bindings/mtd/oxnas-nand.txt         |   41 -
 .../devicetree/bindings/net/oxnas-dwmac.txt        |   41 -
 .../devicetree/bindings/pinctrl/oxnas,pinctrl.txt  |   56 -
 .../devicetree/bindings/reset/oxnas,reset.txt      |   32 -
 .../devicetree/bindings/timer/oxsemi,rps-timer.txt |   17 -
 MAINTAINERS                                        |   10 -
 arch/arm/Makefile                                  |    1 -
 arch/arm/boot/dts/Makefile                         |    3 -
 arch/arm/boot/dts/ox810se-wd-mbwe.dts              |  115 --
 arch/arm/boot/dts/ox810se.dtsi                     |  357 ------
 .../dts/ox820-cloudengines-pogoplug-series-3.dts   |   93 --
 arch/arm/boot/dts/ox820.dtsi                       |  299 -----
 arch/arm/configs/oxnas_v6_defconfig                |   92 --
 arch/arm/mach-oxnas/Kconfig                        |   34 -
 arch/arm/mach-oxnas/Makefile                       |    1 -
 drivers/clk/Kconfig                                |    7 -
 drivers/clk/Makefile                               |    1 -
 drivers/clk/clk-oxnas.c                            |  251 ----
 drivers/clocksource/Kconfig                        |    7 -
 drivers/clocksource/Makefile                       |    1 -
 drivers/clocksource/timer-oxnas-rps.c              |  288 -----
 drivers/irqchip/irq-versatile-fpga.c               |    1 -
 drivers/mtd/nand/raw/Kconfig                       |    7 -
 drivers/mtd/nand/raw/Makefile                      |    1 -
 drivers/mtd/nand/raw/oxnas_nand.c                  |  211 ----
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   11 -
 drivers/net/ethernet/stmicro/stmmac/Makefile       |    1 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c  |  245 ----
 drivers/pinctrl/Kconfig                            |   11 -
 drivers/pinctrl/Makefile                           |    1 -
 drivers/pinctrl/pinctrl-oxnas.c                    | 1292 --------------------
 drivers/power/reset/Kconfig                        |    7 -
 drivers/power/reset/Makefile                       |    1 -
 drivers/power/reset/oxnas-restart.c                |  233 ----
 drivers/reset/Kconfig                              |    3 -
 drivers/reset/Makefile                             |    1 -
 drivers/reset/reset-oxnas.c                        |  114 --
 41 files changed, 3 insertions(+), 3977 deletions(-)
---
base-commit: df45499b419b31c4d44ef9f1d1656d1fc0897014
change-id: 20230331-topic-oxnas-upstream-remove-a62e9d96feee

Best regards,
-- 
Neil Armstrong <neil.armstrong@linaro.org>

