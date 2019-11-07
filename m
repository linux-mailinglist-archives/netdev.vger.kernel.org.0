Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C238F2C2D
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388233AbfKGKb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:31:26 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.124]:16170 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387926AbfKGKbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:31:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573122681;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Lx5yFKmDpyM6XrU85xlKU8xCu58g5jftLo0ePR4fO8c=;
        b=BrDV7yB2domjVNvFIogB3B8MSnndzXUrcSMLVSQxvqb9NNSw+QH8n8efhxg74tG8J5
        jFTi1C8ZKrEUMxMfxGjCImg1LnlCst6WSxjU0s8z8qHn5g3RCFQcWFnZS+8DgfvV99LG
        gFsVJ+yQ65t04DfuSpAYHhLIXcCgTeM0VJzhOsGEM/1EQi4oiOokq3s2f+SzuzvbSwa6
        rxMTJk4TYG/X+Wm2Ox4qWjTtdtHseZv7Pmj8riN7AOteEGlB9kYBz35cnJn1Z20JJHa2
        ug1W0YNnN7plOmV7htzB5Xl3UyeUjEXwT6LBecVD5hu9O2+xxgOI3UqWiIflzydXEZu+
        kRqg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M7PR5/L9P0"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vA7AUrdRz
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 7 Nov 2019 11:30:53 +0100 (CET)
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
Subject: [PATCH v3 07/12] omap: remove omap2_hsmmc_info in old hsmmc.[ch] and update Makefile
Date:   Thu,  7 Nov 2019 11:30:40 +0100
Message-Id: <c3e0a1392dd6d44fe8bde0161c508007f4abdd5f.1573122644.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573122644.git.hns@goldelico.com>
References: <cover.1573122644.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a new driver in drivers/mmc/host/omap_hsmmc.c
configured by CONFIG_MMC_OMAP_HS and the last user
was the pdata-quirks for pandora.

Suggested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 arch/arm/mach-omap2/Makefile       |   3 -
 arch/arm/mach-omap2/common.h       |   1 -
 arch/arm/mach-omap2/hsmmc.c        | 171 -----------------------------
 arch/arm/mach-omap2/hsmmc.h        |  32 ------
 arch/arm/mach-omap2/pdata-quirks.c |   1 -
 5 files changed, 208 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/hsmmc.c
 delete mode 100644 arch/arm/mach-omap2/hsmmc.h

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 8f208197988f..1e1e86d17fc5 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -216,9 +216,6 @@ obj-$(CONFIG_MACH_NOKIA_N8X0)		+= board-n8x0.o
 
 # Platform specific device init code
 
-omap-hsmmc-$(CONFIG_MMC_OMAP_HS)	:= hsmmc.o
-obj-y					+= $(omap-hsmmc-m) $(omap-hsmmc-y)
-
 obj-y					+= omap_phy_internal.o
 
 obj-$(CONFIG_MACH_OMAP2_TUSB6010)	+= usb-tusb6010.o
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 6316da3623b3..223b37c48389 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -352,7 +352,6 @@ void omap_pcs_legacy_init(int irq, void (*rearm)(void));
 struct omap_sdrc_params;
 extern void omap_sdrc_init(struct omap_sdrc_params *sdrc_cs0,
 				      struct omap_sdrc_params *sdrc_cs1);
-struct omap2_hsmmc_info;
 extern void omap_reserve(void);
 
 struct omap_hwmod;
diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
deleted file mode 100644
index 63423ea6a240..000000000000
--- a/arch/arm/mach-omap2/hsmmc.c
+++ /dev/null
@@ -1,171 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * linux/arch/arm/mach-omap2/hsmmc.c
- *
- * Copyright (C) 2007-2008 Texas Instruments
- * Copyright (C) 2008 Nokia Corporation
- * Author: Texas Instruments
- */
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/delay.h>
-#include <linux/mmc/host.h>
-#include <linux/platform_data/hsmmc-omap.h>
-
-#include "soc.h"
-#include "omap_device.h"
-
-#include "hsmmc.h"
-#include "control.h"
-
-#if IS_ENABLED(CONFIG_MMC_OMAP_HS)
-
-static u16 control_pbias_offset;
-static u16 control_devconf1_offset;
-
-#define HSMMC_NAME_LEN	9
-
-static int __init omap_hsmmc_pdata_init(struct omap2_hsmmc_info *c,
-					struct omap_hsmmc_platform_data *mmc)
-{
-	char *hc_name;
-
-	hc_name = kzalloc(HSMMC_NAME_LEN + 1, GFP_KERNEL);
-	if (!hc_name)
-		return -ENOMEM;
-
-	snprintf(hc_name, (HSMMC_NAME_LEN + 1), "mmc%islot%i", c->mmc, 1);
-	mmc->name = hc_name;
-	mmc->caps = c->caps;
-	mmc->reg_offset = 0;
-
-	return 0;
-}
-
-static int omap_hsmmc_done;
-
-void omap_hsmmc_late_init(struct omap2_hsmmc_info *c)
-{
-	struct platform_device *pdev;
-	int res;
-
-	if (omap_hsmmc_done)
-		return;
-
-	omap_hsmmc_done = 1;
-
-	for (; c->mmc; c++) {
-		pdev = c->pdev;
-		if (!pdev)
-			continue;
-		res = omap_device_register(pdev);
-		if (res)
-			pr_err("Could not late init MMC\n");
-	}
-}
-
-#define MAX_OMAP_MMC_HWMOD_NAME_LEN		16
-
-static void __init omap_hsmmc_init_one(struct omap2_hsmmc_info *hsmmcinfo,
-					int ctrl_nr)
-{
-	struct omap_hwmod *oh;
-	struct omap_hwmod *ohs[1];
-	struct omap_device *od;
-	struct platform_device *pdev;
-	char oh_name[MAX_OMAP_MMC_HWMOD_NAME_LEN];
-	struct omap_hsmmc_platform_data *mmc_data;
-	struct omap_hsmmc_dev_attr *mmc_dev_attr;
-	char *name;
-	int res;
-
-	mmc_data = kzalloc(sizeof(*mmc_data), GFP_KERNEL);
-	if (!mmc_data)
-		return;
-
-	res = omap_hsmmc_pdata_init(hsmmcinfo, mmc_data);
-	if (res < 0)
-		goto free_mmc;
-
-	name = "omap_hsmmc";
-	res = snprintf(oh_name, MAX_OMAP_MMC_HWMOD_NAME_LEN,
-		     "mmc%d", ctrl_nr);
-	WARN(res >= MAX_OMAP_MMC_HWMOD_NAME_LEN,
-	     "String buffer overflow in MMC%d device setup\n", ctrl_nr);
-
-	oh = omap_hwmod_lookup(oh_name);
-	if (!oh) {
-		pr_err("Could not look up %s\n", oh_name);
-		goto free_name;
-	}
-	ohs[0] = oh;
-	if (oh->dev_attr != NULL) {
-		mmc_dev_attr = oh->dev_attr;
-		mmc_data->controller_flags = mmc_dev_attr->flags;
-	}
-
-	pdev = platform_device_alloc(name, ctrl_nr - 1);
-	if (!pdev) {
-		pr_err("Could not allocate pdev for %s\n", name);
-		goto free_name;
-	}
-	dev_set_name(&pdev->dev, "%s.%d", pdev->name, pdev->id);
-
-	od = omap_device_alloc(pdev, ohs, 1);
-	if (IS_ERR(od)) {
-		pr_err("Could not allocate od for %s\n", name);
-		goto put_pdev;
-	}
-
-	res = platform_device_add_data(pdev, mmc_data,
-			      sizeof(struct omap_hsmmc_platform_data));
-	if (res) {
-		pr_err("Could not add pdata for %s\n", name);
-		goto put_pdev;
-	}
-
-	hsmmcinfo->pdev = pdev;
-
-	res = omap_device_register(pdev);
-	if (res) {
-		pr_err("Could not register od for %s\n", name);
-		goto free_od;
-	}
-
-	goto free_mmc;
-
-free_od:
-	omap_device_delete(od);
-
-put_pdev:
-	platform_device_put(pdev);
-
-free_name:
-	kfree(mmc_data->name);
-
-free_mmc:
-	kfree(mmc_data);
-}
-
-void __init omap_hsmmc_init(struct omap2_hsmmc_info *controllers)
-{
-	if (omap_hsmmc_done)
-		return;
-
-	omap_hsmmc_done = 1;
-
-	if (cpu_is_omap2430()) {
-		control_pbias_offset = OMAP243X_CONTROL_PBIAS_LITE;
-		control_devconf1_offset = OMAP243X_CONTROL_DEVCONF1;
-	} else {
-		control_pbias_offset = OMAP343X_CONTROL_PBIAS_LITE;
-		control_devconf1_offset = OMAP343X_CONTROL_DEVCONF1;
-	}
-
-	for (; controllers->mmc; controllers++)
-		omap_hsmmc_init_one(controllers, controllers->mmc);
-
-}
-
-#endif
diff --git a/arch/arm/mach-omap2/hsmmc.h b/arch/arm/mach-omap2/hsmmc.h
deleted file mode 100644
index 76c5ed2afa72..000000000000
--- a/arch/arm/mach-omap2/hsmmc.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * MMC definitions for OMAP2
- */
-
-struct mmc_card;
-
-struct omap2_hsmmc_info {
-	u8	mmc;		/* controller 1/2/3 */
-	u32	caps;		/* 4/8 wires and any additional host
-				 * capabilities OR'd (ref. linux/mmc/host.h) */
-	struct platform_device *pdev;	/* mmc controller instance */
-	/* init some special card */
-	void (*init_card)(struct mmc_card *card);
-};
-
-#if IS_ENABLED(CONFIG_MMC_OMAP_HS)
-
-void omap_hsmmc_init(struct omap2_hsmmc_info *);
-void omap_hsmmc_late_init(struct omap2_hsmmc_info *);
-
-#else
-
-static inline void omap_hsmmc_init(struct omap2_hsmmc_info *info)
-{
-}
-
-static inline void omap_hsmmc_late_init(struct omap2_hsmmc_info *info)
-{
-}
-
-#endif
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 1b7cf81ff035..ad0e00724578 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -32,7 +32,6 @@
 #include "omap_device.h"
 #include "omap-secure.h"
 #include "soc.h"
-#include "hsmmc.h"
 
 static struct omap_hsmmc_platform_data __maybe_unused mmc_pdata[2];
 
-- 
2.23.0

