Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9D51CBF0A
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgEII3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:53 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:9905
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727982AbgEII3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxEVWl4TmJD+yPwd9gw4x1aKo9xiCtMT4OOMm82F9PdJ8ZVx+DAfzKF/p1hQ4ov7qDlp93myqlLDXtEAFpjYheK/KAhDQgF0Ylj49c/xbW/J5uS1vtdga2uT8CjVZfXWo+FyPjdDxdySOIHMjP/kgRFXmjTvZF70UZomCxxmS4vgSils24g2bQaC8ts+otOm9AIXtxlhtcOt34CaM1JUc8xKkDcKBrS47qHVv3qHuw1XOwsHVg1jZHmFQsRUBwDQF0vSy4+IFoHPGpnPeg4Ys5g71KLpansPqoRe1bXXftdtPAeU0BOUtdxFaa4GfjfTMdPicHZTt/T8tNkhlFtvFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0wSSjMBh5wClIVN3ATDOsoC0dTu/7czxzHmaGPdjqI=;
 b=EWruNoJThcI6ZyMKFbhcs+CeqMQchRD9yHy26AIQS7U8duSTrpesmABUP+kzes/jmmzkPaTciQlCHRPO/xchwvBBhKJVaaTFl5QHZ+Yvea76NboZNxoowq0J1+0muMNed71P/hq2Rx8CV+K56uS1f7x2mbP/M8Vohuzap/EYrYFQq8CyCP4i7vRv7nYKwJHnl9QcnrvUtb0V7OKu/LjB0Wss3KGaPXg2RQVk9iYQWROgWFfpvRf98vcwqWnp07AgQs6c8PI0vhwWOJS9RWGhU7XyXU6oEuSKcwgGeHKHi1vMvSvm4VGRv3AwofLPW1L6N03kWmNwdIidFuaS05lkIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0wSSjMBh5wClIVN3ATDOsoC0dTu/7czxzHmaGPdjqI=;
 b=E87G/qXgO8B8R32Bd6/As/JCMUK6KWQuGrXjsXlW620TiwkbEuv10iVhgFraZpWX+IVNpxgpb2QY5aRMnpu3SZvY/IeWge2SiGTgCHieQM8ngT8R8nIPHfPpwvXdiG7L4DHu9/ArMevtFtebmPqJSWAiIFR/whwwGdMIbgxkAgA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:39 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/13] net/mlx5e: Use struct assignment for WQE info updates
Date:   Sat,  9 May 2020 01:28:54 -0700
Message-Id: <20200509082856.97337-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200509082856.97337-1-saeedm@mellanox.com>
References: <20200509082856.97337-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:37 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 39c421c1-a92b-435d-adc0-08d7f3f31d97
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4813C79C9593D871E3549515BEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gHHuHhFnm8yuO682ihnzmfR2LvNkErKCzoOdi0SYPoiCD9P6SZi0L042AZ7iJeWOYn3Jd+0nUUuDub7yiD0QOHQH4UCdeX24P0ZY4QQrUQl8jl6QC1MdIx+J1uTUIzd3opBQ883BzCPgqLBRtrRkih/hGVhku/MWYaVm/wSadje45qBz34oLwqiaRRzvfgpk1c3lwakUYRSW6OdUUOCkDIKxqZS43wXj+4MHhMQZAD6lJB5hH0E8i/H2OgA6wxuzk9KUd8E8o1+0IqU/xRQfsZSKeyCImvBLno7Xfcm1QyG56FNAb2GeT0mJO2qs+Up9DjGX0NcKAJoi/YKFbitSFOgLsedRCwKzUotUhe1zSi1jQhYD7gWt/MX8ST1xQqgFyNSWu/14IGgxwBzGyo+wcsCGtlvwMBdCHkbbDCBMztSAYjAGtLKa+eslJYjckudrpTPWscP/6mfER5dc464JDCd+0SLaHfiSdCdJ5B04ovz/IGgKuLMlcl06lIsIA5DWlmn74htWh1l/mPTeNJlRfoPXbHCfff2nrNuPCDE/km7irQlmUj9MLDmho7qpBTri
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33430700001)(107886003)(66946007)(316002)(2906002)(16526019)(8676002)(956004)(54906003)(66476007)(5660300002)(186003)(478600001)(52116002)(86362001)(4326008)(6512007)(6506007)(2616005)(6666004)(26005)(33440700001)(66556008)(36756003)(1076003)(6486002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aJhKVjm2xMoZXRMiFrjHF8DP7nVKWIjyMGhRqNpC/LUWiL6Rx9m4nTsEQd24cEvTMQkH5dZJJyVVYUcXStRyWVHnyXqiwH+QJMFa6Al/23DNtSSaNNiwgycW9CxepZc2Zy57obe9YVGcJnetCTI8aqC1PvMNw/4R9MiwwXDsO4Je2VWP+5GVaA+5njrH8o3ujgkXZJe8pyPIGAYeFqSLcP3cPB//wQ9tOIgcwIELNEkowjqyse4hvkKwKo8dMeZBWL2PieL/Bmv9QgKBQgMPi7JT0P1BULYPorRyr3InHPnV8FQ2kaLTRvgf7nD6POBJ6Ju2+3CjhzpgLBXkhtBLsONgUNqclOEfxURsz3HgKAOz3ZAmWCaE1XVD0PdXJo5Dw8BXL6K/fjG+8JD8d8mwzDZI6d5fF+iM5ZQ0QOc5QB4ej9O0qAOMVkZALAEeegPec6U28saO8y7DNNfd7coUeWHBDytby7m/mk9KDeGV1fY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c421c1-a92b-435d-adc0-08d7f3f31d97
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:39.7025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zSQvM2RrU6Mz8ZNZN5jbTZ2tZ7DohsEIsaMXPzdXnC6VOLwTPIl5S950kn0O9lNp7RTbSJVnTAvT2V/bOPVXKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Struct assignment looks more clean, and implies resetting
the not assigned fields to zero, instead of holding values
from older ring cycles.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c        |  9 +++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c    | 16 ++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c  |  9 ++++++---
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c    |  7 +++++--
 4 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 1c9d0174676d..3cd78d9503c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -108,10 +108,11 @@ static void tx_fill_wi(struct mlx5e_txqsq *sq,
 {
 	struct mlx5e_tx_wqe_info *wi = &sq->db.wqe_info[pi];
 
-	memset(wi, 0, sizeof(*wi));
-	wi->num_wqebbs = num_wqebbs;
-	wi->num_bytes  = num_bytes;
-	wi->resync_dump_frag_page = page;
+	*wi = (struct mlx5e_tx_wqe_info) {
+		.num_wqebbs = num_wqebbs,
+		.num_bytes  = num_bytes,
+		.resync_dump_frag_page = page,
+	};
 }
 
 void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_tx *priv_tx)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 048a4f8601a8..0a9dfc31de3e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1364,13 +1364,12 @@ static void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
 	/* last doorbell out, godspeed .. */
 	if (mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, 1)) {
 		u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-		struct mlx5e_tx_wqe_info *wi;
 		struct mlx5e_tx_wqe *nop;
 
-		wi = &sq->db.wqe_info[pi];
+		sq->db.wqe_info[pi] = (struct mlx5e_tx_wqe_info) {
+			.num_wqebbs = 1,
+		};
 
-		memset(wi, 0, sizeof(*wi));
-		wi->num_wqebbs = 1;
 		nop = mlx5e_post_nop(wq, sq->sqn, &sq->pc);
 		mlx5e_notify_hw(wq, sq->pc, sq->uar_map, &nop->ctrl);
 	}
@@ -1482,20 +1481,21 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 
 		/* Pre initialize fixed WQE fields */
 		for (i = 0; i < mlx5_wq_cyc_get_size(&sq->wq); i++) {
-			struct mlx5e_xdp_wqe_info *wi  = &sq->db.wqe_info[i];
 			struct mlx5e_tx_wqe      *wqe  = mlx5_wq_cyc_get_wqe(&sq->wq, i);
 			struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
 			struct mlx5_wqe_eth_seg  *eseg = &wqe->eth;
 			struct mlx5_wqe_data_seg *dseg;
 
+			sq->db.wqe_info[i] = (struct mlx5e_xdp_wqe_info) {
+				.num_wqebbs = 1,
+				.num_pkts   = 1,
+			};
+
 			cseg->qpn_ds = cpu_to_be32((sq->sqn << 8) | ds_cnt);
 			eseg->inline_hdr.sz = cpu_to_be16(inline_hdr_sz);
 
 			dseg = (struct mlx5_wqe_data_seg *)cseg + (ds_cnt - 1);
 			dseg->lkey = sq->mkey_be;
-
-			wi->num_wqebbs = 1;
-			wi->num_pkts   = 1;
 		}
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index d9a5a669b84d..8142b6e70857 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -505,9 +505,12 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 			    MLX5_OPCODE_UMR);
 	umr_wqe->uctrl.xlt_offset = cpu_to_be16(xlt_offset);
 
-	sq->db.wqe_info[pi].opcode = MLX5_OPCODE_UMR;
-	sq->db.wqe_info[pi].num_wqebbs = MLX5E_UMR_WQEBBS;
-	sq->db.wqe_info[pi].umr.rq = rq;
+	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
+		.opcode     = MLX5_OPCODE_UMR,
+		.num_wqebbs = MLX5E_UMR_WQEBBS,
+		.umr.rq     = rq,
+	};
+
 	sq->pc += MLX5E_UMR_WQEBBS;
 
 	sq->doorbell_cseg = &umr_wqe->ctrl;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 869fd58a6775..73293f9c3f63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -78,8 +78,11 @@ void mlx5e_trigger_irq(struct mlx5e_icosq *sq)
 	struct mlx5e_tx_wqe *nopwqe;
 	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 
-	sq->db.wqe_info[pi].opcode = MLX5_OPCODE_NOP;
-	sq->db.wqe_info[pi].num_wqebbs = 1;
+	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
+		.opcode     = MLX5_OPCODE_NOP,
+		.num_wqebbs = 1,
+	};
+
 	nopwqe = mlx5e_post_nop(wq, sq->sqn, &sq->pc);
 	mlx5e_notify_hw(wq, sq->pc, sq->uar_map, &nopwqe->ctrl);
 }
-- 
2.25.4

