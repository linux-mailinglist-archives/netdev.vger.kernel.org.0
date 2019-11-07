Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D519F2C5B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388096AbfKGKbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:31:22 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.176]:11950 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387638AbfKGKbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573122677;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=mNLH4riRUq1p8a4+5caD9BLFnhL7l1H/pJL1Sfpeh3w=;
        b=HOg3eAGta7IEuaix9UVBtB9iYyXaqKJtzr/BBrQPR/bsKGRVAjTvPIghpTRHflKIS0
        lzOxtLB7OYUttwI7bBeAfbh5TmSl1sv8L0wxBiE2iFswjrgQDODNRzA04IBfZtuB8O2I
        uOpHflqHOdcQfeer74/cu8Jem4hCpY3nvgeNnUzJGL9TN85aKJZgMZBlQrp5jNP0jsTd
        X2CcU2cZpT5m7BfMZMrnAAjVCXB4M+ilDtoWqQ1OXpA/vDSqWoWJm5Y3UOaI2kcA3WRi
        eEZ1ArMyCZuzhVjOcrXGLJO6xc3pbMIbpSsFI3WZkymdLgXoQ2ELjT89z8DtU7dzYRxU
        jGEA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M7PR5/L9P0"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vA7AUpdRu
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 7 Nov 2019 11:30:51 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Subject: [PATCH v3 05/12] omap: pdata-quirks: revert pandora specific gpiod additions
Date:   Thu,  7 Nov 2019 11:30:38 +0100
Message-Id: <a90b488031c3d5da2feb2f157efa6c4287cf1922.1573122644.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573122644.git.hns@goldelico.com>
References: <cover.1573122644.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

introduced by commit

efdfeb079cc3b ("regulator: fixed: Convert to use GPIO descriptor only")

We must remove this from mainline first, so that the following patch
to remove the openpandora quirks for mmc3 and wl1251 cleanly applies
to stable v4.9, v4.14, v4.19 where the above mentioned patch is not yet
present.

Since the code affected is removed (no pandora gpios in pdata-quirks
and more), there will be no matching revert-of-the-revert.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 arch/arm/mach-omap2/pdata-quirks.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 2efd18e8824c..800a602c06ec 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -7,7 +7,6 @@
 #include <linux/clk.h>
 #include <linux/davinci_emac.h>
 #include <linux/gpio.h>
-#include <linux/gpio/machine.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/of_platform.h>
@@ -334,7 +333,9 @@ static struct regulator_init_data pandora_vmmc3 = {
 static struct fixed_voltage_config pandora_vwlan = {
 	.supply_name		= "vwlan",
 	.microvolts		= 1800000, /* 1.8V */
+	.gpio			= PANDORA_WIFI_NRESET_GPIO,
 	.startup_delay		= 50000, /* 50ms */
+	.enable_high		= 1,
 	.init_data		= &pandora_vmmc3,
 };
 
@@ -346,19 +347,6 @@ static struct platform_device pandora_vwlan_device = {
 	},
 };
 
-static struct gpiod_lookup_table pandora_vwlan_gpiod_table = {
-	.dev_id = "reg-fixed-voltage.1",
-	.table = {
-		/*
-		 * As this is a low GPIO number it should be at the first
-		 * GPIO bank.
-		 */
-		GPIO_LOOKUP("gpio-0-31", PANDORA_WIFI_NRESET_GPIO,
-			    NULL, GPIO_ACTIVE_HIGH),
-		{ },
-	},
-};
-
 static void pandora_wl1251_init_card(struct mmc_card *card)
 {
 	/*
@@ -380,6 +368,8 @@ static struct omap2_hsmmc_info pandora_mmc3[] = {
 	{
 		.mmc		= 3,
 		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_POWER_OFF_CARD,
+		.gpio_cd	= -EINVAL,
+		.gpio_wp	= -EINVAL,
 		.init_card	= pandora_wl1251_init_card,
 	},
 	{}	/* Terminator */
@@ -418,7 +408,6 @@ static void __init pandora_wl1251_init(void)
 static void __init omap3_pandora_legacy_init(void)
 {
 	platform_device_register(&pandora_backlight);
-	gpiod_add_lookup_table(&pandora_vwlan_gpiod_table);
 	platform_device_register(&pandora_vwlan_device);
 	omap_hsmmc_init(pandora_mmc3);
 	omap_hsmmc_late_init(pandora_mmc3);
-- 
2.23.0

