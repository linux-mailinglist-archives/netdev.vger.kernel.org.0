Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C66671BE2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjARMUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjARMTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:19:00 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545294B4BC;
        Wed, 18 Jan 2023 03:41:51 -0800 (PST)
X-UUID: 16338152972511ed945fc101203acc17-20230118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=eas6wIFBuQy7UzkrK500VJMgeato0L4fG/5Di/9irl4=;
        b=jAId+x8lnJaBqDJpEHF7NqjJh2I293CXYUbeKxPi7B2d8vNbix9NR02SQLaJB3JAdvlj4S2N8+mo8ML0S1PCXrrWfT0A4EPrNPfx+v9whlmg1cq2k1urHZK8wB5gi/T/tf46i00WO4gLF+g6O5yZ737vT0vow4SgQE1nWZo/ARA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:074018e9-03d1-4c78-aa52-d563e27e4a08,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:70
X-CID-INFO: VERSION:1.1.18,REQID:074018e9-03d1-4c78-aa52-d563e27e4a08,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:70
X-CID-META: VersionHash:3ca2d6b,CLOUDID:26792df6-ff42-4fb0-b929-626456a83c14,B
        ulkID:2301181941477PXH0II6,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
        I:0,OSA:0
X-CID-BVR: 0,NGT
X-UUID: 16338152972511ed945fc101203acc17-20230118
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1737762517; Wed, 18 Jan 2023 19:41:46 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 18 Jan 2023 19:41:44 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 18 Jan 2023 19:41:42 +0800
From:   Yanchao Yang <yanchao.yang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
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
        "Yanchao Yang" <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: [PATCH net-next v2 03/12] net: wwan: tmi: Add control DMA interface
Date:   Wed, 18 Jan 2023 19:38:50 +0800
Message-ID: <20230118113859.175836-4-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230118113859.175836-1-yanchao.yang@mediatek.com>
References: <20230118113859.175836-1-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cross Layer Direct Memory Access(CLDMA) is the hardware interface used by the
control plane and designated to translate data between the host and the device.
It supports 8 hardware queues for the device AP and modem respectively.

CLDMA driver uses General Purpose Descriptor (GPD) to describe transaction
information that can be recognized by CLDMA hardware.
Once CLDMA hardware transaction is started, it would fetch and parse GPD to
transfer data correctly.
To facilitate the CLDMA transaction, a GPD ring for each queue is used.
Once the transaction is started, CLDMA hardware will traverse the GPD ring
to transfer data between the host and the device until no GPD is available.

CLDMA TX flow:
Once a TX service receives the TX data from the port layer, it uses APIs
exported by the CLDMA driver to configure GPD with the DMA address of TX data.
After that, the service triggers CLDMA to fetch the first available GPD to
transfer data.

CLDMA RX flow:
When there is RX data from the MD, CLDMA hardware asserts an interrupt to
notify the host to fetch data and dispatch it to FSM (for handshake messages)
or the port layer.
After CLDMA opening is finished, All RX GPDs are fulfilled and ready to receive
data from the device.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
Signed-off-by: Min Dong <min.dong@mediatek.com>
---
 drivers/net/wwan/mediatek/Makefile            |   6 +-
 drivers/net/wwan/mediatek/mtk_cldma.c         | 260 +++++
 drivers/net/wwan/mediatek/mtk_cldma.h         | 158 +++
 drivers/net/wwan/mediatek/mtk_ctrl_plane.h    |  48 +
 .../wwan/mediatek/pcie/mtk_cldma_drv_t800.c   | 939 ++++++++++++++++++
 .../wwan/mediatek/pcie/mtk_cldma_drv_t800.h   |  20 +
 6 files changed, 1429 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wwan/mediatek/mtk_cldma.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_cldma.h
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index 192f08e08a33..f607fb1dad6e 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -4,8 +4,10 @@ MODULE_NAME := mtk_tmi
 
 mtk_tmi-y = \
 	pcie/mtk_pci.o	\
-	mtk_dev.o	\
-	mtk_ctrl_plane.o
+	mtk_dev.o \
+	mtk_ctrl_plane.o \
+	mtk_cldma.o \
+	pcie/mtk_cldma_drv_t800.o
 
 ccflags-y += -I$(srctree)/$(src)/
 ccflags-y += -I$(srctree)/$(src)/pcie/
diff --git a/drivers/net/wwan/mediatek/mtk_cldma.c b/drivers/net/wwan/mediatek/mtk_cldma.c
new file mode 100644
index 000000000000..f9531f48f898
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_cldma.c
@@ -0,0 +1,260 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/pm_runtime.h>
+#include <linux/skbuff.h>
+
+#include "mtk_cldma.h"
+#include "mtk_cldma_drv_t800.h"
+
+/**
+ * mtk_cldma_init() - Initialize CLDMA
+ * @trans: pointer to transaction structure
+ *
+ * Return:
+ * * 0 - OK
+ * * -ENOMEM - out of memory
+ */
+static int mtk_cldma_init(struct mtk_ctrl_trans *trans)
+{
+	struct cldma_dev *cd;
+
+	cd = devm_kzalloc(trans->mdev->dev, sizeof(*cd), GFP_KERNEL);
+	if (!cd)
+		return -ENOMEM;
+
+	cd->trans = trans;
+	cd->hw_ops.init = mtk_cldma_hw_init_t800;
+	cd->hw_ops.exit = mtk_cldma_hw_exit_t800;
+	cd->hw_ops.txq_alloc = mtk_cldma_txq_alloc_t800;
+	cd->hw_ops.rxq_alloc = mtk_cldma_rxq_alloc_t800;
+	cd->hw_ops.txq_free = mtk_cldma_txq_free_t800;
+	cd->hw_ops.rxq_free = mtk_cldma_rxq_free_t800;
+	cd->hw_ops.start_xfer = mtk_cldma_start_xfer_t800;
+
+	trans->dev[CLDMA_CLASS_ID] = cd;
+
+	return 0;
+}
+
+/**
+ * mtk_cldma_exit() - De-Initialize CLDMA
+ * @trans: pointer to transaction structure
+ *
+ * Return:
+ * * 0 - OK
+ */
+static int mtk_cldma_exit(struct mtk_ctrl_trans *trans)
+{
+	struct cldma_dev *cd;
+
+	cd = trans->dev[CLDMA_CLASS_ID];
+	if (!cd)
+		return 0;
+
+	devm_kfree(trans->mdev->dev, cd);
+
+	return 0;
+}
+
+/**
+ * mtk_cldma_open() - Initialize CLDMA hardware queue
+ * @cd: pointer to CLDMA device
+ * @skb: pointer to socket buffer
+ *
+ * Return:
+ * * 0 - OK
+ * * -EBUSY - hardware queue is busy
+ * * -EIO - failed to initialize hardware queue
+ * * -EINVAL - invalid input parameters
+ */
+static int mtk_cldma_open(struct cldma_dev *cd, struct sk_buff *skb)
+{
+	struct trb_open_priv *trb_open_priv = (struct trb_open_priv *)skb->data;
+	struct trb *trb = (struct trb *)skb->cb;
+	struct cldma_hw *hw;
+	struct virtq *vq;
+	struct txq *txq;
+	struct rxq *rxq;
+	int err = 0;
+
+	vq = cd->trans->vq_tbl + trb->vqno;
+	hw = cd->cldma_hw[vq->hif_id & HIF_ID_BITMASK];
+	trb_open_priv->tx_mtu = vq->tx_mtu;
+	trb_open_priv->rx_mtu = vq->rx_mtu;
+	if (unlikely(vq->rxqno < 0 || vq->rxqno >= HW_QUEUE_NUM) ||
+	    unlikely(vq->txqno < 0 || vq->txqno >= HW_QUEUE_NUM)) {
+		err = -EINVAL;
+		goto exit;
+	}
+
+	if (hw->txq[vq->txqno] || hw->rxq[vq->rxqno]) {
+		err = -EBUSY;
+		goto exit;
+	}
+
+	txq = cd->hw_ops.txq_alloc(hw, skb);
+	if (!txq) {
+		err = -EIO;
+		goto exit;
+	}
+
+	rxq = cd->hw_ops.rxq_alloc(hw, skb);
+	if (!rxq) {
+		err = -EIO;
+		cd->hw_ops.txq_free(hw, trb->vqno);
+		goto exit;
+	}
+
+exit:
+	trb->status = err;
+	trb->trb_complete(skb);
+
+	return err;
+}
+
+/**
+ * mtk_cldma_tx() - start CLDMA TX transaction
+ * @cd: pointer to CLDMA device
+ * @skb: pointer to socket buffer
+ *
+ * Return:
+ * * 0 - OK
+ * * -EPIPE - hardware queue is broken
+ */
+static int mtk_cldma_tx(struct cldma_dev *cd, struct sk_buff *skb)
+{
+	struct trb *trb = (struct trb *)skb->cb;
+	struct cldma_hw *hw;
+	struct virtq *vq;
+	struct txq *txq;
+
+	vq = cd->trans->vq_tbl + trb->vqno;
+	hw = cd->cldma_hw[vq->hif_id & HIF_ID_BITMASK];
+	txq = hw->txq[vq->txqno];
+	if (txq->is_stopping)
+		return -EPIPE;
+
+	cd->hw_ops.start_xfer(hw, vq->txqno);
+
+	return 0;
+}
+
+/**
+ * mtk_cldma_close() - De-Initialize CLDMA hardware queue
+ * @cd: pointer to CLDMA device
+ * @skb: pointer to socket buffer
+ *
+ * Return:
+ * * 0 - OK
+ */
+static int mtk_cldma_close(struct cldma_dev *cd, struct sk_buff *skb)
+{
+	struct trb *trb = (struct trb *)skb->cb;
+	struct cldma_hw *hw;
+	struct virtq *vq;
+
+	vq = cd->trans->vq_tbl + trb->vqno;
+	hw = cd->cldma_hw[vq->hif_id & HIF_ID_BITMASK];
+
+	cd->hw_ops.txq_free(hw, trb->vqno);
+	cd->hw_ops.rxq_free(hw, trb->vqno);
+
+	trb->status = 0;
+	trb->trb_complete(skb);
+
+	return 0;
+}
+
+static int mtk_cldma_submit_tx(void *dev, struct sk_buff *skb)
+{
+	struct trb *trb = (struct trb *)skb->cb;
+	struct cldma_dev *cd = dev;
+	dma_addr_t data_dma_addr;
+	struct cldma_hw *hw;
+	struct tx_req *req;
+	struct virtq *vq;
+	struct txq *txq;
+	int err;
+
+	vq = cd->trans->vq_tbl + trb->vqno;
+	hw = cd->cldma_hw[vq->hif_id & HIF_ID_BITMASK];
+	txq = hw->txq[vq->txqno];
+
+	if (!txq->req_budget)
+		return -EAGAIN;
+
+	data_dma_addr = dma_map_single(hw->mdev->dev, skb->data, skb->len, DMA_TO_DEVICE);
+	err = dma_mapping_error(hw->mdev->dev, data_dma_addr);
+	if (unlikely(err)) {
+		dev_err(hw->mdev->dev, "Failed to map dma!\n");
+		return err;
+	}
+
+	mutex_lock(&txq->lock);
+	txq->req_budget--;
+	mutex_unlock(&txq->lock);
+
+	req = txq->req_pool + txq->wr_idx;
+	req->gpd->tx_gpd.debug_id = 0x01;
+	req->gpd->tx_gpd.data_buff_ptr_h = cpu_to_le32((u64)(data_dma_addr) >> 32);
+	req->gpd->tx_gpd.data_buff_ptr_l = cpu_to_le32(data_dma_addr);
+	req->gpd->tx_gpd.data_buff_len = cpu_to_le16(skb->len);
+	req->gpd->tx_gpd.gpd_flags = CLDMA_GPD_FLAG_IOC | CLDMA_GPD_FLAG_HWO;
+
+	req->data_vm_addr = skb->data;
+	req->data_dma_addr = data_dma_addr;
+	req->data_len = skb->len;
+	req->skb = skb;
+	txq->wr_idx = (txq->wr_idx + 1) % txq->req_pool_size;
+
+	wmb(); /* ensure GPD setup done before HW start */
+
+	return 0;
+}
+
+/**
+ * mtk_cldma_trb_process() - Dispatch trb request to low-level CLDMA routine
+ * @dev: pointer to CLDMA device
+ * @skb: pointer to socket buffer
+ *
+ * Return:
+ * * 0 - OK
+ * * -EBUSY - hardware queue is busy
+ * * -EINVAL - invalid input
+ * * -EIO - failed to initialize hardware queue
+ * * -EPIPE - hardware queue is broken
+ */
+static int mtk_cldma_trb_process(void *dev, struct sk_buff *skb)
+{
+	struct trb *trb = (struct trb *)skb->cb;
+	struct cldma_dev *cd = dev;
+	int err;
+
+	switch (trb->cmd) {
+	case TRB_CMD_ENABLE:
+		err = mtk_cldma_open(cd, skb);
+		break;
+	case TRB_CMD_TX:
+		err = mtk_cldma_tx(cd, skb);
+		break;
+	case TRB_CMD_DISABLE:
+		err = mtk_cldma_close(cd, skb);
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+struct hif_ops cldma_ops = {
+	.init = mtk_cldma_init,
+	.exit = mtk_cldma_exit,
+	.trb_process = mtk_cldma_trb_process,
+	.submit_tx = mtk_cldma_submit_tx,
+};
diff --git a/drivers/net/wwan/mediatek/mtk_cldma.h b/drivers/net/wwan/mediatek/mtk_cldma.h
new file mode 100644
index 000000000000..4fd5f826bcf6
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_cldma.h
@@ -0,0 +1,158 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_CLDMA_H__
+#define __MTK_CLDMA_H__
+
+#include <linux/types.h>
+
+#include "mtk_ctrl_plane.h"
+#include "mtk_dev.h"
+
+#define HW_QUEUE_NUM				8
+#define ALLQ					(0XFF)
+#define LINK_ERROR_VAL				(0XFFFFFFFF)
+
+#define CLDMA_CLASS_ID				0
+
+#define NR_CLDMA				2
+#define CLDMA0					(((CLDMA_CLASS_ID) << HIF_CLASS_SHIFT) + 0)
+#define CLDMA1					(((CLDMA_CLASS_ID) << HIF_CLASS_SHIFT) + 1)
+
+#define TXQ(N)					(N)
+#define RXQ(N)					(N)
+
+#define CLDMA_GPD_FLAG_HWO			BIT(0)
+#define CLDMA_GPD_FLAG_IOC			BIT(7)
+
+enum mtk_ip_busy_src {
+	IP_BUSY_TXDONE = 0,
+	IP_BUSY_RXDONE = 24,
+};
+
+enum mtk_intr_type {
+	QUEUE_XFER_DONE = 0,
+	QUEUE_ERROR = 16,
+	INVALID_TYPE
+};
+
+enum mtk_tx_rx {
+	DIR_TX,
+	DIR_RX,
+	INVALID_DIR
+};
+
+union gpd {
+	struct {
+		u8 gpd_flags;
+		u8 non_used1;
+		__le16 data_allow_len;
+		__le32 next_gpd_ptr_h;
+		__le32 next_gpd_ptr_l;
+		__le32 data_buff_ptr_h;
+		__le32 data_buff_ptr_l;
+		__le16 data_recv_len;
+		u8 non_used2;
+		u8 debug_id;
+	} rx_gpd;
+
+	struct {
+		u8 gpd_flags;
+		u8 non_used1;
+		u8 non_used2;
+		u8 debug_id;
+		__le32 next_gpd_ptr_h;
+		__le32 next_gpd_ptr_l;
+		__le32 data_buff_ptr_h;
+		__le32 data_buff_ptr_l;
+		__le16 data_buff_len;
+		__le16 non_used3;
+	} tx_gpd;
+};
+
+struct rx_req {
+	union gpd *gpd;
+	int mtu;
+	struct sk_buff *skb;
+	size_t data_len;
+	dma_addr_t gpd_dma_addr;
+	dma_addr_t data_dma_addr;
+};
+
+struct rxq {
+	struct cldma_hw *hw;
+	int rxqno;
+	int vqno;
+	struct virtq *vq;
+	struct work_struct rx_done_work;
+	struct rx_req *req_pool;
+	int req_pool_size;
+	int free_idx;
+	unsigned short rx_done_cnt;
+	void *arg;
+	int (*rx_done)(struct sk_buff *skb, int len, void *priv);
+};
+
+struct tx_req {
+	union gpd *gpd;
+	int mtu;
+	void *data_vm_addr;
+	size_t data_len;
+	dma_addr_t data_dma_addr;
+	dma_addr_t gpd_dma_addr;
+	struct sk_buff *skb;
+	int (*trb_complete)(struct sk_buff *skb);
+};
+
+struct txq {
+	struct cldma_hw *hw;
+	int txqno;
+	int vqno;
+	struct virtq *vq;
+	struct mutex lock; /* protect structure fields */
+	struct work_struct tx_done_work;
+	struct tx_req *req_pool;
+	int req_pool_size;
+	int req_budget;
+	int wr_idx;
+	int free_idx;
+	bool tx_started;
+	bool is_stopping;
+	unsigned short tx_done_cnt;
+};
+
+struct cldma_dev;
+struct cldma_hw;
+
+struct cldma_hw_ops {
+	int (*init)(struct cldma_dev *cd, int hif_id);
+	int (*exit)(struct cldma_dev *cd, int hif_id);
+	struct txq* (*txq_alloc)(struct cldma_hw *hw, struct sk_buff *skb);
+	struct rxq* (*rxq_alloc)(struct cldma_hw *hw, struct sk_buff *skb);
+	int (*txq_free)(struct cldma_hw *hw, int vqno);
+	int (*rxq_free)(struct cldma_hw *hw, int vqno);
+	int (*start_xfer)(struct cldma_hw *hw, int qno);
+};
+
+struct cldma_hw {
+	int hif_id;
+	int base_addr;
+	int pci_ext_irq_id;
+	struct mtk_md_dev *mdev;
+	struct cldma_dev *cd;
+	struct txq *txq[HW_QUEUE_NUM];
+	struct rxq *rxq[HW_QUEUE_NUM];
+	struct dma_pool *dma_pool;
+	struct workqueue_struct *wq;
+};
+
+struct cldma_dev {
+	struct cldma_hw *cldma_hw[NR_CLDMA];
+	struct mtk_ctrl_trans *trans;
+	struct cldma_hw_ops hw_ops;
+};
+
+extern struct hif_ops cldma_ops;
+#endif
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
index 77af4248cb74..32cd8dc7bdb7 100644
--- a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
@@ -14,7 +14,55 @@
 #define VQ_MTU_3_5K			(0xE00)
 #define VQ_MTU_63K			(0xFC00)
 
+#define HIF_CLASS_NUM			(1)
+#define HIF_CLASS_SHIFT			(8)
+#define HIF_ID_BITMASK			(0x01)
+
+enum mtk_trb_cmd_type {
+	TRB_CMD_ENABLE = 1,
+	TRB_CMD_TX,
+	TRB_CMD_DISABLE,
+};
+
+struct trb_open_priv {
+	u16 tx_mtu;
+	u16 rx_mtu;
+	int (*rx_done)(struct sk_buff *skb, int len, void *priv);
+};
+
+struct trb {
+	u8 vqno;
+	enum mtk_trb_cmd_type cmd;
+	int status;
+	struct kref kref;
+	void *priv;
+	int (*trb_complete)(struct sk_buff *skb);
+};
+
+struct virtq {
+	int vqno;
+	int hif_id;
+	int txqno;
+	int rxqno;
+	int tx_mtu;
+	int rx_mtu;
+	int tx_req_num;
+	int rx_req_num;
+};
+
+struct mtk_ctrl_trans;
+
+struct hif_ops {
+	int (*init)(struct mtk_ctrl_trans *trans);
+	int (*exit)(struct mtk_ctrl_trans *trans);
+	int (*submit_tx)(void *dev, struct sk_buff *skb);
+	int (*trb_process)(void *dev, struct sk_buff *skb);
+};
+
 struct mtk_ctrl_trans {
+	struct virtq *vq_tbl;
+	void *dev[HIF_CLASS_NUM];
+	struct hif_ops *ops[HIF_CLASS_NUM];
 	struct mtk_ctrl_blk *ctrl_blk;
 	struct mtk_md_dev *mdev;
 };
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
new file mode 100644
index 000000000000..bd9a7a7bf18f
--- /dev/null
+++ b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
@@ -0,0 +1,939 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/pm_runtime.h>
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+
+#include "mtk_cldma_drv_t800.h"
+#include "mtk_ctrl_plane.h"
+#include "mtk_dev.h"
+#include "mtk_reg.h"
+
+#define DMA_POOL_NAME_LEN	64
+
+#define CLDMA_STOP_HW_WAIT_TIME_MS		(20)
+#define CLDMA_STOP_HW_POLLING_MAX_CNT	(10)
+
+#define CLDMA0_BASE_ADDR				(0x1021C000)
+#define CLDMA1_BASE_ADDR				(0x1021E000)
+
+/* CLDMA IN(Tx) */
+#define REG_CLDMA_UL_START_ADDRL_0			(0x0004)
+#define REG_CLDMA_UL_START_ADDRH_0			(0x0008)
+#define REG_CLDMA_UL_STATUS				(0x0084)
+#define REG_CLDMA_UL_START_CMD				(0x0088)
+#define REG_CLDMA_UL_RESUME_CMD				(0x008C)
+#define REG_CLDMA_UL_STOP_CMD				(0x0090)
+#define REG_CLDMA_UL_ERROR				(0x0094)
+#define REG_CLDMA_UL_CFG				(0x0098)
+#define REG_CLDMA_UL_DUMMY_0				(0x009C)
+
+/* CLDMA OUT(Rx) */
+#define REG_CLDMA_SO_START_CMD				(0x0400 + 0x01BC)
+#define REG_CLDMA_SO_RESUME_CMD				(0x0400 + 0x01C0)
+#define REG_CLDMA_SO_STOP_CMD				(0x0400 + 0x01C4)
+#define REG_CLDMA_SO_DUMMY_0				(0x0400 + 0x0108)
+#define REG_CLDMA_SO_CFG				(0x0400 + 0x0004)
+#define REG_CLDMA_SO_START_ADDRL_0			(0x0400 + 0x0078)
+#define REG_CLDMA_SO_START_ADDRH_0			(0x0400 + 0x007C)
+#define REG_CLDMA_SO_CUR_ADDRL_0			(0x0400 + 0x00B8)
+#define REG_CLDMA_SO_CUR_ADDRH_0			(0x0400 + 0x00BC)
+#define REG_CLDMA_SO_STATUS				(0x0400 + 0x00F8)
+
+/* CLDMA MISC */
+#define REG_CLDMA_L2TISAR0				(0x0800 + 0x0010)
+#define REG_CLDMA_L2TISAR1				(0x0800 + 0x0014)
+#define REG_CLDMA_L2TIMR0				(0x0800 + 0x0018)
+#define REG_CLDMA_L2TIMR1				(0x0800 + 0x001C)
+#define REG_CLDMA_L2TIMCR0				(0x0800 + 0x0020)
+#define REG_CLDMA_L2TIMCR1				(0x0800 + 0x0024)
+#define REG_CLDMA_L2TIMSR0				(0x0800 + 0x0028)
+#define REG_CLDMA_L2TIMSR1				(0x0800 + 0x002C)
+#define REG_CLDMA_L3TISAR0				(0x0800 + 0x0030)
+#define REG_CLDMA_L3TISAR1				(0x0800 + 0x0034)
+#define REG_CLDMA_L3TIMR0				(0x0800 + 0x0038)
+#define REG_CLDMA_L3TIMR1				(0x0800 + 0x003C)
+#define REG_CLDMA_L3TIMCR0				(0x0800 + 0x0040)
+#define REG_CLDMA_L3TIMCR1				(0x0800 + 0x0044)
+#define REG_CLDMA_L3TIMSR0				(0x0800 + 0x0048)
+#define REG_CLDMA_L3TIMSR1				(0x0800 + 0x004C)
+#define REG_CLDMA_L2RISAR0				(0x0800 + 0x0050)
+#define REG_CLDMA_L2RISAR1				(0x0800 + 0x0054)
+#define REG_CLDMA_L3RISAR0				(0x0800 + 0x0070)
+#define REG_CLDMA_L3RISAR1				(0x0800 + 0x0074)
+#define REG_CLDMA_L3RIMR0				(0x0800 + 0x0078)
+#define REG_CLDMA_L3RIMR1				(0x0800 + 0x007C)
+#define REG_CLDMA_L3RIMCR0				(0x0800 + 0x0080)
+#define REG_CLDMA_L3RIMCR1				(0x0800 + 0x0084)
+#define REG_CLDMA_L3RIMSR0				(0x0800 + 0x0088)
+#define REG_CLDMA_L3RIMSR1				(0x0800 + 0x008C)
+#define REG_CLDMA_IP_BUSY				(0x0800 + 0x00B4)
+#define REG_CLDMA_L3TISAR2				(0x0800 + 0x00C0)
+#define REG_CLDMA_L3TIMR2				(0x0800 + 0x00C4)
+#define REG_CLDMA_L3TIMCR2				(0x0800 + 0x00C8)
+#define REG_CLDMA_L3TIMSR2				(0x0800 + 0x00CC)
+
+#define REG_CLDMA_L2RIMR0				(0x0800 + 0x00E8)
+#define REG_CLDMA_L2RIMR1				(0x0800 + 0x00EC)
+#define REG_CLDMA_L2RIMCR0				(0x0800 + 0x00F0)
+#define REG_CLDMA_L2RIMCR1				(0x0800 + 0x00F4)
+#define REG_CLDMA_L2RIMSR0				(0x0800 + 0x00F8)
+#define REG_CLDMA_L2RIMSR1				(0x0800 + 0x00FC)
+
+#define REG_CLDMA_INT_EAP_USIP_MASK			(0x0800 + 0x011C)
+#define REG_CLDMA_RQ1_GPD_DONE_CNT			(0x0800 + 0x0174)
+#define REG_CLDMA_TQ1_GPD_DONE_CNT			(0x0800 + 0x0184)
+
+#define REG_CLDMA_IP_BUSY_TO_PCIE_MASK			(0x0800 + 0x0194)
+#define REG_CLDMA_IP_BUSY_TO_PCIE_MASK_SET		(0x0800 + 0x0198)
+#define REG_CLDMA_IP_BUSY_TO_PCIE_MASK_CLR		(0x0800 + 0x019C)
+
+#define REG_CLDMA_IP_BUSY_TO_AP_MASK			(0x0800 + 0x0200)
+#define REG_CLDMA_IP_BUSY_TO_AP_MASK_SET		(0x0800 + 0x0204)
+#define REG_CLDMA_IP_BUSY_TO_AP_MASK_CLR		(0x0800 + 0x0208)
+
+/* CLDMA RESET */
+#define REG_INFRA_RST0_SET				(0x120)
+#define REG_INFRA_RST0_CLR				(0x124)
+#define REG_CLDMA0_RST_SET_BIT				(8)
+#define REG_CLDMA0_RST_CLR_BIT				(8)
+
+static void mtk_cldma_setup_start_addr(struct mtk_md_dev *mdev, int base,
+				       enum mtk_tx_rx dir, int qno, dma_addr_t addr)
+{
+	unsigned int addr_l;
+	unsigned int addr_h;
+
+	if (dir == DIR_TX) {
+		addr_l = base + REG_CLDMA_UL_START_ADDRL_0 + qno * HW_QUEUE_NUM;
+		addr_h = base + REG_CLDMA_UL_START_ADDRH_0 + qno * HW_QUEUE_NUM;
+	} else {
+		addr_l = base + REG_CLDMA_SO_START_ADDRL_0 + qno * HW_QUEUE_NUM;
+		addr_h = base + REG_CLDMA_SO_START_ADDRH_0 + qno * HW_QUEUE_NUM;
+	}
+
+	mtk_hw_write32(mdev, addr_l, (u32)addr);
+	mtk_hw_write32(mdev, addr_h, (u32)((u64)addr >> 32));
+}
+
+static void mtk_cldma_mask_intr(struct mtk_md_dev *mdev, int base,
+				enum mtk_tx_rx dir, int qno, enum mtk_intr_type type)
+{
+	u32 addr;
+	u32 val;
+
+	if (unlikely(qno < 0 || qno >= HW_QUEUE_NUM))
+		return;
+
+	if (dir == DIR_TX)
+		addr = base + REG_CLDMA_L2TIMSR0;
+	else
+		addr = base + REG_CLDMA_L2RIMSR0;
+
+	if (qno == ALLQ)
+		val = qno << type;
+	else
+		val = BIT(qno) << type;
+
+	mtk_hw_write32(mdev, addr, val);
+}
+
+static void mtk_cldma_unmask_intr(struct mtk_md_dev *mdev, int base,
+				  enum mtk_tx_rx dir, int qno, enum mtk_intr_type type)
+{
+	u32 addr;
+	u32 val;
+
+	if (unlikely(qno < 0 || qno >= HW_QUEUE_NUM))
+		return;
+
+	if (dir == DIR_TX)
+		addr = base + REG_CLDMA_L2TIMCR0;
+	else
+		addr = base + REG_CLDMA_L2RIMCR0;
+
+	if (qno == ALLQ)
+		val = qno << type;
+	else
+		val = BIT(qno) << type;
+
+	mtk_hw_write32(mdev, addr, val);
+}
+
+static void mtk_cldma_clr_intr_status(struct mtk_md_dev *mdev, int base,
+				      int dir, int qno, enum mtk_intr_type type)
+{
+	u32 addr;
+	u32 val;
+
+	if (unlikely(qno < 0 || qno >= HW_QUEUE_NUM))
+		return;
+
+	if (type == QUEUE_ERROR) {
+		if (dir == DIR_TX) {
+			val = mtk_hw_read32(mdev, base + REG_CLDMA_L3TISAR0);
+			mtk_hw_write32(mdev, base + REG_CLDMA_L3TISAR0, val);
+			val = mtk_hw_read32(mdev, base + REG_CLDMA_L3TISAR1);
+			mtk_hw_write32(mdev, base + REG_CLDMA_L3TISAR1, val);
+		} else {
+			val = mtk_hw_read32(mdev, base + REG_CLDMA_L3RISAR0);
+			mtk_hw_write32(mdev, base + REG_CLDMA_L3RISAR0, val);
+			val = mtk_hw_read32(mdev, base + REG_CLDMA_L3RISAR1);
+			mtk_hw_write32(mdev, base + REG_CLDMA_L3RISAR1, val);
+		}
+	}
+
+	if (dir == DIR_TX)
+		addr = base + REG_CLDMA_L2TISAR0;
+	else
+		addr = base + REG_CLDMA_L2RISAR0;
+
+	if (qno == ALLQ)
+		val = qno << type;
+	else
+		val = BIT(qno) << type;
+
+	mtk_hw_write32(mdev, addr, val);
+	val = mtk_hw_read32(mdev, addr);
+}
+
+static u32 mtk_cldma_check_intr_status(struct mtk_md_dev *mdev, int base,
+				       int dir, int qno, enum mtk_intr_type type)
+{
+	u32 addr;
+	u32 val;
+	u32 sta;
+
+	if (dir == DIR_TX)
+		addr = base + REG_CLDMA_L2TISAR0;
+	else
+		addr = base + REG_CLDMA_L2RISAR0;
+
+	val = mtk_hw_read32(mdev, addr);
+	if (val == LINK_ERROR_VAL)
+		sta = val;
+	else if (qno == ALLQ)
+		sta = (val >> type) & 0xFF;
+	else
+		sta = (val >> type) & BIT(qno);
+	return sta;
+}
+
+static void mtk_cldma_start_queue(struct mtk_md_dev *mdev, int base, enum mtk_tx_rx dir, int qno)
+{
+	u32 val = BIT(qno);
+	u32 addr;
+
+	if (dir == DIR_TX)
+		addr = base + REG_CLDMA_UL_START_CMD;
+	else
+		addr = base + REG_CLDMA_SO_START_CMD;
+
+	mtk_hw_write32(mdev, addr, val);
+}
+
+static void mtk_cldma_resume_queue(struct mtk_md_dev *mdev, int base, enum mtk_tx_rx dir, int qno)
+{
+	u32 val = BIT(qno);
+	u32 addr;
+
+	if (dir == DIR_TX)
+		addr = base + REG_CLDMA_UL_RESUME_CMD;
+	else
+		addr = base + REG_CLDMA_SO_RESUME_CMD;
+
+	mtk_hw_write32(mdev, addr, val);
+}
+
+static u32 mtk_cldma_queue_status(struct mtk_md_dev *mdev, int base, enum mtk_tx_rx dir, int qno)
+{
+	u32 addr;
+	u32 val;
+
+	if (dir == DIR_TX)
+		addr = base + REG_CLDMA_UL_STATUS;
+	else
+		addr = base + REG_CLDMA_SO_STATUS;
+
+	val = mtk_hw_read32(mdev, addr);
+
+	if (qno == ALLQ || val == LINK_ERROR_VAL)
+		return val;
+	else
+		return val & BIT(qno);
+}
+
+static void mtk_cldma_mask_ip_busy_to_pci(struct mtk_md_dev *mdev,
+					  int base, int qno, enum mtk_ip_busy_src type)
+{
+	if (qno == ALLQ)
+		mtk_hw_write32(mdev, base + REG_CLDMA_IP_BUSY_TO_PCIE_MASK_SET, qno << type);
+	else
+		mtk_hw_write32(mdev, base + REG_CLDMA_IP_BUSY_TO_PCIE_MASK_SET, BIT(qno) << type);
+}
+
+static void mtk_cldma_unmask_ip_busy_to_pci(struct mtk_md_dev *mdev,
+					    int base, int qno, enum mtk_ip_busy_src type)
+{
+	if (qno == ALLQ)
+		mtk_hw_write32(mdev, base + REG_CLDMA_IP_BUSY_TO_PCIE_MASK_CLR, qno << type);
+	else
+		mtk_hw_write32(mdev, base + REG_CLDMA_IP_BUSY_TO_PCIE_MASK_CLR, BIT(qno) << type);
+}
+
+static void mtk_cldma_stop_queue(struct mtk_md_dev *mdev, int base, enum mtk_tx_rx dir, int qno)
+{
+	u32 val = (qno == ALLQ) ? qno : BIT(qno);
+	u32 addr;
+
+	if (dir == DIR_TX)
+		addr = base + REG_CLDMA_UL_STOP_CMD;
+	else
+		addr = base + REG_CLDMA_SO_STOP_CMD;
+
+	mtk_hw_write32(mdev, addr, val);
+}
+
+static void mtk_cldma_clear_ip_busy(struct mtk_md_dev *mdev, int base)
+{
+	mtk_hw_write32(mdev, base + REG_CLDMA_IP_BUSY, 0x01);
+}
+
+static void mtk_cldma_hw_init(struct mtk_md_dev *mdev, int base)
+{
+	u32 val = mtk_hw_read32(mdev, base + REG_CLDMA_UL_CFG);
+
+	val = (val & (~(0x7 << 5))) | ((0x4) << 5);
+	mtk_hw_write32(mdev, base + REG_CLDMA_UL_CFG, val);
+
+	val = mtk_hw_read32(mdev, base + REG_CLDMA_SO_CFG);
+	val = (val & (~(0x7 << 10))) | ((0x4) << 10) | (1 << 2);
+	mtk_hw_write32(mdev, base + REG_CLDMA_SO_CFG, val);
+
+	mtk_hw_write32(mdev, base + REG_CLDMA_IP_BUSY_TO_PCIE_MASK_CLR, 0);
+	mtk_hw_write32(mdev, base + REG_CLDMA_IP_BUSY_TO_AP_MASK_CLR, 0);
+
+	/* enable interrupt to PCIe */
+	mtk_hw_write32(mdev, base + REG_CLDMA_INT_EAP_USIP_MASK, 0);
+
+	/* disable illegal memory check */
+	mtk_hw_write32(mdev, base + REG_CLDMA_UL_DUMMY_0, 1);
+	mtk_hw_write32(mdev, base + REG_CLDMA_SO_DUMMY_0, 1);
+}
+
+static void mtk_cldma_tx_done_work(struct work_struct *work)
+{
+	struct txq *txq = container_of(work, struct txq, tx_done_work);
+	struct mtk_md_dev *mdev = txq->hw->mdev;
+	struct tx_req *req;
+	unsigned int state;
+	struct trb *trb;
+	int i;
+
+again:
+	for (i = 0; i < txq->req_pool_size; i++) {
+		req = txq->req_pool + txq->free_idx;
+		if ((req->gpd->tx_gpd.gpd_flags & CLDMA_GPD_FLAG_HWO) || !req->data_vm_addr)
+			break;
+
+		dma_unmap_single(mdev->dev, req->data_dma_addr, req->data_len, DMA_TO_DEVICE);
+
+		trb = (struct trb *)req->skb->cb;
+		trb->status = 0;
+		trb->trb_complete(req->skb);
+
+		req->data_vm_addr = NULL;
+		req->data_dma_addr = 0;
+		req->data_len = 0;
+
+		txq->free_idx = (txq->free_idx + 1) % txq->req_pool_size;
+		mutex_lock(&txq->lock);
+		txq->req_budget++;
+		mutex_unlock(&txq->lock);
+	}
+	mtk_cldma_unmask_ip_busy_to_pci(mdev, txq->hw->base_addr, txq->txqno, IP_BUSY_TXDONE);
+	state = mtk_cldma_check_intr_status(mdev, txq->hw->base_addr,
+					    DIR_TX, txq->txqno, QUEUE_XFER_DONE);
+	if (state) {
+		if (unlikely(state == LINK_ERROR_VAL))
+			return;
+
+		mtk_cldma_clr_intr_status(mdev, txq->hw->base_addr, DIR_TX,
+					  txq->txqno, QUEUE_XFER_DONE);
+
+		if (need_resched()) {
+			mtk_cldma_mask_ip_busy_to_pci(mdev, txq->hw->base_addr,
+						      txq->txqno, IP_BUSY_TXDONE);
+			cond_resched();
+			mtk_cldma_unmask_ip_busy_to_pci(mdev, txq->hw->base_addr,
+							txq->txqno, IP_BUSY_TXDONE);
+		}
+
+		goto again;
+	}
+
+	mtk_cldma_unmask_intr(mdev, txq->hw->base_addr, DIR_TX, txq->txqno, QUEUE_XFER_DONE);
+	mtk_cldma_clear_ip_busy(mdev, txq->hw->base_addr);
+}
+
+static void mtk_cldma_rx_done_work(struct work_struct *work)
+{
+	struct rxq *rxq = container_of(work, struct rxq, rx_done_work);
+	struct cldma_hw *hw = rxq->hw;
+	u32 curr_addr_h, curr_addr_l;
+	struct mtk_md_dev *mdev;
+	struct rx_req *req;
+	u64 curr_addr;
+	int i, err;
+	u32 state;
+	u64 addr;
+
+	mdev = hw->mdev;
+
+	do {
+		for (i = 0; i < rxq->req_pool_size; i++) {
+			req = rxq->req_pool + rxq->free_idx;
+			if ((req->gpd->rx_gpd.gpd_flags & CLDMA_GPD_FLAG_HWO)) {
+				addr = hw->base_addr + REG_CLDMA_SO_CUR_ADDRH_0 +
+					(u64)rxq->rxqno * HW_QUEUE_NUM;
+				curr_addr_h = mtk_hw_read32(mdev, addr);
+				addr = hw->base_addr + REG_CLDMA_SO_CUR_ADDRL_0 +
+					(u64)rxq->rxqno * HW_QUEUE_NUM;
+				curr_addr_l = mtk_hw_read32(mdev, addr);
+				curr_addr = ((u64)curr_addr_h << 32) | curr_addr_l;
+
+				if (req->gpd_dma_addr == curr_addr &&
+				    (req->gpd->rx_gpd.gpd_flags & CLDMA_GPD_FLAG_HWO))
+					break;
+			}
+
+			dma_unmap_single(mdev->dev, req->data_dma_addr, req->mtu, DMA_FROM_DEVICE);
+
+			rxq->rx_done(req->skb, le16_to_cpu(req->gpd->rx_gpd.data_recv_len),
+				     rxq->arg);
+
+			rxq->free_idx = (rxq->free_idx + 1) % rxq->req_pool_size;
+			req->skb = __dev_alloc_skb(rxq->vq->rx_mtu, GFP_KERNEL);
+			if (!req->skb)
+				break;
+
+			req->data_dma_addr = dma_map_single(mdev->dev,
+							    req->skb->data,
+							    req->mtu,
+							    DMA_FROM_DEVICE);
+			err = dma_mapping_error(mdev->dev, req->data_dma_addr);
+			if (unlikely(err)) {
+				dev_err(mdev->dev, "Failed to map dma!\n");
+				dev_kfree_skb_any(req->skb);
+				break;
+			}
+
+			req->gpd->rx_gpd.data_recv_len = 0;
+			req->gpd->rx_gpd.data_buff_ptr_h =
+				cpu_to_le32((u64)req->data_dma_addr >> 32);
+			req->gpd->rx_gpd.data_buff_ptr_l = cpu_to_le32(req->data_dma_addr);
+			req->gpd->rx_gpd.gpd_flags = CLDMA_GPD_FLAG_IOC | CLDMA_GPD_FLAG_HWO;
+		}
+
+		mtk_cldma_resume_queue(mdev, rxq->hw->base_addr, DIR_RX, rxq->rxqno);
+		state = mtk_cldma_check_intr_status(mdev, rxq->hw->base_addr,
+						    DIR_RX, rxq->rxqno, QUEUE_XFER_DONE);
+
+		if (!state)
+			break;
+
+		mtk_cldma_clr_intr_status(mdev, rxq->hw->base_addr, DIR_RX,
+					  rxq->rxqno, QUEUE_XFER_DONE);
+
+		if (need_resched())
+			cond_resched();
+	} while (true);
+
+	mtk_cldma_unmask_intr(mdev, rxq->hw->base_addr, DIR_RX, rxq->rxqno, QUEUE_XFER_DONE);
+	mtk_cldma_mask_ip_busy_to_pci(mdev, rxq->hw->base_addr, rxq->rxqno, IP_BUSY_RXDONE);
+	mtk_cldma_clear_ip_busy(mdev, rxq->hw->base_addr);
+}
+
+static int mtk_cldma_isr(int irq_id, void *param)
+{
+	u32 txq_xfer_done, rxq_xfer_done;
+	struct cldma_hw *hw = param;
+	u32 tx_mask, rx_mask;
+	u32 txq_err, rxq_err;
+	u32 tx_sta, rx_sta;
+	struct txq *txq;
+	struct rxq *rxq;
+	int i;
+
+	tx_sta = mtk_hw_read32(hw->mdev, hw->base_addr + REG_CLDMA_L2TISAR0);
+	tx_mask = mtk_hw_read32(hw->mdev, hw->base_addr + REG_CLDMA_L2TIMR0);
+	rx_sta = mtk_hw_read32(hw->mdev, hw->base_addr + REG_CLDMA_L2RISAR0);
+	rx_mask = mtk_hw_read32(hw->mdev, hw->base_addr + REG_CLDMA_L2RIMR0);
+
+	tx_sta = tx_sta & (~tx_mask);
+	rx_sta = rx_sta & (~rx_mask);
+
+	if (tx_sta) {
+		/* TX mask */
+		mtk_hw_write32(hw->mdev, hw->base_addr + REG_CLDMA_L2TIMSR0, tx_sta);
+
+		txq_err = (tx_sta >> QUEUE_ERROR) & 0xFF;
+		if (txq_err) {
+			mtk_cldma_clr_intr_status(hw->mdev, hw->base_addr,
+						  DIR_TX, ALLQ, QUEUE_ERROR);
+			mtk_hw_write32(hw->mdev, hw->base_addr + REG_CLDMA_L2TIMCR0,
+				       (txq_err << QUEUE_ERROR));
+		}
+
+		/* TX clear */
+		mtk_hw_write32(hw->mdev, hw->base_addr + REG_CLDMA_L2TISAR0, tx_sta);
+
+		txq_xfer_done = (tx_sta >> QUEUE_XFER_DONE) & 0xFF;
+		if (txq_xfer_done) {
+			for (i = 0; i < HW_QUEUE_NUM; i++) {
+				if (txq_xfer_done & (1 << i)) {
+					txq = hw->txq[i];
+					queue_work(hw->wq, &txq->tx_done_work);
+				}
+			}
+		}
+	}
+
+	if (rx_sta) {
+		/* RX mask */
+		mtk_hw_write32(hw->mdev, hw->base_addr + REG_CLDMA_L2RIMSR0, rx_sta);
+
+		rxq_err = (rx_sta >> QUEUE_ERROR) & 0xFF;
+		if (rxq_err) {
+			mtk_cldma_clr_intr_status(hw->mdev, hw->base_addr,
+						  DIR_RX, ALLQ, QUEUE_ERROR);
+			mtk_hw_write32(hw->mdev, hw->base_addr + REG_CLDMA_L2RIMCR0,
+				       (rxq_err << QUEUE_ERROR));
+		}
+
+		/* RX clear */
+		mtk_hw_write32(hw->mdev, hw->base_addr + REG_CLDMA_L2RISAR0, rx_sta);
+
+		rxq_xfer_done = (rx_sta >> QUEUE_XFER_DONE) & 0xFF;
+		if (rxq_xfer_done) {
+			for (i = 0; i < HW_QUEUE_NUM; i++) {
+				if (rxq_xfer_done & (1 << i)) {
+					rxq = hw->rxq[i];
+					queue_work(hw->wq, &rxq->rx_done_work);
+				}
+			}
+		}
+	}
+
+	mtk_hw_clear_irq(hw->mdev, hw->pci_ext_irq_id);
+	mtk_hw_unmask_irq(hw->mdev, hw->pci_ext_irq_id);
+
+	return IRQ_HANDLED;
+}
+
+int mtk_cldma_hw_init_t800(struct cldma_dev *cd, int hif_id)
+{
+	char pool_name[DMA_POOL_NAME_LEN];
+	struct cldma_hw *hw;
+	unsigned int flag;
+
+	if (cd->cldma_hw[hif_id])
+		return 0;
+
+	hw = devm_kzalloc(cd->trans->mdev->dev, sizeof(*hw), GFP_KERNEL);
+	if (!hw)
+		return -ENOMEM;
+
+	hw->cd = cd;
+	hw->mdev = cd->trans->mdev;
+	hw->hif_id = ((CLDMA_CLASS_ID) << 8) + hif_id;
+	snprintf(pool_name, DMA_POOL_NAME_LEN, "cldma%d_pool_%s", hw->hif_id, hw->mdev->dev_str);
+	hw->dma_pool = dma_pool_create(pool_name, hw->mdev->dev, sizeof(union gpd), 64, 0);
+	if (!hw->dma_pool)
+		goto err_exit;
+
+	switch (hif_id) {
+	case CLDMA0:
+		hw->pci_ext_irq_id = mtk_hw_get_irq_id(hw->mdev, MTK_IRQ_SRC_CLDMA0);
+		hw->base_addr = CLDMA0_BASE_ADDR;
+		break;
+	case CLDMA1:
+		hw->pci_ext_irq_id = mtk_hw_get_irq_id(hw->mdev, MTK_IRQ_SRC_CLDMA1);
+		hw->base_addr = CLDMA1_BASE_ADDR;
+		break;
+	default:
+		break;
+	}
+
+	flag = WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI;
+	hw->wq = alloc_workqueue("cldma%d_workq_%s", flag, 0, hif_id, hw->mdev->dev_str);
+
+	mtk_cldma_hw_init(hw->mdev, hw->base_addr);
+
+	/* mask/clear PCI CLDMA L1 interrupt */
+	mtk_hw_mask_irq(hw->mdev, hw->pci_ext_irq_id);
+	mtk_hw_clear_irq(hw->mdev, hw->pci_ext_irq_id);
+
+	/* register CLDMA interrupt handler */
+	mtk_hw_register_irq(hw->mdev, hw->pci_ext_irq_id, mtk_cldma_isr, hw);
+
+	/* unmask PCI CLDMA L1 interrupt */
+	mtk_hw_unmask_irq(hw->mdev, hw->pci_ext_irq_id);
+
+	cd->cldma_hw[hif_id] = hw;
+	return 0;
+
+err_exit:
+	devm_kfree(hw->mdev->dev, hw);
+
+	return -EIO;
+}
+
+int mtk_cldma_hw_exit_t800(struct cldma_dev *cd, int hif_id)
+{
+	struct mtk_md_dev *mdev;
+	struct cldma_hw *hw;
+	int i;
+
+	if (!cd->cldma_hw[hif_id])
+		return 0;
+
+	/* free cldma descriptor */
+	hw = cd->cldma_hw[hif_id];
+	mdev = cd->trans->mdev;
+	mtk_hw_mask_irq(mdev, hw->pci_ext_irq_id);
+	for (i = 0; i < HW_QUEUE_NUM; i++) {
+		if (hw->txq[i])
+			cd->hw_ops.txq_free(hw, hw->txq[i]->vqno);
+		if (hw->rxq[i])
+			cd->hw_ops.rxq_free(hw, hw->rxq[i]->vqno);
+	}
+
+	flush_workqueue(hw->wq);
+	destroy_workqueue(hw->wq);
+	dma_pool_destroy(hw->dma_pool);
+	mtk_hw_unregister_irq(mdev, hw->pci_ext_irq_id);
+
+	devm_kfree(mdev->dev, hw);
+	cd->cldma_hw[hif_id] = NULL;
+
+	return 0;
+}
+
+struct txq *mtk_cldma_txq_alloc_t800(struct cldma_hw *hw, struct sk_buff *skb)
+{
+	struct trb *trb = (struct trb *)skb->cb;
+	struct tx_req *next;
+	struct tx_req *req;
+	struct txq *txq;
+	int i;
+
+	txq = devm_kzalloc(hw->mdev->dev, sizeof(*txq), GFP_KERNEL);
+	if (!txq)
+		return NULL;
+
+	txq->hw = hw;
+	txq->vqno = trb->vqno;
+	txq->vq = hw->cd->trans->vq_tbl + trb->vqno;
+	txq->txqno = txq->vq->txqno;
+	txq->req_pool_size = txq->vq->tx_req_num;
+	txq->req_budget = txq->vq->tx_req_num;
+	txq->is_stopping = false;
+	mutex_init(&txq->lock);
+	if (unlikely(txq->txqno < 0 || txq->txqno >= HW_QUEUE_NUM))
+		goto err_exit;
+
+	txq->req_pool = devm_kcalloc(hw->mdev->dev, txq->req_pool_size, sizeof(*req), GFP_KERNEL);
+	if (!txq->req_pool)
+		goto err_exit;
+
+	for (i = 0; i < txq->req_pool_size; i++) {
+		req = txq->req_pool + i;
+		req->mtu = txq->vq->tx_mtu;
+		req->gpd = dma_pool_zalloc(hw->dma_pool, GFP_KERNEL, &req->gpd_dma_addr);
+		if (!req->gpd)
+			goto exit_free_req;
+	}
+
+	for (i = 0; i < txq->req_pool_size; i++) {
+		req = txq->req_pool + i;
+		next = txq->req_pool + ((i + 1) % txq->req_pool_size);
+		req->gpd->tx_gpd.next_gpd_ptr_h = cpu_to_le32((u64)(next->gpd_dma_addr) >> 32);
+		req->gpd->tx_gpd.next_gpd_ptr_l = cpu_to_le32(next->gpd_dma_addr);
+	}
+
+	INIT_WORK(&txq->tx_done_work, mtk_cldma_tx_done_work);
+
+	mtk_cldma_stop_queue(hw->mdev, hw->base_addr, DIR_TX, txq->txqno);
+	txq->tx_started = false;
+	mtk_cldma_setup_start_addr(hw->mdev, hw->base_addr, DIR_TX, txq->txqno,
+				   txq->req_pool[0].gpd_dma_addr);
+	mtk_cldma_unmask_intr(hw->mdev, hw->base_addr, DIR_TX, txq->txqno, QUEUE_ERROR);
+	mtk_cldma_unmask_intr(hw->mdev, hw->base_addr, DIR_TX, txq->txqno, QUEUE_XFER_DONE);
+
+	hw->txq[txq->txqno] = txq;
+	return txq;
+
+exit_free_req:
+	for (i--; i >= 0; i--) {
+		req = txq->req_pool + i;
+		dma_pool_free(hw->dma_pool, req->gpd, req->gpd_dma_addr);
+	}
+
+	devm_kfree(hw->mdev->dev, txq->req_pool);
+err_exit:
+	devm_kfree(hw->mdev->dev, txq);
+	return NULL;
+}
+
+int mtk_cldma_txq_free_t800(struct cldma_hw *hw, int vqno)
+{
+	struct virtq *vq = hw->cd->trans->vq_tbl + vqno;
+	unsigned int active;
+	struct tx_req *req;
+	struct txq *txq;
+	struct trb *trb;
+	int cnt = 0;
+	int irq_id;
+	int txqno;
+	int i;
+
+	txqno = vq->txqno;
+	if (unlikely(txqno < 0 || txqno >= HW_QUEUE_NUM))
+		return -EINVAL;
+	txq = hw->txq[txqno];
+	if (!txq)
+		return -EINVAL;
+
+	/* stop HW tx transaction */
+	mtk_cldma_stop_queue(hw->mdev, hw->base_addr, DIR_TX, txqno);
+	txq->tx_started = false;
+	do {
+		active = mtk_cldma_queue_status(hw->mdev, hw->base_addr, DIR_TX, txqno);
+		if (active == LINK_ERROR_VAL)
+			break;
+		msleep(CLDMA_STOP_HW_WAIT_TIME_MS); /* ensure HW tx transaction done */
+		cnt++;
+	} while (active && cnt < CLDMA_STOP_HW_POLLING_MAX_CNT);
+
+	irq_id = mtk_hw_get_virq_id(hw->mdev, hw->pci_ext_irq_id);
+	synchronize_irq(irq_id);
+
+	flush_work(&txq->tx_done_work);
+	mtk_cldma_mask_intr(hw->mdev, hw->base_addr, DIR_TX, txqno, QUEUE_XFER_DONE);
+	mtk_cldma_mask_intr(hw->mdev, hw->base_addr, DIR_TX, txqno, QUEUE_ERROR);
+
+	/* free tx req resource */
+	for (i = 0; i < txq->req_pool_size; i++) {
+		req = txq->req_pool + i;
+		if (req->data_dma_addr && req->data_len) {
+			dma_unmap_single(hw->mdev->dev,
+					 req->data_dma_addr,
+					 req->data_len,
+					 DMA_TO_DEVICE);
+			trb = (struct trb *)req->skb->cb;
+			trb->status = -EPIPE;
+			trb->trb_complete(req->skb);
+		}
+		dma_pool_free(hw->dma_pool, req->gpd, req->gpd_dma_addr);
+	}
+
+	devm_kfree(hw->mdev->dev, txq->req_pool);
+	devm_kfree(hw->mdev->dev, txq);
+	hw->txq[txqno] = NULL;
+
+	return 0;
+}
+
+struct rxq *mtk_cldma_rxq_alloc_t800(struct cldma_hw *hw, struct sk_buff *skb)
+{
+	struct trb_open_priv *trb_open_priv = (struct trb_open_priv *)skb->data;
+	struct trb *trb = (struct trb *)skb->cb;
+	struct rx_req *next;
+	struct rx_req *req;
+	struct rxq *rxq;
+	int err;
+	int i;
+
+	rxq = devm_kzalloc(hw->mdev->dev, sizeof(*rxq), GFP_KERNEL);
+	if (!rxq)
+		return NULL;
+
+	rxq->hw = hw;
+	rxq->vqno = trb->vqno;
+	rxq->vq = hw->cd->trans->vq_tbl + trb->vqno;
+	rxq->rxqno = rxq->vq->rxqno;
+	rxq->req_pool_size = rxq->vq->rx_req_num;
+	rxq->arg = trb->priv;
+	rxq->rx_done = trb_open_priv->rx_done;
+	if (unlikely(rxq->rxqno < 0 || rxq->rxqno >= HW_QUEUE_NUM))
+		goto err_exit;
+
+	rxq->req_pool = devm_kcalloc(hw->mdev->dev, rxq->req_pool_size, sizeof(*req), GFP_KERNEL);
+	if (!rxq->req_pool)
+		goto err_exit;
+
+	/* setup rx request */
+	for (i = 0; i < rxq->req_pool_size; i++) {
+		req = rxq->req_pool + i;
+		req->mtu = rxq->vq->rx_mtu;
+		req->gpd = dma_pool_zalloc(hw->dma_pool, GFP_KERNEL, &req->gpd_dma_addr);
+		if (!req->gpd)
+			goto exit_free_req;
+
+		req->skb = __dev_alloc_skb(rxq->vq->rx_mtu, GFP_KERNEL);
+		if (!req->skb) {
+			dma_pool_free(hw->dma_pool, req->gpd, req->gpd_dma_addr);
+			goto exit_free_req;
+		}
+
+		req->data_dma_addr = dma_map_single(hw->mdev->dev,
+						    req->skb->data,
+						    req->mtu,
+						    DMA_FROM_DEVICE);
+		err = dma_mapping_error(hw->mdev->dev, req->data_dma_addr);
+		if (unlikely(err)) {
+			dev_err(hw->mdev->dev, "Failed to map dma!\n");
+			i++;
+			goto exit_free_req;
+		}
+	}
+
+	for (i = 0; i < rxq->req_pool_size; i++) {
+		req = rxq->req_pool + i;
+		next = rxq->req_pool + ((i + 1) % rxq->req_pool_size);
+		req->gpd->rx_gpd.gpd_flags = CLDMA_GPD_FLAG_IOC | CLDMA_GPD_FLAG_HWO;
+		req->gpd->rx_gpd.data_allow_len = cpu_to_le16(req->mtu);
+		req->gpd->rx_gpd.next_gpd_ptr_h = cpu_to_le32((u64)(next->gpd_dma_addr) >> 32);
+		req->gpd->rx_gpd.next_gpd_ptr_l = cpu_to_le32(next->gpd_dma_addr);
+		req->gpd->rx_gpd.data_buff_ptr_h = cpu_to_le32((u64)(req->data_dma_addr) >> 32);
+		req->gpd->rx_gpd.data_buff_ptr_l = cpu_to_le32(req->data_dma_addr);
+	}
+
+	INIT_WORK(&rxq->rx_done_work, mtk_cldma_rx_done_work);
+
+	hw->rxq[rxq->rxqno] = rxq;
+	mtk_cldma_stop_queue(hw->mdev, hw->base_addr, DIR_RX, rxq->rxqno);
+	mtk_cldma_setup_start_addr(hw->mdev, hw->base_addr, DIR_RX,
+				   rxq->rxqno, rxq->req_pool[0].gpd_dma_addr);
+	mtk_cldma_start_queue(hw->mdev, hw->base_addr, DIR_RX, rxq->rxqno);
+	mtk_cldma_unmask_intr(hw->mdev, hw->base_addr, DIR_RX, rxq->rxqno, QUEUE_ERROR);
+	mtk_cldma_unmask_intr(hw->mdev, hw->base_addr, DIR_RX, rxq->rxqno, QUEUE_XFER_DONE);
+
+	return rxq;
+
+exit_free_req:
+	for (i--; i >= 0; i--) {
+		req = rxq->req_pool + i;
+		dma_unmap_single(hw->mdev->dev, req->data_dma_addr, req->mtu, DMA_FROM_DEVICE);
+		dma_pool_free(hw->dma_pool, req->gpd, req->gpd_dma_addr);
+		if (req->skb)
+			dev_kfree_skb_any(req->skb);
+	}
+
+	devm_kfree(hw->mdev->dev, rxq->req_pool);
+err_exit:
+	devm_kfree(hw->mdev->dev, rxq);
+	return NULL;
+}
+
+int mtk_cldma_rxq_free_t800(struct cldma_hw *hw, int vqno)
+{
+	struct mtk_md_dev *mdev;
+	unsigned int active;
+	struct rx_req *req;
+	struct virtq *vq;
+	struct rxq *rxq;
+	int cnt = 0;
+	int irq_id;
+	int rxqno;
+	int i;
+
+	mdev = hw->mdev;
+	vq = hw->cd->trans->vq_tbl + vqno;
+	rxqno = vq->rxqno;
+	if (unlikely(rxqno < 0 || rxqno >= HW_QUEUE_NUM))
+		return -EINVAL;
+	rxq = hw->rxq[rxqno];
+	if (!rxq)
+		return -EINVAL;
+
+	mtk_cldma_stop_queue(mdev, hw->base_addr, DIR_RX, rxqno);
+	do {
+		/* check CLDMA HW state register */
+		active = mtk_cldma_queue_status(mdev, hw->base_addr, DIR_RX, rxqno);
+		if (active == LINK_ERROR_VAL)
+			break;
+		msleep(CLDMA_STOP_HW_WAIT_TIME_MS); /* ensure HW rx transaction done */
+		cnt++;
+	} while (active && cnt < CLDMA_STOP_HW_POLLING_MAX_CNT);
+
+	irq_id = mtk_hw_get_virq_id(hw->mdev, hw->pci_ext_irq_id);
+	synchronize_irq(irq_id);
+
+	flush_work(&rxq->rx_done_work);
+	mtk_cldma_mask_intr(mdev, hw->base_addr, DIR_RX, rxqno, QUEUE_XFER_DONE);
+	mtk_cldma_mask_intr(mdev, hw->base_addr, DIR_RX, rxqno, QUEUE_ERROR);
+
+	/* free rx req resource */
+	for (i = 0; i < rxq->req_pool_size; i++) {
+		req = rxq->req_pool + i;
+		if (!(req->gpd->rx_gpd.gpd_flags & CLDMA_GPD_FLAG_HWO) &&
+		    le16_to_cpu(req->gpd->rx_gpd.data_recv_len)) {
+			dma_unmap_single(mdev->dev, req->data_dma_addr, req->mtu, DMA_FROM_DEVICE);
+			rxq->rx_done(req->skb, le16_to_cpu(req->gpd->rx_gpd.data_recv_len),
+				     rxq->arg);
+			req->skb = NULL;
+		}
+
+		dma_pool_free(hw->dma_pool, req->gpd, req->gpd_dma_addr);
+		if (req->skb) {
+			dev_kfree_skb_any(req->skb);
+			dma_unmap_single(mdev->dev, req->data_dma_addr, req->mtu, DMA_FROM_DEVICE);
+		}
+	}
+
+	devm_kfree(mdev->dev, rxq->req_pool);
+	devm_kfree(mdev->dev, rxq);
+	hw->rxq[rxqno] = NULL;
+
+	return 0;
+}
+
+int mtk_cldma_start_xfer_t800(struct cldma_hw *hw, int qno)
+{
+	struct txq *txq;
+	u32 addr, val;
+	int idx;
+
+	txq = hw->txq[qno];
+	addr = hw->base_addr + REG_CLDMA_UL_START_ADDRL_0 + qno * HW_QUEUE_NUM;
+	val = mtk_hw_read32(hw->mdev, addr);
+	if (unlikely(!val)) {
+		mtk_cldma_hw_init(hw->mdev, hw->base_addr);
+		txq = hw->txq[qno];
+		idx = (txq->wr_idx + txq->req_pool_size - 1) % txq->req_pool_size;
+		mtk_cldma_setup_start_addr(hw->mdev, hw->base_addr, DIR_TX, qno,
+					   txq->req_pool[idx].gpd_dma_addr);
+		mtk_cldma_start_queue(hw->mdev, hw->base_addr, DIR_TX, qno);
+		txq->tx_started = true;
+	} else {
+		if (unlikely(!txq->tx_started)) {
+			mtk_cldma_start_queue(hw->mdev, hw->base_addr, DIR_TX, qno);
+			txq->tx_started = true;
+		} else {
+			mtk_cldma_resume_queue(hw->mdev, hw->base_addr, DIR_TX, qno);
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
new file mode 100644
index 000000000000..b89d45a81c4f
--- /dev/null
+++ b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_CLDMA_DRV_T800_H__
+#define __MTK_CLDMA_DRV_T800_H__
+
+#include <linux/skbuff.h>
+
+#include "mtk_cldma.h"
+
+int mtk_cldma_hw_init_t800(struct cldma_dev *cd, int hif_id);
+int mtk_cldma_hw_exit_t800(struct cldma_dev *cd, int hif_id);
+struct txq *mtk_cldma_txq_alloc_t800(struct cldma_hw *hw, struct sk_buff *skb);
+int mtk_cldma_txq_free_t800(struct cldma_hw *hw, int vqno);
+struct rxq *mtk_cldma_rxq_alloc_t800(struct cldma_hw *hw, struct sk_buff *skb);
+int mtk_cldma_rxq_free_t800(struct cldma_hw *hw, int vqno);
+int mtk_cldma_start_xfer_t800(struct cldma_hw *hw, int qno);
+#endif
-- 
2.32.0

