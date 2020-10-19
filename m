Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290B0292689
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgJSLm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:42:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50056 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726087AbgJSLm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:42:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09JBaPmT008252;
        Mon, 19 Oct 2020 04:42:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=OPRFMj9GqO9uy58V7Ct8SkGhVtaafxi5zhFRuBXX0mo=;
 b=RCQIskLH8N37G7cGMG6b6V4CfRqQLOOGcjhPm6LHL5GHYL5lyiBltI/KVC8gxav75cU/
 hzjwnrEqIK3di+6x0yzeuqukmNazftRvkCahinaOxrKFDVpfVuGqFyYVnMIzFcSdVJDk
 I2ryAFB9kz1zqqpy63dqMbQ3gAGIBXIKhkAS+Jmw9/Yuzr7hMTFjIeQxz+IK4mk4m/4r
 psmafbKghwHNmXeZmkV7xueYhEyfndEiGJ9OkY/cky+v3zSjTOvvWp37vHMo+hWUXkfR
 02kfK4Hku//vCbdxcxx8skLwzC2UqEjh0tkM1larpnZYL724YbqyWae+hicr9tzgNwsC xQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 347wyq52fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Oct 2020 04:42:24 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Oct
 2020 04:42:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Oct
 2020 04:42:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 19 Oct 2020 04:42:23 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 578733F703F;
        Mon, 19 Oct 2020 04:42:19 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v8,net-next,03/12] octeontx2-af: add debugfs entries for CPT block
Date:   Mon, 19 Oct 2020 17:11:48 +0530
Message-ID: <20201019114157.4347-4-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019114157.4347-1-schalla@marvell.com>
References: <20201019114157.4347-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-19_05:2020-10-16,2020-10-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add entries to debugfs at /sys/kernel/debug/octeontx2/cpt.

cpt_pc: dump cpt performance HW registers.
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_pc

cpt_ae_sts: show cpt asymmetric engines current state
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_ae_sts

cpt_se_sts: show cpt symmetric engines current state
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_se_sts

cpt_engines_info: dump cpt engine control registers.
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_engines_info

cpt_lfs_info: dump cpt lfs control registers.
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_lfs_info

cpt_err_info: dump cpt error registers.
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_err_info

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   1 +
 .../marvell/octeontx2/af/rvu_debugfs.c        | 304 ++++++++++++++++++
 2 files changed, 305 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index c37e106d7006..ba18171c87d6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -50,6 +50,7 @@ struct rvu_debugfs {
 	struct dentry *npa;
 	struct dentry *nix;
 	struct dentry *npc;
+	struct dentry *cpt;
 	struct dump_ctx npa_aura_ctx;
 	struct dump_ctx npa_pool_ctx;
 	struct dump_ctx nix_cq_ctx;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 77adad4adb1b..24354bfb4e94 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1676,6 +1676,309 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
 	debugfs_remove_recursive(rvu->rvu_dbg.npc);
 }
 
+/* CPT debugfs APIs */
+static int rvu_dbg_cpt_ae_sts_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	u64 busy_sts = 0, free_sts = 0;
+	u32 e_min = 0, e_max = 0, e, i;
+	u16 max_ses, max_ies, max_aes;
+	int blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
+	max_ses = reg & 0xffff;
+	max_ies = (reg >> 16) & 0xffff;
+	max_aes = (reg >> 32) & 0xffff;
+
+	e_min = max_ses + max_ies;
+	e_max = max_ses + max_ies + max_aes;
+
+	for (e = e_min, i = 0; e < e_max; e++, i++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e));
+		if (reg & 0x1)
+			busy_sts |= 1ULL << i;
+
+		if (reg & 0x2)
+			free_sts |= 1ULL << i;
+	}
+	seq_printf(filp, "FREE STS : 0x%016llx\n", free_sts);
+	seq_printf(filp, "BUSY STS : 0x%016llx\n", busy_sts);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_ae_sts, cpt_ae_sts_display, NULL);
+
+static int rvu_dbg_cpt_se_sts_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	u64 busy_sts = 0, free_sts = 0;
+	u32 e_min = 0, e_max = 0, e;
+	u16 max_ses;
+	int blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
+	max_ses = reg & 0xffff;
+
+	e_min = 0;
+	e_max = max_ses;
+
+	for (e = e_min; e < e_max; e++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e));
+		if (reg & 0x1)
+			busy_sts |= 1ULL << e;
+
+		if (reg & 0x2)
+			free_sts |= 1ULL << e;
+	}
+	seq_printf(filp, "FREE STS : 0x%016llx\n", free_sts);
+	seq_printf(filp, "BUSY STS : 0x%016llx\n", busy_sts);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_se_sts, cpt_se_sts_display, NULL);
+
+static int rvu_dbg_cpt_ie_sts_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	u64 busy_sts = 0, free_sts = 0;
+	u32 e_min = 0, e_max = 0, e, i;
+	u16 max_ses, max_ies;
+	int blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
+	max_ses = reg & 0xffff;
+	max_ies = (reg >> 16) & 0xffff;
+
+	e_min = max_ses;
+	e_max = max_ses + max_ies;
+
+	for (e = e_min, i = 0; e < e_max; e++, i++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e));
+		if (reg & 0x1)
+			busy_sts |= 1ULL << i;
+
+		if (reg & 0x2)
+			free_sts |= 1ULL << i;
+	}
+	seq_printf(filp, "FREE STS : 0x%016llx\n", free_sts);
+	seq_printf(filp, "BUSY STS : 0x%016llx\n", busy_sts);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_ie_sts, cpt_ie_sts_display, NULL);
+
+static int rvu_dbg_cpt_engines_info_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	u16 max_ses, max_ies, max_aes;
+	u32 e_max, e;
+	int blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
+	max_ses = reg & 0xffff;
+	max_ies = (reg >> 16) & 0xffff;
+	max_aes = (reg >> 32) & 0xffff;
+
+	e_max = max_ses + max_ies + max_aes;
+
+	seq_puts(filp, "===========================================\n");
+	for (e = 0; e < e_max; e++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL2(e));
+		seq_printf(filp, "CPT Engine[%u] Group Enable   0x%02llx\n", e,
+			   reg & 0xff);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_ACTIVE(e));
+		seq_printf(filp, "CPT Engine[%u] Active Info    0x%llx\n", e,
+			   reg);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL(e));
+		seq_printf(filp, "CPT Engine[%u] Control        0x%llx\n", e,
+			   reg);
+		seq_puts(filp, "===========================================\n");
+	}
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_engines_info, cpt_engines_info_display, NULL);
+
+static int rvu_dbg_cpt_lfs_info_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int blkaddr;
+	u64 reg;
+	u32 lf;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	block = &hw->block[blkaddr];
+	if (!block->lf.bmap)
+		return -ENODEV;
+
+	seq_puts(filp, "===========================================\n");
+	for (lf = 0; lf < block->lf.max; lf++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(lf));
+		seq_printf(filp, "CPT Lf[%u] CTL          0x%llx\n", lf, reg);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL2(lf));
+		seq_printf(filp, "CPT Lf[%u] CTL2         0x%llx\n", lf, reg);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_PTR_CTL(lf));
+		seq_printf(filp, "CPT Lf[%u] PTR_CTL      0x%llx\n", lf, reg);
+		reg = rvu_read64(rvu, blkaddr, block->lfcfg_reg |
+				(lf << block->lfshift));
+		seq_printf(filp, "CPT Lf[%u] CFG          0x%llx\n", lf, reg);
+		seq_puts(filp, "===========================================\n");
+	}
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_lfs_info, cpt_lfs_info_display, NULL);
+
+static int rvu_dbg_cpt_err_info_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	u64 reg0, reg1;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(0));
+	reg1 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(1));
+	seq_printf(filp, "CPT_AF_FLTX_INT:       0x%llx 0x%llx\n", reg0, reg1);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_EXE(0));
+	reg1 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_EXE(1));
+	seq_printf(filp, "CPT_AF_PSNX_EXE:       0x%llx 0x%llx\n", reg0, reg1);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_LF(0));
+	seq_printf(filp, "CPT_AF_PSNX_LF:        0x%llx\n", reg0);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_RVU_INT);
+	seq_printf(filp, "CPT_AF_RVU_INT:        0x%llx\n", reg0);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_RAS_INT);
+	seq_printf(filp, "CPT_AF_RAS_INT:        0x%llx\n", reg0);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_EXE_ERR_INFO);
+	seq_printf(filp, "CPT_AF_EXE_ERR_INFO:   0x%llx\n", reg0);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_err_info, cpt_err_info_display, NULL);
+
+static int rvu_dbg_cpt_pc_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu;
+	int blkaddr;
+	u64 reg;
+
+	rvu = filp->private;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_REQ_PC);
+	seq_printf(filp, "CPT instruction requests   %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_LATENCY_PC);
+	seq_printf(filp, "CPT instruction latency    %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_REQ_PC);
+	seq_printf(filp, "CPT NCB read requests      %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_LATENCY_PC);
+	seq_printf(filp, "CPT NCB read latency       %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_UC_PC);
+	seq_printf(filp, "CPT read requests caused by UC fills   %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_ACTIVE_CYCLES_PC);
+	seq_printf(filp, "CPT active cycles pc       %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CPTCLK_CNT);
+	seq_printf(filp, "CPT clock count pc         %llu\n", reg);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_pc, cpt_pc_display, NULL);
+
+static void rvu_dbg_cpt_init(struct rvu *rvu)
+{
+	const struct device *dev = &rvu->pdev->dev;
+	struct dentry *pfile;
+
+	if (!is_block_implemented(rvu->hw, BLKADDR_CPT0))
+		return;
+
+	rvu->rvu_dbg.cpt = debugfs_create_dir("cpt", rvu->rvu_dbg.root);
+	if (!rvu->rvu_dbg.cpt)
+		return;
+
+	pfile = debugfs_create_file("cpt_pc", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_pc_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_ae_sts", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_ae_sts_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_se_sts", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_se_sts_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_ie_sts", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_ie_sts_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_engines_info", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_engines_info_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_lfs_info", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_lfs_info_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_err_info", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_err_info_fops);
+	if (!pfile)
+		goto create_failed;
+
+	return;
+
+create_failed:
+	dev_err(dev, "Failed to create debugfs dir/file for CPT\n");
+	debugfs_remove_recursive(rvu->rvu_dbg.cpt);
+}
+
 void rvu_dbg_init(struct rvu *rvu)
 {
 	struct device *dev = &rvu->pdev->dev;
@@ -1695,6 +1998,7 @@ void rvu_dbg_init(struct rvu *rvu)
 	rvu_dbg_nix_init(rvu);
 	rvu_dbg_cgx_init(rvu);
 	rvu_dbg_npc_init(rvu);
+	rvu_dbg_cpt_init(rvu);
 
 	return;
 
-- 
2.28.0

