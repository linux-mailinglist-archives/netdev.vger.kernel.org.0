Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D212D1BE844
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgD2UR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbgD2URY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:17:24 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2794C035493;
        Wed, 29 Apr 2020 13:17:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so4152079wrr.0;
        Wed, 29 Apr 2020 13:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w5E0z8+RH9QdjVjupYJsFCJKf6+6jAHD7ZKMzQZsttM=;
        b=RhijCmsTq80bADpuTyOQl20JpLBT/78NnD3MQ7DpsaMPWt49HHCeU8RBMmIuPPR5zy
         Hw3fdZKnjzibR+NRL4NITQYUiiAMHcNq5Pn6ffl1476/OEbevJ8vBnePxSLscT26c7Jj
         fYsHf+Wh/RIriLkqg1f1Qbgxa7D7GU5SHAfFyj898dnXTau/MPe38UlF29Kf9ZLOZE7o
         AEe8t4ybvQDwGbGZFxZ8cZrFlr8YXdFva7ppd3AnA9PWnFAEzKKsmt7aTb2//Qrcigwu
         e4yZ6xEDPMmcF0LGm8cAZJqR0EVxgFknleEPPH8hXtLMnOQRTlOUEQEkHJCwnrUH9aVx
         kJ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w5E0z8+RH9QdjVjupYJsFCJKf6+6jAHD7ZKMzQZsttM=;
        b=I/hzNUaqSZNrltyo0HdE0++kKsUUEtbG5bVxuLGOK/DV5XpPXvqNMDL00q5cXVudx+
         fmWqMmyvJ7j8LIOGIx+HByeYHVqQYN0sQA9jutm9IGAf7uC6JZybUQ+RA3zhtE9M0GHe
         AYNGGulkGHBZkftoVSmK5sOSvDshoiHQUH8glm0pAxpX0lp0KMvyIFWQ+j+kUL/ydGUq
         FI1lt4CaSDcy1u+oZPlliJxKsooNfwjmy/zCiEwraf007iJ1E5Wbks1pG0k4RaZskzch
         244QaAVb/ePeSIs+5Bwpa9RutabrLcy7dy6WPAtuKL0i35/3jQwuEoTiVMhBfO1ThJlZ
         l5kQ==
X-Gm-Message-State: AGi0Puardy4uXzCIcPOotYZ6vOp4kktJxOCrHSrTL+ijgv8fvnFEHNW1
        D663jO5MG3mXZ8TTbU522tc=
X-Google-Smtp-Source: APiQypL6/HjmO2Y5BOTOvHuARmRoeixXyPJyoP3pLs3IZxUHoveUQQ3YxMsDKRuvm8meMzKYkXEN0g==
X-Received: by 2002:adf:e486:: with SMTP id i6mr39356107wrm.377.1588191441584;
        Wed, 29 Apr 2020 13:17:21 -0700 (PDT)
Received: from localhost.localdomain (p200300F137142E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3714:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q143sm9923623wme.31.2020.04.29.13.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 13:17:20 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 08/11] net: stmmac: dwmac-meson8b: add support for the RX delay configuration
Date:   Wed, 29 Apr 2020 22:16:41 +0200
Message-Id: <20200429201644.1144546-9-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure the PRG_ETH0_ADJ_* bits to enable or disable the RX delay
based on the various RGMII PHY modes. For now the only supported RX
delay settings are:
- disabled, use for example for phy-mode "rgmii-id"
- 0ns - this is treated identical to "disabled", used for example on
  boards where the PHY provides 2ns TX delay and the PCB trace length
  already adds 2ns RX delay
- 2ns - for whenever the PHY cannot add the RX delay and the traces on
  the PCB don't add any RX delay

Disabling the RX delay (in case u-boot enables it, which is the case
for example on Meson8b Odroid-C1) simply means that PRG_ETH0_ADJ_ENABLE,
PRG_ETH0_ADJ_SETUP, PRG_ETH0_ADJ_DELAY and PRG_ETH0_ADJ_SKEW should be
disabled (just disabling PRG_ETH0_ADJ_ENABLE may be enough, since that
disables the whole re-timing logic - but I find it makes more sense to
clear the other bits as well since they depend on that setting).

u-boot on Odroid-C1 uses the following steps to enable a 2ns RX delay:
- enabling enabling the timing adjustment clock
- enabling the timing adjustment logic by setting PRG_ETH0_ADJ_ENABLE
- setting the PRG_ETH0_ADJ_SETUP bit

The documentation for the PRG_ETH0_ADJ_DELAY and PRG_ETH0_ADJ_SKEW
registers indicates that we can even set different RX delays. However,
I could not find out how this works exactly, so for now we only support
a 2ns RX delay using the exact same way that Odroid-C1's u-boot does.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 79 +++++++++++++------
 1 file changed, 56 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index d31f79c455de..73c84108d65b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -85,6 +85,7 @@ struct meson8b_dwmac {
 	phy_interface_t			phy_mode;
 	struct clk			*rgmii_tx_clk;
 	u32				tx_delay_ns;
+	u32				rx_delay_ns;
 	struct clk			*timing_adj_clk;
 };
 
@@ -284,25 +285,58 @@ static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
 
 static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 {
+	u32 tx_dly_config, rx_dly_config, delay_config;
 	int ret;
-	u8 tx_dly_val = 0;
+
+	tx_dly_config = FIELD_PREP(PRG_ETH0_TXDLY_MASK,
+				   dwmac->tx_delay_ns >> 1);
+
+	if (dwmac->rx_delay_ns == 2)
+		rx_dly_config = PRG_ETH0_ADJ_ENABLE | PRG_ETH0_ADJ_SETUP;
+	else
+		rx_dly_config = 0;
 
 	switch (dwmac->phy_mode) {
 	case PHY_INTERFACE_MODE_RGMII:
+		delay_config = tx_dly_config | rx_dly_config;
+		break;
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		tx_dly_val = dwmac->tx_delay_ns >> 1;
-		/* fall through */
-
-	case PHY_INTERFACE_MODE_RGMII_ID:
+		delay_config = tx_dly_config;
+		break;
 	case PHY_INTERFACE_MODE_RGMII_TXID:
+		delay_config = rx_dly_config;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RMII:
+		delay_config = 0;
+		break;
+	default:
+		dev_err(dwmac->dev, "unsupported phy-mode %s\n",
+			phy_modes(dwmac->phy_mode));
+		return -EINVAL;
+	};
+
+	if (rx_dly_config & PRG_ETH0_ADJ_ENABLE) {
+		/* The timing adjustment logic is driven by a separate clock */
+		ret = meson8b_devm_clk_prepare_enable(dwmac,
+						      dwmac->timing_adj_clk);
+		if (ret) {
+			dev_err(dwmac->dev,
+				"Failed to enable the timing-adjustment clock\n");
+			return ret;
+		}
+	}
+
+	meson8b_dwmac_mask_bits(dwmac, PRG_ETH0, PRG_ETH0_TXDLY_MASK |
+				PRG_ETH0_ADJ_ENABLE | PRG_ETH0_ADJ_SETUP |
+				PRG_ETH0_ADJ_DELAY | PRG_ETH0_ADJ_SKEW,
+				delay_config);
+
+	if (phy_interface_mode_is_rgmii(dwmac->phy_mode)) {
 		/* only relevant for RMII mode -> disable in RGMII mode */
 		meson8b_dwmac_mask_bits(dwmac, PRG_ETH0,
 					PRG_ETH0_INVERTED_RMII_CLK, 0);
 
-		meson8b_dwmac_mask_bits(dwmac, PRG_ETH0, PRG_ETH0_TXDLY_MASK,
-					FIELD_PREP(PRG_ETH0_TXDLY_MASK,
-						   tx_dly_val));
-
 		/* Configure the 125MHz RGMII TX clock, the IP block changes
 		 * the output automatically (= without us having to configure
 		 * a register) based on the line-speed (125MHz for Gbit speeds,
@@ -322,24 +356,11 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 				"failed to enable the RGMII TX clock\n");
 			return ret;
 		}
-		break;
-
-	case PHY_INTERFACE_MODE_RMII:
+	} else {
 		/* invert internal clk_rmii_i to generate 25/2.5 tx_rx_clk */
 		meson8b_dwmac_mask_bits(dwmac, PRG_ETH0,
 					PRG_ETH0_INVERTED_RMII_CLK,
 					PRG_ETH0_INVERTED_RMII_CLK);
-
-		/* TX clock delay cannot be configured in RMII mode */
-		meson8b_dwmac_mask_bits(dwmac, PRG_ETH0, PRG_ETH0_TXDLY_MASK,
-					0);
-
-		break;
-
-	default:
-		dev_err(dwmac->dev, "unsupported phy-mode %s\n",
-			phy_modes(dwmac->phy_mode));
-		return -EINVAL;
 	}
 
 	/* enable TX_CLK and PHY_REF_CLK generator */
@@ -394,6 +415,18 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 				 &dwmac->tx_delay_ns))
 		dwmac->tx_delay_ns = 2;
 
+	/* use 0ns as fallback since this is what most boards actually use */
+	if (of_property_read_u32(pdev->dev.of_node, "amlogic,rx-delay-ns",
+				 &dwmac->rx_delay_ns))
+		dwmac->rx_delay_ns = 0;
+
+	if (dwmac->rx_delay_ns != 0 && dwmac->rx_delay_ns != 2) {
+		dev_err(&pdev->dev,
+			"The only allowed RX delays values are: 0ns, 2ns");
+		ret = -EINVAL;
+		goto err_remove_config_dt;
+	}
+
 	dwmac->timing_adj_clk = devm_clk_get_optional(dwmac->dev,
 						      "timing-adjustment");
 	if (IS_ERR(dwmac->timing_adj_clk)) {
-- 
2.26.2

