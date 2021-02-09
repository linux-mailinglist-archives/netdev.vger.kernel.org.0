Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779C3314577
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhBIBRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:17:01 -0500
Received: from mga04.intel.com ([192.55.52.120]:52204 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhBIBQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 20:16:47 -0500
IronPort-SDR: Lh7jAlE1U8X3Ji8mT+OEw3veosO0RPsPNxZXwnPqU3iXoOEYJegHCGV+WOnYH3YlwoiXRnBJqW
 4TmLNWPaGv4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="179250875"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="179250875"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 17:15:48 -0800
IronPort-SDR: fUw3tvvnLrsIdzRSSvjyKnTA0Fm53Oh+pcADdgwcHN/sd5GjtEFuxK9STBGiNXqp42O+JdieAM
 PiMdB7Nsz3oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="487669621"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2021 17:15:48 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 09/12] ice: remove unnecessary casts
Date:   Mon,  8 Feb 2021 17:16:33 -0800
Message-Id: <20210209011636.1989093-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
References: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Casting a void * rvalue in an assignment is unnecessary in C; remove the
casts.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c    |  6 +++---
 drivers/net/ethernet/intel/ice/ice_controlq.c  |  4 ++--
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 10 +++++-----
 drivers/net/ethernet/intel/ice/ice_switch.c    |  2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index e9b40cdfeb0c..3d9475e222cd 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -110,7 +110,7 @@ ice_aq_manage_mac_read(struct ice_hw *hw, void *buf, u16 buf_size,
 	if (status)
 		return status;
 
-	resp = (struct ice_aqc_manage_mac_read_resp *)buf;
+	resp = buf;
 	flags = le16_to_cpu(cmd->flags) & ICE_AQC_MAN_MAC_READ_M;
 
 	if (!(flags & ICE_AQC_MAN_MAC_LAN_ADDR_VALID)) {
@@ -1980,7 +1980,7 @@ ice_parse_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_p,
 	struct ice_aqc_list_caps_elem *cap_resp;
 	u32 i;
 
-	cap_resp = (struct ice_aqc_list_caps_elem *)buf;
+	cap_resp = buf;
 
 	memset(func_p, 0, sizeof(*func_p));
 
@@ -2110,7 +2110,7 @@ ice_parse_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
 	struct ice_aqc_list_caps_elem *cap_resp;
 	u32 i;
 
-	cap_resp = (struct ice_aqc_list_caps_elem *)buf;
+	cap_resp = buf;
 
 	memset(dev_p, 0, sizeof(*dev_p));
 
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 4db12d1f5808..b2d8a5932b1d 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -838,7 +838,7 @@ static u16 ice_clean_sq(struct ice_hw *hw, struct ice_ctl_q_info *cq)
  */
 static void ice_debug_cq(struct ice_hw *hw, void *desc, void *buf, u16 buf_len)
 {
-	struct ice_aq_desc *cq_desc = (struct ice_aq_desc *)desc;
+	struct ice_aq_desc *cq_desc = desc;
 	u16 len;
 
 	if (!IS_ENABLED(CONFIG_DYNAMIC_DEBUG) &&
@@ -868,7 +868,7 @@ static void ice_debug_cq(struct ice_hw *hw, void *desc, void *buf, u16 buf_len)
 		if (buf_len < len)
 			len = buf_len;
 
-		ice_debug_array(hw, ICE_DBG_AQ_DESC_BUF, 16, 1, (u8 *)buf, len);
+		ice_debug_array(hw, ICE_DBG_AQ_DESC_BUF, 16, 1, buf, len);
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index cf5b717b9293..5e1fd30c0a0f 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -2727,7 +2727,7 @@ static void ice_fill_tbl(struct ice_hw *hw, enum ice_block block_id, u32 sid)
 		case ICE_SID_XLT1_RSS:
 		case ICE_SID_XLT1_ACL:
 		case ICE_SID_XLT1_PE:
-			xlt1 = (struct ice_xlt1_section *)sect;
+			xlt1 = sect;
 			src = xlt1->value;
 			sect_len = le16_to_cpu(xlt1->count) *
 				sizeof(*hw->blk[block_id].xlt1.t);
@@ -2740,7 +2740,7 @@ static void ice_fill_tbl(struct ice_hw *hw, enum ice_block block_id, u32 sid)
 		case ICE_SID_XLT2_RSS:
 		case ICE_SID_XLT2_ACL:
 		case ICE_SID_XLT2_PE:
-			xlt2 = (struct ice_xlt2_section *)sect;
+			xlt2 = sect;
 			src = (__force u8 *)xlt2->value;
 			sect_len = le16_to_cpu(xlt2->count) *
 				sizeof(*hw->blk[block_id].xlt2.t);
@@ -2753,7 +2753,7 @@ static void ice_fill_tbl(struct ice_hw *hw, enum ice_block block_id, u32 sid)
 		case ICE_SID_PROFID_TCAM_RSS:
 		case ICE_SID_PROFID_TCAM_ACL:
 		case ICE_SID_PROFID_TCAM_PE:
-			pid = (struct ice_prof_id_section *)sect;
+			pid = sect;
 			src = (u8 *)pid->entry;
 			sect_len = le16_to_cpu(pid->count) *
 				sizeof(*hw->blk[block_id].prof.t);
@@ -2766,7 +2766,7 @@ static void ice_fill_tbl(struct ice_hw *hw, enum ice_block block_id, u32 sid)
 		case ICE_SID_PROFID_REDIR_RSS:
 		case ICE_SID_PROFID_REDIR_ACL:
 		case ICE_SID_PROFID_REDIR_PE:
-			pr = (struct ice_prof_redir_section *)sect;
+			pr = sect;
 			src = pr->redir_value;
 			sect_len = le16_to_cpu(pr->count) *
 				sizeof(*hw->blk[block_id].prof_redir.t);
@@ -2779,7 +2779,7 @@ static void ice_fill_tbl(struct ice_hw *hw, enum ice_block block_id, u32 sid)
 		case ICE_SID_FLD_VEC_RSS:
 		case ICE_SID_FLD_VEC_ACL:
 		case ICE_SID_FLD_VEC_PE:
-			es = (struct ice_sw_fv_section *)sect;
+			es = sect;
 			src = (u8 *)es->fv;
 			sect_len = (u32)(le16_to_cpu(es->count) *
 					 hw->blk[block_id].es.fvw) *
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index c33612132ddf..67c965a3f5d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -603,7 +603,7 @@ enum ice_status ice_get_initial_sw_cfg(struct ice_hw *hw)
 		}
 	} while (req_desc && !status);
 
-	devm_kfree(ice_hw_to_dev(hw), (void *)rbuf);
+	devm_kfree(ice_hw_to_dev(hw), rbuf);
 	return status;
 }
 
-- 
2.26.2

