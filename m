Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B092EF2C40
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388362AbfKGKbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:31:53 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.123]:31917 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387847AbfKGKbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:31:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573122680;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=5FlhlVHuQf9tdBddvtWGtj7oyfs9DTstGeXr+k/1N4w=;
        b=grTmDZ/dk3f32hReNWkYMb4KQMEl+bFYEg+lJVYt4vloRL/6nD2GhM8VKFGH8b4iQL
        WVG/0XCRad80ZHNFE+4WyS6MCTQMzx4bvPEJcb+6EjRSphZUgKw2EleQaifj5Cf6EqBz
        dxfuRlBaM4hVg0ugXa2AXx68gjsMK+qBqBFZke4uJPpS56k9lbHNgNfIa160Vzsyoz0N
        jt0QeHiBsV6xqn13z3Mf+99yLOjKEfQCKw3r/HETCTN0SmVMfHAHCdk6VV/a3XScMrIg
        fBpZ1gxWTvyS7oZ5dKwHHr6D8AdhCqeGhaWpWMSSB6wy7vRsei0wUOGJ0VabBC684h4P
        xeUg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M7PR5/L9P0"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vA7AUqdRw
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 7 Nov 2019 11:30:52 +0100 (CET)
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
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: [PATCH v3 06/12] omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251
Date:   Thu,  7 Nov 2019 11:30:39 +0100
Message-Id: <ff450c14eb1e13d2db6533fa06e069c5bec3a0c4.1573122644.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573122644.git.hns@goldelico.com>
References: <cover.1573122644.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a wl1251 child node of mmc3 in the device tree decoded
in omap_hsmmc.c to handle special wl1251 initialization, we do
no longer need to instantiate the mmc3 through pdata quirks.

We also can remove the wlan regulator and reset/interrupt definitions
and do them through device tree.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # 4.7.0
---
 arch/arm/mach-omap2/pdata-quirks.c | 93 ------------------------------
 1 file changed, 93 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 800a602c06ec..1b7cf81ff035 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -310,108 +310,15 @@ static void __init omap3_logicpd_torpedo_init(void)
 }
 
 /* omap3pandora legacy devices */
-#define PANDORA_WIFI_IRQ_GPIO		21
-#define PANDORA_WIFI_NRESET_GPIO	23
 
 static struct platform_device pandora_backlight = {
 	.name	= "pandora-backlight",
 	.id	= -1,
 };
 
-static struct regulator_consumer_supply pandora_vmmc3_supply[] = {
-	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.2"),
-};
-
-static struct regulator_init_data pandora_vmmc3 = {
-	.constraints = {
-		.valid_ops_mask		= REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= ARRAY_SIZE(pandora_vmmc3_supply),
-	.consumer_supplies	= pandora_vmmc3_supply,
-};
-
-static struct fixed_voltage_config pandora_vwlan = {
-	.supply_name		= "vwlan",
-	.microvolts		= 1800000, /* 1.8V */
-	.gpio			= PANDORA_WIFI_NRESET_GPIO,
-	.startup_delay		= 50000, /* 50ms */
-	.enable_high		= 1,
-	.init_data		= &pandora_vmmc3,
-};
-
-static struct platform_device pandora_vwlan_device = {
-	.name		= "reg-fixed-voltage",
-	.id		= 1,
-	.dev = {
-		.platform_data = &pandora_vwlan,
-	},
-};
-
-static void pandora_wl1251_init_card(struct mmc_card *card)
-{
-	/*
-	 * We have TI wl1251 attached to MMC3. Pass this information to
-	 * SDIO core because it can't be probed by normal methods.
-	 */
-	if (card->type == MMC_TYPE_SDIO || card->type == MMC_TYPE_SD_COMBO) {
-		card->quirks |= MMC_QUIRK_NONSTD_SDIO;
-		card->cccr.wide_bus = 1;
-		card->cis.vendor = 0x104c;
-		card->cis.device = 0x9066;
-		card->cis.blksize = 512;
-		card->cis.max_dtr = 24000000;
-		card->ocr = 0x80;
-	}
-}
-
-static struct omap2_hsmmc_info pandora_mmc3[] = {
-	{
-		.mmc		= 3,
-		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_POWER_OFF_CARD,
-		.gpio_cd	= -EINVAL,
-		.gpio_wp	= -EINVAL,
-		.init_card	= pandora_wl1251_init_card,
-	},
-	{}	/* Terminator */
-};
-
-static void __init pandora_wl1251_init(void)
-{
-	struct wl1251_platform_data pandora_wl1251_pdata;
-	int ret;
-
-	memset(&pandora_wl1251_pdata, 0, sizeof(pandora_wl1251_pdata));
-
-	pandora_wl1251_pdata.power_gpio = -1;
-
-	ret = gpio_request_one(PANDORA_WIFI_IRQ_GPIO, GPIOF_IN, "wl1251 irq");
-	if (ret < 0)
-		goto fail;
-
-	pandora_wl1251_pdata.irq = gpio_to_irq(PANDORA_WIFI_IRQ_GPIO);
-	if (pandora_wl1251_pdata.irq < 0)
-		goto fail_irq;
-
-	pandora_wl1251_pdata.use_eeprom = true;
-	ret = wl1251_set_platform_data(&pandora_wl1251_pdata);
-	if (ret < 0)
-		goto fail_irq;
-
-	return;
-
-fail_irq:
-	gpio_free(PANDORA_WIFI_IRQ_GPIO);
-fail:
-	pr_err("wl1251 board initialisation failed\n");
-}
-
 static void __init omap3_pandora_legacy_init(void)
 {
 	platform_device_register(&pandora_backlight);
-	platform_device_register(&pandora_vwlan_device);
-	omap_hsmmc_init(pandora_mmc3);
-	omap_hsmmc_late_init(pandora_mmc3);
-	pandora_wl1251_init();
 }
 #endif /* CONFIG_ARCH_OMAP3 */
 
-- 
2.23.0

