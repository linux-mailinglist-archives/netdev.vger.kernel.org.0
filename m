Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2453969E6
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhEaW6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:58:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39374 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232363AbhEaW6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:58:43 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VMpnaO002245;
        Mon, 31 May 2021 15:54:52 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnja4pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 15:54:51 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 15:54:49 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 31 May 2021 15:54:46 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>, Arie Gershberg <agershberg@marvell.com>
Subject: [RFC PATCH v7 16/27] qedn: Add qedn - Marvell's NVMeTCP HW offload vendor driver
Date:   Tue, 1 Jun 2021 01:52:11 +0300
Message-ID: <20210531225222.16992-17-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210531225222.16992-1-smalin@marvell.com>
References: <20210531225222.16992-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: wGAdmYDRHT2G9jaFnz6pFInHVu2IpAmv
X-Proofpoint-ORIG-GUID: wGAdmYDRHT2G9jaFnz6pFInHVu2IpAmv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_15:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch will present the skeleton of the qedn driver.
The new driver will be added under "drivers/nvme/hw/qedn" and will be
enabled by the Kconfig "Marvell NVM Express over Fabrics TCP offload".

The internal implementation:
- qedn.h:
  Includes all common structs to be used by the qedn vendor driver.

- qedn_main.c
  Includes the qedn_init and qedn_cleanup implementation.
  As part of the qedn init, the driver will register as a pci device and
  will work with the Marvell fastlinQ NICs.
  As part of the probe, the driver will register to the nvme_tcp_offload
  (ULP).

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Arie Gershberg <agershberg@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 MAINTAINERS                      |  10 ++
 drivers/nvme/Kconfig             |   1 +
 drivers/nvme/Makefile            |   1 +
 drivers/nvme/hw/Kconfig          |   8 ++
 drivers/nvme/hw/Makefile         |   3 +
 drivers/nvme/hw/qedn/Makefile    |   5 +
 drivers/nvme/hw/qedn/qedn.h      |  19 +++
 drivers/nvme/hw/qedn/qedn_main.c | 200 +++++++++++++++++++++++++++++++
 8 files changed, 247 insertions(+)
 create mode 100644 drivers/nvme/hw/Kconfig
 create mode 100644 drivers/nvme/hw/Makefile
 create mode 100644 drivers/nvme/hw/qedn/Makefile
 create mode 100644 drivers/nvme/hw/qedn/qedn.h
 create mode 100644 drivers/nvme/hw/qedn/qedn_main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 64cdffb8aaed..e69c5c3554c5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14908,6 +14908,16 @@ S:	Supported
 F:	drivers/infiniband/hw/qedr/
 F:	include/uapi/rdma/qedr-abi.h
 
+QLOGIC QL4xxx NVME-TCP-OFFLOAD DRIVER
+M:	Shai Malin <smalin@marvell.com>
+M:	Ariel Elior <aelior@marvell.com>
+L:	linux-nvme@lists.infradead.org
+S:	Supported
+W:	http://git.infradead.org/nvme.git
+T:	git://git.infradead.org/nvme.git
+F:	drivers/nvme/hw/qedn/
+F:	include/linux/qed/
+
 QLOGIC QLA1280 SCSI DRIVER
 M:	Michael Reed <mdr@sgi.com>
 L:	linux-scsi@vger.kernel.org
diff --git a/drivers/nvme/Kconfig b/drivers/nvme/Kconfig
index 87ae409a32b9..827c2c9f0ad1 100644
--- a/drivers/nvme/Kconfig
+++ b/drivers/nvme/Kconfig
@@ -3,5 +3,6 @@ menu "NVME Support"
 
 source "drivers/nvme/host/Kconfig"
 source "drivers/nvme/target/Kconfig"
+source "drivers/nvme/hw/Kconfig"
 
 endmenu
diff --git a/drivers/nvme/Makefile b/drivers/nvme/Makefile
index fb42c44609a8..14c569040ef2 100644
--- a/drivers/nvme/Makefile
+++ b/drivers/nvme/Makefile
@@ -2,3 +2,4 @@
 
 obj-y		+= host/
 obj-y		+= target/
+obj-y		+= hw/
\ No newline at end of file
diff --git a/drivers/nvme/hw/Kconfig b/drivers/nvme/hw/Kconfig
new file mode 100644
index 000000000000..374f1f9dbd3d
--- /dev/null
+++ b/drivers/nvme/hw/Kconfig
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config NVME_QEDN
+	tristate "Marvell NVM Express over Fabrics TCP offload"
+	depends on NVME_TCP_OFFLOAD
+	help
+	  This enables the Marvell NVMe TCP offload support (qedn).
+
+	  If unsure, say N.
diff --git a/drivers/nvme/hw/Makefile b/drivers/nvme/hw/Makefile
new file mode 100644
index 000000000000..2f38e0520795
--- /dev/null
+++ b/drivers/nvme/hw/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_NVME_QEDN)		+= qedn/
diff --git a/drivers/nvme/hw/qedn/Makefile b/drivers/nvme/hw/qedn/Makefile
new file mode 100644
index 000000000000..1422cd878680
--- /dev/null
+++ b/drivers/nvme/hw/qedn/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_NVME_QEDN) := qedn.o
+
+qedn-y := qedn_main.o
diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
new file mode 100644
index 000000000000..bcd0748a10fd
--- /dev/null
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+
+#ifndef _QEDN_H_
+#define _QEDN_H_
+
+/* Driver includes */
+#include "../../host/tcp-offload.h"
+
+#define QEDN_MODULE_NAME "qedn"
+
+struct qedn_ctx {
+	struct pci_dev *pdev;
+	struct nvme_tcp_ofld_dev qedn_ofld_dev;
+};
+
+#endif /* _QEDN_H_ */
diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
new file mode 100644
index 000000000000..19b0eab7e9e2
--- /dev/null
+++ b/drivers/nvme/hw/qedn/qedn_main.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+ /* Kernel includes */
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+/* Driver includes */
+#include "qedn.h"
+
+#define CHIP_NUM_AHP_NVMETCP 0x8194
+
+static struct pci_device_id qedn_pci_tbl[] = {
+	{ PCI_VDEVICE(QLOGIC, CHIP_NUM_AHP_NVMETCP), 0 },
+	{0, 0},
+};
+
+static int
+qedn_claim_dev(struct nvme_tcp_ofld_dev *dev,
+	       struct nvme_tcp_ofld_ctrl *ctrl)
+{
+	/* Placeholder - qedn_claim_dev */
+
+	return 0;
+}
+
+static int qedn_setup_ctrl(struct nvme_tcp_ofld_ctrl *ctrl)
+{
+	/* Placeholder - qedn_setup_ctrl */
+
+	return 0;
+}
+
+static int qedn_release_ctrl(struct nvme_tcp_ofld_ctrl *ctrl)
+{
+	/* Placeholder - qedn_release_ctrl */
+
+	return 0;
+}
+
+static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid,
+			     size_t queue_size)
+{
+	/* Placeholder - qedn_create_queue */
+
+	return 0;
+}
+
+static void qedn_drain_queue(struct nvme_tcp_ofld_queue *queue)
+{
+	/* Placeholder - qedn_drain_queue */
+}
+
+static void qedn_destroy_queue(struct nvme_tcp_ofld_queue *queue)
+{
+	/* Placeholder - qedn_destroy_queue */
+}
+
+static int qedn_poll_queue(struct nvme_tcp_ofld_queue *queue)
+{
+	/*
+	 * Poll queue support will be added as part of future
+	 * enhancements.
+	 */
+
+	return 0;
+}
+
+static int qedn_send_req(struct nvme_tcp_ofld_req *req)
+{
+	/* Placeholder - qedn_send_req */
+
+	return 0;
+}
+
+static struct nvme_tcp_ofld_ops qedn_ofld_ops = {
+	.name = "qedn",
+	.module = THIS_MODULE,
+	.required_opts = NVMF_OPT_TRADDR,
+	.allowed_opts = NVMF_OPT_TRSVCID | NVMF_OPT_NR_WRITE_QUEUES |
+			NVMF_OPT_HOST_TRADDR | NVMF_OPT_CTRL_LOSS_TMO |
+			NVMF_OPT_RECONNECT_DELAY,
+		/* These flags will be as part of future enhancements
+		 *	NVMF_OPT_HDR_DIGEST | NVMF_OPT_DATA_DIGEST |
+		 *	NVMF_OPT_NR_POLL_QUEUES | NVMF_OPT_TOS
+		 */
+	.claim_dev = qedn_claim_dev,
+	.setup_ctrl = qedn_setup_ctrl,
+	.release_ctrl = qedn_release_ctrl,
+	.create_queue = qedn_create_queue,
+	.drain_queue = qedn_drain_queue,
+	.destroy_queue = qedn_destroy_queue,
+	.poll_queue = qedn_poll_queue,
+	.send_req = qedn_send_req,
+};
+
+static void __qedn_remove(struct pci_dev *pdev)
+{
+	struct qedn_ctx *qedn = pci_get_drvdata(pdev);
+
+	pr_notice("Starting qedn_remove\n");
+	nvme_tcp_ofld_unregister_dev(&qedn->qedn_ofld_dev);
+	kfree(qedn);
+	pr_notice("Ending qedn_remove successfully\n");
+}
+
+static void qedn_remove(struct pci_dev *pdev)
+{
+	__qedn_remove(pdev);
+}
+
+static void qedn_shutdown(struct pci_dev *pdev)
+{
+	__qedn_remove(pdev);
+}
+
+static struct qedn_ctx *qedn_alloc_ctx(struct pci_dev *pdev)
+{
+	struct qedn_ctx *qedn = NULL;
+
+	qedn = kzalloc(sizeof(*qedn), GFP_KERNEL);
+	if (!qedn)
+		return NULL;
+
+	qedn->pdev = pdev;
+	pci_set_drvdata(pdev, qedn);
+
+	return qedn;
+}
+
+static int __qedn_probe(struct pci_dev *pdev)
+{
+	struct qedn_ctx *qedn;
+	int rc;
+
+	pr_notice("Starting qedn probe\n");
+
+	qedn = qedn_alloc_ctx(pdev);
+	if (!qedn)
+		return -ENODEV;
+
+	qedn->qedn_ofld_dev.ops = &qedn_ofld_ops;
+	INIT_LIST_HEAD(&qedn->qedn_ofld_dev.entry);
+	rc = nvme_tcp_ofld_register_dev(&qedn->qedn_ofld_dev);
+	if (rc)
+		goto release_qedn;
+
+	return 0;
+release_qedn:
+	kfree(qedn);
+
+	return rc;
+}
+
+static int qedn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	return __qedn_probe(pdev);
+}
+
+static struct pci_driver qedn_pci_driver = {
+	.name     = QEDN_MODULE_NAME,
+	.id_table = qedn_pci_tbl,
+	.probe    = qedn_probe,
+	.remove   = qedn_remove,
+	.shutdown = qedn_shutdown,
+};
+
+static int __init qedn_init(void)
+{
+	int rc;
+
+	rc = pci_register_driver(&qedn_pci_driver);
+	if (rc) {
+		pr_err("Failed to register pci driver\n");
+
+		return -EINVAL;
+	}
+
+	pr_notice("driver loaded successfully\n");
+
+	return 0;
+}
+
+static void __exit qedn_cleanup(void)
+{
+	pci_unregister_driver(&qedn_pci_driver);
+	pr_notice("Unloading qedn ended\n");
+}
+
+module_init(qedn_init);
+module_exit(qedn_cleanup);
+
+MODULE_LICENSE("GPL v2");
+MODULE_SOFTDEP("pre: qede nvme-fabrics nvme-tcp-offload");
+MODULE_DESCRIPTION("Marvell 25/50/100G NVMe-TCP Offload Host Driver");
+MODULE_AUTHOR("Marvell");
-- 
2.22.0

