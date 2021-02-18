Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C71F31E5B2
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhBRFfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhBRFaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:30:52 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0603.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B38C061788;
        Wed, 17 Feb 2021 21:30:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXskKfnZRrHlop3BPbsasdw9sC5c/F9Y+LLBMZ3bcNsEDb5gV7WqoWljfT6MVyALTgbyXartk0EgGRUz9qJvCSjyC5oI3W+OhTh7t7yds8K9j8IFTgdgDU2a7aYcn0MBM18/Ta9k/dJjkDP40VqSwnAiXaz+YdkyoMwMAludvQ8tdBQL6GwA7t6LNLXHwqQBswITdfRKFfN77HEIPGc8BUyADRbToShicemS8lj1+zu/cIJ+SXozCH5tjt4FO0DreOlvJDSfu07IvzKcGLUC3Ov2hOqi8chppJTjqtoV4MwZAg72Hbsq/ehhMQVTbbDgzLvrDsy6mu9lyC75DpDcHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iN8dWrUpI69gm2uQRF7UqhxjIe9OOLdydPVAMK6H8Ds=;
 b=BQqZArEenG9luvqRDXiL1o1S3YOR+WUyWGY8El2+P5MiX+wnAyyvn1NIQ2ZufCUEcgMWwG0E9ISyMwZShzvtXcnnAhGOuFSEkkaJYBwdV2Lb+fcCP+/7EmKmxbq8l6qn/yWswHsUM2raAw7KRmk8sdUK9Qw/uFGd+1sTYtjazSidXpZwRs1SkOaddophPxi2evvHca1UuLbZUK5IySa/IoSmHfuGaIOZm99OrdF4Y6hllkuYRw338ujReW286IK/8OGhahgnimbnO3at86csCOeJ/7QiW9EUkAnOaN6Xv54dEu7a5Y0QIS7CcjW+Rqxltokxq1tfMQ8GF+tx0dvxsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iN8dWrUpI69gm2uQRF7UqhxjIe9OOLdydPVAMK6H8Ds=;
 b=MGLlEwtkrQKuOeEmLSnboBUT3yllZkfOieUrNPoBPmRcd93Q2FXePMFF7/ZTRFVxOPwNEOwQbsXN8NaZXvqGlc/vg646BPlxCpppPLwNpQl2UfTn8kogQ5JTdbVwEl5Jh11ASoL23T795JFHU4FaoxTOzPTqXiNaBI7bspkz2bE=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7730.eurprd04.prod.outlook.com (2603:10a6:20b:242::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 05:28:49 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:28:49 +0000
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
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>
Subject: [net-next PATCH v6 12/15] net/fsl: Use fwnode_mdiobus_register()
Date:   Thu, 18 Feb 2021 10:56:51 +0530
Message-Id: <20210218052654.28995-13-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:28:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 779a09e1-41de-4b37-7064-08d8d3ce1216
X-MS-TrafficTypeDiagnostic: AM8PR04MB7730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB77308D04193EBB7D2F478D42D2859@AM8PR04MB7730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wCv+geqrVACCTi9R3pmgP72f43OWxtwnWiUxFhqGIdz72AjGR7CPEn8bojNT3Vy6FL2MixW3QoIHbroWToBhUxs5wNAEIeNECleM9WvqAZB3vp2uNzIsws2tz9/c4ROKn07iSandrdenvmEURu85pwbFFCd9HKH/oQrfoN9MMwVa9wftbmaD9uZo3BslAQBaaJojs9dtBjjhmzlug2nP9Bd8Gx5hGUZ57t2wrNdPvSC097+r4MIGT2V/mAEhgzd9FaPqUZxdLdo+Hw0f3THtvglc7zwWH4S173JSsrR9gcAWO/Nz5c1a8duLGJ0BKbdxesuqy6W5dr7XL4wE4LLvuoIAvISD9tLIvYHx0IKY52qwmO9L3mdZDyFXm5vYpmeRbZKS6rQgPMRI+8SCnqcLu3XwUHBPKBnlPQIwCS73ljkLuDuRPqc0G986CteXwaq+17XnVTS8xJVVaKMK3fz/qLyoEMKCn2agYpkeMJxeoVpsO9vPXJmCHi2M8APL+IWN5eS8ViVbe+oJWZvZuhUBWUUfV0s1BNA/v3S41QOsvzOclhwTSCPMXrXBYrO6hcesfl0bE+ViKsRFK5D3cq0es0+GYYoz/Y4exaNNJGbWs4U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(8936002)(52116002)(16526019)(921005)(478600001)(1076003)(6486002)(8676002)(55236004)(83380400001)(5660300002)(186003)(44832011)(110136005)(6512007)(956004)(54906003)(316002)(66946007)(2906002)(2616005)(1006002)(66476007)(86362001)(7416002)(6506007)(6666004)(4326008)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5w5TK8yVwHGrfOij9V6wPGZ6xZadJYg33ACMtNZtzDT0wuV9yGNTjwc9P6+o?=
 =?us-ascii?Q?46RToR++7LDM2W62VB6R/NCjGq1TNpXe0+T8xWjYBVncJpIS/Tqw5x9qGFlN?=
 =?us-ascii?Q?sFIKeDEqKMagkgLOwFoa01MCrZxTv+y7RfFYU2tHw17PsyYNimyhcea/Wafz?=
 =?us-ascii?Q?WnmkJkoxANSeVT19gYvVaaXQMii2kZCckRi0DZYtMFXnMfWJSa9gAyLXFvoW?=
 =?us-ascii?Q?g64Ii9inOXhUHYdH8M/O65pMlzCGAoZPzcnU/GojfaReMYKRydY3hTUEgXWk?=
 =?us-ascii?Q?UsmUy3uPyqPyfHVuFi2+GakCNo/gDrHoEPDdGtodQwFj8qyWEgmp15BwDA3k?=
 =?us-ascii?Q?UwTflD77YlsJbZam9FuqBV93xba+Ri/LwhTB664/ZAII81qYvfjB4KfRn1u5?=
 =?us-ascii?Q?Tpwce2dxPIp/pO/GJwsTsh2XcaeOmYqMfA6Jo9RF8XLfjc0R6DUmqGd5RBqf?=
 =?us-ascii?Q?yI0E2jfM8sa9Y1PJS17IkWpRIR5bMP50sBdZ3RJo/q6LbetG++blpSt6CQb7?=
 =?us-ascii?Q?0qzn+NwD2bTBjHk2CuU+NnNtm30SDb517LS0Q4JKc8jZLlYOJ9tCjpL2QJG2?=
 =?us-ascii?Q?PhLbotFMJe4GfS3PXT1rWifeO1gX+gnOMJrXAjeeyKbPoNFp5l5ZMiCdr/HG?=
 =?us-ascii?Q?QdLI9QMDuM1jiF9V7WEhNTuhlchQIkTZPnhvc4b6ZhPYZElsXsFhJQbHW//Y?=
 =?us-ascii?Q?1rK5uiIJS08G3PWwfzG0639M0fZ1wWC4nW3hZncWAUoOvT+4qSIan4i8y+s+?=
 =?us-ascii?Q?aOQnstrfAkxaMF4WI/UeqOJlij6fUbwEzvGr15HZBV49CMubKfiKrLeTqBSf?=
 =?us-ascii?Q?aVtuDPvqVlt6lGQZVKMnSf0enDRkzvjqPZhhQXh5ro/E/gy7DlS3aFOSiVfW?=
 =?us-ascii?Q?K2otggvatlX09B0+WBeji5ys0x+nMF/rAPYh+OxlX+vymW2WUwibztIH2RNG?=
 =?us-ascii?Q?CZwyhQK1fXj56OYPwJAOksYmBXUgYfH79b9Wxwvi1WhwSF8PPbw8ypgUtvFz?=
 =?us-ascii?Q?r4ii4z2CpTCDBpNBpDU+IsbaX1Fbol9NNjI1iYx6FP9sZutyKws4rPtHnDqD?=
 =?us-ascii?Q?yDrtCBdk2u1UxoKSwNMekGaZuibLXRyxuYTPRLtbJB3gsiU3pWv16xHOPnRX?=
 =?us-ascii?Q?IGUgwluvBhJyBkUpEbDYLq/0mGv+ZilOwHkYyX3vIKD5PS0xatnZuWxap5rZ?=
 =?us-ascii?Q?koT9bw6JwJGWK5HGBqPKl+hI9AmbTd5zQF59v0Gct3IgQKhotAAbX3VTUxeQ?=
 =?us-ascii?Q?10UFoe9932mL5QCB56jx316VZFyzfURWhNfd8J+HGJVb0sHM7t+o/ueOV8v/?=
 =?us-ascii?Q?31SRl//rUpzV7mFFEQu7TkC3?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 779a09e1-41de-4b37-7064-08d8d3ce1216
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:28:49.4848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LsazGlH7AIpWonF42JOs1mtir73JEHcBr7fvMUiRuPyAZBk5DtyOxazVcUF7CZhv9h6R2panbrSFQK0UoTgE2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7730
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

Changes in v6: None
Changes in v5: None
Changes in v4:
- Cleanup xgmac_mdio_probe()

Changes in v3:
- Avoid unnecessary line removal
- Remove unused inclusion of acpi.h

Changes in v2: None

 drivers/net/ethernet/freescale/xgmac_mdio.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index bfa2826c5545..dca5305e7185 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -2,6 +2,7 @@
  * QorIQ 10G MDIO Controller
  *
  * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2021 NXP
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
@@ -279,13 +279,16 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
+	/* For both ACPI and DT cases, endianness of MDIO controller
+	 * needs to be specified using "little-endian" property.
+	 */
 	priv->is_little_endian = device_property_read_bool(&pdev->dev,
 							   "little-endian");
 
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
-	ret = of_mdiobus_register(bus, np);
+	ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
 		goto err_registration;
-- 
2.17.1

