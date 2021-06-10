Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CF63A30E3
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhFJQmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhFJQma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:42:30 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A99C0617AD;
        Thu, 10 Jun 2021 09:40:33 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l1so204352ejb.6;
        Thu, 10 Jun 2021 09:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hFh6jYonelvZcVZIn7qh3nwcG8z8TGAQoCmOgPCyB0c=;
        b=Ho8mRlw8cA1XuEW9uN0AMreW1JMmvi9l3Aj9Kg7vSxqQmmyS3SDcDPuX8myEl24zAK
         rk/TkkaWV4FliQvwFsmVbb2sfHecdDmE8F6pvbdujUsM3f5ztTMusZdjZZ6Ccrej2D8g
         EvWZlF96PqJukZ+624VwBvUhQoGIIP49hH26+RzSFdIobezMYpgy8P7e9QbKOrwCk8YK
         Qyk6RI28g0mcXxRfvkYBhWOlFFg/5iddhUv1VZvIWJrceEeM1coDBjpNQF2fipBA/Zd5
         Op7o3UWZkVOxApMH2kM/ySJ5UduXXH8WPt7tq/VDzKZCRKQRFD5AkXdH3FmL95T6Dxmd
         g94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hFh6jYonelvZcVZIn7qh3nwcG8z8TGAQoCmOgPCyB0c=;
        b=C2J0cbNZfg3StmxakGjgHKYSRFNd8SRPl2QNtzcTHttqCZwkbiKZipvaACmvkNB2dP
         uGtuD2nGkFm4l9lVyzj+2murgpWo5Uq2svbHlXs1OdqmuF4FMfO8zAlxWr0hKI1R2BaF
         Eh1Hyn/5Rv9KtgxrbmqzT3Rwtpdf2uvuBrpcu4qiOAgo7IfYeSA7csY//wQsNtYsqClS
         3XuFAq+peMuxmoZHk26SZS3XOPHJ0hBce/HOk+NMLwRIlr4TWsmPLIZmDithwszLRZmZ
         x/o2GG63qXyel9F6v4Y9/ooLoNjetoQ4Xmiy5TIm4DCcD/f+rUNsrG05/JUABW/9wUlP
         Tsuw==
X-Gm-Message-State: AOAM5310IeSyclYw+qB7x5B2IqoFGDnHnD+ff+v2TIXkNl5rKMUo0oEJ
        L/LnCVENcW2FTHVHEGUyRVg=
X-Google-Smtp-Source: ABdhPJyi/Zlj/d1o32zuNleSWskcyk4jc1ktL+9+XUsQLcPbmWXPXvm7q//kgPyvLth7GxXyuG4wZA==
X-Received: by 2002:a17:906:2892:: with SMTP id o18mr474818ejd.124.1623343232068;
        Thu, 10 Jun 2021 09:40:32 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:31 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Grant Likely <grant.likely@arm.com>,
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
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v8 08/15] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
Date:   Thu, 10 Jun 2021 19:39:10 +0300
Message-Id: <20210610163917.4138412-9-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
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
of_mdiobus_phy_device_register() and remove of_find_mii_timestamper()
since it's not needed anymore.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

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
 drivers/net/mdio/of_mdio.c     |  61 +-------------
 include/linux/fwnode_mdio.h    |  35 ++++++++
 6 files changed, 193 insertions(+), 58 deletions(-)
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
index 000000000000..e6985fcf7921
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
+	err = of_parse_phandle_with_fixed_args(to_of_node(fwnode), "timestamper", 1, 0, &arg);
+
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
index d73c0570f19c..9b1cadfd465d 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -32,65 +32,12 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
 }
 
-static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
-{
-	struct of_phandle_args arg;
-	int err;
-
-	err = of_parse_phandle_with_fixed_args(node, "timestamper", 1, 0, &arg);
-
-	if (err == -ENOENT)
-		return NULL;
-	else if (err)
-		return ERR_PTR(err);
-
-	if (arg.args_count != 1)
-		return ERR_PTR(-EINVAL);
-
-	return register_mii_timestamper(arg.np, arg.args[0]);
-}
-
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

