Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910E8544091
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 02:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbiFIA26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 20:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiFIA24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 20:28:56 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150F31B7028;
        Wed,  8 Jun 2022 17:28:55 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bg6so24652710ejb.0;
        Wed, 08 Jun 2022 17:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MmMak1g0Or5/SPEB3988q7jPgBcZiEs6ACLIGroSnsk=;
        b=YJ/+S4sd6V5TTpWe3HozJ6aT4U5QrdBRDxy8HERqMCsYOduLGF+IeYdUMu+4WjQZD4
         yCD6viR0tZPk0htv+QHuhU4aP0/ScEGIBAfR0JeTpEQdrXpOwyoM87SEMJOSuydFpgyc
         WxfUVoYrqoHZP0RAfW60Fx+T9BGiKjbvOQVIhvA3gYlsnYrqQc+2T70o51iwjrmb8n+g
         54a0g302y2sIOnkLe+syaOvH4+qUPNy5dorI0qUTjo+oHq8a1mmaYa6vFKtmOxrVF2hJ
         8ev5j8lGyxWTA9LSg7TVUyN7XRNmoxv4jvSI3OHwcglSqxX6BLMQaJWbSNP/cv0OAe10
         kczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MmMak1g0Or5/SPEB3988q7jPgBcZiEs6ACLIGroSnsk=;
        b=nufKFBktMw1Lgxk9AFoA/n+Of3a3XCBM/6s6sR9St5k/ilCH4ehopjhX+uBrTa0rml
         ri5kNG4dUQZ5ZtxPfm8/gj3ACruwhJOsYN2T1yJOrP4K2S+m0bqnxoy8dCvted2PuOpt
         QUWHTBWdAmuUpF5mXXFOHkt+R4Kg4K40EaSWq/bjXY1WP/Pp0reNqbdaObKHT3hMQ1LC
         5Xy1h60Rrqk5GnCX5T+qnTvA/HZFMc6q5iL1IiOlA/Hd5e/gQrsUWOdzND62/N6hMOeH
         XE3Mm7taApFrTdmZLci3/QLPvXI8mZ7FdsHD+Vg/IQHobwWiDvnGTz5prrWoT1oJ86Me
         VTXQ==
X-Gm-Message-State: AOAM533n82bDQxPirvq5I1HNhnqxaxnu7qTgM5OVrHKFNDChaERCtdUw
        aTdKeZ1oi63gA1rkaWYb+I0=
X-Google-Smtp-Source: ABdhPJxWiOTBDATWmUT0/XEHaIWadZNAuHe/ThI65GnYp+/wA5AuZbJ+tHEdwZOg2U0+MZ8IrjhN9w==
X-Received: by 2002:a17:906:5d07:b0:6ff:40d2:1ff9 with SMTP id g7-20020a1709065d0700b006ff40d21ff9mr34588933ejt.435.1654734532957;
        Wed, 08 Jun 2022 17:28:52 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id g22-20020aa7c596000000b0042deea0e961sm13110325edq.67.2022.06.08.17.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 17:28:52 -0700 (PDT)
From:   Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
Subject: [net-next PATCH 1/2] net: ethernet: stmmac: add missing sgmii configure for ipq806x
Date:   Thu,  9 Jun 2022 02:28:30 +0200
Message-Id: <20220609002831.24236-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The different gmacid require different configuration based on the soc
and on the gmac id. Add these missing configuration taken from the
original driver.

Signed-off-by: Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  1 +
 .../ethernet/stmicro/stmmac/dwmac-ipq806x.c   | 93 +++++++++++++++----
 2 files changed, 78 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 929cfc22cd0c..c4bca16dae57 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -83,6 +83,7 @@ config DWMAC_IPQ806X
 	default ARCH_QCOM
 	depends on OF && (ARCH_QCOM || COMPILE_TEST)
 	select MFD_SYSCON
+	select QCOM_SOCINFO
 	help
 	  Support for QCA IPQ806X DWMAC Ethernet.
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index f7dc8458cde8..832f442254d8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -27,6 +27,8 @@
 #include <linux/stmmac.h>
 #include <linux/of_mdio.h>
 #include <linux/module.h>
+#include <linux/sys_soc.h>
+#include <linux/bitfield.h>
 
 #include "stmmac_platform.h"
 
@@ -75,11 +77,20 @@
 #define QSGMII_PHY_RX_SIGNAL_DETECT_EN		BIT(2)
 #define QSGMII_PHY_TX_DRIVER_EN			BIT(3)
 #define QSGMII_PHY_QSGMII_EN			BIT(7)
-#define QSGMII_PHY_PHASE_LOOP_GAIN_OFFSET	12
-#define QSGMII_PHY_RX_DC_BIAS_OFFSET		18
-#define QSGMII_PHY_RX_INPUT_EQU_OFFSET		20
-#define QSGMII_PHY_CDR_PI_SLEW_OFFSET		22
-#define QSGMII_PHY_TX_DRV_AMP_OFFSET		28
+#define QSGMII_PHY_DEEMPHASIS_LVL_MASK		GENMASK(11, 10)
+#define QSGMII_PHY_DEEMPHASIS_LVL(x)		FIELD_PREP(QSGMII_PHY_DEEMPHASIS_LVL_MASK, (x))
+#define QSGMII_PHY_PHASE_LOOP_GAIN_MASK		GENMASK(14, 12)
+#define QSGMII_PHY_PHASE_LOOP_GAIN(x)		FIELD_PREP(QSGMII_PHY_PHASE_LOOP_GAIN_MASK, (x))
+#define QSGMII_PHY_RX_DC_BIAS_MASK		GENMASK(19, 18)
+#define QSGMII_PHY_RX_DC_BIAS(x)		FIELD_PREP(QSGMII_PHY_RX_DC_BIAS_MASK, (x))
+#define QSGMII_PHY_RX_INPUT_EQU_MASK		GENMASK(21, 20)
+#define QSGMII_PHY_RX_INPUT_EQU(x)		FIELD_PREP(QSGMII_PHY_RX_INPUT_EQU_MASK, (x))
+#define QSGMII_PHY_CDR_PI_SLEW_MASK		GENMASK(23, 22)
+#define QSGMII_PHY_CDR_PI_SLEW(x)		FIELD_PREP(QSGMII_PHY_CDR_PI_SLEW_MASK, (x))
+#define QSGMII_PHY_TX_SLEW_MASK			GENMASK(27, 26)
+#define QSGMII_PHY_TX_SLEW(x)			FIELD_PREP(QSGMII_PHY_TX_SLEW_MASK, (x))
+#define QSGMII_PHY_TX_DRV_AMP_MASK		GENMASK(31, 28)
+#define QSGMII_PHY_TX_DRV_AMP(x)		FIELD_PREP(QSGMII_PHY_TX_DRV_AMP_MASK, (x))
 
 struct ipq806x_gmac {
 	struct platform_device *pdev;
@@ -242,6 +253,64 @@ static void ipq806x_gmac_fix_mac_speed(void *priv, unsigned int speed)
 	ipq806x_gmac_set_speed(gmac, speed);
 }
 
+static const struct soc_device_attribute ipq806x_gmac_soc_v1[] = {
+	{
+		.revision = "1.*",
+	},
+	{
+		/* sentinel */
+	}
+};
+
+static int
+ipq806x_gmac_configure_qsgmii_params(struct ipq806x_gmac *gmac)
+{
+	struct platform_device *pdev = gmac->pdev;
+	const struct soc_device_attribute *soc;
+	struct device *dev = &pdev->dev;
+	u32 qsgmii_param;
+
+	switch (gmac->id) {
+	case 1:
+		soc = soc_device_match(ipq806x_gmac_soc_v1);
+
+		if (soc)
+			qsgmii_param = QSGMII_PHY_TX_DRV_AMP(0xc) |
+				       QSGMII_PHY_TX_SLEW(0x2) |
+				       QSGMII_PHY_DEEMPHASIS_LVL(0x2);
+		else
+			qsgmii_param = QSGMII_PHY_TX_DRV_AMP(0xd) |
+				       QSGMII_PHY_TX_SLEW(0x0) |
+				       QSGMII_PHY_DEEMPHASIS_LVL(0x0);
+
+		qsgmii_param |= QSGMII_PHY_RX_DC_BIAS(0x2);
+		break;
+	case 2:
+	case 3:
+		qsgmii_param = QSGMII_PHY_RX_DC_BIAS(0x3) |
+			       QSGMII_PHY_TX_DRV_AMP(0xc);
+		break;
+	default: /* gmac 0 can't be set in SGMII mode */
+		dev_err(dev, "gmac id %d can't be in SGMII mode", gmac->id);
+		return -EINVAL;
+	}
+
+	/* Common params across all gmac id */
+	qsgmii_param |= QSGMII_PHY_CDR_EN |
+			QSGMII_PHY_RX_FRONT_EN |
+			QSGMII_PHY_RX_SIGNAL_DETECT_EN |
+			QSGMII_PHY_TX_DRIVER_EN |
+			QSGMII_PHY_QSGMII_EN |
+			QSGMII_PHY_PHASE_LOOP_GAIN(0x4) |
+			QSGMII_PHY_RX_INPUT_EQU(0x1) |
+			QSGMII_PHY_CDR_PI_SLEW(0x2);
+
+	regmap_write(gmac->qsgmii_csr, QSGMII_PHY_SGMII_CTL(gmac->id),
+		     qsgmii_param);
+
+	return 0;
+}
+
 static int ipq806x_gmac_probe(struct platform_device *pdev)
 {
 	struct plat_stmmacenet_data *plat_dat;
@@ -328,17 +397,9 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 	regmap_write(gmac->nss_common, NSS_COMMON_CLK_GATE, val);
 
 	if (gmac->phy_mode == PHY_INTERFACE_MODE_SGMII) {
-		regmap_write(gmac->qsgmii_csr, QSGMII_PHY_SGMII_CTL(gmac->id),
-			     QSGMII_PHY_CDR_EN |
-			     QSGMII_PHY_RX_FRONT_EN |
-			     QSGMII_PHY_RX_SIGNAL_DETECT_EN |
-			     QSGMII_PHY_TX_DRIVER_EN |
-			     QSGMII_PHY_QSGMII_EN |
-			     0x4ul << QSGMII_PHY_PHASE_LOOP_GAIN_OFFSET |
-			     0x3ul << QSGMII_PHY_RX_DC_BIAS_OFFSET |
-			     0x1ul << QSGMII_PHY_RX_INPUT_EQU_OFFSET |
-			     0x2ul << QSGMII_PHY_CDR_PI_SLEW_OFFSET |
-			     0xCul << QSGMII_PHY_TX_DRV_AMP_OFFSET);
+		err = ipq806x_gmac_configure_qsgmii_params(gmac);
+		if (err)
+			goto err_remove_config_dt;
 	}
 
 	plat_dat->has_gmac = true;
-- 
2.36.1

