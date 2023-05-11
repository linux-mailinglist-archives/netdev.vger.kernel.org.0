Return-Path: <netdev+bounces-1867-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D1736FF5C2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:21:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA74A1C20F91
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B671663B;
	Thu, 11 May 2023 15:21:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AFE62C
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:21:39 +0000 (UTC)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2089.outbound.protection.outlook.com [40.107.14.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABE91BF8;
	Thu, 11 May 2023 08:21:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1cIyZki8O1kJ8vRo4f8D2roHQGQauOftSn+DQYoQxHy7/BDbnZBoULLGYwfzSsGVkFtQQNtld7OQCkepqljCsjqOvqPA4CvLXckSgNdSxbHIND7CTTtzKMSR8XtyR7bAFRxAQdetd/l0yUeZUTfFc0HQHqvWmAx98enqbnEpVwSvQ28Z4n9QQE9p9l4g8cVdEeyTVVHCxh9KK1eev0oH3XrJd2P+jLehnsC2YowsdMeYfeDE56L0qRAe/x4rS63gYtY6wmUr+BIuoWYOEE+Nu62W96La/L1krpiy0J6Xo2gH+FcTJo1ms1VWECfRzMBBYGhoLuZjZMfhNY1SmIMyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5sUeZMnNsQcm3LajAujOtB5TursVNZTNcPqagCNQYQ=;
 b=Co27qitpwokxj+Pcshq+e3k09fuDi3jgjtVVyytzRiLgXO0KQgvfaTN8GxjCYXMqovAxzMENRZploRpCFEIjZYGTtt0r0pOzOm82iWA/3qoRNUW5zxqJV98wVsubU+qCqPR8Xx2gqypskJ/OL/yiTTtf4714rK9E2mS8OgsC37wKpSbYeQRfels1tNLOqGt74PA1yk/RwdY3Ii8EU3u/Aa6k8tzdRIGtSn5SV2wfaycBNjAxZ1IQ+HKOALeI550aI4/kMI8uV+/YlNhmlDIzVB1ntwTG2XOsHfbVIoFwnCbXTCPx5VLIZg5Pi24KzBlgoNyop8WkIfaYMJcCrhpQ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5sUeZMnNsQcm3LajAujOtB5TursVNZTNcPqagCNQYQ=;
 b=Slb1tgYJV/GD/lrDjFkA2WYuX3osX7R1v8l2GgdiHIEvRB2yxMS1dVMjS+KwfQiwkG32c6aN146uSSjiJZi0ioq3rlSSAZJDHRlf6RB6Xn/Ztoh8On8czsKlMAwVaua0jW5Jd2EqqFym3SSnSU+8mHumRgW7DhXY0bTYoR22Y/0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Thu, 11 May
 2023 15:21:35 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 15:21:34 +0000
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
	imx@lists.linux.dev
Subject: [PATCH v3 net-next] net: fec: using the standard return codes when xdp xmit errors
Date: Thu, 11 May 2023 10:21:15 -0500
Message-Id: <20230511152115.1355010-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0052.namprd07.prod.outlook.com
 (2603:10b6:a03:60::29) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AS8PR04MB8040:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ec2d9ee-d221-488b-edd3-08db523367ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9nfFmPMWXjbAm34uEA8FXd1GZ9xCPUsjFwLRNrQDBVG9SN2P4eu5wkSbOpXkLrh0TsSPT5QXW82tPLALboTld2Cobb/WzX1kKv0zSITxtvFN4t1YeGw6iwxf7QxHvdvTV1Pk9O9MSQwD9HI+3ylFqSSlyvyZ+uCJ/FjXu6OBz6lKb8E4tIDn8rmz7Us/rJTlquMOBWSsMt4Dp0DAwbMR0OoHVmIstmLMHVhs8LEMTaQQRr97SlZkLCI0fc16HFyh+Otc9uHmoK9JLGeLVqYFyfV0Vw6RRx+aBY7NcpTgbBCs4opP8XV6WxjeemF1GILQn1Hc5saVpVgfMjevIl38w1sNkJsiBDzlinMx8X4WC3rtpUIpOg3KMAhmFFY7KRlsUaTt4yIEfA4Y1QH89wi2WwQ9av3fXVPaY+OfAx0IBE0e8p7De4eRhv2I1JTsGZJ3nRikklugMSf9BFIkr1HnShHG23oeR4+T8+QA3tk229GmLAbDSHe/4sQO93T5J8ryD+euGBXCvGQLfeAWYdcRa/z2MYr99TVZWvnErUecF/iyA4ryz4Wot/j9CHiQ0jPpVUg+hXStyofye5KhCPZBBTqrk5V/agGR3USjR1sDTarP/jwaCUFNlruOnGCdmcVI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199021)(6512007)(6506007)(26005)(1076003)(2616005)(83380400001)(38100700002)(38350700002)(41300700001)(52116002)(6666004)(6486002)(186003)(55236004)(478600001)(110136005)(54906003)(66476007)(4326008)(66556008)(66946007)(316002)(5660300002)(7416002)(8676002)(8936002)(86362001)(2906002)(36756003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9xbZisAlUNx7LKwdDt8dw38LUbryw5QM7Rx5FA1zK2S5ciRdhbc5YmyUE9HC?=
 =?us-ascii?Q?iImakxiYhBNfyjGxBic6t5oSiBgoyqP0migJu0avs6L+ld9Ldor89e6ZOiP6?=
 =?us-ascii?Q?IkhA2KFcicMrFTUBe9oQp5ISH5Y515uR5EohQ9YsHhAj0VecU4OyE1+FcBrp?=
 =?us-ascii?Q?OyM2ansdZUNJYuH4a+9TwGk+KsmuZWfghhGdduyRwVoMOFACeAhhb+NS51VW?=
 =?us-ascii?Q?TLLYh2gRbd9yrF4VTgeBOKkQHp5PIjO4nike/pk+l4G8i9UbQcc/AMDDbn5j?=
 =?us-ascii?Q?h25iH7KhzsQkqKBi+w79+MWCK791lsrszGm7qlLQKviIrxmZyZYEH6mZMhtB?=
 =?us-ascii?Q?q02bA20cJOyG1PY9mG2+FgNfhpMD5JcNPCsHJz6027iWoGT2ZKPiUOKs3yiN?=
 =?us-ascii?Q?32njtRl8nl8ajHdrNmkP/55KJwru2M3Z/OsVqBT5fbf1Uq81a6uKJptMVUwQ?=
 =?us-ascii?Q?GCpbVnypQZWDbfu4dq1HWiskzZmoCYoRKWH5pjAj0lWp53m1PyCNxspzHa54?=
 =?us-ascii?Q?Mlb5asKmM8AzCppWSEdOs5yQVqKsnsbAZI0/Yf8ZYIf7IHu4aOLC8wDjU/Ov?=
 =?us-ascii?Q?Asm1sT2EOumKy9Pc5yb/gGWAEJ6yku3/2y1T0ins8WrpiF2746/JirvcjVh1?=
 =?us-ascii?Q?HybYQakWaJFqmtWnC+Ml2IijrlfaeMNUHLG5yzmF1MjgeQ9C0aEec2U4y7XW?=
 =?us-ascii?Q?D8jBvCFn2QOrBJyitWfhfbP13vdXsehGbYMbOW3zQLq8NCTTXyqtCAxTVmps?=
 =?us-ascii?Q?y95MCJonF0ilxahAB3bu3/HPb0Gbj4MLijXHVaSThOPZNLzDJ8uXN1oqKdBV?=
 =?us-ascii?Q?ce5fbto7XLRSanGEuDcyyQ23l8ai827ltx1CCisuifS6qRnKNP1WSs05rkkB?=
 =?us-ascii?Q?/4oql72AKJwADlO2I/7oyHqbWZpo12BpXK7zcIORwWVnaBrNeALg4IZWCOSs?=
 =?us-ascii?Q?lnq679eRNUHPafegrpTCv+M6ydkCrRFG1HW+OlxyMUodR8eIu0YDnrCIQ4K0?=
 =?us-ascii?Q?6qQAQp/xNO/x+pYZWctervhG3wuzWJ0N+LwzbsuPbfvlhA0zJd/EZnPgGjrN?=
 =?us-ascii?Q?vPubajLz6GczmWKomM7Fd1fArcGqbt4MKyjzgoPjPAqImiM/P34mZ0sv4IP9?=
 =?us-ascii?Q?vo2A1sm/gFDYsBhAARv7IKqrdFxTTE4XPmg3hVaHNyhLRs3MU1wFYIxIq8tu?=
 =?us-ascii?Q?P/Uk8nDxPTomIbcDymUxhqhCnmPiNnZGwOuTF2zs7hx/Ij0MfpfyruOgoNun?=
 =?us-ascii?Q?9founehXZYQj0eKbOZQNcMIyC8K/E+4eGQ03tC98rWxt/i3Vlxge1C0Dxjh3?=
 =?us-ascii?Q?1qHJY24aUo/Bsn8eDRKQid0V2HBSTDy92rrYjAW6EQoc9pXP2xCSAkndwUlN?=
 =?us-ascii?Q?CSGdJPahaoOxBbLn+wi0Y9TbegogAVuIn+/2Zlegh6tlaSfRAWj19swzOpcI?=
 =?us-ascii?Q?QSST3d7AzML8uJpE8bcGdyBB98QU1pSyfGteHXhgwLCtSG5NOjAHmVPQxDrv?=
 =?us-ascii?Q?7yUgGk+VylE1/4Q+nij3MfKcTrFkRBXpYFKdO60+pKlhdJjld2uPRwHzNSL4?=
 =?us-ascii?Q?TudhhPlJh0n9dZIshG+C/MWWq9B7vDN7LKkubrwb?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec2d9ee-d221-488b-edd3-08db523367ee
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 15:21:34.6791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgdInuFRtNhyNSbJsil0W4B25aLGNpRGn36K7ApIpF56i4ndwvNCvUp0e9K5rdgRkTRHZMpx05nxqlE+RunL6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8040
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch standardizes the inconsistent return values for unsuccessful
XDP transmits by using standardized error codes (-EBUSY or -ENOMEM).

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 v3:
  - remove the fix tag.
  - resend to net-next

 v2:
  - focusing on code clean up per Simon's feedback.

 drivers/net/ethernet/freescale/fec_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 42ec6ca3bf03..6a021fe24dfe 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3798,8 +3798,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	entries_free = fec_enet_get_free_txdesc_num(txq);
 	if (entries_free < MAX_SKB_FRAGS + 1) {
 		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
-		xdp_return_frame(frame);
-		return NETDEV_TX_BUSY;
+		return -EBUSY;
 	}

 	/* Fill in a Tx ring entry */
@@ -3813,7 +3812,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	dma_addr = dma_map_single(&fep->pdev->dev, frame->data,
 				  frame->len, DMA_TO_DEVICE);
 	if (dma_mapping_error(&fep->pdev->dev, dma_addr))
-		return FEC_ENET_XDP_CONSUMED;
+		return -ENOMEM;

 	status |= (BD_ENET_TX_INTR | BD_ENET_TX_LAST);
 	if (fep->bufdesc_ex)
@@ -3869,7 +3868,7 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 	__netif_tx_lock(nq, cpu);

 	for (i = 0; i < num_frames; i++) {
-		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)
+		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) < 0)
 			break;
 		sent_frames++;
 	}
--
2.34.1


