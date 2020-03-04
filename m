Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 743EA179C4B
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388612AbgCDXVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:21:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:48332 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388578AbgCDXVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 18:21:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 15:21:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244094655"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 15:21:38 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/16] ice: use variable name more descriptive than type
Date:   Wed,  4 Mar 2020 15:21:35 -0800
Message-Id: <20200304232136.4172118-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

The variable name 'type' is not very descriptive. Replace instances of
those with a variable name that is more descriptive or replace it if not
needed.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 16 ++++++-------
 drivers/net/ethernet/intel/ice/ice_flow.c    |  8 +++----
 drivers/net/ethernet/intel/ice/ice_lib.c     | 24 ++++++++++----------
 drivers/net/ethernet/intel/ice/ice_lib.h     |  4 ++--
 drivers/net/ethernet/intel/ice/ice_switch.c  | 20 ++++++++--------
 5 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 140a90cc6436..7bea09363b42 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -779,7 +779,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	bool need_reconfig = false;
 	struct ice_port_info *pi;
 	struct ice_vsi *pf_vsi;
-	u8 type;
+	u8 mib_type;
 	int ret;
 
 	/* Not DCB capable or capability disabled */
@@ -794,16 +794,16 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	pi = pf->hw.port_info;
 	mib = (struct ice_aqc_lldp_get_mib *)&event->desc.params.raw;
 	/* Ignore if event is not for Nearest Bridge */
-	type = ((mib->type >> ICE_AQ_LLDP_BRID_TYPE_S) &
-		ICE_AQ_LLDP_BRID_TYPE_M);
-	dev_dbg(dev, "LLDP event MIB bridge type 0x%x\n", type);
-	if (type != ICE_AQ_LLDP_BRID_TYPE_NEAREST_BRID)
+	mib_type = ((mib->type >> ICE_AQ_LLDP_BRID_TYPE_S) &
+		    ICE_AQ_LLDP_BRID_TYPE_M);
+	dev_dbg(dev, "LLDP event MIB bridge type 0x%x\n", mib_type);
+	if (mib_type != ICE_AQ_LLDP_BRID_TYPE_NEAREST_BRID)
 		return;
 
 	/* Check MIB Type and return if event for Remote MIB update */
-	type = mib->type & ICE_AQ_LLDP_MIB_TYPE_M;
-	dev_dbg(dev, "LLDP event mib type %s\n", type ? "remote" : "local");
-	if (type == ICE_AQ_LLDP_MIB_REMOTE) {
+	mib_type = mib->type & ICE_AQ_LLDP_MIB_TYPE_M;
+	dev_dbg(dev, "LLDP event mib type %s\n", mib_type ? "remote" : "local");
+	if (mib_type == ICE_AQ_LLDP_MIB_REMOTE) {
 		/* Update the remote cached instance and return */
 		ret = ice_aq_get_dcb_cfg(pi->hw, ICE_AQ_LLDP_MIB_REMOTE,
 					 ICE_AQ_LLDP_BRID_TYPE_NEAREST_BRID,
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index d0dbd4143115..07875db08c3f 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -718,7 +718,7 @@ ice_flow_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
  * ice_flow_set_fld_ext - specifies locations of field from entry's input buffer
  * @seg: packet segment the field being set belongs to
  * @fld: field to be set
- * @type: type of the field
+ * @field_type: type of the field
  * @val_loc: if not ICE_FLOW_FLD_OFF_INVAL, location of the value to match from
  *           entry's input buffer
  * @mask_loc: if not ICE_FLOW_FLD_OFF_INVAL, location of mask value from entry's
@@ -739,16 +739,16 @@ ice_flow_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
  */
 static void
 ice_flow_set_fld_ext(struct ice_flow_seg_info *seg, enum ice_flow_field fld,
-		     enum ice_flow_fld_match_type type, u16 val_loc,
+		     enum ice_flow_fld_match_type field_type, u16 val_loc,
 		     u16 mask_loc, u16 last_loc)
 {
 	u64 bit = BIT_ULL(fld);
 
 	seg->match |= bit;
-	if (type == ICE_FLOW_FLD_TYPE_RANGE)
+	if (field_type == ICE_FLOW_FLD_TYPE_RANGE)
 		seg->range |= bit;
 
-	seg->fields[fld].type = type;
+	seg->fields[fld].type = field_type;
 	seg->fields[fld].src.val = val_loc;
 	seg->fields[fld].src.mask = mask_loc;
 	seg->fields[fld].src.last = last_loc;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 1ee6a86f507d..2f256bf45efc 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -9,11 +9,11 @@
 
 /**
  * ice_vsi_type_str - maps VSI type enum to string equivalents
- * @type: VSI type enum
+ * @vsi_type: VSI type enum
  */
-const char *ice_vsi_type_str(enum ice_vsi_type type)
+const char *ice_vsi_type_str(enum ice_vsi_type vsi_type)
 {
-	switch (type) {
+	switch (vsi_type) {
 	case ICE_VSI_PF:
 		return "ICE_VSI_PF";
 	case ICE_VSI_VF:
@@ -350,13 +350,13 @@ static irqreturn_t ice_msix_clean_rings(int __always_unused irq, void *data)
 /**
  * ice_vsi_alloc - Allocates the next available struct VSI in the PF
  * @pf: board private structure
- * @type: type of VSI
+ * @vsi_type: type of VSI
  * @vf_id: ID of the VF being configured
  *
  * returns a pointer to a VSI on success, NULL on failure.
  */
 static struct ice_vsi *
-ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type type, u16 vf_id)
+ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type, u16 vf_id)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_vsi *vsi = NULL;
@@ -377,13 +377,13 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type type, u16 vf_id)
 	if (!vsi)
 		goto unlock_pf;
 
-	vsi->type = type;
+	vsi->type = vsi_type;
 	vsi->back = pf;
 	set_bit(__ICE_DOWN, vsi->state);
 
 	vsi->idx = pf->next_vsi;
 
-	if (type == ICE_VSI_VF)
+	if (vsi_type == ICE_VSI_VF)
 		ice_vsi_set_num_qs(vsi, vf_id);
 	else
 		ice_vsi_set_num_qs(vsi, ICE_INVAL_VFID);
@@ -2084,7 +2084,7 @@ void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create)
  * ice_vsi_setup - Set up a VSI by a given type
  * @pf: board private structure
  * @pi: pointer to the port_info instance
- * @type: VSI type
+ * @vsi_type: VSI type
  * @vf_id: defines VF ID to which this VSI connects. This field is meant to be
  *         used only for ICE_VSI_VF VSI type. For other VSI types, should
  *         fill-in ICE_INVAL_VFID as input.
@@ -2096,7 +2096,7 @@ void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create)
  */
 struct ice_vsi *
 ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
-	      enum ice_vsi_type type, u16 vf_id)
+	      enum ice_vsi_type vsi_type, u16 vf_id)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct device *dev = ice_pf_to_dev(pf);
@@ -2104,10 +2104,10 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	struct ice_vsi *vsi;
 	int ret, i;
 
-	if (type == ICE_VSI_VF)
-		vsi = ice_vsi_alloc(pf, type, vf_id);
+	if (vsi_type == ICE_VSI_VF)
+		vsi = ice_vsi_alloc(pf, vsi_type, vf_id);
 	else
-		vsi = ice_vsi_alloc(pf, type, ICE_INVAL_VFID);
+		vsi = ice_vsi_alloc(pf, vsi_type, ICE_INVAL_VFID);
 
 	if (!vsi) {
 		dev_err(dev, "could not allocate VSI\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 585f1350403f..04ca00799364 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -6,7 +6,7 @@
 
 #include "ice.h"
 
-const char *ice_vsi_type_str(enum ice_vsi_type type);
+const char *ice_vsi_type_str(enum ice_vsi_type vsi_type);
 
 int
 ice_add_mac_to_list(struct ice_vsi *vsi, struct list_head *add_list,
@@ -58,7 +58,7 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc);
 
 struct ice_vsi *
 ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
-	      enum ice_vsi_type type, u16 vf_id);
+	      enum ice_vsi_type vsi_type, u16 vf_id);
 
 void ice_napi_del(struct ice_vsi *vsi);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 4d96abfd05d6..51825a203e35 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -578,7 +578,7 @@ enum ice_status ice_get_initial_sw_cfg(struct ice_hw *hw)
 			struct ice_aqc_get_sw_cfg_resp_elem *ele;
 			u16 pf_vf_num, swid, vsi_port_num;
 			bool is_vf = false;
-			u8 type;
+			u8 res_type;
 
 			ele = rbuf[i].elements;
 			vsi_port_num = le16_to_cpu(ele->vsi_port_num) &
@@ -593,16 +593,16 @@ enum ice_status ice_get_initial_sw_cfg(struct ice_hw *hw)
 			    ICE_AQC_GET_SW_CONF_RESP_IS_VF)
 				is_vf = true;
 
-			type = le16_to_cpu(ele->vsi_port_num) >>
+			res_type = le16_to_cpu(ele->vsi_port_num) >>
 				ICE_AQC_GET_SW_CONF_RESP_TYPE_S;
 
-			if (type == ICE_AQC_GET_SW_CONF_RESP_VSI) {
+			if (res_type == ICE_AQC_GET_SW_CONF_RESP_VSI) {
 				/* FW VSI is not needed. Just continue. */
 				continue;
 			}
 
 			ice_init_port_info(hw->port_info, vsi_port_num,
-					   type, swid, pf_vf_num, is_vf);
+					   res_type, swid, pf_vf_num, is_vf);
 		}
 	} while (req_desc && !status);
 
@@ -958,7 +958,7 @@ ice_update_vsi_list_rule(struct ice_hw *hw, u16 *vsi_handle_arr, u16 num_vsi,
 	struct ice_aqc_sw_rules_elem *s_rule;
 	enum ice_status status;
 	u16 s_rule_size;
-	u16 type;
+	u16 rule_type;
 	int i;
 
 	if (!num_vsi)
@@ -970,11 +970,11 @@ ice_update_vsi_list_rule(struct ice_hw *hw, u16 *vsi_handle_arr, u16 num_vsi,
 	    lkup_type == ICE_SW_LKUP_ETHERTYPE_MAC ||
 	    lkup_type == ICE_SW_LKUP_PROMISC ||
 	    lkup_type == ICE_SW_LKUP_PROMISC_VLAN)
-		type = remove ? ICE_AQC_SW_RULES_T_VSI_LIST_CLEAR :
-				ICE_AQC_SW_RULES_T_VSI_LIST_SET;
+		rule_type = remove ? ICE_AQC_SW_RULES_T_VSI_LIST_CLEAR :
+			ICE_AQC_SW_RULES_T_VSI_LIST_SET;
 	else if (lkup_type == ICE_SW_LKUP_VLAN)
-		type = remove ? ICE_AQC_SW_RULES_T_PRUNE_LIST_CLEAR :
-				ICE_AQC_SW_RULES_T_PRUNE_LIST_SET;
+		rule_type = remove ? ICE_AQC_SW_RULES_T_PRUNE_LIST_CLEAR :
+			ICE_AQC_SW_RULES_T_PRUNE_LIST_SET;
 	else
 		return ICE_ERR_PARAM;
 
@@ -992,7 +992,7 @@ ice_update_vsi_list_rule(struct ice_hw *hw, u16 *vsi_handle_arr, u16 num_vsi,
 			cpu_to_le16(ice_get_hw_vsi_num(hw, vsi_handle_arr[i]));
 	}
 
-	s_rule->type = cpu_to_le16(type);
+	s_rule->type = cpu_to_le16(rule_type);
 	s_rule->pdata.vsi_list.number_vsi = cpu_to_le16(num_vsi);
 	s_rule->pdata.vsi_list.index = cpu_to_le16(vsi_list_id);
 
-- 
2.24.1

