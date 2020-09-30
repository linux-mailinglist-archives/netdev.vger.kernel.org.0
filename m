Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B56B27EE5F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbgI3QGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:06:37 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:11246
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725837AbgI3QGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:06:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpNWtlKm5v5payReNSIwqhgO0qeYjnzjmcfqNwDD27cUXMFxutDf8/Cu1BAd0GvcX8u1MaAYTfjIdxWj/SV8Y/+MEX7CamoCy7mGb2wPTS2vIdnw6MjKvlEQcBGX0ijq/BIxMUQFF4NPTj6ZOqp4deIrfarxa7VRFQeK1hkWIBURsBpiW8BKO1r0O8Jyw8YFmdNp1EjZdVvtW4aA0F4UBiBJJJVWA3zK/C3BhaAaYU476QR84dBU+n6gpvSSXVKxmVEBLQ01p8BHGsQe66ZfMel1Ws0tZpLcBwS8WCi/649fPcTCqV6BXMdM5nc652EE+BwUnUJL1vzoPb+OWv5BPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcw4Olba4XlQcbHT3A0pSm4t3j7bkW95YCFrAvkECx8=;
 b=V2t+Tz+2dKnDjQJfNMm+ftTJvwsQr+bahZeT0oAG0+ugkq7lyVAbwrfdPltyV0n5q8hu8I0OGqfCQWNB/JT5//54nL0RFayR27UNs9007d32j+718IX7Fo7hBmROOlHQhF+YG99ra9HW+8QqhFkluI/1i3MSZ4Blst5rUPsEg8EED6uU3el8bUyU87FHE7feiEN+i05hIOF2Mad6gBG9LE4FDzxorNUPV1+d1n+hV5+FZwW3jyhdRFvK3shbbeXqzRMtSFCNi3FKqztfTyYIQwVvQ174Ob0xItT91nOTOemccMkywUiAb2GMHesQrI8aXizp15nwwFFU7jLLH2BPSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcw4Olba4XlQcbHT3A0pSm4t3j7bkW95YCFrAvkECx8=;
 b=dx/OQS5gRJCBs8B0uxtz/0TlbnszLoaBPVuriIoSXNpZigjs4w1N3BsDMPmVjygPtKrB0wnewLOatl+FwyfH4KuIbZczuuQUZMysstmH1t88PcnGwuKvhZ+dB3Z6MJHUJherl27uwgLXuaJJdtycOWOHrc2b3kkNsGq0SSlmlDU=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4225.eurprd04.prod.outlook.com (2603:10a6:208:59::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Wed, 30 Sep
 2020 16:06:08 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 16:06:08 +0000
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
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v1 7/7] net/fsl: Use _ADR ACPI object to register PHYs
Date:   Wed, 30 Sep 2020 21:34:30 +0530
Message-Id: <20200930160430.7908-8-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR03CA0168.apcprd03.prod.outlook.com
 (2603:1096:4:c9::23) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0168.apcprd03.prod.outlook.com (2603:1096:4:c9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.16 via Frontend Transport; Wed, 30 Sep 2020 16:06:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9cb46d27-7367-4d58-875a-08d8655abdfc
X-MS-TrafficTypeDiagnostic: AM0PR04MB4225:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4225113DB750974AC4B8BD2BD2330@AM0PR04MB4225.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xch5JSiI+Bph6bq1XjLsgkGmDeoBYyIK/3etOEFYHEV2ujLNtHM9BDvQeI0nYrNbyCwqBGZPPx7+ijNb9+dyXje33prQ+UrYfdT2m2EfUlVV+Em6WHuhK7bzLlg0NIel9Zx5d0LAVMlX/GwAaUpOqjIlQkaHYOaKoA6IpdxzOf/lbV9htE5DTTcy3T1qNfu1sealVExYZ7veox6cZoIPGNCKN/ZLjDjrTweX02pT2YnubCsRX6ZrSqc2d3vQcTCXfiHD3WsJBfqH3SCaXmSOE4kHW1y58VxkpxfKZK1rNfYunqDpCz6uukUUbnUd7AwBAPrCrdq2sy8HXPlLl81mZ5oJLDALPYYSzh/p4yTTJRFJYzN9f69LA6m8tJnayV1GpyZtrXK1z5CzQiDOZAc72oka5YWG/YWQ2IjjIsG38mzy8fnhNa5BN1xyFMjXe9Mp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(2906002)(8676002)(1076003)(26005)(4326008)(54906003)(6506007)(316002)(478600001)(8936002)(6512007)(55236004)(86362001)(66556008)(66476007)(5660300002)(956004)(52116002)(44832011)(1006002)(6666004)(110136005)(7416002)(2616005)(66946007)(83380400001)(186003)(16526019)(6486002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TakG4wmKmqRn6nPhL5CNMV83dyvD3l5ABM/vmSB7twjjs4rtBcrtP76MCQ14dZY01u0sp/bwrYt4QSkY+Bn5jLdWoNROfeDLRrfn6lSBNQcz31iPF6vvX1yKlECoBlJI1eY0egCXEgmr6+SbkOiiwPNMHgE1RWfjk3sQP1G31lL5ghUSd9IDHFcH/trmqek+g6R/3sV2iNsR7+EKzkpJVXe6HiwChr9G5IcEkk3wyElzdSNYcC5OMVlHaeJ9ju3Ek8MYrYbxMj5S/a34loqQK6R/YBMG7ymhcujgfQbKqBR5IZmoGVQvDJVuAR8pEHXpEWWuqUHdHcq4hQmt+X4JaeLwkFP1h9ICpGInLXdopJuspD+flAcfpqUwYxAs4XHabv2+r8S0FURVBpIheW3MfV0rRbfbPKhdZmbo6axZD1OpWEEz34tgDwDVG4pPM542HJVuvQlJj536iRgzbs8kA97OurDUyMeRJGjT0Q2TUGcDQ6xI09yWJlQy5vz/ioTRga2ZttTJyjTRxoEKpswW7oB5xFjDnE625MukKNDj9xMmRnXemlDP3nzMVwmz/ofq/Iryp3ej+c9XollLejWh40msPzDN9s+lIFXehof+fOB3zn/IHracX49VP/i6JYCfrdvE3pH03kWyM99qe4aT/g==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cb46d27-7367-4d58-875a-08d8655abdfc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 16:06:08.3889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPV+8aPcgUhp4Q4JO83vBlhBlONpDMyYxkedBiQVmRbnt0YqS5zxdOfPEH34VAP/hek7FbARdXmy10r3JIU28Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4225
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHYs on an mdio bus has address which can be obtained from ACPI
DSDT table using the _ADR object.

DSDT Eg: PHYs connected to MDI0 bus.
-------------------------
Scope(\_SB.MDI0)
{
  Device(PHY1) {
    Name (_ADR, 0x1)
  } // end of PHY1

  Device(PHY2) {
    Name (_ADR, 0x2)
  } // end of PHY2
} // end of MDI0
-------------------------

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/net/ethernet/freescale/xgmac_mdio.c | 48 +++++++++++++++++++--
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 98be51d8b08c..fb272564855e 100644
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
@@ -248,6 +250,10 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct mdio_fsl_priv *priv;
 	int ret;
+	struct fwnode_handle *fwnode;
+	struct fwnode_handle *child;
+	unsigned long long addr;
+	acpi_status status;
 
 	/* In DPAA-1, MDIO is one of the many FMan sub-devices. The FMan
 	 * defines a register space that spans a large area, covering all the
@@ -284,10 +290,44 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
-
-	ret = of_mdiobus_register(bus, np);
-	if (ret) {
-		dev_err(&pdev->dev, "cannot register MDIO bus\n");
+	if (is_of_node(pdev->dev.fwnode)) {
+		ret = of_mdiobus_register(bus, np);
+		if (ret) {
+			dev_err(&pdev->dev, "cannot register MDIO bus\n");
+			goto err_registration;
+		}
+	} else if (is_acpi_node(pdev->dev.fwnode)) {
+		priv->is_little_endian = true;
+		/* Mask out all PHYs from auto probing. */
+		bus->phy_mask = ~0;
+		ret = mdiobus_register(bus);
+		if (ret) {
+			dev_err(&pdev->dev, "mdiobus register err(%d)\n", ret);
+			return ret;
+		}
+
+		fwnode = pdev->dev.fwnode;
+	/* Loop over the child nodes and register a phy_device for each PHY */
+		fwnode_for_each_child_node(fwnode, child) {
+			status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(child),
+						       "_ADR", NULL, &addr);
+			if (ACPI_FAILURE(status)) {
+				pr_debug("_ADR returned %d\n", status);
+				continue;
+			}
+
+			if (addr < 0 || addr >= PHY_MAX_ADDR)
+				continue;
+
+			ret = fwnode_mdiobus_register_phy(bus, child, addr);
+			if (ret == -ENODEV)
+				dev_err(&bus->dev,
+					"MDIO device at address %lld is missing.\n",
+					addr);
+		}
+	} else {
+		dev_err(&pdev->dev, "Cannot get cfg data from DT or ACPI\n");
+		ret = -ENXIO;
 		goto err_registration;
 	}
 
-- 
2.17.1

