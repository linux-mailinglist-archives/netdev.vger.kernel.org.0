Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5434618AEC
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiKCV6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiKCV6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:58:09 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6FE220F4;
        Thu,  3 Nov 2022 14:58:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amY5IF9rT/hT9/zXUJraMwSVqP12LfTbGcI9sSJK33AimE9jEFI0+ycvz5z2KQw4mME4nQwqWp5jX/nCRMwBBTcKZQj6SYk0ydBygnSBf5UDc/dzyKKJ7U3YieVc6ToiB+MskBD1sn/rcfwyEIfyVo7TjgjBFIe0rzZN63QmApVOtuVd+dkavjmj2AKpOBKa2Wp03nVscdaMDnO7yBu4nwQLFT7dA7ZzvXK1nawsBC56215Uzp+F9g80pcfRfrG9b5laiOiqTh7LE7EnjUXKW4QT5YMjhSOFSTD4njl5w1ane8bnYk5HbxSchfXEYDQweqP0p8QD2AWbp4pQhdcIZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrL76Vm0XcTK1dRzx45bQKLHYwG1VC1p0+eDpcFDuGs=;
 b=gCyhgEcVE7dR1oh93vaHFTNKnKcKpT2qkWvp0tLt2y1csHMZUVbfav5jJkZks/JU6TmRQbBulOIVF6Iq8LALR+RSgjUj+TOwx0QBAoTH6AjHwVYJ2PimnHkXq/8fZ5i+5CLiSWJHnOQ0oc2IWSEe+eQqLCcR6dFnaBxqJ3NyxmRwzjHZRWcRsqcewS30o5L62ci9zJ8oO6bg47hCi+eG15fvlUeD0N2bWxLu9y5ZwlPuz6Q6wmCuOFg0bQsRjy5IMfcgQ0i0vWJyt7O0XRJZ6/fBeCxhqGzpZwTzKsTvWMGaEOFbcryAcsPl+HHr+FFhrlnjeDwlKM1OjKji7OJ3AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrL76Vm0XcTK1dRzx45bQKLHYwG1VC1p0+eDpcFDuGs=;
 b=MSqpBN71sPWj+2xFXF9xPDGoCaJ+boQPYQi/aLMXpgdpMD+0v8jHLeQmnoiqRxOaT48T4moDNwlD50B52cmcx0LchvOSGnwx3Yy60Y8/XvMPQf6RNnh2+4bA0jdFchz8J245U7Q1ploopu+2a0XMn5IpYiYb4wUeAPehLIN7u1A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM9PR04MB8828.eurprd04.prod.outlook.com (2603:10a6:20b:40b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Thu, 3 Nov
 2022 21:58:06 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:58:06 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 1/1] net: fec: simplify the code logic of quirks
Date:   Thu,  3 Nov 2022 16:57:41 -0500
Message-Id: <20221103215741.2735244-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM9PR04MB8828:EE_
X-MS-Office365-Filtering-Correlation-Id: 872e23fb-93ca-4539-c90a-08dabde67cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkNAKAyutCiHDFR9CHr9HHn34PEGldj5+4uOWGxag6qzghPVCuSvyVSsXIYYQDeoHHONv6T4doa4aAI59F0bInbYh9O/OG+KM+OPKa6L8oInx49NfNysMGr2+Lfj33Gcn3jW5raK/9aZnPi4BM+H1H14bVBFZGO4JrJLt6spO+aQXJRWFt5NiI5DEROHNuRH7WjHLY3G0Dsxp4uKrK8Khv/hTHNAHov+Siobmp1D/gQEANwxvwyzLgZUrwqQNw9zddIPHuXod2KUILLEB3mF5hHZ+7vFdkq6B3SvQa8U3Fii509q3AJ8ORjkE8OS01XPxOVqHsotcg1B/qsGr0kiO5qKUo90trL0eN6HVgajc9qmQcpNxgyC3s8FUPELkba1tNwmd/soSzAAfvdROaINMfU1qMPNuAODlB3gArjDbvqBWca9FlWzeKBHvEx5UYrwYh/3Nea8E7GOlpmOOW9Vx/FidAhHU0MkZFzxy5SkKFa61bxX0oEl5fY+4Bm+pPntbySnp9WBn/Dza8DWpqtCo9M5lOoG4n7vwT2Aw1zDIFc62dEOW7UmMLIcw+oFU4fH0ZbMw2UcjGkxeHUfHVq20Ew/nbGW48Fubbn8WTZ0Tel97hY6QII+BcmI1fRAuqNwCsxIzRYdWMmV4jTmLXSvZ0480Jdh4ovDvznIyI2+OeYjAH3e88DurWqUTbIKWAW73G85N8eIbTuOw3kb6PsSG0IlVSEuTbE2fCItB0pYUSYhXkNCn7827D2ZrkJDnhGz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(44832011)(38350700002)(86362001)(83380400001)(38100700002)(2906002)(7416002)(2616005)(5660300002)(66946007)(66556008)(6506007)(4326008)(6666004)(55236004)(8676002)(41300700001)(1076003)(66476007)(26005)(110136005)(6512007)(6486002)(54906003)(186003)(478600001)(52116002)(316002)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H/XS2De/0xo5DhmjB7LwcfNcxlNJOW2wxdGkXiQ4T08McCeFZmheoAf75D9s?=
 =?us-ascii?Q?X21Wp7R7J3UZ2taNAO2Xdt56Zqro8SGRV9F7j5U0Apw2pFJ78rSn1DBwH/du?=
 =?us-ascii?Q?1INcIDLXmZvrOEmvaTadTI6HZ/6MIFACzSN3RiSuWAXqw/x0Y9l4azv7Ez/Z?=
 =?us-ascii?Q?d5B9Ozc/PGD3zOxrZn7gyRdrICBnXxfOd8dRW/e8bQLvzoPj6eOvChKWr/4d?=
 =?us-ascii?Q?hHzUFQ0kAaddOjxVA+J1JwVDerN61lgkZZHhY9/p9SJ4yppg037QMh1inFRJ?=
 =?us-ascii?Q?8U7qpTN3rY4s6LYn94PDP7ud5mpOsnO2Xs7xmNtElfO+nclkJ2mrSr2gJwE4?=
 =?us-ascii?Q?AFl4aUzDH5RIpgaBfQQWH+XqsjI5b8nO2FU+AlBVTwQeZ5LuBr9/RoHOZagh?=
 =?us-ascii?Q?S++0LvT6kVO+NUo1wlos9a88ytNp8D3l6qJFGWBPePl4twkgJgCPvVLMrOE0?=
 =?us-ascii?Q?v9TrBQXLXVksE8seLh+q63ZlL5X9H/E9CUoEpIgpaAUQjmEy2isQm/3DmAxC?=
 =?us-ascii?Q?VAP2/1sRl4hv5aYHl8J6h+Uy886ySedUhmouNFqBzUFX0HRfe1CUrvC1cSpC?=
 =?us-ascii?Q?07bYLiLnFcys5/a6HW0WCnchk+W7mOsBCYCWXiYJGkGooIr12VFGFj2kZ1g+?=
 =?us-ascii?Q?GriuISFP9Zy80dPSo7Mj/Iy24RyVVjC3zaBm0PYe4rFZTmDTy0wnWRO0U+K0?=
 =?us-ascii?Q?Y0omfhAlUq45Jc085t0dFW6IzaiJqicifoP/9lE9otC/omg+5Y05yR5sIDDO?=
 =?us-ascii?Q?T8TVr/rJjQQQR3hlwo6jmxRXjzt9hspFPAEh4Xp+ix3zC9F5EIWocmbYI5nA?=
 =?us-ascii?Q?9Oiq18PGrWHWNLSV0iw2wp+5jTp46XYlKDR2GPAI6H/AKR7tuZyDNlRQoBnA?=
 =?us-ascii?Q?r1u4QY2qhSm1p5ZnaDxkkfOjT8MxTZ/qeXWCOUuBcR7C2/NWMMYEV50dPoQL?=
 =?us-ascii?Q?sxkc7ip7AE1AFd8ZQg7sQHgJ3cvTTvHZaG2k+JpkDXI/xMnHisYJmdOUrVpZ?=
 =?us-ascii?Q?yWGFTIJKSqQy7KiM9sA8Y0gDFGSiRTPRHwnvzw73V0X2sNpK0iwj93QsBqlW?=
 =?us-ascii?Q?+tlKzrgPDn8ZQFTZmHCE+QpwNhuz8nyrxaF4iwePLFrEIi+GG0tZC0+SoMRk?=
 =?us-ascii?Q?OPkMWpI19CHSxcLpvISyWojl+ziaavkXhlK2mYlZNkxYFOYYBBTcb6+fQVzZ?=
 =?us-ascii?Q?AVkUnSQPjCW7h8O/hOM5YHt6RRyXAE8xIVNMvCS6mH2k+GUcdmQQV+UKpesR?=
 =?us-ascii?Q?RhCh1yCeC+Hc3sMvlZx9SJaD1/Edz1qNd0cxkfOKwpE8HceHxBwvikHpvFju?=
 =?us-ascii?Q?xWabGAQbEP5xk60n4x3pes2gvR3cwDKHJyuJRKCio8/7Z/Cih7EKHi91Ofj+?=
 =?us-ascii?Q?q4LMHph0RUCPzwSPIwWnTMnVmHvsT4zUAjfPGpHoD5g0XYm/eaGHE60uKqTv?=
 =?us-ascii?Q?btcRtM6+jQiwrhw0CS+klwmhyXqARvFuM8nzxYibYd3C9OghSPzfTuqRru24?=
 =?us-ascii?Q?xY40Rr/wUa2yn6lh8/Mccvx9tzh9xyWhe2Oux2f3OL3C/e1Ooalx3jZOLzlY?=
 =?us-ascii?Q?yYj0T22mdGooBDTEAg4IT80zFroLigjcz98xv5Uk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 872e23fb-93ca-4539-c90a-08dabde67cda
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:58:06.3712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6XzQpNY42v1LjuMWmKvFN8ozP/+nMuY1PmlX9UueUfPzm9/E2sqcjdN5ninGakt8wuGlkPRu91xJ12Btq/d8tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8828
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code logic of handling the quirk of FEC_QUIRK_HAS_RACC.
If a SoC has the RACC quirk, the driver will enable the 16bit shift
by default in the probe function for a better performance.

This patch handles the logic in one place to make the logic simple
and clean. The patch optimizes the fec_enet_xdp_get_tx_queue function
according to Paolo Abeni's comments, and it also exludes the SoCs that
require to do frame swap from XDP support.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 47 ++++++++++++++---------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6b062a0663f4..0c9a434e5b7b 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1581,8 +1581,20 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	bool	need_swap = fep->quirks & FEC_QUIRK_SWAP_FRAME;
 	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
 	u32 ret, xdp_result = FEC_ENET_XDP_PASS;
+	u32 data_start = FEC_ENET_XDP_HEADROOM;
 	struct xdp_buff xdp;
 	struct page *page;
+	u32 sub_len = 4;
+
+#if !defined(CONFIG_M5272)
+	/*If it has the FEC_QUIRK_HAS_RACC quirk property, the bit of
+	 * FEC_RACC_SHIFT16 is set by default in the probe function.
+	 */
+	if (fep->quirks & FEC_QUIRK_HAS_RACC) {
+		data_start += 2;
+		sub_len += 2;
+	}
+#endif
 
 #ifdef CONFIG_M532x
 	flush_cache_all();
@@ -1645,9 +1657,9 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 
 		if (xdp_prog) {
 			xdp_buff_clear_frags_flag(&xdp);
+			/* subtract 16bit shift and FCS */
 			xdp_prepare_buff(&xdp, page_address(page),
-					 FEC_ENET_XDP_HEADROOM, pkt_len, false);
-
+					 data_start, pkt_len - sub_len, false);
 			ret = fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq, index);
 			xdp_result |= ret;
 			if (ret != FEC_ENET_XDP_PASS)
@@ -1659,18 +1671,15 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		 * bridging applications.
 		 */
 		skb = build_skb(page_address(page), PAGE_SIZE);
-		skb_reserve(skb, FEC_ENET_XDP_HEADROOM);
-		skb_put(skb, pkt_len - 4);
+		skb_reserve(skb, data_start);
+		skb_put(skb, pkt_len - sub_len);
 		skb_mark_for_recycle(skb);
 		data = skb->data;
 
-		if (need_swap)
+		if (unlikely(need_swap)) {
+			data = page_address(page) + FEC_ENET_XDP_HEADROOM;
 			swap_buffer(data, pkt_len);
-
-#if !defined(CONFIG_M5272)
-		if (fep->quirks & FEC_QUIRK_HAS_RACC)
-			data = skb_pull_inline(skb, 2);
-#endif
+		}
 
 		/* Extract the enhanced buffer descriptor */
 		ebdp = NULL;
@@ -3562,6 +3571,13 @@ static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 
 	switch (bpf->command) {
 	case XDP_SETUP_PROG:
+		/* No need to support the SoCs that require to
+		 * do the frame swap because the performance wouldn't be
+		 * better than the skb mode.
+		 */
+		if (fep->quirks & FEC_QUIRK_SWAP_FRAME)
+			return -EOPNOTSUPP;
+
 		if (is_run) {
 			napi_disable(&fep->napi);
 			netif_tx_disable(dev);
@@ -3589,17 +3605,12 @@ static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 }
 
 static int
-fec_enet_xdp_get_tx_queue(struct fec_enet_private *fep, int cpu)
+fec_enet_xdp_get_tx_queue(struct fec_enet_private *fep, int index)
 {
-	int index = cpu;
-
 	if (unlikely(index < 0))
-		index = 0;
-
-	while (index >= fep->num_tx_queues)
-		index -= fep->num_tx_queues;
+		return 0;
 
-	return index;
+	return (index % fep->num_tx_queues);
 }
 
 static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
-- 
2.34.1

