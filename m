Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307A4621A50
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiKHRVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiKHRVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:21:39 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70053.outbound.protection.outlook.com [40.107.7.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA05A1AD83;
        Tue,  8 Nov 2022 09:21:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlCoH1QLFWXrWSAKgYU/1Zaykn0kmlrUY9RIbaU2AmDwyzbeEafFaYcoubNicHCUm1WLhprHRnS3HG1cTHi8AyexJcWK9nvL+0/i85lYWjvSBVuebvHgvLY20pKkzYCT6DHwQpPw+bOAC/mTax5dmX8V/hap3ep5baj4FkqD0Rp+ywcbmyqpbvPyWr+G3L0GEiC1sjqiXzqquroLOJ7oSwsWE/EprtJeL3KAk2g5MEh05PzMJ+jxuN7OLIgEYjERfiedu6R5yqNq+em5Zr7ibtOQw1o+5NSfNal3TDk9PpdncouePxLIssl1iI6NQnEtrNF+NU0hqcWJN6FIz8I0Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBQbjC/nrO2786LNIfK7WsUT+HcBlkTgsK7ptHxzTbc=;
 b=OX9gpJ9Oq3zTb3Ck+Cse1T6VBXMfXVDg/gjdgr3vqq4bY24fr3wZF5P1hsQWWKR48Z680MYs6B30si8XfVzCiUwUm2Zq8P8H5nXzcQNRsEggxfRmQK14vImCObqrCjShDXvBrMh4dg8uiBj2/1oqLHSHAozkE5CH8AC7A5XW/jU1SQUsJzWAMUib6OMp2HyY6FRkasM+0wViMucmOdTGHIklj+toRJ9B9WGRDZvIL4d5s+hvYkFiNDtmTeG9jAUrj9yWLD9hIL8Kabg/p4IY2q8CADrubGMvF8+0Oy73b5cRG0jCaDxM6CgHBSMD+l9rQHA0fjMKxszavGpNybZpbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBQbjC/nrO2786LNIfK7WsUT+HcBlkTgsK7ptHxzTbc=;
 b=DJlz4OBSEYee4PfwkaCas8bWTthZqAHfJANupBFsGYbum98/wCE+nQVOd8W8lYCouvwa9kEH+yRpvIi7Qa5XnAq2VMuYd4rrqbygUPhE+uxAI0klttImb8s67gvmlpu9/4ooGwSdRgLCfWRF0RF4xHHHSbCh0m4viHRLxg2bvRo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DBAPR04MB7334.eurprd04.prod.outlook.com (2603:10a6:10:1aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Tue, 8 Nov
 2022 17:21:32 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 17:21:32 +0000
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
Subject: [PATCH v2 1/2] net: fec: simplify the code logic of quirks
Date:   Tue,  8 Nov 2022 11:21:04 -0600
Message-Id: <20221108172105.3760656-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221108172105.3760656-1-shenwei.wang@nxp.com>
References: <20221108172105.3760656-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0113.namprd03.prod.outlook.com
 (2603:10b6:a03:333::28) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DBAPR04MB7334:EE_
X-MS-Office365-Filtering-Correlation-Id: 15645daf-b847-4614-c976-08dac1adae23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /SJLxU270lKy87tY5da6IDfjhOn+jNDoa+n2AAlKr/HVoeBOmwVgR5ya7i4ZK1Z0swy/pL+ByQ8Uek5uUEU2NmJq0eftVkmzaSEqX4J+FqpNCDdRIW77MrSDUH1VK9Ux9F63jR8e60x5IvT1H+39u6s7X/9/WDuKwNhAsD9X42a6Qj/8rakO4A6BngPzhYICAw7fQrP0rNfw7S4Ava8jHJ7l78y+1vpcNLEFzdiA7HVzvHXCNMiHGAE4zRieEglpGNfuRcoALP1kZ6tIP/nowcMZhbGmAJb5Ow6QtVbNDQ9jEev+lIhyxUDv6GNPOZfaNaDqmlL5ScQZogmTiRSG6iu/Xmf4iuwbwCLNmD6kvShxov/40aE6ZbaBQVdDa82b3moR8AH90RRVg+g6yOou42uaZLL2E0WGo5GgPMTgrixSQpjYTSaQd5dJRYm/skEC3FBXT1MSLV8BxKtUmuXtnD52Uwmk7aFF5mjlPYs4be8umM6jWedYf7uTZvQBu6yn+ItnHARlV/5EVjthi6FK4Q/4XPPMVcBCsBPsWrLDm91QOFKRZIK2G2zC3Cm4HEfLmGmFc1iYKFDarsHkXM+buyMYEqbeerCl/oiYQzxwhAYrOhSxfN33N213FfT40OxTkWijjLItRC3CSoYbWSfluBRJwfbVlxthbPJfc5VYh+oXIjlGcI3VyDpH8WlvMNJItmLxtPXFNTIuoQyCSEHkB2I3Cxjt6Gmk1m/6ZI1gu6dZTbL9HT65bpIALjf4LZQ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199015)(36756003)(478600001)(38350700002)(38100700002)(83380400001)(86362001)(2906002)(6512007)(26005)(44832011)(1076003)(6506007)(52116002)(55236004)(6666004)(6486002)(7416002)(5660300002)(8936002)(54906003)(110136005)(186003)(2616005)(316002)(66946007)(4326008)(66556008)(66476007)(8676002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BvPvwvkbVC/x751UjYlbGGDysDpXRS5qGcYnTA9wu9HEcvOid+UqW3Zz6zLH?=
 =?us-ascii?Q?BmZSMhOz8QL21Yl4st/nIyyXPR6DDnxzT3lDiHxKrYlFpTVcIEyXkSEkwKPA?=
 =?us-ascii?Q?bOMEjYVanpVcIH3izFW7jUtbgkFfLMr8YPb8rVNy6aJGXxqenE0xnGap2Bdd?=
 =?us-ascii?Q?R9FVt6SZ5u7+ZlXZ5zyQRRpKGiCduzp3DQK9XX0+7GdzGvvSlJ4QKA+DWt8f?=
 =?us-ascii?Q?WX0VqvaOjgrcISOsje0rcSDwDL9t09B+BeB1OXG6Is8W+thl8m0RVRNGeSx1?=
 =?us-ascii?Q?8pjtULEa1aHFHFYyLLEWh+loWUBulFhmtW6sl+i4CyhSCgbfgtItHjPiIpSj?=
 =?us-ascii?Q?Al671n08mr5E6TE/AfFPmlSr8Qr1CYSHdqWlfUOfkUx56SsbQuRqanZ3csOd?=
 =?us-ascii?Q?tnBwYJilCxmLyHVcreygAxg6hXcuXa154g9FuTj5bPiKIC1+pzt2LhE6+F3Y?=
 =?us-ascii?Q?iAxg8NqYcaItZrordDFaU6/wmoIi7z2AA2rFNReQ4sWn73AH4ce8KEDXr1Um?=
 =?us-ascii?Q?tzCHt0T/WXI0e8c7lslrpD95lZEoAHu9naScLlxkhJUdvC/16uwcPGp0j1nY?=
 =?us-ascii?Q?0UY7Xmk12otBDwRPe1gYAn9Ci24Bzr7ZMzXqvdLcePbhzJzKhZZI6nP4eB17?=
 =?us-ascii?Q?CjbNXFyZFw2zEzfh5FtkzPs+m1IwhpPn5hUVlPGiWavwDJ2fgxbm/wWgkZUl?=
 =?us-ascii?Q?FoX0I/WCXSe664A7YVsWyZXNaxs3o1FFYqeKb/o3Djw90Hj/zeaRtbBdLziz?=
 =?us-ascii?Q?gL+gIiRJkepfzMCJ4gZNhOO/SI5nXxf60Vh28DbeeyAPbqknc6A5/Ou03BnE?=
 =?us-ascii?Q?dgeS4cdRdHhUZkVtIDTBK63269a6eDYdKSGuRmZ9IAdjtYOhXNlqI/geJY1c?=
 =?us-ascii?Q?OzXhXg29c7EtqYM7d2r3lNxp5n/ynzdUQbbzniTLanydDovXEg74T/3qShl0?=
 =?us-ascii?Q?E2vVFLVtxZpvh1RDjo/A02WHeYv5K15cStneNlVvWz1JhLR0bSCn7bx7QdWe?=
 =?us-ascii?Q?b4+bJ1A5csQvJEEj/XST8XYBlRz/M2FuPkKFom54OlG+tIJRB2QIHZisTbYP?=
 =?us-ascii?Q?+x386/tZg7zHGDvLdquc6eoahVZJBNymqbt3Q/T/5CvZEx3KG+3SOzDWVblY?=
 =?us-ascii?Q?+Od9w3dFWZ/hNEGqLyjn8bJWeazRHu55KWUNCJ9hAOcJqs05iR1fugUQT2ML?=
 =?us-ascii?Q?NgK9Jr92WW+t2PKHW/uEKL7GUEJNVY8aor/rt5FImYN5HLwwCgm2bXC0EN3O?=
 =?us-ascii?Q?dq0nYtgH5+nX79s8KNh3lqnb5h/vKqwjAKHXOC2DFRnylKslqjmmioeDDxcA?=
 =?us-ascii?Q?WGhXz20H0YJHvJMcTjZmpInlxLJLyCq4rx97ZdCKOQnfKRfJvXhXbLafMFwk?=
 =?us-ascii?Q?n3cSRliqbjvHoRv8whq5xUBuZkD+XzhO8fCwhOPkrSaKjVRKs4caJX4IAygI?=
 =?us-ascii?Q?Tk/vG/dH7BASeU9Wa2J/T/8/hg+bv7zvQgyuKHGJ4KyQzEfK5mEPMYhQGwEX?=
 =?us-ascii?Q?GIHl67/qqKQMfnAj/nZfymiTL9TbhanawPj0ec1aL/DXgY+Wb8okpU/1FiEU?=
 =?us-ascii?Q?4UzBk8rjLJjPDgKVkmW+YYNiEcgX1JWGn4T/bOOB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15645daf-b847-4614-c976-08dac1adae23
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:21:32.3621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnF/xrYC3PVpahW0Mn88+SaDQHgkLwE0DsY+7fOpgJ+0s91Rh2cyrkzF5t8WJm2jf4HvIqeKcLc0CyenNW1YHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7334
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
 drivers/net/ethernet/freescale/fec_main.c | 49 ++++++++++++++---------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6b062a0663f4..3fb870340c22 100644
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
-		data = skb->data;
 
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
+		data = skb->data;
 
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

