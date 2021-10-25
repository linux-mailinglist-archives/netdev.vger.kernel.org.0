Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587C3439F4C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhJYTTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:19:14 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43338 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233843AbhJYTRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:17:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PIc3gx001413;
        Mon, 25 Oct 2021 12:15:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=NDrGRip1gWTnxxkhjDTOJWDVc76GDFMC/G2sfLWSA1E=;
 b=QU69mmBvl+PzYLKapVymy42HqE0v85TgpAmWa1JBmacp6X76dPiD5p82lPS0aNtbrMk1
 BiXbITcxYUWZVn8XPW0WorUQlbWqTFBCjfOECC/yBs2LemwImYah6Wk8canwy8O2XU9N
 X2CNXOAOTnxzXR7yZuW1DXzD12XezK7GvPA5cUFjLUxijgpHIwNyaimqODansz9YxMe0
 /qaQzrcI2jhtK+T2pfyY4dKJjwnVww+veadXmQBcnlmPzdVPfaX3ovMhuTxfo1MLjNyg
 j+ySxjdV6hR/lvXR0mfPxBpQh+uAiFJJw0WxnfMwIPJkPCG/l9+a91IDT8yc34HHfiVP uQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bwtjrj8ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 12:15:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 25 Oct
 2021 12:15:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 25 Oct 2021 12:15:12 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id E458F3F704A;
        Mon, 25 Oct 2021 12:15:08 -0700 (PDT)
From:   Rakesh Babu <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
CC:     Harman Kalra <hkalra@marvell.com>,
        Bhaskara Budiredla <bbudiredla@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>
Subject: [net-next PATCH 2/3] octeontx2-af: cn10k: debugfs for dumping lmtst map table
Date:   Tue, 26 Oct 2021 00:44:41 +0530
Message-ID: <20211025191442.10084-3-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211025191442.10084-1-rsaladi2@marvell.com>
References: <20211025191442.10084-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: G-kLkJJrDq4Y8_WdOOe92UUltl2XXzKH
X-Proofpoint-GUID: G-kLkJJrDq4Y8_WdOOe92UUltl2XXzKH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_06,2021-10-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harman Kalra <hkalra@marvell.com>

Implemented a new debugfs entry for dumping lmtst map
table present on CN10K, as this might be very useful to debug any issue
in case of shared lmtst region among multiple pcifuncs.

Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Bhaskara Budiredla <bbudiredla@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        | 94 +++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 54f8fac34215..7ff8f4045223 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -226,6 +226,96 @@ static const struct file_operations rvu_dbg_##name##_fops = { \
 
 static void print_nix_qsize(struct seq_file *filp, struct rvu_pfvf *pfvf);
 
+#define LMT_MAPTBL_ENTRY_SIZE 16
+/* Dump LMTST map table */
+static ssize_t rvu_dbg_lmtst_map_table_display(struct file *filp,
+					       char __user *buffer,
+					       size_t count, loff_t *ppos)
+{
+	struct rvu *rvu = filp->private_data;
+	u64 lmt_addr, val, tbl_base;
+	int pf, vf, num_vfs, hw_vfs;
+	void __iomem *lmt_map_base;
+	int index = 0, off = 0;
+	int bytes_not_copied;
+	int buf_size = 10240;
+	char *buf;
+
+	/* don't allow partial reads */
+	if (*ppos != 0)
+		return 0;
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOSPC;
+
+	tbl_base = rvu_read64(rvu, BLKADDR_APR, APR_AF_LMT_MAP_BASE);
+
+	lmt_map_base = ioremap_wc(tbl_base, 128 * 1024);
+	if (!lmt_map_base) {
+		dev_err(rvu->dev, "Failed to setup lmt map table mapping!!\n");
+		kfree(buf);
+		return false;
+	}
+
+	off +=	scnprintf(&buf[off], buf_size - 1 - off,
+			  "\n\t\t\t\t\tLmtst Map Table Entries");
+	off +=	scnprintf(&buf[off], buf_size - 1 - off,
+			  "\n\t\t\t\t\t=======================");
+	off +=	scnprintf(&buf[off], buf_size - 1 - off, "\nPcifunc\t\t\t");
+	off +=	scnprintf(&buf[off], buf_size - 1 - off, "Table Index\t\t");
+	off +=	scnprintf(&buf[off], buf_size - 1 - off,
+			  "Lmtline Base (word 0)\t\t");
+	off +=	scnprintf(&buf[off], buf_size - 1 - off,
+			  "Lmt Map Entry (word 1)");
+	off += scnprintf(&buf[off], buf_size - 1 - off, "\n");
+	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
+		off += scnprintf(&buf[off], buf_size - 1 - off, "PF%d  \t\t\t",
+				    pf);
+
+		index = pf * rvu->hw->total_vfs * LMT_MAPTBL_ENTRY_SIZE;
+		off += scnprintf(&buf[off], buf_size - 1 - off, " 0x%llx\t\t",
+				 (tbl_base + index));
+		lmt_addr = readq(lmt_map_base + index);
+		off += scnprintf(&buf[off], buf_size - 1 - off,
+				 " 0x%016llx\t\t", lmt_addr);
+		index += 8;
+		val = readq(lmt_map_base + index);
+		off += scnprintf(&buf[off], buf_size - 1 - off, " 0x%016llx\n",
+				 val);
+		/* Reading num of VFs per PF */
+		rvu_get_pf_numvfs(rvu, pf, &num_vfs, &hw_vfs);
+		for (vf = 0; vf < num_vfs; vf++) {
+			index = (pf * rvu->hw->total_vfs * 16) +
+				((vf + 1)  * LMT_MAPTBL_ENTRY_SIZE);
+			off += scnprintf(&buf[off], buf_size - 1 - off,
+					    "PF%d:VF%d  \t\t", pf, vf);
+			off += scnprintf(&buf[off], buf_size - 1 - off,
+					 " 0x%llx\t\t", (tbl_base + index));
+			lmt_addr = readq(lmt_map_base + index);
+			off += scnprintf(&buf[off], buf_size - 1 - off,
+					 " 0x%016llx\t\t", lmt_addr);
+			index += 8;
+			val = readq(lmt_map_base + index);
+			off += scnprintf(&buf[off], buf_size - 1 - off,
+					 " 0x%016llx\n", val);
+		}
+	}
+	off +=	scnprintf(&buf[off], buf_size - 1 - off, "\n");
+
+	bytes_not_copied = copy_to_user(buffer, buf, off);
+	kfree(buf);
+
+	iounmap(lmt_map_base);
+	if (bytes_not_copied)
+		return -EFAULT;
+
+	*ppos = off;
+	return off;
+}
+
+RVU_DEBUG_FOPS(lmtst_map_table, lmtst_map_table_display, NULL);
+
 /* Dumps current provisioning status of all RVU block LFs */
 static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 					  char __user *buffer,
@@ -2672,6 +2762,10 @@ void rvu_dbg_init(struct rvu *rvu)
 	debugfs_create_file("rsrc_alloc", 0444, rvu->rvu_dbg.root, rvu,
 			    &rvu_dbg_rsrc_status_fops);
 
+	if (!is_rvu_otx2(rvu))
+		debugfs_create_file("lmtst_map_table", 0444, rvu->rvu_dbg.root,
+				    rvu, &rvu_dbg_lmtst_map_table_fops);
+
 	if (!cgx_get_cgxcnt_max())
 		goto create;
 
-- 
2.17.1

