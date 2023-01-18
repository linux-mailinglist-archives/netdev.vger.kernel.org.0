Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21373671C07
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjARM1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjARM0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:26:40 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D9175A17;
        Wed, 18 Jan 2023 03:45:43 -0800 (PST)
X-UUID: 9fe7424e972511eda06fc9ecc4dadd91-20230118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Cubr0SMDp+3uBznVIz+WdXPSfLWYS+oCicJuucvO70E=;
        b=AseWCofpE48dOlEIylyYR1aODtmHcSy5+TMfiChkI9l2LQXZKUHDZ+ddDSx9g0g9WTZIred8E0kr0X73CCREcvwZ/ZzDk37nNiljyBrb4lRIza5hrUE540avrvkaNgeX6kBeUqLdRNzLFg6gzKsJd44I759ou1vuCRHc8DnE18Y=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:4905688c-4f68-4182-96cf-0d485dc6daba,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:3ca2d6b,CLOUDID:e9be0355-dd49-462e-a4be-2143a3ddc739,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
X-CID-BVR: 0,NGT
X-UUID: 9fe7424e972511eda06fc9ecc4dadd91-20230118
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1209231423; Wed, 18 Jan 2023 19:45:37 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 18 Jan 2023 19:45:35 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 18 Jan 2023 19:45:33 +0800
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
Subject: [PATCH net-next v2 10/12] net: wwan: tmi: Add exception handling service
Date:   Wed, 18 Jan 2023 19:38:57 +0800
Message-ID: <20230118113859.175836-11-yanchao.yang@mediatek.com>
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

The exception handling service aims to recover the entire system when the host
driver detects some exceptions.

The scenarios that could trigger exceptions include:
- Read/Write error from the transaction layer when the PCIe link brokes.
- An RGU interrupt is received.
- The OS reports PCIe link failure, e.g., an AER is detected.

When an exception happens, the exception module will receive an exception
event, and it will use FLDR or PLDR to reset the device. The exception module
will also start a timer to check if the PCIe link is back by reading the vendor
ID of the device, and it will re-initialize the host driver when the PCIe link
comes back.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
Signed-off-by: Mingliang Xu <mingliang.xu@mediatek.com>
---
 drivers/net/wwan/mediatek/Makefile            |   3 +-
 drivers/net/wwan/mediatek/mtk_cldma.c         |  15 +-
 drivers/net/wwan/mediatek/mtk_dev.c           |   8 +
 drivers/net/wwan/mediatek/mtk_dev.h           |  79 ++++++++
 drivers/net/wwan/mediatek/mtk_dpmaif.c        |  14 +-
 drivers/net/wwan/mediatek/mtk_dpmaif_drv.h    |  10 +-
 drivers/net/wwan/mediatek/mtk_except.c        | 176 ++++++++++++++++++
 drivers/net/wwan/mediatek/mtk_fsm.c           |   2 +
 .../wwan/mediatek/pcie/mtk_cldma_drv_t800.c   |  15 +-
 drivers/net/wwan/mediatek/pcie/mtk_pci.c      |  47 +++++
 10 files changed, 353 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/wwan/mediatek/mtk_except.c

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index 6a5e699987ef..e29d9711e900 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -14,7 +14,8 @@ mtk_tmi-y = \
 	mtk_fsm.o \
 	mtk_dpmaif.o \
 	mtk_wwan.o \
-	mtk_ethtool.o
+	mtk_ethtool.o \
+	mtk_except.o
 
 ccflags-y += -I$(srctree)/$(src)/
 ccflags-y += -I$(srctree)/$(src)/pcie/
diff --git a/drivers/net/wwan/mediatek/mtk_cldma.c b/drivers/net/wwan/mediatek/mtk_cldma.c
index 03190c5a01b2..47b10207cdc0 100644
--- a/drivers/net/wwan/mediatek/mtk_cldma.c
+++ b/drivers/net/wwan/mediatek/mtk_cldma.c
@@ -180,14 +180,22 @@ static int mtk_cldma_submit_tx(void *dev, struct sk_buff *skb)
 	struct tx_req *req;
 	struct virtq *vq;
 	struct txq *txq;
+	int ret = 0;
 	int err;
 
 	vq = cd->trans->vq_tbl + trb->vqno;
 	hw = cd->cldma_hw[vq->hif_id & HIF_ID_BITMASK];
 	txq = hw->txq[vq->txqno];
 
-	if (!txq->req_budget)
-		return -EAGAIN;
+	if (!txq->req_budget) {
+		if (mtk_hw_mmio_check(hw->mdev)) {
+			mtk_except_report_evt(hw->mdev, EXCEPT_LINK_ERR);
+			ret = -EFAULT;
+		} else {
+			ret = -EAGAIN;
+		}
+		goto err;
+	}
 
 	data_dma_addr = dma_map_single(hw->mdev->dev, skb->data, skb->len, DMA_TO_DEVICE);
 	err = dma_mapping_error(hw->mdev->dev, data_dma_addr);
@@ -215,7 +223,8 @@ static int mtk_cldma_submit_tx(void *dev, struct sk_buff *skb)
 
 	wmb(); /* ensure GPD setup done before HW start */
 
-	return 0;
+err:
+	return ret;
 }
 
 /**
diff --git a/drivers/net/wwan/mediatek/mtk_dev.c b/drivers/net/wwan/mediatek/mtk_dev.c
index 50a05921e698..d64b597bad0c 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.c
+++ b/drivers/net/wwan/mediatek/mtk_dev.c
@@ -24,6 +24,13 @@ int mtk_dev_init(struct mtk_md_dev *mdev)
 	if (ret)
 		goto err_data_init;
 
+	ret = mtk_except_init(mdev);
+	if (ret)
+		goto err_except_init;
+
+	return 0;
+err_except_init:
+	mtk_data_exit(mdev);
 err_data_init:
 	mtk_ctrl_exit(mdev);
 err_ctrl_init:
@@ -38,6 +45,7 @@ void mtk_dev_exit(struct mtk_md_dev *mdev)
 			   EVT_MODE_BLOCKING | EVT_MODE_TOHEAD);
 	mtk_data_exit(mdev);
 	mtk_ctrl_exit(mdev);
+	mtk_except_exit(mdev);
 	mtk_fsm_exit(mdev);
 }
 
diff --git a/drivers/net/wwan/mediatek/mtk_dev.h b/drivers/net/wwan/mediatek/mtk_dev.h
index 0dc73b40554f..3bcf8072feea 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.h
+++ b/drivers/net/wwan/mediatek/mtk_dev.h
@@ -39,6 +39,7 @@ enum mtk_reset_type {
 	RESET_FLDR,
 	RESET_PLDR,
 	RESET_RGU,
+	RESET_NONE
 };
 
 enum mtk_reinit_type {
@@ -51,6 +52,15 @@ enum mtk_l1ss_grp {
 	L1SS_EXT_EVT,
 };
 
+enum mtk_except_evt {
+	EXCEPT_LINK_ERR,
+	EXCEPT_RGU,
+	EXCEPT_AER_DETECTED,
+	EXCEPT_AER_RESET,
+	EXCEPT_AER_RESUME,
+	EXCEPT_MAX
+};
+
 #define L1SS_BIT_L1(grp)     BIT(((grp) << 2) + 1)
 #define L1SS_BIT_L1_1(grp)   BIT(((grp) << 2) + 2)
 #define L1SS_BIT_L1_2(grp)   BIT(((grp) << 2) + 3)
@@ -87,6 +97,7 @@ struct mtk_md_dev;
  * @reset:          Callback to reset device.
  * @reinit:         Callback to execute device re-initialization.
  * @mmio_check:     Callback to check whether it is available to mmio access device.
+ * @link_check:     Callback to execute hardware link check.
  * @get_hp_status:  Callback to get link hotplug status.
  */
 struct mtk_hw_ops {
@@ -118,10 +129,18 @@ struct mtk_hw_ops {
 
 	int (*reset)(struct mtk_md_dev *mdev, enum mtk_reset_type type);
 	int (*reinit)(struct mtk_md_dev *mdev, enum mtk_reinit_type type);
+	bool (*link_check)(struct mtk_md_dev *mdev);
 	bool (*mmio_check)(struct mtk_md_dev *mdev);
 	int (*get_hp_status)(struct mtk_md_dev *mdev);
 };
 
+struct mtk_md_except {
+	atomic_t flag;
+	enum mtk_reset_type type;
+	int pci_ext_irq_id;
+	struct timer_list timer;
+};
+
 /**
  * struct mtk_md_dev - defines the context structure of MTK modem device.
  * @dev:        pointer to the generic device object.
@@ -134,6 +153,7 @@ struct mtk_hw_ops {
  * @ctrl_blk:   pointer to the context of control plane submodule.
  * @data_blk:   pointer to the context of data plane submodule.
  * @bm_ctrl:    pointer to the context of buffer management submodule.
+ * @except:     pointer to the context of driver exception submodule.
  */
 struct mtk_md_dev {
 	struct device *dev;
@@ -147,6 +167,7 @@ struct mtk_md_dev {
 	void *ctrl_blk;
 	void *data_blk;
 	struct mtk_bm_ctrl *bm_ctrl;
+	struct mtk_md_except except;
 };
 
 int mtk_dev_init(struct mtk_md_dev *mdev);
@@ -461,6 +482,19 @@ static inline int mtk_hw_reinit(struct mtk_md_dev *mdev, enum mtk_reinit_type ty
 	return mdev->hw_ops->reinit(mdev, type);
 }
 
+/**
+ * mtk_hw_link_check() - Check if the link is down.
+ * @mdev: Device instance.
+ *
+ * Return:
+ * * 0 - indicates link normally.
+ * * other value - indicates link down.
+ */
+static inline bool mtk_hw_link_check(struct mtk_md_dev *mdev)
+{
+	return mdev->hw_ops->link_check(mdev);
+}
+
 /**
  * mtk_hw_mmio_check() - Check if the PCIe MMIO is ready.
  * @mdev: Device instance.
@@ -487,4 +521,49 @@ static inline int mtk_hw_get_hp_status(struct mtk_md_dev *mdev)
 	return mdev->hw_ops->get_hp_status(mdev);
 }
 
+/**
+ * mtk_except_report_evt() - Report exception event.
+ * @mdev: pointer to mtk_md_dev
+ * @evt: exception event
+ *
+ * Return:
+ * *  0 - OK
+ * *  -EFAULT - exception feature is not ready
+ */
+int mtk_except_report_evt(struct mtk_md_dev *mdev, enum mtk_except_evt evt);
+
+/**
+ * mtk_except_start() - Start exception service.
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return: void
+ */
+void mtk_except_start(struct mtk_md_dev *mdev);
+
+/**
+ * mtk_except_stop() - Stop exception service.
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return: void
+ */
+void mtk_except_stop(struct mtk_md_dev *mdev);
+
+/**
+ * mtk_except_init() - Initialize exception feature.
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return:
+ * *  0 - OK
+ */
+int mtk_except_init(struct mtk_md_dev *mdev);
+
+/**
+ * mtk_except_exit() - De-Initialize exception feature.
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return:
+ * *  0 - OK
+ */
+int mtk_except_exit(struct mtk_md_dev *mdev);
+
 #endif /* __MTK_DEV_H__ */
diff --git a/drivers/net/wwan/mediatek/mtk_dpmaif.c b/drivers/net/wwan/mediatek/mtk_dpmaif.c
index 246b093a8cf6..44cd129b9544 100644
--- a/drivers/net/wwan/mediatek/mtk_dpmaif.c
+++ b/drivers/net/wwan/mediatek/mtk_dpmaif.c
@@ -534,10 +534,12 @@ static void mtk_dpmaif_common_err_handle(struct mtk_dpmaif_ctlb *dcb, bool is_hw
 		return;
 	}
 
-	if (mtk_hw_mmio_check(DCB_TO_MDEV(dcb)))
+	if (mtk_hw_mmio_check(DCB_TO_MDEV(dcb))) {
 		dev_err(DCB_TO_DEV(dcb), "Failed to access mmio\n");
-	else
+		mtk_except_report_evt(DCB_TO_MDEV(dcb), EXCEPT_LINK_ERR);
+	} else {
 		mtk_dpmaif_trigger_dev_exception(dcb);
+	}
 }
 
 static unsigned int mtk_dpmaif_pit_bid(struct dpmaif_pd_pit *pit_info)
@@ -708,10 +710,10 @@ static int mtk_dpmaif_reload_rx_page(struct mtk_dpmaif_ctlb *dcb,
 			page_info->offset = data - page_address(page_info->page);
 			page_info->data_len = bat_ring->buf_size;
 			page_info->data_dma_addr = dma_map_page(DCB_TO_MDEV(dcb)->dev,
-							page_info->page,
-							page_info->offset,
-							page_info->data_len,
-							DMA_FROM_DEVICE);
+								page_info->page,
+								page_info->offset,
+								page_info->data_len,
+								DMA_FROM_DEVICE);
 			ret = dma_mapping_error(DCB_TO_MDEV(dcb)->dev, page_info->data_dma_addr);
 			if (unlikely(ret)) {
 				dev_err(DCB_TO_MDEV(dcb)->dev, "Failed to map dma!\n");
diff --git a/drivers/net/wwan/mediatek/mtk_dpmaif_drv.h b/drivers/net/wwan/mediatek/mtk_dpmaif_drv.h
index 34ec846e6336..29b6c99bba42 100644
--- a/drivers/net/wwan/mediatek/mtk_dpmaif_drv.h
+++ b/drivers/net/wwan/mediatek/mtk_dpmaif_drv.h
@@ -84,12 +84,12 @@ enum mtk_drv_err {
 
 enum {
 	DPMAIF_CLEAR_INTR,
-	DPMAIF_UNMASK_INTR
+	DPMAIF_UNMASK_INTR,
 };
 
 enum dpmaif_drv_dlq_id {
 	DPMAIF_DLQ0 = 0,
-	DPMAIF_DLQ1
+	DPMAIF_DLQ1,
 };
 
 struct dpmaif_drv_dlq {
@@ -132,7 +132,7 @@ enum dpmaif_drv_ring_type {
 	DPMAIF_PIT,
 	DPMAIF_BAT,
 	DPMAIF_FRAG,
-	DPMAIF_DRB
+	DPMAIF_DRB,
 };
 
 enum dpmaif_drv_ring_idx {
@@ -143,7 +143,7 @@ enum dpmaif_drv_ring_idx {
 	DPMAIF_FRAG_WIDX,
 	DPMAIF_FRAG_RIDX,
 	DPMAIF_DRB_WIDX,
-	DPMAIF_DRB_RIDX
+	DPMAIF_DRB_RIDX,
 };
 
 struct dpmaif_drv_irq_en_mask {
@@ -184,7 +184,7 @@ enum dpmaif_drv_intr_type {
 	DPMAIF_INTR_DL_FRGCNT_LEN_ERR,
 	DPMAIF_INTR_DL_PITCNT_LEN_ERR,
 	DPMAIF_INTR_DL_DONE,
-	DPMAIF_INTR_MAX,
+	DPMAIF_INTR_MAX
 };
 
 #define DPMAIF_INTR_COUNT ((DPMAIF_INTR_MAX) - (DPMAIF_INTR_MIN) - 1)
diff --git a/drivers/net/wwan/mediatek/mtk_except.c b/drivers/net/wwan/mediatek/mtk_except.c
new file mode 100644
index 000000000000..e35592d9d2c3
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_except.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/timer.h>
+
+#include "mtk_dev.h"
+#include "mtk_fsm.h"
+
+#define MTK_EXCEPT_HOST_RESET_TIME		(2)
+#define MTK_EXCEPT_SELF_RESET_TIME		(35)
+#define MTK_EXCEPT_RESET_TYPE_PLDR		BIT(26)
+#define MTK_EXCEPT_RESET_TYPE_FLDR		BIT(27)
+
+static void mtk_except_start_monitor(struct mtk_md_dev *mdev, unsigned long expires)
+{
+	struct mtk_md_except *except = &mdev->except;
+
+	if (!timer_pending(&except->timer) && !mtk_hw_get_hp_status(mdev)) {
+		except->timer.expires = jiffies + expires;
+		add_timer(&except->timer);
+		dev_info(mdev->dev, "Add timer to monitor PCI link\n");
+	}
+}
+
+int mtk_except_report_evt(struct mtk_md_dev *mdev, enum mtk_except_evt evt)
+{
+	struct mtk_md_except *except = &mdev->except;
+	int err, val;
+
+	if (atomic_read(&except->flag) != 1)
+		return -EFAULT;
+
+	switch (evt) {
+	case EXCEPT_LINK_ERR:
+		err = mtk_hw_mmio_check(mdev);
+		if (err)
+			mtk_fsm_evt_submit(mdev, FSM_EVT_LINKDOWN, FSM_F_DFLT, NULL, 0, 0);
+		break;
+	case EXCEPT_RGU:
+		/* delay 20ms to make sure device ready for reset */
+		msleep(20);
+
+		val = mtk_hw_get_dev_state(mdev);
+		dev_info(mdev->dev, "dev_state:0x%x, hw_ver:0x%x, fsm state:%d\n",
+			 val, mdev->hw_ver, mdev->fsm->state);
+
+		/* Invalid dev state will trigger PLDR */
+		if (val & MTK_EXCEPT_RESET_TYPE_PLDR) {
+			except->type = RESET_PLDR;
+		} else if (val & MTK_EXCEPT_RESET_TYPE_FLDR) {
+			except->type = RESET_FLDR;
+		} else if (mdev->fsm->state >= FSM_STATE_READY) {
+			dev_info(mdev->dev, "HW reboot\n");
+			except->type = RESET_NONE;
+		} else {
+			dev_info(mdev->dev, "RGU ignored\n");
+			break;
+		}
+		mtk_fsm_evt_submit(mdev, FSM_EVT_DEV_RESET_REQ, FSM_F_DFLT, NULL, 0, 0);
+		break;
+	case EXCEPT_AER_DETECTED:
+		mtk_fsm_evt_submit(mdev, FSM_EVT_AER, FSM_F_DFLT, NULL, 0, EVT_MODE_BLOCKING);
+		break;
+	case EXCEPT_AER_RESET:
+		err = mtk_hw_reset(mdev, RESET_FLDR);
+		if (err)
+			mtk_hw_reset(mdev, RESET_RGU);
+		break;
+	case EXCEPT_AER_RESUME:
+		mtk_except_start_monitor(mdev, HZ);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+void mtk_except_start(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_except *except = &mdev->except;
+
+	mtk_hw_unmask_irq(mdev, except->pci_ext_irq_id);
+}
+
+void mtk_except_stop(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_except *except = &mdev->except;
+
+	mtk_hw_mask_irq(mdev, except->pci_ext_irq_id);
+}
+
+static void mtk_except_fsm_handler(struct mtk_fsm_param *param, void *data)
+{
+	struct mtk_md_except *except = data;
+	enum mtk_reset_type reset_type;
+	struct mtk_md_dev *mdev;
+	unsigned long expires;
+	int err;
+
+	mdev = container_of(except, struct mtk_md_dev, except);
+
+	switch (param->to) {
+	case FSM_STATE_POSTDUMP:
+		mtk_hw_mask_irq(mdev, except->pci_ext_irq_id);
+		mtk_hw_clear_irq(mdev, except->pci_ext_irq_id);
+		mtk_hw_unmask_irq(mdev, except->pci_ext_irq_id);
+		break;
+	case FSM_STATE_OFF:
+		if (param->evt_id == FSM_EVT_DEV_RESET_REQ)
+			reset_type = except->type;
+		else if (param->evt_id == FSM_EVT_LINKDOWN)
+			reset_type = RESET_FLDR;
+		else
+			break;
+
+		if (reset_type == RESET_NONE) {
+			expires = MTK_EXCEPT_SELF_RESET_TIME * HZ;
+		} else {
+			err = mtk_hw_reset(mdev, reset_type);
+			if (err)
+				expires = MTK_EXCEPT_SELF_RESET_TIME * HZ;
+			else
+				expires = MTK_EXCEPT_HOST_RESET_TIME * HZ;
+		}
+
+		mtk_except_start_monitor(mdev, expires);
+		break;
+	default:
+		break;
+	}
+}
+
+static void mtk_except_link_monitor(struct timer_list *timer)
+{
+	struct mtk_md_except *except = container_of(timer, struct mtk_md_except, timer);
+	struct mtk_md_dev *mdev = container_of(except, struct mtk_md_dev, except);
+	int err;
+
+	err = mtk_hw_link_check(mdev);
+	if (!err) {
+		mtk_fsm_evt_submit(mdev, FSM_EVT_REINIT, FSM_F_FULL_REINIT, NULL, 0, 0);
+		del_timer(&except->timer);
+	} else {
+		mod_timer(timer, jiffies + HZ);
+	}
+}
+
+int mtk_except_init(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_except *except = &mdev->except;
+
+	except->pci_ext_irq_id = mtk_hw_get_irq_id(mdev, MTK_IRQ_SRC_SAP_RGU);
+
+	mtk_fsm_notifier_register(mdev, MTK_USER_EXCEPT,
+				  mtk_except_fsm_handler, except, FSM_PRIO_1, false);
+	timer_setup(&except->timer, mtk_except_link_monitor, 0);
+	atomic_set(&except->flag, 1);
+
+	return 0;
+}
+
+int mtk_except_exit(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_except *except = &mdev->except;
+
+	atomic_set(&except->flag, 0);
+	del_timer(&except->timer);
+	mtk_fsm_notifier_unregister(mdev, MTK_USER_EXCEPT);
+
+	return 0;
+}
diff --git a/drivers/net/wwan/mediatek/mtk_fsm.c b/drivers/net/wwan/mediatek/mtk_fsm.c
index 46feb3148342..e1588b932e2a 100644
--- a/drivers/net/wwan/mediatek/mtk_fsm.c
+++ b/drivers/net/wwan/mediatek/mtk_fsm.c
@@ -516,6 +516,8 @@ static int mtk_fsm_early_bootup_handler(u32 status, void *__fsm)
 	dev_stage = dev_state & REGION_BITMASK;
 	if (dev_stage >= DEV_STAGE_MAX) {
 		dev_err(mdev->dev, "Invalid dev state 0x%x\n", dev_state);
+		if (mtk_hw_link_check(mdev))
+			mtk_except_report_evt(mdev, EXCEPT_LINK_ERR);
 		return -ENXIO;
 	}
 
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
index 06c84afbd9ee..21e59fb07d56 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
+++ b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
@@ -364,8 +364,10 @@ static void mtk_cldma_tx_done_work(struct work_struct *work)
 	state = mtk_cldma_check_intr_status(mdev, txq->hw->base_addr,
 					    DIR_TX, txq->txqno, QUEUE_XFER_DONE);
 	if (state) {
-		if (unlikely(state == LINK_ERROR_VAL))
+		if (unlikely(state == LINK_ERROR_VAL)) {
+			mtk_except_report_evt(mdev, EXCEPT_LINK_ERR);
 			return;
+		}
 
 		mtk_cldma_clr_intr_status(mdev, txq->hw->base_addr, DIR_TX,
 					  txq->txqno, QUEUE_XFER_DONE);
@@ -451,6 +453,11 @@ static void mtk_cldma_rx_done_work(struct work_struct *work)
 		if (!state)
 			break;
 
+		if (unlikely(state == LINK_ERROR_VAL)) {
+			mtk_except_report_evt(mdev, EXCEPT_LINK_ERR);
+			return;
+		}
+
 		mtk_cldma_clr_intr_status(mdev, rxq->hw->base_addr, DIR_RX,
 					  rxq->rxqno, QUEUE_XFER_DONE);
 
@@ -751,6 +758,9 @@ int mtk_cldma_txq_free_t800(struct cldma_hw *hw, int vqno)
 	devm_kfree(hw->mdev->dev, txq);
 	hw->txq[txqno] = NULL;
 
+	if (active == LINK_ERROR_VAL)
+		mtk_except_report_evt(hw->mdev, EXCEPT_LINK_ERR);
+
 	return 0;
 }
 
@@ -906,6 +916,9 @@ int mtk_cldma_rxq_free_t800(struct cldma_hw *hw, int vqno)
 	devm_kfree(mdev->dev, rxq);
 	hw->rxq[rxqno] = NULL;
 
+	if (active == LINK_ERROR_VAL)
+		mtk_except_report_evt(mdev, EXCEPT_LINK_ERR);
+
 	return 0;
 }
 
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.c b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
index 3669e5523d12..3565705754c7 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_pci.c
+++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
@@ -518,6 +518,8 @@ static int mtk_pci_reset(struct mtk_md_dev *mdev, enum mtk_reset_type type)
 		return mtk_pci_fldr(mdev);
 	case RESET_PLDR:
 		return mtk_pci_pldr(mdev);
+	default:
+		break;
 	}
 
 	return -EINVAL;
@@ -529,6 +531,12 @@ static int mtk_pci_reinit(struct mtk_md_dev *mdev, enum mtk_reinit_type type)
 	struct mtk_pci_priv *priv = mdev->hw_priv;
 	int ret, ltr, l1ss;
 
+	if (type == REINIT_TYPE_EXP) {
+		/* We have saved it in probe() */
+		pci_load_saved_state(pdev, priv->saved_state);
+		pci_restore_state(pdev);
+	}
+
 	/* restore ltr */
 	ltr = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_LTR);
 	if (ltr) {
@@ -553,6 +561,9 @@ static int mtk_pci_reinit(struct mtk_md_dev *mdev, enum mtk_reinit_type type)
 			mtk_pci_set_msix_merged(priv, priv->irq_cnt);
 	}
 
+	if (type == REINIT_TYPE_EXP)
+		mtk_pci_clear_irq(mdev, priv->rgu_irq_id);
+
 	mtk_pci_unmask_irq(mdev, priv->rgu_irq_id);
 	mtk_pci_unmask_irq(mdev, priv->mhccif_irq_id);
 
@@ -616,6 +627,7 @@ static const struct mtk_hw_ops mtk_pci_ops = {
 	.get_ext_evt_status    = mtk_mhccif_get_evt_status,
 	.reset                 = mtk_pci_reset,
 	.reinit                = mtk_pci_reinit,
+	.link_check            = mtk_pci_link_check,
 	.mmio_check            = mtk_pci_mmio_check,
 	.get_hp_status         = mtk_pci_get_hp_status,
 };
@@ -636,6 +648,7 @@ static void mtk_mhccif_isr_work(struct work_struct *work)
 	if (unlikely(stat == U32_MAX && mtk_pci_link_check(mdev))) {
 		/* When link failed, we don't need to unmask/clear. */
 		dev_err(mdev->dev, "Failed to check link in MHCCIF handler.\n");
+		mtk_except_report_evt(mdev, EXCEPT_LINK_ERR);
 		return;
 	}
 
@@ -760,6 +773,7 @@ static void mtk_rgu_work(struct work_struct *work)
 	struct mtk_pci_priv *priv;
 	struct mtk_md_dev *mdev;
 	struct pci_dev *pdev;
+	int ret;
 
 	priv = container_of(to_delayed_work(work), struct mtk_pci_priv, rgu_work);
 	mdev = priv->mdev;
@@ -770,6 +784,10 @@ static void mtk_rgu_work(struct work_struct *work)
 	mtk_pci_mask_irq(mdev, priv->rgu_irq_id);
 	mtk_pci_clear_irq(mdev, priv->rgu_irq_id);
 
+	ret = mtk_except_report_evt(mdev, EXCEPT_RGU);
+	if (ret)
+		dev_err(mdev->dev, "Failed to report exception with EXCEPT_RGU\n");
+
 	if (!pdev->msix_enabled)
 		return;
 
@@ -782,8 +800,14 @@ static int mtk_rgu_irq_cb(int irq_id, void *data)
 	struct mtk_pci_priv *priv;
 
 	priv = mdev->hw_priv;
+
+	if (delayed_work_pending(&priv->rgu_work))
+		goto exit;
+
 	schedule_delayed_work(&priv->rgu_work, msecs_to_jiffies(1));
+	dev_info(mdev->dev, "RGU IRQ arrived\n");
 
+exit:
 	return 0;
 }
 
@@ -1105,16 +1129,39 @@ static void mtk_pci_remove(struct pci_dev *pdev)
 static pci_ers_result_t mtk_pci_error_detected(struct pci_dev *pdev,
 					       pci_channel_state_t state)
 {
+	struct mtk_md_dev *mdev = pci_get_drvdata(pdev);
+	int ret;
+
+	ret = mtk_except_report_evt(mdev, EXCEPT_AER_DETECTED);
+	if (ret)
+		dev_err(mdev->dev, "Failed to call excpetion report API with EXCEPT_AER_DETECTED!\n");
+	dev_info(mdev->dev, "AER detected: pci_channel_state_t=%d\n", state);
+
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
 static pci_ers_result_t mtk_pci_slot_reset(struct pci_dev *pdev)
 {
+	struct mtk_md_dev *mdev = pci_get_drvdata(pdev);
+	int ret;
+
+	ret = mtk_except_report_evt(mdev, EXCEPT_AER_RESET);
+	if (ret)
+		dev_err(mdev->dev, "Failed to call excpetion report API with EXCEPT_AER_RESET!\n");
+	dev_info(mdev->dev, "Slot reset!\n");
+
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
 static void mtk_pci_io_resume(struct pci_dev *pdev)
 {
+	struct mtk_md_dev *mdev = pci_get_drvdata(pdev);
+	int ret;
+
+	ret = mtk_except_report_evt(mdev, EXCEPT_AER_RESUME);
+	if (ret)
+		dev_err(mdev->dev, "Failed to call excpetion report API with EXCEPT_AER_RESUME!\n");
+	dev_info(mdev->dev, "IO resume!\n");
 }
 
 static const struct pci_error_handlers mtk_pci_err_handler = {
-- 
2.32.0

