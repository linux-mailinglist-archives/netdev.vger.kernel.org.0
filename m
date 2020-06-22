Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D789E2031F3
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 10:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgFVIU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 04:20:28 -0400
Received: from mail-eopbgr150080.outbound.protection.outlook.com ([40.107.15.80]:20382
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbgFVIUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 04:20:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JY51wWo7tNVX5Vd4iDR7gsSDFxq2Y/hJcLQNfZCExvm5PiiqJ+HtWTWxIcV9mhCtwMGPZwlO9rn91167YvhRi9MLcxW6TnQ16e0qThN/mmpAePdsUHzgJmulM99TlW2gu1nY4kVnNgt8eXyFVEQHvkKI4GetbWqANgJQoiypGNRSHYH0tqRaAIJTYEEkSEopt4mvJpo+IeG+QJuWpK09cQMLnBH81o9WQhiCE97tcHyysM+A6FfpeXaAVI9yBd0l8txpsUCz/Bmd/WfwR7dsOcJWeht0nIV0UDTPHoEbaPQQvDhN7Hbo/0qrP6uUA3uS62CNW9EzgpViNy5xeY02cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nqkj8z9vnsiiY7xfNgYf/V3BsOgQ1hccG66Sf11GUlA=;
 b=M3vaH1h9DwuMzCOTQJBt9bg/qbvxsBhA14wiRfzlSQWc3w/Fj+bhBSsHUhFGOKwSFzYAb3jWsaqVxcfezj898bzGwZLIHX0CTUZSFx+FfpBq9Q5UEmVhf1Lxrvg9FRPdCBrDvtu/2eYMC8O8zI48+cuTKo/lIgZtwiIpkF2UmZokREE2MvKYJ3us7CifBv0cnVoWzWgakVahODG9EMcJwpyTaQCQNUuXUl0sSSk2MhCc4cXmtsnMUuX1bnuJFoW5vlXX26uccpGJlVHArI8RV4z69NcQLjDA1Ojn9QmBhHAKe5+Aiowrx0eOyTZ3WjXy68E60qu3O9jnF9z352LBQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nqkj8z9vnsiiY7xfNgYf/V3BsOgQ1hccG66Sf11GUlA=;
 b=WRgEpHx7b6WDOz9d4XWXTsw92ydl2jlmcZHsSQa4e/pujC3zDW7r3DH9Th73yLdkfUEiabO1oZn0Z6EAcKtY6Xfm/I9o1EecfjMxfEj0dMOQPbt0L2z0gzLp419BL8Dn79eyrGDCvRTB8d55VxIKGNe/B/WY9qCxkgWQBQIU/S0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6401.eurprd04.prod.outlook.com (2603:10a6:208:172::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 08:20:22 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 08:20:22 +0000
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
Cc:     linux.cj@gmail.com, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v2 2/3] net/fsl: acpize xgmac_mdio
Date:   Mon, 22 Jun 2020 13:49:13 +0530
Message-Id: <20200622081914.2807-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622081914.2807-1-calvin.johnson@oss.nxp.com>
References: <20200622081914.2807-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0220.apcprd06.prod.outlook.com
 (2603:1096:4:68::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0220.apcprd06.prod.outlook.com (2603:1096:4:68::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23 via Frontend Transport; Mon, 22 Jun 2020 08:20:18 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 996bf938-5a1c-48d2-88f6-08d816851b50
X-MS-TrafficTypeDiagnostic: AM0PR04MB6401:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB64014D645E408FE62B85CA91D2970@AM0PR04MB6401.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0LBV/msdQSizXOqfbXciwrPtOnKaqmVB4K3El5bNq9dDJ/BmfLfiy4jg55tfX9uhegml0PdHvx6fks6f/8rHhdxZOYP505Gi1OZb7YvmbJqsM0a0pHxDyxRv47qc7LL+5fukA0RfCZVEFuJ5kLCrbVmYwGTbbDWcqDgwKyEc2pAHvOw/Rk7MN8j8HWK2PL467bC5ubOtXIKq5JFcjIEefa8obdQ5aXj/PH2VCBsUAalMxVf+EC4Mhmfl6az+dfU3hnbjyDaDnsuq/s45OrzbRHiFFAckYUxebdUtIi7DjHujcOaEmDdrI1cuhSMfLxauecZnRP5qNs/oTQOOEujgNMddjIwnSfgQ9t5Sz1cCHDtTqduSbPbf0srRdE8Qq6RP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(2906002)(6512007)(66556008)(110136005)(1076003)(5660300002)(44832011)(66946007)(66476007)(83380400001)(6486002)(4326008)(86362001)(8676002)(956004)(6666004)(1006002)(316002)(26005)(16526019)(52116002)(55236004)(186003)(6506007)(6636002)(478600001)(8936002)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mN+6r/nUMBLKN0ks8tni2BLl9qS/ZQ0cAH276m1j5Lp89EwpQmfmJyqtGNVd8PNm6e6DZAaEPByhJDeSGa3fh2RJlS7bwMdOEOt/+GyoVbxBT85RgcrWt/I1plhWU/IiNvqrS3KlNgF0FFX7Dih2dO0M+13m9SqpnGkV4veyd2pi+LYOMc0KiZayXQ3W8PytktRgBJWYfRdYXYJ9VeLX6oY9624K3dSyCPzK91U3vuabjdi+hp7ax4Ch3DOMroWAwQFnhim+xmZb1BniMYSo47oK164jMB0ZeNP5ootsVDWADl/N3FM4nyoKYGNXihjyT28Le3xUDqPmp0pobU8dZ3QnOGj3koas8a482W72StZ0HyzX7J9EzjawesmCbGFMiOB4vOcD88uOR/s8k6LZ2KL9Aal9uTlKHY8M0UVEleWEu1uf5fnU3yFdERZ5EAFTMynG7eUYg4w6RgAFKBqfP5GnrXXVjE6b5mZUQ7zFj4xadqu9FtJ2P/831/fwWj7b
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 996bf938-5a1c-48d2-88f6-08d816851b50
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 08:20:22.0427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oahkn1aUkImxphjA/c0GDs9pRoSWpf1f0+HRfjfPdzwid9zfg+Gl+1+R+l2u0UCpaQtuC7B4C3XiLWEkxzwwIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6401
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

