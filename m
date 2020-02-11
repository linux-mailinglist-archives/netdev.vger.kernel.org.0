Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5BB159C4E
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgBKWgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:36:05 -0500
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:38926
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727620AbgBKWgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:36:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YruOZowQ5cdV5GTKDmjhXb+x9S8RtOYA2g9BUKQjhlELsxfK5gznyeMjG/oHxhHyRBmNfhG+HjkGRCjNkhMeq0rMDpYHFSe27EUm8qCHuongfe2GvwMNfQxEbOlVxkVQbT1M/H7LORsgm5FwFnASGwd8yX5Vu1jMGKDh2x+50LOhByin8zLY1WnjTZcKx8LAmOiJthFP3Kq8xiujZoyU763nK+pL6w92HFtNVDCk/vyHD/U84b7m6K3ffRgNQ5QIAAiDthEF/C/OZ/LQcsF6k4BSkSzUhyNgz+MH6ZMiC+w0stSGxGiNH2yFJdeXcLZ/z2Qb24/U9Ww/eDcQEbwCQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wS3tMh9Z1jqVzrJ2Z21I2/cMOmdFRUHfCymMeyfVWE=;
 b=lmRWkvS4lpK1O8CYzkfKPT0KlgxdOyrzkal0o3b15RvYZZT7JCMp6c9mm5mqbEsnsFv13lMIzSrXvtiZ+KXhqhkHBXLg3jm1miw8Ik0tG8pt3GnTGI+SEN9ugDIft1tlMTM0vqXftISd528j75is5CNe9w6TYChRl7Ue4OBI4g3Umw+8gr6TgOqQbN50b0f4Hu4S1oY/AqpJMnCuz+/S/bmnqOjIeVdmedoYN06oNHsSmN3BP5GNKq9KXvyxjpFX48RarSyVmhwgIlgB1DPlmb6RrLhRPaMT4K/1Kk5dsCsjAZfXDTT++DOR6g1HNKi0+NiXtz8ObSQ2xucuaPSs2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wS3tMh9Z1jqVzrJ2Z21I2/cMOmdFRUHfCymMeyfVWE=;
 b=dxWjr+jUuX8F4pCycRgZzRn7kkh11Lzg0C1T417EtMCDZAuHnpjlaLlaGMNnlFiIrEQbXAjHR1kldDjzAIXWR2WFSmACDx3wE2NWOLb+slTPeZrZlBqrR7Yg1c/+42i52B8vH4DySmKf/A1yFiTiEcyEF5Y3pNDsXpYhK9CshS8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:35:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:35:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 06/13] mlx5: Use proper logging and tracing line terminations
Date:   Tue, 11 Feb 2020 14:32:47 -0800
Message-Id: <20200211223254.101641-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:35:47 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a5ab0c1e-2fd8-4a39-af65-08d7af42be10
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43838846620DB69FC25367DBBE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:651;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(110136005)(36756003)(5660300002)(478600001)(81156014)(6512007)(54906003)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0wv+X5ukJgAIjJUSOgqPu684uUTi56Kpkmep/YeHWkHd8oyjL2+z2CVhdSJizprnF1f1UNL5VTcbnohb7NWr5RDZIsWd5vhpKmsEvq7hdQPFHihg7oMqA0VQtHQSmUSeOV4X/og1ujWwHBlIJtr444sxvaOsxcDds4a3gRty+6jlQzOL2+3WiYBI+cEPwsXhlXKShuHJb4AA5xNg7Jh1JYBkDyrFvJNlPYYc+2J9QPWSuDpKdHeGnExfia50EDwyOxiNItgcVAGInfIsLux3DhM75O4D5n6i3lyz6GnKmP4uupusSG/KdkNmgSOoJdXtOmGcxuFuIY/0S/CP25KIQ3zzblgT+9dbfuuSzOeIJ0ylzAMHMKs/aTPFgzRCUuhOUstzEfvywFTJnqfkGk6KVGzQhAhWBrYDVMxedtrJYWMwrUeT2eVLZa9+Dh701/231GCv+zdBV/ZrrU0qF2kjNWy7a9TvbJwatf9teCQ9B4RsbGKq0Nny06FArXZjdG//7WYZY+Uv1KTZwwrOeSTU4jMX7pN+RLW2BRN+4GspZzw=
X-MS-Exchange-AntiSpam-MessageData: 6g5f7S3AS+PgXS2vksI/Q1FhMH64ueP8n9wUboLIzf9jI2VLq7fyntq9kfjSSRGPDR7cxnABE6MxZAKSK6dHjX8NUbe89bpcCguQ9KsYV0bfLdlU5mvTHBtuMqPqi21uW6JhJsYPMgQlXeR8vcykxA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ab0c1e-2fd8-4a39-af65-08d7af42be10
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:35:49.0689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0OphjUr636w5nWJ4zxhTguRqc7239a0Sxc4CkxBgUHAy/c8ysv/crjZWclIOT8pZ1MTLTVKdbQwN+Xy0tZvUhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>

netdev_err should use newline termination but mlx5_health_report
is used in a trace output function devlink_health_report where
no newline should be used.

Remove the newlines from a couple formats and add a format string
of "%s\n" to the netdev_err call to not directly output the
logging string.

Also use snprintf to avoid any possible output string overrun.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  9 +++++----
 .../net/ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 10 +++++-----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 7178f421d2cb..68d019b27642 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -198,7 +198,7 @@ int mlx5e_health_report(struct mlx5e_priv *priv,
 			struct devlink_health_reporter *reporter, char *err_str,
 			struct mlx5e_err_ctx *err_ctx)
 {
-	netdev_err(priv->netdev, err_str);
+	netdev_err(priv->netdev, "%s\n", err_str);
 
 	if (!reporter)
 		return err_ctx->recover(&err_ctx->ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 9599fdd620a8..ce2b41c61090 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -519,8 +519,9 @@ void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
 	err_ctx.ctx = rq;
 	err_ctx.recover = mlx5e_rx_reporter_timeout_recover;
 	err_ctx.dump = mlx5e_rx_reporter_dump_rq;
-	sprintf(err_str, "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x\n",
-		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
+	snprintf(err_str, sizeof(err_str),
+		 "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x",
+		 icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
 
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
@@ -534,7 +535,7 @@ void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
 	err_ctx.ctx = rq;
 	err_ctx.recover = mlx5e_rx_reporter_err_rq_cqe_recover;
 	err_ctx.dump = mlx5e_rx_reporter_dump_rq;
-	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on RQ: 0x%x", rq->rqn);
 
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
@@ -548,7 +549,7 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
 	err_ctx.ctx = icosq;
 	err_ctx.recover = mlx5e_rx_reporter_err_icosq_cqe_recover;
 	err_ctx.dump = mlx5e_rx_reporter_dump_icosq;
-	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
 
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 1772c9ce3938..2028ce9b151f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -375,7 +375,7 @@ void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 	err_ctx.ctx = sq;
 	err_ctx.recover = mlx5e_tx_reporter_err_cqe_recover;
 	err_ctx.dump = mlx5e_tx_reporter_dump_sq;
-	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on SQ: 0x%x", sq->sqn);
 
 	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
@@ -389,10 +389,10 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 	err_ctx.ctx = sq;
 	err_ctx.recover = mlx5e_tx_reporter_timeout_recover;
 	err_ctx.dump = mlx5e_tx_reporter_dump_sq;
-	sprintf(err_str,
-		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u\n",
-		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
-		jiffies_to_usecs(jiffies - sq->txq->trans_start));
+	snprintf(err_str, sizeof(err_str),
+		 "TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u",
+		 sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
+		 jiffies_to_usecs(jiffies - sq->txq->trans_start));
 
 	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
-- 
2.24.1

