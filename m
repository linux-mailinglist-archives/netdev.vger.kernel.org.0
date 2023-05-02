Return-Path: <netdev+bounces-28-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6D7B6F4CBE
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 00:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86D33280CE4
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2932CAD55;
	Tue,  2 May 2023 22:08:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C869AD53
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 22:08:43 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2089.outbound.protection.outlook.com [40.107.20.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E92198C;
	Tue,  2 May 2023 15:08:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7X8kjZTkBPIaV8XFWQdS0xPLjX8HSOm/qtOY4Mb5hI9i6sYl8PlTzjO/OE8PadLs2lojQtBh8+DiuCnT6Uf/hOPjoeWdNYV6z7sGV0rML1JA0NS3Mw9sLZO99XrDW5FCeEZSiorXGWTy2dE/5sRkX75ajbRxSdKno5j/0S05O1d2f4UjuixaI815kuiW4jLI3CPXe1RMPHGnwziMQq1WShLLtgv+Xy9zf+kEkmhe5qnIHK3Auoqx+2rEqYhCtLGi1wpN1uFMB9Ol8C2xvWgE/TXZ4YgDbL6z2PevsNKP2kNR+4g+vNTqibwnR+UKK75m8O8HEtaUyZ3ym+kkGFYEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4ZbOXrqg0Z9bC3JJvm08i9JMWY4/r6DFAeHr8jsRxk=;
 b=Se6pfkTaKuxaqQ+iiRpz6fTjT4I8KF8ASxEP0wfh5RHI6B+0ODl+AEglJb/voaD5YuuQ5JsRbdd0JQCuiYHD4/ur/fAi5lgn5ZT8/1nTV1DeansoXrCw+DP4RL1qKBbbbibM1slBbYp7uct4TeKWMNOzPDSt2p1eE+4hu7Y+cN9NnRs7CJR5AzAbwidL57r5ynrCfooidbFMMYbYv0xm+zW+FaLPduBtJS/STCJC9SRy89qELiWqpN/bh4kQq/wG/9kEqofUw0L2F+wRx9Dxvhj5xRa/FFK4niPjuflP0X+fPwLXuXhLMbG+gNPh5CjJKTdJuuuzxRHOeHlQktPg/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4ZbOXrqg0Z9bC3JJvm08i9JMWY4/r6DFAeHr8jsRxk=;
 b=nBqvhrhgtd8ZAM8UKMvhpKJnDz5H1aX7l5TxpsmGzWva4sJ7OqWoFgm0tP/utqALwrU31Vh45TnL5WVjjn7GuHJTin82Z4lL78psKaLsy5tIb5UTFpf5GWpN6/2e9Y78dBtxn2xZyx3rJTaLjfZ68wE9TGwwiOIh2BNGhj/Z47g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PA4PR04MB8016.eurprd04.prod.outlook.com (2603:10a6:102:cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 22:08:37 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 22:08:37 +0000
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
Subject: [PATCH v2 net 1/2] net: fec: correct the counting of XDP sent frames
Date: Tue,  2 May 2023 17:08:17 -0500
Message-Id: <20230502220818.691444-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::23) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PA4PR04MB8016:EE_
X-MS-Office365-Filtering-Correlation-Id: cd6484fb-6171-446d-88d6-08db4b59c717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ukEsdoEn8mSp0sGrbKhYPuzCO6BRVXQOFof/YO0ltoUKAGChj1ZUmrv3rTEOmGe/nsbn9tQbVmdTh6LtfKptGRA3LSPu9690k5NBxjQwsB8TEV0LAmExT4tYtmNvJg88FCdFku6USn4eNCnXHDlldZotX/Clu23z+68/oTANJzn7WGMyooKsogVjMOozj2hrKkr/aksI85791+u6g8DajXv6/IfP3OL4i1QAp4tU0qmZfTF/jXpZGZtTt7yphZC6zPWVYmvGz+FOejK5vEjxoczlgZG7MhRLc7qjwgh3dY1Mui/uByksczYBSJjCGGyUGwftx5Ja96RZl8QnT5E3+PgbOTb8gjt4wiUV6UcvXlFBvCL+DqzFwEXiBmLSdpRtmSS0NUNNgsTP4EBFNu/fmCo7nLZ+863+XcqaTlgm76qwxT14/RSpWy+STLLXXKILih8Iz+fzYDh7VcM6B3bLgqTIEO+5ikwFHzG8pRMPlBJ9LIfIJL2aJLwlBcmEu0AMBj2r/fJOiQn4yTpy+5ZnpjPzPGjAOTFauSJNH8vhcsAcmhJEus4iLMXeJ8RzZdEWaHXNk7W2yyRk0BJ8wBCB2jJr6+yYA+pVSLjVYfajlYxMdFjgDVnUW3GbTQHiiLQ6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199021)(54906003)(2616005)(478600001)(83380400001)(6486002)(6666004)(6506007)(26005)(1076003)(6512007)(52116002)(110136005)(4326008)(66946007)(66556008)(66476007)(316002)(55236004)(186003)(7416002)(41300700001)(8676002)(5660300002)(8936002)(44832011)(38350700002)(38100700002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q9irMVYgWNQzMg8AH1Z7dKKxyKbhElIWhCSNHgE62holld/dCCG0GJrQY7/H?=
 =?us-ascii?Q?pYpPMGMg0uh2SrurtG+36DkDZVPAEG+P//tIudE3zgoYADd8s5wMFY5ud+bt?=
 =?us-ascii?Q?VGOrphxlnD1BNFUwpa2Jmxq+pg+7f5kARbgTVjYzYEC9s04SLt3WvCsMySxm?=
 =?us-ascii?Q?bXdnE5UqUdJ4KhKXBEjCN9ZbpSvQDLTBnTtPzl7+VScTLGCXb+/4dUGZi66b?=
 =?us-ascii?Q?6BMA2rS707mNiJ30ndmHH/ykp2kJ/wuJaaEtm94uWdYNe9us5GRykTAhjTan?=
 =?us-ascii?Q?xUJrsK73KXUeYYJk/7q1gZnHLig7xNjpQFBZ+nXTAHvC9SMFpKZqDI8kNCLv?=
 =?us-ascii?Q?wia/hRvtmbChrRrulxRAK6uvqmPxHZh5kRVUxovn7exrK/k/EgwJL4bjGJ/4?=
 =?us-ascii?Q?JS45lZ5CezwE3bTgjBBgC8IrlDvB5Pm94ePHHlgYyocMJ4KMtCxt0QT8p4fh?=
 =?us-ascii?Q?gp2DcHjMg+MWK5wJ61q+Pm5Q7NU2dFahDkNR6eC4LsbyqlcsM79MwZUh6Cf1?=
 =?us-ascii?Q?EXUxu0GnizrzSLdTloI7s/Pe7+Sxobmfys1NzsdHGeZWciJWpQYWQNmCmJ2j?=
 =?us-ascii?Q?LpbPTE0RUxpFjaYuGAJv+0RgYd35fW4o6tt0xY2JIUtVMe7wlODs0Tvh0J6E?=
 =?us-ascii?Q?72AAV4MHR6u+Tc3ta4FC7mTDPhdmGxSzSq06nzRzbOdVzjBfxCx1mTkX6CuX?=
 =?us-ascii?Q?nB6JVwYzPeM77/RJZ2L6d1lmQ4xCyr4nmg2McBJmtFl8choUzfM32yj/CQnr?=
 =?us-ascii?Q?mcuKzLBqYM/+qC7ik58luQPtzGvXoU46XObNX9PA6D2ZX6W16GYMRazgK08n?=
 =?us-ascii?Q?mIyUqPzAbt18pHl6oo5E3CrCad2DZ7nL8RY6cuPil0z6PkxVsoVE2VkME7xH?=
 =?us-ascii?Q?ZzQ23qUWsHell6hq59JX1+QlvUWwxydy8h7iu2xW9EC+w5xtAE1lv0TyVSxf?=
 =?us-ascii?Q?ZH30KeH4/wwCl7ihBv4hZ7CbvleUXS6YjrYk2aanss0u61CIE8wkwOgidFK3?=
 =?us-ascii?Q?xBkUc8acnIqpvwTWpuCnT62q9JTQhViOvmYSqpRSfeUdMCaNPIyX+aRGMEkN?=
 =?us-ascii?Q?eCOAJuxEAInTNjEq9MKrbjLCinTuFPSEBaWeuIrGrs1c+FoPDyKAW43e9Z9w?=
 =?us-ascii?Q?u+oYQ+aiL34BguZQRUibfKEJ5WPD4OMQQ9i7uokxMPqiy6Bm2VLoXYq7KSQ7?=
 =?us-ascii?Q?MXnZIhWl4epxsWWZ85tVxDVcwmJfBlRXCwq2hHiJwLrX9AjSmkOgzP6/7k1j?=
 =?us-ascii?Q?xEClUUXczSH9ppmNsphHMD84o4zBIsMHH+T7ai8RW+UQoF/appW8hPcTskG7?=
 =?us-ascii?Q?HpLFofLINKHzbmFvojIOd+zfrH1bnHCMAoG2uIhr58Vpyc/34P21ynOuD+zl?=
 =?us-ascii?Q?Ii+2oWDPwwBB+FpyA+VKCrNr0yGiEoOpyaiaXuRlxC7cbZebsbMeOHQNig7R?=
 =?us-ascii?Q?hk1g1mP72SnUpFI2dGRXOTRyX81fvMGLiq9XrB3bPcFiOXhwrLmWmIIb2bTY?=
 =?us-ascii?Q?jOSkdqJrrK5+cwP7CUVqnlwbjOoQRBA6W/i2qIE3qIil6dZk/3DQy9GGAwG/?=
 =?us-ascii?Q?0NY439lgK7Q5QW5Ifh1zpg6dEwTS8+tfOgqFM2DE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd6484fb-6171-446d-88d6-08db4b59c717
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 22:08:36.8719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2oJIMDiWlqq1OEXQ1mXgZ3Oxvp7XtXkoOgOrzSNZah+jcFBh3v9OKABmnidhCscVr4V4kVfxcNlQHswVWZcA1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8016
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


