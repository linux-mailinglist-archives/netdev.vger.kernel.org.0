Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3362A23E5
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 06:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgKBFHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 00:07:03 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19304 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727846AbgKBFHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 00:07:03 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A255Xuc013108;
        Sun, 1 Nov 2020 21:06:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=QAloGG6NRznYRTfqP1LsRZ4yD9jjhdKR+g3caPV+8TY=;
 b=bBaBt+xEtTSsWOO7sJod/VkgtT54lDw5Rpnzfc+V8bD31sxu/BsXY5SeaDlC3+nxEwlt
 /RiuEYSZNaJ+zxNrPFfY5cGntek/uZs4pNlO5ZZgkWF1tz3Ntfbrc+ulIoQZNKjNTTBt
 Lvg9iAes1G0IBKs6NTznllxjvJugj3hUWT9WChCb+sRm439r1/oV6qLLQneXXW//jf8m
 zeOl5mhzfBunmAm6piDpInxImDJ9gwYUiKai9KmYwn6Ot7ehKXq7xn82mYkdvEk6drYZ
 0nXhVNeJLLHkR2ymKu6lv9YdJtcWXFLz3/ayt45uTvzaksy96RjBj9803JEfiIi5pHVN 8g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7ennyue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Nov 2020 21:06:59 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 1 Nov
 2020 21:06:58 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 1 Nov
 2020 21:06:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 1 Nov 2020 21:06:58 -0800
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 9BB753F7040;
        Sun,  1 Nov 2020 21:06:54 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <george.cherian@marvell.com>
Subject: [net-next PATCH 1/3] octeontx2-af: Add devlink suppoort to af driver
Date:   Mon, 2 Nov 2020 10:36:47 +0530
Message-ID: <20201102050649.2188434-2-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102050649.2188434-1-george.cherian@marvell.com>
References: <20201102050649.2188434-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_01:2020-10-30,2020-11-02 signatures=0
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
 .../ethernet/marvell/octeontx2/af/Makefile    |  3 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  9 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  5 +-
 .../marvell/octeontx2/af/rvu_devlink.c        | 69 +++++++++++++++++++
 .../marvell/octeontx2/af/rvu_devlink.h        | 20 ++++++
 6 files changed, 104 insertions(+), 3 deletions(-)
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
index 2f7a861d0c7b..20135f1d3387 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 
 octeontx2_mbox-y := mbox.o rvu_trace.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
-		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o
+		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o \
+		  rvu_devlink.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index a28a518c0eae..58c48fa7aa72 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2812,10 +2812,14 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_mbox;
 
-	err = rvu_register_interrupts(rvu);
+	err = rvu_register_dl(rvu);
 	if (err)
 		goto err_flr;
 
+	err = rvu_register_interrupts(rvu);
+	if (err)
+		goto err_dl;
+
 	rvu_setup_rvum_blk_revid(rvu);
 
 	/* Enable AF's VFs (if any) */
@@ -2829,6 +2833,8 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 err_irq:
 	rvu_unregister_interrupts(rvu);
+err_dl:
+	rvu_unregister_dl(rvu);
 err_flr:
 	rvu_flr_wq_destroy(rvu);
 err_mbox:
@@ -2858,6 +2864,7 @@ static void rvu_remove(struct pci_dev *pdev)
 
 	rvu_dbg_exit(rvu);
 	rvu_unregister_interrupts(rvu);
+	rvu_unregister_dl(rvu);
 	rvu_flr_wq_destroy(rvu);
 	rvu_cgx_exit(rvu);
 	rvu_fwdata_exit(rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 5ac9bb12415f..c112b299635d 100644
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
 
@@ -372,10 +375,10 @@ struct rvu {
 	struct npc_kpu_profile_adapter kpu;
 
 	struct ptp		*ptp;
-
 #ifdef CONFIG_DEBUG_FS
 	struct rvu_debugfs	rvu_dbg;
 #endif
+	struct rvu_devlink	*rvu_dl;
 };
 
 static inline void rvu_write64(struct rvu *rvu, u64 block, u64 offset, u64 val)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
new file mode 100644
index 000000000000..c9f5f66e6701
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Devlink
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
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
+		return -ENOMEM;
+	}
+
+	err = devlink_register(dl, rvu->dev);
+	if (err) {
+		dev_err(rvu->dev, "devlink register failed with error %d\n", err);
+		devlink_free(dl);
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
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
new file mode 100644
index 000000000000..b0a0dfeb99c2
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 RVU Devlink
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
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

