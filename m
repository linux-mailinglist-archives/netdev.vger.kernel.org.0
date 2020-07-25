Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B9622D81B
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 16:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgGYOZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 10:25:07 -0400
Received: from mail-eopbgr30079.outbound.protection.outlook.com ([40.107.3.79]:2415
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726944AbgGYOZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 10:25:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROKMZEBuS4KRRL4sLJE5VN1VL3o4vJgYmt0/4N6hsktFzDZBLwUiYmu98vIVftXc9Q5MCaMjRzHRrIX4RQh/fn+n66L6Py/kwMsa183dAWMksUL+yKSZmm21eZ6+fLJxpA6ShwmZY0IhfezP24YzVQFlK537qTSJfxtDs52qp9/Jd9PorI31imIP/w9lG3EmNwI0jn37wRzWwoyKdkf5oiZgrssgwdCajd6b4p6gESJDgI8e9xD8c9tEEno2veVKI4TYve2rH5WVsksxoh/RB9MjmyA2n8ZKT7jHTnrm7bKfEnRXPobcYIP7k/BoPExl7mFtSI13W3eLbx3ygs/+1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1viDoyHHBQierD0TQySliftKgcLbKdXUmBXhtUvd9o=;
 b=eXsNniSShyH4V/ozMifaOWWrwrRswn7EdLXPe2Q3Nl78U7CER3/rUw/cXu1OKAsplBtDxlg1sc0qG8w+5oomEA6j9vP5l85VG1lu/85hA7rokVED8w4bdoMQ7esmPBHeoUShEFRPkr1SYGnitNMLRiWwYRgMlT9B2WnjWe40/Jf7j4v8l9xJF7suFUiYy1mn0scDAbsQeGD/FfmhVzBuikY1Gxw7wPT4lkMqMmSaoY3BkG7101U8K8adcnRVczeFqGKy+SFJYweDu0XXoP2RjsjNrusbnbfeHst2uXggzTyxPiigfs9y+pHGPz8D72MEueFEimHyUdGsmmrJm99P3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1viDoyHHBQierD0TQySliftKgcLbKdXUmBXhtUvd9o=;
 b=ESXs7kC1blyPPwksuBsnMETG4LvVp4ukmr2wctrGkiCnEWGimsez/1Z82hKsrRstTHT7ySJ+9aucAZrAEmardm8p4y7SdmLnE+M2axzNuygdYkvr+vkNookNSrFqf4Uulq1ZxSGDkwd5xDvgPidRhmv0Hlu5fQUGuYnYEshMKs4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4931.eurprd04.prod.outlook.com (2603:10a6:208:c1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Sat, 25 Jul
 2020 14:25:02 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76%7]) with mapi id 15.20.3216.027; Sat, 25 Jul 2020
 14:25:02 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Al Stone <ahs3@redhat.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux.cj@gmail.com, Paul Yang <Paul.Yang@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v7 3/6] net/fsl: use device_mdiobus_register()
Date:   Sat, 25 Jul 2020 19:54:01 +0530
Message-Id: <20200725142404.30634-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
References: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0302CA0018.apcprd03.prod.outlook.com
 (2603:1096:3:2::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0302CA0018.apcprd03.prod.outlook.com (2603:1096:3:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Sat, 25 Jul 2020 14:24:57 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 59290318-d538-4254-e2f4-08d830a6849f
X-MS-TrafficTypeDiagnostic: AM0PR04MB4931:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4931CA68A16C7CDD1F5084B1D2740@AM0PR04MB4931.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: obOAs9Omm/laDZ/TRxBtVYPG8TCOZyUwKGPJBzvP4pUdvN7vpvzkXgQl9FaISOnZKPRch4+aOARGspqeLzLhSPTs6f6YhJaS0oXM/uBpcvCClck+3/GgMl43m6KKVmENODr8SEGgpvSV+BDHncze3cLqYZka7UXjgz1St0bEILYjTkMLfvFfpWNThau29zDY5eecpI8QqKDmQ6rGcfrXHTBKQeYZYCo8WVGzRSioeRAygq6+b0yI+9Q/DRGJSS68tv1DHxO8devoG4UhsUGEgXGdjGoY49Zp/iSLstLE+EdBVA0avmYXFIUkaUGwvFTMqVRcbRisbtSe2BvFqlkeRs7lijq2DkFQ7RD+ia8DkEAa2x4Hbss6b/5cjmy1InZthbnU3cRAurUAbuwV5qhToA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(66946007)(66476007)(5660300002)(6506007)(6512007)(86362001)(55236004)(52116002)(478600001)(44832011)(110136005)(8676002)(316002)(54906003)(1076003)(66556008)(4326008)(16526019)(956004)(2616005)(26005)(8936002)(6636002)(186003)(83380400001)(2906002)(6486002)(6666004)(1006002)(7416002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HIblcTaqhe+jwUcbvkEfuffpbA88BgxlZ0Q7J2Y4fL/FtMYKryleiLkRIPSyj17ZFbY49fOuYKPE+i4OvAg0u1YjMvKaBUaK9Zr1znm76ZuwYxEJLVT0r7JwsgbTiXHvEYHW1wk223UEJrtBrVGVxr4QO4dw6PoAP9a3XsrUeptR+5XEKh2F3g6vo4hSqdZkwUNa9KW+W/DUpjxW8NIkfHwc5rs7DvsUvRc+BDTVoc+dvs8I6h+EWRNNiRitwXB2HO236FIbE2mUqqopozlv01wvLQaClejXdB2OQD9qq0r8hDAZ+NXBIE8X9HVNfiAmTWFUGK2lPBukyW56b4VrVUK8Wyu3vbCXYp282+4LqFdOCj+PyOeCxdGij2hmkAf80+obRSo9SQtPGKxu+K2j8iZ90c64X6f9k2An9Sk2sGMPfYuRG7ZcG02YSK0fBntbv0nZXGyJ58yxIkqE0vaOmKGxjjCslSelBO0DckxPDGs=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59290318-d538-4254-e2f4-08d830a6849f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2020 14:25:02.2339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RkO2E91LUNxDtmsBFO5FL1oO6dg9qLeADUqehqMm4cfvbMtBIPTSL9ItT58b1PzvymNZ1SnyBKixuv5QvIC/+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4931
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

