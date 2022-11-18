Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DD16302C3
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbiKRXPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiKRXNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:46 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754AFC68AA
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:59 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b11so5733678pjp.2
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RdcpDY5aqslOYqFJ06sUwegPY2/JzZgBm4aj1WYTEJo=;
        b=RpjogYL+Ii6F3F35dmD6fUDRXo1/kPZKk/VoVLntfay3nNrXkN1DGbhYgKvHMZxLG5
         QcAz1DVoAL/FLd4skyvobcjt833Lb+CyBTu9a+gwL0/xeg8CUFpB7p8Z5t2Wr3+SHbrZ
         1s+ei4WluoEeR93j9Dn/DTwgJYJku3b5miUVx6Zi9/g/6o9jfPQP/2GUsMyWne8Sychf
         BBUGfanehrXGtSP1Qfkswj/qwxMBQoDSMkhgv9CnpsRrhJARWf/A11geJmIyCwPaeIuf
         pin+h5zChzWuBAvHXdbCybMjx26tWcazxxhjowv0mhO6YDrzs2MrW9km6RhkwHOuSKji
         mNPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RdcpDY5aqslOYqFJ06sUwegPY2/JzZgBm4aj1WYTEJo=;
        b=iSV42VgKyQv+eoQUKdfImOQRYMLa22TSIjG6uHPxYo93+SlnSsh4KR9b6Ohu9lWeTn
         q33mZbIjem6UyhFWNQRcEYArPrbBGRgh3Z3mz7qGtrDL1RK479HeBizDq7RZhxAVvYjO
         RxJ3Akg68xtUNHavGn3otHMZcBmW2XwfFKj76yZ5DXieZz+vIySNWADWKXMmDX9UJZWv
         EcJZ0rkOi0nmR+TuCXPUaB1mb0TbIPFDpTLLofRsI8KOxsCTUxeRTOz6pGSVBNz7qudZ
         o2cOFJKQ7PnVB+K+HQWqhAETodWt5TuaUG3hT+6NqniFfzXm11I4gR/CdIRUzJfzPvhN
         iklg==
X-Gm-Message-State: ANoB5plLDaLmXbEtKTk09M63V6GcXYl8NY/cxa1F7K39hS+8ZDHUdfFT
        T+QoSoV8/jLLlb3h2q7paXIBWmvCymdZcA==
X-Google-Smtp-Source: AA0mqf4FLBCJdqiEZkShRHzaiMO4llnGBzuxxpWzX4vaR7Hps/C1cGLPZ6FSIvJuAWqtJYkVnqhIIg==
X-Received: by 2002:a17:903:3292:b0:188:ec14:e3a3 with SMTP id jh18-20020a170903329200b00188ec14e3a3mr1418588plb.154.1668812255263;
        Fri, 18 Nov 2022 14:57:35 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:34 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 17/19] pds_vdpa: add vdpa config client commands
Date:   Fri, 18 Nov 2022 14:56:54 -0800
Message-Id: <20221118225656.48309-18-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118225656.48309-1-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are the adminq commands that will be needed for
setting up and using the vDPA device.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/vdpa/pds/Makefile   |   1 +
 drivers/vdpa/pds/cmds.c     | 266 ++++++++++++++++++++++++++++++++++++
 drivers/vdpa/pds/cmds.h     |  17 +++
 drivers/vdpa/pds/vdpa_dev.h |  60 ++++++++
 4 files changed, 344 insertions(+)
 create mode 100644 drivers/vdpa/pds/cmds.c
 create mode 100644 drivers/vdpa/pds/cmds.h
 create mode 100644 drivers/vdpa/pds/vdpa_dev.h

diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
index 82ee258f6122..fafd356ddf86 100644
--- a/drivers/vdpa/pds/Makefile
+++ b/drivers/vdpa/pds/Makefile
@@ -4,6 +4,7 @@
 obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
 
 pds_vdpa-y := aux_drv.o \
+	      cmds.o \
 	      pci_drv.o	\
 	      debugfs.o \
 	      virtio_pci.o
diff --git a/drivers/vdpa/pds/cmds.c b/drivers/vdpa/pds/cmds.c
new file mode 100644
index 000000000000..2428ecdcf671
--- /dev/null
+++ b/drivers/vdpa/pds/cmds.c
@@ -0,0 +1,266 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/types.h>
+#include <linux/vdpa.h>
+
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
+#include <linux/pds/pds_vdpa.h>
+
+#include "vdpa_dev.h"
+#include "aux_drv.h"
+#include "pci_drv.h"
+#include "cmds.h"
+
+static void
+pds_vdpa_check_needs_reset(struct pds_vdpa_device *pdsv, int err)
+{
+	if (err == -ENXIO)
+		pdsv->hw.status |= VIRTIO_CONFIG_S_NEEDS_RESET;
+}
+
+int
+pds_vdpa_init_hw(struct pds_vdpa_device *pdsv)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_init_cmd init_cmd = {
+		.opcode = PDS_VDPA_CMD_INIT,
+		.vdpa_index = pdsv->hw.vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vdpa_vf->vf_id),
+		.len = cpu_to_le32(sizeof(pdsv->vn_config)),
+		.config_pa = cpu_to_le64(pdsv->vn_config_pa),
+	};
+	struct pds_vdpa_comp init_comp = {0};
+	int err;
+
+	/* Initialize the vdpa/virtio device */
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&init_cmd,
+				     sizeof(init_cmd),
+				     (union pds_core_adminq_comp *)&init_comp,
+				     0);
+	if (err) {
+		dev_err(dev, "Failed to init hw, status %d: %pe\n",
+			init_comp.status, ERR_PTR(err));
+		pds_vdpa_check_needs_reset(pdsv, err);
+	}
+
+	return err;
+}
+
+int
+pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_RESET,
+		.vdpa_index = pdsv->hw.vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vdpa_vf->vf_id),
+	};
+	struct pds_vdpa_comp comp = {0};
+	int err;
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err) {
+		dev_err(dev, "Failed to reset hw, status %d: %pe\n",
+			comp.status, ERR_PTR(err));
+		pds_vdpa_check_needs_reset(pdsv, err);
+	}
+
+	return err;
+}
+
+int
+pds_vdpa_cmd_set_status(struct pds_vdpa_device *pdsv, u8 status)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_status_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_STATUS_UPDATE,
+		.vdpa_index = pdsv->hw.vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vdpa_vf->vf_id),
+		.status = status
+	};
+	struct pds_vdpa_comp comp = {0};
+	int err;
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err) {
+		dev_err(dev, "Failed to set status update %#x, status %d: %pe\n",
+			status, comp.status, ERR_PTR(err));
+		pds_vdpa_check_needs_reset(pdsv, err);
+	}
+
+	return err;
+}
+
+int
+pds_vdpa_cmd_set_mac(struct pds_vdpa_device *pdsv, u8 *mac)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_setattr_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_SET_ATTR,
+		.vdpa_index = pdsv->hw.vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vdpa_vf->vf_id),
+		.attr = PDS_VDPA_ATTR_MAC,
+	};
+	struct pds_vdpa_comp comp = {0};
+	int err;
+
+	ether_addr_copy(cmd.mac, mac);
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err) {
+		dev_err(dev, "Failed to set mac address %pM, status %d: %pe\n",
+			mac, comp.status, ERR_PTR(err));
+		pds_vdpa_check_needs_reset(pdsv, err);
+	}
+
+	return err;
+}
+
+int
+pds_vdpa_cmd_set_max_vq_pairs(struct pds_vdpa_device *pdsv, u16 max_vqp)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_setattr_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_SET_ATTR,
+		.vdpa_index = pdsv->hw.vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vdpa_vf->vf_id),
+		.attr = PDS_VDPA_ATTR_MAX_VQ_PAIRS,
+		.max_vq_pairs = cpu_to_le16(max_vqp),
+	};
+	struct pds_vdpa_comp comp = {0};
+	int err;
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err) {
+		dev_err(dev, "Failed to set max vq pairs %u, status %d: %pe\n",
+			max_vqp, comp.status, ERR_PTR(err));
+		pds_vdpa_check_needs_reset(pdsv, err);
+	}
+
+	return err;
+}
+
+int
+pds_vdpa_cmd_init_vq(struct pds_vdpa_device *pdsv, u16 qid,
+		     struct pds_vdpa_vq_info *vq_info)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_vq_init_comp comp = {0};
+	struct pds_vdpa_vq_init_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_VQ_INIT,
+		.vdpa_index = pdsv->hw.vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vdpa_vf->vf_id),
+		.qid = cpu_to_le16(qid),
+		.len = cpu_to_le16(ilog2(vq_info->q_len)),
+		.desc_addr = cpu_to_le64(vq_info->desc_addr),
+		.avail_addr = cpu_to_le64(vq_info->avail_addr),
+		.used_addr = cpu_to_le64(vq_info->used_addr),
+		.intr_index = cpu_to_le16(vq_info->intr_index),
+	};
+	int err;
+
+	dev_dbg(dev, "%s: qid %d len %d desc_addr %#llx avail_addr %#llx used_addr %#llx intr_index %d\n",
+		 __func__, qid, ilog2(vq_info->q_len),
+		 vq_info->desc_addr, vq_info->avail_addr,
+		 vq_info->used_addr, vq_info->intr_index);
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err) {
+		dev_err(dev, "Failed to init vq %d, status %d: %pe\n",
+			qid, comp.status, ERR_PTR(err));
+		pds_vdpa_check_needs_reset(pdsv, err);
+	} else {
+		vq_info->hw_qtype = comp.hw_qtype;
+		vq_info->hw_qindex = le16_to_cpu(comp.hw_qindex);
+	}
+
+	return err;
+}
+
+int
+pds_vdpa_cmd_reset_vq(struct pds_vdpa_device *pdsv, u16 qid)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_vq_reset_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_VQ_RESET,
+		.vdpa_index = pdsv->hw.vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vdpa_vf->vf_id),
+		.qid = cpu_to_le16(qid),
+	};
+	struct pds_vdpa_comp comp = {0};
+	int err;
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err) {
+		dev_err(dev, "Failed to reset vq %d, status %d: %pe\n",
+			qid, comp.status, ERR_PTR(err));
+		pds_vdpa_check_needs_reset(pdsv, err);
+	}
+
+	return err;
+}
+
+int
+pds_vdpa_cmd_set_features(struct pds_vdpa_device *pdsv, u64 features)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_set_features_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_SET_FEATURES,
+		.vdpa_index = pdsv->hw.vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vdpa_vf->vf_id),
+		.features = cpu_to_le64(features),
+	};
+	struct pds_vdpa_comp comp = {0};
+	int err;
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err) {
+		dev_err(dev, "Failed to set features %#llx, status %d: %pe\n",
+			features, comp.status, ERR_PTR(err));
+		pds_vdpa_check_needs_reset(pdsv, err);
+	}
+
+	return err;
+}
diff --git a/drivers/vdpa/pds/cmds.h b/drivers/vdpa/pds/cmds.h
new file mode 100644
index 000000000000..88ecc9b33646
--- /dev/null
+++ b/drivers/vdpa/pds/cmds.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#ifndef _VDPA_CMDS_H_
+#define _VDPA_CMDS_H_
+
+int pds_vdpa_init_hw(struct pds_vdpa_device *pdsv);
+
+int pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv);
+int pds_vdpa_cmd_set_status(struct pds_vdpa_device *pdsv, u8 status);
+int pds_vdpa_cmd_set_mac(struct pds_vdpa_device *pdsv, u8 *mac);
+int pds_vdpa_cmd_set_max_vq_pairs(struct pds_vdpa_device *pdsv, u16 max_vqp);
+int pds_vdpa_cmd_init_vq(struct pds_vdpa_device *pdsv, u16 qid,
+			 struct pds_vdpa_vq_info *vq_info);
+int pds_vdpa_cmd_reset_vq(struct pds_vdpa_device *pdsv, u16 qid);
+int pds_vdpa_cmd_set_features(struct pds_vdpa_device *pdsv, u64 features);
+#endif /* _VDPA_CMDS_H_ */
diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
new file mode 100644
index 000000000000..ac881687dc3e
--- /dev/null
+++ b/drivers/vdpa/pds/vdpa_dev.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#ifndef _VDPA_DEV_H_
+#define _VDPA_DEV_H_
+
+#include <linux/pci.h>
+#include <linux/vdpa.h>
+
+
+struct pds_vdpa_aux;
+
+struct pds_vdpa_vq_info {
+	bool ready;
+	u64 desc_addr;
+	u64 avail_addr;
+	u64 used_addr;
+	u32 q_len;
+	u16 qid;
+
+	void __iomem *notify;
+	dma_addr_t notify_pa;
+
+	u64 doorbell;
+	u16 avail_idx;
+	u16 used_idx;
+	int intr_index;
+
+	u8 hw_qtype;
+	u16 hw_qindex;
+
+	struct vdpa_callback event_cb;
+	struct pds_vdpa_device *pdsv;
+};
+
+#define PDS_VDPA_MAX_QUEUES	65
+#define PDS_VDPA_MAX_QLEN	32768
+struct pds_vdpa_hw {
+	struct pds_vdpa_vq_info vqs[PDS_VDPA_MAX_QUEUES];
+	u64 req_features;		/* features requested by vdpa */
+	u64 actual_features;		/* features negotiated and in use */
+	u8 vdpa_index;			/* rsvd for future subdevice use */
+	u8 num_vqs;			/* num vqs in use */
+	u16 status;			/* vdpa status */
+	struct vdpa_callback config_cb;
+};
+
+struct pds_vdpa_device {
+	struct vdpa_device vdpa_dev;
+	struct pds_vdpa_aux *vdpa_aux;
+	struct pds_vdpa_hw hw;
+
+	struct virtio_net_config vn_config;
+	dma_addr_t vn_config_pa;
+	struct dentry *dentry;
+};
+
+int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
+
+#endif /* _VDPA_DEV_H_ */
-- 
2.17.1

