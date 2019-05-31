Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAED309EF
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfEaIPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:15:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:64473 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726941AbfEaIPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:15:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:15:12 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2019 01:15:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/13] iavf: rename iavf_status structure flags
Date:   Fri, 31 May 2019 01:15:14 -0700
Message-Id: <20190531081518.16430-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
References: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

rename the flags inside of iavf_status from I40E_*
to IAVF_*

Signed-off-by: Alice Michael <alice.michael@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_adminq.c |  42 +--
 drivers/net/ethernet/intel/iavf/iavf_adminq.h |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_client.c |   6 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c | 266 +++++++++---------
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  38 +--
 drivers/net/ethernet/intel/iavf/iavf_status.h | 134 ++++-----
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |   2 +-
 7 files changed, 245 insertions(+), 245 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.c b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
index 56172e2974bb..a764eb9838d1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
@@ -271,7 +271,7 @@ static enum iavf_status i40e_config_asq_regs(struct iavf_hw *hw)
 	/* Check one register to verify that config was applied */
 	reg = rd32(hw, hw->aq.asq.bal);
 	if (reg != lower_32_bits(hw->aq.asq.desc_buf.pa))
-		ret_code = I40E_ERR_ADMIN_QUEUE_ERROR;
+		ret_code = IAVF_ERR_ADMIN_QUEUE_ERROR;
 
 	return ret_code;
 }
@@ -303,7 +303,7 @@ static enum iavf_status i40e_config_arq_regs(struct iavf_hw *hw)
 	/* Check one register to verify that config was applied */
 	reg = rd32(hw, hw->aq.arq.bal);
 	if (reg != lower_32_bits(hw->aq.arq.desc_buf.pa))
-		ret_code = I40E_ERR_ADMIN_QUEUE_ERROR;
+		ret_code = IAVF_ERR_ADMIN_QUEUE_ERROR;
 
 	return ret_code;
 }
@@ -327,14 +327,14 @@ static enum iavf_status i40e_init_asq(struct iavf_hw *hw)
 
 	if (hw->aq.asq.count > 0) {
 		/* queue already initialized */
-		ret_code = I40E_ERR_NOT_READY;
+		ret_code = IAVF_ERR_NOT_READY;
 		goto init_adminq_exit;
 	}
 
 	/* verify input for valid configuration */
 	if ((hw->aq.num_asq_entries == 0) ||
 	    (hw->aq.asq_buf_size == 0)) {
-		ret_code = I40E_ERR_CONFIG;
+		ret_code = IAVF_ERR_CONFIG;
 		goto init_adminq_exit;
 	}
 
@@ -386,14 +386,14 @@ static enum iavf_status i40e_init_arq(struct iavf_hw *hw)
 
 	if (hw->aq.arq.count > 0) {
 		/* queue already initialized */
-		ret_code = I40E_ERR_NOT_READY;
+		ret_code = IAVF_ERR_NOT_READY;
 		goto init_adminq_exit;
 	}
 
 	/* verify input for valid configuration */
 	if ((hw->aq.num_arq_entries == 0) ||
 	    (hw->aq.arq_buf_size == 0)) {
-		ret_code = I40E_ERR_CONFIG;
+		ret_code = IAVF_ERR_CONFIG;
 		goto init_adminq_exit;
 	}
 
@@ -439,7 +439,7 @@ static enum iavf_status i40e_shutdown_asq(struct iavf_hw *hw)
 	mutex_lock(&hw->aq.asq_mutex);
 
 	if (hw->aq.asq.count == 0) {
-		ret_code = I40E_ERR_NOT_READY;
+		ret_code = IAVF_ERR_NOT_READY;
 		goto shutdown_asq_out;
 	}
 
@@ -473,7 +473,7 @@ static enum iavf_status i40e_shutdown_arq(struct iavf_hw *hw)
 	mutex_lock(&hw->aq.arq_mutex);
 
 	if (hw->aq.arq.count == 0) {
-		ret_code = I40E_ERR_NOT_READY;
+		ret_code = IAVF_ERR_NOT_READY;
 		goto shutdown_arq_out;
 	}
 
@@ -514,7 +514,7 @@ enum iavf_status iavf_init_adminq(struct iavf_hw *hw)
 	    (hw->aq.num_asq_entries == 0) ||
 	    (hw->aq.arq_buf_size == 0) ||
 	    (hw->aq.asq_buf_size == 0)) {
-		ret_code = I40E_ERR_CONFIG;
+		ret_code = IAVF_ERR_CONFIG;
 		goto init_adminq_exit;
 	}
 
@@ -648,7 +648,7 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 	if (hw->aq.asq.count == 0) {
 		iavf_debug(hw, IAVF_DEBUG_AQ_MESSAGE,
 			   "AQTX: Admin queue not initialized.\n");
-		status = I40E_ERR_QUEUE_EMPTY;
+		status = IAVF_ERR_QUEUE_EMPTY;
 		goto asq_send_command_error;
 	}
 
@@ -658,7 +658,7 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 	if (val >= hw->aq.num_asq_entries) {
 		iavf_debug(hw, IAVF_DEBUG_AQ_MESSAGE,
 			   "AQTX: head overrun at %d\n", val);
-		status = I40E_ERR_QUEUE_EMPTY;
+		status = IAVF_ERR_QUEUE_EMPTY;
 		goto asq_send_command_error;
 	}
 
@@ -689,7 +689,7 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 			   IAVF_DEBUG_AQ_MESSAGE,
 			   "AQTX: Invalid buffer size: %d.\n",
 			   buff_size);
-		status = I40E_ERR_INVALID_SIZE;
+		status = IAVF_ERR_INVALID_SIZE;
 		goto asq_send_command_error;
 	}
 
@@ -697,7 +697,7 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 		iavf_debug(hw,
 			   IAVF_DEBUG_AQ_MESSAGE,
 			   "AQTX: Async flag not set along with postpone flag");
-		status = I40E_ERR_PARAM;
+		status = IAVF_ERR_PARAM;
 		goto asq_send_command_error;
 	}
 
@@ -712,7 +712,7 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 		iavf_debug(hw,
 			   IAVF_DEBUG_AQ_MESSAGE,
 			   "AQTX: Error queue is full.\n");
-		status = I40E_ERR_ADMIN_QUEUE_FULL;
+		status = IAVF_ERR_ADMIN_QUEUE_FULL;
 		goto asq_send_command_error;
 	}
 
@@ -784,9 +784,9 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 		if ((enum iavf_admin_queue_err)retval == IAVF_AQ_RC_OK)
 			status = 0;
 		else if ((enum iavf_admin_queue_err)retval == IAVF_AQ_RC_EBUSY)
-			status = I40E_ERR_NOT_READY;
+			status = IAVF_ERR_NOT_READY;
 		else
-			status = I40E_ERR_ADMIN_QUEUE_ERROR;
+			status = IAVF_ERR_ADMIN_QUEUE_ERROR;
 		hw->aq.asq_last_status = (enum iavf_admin_queue_err)retval;
 	}
 
@@ -804,11 +804,11 @@ enum iavf_status iavf_asq_send_command(struct iavf_hw *hw,
 		if (rd32(hw, hw->aq.asq.len) & IAVF_VF_ATQLEN1_ATQCRIT_MASK) {
 			iavf_debug(hw, IAVF_DEBUG_AQ_MESSAGE,
 				   "AQTX: AQ Critical error.\n");
-			status = I40E_ERR_ADMIN_QUEUE_CRITICAL_ERROR;
+			status = IAVF_ERR_ADMIN_QUEUE_CRITICAL_ERROR;
 		} else {
 			iavf_debug(hw, IAVF_DEBUG_AQ_MESSAGE,
 				   "AQTX: Writeback timeout.\n");
-			status = I40E_ERR_ADMIN_QUEUE_TIMEOUT;
+			status = IAVF_ERR_ADMIN_QUEUE_TIMEOUT;
 		}
 	}
 
@@ -864,7 +864,7 @@ enum iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
 	if (hw->aq.arq.count == 0) {
 		iavf_debug(hw, IAVF_DEBUG_AQ_MESSAGE,
 			   "AQRX: Admin queue not initialized.\n");
-		ret_code = I40E_ERR_QUEUE_EMPTY;
+		ret_code = IAVF_ERR_QUEUE_EMPTY;
 		goto clean_arq_element_err;
 	}
 
@@ -872,7 +872,7 @@ enum iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
 	ntu = rd32(hw, hw->aq.arq.head) & IAVF_VF_ARQH1_ARQH_MASK;
 	if (ntu == ntc) {
 		/* nothing to do - shouldn't need to update ring's values */
-		ret_code = I40E_ERR_ADMIN_QUEUE_NO_WORK;
+		ret_code = IAVF_ERR_ADMIN_QUEUE_NO_WORK;
 		goto clean_arq_element_out;
 	}
 
@@ -884,7 +884,7 @@ enum iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
 		(enum iavf_admin_queue_err)le16_to_cpu(desc->retval);
 	flags = le16_to_cpu(desc->flags);
 	if (flags & IAVF_AQ_FLAG_ERR) {
-		ret_code = I40E_ERR_ADMIN_QUEUE_ERROR;
+		ret_code = IAVF_ERR_ADMIN_QUEUE_ERROR;
 		iavf_debug(hw,
 			   IAVF_DEBUG_AQ_MESSAGE,
 			   "AQRX: Event received with error 0x%X.\n",
diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.h b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
index 60a6a41d21a0..300320e034d2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
@@ -117,7 +117,7 @@ static inline int i40e_aq_rc_to_posix(int aq_ret, int aq_rc)
 	};
 
 	/* aq_rc is invalid if AQ timed out */
-	if (aq_ret == I40E_ERR_ADMIN_QUEUE_TIMEOUT)
+	if (aq_ret == IAVF_ERR_ADMIN_QUEUE_TIMEOUT)
 		return -EAGAIN;
 
 	if (!((u32)aq_rc < (sizeof(aq_to_posix) / sizeof((aq_to_posix)[0]))))
diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.c b/drivers/net/ethernet/intel/iavf/iavf_client.c
index 3cdcaac75b70..196ce7324ea4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_client.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_client.c
@@ -142,7 +142,7 @@ static int iavf_client_release_qvlist(struct i40e_info *ldev)
 
 	err = iavf_aq_send_msg_to_pf(&adapter->hw,
 				     VIRTCHNL_OP_RELEASE_IWARP_IRQ_MAP,
-				     I40E_SUCCESS, NULL, 0, NULL);
+				     IAVF_SUCCESS, NULL, 0, NULL);
 
 	if (err)
 		dev_err(&adapter->pdev->dev,
@@ -426,7 +426,7 @@ static u32 iavf_client_virtchnl_send(struct i40e_info *ldev,
 		return -EAGAIN;
 
 	err = iavf_aq_send_msg_to_pf(&adapter->hw, VIRTCHNL_OP_IWARP,
-				     I40E_SUCCESS, msg, len, NULL);
+				     IAVF_SUCCESS, msg, len, NULL);
 	if (err)
 		dev_err(&adapter->pdev->dev, "Unable to send iWarp message to PF, error %d, aq status %d\n",
 			err, adapter->hw.aq.asq_last_status);
@@ -474,7 +474,7 @@ static int iavf_client_setup_qvlist(struct i40e_info *ldev,
 
 	adapter->client_pending |= BIT(VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP);
 	err = iavf_aq_send_msg_to_pf(&adapter->hw,
-				VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP, I40E_SUCCESS,
+				VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP, IAVF_SUCCESS,
 				(u8 *)v_qvlist_info, msg_size, NULL);
 
 	if (err) {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index 137e06c0c4ee..05ae5ce06537 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -32,7 +32,7 @@ enum iavf_status iavf_set_mac_type(struct iavf_hw *hw)
 			break;
 		}
 	} else {
-		status = I40E_ERR_DEVICE_NOT_SUPPORTED;
+		status = IAVF_ERR_DEVICE_NOT_SUPPORTED;
 	}
 
 	hw_dbg(hw, "found mac: %d, returns: %d\n", hw->mac.type, status);
@@ -109,138 +109,138 @@ const char *iavf_stat_str(struct iavf_hw *hw, enum iavf_status stat_err)
 	switch (stat_err) {
 	case 0:
 		return "OK";
-	case I40E_ERR_NVM:
-		return "I40E_ERR_NVM";
-	case I40E_ERR_NVM_CHECKSUM:
-		return "I40E_ERR_NVM_CHECKSUM";
-	case I40E_ERR_PHY:
-		return "I40E_ERR_PHY";
-	case I40E_ERR_CONFIG:
-		return "I40E_ERR_CONFIG";
-	case I40E_ERR_PARAM:
-		return "I40E_ERR_PARAM";
-	case I40E_ERR_MAC_TYPE:
-		return "I40E_ERR_MAC_TYPE";
-	case I40E_ERR_UNKNOWN_PHY:
-		return "I40E_ERR_UNKNOWN_PHY";
-	case I40E_ERR_LINK_SETUP:
-		return "I40E_ERR_LINK_SETUP";
-	case I40E_ERR_ADAPTER_STOPPED:
-		return "I40E_ERR_ADAPTER_STOPPED";
-	case I40E_ERR_INVALID_MAC_ADDR:
-		return "I40E_ERR_INVALID_MAC_ADDR";
-	case I40E_ERR_DEVICE_NOT_SUPPORTED:
-		return "I40E_ERR_DEVICE_NOT_SUPPORTED";
-	case I40E_ERR_MASTER_REQUESTS_PENDING:
-		return "I40E_ERR_MASTER_REQUESTS_PENDING";
-	case I40E_ERR_INVALID_LINK_SETTINGS:
-		return "I40E_ERR_INVALID_LINK_SETTINGS";
-	case I40E_ERR_AUTONEG_NOT_COMPLETE:
-		return "I40E_ERR_AUTONEG_NOT_COMPLETE";
-	case I40E_ERR_RESET_FAILED:
-		return "I40E_ERR_RESET_FAILED";
-	case I40E_ERR_SWFW_SYNC:
-		return "I40E_ERR_SWFW_SYNC";
-	case I40E_ERR_NO_AVAILABLE_VSI:
-		return "I40E_ERR_NO_AVAILABLE_VSI";
-	case I40E_ERR_NO_MEMORY:
-		return "I40E_ERR_NO_MEMORY";
-	case I40E_ERR_BAD_PTR:
-		return "I40E_ERR_BAD_PTR";
-	case I40E_ERR_RING_FULL:
-		return "I40E_ERR_RING_FULL";
-	case I40E_ERR_INVALID_PD_ID:
-		return "I40E_ERR_INVALID_PD_ID";
-	case I40E_ERR_INVALID_QP_ID:
-		return "I40E_ERR_INVALID_QP_ID";
-	case I40E_ERR_INVALID_CQ_ID:
-		return "I40E_ERR_INVALID_CQ_ID";
-	case I40E_ERR_INVALID_CEQ_ID:
-		return "I40E_ERR_INVALID_CEQ_ID";
-	case I40E_ERR_INVALID_AEQ_ID:
-		return "I40E_ERR_INVALID_AEQ_ID";
-	case I40E_ERR_INVALID_SIZE:
-		return "I40E_ERR_INVALID_SIZE";
-	case I40E_ERR_INVALID_ARP_INDEX:
-		return "I40E_ERR_INVALID_ARP_INDEX";
-	case I40E_ERR_INVALID_FPM_FUNC_ID:
-		return "I40E_ERR_INVALID_FPM_FUNC_ID";
-	case I40E_ERR_QP_INVALID_MSG_SIZE:
-		return "I40E_ERR_QP_INVALID_MSG_SIZE";
-	case I40E_ERR_QP_TOOMANY_WRS_POSTED:
-		return "I40E_ERR_QP_TOOMANY_WRS_POSTED";
-	case I40E_ERR_INVALID_FRAG_COUNT:
-		return "I40E_ERR_INVALID_FRAG_COUNT";
-	case I40E_ERR_QUEUE_EMPTY:
-		return "I40E_ERR_QUEUE_EMPTY";
-	case I40E_ERR_INVALID_ALIGNMENT:
-		return "I40E_ERR_INVALID_ALIGNMENT";
-	case I40E_ERR_FLUSHED_QUEUE:
-		return "I40E_ERR_FLUSHED_QUEUE";
-	case I40E_ERR_INVALID_PUSH_PAGE_INDEX:
-		return "I40E_ERR_INVALID_PUSH_PAGE_INDEX";
-	case I40E_ERR_INVALID_IMM_DATA_SIZE:
-		return "I40E_ERR_INVALID_IMM_DATA_SIZE";
-	case I40E_ERR_TIMEOUT:
-		return "I40E_ERR_TIMEOUT";
-	case I40E_ERR_OPCODE_MISMATCH:
-		return "I40E_ERR_OPCODE_MISMATCH";
-	case I40E_ERR_CQP_COMPL_ERROR:
-		return "I40E_ERR_CQP_COMPL_ERROR";
-	case I40E_ERR_INVALID_VF_ID:
-		return "I40E_ERR_INVALID_VF_ID";
-	case I40E_ERR_INVALID_HMCFN_ID:
-		return "I40E_ERR_INVALID_HMCFN_ID";
-	case I40E_ERR_BACKING_PAGE_ERROR:
-		return "I40E_ERR_BACKING_PAGE_ERROR";
-	case I40E_ERR_NO_PBLCHUNKS_AVAILABLE:
-		return "I40E_ERR_NO_PBLCHUNKS_AVAILABLE";
-	case I40E_ERR_INVALID_PBLE_INDEX:
-		return "I40E_ERR_INVALID_PBLE_INDEX";
-	case I40E_ERR_INVALID_SD_INDEX:
-		return "I40E_ERR_INVALID_SD_INDEX";
-	case I40E_ERR_INVALID_PAGE_DESC_INDEX:
-		return "I40E_ERR_INVALID_PAGE_DESC_INDEX";
-	case I40E_ERR_INVALID_SD_TYPE:
-		return "I40E_ERR_INVALID_SD_TYPE";
-	case I40E_ERR_MEMCPY_FAILED:
-		return "I40E_ERR_MEMCPY_FAILED";
-	case I40E_ERR_INVALID_HMC_OBJ_INDEX:
-		return "I40E_ERR_INVALID_HMC_OBJ_INDEX";
-	case I40E_ERR_INVALID_HMC_OBJ_COUNT:
-		return "I40E_ERR_INVALID_HMC_OBJ_COUNT";
-	case I40E_ERR_INVALID_SRQ_ARM_LIMIT:
-		return "I40E_ERR_INVALID_SRQ_ARM_LIMIT";
-	case I40E_ERR_SRQ_ENABLED:
-		return "I40E_ERR_SRQ_ENABLED";
-	case I40E_ERR_ADMIN_QUEUE_ERROR:
-		return "I40E_ERR_ADMIN_QUEUE_ERROR";
-	case I40E_ERR_ADMIN_QUEUE_TIMEOUT:
-		return "I40E_ERR_ADMIN_QUEUE_TIMEOUT";
-	case I40E_ERR_BUF_TOO_SHORT:
-		return "I40E_ERR_BUF_TOO_SHORT";
-	case I40E_ERR_ADMIN_QUEUE_FULL:
-		return "I40E_ERR_ADMIN_QUEUE_FULL";
-	case I40E_ERR_ADMIN_QUEUE_NO_WORK:
-		return "I40E_ERR_ADMIN_QUEUE_NO_WORK";
-	case I40E_ERR_BAD_IWARP_CQE:
-		return "I40E_ERR_BAD_IWARP_CQE";
-	case I40E_ERR_NVM_BLANK_MODE:
-		return "I40E_ERR_NVM_BLANK_MODE";
-	case I40E_ERR_NOT_IMPLEMENTED:
-		return "I40E_ERR_NOT_IMPLEMENTED";
-	case I40E_ERR_PE_DOORBELL_NOT_ENABLED:
-		return "I40E_ERR_PE_DOORBELL_NOT_ENABLED";
-	case I40E_ERR_DIAG_TEST_FAILED:
-		return "I40E_ERR_DIAG_TEST_FAILED";
-	case I40E_ERR_NOT_READY:
-		return "I40E_ERR_NOT_READY";
-	case I40E_NOT_SUPPORTED:
-		return "I40E_NOT_SUPPORTED";
-	case I40E_ERR_FIRMWARE_API_VERSION:
-		return "I40E_ERR_FIRMWARE_API_VERSION";
-	case I40E_ERR_ADMIN_QUEUE_CRITICAL_ERROR:
-		return "I40E_ERR_ADMIN_QUEUE_CRITICAL_ERROR";
+	case IAVF_ERR_NVM:
+		return "IAVF_ERR_NVM";
+	case IAVF_ERR_NVM_CHECKSUM:
+		return "IAVF_ERR_NVM_CHECKSUM";
+	case IAVF_ERR_PHY:
+		return "IAVF_ERR_PHY";
+	case IAVF_ERR_CONFIG:
+		return "IAVF_ERR_CONFIG";
+	case IAVF_ERR_PARAM:
+		return "IAVF_ERR_PARAM";
+	case IAVF_ERR_MAC_TYPE:
+		return "IAVF_ERR_MAC_TYPE";
+	case IAVF_ERR_UNKNOWN_PHY:
+		return "IAVF_ERR_UNKNOWN_PHY";
+	case IAVF_ERR_LINK_SETUP:
+		return "IAVF_ERR_LINK_SETUP";
+	case IAVF_ERR_ADAPTER_STOPPED:
+		return "IAVF_ERR_ADAPTER_STOPPED";
+	case IAVF_ERR_INVALID_MAC_ADDR:
+		return "IAVF_ERR_INVALID_MAC_ADDR";
+	case IAVF_ERR_DEVICE_NOT_SUPPORTED:
+		return "IAVF_ERR_DEVICE_NOT_SUPPORTED";
+	case IAVF_ERR_MASTER_REQUESTS_PENDING:
+		return "IAVF_ERR_MASTER_REQUESTS_PENDING";
+	case IAVF_ERR_INVALID_LINK_SETTINGS:
+		return "IAVF_ERR_INVALID_LINK_SETTINGS";
+	case IAVF_ERR_AUTONEG_NOT_COMPLETE:
+		return "IAVF_ERR_AUTONEG_NOT_COMPLETE";
+	case IAVF_ERR_RESET_FAILED:
+		return "IAVF_ERR_RESET_FAILED";
+	case IAVF_ERR_SWFW_SYNC:
+		return "IAVF_ERR_SWFW_SYNC";
+	case IAVF_ERR_NO_AVAILABLE_VSI:
+		return "IAVF_ERR_NO_AVAILABLE_VSI";
+	case IAVF_ERR_NO_MEMORY:
+		return "IAVF_ERR_NO_MEMORY";
+	case IAVF_ERR_BAD_PTR:
+		return "IAVF_ERR_BAD_PTR";
+	case IAVF_ERR_RING_FULL:
+		return "IAVF_ERR_RING_FULL";
+	case IAVF_ERR_INVALID_PD_ID:
+		return "IAVF_ERR_INVALID_PD_ID";
+	case IAVF_ERR_INVALID_QP_ID:
+		return "IAVF_ERR_INVALID_QP_ID";
+	case IAVF_ERR_INVALID_CQ_ID:
+		return "IAVF_ERR_INVALID_CQ_ID";
+	case IAVF_ERR_INVALID_CEQ_ID:
+		return "IAVF_ERR_INVALID_CEQ_ID";
+	case IAVF_ERR_INVALID_AEQ_ID:
+		return "IAVF_ERR_INVALID_AEQ_ID";
+	case IAVF_ERR_INVALID_SIZE:
+		return "IAVF_ERR_INVALID_SIZE";
+	case IAVF_ERR_INVALID_ARP_INDEX:
+		return "IAVF_ERR_INVALID_ARP_INDEX";
+	case IAVF_ERR_INVALID_FPM_FUNC_ID:
+		return "IAVF_ERR_INVALID_FPM_FUNC_ID";
+	case IAVF_ERR_QP_INVALID_MSG_SIZE:
+		return "IAVF_ERR_QP_INVALID_MSG_SIZE";
+	case IAVF_ERR_QP_TOOMANY_WRS_POSTED:
+		return "IAVF_ERR_QP_TOOMANY_WRS_POSTED";
+	case IAVF_ERR_INVALID_FRAG_COUNT:
+		return "IAVF_ERR_INVALID_FRAG_COUNT";
+	case IAVF_ERR_QUEUE_EMPTY:
+		return "IAVF_ERR_QUEUE_EMPTY";
+	case IAVF_ERR_INVALID_ALIGNMENT:
+		return "IAVF_ERR_INVALID_ALIGNMENT";
+	case IAVF_ERR_FLUSHED_QUEUE:
+		return "IAVF_ERR_FLUSHED_QUEUE";
+	case IAVF_ERR_INVALID_PUSH_PAGE_INDEX:
+		return "IAVF_ERR_INVALID_PUSH_PAGE_INDEX";
+	case IAVF_ERR_INVALID_IMM_DATA_SIZE:
+		return "IAVF_ERR_INVALID_IMM_DATA_SIZE";
+	case IAVF_ERR_TIMEOUT:
+		return "IAVF_ERR_TIMEOUT";
+	case IAVF_ERR_OPCODE_MISMATCH:
+		return "IAVF_ERR_OPCODE_MISMATCH";
+	case IAVF_ERR_CQP_COMPL_ERROR:
+		return "IAVF_ERR_CQP_COMPL_ERROR";
+	case IAVF_ERR_INVALID_VF_ID:
+		return "IAVF_ERR_INVALID_VF_ID";
+	case IAVF_ERR_INVALID_HMCFN_ID:
+		return "IAVF_ERR_INVALID_HMCFN_ID";
+	case IAVF_ERR_BACKING_PAGE_ERROR:
+		return "IAVF_ERR_BACKING_PAGE_ERROR";
+	case IAVF_ERR_NO_PBLCHUNKS_AVAILABLE:
+		return "IAVF_ERR_NO_PBLCHUNKS_AVAILABLE";
+	case IAVF_ERR_INVALID_PBLE_INDEX:
+		return "IAVF_ERR_INVALID_PBLE_INDEX";
+	case IAVF_ERR_INVALID_SD_INDEX:
+		return "IAVF_ERR_INVALID_SD_INDEX";
+	case IAVF_ERR_INVALID_PAGE_DESC_INDEX:
+		return "IAVF_ERR_INVALID_PAGE_DESC_INDEX";
+	case IAVF_ERR_INVALID_SD_TYPE:
+		return "IAVF_ERR_INVALID_SD_TYPE";
+	case IAVF_ERR_MEMCPY_FAILED:
+		return "IAVF_ERR_MEMCPY_FAILED";
+	case IAVF_ERR_INVALID_HMC_OBJ_INDEX:
+		return "IAVF_ERR_INVALID_HMC_OBJ_INDEX";
+	case IAVF_ERR_INVALID_HMC_OBJ_COUNT:
+		return "IAVF_ERR_INVALID_HMC_OBJ_COUNT";
+	case IAVF_ERR_INVALID_SRQ_ARM_LIMIT:
+		return "IAVF_ERR_INVALID_SRQ_ARM_LIMIT";
+	case IAVF_ERR_SRQ_ENABLED:
+		return "IAVF_ERR_SRQ_ENABLED";
+	case IAVF_ERR_ADMIN_QUEUE_ERROR:
+		return "IAVF_ERR_ADMIN_QUEUE_ERROR";
+	case IAVF_ERR_ADMIN_QUEUE_TIMEOUT:
+		return "IAVF_ERR_ADMIN_QUEUE_TIMEOUT";
+	case IAVF_ERR_BUF_TOO_SHORT:
+		return "IAVF_ERR_BUF_TOO_SHORT";
+	case IAVF_ERR_ADMIN_QUEUE_FULL:
+		return "IAVF_ERR_ADMIN_QUEUE_FULL";
+	case IAVF_ERR_ADMIN_QUEUE_NO_WORK:
+		return "IAVF_ERR_ADMIN_QUEUE_NO_WORK";
+	case IAVF_ERR_BAD_IWARP_CQE:
+		return "IAVF_ERR_BAD_IWARP_CQE";
+	case IAVF_ERR_NVM_BLANK_MODE:
+		return "IAVF_ERR_NVM_BLANK_MODE";
+	case IAVF_ERR_NOT_IMPLEMENTED:
+		return "IAVF_ERR_NOT_IMPLEMENTED";
+	case IAVF_ERR_PE_DOORBELL_NOT_ENABLED:
+		return "IAVF_ERR_PE_DOORBELL_NOT_ENABLED";
+	case IAVF_ERR_DIAG_TEST_FAILED:
+		return "IAVF_ERR_DIAG_TEST_FAILED";
+	case IAVF_ERR_NOT_READY:
+		return "IAVF_ERR_NOT_READY";
+	case IAVF_NOT_SUPPORTED:
+		return "IAVF_NOT_SUPPORTED";
+	case IAVF_ERR_FIRMWARE_API_VERSION:
+		return "IAVF_ERR_FIRMWARE_API_VERSION";
+	case IAVF_ERR_ADMIN_QUEUE_CRITICAL_ERROR:
+		return "IAVF_ERR_ADMIN_QUEUE_CRITICAL_ERROR";
 	}
 
 	snprintf(hw->err_str, sizeof(hw->err_str), "%d", stat_err);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d1f4a3329abb..44d2150adb37 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -73,7 +73,7 @@ enum iavf_status iavf_allocate_dma_mem_d(struct iavf_hw *hw,
 	struct iavf_adapter *adapter = (struct iavf_adapter *)hw->back;
 
 	if (!mem)
-		return I40E_ERR_PARAM;
+		return IAVF_ERR_PARAM;
 
 	mem->size = ALIGN(size, alignment);
 	mem->va = dma_alloc_coherent(&adapter->pdev->dev, mem->size,
@@ -81,7 +81,7 @@ enum iavf_status iavf_allocate_dma_mem_d(struct iavf_hw *hw,
 	if (mem->va)
 		return 0;
 	else
-		return I40E_ERR_NO_MEMORY;
+		return IAVF_ERR_NO_MEMORY;
 }
 
 /**
@@ -95,7 +95,7 @@ enum iavf_status iavf_free_dma_mem_d(struct iavf_hw *hw,
 	struct iavf_adapter *adapter = (struct iavf_adapter *)hw->back;
 
 	if (!mem || !mem->va)
-		return I40E_ERR_PARAM;
+		return IAVF_ERR_PARAM;
 	dma_free_coherent(&adapter->pdev->dev, mem->size,
 			  mem->va, (dma_addr_t)mem->pa);
 	return 0;
@@ -111,7 +111,7 @@ enum iavf_status iavf_allocate_virt_mem_d(struct iavf_hw *hw,
 					  struct iavf_virt_mem *mem, u32 size)
 {
 	if (!mem)
-		return I40E_ERR_PARAM;
+		return IAVF_ERR_PARAM;
 
 	mem->size = size;
 	mem->va = kzalloc(size, GFP_KERNEL);
@@ -119,7 +119,7 @@ enum iavf_status iavf_allocate_virt_mem_d(struct iavf_hw *hw,
 	if (mem->va)
 		return 0;
 	else
-		return I40E_ERR_NO_MEMORY;
+		return IAVF_ERR_NO_MEMORY;
 }
 
 /**
@@ -131,7 +131,7 @@ enum iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw,
 				      struct iavf_virt_mem *mem)
 {
 	if (!mem)
-		return I40E_ERR_PARAM;
+		return IAVF_ERR_PARAM;
 
 	/* it's ok to kfree a NULL pointer */
 	kfree(mem->va);
@@ -2510,7 +2510,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ether dest mask %pM\n",
 					match.mask->dst);
-				return I40E_ERR_CONFIG;
+				return IAVF_ERR_CONFIG;
 			}
 		}
 
@@ -2520,7 +2520,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ether src mask %pM\n",
 					match.mask->src);
-				return I40E_ERR_CONFIG;
+				return IAVF_ERR_CONFIG;
 			}
 		}
 
@@ -2555,7 +2555,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad vlan mask %u\n",
 					match.mask->vlan_id);
-				return I40E_ERR_CONFIG;
+				return IAVF_ERR_CONFIG;
 			}
 		}
 		vf->mask.tcp_spec.vlan_id |= cpu_to_be16(0xffff);
@@ -2579,7 +2579,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ip dst mask 0x%08x\n",
 					be32_to_cpu(match.mask->dst));
-				return I40E_ERR_CONFIG;
+				return IAVF_ERR_CONFIG;
 			}
 		}
 
@@ -2589,13 +2589,13 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad ip src mask 0x%08x\n",
 					be32_to_cpu(match.mask->dst));
-				return I40E_ERR_CONFIG;
+				return IAVF_ERR_CONFIG;
 			}
 		}
 
 		if (field_flags & IAVF_CLOUD_FIELD_TEN_ID) {
 			dev_info(&adapter->pdev->dev, "Tenant id not allowed for ip filter\n");
-			return I40E_ERR_CONFIG;
+			return IAVF_ERR_CONFIG;
 		}
 		if (match.key->dst) {
 			vf->mask.tcp_spec.dst_ip[0] |= cpu_to_be32(0xffffffff);
@@ -2616,7 +2616,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 		if (ipv6_addr_any(&match.mask->dst)) {
 			dev_err(&adapter->pdev->dev, "Bad ipv6 dst mask 0x%02x\n",
 				IPV6_ADDR_ANY);
-			return I40E_ERR_CONFIG;
+			return IAVF_ERR_CONFIG;
 		}
 
 		/* src and dest IPv6 address should not be LOOPBACK
@@ -2626,7 +2626,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 		    ipv6_addr_loopback(&match.key->src)) {
 			dev_err(&adapter->pdev->dev,
 				"ipv6 addr should not be loopback\n");
-			return I40E_ERR_CONFIG;
+			return IAVF_ERR_CONFIG;
 		}
 		if (!ipv6_addr_any(&match.mask->dst) ||
 		    !ipv6_addr_any(&match.mask->src))
@@ -2651,7 +2651,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad src port mask %u\n",
 					be16_to_cpu(match.mask->src));
-				return I40E_ERR_CONFIG;
+				return IAVF_ERR_CONFIG;
 			}
 		}
 
@@ -2661,7 +2661,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
 			} else {
 				dev_err(&adapter->pdev->dev, "Bad dst port mask %u\n",
 					be16_to_cpu(match.mask->dst));
-				return I40E_ERR_CONFIG;
+				return IAVF_ERR_CONFIG;
 			}
 		}
 		if (match.key->dst) {
@@ -3404,7 +3404,7 @@ static void iavf_init_task(struct work_struct *work)
 		/* aq msg sent, awaiting reply */
 		err = iavf_verify_api_ver(adapter);
 		if (err) {
-			if (err == I40E_ERR_ADMIN_QUEUE_NO_WORK)
+			if (err == IAVF_ERR_ADMIN_QUEUE_NO_WORK)
 				err = iavf_send_api_ver(adapter);
 			else
 				dev_err(&pdev->dev, "Unsupported PF API version %d.%d, expected %d.%d\n",
@@ -3432,10 +3432,10 @@ static void iavf_init_task(struct work_struct *work)
 				goto err;
 		}
 		err = iavf_get_vf_config(adapter);
-		if (err == I40E_ERR_ADMIN_QUEUE_NO_WORK) {
+		if (err == IAVF_ERR_ADMIN_QUEUE_NO_WORK) {
 			err = iavf_send_vf_config_msg(adapter);
 			goto err;
-		} else if (err == I40E_ERR_PARAM) {
+		} else if (err == IAVF_ERR_PARAM) {
 			/* We only get ERR_PARAM if the device is in a very bad
 			 * state or if we've been disabled for previous bad
 			 * behavior. Either way, we're done now.
diff --git a/drivers/net/ethernet/intel/iavf/iavf_status.h b/drivers/net/ethernet/intel/iavf/iavf_status.h
index 95026298685d..46e3d1f6b604 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_status.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_status.h
@@ -6,73 +6,73 @@
 
 /* Error Codes */
 enum iavf_status {
-	I40E_SUCCESS				= 0,
-	I40E_ERR_NVM				= -1,
-	I40E_ERR_NVM_CHECKSUM			= -2,
-	I40E_ERR_PHY				= -3,
-	I40E_ERR_CONFIG				= -4,
-	I40E_ERR_PARAM				= -5,
-	I40E_ERR_MAC_TYPE			= -6,
-	I40E_ERR_UNKNOWN_PHY			= -7,
-	I40E_ERR_LINK_SETUP			= -8,
-	I40E_ERR_ADAPTER_STOPPED		= -9,
-	I40E_ERR_INVALID_MAC_ADDR		= -10,
-	I40E_ERR_DEVICE_NOT_SUPPORTED		= -11,
-	I40E_ERR_MASTER_REQUESTS_PENDING	= -12,
-	I40E_ERR_INVALID_LINK_SETTINGS		= -13,
-	I40E_ERR_AUTONEG_NOT_COMPLETE		= -14,
-	I40E_ERR_RESET_FAILED			= -15,
-	I40E_ERR_SWFW_SYNC			= -16,
-	I40E_ERR_NO_AVAILABLE_VSI		= -17,
-	I40E_ERR_NO_MEMORY			= -18,
-	I40E_ERR_BAD_PTR			= -19,
-	I40E_ERR_RING_FULL			= -20,
-	I40E_ERR_INVALID_PD_ID			= -21,
-	I40E_ERR_INVALID_QP_ID			= -22,
-	I40E_ERR_INVALID_CQ_ID			= -23,
-	I40E_ERR_INVALID_CEQ_ID			= -24,
-	I40E_ERR_INVALID_AEQ_ID			= -25,
-	I40E_ERR_INVALID_SIZE			= -26,
-	I40E_ERR_INVALID_ARP_INDEX		= -27,
-	I40E_ERR_INVALID_FPM_FUNC_ID		= -28,
-	I40E_ERR_QP_INVALID_MSG_SIZE		= -29,
-	I40E_ERR_QP_TOOMANY_WRS_POSTED		= -30,
-	I40E_ERR_INVALID_FRAG_COUNT		= -31,
-	I40E_ERR_QUEUE_EMPTY			= -32,
-	I40E_ERR_INVALID_ALIGNMENT		= -33,
-	I40E_ERR_FLUSHED_QUEUE			= -34,
-	I40E_ERR_INVALID_PUSH_PAGE_INDEX	= -35,
-	I40E_ERR_INVALID_IMM_DATA_SIZE		= -36,
-	I40E_ERR_TIMEOUT			= -37,
-	I40E_ERR_OPCODE_MISMATCH		= -38,
-	I40E_ERR_CQP_COMPL_ERROR		= -39,
-	I40E_ERR_INVALID_VF_ID			= -40,
-	I40E_ERR_INVALID_HMCFN_ID		= -41,
-	I40E_ERR_BACKING_PAGE_ERROR		= -42,
-	I40E_ERR_NO_PBLCHUNKS_AVAILABLE		= -43,
-	I40E_ERR_INVALID_PBLE_INDEX		= -44,
-	I40E_ERR_INVALID_SD_INDEX		= -45,
-	I40E_ERR_INVALID_PAGE_DESC_INDEX	= -46,
-	I40E_ERR_INVALID_SD_TYPE		= -47,
-	I40E_ERR_MEMCPY_FAILED			= -48,
-	I40E_ERR_INVALID_HMC_OBJ_INDEX		= -49,
-	I40E_ERR_INVALID_HMC_OBJ_COUNT		= -50,
-	I40E_ERR_INVALID_SRQ_ARM_LIMIT		= -51,
-	I40E_ERR_SRQ_ENABLED			= -52,
-	I40E_ERR_ADMIN_QUEUE_ERROR		= -53,
-	I40E_ERR_ADMIN_QUEUE_TIMEOUT		= -54,
-	I40E_ERR_BUF_TOO_SHORT			= -55,
-	I40E_ERR_ADMIN_QUEUE_FULL		= -56,
-	I40E_ERR_ADMIN_QUEUE_NO_WORK		= -57,
-	I40E_ERR_BAD_IWARP_CQE			= -58,
-	I40E_ERR_NVM_BLANK_MODE			= -59,
-	I40E_ERR_NOT_IMPLEMENTED		= -60,
-	I40E_ERR_PE_DOORBELL_NOT_ENABLED	= -61,
-	I40E_ERR_DIAG_TEST_FAILED		= -62,
-	I40E_ERR_NOT_READY			= -63,
-	I40E_NOT_SUPPORTED			= -64,
-	I40E_ERR_FIRMWARE_API_VERSION		= -65,
-	I40E_ERR_ADMIN_QUEUE_CRITICAL_ERROR	= -66,
+	IAVF_SUCCESS				= 0,
+	IAVF_ERR_NVM				= -1,
+	IAVF_ERR_NVM_CHECKSUM			= -2,
+	IAVF_ERR_PHY				= -3,
+	IAVF_ERR_CONFIG				= -4,
+	IAVF_ERR_PARAM				= -5,
+	IAVF_ERR_MAC_TYPE			= -6,
+	IAVF_ERR_UNKNOWN_PHY			= -7,
+	IAVF_ERR_LINK_SETUP			= -8,
+	IAVF_ERR_ADAPTER_STOPPED		= -9,
+	IAVF_ERR_INVALID_MAC_ADDR		= -10,
+	IAVF_ERR_DEVICE_NOT_SUPPORTED		= -11,
+	IAVF_ERR_MASTER_REQUESTS_PENDING	= -12,
+	IAVF_ERR_INVALID_LINK_SETTINGS		= -13,
+	IAVF_ERR_AUTONEG_NOT_COMPLETE		= -14,
+	IAVF_ERR_RESET_FAILED			= -15,
+	IAVF_ERR_SWFW_SYNC			= -16,
+	IAVF_ERR_NO_AVAILABLE_VSI		= -17,
+	IAVF_ERR_NO_MEMORY			= -18,
+	IAVF_ERR_BAD_PTR			= -19,
+	IAVF_ERR_RING_FULL			= -20,
+	IAVF_ERR_INVALID_PD_ID			= -21,
+	IAVF_ERR_INVALID_QP_ID			= -22,
+	IAVF_ERR_INVALID_CQ_ID			= -23,
+	IAVF_ERR_INVALID_CEQ_ID			= -24,
+	IAVF_ERR_INVALID_AEQ_ID			= -25,
+	IAVF_ERR_INVALID_SIZE			= -26,
+	IAVF_ERR_INVALID_ARP_INDEX		= -27,
+	IAVF_ERR_INVALID_FPM_FUNC_ID		= -28,
+	IAVF_ERR_QP_INVALID_MSG_SIZE		= -29,
+	IAVF_ERR_QP_TOOMANY_WRS_POSTED		= -30,
+	IAVF_ERR_INVALID_FRAG_COUNT		= -31,
+	IAVF_ERR_QUEUE_EMPTY			= -32,
+	IAVF_ERR_INVALID_ALIGNMENT		= -33,
+	IAVF_ERR_FLUSHED_QUEUE			= -34,
+	IAVF_ERR_INVALID_PUSH_PAGE_INDEX	= -35,
+	IAVF_ERR_INVALID_IMM_DATA_SIZE		= -36,
+	IAVF_ERR_TIMEOUT			= -37,
+	IAVF_ERR_OPCODE_MISMATCH		= -38,
+	IAVF_ERR_CQP_COMPL_ERROR		= -39,
+	IAVF_ERR_INVALID_VF_ID			= -40,
+	IAVF_ERR_INVALID_HMCFN_ID		= -41,
+	IAVF_ERR_BACKING_PAGE_ERROR		= -42,
+	IAVF_ERR_NO_PBLCHUNKS_AVAILABLE		= -43,
+	IAVF_ERR_INVALID_PBLE_INDEX		= -44,
+	IAVF_ERR_INVALID_SD_INDEX		= -45,
+	IAVF_ERR_INVALID_PAGE_DESC_INDEX	= -46,
+	IAVF_ERR_INVALID_SD_TYPE		= -47,
+	IAVF_ERR_MEMCPY_FAILED			= -48,
+	IAVF_ERR_INVALID_HMC_OBJ_INDEX		= -49,
+	IAVF_ERR_INVALID_HMC_OBJ_COUNT		= -50,
+	IAVF_ERR_INVALID_SRQ_ARM_LIMIT		= -51,
+	IAVF_ERR_SRQ_ENABLED			= -52,
+	IAVF_ERR_ADMIN_QUEUE_ERROR		= -53,
+	IAVF_ERR_ADMIN_QUEUE_TIMEOUT		= -54,
+	IAVF_ERR_BUF_TOO_SHORT			= -55,
+	IAVF_ERR_ADMIN_QUEUE_FULL		= -56,
+	IAVF_ERR_ADMIN_QUEUE_NO_WORK		= -57,
+	IAVF_ERR_BAD_IWARP_CQE			= -58,
+	IAVF_ERR_NVM_BLANK_MODE			= -59,
+	IAVF_ERR_NOT_IMPLEMENTED		= -60,
+	IAVF_ERR_PE_DOORBELL_NOT_ENABLED	= -61,
+	IAVF_ERR_DIAG_TEST_FAILED		= -62,
+	IAVF_ERR_NOT_READY			= -63,
+	IAVF_NOT_SUPPORTED			= -64,
+	IAVF_ERR_FIRMWARE_API_VERSION		= -65,
+	IAVF_ERR_ADMIN_QUEUE_CRITICAL_ERROR	= -66,
 };
 
 #endif /* _IAVF_STATUS_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 47df277e12d7..b9f73154dcee 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -60,7 +60,7 @@ int iavf_send_api_ver(struct iavf_adapter *adapter)
  *
  * Compare API versions with the PF. Must be called after admin queue is
  * initialized. Returns 0 if API versions match, -EIO if they do not,
- * I40E_ERR_ADMIN_QUEUE_NO_WORK if the admin queue is empty, and any errors
+ * IAVF_ERR_ADMIN_QUEUE_NO_WORK if the admin queue is empty, and any errors
  * from the firmware are propagated.
  **/
 int iavf_verify_api_ver(struct iavf_adapter *adapter)
-- 
2.21.0

