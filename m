Return-Path: <netdev+bounces-7693-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52830721246
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 22:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D74F2819C8
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 20:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18093FBEF;
	Sat,  3 Jun 2023 20:05:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A92EE57E
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 20:05:38 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F036E66;
	Sat,  3 Jun 2023 13:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685822719; x=1717358719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n3ILkFBfh9UZ4UHKI4Ru752YIb0DQoRd9ssi4xgvZUI=;
  b=NR1/JIZuEV4DRD8CVcV+WnBgMJ67Xh4S/pzh7/ff6ukgvItyieJhswXs
   AJXsgfU3eJRjp43GcORJBVuU6qMIKa2BIu9/RPtfFMoMlB7CJm9pEl0sb
   aDdSaq0zbuI7cQ+egJubF8j+VroQENKRd0ZWPTCtjbg7njHWaIELSci17
   8tw/pHcqgGtqhxE64jIuM2N1t0M/713/jvKGgbNAnYD0/nH507R3CN512
   xanBE59jIijyt9aTl+yRNgJ9ZBxJ6RJrb2pDD30fZc0Z6QECx4bK/GpLe
   iuOdy5ERuIVWzyeFeCjSDJyZzWcWQqzQekCu2xP3A+jkZ/XRO9R7WyEz9
   w==;
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; 
   d="scan'208";a="228307953"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jun 2023 13:05:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 3 Jun 2023 13:05:17 -0700
Received: from che-lt-i67070.amer.actel.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sat, 3 Jun 2023 13:05:05 -0700
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
Subject: [PATCH 10/21] ARM: at91: Kconfig: add config flag for SAM9X7 SoC
Date: Sun, 4 Jun 2023 01:32:32 +0530
Message-ID: <20230603200243.243878-11-varshini.rajendran@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230603200243.243878-1-varshini.rajendran@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
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

Add config flag for sam9x7 SoC

Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
---
 arch/arm/mach-at91/Kconfig | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 3dd9e718661b..4463afd7298a 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -143,11 +143,28 @@ config SOC_SAM9X60
 	help
 	  Select this if you are using Microchip's SAM9X60 SoC
 
+config SOC_SAM9X7
+	bool "SAM9X7"
+	depends on ARCH_MULTI_V5
+	select ATMEL_AIC5_IRQ
+	select ATMEL_PM if PM
+	select ATMEL_SDRAMC
+	select CPU_ARM926T
+	select HAVE_AT91_USB_CLK
+	select HAVE_AT91_GENERATED_CLK
+	select HAVE_AT91_SAM9X60_PLL
+	select MEMORY
+	select PINCTRL_AT91
+	select SOC_SAM_V4_V5
+	select SRAM if PM
+	help
+	  Select this if you are using Microchip's SAM9X7 SoC
+
 comment "Clocksource driver selection"
 
 config ATMEL_CLOCKSOURCE_PIT
 	bool "Periodic Interval Timer (PIT) support"
-	depends on SOC_AT91SAM9 || SOC_SAM9X60 || SOC_SAMA5
+	depends on SOC_AT91SAM9 || SOC_SAM9X60 || SOC_SAM9X7 || SOC_SAMA5
 	default SOC_AT91SAM9 || SOC_SAMA5
 	select ATMEL_PIT
 	help
@@ -157,7 +174,7 @@ config ATMEL_CLOCKSOURCE_PIT
 
 config ATMEL_CLOCKSOURCE_TCB
 	bool "Timer Counter Blocks (TCB) support"
-	default SOC_AT91RM9200 || SOC_AT91SAM9 || SOC_SAM9X60 || SOC_SAMA5
+	default SOC_AT91RM9200 || SOC_AT91SAM9 || SOC_SAM9X60 || SOC_SAM9X7 || SOC_SAMA5
 	select ATMEL_TCB_CLKSRC
 	help
 	  Select this to get a high precision clocksource based on a
-- 
2.25.1


