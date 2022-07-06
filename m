Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1198A5688E2
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiGFNDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiGFNDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:03:24 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC7FB5D;
        Wed,  6 Jul 2022 06:03:22 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2668Uf6m023774;
        Wed, 6 Jul 2022 06:03:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=QaOvDJvhXomSB7AoEy0esXvkvxDbq/1ZylAbfHARcPw=;
 b=Upsc40SHAOGs0TEE3o+xx7ZEo0+hJ+zgw2txU6jX0MTbzHT/d9HEeJubrmPMpJ7cP4+o
 EDTB3mUg/tNQyXVGDhm/sQqwTCStg4TKSxsYBCWrUWvfFvRJadCSxhpTu9N/Z35f0XFt
 H3imfM7nSKrFtUouf9f/fCOxiRvWcj4e3nsZt7RT9OcUsax38RcFQQ/8mAWZU8snQS9Z
 Ton+LedtslrIaT6Y73KXf9YUgSjUhlVILwuv1VM72K4zvzR5JVaLE4e7DHz/cIgekv4o
 TpQleRfZek9lNppr0TyitYHvjlSiDY6o+cIUCARiqucFSjCXu9siDi7g305kjs+H20yv Ag== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h56wt0vkk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:03:03 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 Jul
 2022 06:03:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 Jul 2022 06:03:02 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id 661435B6942;
        Wed,  6 Jul 2022 06:02:59 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <kbuild-all@lists.01.org>,
        "Ratheesh Kannoth" <rkannoth@marvell.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] octeontx2-af: Fix compiler warnings.
Date:   Wed, 6 Jul 2022 18:32:41 +0530
Message-ID: <20220706130241.2452196-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: JEpjA4ex_fO9g5jaEQnIjLd9zvT_EoCk
X-Proofpoint-GUID: JEpjA4ex_fO9g5jaEQnIjLd9zvT_EoCk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_08,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:388:5: warning: no previous prototype for 'rvu_exact_calculate_hash' [-Wmissing-prototypes]
388 | u32 rvu_exact_calculate_hash(struct rvu *rvu, u16 chan, u16 ctype, u8 *mac,
|     ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: In function 'rvu_npc_exact_get_drop_rule_info':
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1080:14: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
1080 |         bool rc;
|              ^~
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: At top level:
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1248:5: warning: no previous prototype for 'rvu_npc_exact_add_table_entry' [-Wmissing-prototypes]
1248 | int rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id, u8 *mac,
|     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: In function 'rvu_npc_exact_add_table_entry':
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1254:33: warning: variable 'table' set but not used [-Wunused-but-set-variable]
1254 |         struct npc_exact_table *table;
|                                 ^~~~~
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: At top level:
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1320:5: warning: no previous prototype for 'rvu_npc_exact_update_table_entry' [-Wmissing-prototypes]
1320 | int rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
|     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 29 ++++++++++---------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index d3e6f7887ded..61881a437783 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -340,7 +340,7 @@ int rvu_mbox_handler_npc_get_secret_key(struct rvu *rvu,
 
 /**
  *	rvu_npc_exact_mac2u64 - utility function to convert mac address to u64.
- *	@macaddr: MAC address.
+ *	@mac_addr: MAC address.
  *	Returns mdata for exact match table.
  */
 static u64 rvu_npc_exact_mac2u64(u8 *mac_addr)
@@ -385,8 +385,8 @@ static u64 rvu_exact_prepare_mdata(u8 *mac, u16 chan, u16 ctype, u64 mask)
  *	@mask: HASH mask.
  *	@table_depth: Depth of table.
  */
-u32 rvu_exact_calculate_hash(struct rvu *rvu, u16 chan, u16 ctype, u8 *mac,
-			     u64 mask, u32 table_depth)
+static u32 rvu_exact_calculate_hash(struct rvu *rvu, u16 chan, u16 ctype, u8 *mac,
+				    u64 mask, u32 table_depth)
 {
 	struct npc_exact_table *table = rvu->hw->table;
 	u64 hash_key[2];
@@ -419,6 +419,7 @@ u32 rvu_exact_calculate_hash(struct rvu *rvu, u16 chan, u16 ctype, u8 *mac,
  *      @rvu: resource virtualization unit.
  *	@way: Indicate way to table.
  *	@index: Hash index to 4 way table.
+ *	@hash: Hash value.
  *
  *	Searches 4 way table using hash index. Returns 0 on success.
  */
@@ -565,6 +566,7 @@ static u64 rvu_exact_prepare_table_entry(struct rvu *rvu, bool enable,
 
 /**
  *	rvu_exact_config_secret_key - Configure secret key.
+ *	@rvu: Resource virtualization unit.
  *	Returns mdata for exact match table.
  */
 static void rvu_exact_config_secret_key(struct rvu *rvu)
@@ -584,6 +586,7 @@ static void rvu_exact_config_secret_key(struct rvu *rvu)
 
 /**
  *	rvu_exact_config_search_key - Configure search key
+ *	@rvu: Resource virtualization unit.
  *	Returns mdata for exact match table.
  */
 static void rvu_exact_config_search_key(struct rvu *rvu)
@@ -727,7 +730,7 @@ __rvu_npc_exact_find_entry_by_seq_id(struct rvu *rvu, u32 seq_id)
  *	@ways: MEM table ways.
  *	@index: Index in MEM/CAM table.
  *	@cgx_id: CGX identifier.
- *	@lamc_id: LMAC identifier.
+ *	@lmac_id: LMAC identifier.
  *	@mac_addr: MAC address.
  *	@chan: Channel number.
  *	@ctype: Channel Type.
@@ -933,8 +936,8 @@ static int rvu_npc_exact_alloc_table_entry(struct rvu *rvu,  char *mac, u16 chan
 	table = rvu->hw->table;
 
 	/* Check in 4-ways mem entry for free slote */
-	hash =  rvu_exact_calculate_hash(rvu, chan, ctype, mac, table->mem_table.mask,
-					 table->mem_table.depth);
+	hash = rvu_exact_calculate_hash(rvu, chan, ctype, mac, table->mem_table.mask,
+					table->mem_table.depth);
 	err = rvu_npc_exact_alloc_mem_table_entry(rvu, ways, index, hash);
 	if (!err) {
 		*opc_type = NPC_EXACT_OPC_MEM;
@@ -1089,6 +1092,8 @@ static bool rvu_npc_exact_get_drop_rule_info(struct rvu *rvu, u8 intf_type, u8 c
 
 	rc = rvu_npc_exact_calc_drop_rule_chan_and_mask(rvu, intf_type, cgx_id,
 							lmac_id, &chan_val, &chan_mask);
+	if (!rc)
+		return false;
 
 	for (i = 0; i < NPC_MCAM_DROP_RULE_MAX; i++) {
 		if (!table->drop_rule_map[i].valid)
@@ -1254,7 +1259,6 @@ static int rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
 {
 	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	enum npc_exact_opc_type opc_type;
-	struct npc_exact_table *table;
 	u32 drop_mcam_idx;
 	bool enable_cam;
 	u32 index;
@@ -1262,8 +1266,6 @@ static int rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
 	int err;
 	u8 ways;
 
-	table = rvu->hw->table;
-
 	ctype = 0;
 
 	err = rvu_npc_exact_alloc_table_entry(rvu, mac, chan, ctype, &index, &ways, &opc_type);
@@ -1312,7 +1314,7 @@ static int rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
  *      rvu_npc_exact_update_table_entry - Update exact match table.
  *      @rvu: resource virtualization unit.
  *	@cgx_id: CGX identifier.
- *	@lamc_id: LMAC identifier.
+ *	@lmac_id: LMAC identifier.
  *	@old_mac: Existing MAC address entry.
  *	@new_mac: New MAC address entry.
  *	@seq_id: Sequence identifier of the entry.
@@ -1347,9 +1349,9 @@ static int rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_
 	 * hash index, we cannot update the entry. Fail in these scenarios.
 	 */
 	if (entry->opc_type == NPC_EXACT_OPC_MEM) {
-		hash_index =  rvu_exact_calculate_hash(rvu, entry->chan, entry->ctype,
-						       new_mac, table->mem_table.mask,
-						       table->mem_table.depth);
+		hash_index = rvu_exact_calculate_hash(rvu, entry->chan, entry->ctype,
+						      new_mac, table->mem_table.mask,
+						      table->mem_table.depth);
 		if (hash_index != entry->index) {
 			dev_dbg(rvu->dev,
 				"%s: Update failed due to index mismatch(new=0x%x, old=%x)\n",
@@ -1771,7 +1773,6 @@ void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc)
  *      @rvu: resource virtualization unit.
  *
  *	Initialize HW and SW resources to manage 4way-2K table and fully
-	u8 cgx_id, lmac_id;
  *	associative 32-entry mcam table.
  */
 int rvu_npc_exact_init(struct rvu *rvu)
-- 
2.25.1

