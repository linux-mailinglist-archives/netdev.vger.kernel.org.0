Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297F1203A46
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 17:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgFVPGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 11:06:18 -0400
Received: from mail-am6eur05on2079.outbound.protection.outlook.com ([40.107.22.79]:46017
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729210AbgFVPGQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 11:06:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auqbkw5JWGaEUexxb6sn9zTdNo1gqwxIEB1QY5roGNGINt8VK+EKl0pDK6t1zfHNHD5epAYGeSGoPukhq/HfwAlhupKlv08du5hATMvpH8Q2llI9gRUirNno/eVlJcAStjTiYvsAkL0snS9vFwWonqiDzLL4ENYhEbo8gBxh17F5drD+RdmljgjIp52kwKoJAmfNaEDsYe9YwthDdFFb2vR7wVp8Bcl5SzFEClVIikxISol4SoBpfHfekMdhxvfQ/AY9UJl6KBmzFQi4bjiSqB70TpkrrodKdUk7ennJQ4BqYXO4ArfTV5RY3miBFHWYiPbxGmq+WKPwE+6twe464A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIAlnW9JW96dDiZSW9asksdZwvor5iFXXgvZbmmsFCE=;
 b=enO/O+UQkxRx6IDsBtNUDopb5BONy1FP0OAN40PkyjVGfgFdvdJ1A4Rh11gKIH05k1OfdEILb85100VClmd3nsVmKQd+cvUUSntSsXENJRGPvQKyA0yPBvFkvrd8+P96G4xi1SeJrdMJ3N9IUxDTLJTwPdJjQaihUNIuB2XYqyLYjbjUwKE5D0TFuOEuzuPkQ2n8iF6ht7dSef73/pWJq/IZIbEeL3mTLl/0XwJZpxnswEBuBozGw7UYKHeGitN7DcJsHabHPh3wP89nmKqYaMfFp1PzrnOF5fHQLRBxCZofjyaMGzdiHoJrNOUmbnTeulSq9HS3E+A5vNYaUsJO3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIAlnW9JW96dDiZSW9asksdZwvor5iFXXgvZbmmsFCE=;
 b=aeaFSzLb1jKkzNIUF7q/wjqoRuHUru2d9mcWK0F40zP8sgrGAs9/2oj9YRUOgz9h5s3gTycKGEpEMzaAOfBARbqFKYTDC0Jcsp+KWiDke6DpP4M0lp05IH7tto4nCu6FlKd6sHu6N2EbaQU3RksD6P9iW+y8NHUGcl06ym7flhM=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4289.eurprd04.prod.outlook.com (2603:10a6:208:62::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 15:06:13 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 15:06:13 +0000
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
Subject: [net-next PATCH v3 2/3] net/fsl: acpize xgmac_mdio
Date:   Mon, 22 Jun 2020 20:35:33 +0530
Message-Id: <20200622150534.27482-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622150534.27482-1-calvin.johnson@oss.nxp.com>
References: <20200622150534.27482-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0115.apcprd03.prod.outlook.com
 (2603:1096:4:91::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0115.apcprd03.prod.outlook.com (2603:1096:4:91::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend Transport; Mon, 22 Jun 2020 15:06:09 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fbc3d6ef-82da-4c2b-1e5a-08d816bdcda9
X-MS-TrafficTypeDiagnostic: AM0PR04MB4289:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB428959C69A3E1B48E7CED40ED2970@AM0PR04MB4289.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJtuEu1zVypAtjLaPOJDNWkOHs3Lm7pllcvw+gJpkqTHD0r5a3xH+1aEQN/3AUbPxvdVO+yw9sItxcNWnlRUAnkNfUcOj6jeQFcOSVpVkphx0Y9lUTL52+nd4SksRoGfPOHRMt+qugBe+u0/zx4CRNsym0JxolOwPG3KQGyE5tsoanAIxMZL4z8eV1HsFwiAYd4EbAlOnB36V6r0qHFHlkXi1t8vxbNis/puWFnjr2A/LikY2mVJbYMt/dGRtNqH4FoZEp1ylCMOsf6GLxKBspEDMbrE9RIkv9mz/gNpqR7rmKAILRTsUSeZXmgev8HhJrwwcDMPK+hNQVglidPJpBT9jNYJINSjuvusZyvEx9A1QWDg3nmjrzLXH4x35T/w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(6506007)(478600001)(26005)(16526019)(52116002)(186003)(55236004)(316002)(8936002)(2616005)(1076003)(5660300002)(110136005)(66476007)(44832011)(66556008)(6636002)(6512007)(2906002)(66946007)(6666004)(6486002)(86362001)(4326008)(83380400001)(956004)(8676002)(1006002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LPUxFiWm3MT7TjIQrxvLI/Mp3PB43YT6HRt/Qk3JwuU8fBIWOHzLQid5s6KummXGHWbnoZ3yiRfnG1CwS/MjB1ioLpHC6aP8hJZMB8WTO/TnOrdfqkj1RipTLAtNzG7/crjrj4cBHgA69QqCVGAE8kKGjYLpNJrXi+BmCkXWqmHcnwVZh6Qm3cAGjG4y/Gu+UfoQ0vtOGWaKcZG7dNB3lXtyYtTTuRrQJk4aetiLnYcrc0GG7mf/l2DGzwYokg+TY9yWxOt9YbP7eB6eKXMGJh+40YZ83ZvGdYulIbPAWo8WljW56mNFf064BBI2ps6nI8giS2T05FvhtYRLI4Xbhb4BHrUV2ymDbce/YNw1eiJAQk+nzkIUIOFTVBPJXzDYzAHwvd3ZIdezvxXb8ptcKSQZYCN0HWjoRR1+ckLo12d/IxX3DJwu8ioLH+0WrLvq/lkkLhWT9Q4ukbD6G67pulNLdN2YduarKxTjpnPEILZE+x4ZzbR9x7FHReWlfBN7
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc3d6ef-82da-4c2b-1e5a-08d816bdcda9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 15:06:13.0596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 80rixbNKmvcc83kiat4ynmDdMNFPZit9ZMFthQadbyeNYFPYyySzl/AdA4sinFJ3LBiKlsyfA6zz87C8xmuFng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4289
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ACPI support for xgmac MDIO bus registration while maintaining
the existing DT support.

The function mdiobus_register() inside of_mdiobus_register(), brings
up all the PHYs on the mdio bus and attach them to the bus.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v3: None
Changes in v2:
- bus->id: change to appropriate printk format specifier
- clean up xgmac_acpi_match
- clariy platform_get_resource() usage with comments

 drivers/net/ethernet/freescale/xgmac_mdio.c | 32 ++++++++++++++-------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index c82c85ef5fb3..b4ed5f837975 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -245,14 +245,19 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct mii_bus *bus;
-	struct resource res;
+	struct resource *res;
 	struct mdio_fsl_priv *priv;
 	int ret;
 
-	ret = of_address_to_resource(np, 0, &res);
-	if (ret) {
+	/* In DPAA-1, MDIO is one of the many FMan sub-devices. The FMan
+	 * defines a register space that spans a large area, covering all the
+	 * subdevice areas. Therefore, MDIO cannot claim exclusive access to
+	 * this register area.
+	 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
 		dev_err(&pdev->dev, "could not obtain address\n");
-		return ret;
+		return -EINVAL;
 	}
 
 	bus = mdiobus_alloc_size(sizeof(struct mdio_fsl_priv));
@@ -263,21 +268,21 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->read = xgmac_mdio_read;
 	bus->write = xgmac_mdio_write;
 	bus->parent = &pdev->dev;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res.start);
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res->start);
 
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
@@ -320,10 +325,17 @@ static const struct of_device_id xgmac_mdio_match[] = {
 };
 MODULE_DEVICE_TABLE(of, xgmac_mdio_match);
 
+static const struct acpi_device_id xgmac_acpi_match[] = {
+	{ "NXP0006" },
+	{ }
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

