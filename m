Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1123007C6
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbhAVPtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:49:21 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:21476
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729184AbhAVPrH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:47:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0NvJbMluUzV+kzEkw0M15Pdk7tkZacX8uBx3TxKqVRAie8s9uHxNoZyo2UDVh6x4MoofwXOjOFfnA7MkGEjpzR0lzTylbk4q/6Z6CCelfU3KI5WXPVvOoaamp0yI59qu1hnIod22JsBQgH8LfWhdBK78r9xtF+EsYk6Pi0w7A8XKfwubMEaBJ0g4aQff0dD9ZJudd/dxS3Et7pP2Q78HEMH2HAbe34J/w0pVDhr7VU3uHbyNyZuqrkPVk/iJyCQJ0jN6640LaVq5L+XVvjLiE2ojYiy4AkcNx/2iDOHnCSJatUqNIZAY3qj8QI3/nNPoIoXFG0sKwj/dvpTRBPz2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBHmkTm5PwVsPz8pnjCbkqkwCF097d71rRO6haXYo5Q=;
 b=ErmRQZJ7tCUCvoBWLhL7ukmJEdqShuDc5+DXXFN1wHqpVb0bsrvgmhqdqRX4B16QlS7kKuiY7MUEE1hUL95OuMhaJnCl+ZpmuyOVjx0PgDEp/BP6x4hOL5TTjPyw3G4ijV8MwwMcDm5uGegCVVu8ihrs62eF9yxAP9GoAW1vfEC6q4Wn1xpSKGxXk20bCme3O+bRZNcIhMqHiB5pST4UmXgCpOXVZ3p7XEgO1FzqEMNfrsxnmrqe08Uxvu0+OoFtcwX5w8Pie3Q3FB92Hhvvxfw1znUI2atbBYohVyuJGFC7UgisCwvr89SGO3NqYEfDfpg8BV7Lz/uxgtGHIwlgSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBHmkTm5PwVsPz8pnjCbkqkwCF097d71rRO6haXYo5Q=;
 b=BNwvJw7p/DiiDXlWFKG1mjV+f+vChsp2nvgEQbtIdeaHNzCoGAonZWnS5Fawr4aSxMDa1anC535E9ekMP9YHPl7JMC6MwoRyC7ZAsBPPMzQIcUZX06UWRmPjhT+XWapCPL03VKZUMFQ410DdFPVmNsII1Awn6HkQo14+6WWjHa0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:44:56 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:44:56 +0000
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
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v4 10/15] net: mdio: Add ACPI support code for mdio
Date:   Fri, 22 Jan 2021 21:12:55 +0530
Message-Id: <20210122154300.7628-11-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:44:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f8c97cf2-09ff-48cf-fce3-08d8beecaa8d
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3443B774D8DDAC6DED0186FAD2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wR2EHPeGL+ZXGtxwHDAKdJncik0w+a+U904gzO2kofEwEuU0iDlOUq+ChJs5uVyqz9PEG160KDVl61VX1VFduc3+IKWzU+ag9kS6TddEgGTLz8SIEFDU77fnziLRonW82ZBZgEDLIOyhKvN2Qf/5BeEJ9AsJ4JyDL9rRfgEO8Gov+EaJXSsLPHsqDKC8GGS6glRb0oEE4ji+lqDD+h0xQGAqFUyX0jj6cg6wQ5BAqQSQX/jYX3mK+SnNovCAbHNXkgKwIAf9Lm1CzlCjuxEfZZJT0IFMKzRiEXjvkRxjoT5dHZs86eXS9B5FyF70Y4BoC3IAnTsWgVcUrfGhdNdCWEZOroGy9t/0oj+aNgrntjO6L0CtjpInIPS7DV/TO9zO+qrAMArkK59fDViIkxImNas0IE4idB03JsyUZuI9zP7PNfXVAigQ8Q+2bgAx3214GnmxNLOzJ8QY67Ng8AJk+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(2906002)(6506007)(921005)(6512007)(6666004)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(83380400001)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YhOwwXW/ghE3zvj7MT/BL8P2S4VTZngHcFZ7RYe3WcJn6vT1oXBWVsDYBy/2?=
 =?us-ascii?Q?wvpqkI5+wkXxMQpAybHtDN6UNjl7z9JsYldMWeprUf78py4oOGa1+nVNcknX?=
 =?us-ascii?Q?IMt92ezkU4s8c8g0yU1qHL3k0s9GvTwezYUMangjJ6UpIto+fl4Kg72Jvsc9?=
 =?us-ascii?Q?ukdeMj9VAVDOClQwX05G7caOCXDshzTd/tTL3qaRZxFKR+8R7M6OEqrYiQWJ?=
 =?us-ascii?Q?KsRaitw9rL26cP1Xqay9ZsB8prb07yvG+1yv8YU7jHJ/QOUa8zcn96iAemEm?=
 =?us-ascii?Q?7Gspb4R+x6Dml9R1OGflcg25zL61uTxuaQjrrawtCBOfxHsBxD3qZJ7VEZyh?=
 =?us-ascii?Q?xxZOtRzoZ+X4BGHJU2m3lB+N9g2OMDjcS3PgUnVK5cOUKve8G1nTLocWTg2B?=
 =?us-ascii?Q?Jch3dfvxn7Y3d+bjIHhNoUSVvHqkj8CsVE7OkKZmazUdgDC94K5gGkaSu5rw?=
 =?us-ascii?Q?a0MmdpS638mpeXUqY6KYNpIsr1puSxW3oucW+d0jjvk6E3jpUvyAAvXb0jiH?=
 =?us-ascii?Q?tgfZKxaEOnfrZl3CUBOAMPEi3sSE5SsqFwdnLrbVzmwu93kYJxRtN3vqGu2s?=
 =?us-ascii?Q?rWd2lsYbGLeG4w0soXm2ApR6kYxXSUSqwl30gNwDkcTYLJ5kzd8VcZ6rtwEg?=
 =?us-ascii?Q?4byu5BR0pkKmJkUfMTugr7qXEJFTQSFyvgt1pOa9+ifqnNYhC+oxhZ2XFoNd?=
 =?us-ascii?Q?/X1Ouwoqf/J/wnErTnIgjWjQcfFgxNLdr2OzKS/S4al166MQQ0G1DzgWPGNR?=
 =?us-ascii?Q?Xwip0BCXQsTz6yBoGMYxhylav+k91+17WZwaId3zi41eAPjAqXnQlYATWG0W?=
 =?us-ascii?Q?ihgh/wF5hzRxulNJGMLusAXvAWI3DNEafLpHrGPOXzbbDJu6vzNtUN9qhTqC?=
 =?us-ascii?Q?TZpQ8kSrJacvFdv8KlGAxjZPjQwfbV41PgSgVKhb2LgAzRi0IkpsnFF8zXhx?=
 =?us-ascii?Q?Xo6iLE4aIt/HwX6wVImEkkfUwy1LGaDHscDRJ0rZXV+AedlMzgUJCoWuvwAE?=
 =?us-ascii?Q?EEIu0+WqoxlXbNUN8COG/vPyL2kK+hQpPdQw/TijQdqIO6zTnyjIJx6Bqvso?=
 =?us-ascii?Q?4IwS9sxu?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c97cf2-09ff-48cf-fce3-08d8beecaa8d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:44:55.9664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4uy6na7/oX7cML0p9tFBrioCMAD50ZOADrlKLJqQC3qkdaXIhboM3I+iFwwutrbyEM1JxDtfZTBjeK9wtXPQ5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
each ACPI child node.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4: None
Changes in v3: None
Changes in v2: None

 MAINTAINERS                  |  1 +
 drivers/net/mdio/Kconfig     |  7 ++++++
 drivers/net/mdio/Makefile    |  1 +
 drivers/net/mdio/acpi_mdio.c | 49 ++++++++++++++++++++++++++++++++++++
 include/linux/acpi_mdio.h    | 27 ++++++++++++++++++++
 5 files changed, 85 insertions(+)
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 include/linux/acpi_mdio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a444cd9d7d7f..fdf5231373f7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6666,6 +6666,7 @@ F:	Documentation/devicetree/bindings/net/mdio*
 F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
 F:	Documentation/networking/phy.rst
 F:	drivers/net/mdio/
+F:	drivers/net/mdio/acpi_mdio.c
 F:	drivers/net/mdio/of_mdio.c
 F:	drivers/net/pcs/
 F:	drivers/net/phy/
diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index a10cc460d7cf..df6bb7837d6a 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -27,6 +27,13 @@ config OF_MDIO
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
index 5c498dde463f..2373ade8af13 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -2,6 +2,7 @@
 # Makefile for Linux MDIO bus drivers
 
 obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
+obj-$(CONFIG_ACPI_MDIO)	+= acpi_mdio.o
 
 obj-$(CONFIG_MDIO_ASPEED)		+= mdio-aspeed.o
 obj-$(CONFIG_MDIO_BCM_IPROC)		+= mdio-bcm-iproc.o
diff --git a/drivers/net/mdio/acpi_mdio.c b/drivers/net/mdio/acpi_mdio.c
new file mode 100644
index 000000000000..adab5dc9d911
--- /dev/null
+++ b/drivers/net/mdio/acpi_mdio.c
@@ -0,0 +1,49 @@
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
+
+/**
+ * acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.
+ *
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
+	mdio->phy_mask = ~0;
+	ret = mdiobus_register(mdio);
+	if (ret)
+		return ret;
+
+	mdio->dev.fwnode = fwnode;
+/* Loop over the child nodes and register a phy_device for each PHY */
+	fwnode_for_each_child_node(fwnode, child) {
+		ret = fwnode_get_id(child, &addr);
+
+		if (addr >= PHY_MAX_ADDR)
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
index 000000000000..9be6f63cde8f
--- /dev/null
+++ b/include/linux/acpi_mdio.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * ACPI helpers for the MDIO (Ethernet PHY) API
+ *
+ */
+
+#ifndef __LINUX_ACPI_MDIO_H
+#define __LINUX_ACPI_MDIO_H
+
+#include <linux/device.h>
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

