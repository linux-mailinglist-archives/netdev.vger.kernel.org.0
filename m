Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19292618E6C
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 03:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiKDCsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 22:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKDCsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 22:48:13 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2042.outbound.protection.outlook.com [40.107.22.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB991D32C;
        Thu,  3 Nov 2022 19:48:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0kQua7gw1ftvjbEodpftXiS0EPbGWytJsdPgMV1IiqsunwJLpxDo0MxtJg286n3/lRzcHN6hco3Mi4tMZwRXBKtAO7VncOPse5GEHRID97ZUV+TSqenVbUiu5HxOFAHt4jksPQYFV9+x2zXF8iU3eDgs8VGrEDmrdBk8cht4+w+6db80wO2MCroDsRrV0vvnV2+uYEWVzwTJ7veoLj7H26IOqnQvFNfGkZE3dcjTK6jVZY2AR82dZkAZQQ/DUQ7pVi+qB6ozui1N3eP7vR8ngD4TISpyqFiS6gtxgDpjHE+RnAAwlBc/oMtb6MMFKoU6dRxgwlD5oNiLTFVkh08Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sM1JLE3QexnGp2o5HIqCWTMb2IeV4z8+xNSA12RTcmA=;
 b=S8G8eIkfMlBa54H8Oq6ouyV+qsB9P4aclidT5eifuu6Vl4ODqjWlZ8AwhnZuQYTP6UW+okQB3a8GrAOvup7ITrTSTrKVdhtyMc77U8TV4VQQ4cfJqKxTQWrzWCAiUuXZD17e4sLW6PSHduSdGy7dXp8KACUheSQt2uwxLiRYJ1uwhrQ/RvIOULFOU5Rw5PrhG8ItJYOc3GIfQuVHOoPQ+AVYdA6o+qhXSZeXhMFCGVVMrDBBHW8P5qAmwKuCk+Ii3n+xnDp1g5HMg7wt2uNlpxMLO/fekuC7eCWQGTWQ1OheolkLTnjD8tvgRvKlWDn+FuIfakg6KWvRtqHJDemuzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sM1JLE3QexnGp2o5HIqCWTMb2IeV4z8+xNSA12RTcmA=;
 b=n747n/eCpWkOj6Ft9Io96rW6aijnofydJB0J9KhJKBn9V0wRzaI4CzQYmYvW1k5Ghh5KcmUb/6LympNFF909Atja29ooqyyXCtq7/R4696eSjwX55YRA7y6Fly23oYd2qkSnkoE07E7UMKjlHS6hPdKhE5aJfAbJZ4K0ex8/Gqc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PA4PR04MB9662.eurprd04.prod.outlook.com (2603:10a6:102:260::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 4 Nov
 2022 02:48:09 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 02:48:09 +0000
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
Subject: [PATCH v2 1/1] net: fec: simplify the code logic of quirks
Date:   Thu,  3 Nov 2022 21:47:54 -0500
Message-Id: <20221104024754.2756412-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:806:21::11) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PA4PR04MB9662:EE_
X-MS-Office365-Filtering-Correlation-Id: bf2c0414-eef6-484f-f674-08dabe0f020a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ep6eOnVdtLWNqGjrfSg7Ta0oWIkDGMPj+NPfoZSumVayaHmpCUTST6Zbo753XZdVN7xzAzOK61xEtSW5yIv+cldSbXD4ncrPe/U/iCinGzDOc6thZgDtrnkOkmOySz5BpVPdZ1txP+LstVew2gXedxfhRF+09G6cJdUGB3rY9TknucwJZGTW6Wcm9+87VT/uAg00xpocwQ25YaJpeE3FDnk7qIe5JHCcH/0kQDe51kx8qkz1qaz8ccso/ZZS743Ba0ZYQn1cPF78AMKy+3Zc7MnEPxd+LM5rUg3nE49ymRwPyi4vfGJe0+gRuXwJjkeRpF7UEs+OKvKWAf5kWjwulWpRmGz3kxEL89vDDBDPSb0HQKJeThaBdsoFU7IY+xGbYR5McQiQMlndZkSI7Aoy8PuMBwHDpb4MsoY5I0hy7Vs4B5x8xFGDVwmWeDfT/2OOyfR2FJNun7xrKw2yORSzgJDE7q3v9KJc3IiG4TldCJ8XXxGsNQH0dVnczGxb1eT7NXiLQbrSHLn87eUZV+D4308ccPf4T7XwQjgheIwZvz0OFqa1yAhwyZUcoA4NpvJqRUQUkRh2QUJ/kJ6EGuFPeK+mQRrTU7CKrqvAEj/CYjh9lLTzaCzul6ZH7P3r5STD3L36qMYLwW0nHZ6Nu0V1yBtQXE+h5u3d/fqFstLEmI5Ip8eePnPUVxe66tkjcGJ2l/e1vdtIJZo2Mx6s4mq8HNDNGLrQJ5rIn1pq1yy/EoR3cnjTBLM8PWowGNC6jHgi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199015)(7416002)(2616005)(186003)(2906002)(6486002)(44832011)(478600001)(1076003)(4326008)(6506007)(54906003)(66476007)(83380400001)(38100700002)(316002)(36756003)(66946007)(52116002)(38350700002)(8676002)(55236004)(41300700001)(6512007)(8936002)(26005)(86362001)(6666004)(110136005)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NB13uX9D8aibkKKHQh+aF7FinMAsNKYzw15jG3dYeSNylFA1/bX7CEGsLjeI?=
 =?us-ascii?Q?q8Fohd4o1hVC3uOMUsVrhkM0e38usx1b52qRzr3ITYinwZR6V8LVhOnpOHPs?=
 =?us-ascii?Q?R8iifnO7yFOHxhaA1XKG/TAFTYjt6038/9nmn93OS54yCbR1ryLwsHrMiNjr?=
 =?us-ascii?Q?ui+AIbkVKmTf6UfXu/GRKLEj9vXYNOxF9VxOcZ6F+uperqzZvi3o5lbPoWIN?=
 =?us-ascii?Q?9qQoDY2uWDVWv1IZAV6zZtFyr1HObdNI0UDw+Q/YzlzxxW28x11kaKEsPNcK?=
 =?us-ascii?Q?XO39z0MqgyIF92U4tAFJVixnsnvayxwEmJ1iiAaAzFYEga4o4Q/SFZShb6Eh?=
 =?us-ascii?Q?GElPN19MdMn0E3+Cse8BnMve83rWd0/XTSYLZ5TUN39ROD3wns7yJXovvgiu?=
 =?us-ascii?Q?rH5JENMrvx2htDIuxMpEDcbXyOr4JVk/w5CLnjbCSOxbaPlV2jHAJsQMZyss?=
 =?us-ascii?Q?5GcLUEx3p91IYrHYsLK3RGm/JHEgEvStQyp6ksDdR6QIygodB/T2MirmHyGv?=
 =?us-ascii?Q?Fb803TY7OBALk5/ftuy/CzfxvDVjGuainoKd3+a3lbXrVKUbA1XPOYHbckFu?=
 =?us-ascii?Q?hrZpfMnVHZkAydL0wrBLZWrHLVvWxtbZBvOxnUQMEZQUIJuEv/Bk1iuaLznu?=
 =?us-ascii?Q?o5G6pSTxGzTMNwynurn5rCjnBIW+0gy/oPJCwhuef0rZ1QFkQId2zpB3A3Bv?=
 =?us-ascii?Q?Fv1S3zgq1A7gf8mlJyHYrJCB6o/teSnNFwKLtP6dM6GhrPHYik/pCojoZ/CK?=
 =?us-ascii?Q?12011Q4j2uo8T7RbjX8IzX2tzScM9SHFJbUMRg847ZwCEAFFbqpKPO2px2pP?=
 =?us-ascii?Q?EUGemL7xDwbAxZYxDudxFqu39mZkhaaYrztbKYL6ortG4Pi9M1Saqz+e13bg?=
 =?us-ascii?Q?Qw4l5T82YjqDdfk3HxLJtzmt1/Tr/Jz4pNhM8bXBocDcntYKFdNCovI7jTXr?=
 =?us-ascii?Q?/akLXw7osenTiZ9zLo0en21xxa/KnP3w5fqpshf/MOcB6T8zhUm9gjgQMkIk?=
 =?us-ascii?Q?G8T5tUWQtEkYjyVXSvUA6rEMPXMTkOUcQtTrzAYHAAS57QSsRumXa1MbfLXg?=
 =?us-ascii?Q?Q23EtkMPpUwSk4WPl4KKUo68E5WlPMcM+hGSF+a6y0uAevszDZLrEu4EWf2q?=
 =?us-ascii?Q?wDf0I3tbSnKo9xYR2Jd5w8g9cgsO6eKT+Ci4AufySnYo2M8Tk980tCp09s/w?=
 =?us-ascii?Q?JayFoh+GeAH3X3U6OEGhihv33Vm2iWVxar5sc8g9Oikshtmd650BWSpl+xZ+?=
 =?us-ascii?Q?buhZERS8+Eh4y+o/zLmyAkQMiQlc+UAYUWx3uGF5ILzY5E3KAM+gMveyXbGF?=
 =?us-ascii?Q?0H/CHu0H4ivZXG9A/4Z1xGPN98HHfOFcgdYZwpOGxZKbIpHissklCCm7Il7n?=
 =?us-ascii?Q?pULSBSpRmDP6W56Ho+jbX1dtOj7a4su+aSvMf0onn5SXj+3VtWMHnpGsanxq?=
 =?us-ascii?Q?QOsbt20IdAieoy9dUOyrJNfBMhvHrNX0kv6U9sBFAwo92PPXwyqFxu6vRLCq?=
 =?us-ascii?Q?+JjQNEnaPRNE/jXUCO46P2N3B9wUjmUA7IPKWju0BO8exmBB5kOseeXfNoIu?=
 =?us-ascii?Q?ZZAqsnR/BzdrAHJ66YNVUUnb4PLRdQaB6plWY6Qo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf2c0414-eef6-484f-f674-08dabe0f020a
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 02:48:09.6749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kuDStLbw5Jp5bP/qX82eSEJBsBxO5tHnSTA7lhmikjOHB3leIb+kL7yjubeBjgRf/kMokeVP6/vD0qx34wycA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9662
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
 Changes in V2:
  - fix a bug. the "data = skb->data" should be after checking need_swap.

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

