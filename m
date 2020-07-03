Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB0021329A
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgGCEJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:09:51 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725960AbgGCEJv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:09:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGc5BjtwydAcFQBqgprSEWC0gzCRD0k4MQGOLGrmwl6stNnvCQk42UIWC8Q5EwsQKSWmPerb1u+Lp7XerXKYN2jJpsv2EWZsyqnAJYyq4b8M1dRhK+dY92A7GquR59N2fLrhqSSd2YRANum6mVWh/s4527ltctNbdOgRT7ZdidmY0GmeAtcLUzSKOtX7gg9gOVM2N1wC5hx6BEiakp73F5YXwCbto7bxfFpxQNZDAeOHX+WtQEidez2V80bpzsZMDYPAA253m3uWT/+/o+lj05FiwSqxplvltk+9jpK/ru/Qr8RNppotLXz9UyGYGxVfAGMkAVORo8tFexWstrUkEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61GfjUVaDKy7lRmMb57YdLHSAxvoTRuJlGWZ4PpI9jA=;
 b=luQANb5SanxpmOGCat6DfitD0j5Jpgv5JYN+JOfhdvktOIO0frOKreqWJQ5iheXpGt5nWD5Vut19+LhWPIx97o/EN3CPQALJ784aH6Z6Glbe39oOXGtrul6jF7qJZiJFOTHfvcALiVqei7TTakSNqgMLwVEJ/2DBPdiF1yQxKBzcE3kY2PEbx01QwVEv4QMUzmyXwA3xoqcHXTF1Ap1/RqhTSjHEsYNPJMe3jWaTu2ug2BlTLeW7K48ixJoFga1XU6MWEV751S9qyf7MH0sxtMomQlAVil0tNJpsIJmkXm5oCMvhvBh7ytcXz8qAg9qCkU06MDXkbr5o9sbNG8SJPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61GfjUVaDKy7lRmMb57YdLHSAxvoTRuJlGWZ4PpI9jA=;
 b=Cl22IKpHUNXLuMusaqsOuD3VUmy0ag7xWAtxGrrWdyBt4JD6rv+dBHPDL+/4fj6b1INdKb4lUWxVKh16BRABKXGY3uFeElW17AfW8brgUUzchSEKNv0Q8fIuIxxi/iguuNzQKcs+EFoMLMerWYpL5gfE2AgXxvXrExZMAf1D9/0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/12] net/mlx5e: Rename reporter's helpers
Date:   Thu,  2 Jul 2020 21:08:28 -0700
Message-Id: <20200703040832.670860-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:18 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 666e2c4c-1eec-48d4-dab2-08d81f06dc3f
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5534AA271A34910203A2A1D0BE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:23;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TOxLpAr6aU5UP9u/CDgzaZR9HfLf7rWM4k1+aV1IAdcw/G1liYLFf0HwaGcJtWlO3qVv0vlaHz9nXsJPfXnF5/6ZmrpKwCNBxSAN/T/hscXINztZl2sKVYPLQ+QW+tYCLz+3E5Bh0rFvhHkbUXgja0s5tgVmmjVeZtRXAvd4r4BnMyYppozG7PdEZhAGXCaLbzGRPSWoiOp9zSRe0p4akz89Wno/iB8HkzwDHw5ifwO83EVZvirV0rGKmyEtK8A9qhJwNG1dSO0VcR7l3imUsvjQSm4kelxBSiF9CQwnYntLrjoiFjQM5nyWMvyUT8ShaCk2so+2eGHEtP2kczr4UIIrAO1yja4QhBVSYf3YI3srxJTyTCl3eDxNjo8nOpM8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(83380400001)(86362001)(66556008)(66476007)(36756003)(66946007)(30864003)(956004)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WmZz5f5ya7/k/pzFZAwoW0I++qjbxhwyHiSsEwjSoSmqSelFJqJN8qjcajhrPeS64lZWYlEMXHBb++YkKdm9BsfGSLbB3h4t0STcezEH1thrYzsEwEXgstecK9zcqFQu5o/oE+1D0EhNRf8T9Yf83dLL08eQWIN2Yn8YJlFhBv4Yy5tspw1Wqirs3vodsC3hkttF9WMRnmr4KK3ztRvovKoC4sTCrSUmPFjzzOSdWxiPWAHvbnVkR1kKAk2IExawHyETulhIAhEn7GeKPLZohJ6b1kMe6iV+G1IjP2grRXbkoTG4bPTbLL3+aNOFMpALVtpCar29ReqdtcbgHOI/gDh2sD5hJRKmHK2qQklKAel9re6srDR9qatmg9nwWQupMn1ZiBryKH4BiBcw50j1ztJ/Fu82xNyiGI98qGwzhdyO2+73yISm+jNiyiKOncxLE1oELZ3hQJWPMYvyPuIR+UKRN3N6qyLB0K5WK3/RQ30=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 666e2c4c-1eec-48d4-dab2-08d81f06dc3f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:20.0191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YEGnA4wFSdaa0b/Z1hx51iQ590nOlDGPedVGb7VX6cfj5lhCON+ROywjKR2wGnwnv3+FVoGHmRTni4fz0WnLBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Change prefix to match resident file:
%s/mlx5e_reporter_cq_diagnose/mlx5e_health_cq_diag_fmsg
%s/mlx5e_reporter_cq_common_diagnose/mlx5e_health_cq_common_diag_fmsg
%s/mlx5e_reporter_named_obj_nest_start/mlx5e_health_fmsg_named_obj_nest_start
%s/mlx5e_reporter_named_obj_nest_end/mlx5e_health_fmsg_named_obj_nest_end

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/health.c   | 20 ++++----
 .../ethernet/mellanox/mlx5/core/en/health.h   |  8 ++--
 .../mellanox/mlx5/core/en/reporter_rx.c       | 48 +++++++++----------
 .../mellanox/mlx5/core/en/reporter_tx.c       | 32 ++++++-------
 4 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index d0625ee923d6..1b735b54b3ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -5,7 +5,7 @@
 #include "lib/eq.h"
 #include "lib/mlx5.h"
 
-int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name)
+int mlx5e_health_fmsg_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name)
 {
 	int err;
 
@@ -20,7 +20,7 @@ int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name)
 	return 0;
 }
 
-int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg)
+int mlx5e_health_fmsg_named_obj_nest_end(struct devlink_fmsg *fmsg)
 {
 	int err;
 
@@ -35,7 +35,7 @@ int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg)
 	return 0;
 }
 
-int mlx5e_reporter_cq_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg)
+int mlx5e_health_cq_diag_fmsg(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg)
 {
 	struct mlx5e_priv *priv = cq->channel->priv;
 	u32 out[MLX5_ST_SZ_DW(query_cq_out)] = {};
@@ -50,7 +50,7 @@ int mlx5e_reporter_cq_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg)
 	cqc = MLX5_ADDR_OF(query_cq_out, out, cq_context);
 	hw_status = MLX5_GET(cqc, cqc, status);
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "CQ");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "CQ");
 	if (err)
 		return err;
 
@@ -62,14 +62,14 @@ int mlx5e_reporter_cq_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg)
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
 	return 0;
 }
 
-int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg)
+int mlx5e_health_cq_common_diag_fmsg(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg)
 {
 	u8 cq_log_stride;
 	u32 cq_sz;
@@ -78,7 +78,7 @@ int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *
 	cq_sz = mlx5_cqwq_get_size(&cq->wq);
 	cq_log_stride = mlx5_cqwq_get_log_stride_size(&cq->wq);
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "CQ");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "CQ");
 	if (err)
 		return err;
 
@@ -90,7 +90,7 @@ int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
@@ -282,7 +282,7 @@ int mlx5e_health_queue_dump(struct mlx5e_priv *priv, struct devlink_fmsg *fmsg,
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, lbl);
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, lbl);
 	if (err)
 		return err;
 
@@ -294,7 +294,7 @@ int mlx5e_health_queue_dump(struct mlx5e_priv *priv, struct devlink_fmsg *fmsg,
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index 2938553a7606..6e48518d3d5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -21,10 +21,10 @@ void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
 
-int mlx5e_reporter_cq_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg);
-int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg);
-int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name);
-int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg);
+int mlx5e_health_cq_diag_fmsg(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg);
+int mlx5e_health_cq_common_diag_fmsg(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg);
+int mlx5e_health_fmsg_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name);
+int mlx5e_health_fmsg_named_obj_nest_end(struct devlink_fmsg *fmsg);
 
 void mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index bec804295c52..4e1a01d871b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -238,7 +238,7 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_cq_diagnose(&rq->cq, fmsg);
+	err = mlx5e_health_cq_diag_fmsg(&rq->cq, fmsg);
 	if (err)
 		return err;
 
@@ -268,11 +268,11 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	rq_sz = mlx5e_rqwq_get_size(generic_rq);
 	rq_stride = BIT(mlx5e_mpwqe_get_log_stride_size(priv->mdev, params, NULL));
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "Common config");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "Common config");
 	if (err)
 		goto unlock;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "RQ");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "RQ");
 	if (err)
 		goto unlock;
 
@@ -288,15 +288,15 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	if (err)
 		goto unlock;
 
-	err = mlx5e_reporter_cq_common_diagnose(&generic_rq->cq, fmsg);
+	err = mlx5e_health_cq_common_diag_fmsg(&generic_rq->cq, fmsg);
 	if (err)
 		goto unlock;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		goto unlock;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		goto unlock;
 
@@ -329,7 +329,7 @@ static int mlx5e_rx_reporter_dump_icosq(struct mlx5e_priv *priv, struct devlink_
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		return 0;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "SX Slice");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "SX Slice");
 	if (err)
 		return err;
 
@@ -339,15 +339,15 @@ static int mlx5e_rx_reporter_dump_icosq(struct mlx5e_priv *priv, struct devlink_
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "ICOSQ");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "ICOSQ");
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "QPC");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "QPC");
 	if (err)
 		return err;
 
@@ -359,11 +359,11 @@ static int mlx5e_rx_reporter_dump_icosq(struct mlx5e_priv *priv, struct devlink_
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "send_buff");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "send_buff");
 	if (err)
 		return err;
 
@@ -374,11 +374,11 @@ static int mlx5e_rx_reporter_dump_icosq(struct mlx5e_priv *priv, struct devlink_
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
-	return mlx5e_reporter_named_obj_nest_end(fmsg);
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
 
 static int mlx5e_rx_reporter_dump_rq(struct mlx5e_priv *priv, struct devlink_fmsg *fmsg,
@@ -391,7 +391,7 @@ static int mlx5e_rx_reporter_dump_rq(struct mlx5e_priv *priv, struct devlink_fms
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		return 0;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "RX Slice");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "RX Slice");
 	if (err)
 		return err;
 
@@ -401,15 +401,15 @@ static int mlx5e_rx_reporter_dump_rq(struct mlx5e_priv *priv, struct devlink_fms
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "RQ");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "RQ");
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "QPC");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "QPC");
 	if (err)
 		return err;
 
@@ -421,11 +421,11 @@ static int mlx5e_rx_reporter_dump_rq(struct mlx5e_priv *priv, struct devlink_fms
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "receive_buff");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "receive_buff");
 	if (err)
 		return err;
 
@@ -435,11 +435,11 @@ static int mlx5e_rx_reporter_dump_rq(struct mlx5e_priv *priv, struct devlink_fms
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
-	return mlx5e_reporter_named_obj_nest_end(fmsg);
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
 
 static int mlx5e_rx_reporter_dump_all_rqs(struct mlx5e_priv *priv,
@@ -451,7 +451,7 @@ static int mlx5e_rx_reporter_dump_all_rqs(struct mlx5e_priv *priv,
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		return 0;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "RX Slice");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "RX Slice");
 	if (err)
 		return err;
 
@@ -461,7 +461,7 @@ static int mlx5e_rx_reporter_dump_all_rqs(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 6eb2971231d8..9f712ff2faf9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -166,7 +166,7 @@ mlx5e_tx_reporter_build_diagnose_output(struct devlink_fmsg *fmsg,
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_cq_diagnose(&sq->cq, fmsg);
+	err = mlx5e_health_cq_diag_fmsg(&sq->cq, fmsg);
 	if (err)
 		return err;
 
@@ -195,11 +195,11 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	sq_sz = mlx5_wq_cyc_get_size(&generic_sq->wq);
 	sq_stride = MLX5_SEND_WQE_BB;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "Common Config");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "Common Config");
 	if (err)
 		goto unlock;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "SQ");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "SQ");
 	if (err)
 		goto unlock;
 
@@ -211,15 +211,15 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	if (err)
 		goto unlock;
 
-	err = mlx5e_reporter_cq_common_diagnose(&generic_sq->cq, fmsg);
+	err = mlx5e_health_cq_common_diag_fmsg(&generic_sq->cq, fmsg);
 	if (err)
 		goto unlock;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		goto unlock;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		goto unlock;
 
@@ -257,7 +257,7 @@ static int mlx5e_tx_reporter_dump_sq(struct mlx5e_priv *priv, struct devlink_fms
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		return 0;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "SX Slice");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "SX Slice");
 	if (err)
 		return err;
 
@@ -267,15 +267,15 @@ static int mlx5e_tx_reporter_dump_sq(struct mlx5e_priv *priv, struct devlink_fms
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "SQ");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "SQ");
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "QPC");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "QPC");
 	if (err)
 		return err;
 
@@ -287,11 +287,11 @@ static int mlx5e_tx_reporter_dump_sq(struct mlx5e_priv *priv, struct devlink_fms
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "send_buff");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "send_buff");
 	if (err)
 		return err;
 
@@ -301,11 +301,11 @@ static int mlx5e_tx_reporter_dump_sq(struct mlx5e_priv *priv, struct devlink_fms
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
-	return mlx5e_reporter_named_obj_nest_end(fmsg);
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
 
 static int mlx5e_tx_reporter_dump_all_sqs(struct mlx5e_priv *priv,
@@ -317,7 +317,7 @@ static int mlx5e_tx_reporter_dump_all_sqs(struct mlx5e_priv *priv,
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		return 0;
 
-	err = mlx5e_reporter_named_obj_nest_start(fmsg, "SX Slice");
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "SX Slice");
 	if (err)
 		return err;
 
@@ -327,7 +327,7 @@ static int mlx5e_tx_reporter_dump_all_sqs(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	err = mlx5e_reporter_named_obj_nest_end(fmsg);
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
 
-- 
2.26.2

