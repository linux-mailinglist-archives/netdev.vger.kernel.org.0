Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471FA31E5AD
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhBRFeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhBRFaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:30:52 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0603.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA5BC0613D6;
        Wed, 17 Feb 2021 21:30:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCYcdK5mYmTbExkhF/R2bFN7QfBQGYvAFxvpSEjFRiQWQdeLByWHCru4YyiKh5Z70uFEGKbhnNiecBrNq3EUkdGkFbwCu8PP/yAG+xbZ0M5xyui7vYZDvDZb+37LuYl6EpnTbfitURuoCIixmTbZmjg0i1qIEbCePB7ms/F3EKFRnm53KIsAYLjGzFjI16rFCsOXDcIhpqrU9+5K+9+diNQOkXUEKSWDIxAm6wnnSi6RXkJPIIsTpgxwjBkPs11mMnN15LMNvPcEeb9N1N4wL7NdXcUeuTfvuTE9SiumxqFKEHniI68Fvl6oEP8yJzQa4e5nI8Re6OaqG2jg0K1jeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15LjNqafMe9XbMRxl6wCPfbkpsrCCaKoRRcVNTMs5uo=;
 b=SdrnS5g3as5BXrgvyYQ8x4y4K9Ao3bGXXrZC9PRa56taHdiVEtmVSnK3n1RczGaor+HeBchdpuB0BxTaoz0YeTbKaKwVO3oG4ee4ttGp1AWxO5AO1EncAl1xRtnOtTgjOefnmUYacUhhjAoWRUOxC9vCn29f2IuA4jPr8vLHkkvpKWpqVVotrAxBIZpkUaPtfoUXmoI0a+fdii3rm7KwKvM6f2qeyoTytOWW0zojOhvka7sh4FLmBYyshX5fq5ebUaBmBk+9GoPf6o8kewY7ofrNRhvWGjnc1KhRUwvO0nE8BO/TnKJRCi1ToAxdK3KFN58AU6uq7QnvfOJ/n7xDkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15LjNqafMe9XbMRxl6wCPfbkpsrCCaKoRRcVNTMs5uo=;
 b=WsLf6zGzM9xGl+iQ8pbkMGnNMRZj0+vtEM0z9DHgfIUjauhJ6foc3anOWN7lLj/UrfANRRDLruoKf3etL61ouPO+nW4evyKYAt+YWXO7y4c4/XKm+8JLjhToSnyRsrLSgzOfJZAWHxA8nbxH5yKvsSjOJxRlLv3qMoRx5u6W4Pw=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7730.eurprd04.prod.outlook.com (2603:10a6:20b:242::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 05:28:35 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:28:35 +0000
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
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v6 10/15] net: mdio: Add ACPI support code for mdio
Date:   Thu, 18 Feb 2021 10:56:49 +0530
Message-Id: <20210218052654.28995-11-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:28:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5529b96b-9b9a-433e-3d38-08d8d3ce09fe
X-MS-TrafficTypeDiagnostic: AM8PR04MB7730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB7730A8EB1FC98D2BE97E472ED2859@AM8PR04MB7730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F3enkKJhhAFDdtpLa9PUxPeVBlFKzblt41G3ME/NDn4Vfqxycm8/0AaUkSHtn/FxADti57Mi3sr0fkFtzg2gJ3tb+xRAijCyZENQnhNJSHohZj5DgpNsgMpTWL/46hbIOGn1sKBR2inL3bBBLJYs4+GxUGeDOeiqjL1zbl0QRasTGnXTN9Yd9UHUY5P5j6r78uRCsH/jSmuXyhNeT7FxFME+om5vEga9L9lNSgg0qDP+VAYTRr/x+l2L4bTpz2oxLcV88iqRFKRxtD5ztGqGoolfv4eINk2hxhyhL2LCA/YX8A3Vkuxs4/JcIBfcvq5aI9WfpQUkDDhVf+bv8Qf0pjokRi6BqfeUSmPGQxywCv0bX1kRHJWxZucZRscHAFva0MLRoUrayyxfAOQVJzbkOGd7w5L66Dv/ENkYuX8V2LUvktS2ZYJ1wVD9BtBOrvoEAkDqn5Zw/bQXJj+MwHj4NQMvTS2JIC98q9J00Wi+4nMcfeHFUUVxwALrV9XVBCQkolGNHOAnL3CiNr6BlaJ/YlJqHZYr88VimezeF+T9hwVjdG+Y6taJUArS85WEevQhK7fEmQzsGiCYcOXA4mh5kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(8936002)(52116002)(16526019)(921005)(478600001)(1076003)(6486002)(8676002)(55236004)(83380400001)(5660300002)(186003)(44832011)(110136005)(6512007)(956004)(54906003)(316002)(66946007)(2906002)(2616005)(1006002)(66476007)(86362001)(7416002)(6506007)(6666004)(4326008)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MEjVIl7JMaBRiegK/lMa5VNc6Xjqw3FKtUQ9GJjHbfmCiqTwj5hzKlp2ft6U?=
 =?us-ascii?Q?x2oujQ/BLpwThh1U42c3l2kWSITqnegzQxAy4JZvQqjMUfJuI/2XBKBO+Ft8?=
 =?us-ascii?Q?PyecRkqX3OEN4KtMJbzff3dYyYZFAVappM5E+uj/bWRkYtUidlPtBh43BA/T?=
 =?us-ascii?Q?LdHEG5dro+rpyPgxtJaacKeAuoq8l8qoEC9A8NxtXQPyxxdrPjt+HeNbctgV?=
 =?us-ascii?Q?ORoPNkEM7/Av+yMBxCOXFHSCBKRbm2KEQkyYJ4c+faE6VEJbGtwm0Di7CnBd?=
 =?us-ascii?Q?bKFvff4HBAzRDOMry827zGJQNv9qRbuoBy1J7B0+t4SG8kAF/aPN3LdX3+Dv?=
 =?us-ascii?Q?27391r2TC9smPZsSpbQMUHbId+Doj2GE/skUIBv/L++DJmnjBLe5FmDIDZDz?=
 =?us-ascii?Q?dr//AR06J8hgso10PszkTw9WrrQdRj/Wk+0gt1B2P2M5GG9/A6R81MATDye8?=
 =?us-ascii?Q?pBEaCii0TIvMBQcDamGFA/JT45SK35pa5PQUjuE1Vdma3d7XQwn9N2S2c+xK?=
 =?us-ascii?Q?xXCsYssRfOvP+0CPaABmE39Xa/qkD5x912awxh8jFlvgSGhftPkp6ejMngjv?=
 =?us-ascii?Q?UpAk5PxuTzm/AZEuDenvAQbk83E9CzOmGdOUd3NCD4vVMNBmBQamPlVNROJ5?=
 =?us-ascii?Q?3sxGmd0CvVxxar9Jsme+qI4oFF6pFhQcn+NUB68JwsdcfVe1NiG9KoNXVG5r?=
 =?us-ascii?Q?QXga7zkXpXOsOEahPyp7YCrz/fYMcUdQzTSCKgslSB2BTM1McQ3yuYupGWvV?=
 =?us-ascii?Q?V0YoIFs17t/TE2MrUUc1+e6Pat80sRmG9yWGX4yJB9oPKIERXTqpu5Gh1J6x?=
 =?us-ascii?Q?h8NXTiAYvYoCVRNHHxMn1BdpLIGLzzIoZGf4O0hgGwR8ELqCgJZePbP16wzC?=
 =?us-ascii?Q?rxq6NGOSHaBzJ0lekTGZ9GOm8ehg5KuW4vtMAKb0HLCLjAP1QbXFP+5Ew7gf?=
 =?us-ascii?Q?7nXdWCB4iLOmlAfxYOGVil3PLkuwN7F6rNOeWHmb1mK8o8+A2e4Cwqn9aCL1?=
 =?us-ascii?Q?vC9LpYBKmDVJzjRiL7oy97HYax0UXrXqJujBBbklLHc3xymKBBz1wd37WEXM?=
 =?us-ascii?Q?6VY+cU4XK1KeYj16tPjrTW4eLD9oqOUV72yGnIWDh+L96YDcGleBas3JdRGu?=
 =?us-ascii?Q?qdRilr1DiiKSUzke2lre0W1bFLODlUcW2y4mjrA31+m4+D4xm7ZMzcu8mUm9?=
 =?us-ascii?Q?I4qnAw5NFiQd4wLc2g0K7GozGGVuJDtqYyfDH/JLR4ePbPjEAF/erjd81XyT?=
 =?us-ascii?Q?MUSu1Aqm4LZ9GyRq46rs1RapCVEnNF3t245L59oft0RPJSjaUEZ4LxqeUSm4?=
 =?us-ascii?Q?u6s2oEuY9ldmKm4WfzeJM+nK?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5529b96b-9b9a-433e-3d38-08d8d3ce09fe
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:28:35.8734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0SY10Xk5ry2o5/Mt8hg91seyaH8TuDmfOjBo9O0M2OhGjkn7QNYSXq9IVT7kDY39hinVtGGI3qJUnRYkC360Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
each ACPI child node.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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
 drivers/net/mdio/acpi_mdio.c | 51 ++++++++++++++++++++++++++++++++++++
 include/linux/acpi_mdio.h    | 25 ++++++++++++++++++
 5 files changed, 85 insertions(+)
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 include/linux/acpi_mdio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 1a219335efe0..41d16d77b6cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6680,6 +6680,7 @@ F:	Documentation/devicetree/bindings/net/mdio*
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
index 000000000000..091c8272e596
--- /dev/null
+++ b/drivers/net/mdio/acpi_mdio.c
@@ -0,0 +1,51 @@
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

