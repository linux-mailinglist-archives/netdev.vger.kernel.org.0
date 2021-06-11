Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995C73A49D9
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhFKUIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhFKUIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:08:04 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C95FC0617AF
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:05:53 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id he7so6197270ejc.13
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7rf5mkLuUypq0h7ZqDlXOvS/OCZFflVmrxJpR4TU2eA=;
        b=t4VE3vgG7a2dNm2KQ0jY/pcL4ZpcfnsnP4N/bYaYo4FxU/60OdMpn50QlQ6ZAXmCj6
         XmCx+MTq1LRK5dkoa2bCbaJMf42xXIrpkgfiLa8YOVaV5HTZf2WCHiACEjVHOJZLBsv1
         bQ+r/8vr0fpTSH67pE1HQqaFEof+Um/FBu+ts6mg2LQf2FySDvnQTOqi3FPrtfQqiatV
         4IG2muGBxmF5XVF94iiFrTXWojIN0YjW41f0DRDUVnrCu15xqxldzqAVfONHZ6rJmNux
         vUIfNzw3HFN4L9gWOPNjP3PZ7IizwVY6QcC8bp3iA8Luz7DVWGDLBL78yk8X/cdOiPKx
         YsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7rf5mkLuUypq0h7ZqDlXOvS/OCZFflVmrxJpR4TU2eA=;
        b=bCx42wHyjS3cI606D54dbWbut2HtEgFZFmnBSPzw4eq7lgup5HVRRFAWrDYx6ktEXd
         282RG15nB0HMJ6YTq/bWrVQRa0ZsztCxF6EymuwnotcpPLnYCC24IPzbQUL+s1IpqMwR
         VBzq+V8M6jgwpnOAO6Im9JX8G4WXkGd9SSJaPo7J+9Z0AQw9q9cJ9ZWZeNL5N6pciMqO
         +VapgiT9c0F2o5bSmxJqVmNp2IBTVrNhJXE9/uuWuguZaIMaR0TiwA5EY8pVdjuXssAr
         LuB4s7O9u9W1PC2w/p1HENEpSJ6408zRL+gDnqBcg8ozp+GtSD7qtHZq6QI1U7NK9Sh5
         dLOA==
X-Gm-Message-State: AOAM530grZmgXJ9adFqVZV/981BGFkxzvU3xLMMJmKxfR1g2eoDWrJmC
        7RcxrwwNbX3dYITD3WIKcZ0=
X-Google-Smtp-Source: ABdhPJyX2aRStoWQOKLr6waovMSjYq08hLi0hGba4pRj00UF0JHkCfoaNzggn9/VQj4eUEeI80iUgg==
X-Received: by 2002:a17:906:d297:: with SMTP id ay23mr5137857ejb.418.1623441951940;
        Fri, 11 Jun 2021 13:05:51 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:05:51 -0700 (PDT)
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
Subject: [PATCH v3 net-next 04/13] net: pcs: xpcs: move register bit descriptions to a header file
Date:   Fri, 11 Jun 2021 23:05:22 +0300
Message-Id: <20210611200531.2384819-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
References: <20210611200531.2384819-1-olteanv@gmail.com>
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
v2->v3: none
v1->v2: none

 MAINTAINERS                |   1 +
 drivers/net/pcs/pcs-xpcs.c |  97 +---------------------------------
 drivers/net/pcs/pcs-xpcs.h | 103 +++++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+), 96 deletions(-)
 create mode 100644 drivers/net/pcs/pcs-xpcs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e69c1991ec3b..a9509f1b1d9e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17674,6 +17674,7 @@ M:	Jose Abreu <Jose.Abreu@synopsys.com>
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

