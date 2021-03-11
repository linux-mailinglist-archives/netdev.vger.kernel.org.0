Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B165D336C31
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhCKGWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:22:43 -0500
Received: from mail-am6eur05on2047.outbound.protection.outlook.com ([40.107.22.47]:12237
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231374AbhCKGWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:22:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtgZaf2FOnT/iJAY2eT1+ociEJXpLQNnW95m4KnFg5eCSnu2Hn9p5CvI0Wv/9aSrY/mY+6vcDlLl0FTCyTjh2tL7yDpspa2+hYCt4/1oOKseeoEgv4aX3fwhrixfXXVLR5IHQ5qdw+1j70VZQZBB6mR/hWCpUqHYhCnuSmDq5H3BtHg4tl6AflGplPGUkY0hv3RYuHv+KGXcOqZNBqrC5NvUREG/Qyj9mCtXK1hsLtm9Hbw5iFPgjQXdMKoBCRU4YnNeYF9Oft/Rb1uDR8xdlhGs99dQWM1E7te1+PfbciiNfpfkkB5Tx8oaaCjtnwSMraCAmi/HdKCN9BKzZvnSDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eov0g2e7j/5sx8TQSI4sQKd2+pqg96z/I7FWfHmchjE=;
 b=hXMKI/nA5plV1dXu8eBUlBcvnm0EMFJw7i9IEDGx/23OI+sJlt7lT+5zVX42yfcCwVsJBL/vkKWrmt8HrghZ2JYzXkEqXvm4qEPoGk3WsD25hlu3mvtti0UNJ9P61KEG2Anbmj/CHycR2AsWg2lxkufk9hNRZiEjEnw63R/SeGlltKuYPabxe4011e9qiiYoDZ+iq+lt60MwpFNbmjODV5IyAOLpG+dhYgHjfBFIjZxSt+6Q1jY66A3KofRDxfU1O1P9wSWDJBePuo8MjNt2aV5NWycKgzMy/8foBzE71sGwuKQTmkoQFZtUN+roJWb2orIYvwQoAWC2RddsgLn52w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eov0g2e7j/5sx8TQSI4sQKd2+pqg96z/I7FWfHmchjE=;
 b=lFSLvynRPML4HFzt7GFKc5N9QFgtgt0WbAtR3wuEgmel00r9OHHxoOfeMkGkzQgqPi89ixtqFdjx7Q88O8nl9pCtvcF5P88K5JrfMwljozbXQfhcMjVxB8M2DbfVj66ySdMYBo0wK7iBPhUZWthtu/kBvbij9PMX4is4FgNW7Fk=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6611.eurprd04.prod.outlook.com (2603:10a6:208:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 06:22:22 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:22:22 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v7 11/16] net: mdio: Add ACPI support code for mdio
Date:   Thu, 11 Mar 2021 11:50:06 +0530
Message-Id: <20210311062011.8054-12-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:22:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 73afef84-a474-43cf-7b15-08d8e45607b8
X-MS-TrafficTypeDiagnostic: AM0PR04MB6611:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB66114B870EA39098C0B2684CD2909@AM0PR04MB6611.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NXvJMNi6BWcmRN/mbZVTFOSJFJ+VSRfnTvdH1e6BkiyoLuN6egGBq2g1+FAn7FVSf7K20C5WMUdMGVzGhdaxu+J4EWFAsef9GsDapCBQdM44ArDsNVCi5aOB4C6ypp0bZMdulHSMSH3cdlH4LyeQuOzsx58Aj0WVMOp/bkL9xUqLeAl7rWasB0F89d7ZYUU2ZZeltKi4LCXJ0cOtc3q7Fac1MU2REtdW1RPyA5XH539FzcqXcCUHS5rKtE3ZFL+AVj3MQDEAis3rBTbi/BHgn+wEqUUM/Palb/Xz7yWTrpvMladI6drXfiB4kW0utojitdfXpUxQZQITj1U6FsBjF6BsPotHckuEWfossogkmKYpSYe5jOQh+Wsnbnlebdc0K1dY5NUeV+mJgighspq6ffwkRt5ieoU8IyUlcFpXznJfXDoK6KZyrtmIEnOvTH0PJ8yoerAov4baofpwgC4ZIK84X/LbZ1aIcXMVUrN00VWYm85NhDjFk//xfnCwtz4jlrGE/8Sxa+cMcLkDfgytUaRJu+1a4FhaNGAEJYF61G71BDxtw3DiuXKlzyw81hnFbIYkj98umsISGAs3JZULJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(2906002)(921005)(16526019)(26005)(186003)(83380400001)(6486002)(8936002)(6506007)(66556008)(66946007)(55236004)(66476007)(44832011)(478600001)(6512007)(2616005)(316002)(54906003)(5660300002)(956004)(1006002)(52116002)(8676002)(6666004)(110136005)(86362001)(4326008)(7416002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TUymOQX6cfkYRJKDr7r+2iD70/3n2TwgctW3oHKN19XXi12S+Whp71M/u1b3?=
 =?us-ascii?Q?C+qstpfu+03OwztZehlsd6bFHGSr+rETZGfgydzFjFAX0XLH/G/D2h3ARzX7?=
 =?us-ascii?Q?6n39vCvk0Lj2Qh9XXgCVTNMWX8IWohPOxhHQAzSY9L0D4XaJyYXyph++jWVM?=
 =?us-ascii?Q?05eIerjuh9UoZB1dBRIWqZxStaUUflTyp4S+JyWX6rNXooBR8GvYvPYG7ybn?=
 =?us-ascii?Q?+XCR7znZlSBbxrQgd9qMxfPE5cr8aHj5zZDoD2w/GpkWu/txEXQRPJ+Zp7vW?=
 =?us-ascii?Q?zke5T32e38QTw761D/VaE9wyq3Jqq3OetYgGUYutxzs1fBQf1lrsnRmfE/FE?=
 =?us-ascii?Q?5iVGWa5V9IQc/H1rbNJNaX9SHj8I0MTuHQxgQwiF6yHad10RHsitMUuqYIXQ?=
 =?us-ascii?Q?EdmgGw59odkwkxY6gn26Ii/S+OAG+IEYpZhldeXWIuNWShmEI1fa12tF4BB/?=
 =?us-ascii?Q?Cqy/Crqb7PWQ/tEHIjJ7qmZE78iVaGn0m0f+YzXXkr7OZQethACEPuLD5ted?=
 =?us-ascii?Q?UMyk61IzucytUH/aauaA4nQC8nRBU0RdVqbJybHOVg4PVYPJSFi5h4iNfUPI?=
 =?us-ascii?Q?GPwGTHO9yvhQTie46qPXpsxb0IqCowlInpfqhRkUBtbtlSQB007uTVYuvbE7?=
 =?us-ascii?Q?ZywfF4y28hqVeuCiQgdKLP4Ya/sT11NLKYN7G/EYqRHs0Y9r+xE9nQ5aAGz8?=
 =?us-ascii?Q?1QTJe4lbgDGdx7KXb+IKOV8KSQJFACs8FhJ0vKvS7ekyjxeqtjyV1yYN7V+K?=
 =?us-ascii?Q?KzoOqEC95xL7ovRc/FQ4aDGHXtcBGsxjufNuFApzQS8ogB3fxHQvNbUQW1w7?=
 =?us-ascii?Q?m9jGWOLWegycd19iCeM+ihtcFO53yx2D0QRTF7fARHHLat/bSu+TlfMOZ+wH?=
 =?us-ascii?Q?L7Et+cTQ+vRUNFyMoGrhuIwmmzfoze96KAYQdJAsw3JIzQnziJIh2y7DBgPb?=
 =?us-ascii?Q?CN3lx5Z9HPb914GkzzlVhz0HbLFhk57aAcMQSHlovfCO2vfzkCFB+adsqdLx?=
 =?us-ascii?Q?qBHcm2fPr0WegcS0c/L/yeeJGwryhVE0SC5FuYH6M/2wogInJ/aPRy/LpaTj?=
 =?us-ascii?Q?n1XR4AIEzav3kn8bkDsxXDvz8d9kE7/6GYBK0qNHfRzT84BEJScOHbgH3K+6?=
 =?us-ascii?Q?B+7ewKdrKJ2yiCIJnDc/da4StkqLbjF/lVqg9+jTFRpwiJJ+qk6Td1BNTcDu?=
 =?us-ascii?Q?JuCFwzqnkdEAfPOSsyE7o3SGIVKReK3zHMwMsvSdJUJnva5ZueN10dMZ5u0P?=
 =?us-ascii?Q?azUHUTIcX8OH/pxlL49rNijTXHXhaWN2DmoZX3VsML1ul2ahAFAdJ/dCqizS?=
 =?us-ascii?Q?dGhq67T+0RZ7UYmmmdJlkmo3?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73afef84-a474-43cf-7b15-08d8e45607b8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:22:22.3524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6MWSBTvH3QGa9W3hJIeFvkc05ImmU1GsAxj0qt8qhBXNDDR3530W2u/fseZ5BTEY6iMzaYFF6DxZudBYLfFnJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
each ACPI child node.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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
 include/linux/acpi_mdio.h    | 25 ++++++++++++++++
 5 files changed, 90 insertions(+)
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 include/linux/acpi_mdio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 146de41d2656..051377b7fa94 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6680,6 +6680,7 @@ F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
 F:	Documentation/networking/phy.rst
 F:	drivers/net/mdio/
+F:	drivers/net/mdio/acpi_mdio.c
 F:	drivers/net/mdio/fwnode_mdio.c
 F:	drivers/net/mdio/of_mdio.c
 F:	drivers/net/pcs/
diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 2d5bf5ccffb5..fc8c787b448f 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -36,6 +36,13 @@ config OF_MDIO
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
index ea5390e2ef84..e8b739a3df1c 100644
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
index 000000000000..748d261fe2f9
--- /dev/null
+++ b/include/linux/acpi_mdio.h
@@ -0,0 +1,25 @@
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
+static inline int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
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
2.17.1

