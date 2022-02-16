Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54334B918E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbiBPTmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:42:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbiBPTmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:42:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6656E10EC79;
        Wed, 16 Feb 2022 11:42:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03F74618C1;
        Wed, 16 Feb 2022 19:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30B6C004E1;
        Wed, 16 Feb 2022 19:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645040555;
        bh=mPG4ycp9gIAGAdoVgn30jUFXPydzNYcnE8hERVvj+sc=;
        h=Date:From:To:Cc:Subject:From;
        b=oO8W/fvj177LwkkO8f+l+T4Y/7au1+kjuZi+7nGDXy9F75YXYvzhnIUQGIP2voyq/
         WvrN3rwdM7v8ExCaafUSXyAnJMC+w67YAHJ1vrCEf0cKX6WPPt/whC7OUdcHgAgie8
         vJGrzvNvD9Q8ZslEK8pnUDqc1vjJm/EGoZTlWhbZsJIOAtDt2oyBe9vajQEz2QzRZz
         ickD0kNnQVr3wuD+A1NavtcHliUg24N9hmPyYDyl2TKzfmwsFvUB7RjnuUt1gQzKOi
         Z9ZAgHZ9+rArVxpoo4Bqvhl1Oj4SYrIyGz+XZ6pfFP1ZfhYbmKRezMtkSs02gMHojE
         SCp7UAlOAAsEg==
Date:   Wed, 16 Feb 2022 13:50:15 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] iwlwifi: fw: Replace zero-length arrays with
 flexible-array members
Message-ID: <20220216195015.GA904148@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare
having a dynamically sized set of trailing elements in a structure.
Kernel code should always use “flexible array members”[1] for these
cases. The older style of one-element or zero-length arrays should
no longer be used[2].

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h |  4 ++--
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h   |  4 ++--
 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h  |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h    |  4 ++--
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h     |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h    |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h  |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h        | 12 ++++++------
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index 456b7eaac570..9df7eda3b3e7 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -25,7 +25,7 @@ struct iwl_fw_ini_hcmd {
 	u8 id;
 	u8 group;
 	__le16 reserved;
-	u8 data[0];
+	u8 data[];
 } __packed; /* FW_DEBUG_TLV_HCMD_DATA_API_S_VER_1 */
 
 /**
@@ -275,7 +275,7 @@ struct iwl_fw_ini_conf_set_tlv {
 	__le32 time_point;
 	__le32 set_type;
 	__le32 addr_offset;
-	struct iwl_fw_ini_addr_val addr_val[0];
+	struct iwl_fw_ini_addr_val addr_val[];
 } __packed; /* FW_TLV_DEBUG_CONFIG_SET_API_S_VER_1 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h b/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
index 029ae64bf2b2..e732afc7204d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
@@ -234,7 +234,7 @@ struct iwl_mfu_assert_dump_notif {
 	__le16   index_num;
 	__le16   parts_num;
 	__le32   data_size;
-	__le32   data[0];
+	__le32   data[];
 } __packed; /* MFU_DUMP_ASSERT_API_S_VER_1 */
 
 /**
@@ -270,7 +270,7 @@ struct iwl_mvm_marker {
 	u8 marker_id;
 	__le16 reserved;
 	__le64 timestamp;
-	__le32 metadata[0];
+	__le32 metadata[];
 } __packed; /* MARKER_API_S_VER_1 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/filter.h b/drivers/net/wireless/intel/iwlwifi/fw/api/filter.h
index dd62a63956b3..0783b531f616 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/filter.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/filter.h
@@ -33,7 +33,7 @@ struct iwl_mcast_filter_cmd {
 	u8 pass_all;
 	u8 bssid[6];
 	u8 reserved[2];
-	u8 addr_list[0];
+	u8 addr_list[];
 } __packed; /* MCAST_FILTERING_CMD_API_S_VER_1 */
 
 #define MAX_BCAST_FILTERS 8
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index 5413087ae909..5543d9cb74c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -1165,7 +1165,7 @@ struct iwl_scan_offload_profiles_query_v1 {
 	u8 resume_while_scanning;
 	u8 self_recovery;
 	__le16 reserved;
-	struct iwl_scan_offload_profile_match_v1 matches[0];
+	struct iwl_scan_offload_profile_match_v1 matches[];
 } __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_2 */
 
 /**
@@ -1209,7 +1209,7 @@ struct iwl_scan_offload_profiles_query {
 	u8 resume_while_scanning;
 	u8 self_recovery;
 	__le16 reserved;
-	struct iwl_scan_offload_profile_match matches[0];
+	struct iwl_scan_offload_profile_match matches[];
 } __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_3 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h b/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
index 5edbe27c0922..d62fed543276 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
@@ -477,7 +477,7 @@ struct iwl_mvm_wep_key_cmd {
 	u8 decryption_type;
 	u8 flags;
 	u8 reserved;
-	struct iwl_mvm_wep_key wep_key[0];
+	struct iwl_mvm_wep_key wep_key[];
 } __packed; /* SEC_CURR_WEP_KEY_CMD_API_S_VER_2 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h
index 14d35000abed..893438aadab0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h
@@ -132,7 +132,7 @@ struct iwl_tdls_config_cmd {
 
 	__le32 pti_req_data_offset;
 	struct iwl_tx_cmd pti_req_tx_cmd;
-	u8 pti_req_template[0];
+	u8 pti_req_template[];
 } __packed; /* TDLS_CONFIG_CMD_API_S_VER_1 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index 079fa0023bd8..c62576e442bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -84,7 +84,7 @@ struct iwl_fw_error_dump_data {
 struct iwl_fw_error_dump_file {
 	__le32 barker;
 	__le32 file_len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index e4ebda64cd52..e336c254a2ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -119,7 +119,7 @@ enum iwl_ucode_tlv_type {
 struct iwl_ucode_tlv {
 	__le32 type;		/* see above */
 	__le32 length;		/* not including type/length fields */
-	u8 data[0];
+	u8 data[];
 };
 
 #define IWL_TLV_UCODE_MAGIC		0x0a4c5749
@@ -145,7 +145,7 @@ struct iwl_tlv_ucode_header {
 	 * Note that each TLV is padded to a length
 	 * that is a multiple of 4 for alignment.
 	 */
-	u8 data[0];
+	u8 data[];
 };
 
 /*
@@ -631,7 +631,7 @@ struct iwl_fw_dbg_dest_tlv_v1 {
 	__le32 wrap_count;
 	u8 base_shift;
 	u8 end_shift;
-	struct iwl_fw_dbg_reg_op reg_ops[0];
+	struct iwl_fw_dbg_reg_op reg_ops[];
 } __packed;
 
 /* Mask of the register for defining the LDBG MAC2SMEM buffer SMEM size */
@@ -651,14 +651,14 @@ struct iwl_fw_dbg_dest_tlv {
 	__le32 wrap_count;
 	u8 base_shift;
 	u8 size_shift;
-	struct iwl_fw_dbg_reg_op reg_ops[0];
+	struct iwl_fw_dbg_reg_op reg_ops[];
 } __packed;
 
 struct iwl_fw_dbg_conf_hcmd {
 	u8 id;
 	u8 reserved;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /**
@@ -733,7 +733,7 @@ struct iwl_fw_dbg_trigger_tlv {
 	u8 flags;
 	u8 reserved[5];
 
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #define FW_DBG_START_FROM_ALIVE	0
-- 
2.27.0

