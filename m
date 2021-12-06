Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D02946AE8A
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353779AbhLFXpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 18:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351277AbhLFXpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:45:38 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9638DC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 15:42:08 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id d10so9264900lfg.6
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 15:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dfSeAedh+6z3xPMXJEbK39zxUF9RksqGn+LD5Z11VAk=;
        b=paqEvX/cUy6bLE+vhFcgHZ30+6nqdeLe/WITbffLcprayr5wHVMrotd3ekUA4Qyt4g
         f7poJO9hC1zsnCdb51LSAWg/edXNqF2BL2sV0oN1vQyouG+wA9h99C+7y8picX2tJGFt
         CY1WTt82eBUU1e3tjnMR0q5E6WWYCX7fXpZXEJi4WZuol7DisWApTFMlDTQDXQHX2LwK
         4KCPNVHn076zruCPrnuNIBk7kvdlo4GXaFdSJ61T1VPk67cfVZQcOzEd2FpsmyZp286X
         P2Okk8V0riJLcdGWviP7kST4wFZSp3ikU53JwbgMU1U2GXVXSQBmopLPj+pyIWQ15MBy
         UGFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dfSeAedh+6z3xPMXJEbK39zxUF9RksqGn+LD5Z11VAk=;
        b=BYF9gtr8QdorjW3CqNdydigH5IV9PQ4rcjw+wOrcz+HVUTd5fqKPPPQa4IL5/S7HL5
         t2B/MzBgrCSdukcTjfmUed5DtCGu3pMgF8A4ImTOsMmwCJXN/3qBls4QUsfG0699KPTN
         UPuYttlRM4NypkxQDlWWImCPkISZQE6psp3W3zGvcT7WDBrtEkBsxKK/yDePE/J5GqNF
         iHGW1yYGKRTjBPXP0q2IGRp/wAXiYyGakXdMInBBo0mOyJVg1gl83eevEEOU53hU/QzR
         Lj6vBplKB5YBtZXvbfZRb1FOqXclePJU45sZVDDP8l8RM3SNYNc3NracnnWCK6F31ZtM
         ZHXw==
X-Gm-Message-State: AOAM533/F9cKZRx13yP0JoSxydeycezAPdvtQhq/KDKXQ6VRRVj1EHdq
        LuwxSvkI3m6eDjdX0uO3DH8=
X-Google-Smtp-Source: ABdhPJwK03zMl1tk4Z3qyfhR4tHgr70B7s9WdYeB988n353VpB+3fmui6Yh1CYLsRD0KHdvJPGW2Dw==
X-Received: by 2002:a05:6512:1506:: with SMTP id bq6mr38700923lfb.444.1638834126904;
        Mon, 06 Dec 2021 15:42:06 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id f23sm1590333ljg.90.2021.12.06.15.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 15:42:06 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next v2 3/4] net: wwan: iosm: move debugfs knobs into a subdir
Date:   Tue,  7 Dec 2021 02:41:54 +0300
Message-Id: <20211206234155.15578-4-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211206234155.15578-1-ryazanov.s.a@gmail.com>
References: <20211206234155.15578-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The modem traces collection is a device (and so driver) specific option.
Therefore, move the related debugfs files into a driver-specific
subdirectory under the common per WWAN device directory.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
Changes since v1:
* add missed description for a new structure field 'debugfs_dir'

 drivers/net/wwan/iosm/Makefile           |  1 +
 drivers/net/wwan/iosm/iosm_ipc_debugfs.c | 29 ++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_debugfs.h | 12 ++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem.c    |  7 +++---
 drivers/net/wwan/iosm/iosm_ipc_imem.h    |  2 ++
 drivers/net/wwan/iosm/iosm_ipc_trace.c   |  6 ++---
 6 files changed, 49 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.h

diff --git a/drivers/net/wwan/iosm/Makefile b/drivers/net/wwan/iosm/Makefile
index 5c2528beca2a..5091f664af0d 100644
--- a/drivers/net/wwan/iosm/Makefile
+++ b/drivers/net/wwan/iosm/Makefile
@@ -22,6 +22,7 @@ iosm-y = \
 	iosm_ipc_devlink.o		\
 	iosm_ipc_flash.o		\
 	iosm_ipc_coredump.o		\
+	iosm_ipc_debugfs.o		\
 	iosm_ipc_trace.o
 
 obj-$(CONFIG_IOSM) := iosm.o
diff --git a/drivers/net/wwan/iosm/iosm_ipc_debugfs.c b/drivers/net/wwan/iosm/iosm_ipc_debugfs.c
new file mode 100644
index 000000000000..f2f57751a7d2
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_debugfs.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020-2021 Intel Corporation.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/wwan.h>
+
+#include "iosm_ipc_imem.h"
+#include "iosm_ipc_trace.h"
+#include "iosm_ipc_debugfs.h"
+
+void ipc_debugfs_init(struct iosm_imem *ipc_imem)
+{
+	struct dentry *debugfs_pdev = wwan_get_debugfs_dir(ipc_imem->dev);
+
+	ipc_imem->debugfs_dir = debugfs_create_dir(KBUILD_MODNAME,
+						   debugfs_pdev);
+
+	ipc_imem->trace = ipc_trace_init(ipc_imem);
+	if (!ipc_imem->trace)
+		dev_warn(ipc_imem->dev, "trace channel init failed");
+}
+
+void ipc_debugfs_deinit(struct iosm_imem *ipc_imem)
+{
+	ipc_trace_deinit(ipc_imem->trace);
+	debugfs_remove_recursive(ipc_imem->debugfs_dir);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_debugfs.h b/drivers/net/wwan/iosm/iosm_ipc_debugfs.h
new file mode 100644
index 000000000000..35788039f13f
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_debugfs.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020-2021 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_DEBUGFS_H
+#define IOSM_IPC_DEBUGFS_H
+
+void ipc_debugfs_init(struct iosm_imem *ipc_imem);
+void ipc_debugfs_deinit(struct iosm_imem *ipc_imem);
+
+#endif
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index a60b93cefd2e..25b889922912 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -11,6 +11,7 @@
 #include "iosm_ipc_imem.h"
 #include "iosm_ipc_port.h"
 #include "iosm_ipc_trace.h"
+#include "iosm_ipc_debugfs.h"
 
 /* Check the wwan ips if it is valid with Channel as input. */
 static int ipc_imem_check_wwan_ips(struct ipc_mem_channel *chnl)
@@ -554,9 +555,7 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 		ctrl_chl_idx++;
 	}
 
-	ipc_imem->trace = ipc_trace_init(ipc_imem);
-	if (!ipc_imem->trace)
-		dev_warn(ipc_imem->dev, "trace channel init failed");
+	ipc_debugfs_init(ipc_imem);
 
 	ipc_task_queue_send_task(ipc_imem, ipc_imem_send_mdm_rdy_cb, 0, NULL, 0,
 				 false);
@@ -1173,7 +1172,7 @@ void ipc_imem_cleanup(struct iosm_imem *ipc_imem)
 
 	if (test_and_clear_bit(FULLY_FUNCTIONAL, &ipc_imem->flag)) {
 		ipc_mux_deinit(ipc_imem->mux);
-		ipc_trace_deinit(ipc_imem->trace);
+		ipc_debugfs_deinit(ipc_imem);
 		ipc_wwan_deinit(ipc_imem->wwan);
 		ipc_port_deinit(ipc_imem->ipc_port);
 	}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index cec38009c44a..1b8c7b8959c6 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -341,6 +341,7 @@ enum ipc_phase {
  * @ev_mux_net_transmit_pending:0 means inform the IPC tasklet to pass
  * @reset_det_n:		Reset detect flag
  * @pcie_wake_n:		Pcie wake flag
+ * @debugfs_dir:		Debug FS directory for driver-specific entries
  */
 struct iosm_imem {
 	struct iosm_mmio *mmio;
@@ -380,6 +381,7 @@ struct iosm_imem {
 	   ev_mux_net_transmit_pending:1,
 	   reset_det_n:1,
 	   pcie_wake_n:1;
+	struct dentry *debugfs_dir;
 };
 
 /**
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.c b/drivers/net/wwan/iosm/iosm_ipc_trace.c
index c588a394cd94..5243ead90b5f 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.c
@@ -134,7 +134,6 @@ struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem)
 {
 	struct ipc_chnl_cfg chnl_cfg = { 0 };
 	struct iosm_trace *ipc_trace;
-	struct dentry *debugfs_pdev;
 
 	ipc_chnl_cfg_get(&chnl_cfg, IPC_MEM_CTRL_CHL_ID_3);
 	ipc_imem_channel_init(ipc_imem, IPC_CTYPE_CTRL, chnl_cfg,
@@ -150,15 +149,14 @@ struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem)
 	ipc_trace->chl_id = IPC_MEM_CTRL_CHL_ID_3;
 
 	mutex_init(&ipc_trace->trc_mutex);
-	debugfs_pdev = wwan_get_debugfs_dir(ipc_imem->dev);
 
 	ipc_trace->ctrl_file = debugfs_create_file(IOSM_TRC_DEBUGFS_TRACE_CTRL,
 						   IOSM_TRC_FILE_PERM,
-						   debugfs_pdev,
+						   ipc_imem->debugfs_dir,
 						   ipc_trace, &ipc_trace_fops);
 
 	ipc_trace->ipc_rchan = relay_open(IOSM_TRC_DEBUGFS_TRACE,
-					  debugfs_pdev,
+					  ipc_imem->debugfs_dir,
 					  IOSM_TRC_SUB_BUFF_SIZE,
 					  IOSM_TRC_N_SUB_BUFF,
 					  &relay_callbacks, NULL);
-- 
2.32.0

