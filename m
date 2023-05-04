Return-Path: <netdev+bounces-298-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35BFD6F6F13
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 311E0280D98
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BC939465;
	Thu,  4 May 2023 15:35:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0896B29A8
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 15:35:42 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2087.outbound.protection.outlook.com [40.107.8.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C72E40;
	Thu,  4 May 2023 08:35:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/aaibR+kK8cF7CMxP2DpPhjfQmPAqPe5p57NJzBKLxFqJ1BXk0pFXLE0PMTGOqkY+fhUOmk/pQj9XLFH37HwujxxbWmPIrLu5tt80PeX8v+ExdAi2B7alJKZJBZMPkUF0Gn/7xP7W5paNCT2dMn0/VF9GyjZlJG9oqtNonaomOoweos+pak20B1VyJdX9up2EDmRhOoGoyMGsXvvqrJfxINZzrBZRgKf8Ath5evxig/Y8IYv2aRtzxACrZNXPJRi/L2irnWahzdagQmSPrNzH/dDx70jkn8DZdLbi82JV4zNfZnrY7Whi7eOkIpw0V7CnjeV0bxgIBamBcQyc/fjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JAvUmbK2XBC5GjxHBQdwJN4Yw6X4HgzA0V6CVFo9Ig=;
 b=oLf77msRhUmD1Wsmme3uIKnTLT87RgdgfqjIWtJZaqdP4zVAwLJFturbP9iRNvaVEo1rOJ5Jd8LbNdnTEzHnA+Sd4TTVWL+MMwwdpgtHesJLHhk1mLqHEFskVT8daj81Nr1vV2vlJRIooRlyiR9osz8x24iot65mAs6nnYnDdFiCycapbxRbBKIYRmBdipQFpHA+ZZbhGl7LQwgCq9qi2e42PV1QUfuk9FDeB1oACVX+WPY249pwZRBbcPYjpbmnQFQhwX2b6NoTeA22jikJkLyH/XWloBL2ZyPKxOMPqFEz8I2YX37d68o5eW8atFeWwW9kkD3DCH16rjqF1mIsVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JAvUmbK2XBC5GjxHBQdwJN4Yw6X4HgzA0V6CVFo9Ig=;
 b=HYxHSaXcjAaGmWLQetEXKZhb7j/RyjG1snDm8/rTDGjb8doJwhw0dTzKr0eoVwoSP6BN4n8a4/BfLBufMKblzq6ZHkqxw3+fLpnNhbZM2frrs29GH1YIyBtAJi/RYeivrphp2/gJzLx5CUpMQrVTeM0cz5gzNMchiP8VQO8hrjc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by VE1PR04MB7245.eurprd04.prod.outlook.com (2603:10a6:800:1b1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 15:35:38 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 15:35:38 +0000
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
Subject: [PATCH v3 net 1/1] net: fec: correct the counting of XDP sent frames
Date: Thu,  4 May 2023 10:35:17 -0500
Message-Id: <20230504153517.816636-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:a03:74::37) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|VE1PR04MB7245:EE_
X-MS-Office365-Filtering-Correlation-Id: 92e17222-5a23-441b-cd58-08db4cb5361a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jLdrwbpNG5MIzVC2laVhdkMLYpLglpSKY8ucUz9hHq/Sxb6PGYaX8iOmxzjPD4zffZ9L0MCFpmqHvDnYadJMWNGGjj8i/pNT2oasEekYpqfV7WJonk5EzjRdoe4upVIftGl1mR0JtDGWVBygTZ3/eUdW6zb+LWmPbGVlPiVzAIU88ns/Aua2cP4XYoJJSA2CaV5NMFRcl0ZhPCyWEKqnCiyoujXUfbbd0E8l0FzO2B9SN2qDWmO1Xdi7Gro6Mo5BosaHzq8gSV2hby/RWuVtV+AR4b+9FqgH4nbNtbxJb7P8w9PTWkw678hqSawtmSQ06JSMxHb7RywTRG9j0x3nFSRuuMPLn2ETQ4szBjRZafJ9zu4L/ZCjqX1drzQgpjhV+Um1EKf9tNwBfK/2KV9Q6Jn8/016mdo2ucaF+HNFZaTlIuMZpzohD4LT+tseex0HlC/hCekTyqNRMuJhLY8czUqtcFSBUmS5bm2WZwqlAm73wqj8oyVdndLym763pBnQHHMQ3zgLjLJPlCZkEsksc2LQvfK3DlA1gfhlZ100/USmscQzT4Uq3KOOJZbdMTtWc2+oasPBjO2SqlQbKja06KfUoB/qA09GITytgEg5g1kjRhX7yFKxzgyzzEycGDOM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199021)(38100700002)(6666004)(38350700002)(110136005)(478600001)(86362001)(83380400001)(55236004)(26005)(1076003)(186003)(6506007)(6512007)(2616005)(36756003)(6486002)(52116002)(54906003)(5660300002)(8676002)(41300700001)(8936002)(44832011)(7416002)(2906002)(66556008)(316002)(66476007)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0YDjKE+g1xxwAApswedzZo2yEbWF2ZEvaW076N6Q2mNeZ5YD7yKisYoEzGkk?=
 =?us-ascii?Q?SNDekHsf5N82DiVLEADhyWtiua6xxdyboJlTpgyResQ4Vqo1RcRkMsbnsIW0?=
 =?us-ascii?Q?ahbONmxEe8HM1KgaESruHJKTcqvZeP0KMQVDqLYqA379cCwbVWgDo2POPxzd?=
 =?us-ascii?Q?JWnJlyKEbaZCbL+QMhVeF4RtCWepmqJfOpBzHrb4NpKtlcJOED3XoXe97o+1?=
 =?us-ascii?Q?eb7VRA8JBwQv6AHb35xFKyzdqiT9TWHDCbySHMUDwS6Gh/6iYgrTB05O6cft?=
 =?us-ascii?Q?FOASQiz2DSorGTLnO2p43nFgFG85Ejfi1gT+CyxZdog8fONhXLHyO9zUGDRz?=
 =?us-ascii?Q?vFQShwMtHfhFFwUIIEGnAQrbCFS7/o1wOEkkqmw0lRpN0F7Vysl7izl6axTR?=
 =?us-ascii?Q?u0V6dMJi/sw30W9eNpJvptY1GnnUUmQdCW4fXvG39DMePFLkyk4i1/6qy7ZM?=
 =?us-ascii?Q?8XTfzzM2Lj+5JRqHqjH5iXvGyaXQgktbGHcGEKPnxJZuYsaMPdxm0vPQosm+?=
 =?us-ascii?Q?8OC9S+R8CHrbiBOhkJElk2Cdckf6p67r2mCqkWN7xcWPzKQDWLw8lKfc27bV?=
 =?us-ascii?Q?QaKn8jA1MEZfECLEc5mR53/c5nEcOLIc7+JkvV/8ImdOSfbYTVY/IcASNdoY?=
 =?us-ascii?Q?GwAE13Kmrfq8UK1DzdrnrW2ZnqTW0ex3rXcRMeD63K+KJqEClhakeyq3cmQh?=
 =?us-ascii?Q?74fc/fQz/nPSQcuGT0N4Kh+IjBaSzx8fONdTIIlMAEfZsGWkmHHbYrhRawZ+?=
 =?us-ascii?Q?y2+aOw2zXWuOqrI5xB5eHW8SY3arGeIYABGIxt7LUv8Jn4Aaj6uVrQIwTwlb?=
 =?us-ascii?Q?Z/CzGg6pR2qcXyySo1Gcj/PtOi4Jc95YBU9M5AcE4yh8JD16BZ55Q0N6/FC1?=
 =?us-ascii?Q?2mbSfonOTekMOPvWPgAwUMx5RX59zpVIotY8wwR14iL2uklSLezle3rqACop?=
 =?us-ascii?Q?Jnd44ZtZnRZDhpPkSysTCqpCaXHqOvtUat0n6yTYE72O55U+25b7MkmVDx7g?=
 =?us-ascii?Q?lBgvziD1VNYyy0+91XP7XAgxNuQo/UkIOOxbx7q2jz6Y7NmDszCUxWLm24B8?=
 =?us-ascii?Q?h64NhIylMmp5kOj3quqwcGyG5QWrkvr1cyqvYiKQ774x99Y9OLxjbOjFGnwY?=
 =?us-ascii?Q?HiuYZ931h9GWH77ktaH95SCIZM4h6ytc4JhkKiKxtyhEARtDIXcHxLMWJzU/?=
 =?us-ascii?Q?O41zL78AKr3wgwb6bgMTVr3Ie+BlIbmO3yw9nACGnQA+bhSxK/tLZ9Nxlexi?=
 =?us-ascii?Q?4k9CLDdboVpdsxLGVz0/eLPgAKYLdpPxfAKZsOwE160A22oQ5coqvIkWEcGR?=
 =?us-ascii?Q?H9L06CMbu8VPWzyWhk1Nb/MCSmGCJkSnPTbj3lEVY4Gupeh8L8fLMerW5FZy?=
 =?us-ascii?Q?+MS6SUpih+DwscUdgtHaW87LUA5xdvM4y/UVIUksYLZd2yJFwtfQn2mxEjW8?=
 =?us-ascii?Q?gsovBj6FG3NZvDH1S3i8Ji5v+CAzg52ALFCBlTBqkV9j2TN5PfYdKKXn8+j6?=
 =?us-ascii?Q?4ReTcYTMUJax3bSe9nKzNEDqoveQYqiq8RHfxvYpLhMSSNW2GMyOVY+vDofM?=
 =?us-ascii?Q?wQMftOWKURFpqTPHJ1VRuhPM1mTGa1c7RyH38xZ7?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e17222-5a23-441b-cd58-08db4cb5361a
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 15:35:38.6296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7W7+hYC1BW2/zGIwvT8zeJ/VlAE1oVyDxD88JvukNOaHhQMgqdiAAknR5AJduJUWgXuclOSzOoKwJzfxAHEQIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7245
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 v3:
  - resend the v2 fix for "net" as the standalone patch.

 v2:
  - only keep the bug fix part of codes according to Horatiu's comments.
  - restructure the functions to avoid the forward declaration.

 drivers/net/ethernet/freescale/fec_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 160c1b3525f5..42ec6ca3bf03 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3798,7 +3798,8 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	entries_free = fec_enet_get_free_txdesc_num(txq);
 	if (entries_free < MAX_SKB_FRAGS + 1) {
 		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
-		return NETDEV_TX_OK;
+		xdp_return_frame(frame);
+		return NETDEV_TX_BUSY;
 	}

 	/* Fill in a Tx ring entry */
@@ -3856,6 +3857,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 	struct fec_enet_private *fep = netdev_priv(dev);
 	struct fec_enet_priv_tx_q *txq;
 	int cpu = smp_processor_id();
+	unsigned int sent_frames = 0;
 	struct netdev_queue *nq;
 	unsigned int queue;
 	int i;
@@ -3866,8 +3868,11 @@ static int fec_enet_xdp_xmit(struct net_device *dev,

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
@@ -3877,7 +3882,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,

 	__netif_tx_unlock(nq);

-	return num_frames;
+	return sent_frames;
 }

 static const struct net_device_ops fec_netdev_ops = {
--
2.34.1


