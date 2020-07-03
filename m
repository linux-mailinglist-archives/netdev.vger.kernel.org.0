Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFA5213297
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGCEJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:09:30 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725960AbgGCEJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:09:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEQjME04i0cySULVwTIPjgj3YRTG1Aw3RkFmUP/76nRJYO/CLtp0Zpd29uifiEnrhfWpEmHpROK7TOKZyuZqJbvzWMiRAy60Ttc1tAtSATKN2f7Pa02hwF04YzHjo58kLIJZSpN0B2293wr8nZ1vYwrRCTQDKUYxeSJcJKkVWxOlTQmoFK51pbY9HZgDtcth9CA282F3sZlggcWtM+Rtxq6gHRFTJextNaww1OJHg3tvqwuJWlscUn9BRHGRDzvacmpXlwb7/AjUkl/LSTbtcGrIJPkls5MJj1FMaCBBA1pZHaWqhRxwQrIRCwSQLufUyFp5CcLhSj71K0DOIK+4CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7ssqwSlXiSWUcZEx2uLIxVf7PgimnundSMaNmHwuog=;
 b=Oqr6JicbBJtqzMXLe3gjJlWpyfhyr76ZFXJ3PD07qYhOuJaCtItF4jcI0SGjGAFoaejqij/+QxuhjT4N1HDu5wSuGwr+eoSyHV0hNWSYfvqzB8UwmpbNiu/FVUi3tNKrdoZ1hIVkxhcMKZZKbfFsKBli/GqbGgD50MqdynOI2vXXBnkq3MRkX8WHyTW4VHG3ynBNtcZ3Uj8/PnXxdvdvQEz77CkJW/ydWBLNOf7/AsuxY4orjAx1MYSOurbvi619XayJsTVdE996wdlVcZpBKf3Z37y7tDaEZP5ImJo3RHMKvs/kqfAiWh60Zls7rbdAz+zyWysJmaLwfUkcb7h4UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7ssqwSlXiSWUcZEx2uLIxVf7PgimnundSMaNmHwuog=;
 b=Dnc2SQHfPoDLA98QjP/9UGLWFtDuBYiyVMA02Uqdm0f5Gq5qw8k5aCqJ3UrE/sU/PFMJploHba5dghm7QoJSxorG4v/K8ucBCOSx92roco8Ym3DFLJ/medI1/b5AuMVkpPPJLXhmOx80r8MAVyNScxxPA66C1xyXFC0D0G9Q7wQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/12] net/mlx5e: Move RQ helpers to txrx.h
Date:   Thu,  2 Jul 2020 21:08:25 -0700
Message-Id: <20200703040832.670860-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:12 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f97fb3d7-a19c-498e-a70b-08d81f06d8b2
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5534435468868307004953C7BE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eGb8C8TWNONf5zxTUgVfEJnWCShqJX1c6+Ibd0F9KFl31EjnJZkqvxeY51Uexh1ukR+N5iTLyRhBK1BQVR3pS3GXvUJ5db/4cCdDEtt8CEpXdft/r6kRKdFLpRV4Y8CxHwMz8doY2uDmxYM/ex/XLxLlE2OcpLqS43p3qg7UB/1anyLeuC630owGwSVaU1HwhDW8yvLjCom7qQb5CN1fl47/ucMu09N3lq8O9v2w2ERwXEKM7rTp7CsZU2obwqAVItXIh0Fxo957cUmKwuto2VXuqEHq9F+Tp5nXNrtEka4QUmFt/Xb/5I6d9G3TsvvOHjfubYCzpt5wyRMFNMurWc8JzzgwkG8Sjfnu86xLwjzWs7F5mqF6g28ASqRc8hRK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(83380400001)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hv7lMkkunXPJsmB+DunD8VUNs+9DSu/rWY5I4ohBOki4KkFObnfFscqB3CaWA0WC14WDpKZjtdXxkDmNgotrdbYoWJGpN4xxYihxZqw6MCOiOMq8ObtocvZ8YULh+QpyFVnbX27/aKENxugkiyT1s7BAszINM2BnvILi+47x8Bv5OW4WbnKL7X57eB6T6gSjSytThX1Ho4jAWS+55MsVJ+BLky8ZWflsIeZuhwbSVQgWJh4vay4jMIxHnFroGdjjK5q7aHLywRKeU7ZLEfzPL4tCAOCyzfLLhjoFBiZzolyQ73ivNtyf9Kr1OO9NVPNcApjzhU5shoXsyIzGJANXHkQ2rJYWTIVAnda9sZXeg8jhJuHYr5A/ynwkOqVnsylRZxvxnLxut/PKuhtGKOmYtFZceuOq3cTUSjx8PGsJAebtDUMgq33noZnz+toV+GpWrhrTRd3QqifXPQ/J9B3/hBtuF4SkzOyD4jebTDZLSLg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97fb3d7-a19c-498e-a70b-08d81f06d8b2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:14.0555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: unGqpYJk9KljYleyZXkpOaiOVpQKqvYWPoas6wRdxlQUqutx9dd8LQ+vUqovfD4ckRhLHcQZIDxaJDI7YHQDAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Use txrx.h to contain helper function regarding TX/RX. In the coming
patches, I will add more RQ helpers.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 20 -------------------
 .../mellanox/mlx5/core/en/reporter_rx.c       |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 20 +++++++++++++++++++
 3 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 2957edb7e0b7..c44669102626 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -852,26 +852,6 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
 int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget);
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 
-static inline u32 mlx5e_rqwq_get_size(struct mlx5e_rq *rq)
-{
-	switch (rq->wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		return mlx5_wq_ll_get_size(&rq->mpwqe.wq);
-	default:
-		return mlx5_wq_cyc_get_size(&rq->wqe.wq);
-	}
-}
-
-static inline u32 mlx5e_rqwq_get_cur_sz(struct mlx5e_rq *rq)
-{
-	switch (rq->wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		return rq->mpwqe.wq.cur_sz;
-	default:
-		return rq->wqe.wq.cur_sz;
-	}
-}
-
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev);
 bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 				struct mlx5e_params *params);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index f1edde1ab8bc..bfdf9c185f02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -3,6 +3,7 @@
 
 #include "health.h"
 #include "params.h"
+#include "txrx.h"
 
 static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index be7692897fc1..ed9e0b8a6f9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -284,6 +284,26 @@ static inline void mlx5e_dump_error_cqe(struct mlx5e_cq *cq, u32 qn,
 	mlx5_dump_err_cqe(cq->mdev, err_cqe);
 }
 
+static inline u32 mlx5e_rqwq_get_size(struct mlx5e_rq *rq)
+{
+	switch (rq->wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		return mlx5_wq_ll_get_size(&rq->mpwqe.wq);
+	default:
+		return mlx5_wq_cyc_get_size(&rq->wqe.wq);
+	}
+}
+
+static inline u32 mlx5e_rqwq_get_cur_sz(struct mlx5e_rq *rq)
+{
+	switch (rq->wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		return rq->mpwqe.wq.cur_sz;
+	default:
+		return rq->wqe.wq.cur_sz;
+	}
+}
+
 /* SW parser related functions */
 
 struct mlx5e_swp_spec {
-- 
2.26.2

