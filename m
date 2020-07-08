Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CBE218E53
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGHRfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:35:13 -0400
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:43335
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbgGHRfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:35:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEIQxZriP6nN/KmSS6+mZcy/z/VMiOpKuv5NqP0/N9hMoZQnhSiGoAkjvLoVC9IzRkIjsydaqjRHrFlAQ5Qh6VicxRie7SFyk4BsA1jBPo76hxG4SBuxMMyuLTCfcwx2xR+lGoL/CXjVN1P5RcI8k647S8VjszaygTasNGIRwvb8+FKuPQUMwCn9WDLkqit9cUB8hRg6oS0PocLXNU7YSmsb7iFUdrGH1ouj6N50lQLdZGwmrT9/v3oHDWIp1BR+Vh3SLKX1TspCigQcUGfmYwO+MbxLu9mro/GZzfoNLJ5QIfFuwl/qdFVdraCX53V5RgV6LCOwLOPu+7SunQ6EGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mpyk3909EXqa8teYZxfF+BCdEL9rGeVAzf8kyTwKhsE=;
 b=VB7rq7eReyfrJZIfopCZmhrGThArXAdUXTv03UxAmBGP3Uj1PDhrWuW3IiRfvev/9S5t4llk7WU8E+j3Ho0VKoc0gyeBW/fUelco8gMOXIxmg5ih/Ph0bzUvwCdTEW/8xxk0MezcfkwEb3BzMmYYwZcQQJJTmTE4LOittcBMVE0F3UjcDMIGLqNhh5NYF9vBr02leyrGXe2/x/ejxtbLckGpuveIbjbQJ2z/pc0fOlG29ix6Yi8ixCjwrIu/Y11mPLke0GaKJEsp+edQ8rBFTsvepiIaAjTOa5v5qki+il9YoW7bL1OpqGNZtX5LVp2Dvb8SR7DdCrwcOHrTxiYfvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mpyk3909EXqa8teYZxfF+BCdEL9rGeVAzf8kyTwKhsE=;
 b=FIZx8piJFhhzK1zRIk1kMD/UU0E17dJ8pkvYGf/FOaS0HBHbLTJ2ryZJfBxbipsf6yB6qtiIX7C7sJfMM2Q4izF+qVHrDHcJd07StyCb3rVKLXD1jjR/eWgK1AFV/YNy1lTdREcbbr9kPKfmkfeuEqXKMM10AamONI1I5Yrc7XI=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5730.eurprd04.prod.outlook.com (2603:10a6:208:12c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Wed, 8 Jul
 2020 17:35:08 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 17:35:08 +0000
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
Cc:     linux.cj@gmail.com, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v3 2/5] net/fsl: store mdiobus fwnode
Date:   Wed,  8 Jul 2020 23:04:32 +0530
Message-Id: <20200708173435.16256-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
References: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 17:35:04 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 47aa6738-430d-4be3-7b32-08d8236541c0
X-MS-TrafficTypeDiagnostic: AM0PR04MB5730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5730EF410EE8DCC01B09CBD7D2670@AM0PR04MB5730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rupE9HOxhz0HPcEU6EIybysYTFfQ6+1bJYbkOpmGJrtP91tS+F8CvJ5QAxXa0DSIbABErM5RSVxFKfQf0cEiZdzuZQ+FnmeHzgW7C2Wa+uiO5PL3o+8+UuV625kd3GxGEgjt7pZvUeVzF0gi5eBcOqZPvlUZRajG6nDaWF5N2k2ahgLCOJvHHsd93l0T3KyL8fjBd8GW+5VI5sXZamB07UfuTrVxeFSPkzVCVHKnUAVl0nh6SslPQ8dSeVJVQw4ov0yel8zLwOt3O0hpsY7Wm5Rl1xe3kJ0A4MYL2KIVBzgUSWB/Ee9jIwHl6ArgRi7ZT8g7QpDJez53PqW7rn36M7yJWl1288aE+q0zDd1Y8w5q2ClsnivsMGYHR9m3DCcJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(2906002)(186003)(16526019)(956004)(2616005)(8676002)(316002)(8936002)(1006002)(6666004)(478600001)(6512007)(5660300002)(44832011)(55236004)(66556008)(1076003)(66476007)(6636002)(86362001)(6506007)(66946007)(52116002)(26005)(4744005)(110136005)(4326008)(6486002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wK8Hljf3xrFnLcJe6pBC6nG1ROJWguH2G+5Jrx1ZVkhNFjHeFY+uP//ka/GuKj9vO7t+HBUzZ2h9R092E5z5lSUoyFZ47lYd1JUMTLUkvmz4zO5Am2MuNoF6cLtU0fU97mcnppfzV52xnsWs6MLGYnDA3rJC4G5Mx6uDI7qLRYaKgVNz+Wry0NRItbknwOmLxvouQCN2xUcx7VH+49U0NPxs5dv47qkMdAigmb2qBiEiqyNojpQIrVQTZpvi04ILnQ/4x2qDwRDcDaYUCJZWIHpfKs6J/eeLq1okWLw8ZQUepVjCfnSlUSRMwWqvdTqFUPBSpXd8I67PGjtp0Ygf3VnIHRPijyty6wid7PW3l1PSwEoCrqfQAEyVegq55DCuJjrcxHC3RkZgGriep3XVRjDTowXPiGCJ7TUi9fEghl8FKqWQ5HekVHdtQQy+WmPkqb2J4N8Y8UPLjBtw0Jm+pKTHyLHmaE6mqrCTSO61vYc=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47aa6738-430d-4be3-7b32-08d8236541c0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 17:35:07.8525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iw2mbbVchf17KyinndIud7OHx9gwRO/Xhzch3NzPs19TwnD0xy6GW/kgyy77pAq1+ha0caFLYtaOqGM6fsg3gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store fwnode for mdiobus in the bus structure so that it can
later be retrieved and used whenever mdiobus fwnode information
is required.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v3: None
Changes in v2: None

 drivers/net/ethernet/freescale/xgmac_mdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 98be51d8b08c..8189c86d5a44 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -269,6 +269,8 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->write = xgmac_mdio_write;
 	bus->parent = &pdev->dev;
 	bus->probe_capabilities = MDIOBUS_C22_C45;
+	if (pdev->dev.fwnode)
+		bus->dev.fwnode = pdev->dev.fwnode;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res->start);
 
 	/* Set the PHY base address */
-- 
2.17.1

