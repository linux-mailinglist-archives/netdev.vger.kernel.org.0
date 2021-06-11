Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C803A4091
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhFKK5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhFKK5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:57:30 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E32DC0613A4;
        Fri, 11 Jun 2021 03:55:17 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ho18so3901309ejc.8;
        Fri, 11 Jun 2021 03:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jIku+SUxsHEOSxoQcz7D5aJYws7YqOlKpfXAqwjLSzk=;
        b=Y265f3PSDjRMjK1R4E/1OKrg3C0lTTShbOBsyJfHPA52dJs6QEXAU+V7eJZqufE25p
         4J8kAFaYAgxxYsIo2n6GfkbUWdYBht7a6WHxQSxel2Kb1BiEK1R/Q8MHch92b9deVBuX
         0lJY5lC1CoN+YOEe/A7vwM5mB+7NEqg+HX8qYs94L68Gl61bqS1qefrN9BJncbhHg/tA
         YKCiiQh3FvGMCEWFNMn9CMSRGqGgWm7MM7VSzrRi6Nyz/nl1Gi1pBPE0IFy/nN5aNDgK
         S1YZJnAySfr+Iml8qbqW/m/Sh/CfzpNZjX2IFD9ONJXzJgQP9YaCtPM93ur46foBZF7u
         ikpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jIku+SUxsHEOSxoQcz7D5aJYws7YqOlKpfXAqwjLSzk=;
        b=klUZciSRMswK4zvPrXMUCpq8CFV0JvEVAnbKIViFxHIjpKiytem9XX8I1NEctTzoEN
         HQnnCP7BtbTTbJAJEUXE1XTyTJMYpDFfMEW8gAhw17Sge86f2v/eU+3TUh6PWG+Qc6Oc
         CVJpHpGtpzUOI2Os5/SR/nkjIMnTAaXM4VqpyoYzfpEZoJmXLTpNFY3J+kmELwgzdL8A
         LEsCV5rverxee7cfIdFLHBfSgXkWQvve10W65O0/fPNdvsny5KJ0s/zL83nqT/hHMAPN
         jswr8fFe+fR3qyrwp7ejzoDMlxcGQlDoK607KdzSGlWAXDaZt8TkJHJ7Ry+P6JP7AKJd
         IM9A==
X-Gm-Message-State: AOAM532Uo/DUQxxul/Gab58ZMV9MUisZke3p+TgdCNDv3L9DWZnPJ3tT
        ojwgjHoMhzB3yerLliGiKSQ=
X-Google-Smtp-Source: ABdhPJykvt6kbaDhPxoeEdGHmfH0CXOXH0YotRXOxh4e4HrJb+j91eQMZyFXTU7RzK1EON9GIpQuYg==
X-Received: by 2002:a17:906:4e91:: with SMTP id v17mr3165296eju.119.1623408915592;
        Fri, 11 Jun 2021 03:55:15 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:55:15 -0700 (PDT)
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
Subject: [PATCH net-next v9 11/15] net: mdio: Add ACPI support code for mdio
Date:   Fri, 11 Jun 2021 13:53:57 +0300
Message-Id: <20210611105401.270673-12-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
each ACPI child node.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9:
- Add some more info about what is expected to be passed to
  acpi_mdiobus_register() as fwnode

Changes in v8: None
Changes in v7:
- Include headers directly used in acpi_mdio.c

Changes in v6:
- use GENMASK() and ACPI_COMPANION_SET()
- some cleanup
- remove unwanted header inclusion

Changes in v5:
- add missing MODULE_LICENSE()
- replace fwnode_get_id() with OF and ACPI function calls

Changes in v4: None
Changes in v3: None
Changes in v2: None


 MAINTAINERS                  |  1 +
 drivers/net/mdio/Kconfig     |  7 +++++
 drivers/net/mdio/Makefile    |  1 +
 drivers/net/mdio/acpi_mdio.c | 58 ++++++++++++++++++++++++++++++++++++
 include/linux/acpi_mdio.h    | 26 ++++++++++++++++
 5 files changed, 93 insertions(+)
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 include/linux/acpi_mdio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e8f8b6c33a51..2172f594be8f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6811,6 +6811,7 @@ F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
 F:	Documentation/networking/phy.rst
 F:	drivers/net/mdio/
+F:	drivers/net/mdio/acpi_mdio.c
 F:	drivers/net/mdio/fwnode_mdio.c
 F:	drivers/net/mdio/of_mdio.c
 F:	drivers/net/pcs/
diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 422e9e042a3c..99a6c13a11af 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -34,6 +34,13 @@ config OF_MDIO
 	help
 	  OpenFirmware MDIO bus (Ethernet PHY) accessors
 
+config ACPI_MDIO
+	def_tristate PHYLIB
+	depends on ACPI
+	depends on PHYLIB
+	help
+	  ACPI MDIO bus (Ethernet PHY) accessors
+
 if MDIO_BUS
 
 config MDIO_DEVRES
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 2e6813c709eb..15f8dc4042ce 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux MDIO bus drivers
 
+obj-$(CONFIG_ACPI_MDIO)		+= acpi_mdio.o
 obj-$(CONFIG_FWNODE_MDIO)	+= fwnode_mdio.o
 obj-$(CONFIG_OF_MDIO)		+= of_mdio.o
 
diff --git a/drivers/net/mdio/acpi_mdio.c b/drivers/net/mdio/acpi_mdio.c
new file mode 100644
index 000000000000..d77c987fda9c
--- /dev/null
+++ b/drivers/net/mdio/acpi_mdio.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * ACPI helpers for the MDIO (Ethernet PHY) API
+ *
+ * This file provides helper functions for extracting PHY device information
+ * out of the ACPI ASL and using it to populate an mii_bus.
+ */
+
+#include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
+#include <linux/bits.h>
+#include <linux/dev_printk.h>
+#include <linux/fwnode_mdio.h>
+#include <linux/module.h>
+#include <linux/types.h>
+
+MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
+MODULE_LICENSE("GPL");
+
+/**
+ * acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.
+ * @mdio: pointer to mii_bus structure
+ * @fwnode: pointer to fwnode of MDIO bus. This fwnode is expected to represent
+ * an ACPI device object corresponding to the MDIO bus and its children are
+ * expected to correspond to the PHY devices on that bus.
+ *
+ * This function registers the mii_bus structure and registers a phy_device
+ * for each child node of @fwnode.
+ */
+int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *child;
+	u32 addr;
+	int ret;
+
+	/* Mask out all PHYs from auto probing. */
+	mdio->phy_mask = GENMASK(31, 0);
+	ret = mdiobus_register(mdio);
+	if (ret)
+		return ret;
+
+	ACPI_COMPANION_SET(&mdio->dev, to_acpi_device_node(fwnode));
+
+	/* Loop over the child nodes and register a phy_device for each PHY */
+	fwnode_for_each_child_node(fwnode, child) {
+		ret = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &addr);
+		if (ret || addr >= PHY_MAX_ADDR)
+			continue;
+
+		ret = fwnode_mdiobus_register_phy(mdio, child, addr);
+		if (ret == -ENODEV)
+			dev_err(&mdio->dev,
+				"MDIO device at address %d is missing.\n",
+				addr);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(acpi_mdiobus_register);
diff --git a/include/linux/acpi_mdio.h b/include/linux/acpi_mdio.h
new file mode 100644
index 000000000000..0a24ab7cb66f
--- /dev/null
+++ b/include/linux/acpi_mdio.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * ACPI helper for the MDIO (Ethernet PHY) API
+ */
+
+#ifndef __LINUX_ACPI_MDIO_H
+#define __LINUX_ACPI_MDIO_H
+
+#include <linux/phy.h>
+
+#if IS_ENABLED(CONFIG_ACPI_MDIO)
+int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
+#else /* CONFIG_ACPI_MDIO */
+static inline int
+acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+{
+	/*
+	 * Fall back to mdiobus_register() function to register a bus.
+	 * This way, we don't have to keep compat bits around in drivers.
+	 */
+
+	return mdiobus_register(mdio);
+}
+#endif
+
+#endif /* __LINUX_ACPI_MDIO_H */
-- 
2.31.1

