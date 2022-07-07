Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274BE569784
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 03:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiGGBcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 21:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiGGBcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 21:32:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFB82E9D6
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 18:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF15DB81E4E
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 01:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE63C3411C;
        Thu,  7 Jul 2022 01:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657157523;
        bh=lc0KqV/wBh6zaRLQxmz2Vtyl2EvqdskoztosoYh+V0Q=;
        h=From:To:Cc:Subject:Date:From;
        b=PPQt2Oz5neuePK+uDqpcCe4dUa37+5rPhEet4wPqTW1bGvpyi49ZYO+LBGed9b1Pj
         MwFIsrV+eHbZdM3UT43jLfWQFTobZfFN2vyZzfDo7s6haXq5u5iOCpS7sC8spf5MWX
         OaAAES8iw5RMxbMMcyUpZy5+X91mKTsOGlnVOEQdYYmN748NvhtaIxT/0RoQm0mmzh
         OqMM/3bOS4p/7Ac1f1MDKHsYUbPZSi3Ch9mE3aJgw9zSM8wMNmQnvRMtaTvq64E7mw
         7sP9rdw2mHn4r8fyzuui0cY32Zhy+Vpu7+WiweUWPwex239qaLZy6eVdE0XPqzxK7I
         rmzWR33ARuUhQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Ratheesh Kannoth <rkannoth@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] Revert "Merge branch 'octeontx2-af-next'"
Date:   Wed,  6 Jul 2022 18:32:01 -0700
Message-Id: <20220707013201.1372433-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 2ef8e39f58f08589ab035223c2687830c0eba30f, reversing
changes made to e7ce9fc9ad38773b660ef663ae98df4f93cb6a37.

There are build warnings here which break the normal
build due to -Werror. Ratheesh was nice enough to quickly
follow up with fixes but didn't hit all the warnings I
see on GCC 12 so to unlock net-next from taking patches
let get this series out for now.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/Makefile    |    2 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |   41 +-
 .../net/ethernet/marvell/octeontx2/af/npc.h   |   25 -
 .../marvell/octeontx2/af/npc_profile.h        |    5 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   16 -
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   24 +-
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |   39 +-
 .../marvell/octeontx2/af/rvu_debugfs.c        |  179 --
 .../marvell/octeontx2/af/rvu_devlink.c        |   71 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |    7 -
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |   51 +-
 .../marvell/octeontx2/af/rvu_npc_fs.c         |  162 +-
 .../marvell/octeontx2/af/rvu_npc_fs.h         |   17 -
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 1958 -----------------
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  233 --
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   15 -
 .../marvell/octeontx2/nic/otx2_common.h       |   10 +-
 .../marvell/octeontx2/nic/otx2_dmac_flt.c     |   46 +-
 .../marvell/octeontx2/nic/otx2_flows.c        |   40 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |    2 +-
 20 files changed, 67 insertions(+), 2876 deletions(-)
 delete mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
 delete mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
 delete mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 40203560b291..7f4a4ca9af78 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -11,4 +11,4 @@ rvu_mbox-y := mbox.o rvu_trace.o
 rvu_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
 		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o \
 		  rvu_cpt.o rvu_devlink.o rpm.o rvu_cn10k.o rvu_switch.o \
-		  rvu_sdp.o rvu_npc_hash.o
+		  rvu_sdp.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 430aa8a05c23..550cb11197bf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -169,10 +169,9 @@ M(CGX_GET_PHY_FEC_STATS, 0x219, cgx_get_phy_fec_stats, msg_req, msg_rsp) \
 M(CGX_FEATURES_GET,	0x21B, cgx_features_get, msg_req,		\
 			       cgx_features_info_msg)			\
 M(RPM_STATS,		0x21C, rpm_stats, msg_req, rpm_stats_rsp)	\
-M(CGX_MAC_ADDR_RESET,	0x21D, cgx_mac_addr_reset, cgx_mac_addr_reset_req, \
-							msg_rsp) \
+M(CGX_MAC_ADDR_RESET,	0x21D, cgx_mac_addr_reset, msg_req, msg_rsp)	\
 M(CGX_MAC_ADDR_UPDATE,	0x21E, cgx_mac_addr_update, cgx_mac_addr_update_req, \
-						    cgx_mac_addr_update_rsp) \
+			       msg_rsp)					\
 M(CGX_PRIO_FLOW_CTRL_CFG, 0x21F, cgx_prio_flow_ctrl_cfg, cgx_pfc_cfg,  \
 				 cgx_pfc_rsp)                               \
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
@@ -242,9 +241,6 @@ M(NPC_MCAM_READ_BASE_RULE, 0x6011, npc_read_base_steer_rule,            \
 M(NPC_MCAM_GET_STATS, 0x6012, npc_mcam_entry_stats,                     \
 				   npc_mcam_get_stats_req,              \
 				   npc_mcam_get_stats_rsp)              \
-M(NPC_GET_SECRET_KEY, 0x6013, npc_get_secret_key,                     \
-				   npc_get_secret_key_req,              \
-				   npc_get_secret_key_rsp)              \
 /* NIX mbox IDs (range 0x8000 - 0xFFFF) */				\
 M(NIX_LF_ALLOC,		0x8000, nix_lf_alloc,				\
 				 nix_lf_alloc_req, nix_lf_alloc_rsp)	\
@@ -432,7 +428,6 @@ struct get_hw_cap_rsp {
 	struct mbox_msghdr hdr;
 	u8 nix_fixed_txschq_mapping; /* Schq mapping fixed or flexible */
 	u8 nix_shaping;		     /* Is shaping and coloring supported */
-	u8 npc_hash_extract;	/* Is hash extract supported */
 };
 
 /* CGX mbox message formats */
@@ -456,7 +451,6 @@ struct cgx_fec_stats_rsp {
 struct cgx_mac_addr_set_or_get {
 	struct mbox_msghdr hdr;
 	u8 mac_addr[ETH_ALEN];
-	u32 index;
 };
 
 /* Structure for requesting the operation to
@@ -472,7 +466,7 @@ struct cgx_mac_addr_add_req {
  */
 struct cgx_mac_addr_add_rsp {
 	struct mbox_msghdr hdr;
-	u32 index;
+	u8 index;
 };
 
 /* Structure for requesting the operation to
@@ -480,7 +474,7 @@ struct cgx_mac_addr_add_rsp {
  */
 struct cgx_mac_addr_del_req {
 	struct mbox_msghdr hdr;
-	u32 index;
+	u8 index;
 };
 
 /* Structure for response against the operation to
@@ -488,7 +482,7 @@ struct cgx_mac_addr_del_req {
  */
 struct cgx_max_dmac_entries_get_rsp {
 	struct mbox_msghdr hdr;
-	u32 max_dmac_filters;
+	u8 max_dmac_filters;
 };
 
 struct cgx_link_user_info {
@@ -589,20 +583,10 @@ struct cgx_set_link_mode_rsp {
 	int status;
 };
 
-struct cgx_mac_addr_reset_req {
-	struct mbox_msghdr hdr;
-	u32 index;
-};
-
 struct cgx_mac_addr_update_req {
 	struct mbox_msghdr hdr;
 	u8 mac_addr[ETH_ALEN];
-	u32 index;
-};
-
-struct cgx_mac_addr_update_rsp {
-	struct mbox_msghdr hdr;
-	u32 index;
+	u8 index;
 };
 
 #define RVU_LMAC_FEAT_FC		BIT_ULL(0) /* pause frames */
@@ -1456,16 +1440,6 @@ struct npc_mcam_get_stats_rsp {
 	u8 stat_ena; /* enabled */
 };
 
-struct npc_get_secret_key_req {
-	struct mbox_msghdr hdr;
-	u8 intf;
-};
-
-struct npc_get_secret_key_rsp {
-	struct mbox_msghdr hdr;
-	u64 secret_key[3];
-};
-
 enum ptp_op {
 	PTP_OP_ADJFINE = 0,
 	PTP_OP_GET_CLOCK = 1,
@@ -1648,9 +1622,6 @@ enum cgx_af_status {
 	LMAC_AF_ERR_PERM_DENIED		= -1103,
 	LMAC_AF_ERR_PFC_ENADIS_PERM_DENIED       = -1104,
 	LMAC_AF_ERR_8023PAUSE_ENADIS_PERM_DENIED = -1105,
-	LMAC_AF_ERR_EXACT_MATCH_TBL_ADD_FAILED = -1108,
-	LMAC_AF_ERR_EXACT_MATCH_TBL_DEL_FAILED = -1109,
-	LMAC_AF_ERR_EXACT_MATCH_TBL_LOOK_UP_FAILED = -1110,
 };
 
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index f187293e3e08..9b6e587e78b4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -10,14 +10,6 @@
 
 #define NPC_KEX_CHAN_MASK	0xFFFULL
 
-#define SET_KEX_LD(intf, lid, ltype, ld, cfg)	\
-	rvu_write64(rvu, blkaddr,	\
-		    NPC_AF_INTFX_LIDX_LTX_LDX_CFG(intf, lid, ltype, ld), cfg)
-
-#define SET_KEX_LDFLAGS(intf, ld, flags, cfg)	\
-	rvu_write64(rvu, blkaddr,	\
-		    NPC_AF_INTFX_LDATAX_FLAGSX_CFG(intf, ld, flags), cfg)
-
 enum NPC_LID_E {
 	NPC_LID_LA = 0,
 	NPC_LID_LB,
@@ -208,7 +200,6 @@ enum key_fields {
 	NPC_ERRLEV,
 	NPC_ERRCODE,
 	NPC_LXMB,
-	NPC_EXACT_RESULT,
 	NPC_LA,
 	NPC_LB,
 	NPC_LC,
@@ -389,22 +380,6 @@ struct nix_rx_action {
 #endif
 };
 
-/* NPC_AF_INTFX_KEX_CFG field masks */
-#define NPC_EXACT_NIBBLE_START		40
-#define NPC_EXACT_NIBBLE_END		43
-#define NPC_EXACT_NIBBLE		GENMASK_ULL(43, 40)
-
-/* NPC_EXACT_KEX_S nibble definitions for each field */
-#define NPC_EXACT_NIBBLE_HIT		BIT_ULL(40)
-#define NPC_EXACT_NIBBLE_OPC		BIT_ULL(40)
-#define NPC_EXACT_NIBBLE_WAY		BIT_ULL(40)
-#define NPC_EXACT_NIBBLE_INDEX		GENMASK_ULL(43, 41)
-
-#define NPC_EXACT_RESULT_HIT		BIT_ULL(0)
-#define NPC_EXACT_RESULT_OPC		GENMASK_ULL(2, 1)
-#define NPC_EXACT_RESULT_WAY		GENMASK_ULL(4, 3)
-#define NPC_EXACT_RESULT_IDX		GENMASK_ULL(15, 5)
-
 /* NPC_AF_INTFX_KEX_CFG field masks */
 #define NPC_PARSE_NIBBLE		GENMASK_ULL(30, 0)
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index a820bad3abb2..4180376fa676 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -155,7 +155,7 @@
 
 /* Rx parse key extract nibble enable */
 #define NPC_PARSE_NIBBLE_INTF_RX	(NPC_PARSE_NIBBLE_CHAN | \
-					 NPC_PARSE_NIBBLE_L2L3_BCAST | \
+					 NPC_PARSE_NIBBLE_ERRCODE | \
 					 NPC_PARSE_NIBBLE_LA_LTYPE | \
 					 NPC_PARSE_NIBBLE_LB_LTYPE | \
 					 NPC_PARSE_NIBBLE_LC_LTYPE | \
@@ -15123,8 +15123,7 @@ static struct npc_mcam_kex npc_mkex_default = {
 	.kpu_version = NPC_KPU_PROFILE_VER,
 	.keyx_cfg = {
 		/* nibble: LA..LE (ltype only) + Error code + Channel */
-		[NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | NPC_PARSE_NIBBLE_INTF_RX |
-						(u64)NPC_EXACT_NIBBLE_HIT,
+		[NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | NPC_PARSE_NIBBLE_INTF_RX,
 		/* nibble: LA..LE (ltype only) */
 		[NIX_INTF_TX] = ((u64)NPC_MCAM_KEY_X2 << 32) | NPC_PARSE_NIBBLE_INTF_TX,
 	},
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 6809b8b4c556..54e1b27a7dfe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -18,7 +18,6 @@
 #include "ptp.h"
 
 #include "rvu_trace.h"
-#include "rvu_npc_hash.h"
 
 #define DRV_NAME	"rvu_af"
 #define DRV_STRING      "Marvell OcteonTX2 RVU Admin Function Driver"
@@ -69,8 +68,6 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
 	hw->cap.nix_tx_link_bp = true;
 	hw->cap.nix_rx_multicast = true;
 	hw->cap.nix_shaper_toggle_wait = false;
-	hw->cap.npc_hash_extract = false;
-	hw->cap.npc_exact_match_enabled = false;
 	hw->rvu = rvu;
 
 	if (is_rvu_pre_96xx_C0(rvu)) {
@@ -88,9 +85,6 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
 
 	if (!is_rvu_otx2(rvu))
 		hw->cap.per_pf_mbox_regs = true;
-
-	if (is_rvu_npc_hash_extract_en(rvu))
-		hw->cap.npc_hash_extract = true;
 }
 
 /* Poll a RVU block's register 'offset', for a 'zero'
@@ -1128,12 +1122,6 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 		goto cgx_err;
 	}
 
-	err = rvu_npc_exact_init(rvu);
-	if (err) {
-		dev_err(rvu->dev, "failed to initialize exact match table\n");
-		return err;
-	}
-
 	/* Assign MACs for CGX mapped functions */
 	rvu_setup_pfvf_macaddress(rvu);
 
@@ -2003,7 +1991,6 @@ int rvu_mbox_handler_get_hw_cap(struct rvu *rvu, struct msg_req *req,
 
 	rsp->nix_fixed_txschq_mapping = hw->cap.nix_fixed_txschq_mapping;
 	rsp->nix_shaping = hw->cap.nix_shaping;
-	rsp->npc_hash_extract = hw->cap.npc_hash_extract;
 
 	return 0;
 }
@@ -2561,9 +2548,6 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 
 static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 {
-	if (rvu_npc_exact_has_match_table(rvu))
-		rvu_npc_exact_reset(rvu, pcifunc);
-
 	mutex_lock(&rvu->flr_lock);
 	/* Reset order should reflect inter-block dependencies:
 	 * 1. Reset any packet/work sources (NIX, CPT, TIM)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index e5fdb7b62651..513b43ecd5be 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -338,8 +338,6 @@ struct hw_cap {
 	bool	per_pf_mbox_regs; /* PF mbox specified in per PF registers ? */
 	bool	programmable_chans; /* Channels programmable ? */
 	bool	ipolicer;
-	bool	npc_hash_extract; /* Hash extract enabled ? */
-	bool	npc_exact_match_enabled; /* Exact match supported ? */
 };
 
 struct rvu_hwinfo {
@@ -371,7 +369,6 @@ struct rvu_hwinfo {
 	struct rvu	 *rvu;
 	struct npc_pkind pkind;
 	struct npc_mcam  mcam;
-	struct npc_exact_table *table;
 };
 
 struct mbox_wq_info {
@@ -422,7 +419,6 @@ struct npc_kpu_profile_adapter {
 	const struct npc_kpu_profile_action	*ikpu; /* array[pkinds] */
 	const struct npc_kpu_profile	*kpu; /* array[kpus] */
 	struct npc_mcam_kex		*mkex;
-	struct npc_mcam_kex_hash	*mkex_hash;
 	bool				custom;
 	size_t				pkinds;
 	size_t				kpus;
@@ -579,17 +575,6 @@ static inline bool is_rvu_otx2(struct rvu *rvu)
 		midr == PCI_REVISION_ID_95XXMM || midr == PCI_REVISION_ID_95XXO);
 }
 
-static inline bool is_rvu_npc_hash_extract_en(struct rvu *rvu)
-{
-	u64 npc_const3;
-
-	npc_const3 = rvu_read64(rvu, BLKADDR_NPC, NPC_AF_CONST3);
-	if (!(npc_const3 & BIT_ULL(62)))
-		return false;
-
-	return true;
-}
-
 static inline u16 rvu_nix_chan_cgx(struct rvu *rvu, u8 cgxid,
 				   u8 lmacid, u8 chan)
 {
@@ -769,6 +754,7 @@ u32 convert_dwrr_mtu_to_bytes(u8 dwrr_mtu);
 u32 convert_bytes_to_dwrr_mtu(u32 bytes);
 
 /* NPC APIs */
+int rvu_npc_init(struct rvu *rvu);
 void rvu_npc_freemem(struct rvu *rvu);
 int rvu_npc_get_pkind(struct rvu *rvu, u16 pf);
 void rvu_npc_set_pkind(struct rvu *rvu, int pkind, struct rvu_pfvf *pfvf);
@@ -787,17 +773,14 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 				    u64 chan);
 void rvu_npc_enable_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 				   bool enable);
-
 void npc_enadis_default_mce_entry(struct rvu *rvu, u16 pcifunc,
 				  int nixlf, int type, bool enable);
 void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
-bool rvu_npc_enable_mcam_by_entry_index(struct rvu *rvu, int entry, int intf, bool enable);
 void rvu_npc_free_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 				    int group, int alg_idx, int mcam_index);
-
 void rvu_npc_get_mcam_entry_alloc_info(struct rvu *rvu, u16 pcifunc,
 				       int blkaddr, int *alloc_cnt,
 				       int *enable_cnt);
@@ -832,11 +815,6 @@ int npc_get_nixlf_mcam_index(struct npc_mcam *mcam, u16 pcifunc, int nixlf,
 			     int type);
 bool is_mcam_entry_enabled(struct rvu *rvu, struct npc_mcam *mcam, int blkaddr,
 			   int index);
-int rvu_npc_init(struct rvu *rvu);
-int npc_install_mcam_drop_rule(struct rvu *rvu, int mcam_idx, u16 *counter_idx,
-			       u64 chan_val, u64 chan_mask, u64 exact_val, u64 exact_mask,
-			       u64 bcast_mcast_val, u64 bcast_mcast_mask);
-void npc_mcam_rsrcs_reserve(struct rvu *rvu, int blkaddr, int entry_idx);
 
 /* CPT APIs */
 int rvu_cpt_register_interrupts(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 5090ddcc7e8a..9ffe99830e34 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -14,7 +14,6 @@
 #include "lmac_common.h"
 #include "rvu_reg.h"
 #include "rvu_trace.h"
-#include "rvu_npc_hash.h"
 
 struct cgx_evq_entry {
 	struct list_head evq_node;
@@ -475,11 +474,6 @@ void rvu_cgx_disable_dmac_entries(struct rvu *rvu, u16 pcifunc)
 	if (!is_cgx_config_permitted(rvu, pcifunc))
 		return;
 
-	if (rvu_npc_exact_has_match_table(rvu)) {
-		rvu_npc_exact_reset(rvu, pcifunc);
-		return;
-	}
-
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	cgx_dev = cgx_get_pdata(cgx_id);
 	lmac_count = cgx_get_lmac_cnt(cgx_dev);
@@ -590,9 +584,6 @@ int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
-	if (rvu_npc_exact_has_match_table(rvu))
-		return rvu_npc_exact_mac_addr_set(rvu, req, rsp);
-
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_addr_set(cgx_id, lmac_id, req->mac_addr);
@@ -611,9 +602,6 @@ int rvu_mbox_handler_cgx_mac_addr_add(struct rvu *rvu,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
-	if (rvu_npc_exact_has_match_table(rvu))
-		return rvu_npc_exact_mac_addr_add(rvu, req, rsp);
-
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	rc = cgx_lmac_addr_add(cgx_id, lmac_id, req->mac_addr);
 	if (rc >= 0) {
@@ -634,9 +622,6 @@ int rvu_mbox_handler_cgx_mac_addr_del(struct rvu *rvu,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
-	if (rvu_npc_exact_has_match_table(rvu))
-		return rvu_npc_exact_mac_addr_del(rvu, req, rsp);
-
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	return cgx_lmac_addr_del(cgx_id, lmac_id, req->index);
 }
@@ -658,11 +643,6 @@ int rvu_mbox_handler_cgx_mac_max_entries_get(struct rvu *rvu,
 		return 0;
 	}
 
-	if (rvu_npc_exact_has_match_table(rvu)) {
-		rsp->max_dmac_filters = rvu_npc_exact_get_max_entries(rvu);
-		return 0;
-	}
-
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	rsp->max_dmac_filters = cgx_lmac_addr_max_entries_get(cgx_id, lmac_id);
 	return 0;
@@ -700,10 +680,6 @@ int rvu_mbox_handler_cgx_promisc_enable(struct rvu *rvu, struct msg_req *req,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
-	/* Disable drop on non hit rule */
-	if (rvu_npc_exact_has_match_table(rvu))
-		return rvu_npc_exact_promisc_enable(rvu, req->hdr.pcifunc);
-
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_promisc_config(cgx_id, lmac_id, true);
@@ -719,10 +695,6 @@ int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
-	/* Disable drop on non hit rule */
-	if (rvu_npc_exact_has_match_table(rvu))
-		return rvu_npc_exact_promisc_disable(rvu, req->hdr.pcifunc);
-
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_promisc_config(cgx_id, lmac_id, false);
@@ -1116,7 +1088,7 @@ int rvu_mbox_handler_cgx_set_link_mode(struct rvu *rvu,
 	return 0;
 }
 
-int rvu_mbox_handler_cgx_mac_addr_reset(struct rvu *rvu, struct cgx_mac_addr_reset_req *req,
+int rvu_mbox_handler_cgx_mac_addr_reset(struct rvu *rvu, struct msg_req *req,
 					struct msg_rsp *rsp)
 {
 	int pf = rvu_get_pf(req->hdr.pcifunc);
@@ -1126,16 +1098,12 @@ int rvu_mbox_handler_cgx_mac_addr_reset(struct rvu *rvu, struct cgx_mac_addr_res
 		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-
-	if (rvu_npc_exact_has_match_table(rvu))
-		return rvu_npc_exact_mac_addr_reset(rvu, req, rsp);
-
 	return cgx_lmac_addr_reset(cgx_id, lmac_id);
 }
 
 int rvu_mbox_handler_cgx_mac_addr_update(struct rvu *rvu,
 					 struct cgx_mac_addr_update_req *req,
-					 struct cgx_mac_addr_update_rsp *rsp)
+					 struct msg_rsp *rsp)
 {
 	int pf = rvu_get_pf(req->hdr.pcifunc);
 	u8 cgx_id, lmac_id;
@@ -1143,9 +1111,6 @@ int rvu_mbox_handler_cgx_mac_addr_update(struct rvu *rvu,
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return LMAC_AF_ERR_PERM_DENIED;
 
-	if (rvu_npc_exact_has_match_table(rvu))
-		return rvu_npc_exact_mac_addr_update(rvu, req, rsp);
-
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	return cgx_lmac_addr_update(cgx_id, lmac_id, req->mac_addr, req->index);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index f42a09f04b25..2ad73b180276 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -18,7 +18,6 @@
 #include "cgx.h"
 #include "lmac_common.h"
 #include "npc.h"
-#include "rvu_npc_hash.h"
 
 #define DEBUGFS_DIR_NAME "octeontx2"
 
@@ -2601,170 +2600,6 @@ static int rvu_dbg_npc_mcam_show_rules(struct seq_file *s, void *unused)
 
 RVU_DEBUG_SEQ_FOPS(npc_mcam_rules, npc_mcam_show_rules, NULL);
 
-static int rvu_dbg_npc_exact_show_entries(struct seq_file *s, void *unused)
-{
-	struct npc_exact_table_entry *mem_entry[NPC_EXACT_TBL_MAX_WAYS] = { 0 };
-	struct npc_exact_table_entry *cam_entry;
-	struct npc_exact_table *table;
-	struct rvu *rvu = s->private;
-	int i, j;
-
-	u8 bitmap = 0;
-
-	table = rvu->hw->table;
-
-	mutex_lock(&table->lock);
-
-	/* Check if there is at least one entry in mem table */
-	if (!table->mem_tbl_entry_cnt)
-		goto dump_cam_table;
-
-	/* Print table headers */
-	seq_puts(s, "\n\tExact Match MEM Table\n");
-	seq_puts(s, "Index\t");
-
-	for (i = 0; i < table->mem_table.ways; i++) {
-		mem_entry[i] = list_first_entry_or_null(&table->lhead_mem_tbl_entry[i],
-							struct npc_exact_table_entry, list);
-
-		seq_printf(s, "Way-%d\t\t\t\t\t", i);
-	}
-
-	seq_puts(s, "\n");
-	for (i = 0; i < table->mem_table.ways; i++)
-		seq_puts(s, "\tChan  MAC                     \t");
-
-	seq_puts(s, "\n\n");
-
-	/* Print mem table entries */
-	for (i = 0; i < table->mem_table.depth; i++) {
-		bitmap = 0;
-		for (j = 0; j < table->mem_table.ways; j++) {
-			if (!mem_entry[j])
-				continue;
-
-			if (mem_entry[j]->index != i)
-				continue;
-
-			bitmap |= BIT(j);
-		}
-
-		/* No valid entries */
-		if (!bitmap)
-			continue;
-
-		seq_printf(s, "%d\t", i);
-		for (j = 0; j < table->mem_table.ways; j++) {
-			if (!(bitmap & BIT(j))) {
-				seq_puts(s, "nil\t\t\t\t\t");
-				continue;
-			}
-
-			seq_printf(s, "0x%x %pM\t\t\t", mem_entry[j]->chan,
-				   mem_entry[j]->mac);
-			mem_entry[j] = list_next_entry(mem_entry[j], list);
-		}
-		seq_puts(s, "\n");
-	}
-
-dump_cam_table:
-
-	if (!table->cam_tbl_entry_cnt)
-		goto done;
-
-	seq_puts(s, "\n\tExact Match CAM Table\n");
-	seq_puts(s, "index\tchan\tMAC\n");
-
-	/* Traverse cam table entries */
-	list_for_each_entry(cam_entry, &table->lhead_cam_tbl_entry, list) {
-		seq_printf(s, "%d\t0x%x\t%pM\n", cam_entry->index, cam_entry->chan,
-			   cam_entry->mac);
-	}
-
-done:
-	mutex_unlock(&table->lock);
-	return 0;
-}
-
-RVU_DEBUG_SEQ_FOPS(npc_exact_entries, npc_exact_show_entries, NULL);
-
-static int rvu_dbg_npc_exact_show_info(struct seq_file *s, void *unused)
-{
-	struct npc_exact_table *table;
-	struct rvu *rvu = s->private;
-	int i;
-
-	table = rvu->hw->table;
-
-	seq_puts(s, "\n\tExact Table Info\n");
-	seq_printf(s, "Exact Match Feature : %s\n",
-		   rvu->hw->cap.npc_exact_match_enabled ? "enabled" : "disable");
-	if (!rvu->hw->cap.npc_exact_match_enabled)
-		return 0;
-
-	seq_puts(s, "\nMCAM Index\tMAC Filter Rules Count\n");
-	for (i = 0; i < table->num_drop_rules; i++)
-		seq_printf(s, "%d\t\t%d\n", i, table->cnt_cmd_rules[i]);
-
-	seq_puts(s, "\nMcam Index\tPromisc Mode Status\n");
-	for (i = 0; i < table->num_drop_rules; i++)
-		seq_printf(s, "%d\t\t%s\n", i, table->promisc_mode[i] ? "on" : "off");
-
-	seq_puts(s, "\n\tMEM Table Info\n");
-	seq_printf(s, "Ways : %d\n", table->mem_table.ways);
-	seq_printf(s, "Depth : %d\n", table->mem_table.depth);
-	seq_printf(s, "Mask : 0x%llx\n", table->mem_table.mask);
-	seq_printf(s, "Hash Mask : 0x%x\n", table->mem_table.hash_mask);
-	seq_printf(s, "Hash Offset : 0x%x\n", table->mem_table.hash_offset);
-
-	seq_puts(s, "\n\tCAM Table Info\n");
-	seq_printf(s, "Depth : %d\n", table->cam_table.depth);
-
-	return 0;
-}
-
-RVU_DEBUG_SEQ_FOPS(npc_exact_info, npc_exact_show_info, NULL);
-
-static int rvu_dbg_npc_exact_drop_cnt(struct seq_file *s, void *unused)
-{
-	struct npc_exact_table *table;
-	struct rvu *rvu = s->private;
-	struct npc_key_field *field;
-	u16 chan, pcifunc;
-	int blkaddr, i;
-	u64 cfg, cam1;
-	char *str;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-	table = rvu->hw->table;
-
-	field = &rvu->hw->mcam.rx_key_fields[NPC_CHAN];
-
-	seq_puts(s, "\n\t Exact Hit on drop status\n");
-	seq_puts(s, "\npcifunc\tmcam_idx\tHits\tchan\tstatus\n");
-
-	for (i = 0; i < table->num_drop_rules; i++) {
-		pcifunc = rvu_npc_exact_drop_rule_to_pcifunc(rvu, i);
-		cfg = rvu_read64(rvu, blkaddr, NPC_AF_MCAMEX_BANKX_CFG(i, 0));
-
-		/* channel will be always in keyword 0 */
-		cam1 = rvu_read64(rvu, blkaddr,
-				  NPC_AF_MCAMEX_BANKX_CAMX_W0(i, 0, 1));
-		chan = field->kw_mask[0] & cam1;
-
-		str = (cfg & 1) ? "enabled" : "disabled";
-
-		seq_printf(s, "0x%x\t%d\t\t%llu\t0x%x\t%s\n", pcifunc, i,
-			   rvu_read64(rvu, blkaddr,
-				      NPC_AF_MATCH_STATX(table->counter_idx[i])),
-			   chan, str);
-	}
-
-	return 0;
-}
-
-RVU_DEBUG_SEQ_FOPS(npc_exact_drop_cnt, npc_exact_drop_cnt, NULL);
-
 static void rvu_dbg_npc_init(struct rvu *rvu)
 {
 	rvu->rvu_dbg.npc = debugfs_create_dir("npc", rvu->rvu_dbg.root);
@@ -2773,22 +2608,8 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
 			    &rvu_dbg_npc_mcam_info_fops);
 	debugfs_create_file("mcam_rules", 0444, rvu->rvu_dbg.npc, rvu,
 			    &rvu_dbg_npc_mcam_rules_fops);
-
 	debugfs_create_file("rx_miss_act_stats", 0444, rvu->rvu_dbg.npc, rvu,
 			    &rvu_dbg_npc_rx_miss_act_fops);
-
-	if (!rvu->hw->cap.npc_exact_match_enabled)
-		return;
-
-	debugfs_create_file("exact_entries", 0444, rvu->rvu_dbg.npc, rvu,
-			    &rvu_dbg_npc_exact_entries_fops);
-
-	debugfs_create_file("exact_info", 0444, rvu->rvu_dbg.npc, rvu,
-			    &rvu_dbg_npc_exact_info_fops);
-
-	debugfs_create_file("exact_drop_cnt", 0444, rvu->rvu_dbg.npc, rvu,
-			    &rvu_dbg_npc_exact_drop_cnt_fops);
-
 }
 
 static int cpt_eng_sts_display(struct seq_file *filp, u8 eng_type)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 88dee589cb21..d0ab8f233a02 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -10,7 +10,6 @@
 #include "rvu.h"
 #include "rvu_reg.h"
 #include "rvu_struct.h"
-#include "rvu_npc_hash.h"
 
 #define DRV_NAME "octeontx2-af"
 
@@ -1437,75 +1436,14 @@ static int rvu_af_dl_dwrr_mtu_get(struct devlink *devlink, u32 id,
 enum rvu_af_dl_param_id {
 	RVU_AF_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
-	RVU_AF_DEVLINK_PARAM_ID_NPC_EXACT_FEATURE_DISABLE,
 };
 
-static int rvu_af_npc_exact_feature_get(struct devlink *devlink, u32 id,
-					struct devlink_param_gset_ctx *ctx)
-{
-	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
-	struct rvu *rvu = rvu_dl->rvu;
-	bool enabled;
-
-	enabled = rvu_npc_exact_has_match_table(rvu);
-
-	snprintf(ctx->val.vstr, sizeof(ctx->val.vstr), "%s",
-		 enabled ? "enabled" : "disabled");
-
-	return 0;
-}
-
-static int rvu_af_npc_exact_feature_disable(struct devlink *devlink, u32 id,
-					    struct devlink_param_gset_ctx *ctx)
-{
-	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
-	struct rvu *rvu = rvu_dl->rvu;
-
-	rvu_npc_exact_disable_feature(rvu);
-
-	return 0;
-}
-
-static int rvu_af_npc_exact_feature_validate(struct devlink *devlink, u32 id,
-					     union devlink_param_value val,
-					     struct netlink_ext_ack *extack)
-{
-	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
-	struct rvu *rvu = rvu_dl->rvu;
-	u64 enable;
-
-	if (kstrtoull(val.vstr, 10, &enable)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Only 1 value is supported");
-		return -EINVAL;
-	}
-
-	if (enable != 1) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Only disabling exact match feature is supported");
-		return -EINVAL;
-	}
-
-	if (rvu_npc_exact_can_disable_feature(rvu))
-		return 0;
-
-	NL_SET_ERR_MSG_MOD(extack,
-			   "Can't disable exact match feature; Please try before any configuration");
-	return -EFAULT;
-}
-
 static const struct devlink_param rvu_af_dl_params[] = {
 	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
 			     "dwrr_mtu", DEVLINK_PARAM_TYPE_U32,
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     rvu_af_dl_dwrr_mtu_get, rvu_af_dl_dwrr_mtu_set,
 			     rvu_af_dl_dwrr_mtu_validate),
-	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_NPC_EXACT_FEATURE_DISABLE,
-			     "npc_exact_feature_disable", DEVLINK_PARAM_TYPE_STRING,
-			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
-			     rvu_af_npc_exact_feature_get,
-			     rvu_af_npc_exact_feature_disable,
-			     rvu_af_npc_exact_feature_validate),
 };
 
 /* Devlink switch mode */
@@ -1563,7 +1501,6 @@ int rvu_register_dl(struct rvu *rvu)
 {
 	struct rvu_devlink *rvu_dl;
 	struct devlink *dl;
-	size_t size;
 	int err;
 
 	dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink),
@@ -1585,12 +1522,8 @@ int rvu_register_dl(struct rvu *rvu)
 		goto err_dl_health;
 	}
 
-	/* Register exact match devlink only for CN10K-B */
-	size = ARRAY_SIZE(rvu_af_dl_params);
-	if (!rvu_npc_exact_has_match_table(rvu))
-		size -= 1;
-
-	err = devlink_params_register(dl, rvu_af_dl_params, size);
+	err = devlink_params_register(dl, rvu_af_dl_params,
+				      ARRAY_SIZE(rvu_af_dl_params));
 	if (err) {
 		dev_err(rvu->dev,
 			"devlink params register failed with error %d", err);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 1d3323da6930..0fa625e2528e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -14,7 +14,6 @@
 #include "npc.h"
 #include "cgx.h"
 #include "lmac_common.h"
-#include "rvu_npc_hash.h"
 
 static void nix_free_tx_vtag_entries(struct rvu *rvu, u16 pcifunc);
 static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
@@ -3793,15 +3792,9 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
 					      pfvf->rx_chan_base,
 					      pfvf->rx_chan_cnt);
-
-		if (rvu_npc_exact_has_match_table(rvu))
-			rvu_npc_exact_promisc_enable(rvu, pcifunc);
 	} else {
 		if (!nix_rx_multicast)
 			rvu_npc_enable_promisc_entry(rvu, pcifunc, nixlf, false);
-
-		if (rvu_npc_exact_has_match_table(rvu))
-			rvu_npc_exact_promisc_disable(rvu, pcifunc);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 583ead4dd246..e05fd2b9a929 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -15,7 +15,6 @@
 #include "npc.h"
 #include "cgx.h"
 #include "npc_profile.h"
-#include "rvu_npc_hash.h"
 
 #define RSVD_MCAM_ENTRIES_PER_PF	3 /* Broadcast, Promisc and AllMulticast */
 #define RSVD_MCAM_ENTRIES_PER_NIXLF	1 /* Ucast for LFs */
@@ -1106,34 +1105,6 @@ void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 				     NIXLF_PROMISC_ENTRY, false);
 }
 
-bool rvu_npc_enable_mcam_by_entry_index(struct rvu *rvu, int entry, int intf, bool enable)
-{
-	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-	struct npc_mcam *mcam = &rvu->hw->mcam;
-	struct rvu_npc_mcam_rule *rule, *tmp;
-
-	mutex_lock(&mcam->lock);
-
-	list_for_each_entry_safe(rule, tmp, &mcam->mcam_rules, list) {
-		if (rule->intf != intf)
-			continue;
-
-		if (rule->entry != entry)
-			continue;
-
-		rule->enable = enable;
-		mutex_unlock(&mcam->lock);
-
-		npc_enable_mcam_entry(rvu, mcam, blkaddr,
-				      entry, enable);
-
-		return true;
-	}
-
-	mutex_unlock(&mcam->lock);
-	return false;
-}
-
 void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
 	/* Enables only broadcast match entry. Promisc/Allmulti are enabled
@@ -1210,6 +1181,14 @@ void rvu_npc_free_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 	rvu_npc_disable_default_entries(rvu, pcifunc, nixlf);
 }
 
+#define SET_KEX_LD(intf, lid, ltype, ld, cfg)	\
+	rvu_write64(rvu, blkaddr,			\
+		NPC_AF_INTFX_LIDX_LTX_LDX_CFG(intf, lid, ltype, ld), cfg)
+
+#define SET_KEX_LDFLAGS(intf, ld, flags, cfg)	\
+	rvu_write64(rvu, blkaddr,			\
+		NPC_AF_INTFX_LDATAX_FLAGSX_CFG(intf, ld, flags), cfg)
+
 static void npc_program_mkex_rx(struct rvu *rvu, int blkaddr,
 				struct npc_mcam_kex *mkex, u8 intf)
 {
@@ -1283,9 +1262,6 @@ static void npc_program_mkex_profile(struct rvu *rvu, int blkaddr,
 		npc_program_mkex_rx(rvu, blkaddr, mkex, intf);
 		npc_program_mkex_tx(rvu, blkaddr, mkex, intf);
 	}
-
-	/* Programme mkex hash profile */
-	npc_program_mkex_hash(rvu, blkaddr);
 }
 
 static int npc_fwdb_prfl_img_map(struct rvu *rvu, void __iomem **prfl_img_addr,
@@ -1487,7 +1463,6 @@ static int npc_prepare_default_kpu(struct npc_kpu_profile_adapter *profile)
 	profile->kpus = ARRAY_SIZE(npc_kpu_profiles);
 	profile->lt_def = &npc_lt_defaults;
 	profile->mkex = &npc_mkex_default;
-	profile->mkex_hash = &npc_mkex_hash_default;
 
 	return 0;
 }
@@ -1844,6 +1819,7 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	mcam->hprio_count = mcam->lprio_count;
 	mcam->hprio_end = mcam->hprio_count;
 
+
 	/* Allocate bitmap for managing MCAM counters and memory
 	 * for saving counter to RVU PFFUNC allocation mapping.
 	 */
@@ -2071,7 +2047,6 @@ int rvu_npc_init(struct rvu *rvu)
 
 	rvu_npc_setup_interfaces(rvu, blkaddr);
 
-	npc_config_secret_key(rvu, blkaddr);
 	/* Configure MKEX profile */
 	npc_load_mkex_profile(rvu, blkaddr, rvu->mkex_pfl_name);
 
@@ -2587,14 +2562,6 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 	return 0;
 }
 
-/* Marks bitmaps to reserved the mcam slot */
-void npc_mcam_rsrcs_reserve(struct rvu *rvu, int blkaddr, int entry_idx)
-{
-	struct npc_mcam *mcam = &rvu->hw->mcam;
-
-	npc_mcam_set_bit(mcam, entry_idx);
-}
-
 int rvu_mbox_handler_npc_mcam_alloc_entry(struct rvu *rvu,
 					  struct npc_mcam_alloc_entry_req *req,
 					  struct npc_mcam_alloc_entry_rsp *rsp)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 5cfad8ac5a50..19c53e591d0d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -10,9 +10,6 @@
 #include "rvu_reg.h"
 #include "rvu.h"
 #include "npc.h"
-#include "rvu_npc_fs.h"
-#include "npc_profile.h"
-#include "rvu_npc_hash.h"
 
 #define NPC_BYTESM		GENMASK_ULL(19, 16)
 #define NPC_HDR_OFFSET		GENMASK_ULL(15, 8)
@@ -230,25 +227,6 @@ static bool npc_check_field(struct rvu *rvu, int blkaddr, enum key_fields type,
 	return true;
 }
 
-static void npc_scan_exact_result(struct npc_mcam *mcam, u8 bit_number,
-				  u8 key_nibble, u8 intf)
-{
-	u8 offset = (key_nibble * 4) % 64; /* offset within key word */
-	u8 kwi = (key_nibble * 4) / 64; /* which word in key */
-	u8 nr_bits = 4; /* bits in a nibble */
-	u8 type;
-
-	switch (bit_number) {
-	case 40 ... 43:
-		type = NPC_EXACT_RESULT;
-		break;
-
-	default:
-		return;
-	}
-	npc_set_kw_masks(mcam, type, nr_bits, kwi, offset, intf);
-}
-
 static void npc_scan_parse_result(struct npc_mcam *mcam, u8 bit_number,
 				  u8 key_nibble, u8 intf)
 {
@@ -298,7 +276,6 @@ static void npc_scan_parse_result(struct npc_mcam *mcam, u8 bit_number,
 	default:
 		return;
 	}
-
 	npc_set_kw_masks(mcam, type, nr_bits, kwi, offset, intf);
 }
 
@@ -532,8 +509,8 @@ static int npc_scan_kex(struct rvu *rvu, int blkaddr, u8 intf)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u8 lid, lt, ld, bitnr;
-	u64 cfg, masked_cfg;
 	u8 key_nibble = 0;
+	u64 cfg;
 
 	/* Scan and note how parse result is going to be in key.
 	 * A bit set in PARSE_NIBBLE_ENA corresponds to a nibble from
@@ -541,24 +518,12 @@ static int npc_scan_kex(struct rvu *rvu, int blkaddr, u8 intf)
 	 * will be concatenated in key.
 	 */
 	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(intf));
-	masked_cfg = cfg & NPC_PARSE_NIBBLE;
-	for_each_set_bit(bitnr, (unsigned long *)&masked_cfg, 31) {
+	cfg &= NPC_PARSE_NIBBLE;
+	for_each_set_bit(bitnr, (unsigned long *)&cfg, 31) {
 		npc_scan_parse_result(mcam, bitnr, key_nibble, intf);
 		key_nibble++;
 	}
 
-	/* Ignore exact match bits for mcam entries except the first rule
-	 * which is drop on hit. This first rule is configured explitcitly by
-	 * exact match code.
-	 */
-	masked_cfg = cfg & NPC_EXACT_NIBBLE;
-	bitnr = NPC_EXACT_NIBBLE_START;
-	for_each_set_bit_from(bitnr, (unsigned long *)&masked_cfg,
-			      NPC_EXACT_NIBBLE_START) {
-		npc_scan_exact_result(mcam, bitnr, key_nibble, intf);
-		key_nibble++;
-	}
-
 	/* Scan and note how layer data is going to be in key */
 	for (lid = 0; lid < NPC_MAX_LID; lid++) {
 		for (lt = 0; lt < NPC_MAX_LT; lt++) {
@@ -659,9 +624,9 @@ static int npc_check_unsupported_flows(struct rvu *rvu, u64 features, u8 intf)
  * If any bits in mask are 0 then corresponding bits in value are
  * dont care.
  */
-void npc_update_entry(struct rvu *rvu, enum key_fields type,
-		      struct mcam_entry *entry, u64 val_lo,
-		      u64 val_hi, u64 mask_lo, u64 mask_hi, u8 intf)
+static void npc_update_entry(struct rvu *rvu, enum key_fields type,
+			     struct mcam_entry *entry, u64 val_lo,
+			     u64 val_hi, u64 mask_lo, u64 mask_hi, u8 intf)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	struct mcam_entry dummy = { {0} };
@@ -740,6 +705,8 @@ void npc_update_entry(struct rvu *rvu, enum key_fields type,
 	}
 }
 
+#define IPV6_WORDS     4
+
 static void npc_update_ipv6_flow(struct rvu *rvu, struct mcam_entry *entry,
 				 u64 features, struct flow_msg *pkt,
 				 struct flow_msg *mask,
@@ -812,8 +779,7 @@ static void npc_update_vlan_features(struct rvu *rvu, struct mcam_entry *entry,
 static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
 			    u64 features, struct flow_msg *pkt,
 			    struct flow_msg *mask,
-			    struct rvu_npc_mcam_rule *output, u8 intf,
-			    int blkaddr)
+			    struct rvu_npc_mcam_rule *output, u8 intf)
 {
 	u64 dmac_mask = ether_addr_to_u64(mask->dmac);
 	u64 smac_mask = ether_addr_to_u64(mask->smac);
@@ -862,7 +828,6 @@ do {									      \
 } while (0)
 
 	NPC_WRITE_FLOW(NPC_DMAC, dmac, dmac_val, 0, dmac_mask, 0);
-
 	NPC_WRITE_FLOW(NPC_SMAC, smac, smac_val, 0, smac_mask, 0);
 	NPC_WRITE_FLOW(NPC_ETYPE, etype, ntohs(pkt->etype), 0,
 		       ntohs(mask->etype), 0);
@@ -889,12 +854,10 @@ do {									      \
 
 	npc_update_ipv6_flow(rvu, entry, features, pkt, mask, output, intf);
 	npc_update_vlan_features(rvu, entry, features, intf);
-
-	npc_update_field_hash(rvu, intf, entry, blkaddr, features,
-			      pkt, mask, opkt, omask);
 }
 
-static struct rvu_npc_mcam_rule *rvu_mcam_find_rule(struct npc_mcam *mcam, u16 entry)
+static struct rvu_npc_mcam_rule *rvu_mcam_find_rule(struct npc_mcam *mcam,
+						    u16 entry)
 {
 	struct rvu_npc_mcam_rule *iter;
 
@@ -1060,9 +1023,8 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	u16 owner = req->hdr.pcifunc;
 	struct msg_rsp write_rsp;
 	struct mcam_entry *entry;
+	int entry_index, err;
 	bool new = false;
-	u16 entry_index;
-	int err;
 
 	installed_features = req->features;
 	features = req->features;
@@ -1070,7 +1032,7 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	entry_index = req->entry;
 
 	npc_update_flow(rvu, entry, features, &req->packet, &req->mask, &dummy,
-			req->intf, blkaddr);
+			req->intf);
 
 	if (is_npc_intf_rx(req->intf))
 		npc_update_rx_entry(rvu, pfvf, entry, req, target, pf_set_vfs_mac);
@@ -1095,8 +1057,7 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 			npc_update_flow(rvu, entry, missing_features,
 					&def_ucast_rule->packet,
 					&def_ucast_rule->mask,
-					&dummy, req->intf,
-					blkaddr);
+					&dummy, req->intf);
 		installed_features = req->features | missing_features;
 	}
 
@@ -1463,98 +1424,3 @@ void npc_mcam_disable_flows(struct rvu *rvu, u16 target)
 	}
 	mutex_unlock(&mcam->lock);
 }
-
-/* single drop on non hit rule starting from 0th index. This an extension
- * to RPM mac filter to support more rules.
- */
-int npc_install_mcam_drop_rule(struct rvu *rvu, int mcam_idx, u16 *counter_idx,
-			       u64 chan_val, u64 chan_mask, u64 exact_val, u64 exact_mask,
-			       u64 bcast_mcast_val, u64 bcast_mcast_mask)
-{
-	struct npc_mcam_alloc_counter_req cntr_req = { 0 };
-	struct npc_mcam_alloc_counter_rsp cntr_rsp = { 0 };
-	struct npc_mcam_write_entry_req req = { 0 };
-	struct npc_mcam *mcam = &rvu->hw->mcam;
-	struct rvu_npc_mcam_rule *rule;
-	struct msg_rsp rsp;
-	bool enabled;
-	int blkaddr;
-	int err;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-	if (blkaddr < 0) {
-		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
-		return -ENODEV;
-	}
-
-	/* Bail out if no exact match support */
-	if (!rvu_npc_exact_has_match_table(rvu)) {
-		dev_info(rvu->dev, "%s: No support for exact match feature\n", __func__);
-		return -EINVAL;
-	}
-
-	/* If 0th entry is already used, return err */
-	enabled = is_mcam_entry_enabled(rvu, mcam, blkaddr, mcam_idx);
-	if (enabled) {
-		dev_err(rvu->dev, "%s: failed to add single drop on non hit rule at %d th index\n",
-			__func__, mcam_idx);
-		return	-EINVAL;
-	}
-
-	/* Add this entry to mcam rules list */
-	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
-	if (!rule)
-		return -ENOMEM;
-
-	/* Disable rule by default. Enable rule when first dmac filter is
-	 * installed
-	 */
-	rule->enable = false;
-	rule->chan = chan_val;
-	rule->chan_mask = chan_mask;
-	rule->entry = mcam_idx;
-	rvu_mcam_add_rule(mcam, rule);
-
-	/* Reserve slot 0 */
-	npc_mcam_rsrcs_reserve(rvu, blkaddr, mcam_idx);
-
-	/* Allocate counter for this single drop on non hit rule */
-	cntr_req.hdr.pcifunc = 0; /* AF request */
-	cntr_req.contig = true;
-	cntr_req.count = 1;
-	err = rvu_mbox_handler_npc_mcam_alloc_counter(rvu, &cntr_req, &cntr_rsp);
-	if (err) {
-		dev_err(rvu->dev, "%s: Err to allocate cntr for drop rule (err=%d)\n",
-			__func__, err);
-		return	-EFAULT;
-	}
-	*counter_idx = cntr_rsp.cntr;
-
-	/* Fill in fields for this mcam entry */
-	npc_update_entry(rvu, NPC_EXACT_RESULT, &req.entry_data, exact_val, 0,
-			 exact_mask, 0, NIX_INTF_RX);
-	npc_update_entry(rvu, NPC_CHAN, &req.entry_data, chan_val, 0,
-			 chan_mask, 0, NIX_INTF_RX);
-	npc_update_entry(rvu, NPC_LXMB, &req.entry_data, bcast_mcast_val, 0,
-			 bcast_mcast_mask, 0, NIX_INTF_RX);
-
-	req.intf = NIX_INTF_RX;
-	req.set_cntr = true;
-	req.cntr = cntr_rsp.cntr;
-	req.entry = mcam_idx;
-
-	err = rvu_mbox_handler_npc_mcam_write_entry(rvu, &req, &rsp);
-	if (err) {
-		dev_err(rvu->dev, "%s: Installation of single drop on non hit rule at %d failed\n",
-			__func__, mcam_idx);
-		return err;
-	}
-
-	dev_err(rvu->dev, "%s: Installed single drop on non hit rule at %d, cntr=%d\n",
-		__func__, mcam_idx, req.cntr);
-
-	/* disable entry at Bank 0, index 0 */
-	npc_enable_mcam_entry(rvu, mcam, blkaddr, mcam_idx, false);
-
-	return 0;
-}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
deleted file mode 100644
index bdd65ce56a32..000000000000
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Marvell RVU Admin Function driver
- *
- * Copyright (C) 2022 Marvell.
- *
- */
-
-#ifndef __RVU_NPC_FS_H
-#define __RVU_NPC_FS_H
-
-#define IPV6_WORDS	4
-
-void npc_update_entry(struct rvu *rvu, enum key_fields type,
-		      struct mcam_entry *entry, u64 val_lo,
-		      u64 val_hi, u64 mask_lo, u64 mask_hi, u8 intf);
-
-#endif /* RVU_NPC_FS_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
deleted file mode 100644
index d3e6f7887ded..000000000000
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ /dev/null
@@ -1,1958 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Marvell RVU Admin Function driver
- *
- * Copyright (C) 2022 Marvell.
- *
- */
-
-#include <linux/bitfield.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/firmware.h>
-#include <linux/stddef.h>
-#include <linux/debugfs.h>
-#include <linux/bitfield.h>
-
-#include "rvu_struct.h"
-#include "rvu_reg.h"
-#include "rvu.h"
-#include "npc.h"
-#include "cgx.h"
-#include "rvu_npc_hash.h"
-#include "rvu_npc_fs.h"
-#include "rvu_npc_hash.h"
-
-static u64 rvu_npc_wide_extract(const u64 input[], size_t start_bit,
-				size_t width_bits)
-{
-	const u64 mask = ~(u64)((~(__uint128_t)0) << width_bits);
-	const size_t msb = start_bit + width_bits - 1;
-	const size_t lword = start_bit >> 6;
-	const size_t uword = msb >> 6;
-	size_t lbits;
-	u64 hi, lo;
-
-	if (lword == uword)
-		return (input[lword] >> (start_bit & 63)) & mask;
-
-	lbits = 64 - (start_bit & 63);
-	hi = input[uword];
-	lo = (input[lword] >> (start_bit & 63));
-	return ((hi << lbits) | lo) & mask;
-}
-
-static void rvu_npc_lshift_key(u64 *key, size_t key_bit_len)
-{
-	u64 prev_orig_word = 0;
-	u64 cur_orig_word = 0;
-	size_t extra = key_bit_len % 64;
-	size_t max_idx = key_bit_len / 64;
-	size_t i;
-
-	if (extra)
-		max_idx++;
-
-	for (i = 0; i < max_idx; i++) {
-		cur_orig_word = key[i];
-		key[i] = key[i] << 1;
-		key[i] |= ((prev_orig_word >> 63) & 0x1);
-		prev_orig_word = cur_orig_word;
-	}
-}
-
-static u32 rvu_npc_toeplitz_hash(const u64 *data, u64 *key, size_t data_bit_len,
-				 size_t key_bit_len)
-{
-	u32 hash_out = 0;
-	u64 temp_data = 0;
-	int i;
-
-	for (i = data_bit_len - 1; i >= 0; i--) {
-		temp_data = (data[i / 64]);
-		temp_data = temp_data >> (i % 64);
-		temp_data &= 0x1;
-		if (temp_data)
-			hash_out ^= (u32)(rvu_npc_wide_extract(key, key_bit_len - 32, 32));
-
-		rvu_npc_lshift_key(key, key_bit_len);
-	}
-
-	return hash_out;
-}
-
-u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash *mkex_hash,
-			u64 *secret_key, u8 intf, u8 hash_idx)
-{
-	u64 hash_key[3];
-	u64 data_padded[2];
-	u32 field_hash;
-
-	hash_key[0] = secret_key[1] << 31;
-	hash_key[0] |= secret_key[2];
-	hash_key[1] = secret_key[1] >> 33;
-	hash_key[1] |= secret_key[0] << 31;
-	hash_key[2] = secret_key[0] >> 33;
-
-	data_padded[0] = mkex_hash->hash_mask[intf][hash_idx][0] & ldata[0];
-	data_padded[1] = mkex_hash->hash_mask[intf][hash_idx][1] & ldata[1];
-	field_hash = rvu_npc_toeplitz_hash(data_padded, hash_key, 128, 159);
-
-	field_hash &= mkex_hash->hash_ctrl[intf][hash_idx] >> 32;
-	field_hash |= mkex_hash->hash_ctrl[intf][hash_idx];
-	return field_hash;
-}
-
-static u64 npc_update_use_hash(int lt, int ld)
-{
-	u64 cfg = 0;
-
-	switch (lt) {
-	case NPC_LT_LC_IP6:
-		/* Update use_hash(bit-20) and bytesm1 (bit-16:19)
-		 * in KEX_LD_CFG
-		 */
-		cfg = KEX_LD_CFG_USE_HASH(0x1, 0x03,
-					  ld ? 0x8 : 0x18,
-					  0x1, 0x0, 0x10);
-		break;
-	}
-
-	return cfg;
-}
-
-static void npc_program_mkex_hash_rx(struct rvu *rvu, int blkaddr,
-				     u8 intf)
-{
-	struct npc_mcam_kex_hash *mkex_hash = rvu->kpu.mkex_hash;
-	int lid, lt, ld, hash_cnt = 0;
-
-	if (is_npc_intf_tx(intf))
-		return;
-
-	/* Program HASH_CFG */
-	for (lid = 0; lid < NPC_MAX_LID; lid++) {
-		for (lt = 0; lt < NPC_MAX_LT; lt++) {
-			for (ld = 0; ld < NPC_MAX_LD; ld++) {
-				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
-					u64 cfg = npc_update_use_hash(lt, ld);
-
-					hash_cnt++;
-					if (hash_cnt == NPC_MAX_HASH)
-						return;
-
-					/* Set updated KEX configuration */
-					SET_KEX_LD(intf, lid, lt, ld, cfg);
-					/* Set HASH configuration */
-					SET_KEX_LD_HASH(intf, ld,
-							mkex_hash->hash[intf][ld]);
-					SET_KEX_LD_HASH_MASK(intf, ld, 0,
-							     mkex_hash->hash_mask[intf][ld][0]);
-					SET_KEX_LD_HASH_MASK(intf, ld, 1,
-							     mkex_hash->hash_mask[intf][ld][1]);
-					SET_KEX_LD_HASH_CTRL(intf, ld,
-							     mkex_hash->hash_ctrl[intf][ld]);
-				}
-			}
-		}
-	}
-}
-
-static void npc_program_mkex_hash_tx(struct rvu *rvu, int blkaddr,
-				     u8 intf)
-{
-	struct npc_mcam_kex_hash *mkex_hash = rvu->kpu.mkex_hash;
-	int lid, lt, ld, hash_cnt = 0;
-
-	if (is_npc_intf_rx(intf))
-		return;
-
-	/* Program HASH_CFG */
-	for (lid = 0; lid < NPC_MAX_LID; lid++) {
-		for (lt = 0; lt < NPC_MAX_LT; lt++) {
-			for (ld = 0; ld < NPC_MAX_LD; ld++)
-				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
-					u64 cfg = npc_update_use_hash(lt, ld);
-
-					hash_cnt++;
-					if (hash_cnt == NPC_MAX_HASH)
-						return;
-
-					/* Set updated KEX configuration */
-					SET_KEX_LD(intf, lid, lt, ld, cfg);
-					/* Set HASH configuration */
-					SET_KEX_LD_HASH(intf, ld,
-							mkex_hash->hash[intf][ld]);
-					SET_KEX_LD_HASH_MASK(intf, ld, 0,
-							     mkex_hash->hash_mask[intf][ld][0]);
-					SET_KEX_LD_HASH_MASK(intf, ld, 1,
-							     mkex_hash->hash_mask[intf][ld][1]);
-					SET_KEX_LD_HASH_CTRL(intf, ld,
-							     mkex_hash->hash_ctrl[intf][ld]);
-					hash_cnt++;
-					if (hash_cnt == NPC_MAX_HASH)
-						return;
-				}
-		}
-	}
-}
-
-void npc_config_secret_key(struct rvu *rvu, int blkaddr)
-{
-	struct hw_cap *hwcap = &rvu->hw->cap;
-	struct rvu_hwinfo *hw = rvu->hw;
-	u8 intf;
-
-	if (!hwcap->npc_hash_extract) {
-		dev_info(rvu->dev, "HW does not support secret key configuration\n");
-		return;
-	}
-
-	for (intf = 0; intf < hw->npc_intfs; intf++) {
-		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY0(intf),
-			    RVU_NPC_HASH_SECRET_KEY0);
-		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY1(intf),
-			    RVU_NPC_HASH_SECRET_KEY1);
-		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY2(intf),
-			    RVU_NPC_HASH_SECRET_KEY2);
-	}
-}
-
-void npc_program_mkex_hash(struct rvu *rvu, int blkaddr)
-{
-	struct hw_cap *hwcap = &rvu->hw->cap;
-	struct rvu_hwinfo *hw = rvu->hw;
-	u8 intf;
-
-	if (!hwcap->npc_hash_extract) {
-		dev_dbg(rvu->dev, "Field hash extract feature is not supported\n");
-		return;
-	}
-
-	for (intf = 0; intf < hw->npc_intfs; intf++) {
-		npc_program_mkex_hash_rx(rvu, blkaddr, intf);
-		npc_program_mkex_hash_tx(rvu, blkaddr, intf);
-	}
-}
-
-void npc_update_field_hash(struct rvu *rvu, u8 intf,
-			   struct mcam_entry *entry,
-			   int blkaddr,
-			   u64 features,
-			   struct flow_msg *pkt,
-			   struct flow_msg *mask,
-			   struct flow_msg *opkt,
-			   struct flow_msg *omask)
-{
-	struct npc_mcam_kex_hash *mkex_hash = rvu->kpu.mkex_hash;
-	struct npc_get_secret_key_req req;
-	struct npc_get_secret_key_rsp rsp;
-	u64 ldata[2], cfg;
-	u32 field_hash;
-	u8 hash_idx;
-
-	if (!rvu->hw->cap.npc_hash_extract) {
-		dev_dbg(rvu->dev, "%s: Field hash extract feature is not supported\n", __func__);
-		return;
-	}
-
-	req.intf = intf;
-	rvu_mbox_handler_npc_get_secret_key(rvu, &req, &rsp);
-
-	for (hash_idx = 0; hash_idx < NPC_MAX_HASH; hash_idx++) {
-		cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_HASHX_CFG(intf, hash_idx));
-		if ((cfg & BIT_ULL(11)) && (cfg & BIT_ULL(12))) {
-			u8 lid = (cfg & GENMASK_ULL(10, 8)) >> 8;
-			u8 ltype = (cfg & GENMASK_ULL(7, 4)) >> 4;
-			u8 ltype_mask = cfg & GENMASK_ULL(3, 0);
-
-			if (mkex_hash->lid_lt_ld_hash_en[intf][lid][ltype][hash_idx]) {
-				switch (ltype & ltype_mask) {
-				/* If hash extract enabled is supported for IPv6 then
-				 * 128 bit IPv6 source and destination addressed
-				 * is hashed to 32 bit value.
-				 */
-				case NPC_LT_LC_IP6:
-					if (features & BIT_ULL(NPC_SIP_IPV6)) {
-						u32 src_ip[IPV6_WORDS];
-
-						be32_to_cpu_array(src_ip, pkt->ip6src, IPV6_WORDS);
-						ldata[0] = (u64)src_ip[0] << 32 | src_ip[1];
-						ldata[1] = (u64)src_ip[2] << 32 | src_ip[3];
-						field_hash = npc_field_hash_calc(ldata,
-										 mkex_hash,
-										 rsp.secret_key,
-										 intf,
-										 hash_idx);
-						npc_update_entry(rvu, NPC_SIP_IPV6, entry,
-								 field_hash, 0, 32, 0, intf);
-						memcpy(&opkt->ip6src, &pkt->ip6src,
-						       sizeof(pkt->ip6src));
-						memcpy(&omask->ip6src, &mask->ip6src,
-						       sizeof(mask->ip6src));
-						break;
-					}
-
-					if (features & BIT_ULL(NPC_DIP_IPV6)) {
-						u32 dst_ip[IPV6_WORDS];
-
-						be32_to_cpu_array(dst_ip, pkt->ip6dst, IPV6_WORDS);
-						ldata[0] = (u64)dst_ip[0] << 32 | dst_ip[1];
-						ldata[1] = (u64)dst_ip[2] << 32 | dst_ip[3];
-						field_hash = npc_field_hash_calc(ldata,
-										 mkex_hash,
-										 rsp.secret_key,
-										 intf,
-										 hash_idx);
-						npc_update_entry(rvu, NPC_DIP_IPV6, entry,
-								 field_hash, 0, 32, 0, intf);
-						memcpy(&opkt->ip6dst, &pkt->ip6dst,
-						       sizeof(pkt->ip6dst));
-						memcpy(&omask->ip6dst, &mask->ip6dst,
-						       sizeof(mask->ip6dst));
-					}
-					break;
-				}
-			}
-		}
-	}
-}
-
-int rvu_mbox_handler_npc_get_secret_key(struct rvu *rvu,
-					struct npc_get_secret_key_req *req,
-					struct npc_get_secret_key_rsp *rsp)
-{
-	u64 *secret_key = rsp->secret_key;
-	u8 intf = req->intf;
-	int blkaddr;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-	if (blkaddr < 0) {
-		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
-		return -EINVAL;
-	}
-
-	secret_key[0] = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY0(intf));
-	secret_key[1] = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY1(intf));
-	secret_key[2] = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY2(intf));
-
-	return 0;
-}
-
-/**
- *	rvu_npc_exact_mac2u64 - utility function to convert mac address to u64.
- *	@macaddr: MAC address.
- *	Returns mdata for exact match table.
- */
-static u64 rvu_npc_exact_mac2u64(u8 *mac_addr)
-{
-	u64 mac = 0;
-	int index;
-
-	for (index = ETH_ALEN - 1; index >= 0; index--)
-		mac |= ((u64)*mac_addr++) << (8 * index);
-
-	return mac;
-}
-
-/**
- *	rvu_exact_prepare_mdata - Make mdata for mcam entry
- *	@mac: MAC address
- *	@chan: Channel number.
- *	@ctype: Channel Type.
- *	@mask: LDATA mask.
- */
-static u64 rvu_exact_prepare_mdata(u8 *mac, u16 chan, u16 ctype, u64 mask)
-{
-	u64 ldata = rvu_npc_exact_mac2u64(mac);
-
-	/* Please note that mask is 48bit which excludes chan and ctype.
-	 * Increase mask bits if we need to include them as well.
-	 */
-	ldata |= ((u64)chan << 48);
-	ldata |= ((u64)ctype  << 60);
-	ldata &= mask;
-	ldata = ldata << 2;
-
-	return ldata;
-}
-
-/**
- *      rvu_exact_calculate_hash - calculate hash index to mem table.
- *	@rvu: resource virtualization unit.
- *	@chan: Channel number
- *	@ctype: Channel type.
- *	@mac: MAC address
- *	@mask: HASH mask.
- *	@table_depth: Depth of table.
- */
-u32 rvu_exact_calculate_hash(struct rvu *rvu, u16 chan, u16 ctype, u8 *mac,
-			     u64 mask, u32 table_depth)
-{
-	struct npc_exact_table *table = rvu->hw->table;
-	u64 hash_key[2];
-	u64 key_in[2];
-	u64 ldata;
-	u32 hash;
-
-	key_in[0] = RVU_NPC_HASH_SECRET_KEY0;
-	key_in[1] = RVU_NPC_HASH_SECRET_KEY2;
-
-	hash_key[0] = key_in[0] << 31;
-	hash_key[0] |= key_in[1];
-	hash_key[1] = key_in[0] >> 33;
-
-	ldata = rvu_exact_prepare_mdata(mac, chan, ctype, mask);
-
-	dev_dbg(rvu->dev, "%s: ldata=0x%llx hash_key0=0x%llx hash_key2=0x%llx\n", __func__,
-		ldata, hash_key[1], hash_key[0]);
-	hash = rvu_npc_toeplitz_hash(&ldata, (u64 *)hash_key, 64, 95);
-
-	hash &= table->mem_table.hash_mask;
-	hash += table->mem_table.hash_offset;
-	dev_dbg(rvu->dev, "%s: hash=%x\n", __func__,  hash);
-
-	return hash;
-}
-
-/**
- *      rvu_npc_exact_alloc_mem_table_entry - find free entry in 4 way table.
- *      @rvu: resource virtualization unit.
- *	@way: Indicate way to table.
- *	@index: Hash index to 4 way table.
- *
- *	Searches 4 way table using hash index. Returns 0 on success.
- */
-static int rvu_npc_exact_alloc_mem_table_entry(struct rvu *rvu, u8 *way,
-					       u32 *index, unsigned int hash)
-{
-	struct npc_exact_table *table;
-	int depth, i;
-
-	table = rvu->hw->table;
-	depth = table->mem_table.depth;
-
-	/* Check all the 4 ways for a free slot. */
-	mutex_lock(&table->lock);
-	for (i = 0; i <  table->mem_table.ways; i++) {
-		if (test_bit(hash + i * depth, table->mem_table.bmap))
-			continue;
-
-		set_bit(hash + i * depth, table->mem_table.bmap);
-		mutex_unlock(&table->lock);
-
-		dev_dbg(rvu->dev, "%s: mem table entry alloc success (way=%d index=%d)\n",
-			__func__, i, hash);
-
-		*way = i;
-		*index = hash;
-		return 0;
-	}
-	mutex_unlock(&table->lock);
-
-	dev_dbg(rvu->dev, "%s: No space in 4 way exact way, weight=%u\n", __func__,
-		bitmap_weight(table->mem_table.bmap, table->mem_table.depth));
-	return -ENOSPC;
-}
-
-/**
- *	rvu_npc_exact_free_id - Free seq id from bitmat.
- *	@rvu: Resource virtualization unit.
- *	@seq_id: Sequence identifier to be freed.
- */
-static void rvu_npc_exact_free_id(struct rvu *rvu, u32 seq_id)
-{
-	struct npc_exact_table *table;
-
-	table = rvu->hw->table;
-	mutex_lock(&table->lock);
-	clear_bit(seq_id, table->id_bmap);
-	mutex_unlock(&table->lock);
-	dev_dbg(rvu->dev, "%s: freed id %d\n", __func__, seq_id);
-}
-
-/**
- *	rvu_npc_exact_alloc_id - Alloc seq id from bitmap.
- *	@rvu: Resource virtualization unit.
- *	@seq_id: Sequence identifier.
- */
-static bool rvu_npc_exact_alloc_id(struct rvu *rvu, u32 *seq_id)
-{
-	struct npc_exact_table *table;
-	u32 idx;
-
-	table = rvu->hw->table;
-
-	mutex_lock(&table->lock);
-	idx = find_first_zero_bit(table->id_bmap, table->tot_ids);
-	if (idx == table->tot_ids) {
-		mutex_unlock(&table->lock);
-		dev_err(rvu->dev, "%s: No space in id bitmap (%d)\n",
-			__func__, bitmap_weight(table->id_bmap, table->tot_ids));
-
-		return false;
-	}
-
-	/* Mark bit map to indicate that slot is used.*/
-	set_bit(idx, table->id_bmap);
-	mutex_unlock(&table->lock);
-
-	*seq_id = idx;
-	dev_dbg(rvu->dev, "%s: Allocated id (%d)\n", __func__, *seq_id);
-
-	return true;
-}
-
-/**
- *      rvu_npc_exact_alloc_cam_table_entry - find free slot in fully associative table.
- *      @rvu: resource virtualization unit.
- *	@index: Index to exact CAM table.
- */
-static int rvu_npc_exact_alloc_cam_table_entry(struct rvu *rvu, int *index)
-{
-	struct npc_exact_table *table;
-	u32 idx;
-
-	table = rvu->hw->table;
-
-	mutex_lock(&table->lock);
-	idx = find_first_zero_bit(table->cam_table.bmap, table->cam_table.depth);
-	if (idx == table->cam_table.depth) {
-		mutex_unlock(&table->lock);
-		dev_info(rvu->dev, "%s: No space in exact cam table, weight=%u\n", __func__,
-			 bitmap_weight(table->cam_table.bmap, table->cam_table.depth));
-		return -ENOSPC;
-	}
-
-	/* Mark bit map to indicate that slot is used.*/
-	set_bit(idx, table->cam_table.bmap);
-	mutex_unlock(&table->lock);
-
-	*index = idx;
-	dev_dbg(rvu->dev, "%s: cam table entry alloc success (index=%d)\n",
-		__func__, idx);
-	return 0;
-}
-
-/**
- *	rvu_exact_prepare_table_entry - Data for exact match table entry.
- *	@rvu: Resource virtualization unit.
- *	@enable: Enable/Disable entry
- *	@ctype: Software defined channel type. Currently set as 0.
- *	@chan: Channel number.
- *	@mac_addr: Destination mac address.
- *	returns mdata for exact match table.
- */
-static u64 rvu_exact_prepare_table_entry(struct rvu *rvu, bool enable,
-					 u8 ctype, u16 chan, u8 *mac_addr)
-
-{
-	u64 ldata = rvu_npc_exact_mac2u64(mac_addr);
-
-	/* Enable or disable */
-	u64 mdata = FIELD_PREP(GENMASK_ULL(63, 63), !!enable);
-
-	/* Set Ctype */
-	mdata |= FIELD_PREP(GENMASK_ULL(61, 60), ctype);
-
-	/* Set chan */
-	mdata |= FIELD_PREP(GENMASK_ULL(59, 48), chan);
-
-	/* MAC address */
-	mdata |= FIELD_PREP(GENMASK_ULL(47, 0), ldata);
-
-	return mdata;
-}
-
-/**
- *	rvu_exact_config_secret_key - Configure secret key.
- *	Returns mdata for exact match table.
- */
-static void rvu_exact_config_secret_key(struct rvu *rvu)
-{
-	int blkaddr;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_SECRET0(NIX_INTF_RX),
-		    RVU_NPC_HASH_SECRET_KEY0);
-
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_SECRET1(NIX_INTF_RX),
-		    RVU_NPC_HASH_SECRET_KEY1);
-
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_SECRET2(NIX_INTF_RX),
-		    RVU_NPC_HASH_SECRET_KEY2);
-}
-
-/**
- *	rvu_exact_config_search_key - Configure search key
- *	Returns mdata for exact match table.
- */
-static void rvu_exact_config_search_key(struct rvu *rvu)
-{
-	int blkaddr;
-	u64 reg_val;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-
-	/* HDR offset */
-	reg_val = FIELD_PREP(GENMASK_ULL(39, 32), 0);
-
-	/* BYTESM1, number of bytes - 1 */
-	reg_val |= FIELD_PREP(GENMASK_ULL(18, 16), ETH_ALEN - 1);
-
-	/* Enable LID and set LID to  NPC_LID_LA */
-	reg_val |= FIELD_PREP(GENMASK_ULL(11, 11), 1);
-	reg_val |= FIELD_PREP(GENMASK_ULL(10, 8),  NPC_LID_LA);
-
-	/* Clear layer type based extraction */
-
-	/* Disable LT_EN */
-	reg_val |= FIELD_PREP(GENMASK_ULL(12, 12), 0);
-
-	/* Set LTYPE_MATCH to 0 */
-	reg_val |= FIELD_PREP(GENMASK_ULL(7, 4), 0);
-
-	/* Set LTYPE_MASK to 0 */
-	reg_val |= FIELD_PREP(GENMASK_ULL(3, 0), 0);
-
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_CFG(NIX_INTF_RX), reg_val);
-}
-
-/**
- *	rvu_exact_config_result_ctrl - Set exact table hash control
- *	@rvu: Resource virtualization unit.
- *	@depth: Depth of Exact match table.
- *
- *	Sets mask and offset for hash for mem table.
- */
-static void rvu_exact_config_result_ctrl(struct rvu *rvu, uint32_t depth)
-{
-	int blkaddr;
-	u64 reg = 0;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-
-	/* Set mask. Note that depth is a power of 2 */
-	rvu->hw->table->mem_table.hash_mask = (depth - 1);
-	reg |= FIELD_PREP(GENMASK_ULL(42, 32), (depth - 1));
-
-	/* Set offset as 0 */
-	rvu->hw->table->mem_table.hash_offset = 0;
-	reg |= FIELD_PREP(GENMASK_ULL(10, 0), 0);
-
-	/* Set reg for RX */
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_RESULT_CTL(NIX_INTF_RX), reg);
-	/* Store hash mask and offset for s/w algorithm */
-}
-
-/**
- *	rvu_exact_config_table_mask - Set exact table mask.
- *	@rvu: Resource virtualization unit.
- */
-static void rvu_exact_config_table_mask(struct rvu *rvu)
-{
-	int blkaddr;
-	u64 mask = 0;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-
-	/* Don't use Ctype */
-	mask |= FIELD_PREP(GENMASK_ULL(61, 60), 0);
-
-	/* Set chan */
-	mask |= GENMASK_ULL(59, 48);
-
-	/* Full ldata */
-	mask |= GENMASK_ULL(47, 0);
-
-	/* Store mask for s/w hash calcualtion */
-	rvu->hw->table->mem_table.mask = mask;
-
-	/* Set mask for RX.*/
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_MASK(NIX_INTF_RX), mask);
-}
-
-/**
- *      rvu_npc_exact_get_max_entries - Get total number of entries in table.
- *      @rvu: resource virtualization unit.
- */
-u32 rvu_npc_exact_get_max_entries(struct rvu *rvu)
-{
-	struct npc_exact_table *table;
-
-	table = rvu->hw->table;
-	return table->tot_ids;
-}
-
-/**
- *      rvu_npc_exact_has_match_table - Checks support for exact match.
- *      @rvu: resource virtualization unit.
- *
- */
-bool rvu_npc_exact_has_match_table(struct rvu *rvu)
-{
-	return  rvu->hw->cap.npc_exact_match_enabled;
-}
-
-/**
- *      __rvu_npc_exact_find_entry_by_seq_id - find entry by id
- *      @rvu: resource virtualization unit.
- *	@seq_id: Sequence identifier.
- *
- *	Caller should acquire the lock.
- */
-static struct npc_exact_table_entry *
-__rvu_npc_exact_find_entry_by_seq_id(struct rvu *rvu, u32 seq_id)
-{
-	struct npc_exact_table *table = rvu->hw->table;
-	struct npc_exact_table_entry *entry = NULL;
-	struct list_head *lhead;
-
-	lhead = &table->lhead_gbl;
-
-	/* traverse to find the matching entry */
-	list_for_each_entry(entry, lhead, glist) {
-		if (entry->seq_id != seq_id)
-			continue;
-
-		return entry;
-	}
-
-	return NULL;
-}
-
-/**
- *      rvu_npc_exact_add_to_list - Add entry to list
- *      @rvu: resource virtualization unit.
- *	@opc_type: OPCODE to select MEM/CAM table.
- *	@ways: MEM table ways.
- *	@index: Index in MEM/CAM table.
- *	@cgx_id: CGX identifier.
- *	@lamc_id: LMAC identifier.
- *	@mac_addr: MAC address.
- *	@chan: Channel number.
- *	@ctype: Channel Type.
- *	@seq_id: Sequence identifier
- *	@cmd: True if function is called by ethtool cmd
- *	@mcam_idx: NPC mcam index of DMAC entry in NPC mcam.
- *	@pcifunc: pci function
- */
-static int rvu_npc_exact_add_to_list(struct rvu *rvu, enum npc_exact_opc_type opc_type, u8 ways,
-				     u32 index, u8 cgx_id, u8 lmac_id, u8 *mac_addr, u16 chan,
-				     u8 ctype, u32 *seq_id, bool cmd, u32 mcam_idx, u16 pcifunc)
-{
-	struct npc_exact_table_entry *entry, *tmp, *iter;
-	struct npc_exact_table *table = rvu->hw->table;
-	struct list_head *lhead, *pprev;
-
-	WARN_ON(ways >= NPC_EXACT_TBL_MAX_WAYS);
-
-	if (!rvu_npc_exact_alloc_id(rvu, seq_id)) {
-		dev_err(rvu->dev, "%s: Generate seq id failed\n", __func__);
-		return -EFAULT;
-	}
-
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry) {
-		rvu_npc_exact_free_id(rvu, *seq_id);
-		dev_err(rvu->dev, "%s: Memory allocation failed\n", __func__);
-		return -ENOMEM;
-	}
-
-	mutex_lock(&table->lock);
-	switch (opc_type) {
-	case NPC_EXACT_OPC_CAM:
-		lhead = &table->lhead_cam_tbl_entry;
-		table->cam_tbl_entry_cnt++;
-		break;
-
-	case NPC_EXACT_OPC_MEM:
-		lhead = &table->lhead_mem_tbl_entry[ways];
-		table->mem_tbl_entry_cnt++;
-		break;
-
-	default:
-		mutex_unlock(&table->lock);
-		kfree(entry);
-		rvu_npc_exact_free_id(rvu, *seq_id);
-
-		dev_err(rvu->dev, "%s: Unknown opc type%d\n", __func__, opc_type);
-		return  -EINVAL;
-	}
-
-	/* Add to global list */
-	INIT_LIST_HEAD(&entry->glist);
-	list_add_tail(&entry->glist, &table->lhead_gbl);
-	INIT_LIST_HEAD(&entry->list);
-	entry->index = index;
-	entry->ways = ways;
-	entry->opc_type = opc_type;
-
-	entry->pcifunc = pcifunc;
-
-	ether_addr_copy(entry->mac, mac_addr);
-	entry->chan = chan;
-	entry->ctype = ctype;
-	entry->cgx_id = cgx_id;
-	entry->lmac_id = lmac_id;
-
-	entry->seq_id = *seq_id;
-
-	entry->mcam_idx = mcam_idx;
-	entry->cmd = cmd;
-
-	pprev = lhead;
-
-	/* Insert entry in ascending order of index */
-	list_for_each_entry_safe(iter, tmp, lhead, list) {
-		if (index < iter->index)
-			break;
-
-		pprev = &iter->list;
-	}
-
-	/* Add to each table list */
-	list_add(&entry->list, pprev);
-	mutex_unlock(&table->lock);
-	return 0;
-}
-
-/**
- *	rvu_npc_exact_mem_table_write - Wrapper for register write
- *	@rvu: resource virtualization unit.
- *	@blkaddr: Block address
- *	@ways: ways for MEM table.
- *	@index: Index in MEM
- *	@mdata: Meta data to be written to register.
- */
-static void rvu_npc_exact_mem_table_write(struct rvu *rvu, int blkaddr, u8 ways,
-					  u32 index, u64 mdata)
-{
-	rvu_write64(rvu, blkaddr, NPC_AF_EXACT_MEM_ENTRY(ways, index), mdata);
-}
-
-/**
- *	rvu_npc_exact_cam_table_write - Wrapper for register write
- *	@rvu: resource virtualization unit.
- *	@blkaddr: Block address
- *	@index: Index in MEM
- *	@mdata: Meta data to be written to register.
- */
-static void rvu_npc_exact_cam_table_write(struct rvu *rvu, int blkaddr,
-					  u32 index, u64 mdata)
-{
-	rvu_write64(rvu, blkaddr, NPC_AF_EXACT_CAM_ENTRY(index), mdata);
-}
-
-/**
- *      rvu_npc_exact_dealloc_table_entry - dealloc table entry
- *      @rvu: resource virtualization unit.
- *	@opc_type: OPCODE for selection of table(MEM or CAM)
- *	@ways: ways if opc_type is MEM table.
- *	@index: Index of MEM or CAM table.
- */
-static int rvu_npc_exact_dealloc_table_entry(struct rvu *rvu, enum npc_exact_opc_type opc_type,
-					     u8 ways, u32 index)
-{
-	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-	struct npc_exact_table *table;
-	u8 null_dmac[6] = { 0 };
-	int depth;
-
-	/* Prepare entry with all fields set to zero */
-	u64 null_mdata = rvu_exact_prepare_table_entry(rvu, false, 0, 0, null_dmac);
-
-	table = rvu->hw->table;
-	depth = table->mem_table.depth;
-
-	mutex_lock(&table->lock);
-
-	switch (opc_type) {
-	case NPC_EXACT_OPC_CAM:
-
-		/* Check whether entry is used already */
-		if (!test_bit(index, table->cam_table.bmap)) {
-			mutex_unlock(&table->lock);
-			dev_err(rvu->dev, "%s: Trying to free an unused entry ways=%d index=%d\n",
-				__func__, ways, index);
-			return -EINVAL;
-		}
-
-		rvu_npc_exact_cam_table_write(rvu, blkaddr, index, null_mdata);
-		clear_bit(index, table->cam_table.bmap);
-		break;
-
-	case NPC_EXACT_OPC_MEM:
-
-		/* Check whether entry is used already */
-		if (!test_bit(index + ways * depth, table->mem_table.bmap)) {
-			mutex_unlock(&table->lock);
-			dev_err(rvu->dev, "%s: Trying to free an unused entry index=%d\n",
-				__func__, index);
-			return -EINVAL;
-		}
-
-		rvu_npc_exact_mem_table_write(rvu, blkaddr, ways, index, null_mdata);
-		clear_bit(index + ways * depth, table->mem_table.bmap);
-		break;
-
-	default:
-		mutex_unlock(&table->lock);
-		dev_err(rvu->dev, "%s: invalid opc type %d", __func__, opc_type);
-		return -ENOSPC;
-	}
-
-	mutex_unlock(&table->lock);
-
-	dev_dbg(rvu->dev, "%s: Successfully deleted entry (index=%d, ways=%d opc_type=%d\n",
-		__func__, index,  ways, opc_type);
-
-	return 0;
-}
-
-/**
- *	rvu_npc_exact_alloc_table_entry - Allociate an entry
- *      @rvu: resource virtualization unit.
- *	@mac: MAC address.
- *	@chan: Channel number.
- *	@ctype: Channel Type.
- *	@index: Index of MEM table or CAM table.
- *	@ways: Ways. Only valid for MEM table.
- *	@opc_type: OPCODE to select table (MEM or CAM)
- *
- *	Try allocating a slot from MEM table. If all 4 ways
- *	slot are full for a hash index, check availability in
- *	32-entry CAM table for allocation.
- */
-static int rvu_npc_exact_alloc_table_entry(struct rvu *rvu,  char *mac, u16 chan, u8 ctype,
-					   u32 *index, u8 *ways, enum npc_exact_opc_type *opc_type)
-{
-	struct npc_exact_table *table;
-	unsigned int hash;
-	int err;
-
-	table = rvu->hw->table;
-
-	/* Check in 4-ways mem entry for free slote */
-	hash =  rvu_exact_calculate_hash(rvu, chan, ctype, mac, table->mem_table.mask,
-					 table->mem_table.depth);
-	err = rvu_npc_exact_alloc_mem_table_entry(rvu, ways, index, hash);
-	if (!err) {
-		*opc_type = NPC_EXACT_OPC_MEM;
-		dev_dbg(rvu->dev, "%s: inserted in 4 ways hash table ways=%d, index=%d\n",
-			__func__, *ways, *index);
-		return 0;
-	}
-
-	dev_dbg(rvu->dev, "%s: failed to insert in 4 ways hash table\n", __func__);
-
-	/* wayss is 0 for cam table */
-	*ways = 0;
-	err = rvu_npc_exact_alloc_cam_table_entry(rvu, index);
-	if (!err) {
-		*opc_type = NPC_EXACT_OPC_CAM;
-		dev_dbg(rvu->dev, "%s: inserted in fully associative hash table index=%u\n",
-			__func__, *index);
-		return 0;
-	}
-
-	dev_err(rvu->dev, "%s: failed to insert in fully associative hash table\n", __func__);
-	return -ENOSPC;
-}
-
-/**
- *	rvu_npc_exact_save_drop_rule_chan_and_mask - Save drop rules info in data base.
- *      @rvu: resource virtualization unit.
- *	@drop_mcam_idx: Drop rule index in NPC mcam.
- *	@chan_val: Channel value.
- *	@chan_mask: Channel Mask.
- *	@pcifunc: pcifunc of interface.
- */
-static bool rvu_npc_exact_save_drop_rule_chan_and_mask(struct rvu *rvu, int drop_mcam_idx,
-						       u64 chan_val, u64 chan_mask, u16 pcifunc)
-{
-	struct npc_exact_table *table;
-	int i;
-
-	table = rvu->hw->table;
-
-	for (i = 0; i < NPC_MCAM_DROP_RULE_MAX; i++) {
-		if (!table->drop_rule_map[i].valid)
-			break;
-
-		if (table->drop_rule_map[i].chan_val != (u16)chan_val)
-			continue;
-
-		if (table->drop_rule_map[i].chan_mask != (u16)chan_mask)
-			continue;
-
-		return false;
-	}
-
-	if (i == NPC_MCAM_DROP_RULE_MAX)
-		return false;
-
-	table->drop_rule_map[i].drop_rule_idx = drop_mcam_idx;
-	table->drop_rule_map[i].chan_val = (u16)chan_val;
-	table->drop_rule_map[i].chan_mask = (u16)chan_mask;
-	table->drop_rule_map[i].pcifunc = pcifunc;
-	table->drop_rule_map[i].valid = true;
-	return true;
-}
-
-/**
- *	rvu_npc_exact_calc_drop_rule_chan_and_mask - Calculate Channel number and mask.
- *      @rvu: resource virtualization unit.
- *	@intf_type: Interface type (SDK, LBK or CGX)
- *	@cgx_id: CGX identifier.
- *	@lmac_id: LAMC identifier.
- *	@val: Channel number.
- *	@mask: Channel mask.
- */
-static bool rvu_npc_exact_calc_drop_rule_chan_and_mask(struct rvu *rvu, u8 intf_type,
-						       u8 cgx_id, u8 lmac_id,
-						       u64 *val, u64 *mask)
-{
-	u16 chan_val, chan_mask;
-
-	/* No support for SDP and LBK */
-	if (intf_type != NIX_INTF_TYPE_CGX)
-		return false;
-
-	chan_val = rvu_nix_chan_cgx(rvu, cgx_id, lmac_id, 0);
-	chan_mask = 0xfff;
-
-	if (val)
-		*val = chan_val;
-
-	if (mask)
-		*mask = chan_mask;
-
-	return true;
-}
-
-/**
- *	rvu_npc_exact_drop_rule_to_pcifunc - Retrieve pcifunc
- *      @rvu: resource virtualization unit.
- *	@drop_rule_idx: Drop rule index in NPC mcam.
- *
- *	Debugfs (exact_drop_cnt) entry displays pcifunc for interface
- *	by retrieving the pcifunc value from data base.
- */
-u16 rvu_npc_exact_drop_rule_to_pcifunc(struct rvu *rvu, u32 drop_rule_idx)
-{
-	struct npc_exact_table *table;
-	int i;
-
-	table = rvu->hw->table;
-
-	for (i = 0; i < NPC_MCAM_DROP_RULE_MAX; i++) {
-		if (!table->drop_rule_map[i].valid)
-			break;
-
-		if (table->drop_rule_map[i].drop_rule_idx != drop_rule_idx)
-			continue;
-
-		return table->drop_rule_map[i].pcifunc;
-	}
-
-	dev_err(rvu->dev, "%s: drop mcam rule index (%d) >= NPC_MCAM_DROP_RULE_MAX\n",
-		__func__, drop_rule_idx);
-	return -1;
-}
-
-/**
- *	rvu_npc_exact_get_drop_rule_info - Get drop rule information.
- *      @rvu: resource virtualization unit.
- *	@intf_type: Interface type (CGX, SDP or LBK)
- *	@cgx_id: CGX identifier.
- *	@lmac_id: LMAC identifier.
- *	@drop_mcam_idx: NPC mcam drop rule index.
- *	@val: Channel value.
- *	@mask: Channel mask.
- *	@pcifunc: pcifunc of interface corresponding to the drop rule.
- */
-static bool rvu_npc_exact_get_drop_rule_info(struct rvu *rvu, u8 intf_type, u8 cgx_id,
-					     u8 lmac_id, u32 *drop_mcam_idx, u64 *val,
-					     u64 *mask, u16 *pcifunc)
-{
-	struct npc_exact_table *table;
-	u64 chan_val, chan_mask;
-	bool rc;
-	int i;
-
-	table = rvu->hw->table;
-
-	if (intf_type != NIX_INTF_TYPE_CGX) {
-		dev_err(rvu->dev, "%s: No drop rule for LBK/SDP mode\n", __func__);
-		return false;
-	}
-
-	rc = rvu_npc_exact_calc_drop_rule_chan_and_mask(rvu, intf_type, cgx_id,
-							lmac_id, &chan_val, &chan_mask);
-
-	for (i = 0; i < NPC_MCAM_DROP_RULE_MAX; i++) {
-		if (!table->drop_rule_map[i].valid)
-			break;
-
-		if (table->drop_rule_map[i].chan_val != (u16)chan_val)
-			continue;
-
-		if (val)
-			*val = table->drop_rule_map[i].chan_val;
-		if (mask)
-			*mask = table->drop_rule_map[i].chan_mask;
-		if (pcifunc)
-			*pcifunc = table->drop_rule_map[i].pcifunc;
-
-		*drop_mcam_idx = i;
-		return true;
-	}
-
-	if (i == NPC_MCAM_DROP_RULE_MAX) {
-		dev_err(rvu->dev, "%s: drop mcam rule index (%d) >= NPC_MCAM_DROP_RULE_MAX\n",
-			__func__, *drop_mcam_idx);
-		return false;
-	}
-
-	dev_err(rvu->dev, "%s: Could not retrieve for cgx=%d, lmac=%d\n",
-		__func__, cgx_id, lmac_id);
-	return false;
-}
-
-/**
- *	__rvu_npc_exact_cmd_rules_cnt_update - Update number dmac rules against a drop rule.
- *      @rvu: resource virtualization unit.
- *	@drop_mcam_idx: NPC mcam drop rule index.
- *	@val: +1 or -1.
- *	@enable_or_disable_cam: If no exact match rules against a drop rule, disable it.
- *
- *	when first exact match entry against a drop rule is added, enable_or_disable_cam
- *	is set to true. When last exact match entry against a drop rule is deleted,
- *	enable_or_disable_cam is set to true.
- */
-static u16 __rvu_npc_exact_cmd_rules_cnt_update(struct rvu *rvu, int drop_mcam_idx,
-						int val, bool *enable_or_disable_cam)
-{
-	struct npc_exact_table *table;
-	u16 *cnt, old_cnt;
-	bool promisc;
-
-	table = rvu->hw->table;
-	promisc = table->promisc_mode[drop_mcam_idx];
-
-	cnt = &table->cnt_cmd_rules[drop_mcam_idx];
-	old_cnt = *cnt;
-
-	*cnt += val;
-
-	if (!enable_or_disable_cam)
-		goto done;
-
-	*enable_or_disable_cam = false;
-
-	if (promisc)
-		goto done;
-
-	/* If all rules are deleted and not already in promisc mode; disable cam */
-	if (!*cnt && val < 0) {
-		*enable_or_disable_cam = true;
-		goto done;
-	}
-
-	/* If rule got added and not already in promisc mode; enable cam */
-	if (!old_cnt && val > 0) {
-		*enable_or_disable_cam = true;
-		goto done;
-	}
-
-done:
-	return *cnt;
-}
-
-/**
- *      rvu_npc_exact_del_table_entry_by_id - Delete and free table entry.
- *      @rvu: resource virtualization unit.
- *	@seq_id: Sequence identifier of the entry.
- *
- *	Deletes entry from linked lists and free up slot in HW MEM or CAM
- *	table.
- */
-static int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id)
-{
-	struct npc_exact_table_entry *entry = NULL;
-	struct npc_exact_table *table;
-	u32 drop_mcam_idx;
-	bool disable_cam;
-	int *cnt;
-
-	table = rvu->hw->table;
-
-	mutex_lock(&table->lock);
-
-	/* Lookup for entry which needs to be updated */
-	entry = __rvu_npc_exact_find_entry_by_seq_id(rvu, seq_id);
-	if (!entry) {
-		dev_dbg(rvu->dev, "%s: failed to find entry for id=0x%x\n", __func__, seq_id);
-		mutex_unlock(&table->lock);
-		return -ENODATA;
-	}
-
-	cnt = (entry->opc_type == NPC_EXACT_OPC_CAM) ? &table->cam_tbl_entry_cnt :
-				&table->mem_tbl_entry_cnt;
-
-	/* delete from lists */
-	list_del_init(&entry->list);
-	list_del_init(&entry->glist);
-
-	(*cnt)--;
-
-	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, entry->cgx_id, entry->lmac_id,
-					 &drop_mcam_idx, NULL, NULL, NULL);
-
-	if (entry->cmd)
-		__rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, -1, &disable_cam);
-
-	/* No dmac filter rules; disable drop on hit rule */
-	if (disable_cam) {
-		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, false);
-		dev_dbg(rvu->dev, "%s: Disabling mcam idx %d\n",
-			__func__, drop_mcam_idx);
-	}
-
-	mutex_unlock(&table->lock);
-
-	rvu_npc_exact_dealloc_table_entry(rvu, entry->opc_type, entry->ways, entry->index);
-
-	rvu_npc_exact_free_id(rvu, seq_id);
-
-	dev_dbg(rvu->dev, "%s: delete entry success for id=0x%x, mca=%pM\n",
-		__func__, seq_id, entry->mac);
-	kfree(entry);
-
-	return 0;
-}
-
-/**
- *      rvu_npc_exact_add_table_entry - Adds a table entry
- *      @rvu: resource virtualization unit.
- *	@cgx_id: cgx identifier.
- *	@lmac_id: lmac identifier.
- *	@mac: MAC address.
- *	@chan: Channel number.
- *	@ctype: Channel Type.
- *	@seq_id: Sequence number.
- *	@cmd: Whether it is invoked by ethtool cmd.
- *	@mcam_idx: NPC mcam index corresponding to MAC
- *	@pcifunc: PCI func.
- *
- *	Creates a new exact match table entry in either CAM or
- *	MEM table.
- */
-static int rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id, u8 *mac,
-					 u16 chan, u8 ctype, u32 *seq_id, bool cmd,
-					 u32 mcam_idx, u16 pcifunc)
-{
-	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-	enum npc_exact_opc_type opc_type;
-	struct npc_exact_table *table;
-	u32 drop_mcam_idx;
-	bool enable_cam;
-	u32 index;
-	u64 mdata;
-	int err;
-	u8 ways;
-
-	table = rvu->hw->table;
-
-	ctype = 0;
-
-	err = rvu_npc_exact_alloc_table_entry(rvu, mac, chan, ctype, &index, &ways, &opc_type);
-	if (err) {
-		dev_err(rvu->dev, "%s: Could not alloc in exact match table\n", __func__);
-		return err;
-	}
-
-	/* Write mdata to table */
-	mdata = rvu_exact_prepare_table_entry(rvu, true, ctype, chan, mac);
-
-	if (opc_type == NPC_EXACT_OPC_CAM)
-		rvu_npc_exact_cam_table_write(rvu, blkaddr, index, mdata);
-	else
-		rvu_npc_exact_mem_table_write(rvu, blkaddr, ways, index,  mdata);
-
-	/* Insert entry to linked list */
-	err = rvu_npc_exact_add_to_list(rvu, opc_type, ways, index, cgx_id, lmac_id,
-					mac, chan, ctype, seq_id, cmd, mcam_idx, pcifunc);
-	if (err) {
-		rvu_npc_exact_dealloc_table_entry(rvu, opc_type, ways, index);
-		dev_err(rvu->dev, "%s: could not add to exact match table\n", __func__);
-		return err;
-	}
-
-	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
-					 &drop_mcam_idx, NULL, NULL, NULL);
-	if (cmd)
-		__rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, 1, &enable_cam);
-
-	/* First command rule; enable drop on hit rule */
-	if (enable_cam) {
-		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, true);
-		dev_dbg(rvu->dev, "%s: Enabling mcam idx %d\n",
-			__func__, drop_mcam_idx);
-	}
-
-	dev_dbg(rvu->dev,
-		"%s: Successfully added entry (index=%d, dmac=%pM, ways=%d opc_type=%d\n",
-		__func__, index, mac, ways, opc_type);
-
-	return 0;
-}
-
-/**
- *      rvu_npc_exact_update_table_entry - Update exact match table.
- *      @rvu: resource virtualization unit.
- *	@cgx_id: CGX identifier.
- *	@lamc_id: LMAC identifier.
- *	@old_mac: Existing MAC address entry.
- *	@new_mac: New MAC address entry.
- *	@seq_id: Sequence identifier of the entry.
- *
- *	Updates MAC address of an entry. If entry is in MEM table, new
- *	hash value may not match with old one.
- */
-static int rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
-					    u8 *old_mac, u8 *new_mac, u32 *seq_id)
-{
-	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-	struct npc_exact_table_entry *entry;
-	struct npc_exact_table *table;
-	u32 hash_index;
-	u64 mdata;
-
-	table = rvu->hw->table;
-
-	mutex_lock(&table->lock);
-
-	/* Lookup for entry which needs to be updated */
-	entry = __rvu_npc_exact_find_entry_by_seq_id(rvu, *seq_id);
-	if (!entry) {
-		mutex_unlock(&table->lock);
-		dev_dbg(rvu->dev,
-			"%s: failed to find entry for cgx_id=%d lmac_id=%d old_mac=%pM\n",
-			__func__, cgx_id, lmac_id, old_mac);
-		return -ENODATA;
-	}
-
-	/* If entry is in mem table and new hash index is different than old
-	 * hash index, we cannot update the entry. Fail in these scenarios.
-	 */
-	if (entry->opc_type == NPC_EXACT_OPC_MEM) {
-		hash_index =  rvu_exact_calculate_hash(rvu, entry->chan, entry->ctype,
-						       new_mac, table->mem_table.mask,
-						       table->mem_table.depth);
-		if (hash_index != entry->index) {
-			dev_dbg(rvu->dev,
-				"%s: Update failed due to index mismatch(new=0x%x, old=%x)\n",
-				__func__, hash_index, entry->index);
-			mutex_unlock(&table->lock);
-			return -EINVAL;
-		}
-	}
-
-	mdata = rvu_exact_prepare_table_entry(rvu, true, entry->ctype, entry->chan, new_mac);
-
-	if (entry->opc_type == NPC_EXACT_OPC_MEM)
-		rvu_npc_exact_mem_table_write(rvu, blkaddr, entry->ways, entry->index, mdata);
-	else
-		rvu_npc_exact_cam_table_write(rvu, blkaddr, entry->index, mdata);
-
-	/* Update entry fields */
-	ether_addr_copy(entry->mac, new_mac);
-	*seq_id = entry->seq_id;
-
-	dev_dbg(rvu->dev,
-		"%s: Successfully updated entry (index=%d, dmac=%pM, ways=%d opc_type=%d\n",
-		__func__, hash_index, entry->mac, entry->ways, entry->opc_type);
-
-	dev_dbg(rvu->dev, "%s: Successfully updated entry (old mac=%pM new_mac=%pM\n",
-		__func__, old_mac, new_mac);
-
-	mutex_unlock(&table->lock);
-	return 0;
-}
-
-/**
- *	rvu_npc_exact_promisc_disable - Disable promiscuous mode.
- *      @rvu: resource virtualization unit.
- *	@pcifunc: pcifunc
- *
- *	Drop rule is against each PF. We dont support DMAC filter for
- *	VF.
- */
-
-int rvu_npc_exact_promisc_disable(struct rvu *rvu, u16 pcifunc)
-{
-	struct npc_exact_table *table;
-	int pf = rvu_get_pf(pcifunc);
-	u8 cgx_id, lmac_id;
-	u32 drop_mcam_idx;
-	bool *promisc;
-	u32 cnt;
-
-	table = rvu->hw->table;
-
-	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
-					 &drop_mcam_idx, NULL, NULL, NULL);
-
-	mutex_lock(&table->lock);
-	promisc = &table->promisc_mode[drop_mcam_idx];
-
-	if (!*promisc) {
-		mutex_unlock(&table->lock);
-		dev_dbg(rvu->dev, "%s: Err Already promisc mode disabled (cgx=%d lmac=%d)\n",
-			__func__, cgx_id, lmac_id);
-		return LMAC_AF_ERR_INVALID_PARAM;
-	}
-	*promisc = false;
-	cnt = __rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, 0, NULL);
-	mutex_unlock(&table->lock);
-
-	/* If no dmac filter entries configured, disable drop rule */
-	if (!cnt)
-		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, false);
-	else
-		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, !*promisc);
-
-	dev_dbg(rvu->dev, "%s: disabled  promisc mode (cgx=%d lmac=%d, cnt=%d)\n",
-		__func__, cgx_id, lmac_id, cnt);
-	return 0;
-}
-
-/**
- *	rvu_npc_exact_promisc_enable - Enable promiscuous mode.
- *      @rvu: resource virtualization unit.
- *	@pcifunc: pcifunc.
- */
-int rvu_npc_exact_promisc_enable(struct rvu *rvu, u16 pcifunc)
-{
-	struct npc_exact_table *table;
-	int pf = rvu_get_pf(pcifunc);
-	u8 cgx_id, lmac_id;
-	u32 drop_mcam_idx;
-	bool *promisc;
-	u32 cnt;
-
-	table = rvu->hw->table;
-
-	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
-					 &drop_mcam_idx, NULL, NULL, NULL);
-
-	mutex_lock(&table->lock);
-	promisc = &table->promisc_mode[drop_mcam_idx];
-
-	if (*promisc) {
-		mutex_unlock(&table->lock);
-		dev_dbg(rvu->dev, "%s: Already in promisc mode (cgx=%d lmac=%d)\n",
-			__func__, cgx_id, lmac_id);
-		return LMAC_AF_ERR_INVALID_PARAM;
-	}
-	*promisc = true;
-	cnt = __rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, 0, NULL);
-	mutex_unlock(&table->lock);
-
-	/* If no dmac filter entries configured, disable drop rule */
-	if (!cnt)
-		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, false);
-	else
-		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, !*promisc);
-
-	dev_dbg(rvu->dev, "%s: Enabled promisc mode (cgx=%d lmac=%d cnt=%d)\n",
-		__func__, cgx_id, lmac_id, cnt);
-	return 0;
-}
-
-/**
- *	rvu_npc_exact_mac_addr_reset - Delete PF mac address.
- *      @rvu: resource virtualization unit.
- *	@req: Reset request
- *	@rsp: Reset response.
- */
-int rvu_npc_exact_mac_addr_reset(struct rvu *rvu, struct cgx_mac_addr_reset_req *req,
-				 struct msg_rsp *rsp)
-{
-	int pf = rvu_get_pf(req->hdr.pcifunc);
-	u32 seq_id = req->index;
-	struct rvu_pfvf *pfvf;
-	u8 cgx_id, lmac_id;
-	int rc;
-
-	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-
-	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
-
-	rc = rvu_npc_exact_del_table_entry_by_id(rvu, seq_id);
-	if (rc) {
-		/* TODO: how to handle this error case ? */
-		dev_err(rvu->dev, "%s MAC (%pM) del PF=%d failed\n", __func__, pfvf->mac_addr, pf);
-		return 0;
-	}
-
-	dev_dbg(rvu->dev, "%s MAC (%pM) del PF=%d success (seq_id=%u)\n",
-		__func__, pfvf->mac_addr, pf, seq_id);
-	return 0;
-}
-
-/**
- *	rvu_npc_exact_mac_addr_update - Update mac address field with new value.
- *      @rvu: resource virtualization unit.
- *	@req: Update request.
- *	@rsp: Update response.
- */
-int rvu_npc_exact_mac_addr_update(struct rvu *rvu,
-				  struct cgx_mac_addr_update_req *req,
-				  struct cgx_mac_addr_update_rsp *rsp)
-{
-	int pf = rvu_get_pf(req->hdr.pcifunc);
-	struct npc_exact_table_entry *entry;
-	struct npc_exact_table *table;
-	struct rvu_pfvf *pfvf;
-	u32 seq_id, mcam_idx;
-	u8 old_mac[ETH_ALEN];
-	u8 cgx_id, lmac_id;
-	int rc;
-
-	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
-		return LMAC_AF_ERR_PERM_DENIED;
-
-	dev_dbg(rvu->dev, "%s: Update request for seq_id=%d, mac=%pM\n",
-		__func__, req->index, req->mac_addr);
-
-	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-
-	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
-
-	table = rvu->hw->table;
-
-	mutex_lock(&table->lock);
-
-	/* Lookup for entry which needs to be updated */
-	entry = __rvu_npc_exact_find_entry_by_seq_id(rvu, req->index);
-	if (!entry) {
-		dev_err(rvu->dev, "%s: failed to find entry for id=0x%x\n", __func__, req->index);
-		mutex_unlock(&table->lock);
-		return LMAC_AF_ERR_EXACT_MATCH_TBL_LOOK_UP_FAILED;
-	}
-	ether_addr_copy(old_mac, entry->mac);
-	seq_id = entry->seq_id;
-	mcam_idx = entry->mcam_idx;
-	mutex_unlock(&table->lock);
-
-	rc = rvu_npc_exact_update_table_entry(rvu, cgx_id, lmac_id,  old_mac,
-					      req->mac_addr, &seq_id);
-	if (!rc) {
-		rsp->index = seq_id;
-		dev_dbg(rvu->dev, "%s  mac:%pM (pfvf:%pM default:%pM) update to PF=%d success\n",
-			__func__, req->mac_addr, pfvf->mac_addr, pfvf->default_mac, pf);
-		ether_addr_copy(pfvf->mac_addr, req->mac_addr);
-		return 0;
-	}
-
-	/* Try deleting and adding it again */
-	rc = rvu_npc_exact_del_table_entry_by_id(rvu, req->index);
-	if (rc) {
-		/* This could be a new entry */
-		dev_dbg(rvu->dev, "%s MAC (%pM) del PF=%d failed\n", __func__,
-			pfvf->mac_addr, pf);
-	}
-
-	rc = rvu_npc_exact_add_table_entry(rvu, cgx_id, lmac_id, req->mac_addr,
-					   pfvf->rx_chan_base, 0, &seq_id, true,
-					   mcam_idx, req->hdr.pcifunc);
-	if (rc) {
-		dev_err(rvu->dev, "%s MAC (%pM) add PF=%d failed\n", __func__,
-			req->mac_addr, pf);
-		return LMAC_AF_ERR_EXACT_MATCH_TBL_ADD_FAILED;
-	}
-
-	rsp->index = seq_id;
-	dev_dbg(rvu->dev,
-		"%s MAC (new:%pM, old=%pM default:%pM) del and add to PF=%d success (seq_id=%u)\n",
-		__func__, req->mac_addr, pfvf->mac_addr, pfvf->default_mac, pf, seq_id);
-
-	ether_addr_copy(pfvf->mac_addr, req->mac_addr);
-	return 0;
-}
-
-/**
- *	rvu_npc_exact_mac_addr_add - Adds MAC address to exact match table.
- *      @rvu: resource virtualization unit.
- *	@req: Add request.
- *	@rsp: Add response.
- */
-int rvu_npc_exact_mac_addr_add(struct rvu *rvu,
-			       struct cgx_mac_addr_add_req *req,
-			       struct cgx_mac_addr_add_rsp *rsp)
-{
-	int pf = rvu_get_pf(req->hdr.pcifunc);
-	struct rvu_pfvf *pfvf;
-	u8 cgx_id, lmac_id;
-	int rc = 0;
-	u32 seq_id;
-
-	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
-
-	rc = rvu_npc_exact_add_table_entry(rvu, cgx_id, lmac_id, req->mac_addr,
-					   pfvf->rx_chan_base, 0, &seq_id,
-					   true, -1, req->hdr.pcifunc);
-
-	if (!rc) {
-		rsp->index = seq_id;
-		dev_dbg(rvu->dev, "%s MAC (%pM) add to PF=%d success (seq_id=%u)\n",
-			__func__, req->mac_addr, pf, seq_id);
-		return 0;
-	}
-
-	dev_err(rvu->dev, "%s MAC (%pM) add to PF=%d failed\n", __func__,
-		req->mac_addr, pf);
-	return LMAC_AF_ERR_EXACT_MATCH_TBL_ADD_FAILED;
-}
-
-/**
- *	rvu_npc_exact_mac_addr_del - Delete DMAC filter
- *      @rvu: resource virtualization unit.
- *	@req: Delete request.
- *	@rsp: Delete response.
- */
-int rvu_npc_exact_mac_addr_del(struct rvu *rvu,
-			       struct cgx_mac_addr_del_req *req,
-			       struct msg_rsp *rsp)
-{
-	int pf = rvu_get_pf(req->hdr.pcifunc);
-	int rc;
-
-	rc = rvu_npc_exact_del_table_entry_by_id(rvu, req->index);
-	if (!rc) {
-		dev_dbg(rvu->dev, "%s del to PF=%d success (seq_id=%u)\n",
-			__func__, pf, req->index);
-		return 0;
-	}
-
-	dev_err(rvu->dev, "%s del to PF=%d failed (seq_id=%u)\n",
-		__func__,  pf, req->index);
-	return LMAC_AF_ERR_EXACT_MATCH_TBL_DEL_FAILED;
-}
-
-/**
- *	rvu_npc_exact_mac_addr_set - Add PF mac address to dmac filter.
- *      @rvu: resource virtualization unit.
- *	@req: Set request.
- *	@rsp: Set response.
- */
-int rvu_npc_exact_mac_addr_set(struct rvu *rvu, struct cgx_mac_addr_set_or_get *req,
-			       struct cgx_mac_addr_set_or_get *rsp)
-{
-	int pf = rvu_get_pf(req->hdr.pcifunc);
-	u32 seq_id = req->index;
-	struct rvu_pfvf *pfvf;
-	u8 cgx_id, lmac_id;
-	u32 mcam_idx = -1;
-	int rc, nixlf;
-
-	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-
-	pfvf = &rvu->pf[pf];
-
-	/* If table does not have an entry; both update entry and del table entry API
-	 * below fails. Those are not failure conditions.
-	 */
-	rc = rvu_npc_exact_update_table_entry(rvu, cgx_id, lmac_id, pfvf->mac_addr,
-					      req->mac_addr, &seq_id);
-	if (!rc) {
-		rsp->index = seq_id;
-		ether_addr_copy(pfvf->mac_addr, req->mac_addr);
-		ether_addr_copy(rsp->mac_addr, req->mac_addr);
-		dev_dbg(rvu->dev, "%s MAC (%pM) update to PF=%d success\n",
-			__func__, req->mac_addr, pf);
-		return 0;
-	}
-
-	/* Try deleting and adding it again */
-	rc = rvu_npc_exact_del_table_entry_by_id(rvu, req->index);
-	if (rc) {
-		dev_dbg(rvu->dev, "%s MAC (%pM) del PF=%d failed\n",
-			__func__, pfvf->mac_addr, pf);
-	}
-
-	/* find mcam entry if exist */
-	rc = nix_get_nixlf(rvu, req->hdr.pcifunc, &nixlf, NULL);
-	if (!rc) {
-		mcam_idx = npc_get_nixlf_mcam_index(&rvu->hw->mcam, req->hdr.pcifunc,
-						    nixlf, NIXLF_UCAST_ENTRY);
-	}
-
-	rc = rvu_npc_exact_add_table_entry(rvu, cgx_id, lmac_id, req->mac_addr,
-					   pfvf->rx_chan_base, 0, &seq_id,
-					   true, mcam_idx, req->hdr.pcifunc);
-	if (rc) {
-		dev_err(rvu->dev, "%s MAC (%pM) add PF=%d failed\n",
-			__func__, req->mac_addr, pf);
-		return LMAC_AF_ERR_EXACT_MATCH_TBL_ADD_FAILED;
-	}
-
-	rsp->index = seq_id;
-	ether_addr_copy(rsp->mac_addr, req->mac_addr);
-	ether_addr_copy(pfvf->mac_addr, req->mac_addr);
-	dev_dbg(rvu->dev,
-		"%s MAC (%pM) del and add to PF=%d success (seq_id=%u)\n",
-		__func__, req->mac_addr, pf, seq_id);
-	return 0;
-}
-
-/**
- *	rvu_npc_exact_can_disable_feature - Check if feature can be disabled.
- *      @rvu: resource virtualization unit.
- */
-bool rvu_npc_exact_can_disable_feature(struct rvu *rvu)
-{
-	struct npc_exact_table *table = rvu->hw->table;
-	bool empty;
-
-	if (!rvu->hw->cap.npc_exact_match_enabled)
-		return false;
-
-	mutex_lock(&table->lock);
-	empty = list_empty(&table->lhead_gbl);
-	mutex_unlock(&table->lock);
-
-	return empty;
-}
-
-/**
- *	rvu_npc_exact_disable_feature - Disable feature.
- *      @rvu: resource virtualization unit.
- */
-void rvu_npc_exact_disable_feature(struct rvu *rvu)
-{
-	rvu->hw->cap.npc_exact_match_enabled = false;
-}
-
-/**
- *	rvu_npc_exact_reset - Delete and free all entry which match pcifunc.
- *      @rvu: resource virtualization unit.
- *	@pcifunc: PCI func to match.
- */
-void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc)
-{
-	struct npc_exact_table *table = rvu->hw->table;
-	struct npc_exact_table_entry *tmp, *iter;
-	u32 seq_id;
-
-	mutex_lock(&table->lock);
-	list_for_each_entry_safe(iter, tmp, &table->lhead_gbl, glist) {
-		if (pcifunc != iter->pcifunc)
-			continue;
-
-		seq_id = iter->seq_id;
-		dev_dbg(rvu->dev, "%s: resetting pcifun=%d seq_id=%u\n", __func__,
-			pcifunc, seq_id);
-
-		mutex_unlock(&table->lock);
-		rvu_npc_exact_del_table_entry_by_id(rvu, seq_id);
-		mutex_lock(&table->lock);
-	}
-	mutex_unlock(&table->lock);
-}
-
-/**
- *      rvu_npc_exact_init - initialize exact match table
- *      @rvu: resource virtualization unit.
- *
- *	Initialize HW and SW resources to manage 4way-2K table and fully
-	u8 cgx_id, lmac_id;
- *	associative 32-entry mcam table.
- */
-int rvu_npc_exact_init(struct rvu *rvu)
-{
-	u64 bcast_mcast_val, bcast_mcast_mask;
-	struct npc_exact_table *table;
-	u64 exact_val, exact_mask;
-	u64 chan_val, chan_mask;
-	u8 cgx_id, lmac_id;
-	u32 *drop_mcam_idx;
-	u16 max_lmac_cnt;
-	u64 npc_const3;
-	int table_size;
-	int blkaddr;
-	u16 pcifunc;
-	int err, i;
-	u64 cfg;
-	bool rc;
-
-	/* Read NPC_AF_CONST3 and check for have exact
-	 * match functionality is present
-	 */
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-	if (blkaddr < 0) {
-		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
-		return -EINVAL;
-	}
-
-	/* Check exact match feature is supported */
-	npc_const3 = rvu_read64(rvu, blkaddr, NPC_AF_CONST3);
-	if (!(npc_const3 & BIT_ULL(62))) {
-		dev_info(rvu->dev, "%s: No support for exact match support\n",
-			 __func__);
-		return 0;
-	}
-
-	/* Check if kex profile has enabled EXACT match nibble */
-	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX));
-	if (!(cfg & NPC_EXACT_NIBBLE_HIT)) {
-		dev_info(rvu->dev, "%s: NPC exact match nibble not enabled in KEX profile\n",
-			 __func__);
-		return 0;
-	}
-
-	/* Set capability to true */
-	rvu->hw->cap.npc_exact_match_enabled = true;
-
-	table = kmalloc(sizeof(*table), GFP_KERNEL);
-	if (!table)
-		return -ENOMEM;
-
-	dev_dbg(rvu->dev, "%s: Memory allocation for table success\n", __func__);
-	memset(table, 0, sizeof(*table));
-	rvu->hw->table = table;
-
-	/* Read table size, ways and depth */
-	table->mem_table.depth = FIELD_GET(GENMASK_ULL(31, 24), npc_const3);
-	table->mem_table.ways = FIELD_GET(GENMASK_ULL(19, 16), npc_const3);
-	table->cam_table.depth = FIELD_GET(GENMASK_ULL(15, 0), npc_const3);
-
-	dev_dbg(rvu->dev, "%s: NPC exact match 4way_2k table(ways=%d, depth=%d)\n",
-		__func__,  table->mem_table.ways, table->cam_table.depth);
-
-	/* Check if depth of table is not a sequre of 2
-	 * TODO: why _builtin_popcount() is not working ?
-	 */
-	if ((table->mem_table.depth & (table->mem_table.depth - 1)) != 0) {
-		dev_err(rvu->dev,
-			"%s: NPC exact match 4way_2k table depth(%d) is not square of 2\n",
-			__func__,  table->mem_table.depth);
-		return -EINVAL;
-	}
-
-	table_size = table->mem_table.depth * table->mem_table.ways;
-
-	/* Allocate bitmap for 4way 2K table */
-	table->mem_table.bmap = devm_kcalloc(rvu->dev, BITS_TO_LONGS(table_size),
-					     sizeof(long), GFP_KERNEL);
-	if (!table->mem_table.bmap)
-		return -ENOMEM;
-
-	dev_dbg(rvu->dev, "%s: Allocated bitmap for 4way 2K entry table\n", __func__);
-
-	/* Allocate bitmap for 32 entry mcam */
-	table->cam_table.bmap = devm_kcalloc(rvu->dev, 1, sizeof(long), GFP_KERNEL);
-
-	if (!table->cam_table.bmap)
-		return -ENOMEM;
-
-	dev_dbg(rvu->dev, "%s: Allocated bitmap for 32 entry cam\n", __func__);
-
-	table->tot_ids = (table->mem_table.depth * table->mem_table.ways) + table->cam_table.depth;
-	table->id_bmap = devm_kcalloc(rvu->dev, BITS_TO_LONGS(table->tot_ids),
-				      table->tot_ids, GFP_KERNEL);
-
-	if (!table->id_bmap)
-		return -ENOMEM;
-
-	dev_dbg(rvu->dev, "%s: Allocated bitmap for id map (total=%d)\n",
-		__func__, table->tot_ids);
-
-	/* Initialize list heads for npc_exact_table entries.
-	 * This entry is used by debugfs to show entries in
-	 * exact match table.
-	 */
-	for (i = 0; i < NPC_EXACT_TBL_MAX_WAYS; i++)
-		INIT_LIST_HEAD(&table->lhead_mem_tbl_entry[i]);
-
-	INIT_LIST_HEAD(&table->lhead_cam_tbl_entry);
-	INIT_LIST_HEAD(&table->lhead_gbl);
-
-	mutex_init(&table->lock);
-
-	rvu_exact_config_secret_key(rvu);
-	rvu_exact_config_search_key(rvu);
-
-	rvu_exact_config_table_mask(rvu);
-	rvu_exact_config_result_ctrl(rvu, table->mem_table.depth);
-
-	/* - No drop rule for LBK
-	 * - Drop rules for SDP and each LMAC.
-	 */
-	exact_val = !NPC_EXACT_RESULT_HIT;
-	exact_mask = NPC_EXACT_RESULT_HIT;
-
-	/* nibble - 3	2  1   0
-	 *	   L3B L3M L2B L2M
-	 */
-	bcast_mcast_val = 0b0000;
-	bcast_mcast_mask = 0b0011;
-
-	/* Install SDP drop rule */
-	drop_mcam_idx = &table->num_drop_rules;
-
-	max_lmac_cnt = rvu->cgx_cnt_max * MAX_LMAC_PER_CGX + PF_CGXMAP_BASE;
-	for (i = PF_CGXMAP_BASE; i < max_lmac_cnt; i++) {
-		if (rvu->pf2cgxlmac_map[i] == 0xFF)
-			continue;
-
-		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[i], &cgx_id, &lmac_id);
-
-		rc = rvu_npc_exact_calc_drop_rule_chan_and_mask(rvu, NIX_INTF_TYPE_CGX, cgx_id,
-								lmac_id, &chan_val, &chan_mask);
-		if (!rc) {
-			dev_err(rvu->dev,
-				"%s: failed, info chan_val=0x%llx chan_mask=0x%llx rule_id=%d\n",
-				__func__, chan_val, chan_mask, *drop_mcam_idx);
-			return -EINVAL;
-		}
-
-		/* Filter rules are only for PF */
-		pcifunc = RVU_PFFUNC(i, 0);
-
-		dev_dbg(rvu->dev,
-			"%s:Drop rule cgx=%d lmac=%d chan(val=0x%llx, mask=0x%llx\n",
-			__func__, cgx_id, lmac_id, chan_val, chan_mask);
-
-		rc = rvu_npc_exact_save_drop_rule_chan_and_mask(rvu, table->num_drop_rules,
-								chan_val, chan_mask, pcifunc);
-		if (!rc) {
-			dev_err(rvu->dev,
-				"%s: failed to set drop info for cgx=%d, lmac=%d, chan=%llx\n",
-				__func__, cgx_id, lmac_id, chan_val);
-			return err;
-		}
-
-		err = npc_install_mcam_drop_rule(rvu, *drop_mcam_idx,
-						 &table->counter_idx[*drop_mcam_idx],
-						 chan_val, chan_mask,
-						 exact_val, exact_mask,
-						 bcast_mcast_val, bcast_mcast_mask);
-		if (err) {
-			dev_err(rvu->dev,
-				"failed to configure drop rule (cgx=%d lmac=%d)\n",
-				cgx_id, lmac_id);
-			return err;
-		}
-
-		(*drop_mcam_idx)++;
-	}
-
-	dev_info(rvu->dev, "initialized exact match table successfully\n");
-	return 0;
-}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
deleted file mode 100644
index 3efeb09c58de..000000000000
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ /dev/null
@@ -1,233 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Marvell RVU Admin Function driver
- *
- * Copyright (C) 2022 Marvell.
- *
- */
-
-#ifndef __RVU_NPC_HASH_H
-#define __RVU_NPC_HASH_H
-
-#define RVU_NPC_HASH_SECRET_KEY0 0xa9d5af4c9fbc76b1
-#define RVU_NPC_HASH_SECRET_KEY1 0xa9d5af4c9fbc87b4
-#define RVU_NPC_HASH_SECRET_KEY2 0x5954c9e7
-
-#define NPC_MAX_HASH 2
-#define NPC_MAX_HASH_MASK 2
-
-#define KEX_LD_CFG_USE_HASH(use_hash, bytesm1, hdr_ofs, ena, flags_ena, key_ofs) \
-			    ((use_hash) << 20 | ((bytesm1) << 16) | ((hdr_ofs) << 8) | \
-			     ((ena) << 7) | ((flags_ena) << 6) | ((key_ofs) & 0x3F))
-#define KEX_LD_CFG_HASH(hdr_ofs, bytesm1, lt_en, lid_en, lid, ltype_match, ltype_mask)	\
-			(((hdr_ofs) << 32) | ((bytesm1) << 16) | \
-			 ((lt_en) << 12) | ((lid_en) << 11) | ((lid) << 8) | \
-			 ((ltype_match) << 4) | ((ltype_mask) & 0xF))
-
-#define SET_KEX_LD_HASH(intf, ld, cfg) \
-	rvu_write64(rvu, blkaddr,	\
-		    NPC_AF_INTFX_HASHX_CFG(intf, ld), cfg)
-
-#define SET_KEX_LD_HASH_MASK(intf, ld, mask_idx, cfg) \
-	rvu_write64(rvu, blkaddr,	\
-		    NPC_AF_INTFX_HASHX_MASKX(intf, ld, mask_idx), cfg)
-
-#define SET_KEX_LD_HASH_CTRL(intf, ld, cfg) \
-	rvu_write64(rvu, blkaddr,	\
-		    NPC_AF_INTFX_HASHX_RESULT_CTRL(intf, ld), cfg)
-
-struct npc_mcam_kex_hash {
-	/* NPC_AF_INTF(0..1)_LID(0..7)_LT(0..15)_LD(0..1)_CFG */
-	bool lid_lt_ld_hash_en[NPC_MAX_INTF][NPC_MAX_LID][NPC_MAX_LT][NPC_MAX_LD];
-	/* NPC_AF_INTF(0..1)_HASH(0..1)_CFG */
-	u64 hash[NPC_MAX_INTF][NPC_MAX_HASH];
-	/* NPC_AF_INTF(0..1)_HASH(0..1)_MASK(0..1) */
-	u64 hash_mask[NPC_MAX_INTF][NPC_MAX_HASH][NPC_MAX_HASH_MASK];
-	/* NPC_AF_INTF(0..1)_HASH(0..1)_RESULT_CTRL */
-	u64 hash_ctrl[NPC_MAX_INTF][NPC_MAX_HASH];
-} __packed;
-
-void npc_update_field_hash(struct rvu *rvu, u8 intf,
-			   struct mcam_entry *entry,
-			   int blkaddr,
-			   u64 features,
-			   struct flow_msg *pkt,
-			   struct flow_msg *mask,
-			   struct flow_msg *opkt,
-			   struct flow_msg *omask);
-void npc_config_secret_key(struct rvu *rvu, int blkaddr);
-void npc_program_mkex_hash(struct rvu *rvu, int blkaddr);
-u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash *mkex_hash,
-			u64 *secret_key, u8 intf, u8 hash_idx);
-
-static struct npc_mcam_kex_hash npc_mkex_hash_default __maybe_unused = {
-	.lid_lt_ld_hash_en = {
-	[NIX_INTF_RX] = {
-		[NPC_LID_LC] = {
-			[NPC_LT_LC_IP6] = {
-				true,
-				true,
-			},
-		},
-	},
-
-	[NIX_INTF_TX] = {
-		[NPC_LID_LC] = {
-			[NPC_LT_LC_IP6] = {
-				true,
-				true,
-			},
-		},
-	},
-	},
-
-	.hash = {
-	[NIX_INTF_RX] = {
-		KEX_LD_CFG_HASH(0x8ULL, 0xf, 0x1, 0x1, NPC_LID_LC, NPC_LT_LC_IP6, 0xf),
-		KEX_LD_CFG_HASH(0x18ULL, 0xf, 0x1, 0x1, NPC_LID_LC, NPC_LT_LC_IP6, 0xf),
-	},
-
-	[NIX_INTF_TX] = {
-		KEX_LD_CFG_HASH(0x8ULL, 0xf, 0x1, 0x1, NPC_LID_LC, NPC_LT_LC_IP6, 0xf),
-		KEX_LD_CFG_HASH(0x18ULL, 0xf, 0x1, 0x1, NPC_LID_LC, NPC_LT_LC_IP6, 0xf),
-	},
-	},
-
-	.hash_mask = {
-	[NIX_INTF_RX] = {
-		[0] = {
-			GENMASK_ULL(63, 0),
-			GENMASK_ULL(63, 0),
-		},
-		[1] = {
-			GENMASK_ULL(63, 0),
-			GENMASK_ULL(63, 0),
-		},
-	},
-
-	[NIX_INTF_TX] = {
-		[0] = {
-			GENMASK_ULL(63, 0),
-			GENMASK_ULL(63, 0),
-		},
-		[1] = {
-			GENMASK_ULL(63, 0),
-			GENMASK_ULL(63, 0),
-		},
-	},
-	},
-
-	.hash_ctrl = {
-	[NIX_INTF_RX] = {
-		[0] = GENMASK_ULL(63, 32), /* MSB 32 bit is mask and LSB 32 bit is offset. */
-		[1] = GENMASK_ULL(63, 32), /* MSB 32 bit is mask and LSB 32 bit is offset. */
-	},
-
-	[NIX_INTF_TX] = {
-		[0] = GENMASK_ULL(63, 32), /* MSB 32 bit is mask and LSB 32 bit is offset. */
-		[1] = GENMASK_ULL(63, 32), /* MSB 32 bit is mask and LSB 32 bit is offset. */
-	},
-	},
-};
-
-/* If exact match table support is enabled, enable drop rules */
-#define NPC_MCAM_DROP_RULE_MAX 30
-#define NPC_MCAM_SDP_DROP_RULE_IDX 0
-
-#define RVU_PFFUNC(pf, func)	\
-	((((pf) & RVU_PFVF_PF_MASK) << RVU_PFVF_PF_SHIFT) | \
-	(((func) & RVU_PFVF_FUNC_MASK) << RVU_PFVF_FUNC_SHIFT))
-
-enum npc_exact_opc_type {
-	NPC_EXACT_OPC_MEM,
-	NPC_EXACT_OPC_CAM,
-};
-
-struct npc_exact_table_entry {
-	struct list_head list;
-	struct list_head glist;
-	u32 seq_id;	/* Sequence number of entry */
-	u32 index;	/* Mem table or cam table index */
-	u32 mcam_idx;
-		/* Mcam index. This is valid only if "cmd" field is false */
-	enum npc_exact_opc_type opc_type;
-	u16 chan;
-	u16 pcifunc;
-	u8 ways;
-	u8 mac[ETH_ALEN];
-	u8 ctype;
-	u8 cgx_id;
-	u8 lmac_id;
-	bool cmd;	/* Is added by ethtool command ? */
-};
-
-struct npc_exact_table {
-	struct mutex lock;	/* entries update lock */
-	unsigned long *id_bmap;
-	int num_drop_rules;
-	u32 tot_ids;
-	u16 cnt_cmd_rules[NPC_MCAM_DROP_RULE_MAX];
-	u16 counter_idx[NPC_MCAM_DROP_RULE_MAX];
-	bool promisc_mode[NPC_MCAM_DROP_RULE_MAX];
-	struct {
-		int ways;
-		int depth;
-		unsigned long *bmap;
-		u64 mask;	// Masks before hash calculation.
-		u16 hash_mask;	// 11 bits for hash mask
-		u16 hash_offset; // 11 bits offset
-	} mem_table;
-
-	struct {
-		int depth;
-		unsigned long *bmap;
-	} cam_table;
-
-	struct {
-		bool valid;
-		u16 chan_val;
-		u16 chan_mask;
-		u16 pcifunc;
-		u8 drop_rule_idx;
-	} drop_rule_map[NPC_MCAM_DROP_RULE_MAX];
-
-#define NPC_EXACT_TBL_MAX_WAYS 4
-
-	struct list_head lhead_mem_tbl_entry[NPC_EXACT_TBL_MAX_WAYS];
-	int mem_tbl_entry_cnt;
-
-	struct list_head lhead_cam_tbl_entry;
-	int cam_tbl_entry_cnt;
-
-	struct list_head lhead_gbl;
-};
-
-bool rvu_npc_exact_has_match_table(struct rvu *rvu);
-u32 rvu_npc_exact_get_max_entries(struct rvu *rvu);
-int rvu_npc_exact_init(struct rvu *rvu);
-int rvu_npc_exact_mac_addr_reset(struct rvu *rvu, struct cgx_mac_addr_reset_req *req,
-				 struct msg_rsp *rsp);
-
-int rvu_npc_exact_mac_addr_update(struct rvu *rvu,
-				  struct cgx_mac_addr_update_req *req,
-				  struct cgx_mac_addr_update_rsp *rsp);
-
-int rvu_npc_exact_mac_addr_add(struct rvu *rvu,
-			       struct cgx_mac_addr_add_req *req,
-			       struct cgx_mac_addr_add_rsp *rsp);
-
-int rvu_npc_exact_mac_addr_del(struct rvu *rvu,
-			       struct cgx_mac_addr_del_req *req,
-			       struct msg_rsp *rsp);
-
-int rvu_npc_exact_mac_addr_set(struct rvu *rvu, struct cgx_mac_addr_set_or_get *req,
-			       struct cgx_mac_addr_set_or_get *rsp);
-
-void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc);
-
-bool rvu_npc_exact_can_disable_feature(struct rvu *rvu);
-void rvu_npc_exact_disable_feature(struct rvu *rvu);
-void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc);
-u16 rvu_npc_exact_drop_rule_to_pcifunc(struct rvu *rvu, u32 drop_rule_idx);
-int rvu_npc_exact_promisc_disable(struct rvu *rvu, u16 pcifunc);
-int rvu_npc_exact_promisc_enable(struct rvu *rvu, u16 pcifunc);
-#endif /* RVU_NPC_HASH_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 77a9ade91f3e..22cd751613cd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -565,13 +565,7 @@
 #define NPC_AF_PCK_DEF_OIP4		(0x00620)
 #define NPC_AF_PCK_DEF_OIP6		(0x00630)
 #define NPC_AF_PCK_DEF_IIP4		(0x00640)
-#define NPC_AF_INTFX_HASHX_RESULT_CTRL(a, b)	(0x006c0 | (a) << 4 | (b) << 3)
-#define NPC_AF_INTFX_HASHX_MASKX(a, b, c)  (0x00700 | (a) << 5 | (b) << 4 | (c) << 3)
 #define NPC_AF_KEX_LDATAX_FLAGS_CFG(a)	(0x00800 | (a) << 3)
-#define NPC_AF_INTFX_HASHX_CFG(a, b)  (0x00b00 | (a) << 6 | (b) << 4)
-#define NPC_AF_INTFX_SECRET_KEY0(a)	(0x00e00 | (a) << 3)
-#define NPC_AF_INTFX_SECRET_KEY1(a)	(0x00e20 | (a) << 3)
-#define NPC_AF_INTFX_SECRET_KEY2(a)	(0x00e40 | (a) << 3)
 #define NPC_AF_INTFX_KEX_CFG(a)		(0x01010 | (a) << 8)
 #define NPC_AF_PKINDX_ACTION0(a)	(0x80000ull | (a) << 6)
 #define NPC_AF_PKINDX_ACTION1(a)	(0x80008ull | (a) << 6)
@@ -605,15 +599,6 @@
 #define NPC_AF_DBG_DATAX(a)		(0x3001400 | (a) << 4)
 #define NPC_AF_DBG_RESULTX(a)		(0x3001800 | (a) << 4)
 
-#define NPC_AF_EXACT_MEM_ENTRY(a, b)	(0x300000 | (a) << 15 | (b) << 3)
-#define NPC_AF_EXACT_CAM_ENTRY(a)	(0xC00 | (a) << 3)
-#define NPC_AF_INTFX_EXACT_MASK(a)	(0x660 | (a) << 3)
-#define NPC_AF_INTFX_EXACT_RESULT_CTL(a)(0x680 | (a) << 3)
-#define NPC_AF_INTFX_EXACT_CFG(a)	(0xA00 | (a) << 3)
-#define NPC_AF_INTFX_EXACT_SECRET0(a)	(0xE00 | (a) << 3)
-#define NPC_AF_INTFX_EXACT_SECRET1(a)	(0xE20 | (a) << 3)
-#define NPC_AF_INTFX_EXACT_SECRET2(a)	(0xE40 | (a) << 3)
-
 #define NPC_AF_MCAMEX_BANKX_CAMX_INTF(a, b, c) ({			   \
 	u64 offset;							   \
 									   \
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index e795f9ee76dd..ce2766317c0b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -314,8 +314,8 @@ struct otx2_flow_config {
 #define OTX2_VF_VLAN_TX_INDEX	1
 	u16			max_flows;
 	u8			dmacflt_max_flows;
-	u32			*bmap_to_dmacindex;
-	unsigned long		*dmacflt_bmap;
+	u8			*bmap_to_dmacindex;
+	unsigned long		dmacflt_bmap;
 	struct list_head	flow_list;
 };
 
@@ -895,9 +895,9 @@ int otx2_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic);
 /* CGX/RPM DMAC filters support */
 int otx2_dmacflt_get_max_cnt(struct otx2_nic *pf);
-int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u32 bit_pos);
-int otx2_dmacflt_remove(struct otx2_nic *pf, const u8 *mac, u32 bit_pos);
-int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u32 bit_pos);
+int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u8 bit_pos);
+int otx2_dmacflt_remove(struct otx2_nic *pf, const u8 *mac, u8 bit_pos);
+int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u8 bit_pos);
 void otx2_dmacflt_reinstall_flows(struct otx2_nic *pf);
 void otx2_dmacflt_update_pfmac_flow(struct otx2_nic *pfvf);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
index 846a0294a215..2ec800f741d8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
@@ -8,7 +8,7 @@
 #include "otx2_common.h"
 
 static int otx2_dmacflt_do_add(struct otx2_nic *pf, const u8 *mac,
-			       u32 *dmac_index)
+			       u8 *dmac_index)
 {
 	struct cgx_mac_addr_add_req *req;
 	struct cgx_mac_addr_add_rsp *rsp;
@@ -35,10 +35,9 @@ static int otx2_dmacflt_do_add(struct otx2_nic *pf, const u8 *mac,
 	return err;
 }
 
-static int otx2_dmacflt_add_pfmac(struct otx2_nic *pf, u32 *dmac_index)
+static int otx2_dmacflt_add_pfmac(struct otx2_nic *pf)
 {
 	struct cgx_mac_addr_set_or_get *req;
-	struct cgx_mac_addr_set_or_get *rsp;
 	int err;
 
 	mutex_lock(&pf->mbox.lock);
@@ -49,24 +48,16 @@ static int otx2_dmacflt_add_pfmac(struct otx2_nic *pf, u32 *dmac_index)
 		return -ENOMEM;
 	}
 
-	req->index = *dmac_index;
-
 	ether_addr_copy(req->mac_addr, pf->netdev->dev_addr);
 	err = otx2_sync_mbox_msg(&pf->mbox);
 
-	if (!err) {
-		rsp = (struct cgx_mac_addr_set_or_get *)
-			 otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &req->hdr);
-		*dmac_index = rsp->index;
-	}
-
 	mutex_unlock(&pf->mbox.lock);
 	return err;
 }
 
-int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u32 bit_pos)
+int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u8 bit_pos)
 {
-	u32 *dmacindex;
+	u8 *dmacindex;
 
 	/* Store dmacindex returned by CGX/RPM driver which will
 	 * be used for macaddr update/remove
@@ -74,13 +65,13 @@ int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u32 bit_pos)
 	dmacindex = &pf->flow_cfg->bmap_to_dmacindex[bit_pos];
 
 	if (ether_addr_equal(mac, pf->netdev->dev_addr))
-		return otx2_dmacflt_add_pfmac(pf, dmacindex);
+		return otx2_dmacflt_add_pfmac(pf);
 	else
 		return otx2_dmacflt_do_add(pf, mac, dmacindex);
 }
 
 static int otx2_dmacflt_do_remove(struct otx2_nic *pfvf, const u8 *mac,
-				  u32 dmac_index)
+				  u8 dmac_index)
 {
 	struct cgx_mac_addr_del_req *req;
 	int err;
@@ -100,9 +91,9 @@ static int otx2_dmacflt_do_remove(struct otx2_nic *pfvf, const u8 *mac,
 	return err;
 }
 
-static int otx2_dmacflt_remove_pfmac(struct otx2_nic *pf, u32 dmac_index)
+static int otx2_dmacflt_remove_pfmac(struct otx2_nic *pf)
 {
-	struct cgx_mac_addr_reset_req *req;
+	struct msg_req *req;
 	int err;
 
 	mutex_lock(&pf->mbox.lock);
@@ -111,7 +102,6 @@ static int otx2_dmacflt_remove_pfmac(struct otx2_nic *pf, u32 dmac_index)
 		mutex_unlock(&pf->mbox.lock);
 		return -ENOMEM;
 	}
-	req->index = dmac_index;
 
 	err = otx2_sync_mbox_msg(&pf->mbox);
 
@@ -120,12 +110,12 @@ static int otx2_dmacflt_remove_pfmac(struct otx2_nic *pf, u32 dmac_index)
 }
 
 int otx2_dmacflt_remove(struct otx2_nic *pf, const u8 *mac,
-			u32 bit_pos)
+			u8 bit_pos)
 {
-	u32 dmacindex = pf->flow_cfg->bmap_to_dmacindex[bit_pos];
+	u8 dmacindex = pf->flow_cfg->bmap_to_dmacindex[bit_pos];
 
 	if (ether_addr_equal(mac, pf->netdev->dev_addr))
-		return otx2_dmacflt_remove_pfmac(pf, dmacindex);
+		return otx2_dmacflt_remove_pfmac(pf);
 	else
 		return otx2_dmacflt_do_remove(pf, mac, dmacindex);
 }
@@ -161,10 +151,9 @@ int otx2_dmacflt_get_max_cnt(struct otx2_nic *pf)
 	return err;
 }
 
-int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u32 bit_pos)
+int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u8 bit_pos)
 {
 	struct cgx_mac_addr_update_req *req;
-	struct cgx_mac_addr_update_rsp *rsp;
 	int rc;
 
 	mutex_lock(&pf->mbox.lock);
@@ -178,19 +167,8 @@ int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u32 bit_pos)
 
 	ether_addr_copy(req->mac_addr, mac);
 	req->index = pf->flow_cfg->bmap_to_dmacindex[bit_pos];
-
-	/* check the response and change index */
-
 	rc = otx2_sync_mbox_msg(&pf->mbox);
-	if (rc)
-		goto out;
 
-	rsp = (struct cgx_mac_addr_update_rsp *)
-		otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &req->hdr);
-
-	pf->flow_cfg->bmap_to_dmacindex[bit_pos] = rsp->index;
-
-out:
 	mutex_unlock(&pf->mbox.lock);
 	return rc;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 709fc0114fbd..2dd192b5e4e0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -18,7 +18,7 @@ struct otx2_flow {
 	struct ethtool_rx_flow_spec flow_spec;
 	struct list_head list;
 	u32 location;
-	u32 entry;
+	u16 entry;
 	bool is_vf;
 	u8 rss_ctx_id;
 #define DMAC_FILTER_RULE		BIT(0)
@@ -232,9 +232,6 @@ static int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 	return 0;
 }
 
-/* TODO : revisit on size */
-#define OTX2_DMAC_FLTR_BITMAP_SZ (4 * 2048 + 32)
-
 int otx2vf_mcam_flow_init(struct otx2_nic *pfvf)
 {
 	struct otx2_flow_config *flow_cfg;
@@ -245,12 +242,6 @@ int otx2vf_mcam_flow_init(struct otx2_nic *pfvf)
 	if (!pfvf->flow_cfg)
 		return -ENOMEM;
 
-	pfvf->flow_cfg->dmacflt_bmap = devm_kcalloc(pfvf->dev,
-						    BITS_TO_LONGS(OTX2_DMAC_FLTR_BITMAP_SZ),
-						    sizeof(long), GFP_KERNEL);
-	if (!pfvf->flow_cfg->dmacflt_bmap)
-		return -ENOMEM;
-
 	flow_cfg = pfvf->flow_cfg;
 	INIT_LIST_HEAD(&flow_cfg->flow_list);
 	flow_cfg->max_flows = 0;
@@ -268,12 +259,6 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 	if (!pf->flow_cfg)
 		return -ENOMEM;
 
-	pf->flow_cfg->dmacflt_bmap = devm_kcalloc(pf->dev,
-						  BITS_TO_LONGS(OTX2_DMAC_FLTR_BITMAP_SZ),
-						  sizeof(long), GFP_KERNEL);
-	if (!pf->flow_cfg->dmacflt_bmap)
-		return -ENOMEM;
-
 	INIT_LIST_HEAD(&pf->flow_cfg->flow_list);
 
 	/* Allocate bare minimum number of MCAM entries needed for
@@ -299,7 +284,7 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 		return 0;
 
 	pf->flow_cfg->bmap_to_dmacindex =
-			devm_kzalloc(pf->dev, sizeof(u32) *
+			devm_kzalloc(pf->dev, sizeof(u8) *
 				     pf->flow_cfg->dmacflt_max_flows,
 				     GFP_KERNEL);
 
@@ -370,7 +355,7 @@ int otx2_add_macfilter(struct net_device *netdev, const u8 *mac)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
 
-	if (!bitmap_empty(pf->flow_cfg->dmacflt_bmap,
+	if (!bitmap_empty(&pf->flow_cfg->dmacflt_bmap,
 			  pf->flow_cfg->dmacflt_max_flows))
 		netdev_warn(netdev,
 			    "Add %pM to CGX/RPM DMAC filters list as well\n",
@@ -453,7 +438,7 @@ int otx2_get_maxflows(struct otx2_flow_config *flow_cfg)
 		return 0;
 
 	if (flow_cfg->nr_flows == flow_cfg->max_flows ||
-	    !bitmap_empty(flow_cfg->dmacflt_bmap,
+	    !bitmap_empty(&flow_cfg->dmacflt_bmap,
 			  flow_cfg->dmacflt_max_flows))
 		return flow_cfg->max_flows + flow_cfg->dmacflt_max_flows;
 	else
@@ -1025,7 +1010,7 @@ static int otx2_add_flow_with_pfmac(struct otx2_nic *pfvf,
 
 	otx2_add_flow_to_list(pfvf, pf_mac);
 	pfvf->flow_cfg->nr_flows++;
-	set_bit(0, pfvf->flow_cfg->dmacflt_bmap);
+	set_bit(0, &pfvf->flow_cfg->dmacflt_bmap);
 
 	return 0;
 }
@@ -1079,7 +1064,7 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 			return otx2_dmacflt_update(pfvf, eth_hdr->h_dest,
 						   flow->entry);
 
-		if (bitmap_full(flow_cfg->dmacflt_bmap,
+		if (bitmap_full(&flow_cfg->dmacflt_bmap,
 				flow_cfg->dmacflt_max_flows)) {
 			netdev_warn(pfvf->netdev,
 				    "Can't insert the rule %d as max allowed dmac filters are %d\n",
@@ -1093,17 +1078,17 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 		}
 
 		/* Install PF mac address to DMAC filter list */
-		if (!test_bit(0, flow_cfg->dmacflt_bmap))
+		if (!test_bit(0, &flow_cfg->dmacflt_bmap))
 			otx2_add_flow_with_pfmac(pfvf, flow);
 
 		flow->rule_type |= DMAC_FILTER_RULE;
-		flow->entry = find_first_zero_bit(flow_cfg->dmacflt_bmap,
+		flow->entry = find_first_zero_bit(&flow_cfg->dmacflt_bmap,
 						  flow_cfg->dmacflt_max_flows);
 		fsp->location = flow_cfg->max_flows + flow->entry;
 		flow->flow_spec.location = fsp->location;
 		flow->location = fsp->location;
 
-		set_bit(flow->entry, flow_cfg->dmacflt_bmap);
+		set_bit(flow->entry, &flow_cfg->dmacflt_bmap);
 		otx2_dmacflt_add(pfvf, eth_hdr->h_dest, flow->entry);
 
 	} else {
@@ -1169,12 +1154,11 @@ static void otx2_update_rem_pfmac(struct otx2_nic *pfvf, int req)
 			if (req == DMAC_ADDR_DEL) {
 				otx2_dmacflt_remove(pfvf, eth_hdr->h_dest,
 						    0);
-				clear_bit(0, pfvf->flow_cfg->dmacflt_bmap);
+				clear_bit(0, &pfvf->flow_cfg->dmacflt_bmap);
 				found = true;
 			} else {
 				ether_addr_copy(eth_hdr->h_dest,
 						pfvf->netdev->dev_addr);
-
 				otx2_dmacflt_update(pfvf, eth_hdr->h_dest, 0);
 			}
 			break;
@@ -1210,12 +1194,12 @@ int otx2_remove_flow(struct otx2_nic *pfvf, u32 location)
 
 		err = otx2_dmacflt_remove(pfvf, eth_hdr->h_dest,
 					  flow->entry);
-		clear_bit(flow->entry, flow_cfg->dmacflt_bmap);
+		clear_bit(flow->entry, &flow_cfg->dmacflt_bmap);
 		/* If all dmac filters are removed delete macfilter with
 		 * interface mac address and configure CGX/RPM block in
 		 * promiscuous mode
 		 */
-		if (bitmap_weight(flow_cfg->dmacflt_bmap,
+		if (bitmap_weight(&flow_cfg->dmacflt_bmap,
 				  flow_cfg->dmacflt_max_flows) == 1)
 			otx2_update_rem_pfmac(pfvf, DMAC_ADDR_DEL);
 	} else {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 9376d0e62914..9106c359e64c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1120,7 +1120,7 @@ static int otx2_cgx_config_loopback(struct otx2_nic *pf, bool enable)
 	struct msg_req *msg;
 	int err;
 
-	if (enable && !bitmap_empty(pf->flow_cfg->dmacflt_bmap,
+	if (enable && !bitmap_empty(&pf->flow_cfg->dmacflt_bmap,
 				    pf->flow_cfg->dmacflt_max_flows))
 		netdev_warn(pf->netdev,
 			    "CGX/RPM internal loopback might not work as DMAC filters are active\n");
-- 
2.36.1

