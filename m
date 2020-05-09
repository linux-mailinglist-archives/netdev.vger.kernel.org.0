Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999ED1CBF0C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgEII34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:56 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:9905
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbgEII3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kps1pjVXv4V4puTAE/czSv1lSqlrTjzeEyDjqRmkRGg0CRp2hoWpMZdtI/QctaeDK5oSE4Nbs7Y7x9lZ84XTfiTjK/IDRvNbPJYDSiFE5toQXanYUFdcmbXcYK5SEus9lkh7RkHTlx0eb0WByCemwkZWYAYlclLnLs0l7t4IrNmJAWox2kI66tHJN7cBccAVgYmijSc03lNF91OR6sqlxEsThhuiLt6fleh8sUSMCw/AM77UTE3JZXQh5kn/LQphQLjx6Q97XTyorSscttgl3sStidwhoFZd76CmR8P0nKOZjcnABFZCe78/qzhAaJa1jDAO8bDPNRscRd24l6aKPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLNKoEfVIM14ZwhEku4mFjtKucAlYzMYpq02tiNNMkg=;
 b=hSDPqhq1P5m258UULcPM6AHtWAtZxWyXLmd5U4kFWOMZssHaVjce0QAUar+46ogD3sOeuEJK7hXORnLUBKviKD9KDMSlg49uKoyKGU72ZDJ0lbbUT0VXDykijPhLB2lrBX2iDfWyLTtzNBvepD1neaiARo78j4bTSWzLdO7dOhnjoYdPjWrOD6VTX1hikicrHnikEOih0a13crXMgKYU1eFkYm8paOA9M4lhJ5YJnU2GwyxI/1XzsMLnjr3WkjwwjtAXMxKFiFwiRmkiuORTXvJy5enXn1oZywI2194fimib4+8dvrksDsFHWh8I0hmi7xAbq+TQ9Yx3KzB/v6m3xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLNKoEfVIM14ZwhEku4mFjtKucAlYzMYpq02tiNNMkg=;
 b=EuYlwLz/Yib8GeqqecMWNHnI6a1zetUKZbPbr7U8RNrcb3HgGNLaSpmAb9M/rF6Y3rkdntBfTqx/zFn8vBRJrrjGaOEIxgX+k2WFsMQnKU8DSv67dv2eBGBrCO8Hp0cQWtAQmB6zX+Euwr7Cvcjte/NK1RBcxmYdRd29aPQZQ2I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/13] net/mlx5e: Enhance ICOSQ WQE info fields
Date:   Sat,  9 May 2020 01:28:56 -0700
Message-Id: <20200509082856.97337-14-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:42 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8624020b-71c8-448b-7e0a-08d7f3f32080
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4813580FAE156AD256731116BEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +zeDB+UZTZ5KJqdNjZO3Arb/ayVVJnybKjCZ4Z3NoYoU8ZJwqNW1ae6n2X1oUsfmZFjOXxUCMsDdlsigcYpv91Y+kBbx8UBl8STRVgwwhKguObzDGPBOi/6SjfM7ZpVrzfwppng/ygpNRWhe6fd7vl9JxYzn8+S/laLofOo7gJqNdG6NyvpUrx+9di4p1nhusQkgnu3ND7IwwQ0/ZkD7zpJXDyx+NMlEDQa7Wdp8WD7FioWKek++V6vQAD31MiU1HKya4h5VfDJWjxc0GlmM51Mmpzorym+x0vTu66xqFejvBh8V+82wV+x02I0OOR4G/75MOFIz198EheT8WUBEOcEowGOfT5NnzXEV0GbyrdI8cCvM5W4U+Pv30zo7V04XNbNr0lrugR4swfAm5GxoeWAUOub2MYOvBwjOjbtVWAHvV94PfpsXL+ED2KmLUxb9Kkxzo+Lpnd22zTrUfqT5BZRKsSVkPha0/fMXktwYPyis4C4yWr8SjwXepH9kPAA28tLcWJR4tmCe3Szbukqkqeh81NWM8N2QvT/DPGNuL2es9bbiHvsgpqMxaHhNr+Yt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33430700001)(107886003)(66946007)(316002)(2906002)(16526019)(8676002)(956004)(54906003)(66476007)(5660300002)(186003)(478600001)(52116002)(86362001)(4326008)(6512007)(6506007)(2616005)(6666004)(26005)(33440700001)(66556008)(36756003)(1076003)(6486002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oIE4JxTUJzvDmH+PeO17oZCPfPk0c2+cfCPX6oAPv7CU6w+KAHRsXkVZOJHxzcFKlc+ud3YksKGvj2PeDbCV/Y0pB9b+M3YnXO6+ApefLd7QNFHkFUsv+adfIOAatLCRtSa0kSjK88UprXbDe0MMxowMIFaJzbNnELYl0cqOLxm4xFlBmSdxEy4DC0j9mmGNvasDNoKPS33oCbb6vMxcWzcmaaOHN2xSeLV+cK0cGoCWPnufKRoq1jgm5nXQpupV2ENRV8h/iIIsdj0RluUfY36KsIGdSPsyfZ3h2kDrnzD/5wdvPwSTaAzQWOfZUbmHOiPXji3WDZun5djKP2ybimUKw97SiVw8FkABnBVWoKnUv7bgu+yxYozfNevcVr4UUKpmOyVFqMPRvst+lpijewHQcZqLExwyOZCjHW0PXy2DfWqhUwyqmCnQ0GeVMqKUV9QvuBbFcS0dEw21hXDDsiKjEYXHCrhhzqJxx3Wy7fY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8624020b-71c8-448b-7e0a-08d7f3f32080
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:44.5707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NQgsnCp3j74DLlm9o0URYYIlgMbAVXPjy0lsW28xEccat5K/gonCTTsPgQjHopBNJJeUQsxaqAHzyajekLZpWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

The same WQE opcode might be used in different ICOSQ flows
and WQE types.
To have a better distinguishability, replace it with an enum that
better indicates the WQE type and flow it is used for.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h   | 11 ++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 17 ++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c   |  2 +-
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 9e150d160cde..dce2bbbf9109 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -27,6 +27,11 @@
 
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
 
+enum mlx5e_icosq_wqe_type {
+	MLX5E_ICOSQ_WQE_NOP,
+	MLX5E_ICOSQ_WQE_UMR_RX,
+};
+
 static inline bool
 mlx5e_wqc_has_room_for(struct mlx5_wq_cyc *wq, u16 cc, u16 pc, u16 n)
 {
@@ -120,10 +125,10 @@ static inline u16 mlx5e_txqsq_get_next_pi(struct mlx5e_txqsq *sq, u16 size)
 }
 
 struct mlx5e_icosq_wqe_info {
-	u8 opcode;
+	u8 wqe_type;
 	u8 num_wqebbs;
 
-	/* Auxiliary data for different opcodes. */
+	/* Auxiliary data for different wqe types. */
 	union {
 		struct {
 			struct mlx5e_rq *rq;
@@ -147,7 +152,7 @@ static inline u16 mlx5e_icosq_get_next_pi(struct mlx5e_icosq *sq, u16 size)
 		/* Fill SQ frag edge with NOPs to avoid WQE wrapping two pages. */
 		for (; wi < edge_wi; wi++) {
 			*wi = (struct mlx5e_icosq_wqe_info) {
-				.opcode = MLX5_OPCODE_NOP,
+				.wqe_type   = MLX5E_ICOSQ_WQE_NOP,
 				.num_wqebbs = 1,
 			};
 			mlx5e_post_nop(wq, sq->sqn, &sq->pc);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 8142b6e70857..779600bebcca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -506,7 +506,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	umr_wqe->uctrl.xlt_offset = cpu_to_be16(xlt_offset);
 
 	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
-		.opcode     = MLX5_OPCODE_UMR,
+		.wqe_type   = MLX5E_ICOSQ_WQE_UMR_RX,
 		.num_wqebbs = MLX5E_UMR_WQEBBS,
 		.umr.rq     = rq,
 	};
@@ -619,15 +619,18 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 				break;
 			}
 
-			if (likely(wi->opcode == MLX5_OPCODE_UMR))
+			switch (wi->wqe_type) {
+			case MLX5E_ICOSQ_WQE_UMR_RX:
 				wi->umr.rq->mpwqe.umr_completed++;
-			else if (unlikely(wi->opcode != MLX5_OPCODE_NOP))
+				break;
+			case MLX5E_ICOSQ_WQE_NOP:
+				break;
+			default:
 				netdev_WARN_ONCE(cq->channel->netdev,
-						 "Bad OPCODE in ICOSQ WQE info: 0x%x\n",
-						 wi->opcode);
-
+						 "Bad WQE type in ICOSQ WQE info: 0x%x\n",
+						 wi->wqe_type);
+			}
 		} while (!last_wqe);
-
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
 	sq->cc = sqcc;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 73293f9c3f63..8480278f2ee2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -79,7 +79,7 @@ void mlx5e_trigger_irq(struct mlx5e_icosq *sq)
 	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 
 	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
-		.opcode     = MLX5_OPCODE_NOP,
+		.wqe_type   = MLX5E_ICOSQ_WQE_NOP,
 		.num_wqebbs = 1,
 	};
 
-- 
2.25.4

