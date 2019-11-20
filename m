Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A7510427D
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbfKTRtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:49:43 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36338 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728342AbfKTRtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:49:42 -0500
Received: by mail-pg1-f194.google.com with SMTP id k13so92465pgh.3
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4m8cWGldbStMSx8yl46fKAWcw+Qfm+9vgMnFtv1RaR4=;
        b=tg9cwDU7AtMQS9lbvV47YZBjcyMw1fhs1gPYAlWNuqkH9Zx1mbM/B688pkacF56+Iy
         RIG+b5DKCq4wk6DlAgolyp15BrXMkCDoyvcOThIqzcscCsv2gWhwL0g0NGjH5/vHCtmr
         qhpSgDdd3omUvpF6dUJ7yZ8PParzswBaW0qi7l0mp4j2ePt+TyPXoEXwe9Y5MvOQrhcr
         PztKy2vMHXXvDl5G4uEYlhtwfTbSHW+q1Eh7ulDOCQ69/NaRTuXOKQbh3pv5NPPGBEyb
         BuS05PVwkWgkBiiiC2H/ODrmhChDSWsbercLz9qpeTTzxSw/u1dCt5NS/LqylRydXTRf
         9p3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4m8cWGldbStMSx8yl46fKAWcw+Qfm+9vgMnFtv1RaR4=;
        b=QKxbOGWTgbqH6ivncD00mJK5WqqAdlllDsJt3cVBOdjvFSflR6v3MaxFM99UA/Rc5v
         OidPn1AycqVsDWYhnFCYeZ42fJHjRFpC7gNF8ZWnuR25ltDgbkjAFoW55Q/WMaEesvCP
         236pcj5ym7PLqaLGtvE2ld2adCYvlWPnU+XFzsOlGfTxyyWL+Vj0MoP4AhpVz1pR09tV
         iBYwlbuiDcbyb76/hy/89Xszc2PZxpz9EZ4dslwaeKRZGDr1/UWl/P9EBTjW0l53ZFx/
         HusDSLCgQSRTyNu9f6sBwrpKcZKQi+2cUbOIvTcjKPDneg6OzfXR12lhhABT1kOsphLO
         3G6g==
X-Gm-Message-State: APjAAAUO/bcyx+i3+JwzQ8I2rLGxEoHghGCb/XOgIByudrbRRGIkvFog
        /h8OageEZ+TcXJDFFAvnvgtw648W
X-Google-Smtp-Source: APXvYqySwpoyZ4y+Q+BjvYeeBAQnXYrIRp3DHCS1q7ggtIqi0zyaF2HyAeC2cgulvPfGnfCigPOv8g==
X-Received: by 2002:a63:a741:: with SMTP id w1mr4558205pgo.26.1574272180009;
        Wed, 20 Nov 2019 09:49:40 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y24sm32230522pfr.116.2019.11.20.09.49.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 20 Nov 2019 09:49:39 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        Pavan Nikhilesh <pbhagavatula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v3 11/16] octeontx2-af: add debugfs support for sso
Date:   Wed, 20 Nov 2019 23:18:01 +0530
Message-Id: <1574272086-21055-12-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Nikhilesh <pbhagavatula@marvell.com>

Add debugfs for HWGRP performance counter stats, internal queue walks
and few HWS debug registers.

Signed-off-by: Pavan Nikhilesh <pbhagavatula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 699 +++++++++++++++++++++
 2 files changed, 702 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 2216482..fa0f3ca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -50,6 +50,9 @@ struct rvu_debugfs {
 	struct dentry *npa;
 	struct dentry *nix;
 	struct dentry *npc;
+	struct dentry *sso;
+	struct dentry *sso_hwgrp;
+	struct dentry *sso_hws;
 	struct dump_ctx npa_aura_ctx;
 	struct dump_ctx npa_pool_ctx;
 	struct dump_ctx nix_cq_ctx;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 77adad4..524d56d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1676,6 +1676,704 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
 	debugfs_remove_recursive(rvu->rvu_dbg.npc);
 }
 
+static int parse_sso_cmd_buffer(char *cmd_buf, size_t *count,
+				const char __user *buffer, int *ssolf,
+				bool *all)
+{
+	int ret, bytes_not_copied;
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
+	if (subtoken && strcmp(subtoken, "all") == 0) {
+		*all = true;
+	} else {
+		ret = subtoken ? kstrtoint(subtoken, 10, ssolf) : -EINVAL;
+		if (ret < 0)
+			return ret;
+	}
+	if (cmd_buf)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void sso_hwgrp_display_iq_list(struct rvu *rvu, int ssolf, u16 idx,
+				      u16 tail_idx, u8 queue_type)
+{
+	const char *queue[3] = {"DQ", "CQ", "AQ"};
+	int blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return;
+
+	pr_info("SSO HWGGRP[%d] [%s] Chain queue head[%d]", ssolf,
+		queue[queue_type], idx);
+	pr_info("SSO HWGGRP[%d] [%s] Chain queue tail[%d]", ssolf,
+		queue[queue_type], tail_idx);
+	pr_info("--------------------------------------------------\n");
+	do {
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_IENTX_TAG(idx));
+		pr_info("SSO HWGGRP[%d] [%s] IE[%d] TAG      0x%llx\n", ssolf,
+			queue[queue_type], idx, reg);
+
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_IENTX_GRP(idx));
+		pr_info("SSO HWGGRP[%d] [%s] IE[%d] GRP      0x%llx\n", ssolf,
+			queue[queue_type], idx, reg);
+
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_IENTX_PENDTAG(idx));
+		pr_info("SSO HWGGRP[%d] [%s] IE[%d] PENDTAG  0x%llx\n", ssolf,
+			queue[queue_type], idx, reg);
+
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_IENTX_LINKS(idx));
+		pr_info("SSO HWGGRP[%d] [%s] IE[%d] LINKS    0x%llx\n", ssolf,
+			queue[queue_type], idx, reg);
+
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_IENTX_QLINKS(idx));
+		pr_info("SSO HWGGRP[%d] [%s] IE[%d] QLINKS   0x%llx\n", ssolf,
+			queue[queue_type], idx, reg);
+		pr_info("--------------------------------------------------\n");
+		if (idx == tail_idx)
+			break;
+		idx = reg & 0x1FFF;
+	} while (idx != 0x1FFF);
+}
+
+static void sso_hwgrp_display_taq_list(struct rvu *rvu, int ssolf, u8 wae_head,
+				       u16 ent_head, u8 wae_used, u8 taq_lines)
+{
+	int i, blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return;
+
+	pr_info("--------------------------------------------------\n");
+	do {
+		for (i = wae_head; i < taq_lines && wae_used; i++) {
+			reg = rvu_read64(rvu, blkaddr,
+					 SSO_AF_TAQX_WAEY_TAG(ent_head, i));
+			pr_info("SSO HWGGRP[%d] TAQ[%d] WAE[%d] TAG  0x%llx\n",
+				ssolf, ent_head, i, reg);
+
+			reg = rvu_read64(rvu, blkaddr,
+					 SSO_AF_TAQX_WAEY_WQP(ent_head, i));
+			pr_info("SSO HWGGRP[%d] TAQ[%d] WAE[%d] WQP  0x%llx\n",
+				ssolf, ent_head, i, reg);
+			wae_used--;
+		}
+
+		reg = rvu_read64(rvu, blkaddr,
+				 SSO_AF_TAQX_LINK(ent_head));
+		pr_info("SSO HWGGRP[%d] TAQ[%d] LINK         0x%llx\n",
+			ssolf, ent_head, reg);
+		ent_head = reg & 0x7FF;
+		pr_info("--------------------------------------------------\n");
+	} while (ent_head && wae_used);
+}
+
+static int read_sso_pc(struct rvu *rvu)
+{
+	int blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_ACTIVE_CYCLES0);
+	pr_info("SSO Add-Work active cycles		%lld\n", reg);
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_ACTIVE_CYCLES1);
+	pr_info("SSO Get-Work active cycles		%lld\n", reg);
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_ACTIVE_CYCLES2);
+	pr_info("SSO Work-Slot active cycles		%lld\n", reg);
+	pr_info("\n");
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_NOS_CNT) & 0x1FFF;
+	pr_info("SSO work-queue entries on the no-schedule list	%lld\n", reg);
+	pr_info("\n");
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_AW_READ_ARB);
+	pr_info("SSO XAQ reads outstanding		%lld\n",
+		(reg >> 24) & 0x3F);
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_XAQ_REQ_PC);
+	pr_info("SSO XAQ reads requests			%lld\n", reg);
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_XAQ_LATENCY_PC);
+	pr_info("SSO XAQ read latency cycles		%lld\n", reg);
+	pr_info("\n");
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_AW_WE);
+	pr_info("SSO IAQ reserved			%lld\n",
+		(reg >> 16) & 0x3FFF);
+	pr_info("SSO IAQ total				%lld\n", reg & 0x3FFF);
+	pr_info("\n");
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_TAQ_CNT);
+	pr_info("SSO TAQ reserved			%lld\n",
+		(reg >> 16) & 0x7FF);
+	pr_info("SSO TAQ total				%lld\n", reg & 0x7FF);
+	pr_info("\n");
+
+	return 0;
+}
+
+/* Reads SSO hwgrp perfomance counters */
+static void read_sso_hwgrp_pc(struct rvu *rvu, int ssolf, bool all)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int blkaddr, max_id;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return;
+
+	block = &hw->block[blkaddr];
+	if (ssolf < 0 || ssolf >= block->lf.max) {
+		pr_info("Invalid SSOLF(HWGRP), valid range is 0-%d\n",
+			block->lf.max - 1);
+		return;
+	}
+	max_id =  block->lf.max;
+
+	if (all)
+		ssolf = 0;
+	else
+		max_id = ssolf + 1;
+
+	pr_info("==================================================\n");
+	for (; ssolf < max_id; ssolf++) {
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_WS_PC(ssolf));
+		pr_info("SSO HWGGRP[%d] Work-Schedule PC     0x%llx\n", ssolf,
+			reg);
+
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_EXT_PC(ssolf));
+		pr_info("SSO HWGGRP[%d] External Schedule PC 0x%llx\n", ssolf,
+			reg);
+
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_WA_PC(ssolf));
+		pr_info("SSO HWGGRP[%d] Work-Add PC          0x%llx\n", ssolf,
+			reg);
+
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_TS_PC(ssolf));
+		pr_info("SSO HWGGRP[%d] Tag Switch PC        0x%llx\n", ssolf,
+			reg);
+
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_DS_PC(ssolf));
+		pr_info("SSO HWGGRP[%d] Deschedule PC        0x%llx\n", ssolf,
+			reg);
+
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_HWGRPX_DQ_PC(ssolf));
+		pr_info("SSO HWGGRP[%d] Work-Descheduled PC  0x%llx\n", ssolf,
+			reg);
+
+		reg = rvu_read64(rvu, blkaddr,
+				 SSO_AF_HWGRPX_PAGE_CNT(ssolf));
+		pr_info("SSO HWGGRP[%d] In-use Page Count    0x%llx\n", ssolf,
+			reg);
+		pr_info("==================================================\n");
+	}
+}
+
+/* Reads SSO hwgrp Threshold */
+static void read_sso_hwgrp_thresh(struct rvu *rvu, int ssolf, bool all)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int blkaddr, max_id;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return;
+
+	block = &hw->block[blkaddr];
+	if (ssolf < 0 || ssolf >= block->lf.max) {
+		pr_info("Invalid SSOLF(HWGRP), valid range is 0-%d\n",
+			block->lf.max - 1);
+		return;
+	}
+	max_id =  block->lf.max;
+
+	if (all)
+		ssolf = 0;
+	else
+		max_id = ssolf + 1;
+
+	pr_info("==================================================\n");
+	for (; ssolf < max_id; ssolf++) {
+		reg = rvu_read64(rvu, blkaddr,
+				 SSO_AF_HWGRPX_IAQ_THR(ssolf));
+		pr_info("SSO HWGGRP[%d] IAQ Threshold        0x%llx\n", ssolf,
+			reg);
+
+		reg = rvu_read64(rvu, blkaddr,
+				 SSO_AF_HWGRPX_TAQ_THR(ssolf));
+		pr_info("SSO HWGGRP[%d] TAQ Threshold        0x%llx\n", ssolf,
+			reg);
+
+		reg = rvu_read64(rvu, blkaddr,
+				 SSO_AF_HWGRPX_XAQ_AURA(ssolf));
+		pr_info("SSO HWGGRP[%d] XAQ Aura             0x%llx\n", ssolf,
+			reg);
+
+		reg = rvu_read64(rvu, blkaddr,
+				 SSO_AF_HWGRPX_XAQ_LIMIT(ssolf));
+		pr_info("SSO HWGGRP[%d] XAQ Limit            0x%llx\n", ssolf,
+			reg);
+
+		reg = rvu_read64(rvu, blkaddr,
+				 SSO_AF_HWGRPX_IU_ACCNT(ssolf));
+		pr_info("SSO HWGGRP[%d] IU Account Index     0x%llx\n", ssolf,
+			reg);
+
+		reg = rvu_read64(rvu, blkaddr,
+				 SSO_AF_IU_ACCNTX_CFG(reg & 0xFF));
+		pr_info("SSO HWGGRP[%d] IU Accounting Cfg    0x%llx\n", ssolf,
+			reg);
+		pr_info("==================================================\n");
+	}
+}
+
+/* Reads SSO hwgrp TAQ list */
+static void read_sso_hwgrp_taq_list(struct rvu *rvu, int ssolf, bool all)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u8 taq_entries, wae_head;
+	struct rvu_block *block;
+	u16 ent_head, cl_used;
+	int blkaddr, max_id;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return;
+
+	block = &hw->block[blkaddr];
+	if (ssolf < 0 || ssolf >= block->lf.max) {
+		pr_info("Invalid SSOLF(HWGRP), valid range is 0-%d\n",
+			block->lf.max - 1);
+		return;
+	}
+	max_id =  block->lf.max;
+
+	if (all)
+		ssolf = 0;
+	else
+		max_id = ssolf + 1;
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_CONST);
+	taq_entries = (reg >> 48) & 0xFF;
+	pr_info("==================================================\n");
+	for (; ssolf < max_id; ssolf++) {
+		pr_info("++++++++++++++++++++++++++++++++++++++++++++++++++\n");
+		pr_info("SSO HWGGRP[%d] Transitory Output Admission Queue",
+			ssolf);
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_TOAQX_STATUS(ssolf));
+		pr_info("SSO HWGGRP[%d] TOAQ Status          0x%llx\n", ssolf,
+			reg);
+		ent_head = (reg >> 12) & 0x7FF;
+		cl_used = (reg >> 32) & 0x7FF;
+		if (reg & BIT_ULL(61) && cl_used) {
+			pr_info("SSO HWGGRP[%d] TOAQ CL_USED         0x%x\n",
+				ssolf, cl_used);
+			sso_hwgrp_display_taq_list(rvu, ssolf, ent_head, 0,
+						   cl_used * taq_entries,
+						   taq_entries);
+		}
+		pr_info("++++++++++++++++++++++++++++++++++++++++++++++++++\n");
+		pr_info("SSO HWGGRP[%d] Transitory Input Admission Queue",
+			ssolf);
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_TIAQX_STATUS(ssolf));
+		pr_info("SSO HWGGRP[%d] TIAQ Status          0x%llx\n", ssolf,
+			reg);
+		wae_head = (reg >> 60) & 0xF;
+		cl_used = (reg >> 32) & 0x7FFF;
+		ent_head = (reg >> 12) & 0x7FF;
+		if (reg & BIT_ULL(61) && cl_used) {
+			pr_info("SSO HWGGRP[%d] TIAQ WAE_USED         0x%x\n",
+				ssolf, cl_used);
+			sso_hwgrp_display_taq_list(rvu, ssolf, ent_head,
+						   wae_head, cl_used,
+						   taq_entries);
+		}
+		pr_info("++++++++++++++++++++++++++++++++++++++++++++++++++\n");
+		pr_info("==================================================\n");
+	}
+}
+
+/* Reads SSO hwgrp IAQ list */
+static void read_sso_hwgrp_iaq_list(struct rvu *rvu, int ssolf, bool all)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	u16 head_idx, tail_idx;
+	int blkaddr, max_id;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return;
+
+	block = &hw->block[blkaddr];
+	if (ssolf < 0 || ssolf >= block->lf.max) {
+		pr_info("Invalid SSOLF(HWGRP), valid range is 0-%d\n",
+			block->lf.max - 1);
+		return;
+	}
+	max_id =  block->lf.max;
+
+	if (all)
+		ssolf = 0;
+	else
+		max_id = ssolf + 1;
+	pr_info("==================================================\n");
+	for (; ssolf < max_id; ssolf++) {
+		pr_info("++++++++++++++++++++++++++++++++++++++++++++++++++\n");
+		pr_info("SSO HWGGRP[%d] Deschedule Queue(DQ)\n", ssolf);
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_IPL_DESCHEDX(ssolf));
+		pr_info("SSO HWGGRP[%d] DQ List              0x%llx\n", ssolf,
+			reg);
+		head_idx = (reg >> 13) & 0x1FFF;
+		tail_idx = reg & 0x1FFF;
+		if (reg & (BIT_ULL(26) | BIT_ULL(27)))
+			sso_hwgrp_display_iq_list(rvu, ssolf, head_idx,
+						  tail_idx, 0);
+		pr_info("++++++++++++++++++++++++++++++++++++++++++++++++++\n");
+		pr_info("SSO HWGGRP[%d] Conflict Queue(CQ)\n", ssolf);
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_IPL_CONFX(ssolf));
+		pr_info("SSO HWGGRP[%d] CQ List              0x%llx\n", ssolf,
+			reg);
+		head_idx = (reg >> 13) & 0x1FFF;
+		tail_idx = reg & 0x1FFF;
+		if (reg & (BIT_ULL(26) | BIT_ULL(27)))
+			sso_hwgrp_display_iq_list(rvu, ssolf, head_idx,
+						  tail_idx, 1);
+		pr_info("++++++++++++++++++++++++++++++++++++++++++++++++++\n");
+		pr_info("SSO HWGGRP[%d] Admission Queue(AQ)\n", ssolf);
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_IPL_IAQX(ssolf));
+		pr_info("SSO HWGGRP[%d] AQ List              0x%llx\n", ssolf,
+			reg);
+		head_idx = (reg >> 13) & 0x1FFF;
+		tail_idx = reg & 0x1FFF;
+		if (reg & (BIT_ULL(26) | BIT_ULL(27)))
+			sso_hwgrp_display_iq_list(rvu, ssolf, head_idx,
+						  tail_idx, 2);
+		pr_info("++++++++++++++++++++++++++++++++++++++++++++++++++\n");
+		pr_info("==================================================\n");
+	}
+}
+
+/* Reads SSO hwgrp IENT list */
+static int read_sso_hwgrp_ient_list(struct rvu *rvu)
+{
+	const char *tt_c[4] = {"SSO_TT_ORDERED_", "SSO_TT_ATOMIC__",
+				"SSO_TT_UNTAGGED", "SSO_TT_EMPTY___"};
+	struct rvu_hwinfo *hw = rvu->hw;
+	int max_idx = hw->sso.sso_iue;
+	u64 pendtag, qlinks, links;
+	int len, idx, blkaddr;
+	u64 tag, grp, wqp;
+	char str[300];
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	for (idx = 0; idx < max_idx; idx++) {
+		len = 0;
+		tag = rvu_read64(rvu, blkaddr, SSO_AF_IENTX_TAG(idx));
+		grp = rvu_read64(rvu, blkaddr, SSO_AF_IENTX_GRP(idx));
+		pendtag = rvu_read64(rvu, blkaddr,
+				     SSO_AF_IENTX_PENDTAG(idx));
+		links = rvu_read64(rvu, blkaddr, SSO_AF_IENTX_LINKS(idx));
+		qlinks = rvu_read64(rvu, blkaddr,
+				    SSO_AF_IENTX_QLINKS(idx));
+		wqp = rvu_read64(rvu, blkaddr, SSO_AF_IENTX_WQP(idx));
+		len = snprintf(str + len, 300,
+			       "SSO IENT[%4d] TT [%s] HWGRP [%3lld] ", idx,
+				tt_c[(tag >> 32) & 0x3], (grp >> 48) & 0x1f);
+		len += snprintf(str + len, 300 - len,
+				"TAG [0x%010llx] GRP [0x%016llx] ", tag, grp);
+		len += snprintf(str + len, 300 - len, "PENDTAG [0x%010llx] ",
+				pendtag);
+		len += snprintf(str + len, 300 - len,
+				"LINKS [0x%016llx] QLINKS [0x%010llx] ", links,
+				qlinks);
+		snprintf(str + len, 300 - len, "WQP [0x%016llx]\n", wqp);
+		pr_info("%s", str);
+	}
+
+	return 0;
+}
+
+/* Reads SSO hwgrp free list */
+static int read_sso_hwgrp_free_list(struct rvu *rvu)
+{
+	int blkaddr;
+	u64 reg;
+	u8 idx;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	pr_info("==================================================\n");
+	for (idx = 0; idx < 4; idx++) {
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_IPL_FREEX(idx));
+		pr_info("SSO FREE LIST[%d]\n", idx);
+		pr_info("qnum_head : %lld qnum_tail : %lld\n",
+			(reg >> 58) & 0x3, (reg >> 56) & 0x3);
+		pr_info("queue_cnt : %llx\n", (reg >> 26) & 0x7fff);
+		pr_info("queue_val : %lld queue_head : %4lld queue_tail %4lld\n"
+			, (reg >> 40) & 0x1, (reg >> 13) & 0x1fff,
+			reg & 0x1fff);
+		pr_info("==================================================\n");
+	}
+
+	return 0;
+}
+
+/* Reads SSO hwgrp perfomance counters */
+static void read_sso_hws_info(struct rvu *rvu, int ssowlf, bool all)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int blkaddr;
+	int max_id;
+	u64 reg;
+	u8 mask;
+	u8 set;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSOW, 0);
+	if (blkaddr < 0)
+		return;
+
+	block = &hw->block[blkaddr];
+	if (ssowlf < 0 || ssowlf >= block->lf.max) {
+		pr_info("Invalid SSOWLF(HWS), valid range is 0-%d\n",
+			block->lf.max - 1);
+		return;
+	}
+	max_id =  block->lf.max;
+
+	if (all)
+		ssowlf = 0;
+	else
+		max_id = ssowlf + 1;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return;
+
+	pr_info("==================================================\n");
+	for (; ssowlf < max_id; ssowlf++) {
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_HWSX_ARB(ssowlf));
+		pr_info("SSOW HWS[%d] Arbitration State      0x%llx\n", ssowlf,
+			reg);
+		reg = rvu_read64(rvu, blkaddr, SSO_AF_HWSX_GMCTL(ssowlf));
+		pr_info("SSOW HWS[%d] Guest Machine Control  0x%llx\n", ssowlf,
+			reg);
+		for (set = 0; set < 2; set++)
+			for (mask = 0; mask < 4; mask++) {
+				reg = rvu_read64(rvu, blkaddr,
+						 SSO_AF_HWSX_SX_GRPMSKX(ssowlf, set, mask));
+				pr_info("SSOW HWS[%d] SET[%d] Group Mask[%d] 0x%llx\n",
+					ssowlf, set, mask, reg);
+			}
+		pr_info("==================================================\n");
+	}
+}
+
+typedef void (*sso_dump_cb)(struct rvu *rvu, int ssolf, bool all);
+
+static ssize_t rvu_dbg_sso_cmd_parser(struct file *filp,
+				      const char __user *buffer, size_t count,
+				      loff_t *ppos, char *lf_type,
+				      char *file_nm, sso_dump_cb fn)
+{
+	struct rvu *rvu = filp->private_data;
+	bool all = false;
+	char *cmd_buf;
+	int lf = 0;
+
+	if ((*ppos != 0) || !count)
+		return -EINVAL;
+
+	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
+	if (!cmd_buf)
+		return -ENOSPC;
+
+	if (parse_sso_cmd_buffer(cmd_buf, &count, buffer,
+				 &lf, &all) < 0) {
+		pr_info("Usage: echo [<%s>/all] > %s\n", lf_type, file_nm);
+	} else {
+		fn(rvu, lf, all);
+	}
+	kfree(cmd_buf);
+
+	return count;
+}
+
+/* SSO debugfs APIs */
+static ssize_t rvu_dbg_sso_pc_display(struct file *filp,
+				      char __user *buffer,
+				      size_t count, loff_t *ppos)
+{
+	return read_sso_pc(filp->private_data);
+}
+
+static ssize_t rvu_dbg_sso_hwgrp_pc_display(struct file *filp,
+					    const char __user *buffer,
+					    size_t count, loff_t *ppos)
+{
+	return rvu_dbg_sso_cmd_parser(filp, buffer, count, ppos, "hwgrp",
+			"sso_hwgrp_pc", read_sso_hwgrp_pc);
+}
+
+static ssize_t rvu_dbg_sso_hwgrp_thresh_display(struct file *filp,
+						const char __user *buffer,
+						size_t count, loff_t *ppos)
+{
+	return rvu_dbg_sso_cmd_parser(filp, buffer, count, ppos, "hwgrp",
+			"sso_hwgrp_thresh", read_sso_hwgrp_thresh);
+}
+
+static ssize_t rvu_dbg_sso_hwgrp_taq_wlk_display(struct file *filp,
+						 const char __user *buffer,
+						 size_t count, loff_t *ppos)
+{
+	return rvu_dbg_sso_cmd_parser(filp, buffer, count, ppos, "hwgrp",
+			"sso_hwgrp_taq_wlk", read_sso_hwgrp_taq_list);
+}
+
+static ssize_t rvu_dbg_sso_hwgrp_iaq_wlk_display(struct file *filp,
+						 const char __user *buffer,
+						 size_t count, loff_t *ppos)
+{
+	return rvu_dbg_sso_cmd_parser(filp, buffer, count, ppos, "hwgrp",
+			"sso_hwgrp_iaq_wlk", read_sso_hwgrp_iaq_list);
+}
+
+static ssize_t rvu_dbg_sso_hwgrp_ient_wlk_display(struct file *filp,
+						  char __user *buffer,
+						  size_t count, loff_t *ppos)
+{
+	return read_sso_hwgrp_ient_list(filp->private_data);
+}
+
+static ssize_t rvu_dbg_sso_hwgrp_fl_wlk_display(struct file *filp,
+						char __user *buffer,
+						size_t count, loff_t *ppos)
+{
+	return read_sso_hwgrp_free_list(filp->private_data);
+}
+
+static ssize_t rvu_dbg_sso_hws_info_display(struct file *filp,
+					    const char __user *buffer,
+					    size_t count, loff_t *ppos)
+{
+	return rvu_dbg_sso_cmd_parser(filp, buffer, count, ppos, "hws",
+			"sso_hws_info", read_sso_hws_info);
+}
+
+RVU_DEBUG_FOPS(sso_pc, sso_pc_display, NULL);
+RVU_DEBUG_FOPS(sso_hwgrp_pc, NULL, sso_hwgrp_pc_display);
+RVU_DEBUG_FOPS(sso_hwgrp_thresh, NULL, sso_hwgrp_thresh_display);
+RVU_DEBUG_FOPS(sso_hwgrp_taq_wlk, NULL, sso_hwgrp_taq_wlk_display);
+RVU_DEBUG_FOPS(sso_hwgrp_iaq_wlk, NULL, sso_hwgrp_iaq_wlk_display);
+RVU_DEBUG_FOPS(sso_hwgrp_ient_wlk, sso_hwgrp_ient_wlk_display, NULL);
+RVU_DEBUG_FOPS(sso_hwgrp_fl_wlk, sso_hwgrp_fl_wlk_display, NULL);
+RVU_DEBUG_FOPS(sso_hws_info, NULL, sso_hws_info_display);
+
+static void rvu_dbg_sso_init(struct rvu *rvu)
+{
+	const struct device *dev = &rvu->pdev->dev;
+	struct dentry *pfile;
+
+	rvu->rvu_dbg.sso = debugfs_create_dir("sso", rvu->rvu_dbg.root);
+	if (!rvu->rvu_dbg.sso)
+		return;
+
+	rvu->rvu_dbg.sso_hwgrp = debugfs_create_dir("hwgrp", rvu->rvu_dbg.sso);
+	if (!rvu->rvu_dbg.sso_hwgrp)
+		return;
+
+	rvu->rvu_dbg.sso_hws = debugfs_create_dir("hws", rvu->rvu_dbg.sso);
+	if (!rvu->rvu_dbg.sso_hws)
+		return;
+
+	pfile = debugfs_create_file("sso_pc", 0600,
+				    rvu->rvu_dbg.sso, rvu,
+			&rvu_dbg_sso_pc_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("sso_hwgrp_pc", 0600,
+				    rvu->rvu_dbg.sso_hwgrp, rvu,
+			&rvu_dbg_sso_hwgrp_pc_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("sso_hwgrp_thresh", 0600,
+				    rvu->rvu_dbg.sso_hwgrp, rvu,
+			&rvu_dbg_sso_hwgrp_thresh_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("sso_hwgrp_taq_walk", 0600,
+				    rvu->rvu_dbg.sso_hwgrp, rvu,
+			&rvu_dbg_sso_hwgrp_taq_wlk_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("sso_hwgrp_iaq_walk", 0600,
+				    rvu->rvu_dbg.sso_hwgrp, rvu,
+			&rvu_dbg_sso_hwgrp_iaq_wlk_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("sso_hwgrp_ient_walk", 0600,
+				    rvu->rvu_dbg.sso_hwgrp, rvu,
+			&rvu_dbg_sso_hwgrp_ient_wlk_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("sso_hwgrp_free_list_walk", 0600,
+				    rvu->rvu_dbg.sso_hwgrp, rvu,
+			&rvu_dbg_sso_hwgrp_fl_wlk_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("sso_hws_info", 0600,
+				    rvu->rvu_dbg.sso_hws, rvu,
+			&rvu_dbg_sso_hws_info_fops);
+	if (!pfile)
+		goto create_failed;
+
+	return;
+
+create_failed:
+	dev_err(dev, "Failed to create debugfs dir/file for SSO\n");
+	debugfs_remove_recursive(rvu->rvu_dbg.sso);
+}
+
 void rvu_dbg_init(struct rvu *rvu)
 {
 	struct device *dev = &rvu->pdev->dev;
@@ -1695,6 +2393,7 @@ void rvu_dbg_init(struct rvu *rvu)
 	rvu_dbg_nix_init(rvu);
 	rvu_dbg_cgx_init(rvu);
 	rvu_dbg_npc_init(rvu);
+	rvu_dbg_sso_init(rvu);
 
 	return;
 
-- 
2.7.4

