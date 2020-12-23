Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF742E22C5
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 00:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgLWXcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 18:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbgLWXb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 18:31:59 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4327AC061248;
        Wed, 23 Dec 2020 15:30:44 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r7so701189wrc.5;
        Wed, 23 Dec 2020 15:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xDe0p+fCHjgP8/3HdTwCfTdFrh+VCfBpvFU7FupxqxM=;
        b=a5m/JD67n1sNEG2yCgdvaAqsVhI24bs4L0yvW0M8S/t3WevCKohih9wiop8NQpIS0O
         5MaRETZRwCb6ENQtw5rsIbozTQesm4BiQ1sWLzm3co7YWM7gg88Zf3wj/vtGCVxhI4aA
         6u+AP7AZ5QFQyosIjijRm8qWYAsxwNuA3OpXK7dFZxIrhpvh54B3oDv1Vd3CK35zdp4/
         wIrqnT2U+ySQKdVz0PbAAWimPNlWCENelG3fPVCVdayZIdmwp1HN2ake1+3QqQj4F7cX
         1jCRFBwMvtD31Sw6NEE5562GFAtpYqXnGJVrH3BA2wpKfv69RHE1QeQWBJWo+EWQFxpA
         N3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xDe0p+fCHjgP8/3HdTwCfTdFrh+VCfBpvFU7FupxqxM=;
        b=Yty8D+2C9w2OtMPA27hFq8svnRvZ0q0YQydZM86ulC/XnMztGHQANoO4JdrG78Evex
         cV/82HJkS/MmU3lkz0Bu9Bowujje3gVBKfxKLCIqhnKWX+KDyexZ4hNDHby28ITT+nwT
         PK4jP+70/Y8PYvt5O7iZ9rf5ofj+0sjstqzebQl7BPf0VVqDzrC9UZz+LxkWY8syvARP
         3434UexEu0v7nu4+4W3oyQyE8oO4HqMIaoSm23RgaD5FWSPWu2p5/YDfjNkHGRqrHdLS
         /M/dUQxuohyHQDsXbUOfYvIVt73IT1BXzGISI6gU0au02pxswRJ71t+gwllipMYh8JGl
         TI7Q==
X-Gm-Message-State: AOAM532rabbLcQprlJKIoE0pjboeNgnYTIjm4huIwnk/O/dYP975Sypa
        p4bgjqoNtl/GVVySpYpZ6tQ=
X-Google-Smtp-Source: ABdhPJw5Ez/gToiq52vpj3Abpb+v5FIko90pZbplhBepbNdPFGa/+E4ZV0SpTwefYDAkozF55ECLcw==
X-Received: by 2002:a5d:504d:: with SMTP id h13mr31960136wrt.246.1608766243040;
        Wed, 23 Dec 2020 15:30:43 -0800 (PST)
Received: from localhost.localdomain (p200300f1371a0900428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:371a:900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id l16sm37926657wrx.5.2020.12.23.15.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 15:30:42 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, jianxin.pan@amlogic.com,
        narmstrong@baylibre.com, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jbrunet@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 5/5] net: stmmac: dwmac-meson8b: add support for the RGMII RX delay on G12A
Date:   Thu, 24 Dec 2020 00:29:05 +0100
Message-Id: <20201223232905.2958651-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
References: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
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

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 61 +++++++++++++++----
 1 file changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 4937432ac70d..55152d7ba99a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -68,10 +68,21 @@
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
 
@@ -423,11 +442,20 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
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
@@ -469,10 +497,17 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 
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
@@ -494,7 +529,7 @@ static const struct of_device_id meson8b_dwmac_match[] = {
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

