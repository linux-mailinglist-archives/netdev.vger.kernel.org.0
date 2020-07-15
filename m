Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CEE220D09
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbgGOMi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:38:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58262 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726968AbgGOMi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:38:28 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FCVWjp014359;
        Wed, 15 Jul 2020 05:38:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=s6GrHD6rdzcWMkOAXauwjQGMWDxh/BfEd7yL8R0HrcI=;
 b=kACRuX2o3VztVEXhR+L1hS7H9m458pwg8halj+TWFqaKvSiQS0lspHu4bJGY+Y1r+4E5
 CHRUgcSmnJImY6l2p9mZv+sFex9h2tKMZDvQzQVGM3bYqzJM6JwT3af/bGFKzrVYUTGr
 r00DjD65MB7NBpLnO6CRkq484RNj/HYK9K3k9qqwVn8RMlx9J9l+75wP300Rqreyx1Yr
 W+/oJj3X1jEECYushK+58irHqzZGtwz8v9w1+oB0fqxxPyF9zIcjrMXGVamz0KjrD6mz
 uH1Gjev3oWZnHqtBlVvwyHYnsiRLbb6F2mBk2cX1cymxRSzubnseZWVzUUF5QxENVmv0 bA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhtpq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 05:38:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 05:38:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 05:38:20 -0700
Received: from hyd1358.caveonetworks.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 52DAE3F703F;
        Wed, 15 Jul 2020 05:38:18 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        Aleksey Makarov <amakarov@marvell.com>
Subject: [PATCH v4 net-next 2/3] octeontx2-af: Add support for Marvell PTP coprocessor
Date:   Wed, 15 Jul 2020 18:08:08 +0530
Message-ID: <1594816689-5935-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594816689-5935-1-git-send-email-sbhatta@marvell.com>
References: <1594816689-5935-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_11:2020-07-15,2020-07-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksey Makarov <amakarov@marvell.com>

This patch adds driver for Precision Time
Protocol Clock and Timestamping block found on
Octeontx2 platform. The driver does initial
configuration and exposes a function to adjust
PTP hardware clock.

Co-developed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---

v4:
  No changes
v3:
  No changes
v2:
  No changes

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  17 ++
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    | 244 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |  22 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  29 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
 6 files changed, 314 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 1b25948..0bc2410 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 
 octeontx2_mbox-y := mbox.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
-		  rvu_reg.o rvu_npc.o rvu_debugfs.o
+		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index c89b098..4aaef0a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -127,6 +127,7 @@ M(ATTACH_RESOURCES,	0x002, attach_resources, rsrc_attach, msg_rsp)	\
 M(DETACH_RESOURCES,	0x003, detach_resources, rsrc_detach, msg_rsp)	\
 M(MSIX_OFFSET,		0x005, msix_offset, msg_req, msix_offset_rsp)	\
 M(VF_FLR,		0x006, vf_flr, msg_req, msg_rsp)		\
+M(PTP_OP,		0x007, ptp_op, ptp_req, ptp_rsp)		\
 M(GET_HW_CAP,		0x008, get_hw_cap, msg_req, get_hw_cap_rsp)	\
 /* CGX mbox IDs (range 0x200 - 0x3FF) */				\
 M(CGX_START_RXTX,	0x200, cgx_start_rxtx, msg_req, msg_rsp)	\
@@ -862,4 +863,20 @@ struct npc_get_kex_cfg_rsp {
 	u8 mkex_pfl_name[MKEX_NAME_LEN];
 };
 
+enum ptp_op {
+	PTP_OP_ADJFINE = 0,
+	PTP_OP_GET_CLOCK = 1,
+};
+
+struct ptp_req {
+	struct mbox_msghdr hdr;
+	u8 op;
+	s64 scaled_ppm;
+};
+
+struct ptp_rsp {
+	struct mbox_msghdr hdr;
+	u64 clk;
+};
+
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
new file mode 100644
index 0000000..d6d40ca
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell PTP driver */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "ptp.h"
+#include "mbox.h"
+#include "rvu.h"
+
+#define DRV_NAME				"Marvell PTP Driver"
+
+#define PCI_DEVID_OCTEONTX2_PTP			0xA00C
+#define PCI_SUBSYS_DEVID_OCTX2_98xx_PTP		0xB100
+#define PCI_SUBSYS_DEVID_OCTX2_96XX_PTP		0xB200
+#define PCI_SUBSYS_DEVID_OCTX2_95XX_PTP		0xB300
+#define PCI_SUBSYS_DEVID_OCTX2_LOKI_PTP		0xB400
+#define PCI_DEVID_OCTEONTX2_RST			0xA085
+
+#define PCI_PTP_BAR_NO				0
+#define PCI_RST_BAR_NO				0
+
+#define PTP_CLOCK_CFG				0xF00ULL
+#define PTP_CLOCK_CFG_PTP_EN			BIT_ULL(0)
+#define PTP_CLOCK_LO				0xF08ULL
+#define PTP_CLOCK_HI				0xF10ULL
+#define PTP_CLOCK_COMP				0xF18ULL
+
+#define RST_BOOT				0x1600ULL
+#define CLOCK_BASE_RATE				50000000ULL
+
+static u64 get_clock_rate(void)
+{
+	u64 ret = CLOCK_BASE_RATE * 16;
+	struct pci_dev *pdev;
+	void __iomem *base;
+
+	pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
+			      PCI_DEVID_OCTEONTX2_RST, NULL);
+	if (!pdev)
+		goto error;
+
+	base = pci_ioremap_bar(pdev, PCI_RST_BAR_NO);
+	if (!base)
+		goto error_put_pdev;
+
+	ret = CLOCK_BASE_RATE * ((readq(base + RST_BOOT) >> 33) & 0x3f);
+
+	iounmap(base);
+
+error_put_pdev:
+	pci_dev_put(pdev);
+
+error:
+	return ret;
+}
+
+struct ptp *ptp_get(void)
+{
+	struct pci_dev *pdev;
+	struct ptp *ptp;
+
+	pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
+			      PCI_DEVID_OCTEONTX2_PTP, NULL);
+	if (!pdev)
+		return ERR_PTR(-ENODEV);
+
+	ptp = pci_get_drvdata(pdev);
+	if (!ptp)
+		ptp = ERR_PTR(-EPROBE_DEFER);
+	if (IS_ERR(ptp))
+		pci_dev_put(pdev);
+
+	return ptp;
+}
+
+void ptp_put(struct ptp *ptp)
+{
+	if (!ptp)
+		return;
+
+	pci_dev_put(ptp->pdev);
+}
+
+static int ptp_adjfine(struct ptp *ptp, long scaled_ppm)
+{
+	bool neg_adj = false;
+	u64 comp;
+	u64 adj;
+	s64 ppb;
+
+	if (scaled_ppm < 0) {
+		neg_adj = true;
+		scaled_ppm = -scaled_ppm;
+	}
+
+	/* The hardware adds the clock compensation value to the PTP clock
+	 * on every coprocessor clock cycle. Typical convention is that it
+	 * represent number of nanosecond betwen each cycle. In this
+	 * convention compensation value is in 64 bit fixed-point
+	 * representation where upper 32 bits are number of nanoseconds
+	 * and lower is fractions of nanosecond.
+	 * The scaled_ppm represent the ratio in "parts per million" by which
+	 * the compensation value should be corrected.
+	 * To calculate new compenstation value we use 64bit fixed point
+	 * arithmetic on following formula
+	 * comp = tbase + tbase * scaled_ppm / (1M * 2^16)
+	 * where tbase is the basic compensation value calculated
+	 * initialy in the probe function.
+	 */
+	comp = ((u64)1000000000ull << 32) / ptp->clock_rate;
+	/* convert scaled_ppm to ppb */
+	ppb = 1 + scaled_ppm;
+	ppb *= 125;
+	ppb >>= 13;
+	adj = comp * ppb;
+	adj = div_u64(adj, 1000000000ull);
+	comp = neg_adj ? comp - adj : comp + adj;
+
+	writeq(comp, ptp->reg_base + PTP_CLOCK_COMP);
+
+	return 0;
+}
+
+static int ptp_get_clock(struct ptp *ptp, u64 *clk)
+{
+	*clk = readq(ptp->reg_base + PTP_CLOCK_HI);
+
+	return 0;
+}
+
+static int ptp_probe(struct pci_dev *pdev,
+		     const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct ptp *ptp;
+	u64 clock_comp;
+	u64 clock_cfg;
+	int err;
+
+	ptp = devm_kzalloc(dev, sizeof(*ptp), GFP_KERNEL);
+	if (!ptp) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	ptp->pdev = pdev;
+
+	err = pcim_enable_device(pdev);
+	if (err)
+		goto error_free;
+
+	err = pcim_iomap_regions(pdev, 1 << PCI_PTP_BAR_NO, pci_name(pdev));
+	if (err)
+		goto error_free;
+
+	ptp->reg_base = pcim_iomap_table(pdev)[PCI_PTP_BAR_NO];
+
+	ptp->clock_rate = get_clock_rate();
+
+	clock_cfg = readq(ptp->reg_base + PTP_CLOCK_CFG);
+	clock_cfg |= PTP_CLOCK_CFG_PTP_EN;
+	writeq(clock_cfg, ptp->reg_base + PTP_CLOCK_CFG);
+
+	clock_comp = ((u64)1000000000ull << 32) / ptp->clock_rate;
+	writeq(clock_comp, ptp->reg_base + PTP_CLOCK_COMP);
+
+	pci_set_drvdata(pdev, ptp);
+
+	return 0;
+
+error_free:
+	devm_kfree(dev, ptp);
+
+error:
+	/* For `ptp_get()` we need to differentiate between the case
+	 * when the core has not tried to probe this device and the case when
+	 * the probe failed.  In the later case we pretend that the
+	 * initialization was successful and keep the error in
+	 * `dev->driver_data`.
+	 */
+	pci_set_drvdata(pdev, ERR_PTR(err));
+	return 0;
+}
+
+static void ptp_remove(struct pci_dev *pdev)
+{
+	struct ptp *ptp = pci_get_drvdata(pdev);
+	u64 clock_cfg;
+
+	if (IS_ERR_OR_NULL(ptp))
+		return;
+
+	clock_cfg = readq(ptp->reg_base + PTP_CLOCK_CFG);
+	clock_cfg &= ~PTP_CLOCK_CFG_PTP_EN;
+	writeq(clock_cfg, ptp->reg_base + PTP_CLOCK_CFG);
+}
+
+static const struct pci_device_id ptp_id_table[] = {
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_PTP,
+			 PCI_VENDOR_ID_CAVIUM,
+			 PCI_SUBSYS_DEVID_OCTX2_98xx_PTP) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_PTP,
+			 PCI_VENDOR_ID_CAVIUM,
+			 PCI_SUBSYS_DEVID_OCTX2_96XX_PTP) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_PTP,
+			 PCI_VENDOR_ID_CAVIUM,
+			 PCI_SUBSYS_DEVID_OCTX2_95XX_PTP) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_PTP,
+			 PCI_VENDOR_ID_CAVIUM,
+			 PCI_SUBSYS_DEVID_OCTX2_LOKI_PTP) },
+	{ 0, }
+};
+
+struct pci_driver ptp_driver = {
+	.name = DRV_NAME,
+	.id_table = ptp_id_table,
+	.probe = ptp_probe,
+	.remove = ptp_remove,
+};
+
+int rvu_mbox_handler_ptp_op(struct rvu *rvu, struct ptp_req *req,
+			    struct ptp_rsp *rsp)
+{
+	int err = 0;
+
+	if (!rvu->ptp)
+		return -ENODEV;
+
+	switch (req->op) {
+	case PTP_OP_ADJFINE:
+		err = ptp_adjfine(rvu->ptp, req->scaled_ppm);
+		break;
+	case PTP_OP_GET_CLOCK:
+		err = ptp_get_clock(rvu->ptp, &rsp->clk);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	return err;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.h b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
new file mode 100644
index 0000000..a344722
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell PTP driver */
+
+#ifndef PTP_H
+#define PTP_H
+
+#include <linux/timecounter.h>
+#include <linux/time64.h>
+#include <linux/spinlock.h>
+
+struct ptp {
+	struct pci_dev *pdev;
+	void __iomem *reg_base;
+	u32 clock_rate;
+};
+
+struct ptp *ptp_get(void);
+void ptp_put(struct ptp *ptp);
+
+extern struct pci_driver ptp_driver;
+
+#endif
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 557e429..c3ef73a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -18,6 +18,7 @@
 #include "cgx.h"
 #include "rvu.h"
 #include "rvu_reg.h"
+#include "ptp.h"
 
 #define DRV_NAME	"octeontx2-af"
 #define DRV_STRING      "Marvell OcteonTX2 RVU Admin Function Driver"
@@ -2565,13 +2566,21 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_master(pdev);
 
+	rvu->ptp = ptp_get();
+	if (IS_ERR(rvu->ptp)) {
+		err = PTR_ERR(rvu->ptp);
+		if (err == -EPROBE_DEFER)
+			goto err_release_regions;
+		rvu->ptp = NULL;
+	}
+
 	/* Map Admin function CSRs */
 	rvu->afreg_base = pcim_iomap(pdev, PCI_AF_REG_BAR_NUM, 0);
 	rvu->pfreg_base = pcim_iomap(pdev, PCI_PF_REG_BAR_NUM, 0);
 	if (!rvu->afreg_base || !rvu->pfreg_base) {
 		dev_err(dev, "Unable to map admin function CSRs, aborting\n");
 		err = -ENOMEM;
-		goto err_release_regions;
+		goto err_put_ptp;
 	}
 
 	/* Store module params in rvu structure */
@@ -2586,7 +2595,7 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	err = rvu_setup_hw_resources(rvu);
 	if (err)
-		goto err_release_regions;
+		goto err_put_ptp;
 
 	/* Init mailbox btw AF and PFs */
 	err = rvu_mbox_init(rvu, &rvu->afpf_wq_info, TYPE_AFPF,
@@ -2626,6 +2635,8 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rvu_reset_all_blocks(rvu);
 	rvu_free_hw_resources(rvu);
 	rvu_clear_rvum_blk_revid(rvu);
+err_put_ptp:
+	ptp_put(rvu->ptp);
 err_release_regions:
 	pci_release_regions(pdev);
 err_disable_device:
@@ -2651,6 +2662,7 @@ static void rvu_remove(struct pci_dev *pdev)
 	rvu_reset_all_blocks(rvu);
 	rvu_free_hw_resources(rvu);
 	rvu_clear_rvum_blk_revid(rvu);
+	ptp_put(rvu->ptp);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
@@ -2676,9 +2688,19 @@ static int __init rvu_init_module(void)
 	if (err < 0)
 		return err;
 
+	err = pci_register_driver(&ptp_driver);
+	if (err < 0)
+		goto ptp_err;
+
 	err =  pci_register_driver(&rvu_driver);
 	if (err < 0)
-		pci_unregister_driver(&cgx_driver);
+		goto rvu_err;
+
+	return 0;
+rvu_err:
+	pci_unregister_driver(&ptp_driver);
+ptp_err:
+	pci_unregister_driver(&cgx_driver);
 
 	return err;
 }
@@ -2686,6 +2708,7 @@ static int __init rvu_init_module(void)
 static void __exit rvu_cleanup_module(void)
 {
 	pci_unregister_driver(&rvu_driver);
+	pci_unregister_driver(&ptp_driver);
 	pci_unregister_driver(&cgx_driver);
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 62c3ed2..05da7a9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -289,6 +289,8 @@ struct rvu_fwdata {
 	u64 reserved[FWDATA_RESERVED_MEM];
 };
 
+struct ptp;
+
 struct rvu {
 	void __iomem		*afreg_base;
 	void __iomem		*pfreg_base;
@@ -337,6 +339,8 @@ struct rvu {
 	/* Firmware data */
 	struct rvu_fwdata	*fwdata;
 
+	struct ptp		*ptp;
+
 #ifdef CONFIG_DEBUG_FS
 	struct rvu_debugfs	rvu_dbg;
 #endif
-- 
2.7.4

