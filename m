Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F09445DAA2
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 14:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355101AbhKYNEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 08:04:20 -0500
Received: from mail-eopbgr130073.outbound.protection.outlook.com ([40.107.13.73]:56166
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355032AbhKYNCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 08:02:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVHXA6nV8/M5tPPlfe7I3n0EdPEP8Imn1hQHCDIddvGfGXXAMZSfXOQtiIxOZyJvPhvNG7O6lzq5QYc/uLPQAGlLTaUrI5Po3Bu5t2nKlcSa3HFu0StqPuLwnwzPhxHmnxwrWr048oI43mBIhJh+wPXuoaTgIult1qkDGyQeLNmQ4KG1pPQSlL9bEvJ//29Hl9ey5oh+DUNFtE61F7dFt6xrtz+CvdsVFVBZIoWf0c6zNswXfHGR3cBtAXsB3GjNQinf+FQ3tsPQZH7gB8tAbjHIkfyzgrAsOwvzKotAKHlSHpUZNVNXt9um0my6JALm/b9CMf4FT8NiYWQJ2a7e1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WBmlia3uVRoFolEmPydmGWQdRqZxGimh1sph1/Bkito=;
 b=PCjruJc8f+dZUkLAAzs6lSDKUK3HB04ToBKQOOmKl49B1k3AlYVug3L2yktAceVJ6Ex8yRl9pvjF+PTrSckaUDDSErtiVE41SyeRkzITxzgX4rHeAH5j3qFaIDvraz2L61cDyZPse0uccPB8hFUVj4zP3U4MmlCLeZRQP3Gf6wuko7w1j4WOVwM6ML1vxoglgPBDpda7G2He8BJ/afQoz8TvY/pGJKQ4C0Nb4CPHA6I6pJaaKwLTIUcnH1x33QqhyuadyB81E6OlbtR4ONoz6XOYXF4ELc3+t+iYez0Xcf1UND1OH6YfPefEdY4BOssNM679IW2t/8ncNXRm2AFxjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBmlia3uVRoFolEmPydmGWQdRqZxGimh1sph1/Bkito=;
 b=HGEPZ21Sr/6lurgGA2nU/Gjqv5h8cKhqujtaVN2czolErz8dmJtZmcjWyenyr/xtHwWEyFfHJZGIV36wqkTfWF8Zg3vFotyFAbcr2LLN2FKdFHxZ6aK24vYm23HathHRdNbpE8/ZT7rbnkmzWmSGfbm8pXsV0MqLxbi5xJjGGSk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6510.eurprd04.prod.outlook.com (2603:10a6:803:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 12:59:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 12:59:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH v3 net-next 1/2] net: ocelot: remove "bridge" argument from ocelot_get_bridge_fwd_mask
Date:   Thu, 25 Nov 2021 14:58:07 +0200
Message-Id: <20211125125808.2383984-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0142.eurprd07.prod.outlook.com
 (2603:10a6:207:8::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.163.189) by AM3PR07CA0142.eurprd07.prod.outlook.com (2603:10a6:207:8::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7 via Frontend Transport; Thu, 25 Nov 2021 12:59:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bb13975-d91d-4aca-5824-08d9b0135d6c
X-MS-TrafficTypeDiagnostic: VE1PR04MB6510:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6510CE7504BE98D8139714B0E0629@VE1PR04MB6510.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9TFsQ0zQ7kpXGuBAplLS7G8+baxR9ZaIzZHp1A44QkuOwDw8i5o1UqUAV5i8INcyNqAzAQJqjNMb73/WHu1YjLfkpdqwspfxqH7WFHc37qrQ70D47Tsq+2inNjkbKjfZm2BpMmXSaXGl0nweypLqyfdgnfHtqzA4PNlqAF30T4ffjs0WzOC6j+OD/An/k/2HdQaXRoW4+eXVDIhMGZyWWXb1C97kKH/c3r32XBcE2zZnXV4zA5tVUXVghg1R1k/98/4yDGHngr+CbVBIDXWJoYcoSKPmvrQGARW2tZVDf7O6cKGV90ljRNEg5n5rojqv0pUO+paopCJB7m0uxWmbGd4GSUYHKIw5juo/k2vPABK+hOVEBgpnH9PjeX0094JzSdoGQvBYX7JjfPcsGAT/zAoP+99SNULGtlakO8vggJ9Q+lgbY/WQnkEVS2X0Lhz1bL4GzvcMG0lY1AGuEPPzEOrLeHGGjWbjgta+grnJ3/f1iR9N1Czbfebgdac6lb00WX1tuI3u3axT0X6PwITn1j9Zbg9DayKG03y04Gp0BTnqEmbHeAFoM41IwVWaXxGKQt03gXZQnIoj5z7+Eft0Lrssei3i0xjp2kjLRaipo/OCHjGurmAR5ZBSOFlPqDh8TKVFE8BTYxDSdYzOCwR5R3FOkIwm5KuxbzbH+XtpIAjd8vrWyqWt+YpBC51485tR1em6avyDuGKjMrkmNsPyMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(66946007)(8676002)(508600001)(66476007)(6486002)(6916009)(26005)(38350700002)(66556008)(2616005)(186003)(86362001)(956004)(6512007)(8936002)(36756003)(83380400001)(38100700002)(54906003)(6506007)(4326008)(2906002)(1076003)(52116002)(44832011)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?duDFa63qXbCy7babT/WlRciICl8s8h/045I2+jFwsTteLpolK6UA3DuOTgib?=
 =?us-ascii?Q?/Monbyn60jO0vngiCbRulsJccmfe58Cc7H3IvzahFGEdUzsA9N59tjASn64S?=
 =?us-ascii?Q?b/RFwPpMZMvWFbcQBnjaqCewXzwZkGoMnijDQnLscZoAxTQ3dLqXR6BtDzWl?=
 =?us-ascii?Q?7kMzgblITwpyJyUby7tSZC7VCA3rKIPHgZP9K9fFgfIDUPIOrdVm04U4LaDr?=
 =?us-ascii?Q?g9yP2rPY+5e428gX+xZKZn2fdj5GErhOk0I6B55Gs2FRYTpeKusyPFDjDBHw?=
 =?us-ascii?Q?K/osJ8MyRJlvkZ51C2r/xs+DTJhCeR+rJ90cjiQPHQUOo5MAa6iMXO0x4QAI?=
 =?us-ascii?Q?qPqeK9DoYMFfMWh4Aj8rGgyeGAXZtKt1BZq2nw92oJozS1KQ2wQsDE4mhwqd?=
 =?us-ascii?Q?C9W3cVZs4lJDKmhA6GLakRXIT93pWwOcMA7paxHCWlSeg1pdRkIJqAorVguw?=
 =?us-ascii?Q?Y1yB6PIaea4OGY+XIW+i0B6W4FgW/Xqg3nWNQAkVPmTfHDOsBBb9G19oEYaM?=
 =?us-ascii?Q?f5AfIA95hdYdmGjrHg3g8D5kfVeGL3hdj+8eiajS3J0wFLahc2PYpavuMUHN?=
 =?us-ascii?Q?ZG33lDONXhxnN7/F2jW2mM+KjoLplaEOWhbMYZAmhJbHEE57qrpGkOpoc5S0?=
 =?us-ascii?Q?dHlwpqyk20flq/jaOUSkIp/oV14AzLHAvTqrfBFRQNHntp+LdoTm3ynWogMw?=
 =?us-ascii?Q?HsdL3WNB4fO/tB/yuMwU/965b+etoWrL1hSAtOY5i4ENAYAlMY3xTFmjeGqQ?=
 =?us-ascii?Q?a2O3+UwqrwloOJNdNdWli5O1xQY0bFaO+pbHyVFvizOeXnOTftbbUmi9JZKg?=
 =?us-ascii?Q?E9xHJ624JysMv2iXHdy+ImGpB2EYU/kmOpk1rIDdrFdbyMcgk15np04emvma?=
 =?us-ascii?Q?aogKCBj0wC2ytECXFYYuOxU90khpYVcRsZrQ6jLu2uYxPlZ1tf8CkuODAYhN?=
 =?us-ascii?Q?2zgCSxnBsdVx8AwY93V42nxR45ACAY7e9MKshYhu/CdGE/iwDwPMJ3sXMA0O?=
 =?us-ascii?Q?y7rq2h1MVmOGiaQ6YkWznOq2ivJgyavcvf+P4XxuGbF9XMtLfzW7qGHEBhBx?=
 =?us-ascii?Q?wZxfR8DG13SbARrZARkV4UZE/ZMQtcqj7DvdJSUjD7Wnz4iauAXmLLCKOU0B?=
 =?us-ascii?Q?EMP8XV9t185DQDvRme5toggSb5y5sLw5FPIQtUALIMCQeMcLBBoA/poY0TwI?=
 =?us-ascii?Q?1pqFEQd6vbU1y++2cLEb9rPzUXmfjuPFaefBbtH4jFF4Aw4t/jYhxw0EEZY5?=
 =?us-ascii?Q?NGp1el06Qn8NsA1BHBe5K3x9dxbsya4/+ctJaBM+0O4/44feaKdysPQJQH5B?=
 =?us-ascii?Q?sHJMIphAF+gX99MlpZcaeZn5pbXpXEA1OJZUaKPtSML/x69QtYfpDN1Wip0c?=
 =?us-ascii?Q?SY5A/dWDkAAlT2EZL/WEQ0VUGQq80Kc3GGzT7m1IYMDHDAb7Grh7a71QOLr0?=
 =?us-ascii?Q?xEsiIB/GdbyEiTMjvqBjU7NXPbhoh8adxxUlm9wTqej4BUISoNsR+FwaNYuH?=
 =?us-ascii?Q?U/u68BIOF6FUMWykbH404e0QO9XHwV6iiM91MZvfpfdoSRMxFnH7xBPRFKa+?=
 =?us-ascii?Q?vFaPITecsRH0N9YCxDSE2/fCsi8No+7S0a6SBPtldlqLoO/T7WJNPk9E4D8b?=
 =?us-ascii?Q?rMn6KOEOpUs99VGJ+v+bnWQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb13975-d91d-4aca-5824-08d9b0135d6c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 12:59:07.0073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JW5LBgJc2XUGNH+MxQ4pT2IbmM2qFCDUX63+1WkxmiW6H6yHfDCxNMMJRjACl4r0XwqdfMyQ0ozooxy61e2N+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only called takes ocelot_port->bridge and passes it as the "bridge"
argument to this function, which then compares it with
ocelot_port->bridge. This is not useful.

Instead, we would like this function to return 0 if ocelot_port->bridge
is not present, which is what this patch does.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

 drivers/net/ethernet/mscc/ocelot.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 95920668feb0..26feb030d1a6 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1542,15 +1542,18 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
 	return mask;
 }
 
-static u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port,
-				      struct net_device *bridge)
+static u32 ocelot_get_bridge_fwd_mask(struct ocelot *ocelot, int src_port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[src_port];
+	const struct net_device *bridge;
 	u32 mask = 0;
 	int port;
 
-	if (!ocelot_port || ocelot_port->bridge != bridge ||
-	    ocelot_port->stp_state != BR_STATE_FORWARDING)
+	if (!ocelot_port || ocelot_port->stp_state != BR_STATE_FORWARDING)
+		return 0;
+
+	bridge = ocelot_port->bridge;
+	if (!bridge)
 		return 0;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
@@ -1617,10 +1620,9 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			mask = GENMASK(ocelot->num_phys_ports - 1, 0);
 			mask &= ~cpu_fwd_mask;
 		} else if (ocelot_port->bridge) {
-			struct net_device *bridge = ocelot_port->bridge;
 			struct net_device *bond = ocelot_port->bond;
 
-			mask = ocelot_get_bridge_fwd_mask(ocelot, port, bridge);
+			mask = ocelot_get_bridge_fwd_mask(ocelot, port);
 			mask |= cpu_fwd_mask;
 			mask &= ~BIT(port);
 			if (bond) {
-- 
2.25.1

