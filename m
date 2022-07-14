Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779BB5743D4
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 06:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbiGNEmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 00:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237690AbiGNElv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 00:41:51 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA8F43E6E;
        Wed, 13 Jul 2022 21:29:15 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E4ShgD026333;
        Wed, 13 Jul 2022 21:29:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=F4p0S98GbPxLv7YqLHCF8BiNhUlkXPe4enwwU8pyXb0=;
 b=NAu4+C32nkbT8tZxwoSTiWFAv7n1XCyGcl4CcKiWeoxzXXYsi99nNDOk/pYmmUyPVhyn
 mTDKcwZB5WEvjdRVP7EbVKvA5NHOBvD2KLQcqre6S3jtnkcPhzI0+NTySgg3uDU82bNb
 h533a5SFwN0BC8N43eOzKKVeLGr+RIqu4QztweZOGpCEZjwcqMrzMABzBDrQ0LTiQrpx
 +oMYxTtAhzvt6afB96Cz1Z7/rIlSHMG3HDJAR3kaHNuu5wxN84ybgoqggwcnb+CRGDER
 WdvjO0GoqpZ2HiwRwRuKhpX2dWwx6B2HCcYInX37Y99ilrzaKkDDrO8hcGMgDYK0p2DX Bg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9udu3jr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 21:29:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Jul
 2022 21:28:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Jul 2022 21:28:59 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id E3CDD5B6929;
        Wed, 13 Jul 2022 21:28:55 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <kbuild-all@lists.01.org>, <dan.carpenter@oracle.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net-next PATCH] octeontx2-af: Fixes static warnings
Date:   Thu, 14 Jul 2022 09:58:43 +0530
Message-ID: <20220714042843.250537-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: SfTsOg3sTbsYgWNvrllSiYtFTZtrP9Gh
X-Proofpoint-ORIG-GUID: SfTsOg3sTbsYgWNvrllSiYtFTZtrP9Gh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_02,2022-07-13_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes smatch static tool warning reported by smatch tool.

rvu_npc_hash.c:1232 rvu_npc_exact_del_table_entry_by_id() error:
uninitialized symbol 'drop_mcam_idx'.

rvu_npc_hash.c:1312 rvu_npc_exact_add_table_entry() error:
uninitialized symbol 'drop_mcam_idx'.

rvu_npc_hash.c:1391 rvu_npc_exact_update_table_entry() error:
uninitialized symbol 'hash_index'.

rvu_npc_hash.c:1428 rvu_npc_exact_promisc_disable() error:
uninitialized symbol 'drop_mcam_idx'.

rvu_npc_hash.c:1473 rvu_npc_exact_promisc_enable() error:
uninitialized symbol 'drop_mcam_idx'.

otx2_dmac_flt.c:191 otx2_dmacflt_update() error: 'rsp'
dereferencing possible ERR_PTR()

otx2_dmac_flt.c:60 otx2_dmacflt_add_pfmac() error: 'rsp'
dereferencing possible ERR_PTR()

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 49 ++++++++++++++-----
 .../marvell/octeontx2/nic/otx2_dmac_flt.c     | 21 ++++++--
 2 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 1195b690f483..594029007f85 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1199,8 +1199,9 @@ static int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id)
 	struct npc_exact_table_entry *entry = NULL;
 	struct npc_exact_table *table;
 	bool disable_cam = false;
-	u32 drop_mcam_idx;
+	u32 drop_mcam_idx = -1;
 	int *cnt;
+	bool rc;
 
 	table = rvu->hw->table;
 
@@ -1209,7 +1210,7 @@ static int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id)
 	/* Lookup for entry which needs to be updated */
 	entry = __rvu_npc_exact_find_entry_by_seq_id(rvu, seq_id);
 	if (!entry) {
-		dev_dbg(rvu->dev, "%s: failed to find entry for id=0x%x\n", __func__, seq_id);
+		dev_dbg(rvu->dev, "%s: failed to find entry for id=%d\n", __func__, seq_id);
 		mutex_unlock(&table->lock);
 		return -ENODATA;
 	}
@@ -1223,8 +1224,14 @@ static int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id)
 
 	(*cnt)--;
 
-	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, entry->cgx_id, entry->lmac_id,
-					 &drop_mcam_idx, NULL, NULL, NULL);
+	rc = rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, entry->cgx_id,
+					      entry->lmac_id, &drop_mcam_idx, NULL, NULL, NULL);
+	if (!rc) {
+		dev_dbg(rvu->dev, "%s: failed to retrieve drop info for id=0x%x\n",
+			__func__, seq_id);
+		mutex_unlock(&table->lock);
+		return -ENODATA;
+	}
 
 	if (entry->cmd)
 		__rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, -1, &disable_cam);
@@ -1276,6 +1283,7 @@ static int rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
 	u32 drop_mcam_idx;
 	u32 index;
 	u64 mdata;
+	bool rc;
 	int err;
 	u8 ways;
 
@@ -1304,8 +1312,15 @@ static int rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
 		return err;
 	}
 
-	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
-					 &drop_mcam_idx, NULL, NULL, NULL);
+	rc = rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
+					      &drop_mcam_idx, NULL, NULL, NULL);
+	if (!rc) {
+		rvu_npc_exact_dealloc_table_entry(rvu, opc_type, ways, index);
+		dev_dbg(rvu->dev, "%s: failed to get drop rule info cgx=%d lmac=%d\n",
+			__func__, cgx_id, lmac_id);
+		return -EINVAL;
+	}
+
 	if (cmd)
 		__rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, 1, &enable_cam);
 
@@ -1388,7 +1403,7 @@ static int rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_
 
 	dev_dbg(rvu->dev,
 		"%s: Successfully updated entry (index=%d, dmac=%pM, ways=%d opc_type=%d\n",
-		__func__, hash_index, entry->mac, entry->ways, entry->opc_type);
+		__func__, entry->index, entry->mac, entry->ways, entry->opc_type);
 
 	dev_dbg(rvu->dev, "%s: Successfully updated entry (old mac=%pM new_mac=%pM\n",
 		__func__, old_mac, new_mac);
@@ -1414,13 +1429,19 @@ int rvu_npc_exact_promisc_disable(struct rvu *rvu, u16 pcifunc)
 	u8 cgx_id, lmac_id;
 	u32 drop_mcam_idx;
 	bool *promisc;
+	bool rc;
 	u32 cnt;
 
 	table = rvu->hw->table;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
-					 &drop_mcam_idx, NULL, NULL, NULL);
+	rc = rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
+					      &drop_mcam_idx, NULL, NULL, NULL);
+	if (!rc) {
+		dev_dbg(rvu->dev, "%s: failed to get drop rule info cgx=%d lmac=%d\n",
+			__func__, cgx_id, lmac_id);
+		return -EINVAL;
+	}
 
 	mutex_lock(&table->lock);
 	promisc = &table->promisc_mode[drop_mcam_idx];
@@ -1459,13 +1480,19 @@ int rvu_npc_exact_promisc_enable(struct rvu *rvu, u16 pcifunc)
 	u8 cgx_id, lmac_id;
 	u32 drop_mcam_idx;
 	bool *promisc;
+	bool rc;
 	u32 cnt;
 
 	table = rvu->hw->table;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
-					 &drop_mcam_idx, NULL, NULL, NULL);
+	rc = rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
+					      &drop_mcam_idx, NULL, NULL, NULL);
+	if (!rc) {
+		dev_dbg(rvu->dev, "%s: failed to get drop rule info cgx=%d lmac=%d\n",
+			__func__, cgx_id, lmac_id);
+		return -EINVAL;
+	}
 
 	mutex_lock(&table->lock);
 	promisc = &table->promisc_mode[drop_mcam_idx];
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
index 846a0294a215..80d853b343f9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
@@ -54,12 +54,19 @@ static int otx2_dmacflt_add_pfmac(struct otx2_nic *pf, u32 *dmac_index)
 	ether_addr_copy(req->mac_addr, pf->netdev->dev_addr);
 	err = otx2_sync_mbox_msg(&pf->mbox);
 
-	if (!err) {
-		rsp = (struct cgx_mac_addr_set_or_get *)
-			 otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &req->hdr);
-		*dmac_index = rsp->index;
+	if (err)
+		goto out;
+
+	rsp = (struct cgx_mac_addr_set_or_get *)
+		otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &req->hdr);
+
+	if (IS_ERR_OR_NULL(rsp)) {
+		err = -EINVAL;
+		goto out;
 	}
 
+	*dmac_index = rsp->index;
+out:
 	mutex_unlock(&pf->mbox.lock);
 	return err;
 }
@@ -154,6 +161,12 @@ int otx2_dmacflt_get_max_cnt(struct otx2_nic *pf)
 
 	rsp = (struct cgx_max_dmac_entries_get_rsp *)
 		     otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &msg->hdr);
+
+	if (IS_ERR_OR_NULL(rsp)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	pf->flow_cfg->dmacflt_max_flows = rsp->max_dmac_filters;
 
 out:
-- 
2.25.1

