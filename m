Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37112F320F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387526AbhALNny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:43:54 -0500
Received: from mail-eopbgr10085.outbound.protection.outlook.com ([40.107.1.85]:39271
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387889AbhALNnl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:43:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCDtgIJvYMnYgwRSbj45buXzikYhTyQJeVwAfsLCYe5WKu7PBMAe0YXLUKDxN+AEQfkpbAzyimm6q5p69teCuXaPGXYnHmqPHqL86e0mUFrKTo8QBRtxv3sT2iGOs3BTgqstBgc6R5Wfy4WO3yAp0CPSx4mNgOrMew168GztIivYqBCgdRXdEmFFcpA6eNxop7Kt0xf8PNIlWuqyijQozXFQaM5ISaFs2sVVYVMj2g6rU0L402AntN/aw6MGxAqNMA1CdRfK6STOEWzE4/9bnVOzvZ23/h3qeu19qhL+i/0gdMn1Piywh/DnRCwBXygUUS3zB2j+Tj7vX9O6nIlG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PG8h2yOCA+X+lsQ2OIMt46f4ebRFGNxig8GVOvJx8c=;
 b=ds5tVSLfyCDsBz5cwTEWNPm6vC//ppzC1jel7mhoB0/XpESJ2bQLFeczkrQG7CQNUCatsNI06QBBS2ngbiFL2e2dl4QRCN1dmyYA+Uvi8BT3A3LD22vCn6X/6krWkn3CzGjLOLTJepIdHdZO/ux6f5PzNkWSdgoHICBIT3jWW7otn3vL06KQ5GmMIte5hZjnGLv7ChHAwj6OO1otVMsNHEO7pzBtfNxjO6z46VUFrkwlpMJ2Al2vzKFZD4EFN4nG+FrQbOsxukfGPtN3IIy1OHj9Omqmu/lA+VPxiY8bBHuInfVWto95xXDbd8pN0yQ05wS4cSG++3F0blyNOubtOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PG8h2yOCA+X+lsQ2OIMt46f4ebRFGNxig8GVOvJx8c=;
 b=WfWL8kC2RTlbxsqmUhjI1UQV1yqAtEAyLh965i8gqOgd0IbzghmA4q5r91y5YYMWOXdvMK0bu4SRp6eb9XCExSK2LmsgUEsKcrmZn6H74W7CvjnFNm+it3+rNx7bEDpscwBaGLQk0n+xUYR/t/93bms0vWB9x2TyjBI+OkObbfI=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:42:54 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:42:54 +0000
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
Subject: [net-next PATCH v3 11/15] net: mdiobus: Introduce fwnode_mdiobus_register()
Date:   Tue, 12 Jan 2021 19:10:50 +0530
Message-Id: <20210112134054.342-12-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:42:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 399b47ab-459a-4ce1-b6cd-08d8b6fff6e0
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3443F4D776016A222952548ED2AA0@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7s0TaKxPZtnJ1M2pWyjhpNAukfnlCps5lbF1ecijtODsZjwBDTNmrzzc8RaODdf09fau7iwznsl1lI0XzmURRxMhvN5ID2ykfzaBza7mRQrctmUldYZv4DiKBBJXxQHay81LXAOP6BxwWA/6Bp1o2UECmnRXzlBzEO/uS0YoGyISovQX7boAObN2jKszwgrhBlRA9Ji9GD5it8d4cwMy2Kk0PEbUflEjOEJ2rsZPqt0LJv98rurvd54R/3W/Y44oCiC8SPIqjTsWkOY9dsaDGjAmtQloZEyAlOp2IuJlL1JMoVsirXC8ZUXL2zcprNttFEdsZhWCop7dxPhYcqPzsq0RpBUPzIY75d+Bn8uROClcsBfiDJVsKSBaRjTvYEYBYH/opyCSJ8r3duEIF+GZ6JZUeSGksIISgkzX1Q09oFBfeUHAoQv5yT9PEc0uaohPHv9QagduCMH+DpmLpZxi8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(478600001)(1006002)(66946007)(921005)(110136005)(6506007)(54906003)(16526019)(6666004)(52116002)(2616005)(66556008)(66476007)(186003)(7416002)(4326008)(956004)(1076003)(44832011)(86362001)(55236004)(8676002)(6486002)(6512007)(26005)(5660300002)(316002)(8936002)(2906002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dgeACb2MIMRTbSqYFAF0GmadYAjp+rPhiQu2oxySfwAtLuXhTkf+ABKJFR4N?=
 =?us-ascii?Q?zAgz2l6gtcPuZV14fxWknc+6Ab2uOW8kfHyjsxAIHYFzhPX7heATlRw3B4fM?=
 =?us-ascii?Q?Y1plVFiz5r0MDv9GW7TGmb8nIq1pxDeShZ7IYE6NGuuaHcjnPGOcmsmeUzDt?=
 =?us-ascii?Q?uquajWokLXEjbEiVFliHClJNHVRzmGnahLjRfPp+YGH+FgY4aoWoegQGIWx/?=
 =?us-ascii?Q?lzj0Uut1s59urGz5X4ug3HobeEn/13AOQaDE8Q0ChOnvtLDdCzBtXboVFueT?=
 =?us-ascii?Q?86pfb/Q/uUjHwJejeIIl7BrNRyYj5rSc02CLZRBxXBfFTN7LP0fAQbx8bjO8?=
 =?us-ascii?Q?PxOuuIFEKEbXf7wNfTUgM++ITz60YzASxLS3SHSsghb/36ahp0wnzI2bonkg?=
 =?us-ascii?Q?cb/g/7U4og+sSBqHOWG++l8zy58W/sLxC7c80GjBQu1jDt3o+k7lAPvxLfO1?=
 =?us-ascii?Q?fQasOiH7obCi4YphwGN1eNxuun4fY9augll8oWa0Miqai4URgVbNRIqdr5hA?=
 =?us-ascii?Q?zY7OIsEWHAei4PvIYdXzsFTO0Nu5GyfzjE9o6q4rfJCt70qi+Q4zLgrD3KNB?=
 =?us-ascii?Q?87JBqPUgrrkdY/Ie90zh8sdTA6zPrbp96VaYweHPg9aDLfblKomYpDRgWUgr?=
 =?us-ascii?Q?vCm5vmaBs0+dyMkgMqxx+dwzwWpBcEgA+7fgJt1BShsv5EIMW71qNnH0Ziq4?=
 =?us-ascii?Q?HqspNR5qlzJnEwWNWWcXfOrHhP4tSweBoPumxeS+aEHjrrMCfrLXV0gaWNRS?=
 =?us-ascii?Q?yL/t7WOmXPUhLz6RoTjG+k5l9n5+zKEX3etGdiHeepv046aieD8439mX9K/e?=
 =?us-ascii?Q?Zd1lFAN2XCkHfILaECWMlqaZHMUioRmgKm9fQysVJv6qfawiAhzL+zltHJW2?=
 =?us-ascii?Q?iCSE7pNuNATFq9+A1esju5IUqr0mWSSWKvcaxrj2Y8tc2CSrZVxojePaCNAP?=
 =?us-ascii?Q?uW8e0d1SaseUuRoRpxaPzRQY0ZUYT3XgWgJzniRn49CcModPbYmrgN9kQehN?=
 =?us-ascii?Q?W/l/?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:42:54.6533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 399b47ab-459a-4ce1-b6cd-08d8b6fff6e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ylei9Q+kqDz8Hz7+XviEl6g4unxlGPuY/g86fLFuPqW3vsY3JvZV69A3rwpKTO65S5EqZ5qVmz9VozW7+GmxyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce fwnode_mdiobus_register() to register PHYs on the  mdiobus.
If the fwnode is DT node, then call of_mdiobus_register().
If it is an ACPI node, then call acpi_mdiobus_register().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v3:
- Use acpi_mdiobus_register()

Changes in v2: None

 drivers/net/phy/mdio_bus.c | 20 ++++++++++++++++++++
 include/linux/phy.h        |  1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 44ddfb0ba99f..01bee3c46d12 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -9,6 +9,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -568,6 +569,25 @@ static int mdiobus_create_device(struct mii_bus *bus,
 	return ret;
 }
 
+/**
+ * fwnode_mdiobus_register - Register mii_bus and create PHYs from fwnode
+ * @mdio: pointer to mii_bus structure
+ * @fwnode: pointer to fwnode of MDIO bus.
+ *
+ * This function returns of_mdiobus_register() for DT and
+ * acpi_mdiobus_register() for ACPI.
+ */
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+{
+	if (is_of_node(fwnode))
+		return of_mdiobus_register(mdio, to_of_node(fwnode));
+	else if (is_acpi_node(fwnode))
+		return acpi_mdiobus_register(mdio, fwnode);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register);
+
 /**
  * __mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
  * @bus: target mii_bus
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 28cd111f1b09..0a5c68eab53a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -383,6 +383,7 @@ static inline struct mii_bus *mdiobus_alloc(void)
 	return mdiobus_alloc_size(0);
 }
 
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
 int __mdiobus_register(struct mii_bus *bus, struct module *owner);
 int __devm_mdiobus_register(struct device *dev, struct mii_bus *bus,
 			    struct module *owner);
-- 
2.17.1

