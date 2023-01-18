Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F141671BCF
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjARMTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjARMRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:17:05 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CCA2D166;
        Wed, 18 Jan 2023 03:40:13 -0800 (PST)
X-UUID: dc2fa5a8972411eda06fc9ecc4dadd91-20230118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=nAGfX8B7YlkGWWYwlJKVYzvIQMIivQuspxp+I/Mk5CA=;
        b=QG22b9nenpL6bpB7NbRBpn4rQLj8L1IGHJXmQu7oGYY2vKz9WsabXsx8FaYx7BvuX+H1dibtsI1z069L8ir9ST/m4u3tmWoyNk+VHWvK+9V4yc93k7DXKzZe4Za79aYO2gyDmw/yaaQAHR+XR6k4ifVBqj4keKosTNP9kRLokpw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:10664f3e-10f3-4a0f-9af3-7e80855d2a72,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:3ca2d6b,CLOUDID:5b949e8c-8530-4eff-9f77-222cf6e2895b,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
X-CID-BVR: 0,NGT
X-UUID: dc2fa5a8972411eda06fc9ecc4dadd91-20230118
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 2019510653; Wed, 18 Jan 2023 19:40:08 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 18 Jan 2023 19:40:07 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 18 Jan 2023 19:40:04 +0800
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
Subject: [PATCH net-next v2 01/12] net: wwan: tmi: Add PCIe core
Date:   Wed, 18 Jan 2023 19:38:48 +0800
Message-ID: <20230118113859.175836-2-yanchao.yang@mediatek.com>
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

Registers the TMI device driver with the kernel. Set up all the fundamental
configurations for the device: PCIe layer, Modem Host Cross Core Interface
(MHCCIF), Reset Generation Unit (RGU), modem common control operations and
build infrastructure.

* PCIe layer code implements driver probe and removal, MSI-X interrupt
initialization and de-initialization, and the way of resetting the device.
* MHCCIF provides interrupt channels to communicate events such as handshake,
PM and port enumeration.
* RGU provides interrupt channels to generate notifications from the device
so that the TMI driver could get the device reset.
* Modem common control operations provide the basic read/write functions of
the device's hardware registers, mask/unmask/get/clear functions of the
device's interrupt registers and inquiry functions of the device's status.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
Signed-off-by: Ting Wang <ting.wang@mediatek.com>
---
 drivers/net/wwan/Kconfig                 |   13 +
 drivers/net/wwan/Makefile                |    1 +
 drivers/net/wwan/mediatek/Makefile       |   11 +
 drivers/net/wwan/mediatek/mtk_common.h   |   30 +
 drivers/net/wwan/mediatek/mtk_dev.h      |  463 +++++++++
 drivers/net/wwan/mediatek/pcie/mtk_pci.c | 1124 ++++++++++++++++++++++
 drivers/net/wwan/mediatek/pcie/mtk_pci.h |  150 +++
 drivers/net/wwan/mediatek/pcie/mtk_reg.h |   69 ++
 8 files changed, 1861 insertions(+)
 create mode 100644 drivers/net/wwan/mediatek/Makefile
 create mode 100644 drivers/net/wwan/mediatek/mtk_common.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_dev.h
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_pci.c
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_pci.h
 create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_reg.h

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 410b0245114e..1422fea75932 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -120,6 +120,19 @@ config MTK_T7XX
 
 	  If unsure, say N.
 
+config MTK_TMI
+	tristate "TMI Driver for Mediatek T-series Device"
+	depends on PCI
+	help
+	  This driver enables Mediatek T-series WWAN Device communication.
+	  The TMI is intended for t8xx T-series modem chips. Currently, t7xx
+	  is not supported.
+
+	  If you have one of those Mediatek T-series WWAN Modules and wish to
+	  use it in Linux say Y/M here.
+
+	  If unsure, say N.
+
 endif # WWAN
 
 endmenu
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
index 3960c0ae2445..198d8074851f 100644
--- a/drivers/net/wwan/Makefile
+++ b/drivers/net/wwan/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_QCOM_BAM_DMUX) += qcom_bam_dmux.o
 obj-$(CONFIG_RPMSG_WWAN_CTRL) += rpmsg_wwan_ctrl.o
 obj-$(CONFIG_IOSM) += iosm/
 obj-$(CONFIG_MTK_T7XX) += t7xx/
+obj-$(CONFIG_MTK_TMI) += mediatek/
diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
new file mode 100644
index 000000000000..5ba75d0592d3
--- /dev/null
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: BSD-3-Clause-Clear
+
+MODULE_NAME := mtk_tmi
+
+mtk_tmi-y = \
+	pcie/mtk_pci.o
+
+ccflags-y += -I$(srctree)/$(src)/
+ccflags-y += -I$(srctree)/$(src)/pcie/
+
+obj-$(CONFIG_MTK_TMI) += mtk_tmi.o
diff --git a/drivers/net/wwan/mediatek/mtk_common.h b/drivers/net/wwan/mediatek/mtk_common.h
new file mode 100644
index 000000000000..516d3d9e02cf
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_common.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef _MTK_COMMON_H
+#define _MTK_COMMON_H
+
+#include <linux/device.h>
+
+#define MTK_UEVENT_INFO_LEN 128
+
+/* MTK uevent */
+enum mtk_uevent_id {
+	MTK_UEVENT_FSM = 1,
+	MTK_UEVENT_MAX
+};
+
+static inline void mtk_uevent_notify(struct device *dev, enum mtk_uevent_id id, const char *info)
+{
+	char buf[MTK_UEVENT_INFO_LEN];
+	char *ext[2] = {NULL, NULL};
+
+	snprintf(buf, MTK_UEVENT_INFO_LEN, "%s:event_id=%d, info=%s",
+		 dev->kobj.name, id, info);
+	ext[0] = buf;
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, ext);
+}
+
+#endif /* _MTK_COMMON_H */
diff --git a/drivers/net/wwan/mediatek/mtk_dev.h b/drivers/net/wwan/mediatek/mtk_dev.h
new file mode 100644
index 000000000000..312fbf66fffa
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_dev.h
@@ -0,0 +1,463 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_DEV_H__
+#define __MTK_DEV_H__
+
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+
+#define MTK_DEV_STR_LEN 16
+
+enum mtk_irq_src {
+	MTK_IRQ_SRC_MIN,
+	MTK_IRQ_SRC_MHCCIF,
+	MTK_IRQ_SRC_SAP_RGU,
+	MTK_IRQ_SRC_DPMAIF,
+	MTK_IRQ_SRC_DPMAIF2,
+	MTK_IRQ_SRC_CLDMA0,
+	MTK_IRQ_SRC_CLDMA1,
+	MTK_IRQ_SRC_CLDMA2,
+	MTK_IRQ_SRC_CLDMA3,
+	MTK_IRQ_SRC_PM_LOCK,
+	MTK_IRQ_SRC_DPMAIF3,
+	MTK_IRQ_SRC_MAX
+};
+
+enum mtk_user_id {
+	MTK_USER_HW,
+	MTK_USER_CTRL,
+	MTK_USER_DPMAIF,
+	MTK_USER_PM,
+	MTK_USER_EXCEPT,
+	MTK_USER_MAX
+};
+
+enum mtk_reset_type {
+	RESET_FLDR,
+	RESET_PLDR,
+	RESET_RGU,
+};
+
+enum mtk_reinit_type {
+	REINIT_TYPE_RESUME,
+	REINIT_TYPE_EXP,
+};
+
+enum mtk_l1ss_grp {
+	L1SS_PM,
+	L1SS_EXT_EVT,
+};
+
+#define L1SS_BIT_L1(grp)     BIT(((grp) << 2) + 1)
+#define L1SS_BIT_L1_1(grp)   BIT(((grp) << 2) + 2)
+#define L1SS_BIT_L1_2(grp)   BIT(((grp) << 2) + 3)
+
+struct mtk_md_dev;
+
+/**
+ * struct mtk_hw_ops - The HW layer operations provided to transaction layer.
+ * @read32:         Callback to read 32-bit register.
+ *                  Read value from MD. For PCIe, it's BAR 2/3 MMIO read.
+ * @write32:        Callback to write 32-bit register.
+ *                  Write value to MD. For PCIe, it's BAR 2/3 MMIO write.
+ * @get_dev_state:  Callback to get the device's state.
+ * @ack_dev_state:  Callback to acknowledge device state.
+ * @get_ds_status:  Callback to get device deep sleep status.
+ * @ds_lock:        Callback to lock the deep sleep of device.
+ * @ds_unlock:      Callback to unlock the deep sleep of device.
+ * @set_l1ss:       Callback to set the link L1 and L1ss enable/disable.
+ * @get_resume_state:Callback to get PM resume information that device writes.
+ * @get_irq_id:     Callback to get the irq id specific IP on a chip.
+ * @get_virq_id:     Callback to get the system virtual IRQ.
+ * @register_irq:   Callback to register callback function to specific hardware IP.
+ * @unregister_irq: Callback to unregister callback function to specific hardware IP.
+ * @mask_irq:       Callback to mask the interrupt of specific hardware IP.
+ * @unmask_irq:     Callback to unmask the interrupt of specific hardware IP.
+ * @clear_irq:      Callback to clear the interrupt of specific hardware IP.
+ * @register_ext_evt:Callback to register HW Layer external event.
+ * @unregister_ext_evt:Callback to unregister HW Layer external event.
+ * @mask_ext_evt:   Callback to mask HW Layer external event.
+ * @unmask_ext_evt: Callback to unmask HW Layer external event.
+ * @clear_ext_evt:  Callback to clear HW Layer external event status.
+ * @send_ext_evt:   Callback to send HW Layer external event.
+ * @get_ext_evt_status:Callback to get HW Layer external event status.
+ * @reset:          Callback to reset device.
+ * @reinit:         Callback to execute device re-initialization.
+ * @get_hp_status:  Callback to get link hotplug status.
+ */
+struct mtk_hw_ops {
+	u32 (*read32)(struct mtk_md_dev *mdev, u64 addr);
+	void (*write32)(struct mtk_md_dev *mdev, u64 addr, u32 val);
+	u32 (*get_dev_state)(struct mtk_md_dev *mdev);
+	void (*ack_dev_state)(struct mtk_md_dev *mdev, u32 state);
+	u32 (*get_ds_status)(struct mtk_md_dev *mdev);
+	void (*ds_lock)(struct mtk_md_dev *mdev);
+	void (*ds_unlock)(struct mtk_md_dev *mdev);
+	void (*set_l1ss)(struct mtk_md_dev *mdev, u32 type, bool enable);
+	u32 (*get_resume_state)(struct mtk_md_dev *mdev);
+	int (*get_irq_id)(struct mtk_md_dev *mdev, enum mtk_irq_src irq_src);
+	int (*get_virq_id)(struct mtk_md_dev *mdev, int irq_id);
+	int (*register_irq)(struct mtk_md_dev *mdev, int irq_id,
+			    int (*irq_cb)(int irq_id, void *data), void *data);
+	int (*unregister_irq)(struct mtk_md_dev *mdev, int irq_id);
+	int (*mask_irq)(struct mtk_md_dev *mdev, int irq_id);
+	int (*unmask_irq)(struct mtk_md_dev *mdev, int irq_id);
+	int (*clear_irq)(struct mtk_md_dev *mdev, int irq_id);
+	int (*register_ext_evt)(struct mtk_md_dev *mdev, u32 chs,
+				int (*evt_cb)(u32 status, void *data), void *data);
+	int (*unregister_ext_evt)(struct mtk_md_dev *mdev, u32 chs);
+	void (*mask_ext_evt)(struct mtk_md_dev *mdev, u32 chs);
+	void (*unmask_ext_evt)(struct mtk_md_dev *mdev, u32 chs);
+	void (*clear_ext_evt)(struct mtk_md_dev *mdev, u32 chs);
+	int (*send_ext_evt)(struct mtk_md_dev *mdev, u32 ch);
+	u32 (*get_ext_evt_status)(struct mtk_md_dev *mdev);
+
+	int (*reset)(struct mtk_md_dev *mdev, enum mtk_reset_type type);
+	int (*reinit)(struct mtk_md_dev *mdev, enum mtk_reinit_type type);
+	int (*get_hp_status)(struct mtk_md_dev *mdev);
+};
+
+/**
+ * struct mtk_md_dev - defines the context structure of MTK modem device.
+ * @dev:        pointer to the generic device object.
+ * @hw_ops:     operations provided by HW layer.
+ * @hw_priv:    pointer to HW layer proprietary context data.
+ * @hw_ver:     to keep HW chip ID.
+ * @msi_nvecs:  to keep the amount of aollocated irq vectors.
+ * @dev_str:    to keep device B-D-F information.
+ */
+struct mtk_md_dev {
+	struct device *dev;
+	const struct mtk_hw_ops *hw_ops;
+	void *hw_priv;
+	u32 hw_ver;
+	int msi_nvecs;
+	char dev_str[MTK_DEV_STR_LEN];
+};
+
+/**
+ * mtk_hw_read32() - Read dword from register.
+ * @mdev: Device instance.
+ * @addr: Register address.
+ *
+ * Return: Dword register value.
+ */
+static inline u32 mtk_hw_read32(struct mtk_md_dev *mdev, u64 addr)
+{
+	return mdev->hw_ops->read32(mdev, addr);
+}
+
+/**
+ * mtk_hw_write32() - Write dword to register.
+ * @mdev: Device instance.
+ * @addr: Register address.
+ * @val: Dword to be written.
+ */
+static inline void mtk_hw_write32(struct mtk_md_dev *mdev, u64 addr, u32 val)
+{
+	mdev->hw_ops->write32(mdev, addr, val);
+}
+
+/**
+ * mtk_hw_get_dev_state() - Get device's state register.
+ * @mdev: Device instance.
+ *
+ * Return: The value of state register.
+ */
+static inline u32 mtk_hw_get_dev_state(struct mtk_md_dev *mdev)
+{
+	return mdev->hw_ops->get_dev_state(mdev);
+}
+
+/**
+ * mtk_hw_ack_dev_state() - Write state to device's state register.
+ * @mdev: Device instance.
+ * @state: The state value to be written.
+ */
+static inline void mtk_hw_ack_dev_state(struct mtk_md_dev *mdev, u32 state)
+{
+	mdev->hw_ops->ack_dev_state(mdev, state);
+}
+
+/**
+ * mtk_hw_get_ds_status() - Get device's deep sleep status.
+ * @mdev: Device instance.
+ *
+ * Return: The value of deep sleep register.
+ */
+static inline u32 mtk_hw_get_ds_status(struct mtk_md_dev *mdev)
+{
+	return mdev->hw_ops->get_ds_status(mdev);
+}
+
+/**
+ * mtk_hw_ds_lock() - Prevent the device from entering deep sleep.
+ * @mdev: Device instance.
+ */
+static inline void mtk_hw_ds_lock(struct mtk_md_dev *mdev)
+{
+	mdev->hw_ops->ds_lock(mdev);
+}
+
+/**
+ * mtk_hw_ds_unlock() - Allow the device from entering deep sleep.
+ * @mdev: Device instance.
+ */
+static inline void mtk_hw_ds_unlock(struct mtk_md_dev *mdev)
+{
+	mdev->hw_ops->ds_unlock(mdev);
+}
+
+/**
+ * mtk_hw_set_l1ss() - Enable or disable l1ss.
+ * @mdev: Device instance.
+ * @type: Select the sub-function of l1ss by bit,
+ *        please see "enum mtk_l1ss_grp" and "L1SS_BIT_L1", "L1SS_BIT_L1_1", "L1SS_BIT_L1_2".
+ * @enable: Input true or false.
+ */
+static inline void mtk_hw_set_l1ss(struct mtk_md_dev *mdev, u32 type, bool enable)
+{
+	mdev->hw_ops->set_l1ss(mdev, type, enable);
+}
+
+/**
+ * mtk_hw_get_resume_state() - Get device resume status.
+ * @mdev: Device instance.
+ *
+ * Return: The resume state of device.
+ */
+static inline u32 mtk_hw_get_resume_state(struct mtk_md_dev *mdev)
+{
+	return mdev->hw_ops->get_resume_state(mdev);
+}
+
+/**
+ * mtk_hw_get_irq_id() - Get hardware irq_id by virtual irq_src.
+ * @mdev: Device instance.
+ * @irq_src: Virtual irq source number.
+ *
+ * Return:
+ * * a negative value - indicates failure.
+ * * other values - are valid irq_id.
+ */
+static inline int mtk_hw_get_irq_id(struct mtk_md_dev *mdev, enum mtk_irq_src irq_src)
+{
+	return mdev->hw_ops->get_irq_id(mdev, irq_src);
+}
+
+/**
+ * mtk_hw_get_virq_id() - Get system virtual IRQ  by hardware irq_id.
+ * @mdev: Device instance.
+ * @irq_id: Interrupt source id.
+ *
+ * Return:  System virtual IRQ.
+ */
+static inline int mtk_hw_get_virq_id(struct mtk_md_dev *mdev, int irq_id)
+{
+	return mdev->hw_ops->get_virq_id(mdev, irq_id);
+}
+
+/**
+ * mtk_hw_register_irq() - Register the interrupt callback to irq_id.
+ * @mdev: Device instance.
+ * @irq_id: Hardware irq id.
+ * @irq_cb: The interrupt callback.
+ * @data: Private data for callback.
+ *
+ * Return:
+ * * 0 - indicates success.
+ * * other value - indicates failure.
+ */
+static inline int mtk_hw_register_irq(struct mtk_md_dev *mdev, int irq_id,
+				      int (*irq_cb)(int irq_id, void *data), void *data)
+{
+	return mdev->hw_ops->register_irq(mdev, irq_id, irq_cb, data);
+}
+
+/**
+ * mtk_hw_unregister_irq() - Unregister the interrupt callback to irq_id.
+ * @mdev: Device instance.
+ * @irq_id: Hardware irq id.
+ *
+ * Return:
+ * * 0 - indicates success.
+ * * other value - indicates failure.
+ */
+static inline int mtk_hw_unregister_irq(struct mtk_md_dev *mdev, int irq_id)
+{
+	return mdev->hw_ops->unregister_irq(mdev, irq_id);
+}
+
+/**
+ * mtk_hw_mask_irq() - Mask interrupt.
+ * @mdev: Device instance.
+ * @irq_id: Hardware irq id.
+ *
+ * Return:
+ * * 0 - indicates success.
+ * * other value - indicates failure.
+ */
+static inline int mtk_hw_mask_irq(struct mtk_md_dev *mdev, int irq_id)
+{
+	return mdev->hw_ops->mask_irq(mdev, irq_id);
+}
+
+/**
+ * mtk_hw_unmask_irq() - Unmask interrupt.
+ * @mdev: Device instance.
+ * @irq_id: Hardware irq id.
+ *
+ * Return:
+ * * 0 - indicates success.
+ * * other value - indicates failure.
+ */
+static inline int mtk_hw_unmask_irq(struct mtk_md_dev *mdev, int irq_id)
+{
+	return mdev->hw_ops->unmask_irq(mdev, irq_id);
+}
+
+/**
+ * mtk_hw_clear_irq() - Clear interrupt.
+ * @mdev: Device instance.
+ * @irq_id: Hardware irq id.
+ *
+ * Return:
+ * * 0 - indicates success.
+ * * other value - indicates failure.
+ */
+static inline int mtk_hw_clear_irq(struct mtk_md_dev *mdev, int irq_id)
+{
+	return mdev->hw_ops->clear_irq(mdev, irq_id);
+}
+
+/**
+ * mtk_hw_register_ext_evt() - Register callback to external events.
+ * @mdev: Device instance.
+ * @chs: External event channels.
+ * @evt_cb: External events callback.
+ * @data: Private data for callback.
+ *
+ * Return:
+ * * 0 - indicates success.
+ * * other value - indicates failure.
+ */
+static inline int mtk_hw_register_ext_evt(struct mtk_md_dev *mdev, u32 chs,
+					  int (*evt_cb)(u32 status, void *data), void *data)
+{
+	return mdev->hw_ops->register_ext_evt(mdev, chs, evt_cb, data);
+}
+
+/**
+ * mtk_hw_unregister_ext_evt() - Unregister callback to external events.
+ * @mdev: Device instance.
+ * @chs: External event channels.
+ *
+ * Return:
+ * * 0 - indicates success.
+ * * other value - indicates failure.
+ */
+static inline int mtk_hw_unregister_ext_evt(struct mtk_md_dev *mdev, u32 chs)
+{
+	return mdev->hw_ops->unregister_ext_evt(mdev, chs);
+}
+
+/**
+ * mtk_hw_mask_ext_evt() - Mask external events.
+ * @mdev: Device instance.
+ * @chs: External event channels.
+ */
+static inline void mtk_hw_mask_ext_evt(struct mtk_md_dev *mdev, u32 chs)
+{
+	mdev->hw_ops->mask_ext_evt(mdev, chs);
+}
+
+/**
+ * mtk_hw_unmask_ext_evt() - Unmask external events.
+ * @mdev: Device instance.
+ * @chs: External event channels.
+ */
+static inline void mtk_hw_unmask_ext_evt(struct mtk_md_dev *mdev, u32 chs)
+{
+	mdev->hw_ops->unmask_ext_evt(mdev, chs);
+}
+
+/**
+ * mtk_hw_clear_ext_evt() - Clear external events.
+ * @mdev: Device instance.
+ * @chs: External event channels.
+ */
+static inline void mtk_hw_clear_ext_evt(struct mtk_md_dev *mdev, u32 chs)
+{
+	mdev->hw_ops->clear_ext_evt(mdev, chs);
+}
+
+/**
+ * mtk_hw_send_ext_evt() - Send external event to device.
+ * @mdev: Device instance.
+ * @ch: External event channel, only allow one channel at a time.
+ *
+ * Return:
+ * * 0 - indicates success.
+ * * other value - indicates failure.
+ */
+static inline int mtk_hw_send_ext_evt(struct mtk_md_dev *mdev, u32 ch)
+{
+	return mdev->hw_ops->send_ext_evt(mdev, ch);
+}
+
+/**
+ * mtk_hw_get_ext_evt_status() - Get external event status of device.
+ * @mdev: Device instance.
+ *
+ * Return: External event status of device.
+ */
+static inline u32 mtk_hw_get_ext_evt_status(struct mtk_md_dev *mdev)
+{
+	return mdev->hw_ops->get_ext_evt_status(mdev);
+}
+
+/**
+ * mtk_hw_reset() - Reset device.
+ * @mdev: Device instance.
+ * @type: Reset type.
+ *
+ * Return:
+ * * 0 - indicates success.
+ * * other value - indicates failure.
+ */
+static inline int mtk_hw_reset(struct mtk_md_dev *mdev, enum mtk_reset_type type)
+{
+	return mdev->hw_ops->reset(mdev, type);
+}
+
+/**
+ * mtk_hw_reinit() - Reinitialize device.
+ * @mdev: Device instance.
+ * @type: Reinit type.
+ *
+ * Return:
+ * * 0 - indicates success.
+ * * other value - indicates failure.
+ */
+static inline int mtk_hw_reinit(struct mtk_md_dev *mdev, enum mtk_reinit_type type)
+{
+	return mdev->hw_ops->reinit(mdev, type);
+}
+
+/**
+ * mtk_hw_get_hp_status() - Get whether the device can be hot-plugged.
+ * @mdev: Device instance.
+ *
+ * Return:
+ * * 0 - indicates can't.
+ * * other value - indicates can.
+ */
+static inline int mtk_hw_get_hp_status(struct mtk_md_dev *mdev)
+{
+	return mdev->hw_ops->get_hp_status(mdev);
+}
+
+#endif /* __MTK_DEV_H__ */
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.c b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
new file mode 100644
index 000000000000..5261cebb61b1
--- /dev/null
+++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
@@ -0,0 +1,1124 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/acpi.h>
+#include <linux/aer.h>
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "mtk_pci.h"
+#include "mtk_reg.h"
+
+#define MTK_PCI_TRANSPARENT_ATR_SIZE	(0x3F)
+
+static u32 mtk_pci_mac_read32(struct mtk_pci_priv *priv, u64 addr)
+{
+	return ioread32(priv->mac_reg_base + addr);
+}
+
+static void mtk_pci_mac_write32(struct mtk_pci_priv *priv, u64 addr, u32 val)
+{
+	iowrite32(val, priv->mac_reg_base + addr);
+}
+
+static void mtk_pci_set_msix_merged(struct mtk_pci_priv *priv, int irq_cnt)
+{
+	mtk_pci_mac_write32(priv, REG_PCIE_CFG_MSIX, ffs(irq_cnt) * 2 - 1);
+}
+
+static int mtk_pci_setup_atr(struct mtk_md_dev *mdev, struct mtk_atr_cfg *cfg)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	u32 addr, val, size_h, size_l;
+	int atr_size, pos, offset;
+
+	if (cfg->transparent) {
+		atr_size = MTK_PCI_TRANSPARENT_ATR_SIZE; /* No address conversion is performed */
+	} else {
+		if (cfg->src_addr & (cfg->size - 1)) {
+			dev_err(mdev->dev, "Invalid atr src addr is not aligned to size\n");
+			return -EFAULT;
+		}
+		if (cfg->trsl_addr & (cfg->size - 1)) {
+			dev_err(mdev->dev,
+				"Invalid atr trsl addr is not aligned to size, %llx, %llx\n",
+				cfg->trsl_addr,
+				cfg->size - 1);
+			return -EFAULT;
+		}
+
+		size_l = FIELD_GET(GENMASK_ULL(31, 0), cfg->size);
+		size_h = FIELD_GET(GENMASK_ULL(63, 32), cfg->size);
+
+		pos = ffs(size_l);
+		if (pos) {
+			/* Address Translate Space Size is equal to 2^(atr_size+1).
+			 * "-2" means "-1-1", the first "-1" is because of the atr_size register,
+			 * the second is because of the ffs() will increase by one.
+			 */
+			atr_size = pos - 2;
+		} else {
+			pos = ffs(size_h);
+			/* "+30" means "+32-1-1", the meaning of "-1-1" is same as above,
+			 * "+32" is because atr_size is large, exceeding 32-bits.
+			 */
+			atr_size = pos + 30;
+		}
+	}
+
+	/* Calculate table offset */
+	offset = ATR_PORT_OFFSET * cfg->port + ATR_TABLE_OFFSET * cfg->table;
+	/* SRC_ADDR_H */
+	addr = REG_ATR_PCIE_WIN0_T0_SRC_ADDR_MSB + offset;
+	val = (u32)(cfg->src_addr >> 32);
+	mtk_pci_mac_write32(priv, addr, val);
+	/* SRC_ADDR_L */
+	addr = REG_ATR_PCIE_WIN0_T0_SRC_ADDR_LSB + offset;
+	val = (u32)(cfg->src_addr & 0xFFFFF000) | (atr_size << 1) | 0x1;
+	mtk_pci_mac_write32(priv, addr, val);
+
+	/* TRSL_ADDR_H */
+	addr = REG_ATR_PCIE_WIN0_T0_TRSL_ADDR_MSB + offset;
+	val = (u32)(cfg->trsl_addr >> 32);
+	mtk_pci_mac_write32(priv, addr, val);
+	/* TRSL_ADDR_L */
+	addr = REG_ATR_PCIE_WIN0_T0_TRSL_ADDR_LSB + offset;
+	val = (u32)(cfg->trsl_addr & 0xFFFFF000);
+	mtk_pci_mac_write32(priv, addr, val);
+
+	/* TRSL_PARAM */
+	addr = REG_ATR_PCIE_WIN0_T0_TRSL_PARAM + offset;
+	val = (cfg->trsl_param << 16) | cfg->trsl_id;
+	mtk_pci_mac_write32(priv, addr, val);
+
+	return 0;
+}
+
+static void mtk_pci_atr_disable(struct mtk_pci_priv *priv)
+{
+	int port, tbl, offset;
+
+	/* Disable all ATR table for all ports */
+	for (port = ATR_SRC_PCI_WIN0; port <= ATR_SRC_AXIS_3; port++)
+		for (tbl = 0; tbl < ATR_TABLE_NUM_PER_ATR; tbl++) {
+			/* Calculate table offset */
+			offset = ATR_PORT_OFFSET * port + ATR_TABLE_OFFSET * tbl;
+			/* Disable table by SRC_ADDR_L */
+			mtk_pci_mac_write32(priv, REG_ATR_PCIE_WIN0_T0_SRC_ADDR_LSB + offset, 0);
+		}
+}
+
+static int mtk_pci_atr_init(struct mtk_md_dev *mdev)
+{
+	struct pci_dev *pdev = to_pci_dev(mdev->dev);
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	struct mtk_atr_cfg cfg;
+	int port, ret;
+
+	mtk_pci_atr_disable(priv);
+
+	/* Config ATR for RC to access device's register */
+	cfg.src_addr = pci_resource_start(pdev, MTK_BAR_2_3_IDX);
+	cfg.size = ATR_PCIE_REG_SIZE;
+	cfg.trsl_addr = ATR_PCIE_REG_TRSL_ADDR;
+	cfg.type = ATR_PCI2AXI;
+	cfg.port = ATR_PCIE_REG_PORT;
+	cfg.table = ATR_PCIE_REG_TABLE_NUM;
+	cfg.trsl_id = ATR_PCIE_REG_TRSL_PORT;
+	cfg.trsl_param = 0x0;
+	cfg.transparent = 0x0;
+	ret = mtk_pci_setup_atr(mdev, &cfg);
+	if (ret)
+		return ret;
+
+	/* Config ATR for MHCCIF */
+	cfg.src_addr = pci_resource_start(pdev, MTK_BAR_2_3_IDX);
+	cfg.src_addr += priv->cfg->mhccif_rc_base_addr - ATR_PCIE_REG_TRSL_ADDR;
+	cfg.size = priv->cfg->mhccif_trsl_size;
+	cfg.trsl_addr = priv->cfg->mhccif_rc_reg_trsl_addr;
+	cfg.type = ATR_PCI2AXI;
+	cfg.port = ATR_PCIE_REG_PORT;
+	cfg.table = ART_PCIE_REG_MHCCIF_TABLE_NUM;
+	cfg.trsl_id = ATR_PCIE_REG_TRSL_PORT;
+	cfg.trsl_param = 0x0;
+	cfg.transparent = 0x0;
+	ret = mtk_pci_setup_atr(mdev, &cfg);
+	if (ret)
+		return ret;
+
+	/* Config ATR for EP to access RC's memory */
+	for (port = ATR_PCIE_DEV_DMA_PORT_START; port <= ATR_PCIE_DEV_DMA_PORT_END; port++) {
+		cfg.src_addr = ATR_PCIE_DEV_DMA_SRC_ADDR;
+		cfg.size = ATR_PCIE_DEV_DMA_SIZE;
+		cfg.trsl_addr = ATR_PCIE_DEV_DMA_TRSL_ADDR;
+		cfg.type = ATR_AXI2PCI;
+		cfg.port = port;
+		cfg.table = ATR_PCIE_DEV_DMA_TABLE_NUM;
+		cfg.trsl_id = ATR_DST_PCI_TRX;
+		cfg.trsl_param = 0x0;
+		/* Enable transparent translation */
+		cfg.transparent = ATR_PCIE_DEV_DMA_TRANSPARENT;
+		ret = mtk_pci_setup_atr(mdev, &cfg);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static u32 mtk_pci_read32(struct mtk_md_dev *mdev, u64 addr)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	return ioread32(priv->ext_reg_base + addr);
+}
+
+static void mtk_pci_write32(struct mtk_md_dev *mdev, u64 addr, u32 val)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	iowrite32(val, priv->ext_reg_base + addr);
+}
+
+static u32 mtk_pci_get_dev_state(struct mtk_md_dev *mdev)
+{
+	return mtk_pci_mac_read32(mdev->hw_priv, REG_PCIE_DEBUG_DUMMY_7);
+}
+
+static void mtk_pci_ack_dev_state(struct mtk_md_dev *mdev, u32 state)
+{
+	mtk_pci_mac_write32(mdev->hw_priv, REG_PCIE_DEBUG_DUMMY_7, state);
+}
+
+static void mtk_pci_force_mac_active(struct mtk_md_dev *mdev, bool enable)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	u32 reg;
+
+	reg = mtk_pci_mac_read32(priv, REG_PCIE_MISC_CTRL);
+	if (enable)
+		reg |= MTK_FORCE_MAC_ACTIVE_BIT;
+	else
+		reg &= ~MTK_FORCE_MAC_ACTIVE_BIT;
+	mtk_pci_mac_write32(priv, REG_PCIE_MISC_CTRL, reg);
+}
+
+static u32 mtk_pci_get_ds_status(struct mtk_md_dev *mdev)
+{
+	u32 reg;
+
+	mtk_pci_force_mac_active(mdev, true);
+	reg = mtk_pci_mac_read32(mdev->hw_priv, REG_PCIE_RESOURCE_STATUS);
+	mtk_pci_force_mac_active(mdev, false);
+
+	return reg;
+}
+
+static void mtk_pci_ds_lock(struct mtk_md_dev *mdev)
+{
+	mtk_pci_mac_write32(mdev->hw_priv, REG_PCIE_PEXTP_MAC_SLEEP_CTRL,
+			    MTK_DISABLE_DS_BIT(0));
+}
+
+static void mtk_pci_ds_unlock(struct mtk_md_dev *mdev)
+{
+	mtk_pci_mac_write32(mdev->hw_priv, REG_PCIE_PEXTP_MAC_SLEEP_CTRL,
+			    MTK_ENABLE_DS_BIT(0));
+}
+
+static void mtk_pci_set_l1ss(struct mtk_md_dev *mdev, u32 type, bool enable)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	u32 addr = REG_DIS_ASPM_LOWPWR_SET_0;
+
+	if (enable)
+		addr = REG_DIS_ASPM_LOWPWR_CLR_0;
+
+	mtk_pci_mac_write32(priv, addr, type);
+}
+
+static int mtk_pci_get_irq_id(struct mtk_md_dev *mdev, enum mtk_irq_src irq_src)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	const int *irq_tbl = priv->cfg->irq_tbl;
+	int irq_id = -EINVAL;
+
+	if (irq_src > MTK_IRQ_SRC_MIN && irq_src < MTK_IRQ_SRC_MAX) {
+		irq_id = irq_tbl[irq_src];
+		if (unlikely(irq_id < 0 || irq_id >= MTK_IRQ_CNT_MAX))
+			irq_id = -EINVAL;
+	}
+
+	return irq_id;
+}
+
+static int mtk_pci_get_virq_id(struct mtk_md_dev *mdev, int irq_id)
+{
+	struct pci_dev *pdev = to_pci_dev(mdev->dev);
+	int nr = 0;
+
+	if (pdev->msix_enabled)
+		nr = irq_id % mdev->msi_nvecs;
+
+	return pci_irq_vector(pdev, nr);
+}
+
+static int mtk_pci_register_irq(struct mtk_md_dev *mdev, int irq_id,
+				int (*irq_cb)(int irq_id, void *data), void *data)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	if (unlikely((irq_id < 0 || irq_id >= MTK_IRQ_CNT_MAX) || !irq_cb))
+		return -EINVAL;
+
+	if (priv->irq_cb_list[irq_id]) {
+		dev_err(mdev->dev,
+			"Unable to register irq, irq_id=%d, it's already been register by %ps.\n",
+			irq_id, priv->irq_cb_list[irq_id]);
+		return -EFAULT;
+	}
+	priv->irq_cb_list[irq_id] = irq_cb;
+	priv->irq_cb_data[irq_id] = data;
+
+	return 0;
+}
+
+static int mtk_pci_unregister_irq(struct mtk_md_dev *mdev, int irq_id)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	if (unlikely(irq_id < 0 || irq_id >= MTK_IRQ_CNT_MAX))
+		return -EINVAL;
+
+	if (!priv->irq_cb_list[irq_id]) {
+		dev_err(mdev->dev, "irq_id=%d has not been registered\n", irq_id);
+		return -EFAULT;
+	}
+	priv->irq_cb_list[irq_id] = NULL;
+	priv->irq_cb_data[irq_id] = NULL;
+
+	return 0;
+}
+
+static int mtk_pci_mask_irq(struct mtk_md_dev *mdev, int irq_id)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	if (unlikely((irq_id < 0 || irq_id >= MTK_IRQ_CNT_MAX) || priv->irq_type != PCI_IRQ_MSIX)) {
+		dev_err(mdev->dev, "Failed to mask irq: input irq_id=%d\n", irq_id);
+		return -EINVAL;
+	}
+
+	mtk_pci_mac_write32(priv, REG_IMASK_HOST_MSIX_CLR_GRP0_0, BIT(irq_id));
+
+	return 0;
+}
+
+static int mtk_pci_unmask_irq(struct mtk_md_dev *mdev, int irq_id)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	if (unlikely((irq_id < 0 || irq_id >= MTK_IRQ_CNT_MAX) || priv->irq_type != PCI_IRQ_MSIX)) {
+		dev_err(mdev->dev, "Failed to unmask irq: input irq_id=%d\n", irq_id);
+		return -EINVAL;
+	}
+
+	mtk_pci_mac_write32(priv, REG_IMASK_HOST_MSIX_SET_GRP0_0, BIT(irq_id));
+
+	return 0;
+}
+
+static int mtk_pci_clear_irq(struct mtk_md_dev *mdev, int irq_id)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	if (unlikely((irq_id < 0 || irq_id >= MTK_IRQ_CNT_MAX) || priv->irq_type != PCI_IRQ_MSIX)) {
+		dev_err(mdev->dev, "Failed to clear irq: input irq_id=%d\n", irq_id);
+		return -EINVAL;
+	}
+
+	mtk_pci_mac_write32(priv, REG_MSIX_ISTATUS_HOST_GRP0_0, BIT(irq_id));
+
+	return 0;
+}
+
+static int mtk_mhccif_register_evt(struct mtk_md_dev *mdev, u32 chs,
+				   int (*evt_cb)(u32 status, void *data), void *data)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	struct mtk_mhccif_cb *cb;
+	unsigned long flag;
+	int ret = 0;
+
+	if (!chs || !evt_cb)
+		return -EINVAL;
+
+	spin_lock_irqsave(&priv->mhccif_lock, flag);
+	list_for_each_entry(cb, &priv->mhccif_cb_list, entry) {
+		if (cb->chs & chs) {
+			ret = -EFAULT;
+			dev_err(mdev->dev,
+				"Unable to register evt, chs=0x%08X&0x%08X registered_cb=%ps\n",
+				chs, cb->chs, cb->evt_cb);
+			goto err;
+		}
+	}
+	cb = devm_kzalloc(mdev->dev, sizeof(*cb), GFP_ATOMIC);
+	if (!cb) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	cb->evt_cb = evt_cb;
+	cb->data = data;
+	cb->chs = chs;
+	list_add_tail(&cb->entry, &priv->mhccif_cb_list);
+
+err:
+	spin_unlock_irqrestore(&priv->mhccif_lock, flag);
+
+	return ret;
+}
+
+static int mtk_mhccif_unregister_evt(struct mtk_md_dev *mdev, u32 chs)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	struct mtk_mhccif_cb *cb, *next;
+	unsigned long flag;
+	int ret = 0;
+
+	if (!chs)
+		return -EINVAL;
+
+	spin_lock_irqsave(&priv->mhccif_lock, flag);
+	list_for_each_entry_safe(cb, next, &priv->mhccif_cb_list, entry) {
+		if (cb->chs == chs) {
+			list_del(&cb->entry);
+			devm_kfree(mdev->dev, cb);
+			goto out;
+		}
+	}
+	ret = -EFAULT;
+	dev_warn(mdev->dev, "Unable to unregister evt, no chs=0x%08X has been registered.\n", chs);
+out:
+	spin_unlock_irqrestore(&priv->mhccif_lock, flag);
+
+	return ret;
+}
+
+static void mtk_mhccif_mask_evt(struct mtk_md_dev *mdev, u32 chs)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	mtk_pci_write32(mdev, priv->cfg->mhccif_rc_base_addr
+		+ MHCCIF_EP2RC_SW_INT_EAP_MASK_SET, chs);
+}
+
+static void mtk_mhccif_unmask_evt(struct mtk_md_dev *mdev, u32 chs)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	mtk_pci_write32(mdev, priv->cfg->mhccif_rc_base_addr
+		+ MHCCIF_EP2RC_SW_INT_EAP_MASK_CLR, chs);
+}
+
+static void mtk_mhccif_clear_evt(struct mtk_md_dev *mdev, u32 chs)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	mtk_pci_write32(mdev, priv->cfg->mhccif_rc_base_addr
+		+ MHCCIF_EP2RC_SW_INT_ACK, chs);
+}
+
+static int mtk_mhccif_send_evt(struct mtk_md_dev *mdev, u32 ch)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	u32 rc_base;
+
+	rc_base = priv->cfg->mhccif_rc_base_addr;
+	/* Only allow one ch to be triggered at a time */
+	if ((ch & (ch - 1)) || !ch) {
+		dev_err(mdev->dev, "Unsupported ext evt ch=0x%08X\n", ch);
+		return -EINVAL;
+	}
+
+	mtk_pci_write32(mdev, rc_base + MHCCIF_RC2EP_SW_BSY, ch);
+	mtk_pci_write32(mdev, rc_base + MHCCIF_RC2EP_SW_TCHNUM, ffs(ch) - 1);
+
+	return 0;
+}
+
+static u32 mtk_mhccif_get_evt_status(struct mtk_md_dev *mdev)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	return mtk_pci_read32(mdev, priv->cfg->mhccif_rc_base_addr + MHCCIF_EP2RC_SW_INT_STS);
+}
+
+static int mtk_pci_acpi_reset(struct mtk_md_dev *mdev, char *fn_name)
+{
+#ifdef CONFIG_ACPI
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	acpi_status acpi_ret;
+	acpi_handle handle;
+	int ret = 0;
+
+	handle = ACPI_HANDLE(mdev->dev);
+	if (!handle) {
+		dev_err(mdev->dev, "Unsupported, acpi handle isn't found\n");
+		ret = -ENODEV;
+		goto err;
+	}
+	if (!acpi_has_method(handle, fn_name)) {
+		dev_err(mdev->dev, "Unsupported, _RST method isn't found\n");
+		ret = -ENODEV;
+		goto err;
+	}
+	acpi_ret = acpi_evaluate_object(handle, fn_name, NULL, &buffer);
+	if (ACPI_FAILURE(acpi_ret)) {
+		dev_err(mdev->dev, "Failed to execute %s method: %s\n",
+			fn_name,
+			acpi_format_exception(acpi_ret));
+		ret = -EFAULT;
+		goto err;
+	}
+	dev_info(mdev->dev, "FLDR execute successfully\n");
+	acpi_os_free(buffer.pointer);
+err:
+	return ret;
+#else
+	dev_err(mdev->dev, "Unsupported, CONFIG ACPI hasn't been set to 'y'\n");
+	return -ENODEV;
+#endif
+}
+
+static int mtk_pci_fldr(struct mtk_md_dev *mdev)
+{
+	return mtk_pci_acpi_reset(mdev, "_RST");
+}
+
+static int mtk_pci_pldr(struct mtk_md_dev *mdev)
+{
+	return mtk_pci_acpi_reset(mdev, "MRST._RST");
+}
+
+static int mtk_pci_reset(struct mtk_md_dev *mdev, enum mtk_reset_type type)
+{
+	switch (type) {
+	case RESET_RGU:
+		return mtk_mhccif_send_evt(mdev, EXT_EVT_H2D_DEVICE_RESET);
+	case RESET_FLDR:
+		return mtk_pci_fldr(mdev);
+	case RESET_PLDR:
+		return mtk_pci_pldr(mdev);
+	}
+
+	return -EINVAL;
+}
+
+static int mtk_pci_reinit(struct mtk_md_dev *mdev, enum mtk_reinit_type type)
+{
+	struct pci_dev *pdev = to_pci_dev(mdev->dev);
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	int ret, ltr, l1ss;
+
+	/* restore ltr */
+	ltr = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_LTR);
+	if (ltr) {
+		pci_write_config_word(pdev, ltr + PCI_LTR_MAX_SNOOP_LAT,
+				      priv->ltr_max_snoop_lat);
+		pci_write_config_word(pdev, ltr + PCI_LTR_MAX_NOSNOOP_LAT,
+				      priv->ltr_max_nosnoop_lat);
+	}
+	/* restore l1ss */
+	l1ss = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_L1SS);
+	if (l1ss) {
+		pci_write_config_dword(pdev, l1ss + PCI_L1SS_CTL1, priv->l1ss_ctl1);
+		pci_write_config_dword(pdev, l1ss + PCI_L1SS_CTL2, priv->l1ss_ctl2);
+	}
+
+	ret = mtk_pci_atr_init(mdev);
+	if (ret)
+		return ret;
+
+	if (priv->irq_type == PCI_IRQ_MSIX) {
+		if (priv->irq_cnt != MTK_IRQ_CNT_MAX)
+			mtk_pci_set_msix_merged(priv, priv->irq_cnt);
+	}
+
+	mtk_pci_unmask_irq(mdev, priv->rgu_irq_id);
+	mtk_pci_unmask_irq(mdev, priv->mhccif_irq_id);
+
+	/* In L2 resume, device would disable PCIe interrupt,
+	 * and this step would re-enable PCIe interrupt.
+	 * For L3, just do this with no effect.
+	 */
+	if (type == REINIT_TYPE_RESUME)
+		mtk_pci_mac_write32(priv, priv->cfg->istatus_host_ctrl_addr, 0);
+
+	dev_dbg(mdev->dev, "PCIe reinit type=%d\n", type);
+
+	return 0;
+}
+
+static bool mtk_pci_link_check(struct mtk_md_dev *mdev)
+{
+	return !pci_device_is_present(to_pci_dev(mdev->dev));
+}
+
+static int mtk_pci_get_hp_status(struct mtk_md_dev *mdev)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	return priv->rc_hp_on;
+}
+
+static u32 mtk_pci_get_resume_state(struct mtk_md_dev *mdev)
+{
+	return mtk_pci_mac_read32(mdev->hw_priv, REG_PCIE_DEBUG_DUMMY_3);
+}
+
+static const struct mtk_hw_ops mtk_pci_ops = {
+	.read32                = mtk_pci_read32,
+	.write32               = mtk_pci_write32,
+	.get_dev_state         = mtk_pci_get_dev_state,
+	.ack_dev_state         = mtk_pci_ack_dev_state,
+	.get_ds_status         = mtk_pci_get_ds_status,
+	.ds_lock               = mtk_pci_ds_lock,
+	.ds_unlock             = mtk_pci_ds_unlock,
+	.set_l1ss              = mtk_pci_set_l1ss,
+	.get_resume_state      = mtk_pci_get_resume_state,
+	.get_irq_id            = mtk_pci_get_irq_id,
+	.get_virq_id           = mtk_pci_get_virq_id,
+	.register_irq          = mtk_pci_register_irq,
+	.unregister_irq        = mtk_pci_unregister_irq,
+	.mask_irq              = mtk_pci_mask_irq,
+	.unmask_irq            = mtk_pci_unmask_irq,
+	.clear_irq             = mtk_pci_clear_irq,
+	.register_ext_evt      = mtk_mhccif_register_evt,
+	.unregister_ext_evt    = mtk_mhccif_unregister_evt,
+	.mask_ext_evt          = mtk_mhccif_mask_evt,
+	.unmask_ext_evt        = mtk_mhccif_unmask_evt,
+	.clear_ext_evt         = mtk_mhccif_clear_evt,
+	.send_ext_evt          = mtk_mhccif_send_evt,
+	.get_ext_evt_status    = mtk_mhccif_get_evt_status,
+	.reset                 = mtk_pci_reset,
+	.reinit                = mtk_pci_reinit,
+	.get_hp_status         = mtk_pci_get_hp_status,
+};
+
+static void mtk_mhccif_isr_work(struct work_struct *work)
+{
+	struct mtk_pci_priv *priv = container_of(work, struct mtk_pci_priv, mhccif_work);
+	struct mtk_md_dev *mdev = priv->irq_desc->mdev;
+	struct mtk_mhccif_cb *cb;
+	unsigned long flag;
+	u32 stat, mask;
+
+	stat = mtk_mhccif_get_evt_status(mdev);
+	mask = mtk_pci_read32(mdev, priv->cfg->mhccif_rc_base_addr
+		+ MHCCIF_EP2RC_SW_INT_EAP_MASK);
+	dev_dbg(mdev->dev, "External events: mhccif_stat=0x%08X mask=0x%08X\n", stat, mask);
+
+	if (unlikely(stat == U32_MAX && mtk_pci_link_check(mdev))) {
+		/* When link failed, we don't need to unmask/clear. */
+		dev_err(mdev->dev, "Failed to check link in MHCCIF handler.\n");
+		return;
+	}
+
+	stat &= ~mask;
+	spin_lock_irqsave(&priv->mhccif_lock, flag);
+	list_for_each_entry(cb, &priv->mhccif_cb_list, entry) {
+		if (cb->chs & stat)
+			cb->evt_cb(cb->chs & stat, cb->data);
+	}
+	spin_unlock_irqrestore(&priv->mhccif_lock, flag);
+
+	mtk_pci_clear_irq(mdev, priv->mhccif_irq_id);
+	mtk_pci_unmask_irq(mdev, priv->mhccif_irq_id);
+}
+
+static const struct mtk_pci_dev_cfg mtk_dev_cfg_0800 = {
+	.mhccif_rc_base_addr = 0x10012000,
+	.mhccif_trsl_size = 0x2000,
+	.mhccif_rc_reg_trsl_addr = 0x12020000,
+	.istatus_host_ctrl_addr = REG_ISTATUS_HOST_CTRL_NEW,
+	.irq_tbl = {
+		[MTK_IRQ_SRC_DPMAIF]  = 24,
+		[MTK_IRQ_SRC_CLDMA0]  = 25,
+		[MTK_IRQ_SRC_CLDMA1]  = 26,
+		[MTK_IRQ_SRC_CLDMA2]  = 27,
+		[MTK_IRQ_SRC_MHCCIF]  = 28,
+		[MTK_IRQ_SRC_DPMAIF2] = 29,
+		[MTK_IRQ_SRC_SAP_RGU] = 30,
+		[MTK_IRQ_SRC_CLDMA3]  = 31,
+		[MTK_IRQ_SRC_PM_LOCK] = 0,
+		[MTK_IRQ_SRC_DPMAIF3] = 7,
+	},
+};
+
+static const struct pci_device_id mtk_pci_ids[] = {
+	MTK_PCI_DEV_CFG(0x0800, mtk_dev_cfg_0800),
+	{ /* end: all zeroes */ }
+};
+MODULE_DEVICE_TABLE(pci, mtk_pci_ids);
+
+static int mtk_pci_bar_init(struct mtk_md_dev *mdev)
+{
+	struct pci_dev *pdev = to_pci_dev(mdev->dev);
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	int ret;
+
+	ret = pcim_iomap_regions(pdev, MTK_REQUESTED_BARS, mdev->dev_str);
+	if (ret) {
+		dev_err(mdev->dev, "Failed to init MMIO. ret=%d\n", ret);
+		return ret;
+	}
+
+	/* get ioremapped memory */
+	priv->mac_reg_base = pcim_iomap_table(pdev)[MTK_BAR_0_1_IDX];
+	priv->bar23_addr = pcim_iomap_table(pdev)[MTK_BAR_2_3_IDX];
+	dev_info(mdev->dev, "BAR0/1 Addr=0x%p, BAR2/3 Addr=0x%p\n",
+		 priv->mac_reg_base, priv->bar23_addr);
+	/* We use MD view base address "0" to observe registers */
+	priv->ext_reg_base = priv->bar23_addr - ATR_PCIE_REG_TRSL_ADDR;
+
+	return 0;
+}
+
+static void mtk_pci_bar_exit(struct mtk_md_dev *mdev)
+{
+	pcim_iounmap_regions(to_pci_dev(mdev->dev), MTK_REQUESTED_BARS);
+}
+
+static int mtk_mhccif_irq_cb(int irq_id, void *data)
+{
+	struct mtk_md_dev *mdev = data;
+	struct mtk_pci_priv *priv;
+
+	priv = mdev->hw_priv;
+	queue_work(system_highpri_wq, &priv->mhccif_work);
+
+	return 0;
+}
+
+static int mtk_mhccif_init(struct mtk_md_dev *mdev)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	int ret;
+
+	INIT_LIST_HEAD(&priv->mhccif_cb_list);
+	spin_lock_init(&priv->mhccif_lock);
+	INIT_WORK(&priv->mhccif_work, mtk_mhccif_isr_work);
+
+	ret = mtk_pci_get_irq_id(mdev, MTK_IRQ_SRC_MHCCIF);
+	if (ret < 0) {
+		dev_err(mdev->dev, "Failed to get mhccif_irq_id. ret=%d\n", ret);
+		goto err;
+	}
+	priv->mhccif_irq_id = ret;
+
+	ret = mtk_pci_register_irq(mdev, priv->mhccif_irq_id, mtk_mhccif_irq_cb, mdev);
+	if (ret) {
+		dev_err(mdev->dev, "Failed to register mhccif_irq callback\n");
+		goto err;
+	}
+
+	/* To check if the device rebooted.
+	 * The reboot of some PC doesn't cause the device power cycle.
+	 */
+	mtk_pci_read32(mdev, priv->cfg->mhccif_rc_base_addr +
+				   MHCCIF_EP2RC_SW_INT_EAP_MASK);
+
+err:
+	return ret;
+}
+
+static void mtk_mhccif_exit(struct mtk_md_dev *mdev)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	mtk_pci_unregister_irq(mdev, priv->mhccif_irq_id);
+	cancel_work_sync(&priv->mhccif_work);
+}
+
+static void mtk_rgu_work(struct work_struct *work)
+{
+	struct mtk_pci_priv *priv;
+	struct mtk_md_dev *mdev;
+	struct pci_dev *pdev;
+
+	priv = container_of(to_delayed_work(work), struct mtk_pci_priv, rgu_work);
+	mdev = priv->mdev;
+	pdev = to_pci_dev(mdev->dev);
+
+	dev_info(mdev->dev, "RGU work\n");
+
+	mtk_pci_mask_irq(mdev, priv->rgu_irq_id);
+	mtk_pci_clear_irq(mdev, priv->rgu_irq_id);
+
+	if (!pdev->msix_enabled)
+		return;
+
+	mtk_pci_unmask_irq(mdev, priv->rgu_irq_id);
+}
+
+static int mtk_rgu_irq_cb(int irq_id, void *data)
+{
+	struct mtk_md_dev *mdev = data;
+	struct mtk_pci_priv *priv;
+
+	priv = mdev->hw_priv;
+	schedule_delayed_work(&priv->rgu_work, msecs_to_jiffies(1));
+
+	return 0;
+}
+
+static int mtk_rgu_init(struct mtk_md_dev *mdev)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	int ret;
+
+	ret = mtk_pci_get_irq_id(mdev, MTK_IRQ_SRC_SAP_RGU);
+	if (ret < 0) {
+		dev_err(mdev->dev, "Failed to get rgu_irq_id. ret=%d\n", ret);
+		goto err;
+	}
+	priv->rgu_irq_id = ret;
+
+	INIT_DELAYED_WORK(&priv->rgu_work, mtk_rgu_work);
+
+	mtk_pci_mask_irq(mdev, priv->rgu_irq_id);
+	mtk_pci_clear_irq(mdev, priv->rgu_irq_id);
+
+	ret = mtk_pci_register_irq(mdev, priv->rgu_irq_id, mtk_rgu_irq_cb, mdev);
+	if (ret) {
+		dev_err(mdev->dev, "Failed to register rgu_irq callback\n");
+		goto err;
+	}
+
+	mtk_pci_unmask_irq(mdev, priv->rgu_irq_id);
+
+err:
+	return ret;
+}
+
+static void mtk_rgu_exit(struct mtk_md_dev *mdev)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+
+	mtk_pci_unregister_irq(mdev, priv->rgu_irq_id);
+	cancel_delayed_work_sync(&priv->rgu_work);
+}
+
+static irqreturn_t mtk_pci_irq_handler(struct mtk_md_dev *mdev, u32 irq_state)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	int irq_id;
+
+	/* Check whether each set bit has a callback, if has, call it */
+	do {
+		irq_id = fls(irq_state) - 1;
+		irq_state &= ~BIT(irq_id);
+		if (likely(priv->irq_cb_list[irq_id]))
+			priv->irq_cb_list[irq_id](irq_id, priv->irq_cb_data[irq_id]);
+		else
+			dev_err(mdev->dev, "Unhandled irq_id=%d, no callback for it.\n", irq_id);
+	} while (irq_state);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t mtk_pci_irq_msix(int irq, void *data)
+{
+	struct mtk_pci_irq_desc *irq_desc = data;
+	struct mtk_md_dev *mdev = irq_desc->mdev;
+	struct mtk_pci_priv *priv;
+	u32 irq_state, irq_enable;
+
+	priv = mdev->hw_priv;
+	irq_state = mtk_pci_mac_read32(priv, REG_MSIX_ISTATUS_HOST_GRP0_0);
+	irq_enable = mtk_pci_mac_read32(priv, REG_IMASK_HOST_MSIX_GRP0_0);
+	dev_dbg(mdev->dev, "irq_state=0x%08X, irq_enable=0x%08X, msix_bits=0x%08X\n",
+		irq_state, irq_enable, irq_desc->msix_bits);
+	irq_state &= irq_enable;
+
+	if (unlikely(!irq_state) || unlikely(!((irq_state % priv->irq_cnt) & irq_desc->msix_bits)))
+		return IRQ_NONE;
+
+	/* Mask the bit and user needs to unmask by itself */
+	mtk_pci_mac_write32(priv, REG_IMASK_HOST_MSIX_CLR_GRP0_0, irq_state & (~BIT(30)));
+
+	return mtk_pci_irq_handler(mdev, irq_state);
+}
+
+static int mtk_pci_request_irq_msix(struct mtk_md_dev *mdev, int irq_cnt_allocated)
+{
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	struct mtk_pci_irq_desc *irq_desc;
+	struct pci_dev *pdev;
+	int irq_cnt;
+	int ret, i;
+
+	/* calculate the nearest 2's power number */
+	irq_cnt = BIT(fls(irq_cnt_allocated) - 1);
+	pdev = to_pci_dev(mdev->dev);
+	irq_desc = priv->irq_desc;
+	for (i = 0; i < irq_cnt; i++) {
+		irq_desc[i].mdev = mdev;
+		irq_desc[i].msix_bits = BIT(i);
+		snprintf(irq_desc[i].name, MTK_IRQ_NAME_LEN, "msix%d-%s", i, mdev->dev_str);
+		ret = pci_request_irq(pdev, i, mtk_pci_irq_msix, NULL,
+				      &irq_desc[i], irq_desc[i].name);
+		if (ret) {
+			dev_err(mdev->dev, "Failed to request %s: ret=%d\n", irq_desc[i].name, ret);
+			for (i--; i >= 0; i--)
+				pci_free_irq(pdev, i, &irq_desc[i]);
+			return ret;
+		}
+	}
+	priv->irq_cnt = irq_cnt;
+	priv->irq_type = PCI_IRQ_MSIX;
+
+	if (irq_cnt != MTK_IRQ_CNT_MAX)
+		mtk_pci_set_msix_merged(priv, irq_cnt);
+
+	return 0;
+}
+
+static int mtk_pci_request_irq(struct mtk_md_dev *mdev, int max_irq_cnt, int irq_type)
+{
+	struct pci_dev *pdev = to_pci_dev(mdev->dev);
+	int irq_cnt;
+
+	irq_cnt = pci_alloc_irq_vectors(pdev, MTK_IRQ_CNT_MIN, max_irq_cnt, irq_type);
+	mdev->msi_nvecs = irq_cnt;
+
+	if (irq_cnt < MTK_IRQ_CNT_MIN) {
+		dev_err(mdev->dev,
+			"Unable to alloc pci irq vectors. ret=%d maxirqcnt=%d irqtype=0x%x\n",
+			irq_cnt, max_irq_cnt, irq_type);
+		return -EFAULT;
+	}
+
+	return mtk_pci_request_irq_msix(mdev, irq_cnt);
+}
+
+static void mtk_pci_free_irq(struct mtk_md_dev *mdev)
+{
+	struct pci_dev *pdev = to_pci_dev(mdev->dev);
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	int i;
+
+	for (i = 0; i < priv->irq_cnt; i++)
+		pci_free_irq(pdev, i, &priv->irq_desc[i]);
+
+	pci_free_irq_vectors(pdev);
+}
+
+static void mtk_pci_save_state(struct mtk_md_dev *mdev)
+{
+	struct pci_dev *pdev = to_pci_dev(mdev->dev);
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	int ltr, l1ss;
+
+	pci_save_state(pdev);
+	/* save ltr */
+	ltr = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_LTR);
+	if (ltr) {
+		pci_read_config_word(pdev, ltr + PCI_LTR_MAX_SNOOP_LAT,
+				     &priv->ltr_max_snoop_lat);
+		pci_read_config_word(pdev, ltr + PCI_LTR_MAX_NOSNOOP_LAT,
+				     &priv->ltr_max_nosnoop_lat);
+	}
+	/* save l1ss */
+	l1ss = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_L1SS);
+	if (l1ss) {
+		pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL1, &priv->l1ss_ctl1);
+		pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL2, &priv->l1ss_ctl2);
+	}
+}
+
+static int mtk_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct device *dev = &pdev->dev;
+	struct mtk_pci_priv *priv;
+	struct mtk_md_dev *mdev;
+	int ret;
+
+	mdev = devm_kzalloc(dev, sizeof(*mdev), GFP_KERNEL);
+	if (!mdev) {
+		ret = -ENOMEM;
+		goto err_alloc_mdev;
+	}
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		goto err_alloc_priv;
+	}
+
+	pci_set_drvdata(pdev, mdev);
+	priv->cfg = (struct mtk_pci_dev_cfg *)id->driver_data;
+	priv->mdev = mdev;
+	mdev->hw_ver  = pdev->device;
+	mdev->hw_ops  = &mtk_pci_ops;
+	mdev->hw_priv = priv;
+	mdev->dev     = dev;
+	snprintf(mdev->dev_str, MTK_DEV_STR_LEN, "%02x%02x%d",
+		 pdev->bus->number, PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
+
+	dev_info(mdev->dev, "Start probe 0x%x, state_saved[%d]\n",
+		 mdev->hw_ver, pdev->state_saved);
+
+	if (pdev->state_saved)
+		pci_restore_state(pdev);
+
+	/* enable host to device access. */
+	ret = pcim_enable_device(pdev);
+	if (ret) {
+		dev_err(mdev->dev, "Failed to enable pci device.\n");
+		goto err_enable_pdev;
+	}
+
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(mdev->dev, "Failed to set DMA Mask and Coherent. (ret=%d)\n", ret);
+		goto err_set_dma_mask;
+	}
+
+	ret = mtk_pci_bar_init(mdev);
+	if (ret)
+		goto err_bar_init;
+
+	ret = mtk_pci_atr_init(mdev);
+	if (ret)
+		goto err_atr_init;
+
+	ret = mtk_mhccif_init(mdev);
+	if (ret)
+		goto err_mhccif_init;
+
+	ret = mtk_pci_request_irq(mdev, MTK_IRQ_CNT_MAX, PCI_IRQ_MSIX);
+	if (ret)
+		goto err_request_irq;
+
+	ret = mtk_rgu_init(mdev);
+	if (ret)
+		goto err_rgu_init;
+
+	/* enable device to host interrupt. */
+	pci_set_master(pdev);
+
+	mtk_pci_unmask_irq(mdev, priv->mhccif_irq_id);
+
+	mtk_pci_save_state(mdev);
+	priv->saved_state = pci_store_saved_state(pdev);
+	if (!priv->saved_state) {
+		ret = -EFAULT;
+		goto err_save_state;
+	}
+
+	dev_info(mdev->dev, "Probe done hw_ver=0x%x\n", mdev->hw_ver);
+	return 0;
+
+err_save_state:
+	pci_disable_pcie_error_reporting(pdev);
+	pci_clear_master(pdev);
+	mtk_rgu_exit(mdev);
+err_rgu_init:
+	mtk_pci_free_irq(mdev);
+err_request_irq:
+	mtk_mhccif_exit(mdev);
+err_mhccif_init:
+err_atr_init:
+	mtk_pci_bar_exit(mdev);
+err_bar_init:
+err_set_dma_mask:
+	pci_disable_device(pdev);
+err_enable_pdev:
+	devm_kfree(dev, priv);
+err_alloc_priv:
+	devm_kfree(dev, mdev);
+err_alloc_mdev:
+	dev_err(dev, "Failed to probe device, ret=%d\n", ret);
+
+	return ret;
+}
+
+static void mtk_pci_remove(struct pci_dev *pdev)
+{
+	struct mtk_md_dev *mdev = pci_get_drvdata(pdev);
+	struct mtk_pci_priv *priv = mdev->hw_priv;
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	mtk_pci_mask_irq(mdev, priv->rgu_irq_id);
+	mtk_pci_mask_irq(mdev, priv->mhccif_irq_id);
+	pci_disable_pcie_error_reporting(pdev);
+
+	ret = mtk_pci_fldr(mdev);
+	if (ret)
+		mtk_mhccif_send_evt(mdev, EXT_EVT_H2D_DEVICE_RESET);
+
+	pci_clear_master(pdev);
+	mtk_rgu_exit(mdev);
+	mtk_mhccif_exit(mdev);
+	mtk_pci_free_irq(mdev);
+	mtk_pci_bar_exit(mdev);
+	pci_disable_device(pdev);
+	pci_load_and_free_saved_state(pdev, &priv->saved_state);
+	devm_kfree(dev, priv);
+	devm_kfree(dev, mdev);
+	dev_info(dev, "Remove done, state_saved[%d]\n", pdev->state_saved);
+}
+
+static pci_ers_result_t mtk_pci_error_detected(struct pci_dev *pdev,
+					       pci_channel_state_t state)
+{
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+static pci_ers_result_t mtk_pci_slot_reset(struct pci_dev *pdev)
+{
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static void mtk_pci_io_resume(struct pci_dev *pdev)
+{
+}
+
+static const struct pci_error_handlers mtk_pci_err_handler = {
+	.error_detected = mtk_pci_error_detected,
+	.slot_reset = mtk_pci_slot_reset,
+	.resume = mtk_pci_io_resume,
+};
+
+static struct pci_driver mtk_pci_drv = {
+	.name = "mtk_pci_drv",
+	.id_table = mtk_pci_ids,
+
+	.probe =    mtk_pci_probe,
+	.remove =   mtk_pci_remove,
+
+	.err_handler = &mtk_pci_err_handler
+};
+
+static int __init mtk_drv_init(void)
+{
+	return pci_register_driver(&mtk_pci_drv);
+}
+module_init(mtk_drv_init);
+
+static void __exit mtk_drv_exit(void)
+{
+	pci_unregister_driver(&mtk_pci_drv);
+}
+module_exit(mtk_drv_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.h b/drivers/net/wwan/mediatek/pcie/mtk_pci.h
new file mode 100644
index 000000000000..c7b29e94aafc
--- /dev/null
+++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.h
@@ -0,0 +1,150 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_PCI_H__
+#define __MTK_PCI_H__
+
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+
+#include "mtk_dev.h"
+
+enum mtk_atr_type {
+	ATR_PCI2AXI = 0,
+	ATR_AXI2PCI
+};
+
+enum mtk_atr_src_port {
+	ATR_SRC_PCI_WIN0 = 0,
+	ATR_SRC_AXIS_0 = 2,
+	ATR_SRC_AXIS_2 = 3,
+	ATR_SRC_AXIS_3 = 4,
+};
+
+enum mtk_atr_dst_port {
+	ATR_DST_PCI_TRX = 0,
+	ATR_DST_AXIM_0 = 4,
+};
+
+#define ATR_PORT_OFFSET                 0x100
+#define ATR_TABLE_OFFSET                0x20
+#define ATR_TABLE_NUM_PER_ATR           8
+#define ATR_WIN0_SRC_ADDR_LSB_DEFT      0x0000007f
+#define ATR_PCIE_REG_TRSL_ADDR          0x10000000
+#define ATR_PCIE_REG_SIZE               0x00400000
+#define ATR_PCIE_REG_PORT               ATR_SRC_PCI_WIN0
+#define ATR_PCIE_REG_TABLE_NUM          1
+#define ART_PCIE_REG_MHCCIF_TABLE_NUM	0
+#define ATR_PCIE_REG_TRSL_PORT          ATR_DST_AXIM_0
+#define ATR_PCIE_DEV_DMA_PORT_START     ATR_SRC_AXIS_0
+#define ATR_PCIE_DEV_DMA_PORT_END       ATR_SRC_AXIS_2
+#define ATR_PCIE_DEV_DMA_SRC_ADDR       0x00000000
+#define ATR_PCIE_DEV_DMA_TRANSPARENT    1
+#define ATR_PCIE_DEV_DMA_SIZE           0
+#define ATR_PCIE_DEV_DMA_TABLE_NUM      0
+#define ATR_PCIE_DEV_DMA_TRSL_ADDR      0x00000000
+
+#define MTK_BAR_0_1_IDX        0
+#define MTK_BAR_2_3_IDX        2
+/* Only use BAR0/1 and 2/3, so we should input 0b0101 for the two bar,
+ * Input 0xf would cause error.
+ */
+#define MTK_REQUESTED_BARS     ((1 << MTK_BAR_0_1_IDX) | (1 << MTK_BAR_2_3_IDX))
+
+#define MTK_IRQ_CNT_MIN        1
+#define MTK_IRQ_CNT_MAX        32
+#define MTK_IRQ_NAME_LEN	20
+
+#define MTK_INVAL_IRQ_SRC      -1
+
+#define MTK_FORCE_MAC_ACTIVE_BIT	BIT(6)
+#define MTK_DS_LOCK_REG_BIT		BIT(7)
+
+/* mhccif registers */
+#define MHCCIF_RC2EP_SW_BSY                0x4
+#define MHCCIF_RC2EP_SW_INT_START          0x8
+#define MHCCIF_RC2EP_SW_TCHNUM             0xC
+#define MHCCIF_EP2RC_SW_INT_STS            0x10
+#define MHCCIF_EP2RC_SW_INT_ACK            0x14
+#define MHCCIF_EP2RC_SW_INT_EAP_MASK       0x20
+#define MHCCIF_EP2RC_SW_INT_EAP_MASK_SET   0x30
+#define MHCCIF_EP2RC_SW_INT_EAP_MASK_CLR   0x40
+#define MHCCIF_RC2EP_PCIE_PM_COUNTER       0x12C
+
+#define MTK_PCI_CLASS         0x0D4000
+#define MTK_PCI_VENDOR_ID     0x14C3
+
+#define MTK_DISABLE_DS_BIT(grp)	BIT(grp)
+#define MTK_ENABLE_DS_BIT(grp)	BIT((grp) << 8)
+
+#define MTK_PCI_DEV_CFG(id, cfg) \
+{ \
+	PCI_DEVICE(MTK_PCI_VENDOR_ID, id), \
+	MTK_PCI_CLASS, PCI_ANY_ID, \
+	.driver_data = (kernel_ulong_t)&(cfg), \
+}
+
+struct mtk_pci_dev_cfg {
+	u32 flag;
+	u32 mhccif_rc_base_addr;
+	u32 mhccif_rc_reg_trsl_addr;
+	u32 mhccif_trsl_size;
+	u32 istatus_host_ctrl_addr;
+	int irq_tbl[MTK_IRQ_SRC_MAX];
+};
+
+struct mtk_pci_irq_desc {
+	struct mtk_md_dev *mdev;
+	u32 msix_bits;
+	char name[MTK_IRQ_NAME_LEN];
+};
+
+struct mtk_pci_priv {
+	const struct mtk_pci_dev_cfg *cfg;
+	void *mdev;
+	void __iomem *bar23_addr;
+	void __iomem *mac_reg_base;
+	void __iomem *ext_reg_base;
+	int rc_hp_on; /* Bridge hotplug status */
+	int rgu_irq_id;
+	int irq_cnt;
+	int irq_type;
+	void *irq_cb_data[MTK_IRQ_CNT_MAX];
+
+	int (*irq_cb_list[MTK_IRQ_CNT_MAX])(int irq_id, void *data);
+	struct mtk_pci_irq_desc irq_desc[MTK_IRQ_CNT_MAX];
+	struct list_head mhccif_cb_list;
+	/* mhccif_lock: lock to protect mhccif_cb_list */
+	spinlock_t mhccif_lock;
+	struct work_struct mhccif_work;
+	int mhccif_irq_id;
+	struct delayed_work rgu_work;
+	struct pci_saved_state *saved_state;
+	u16 ltr_max_snoop_lat;
+	u16 ltr_max_nosnoop_lat;
+	u32 l1ss_ctl1;
+	u32 l1ss_ctl2;
+};
+
+struct mtk_mhccif_cb {
+	struct list_head entry;
+	int (*evt_cb)(u32 status, void *data);
+	void *data;
+	u32 chs;
+};
+
+struct mtk_atr_cfg {
+	u64 src_addr;
+	u64 trsl_addr;
+	u64 size;
+	u32 type;      /* Port type */
+	u32 port;      /* Port number */
+	u32 table;     /* Table number (8 tables for each port) */
+	u32 trsl_id;
+	u32 trsl_param;
+	u32 transparent;
+};
+
+#endif /* __MTK_PCI_H__ */
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_reg.h b/drivers/net/wwan/mediatek/pcie/mtk_reg.h
new file mode 100644
index 000000000000..23fa7fd9518e
--- /dev/null
+++ b/drivers/net/wwan/mediatek/pcie/mtk_reg.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_REG_H__
+#define __MTK_REG_H__
+
+enum mtk_ext_evt_h2d {
+	EXT_EVT_H2D_EXCEPT_ACK             = 1 << 1,
+	EXT_EVT_H2D_EXCEPT_CLEARQ_ACK      = 1 << 2,
+	EXT_EVT_H2D_PCIE_DS_LOCK           = 1 << 3,
+	EXT_EVT_H2D_RESERVED_FOR_DPMAIF    = 1 << 8,
+	EXT_EVT_H2D_PCIE_PM_SUSPEND_REQ    = 1 << 9,
+	EXT_EVT_H2D_PCIE_PM_RESUME_REQ     = 1 << 10,
+	EXT_EVT_H2D_PCIE_PM_SUSPEND_REQ_AP = 1 << 11,
+	EXT_EVT_H2D_PCIE_PM_RESUME_REQ_AP  = 1 << 12,
+	EXT_EVT_H2D_DEVICE_RESET           = 1 << 13,
+};
+
+#define REG_PCIE_SW_TRIG_INT			0x00BC
+#define REG_PCIE_LTSSM_STATUS			0x0150
+#define REG_IMASK_LOCAL				0x0180
+#define REG_ISTATUS_LOCAL			0x0184
+#define REG_INT_ENABLE_HOST			0x0188
+#define REG_ISTATUS_HOST			0x018C
+#define REG_PCIE_LOW_POWER_CTRL			0x0194
+#define REG_ISTATUS_HOST_CTRL			0x01AC
+#define REG_ISTATUS_PENDING_ADT			0x01D4
+#define REG_INT_ENABLE_HOST_SET			0x01F0
+#define REG_INT_ENABLE_HOST_CLR			0x01F4
+#define REG_PCIE_DMA_DUMMY_0			0x01F8
+#define REG_ISTATUS_HOST_CTRL_NEW		0x031C
+#define REG_PCIE_MISC_CTRL			0x0348
+#define REG_PCIE_DUMMY_0			0x03C0
+#define REG_SW_TRIG_INTR_SET			0x03C8
+#define REG_SW_TRIG_INTR_CLR			0x03CC
+#define REG_PCIE_CFG_MSIX			0x03EC
+#define REG_ATR_PCIE_WIN0_T0_SRC_ADDR_LSB	0x0600
+#define REG_ATR_PCIE_WIN0_T0_SRC_ADDR_MSB	0x0604
+#define REG_ATR_PCIE_WIN0_T0_TRSL_ADDR_LSB	0x0608
+#define REG_ATR_PCIE_WIN0_T0_TRSL_ADDR_MSB	0x060C
+#define REG_ATR_PCIE_WIN0_T0_TRSL_PARAM		0x0610
+#define REG_PCIE_DEBUG_DUMMY_0			0x0D00
+#define REG_PCIE_DEBUG_DUMMY_1			0x0D04
+#define REG_PCIE_DEBUG_DUMMY_2			0x0D08
+#define REG_PCIE_DEBUG_DUMMY_3			0x0D0C
+#define REG_PCIE_DEBUG_DUMMY_4			0x0D10
+#define REG_PCIE_DEBUG_DUMMY_5			0x0D14
+#define REG_PCIE_DEBUG_DUMMY_6			0x0D18
+#define REG_PCIE_DEBUG_DUMMY_7			0x0D1C
+#define REG_PCIE_RESOURCE_STATUS		0x0D28
+#define REG_RC2EP_SW_TRIG_LOCAL_INTR_STAT	0x0D94
+#define REG_RC2EP_SW_TRIG_LOCAL_INTR_SET	0x0D98
+#define REG_RC2EP_SW_TRIG_LOCAL_INTR_CLR	0x0D9C
+#define REG_DIS_ASPM_LOWPWR_SET_0		0x0E50
+#define REG_DIS_ASPM_LOWPWR_CLR_0		0x0E54
+#define REG_DIS_ASPM_LOWPWR_SET_1		0x0E58
+#define REG_DIS_ASPM_LOWPWR_CLR_1		0x0E5C
+#define REG_DIS_ASPM_LOWPWR_STS_0		0x0E60
+#define REG_DIS_ASPM_LOWPWR_STS_1		0x0E64
+#define REG_PCIE_PEXTP_MAC_SLEEP_CTRL		0x0E70
+#define REG_MSIX_SW_TRIG_SET_GRP0_0		0x0E80
+#define REG_MSIX_ISTATUS_HOST_GRP0_0		0x0F00
+#define REG_IMASK_HOST_MSIX_SET_GRP0_0		0x3000
+#define REG_IMASK_HOST_MSIX_CLR_GRP0_0		0x3080
+#define REG_IMASK_HOST_MSIX_GRP0_0		0x3100
+#define REG_DEV_INFRA_BASE			0x10001000
+#endif /* __MTK_REG_H__ */
-- 
2.32.0

