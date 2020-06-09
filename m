Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01BC1F387C
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 12:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgFIKsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 06:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgFIKrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 06:47:53 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567A0C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 03:47:45 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w7so15952144edt.1
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 03:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KgK4P2m0HWbcss1X1BSEkxtN1Ke/4iUpNFB9xpmQCOg=;
        b=UPvX5QPGLBD6wvTceu7r+wBSYknWrZ9OGRE9Zsl1g3in+7vsnsuoDklsiQJvGe//YE
         4hp574BPc7X4I70eobXw2nqhV1cp4ZVml9EZKW+ssvr0HYPdUT2gOYlNmU03rEfZ09dy
         UrosjQag9MDC2HScC/txdU/oi9AsxXODKDZdc8MgzX1qiCtvVf8hfimibs725xMslHRN
         kqHri+t64zKu4DE+9m9rlqW523rF8qoQP0EhH4GM17uui6B9dx1lP/yllSCGSHz56a7L
         oNSz7+n+3zEhU8wVrL86XpV4bqhvQ6LRu39MQYd/yuVod/e5ELFg7Jn1cnOaUvR++hW7
         EM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KgK4P2m0HWbcss1X1BSEkxtN1Ke/4iUpNFB9xpmQCOg=;
        b=oKi9OzBky//OskfDhSnS/kx5D3/DS6aNrS6a7XwXIZDAJOGlEfRBd7ETeFohzJkjfk
         pKi1x4BniqZOKN+gBWjfAIFazlbVoeyxfoyJLmiFk3UqrLUgRdm6pj0wyRP2yNEf6NZL
         m8B2w4iykO0O6jHb6DVDC8/vWNVxTUuGbByJvf4ejO80lPmjEa3Qjkf3oiDiwb59EtNj
         gnFs+7THHnuaulHa9ZyzyWnTfUwFgFmAhkkUPCOtpOgI5fvGTgUx4UN+o/YynO8YwH8+
         YsB3b1MLWGeI5CH2226WgFRAyquz3IKrp/Z5g0MfGqgsE/f6kfwfrUeawzhRQm3p1hYs
         7ntg==
X-Gm-Message-State: AOAM530Q05IB9EkUu3MhLzhtDrsoWdMerzOM61CHfZu3bJwRKT8Wyxe4
        H+FuTm20KtiaiU6egrDMwvqw3w==
X-Google-Smtp-Source: ABdhPJzhW/FuUGYzWYiWQfrwNgrP7hBIs7fJIRdVHuyLuLXWjZ/RasdGZG4rvQtmuhDFDz63vVvStA==
X-Received: by 2002:aa7:da17:: with SMTP id r23mr27104020eds.261.1591699664011;
        Tue, 09 Jun 2020 03:47:44 -0700 (PDT)
Received: from localhost.localdomain (hst-221-69.medicom.bg. [84.238.221.69])
        by smtp.gmail.com with ESMTPSA id qt19sm12267763ejb.14.2020.06.09.03.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 03:47:43 -0700 (PDT)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v3 5/7] venus: Add debugfs interface to set firmware log level
Date:   Tue,  9 Jun 2020 13:46:02 +0300
Message-Id: <20200609104604.1594-6-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be useful when debugging specific issues related to
firmware HFI interface.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/Makefile    |  2 +-
 drivers/media/platform/qcom/venus/core.c      |  5 ++++
 drivers/media/platform/qcom/venus/core.h      |  3 +++
 drivers/media/platform/qcom/venus/dbgfs.c     | 26 +++++++++++++++++++
 drivers/media/platform/qcom/venus/dbgfs.h     | 12 +++++++++
 drivers/media/platform/qcom/venus/hfi_venus.c |  7 ++++-
 6 files changed, 53 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/platform/qcom/venus/dbgfs.c
 create mode 100644 drivers/media/platform/qcom/venus/dbgfs.h

diff --git a/drivers/media/platform/qcom/venus/Makefile b/drivers/media/platform/qcom/venus/Makefile
index 64af0bc1edae..dfc636865709 100644
--- a/drivers/media/platform/qcom/venus/Makefile
+++ b/drivers/media/platform/qcom/venus/Makefile
@@ -3,7 +3,7 @@
 
 venus-core-objs += core.o helpers.o firmware.o \
 		   hfi_venus.o hfi_msgs.o hfi_cmds.o hfi.o \
-		   hfi_parser.o pm_helpers.o
+		   hfi_parser.o pm_helpers.o dbgfs.o
 
 venus-dec-objs += vdec.o vdec_ctrls.o
 venus-enc-objs += venc.o venc_ctrls.o
diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 203c6538044f..bbb394ca4175 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -290,6 +290,10 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_dev_unregister;
 
+	ret = venus_dbgfs_init(core);
+	if (ret)
+		goto err_dev_unregister;
+
 	return 0;
 
 err_dev_unregister:
@@ -337,6 +341,7 @@ static int venus_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&core->v4l2_dev);
 	mutex_destroy(&core->pm_lock);
 	mutex_destroy(&core->lock);
+	venus_dbgfs_deinit(core);
 
 	return ret;
 }
diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 7118612673c9..b48782f9aa95 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -12,6 +12,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 
+#include "dbgfs.h"
 #include "hfi.h"
 
 #define VIDC_CLKS_NUM_MAX		4
@@ -136,6 +137,7 @@ struct venus_caps {
  * @priv:	a private filed for HFI operations
  * @ops:		the core HFI operations
  * @work:	a delayed work for handling system fatal error
+ * @root:	debugfs root directory
  */
 struct venus_core {
 	void __iomem *base;
@@ -185,6 +187,7 @@ struct venus_core {
 	unsigned int codecs_count;
 	unsigned int core0_usage_count;
 	unsigned int core1_usage_count;
+	struct dentry *root;
 };
 
 struct vdec_controls {
diff --git a/drivers/media/platform/qcom/venus/dbgfs.c b/drivers/media/platform/qcom/venus/dbgfs.c
new file mode 100644
index 000000000000..a2465fe8e20b
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/dbgfs.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Linaro Ltd.
+ */
+
+#include <linux/debugfs.h>
+
+#include "core.h"
+
+extern int venus_fw_debug;
+
+int venus_dbgfs_init(struct venus_core *core)
+{
+	core->root = debugfs_create_dir("venus", NULL);
+	if (IS_ERR(core->root))
+		return IS_ERR(core->root);
+
+	debugfs_create_x32("fw_level", 0644, core->root, &venus_fw_debug);
+
+	return 0;
+}
+
+void venus_dbgfs_deinit(struct venus_core *core)
+{
+	debugfs_remove_recursive(core->root);
+}
diff --git a/drivers/media/platform/qcom/venus/dbgfs.h b/drivers/media/platform/qcom/venus/dbgfs.h
new file mode 100644
index 000000000000..4e35bd7db15f
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/dbgfs.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2020 Linaro Ltd. */
+
+#ifndef __VENUS_DBGFS_H__
+#define __VENUS_DBGFS_H__
+
+struct venus_core;
+
+int venus_dbgfs_init(struct venus_core *core);
+void venus_dbgfs_deinit(struct venus_core *core);
+
+#endif
diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 0d8855014ab3..3a04b08ab85a 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -130,7 +130,7 @@ struct venus_hfi_device {
 };
 
 static bool venus_pkt_debug;
-static int venus_fw_debug = HFI_DEBUG_MSG_ERROR | HFI_DEBUG_MSG_FATAL;
+int venus_fw_debug = HFI_DEBUG_MSG_ERROR | HFI_DEBUG_MSG_FATAL;
 static bool venus_sys_idle_indicator;
 static bool venus_fw_low_power_mode = true;
 static int venus_hw_rsp_timeout = 1000;
@@ -1130,9 +1130,14 @@ static int venus_session_init(struct venus_inst *inst, u32 session_type,
 			      u32 codec)
 {
 	struct venus_hfi_device *hdev = to_hfi_priv(inst->core);
+	struct device *dev = hdev->core->dev;
 	struct hfi_session_init_pkt pkt;
 	int ret;
 
+	ret = venus_sys_set_debug(hdev, venus_fw_debug);
+	if (ret)
+		dev_warn(dev, "setting fw debug msg ON failed (%d)\n", ret);
+
 	ret = pkt_session_init(&pkt, inst, session_type, codec);
 	if (ret)
 		goto err;
-- 
2.17.1

