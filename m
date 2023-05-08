Return-Path: <netdev+bounces-886-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47CD16FB2F2
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:31:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AC521C209D5
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A7517CF;
	Mon,  8 May 2023 14:30:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A4F11C89
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:30:14 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2052.outbound.protection.outlook.com [40.107.7.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BB2A244;
	Mon,  8 May 2023 07:29:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3QrkHXjSQSQYTPDfYdpfGAOkKLGLCGCMpEP0icgZjUeC2MYwHU+AVKQcnnFAdRFe4zh6ePbDdaNE3c+G8Rj2JPOYGTYPlhBUXxqma23LV8GdeY8AAufk1zbTUIEUK4V9v2rbqVk5VtOq+Wc/4oNGh3FbU7n9KjG+ejzggs2ok3RLM0pBc+hAR9eFnzuJmdUCIPNbsgDZzBfrs5HUtf4YlqGXeKvzB0C0FYQ6zxoo9tzxo+pEZqGKueQxvnEK764uOKDwFKTE/KuDiK5OSdxf6fYh6mTQUvHjiphSjmvA5aw00DYHCDcgII/jxeI6puZDNSzmMnFHobrX4nC6Umotg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Ak51wo9QF9+45g3AyhvJ96xnL8AaJnlRO0P2rBaUoA=;
 b=XP5bXeRKP4Gli1d6pjXAgiwB5vadGkzk1PD1mqcU5yCWj+KrA3tIYGSFu9xANov/nESoddg9RxrEG/2CXa8oChcfmzzcydJz8Zh/E98YZA+6PUdb6TRz3tGULcpMU/big1/8GO/Oluya7/xjX7x26S7QUeLlhz6Kc9CW53FqDkPDk4AkJPWUr/WgQiW19hIq+sZCJ9CD5PLQIrOGKvXtQD40k962zSFBU9xlHC/X4LQckipzs+TkEhnrHY4UMEp/wC2a3ioQIAKUzWUJ+d/wluVT6P4CEweBomu24Fjr3q1cEOGK0GU7iF6s20bp7Qr29VnTcEP+Qb6iEIAAlOoteA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Ak51wo9QF9+45g3AyhvJ96xnL8AaJnlRO0P2rBaUoA=;
 b=COH2butADl5C5zn7a6YeBff2mu8y3cuyvgi5aKTgk88M8TiiwdhSEnt3UpjVRtw9NdM0PzBuHPPjq6IbBpYD7wH6R2/fcDBLRpUW7ZWdfEg94Si+1XBcbcJ3aBCIPi/3Fu7Lh8/haeNfG/tsAkQ2eaxZ9k7Jb7ye2cAoMd/Zigw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by VE1PR04MB7325.eurprd04.prod.outlook.com (2603:10a6:800:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 14:29:43 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 14:29:43 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	Gagandeep Singh <g.singh@nxp.com>
Subject: [PATCH v4 1/1] net: fec: correct the counting of XDP sent frames
Date: Mon,  8 May 2023 09:29:31 -0500
Message-Id: <20230508142931.980196-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0066.namprd17.prod.outlook.com
 (2603:10b6:a03:167::43) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|VE1PR04MB7325:EE_
X-MS-Office365-Filtering-Correlation-Id: f57a1871-9ab9-4695-ff6e-08db4fd0aa2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l9HMX+LpEafX+XysenJ5XaEPjRZMDpWMXzrhIjuOmMlmKKHx9yhj28Nx2C5AQgSfM7/qYKvLe7Zlgr1RGWSt9lYUXwozRdVd063E8JJP0KkuQFpsBUxZhmm1lnQdZYzoKnJAhHFeuCFZjPTQB9J/Va5GJvaby2lvomJI9EWvpvi9W9tY6hYCSVV9eIDSTSZoTUJNLQHNzIoUpOhfWRpIcfxk73HJRVz4EPBDE4PouOnFo6NGoAX/6gzuVN8GnKu5uq8ENCKrMKB5NW5GVuzCxmA0gbJmPsp5FDZ0LbCFW/HV1QkgTjODa0IW+3LFv5jZ5ROIpSk24FDTBpqH1TSLnW5x1AEhwYiIMg75w3xfywVtnobsjBDHSH6yvaabU/U+x69/eNhhCzWbXDVV9GAhzBCvxuoPIWMS2wyOEfTlHV4ZWA/oTA6Nof6rKtKQVCgiFNHN6B0QdTpCf2SwIWsfw25u0yEGxuc5H/B3iZeNafB/tB273OxXoME5xFmQND48DWJOVpAVonVtPrIh6VyXGoico+sFUdeWwCzz5Ie9Loj8+EEHD032APB7g64M4K/iQvGsVNRslI+YUiWuJUUt95m2ltYTh/7hm8Q2A3j+2xVv11YzBdXCfBrvF8UB5wXi
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(52116002)(6486002)(6506007)(6512007)(26005)(55236004)(1076003)(83380400001)(36756003)(2616005)(38100700002)(38350700002)(86362001)(186003)(110136005)(44832011)(2906002)(7416002)(54906003)(316002)(8936002)(8676002)(41300700001)(4326008)(5660300002)(66946007)(66476007)(66556008)(478600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hgnbxc8IgYLEsvjYhscFU+VAKlNQk02+Nj0bV7zwomzMN48tj22xQxxCEANr?=
 =?us-ascii?Q?Vl09S1iV2CTZhxw7T44JIm2UZWL+17J0nYNUhOR1BdpB5XGM7UaXQXWfnkPX?=
 =?us-ascii?Q?MshKnqnHfflCRUKESGg+rlXzZJOr/FtTHNB+Xqxn488YH81eG7ZYGITZQHuX?=
 =?us-ascii?Q?0uM8qLWtIZHd0LLxY2wOuJWccQiIMatdQTJ915qGBAC4WzZcux6ylQ68tptd?=
 =?us-ascii?Q?UBGbQ9XPfO3AVbIQq8TLX0OLHtX7gYaRbEvT3wA7b3M7EvHiMYAHsocyqYSS?=
 =?us-ascii?Q?JG4PYLRcOsCi9OClsMlPTnpB67Dc24UzArMOJosNRdIgA7yxv949hnNWQojo?=
 =?us-ascii?Q?3n63KR5nUUKoNCTlTuyRCuOcEbVeTtzqzAzhXuTmMVQ5MNh6h3Yw5VsDhaLj?=
 =?us-ascii?Q?9QM5QGz9JHtsf69l9j3H+xNzzSWglO+UzYgxptTC/LSTB0HXzpMDi4BM2riW?=
 =?us-ascii?Q?zqAEiNFVdpx8x9v3FrvjqQBdhebRcWYkN56zE9Ht+kr26PmoFoEysBHQPrUb?=
 =?us-ascii?Q?sevoromuZno1bmG2X6xDry+tdUh09fxvef3uxM8OLsAQKAssHUaa8WcOBd7S?=
 =?us-ascii?Q?Jows1cRyiktrcfmvWLz07pNeWyne7aL1w9P9gTLLFS7YRxwo4j7WcKcIGN+A?=
 =?us-ascii?Q?EgYVkG0zauciChxT4fV6QmwPBwEaFY7NmHdyB/K/zx9+jY4WoEcqOpyhTD57?=
 =?us-ascii?Q?QrBdj/gb6QIdWxlzzL/XiNyb8QWHYsb7JhXv1OaLOEUaCdipmouyUMZjU3Vw?=
 =?us-ascii?Q?e5gOJliVbbUl2bVipTfUGJmInNTvoZYg+8dbjjYXTjiRMhbGNFGDuz5M9Kyg?=
 =?us-ascii?Q?zwizcyQac3qzb33oLEC3TiwzNdgMwPQSd0lC1TSUCbTnGBPFMNnDJsGIBo17?=
 =?us-ascii?Q?v+pplU3VOs1S9ItAxar/bGuIBZJ5tWWljcoh16GxUFAEY2fCnieoq8EhqqOA?=
 =?us-ascii?Q?s9Xj4u89F8Tq0eytAob8rYKMzC04rYUJSagWP+rRIb+ZgB0Cfkj5x6BEVTmo?=
 =?us-ascii?Q?vZnvlUJxVoKU232mEuaJw0xGE5CWBY3BUy25ZHnOWweI75c0E0efrU5K26sq?=
 =?us-ascii?Q?eemK810OM1X6AcB/Zqou5La1V6mF6hozbudAuZm9w7z02ZQf74gbsfR5rDQ0?=
 =?us-ascii?Q?MvxaV6l6rwQ1EE5PypMKPjpugaLLn1z5UbnUKUisPW2ctnrt665/K/SCVnyf?=
 =?us-ascii?Q?iwoyb6T/qWFN/H9oNlr8BSNakjOC7cf8robobeCWCVvAM3bQ2LV1RsPeAwk7?=
 =?us-ascii?Q?IzEwv/RjRolyKZvk4YYyxiMcrQdxDD0N7PtnTRKOrcbS9gP9g+visQgRg7DG?=
 =?us-ascii?Q?kT677w79Oset846vxSoajAsHkhDDUU5g9eYs177X8J1JpnP8UmpTvlWfNDVn?=
 =?us-ascii?Q?pnDKmaIyMT6lH/hQX4/kbkHnuJzuzeF5sY4FbiknVkiLv7tul9S0rf7Lv5aw?=
 =?us-ascii?Q?YlESeGEsLhWFTrzAc9lkCYWmIBVoVZQSuHQg7chYJ9ekKVieX6BJm6x6cXpr?=
 =?us-ascii?Q?uqdIue86Qkzq4WRiqYkCfIHvsFrPsgCDfmFHSn+SZhYhteman6QpuxxBF7Gr?=
 =?us-ascii?Q?fPnwUtQ/D8KwScda5IwL08lzkqzQIc+GpRqaUvjB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f57a1871-9ab9-4695-ff6e-08db4fd0aa2e
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 14:29:43.2891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W43ZUhLDCXKQcMPJZsUGVi6GWidWLj0Ofb4gi6atbVD6CP02Z4rj2qKOQKXUUCYR+KUqmF5IE2tQX0XcjqsmcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the current xdp_xmit implementation, if any single frame fails to
transmit due to insufficient buffer descriptors, the function nevertheless
reports success in sending all frames. This results in erroneously
indicating that frames were transmitted when in fact they were dropped.

This patch fixes the issue by ensureing the return value properly
indicates the actual number of frames successfully transmitted, rather than
potentially reporting success for all frames when some could not transmit.

Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
Signed-off-by: Gagandeep Singh <g.singh@nxp.com>
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 v4:
  - the tx frame shouldn't be returned when error occurs.
  - changed the function return values by using the standard errno.

 v3:
  - resend the v2 fix for "net" as the standalone patch.

 v2:
  - only keep the bug fix part of codes according to Horatiu's comments.
  - restructure the functions to avoid the forward declaration.

 drivers/net/ethernet/freescale/fec_main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 160c1b3525f5..36a3ee304482 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3798,7 +3798,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	entries_free = fec_enet_get_free_txdesc_num(txq);
 	if (entries_free < MAX_SKB_FRAGS + 1) {
 		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
-		return NETDEV_TX_OK;
+		return -EBUSY;
 	}

 	/* Fill in a Tx ring entry */
@@ -3812,7 +3812,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	dma_addr = dma_map_single(&fep->pdev->dev, frame->data,
 				  frame->len, DMA_TO_DEVICE);
 	if (dma_mapping_error(&fep->pdev->dev, dma_addr))
-		return FEC_ENET_XDP_CONSUMED;
+		return -ENOMEM;

 	status |= (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
 	if (fep->bufdesc_ex)
@@ -3856,6 +3856,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 	struct fec_enet_private *fep = netdev_priv(dev);
 	struct fec_enet_priv_tx_q *txq;
 	int cpu = smp_processor_id();
+	unsigned int sent_frames = 0;
 	struct netdev_queue *nq;
 	unsigned int queue;
 	int i;
@@ -3866,8 +3867,11 @@ static int fec_enet_xdp_xmit(struct net_device *dev,

 	__netif_tx_lock(nq, cpu);

-	for (i = 0; i < num_frames; i++)
-		fec_enet_txq_xmit_frame(fep, txq, frames[i]);
+	for (i = 0; i < num_frames; i++) {
+		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)
+			break;
+		sent_frames++;
+	}

 	/* Make sure the update to bdp and tx_skbuff are performed. */
 	wmb();
@@ -3877,7 +3881,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,

 	__netif_tx_unlock(nq);

-	return num_frames;
+	return sent_frames;
 }

 static const struct net_device_ops fec_netdev_ops = {
--
2.34.1


