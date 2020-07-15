Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384DE22081B
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbgGOJEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:04:45 -0400
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:28226
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730370AbgGOJEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 05:04:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bc49v4TMAMNiY66kbb+iLAwCeuImlPumQW61+0yvEDoia1h6HfDEl67qDX1Jig8x0Fpq2wlPZ82iMY8OU5joZtlW8DroGYaC2RMDE2yqKKevEfaAX95IhI9qlfgpcCKIusuif486rBccrUxn0IJ0kv8bpitUW3C6VBpV4NOkaPpK/6m/Qatk1JrLKwK+RfHMsw9oZREdOMAIvSSazFUO8IjT9G0BFMow3Soo8ClgOyhh0GWfepn1YWeiiIsBrB9pqS+35wV/6PD+tErGJ8xhDGfhnB9NETGCZppOj8VR4YFIm13lrMzHCHxrffVALiWKiEMcXMyoyd/DXoVuUd22eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1viDoyHHBQierD0TQySliftKgcLbKdXUmBXhtUvd9o=;
 b=V/CCpQmF1cWpuMOpPGxwQf8PmW06BKwuklOViH0WesbYR0dPL9pFkY9XfmnmHFqHL3fnPO2ypGpOaWp/864/uGcuUXkxLPF8VR9QmstA2JiRr8vCODLtTwmw09IaqaL7RywqPl+W3WU6dRZg5rW7ezvMHMqnJi9wNt9atPWX0MWi51Ej+zWyUXavsS8C99Ny2uAptsUbedKcdqn3rJJs4E0FTDXwMs31uI+pefe/I8jV0ruoLxrwGuDmc6C4yoyRG6g1TUmbM8JYSsA81dLIP5fGmbibQWV5A0UacDtgp6XqnjPy1J3tu1QzJ7fWgtVzMKOa+NUZTkBJX2wT9dsqdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1viDoyHHBQierD0TQySliftKgcLbKdXUmBXhtUvd9o=;
 b=WmlUZOtFOkDNG6MtY2Jl6HZVAKlFJTonxvOj4mydT2VO0UuSqFC9LbbcC+m+lwwNQHvSdcQyClPdCxTuFCRE8faSjYlTCDO9HWNFATeTkNue52APQ0J3X8DAEhiw/KHJrZbh42DJZe5fau4heH8I2OHxThNUMbkxZ3RS3Uq5r0A=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3763.eurprd04.prod.outlook.com (2603:10a6:208:e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Wed, 15 Jul
 2020 09:04:41 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 09:04:41 +0000
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
Subject: [net-next PATCH v7 3/6] net/fsl: use device_mdiobus_register()
Date:   Wed, 15 Jul 2020 14:33:57 +0530
Message-Id: <20200715090400.4733-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0070.apcprd02.prod.outlook.com
 (2603:1096:4:54::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0070.apcprd02.prod.outlook.com (2603:1096:4:54::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Wed, 15 Jul 2020 09:04:38 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f6b36dfb-32dd-47cb-e623-08d8289e1bf1
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3763:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB376369FC7A67F6401F677FBFD27E0@AM0PR0402MB3763.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxp5pWqddGXQ8ARqWmgSjv4n+Yi7+Wyk/dx4Cuxy6SCrTw9zWzXlqkdVT3a49I4y0eAK8bYG7ZsOdItvXQeNsWwXfLZ9jrrB1UcyObeVtvmqnkUsLJMb3HWyIaurwM4YEKtZ7efSudWHz+a8jm4VbVU+ilEkrZwgmY2awXLTwERvMT5CyfM7ZC3HA+VH8bsCMGT1jg106ug/ONotTSm/4W4P5YhwcKvvfNws01Xi87MrTCIleR1xTyKT809Ht9gjnTDluXcJ+GECJriNzHjA6HqZ35LaPODsRfT5KmbrImBeESKROsMImQU16y0mxAT/V9GoCFS/2ir4XJ9VdTTjOi2gdff3LGZ6l1v09/Y0OODVtJXJoQRZiBE5ac41zV9Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(5660300002)(110136005)(2906002)(6512007)(66946007)(6666004)(66476007)(86362001)(1006002)(4326008)(66556008)(52116002)(44832011)(316002)(956004)(83380400001)(26005)(6486002)(2616005)(6636002)(6506007)(55236004)(1076003)(186003)(16526019)(8676002)(8936002)(478600001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: INyn4coI+tks7/HQT9zoefLtZD9v7xM30pg2lVpZpaF0iUmUX34EAGaxxeelng1xNgYUmK/gPT+RtUmBRUKuyvUyhVx1/B6VwOsP+2gUbFMF/7Ha3ymEwfB2hex/0CAm2yagsx0TDhC5Jtb4pJbr+JnmNWEnjiWns344Ovkd2Es08a2FesJT+my9mvPTC7XFUEtMlr3aRaLI7brAfT7NSbyYgpLPoXNz+TgxJoF0Vxi3nQ8pmywLH8EcN8wpERe8KbKVz/L3YKQsddhr2bLgRhZesjotZYjcgIJq0D8wgr67olJU4dpUxQP3uOks4Wwu4+GT6pIEcVdeJFdSVK5aIzHVpgKDXNAGocWaqapY7Rd+I8dygGH0W9JPXD3W5IODDdU5yicmGz+X6ZA52JnbqFyammAX19nRjZCk9gXNCfRKMKRoJn82bS/ll6RK1+LN6Ln3K0SpzqGFKEqmrP0dtTf1tl9eZjkJhRxmILPQ2ZB5oCZU4Wt3ioye2UGucMbd
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b36dfb-32dd-47cb-e623-08d8289e1bf1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 09:04:41.3495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uACUj4AohJv8Y2n/ZSJTWuAhzLEAcRFTd1NmzUpj+Gdo90vaTHJQ2u1p4QDflOdbvVkvrm3yWAQPyB2xeJj5BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3763
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace of_mdiobus_register() with device_mdiobus_register()
to take care of both DT and ACPI mdiobus_register.

Remove unused device_node pointer.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v7: None
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

