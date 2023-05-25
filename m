Return-Path: <netdev+bounces-5270-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E329B7107CB
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B8291C20B8C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2B6D2ED;
	Thu, 25 May 2023 08:43:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0C9C12B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:43:07 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2050.outbound.protection.outlook.com [40.107.8.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FCC9E;
	Thu, 25 May 2023 01:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ml2uWa0mOJmc6mDcUSdsCJT+gNhfBte1Pg0DQcNco8pP350VzuaDdUHhZAvAHi2hS18xOydi2TqXePnv04ujI47tjJjPuOr9pKOctXzHdfdNxLc5WpPGRxei6kvnTMorUejniStOJMMOz4D3ZwZ4PiiKQ4WaRDVX1ieu5L2rLHwDOvWvhLt4j7an44yP6J/lFXvKopykoQaS7K94GYl/GR9jkbZ4zLIEFJBKXQL0719/MHIhmIKJEnuNEkELfPStU/fVnu8kMipW1jUh1dR+ea+txbFUgyRnfRPJrf45UHHQvi4tzSSb4300/GmywVf5DxR6yq4s7sWdpDk5OvQonA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/8uxgSdL3l7/LRvYC73ji0Es39zv4Mj6qgR5rkZFR8=;
 b=d0+5gPRIeogQJRDpAMUE5IpRJIr2qDkzbTAis28C5qGWVS7ojOXejWJJfr9Q1na7Z9Uxw333GnEnHSF//ph5A91wOw0gtogS4h31tye3teyuEHgsUZeKNefo+R7/KVlMKv7ccp6xGzXB/n/4w1EUCPqNqESMt2b6/1d7CUeVrS97bytmrqAm3M0HOsuaoRvHXq5I4vOiecEzo4ILuKH4kpO4GuojNnFlc6jbjoyR45kcWqtDkizUF0xAPAMm35vCcLRwUODaY5sbBwIJRaSQEgfenYEm8Qj8CVyyWot6CS273zf0GOtexuhCAsMh5hUH3uRxjQzXs2z63hllTCYuLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/8uxgSdL3l7/LRvYC73ji0Es39zv4Mj6qgR5rkZFR8=;
 b=i3WnR+NayA9wAMVfdpyqxExsrPeYkp+WP9hGooI7ogqgRQCxSMnBj0wsPQPcW4L8pZ1qitubQapeuRcje/59uvdOC6hSgrJklAzT1VTUlCZe7xVwZC2iSTktjXp/fZb7qzMuYRKVG3vzPaJhMAoSAtNBXbdpS+v4QfBvqtWWxxo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by PAXPR04MB8558.eurprd04.prod.outlook.com (2603:10a6:102:215::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Thu, 25 May
 2023 08:42:59 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6433.015; Thu, 25 May 2023
 08:42:59 +0000
From: wei.fang@nxp.com
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shenwei.wang@nxp.com,
	xiaoning.wang@nxp.com,
	netdev@vger.kernel.org
Cc: linux-imx@nxp.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: fec: remove last_bdp from fec_enet_txq_xmit_frame()
Date: Thu, 25 May 2023 16:38:24 +0800
Message-Id: <20230525083824.526627-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:196::13) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|PAXPR04MB8558:EE_
X-MS-Office365-Filtering-Correlation-Id: 53721ba4-b7d8-4b4d-d9ed-08db5cfc0b58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zYA56Rjptc0rqlbgGPdlHhbXqd3gt1SoHQVxcKzzvn2FXQ4+1vtWgZTQ99NItZSCrYZVBOtoHWAVNzr0ntdFQXAEbAJ4QYlqA6B8uX2+zxCtJHpQWlDC5+8mnBHZCZwO24c23KgJLm+LUYwp9WLkLZYrYsmZiGkBIfJ8zdIXQT8LFHI8QZNtqRcfIMbHjGTjYOXy4q3Xjjqewn9xLH7KQ+slG4OsgQM3ip5Wx5bZMnzTyvXzkoTsBFr/jAcpknURgeG8KQclYjb/OFFyLQhatwUAID+X5iwgk6EJMDr59iVNaTD2QrJpJrRYgc93kwoGVJp7ze4uXgr0Nj+NrCr+J0PvViaOxHUdTtGCdsiP9f1MK9BCVJWGV9b6cF45qWgMCXl9lPP6kOwRHBLmvDxilnzHzBfMjnqDwC0iXmNXpQTGsXRJFUJ2rx0XesXyX3QMwrOHGjGi4w38oNtlVfdEr9a7+jfKjtS4LATgX0Q51t2KOPb+4JwRDaXGMaEyltJ3E8c6SpQPLReuTadVhBsbd7QekSQ+jfojryp+NdDmkQ7KFFH+7AbjEQkdM+ohzWul/7vp7SmFdjx6su+d8BARkkF/FS+8r+pgd2EC62ZcXIWPMghVhKe6+zLrtTd70yki
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(451199021)(9686003)(6506007)(6512007)(1076003)(26005)(6486002)(52116002)(186003)(2616005)(86362001)(36756003)(478600001)(8676002)(8936002)(5660300002)(4326008)(316002)(66476007)(66556008)(66946007)(41300700001)(83380400001)(38350700002)(38100700002)(6666004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AGBoNAp+b2hqC4LKEV4SzoL1KwjsAxYgh5ncttlvJ259Y2tBC1QjCT7JYDL9?=
 =?us-ascii?Q?gE+HJ8nnBjdoaFUAFQcIkMk748xhUfmIhryTQ8zfUX0vHe4leFOybS+ds21c?=
 =?us-ascii?Q?sUDp4OzCi8T4Mzdu7YCvlw/URgMgcTpovU3fPs8svLwL5m05/sscWjCs6Zlf?=
 =?us-ascii?Q?OslqClsCYWDvIvZOW55Ac+eyB6uEjF2r+EZhzTEbmCAeW5xHDWWoj1CxOKYG?=
 =?us-ascii?Q?ykJcQIFsVq7XsGL8JhBWOEngU91VmGsquoA9I9ZMNsPXdbUesGL5D/6IB+kz?=
 =?us-ascii?Q?HxRapP6aluIPlZwngrTPcyK7jXwFCZivTaYxMiiaF6/63wNsQ0CKd1XgaP1p?=
 =?us-ascii?Q?FUxZBvOq2Pf7puikHpRWRxiLSqAXYV/PKpcXM47MO/FrWpTDAmviOdntfQvB?=
 =?us-ascii?Q?oRuKY5nruOJSq3GObgOm22kU6LuhJ+qyD8iF17FmqWZQ9ppfNWxuaP6SmzXi?=
 =?us-ascii?Q?6p1xnXIBV0L8GTzNAzvje74gAU4Ob9GYyRbAmw9glgIZhbqdCIRbf4glWoHV?=
 =?us-ascii?Q?BM4pHdtCJGnLA+L6Ek+M0a4Ml2dA5L/iuvm+airYrAlCRe/eL0kMUUtiyfq6?=
 =?us-ascii?Q?IvAtuQypRd2nx3DGN8+xjl0LUeeh2YKijvBLrLLJW9MSkQ+N7WN/jW/mhGBN?=
 =?us-ascii?Q?mO1e29wPY/qgT/6SMY8xrQHad8SZrRv6MeOjVJGg1ZG2abl4yINeTnHi7dRn?=
 =?us-ascii?Q?Xe6KGyBjXULKCqr6kkBJQCqsmyDyFlPMR07Gqv1sD/T6Ulma17OTlPpCfbcq?=
 =?us-ascii?Q?BJyCR86nRP+QHLpeGss2z/8QuTHkqQRthh+8jfvTgM6sIWAVySs/FVz/uzc0?=
 =?us-ascii?Q?9G6EEeWF8Q5j+CQX3BcZtqvWHflAOd9/xjujbJG1MvLzxUQxYJGu5rHtKROM?=
 =?us-ascii?Q?eIxsmNI86SgaM7sBOR8XumTDb5cRWvIZYOI3jDr7kGpWnRJerlJUALyRBNr1?=
 =?us-ascii?Q?F3U9eDdAWx0emsXbHpoZPhVSwNLdWAdk271GJ+7L8ByUGDV5XPvQgNpRQ6Ee?=
 =?us-ascii?Q?SxkHVz0R6i8z04vaPDMyYZPbEEIQNPsmQQTzl5zwzpG74siYTv4rpLelgeZT?=
 =?us-ascii?Q?qT/hhmf+GGtyEA04IlhPXCBTkeej17RZTYXa93y76fTik1YWFi6bbB+MaQmj?=
 =?us-ascii?Q?WvF0TTXeozCFvJQKtXTwDXGeC6Ne17kSF0juNn8ie+8n652PvzYRZNyUS8R6?=
 =?us-ascii?Q?PJT/RyJLi0c7SOajdkbEgkSZ72FUgcvfi1XuJef6/NgEheCwcUohaIvjPwlU?=
 =?us-ascii?Q?1ILE57g+1j+76gMKPx4OBO4CflGO73+fQI21p3BubRJIXUTtKP/eWl722Fyz?=
 =?us-ascii?Q?FC54nBvn/B+Wih2GVxry8TiLXOmM4Yrx+8xuiWzx27j+krPD1OeNLdNM9PaZ?=
 =?us-ascii?Q?qmh9HEEpLnzvDT1HpnyFJJ+p0NTWdTpXmvo9pMuk9FTKD//klGZHEFADFltS?=
 =?us-ascii?Q?YJ65NOq/n6k31d4h8BPStowQHn2ea4eqCit7q/Vf6yxC9/3vGJiZwWCm8h4q?=
 =?us-ascii?Q?X36JdN5HYSCbC8CvVmn/E586IsU71oVOt+/6m24/d+OoYAUYTY/i+vcqE5Co?=
 =?us-ascii?Q?hZXNXEzfVglZzBNz4WbHijVGN4zZh29zoLBAC1jj?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53721ba4-b7d8-4b4d-d9ed-08db5cfc0b58
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 08:42:59.6962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8aw33zlaR3e8GX+XapoJbOrkdxo3a+a80A9k380aM7UVOR9JBHPZhCpplI5fVy2jqmEZwm5He/3H4I5+bIcRkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8558
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

Actually, the last_bdp is useless in fec_enet_txq_xmit_frame(),
so remove it.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 3ecf20ee5851..26fb00e0590b 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3770,7 +3770,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 				   struct xdp_frame *frame)
 {
 	unsigned int index, status, estatus;
-	struct bufdesc *bdp, *last_bdp;
+	struct bufdesc *bdp;
 	dma_addr_t dma_addr;
 	int entries_free;
 
@@ -3782,7 +3782,6 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 
 	/* Fill in a Tx ring entry */
 	bdp = txq->bd.cur;
-	last_bdp = bdp;
 	status = fec16_to_cpu(bdp->cbd_sc);
 	status &= ~BD_ENET_TX_STATS;
 
@@ -3810,7 +3809,6 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 		ebdp->cbd_esc = cpu_to_fec32(estatus);
 	}
 
-	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
 	txq->tx_skbuff[index] = NULL;
 
 	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
@@ -3820,7 +3818,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	bdp->cbd_sc = cpu_to_fec16(status);
 
 	/* If this was the last BD in the ring, start at the beginning again. */
-	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);
+	bdp = fec_enet_get_nextdesc(bdp, &txq->bd);
 
 	txq->bd.cur = bdp;
 
-- 
2.25.1


