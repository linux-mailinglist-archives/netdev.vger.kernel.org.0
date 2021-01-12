Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B76D2F320A
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387949AbhALNnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:43:43 -0500
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:16694
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387526AbhALNn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:43:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBKBqH4M2uwquUKH4wz82YTrb2su3+9jEFoSmssSyM0QkIMWCzNdw0Fplq3Zca0+k+rukG4/vgowFG0TFTkecwdAviet3bhQE3ln4OIonWPM/RJy+p6u4hyx2Nptv7FU1t6GZLzJSgZDXFVhM8FRK9lV++bZPtD0m1YwoRJt8KqShLBVo/LHrIkAkN3uRYfFNzGVbe/PlppU95hcjZv3rRfzoKUuU78E7nBkeeA+aPx5YHUAsGI5MOSk7XZAgk3On9iKAk3bSckc51hA54XYgCZTzwF1/e3EKhu/JjAgawyAqQCxPbEH5EOlNY83boA2fszIiwAoUbJYtkmtSLmwAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBFuskpyy3aulS84iesWozcok0irG/Utg82iUgXOxKY=;
 b=PXgMoymxxUE+G7/3CJML2pjiomXc/ffGY7HNJv9j/Kr3aHtEVqpcjKpPKh/M+rQnPd/prtw3rzjIGIf9XKOG/6DaZeQ+hOdwPG2bXnKXT7oWrt+w6qOPl3uLKzOBrxwWWCWkSGFMG7D3/OkJWYT4a9Cc5jx9odkhBQ/UnVfCZCGBbaoS6SaVu9wVcoKQVm3QEIvSFyZVB8wZvk4Fbwcp9YeITB/Iqf3UT7JYigShZaQYu0QsWvDUk5j9xDikmrQXB2I2neauIhIua5jDlEqxM1auXKgBYxfcEMa/wyVlrMYzFW5Vqtp8RO+DXzDtjQxmTWywNFwgXeYIxdmNBxcPaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBFuskpyy3aulS84iesWozcok0irG/Utg82iUgXOxKY=;
 b=HgddnYcX2qpW2Zo+KGknMPLpNRaCZjFN6heNrcZbgaS6YIi0O5B9rNzkeZ/57OKMx4sgR+BreWvbgDJlHo6DH49RLtz5BezBA+IBi4FFNBQr3zGl8hvQy6D1SpN3FmmpHd5/wh5H66FoXozyURRGW5zLzvG4+eLwBjNGDutVoy0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:42:45 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:42:45 +0000
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
        Jon <jon@solid-run.com>
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v3 10/15] net: mdio: Add ACPI support code for mdio
Date:   Tue, 12 Jan 2021 19:10:49 +0530
Message-Id: <20210112134054.342-11-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:42:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 906b8b92-a438-4d15-dd5e-08d8b6fff1a0
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB34436242B41A16267CDD7D03D2AA0@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQShrTTM5H9nra510HUbpo9NYFBpPuAY0voTDUqwh6xsuVO/ho8x/cT9hB6Xa3ujGfOL10OVcbkiUa1LKbte+brDq4lossMZhU23x1zI+T9gIB6govvuObGxCnt7WxT7d6UiMJnr/NfA+0tiQZDpLmSK9c6PRIsAt4VZGuYYPye6veS0F0KUa6cwkK2GnBKHUkc0oZ0uwlMinN/OQRx5ocnCJYvQwVoLsBigiImwxKLW90trfi1RZ1R8wVFVOJpPZj/H8Cgvmuzd9zM44nQeh3baJ3ztmTWhUXJOr5imh0pm9tNyPDXrhbrKYrllRJce5C5lW8YgzI/BLuhkAiBs3zi5qUUxWzllyvEDbWkOzuKJByHRQ1u3eQCINiUT8lJGMcarEGyASCfIUMInrsQVmjl4MM6dZs63UW+A6u/x84JqIg/bry3iCscKAsMzqewf6flysatvPs+p2gChwJiRwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(478600001)(1006002)(66946007)(921005)(110136005)(6506007)(54906003)(16526019)(83380400001)(6666004)(52116002)(2616005)(66556008)(66476007)(186003)(7416002)(4326008)(956004)(1076003)(44832011)(86362001)(55236004)(8676002)(6486002)(6512007)(26005)(5660300002)(316002)(8936002)(2906002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vPotSydC7R+3NpuCsZkcg0iDHOP2OHoSd59psHy96PaoWxWjcVnyvOKICHzl?=
 =?us-ascii?Q?Kz77j9HjXZOkXTLb+NR8fkLeZIJw41CbhGQfsf90D42PL1i+gBZKj8+hZqg5?=
 =?us-ascii?Q?d2pMdVZgYPl9wgNOZ6SiFIugALYznPGZkSO+HHC+oGT3HngZMjyghZszC0rg?=
 =?us-ascii?Q?DUTnld6O+cg9W1pQQSvTn9mxAtbE6U2gF4S3k4uGjnHflW0jeRbaDmeq8Z6c?=
 =?us-ascii?Q?qKvZB5yFUOy2JOtjOU64xxxebDYMlj6paUQ/pCH+JKbh/CTPA8GbAJXohekh?=
 =?us-ascii?Q?RJqvkxr0DeUQS/d51Pmkrxp3CeOV4kqkt1+nYsoaZJh1tFLoS06e+ScTN3oA?=
 =?us-ascii?Q?hvnboFoLahG0Ft/QNvxMaECbyOiG4qPg84bFGuO0zgMrtRUfwpbiUM+FjZLY?=
 =?us-ascii?Q?xUBLFCr4ofKUxGjjFOt47splfE//iMiaInkrM432MuJA+vKoXO3I57vj8t9F?=
 =?us-ascii?Q?bnB6Tm08/bX/Be/YdqGK0MSQeAsir7m0b4zcjt8/sqfpxK9dkv9S/x2cttBC?=
 =?us-ascii?Q?Y55yUvgayUrRavZOPheio0VREHZENNHrF3y8yEqtANG6pl4kPvDvIaB+gFEE?=
 =?us-ascii?Q?KK5y598zgn0NnAd05zfYwlk/zxneZnmCBBxV1pkx6PHojAigpDB2qsFulAbU?=
 =?us-ascii?Q?evkfGfiXa+eZElC82dcti/XUWmZi0bLEZ3pU8kKSRmFJN/m4kn+pRzsmfNaz?=
 =?us-ascii?Q?MB7c8+3f35/zTypsmmP9NKBU2gzwrT4nxtFeNFC4z2PVV+buC1iRDMQPkEV5?=
 =?us-ascii?Q?oGjrOx9iQRJYYuI9pP3yLhdJgcmUDhNrXlpPJL5O+T+uDRVQLmuxdCkbliec?=
 =?us-ascii?Q?e/6Yb36KCmZVHIADoAfJF38NbRRvkkUVE4RMRlc9x+hr2co7QUW/0L0Qr3+E?=
 =?us-ascii?Q?7H5axD74xf8RwCvGgbXeFjFUEXjq+JAtUjNy3D4zt8bsGIgbUVRoVLJTG280?=
 =?us-ascii?Q?zmR6gUuJT9ETI2sK41W05hLmc3cDNepgqfDvg6Drf2jBXZ+na6KXVf2OfvxZ?=
 =?us-ascii?Q?H8lN?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:42:45.8273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 906b8b92-a438-4d15-dd5e-08d8b6fff1a0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/MZXKK7Qyuhabq6yLE624v8xY/DJ/oLtBIutfzVhLxTMAV6KpD7s2eqYpwSyaxz17ERmSZLFcNE1TJUOvcxGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
each ACPI child node.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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
index bfd13ae685d4..efb4bae8d622 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6658,6 +6658,7 @@ F:	Documentation/devicetree/bindings/net/mdio*
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

