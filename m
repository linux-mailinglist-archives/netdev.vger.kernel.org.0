Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978BA4F8B5F
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiDGWjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiDGWjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:39:20 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7E7129E95;
        Thu,  7 Apr 2022 15:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649371035; x=1680907035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=nnyXQjrQz2FNaSuxMWKy5EGNAG4f67nTFZt9PRCt3eQ=;
  b=LVIoc4Kr0HNJfR+qjlrCoQ+sgr3LLa0SLvscvbm4BpOSE8s0vJP4T6KB
   WAYJ8YqqSxmVfvYyuXXBRQlCNXWCg4GijehJcun8Zs0/knxwIZNZRsgT9
   R1DLJJ4AnaZzhF0iHYUGD3OEtFZFrlE1kerFqjqi11QedJiIAsDOHjOI6
   xCvWVdXELWjCHlFAfvefG+atGmZiek68zrwwSrsU6vAFhIO3JRgqPvl+u
   FfLcZI+tfSItmaswXVtQ90ec/JxSWYydRWHCPhe15w3Y4m8rgDaQkwAWM
   oTbDe9QKlBsHRt2DzqA0bky08v5Baw9OzVfHkx+l423WQkhVKmsqXNk1N
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261449310"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="261449310"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 15:37:11 -0700
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="659242880"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 15:37:11 -0700
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
Subject: [PATCH net-next v6 04/13] net: wwan: t7xx: Add port proxy infrastructure
Date:   Thu,  7 Apr 2022 15:36:20 -0700
Message-Id: <20220407223629.21487-5-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haijun Liu <haijun.liu@mediatek.com>

Port-proxy provides a common interface to interact with different types
of ports. Ports export their configuration via `struct t7xx_port` and
operate as defined by `struct port_ops`.

Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>

From a WWAN framework perspective:
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/t7xx/Makefile             |   1 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     |  14 +-
 drivers/net/wwan/t7xx/t7xx_port.h          | 136 +++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 449 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |  72 ++++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c |   5 +
 6 files changed, 676 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.h

diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index 6a49013bc343..99f9ca3b4b51 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -10,3 +10,4 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_modem_ops.o \
 		t7xx_cldma.o \
 		t7xx_hif_cldma.o  \
+		t7xx_port_proxy.o  \
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
index 30292e3f1c37..d1d3384608be 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -34,6 +34,8 @@
 #include "t7xx_modem_ops.h"
 #include "t7xx_pci.h"
 #include "t7xx_pcie_mac.h"
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
 #include "t7xx_reg.h"
 #include "t7xx_state_monitor.h"
 
@@ -273,6 +275,7 @@ static void t7xx_md_exception(struct t7xx_modem *md, enum hif_ex_stage stage)
 	if (stage == HIF_EX_CLEARQ_DONE) {
 		/* Give DHL time to flush data */
 		msleep(PORT_RESET_DELAY_MS);
+		t7xx_port_proxy_reset(md->port_prox);
 	}
 
 	t7xx_cldma_exception(md->md_ctrl[CLDMA_ID_MD], stage);
@@ -426,6 +429,7 @@ int t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev)
 	md->exp_id = 0;
 	t7xx_fsm_reset(md);
 	t7xx_cldma_reset(md->md_ctrl[CLDMA_ID_MD]);
+	t7xx_port_proxy_reset(md->port_prox);
 	md->md_init_finish = true;
 	return 0;
 }
@@ -462,14 +466,21 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
 	if (ret)
 		goto err_uninit_fsm;
 
+	ret = t7xx_port_proxy_init(md);
+	if (ret)
+		goto err_uninit_md_cldma;
+
 	ret = t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_START, 0);
 	if (ret) /* fsm_uninit flushes cmd queue */
-		goto err_uninit_md_cldma;
+		goto err_uninit_proxy;
 
 	t7xx_md_sys_sw_init(t7xx_dev);
 	md->md_init_finish = true;
 	return 0;
 
+err_uninit_proxy:
+	t7xx_port_proxy_uninit(md->port_prox);
+
 err_uninit_md_cldma:
 	t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_MD]);
 
@@ -492,6 +503,7 @@ void t7xx_md_exit(struct t7xx_pci_dev *t7xx_dev)
 		return;
 
 	t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_PRE_STOP, FSM_CMD_FLAG_WAIT_FOR_COMPLETION);
+	t7xx_port_proxy_uninit(md->port_prox);
 	t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_MD]);
 	t7xx_fsm_uninit(md);
 	destroy_workqueue(md->handshake_wq);
diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
new file mode 100644
index 000000000000..3abf092bcd88
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -0,0 +1,136 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021-2022, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez <ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ */
+
+#ifndef __T7XX_PORT_H__
+#define __T7XX_PORT_H__
+
+#include <linux/bits.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/wwan.h>
+
+#include "t7xx_hif_cldma.h"
+#include "t7xx_pci.h"
+
+/* Reused for net TX, Data queue, same bit as RX_FULLED */
+#define PORT_F_TX_DATA_FULLED	BIT(1)
+#define PORT_F_TX_ACK_FULLED	BIT(8)
+
+#define PORT_CH_ID_MASK		GENMASK(7, 0)
+
+/* Channel ID and Message ID definitions.
+ * The channel number consists of peer_id(15:12) , channel_id(11:0)
+ * peer_id:
+ * 0:reserved, 1: to sAP, 2: to MD
+ */
+enum port_ch {
+	/* to MD */
+	PORT_CH_CONTROL_RX = 0x2000,
+	PORT_CH_CONTROL_TX = 0x2001,
+	PORT_CH_UART1_RX = 0x2006,	/* META */
+	PORT_CH_UART1_TX = 0x2008,
+	PORT_CH_UART2_RX = 0x200a,	/* AT */
+	PORT_CH_UART2_TX = 0x200c,
+	PORT_CH_MD_LOG_RX = 0x202a,	/* MD logging */
+	PORT_CH_MD_LOG_TX = 0x202b,
+	PORT_CH_LB_IT_RX = 0x203e,	/* Loop back test */
+	PORT_CH_LB_IT_TX = 0x203f,
+	PORT_CH_STATUS_RX = 0x2043,	/* Status events */
+	PORT_CH_MIPC_RX = 0x20ce,	/* MIPC */
+	PORT_CH_MIPC_TX = 0x20cf,
+	PORT_CH_MBIM_RX = 0x20d0,
+	PORT_CH_MBIM_TX = 0x20d1,
+	PORT_CH_DSS0_RX = 0x20d2,
+	PORT_CH_DSS0_TX = 0x20d3,
+	PORT_CH_DSS1_RX = 0x20d4,
+	PORT_CH_DSS1_TX = 0x20d5,
+	PORT_CH_DSS2_RX = 0x20d6,
+	PORT_CH_DSS2_TX = 0x20d7,
+	PORT_CH_DSS3_RX = 0x20d8,
+	PORT_CH_DSS3_TX = 0x20d9,
+	PORT_CH_DSS4_RX = 0x20da,
+	PORT_CH_DSS4_TX = 0x20db,
+	PORT_CH_DSS5_RX = 0x20dc,
+	PORT_CH_DSS5_TX = 0x20dd,
+	PORT_CH_DSS6_RX = 0x20de,
+	PORT_CH_DSS6_TX = 0x20df,
+	PORT_CH_DSS7_RX = 0x20e0,
+	PORT_CH_DSS7_TX = 0x20e1,
+};
+
+struct t7xx_port;
+struct port_ops {
+	int (*init)(struct t7xx_port *port);
+	int (*recv_skb)(struct t7xx_port *port, struct sk_buff *skb);
+	void (*md_state_notify)(struct t7xx_port *port, unsigned int md_state);
+	void (*uninit)(struct t7xx_port *port);
+	int (*enable_chl)(struct t7xx_port *port);
+	int (*disable_chl)(struct t7xx_port *port);
+};
+
+struct t7xx_port_conf {
+	enum port_ch		tx_ch;
+	enum port_ch		rx_ch;
+	unsigned char		txq_index;
+	unsigned char		rxq_index;
+	unsigned char		txq_exp_index;
+	unsigned char		rxq_exp_index;
+	enum cldma_id		path_id;
+	struct port_ops		*ops;
+	char			*name;
+	enum wwan_port_type	port_type;
+};
+
+struct t7xx_port {
+	/* Members not initialized in definition */
+	struct t7xx_port_conf	*port_conf;
+	struct wwan_port	*wwan_port;
+	struct t7xx_pci_dev	*t7xx_dev;
+	struct device		*dev;
+	u16			seq_nums[2];	/* TX/RX sequence numbers */
+	atomic_t		usage_cnt;
+	struct			list_head entry;
+	struct			list_head queue_entry;
+	/* TX and RX flows are asymmetric since ports are multiplexed on
+	 * queues.
+	 *
+	 * TX: data blocks are sent directly to a queue. Each port
+	 * does not maintain a TX list; instead, they only provide
+	 * a wait_queue_head for blocking writes.
+	 *
+	 * RX: Each port uses a RX list to hold packets,
+	 * allowing the modem to dispatch RX packet as quickly as possible.
+	 */
+	struct sk_buff_head	rx_skb_list;
+	spinlock_t		port_update_lock; /* Protects port configuration */
+	wait_queue_head_t	rx_wq;
+	int			rx_length_th;
+	bool			chan_enable;
+	struct task_struct	*thread;
+};
+
+struct sk_buff *t7xx_port_alloc_skb(int payload);
+int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb);
+int t7xx_port_send_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int pkt_header,
+		       unsigned int ex_msg);
+
+#endif /* __T7XX_PORT_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
new file mode 100644
index 000000000000..8d813b0c144d
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -0,0 +1,449 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021-2022, Intel Corporation.
+ *
+ * Authors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez <ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#include <linux/bits.h>
+#include <linux/bitfield.h>
+#include <linux/device.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/wwan.h>
+
+#include "t7xx_hif_cldma.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_port.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_state_monitor.h"
+
+#define Q_IDX_CTRL			0
+#define Q_IDX_MBIM			2
+#define Q_IDX_AT_CMD			5
+
+#define INVALID_SEQ_NUM			GENMASK(15, 0)
+
+#define for_each_proxy_port(i, p, proxy)	\
+	for (i = 0, (p) = &(proxy)->ports[i];	\
+	     i < (proxy)->port_number;		\
+	     i++, (p) = &(proxy)->ports[i])
+
+static struct t7xx_port_conf t7xx_md_port_conf[] = {};
+
+static struct t7xx_port *t7xx_proxy_get_port_by_ch(struct port_proxy *port_prox, enum port_ch ch)
+{
+	struct t7xx_port_conf *port_conf;
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox) {
+		port_conf = port->port_conf;
+		if (port_conf->rx_ch == ch || port_conf->tx_ch == ch)
+			return port;
+	}
+
+	return NULL;
+}
+
+static u16 t7xx_port_next_rx_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h)
+{
+	u16 seq_num, next_seq_num;
+	bool assert_bit;
+
+	seq_num = FIELD_GET(CCCI_H_SEQ_FLD, le32_to_cpu(ccci_h->status));
+	next_seq_num = (seq_num + 1) & FIELD_MAX(CCCI_H_SEQ_FLD);
+	assert_bit = !!(le32_to_cpu(ccci_h->status) & CCCI_H_AST_BIT);
+	if (!assert_bit || port->seq_nums[MTK_RX] == INVALID_SEQ_NUM)
+		return next_seq_num;
+
+	if (seq_num != port->seq_nums[MTK_RX])
+		dev_warn_ratelimited(port->dev,
+				     "seq num out-of-order %u != %u (header %X, len %X)\n",
+				     seq_num, port->seq_nums[MTK_RX],
+				     le32_to_cpu(ccci_h->packet_header),
+				     le32_to_cpu(ccci_h->packet_len));
+
+	return next_seq_num;
+}
+
+void t7xx_port_proxy_reset(struct port_proxy *port_prox)
+{
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox) {
+		port->seq_nums[MTK_RX] = INVALID_SEQ_NUM;
+		port->seq_nums[MTK_TX] = 0;
+	}
+}
+
+static int t7xx_port_get_queue_no(struct t7xx_port *port)
+{
+	struct t7xx_port_conf *port_conf = port->port_conf;
+	struct t7xx_fsm_ctl *ctl = port->t7xx_dev->md->fsm_ctl;
+
+	return t7xx_fsm_get_md_state(ctl) == MD_STATE_EXCEPTION ?
+		port_conf->txq_exp_index : port_conf->txq_index;
+}
+
+static void t7xx_port_struct_init(struct t7xx_port *port)
+{
+	INIT_LIST_HEAD(&port->entry);
+	INIT_LIST_HEAD(&port->queue_entry);
+	skb_queue_head_init(&port->rx_skb_list);
+	init_waitqueue_head(&port->rx_wq);
+	port->seq_nums[MTK_RX] = INVALID_SEQ_NUM;
+	port->seq_nums[MTK_TX] = 0;
+	atomic_set(&port->usage_cnt, 0);
+}
+
+struct sk_buff *t7xx_port_alloc_skb(int payload)
+{
+	struct sk_buff *skb = __dev_alloc_skb(payload + sizeof(struct ccci_header), GFP_KERNEL);
+
+	if (skb)
+		skb_reserve(skb, sizeof(struct ccci_header));
+
+	return skb;
+}
+
+/**
+ * t7xx_port_enqueue_skb() - Enqueue the received skb into the port's rx_skb_list.
+ * @port: port context.
+ * @skb: received skb.
+ *
+ * Return:
+ * * 0		- Success.
+ * * -ENOBUFS	- Not enough buffer space.
+ */
+int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->rx_wq.lock, flags);
+	if (port->rx_skb_list.qlen >= port->rx_length_th) {
+		spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+
+		return -ENOBUFS;
+	}
+	__skb_queue_tail(&port->rx_skb_list, skb);
+	spin_unlock_irqrestore(&port->rx_wq.lock, flags);
+
+	wake_up_all(&port->rx_wq);
+	return 0;
+}
+
+static int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff *skb)
+{
+	enum cldma_id path_id = port->port_conf->path_id;
+	struct cldma_ctrl *md_ctrl;
+	int ret, tx_qno;
+
+	md_ctrl = port->t7xx_dev->md->md_ctrl[path_id];
+	tx_qno = t7xx_port_get_queue_no(port);
+	ret = t7xx_cldma_send_skb(md_ctrl, tx_qno, skb);
+	if (ret)
+		dev_err(port->dev, "Failed to send skb: %d\n", ret);
+
+	return ret;
+}
+
+static int t7xx_port_send_ccci_skb(struct t7xx_port *port, struct sk_buff *skb,
+				   unsigned int pkt_header, unsigned int ex_msg)
+{
+	struct t7xx_port_conf *port_conf = port->port_conf;
+	struct ccci_header *ccci_h;
+	u32 status;
+	int ret;
+
+	ccci_h = skb_push(skb, sizeof(*ccci_h));
+	status = FIELD_PREP(CCCI_H_CHN_FLD, port_conf->tx_ch) |
+		 FIELD_PREP(CCCI_H_SEQ_FLD, port->seq_nums[MTK_TX]) | CCCI_H_AST_BIT;
+	ccci_h->status = cpu_to_le32(status);
+	ccci_h->packet_header = cpu_to_le32(pkt_header);
+	ccci_h->packet_len = cpu_to_le32(skb->len);
+	ccci_h->ex_msg = cpu_to_le32(ex_msg);
+
+	ret = t7xx_port_send_raw_skb(port, skb);
+	if (ret)
+		return ret;
+
+	port->seq_nums[MTK_TX]++;
+	return 0;
+}
+
+int t7xx_port_send_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int pkt_header,
+		       unsigned int ex_msg)
+{
+	struct t7xx_fsm_ctl *ctl = port->t7xx_dev->md->fsm_ctl;
+	unsigned int fsm_state;
+
+	fsm_state = t7xx_fsm_get_ctl_state(ctl);
+	if (fsm_state != FSM_STATE_PRE_START) {
+		struct t7xx_port_conf *port_conf = port->port_conf;
+		enum md_state md_state = t7xx_fsm_get_md_state(ctl);
+
+		switch (md_state) {
+		case MD_STATE_EXCEPTION:
+			if (port_conf->tx_ch != PORT_CH_MD_LOG_TX)
+				return -EBUSY;
+			break;
+
+		case MD_STATE_WAITING_FOR_HS1:
+		case MD_STATE_WAITING_FOR_HS2:
+		case MD_STATE_STOPPED:
+		case MD_STATE_WAITING_TO_STOP:
+		case MD_STATE_INVALID:
+			return -ENODEV;
+
+		default:
+			break;
+		}
+	}
+
+	return t7xx_port_send_ccci_skb(port, skb, pkt_header, ex_msg);
+}
+
+static void t7xx_proxy_setup_ch_mapping(struct port_proxy *port_prox)
+{
+	struct t7xx_port *port;
+
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(port_prox->rx_ch_ports); i++)
+		INIT_LIST_HEAD(&port_prox->rx_ch_ports[i]);
+
+	for (j = 0; j < ARRAY_SIZE(port_prox->queue_ports); j++) {
+		for (i = 0; i < ARRAY_SIZE(port_prox->queue_ports[j]); i++)
+			INIT_LIST_HEAD(&port_prox->queue_ports[j][i]);
+	}
+
+	for_each_proxy_port(i, port, port_prox) {
+		struct t7xx_port_conf *port_conf = port->port_conf;
+		enum cldma_id path_id = port_conf->path_id;
+		u8 ch_id;
+
+		ch_id = FIELD_GET(PORT_CH_ID_MASK, port_conf->rx_ch);
+		list_add_tail(&port->entry, &port_prox->rx_ch_ports[ch_id]);
+		list_add_tail(&port->queue_entry,
+			      &port_prox->queue_ports[path_id][port_conf->rxq_index]);
+	}
+}
+
+static struct t7xx_port *t7xx_port_proxy_find_port(struct t7xx_pci_dev *t7xx_dev,
+						   struct cldma_queue *queue, u16 channel)
+{
+	struct port_proxy *port_prox = t7xx_dev->md->port_prox;
+	struct list_head *port_list;
+	struct t7xx_port *port;
+	u8 ch_id;
+
+	ch_id = FIELD_GET(PORT_CH_ID_MASK, channel);
+	port_list = &port_prox->rx_ch_ports[ch_id];
+	list_for_each_entry(port, port_list, entry) {
+		struct t7xx_port_conf *port_conf = port->port_conf;
+
+		if (queue->md_ctrl->hif_id == port_conf->path_id &&
+		    channel == port_conf->rx_ch)
+			return port;
+	}
+
+	return NULL;
+}
+
+/**
+ * t7xx_port_proxy_recv_skb() - Dispatch received skb.
+ * @queue: CLDMA queue.
+ * @skb: Socket buffer.
+ *
+ * Return:
+ ** 0		- Packet consumed.
+ ** -ERROR	- Failed to process skb.
+ */
+static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *skb)
+{
+	struct ccci_header *ccci_h = (struct ccci_header *)skb->data;
+	struct t7xx_pci_dev *t7xx_dev = queue->md_ctrl->t7xx_dev;
+	struct t7xx_fsm_ctl *ctl = t7xx_dev->md->fsm_ctl;
+	struct device *dev = queue->md_ctrl->dev;
+	struct t7xx_port_conf *port_conf;
+	struct t7xx_port *port;
+	u16 seq_num, channel;
+	int ret;
+
+	if (!skb)
+		return -EINVAL;
+
+	channel = FIELD_GET(CCCI_H_CHN_FLD, le32_to_cpu(ccci_h->status));
+	if (t7xx_fsm_get_md_state(ctl) == MD_STATE_INVALID) {
+		dev_err_ratelimited(dev, "Packet drop on channel 0x%x, modem not ready\n", channel);
+		goto drop_skb;
+	}
+
+	port = t7xx_port_proxy_find_port(t7xx_dev, queue, channel);
+	if (!port) {
+		dev_err_ratelimited(dev, "Packet drop on channel 0x%x, port not found\n", channel);
+		goto drop_skb;
+	}
+
+	seq_num = t7xx_port_next_rx_seq_num(port, ccci_h);
+	port_conf = port->port_conf;
+	skb_pull(skb, sizeof(*ccci_h));
+
+	ret = port_conf->ops->recv_skb(port, skb);
+	if (ret) {
+		skb_push(skb, sizeof(*ccci_h));
+		return ret;
+	}
+
+	port->seq_nums[MTK_RX] = seq_num;
+	return 0;
+
+drop_skb:
+	dev_kfree_skb_any(skb);
+	return 0;
+}
+
+/**
+ * t7xx_port_proxy_md_status_notify() - Notify all ports of state.
+ *@port_prox: The port_proxy pointer.
+ *@state: State.
+ *
+ * Called by t7xx_fsm. Used to dispatch modem status for all ports,
+ * which want to know MD state transition.
+ */
+void t7xx_port_proxy_md_status_notify(struct port_proxy *port_prox, unsigned int state)
+{
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox) {
+		struct t7xx_port_conf *port_conf = port->port_conf;
+
+		if (port_conf->ops->md_state_notify)
+			port_conf->ops->md_state_notify(port, state);
+	}
+}
+
+static void t7xx_proxy_init_all_ports(struct t7xx_modem *md)
+{
+	struct port_proxy *port_prox = md->port_prox;
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox) {
+		struct t7xx_port_conf *port_conf = port->port_conf;
+
+		t7xx_port_struct_init(port);
+
+		port->t7xx_dev = md->t7xx_dev;
+		port->dev = &md->t7xx_dev->pdev->dev;
+		spin_lock_init(&port->port_update_lock);
+		port->chan_enable = false;
+
+		if (port_conf->ops->init)
+			port_conf->ops->init(port);
+	}
+
+	t7xx_proxy_setup_ch_mapping(port_prox);
+}
+
+static int t7xx_proxy_alloc(struct t7xx_modem *md)
+{
+	unsigned int port_number = ARRAY_SIZE(t7xx_md_port_conf);
+	struct device *dev = &md->t7xx_dev->pdev->dev;
+	struct port_proxy *port_prox;
+	int i;
+
+	port_prox = devm_kzalloc(dev, sizeof(*port_prox) + sizeof(struct t7xx_port) * port_number,
+				 GFP_KERNEL);
+	if (!port_prox)
+		return -ENOMEM;
+
+	md->port_prox = port_prox;
+	port_prox->dev = dev;
+
+	for (i = 0; i < port_number; i++)
+		port_prox->ports[i].port_conf = &t7xx_md_port_conf[i];
+
+	port_prox->port_number = port_number;
+	t7xx_proxy_init_all_ports(md);
+	return 0;
+}
+
+/**
+ * t7xx_port_proxy_init() - Initialize ports.
+ * @md: Modem.
+ *
+ * Create all port instances.
+ *
+ * Return:
+ * * 0		- Success.
+ * * -ERROR	- Error code from failure sub-initializations.
+ */
+int t7xx_port_proxy_init(struct t7xx_modem *md)
+{
+	int ret;
+
+	ret = t7xx_proxy_alloc(md);
+	if (ret)
+		return ret;
+
+	t7xx_cldma_set_recv_skb(md->md_ctrl[CLDMA_ID_MD], t7xx_port_proxy_recv_skb);
+	return 0;
+}
+
+void t7xx_port_proxy_uninit(struct port_proxy *port_prox)
+{
+	struct t7xx_port *port;
+	int i;
+
+	for_each_proxy_port(i, port, port_prox) {
+		struct t7xx_port_conf *port_conf = port->port_conf;
+
+		if (port_conf->ops->uninit)
+			port_conf->ops->uninit(port);
+	}
+}
+
+int t7xx_port_proxy_chl_enable_disable(struct port_proxy *port_prox, unsigned int ch_id,
+				       bool en_flag)
+{
+	struct t7xx_port *port = t7xx_proxy_get_port_by_ch(port_prox, ch_id);
+	struct t7xx_port_conf *port_conf;
+
+	if (!port)
+		return -EINVAL;
+
+	port_conf = port->port_conf;
+
+	if (en_flag) {
+		if (port_conf->ops->enable_chl)
+			port_conf->ops->enable_chl(port);
+	} else {
+		if (port_conf->ops->disable_chl)
+			port_conf->ops->disable_chl(port);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
new file mode 100644
index 000000000000..2bb50b18f1a1
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021-2022, Intel Corporation.
+ *
+ * Authors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez <ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#ifndef __T7XX_PORT_PROXY_H__
+#define __T7XX_PORT_PROXY_H__
+
+#include <linux/bits.h>
+#include <linux/device.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+
+#include "t7xx_hif_cldma.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_port.h"
+
+#define MTK_QUEUES		16
+#define RX_QUEUE_MAXLEN		32
+#define CTRL_QUEUE_MAXLEN	16
+
+struct port_proxy {
+	int				port_number;
+	struct list_head		rx_ch_ports[PORT_CH_ID_MASK + 1];
+	struct list_head		queue_ports[CLDMA_NUM][MTK_QUEUES];
+	struct device			*dev;
+	struct t7xx_port		ports[];
+};
+
+struct ccci_header {
+	__le32 packet_header;
+	__le32 packet_len;
+	__le32 status;
+	__le32 ex_msg;
+};
+
+/* Coupled with HW - indicates if there is data following the CCCI header or not */
+#define CCCI_HEADER_NO_DATA	0xffffffff
+
+#define CCCI_H_AST_BIT		BIT(31)
+#define CCCI_H_SEQ_FLD		GENMASK(30, 16)
+#define CCCI_H_CHN_FLD		GENMASK(15, 0)
+
+#define PORT_INFO_RSRVD		GENMASK(31, 16)
+#define PORT_INFO_ENFLG		BIT(15)
+#define PORT_INFO_CH_ID		GENMASK(14, 0)
+
+#define PORT_ENUM_VER		0
+#define PORT_ENUM_HEAD_PATTERN	0x5a5a5a5a
+#define PORT_ENUM_TAIL_PATTERN	0xa5a5a5a5
+#define PORT_ENUM_VER_MISMATCH	0x00657272
+
+void t7xx_port_proxy_reset(struct port_proxy *port_prox);
+void t7xx_port_proxy_uninit(struct port_proxy *port_prox);
+int t7xx_port_proxy_init(struct t7xx_modem *md);
+void t7xx_port_proxy_md_status_notify(struct port_proxy *port_prox, unsigned int state);
+int t7xx_port_proxy_chl_enable_disable(struct port_proxy *port_prox, unsigned int ch_id,
+				       bool en_flag);
+
+#endif /* __T7XX_PORT_PROXY_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index 4b2e6913c45e..30f3739f1d83 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -37,6 +37,7 @@
 #include "t7xx_modem_ops.h"
 #include "t7xx_pci.h"
 #include "t7xx_pcie_mac.h"
+#include "t7xx_port_proxy.h"
 #include "t7xx_reg.h"
 #include "t7xx_state_monitor.h"
 
@@ -90,6 +91,9 @@ static void fsm_state_notify(struct t7xx_modem *md, enum md_state state)
 void t7xx_fsm_broadcast_state(struct t7xx_fsm_ctl *ctl, enum md_state state)
 {
 	ctl->md_state = state;
+
+	/* Update to port first, otherwise sending message on HS2 may fail */
+	t7xx_port_proxy_md_status_notify(ctl->md->port_prox, state);
 	fsm_state_notify(ctl->md, state);
 }
 
@@ -258,6 +262,7 @@ static void t7xx_fsm_broadcast_ready_state(struct t7xx_fsm_ctl *ctl)
 	ctl->md_state = MD_STATE_READY;
 
 	fsm_state_notify(ctl->md, MD_STATE_READY);
+	t7xx_port_proxy_md_status_notify(ctl->md->port_prox, MD_STATE_READY);
 }
 
 static void fsm_routine_ready(struct t7xx_fsm_ctl *ctl)
-- 
2.17.1

