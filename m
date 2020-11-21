Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100242BBCD4
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 05:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgKUECX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 23:02:23 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34972 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbgKUECW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 23:02:22 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AL42KcR014557;
        Fri, 20 Nov 2020 20:02:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=CWZB6uSGlb1xnaXuJpCulG7xmsFg++yfRJMQhJP4ywc=;
 b=XFSn4fMWab7ahkczrK1E1r/lZx2tKeg0At65rQCyEx0PhrgGmu2d/I4m3c8265QUAgqL
 KyJqOz1+VIu16oA5lNh9GhMl/m3vIEk5gGYfTl00BhZV4VwNDpXnrTfaG+FlRMdtOmUI
 Z3FoIC8ZGfuPx9x+Sk/3xqIW4FmryGEHBBEo8Y3XPNZqISNQZBIFZC3g4ihyKFp1fwxb
 ZFHcNlQnBY/rzHmNNOY1XAZF8VTimBR/x14QemA481OHe27XMV8d4AuB48S0HZ2/iAmS
 L4xDEfUvpsB4wMl2WeJURr0NdpJkObco2WeNXmJmTqC9iZw5F6KNaktAMnzqsKeQYy4W nQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34xbeyk2p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 20:02:20 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Nov
 2020 20:02:19 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Nov
 2020 20:02:18 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 20 Nov 2020 20:02:18 -0800
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 26F903F7040;
        Fri, 20 Nov 2020 20:02:11 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <george.cherian@marvell.com>,
        <willemdebruijn.kernel@gmail.com>, <saeed@kernel.org>
Subject: [PATCHv4 net-next 1/3] octeontx2-af: Add devlink suppoort to af driver
Date:   Sat, 21 Nov 2020 09:31:59 +0530
Message-ID: <20201121040201.3171542-2-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201121040201.3171542-1-george.cherian@marvell.com>
References: <20201121040201.3171542-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-21_02:2020-11-20,2020-11-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink support to AF driver. Basic devlink support is added.
Currently info_get is the only supported devlink ops.

devlink ouptput looks like this
 # devlink dev
 pci/0002:01:00.0
 # devlink dev info
 pci/0002:01:00.0:
  driver octeontx2-af
  versions:
      fixed:
        mbox version: 9

Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/Kconfig    |  1 +
 .../ethernet/marvell/octeontx2/af/Makefile    |  2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  9 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  4 ++
 .../marvell/octeontx2/af/rvu_devlink.c        | 72 +++++++++++++++++++
 .../marvell/octeontx2/af/rvu_devlink.h        | 20 ++++++
 6 files changed, 106 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
index 543a1d047567..16caa02095fe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -9,6 +9,7 @@ config OCTEONTX2_MBOX
 config OCTEONTX2_AF
 	tristate "Marvell OcteonTX2 RVU Admin Function driver"
 	select OCTEONTX2_MBOX
+	select NET_DEVLINK
 	depends on (64BIT && COMPILE_TEST) || ARM64
 	depends on PCI
 	help
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 7100d1dd856e..eb535c98ca38 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -10,4 +10,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 octeontx2_mbox-y := mbox.o rvu_trace.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
 		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o \
-		  rvu_cpt.o
+		  rvu_cpt.o rvu_devlink.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 9f901c0edcbb..e8fd712860a1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2826,17 +2826,23 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_flr;
 
+	err = rvu_register_dl(rvu);
+	if (err)
+		goto err_irq;
+
 	rvu_setup_rvum_blk_revid(rvu);
 
 	/* Enable AF's VFs (if any) */
 	err = rvu_enable_sriov(rvu);
 	if (err)
-		goto err_irq;
+		goto err_dl;
 
 	/* Initialize debugfs */
 	rvu_dbg_init(rvu);
 
 	return 0;
+err_dl:
+	rvu_unregister_dl(rvu);
 err_irq:
 	rvu_unregister_interrupts(rvu);
 err_flr:
@@ -2868,6 +2874,7 @@ static void rvu_remove(struct pci_dev *pdev)
 
 	rvu_dbg_exit(rvu);
 	rvu_unregister_interrupts(rvu);
+	rvu_unregister_dl(rvu);
 	rvu_flr_wq_destroy(rvu);
 	rvu_cgx_exit(rvu);
 	rvu_fwdata_exit(rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index b6c0977499ab..b1a6ecfd563e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -12,7 +12,10 @@
 #define RVU_H
 
 #include <linux/pci.h>
+#include <net/devlink.h>
+
 #include "rvu_struct.h"
+#include "rvu_devlink.h"
 #include "common.h"
 #include "mbox.h"
 #include "npc.h"
@@ -422,6 +425,7 @@ struct rvu {
 #ifdef CONFIG_DEBUG_FS
 	struct rvu_debugfs	rvu_dbg;
 #endif
+	struct rvu_devlink	*rvu_dl;
 };
 
 static inline void rvu_write64(struct rvu *rvu, u64 block, u64 offset, u64 val)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
new file mode 100644
index 000000000000..04ef945e7e75
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Devlink
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#include "rvu.h"
+
+#define DRV_NAME "octeontx2-af"
+
+static int rvu_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	char buf[10];
+	int err;
+
+	err = devlink_info_driver_name_put(req, DRV_NAME);
+	if (err)
+		return err;
+
+	sprintf(buf, "%X", OTX2_MBOX_VERSION);
+	return devlink_info_version_fixed_put(req, "mbox version:", buf);
+}
+
+static const struct devlink_ops rvu_devlink_ops = {
+	.info_get = rvu_devlink_info_get,
+};
+
+int rvu_register_dl(struct rvu *rvu)
+{
+	struct rvu_devlink *rvu_dl;
+	struct devlink *dl;
+	int err;
+
+	rvu_dl = kzalloc(sizeof(*rvu_dl), GFP_KERNEL);
+	if (!rvu_dl)
+		return -ENOMEM;
+
+	dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink));
+	if (!dl) {
+		dev_warn(rvu->dev, "devlink_alloc failed\n");
+		kfree(rvu_dl);
+		return -ENOMEM;
+	}
+
+	err = devlink_register(dl, rvu->dev);
+	if (err) {
+		dev_err(rvu->dev, "devlink register failed with error %d\n", err);
+		devlink_free(dl);
+		kfree(rvu_dl);
+		return err;
+	}
+
+	rvu_dl->dl = dl;
+	rvu_dl->rvu = rvu;
+	rvu->rvu_dl = rvu_dl;
+	return 0;
+}
+
+void rvu_unregister_dl(struct rvu *rvu)
+{
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	struct devlink *dl = rvu_dl->dl;
+
+	if (!dl)
+		return;
+
+	devlink_unregister(dl);
+	devlink_free(dl);
+	kfree(rvu_dl);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
new file mode 100644
index 000000000000..1ed6dde79a4e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 RVU Devlink
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#ifndef RVU_DEVLINK_H
+#define  RVU_DEVLINK_H
+
+struct rvu_devlink {
+	struct devlink *dl;
+	struct rvu *rvu;
+};
+
+/* Devlink APIs */
+int rvu_register_dl(struct rvu *rvu);
+void rvu_unregister_dl(struct rvu *rvu);
+
+#endif /* RVU_DEVLINK_H */
-- 
2.25.1

