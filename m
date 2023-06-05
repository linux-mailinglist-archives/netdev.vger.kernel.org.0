Return-Path: <netdev+bounces-7896-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A88D7722017
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B66AD1C20B61
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2478A11CAC;
	Mon,  5 Jun 2023 07:51:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1803EF9E7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:51:43 +0000 (UTC)
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584FE94
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:51:42 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-53fb4ee9ba1so2027014a12.3
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 00:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685951501; x=1688543501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nU2CYwpNmewMdUxmydFIJKU9mw4RWnhKF4EKr48i69c=;
        b=NUPnPfR/cXnngThOUnad7tfgNQ0f1UXENG1We2FCDFa4C4CymVLSv212LJ8zHlLLcT
         4VUNphhzVh/6O4DztgQqTGv5VgsWNitYcTHrAJ1hFvoSKScVrOHHing8RpsWXfqhbWaC
         U5tx1znsQQTwQvx+C65Y2mkbxqJtKHQMpS2UXsMFSsFvK8ptT7hEiIqU5g3ShNdrdgdI
         weBMEvMXbEyUvMCUDOevbfc6PH/XDWSG77yVzsfZr1kor2gXMBEaNCGoGObgZnCZHoox
         +bmVf4fDPuIcMYdKUEAv+mDNUysxiFKlUPUXdLMuV5errGMSsGwg1i0aMjE57AOGpn9E
         I0kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685951501; x=1688543501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nU2CYwpNmewMdUxmydFIJKU9mw4RWnhKF4EKr48i69c=;
        b=D5EBKUG0TTyMawUj/zw8SqXyurD361S8MOhk+q3k4Fdpdjl2SjVYNvDgPIlDupXy8c
         EmZEAW3hm45J427lKV3n9uWIMC/GlYljG+iZzgDon7YJwFIu64F0Rg//M0YmN6bzstQc
         o3ZzMtii4KOTLRgPIOWG75v4TpRAzrbx4SdDG+P9lup/ggN6XMB1ZeVIYM4v4a+FX+ss
         9fTP09jmOiYu7ZaPzDwBuQvTI25RMyKDKh8wQcj6qgxbraBSkwgdW1pCsnheU9KB2dAW
         PlLTQaKp3VdNdYM4eDNCewCJguU/kMOPsXiyYKnIrmILjwSsUpnKlKLnWPgZ++r1BpCK
         DYCg==
X-Gm-Message-State: AC+VfDytdrMgS2aOXhHvtfu5O7AhkHFDTmTKO2DWDswdixDNSlv/JMR3
	dPLBSV4nJywX/Dxu2fav6huQIa8Jor+hIw==
X-Google-Smtp-Source: ACHHUZ620uT8/It858F909Hd65L4MLMGFPkAYg59K4HeeUlZ7f8Fsic62FSQqHsOqpfZ9XVnxu/eLA==
X-Received: by 2002:a05:6a21:6d8f:b0:115:6b3e:7ab9 with SMTP id wl15-20020a056a216d8f00b001156b3e7ab9mr993867pzb.19.1685951501270;
        Mon, 05 Jun 2023 00:51:41 -0700 (PDT)
Received: from 6-0-u2204.. ([182.209.58.11])
        by smtp.gmail.com with ESMTPSA id e14-20020a170902ed8e00b001b02bd00c61sm5886356plj.237.2023.06.05.00.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 00:51:40 -0700 (PDT)
From: Juhee Kang <claudiajkang@gmail.com>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	leon@kernel.org,
	saeedm@nvidia.com
Subject: [net-next PATCH] net/mlx5: Add header file for events
Date: Mon,  5 Jun 2023 16:51:36 +0900
Message-Id: <20230605075136.1878-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Separate the event API defined in the generic mlx5.h header into
a dedicated header. And remove the TODO comment in commit
69c1280b1f3b ("net/mlx5: Device events, Use async events chain").

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
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
index f1d9596905c6..1ba70a90a476 100644
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
index 871c32dda66e..168c9e9ed2a7 100644
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
index d85a8dfc153d..00da17d502e6 100644
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
index 0c0ef600f643..604bb1914d9a 100644
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
2.34.1


