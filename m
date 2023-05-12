Return-Path: <netdev+bounces-2159-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF969700908
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AACFE281B3A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092E51DDFA;
	Fri, 12 May 2023 13:20:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DAF12B74
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:20:38 +0000 (UTC)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2060.outbound.protection.outlook.com [40.107.247.60])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80121FCD;
	Fri, 12 May 2023 06:20:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7yCim7ce1Iby3E1+AEvrOIzFnOpw7hoNVGXvXHBmTCxiZHelFwfulX4oT5NEpSEcxMKSteXYRDKGUANkmKk0zvhBbJkxU9tB2Vi+1NyTHrmReZVuvXk06niEVyXII/Lg6wbHAcfFPYJy4MUCMeLR9a9CO50q2MRrhSgNAiyf+d6eZecJNHZMM5dMKWLC4mRiq5EWVNQYuxdtEtiB1zoOL75r4/WS4hHbzhRsoWBRB7RnWGc7k7oh8WH/8Z6XIQvdNnsuQM9gCgMhzGFWdYDIdlUv6d4cyPHlW5wkeA+/Z2QW0v8XmTShTk0mBqxy/zBnZhgy/bzr/Zg4VfwJFpIOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mvcHDKk9aePOKSMBNr+7VfvUqJzy7NCLdTwBrhoER4E=;
 b=BlcPW29N2j1dyK9TjRfSh1mdCdPZjvAHxkvdREUGu6IL6zFFiPDdoRj5mY3iXY+7a+Au21ZLZLlBx1DSOqdQdwhNjE+ibRofCwy7EE8201y7Tg7StJXYCpYk1wbZYH23zPAybvsaLImEvSMwhBtH11IKcvmhYwTMokLOqFeb0YBLk/yY6aao3+P+frdEa/Ntv1DNumhM93uC+Ub7K/sjVysgTdhKWZUxJqHAgVl8YPeeOAQeH4BzB+gIwe79DsvSHX7C5Rd9DkwoAX4TVMx8tWolUpJOeX2GGRX2hPAKUpg07i9pYJlu4/NCudWHFXUSY4AdKP3ye8i0qKRT4Pb/2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvcHDKk9aePOKSMBNr+7VfvUqJzy7NCLdTwBrhoER4E=;
 b=jkbKMNa7ryeiKqS6SpRF8Pw9M8Ur6TaCRRkjgbM/CfE44ivqszc83ZBRM3qzzA3240K6Du8HgOfGF2alyDUMNzDnJemJRihLMluJPnqIQYhJ7Q8tnY384e6BTm2rDNZy75jOunU43sg7UEjgtxsLE7BmbPeXtCahjmuJ6gkm3tc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM9PR04MB8730.eurprd04.prod.outlook.com (2603:10a6:20b:43d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.23; Fri, 12 May
 2023 13:20:34 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6387.020; Fri, 12 May 2023
 13:20:33 +0000
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
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v4] net: fec: using the standard return codes when xdp xmit errors
Date: Fri, 12 May 2023 08:20:10 -0500
Message-Id: <20230512132010.1358350-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0040.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::15) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM9PR04MB8730:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d1501a4-de05-4844-3348-08db52ebaa4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eSAfMZr+BynppLTJtj0cuVXo1FAmxITPBW3Jd4niovBaJjHoxUNX2G5hbIT3odEL63D90ZUD+2J7h49MEfWyN9L3Q92Kidh9+0fiLkt25XGD+uReYGrKF4qfGGbekog7tbk42/neO20U0dy9XGw5zlY0mzZu2/jGz4h0VpB8COgutOMo/WaNRl00t/hyqbo+j4rnb2H5FC20iHZga+s8756hXvlmx90Rd+dJkCH0X++wr0Zo2ra/coUDZUw2yff2fU7dGeIqt9PQnEj8YbTD2CYFXVSlb1+XBw1+X5xHrrpXYTAk5za2woJCV3EX2Sgm8l4AmilAKWf0Nln63krl2iZ0+0jtfiXyeeLgYl+qs9To7j+B9SKepDFGKZKd3TP8sZWtylmWPsvZYDkj3qWHyUzSWm/eEP4F1j/zUSFEjteZg7GfsLr6+kkSKE3VQM0kqkngLxqHV5Q/kBRrklLfjq5pFt1RDOFsQTbtRN2WIq98a7yMlG6hYRFtBflTUvVP7/3cSpKKBBb4PzvoUqdNpTy8ToVa+YlwbaQpu39cJ96nnF0YOgvRzRRfJRX2RjIkB+Lz5pdX+O80H4LTIAMnmJM/+1r0Ozt5JFwh5SXgWSHkaDccTcEc4GLb6hAjea/1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199021)(6666004)(52116002)(6486002)(54906003)(41300700001)(86362001)(44832011)(7416002)(110136005)(8936002)(8676002)(66476007)(478600001)(4326008)(316002)(66556008)(66946007)(5660300002)(6506007)(6512007)(55236004)(1076003)(36756003)(38350700002)(186003)(26005)(38100700002)(83380400001)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gM6ZX/Ci+0fywt+itmOQUVvSGF0g+fauwQ5hoisTuTQ4EC25oLoLAM0iBY4J?=
 =?us-ascii?Q?NKnXKhkQAZ3jWvLYVNPwtsMwMYjGqh3J94Ao6bQnsOiMOp3ohp29Z3vbXcGp?=
 =?us-ascii?Q?GlpXZ/dRhE4M92xiVOCb8Fe6hcvq87Qid2hQGspCsHKPR08D+yBbZAIMJ1/m?=
 =?us-ascii?Q?LwYyzZ8rrGaWb+6mrl+BztCzdTV0R7qOxX2EkOGbG79BsCMo86feyJ3JZHZH?=
 =?us-ascii?Q?xzfe5fVxXJmIxuOLkXadEVulIvolVkHjyy4YhloWWHbKQ/8HLbZEeKzifmKw?=
 =?us-ascii?Q?9h8mocpUjXKSQU8jbF9ve8jqxP1zaD8O4/zy+pGGV9hhY3q6LECeRySKI6Xq?=
 =?us-ascii?Q?r3j3KNawvRuI4dLvoMm48D6Fmk7ZD17wm2PLQLMuqRQEXql6QcnBJBD8LWJC?=
 =?us-ascii?Q?JazU1KhxyVe/toSuhhxFxFVniBrErBmGfEqW96oSzpk5+BIt1NGXNf+cmzn0?=
 =?us-ascii?Q?XhZWEzC21Yox1frsN1bk0y7AIx/5egr3n9euFPpWYjwnoTwQ0xkGEXjBuPg7?=
 =?us-ascii?Q?f7Ip4S/E4kCdD7/BG95wNrG76RneSecgawelYMnlW++X3mnel5vthE+AydFO?=
 =?us-ascii?Q?4DXF4WaE+UB7GM19dOs7XExgQaSODO+UzHuzPDbr/8BCIVjKAgwBHkvMXiIs?=
 =?us-ascii?Q?Eea5gAxVQYwj2InmQOzuP5YV00C/0ULeseTrlUVxsPwTzxpxQ6z4v+AV3TXy?=
 =?us-ascii?Q?3fP3ksJIBGyjDcFbEKevLll4cVZ1gO+o+xsvmNzhBUkbWTtoijM1Y8b0PEEs?=
 =?us-ascii?Q?TshPxE6xKJM0KpFggtzTwz2a8hyxW6YlrDGsqf+JSMtBjWP8xgmqnL+GJKjr?=
 =?us-ascii?Q?F7drzd+b9QdCQYp3WEfU1UVvn/V72R9oFg6hj7kcSu5vDl7LgmZ0TeJZJZmT?=
 =?us-ascii?Q?3UVhkMmt/U/2LoH6qM4eOGtOl42KQcrz4omKnjRbUd8pJV0caXCwykuEjEqi?=
 =?us-ascii?Q?TtsQLUQJnBvjhYAXHQL+cDAmAV1BNCp32+s7ZyedN48IXsFwquuYoEtJPqec?=
 =?us-ascii?Q?pUU2FqjDfIvYicLKGPSlzz8CzHxIrMqI+B+rRSUQzqEcycvKHpM8w7E16AI7?=
 =?us-ascii?Q?GYg+EDBYrnfXF35w0+fLbV/y32HkcVYTAv9METJx1BngAr69+8wObD4oMGCA?=
 =?us-ascii?Q?NwvJWeZ68Z64w6Guj9X6a9A5tnVrq1u+VUAEUtVDYVyTSgMklV930woZOVD8?=
 =?us-ascii?Q?L0OWOwHTx/JJpAewfmMntHjuI9nngLAT1OfdI+8+B4rqUtgs8NAvNhRGhOj9?=
 =?us-ascii?Q?qIMyjrRrVmmwUcQKnPc7c7u/nj3EZ98sEEzqwI1pMlH32NY5pB53NuzGtURV?=
 =?us-ascii?Q?wsA2f0fDW0IluOq6de9xYtrzSkiM+w1W4pbXAlJMzWIB9dpMyoz49lAoN5zy?=
 =?us-ascii?Q?VqnaQsgVaeKnIIHBkOZEsi+F+WHdtqXDkzwShSFGcQ7ei1Mq3x/gBrhzAkro?=
 =?us-ascii?Q?PPIV0Hd/kUnNKH6gk1c3BmN4t4827RnKiVbyP/GjN2OhfiBepcERX/Hjvqcv?=
 =?us-ascii?Q?X+ooZctAXviGjQzux/gwkNopHtvmwLngdDB0LHa9cMdahSRgta0o4eysGFCA?=
 =?us-ascii?Q?YACDpCnqrbBQcNi/JByHGD79wKiqaPjP5awxUMYi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1501a4-de05-4844-3348-08db52ebaa4c
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 13:20:33.3932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SFBEG5lt1/N87RcPUVXS6gIrkb11bvjmyEtkRAWaUE+UCs+0y9J7QkDhR3aq8tdZthQZ8QBGbe3aUWdI5vtFbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8730
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch standardizes the inconsistent return values for unsuccessful
XDP transmits by using standardized error codes (-EBUSY or -ENOMEM).

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 v4:
  - remove the fix of double call of xdp_return_frame in this patch and
    will correct it in another patch for net.

 v3:
  - remove the fix tag.
  - resend to net-next

 v2:
  - focusing on code clean up per Simon's feedback.

 drivers/net/ethernet/freescale/fec_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 42ec6ca3bf03..cd215ab20ff9 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3799,7 +3799,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	if (entries_free < MAX_SKB_FRAGS + 1) {
 		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
 		xdp_return_frame(frame);
-		return NETDEV_TX_BUSY;
+		return -EBUSY;
 	}

 	/* Fill in a Tx ring entry */
@@ -3813,7 +3813,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	dma_addr = dma_map_single(&fep->pdev->dev, frame->data,
 				  frame->len, DMA_TO_DEVICE);
 	if (dma_mapping_error(&fep->pdev->dev, dma_addr))
-		return FEC_ENET_XDP_CONSUMED;
+		return -ENOMEM;

 	status |= (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
 	if (fep->bufdesc_ex)
@@ -3869,7 +3869,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 	__netif_tx_lock(nq, cpu);

 	for (i = 0; i < num_frames; i++) {
-		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)
+		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) < 0)
 			break;
 		sent_frames++;
 	}
--
2.34.1


