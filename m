Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0B32031F5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 10:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgFVIUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 04:20:38 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:14131
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbgFVIUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 04:20:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgCadeabNN0apcsw2oW+cW+JJJBpLd1OYGeapo9UJwH3fYFrOSLkq+3aOpLGSmIdwXixosv1+m80zJiPbRqf0R6vRUCOLCCnBZm/mDeMPDhm5lg4ypY935M1L4/HlUZaopEi7Wyk9jJ++5JM/xKHwahH5qJzDZWhweKzWWlG52mwNsKwb6IqWT+XSlBLMphgfFxmyd/PfHoScQgqFOg3Pm++0yQVVvAWFoU7V7HGUSGiXppVbL75naAEZLO7Zm5RZ2bLC093C27IfIvh6Hvd1PW+FZPz0QUEnFrmBaq8AIiWcaTeonqqI+/l0knY7t4pBwTGnI1z2aJS8/6HP18Iag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9uxmQdzlzSPbJJogLFm0pYKRl8SZMNOSruORNvqwE4=;
 b=n6jdJIxNRA51lCj5ocE9uHSsTwIPXV1w2295S1yCeGYNlFtY5ZqtKfDEPiEJsdQq5/+Nwtyeol0RB4sFVY7CFr1a+50CliyEwdzAxNvaicZAojBrwQ6XFDnZE9a/zK5baCZ5fe4QkPCxYN4QA2e0snvj8wU5QlqfMRp9oVvq2OD3klvH4Jx9xJzgn1xas8Fgzv+txhMn525KdjKajIb98Qy8N4g2A0tD5iw+lFLuYeiC7y8mhqA0GFF0eB7KLQguJJDRc+PUQxPJkfOO58BmB+oOkJtXC9Nt4oXnJ/0nQHaBR0C9eBB+hoWqIIIAhvVgAVZBGTGAF73V1FfHXTsjRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9uxmQdzlzSPbJJogLFm0pYKRl8SZMNOSruORNvqwE4=;
 b=VBvaRhsjaDNcJVfD35qjBpOqXmJxgC7yszDxn+9qyX99R15GMI8gX6bSarVizfCGrD3jkY0Lmbcx28XuJJvfbPyLYmbHVUCgFV311Dzz4cMaFMOEiZKgZIJGeRVsfovgFrcknWL2pxuPcB9NUmaBty6RhmrHs6Z4PElSwod1ESM=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6401.eurprd04.prod.outlook.com (2603:10a6:208:172::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 08:20:34 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 08:20:34 +0000
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
Subject: [net-next PATCH v2 3/3] net/fsl: enable extended scanning in xgmac_mdio
Date:   Mon, 22 Jun 2020 13:49:14 +0530
Message-Id: <20200622081914.2807-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622081914.2807-1-calvin.johnson@oss.nxp.com>
References: <20200622081914.2807-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0220.apcprd06.prod.outlook.com
 (2603:1096:4:68::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0220.apcprd06.prod.outlook.com (2603:1096:4:68::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23 via Frontend Transport; Mon, 22 Jun 2020 08:20:31 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2d6d8092-9089-42ca-ac75-08d816852293
X-MS-TrafficTypeDiagnostic: AM0PR04MB6401:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB640117D03CE966D9ABFB4E64D2970@AM0PR04MB6401.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: siNuXKA+NgRmlMAeCDQ5DMriMYVpQOpNUR/ICoVFeRHp7lXRdfe4BSH0QUCEd2wJ3+YEQ626jXDFkv4rgS0Xt4skHVQc2Wh4N4IeuSCEvKarj8823q2e3hKaVsCHQPZHahkgqXUG4rrUK2XGhSyPNgJDzO/5eEmnESc6BAFRyPNjOIZe+eStwSk+EiZgVbrA9Wd2T0sQPp2LPR51CdRKKnch9q0y+SiIjvcEq8fUr2I5X1WfgCaMmYI6voJQP8tCIUzvsGp3FhBAjoOIiUC19jGsXHopIj5/aMjPMQ6wqsj1haZ5plr3d4UMkI5vtsfDTEycsAuxQol6Go+gyTq1vb7EBa/P0qpmCDVJOjVIZ+ATwAfMugvfvqpd74M5Cijo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(2906002)(6512007)(66556008)(110136005)(1076003)(5660300002)(44832011)(66946007)(66476007)(6486002)(4326008)(86362001)(8676002)(956004)(6666004)(1006002)(316002)(26005)(16526019)(52116002)(55236004)(186003)(6506007)(4744005)(6636002)(478600001)(8936002)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C8m1yTsng/pdk/m3FcKCKVfkyr32BQrnB/zSHJ9LmiTSFJQo5NZnZGjH5pFxas4Rnd1OSBLMGYI5EA4Tv7IPIigutWF6VR89TbVAQg9EiVUMkVocHYqUijn4ieQ28C7eXAygSUd68sq3N/xV0im5Qkhc4FJioij7pz9MPhqRdO2TFidvGrfjrETn0v2lIrU3sogIbKU2V4JVGvUK+Meu33MkQmlr7nJWCpYueoSIe7PMEcdsWnYDzEIP2t5HOJQHYJ+wuMSDelJe/1rNtTCI5CIO++tRc3j10npAxs4vNk5gCyxPump4JPoM4scRh+JUlx70cFgFMs0dscIQiBnHUodoxgqepcNs4dLSDfxk19WfCsbSam4RXF2QGbCT+9bJ2ffqDcVvXL/KOPUQhgvzQp4FO+0fguQXH30oqBxepjDQkIpA8Gw/PhHltBe3TGXOueM2BVDVr7sEX2Uu6zQ+gAtPJN+V6FVR/FypLLFRhCQVZmkdM3BLt4aDFGtvypxN
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6d8092-9089-42ca-ac75-08d816852293
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 08:20:34.2957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NVf1mxnalBuBXHf3++GF4P8THhKfCy3DkkVGSOjkJpsbw9DVC6h6mV5b1RIZHec01qTinRoZLa78xM3s7aXv5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6401
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

Since we know the xgmac hardware always has a c45
compliant bus, let's try scanning for c22 capable
PHYs first. If we fail to find any, then it will
fall back to c45 automatically.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v2: None

 drivers/net/ethernet/freescale/xgmac_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index b4ed5f837975..98be51d8b08c 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -268,6 +268,7 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->read = xgmac_mdio_read;
 	bus->write = xgmac_mdio_write;
 	bus->parent = &pdev->dev;
+	bus->probe_capabilities = MDIOBUS_C22_C45;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res->start);
 
 	/* Set the PHY base address */
-- 
2.17.1

