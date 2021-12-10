Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EAF470B2E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243465AbhLJUAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:00:38 -0500
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:17409
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234222AbhLJUAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 15:00:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4w2tSQeHvPrw/HiwxscJn9YT1CS8KdLK3iJQz/aoX/STGTChRh5sVYtqyiHouOqvn6Le/MqBhz9Vf/Rq57opLeBpsUb6XY6riNLQk9e9UVGXbwhLflxIBO5zIIHM13MzhObqZSptt0YR7LQ+Da6nY1bJMJG2qrcz4LNk8aIJtMMSFzHjq6mPn8Va8L+DAUHt0ncJiXSwywA4Jk25UHKhdXJbRoC8naltrHEtSGPvsFgVSJghukf98z2pVauggiVdS5l6Q0zb/l1eeVmnqMOfKVVSyV20C+ahG9UgmHTvPb+hGmGe+XZLry8GOc3/GOFMuAksLBQPR8VHH5OcS+cHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lL4poCPnDoQ1PP7iT2r5Imsg0xj9+zBvPZq11ZSQ/fU=;
 b=MjyHj3KdS5HPwnWUg7rqi122OrovGEtbQ9Gi+hQhHN1u13gH/6yQhokJRWhGpaUadutWC4DGuFi3EalUkgOCVW+jYUmo8g1CAv2Izi82oFaRoboKS7BzTNieopmf2PrIH+ZbpHAYBoVjoX7IZOLEnj2Q0ndSC7spKXGxC9/ltRlc6lO9p6vViaGeoThN+FPpvYUpxwNIyZUshu3kWelHvGZGPK+jziSlormS2xsD9zZ7VWE3zDU9wuFHhAc7MA9f5d+2ASDEkTk5A/lqhaNN1wVTbt/zXwAxosdGKI6r6pTVDSv4kNKFzBwDxHkhNK8U954YV/jI0WQWk7ERghaS1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lL4poCPnDoQ1PP7iT2r5Imsg0xj9+zBvPZq11ZSQ/fU=;
 b=T64Qbh/oF+2JqWteMr7C36i0yOe0c//qA1Y+rrRRGQ4EfVH9XUI/H7PZucylKSYZY3jHEtjvHtpzi4gXVtaXmnEs8X0+Rc6NSLzCPxfxO4YrtpTSvjbiJnyJK2VstQWHxD1vEKOM2wCCLyflEWJM87t57Ujb21vNXD+v0coN28s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8887.eurprd04.prod.outlook.com (2603:10a6:10:2e2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 10 Dec
 2021 19:56:49 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115%6]) with mapi id 15.20.4755.022; Fri, 10 Dec 2021
 19:56:49 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [RFC net-next 3/4] net: stmmac: do not use __netif_tx_lock_bh when in NAPI threaded mode
Date:   Fri, 10 Dec 2021 20:35:55 +0100
Message-Id: <20211210193556.1349090-4-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211210193556.1349090-1-yannick.vignon@oss.nxp.com>
References: <20211210193556.1349090-1-yannick.vignon@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0153.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::20) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM0PR02CA0153.eurprd02.prod.outlook.com (2603:10a6:20b:28d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 10 Dec 2021 19:56:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d97cdea-65da-44ee-3c5f-08d9bc173411
X-MS-TrafficTypeDiagnostic: DU2PR04MB8887:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB88874A0DAFF7D5F16825037BD2719@DU2PR04MB8887.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1nsFJKtUlCzgKCVLGKkGFZw9+P6Yw21Kj1Se5FO/6mSaTtP3EbdfM0zHj8rMtTR+h/HvgxQJjk7e5esOhCDu6pVTk12nHFQp+hBT9tvV3DhvSpwgVzh/ctPMVaEJiZ5dhoA4n7qDVWXXjuoQyMjbMG6+Cs4uJwiIpLhlrimNsoRaUXV71gNGGLb7bK7vNkWGLjty+6AkXh16HO0ZdQcQs/AC4mEyvur/uR81UqkuKrnTvz6NPRFSIL+wtIHNHSihjJhZuS9uBrtRfUo1toiayFSRek2RkjB6qIvK/9pnEsu4rbfYoDhv3N91HckF8WrV93RnJi75JgqCil40heuqfTnqf2c0iL+wAuFTjC6Fw6wNoP1JeOKyeD9KI30O+QfxPkldrGGGW7iBsm6jP3WjQqWrFe/pczdE6SZjq0VtPK5Hvmna2NGss+3mAue5vNiSR9ItxZ7hBMZLSLT8VY+gw0gWWu0Uo7TM0V/iXdle+3sK9HrWVEVJPXO2fjkX2oY3H7La6WNODP+ymrB9K+qn/D5M8WOGg2byM07fCIu3GwelbbuOO8CcGRoPWXEaYpnTRVHiiNk6jcUlAE/Is2gnwzHiWIdUyLXHFXaLyHksWRTPsWZrr5zxDdV7/3f1EmCMrCOcBmToSLRogEY9LL5NDrKclJAxe6MOKG223dn46RDtYfc5pZYky8hbZ44dhuetLzqu/UA26hhk1mPb6sGiIHMJl0NMpWq0YB+1dThTn9RefwwO87uaa+5dQQQEcKPY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(44832011)(316002)(186003)(6512007)(110136005)(921005)(38100700002)(1076003)(6506007)(8676002)(5660300002)(8936002)(6666004)(66476007)(52116002)(83380400001)(66556008)(66946007)(86362001)(508600001)(6486002)(26005)(2906002)(2616005)(7416002)(38350700002)(956004)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bDfVqqSv6XaxuJdNctYbYwiZbZ+cF+A12Ou406W8PGwUaxP+lmNjuSEsFlVb?=
 =?us-ascii?Q?CDpznMi/MsnW0ignoKAU2+L+NkzjLp6SBx0EoXlEBQUtkdlABWxA8pVkKmzk?=
 =?us-ascii?Q?yJSJ69bHJdiwHAjCSOmlTyV186hyW0FQKtpTdLGtGPGfo9FwHq5lLfh76Zav?=
 =?us-ascii?Q?loIFToCRK3DUyXca2d+GQFAstE7GSGZlI1M4a+7quXSxQnfVEsSE27PkT8Hb?=
 =?us-ascii?Q?BF44QsR/Wu+lAQtrCAmxn4dIhSjA9lozXbOndmtK5g2VChUPQt4bEZtnzIuh?=
 =?us-ascii?Q?PXukkSuOH6DRJsE7oZ+RfxW+22kRI29rvwEI5Ml56YmtcKwy98zoENitXGEC?=
 =?us-ascii?Q?1JlWAMHF3NoCN1DInXi+Zw1kj3PEIDbEjVxYiQeB07HGyD5GA85wQ1uiI3dE?=
 =?us-ascii?Q?Q6lz3jKcXTgPCJdjbkq+IO6nXGUCuWl+IUj1uErq5UqSb1KQ5SAjUuZwcusU?=
 =?us-ascii?Q?90MhnRFFgnDwBBlnvuJa3UP8gEPwXA0oBsLkFz1n05zgzf7WFynQ8vYl1wE2?=
 =?us-ascii?Q?OJU/8Mm2CmnSufAY+xI3aHluM8bOVGR2ilGKFdyCZCLl6nzef+jYhq4hfMB4?=
 =?us-ascii?Q?gRf11p8oV0qK3NZGlimCc+o5rR3PrOOBa2zf+9xhu0+tH2Zc5HpwecKQn4sO?=
 =?us-ascii?Q?HFc/gHBc8XLl0o2IwZHO2AKd70lPLxiQC8/4ZC0Rr14Obgex7OsV2sCrLhk9?=
 =?us-ascii?Q?18Z5PdmifRy5HPz3h/bi/DCcCcVyMgqSgTBwHGrH4a99usAlq27iKmXLh5YF?=
 =?us-ascii?Q?NFDta7Sm6O/qFwNyD2DzZMrxDGpCWAULze7qrjCQHwoWb1/SymzetCp5eOCz?=
 =?us-ascii?Q?dz3jVO9ApSCS4Tz0d9hmHit6KyukyN22Tz1ZIWcYEOZY9xYUBX5IWkfcnkYu?=
 =?us-ascii?Q?0Hv8Ew+NPtFyOy2YBBiplDkSggiXSLZXQTG0D845P8JIc9r2d26HU1fEwdEz?=
 =?us-ascii?Q?JvWvaMjWKRukwucUfrWdyxUSsnS9+nrgDzRNUdVouflVCxgXe26IB+WnFR5T?=
 =?us-ascii?Q?Xme1sO8SF3Jm2zBV3zKK7DnLyqb9U3GnLMjkgd9e5n1TNjPc9D4gMuDB4stv?=
 =?us-ascii?Q?ZeHX7VnYoLDwWfDHl13xCUx8nRx+RomeaIkDxZMjAGf5X/wdXZXgPcU3T+en?=
 =?us-ascii?Q?SzQSRxmRIwLBr5TnjTE+TIRFiN6W5NtAOqOMdJi39W+W24XzjpnroCsVa5o+?=
 =?us-ascii?Q?GFLxufHaU2H5Sap1uhcbabMSx7VlyO2bRiUPfzWQVn4YzCTbXkSltEfq/U6M?=
 =?us-ascii?Q?oGFRsFVCydR/9foYJqxSjMKxro1Czzbb/qORNRGAWlMcrnlu0Grsjz6byWJe?=
 =?us-ascii?Q?09dcmvyCA1d9j6bDsu5WMRd6+Jxp9pZ7I5mBuG6Dmcnj5R26eQU/cTIZblXG?=
 =?us-ascii?Q?+I/ZrlbSRCw+xnjxAQ3LrNWZ7kqP7FcbBwOoMVvY+ulGJPZN5kYVEpFMl/oA?=
 =?us-ascii?Q?+T6xqERHOqpG5MjCQKwWqhLJq7qV/7YwoCOj9Jklw/6iMU0lRTRnrI8kQejY?=
 =?us-ascii?Q?IQnBH2KGvQ53Ae8idbs8au/TBRXZTIlQ2qhpk6s2AXewnvC5GL6DGUpWH9r9?=
 =?us-ascii?Q?XBg9hAnv+WtJ7AVMORSd/9SMRukWQug6gp/vI3V8Pw4g4IBzu9OoMaPCefsj?=
 =?us-ascii?Q?5gcWbqK6zUac6hRNPJELC5Y=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d97cdea-65da-44ee-3c5f-08d9bc173411
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 19:56:49.4734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s63sFZ8XTtBLgeAvssIOghK/v0s/N0IROfcDaqK2K1ETD92JitfLYnAwNqHhl0sa5KMmYNNQREOY/I1h5HHjsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8887
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

In threaded mode, a NAPI instance can not execute concurrently in a
separate context but only in its assigned kernel thread.

Replace the calls to __netif_tx_lock_bh/__netif_tx_unlock_bh by their
non-bh version to avoid disabling BH in that case. This prevents high
priority traffic from being blocked by another piece of code already
running with BH disabled.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8bf24902be3c..2190b40fa92e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2481,13 +2481,16 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
  * @queue: TX queue index
  * Description: it reclaims the transmit resources after transmission completes.
  */
-static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
+static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue, bool is_threaded)
 {
 	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
 	unsigned int bytes_compl = 0, pkts_compl = 0;
 	unsigned int entry, xmits = 0, count = 0;
 
-	__netif_tx_lock_bh(netdev_get_tx_queue(priv->dev, queue));
+	if (is_threaded)
+		__netif_tx_lock(netdev_get_tx_queue(priv->dev, queue), smp_processor_id());
+	else
+		__netif_tx_lock_bh(netdev_get_tx_queue(priv->dev, queue));
 
 	priv->xstats.tx_clean++;
 
@@ -2646,7 +2649,10 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 			      STMMAC_COAL_TIMER(priv->tx_coal_timer[queue]),
 			      HRTIMER_MODE_REL);
 
-	__netif_tx_unlock_bh(netdev_get_tx_queue(priv->dev, queue));
+	if (is_threaded)
+		__netif_tx_unlock(netdev_get_tx_queue(priv->dev, queue));
+	else
+		__netif_tx_unlock_bh(netdev_get_tx_queue(priv->dev, queue));
 
 	/* Combine decisions from TX clean and XSK TX */
 	return max(count, xmits);
@@ -5377,7 +5383,7 @@ static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
 
 	priv->xstats.napi_poll++;
 
-	work_done = stmmac_tx_clean(priv, budget, chan);
+	work_done = stmmac_tx_clean(priv, budget, chan, !!napi->thread);
 	work_done = min(work_done, budget);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
@@ -5401,7 +5407,7 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
 
 	priv->xstats.napi_poll++;
 
-	tx_done = stmmac_tx_clean(priv, budget, chan);
+	tx_done = stmmac_tx_clean(priv, budget, chan, !!napi->thread);
 	tx_done = min(tx_done, budget);
 
 	rx_done = stmmac_rx_zc(priv, budget, chan);
-- 
2.25.1

