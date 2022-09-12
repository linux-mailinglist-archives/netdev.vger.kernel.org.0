Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB035B610B
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiILSfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiILSeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:34:11 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20042.outbound.protection.outlook.com [40.107.2.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEB84623A
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:31:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VU+BazPb0BeRBS5VsdWQHn+MXWeHKnCnCDow8Dv/Z54OOIBM4Epnaa+XLS0sT0xju4Ve7VNZQlkpIavf9VoWKFGHUNZw9PwT96QHXAVkpDdWx+Q0O6IVAjZNwPV/edUe1uZKfwx3aRLRxvDLdA/HoDvFQZlG/RSGjhMI/fvRhQNRZzQ5yMhGCniyiQ1Kwczs+isVHySKvAgp2UuriRbGxNKUlFmfWgBejiay5PZmPFyS5Sl0ZhBHYJ8A05VEDxMLgHGENQNimlkZrTgkTGmhpmK1N8/SdQKl2wSAaL0p4gSsVcvXe7p9Kl7ybXk5FS+XegwTG+ND6TrJzNLhKNuXmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HcjW3OOaF0p6yMlk4erDLBp2Jp0RsmFh2DqTHasZ2CA=;
 b=SXDRu7uxKaSjSXhwdms0PfldySSZHSqQ9WaIp4sEB87omfZcVlYUEesFyyPMfn+PKOVU89Vg+Ut8mvQPaCvp6/jMVQGvNmT5l55CeLHzam4b6R6L9E01kSTmW2DPsPNHXcAgSY2xK2NuhKuR/4MzVs7JGyO7YYucc8oEvnPp9WxYkFFmyX70DoMAW44uzEk8rZ9qT9x98rWrwsoExAk0OTtBWUQYSqZaToKKA8WMu6aVW5exkykt+JoXDobH9s0NGsrGmwwwafcPQweLTZfrxjQLcP2NnGDEPH4GYbpNnvYBVLVV4enqNUnW+i/AnKn/RDMQYT/BECf0OxsuX5KtUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcjW3OOaF0p6yMlk4erDLBp2Jp0RsmFh2DqTHasZ2CA=;
 b=WLMOmhmNgiJzHB/fRByz8a0LcOPtmO53Jl+CPpM43TIhzHFox8qu3a0xfWwlogzjNmYMapX+28Sy2vT8oj97ujjhYBY1OO3N+EX4OIdvxYNPomsy44RHwVb7zEyjdlE43OWjEhkW6erHvpm/FuEpjCPt+LrEtV7RiQgXHHHEwb4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8023.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 18:28:54 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:28:54 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 02/12] net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats
Date:   Mon, 12 Sep 2022 21:28:19 +0300
Message-Id: <20220912182829.160715-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220912182829.160715-1-ioana.ciornei@nxp.com>
References: <20220912182829.160715-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::16) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: 856b54d9-d09c-42d5-ccb6-08da94eca593
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cuOy9xgKJf5vh3Bo8ccWt+yHeD4K+5fUejMzRrN5o3xfC7POCY/ML504SdZg1qSMno5eGzRDoiHGYM3DLx7SXINIrBzVovV5pE/is651t5EzX7KsatVu4s7wBchswpU88LNvFfSuAlsGGJwHzoBCkbni0+kCZzNRNB+wfQinfw3zalLL9ugK2rq+PtK1jd+Hlpx0x2ybK/WNK3AThlCRyP/nV2+SG/JCYCRGoSjOcjMKawgOpK+SfiWDO33pfWsVwpMxR+Mzhw4sDMBPlLuM/MCwhioKKUw4xG1tIC1nipQfR5Ni0mF8fZdYgc1uXHuguJbZw1+Qur9atr8pMMhjCbCwTTAIhsyOZilK0lbRYRPEKl5E2voWvl51FAaOVZYICoB5s7Sh2i+R61Y4m6bpVAkgvfBSGL9K1sXOGDphmrGzPcjAvjVgPydSs9QPOwx10+co+SuuOJGlsPzdX1EqtJrI6bY5FwsQkKTuZ53H5g3IUAhj/3np+iVIHf4cJu8oNnsBgHzJ52qf8oc2yRLtF7Pq3Z2bjylStKtUBe+tiy8uoeWIr5O5Nn9tCOAv89QKyGqlI0MVZegvIrGcMiWAB/deLJ7+eyCnobxLSOA+mRvdN1HmZ5yHGOzEQZJOCE4gkswwRm8qQMxPrRI5jUj0x/n28jEsbbL7os5UIpv3pGjoYEGD/8o2FqdzDoyQc2uh2eEplyX+wQh8zhFN57FZpHZN/eLZJonA8RGyQOTmop3boaAMFVOzQdUcC4VX96l4e1T7Qu8Ucmtc0/U2+/dlyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(4326008)(5660300002)(8936002)(2616005)(6486002)(1076003)(2906002)(8676002)(6666004)(316002)(36756003)(41300700001)(86362001)(38350700002)(38100700002)(66476007)(44832011)(6506007)(6512007)(66556008)(186003)(66946007)(52116002)(478600001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XcrZaQ3K1GtTv1gPvlcoI+YEfYR0NZUjbGefuGPH+HIjBFZWfOyMwqDXC2Bk?=
 =?us-ascii?Q?EKTgf999Gjx7/Ovl8YiVjL/w7u8SFPm+7D+nvpxPD/omN14ySGH7Ol3rL6g3?=
 =?us-ascii?Q?eb1Tqc9YBTOMut0kxAv/Ivn432HIJgrKdDrlr+On4OVEPrxnFm3u7+O1DNvo?=
 =?us-ascii?Q?M0xU45+TODI0yKbJun72V87myMzu4Sr9enWG9eruisyObHtECI9toWf+JrG5?=
 =?us-ascii?Q?u8btXnB0HLlHtya1bA7GLzDrwLKvqi3Nki0kTDnjIO+Fw0R0Qp7HdDSypYiC?=
 =?us-ascii?Q?mzM34WKbLLN/Cf2J/KFAPlldKatOdvbIJ9fwN5PixVKbkYcBelJihcqvLeo3?=
 =?us-ascii?Q?oe63V2YxkZ78YDZT6c1ENlRx9jv9vl5vtd13yVW+fL2M65M4hW0mAexyx4fI?=
 =?us-ascii?Q?BRqZrjVybxg7fewA9urrnspojLtWiCJe44SrryzIgTjD+WIPfzd99QVDhztX?=
 =?us-ascii?Q?etKCPPBE4/dfkdESdAAZz2SNvc/C9gPnX9YjjAjqFAbLfWHLpFvAePgZ+/ZR?=
 =?us-ascii?Q?yveN5dwSJ/zvArjVG2g7LxW0mvhbvkJtow5/6Qo82OZhH1hDhM46bl757yWo?=
 =?us-ascii?Q?xQ5d3D5UqbN9Wk9geA/Pcn1SHsSU008ETk4i0u/QwoKMtCw9Tfx4CsbRQwxQ?=
 =?us-ascii?Q?gbxX8pgnae2ZOaXp/LZ5pl0nPiH4nf2/CMXqj2UsCocO8oITiLeYKHdQMjdx?=
 =?us-ascii?Q?vJ4XmKhaMf3KDnqcL2lj4SHp7blq5pr1shjeaVXx3CMe1k02kB8HnH95LCGa?=
 =?us-ascii?Q?XE26aX9N/HKdV4xPj2Sdtq/T0Y2UW/i1+FQieuubMmoD93mH2aeFYtoke0FO?=
 =?us-ascii?Q?32Xub7KWPuVPP/azeqcrR7TCJV9p7evSrkYtQfHSZscrgXNg9XRZCgdEaMgX?=
 =?us-ascii?Q?KNd9Nge3mCQNIqhXqp3I1AoC7DxYnE3pAI+exStIna3jlQ80/iRYpMnAEPcr?=
 =?us-ascii?Q?ZpAcpNjLz4HHpcGP84NQ7qCY1mRriQYjbtR47zkvpk8fyC4PcypWSzSCASG7?=
 =?us-ascii?Q?aPgMoGaz/VUr5Zs4gkqf1+We+/Sb9fx6km1RP2brQ/cx9E9bF0A5Ah4n5fpn?=
 =?us-ascii?Q?kwNyrfWUDEH76d49W4d2gVQRmfBBxpTOnCcU331iNNjaBG7oQtzswJvaDxb3?=
 =?us-ascii?Q?wLpBWa1xXpwlayE7Y4PMsvmkip8OlNxQIZwe0cuAlEh/4bvCwp+gpcwxrnWI?=
 =?us-ascii?Q?7L4MTPybhZQhzbJF1BK4apTZVmFX+rZ1xE75GaFh0IHC8VPffsE//nR9hmmf?=
 =?us-ascii?Q?0qi778k0ivuoB2ZjhJChZ9xOlSfBexRPVoGROW07hBYXlIAtLiw4er/ZyDJ6?=
 =?us-ascii?Q?XvM1+xbI1MaHQWrUVCbKbjmYkxoCO952rRbzKrMV3Ao+L5KiecqhR/Bzn+hc?=
 =?us-ascii?Q?xciCELm3xP0oo3AWSYeXSjXmJDMbqLI8hCIEU5ijd+M07rUDLdH+gkT3GQqI?=
 =?us-ascii?Q?Lg8RFetrB43YrsVNiDakqZlTme52KIlIRY3ObUtP7jukJTKklUcZGqzHU4gx?=
 =?us-ascii?Q?FNORTbyj9pt1uQ4aCgB0uHwtndVEp9q+YbjNMF84mI+8LxICjj8drnm+AG2M?=
 =?us-ascii?Q?YRiRE3hEfKz8sk/EmInZ/o/3l3cC9l9sux9N/aF4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856b54d9-d09c-42d5-ccb6-08da94eca593
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:28:54.1205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ozg5EnA9up6gzu5w0VHSx4xzI+BkNp11G79HQQmmfqOrXldyYVT38plYOr8QP8HYjG4FnYXv0ZwBWGQPbU+X2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rearrange the variables in the dpaa2_eth_get_ethtool_stats() function so
that we adhere to the reverse Christmas tree rule.
Also, in the next patch we are adding more variables and I didn't know
where to place them with the current ordering.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c   | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 97ec2adf5dc5..46b493892f3b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -226,17 +226,8 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 					struct ethtool_stats *stats,
 					u64 *data)
 {
-	int i = 0;
-	int j, k, err;
-	int num_cnt;
-	union dpni_statistics dpni_stats;
-	u32 fcnt, bcnt;
-	u32 fcnt_rx_total = 0, fcnt_tx_total = 0;
-	u32 bcnt_rx_total = 0, bcnt_tx_total = 0;
-	u32 buf_cnt;
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	struct dpaa2_eth_drv_stats *extras;
-	struct dpaa2_eth_ch_stats *ch_stats;
+	union dpni_statistics dpni_stats;
 	int dpni_stats_page_size[DPNI_STATISTICS_CNT] = {
 		sizeof(dpni_stats.page_0),
 		sizeof(dpni_stats.page_1),
@@ -246,6 +237,13 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 		sizeof(dpni_stats.page_5),
 		sizeof(dpni_stats.page_6),
 	};
+	u32 fcnt_rx_total = 0, fcnt_tx_total = 0;
+	u32 bcnt_rx_total = 0, bcnt_tx_total = 0;
+	struct dpaa2_eth_ch_stats *ch_stats;
+	struct dpaa2_eth_drv_stats *extras;
+	int j, k, err, num_cnt, i = 0;
+	u32 fcnt, bcnt;
+	u32 buf_cnt;
 
 	memset(data, 0,
 	       sizeof(u64) * (DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS));
-- 
2.33.1

