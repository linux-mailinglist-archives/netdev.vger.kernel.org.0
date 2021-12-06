Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FE746AE8B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353793AbhLFXpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 18:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbhLFXpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:45:39 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2ADBC0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 15:42:09 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id m27so29114358lfj.12
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 15:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rn0II+Rf71/vLVMb9zBHUU4A9s2oaR60NrApT1/X4AQ=;
        b=PEb9neyCWeBkjTWa077YInnubVCQXnFk3c1g+ibUjEUCKSSPa8E7z8zWamay5IHPgA
         iT13v9NU6Z37M60E4BP4h/rpSz9P2fIy7GyUUXe0Zg99dB0rWFCiczy1hmaGdh/Hg7wn
         SUsrcXdmwsBovC9yLtQuPI+6hwJOQ7xF3uE/6ky6jNm4nHO+sZqmo5GmxK214fQSlgWa
         L1US4LyUUx9PT5ZFBwiRKowiQ13cPYcxHvPW8Bogpw+ONWz7CTH+bT60HyB7vBngSb6G
         1tkAi7V0/tv1Qh9+eawmymefn9viCm5oRo8pbe1htQQoDYADetFo/2Sap/5rSNU16iLO
         uk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rn0II+Rf71/vLVMb9zBHUU4A9s2oaR60NrApT1/X4AQ=;
        b=1fSZtVmnSyV6EKYI0wMR6ESRjdJ8Gf9NSRjJOpeqCI6Kwyc32ntriOxpAJO6cp4X08
         dlHBGLIOePelI6oLT35y9TZZrw7LNOMNDot3eoSMnGCFn1fIRIsoVD3KfGgIltsbhhsZ
         Ie7KfiGljBoDT2NbeASROS80eqyBJ/PpJF8qii5meAGbak3kHZzZMREW606m8KffPSoE
         gHNwlEiO4FvR1RjSDFX6vTCC+8Bm1vPBStyLRjlsrDGddUOMNRPkxFjW27r74tBbAwcy
         +wQb94sSt6ZCrwrh/iAmgb9Uei9ajAGlFPx0bbhxI7yCKeG5njxBbNtnDmm7zMCBfhld
         QXvw==
X-Gm-Message-State: AOAM532fQKmlU0nG/O+o0Zf13zNs92IwRFmZLMYv2KGlGUVoCnH6sdLj
        iue2qRDXWiod0DeetavDeQ4=
X-Google-Smtp-Source: ABdhPJzK3xquobzKsFXPaNK9eoSAF4YEOQAKeFIhkZLG6VttxVrN8WQJfynTAPR+VJLOZWzuZUmgKw==
X-Received: by 2002:a05:6512:b8e:: with SMTP id b14mr38075658lfv.654.1638834128065;
        Mon, 06 Dec 2021 15:42:08 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id f23sm1590333ljg.90.2021.12.06.15.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 15:42:07 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next v2 4/4] net: wwan: make debugfs optional
Date:   Tue,  7 Dec 2021 02:41:55 +0300
Message-Id: <20211206234155.15578-5-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211206234155.15578-1-ryazanov.s.a@gmail.com>
References: <20211206234155.15578-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Debugfs interface is optional for the regular modem use. Some distros
and users will want to disable this feature for security or kernel
size reasons. So add a configuration option that allows to completely
disable the debugfs interface of the WWAN devices.

A primary considered use case for this option was embedded firmwares.
For example, in OpenWrt, you can not completely disable debugfs, as a
lot of wireless stuff can only be configured and monitored with the
debugfs knobs. At the same time, reducing the size of a kernel and
modules is an essential task in the world of embedded software.
Disabling the WWAN and IOSM debugfs interfaces allows us to save 50K
(x86-64 build) of space for module storage. Not much, but already
considerable when you only have 16MB of storage.

So it is hard to just disable whole debugfs. Users need some fine
grained set of options to control which debugfs interface is important
and should be available and which is not.

The new configuration symbol is enabled by default and is hidden under
the EXPERT option. So a regular user would not be bothered by another
one configuration question. While an embedded distro maintainer will be
able to a little more reduce the final image size.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
Changes since v1:
* this is a merge of 4th and 5th patches
* drop the IOSM specific configuration option and use the common WWAN
  option to control the IOSM debugfs interface build, thanks to Johannes
  and Leon for their recomendations
* make WWAN debugfs enabled by default and hide it under EXPERT as
  suggested by Johannes
* add  a detailed rationale to the patch description to show why we need
  the ability to disable debugfs
* return ERR_PTR(-ENODEV) instead of NULL if WWAN debugfs was disabled,
  thanks to Johannes for spotting this
* fix unused 'wwandev_name' variable warning
* expand the new configuration symbold description

 drivers/net/wwan/Kconfig                 | 13 ++++++++++++-
 drivers/net/wwan/iosm/Makefile           |  4 +++-
 drivers/net/wwan/iosm/iosm_ipc_debugfs.h |  5 +++++
 drivers/net/wwan/iosm/iosm_ipc_imem.c    |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.h    |  4 ++++
 drivers/net/wwan/iosm/iosm_ipc_trace.c   |  6 ++++--
 drivers/net/wwan/iosm/iosm_ipc_trace.h   | 20 +++++++++++++++++++-
 drivers/net/wwan/wwan_core.c             | 17 +++++++++++++----
 include/linux/wwan.h                     |  7 +++++++
 9 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 9f5111a77da9..609fd4a2c865 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -16,6 +16,17 @@ config WWAN
 
 if WWAN
 
+config WWAN_DEBUGFS
+	bool "WWAN devices debugfs interface" if EXPERT
+	depends on DEBUG_FS
+	default y
+	help
+	  Enables debugfs infrastructure for the WWAN core and device drivers.
+
+	  If this option is selected, then you can find the debug interface
+	  elements for each WWAN device in a directory that is corresponding to
+	  the device name: debugfs/wwan/wwanX.
+
 config WWAN_HWSIM
 	tristate "Simulated WWAN device"
 	help
@@ -85,7 +96,7 @@ config IOSM
 	tristate "IOSM Driver for Intel M.2 WWAN Device"
 	depends on INTEL_IOMMU
 	select NET_DEVLINK
-	select RELAY
+	select RELAY if WWAN_DEBUGFS
 	help
 	  This driver enables Intel M.2 WWAN Device communication.
 
diff --git a/drivers/net/wwan/iosm/Makefile b/drivers/net/wwan/iosm/Makefile
index 5091f664af0d..fa8d6afd18e1 100644
--- a/drivers/net/wwan/iosm/Makefile
+++ b/drivers/net/wwan/iosm/Makefile
@@ -21,7 +21,9 @@ iosm-y = \
 	iosm_ipc_mux_codec.o		\
 	iosm_ipc_devlink.o		\
 	iosm_ipc_flash.o		\
-	iosm_ipc_coredump.o		\
+	iosm_ipc_coredump.o
+
+iosm-$(CONFIG_WWAN_DEBUGFS) += \
 	iosm_ipc_debugfs.o		\
 	iosm_ipc_trace.o
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_debugfs.h b/drivers/net/wwan/iosm/iosm_ipc_debugfs.h
index 35788039f13f..8a84bfa2c14a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_debugfs.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_debugfs.h
@@ -6,7 +6,12 @@
 #ifndef IOSM_IPC_DEBUGFS_H
 #define IOSM_IPC_DEBUGFS_H
 
+#ifdef CONFIG_WWAN_DEBUGFS
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
index 1b8c7b8959c6..86a1ffe61729 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -351,7 +351,9 @@ struct iosm_imem {
 	struct iosm_mux *mux;
 	struct iosm_cdev *ipc_port[IPC_MEM_MAX_CHANNELS];
 	struct iosm_pcie *pcie;
+#ifdef CONFIG_WWAN_DEBUGFS
 	struct iosm_trace *trace;
+#endif
 	struct device *dev;
 	enum ipc_mem_device_ipc_state ipc_requested_state;
 	struct ipc_mem_channel channels[IPC_MEM_MAX_CHANNELS];
@@ -381,7 +383,9 @@ struct iosm_imem {
 	   ev_mux_net_transmit_pending:1,
 	   reset_det_n:1,
 	   pcie_wake_n:1;
+#ifdef CONFIG_WWAN_DEBUGFS
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
index 419540c91219..5ebe7790585c 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.h
@@ -45,6 +45,8 @@ struct iosm_trace {
 	enum trace_ctrl_mode mode;
 };
 
+#ifdef CONFIG_WWAN_DEBUGFS
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
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 5bf62dc35ac7..1508dc2a497b 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -50,7 +50,9 @@ struct wwan_device {
 	atomic_t port_id;
 	const struct wwan_ops *ops;
 	void *ops_ctxt;
+#ifdef CONFIG_WWAN_DEBUGFS
 	struct dentry *debugfs_dir;
+#endif
 };
 
 /**
@@ -146,6 +148,7 @@ static struct wwan_device *wwan_dev_get_by_name(const char *name)
 	return to_wwan_dev(dev);
 }
 
+#ifdef CONFIG_WWAN_DEBUGFS
 struct dentry *wwan_get_debugfs_dir(struct device *parent)
 {
 	struct wwan_device *wwandev;
@@ -157,6 +160,7 @@ struct dentry *wwan_get_debugfs_dir(struct device *parent)
 	return wwandev->debugfs_dir;
 }
 EXPORT_SYMBOL_GPL(wwan_get_debugfs_dir);
+#endif
 
 /* This function allocates and registers a new WWAN device OR if a WWAN device
  * already exist for the given parent, it gets a reference and return it.
@@ -166,7 +170,6 @@ EXPORT_SYMBOL_GPL(wwan_get_debugfs_dir);
 static struct wwan_device *wwan_create_dev(struct device *parent)
 {
 	struct wwan_device *wwandev;
-	const char *wwandev_name;
 	int err, id;
 
 	/* The 'find-alloc-register' operation must be protected against
@@ -206,9 +209,11 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
 		goto done_unlock;
 	}
 
-	wwandev_name = kobject_name(&wwandev->dev.kobj);
-	wwandev->debugfs_dir = debugfs_create_dir(wwandev_name,
-						  wwan_debugfs_dir);
+#ifdef CONFIG_WWAN_DEBUGFS
+	wwandev->debugfs_dir =
+			debugfs_create_dir(kobject_name(&wwandev->dev.kobj),
+					   wwan_debugfs_dir);
+#endif
 
 done_unlock:
 	mutex_unlock(&wwan_register_lock);
@@ -240,7 +245,9 @@ static void wwan_remove_dev(struct wwan_device *wwandev)
 		ret = device_for_each_child(&wwandev->dev, NULL, is_wwan_child);
 
 	if (!ret) {
+#ifdef CONFIG_WWAN_DEBUGFS
 		debugfs_remove_recursive(wwandev->debugfs_dir);
+#endif
 		device_unregister(&wwandev->dev);
 	} else {
 		put_device(&wwandev->dev);
@@ -1140,7 +1147,9 @@ static int __init wwan_init(void)
 		goto destroy;
 	}
 
+#ifdef CONFIG_WWAN_DEBUGFS
 	wwan_debugfs_dir = debugfs_create_dir("wwan", NULL);
+#endif
 
 	return 0;
 
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 1646aa3e6779..e143c88bf4b0 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -171,6 +171,13 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 
 void wwan_unregister_ops(struct device *parent);
 
+#ifdef CONFIG_WWAN_DEBUGFS
 struct dentry *wwan_get_debugfs_dir(struct device *parent);
+#else
+static inline struct dentry *wwan_get_debugfs_dir(struct device *parent)
+{
+	return ERR_PTR(-ENODEV);
+}
+#endif
 
 #endif /* __WWAN_H */
-- 
2.32.0

