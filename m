Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EAE3B6743
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 19:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhF1RJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 13:09:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36780 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232854AbhF1RJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 13:09:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15SH74sv029838;
        Mon, 28 Jun 2021 10:07:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yiFmywgpbQfgLzJohx0jbH6nPpHLpG7vjrNK3oMJEWk=;
 b=MeTQH5t8HFiwWAEeeRNZ1cI9NMhjPy9Eo4Y//iXs2LxIO1oAgcFGpTGVF0E7rWDxA6YC
 qm7DrmiTj2gyND9mWnoQ5iUknfmhNGtLoglzvy8HrX3YZ9XhzSXa93eiM8QZfiVW/sgW
 gdjI99IZx2Of0+wZLlpYiuzdRUIVNro8q5OT2LONStAkqaJxhpaZ/uvWo7flhT11a/7s
 yJD0B8w3N1uh4Sdma9fwK6MNHsS20XskR/huQZZAVLIeEJZlQPc5VTB+zudzZH+5JG/O
 nl/0whgtmD3LWHOQf50VacLj1ASFj0elocXJ25u6ObUND1nLzDWGV0j1YoazRlBONgNb yQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 39f11y3bqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Jun 2021 10:07:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 28 Jun
 2021 10:07:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 28 Jun 2021 10:07:07 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id B993F3F7099;
        Mon, 28 Jun 2021 10:07:03 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net-next 2/3] octeontx2-af: Debugfs support for DMAC filters
Date:   Mon, 28 Jun 2021 22:36:53 +0530
Message-ID: <20210628170654.22995-3-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210628170654.22995-1-hkelam@marvell.com>
References: <20210628170654.22995-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 8Amy_aIEFABTESduInnlyE2NtrH4t6-5
X-Proofpoint-ORIG-GUID: 8Amy_aIEFABTESduInnlyE2NtrH4t6-5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_14:2021-06-25,2021-06-28 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add debugfs support to display CGX/RPM DMAC filter
table associated with pf.

cat /sys/kernel/debug/octeontx2/cgx/cgx0/lmac0/mac_filter

PCI dev       RVUPF  BROADCAST  MULTICAST  FILTER-MODE
0002:02:00.0  PF2    ACCEPT     ACCEPT     UNICAST

DMAC-INDEX  ADDRESS
      0     00:0f:b7:06:17:06
      1     1a:1b:1c:1d:1e:01
      2     1a:1b:1c:1d:1e:02

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 28 ++++++
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  3 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  2 +-
 .../marvell/octeontx2/af/rvu_debugfs.c        | 87 +++++++++++++++++--
 5 files changed, 112 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 5971e85162f1..a5b558fd5b9a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -266,6 +266,34 @@ int cgx_lmac_addr_set(u8 cgx_id, u8 lmac_id, u8 *mac_addr)
 	return 0;
 }
 
+u64 cgx_read_dmac_ctrl(void *cgxd, int lmac_id)
+{
+	struct mac_ops *mac_ops;
+	struct cgx *cgx = cgxd;
+
+	if (!cgxd || !is_lmac_valid(cgxd, lmac_id))
+		return 0;
+
+	cgx = cgxd;
+	/* Get mac_ops to know csr offset */
+	mac_ops = cgx->mac_ops;
+
+	return cgx_read(cgxd, lmac_id, CGXX_CMRX_RX_DMAC_CTL0);
+}
+
+u64 cgx_read_dmac_entry(void *cgxd, int index)
+{
+	struct mac_ops *mac_ops;
+	struct cgx *cgx;
+
+	if (!cgxd)
+		return 0;
+
+	cgx = cgxd;
+	mac_ops = cgx->mac_ops;
+	return cgx_read(cgx, 0, (CGXX_CMRX_RX_DMAC_CAM0 + (index * 8)));
+}
+
 int cgx_lmac_addr_add(u8 cgx_id, u8 lmac_id, u8 *mac_addr)
 {
 	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 0c613f83a41c..237ba2b56210 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -52,6 +52,7 @@
 #define CGX_DMAC_BCAST_MODE		BIT_ULL(0)
 #define CGXX_CMRX_RX_DMAC_CAM0		(0x200 + mac_ops->csr_offset)
 #define CGX_DMAC_CAM_ADDR_ENABLE	BIT_ULL(48)
+#define CGX_DMAC_CAM_ENTRY_LMACID	GENMASK_ULL(50, 49)
 #define CGXX_CMRX_RX_DMAC_CAM1		0x400
 #define CGX_RX_DMAC_ADR_MASK		GENMASK_ULL(47, 0)
 #define CGXX_CMRX_TX_STAT0		0x700
@@ -172,4 +173,6 @@ unsigned long cgx_get_lmac_bmap(void *cgxd);
 void cgx_lmac_write(int cgx_id, int lmac_id, u64 offset, u64 val);
 u64 cgx_lmac_read(int cgx_id, int lmac_id, u64 offset);
 int cgx_lmac_addr_update(u8 cgx_id, u8 lmac_id, u8 *mac_addr, u8 index);
+u64 cgx_read_dmac_ctrl(void *cgxd, int lmac_id);
+u64 cgx_read_dmac_entry(void *cgxd, int index);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 32ce564c3872..8dd1d3b97b18 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -743,6 +743,7 @@ void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature);
 u32  rvu_cgx_get_fifolen(struct rvu *rvu);
 void *rvu_first_cgx_pdata(struct rvu *rvu);
+int cgxlmac_to_pf(struct rvu *rvu, int cgx_id, int lmac_id);
 
 int npc_get_nixlf_mcam_index(struct npc_mcam *mcam, u16 pcifunc, int nixlf,
 			     int type);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 378915f557af..4390ee56f9e3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -63,7 +63,7 @@ static u16 cgxlmac_to_pfmap(struct rvu *rvu, u8 cgx_id, u8 lmac_id)
 	return rvu->cgxlmac2pf_map[CGX_OFFSET(cgx_id) + lmac_id];
 }
 
-static int cgxlmac_to_pf(struct rvu *rvu, int cgx_id, int lmac_id)
+int cgxlmac_to_pf(struct rvu *rvu, int cgx_id, int lmac_id)
 {
 	unsigned long pfmap;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 3cc3c6fd1d84..b55666ba8bfd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1971,10 +1971,9 @@ static int cgx_print_stats(struct seq_file *s, int lmac_id)
 	return err;
 }
 
-static int rvu_dbg_cgx_stat_display(struct seq_file *filp, void *unused)
+static int rvu_dbg_derive_lmacid(struct seq_file *filp, int *lmac_id)
 {
 	struct dentry *current_dir;
-	int err, lmac_id;
 	char *buf;
 
 	current_dir = filp->file->f_path.dentry->d_parent;
@@ -1982,17 +1981,87 @@ static int rvu_dbg_cgx_stat_display(struct seq_file *filp, void *unused)
 	if (!buf)
 		return -EINVAL;
 
-	err = kstrtoint(buf + 1, 10, &lmac_id);
-	if (!err) {
-		err = cgx_print_stats(filp, lmac_id);
-		if (err)
-			return err;
-	}
+	return kstrtoint(buf + 1, 10, lmac_id);
+}
+
+static int rvu_dbg_cgx_stat_display(struct seq_file *filp, void *unused)
+{
+	int lmac_id, err;
+
+	err = rvu_dbg_derive_lmacid(filp, &lmac_id);
+	if (!err)
+		return cgx_print_stats(filp, lmac_id);
+
 	return err;
 }
 
 RVU_DEBUG_SEQ_FOPS(cgx_stat, cgx_stat_display, NULL);
 
+static int cgx_print_dmac_flt(struct seq_file *s, int lmac_id)
+{
+	struct pci_dev *pdev = NULL;
+	void *cgxd = s->private;
+	char *bcast, *mcast;
+	u16 index, domain;
+	u8 dmac[ETH_ALEN];
+	struct rvu *rvu;
+	u64 cfg, mac;
+	int pf;
+
+	rvu = pci_get_drvdata(pci_get_device(PCI_VENDOR_ID_CAVIUM,
+					     PCI_DEVID_OCTEONTX2_RVU_AF, NULL));
+	if (!rvu)
+		return -ENODEV;
+
+	pf = cgxlmac_to_pf(rvu, cgx_get_cgxid(cgxd), lmac_id);
+	domain = 2;
+
+	pdev = pci_get_domain_bus_and_slot(domain, pf + 1, 0);
+	if (!pdev)
+		return 0;
+
+	cfg = cgx_read_dmac_ctrl(cgxd, lmac_id);
+	bcast = cfg & CGX_DMAC_BCAST_MODE ? "ACCEPT" : "REJECT";
+	mcast = cfg & CGX_DMAC_MCAST_MODE ? "ACCEPT" : "REJECT";
+
+	seq_puts(s,
+		 "PCI dev       RVUPF   BROADCAST  MULTICAST  FILTER-MODE\n");
+	seq_printf(s, "%s  PF%d  %9s  %9s",
+		   dev_name(&pdev->dev), pf, bcast, mcast);
+	if (cfg & CGX_DMAC_CAM_ACCEPT)
+		seq_printf(s, "%12s\n\n", "UNICAST");
+	else
+		seq_printf(s, "%16s\n\n", "PROMISCUOUS");
+
+	seq_puts(s, "\nDMAC-INDEX  ADDRESS\n");
+
+	for (index = 0 ; index < 32 ; index++) {
+		cfg = cgx_read_dmac_entry(cgxd, index);
+		/* Display enabled dmac entries associated with current lmac */
+		if (lmac_id == FIELD_GET(CGX_DMAC_CAM_ENTRY_LMACID, cfg) &&
+		    FIELD_GET(CGX_DMAC_CAM_ADDR_ENABLE, cfg)) {
+			mac = FIELD_GET(CGX_RX_DMAC_ADR_MASK, cfg);
+			u64_to_ether_addr(mac, dmac);
+			seq_printf(s, "%7d     %pM\n", index, dmac);
+		}
+	}
+
+	return 0;
+}
+
+static int rvu_dbg_cgx_dmac_flt_display(struct seq_file *filp, void *unused)
+{
+	int err, lmac_id;
+
+	err = rvu_dbg_derive_lmacid(filp, &lmac_id);
+	if (!err)
+		return cgx_print_dmac_flt(filp, lmac_id);
+
+	return err;
+}
+
+RVU_DEBUG_SEQ_FOPS(cgx_dmac_flt, cgx_dmac_flt_display, NULL);
+
 static void rvu_dbg_cgx_init(struct rvu *rvu)
 {
 	struct mac_ops *mac_ops;
@@ -2029,6 +2098,8 @@ static void rvu_dbg_cgx_init(struct rvu *rvu)
 
 			debugfs_create_file("stats", 0600, rvu->rvu_dbg.lmac,
 					    cgx, &rvu_dbg_cgx_stat_fops);
+			debugfs_create_file("mac_filter", 0600, rvu->rvu_dbg.lmac,
+					    cgx, &rvu_dbg_cgx_dmac_flt_fops);
 		}
 	}
 }
-- 
2.17.1

