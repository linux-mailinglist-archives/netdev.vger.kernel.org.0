Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4C1159C4A
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgBKWf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:35:57 -0500
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:38926
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727361AbgBKWf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:35:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbGLrfV+kPmxBae8vj20o1csvAxyl3i/fY991spZjbxEQD1HyP6hj6tdqGHtKWyWUqvBPY6akz+1EaWHOvLFi5G4BftYP9yM+xqh9/76vDBct84NbogJ72pRMV5NJJZAmUaVclIaUDbGAOCt2dqhrQ3+lRGw94VQJf7yj73nra63HC6KkPHVk21yEvNAgIeSzUZgZpgvxfvhKblTCEX+v3qaZs8+WBQK333Lkbg7KaNF1YcldaZMNJaf4zwGav2tNBxuzLGmImBiufZWPy1fso0TeJvtsF/NzSSYa4FzWGAixhivU/FSf195oO4ItOS6gOKCgMEWveJV3iUcH5K+Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNFTU+f8A2nKnCNjJMbsPragQMrDTZk/xRCLQSCTls8=;
 b=kKAmr5+5D2wHin+LJM1qdEAUf7AMYqkl7GFnigyDR0fMq3+bKEafN7piBIypAsp4c8FLj2Vt64fFxV4+cTahKDozlbi0LDtKDpZqYNk7YzgAseGo2SC4iar1F3lIZ+0rLvcQ/BzBM2DLrxMPFdKo1weP4mcweowpXxwVf6+OrB4Q/Zb5QLHttNKXkC8LEGlp5BJ0Qi9Jbns4SWee3UHGFgf/oGc0TXYkfqafwnDpTuyZUF4zAz9n4QAndFeoLmkfaZiG/OFiP8yZEYry9f7MLWQFzcdd1fqi5ls2UwwK49eS7r3u0n/pc3CXEuy6xpvg2VIphkbLrNPq779By50W+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNFTU+f8A2nKnCNjJMbsPragQMrDTZk/xRCLQSCTls8=;
 b=oiPepX/tl4e+IG4EN7T5+kFt2cStDImHvizK0m1QI+xQXHza+/XMr8QEkm/PwuGgCHqXg3TKiQ58NKNOm5LW1ahSuQTGAkIwoKCe94ICvYL3dLCeI/kL12tVaq2iXotkAa79YOItP/ckQce7J8lJJUHpsaI3NZZ3Y6KoEYs/ujU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:35:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:35:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 03/13] net/mlx5e: Gather reporters APIs together
Date:   Tue, 11 Feb 2020 14:32:44 -0800
Message-Id: <20200211223254.101641-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:35:41 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9986c4e5-37be-4029-cd5e-08d7af42bab5
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4383A8FF8429AAF4C034FE8FBE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(110136005)(36756003)(5660300002)(478600001)(81156014)(6512007)(54906003)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HcqDl6ai/PhDtEP9oFLs1Yu+ZdDsGxAWaCJlcHX0ZgNwW54pUMLEIdIaJsk2jiMySOvzzQg8FLoZvm1xPzgz0XZLJ8VuvvAZxsGybJh+6AUUDNj4gbdL5GLyj2uIRZCPbvXTgURjFUSY34g9PdpLNT+M75cJcg4qjOZCzumZY3Db+bsMtNym2sGg+6XpIz6YkPOqxnzkru+N8VLMJ/f5Scfwr5mlPDFhXDT99eUk6y7SgELHDlis2pCgY53kdZR6i+Wsi0MAntxgDAUVV9/khPLPTL/VlUAnpirY4CVWNwEVnPer+8oKPoupi4yYD+n5+3qMjcKwh43ntgIj/Atvsv3VfS4n+5mCqFUhdsDVpx/eK2CQ+Q7nclqw+I+F66sOr9+NGMQmIAjeMy2HE4SrbjysVGni3Tf2NblY3byEbjn37XNw8NdTDxbx2d94Psr7kyaisDmaNgsCF8upNrSk9gzyExzKk+HGS7v1ZUN00YjMdGjYxkGEfimJAIq1/7PhXlItciWsIw+FPT9YAqU9GaxZ4D2vXMLpFfeX/9AgPGs=
X-MS-Exchange-AntiSpam-MessageData: iBqBh/hKZgH/fdlJeSFb7+nnfwkeqSz6r/b88J1hfTIXUrlE2o4g3C1tapdxCRBkzCQ4yIPIHV6DRJvWkPmpH/o689gGkJ10ylW1o8j0kbgYf3Ev83a1HAuH7QoExh/lZnacLXd4D8LzGf9qOO7xdQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9986c4e5-37be-4029-cd5e-08d7af42bab5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:35:43.4811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B0KNL899ixmQ4nUCsGLMgPH7mswfyh+BxtFhZNibt2zxazq1uSgUGqV9CXaV0NtclQvAfmJKJrq8NuWdwmW0Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Assemble all the API's to ease insertion of dump callbacks in the
following patches in the set.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/reporter_rx.c       | 82 +++++++++----------
 .../mellanox/mlx5/core/en/reporter_tx.c       | 58 ++++++-------
 2 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 6c72b592315b..cfa6941fca6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -102,19 +102,6 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 	return err;
 }
 
-void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
-{
-	struct mlx5e_priv *priv = icosq->channel->priv;
-	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
-	struct mlx5e_err_ctx err_ctx = {};
-
-	err_ctx.ctx = icosq;
-	err_ctx.recover = mlx5e_rx_reporter_err_icosq_cqe_recover;
-	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
-
-	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
-}
-
 static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
 {
 	struct net_device *dev = rq->netdev;
@@ -171,19 +158,6 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 	return err;
 }
 
-void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
-{
-	struct mlx5e_priv *priv = rq->channel->priv;
-	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
-	struct mlx5e_err_ctx err_ctx = {};
-
-	err_ctx.ctx = rq;
-	err_ctx.recover = mlx5e_rx_reporter_err_rq_cqe_recover;
-	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
-
-	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
-}
-
 static int mlx5e_rx_reporter_timeout_recover(void *ctx)
 {
 	struct mlx5e_icosq *icosq;
@@ -201,21 +175,6 @@ static int mlx5e_rx_reporter_timeout_recover(void *ctx)
 	return err;
 }
 
-void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
-{
-	struct mlx5e_icosq *icosq = &rq->channel->icosq;
-	struct mlx5e_priv *priv = rq->channel->priv;
-	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
-	struct mlx5e_err_ctx err_ctx = {};
-
-	err_ctx.ctx = rq;
-	err_ctx.recover = mlx5e_rx_reporter_timeout_recover;
-	sprintf(err_str, "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x\n",
-		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
-
-	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
-}
-
 static int mlx5e_rx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ctx)
 {
 	return err_ctx->recover(err_ctx->ctx);
@@ -371,6 +330,47 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	return err;
 }
 
+void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
+{
+	struct mlx5e_icosq *icosq = &rq->channel->icosq;
+	struct mlx5e_priv *priv = rq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx = {};
+
+	err_ctx.ctx = rq;
+	err_ctx.recover = mlx5e_rx_reporter_timeout_recover;
+	sprintf(err_str, "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x\n",
+		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
+void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
+{
+	struct mlx5e_priv *priv = rq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx = {};
+
+	err_ctx.ctx = rq;
+	err_ctx.recover = mlx5e_rx_reporter_err_rq_cqe_recover;
+	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
+void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
+{
+	struct mlx5e_priv *priv = icosq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx = {};
+
+	err_ctx.ctx = icosq;
+	err_ctx.recover = mlx5e_rx_reporter_err_icosq_cqe_recover;
+	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
 static const struct devlink_health_reporter_ops mlx5_rx_reporter_ops = {
 	.name = "rx",
 	.recover = mlx5e_rx_reporter_recover,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index b468549e96ff..623c949db54c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -82,19 +82,6 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 	return err;
 }
 
-void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
-{
-	struct mlx5e_priv *priv = sq->channel->priv;
-	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
-	struct mlx5e_err_ctx err_ctx = {0};
-
-	err_ctx.ctx = sq;
-	err_ctx.recover = mlx5e_tx_reporter_err_cqe_recover;
-	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
-
-	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
-}
-
 static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 {
 	struct mlx5_eq_comp *eq;
@@ -110,22 +97,6 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 	return err;
 }
 
-int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
-{
-	struct mlx5e_priv *priv = sq->channel->priv;
-	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
-	struct mlx5e_err_ctx err_ctx;
-
-	err_ctx.ctx = sq;
-	err_ctx.recover = mlx5e_tx_reporter_timeout_recover;
-	sprintf(err_str,
-		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u\n",
-		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
-		jiffies_to_usecs(jiffies - sq->txq->trans_start));
-
-	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
-}
-
 /* state lock cannot be grabbed within this function.
  * It can cause a dead lock or a read-after-free.
  */
@@ -275,6 +246,35 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 	return err;
 }
 
+void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
+{
+	struct mlx5e_priv *priv = sq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx = {};
+
+	err_ctx.ctx = sq;
+	err_ctx.recover = mlx5e_tx_reporter_err_cqe_recover;
+	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
+
+	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
+}
+
+int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
+{
+	struct mlx5e_priv *priv = sq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx = {};
+
+	err_ctx.ctx = sq;
+	err_ctx.recover = mlx5e_tx_reporter_timeout_recover;
+	sprintf(err_str,
+		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u\n",
+		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
+		jiffies_to_usecs(jiffies - sq->txq->trans_start));
+
+	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
+}
+
 static const struct devlink_health_reporter_ops mlx5_tx_reporter_ops = {
 		.name = "tx",
 		.recover = mlx5e_tx_reporter_recover,
-- 
2.24.1

