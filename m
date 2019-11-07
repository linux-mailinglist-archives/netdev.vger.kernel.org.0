Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C0EF2C51
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388399AbfKGKcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:32:01 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.121]:11949 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387870AbfKGKbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:31:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573122680;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ghbGYZ5e/JMttXQLnmZ61iznAlH5vCDYTJ/MRrpzqB0=;
        b=Ele+smM6uGvvzZzyoZww4oqs3zlQduJqg2Ds7T/TLB5qZJblI8UXUGumrgpx4s4CWY
        +rKL12X4Q+FBqa29XwFVdbRdkHbYs9L26ITWLXcaRLK8xqDF88wKheRID/qI40PNdsLi
        fFPLP9aEaACTphnsTwjAjnc9CbY3PgFZtITyxeXX8mT00wD9ojivm60DndZ5jVBBPScV
        ZlFRHzBnG0uUOEd6Tbyt5GLOZOqDv2nhVgKJphC6cRNphp/thNai9O5JEMMFkZQGeMll
        h9oq6kzw+DSEcrGZshgPh6RfcY0t9GJN5HPrv35rLwpW3NVKJV5+UGpKe+G9iGY+NWkm
        ErBg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M7PR5/L9P0"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vA7AUsdS0
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 7 Nov 2019 11:30:54 +0100 (CET)
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
Subject: [PATCH v3 08/12] mmc: host: omap-hsmmc: remove init_card pdata callback from pdata
Date:   Thu,  7 Nov 2019 11:30:41 +0100
Message-Id: <3254fc364a5237122491188ae4ecfed0759d8de8.1573122644.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573122644.git.hns@goldelico.com>
References: <cover.1573122644.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now as we have removed the last user (pandora_wl1251_init_card)
of this callback, we can remove it from the hsmmc code.

Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/mmc/host/omap_hsmmc.c            | 4 +---
 include/linux/platform_data/hsmmc-omap.h | 3 ---
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index a7192731ac13..b8c040691bab 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1510,9 +1510,7 @@ static void omap_hsmmc_init_card(struct mmc_host *mmc, struct mmc_card *card)
 {
 	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
-	if (mmc_pdata(host)->init_card)
-		mmc_pdata(host)->init_card(card);
-	else if (card->type == MMC_TYPE_SDIO || card->type == MMC_TYPE_SD_COMBO) {
+	if (card->type == MMC_TYPE_SDIO || card->type == MMC_TYPE_SD_COMBO) {
 		struct device_node *np = mmc_dev(mmc)->of_node;
 
 		/*
diff --git a/include/linux/platform_data/hsmmc-omap.h b/include/linux/platform_data/hsmmc-omap.h
index e79d238ff18f..7124a5f4bf06 100644
--- a/include/linux/platform_data/hsmmc-omap.h
+++ b/include/linux/platform_data/hsmmc-omap.h
@@ -67,9 +67,6 @@ struct omap_hsmmc_platform_data {
 	/* string specifying a particular variant of hardware */
 	char *version;
 
-	/* if we have special card, init it using this callback */
-	void (*init_card)(struct mmc_card *card);
-
 	const char *name;
 	u32 ocr_mask;
 };
-- 
2.23.0

