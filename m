Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F1627A213
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 19:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgI0Rms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 13:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgI0Rmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 13:42:46 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1AEC0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:46 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x5so1958161plo.6
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 10:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ks+/gV+5SJCo98NNo6WFKTfR1XUnzB/LjRhC4ZYMUYA=;
        b=J0UWr8aqjWWN8FXUr7dUuSL6Co09DrhmUF5QOv2MQ3/ukI7aA1E9cNrwdUWMbuqKud
         5njiaUEsGJWy+SB4Sj4uRVu8sXt7GOf6yodEseskh9ygyNphI+vYRluerjbg5PIi7jQn
         c0zZjvcZv5s/A+8788aRzLix7LAiywseiMzPI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ks+/gV+5SJCo98NNo6WFKTfR1XUnzB/LjRhC4ZYMUYA=;
        b=hv9wvCX4PEs+KmtXiqYv8bPrRgY2ES3JwsGUFDT2OkAZn+W6bK6AQWsCR5JrKvfrTH
         KuLXrjCzm2jk2CYcyZ+lY6GlkHT43VFfXu3H8GoPIKxO1idz27/WUC30X2aCj+SH0/Um
         zl7ikryDGRvrr/zsOCbjvqOzWMsoeNKVeTyuitXN+T7q1lQZjFUmrsv2fWgc8M7DUNdw
         3o+JFEn56/N1a2Y6Qum2ryxG/q9KEbfKsGNoO+B6OBlxXw2XaNo81bQ9HrWycy9bQjGZ
         I8ekaGWJTywtDBc6/Lf8tlnxeWK2/zMe/QkxJWxlpRTQdPb3r7z4yVOtC6FLrm08Dvmw
         FDIA==
X-Gm-Message-State: AOAM531OwhCINm5ZcGcC8uT6fwh7nJXb7/WbacH8DUwYcCgJlkL0ic+n
        HDvh4yK29euZC25xqJEdVwhypw==
X-Google-Smtp-Source: ABdhPJyoZJy6blLl3T2WySHgvwCoum/9BqxhVlvyXI8jHgMWOHlTltNkEMVa9oTDfZmqSlYq9tLK5Q==
X-Received: by 2002:a17:902:7608:b029:d0:cbe1:e70e with SMTP id k8-20020a1709027608b02900d0cbe1e70emr8145245pll.28.1601228565811;
        Sun, 27 Sep 2020 10:42:45 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o19sm8765570pfp.64.2020.09.27.10.42.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Sep 2020 10:42:44 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 01/11] bnxt_en: Update firmware interface spec to 1.10.1.65.
Date:   Sun, 27 Sep 2020 13:42:10 -0400
Message-Id: <1601228540-20852-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
References: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e8669805b04f13c0"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e8669805b04f13c0

The main changes include FEC, ECN statistics, HWRM_PORT_PHY_QCFG
response size reduction, and a new counter added to
ctx_hw_stats_ext struct to support the new 58818 chip.

The ctx_hw_stats_ext structure is now the superset supporting the new
58818 chips and the prior P5 chips.  Add a new flag to identify the new
chip and use constants for the chip specific ring statistics sizes
instead of the size of the structure.

Because the HWRM_PORT_PHY_QCFG response structure size has shrunk back
to 96 bytes, the workaround added earlier to limit the size of this
message for forwarding to the VF can be removed.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  16 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  71 ++--
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 375 +++++++++++++++---
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   2 +-
 5 files changed, 361 insertions(+), 113 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 65c298f1f333..b57f28d2e716 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5343,13 +5343,16 @@ static int bnxt_hwrm_vnic_qcaps(struct bnxt *bp)
 		 * VLAN_STRIP_CAP properly.
 		 */
 		if ((flags & VNIC_QCAPS_RESP_FLAGS_VLAN_STRIP_CAP) ||
-		    ((bp->flags & BNXT_FLAG_CHIP_P5) &&
+		    (BNXT_CHIP_P5_THOR(bp) &&
 		     !(bp->fw_cap & BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED)))
 			bp->fw_cap |= BNXT_FW_CAP_VLAN_RX_STRIP;
 		bp->max_tpa_v2 = le16_to_cpu(resp->max_aggs_supported);
-		if (bp->max_tpa_v2)
-			bp->hw_ring_stats_size =
-				sizeof(struct ctx_hw_stats_ext);
+		if (bp->max_tpa_v2) {
+			if (BNXT_CHIP_P5_THOR(bp))
+				bp->hw_ring_stats_size = BNXT_RING_STATS_SIZE_P5;
+			else
+				bp->hw_ring_stats_size = BNXT_RING_STATS_SIZE_P5_SR2;
+		}
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
@@ -12233,8 +12236,11 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		goto init_err_pci_clean;
 
-	if (BNXT_CHIP_P5(bp))
+	if (BNXT_CHIP_P5(bp)) {
 		bp->flags |= BNXT_FLAG_CHIP_P5;
+		if (BNXT_CHIP_SR2(bp))
+			bp->flags |= BNXT_FLAG_CHIP_SR2;
+	}
 
 	rc = bnxt_alloc_rss_indir_tbl(bp);
 	if (rc)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 0ef89dabfd61..21f2b82287a9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1142,50 +1142,6 @@ struct bnxt_ntuple_filter {
 #define BNXT_FLTR_UPDATE	1
 };
 
-struct hwrm_port_phy_qcfg_output_compat {
-	__le16	error_code;
-	__le16	req_type;
-	__le16	seq_id;
-	__le16	resp_len;
-	u8	link;
-	u8	link_signal_mode;
-	__le16	link_speed;
-	u8	duplex_cfg;
-	u8	pause;
-	__le16	support_speeds;
-	__le16	force_link_speed;
-	u8	auto_mode;
-	u8	auto_pause;
-	__le16	auto_link_speed;
-	__le16	auto_link_speed_mask;
-	u8	wirespeed;
-	u8	lpbk;
-	u8	force_pause;
-	u8	module_status;
-	__le32	preemphasis;
-	u8	phy_maj;
-	u8	phy_min;
-	u8	phy_bld;
-	u8	phy_type;
-	u8	media_type;
-	u8	xcvr_pkg_type;
-	u8	eee_config_phy_addr;
-	u8	parallel_detect;
-	__le16	link_partner_adv_speeds;
-	u8	link_partner_adv_auto_mode;
-	u8	link_partner_adv_pause;
-	__le16	adv_eee_link_speed_mask;
-	__le16	link_partner_adv_eee_link_speed_mask;
-	__le32	xcvr_identifier_type_tx_lpi_timer;
-	__le16	fec_cfg;
-	u8	duplex_state;
-	u8	option_flags;
-	char	phy_vendor_name[16];
-	char	phy_vendor_partnumber[16];
-	u8	unused_0[7];
-	u8	valid;
-};
-
 struct bnxt_link_info {
 	u8			phy_type;
 	u8			media_type;
@@ -1535,6 +1491,8 @@ struct bnxt {
 
 	u8			chip_rev;
 
+#define CHIP_NUM_58818		0xd818
+
 #define BNXT_CHIP_NUM_5730X(chip_num)		\
 	((chip_num) >= CHIP_NUM_57301 &&	\
 	 (chip_num) <= CHIP_NUM_57304)
@@ -1613,6 +1571,7 @@ struct bnxt {
 					 BNXT_FLAG_ROCEV2_CAP)
 	#define BNXT_FLAG_NO_AGG_RINGS	0x20000
 	#define BNXT_FLAG_RX_PAGE_MODE	0x40000
+	#define BNXT_FLAG_CHIP_SR2	0x80000
 	#define BNXT_FLAG_MULTI_HOST	0x100000
 	#define BNXT_FLAG_DSN_VALID	0x200000
 	#define BNXT_FLAG_DOUBLE_DB	0x400000
@@ -1638,12 +1597,18 @@ struct bnxt {
 				 (!((bp)->flags & BNXT_FLAG_CHIP_P5) ||	\
 				  (bp)->max_tpa_v2) && !is_kdump_kernel())
 
-/* Chip class phase 5 */
-#define BNXT_CHIP_P5(bp)			\
+#define BNXT_CHIP_SR2(bp)			\
+	((bp)->chip_num == CHIP_NUM_58818)
+
+#define BNXT_CHIP_P5_THOR(bp)			\
 	((bp)->chip_num == CHIP_NUM_57508 ||	\
 	 (bp)->chip_num == CHIP_NUM_57504 ||	\
 	 (bp)->chip_num == CHIP_NUM_57502)
 
+/* Chip class phase 5 */
+#define BNXT_CHIP_P5(bp)			\
+	(BNXT_CHIP_P5_THOR(bp) || BNXT_CHIP_SR2(bp))
+
 /* Chip class phase 4.x */
 #define BNXT_CHIP_P4(bp)			\
 	(BNXT_CHIP_NUM_57X1X((bp)->chip_num) ||	\
@@ -1935,6 +1900,20 @@ struct bnxt {
 	struct device		*hwmon_dev;
 };
 
+#define BNXT_NUM_RX_RING_STATS			8
+#define BNXT_NUM_TX_RING_STATS			8
+#define BNXT_NUM_TPA_RING_STATS			4
+#define BNXT_NUM_TPA_RING_STATS_P5		5
+#define BNXT_NUM_TPA_RING_STATS_P5_SR2		6
+
+#define BNXT_RING_STATS_SIZE_P5					\
+	((BNXT_NUM_RX_RING_STATS + BNXT_NUM_TX_RING_STATS +	\
+	  BNXT_NUM_TPA_RING_STATS_P5) * 8)
+
+#define BNXT_RING_STATS_SIZE_P5_SR2				\
+	((BNXT_NUM_RX_RING_STATS + BNXT_NUM_TX_RING_STATS +	\
+	  BNXT_NUM_TPA_RING_STATS_P5_SR2) * 8)
+
 #define BNXT_GET_RING_STATS64(sw, counter)		\
 	(*((sw) + offsetof(struct ctx_hw_stats, counter) / 8))
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 6a3453f46d9a..9703ff48f2ab 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -172,6 +172,7 @@ static const char * const bnxt_ring_tpa2_stats_str[] = {
 	"rx_tpa_pkt",
 	"rx_tpa_bytes",
 	"rx_tpa_errors",
+	"rx_tpa_events",
 };
 
 static const char * const bnxt_rx_sw_stats_str[] = {
@@ -462,9 +463,12 @@ static const struct {
 static int bnxt_get_num_tpa_ring_stats(struct bnxt *bp)
 {
 	if (BNXT_SUPPORTS_TPA(bp)) {
-		if (bp->max_tpa_v2)
-			return ARRAY_SIZE(bnxt_ring_tpa2_stats_str);
-		return ARRAY_SIZE(bnxt_ring_tpa_stats_str);
+		if (bp->max_tpa_v2) {
+			if (BNXT_CHIP_P5_THOR(bp))
+				return BNXT_NUM_TPA_RING_STATS_P5;
+			return BNXT_NUM_TPA_RING_STATS_P5_SR2;
+		}
+		return BNXT_NUM_TPA_RING_STATS;
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index c4af6bf15e36..303713aa03b0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -213,7 +213,10 @@ struct cmd_nums {
 	#define HWRM_PORT_PHY_MDIO_BUS_ACQUIRE            0xb7UL
 	#define HWRM_PORT_PHY_MDIO_BUS_RELEASE            0xb8UL
 	#define HWRM_PORT_QSTATS_EXT_PFC_WD               0xb9UL
-	#define HWRM_PORT_ECN_QSTATS                      0xbaUL
+	#define HWRM_RESERVED7                            0xbaUL
+	#define HWRM_PORT_TX_FIR_CFG                      0xbbUL
+	#define HWRM_PORT_TX_FIR_QCFG                     0xbcUL
+	#define HWRM_PORT_ECN_QSTATS                      0xbdUL
 	#define HWRM_FW_RESET                             0xc0UL
 	#define HWRM_FW_QSTATUS                           0xc1UL
 	#define HWRM_FW_HEALTH_CHECK                      0xc2UL
@@ -370,6 +373,8 @@ struct cmd_nums {
 	#define HWRM_TF_SESSION_RESC_FLUSH                0x2cfUL
 	#define HWRM_TF_TBL_TYPE_GET                      0x2daUL
 	#define HWRM_TF_TBL_TYPE_SET                      0x2dbUL
+	#define HWRM_TF_CTXT_MEM_ALLOC                    0x2e2UL
+	#define HWRM_TF_CTXT_MEM_FREE                     0x2e3UL
 	#define HWRM_TF_CTXT_MEM_RGTR                     0x2e4UL
 	#define HWRM_TF_CTXT_MEM_UNRGTR                   0x2e5UL
 	#define HWRM_TF_EXT_EM_QCAPS                      0x2e6UL
@@ -384,6 +389,8 @@ struct cmd_nums {
 	#define HWRM_TF_TCAM_FREE                         0x2fbUL
 	#define HWRM_TF_GLOBAL_CFG_SET                    0x2fcUL
 	#define HWRM_TF_GLOBAL_CFG_GET                    0x2fdUL
+	#define HWRM_TF_IF_TBL_SET                        0x2feUL
+	#define HWRM_TF_IF_TBL_GET                        0x2ffUL
 	#define HWRM_SV                                   0x400UL
 	#define HWRM_DBG_READ_DIRECT                      0xff10UL
 	#define HWRM_DBG_READ_INDIRECT                    0xff11UL
@@ -447,6 +454,7 @@ struct ret_codes {
 	#define HWRM_ERR_CODE_KEY_ALREADY_EXISTS           0xeUL
 	#define HWRM_ERR_CODE_HWRM_ERROR                   0xfUL
 	#define HWRM_ERR_CODE_BUSY                         0x10UL
+	#define HWRM_ERR_CODE_RESOURCE_LOCKED              0x11UL
 	#define HWRM_ERR_CODE_TLV_ENCAPSULATED_RESPONSE    0x8000UL
 	#define HWRM_ERR_CODE_UNKNOWN_ERR                  0xfffeUL
 	#define HWRM_ERR_CODE_CMD_NOT_SUPPORTED            0xffffUL
@@ -478,8 +486,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 1
-#define HWRM_VERSION_RSVD 54
-#define HWRM_VERSION_STR "1.10.1.54"
+#define HWRM_VERSION_RSVD 65
+#define HWRM_VERSION_STR "1.10.1.65"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -675,6 +683,7 @@ struct hwrm_async_event_cmpl {
 	#define ASYNC_EVENT_CMPL_EVENT_ID_PORT_PHY_CFG_CHANGE        0x7UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY               0x8UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY             0x9UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG           0xaUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FUNC_DRVR_UNLOAD           0x10UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FUNC_DRVR_LOAD             0x11UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FUNC_FLR_PROC_CMPLT        0x12UL
@@ -851,6 +860,32 @@ struct hwrm_async_event_cmpl_error_recovery {
 	#define ASYNC_EVENT_CMPL_ERROR_RECOVERY_EVENT_DATA1_FLAGS_RECOVERY_ENABLED      0x2UL
 };
 
+/* hwrm_async_event_cmpl_ring_monitor_msg (size:128b/16B) */
+struct hwrm_async_event_cmpl_ring_monitor_msg {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_TYPE_LAST             ASYNC_EVENT_CMPL_RING_MONITOR_MSG_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_ID_RING_MONITOR_MSG 0xaUL
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_ID_LAST            ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_ID_RING_MONITOR_MSG
+	__le32	event_data2;
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_DATA2_DISABLE_RING_TYPE_MASK 0xffUL
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_DATA2_DISABLE_RING_TYPE_SFT 0
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_DATA2_DISABLE_RING_TYPE_TX    0x0UL
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_DATA2_DISABLE_RING_TYPE_RX    0x1UL
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_DATA2_DISABLE_RING_TYPE_CMPL  0x2UL
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_DATA2_DISABLE_RING_TYPE_LAST ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_DATA2_DISABLE_RING_TYPE_CMPL
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_V          0x1UL
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_RING_MONITOR_MSG_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+};
+
 /* hwrm_async_event_cmpl_vf_cfg_change (size:128b/16B) */
 struct hwrm_async_event_cmpl_vf_cfg_change {
 	__le16	type;
@@ -975,6 +1010,28 @@ struct hwrm_async_event_cmpl_eem_cache_flush_done {
 	#define ASYNC_EVENT_CMPL_EEM_CACHE_FLUSH_DONE_EVENT_DATA1_FID_SFT 0
 };
 
+/* hwrm_async_event_cmpl_deferred_response (size:128b/16B) */
+struct hwrm_async_event_cmpl_deferred_response {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_TYPE_LAST             ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_EVENT_ID_DEFERRED_RESPONSE 0x40UL
+	#define ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_EVENT_ID_LAST             ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_EVENT_ID_DEFERRED_RESPONSE
+	__le32	event_data2;
+	#define ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_EVENT_DATA2_SEQ_ID_MASK 0xffffUL
+	#define ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_EVENT_DATA2_SEQ_ID_SFT 0
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_V          0x1UL
+	#define ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_DEFERRED_RESPONSE_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+};
+
 /* hwrm_func_reset_input (size:192b/24B) */
 struct hwrm_func_reset_input {
 	__le16	req_type;
@@ -1214,7 +1271,13 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_SCHQ_SUPPORTED                         0x40UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_PPP_PUSH_MODE_SUPPORTED                0x80UL
 	u8	max_schqs;
-	u8	unused_1[2];
+	u8	mpc_chnls_cap;
+	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_TCE         0x1UL
+	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_RCE         0x2UL
+	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_TE_CFA      0x4UL
+	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_RE_CFA      0x8UL
+	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_PRIMATE     0x10UL
+	u8	unused_1;
 	u8	valid;
 };
 
@@ -1250,6 +1313,7 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_FLAGS_PREBOOT_LEGACY_L2_RINGS      0x100UL
 	#define FUNC_QCFG_RESP_FLAGS_HOT_RESET_ALLOWED            0x200UL
 	#define FUNC_QCFG_RESP_FLAGS_PPP_PUSH_MODE_ENABLED        0x400UL
+	#define FUNC_QCFG_RESP_FLAGS_RING_MONITOR_ENABLED         0x800UL
 	u8	mac_address[6];
 	__le16	pci_id;
 	__le16	alloc_rsscos_ctx;
@@ -1341,7 +1405,13 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_SVIF_INFO_SVIF_MASK      0x7fffUL
 	#define FUNC_QCFG_RESP_SVIF_INFO_SVIF_SFT       0
 	#define FUNC_QCFG_RESP_SVIF_INFO_SVIF_VALID     0x8000UL
-	u8	unused_2[7];
+	u8	mpc_chnls;
+	#define FUNC_QCFG_RESP_MPC_CHNLS_TCE_ENABLED         0x1UL
+	#define FUNC_QCFG_RESP_MPC_CHNLS_RCE_ENABLED         0x2UL
+	#define FUNC_QCFG_RESP_MPC_CHNLS_TE_CFA_ENABLED      0x4UL
+	#define FUNC_QCFG_RESP_MPC_CHNLS_RE_CFA_ENABLED      0x8UL
+	#define FUNC_QCFG_RESP_MPC_CHNLS_PRIMATE_ENABLED     0x10UL
+	u8	unused_2[6];
 	u8	valid;
 };
 
@@ -1405,6 +1475,7 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_ENABLES_ADMIN_LINK_STATE         0x400000UL
 	#define FUNC_CFG_REQ_ENABLES_HOT_RESET_IF_SUPPORT     0x800000UL
 	#define FUNC_CFG_REQ_ENABLES_SCHQ_ID                  0x1000000UL
+	#define FUNC_CFG_REQ_ENABLES_MPC_CHNLS                0x2000000UL
 	__le16	mtu;
 	__le16	mru;
 	__le16	num_rsscos_ctxs;
@@ -1479,7 +1550,18 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_OPTIONS_RSVD_SFT                    4
 	__le16	num_mcast_filters;
 	__le16	schq_id;
-	u8	unused_0[6];
+	__le16	mpc_chnls;
+	#define FUNC_CFG_REQ_MPC_CHNLS_TCE_ENABLE          0x1UL
+	#define FUNC_CFG_REQ_MPC_CHNLS_TCE_DISABLE         0x2UL
+	#define FUNC_CFG_REQ_MPC_CHNLS_RCE_ENABLE          0x4UL
+	#define FUNC_CFG_REQ_MPC_CHNLS_RCE_DISABLE         0x8UL
+	#define FUNC_CFG_REQ_MPC_CHNLS_TE_CFA_ENABLE       0x10UL
+	#define FUNC_CFG_REQ_MPC_CHNLS_TE_CFA_DISABLE      0x20UL
+	#define FUNC_CFG_REQ_MPC_CHNLS_RE_CFA_ENABLE       0x40UL
+	#define FUNC_CFG_REQ_MPC_CHNLS_RE_CFA_DISABLE      0x80UL
+	#define FUNC_CFG_REQ_MPC_CHNLS_PRIMATE_ENABLE      0x100UL
+	#define FUNC_CFG_REQ_MPC_CHNLS_PRIMATE_DISABLE     0x200UL
+	u8	unused_0[4];
 };
 
 /* hwrm_func_cfg_output (size:128b/16B) */
@@ -1559,7 +1641,7 @@ struct hwrm_func_qstats_ext_input {
 	u8	unused_1[4];
 };
 
-/* hwrm_func_qstats_ext_output (size:1472b/184B) */
+/* hwrm_func_qstats_ext_output (size:1536b/192B) */
 struct hwrm_func_qstats_ext_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -1586,6 +1668,7 @@ struct hwrm_func_qstats_ext_output {
 	__le64	rx_tpa_pkt;
 	__le64	rx_tpa_bytes;
 	__le64	rx_tpa_errors;
+	__le64	rx_tpa_events;
 	u8	unused_0[7];
 	u8	valid;
 };
@@ -2412,25 +2495,29 @@ struct hwrm_port_phy_cfg_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le32	flags;
-	#define PORT_PHY_CFG_REQ_FLAGS_RESET_PHY                 0x1UL
-	#define PORT_PHY_CFG_REQ_FLAGS_DEPRECATED                0x2UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FORCE                     0x4UL
-	#define PORT_PHY_CFG_REQ_FLAGS_RESTART_AUTONEG           0x8UL
-	#define PORT_PHY_CFG_REQ_FLAGS_EEE_ENABLE                0x10UL
-	#define PORT_PHY_CFG_REQ_FLAGS_EEE_DISABLE               0x20UL
-	#define PORT_PHY_CFG_REQ_FLAGS_EEE_TX_LPI_ENABLE         0x40UL
-	#define PORT_PHY_CFG_REQ_FLAGS_EEE_TX_LPI_DISABLE        0x80UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_AUTONEG_ENABLE        0x100UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_AUTONEG_DISABLE       0x200UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_ENABLE       0x400UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_DISABLE      0x800UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE91_ENABLE       0x1000UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE91_DISABLE      0x2000UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FORCE_LINK_DWN            0x4000UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_1XN_ENABLE      0x8000UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_1XN_DISABLE     0x10000UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_2XN_ENABLE      0x20000UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_2XN_DISABLE     0x40000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_RESET_PHY                  0x1UL
+	#define PORT_PHY_CFG_REQ_FLAGS_DEPRECATED                 0x2UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FORCE                      0x4UL
+	#define PORT_PHY_CFG_REQ_FLAGS_RESTART_AUTONEG            0x8UL
+	#define PORT_PHY_CFG_REQ_FLAGS_EEE_ENABLE                 0x10UL
+	#define PORT_PHY_CFG_REQ_FLAGS_EEE_DISABLE                0x20UL
+	#define PORT_PHY_CFG_REQ_FLAGS_EEE_TX_LPI_ENABLE          0x40UL
+	#define PORT_PHY_CFG_REQ_FLAGS_EEE_TX_LPI_DISABLE         0x80UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_AUTONEG_ENABLE         0x100UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_AUTONEG_DISABLE        0x200UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_ENABLE        0x400UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_DISABLE       0x800UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE91_ENABLE        0x1000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE91_DISABLE       0x2000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FORCE_LINK_DWN             0x4000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_1XN_ENABLE       0x8000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_1XN_DISABLE      0x10000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_IEEE_ENABLE      0x20000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_IEEE_DISABLE     0x40000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS272_1XN_ENABLE       0x80000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS272_1XN_DISABLE      0x100000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS272_IEEE_ENABLE      0x200000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS272_IEEE_DISABLE     0x400000UL
 	__le32	enables;
 	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_MODE                     0x1UL
 	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_DUPLEX                   0x2UL
@@ -2573,7 +2660,7 @@ struct hwrm_port_phy_qcfg_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_port_phy_qcfg_output (size:832b/104B) */
+/* hwrm_port_phy_qcfg_output (size:768b/96B) */
 struct hwrm_port_phy_qcfg_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -2584,10 +2671,22 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_LINK_SIGNAL  0x1UL
 	#define PORT_PHY_QCFG_RESP_LINK_LINK    0x2UL
 	#define PORT_PHY_QCFG_RESP_LINK_LAST   PORT_PHY_QCFG_RESP_LINK_LINK
-	u8	link_signal_mode;
-	#define PORT_PHY_QCFG_RESP_LINK_SIGNAL_MODE_NRZ  0x0UL
-	#define PORT_PHY_QCFG_RESP_LINK_SIGNAL_MODE_PAM4 0x1UL
-	#define PORT_PHY_QCFG_RESP_LINK_SIGNAL_MODE_LAST PORT_PHY_QCFG_RESP_LINK_SIGNAL_MODE_PAM4
+	u8	active_fec_signal_mode;
+	#define PORT_PHY_QCFG_RESP_SIGNAL_MODE_MASK                0xfUL
+	#define PORT_PHY_QCFG_RESP_SIGNAL_MODE_SFT                 0
+	#define PORT_PHY_QCFG_RESP_SIGNAL_MODE_NRZ                   0x0UL
+	#define PORT_PHY_QCFG_RESP_SIGNAL_MODE_PAM4                  0x1UL
+	#define PORT_PHY_QCFG_RESP_SIGNAL_MODE_LAST                 PORT_PHY_QCFG_RESP_SIGNAL_MODE_PAM4
+	#define PORT_PHY_QCFG_RESP_ACTIVE_FEC_MASK                 0xf0UL
+	#define PORT_PHY_QCFG_RESP_ACTIVE_FEC_SFT                  4
+	#define PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_NONE_ACTIVE        (0x0UL << 4)
+	#define PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_CLAUSE74_ACTIVE    (0x1UL << 4)
+	#define PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_CLAUSE91_ACTIVE    (0x2UL << 4)
+	#define PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS544_1XN_ACTIVE   (0x3UL << 4)
+	#define PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS544_IEEE_ACTIVE  (0x4UL << 4)
+	#define PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS272_1XN_ACTIVE   (0x5UL << 4)
+	#define PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS272_IEEE_ACTIVE  (0x6UL << 4)
+	#define PORT_PHY_QCFG_RESP_ACTIVE_FEC_LAST                  PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS272_IEEE_ACTIVE
 	__le16	link_speed;
 	#define PORT_PHY_QCFG_RESP_LINK_SPEED_100MB 0x1UL
 	#define PORT_PHY_QCFG_RESP_LINK_SPEED_1GB   0xaUL
@@ -2809,21 +2908,21 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_XCVR_IDENTIFIER_TYPE_QSFP28    (0x11UL << 24)
 	#define PORT_PHY_QCFG_RESP_XCVR_IDENTIFIER_TYPE_LAST     PORT_PHY_QCFG_RESP_XCVR_IDENTIFIER_TYPE_QSFP28
 	__le16	fec_cfg;
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_NONE_SUPPORTED          0x1UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_AUTONEG_SUPPORTED       0x2UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_AUTONEG_ENABLED         0x4UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_SUPPORTED      0x8UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_ENABLED        0x10UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_SUPPORTED      0x20UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_ENABLED        0x40UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_1XN_SUPPORTED     0x80UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_1XN_ENABLED       0x100UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_2XN_SUPPORTED     0x200UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_2XN_ENABLED       0x400UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_ACTIVE         0x800UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_ACTIVE         0x1000UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_1XN_ACTIVE        0x2000UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_2XN_ACTIVE        0x4000UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_NONE_SUPPORTED           0x1UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_AUTONEG_SUPPORTED        0x2UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_AUTONEG_ENABLED          0x4UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_SUPPORTED       0x8UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_ENABLED         0x10UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_SUPPORTED       0x20UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_ENABLED         0x40UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_1XN_SUPPORTED      0x80UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_1XN_ENABLED        0x100UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_IEEE_SUPPORTED     0x200UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_IEEE_ENABLED       0x400UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS272_1XN_SUPPORTED      0x800UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS272_1XN_ENABLED        0x1000UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS272_IEEE_SUPPORTED     0x2000UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS272_IEEE_ENABLED       0x4000UL
 	u8	duplex_state;
 	#define PORT_PHY_QCFG_RESP_DUPLEX_STATE_HALF 0x0UL
 	#define PORT_PHY_QCFG_RESP_DUPLEX_STATE_FULL 0x1UL
@@ -2845,11 +2944,10 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_AUTO_PAM4_LINK_SPEED_MASK_50G      0x1UL
 	#define PORT_PHY_QCFG_RESP_AUTO_PAM4_LINK_SPEED_MASK_100G     0x2UL
 	#define PORT_PHY_QCFG_RESP_AUTO_PAM4_LINK_SPEED_MASK_200G     0x4UL
-	__le16	link_partner_pam4_adv_speeds;
+	u8	link_partner_pam4_adv_speeds;
 	#define PORT_PHY_QCFG_RESP_LINK_PARTNER_PAM4_ADV_SPEEDS_50GB      0x1UL
 	#define PORT_PHY_QCFG_RESP_LINK_PARTNER_PAM4_ADV_SPEEDS_100GB     0x2UL
 	#define PORT_PHY_QCFG_RESP_LINK_PARTNER_PAM4_ADV_SPEEDS_200GB     0x4UL
-	u8	unused_0[7];
 	u8	valid;
 };
 
@@ -3293,6 +3391,47 @@ struct hwrm_port_lpbk_qstats_output {
 	u8	valid;
 };
 
+/* hwrm_port_ecn_qstats_input (size:256b/32B) */
+struct hwrm_port_ecn_qstats_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	port_id;
+	__le16	ecn_stat_buf_size;
+	u8	flags;
+	#define PORT_ECN_QSTATS_REQ_FLAGS_UNUSED       0x0UL
+	#define PORT_ECN_QSTATS_REQ_FLAGS_COUNTER_MASK 0x1UL
+	#define PORT_ECN_QSTATS_REQ_FLAGS_LAST        PORT_ECN_QSTATS_REQ_FLAGS_COUNTER_MASK
+	u8	unused_0[3];
+	__le64	ecn_stat_host_addr;
+};
+
+/* hwrm_port_ecn_qstats_output (size:128b/16B) */
+struct hwrm_port_ecn_qstats_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le16	ecn_stat_buf_size;
+	u8	mark_en;
+	u8	unused_0[4];
+	u8	valid;
+};
+
+/* port_stats_ecn (size:512b/64B) */
+struct port_stats_ecn {
+	__le64	mark_cnt_cos0;
+	__le64	mark_cnt_cos1;
+	__le64	mark_cnt_cos2;
+	__le64	mark_cnt_cos3;
+	__le64	mark_cnt_cos4;
+	__le64	mark_cnt_cos5;
+	__le64	mark_cnt_cos6;
+	__le64	mark_cnt_cos7;
+};
+
 /* hwrm_port_clr_stats_input (size:192b/24B) */
 struct hwrm_port_clr_stats_input {
 	__le16	req_type;
@@ -3387,8 +3526,9 @@ struct hwrm_port_phy_qcaps_output {
 	#define PORT_PHY_QCAPS_RESP_FLAGS_AUTONEG_LPBK_SUPPORTED           0x4UL
 	#define PORT_PHY_QCAPS_RESP_FLAGS_SHARED_PHY_CFG_SUPPORTED         0x8UL
 	#define PORT_PHY_QCAPS_RESP_FLAGS_CUMULATIVE_COUNTERS_ON_RESET     0x10UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_MASK                       0xe0UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_SFT                        5
+	#define PORT_PHY_QCAPS_RESP_FLAGS_LOCAL_LPBK_NOT_SUPPORTED         0x20UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_MASK                       0xc0UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_SFT                        6
 	u8	port_cnt;
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_UNKNOWN 0x0UL
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_1       0x1UL
@@ -5365,6 +5505,7 @@ struct hwrm_ring_alloc_input {
 	#define RING_ALLOC_REQ_ENABLES_NQ_RING_ID_VALID      0x80UL
 	#define RING_ALLOC_REQ_ENABLES_RX_BUF_SIZE_VALID     0x100UL
 	#define RING_ALLOC_REQ_ENABLES_SCHQ_ID               0x200UL
+	#define RING_ALLOC_REQ_ENABLES_MPC_CHNLS_TYPE        0x400UL
 	u8	ring_type;
 	#define RING_ALLOC_REQ_RING_TYPE_L2_CMPL   0x0UL
 	#define RING_ALLOC_REQ_RING_TYPE_TX        0x1UL
@@ -5424,7 +5565,14 @@ struct hwrm_ring_alloc_input {
 	#define RING_ALLOC_REQ_INT_MODE_MSIX   0x2UL
 	#define RING_ALLOC_REQ_INT_MODE_POLL   0x3UL
 	#define RING_ALLOC_REQ_INT_MODE_LAST  RING_ALLOC_REQ_INT_MODE_POLL
-	u8	unused_4[3];
+	u8	mpc_chnls_type;
+	#define RING_ALLOC_REQ_MPC_CHNLS_TYPE_TCE     0x0UL
+	#define RING_ALLOC_REQ_MPC_CHNLS_TYPE_RCE     0x1UL
+	#define RING_ALLOC_REQ_MPC_CHNLS_TYPE_TE_CFA  0x2UL
+	#define RING_ALLOC_REQ_MPC_CHNLS_TYPE_RE_CFA  0x3UL
+	#define RING_ALLOC_REQ_MPC_CHNLS_TYPE_PRIMATE 0x4UL
+	#define RING_ALLOC_REQ_MPC_CHNLS_TYPE_LAST   RING_ALLOC_REQ_MPC_CHNLS_TYPE_PRIMATE
+	u8	unused_4[2];
 	__le64	cq_handle;
 };
 
@@ -6661,7 +6809,7 @@ struct hwrm_cfa_vfr_alloc_output {
 	u8	valid;
 };
 
-/* hwrm_cfa_vfr_free_input (size:384b/48B) */
+/* hwrm_cfa_vfr_free_input (size:448b/56B) */
 struct hwrm_cfa_vfr_free_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -6669,6 +6817,9 @@ struct hwrm_cfa_vfr_free_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	char	vfr_name[32];
+	__le16	vf_id;
+	__le16	reserved;
+	u8	unused_0[4];
 };
 
 /* hwrm_cfa_vfr_free_output (size:128b/16B) */
@@ -6970,7 +7121,7 @@ struct ctx_hw_stats {
 	__le64	tpa_aborts;
 };
 
-/* ctx_hw_stats_ext (size:1344b/168B) */
+/* ctx_hw_stats_ext (size:1408b/176B) */
 struct ctx_hw_stats_ext {
 	__le64	rx_ucast_pkts;
 	__le64	rx_mcast_pkts;
@@ -6993,6 +7144,7 @@ struct ctx_hw_stats_ext {
 	__le64	rx_tpa_pkt;
 	__le64	rx_tpa_bytes;
 	__le64	rx_tpa_errors;
+	__le64	rx_tpa_events;
 };
 
 /* hwrm_stat_ctx_alloc_input (size:256b/32B) */
@@ -7065,16 +7217,16 @@ struct hwrm_stat_ctx_query_output {
 	__le64	tx_ucast_pkts;
 	__le64	tx_mcast_pkts;
 	__le64	tx_bcast_pkts;
-	__le64	tx_err_pkts;
-	__le64	tx_drop_pkts;
+	__le64	tx_discard_pkts;
+	__le64	tx_error_pkts;
 	__le64	tx_ucast_bytes;
 	__le64	tx_mcast_bytes;
 	__le64	tx_bcast_bytes;
 	__le64	rx_ucast_pkts;
 	__le64	rx_mcast_pkts;
 	__le64	rx_bcast_pkts;
-	__le64	rx_err_pkts;
-	__le64	rx_drop_pkts;
+	__le64	rx_discard_pkts;
+	__le64	rx_error_pkts;
 	__le64	rx_ucast_bytes;
 	__le64	rx_mcast_bytes;
 	__le64	rx_bcast_bytes;
@@ -7099,7 +7251,7 @@ struct hwrm_stat_ext_ctx_query_input {
 	u8	unused_0[3];
 };
 
-/* hwrm_stat_ext_ctx_query_output (size:1472b/184B) */
+/* hwrm_stat_ext_ctx_query_output (size:1536b/192B) */
 struct hwrm_stat_ext_ctx_query_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -7126,6 +7278,7 @@ struct hwrm_stat_ext_ctx_query_output {
 	__le64	rx_tpa_pkt;
 	__le64	rx_tpa_bytes;
 	__le64	rx_tpa_errors;
+	__le64	rx_tpa_events;
 	u8	unused_0[7];
 	u8	valid;
 };
@@ -7702,6 +7855,77 @@ struct hwrm_dbg_read_direct_output {
 	u8	valid;
 };
 
+/* hwrm_dbg_qcaps_input (size:192b/24B) */
+struct hwrm_dbg_qcaps_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	fid;
+	u8	unused_0[6];
+};
+
+/* hwrm_dbg_qcaps_output (size:192b/24B) */
+struct hwrm_dbg_qcaps_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le16	fid;
+	u8	unused_0[2];
+	__le32	coredump_component_disable_caps;
+	#define DBG_QCAPS_RESP_COREDUMP_COMPONENT_DISABLE_CAPS_NVRAM     0x1UL
+	__le32	flags;
+	#define DBG_QCAPS_RESP_FLAGS_CRASHDUMP_NVM          0x1UL
+	#define DBG_QCAPS_RESP_FLAGS_CRASHDUMP_HOST_DDR     0x2UL
+	#define DBG_QCAPS_RESP_FLAGS_CRASHDUMP_SOC_DDR      0x4UL
+	u8	unused_1[3];
+	u8	valid;
+};
+
+/* hwrm_dbg_qcfg_input (size:192b/24B) */
+struct hwrm_dbg_qcfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	fid;
+	__le16	flags;
+	#define DBG_QCFG_REQ_FLAGS_CRASHDUMP_SIZE_FOR_DEST_MASK         0x3UL
+	#define DBG_QCFG_REQ_FLAGS_CRASHDUMP_SIZE_FOR_DEST_SFT          0
+	#define DBG_QCFG_REQ_FLAGS_CRASHDUMP_SIZE_FOR_DEST_DEST_NVM       0x0UL
+	#define DBG_QCFG_REQ_FLAGS_CRASHDUMP_SIZE_FOR_DEST_DEST_HOST_DDR  0x1UL
+	#define DBG_QCFG_REQ_FLAGS_CRASHDUMP_SIZE_FOR_DEST_DEST_SOC_DDR   0x2UL
+	#define DBG_QCFG_REQ_FLAGS_CRASHDUMP_SIZE_FOR_DEST_LAST          DBG_QCFG_REQ_FLAGS_CRASHDUMP_SIZE_FOR_DEST_DEST_SOC_DDR
+	__le32	coredump_component_disable_flags;
+	#define DBG_QCFG_REQ_COREDUMP_COMPONENT_DISABLE_FLAGS_NVRAM     0x1UL
+};
+
+/* hwrm_dbg_qcfg_output (size:256b/32B) */
+struct hwrm_dbg_qcfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le16	fid;
+	u8	unused_0[2];
+	__le32	coredump_size;
+	__le32	flags;
+	#define DBG_QCFG_RESP_FLAGS_UART_LOG               0x1UL
+	#define DBG_QCFG_RESP_FLAGS_UART_LOG_SECONDARY     0x2UL
+	#define DBG_QCFG_RESP_FLAGS_FW_TRACE               0x4UL
+	#define DBG_QCFG_RESP_FLAGS_FW_TRACE_SECONDARY     0x8UL
+	#define DBG_QCFG_RESP_FLAGS_DEBUG_NOTIFY           0x10UL
+	#define DBG_QCFG_RESP_FLAGS_JTAG_DEBUG             0x20UL
+	__le16	async_cmpl_ring;
+	u8	unused_2[2];
+	__le32	crashdump_size;
+	u8	unused_3[3];
+	u8	valid;
+};
+
 /* coredump_segment_record (size:128b/16B) */
 struct coredump_segment_record {
 	__le16	component_id;
@@ -8381,6 +8605,16 @@ struct hwrm_selftest_irq_output {
 	u8	valid;
 };
 
+/* db_push_info (size:64b/8B) */
+struct db_push_info {
+	u32	push_size_push_index;
+	#define DB_PUSH_INFO_PUSH_INDEX_MASK 0xffffffUL
+	#define DB_PUSH_INFO_PUSH_INDEX_SFT 0
+	#define DB_PUSH_INFO_PUSH_SIZE_MASK 0x1f000000UL
+	#define DB_PUSH_INFO_PUSH_SIZE_SFT  24
+	u32	reserved32;
+};
+
 /* fw_status_reg (size:32b/4B) */
 struct fw_status_reg {
 	u32	fw_status;
@@ -8395,4 +8629,29 @@ struct fw_status_reg {
 	#define FW_STATUS_REG_SHUTDOWN               0x100000UL
 };
 
+/* hcomm_status (size:64b/8B) */
+struct hcomm_status {
+	u32	sig_ver;
+	#define HCOMM_STATUS_VER_MASK      0xffUL
+	#define HCOMM_STATUS_VER_SFT       0
+	#define HCOMM_STATUS_VER_LATEST      0x1UL
+	#define HCOMM_STATUS_VER_LAST       HCOMM_STATUS_VER_LATEST
+	#define HCOMM_STATUS_SIGNATURE_MASK 0xffffff00UL
+	#define HCOMM_STATUS_SIGNATURE_SFT 8
+	#define HCOMM_STATUS_SIGNATURE_VAL   (0x484353UL << 8)
+	#define HCOMM_STATUS_SIGNATURE_LAST HCOMM_STATUS_SIGNATURE_VAL
+	u32	fw_status_loc;
+	#define HCOMM_STATUS_TRUE_ADDR_SPACE_MASK    0x3UL
+	#define HCOMM_STATUS_TRUE_ADDR_SPACE_SFT     0
+	#define HCOMM_STATUS_FW_STATUS_LOC_ADDR_SPACE_PCIE_CFG  0x0UL
+	#define HCOMM_STATUS_FW_STATUS_LOC_ADDR_SPACE_GRC       0x1UL
+	#define HCOMM_STATUS_FW_STATUS_LOC_ADDR_SPACE_BAR0      0x2UL
+	#define HCOMM_STATUS_FW_STATUS_LOC_ADDR_SPACE_BAR1      0x3UL
+	#define HCOMM_STATUS_FW_STATUS_LOC_ADDR_SPACE_LAST     HCOMM_STATUS_FW_STATUS_LOC_ADDR_SPACE_BAR1
+	#define HCOMM_STATUS_TRUE_OFFSET_MASK        0xfffffffcUL
+	#define HCOMM_STATUS_TRUE_OFFSET_SFT         2
+};
+
+#define HCOMM_STATUS_STRUCT_LOC 0x31001F0UL
+
 #endif /* _BNXT_HSI_H_ */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index cc2ee4d0bd18..23b80aa171dd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -1029,7 +1029,7 @@ static int bnxt_vf_set_link(struct bnxt *bp, struct bnxt_vf_info *vf)
 		rc = bnxt_hwrm_exec_fwd_resp(
 			bp, vf, sizeof(struct hwrm_port_phy_qcfg_input));
 	} else {
-		struct hwrm_port_phy_qcfg_output_compat phy_qcfg_resp = {0};
+		struct hwrm_port_phy_qcfg_output phy_qcfg_resp = {0};
 		struct hwrm_port_phy_qcfg_input *phy_qcfg_req;
 
 		phy_qcfg_req =
-- 
2.18.1


--000000000000e8669805b04f13c0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQQgYJKoZIhvcNAQcCoIIQMzCCEC8CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2XMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFRDCCBCygAwIBAgIMXmemodY7nThKPhDVMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTIxMTQ0
MzQ4WhcNMjIwOTIyMTQ0MzQ4WjCBjjELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRUwEwYDVQQDEwxNaWNo
YWVsIENoYW4xKDAmBgkqhkiG9w0BCQEWGW1pY2hhZWwuY2hhbkBicm9hZGNvbS5jb20wggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCzvTuOFaHAhIIrIXYLJ1QZpV36s3f9hlbZaYtz/62Y
SlCURfQ+8H3lJAzgIK2y0H/wT6TqqTDDJiRnDEm/g+5cRmc+bgdu6tGTmj0TIB5Z9wl5SCszDgme
/pPQJf8bD0McWRyaJctmS3DJWgBKl3Fg+tEwUtE4vjA2Yc8WK/S2gtZopdx2gDtvb9ckkJO1LENm
VqhZWob5BsD9/3+ouwWAGUFyA14cXchjfxAeuf4j03ckshYX3DVIp802zOgdQZ5QPfeLUIDSj4yF
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgeKJc2Hf1LI8t
T9i1bvHnALknh7h4VPQL7S4VOxTbpnMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAwOTI3MTc0MjQ2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFcDtu5x8XgZUV0vjekvO9JQFpo0c2SB
nnnFwbIhJQlB88SW+MziOTnQeIwGnxIIgxSFpk855niUXBQw5fPBaGfWuo5YGO/RNAJrCGa0zkbb
yudfZ+e6aNPj6l7ocxZUdeGo8DkrBSv27MIkqBzQ8463iktCfXwD0AYlprpe0aEyamt8i0oYTOEX
2F+jwfbCAdC7OS/V8lhbPKEepoIgeEmB+lTgCfcPjXRAkvYix7F07qakFJr6eDSmF8aAE/WJHHES
i3+XyL1BSAIoxBPyGBnDfwW8jap7ERJGVXw5EW3yOI68P26kivTcTczps90ZBPpd7XcJRPEnXdxM
vViTk/g=
--000000000000e8669805b04f13c0--
