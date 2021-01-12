Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364992F320E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388106AbhALNnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:43:52 -0500
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:16694
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387526AbhALNnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:43:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYYrVYwkw0QpiUAzVZL4vf+FprnoO9OgqbslEAoeCIof3oUj8Tu4EGJ8IP6/wwjdoj/ZKsp5/Pk7fS7tdT6yHCemu6Hf6WBdt6AEKBoxQ9h0CD3gjr/hCaL0w0iQ3sUCS5/DKjx3hVlAazSTY/cYCE8+2UWaeRyQr+PMSETMYtBw2w3mfGQVlh8FFLP+0qKKYh+2wHLqwpB9QZbH2H6EgbVK2Ba25g2DjJQMHaG3SZndOhWWJg3WpOeRStjDMJsjG63vWIlfv9J1VN4+RYM6hxfPa60Q0GMrtvAGZCRnUWAonBBEO9CRqgOO3oHjvUd+T8xnKIozpXvd4EptqLHjeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+ac/sHlsjD1wXhT9Y0kXhnbyl8mFnzvRRbk+6v9oA0=;
 b=Qs0M909GtAbVeZx1x9Wlm7IkupP5uNrNS+YqYzN2omDbElSwWek0ursIlqHF94IJrXHq3UIz4uzg2uBTyhXOV5uEIIq18zoHaZIoGpTuUyeY1ojJ9X7XzbvGbWv2H8KMqqrUIOIxI3c+785Obny26uwrtw2k1SMaXTxcdmHc8xF6bn1g7+6pHeiM1oSxRIWzN0twJd+T7U05+J6QfX0bRKblyR0hEWHqwuFgnYZPlWg+nrdu6i4TnAyLvrvWoBGYaWcEOiC6xi0eT65F7iv8Gf4pzDcvsF6wN+P0WAx3YCeLLkhtZjis/15a0zAqTIdAnGav5FsyxAMa0lbjN4iFew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+ac/sHlsjD1wXhT9Y0kXhnbyl8mFnzvRRbk+6v9oA0=;
 b=FeDFGAUsclGnYoHjbJwAmh9Oq3s1FSrOFSrSwMcQ8c8ZkyBkR6mjyJ0NGZSQ9xwB1MarC2uv2MSaPmcS3x8ZnmNG6baxrHPJ6eXDOiZp96B+K3c5L9SNiam05V8kXUC7dVUUMkC2cO9YFXgxGvPGwcMh8kjegtF3JEmATPrBtwo=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:43:01 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:43:01 +0000
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
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>
Subject: [net-next PATCH v3 12/15] net/fsl: Use fwnode_mdiobus_register()
Date:   Tue, 12 Jan 2021 19:10:51 +0530
Message-Id: <20210112134054.342-13-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:42:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 62e437ef-a33a-49f7-cf86-08d8b6fffab8
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB34439CA0C74DEACEEC9D2DC6D2AA0@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mANDbPGkr6GqgR9t3lEtcAcYxqVl44piNZmEf8HTskmW7daqa39LVNTWg2I+IpoZ72NutvfNFn8wvExFILQTObwI/qHN5ZvGKqCnW1Qzw6BdWK3NcNcxygnag3bay4yLZ/9L9jzR6NFadDYcy72rK2By4KfFFInvas8j23jqPt/nKeVQjiJOGuNLc+Oak9AEijULOhTmlRSVKPMYefuaABoiyL8aavoMburRLiKpYeYCnkO/3W6lGD4ahwoq7i0RZF0KjuktajF0zU7dKtW700v+5zN3qvb86v8y3dFr1gKRbJrOASYKhE0tU67lCV50b0sTORhIhz0EnOFQ6Pd+9s9YQKIFhQoZ4wHsOvW5rYjTmT6DEBS5Vzu3tXwAIPZqcS8XBkfOTbBibm8ANJ2+6GDFpP4Dr1oFuKoakmXZalCY6/TaVsZkMiqWun1465F75D8Vw01tWd4u3RE3RtcoeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(478600001)(1006002)(66946007)(921005)(110136005)(6506007)(54906003)(16526019)(83380400001)(6666004)(52116002)(2616005)(66556008)(66476007)(186003)(7416002)(4326008)(956004)(1076003)(44832011)(86362001)(55236004)(8676002)(6486002)(6512007)(26005)(5660300002)(316002)(8936002)(2906002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cmSxqlH/ggVgw9/H2gBsAUFPJNCZ5ZVQ1tv0DLJLra6nOMtCnPtAsVshSe8+?=
 =?us-ascii?Q?7fkflaMouknMMISwRL/ev0I1ZvO4+SYPhvpuiMYRUVaIxvnwOeBoxKQoRZFr?=
 =?us-ascii?Q?ndKLw7LBxUPZqd/A7KuP6TAY6PenaWq/yQf40QcUtj2itemc013HvmvccNFh?=
 =?us-ascii?Q?echUe08Fdrfg5veRv8HMimlOxJJdaqxIllvfFG5XHxz6lWcNdVqesdU00YTi?=
 =?us-ascii?Q?E/MWI+dDlueMFQlhKEnHQz6L4hQs7vsrTjZox+czs7KocPnb78OLzoCo3fxS?=
 =?us-ascii?Q?ulLu3p27FhwU9/aVu26BqfNsSkp8/YMfh06hNlofC1PHL6QiXSgEcVUKLo1T?=
 =?us-ascii?Q?c7Jr92zXEilVOqIKzaEw0IWBdwE1hhyGuEg5B9HnaD88wvfZLHEqf6Wm5LR7?=
 =?us-ascii?Q?mRUejbFUwAkatKN8AcJbfaepdNwokhRrS4+YdecQuJbWHKlJOSCE53jBahz0?=
 =?us-ascii?Q?dh6OXZSrQJk7IOS4HubLA73cm0Ss3kJV97Ey/+ATNU4BvqVy5w7LdYN7epXN?=
 =?us-ascii?Q?G3KCeuzd7GLa18R5YY7hKIys7N4VIbIdB1gDmROlA4GAj44FjvJNBR0Qh+aw?=
 =?us-ascii?Q?jeF0QMUyUzO6XncF4hOp5NZwExpaS/4CjboRP/94JAKnE0n+dAo+VCYbe4Hs?=
 =?us-ascii?Q?32La/rYSOFWwtrd+PpCwKjktNPnxYkHJqVZJzwyTrzry5EldGiBvimlagTW8?=
 =?us-ascii?Q?iIU4LXsuFHj9d5mwwDwEyBy9YSShEvOY5I6BJVJqAPQmO/c3Jr96Z/yJ4vae?=
 =?us-ascii?Q?4M26yAPLjCxRN3748aDOFFIS3hbkuss3zyOdekFpAG5jixCiIBY6M7qbRNOw?=
 =?us-ascii?Q?O3EBqeb0dFdhMlPvX4lL+Usy/q0BQBXSfCse06lxehbd9Z4Bg2aEEac8wC9y?=
 =?us-ascii?Q?VOggJWVnPs/rrLpefKFOHbox9IUZcb9n0jDPsE0qnKVvIqtHkJFCRmc78B5n?=
 =?us-ascii?Q?ObOrCTYuftKHRPrJvRjZrmWkSNH/FN8TMXYCRtkl/HD2aOsrcuOXMc0fQMnG?=
 =?us-ascii?Q?oWeF?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:43:01.1477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e437ef-a33a-49f7-cf86-08d8b6fffab8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f6XFfCzOrYy4jKAKW4uOV2Iri/VBzMgYDLmw5yz2B++AnlAYOR64bCA+UKTcu24VAgjYQcaFENI8Dz9b4upqdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
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

Changes in v3:
- Avoid unnecessary line removal
- Remove unused inclusion of acpi.h

Changes in v2: None

 drivers/net/ethernet/freescale/xgmac_mdio.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index bfa2826c5545..d609c08b445a 100644
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
@@ -243,10 +244,9 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 
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
@@ -279,13 +279,15 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
+	/* For both ACPI and DT cases, endianness of MDIO controller
+	 *  need to be specified using "little-endian" property.
+	 */
 	priv->is_little_endian = device_property_read_bool(&pdev->dev,
 							   "little-endian");
 
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

