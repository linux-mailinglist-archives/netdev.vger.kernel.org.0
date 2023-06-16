Return-Path: <netdev+bounces-11603-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE2AA733AA0
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B9C31C210B7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13E722609;
	Fri, 16 Jun 2023 20:11:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FEF22617
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E812EC433C9;
	Fri, 16 Jun 2023 20:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946309;
	bh=yLcpryiCBJbr+GROLX2r8XANtgg+MINheHaV9cuj09c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0DjuQ7wAau3x7W9xeq09QkPgxH5D8jBSTm43CBOGONKzUlQIFOEKnAEQp0cbmrye
	 SDOEOzyhS26KKCX0FtHg/p4uZKvv8UfJNGA/7K1GAyDyzMmipznzfBVTQJ82A+eD2p
	 RpW4+g5t2b6JjvFRtOhEOhy8aRxRJIl9eKjf7dMGcXh854acXaFUMSGfC0wwSAc3xp
	 HgSL/eIM4fxXc+emlA0cOmBj9RbS/ZJFLb/5DmT+uM/i1t2E/0/VfsCxezBfzX8AHN
	 69I6IHNj1k6O/EaYz+vd6dXycJlCKZnM+ESL/9OuGSk2o5jB3nkvhJXKYLnBDb4kYd
	 EOpvvIy9b5DEQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Juhee Kang <claudiajkang@gmail.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>
Subject: [net-next 14/15] net/mlx5: Add header file for events
Date: Fri, 16 Jun 2023 13:11:12 -0700
Message-Id: <20230616201113.45510-15-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Juhee Kang <claudiajkang@gmail.com>

Separate the event API defined in the generic mlx5.h header into
a dedicated header. And remove the TODO comment in commit
69c1280b1f3b ("net/mlx5: Device events, Use async events chain").

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/events.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |  1 +
 .../net/ethernet/mellanox/mlx5/core/lag/mp.c  |  2 +-
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/events.h  | 40 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    | 34 ----------------
 7 files changed, 45 insertions(+), 38 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/events.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 25a6c596300d..4d77055abd4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -30,7 +30,7 @@
  * SOFTWARE.
  */
 
-#include "lib/mlx5.h"
+#include "lib/events.h"
 #include "en.h"
 #include "en_accel/ktls.h"
 #include "en_accel/en_accel.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 718cf09c28ce..3ec892d51f57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -5,7 +5,7 @@
 
 #include "mlx5_core.h"
 #include "lib/eq.h"
-#include "lib/mlx5.h"
+#include "lib/events.h"
 
 struct mlx5_event_nb {
 	struct mlx5_nb  nb;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 210100a4064a..187cb2c464f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -39,6 +39,7 @@
 #include "mlx5_core.h"
 #include "lib/eq.h"
 #include "lib/mlx5.h"
+#include "lib/events.h"
 #include "lib/pci_vsc.h"
 #include "lib/tout.h"
 #include "diag/fw_tracer.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index 976caa8e6922..b1aa494c76ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -7,7 +7,7 @@
 #include "lag/mp.h"
 #include "mlx5_core.h"
 #include "eswitch.h"
-#include "lib/mlx5.h"
+#include "lib/events.h"
 
 static bool __mlx5_lag_is_multipath(struct mlx5_lag *ldev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 0e869a76dfe4..4bf15391525c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -6,7 +6,7 @@
 #include "lag/lag.h"
 #include "eswitch.h"
 #include "esw/acl/ofld.h"
-#include "lib/mlx5.h"
+#include "lib/events.h"
 
 static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/events.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/events.h
new file mode 100644
index 000000000000..a0f7faea317b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/events.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __LIB_EVENTS_H__
+#define __LIB_EVENTS_H__
+
+#include "mlx5_core.h"
+
+#define PORT_MODULE_EVENT_MODULE_STATUS_MASK 0xF
+#define PORT_MODULE_EVENT_ERROR_TYPE_MASK    0xF
+
+enum port_module_event_status_type {
+	MLX5_MODULE_STATUS_PLUGGED   = 0x1,
+	MLX5_MODULE_STATUS_UNPLUGGED = 0x2,
+	MLX5_MODULE_STATUS_ERROR     = 0x3,
+	MLX5_MODULE_STATUS_DISABLED  = 0x4,
+	MLX5_MODULE_STATUS_NUM,
+};
+
+enum  port_module_event_error_type {
+	MLX5_MODULE_EVENT_ERROR_POWER_BUDGET_EXCEEDED    = 0x0,
+	MLX5_MODULE_EVENT_ERROR_LONG_RANGE_FOR_NON_MLNX  = 0x1,
+	MLX5_MODULE_EVENT_ERROR_BUS_STUCK                = 0x2,
+	MLX5_MODULE_EVENT_ERROR_NO_EEPROM_RETRY_TIMEOUT  = 0x3,
+	MLX5_MODULE_EVENT_ERROR_ENFORCE_PART_NUMBER_LIST = 0x4,
+	MLX5_MODULE_EVENT_ERROR_UNKNOWN_IDENTIFIER       = 0x5,
+	MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE         = 0x6,
+	MLX5_MODULE_EVENT_ERROR_BAD_CABLE                = 0x7,
+	MLX5_MODULE_EVENT_ERROR_PCIE_POWER_SLOT_EXCEEDED = 0xc,
+	MLX5_MODULE_EVENT_ERROR_NUM,
+};
+
+struct mlx5_pme_stats {
+	u64 status_counters[MLX5_MODULE_STATUS_NUM];
+	u64 error_counters[MLX5_MODULE_EVENT_ERROR_NUM];
+};
+
+void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats);
+int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int event, void *data);
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index ccf12f7db6f0..2b5826a785c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -45,40 +45,6 @@ int mlx5_crdump_enable(struct mlx5_core_dev *dev);
 void mlx5_crdump_disable(struct mlx5_core_dev *dev);
 int mlx5_crdump_collect(struct mlx5_core_dev *dev, u32 *cr_data);
 
-/* TODO move to lib/events.h */
-
-#define PORT_MODULE_EVENT_MODULE_STATUS_MASK 0xF
-#define PORT_MODULE_EVENT_ERROR_TYPE_MASK    0xF
-
-enum port_module_event_status_type {
-	MLX5_MODULE_STATUS_PLUGGED   = 0x1,
-	MLX5_MODULE_STATUS_UNPLUGGED = 0x2,
-	MLX5_MODULE_STATUS_ERROR     = 0x3,
-	MLX5_MODULE_STATUS_DISABLED  = 0x4,
-	MLX5_MODULE_STATUS_NUM,
-};
-
-enum  port_module_event_error_type {
-	MLX5_MODULE_EVENT_ERROR_POWER_BUDGET_EXCEEDED    = 0x0,
-	MLX5_MODULE_EVENT_ERROR_LONG_RANGE_FOR_NON_MLNX  = 0x1,
-	MLX5_MODULE_EVENT_ERROR_BUS_STUCK                = 0x2,
-	MLX5_MODULE_EVENT_ERROR_NO_EEPROM_RETRY_TIMEOUT  = 0x3,
-	MLX5_MODULE_EVENT_ERROR_ENFORCE_PART_NUMBER_LIST = 0x4,
-	MLX5_MODULE_EVENT_ERROR_UNKNOWN_IDENTIFIER       = 0x5,
-	MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE         = 0x6,
-	MLX5_MODULE_EVENT_ERROR_BAD_CABLE                = 0x7,
-	MLX5_MODULE_EVENT_ERROR_PCIE_POWER_SLOT_EXCEEDED = 0xc,
-	MLX5_MODULE_EVENT_ERROR_NUM,
-};
-
-struct mlx5_pme_stats {
-	u64 status_counters[MLX5_MODULE_STATUS_NUM];
-	u64 error_counters[MLX5_MODULE_EVENT_ERROR_NUM];
-};
-
-void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats);
-int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int event, void *data);
-
 static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
 {
 	return devlink_net(priv_to_devlink(dev));
-- 
2.40.1


