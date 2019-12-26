Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064FE12AE88
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 21:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfLZUhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 15:37:20 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:40856 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfLZUhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 15:37:16 -0500
Received: by mail-wm1-f47.google.com with SMTP id t14so6807932wmi.5;
        Thu, 26 Dec 2019 12:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RjzvH91MnVV7aITjjuXlbaOaZ4rQFhkSbeJltjOfK8A=;
        b=s+drKSEiN/qOoiDdlcEy0bXE+J5Pc5IJ0dzfAXtyoK1ioUgP35H6WcIHPxSGqsGjoj
         IgA7AzNURTPzCOEPtnsnNSbP8evDBzz/bQOmXHjd6aofJ7+iAtnsiWmtO7Mo9eEzI4pR
         rL359/EItc2wt8MqMa1xQKhWBrl4ilmXxnGU8LFBOIVqVPFmkasHP5mcoF06myENwmzK
         V0Fa7vSNiZ5ley+IA3SqIkpBIc45TksTRnyHAYerI+9KOPfC/M8EQ15BryuYrHMW0Oqd
         UfIakJmOvV2/ULXcu1BKOVCHq42Kccr2MfE3rBanZ6ZsW33GF+sXcsF/njXcHJDo7P4o
         MIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RjzvH91MnVV7aITjjuXlbaOaZ4rQFhkSbeJltjOfK8A=;
        b=uBI1TBAHMpMzIpqGAiEgwzTuqOW+dJ6T/1YylAuXyxtSlVrtk67wzItd/gsroVrTGo
         5uJUsT1C8g04uX6E0nyC82DHdA0cl9rcSisUME0EpEmxt4fgPfKiXem6o2D0otBL2M0U
         /FYmbFBI1rLndGQsKw4rl9hW4QXibZ2IaOm8WoRArhfsvAXvJPjE/I71Xx9qNTsWzhB1
         46ffuaYfPfeCkIqc1Mko8WZOGOc3+TU1eFxUHBwRccbRPfdK39kZsrcpi+Ut+3k3hyGJ
         drclNoWJCHGvNr+FnOJbpKMVLa7T4lVtyinf5JLOkgm8N+X/lRC0zJeF92I1QalcYkFM
         Lorw==
X-Gm-Message-State: APjAAAU3gCEfvk+xUxfSugvA2ypsq4LlHgYk2IvUyHG5b7Gz77KhWE+C
        xvRQQMtqO5QjDiTjheL4j3E=
X-Google-Smtp-Source: APXvYqw2MZbGNvdpTY6PKEXi82D3m+l0OOPUiJU+ERQgG9SfmDopfpP3drcdmqJBbzAUiexFFSEACA==
X-Received: by 2002:a7b:ca4c:: with SMTP id m12mr15100035wml.176.1577392633660;
        Thu, 26 Dec 2019 12:37:13 -0800 (PST)
Received: from localhost.localdomain (p200300F1373A1900428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:373a:1900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q3sm32911665wrn.33.2019.12.26.12.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 12:37:13 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, jianxin.pan@amlogic.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC v1 2/2] net: stmmac: dwmac-meson8b: add support for the RX delay configuration
Date:   Thu, 26 Dec 2019 21:36:55 +0100
Message-Id: <20191226203655.4046170-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191226203655.4046170-1-martin.blumenstingl@googlemail.com>
References: <20191226203655.4046170-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DO NOT MERGE THIS!

Test results:
- Akaso M8S (not upstream yet) Meson8m2 with RMII PHY: no change
- Odroid-C1 Meson8b with RTL8211F RGMII PHY:
  phy-mode = "rgmii" still works
  phy-mode = "rgmii-id" works now
- Khadas VIM2 GXM with RTL8211F RGMII PHY:
  phy-mode = "rgmii" is now broken!
  phy-mode = "rgmii-id" works

The public A311D datasheet [0] mentions these bits in the PRG_ETH0 (also
call PRG_ETH0_REG) register:
- bit[13]: RMII & RGMII mode, Enable data delay adjustment and
  calibration logic.
- bit[14]: Set RXDV and RXD setup time, data is aligned with index 0.
  When set to 1, auto delay and skew.
- bit[19:15]:  Set bit14 to 0. RMII & RGMII mode. Capture input data at
  clock index equal to adj_delay.
- bit[24:20]: RMII & RGMII mode. 5 Bits correspondent to
  {RXDV, RXD[3:0]}, set to 1 will delay the data capture by 1 cycle.
(do all of these bits have the same meaning for all supported SoCs:
Meson8b, Meson8m2, GXBB, GXL, GXM, AXG, G12A, G12B, SM1?)

The public "Amlogic Ethernet controller user guide" recommends the
following settings.
RMII: adj_enable = 1, adj_setup = 0, adj_delay = 18, adj_skew = 0x0
RGMII: adj_enable = 1, adj_setup = 1, adj_delay = 4, adj_skew = 0xc
(shouldn't adj_delay be 0 for the RGMII mode based on the register
description above?)

Do we need to expose adj_delay and adj_skew to devicetree?
How do I know which value to set for each board?

[0] https://dl.khadas.com/Hardware/VIM3/Datasheet/A311D_Datasheet_01_Wesion.pdf
[1] http://openlinux.amlogic.com/@api/deki/files/75/=Amlogic_Ethenet_controller_user_Guide.pdf

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 59 ++++++++++---------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 1483761ab1e6..af25eb1aea41 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -33,6 +33,10 @@
 #define PRG_ETH0_CLK_M250_SEL_SHIFT	4
 #define PRG_ETH0_CLK_M250_SEL_MASK	GENMASK(4, 4)
 
+/* TX clock delay in ns = "8ns / 4 * tx_dly_val" (where 8ns are exactly one
+ * cycle of the 125MHz RGMII TX clock):
+ * 0ns = 0x0, 2ns = 0x1, 4ns = 0x2, 6ns = 0x3
+ */
 #define PRG_ETH0_TXDLY_MASK		GENMASK(6, 5)
 
 /* divider for the result of m250_sel */
@@ -44,6 +48,11 @@
 #define PRG_ETH0_INVERTED_RMII_CLK	BIT(11)
 #define PRG_ETH0_TX_AND_PHY_REF_CLK	BIT(12)
 
+#define PRG_ETH0_ADJ_ENABLE		BIT(13)
+#define PRG_ETH0_ADJ_SETUP		BIT(14)
+#define PRG_ETH0_ADJ_DELAY		GENMASK(19, 15)
+#define PRG_ETH0_ADJ_SKEW		GENMASK(24, 20)
+
 #define MUX_CLK_NUM_PARENTS		2
 
 struct meson8b_dwmac;
@@ -241,29 +250,38 @@ static int meson_axg_set_phy_mode(struct meson8b_dwmac *dwmac)
 
 static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 {
+	u8 tx_dly_val = dwmac->tx_delay_ns >> 1;
+	u32 delay_config;
 	int ret;
-	u8 tx_dly_val = 0;
 
 	switch (dwmac->phy_mode) {
 	case PHY_INTERFACE_MODE_RGMII:
+		delay_config = FIELD_PREP(PRG_ETH0_TXDLY_MASK, tx_dly_val);
+		delay_config |= PRG_ETH0_ADJ_ENABLE | PRG_ETH0_ADJ_SETUP;
+		break;
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		/* TX clock delay in ns = "8ns / 4 * tx_dly_val" (where
-		 * 8ns are exactly one cycle of the 125MHz RGMII TX clock):
-		 * 0ns = 0x0, 2ns = 0x1, 4ns = 0x2, 6ns = 0x3
-		 */
-		tx_dly_val = dwmac->tx_delay_ns >> 1;
-		/* fall through */
-
-	case PHY_INTERFACE_MODE_RGMII_ID:
+		delay_config = FIELD_PREP(PRG_ETH0_TXDLY_MASK, tx_dly_val);
+		break;
 	case PHY_INTERFACE_MODE_RGMII_TXID:
+		delay_config = PRG_ETH0_ADJ_ENABLE | PRG_ETH0_ADJ_SETUP;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RMII:
+	default:
+		delay_config = 0;
+		break;
+	};
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
@@ -286,24 +304,11 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 		devm_add_action_or_reset(dwmac->dev,
 					(void(*)(void *))clk_disable_unprepare,
 					dwmac->rgmii_tx_clk);
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
-- 
2.24.1

