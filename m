Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19B4F7ECB
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbfKKSi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 13:38:58 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35289 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbfKKSi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:38:56 -0500
Received: by mail-pl1-f195.google.com with SMTP id s10so8148755plp.2
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 10:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F0EndsoPU9b+4eYMKoe2V0vT5gGlSwF+OtIWyuplaSU=;
        b=Gc92JcKEltosEAKcKaPmlrjLunt00/WHiADENOrYE+mP/DKvwJQOa+Gwp+XfxE2ox8
         Iaera133lVFWCDpVPMccA3+5QVmKflKvsX3+FTeJLR5pWK+H7Np7TBf1kaXVKoeqEcCp
         U6gA0MEQ9g5dodHL/f5IaIIiZ77eO/+0qqr64RKCzR+2/FiApm7eLtIcv1Oe4x3b2WBk
         kRkv05ySYpDhUZpBmQ3sqxB3h0TohocPz9jJjkcZC6qkeqJdaTwejIkGMSHg9jfqFC8c
         jMyrRWM7t4fMcsChZU0BBCu1QS4qc8tlRprb48jnaxY3HUSPCLOqW1Zh/IytoCG5vwoG
         u07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F0EndsoPU9b+4eYMKoe2V0vT5gGlSwF+OtIWyuplaSU=;
        b=TehIjZV+qVdLyDiSXz73UA9ZCsQPoYlZ1HrH0QQSlouc3WGQ/F/F5UWgRWhJ0cosw1
         bl8AmanY0JlUWL+vR2NMk3rnZo4IDOvIEZdu0x/QIkKFRAPO3fRqSxBfqLaQQadhuEu9
         UDOivUCAl8HL8xrWVtgoOAtmnPRzHzQoO+Ocl5+O4C02Vezd8dOHRy43RxNgI/4bn1+U
         Pib2HLFxuokjxKaZtvrTXDM5GOUUoiCB4dNWLwkQoagXjWyvJwNsyVdVSAQxy8alz8z4
         SuuC9JXDS8isruvP67Jb8ta1qcGo+i0A/WE6096V4bRd0+ZPgjBi0cRW95JrfDCQ6mmV
         1oEw==
X-Gm-Message-State: APjAAAXLjGf25sh7Z9J/svBh88o5SuclaSqWFBPeDLovHBBdwSOIT6U8
        niBINhSpWAgKeaymTGhIh4nYLPsLuwM=
X-Google-Smtp-Source: APXvYqzmPly8UKZn9RAOq6wqM0LjGvs0qE+O7sioFS1zRvoQU5CyJL91veYAtyvkrzK09XIhARsJJw==
X-Received: by 2002:a17:902:9046:: with SMTP id w6mr6740455plz.323.1573497535506;
        Mon, 11 Nov 2019 10:38:55 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id b5sm16921762pfp.149.2019.11.11.10.38.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 10:38:54 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Prakash Brahmajyosyula <bprakash@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 05/18] octeontx2-af: Add CGX LMAC stats to debugfs
Date:   Tue, 12 Nov 2019 00:08:01 +0530
Message-Id: <1573497494-11468-6-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prakash Brahmajyosyula <bprakash@marvell.com>

This patch adds CGX LMAC physical interface or serdes Rx/Tx
packet stats to debugfs.

'cat cgx<idx>/lmac<idx>/stats' dumps the current interface link
status and Rx/Tx stats. Stats include pkt received/transmitted,
dropped, pause frames etc etc.

Signed-off-by: Prakash Brahmajyosyula <bprakash@marvell.com>
Signed-off-by: Linu Cherian <lcherian@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 160 +++++++++++++++++++++
 2 files changed, 163 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 269c43f..2fb871d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -44,6 +44,9 @@ struct dump_ctx {
 
 struct rvu_debugfs {
 	struct dentry *root;
+	struct dentry *cgx_root;
+	struct dentry *cgx;
+	struct dentry *lmac;
 	struct dentry *npa;
 	struct dentry *nix;
 	struct dump_ctx npa_aura_ctx;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 581b611..c01a85e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -18,9 +18,69 @@
 #include "rvu_struct.h"
 #include "rvu_reg.h"
 #include "rvu.h"
+#include "cgx.h"
 
 #define DEBUGFS_DIR_NAME "octeontx2"
 
+enum {
+	CGX_STAT0,
+	CGX_STAT1,
+	CGX_STAT2,
+	CGX_STAT3,
+	CGX_STAT4,
+	CGX_STAT5,
+	CGX_STAT6,
+	CGX_STAT7,
+	CGX_STAT8,
+	CGX_STAT9,
+	CGX_STAT10,
+	CGX_STAT11,
+	CGX_STAT12,
+	CGX_STAT13,
+	CGX_STAT14,
+	CGX_STAT15,
+	CGX_STAT16,
+	CGX_STAT17,
+	CGX_STAT18,
+};
+
+static char *cgx_rx_stats_fields[] = {
+	[CGX_STAT0]	= "Received packets",
+	[CGX_STAT1]	= "Octets of received packets",
+	[CGX_STAT2]	= "Received PAUSE packets",
+	[CGX_STAT3]	= "Received PAUSE and control packets",
+	[CGX_STAT4]	= "Filtered DMAC0 (NIX-bound) packets",
+	[CGX_STAT5]	= "Filtered DMAC0 (NIX-bound) octets",
+	[CGX_STAT6]	= "Packets dropped due to RX FIFO full",
+	[CGX_STAT7]	= "Octets dropped due to RX FIFO full",
+	[CGX_STAT8]	= "Error packets",
+	[CGX_STAT9]	= "Filtered DMAC1 (NCSI-bound) packets",
+	[CGX_STAT10]	= "Filtered DMAC1 (NCSI-bound) octets",
+	[CGX_STAT11]	= "NCSI-bound packets dropped",
+	[CGX_STAT12]	= "NCSI-bound octets dropped",
+};
+
+static char *cgx_tx_stats_fields[] = {
+	[CGX_STAT0]	= "Packets dropped due to excessive collisions",
+	[CGX_STAT1]	= "Packets dropped due to excessive deferral",
+	[CGX_STAT2]	= "Multiple collisions before successful transmission",
+	[CGX_STAT3]	= "Single collisions before successful transmission",
+	[CGX_STAT4]	= "Total octets sent on the interface",
+	[CGX_STAT5]	= "Total frames sent on the interface",
+	[CGX_STAT6]	= "Packets sent with an octet count < 64",
+	[CGX_STAT7]	= "Packets sent with an octet count == 64",
+	[CGX_STAT8]	= "Packets sent with an octet count of 65–127",
+	[CGX_STAT9]	= "Packets sent with an octet count of 128-255",
+	[CGX_STAT10]	= "Packets sent with an octet count of 256-511",
+	[CGX_STAT11]	= "Packets sent with an octet count of 512-1023",
+	[CGX_STAT12]	= "Packets sent with an octet count of 1024-1518",
+	[CGX_STAT13]	= "Packets sent with an octet count of > 1518",
+	[CGX_STAT14]	= "Packets sent to a broadcast DMAC",
+	[CGX_STAT15]	= "Packets sent to the multicast DMAC",
+	[CGX_STAT16]	= "Transmit underflow and were truncated",
+	[CGX_STAT17]	= "Control/PAUSE packets sent",
+};
+
 #define NDC_MAX_BANK(rvu, blk_addr) (rvu_read64(rvu, \
 						blk_addr, NDC_AF_CONST) & 0xFF)
 
@@ -1269,6 +1329,105 @@ static void rvu_dbg_npa_init(struct rvu *rvu)
 	debugfs_remove_recursive(rvu->rvu_dbg.npa);
 }
 
+static int cgx_print_stats(struct seq_file *s, int lmac_id)
+{
+	struct cgx_link_user_info linfo;
+	void *cgxd = s->private;
+	int stat = 0, err = 0;
+	u64 tx_stat, rx_stat;
+
+	/* Link status */
+	seq_puts(s, "\n=======Link Status======\n\n");
+	err = cgx_get_link_info(cgxd, lmac_id, &linfo);
+	if (err)
+		seq_puts(s, "Failed to read link status\n");
+	seq_printf(s, "\nLink is %s %d Mbps\n\n",
+		   linfo.link_up ? "UP" : "DOWN", linfo.speed);
+
+	/* Rx stats */
+	seq_puts(s, "\n=======CGX RX_STATS======\n\n");
+	while (stat < CGX_RX_STATS_COUNT) {
+		err = cgx_get_rx_stats(cgxd, lmac_id, stat, &rx_stat);
+		if (err)
+			return err;
+		seq_printf(s, "%s: %llu\n", cgx_rx_stats_fields[stat], rx_stat);
+		stat++;
+	}
+
+	/* Tx stats */
+	stat = 0;
+	seq_puts(s, "\n=======CGX TX_STATS======\n\n");
+	while (stat < CGX_TX_STATS_COUNT) {
+		err = cgx_get_tx_stats(cgxd, lmac_id, stat, &tx_stat);
+		if (err)
+			return err;
+		seq_printf(s, "%s: %llu\n", cgx_tx_stats_fields[stat], tx_stat);
+		stat++;
+	}
+
+	return err;
+}
+
+static int rvu_dbg_cgx_stat_display(struct seq_file *filp, void *unused)
+{
+	struct dentry *current_dir;
+	int err, lmac_id;
+	char *buf;
+
+	current_dir = filp->file->f_path.dentry->d_parent;
+	buf = strrchr(current_dir->d_name.name, 'c');
+	if (!buf)
+		return -EINVAL;
+
+	err = kstrtoint(buf + 1, 10, &lmac_id);
+	if (!err) {
+		err = cgx_print_stats(filp, lmac_id);
+		if (err)
+			return err;
+	}
+	return err;
+}
+
+RVU_DEBUG_SEQ_FOPS(cgx_stat, cgx_stat_display, NULL);
+
+static void rvu_dbg_cgx_init(struct rvu *rvu)
+{
+	const struct device *dev = &rvu->pdev->dev;
+	struct dentry *pfile;
+	int i, lmac_id;
+	char dname[20];
+	void *cgx;
+
+	rvu->rvu_dbg.cgx_root = debugfs_create_dir("cgx", rvu->rvu_dbg.root);
+
+	for (i = 0; i < cgx_get_cgxcnt_max(); i++) {
+		cgx = rvu_cgx_pdata(i, rvu);
+		if (!cgx)
+			continue;
+		/* cgx debugfs dir */
+		sprintf(dname, "cgx%d", i);
+		rvu->rvu_dbg.cgx = debugfs_create_dir(dname,
+						      rvu->rvu_dbg.cgx_root);
+		for (lmac_id = 0; lmac_id < cgx_get_lmac_cnt(cgx); lmac_id++) {
+			/* lmac debugfs dir */
+			sprintf(dname, "lmac%d", lmac_id);
+			rvu->rvu_dbg.lmac =
+				debugfs_create_dir(dname, rvu->rvu_dbg.cgx);
+
+			pfile =	debugfs_create_file("stats", 0600,
+						    rvu->rvu_dbg.lmac, cgx,
+						    &rvu_dbg_cgx_stat_fops);
+			if (!pfile)
+				goto create_failed;
+		}
+	}
+	return;
+
+create_failed:
+	dev_err(dev, "Failed to create debugfs dir/file for CGX\n");
+	debugfs_remove_recursive(rvu->rvu_dbg.cgx_root);
+}
+
 void rvu_dbg_init(struct rvu *rvu)
 {
 	struct device *dev = &rvu->pdev->dev;
@@ -1286,6 +1445,7 @@ void rvu_dbg_init(struct rvu *rvu)
 
 	rvu_dbg_npa_init(rvu);
 	rvu_dbg_nix_init(rvu);
+	rvu_dbg_cgx_init(rvu);
 
 	return;
 
-- 
2.7.4

