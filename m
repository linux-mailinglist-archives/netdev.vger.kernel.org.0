Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D91D14EFAA
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgAaPfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:35:40 -0500
Received: from mail-eopbgr150083.outbound.protection.outlook.com ([40.107.15.83]:45391
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728922AbgAaPfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:35:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYRnHILs//BsgXJhjZrVH5jS7zkjdexj/aq+zWhyl9/PWik1bRGa7q7uJtbRk6G5dSUZ8cSrc6udCzebYpq/Lm2dx1UUD0Y2wdJ2z1t5r+pPjz6we/E6+tDudnv2Y7FRYHVlo2Zh7CvTDufWJaaWA/e/IEoP27DTIMdZZEQ0vEeIEiTWmKcQHYq6E0XK3Q6gRp9visW6ORG/QZo4kkoUbLSEHtzzPKkjddQrvJf/0SXdH16d579PUX3LkY8HPhCH/KqSLEfcbH6CbHIfPoFSYvpfE9sYzUdU2l1mslMCU81fPJDjfQdzEZNNB17MuzuIPQ+5fCGAc3u+aCQuLuYkUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z56JE6JNFh2GFkbTcOgPN2K5Dy61b+7ZhRnCIp8NWAc=;
 b=C5Wim+ke0z3/Y6HdZbh3Lw+HrOHW382t54GY5dCQ1CNKxPtjr8IZ5Cjz6jwsM7+4Gdxznk7/zk+Mxf31kUgZICSJOcVYtOfYaC6V6AQw8OT/8QUn4k3ylrBaSc2UTZmb7GHWrNShjsd+aedm8dLtGpV6225mn6XQAsiOVW7dAtJ35kdaPyakEADOXOdcudrJ0n7Y7FSYS7qOH+LcvfYF10oRQsVPXD2G5qyQUr2nDPswXj3Cfer7+BtU+XE8tK/BqaxZ7d5VPIVE0CFFnczqLn7W7nmZzvYo5CCt9sw+EnFDHjS5IXflNSBHK0Wcr9xKhhoJniXEaloSym4skVTH9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z56JE6JNFh2GFkbTcOgPN2K5Dy61b+7ZhRnCIp8NWAc=;
 b=oNIUJcNVSC4uuoKem046Ic8/1W3Rwsnzwte67ZPPIOfkyrOxYOpbbbeK+8zIfXW1Q3lCZEpuBB52omsTgUgmT+NXYhMQ+EE9EKAu81Py8w6C0UwNzKlQC9E47xFi/a88DhyP92ynawCt6dUofj3SnSkHJQkSyar11DJGZUJ+CYY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@nxp.com; 
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com (20.179.10.153) by
 DB8PR04MB6730.eurprd04.prod.outlook.com (20.179.249.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 31 Jan 2020 15:35:36 +0000
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef]) by DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef%2]) with mapi id 15.20.2686.025; Fri, 31 Jan 2020
 15:35:35 +0000
From:   Calvin Johnson <calvin.johnson@nxp.com>
To:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        linux@armlinux.org.uk, Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 3/7] net/fsl: add ACPI support for mdio bus
Date:   Fri, 31 Jan 2020 21:04:36 +0530
Message-Id: <20200131153440.20870-4-calvin.johnson@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131153440.20870-1-calvin.johnson@nxp.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB8PR04MB5643.eurprd04.prod.outlook.com
 (2603:10a6:10:aa::25)
MIME-Version: 1.0
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0061.apcprd02.prod.outlook.com (2603:1096:4:54::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend Transport; Fri, 31 Jan 2020 15:35:32 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b3a9169a-6a90-43fd-66bf-08d7a6633763
X-MS-TrafficTypeDiagnostic: DB8PR04MB6730:|DB8PR04MB6730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6730BACCDBDBB18A625EE3FF93070@DB8PR04MB6730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 029976C540
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(52116002)(7696005)(1006002)(66556008)(66476007)(2906002)(66946007)(8676002)(110136005)(55236004)(8936002)(26005)(81156014)(81166006)(316002)(478600001)(54906003)(1076003)(36756003)(6636002)(6486002)(186003)(16526019)(5660300002)(956004)(86362001)(44832011)(2616005)(4326008)(110426005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6730;H:DB8PR04MB5643.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62Iyc/4jQKaD27f5rkq+fc5+i+AJLG4fEEMqgTMJUiJGnvVB/dujbEvikizzSkpeHjeX4FQ4ABydl3ceNNEbj1kgj5bJc/i+V3PeO2TVVAufu3zE+IQvVmPXQHZjN6JwJoLEXxis+ewqHvHkp5FYToDEIG1nngcsn8RqTPajvy2w03V83xYFF+wIJqsB7X0HFD8aeIVNMIUmYf2zc/GKjqbqO+i+VsFZlMzz53gAP4JVt6tmZ4zVUaBVl8yj2l9c+wnbIK/O56zbkVt1Uqq+Q8itMTA5nPHWlSfTP2L0pNPD4ISxWZbbmjVUl1OwjbpFncBQt8vC2oS9VqzFQiBu4kjyRZB2ObtXTz/VvnONx7a4uMUOv6GH1W6lQJiXYCQ4JCRXbcR1/Wj9s5JjqZWqii3nMATJHA1hfdq+DllZ6SBGtfnSpTNIYcjYkOUQzS7j5JWTLhMpF+wXALX7L9BnvaZMTVMtO99uxYTAwDk3F1Bwj4K6rTlwar+fiZevMfazWfGxX+rN3C16xLB63HUrzXMbtFhQO7DIPY4fIjqjYqk=
X-MS-Exchange-AntiSpam-MessageData: 89k/oaVUsfYUGpaTD+qFFt0lL0IeleZbteO6Ugkgb6nNh6g+9tmbBZ4HKwLIcr+k3/tD0csbwabPgkCJsBOwuBj5ySST4S04tyRrFLqrMinS5/+N4XgtlieKInONtvCcPIOb2TWyfVoikCAfJUfG7A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a9169a-6a90-43fd-66bf-08d7a6633763
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 15:35:35.9287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJZqI+DgdaHJcgF1MHfQGJuLipfayZUq69myly1Jg6rRbysZcgodmkr/Ki5+t56Jwu4w1CvJ+ZN8zDJjw6JTww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Add ACPI support for MDIO bus registration while maintaining
the existing DT support.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/net/ethernet/freescale/xgmac_mdio.c | 63 ++++++++++++++-------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index c82c85ef5fb3..51db7482b3de 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -2,6 +2,7 @@
  * QorIQ 10G MDIO Controller
  *
  * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2019 NXP
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
@@ -245,14 +247,14 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
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
+		return -ENODEV;
 	}
 
 	bus = mdiobus_alloc_size(sizeof(struct mdio_fsl_priv));
@@ -263,25 +265,41 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->read = xgmac_mdio_read;
 	bus->write = xgmac_mdio_write;
 	bus->parent = &pdev->dev;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res.start);
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx",
+		 (unsigned long long)res->start);
 
 	/* Set the PHY base address */
 	priv = bus->priv;
-	priv->mdio_base = of_iomap(np, 0);
+	priv->mdio_base = devm_ioremap_resource(&pdev->dev, res);
 	if (!priv->mdio_base) {
 		ret = -ENOMEM;
 		goto err_ioremap;
 	}
 
-	priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
-						       "little-endian");
-
-	priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
-						  "fsl,erratum-a011043");
-
-	ret = of_mdiobus_register(bus, np);
-	if (ret) {
-		dev_err(&pdev->dev, "cannot register MDIO bus\n");
+	if (is_of_node(pdev->dev.fwnode)) {
+		priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
+							       "little-endian");
+
+		priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
+							  "fsl,erratum-a011043");
+
+		ret = of_mdiobus_register(bus, np);
+		if (ret) {
+			dev_err(&pdev->dev, "cannot register MDIO bus\n");
+			goto err_registration;
+		}
+	} else if (is_acpi_node(pdev->dev.fwnode)) {
+		priv->is_little_endian =
+			fwnode_property_read_bool(pdev->dev.fwnode,
+						  "little-endian");
+		ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
+		if (ret) {
+			dev_err(&pdev->dev, "cannot register MDIO bus\n");
+			goto err_registration;
+		}
+	} else {
+		dev_err(&pdev->dev, "Cannot get cfg data from DT or ACPI\n");
+		ret = -ENXIO;
 		goto err_registration;
 	}
 
@@ -290,8 +308,6 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	return 0;
 
 err_registration:
-	iounmap(priv->mdio_base);
-
 err_ioremap:
 	mdiobus_free(bus);
 
@@ -303,13 +319,12 @@ static int xgmac_mdio_remove(struct platform_device *pdev)
 	struct mii_bus *bus = platform_get_drvdata(pdev);
 
 	mdiobus_unregister(bus);
-	iounmap(bus->priv);
 	mdiobus_free(bus);
 
 	return 0;
 }
 
-static const struct of_device_id xgmac_mdio_match[] = {
+static const struct of_device_id xgmac_mdio_of_match[] = {
 	{
 		.compatible = "fsl,fman-xmdio",
 	},
@@ -318,12 +333,18 @@ static const struct of_device_id xgmac_mdio_match[] = {
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(of, xgmac_mdio_match);
+MODULE_DEVICE_TABLE(of, xgmac_mdio_of_match);
+
+static const struct acpi_device_id xgmac_mdio_acpi_match[] = {
+	{"NXP0006", 0}
+};
+MODULE_DEVICE_TABLE(acpi, xgmac_mdio_acpi_match);
 
 static struct platform_driver xgmac_mdio_driver = {
 	.driver = {
 		.name = "fsl-fman_xmdio",
-		.of_match_table = xgmac_mdio_match,
+		.of_match_table = xgmac_mdio_of_match,
+		.acpi_match_table = ACPI_PTR(xgmac_mdio_acpi_match),
 	},
 	.probe = xgmac_mdio_probe,
 	.remove = xgmac_mdio_remove,
-- 
2.17.1

