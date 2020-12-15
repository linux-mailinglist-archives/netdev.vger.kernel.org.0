Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A27C2DB1F5
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgLOQyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:54:47 -0500
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:56934
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730531AbgLOQqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:46:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2N2kXOnixKCx8090hL6VEV45vbukElCQm4ipyZ4JvRP22L9jjddPGT8O73vj0c+FH7gkHKJNbLCEvl9sQExPilHcMuT8SnSz3KtaWuBVQwkC3zMXG81b5q2QADXfRNMgdbKUygVHal0jnDO+D4OZVLnM0klCbUvIEzRrJqi21tO+Xhq+38CVrxYcLu2/AkWTrMoKvlSnin4EDpm8puCEf+oXbfKBSuHKHh5QdAi2C3TlZ5uu0zjP0S6PIO3ScoAQgIFNkTFSLR1Egpc7filO5UY9sTegIflCtM77EVNiD2RDya4Uc/WKFkxO12ppNMUcdvlAT4OoAdAYtXuruYtfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J99a8bnRoMTGOgkgCKVorR1cedCBY9YEIkc2W+vFOAE=;
 b=mAizbbCS8UNWWkKnjvLui8/PR5l4SZjtg1jylQO/dxZMMQi7AW4+keP4yWhYuUGqmda97CGtwJkok0POojDRoUfZdmDJpiZJz2SDEcCn0tSqUQ3Rao90D1xYOU7lL4vUieKhCUNV+aLXynEOA8PzYzsFJ1LVTM8VP0MmPcSf8rkF+30fnUQEKGNgTv0KN9fnd6So1yv0oc4+9bMjFz3vBeHCVZauXyRB53EnrD5Fg8sE/LIp4zsNQumd45DvYEFV3pGcroSglbomktCPdei/hEFz0bz+Zn9It5lEMYsIRdQLVlRUaEavOEXR0DMlmIDXz8inFbcH++5bhp3TLtrGBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J99a8bnRoMTGOgkgCKVorR1cedCBY9YEIkc2W+vFOAE=;
 b=VZlI/3RXJU32N0uy31xcJZkYw1ZSnDNTMUtpw5KRmbWWKA9elwW1jb/WaTPtBqy6iPwI794mDqTAM++DRa8MUSswvKvzLFPFwcx6axT4FXDn9FZBy3SvU47NQRpKV7b3pG80AliLhw7Y0c1jBPzrPooNV7NMBSTwu6WYYMwDu2M=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:44:49 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:44:49 +0000
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
Cc:     linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>
Subject: [net-next PATCH v2 09/14] net/fsl: Use fwnode_mdiobus_register()
Date:   Tue, 15 Dec 2020 22:13:10 +0530
Message-Id: <20201215164315.3666-10-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0152.apcprd06.prod.outlook.com
 (2603:1096:1:1f::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:44:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e0e0592b-4c54-4bc8-537a-08d8a118bd1f
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6963D737CA939F33934418A6D2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BhD9vBia6SZ/boJzhb8OsiPnfyG5lOBSL1XtnQb28vqUJXGwHcry9TfP7NSET+W4PiCboMSbxwYnV7fycC4QFETYYy0DqijlamVBPCf4Wp8HlrizYZ0mBCtWalvU5xCY1QcwPZ0XWmGh1K28wIhxcKpIZi0JU9nchzNWe/W6o0rM6ecrZLu8gu4b2pZfYLVAGJY+scBfeDDbaJmgBCQtxsfV5LLgVmmP7LT6r8vZcDZ0BKhs93/5/T8whwkoqO2nJkj/tR1v7gzVC5zjpmwEkqITgquzfA/moEgUlD0aSxTyz2UlLx+FE7O8d8jaXHHsMqndRmxotVwxl/AJ3kBM4fRmJiFTVmqdqvvn3KUdH6l8Y7rH739IVJrgjj26lzRebFVLqkp+otapzVu40JYKGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?goEkRGcYzblQ3he3SKrjQPJ+vE70KdjC/N00AeEhYHbKJ72xwRiU2XdtzSxs?=
 =?us-ascii?Q?uF/c2DPFOkFSabF9KDCCvJaDrMIEbjDli6aWz6DMkH2g+WhfASAR3saChE7r?=
 =?us-ascii?Q?TvctUPHCq3aQ1gWIyUm9aYAAteKzVe+tB4D4t8upIDrNLymFAC7u7UsdorZB?=
 =?us-ascii?Q?z7vqtGU/8/MidK3TNhWZjFYT+dUGGDhwEwAmiR8/Y8pXN+4iHiFjhg4c4YUv?=
 =?us-ascii?Q?WoEQBiE6ooHyIX1L0V7cfPhxOzqz1zk4lzM7UcvUD/mulms0/I7vSzizZgXU?=
 =?us-ascii?Q?LJRvXSR14XscYWaeqaoyGD/pCQV+zIk+Pav9keiwFnDk4YQ9lJzuSniF55RC?=
 =?us-ascii?Q?BhNwIRlWr1Hc87MyRjqh7Dw50JZpOWKVLyxUO9AtU55imUReJDy8pDVPChM6?=
 =?us-ascii?Q?8W3QchspMeYMrgrOUttfoBhHLL7AtfFCINV3apVReJgR55sdARrf5vQh5PA2?=
 =?us-ascii?Q?RradAul62aaeCUMOlWc3TZClXnGzdjdJYD7b2KgvfixHQh4RAsCELSQTZLGI?=
 =?us-ascii?Q?v7MLGkb2xzKNmnwcIZJJcviea7aI1fGwwtLxucah0oXqFjW56w9PrDWm0QGC?=
 =?us-ascii?Q?QZagiHxbcJ0FVdcdf1cnMnGm6T4fvrvZaHZKqShEyEUJ8/Q3IvCCFbRO4WEj?=
 =?us-ascii?Q?JoWnGEDhxFpMuImaFcqKFeJlzZsSbpMkVE3//XBZf0u7HTDE5NmcWxsGxC9N?=
 =?us-ascii?Q?xJ5DA0x9gFhMT1LQm7IA6v+AvSJ6C2VuNrLxEDtIUk+9p6uSremIa1FuVoiP?=
 =?us-ascii?Q?fFujxxi1xqwALlMXumm6OLglVhpUO4pckc1h1DW8cqJurjHZe9YygsZa2P5c?=
 =?us-ascii?Q?TavOJRm6tavm/xGzmqUW04Zi3i2i2YkelOpbb404EupJFTuL0/pxGKZmR7GO?=
 =?us-ascii?Q?zwGvgNAwHx0JBauOuKr6KabkcBV3HyDyyD3iN9hYFmv73G6QF5hLn8rT0KaZ?=
 =?us-ascii?Q?dJI2Y33ObA7/AHIV7trMvhwUV+eMolTwrO0jn3gUt697yRZCnjouRX5rET5p?=
 =?us-ascii?Q?LJtS?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:44:49.5819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: e0e0592b-4c54-4bc8-537a-08d8a118bd1f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CQr0KsITjJPY99JHbA0zuNsIcuUDHkjaMQzUhXSL8hWc/dmISE4tORsG7vsAQ2y0sZ7oZGTBTLOo3Ls6VqCpiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fwnode_mdiobus_register() internally takes care of both DT
and ACPI cases to register mdiobus. Replace existing
of_mdiobus_register() with fwnode_mdiobus_register().

Note: For both ACPI and DT cases, endianness of MDIO controller
need to be specified using "little-endian" property.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/net/ethernet/freescale/xgmac_mdio.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index bfa2826c5545..ae2593abac96 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -2,6 +2,7 @@
  * QorIQ 10G MDIO Controller
  *
  * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2020 NXP
  *
  * Authors: Andy Fleming <afleming@freescale.com>
  *          Timur Tabi <timur@freescale.com>
@@ -11,6 +12,7 @@
  * kind, whether express or implied.
  */
 
+#include <linux/acpi.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
@@ -243,10 +245,9 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 
 static int xgmac_mdio_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
-	struct mii_bus *bus;
-	struct resource *res;
 	struct mdio_fsl_priv *priv;
+	struct resource *res;
+	struct mii_bus *bus;
 	int ret;
 
 	/* In DPAA-1, MDIO is one of the many FMan sub-devices. The FMan
@@ -279,13 +280,14 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
+	/* For both ACPI and DT cases, endianness of MDIO controller
+	 *  need to be specified using "little-endian" property.
+	 */
 	priv->is_little_endian = device_property_read_bool(&pdev->dev,
 							   "little-endian");
-
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
-
-	ret = of_mdiobus_register(bus, np);
+	ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
 		goto err_registration;
-- 
2.17.1

