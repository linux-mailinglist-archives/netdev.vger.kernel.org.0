Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49376BE41C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbjCQIoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjCQIoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:44:00 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507CB76163;
        Fri, 17 Mar 2023 01:42:51 -0700 (PDT)
X-UUID: 6cc269e0c49b11edbd2e61cc88cc8f98-20230317
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=SeTkJe4RimMKIh4IP5gC25RuWqFcccQZT3rHpT2NLww=;
        b=XtaQHGa6PAG/c8zigtl0IoPnEfQyx6hbclbPiWG8Wdpq+/rQPRXMd12N55c4lmP7t/TehvGTc+kaqPrBdWew4MfYimZIgD/QXgOFFtRwpQxZKH0MR7b1BB6Jf4QGO72YcravTQlKhOPR5OVIAqoNKa2D0RIL9v/KtyWAIDSBx9E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.21,REQID:26cba884-4ffa-4769-9ddb-c9744e258692,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:70
X-CID-INFO: VERSION:1.1.21,REQID:26cba884-4ffa-4769-9ddb-c9744e258692,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:70
X-CID-META: VersionHash:83295aa,CLOUDID:b1be1af6-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:230317161216ULHBSGAC,BulkQuantity:0,Recheck:0,SF:38|29|28|17|19|48,T
        C:nil,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,CO
        L:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-UUID: 6cc269e0c49b11edbd2e61cc88cc8f98-20230317
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1808890449; Fri, 17 Mar 2023 16:12:14 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 17 Mar 2023 16:12:13 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 17 Mar 2023 16:12:11 +0800
From:   Yanchao Yang <yanchao.yang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
CC:     Intel experts <linuxwwan@intel.com>,
        Chetan <m.chetan.kumar@intel.com>,
        MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        Yanchao Yang <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: [PATCH net-next v4 04/10] net: wwan: tmi: Add control port
Date:   Fri, 17 Mar 2023 16:09:36 +0800
Message-ID: <20230317080942.183514-5-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230317080942.183514-1-yanchao.yang@mediatek.com>
References: <20230317080942.183514-1-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The control port consists of port I/O and port manager.
Port I/O provides a common operation as defined by "struct port_ops",
and the operation is managed by the "port manager". It provides
interfaces to internal users, the implemented internal interfaces are
open, close, write and recv_register.

The port manager defines and implements port management interfaces and
structures. It is responsible for port creation, destroying, and managing
port states. It sends data from port I/O to CLDMA via TRB ( Transaction
Request Block ), and dispatches received data from CLDMA to port I/O.
The using port will be held in the "stale list" when the driver destroys
it, and after creating it again, the user can continue to use it.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
Signed-off-by: Felix Chen <felix.chen@mediatek.com>
---
 drivers/net/wwan/mediatek/Makefile         |   4 +-
 drivers/net/wwan/mediatek/mtk_ctrl_plane.c | 117 +++
 drivers/net/wwan/mediatek/mtk_ctrl_plane.h |  28 +-
 drivers/net/wwan/mediatek/mtk_dev.c        |   4 +-
 drivers/net/wwan/mediatek/mtk_port.c       | 844 +++++++++++++++++++++
 drivers/net/wwan/mediatek/mtk_port.h       | 171 +++++
 drivers/net/wwan/mediatek/mtk_port_io.c    | 253 ++++++
 drivers/net/wwan/mediatek/mtk_port_io.h    |  34 +
 drivers/net/wwan/mediatek/pcie/mtk_pci.c   |   2 +
 9 files changed, 1452 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/wwan/mediatek/mtk_port.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_port.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_port_io.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_port_io.h

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index 23a1cbc06ef6..e3afd8ecb494 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -7,6 +7,8 @@ mtk_tmi-y = \
 	mtk_dev.o \
 	mtk_ctrl_plane.o \
 	mtk_cldma.o \
-	pcie/mtk_cldma_drv_t800.o
+	pcie/mtk_cldma_drv_t800.o \
+	mtk_port.o \
+	mtk_port_io.o
 
 obj-$(CONFIG_MTK_TMI) += mtk_tmi.o
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.c b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
index 1dbfcf8587a1..8adb1f53ec64 100644
--- a/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
@@ -10,11 +10,118 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 
+#include "mtk_cldma.h"
 #include "mtk_ctrl_plane.h"
+#include "mtk_port.h"
+
+static int mtk_ctrl_get_hif_id(unsigned char peer_id)
+{
+	if (peer_id == MTK_PEER_ID_SAP)
+		return CLDMA0;
+	else if (peer_id == MTK_PEER_ID_MD)
+		return CLDMA1;
+	else
+		return -EINVAL;
+}
+
+int mtk_ctrl_vq_search(struct mtk_ctrl_blk *ctrl_blk, unsigned char peer_id,
+		       unsigned char tx_hwq, unsigned char rx_hwq)
+{
+	struct mtk_port_mngr *port_mngr = ctrl_blk->port_mngr;
+	struct mtk_ctrl_trans *trans = ctrl_blk->trans;
+	int hif_id = mtk_ctrl_get_hif_id(peer_id);
+	struct virtq *vq;
+	int vq_num = 0;
+
+	if (hif_id < 0)
+		return -EINVAL;
+
+	do {
+		vq = trans->vq_tbl + vq_num;
+		if (port_mngr->vq_info[vq_num].color && vq->txqno == tx_hwq &&
+		    vq->rxqno == rx_hwq && vq->hif_id == hif_id)
+			return vq_num;
+
+		vq_num++;
+	} while (vq_num < VQ_NUM);
+
+	return -ENOENT;
+}
+
+int mtk_ctrl_vq_color_paint(struct mtk_ctrl_blk *ctrl_blk, unsigned char peer_id,
+			    unsigned char tx_hwq, unsigned char rx_hwq,
+			    unsigned int tx_mtu, unsigned int rx_mtu)
+{
+	struct mtk_port_mngr *port_mngr = ctrl_blk->port_mngr;
+	struct mtk_ctrl_trans *trans = ctrl_blk->trans;
+	int hif_id = mtk_ctrl_get_hif_id(peer_id);
+	struct virtq *vq;
+	int vq_num = 0;
+
+	if (hif_id < 0)
+		return -EINVAL;
+
+	do {
+		vq = trans->vq_tbl + vq_num;
+		if (vq->hif_id == hif_id && vq->txqno == tx_hwq && vq->rxqno == rx_hwq &&
+		    vq->tx_mtu <= tx_mtu && vq->rx_mtu >= rx_mtu)
+			port_mngr->vq_info[vq_num].color = true;
+
+		vq_num++;
+	} while (vq_num < VQ_NUM);
+
+	return 0;
+}
+
+int mtk_ctrl_vq_color_cleanup(struct mtk_ctrl_blk *ctrl_blk, unsigned char peer_id)
+{
+	struct mtk_port_mngr *port_mngr = ctrl_blk->port_mngr;
+	struct mtk_ctrl_trans *trans = ctrl_blk->trans;
+	int hif_id = mtk_ctrl_get_hif_id(peer_id);
+	struct virtq *vq;
+	int vq_num = 0;
+
+	if (hif_id < 0)
+		return -EINVAL;
+
+	do {
+		vq = trans->vq_tbl + vq_num;
+		if (vq->hif_id == hif_id)
+			port_mngr->vq_info[vq_num].color = false;
+
+		vq_num++;
+	} while (vq_num < VQ_NUM);
+
+	return 0;
+}
+
+int mtk_ctrl_trb_submit(struct mtk_ctrl_blk *blk, struct sk_buff *skb)
+{
+	struct mtk_ctrl_trans *trans = blk->trans;
+	struct trb *trb;
+	int vqno;
+
+	trb = (struct trb *)skb->cb;
+	if (trb->vqno >= VQ_NUM)
+		return -EINVAL;
+
+	if (!atomic_read(&trans->available))
+		return -EIO;
+
+	vqno = trb->vqno;
+	if (VQ_LIST_FULL(trans, vqno) && trb->cmd != TRB_CMD_DISABLE)
+		return -EAGAIN;
+
+	/* This function will implement in next patch */
+	wake_up(&trans->trb_srv->trb_waitq);
+
+	return 0;
+}
 
 int mtk_ctrl_init(struct mtk_md_dev *mdev)
 {
 	struct mtk_ctrl_blk *ctrl_blk;
+	int err;
 
 	ctrl_blk = devm_kzalloc(mdev->dev, sizeof(*ctrl_blk), GFP_KERNEL);
 	if (!ctrl_blk)
@@ -23,13 +130,23 @@ int mtk_ctrl_init(struct mtk_md_dev *mdev)
 	ctrl_blk->mdev = mdev;
 	mdev->ctrl_blk = ctrl_blk;
 
+	err = mtk_port_mngr_init(ctrl_blk);
+	if (err)
+		goto err_free_mem;
+
 	return 0;
+
+err_free_mem:
+	devm_kfree(mdev->dev, ctrl_blk);
+
+	return err;
 }
 
 int mtk_ctrl_exit(struct mtk_md_dev *mdev)
 {
 	struct mtk_ctrl_blk *ctrl_blk = mdev->ctrl_blk;
 
+	mtk_port_mngr_exit(ctrl_blk);
 	devm_kfree(mdev->dev, ctrl_blk);
 
 	return 0;
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
index 32cd8dc7bdb7..2e1f21d43644 100644
--- a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
@@ -11,13 +11,20 @@
 
 #include "mtk_dev.h"
 
+#define VQ(N)				(N)
+#define VQ_NUM				(2)
+
 #define VQ_MTU_3_5K			(0xE00)
 #define VQ_MTU_63K			(0xFC00)
 
+#define SKB_LIST_MAX_LEN		(16)
+
 #define HIF_CLASS_NUM			(1)
 #define HIF_CLASS_SHIFT			(8)
 #define HIF_ID_BITMASK			(0x01)
 
+#define VQ_LIST_FULL(trans, vqno)	((trans)->skb_list[vqno].qlen >= SKB_LIST_MAX_LEN)
+
 enum mtk_trb_cmd_type {
 	TRB_CMD_ENABLE = 1,
 	TRB_CMD_TX,
@@ -39,6 +46,14 @@ struct trb {
 	int (*trb_complete)(struct sk_buff *skb);
 };
 
+struct trb_srv {
+	int vq_cnt;
+	int vq_start;
+	struct mtk_ctrl_trans *trans;
+	wait_queue_head_t trb_waitq;
+	struct task_struct *trb_thread;
+};
+
 struct virtq {
 	int vqno;
 	int hif_id;
@@ -50,8 +65,6 @@ struct virtq {
 	int rx_req_num;
 };
 
-struct mtk_ctrl_trans;
-
 struct hif_ops {
 	int (*init)(struct mtk_ctrl_trans *trans);
 	int (*exit)(struct mtk_ctrl_trans *trans);
@@ -60,18 +73,29 @@ struct hif_ops {
 };
 
 struct mtk_ctrl_trans {
+	struct sk_buff_head skb_list[VQ_NUM];
+	struct trb_srv *trb_srv;
 	struct virtq *vq_tbl;
 	void *dev[HIF_CLASS_NUM];
 	struct hif_ops *ops[HIF_CLASS_NUM];
 	struct mtk_ctrl_blk *ctrl_blk;
 	struct mtk_md_dev *mdev;
+	atomic_t available;
 };
 
 struct mtk_ctrl_blk {
 	struct mtk_md_dev *mdev;
+	struct mtk_port_mngr *port_mngr;
 	struct mtk_ctrl_trans *trans;
 };
 
+int mtk_ctrl_vq_search(struct mtk_ctrl_blk *ctrl_blk, unsigned char peer_id,
+		       unsigned char tx_hwq, unsigned char rx_hwq);
+int mtk_ctrl_vq_color_paint(struct mtk_ctrl_blk *ctrl_blk, unsigned char peer_id,
+			    unsigned char tx_hwq, unsigned char rx_hwq,
+			    unsigned int tx_mtu, unsigned int rx_mtu);
+int mtk_ctrl_vq_color_cleanup(struct mtk_ctrl_blk *ctrl_blk, unsigned char peer_id);
+int mtk_ctrl_trb_submit(struct mtk_ctrl_blk *blk, struct sk_buff *skb);
 int mtk_ctrl_init(struct mtk_md_dev *mdev);
 int mtk_ctrl_exit(struct mtk_md_dev *mdev);
 
diff --git a/drivers/net/wwan/mediatek/mtk_dev.c b/drivers/net/wwan/mediatek/mtk_dev.c
index f63c7e04df6a..d34c3933e84d 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.c
+++ b/drivers/net/wwan/mediatek/mtk_dev.c
@@ -12,10 +12,10 @@ int mtk_dev_init(struct mtk_md_dev *mdev)
 
 	ret = mtk_ctrl_init(mdev);
 	if (ret)
-		goto err_ctrl_init;
+		goto exit;
 
 	return 0;
-err_ctrl_init:
+exit:
 	return ret;
 }
 
diff --git a/drivers/net/wwan/mediatek/mtk_port.c b/drivers/net/wwan/mediatek/mtk_port.c
new file mode 100644
index 000000000000..12097a279aa0
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_port.c
@@ -0,0 +1,844 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+
+#include "mtk_port.h"
+#include "mtk_port_io.h"
+
+#define MTK_DFLT_TRB_TIMEOUT			(5 * HZ)
+#define MTK_DFLT_TRB_STATUS			(0x1)
+#define MTK_CHECK_RX_SEQ_MASK			(0x7fff)
+
+#define MTK_PORT_SEARCH_FROM_RADIX_TREE(p, s) ({\
+	struct mtk_port *_p;			\
+	_p = radix_tree_deref_slot(s);		\
+	if (!_p)				\
+		continue;			\
+	p = _p;					\
+})
+
+#define MTK_PORT_INTERNAL_NODE_CHECK(p, s, i) ({\
+	if (radix_tree_is_internal_node(p)) {	\
+		s = radix_tree_iter_retry(&(i));\
+		continue;			\
+	}					\
+})
+
+static LIST_HEAD(stale_list_grp);
+/* mutex lock for stale_list_group */
+DEFINE_MUTEX(port_mngr_grp_mtx);
+
+static DEFINE_IDA(ccci_dev_ids);
+
+static const struct mtk_port_cfg port_cfg[] = {
+	{CCCI_CONTROL_TX, CCCI_CONTROL_RX, VQ(1), PORT_TYPE_INTERNAL, "MDCTRL", PORT_F_ALLOW_DROP},
+	{CCCI_SAP_CONTROL_TX, CCCI_SAP_CONTROL_RX, VQ(0), PORT_TYPE_INTERNAL, "SAPCTRL",
+	 PORT_F_ALLOW_DROP},
+};
+
+void mtk_port_release(struct kref *port_kref)
+{
+	struct mtk_stale_list *s_list;
+	struct mtk_port *port;
+
+	port = container_of(port_kref, struct mtk_port, kref);
+	if (!test_bit(PORT_S_ON_STALE_LIST, &port->status))
+		goto port_exit;
+
+	list_del(&port->stale_entry);
+	list_for_each_entry(s_list, &stale_list_grp, entry) {
+		if (!strncmp(s_list->dev_str, port->dev_str, MTK_DEV_STR_LEN) &&
+		    list_empty(&s_list->ports) && s_list->dev_id >= 0) {
+			pr_info("Free dev id of stale list(%s)\n", s_list->dev_str);
+			ida_free(&ccci_dev_ids, s_list->dev_id);
+			s_list->dev_id = -1;
+			break;
+		}
+	}
+
+port_exit:
+	ports_ops[port->info.type]->exit(port);
+	kfree(port);
+}
+
+static int mtk_port_tbl_add(struct mtk_port_mngr *port_mngr, struct mtk_port *port)
+{
+	int ret;
+
+	ret = radix_tree_insert(&port_mngr->port_tbl[MTK_PORT_TBL_TYPE(port->info.rx_ch)],
+				port->info.rx_ch & 0xFFF, port);
+	if (ret)
+		dev_err(port_mngr->ctrl_blk->mdev->dev,
+			"port(%s) add to port_tbl failed, return %d\n",
+			port->info.name, ret);
+
+	return ret;
+}
+
+static void mtk_port_tbl_del(struct mtk_port_mngr *port_mngr, struct mtk_port *port)
+{
+	radix_tree_delete(&port_mngr->port_tbl[MTK_PORT_TBL_TYPE(port->info.rx_ch)],
+			  port->info.rx_ch & 0xFFF);
+}
+
+static struct mtk_port *mtk_port_get_from_stale_list(struct mtk_port_mngr *port_mngr,
+						     struct mtk_stale_list *s_list,
+						     int rx_ch)
+{
+	struct mtk_port *port, *next_port;
+	int ret;
+
+	mutex_lock(&port_mngr_grp_mtx);
+	list_for_each_entry_safe(port, next_port, &s_list->ports, stale_entry) {
+		if (port->info.rx_ch == rx_ch) {
+			kref_get(&port->kref);
+			list_del(&port->stale_entry);
+			ret = mtk_port_tbl_add(port_mngr, port);
+			if (ret) {
+				list_add_tail(&port->stale_entry, &s_list->ports);
+				kref_put(&port->kref, mtk_port_release);
+				mutex_unlock(&port_mngr_grp_mtx);
+				dev_err(port_mngr->ctrl_blk->mdev->dev,
+					"Failed when adding (%s) to port mngr\n",
+					port->info.name);
+				return ERR_PTR(ret);
+			}
+
+			port->port_mngr = port_mngr;
+			clear_bit(PORT_S_ON_STALE_LIST, &port->status);
+			mutex_unlock(&port_mngr_grp_mtx);
+			return port;
+		}
+	}
+	mutex_unlock(&port_mngr_grp_mtx);
+
+	return NULL;
+}
+
+static struct mtk_port *mtk_port_alloc_or_restore(struct mtk_port_mngr *port_mngr,
+						  struct mtk_port_cfg *dflt_info,
+						  struct mtk_stale_list *s_list)
+{
+	struct mtk_port *port;
+	int ret;
+
+	port = mtk_port_get_from_stale_list(port_mngr, s_list, dflt_info->rx_ch);
+	if (IS_ERR(port))
+		return port;
+
+	if (port) {
+		ports_ops[port->info.type]->reset(port);
+		dev_info(port_mngr->ctrl_blk->mdev->dev,
+			 "Port(%s) move from stale list\n", port->info.name);
+		goto return_port;
+	}
+
+	port = kzalloc(sizeof(*port), GFP_KERNEL);
+	if (!port) {
+		ret = -ENOMEM;
+		goto exit_err;
+	}
+
+	memcpy(port, dflt_info, sizeof(*dflt_info));
+	ret = mtk_port_tbl_add(port_mngr, port);
+	if (ret < 0) {
+		dev_err(port_mngr->ctrl_blk->mdev->dev,
+			"Failed to add port(%s) to port tbl\n", dflt_info->name);
+		goto free_port;
+	}
+
+	port->port_mngr = port_mngr;
+	ports_ops[port->info.type]->init(port);
+	dev_info(port_mngr->ctrl_blk->mdev->dev,
+		 "Port(%s) alloc and init\n", port->info.name);
+
+return_port:
+	return port;
+free_port:
+	kfree(port);
+exit_err:
+	return ERR_PTR(ret);
+}
+
+static void mtk_port_free_or_backup(struct mtk_port_mngr *port_mngr,
+				    struct mtk_port *port, struct mtk_stale_list *s_list)
+{
+	mutex_lock(&port_mngr_grp_mtx);
+	mtk_port_tbl_del(port_mngr, port);
+	if (port->info.type != PORT_TYPE_INTERNAL) {
+		if (test_bit(PORT_S_OPEN, &port->status)) {
+			list_add_tail(&port->stale_entry, &s_list->ports);
+			set_bit(PORT_S_ON_STALE_LIST, &port->status);
+			dev_info(port_mngr->ctrl_blk->mdev->dev,
+				 "Port(%s) move to stale list\n", port->info.name);
+			memcpy(port->dev_str, port_mngr->ctrl_blk->mdev->dev_str, MTK_DEV_STR_LEN);
+			port->port_mngr = NULL;
+		}
+		kref_put(&port->kref, mtk_port_release);
+	} else {
+		mtk_port_release(&port->kref);
+	}
+	mutex_unlock(&port_mngr_grp_mtx);
+}
+
+static struct mtk_port *mtk_port_search_by_id(struct mtk_port_mngr *port_mngr, int rx_ch)
+{
+	int tbl_type = MTK_PORT_TBL_TYPE(rx_ch);
+
+	if (tbl_type < PORT_TBL_SAP || tbl_type >= PORT_TBL_MAX)
+		return NULL;
+
+	return radix_tree_lookup(&port_mngr->port_tbl[tbl_type], MTK_CH_ID(rx_ch));
+}
+
+struct mtk_port *mtk_port_search_by_name(struct mtk_port_mngr *port_mngr, char *name)
+{
+	int tbl_type = PORT_TBL_SAP;
+	struct radix_tree_iter iter;
+	struct mtk_port *port;
+	void __rcu **slot;
+
+	do {
+		radix_tree_for_each_slot(slot, &port_mngr->port_tbl[tbl_type], &iter, 0) {
+			MTK_PORT_SEARCH_FROM_RADIX_TREE(port, slot);
+			MTK_PORT_INTERNAL_NODE_CHECK(port, slot, iter);
+			if (!strncmp(port->info.name, name, strlen(port->info.name)))
+				return port;
+		}
+		tbl_type++;
+	} while (tbl_type < PORT_TBL_MAX);
+	return NULL;
+}
+
+static int mtk_port_tbl_create(struct mtk_port_mngr *port_mngr, struct mtk_port_cfg *cfg,
+			       const int port_cnt, struct mtk_stale_list *s_list)
+{
+	struct mtk_port_cfg *dflt_port;
+	struct mtk_port *port;
+	int i, ret;
+
+	INIT_RADIX_TREE(&port_mngr->port_tbl[PORT_TBL_SAP], GFP_KERNEL);
+	INIT_RADIX_TREE(&port_mngr->port_tbl[PORT_TBL_MD], GFP_KERNEL);
+
+	for (i = 0; i < port_cnt; i++) {
+		dflt_port = cfg + i;
+		port = mtk_port_alloc_or_restore(port_mngr, dflt_port, s_list);
+		if (IS_ERR(port)) {
+			ret = PTR_ERR(port);
+			goto free_ports;
+		}
+	}
+	return 0;
+
+free_ports:
+	for (i--; i >= 0; i--) {
+		dflt_port = cfg + i;
+		port = mtk_port_search_by_id(port_mngr, dflt_port->rx_ch);
+		if (port)
+			mtk_port_free_or_backup(port_mngr, port, s_list);
+	}
+
+	return ret;
+}
+
+static void mtk_port_tbl_destroy(struct mtk_port_mngr *port_mngr, struct mtk_stale_list *s_list)
+{
+	struct radix_tree_iter iter;
+	struct mtk_port *port;
+	void __rcu **slot;
+	int tbl_type;
+
+	tbl_type = PORT_TBL_SAP;
+	do {
+		radix_tree_for_each_slot(slot, &port_mngr->port_tbl[tbl_type], &iter, 0) {
+			MTK_PORT_SEARCH_FROM_RADIX_TREE(port, slot);
+			MTK_PORT_INTERNAL_NODE_CHECK(port, slot, iter);
+			ports_ops[port->info.type]->disable(port);
+		}
+		tbl_type++;
+	} while (tbl_type < PORT_TBL_MAX);
+
+	tbl_type = PORT_TBL_SAP;
+	do {
+		radix_tree_for_each_slot(slot, &port_mngr->port_tbl[tbl_type], &iter, 0) {
+			MTK_PORT_SEARCH_FROM_RADIX_TREE(port, slot);
+			MTK_PORT_INTERNAL_NODE_CHECK(port, slot, iter);
+			mtk_port_free_or_backup(port_mngr, port, s_list);
+		}
+		tbl_type++;
+	} while (tbl_type < PORT_TBL_MAX);
+}
+
+static struct mtk_stale_list *mtk_port_stale_list_create(struct mtk_port_mngr *port_mngr)
+{
+	struct mtk_stale_list *s_list;
+
+	s_list = kzalloc(sizeof(*s_list), GFP_KERNEL);
+	if (!s_list)
+		return NULL;
+
+	memcpy(s_list->dev_str, port_mngr->ctrl_blk->mdev->dev_str, MTK_DEV_STR_LEN);
+	s_list->dev_id = -1;
+	INIT_LIST_HEAD(&s_list->ports);
+
+	mutex_lock(&port_mngr_grp_mtx);
+	list_add_tail(&s_list->entry, &stale_list_grp);
+	mutex_unlock(&port_mngr_grp_mtx);
+
+	return s_list;
+}
+
+static void mtk_port_stale_list_destroy(struct mtk_stale_list *s_list)
+{
+	mutex_lock(&port_mngr_grp_mtx);
+	list_del(&s_list->entry);
+	mutex_unlock(&port_mngr_grp_mtx);
+	kfree(s_list);
+}
+
+static struct mtk_stale_list *mtk_port_stale_list_search(const char *dev_str)
+{
+	struct mtk_stale_list *tmp, *s_list = NULL;
+
+	mutex_lock(&port_mngr_grp_mtx);
+	list_for_each_entry(tmp, &stale_list_grp, entry) {
+		if (!strncmp(tmp->dev_str, dev_str, MTK_DEV_STR_LEN)) {
+			s_list = tmp;
+			break;
+		}
+	}
+	mutex_unlock(&port_mngr_grp_mtx);
+
+	return s_list;
+}
+
+void mtk_port_stale_list_grp_cleanup(void)
+{
+	struct mtk_stale_list *s_list, *next_s_list;
+	struct mtk_port *port, *next_port;
+
+	mutex_lock(&port_mngr_grp_mtx);
+	list_for_each_entry_safe(s_list, next_s_list, &stale_list_grp, entry) {
+		list_del(&s_list->entry);
+
+		list_for_each_entry_safe(port, next_port, &s_list->ports, stale_entry) {
+			list_del(&port->stale_entry);
+			mtk_port_release(&port->kref);
+		}
+
+		kfree(s_list);
+	}
+	mutex_unlock(&port_mngr_grp_mtx);
+}
+
+static struct mtk_stale_list *mtk_port_stale_list_init(struct mtk_port_mngr *port_mngr)
+{
+	struct mtk_stale_list *s_list;
+
+	s_list = mtk_port_stale_list_search(port_mngr->ctrl_blk->mdev->dev_str);
+	if (!s_list) {
+		dev_info(port_mngr->ctrl_blk->mdev->dev, "Create stale list\n");
+		s_list = mtk_port_stale_list_create(port_mngr);
+		if (unlikely(!s_list))
+			return NULL;
+	} else {
+		dev_info(port_mngr->ctrl_blk->mdev->dev, "Reuse old stale list\n");
+	}
+
+	mutex_lock(&port_mngr_grp_mtx);
+	if (s_list->dev_id < 0) {
+		port_mngr->dev_id = ida_alloc_range(&ccci_dev_ids, 0,
+						    MTK_DFLT_MAX_DEV_CNT - 1,
+						    GFP_KERNEL);
+	} else {
+		port_mngr->dev_id = s_list->dev_id;
+		s_list->dev_id = -1;
+	}
+	mutex_unlock(&port_mngr_grp_mtx);
+
+	return s_list;
+}
+
+static void mtk_port_stale_list_exit(struct mtk_port_mngr *port_mngr, struct mtk_stale_list *s_list)
+{
+	mutex_lock(&port_mngr_grp_mtx);
+	if (list_empty(&s_list->ports)) {
+		ida_free(&ccci_dev_ids, port_mngr->dev_id);
+		mutex_unlock(&port_mngr_grp_mtx);
+		mtk_port_stale_list_destroy(s_list);
+		dev_info(port_mngr->ctrl_blk->mdev->dev, "Destroy stale list\n");
+	} else {
+		s_list->dev_id = port_mngr->dev_id;
+		mutex_unlock(&port_mngr_grp_mtx);
+		dev_info(port_mngr->ctrl_blk->mdev->dev, "Reserve stale list\n");
+	}
+}
+
+static void mtk_port_trb_init(struct mtk_port *port, struct trb *trb, enum mtk_trb_cmd_type cmd,
+			      int (*trb_complete)(struct sk_buff *skb))
+{
+	kref_init(&trb->kref);
+	trb->vqno = port->info.vq_id;
+	trb->status = MTK_DFLT_TRB_STATUS;
+	trb->priv = port;
+	trb->cmd = cmd;
+	trb->trb_complete = trb_complete;
+}
+
+static void mtk_port_trb_free(struct kref *trb_kref)
+{
+	struct trb *trb = container_of(trb_kref, struct trb, kref);
+	struct sk_buff *skb;
+
+	skb = container_of((char *)trb, struct sk_buff, cb[0]);
+	dev_kfree_skb_any(skb);
+}
+
+static int mtk_port_open_trb_complete(struct sk_buff *skb)
+{
+	struct trb_open_priv *trb_open_priv = (struct trb_open_priv *)skb->data;
+	struct trb *trb = (struct trb *)skb->cb;
+	struct mtk_port *port = trb->priv;
+	struct mtk_port_mngr *port_mngr;
+
+	port_mngr = port->port_mngr;
+
+	if (trb->status && trb->status != -EBUSY)
+		goto out;
+
+	if (!trb->status) {
+		port_mngr->vq_info[trb->vqno].tx_mtu = trb_open_priv->tx_mtu;
+		port_mngr->vq_info[trb->vqno].rx_mtu = trb_open_priv->rx_mtu;
+	}
+
+	port->tx_mtu = port_mngr->vq_info[trb->vqno].tx_mtu;
+	port->rx_mtu = port_mngr->vq_info[trb->vqno].rx_mtu;
+
+	port->tx_mtu -= MTK_CCCI_H_ELEN;
+	port->rx_mtu -= MTK_CCCI_H_ELEN;
+
+out:
+	wake_up_interruptible_all(&port->trb_wq);
+
+	dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+		 "Open VQ TRB:status:%d, vq:%d, port:%s, tx_mtu:%d. rx_mtu:%d\n",
+		 trb->status, trb->vqno, port->info.name, port->tx_mtu, port->rx_mtu);
+	kref_put(&trb->kref, mtk_port_trb_free);
+	return 0;
+}
+
+static int mtk_port_close_trb_complete(struct sk_buff *skb)
+{
+	struct trb *trb = (struct trb *)skb->cb;
+	struct mtk_port *port = trb->priv;
+
+	wake_up_interruptible_all(&port->trb_wq);
+	dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+		 "Close VQ TRB: trb->status:%d, vq:%d, port:%s\n",
+		 trb->status, trb->vqno, port->info.name);
+	kref_put(&trb->kref, mtk_port_trb_free);
+
+	return 0;
+}
+
+static int mtk_port_tx_complete(struct sk_buff *skb)
+{
+	struct trb *trb = (struct trb *)skb->cb;
+	struct mtk_port *port = trb->priv;
+
+	if (trb->status < 0)
+		dev_warn(port->port_mngr->ctrl_blk->mdev->dev,
+			 "Failed to send data: trb->status:%d, vq:%d, port:%s\n",
+			 trb->status, trb->vqno, port->info.name);
+
+	if (port->info.flags & PORT_F_BLOCKING)
+		wake_up_interruptible_all(&port->trb_wq);
+
+	kref_put(&trb->kref, mtk_port_trb_free);
+
+	return 0;
+}
+
+static int mtk_port_status_check(struct mtk_port *port)
+{
+	if (!test_bit(PORT_S_ENABLE, &port->status)) {
+		pr_err("[TMI]Unable to use port: (%s) disabled. Caller: %ps\n",
+		       port->info.name, __builtin_return_address(0));
+		return -ENODEV;
+	}
+
+	if (!test_bit(PORT_S_OPEN, &port->status) || test_bit(PORT_S_FLUSH, &port->status) ||
+	    !test_bit(PORT_S_RDWR, &port->status)) {
+		dev_err(port->port_mngr->ctrl_blk->mdev->dev,
+			"Unable to use port: (%s), port status = 0x%lx. Caller: %ps\n",
+			port->info.name, port->status, __builtin_return_address(0));
+
+		return -EBADF;
+	}
+
+	return 0;
+}
+
+int mtk_port_send_data(struct mtk_port *port, void *data)
+{
+	struct mtk_port_mngr *port_mngr;
+	struct mtk_ctrl_trans *trans;
+	struct sk_buff *skb = data;
+	struct trb *trb;
+	int ret, len;
+
+	port_mngr = port->port_mngr;
+	trans = port_mngr->ctrl_blk->trans;
+
+	trb = (struct trb *)skb->cb;
+	mtk_port_trb_init(port, trb, TRB_CMD_TX, mtk_port_tx_complete);
+	len = skb->len;
+	kref_get(&trb->kref); /* kref count 1->2 */
+
+submit_trb:
+	mutex_lock(&port->write_lock);
+	ret = mtk_port_status_check(port);
+	if (!ret)
+		ret = mtk_ctrl_trb_submit(port_mngr->ctrl_blk, skb);
+	mutex_unlock(&port->write_lock);
+
+	if (ret == -EAGAIN && port->info.flags & PORT_F_BLOCKING) {
+		dev_warn(port_mngr->ctrl_blk->mdev->dev,
+			 "Failed to submit trb for port(%s), ret=%d\n", port->info.name, ret);
+		wait_event_interruptible(port->trb_wq, !VQ_LIST_FULL(trans, trb->vqno));
+		goto submit_trb;
+	} else if (ret < 0) {
+		dev_warn(port_mngr->ctrl_blk->mdev->dev,
+			 "Failed to submit trb for port(%s), ret=%d\n", port->info.name, ret);
+		kref_put(&trb->kref, mtk_port_trb_free); /* kref count 2->1 */
+		dev_kfree_skb_any(skb);
+		goto end;
+	}
+
+	if (!(port->info.flags & PORT_F_BLOCKING)) {
+		kref_put(&trb->kref, mtk_port_trb_free);
+		ret = len;
+		goto end;
+	}
+start_wait:
+	ret = wait_event_interruptible_timeout(port->trb_wq,
+					       trb->status <= 0 ||
+					       test_bit(PORT_S_FLUSH, &port->status),
+					       MTK_DFLT_TRB_TIMEOUT);
+
+	if (ret == -ERESTARTSYS)
+		goto start_wait;
+	else if (test_bit(PORT_S_FLUSH, &port->status))
+		ret = -EBUSY;
+	else if (!ret)
+		ret = -ETIMEDOUT;
+	else
+		ret = (!trb->status) ? len : trb->status;
+
+	kref_put(&trb->kref, mtk_port_trb_free);
+
+end:
+	return ret;
+}
+
+static int mtk_port_check_rx_seq(struct mtk_port *port, struct mtk_ccci_header *ccci_h)
+{
+	u16 seq_num, assert_bit;
+
+	seq_num = FIELD_GET(MTK_HDR_FLD_SEQ, le32_to_cpu(ccci_h->status));
+	assert_bit = FIELD_GET(MTK_HDR_FLD_AST, le32_to_cpu(ccci_h->status));
+	if (assert_bit && port->rx_seq &&
+	    ((seq_num - port->rx_seq) & MTK_CHECK_RX_SEQ_MASK) != 1) {
+		dev_err(port->port_mngr->ctrl_blk->mdev->dev,
+			"<ch: %ld> seq num out-of-order %d->%d",
+			FIELD_GET(MTK_HDR_FLD_CHN, le32_to_cpu(ccci_h->status)),
+			seq_num, port->rx_seq);
+		return -EPROTO;
+	}
+
+	return 0;
+}
+
+static int mtk_port_rx_dispatch(struct sk_buff *skb, int len, void *priv)
+{
+	struct mtk_port_mngr *port_mngr;
+	struct mtk_ccci_header *ccci_h;
+	struct mtk_port *port = priv;
+	int ret = -EPROTO;
+	u16 channel;
+
+	if (!skb || !priv) {
+		pr_err("[TMI] Invalid input value in rx dispatch\n");
+		ret = -EINVAL;
+		goto end;
+	}
+
+	port_mngr = port->port_mngr;
+
+	skb->len = 0;
+	skb_reset_tail_pointer(skb);
+	skb_put(skb, len);
+
+	ccci_h = mtk_port_strip_header(skb);
+	if (unlikely(!ccci_h)) {
+		dev_warn(port_mngr->ctrl_blk->mdev->dev,
+			 "Unsupported: skb length(%d) is less than ccci header\n",
+			 skb->len);
+		goto drop_data;
+	}
+
+	dev_dbg(port_mngr->ctrl_blk->mdev->dev,
+		"RX header:%08x %08x\n", ccci_h->packet_len, ccci_h->status);
+
+	channel = FIELD_GET(MTK_HDR_FLD_CHN, le32_to_cpu(ccci_h->status));
+	port = mtk_port_search_by_id(port_mngr, channel);
+	if (unlikely(!port)) {
+		dev_warn(port_mngr->ctrl_blk->mdev->dev,
+			 "Failed to find port by channel:%d\n", channel);
+		goto drop_data;
+	}
+
+	ret = mtk_port_check_rx_seq(port, ccci_h);
+	if (unlikely(ret))
+		goto drop_data;
+
+	port->rx_seq = FIELD_GET(MTK_HDR_FLD_SEQ, le32_to_cpu(ccci_h->status));
+
+	ret = ports_ops[port->info.type]->recv(port, skb);
+
+	return ret;
+
+drop_data:
+	dev_kfree_skb_any(skb);
+end:
+	return ret;
+}
+
+int mtk_port_add_header(struct sk_buff *skb)
+{
+	struct mtk_ccci_header *ccci_h;
+	struct mtk_port *port;
+	struct trb *trb;
+	int ret = 0;
+
+	trb = (struct trb *)skb->cb;
+	if (trb->status == 0xADDED)
+		goto end;
+
+	port = trb->priv;
+	if (!port) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	ccci_h = skb_push(skb, sizeof(*ccci_h));
+
+	ccci_h->packet_header = cpu_to_le32(0);
+	ccci_h->packet_len = cpu_to_le32(skb->len);
+	ccci_h->ex_msg = cpu_to_le32(0);
+	ccci_h->status = cpu_to_le32(FIELD_PREP(MTK_HDR_FLD_CHN, port->info.tx_ch) |
+				     FIELD_PREP(MTK_HDR_FLD_SEQ, port->tx_seq++) |
+				     FIELD_PREP(MTK_HDR_FLD_AST, 1));
+
+	trb->status = 0xADDED;
+end:
+	return ret;
+}
+
+struct mtk_ccci_header *mtk_port_strip_header(struct sk_buff *skb)
+{
+	struct mtk_ccci_header *ccci_h;
+
+	if (skb->len < sizeof(*ccci_h)) {
+		pr_err("[TMI] Invalid input value\n");
+		return NULL;
+	}
+
+	ccci_h = (struct mtk_ccci_header *)skb->data;
+	skb_pull(skb, sizeof(*ccci_h));
+
+	return ccci_h;
+}
+
+int mtk_port_mngr_vq_status_check(struct sk_buff *skb)
+{
+	struct trb *trb = (struct trb *)skb->cb;
+	struct trb_open_priv *trb_open_priv;
+	struct mtk_port *port = trb->priv;
+	struct mtk_port_mngr *port_mngr;
+	int ret = 0;
+
+	port_mngr = port->port_mngr;
+	switch (trb->cmd) {
+	case TRB_CMD_ENABLE:
+		port_mngr->vq_info[trb->vqno].port_cnt++;
+		if (port_mngr->vq_info[trb->vqno].port_cnt == 1) {
+			trb_open_priv = (struct trb_open_priv *)skb->data;
+			trb_open_priv->rx_done = mtk_port_rx_dispatch;
+			break;
+		}
+
+		trb->status = -EBUSY;
+		trb->trb_complete(skb);
+		ret = -EBUSY;
+		break;
+	case TRB_CMD_DISABLE:
+		port_mngr->vq_info[trb->vqno].port_cnt--;
+		if (!port_mngr->vq_info[trb->vqno].port_cnt)
+			break;
+
+		dev_info(port_mngr->ctrl_blk->mdev->dev,
+			 "VQ(%d) still has %d port, skip to handle close skb\n",
+			 trb->vqno, port_mngr->vq_info[trb->vqno].port_cnt);
+		trb->status = -EBUSY;
+		trb->trb_complete(skb);
+		ret = -EBUSY;
+		break;
+	default:
+		dev_err(port_mngr->ctrl_blk->mdev->dev, "Invalid trb command(%d)\n", trb->cmd);
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+int mtk_port_vq_enable(struct mtk_port *port)
+{
+	struct mtk_port_mngr *port_mngr = port->port_mngr;
+	struct sk_buff *skb;
+	int ret = -ENOMEM;
+	struct trb *trb;
+
+	skb = __dev_alloc_skb(port->tx_mtu, GFP_KERNEL);
+	if (!skb)
+		goto end;
+
+	skb_put(skb, sizeof(struct trb_open_priv));
+	trb = (struct trb *)skb->cb;
+	mtk_port_trb_init(port, trb, TRB_CMD_ENABLE, mtk_port_open_trb_complete);
+	kref_get(&trb->kref);
+
+	ret = mtk_ctrl_trb_submit(port_mngr->ctrl_blk, skb);
+	if (ret) {
+		dev_err(port_mngr->ctrl_blk->mdev->dev,
+			"Failed to submit trb for port(%s), ret=%d\n", port->info.name, ret);
+		kref_put(&trb->kref, mtk_port_trb_free);
+		mtk_port_trb_free(&trb->kref);
+		goto end;
+	}
+
+start_wait:
+	ret = wait_event_interruptible_timeout(port->trb_wq, trb->status <= 0,
+					       MTK_DFLT_TRB_TIMEOUT);
+	if (ret == -ERESTARTSYS)
+		goto start_wait;
+	else if (!ret)
+		ret = -ETIMEDOUT;
+	else
+		ret = trb->status;
+
+	kref_put(&trb->kref, mtk_port_trb_free);
+
+end:
+	return ret;
+}
+
+int mtk_port_vq_disable(struct mtk_port *port)
+{
+	struct mtk_port_mngr *port_mngr = port->port_mngr;
+	struct sk_buff *skb;
+	int ret = -ENOMEM;
+	struct trb *trb;
+
+	skb = __dev_alloc_skb(port->tx_mtu, GFP_KERNEL);
+	if (!skb)
+		goto end;
+
+	skb_put(skb, sizeof(struct trb_open_priv));
+	trb = (struct trb *)skb->cb;
+	mtk_port_trb_init(port, trb, TRB_CMD_DISABLE, mtk_port_close_trb_complete);
+	kref_get(&trb->kref);
+
+	mutex_lock(&port->write_lock);
+	ret = mtk_ctrl_trb_submit(port_mngr->ctrl_blk, skb);
+	mutex_unlock(&port->write_lock);
+	if (ret) {
+		dev_warn(port_mngr->ctrl_blk->mdev->dev,
+			 "Failed to submit trb for port(%s), ret=%d\n", port->info.name, ret);
+		kref_put(&trb->kref, mtk_port_trb_free);
+		mtk_port_trb_free(&trb->kref);
+		goto end;
+	}
+
+start_wait:
+	ret = wait_event_interruptible(port->trb_wq, trb->status <= 0);
+	if (ret == -ERESTARTSYS)
+		goto start_wait;
+
+	ret = trb->status;
+	kref_put(&trb->kref, mtk_port_trb_free);
+
+end:
+	return ret;
+}
+
+int mtk_port_mngr_init(struct mtk_ctrl_blk *ctrl_blk)
+{
+	struct mtk_port_mngr *port_mngr;
+	struct mtk_stale_list *s_list;
+	int ret = -ENOMEM;
+
+	port_mngr = devm_kzalloc(ctrl_blk->mdev->dev, sizeof(*port_mngr), GFP_KERNEL);
+	if (unlikely(!port_mngr)) {
+		dev_err(ctrl_blk->mdev->dev, "Failed to alloc memory for port_mngr\n");
+		goto end;
+	}
+
+	port_mngr->ctrl_blk = ctrl_blk;
+
+	s_list = mtk_port_stale_list_init(port_mngr);
+	if (!s_list) {
+		dev_err(ctrl_blk->mdev->dev, "Failed to init mtk_stale_list\n");
+		goto free_port_mngr;
+	}
+
+	ret = mtk_port_tbl_create(port_mngr, (struct mtk_port_cfg *)port_cfg,
+				  ARRAY_SIZE(port_cfg), s_list);
+	if (unlikely(ret)) {
+		dev_err(ctrl_blk->mdev->dev, "Failed to create port_tbl\n");
+		goto exit_stale_list;
+	}
+	ctrl_blk->port_mngr = port_mngr;
+	dev_info(ctrl_blk->mdev->dev, "Initialize port_mngr successfully\n");
+
+	return ret;
+
+exit_stale_list:
+	mtk_port_stale_list_exit(port_mngr, s_list);
+free_port_mngr:
+	devm_kfree(ctrl_blk->mdev->dev, port_mngr);
+end:
+	return ret;
+}
+
+void mtk_port_mngr_exit(struct mtk_ctrl_blk *ctrl_blk)
+{
+	struct mtk_port_mngr *port_mngr = ctrl_blk->port_mngr;
+	struct mtk_stale_list *s_list;
+
+	s_list = mtk_port_stale_list_search(port_mngr->ctrl_blk->mdev->dev_str);
+	mtk_port_tbl_destroy(port_mngr, s_list);
+	mtk_port_stale_list_exit(port_mngr, s_list);
+	devm_kfree(ctrl_blk->mdev->dev, port_mngr);
+	ctrl_blk->port_mngr = NULL;
+	dev_info(ctrl_blk->mdev->dev, "Exit port_mngr successfully\n");
+}
diff --git a/drivers/net/wwan/mediatek/mtk_port.h b/drivers/net/wwan/mediatek/mtk_port.h
new file mode 100644
index 000000000000..dd6d47092028
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_port.h
@@ -0,0 +1,171 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_PORT_H__
+#define __MTK_PORT_H__
+
+#include <linux/bits.h>
+#include <linux/mutex.h>
+#include <linux/radix-tree.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+
+#include "mtk_ctrl_plane.h"
+#include "mtk_dev.h"
+
+#define MTK_PEER_ID_MASK	(0xF000)
+#define MTK_PEER_ID_SHIFT	(12)
+#define MTK_PEER_ID(ch)		(((ch) & MTK_PEER_ID_MASK) >> MTK_PEER_ID_SHIFT)
+#define MTK_PEER_ID_SAP		(0x1)
+#define MTK_PEER_ID_MD		(0x2)
+#define MTK_CH_ID_MASK		(0x0FFF)
+#define MTK_CH_ID(ch)		((ch) & MTK_CH_ID_MASK)
+#define MTK_DFLT_MAX_DEV_CNT	(10)
+#define MTK_DFLT_PORT_NAME_LEN	(20)
+
+#define MTK_PORT_TBL_TYPE(ch)	(MTK_PEER_ID(ch) - 1)
+
+#define MTK_CCCI_H_ELEN		(128)
+
+#define MTK_HDR_FLD_AST		((u32)BIT(31))
+#define MTK_HDR_FLD_SEQ		GENMASK(30, 16)
+#define MTK_HDR_FLD_CHN		GENMASK(15, 0)
+
+#define MTK_INFO_FLD_EN		((u16)BIT(15))
+#define MTK_INFO_FLD_CHID	GENMASK(14, 0)
+
+enum mtk_port_status {
+	PORT_S_DFLT = 0,
+	PORT_S_ENABLE,
+	PORT_S_OPEN,
+	PORT_S_RDWR,
+	PORT_S_FLUSH,
+	PORT_S_ON_STALE_LIST,
+};
+
+enum mtk_ccci_ch {
+	CCCI_SAP_CONTROL_RX = 0x1000,
+	CCCI_SAP_CONTROL_TX = 0x1001,
+	CCCI_CONTROL_RX = 0x2000,
+	CCCI_CONTROL_TX = 0x2001,
+};
+
+enum mtk_port_flag {
+	PORT_F_DFLT = 0,
+	PORT_F_BLOCKING = BIT(1),
+	PORT_F_ALLOW_DROP = BIT(2),
+};
+
+enum mtk_port_tbl {
+	PORT_TBL_SAP,
+	PORT_TBL_MD,
+	PORT_TBL_MAX
+};
+
+enum mtk_port_type {
+	PORT_TYPE_INTERNAL,
+	PORT_TYPE_MAX
+};
+
+struct mtk_internal_port {
+	void *arg;
+	int (*recv_cb)(void *arg, struct sk_buff *skb);
+};
+
+union mtk_port_priv {
+	struct mtk_internal_port i_priv;
+};
+
+struct mtk_port_cfg {
+	enum mtk_ccci_ch tx_ch;
+	enum mtk_ccci_ch rx_ch;
+	unsigned char vq_id;
+	enum mtk_port_type type;
+	char name[MTK_DFLT_PORT_NAME_LEN];
+	unsigned char flags;
+};
+
+struct mtk_port {
+	struct mtk_port_cfg info;
+	struct kref kref;
+	bool enable;
+	unsigned long status;
+	unsigned int minor;
+	unsigned short tx_seq;
+	unsigned short rx_seq;
+	unsigned int tx_mtu;
+	unsigned int rx_mtu;
+	struct sk_buff_head rx_skb_list;
+	unsigned int rx_data_len;
+	unsigned int rx_buf_size;
+	wait_queue_head_t trb_wq;
+	wait_queue_head_t rx_wq;
+	/* Use write_lock to lock user's write and disable thread */
+	struct mutex write_lock;
+	/* Used to lock user's read thread */
+	struct mutex read_buf_lock;
+	struct list_head stale_entry;
+	char dev_str[MTK_DEV_STR_LEN];
+	struct mtk_port_mngr *port_mngr;
+	union mtk_port_priv priv;
+};
+
+struct mtk_vq_info {
+	int tx_mtu;
+	int rx_mtu;
+	unsigned int port_cnt;
+	bool color;
+};
+
+struct mtk_port_mngr {
+	struct mtk_ctrl_blk *ctrl_blk;
+	struct radix_tree_root port_tbl[PORT_TBL_MAX];
+	struct mtk_vq_info vq_info[VQ_NUM];
+	struct kobject *port_attr_kobj;
+	int dev_id;
+};
+
+struct mtk_stale_list {
+	struct list_head entry;
+	struct list_head ports;
+	char dev_str[MTK_DEV_STR_LEN];
+	int dev_id;
+};
+
+struct mtk_port_info {
+	__le16 channel;
+	__le16 reserved;
+} __packed;
+
+struct mtk_port_enum_msg {
+	__le32 head_pattern;
+	__le16 port_cnt;
+	__le16 version;
+	__le32 tail_pattern;
+	u8 data[];
+} __packed;
+
+struct mtk_ccci_header {
+	__le32 packet_header;
+	__le32 packet_len;
+	__le32 status;
+	__le32 ex_msg;
+};
+
+extern const struct port_ops *ports_ops[PORT_TYPE_MAX];
+
+void mtk_port_release(struct kref *port_kref);
+struct mtk_port *mtk_port_search_by_name(struct mtk_port_mngr *port_mngr, char *name);
+void mtk_port_stale_list_grp_cleanup(void);
+int mtk_port_add_header(struct sk_buff *skb);
+struct mtk_ccci_header *mtk_port_strip_header(struct sk_buff *skb);
+int mtk_port_send_data(struct mtk_port *port, void *data);
+int mtk_port_vq_enable(struct mtk_port *port);
+int mtk_port_vq_disable(struct mtk_port *port);
+int mtk_port_mngr_vq_status_check(struct sk_buff *skb);
+int mtk_port_mngr_init(struct mtk_ctrl_blk *ctrl_blk);
+void mtk_port_mngr_exit(struct mtk_ctrl_blk *ctrl_blk);
+
+#endif /* __MTK_PORT_H__ */
diff --git a/drivers/net/wwan/mediatek/mtk_port_io.c b/drivers/net/wwan/mediatek/mtk_port_io.c
new file mode 100644
index 000000000000..2ddd131dfe16
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_port_io.c
@@ -0,0 +1,253 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include "mtk_port_io.h"
+
+#define MTK_DFLT_READ_TIMEOUT		(1 * HZ)
+
+static int mtk_port_get_locked(struct mtk_port *port)
+{
+	int ret = 0;
+
+	mutex_lock(&port_mngr_grp_mtx);
+	if (!port) {
+		mutex_unlock(&port_mngr_grp_mtx);
+		pr_err("[TMI] Port does not exist\n");
+		return -ENODEV;
+	}
+	kref_get(&port->kref);
+	mutex_unlock(&port_mngr_grp_mtx);
+
+	return ret;
+}
+
+static void mtk_port_put_locked(struct mtk_port *port)
+{
+	mutex_lock(&port_mngr_grp_mtx);
+	kref_put(&port->kref, mtk_port_release);
+	mutex_unlock(&port_mngr_grp_mtx);
+}
+
+static void mtk_port_struct_init(struct mtk_port *port)
+{
+	port->tx_seq = 0;
+	port->rx_seq = -1;
+	clear_bit(PORT_S_ENABLE, &port->status);
+	kref_init(&port->kref);
+	skb_queue_head_init(&port->rx_skb_list);
+	port->rx_buf_size = MTK_RX_BUF_SIZE;
+	init_waitqueue_head(&port->trb_wq);
+	init_waitqueue_head(&port->rx_wq);
+	mutex_init(&port->read_buf_lock);
+}
+
+static int mtk_port_internal_init(struct mtk_port *port)
+{
+	mtk_port_struct_init(port);
+	port->enable = false;
+
+	return 0;
+}
+
+static int mtk_port_internal_exit(struct mtk_port *port)
+{
+	if (test_bit(PORT_S_ENABLE, &port->status))
+		ports_ops[port->info.type]->disable(port);
+
+	return 0;
+}
+
+static int mtk_port_reset(struct mtk_port *port)
+{
+	port->tx_seq = 0;
+	port->rx_seq = -1;
+
+	return 0;
+}
+
+static int mtk_port_internal_enable(struct mtk_port *port)
+{
+	int ret;
+
+	if (test_bit(PORT_S_ENABLE, &port->status)) {
+		dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+			 "Skip to enable port( %s )\n", port->info.name);
+		return 0;
+	}
+
+	ret = mtk_port_vq_enable(port);
+	if (ret && ret != -EBUSY)
+		return ret;
+
+	set_bit(PORT_S_RDWR, &port->status);
+	set_bit(PORT_S_ENABLE, &port->status);
+	dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+		 "Port(%s) enable is complete\n", port->info.name);
+
+	return 0;
+}
+
+static int mtk_port_internal_disable(struct mtk_port *port)
+{
+	if (!test_and_clear_bit(PORT_S_ENABLE, &port->status)) {
+		dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+			 "Skip to disable port(%s)\n", port->info.name);
+		return 0;
+	}
+
+	clear_bit(PORT_S_RDWR, &port->status);
+	mtk_port_vq_disable(port);
+
+	dev_info(port->port_mngr->ctrl_blk->mdev->dev,
+		 "Port(%s) disable is complete\n", port->info.name);
+
+	return 0;
+}
+
+static int mtk_port_internal_recv(struct mtk_port *port, struct sk_buff *skb)
+{
+	struct mtk_internal_port *priv;
+	int ret = -ENXIO;
+
+	if (!test_bit(PORT_S_OPEN, &port->status)) {
+		dev_warn_ratelimited(port->port_mngr->ctrl_blk->mdev->dev,
+				     "Unabled to recv: (%s) not opened\n", port->info.name);
+		goto drop_data;
+	}
+
+	priv = &port->priv.i_priv;
+	if (!priv->recv_cb || !priv->arg) {
+		dev_warn_ratelimited(port->port_mngr->ctrl_blk->mdev->dev,
+				     "Invalid (%s) recv_cb, drop packet\n", port->info.name);
+		goto drop_data;
+	}
+
+	ret = priv->recv_cb(priv->arg, skb);
+	return ret;
+
+drop_data:
+	dev_kfree_skb_any(skb);
+	return ret;
+}
+
+static int mtk_port_common_open(struct mtk_port *port)
+{
+	int ret = 0;
+
+	if (!test_bit(PORT_S_ENABLE, &port->status)) {
+		pr_err("[TMI] Failed to open: (%s) is disabled\n", port->info.name);
+		ret = -ENODEV;
+		goto end;
+	}
+
+	if (test_bit(PORT_S_OPEN, &port->status)) {
+		dev_warn(port->port_mngr->ctrl_blk->mdev->dev,
+			 "Unabled to open port(%s) twice\n", port->info.name);
+		ret = -EBUSY;
+		goto end;
+	}
+
+	dev_info(port->port_mngr->ctrl_blk->mdev->dev, "Open port %s\n", port->info.name);
+	skb_queue_purge(&port->rx_skb_list);
+	set_bit(PORT_S_OPEN, &port->status);
+
+end:
+	return ret;
+}
+
+static void mtk_port_common_close(struct mtk_port *port)
+{
+	dev_info(port->port_mngr->ctrl_blk->mdev->dev, "Close port %s\n", port->info.name);
+
+	clear_bit(PORT_S_OPEN, &port->status);
+
+	skb_queue_purge(&port->rx_skb_list);
+}
+
+void *mtk_port_internal_open(struct mtk_md_dev *mdev, char *name, int flag)
+{
+	struct mtk_port_mngr *port_mngr;
+	struct mtk_ctrl_blk *ctrl_blk;
+	struct mtk_port *port;
+	int ret;
+
+	ctrl_blk = mdev->ctrl_blk;
+	port_mngr = ctrl_blk->port_mngr;
+
+	port = mtk_port_search_by_name(port_mngr, name);
+	ret = mtk_port_get_locked(port);
+	if (ret)
+		goto end;
+
+	ret = mtk_port_common_open(port);
+	if (ret) {
+		mtk_port_put_locked(port);
+		goto end;
+	}
+
+	if (flag & O_NONBLOCK)
+		port->info.flags &= ~PORT_F_BLOCKING;
+	else
+		port->info.flags |= PORT_F_BLOCKING;
+end:
+	return port;
+}
+
+int mtk_port_internal_close(void *i_port)
+{
+	struct mtk_port *port = i_port;
+	int ret = 0;
+
+	if (!port) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	if (!test_bit(PORT_S_OPEN, &port->status)) {
+		pr_err("[TMI] Port(%s) has been closed\n", port->info.name);
+		ret = -EBADF;
+		goto end;
+	}
+
+	mtk_port_common_close(port);
+	mtk_port_put_locked(port);
+end:
+	return ret;
+}
+
+int mtk_port_internal_write(void *i_port, struct sk_buff *skb)
+{
+	struct mtk_port *port = i_port;
+
+	if (!port)
+		return -EINVAL;
+
+	return mtk_port_send_data(port, skb);
+}
+
+void mtk_port_internal_recv_register(void *i_port,
+				     int (*cb)(void *priv, struct sk_buff *skb),
+				     void *arg)
+{
+	struct mtk_port *port = i_port;
+	struct mtk_internal_port *priv;
+
+	priv = &port->priv.i_priv;
+	priv->arg = arg;
+	priv->recv_cb = cb;
+}
+
+static const struct port_ops port_internal_ops = {
+	.init = mtk_port_internal_init,
+	.exit = mtk_port_internal_exit,
+	.reset = mtk_port_reset,
+	.enable = mtk_port_internal_enable,
+	.disable = mtk_port_internal_disable,
+	.recv = mtk_port_internal_recv,
+};
+
+const struct port_ops *ports_ops[PORT_TYPE_MAX] = {
+	&port_internal_ops,
+};
diff --git a/drivers/net/wwan/mediatek/mtk_port_io.h b/drivers/net/wwan/mediatek/mtk_port_io.h
new file mode 100644
index 000000000000..30e1d4149881
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_port_io.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_PORT_IO_H__
+#define __MTK_PORT_IO_H__
+
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+
+#include "mtk_port.h"
+
+#define MTK_RX_BUF_SIZE			(1024 * 1024)
+
+extern struct mutex port_mngr_grp_mtx;
+
+struct port_ops {
+	int (*init)(struct mtk_port *port);
+	int (*exit)(struct mtk_port *port);
+	int (*reset)(struct mtk_port *port);
+	int (*enable)(struct mtk_port *port);
+	int (*disable)(struct mtk_port *port);
+	int (*recv)(struct mtk_port *port, struct sk_buff *skb);
+};
+
+void *mtk_port_internal_open(struct mtk_md_dev *mdev, char *name, int flag);
+int mtk_port_internal_close(void *i_port);
+int mtk_port_internal_write(void *i_port, struct sk_buff *skb);
+void mtk_port_internal_recv_register(void *i_port,
+				     int (*cb)(void *priv, struct sk_buff *skb),
+				     void *arg);
+
+#endif /* __MTK_PORT_IO_H__ */
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.c b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
index b3de9634a62c..d1cf4bf10f6a 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_pci.c
+++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#include "../mtk_port_io.h"
 #include "mtk_pci.h"
 #include "mtk_reg.h"
 
@@ -943,6 +944,7 @@ module_init(mtk_drv_init);
 static void __exit mtk_drv_exit(void)
 {
 	pci_unregister_driver(&mtk_pci_drv);
+	mtk_port_stale_list_grp_cleanup();
 }
 module_exit(mtk_drv_exit);
 
-- 
2.32.0

