Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B2154AF47
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 13:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242807AbiFNLWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 07:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbiFNLWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 07:22:46 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D4422528;
        Tue, 14 Jun 2022 04:22:45 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x17so10829165wrg.6;
        Tue, 14 Jun 2022 04:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MmMak1g0Or5/SPEB3988q7jPgBcZiEs6ACLIGroSnsk=;
        b=HmfCPZ9AFEQf5tcfiCiiHJ5QwOuxrLWSa95gvikD18rgqitixPy9VCc3STZznWpbN3
         hYwJpQDAG9TuN2+QvEGQOmvioizyGS4YbjmgveDvc75Auv1rthbf0v4kPoNVi7w2XSI7
         XJIt8eVMHWUN4OFnS0U5VAyzTOryvD9iE9l18D9vvARRNas1HlB6gplqo//Muhk9m1tg
         5IzvoyNFBR6P6En894V0FIymlFpivrSY5Vv+iGtzCUQVwXMAzLi6kPalBkcqXcmjyERI
         VD17oOkq4FPeecC/ZhDaVUtj0n2HpOqcQpODLo4Lo2hidkhaDvujCabLnidoY3Anvidj
         JGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MmMak1g0Or5/SPEB3988q7jPgBcZiEs6ACLIGroSnsk=;
        b=UOf9hP25G/BuDKnAdplfHxCLg14Gp9cDvRa1vHaWzfjln1s70oP5vuRA0h9b4aUEhn
         tuV0pvMc8iL+NeqKM6OgWyYHgqQvFj+k9vb+/6D1ZkkBvvz0c5nwx2QFaMJYFyK1YIkV
         Fz5tNhxcIc0qVhk4OcJxhcOYsOAlFNVuBc+xa9uA6ConH5wXHwF2MhoVDRsqAliGKERf
         nU6f3Da2wwknaczsSDudXsBBvH4pway5X7EqfIxvEnTqi21wlvAmqrN+t5Vuyc19UMRa
         7kad8nlP/lysyLLkSNxt4/Y+FJ4VqJlxXJC8VCRzCImGySrsSZqWzUt+04m0+LsuTFn9
         wMeQ==
X-Gm-Message-State: AJIora9eH6LedC5Ono1AHez3ZKWvDo98X29tJxbBCPSpKzY6jwq0w6Dn
        PPGi4WiopYTu4B6+x6QmKcc=
X-Google-Smtp-Source: AGRyM1uRvYAccgLzUm8sQyP0VQB9W6rxEVEwx7oSgwRnFpdc58/r8x0mpUhfhFyo2PIGZAX32wFT2Q==
X-Received: by 2002:a5d:64c4:0:b0:219:b73f:48a7 with SMTP id f4-20020a5d64c4000000b00219b73f48a7mr4387320wri.180.1655205764030;
        Tue, 14 Jun 2022 04:22:44 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id o19-20020a1c4d13000000b0039c60e33702sm12497390wmh.16.2022.06.14.04.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 04:22:43 -0700 (PDT)
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
Subject: [net-next PATCH v2 1/2] net: ethernet: stmmac: add missing sgmii configure for ipq806x
Date:   Tue, 14 Jun 2022 13:22:27 +0200
Message-Id: <20220614112228.1998-1-ansuelsmth@gmail.com>
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

