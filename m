Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725B91C03D2
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgD3RWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:22:13 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727049AbgD3RWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:22:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eg6M9IDn7SIp9/2C5/3UpdX/AqiI3T5BOBJzHaPjtMqGJbpL0PLhfpo+atbpxB4L5/kyq18IvNMAqvmW6qX89HyJ6j0GzqNx5Bg/FQjZjXdW6m1nH6+Rd+VLZaFKbNPz/em/Ma5whgFzdHY2ba7ZKydHHDLnEHkDZffDTDJf2/OffE6aERvcupoJxeRQP4T+5Ikx/QobggFJQ6MKnVCUbblRBkHmZK2YMQDByZqeB8MVV77w/3tSwSPu9B3MNGS9PF1WlZvJkDvWMwHy93CxG0DOwy6qElGvv4MOAX31f8CdvHCjC4BXuWg7UhMx928HNEcQHULhZj6evt2hFZ4f4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yiSyYGMdcfh9NNpXIZc2UrIx01sRnxyJam3NXL896vg=;
 b=EtQq0BlU+NWCVDPexqN2krc8IdYW1njxsdcCrmvGijFjRFQuiF8GnCtOqg+jvW0K7DMBtO5ju4lHnSIarbrPCV0JpkcfdEzpdCtNTP86hw6JHJje+0nmNSV8LuCHsUWWp+oGwkE45kSqaKfasClYuoxuGh1IIpnxfP0nIMSUStqg8ocLcO0Y1HqGvSE/uGyobK6lTLb2KHURAF8YgSf0sfG/NkkgivLarV1sHQTDSmwxdxeUWEmpXbH4E/fH3pWJHq5POHF7JI7i+MUChd5HwEMfgEVH0zUSasUp61O8Sd2Mgs4fq1mQjUb8OztGbIRbSOq361Deke+pbvG0rWrHPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yiSyYGMdcfh9NNpXIZc2UrIx01sRnxyJam3NXL896vg=;
 b=ZI5WwP7EpobtDrKekE2pG2qLqueb/LgRPEE4jQ16Q1a5jv9Foa0UQ5iwCYyhJ2qEF8eAfit0O2Bga8gY1sKg3EBW1NfBI8k61OMl0yhgKlw31JAV//+5YSBu13ezhyMTekQVvqUljkMAd61FnTuuIeAQgOBSSLVVJh8l/Crm05c=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/15] net/mlx5e: Rename ICOSQ WQE info struct and field
Date:   Thu, 30 Apr 2020 10:18:34 -0700
Message-Id: <20200430171835.20812-15-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:26 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8356b027-8615-452a-7e1c-08d7ed2aeae8
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3296986D413115A3D94BAA5BBEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ypsFiq9JB86b70OSL+vCwUvAcFEVxF9BnMo3zT8qVpd7P9H0voPADiTYPftlBnxyCaPrIXuTTXaAUqHmd0Og4A2gW0lmI1+TtLb4k5MxK1TT30wty6HRsuKf5+0d/WpQLQohHnns0QfP1Mwf4L/FEl/RQVp77MUIxILarrUutoS74LhIk0SEwWET+TyfolfYBK5fKGi7c/yTwhVCwYcP8cJBvVqBmUNZVyxYZ95SvRt0jffu3V4WSM9kfRxe5aSZAWfPavZr2wB9VYTOA69x7BTkQr/Kmc1enbX6/wJc4OhxfjxHfCU2BuO0ZX3oWp2/Au7EAikVdkNRRTWUvZ69JHeDYfn5Teg+YQk6pj5U7SzeMQJ7H71GLNrXdKkkdXiHGkCNjLtci7LncBbtaA4640SPzVzAdfmm5YmjSVI1VCsQxpS4ybegxaFkjalTm1W3haTTZ+nhhJUZTnvJRmJ5Eb33uurDhWOXYJ8nk7ry9DVYCLoV/a6u8XU5ff2PCblA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JScHGE386fTk/pcbHUlCqJ5gVNqxodW6lC3/kLgjoNKEKHLzy4BNgqJwfgI0uHyer/kirbGCHx629wGljua+k7mHyRvrJC75Xx6rxeJSZOakFNiZknzBrTs3739YwtAnKVMiNmzZN1nMBwNxIYNx5uTZvH+bXcKuqQjbVL/Do9WhKcrHb9s4ijo7uS2Gf48EFkiV5tvdfB3lRJ8XRaTX+CpvU7KyBsyoEaJ+dBcOsZtDNKv1NjUtYyfy2OJymWlg6d+99+hD7nNAZIwCcVjka96lUOMBoJRsuDs96UF2FuRuEAVgtiQ5JkpMqeaAixtyURFxCFDwrs+8Ch5X6gBC4Gjwewg5F1BgCC4DIwBq7iEQQTZFQS4JByvRNZhNRZOFYG0XZvQ4bwk9zw7NrFSpTnrBfgx41K+zAMk+v55DR6GQ0zFrXCXFpR/Apg8WzD47ATOhEpsKnD4qBMsGTKl1yrk4YsYOqM0XNq7AeV4Xe35LGFS43azYDWUQbhBA07cp8wKaFpALS8/iqlzPhUhINMv3srrS5PoBbv8Y77qPCEydf/B+84n/HhZxjUfetm33kgoYnJ+EYRcE/9vVQ3pAU7V/o9VkYmNrh86Kprplacke4asczHoJHfGJGsLGd0z0unvRHLt4Oo0h1c52GsheJSl+7OxNFegQQPsQpII2D/1jO5nGlM+Pho2wkSPjiUwKHTCo2eKvAhh7jk2kYH3oIVVgwe2OJFTJZ23w44v8FCQ0l6pMNYu3s2TsGWY7mwJ/7HZQODNw8el5jxDNHFQiSXEtXbwLjdFMXs5nxaXxhTI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8356b027-8615-452a-7e1c-08d7ed2aeae8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:28.3797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBX6p3EyHSXK3v3g/r6bKVtq/cJATe702VT3gna3terYerpXGFp9fyNJ3xzpgC1keKXMyyWqywzglVa4SPlOLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Structs mlx5e_txqsq and mlx5e_xdpsq contain wqe_info arrays to store
supplementary information corresponding to WQEs in the queue. Struct
mlx5e_icosq also has such an array, but it's called differently -
ico_wqe. This patch renames it to unify with the other SQs.

In addition, rename the struct to emphasize its specific usage.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c |  4 ++--
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index e8508c74eaa8..0864b76ca2c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -370,7 +370,7 @@ enum {
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 };
 
-struct mlx5e_sq_wqe_info {
+struct mlx5e_icosq_wqe_info {
 	u8  opcode;
 	u8 num_wqebbs;
 
@@ -552,7 +552,7 @@ struct mlx5e_icosq {
 
 	/* write@xmit, read@completion */
 	struct {
-		struct mlx5e_sq_wqe_info *ico_wqe;
+		struct mlx5e_icosq_wqe_info *wqe_info;
 	} db;
 
 	/* read only */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bf3fdbea1074..048a4f8601a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1027,17 +1027,17 @@ static void mlx5e_free_xdpsq(struct mlx5e_xdpsq *sq)
 
 static void mlx5e_free_icosq_db(struct mlx5e_icosq *sq)
 {
-	kvfree(sq->db.ico_wqe);
+	kvfree(sq->db.wqe_info);
 }
 
 static int mlx5e_alloc_icosq_db(struct mlx5e_icosq *sq, int numa)
 {
 	int wq_sz = mlx5_wq_cyc_get_size(&sq->wq);
+	size_t size;
 
-	sq->db.ico_wqe = kvzalloc_node(array_size(wq_sz,
-						  sizeof(*sq->db.ico_wqe)),
-				       GFP_KERNEL, numa);
-	if (!sq->db.ico_wqe)
+	size = array_size(wq_sz, sizeof(*sq->db.wqe_info));
+	sq->db.wqe_info = kvzalloc_node(size, GFP_KERNEL, numa);
+	if (!sq->db.wqe_info)
 		return -ENOMEM;
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 4db1c92f0019..9f33a0e7dd9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -472,7 +472,7 @@ static inline void mlx5e_fill_icosq_frag_edge(struct mlx5e_icosq *sq,
 					      struct mlx5_wq_cyc *wq,
 					      u16 pi, u16 nnops)
 {
-	struct mlx5e_sq_wqe_info *edge_wi, *wi = &sq->db.ico_wqe[pi];
+	struct mlx5e_icosq_wqe_info *edge_wi, *wi = &sq->db.wqe_info[pi];
 
 	edge_wi = wi + nnops;
 
@@ -527,9 +527,9 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 			    MLX5_OPCODE_UMR);
 	umr_wqe->uctrl.xlt_offset = cpu_to_be16(xlt_offset);
 
-	sq->db.ico_wqe[pi].opcode = MLX5_OPCODE_UMR;
-	sq->db.ico_wqe[pi].num_wqebbs = MLX5E_UMR_WQEBBS;
-	sq->db.ico_wqe[pi].umr.rq = rq;
+	sq->db.wqe_info[pi].opcode = MLX5_OPCODE_UMR;
+	sq->db.wqe_info[pi].num_wqebbs = MLX5E_UMR_WQEBBS;
+	sq->db.wqe_info[pi].umr.rq = rq;
 	sq->pc += MLX5E_UMR_WQEBBS;
 
 	sq->doorbell_cseg = &umr_wqe->ctrl;
@@ -618,13 +618,13 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 		wqe_counter = be16_to_cpu(cqe->wqe_counter);
 
 		do {
-			struct mlx5e_sq_wqe_info *wi;
+			struct mlx5e_icosq_wqe_info *wi;
 			u16 ci;
 
 			last_wqe = (sqcc == wqe_counter);
 
 			ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
-			wi = &sq->db.ico_wqe[ci];
+			wi = &sq->db.wqe_info[ci];
 			sqcc += wi->num_wqebbs;
 
 			if (last_wqe && unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index acb20215a33b..869fd58a6775 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -78,8 +78,8 @@ void mlx5e_trigger_irq(struct mlx5e_icosq *sq)
 	struct mlx5e_tx_wqe *nopwqe;
 	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 
-	sq->db.ico_wqe[pi].opcode = MLX5_OPCODE_NOP;
-	sq->db.ico_wqe[pi].num_wqebbs = 1;
+	sq->db.wqe_info[pi].opcode = MLX5_OPCODE_NOP;
+	sq->db.wqe_info[pi].num_wqebbs = 1;
 	nopwqe = mlx5e_post_nop(wq, sq->sqn, &sq->pc);
 	mlx5e_notify_hw(wq, sq->pc, sq->uar_map, &nopwqe->ctrl);
 }
-- 
2.25.4

