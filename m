Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA741FD345
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgFQRQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:16:31 -0400
Received: from mail-vi1eur05on2086.outbound.protection.outlook.com ([40.107.21.86]:6145
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726941AbgFQRQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 13:16:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJH9Bam4qZOhQOzrHAqLU8LqZFGB4eXcgVcf6FR4tDYJnlt+gdO9CQkDopNQjiWY5aJovnc05Ptk6jge8GsXYg+8rwME2mu/IZyuDc1/Lok77USbLcbfXsjgk8Fa3uMqIF6GyIsqsRHqI2gRpIN07bFMPTJCk38BrqZn0Fop1pizLlLKyULvYDBaw9/V/1f+eCn/UJNSxDI5RYmDmNBm1rsFk1TPvJ2oT2uE564o+t4Pz/SOwSTpZTmpaCw7kNIUQoVHIVAilaDuAbucsaXbvbDdKRBi1lMDiQ5dUkrOstX6Ih70YaYtNNJT4LQqkrHJScmRnjSyJBeW7Jr6fsenmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHLC/iAHSNDWoxfJUn135fxQqtmKquqkkD4WkLFx0X4=;
 b=IZOMJVcqVY2O7d2K3vo0ziStx/YONU6s7Wv/PYbO2bWWvJ8J873Os9L2b+KZLQ+od7cgzKb/4HK+cpAL/LM8uwjIQ4CXMep9PAj08JbuMK2RAurdJpWTNpmWl3JQ8PbLS+Jx4Q2v87qNzetXKAv31JpZyzoLMRnYHNuAQFL4mqEexFQPIb8OLEvXI2ueZIkPd4kuAcD/c0zlI2UxxAtKZyZcJn7I21Ofb2ChdsCCZiBSa6Kj6QLgmk3E5XIZPChfrliu2XdgM4RapUz0U2A1p/tcowooho+j1kxRFobOhqmWt5LmjjIt3ignLUOdU9PzlMB5+9oCUYRq9J6TfGAKAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHLC/iAHSNDWoxfJUn135fxQqtmKquqkkD4WkLFx0X4=;
 b=IXWvJlOIRC5azAUGFcihDFg4F979K7RfHOr3T0dn8iRCh3OGn5O097wGdsTZLCAFXumjQs9zZUGlKRlEqxROYakyNwJPl0TkwHxYhgR+P95rWSvR9Hc5V5zotC4UIPhFTjcZARr830jKl8WSYdpciTNS0dv2E2/X+BZ27AcfM6w=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5427.eurprd04.prod.outlook.com (2603:10a6:208:119::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.24; Wed, 17 Jun
 2020 17:16:23 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3088.028; Wed, 17 Jun 2020
 17:16:23 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [PATCH v1 2/3] net/fsl: acpize xgmac_mdio
Date:   Wed, 17 Jun 2020 22:45:34 +0530
Message-Id: <20200617171536.12014-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0146.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0146.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 17 Jun 2020 17:16:20 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: affb1f38-057d-440d-d5aa-08d812e2292f
X-MS-TrafficTypeDiagnostic: AM0PR04MB5427:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5427E681760E3D2007840E5BD29A0@AM0PR04MB5427.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: leNiFOjjhtJDjK716I+/1wGcXyZXhI8tSpqTKmEuiaqrAyOVPWsg8Jyfa/Z56Pz57bgsUJD/fAmUC71sCY8AIB3Fh+4eyK/RNcIp/v9PWRdow3eVnGKRsV/KVORkB0fMkHD088ogPQ7x1/jGyET9W/JzCTFki89VRPl9c0zslnAO5dfi1aoVpHmzsrSw2Vmq08FuAQ4rN5zrWmdczLoDjJxxViUNbZM3Ps44zYUyp9oMevQwmIAII48BNqPQfjjkQlQ3G5TlD5umZ/e+GXHgtdb/ZeTQZftBBjDL2/uifLWMAtKBsT3wCnSsPdQnE4aAHQyMbW7Cv8cQ8ff0Fsee4dA+VlbQrtMM+Sv+TV/UE2PqNs4uXlx45dCApGji0NEB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(6512007)(52116002)(6486002)(26005)(6666004)(1076003)(478600001)(8936002)(1006002)(66946007)(2906002)(66476007)(86362001)(66556008)(956004)(44832011)(316002)(186003)(8676002)(55236004)(110136005)(83380400001)(16526019)(6636002)(5660300002)(4326008)(6506007)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JikNNQD+EGi9XNfZ59nfJ5/4Qhp6JN2YnEGGFhXKKuiHPDsboEVeg4MpcoTxpnSiN3meRrJgqS/Hyvjmb32nOYexEI8wsyTmWZUup2QkWzQVC1Ck0pe0twXUk3meGXfLjWwh5k+NKWE/DukzpxP8W3rwHWtEC7xmE6W7XAtNF25JhGI2QgrwrMnM3JCFs/AAivFnIKm+Ai31yzstiAsdBAE/V6k17QAdfZXNEblxqihiGD1tamDDqsrnLZqrW+7xrGb+hN6+X8AN0omqK3N/TJ6OtGTKvMMvRGdx/Sm0q4j2ulHUZ72ltErLjemRRraFzIpQfGbm47sWtG/EpBvvEZmhSEWooWep8hO0GtfyOxH5/h+jTQSDoeX2RrMTlH0c5cDZDURC/XOxiYune1CFB8wptSQzHQz8Hjbxb2wNtTKdEBOYOPzKeOG2EoD/xV5rFhHUXCHsk2lPEhqd7x1YrNrY12bc/kU/O/yoFDu2jRdRkzHhoWS82AcsmxdoPhLj
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: affb1f38-057d-440d-d5aa-08d812e2292f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 17:16:23.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vr+c2sDZTacMmowcay3efK59OeZ+buQez09GgXMLMahYKsbBhGZmXF5Ar7gelJkVJdOQHYZ2/5tDcZMPI1u5PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5427
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

Add ACPI support for xgmac MDIO bus registration while maintaining
the existing DT support.

The function mdiobus_register() inside of_mdiobus_register(), brings
up all the PHYs on the mdio bus and attach them to the bus.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/net/ethernet/freescale/xgmac_mdio.c | 27 +++++++++++++--------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index c82c85ef5fb3..fb7f8caff643 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -245,14 +245,14 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct mii_bus *bus;
-	struct resource res;
+	struct resource *res;
 	struct mdio_fsl_priv *priv;
 	int ret;
 
-	ret = of_address_to_resource(np, 0, &res);
-	if (ret) {
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
 		dev_err(&pdev->dev, "could not obtain address\n");
-		return ret;
+		return -EINVAL;
 	}
 
 	bus = mdiobus_alloc_size(sizeof(struct mdio_fsl_priv));
@@ -263,21 +263,21 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->read = xgmac_mdio_read;
 	bus->write = xgmac_mdio_write;
 	bus->parent = &pdev->dev;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res.start);
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res->start);
 
 	/* Set the PHY base address */
 	priv = bus->priv;
-	priv->mdio_base = of_iomap(np, 0);
+	priv->mdio_base = ioremap(res->start, resource_size(res));
 	if (!priv->mdio_base) {
 		ret = -ENOMEM;
 		goto err_ioremap;
 	}
 
-	priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
-						       "little-endian");
+	priv->is_little_endian = device_property_read_bool(&pdev->dev,
+							   "little-endian");
 
-	priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
-						  "fsl,erratum-a011043");
+	priv->has_a011043 = device_property_read_bool(&pdev->dev,
+						      "fsl,erratum-a011043");
 
 	ret = of_mdiobus_register(bus, np);
 	if (ret) {
@@ -320,10 +320,17 @@ static const struct of_device_id xgmac_mdio_match[] = {
 };
 MODULE_DEVICE_TABLE(of, xgmac_mdio_match);
 
+static const struct acpi_device_id xgmac_acpi_match[] = {
+	{ "NXP0006", (kernel_ulong_t)NULL },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, xgmac_acpi_match);
+
 static struct platform_driver xgmac_mdio_driver = {
 	.driver = {
 		.name = "fsl-fman_xmdio",
 		.of_match_table = xgmac_mdio_match,
+		.acpi_match_table = xgmac_acpi_match,
 	},
 	.probe = xgmac_mdio_probe,
 	.remove = xgmac_mdio_remove,
-- 
2.17.1

