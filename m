Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C00A607ABB
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiJUPcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiJUPby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:31:54 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A91A14FD18
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 08:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666366299; x=1697902299;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=a7dnYqezLsp/6R4vBodusRInr6ztTmqPAWvcJZnuDj8=;
  b=JrtvSW0y/9coASNWdeUoOu/PjK10RNz5aRb3ibZuXqxYqLiS0/cvgO5q
   zMtW1MLaWgila+0QpV6/Z/n5d9FiuGn3mMa/LRMc4oHXCxA95MI1STlhi
   uU2zawmmUgHSVHKPzmCrn0TykUeEsU8k3biNGUCV5LYbhAa5GS5UITBmL
   Rf66pUKuTCqD9lIDYRN45bAE/mR5X6wlvXLzLTasz0oFovSIF+KmnhgC9
   lmMb+LogF/SbTxqYi4pGfBhR31k2zgzyLcj4h/ht7ilalLNrTpHHLiYCR
   EhzFwmGzkdquHi8Sz19aDt8jAR9Y9XvAFFTuobAEhODV2zWPU7BBLmdHf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="286748956"
X-IronPort-AV: E=Sophos;i="5.95,202,1661842800"; 
   d="scan'208";a="286748956"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 08:31:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="581633143"
X-IronPort-AV: E=Sophos;i="5.95,202,1661842800"; 
   d="scan'208";a="581633143"
Received: from bswcg005.iind.intel.com ([10.224.174.25])
  by orsmga003.jf.intel.com with ESMTP; 21 Oct 2022 08:31:24 -0700
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com, linuxwwan_5g@intel.com,
        Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH V4 net-next 2/2] net: wwan: t7xx: Add port for modem logging
Date:   Sat, 22 Oct 2022 02:29:17 +0530
Message-Id: <20221021205917.1764666-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

The Modem Logging (MDL) port provides an interface to collect modem
logs for debugging purposes. MDL is supported by the relay interface,
and the mtk_t7xx port infrastructure. MDL allows user-space apps to
control logging via mbim command and to collect logs via the relay
interface, while port infrastructure facilitates communication between
the driver and the modem.

Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
Acked-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
--
v4:
 * Drop debugfs members in t7xx_port.
 * Use local var for debugfs_wwan_dir reference.
 * Move driver debugfs_dir var to t7xx_pci_dev.
 * wwan kconfig change.
v3:
 * Return if wwan_get_debugfs_dir() returns error.
v2
 * Removed debugfs control port.
 * Initialize in Notify function upon handshake completion.
 * Remove trace write function, MBIM will send commands.
---
 drivers/net/wwan/Kconfig                |   1 +
 drivers/net/wwan/t7xx/Makefile          |   3 +
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c  |   2 +
 drivers/net/wwan/t7xx/t7xx_pci.h        |   3 +
 drivers/net/wwan/t7xx/t7xx_port.h       |   3 +
 drivers/net/wwan/t7xx/t7xx_port_proxy.c |  12 +++
 drivers/net/wwan/t7xx/t7xx_port_proxy.h |   4 +
 drivers/net/wwan/t7xx/t7xx_port_trace.c | 116 ++++++++++++++++++++++++
 8 files changed, 144 insertions(+)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_trace.c

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 3486ffe94ac4..32149029c891 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -108,6 +108,7 @@ config IOSM
 config MTK_T7XX
 	tristate "MediaTek PCIe 5G WWAN modem T7xx device"
 	depends on PCI
+	select RELAY if WWAN_DEBUGFS
 	help
 	  Enables MediaTek PCIe based 5G WWAN modem (T7xx series) device.
 	  Adapts WWAN framework and provides network interface like wwan0
diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index dc6a7d682c15..268ff9e87e5b 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -18,3 +18,6 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_hif_dpmaif_rx.o  \
 		t7xx_dpmaif.o \
 		t7xx_netdev.o
+
+mtk_t7xx-$(CONFIG_WWAN_DEBUGFS) += \
+		t7xx_port_trace.o \
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index 6ff30cb8eb16..aec3a18d44bd 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -1018,6 +1018,8 @@ static int t7xx_cldma_late_init(struct cldma_ctrl *md_ctrl)
 			dev_err(md_ctrl->dev, "control TX ring init fail\n");
 			goto err_free_tx_ring;
 		}
+
+		md_ctrl->tx_ring[i].pkt_size = CLDMA_MTU;
 	}
 
 	for (j = 0; j < CLDMA_RXQ_NUM; j++) {
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.h b/drivers/net/wwan/t7xx/t7xx_pci.h
index 50b37056ce5a..112efa534eac 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.h
+++ b/drivers/net/wwan/t7xx/t7xx_pci.h
@@ -78,6 +78,9 @@ struct t7xx_pci_dev {
 	spinlock_t		md_pm_lock;		/* Protects PCI resource lock */
 	unsigned int		sleep_disable_count;
 	struct completion	sleep_lock_acquire;
+#ifdef CONFIG_WWAN_DEBUGFS
+	struct dentry		*debugfs_dir;
+#endif
 };
 
 enum t7xx_pm_id {
diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
index fbc6d724b7c2..8ea9079af997 100644
--- a/drivers/net/wwan/t7xx/t7xx_port.h
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -125,6 +125,9 @@ struct t7xx_port {
 		struct {
 			struct wwan_port		*wwan_port;
 		} wwan;
+		struct {
+			struct rchan			*relaych;
+		} log;
 	};
 };
 
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
index d4de047ff0d4..894b1d11b2c9 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -70,6 +70,18 @@ static const struct t7xx_port_conf t7xx_md_port_conf[] = {
 		.name = "MBIM",
 		.port_type = WWAN_PORT_MBIM,
 	}, {
+#ifdef CONFIG_WWAN_DEBUGFS
+		.tx_ch = PORT_CH_MD_LOG_TX,
+		.rx_ch = PORT_CH_MD_LOG_RX,
+		.txq_index = 7,
+		.rxq_index = 7,
+		.txq_exp_index = 7,
+		.rxq_exp_index = 7,
+		.path_id = CLDMA_ID_MD,
+		.ops = &t7xx_trace_port_ops,
+		.name = "mdlog",
+	}, {
+#endif
 		.tx_ch = PORT_CH_CONTROL_TX,
 		.rx_ch = PORT_CH_CONTROL_RX,
 		.txq_index = Q_IDX_CTRL,
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
index bc1ff5c6c700..81d059fbc0fb 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -87,6 +87,10 @@ struct ctrl_msg_header {
 extern struct port_ops wwan_sub_port_ops;
 extern struct port_ops ctl_port_ops;
 
+#ifdef CONFIG_WWAN_DEBUGFS
+extern struct port_ops t7xx_trace_port_ops;
+#endif
+
 void t7xx_port_proxy_reset(struct port_proxy *port_prox);
 void t7xx_port_proxy_uninit(struct port_proxy *port_prox);
 int t7xx_port_proxy_init(struct t7xx_modem *md);
diff --git a/drivers/net/wwan/t7xx/t7xx_port_trace.c b/drivers/net/wwan/t7xx/t7xx_port_trace.c
new file mode 100644
index 000000000000..6a3f36385865
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_trace.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Intel Corporation.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/relay.h>
+#include <linux/skbuff.h>
+#include <linux/wwan.h>
+
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_state_monitor.h"
+
+#define T7XX_TRC_SUB_BUFF_SIZE		131072
+#define T7XX_TRC_N_SUB_BUFF		32
+
+static struct dentry *t7xx_trace_create_buf_file_handler(const char *filename,
+							 struct dentry *parent,
+							 umode_t mode,
+							 struct rchan_buf *buf,
+							 int *is_global)
+{
+	*is_global = 1;
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+static int t7xx_trace_remove_buf_file_handler(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+	return 0;
+}
+
+static int t7xx_trace_subbuf_start_handler(struct rchan_buf *buf, void *subbuf,
+					   void *prev_subbuf, size_t prev_padding)
+{
+	if (relay_buf_full(buf)) {
+		pr_err_ratelimited("Relay_buf full dropping traces");
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct rchan_callbacks relay_callbacks = {
+	.subbuf_start = t7xx_trace_subbuf_start_handler,
+	.create_buf_file = t7xx_trace_create_buf_file_handler,
+	.remove_buf_file = t7xx_trace_remove_buf_file_handler,
+};
+
+static void t7xx_trace_port_uninit(struct t7xx_port *port)
+{
+	struct dentry *debugfs_dir = port->t7xx_dev->debugfs_dir;
+	struct rchan *relaych = port->log.relaych;
+
+	if (!relaych)
+		return;
+
+	relay_close(relaych);
+	debugfs_remove_recursive(debugfs_dir);
+}
+
+static int t7xx_trace_port_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	struct rchan *relaych = port->log.relaych;
+
+	if (!relaych)
+		return -EINVAL;
+
+	relay_write(relaych, skb->data, skb->len);
+	dev_kfree_skb(skb);
+	return 0;
+}
+
+static void t7xx_port_trace_md_state_notify(struct t7xx_port *port, unsigned int state)
+{
+	struct rchan *relaych = port->log.relaych;
+	struct dentry *debugfs_wwan_dir;
+	struct dentry *debugfs_dir;
+
+	if (state != MD_STATE_READY || relaych)
+		return;
+
+	debugfs_wwan_dir = wwan_get_debugfs_dir(port->dev);
+	if (IS_ERR(debugfs_wwan_dir))
+		return;
+
+	debugfs_dir = debugfs_create_dir(KBUILD_MODNAME, debugfs_wwan_dir);
+	if (IS_ERR_OR_NULL(debugfs_dir)) {
+		wwan_put_debugfs_dir(debugfs_wwan_dir);
+		dev_err(port->dev, "Unable to create debugfs for trace");
+		return;
+	}
+
+	relaych = relay_open("relay_ch", debugfs_dir, T7XX_TRC_SUB_BUFF_SIZE,
+			     T7XX_TRC_N_SUB_BUFF, &relay_callbacks, NULL);
+	if (!relaych)
+		goto err_rm_debugfs_dir;
+
+	wwan_put_debugfs_dir(debugfs_wwan_dir);
+	port->log.relaych = relaych;
+	port->t7xx_dev->debugfs_dir = debugfs_dir;
+	return;
+
+err_rm_debugfs_dir:
+	debugfs_remove_recursive(debugfs_dir);
+	wwan_put_debugfs_dir(debugfs_wwan_dir);
+	dev_err(port->dev, "Unable to create trace port %s", port->port_conf->name);
+}
+
+struct port_ops t7xx_trace_port_ops = {
+	.recv_skb = t7xx_trace_port_recv_skb,
+	.uninit = t7xx_trace_port_uninit,
+	.md_state_notify = t7xx_port_trace_md_state_notify,
+};
-- 
2.34.1

