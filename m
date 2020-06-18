Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265161FEAC2
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgFRFOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:14:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:64356 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgFRFOO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:14:14 -0400
IronPort-SDR: uvCwNMp6kf7+OFojqMAwQ0h6k2862IfJfhteEw0OLNPGWV/9zqAuu42JWXtx86AOx//nfXq4Q9
 9jT3kRKaQlpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="141516121"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="141516121"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:53 -0700
IronPort-SDR: zEw+msD7Za2wP2gHwRW2Mjw9TrLC5KADiWuK+N6rCJJLyC+ihecwjeNAxASS+PfmFBOYXSh2d6
 Lff+bSl/NOXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495634"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:53 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alan Brady <alan.brady@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alice Michael <alice.michael@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] idpf: Introduce idpf driver
Date:   Wed, 17 Jun 2020 22:13:44 -0700
Message-Id: <20200618051344.516587-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alan Brady <alan.brady@intel.com>

Utilizes the Intel Ethernet Common Module and provides
a device specific implementation for data plane devices.

Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../networking/device_drivers/intel/idpf.rst  |  47 ++++++
 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/intel/Kconfig            |   8 +
 drivers/net/ethernet/intel/Makefile           |   1 +
 drivers/net/ethernet/intel/idpf/Makefile      |  12 ++
 drivers/net/ethernet/intel/idpf/idpf_dev.h    |  17 ++
 drivers/net/ethernet/intel/idpf/idpf_devids.h |  10 ++
 drivers/net/ethernet/intel/idpf/idpf_main.c   | 136 ++++++++++++++++
 drivers/net/ethernet/intel/idpf/idpf_reg.c    | 152 ++++++++++++++++++
 9 files changed, 384 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/intel/idpf.rst
 create mode 100644 drivers/net/ethernet/intel/idpf/Makefile
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_dev.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_devids.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_main.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_reg.c

diff --git a/Documentation/networking/device_drivers/intel/idpf.rst b/Documentation/networking/device_drivers/intel/idpf.rst
new file mode 100644
index 000000000000..973fa9613428
--- /dev/null
+++ b/Documentation/networking/device_drivers/intel/idpf.rst
@@ -0,0 +1,47 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================================================
+Linux Base Driver for the Intel(R) Smart Network Adapter Family Series
+==================================================================
+
+Intel idpf Linux driver.
+Copyright(c) 2020 Intel Corporation.
+
+Contents
+========
+
+- Enabling the driver
+- Support
+
+The driver in this release supports Intel's Smart Network Adapter Family Series
+of products. For more information, visit Intel's support page at
+https://support.intel.com.
+
+Enabling the driver
+===================
+The driver is enabled via the standard kernel configuration system,
+using the make command::
+
+  make oldconfig/menuconfig/etc.
+
+The driver is located in the menu structure at:
+
+  -> Device Drivers
+    -> Network device support (NETDEVICES [=y])
+      -> Ethernet driver support
+        -> Intel devices
+          -> Intel(R) Smart Network Adapter Family Series Support
+
+Support
+=======
+For general information, go to the Intel support website at:
+
+https://www.intel.com/support/
+
+or the Intel Wired Networking project hosted by Sourceforge at:
+
+https://sourceforge.net/projects/e1000
+
+If an issue is identified with the released source code on a supported kernel
+with a supported adapter, email the specific information related to the issue
+to e1000-devel@lists.sf.net.
diff --git a/MAINTAINERS b/MAINTAINERS
index 102ee1e4aef0..97ac0d417067 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8654,6 +8654,7 @@ F:	Documentation/networking/device_drivers/intel/fm10k.rst
 F:	Documentation/networking/device_drivers/intel/i40e.rst
 F:	Documentation/networking/device_drivers/intel/iavf.rst
 F:	Documentation/networking/device_drivers/intel/ice.rst
+F:	Documentation/networking/device_drivers/intel/idpf.rst
 F:	Documentation/networking/device_drivers/intel/iecm.rst
 F:	Documentation/networking/device_drivers/intel/igb.rst
 F:	Documentation/networking/device_drivers/intel/igbvf.rst
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 6dd985cbdb6d..9e0b3c1bf7c6 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -349,4 +349,12 @@ config IECM
 	help
 	 To compile this driver as a module, choose M here. The module
 	 will be called iecm.  MSI-X interrupt support is required
+
+config IDPF
+	tristate "Intel(R) Data Plane Function Support"
+	default n
+	depends on PCI
+	help
+	 To compile this driver as a module, choose M here. The module
+	 will be called idpf.
 endif # NET_VENDOR_INTEL
diff --git a/drivers/net/ethernet/intel/Makefile b/drivers/net/ethernet/intel/Makefile
index c9eba9cc5087..3786c2269f3d 100644
--- a/drivers/net/ethernet/intel/Makefile
+++ b/drivers/net/ethernet/intel/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_IAVF) += iavf/
 obj-$(CONFIG_FM10K) += fm10k/
 obj-$(CONFIG_ICE) += ice/
 obj-$(CONFIG_IECM) += iecm/
+obj-$(CONFIG_IDPF) += idpf/
diff --git a/drivers/net/ethernet/intel/idpf/Makefile b/drivers/net/ethernet/intel/idpf/Makefile
new file mode 100644
index 000000000000..ac6cac6c6360
--- /dev/null
+++ b/drivers/net/ethernet/intel/idpf/Makefile
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright (C) 2020 Intel Corporation
+
+#
+# Makefile for the Intel(R) Data Plane Function Linux Driver
+#
+
+obj-$(CONFIG_IDPF) += idpf.o
+
+idpf-y := \
+	idpf_main.o \
+	idpf_reg.o
diff --git a/drivers/net/ethernet/intel/idpf/idpf_dev.h b/drivers/net/ethernet/intel/idpf/idpf_dev.h
new file mode 100644
index 000000000000..1da33f5120a2
--- /dev/null
+++ b/drivers/net/ethernet/intel/idpf/idpf_dev.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2020 Intel Corporation */
+
+#ifndef _IDPF_DEV_H_
+#define _IDPF_DEV_H_
+
+#include <linux/net/intel/iecm.h>
+
+void idpf_intr_reg_init(struct iecm_vport *vport);
+void idpf_mb_intr_reg_init(struct iecm_adapter *adapter);
+void idpf_reset_reg_init(struct iecm_reset_reg *reset_reg);
+void idpf_trigger_reset(struct iecm_adapter *adapter,
+			enum iecm_flags trig_cause);
+void idpf_vportq_reg_init(struct iecm_vport *vport);
+void idpf_ctlq_reg_init(struct iecm_ctlq_create_info *cq);
+
+#endif /* _IDPF_DEV_H_ */
diff --git a/drivers/net/ethernet/intel/idpf/idpf_devids.h b/drivers/net/ethernet/intel/idpf/idpf_devids.h
new file mode 100644
index 000000000000..ee373a04cb20
--- /dev/null
+++ b/drivers/net/ethernet/intel/idpf/idpf_devids.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2020 Intel Corporation */
+
+#ifndef _IDPF_DEVIDS_H_
+#define _IDPF_DEVIDS_H_
+
+/* Device IDs */
+#define IDPF_DEV_ID_PF			0x1452
+
+#endif /* _IDPF_DEVIDS_H_ */
diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
new file mode 100644
index 000000000000..56f20abd57ee
--- /dev/null
+++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Intel Corporation */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include "idpf_dev.h"
+#include "idpf_devids.h"
+
+#define DRV_SUMMARY	"Intel(R) Data Plane Function Linux Driver"
+static const char idpf_driver_string[] = DRV_SUMMARY;
+static const char idpf_copyright[] = "Copyright (c) 2020, Intel Corporation.";
+
+MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
+MODULE_DESCRIPTION(DRV_SUMMARY);
+MODULE_LICENSE("GPL v2");
+
+static int debug = -1;
+module_param(debug, int, 0644);
+#ifndef CONFIG_DYNAMIC_DEBUG
+MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all), hw debug_mask (0x8XXXXXXX)");
+#else
+MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all)");
+#endif /* !CONFIG_DYNAMIC_DEBUG */
+
+/**
+ * idpf_reg_ops_init - Initialize register API function pointers
+ * @adapter: Driver specific private structure
+ */
+static void idpf_reg_ops_init(struct iecm_adapter *adapter)
+{
+	adapter->dev_ops.reg_ops.ctlq_reg_init = idpf_ctlq_reg_init;
+	adapter->dev_ops.reg_ops.vportq_reg_init = idpf_vportq_reg_init;
+	adapter->dev_ops.reg_ops.intr_reg_init = idpf_intr_reg_init;
+	adapter->dev_ops.reg_ops.mb_intr_reg_init = idpf_mb_intr_reg_init;
+	adapter->dev_ops.reg_ops.reset_reg_init = idpf_reset_reg_init;
+	adapter->dev_ops.reg_ops.trigger_reset = idpf_trigger_reset;
+}
+
+/**
+ * idpf_probe - Device initialization routine
+ * @pdev: PCI device information struct
+ * @ent: entry in idpf_pci_tbl
+ *
+ * Returns 0 on success, negative on failure
+ */
+int idpf_probe(struct pci_dev *pdev,
+	       const struct pci_device_id __always_unused *ent)
+{
+	struct iecm_adapter *adapter = NULL;
+	int err;
+
+	err = pcim_enable_device(pdev);
+	if (err)
+		return err;
+
+	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
+	if (!adapter)
+		return -ENOMEM;
+
+	adapter->dev_ops.reg_ops_init = idpf_reg_ops_init;
+
+	err = iecm_probe(pdev, ent, adapter);
+	if (err)
+		kfree(adapter);
+
+	return err;
+}
+
+/**
+ * idpf_remove - Device removal routine
+ * @pdev: PCI device information struct
+ */
+static void idpf_remove(struct pci_dev *pdev)
+{
+	struct iecm_adapter *adapter = pci_get_drvdata(pdev);
+
+	iecm_remove(pdev);
+	kfree(adapter);
+}
+
+/* idpf_pci_tbl - PCI Dev idpf ID Table
+ *
+ * Wildcard entries (PCI_ANY_ID) should come last
+ * Last entry must be all 0s
+ *
+ * { Vendor ID, Deviecm ID, SubVendor ID, SubDevice ID,
+ *   Class, Class Mask, private data (not used) }
+ */
+static const struct pci_device_id idpf_pci_tbl[] = {
+	{ PCI_VDEVICE(INTEL, IDPF_DEV_ID_PF), 0 },
+	/* required last entry */
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, idpf_pci_tbl);
+
+static struct pci_driver idpf_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = idpf_pci_tbl,
+	.probe = idpf_probe,
+	.remove = idpf_remove,
+	.shutdown = iecm_shutdown,
+};
+
+/**
+ * idpf_module_init - Driver registration routine
+ *
+ * idpf_module_init is the first routine called when the driver is
+ * loaded. All it does is register with the PCI subsystem.
+ */
+static int __init idpf_module_init(void)
+{
+	int status;
+
+	pr_info("%s", idpf_driver_string);
+	pr_info("%s\n", idpf_copyright);
+
+	status = pci_register_driver(&idpf_driver);
+	if (status)
+		pr_err("failed to register pci driver, err %d\n", status);
+
+	return status;
+}
+module_init(idpf_module_init);
+
+/**
+ * idpf_module_exit - Driver exit cleanup routine
+ *
+ * idpf_module_exit is called just before the driver is removed
+ * from memory.
+ */
+static void __exit idpf_module_exit(void)
+{
+	pci_unregister_driver(&idpf_driver);
+	pr_info("module unloaded\n");
+}
+module_exit(idpf_module_exit);
diff --git a/drivers/net/ethernet/intel/idpf/idpf_reg.c b/drivers/net/ethernet/intel/idpf/idpf_reg.c
new file mode 100644
index 000000000000..f5f364639cfc
--- /dev/null
+++ b/drivers/net/ethernet/intel/idpf/idpf_reg.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Intel Corporation */
+
+#include "idpf_dev.h"
+#include <linux/net/intel/iecm_lan_pf_regs.h>
+
+/**
+ * idpf_ctlq_reg_init - initialize default mailbox registers
+ * @cq: pointer to the array of create control queues
+ */
+void idpf_ctlq_reg_init(struct iecm_ctlq_create_info *cq)
+{
+	int i;
+
+#define NUM_Q 2
+	for (i = 0; i < NUM_Q; i++) {
+		struct iecm_ctlq_create_info *ccq = cq + i;
+
+		switch (ccq->type) {
+		case IECM_CTLQ_TYPE_MAILBOX_TX:
+			/* set head and tail registers in our local struct */
+			ccq->reg.head = PF_FW_ATQH;
+			ccq->reg.tail = PF_FW_ATQT;
+			ccq->reg.len = PF_FW_ATQLEN;
+			ccq->reg.bah = PF_FW_ATQBAH;
+			ccq->reg.bal = PF_FW_ATQBAL;
+			ccq->reg.len_mask = PF_FW_ATQLEN_ATQLEN_M;
+			ccq->reg.len_ena_mask = PF_FW_ATQLEN_ATQENABLE_M;
+			ccq->reg.head_mask = PF_FW_ATQH_ATQH_M;
+			break;
+		case IECM_CTLQ_TYPE_MAILBOX_RX:
+			/* set head and tail registers in our local struct */
+			ccq->reg.head = PF_FW_ARQH;
+			ccq->reg.tail = PF_FW_ARQT;
+			ccq->reg.len = PF_FW_ARQLEN;
+			ccq->reg.bah = PF_FW_ARQBAH;
+			ccq->reg.bal = PF_FW_ARQBAL;
+			ccq->reg.len_mask = PF_FW_ARQLEN_ARQLEN_M;
+			ccq->reg.len_ena_mask = PF_FW_ARQLEN_ARQENABLE_M;
+			ccq->reg.head_mask = PF_FW_ARQH_ARQH_M;
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+/**
+ * idpf_vportq_reg_init - Initialize tail registers
+ * @vport: virtual port structure
+ */
+void idpf_vportq_reg_init(struct iecm_vport *vport)
+{
+	struct iecm_hw *hw = &vport->adapter->hw;
+	struct iecm_queue *q;
+	int i, j;
+
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		int num_txq = vport->txq_grps[i].num_txq;
+
+		for (j = 0; j < num_txq; j++) {
+			q = &vport->txq_grps[i].txqs[j];
+			q->tail = hw->hw_addr + PF_QTX_COMM_DBELL(q->q_id);
+		}
+	}
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct iecm_rxq_group *rxq_grp = &vport->rxq_grps[i];
+		int num_rxq;
+
+		if (iecm_is_queue_model_split(vport->rxq_model)) {
+			for (j = 0; j < IECM_BUFQS_PER_RXQ_SET; j++) {
+				q = &rxq_grp->splitq.bufq_sets[j].bufq;
+				q->tail = hw->hw_addr +
+					  PF_QRX_BUFFQ_TAIL(q->q_id);
+			}
+
+			num_rxq = rxq_grp->splitq.num_rxq_sets;
+		} else {
+			num_rxq = rxq_grp->singleq.num_rxq;
+		}
+
+		for (j = 0; j < num_rxq; j++) {
+			if (iecm_is_queue_model_split(vport->rxq_model))
+				q = &rxq_grp->splitq.rxq_sets[j].rxq;
+			else
+				q = &rxq_grp->singleq.rxqs[j];
+			q->tail = hw->hw_addr + PF_QRX_TAIL(q->q_id);
+		}
+	}
+}
+
+/**
+ * idpf_mb_intr_reg_init - Initialize mailbox interrupt register
+ * @adapter: adapter structure
+ */
+void idpf_mb_intr_reg_init(struct iecm_adapter *adapter)
+{
+	struct iecm_intr_reg *intr = &adapter->mb_vector.intr_reg;
+	int vidx;
+
+	vidx = adapter->mb_vector.v_idx;
+	intr->dyn_ctl = PF_GLINT_DYN_CTL(vidx);
+	intr->dyn_ctl_intena_m = PF_GLINT_DYN_CTL_INTENA_M;
+	intr->dyn_ctl_itridx_m = 0x3 << PF_GLINT_DYN_CTL_ITR_INDX_S;
+}
+
+/**
+ * idpf_intr_reg_init - Initialize interrupt registers
+ * @vport: virtual port structure
+ */
+void idpf_intr_reg_init(struct iecm_vport *vport)
+{
+	int q_idx;
+
+	for (q_idx = 0; q_idx < vport->num_q_vectors; q_idx++) {
+		struct iecm_q_vector *q_vector = &vport->q_vectors[q_idx];
+		struct iecm_intr_reg *intr = &q_vector->intr_reg;
+		u32 vidx = q_vector->v_idx;
+
+		intr->dyn_ctl = PF_GLINT_DYN_CTL(vidx);
+		intr->dyn_ctl_clrpba_m = PF_GLINT_DYN_CTL_CLEARPBA_M;
+		intr->dyn_ctl_intena_m = PF_GLINT_DYN_CTL_INTENA_M;
+		intr->dyn_ctl_itridx_s = PF_GLINT_DYN_CTL_ITR_INDX_S;
+		intr->dyn_ctl_intrvl_s = PF_GLINT_DYN_CTL_INTERVAL_S;
+		intr->itr = PF_GLINT_ITR(VIRTCHNL_ITR_IDX_0, vidx);
+	}
+}
+
+/**
+ * idpf_reset_reg_init - Initialize reset registers
+ * @reset_reg: struct to be filled in with reset registers
+ */
+void idpf_reset_reg_init(struct iecm_reset_reg *reset_reg)
+{
+	reset_reg->rstat = PFGEN_RSTAT;
+	reset_reg->rstat_m = PFGEN_RSTAT_PFR_STATE_M;
+}
+
+/**
+ * idpf_trigger_reset - trigger reset
+ * @adapter: Driver specific private structure
+ * @trig_cause: Reason to trigger a reset
+ */
+void idpf_trigger_reset(struct iecm_adapter *adapter,
+			enum iecm_flags trig_cause)
+{
+	u32 reset_reg;
+
+	reset_reg = rd32(&adapter->hw, PFGEN_CTRL);
+	wr32(&adapter->hw, PFGEN_CTRL, (reset_reg | PFGEN_CTRL_PFSWR));
+}
-- 
2.26.2

