Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF8E56995E
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 06:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiGGEqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 00:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiGGEph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 00:45:37 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A263056D;
        Wed,  6 Jul 2022 21:45:29 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2674Uwec023774;
        Wed, 6 Jul 2022 21:45:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=K1J2w+rt+Vsk2MuRTg7hsBoSL45Zz1haY7OUxucdBxM=;
 b=Pjdovkx45kEE4gWhOlHKRNkZFDhohA/5YhukUD0F/WeDSm8J8PfWBkH7IIT5l1XunHbG
 WfdNTpfBFl3kKRV9/ZistFihz/9viERdes/Splm1Jh3diUbQRCHDlDs5BcrE0UpVRaaT
 +DF0WxGyN6zIna+9e/GzsRBbD20Yht+Jag5OnZytqmEzI2mWx7wwAjW7EVsxLM3bj/54
 yZL96e7rqgFgjQ0V56/H/ZIyjEsUGaiLcWignDSqOAbzvQlH1bbomHq9aCQl98/25s5Q
 5F3jg/Yf9PnAhxGFgt0kZCZeLfh321R61+XzAfpoJBrr2xBmkzmwb+ig224W5v9X4p5T fQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h56wt48g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 21:45:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 6 Jul
 2022 21:45:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 6 Jul 2022 21:45:19 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id A42373F7097;
        Wed,  6 Jul 2022 21:45:14 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [PATCH V2 06/12] octeontx2-af: Drop rules for NPC MCAM
Date:   Thu, 7 Jul 2022 10:13:58 +0530
Message-ID: <20220707044404.2723378-7-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220707044404.2723378-1-rkannoth@marvell.com>
References: <20220707044404.2723378-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xpfa906LeUUSSXux4s_aC1BBzUIxU8uK
X-Proofpoint-GUID: xpfa906LeUUSSXux4s_aC1BBzUIxU8uK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_02,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NPC exact match table installs drop on hit rules in
NPC mcam for each channel. This rule has broadcast and multicast
bits cleared. Exact match bit cleared and channel bits
set. If exact match table hit bit is 0, corresponding NPC mcam
drop rule will be hit for the packet and will be dropped.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   6 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  37 +-
 .../marvell/octeontx2/af/rvu_npc_fs.c         | 105 +++++-
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 316 +++++++++++++++++-
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  22 ++
 6 files changed, 482 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 88b9856a7b39..6809b8b4c556 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1128,6 +1128,12 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 		goto cgx_err;
 	}
 
+	err = rvu_npc_exact_init(rvu);
+	if (err) {
+		dev_err(rvu->dev, "failed to initialize exact match table\n");
+		return err;
+	}
+
 	/* Assign MACs for CGX mapped functions */
 	rvu_setup_pfvf_macaddress(rvu);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index f80d80819745..e5fdb7b62651 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -791,6 +791,7 @@ void rvu_npc_enable_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 void npc_enadis_default_mce_entry(struct rvu *rvu, u16 pcifunc,
 				  int nixlf, int type, bool enable);
 void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
+bool rvu_npc_enable_mcam_by_entry_index(struct rvu *rvu, int entry, int intf, bool enable);
 void rvu_npc_free_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
@@ -835,6 +836,7 @@ int rvu_npc_init(struct rvu *rvu);
 int npc_install_mcam_drop_rule(struct rvu *rvu, int mcam_idx, u16 *counter_idx,
 			       u64 chan_val, u64 chan_mask, u64 exact_val, u64 exact_mask,
 			       u64 bcast_mcast_val, u64 bcast_mcast_mask);
+void npc_mcam_rsrcs_reserve(struct rvu *rvu, int blkaddr, int entry_idx);
 
 /* CPT APIs */
 int rvu_cpt_register_interrupts(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 86cf5794490f..583ead4dd246 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1106,6 +1106,34 @@ void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 				     NIXLF_PROMISC_ENTRY, false);
 }
 
+bool rvu_npc_enable_mcam_by_entry_index(struct rvu *rvu, int entry, int intf, bool enable)
+{
+	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_npc_mcam_rule *rule, *tmp;
+
+	mutex_lock(&mcam->lock);
+
+	list_for_each_entry_safe(rule, tmp, &mcam->mcam_rules, list) {
+		if (rule->intf != intf)
+			continue;
+
+		if (rule->entry != entry)
+			continue;
+
+		rule->enable = enable;
+		mutex_unlock(&mcam->lock);
+
+		npc_enable_mcam_entry(rvu, mcam, blkaddr,
+				      entry, enable);
+
+		return true;
+	}
+
+	mutex_unlock(&mcam->lock);
+	return false;
+}
+
 void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
 	/* Enables only broadcast match entry. Promisc/Allmulti are enabled
@@ -1816,7 +1844,6 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	mcam->hprio_count = mcam->lprio_count;
 	mcam->hprio_end = mcam->hprio_count;
 
-
 	/* Allocate bitmap for managing MCAM counters and memory
 	 * for saving counter to RVU PFFUNC allocation mapping.
 	 */
@@ -2560,6 +2587,14 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 	return 0;
 }
 
+/* Marks bitmaps to reserved the mcam slot */
+void npc_mcam_rsrcs_reserve(struct rvu *rvu, int blkaddr, int entry_idx)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+
+	npc_mcam_set_bit(mcam, entry_idx);
+}
+
 int rvu_mbox_handler_npc_mcam_alloc_entry(struct rvu *rvu,
 					  struct npc_mcam_alloc_entry_req *req,
 					  struct npc_mcam_alloc_entry_rsp *rsp)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 4a8618731fc6..a400aa22da79 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -10,8 +10,8 @@
 #include "rvu_reg.h"
 #include "rvu.h"
 #include "npc.h"
-#include "rvu_npc_hash.h"
 #include "rvu_npc_fs.h"
+#include "rvu_npc_hash.h"
 
 #define NPC_BYTESM		GENMASK_ULL(19, 16)
 #define NPC_HDR_OFFSET		GENMASK_ULL(15, 8)
@@ -297,6 +297,7 @@ static void npc_scan_parse_result(struct npc_mcam *mcam, u8 bit_number,
 	default:
 		return;
 	}
+
 	npc_set_kw_masks(mcam, type, nr_bits, kwi, offset, intf);
 }
 
@@ -860,6 +861,7 @@ do {									      \
 } while (0)
 
 	NPC_WRITE_FLOW(NPC_DMAC, dmac, dmac_val, 0, dmac_mask, 0);
+
 	NPC_WRITE_FLOW(NPC_SMAC, smac, smac_val, 0, smac_mask, 0);
 	NPC_WRITE_FLOW(NPC_ETYPE, etype, ntohs(pkt->etype), 0,
 		       ntohs(mask->etype), 0);
@@ -891,8 +893,7 @@ do {									      \
 			      pkt, mask, opkt, omask);
 }
 
-static struct rvu_npc_mcam_rule *rvu_mcam_find_rule(struct npc_mcam *mcam,
-						    u16 entry)
+static struct rvu_npc_mcam_rule *rvu_mcam_find_rule(struct npc_mcam *mcam, u16 entry)
 {
 	struct rvu_npc_mcam_rule *iter;
 
@@ -1058,8 +1059,9 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	u16 owner = req->hdr.pcifunc;
 	struct msg_rsp write_rsp;
 	struct mcam_entry *entry;
-	int entry_index, err;
 	bool new = false;
+	u16 entry_index;
+	int err;
 
 	installed_features = req->features;
 	features = req->features;
@@ -1460,3 +1462,98 @@ void npc_mcam_disable_flows(struct rvu *rvu, u16 target)
 	}
 	mutex_unlock(&mcam->lock);
 }
+
+/* single drop on non hit rule starting from 0th index. This an extension
+ * to RPM mac filter to support more rules.
+ */
+int npc_install_mcam_drop_rule(struct rvu *rvu, int mcam_idx, u16 *counter_idx,
+			       u64 chan_val, u64 chan_mask, u64 exact_val, u64 exact_mask,
+			       u64 bcast_mcast_val, u64 bcast_mcast_mask)
+{
+	struct npc_mcam_alloc_counter_req cntr_req = { 0 };
+	struct npc_mcam_alloc_counter_rsp cntr_rsp = { 0 };
+	struct npc_mcam_write_entry_req req = { 0 };
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_npc_mcam_rule *rule;
+	struct msg_rsp rsp;
+	bool enabled;
+	int blkaddr;
+	int err;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0) {
+		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
+		return -ENODEV;
+	}
+
+	/* Bail out if no exact match support */
+	if (!rvu_npc_exact_has_match_table(rvu)) {
+		dev_info(rvu->dev, "%s: No support for exact match feature\n", __func__);
+		return -EINVAL;
+	}
+
+	/* If 0th entry is already used, return err */
+	enabled = is_mcam_entry_enabled(rvu, mcam, blkaddr, mcam_idx);
+	if (enabled) {
+		dev_err(rvu->dev, "%s: failed to add single drop on non hit rule at %d th index\n",
+			__func__, mcam_idx);
+		return	-EINVAL;
+	}
+
+	/* Add this entry to mcam rules list */
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule)
+		return -ENOMEM;
+
+	/* Disable rule by default. Enable rule when first dmac filter is
+	 * installed
+	 */
+	rule->enable = false;
+	rule->chan = chan_val;
+	rule->chan_mask = chan_mask;
+	rule->entry = mcam_idx;
+	rvu_mcam_add_rule(mcam, rule);
+
+	/* Reserve slot 0 */
+	npc_mcam_rsrcs_reserve(rvu, blkaddr, mcam_idx);
+
+	/* Allocate counter for this single drop on non hit rule */
+	cntr_req.hdr.pcifunc = 0; /* AF request */
+	cntr_req.contig = true;
+	cntr_req.count = 1;
+	err = rvu_mbox_handler_npc_mcam_alloc_counter(rvu, &cntr_req, &cntr_rsp);
+	if (err) {
+		dev_err(rvu->dev, "%s: Err to allocate cntr for drop rule (err=%d)\n",
+			__func__, err);
+		return	-EFAULT;
+	}
+	*counter_idx = cntr_rsp.cntr;
+
+	/* Fill in fields for this mcam entry */
+	npc_update_entry(rvu, NPC_EXACT_RESULT, &req.entry_data, exact_val, 0,
+			 exact_mask, 0, NIX_INTF_RX);
+	npc_update_entry(rvu, NPC_CHAN, &req.entry_data, chan_val, 0,
+			 chan_mask, 0, NIX_INTF_RX);
+	npc_update_entry(rvu, NPC_LXMB, &req.entry_data, bcast_mcast_val, 0,
+			 bcast_mcast_mask, 0, NIX_INTF_RX);
+
+	req.intf = NIX_INTF_RX;
+	req.set_cntr = true;
+	req.cntr = cntr_rsp.cntr;
+	req.entry = mcam_idx;
+
+	err = rvu_mbox_handler_npc_mcam_write_entry(rvu, &req, &rsp);
+	if (err) {
+		dev_err(rvu->dev, "%s: Installation of single drop on non hit rule at %d failed\n",
+			__func__, mcam_idx);
+		return err;
+	}
+
+	dev_err(rvu->dev, "%s: Installed single drop on non hit rule at %d, cntr=%d\n",
+		__func__, mcam_idx, req.cntr);
+
+	/* disable entry at Bank 0, index 0 */
+	npc_enable_mcam_entry(rvu, mcam, blkaddr, mcam_idx, false);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 96fc56924042..d8f4f55a7d65 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -970,6 +970,220 @@ static int rvu_npc_exact_alloc_table_entry(struct rvu *rvu,  char *mac, u16 chan
 	return -ENOSPC;
 }
 
+/**
+ *	rvu_npc_exact_save_drop_rule_chan_and_mask - Save drop rules info in data base.
+ *      @rvu: resource virtualization unit.
+ *	@drop_mcam_idx: Drop rule index in NPC mcam.
+ *	@chan_val: Channel value.
+ *	@chan_mask: Channel Mask.
+ *	@pcifunc: pcifunc of interface.
+ *	Return: True upon success.
+ */
+static bool rvu_npc_exact_save_drop_rule_chan_and_mask(struct rvu *rvu, int drop_mcam_idx,
+						       u64 chan_val, u64 chan_mask, u16 pcifunc)
+{
+	struct npc_exact_table *table;
+	int i;
+
+	table = rvu->hw->table;
+
+	for (i = 0; i < NPC_MCAM_DROP_RULE_MAX; i++) {
+		if (!table->drop_rule_map[i].valid)
+			break;
+
+		if (table->drop_rule_map[i].chan_val != (u16)chan_val)
+			continue;
+
+		if (table->drop_rule_map[i].chan_mask != (u16)chan_mask)
+			continue;
+
+		return false;
+	}
+
+	if (i == NPC_MCAM_DROP_RULE_MAX)
+		return false;
+
+	table->drop_rule_map[i].drop_rule_idx = drop_mcam_idx;
+	table->drop_rule_map[i].chan_val = (u16)chan_val;
+	table->drop_rule_map[i].chan_mask = (u16)chan_mask;
+	table->drop_rule_map[i].pcifunc = pcifunc;
+	table->drop_rule_map[i].valid = true;
+	return true;
+}
+
+/**
+ *	rvu_npc_exact_calc_drop_rule_chan_and_mask - Calculate Channel number and mask.
+ *      @rvu: resource virtualization unit.
+ *	@intf_type: Interface type (SDK, LBK or CGX)
+ *	@cgx_id: CGX identifier.
+ *	@lmac_id: LAMC identifier.
+ *	@val: Channel number.
+ *	@mask: Channel mask.
+ *	Return: True upon success.
+ */
+static bool rvu_npc_exact_calc_drop_rule_chan_and_mask(struct rvu *rvu, u8 intf_type,
+						       u8 cgx_id, u8 lmac_id,
+						       u64 *val, u64 *mask)
+{
+	u16 chan_val, chan_mask;
+
+	/* No support for SDP and LBK */
+	if (intf_type != NIX_INTF_TYPE_CGX)
+		return false;
+
+	chan_val = rvu_nix_chan_cgx(rvu, cgx_id, lmac_id, 0);
+	chan_mask = 0xfff;
+
+	if (val)
+		*val = chan_val;
+
+	if (mask)
+		*mask = chan_mask;
+
+	return true;
+}
+
+/**
+ *	rvu_npc_exact_drop_rule_to_pcifunc - Retrieve pcifunc
+ *      @rvu: resource virtualization unit.
+ *	@drop_rule_idx: Drop rule index in NPC mcam.
+ *
+ *	Debugfs (exact_drop_cnt) entry displays pcifunc for interface
+ *	by retrieving the pcifunc value from data base.
+ *	Return: Drop rule index.
+ */
+u16 rvu_npc_exact_drop_rule_to_pcifunc(struct rvu *rvu, u32 drop_rule_idx)
+{
+	struct npc_exact_table *table;
+	int i;
+
+	table = rvu->hw->table;
+
+	for (i = 0; i < NPC_MCAM_DROP_RULE_MAX; i++) {
+		if (!table->drop_rule_map[i].valid)
+			break;
+
+		if (table->drop_rule_map[i].drop_rule_idx != drop_rule_idx)
+			continue;
+
+		return table->drop_rule_map[i].pcifunc;
+	}
+
+	dev_err(rvu->dev, "%s: drop mcam rule index (%d) >= NPC_MCAM_DROP_RULE_MAX\n",
+		__func__, drop_rule_idx);
+	return -1;
+}
+
+/**
+ *	rvu_npc_exact_get_drop_rule_info - Get drop rule information.
+ *      @rvu: resource virtualization unit.
+ *	@intf_type: Interface type (CGX, SDP or LBK)
+ *	@cgx_id: CGX identifier.
+ *	@lmac_id: LMAC identifier.
+ *	@drop_mcam_idx: NPC mcam drop rule index.
+ *	@val: Channel value.
+ *	@mask: Channel mask.
+ *	@pcifunc: pcifunc of interface corresponding to the drop rule.
+ *	Return: True upon success.
+ */
+static bool rvu_npc_exact_get_drop_rule_info(struct rvu *rvu, u8 intf_type, u8 cgx_id,
+					     u8 lmac_id, u32 *drop_mcam_idx, u64 *val,
+					     u64 *mask, u16 *pcifunc)
+{
+	struct npc_exact_table *table;
+	u64 chan_val, chan_mask;
+	bool rc;
+	int i;
+
+	table = rvu->hw->table;
+
+	if (intf_type != NIX_INTF_TYPE_CGX) {
+		dev_err(rvu->dev, "%s: No drop rule for LBK/SDP mode\n", __func__);
+		return false;
+	}
+
+	rc = rvu_npc_exact_calc_drop_rule_chan_and_mask(rvu, intf_type, cgx_id,
+							lmac_id, &chan_val, &chan_mask);
+	if (!rc)
+		return false;
+
+	for (i = 0; i < NPC_MCAM_DROP_RULE_MAX; i++) {
+		if (!table->drop_rule_map[i].valid)
+			break;
+
+		if (table->drop_rule_map[i].chan_val != (u16)chan_val)
+			continue;
+
+		if (val)
+			*val = table->drop_rule_map[i].chan_val;
+		if (mask)
+			*mask = table->drop_rule_map[i].chan_mask;
+		if (pcifunc)
+			*pcifunc = table->drop_rule_map[i].pcifunc;
+
+		*drop_mcam_idx = i;
+		return true;
+	}
+
+	if (i == NPC_MCAM_DROP_RULE_MAX) {
+		dev_err(rvu->dev, "%s: drop mcam rule index (%d) >= NPC_MCAM_DROP_RULE_MAX\n",
+			__func__, *drop_mcam_idx);
+		return false;
+	}
+
+	dev_err(rvu->dev, "%s: Could not retrieve for cgx=%d, lmac=%d\n",
+		__func__, cgx_id, lmac_id);
+	return false;
+}
+
+/**
+ *	__rvu_npc_exact_cmd_rules_cnt_update - Update number dmac rules against a drop rule.
+ *      @rvu: resource virtualization unit.
+ *	@drop_mcam_idx: NPC mcam drop rule index.
+ *	@val: +1 or -1.
+ *	@enable_or_disable_cam: If no exact match rules against a drop rule, disable it.
+ *
+ *	when first exact match entry against a drop rule is added, enable_or_disable_cam
+ *	is set to true. When last exact match entry against a drop rule is deleted,
+ *	enable_or_disable_cam is set to true.
+ *	Return: Number of rules
+ */
+static u16 __rvu_npc_exact_cmd_rules_cnt_update(struct rvu *rvu, int drop_mcam_idx,
+						int val, bool *enable_or_disable_cam)
+{
+	struct npc_exact_table *table;
+	u16 *cnt, old_cnt;
+	bool promisc;
+
+	table = rvu->hw->table;
+	promisc = table->promisc_mode[drop_mcam_idx];
+
+	cnt = &table->cnt_cmd_rules[drop_mcam_idx];
+	old_cnt = *cnt;
+
+	*cnt += val;
+
+	if (!enable_or_disable_cam)
+		goto done;
+
+	*enable_or_disable_cam = false;
+
+	/* If all rules are deleted and not already in promisc mode; disable cam */
+	if (!*cnt && !promisc) {
+		*enable_or_disable_cam = true;
+		goto done;
+	}
+
+	/* If rule got added and not already in promisc mode; enable cam */
+	if (!old_cnt && !promisc) {
+		*enable_or_disable_cam = true;
+		goto done;
+	}
+
+done:
+	return *cnt;
+}
+
 /**
  *      rvu_npc_exact_del_table_entry_by_id - Delete and free table entry.
  *      @rvu: resource virtualization unit.
@@ -983,6 +1197,8 @@ int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id)
 {
 	struct npc_exact_table_entry *entry = NULL;
 	struct npc_exact_table *table;
+	u32 drop_mcam_idx;
+	bool disable_cam;
 	int *cnt;
 
 	table = rvu->hw->table;
@@ -1006,6 +1222,19 @@ int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id)
 
 	(*cnt)--;
 
+	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, entry->cgx_id, entry->lmac_id,
+					 &drop_mcam_idx, NULL, NULL, NULL);
+
+	if (entry->cmd)
+		__rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, -1, &disable_cam);
+
+	/* No dmac filter rules; disable drop on hit rule */
+	if (disable_cam) {
+		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, false);
+		dev_dbg(rvu->dev, "%s: Disabling mcam idx %d\n",
+			__func__, drop_mcam_idx);
+	}
+
 	mutex_unlock(&table->lock);
 
 	rvu_npc_exact_dealloc_table_entry(rvu, entry->opc_type, entry->ways, entry->index);
@@ -1042,6 +1271,8 @@ static int __maybe_unused rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_
 {
 	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	enum npc_exact_opc_type opc_type;
+	u32 drop_mcam_idx;
+	bool enable_cam;
 	u32 index;
 	u64 mdata;
 	int err;
@@ -1072,6 +1303,18 @@ static int __maybe_unused rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_
 		return err;
 	}
 
+	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
+					 &drop_mcam_idx, NULL, NULL, NULL);
+	if (cmd)
+		__rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, 1, &enable_cam);
+
+	/* First command rule; enable drop on hit rule */
+	if (enable_cam) {
+		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, true);
+		dev_dbg(rvu->dev, "%s: Enabling mcam idx %d\n",
+			__func__, drop_mcam_idx);
+	}
+
 	dev_dbg(rvu->dev,
 		"%s: Successfully added entry (index=%d, dmac=%pM, ways=%d opc_type=%d\n",
 		__func__, index, mac, ways, opc_type);
@@ -1215,17 +1458,26 @@ void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc)
  *      @rvu: resource virtualization unit.
  *
  *	Initialize HW and SW resources to manage 4way-2K table and fully
+	u8 cgx_id, lmac_id;
  *	associative 32-entry mcam table.
  *	Return: 0 upon success.
  */
 int rvu_npc_exact_init(struct rvu *rvu)
 {
+	u64 bcast_mcast_val, bcast_mcast_mask;
 	struct npc_exact_table *table;
+	u64 exact_val, exact_mask;
+	u64 chan_val, chan_mask;
+	u8 cgx_id, lmac_id;
+	u32 *drop_mcam_idx;
+	u16 max_lmac_cnt;
 	u64 npc_const3;
 	int table_size;
 	int blkaddr;
+	u16 pcifunc;
+	int err, i;
 	u64 cfg;
-	int i;
+	bool rc;
 
 	/* Read NPC_AF_CONST3 and check for have exact
 	 * match functionality is present
@@ -1327,6 +1579,68 @@ int rvu_npc_exact_init(struct rvu *rvu)
 	rvu_exact_config_table_mask(rvu);
 	rvu_exact_config_result_ctrl(rvu, table->mem_table.depth);
 
+	/* - No drop rule for LBK
+	 * - Drop rules for SDP and each LMAC.
+	 */
+	exact_val = !NPC_EXACT_RESULT_HIT;
+	exact_mask = NPC_EXACT_RESULT_HIT;
+
+	/* nibble - 3	2  1   0
+	 *	   L3B L3M L2B L2M
+	 */
+	bcast_mcast_val = 0b0000;
+	bcast_mcast_mask = 0b0011;
+
+	/* Install SDP drop rule */
+	drop_mcam_idx = &table->num_drop_rules;
+
+	max_lmac_cnt = rvu->cgx_cnt_max * MAX_LMAC_PER_CGX + PF_CGXMAP_BASE;
+	for (i = PF_CGXMAP_BASE; i < max_lmac_cnt; i++) {
+		if (rvu->pf2cgxlmac_map[i] == 0xFF)
+			continue;
+
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[i], &cgx_id, &lmac_id);
+
+		rc = rvu_npc_exact_calc_drop_rule_chan_and_mask(rvu, NIX_INTF_TYPE_CGX, cgx_id,
+								lmac_id, &chan_val, &chan_mask);
+		if (!rc) {
+			dev_err(rvu->dev,
+				"%s: failed, info chan_val=0x%llx chan_mask=0x%llx rule_id=%d\n",
+				__func__, chan_val, chan_mask, *drop_mcam_idx);
+			return -EINVAL;
+		}
+
+		/* Filter rules are only for PF */
+		pcifunc = RVU_PFFUNC(i, 0);
+
+		dev_dbg(rvu->dev,
+			"%s:Drop rule cgx=%d lmac=%d chan(val=0x%llx, mask=0x%llx\n",
+			__func__, cgx_id, lmac_id, chan_val, chan_mask);
+
+		rc = rvu_npc_exact_save_drop_rule_chan_and_mask(rvu, table->num_drop_rules,
+								chan_val, chan_mask, pcifunc);
+		if (!rc) {
+			dev_err(rvu->dev,
+				"%s: failed to set drop info for cgx=%d, lmac=%d, chan=%llx\n",
+				__func__, cgx_id, lmac_id, chan_val);
+			return err;
+		}
+
+		err = npc_install_mcam_drop_rule(rvu, *drop_mcam_idx,
+						 &table->counter_idx[*drop_mcam_idx],
+						 chan_val, chan_mask,
+						 exact_val, exact_mask,
+						 bcast_mcast_val, bcast_mcast_mask);
+		if (err) {
+			dev_err(rvu->dev,
+				"failed to configure drop rule (cgx=%d lmac=%d)\n",
+				cgx_id, lmac_id);
+			return err;
+		}
+
+		(*drop_mcam_idx)++;
+	}
+
 	dev_info(rvu->dev, "initialized exact match table successfully\n");
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
index 0a4aeddbadca..e6cc6d9aea7e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -129,6 +129,14 @@ static struct npc_mcam_kex_hash npc_mkex_hash_default __maybe_unused = {
 	},
 };
 
+/* If exact match table support is enabled, enable drop rules */
+#define NPC_MCAM_DROP_RULE_MAX 30
+#define NPC_MCAM_SDP_DROP_RULE_IDX 0
+
+#define RVU_PFFUNC(pf, func)	\
+	((((pf) & RVU_PFVF_PF_MASK) << RVU_PFVF_PF_SHIFT) | \
+	(((func) & RVU_PFVF_FUNC_MASK) << RVU_PFVF_FUNC_SHIFT))
+
 enum npc_exact_opc_type {
 	NPC_EXACT_OPC_MEM,
 	NPC_EXACT_OPC_CAM,
@@ -155,7 +163,11 @@ struct npc_exact_table_entry {
 struct npc_exact_table {
 	struct mutex lock;	/* entries update lock */
 	unsigned long *id_bmap;
+	int num_drop_rules;
 	u32 tot_ids;
+	u16 cnt_cmd_rules[NPC_MCAM_DROP_RULE_MAX];
+	u16 counter_idx[NPC_MCAM_DROP_RULE_MAX];
+	bool promisc_mode[NPC_MCAM_DROP_RULE_MAX];
 	struct {
 		int ways;
 		int depth;
@@ -169,6 +181,15 @@ struct npc_exact_table {
 		int depth;
 		unsigned long *bmap;
 	} cam_table;
+
+	struct {
+		bool valid;
+		u16 chan_val;
+		u16 chan_mask;
+		u16 pcifunc;
+		u8 drop_rule_idx;
+	} drop_rule_map[NPC_MCAM_DROP_RULE_MAX];
+
 #define NPC_EXACT_TBL_MAX_WAYS 4
 
 	struct list_head lhead_mem_tbl_entry[NPC_EXACT_TBL_MAX_WAYS];
@@ -188,5 +209,6 @@ int rvu_npc_exact_init(struct rvu *rvu);
 bool rvu_npc_exact_can_disable_feature(struct rvu *rvu);
 void rvu_npc_exact_disable_feature(struct rvu *rvu);
 void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc);
+u16 rvu_npc_exact_drop_rule_to_pcifunc(struct rvu *rvu, u32 drop_rule_idx);
 
 #endif /* RVU_NPC_HASH_H */
-- 
2.25.1

