Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7A13A49DC
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhFKUIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhFKUIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:08:10 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5FAC0613A2
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:05:59 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id g8so6278220ejx.1
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EfORNi+2Y2IKStIxZVTIGwtIaR3EJi0T8JfetVJhwU0=;
        b=SwWcBuKv5Vavo13i1ICqUAK+7Hik8s6tZkCUjYhCzuEJAwPuzukWOpZshRkkTO5rj+
         YYsMgem73W28j5t8KAiZIiUjgtwbdVmjnc/U0m4ZquWrQIspZBtPL+z9pDkgRGKtpseC
         CjiwtDLGI9KWWNx82OIFvrmMfm1rIpAD9WLbDqfd+cyGlSztPVPRbTZgifGiPzgoTqW2
         LCC3Xf43JHn+SR8Pl97QVD9rHPxqhBMNZLjjMgLV3Ex26CX6mfnMfkhPUMF2kH5MNe90
         PsEynIODnLh77fUMcdWKCaAtyeIOGKgI+XxB3DayVujKb4sizf3VLYQZrRylQu+i4fJ9
         dLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EfORNi+2Y2IKStIxZVTIGwtIaR3EJi0T8JfetVJhwU0=;
        b=XitDKfa3Mv110DynDhevAuV4jLh9kqdldkekbQ97AR1Wp5QN6W8tb/Z5kDeA8u/EY6
         KIfv54FcT+Rrv19AGQsQvNhPrWmDVijy3JQys3iNnkWqM7l2tlxNTtPvdNNJf+84UrjM
         srAuBFXemCUimWH03IPt9ASTYyLG8nxj1UpUdoCxND6Ez5pPaOP0zKSW6ScSSE8hmXc0
         +9Tbc2aYFKrhVtJVYkSeyo3oi5eXd5EwiGDVNF/i6YvP946/nGDYHrfHc5NHQ9RfCm0Q
         ZvhWG7W01gnAQsvQl308zf5TRUOFoEBpHkT1CzVDka9Sxe0d+MtZfFHciPVs0u+1jpfV
         d2Ow==
X-Gm-Message-State: AOAM530zrv05Sk+5DmF5j7je+BNmJzyVfMZUaADMZScEMko2AHVtUdbd
        aMgiHddynqwYvuAai12TAZw=
X-Google-Smtp-Source: ABdhPJzP+vA9jb3DGIIGNJu3qJRUppbCQmTk41Hm+JZ5EO3/+30XmMBx//AnVQouc4e1DSZdEWxhpg==
X-Received: by 2002:a17:906:2c1b:: with SMTP id e27mr5205367ejh.5.1623441958199;
        Fri, 11 Jun 2021 13:05:58 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:05:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 08/13] net: pcs: xpcs: add support for NXP SJA1110
Date:   Fri, 11 Jun 2021 23:05:26 +0300
Message-Id: <20210611200531.2384819-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
References: <20210611200531.2384819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The NXP SJA1110 switch integrates its own, non-Synopsys PMA, but it
manages it through the register space of the XPCS itself, in a small
register window inside MDIO_MMD_VEND2 from address 0x8030 to 0x806e.

This coincides with where the registers for the default Synopsys PMA
are, but the register definitions are of course not the same.

This situation is an odd hardware quirk, but the simplest way to manage
it is to drive the SJA1110's PMA from within the XPCS driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: none

 drivers/net/pcs/pcs-xpcs-nxp.c | 169 +++++++++++++++++++++++++++++++++
 drivers/net/pcs/pcs-xpcs.c     |  21 ++++
 drivers/net/pcs/pcs-xpcs.h     |   2 +
 include/linux/pcs/pcs-xpcs.h   |   1 +
 4 files changed, 193 insertions(+)

diff --git a/drivers/net/pcs/pcs-xpcs-nxp.c b/drivers/net/pcs/pcs-xpcs-nxp.c
index 51b2fc7d36a9..de99c37cf2ae 100644
--- a/drivers/net/pcs/pcs-xpcs-nxp.c
+++ b/drivers/net/pcs/pcs-xpcs-nxp.c
@@ -4,6 +4,66 @@
 #include <linux/pcs/pcs-xpcs.h>
 #include "pcs-xpcs.h"
 
+/* LANE_DRIVER1_0 register */
+#define SJA1110_LANE_DRIVER1_0		0x8038
+#define SJA1110_TXDRV(x)		(((x) << 12) & GENMASK(14, 12))
+
+/* LANE_DRIVER2_0 register */
+#define SJA1110_LANE_DRIVER2_0		0x803a
+#define SJA1110_TXDRVTRIM_LSB(x)	((x) & GENMASK_ULL(15, 0))
+
+/* LANE_DRIVER2_1 register */
+#define SJA1110_LANE_DRIVER2_1		0x803b
+#define SJA1110_LANE_DRIVER2_1_RSV	BIT(9)
+#define SJA1110_TXDRVTRIM_MSB(x)	(((x) & GENMASK_ULL(23, 16)) >> 16)
+
+/* LANE_TRIM register */
+#define SJA1110_LANE_TRIM		0x8040
+#define SJA1110_TXTEN			BIT(11)
+#define SJA1110_TXRTRIM(x)		(((x) << 8) & GENMASK(10, 8))
+#define SJA1110_TXPLL_BWSEL		BIT(7)
+#define SJA1110_RXTEN			BIT(6)
+#define SJA1110_RXRTRIM(x)		(((x) << 3) & GENMASK(5, 3))
+#define SJA1110_CDR_GAIN		BIT(2)
+#define SJA1110_ACCOUPLE_RXVCM_EN	BIT(0)
+
+/* LANE_DATAPATH_1 register */
+#define SJA1110_LANE_DATAPATH_1		0x8037
+
+/* POWERDOWN_ENABLE register */
+#define SJA1110_POWERDOWN_ENABLE	0x8041
+#define SJA1110_TXPLL_PD		BIT(12)
+#define SJA1110_TXPD			BIT(11)
+#define SJA1110_RXPKDETEN		BIT(10)
+#define SJA1110_RXCH_PD			BIT(9)
+#define SJA1110_RXBIAS_PD		BIT(8)
+#define SJA1110_RESET_SER_EN		BIT(7)
+#define SJA1110_RESET_SER		BIT(6)
+#define SJA1110_RESET_DES		BIT(5)
+#define SJA1110_RCVEN			BIT(4)
+
+/* RXPLL_CTRL0 register */
+#define SJA1110_RXPLL_CTRL0		0x8065
+#define SJA1110_RXPLL_FBDIV(x)		(((x) << 2) & GENMASK(9, 2))
+
+/* RXPLL_CTRL1 register */
+#define SJA1110_RXPLL_CTRL1		0x8066
+#define SJA1110_RXPLL_REFDIV(x)		((x) & GENMASK(4, 0))
+
+/* TXPLL_CTRL0 register */
+#define SJA1110_TXPLL_CTRL0		0x806d
+#define SJA1110_TXPLL_FBDIV(x)		((x) & GENMASK(11, 0))
+
+/* TXPLL_CTRL1 register */
+#define SJA1110_TXPLL_CTRL1		0x806e
+#define SJA1110_TXPLL_REFDIV(x)		((x) & GENMASK(5, 0))
+
+/* RX_DATA_DETECT register */
+#define SJA1110_RX_DATA_DETECT		0x8045
+
+/* RX_CDR_CTLE register */
+#define SJA1110_RX_CDR_CTLE		0x8042
+
 /* In NXP SJA1105, the PCS is integrated with a PMA that has the TX lane
  * polarity inverted by default (PLUS is MINUS, MINUS is PLUS). To obtain
  * normal non-inverted behavior, the TX lane polarity must be inverted in the
@@ -14,3 +74,112 @@ int nxp_sja1105_sgmii_pma_config(struct dw_xpcs *xpcs)
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL2,
 			  DW_VR_MII_DIG_CTRL2_TX_POL_INV);
 }
+
+static int nxp_sja1110_pma_config(struct dw_xpcs *xpcs,
+				  u16 txpll_fbdiv, u16 txpll_refdiv,
+				  u16 rxpll_fbdiv, u16 rxpll_refdiv,
+				  u16 rx_cdr_ctle)
+{
+	u16 val;
+	int ret;
+
+	/* Program TX PLL feedback divider and reference divider settings for
+	 * correct oscillation frequency.
+	 */
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_TXPLL_CTRL0,
+			 SJA1110_TXPLL_FBDIV(txpll_fbdiv));
+	if (ret < 0)
+		return ret;
+
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_TXPLL_CTRL1,
+			 SJA1110_TXPLL_REFDIV(txpll_refdiv));
+	if (ret < 0)
+		return ret;
+
+	/* Program transmitter amplitude and disable amplitude trimming */
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_LANE_DRIVER1_0,
+			 SJA1110_TXDRV(0x5));
+	if (ret < 0)
+		return ret;
+
+	val = SJA1110_TXDRVTRIM_LSB(0xffffffull);
+
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_LANE_DRIVER2_0, val);
+	if (ret < 0)
+		return ret;
+
+	val = SJA1110_TXDRVTRIM_MSB(0xffffffull) | SJA1110_LANE_DRIVER2_1_RSV;
+
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_LANE_DRIVER2_1, val);
+	if (ret < 0)
+		return ret;
+
+	/* Enable input and output resistor terminations for low BER. */
+	val = SJA1110_ACCOUPLE_RXVCM_EN | SJA1110_CDR_GAIN |
+	      SJA1110_RXRTRIM(4) | SJA1110_RXTEN | SJA1110_TXPLL_BWSEL |
+	      SJA1110_TXRTRIM(3) | SJA1110_TXTEN;
+
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_LANE_TRIM, val);
+	if (ret < 0)
+		return ret;
+
+	/* Select PCS as transmitter data source. */
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_LANE_DATAPATH_1, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Program RX PLL feedback divider and reference divider for correct
+	 * oscillation frequency.
+	 */
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_RXPLL_CTRL0,
+			 SJA1110_RXPLL_FBDIV(rxpll_fbdiv));
+	if (ret < 0)
+		return ret;
+
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_RXPLL_CTRL1,
+			 SJA1110_RXPLL_REFDIV(rxpll_refdiv));
+	if (ret < 0)
+		return ret;
+
+	/* Program threshold for receiver signal detector.
+	 * Enable control of RXPLL by receiver signal detector to disable RXPLL
+	 * when an input signal is not present.
+	 */
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_RX_DATA_DETECT, 0x0005);
+	if (ret < 0)
+		return ret;
+
+	/* Enable TX and RX PLLs and circuits.
+	 * Release reset of PMA to enable data flow to/from PCS.
+	 */
+	val = xpcs_read(xpcs, MDIO_MMD_VEND2, SJA1110_POWERDOWN_ENABLE);
+	if (val < 0)
+		return val;
+
+	val &= ~(SJA1110_TXPLL_PD | SJA1110_TXPD | SJA1110_RXCH_PD |
+		 SJA1110_RXBIAS_PD | SJA1110_RESET_SER_EN |
+		 SJA1110_RESET_SER | SJA1110_RESET_DES);
+	val |= SJA1110_RXPKDETEN | SJA1110_RCVEN;
+
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_POWERDOWN_ENABLE, val);
+	if (ret < 0)
+		return ret;
+
+	/* Program continuous-time linear equalizer (CTLE) settings. */
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, SJA1110_RX_CDR_CTLE,
+			 rx_cdr_ctle);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int nxp_sja1110_sgmii_pma_config(struct dw_xpcs *xpcs)
+{
+	return nxp_sja1110_pma_config(xpcs, 0x19, 0x1, 0x19, 0x1, 0x212a);
+}
+
+int nxp_sja1110_2500basex_pma_config(struct dw_xpcs *xpcs)
+{
+	return nxp_sja1110_pma_config(xpcs, 0x7d, 0x2, 0x7d, 0x2, 0x732a);
+}
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 3b1baacfaf8f..b66e46fc88dc 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1039,6 +1039,23 @@ static const struct xpcs_compat nxp_sja1105_xpcs_compat[DW_XPCS_INTERFACE_MAX] =
 	},
 };
 
+static const struct xpcs_compat nxp_sja1110_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
+	[DW_XPCS_SGMII] = {
+		.supported = xpcs_sgmii_features,
+		.interface = xpcs_sgmii_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_sgmii_interfaces),
+		.an_mode = DW_AN_C37_SGMII,
+		.pma_config = nxp_sja1110_sgmii_pma_config,
+	},
+	[DW_XPCS_2500BASEX] = {
+		.supported = xpcs_2500basex_features,
+		.interface = xpcs_2500basex_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_2500basex_interfaces),
+		.an_mode = DW_2500BASEX,
+		.pma_config = nxp_sja1110_2500basex_pma_config,
+	},
+};
+
 static const struct xpcs_id xpcs_id_list[] = {
 	{
 		.id = SYNOPSYS_XPCS_ID,
@@ -1048,6 +1065,10 @@ static const struct xpcs_id xpcs_id_list[] = {
 		.id = NXP_SJA1105_XPCS_ID,
 		.mask = SYNOPSYS_XPCS_MASK,
 		.compat = nxp_sja1105_xpcs_compat,
+	}, {
+		.id = NXP_SJA1110_XPCS_ID,
+		.mask = SYNOPSYS_XPCS_MASK,
+		.compat = nxp_sja1110_xpcs_compat,
 	},
 };
 
diff --git a/drivers/net/pcs/pcs-xpcs.h b/drivers/net/pcs/pcs-xpcs.h
index 3daf4276a158..35651d32a224 100644
--- a/drivers/net/pcs/pcs-xpcs.h
+++ b/drivers/net/pcs/pcs-xpcs.h
@@ -111,3 +111,5 @@ int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg);
 int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val);
 
 int nxp_sja1105_sgmii_pma_config(struct dw_xpcs *xpcs);
+int nxp_sja1110_sgmii_pma_config(struct dw_xpcs *xpcs);
+int nxp_sja1110_2500basex_pma_config(struct dw_xpcs *xpcs);
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index c594f7cdc304..dae7dd8ac683 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -11,6 +11,7 @@
 #include <linux/phylink.h>
 
 #define NXP_SJA1105_XPCS_ID		0x00000010
+#define NXP_SJA1110_XPCS_ID		0x00000020
 
 /* AN mode */
 #define DW_AN_C73			1
-- 
2.25.1

