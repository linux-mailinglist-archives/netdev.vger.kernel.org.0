Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7430529E57C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732535AbgJ2H5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgJ2HYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:41 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFCCC0613BD
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:21 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 15so1370436pgd.12
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m5zXeLoi2N7iKfN6ydxuMRT/Ce/9MTpzWH3tE+i1IAE=;
        b=T6tvkMWv795O0vCCdO0wOiy2r3LoyJEpPzWzq4qnN2sC7tKN5w1f6YpbergAC+W+dq
         +8v1cT8Kur0p4nwaqPXNSTPde1dGinba4ngDJ2WMwkNXnaidnP5BeBDgdA8d+NF3HTEf
         RcH8zgHXDtXj/0ytlZwN3B5zd9nFX9eViIVQ01O7sf80tbCRSnrsFh7jY10m3W1AO287
         5+HkB8rWM6YArLiEtNzr2nZytuIaSuhirYWhZvXb8aOuHqW7rCAv/FvxOp6OOdOLQ2ec
         D14agZ3ujpDPd17NA2sQhn5fHomyL83XYW6nBKdPFy5hjxmR/B0S9z8jdcD2jzT5mGPd
         9omg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m5zXeLoi2N7iKfN6ydxuMRT/Ce/9MTpzWH3tE+i1IAE=;
        b=bpXjLg5ZlTNuUf/JwKhf/V1tdeDKIrZ0mkXsNwa0jTlVCorzMrV6mp1dtvz6DGPFNw
         /XX7MTC8wfwNaKY8k2Atq2M195jcD86YCkRfjWn6xQTrkGzaAttvFrde1eoP9CxkjXKG
         zGI+Ta/s1OYZJZAIifnB+FakBNWT1S1IJHWQvdh4WVLHciSLdtfaBI0cdzXjCDid3bB7
         /o925xOX9qpzMaoYgMBYvPX9ly928eJ0nYbIJnG5jXdMpPDRafH6FLFveoGS9T+XUpDo
         E3h6I/VMq7aLL3knXWzvXgnIdhOvFwPLhea6R5xKPGzOMma0qNmgm5uLEx1t1B6LD81X
         Bbog==
X-Gm-Message-State: AOAM531qMtyonLNKHGRwMPPsmmHblosq/MECvxkcDgp3jHKhn6AmwDmz
        pte7kdNN8265kkLnaFtZlL4=
X-Google-Smtp-Source: ABdhPJxWXyOoc5vwxoxU0s3y2d+3zbDOfk5B86FUnUH2jzqfkJEUMb0E28FLSXuVqmVPAAQRVilSFw==
X-Received: by 2002:a62:3815:0:b029:152:80d4:2a6f with SMTP id f21-20020a6238150000b029015280d42a6fmr2686912pfa.72.1603948580541;
        Wed, 28 Oct 2020 22:16:20 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id k7sm1292242pfa.184.2020.10.28.22.16.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Oct 2020 22:16:19 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        netdev@vger.kernel.org
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>
Subject: [v2 net-next PATCH 06/10] octeontx2-af: Add NIX1 interfaces to NPC
Date:   Thu, 29 Oct 2020 10:45:45 +0530
Message-Id: <1603948549-781-7-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
References: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

On 98xx silicon, NPC block has additional
mcam entries, counters and NIX1 interfaces.
Extended set of registers are present for the
new mcam entries and counters.
This patch does the following:
- updates the register accessing macros
  to use extended set if present.
- configures the MKEX profile for NIX1 interfaces also.
- updates mcam entry write functions to use assigned
  NIX0/1 interfaces for the PF/VF.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   8 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   4 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  13 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  10 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 328 +++++++++++++++------
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  79 ++++-
 7 files changed, 337 insertions(+), 107 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index f48eb66..3b7cad5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -174,8 +174,12 @@ enum nix_scheduler {
 #define NPC_MCAM_KEY_X2			1
 #define NPC_MCAM_KEY_X4			2
 
-#define NIX_INTF_RX			0
-#define NIX_INTF_TX			1
+#define NIX_INTFX_RX(a)			(0x0ull | (a) << 1)
+#define NIX_INTFX_TX(a)			(0x1ull | (a) << 1)
+
+/* Default interfaces are NIX0_RX and NIX0_TX */
+#define NIX_INTF_RX			NIX_INTFX_RX(0)
+#define NIX_INTF_TX			NIX_INTFX_TX(0)
 
 #define NIX_INTF_TYPE_CGX		0
 #define NIX_INTF_TYPE_LBK		1
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 77bb4ed..1994486 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -13380,7 +13380,7 @@ static const struct npc_lt_def_cfg npc_lt_defaults = {
 	},
 };
 
-static const struct npc_mcam_kex npc_mkex_default = {
+static struct npc_mcam_kex npc_mkex_default = {
 	.mkex_sign = MKEX_SIGN,
 	.name = "default",
 	.kpu_version = NPC_KPU_PROFILE_VER,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index f2dbc9ae..2a95641 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1276,10 +1276,14 @@ static int rvu_get_nix_blkaddr(struct rvu *rvu, u16 pcifunc)
 	switch (blkaddr) {
 	case BLKADDR_NIX1:
 		pfvf->nix_blkaddr = BLKADDR_NIX1;
+		pfvf->nix_rx_intf = NIX_INTFX_RX(1);
+		pfvf->nix_tx_intf = NIX_INTFX_TX(1);
 		break;
 	case BLKADDR_NIX0:
 	default:
 		pfvf->nix_blkaddr = BLKADDR_NIX0;
+		pfvf->nix_rx_intf = NIX_INTFX_RX(0);
+		pfvf->nix_tx_intf = NIX_INTFX_TX(0);
 		break;
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 5d0815b..5ac9bb1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -186,6 +186,8 @@ struct rvu_pfvf {
 	int	cgx_users;  /* number of cgx users - used only by PFs */
 
 	u8	nix_blkaddr; /* BLKADDR_NIX0/1 assigned to this PF */
+	u8	nix_rx_intf; /* NIX0_RX/NIX1_RX interface to NPC */
+	u8	nix_tx_intf; /* NIX0_TX/NIX1_TX interface to NPC */
 };
 
 struct nix_txsch {
@@ -257,6 +259,11 @@ struct rvu_hwinfo {
 	u8	lbk_links;
 	u8	sdp_links;
 	u8	npc_kpus;          /* No of parser units */
+	u8	npc_pkinds;        /* No of port kinds */
+	u8	npc_intfs;         /* No of interfaces */
+	u8	npc_kpu_entries;   /* No of KPU entries */
+	u16	npc_counters;	   /* No of match stats counters */
+	bool	npc_ext_set;	   /* Extended register set */
 
 	struct hw_cap    cap;
 	struct rvu_block block[BLK_COUNT]; /* Block info */
@@ -307,7 +314,7 @@ struct npc_kpu_profile_adapter {
 	const struct npc_lt_def_cfg	*lt_def;
 	const struct npc_kpu_profile_action	*ikpu; /* array[pkinds] */
 	const struct npc_kpu_profile	*kpu; /* array[kpus] */
-	const struct npc_mcam_kex	*mkex;
+	struct npc_mcam_kex		*mkex;
 	size_t				pkinds;
 	size_t				kpus;
 };
@@ -524,6 +531,10 @@ void rvu_npc_get_mcam_entry_alloc_info(struct rvu *rvu, u16 pcifunc,
 void rvu_npc_get_mcam_counter_alloc_info(struct rvu *rvu, u16 pcifunc,
 					 int blkaddr, int *alloc_cnt,
 					 int *enable_cnt);
+bool is_npc_intf_tx(u8 intf);
+bool is_npc_intf_rx(u8 intf);
+bool is_npc_interface_valid(struct rvu *rvu, u8 intf);
+int rvu_npc_get_tx_nibble_cfg(struct rvu *rvu, u64 nibble_ena);
 
 #ifdef CONFIG_DEBUG_FS
 void rvu_dbg_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 77adad4..7b8cc55 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1565,7 +1565,7 @@ static int rvu_dbg_npc_mcam_info_display(struct seq_file *filp, void *unsued)
 	struct rvu *rvu = filp->private;
 	int pf, vf, numvfs, blkaddr;
 	struct npc_mcam *mcam;
-	u16 pcifunc;
+	u16 pcifunc, counters;
 	u64 cfg;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
@@ -1573,6 +1573,7 @@ static int rvu_dbg_npc_mcam_info_display(struct seq_file *filp, void *unsued)
 		return -ENODEV;
 
 	mcam = &rvu->hw->mcam;
+	counters = rvu->hw->npc_counters;
 
 	seq_puts(filp, "\nNPC MCAM info:\n");
 	/* MCAM keywidth on receive and transmit sides */
@@ -1595,10 +1596,9 @@ static int rvu_dbg_npc_mcam_info_display(struct seq_file *filp, void *unsued)
 	seq_printf(filp, "\t\t Available \t: %d\n", mcam->bmap_fcnt);
 
 	/* MCAM counters */
-	cfg = rvu_read64(rvu, blkaddr, NPC_AF_CONST);
-	cfg = (cfg >> 48) & 0xFFFF;
-	seq_printf(filp, "\n\t\t MCAM counters \t: %lld\n", cfg);
-	seq_printf(filp, "\t\t Reserved \t: %lld\n", cfg - mcam->counters.max);
+	seq_printf(filp, "\n\t\t MCAM counters \t: %d\n", counters);
+	seq_printf(filp, "\t\t Reserved \t: %d\n",
+		   counters - mcam->counters.max);
 	seq_printf(filp, "\t\t Available \t: %d\n",
 		   rvu_rsrc_free_count(&mcam->counters));
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 511b01d..989533a3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -36,6 +36,33 @@ static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
 static void npc_mcam_free_all_counters(struct rvu *rvu, struct npc_mcam *mcam,
 				       u16 pcifunc);
 
+bool is_npc_intf_tx(u8 intf)
+{
+	return !!(intf & 0x1);
+}
+
+bool is_npc_intf_rx(u8 intf)
+{
+	return !(intf & 0x1);
+}
+
+bool is_npc_interface_valid(struct rvu *rvu, u8 intf)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+
+	return intf < hw->npc_intfs;
+}
+
+int rvu_npc_get_tx_nibble_cfg(struct rvu *rvu, u64 nibble_ena)
+{
+	/* Due to a HW issue in these silicon versions, parse nibble enable
+	 * configuration has to be identical for both Rx and Tx interfaces.
+	 */
+	if (is_rvu_96xx_B0(rvu))
+		return nibble_ena;
+	return 0;
+}
+
 void rvu_npc_set_pkind(struct rvu *rvu, int pkind, struct rvu_pfvf *pfvf)
 {
 	int blkaddr;
@@ -94,6 +121,31 @@ int npc_config_ts_kpuaction(struct rvu *rvu, int pf, u16 pcifunc, bool enable)
 	return 0;
 }
 
+static int npc_get_ucast_mcam_index(struct npc_mcam *mcam, u16 pcifunc,
+				    int nixlf)
+{
+	struct rvu_hwinfo *hw = container_of(mcam, struct rvu_hwinfo, mcam);
+	struct rvu *rvu = hw->rvu;
+	int blkaddr = 0, max = 0;
+	struct rvu_block *block;
+	struct rvu_pfvf *pfvf;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	/* Given a PF/VF and NIX LF number calculate the unicast mcam
+	 * entry index based on the NIX block assigned to the PF/VF.
+	 */
+	blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
+	while (blkaddr) {
+		if (pfvf->nix_blkaddr == blkaddr)
+			break;
+		block = &rvu->hw->block[blkaddr];
+		max += block->lf.max;
+		blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
+	}
+
+	return mcam->nixlf_offset + (max + nixlf) * RSVD_MCAM_ENTRIES_PER_NIXLF;
+}
+
 static int npc_get_nixlf_mcam_index(struct npc_mcam *mcam,
 				    u16 pcifunc, int nixlf, int type)
 {
@@ -114,7 +166,7 @@ static int npc_get_nixlf_mcam_index(struct npc_mcam *mcam,
 			return index + 1;
 	}
 
-	return (mcam->nixlf_offset + (nixlf * RSVD_MCAM_ENTRIES_PER_NIXLF));
+	return npc_get_ucast_mcam_index(mcam, pcifunc, nixlf);
 }
 
 static int npc_get_bank(struct npc_mcam *mcam, int index)
@@ -413,7 +465,7 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 
 	entry.action = *(u64 *)&action;
 	npc_config_mcam_entry(rvu, mcam, blkaddr, index,
-			      NIX_INTF_RX, &entry, true);
+			      pfvf->nix_rx_intf, &entry, true);
 
 	/* add VLAN matching, setup action and save entry back for later */
 	entry.kw[0] |= (NPC_LT_LB_STAG_QINQ | NPC_LT_LB_CTAG) << 20;
@@ -430,6 +482,7 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 				   int nixlf, u64 chan, bool allmulti)
 {
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	int blkaddr, ucast_idx, index, kwi;
 	struct mcam_entry entry = { {0} };
@@ -473,7 +526,7 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 
 	entry.action = *(u64 *)&action;
 	npc_config_mcam_entry(rvu, mcam, blkaddr, index,
-			      NIX_INTF_RX, &entry, true);
+			      pfvf->nix_rx_intf, &entry, true);
 }
 
 static void npc_enadis_promisc_entry(struct rvu *rvu, u16 pcifunc,
@@ -531,6 +584,7 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 
 	/* Get 'pcifunc' of PF device */
 	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_BCAST_ENTRY);
 
@@ -553,14 +607,13 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 		action.op = NIX_RX_ACTIONOP_UCAST;
 		action.pf_func = pcifunc;
 	} else {
-		pfvf = rvu_get_pfvf(rvu, pcifunc);
 		action.index = pfvf->bcast_mce_idx;
 		action.op = NIX_RX_ACTIONOP_MCAST;
 	}
 
 	entry.action = *(u64 *)&action;
 	npc_config_mcam_entry(rvu, mcam, blkaddr, index,
-			      NIX_INTF_RX, &entry, true);
+			      pfvf->nix_rx_intf, &entry, true);
 }
 
 void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable)
@@ -732,44 +785,78 @@ void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 	rvu_write64(rvu, blkaddr,			\
 		NPC_AF_INTFX_LDATAX_FLAGSX_CFG(intf, ld, flags), cfg)
 
-static void npc_program_mkex_profile(struct rvu *rvu, int blkaddr,
-				     const struct npc_mcam_kex *mkex)
+static void npc_program_mkex_rx(struct rvu *rvu, int blkaddr,
+				struct npc_mcam_kex *mkex, u8 intf)
 {
 	int lid, lt, ld, fl;
 
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX),
-		    mkex->keyx_cfg[NIX_INTF_RX]);
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_TX),
-		    mkex->keyx_cfg[NIX_INTF_TX]);
+	if (is_npc_intf_tx(intf))
+		return;
 
-	for (ld = 0; ld < NPC_MAX_LD; ld++)
-		rvu_write64(rvu, blkaddr, NPC_AF_KEX_LDATAX_FLAGS_CFG(ld),
-			    mkex->kex_ld_flags[ld]);
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(intf),
+		    mkex->keyx_cfg[NIX_INTF_RX]);
 
+	/* Program LDATA */
 	for (lid = 0; lid < NPC_MAX_LID; lid++) {
 		for (lt = 0; lt < NPC_MAX_LT; lt++) {
-			for (ld = 0; ld < NPC_MAX_LD; ld++) {
-				SET_KEX_LD(NIX_INTF_RX, lid, lt, ld,
+			for (ld = 0; ld < NPC_MAX_LD; ld++)
+				SET_KEX_LD(intf, lid, lt, ld,
 					   mkex->intf_lid_lt_ld[NIX_INTF_RX]
 					   [lid][lt][ld]);
-
-				SET_KEX_LD(NIX_INTF_TX, lid, lt, ld,
-					   mkex->intf_lid_lt_ld[NIX_INTF_TX]
-					   [lid][lt][ld]);
-			}
 		}
 	}
-
+	/* Program LFLAGS */
 	for (ld = 0; ld < NPC_MAX_LD; ld++) {
-		for (fl = 0; fl < NPC_MAX_LFL; fl++) {
-			SET_KEX_LDFLAGS(NIX_INTF_RX, ld, fl,
+		for (fl = 0; fl < NPC_MAX_LFL; fl++)
+			SET_KEX_LDFLAGS(intf, ld, fl,
 					mkex->intf_ld_flags[NIX_INTF_RX]
 					[ld][fl]);
+	}
+}
+
+static void npc_program_mkex_tx(struct rvu *rvu, int blkaddr,
+				struct npc_mcam_kex *mkex, u8 intf)
+{
+	int lid, lt, ld, fl;
 
-			SET_KEX_LDFLAGS(NIX_INTF_TX, ld, fl,
+	if (is_npc_intf_rx(intf))
+		return;
+
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(intf),
+		    mkex->keyx_cfg[NIX_INTF_TX]);
+
+	/* Program LDATA */
+	for (lid = 0; lid < NPC_MAX_LID; lid++) {
+		for (lt = 0; lt < NPC_MAX_LT; lt++) {
+			for (ld = 0; ld < NPC_MAX_LD; ld++)
+				SET_KEX_LD(intf, lid, lt, ld,
+					   mkex->intf_lid_lt_ld[NIX_INTF_TX]
+					   [lid][lt][ld]);
+		}
+	}
+	/* Program LFLAGS */
+	for (ld = 0; ld < NPC_MAX_LD; ld++) {
+		for (fl = 0; fl < NPC_MAX_LFL; fl++)
+			SET_KEX_LDFLAGS(intf, ld, fl,
 					mkex->intf_ld_flags[NIX_INTF_TX]
 					[ld][fl]);
-		}
+	}
+}
+
+static void npc_program_mkex_profile(struct rvu *rvu, int blkaddr,
+				     struct npc_mcam_kex *mkex)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u8 intf;
+	int ld;
+
+	for (ld = 0; ld < NPC_MAX_LD; ld++)
+		rvu_write64(rvu, blkaddr, NPC_AF_KEX_LDATAX_FLAGS_CFG(ld),
+			    mkex->kex_ld_flags[ld]);
+
+	for (intf = 0; intf < hw->npc_intfs; intf++) {
+		npc_program_mkex_rx(rvu, blkaddr, mkex, intf);
+		npc_program_mkex_tx(rvu, blkaddr, mkex, intf);
 	}
 }
 
@@ -909,7 +996,7 @@ static void npc_program_kpu_profile(struct rvu *rvu, int blkaddr, int kpu,
 			kpu, profile->cam_entries, profile->action_entries);
 	}
 
-	max_entries = rvu_read64(rvu, blkaddr, NPC_AF_CONST1) & 0xFFF;
+	max_entries = rvu->hw->npc_kpu_entries;
 
 	/* Program CAM match entries for previous KPU extracted data */
 	num_entries = min_t(int, profile->cam_entries, max_entries);
@@ -964,9 +1051,6 @@ static void npc_parser_profile_init(struct rvu *rvu, int blkaddr)
 	int num_pkinds, num_kpus, idx;
 	struct npc_pkind *pkind;
 
-	/* Get HW limits */
-	hw->npc_kpus = (rvu_read64(rvu, blkaddr, NPC_AF_CONST) >> 8) & 0x1F;
-
 	/* Disable all KPUs and their entries */
 	for (idx = 0; idx < hw->npc_kpus; idx++) {
 		rvu_write64(rvu, blkaddr,
@@ -1005,12 +1089,6 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	int rsvd, err;
 	u64 cfg;
 
-	/* Get HW limits */
-	cfg = rvu_read64(rvu, blkaddr, NPC_AF_CONST);
-	mcam->banks = (cfg >> 44) & 0xF;
-	mcam->banksize = (cfg >> 28) & 0xFFFF;
-	mcam->counters.max = (cfg >> 48) & 0xFFFF;
-
 	/* Actual number of MCAM entries vary by entry size */
 	cfg = (rvu_read64(rvu, blkaddr,
 			  NPC_AF_INTFX_KEX_CFG(0)) >> 32) & 0x07;
@@ -1077,12 +1155,6 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	mcam->hprio_count = mcam->lprio_count;
 	mcam->hprio_end = mcam->hprio_count;
 
-	/* Reserve last counter for MCAM RX miss action which is set to
-	 * drop pkt. This way we will know how many pkts didn't match
-	 * any MCAM entry.
-	 */
-	mcam->counters.max--;
-	mcam->rx_miss_act_cntr = mcam->counters.max;
 
 	/* Allocate bitmap for managing MCAM counters and memory
 	 * for saving counter to RVU PFFUNC allocation mapping.
@@ -1118,12 +1190,110 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	return -ENOMEM;
 }
 
+static void rvu_npc_hw_init(struct rvu *rvu, int blkaddr)
+{
+	struct npc_pkind *pkind = &rvu->hw->pkind;
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_hwinfo *hw = rvu->hw;
+	u64 npc_const, npc_const1;
+	u64 npc_const2 = 0;
+
+	npc_const = rvu_read64(rvu, blkaddr, NPC_AF_CONST);
+	npc_const1 = rvu_read64(rvu, blkaddr, NPC_AF_CONST1);
+	if (npc_const1 & BIT_ULL(63))
+		npc_const2 = rvu_read64(rvu, blkaddr, NPC_AF_CONST2);
+
+	pkind->rsrc.max = (npc_const1 >> 12) & 0xFFULL;
+	hw->npc_kpu_entries = npc_const1 & 0xFFFULL;
+	hw->npc_kpus = (npc_const >> 8) & 0x1FULL;
+	hw->npc_intfs = npc_const & 0xFULL;
+	hw->npc_counters = (npc_const >> 48) & 0xFFFFULL;
+
+	mcam->banks = (npc_const >> 44) & 0xFULL;
+	mcam->banksize = (npc_const >> 28) & 0xFFFFULL;
+	/* Extended set */
+	if (npc_const2) {
+		hw->npc_ext_set = true;
+		hw->npc_counters = (npc_const2 >> 16) & 0xFFFFULL;
+		mcam->banksize = npc_const2 & 0xFFFFULL;
+	}
+
+	mcam->counters.max = hw->npc_counters;
+}
+
+static void rvu_npc_setup_interfaces(struct rvu *rvu, int blkaddr)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_hwinfo *hw = rvu->hw;
+	u64 nibble_ena, rx_kex, tx_kex;
+	u8 intf;
+
+	/* Reserve last counter for MCAM RX miss action which is set to
+	 * drop packet. This way we will know how many pkts didn't match
+	 * any MCAM entry.
+	 */
+	mcam->counters.max--;
+	mcam->rx_miss_act_cntr = mcam->counters.max;
+
+	rx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_RX];
+	tx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_TX];
+	nibble_ena = FIELD_GET(NPC_PARSE_NIBBLE, rx_kex);
+
+	nibble_ena = rvu_npc_get_tx_nibble_cfg(rvu, nibble_ena);
+	if (nibble_ena) {
+		tx_kex &= ~NPC_PARSE_NIBBLE;
+		tx_kex |= FIELD_PREP(NPC_PARSE_NIBBLE, nibble_ena);
+		npc_mkex_default.keyx_cfg[NIX_INTF_TX] = tx_kex;
+	}
+
+	/* Configure RX interfaces */
+	for (intf = 0; intf < hw->npc_intfs; intf++) {
+		if (is_npc_intf_tx(intf))
+			continue;
+
+		/* Set RX MCAM search key size. LA..LE (ltype only) + Channel */
+		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(intf),
+			    rx_kex);
+
+		/* If MCAM lookup doesn't result in a match, drop the received
+		 * packet. And map this action to a counter to count dropped
+		 * packets.
+		 */
+		rvu_write64(rvu, blkaddr,
+			    NPC_AF_INTFX_MISS_ACT(intf), NIX_RX_ACTIONOP_DROP);
+
+		/* NPC_AF_INTFX_MISS_STAT_ACT[14:12] - counter[11:9]
+		 * NPC_AF_INTFX_MISS_STAT_ACT[8:0] - counter[8:0]
+		 */
+		rvu_write64(rvu, blkaddr,
+			    NPC_AF_INTFX_MISS_STAT_ACT(intf),
+			    ((mcam->rx_miss_act_cntr >> 9) << 12) |
+			    BIT_ULL(9) | mcam->rx_miss_act_cntr);
+	}
+
+	/* Configure TX interfaces */
+	for (intf = 0; intf < hw->npc_intfs; intf++) {
+		if (is_npc_intf_rx(intf))
+			continue;
+
+		/* Extract Ltypes LID_LA to LID_LE */
+		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(intf),
+			    tx_kex);
+
+		/* Set TX miss action to UCAST_DEFAULT i.e
+		 * transmit the packet on NIX LF SQ's default channel.
+		 */
+		rvu_write64(rvu, blkaddr,
+			    NPC_AF_INTFX_MISS_ACT(intf),
+			    NIX_TX_ACTIONOP_UCAST_DEFAULT);
+	}
+}
+
 int rvu_npc_init(struct rvu *rvu)
 {
 	struct npc_kpu_profile_adapter *kpu = &rvu->kpu;
 	struct npc_pkind *pkind = &rvu->hw->pkind;
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	u64 cfg, nibble_ena, rx_kex, tx_kex;
 	int blkaddr, entry, bank, err;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
@@ -1132,17 +1302,15 @@ int rvu_npc_init(struct rvu *rvu)
 		return -ENODEV;
 	}
 
+	rvu_npc_hw_init(rvu, blkaddr);
+
 	/* First disable all MCAM entries, to stop traffic towards NIXLFs */
-	cfg = rvu_read64(rvu, blkaddr, NPC_AF_CONST);
-	for (bank = 0; bank < ((cfg >> 44) & 0xF); bank++) {
-		for (entry = 0; entry < ((cfg >> 28) & 0xFFFF); entry++)
+	for (bank = 0; bank < mcam->banks; bank++) {
+		for (entry = 0; entry < mcam->banksize; entry++)
 			rvu_write64(rvu, blkaddr,
 				    NPC_AF_MCAMEX_BANKX_CFG(entry, bank), 0);
 	}
 
-	/* Allocate resource bimap for pkind*/
-	pkind->rsrc.max = (rvu_read64(rvu, blkaddr,
-				      NPC_AF_CONST1) >> 12) & 0xFF;
 	err = rvu_alloc_bitmap(&pkind->rsrc);
 	if (err)
 		return err;
@@ -1180,21 +1348,7 @@ int rvu_npc_init(struct rvu *rvu)
 		    BIT_ULL(32) | BIT_ULL(24) | BIT_ULL(6) |
 		    BIT_ULL(2) | BIT_ULL(1));
 
-	/* Set RX and TX side MCAM search key size.
-	 * LA..LD (ltype only) + Channel
-	 */
-	rx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_RX];
-	tx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_TX];
-	nibble_ena = FIELD_GET(NPC_PARSE_NIBBLE, rx_kex);
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX), rx_kex);
-	/* Due to an errata (35786) in A0 pass silicon, parse nibble enable
-	 * configuration has to be identical for both Rx and Tx interfaces.
-	 */
-	if (is_rvu_96xx_B0(rvu)) {
-		tx_kex &= ~NPC_PARSE_NIBBLE;
-		tx_kex |= FIELD_PREP(NPC_PARSE_NIBBLE, nibble_ena);
-	}
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_TX), tx_kex);
+	rvu_npc_setup_interfaces(rvu, blkaddr);
 
 	err = npc_mcam_rsrcs_init(rvu, blkaddr);
 	if (err)
@@ -1203,20 +1357,6 @@ int rvu_npc_init(struct rvu *rvu)
 	/* Configure MKEX profile */
 	npc_load_mkex_profile(rvu, blkaddr, rvu->mkex_pfl_name);
 
-	/* Set TX miss action to UCAST_DEFAULT i.e
-	 * transmit the packet on NIX LF SQ's default channel.
-	 */
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_MISS_ACT(NIX_INTF_TX),
-		    NIX_TX_ACTIONOP_UCAST_DEFAULT);
-
-	/* If MCAM lookup doesn't result in a match, drop the received packet.
-	 * And map this action to a counter to count dropped pkts.
-	 */
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_MISS_ACT(NIX_INTF_RX),
-		    NIX_RX_ACTIONOP_DROP);
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_MISS_STAT_ACT(NIX_INTF_RX),
-		    BIT_ULL(9) | mcam->rx_miss_act_cntr);
-
 	return 0;
 }
 
@@ -1307,10 +1447,13 @@ static void npc_map_mcam_entry_and_cntr(struct rvu *rvu, struct npc_mcam *mcam,
 	/* Set mapping and increment counter's refcnt */
 	mcam->entry2cntr_map[entry] = cntr;
 	mcam->cntr_refcnt[cntr]++;
-	/* Enable stats */
+	/* Enable stats
+	 * NPC_AF_MCAMEX_BANKX_STAT_ACT[14:12] - counter[11:9]
+	 * NPC_AF_MCAMEX_BANKX_STAT_ACT[8:0] - counter[8:0]
+	 */
 	rvu_write64(rvu, blkaddr,
 		    NPC_AF_MCAMEX_BANKX_STAT_ACT(index, bank),
-		    BIT_ULL(9) | cntr);
+		    ((cntr >> 9) << 12) | BIT_ULL(9) | cntr);
 }
 
 static void npc_unmap_mcam_entry_and_cntr(struct rvu *rvu,
@@ -1789,9 +1932,11 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 					  struct npc_mcam_write_entry_req *req,
 					  struct msg_rsp *rsp)
 {
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u16 pcifunc = req->hdr.pcifunc;
 	int blkaddr, rc;
+	u8 nix_intf;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
@@ -1808,12 +1953,17 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 		goto exit;
 	}
 
-	if (req->intf != NIX_INTF_RX && req->intf != NIX_INTF_TX) {
+	if (!is_npc_interface_valid(rvu, req->intf)) {
 		rc = NPC_MCAM_INVALID_REQ;
 		goto exit;
 	}
 
-	npc_config_mcam_entry(rvu, mcam, blkaddr, req->entry, req->intf,
+	if (is_npc_intf_tx(req->intf))
+		nix_intf = pfvf->nix_tx_intf;
+	else
+		nix_intf = pfvf->nix_rx_intf;
+
+	npc_config_mcam_entry(rvu, mcam, blkaddr, req->entry, nix_intf,
 			      &req->entry_data, req->enable_entry);
 
 	if (req->set_cntr)
@@ -2141,6 +2291,7 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 			  struct npc_mcam_alloc_and_write_entry_req *req,
 			  struct npc_mcam_alloc_and_write_entry_rsp *rsp)
 {
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
 	struct npc_mcam_alloc_counter_req cntr_req;
 	struct npc_mcam_alloc_counter_rsp cntr_rsp;
 	struct npc_mcam_alloc_entry_req entry_req;
@@ -2149,12 +2300,13 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 	u16 entry = NPC_MCAM_ENTRY_INVALID;
 	u16 cntr = NPC_MCAM_ENTRY_INVALID;
 	int blkaddr, rc;
+	u8 nix_intf;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
 		return NPC_MCAM_INVALID_REQ;
 
-	if (req->intf != NIX_INTF_RX && req->intf != NIX_INTF_TX)
+	if (!is_npc_interface_valid(rvu, req->intf))
 		return NPC_MCAM_INVALID_REQ;
 
 	/* Try to allocate a MCAM entry */
@@ -2196,7 +2348,13 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 
 write_entry:
 	mutex_lock(&mcam->lock);
-	npc_config_mcam_entry(rvu, mcam, blkaddr, entry, req->intf,
+
+	if (is_npc_intf_tx(req->intf))
+		nix_intf = pfvf->nix_tx_intf;
+	else
+		nix_intf = pfvf->nix_rx_intf;
+
+	npc_config_mcam_entry(rvu, mcam, blkaddr, entry, nix_intf,
 			      &req->entry_data, req->enable_entry);
 
 	if (req->alloc_cntr)
@@ -2274,7 +2432,7 @@ int rvu_npc_update_rxvlan(struct rvu *rvu, u16 pcifunc, int nixlf)
 	pfvf->entry.action = npc_get_mcam_action(rvu, mcam, blkaddr, index);
 	enable = is_mcam_entry_enabled(rvu, mcam, blkaddr, index);
 	npc_config_mcam_entry(rvu, mcam, blkaddr, pfvf->rxvlan_index,
-			      NIX_INTF_RX, &pfvf->entry, enable);
+			      pfvf->nix_rx_intf, &pfvf->entry, enable);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index b929f8f..1f3379f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -446,6 +446,8 @@
 #define NPC_AF_BLK_RST			(0x00040)
 #define NPC_AF_MCAM_SCRUB_CTL		(0x000a0)
 #define NPC_AF_KCAM_SCRUB_CTL		(0x000b0)
+#define NPC_AF_CONST2			(0x00100)
+#define NPC_AF_CONST3			(0x00110)
 #define NPC_AF_KPUX_CFG(a)		(0x00500 | (a) << 3)
 #define NPC_AF_PCK_CFG			(0x00600)
 #define NPC_AF_PCK_DEF_OL2		(0x00610)
@@ -469,20 +471,7 @@
 		(0x900000 | (a) << 16 | (b) << 12 | (c) << 5 | (d) << 3)
 #define NPC_AF_INTFX_LDATAX_FLAGSX_CFG(a, b, c) \
 		(0x980000 | (a) << 16 | (b) << 12 | (c) << 3)
-#define NPC_AF_MCAMEX_BANKX_CAMX_INTF(a, b, c)       \
-		(0x1000000ull | (a) << 10 | (b) << 6 | (c) << 3)
-#define NPC_AF_MCAMEX_BANKX_CAMX_W0(a, b, c)         \
-		(0x1000010ull | (a) << 10 | (b) << 6 | (c) << 3)
-#define NPC_AF_MCAMEX_BANKX_CAMX_W1(a, b, c)         \
-		(0x1000020ull | (a) << 10 | (b) << 6 | (c) << 3)
-#define NPC_AF_MCAMEX_BANKX_CFG(a, b)	 (0x1800000ull | (a) << 8 | (b) << 4)
-#define NPC_AF_MCAMEX_BANKX_STAT_ACT(a, b) \
-		(0x1880000 | (a) << 8 | (b) << 4)
-#define NPC_AF_MATCH_STATX(a)		(0x1880008 | (a) << 8)
 #define NPC_AF_INTFX_MISS_STAT_ACT(a)	(0x1880040 + (a) * 0x8)
-#define NPC_AF_MCAMEX_BANKX_ACTION(a, b) (0x1900000ull | (a) << 8 | (b) << 4)
-#define NPC_AF_MCAMEX_BANKX_TAG_ACT(a, b) \
-		(0x1900008 | (a) << 8 | (b) << 4)
 #define NPC_AF_INTFX_MISS_ACT(a)	(0x1a00000 | (a) << 4)
 #define NPC_AF_INTFX_MISS_TAG_ACT(a)	(0x1b00008 | (a) << 4)
 #define NPC_AF_MCAM_BANKX_HITX(a, b)	(0x1c80000 | (a) << 8 | (b) << 4)
@@ -499,6 +488,70 @@
 #define NPC_AF_DBG_DATAX(a)		(0x3001400 | (a) << 4)
 #define NPC_AF_DBG_RESULTX(a)		(0x3001800 | (a) << 4)
 
+#define NPC_AF_MCAMEX_BANKX_CAMX_INTF(a, b, c) ({			   \
+	u64 offset;							   \
+									   \
+	offset = (0x1000000ull | (a) << 10 | (b) << 6 | (c) << 3);	   \
+	if (rvu->hw->npc_ext_set)					   \
+		offset = (0x8000000ull | (a) << 8 | (b) << 22 | (c) << 3); \
+	offset; })
+
+#define NPC_AF_MCAMEX_BANKX_CAMX_W0(a, b, c) ({				   \
+	u64 offset;							   \
+									   \
+	offset = (0x1000010ull | (a) << 10 | (b) << 6 | (c) << 3);	   \
+	if (rvu->hw->npc_ext_set)					   \
+		offset = (0x8000010ull | (a) << 8 | (b) << 22 | (c) << 3); \
+	offset; })
+
+#define NPC_AF_MCAMEX_BANKX_CAMX_W1(a, b, c) ({				   \
+	u64 offset;							   \
+									   \
+	offset = (0x1000020ull | (a) << 10 | (b) << 6 | (c) << 3);	   \
+	if (rvu->hw->npc_ext_set)					   \
+		offset = (0x8000020ull | (a) << 8 | (b) << 22 | (c) << 3); \
+	offset; })
+
+#define NPC_AF_MCAMEX_BANKX_CFG(a, b) ({				   \
+	u64 offset;							   \
+									   \
+	offset = (0x1800000ull | (a) << 8 | (b) << 4);			   \
+	if (rvu->hw->npc_ext_set)					   \
+		offset = (0x8000038ull | (a) << 8 | (b) << 22);		   \
+	offset; })
+
+#define NPC_AF_MCAMEX_BANKX_ACTION(a, b) ({				   \
+	u64 offset;							   \
+									   \
+	offset = (0x1900000ull | (a) << 8 | (b) << 4);			   \
+	if (rvu->hw->npc_ext_set)					   \
+		offset = (0x8000040ull | (a) << 8 | (b) << 22);		   \
+	offset; })							   \
+
+#define NPC_AF_MCAMEX_BANKX_TAG_ACT(a, b) ({				   \
+	u64 offset;							   \
+									   \
+	offset = (0x1900008ull | (a) << 8 | (b) << 4);			   \
+	if (rvu->hw->npc_ext_set)					   \
+		offset = (0x8000048ull | (a) << 8 | (b) << 22);		   \
+	offset; })							   \
+
+#define NPC_AF_MCAMEX_BANKX_STAT_ACT(a, b) ({				   \
+	u64 offset;							   \
+									   \
+	offset = (0x1880000ull | (a) << 8 | (b) << 4);			   \
+	if (rvu->hw->npc_ext_set)					   \
+		offset = (0x8000050ull | (a) << 8 | (b) << 22);		   \
+	offset; })							   \
+
+#define NPC_AF_MATCH_STATX(a) ({					   \
+	u64 offset;							   \
+									   \
+	offset = (0x1880008ull | (a) << 8);				   \
+	if (rvu->hw->npc_ext_set)					   \
+		offset = (0x8000078ull | (a) << 8);			   \
+	offset; })							   \
+
 /* NDC */
 #define NDC_AF_CONST			(0x00000)
 #define NDC_AF_CLK_EN			(0x00020)
-- 
2.7.4

