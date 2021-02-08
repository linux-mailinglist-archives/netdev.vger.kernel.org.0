Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE43313753
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbhBHPX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:23:27 -0500
Received: from mail-db8eur05on2087.outbound.protection.outlook.com ([40.107.20.87]:60983
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233659AbhBHPSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:18:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjSM+f1jipgZovyyaWtWv02jIgp515sWqmCrh2mL5WKiri95KOe8D5x+fqwPEQ8oCCZQ/oC8sCGrDHVl5Wbf3QDwpFnuCxYyC2lq97HYOP2Isvy0AXGpxCsUZaeCL8KsRuqz7nO9J4RGsLyRDzYiqcLyYg+nybVNiezDkHNb/uIYcxzgXbInOF3RwfUuV/2c0shixTdKeoXzgLQeZI46rqAHrFjbKmYcQ7pIDrGjkJKwYR/+XzeBpoOpG2R/A3hjuLsJUj0ZQZB/RbocfvI9touxeuTuiUDT6Uu3oFcy8gD9KA4Dkd04sCNMjvMcqXgv0bRyxmc6qRIdWhu53IWhUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vpzyNxHB/NCP2AZQ1pbojSLm6PLIJQLvUGjRDw7+rY=;
 b=C5rFEyDPFmpLVbBYe33NKTtd17NjKam8VjHfzPwT2ugY8xcACSIMrEvc5nbLcqIyetbtYXY6qvZEQW343hJ8TZ23wSgxobbkGAnuyndWeTwsOwSqBxjw9rQforQ1Hoer2d6Qs/kQaWBGaJuHRqYu2GWRk3EdDEsJC59VRuHS3Cx+0VEaTdvI7ZAdX1oggPpCP68jeb8noHjoG0wYjW/I5fQ+knIJ5qyhZH+QqtPuE8sjNt83GDymZQanbzCYooh8BOYzyyj/QiVdT9UM7DbYNJOYHzU4KqzTkK9TjIfcRLcbi73Kxyal2EzNZ1iUaEFvqZl5s4a29DMdDFsaZcuv2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vpzyNxHB/NCP2AZQ1pbojSLm6PLIJQLvUGjRDw7+rY=;
 b=YadZdt7NDL+WC0i9DmhQR8iTlPUnrBmA/ePbUtng9GGhxZJk1lrmcBSRTad/zGHs5NnEo1sGNZH98mNcm3nHR/2slu9jYN8wI+xCNv5IXvyFWjUGm4duS4f4NN7YBJkmArEbleNpfNCBKU8/YMUdYnR9V1p0kYqAcC91cz0Ok/k=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:14:26 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:14:26 +0000
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
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v5 10/15] net: mdio: Add ACPI support code for mdio
Date:   Mon,  8 Feb 2021 20:42:39 +0530
Message-Id: <20210208151244.16338-11-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:14:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ce6f506d-85b6-41ce-18c2-08d8cc44395b
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6435B81E00BFC2AF894D17EDD28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +lKIpCDDZLYnJwfOKIvRT3oIV63IZeUCdS0un2TV/Mhv3ZtfGPDtuxa8h8wLbRUjgRP9SFXHj5X5xYwRj52Yt8KIJLetEfZsnDyJYxB3yzRocoRcXxOV5bRzbCKVT5tIZxWUjj2VJ7FfmihgmkVw7Hc/mfrQaeFr0f0iEu10dDp44pk4CMc3T5N2V0oeCz6s2sFR7Sp55EiocNC1Wc96FpCcm6sHrOe2zmnHiBxGCpMcd96E7IPFjtt6jbcCntBVMGnd+UxYSxg8yMjozyM9FhTBhyW20/HOOJnxwS4DbQ0DITP8NmPpWSpwBuwX1DEzRu0pynpWJS7An16COPBJHLSFqYVr8XUUC8M6QZWTyURl4sWzk+UZ2dPYRQa3ol5byjoCjk6KwfQ7YRmOpQ+HoiU84b/twWHwFxMck7cRoy10URj1luxDx9uMgPqHIB7VNDFdIwhPUpo1HGAEYNJrPbj+4wzhbNfp9FDdrcJt9kp0q7jtHKgPaMv3TGe+zg9aCekVyoNXJVofq5a/BfDSpe22ylbSP0+G41KIJ9CUPyQuehUNMPiEJHU+frmjgvclcgrrclKWepJ/sMFXM8WJxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(44832011)(86362001)(83380400001)(6506007)(5660300002)(921005)(8676002)(66946007)(2616005)(66556008)(26005)(66476007)(1076003)(52116002)(316002)(110136005)(186003)(16526019)(8936002)(54906003)(7416002)(55236004)(2906002)(4326008)(478600001)(6512007)(1006002)(956004)(6486002)(6666004)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CAxmBoiVBuv/ZRdNMV2JsQ2Szcbw3fqYx8zuWsRcnRKI7p9EIEGH5++slB9i?=
 =?us-ascii?Q?EQqxHcPbmjO3gh2GcihORlv8zLftUzhr3SHZ+Ng/9lV3f4kxMjfW+yuMuWZC?=
 =?us-ascii?Q?6WShthC583hD817ROHxbotcw2gk/HWTt+yKw4u7XFM1uMNiMKPyXSA/f6ACi?=
 =?us-ascii?Q?RK+cw+xAVJpJm8eutz5XiLdY0XeTWDmCxjbNuUR25pMQKeNJNUMb5eB/CVoI?=
 =?us-ascii?Q?xYSbhEeDtD4xBR6Wp+laKE991vv7P5EyuYp5KLebeQwwVqL1aFLCDBIpe2fd?=
 =?us-ascii?Q?JaoInWJe738xpoPX2ivxqwh9lalMThfGoglI6yaknXujGUF3pTlMuxdlcutq?=
 =?us-ascii?Q?fRpIwinv7Qaaciy1wuaYbH51JUQBKTJatRgqU9eJQEfgaL3agQ3Nm4QqD1WJ?=
 =?us-ascii?Q?9y7lMb1bAAA8kNTw9tFyfTq4NbD0Q5gs0W1+0Yh5POnJ/tCgUbV1d4O+S2IB?=
 =?us-ascii?Q?sjvx8AeZQvGThKiBqpOLs9hLkY8yotgxnd6hw9GVWkvqOb8d75DV6/Cf9OSC?=
 =?us-ascii?Q?jT+1jRndPP6PZ70zjR0af2aXohlAW1lkF3azuf5ZUfgBW6tHSb0dwVmA0+Ir?=
 =?us-ascii?Q?Y0jvO5BeBa/+ZMjgkgEC24B7Bv9aMTBg8ZMH29Rs1PTR5KG3QwKVvWEa6Pe/?=
 =?us-ascii?Q?DFKLZ0olJprFSsXN6F2Fj3XhguHabSZ0xtMaxgcynptPC7mPMFCPi527uwru?=
 =?us-ascii?Q?3VqEdlBPycOPxT3Osp2bqzvGRkS/9U9Htk7L0SN+3Zh4NJ6aHq4WUv7qNtmA?=
 =?us-ascii?Q?m4+kUQF8QIpxbPVQm4pUtvDClAfqh+ZWrw2dRaVXIWwZajkbJyG1l/3VAmRB?=
 =?us-ascii?Q?2oR8TzeATu5sMYW/rwbxJWc9mZkameG2uTYAajgyhBWi7klQVVO18SU0GUeL?=
 =?us-ascii?Q?+fJg/s9HrLIYwUjRlALoJb9TYzp/DbVzUU4CehFVne5Kuz5TYEiyqOYoFNF7?=
 =?us-ascii?Q?IyS1VQMDBUPPe4z60prkbGrOCAL4yNjb9yN6oR0NcPDTtQEzH1+8NF/53Fce?=
 =?us-ascii?Q?Esy/cBOeEt8pxQ3IofAJ55rPPwcnxb+vkuuXXiCuI6UUwPMOu49F9iMU5feg?=
 =?us-ascii?Q?UhRr5aeypFTaNo+1XlomlZRIO9cwQ2x4QOC5oO+Sg21/pH+epshgmA8zx2M4?=
 =?us-ascii?Q?HHwZWGfRtCoEe4fCJAHpf3+dwamu+CYC9ESkPMlz+Entp6h4oCjd3p31JDzc?=
 =?us-ascii?Q?1SAiIgj86VKmMx7nj/y94rlL1Jl/JLSG6RXoD69xid9YTsRRYm6t+LJ0CWiI?=
 =?us-ascii?Q?6vvJ5yie9lAiDSzqgFtDx/JhVGACStLVLkAKelf2C/BdfdRucYsJHjZ6DY1P?=
 =?us-ascii?Q?ImuTrD0WwjclME9+s1PYG3VA?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6f506d-85b6-41ce-18c2-08d8cc44395b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:14:26.7917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GOQP6vGh6qwSBXPhRvOX5/U/R/XEoo7x2SQLlIK3A1QIEopBEDghUVP+R8tQQt/qGrd67GYI8uQy+DWgFNh6dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
each ACPI child node.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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
 include/linux/acpi_mdio.h    | 27 +++++++++++++++++++
 5 files changed, 87 insertions(+)
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 include/linux/acpi_mdio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 47a5e683ebfe..ead71f60607d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6669,6 +6669,7 @@ F:	Documentation/devicetree/bindings/net/mdio*
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
index 000000000000..7859f2f3352b
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
+		ret = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &addr);
+		if ((ret) || addr >= PHY_MAX_ADDR)
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

