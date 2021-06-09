Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7533E3A1CE9
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhFISoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhFISoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:44:17 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85276C061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 11:42:22 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l1so39933150ejb.6
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jj1042usoUaQh/SdhL4YBrLAd/mZYkKZCKI2AfAJVps=;
        b=p5c3txWibIDWDliQFaREus1g0kSkgRIEqN01yfWz6wdlEN+LpTZlk0L94wf5zcAhKF
         7Cf3iuB46AQxIxehzFefiWKNeYBDfNMDut0oFKaf8V8Fg+YlR6U452doOevqacL+FUpz
         Zulprg8SUNDLPca8YG1uTt3yldMEiTwWkl14O57AjsdmBf9aeLUNYu/O8Pmluk4bGjSH
         wzzyxzMsvmC7LbHLn56E/xLiVR7AUfUn/wTc/oFppOAl+71eAk5VrDNoFQ5fX2n9nAsg
         3sMlje/iJjC1tdJF2w/n+JQQS65pMztGItWFy1frYUZXyRZ0qLhhy3YDoTvdTggA6BoN
         /QCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jj1042usoUaQh/SdhL4YBrLAd/mZYkKZCKI2AfAJVps=;
        b=Rd9gqzlzqSmDuVB2HFG+j4xb7j2JyHDp15BrfUG865fv+hNH1G5sC0yMHerHDrQ1dv
         alBe1HXjo+R+1e9je9HCjqDuctUy/VFU8cP0jtiwNCmyZ8ZkoQxzNCByKLX55SUaZLjj
         y4ihgZ+smmcolj+EAsddklqKhxZiqQhGkU1z/pzxLmdyUFYaDyIz1d1g1kIQbO9ntNnL
         Eb+SimsOWDCzllymmo9Uk0JAd85mazwLYzeixyIu/GkyYkb/CXTto7vCPzCrPgUV9PPS
         LX2KQPNeD36nrp8/ohJYzp3fxodBNfEVDp7/nPMgVsIIqCRw3kw4FSpCNhu1w0D/fTCt
         NmpA==
X-Gm-Message-State: AOAM532flN7eAlGYwvIxnu/cJSY5SMuNvh3qk2eoUfjCyM0awBKdWDdq
        HGbmYRcdEHlNdg9dcXW99mo=
X-Google-Smtp-Source: ABdhPJwneE+Frgm/M9lXs8nO35cC0R1vL3B7KjG45NkqaccJlqVEzU068ni07cXjKKyLXvP3AqU/xg==
X-Received: by 2002:a17:906:e104:: with SMTP id gj4mr1176128ejb.350.1623264141003;
        Wed, 09 Jun 2021 11:42:21 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id oz11sm194935ejb.16.2021.06.09.11.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:42:20 -0700 (PDT)
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
Subject: [PATCH net-next 07/13] net: pcs: xpcs: add support for NXP SJA1105
Date:   Wed,  9 Jun 2021 21:41:49 +0300
Message-Id: <20210609184155.921662-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609184155.921662-1-olteanv@gmail.com>
References: <20210609184155.921662-1-olteanv@gmail.com>
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
 MAINTAINERS                    |  1 +
 drivers/net/pcs/Makefile       |  2 +-
 drivers/net/pcs/pcs-xpcs-nxp.c | 16 ++++++++++++++++
 drivers/net/pcs/pcs-xpcs.c     | 25 +++++++++++++++++++++++--
 drivers/net/pcs/pcs-xpcs.h     | 10 ++++++++++
 include/linux/pcs/pcs-xpcs.h   |  2 ++
 6 files changed, 53 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/pcs/pcs-xpcs-nxp.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 004c0d1e723d..c0ba005349fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13209,6 +13209,7 @@ M:	Vladimir Oltean <olteanv@gmail.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/net/dsa/sja1105
+F:	drivers/net/pcs/pcs-xpcs-nxp.c
 
 NXP TDA998X DRM DRIVER
 M:	Russell King <linux@armlinux.org.uk>
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
index c23146755972..d12b00e48358 100644
--- a/drivers/net/pcs/Makefile
+++ b/drivers/net/pcs/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux PCS drivers
 
-obj-$(CONFIG_PCS_XPCS)		+= pcs-xpcs.o
+obj-$(CONFIG_PCS_XPCS)		+= pcs-xpcs.o pcs-xpcs-nxp.o
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

