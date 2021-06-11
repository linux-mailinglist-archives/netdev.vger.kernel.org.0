Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA203A49E2
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhFKUJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:09:14 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:34355 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbhFKUJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:09:12 -0400
Received: by mail-ej1-f46.google.com with SMTP id g8so6278124ejx.1
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T7wwncSNURGEsgeowOhtJO8mYL7PLO2RDK/FvH0d4BA=;
        b=JibP08/r7kOng1p5opU9PpEIZFK8kp2ZS57H/IpKnNt/Ny/Nc9rBO5j4KVSvyewojF
         6DtC4jKF5qXlPXmEwNPWkaZJ1j8XOLR9vJ6wKr6Vm7YmsJivLDuMEKIqxSLpsmzB1QCV
         U4kAQwAcezZezoiqfQKFqbXkzubwEPd++O7X5DpQtLQSaMRc80OCLn7vKfBIxRitlfmr
         PXr9KnwQYnpsU/Cubf4tkLHH/BGqdBvLqJVUuIuporySosyeRFuU5nPlOWqwe3a/jt68
         k/tyYRWZP72nHl6bqFn6fKJVsLN+i3qrHUoUovOPCBID2P+H8lsufbOJ7bhlBlVN8Puc
         1n/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T7wwncSNURGEsgeowOhtJO8mYL7PLO2RDK/FvH0d4BA=;
        b=ANEWojaXBqX0RPBb7A/0XAaUG6hscYMS6OyHkxrh9/TOqAdN560tf2EXb3nqyGQIao
         Vxuza/Eh8FGFDLio7k9SJQWCZl7JwUomvbMkKp+6FaXpR4GPUC3w/vxC+SCYeI4BwuaM
         oqvKWW+nmup0QdM5FiymkgsmoEiNhAtuUT2XqW8UJ2EVh/3GR/QWrVUxTmtRgaEm2Fjz
         uQs+bLuvrNE+cj0dcutIYf7sWV5wt41ikgvhnI6snlkYHgjqTCLen3glgrYAVGlVIhVb
         qfiFrrdnfBrOuQJJv3Jh16qVpjP5paAfCHqRNaKAsFO8wvWQzMwa1M5+kBL/73DUzEs/
         lbAw==
X-Gm-Message-State: AOAM531gKmF0WGR0aD2q748ahL4LKtkksHxkmaxJcFCWv7ViENBz+274
        PMHBKkXaR+lHQs6yY7zkEyE=
X-Google-Smtp-Source: ABdhPJy3mIDI7YmYL+Gs3gMC44xpOsvLdpJNq+xAw+TlpwF7yeYTyH0RqKvn/BJvEtZ0XmDfa4rEbA==
X-Received: by 2002:a17:907:33d0:: with SMTP id zk16mr5172548ejb.144.1623441956689;
        Fri, 11 Jun 2021 13:05:56 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:05:56 -0700 (PDT)
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
Subject: [PATCH v3 net-next 07/13] net: pcs: xpcs: add support for NXP SJA1105
Date:   Fri, 11 Jun 2021 23:05:25 +0300
Message-Id: <20210611200531.2384819-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
References: <20210611200531.2384819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The NXP SJA1105 DSA switch integrates a Synopsys SGMII XPCS on port 4.
The generic code works fine, except there is an integration issue which
needs to be dealt with: in this switch, the XPCS is integrated with a
PMA that has the TX lane polarity inverted by default (PLUS is MINUS,
MINUS is PLUS).

To obtain normal non-inverted behavior, the TX lane polarity must be
inverted in the PCS, via the DIGITAL_CONTROL_2 register.

We introduce a pma_config() method in xpcs_compat which is called by the
phylink_pcs_config() implementation.

Also, the NXP SJA1105 returns all zeroes in the PHY ID registers 2 and 3.
We need to hack up an ad-hoc PHY ID (OUI is zero, device ID is 1) in
order for the XPCS driver to recognize it. This PHY ID is added to the
public include/linux/pcs/pcs-xpcs.h for that reason (for the sja1105
driver to be able to use it in a later patch).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: fix module build (pcs-xpcs-nxp.c is not a different module so
        this means that we need to change the name of pcs-xpcs.ko to
        pcs_xpcs.ko).

 MAINTAINERS                    |  1 +
 drivers/net/pcs/Makefile       |  4 +++-
 drivers/net/pcs/pcs-xpcs-nxp.c | 16 ++++++++++++++++
 drivers/net/pcs/pcs-xpcs.c     | 25 +++++++++++++++++++++++--
 drivers/net/pcs/pcs-xpcs.h     | 10 ++++++++++
 include/linux/pcs/pcs-xpcs.h   |  2 ++
 6 files changed, 55 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/pcs/pcs-xpcs-nxp.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a9509f1b1d9e..05a5d64374e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13201,6 +13201,7 @@ M:	Vladimir Oltean <olteanv@gmail.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/net/dsa/sja1105
+F:	drivers/net/pcs/pcs-xpcs-nxp.c
 
 NXP TDA998X DRM DRIVER
 M:	Russell King <linux@armlinux.org.uk>
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
index c23146755972..0603d469bd57 100644
--- a/drivers/net/pcs/Makefile
+++ b/drivers/net/pcs/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux PCS drivers
 
-obj-$(CONFIG_PCS_XPCS)		+= pcs-xpcs.o
+pcs_xpcs-$(CONFIG_PCS_XPCS)	:= pcs-xpcs.o pcs-xpcs-nxp.o
+
+obj-$(CONFIG_PCS_XPCS)		+= pcs_xpcs.o
 obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
diff --git a/drivers/net/pcs/pcs-xpcs-nxp.c b/drivers/net/pcs/pcs-xpcs-nxp.c
new file mode 100644
index 000000000000..51b2fc7d36a9
--- /dev/null
+++ b/drivers/net/pcs/pcs-xpcs-nxp.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2021 NXP Semiconductors
+ */
+#include <linux/pcs/pcs-xpcs.h>
+#include "pcs-xpcs.h"
+
+/* In NXP SJA1105, the PCS is integrated with a PMA that has the TX lane
+ * polarity inverted by default (PLUS is MINUS, MINUS is PLUS). To obtain
+ * normal non-inverted behavior, the TX lane polarity must be inverted in the
+ * PCS, via the DIGITAL_CONTROL_2 register.
+ */
+int nxp_sja1105_sgmii_pma_config(struct dw_xpcs *xpcs)
+{
+	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL2,
+			  DW_VR_MII_DIG_CTRL2_TX_POL_INV);
+}
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index ecf5011977d3..3b1baacfaf8f 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -117,6 +117,7 @@ struct xpcs_compat {
 	const phy_interface_t *interface;
 	int num_interfaces;
 	int an_mode;
+	int (*pma_config)(struct dw_xpcs *xpcs);
 };
 
 struct xpcs_id {
@@ -168,7 +169,7 @@ static bool __xpcs_linkmode_supported(const struct xpcs_compat *compat,
 #define xpcs_linkmode_supported(compat, mode) \
 	__xpcs_linkmode_supported(compat, ETHTOOL_LINK_MODE_ ## mode ## _BIT)
 
-static int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg)
+int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg)
 {
 	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 	struct mii_bus *bus = xpcs->mdiodev->bus;
@@ -177,7 +178,7 @@ static int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg)
 	return mdiobus_read(bus, addr, reg_addr);
 }
 
-static int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val)
+int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val)
 {
 	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 	struct mii_bus *bus = xpcs->mdiodev->bus;
@@ -788,6 +789,12 @@ static int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 		return -1;
 	}
 
+	if (compat->pma_config) {
+		ret = compat->pma_config(xpcs);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
@@ -1022,11 +1029,25 @@ static const struct xpcs_compat synopsys_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
 	},
 };
 
+static const struct xpcs_compat nxp_sja1105_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
+	[DW_XPCS_SGMII] = {
+		.supported = xpcs_sgmii_features,
+		.interface = xpcs_sgmii_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_sgmii_interfaces),
+		.an_mode = DW_AN_C37_SGMII,
+		.pma_config = nxp_sja1105_sgmii_pma_config,
+	},
+};
+
 static const struct xpcs_id xpcs_id_list[] = {
 	{
 		.id = SYNOPSYS_XPCS_ID,
 		.mask = SYNOPSYS_XPCS_MASK,
 		.compat = synopsys_xpcs_compat,
+	}, {
+		.id = NXP_SJA1105_XPCS_ID,
+		.mask = SYNOPSYS_XPCS_MASK,
+		.compat = nxp_sja1105_xpcs_compat,
 	},
 };
 
diff --git a/drivers/net/pcs/pcs-xpcs.h b/drivers/net/pcs/pcs-xpcs.h
index 867537a68c63..3daf4276a158 100644
--- a/drivers/net/pcs/pcs-xpcs.h
+++ b/drivers/net/pcs/pcs-xpcs.h
@@ -60,10 +60,15 @@
 /* EEE Mode Control Register */
 #define DW_VR_MII_EEE_MCTRL0		0x8006
 #define DW_VR_MII_EEE_MCTRL1		0x800b
+#define DW_VR_MII_DIG_CTRL2		0x80e1
 
 /* VR_MII_DIG_CTRL1 */
 #define DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW		BIT(9)
 
+/* VR_MII_DIG_CTRL2 */
+#define DW_VR_MII_DIG_CTRL2_TX_POL_INV		BIT(4)
+#define DW_VR_MII_DIG_CTRL2_RX_POL_INV		BIT(0)
+
 /* VR_MII_AN_CTRL */
 #define DW_VR_MII_AN_CTRL_TX_CONFIG_SHIFT	3
 #define DW_VR_MII_TX_CONFIG_MASK		BIT(3)
@@ -101,3 +106,8 @@
 
 /* VR MII EEE Control 1 defines */
 #define DW_VR_MII_EEE_TRN_LPI		BIT(0)	/* Transparent Mode Enable */
+
+int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg);
+int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val);
+
+int nxp_sja1105_sgmii_pma_config(struct dw_xpcs *xpcs);
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 4f1cdf6f3d4c..c594f7cdc304 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -10,6 +10,8 @@
 #include <linux/phy.h>
 #include <linux/phylink.h>
 
+#define NXP_SJA1105_XPCS_ID		0x00000010
+
 /* AN mode */
 #define DW_AN_C73			1
 #define DW_AN_C37_SGMII			2
-- 
2.25.1

