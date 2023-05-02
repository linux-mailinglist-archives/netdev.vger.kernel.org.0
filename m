Return-Path: <netdev+bounces-29-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F09D26F4CC1
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 00:09:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 911D2280CFE
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01190AD53;
	Tue,  2 May 2023 22:08:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F74BA24
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 22:08:48 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2088.outbound.protection.outlook.com [40.107.21.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762AF2718;
	Tue,  2 May 2023 15:08:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mmtb5E9gNLSSW1her0ZafSP9c6ljYQsR6sn6BQrRd2A5z70zz9rv1bOpUI6bHmz5Myc1wTJ1RUe1JvDnr4nLHW/A6lCeWn3ke33V3n9e2uuw6r7xq4cbdUkhmd7xFK+uK4i/XxHW75Vcbu7g4QJ/R1eV7YPzZGB+bT8i1dFJ/1bTEj9+CvW3TuCRe+48HeRkaRNy4+JKKmtkUTx+zIi2awbcXY7CDUyZ2RF1R9oZZkZ9Di6yLwAnrcSdeXl6Z6WXoB/7YxEx3gU2GafMrmnf51l11uELE5PHLA2enRYYeyavIdS6KsoFtyANCfoifAterbDTESi1OWoXl6gvxDlGcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/URwLz8UVdnAwxQunp4zr4XBH25d6pXSNWRB0wLBBA=;
 b=Aa4DdY7e/dtbxku8bGkwSQJ5skJg+VaztNQqMvN7dyQezIbmZcfEo2ElB+rSiWbklctAapx1+aHM9UkO8hAwUKqfNFDf1XZ04VcMcrMTOrjTt9mLrfOemEhRFfTJ4VjlgPgBrNKQzlTtKEpbTwSdySk2pZS5Q7uOScEQ0DRaZwjpzmEhu3Zs5Kc2BRkUkG5O4PNaXX8a2WEbCJjpKVPuumGSPI1t46KHQWOqccdihVumTxGErCg0/zcZIyEOT+7JrVeQJAwWEBCGZSKg1ilg+LVHCYCPJ9p5Ea2fo0F6QO9WfRgPyo9AHK6sLsAF3g3SP8GOy7FzbUCf0jga+RVbEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/URwLz8UVdnAwxQunp4zr4XBH25d6pXSNWRB0wLBBA=;
 b=k3b/ZTuibIdb8bMgY8gtqNm7Q3gX+2ZjVucdwTnhv/wwGSnZkc5ojFtYby5NvO4zwN/WTH+8CzQZ4gFMn9d3qd6WktjFINfehv/VUV9UvKNDrWw57B0NqYHgVFZLP2jvrUJwkhX7GMW7qFNM7l0hhY2BGgoPek0yQpxe6OZIqL8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PA4PR04MB8016.eurprd04.prod.outlook.com (2603:10a6:102:cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 22:08:44 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 22:08:44 +0000
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
	imx@lists.linux.dev
Subject: [PATCH v2 net 2/2] net: fec: restructuring the functions to avoid forward declarations
Date: Tue,  2 May 2023 17:08:18 -0500
Message-Id: <20230502220818.691444-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502220818.691444-1-shenwei.wang@nxp.com>
References: <20230502220818.691444-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0069.namprd02.prod.outlook.com
 (2603:10b6:a03:54::46) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PA4PR04MB8016:EE_
X-MS-Office365-Filtering-Correlation-Id: 890f6969-f5c2-46fc-721b-08db4b59cb43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NsQQTHuUcIC0vmBiFKE0B5H18g+6IlPsQaHeqgJ4PWwsppnP3/PLpIcFIoniafHY/Fvked63SR4e8dwZXYQQTKAYylsRxGJjltknnoDiiaUeZp9blTYTokw3D26dVvkyNe5wA+SgUozlJO0aLVEn9lOrqlaN2GLhZyahbE0clyhTSN/s/6QcrN7/lQarGCqFy2tGup3LuIBApewb3ciQRQPOCQ8kmy5K7id7iVsza9Tkku8PfpWj13eJh3Br6AMZzhGSltj3LTIFU7Y7HvrBCYxr2M2NPn3T1Et/NuHG6Re20Qy755MLHJjbrPrHKywalqaCebENgfS5m6YFuXyTsL2jfcDN2FGhYi2bKaLw6UTzVqyZ3HQdxtTrTfpWjzOMukBSGoEhoP3/14ipeifKsqxksLZYjomcIu8XOiqBniIW8qnVbpkSQzLkDddXUVO6XGYmwL4QInxyo9K6yiYXrSJzpnNgDP+NRKM8ATFrIHog0hpd+MuYQ5ZIpEI80aX5TcFT+rDcPU0B4gyEVzGDKQ8Q4L77SAUR9YVGdIhUyJoukKSCMyWdmqiDWGEjKzIdOojhXYyxcTTSz1GENxRCLUzKNLEDYuNDc8Y+w4W+/v8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199021)(54906003)(2616005)(478600001)(83380400001)(6486002)(6666004)(6506007)(26005)(1076003)(6512007)(52116002)(110136005)(4326008)(66946007)(66556008)(66476007)(316002)(55236004)(186003)(7416002)(41300700001)(8676002)(5660300002)(8936002)(44832011)(38350700002)(38100700002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZVd/cHyjgU9tOEHwOVgiZzIPXFV3+bsWsuIvZg0puRYFCV8kcGAIy8aG/v7c?=
 =?us-ascii?Q?Gqzv86RnlbDuyAiNU4BdKIhK0ZZ8XyXtWpOVVEQeJqp6GhwlJYWMNIqpHIjG?=
 =?us-ascii?Q?rxNbckNOzxcmm3W082tsOW+idZHcAbKwT5MwIrwDiT5BSg1cItxe0OdZEEt+?=
 =?us-ascii?Q?541z+b37qCVmAylVnScWbQqvXE2jRrERLSgEW42XrqSBydRW1YMO4HTdLdTK?=
 =?us-ascii?Q?23B60X8eebmVIFUPsvl8QKrqpvqAqpDgBiOrzNW03ttRhSt6BkpCMAvzWaIu?=
 =?us-ascii?Q?vVu41ZAoyTqnAZJK9q7ckpkbwgORUIDMeCy2cjbER1W+0G6Vr3KpDbAY2Nol?=
 =?us-ascii?Q?NReGCEmoW3oiAz4qvCpcM8uJg/SQq7A19KUoGSk35L+JEpjK8GzsubGAzp3h?=
 =?us-ascii?Q?k8pGW7n1/LBT+KTpvt6neoj25VubOeKbua4EatETbDamgoYynk7pPM9V3pgP?=
 =?us-ascii?Q?B4JFJOpw5vc2WDKQ5dixMrxOVGQzjUQZypZVdqTsXwiVya2z+NxQU5xfdVZ6?=
 =?us-ascii?Q?Adph4c+ly32qXpj/kNxGULinXP0Z9G3/acSFFQCLpGp3mQzZt2YKczrfw1qt?=
 =?us-ascii?Q?T2EcwtcajEmu5iTCPhP6NsqL8T/8diNJ0zQJtUarQsbA+nKeft+crEPXHibV?=
 =?us-ascii?Q?+UA5nJUYCkvARImCQ7CBIFanDoIAyaWg6xsuFqlwgOL2TfVPoTEFLSlTRGqV?=
 =?us-ascii?Q?kLS5+VeafxTGTfKbH1Yih2R6dIVn1VzmFCd9G92Hdieet8I1SFYIHLZHRPjQ?=
 =?us-ascii?Q?tzxd797pp4sWQ1sbZQeHVKy64xgAxXus7soo7vjr9hVEweo4CGZEFvwl/O1c?=
 =?us-ascii?Q?5heU19Svho1vA24VpBKmGSmV7GTsY/hFAbVd6VALt7WAq/cyD+vOnnSYwP87?=
 =?us-ascii?Q?IWwWQQqyDP1yobhm9KMljUkv645yAYjoXmrzMJ/BkGWVen1pa4tzpGAqjyh2?=
 =?us-ascii?Q?uuAgNEcBJIZqgnfjavadZwk+dmZZ7UfwZXxOrk+mWd90cHruyHIWfn62SE9z?=
 =?us-ascii?Q?TvoEopO5olm9EDs8VrDNA85NIbfhmaVhI/swXostst77YyYyWggBRts5AOC6?=
 =?us-ascii?Q?KQ/cpEaQUlU+Jqt+jMIJFTELh6J7hgx+LhtfslFLpj2oQRmkHd8KuJNmZ0Cp?=
 =?us-ascii?Q?t+Hxh+aSvbLBxWQxTsH9PvUKJGGTtMhxBDYH25VdtDk/bmjXkn60lYHr0D35?=
 =?us-ascii?Q?WsJBAbSyaz9doBGirAZvjgsNIFLnPifD2/I+V0tcN09fLiAipxBDgzm+3oPX?=
 =?us-ascii?Q?PVhwVe45eua0RmXJcGQ03W9oMXefOmZF4kET3fjhzyCHqvgWW0nmUOtN5Ok4?=
 =?us-ascii?Q?psoY70sh//so0fjws6IyTg0J6FVyT4HZZLRRQps8j3BntWOaOa28LV0vQ5GE?=
 =?us-ascii?Q?oACpMJgRB1puais2ZdoZnpW1NukSWY9wxVvV0gAoBp+nJyH6wbgKwLy5edu6?=
 =?us-ascii?Q?glQa6PK4vYkqX4exmxTsb031f/ZDcbtIzMw1fry9X3vFanD11V7ADC2EM9tU?=
 =?us-ascii?Q?gBpcBy3xWivVhdnm+AWjiKsOglVtSqL65b63CwHw0KooVG2YtNmaVFo+cAu+?=
 =?us-ascii?Q?P5NnzXAAw+o6GUFLCsq4OfDJo0Cl1A1+3t0N630F?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 890f6969-f5c2-46fc-721b-08db4b59cb43
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 22:08:43.9748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJWDHUJl/xkTJdh3jy8zuGUUz/wqWnsHA13SjS+/YzqEnZ651Mm3Wkz3iotIaOJ3tpx37VUkVM50WkZiLtQqsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8016
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The patch reorganizes functions related to XDP frame transmission, moving
them above the fec_enet_run_xdp implementation. This eliminates the need
for forward declarations of these functions.

Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 216 +++++++++++-----------
 1 file changed, 108 insertions(+), 108 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 42ec6ca3bf03..14f9907f3ca2 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1511,6 +1511,114 @@ static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
 	bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
 }
 
+static int
+fec_enet_xdp_get_tx_queue(struct fec_enet_private *fep, int index)
+{
+	if (unlikely(index < 0))
+		return 0;
+
+	return (index % fep->num_tx_queues);
+}
+
+static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
+				   struct fec_enet_priv_tx_q *txq,
+				   struct xdp_frame *frame)
+{
+	unsigned int index, status, estatus;
+	struct bufdesc *bdp, *last_bdp;
+	dma_addr_t dma_addr;
+	int entries_free;
+
+	entries_free = fec_enet_get_free_txdesc_num(txq);
+	if (entries_free < MAX_SKB_FRAGS + 1) {
+		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
+		xdp_return_frame(frame);
+		return NETDEV_TX_BUSY;
+	}
+
+	/* Fill in a Tx ring entry */
+	bdp = txq->bd.cur;
+	last_bdp = bdp;
+	status = fec16_to_cpu(bdp->cbd_sc);
+	status &= ~BD_ENET_TX_STATS;
+
+	index = fec_enet_get_bd_index(bdp, &txq->bd);
+
+	dma_addr = dma_map_single(&fep->pdev->dev, frame->data,
+				  frame->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&fep->pdev->dev, dma_addr))
+		return FEC_ENET_XDP_CONSUMED;
+
+	status |= (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
+	if (fep->bufdesc_ex)
+		estatus = BD_ENET_TX_INT;
+
+	bdp->cbd_bufaddr = cpu_to_fec32(dma_addr);
+	bdp->cbd_datlen = cpu_to_fec16(frame->len);
+
+	if (fep->bufdesc_ex) {
+		struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
+
+		if (fep->quirks & FEC_QUIRK_HAS_AVB)
+			estatus |= FEC_TX_BD_FTYPE(txq->bd.qid);
+
+		ebdp->cbd_bdu = 0;
+		ebdp->cbd_esc = cpu_to_fec32(estatus);
+	}
+
+	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
+	txq->tx_skbuff[index] = NULL;
+
+	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
+	 * it's the last BD of the frame, and to put the CRC on the end.
+	 */
+	status |= (BD_ENET_TX_READY | BD_ENET_TX_TC);
+	bdp->cbd_sc = cpu_to_fec16(status);
+
+	/* If this was the last BD in the ring, start at the beginning again. */
+	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);
+
+	txq->bd.cur = bdp;
+
+	return 0;
+}
+
+static int fec_enet_xdp_xmit(struct net_device *dev,
+			     int num_frames,
+			     struct xdp_frame **frames,
+			     u32 flags)
+{
+	struct fec_enet_private *fep = netdev_priv(dev);
+	struct fec_enet_priv_tx_q *txq;
+	int cpu = smp_processor_id();
+	unsigned int sent_frames = 0;
+	struct netdev_queue *nq;
+	unsigned int queue;
+	int i;
+
+	queue = fec_enet_xdp_get_tx_queue(fep, cpu);
+	txq = fep->tx_queue[queue];
+	nq = netdev_get_tx_queue(fep->netdev, queue);
+
+	__netif_tx_lock(nq, cpu);
+
+	for (i = 0; i < num_frames; i++) {
+		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)
+			break;
+		sent_frames++;
+	}
+
+	/* Make sure the update to bdp and tx_skbuff are performed. */
+	wmb();
+
+	/* Trigger transmission start */
+	writel(0, txq->bd.reg_desc_active);
+
+	__netif_tx_unlock(nq);
+
+	return sent_frames;
+}
+
 static u32
 fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
 		 struct xdp_buff *xdp, struct fec_enet_priv_rx_q *rxq, int index)
@@ -3777,114 +3885,6 @@ static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 	}
 }
 
-static int
-fec_enet_xdp_get_tx_queue(struct fec_enet_private *fep, int index)
-{
-	if (unlikely(index < 0))
-		return 0;
-
-	return (index % fep->num_tx_queues);
-}
-
-static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
-				   struct fec_enet_priv_tx_q *txq,
-				   struct xdp_frame *frame)
-{
-	unsigned int index, status, estatus;
-	struct bufdesc *bdp, *last_bdp;
-	dma_addr_t dma_addr;
-	int entries_free;
-
-	entries_free = fec_enet_get_free_txdesc_num(txq);
-	if (entries_free < MAX_SKB_FRAGS + 1) {
-		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
-		xdp_return_frame(frame);
-		return NETDEV_TX_BUSY;
-	}
-
-	/* Fill in a Tx ring entry */
-	bdp = txq->bd.cur;
-	last_bdp = bdp;
-	status = fec16_to_cpu(bdp->cbd_sc);
-	status &= ~BD_ENET_TX_STATS;
-
-	index = fec_enet_get_bd_index(bdp, &txq->bd);
-
-	dma_addr = dma_map_single(&fep->pdev->dev, frame->data,
-				  frame->len, DMA_TO_DEVICE);
-	if (dma_mapping_error(&fep->pdev->dev, dma_addr))
-		return FEC_ENET_XDP_CONSUMED;
-
-	status |= (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
-	if (fep->bufdesc_ex)
-		estatus = BD_ENET_TX_INT;
-
-	bdp->cbd_bufaddr = cpu_to_fec32(dma_addr);
-	bdp->cbd_datlen = cpu_to_fec16(frame->len);
-
-	if (fep->bufdesc_ex) {
-		struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
-
-		if (fep->quirks & FEC_QUIRK_HAS_AVB)
-			estatus |= FEC_TX_BD_FTYPE(txq->bd.qid);
-
-		ebdp->cbd_bdu = 0;
-		ebdp->cbd_esc = cpu_to_fec32(estatus);
-	}
-
-	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
-	txq->tx_skbuff[index] = NULL;
-
-	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
-	 * it's the last BD of the frame, and to put the CRC on the end.
-	 */
-	status |= (BD_ENET_TX_READY | BD_ENET_TX_TC);
-	bdp->cbd_sc = cpu_to_fec16(status);
-
-	/* If this was the last BD in the ring, start at the beginning again. */
-	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);
-
-	txq->bd.cur = bdp;
-
-	return 0;
-}
-
-static int fec_enet_xdp_xmit(struct net_device *dev,
-			     int num_frames,
-			     struct xdp_frame **frames,
-			     u32 flags)
-{
-	struct fec_enet_private *fep = netdev_priv(dev);
-	struct fec_enet_priv_tx_q *txq;
-	int cpu = smp_processor_id();
-	unsigned int sent_frames = 0;
-	struct netdev_queue *nq;
-	unsigned int queue;
-	int i;
-
-	queue = fec_enet_xdp_get_tx_queue(fep, cpu);
-	txq = fep->tx_queue[queue];
-	nq = netdev_get_tx_queue(fep->netdev, queue);
-
-	__netif_tx_lock(nq, cpu);
-
-	for (i = 0; i < num_frames; i++) {
-		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)
-			break;
-		sent_frames++;
-	}
-
-	/* Make sure the update to bdp and tx_skbuff are performed. */
-	wmb();
-
-	/* Trigger transmission start */
-	writel(0, txq->bd.reg_desc_active);
-
-	__netif_tx_unlock(nq);
-
-	return sent_frames;
-}
-
 static const struct net_device_ops fec_netdev_ops = {
 	.ndo_open		= fec_enet_open,
 	.ndo_stop		= fec_enet_close,
-- 
2.34.1


