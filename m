Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E034A5F2800
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 06:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiJCE3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 00:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJCE3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 00:29:12 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDA432AB6
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 21:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664771351; x=1696307351;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Qwe0fSzONSq9hGEik6qNKU/qcJpQ5RGaBSXyky4FMKk=;
  b=UWPc9hSdCB20Tm11JREJqCDlyiFbZJWu3je8elgWo7m4I9y4bf/dPfPs
   6giNQ2qy4NTHdr4zTbPX/lUlx7tvWu9+ytRAPBZWSjUQ4WRo6pxICLiBt
   T7UkvKNNfCROvkbldgq+0Vz+xc3Da3wL1Y2tJWTAPqU25Edg1Kh0MqKAu
   Ag1wm+lxZm5dFEwxXwg7CYJMgDaf8xgVahLVMnfVUuupXVG/TEhV3zjke
   mYfSfVMyGZjPtxdiMO0/5YLL6SXOfyqfwB/hAdudzdo95S7ozZ0Fc6Xcc
   8HgMiIj/WUvUBBFGkgxJJktaoTdRysVIIaTiEYfDMjVGVlrPCFzE2esid
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="289706820"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="289706820"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 21:29:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="574496199"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="574496199"
Received: from bswcg005.iind.intel.com ([10.224.174.25])
  by orsmga003.jf.intel.com with ESMTP; 02 Oct 2022 21:29:06 -0700
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com, Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH V3 net-next] net: wwan: t7xx: Add port for modem logging
Date:   Mon,  3 Oct 2022 15:27:25 +0530
Message-Id: <20221003095725.978129-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moises Veleta <moises.veleta@linux.intel.com>

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
 drivers/net/wwan/t7xx/t7xx_port.h       |   5 ++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c |  12 +++
 drivers/net/wwan/t7xx/t7xx_port_proxy.h |   4 +
 drivers/net/wwan/t7xx/t7xx_port_trace.c | 112 ++++++++++++++++++++++++
 7 files changed, 139 insertions(+)
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
diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
index dc4133eb433a..702e7aa2ef31 100644
--- a/drivers/net/wwan/t7xx/t7xx_port.h
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -122,6 +122,11 @@ struct t7xx_port {
 	int				rx_length_th;
 	bool				chan_enable;
 	struct task_struct		*thread;
+#ifdef CONFIG_WWAN_DEBUGFS
+	void				*relaych;
+	struct dentry			*debugfs_dir;
+	struct dentry			*debugfs_wwan_dir;
+#endif
 };
 
 struct sk_buff *t7xx_port_alloc_skb(int payload);
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
index 000000000000..3f740db318a8
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_trace.c
@@ -0,0 +1,112 @@
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
+	struct rchan *relaych = port->relaych;
+
+	if (!relaych)
+		return;
+
+	relay_close(relaych);
+	debugfs_remove_recursive(port->debugfs_dir);
+	wwan_put_debugfs_dir(port->debugfs_wwan_dir);
+}
+
+static int t7xx_trace_port_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	struct rchan *relaych = port->relaych;
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
+	struct rchan *relaych;
+
+	if (state != MD_STATE_READY || port->relaych)
+		return;
+
+	port->debugfs_wwan_dir = wwan_get_debugfs_dir(port->dev);
+	if (IS_ERR(port->debugfs_wwan_dir))
+		return;
+
+	port->debugfs_dir = debugfs_create_dir(KBUILD_MODNAME, port->debugfs_wwan_dir);
+	if (IS_ERR_OR_NULL(port->debugfs_dir)) {
+		wwan_put_debugfs_dir(port->debugfs_wwan_dir);
+		dev_err(port->dev, "Unable to create debugfs for trace");
+		return;
+	}
+
+	relaych = relay_open("relay_ch", port->debugfs_dir, T7XX_TRC_SUB_BUFF_SIZE,
+			     T7XX_TRC_N_SUB_BUFF, &relay_callbacks, NULL);
+	if (!relaych)
+		goto err_rm_debugfs_dir;
+
+	port->relaych = relaych;
+	return;
+
+err_rm_debugfs_dir:
+	debugfs_remove_recursive(port->debugfs_dir);
+	wwan_put_debugfs_dir(port->debugfs_wwan_dir);
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

