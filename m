Return-Path: <netdev+bounces-7683-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5AD77211FF
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 22:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D90202817B8
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 20:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 087D2E57C;
	Sat,  3 Jun 2023 20:03:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17C320EB
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 20:03:12 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD9418D;
	Sat,  3 Jun 2023 13:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685822591; x=1717358591;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d01tRDxvZ5T+IIbhLGGRzLix+V9DNdmXlY+ubhvrJgA=;
  b=m2LwGDPl1RQ4G2TgvLKCRod321ZEh9jqV6HWCZfH0ashx9gyPUqhbb2v
   7hlYRGH2gtWhS0jAgvo6S2Nz/WyQCLCc0KbGYzlmAdVNgw2zZgOZmlDib
   GKmdlY0tnphPmaJv12XDpCvMSF8uiGUsGpi38fYrRnfgjkhFelPlR8FPj
   jBDYmAkafWNKw/ZYzatJgg7zrAWn8kcpXoxDYfuomJ7vjbSRDLG/343wV
   SBuElDQyebhhkpqEcpsPpI/FaENqc73yiyXeHWoA4qM7Ypn0ps994uWho
   uytp8uDFNxeLfxX+rB9ffTvu75Yc5jqso4dm/ztqAnJiG24qmCzXaZAGq
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; 
   d="scan'208";a="155388154"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jun 2023 13:03:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 3 Jun 2023 13:03:07 -0700
Received: from che-lt-i67070.amer.actel.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sat, 3 Jun 2023 13:02:55 -0700
From: Varshini Rajendran <varshini.rajendran@microchip.com>
To: <tglx@linutronix.de>, <maz@kernel.org>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <conor+dt@kernel.org>,
	<nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
	<claudiu.beznea@microchip.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <gregkh@linuxfoundation.org>,
	<linux@armlinux.org.uk>, <mturquette@baylibre.com>, <sboyd@kernel.org>,
	<sre@kernel.org>, <broonie@kernel.org>, <varshini.rajendran@microchip.com>,
	<arnd@arndb.de>, <gregory.clement@bootlin.com>, <sudeep.holla@arm.com>,
	<balamanikandan.gunasundar@microchip.com>, <mihai.sain@microchip.com>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, <linux-clk@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: <Hari.PrasathGE@microchip.com>, <cristian.birsan@microchip.com>,
	<durai.manickamkr@microchip.com>, <manikandan.m@microchip.com>,
	<dharma.b@microchip.com>, <nayabbasha.sayed@microchip.com>,
	<balakrishnan.s@microchip.com>
Subject: [PATCH 00/21] Add support for sam9x7 SoC family
Date: Sun, 4 Jun 2023 01:32:22 +0530
Message-ID: <20230603200243.243878-1-varshini.rajendran@microchip.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch series adds support for the new SoC family - sam9x7.
 - The device tree, configs and drivers are added
 - Clock driver for sam9x7 is added
 - Support for basic peripherals is added

Balamanikandan Gunasundar (1):
  ARM: configs: at91: Enable csi and isc support

Hari Prasath (1):
  irqchip/atmel-aic5: Add support for sam9x7 aic

Nicolas Ferre (1):
  net: macb: add support for gmac to sam9x7

Varshini Rajendran (18):
  dt-bindings: microchip: atmel,at91rm9200-tcb: add sam9x60 compatible
  dt-bindings: usb: ehci: Add atmel at91sam9g45-ehci compatible
  dt-bindings: usb: generic-ehci: Document clock-names property
  ARM: dts: at91: sam9x7: add device tree for soc
  ARM: configs: at91: enable config flags for sam9x7 SoC
  ARM: configs: at91: add mcan support
  ARM: at91: pm: add support for sam9x7 soc family
  ARM: at91: pm: add sam9x7 soc init config
  ARM: at91: Kconfig: add config flag for SAM9X7 SoC
  ARM: at91: add support in soc driver for new sam9x7
  clk: at91: clk-sam9x60-pll: re-factor to support individual core freq
    outputs
  clk: at91: sam9x7: add support for HW PLL freq dividers
  clk: at91: sam9x7: add sam9x7 pmc driver
  dt-bindings: irqchip/atmel-aic5: Add support for sam9x7 aic
  power: reset: at91-poweroff: lookup for proper pmc dt node for sam9x7
  power: reset: at91-reset: add reset support for sam9x7 soc
  power: reset: at91-reset: add sdhwc support for sam9x7 soc
  dt-bindings: net: cdns,macb: add documentation for sam9x7 ethernet
    interface

 .../interrupt-controller/atmel,aic.txt        |    2 +-
 .../devicetree/bindings/net/cdns,macb.yaml    |    1 +
 .../soc/microchip/atmel,at91rm9200-tcb.yaml   |    1 +
 .../devicetree/bindings/usb/generic-ehci.yaml |    5 +
 arch/arm/boot/dts/sam9x7.dtsi                 | 1333 +++++++++++++++++
 arch/arm/configs/at91_dt_defconfig            |    8 +
 arch/arm/mach-at91/Kconfig                    |   21 +-
 arch/arm/mach-at91/Makefile                   |    1 +
 arch/arm/mach-at91/generic.h                  |    2 +
 arch/arm/mach-at91/pm.c                       |   35 +
 arch/arm/mach-at91/sam9x7.c                   |   34 +
 drivers/clk/at91/Makefile                     |    1 +
 drivers/clk/at91/clk-sam9x60-pll.c            |   50 +-
 drivers/clk/at91/pmc.h                        |    2 +
 drivers/clk/at91/sam9x60.c                    |    7 +
 drivers/clk/at91/sam9x7.c                     |  947 ++++++++++++
 drivers/clk/at91/sama7g5.c                    |    7 +
 drivers/irqchip/irq-atmel-aic5.c              |   10 +
 drivers/net/ethernet/cadence/macb_main.c      |    1 +
 drivers/power/reset/Kconfig                   |    4 +-
 drivers/power/reset/at91-sama5d2_shdwc.c      |    1 +
 drivers/soc/atmel/soc.c                       |   23 +
 drivers/soc/atmel/soc.h                       |    9 +
 23 files changed, 2489 insertions(+), 16 deletions(-)
 create mode 100644 arch/arm/boot/dts/sam9x7.dtsi
 create mode 100644 arch/arm/mach-at91/sam9x7.c
 create mode 100644 drivers/clk/at91/sam9x7.c

-- 
2.25.1


