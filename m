Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F921C2EA
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 08:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgGKG4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 02:56:46 -0400
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:8821
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728197AbgGKG4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 02:56:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeY5zqLxiX3ujrSQlqDg0LKUZ+DCDSu/1mlb38jbd1f970H2fjtF2bZSXWQ3Es9cLgyLtqI0jFAHpAfvWs45SQP3/ht6qGBopFEc3BD85JEdhTI0xX8duRLNl88iysj3pcp5ByNQyx33fsXewMuo9CJzQAXMn6PrTfnkFXmqAKPQH15NAY5exUYbCI1shflZe5BGRwlAB9FBgIna7UEQ0H7G2TBA4AOZAbf6RZdJAwiI6x2KmTi9UihdR1p86IEm7A9VXO4qyxyq4Z8OlBDEwaIS8dJrcUaFj/WM0MccP8CVJvqnwGaGmgjoWNFejGBGx9a4+lkN31zUrI0fA7+sWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPPQW4Rp0PLYQkuqIMMhE8S1diTmD6CrXAKmGOpP81Y=;
 b=gg2HcYlyMyvP1pk2ZHc7ohn6XxaVDGzup4wNGBwG8kpn11InH5x3gCD1NIuAs8kclxuvUDSQKfMptZf8HTACeFf+0ztDjIQNIyHDLqoyddsB6ifN4oTag//lo0PGVryyCTmMoc4O/9QzxkyGCKXNGcBs52KPfSaGzu7PH/IfdUDB2RhYcxFBrrkW/bjSCqlaSELfpqClSTxevlxxu8+sKL7LOVrF0GHAMVMvlZCZZlVfudCA0UN6n7KW7baVslKscOLTQsKqAInePKEg/yEFOtjfINpFvnseMnHYXx8LiXVlrM0l3FFcI8ko0UEjbOfIeqyUWH56hWuJ9VDIo/ZffA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPPQW4Rp0PLYQkuqIMMhE8S1diTmD6CrXAKmGOpP81Y=;
 b=B5/SzBCGBO10ptmX0h9kkpXp/J0kRTYsNVk2aK1cJu5W84h/HoR9Df4ygLaponw/idKzb1+M30iclfBqpzAVFiL5EGSse3XMIkD+aRBSiXogJHpLI6NxNuToAStL3b1/G3VnrhA2B+VH1JlI3Ge1pzTLoNxmJtr+M44LfIIs934=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6961.eurprd04.prod.outlook.com (2603:10a6:208:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Sat, 11 Jul
 2020 06:56:43 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Sat, 11 Jul 2020
 06:56:43 +0000
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
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v6 3/6] net/fsl: use device_mdiobus_register()
Date:   Sat, 11 Jul 2020 12:25:57 +0530
Message-Id: <20200711065600.9448-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
References: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0132.apcprd06.prod.outlook.com
 (2603:1096:1:1d::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0132.apcprd06.prod.outlook.com (2603:1096:1:1d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Sat, 11 Jul 2020 06:56:39 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9576baf4-7f68-4ec8-fdba-08d8256791cc
X-MS-TrafficTypeDiagnostic: AM0PR04MB6961:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB69612E0DDCD8E4DC8F0106B4D2620@AM0PR04MB6961.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y8tDWugm+xMfYUfpMM2e+7trGA7EX8UmOZJ7qJ96rwz5/1I6VGubT02h47xlewYPGJfDeC2WzAAeRYb2YaDjBAOo79pEY06aXT6ckk5jcsLILOOzg9rxPnghsR+Ti47Ji409UKZwGUq6druNzYS56fOX7iUxreBDekUh8Ep9UYTHHpDu2HmsXI/eTb3zHsRO/cooQDL0QEt5Nz2gnMIcV0hP/Stfg0cfzPHo7Md0hEZXZX4faui623S+IKI3fO65hllbLTELFkEX8y2bvvRRwo44nyrv5rY3QKMKVkvgHgRCJKnudjCZXDNrYkN08uGXcsoXHgZvFD1eC5imSvLj0MCl/Xc3t7XJBpRIM7RTLYYI+OGFy8+fCLtkMLoypxbp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(26005)(6636002)(16526019)(186003)(110136005)(55236004)(66476007)(44832011)(6666004)(66946007)(66556008)(5660300002)(2616005)(8676002)(52116002)(1006002)(6512007)(316002)(6486002)(6506007)(956004)(1076003)(4326008)(2906002)(83380400001)(478600001)(8936002)(86362001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IRL0/fpmWMVl7v8PiQt9iBWnpOEYGFTIX2J64Fo744+o/PSLvJbDxMTnGoN/BSqpn6p7lJuMckSuEtpYS6ablYSvd0SSRtnrsJhjXOi0EaKPXJYL34kfBQGP+uwhrXyZX0y9686IlGYSmYG7abMFtSw5cWgmVU2702E3IKJ2K4t0D0kwJz7S6/F9ZOKmvnaTWMIk1yCEDT/bJhrjLhLr0PxoFb3yT6K6k4z4oiiaWVqh9kG0d9tgaPlBOhRjR/UU9NgPXeoPZucJCjV5LkeIpvUl2y5NPIwUBPiwXY0Ldb1z67diBnFYRzpQFktGMI3rWoGvASAgQ1TRiC/2+mPeLBkdaohw9S3PqAcOSfYa9BUj92hH9almPa3nTVsiVO0cEPZ3eiiMHaTs+6RNr3sFrUYgWHmAgsq2TeE6yoYHyucylLAAjWZ5Hk04jsdPjU6wyT59aCdhp/7g9HcU9fMhK9EfMebTotqVfSvIfG+EtMs=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9576baf4-7f68-4ec8-fdba-08d8256791cc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2020 06:56:43.3163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsTXRGRDlUwO9NeFkLbpDddsYaWctBtq/DHNVaOYM2OAJOXWHR0a2C2FSvqmbEucJPDzgOPjdaqVGdXfqsPoWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6961
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace of_mdiobus_register() with device_mdiobus_register()
to take care of both DT and ACPI mdiobus_register.

Remove unused device_node pointer.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v6:
- change device_mdiobus_register() parameter position

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/ethernet/freescale/xgmac_mdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 98be51d8b08c..704f2b166d0a 100644
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
+	ret = device_mdiobus_register(&pdev->dev, bus);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
 		goto err_registration;
-- 
2.17.1

