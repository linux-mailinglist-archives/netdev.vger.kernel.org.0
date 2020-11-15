Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188B22B3816
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 19:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgKOSwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 13:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbgKOSws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 13:52:48 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F34C0613D1;
        Sun, 15 Nov 2020 10:52:48 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id a15so16501188edy.1;
        Sun, 15 Nov 2020 10:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e7Tu/oogcejmu22M30ZlZTxBXHimQsNupp6U1ZI/9L0=;
        b=uQFbjQtoLwSmMy2HRTi8gOnvWeUjxwr46XXB2B5LYjVEP2eMVmr4TjsI70OSTXVlCa
         l5m1rdR5THJL3+3VNxvGl+9CqcesTyEHhW+OjaOpqrgugd1qmTwJ8CzffWiCb4S2NWrG
         xnzBe08iDCPxw0HA/9E4fdFHbeRZiO4O3mRJKmj1ECt6nKrxgILtorx9lTwnZdja5LZh
         ZuYMXXoZJanJZCEDLYCI+JDbDLayzYMatTrg3vI/maZi41pSblMw/Ju3oEZjreE6pSip
         PbSd2DaflY2tU9FKCItrcO4HR5RIqP1VXpwQSo5HvKI5yqnM8n3Ixvjp842vi+o9+Ht7
         lCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e7Tu/oogcejmu22M30ZlZTxBXHimQsNupp6U1ZI/9L0=;
        b=n892N2WvK63XKzhC/Kv2sPyBNcEW4tsFA7RdPdwx/58i7hbBCf7TXueTKhbXPRhm8I
         9znxL80tbU6fGLhe3YaRRRZ1fnz3zgYYLbL1H7q8V9Ej6Ey7dPcqR+CYkzFylq4wrlTO
         SjGrfogo4OXMaKeLx/IN95LKlaU44emZPJ2BXBnfn+6VO1A6hHxWyblJP1gZ4nGtnReY
         Kft7aEe0ki8ah+OCjQLMNmzJO8Hkevf0M6WzWIAVnDnUsAgU3IXfBqlRjeScOkBWnyi8
         YA/0QvdN22oVmmVMqAQBS/SLBDcvPlVLGtJHGVrXzvftZs3l+0YRHlkFfRXM/aIsia1D
         s3Sw==
X-Gm-Message-State: AOAM531O1sTxxQzHrdWvvD3hQTaP0XcoEslNgt0cJxiT0bgXTPTYB/Q1
        LUJYNBxjNLi7q5yXvto6O/w=
X-Google-Smtp-Source: ABdhPJxuIdv5liZFaIdQTuZ2uRrlmnCyspQfOzWY6ZIv+j6aaF+/amqZ6c5tmLzAGfkoS4rPGKDeUw==
X-Received: by 2002:a50:d315:: with SMTP id g21mr12616512edh.84.1605466367326;
        Sun, 15 Nov 2020 10:52:47 -0800 (PST)
Received: from localhost.localdomain (p4fc3ea77.dip0.t-ipconnect.de. [79.195.234.119])
        by smtp.googlemail.com with ESMTPSA id i13sm9233520ejv.84.2020.11.15.10.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 10:52:46 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
        narmstrong@baylibre.com, jbrunet@baylibre.com, andrew@lunn.ch,
        f.fainelli@gmail.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 5/5] net: stmmac: dwmac-meson8b: add support for the RGMII RX delay on G12A
Date:   Sun, 15 Nov 2020 19:52:10 +0100
Message-Id: <20201115185210.573739-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amlogic Meson G12A (and newer: G12B, SM1) SoCs have a more advanced RX
delay logic. Instead of fine-tuning the delay in the nanoseconds range
it now allows tuning in 200 picosecond steps. This support comes with
new bits in the PRG_ETH1[19:16] register.

Add support for validating the RGMII RX delay as well as configuring the
register accordingly on these platforms.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 61 +++++++++++++++----
 1 file changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 353fe0f53620..2184b6c2c784 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -69,10 +69,21 @@
  */
 #define PRG_ETH0_ADJ_SKEW		GENMASK(24, 20)
 
+#define PRG_ETH1			0x4
+
+/* Defined for adding a delay to the input RX_CLK for better timing.
+ * Each step is 200ps. These bits are used with external RGMII PHYs
+ * because RGMII RX only has the small window. cfg_rxclk_dly can
+ * adjust the window between RX_CLK and RX_DATA and improve the stability
+ * of "rx data valid".
+ */
+#define PRG_ETH1_CFG_RXCLK_DLY		GENMASK(19, 16)
+
 struct meson8b_dwmac;
 
 struct meson8b_dwmac_data {
 	int (*set_phy_mode)(struct meson8b_dwmac *dwmac);
+	bool has_prg_eth1_rgmii_rx_delay;
 };
 
 struct meson8b_dwmac {
@@ -270,30 +281,35 @@ static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
 
 static int meson8b_init_rgmii_delays(struct meson8b_dwmac *dwmac)
 {
-	u32 tx_dly_config, rx_dly_config, delay_config;
+	u32 tx_dly_config, rx_adj_config, cfg_rxclk_dly, delay_config;
 	int ret;
 
+	rx_adj_config = 0;
+	cfg_rxclk_dly = 0;
 	tx_dly_config = FIELD_PREP(PRG_ETH0_TXDLY_MASK,
 				   dwmac->tx_delay_ns >> 1);
 
-	if (dwmac->rx_delay_ps == 2000)
-		rx_dly_config = PRG_ETH0_ADJ_ENABLE | PRG_ETH0_ADJ_SETUP;
-	else
-		rx_dly_config = 0;
+	if (dwmac->data->has_prg_eth1_rgmii_rx_delay)
+		cfg_rxclk_dly = FIELD_PREP(PRG_ETH1_CFG_RXCLK_DLY,
+					   dwmac->rx_delay_ps / 200);
+	else if (dwmac->rx_delay_ps == 2000)
+		rx_adj_config = PRG_ETH0_ADJ_ENABLE | PRG_ETH0_ADJ_SETUP;
 
 	switch (dwmac->phy_mode) {
 	case PHY_INTERFACE_MODE_RGMII:
-		delay_config = tx_dly_config | rx_dly_config;
+		delay_config = tx_dly_config | rx_adj_config;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 		delay_config = tx_dly_config;
+		cfg_rxclk_dly = 0;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		delay_config = rx_dly_config;
+		delay_config = rx_adj_config;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RMII:
 		delay_config = 0;
+		cfg_rxclk_dly = 0;
 		break;
 	default:
 		dev_err(dwmac->dev, "unsupported phy-mode %s\n",
@@ -323,6 +339,9 @@ static int meson8b_init_rgmii_delays(struct meson8b_dwmac *dwmac)
 				PRG_ETH0_ADJ_DELAY | PRG_ETH0_ADJ_SKEW,
 				delay_config);
 
+	meson8b_dwmac_mask_bits(dwmac, PRG_ETH1, PRG_ETH1_CFG_RXCLK_DLY,
+				cfg_rxclk_dly);
+
 	return 0;
 }
 
@@ -424,11 +443,20 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 			dwmac->rx_delay_ps *= 1000;
 	}
 
-	if (dwmac->rx_delay_ps != 0 && dwmac->rx_delay_ps != 2000) {
-		dev_err(&pdev->dev,
-			"The only allowed RX delays values are: 0ps, 2000ps");
-		ret = -EINVAL;
-		goto err_remove_config_dt;
+	if (dwmac->data->has_prg_eth1_rgmii_rx_delay) {
+		if (dwmac->rx_delay_ps != 0 && dwmac->rx_delay_ps != 2000) {
+			dev_err(dwmac->dev,
+				"The only allowed RGMII RX delays values are: 0ps, 2000ps");
+			ret = -EINVAL;
+			goto err_remove_config_dt;
+		}
+	} else {
+		if (dwmac->rx_delay_ps > 3000 || dwmac->rx_delay_ps % 200) {
+			dev_err(dwmac->dev,
+				"The RGMII RX delay range is 0..3000ps in 200ps steps");
+			ret = -EINVAL;
+			goto err_remove_config_dt;
+		}
 	}
 
 	dwmac->timing_adj_clk = devm_clk_get_optional(dwmac->dev,
@@ -470,10 +498,17 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 
 static const struct meson8b_dwmac_data meson8b_dwmac_data = {
 	.set_phy_mode = meson8b_set_phy_mode,
+	.has_prg_eth1_rgmii_rx_delay = false,
 };
 
 static const struct meson8b_dwmac_data meson_axg_dwmac_data = {
 	.set_phy_mode = meson_axg_set_phy_mode,
+	.has_prg_eth1_rgmii_rx_delay = false,
+};
+
+static const struct meson8b_dwmac_data meson_g12a_dwmac_data = {
+	.set_phy_mode = meson_axg_set_phy_mode,
+	.has_prg_eth1_rgmii_rx_delay = true,
 };
 
 static const struct of_device_id meson8b_dwmac_match[] = {
@@ -495,7 +530,7 @@ static const struct of_device_id meson8b_dwmac_match[] = {
 	},
 	{
 		.compatible = "amlogic,meson-g12a-dwmac",
-		.data = &meson_axg_dwmac_data,
+		.data = &meson_g12a_dwmac_data,
 	},
 	{ }
 };
-- 
2.29.2

