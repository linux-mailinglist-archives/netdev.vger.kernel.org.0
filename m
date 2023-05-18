Return-Path: <netdev+bounces-3626-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70729708209
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:05:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1508E1C210B8
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390D623C7B;
	Thu, 18 May 2023 13:05:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C5223C73
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:05:06 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2075.outbound.protection.outlook.com [40.107.104.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722C2170B;
	Thu, 18 May 2023 06:05:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4fOrjoh5scaZsxUl5hv/HzZitHwAHf5nLaInaW2b7nPPybZUcZeTygFY0EogyohcUX6OhvzVP8xk6FDNGG3T9QpNxK6PZMBR0b6+kgPXcE5tqiufHp2oB4zKwq2J/8BA0XaBUgU/Fb8q8u3W6Lk9kjiXdScjEMgf+PQf3RYF1ik9fij0zuxPhzFchnw4RH1mvnyEcEoLwhpJWhFreoPTwwbc5J3Hfp6d272dKxgrhCxHAhhQMPCBzOzyHSD6HQss4gmpxh2MbK9LKfDMHi8KBvpEVtJjY/xDEUJSuM8sdGFzqhOWanTZvG9sRPmp/gMOV8K14qkJofkNe/QFE3ySw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SM+x4DRbeqO3O2rDFC7s2xKfvJDdWRgcBJvAAosN2dc=;
 b=TE0ncDEYVzwDl59jajLfNazlrT+ptlGn8vF9Aj5176ZtdCceLCx/O4PnJNED+Q9rLbaJnYRUNKek3kooMskDUvdn+HtTfJNCewyHD4v4iCUndgWz06EsqhAcvseSM1p7JMjBV7tqHHtnHWElppHR/1I5P9aOWMpglq/lFgQX2LY3SpOlwPNV+KxIwmsSmK7QL3qcYlhOC6QZ7972aiNdDyGnjY9gO1Yd8fP7Vd8iz/i2mV6S4IvMPPvnAYYoJ+phve1WIrXaqlP/GQdpZSeI9eGWycAh9hy7K/LnbnbT+wL3yPL8xj0EcrIGOwiIPfUOdAxn1Q/7a3HEzGCDHn8gWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SM+x4DRbeqO3O2rDFC7s2xKfvJDdWRgcBJvAAosN2dc=;
 b=F+wHA1Vh+9d5WY33ehhG2roLvZnODvhucWZsOHr3Kw9/PpxloXd4dHLs5Ejva7k24h7JUOKWykto3kDZ+5teGFdN3OmU5NzNX5u81zuK451uynO2cVSBsuFbe5JRvUVDPo4goR3QtaJeLZhfeJ8yLjVArATki76N2nH21F8Utig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by AS8PR04MB7896.eurprd04.prod.outlook.com (2603:10a6:20b:2a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 13:05:00 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6387.033; Thu, 18 May 2023
 13:05:00 +0000
From: wei.fang@nxp.com
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Frank.Li@freescale.com,
	shenwei.wang@nxp.com,
	xiaoning.wang@nxp.com,
	netdev@vger.kernel.org
Cc: linux-imx@nxp.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] net: fec: remove useless fec_enet_reset_skb()
Date: Thu, 18 May 2023 21:00:16 +0800
Message-Id: <20230518130016.1615671-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::31)
 To AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|AS8PR04MB7896:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fa4401f-c4be-42d0-b612-08db57a07cec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aJ9f1peETH+YNuOdTNzNU/402fhUpn/BMFjRa8lzcei1ounOsiFyXj3z781WnnQ+KF0+PiOnc5FmX9S7hKyrHBQDf6uP2fE73Yoib0LHRGTarZwk/ebmiqszC2o2k8pdYOF1ODki/82z/jswGN+PE+jlbfj6EfqZQzrXwZKss7FiE9tialde1WqFcr+HBDnoPnUykVthsgU4N7vpiAsRH/TTfJWlRePnmNfiHl+OwEwzbF0HsWa4LP/LjEPXV6ZpAMoSnrfuL9t5Rn4Dw/nn8O7qyXMaB0Nm/9Gyon4X5yJ30ztWA0ug+Ge5fFfALcgfuZrU5VxU+C8SERKwmleZG2P3KaAj3s3QIIp5JA38QZxGj/4f6Dkm+CywHGx+9saNtKoOYYWf1FJ1P0DTEnO5aSkShDf2lyuqBifMd2vqkLR1hpxgBYs1es/hMs50VqdnLzV8KD02uYf1dWtbtv/dBZtLpfKcKA88mlwRkYoiL8XDkrOXvqjkm4cE39uj9JM791CardMHsoDOcNRSp/DED8hQzqVjkYOutcWtX6djhjej6wbNMTfEqcZPAbFd1H3zNi5BiUEVrOPiXVjesAtnttN9LaTUGu8pc2FlQi5Kuef+Zdf56/NXpifIvdcaWD72
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199021)(4326008)(66556008)(478600001)(66946007)(66476007)(52116002)(316002)(36756003)(83380400001)(1076003)(26005)(2616005)(186003)(6506007)(6486002)(9686003)(6512007)(41300700001)(8676002)(5660300002)(8936002)(2906002)(6666004)(38100700002)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sqRlZqTmR2Vb7W6WnVHV9uYHmVQBMtzVNAFd0NiBFVcDXhjCV8H8oVNRzQxn?=
 =?us-ascii?Q?6hUUDLBBM6hwxA9dgIs37VxeYzhea7iOGrBKrp2S2m/CvFdWbfiHX+GXk+AG?=
 =?us-ascii?Q?4e0j71AgTMCn96NHNueYCSHY0kqp2vsxR6ufvsBCyt6b9KxX6ZxD1Mb6/U3H?=
 =?us-ascii?Q?niNk/12uii8fQiKuXG53qJHECT3LQc/qprAWnN4iBOd6iMXPKKo09XiT+amm?=
 =?us-ascii?Q?Bs/Ee6iAd3/XMa9c2D46f8YFa6MilMy5lnRx68HTIcIPpQSwPN6zJEl8tdek?=
 =?us-ascii?Q?9Rp5Vy7y4EpvThyHwyE9vfui7OwwATGw9plx/c635dMOVp2Z1ou+raFkV+C6?=
 =?us-ascii?Q?ivPCStbvvXM0jVWARUh8M34ayLN5K61b9lcCQ3cDLfByv7Awz/rrTh+Rc6AL?=
 =?us-ascii?Q?hH1zav35xWxktSlcjNhWEW1UClTmDmWTK7qpd6guFyKJLKS/7cHG6e0+72gz?=
 =?us-ascii?Q?DpMMKX2ltdFSS27SWAkGgyNE3VUXKqqavoaxqOavZfd0lXWYcJL7F6Y0+kH1?=
 =?us-ascii?Q?lZOlMfdFQNH8pxgoLgUyNHYrj1vGf+6H6zGIoO2FuiW3dJ43Pg4O9lJuy2Ce?=
 =?us-ascii?Q?R1O8cSkvcgm2kPELFzFrJgfyNO9FCvbC+1xT67bUrUhKdCSGQ452Hmb0sF0I?=
 =?us-ascii?Q?0b9fTot1fgmwp8eZjVpV4sAgKjKC7Iz+lCVAZQ+OTfUkJn5oQgX9UWKVY8Ir?=
 =?us-ascii?Q?oY2g6bxbQnbnndZ0X/R+Ow490N6s+KJOzf2lP5HCn/7yF6L6s3BwSnwgD7gL?=
 =?us-ascii?Q?XR8rKEwDE71NieHYdwkwD+QmNzG69xZFufyK/sM6sVJxhq63IB3DR5RPxab+?=
 =?us-ascii?Q?CJ7POjAryU/qVHc3oQYouklM1uCJCE1wvLUSOrx1BdfB/epx7E+n6jwGqJMg?=
 =?us-ascii?Q?InWQgG/UzmZm9KMZxIUivFrbWnbQkvtT1axmKQ9vnazSqNlLt3gEwsAjv7HQ?=
 =?us-ascii?Q?ISQsriIbtnOGJvcAyTluBrEuEVH7xJBvyMzPq4CUveQcVYP4qQrora1np2Di?=
 =?us-ascii?Q?/Y6IXjXg1rFe2b0fSZR5sT9atgG5LsdvZ5RF6aBZtYltm1t4PPZOCa0PuYjU?=
 =?us-ascii?Q?M49iThUqJOx0hjp6/lF6DXA1R7uY2YqFIrw5cRPBafEXO5lEUMmkd/UYht7n?=
 =?us-ascii?Q?dD7yleUE97QHFyzDHqyOZPLDbeVnOUiHLmj7nqQkNeeQGN7JgB4WQvU1xT0g?=
 =?us-ascii?Q?XtIycIqKyVfWbrckYrofEmKwxw6JqMux98fcZLmuCQtIzusUU5B7buReJ7Rt?=
 =?us-ascii?Q?GvGTx2Hoy5k+SXqci1716IVsqrrP203OLfhk2QIpdX7StVf/uAkHncGT/Kbu?=
 =?us-ascii?Q?wU+LiiwYT1V78iRyy7f6TKyEg9ueVJWhHXU0hFeZagHircu6DQJB1I1ohhWF?=
 =?us-ascii?Q?3Q2YetY5vhH7TpyPCjktcJIGvBjKI+YF0/Zqon4QuunRluxyI4ez0/vjrdBx?=
 =?us-ascii?Q?6T+jPXdgSGDSqgv7hMsRDC5slcHAhqm28CVQ/9batuyIf4dl534Jlc8TRUvA?=
 =?us-ascii?Q?XBCOaGoB+jZ/Azcypokz5zsb0d+dzKlbQ8JeZ4DDCmnZdlkjfODqEEGJCky6?=
 =?us-ascii?Q?jF0BuN1gPUSYMGAXbm0y1ncvTvENM3JCBTwuMkcl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa4401f-c4be-42d0-b612-08db57a07cec
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 13:05:00.7304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDD828mKiaz807BegjcrnXNh/Wc3jvp571csBKutoJxmdAPZW1gznE1f1ol5wohqfmQqYcuoMnIE/KoGeWGiCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7896
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

This patch is a cleanup for fec driver. The fec_enet_reset_skb()
is used to free skb buffers for tx queues and is only invoked in
fec_restart(). However, fec_enet_bd_init() also resets skb buffers
and is invoked in fec_restart() too. So fec_enet_reset_skb() is
redundant and useless.

Fixes: 59d0f7465644 ("net: fec: init multi queue date structure")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 577d94821b3e..70ef969e6588 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1011,24 +1011,6 @@ static void fec_enet_enable_ring(struct net_device *ndev)
 	}
 }
 
-static void fec_enet_reset_skb(struct net_device *ndev)
-{
-	struct fec_enet_private *fep = netdev_priv(ndev);
-	struct fec_enet_priv_tx_q *txq;
-	int i, j;
-
-	for (i = 0; i < fep->num_tx_queues; i++) {
-		txq = fep->tx_queue[i];
-
-		for (j = 0; j < txq->bd.ring_size; j++) {
-			if (txq->tx_skbuff[j]) {
-				dev_kfree_skb_any(txq->tx_skbuff[j]);
-				txq->tx_skbuff[j] = NULL;
-			}
-		}
-	}
-}
-
 /*
  * This function is called to start or restart the FEC during a link
  * change, transmit timeout, or to reconfigure the FEC.  The network
@@ -1071,9 +1053,6 @@ fec_restart(struct net_device *ndev)
 
 	fec_enet_enable_ring(ndev);
 
-	/* Reset tx SKB buffers. */
-	fec_enet_reset_skb(ndev);
-
 	/* Enable MII mode */
 	if (fep->full_duplex == DUPLEX_FULL) {
 		/* FD enable */
-- 
2.25.1


