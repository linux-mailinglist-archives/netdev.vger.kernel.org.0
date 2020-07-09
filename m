Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7396121A669
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgGIR6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:58:07 -0400
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:27872
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728442AbgGIR6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 13:58:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pz62C+sX0GKUKhRvdY4+51GVQLhLhLc9/0Ceq/w5cTao+/kA69XIZ5Y2FKURKTGXA90+5+QUWZHWt7pDTB7UMuoUAQ7xhXK5by1SuumghSgeas8Z1+lP/oxjZqAGp6pmiMnnXlZ9ioRPw3a1r6Gg7u6dzOpdKbb8AaLt+6dSUnzgr8JKBB8DJ7QYwVmcf5xZ0Oc/ixwYAXSy+GTZ+Qv3aOkBycihFs+pes3Sx22QPZWCUy/ixXBNHg5chzWUe/GQXdZxfiqlhwJhHvk95D6aOl9eYLqOwTz2Rpl21cFd41Y8ZARZvuRLJyytH6O54v0P5CDuP8HRAK1wobk0ByLVQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75s6VZEwt82miux0ZDgs13j2jIZivF+xUAmUbIHZQKE=;
 b=CAPv9RYewxhHQQeVeaLtYJyTf9vik2cFDe0YK1CPBdHrWoBp66prrX4ITzw1ZI6yrpAmQeBOo5bJF3dq85MmFDN+9S8dkow1JtJjqp/zaMfxfFUb2aAEJCIVjxWF/eqSoSyjZvLxZUh8Mb7h5ZIpSRBY9OAuDrRs9PMXVRu4gT5Ivv9KzJFD4oRjzQ+dizLhcO1/kDEGVceCAsPpYlFKzp9waUWyHMvt+kRSNVlvoKji+fHpzGn8liZSslUOB0C5wQR/7vR3rSIe2t+mDu8NHnltVPdLYpL2Ba+WPKUU92lX1icSgdxozj7KXpAkrL7s2iVCSyFRF6de5DiSDbhhGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75s6VZEwt82miux0ZDgs13j2jIZivF+xUAmUbIHZQKE=;
 b=jmgPFLSr8aJxT0goe7U81MaJ3e+sMDxMSQQLZr2bmqON4f14wccnVRPWlbrR88MVBloazUqUHaItrfwTYuRaI/ajWcIDanfJoCUt+LxCjVNuU1eSzwY31xOObmO9siao54M/qdXyjtSkmUpKRb7KceafMKGrmVFmF/a5SVHTcl4=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6898.eurprd04.prod.outlook.com (2603:10a6:208:185::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 17:57:54 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 17:57:54 +0000
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
Cc:     linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v4 3/6] net/fsl: use device_mdiobus_register()
Date:   Thu,  9 Jul 2020 23:27:19 +0530
Message-Id: <20200709175722.5228-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
References: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Thu, 9 Jul 2020 17:57:51 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1b9f1e5f-dd6f-4eae-3498-08d824319ae3
X-MS-TrafficTypeDiagnostic: AM0PR04MB6898:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6898452285A92EEFCE076691D2640@AM0PR04MB6898.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3B74TNaQNKsbElVj5LkO/wrUNluwuIdDuM7wgiyvxsblEk8V/FJpK0rZDfans58aLBH0ascl3UR4I0kt6jsckkYgl5KrpjuN96u7Do3a4pEB4vHMbGfgcNZ8AMBvFeDoHEOJMKtfOOCp3x6vy9pEAHxgNS+K1DMvPDmESBa+wWVGO+H2CYc/Ihy6ifB2dRd9v2kY+OvFa6q2ZvJ1pRSTIJRUAoUJWhlamYF+HDihpnsR171SIxsuJPn2RMG0WAHVTYuaASY/QekGY92z1kWUrPjNBpYSMuzWjFWKJL2O4Y9fdtMWu6oXBZ8N1jJBd9oAHwDAZ1slCftmKNedHTN0nJfV3sdWpqDgc3Rk2R9gToiDy0RmexjhFn4ZsM2Oh91d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(83380400001)(6666004)(44832011)(1006002)(8936002)(2906002)(52116002)(2616005)(956004)(110136005)(4326008)(316002)(6512007)(66476007)(8676002)(66946007)(86362001)(66556008)(6636002)(16526019)(26005)(5660300002)(478600001)(55236004)(6506007)(6486002)(186003)(1076003)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yXY1U+0OPEEx9suNvJyi9f5Y1j/wNlHQBJpuLA8T9kzMzsS/F06a8Pz54e77dRVasCh6/esS9y+fwADDSTQP5YYOm0ZESdEcu001JgkD3qAHh0cFvEREmsBMbKQpnpMp/mdBt9YafBB6bCQzr96T0bOik8iK0cZpy15usCARpsELuuDSDcR+s7sEDkE5eNbMv1Hnj5dnLztqsd3A5qjLeU6DJdsb333J1eK5bIR9v3I5NAj4Vg5zEV28vLEVAYgmU6XTNoAAT17fTd7FU36jRbYKpU3VGWzM72h2C+5SgmjXwLlt9uqQtdjCZweP7NTyaShPgOc70U4ULEMGC6PjyP0NL/eZUn29LqFnovypbip+I5kUOuE9BOxiDoUwmK4CdkiFgIjGQuPaAjJzvyuVdpF9TMbuKFLSGvmaUAF4XOR7sj+yPeTyT4jvrEMkPgBc3u2jjTUjvZq3bD1nHDxyMPzZP8ZowQ36VEXSgbkmCCE=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b9f1e5f-dd6f-4eae-3498-08d824319ae3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 17:57:54.7581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TMTbWTqrWUKH/6y/uKHtdHCwvWQMr68ddDOqT4ZeqhAsi7XdYXgtpDaWRsxGsbFcMRkCPFgJMBoPcxwMLgHCnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6898
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace of_mdiobus_register() with device_mdiobus_register()
to take care of both DT and ACPI mdiobus_register.

Remove unused device_node pointer.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/ethernet/freescale/xgmac_mdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 98be51d8b08c..51a77a29c563 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -243,7 +243,6 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 
 static int xgmac_mdio_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
 	struct mii_bus *bus;
 	struct resource *res;
 	struct mdio_fsl_priv *priv;
@@ -285,7 +284,7 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
-	ret = of_mdiobus_register(bus, np);
+	ret = device_mdiobus_register(bus, &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
 		goto err_registration;
-- 
2.17.1

