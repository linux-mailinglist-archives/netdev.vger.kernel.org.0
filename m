Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331143A32D0
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFJSQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhFJSQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:16:43 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61171C061760
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:14:32 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ce15so620799ejb.4
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G07YeSLYEs/CHaiFtuKkZ30d/lVM7JF2e8O5v758x8Y=;
        b=Ar07Llw+O+n+EBKbXKCY6ckOmFSHeGu1VPIdQJHp33g90LN0wqKmGbQ+NGZPxRUVRr
         yF7R7MgY/stuZTHWQe3Isbiv83CTln9f8UpVGCoZkOJo6c82R1yQnfGHA3ZF1Bl7DI2B
         2SOEK7iMAwMTZkOTXtIKxpVIRhQCZYEO1o0UrH/i2LRvaLIozs0c8if/L9KVcxO7kOtD
         RVf04ZFEttVl4VFVxOSqtGcqQgVyJV7gKFoMaNbfmS/Ykkdk5zzNjYn15pF5LITgJFuU
         yXFpgq1j1JVbqyTuLJAGVy+HvNbzWQmk7QJhXsWtYdh8nEm4/jOVjNwdBkkYJEnvR22/
         cERQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G07YeSLYEs/CHaiFtuKkZ30d/lVM7JF2e8O5v758x8Y=;
        b=MdNnzZ4JaAdsBPgOCIp9c/WBWAW8eMQt0a3tlV8zWzxnEVKUjzRSogdBqMFFIcIydF
         qdcUMxoiwK5CpjXhiKMXWNiCu6Q/vF8L2MTmn75iZ7EqP4LkJmoU2MAi3Kfz8slywmlI
         jwn9lj5vMxTBxa3+PtAIFnv9eU2zmk/y8Xz8j8BpUDHYdC8AuwSgGWrLeJF70xbJADWC
         RFNHGW/FEfIQyew3YPToJpXjQ48FG979va7Ia5FepmT5EISfO+sJEhdiIT1l2orCnC/W
         DkdvLYtBO0fnEcTdPF8BfEu8eHvfUKxXyB9eM8zQiqjirtfJKj03hR0uBu0mZp4tNd78
         DRXA==
X-Gm-Message-State: AOAM530S5M8nbHgG0kFcU8IBTiQv+zxFgfqhgC/zLUXxfz8e/h1wCFe0
        kliZVg1WqEJYFWx9HkcjuYg=
X-Google-Smtp-Source: ABdhPJwdyvfSeO/GK14PTJGI6kBFj+r1VZx8kagpkD/qUIrYy6h6oDS81cLfG0BIyh7VAiMy9qtRxw==
X-Received: by 2002:a17:906:1912:: with SMTP id a18mr833650eje.117.1623348870860;
        Thu, 10 Jun 2021 11:14:30 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:29 -0700 (PDT)
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
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 04/13] net: pcs: xpcs: move register bit descriptions to a header file
Date:   Thu, 10 Jun 2021 21:14:01 +0300
Message-Id: <20210610181410.1886658-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
References: <20210610181410.1886658-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Vendors which integrate the Designware XPCS might modify a few things
here and there, and to support those, it's best to create separate C
files in order to not clutter up the main pcs-xpcs.c.

Because the vendor files might want to access the common xpcs registers
too, let's move them in a header file which is local to this driver and
can be included by vendor files as appropriate.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 MAINTAINERS                |   1 +
 drivers/net/pcs/pcs-xpcs.c |  97 +---------------------------------
 drivers/net/pcs/pcs-xpcs.h | 103 +++++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+), 96 deletions(-)
 create mode 100644 drivers/net/pcs/pcs-xpcs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 85a87a93e194..004c0d1e723d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17682,6 +17682,7 @@ M:	Jose Abreu <Jose.Abreu@synopsys.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/pcs/pcs-xpcs.c
+F:	drivers/net/pcs/pcs-xpcs.h
 F:	include/linux/pcs/pcs-xpcs.h
 
 SYNOPSYS DESIGNWARE I2C DRIVER
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index a2cbb2d926b7..8ca7592b02ec 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -11,102 +11,7 @@
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 #include <linux/workqueue.h>
-
-#define SYNOPSYS_XPCS_ID		0x7996ced0
-#define SYNOPSYS_XPCS_MASK		0xffffffff
-
-/* Vendor regs access */
-#define DW_VENDOR			BIT(15)
-
-/* VR_XS_PCS */
-#define DW_USXGMII_RST			BIT(10)
-#define DW_USXGMII_EN			BIT(9)
-#define DW_VR_XS_PCS_DIG_STS		0x0010
-#define DW_RXFIFO_ERR			GENMASK(6, 5)
-
-/* SR_MII */
-#define DW_USXGMII_FULL			BIT(8)
-#define DW_USXGMII_SS_MASK		(BIT(13) | BIT(6) | BIT(5))
-#define DW_USXGMII_10000		(BIT(13) | BIT(6))
-#define DW_USXGMII_5000			(BIT(13) | BIT(5))
-#define DW_USXGMII_2500			(BIT(5))
-#define DW_USXGMII_1000			(BIT(6))
-#define DW_USXGMII_100			(BIT(13))
-#define DW_USXGMII_10			(0)
-
-/* SR_AN */
-#define DW_SR_AN_ADV1			0x10
-#define DW_SR_AN_ADV2			0x11
-#define DW_SR_AN_ADV3			0x12
-#define DW_SR_AN_LP_ABL1		0x13
-#define DW_SR_AN_LP_ABL2		0x14
-#define DW_SR_AN_LP_ABL3		0x15
-
-/* Clause 73 Defines */
-/* AN_LP_ABL1 */
-#define DW_C73_PAUSE			BIT(10)
-#define DW_C73_ASYM_PAUSE		BIT(11)
-#define DW_C73_AN_ADV_SF		0x1
-/* AN_LP_ABL2 */
-#define DW_C73_1000KX			BIT(5)
-#define DW_C73_10000KX4			BIT(6)
-#define DW_C73_10000KR			BIT(7)
-/* AN_LP_ABL3 */
-#define DW_C73_2500KX			BIT(0)
-#define DW_C73_5000KR			BIT(1)
-
-/* Clause 37 Defines */
-/* VR MII MMD registers offsets */
-#define DW_VR_MII_MMD_CTRL		0x0000
-#define DW_VR_MII_DIG_CTRL1		0x8000
-#define DW_VR_MII_AN_CTRL		0x8001
-#define DW_VR_MII_AN_INTR_STS		0x8002
-/* Enable 2.5G Mode */
-#define DW_VR_MII_DIG_CTRL1_2G5_EN	BIT(2)
-/* EEE Mode Control Register */
-#define DW_VR_MII_EEE_MCTRL0		0x8006
-#define DW_VR_MII_EEE_MCTRL1		0x800b
-
-/* VR_MII_DIG_CTRL1 */
-#define DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW		BIT(9)
-
-/* VR_MII_AN_CTRL */
-#define DW_VR_MII_AN_CTRL_TX_CONFIG_SHIFT	3
-#define DW_VR_MII_TX_CONFIG_MASK		BIT(3)
-#define DW_VR_MII_TX_CONFIG_PHY_SIDE_SGMII	0x1
-#define DW_VR_MII_TX_CONFIG_MAC_SIDE_SGMII	0x0
-#define DW_VR_MII_AN_CTRL_PCS_MODE_SHIFT	1
-#define DW_VR_MII_PCS_MODE_MASK			GENMASK(2, 1)
-#define DW_VR_MII_PCS_MODE_C37_1000BASEX	0x0
-#define DW_VR_MII_PCS_MODE_C37_SGMII		0x2
-
-/* VR_MII_AN_INTR_STS */
-#define DW_VR_MII_AN_STS_C37_ANSGM_FD		BIT(1)
-#define DW_VR_MII_AN_STS_C37_ANSGM_SP_SHIFT	2
-#define DW_VR_MII_AN_STS_C37_ANSGM_SP		GENMASK(3, 2)
-#define DW_VR_MII_C37_ANSGM_SP_10		0x0
-#define DW_VR_MII_C37_ANSGM_SP_100		0x1
-#define DW_VR_MII_C37_ANSGM_SP_1000		0x2
-#define DW_VR_MII_C37_ANSGM_SP_LNKSTS		BIT(4)
-
-/* SR MII MMD Control defines */
-#define AN_CL37_EN		BIT(12)	/* Enable Clause 37 auto-nego */
-#define SGMII_SPEED_SS13	BIT(13)	/* SGMII speed along with SS6 */
-#define SGMII_SPEED_SS6		BIT(6)	/* SGMII speed along with SS13 */
-
-/* VR MII EEE Control 0 defines */
-#define DW_VR_MII_EEE_LTX_EN		BIT(0)  /* LPI Tx Enable */
-#define DW_VR_MII_EEE_LRX_EN		BIT(1)  /* LPI Rx Enable */
-#define DW_VR_MII_EEE_TX_QUIET_EN		BIT(2)  /* Tx Quiet Enable */
-#define DW_VR_MII_EEE_RX_QUIET_EN		BIT(3)  /* Rx Quiet Enable */
-#define DW_VR_MII_EEE_TX_EN_CTRL		BIT(4)  /* Tx Control Enable */
-#define DW_VR_MII_EEE_RX_EN_CTRL		BIT(7)  /* Rx Control Enable */
-
-#define DW_VR_MII_EEE_MULT_FACT_100NS_SHIFT	8
-#define DW_VR_MII_EEE_MULT_FACT_100NS		GENMASK(11, 8)
-
-/* VR MII EEE Control 1 defines */
-#define DW_VR_MII_EEE_TRN_LPI		BIT(0)	/* Transparent Mode Enable */
+#include "pcs-xpcs.h"
 
 #define phylink_pcs_to_xpcs(pl_pcs) \
 	container_of((pl_pcs), struct dw_xpcs, pcs)
diff --git a/drivers/net/pcs/pcs-xpcs.h b/drivers/net/pcs/pcs-xpcs.h
new file mode 100644
index 000000000000..867537a68c63
--- /dev/null
+++ b/drivers/net/pcs/pcs-xpcs.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2020 Synopsys, Inc. and/or its affiliates.
+ * Synopsys DesignWare XPCS helpers
+ *
+ * Author: Jose Abreu <Jose.Abreu@synopsys.com>
+ */
+
+#define SYNOPSYS_XPCS_ID		0x7996ced0
+#define SYNOPSYS_XPCS_MASK		0xffffffff
+
+/* Vendor regs access */
+#define DW_VENDOR			BIT(15)
+
+/* VR_XS_PCS */
+#define DW_USXGMII_RST			BIT(10)
+#define DW_USXGMII_EN			BIT(9)
+#define DW_VR_XS_PCS_DIG_STS		0x0010
+#define DW_RXFIFO_ERR			GENMASK(6, 5)
+
+/* SR_MII */
+#define DW_USXGMII_FULL			BIT(8)
+#define DW_USXGMII_SS_MASK		(BIT(13) | BIT(6) | BIT(5))
+#define DW_USXGMII_10000		(BIT(13) | BIT(6))
+#define DW_USXGMII_5000			(BIT(13) | BIT(5))
+#define DW_USXGMII_2500			(BIT(5))
+#define DW_USXGMII_1000			(BIT(6))
+#define DW_USXGMII_100			(BIT(13))
+#define DW_USXGMII_10			(0)
+
+/* SR_AN */
+#define DW_SR_AN_ADV1			0x10
+#define DW_SR_AN_ADV2			0x11
+#define DW_SR_AN_ADV3			0x12
+#define DW_SR_AN_LP_ABL1		0x13
+#define DW_SR_AN_LP_ABL2		0x14
+#define DW_SR_AN_LP_ABL3		0x15
+
+/* Clause 73 Defines */
+/* AN_LP_ABL1 */
+#define DW_C73_PAUSE			BIT(10)
+#define DW_C73_ASYM_PAUSE		BIT(11)
+#define DW_C73_AN_ADV_SF		0x1
+/* AN_LP_ABL2 */
+#define DW_C73_1000KX			BIT(5)
+#define DW_C73_10000KX4			BIT(6)
+#define DW_C73_10000KR			BIT(7)
+/* AN_LP_ABL3 */
+#define DW_C73_2500KX			BIT(0)
+#define DW_C73_5000KR			BIT(1)
+
+/* Clause 37 Defines */
+/* VR MII MMD registers offsets */
+#define DW_VR_MII_MMD_CTRL		0x0000
+#define DW_VR_MII_DIG_CTRL1		0x8000
+#define DW_VR_MII_AN_CTRL		0x8001
+#define DW_VR_MII_AN_INTR_STS		0x8002
+/* Enable 2.5G Mode */
+#define DW_VR_MII_DIG_CTRL1_2G5_EN	BIT(2)
+/* EEE Mode Control Register */
+#define DW_VR_MII_EEE_MCTRL0		0x8006
+#define DW_VR_MII_EEE_MCTRL1		0x800b
+
+/* VR_MII_DIG_CTRL1 */
+#define DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW		BIT(9)
+
+/* VR_MII_AN_CTRL */
+#define DW_VR_MII_AN_CTRL_TX_CONFIG_SHIFT	3
+#define DW_VR_MII_TX_CONFIG_MASK		BIT(3)
+#define DW_VR_MII_TX_CONFIG_PHY_SIDE_SGMII	0x1
+#define DW_VR_MII_TX_CONFIG_MAC_SIDE_SGMII	0x0
+#define DW_VR_MII_AN_CTRL_PCS_MODE_SHIFT	1
+#define DW_VR_MII_PCS_MODE_MASK			GENMASK(2, 1)
+#define DW_VR_MII_PCS_MODE_C37_1000BASEX	0x0
+#define DW_VR_MII_PCS_MODE_C37_SGMII		0x2
+
+/* VR_MII_AN_INTR_STS */
+#define DW_VR_MII_AN_STS_C37_ANSGM_FD		BIT(1)
+#define DW_VR_MII_AN_STS_C37_ANSGM_SP_SHIFT	2
+#define DW_VR_MII_AN_STS_C37_ANSGM_SP		GENMASK(3, 2)
+#define DW_VR_MII_C37_ANSGM_SP_10		0x0
+#define DW_VR_MII_C37_ANSGM_SP_100		0x1
+#define DW_VR_MII_C37_ANSGM_SP_1000		0x2
+#define DW_VR_MII_C37_ANSGM_SP_LNKSTS		BIT(4)
+
+/* SR MII MMD Control defines */
+#define AN_CL37_EN			BIT(12)	/* Enable Clause 37 auto-nego */
+#define SGMII_SPEED_SS13		BIT(13)	/* SGMII speed along with SS6 */
+#define SGMII_SPEED_SS6			BIT(6)	/* SGMII speed along with SS13 */
+
+/* VR MII EEE Control 0 defines */
+#define DW_VR_MII_EEE_LTX_EN			BIT(0)  /* LPI Tx Enable */
+#define DW_VR_MII_EEE_LRX_EN			BIT(1)  /* LPI Rx Enable */
+#define DW_VR_MII_EEE_TX_QUIET_EN		BIT(2)  /* Tx Quiet Enable */
+#define DW_VR_MII_EEE_RX_QUIET_EN		BIT(3)  /* Rx Quiet Enable */
+#define DW_VR_MII_EEE_TX_EN_CTRL		BIT(4)  /* Tx Control Enable */
+#define DW_VR_MII_EEE_RX_EN_CTRL		BIT(7)  /* Rx Control Enable */
+
+#define DW_VR_MII_EEE_MULT_FACT_100NS_SHIFT	8
+#define DW_VR_MII_EEE_MULT_FACT_100NS		GENMASK(11, 8)
+
+/* VR MII EEE Control 1 defines */
+#define DW_VR_MII_EEE_TRN_LPI		BIT(0)	/* Transparent Mode Enable */
-- 
2.25.1

