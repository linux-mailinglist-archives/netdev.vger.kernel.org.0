Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392CA614BB
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfGGLx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:27 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58837 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726519AbfGGLx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:26 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:19 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJLs031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 05/16] net/mlx5e: Rename reporter header file
Date:   Sun,  7 Jul 2019 14:52:57 +0300
Message-Id: <1562500388-16847-6-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Rename reporter.h -> health.h so patches in the set can use it for
health related functionality.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.h      | 15 +++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h    | 15 ---------------
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        |  2 +-
 4 files changed, 17 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/health.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
new file mode 100644
index 000000000000..e78e92753d73
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5E_EN_REPORTER_H
+#define __MLX5E_EN_REPORTER_H
+
+#include <linux/mlx5/driver.h>
+#include "en.h"
+
+int mlx5e_tx_reporter_create(struct mlx5e_priv *priv);
+void mlx5e_tx_reporter_destroy(struct mlx5e_priv *priv);
+void mlx5e_tx_reporter_err_cqe(struct mlx5e_txqsq *sq);
+int mlx5e_tx_reporter_timeout(struct mlx5e_txqsq *sq);
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h
deleted file mode 100644
index e78e92753d73..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (c) 2019 Mellanox Technologies. */
-
-#ifndef __MLX5E_EN_REPORTER_H
-#define __MLX5E_EN_REPORTER_H
-
-#include <linux/mlx5/driver.h>
-#include "en.h"
-
-int mlx5e_tx_reporter_create(struct mlx5e_priv *priv);
-void mlx5e_tx_reporter_destroy(struct mlx5e_priv *priv);
-void mlx5e_tx_reporter_err_cqe(struct mlx5e_txqsq *sq);
-int mlx5e_tx_reporter_timeout(struct mlx5e_txqsq *sq);
-
-#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 83555894bacb..0035ae9306ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (c) 2019 Mellanox Technologies. */
 
-#include "reporter.h"
+#include "health.h"
 #include "lib/eq.h"
 
 #define MLX5E_TX_REPORTER_PER_SQ_MAX_LEN 256
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c5f11a05c34b..ce4533f8169c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -56,7 +56,7 @@
 #include "en/xdp.h"
 #include "lib/eq.h"
 #include "en/monitor_stats.h"
-#include "en/reporter.h"
+#include "en/health.h"
 #include "en/params.h"
 #include "en/xsk/umem.h"
 #include "en/xsk/setup.h"
-- 
1.8.3.1

