Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC9A4C1EAA
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244221AbiBWWf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244228AbiBWWfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:35:47 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B077650E18;
        Wed, 23 Feb 2022 14:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645655715; x=1677191715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=IVgj6KUU7RxGy5Jm1SLV80O8YA4aPErblNZ2yskhhAw=;
  b=kI2GsOLr11cp0BknVyG3LtSE14prJhDYuedwXfHLAa5u4fxaiVU1ZzG1
   YyN0McOs/fNpKH2OoxZpnWhyX6eAEqCmjwveeOQOdbS6ToIzVDPxiN/xd
   rHyzerYhEjXZkMi8v+BPqcIM5k0pvrjG0iUiwLfWsVqYVt/j5dWb1yot5
   60O/9zcSP4wWTt54+cQ6eZcloqiQ1+8OMYDj/5qS13PwaJ2SYATxgazYZ
   JOF2zWSizvsdCzBn8YNhDjYK01y+u/Zm87ZlbH4qKFw6XNMtG3uzRZ/QC
   4EQ4P2Db7SW4Lo/wUKV6kaxN0ONbfzqht4NsgdKscbXg2Hk6gy9G1Cw7n
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="312812433"
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="312812433"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 14:35:11 -0800
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="628252242"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 14:35:10 -0800
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v5 06/13] net: wwan: t7xx: Add AT and MBIM WWAN ports
Date:   Wed, 23 Feb 2022 15:33:19 -0700
Message-Id: <20220223223326.28021-7-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

Adds AT and MBIM ports to the port proxy infrastructure.
The initialization method is responsible for creating the corresponding
ports using the WWAN framework infrastructure. The implemented WWAN port
operations are start, stop, and TX.

Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>

From a WWAN framework perspective:
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/t7xx/Makefile          |   1 +
 drivers/net/wwan/t7xx/t7xx_port_proxy.c |  24 +++
 drivers/net/wwan/t7xx/t7xx_port_proxy.h |   1 +
 drivers/net/wwan/t7xx/t7xx_port_wwan.c  | 210 ++++++++++++++++++++++++
 4 files changed, 236 insertions(+)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_wwan.c

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index 63e1c67b82b5..9eec2e2472fb 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -12,3 +12,4 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_hif_cldma.o  \
 		t7xx_port_proxy.o  \
 		t7xx_port_ctrl_msg.o \
+		t7xx_port_wwan.o \
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
index 256442a60cc2..9a5cc64904d3 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -51,6 +51,30 @@
 
 static struct t7xx_port_static t7xx_md_ports[] = {
 	{
+		.tx_ch = PORT_CH_UART2_TX,
+		.rx_ch = PORT_CH_UART2_RX,
+		.txq_index = Q_IDX_AT_CMD,
+		.rxq_index = Q_IDX_AT_CMD,
+		.txq_exp_index = 0xff,
+		.rxq_exp_index = 0xff,
+		.path_id = CLDMA_ID_MD,
+		.flags = 0,
+		.ops = &wwan_sub_port_ops,
+		.name = "AT",
+		.port_type = WWAN_PORT_AT,
+	}, {
+		.tx_ch = PORT_CH_MBIM_TX,
+		.rx_ch = PORT_CH_MBIM_RX,
+		.txq_index = Q_IDX_MBIM,
+		.rxq_index = Q_IDX_MBIM,
+		.txq_exp_index = 0,
+		.rxq_exp_index = 0,
+		.path_id = CLDMA_ID_MD,
+		.flags = 0,
+		.ops = &wwan_sub_port_ops,
+		.name = "MBIM",
+		.port_type = WWAN_PORT_MBIM,
+	}, {
 		.tx_ch = PORT_CH_CONTROL_TX,
 		.rx_ch = PORT_CH_CONTROL_RX,
 		.txq_index = Q_IDX_CTRL,
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
index b23750f78d55..1c9608987728 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -80,6 +80,7 @@ struct port_msg {
 #define PORT_ENUM_VER_MISMATCH	0x00657272
 
 /* Port operations mapping */
+extern struct port_ops wwan_sub_port_ops;
 extern struct port_ops ctl_port_ops;
 
 int t7xx_port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb);
diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
new file mode 100644
index 000000000000..ac9144021431
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021-2022, Intel Corporation.
+ *
+ * Authors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#include <linux/atomic.h>
+#include <linux/bitfield.h>
+#include <linux/dev_printk.h>
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/minmax.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/wwan.h>
+
+#include "t7xx_common.h"
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_state_monitor.h"
+
+#define CCCI_HEADROOM		128
+
+static int t7xx_port_ctrl_start(struct wwan_port *port)
+{
+	struct t7xx_port *port_mtk = wwan_port_get_drvdata(port);
+
+	if (atomic_read(&port_mtk->usage_cnt))
+		return -EBUSY;
+
+	atomic_inc(&port_mtk->usage_cnt);
+	return 0;
+}
+
+static void t7xx_port_ctrl_stop(struct wwan_port *port)
+{
+	struct t7xx_port *port_mtk = wwan_port_get_drvdata(port);
+
+	atomic_dec(&port_mtk->usage_cnt);
+}
+
+static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
+{
+	struct t7xx_port *port_private = wwan_port_get_drvdata(port);
+	size_t actual_len, alloc_size, txq_mtu = CLDMA_MTU;
+	struct t7xx_port_static *port_static;
+	unsigned int len, i, packets;
+	struct t7xx_fsm_ctl *ctl;
+	enum md_state md_state;
+
+	len = skb->len;
+	if (!len || !port_private->rx_length_th || !port_private->chan_enable)
+		return -EINVAL;
+
+	port_static = port_private->port_static;
+	ctl = port_private->t7xx_dev->md->fsm_ctl;
+	md_state = t7xx_fsm_get_md_state(ctl);
+	if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2) {
+		dev_warn(port_private->dev, "Cannot write to %s port when md_state=%d\n",
+			 port_static->name, md_state);
+		return -ENODEV;
+	}
+
+	alloc_size = min_t(size_t, txq_mtu, len + CCCI_HEADROOM);
+	actual_len = alloc_size - CCCI_HEADROOM;
+	packets = DIV_ROUND_UP(len, txq_mtu - CCCI_HEADROOM);
+
+	for (i = 0; i < packets; i++) {
+		struct ccci_header *ccci_h;
+		struct sk_buff *skb_ccci;
+		int ret;
+
+		if (packets > 1 && packets == i + 1) {
+			actual_len = len % (txq_mtu - CCCI_HEADROOM);
+			alloc_size = actual_len + CCCI_HEADROOM;
+		}
+
+		skb_ccci = __dev_alloc_skb(alloc_size, GFP_KERNEL);
+		if (!skb_ccci)
+			return -ENOMEM;
+
+		ccci_h = skb_put(skb_ccci, sizeof(*ccci_h));
+		t7xx_ccci_header_init(ccci_h, 0, actual_len + sizeof(*ccci_h),
+				      port_static->tx_ch, 0);
+		skb_put_data(skb_ccci, skb->data + i * (txq_mtu - CCCI_HEADROOM), actual_len);
+		t7xx_port_proxy_set_tx_seq_num(port_private, ccci_h);
+
+		ret = t7xx_port_send_skb_to_md(port_private, skb_ccci);
+		if (ret) {
+			dev_kfree_skb_any(skb_ccci);
+			dev_err(port_private->dev, "Write error on %s port, %d\n",
+				port_static->name, ret);
+			return ret;
+		}
+
+		port_private->seq_nums[MTK_TX]++;
+	}
+
+	dev_kfree_skb(skb);
+	return 0;
+}
+
+static const struct wwan_port_ops wwan_ops = {
+	.start = t7xx_port_ctrl_start,
+	.stop = t7xx_port_ctrl_stop,
+	.tx = t7xx_port_ctrl_tx,
+};
+
+static int t7xx_port_wwan_init(struct t7xx_port *port)
+{
+	struct t7xx_port_static *port_static = port->port_static;
+
+	port->rx_length_th = RX_QUEUE_MAXLEN;
+	port->flags |= PORT_F_RX_ADJUST_HEADER;
+
+	if (port_static->rx_ch == PORT_CH_UART2_RX)
+		port->flags |= PORT_F_RX_CH_TRAFFIC;
+
+	if (!port->chan_enable)
+		port->flags |= PORT_F_RX_ALLOW_DROP;
+
+	return 0;
+}
+
+static void t7xx_port_wwan_uninit(struct t7xx_port *port)
+{
+	unsigned long flags;
+
+	if (!port->wwan_port)
+		return;
+
+	spin_lock_irqsave(&port->rx_wq.lock, flags);
+	port->rx_length_th = 0;
+	wwan_remove_port(port->wwan_port);
+	port->wwan_port = NULL;
+	spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+}
+
+static int t7xx_port_wwan_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	struct t7xx_port_static *port_static = port->port_static;
+
+	if (!atomic_read(&port->usage_cnt)) {
+		dev_kfree_skb_any(skb);
+		dev_err_ratelimited(port->dev, "Port %s is not opened, drop packets\n",
+				    port_static->name);
+		return 0;
+	}
+
+	return t7xx_port_recv_skb(port, skb);
+}
+
+static int t7xx_port_wwan_enable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = true;
+	port->flags &= ~PORT_F_RX_ALLOW_DROP;
+	spin_unlock(&port->port_update_lock);
+
+	return 0;
+}
+
+static int t7xx_port_wwan_disable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = false;
+	port->flags |= PORT_F_RX_ALLOW_DROP;
+	spin_unlock(&port->port_update_lock);
+
+	return 0;
+}
+
+static void t7xx_port_wwan_md_state_notify(struct t7xx_port *port, unsigned int state)
+{
+	struct t7xx_port_static *port_static = port->port_static;
+
+	if (state != MD_STATE_READY)
+		return;
+
+	if (!port->wwan_port) {
+		port->wwan_port = wwan_create_port(port->dev, port_static->port_type,
+						   &wwan_ops, port);
+		if (IS_ERR(port->wwan_port))
+			dev_err(port->dev, "Unable to create WWWAN port %s", port_static->name);
+	}
+}
+
+struct port_ops wwan_sub_port_ops = {
+	.init = t7xx_port_wwan_init,
+	.recv_skb = t7xx_port_wwan_recv_skb,
+	.uninit = t7xx_port_wwan_uninit,
+	.enable_chl = t7xx_port_wwan_enable_chl,
+	.disable_chl = t7xx_port_wwan_disable_chl,
+	.md_state_notify = t7xx_port_wwan_md_state_notify,
+};
-- 
2.17.1

