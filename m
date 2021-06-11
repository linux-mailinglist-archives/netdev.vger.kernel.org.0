Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E863A40A3
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhFKK64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:58:56 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:40769 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbhFKK6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:58:03 -0400
Received: by mail-ed1-f45.google.com with SMTP id t3so36608967edc.7;
        Fri, 11 Jun 2021 03:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IoG+8XwXyLviWTaAc/0jgRBQJ98gekWXRq/8laJqJAQ=;
        b=XbT/2X4iB14yus46SeqvHxqLTtVLCc+1s/igD+ctyyDMBKVZIAvHgOiO2Bz1WOufl6
         LD6y99ZtVuPvbKoC/mTEJyS1RVo8GRApFXcPJ8VFnOVyZhnOCJUJjgJBAdIxMAKGoije
         i8WhCsuL1xt2iWp0atME9P4h+JhmC61mzJ1RJs2Onrf985GVRF8chIt/47KUHkfRvTSR
         +e33GzwHpFC6hgKFsZuLKlqBIpOHRPDChpi5/tqHWbHSrdY49DIbHik4GqnGtIbO4Iaj
         lWWFmRWf1Fyb+Pfk83Hk2Xp8wk3TdDUqgA4Gwow4RO24W/+y2BEKJDnl1VEAprf65PsC
         nmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IoG+8XwXyLviWTaAc/0jgRBQJ98gekWXRq/8laJqJAQ=;
        b=R8slkKk/TxwWPeY3a5lVER0sqKyEcnT9S4l4b7gWZM0gcntcBrTSdFarL/D0Cu+ti0
         B0J86Xdgf0+0kuRX1bhBYnl/O7uamFx+tJtmaCN4wryqku+wNYm2ti7Ksiiptw1HBo5P
         24BSbXUGI3deUDAKciz3i64SWyFbn95GXywXw5hPcgmHI+Gaiq9XFPNOZGONXMP4pghg
         I4rIEIpcVdcJDn52vIdM2zC89IOsWmapU9Be7asoRdd+cukp0+/gM1um6eK9xkvXS+/n
         ZmAntvxIgCS0tFEEHI6yuK6dIEKB9QiZrtlUBlABHh7nMT0Qe46RMELqzRxkyDc1Hqit
         a0nw==
X-Gm-Message-State: AOAM531f6u+DL3r1nA+FUwyH6R47rBkMOGv9lWjV2E4zJcwEugZ2L4Rd
        EDvsXRIVyLerQm3E96unSG8=
X-Google-Smtp-Source: ABdhPJy4CUv8It7kiiJyqqCQZaVm2pouG4AB51q1fFJWloukZUi3Sz6muyxYAo7/sOf5cICiGIXtBA==
X-Received: by 2002:aa7:c450:: with SMTP id n16mr3025997edr.386.1623408905055;
        Fri, 11 Jun 2021 03:55:05 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:55:04 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        calvin.johnson@oss.nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v9 08/15] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
Date:   Fri, 11 Jun 2021 13:53:54 +0300
Message-Id: <20210611105401.270673-9-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Introduce fwnode_mdiobus_register_phy() to register PHYs on the
mdiobus. From the compatible string, identify whether the PHY is
c45 and based on this create a PHY device instance which is
registered on the mdiobus.

Along with fwnode_mdiobus_register_phy() also introduce
fwnode_find_mii_timestamper() and fwnode_mdiobus_phy_device_register()
since they are needed.
While at it, also use the newly introduced fwnode operation in
of_mdiobus_phy_device_register().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9:
- fixed the build issue by not removing of_find_mii_timestamper() in
  this patch but rather in the next one

Changes in v8:
- fixed some checkpatch warnings/checks
- included linux/fwnode_mdio.h in fwnode_mdio.c (fixed the build warnings)
- added fwnode_find_mii_timestamper() and fwnode_mdiobus_phy_device_register()
in order to get rid of the cycle dependency.
- change to 'depends on (ACPI || OF) || COMPILE_TEST

Changes in v7:
- Call unregister_mii_timestamper() without NULL check
- Create fwnode_mdio.c and move fwnode_mdiobus_register_phy()

Changes in v6:
- Initialize mii_ts to NULL

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None


 MAINTAINERS                    |   1 +
 drivers/net/mdio/Kconfig       |   7 ++
 drivers/net/mdio/Makefile      |   3 +-
 drivers/net/mdio/fwnode_mdio.c | 144 +++++++++++++++++++++++++++++++++
 drivers/net/mdio/of_mdio.c     |  44 ++--------
 include/linux/fwnode_mdio.h    |  35 ++++++++
 6 files changed, 194 insertions(+), 40 deletions(-)
 create mode 100644 drivers/net/mdio/fwnode_mdio.c
 create mode 100644 include/linux/fwnode_mdio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e69c1991ec3b..e8f8b6c33a51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6811,6 +6811,7 @@ F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
 F:	Documentation/networking/phy.rst
 F:	drivers/net/mdio/
+F:	drivers/net/mdio/fwnode_mdio.c
 F:	drivers/net/mdio/of_mdio.c
 F:	drivers/net/pcs/
 F:	drivers/net/phy/
diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index d06e06f5e31a..422e9e042a3c 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -19,6 +19,13 @@ config MDIO_BUS
 	  reflects whether the mdio_bus/mdio_device code is built as a
 	  loadable module or built-in.
 
+config FWNODE_MDIO
+	def_tristate PHYLIB
+	depends on (ACPI || OF) || COMPILE_TEST
+	select FIXED_PHY
+	help
+	  FWNODE MDIO bus (Ethernet PHY) accessors
+
 config OF_MDIO
 	def_tristate PHYLIB
 	depends on OF
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index c3ec0ef989df..2e6813c709eb 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux MDIO bus drivers
 
-obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
+obj-$(CONFIG_FWNODE_MDIO)	+= fwnode_mdio.o
+obj-$(CONFIG_OF_MDIO)		+= of_mdio.o
 
 obj-$(CONFIG_MDIO_ASPEED)		+= mdio-aspeed.o
 obj-$(CONFIG_MDIO_BCM_IPROC)		+= mdio-bcm-iproc.o
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
new file mode 100644
index 000000000000..e96766da8de4
--- /dev/null
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * fwnode helpers for the MDIO (Ethernet PHY) API
+ *
+ * This file provides helper functions for extracting PHY device information
+ * out of the fwnode and using it to populate an mii_bus.
+ */
+
+#include <linux/acpi.h>
+#include <linux/fwnode_mdio.h>
+#include <linux/of.h>
+#include <linux/phy.h>
+
+MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
+MODULE_LICENSE("GPL");
+
+static struct mii_timestamper *
+fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
+{
+	struct of_phandle_args arg;
+	int err;
+
+	if (is_acpi_node(fwnode))
+		return NULL;
+
+	err = of_parse_phandle_with_fixed_args(to_of_node(fwnode),
+					       "timestamper", 1, 0, &arg);
+	if (err == -ENOENT)
+		return NULL;
+	else if (err)
+		return ERR_PTR(err);
+
+	if (arg.args_count != 1)
+		return ERR_PTR(-EINVAL);
+
+	return register_mii_timestamper(arg.np, arg.args[0]);
+}
+
+int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
+				       struct phy_device *phy,
+				       struct fwnode_handle *child, u32 addr)
+{
+	int rc;
+
+	rc = fwnode_irq_get(child, 0);
+	if (rc == -EPROBE_DEFER)
+		return rc;
+
+	if (rc > 0) {
+		phy->irq = rc;
+		mdio->irq[addr] = rc;
+	} else {
+		phy->irq = mdio->irq[addr];
+	}
+
+	if (fwnode_property_read_bool(child, "broken-turn-around"))
+		mdio->phy_ignore_ta_mask |= 1 << addr;
+
+	fwnode_property_read_u32(child, "reset-assert-us",
+				 &phy->mdio.reset_assert_delay);
+	fwnode_property_read_u32(child, "reset-deassert-us",
+				 &phy->mdio.reset_deassert_delay);
+
+	/* Associate the fwnode with the device structure so it
+	 * can be looked up later
+	 */
+	fwnode_handle_get(child);
+	phy->mdio.dev.fwnode = child;
+
+	/* All data is now stored in the phy struct;
+	 * register it
+	 */
+	rc = phy_device_register(phy);
+	if (rc) {
+		fwnode_handle_put(child);
+		return rc;
+	}
+
+	dev_dbg(&mdio->dev, "registered phy %p fwnode at address %i\n",
+		child, addr);
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_phy_device_register);
+
+int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				struct fwnode_handle *child, u32 addr)
+{
+	struct mii_timestamper *mii_ts = NULL;
+	struct phy_device *phy;
+	bool is_c45 = false;
+	u32 phy_id;
+	int rc;
+
+	mii_ts = fwnode_find_mii_timestamper(child);
+	if (IS_ERR(mii_ts))
+		return PTR_ERR(mii_ts);
+
+	rc = fwnode_property_match_string(child, "compatible",
+					  "ethernet-phy-ieee802.3-c45");
+	if (rc >= 0)
+		is_c45 = true;
+
+	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
+		phy = get_phy_device(bus, addr, is_c45);
+	else
+		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
+	if (IS_ERR(phy)) {
+		unregister_mii_timestamper(mii_ts);
+		return PTR_ERR(phy);
+	}
+
+	if (is_acpi_node(child)) {
+		phy->irq = bus->irq[addr];
+
+		/* Associate the fwnode with the device structure so it
+		 * can be looked up later.
+		 */
+		phy->mdio.dev.fwnode = child;
+
+		/* All data is now stored in the phy struct, so register it */
+		rc = phy_device_register(phy);
+		if (rc) {
+			phy_device_free(phy);
+			fwnode_handle_put(phy->mdio.dev.fwnode);
+			return rc;
+		}
+	} else if (is_of_node(child)) {
+		rc = fwnode_mdiobus_phy_device_register(bus, phy, child, addr);
+		if (rc) {
+			unregister_mii_timestamper(mii_ts);
+			phy_device_free(phy);
+			return rc;
+		}
+	}
+
+	/* phy->mii_ts may already be defined by the PHY driver. A
+	 * mii_timestamper probed via the device tree will still have
+	 * precedence.
+	 */
+	if (mii_ts)
+		phy->mii_ts = mii_ts;
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index d73c0570f19c..17327bbc1de4 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -10,6 +10,7 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/fwnode_mdio.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
@@ -51,46 +52,11 @@ static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
 }
 
 int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
-			      struct device_node *child, u32 addr)
+				   struct device_node *child, u32 addr)
 {
-	int rc;
-
-	rc = of_irq_get(child, 0);
-	if (rc == -EPROBE_DEFER)
-		return rc;
-
-	if (rc > 0) {
-		phy->irq = rc;
-		mdio->irq[addr] = rc;
-	} else {
-		phy->irq = mdio->irq[addr];
-	}
-
-	if (of_property_read_bool(child, "broken-turn-around"))
-		mdio->phy_ignore_ta_mask |= 1 << addr;
-
-	of_property_read_u32(child, "reset-assert-us",
-			     &phy->mdio.reset_assert_delay);
-	of_property_read_u32(child, "reset-deassert-us",
-			     &phy->mdio.reset_deassert_delay);
-
-	/* Associate the OF node with the device structure so it
-	 * can be looked up later */
-	of_node_get(child);
-	phy->mdio.dev.of_node = child;
-	phy->mdio.dev.fwnode = of_fwnode_handle(child);
-
-	/* All data is now stored in the phy struct;
-	 * register it */
-	rc = phy_device_register(phy);
-	if (rc) {
-		of_node_put(child);
-		return rc;
-	}
-
-	dev_dbg(&mdio->dev, "registered phy %pOFn at address %i\n",
-		child, addr);
-	return 0;
+	return fwnode_mdiobus_phy_device_register(mdio, phy,
+						  of_fwnode_handle(child),
+						  addr);
 }
 EXPORT_SYMBOL(of_mdiobus_phy_device_register);
 
diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
new file mode 100644
index 000000000000..faf603c48c86
--- /dev/null
+++ b/include/linux/fwnode_mdio.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * FWNODE helper for the MDIO (Ethernet PHY) API
+ */
+
+#ifndef __LINUX_FWNODE_MDIO_H
+#define __LINUX_FWNODE_MDIO_H
+
+#include <linux/phy.h>
+
+#if IS_ENABLED(CONFIG_FWNODE_MDIO)
+int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
+				       struct phy_device *phy,
+				       struct fwnode_handle *child, u32 addr);
+
+int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+				struct fwnode_handle *child, u32 addr);
+
+#else /* CONFIG_FWNODE_MDIO */
+int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
+				       struct phy_device *phy,
+				       struct fwnode_handle *child, u32 addr)
+{
+	return -EINVAL;
+}
+
+static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
+					      struct fwnode_handle *child,
+					      u32 addr)
+{
+	return -EINVAL;
+}
+#endif
+
+#endif /* __LINUX_FWNODE_MDIO_H */
-- 
2.31.1

