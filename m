Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CFB671C0B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjARM2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjARM2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:28:08 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC5BA19B1;
        Wed, 18 Jan 2023 03:46:28 -0800 (PST)
X-UUID: b24618ac972511ed945fc101203acc17-20230118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=qKo4N+gLchSXIhKd0ledzm8/YVQsPN9+gqbmxJfyZ5c=;
        b=BF1CNGn8vU7emTWhq6Qb7TM0J2yxL/6euAtwV+quv5ZoMGcXTK3K2sEIvnLSMBzhXjIsen88q1WNuxNdLNXCnMs2zBSuC68RzkyHoFVVR2A16b1CmfVnlI6ianNLo+4DT+HgyYgKhNsopiSGVIJfXNZ6GGv5O3ai2dB2Sczwj6A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:55925e55-2b69-4557-8201-b625bf60eecd,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:3ca2d6b,CLOUDID:d58b2df6-ff42-4fb0-b929-626456a83c14,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:1,OSI:0,OSA:0
X-CID-BVR: 2,OSH
X-UUID: b24618ac972511ed945fc101203acc17-20230118
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1015565625; Wed, 18 Jan 2023 19:46:07 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 18 Jan 2023 19:46:06 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 18 Jan 2023 19:46:04 +0800
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
Subject: [PATCH net-next v2 11/12] net: wwan: tmi: Add power management support
Date:   Wed, 18 Jan 2023 19:38:58 +0800
Message-ID: <20230118113859.175836-12-yanchao.yang@mediatek.com>
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

In the TMI driver, both the device and the host system's power management are
supported.

Regarding the device's power management, the host side has implemented a
mechanism to control the device's deep sleep function. If the host side locks
the device's deep sleep mode, the device will always be in running state, even
though the PCIe link state is in power saving state. If the host side unlocks
the device's deep sleep mode, the device may go to low power state by itself
while it is still in D0 state from the host side's point of view.

To adapt to the host system's power management, some 'dev_pm_ops' callbacks are
implemented.They are suspend, resume, freeze, thaw, poweroff, restore,
runtime_suspend and runtime_resume. As the device has several hardware modules
that need to be set up in different ways during system power management (PM)
flows, the driver introduces the 'PM entities' concept. The entities are CLDMA
and DPMAIF hardware modules. When a dev_pm_ops function is called, the PM
entities list is iterated and the matched function is called for each entry in
the list.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
Signed-off-by: Hua Yang <hua.yang@mediatek.com>
---
 drivers/net/wwan/mediatek/Makefile            |    3 +-
 drivers/net/wwan/mediatek/mtk_cldma.c         |   68 +-
 drivers/net/wwan/mediatek/mtk_cldma.h         |    3 +
 drivers/net/wwan/mediatek/mtk_ctrl_plane.c    |   77 ++
 drivers/net/wwan/mediatek/mtk_ctrl_plane.h    |    4 +
 drivers/net/wwan/mediatek/mtk_dev.c           |    8 +
 drivers/net/wwan/mediatek/mtk_dev.h           |  118 ++
 drivers/net/wwan/mediatek/mtk_dpmaif.c        |  130 ++-
 drivers/net/wwan/mediatek/mtk_pm.c            | 1001 +++++++++++++++++
 .../wwan/mediatek/pcie/mtk_cldma_drv_t800.c   |   52 +
 .../wwan/mediatek/pcie/mtk_cldma_drv_t800.h   |    3 +
 drivers/net/wwan/mediatek/pcie/mtk_pci.c      |  120 ++
 drivers/net/wwan/mediatek/pcie/mtk_reg.h      |    4 +
 13 files changed, 1584 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/wwan/mediatek/mtk_pm.c

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index e29d9711e900..f107eeab7f9b 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -15,7 +15,8 @@ mtk_tmi-y = \
 	mtk_dpmaif.o \
 	mtk_wwan.o \
 	mtk_ethtool.o \
-	mtk_except.o
+	mtk_except.o \
+	mtk_pm.o
 
 ccflags-y += -I$(srctree)/$(src)/
 ccflags-y += -I$(srctree)/$(src)/pcie/
diff --git a/drivers/net/wwan/mediatek/mtk_cldma.c b/drivers/net/wwan/mediatek/mtk_cldma.c
index 47b10207cdc0..e308f3db11ce 100644
--- a/drivers/net/wwan/mediatek/mtk_cldma.c
+++ b/drivers/net/wwan/mediatek/mtk_cldma.c
@@ -35,6 +35,9 @@ static int mtk_cldma_init(struct mtk_ctrl_trans *trans)
 	cd->hw_ops.txq_free = mtk_cldma_txq_free_t800;
 	cd->hw_ops.rxq_free = mtk_cldma_rxq_free_t800;
 	cd->hw_ops.start_xfer = mtk_cldma_start_xfer_t800;
+	cd->hw_ops.suspend = mtk_cldma_suspend_t800;
+	cd->hw_ops.suspend_late = mtk_cldma_suspend_late_t800;
+	cd->hw_ops.resume = mtk_cldma_resume_t800;
 	cd->hw_ops.fsm_state_listener = mtk_cldma_fsm_state_listener_t800;
 
 	trans->dev[CLDMA_CLASS_ID] = cd;
@@ -133,6 +136,7 @@ static int mtk_cldma_tx(struct cldma_dev *cd, struct sk_buff *skb)
 	struct cldma_hw *hw;
 	struct virtq *vq;
 	struct txq *txq;
+	int err = 0;
 
 	vq = cd->trans->vq_tbl + trb->vqno;
 	hw = cd->cldma_hw[vq->hif_id & HIF_ID_BITMASK];
@@ -140,9 +144,23 @@ static int mtk_cldma_tx(struct cldma_dev *cd, struct sk_buff *skb)
 	if (txq->is_stopping)
 		return -EPIPE;
 
+	pm_runtime_get_sync(hw->mdev->dev);
+	mtk_pm_ds_lock(hw->mdev, MTK_USER_CTRL);
+	err = mtk_pm_ds_wait_complete(hw->mdev, MTK_USER_CTRL);
+	if (unlikely(err)) {
+		dev_err(hw->mdev->dev, "ds wait err:%d\n", err);
+		goto exit;
+	}
+
 	cd->hw_ops.start_xfer(hw, vq->txqno);
 
-	return 0;
+exit:
+	mtk_pm_ds_unlock(hw->mdev, MTK_USER_CTRL);
+	pm_runtime_put_sync(hw->mdev->dev);
+	if (err == -EIO)
+		mtk_except_report_evt(hw->mdev, EXCEPT_LINK_ERR);
+
+	return err;
 }
 
 /**
@@ -227,6 +245,51 @@ static int mtk_cldma_submit_tx(void *dev, struct sk_buff *skb)
 	return ret;
 }
 
+static int mtk_cldma_suspend(struct mtk_ctrl_trans *trans)
+{
+	struct cldma_dev *cd = trans->dev[CLDMA_CLASS_ID];
+	struct cldma_hw *hw;
+	int i;
+
+	for (i = 0; i < NR_CLDMA; i++) {
+		hw = cd->cldma_hw[i];
+		if (hw)
+			cd->hw_ops.suspend(hw);
+	}
+
+	return 0;
+}
+
+static int mtk_cldma_suspend_late(struct mtk_ctrl_trans *trans)
+{
+	struct cldma_dev *cd = trans->dev[CLDMA_CLASS_ID];
+	struct cldma_hw *hw;
+	int i;
+
+	for (i = 0; i < NR_CLDMA; i++) {
+		hw = cd->cldma_hw[i];
+		if (hw)
+			cd->hw_ops.suspend_late(hw);
+	}
+
+	return 0;
+}
+
+static int mtk_cldma_resume(struct mtk_ctrl_trans *trans)
+{
+	struct cldma_dev *cd = trans->dev[CLDMA_CLASS_ID];
+	struct cldma_hw *hw;
+	int i;
+
+	for (i = 0; i < NR_CLDMA; i++) {
+		hw = cd->cldma_hw[i];
+		if (hw)
+			cd->hw_ops.resume(hw);
+	}
+
+	return 0;
+}
+
 /**
  * mtk_cldma_trb_process() - Dispatch trb request to low-level CLDMA routine
  * @dev: pointer to CLDMA device
@@ -298,6 +361,9 @@ static void mtk_cldma_fsm_state_listener(struct mtk_fsm_param *param, struct mtk
 struct hif_ops cldma_ops = {
 	.init = mtk_cldma_init,
 	.exit = mtk_cldma_exit,
+	.suspend = mtk_cldma_suspend,
+	.suspend_late = mtk_cldma_suspend_late,
+	.resume = mtk_cldma_resume,
 	.trb_process = mtk_cldma_trb_process,
 	.submit_tx = mtk_cldma_submit_tx,
 	.fsm_state_listener = mtk_cldma_fsm_state_listener,
diff --git a/drivers/net/wwan/mediatek/mtk_cldma.h b/drivers/net/wwan/mediatek/mtk_cldma.h
index c9656aa31455..45b68dd3d9dc 100644
--- a/drivers/net/wwan/mediatek/mtk_cldma.h
+++ b/drivers/net/wwan/mediatek/mtk_cldma.h
@@ -135,6 +135,9 @@ struct cldma_hw_ops {
 	int (*txq_free)(struct cldma_hw *hw, int vqno);
 	int (*rxq_free)(struct cldma_hw *hw, int vqno);
 	int (*start_xfer)(struct cldma_hw *hw, int qno);
+	void (*suspend)(struct cldma_hw *hw);
+	void (*suspend_late)(struct cldma_hw *hw);
+	void (*resume)(struct cldma_hw *hw);
 	void (*fsm_state_listener)(struct mtk_fsm_param *param, struct cldma_hw *hw);
 };
 
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.c b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
index 16626a083793..ac367b3a7951 100644
--- a/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
@@ -7,6 +7,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/list.h>
+#include <linux/pm_runtime.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 
@@ -290,7 +291,9 @@ int mtk_ctrl_trb_submit(struct mtk_ctrl_blk *blk, struct sk_buff *skb)
 	else
 		skb_queue_tail(&trans->skb_list[vqno], skb);
 
+	pm_runtime_get_sync(blk->mdev->dev);
 	wake_up(&trans->trb_srv->trb_waitq);
+	pm_runtime_put_sync(blk->mdev->dev);
 
 	return 0;
 }
@@ -371,6 +374,73 @@ static void mtk_ctrl_trans_fsm_state_handler(struct mtk_fsm_param *param,
 	}
 }
 
+static int mtk_ctrl_pm_suspend(struct mtk_md_dev *mdev, void *param)
+{
+	struct mtk_ctrl_blk *ctrl_blk = param;
+	int i;
+
+	kthread_park(ctrl_blk->trans->trb_srv->trb_thread);
+
+	for (i = 0; i < HIF_CLASS_NUM; i++)
+		ctrl_blk->trans->ops[i]->suspend(ctrl_blk->trans);
+
+	return 0;
+}
+
+static int mtk_ctrl_pm_suspend_late(struct mtk_md_dev *mdev, void *param)
+{
+	struct mtk_ctrl_blk *ctrl_blk = param;
+	int i;
+
+	for (i = 0; i < HIF_CLASS_NUM; i++)
+		ctrl_blk->trans->ops[i]->suspend_late(ctrl_blk->trans);
+
+	return 0;
+}
+
+static int mtk_ctrl_pm_resume(struct mtk_md_dev *mdev, void *param)
+{
+	struct mtk_ctrl_blk *ctrl_blk = param;
+	int i;
+
+	for (i = 0; i < HIF_CLASS_NUM; i++)
+		ctrl_blk->trans->ops[i]->resume(ctrl_blk->trans);
+
+	kthread_unpark(ctrl_blk->trans->trb_srv->trb_thread);
+
+	return 0;
+}
+
+static int mtk_ctrl_pm_init(struct mtk_ctrl_blk *ctrl_blk)
+{
+	struct mtk_pm_entity *pm_entity;
+	int ret;
+
+	pm_entity = &ctrl_blk->pm_entity;
+	INIT_LIST_HEAD(&pm_entity->entry);
+	pm_entity->user = MTK_USER_CTRL;
+	pm_entity->param = ctrl_blk;
+	pm_entity->suspend = mtk_ctrl_pm_suspend;
+	pm_entity->suspend_late = mtk_ctrl_pm_suspend_late;
+	pm_entity->resume = mtk_ctrl_pm_resume;
+	ret = mtk_pm_entity_register(ctrl_blk->mdev, pm_entity);
+	if (ret < 0)
+		dev_err(ctrl_blk->mdev->dev, "Failed to register ctrl pm_entity\n");
+
+	return ret;
+}
+
+static int mtk_ctrl_pm_exit(struct mtk_ctrl_blk *ctrl_blk)
+{
+	int ret;
+
+	ret = mtk_pm_entity_unregister(ctrl_blk->mdev, &ctrl_blk->pm_entity);
+	if (ret < 0)
+		dev_err(ctrl_blk->mdev->dev, "Failed to unregister ctrl pm_entity\n");
+
+	return ret;
+}
+
 static void mtk_ctrl_fsm_state_listener(struct mtk_fsm_param *param, void *data)
 {
 	struct mtk_ctrl_blk *ctrl_blk = data;
@@ -416,8 +486,14 @@ int mtk_ctrl_init(struct mtk_md_dev *mdev)
 		goto err_port_exit;
 	}
 
+	err = mtk_ctrl_pm_init(ctrl_blk);
+	if (err)
+		goto err_unregister_notifiers;
+
 	return 0;
 
+err_unregister_notifiers:
+	mtk_fsm_notifier_unregister(mdev, MTK_USER_CTRL);
 err_port_exit:
 	mtk_port_mngr_exit(ctrl_blk);
 err_free_mem:
@@ -436,6 +512,7 @@ int mtk_ctrl_exit(struct mtk_md_dev *mdev)
 {
 	struct mtk_ctrl_blk *ctrl_blk = mdev->ctrl_blk;
 
+	mtk_ctrl_pm_exit(ctrl_blk);
 	mtk_fsm_notifier_unregister(mdev, MTK_USER_CTRL);
 	mtk_port_mngr_exit(ctrl_blk);
 	devm_kfree(mdev->dev, ctrl_blk);
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
index f8216020448f..fe63d6d3eddf 100644
--- a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
@@ -76,6 +76,9 @@ struct virtq {
 struct hif_ops {
 	int (*init)(struct mtk_ctrl_trans *trans);
 	int (*exit)(struct mtk_ctrl_trans *trans);
+	int (*suspend)(struct mtk_ctrl_trans *trans);
+	int (*suspend_late)(struct mtk_ctrl_trans *trans);
+	int (*resume)(struct mtk_ctrl_trans *trans);
 	int (*submit_tx)(void *dev, struct sk_buff *skb);
 	int (*trb_process)(void *dev, struct sk_buff *skb);
 	void (*fsm_state_listener)(struct mtk_fsm_param *param, struct mtk_ctrl_trans *trans);
@@ -96,6 +99,7 @@ struct mtk_ctrl_blk {
 	struct mtk_md_dev *mdev;
 	struct mtk_port_mngr *port_mngr;
 	struct mtk_ctrl_trans *trans;
+	struct mtk_pm_entity pm_entity;
 };
 
 int mtk_ctrl_vq_search(struct mtk_ctrl_blk *ctrl_blk, unsigned char peer_id,
diff --git a/drivers/net/wwan/mediatek/mtk_dev.c b/drivers/net/wwan/mediatek/mtk_dev.c
index d64b597bad0c..cdbdd88f2701 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.c
+++ b/drivers/net/wwan/mediatek/mtk_dev.c
@@ -16,6 +16,10 @@ int mtk_dev_init(struct mtk_md_dev *mdev)
 	if (ret)
 		goto err_fsm_init;
 
+	ret = mtk_pm_init(mdev);
+	if (ret)
+		goto err_pm_init;
+
 	ret = mtk_ctrl_init(mdev);
 	if (ret)
 		goto err_ctrl_init;
@@ -34,6 +38,8 @@ int mtk_dev_init(struct mtk_md_dev *mdev)
 err_data_init:
 	mtk_ctrl_exit(mdev);
 err_ctrl_init:
+	mtk_pm_exit(mdev);
+err_pm_init:
 	mtk_fsm_exit(mdev);
 err_fsm_init:
 	return ret;
@@ -43,8 +49,10 @@ void mtk_dev_exit(struct mtk_md_dev *mdev)
 {
 	mtk_fsm_evt_submit(mdev, FSM_EVT_DEV_RM, 0, NULL, 0,
 			   EVT_MODE_BLOCKING | EVT_MODE_TOHEAD);
+	mtk_pm_exit_early(mdev);
 	mtk_data_exit(mdev);
 	mtk_ctrl_exit(mdev);
+	mtk_pm_exit(mdev);
 	mtk_except_exit(mdev);
 	mtk_fsm_exit(mdev);
 }
diff --git a/drivers/net/wwan/mediatek/mtk_dev.h b/drivers/net/wwan/mediatek/mtk_dev.h
index 3bcf8072feea..55e1da89a205 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.h
+++ b/drivers/net/wwan/mediatek/mtk_dev.h
@@ -35,6 +35,10 @@ enum mtk_user_id {
 	MTK_USER_MAX
 };
 
+enum mtk_d2h_sw_evt {
+	D2H_SW_EVT_PM_LOCK_ACK = 0,
+};
+
 enum mtk_reset_type {
 	RESET_FLDR,
 	RESET_PLDR,
@@ -87,6 +91,7 @@ struct mtk_md_dev;
  * @mask_irq:       Callback to mask the interrupt of specific hardware IP.
  * @unmask_irq:     Callback to unmask the interrupt of specific hardware IP.
  * @clear_irq:      Callback to clear the interrupt of specific hardware IP.
+ * @clear_sw_evt:   Callback to clear the event status register of specific hardware IP.
  * @register_ext_evt:Callback to register HW Layer external event.
  * @unregister_ext_evt:Callback to unregister HW Layer external event.
  * @mask_ext_evt:   Callback to mask HW Layer external event.
@@ -99,6 +104,7 @@ struct mtk_md_dev;
  * @mmio_check:     Callback to check whether it is available to mmio access device.
  * @link_check:     Callback to execute hardware link check.
  * @get_hp_status:  Callback to get link hotplug status.
+ * @write_pm_cnt:   Callback to write PM counter to notify device.
  */
 struct mtk_hw_ops {
 	u32 (*read32)(struct mtk_md_dev *mdev, u64 addr);
@@ -118,6 +124,7 @@ struct mtk_hw_ops {
 	int (*mask_irq)(struct mtk_md_dev *mdev, int irq_id);
 	int (*unmask_irq)(struct mtk_md_dev *mdev, int irq_id);
 	int (*clear_irq)(struct mtk_md_dev *mdev, int irq_id);
+	void (*clear_sw_evt)(struct mtk_md_dev *mdev, enum mtk_d2h_sw_evt evt);
 	int (*register_ext_evt)(struct mtk_md_dev *mdev, u32 chs,
 				int (*evt_cb)(u32 status, void *data), void *data);
 	int (*unregister_ext_evt)(struct mtk_md_dev *mdev, u32 chs);
@@ -132,6 +139,7 @@ struct mtk_hw_ops {
 	bool (*link_check)(struct mtk_md_dev *mdev);
 	bool (*mmio_check)(struct mtk_md_dev *mdev);
 	int (*get_hp_status)(struct mtk_md_dev *mdev);
+	void (*write_pm_cnt)(struct mtk_md_dev *mdev, u32 val);
 };
 
 struct mtk_md_except {
@@ -141,6 +149,72 @@ struct mtk_md_except {
 	struct timer_list timer;
 };
 
+enum mtk_suspend_flag {
+	SUSPEND_F_INIT                 = 0,
+	SUSPEND_F_SLEEP                = 1
+};
+
+enum mtk_pm_resume_state {
+	PM_RESUME_STATE_L3 = 0,
+	PM_RESUME_STATE_L1,
+	PM_RESUME_STATE_INIT,
+	PM_RESUME_STATE_L1_EXCEPT,
+	PM_RESUME_STATE_L2,
+	PM_RESUME_STATE_L2_EXCEPT
+};
+
+struct mtk_pm_cfg {
+	u32 ds_delayed_unlock_timeout_ms;
+	u32 ds_lock_wait_timeout_ms;
+	u32 suspend_wait_timeout_ms;
+	u32 resume_wait_timeout_ms;
+	u32 suspend_wait_timeout_sap_ms;
+	u32 resume_wait_timeout_sap_ms;
+	u32 ds_lock_polling_max_us;
+	u32 ds_lock_polling_min_us;
+	u32 ds_lock_polling_interval_us;
+	unsigned short runtime_idle_delay;
+};
+
+struct mtk_md_pm {
+	struct list_head entities;
+	/* entity_mtx is to protect concurrently
+	 * read or write of pm entity list.
+	 */
+	struct mutex entity_mtx;
+	int irq_id;
+	u32 ext_evt_chs;
+	unsigned long state;
+
+	/* ds_spinlock is to protect concurrently
+	 * ds lock or unlock procedure.
+	 */
+	spinlock_t ds_spinlock;
+	struct completion ds_lock_complete;
+	atomic_t ds_lock_refcnt;
+	struct delayed_work ds_unlock_work;
+	u64 ds_lock_sent;
+	u64 ds_lock_recv;
+
+	struct completion pm_ack;
+	struct completion pm_ack_sap;
+	struct delayed_work resume_work;
+
+	bool resume_from_l3;
+	struct mtk_pm_cfg cfg;
+};
+
+struct mtk_pm_entity {
+	struct list_head entry;
+	enum mtk_user_id user;
+	void *param;
+
+	int (*suspend)(struct mtk_md_dev *mdev, void *param);
+	int (*suspend_late)(struct mtk_md_dev *mdev, void *param);
+	int (*resume_early)(struct mtk_md_dev *mdev, void *param);
+	int (*resume)(struct mtk_md_dev *mdev, void *param);
+};
+
 /**
  * struct mtk_md_dev - defines the context structure of MTK modem device.
  * @dev:        pointer to the generic device object.
@@ -150,6 +224,7 @@ struct mtk_md_except {
  * @msi_nvecs:  to keep the amount of aollocated irq vectors.
  * @dev_str:    to keep device B-D-F information.
  * @fsm:        pointer to the context of fsm submodule.
+ * @pm:         pointer to the context of driver power management submodule.
  * @ctrl_blk:   pointer to the context of control plane submodule.
  * @data_blk:   pointer to the context of data plane submodule.
  * @bm_ctrl:    pointer to the context of buffer management submodule.
@@ -164,6 +239,7 @@ struct mtk_md_dev {
 	char dev_str[MTK_DEV_STR_LEN];
 
 	struct mtk_md_fsm *fsm;
+	struct mtk_md_pm pm;
 	void *ctrl_blk;
 	void *data_blk;
 	struct mtk_bm_ctrl *bm_ctrl;
@@ -173,6 +249,28 @@ struct mtk_md_dev {
 int mtk_dev_init(struct mtk_md_dev *mdev);
 void mtk_dev_exit(struct mtk_md_dev *mdev);
 int mtk_dev_start(struct mtk_md_dev *mdev);
+
+int mtk_pm_init(struct mtk_md_dev *mdev);
+int mtk_pm_exit(struct mtk_md_dev *mdev);
+int mtk_pm_entity_register(struct mtk_md_dev *mdev, struct mtk_pm_entity *md_entity);
+int mtk_pm_entity_unregister(struct mtk_md_dev *mdev, struct mtk_pm_entity *md_entity);
+int mtk_pm_ds_lock(struct mtk_md_dev *mdev, enum mtk_user_id user);
+int mtk_pm_ds_unlock(struct mtk_md_dev *mdev, enum mtk_user_id user);
+int mtk_pm_ds_wait_complete(struct mtk_md_dev *mdev, enum mtk_user_id user);
+int mtk_pm_exit_early(struct mtk_md_dev *mdev);
+bool mtk_pm_check_dev_reset(struct mtk_md_dev *mdev);
+
+int mtk_pm_runtime_idle(struct device *dev);
+int mtk_pm_runtime_suspend(struct device *dev);
+int mtk_pm_runtime_resume(struct device *dev, bool atr_init);
+int mtk_pm_suspend(struct device *dev);
+int mtk_pm_resume(struct device *dev, bool atr_init);
+int mtk_pm_freeze(struct device *dev);
+int mtk_pm_thaw(struct device *dev, bool atr_init);
+int mtk_pm_poweroff(struct device *dev);
+int mtk_pm_restore(struct device *dev, bool atr_init);
+void mtk_pm_shutdown(struct mtk_md_dev *mdev);
+
 /**
  * mtk_hw_read32() - Read dword from register.
  * @mdev: Device instance.
@@ -368,6 +466,16 @@ static inline int mtk_hw_clear_irq(struct mtk_md_dev *mdev, int irq_id)
 	return mdev->hw_ops->clear_irq(mdev, irq_id);
 }
 
+/**
+ * mtk_hw_clear_sw_evt() - Clear software event.
+ * @mdev: Device instance.
+ * @evt: Software event to clear.
+ */
+static inline void mtk_hw_clear_sw_evt(struct mtk_md_dev *mdev, enum mtk_d2h_sw_evt evt)
+{
+	mdev->hw_ops->clear_sw_evt(mdev, evt);
+}
+
 /**
  * mtk_hw_register_ext_evt() - Register callback to external events.
  * @mdev: Device instance.
@@ -521,6 +629,16 @@ static inline int mtk_hw_get_hp_status(struct mtk_md_dev *mdev)
 	return mdev->hw_ops->get_hp_status(mdev);
 }
 
+/**
+ * mtk_hw_write_pm_cnt() - Write PM counter to device.
+ * @mdev: Device instance.
+ * @val:  The value that host driver wants to write.
+ */
+static inline void mtk_hw_write_pm_cnt(struct mtk_md_dev *mdev, u32 val)
+{
+	mdev->hw_ops->write_pm_cnt(mdev, val);
+}
+
 /**
  * mtk_except_report_evt() - Report exception event.
  * @mdev: pointer to mtk_md_dev
diff --git a/drivers/net/wwan/mediatek/mtk_dpmaif.c b/drivers/net/wwan/mediatek/mtk_dpmaif.c
index 44cd129b9544..dafb7cb84bbc 100644
--- a/drivers/net/wwan/mediatek/mtk_dpmaif.c
+++ b/drivers/net/wwan/mediatek/mtk_dpmaif.c
@@ -7,6 +7,7 @@
 #include <linux/icmp.h>
 #include <linux/ip.h>
 #include <linux/kthread.h>
+#include <linux/pm_runtime.h>
 #include <linux/skbuff.h>
 #include <net/ipv6.h>
 #include <net/pkt_sched.h>
@@ -428,10 +429,13 @@ struct mtk_dpmaif_ctlb {
 	struct mtk_data_blk *data_blk;
 	struct mtk_data_port_ops *port_ops;
 	struct dpmaif_drv_info *drv_info;
+	struct mtk_pm_entity pm_entity;
 	struct napi_struct *napi[DPMAIF_RXQ_CNT_MAX];
 
 	enum dpmaif_state dpmaif_state;
+	bool dpmaif_pm_ready;
 	bool dpmaif_user_ready;
+	bool dpmaif_suspending;
 	bool trans_enabled;
 	/* lock for enable/disable routine */
 	struct mutex trans_ctl_lock;
@@ -927,6 +931,14 @@ static void mtk_dpmaif_bat_reload_work(struct work_struct *work)
 		bat_info = container_of(bat_ring, struct dpmaif_bat_info, frag_bat_ring);
 
 	dcb = bat_info->dcb;
+	pm_runtime_get(DCB_TO_DEV(dcb));
+	mtk_pm_ds_lock(DCB_TO_MDEV(dcb), MTK_USER_DPMAIF);
+	ret = mtk_pm_ds_wait_complete(DCB_TO_MDEV(dcb), MTK_USER_DPMAIF);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to wait ds_lock\n");
+		mtk_dpmaif_common_err_handle(dcb, true);
+		goto out;
+	}
 
 	if (bat_ring->type == NORMAL_BAT) {
 		/* Recycle normal bat and reload rx normal buffer. */
@@ -934,7 +946,7 @@ static void mtk_dpmaif_bat_reload_work(struct work_struct *work)
 		if (unlikely(ret < 0)) {
 			dev_err(DCB_TO_DEV(dcb),
 				"Failed to recycle normal bat and reload rx buffer\n");
-			return;
+			goto out;
 		}
 
 		if (bat_ring->bat_cnt_err_intr_set) {
@@ -949,7 +961,7 @@ static void mtk_dpmaif_bat_reload_work(struct work_struct *work)
 			if (unlikely(ret < 0)) {
 				dev_err(DCB_TO_DEV(dcb),
 					"Failed to recycle frag bat and reload rx buffer\n");
-				return;
+				goto out;
 			}
 
 			if (bat_ring->bat_cnt_err_intr_set) {
@@ -959,6 +971,10 @@ static void mtk_dpmaif_bat_reload_work(struct work_struct *work)
 			}
 		}
 	}
+
+out:
+	mtk_pm_ds_unlock(DCB_TO_MDEV(dcb), MTK_USER_DPMAIF);
+	pm_runtime_put(DCB_TO_DEV(dcb));
 }
 
 static void mtk_dpmaif_queue_bat_reload_work(struct mtk_dpmaif_ctlb *dcb)
@@ -1332,6 +1348,16 @@ static void mtk_dpmaif_tx_doorbell(struct work_struct *work)
 	txq = container_of(dwork, struct dpmaif_txq, doorbell_work);
 	dcb = txq->dcb;
 
+	pm_runtime_get_sync(DCB_TO_DEV(dcb));
+	mtk_pm_ds_lock(DCB_TO_MDEV(dcb), MTK_USER_DPMAIF);
+
+	ret = mtk_pm_ds_wait_complete(DCB_TO_MDEV(dcb), MTK_USER_DPMAIF);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to wait ds_lock\n");
+		mtk_dpmaif_common_err_handle(dcb, true);
+		goto out;
+	}
+
 	to_submit_cnt = atomic_read(&txq->to_submit_cnt);
 
 	if (to_submit_cnt > 0) {
@@ -1344,6 +1370,10 @@ static void mtk_dpmaif_tx_doorbell(struct work_struct *work)
 
 		atomic_sub(to_submit_cnt, &txq->to_submit_cnt);
 	}
+
+out:
+	mtk_pm_ds_unlock(DCB_TO_MDEV(dcb), MTK_USER_DPMAIF);
+	pm_runtime_put_sync(DCB_TO_DEV(dcb));
 }
 
 static unsigned int mtk_dpmaif_poll_tx_drb(struct dpmaif_txq *txq)
@@ -1478,6 +1508,8 @@ static void mtk_dpmaif_tx_done(struct work_struct *work)
 		mtk_dpmaif_drv_intr_complete(dcb->drv_info, DPMAIF_INTR_UL_DONE,
 					     txq->id, DPMAIF_UNMASK_INTR);
 	}
+
+	pm_runtime_put(DCB_TO_DEV(dcb));
 }
 
 static int mtk_dpmaif_txq_init(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_txq *txq)
@@ -1570,7 +1602,8 @@ static int mtk_dpmaif_sw_wait_txq_stop(struct mtk_dpmaif_ctlb *dcb, struct dpmai
 	flush_delayed_work(&txq->tx_done_work);
 
 	/* Wait tx doorbell work done. */
-	flush_delayed_work(&txq->doorbell_work);
+	if (!dcb->dpmaif_suspending)
+		flush_delayed_work(&txq->doorbell_work);
 
 	return 0;
 }
@@ -2238,7 +2271,8 @@ static void mtk_dpmaif_trans_ctl(struct mtk_dpmaif_ctlb *dcb, bool enable)
 
 	if (enable) {
 		if (!dcb->trans_enabled) {
-			if (dcb->dpmaif_state == DPMAIF_STATE_PWRON &&
+			if (dcb->dpmaif_pm_ready &&
+			    dcb->dpmaif_state == DPMAIF_STATE_PWRON &&
 			    dcb->dpmaif_user_ready) {
 				mtk_dpmaif_trans_enable(dcb);
 				dcb->trans_enabled = true;
@@ -2246,7 +2280,8 @@ static void mtk_dpmaif_trans_ctl(struct mtk_dpmaif_ctlb *dcb, bool enable)
 		}
 	} else {
 		if (dcb->trans_enabled) {
-			if (!(dcb->dpmaif_state == DPMAIF_STATE_PWRON) ||
+			if (!dcb->dpmaif_pm_ready ||
+			    !(dcb->dpmaif_state == DPMAIF_STATE_PWRON) ||
 			    !dcb->dpmaif_user_ready) {
 				mtk_dpmaif_trans_disable(dcb);
 				dcb->trans_enabled = false;
@@ -2562,8 +2597,21 @@ static void mtk_dpmaif_cmd_handle(struct dpmaif_cmd_srv *srv)
 static void mtk_dpmaif_cmd_srv(struct work_struct *work)
 {
 	struct dpmaif_cmd_srv *srv = container_of(work, struct dpmaif_cmd_srv, work);
+	struct mtk_dpmaif_ctlb *dcb = srv->dcb;
+	int ret;
+
+	pm_runtime_get_sync(DCB_TO_DEV(dcb));
+	mtk_pm_ds_lock(DCB_TO_MDEV(dcb), MTK_USER_DPMAIF);
+	ret = mtk_pm_ds_wait_complete(DCB_TO_MDEV(dcb), MTK_USER_DPMAIF);
+	if (unlikely(ret < 0)) {
+		/* Exception scenario, but should always do command handler. */
+		mtk_dpmaif_common_err_handle(dcb, true);
+	}
 
 	mtk_dpmaif_cmd_handle(srv);
+
+	mtk_pm_ds_unlock(DCB_TO_MDEV(dcb), MTK_USER_DPMAIF);
+	pm_runtime_put_sync(DCB_TO_DEV(dcb));
 }
 
 static int mtk_dpmaif_cmd_srvs_init(struct mtk_dpmaif_ctlb *dcb)
@@ -2965,6 +3013,7 @@ static void mtk_dpmaif_sw_reset(struct mtk_dpmaif_ctlb *dcb)
 	mtk_dpmaif_tx_vqs_reset(dcb);
 	skb_queue_purge(&dcb->cmd_vq.list);
 	memset(&dcb->traffic_stats, 0x00, sizeof(struct dpmaif_traffic_stats));
+	dcb->dpmaif_pm_ready = true;
 	dcb->dpmaif_user_ready = false;
 	dcb->trans_enabled = false;
 }
@@ -3058,6 +3107,64 @@ static int mtk_dpmaif_fsm_exit(struct mtk_dpmaif_ctlb *dcb)
 	return ret;
 }
 
+static int mtk_dpmaif_suspend(struct mtk_md_dev *mdev, void *param)
+{
+	struct mtk_dpmaif_ctlb *dcb = param;
+
+	dcb->dpmaif_pm_ready = false;
+	dcb->dpmaif_suspending = true;
+	mtk_dpmaif_trans_ctl(dcb, false);
+	dcb->dpmaif_suspending = false;
+
+	return 0;
+}
+
+static int mtk_dpmaif_resume(struct mtk_md_dev *mdev, void *param)
+{
+	bool dev_is_reset = mtk_pm_check_dev_reset(mdev);
+	struct mtk_dpmaif_ctlb *dcb = param;
+
+	/* If device resume after device power off, we don't need to enable trans.
+	 * Since host driver will run re-init flow, we will get back to normal.
+	 */
+	if (!dev_is_reset) {
+		dcb->dpmaif_pm_ready = true;
+		mtk_dpmaif_trans_ctl(dcb, true);
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_pm_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	struct mtk_pm_entity *pm_entity;
+	int ret;
+
+	pm_entity = &dcb->pm_entity;
+	INIT_LIST_HEAD(&pm_entity->entry);
+	pm_entity->user = MTK_USER_DPMAIF;
+	pm_entity->param = dcb;
+	pm_entity->suspend = &mtk_dpmaif_suspend;
+	pm_entity->resume = &mtk_dpmaif_resume;
+
+	ret = mtk_pm_entity_register(DCB_TO_MDEV(dcb), pm_entity);
+	if (ret < 0)
+		dev_err(DCB_TO_DEV(dcb), "Failed to register dpmaif pm_entity\n");
+
+	return ret;
+}
+
+static int mtk_dpmaif_pm_exit(struct mtk_dpmaif_ctlb *dcb)
+{
+	int ret;
+
+	ret = mtk_pm_entity_unregister(DCB_TO_MDEV(dcb), &dcb->pm_entity);
+	if (ret < 0)
+		dev_err(DCB_TO_DEV(dcb), "Failed to unregister dpmaif pm_entity\n");
+
+	return ret;
+}
+
 static int mtk_dpmaif_sw_init(struct mtk_data_blk *data_blk, const struct dpmaif_res_cfg *res_cfg)
 {
 	struct mtk_dpmaif_ctlb *dcb;
@@ -3070,6 +3177,7 @@ static int mtk_dpmaif_sw_init(struct mtk_data_blk *data_blk, const struct dpmaif
 	data_blk->dcb = dcb;
 	dcb->data_blk = data_blk;
 	dcb->dpmaif_state = DPMAIF_STATE_PWROFF;
+	dcb->dpmaif_pm_ready = true;
 	dcb->dpmaif_user_ready = false;
 	dcb->trans_enabled = false;
 	mutex_init(&dcb->trans_ctl_lock);
@@ -3114,6 +3222,12 @@ static int mtk_dpmaif_sw_init(struct mtk_data_blk *data_blk, const struct dpmaif
 		goto err_init_port;
 	}
 
+	ret = mtk_dpmaif_pm_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize dpmaif PM, ret=%d\n", ret);
+		goto err_init_pm;
+	}
+
 	ret = mtk_dpmaif_fsm_init(dcb);
 	if (ret < 0) {
 		dev_err(DCB_TO_DEV(dcb), "Failed to initialize dpmaif fsm, ret=%d\n", ret);
@@ -3131,6 +3245,8 @@ static int mtk_dpmaif_sw_init(struct mtk_data_blk *data_blk, const struct dpmaif
 err_init_irq:
 	mtk_dpmaif_fsm_exit(dcb);
 err_init_fsm:
+	mtk_dpmaif_pm_exit(dcb);
+err_init_pm:
 	mtk_dpmaif_port_exit(dcb);
 err_init_port:
 	mtk_dpmaif_drv_res_exit(dcb);
@@ -3160,6 +3276,7 @@ static int mtk_dpmaif_sw_exit(struct mtk_data_blk *data_blk)
 
 	mtk_dpmaif_irq_exit(dcb);
 	mtk_dpmaif_fsm_exit(dcb);
+	mtk_dpmaif_pm_exit(dcb);
 	mtk_dpmaif_port_exit(dcb);
 	mtk_dpmaif_drv_res_exit(dcb);
 	mtk_dpmaif_cmd_srvs_exit(dcb);
@@ -3814,6 +3931,7 @@ static int mtk_dpmaif_rx_napi_poll(struct napi_struct *napi, int budget)
 	int work_done = 0;
 	int ret;
 
+	pm_runtime_get(DCB_TO_DEV(dcb));
 	if (likely(rxq->started)) {
 		ret = mtk_dpmaif_rx_data_collect_more(rxq, budget, &work_done);
 		stats->rx_done_last_cnt[rxq->id] += work_done;
@@ -3829,6 +3947,8 @@ static int mtk_dpmaif_rx_napi_poll(struct napi_struct *napi, int budget)
 		mtk_dpmaif_drv_intr_complete(dcb->drv_info, DPMAIF_INTR_DL_DONE, rxq->id, 0);
 	}
 
+	pm_runtime_put(DCB_TO_DEV(dcb));
+
 	return work_done;
 }
 
diff --git a/drivers/net/wwan/mediatek/mtk_pm.c b/drivers/net/wwan/mediatek/mtk_pm.c
new file mode 100644
index 000000000000..1efa421368b8
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_pm.c
@@ -0,0 +1,1001 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/acpi.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/spinlock.h>
+
+#include "mtk_dev.h"
+#include "mtk_fsm.h"
+#include "mtk_reg.h"
+
+#define LINK_CHECK_RETRY_COUNT	30
+
+static int mtk_pm_wait_ds_lock_done(struct mtk_md_dev *mdev, u32 delay)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	u32 polling_time = 0;
+	u32 reg = 0;
+
+	do {
+		/* Delay some time to poll the deep sleep status. */
+		udelay(pm->cfg.ds_lock_polling_interval_us);
+
+		reg = mtk_hw_get_ds_status(mdev);
+		if ((reg & 0x1F) == 0x1F)
+			return 0;
+
+		polling_time += pm->cfg.ds_lock_polling_interval_us;
+	} while (polling_time < delay);
+	dev_err(mdev->dev, "achieving max polling time %d res_state = 0x%x\n", delay, reg);
+
+	return -ETIMEDOUT;
+}
+
+static int mtk_pm_try_lock_l1ss(struct mtk_md_dev *mdev, bool report)
+{
+	int ret;
+
+	mtk_hw_set_l1ss(mdev, L1SS_BIT_L1(L1SS_PM), false);
+	ret = mtk_pm_wait_ds_lock_done(mdev, mdev->pm.cfg.ds_lock_polling_max_us);
+
+	if (ret) {
+		dev_err(mdev->dev, "Failed to lock L1ss!\n");
+		if (report)
+			mtk_except_report_evt(mdev, EXCEPT_LINK_ERR);
+	}
+
+	return ret;
+}
+
+static int mtk_pm_reset(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+
+	if (!test_bit(SUSPEND_F_INIT, &pm->state)) {
+		set_bit(SUSPEND_F_INIT, &pm->state);
+		pm_runtime_get_noresume(mdev->dev);
+	}
+
+	return 0;
+}
+
+static int mtk_pm_init_late(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+
+	mtk_hw_unmask_ext_evt(mdev, pm->ext_evt_chs);
+	mtk_hw_unmask_irq(mdev, pm->irq_id);
+	mtk_hw_set_l1ss(mdev, L1SS_BIT_L1(L1SS_PM), true);
+
+	/* Clear init flag */
+	if (test_bit(SUSPEND_F_INIT, &pm->state)) {
+		clear_bit(SUSPEND_F_INIT, &pm->state);
+		pm_runtime_put_noidle(mdev->dev);
+	}
+
+	return 0;
+}
+
+static bool mtk_pm_except_handle(struct mtk_md_dev *mdev, bool report)
+{
+	if (mtk_hw_link_check(mdev)) {
+		/* report EXCEPT_LINK_ERR event if report is true; */
+		if (report)
+			mtk_except_report_evt(mdev, EXCEPT_LINK_ERR);
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * mtk_pm_ds_lock() - Lock device power state to prevent it entering deep sleep.
+ * @mdev: pointer to mtk_md_dev
+ * @user: user who issues lock request.
+ *
+ * This function locks device power state, any user who needs to interact with device
+ * shall make sure that device is not in deep sleep.
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_pm_ds_lock(struct mtk_md_dev *mdev, enum mtk_user_id user)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	unsigned long flags = 0;
+	u32 reg;
+
+	if (test_bit(SUSPEND_F_INIT, &pm->state) ||
+	    test_bit(SUSPEND_F_SLEEP, &pm->state)) {
+		reinit_completion(&pm->ds_lock_complete);
+		complete_all(&pm->ds_lock_complete);
+		atomic_inc(&pm->ds_lock_refcnt);
+		return 0;
+	}
+
+	spin_lock_irqsave(&pm->ds_spinlock, flags);
+	if (atomic_inc_return(&pm->ds_lock_refcnt) == 1) {
+		reinit_completion(&pm->ds_lock_complete);
+		mtk_hw_ds_lock(mdev);
+		reg = mtk_hw_get_ds_status(mdev);
+		/* reg & 0xFF = 0b1111 1111 indicates linkdown,
+		 * reg & 0xFF = 0b0001 1111 indicates ds lock is locked.
+		 */
+		if ((reg & 0xFF) == 0x1F) {
+			complete_all(&pm->ds_lock_complete);
+			spin_unlock_irqrestore(&pm->ds_spinlock, flags);
+			return 0;
+		}
+		mtk_hw_send_ext_evt(mdev, EXT_EVT_H2D_PCIE_DS_LOCK);
+	}
+	spin_unlock_irqrestore(&pm->ds_spinlock, flags);
+
+	return 0;
+}
+
+/**
+ * mtk_pm_ds_unlock() - Unlock device power state.
+ * @mdev: pointer to mtk_md_dev
+ * @user: user who issues unlock request.
+ *
+ * This function unlocks device power state, after all users unlock device power state,
+ * the device will enter deep sleep.
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_pm_ds_unlock(struct mtk_md_dev *mdev, enum mtk_user_id user)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	u32 unlock_timeout;
+
+	atomic_dec(&pm->ds_lock_refcnt);
+	if (test_bit(SUSPEND_F_INIT, &pm->state) ||
+	    test_bit(SUSPEND_F_SLEEP, &pm->state))
+		return 0;
+
+	unlock_timeout = pm->cfg.ds_delayed_unlock_timeout_ms;
+	if (!atomic_read(&pm->ds_lock_refcnt)) {
+		cancel_delayed_work(&pm->ds_unlock_work);
+		schedule_delayed_work(&pm->ds_unlock_work, msecs_to_jiffies(unlock_timeout));
+	}
+
+	return 0;
+}
+
+/**
+ * mtk_pm_ds_wait_complete() -Try to get completion for a while.
+ * @mdev: pointer to mtk_md_dev
+ * @user: user id
+ *
+ * The function is not interruptible.
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_pm_ds_wait_complete(struct mtk_md_dev *mdev, enum mtk_user_id user)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	u32 unlock_timeout;
+	int res;
+	/* 0 if timed out, and positive (at least 1,
+	 * or number of jiffies left  till timeout) if completed.
+	 */
+	unlock_timeout = pm->cfg.ds_lock_wait_timeout_ms;
+	res = wait_for_completion_timeout(&pm->ds_lock_complete, msecs_to_jiffies(unlock_timeout));
+
+	if (res > 0)
+		return 0;
+
+	/* only dump register here */
+	res = mtk_pm_except_handle(mdev, false);
+	return res ? -ETIMEDOUT : -EIO;
+}
+
+static void mtk_pm_ds_unlock_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct mtk_md_dev *mdev;
+	struct mtk_md_pm *pm;
+	unsigned long flags;
+
+	pm = container_of(dwork, struct mtk_md_pm, ds_unlock_work);
+	mdev = container_of(pm, struct mtk_md_dev, pm);
+
+	flags = 0;
+	spin_lock_irqsave(&pm->ds_spinlock, flags);
+	if (!atomic_read(&pm->ds_lock_refcnt))
+		mtk_hw_ds_unlock(mdev);
+	spin_unlock_irqrestore(&pm->ds_spinlock, flags);
+}
+
+/**
+ * mtk_pm_entity_register() - Register pm entity into mtk_md_pm's list entry.
+ * @mdev: pointer to mtk_md_dev
+ * @md_entity: pm entity
+ *
+ * After registration, pm entity's related callbacks could be called upon pm event
+ * happening.
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_pm_entity_register(struct mtk_md_dev *mdev,
+			   struct mtk_pm_entity *md_entity)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	struct mtk_pm_entity *entity;
+
+	mutex_lock(&pm->entity_mtx);
+	list_for_each_entry(entity, &pm->entities, entry) {
+		if (entity->user == md_entity->user) {
+			mutex_unlock(&pm->entity_mtx);
+			return -EALREADY;
+		}
+	}
+	list_add_tail(&md_entity->entry, &pm->entities);
+	mutex_unlock(&pm->entity_mtx);
+
+	return 0;
+}
+
+/**
+ * mtk_pm_entity_unregister() - Unregister pm entity from mtk_md_pm's list entry.
+ * @mdev: pointer to mtk_md_dev
+ * @md_entity: pm entity
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_pm_entity_unregister(struct mtk_md_dev *mdev,
+			     struct mtk_pm_entity *md_entity)
+{
+	struct mtk_pm_entity *entity, *cursor;
+	struct mtk_md_pm *pm = &mdev->pm;
+
+	mutex_lock(&pm->entity_mtx);
+	list_for_each_entry_safe(cursor, entity, &pm->entities, entry) {
+		if (cursor->user == md_entity->user) {
+			list_del(&cursor->entry);
+			mutex_unlock(&pm->entity_mtx);
+			return 0;
+		}
+	}
+	mutex_unlock(&pm->entity_mtx);
+
+	return -EALREADY;
+}
+
+/**
+ * mtk_pm_check_dev_reset() - Check if device power off after suspended.
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return: true indicates device is powered off after suspended,
+ * false indicates device is not powered off after suspended.
+ */
+bool mtk_pm_check_dev_reset(struct mtk_md_dev *mdev)
+{
+	return mdev->pm.resume_from_l3;
+}
+
+static int mtk_pm_reinit(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+
+	if (!test_bit(SUSPEND_F_INIT, &pm->state)) {
+		set_bit(SUSPEND_F_INIT, &pm->state);
+		pm_runtime_get_noresume(mdev->dev);
+	}
+
+	clear_bit(SUSPEND_F_SLEEP, &pm->state);
+
+	/* in init stage, no need to report exception event */
+	return mtk_pm_try_lock_l1ss(mdev, false);
+}
+
+static int mtk_pm_entity_resume_early(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	struct mtk_pm_entity *entity;
+	int ret;
+
+	list_for_each_entry(entity, &pm->entities, entry) {
+		if (entity->resume_early) {
+			ret = entity->resume_early(mdev, entity->param);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int mtk_pm_entity_resume(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	struct mtk_pm_entity *entity;
+	int ret;
+
+	list_for_each_entry(entity, &pm->entities, entry) {
+		if (entity->resume) {
+			ret = entity->resume(mdev, entity->param);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int mtk_pm_entity_suspend(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	struct mtk_pm_entity *entity;
+	int ret;
+
+	list_for_each_entry(entity, &pm->entities, entry) {
+		if (entity->suspend) {
+			ret = entity->suspend(mdev, entity->param);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int mtk_pm_entity_suspend_late(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	struct mtk_pm_entity *entity;
+	int ret;
+
+	list_for_each_entry(entity, &pm->entities, entry) {
+		if (entity->suspend_late) {
+			ret = entity->suspend_late(mdev, entity->param);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void mtk_pm_ctrl_entity_resume(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	struct mtk_pm_entity *entity;
+
+	list_for_each_entry(entity, &pm->entities, entry) {
+		if (entity->user == MTK_USER_CTRL && entity->resume) {
+			entity->resume(mdev, entity->param);
+			break;
+		}
+	}
+}
+
+static void mtk_pm_dev_ack_fail_handle(struct mtk_md_dev *mdev)
+{
+	mtk_pm_except_handle(mdev, true);
+	mtk_pm_ctrl_entity_resume(mdev);
+}
+
+static int mtk_pm_enable_wake(struct mtk_md_dev *mdev, u8 dev_state, u8 system_state, bool enable)
+{
+#ifdef CONFIG_ACPI
+	union acpi_object in_arg[3];
+	struct acpi_object_list arg_list = { 3, in_arg };
+	struct pci_dev *bridge;
+	acpi_status acpi_ret;
+	acpi_handle handle;
+
+	if (acpi_disabled) {
+		dev_err(mdev->dev, "Unsupported, acpi function isn't enable\n");
+		return -ENODEV;
+	}
+
+	bridge = pci_upstream_bridge(to_pci_dev(mdev->dev));
+	if (!bridge) {
+		dev_err(mdev->dev, "Unable to find bridge\n");
+		return -ENODEV;
+	}
+
+	handle = ACPI_HANDLE(&bridge->dev);
+	if (!handle) {
+		dev_err(mdev->dev, "Unsupported, acpi handle isn't found\n");
+		return -ENODEV;
+	}
+	if (!acpi_has_method(handle, "_DSW")) {
+		dev_err(mdev->dev, "Unsupported,_DSW method isn't supported\n");
+		return -ENODEV;
+	}
+
+	in_arg[0].type = ACPI_TYPE_INTEGER;
+	in_arg[0].integer.value = enable;
+	in_arg[1].type = ACPI_TYPE_INTEGER;
+	in_arg[1].integer.value = system_state;
+	in_arg[2].type = ACPI_TYPE_INTEGER;
+	in_arg[2].integer.value = dev_state;
+	acpi_ret = acpi_evaluate_object(handle, "_DSW", &arg_list, NULL);
+	if (ACPI_FAILURE(acpi_ret))
+		dev_err(mdev->dev, "_DSW method fail for parent: %s\n",
+			acpi_format_exception(acpi_ret));
+
+	return 0;
+#else
+	dev_err(mdev->dev, "Unsupported, CONFIG ACPI hasn't been set to 'y'\n");
+
+	return -ENODEV;
+#endif
+}
+
+static int mtk_pm_suspend_device(struct mtk_md_dev *mdev, bool is_runtime)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	unsigned long flags;
+	u32 suspend_timeout;
+	int ret;
+
+	if (test_bit(SUSPEND_F_INIT, &pm->state))
+		return -EBUSY;
+
+	ret = mtk_pm_try_lock_l1ss(mdev, true);
+	if (ret)
+		return -EBUSY;
+
+	set_bit(SUSPEND_F_SLEEP, &pm->state);
+
+	mtk_fsm_pause(mdev);
+	mtk_except_stop(mdev);
+
+	ret = mtk_pm_entity_suspend(mdev);
+	if (ret)
+		goto err_suspend;
+
+	reinit_completion(&pm->pm_ack);
+	reinit_completion(&pm->pm_ack_sap);
+	mtk_hw_send_ext_evt(mdev, EXT_EVT_H2D_PCIE_PM_SUSPEND_REQ);
+	mtk_hw_send_ext_evt(mdev, EXT_EVT_H2D_PCIE_PM_SUSPEND_REQ_AP);
+
+	suspend_timeout = pm->cfg.suspend_wait_timeout_ms;
+	ret = wait_for_completion_timeout(&pm->pm_ack, msecs_to_jiffies(suspend_timeout));
+	if (!ret) {
+		dev_err(mdev->dev, "Suspend MD timeout!\n");
+		mtk_pm_dev_ack_fail_handle(mdev);
+		ret = -ETIMEDOUT;
+		goto err_suspend;
+	}
+	suspend_timeout = pm->cfg.suspend_wait_timeout_sap_ms;
+	ret = wait_for_completion_timeout(&pm->pm_ack_sap, msecs_to_jiffies(suspend_timeout));
+	if (!ret) {
+		dev_err(mdev->dev, "Suspend sAP timeout!\n");
+		mtk_pm_dev_ack_fail_handle(mdev);
+		ret = -ETIMEDOUT;
+		goto err_suspend;
+	}
+
+	ret = mtk_pm_entity_suspend_late(mdev);
+	if (ret)
+		goto err_suspend;
+
+	cancel_delayed_work_sync(&pm->ds_unlock_work);
+	if (!atomic_read(&pm->ds_lock_refcnt)) {
+		spin_lock_irqsave(&pm->ds_spinlock, flags);
+		mtk_hw_ds_unlock(mdev);
+		spin_unlock_irqrestore(&pm->ds_spinlock, flags);
+	}
+
+	if (is_runtime)
+		mtk_pm_enable_wake(mdev, 3, 0, true);
+
+	mtk_hw_set_l1ss(mdev, L1SS_BIT_L1(L1SS_PM), true);
+
+	dev_info(mdev->dev, "Suspend success.\n");
+
+	return ret;
+
+err_suspend:
+	mtk_fsm_start(mdev);
+	mtk_except_start(mdev);
+	clear_bit(SUSPEND_F_SLEEP, &pm->state);
+	return ret;
+}
+
+static int mtk_pm_do_resume_device(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	u32 resume_timeout;
+	int ret;
+
+	mtk_pm_try_lock_l1ss(mdev, true);
+
+	ret = mtk_pm_entity_resume_early(mdev);
+	if (ret)
+		goto err_resume;
+
+	reinit_completion(&pm->pm_ack);
+	reinit_completion(&pm->pm_ack_sap);
+
+	mtk_hw_send_ext_evt(mdev, EXT_EVT_H2D_PCIE_PM_RESUME_REQ);
+	mtk_hw_send_ext_evt(mdev, EXT_EVT_H2D_PCIE_PM_RESUME_REQ_AP);
+
+	resume_timeout = pm->cfg.resume_wait_timeout_ms;
+	ret = wait_for_completion_timeout(&pm->pm_ack, msecs_to_jiffies(resume_timeout));
+	if (!ret) {
+		dev_err(mdev->dev, "Resume MD fail!\n");
+		mtk_pm_dev_ack_fail_handle(mdev);
+		ret = -ETIMEDOUT;
+		goto err_resume;
+	}
+	resume_timeout = pm->cfg.resume_wait_timeout_sap_ms;
+	ret = wait_for_completion_timeout(&pm->pm_ack_sap, msecs_to_jiffies(resume_timeout));
+	if (!ret) {
+		dev_err(mdev->dev, "Resume sAP fail!\n");
+		mtk_pm_dev_ack_fail_handle(mdev);
+		ret = -ETIMEDOUT;
+		goto err_resume;
+	}
+
+	ret = mtk_pm_entity_resume(mdev);
+	if (ret)
+		goto err_resume;
+
+	mtk_hw_set_l1ss(mdev, L1SS_BIT_L1(L1SS_PM), true);
+	dev_info(mdev->dev, "Resume success.\n");
+
+err_resume:
+	mtk_fsm_start(mdev);
+	mtk_except_start(mdev);
+	clear_bit(SUSPEND_F_SLEEP, &pm->state);
+
+	return ret;
+}
+
+static int mtk_pm_resume_device(struct mtk_md_dev *mdev, bool is_runtime, bool atr_init)
+{
+	enum mtk_pm_resume_state resume_state;
+	struct mtk_md_pm *pm = &mdev->pm;
+	int ret = 0;
+
+	if (is_runtime)
+		mtk_pm_enable_wake(mdev, 0, 0, false);
+
+	if (unlikely(test_bit(SUSPEND_F_INIT, &pm->state))) {
+		clear_bit(SUSPEND_F_SLEEP, &pm->state);
+		return 0;
+	}
+
+	resume_state = mtk_hw_get_resume_state(mdev);
+
+	if ((resume_state == PM_RESUME_STATE_INIT && atr_init) ||
+	    resume_state == PM_RESUME_STATE_L3)
+		mdev->pm.resume_from_l3 = true;
+	else
+		mdev->pm.resume_from_l3 = false;
+	dev_info(mdev->dev, "Resume Enter: resume state = %d, is_runtime = %d, atr_init = %d\n",
+		 resume_state, is_runtime, atr_init);
+	switch (resume_state) {
+	case PM_RESUME_STATE_INIT:
+		if (!atr_init)
+			break;
+		fallthrough;
+	case PM_RESUME_STATE_L3:
+		ret = mtk_hw_reinit(mdev, REINIT_TYPE_RESUME);
+		if (ret) {
+			mtk_pm_except_handle(mdev, false);
+			dev_err(mdev->dev, "Failed to reinit HW in resume routine!\n");
+			return ret;
+		}
+
+		mtk_pm_entity_resume_early(mdev);
+		mtk_pm_entity_resume(mdev);
+
+		mtk_fsm_evt_submit(mdev, FSM_EVT_COLD_RESUME,
+				   FSM_F_DFLT, NULL, 0, EVT_MODE_TOHEAD);
+		/* No need to start except, for hw reinit will do it later. */
+		mtk_fsm_start(mdev);
+		mtk_fsm_evt_submit(mdev, FSM_EVT_REINIT,
+				   FSM_F_DFLT, NULL, 0, EVT_MODE_BLOCKING);
+		dev_info(mdev->dev, "Resume success from L3.\n");
+		return 0;
+	case PM_RESUME_STATE_L2_EXCEPT:
+		ret = mtk_hw_reinit(mdev, REINIT_TYPE_RESUME);
+		if (ret) {
+			mtk_pm_except_handle(mdev, false);
+			dev_err(mdev->dev, "Failed to reinit HW in PM!\n");
+			return ret;
+		}
+		mtk_hw_unmask_irq(mdev, pm->irq_id);
+		fallthrough;
+	case PM_RESUME_STATE_L1_EXCEPT:
+		mtk_pm_entity_resume_early(mdev);
+		mtk_pm_entity_resume(mdev);
+		set_bit(SUSPEND_F_INIT, &pm->state);
+		mtk_fsm_start(mdev);
+		mtk_except_start(mdev);
+		dev_info(mdev->dev, "Resume success from exception.\n");
+		return 0;
+	case PM_RESUME_STATE_L2:
+		ret = mtk_hw_reinit(mdev, REINIT_TYPE_RESUME);
+		if (ret) {
+			dev_err(mdev->dev, "Failed to reinit HW in PM!\n");
+			return ret;
+		}
+		mtk_hw_unmask_irq(mdev, pm->irq_id);
+		fallthrough;
+	case PM_RESUME_STATE_L1:
+		break;
+	default:
+		set_bit(SUSPEND_F_INIT, &pm->state);
+		cancel_delayed_work_sync(&pm->resume_work);
+		schedule_delayed_work(&pm->resume_work, HZ);
+		return 0;
+	}
+
+	return mtk_pm_do_resume_device(mdev);
+}
+
+static void mtk_pm_resume_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct mtk_md_dev *mdev;
+	struct mtk_md_pm *pm;
+	int ret = 0;
+	int cnt = 0;
+
+	pm = container_of(dwork, struct mtk_md_pm, resume_work);
+	mdev = container_of(pm, struct mtk_md_dev, pm);
+
+	do {
+		ret = mtk_hw_link_check(mdev);
+		if (!ret)
+			break;
+		/* Wait for 1 second to check link state. */
+		msleep(1000);
+		cnt++;
+	} while (cnt < LINK_CHECK_RETRY_COUNT);
+
+	if (!ret) {
+		mtk_except_report_evt(mdev, EXCEPT_LINK_ERR);
+		return;
+	}
+	mtk_fsm_evt_submit(mdev, FSM_EVT_COLD_RESUME, FSM_F_DFLT, NULL, 0, EVT_MODE_TOHEAD);
+	/* No need to start except, for hw reinit will do it */
+	mtk_fsm_start(mdev);
+	/* FSM_EVT_REINIT is full reinit */
+	mtk_fsm_evt_submit(mdev, FSM_EVT_REINIT, FSM_F_FULL_REINIT, NULL, 0, 0);
+	dev_info(mdev->dev, "Resume success within delayed work.\n");
+}
+
+int mtk_pm_suspend(struct device *dev)
+{
+	struct mtk_md_dev *mdev;
+	struct pci_dev *pdev;
+
+	pdev = to_pci_dev(dev);
+	mdev = pci_get_drvdata(pdev);
+
+	dev_info(mdev->dev, "Enter suspend.");
+	return mtk_pm_suspend_device(mdev, false);
+}
+
+int mtk_pm_resume(struct device *dev, bool atr_init)
+{
+	struct mtk_md_dev *mdev;
+	struct pci_dev *pdev;
+
+	pdev = to_pci_dev(dev);
+	mdev = pci_get_drvdata(pdev);
+
+	dev_info(mdev->dev, "Enter resume.");
+	return mtk_pm_resume_device(mdev, false, atr_init);
+}
+
+int mtk_pm_freeze(struct device *dev)
+{
+	struct mtk_md_dev *mdev;
+	struct pci_dev *pdev;
+
+	pdev = to_pci_dev(dev);
+	mdev = pci_get_drvdata(pdev);
+
+	dev_info(mdev->dev, "Enter freeze.");
+	return mtk_pm_suspend_device(mdev, false);
+}
+
+int mtk_pm_poweroff(struct device *dev)
+{
+	struct mtk_md_dev *mdev;
+	struct pci_dev *pdev;
+
+	pdev = to_pci_dev(dev);
+	mdev = pci_get_drvdata(pdev);
+
+	return mtk_pm_suspend_device(mdev, false);
+}
+
+int mtk_pm_restore(struct device *dev, bool atr_init)
+{
+	struct mtk_md_dev *mdev;
+	struct pci_dev *pdev;
+
+	pdev = to_pci_dev(dev);
+	mdev = pci_get_drvdata(pdev);
+
+	return mtk_pm_resume_device(mdev, false, atr_init);
+}
+
+int mtk_pm_thaw(struct device *dev, bool atr_init)
+{
+	struct mtk_md_dev *mdev;
+	struct pci_dev *pdev;
+
+	pdev = to_pci_dev(dev);
+	mdev = pci_get_drvdata(pdev);
+
+	return mtk_pm_resume_device(mdev, false, atr_init);
+}
+
+int mtk_pm_runtime_suspend(struct device *dev)
+{
+	struct mtk_md_dev *mdev;
+	struct pci_dev *pdev;
+
+	pdev = to_pci_dev(dev);
+	mdev = pci_get_drvdata(pdev);
+
+	return mtk_pm_suspend_device(mdev, true);
+}
+
+int mtk_pm_runtime_resume(struct device *dev, bool atr_init)
+{
+	struct mtk_md_dev *mdev;
+	struct pci_dev *pdev;
+
+	pdev = to_pci_dev(dev);
+	mdev = pci_get_drvdata(pdev);
+
+	return mtk_pm_resume_device(mdev, true, atr_init);
+}
+
+int mtk_pm_runtime_idle(struct device *dev)
+{
+	pm_schedule_suspend(dev, 20 * MSEC_PER_SEC);
+	return -EBUSY;
+}
+
+void mtk_pm_shutdown(struct mtk_md_dev *mdev)
+{
+	mtk_pm_suspend_device(mdev, false);
+}
+
+static void mtk_pm_fsm_state_handler(struct mtk_fsm_param *fsm_param, void *data)
+{
+	struct mtk_md_dev *mdev;
+	struct mtk_md_pm *pm;
+
+	pm = data;
+	mdev = container_of(pm, struct mtk_md_dev, pm);
+	switch (fsm_param->to) {
+	case FSM_STATE_ON:
+		if (fsm_param->evt_id == FSM_EVT_REINIT)
+			mtk_pm_reinit(mdev);
+		break;
+
+	case FSM_STATE_READY:
+		mtk_pm_init_late(mdev);
+		break;
+
+	case FSM_STATE_OFF:
+		mtk_pm_reset(mdev);
+		break;
+
+	case FSM_STATE_MDEE:
+		if (fsm_param->fsm_flag == FSM_F_MDEE_INIT)
+			mtk_pm_reinit(mdev);
+		break;
+
+	default:
+		break;
+	}
+}
+
+static int mtk_pm_irq_handler(int irq_id, void *data)
+{
+	struct mtk_md_dev *mdev;
+	struct mtk_md_pm *pm;
+
+	pm = data;
+	mdev = container_of(pm, struct mtk_md_dev, pm);
+	mtk_hw_clear_sw_evt(mdev, D2H_SW_EVT_PM_LOCK_ACK);
+	mtk_hw_clear_irq(mdev, irq_id);
+	complete_all(&pm->ds_lock_complete);
+	mtk_hw_unmask_irq(mdev, irq_id);
+	return IRQ_HANDLED;
+}
+
+static int mtk_pm_ext_evt_handler(u32 status, void *data)
+{
+	int pm_suspend_ack_sap = 0;
+	int pm_resume_ack_sap = 0;
+	struct mtk_md_dev *mdev;
+	int pm_suspend_ack = 0;
+	int pm_resume_ack = 0;
+	struct mtk_md_pm *pm;
+	int pm_ds_lock = 0;
+
+	pm = data;
+	mdev = container_of(pm, struct mtk_md_dev, pm);
+
+	if (status & EXT_EVT_D2H_PCIE_DS_LOCK_ACK)
+		pm_ds_lock = 1;
+
+	if (status & EXT_EVT_D2H_PCIE_PM_SUSPEND_ACK)
+		pm_suspend_ack = 1;
+
+	if (status & EXT_EVT_D2H_PCIE_PM_RESUME_ACK)
+		pm_resume_ack = 1;
+
+	if (status & EXT_EVT_D2H_PCIE_PM_SUSPEND_ACK_AP)
+		pm_suspend_ack_sap = 1;
+
+	if (status & EXT_EVT_D2H_PCIE_PM_RESUME_ACK_AP)
+		pm_resume_ack_sap = 1;
+
+	mtk_hw_clear_ext_evt(mdev, status);
+
+	if (pm_ds_lock)
+		complete_all(&pm->ds_lock_complete);
+
+	if (pm_suspend_ack || pm_resume_ack)
+		complete_all(&pm->pm_ack);
+
+	if (pm_suspend_ack_sap || pm_resume_ack_sap)
+		complete_all(&pm->pm_ack_sap);
+
+	mtk_hw_unmask_ext_evt(mdev, status);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * mtk_pm_init() - Initialize pm fields of struct mtk_md_dev.
+ * @mdev: pointer to mtk_md_dev
+ *
+ * This function initializes pm fields of struct mtk_md_dev, after that the driver is capable
+ * of performing pm related functions.
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_pm_init(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_pm *pm = &mdev->pm;
+	int irq_id = -1;
+	int ret;
+
+	INIT_LIST_HEAD(&pm->entities);
+
+	spin_lock_init(&pm->ds_spinlock);
+	mutex_init(&pm->entity_mtx);
+
+	init_completion(&pm->ds_lock_complete);
+	init_completion(&pm->pm_ack);
+	init_completion(&pm->pm_ack_sap);
+
+	INIT_DELAYED_WORK(&pm->ds_unlock_work, mtk_pm_ds_unlock_work);
+	INIT_DELAYED_WORK(&pm->resume_work, mtk_pm_resume_work);
+
+	atomic_set(&pm->ds_lock_refcnt, 0);
+	pm->ds_lock_sent = 0;
+	pm->ds_lock_recv = 0;
+
+	pm->cfg.ds_delayed_unlock_timeout_ms = 100;
+	pm->cfg.ds_lock_wait_timeout_ms = 50;
+	pm->cfg.suspend_wait_timeout_ms = 1500;
+	pm->cfg.resume_wait_timeout_ms = 1500;
+	pm->cfg.suspend_wait_timeout_sap_ms = 1500;
+	pm->cfg.resume_wait_timeout_sap_ms = 1500;
+	pm->cfg.ds_lock_polling_max_us = 10000;
+	pm->cfg.ds_lock_polling_min_us = 2000;
+	pm->cfg.ds_lock_polling_interval_us = 10;
+
+	/* Set init event flag to prevent device from suspending. */
+	set_bit(SUSPEND_F_INIT, &pm->state);
+
+	mtk_pm_try_lock_l1ss(mdev, false);
+
+	device_init_wakeup(mdev->dev, true);
+
+	/* register sw irq for ds lock. */
+	irq_id = mtk_hw_get_irq_id(mdev, MTK_IRQ_SRC_PM_LOCK);
+	if (irq_id < 0) {
+		dev_err(mdev->dev, "Failed to allocate Irq id!\n");
+		ret = -EFAULT;
+		goto err_start_init;
+	}
+
+	ret = mtk_hw_register_irq(mdev, irq_id, mtk_pm_irq_handler, pm);
+	if (ret) {
+		dev_err(mdev->dev, "Failed to register irq!\n");
+		ret = -EFAULT;
+		goto err_start_init;
+	}
+	pm->irq_id = irq_id;
+
+	/* register mhccif interrupt handler. */
+	pm->ext_evt_chs = EXT_EVT_D2H_PCIE_PM_SUSPEND_ACK |
+			  EXT_EVT_D2H_PCIE_PM_RESUME_ACK |
+			  EXT_EVT_D2H_PCIE_PM_SUSPEND_ACK_AP |
+			  EXT_EVT_D2H_PCIE_PM_RESUME_ACK_AP |
+			  EXT_EVT_D2H_PCIE_DS_LOCK_ACK;
+
+	ret = mtk_hw_register_ext_evt(mdev, pm->ext_evt_chs, mtk_pm_ext_evt_handler, pm);
+	if (ret) {
+		dev_err(mdev->dev, "Failed to register ext event!\n");
+		ret = -EFAULT;
+		goto err_reg_ext_evt;
+	}
+
+	/* register fsm notify callback */
+	ret = mtk_fsm_notifier_register(mdev, MTK_USER_PM,
+					mtk_pm_fsm_state_handler, pm, FSM_PRIO_0, false);
+	if (ret) {
+		dev_err(mdev->dev, "Failed to register fsm notifier!\n");
+		ret = -EFAULT;
+		goto err_reg_fsm_notifier;
+	}
+
+	return 0;
+
+err_reg_fsm_notifier:
+	mtk_hw_unregister_ext_evt(mdev, pm->ext_evt_chs);
+err_reg_ext_evt:
+	if (irq_id >= 0)
+		mtk_hw_unregister_irq(mdev, irq_id);
+err_start_init:
+	return ret;
+}
+
+/**
+ * mtk_pm_exit_early() - Acquire device ds lock at the beginning of driver exit routine.
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_pm_exit_early(struct mtk_md_dev *mdev)
+{
+	/* In kernel device_del, system pm is already removed from pm entry list
+	 * and runtime pm is forbidden as well, thus no need to disable
+	 * PM here.
+	 */
+
+	return mtk_pm_try_lock_l1ss(mdev, false);
+}
+
+/**
+ * mtk_pm_exit() - PM exit cleanup routine.
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_pm_exit(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_pm *pm;
+
+	if (!mdev)
+		return -EINVAL;
+
+	pm = &mdev->pm;
+
+	cancel_delayed_work_sync(&pm->ds_unlock_work);
+	cancel_delayed_work_sync(&pm->resume_work);
+
+	mtk_fsm_notifier_unregister(mdev, MTK_USER_PM);
+	mtk_hw_unregister_ext_evt(mdev, pm->ext_evt_chs);
+	mtk_hw_unregister_irq(mdev, pm->irq_id);
+
+	return 0;
+}
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
index 21e59fb07d56..ce7eacf4aeb6 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
+++ b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
@@ -339,6 +339,7 @@ static void mtk_cldma_tx_done_work(struct work_struct *work)
 	struct trb *trb;
 	int i;
 
+	pm_runtime_get(mdev->dev);
 again:
 	for (i = 0; i < txq->req_pool_size; i++) {
 		req = txq->req_pool + txq->free_idx;
@@ -365,6 +366,7 @@ static void mtk_cldma_tx_done_work(struct work_struct *work)
 					    DIR_TX, txq->txqno, QUEUE_XFER_DONE);
 	if (state) {
 		if (unlikely(state == LINK_ERROR_VAL)) {
+			pm_runtime_put(mdev->dev);
 			mtk_except_report_evt(mdev, EXCEPT_LINK_ERR);
 			return;
 		}
@@ -385,6 +387,7 @@ static void mtk_cldma_tx_done_work(struct work_struct *work)
 
 	mtk_cldma_unmask_intr(mdev, txq->hw->base_addr, DIR_TX, txq->txqno, QUEUE_XFER_DONE);
 	mtk_cldma_clear_ip_busy(mdev, txq->hw->base_addr);
+	pm_runtime_put(mdev->dev);
 }
 
 static void mtk_cldma_rx_done_work(struct work_struct *work)
@@ -401,6 +404,7 @@ static void mtk_cldma_rx_done_work(struct work_struct *work)
 
 	mdev = hw->mdev;
 
+	pm_runtime_get(mdev->dev);
 	do {
 		for (i = 0; i < rxq->req_pool_size; i++) {
 			req = rxq->req_pool + rxq->free_idx;
@@ -454,6 +458,7 @@ static void mtk_cldma_rx_done_work(struct work_struct *work)
 			break;
 
 		if (unlikely(state == LINK_ERROR_VAL)) {
+			pm_runtime_put(mdev->dev);
 			mtk_except_report_evt(mdev, EXCEPT_LINK_ERR);
 			return;
 		}
@@ -468,6 +473,7 @@ static void mtk_cldma_rx_done_work(struct work_struct *work)
 	mtk_cldma_unmask_intr(mdev, rxq->hw->base_addr, DIR_RX, rxq->rxqno, QUEUE_XFER_DONE);
 	mtk_cldma_mask_ip_busy_to_pci(mdev, rxq->hw->base_addr, rxq->rxqno, IP_BUSY_RXDONE);
 	mtk_cldma_clear_ip_busy(mdev, rxq->hw->base_addr);
+	pm_runtime_put(mdev->dev);
 }
 
 static int mtk_cldma_isr(int irq_id, void *param)
@@ -951,6 +957,52 @@ int mtk_cldma_start_xfer_t800(struct cldma_hw *hw, int qno)
 	return 0;
 }
 
+void mtk_cldma_suspend_t800(struct cldma_hw *hw)
+{
+	struct mtk_md_dev *mdev = hw->mdev;
+	struct txq *txq;
+	int i;
+
+	mtk_cldma_stop_queue(mdev, hw->base_addr, DIR_TX, ALLQ);
+
+	for (i = 0; i < HW_QUEUE_NUM; i++) {
+		txq = hw->txq[i];
+		if (txq)
+			flush_work(&txq->tx_done_work);
+	}
+}
+
+void mtk_cldma_suspend_late_t800(struct cldma_hw *hw)
+{
+	struct mtk_md_dev *mdev = hw->mdev;
+	struct rxq *rxq;
+	int i;
+
+	mtk_cldma_stop_queue(mdev, hw->base_addr, DIR_RX, ALLQ);
+
+	for (i = 0; i < HW_QUEUE_NUM; i++) {
+		rxq = hw->rxq[i];
+		if (rxq)
+			flush_work(&rxq->rx_done_work);
+	}
+
+	mtk_hw_mask_irq(mdev, hw->pci_ext_irq_id);
+}
+
+void mtk_cldma_resume_t800(struct cldma_hw *hw)
+{
+	struct mtk_md_dev *mdev = hw->mdev;
+	int i;
+
+	mtk_cldma_hw_init(hw->mdev, hw->base_addr);
+	for (i = 0; i < HW_QUEUE_NUM; i++) {
+		if (hw->rxq[i])
+			mtk_cldma_resume_queue(hw->mdev, hw->base_addr, DIR_RX, hw->rxq[i]->rxqno);
+	}
+
+	mtk_hw_unmask_irq(mdev, hw->pci_ext_irq_id);
+}
+
 static void mtk_cldma_hw_reset(struct mtk_md_dev *mdev, int hif_id)
 {
 	u32 val = mtk_hw_read32(mdev, REG_DEV_INFRA_BASE + REG_INFRA_RST0_SET);
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
index 470a40015f77..e16b9b6abdd6 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
+++ b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
@@ -18,5 +18,8 @@ int mtk_cldma_txq_free_t800(struct cldma_hw *hw, int vqno);
 struct rxq *mtk_cldma_rxq_alloc_t800(struct cldma_hw *hw, struct sk_buff *skb);
 int mtk_cldma_rxq_free_t800(struct cldma_hw *hw, int vqno);
 int mtk_cldma_start_xfer_t800(struct cldma_hw *hw, int qno);
+void mtk_cldma_suspend_t800(struct cldma_hw *hw);
+void mtk_cldma_suspend_late_t800(struct cldma_hw *hw);
+void mtk_cldma_resume_t800(struct cldma_hw *hw);
 void mtk_cldma_fsm_state_listener_t800(struct mtk_fsm_param *param, struct cldma_hw *hw);
 #endif
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.c b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
index 3565705754c7..ea89471df7d7 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_pci.c
+++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
@@ -350,6 +350,11 @@ static int mtk_pci_clear_irq(struct mtk_md_dev *mdev, int irq_id)
 	return 0;
 }
 
+static void mtk_pci_clear_sw_evt(struct mtk_md_dev *mdev, enum mtk_d2h_sw_evt evt)
+{
+	mtk_pci_mac_write32(mdev->hw_priv, REG_SW_TRIG_INTR_CLR, BIT(evt));
+}
+
 static int mtk_mhccif_register_evt(struct mtk_md_dev *mdev, u32 chs,
 				   int (*evt_cb)(u32 status, void *data), void *data)
 {
@@ -596,6 +601,14 @@ static int mtk_pci_get_hp_status(struct mtk_md_dev *mdev)
 	return priv->rc_hp_on;
 }
 
+static void mtk_pci_write_pm_cnt(struct mtk_md_dev *mdev, u32 val)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	mtk_pci_write32(mdev, priv->cfg->mhccif_rc_base_addr
+		+ MHCCIF_RC2EP_PCIE_PM_COUNTER, val);
+}
+
 static u32 mtk_pci_get_resume_state(struct mtk_md_dev *mdev)
 {
 	return mtk_pci_mac_read32(mdev->hw_priv, REG_PCIE_DEBUG_DUMMY_3);
@@ -618,6 +631,7 @@ static const struct mtk_hw_ops mtk_pci_ops = {
 	.mask_irq              = mtk_pci_mask_irq,
 	.unmask_irq            = mtk_pci_unmask_irq,
 	.clear_irq             = mtk_pci_clear_irq,
+	.clear_sw_evt          = mtk_pci_clear_sw_evt,
 	.register_ext_evt      = mtk_mhccif_register_evt,
 	.unregister_ext_evt    = mtk_mhccif_unregister_evt,
 	.mask_ext_evt          = mtk_mhccif_mask_evt,
@@ -630,6 +644,7 @@ static const struct mtk_hw_ops mtk_pci_ops = {
 	.link_check            = mtk_pci_link_check,
 	.mmio_check            = mtk_pci_mmio_check,
 	.get_hp_status         = mtk_pci_get_hp_status,
+	.write_pm_cnt          = mtk_pci_write_pm_cnt,
 };
 
 static void mtk_mhccif_isr_work(struct work_struct *work)
@@ -1170,12 +1185,117 @@ static const struct pci_error_handlers mtk_pci_err_handler = {
 	.resume = mtk_pci_io_resume,
 };
 
+static bool mtk_pci_check_init_status(struct mtk_md_dev *mdev)
+{
+	if (mtk_pci_mac_read32(mdev->hw_priv, REG_ATR_PCIE_WIN0_T0_SRC_ADDR_LSB) ==
+		ATR_WIN0_SRC_ADDR_LSB_DEFT)
+		/* Device reboots and isn't configured ATR, so it is default value. */
+		return TRUE;
+	return FALSE;
+}
+
+static int __maybe_unused mtk_pci_pm_suspend(struct device *dev)
+{
+	return mtk_pm_suspend(dev);
+}
+
+static int __maybe_unused mtk_pci_pm_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct mtk_md_dev *mdev;
+	bool atr_init;
+
+	mdev = pci_get_drvdata(pdev);
+	atr_init = mtk_pci_check_init_status(mdev);
+
+	return mtk_pm_resume(dev, atr_init);
+}
+
+static int __maybe_unused mtk_pci_pm_freeze(struct device *dev)
+{
+	return mtk_pm_freeze(dev);
+}
+
+static int __maybe_unused mtk_pci_pm_thaw(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct mtk_md_dev *mdev;
+	bool atr_init;
+
+	mdev = pci_get_drvdata(pdev);
+	atr_init = mtk_pci_check_init_status(mdev);
+
+	return mtk_pm_thaw(dev, atr_init);
+}
+
+static int __maybe_unused mtk_pci_pm_poweroff(struct device *dev)
+{
+	return mtk_pm_poweroff(dev);
+}
+
+static int __maybe_unused mtk_pci_pm_restore(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct mtk_md_dev *mdev;
+	bool atr_init;
+
+	mdev = pci_get_drvdata(pdev);
+	atr_init = mtk_pci_check_init_status(mdev);
+
+	return mtk_pm_restore(dev, atr_init);
+}
+
+static int __maybe_unused mtk_pci_pm_runtime_suspend(struct device *dev)
+{
+	return mtk_pm_runtime_suspend(dev);
+}
+
+static int __maybe_unused mtk_pci_pm_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct mtk_md_dev *mdev;
+	bool atr_init;
+
+	mdev = pci_get_drvdata(pdev);
+	atr_init = mtk_pci_check_init_status(mdev);
+
+	return mtk_pm_runtime_resume(dev, atr_init);
+}
+
+static int __maybe_unused mtk_pci_pm_runtime_idle(struct device *dev)
+{
+	return mtk_pm_runtime_idle(dev);
+}
+
+static void mtk_pci_pm_shutdown(struct pci_dev *pdev)
+{
+	struct mtk_md_dev *mdev;
+
+	mdev = pci_get_drvdata(pdev);
+
+	return mtk_pm_shutdown(mdev);
+}
+
+static const struct dev_pm_ops mtk_pci_pm_ops = {
+	.suspend = mtk_pci_pm_suspend,
+	.resume = mtk_pci_pm_resume,
+	.freeze = mtk_pci_pm_freeze,
+	.thaw = mtk_pci_pm_thaw,
+	.poweroff = mtk_pci_pm_poweroff,
+	.restore = mtk_pci_pm_restore,
+
+	SET_RUNTIME_PM_OPS(mtk_pci_pm_runtime_suspend, mtk_pci_pm_runtime_resume,
+			   mtk_pci_pm_runtime_idle)
+};
+
 static struct pci_driver mtk_pci_drv = {
 	.name = "mtk_pci_drv",
 	.id_table = mtk_pci_ids,
 
 	.probe =    mtk_pci_probe,
 	.remove =   mtk_pci_remove,
+	.driver.pm = &mtk_pci_pm_ops,
+	.shutdown = mtk_pci_pm_shutdown,
 
 	.err_handler = &mtk_pci_err_handler
 };
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_reg.h b/drivers/net/wwan/mediatek/pcie/mtk_reg.h
index 1159c29685c5..f568a2273879 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_reg.h
+++ b/drivers/net/wwan/mediatek/pcie/mtk_reg.h
@@ -25,6 +25,10 @@ enum mtk_ext_evt_d2h {
 	EXT_EVT_D2H_EXCEPT_CLEARQ_DONE     = 1 << 3,
 	EXT_EVT_D2H_EXCEPT_ALLQ_RESET      = 1 << 4,
 	EXT_EVT_D2H_BOOT_FLOW_SYNC         = 1 << 5,
+	EXT_EVT_D2H_PCIE_PM_SUSPEND_ACK    = 1 << 11,
+	EXT_EVT_D2H_PCIE_PM_RESUME_ACK     = 1 << 12,
+	EXT_EVT_D2H_PCIE_PM_SUSPEND_ACK_AP = 1 << 13,
+	EXT_EVT_D2H_PCIE_PM_RESUME_ACK_AP  = 1 << 14,
 	EXT_EVT_D2H_ASYNC_HS_NOTIFY_SAP    = 1 << 15,
 	EXT_EVT_D2H_ASYNC_HS_NOTIFY_MD     = 1 << 16,
 };
-- 
2.32.0

