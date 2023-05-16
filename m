Return-Path: <netdev+bounces-3122-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C361705964
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 23:21:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 034F11C20C1F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5293271F2;
	Tue, 16 May 2023 21:21:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23BC271E3
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:21:38 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2050.outbound.protection.outlook.com [40.107.13.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285625FD6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:21:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlUXyjXgbQdnNN/Yh7QOfPGwt849wRRVOEJQ31cIHN54G9IyUSpfKoOYqvN0rbTQWOO3ur88D+Iz/rSi6cK8hXh5q4vdS2Y/mTxtmO46SvpdhaKSLtfxLZy2mLIMKqGKBvv47JHU6TWVApaDk6MKz3waqI8zPGjA1vs8oobcRr7vFM2/nN9Z9NTwrqpAhy9RdhDqixWc9oBkLjECN+pcToHtLnB4SzjgzsP5lzK6OTtKmpY5hIpZx9nfVU1O1vOQyDRUJlwetIZvUvZcXXzk6/YNYv3DkBa75hvPGXZXmM0Dh1QhUc4CVuNNFXJgpxd85QACV1cLYPh5gIFhRy/bGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPAPyCqXBWEZqKR0KMFwHG3iniYVPiA7ajR8Krj/AhU=;
 b=XbSyH03nrit4QHE3Tk2lyIThBuPkB97Oe1/UWCwfK7ZF10xMmAaWnVjceaRRYNbOJIldhMRTPpmPKiTAS7EJ7ZD8VwJocaMaWptWTDLSfC4ARAfGTTDbQeSM8mzqS0918X0Vpcu5SBGZIrAtrsnuRxE6zMILO+CXpdaQOEI5JnVmBuZb37n+taHohFPZ+IASXOvDhHqLw8BmfT7S0hpU7K3xHxnQxB2Z2NswaDYMXuXUlqqsKAlwZrlLTdMGkMCBGM7fRLWESLovM6CHVnz/XYBMUuBXQLmq/MiBjKY+8ULGwGhQ5prqJ7yKsf6Tn85jIJvxo8QkJwpBTP7i3UYMeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPAPyCqXBWEZqKR0KMFwHG3iniYVPiA7ajR8Krj/AhU=;
 b=EODWPBPUxC7GCHWiFcyoRz+8V+Py6PDd5tXx1pFf8IOwIcdFR6LPEmTR/1uGh2OUiVXPvlp1NwrDwAObhBMr9ivqfZR4E0qxieoIMz2U9bCnU1jrn2egT+U9Lq+HI0dmdDTlS/tdfZ0YFLGG9Jh0lzNzmVgdu8avuKUSRzrlzC0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by GVXPR04MB9779.eurprd04.prod.outlook.com (2603:10a6:150:111::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 21:21:34 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6387.034; Tue, 16 May 2023
 21:21:34 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	netdev@vger.kernel.org,
	imx@lists.linux.dev
Subject: [PATCH net] net: fec: add wmb to ensure correct descriptor values
Date: Tue, 16 May 2023 16:21:17 -0500
Message-Id: <20230516212117.1726491-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::15) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|GVXPR04MB9779:EE_
X-MS-Office365-Filtering-Correlation-Id: c4ed318c-499c-4bca-947f-08db565385fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yB6qgglbJtxsYHW1WW1vT1zFtVVLkfIlJ7N6IT3XXxOEzfdl7IcgrGt51Y9P+xJk9AkKv/GSsOQRA4RHPd6xAjzvrRYv5xTJibHnViMhzHE9EckHZteAdxftO7FUONlV7PcCyT9+IynRrWExQWe4vaRYYmwPitJBNQ2cJ7QWJwX/Z6PNk5kb3xCUQ4f5rfxHvfjsuX1QfFZS8lRdDZE4N+7ToBZWSpzDO6c4FyDaRbmFXrqg+2fHj5xoxVCOi0BxufJVT7LqJBkNDrAQJ47uwehHeNN8WnICPb7fYxZhZhPDriDKVOPHEbLU/eIlYK6Ax76tRWQ1Y5mgqjhPflDIOYaDAo0VZXP/k1PUsCCL601AOtu2xq2T9LkG2KVzoOZFYVO6PcSYrzi1UdSWcmkGFxo1UnDlpojMDX6xzy+hjd6qVUx08vfcELGCm4LlYNKsWttYF9+Eb7j5Bc4IAQEfjP8HeAf4I0JoElCSAFTRfvEzE+ZO9VEUtwibHMpJ4iCV18uTSKfmZlL5W6oc+dKzMv9cAC9QStQ15uyxCBvEjVnTT4ZoZ6mHdW8nwth1LWMsv/RN28PMPF8WTAaFfL8ovXaMvcQssGcq9xaEb7v5+nE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(451199021)(83380400001)(41300700001)(6506007)(316002)(36756003)(2906002)(38100700002)(4326008)(38350700002)(1076003)(6486002)(66556008)(478600001)(52116002)(66476007)(2616005)(66946007)(26005)(5660300002)(55236004)(8936002)(6512007)(8676002)(86362001)(44832011)(110136005)(54906003)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lhBNF28tFEb4POFa0QKM/53+SDcE2NKOpGUCZeYHQ6pctDyVjx9LGhKhBu3G?=
 =?us-ascii?Q?g37Fzbo7oxKhhjTwt+8Hv5Wca+U6EvZ8hPlaDYa4k/nNMcaeFFudNAE+R/Uk?=
 =?us-ascii?Q?D3a0jTIo8FjeG/iKJlRLYDiMBJ1kc1TtiwQiQpnLSPi/fOqajP1vHNLIkV6W?=
 =?us-ascii?Q?h0+Jt+NsyHcqSForoRL0KUQJBl/46catCNPtAmMP8ZXlWr9ti29n+xWN/MeZ?=
 =?us-ascii?Q?bKw2Dh0EVTuVNdnqNvPBb9H4JbPdA5rQ6QuCJdiRuOGfj/MERJC0PLtudqYi?=
 =?us-ascii?Q?uZamdYvtXbywc71Q9mo0PbOvX9CdgKZqjvWhkQAeMgjPaztTOJyoB14V/rKw?=
 =?us-ascii?Q?BtE1FBtAWk2Vo3qbyhnk5mpx36LLvwo7xhSqlGe3MzlaiOIWI40QovWHtRUj?=
 =?us-ascii?Q?BZ0/IDmPrRAs9YAxiQk1uPuzs1BuPMM71s4nHo3USgXctq8TWFkE+vuhxfQ1?=
 =?us-ascii?Q?zQ6W2hRp60YjNNL/c37WXFvLrUuff5fdvvtjEVgXZsS4Jy2eakwPW0b2jmSj?=
 =?us-ascii?Q?X7sCaNBCPb8TCZL3tD6vzRv5h/lmI03nbsSIMfE1XAiI67ia8LsJyXGle0nB?=
 =?us-ascii?Q?LMhPXWcUDhJ8JoL0jQa5eY3wAUe3IC8lLZ6A8Fy5zs0ZbFJlWtGyd5/7WBL/?=
 =?us-ascii?Q?9ZP5ISMViQBfQdR3b3+DXGCkCC7WVYdtC6S55UeSGDpMtvuG/s0Zzf4iJZPA?=
 =?us-ascii?Q?FWKn/L4JRmqDR4gEEEmIs9WnxxigrND8xOQfyMpUxKW6lLGSXG/kbR2umrHH?=
 =?us-ascii?Q?u73G/molWja759W8mMFia7Dc4FWVw9lUIUOz1EC62Dss4jxxBSeppnWu3Ak5?=
 =?us-ascii?Q?u6w0+h4bfltFWG4arQPXPWB45+N7TvwokaT3bW5W+7McaKMdy8CkoOwOQIBW?=
 =?us-ascii?Q?nUcyv0c2VzokFVGN/YJqIlWq+QFBfBrbgULYCPnL08kIQZCEThS2wNVc8dL/?=
 =?us-ascii?Q?nOvWBgEarvSm6mbQZ4wJAIiHiyri4LycgkMIZFTASnN0L/Mslh0Mz+MNL/sh?=
 =?us-ascii?Q?wZdRE29BD/t8mvOpkiqriQpbPOc5JH6SnnNwhlo5rFqLSDi6L+siGcyS+S0D?=
 =?us-ascii?Q?BQCxxtubHDBkmClGUDzFTktOZ2YxCrRcZOLxBnMVnfdB1SrCMn7BKgrisrJ0?=
 =?us-ascii?Q?wSYFRfpp6y+TaUXUfwVx83Ez+Id/pEdrMzVfbEu3NtI4YfS8kJPt5PzbQ5NJ?=
 =?us-ascii?Q?663AgxvJ/OZqqTe4Z1dKRhEFx67MjxcNTPPEnr+5MqDuWozjOI0LTNO2mNHV?=
 =?us-ascii?Q?vTeld+z/T+Ua8Gm4wuxh2/umlCV4LiEVUv0zwR1HOCCPPoPdRv+HVXIc9oh2?=
 =?us-ascii?Q?gFjk51XTxVYA6z3xxW5PDAj+0REdLUslyTO/LWe+DR1NEPtD+MqIucSZJQHN?=
 =?us-ascii?Q?0jM2szAH+IrKRmorkd6lAMXwLipehAs5rEqTDQEahcXTmr4WvNINVvo81tgA?=
 =?us-ascii?Q?mW4bSK9GGTn4Q1iTb7o9lTj/V9CBXZKcnPCPnrpeH+CsMIKQADOzgCwL07sL?=
 =?us-ascii?Q?Oc6XskGJWC0O3bSUi/IsqMqlyf2rsESfGIXuzJXXTfrZ6GN/gC/UtgHzkHbx?=
 =?us-ascii?Q?5exYXaE7nDR3KDGZYmjAf1cfuWywEivSxEYnBCHh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4ed318c-499c-4bca-947f-08db565385fe
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 21:21:33.6739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZf3z9UDOWg/ZlMnlfNNGFdjtVp33EIzXCTGSmqFTWbNusMuOPhTEMH3iHKS5dWLrovYa6V1U/BV6iVWJeRIpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB9779
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Two wmb() are added in the XDP TX path to ensure proper ordering of
descriptor and buffer updates:
1. A wmb() is added after updating the last BD to make sure
   the updates to rest of the descriptor are visible before
   transferring ownership to FEC.
2. A wmb() is also added after updating the tx_skbuff and bdp
   to ensure these updates are visible before updating txq->bd.cur.
3. Start the xmit of the frame immediately right after configuring the
   tx descriptor.

Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6d0b46c76924..ba4335d5ddc3 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3834,6 +3834,11 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
 	txq->tx_skbuff[index] = NULL;
 
+	/* Make sure the updates to rest of the descriptor are performed before
+	 * transferring ownership.
+	 */
+	wmb();
+
 	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
 	 * it's the last BD of the frame, and to put the CRC on the end.
 	 */
@@ -3843,8 +3848,16 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	/* If this was the last BD in the ring, start at the beginning again. */
 	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);
 
+	/* Make sure the update to bdp and tx_skbuff are performed before
+	 * txq->bd.cur.
+	 */
+	wmb();
+
 	txq->bd.cur = bdp;
 
+	/* Trigger transmission start */
+	writel(0, txq->bd.reg_desc_active);
+
 	return 0;
 }
 
@@ -3873,12 +3886,6 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 		sent_frames++;
 	}
 
-	/* Make sure the update to bdp and tx_skbuff are performed. */
-	wmb();
-
-	/* Trigger transmission start */
-	writel(0, txq->bd.reg_desc_active);
-
 	__netif_tx_unlock(nq);
 
 	return sent_frames;
-- 
2.34.1


