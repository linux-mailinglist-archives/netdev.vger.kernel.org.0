Return-Path: <netdev+bounces-1564-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E8BC6FE4CA
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:05:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2B101C20D99
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC46182C5;
	Wed, 10 May 2023 20:05:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7790C18013
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:05:43 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2056.outbound.protection.outlook.com [40.107.20.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56513C38;
	Wed, 10 May 2023 13:05:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4xJitITL/pD8mj4ZCyW/hsxcqEa5UoGJCrnAY3tegqG5ZQBVsyKV+rTv0jUYGzEuGFafJl+uANMdqWVEo5pAMdIzGRxwA06BCcQYX2+s/fihEL6QR+UlXpC1ztY5BAr/G1gzcgx+U5KIrmW+S+DihF0ee76JZYqYpuXI9/w7bTdRw2uB9/M5eNXe+qdlhPZEyjQEDhJdrhlypUCxTbx7OaABPupS+YZRb0IPccWbSahPrnxoSiVo3b/y1eW7D4q8Ollg3qTtj/vR7cMaag9ejsPhzGonqAoVs/HW7Bi6jm6/dVznLQun5FRpA19YWVJmb+P+ttkBKOkEUxhOIbAig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+lBEg+dBLko0PB35HiDXVZuSacoYvd4clpEPpLDoyM=;
 b=bjemSVH8KyXFzi5TKbJsNrjo1m1Ow+nLYcRt6MuQZEMG+bNE5ilGun6KtNCxi7TZ8gqYRXraxMCkixpYqzjQzyvv8y9Fzow6BxqEIcEAgULNUae1HKZVCzCOBVksSQM2QvUXEPFTfW/ZKWb3LETDPZBgZG+xCWJIIpkOY3Q3mR0rFNDR+t8NtitIBEpMYBtixBKBGKTe1kDiua5VjaFIii9uYFjFXLtNkfEI4S+EIeIpBEpFAU790/EaBLI6kp8FI9ePG9DiYqEJ6FWe0HAvM6LkTVq7sIox/PmKIF7xgtxnIxxVxUOTubt4Ms/GuNNMqvhbXIOxz4m+MkQqxXJRtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+lBEg+dBLko0PB35HiDXVZuSacoYvd4clpEPpLDoyM=;
 b=PGTtSqIQ5Tvo6XGfLEDslYigfFnBBF4jJb+8pnHhHq3H0yl47Ri5W5HWF2oYzMMhappWx9RXzf39UJ3oWxpwbaKrNxBjsKJxSDOqQ1I3f7lWIaf1kwlOmZyWURvfobtbfSup60H9jcgDADX5wPYCRnc4IbmLcGYQGMAiu57AwLw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DU0PR04MB9419.eurprd04.prod.outlook.com (2603:10a6:10:35a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 20:05:37 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 20:05:37 +0000
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
Subject: [PATCH v2 net 1/1] net: fec: using the standard return codes when xdp xmit errors
Date: Wed, 10 May 2023 15:05:23 -0500
Message-Id: <20230510200523.1352951-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::10) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DU0PR04MB9419:EE_
X-MS-Office365-Filtering-Correlation-Id: 01dc9724-b7f4-4df2-457a-08db5191ebb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DBAe7HorieiW8cAlknOny//p0nUGE6w2aOxnGmM5o7lyjB1iGksLsgjlcvKzlrWh5gl987dTE+2VC678uO1ANV7nSWl/1ht5TYJWmJjiZ/bdOKa/onQ0IVd6D3uwAOYGDJVaPA4C4qZLsmRgVFyZfXrnjiMhQk6ruSkwBjol8XwfzAaOl/y9SEIK3cmx9oibpG05CZeZpm2A9eTVVa2gBTPVyGFOz4iMODAM42sGDbvqfK/55wsWOc71qmdJcpN2zcb4XupiTiPP9/+eRgmXnkp/DfGgID0G0/JQLZ6LI9Tpy6e4ZItVpcljOnfp8A1DJAVFhaqlAmhgoEXszZkFi8OlZMXEpVi9BTHYLILA4KVVLD6iRGR0dolWgOQOkjVOIKjbyOZBha5A5+Phroh3TTLmPucvfzLOaKgYWQzLO3pGaESLyRjyDMQB97Zi64UGGh4/yTEqq7lbXymQQYYJiC1i0oRew/vWDiNZXKFDRvTK3CMcJ84Q35gy2ZAFuXSrWzHAIB7dBWF4W+yUcS9RfJCCbCEbdVL3dqtFvZCnpuPAq35gmGUqqjOXFAdW+ukfs80cNW+wpXh06FCfYUq1IGwoZsK/hv5nrzSVWDL4AkDwX6SWzqk5Sq3SkvL4bGzr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(36756003)(6666004)(41300700001)(86362001)(2906002)(8676002)(38100700002)(44832011)(38350700002)(8936002)(7416002)(5660300002)(4326008)(66946007)(478600001)(6486002)(66476007)(54906003)(316002)(83380400001)(66556008)(186003)(6512007)(55236004)(6506007)(26005)(1076003)(2616005)(110136005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZMwYX53Pcn8EiY2TCx3xuP6wme1/vnQId9uTmufdftsg/KQN3vmjH8UCal0C?=
 =?us-ascii?Q?aAB26G1m0lsKRYFvIJmJJ1fLTfwk+oERqMr0q3987jJc9Yq/w7UQvGPtXMBu?=
 =?us-ascii?Q?g3NhC4+O78cpW4mRaF7ABWCNk4BPZTyh15gdRJBEzSN0eI7YwWsiqxUBaUip?=
 =?us-ascii?Q?z7VDVPYlQy7V8gB8JJX3GGADKsBwpTthq574Bg3aKYt3MZKWMUZqtGMo6uPy?=
 =?us-ascii?Q?aExBOWINigrqclDmoaXcpqvnqLPdoyFPi7gr6IFRUVd/3NGa9HIeRkvcd1m7?=
 =?us-ascii?Q?oO/RjDlx1voltv/6PiEFApBBYVu+mUeIRAxfsIq1kNai16JhmzhnJi0BGIgK?=
 =?us-ascii?Q?cDXFQEf4+KU16Y8aVcCnMt2VIy/DC2ZVKO9lGFfMS8DlhAz8OyR1LwBDT/Jl?=
 =?us-ascii?Q?/taHNodXwx1tDg+eavnSUWPV7qC9u1AWSEBwge3wTjCOZ1Biw3mnhOE/qaon?=
 =?us-ascii?Q?edxqtHZwWRyJuQM4r5UUiUpnCLG9oXia6WibkJJyFLs0o2UC4PjNHDdbAlCG?=
 =?us-ascii?Q?3wb+HMEr4/8eF7g3s/7849zjhE8NbzuUggQw7BXaihRg162746Ei6Pgvg9CN?=
 =?us-ascii?Q?IYUt7gKNde851bop3XROq7EW1mvk3N6xBoXbvbj1+rwCFuzFIOYJLV8zlT5K?=
 =?us-ascii?Q?TWwfc6zF//FokpaRChzyVntTgPOApIlpwEo4cWfcLNPSCqli47HDSd4f1/AV?=
 =?us-ascii?Q?nEAESkCSOdWwYeK5c3TEvbLn97PrjfDt+Xf+o8OrNUpXK7w4qORzkYNWnqTf?=
 =?us-ascii?Q?GOR9ctro1a4tqGKXBS6ruqdhQpd0uTYFVyERI/zePVi5BDiah75y0peGQn+H?=
 =?us-ascii?Q?rpxWvkzRVBq12MwDvXUt3J7k7fqnWJtr06TiTcyLUFLbXRTRt45z+R+iKqCH?=
 =?us-ascii?Q?8KCrBhH7EVh9rgzWGWcMYdgokmuI+LtdpmKgwNr78M4YaLa+NtFT45bVY5PQ?=
 =?us-ascii?Q?+47hQ6NtC/EkkW3Ux5a+m3REV2T/7zFD9mDABXjxjvGf7s+4cxV9PD00rPdI?=
 =?us-ascii?Q?ulgLpk97FbGy9ZBE3BOsSJdsm824+R7XB8CEIWadKNBHpDj5lohC89WCl+rD?=
 =?us-ascii?Q?VHKLbX1vtp8L2BLUl/mSW7N2uwgZIPYte+McrBytxbsKD6mp/ESGKInr2uei?=
 =?us-ascii?Q?K/BZM+uuZsMGlEvV8swjXH43dIpt03v0R6Kn1xLcwdlbZGQVD7aSpkPpNUkh?=
 =?us-ascii?Q?KBpW7qdSlz8+gp46Zt7JJe2EBxyyaCcuIIdNyN1Y9hViClbtX5j84xNhq+Ww?=
 =?us-ascii?Q?P3hE82jvqR8lNdraDskALN699O71ZL1tpddH6A54UzNind7YqF4jzatbRsfO?=
 =?us-ascii?Q?OwkPzbIPfWTDIZiF5zUFUh8bnP5vewf5iiEQelpzIwq/at40dJ5VPsL768Bi?=
 =?us-ascii?Q?WNTGDHAp5zTAq/nQ/N/O3IlGDL3+hS3z3e1sbN1vJoOHnGSZRPbtwcEBZxiS?=
 =?us-ascii?Q?OXkBsCZr9xeUHlDYGmQCaYXeTRG+pKTy7H9tdju7la6bbO7WrFjgskbQ/4u4?=
 =?us-ascii?Q?7JmJWlZg/YEtAx5vt2eRFMgjGbZONpRE53ZlzmYQtYwoMjLV1QZELAhC1btt?=
 =?us-ascii?Q?O5CiPpWmeohwMuFYSNYQUeTKr/rBGDWC+nAG7ReC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01dc9724-b7f4-4df2-457a-08db5191ebb2
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:05:37.2663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEe/akf1cNWtMhIoe4nc+7uJDP0p1QhlCAxQ3ldjhiG5zVSH7Y67OEzU/pv6Nh2cxDG7RQbms9PiWBwL7Ud0Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9419
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch standardizes the inconsistent return values for unsuccessful
XDP transmits by using standardized error codes (-EBUSY or -ENOMEM).

Fixes: 26312c685ae0 ("net: fec: correct the counting of XDP sent frames")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
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


