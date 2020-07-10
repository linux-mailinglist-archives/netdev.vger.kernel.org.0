Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC56E21BB01
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgGJQcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:32:01 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:61635
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728339AbgGJQb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 12:31:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaXTKWSCwWlNqOz12LbkiVl+uV3gmfQMMJvSEKLwP3niOvjdCtAOk3t4Ikj6bPe5dXQvpy84WQEwtlQDt32Klh6AZsWZdlDMnzk3q3Ef2uPVsT0jBSfjlbFC4drhROPkI9U/uflJVQJg+eMxBfi/XhtlSnQ349k7VxaZUwA9c4KnUTLA2gK2mnNzMbeYaGGks2Gu9F0AhuqKULs/uX0GTKnzo3wyTeBZE1AEmMnEhqYuszvfy0KUsOCWPI/ZyU2ANZeLofsu+CeA6pELWNugHKnsncRox+3mDCFaEPWuhzoR1OI1bq8tuEyLaDkhb9r+nEKEtVmX6Qo5SYkLUc1xHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lr0w6vAVKJ8tSVDykP9arTecbJqmiA5fXMFZT9aXetM=;
 b=lA+wErUGsD0NbC++JPsDvwtmNBJJgQDJndtkCST+ZxfC+kg+st54a5AmD9e1eZ0UhbeVNK9FmjSYs+zDhHS7DX8+9PiKqH1sp9Jiawf0zOg8ye8qMO4G6F6haLan86eJ8OGCIXTlFlpUdfGndYYPV458/Y3htaDgFqWaeFFkw46av+te1T9X3IIdTDw1YASxroZbsj9q+ENy+o24CGO0kZJApd/dd5L2jRC4bJT8D6hr3X+8dt6QWAtCCDMOnhX+136nbbUsu/nkBcezH9Djh3WsdwUCx8nrWQIAczQwuOjct7EqxtR+2Nxo+cZLcjM3ib0JTxENyfiPFo76YrnrWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lr0w6vAVKJ8tSVDykP9arTecbJqmiA5fXMFZT9aXetM=;
 b=SukknYOOC+noKpUbehUoXlFNMFF5+fPzqkN/5pNo6ddZC4QtUTnLjQbqMd2lEN3wFmwcoL3ctVqJOswxU48HTb0Qrf/LOtp9itnOCApK0Csq2fdGUzpcwssSoXoCy8muIcuX1zJ898gnBPV8U3IsmxV6OV7zCRUtSVpI1dqsAdc=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3908.eurprd04.prod.outlook.com (2603:10a6:208:f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 16:31:55 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 16:31:55 +0000
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
Subject: [net-next PATCH v5 3/6] net/fsl: use device_mdiobus_register()
Date:   Fri, 10 Jul 2020 22:01:12 +0530
Message-Id: <20200710163115.2740-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
References: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0137.apcprd06.prod.outlook.com
 (2603:1096:1:1f::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0137.apcprd06.prod.outlook.com (2603:1096:1:1f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 16:31:51 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5b405f2a-e6bf-494a-b79b-08d824eec1e2
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3908:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3908852FC6B1FEEB1901FF10D2650@AM0PR0402MB3908.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZreKNnWeoYfcKL79Ot7V5JIed0l3OOi0aZxv42mLEmp64uDLFKoDMfClcSCckLxHVz6y3E6mHKKDSotH9Kf5nO3+pHlczxUpHmGHKTkXX1D8d6CZH7o8E3X2KrBmx7fvmysm9WPVYUNJaQTwdaQfkBJEWRQLo0aA5221kiNScS+qHFDP8YBEv47JRR5rj+RQBIZxoKsdbd1I3khyn3gdaxHm/cH/BA2gJhdHEC0R/5Zwo9bo+JIHQEYVjHjQpspexnOhlShUpMOWzZuhtVMYK7lWC9EoHpk6W9+7zfFj2iBQ0u7SIVMovNK3zwQuxZ0Stvp/pIKrPEtzLQN7KWVu58CWZ9Tx9fmHccIxAdpQ3wCmYy12vMC/Q4U9Mz/3n95
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(4326008)(8676002)(2906002)(8936002)(86362001)(26005)(6512007)(52116002)(83380400001)(1076003)(6486002)(316002)(16526019)(110136005)(1006002)(66476007)(66556008)(6666004)(478600001)(956004)(66946007)(44832011)(5660300002)(186003)(6506007)(6636002)(55236004)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NKNzBxAvGq0vtUnE+7MtcmQoAuji1Z/uIV96RRxhqxOd4hObA/6JeZo424KDwb1bl852LRGcvzy58rmrfr6L5E7jUCZjxnEX6sDA4WVWv4yG/njpjdVbQkvZwSxt0Femm3H/HkMCj3VI7lSbEL17OWgh6HNcCkXcVeBaEUH99F+rLkBYR6gjISfnKSEIvl8HOPy629659HcGBnPvhKZ2ZMe4HySs7mZs94TtsHjLW5o59TrQ7g7q0Erv//m3k56evcYocnrYeviWoB4lN2fIDRo9wIHFdHSU26LaHUzAHu+omcQXENwGmWzRzkCcjL/bkUPxhrTwAJqrSpKGBjAWkZEn914QiUAz9m+HYmNb3uIYojqo+KD/9hIen/AfSvwb+/hzOBwBgqHj7lTebyop4mT7HzX1OP7LbOFsBrt7UWTt5m8m+4/4oziv3Er2VOoog/kpitNKxJniL3VwM8jZ1G3Kvwlheqa3knIUjecl5T4PTbckxDObHp3dfbQ6+KuF
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b405f2a-e6bf-494a-b79b-08d824eec1e2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 16:31:54.9670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vKVlm3GleWDqYsvW/Mg+tQkrsIXauM1O9+1J+zLmXglMVKHg6HLoHm4OJ+WUi76nCwnWHyl/ErppgFkNdUHRFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3908
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace of_mdiobus_register() with device_mdiobus_register()
to take care of both DT and ACPI mdiobus_register.

Remove unused device_node pointer.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v5: None
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

