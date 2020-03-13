Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A13B1843F7
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgCMJnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:43:16 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40554 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMJnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 05:43:16 -0400
Received: by mail-pf1-f194.google.com with SMTP id l184so4889542pfl.7
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 02:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gMImhvhFWh5bcuOFfUR6/Nivm6fUTFmueSa+VWmDqfk=;
        b=lQhHrUziGxwZfkts5OWwhL2UwxSfEfnbhFL3HuWb+FekKdYy2zZn4ckXikgzAZLNds
         eLYhwYl1Dy+hLLhL/cmu9kIDw7UKLTR0pQ29miQaO1EJu/WiAIo3LrRiOy859wZFpfoD
         47XxVCWamPc8UNeK+RjMEh6Z/9RNzz2nMGLOfqYYgeIHQueh7oPbgnRqM1qkmvRjKKFH
         aQeyr7vazpmRefV4XZEhEMhbg7VroYwA1GTD2g7nTYl5TDmjL3iOiaziYqswNiUBSIcX
         3jDNu3FhiCtnrX9M7pxX5z3kTktMJ3AoIXOsPKd9dBa1aFSN87UOStbJnQhICY2Uo0Bz
         Ts7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gMImhvhFWh5bcuOFfUR6/Nivm6fUTFmueSa+VWmDqfk=;
        b=KVL0VpCQiZ1WUg4hZD6eINmEpbF9mcaibt5uhAGGpXi8aBS83Cu+xSbUHpFY1ARDRa
         322BTIi/d9+K4QdC3v4jGg58rW0cMxpHr0xN6PP4842dBGxmX+AbEgx+8aTdqA0wmT9J
         VpjaeEWSLV1f85uOWRBbvD4mzVOLtv28MeLOGaNjXMDXU22iirl3JuZN8u/70oGehx3E
         MfGGXql8e56lGdFNJMYYph13oG/Df/noHn+AvFm/0u9LziWUrn43Bon2BjQZ1AA9Z+WN
         wEdJTu5u/Dbv+wOxI4X1i381OfKKJRmuf0ywtFNFii1fsptBxiOS1b9mf63zjn//8pwZ
         m3hA==
X-Gm-Message-State: ANhLgQ3kC4ALpo58+Ch3JOChvAQb4r8XEw4Z8w9sI50/EJQUNYOd4hhj
        uCNc4tQIPfnDzV+FgHuKujfMFNThhVA=
X-Google-Smtp-Source: ADFU+vtwpk0WGtReoIma3HerRh8zo8fWIUFV+SG6dJ8zDqt0Q5iKjET9A3V17cYdHHtUH+fqPRbMGA==
X-Received: by 2002:aa7:990e:: with SMTP id z14mr11091423pff.274.1584092593188;
        Fri, 13 Mar 2020 02:43:13 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v67sm13896386pfc.120.2020.03.13.02.43.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 13 Mar 2020 02:43:12 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 net-next 3/7] octeontx2-vf: Virtual function driver support
Date:   Fri, 13 Mar 2020 15:12:42 +0530
Message-Id: <1584092566-4793-4-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tomasz Duszynski <tduszynski@marvell.com>

On OcteonTx2 silicon there two two types VFs, VFs that share the
physical link with their parent SR-IOV PF and the VFs which work
in pairs using internal HW loopback channels (LBK). Except for the
underlying Rx/Tx channel mapping from netdev functionality perspective
they are almost identical. This patch adds netdev driver support
for these VFs.

Unlike it's parent PF a VF cannot directly communicate with admin
function (AF) and it has to go through PF for the same. The mailbox
communication with AF works like 'VF <=> PF <=> AF'.

Also functionality wise VF and PF are identical, hence to avoid code
duplication PF driver's APIs are resued here for HW initialization,
packet handling etc etc ie almost everything. For VF driver to compile
as module exported few of the existing PF driver APIs.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |   6 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  14 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   9 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  11 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  13 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   | 659 +++++++++++++++++++++
 8 files changed, 714 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
index ced514c..d9dfb61 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -33,3 +33,9 @@ config OCTEONTX2_PF
 	depends on PCI
 	help
 	  This driver supports Marvell's OcteonTX2 NIC physical function.
+
+config OCTEONTX2_VF
+	tristate "Marvell OcteonTX2 NIC Virtual Function driver"
+	depends on OCTEONTX2_PF
+	help
+	  This driver supports Marvell's OcteonTX2 NIC virtual function.
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 41bf00c..778df33 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -4,7 +4,9 @@
 #
 
 obj-$(CONFIG_OCTEONTX2_PF) += octeontx2_nicpf.o
+obj-$(CONFIG_OCTEONTX2_VF) += octeontx2_nicvf.o
 
 octeontx2_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o
+octeontx2_nicvf-y := otx2_vf.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 157735443..70d97c7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -128,6 +128,7 @@ void otx2_get_stats64(struct net_device *netdev,
 	stats->tx_packets = dev_stats->tx_frames;
 	stats->tx_dropped = dev_stats->tx_drops;
 }
+EXPORT_SYMBOL(otx2_get_stats64);
 
 /* Sync MAC address with RVU AF */
 static int otx2_hw_set_mac_addr(struct otx2_nic *pfvf, u8 *mac)
@@ -197,6 +198,7 @@ int otx2_set_mac_address(struct net_device *netdev, void *p)
 
 	return 0;
 }
+EXPORT_SYMBOL(otx2_set_mac_address);
 
 int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 {
@@ -225,6 +227,9 @@ int otx2_config_pause_frm(struct otx2_nic *pfvf)
 	struct cgx_pause_frm_cfg *req;
 	int err;
 
+	if (is_otx2_lbkvf(pfvf->pdev))
+		return 0;
+
 	otx2_mbox_lock(&pfvf->mbox);
 	req = otx2_mbox_alloc_msg_cgx_cfg_pause_frm(&pfvf->mbox);
 	if (!req) {
@@ -416,6 +421,7 @@ void otx2_tx_timeout(struct net_device *netdev, unsigned int txq)
 
 	schedule_work(&pfvf->reset_task);
 }
+EXPORT_SYMBOL(otx2_tx_timeout);
 
 void otx2_get_mac_from_af(struct net_device *netdev)
 {
@@ -430,6 +436,7 @@ void otx2_get_mac_from_af(struct net_device *netdev)
 	if (!is_valid_ether_addr(netdev->dev_addr))
 		eth_hw_addr_random(netdev);
 }
+EXPORT_SYMBOL(otx2_get_mac_from_af);
 
 static int otx2_get_link(struct otx2_nic *pfvf)
 {
@@ -1263,6 +1270,7 @@ int otx2_detach_resources(struct mbox *mbox)
 	otx2_mbox_unlock(mbox);
 	return 0;
 }
+EXPORT_SYMBOL(otx2_detach_resources);
 
 int otx2_attach_npa_nix(struct otx2_nic *pfvf)
 {
@@ -1319,6 +1327,7 @@ int otx2_attach_npa_nix(struct otx2_nic *pfvf)
 
 	return 0;
 }
+EXPORT_SYMBOL(otx2_attach_npa_nix);
 
 void otx2_ctx_disable(struct mbox *mbox, int type, bool npa)
 {
@@ -1387,6 +1396,7 @@ void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 			pf->hw.txschq_list[lvl][schq] =
 				rsp->schq_list[lvl][schq];
 }
+EXPORT_SYMBOL(mbox_handler_nix_txsch_alloc);
 
 void mbox_handler_npa_lf_alloc(struct otx2_nic *pfvf,
 			       struct npa_lf_alloc_rsp *rsp)
@@ -1394,6 +1404,7 @@ void mbox_handler_npa_lf_alloc(struct otx2_nic *pfvf,
 	pfvf->hw.stack_pg_ptrs = rsp->stack_pg_ptrs;
 	pfvf->hw.stack_pg_bytes = rsp->stack_pg_bytes;
 }
+EXPORT_SYMBOL(mbox_handler_npa_lf_alloc);
 
 void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 			       struct nix_lf_alloc_rsp *rsp)
@@ -1404,6 +1415,7 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 	pfvf->hw.lso_tsov4_idx = rsp->lso_tsov4_idx;
 	pfvf->hw.lso_tsov6_idx = rsp->lso_tsov6_idx;
 }
+EXPORT_SYMBOL(mbox_handler_nix_lf_alloc);
 
 void mbox_handler_msix_offset(struct otx2_nic *pfvf,
 			      struct msix_offset_rsp *rsp)
@@ -1411,6 +1423,7 @@ void mbox_handler_msix_offset(struct otx2_nic *pfvf,
 	pfvf->hw.npa_msixoff = rsp->npa_msixoff;
 	pfvf->hw.nix_msixoff = rsp->nix_msixoff;
 }
+EXPORT_SYMBOL(mbox_handler_msix_offset);
 
 void mbox_handler_nix_bp_enable(struct otx2_nic *pfvf,
 				struct nix_bp_cfg_rsp *rsp)
@@ -1422,6 +1435,7 @@ void mbox_handler_nix_bp_enable(struct otx2_nic *pfvf,
 		pfvf->bpid[chan_id] = rsp->chan_bpid[chan] & 0x3FF;
 	}
 }
+EXPORT_SYMBOL(mbox_handler_nix_bp_enable);
 
 void otx2_free_cints(struct otx2_nic *pfvf, int n)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index c0a9693..ca757b2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -20,6 +20,8 @@
 
 /* PCI device IDs */
 #define PCI_DEVID_OCTEONTX2_RVU_PF              0xA063
+#define PCI_DEVID_OCTEONTX2_RVU_VF		0xA064
+#define PCI_DEVID_OCTEONTX2_RVU_AFVF		0xA0F8
 
 #define PCI_SUBSYS_DEVID_96XX_RVU_PFVF		0xB200
 
@@ -242,6 +244,11 @@ struct otx2_nic {
 	int			nix_blkaddr;
 };
 
+static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
+{
+	return pdev->device == PCI_DEVID_OCTEONTX2_RVU_AFVF;
+}
+
 static inline bool is_96xx_A0(struct pci_dev *pdev)
 {
 	return (pdev->revision == 0x00) &&
@@ -627,6 +634,8 @@ void otx2_set_ethtool_ops(struct net_device *netdev);
 
 int otx2_open(struct net_device *netdev);
 int otx2_stop(struct net_device *netdev);
+int otx2vf_open(struct net_device *netdev);
+int otx2vf_stop(struct net_device *netdev);
 int otx2_set_real_num_queues(struct net_device *netdev,
 			     int tx_queues, int rx_queues);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index bf6e2529..89644d5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1088,6 +1088,7 @@ int otx2_set_real_num_queues(struct net_device *netdev,
 			   "Failed to set no of Rx queues: %d\n", rx_queues);
 	return err;
 }
+EXPORT_SYMBOL(otx2_set_real_num_queues);
 
 static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 {
@@ -1523,6 +1524,9 @@ int otx2_open(struct net_device *netdev)
 	if (pf->linfo.link_up && !(pf->pcifunc & RVU_PFVF_FUNC_MASK))
 		otx2_handle_link_event(pf);
 
+	/* Restore pause frame settings */
+	otx2_config_pause_frm(pf);
+
 	err = otx2_rxtx_enable(pf, true);
 	if (err)
 		goto err_free_cints;
@@ -1546,6 +1550,7 @@ int otx2_open(struct net_device *netdev)
 	kfree(qset->napi);
 	return err;
 }
+EXPORT_SYMBOL(otx2_open);
 
 int otx2_stop(struct net_device *netdev)
 {
@@ -1606,6 +1611,7 @@ int otx2_stop(struct net_device *netdev)
 	       sizeof(*qset) - offsetof(struct otx2_qset, sqe_cnt));
 	return 0;
 }
+EXPORT_SYMBOL(otx2_stop);
 
 static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
@@ -1734,7 +1740,6 @@ static int otx2_realloc_msix_vectors(struct otx2_nic *pf)
 
 	otx2_disable_mbox_intr(pf);
 	pci_free_irq_vectors(hw->pdev);
-	pci_free_irq_vectors(hw->pdev);
 	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
 	if (err < 0) {
 		dev_err(pf->dev, "%s: Failed to realloc %d IRQ vectors\n",
@@ -1901,6 +1906,10 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Enable link notifications */
 	otx2_cgx_config_linkevents(pf, true);
 
+	/* Enable pause frames by default */
+	pf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
+	pf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
+
 	return 0;
 
 err_detach_rsrc:
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index 7963d41..867f646 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -45,6 +45,19 @@
 #define RVU_PF_MSIX_VECX_CTL(a)             (0x008 | (a) << 4)
 #define RVU_PF_MSIX_PBAX(a)                 (0xF0000 | (a) << 3)
 
+/* RVU VF registers */
+#define	RVU_VF_VFPF_MBOX0		    (0x00000)
+#define	RVU_VF_VFPF_MBOX1		    (0x00008)
+#define	RVU_VF_VFPF_MBOXX(a)		    (0x00 | (a) << 3)
+#define	RVU_VF_INT			    (0x20)
+#define	RVU_VF_INT_W1S			    (0x28)
+#define	RVU_VF_INT_ENA_W1S		    (0x30)
+#define	RVU_VF_INT_ENA_W1C		    (0x38)
+#define	RVU_VF_BLOCK_ADDRX_DISC(a)	    (0x200 | (a) << 3)
+#define	RVU_VF_MSIX_VECX_ADDR(a)	    (0x000 | (a) << 4)
+#define	RVU_VF_MSIX_VECX_CTL(a)		    (0x008 | (a) << 4)
+#define	RVU_VF_MSIX_PBAX(a)		    (0xF0000 | (a) << 3)
+
 #define RVU_FUNC_BLKADDR_SHIFT		20
 #define RVU_FUNC_BLKADDR_MASK		0x1FULL
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index bef4c20..1865f16 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -778,6 +778,7 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 
 	return true;
 }
+EXPORT_SYMBOL(otx2_sq_append_skb);
 
 void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
new file mode 100644
index 0000000..cf366dc
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -0,0 +1,659 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Virtual Function ethernet driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "otx2_common.h"
+#include "otx2_reg.h"
+
+#define DRV_NAME	"octeontx2-nicvf"
+#define DRV_STRING	"Marvell OcteonTX2 NIC Virtual Function Driver"
+
+static const struct pci_device_id otx2_vf_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_AFVF) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_VF) },
+	{ }
+};
+
+MODULE_AUTHOR("Sunil Goutham <sgoutham@marvell.com>");
+MODULE_DESCRIPTION(DRV_STRING);
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(pci, otx2_vf_id_table);
+
+/* RVU VF Interrupt Vector Enumeration */
+enum {
+	RVU_VF_INT_VEC_MBOX = 0x0,
+};
+
+static int otx2vf_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	bool if_up = netif_running(netdev);
+	int err = 0;
+
+	if (if_up)
+		otx2vf_stop(netdev);
+
+	netdev_info(netdev, "Changing MTU from %d to %d\n",
+		    netdev->mtu, new_mtu);
+	netdev->mtu = new_mtu;
+
+	if (if_up)
+		err = otx2vf_open(netdev);
+
+	return err;
+}
+
+static void otx2vf_process_vfaf_mbox_msg(struct otx2_nic *vf,
+					 struct mbox_msghdr *msg)
+{
+	if (msg->id >= MBOX_MSG_MAX) {
+		dev_err(vf->dev,
+			"Mbox msg with unknown ID %d\n", msg->id);
+		return;
+	}
+
+	if (msg->sig != OTX2_MBOX_RSP_SIG) {
+		dev_err(vf->dev,
+			"Mbox msg with wrong signature %x, ID %d\n",
+			msg->sig, msg->id);
+		return;
+	}
+
+	if (msg->rc == MBOX_MSG_INVALID) {
+		dev_err(vf->dev,
+			"PF/AF says the sent msg(s) %d were invalid\n",
+			msg->id);
+		return;
+	}
+
+	switch (msg->id) {
+	case MBOX_MSG_READY:
+		vf->pcifunc = msg->pcifunc;
+		break;
+	case MBOX_MSG_MSIX_OFFSET:
+		mbox_handler_msix_offset(vf, (struct msix_offset_rsp *)msg);
+		break;
+	case MBOX_MSG_NPA_LF_ALLOC:
+		mbox_handler_npa_lf_alloc(vf, (struct npa_lf_alloc_rsp *)msg);
+		break;
+	case MBOX_MSG_NIX_LF_ALLOC:
+		mbox_handler_nix_lf_alloc(vf, (struct nix_lf_alloc_rsp *)msg);
+		break;
+	case MBOX_MSG_NIX_TXSCH_ALLOC:
+		mbox_handler_nix_txsch_alloc(vf,
+					     (struct nix_txsch_alloc_rsp *)msg);
+		break;
+	case MBOX_MSG_NIX_BP_ENABLE:
+		mbox_handler_nix_bp_enable(vf, (struct nix_bp_cfg_rsp *)msg);
+		break;
+	default:
+		if (msg->rc)
+			dev_err(vf->dev,
+				"Mbox msg response has err %d, ID %d\n",
+				msg->rc, msg->id);
+	}
+}
+
+static void otx2vf_vfaf_mbox_handler(struct work_struct *work)
+{
+	struct otx2_mbox_dev *mdev;
+	struct mbox_hdr *rsp_hdr;
+	struct mbox_msghdr *msg;
+	struct otx2_mbox *mbox;
+	struct mbox *af_mbox;
+	int offset, id;
+
+	af_mbox = container_of(work, struct mbox, mbox_wrk);
+	mbox = &af_mbox->mbox;
+	mdev = &mbox->dev[0];
+	rsp_hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
+	if (af_mbox->num_msgs == 0)
+		return;
+	offset = mbox->rx_start + ALIGN(sizeof(*rsp_hdr), MBOX_MSG_ALIGN);
+
+	for (id = 0; id < af_mbox->num_msgs; id++) {
+		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
+		otx2vf_process_vfaf_mbox_msg(af_mbox->pfvf, msg);
+		offset = mbox->rx_start + msg->next_msgoff;
+		mdev->msgs_acked++;
+	}
+
+	otx2_mbox_reset(mbox, 0);
+}
+
+static int otx2vf_process_mbox_msg_up(struct otx2_nic *vf,
+				      struct mbox_msghdr *req)
+{
+	/* Check if valid, if not reply with a invalid msg */
+	if (req->sig != OTX2_MBOX_REQ_SIG) {
+		otx2_reply_invalid_msg(&vf->mbox.mbox_up, 0, 0, req->id);
+		return -ENODEV;
+	}
+
+	switch (req->id) {
+#define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
+	case _id: {							\
+		struct _rsp_type *rsp;					\
+		int err;						\
+									\
+		rsp = (struct _rsp_type *)otx2_mbox_alloc_msg(		\
+			&vf->mbox.mbox_up, 0,				\
+			sizeof(struct _rsp_type));			\
+		if (!rsp)						\
+			return -ENOMEM;					\
+									\
+		rsp->hdr.id = _id;					\
+		rsp->hdr.sig = OTX2_MBOX_RSP_SIG;			\
+		rsp->hdr.pcifunc = 0;					\
+		rsp->hdr.rc = 0;					\
+									\
+		err = otx2_mbox_up_handler_ ## _fn_name(		\
+			vf, (struct _req_type *)req, rsp);		\
+		return err;						\
+	}
+MBOX_UP_CGX_MESSAGES
+#undef M
+		break;
+	default:
+		otx2_reply_invalid_msg(&vf->mbox.mbox_up, 0, 0, req->id);
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static void otx2vf_vfaf_mbox_up_handler(struct work_struct *work)
+{
+	struct otx2_mbox_dev *mdev;
+	struct mbox_hdr *rsp_hdr;
+	struct mbox_msghdr *msg;
+	struct otx2_mbox *mbox;
+	struct mbox *vf_mbox;
+	struct otx2_nic *vf;
+	int offset, id;
+
+	vf_mbox = container_of(work, struct mbox, mbox_up_wrk);
+	vf = vf_mbox->pfvf;
+	mbox = &vf_mbox->mbox_up;
+	mdev = &mbox->dev[0];
+
+	rsp_hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
+	if (vf_mbox->up_num_msgs == 0)
+		return;
+
+	offset = mbox->rx_start + ALIGN(sizeof(*rsp_hdr), MBOX_MSG_ALIGN);
+
+	for (id = 0; id < vf_mbox->up_num_msgs; id++) {
+		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
+		otx2vf_process_mbox_msg_up(vf, msg);
+		offset = mbox->rx_start + msg->next_msgoff;
+	}
+
+	otx2_mbox_msg_send(mbox, 0);
+}
+
+static irqreturn_t otx2vf_vfaf_mbox_intr_handler(int irq, void *vf_irq)
+{
+	struct otx2_nic *vf = (struct otx2_nic *)vf_irq;
+	struct otx2_mbox_dev *mdev;
+	struct otx2_mbox *mbox;
+	struct mbox_hdr *hdr;
+
+	/* Clear the IRQ */
+	otx2_write64(vf, RVU_VF_INT, BIT_ULL(0));
+
+	/* Read latest mbox data */
+	smp_rmb();
+
+	/* Check for PF => VF response messages */
+	mbox = &vf->mbox.mbox;
+	mdev = &mbox->dev[0];
+	otx2_sync_mbox_bbuf(mbox, 0);
+
+	hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
+	if (hdr->num_msgs) {
+		vf->mbox.num_msgs = hdr->num_msgs;
+		hdr->num_msgs = 0;
+		memset(mbox->hwbase + mbox->rx_start, 0,
+		       ALIGN(sizeof(struct mbox_hdr), sizeof(u64)));
+		queue_work(vf->mbox_wq, &vf->mbox.mbox_wrk);
+	}
+	/* Check for PF => VF notification messages */
+	mbox = &vf->mbox.mbox_up;
+	mdev = &mbox->dev[0];
+	otx2_sync_mbox_bbuf(mbox, 0);
+
+	hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
+	if (hdr->num_msgs) {
+		vf->mbox.up_num_msgs = hdr->num_msgs;
+		hdr->num_msgs = 0;
+		memset(mbox->hwbase + mbox->rx_start, 0,
+		       ALIGN(sizeof(struct mbox_hdr), sizeof(u64)));
+		queue_work(vf->mbox_wq, &vf->mbox.mbox_up_wrk);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void otx2vf_disable_mbox_intr(struct otx2_nic *vf)
+{
+	int vector = pci_irq_vector(vf->pdev, RVU_VF_INT_VEC_MBOX);
+
+	/* Disable VF => PF mailbox IRQ */
+	otx2_write64(vf, RVU_VF_INT_ENA_W1C, BIT_ULL(0));
+	free_irq(vector, vf);
+}
+
+static int otx2vf_register_mbox_intr(struct otx2_nic *vf, bool probe_pf)
+{
+	struct otx2_hw *hw = &vf->hw;
+	struct msg_req *req;
+	char *irq_name;
+	int err;
+
+	/* Register mailbox interrupt handler */
+	irq_name = &hw->irq_name[RVU_VF_INT_VEC_MBOX * NAME_SIZE];
+	snprintf(irq_name, NAME_SIZE, "RVUVFAF Mbox");
+	err = request_irq(pci_irq_vector(vf->pdev, RVU_VF_INT_VEC_MBOX),
+			  otx2vf_vfaf_mbox_intr_handler, 0, irq_name, vf);
+	if (err) {
+		dev_err(vf->dev,
+			"RVUPF: IRQ registration failed for VFAF mbox irq\n");
+		return err;
+	}
+
+	/* Enable mailbox interrupt for msgs coming from PF.
+	 * First clear to avoid spurious interrupts, if any.
+	 */
+	otx2_write64(vf, RVU_VF_INT, BIT_ULL(0));
+	otx2_write64(vf, RVU_VF_INT_ENA_W1S, BIT_ULL(0));
+
+	if (!probe_pf)
+		return 0;
+
+	/* Check mailbox communication with PF */
+	req = otx2_mbox_alloc_msg_ready(&vf->mbox);
+	if (!req) {
+		otx2vf_disable_mbox_intr(vf);
+		return -ENOMEM;
+	}
+
+	err = otx2_sync_mbox_msg(&vf->mbox);
+	if (err) {
+		dev_warn(vf->dev,
+			 "AF not responding to mailbox, deferring probe\n");
+		otx2vf_disable_mbox_intr(vf);
+		return -EPROBE_DEFER;
+	}
+	return 0;
+}
+
+static void otx2vf_vfaf_mbox_destroy(struct otx2_nic *vf)
+{
+	struct mbox *mbox = &vf->mbox;
+
+	if (vf->mbox_wq) {
+		flush_workqueue(vf->mbox_wq);
+		destroy_workqueue(vf->mbox_wq);
+		vf->mbox_wq = NULL;
+	}
+
+	if (mbox->mbox.hwbase)
+		iounmap((void __iomem *)mbox->mbox.hwbase);
+
+	otx2_mbox_destroy(&mbox->mbox);
+	otx2_mbox_destroy(&mbox->mbox_up);
+}
+
+static int otx2vf_vfaf_mbox_init(struct otx2_nic *vf)
+{
+	struct mbox *mbox = &vf->mbox;
+	void __iomem *hwbase;
+	int err;
+
+	mbox->pfvf = vf;
+	vf->mbox_wq = alloc_workqueue("otx2_vfaf_mailbox",
+				      WQ_UNBOUND | WQ_HIGHPRI |
+				      WQ_MEM_RECLAIM, 1);
+	if (!vf->mbox_wq)
+		return -ENOMEM;
+
+	/* Mailbox is a reserved memory (in RAM) region shared between
+	 * admin function (i.e PF0) and this VF, shouldn't be mapped as
+	 * device memory to allow unaligned accesses.
+	 */
+	hwbase = ioremap_wc(pci_resource_start(vf->pdev, PCI_MBOX_BAR_NUM),
+			    pci_resource_len(vf->pdev, PCI_MBOX_BAR_NUM));
+	if (!hwbase) {
+		dev_err(vf->dev, "Unable to map VFAF mailbox region\n");
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	err = otx2_mbox_init(&mbox->mbox, hwbase, vf->pdev, vf->reg_base,
+			     MBOX_DIR_VFPF, 1);
+	if (err)
+		goto exit;
+
+	err = otx2_mbox_init(&mbox->mbox_up, hwbase, vf->pdev, vf->reg_base,
+			     MBOX_DIR_VFPF_UP, 1);
+	if (err)
+		goto exit;
+
+	err = otx2_mbox_bbuf_init(mbox, vf->pdev);
+	if (err)
+		goto exit;
+
+	INIT_WORK(&mbox->mbox_wrk, otx2vf_vfaf_mbox_handler);
+	INIT_WORK(&mbox->mbox_up_wrk, otx2vf_vfaf_mbox_up_handler);
+	otx2_mbox_lock_init(&vf->mbox);
+
+	return 0;
+exit:
+	destroy_workqueue(vf->mbox_wq);
+	return err;
+}
+
+int otx2vf_open(struct net_device *netdev)
+{
+	struct otx2_nic *vf;
+	int err;
+
+	err = otx2_open(netdev);
+	if (err)
+		return err;
+
+	/* LBKs do not receive link events so tell everyone we are up here */
+	vf = netdev_priv(netdev);
+	if (is_otx2_lbkvf(vf->pdev)) {
+		pr_info("%s NIC Link is UP\n", netdev->name);
+		netif_carrier_on(netdev);
+		netif_tx_start_all_queues(netdev);
+	}
+
+	return 0;
+}
+
+int otx2vf_stop(struct net_device *netdev)
+{
+	return otx2_stop(netdev);
+}
+
+static netdev_tx_t otx2vf_xmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct otx2_nic *vf = netdev_priv(netdev);
+	int qidx = skb_get_queue_mapping(skb);
+	struct otx2_snd_queue *sq;
+	struct netdev_queue *txq;
+
+	sq = &vf->qset.sq[qidx];
+	txq = netdev_get_tx_queue(netdev, qidx);
+
+	if (!otx2_sq_append_skb(netdev, sq, skb, qidx)) {
+		netif_tx_stop_queue(txq);
+
+		/* Check again, incase SQBs got freed up */
+		smp_mb();
+		if (((sq->num_sqbs - *sq->aura_fc_addr) * sq->sqe_per_sqb)
+							> sq->sqe_thresh)
+			netif_tx_wake_queue(txq);
+
+		return NETDEV_TX_BUSY;
+	}
+
+	return NETDEV_TX_OK;
+}
+
+static void otx2vf_reset_task(struct work_struct *work)
+{
+	struct otx2_nic *vf = container_of(work, struct otx2_nic, reset_task);
+
+	rtnl_lock();
+
+	if (netif_running(vf->netdev)) {
+		otx2vf_stop(vf->netdev);
+		vf->reset_count++;
+		otx2vf_open(vf->netdev);
+	}
+
+	rtnl_unlock();
+}
+
+static const struct net_device_ops otx2vf_netdev_ops = {
+	.ndo_open = otx2vf_open,
+	.ndo_stop = otx2vf_stop,
+	.ndo_start_xmit = otx2vf_xmit,
+	.ndo_set_mac_address = otx2_set_mac_address,
+	.ndo_change_mtu = otx2vf_change_mtu,
+	.ndo_get_stats64 = otx2_get_stats64,
+	.ndo_tx_timeout = otx2_tx_timeout,
+};
+
+static int otx2vf_realloc_msix_vectors(struct otx2_nic *vf)
+{
+	struct otx2_hw *hw = &vf->hw;
+	int num_vec, err;
+
+	num_vec = hw->nix_msixoff;
+	num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
+
+	otx2vf_disable_mbox_intr(vf);
+	pci_free_irq_vectors(hw->pdev);
+	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
+	if (err < 0) {
+		dev_err(vf->dev, "%s: Failed to realloc %d IRQ vectors\n",
+			__func__, num_vec);
+		return err;
+	}
+
+	return otx2vf_register_mbox_intr(vf, false);
+}
+
+static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	int num_vec = pci_msix_vec_count(pdev);
+	struct device *dev = &pdev->dev;
+	struct net_device *netdev;
+	struct otx2_nic *vf;
+	struct otx2_hw *hw;
+	int err, qcount;
+
+	err = pcim_enable_device(pdev);
+	if (err) {
+		dev_err(dev, "Failed to enable PCI device\n");
+		return err;
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		dev_err(dev, "PCI request regions failed 0x%x\n", err);
+		return err;
+	}
+
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
+	if (err) {
+		dev_err(dev, "DMA mask config failed, abort\n");
+		goto err_release_regions;
+	}
+
+	pci_set_master(pdev);
+
+	qcount = num_online_cpus();
+	netdev = alloc_etherdev_mqs(sizeof(*vf), qcount, qcount);
+	if (!netdev) {
+		err = -ENOMEM;
+		goto err_release_regions;
+	}
+
+	pci_set_drvdata(pdev, netdev);
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+	vf = netdev_priv(netdev);
+	vf->netdev = netdev;
+	vf->pdev = pdev;
+	vf->dev = dev;
+	vf->iommu_domain = iommu_get_domain_for_dev(dev);
+
+	vf->flags |= OTX2_FLAG_INTF_DOWN;
+	hw = &vf->hw;
+	hw->pdev = vf->pdev;
+	hw->rx_queues = qcount;
+	hw->tx_queues = qcount;
+	hw->max_queues = qcount;
+
+	hw->irq_name = devm_kmalloc_array(&hw->pdev->dev, num_vec, NAME_SIZE,
+					  GFP_KERNEL);
+	if (!hw->irq_name)
+		goto err_free_netdev;
+
+	hw->affinity_mask = devm_kcalloc(&hw->pdev->dev, num_vec,
+					 sizeof(cpumask_var_t), GFP_KERNEL);
+	if (!hw->affinity_mask)
+		goto err_free_netdev;
+
+	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
+	if (err < 0) {
+		dev_err(dev, "%s: Failed to alloc %d IRQ vectors\n",
+			__func__, num_vec);
+		goto err_free_netdev;
+	}
+
+	vf->reg_base = pcim_iomap(pdev, PCI_CFG_REG_BAR_NUM, 0);
+	if (!vf->reg_base) {
+		dev_err(dev, "Unable to map physical function CSRs, aborting\n");
+		err = -ENOMEM;
+		goto err_free_irq_vectors;
+	}
+
+	/* Init VF <=> PF mailbox stuff */
+	err = otx2vf_vfaf_mbox_init(vf);
+	if (err)
+		goto err_free_irq_vectors;
+
+	/* Register mailbox interrupt */
+	err = otx2vf_register_mbox_intr(vf, true);
+	if (err)
+		goto err_mbox_destroy;
+
+	/* Request AF to attach NPA and LIX LFs to this AF */
+	err = otx2_attach_npa_nix(vf);
+	if (err)
+		goto err_disable_mbox_intr;
+
+	err = otx2vf_realloc_msix_vectors(vf);
+	if (err)
+		goto err_mbox_destroy;
+
+	err = otx2_set_real_num_queues(netdev, qcount, qcount);
+	if (err)
+		goto err_detach_rsrc;
+
+	otx2_setup_dev_hw_settings(vf);
+
+	/* Assign default mac address */
+	otx2_get_mac_from_af(netdev);
+
+	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
+			      NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
+			      NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6;
+	netdev->features = netdev->hw_features;
+
+	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
+	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
+
+	netdev->netdev_ops = &otx2vf_netdev_ops;
+
+	/* MTU range: 68 - 9190 */
+	netdev->min_mtu = OTX2_MIN_MTU;
+	netdev->max_mtu = OTX2_MAX_MTU;
+
+	INIT_WORK(&vf->reset_task, otx2vf_reset_task);
+
+	/* To distinguish, for LBK VFs set netdev name explicitly */
+	if (is_otx2_lbkvf(vf->pdev)) {
+		int n;
+
+		n = (vf->pcifunc >> RVU_PFVF_FUNC_SHIFT) & RVU_PFVF_FUNC_MASK;
+		/* Need to subtract 1 to get proper VF number */
+		n -= 1;
+		snprintf(netdev->name, sizeof(netdev->name), "lbk%d", n);
+	}
+
+	err = register_netdev(netdev);
+	if (err) {
+		dev_err(dev, "Failed to register netdevice\n");
+		goto err_detach_rsrc;
+	}
+
+	/* Enable pause frames by default */
+	vf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
+	vf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
+
+	return 0;
+
+err_detach_rsrc:
+	otx2_detach_resources(&vf->mbox);
+err_disable_mbox_intr:
+	otx2vf_disable_mbox_intr(vf);
+err_mbox_destroy:
+	otx2vf_vfaf_mbox_destroy(vf);
+err_free_irq_vectors:
+	pci_free_irq_vectors(hw->pdev);
+err_free_netdev:
+	pci_set_drvdata(pdev, NULL);
+	free_netdev(netdev);
+err_release_regions:
+	pci_release_regions(pdev);
+	return err;
+}
+
+static void otx2vf_remove(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct otx2_nic *vf;
+
+	if (!netdev)
+		return;
+
+	vf = netdev_priv(netdev);
+
+	otx2vf_disable_mbox_intr(vf);
+
+	otx2_detach_resources(&vf->mbox);
+	otx2vf_vfaf_mbox_destroy(vf);
+	pci_free_irq_vectors(vf->pdev);
+	pci_set_drvdata(pdev, NULL);
+	free_netdev(netdev);
+
+	pci_release_regions(pdev);
+}
+
+static struct pci_driver otx2vf_driver = {
+	.name = DRV_NAME,
+	.id_table = otx2_vf_id_table,
+	.probe = otx2vf_probe,
+	.remove = otx2vf_remove,
+	.shutdown = otx2vf_remove,
+};
+
+static int __init otx2vf_init_module(void)
+{
+	pr_info("%s: %s\n", DRV_NAME, DRV_STRING);
+
+	return pci_register_driver(&otx2vf_driver);
+}
+
+static void __exit otx2vf_cleanup_module(void)
+{
+	pci_unregister_driver(&otx2vf_driver);
+}
+
+module_init(otx2vf_init_module);
+module_exit(otx2vf_cleanup_module);
-- 
2.7.4

