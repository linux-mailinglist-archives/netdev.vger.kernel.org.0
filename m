Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C1048367A
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbiACR4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233960AbiACR4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:56:44 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6577C061799
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 09:56:43 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d9so71406009wrb.0
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 09:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tCiPkp3jfEInQDuu5pe2s+FpAfkVA+xspBGKsfc9N3o=;
        b=4X6ZZCCrYU57LSXKx569kRQxY/MNgkQFPpsJDHX2Ub8keBv+PYodi4YgTdDzZsDIS4
         mw5gefTaflVbh1AnJGWiVVBwJQvdEeV9Cy5y2oOEV1/aMER5Vk7UXmIXPYUqfwlm9qvi
         0u5Z2gMEnzUx16otyh3qogvs4At7o51QoddC48qVTe4yfM79t7bYuZK5G2nD8JZWdn+3
         soYuwTwi83slTgHg7k0ygDImXcmGfSBbPd+mspqgnZ1NuYQSXM74wTkQ+wadF93enS4F
         ADlXrdf8SsEwtTxfbaXaKk83INV+7vA4fIKN2obvZ3cVL78LeuwsSXtWEQPzgra6c2cr
         uv8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tCiPkp3jfEInQDuu5pe2s+FpAfkVA+xspBGKsfc9N3o=;
        b=kHeqTjg1py65TVkf/0mtsrKHedNZpATC7ryXf+hO9LNBHDTPd+QdY/zYMaWT2W9w8J
         wD9uImMna6lyApcTHHkmKWFq1eNd2jJuwcpReUC94mIpD2Nz4ur8MMluERiM28vOg6lo
         Nl+NxEBBBtY4wNPl+/IRlkPabI/3dNtmBfAQCDkK09WeuxYVk7+f499ZfNHI1NWOK9TM
         +CHCcuC8V6YVLLiXUP9OUe82wReojBMMhrglln8TUS0ar+2rBEZga8eStwbFpwzQG9x5
         C8NXXQmdPd872mr5YL9jfFDvvh4TMhjE47JOm++wSMsHfB0A9kVt8x73Tud9xsaBCwYd
         koPg==
X-Gm-Message-State: AOAM530qpBQAN1MfOaSOQu3IPITlQkHJ8ekc8i5wSkXsdI65HJu0QimE
        8I777Wy5bGocIdWrn/TdPjQ/Pg==
X-Google-Smtp-Source: ABdhPJxOtKYtTNaIgDan8PjmiObJStT/bn80hFMljJ8rGG+Y+kZqa1LMyYMm0veoWk234qEPQBjQbg==
X-Received: by 2002:a05:6000:118a:: with SMTP id g10mr38020352wrx.533.1641232602351;
        Mon, 03 Jan 2022 09:56:42 -0800 (PST)
Received: from localhost.localdomain ([2001:861:44c0:66c0:7c9d:a967:38e2:5220])
        by smtp.gmail.com with ESMTPSA id f13sm35763228wri.51.2022.01.03.09.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 09:56:41 -0800 (PST)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net
Cc:     Neil Armstrong <narmstrong@baylibre.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-oxnas@groups.io,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: stmmac: dwmac-oxnas: Add support for OX810SE
Date:   Mon,  3 Jan 2022 18:56:37 +0100
Message-Id: <20220103175638.89625-3-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220103175638.89625-1-narmstrong@baylibre.com>
References: <20220103175638.89625-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for OX810SE dwmac glue setup, which is a simplified version
of the OX820 introduced later with more control on the PHY interface.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-oxnas.c | 92 ++++++++++++++-----
 1 file changed, 70 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
index adfeb8d3293d..7ffa4a4eb30f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
@@ -12,6 +12,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
@@ -48,12 +49,58 @@
 #define DWMAC_RX_VARDELAY(d)		((d) << DWMAC_RX_VARDELAY_SHIFT)
 #define DWMAC_RXN_VARDELAY(d)		((d) << DWMAC_RXN_VARDELAY_SHIFT)
 
+struct oxnas_dwmac;
+
+struct oxnas_dwmac_data {
+	void (*setup)(struct oxnas_dwmac *dwmac);
+};
+
 struct oxnas_dwmac {
 	struct device	*dev;
 	struct clk	*clk;
 	struct regmap	*regmap;
+	const struct oxnas_dwmac_data	*data;
 };
 
+static void oxnas_dwmac_setup_ox810se(struct oxnas_dwmac *dwmac)
+{
+	unsigned int value;
+
+	/* Enable GMII_GTXCLK to follow GMII_REFCLK, required for gigabit PHY */
+	value = BIT(DWMAC_CKEN_GTX)		|
+		 /* Use simple mux for 25/125 Mhz clock switching */
+		 BIT(DWMAC_SIMPLE_MUX);
+
+	regmap_write(dwmac->regmap, OXNAS_DWMAC_CTRL_REGOFFSET, value);
+}
+
+static void oxnas_dwmac_setup_ox820(struct oxnas_dwmac *dwmac)
+{
+	unsigned int value;
+
+	/* Enable GMII_GTXCLK to follow GMII_REFCLK, required for gigabit PHY */
+	value = BIT(DWMAC_CKEN_GTX)		|
+		 /* Use simple mux for 25/125 Mhz clock switching */
+		BIT(DWMAC_SIMPLE_MUX)		|
+		/* set auto switch tx clock source */
+		BIT(DWMAC_AUTO_TX_SOURCE)	|
+		/* enable tx & rx vardelay */
+		BIT(DWMAC_CKEN_TX_OUT)		|
+		BIT(DWMAC_CKEN_TXN_OUT)	|
+		BIT(DWMAC_CKEN_TX_IN)		|
+		BIT(DWMAC_CKEN_RX_OUT)		|
+		BIT(DWMAC_CKEN_RXN_OUT)	|
+		BIT(DWMAC_CKEN_RX_IN);
+	regmap_write(dwmac->regmap, OXNAS_DWMAC_CTRL_REGOFFSET, value);
+
+	/* set tx & rx vardelay */
+	value = DWMAC_TX_VARDELAY(4)	|
+		DWMAC_TXN_VARDELAY(2)	|
+		DWMAC_RX_VARDELAY(10)	|
+		DWMAC_RXN_VARDELAY(8);
+	regmap_write(dwmac->regmap, OXNAS_DWMAC_DELAY_REGOFFSET, value);
+}
+
 static int oxnas_dwmac_init(struct platform_device *pdev, void *priv)
 {
 	struct oxnas_dwmac *dwmac = priv;
@@ -75,27 +122,7 @@ static int oxnas_dwmac_init(struct platform_device *pdev, void *priv)
 		return ret;
 	}
 
-	/* Enable GMII_GTXCLK to follow GMII_REFCLK, required for gigabit PHY */
-	value |= BIT(DWMAC_CKEN_GTX)		|
-		 /* Use simple mux for 25/125 Mhz clock switching */
-		 BIT(DWMAC_SIMPLE_MUX)		|
-		 /* set auto switch tx clock source */
-		 BIT(DWMAC_AUTO_TX_SOURCE)	|
-		 /* enable tx & rx vardelay */
-		 BIT(DWMAC_CKEN_TX_OUT)		|
-		 BIT(DWMAC_CKEN_TXN_OUT)	|
-		 BIT(DWMAC_CKEN_TX_IN)		|
-		 BIT(DWMAC_CKEN_RX_OUT)		|
-		 BIT(DWMAC_CKEN_RXN_OUT)	|
-		 BIT(DWMAC_CKEN_RX_IN);
-	regmap_write(dwmac->regmap, OXNAS_DWMAC_CTRL_REGOFFSET, value);
-
-	/* set tx & rx vardelay */
-	value = DWMAC_TX_VARDELAY(4)	|
-		DWMAC_TXN_VARDELAY(2)	|
-		DWMAC_RX_VARDELAY(10)	|
-		DWMAC_RXN_VARDELAY(8);
-	regmap_write(dwmac->regmap, OXNAS_DWMAC_DELAY_REGOFFSET, value);
+	dwmac->data->setup(dwmac);
 
 	return 0;
 }
@@ -128,6 +155,12 @@ static int oxnas_dwmac_probe(struct platform_device *pdev)
 		goto err_remove_config_dt;
 	}
 
+	dwmac->data = (const struct oxnas_dwmac_data *)of_device_get_match_data(&pdev->dev);
+	if (!dwmac->data) {
+		ret = -EINVAL;
+		goto err_remove_config_dt;
+	}
+
 	dwmac->dev = &pdev->dev;
 	plat_dat->bsp_priv = dwmac;
 	plat_dat->init = oxnas_dwmac_init;
@@ -166,8 +199,23 @@ static int oxnas_dwmac_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static const struct oxnas_dwmac_data ox810se_dwmac_data = {
+	.setup = oxnas_dwmac_setup_ox810se,
+};
+
+static const struct oxnas_dwmac_data ox820_dwmac_data = {
+	.setup = oxnas_dwmac_setup_ox820,
+};
+
 static const struct of_device_id oxnas_dwmac_match[] = {
-	{ .compatible = "oxsemi,ox820-dwmac" },
+	{
+		.compatible = "oxsemi,ox810se-dwmac",
+		.data = &ox810se_dwmac_data,
+	},
+	{
+		.compatible = "oxsemi,ox820-dwmac",
+		.data = &ox820_dwmac_data,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(of, oxnas_dwmac_match);
-- 
2.25.1

