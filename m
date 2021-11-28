Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5767E460650
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 14:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357420AbhK1ND3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 08:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344496AbhK1NB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 08:01:28 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FC8C061758
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:55:37 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id u3so37159005lfl.2
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ut2j330bo/IxIjJswmV42yHAdJERMb8IowsBpx/nbpM=;
        b=THZa4bBhSrqWyIRUpaQ8GE7t418jV9HGBRuFRTOJqEe8ZkzfO5JvxQFtJ4O5GIkBIE
         7pkqYOISlPapLHtdfZmLj/3N3naZ+orlOunQLpn+dy4mz/W+ZO6GMShhGgeO9XnYPnVg
         garVYVZM95xBe2+++UVtL82b7l0Xy+hxw8Steci0Sh4NmOLXDj87avUTkmz9IYlHJO2t
         ipJarGlJXSAnRlAZ//yZeyB8JJC9cquyNVEOP/0CqlgQqPhBFvBUL4j8yn5OxeXd/QS1
         MV7G7OSUrKtxYofBF0orhlUZki/cwxUVvNzwRhvp3WUH5PLJt3L0syAgZWEUdjXdT4TR
         CSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ut2j330bo/IxIjJswmV42yHAdJERMb8IowsBpx/nbpM=;
        b=XZlvOPtdlpH/lMbwwN0M6VqFKE/mCByvV5wr55DGBULfVhQvtcN7YXyNj1dCS16H1X
         hrHM8YcygQ8rJlCKVeCG/KUugqcorXeB1Jfq1TGLQrdiBff2BCtYEG0aCvTmeuvWUILK
         kPBoVS6tUeIUmjsbrEtc7YHBu8EGs6iyVz1ri3chfOAYzovaslNWDNUc71F/N9JmMuEI
         aMTza93jJ+lgQX9GV2kNWQIoN1AowoJc0lKzq82WWDnXhVcI+iNfjgVPaG7F7Qog7ZIu
         P12OPQvZPxG1v0lMGpLwDQ1SU81T5/FIx8ybXQuo28K2DyLq5LP5fPmPrRyu1kPs5Z0T
         U0Lg==
X-Gm-Message-State: AOAM530yhrMsOQL3iUoRsXopURc92maB9RRveLzHCr0nko5RfJeLUkyZ
        c3nrekEU7xWy2Wh6xWZaplE=
X-Google-Smtp-Source: ABdhPJyGSMUla9XIloHOuxPhrzy26KU1v/iksoa5hSj3DCSnVsHNgaVjMEc4bmJE4WkVov6taKcZBw==
X-Received: by 2002:a19:4895:: with SMTP id v143mr39384108lfa.142.1638104136037;
        Sun, 28 Nov 2021 04:55:36 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id c1sm1066595ljr.111.2021.11.28.04.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:55:35 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH RESEND net-next 4/5] net: wwan: iosm: make debugfs optional
Date:   Sun, 28 Nov 2021 15:55:21 +0300
Message-Id: <20211128125522.23357-5-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Collecting modem firmware traces is optional for the regular modem use.
Some distros and users will want to disable this feature for security or
kernel size reasons. So add a configuration option that allows to
completely disable the driver debugfs interface.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/Kconfig                 |  8 ++++++++
 drivers/net/wwan/iosm/Makefile           |  4 +++-
 drivers/net/wwan/iosm/iosm_ipc_debugfs.h |  5 +++++
 drivers/net/wwan/iosm/iosm_ipc_imem.c    |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.h    |  4 ++++
 drivers/net/wwan/iosm/iosm_ipc_trace.c   |  6 ++++--
 drivers/net/wwan/iosm/iosm_ipc_trace.h   | 20 +++++++++++++++++++-
 7 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 17543be14665..e204e74edcec 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -80,6 +80,14 @@ config IOSM
 
 	  If unsure, say N.
 
+config IOSM_DEBUGFS
+	bool "IOSM Debugfs support"
+	depends on IOSM && DEBUG_FS
+	help
+	  Enables debugfs driver interface for traces collection.
+
+	  If unsure, say N.
+
 endif # WWAN
 
 endmenu
diff --git a/drivers/net/wwan/iosm/Makefile b/drivers/net/wwan/iosm/Makefile
index 5091f664af0d..bf28b29f6151 100644
--- a/drivers/net/wwan/iosm/Makefile
+++ b/drivers/net/wwan/iosm/Makefile
@@ -21,7 +21,9 @@ iosm-y = \
 	iosm_ipc_mux_codec.o		\
 	iosm_ipc_devlink.o		\
 	iosm_ipc_flash.o		\
-	iosm_ipc_coredump.o		\
+	iosm_ipc_coredump.o
+
+iosm-$(CONFIG_IOSM_DEBUGFS) += \
 	iosm_ipc_debugfs.o		\
 	iosm_ipc_trace.o
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_debugfs.h b/drivers/net/wwan/iosm/iosm_ipc_debugfs.h
index 35788039f13f..3e3bb968fa03 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_debugfs.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_debugfs.h
@@ -6,7 +6,12 @@
 #ifndef IOSM_IPC_DEBUGFS_H
 #define IOSM_IPC_DEBUGFS_H
 
+#ifdef CONFIG_IOSM_DEBUGFS
 void ipc_debugfs_init(struct iosm_imem *ipc_imem);
 void ipc_debugfs_deinit(struct iosm_imem *ipc_imem);
+#else
+static inline void ipc_debugfs_init(struct iosm_imem *ipc_imem) {}
+static inline void ipc_debugfs_deinit(struct iosm_imem *ipc_imem) {}
+#endif
 
 #endif
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 25b889922912..2a6ddd7c6c88 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -274,7 +274,7 @@ static void ipc_imem_dl_skb_process(struct iosm_imem *ipc_imem,
 			ipc_imem_sys_devlink_notify_rx(ipc_imem->ipc_devlink,
 						       skb);
 		else if (ipc_is_trace_channel(ipc_imem, port_id))
-			ipc_trace_port_rx(ipc_imem->trace, skb);
+			ipc_trace_port_rx(ipc_imem, skb);
 		else
 			wwan_port_rx(ipc_imem->ipc_port[port_id]->iosm_port,
 				     skb);
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index df3b471f6fa9..cca4b32c63cd 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -350,7 +350,9 @@ struct iosm_imem {
 	struct iosm_mux *mux;
 	struct iosm_cdev *ipc_port[IPC_MEM_MAX_CHANNELS];
 	struct iosm_pcie *pcie;
+#ifdef CONFIG_IOSM_DEBUGFS
 	struct iosm_trace *trace;
+#endif
 	struct device *dev;
 	enum ipc_mem_device_ipc_state ipc_requested_state;
 	struct ipc_mem_channel channels[IPC_MEM_MAX_CHANNELS];
@@ -380,7 +382,9 @@ struct iosm_imem {
 	   ev_mux_net_transmit_pending:1,
 	   reset_det_n:1,
 	   pcie_wake_n:1;
+#ifdef CONFIG_IOSM_DEBUGFS
 	struct dentry *debugfs_dir;
+#endif
 };
 
 /**
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.c b/drivers/net/wwan/iosm/iosm_ipc_trace.c
index 5243ead90b5f..eeecfa3d10c5 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.c
@@ -17,11 +17,13 @@
 
 /**
  * ipc_trace_port_rx - Receive trace packet from cp and write to relay buffer
- * @ipc_trace:  Pointer to the ipc trace data-struct
+ * @ipc_imem:   Pointer to iosm_imem structure
  * @skb:        Pointer to struct sk_buff
  */
-void ipc_trace_port_rx(struct iosm_trace *ipc_trace, struct sk_buff *skb)
+void ipc_trace_port_rx(struct iosm_imem *ipc_imem, struct sk_buff *skb)
 {
+	struct iosm_trace *ipc_trace = ipc_imem->trace;
+
 	if (ipc_trace->ipc_rchan)
 		relay_write(ipc_trace->ipc_rchan, skb->data, skb->len);
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.h b/drivers/net/wwan/iosm/iosm_ipc_trace.h
index 419540c91219..0d74836df90c 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.h
@@ -45,6 +45,8 @@ struct iosm_trace {
 	enum trace_ctrl_mode mode;
 };
 
+#ifdef CONFIG_IOSM_DEBUGFS
+
 static inline bool ipc_is_trace_channel(struct iosm_imem *ipc_mem, u16 chl_id)
 {
 	return ipc_mem->trace && ipc_mem->trace->chl_id == chl_id;
@@ -52,5 +54,21 @@ static inline bool ipc_is_trace_channel(struct iosm_imem *ipc_mem, u16 chl_id)
 
 struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem);
 void ipc_trace_deinit(struct iosm_trace *ipc_trace);
-void ipc_trace_port_rx(struct iosm_trace *ipc_trace, struct sk_buff *skb);
+void ipc_trace_port_rx(struct iosm_imem *ipc_imem, struct sk_buff *skb);
+
+#else
+
+static inline bool ipc_is_trace_channel(struct iosm_imem *ipc_mem, u16 chl_id)
+{
+	return false;
+}
+
+static inline void ipc_trace_port_rx(struct iosm_imem *ipc_imem,
+				     struct sk_buff *skb)
+{
+	dev_kfree_skb(skb);
+}
+
+#endif
+
 #endif
-- 
2.32.0

