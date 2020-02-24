Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9696E16AE05
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgBXRwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:52:17 -0500
Received: from gateway36.websitewelcome.com ([192.185.196.23]:41449 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727426AbgBXRwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:52:16 -0500
X-Greylist: delayed 1499 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2020 12:52:15 EST
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 46D2E40DABC75
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 10:21:02 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6HBTjYyj5RP4z6HBTjy9oE; Mon, 24 Feb 2020 11:06:19 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O10piskvmeldfVVJejkQxB0SXPAWTxh0tLVp0iAU9MU=; b=X/v5OueXOc3toNPFnoZwP52nNr
        kEodOpB71BF/q04Wq29wN9ZRRSLVS1SDQrWGsMU0U56vPTWG14WHDGZL6C6EJvaD6Qhnhc9JxBfEL
        cG1fIiOncUSB+bPPkboZ/vMQzj3sE4+2F9U7KjI+yFLqWV46hkxS7zz8qJXh++BaK0yMdOVKngtgi
        7iov53JgBGZ1K25FdlOMRDTVffycdwMmLvBF93Nf7UBpO7RlCG7OZWlpMSL4WlDF1w/08vXNfKBxs
        3kVFbrRZlsL4nz9Rwn3EuJgj8ZijsXiDVo1xSJr4jT5t9MnprNVohGNrgyEZmPyLvnpVd4Whkvl8c
        PlL1EFJA==;
Received: from [200.68.140.135] (port=5352 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6HBR-00397R-Ea; Mon, 24 Feb 2020 11:06:17 -0600
Date:   Mon, 24 Feb 2020 11:09:07 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] wireless: intel: Replace zero-length array with
 flexible-array member
Message-ID: <20200224170907.GA9948@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.140.135
X-Source-L: No
X-Exim-ID: 1j6HBR-00397R-Ea
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.135]:5352
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 10
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was detected with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |  2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h  | 10 +++----
 drivers/net/wireless/intel/ipw2x00/libipw.h   | 28 +++++++++----------
 .../wireless/intel/iwlegacy/iwl-spectrum.h    |  4 +--
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   |  2 +-
 .../net/wireless/intel/iwlwifi/fw/api/debug.h |  4 +--
 .../wireless/intel/iwlwifi/fw/api/filter.h    |  2 +-
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   |  4 +--
 .../net/wireless/intel/iwlwifi/fw/api/sta.h   |  2 +-
 .../net/wireless/intel/iwlwifi/fw/api/tdls.h  |  2 +-
 .../net/wireless/intel/iwlwifi/fw/debugfs.c   |  2 +-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  | 12 ++++----
 .../net/wireless/intel/iwlwifi/iwl-op-mode.h  |  2 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  2 +-
 15 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 5ef6f87a48ac..f7c7b2cb73b8 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3386,7 +3386,7 @@ struct ipw_fw {
 	__le32 boot_size;
 	__le32 ucode_size;
 	__le32 fw_size;
-	u8 data[0];
+	u8 data[];
 };
 
 static int ipw_get_fw(struct ipw_priv *priv,
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.h b/drivers/net/wireless/intel/ipw2x00/ipw2200.h
index 4346520545c4..09fa7f19050f 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.h
@@ -448,7 +448,7 @@ struct tfd_command {
 	u8 index;
 	u8 length;
 	__le16 reserved;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct tfd_data {
@@ -675,7 +675,7 @@ struct ipw_rx_frame {
 	// is identical)
 	u8 rtscts_seen;		// 0x1 RTS seen ; 0x2 CTS seen
 	__le16 length;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct ipw_rx_header {
@@ -1002,7 +1002,7 @@ struct ipw_cmd {	 /* XXX */
    * Incoming parameters listed 1-st, followed by outcoming params.
    * nParams=(len+3)/4+status_len
    */
-	u32 param[0];
+	u32 param[];
 } __packed;
 
 #define STATUS_HCMD_ACTIVE      (1<<0)	/**< host command in progress */
@@ -1108,7 +1108,7 @@ struct ipw_fw_error {	 /* XXX */
 	u32 log_len;
 	struct ipw_error_elem *elem;
 	struct ipw_event *log;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 #ifdef CONFIG_IPW2200_PROMISCUOUS
@@ -1153,7 +1153,7 @@ struct ipw_rt_hdr {
 	s8 rt_dbmsignal;	/* signal in dbM, kluged to signed */
 	s8 rt_dbmnoise;
 	u8 rt_antenna;	/* antenna number */
-	u8 payload[0];  /* payload... */
+	u8 payload[];  /* payload... */
 } __packed;
 #endif
 
diff --git a/drivers/net/wireless/intel/ipw2x00/libipw.h b/drivers/net/wireless/intel/ipw2x00/libipw.h
index e4a6ab4e8391..e87538a8b88b 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw.h
+++ b/drivers/net/wireless/intel/ipw2x00/libipw.h
@@ -334,7 +334,7 @@ struct libipw_hdr_1addr {
 	__le16 frame_ctl;
 	__le16 duration_id;
 	u8 addr1[ETH_ALEN];
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct libipw_hdr_2addr {
@@ -342,7 +342,7 @@ struct libipw_hdr_2addr {
 	__le16 duration_id;
 	u8 addr1[ETH_ALEN];
 	u8 addr2[ETH_ALEN];
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct libipw_hdr_3addr {
@@ -352,7 +352,7 @@ struct libipw_hdr_3addr {
 	u8 addr2[ETH_ALEN];
 	u8 addr3[ETH_ALEN];
 	__le16 seq_ctl;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct libipw_hdr_4addr {
@@ -363,7 +363,7 @@ struct libipw_hdr_4addr {
 	u8 addr3[ETH_ALEN];
 	__le16 seq_ctl;
 	u8 addr4[ETH_ALEN];
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct libipw_hdr_3addrqos {
@@ -380,7 +380,7 @@ struct libipw_hdr_3addrqos {
 struct libipw_info_element {
 	u8 id;
 	u8 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /*
@@ -406,7 +406,7 @@ struct libipw_auth {
 	__le16 transaction;
 	__le16 status;
 	/* challenge */
-	struct libipw_info_element info_element[0];
+	struct libipw_info_element info_element[];
 } __packed;
 
 struct libipw_channel_switch {
@@ -442,7 +442,7 @@ struct libipw_disassoc {
 struct libipw_probe_request {
 	struct libipw_hdr_3addr header;
 	/* SSID, supported rates */
-	struct libipw_info_element info_element[0];
+	struct libipw_info_element info_element[];
 } __packed;
 
 struct libipw_probe_response {
@@ -452,7 +452,7 @@ struct libipw_probe_response {
 	__le16 capability;
 	/* SSID, supported rates, FH params, DS params,
 	 * CF params, IBSS params, TIM (if beacon), RSN */
-	struct libipw_info_element info_element[0];
+	struct libipw_info_element info_element[];
 } __packed;
 
 /* Alias beacon for probe_response */
@@ -463,7 +463,7 @@ struct libipw_assoc_request {
 	__le16 capability;
 	__le16 listen_interval;
 	/* SSID, supported rates, RSN */
-	struct libipw_info_element info_element[0];
+	struct libipw_info_element info_element[];
 } __packed;
 
 struct libipw_reassoc_request {
@@ -471,7 +471,7 @@ struct libipw_reassoc_request {
 	__le16 capability;
 	__le16 listen_interval;
 	u8 current_ap[ETH_ALEN];
-	struct libipw_info_element info_element[0];
+	struct libipw_info_element info_element[];
 } __packed;
 
 struct libipw_assoc_response {
@@ -480,7 +480,7 @@ struct libipw_assoc_response {
 	__le16 status;
 	__le16 aid;
 	/* supported rates */
-	struct libipw_info_element info_element[0];
+	struct libipw_info_element info_element[];
 } __packed;
 
 struct libipw_txb {
@@ -490,7 +490,7 @@ struct libipw_txb {
 	u8 reserved;
 	u16 frag_size;
 	u16 payload_size;
-	struct sk_buff *fragments[0];
+	struct sk_buff *fragments[];
 };
 
 /* SWEEP TABLE ENTRIES NUMBER */
@@ -594,7 +594,7 @@ struct libipw_ibss_dfs {
 	struct libipw_info_element ie;
 	u8 owner[ETH_ALEN];
 	u8 recovery_interval;
-	struct libipw_channel_map channel_map[0];
+	struct libipw_channel_map channel_map[];
 };
 
 struct libipw_csa {
@@ -830,7 +830,7 @@ struct libipw_device {
 
 	/* This must be the last item so that it points to the data
 	 * allocated beyond this structure by alloc_libipw */
-	u8 priv[0];
+	u8 priv[];
 };
 
 #define IEEE_A            (1<<0)
diff --git a/drivers/net/wireless/intel/iwlegacy/iwl-spectrum.h b/drivers/net/wireless/intel/iwlegacy/iwl-spectrum.h
index a3b490501a70..1e8ab704dbfb 100644
--- a/drivers/net/wireless/intel/iwlegacy/iwl-spectrum.h
+++ b/drivers/net/wireless/intel/iwlegacy/iwl-spectrum.h
@@ -53,7 +53,7 @@ struct ieee80211_measurement_params {
 struct ieee80211_info_element {
 	u8 id;
 	u8 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct ieee80211_measurement_request {
@@ -61,7 +61,7 @@ struct ieee80211_measurement_request {
 	u8 token;
 	u8 mode;
 	u8 type;
-	struct ieee80211_measurement_params params[0];
+	struct ieee80211_measurement_params params[];
 } __packed;
 
 struct ieee80211_measurement_report {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index b9d7ed93311c..da84dc69dbd0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -77,7 +77,7 @@ struct iwl_fw_ini_hcmd {
 	u8 id;
 	u8 group;
 	__le16 reserved;
-	u8 data[0];
+	u8 data[];
 } __packed; /* FW_DEBUG_TLV_HCMD_DATA_API_S_VER_1 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h b/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
index 98e957ecbeed..d3791f73b67f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/debug.h
@@ -266,7 +266,7 @@ struct iwl_mfu_assert_dump_notif {
 	__le16   index_num;
 	__le16   parts_num;
 	__le32   data_size;
-	__le32   data[0];
+	__le32   data[];
 } __packed; /* MFU_DUMP_ASSERT_API_S_VER_1 */
 
 /**
@@ -302,7 +302,7 @@ struct iwl_mvm_marker {
 	u8 marker_id;
 	__le16 reserved;
 	__le64 timestamp;
-	__le32 metadata[0];
+	__le32 metadata[];
 } __packed; /* MARKER_API_S_VER_1 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/filter.h b/drivers/net/wireless/intel/iwlwifi/fw/api/filter.h
index befc3b126041..a4064a6fb4d1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/filter.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/filter.h
@@ -89,7 +89,7 @@ struct iwl_mcast_filter_cmd {
 	u8 pass_all;
 	u8 bssid[6];
 	u8 reserved[2];
-	u8 addr_list[0];
+	u8 addr_list[];
 } __packed; /* MCAST_FILTERING_CMD_API_S_VER_1 */
 
 #define MAX_BCAST_FILTERS 8
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index 97b49843e318..397ac89a04c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -351,7 +351,7 @@ struct iwl_mcc_update_resp_v3 {
 	__le16 time;
 	__le16 geo_info;
 	__le32 n_channels;
-	__le32 channels[0];
+	__le32 channels[];
 } __packed; /* LAR_UPDATE_MCC_CMD_RESP_S_VER_3 */
 
 /**
@@ -380,7 +380,7 @@ struct iwl_mcc_update_resp {
 	u8 source_id;
 	u8 reserved[3];
 	__le32 n_channels;
-	__le32 channels[0];
+	__le32 channels[];
 } __packed; /* LAR_UPDATE_MCC_CMD_RESP_S_VER_4 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h b/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
index 970e9e508ad0..8f9ef474f3b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
@@ -552,7 +552,7 @@ struct iwl_mvm_wep_key_cmd {
 	u8 decryption_type;
 	u8 flags;
 	u8 reserved;
-	struct iwl_mvm_wep_key wep_key[0];
+	struct iwl_mvm_wep_key wep_key[];
 } __packed; /* SEC_CURR_WEP_KEY_CMD_API_S_VER_2 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h
index b089285ac466..ec2a00d6c684 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h
@@ -190,7 +190,7 @@ struct iwl_tdls_config_cmd {
 
 	__le32 pti_req_data_offset;
 	struct iwl_tx_cmd pti_req_tx_cmd;
-	u8 pti_req_template[0];
+	u8 pti_req_template[];
 } __packed; /* TDLS_CONFIG_CMD_API_S_VER_1 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index 89f74116569d..cc1d93606d9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -261,7 +261,7 @@ struct hcmd_write_data {
 	__be32 cmd_id;
 	__be32 flags;
 	__be16 length;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 static ssize_t iwl_dbgfs_send_hcmd_write(struct iwl_fw_runtime *fwrt, char *buf,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index f008e1bbfdf4..f331a16fd940 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -141,7 +141,7 @@ struct iwl_fw_error_dump_data {
 struct iwl_fw_error_dump_file {
 	__le32 barker;
 	__le32 file_len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 1554f5fdd483..92910af88666 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -165,7 +165,7 @@ enum iwl_ucode_tlv_type {
 struct iwl_ucode_tlv {
 	__le32 type;		/* see above */
 	__le32 length;		/* not including type/length fields */
-	u8 data[0];
+	u8 data[];
 };
 
 #define IWL_TLV_UCODE_MAGIC		0x0a4c5749
@@ -191,7 +191,7 @@ struct iwl_tlv_ucode_header {
 	 * Note that each TLV is padded to a length
 	 * that is a multiple of 4 for alignment.
 	 */
-	u8 data[0];
+	u8 data[];
 };
 
 /*
@@ -652,7 +652,7 @@ struct iwl_fw_dbg_dest_tlv_v1 {
 	__le32 wrap_count;
 	u8 base_shift;
 	u8 end_shift;
-	struct iwl_fw_dbg_reg_op reg_ops[0];
+	struct iwl_fw_dbg_reg_op reg_ops[];
 } __packed;
 
 /* Mask of the register for defining the LDBG MAC2SMEM buffer SMEM size */
@@ -672,14 +672,14 @@ struct iwl_fw_dbg_dest_tlv {
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
@@ -754,7 +754,7 @@ struct iwl_fw_dbg_trigger_tlv {
 	u8 flags;
 	u8 reserved[5];
 
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #define FW_DBG_START_FROM_ALIVE	0
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
index 3008a5246be8..b35b8920941b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
@@ -175,7 +175,7 @@ void iwl_opmode_deregister(const char *name);
 struct iwl_op_mode {
 	const struct iwl_op_mode_ops *ops;
 
-	char op_mode_specific[0] __aligned(sizeof(void *));
+	char op_mode_specific[] __aligned(sizeof(void *));
 };
 
 static inline void iwl_op_mode_stop(struct iwl_op_mode *op_mode)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 7b3b1f4c99b4..a3fdaa9f2654 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -875,7 +875,7 @@ struct iwl_trans {
 
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
-	char trans_specific[0] __aligned(sizeof(void *));
+	char trans_specific[] __aligned(sizeof(void *));
 };
 
 const char *iwl_get_cmd_string(struct iwl_trans *trans, u32 id);
-- 
2.25.0

