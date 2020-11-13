Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD9F2B275B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgKMVph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:45:37 -0500
Received: from mga06.intel.com ([134.134.136.31]:18954 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbgKMVpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:45:14 -0500
IronPort-SDR: gXJiJFwvrueNn96B0uvRViDjNt7cLnnSwEWajXAwFVYJ2kxc7k9nw/Vxjz0D70Vpnb3hmCCgN4
 0ht7/N+BcgKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="232153176"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="232153176"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:44:59 -0800
IronPort-SDR: nKErWZMG3qAtbfCvv6aD+Kqszohk9Wosxnz8PKOHteiK0EsRUWDyctdt9CfmwVkztcB6UaKvna
 I/sqQfaX6Yeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="532715906"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 13 Nov 2020 13:44:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v3 14/15] ice: join format strings to same line as ice_debug
Date:   Fri, 13 Nov 2020 13:44:28 -0800
Message-Id: <20201113214429.2131951-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

When printing messages with ice_debug, align the printed string to the
origin line of the message in order to ease debugging and tracking
messages back to their source.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 102 ++++++------------
 drivers/net/ethernet/intel/ice/ice_controlq.c |  42 +++-----
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  24 ++---
 drivers/net/ethernet/intel/ice/ice_flow.c     |   9 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      |  27 ++---
 drivers/net/ethernet/intel/ice/ice_sched.c    |  21 ++--
 drivers/net/ethernet/intel/ice/ice_switch.c   |  15 +--
 7 files changed, 80 insertions(+), 160 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 59459b6ccb9c..625f54d1edcf 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -904,8 +904,7 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 	/* Query the allocated resources for Tx scheduler */
 	status = ice_sched_query_res_alloc(hw);
 	if (status) {
-		ice_debug(hw, ICE_DBG_SCHED,
-			  "Failed to get scheduler allocated resources\n");
+		ice_debug(hw, ICE_DBG_SCHED, "Failed to get scheduler allocated resources\n");
 		goto err_unroll_alloc;
 	}
 
@@ -1044,8 +1043,7 @@ enum ice_status ice_check_reset(struct ice_hw *hw)
 	}
 
 	if (cnt == grst_timeout) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Global reset polling failed to complete.\n");
+		ice_debug(hw, ICE_DBG_INIT, "Global reset polling failed to complete.\n");
 		return ICE_ERR_RESET_FAILED;
 	}
 
@@ -1063,16 +1061,14 @@ enum ice_status ice_check_reset(struct ice_hw *hw)
 	for (cnt = 0; cnt < ICE_PF_RESET_WAIT_COUNT; cnt++) {
 		reg = rd32(hw, GLNVM_ULD) & uld_mask;
 		if (reg == uld_mask) {
-			ice_debug(hw, ICE_DBG_INIT,
-				  "Global reset processes done. %d\n", cnt);
+			ice_debug(hw, ICE_DBG_INIT, "Global reset processes done. %d\n", cnt);
 			break;
 		}
 		mdelay(10);
 	}
 
 	if (cnt == ICE_PF_RESET_WAIT_COUNT) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Wait for Reset Done timed out. GLNVM_ULD = 0x%x\n",
+		ice_debug(hw, ICE_DBG_INIT, "Wait for Reset Done timed out. GLNVM_ULD = 0x%x\n",
 			  reg);
 		return ICE_ERR_RESET_FAILED;
 	}
@@ -1124,8 +1120,7 @@ static enum ice_status ice_pf_reset(struct ice_hw *hw)
 	}
 
 	if (cnt == ICE_PF_RESET_WAIT_COUNT) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "PF reset polling failed to complete.\n");
+		ice_debug(hw, ICE_DBG_INIT, "PF reset polling failed to complete.\n");
 		return ICE_ERR_RESET_FAILED;
 	}
 
@@ -1578,8 +1573,7 @@ ice_acquire_res(struct ice_hw *hw, enum ice_aq_res_ids res,
 		goto ice_acquire_res_exit;
 
 	if (status)
-		ice_debug(hw, ICE_DBG_RES,
-			  "resource %d acquire type %d failed.\n", res, access);
+		ice_debug(hw, ICE_DBG_RES, "resource %d acquire type %d failed.\n", res, access);
 
 	/* If necessary, poll until the current lock owner timeouts */
 	timeout = time_left;
@@ -1602,11 +1596,9 @@ ice_acquire_res(struct ice_hw *hw, enum ice_aq_res_ids res,
 ice_acquire_res_exit:
 	if (status == ICE_ERR_AQ_NO_WORK) {
 		if (access == ICE_RES_WRITE)
-			ice_debug(hw, ICE_DBG_RES,
-				  "resource indicates no work to do.\n");
+			ice_debug(hw, ICE_DBG_RES, "resource indicates no work to do.\n");
 		else
-			ice_debug(hw, ICE_DBG_RES,
-				  "Warning: ICE_ERR_AQ_NO_WORK not expected\n");
+			ice_debug(hw, ICE_DBG_RES, "Warning: ICE_ERR_AQ_NO_WORK not expected\n");
 	}
 	return status;
 }
@@ -1792,66 +1784,53 @@ ice_parse_common_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps,
 	switch (cap) {
 	case ICE_AQC_CAPS_VALID_FUNCTIONS:
 		caps->valid_functions = number;
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: valid_functions (bitmap) = %d\n", prefix,
+		ice_debug(hw, ICE_DBG_INIT, "%s: valid_functions (bitmap) = %d\n", prefix,
 			  caps->valid_functions);
 		break;
 	case ICE_AQC_CAPS_SRIOV:
 		caps->sr_iov_1_1 = (number == 1);
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: sr_iov_1_1 = %d\n", prefix,
+		ice_debug(hw, ICE_DBG_INIT, "%s: sr_iov_1_1 = %d\n", prefix,
 			  caps->sr_iov_1_1);
 		break;
 	case ICE_AQC_CAPS_DCB:
 		caps->dcb = (number == 1);
 		caps->active_tc_bitmap = logical_id;
 		caps->maxtc = phys_id;
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: dcb = %d\n", prefix, caps->dcb);
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: active_tc_bitmap = %d\n", prefix,
+		ice_debug(hw, ICE_DBG_INIT, "%s: dcb = %d\n", prefix, caps->dcb);
+		ice_debug(hw, ICE_DBG_INIT, "%s: active_tc_bitmap = %d\n", prefix,
 			  caps->active_tc_bitmap);
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: maxtc = %d\n", prefix, caps->maxtc);
+		ice_debug(hw, ICE_DBG_INIT, "%s: maxtc = %d\n", prefix, caps->maxtc);
 		break;
 	case ICE_AQC_CAPS_RSS:
 		caps->rss_table_size = number;
 		caps->rss_table_entry_width = logical_id;
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: rss_table_size = %d\n", prefix,
+		ice_debug(hw, ICE_DBG_INIT, "%s: rss_table_size = %d\n", prefix,
 			  caps->rss_table_size);
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: rss_table_entry_width = %d\n", prefix,
+		ice_debug(hw, ICE_DBG_INIT, "%s: rss_table_entry_width = %d\n", prefix,
 			  caps->rss_table_entry_width);
 		break;
 	case ICE_AQC_CAPS_RXQS:
 		caps->num_rxq = number;
 		caps->rxq_first_id = phys_id;
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: num_rxq = %d\n", prefix,
+		ice_debug(hw, ICE_DBG_INIT, "%s: num_rxq = %d\n", prefix,
 			  caps->num_rxq);
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: rxq_first_id = %d\n", prefix,
+		ice_debug(hw, ICE_DBG_INIT, "%s: rxq_first_id = %d\n", prefix,
 			  caps->rxq_first_id);
 		break;
 	case ICE_AQC_CAPS_TXQS:
 		caps->num_txq = number;
 		caps->txq_first_id = phys_id;
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: num_txq = %d\n", prefix,
+		ice_debug(hw, ICE_DBG_INIT, "%s: num_txq = %d\n", prefix,
 			  caps->num_txq);
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: txq_first_id = %d\n", prefix,
+		ice_debug(hw, ICE_DBG_INIT, "%s: txq_first_id = %d\n", prefix,
 			  caps->txq_first_id);
 		break;
 	case ICE_AQC_CAPS_MSIX:
 		caps->num_msix_vectors = number;
 		caps->msix_vector_first_id = phys_id;
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: num_msix_vectors = %d\n", prefix,
+		ice_debug(hw, ICE_DBG_INIT, "%s: num_msix_vectors = %d\n", prefix,
 			  caps->num_msix_vectors);
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: msix_vector_first_id = %d\n", prefix,
+		ice_debug(hw, ICE_DBG_INIT, "%s: msix_vector_first_id = %d\n", prefix,
 			  caps->msix_vector_first_id);
 		break;
 	case ICE_AQC_CAPS_PENDING_NVM_VER:
@@ -1904,8 +1883,7 @@ ice_recalc_port_limited_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps)
 	if (hw->dev_caps.num_funcs > 4) {
 		/* Max 4 TCs per port */
 		caps->maxtc = 4;
-		ice_debug(hw, ICE_DBG_INIT,
-			  "reducing maxtc to %d (based on #ports)\n",
+		ice_debug(hw, ICE_DBG_INIT, "reducing maxtc to %d (based on #ports)\n",
 			  caps->maxtc);
 	}
 }
@@ -1973,11 +1951,9 @@ ice_parse_fdir_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_p)
 		GLQF_FD_SIZE_FD_BSIZE_S;
 	func_p->fd_fltr_best_effort = val;
 
-	ice_debug(hw, ICE_DBG_INIT,
-		  "func caps: fd_fltr_guar = %d\n",
+	ice_debug(hw, ICE_DBG_INIT, "func caps: fd_fltr_guar = %d\n",
 		  func_p->fd_fltr_guar);
-	ice_debug(hw, ICE_DBG_INIT,
-		  "func caps: fd_fltr_best_effort = %d\n",
+	ice_debug(hw, ICE_DBG_INIT, "func caps: fd_fltr_best_effort = %d\n",
 		  func_p->fd_fltr_best_effort);
 }
 
@@ -2026,8 +2002,7 @@ ice_parse_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_p,
 		default:
 			/* Don't list common capabilities as unknown */
 			if (!found)
-				ice_debug(hw, ICE_DBG_INIT,
-					  "func caps: unknown capability[%d]: 0x%x\n",
+				ice_debug(hw, ICE_DBG_INIT, "func caps: unknown capability[%d]: 0x%x\n",
 					  i, cap);
 			break;
 		}
@@ -2160,8 +2135,7 @@ ice_parse_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
 		default:
 			/* Don't list common capabilities as unknown */
 			if (!found)
-				ice_debug(hw, ICE_DBG_INIT,
-					  "dev caps: unknown capability[%d]: 0x%x\n",
+				ice_debug(hw, ICE_DBG_INIT, "dev caps: unknown capability[%d]: 0x%x\n",
 					  i, cap);
 			break;
 		}
@@ -2618,8 +2592,7 @@ ice_aq_set_phy_cfg(struct ice_hw *hw, struct ice_port_info *pi,
 
 	/* Ensure that only valid bits of cfg->caps can be turned on. */
 	if (cfg->caps & ~ICE_AQ_PHY_ENA_VALID_MASK) {
-		ice_debug(hw, ICE_DBG_PHY,
-			  "Invalid bit is set in ice_aqc_set_phy_cfg_data->caps : 0x%x\n",
+		ice_debug(hw, ICE_DBG_PHY, "Invalid bit is set in ice_aqc_set_phy_cfg_data->caps : 0x%x\n",
 			  cfg->caps);
 
 		cfg->caps &= ICE_AQ_PHY_ENA_VALID_MASK;
@@ -3067,8 +3040,7 @@ enum ice_status ice_get_link_status(struct ice_port_info *pi, bool *link_up)
 		status = ice_update_link_info(pi);
 
 		if (status)
-			ice_debug(pi->hw, ICE_DBG_LINK,
-				  "get link status error, status = %d\n",
+			ice_debug(pi->hw, ICE_DBG_LINK, "get link status error, status = %d\n",
 				  status);
 	}
 
@@ -3793,8 +3765,7 @@ ice_set_ctx(struct ice_hw *hw, u8 *src_ctx, u8 *dest_ctx,
 		 * of the endianness of the machine.
 		 */
 		if (ce_info[f].width > (ce_info[f].size_of * BITS_PER_BYTE)) {
-			ice_debug(hw, ICE_DBG_QCTX,
-				  "Field %d width of %d bits larger than size of %d byte(s) ... skipping write\n",
+			ice_debug(hw, ICE_DBG_QCTX, "Field %d width of %d bits larger than size of %d byte(s) ... skipping write\n",
 				  f, ce_info[f].width, ce_info[f].size_of);
 			continue;
 		}
@@ -4292,8 +4263,7 @@ ice_get_link_default_override(struct ice_link_default_override_tlv *ldo,
 	status = ice_get_pfa_module_tlv(hw, &tlv, &tlv_len,
 					ICE_SR_LINK_DEFAULT_OVERRIDE_PTR);
 	if (status) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Failed to read link override TLV.\n");
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read link override TLV.\n");
 		return status;
 	}
 
@@ -4304,8 +4274,7 @@ ice_get_link_default_override(struct ice_link_default_override_tlv *ldo,
 	/* link options first */
 	status = ice_read_sr_word(hw, tlv_start, &buf);
 	if (status) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Failed to read override link options.\n");
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read override link options.\n");
 		return status;
 	}
 	ldo->options = buf & ICE_LINK_OVERRIDE_OPT_M;
@@ -4316,8 +4285,7 @@ ice_get_link_default_override(struct ice_link_default_override_tlv *ldo,
 	offset = tlv_start + ICE_SR_PFA_LINK_OVERRIDE_FEC_OFFSET;
 	status = ice_read_sr_word(hw, offset, &buf);
 	if (status) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Failed to read override phy config.\n");
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read override phy config.\n");
 		return status;
 	}
 	ldo->fec_options = buf & ICE_LINK_OVERRIDE_FEC_OPT_M;
@@ -4327,8 +4295,7 @@ ice_get_link_default_override(struct ice_link_default_override_tlv *ldo,
 	for (i = 0; i < ICE_SR_PFA_LINK_OVERRIDE_PHY_WORDS; i++) {
 		status = ice_read_sr_word(hw, (offset + i), &buf);
 		if (status) {
-			ice_debug(hw, ICE_DBG_INIT,
-				  "Failed to read override link options.\n");
+			ice_debug(hw, ICE_DBG_INIT, "Failed to read override link options.\n");
 			return status;
 		}
 		/* shift 16 bits at a time to fill 64 bits */
@@ -4341,8 +4308,7 @@ ice_get_link_default_override(struct ice_link_default_override_tlv *ldo,
 	for (i = 0; i < ICE_SR_PFA_LINK_OVERRIDE_PHY_WORDS; i++) {
 		status = ice_read_sr_word(hw, (offset + i), &buf);
 		if (status) {
-			ice_debug(hw, ICE_DBG_INIT,
-				  "Failed to read override link options.\n");
+			ice_debug(hw, ICE_DBG_INIT, "Failed to read override link options.\n");
 			return status;
 		}
 		/* shift 16 bits at a time to fill 64 bits */
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 1f46a7828be8..4db12d1f5808 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -717,8 +717,7 @@ enum ice_status ice_init_all_ctrlq(struct ice_hw *hw)
 		if (status != ICE_ERR_AQ_FW_CRITICAL)
 			break;
 
-		ice_debug(hw, ICE_DBG_AQ_MSG,
-			  "Retry Admin Queue init due to FW critical error\n");
+		ice_debug(hw, ICE_DBG_AQ_MSG, "Retry Admin Queue init due to FW critical error\n");
 		ice_shutdown_ctrlq(hw, ICE_CTL_Q_ADMIN);
 		msleep(ICE_CTL_Q_ADMIN_INIT_MSEC);
 	} while (retry++ < ICE_CTL_Q_ADMIN_INIT_TIMEOUT);
@@ -813,8 +812,7 @@ static u16 ice_clean_sq(struct ice_hw *hw, struct ice_ctl_q_info *cq)
 	details = ICE_CTL_Q_DETAILS(*sq, ntc);
 
 	while (rd32(hw, cq->sq.head) != ntc) {
-		ice_debug(hw, ICE_DBG_AQ_MSG,
-			  "ntc %d head %d.\n", ntc, rd32(hw, cq->sq.head));
+		ice_debug(hw, ICE_DBG_AQ_MSG, "ntc %d head %d.\n", ntc, rd32(hw, cq->sq.head));
 		memset(desc, 0, sizeof(*desc));
 		memset(details, 0, sizeof(*details));
 		ntc++;
@@ -852,8 +850,7 @@ static void ice_debug_cq(struct ice_hw *hw, void *desc, void *buf, u16 buf_len)
 
 	len = le16_to_cpu(cq_desc->datalen);
 
-	ice_debug(hw, ICE_DBG_AQ_DESC,
-		  "CQ CMD: opcode 0x%04X, flags 0x%04X, datalen 0x%04X, retval 0x%04X\n",
+	ice_debug(hw, ICE_DBG_AQ_DESC, "CQ CMD: opcode 0x%04X, flags 0x%04X, datalen 0x%04X, retval 0x%04X\n",
 		  le16_to_cpu(cq_desc->opcode),
 		  le16_to_cpu(cq_desc->flags),
 		  le16_to_cpu(cq_desc->datalen), le16_to_cpu(cq_desc->retval));
@@ -925,8 +922,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	cq->sq_last_status = ICE_AQ_RC_OK;
 
 	if (!cq->sq.count) {
-		ice_debug(hw, ICE_DBG_AQ_MSG,
-			  "Control Send queue not initialized.\n");
+		ice_debug(hw, ICE_DBG_AQ_MSG, "Control Send queue not initialized.\n");
 		status = ICE_ERR_AQ_EMPTY;
 		goto sq_send_command_error;
 	}
@@ -938,8 +934,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 
 	if (buf) {
 		if (buf_size > cq->sq_buf_size) {
-			ice_debug(hw, ICE_DBG_AQ_MSG,
-				  "Invalid buffer size for Control Send queue: %d.\n",
+			ice_debug(hw, ICE_DBG_AQ_MSG, "Invalid buffer size for Control Send queue: %d.\n",
 				  buf_size);
 			status = ICE_ERR_INVAL_SIZE;
 			goto sq_send_command_error;
@@ -952,8 +947,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 
 	val = rd32(hw, cq->sq.head);
 	if (val >= cq->num_sq_entries) {
-		ice_debug(hw, ICE_DBG_AQ_MSG,
-			  "head overrun at %d in the Control Send Queue ring\n",
+		ice_debug(hw, ICE_DBG_AQ_MSG, "head overrun at %d in the Control Send Queue ring\n",
 			  val);
 		status = ICE_ERR_AQ_EMPTY;
 		goto sq_send_command_error;
@@ -971,8 +965,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	 * called in a separate thread in case of asynchronous completions.
 	 */
 	if (ice_clean_sq(hw, cq) == 0) {
-		ice_debug(hw, ICE_DBG_AQ_MSG,
-			  "Error: Control Send Queue is full.\n");
+		ice_debug(hw, ICE_DBG_AQ_MSG, "Error: Control Send Queue is full.\n");
 		status = ICE_ERR_AQ_FULL;
 		goto sq_send_command_error;
 	}
@@ -1000,8 +993,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	}
 
 	/* Debug desc and buffer */
-	ice_debug(hw, ICE_DBG_AQ_DESC,
-		  "ATQ: Control Send queue desc and buffer:\n");
+	ice_debug(hw, ICE_DBG_AQ_DESC, "ATQ: Control Send queue desc and buffer:\n");
 
 	ice_debug_cq(hw, (void *)desc_on_ring, buf, buf_size);
 
@@ -1026,8 +1018,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 			u16 copy_size = le16_to_cpu(desc->datalen);
 
 			if (copy_size > buf_size) {
-				ice_debug(hw, ICE_DBG_AQ_MSG,
-					  "Return len %d > than buf len %d\n",
+				ice_debug(hw, ICE_DBG_AQ_MSG, "Return len %d > than buf len %d\n",
 					  copy_size, buf_size);
 				status = ICE_ERR_AQ_ERROR;
 			} else {
@@ -1036,8 +1027,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		}
 		retval = le16_to_cpu(desc->retval);
 		if (retval) {
-			ice_debug(hw, ICE_DBG_AQ_MSG,
-				  "Control Send Queue command 0x%04X completed with error 0x%X\n",
+			ice_debug(hw, ICE_DBG_AQ_MSG, "Control Send Queue command 0x%04X completed with error 0x%X\n",
 				  le16_to_cpu(desc->opcode),
 				  retval);
 
@@ -1050,8 +1040,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		cq->sq_last_status = (enum ice_aq_err)retval;
 	}
 
-	ice_debug(hw, ICE_DBG_AQ_MSG,
-		  "ATQ: desc and buffer writeback:\n");
+	ice_debug(hw, ICE_DBG_AQ_MSG, "ATQ: desc and buffer writeback:\n");
 
 	ice_debug_cq(hw, (void *)desc, buf, buf_size);
 
@@ -1067,8 +1056,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 			ice_debug(hw, ICE_DBG_AQ_MSG, "Critical FW error.\n");
 			status = ICE_ERR_AQ_FW_CRITICAL;
 		} else {
-			ice_debug(hw, ICE_DBG_AQ_MSG,
-				  "Control Send Queue Writeback timeout.\n");
+			ice_debug(hw, ICE_DBG_AQ_MSG, "Control Send Queue Writeback timeout.\n");
 			status = ICE_ERR_AQ_TIMEOUT;
 		}
 	}
@@ -1124,8 +1112,7 @@ ice_clean_rq_elem(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	mutex_lock(&cq->rq_lock);
 
 	if (!cq->rq.count) {
-		ice_debug(hw, ICE_DBG_AQ_MSG,
-			  "Control Receive queue not initialized.\n");
+		ice_debug(hw, ICE_DBG_AQ_MSG, "Control Receive queue not initialized.\n");
 		ret_code = ICE_ERR_AQ_EMPTY;
 		goto clean_rq_elem_err;
 	}
@@ -1147,8 +1134,7 @@ ice_clean_rq_elem(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	flags = le16_to_cpu(desc->flags);
 	if (flags & ICE_AQ_FLAG_ERR) {
 		ret_code = ICE_ERR_AQ_ERROR;
-		ice_debug(hw, ICE_DBG_AQ_MSG,
-			  "Control Receive Queue Event 0x%04X received with error 0x%X\n",
+		ice_debug(hw, ICE_DBG_AQ_MSG, "Control Receive Queue Event 0x%04X received with error 0x%X\n",
 			  le16_to_cpu(desc->opcode),
 			  cq->rq_last_status);
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index da9797c11a8d..eb11df8deae8 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -709,8 +709,7 @@ ice_acquire_global_cfg_lock(struct ice_hw *hw,
 	if (!status)
 		mutex_lock(&ice_global_cfg_lock_sw);
 	else if (status == ICE_ERR_AQ_NO_WORK)
-		ice_debug(hw, ICE_DBG_PKG,
-			  "Global config lock: No work to do\n");
+		ice_debug(hw, ICE_DBG_PKG, "Global config lock: No work to do\n");
 
 	return status;
 }
@@ -909,8 +908,7 @@ ice_update_pkg(struct ice_hw *hw, struct ice_buf *bufs, u32 count)
 					   last, &offset, &info, NULL);
 
 		if (status) {
-			ice_debug(hw, ICE_DBG_PKG,
-				  "Update pkg failed: err %d off %d inf %d\n",
+			ice_debug(hw, ICE_DBG_PKG, "Update pkg failed: err %d off %d inf %d\n",
 				  status, offset, info);
 			break;
 		}
@@ -988,8 +986,7 @@ ice_dwnld_cfg_bufs(struct ice_hw *hw, struct ice_buf *bufs, u32 count)
 		/* Save AQ status from download package */
 		hw->pkg_dwnld_status = hw->adminq.sq_last_status;
 		if (status) {
-			ice_debug(hw, ICE_DBG_PKG,
-				  "Pkg download failed: err %d off %d inf %d\n",
+			ice_debug(hw, ICE_DBG_PKG, "Pkg download failed: err %d off %d inf %d\n",
 				  status, offset, info);
 
 			break;
@@ -1083,8 +1080,7 @@ ice_init_pkg_info(struct ice_hw *hw, struct ice_pkg_hdr *pkg_hdr)
 			  meta_seg->pkg_ver.update, meta_seg->pkg_ver.draft,
 			  meta_seg->pkg_name);
 	} else {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Did not find metadata segment in driver package\n");
+		ice_debug(hw, ICE_DBG_INIT, "Did not find metadata segment in driver package\n");
 		return ICE_ERR_CFG;
 	}
 
@@ -1101,8 +1097,7 @@ ice_init_pkg_info(struct ice_hw *hw, struct ice_pkg_hdr *pkg_hdr)
 			  seg_hdr->seg_format_ver.draft,
 			  seg_hdr->seg_id);
 	} else {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Did not find ice segment in driver package\n");
+		ice_debug(hw, ICE_DBG_INIT, "Did not find ice segment in driver package\n");
 		return ICE_ERR_CFG;
 	}
 
@@ -1318,8 +1313,7 @@ ice_chk_pkg_compat(struct ice_hw *hw, struct ice_pkg_hdr *ospkg,
 		    (*seg)->hdr.seg_format_ver.minor >
 			pkg->pkg_info[i].ver.minor) {
 			status = ICE_ERR_FW_DDP_MISMATCH;
-			ice_debug(hw, ICE_DBG_INIT,
-				  "OS package is not compatible with NVM.\n");
+			ice_debug(hw, ICE_DBG_INIT, "OS package is not compatible with NVM.\n");
 		}
 		/* done processing NVM package so break */
 		break;
@@ -1387,8 +1381,7 @@ enum ice_status ice_init_pkg(struct ice_hw *hw, u8 *buf, u32 len)
 	ice_init_pkg_hints(hw, seg);
 	status = ice_download_pkg(hw, seg);
 	if (status == ICE_ERR_AQ_NO_WORK) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "package previously loaded - no work.\n");
+		ice_debug(hw, ICE_DBG_INIT, "package previously loaded - no work.\n");
 		status = 0;
 	}
 
@@ -3267,8 +3260,7 @@ ice_has_prof_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl)
 		if (ent->profile_cookie == hdl)
 			return true;
 
-	ice_debug(hw, ICE_DBG_INIT,
-		  "Characteristic list for VSI group %d not found.\n",
+	ice_debug(hw, ICE_DBG_INIT, "Characteristic list for VSI group %d not found.\n",
 		  vsig);
 	return false;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index bff0ca02f8c6..a4c4857b933e 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -1080,8 +1080,7 @@ ice_flow_add_prof_sync(struct ice_hw *hw, enum ice_block blk,
 
 	status = ice_flow_proc_segs(hw, params);
 	if (status) {
-		ice_debug(hw, ICE_DBG_FLOW,
-			  "Error processing a flow's packet segments\n");
+		ice_debug(hw, ICE_DBG_FLOW, "Error processing a flow's packet segments\n");
 		goto out;
 	}
 
@@ -1291,8 +1290,7 @@ ice_flow_assoc_prof(struct ice_hw *hw, enum ice_block blk,
 		if (!status)
 			set_bit(vsi_handle, prof->vsis);
 		else
-			ice_debug(hw, ICE_DBG_FLOW,
-				  "HW profile add failed, %d\n",
+			ice_debug(hw, ICE_DBG_FLOW, "HW profile add failed, %d\n",
 				  status);
 	}
 
@@ -1323,8 +1321,7 @@ ice_flow_disassoc_prof(struct ice_hw *hw, enum ice_block blk,
 		if (!status)
 			clear_bit(vsi_handle, prof->vsis);
 		else
-			ice_debug(hw, ICE_DBG_FLOW,
-				  "HW profile remove failed, %d\n",
+			ice_debug(hw, ICE_DBG_FLOW, "HW profile remove failed, %d\n",
 				  status);
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 0d1092cbc927..f729cd0c6224 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -73,8 +73,7 @@ ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
 
 	/* Verify the length of the read if this is for the Shadow RAM */
 	if (read_shadow_ram && ((offset + inlen) > (hw->nvm.sr_words * 2u))) {
-		ice_debug(hw, ICE_DBG_NVM,
-			  "NVM error: requested offset is beyond Shadow RAM limit\n");
+		ice_debug(hw, ICE_DBG_NVM, "NVM error: requested offset is beyond Shadow RAM limit\n");
 		return ICE_ERR_PARAM;
 	}
 
@@ -397,8 +396,7 @@ static enum ice_status ice_get_orom_ver_info(struct ice_hw *hw)
 	status = ice_get_pfa_module_tlv(hw, &boot_cfg_tlv, &boot_cfg_tlv_len,
 					ICE_SR_BOOT_CFG_PTR);
 	if (status) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Failed to read Boot Configuration Block TLV.\n");
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read Boot Configuration Block TLV.\n");
 		return status;
 	}
 
@@ -406,8 +404,7 @@ static enum ice_status ice_get_orom_ver_info(struct ice_hw *hw)
 	 * (Combo Image Version High and Combo Image Version Low)
 	 */
 	if (boot_cfg_tlv_len < 2) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Invalid Boot Configuration Block TLV size.\n");
+		ice_debug(hw, ICE_DBG_INIT, "Invalid Boot Configuration Block TLV size.\n");
 		return ICE_ERR_INVAL_SIZE;
 	}
 
@@ -542,14 +539,12 @@ static enum ice_status ice_discover_flash_size(struct ice_hw *hw)
 		status = ice_read_flat_nvm(hw, offset, &len, &data, false);
 		if (status == ICE_ERR_AQ_ERROR &&
 		    hw->adminq.sq_last_status == ICE_AQ_RC_EINVAL) {
-			ice_debug(hw, ICE_DBG_NVM,
-				  "%s: New upper bound of %u bytes\n",
+			ice_debug(hw, ICE_DBG_NVM, "%s: New upper bound of %u bytes\n",
 				  __func__, offset);
 			status = 0;
 			max_size = offset;
 		} else if (!status) {
-			ice_debug(hw, ICE_DBG_NVM,
-				  "%s: New lower bound of %u bytes\n",
+			ice_debug(hw, ICE_DBG_NVM, "%s: New lower bound of %u bytes\n",
 				  __func__, offset);
 			min_size = offset;
 		} else {
@@ -558,8 +553,7 @@ static enum ice_status ice_discover_flash_size(struct ice_hw *hw)
 		}
 	}
 
-	ice_debug(hw, ICE_DBG_NVM,
-		  "Predicted flash size is %u bytes\n", max_size);
+	ice_debug(hw, ICE_DBG_NVM, "Predicted flash size is %u bytes\n", max_size);
 
 	hw->nvm.flash_size = max_size;
 
@@ -600,15 +594,13 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 	} else {
 		/* Blank programming mode */
 		nvm->blank_nvm_mode = true;
-		ice_debug(hw, ICE_DBG_NVM,
-			  "NVM init error: unsupported blank mode.\n");
+		ice_debug(hw, ICE_DBG_NVM, "NVM init error: unsupported blank mode.\n");
 		return ICE_ERR_NVM_BLANK_MODE;
 	}
 
 	status = ice_read_sr_word(hw, ICE_SR_NVM_DEV_STARTER_VER, &ver);
 	if (status) {
-		ice_debug(hw, ICE_DBG_INIT,
-			  "Failed to read DEV starter version.\n");
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read DEV starter version.\n");
 		return status;
 	}
 	nvm->major_ver = (ver & ICE_NVM_VER_HI_MASK) >> ICE_NVM_VER_HI_SHIFT;
@@ -629,8 +621,7 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 
 	status = ice_discover_flash_size(hw);
 	if (status) {
-		ice_debug(hw, ICE_DBG_NVM,
-			  "NVM init error: failed to discover flash size.\n");
+		ice_debug(hw, ICE_DBG_NVM, "NVM init error: failed to discover flash size.\n");
 		return status;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 44a228530253..f0912e44d4ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -164,8 +164,7 @@ ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 	parent = ice_sched_find_node_by_teid(pi->root,
 					     le32_to_cpu(info->parent_teid));
 	if (!parent) {
-		ice_debug(hw, ICE_DBG_SCHED,
-			  "Parent Node not found for parent_teid=0x%x\n",
+		ice_debug(hw, ICE_DBG_SCHED, "Parent Node not found for parent_teid=0x%x\n",
 			  le32_to_cpu(info->parent_teid));
 		return ICE_ERR_PARAM;
 	}
@@ -704,8 +703,7 @@ static void ice_sched_clear_rl_prof(struct ice_port_info *pi)
 			rl_prof_elem->prof_id_ref = 0;
 			status = ice_sched_del_rl_profile(hw, rl_prof_elem);
 			if (status) {
-				ice_debug(hw, ICE_DBG_SCHED,
-					  "Remove rl profile failed\n");
+				ice_debug(hw, ICE_DBG_SCHED, "Remove rl profile failed\n");
 				/* On error, free mem required */
 				list_del(&rl_prof_elem->list_entry);
 				devm_kfree(ice_hw_to_dev(hw), rl_prof_elem);
@@ -863,8 +861,7 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 	for (i = 0; i < num_nodes; i++) {
 		status = ice_sched_add_node(pi, layer, &buf->generic[i]);
 		if (status) {
-			ice_debug(hw, ICE_DBG_SCHED,
-				  "add nodes in SW DB failed status =%d\n",
+			ice_debug(hw, ICE_DBG_SCHED, "add nodes in SW DB failed status =%d\n",
 				  status);
 			break;
 		}
@@ -872,8 +869,7 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 		teid = le32_to_cpu(buf->generic[i].node_teid);
 		new_node = ice_sched_find_node_by_teid(parent, teid);
 		if (!new_node) {
-			ice_debug(hw, ICE_DBG_SCHED,
-				  "Node is missing for teid =%d\n", teid);
+			ice_debug(hw, ICE_DBG_SCHED, "Node is missing for teid =%d\n", teid);
 			break;
 		}
 
@@ -1830,8 +1826,7 @@ ice_sched_rm_vsi_cfg(struct ice_port_info *pi, u16 vsi_handle, u8 owner)
 			continue;
 
 		if (ice_sched_is_leaf_node_present(vsi_node)) {
-			ice_debug(pi->hw, ICE_DBG_SCHED,
-				  "VSI has leaf nodes in TC %d\n", i);
+			ice_debug(pi->hw, ICE_DBG_SCHED, "VSI has leaf nodes in TC %d\n", i);
 			status = ICE_ERR_IN_USE;
 			goto exit_sched_rm_vsi_cfg;
 		}
@@ -1896,8 +1891,7 @@ static void ice_sched_rm_unused_rl_prof(struct ice_port_info *pi)
 		list_for_each_entry_safe(rl_prof_elem, rl_prof_tmp,
 					 &pi->rl_prof_list[ln], list_entry) {
 			if (!ice_sched_del_rl_profile(pi->hw, rl_prof_elem))
-				ice_debug(pi->hw, ICE_DBG_SCHED,
-					  "Removed rl profile\n");
+				ice_debug(pi->hw, ICE_DBG_SCHED, "Removed rl profile\n");
 		}
 	}
 }
@@ -2441,8 +2435,7 @@ ice_sched_rm_rl_profile(struct ice_port_info *pi, u8 layer_num, u8 profile_type,
 			/* Remove old profile ID from database */
 			status = ice_sched_del_rl_profile(pi->hw, rl_prof_elem);
 			if (status && status != ICE_ERR_IN_USE)
-				ice_debug(pi->hw, ICE_DBG_SCHED,
-					  "Remove rl profile failed\n");
+				ice_debug(pi->hw, ICE_DBG_SCHED, "Remove rl profile failed\n");
 			break;
 		}
 	if (status == ICE_ERR_IN_USE)
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index c3a6c41385ee..c33612132ddf 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -537,8 +537,7 @@ ice_init_port_info(struct ice_port_info *pi, u16 vsi_port_num, u8 type,
 		pi->dflt_rx_vsi_num = ICE_DFLT_VSI_INVAL;
 		break;
 	default:
-		ice_debug(pi->hw, ICE_DBG_SW,
-			  "incorrect VSI/port type received\n");
+		ice_debug(pi->hw, ICE_DBG_SW, "incorrect VSI/port type received\n");
 		break;
 	}
 }
@@ -1476,8 +1475,7 @@ ice_rem_update_vsi_list(struct ice_hw *hw, u16 vsi_handle,
 		tmp_fltr_info.vsi_handle = rem_vsi_handle;
 		status = ice_update_pkt_fwd_rule(hw, &tmp_fltr_info);
 		if (status) {
-			ice_debug(hw, ICE_DBG_SW,
-				  "Failed to update pkt fwd rule to FWD_TO_VSI on HW VSI %d, error %d\n",
+			ice_debug(hw, ICE_DBG_SW, "Failed to update pkt fwd rule to FWD_TO_VSI on HW VSI %d, error %d\n",
 				  tmp_fltr_info.fwd_id.hw_vsi_id, status);
 			return status;
 		}
@@ -1493,8 +1491,7 @@ ice_rem_update_vsi_list(struct ice_hw *hw, u16 vsi_handle,
 		/* Remove the VSI list since it is no longer used */
 		status = ice_remove_vsi_list_rule(hw, vsi_list_id, lkup_type);
 		if (status) {
-			ice_debug(hw, ICE_DBG_SW,
-				  "Failed to remove VSI list %d, error %d\n",
+			ice_debug(hw, ICE_DBG_SW, "Failed to remove VSI list %d, error %d\n",
 				  vsi_list_id, status);
 			return status;
 		}
@@ -1853,8 +1850,7 @@ ice_add_vlan_internal(struct ice_hw *hw, struct ice_fltr_list_entry *f_entry)
 		 */
 		if (v_list_itr->vsi_count > 1 &&
 		    v_list_itr->vsi_list_info->ref_cnt > 1) {
-			ice_debug(hw, ICE_DBG_SW,
-				  "Invalid configuration: Optimization to reuse VSI list with more than one VSI is not being done yet\n");
+			ice_debug(hw, ICE_DBG_SW, "Invalid configuration: Optimization to reuse VSI list with more than one VSI is not being done yet\n");
 			status = ICE_ERR_CFG;
 			goto exit;
 		}
@@ -2740,8 +2736,7 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
 	status = ice_aq_alloc_free_res(hw, 1, buf, buf_len,
 				       ice_aqc_opc_free_res, NULL);
 	if (status)
-		ice_debug(hw, ICE_DBG_SW,
-			  "counter resource could not be freed\n");
+		ice_debug(hw, ICE_DBG_SW, "counter resource could not be freed\n");
 
 	kfree(buf);
 	return status;
-- 
2.26.2

