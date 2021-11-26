Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E295845F30C
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhKZRgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:36:18 -0500
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:29334
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238056AbhKZReR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 12:34:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOhiHhc/AVKGdswIcOlz8yJFmyoYOqJ7JpOpFomIggHKv7XCmYD34fB0KDYDTrsGT6Q9beZZjqvHYxjCWYArcHe6hls57zEC3OVcub3nJl6lamvmvBVNkKzU1SndSa0ucJREXUAPBPCeJxsrm96mlowAa3dpp7PEIitD3acl5v2UecbhulQQl6HCG6N1yVSpy9ePsZnqbBhe/SeVmS8uc3+vMbB1UkFas6el4C2ZHGl/FzR8BJjGF6j3pP60cs3SA1lVAe53BvYkpvFo8v+BDAuR5D6ThMcSz1/uYx6W9HzIbez+5El66T3RCfy3+4vyjBwIAY5SsaOCT4yvs5dzhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcqhtiHzd3/1CAQQn7uv5XcvvlXvG/u5nHDrcquwfYk=;
 b=Pq0d55uMCX0jIAtnlLnUOpKa7Sv6HfSCmOWjPW7eYvL4MCVarffVd5JBpdtxVhvpQ+P0ojXZ3ecpdFGEO0RPCycmXt6UCxRO/LhmP8OcPN1sc/J8RrOZ4J9JwXc6r1aBQXSFs/g9GG60ToGOEBEzKy4C0BEGcvs0sC2LvWc1080z8cBgCEDCLfCbb9m8s+dtzfO2NQ0MHHbLL24NxDkitVh86p6V/rGmcQyO4d3BDeuver5Cf8Q3KNfwjQiNG/iT0rXlw4zFm9uwHljc9VYerx0uDdd/hu+NDIdJVPgrasWM5h2Nel+nt8TPySY7J5pAz+FXz7BMCwkL7B7YXQVs6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcqhtiHzd3/1CAQQn7uv5XcvvlXvG/u5nHDrcquwfYk=;
 b=IQGDvbfpQjj+e8mrVZ4emOV+gTUkLmog7H9hfWlYzkIqzQlyIYWjJlq2EdpoI4Jho8MxS+R02ogpMBbneJf9zt/Z1nWW1eOx3w6yp8vG8ytRksRVno1K2ZPdsRD2ngGGyjlYMmec+GeHgQ1TB4Xy03kUE3NHjCobWlQGhx7UVoA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Fri, 26 Nov
 2021 17:29:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 17:29:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Po Liu <po.liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: [PATCH v2 net 5/5] net: mscc: ocelot: correctly report the timestamping RX filters in ethtool
Date:   Fri, 26 Nov 2021 19:28:45 +0200
Message-Id: <20211126172845.3149260-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
References: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM0PR02CA0125.eurprd02.prod.outlook.com (2603:10a6:20b:28c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Fri, 26 Nov 2021 17:29:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eb96537-c7de-4e63-41c3-08d9b10241c4
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-Microsoft-Antispam-PRVS: <VE1PR04MB66394B71273FA327C2D5DFA9E0639@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWrK/cSWOwrcEKEeLvL39XpDUxaVKi9F5jyvQIEtp7Qkyl6kQyrBjumaKayJinqWiAHqIBY9wyyg458vsVUTGT/uLJwOs6X/nGs7SMyyztHxXywG8iD76jzdvK06grgImAVbM5ndQk4YwCdRXRRnmUp0FGhWGLm+vdsCSUYFtPnrUK9GEX56Y/uxsEnmFP5ZnkbAzNB0WYgNkV62IxFk1kT0OKK7ZDKNXb4lfE/JP4qQ0YfAWGbZrS0vKpyNssb3IywNKckgNumeixb73q3qSzOqf1amjlPHixR5DwoH464kpsIGBHP27G1IOsBrYvmcU4Z+LNNdWtl0rpuPQhNwOG0md7/30P5v6FnDk2D0K1VT9tFypxqHesI73prOf20uVvP5U+JBNmje7DjhrofevdZNphGv2+O4OLB/rWj0e80J2dZiqrBiF43sMTwxcjmGumux/FQCYeXMtuQEQQalI4RoluuypDKXA32RRaUfuersDdibSPi/dLrGdoKzqxhsFgSRuasP4YhbjvzmRdPb7N0R6iioGRTpZ4mv7uK1OdEd4JFt4oFQSggmAfqmZK4dDHxdP+5syCfp/IobbilCmosdqLe6n69uKRZXTV3SVsV2goLpaY4/41wx/k/fbLbuCLq0Xmq8XgUx2VqwpXN01n3PJ7Jq4/1SIzcE3Docszd54rYPpT/oIh7dNKTlATpogcZPpfED0VY9kyULx/uM5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6512007)(7416002)(86362001)(508600001)(956004)(26005)(8936002)(44832011)(6506007)(6486002)(8676002)(52116002)(66476007)(66556008)(83380400001)(2616005)(5660300002)(54906003)(36756003)(38100700002)(37006003)(186003)(6862004)(38350700002)(6666004)(316002)(2906002)(4326008)(6636002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9s5FDhl0j8m9UA0JeKqwUiFqWHBaCizFdXNIAlORmcjmIA7fgeqUuetB5IiA?=
 =?us-ascii?Q?gKVPp6UiPy0W//DIAtL/O7uzAlrYLj4NoPKepl50ixnj0miXyvRygz4Ebg01?=
 =?us-ascii?Q?6gFR7Xm6BB0h1/iMWxMcQEKBax+yVuVkXycnxMqrb1TaiSJY4YWx6Yko79/o?=
 =?us-ascii?Q?Q4yLyHXeXVVCJsWT3Z+1assiG5NwkX142DImdxdQFoOISelCb3LcRFoZvhGy?=
 =?us-ascii?Q?MMTBbwDVNaeRwCM9FYwG7Bj8nW1K6u5lyC4vH0e/QE1UVlWMtX/psvjvKv7V?=
 =?us-ascii?Q?1GqFMwGL7bRxS001n14yPjtu4fl9M9s9lvNKUJq8IBr8KIidA9Mv5uGqTAdT?=
 =?us-ascii?Q?WoulMIlwFypaf8ti5aqV4to2J1VKSIlESgHOG4VGctwmlMjK5zoT7W2FHdf5?=
 =?us-ascii?Q?JvYKBvdsH4HXpJprdHffnYIVUdVsw+qUwefdiuPTRhH/ZsQ+n43S+BhRE5Ap?=
 =?us-ascii?Q?l0Wr9CttYNRZYYr4yvgcnmys31ZXGnFNaXQ8JnPxuaB4ajk+6Fal8ByxnBiu?=
 =?us-ascii?Q?vq9E7mtI+F9nObooB25C2YBamvyqz7Wd0aCFq/1X21rUge2xJ0hj083h8qc9?=
 =?us-ascii?Q?/2Q3ncFJaMvzBURjslKhzNXRW1G6KbdUfSXNKVeHtDKMnkFycPZ8k9ZyHFEF?=
 =?us-ascii?Q?dx19lmgARNs1dwmIfyMNfiz2lQDbdrMpOIF0d28/C2xb5pWaQ0fmwRYJww71?=
 =?us-ascii?Q?eLR+r19uN8alVfFP09KMWG1Bn1wpDvUyd4guE8yQ/5kZD7hi8OO1JpFRIlBH?=
 =?us-ascii?Q?Jx9X7JPYFUVeW0T/sEok/EARaTSxaqpYbz0UgFKX1zIcNzBLN6tod2/C63uf?=
 =?us-ascii?Q?gHtkrgL5a5OiVcFGQ0WRxt8fZSeoK4cHRlaj5xFYQoQBa+yGxsTdwHAIk4GL?=
 =?us-ascii?Q?QGvYJKEMHTz2D8Uel4xqx/KX0qxrwasEeQjtCpIT2aGfQ98H91dgCChFiGsG?=
 =?us-ascii?Q?GFTlL/BNroKWICsD9BbCjxVD8Jka6icJQp2QHf+kyFoS0lcwK7llEGuMnxBX?=
 =?us-ascii?Q?ITu+Zfi7hGKZzjo/XMuAYRbdiGkuG6gJx+MFksO1U4ITO2OrXsAgFTw3uj43?=
 =?us-ascii?Q?cpXihyG2XAWj7wxRGIE3ipBrL5xM32sO7mikhc8Ycx9WsNb1NhCk3g8DIGeT?=
 =?us-ascii?Q?a5InVetvcoN21Q/+MluTq60LXIkM/QnnDf343x6S6J1cbN+k/khpomwp6ZoP?=
 =?us-ascii?Q?8EOTcPqt4639djDmsMeqKGzBtitBBNnwNdnocGQtnt18Y8azIbty5gve9xmk?=
 =?us-ascii?Q?Z8V9wFUzNvKqNMIjajgZc0HFuk1ku1f3KpI5pSZEhP/fZy9ApyulcV6/o5Nn?=
 =?us-ascii?Q?hbGmbg8vyWEqtv7G6U8MmsvaJwtY+hDD9qGcbG+0KnTqw8ziJLS+0dy9fjrJ?=
 =?us-ascii?Q?2FdfwtrZnusaMWKEXOUmnN3uh0JdNMxpf8UOvwUxLcQG6hT284QTLwy6xvyN?=
 =?us-ascii?Q?I9auNp6zUbOO09QLoxebCnFqiHVQjSoqJns3d9GmKiT2BycZIPcliO9/ubKl?=
 =?us-ascii?Q?MwszltEJCagNm/FPfjhi1tCOEvxtOa0TmH/7F/miuSN3ygc01PWM4az64LjU?=
 =?us-ascii?Q?bMQCHF5pxoZjZxQ8GOcdTG7QTTxoc58DULVCc7l0318CmSaru5BDWjastNN9?=
 =?us-ascii?Q?yhjM+pRyqwd67iMnb2nZOCk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb96537-c7de-4e63-41c3-08d9b10241c4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 17:29:10.2716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qi5HHXpV4W8OFwXt2SI/6QbUuoFYl42uipOg25Smv3WA/KYGC026AA7NAM0HptpY9zQ7ziJEkZVpBOXGohOsYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver doesn't support RX timestamping for non-PTP packets, but it
declares that it does. Restrict the reported RX filters to PTP v2 over
L2 and over L4.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9b7be93cbb0d..409cde1e59c6 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1677,7 +1677,10 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 				 SOF_TIMESTAMPING_RAW_HARDWARE;
 	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON) |
 			 BIT(HWTSTAMP_TX_ONESTEP_SYNC);
-	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_EVENT) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT);
 
 	return 0;
 }
-- 
2.25.1

