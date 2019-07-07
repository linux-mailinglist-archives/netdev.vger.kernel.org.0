Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A82C9614BC
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfGGLx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:27 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58840 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726436AbfGGLx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:26 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:19 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJLt031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 06/16] net/mlx5e: Change naming convention for reporter's functions
Date:   Sun,  7 Jul 2019 14:52:58 +0300
Message-Id: <1562500388-16847-7-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Change from mlx5e_tx_reporter_* to mlx5e_reporter_tx_*. In the following
patches in the set rx reporter is added, the new naming convention is
more uniformed.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.h      | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        | 8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index e78e92753d73..e3a3bcee89e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -7,9 +7,9 @@
 #include <linux/mlx5/driver.h>
 #include "en.h"
 
-int mlx5e_tx_reporter_create(struct mlx5e_priv *priv);
-void mlx5e_tx_reporter_destroy(struct mlx5e_priv *priv);
-void mlx5e_tx_reporter_err_cqe(struct mlx5e_txqsq *sq);
-int mlx5e_tx_reporter_timeout(struct mlx5e_txqsq *sq);
+int mlx5e_reporter_tx_create(struct mlx5e_priv *priv);
+void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv);
+void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
+int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 0035ae9306ec..d5ecfcfe5d52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -124,7 +124,7 @@ static int mlx5_tx_health_report(struct devlink_health_reporter *tx_reporter,
 	return devlink_health_report(tx_reporter, err_str, err_ctx);
 }
 
-void mlx5e_tx_reporter_err_cqe(struct mlx5e_txqsq *sq)
+void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 {
 	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
 	struct mlx5e_tx_err_ctx err_ctx = {0};
@@ -159,7 +159,7 @@ static int mlx5e_tx_reporter_timeout_recover(struct mlx5e_txqsq *sq)
 	return ret;
 }
 
-int mlx5e_tx_reporter_timeout(struct mlx5e_txqsq *sq)
+int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 {
 	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
 	struct mlx5e_tx_err_ctx err_ctx;
@@ -288,7 +288,7 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 
 #define MLX5_REPORTER_TX_GRACEFUL_PERIOD 500
 
-int mlx5e_tx_reporter_create(struct mlx5e_priv *priv)
+int mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
 {
 	struct devlink_health_reporter *reporter;
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -307,7 +307,7 @@ int mlx5e_tx_reporter_create(struct mlx5e_priv *priv)
 	return PTR_ERR_OR_ZERO(reporter);
 }
 
-void mlx5e_tx_reporter_destroy(struct mlx5e_priv *priv)
+void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv)
 {
 	if (!priv->tx_reporter)
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ce4533f8169c..98c925e72706 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1376,7 +1376,7 @@ static void mlx5e_tx_err_cqe_work(struct work_struct *recover_work)
 	struct mlx5e_txqsq *sq = container_of(recover_work, struct mlx5e_txqsq,
 					      recover_work);
 
-	mlx5e_tx_reporter_err_cqe(sq);
+	mlx5e_reporter_tx_err_cqe(sq);
 }
 
 int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
@@ -3201,7 +3201,7 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
 {
 	int tc;
 
-	mlx5e_tx_reporter_destroy(priv);
+	mlx5e_reporter_tx_destroy(priv);
 	for (tc = 0; tc < priv->profile->max_tc; tc++)
 		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
 }
@@ -4286,7 +4286,7 @@ static void mlx5e_tx_timeout_work(struct work_struct *work)
 		if (!netif_xmit_stopped(dev_queue))
 			continue;
 
-		if (mlx5e_tx_reporter_timeout(sq))
+		if (mlx5e_reporter_tx_timeout(sq))
 			report_failed = true;
 	}
 
@@ -5093,7 +5093,7 @@ static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_initialize(priv);
 #endif
-	mlx5e_tx_reporter_create(priv);
+	mlx5e_reporter_tx_create(priv);
 	return 0;
 }
 
-- 
1.8.3.1

