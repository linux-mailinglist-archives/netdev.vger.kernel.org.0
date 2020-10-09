Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C4B288CD5
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389341AbgJIPf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:35:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4724 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389332AbgJIPf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:35:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099FUuI1023591;
        Fri, 9 Oct 2020 08:35:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=wzyB3ATDtiR20gXH1wpBmth9NVY3Z5E4KnTOJP3MgzY=;
 b=GVJ93QauOQ7/Ts12KF5EX6unKkN101bR9SjqQMhTpIx2kcxqqAR+V1PIG4OrQIAUuDry
 2wyTPcGC0Sn0XWsrm806/7zHwAb4La7lY9TLwb8Kzda+jMEeBFsHKyKyf/uddYHHqpEW
 yn6S2YFOOimjHdkg+1o78oUyasvBrAeT0zIDj6D+uuyT5/1SybEPDWmUc5Cohhb9TYoB
 9sakR/HSrNIxNh0vDixA9+CAi2JHcl7fgxLBWQAceKgsgdUfrfpGkSHPKxAD8OMOl/09
 M38ET1+To08cJbp2eDE3XBygYXlq3eUQ7eaw2LIpI6LO7VExw97iqrLgGCqntZ0lo8vj hw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3429hh34p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 08:35:19 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:35:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 08:35:18 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id B48C43F7041;
        Fri,  9 Oct 2020 08:35:14 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v4,net-next,03/13] octeontx2-af: add debugfs entries for CPT block
Date:   Fri, 9 Oct 2020 21:04:11 +0530
Message-ID: <20201009153421.30562-4-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009153421.30562-1-schalla@marvell.com>
References: <20201009153421.30562-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_06:2020-10-09,2020-10-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add entries to debugfs at /sys/kernel/debug/octeontx2/cpt.

cpt_pc: dump cpt performance HW registers.
Usage: cat /sys/kernel/debug/octeontx2/cpt/cpt_pc

cpt_engines_sts: show cpt engines current state (busy/free status)
Usage:
echo "AE/SE/IE/all" >  /sys/kernel/debug/octeontx2/cpt/cpt_engines_sts
cat /sys/kernel/debug/octeontx2/cpt/cpt_engines_sts

cpt_engines_info: dump cpt engine control registers.
Usage:
echo "AE/SE/IE/all" >  /sys/kernel/debug/octeontx2/cpt/cpt_engines_info
cat /sys/kernel/debug/octeontx2/cpt/cpt_engines_info

cpt_lfs_info: dump cpt lfs control registers.
Usage:
cat /sys/kernel/debug/octeontx2/cpt/cpt_lfs_info

cpt_err_info: dump cpt error registers.
Usage:
/sys/kernel/debug/octeontx2/cpt/cpt_err_info

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   6 +
 .../marvell/octeontx2/af/rvu_debugfs.c        | 342 ++++++++++++++++++
 2 files changed, 348 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index c17a1938d540..b47ceb295bff 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -42,6 +42,10 @@ struct dump_ctx {
 	bool	all;
 };
 
+struct cpt_dump_ctx {
+	char e_type[NAME_SIZE];
+};
+
 struct rvu_debugfs {
 	struct dentry *root;
 	struct dentry *cgx_root;
@@ -50,11 +54,13 @@ struct rvu_debugfs {
 	struct dentry *npa;
 	struct dentry *nix;
 	struct dentry *npc;
+	struct dentry *cpt;
 	struct dump_ctx npa_aura_ctx;
 	struct dump_ctx npa_pool_ctx;
 	struct dump_ctx nix_cq_ctx;
 	struct dump_ctx nix_rq_ctx;
 	struct dump_ctx nix_sq_ctx;
+	struct cpt_dump_ctx cpt_ctx;
 	int npa_qsize_id;
 	int nix_qsize_id;
 };
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 77adad4adb1b..9dbfcb7e1640 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1676,6 +1676,347 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
 	debugfs_remove_recursive(rvu->rvu_dbg.npc);
 }
 
+/* CPT debugfs APIs */
+static int parse_cpt_cmd_buffer(char *cmd_buf, size_t *count,
+				const char __user *buffer, char *e_type)
+{
+	int  bytes_not_copied;
+	char *cmd_buf_tmp;
+	char *subtoken;
+
+	bytes_not_copied = copy_from_user(cmd_buf, buffer, *count);
+	if (bytes_not_copied)
+		return -EFAULT;
+
+	cmd_buf[*count] = '\0';
+	cmd_buf_tmp = strchr(cmd_buf, '\n');
+
+	if (cmd_buf_tmp) {
+		*cmd_buf_tmp = '\0';
+		*count = cmd_buf_tmp - cmd_buf + 1;
+	}
+
+	subtoken = strsep(&cmd_buf, " ");
+	if (subtoken)
+		strcpy(e_type, subtoken);
+	else
+		return -EINVAL;
+
+	if (cmd_buf)
+		return -EINVAL;
+
+	if (strcmp(e_type, "SE") && strcmp(e_type, "IE") &&
+	    strcmp(e_type, "AE") && strcmp(e_type, "all"))
+		return -EINVAL;
+
+	return 0;
+}
+
+static ssize_t rvu_dbg_cpt_cmd_parser(struct file *filp,
+				      const char __user *buffer, size_t count,
+				      loff_t *ppos)
+{
+	struct seq_file *s = filp->private_data;
+	struct rvu *rvu = s->private;
+	char *cmd_buf;
+	int ret = 0;
+
+	if ((*ppos != 0) || !count)
+		return -EINVAL;
+
+	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
+	if (!cmd_buf)
+		return -ENOSPC;
+
+	if (parse_cpt_cmd_buffer(cmd_buf, &count, buffer,
+				 rvu->rvu_dbg.cpt_ctx.e_type) < 0)
+		ret = -EINVAL;
+
+	kfree(cmd_buf);
+
+	if (ret)
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t rvu_dbg_cpt_engines_sts_write(struct file *filp,
+					     const char __user *buffer,
+					     size_t count, loff_t *ppos)
+{
+	return rvu_dbg_cpt_cmd_parser(filp, buffer, count, ppos);
+}
+
+static int rvu_dbg_cpt_engines_sts_display(struct seq_file *filp, void *unused)
+{
+	u64  busy_sts[2] = {0}, free_sts[2] = {0};
+	struct rvu *rvu = filp->private;
+	u16  max_ses, max_ies, max_aes;
+	u32  e_min = 0, e_max = 0, e;
+	int  blkaddr;
+	char *e_type;
+	u64  reg;
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
+	e_type = rvu->rvu_dbg.cpt_ctx.e_type;
+
+	if (strcmp(e_type, "SE") == 0) {
+		e_min = 0;
+		e_max = max_ses - 1;
+	} else if (strcmp(e_type, "IE") == 0) {
+		e_min = max_ses;
+		e_max = max_ses + max_ies - 1;
+	} else if (strcmp(e_type, "AE") == 0) {
+		e_min = max_ses + max_ies;
+		e_max = max_ses + max_ies + max_aes - 1;
+	} else if (strcmp(e_type, "all") == 0) {
+		e_min = 0;
+		e_max = max_ses + max_ies + max_aes - 1;
+	} else {
+		return -EINVAL;
+	}
+
+	for (e = e_min; e <= e_max; e++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e));
+		if (reg & 0x1) {
+			if (e < max_ses)
+				busy_sts[0] |= 1ULL << e;
+			else if (e >= max_ses)
+				busy_sts[1] |= 1ULL << (e - max_ses);
+		}
+		if (reg & 0x2) {
+			if (e < max_ses)
+				free_sts[0] |= 1ULL << e;
+			else if (e >= max_ses)
+				free_sts[1] |= 1ULL << (e - max_ses);
+		}
+	}
+	seq_printf(filp, "FREE STS : 0x%016llx  0x%016llx\n", free_sts[1],
+		   free_sts[0]);
+	seq_printf(filp, "BUSY STS : 0x%016llx  0x%016llx\n", busy_sts[1],
+		   busy_sts[0]);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_engines_sts, cpt_engines_sts_display,
+		   cpt_engines_sts_write);
+
+static ssize_t rvu_dbg_cpt_engines_info_write(struct file *filp,
+					      const char __user *buffer,
+					      size_t count, loff_t *ppos)
+{
+	return rvu_dbg_cpt_cmd_parser(filp, buffer, count, ppos);
+}
+
+static int rvu_dbg_cpt_engines_info_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	u16  max_ses, max_ies, max_aes;
+	u32  e_min, e_max, e;
+	int  blkaddr;
+	char *e_type;
+	u64  reg;
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
+	e_type = rvu->rvu_dbg.cpt_ctx.e_type;
+
+	if (strcmp(e_type, "SE") == 0) {
+		e_min = 0;
+		e_max = max_ses - 1;
+	} else if (strcmp(e_type, "IE") == 0) {
+		e_min = max_ses;
+		e_max = max_ses + max_ies - 1;
+	} else if (strcmp(e_type, "AE") == 0) {
+		e_min = max_ses + max_ies;
+		e_max = max_ses + max_ies + max_aes - 1;
+	} else if (strcmp(e_type, "all") == 0) {
+		e_min = 0;
+		e_max = max_ses + max_ies + max_aes - 1;
+	} else {
+		return -EINVAL;
+	}
+
+	seq_puts(filp, "===========================================\n");
+	for (e = e_min; e <= e_max; e++) {
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
+RVU_DEBUG_SEQ_FOPS(cpt_engines_info, cpt_engines_info_display,
+		   cpt_engines_info_write);
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
+	pfile = debugfs_create_file("cpt_engines_sts", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_engines_sts_fops);
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
@@ -1695,6 +2036,7 @@ void rvu_dbg_init(struct rvu *rvu)
 	rvu_dbg_nix_init(rvu);
 	rvu_dbg_cgx_init(rvu);
 	rvu_dbg_npc_init(rvu);
+	rvu_dbg_cpt_init(rvu);
 
 	return;
 
-- 
2.28.0

