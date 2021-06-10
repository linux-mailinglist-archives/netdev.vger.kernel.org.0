Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D843A3115
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhFJQoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:44:25 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:45735 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbhFJQnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:43:50 -0400
Received: by mail-ej1-f46.google.com with SMTP id k7so161147ejv.12;
        Thu, 10 Jun 2021 09:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rRvwfKkukgnoScSahSMFZLRC5h4rW9MQ8oHY/dsa0CU=;
        b=aHI+Pj3SA0nCldSK7rXsO6hP+jGwaE6IW07XrKEEHSkDNew4YG2JTnjt27+2ZAPRnf
         RC8KXMTxfHm6qMHOVzaiVuTg1R+hy32Ms1HYer+OLcBUSksLHYvsXfNIMBW/bSojiIrS
         j6i9lzw1mqdS9KfllULTePyca9ec50Vqvv8K3LSpeI/TyvB1qD4SL2RKnMP8fLFWlmP5
         HmN9oeWoBBr7l7edk8czk7jnUH+4sd/3KHzB4P73IJcWVtjImsWqfXX4EI/AlvjXR7JS
         Sy0wgnCFXcROo2l1ojBTXUJoL9V3GaN1kQa+2TQZP+h3gb7wEuULFBaana/6rE/tg9kK
         9GNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rRvwfKkukgnoScSahSMFZLRC5h4rW9MQ8oHY/dsa0CU=;
        b=JY31oBIx2ylsTvIUVIEKLdsKwuzAzfGDKArnugDAYfO9QpFLpCeGOToRiNB9+eMI/n
         m3kr3dVuggNB3bXd2/S9Ax1l3CDfpA3cNV84R0uMlHpU2c6Uzb25hgzHWbhJjNcTCbq7
         X0nF+e85nEFDkEh1K/UixGej1IebKkhAN3uoQ0kKwaHuE4Hnv19tf6qXAgoabamuVU6s
         37vqntUuPUE8O/RFyi4xlfDPn9Vnc7+LnUzaRQNjGwM2Ev9NOI1pgPsUGYWClXUX0NvF
         6MpGhHbGGsByII/FKgFNDdW9/UQ13+W95ygTTGEIsvU9tS0eKitChWd1StcT1qoBrmmr
         z9GA==
X-Gm-Message-State: AOAM532meHB67F27gr/PmOaA70kvI0kPMQ5bvmd/SPlJCoudHB2aLSJI
        ZxaYaJ3wrpDPZJWKZxebu44=
X-Google-Smtp-Source: ABdhPJz4YWRBuxeFIQcGWxDtMKhJvdtWzIe7Vy6kryVThIQL7lMptpfJil7bBVFS+oUTz/kkBJ+dkg==
X-Received: by 2002:a17:906:f889:: with SMTP id lg9mr509833ejb.82.1623343238190;
        Thu, 10 Jun 2021 09:40:38 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:37 -0700 (PDT)
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
Subject: [PATCH net-next v8 11/15] net: mdio: Add ACPI support code for mdio
Date:   Thu, 10 Jun 2021 19:39:13 +0300
Message-Id: <20210610163917.4138412-12-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
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
---

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
 drivers/net/mdio/acpi_mdio.c | 56 ++++++++++++++++++++++++++++++++++++
 include/linux/acpi_mdio.h    | 26 +++++++++++++++++
 5 files changed, 91 insertions(+)
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
index 000000000000..60a86e3fc246
--- /dev/null
+++ b/drivers/net/mdio/acpi_mdio.c
@@ -0,0 +1,56 @@
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
+ * @fwnode: pointer to fwnode of MDIO bus.
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

