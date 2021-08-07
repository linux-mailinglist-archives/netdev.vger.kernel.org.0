Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F893E36E5
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 21:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhHGTDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 15:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhHGTDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 15:03:54 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE3AC0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Aug 2021 12:03:37 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l11so133603plk.6
        for <netdev@vger.kernel.org>; Sat, 07 Aug 2021 12:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eOELfQqlFydcqTIoNtt0guY2vGVpuPYsqAAf19Vb0eU=;
        b=NxFy28KB9ljseH7PGzZ8tIccpMAcQ071SZaEKf7h9UXqndYgbQ+xjfu2p2T2tyuPkv
         WvXPJ9ff7jsgAwjuKoTpBrQ29fJiDpUY19FXeNSa4obq0++iogG3ke1+yYcmcMVlx1Ss
         zSXY0Wg/5GuADfz82OLE/joDOkjtgT9hBBXsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eOELfQqlFydcqTIoNtt0guY2vGVpuPYsqAAf19Vb0eU=;
        b=JpTFdN/S7we+vUQPyygtSCf8gB/RTsNVr0ZTJgmIsQMY5FjQP6FY2BoOsBsmbkUo/l
         oW1WwHt7AN5+CjelpDtE4Z1eyRSPkyNljE6SZAQoAayoy9X7d17KqJttMYpEqlzS/ccB
         uAx/IOTQuhWyPBL7FP6AUt2HlKPyhDQC+TJ8qG/8XzzmmFjsPaH0XYYTq5UKjp1NndzD
         qERhunxkwESVhkL2eTK5sTAZsYxg85+lTWJjvGnGMbtB8cKvIexvKYO0QvWrXjzdE+nA
         D1jl7cdtNbXk5tpKXry4Lw2ItTXvUMvyyIURCwNKDJwm9kkk2en3XeRu4xca3xrSy4PE
         wk6g==
X-Gm-Message-State: AOAM531UgyMzafuQRvE88msJScwRYkK7/25nU4mjtSLcaFYkT/ymOwuY
        xURYwk5C/OjNGKrfLKG76BMOlg==
X-Google-Smtp-Source: ABdhPJwaJiJpThDDC3IoaKqm1p/WvvoOf3nLlzuii6WOsCaJnIt6DMfpoGufOQWX8o2V4KDeK0Hm4w==
X-Received: by 2002:a63:653:: with SMTP id 80mr282279pgg.388.1628363016519;
        Sat, 07 Aug 2021 12:03:36 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o18sm3378006pjp.1.2021.08.07.12.03.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Aug 2021 12:03:35 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com
Subject: [PATCH net 1/3] bnxt_en: Update firmware interface to 1.10.2.52
Date:   Sat,  7 Aug 2021 15:03:13 -0400
Message-Id: <1628362995-7938-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628362995-7938-1-git-send-email-michael.chan@broadcom.com>
References: <1628362995-7938-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003214a305c8fccf6f"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003214a305c8fccf6f

The key change is the firmware call to retrieve the PTP TX timestamp.
The header offset for the PTP sequence number field is now added.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 76 ++++++++++++++-----
 1 file changed, 55 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 3fc6781c5b98..94d07a9f7034 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -368,6 +368,7 @@ struct cmd_nums {
 	#define HWRM_FUNC_PTP_TS_QUERY                    0x19fUL
 	#define HWRM_FUNC_PTP_EXT_CFG                     0x1a0UL
 	#define HWRM_FUNC_PTP_EXT_QCFG                    0x1a1UL
+	#define HWRM_FUNC_KEY_CTX_ALLOC                   0x1a2UL
 	#define HWRM_SELFTEST_QLIST                       0x200UL
 	#define HWRM_SELFTEST_EXEC                        0x201UL
 	#define HWRM_SELFTEST_IRQ                         0x202UL
@@ -531,8 +532,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 2
-#define HWRM_VERSION_RSVD 47
-#define HWRM_VERSION_STR "1.10.2.47"
+#define HWRM_VERSION_RSVD 52
+#define HWRM_VERSION_STR "1.10.2.52"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -585,6 +586,7 @@ struct hwrm_ver_get_output {
 	#define VER_GET_RESP_DEV_CAPS_CFG_CFA_ADV_FLOW_MGNT_SUPPORTED              0x1000UL
 	#define VER_GET_RESP_DEV_CAPS_CFG_CFA_TFLIB_SUPPORTED                      0x2000UL
 	#define VER_GET_RESP_DEV_CAPS_CFG_CFA_TRUFLOW_SUPPORTED                    0x4000UL
+	#define VER_GET_RESP_DEV_CAPS_CFG_SECURE_BOOT_CAPABLE                      0x8000UL
 	u8	roce_fw_maj_8b;
 	u8	roce_fw_min_8b;
 	u8	roce_fw_bld_8b;
@@ -886,7 +888,8 @@ struct hwrm_async_event_cmpl_reset_notify {
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FW_EXCEPTION_FATAL        (0x2UL << 8)
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FW_EXCEPTION_NON_FATAL    (0x3UL << 8)
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FAST_RESET                (0x4UL << 8)
-	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_LAST                     ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FAST_RESET
+	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FW_ACTIVATION             (0x5UL << 8)
+	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_LAST                     ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FW_ACTIVATION
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_DELAY_IN_100MS_TICKS_MASK           0xffff0000UL
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_DELAY_IN_100MS_TICKS_SFT            16
 };
@@ -1236,13 +1239,14 @@ struct hwrm_async_event_cmpl_error_report_base {
 	u8	timestamp_lo;
 	__le16	timestamp_hi;
 	__le32	event_data1;
-	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_MASK          0xffUL
-	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_SFT           0
-	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_RESERVED        0x0UL
-	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_PAUSE_STORM     0x1UL
-	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_INVALID_SIGNAL  0x2UL
-	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_NVM             0x3UL
-	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_LAST           ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_NVM
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_MASK                   0xffUL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_SFT                    0
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_RESERVED                 0x0UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_PAUSE_STORM              0x1UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_INVALID_SIGNAL           0x2UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_NVM                      0x3UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_DOORBELL_DROP_THRESHOLD  0x4UL
+	#define ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_LAST                    ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_DOORBELL_DROP_THRESHOLD
 };
 
 /* hwrm_async_event_cmpl_error_report_pause_storm (size:128b/16B) */
@@ -1446,6 +1450,8 @@ struct hwrm_func_vf_cfg_input {
 	#define FUNC_VF_CFG_REQ_ENABLES_NUM_VNICS            0x200UL
 	#define FUNC_VF_CFG_REQ_ENABLES_NUM_STAT_CTXS        0x400UL
 	#define FUNC_VF_CFG_REQ_ENABLES_NUM_HW_RING_GRPS     0x800UL
+	#define FUNC_VF_CFG_REQ_ENABLES_NUM_TX_KEY_CTXS      0x1000UL
+	#define FUNC_VF_CFG_REQ_ENABLES_NUM_RX_KEY_CTXS      0x2000UL
 	__le16	mtu;
 	__le16	guest_vlan;
 	__le16	async_event_cr;
@@ -1469,7 +1475,8 @@ struct hwrm_func_vf_cfg_input {
 	__le16	num_vnics;
 	__le16	num_stat_ctxs;
 	__le16	num_hw_ring_grps;
-	u8	unused_0[4];
+	__le16	num_tx_key_ctxs;
+	__le16	num_rx_key_ctxs;
 };
 
 /* hwrm_func_vf_cfg_output (size:128b/16B) */
@@ -1493,7 +1500,7 @@ struct hwrm_func_qcaps_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_func_qcaps_output (size:704b/88B) */
+/* hwrm_func_qcaps_output (size:768b/96B) */
 struct hwrm_func_qcaps_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -1587,7 +1594,8 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_TE_CFA      0x4UL
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_RE_CFA      0x8UL
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_PRIMATE     0x10UL
-	u8	unused_1;
+	__le16	max_key_ctxs_alloc;
+	u8	unused_1[7];
 	u8	valid;
 };
 
@@ -1602,7 +1610,7 @@ struct hwrm_func_qcfg_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_func_qcfg_output (size:832b/104B) */
+/* hwrm_func_qcfg_output (size:896b/112B) */
 struct hwrm_func_qcfg_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -1749,11 +1757,13 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
 	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_LAST         FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_PERCENT1_100
 	__le16	host_mtu;
-	u8	unused_3;
+	__le16	alloc_tx_key_ctxs;
+	__le16	alloc_rx_key_ctxs;
+	u8	unused_3[5];
 	u8	valid;
 };
 
-/* hwrm_func_cfg_input (size:832b/104B) */
+/* hwrm_func_cfg_input (size:896b/112B) */
 struct hwrm_func_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -1820,6 +1830,8 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_ENABLES_PARTITION_MAX_BW         0x8000000UL
 	#define FUNC_CFG_REQ_ENABLES_TPID                     0x10000000UL
 	#define FUNC_CFG_REQ_ENABLES_HOST_MTU                 0x20000000UL
+	#define FUNC_CFG_REQ_ENABLES_TX_KEY_CTXS              0x40000000UL
+	#define FUNC_CFG_REQ_ENABLES_RX_KEY_CTXS              0x80000000UL
 	__le16	admin_mtu;
 	__le16	mru;
 	__le16	num_rsscos_ctxs;
@@ -1929,6 +1941,9 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_LAST         FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_PERCENT1_100
 	__be16	tpid;
 	__le16	host_mtu;
+	__le16	num_tx_key_ctxs;
+	__le16	num_rx_key_ctxs;
+	u8	unused_0[4];
 };
 
 /* hwrm_func_cfg_output (size:128b/16B) */
@@ -2099,6 +2114,7 @@ struct hwrm_func_drv_rgtr_input {
 	#define FUNC_DRV_RGTR_REQ_FLAGS_MASTER_SUPPORT                   0x40UL
 	#define FUNC_DRV_RGTR_REQ_FLAGS_FAST_RESET_SUPPORT               0x80UL
 	#define FUNC_DRV_RGTR_REQ_FLAGS_RSS_STRICT_HASH_TYPE_SUPPORT     0x100UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_NPAR_1_2_SUPPORT                 0x200UL
 	__le32	enables;
 	#define FUNC_DRV_RGTR_REQ_ENABLES_OS_TYPE             0x1UL
 	#define FUNC_DRV_RGTR_REQ_ENABLES_VER                 0x2UL
@@ -2268,7 +2284,7 @@ struct hwrm_func_resource_qcaps_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_func_resource_qcaps_output (size:448b/56B) */
+/* hwrm_func_resource_qcaps_output (size:512b/64B) */
 struct hwrm_func_resource_qcaps_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -2300,11 +2316,15 @@ struct hwrm_func_resource_qcaps_output {
 	__le16	max_tx_scheduler_inputs;
 	__le16	flags;
 	#define FUNC_RESOURCE_QCAPS_RESP_FLAGS_MIN_GUARANTEED     0x1UL
+	__le16	min_tx_key_ctxs;
+	__le16	max_tx_key_ctxs;
+	__le16	min_rx_key_ctxs;
+	__le16	max_rx_key_ctxs;
 	u8	unused_0[5];
 	u8	valid;
 };
 
-/* hwrm_func_vf_resource_cfg_input (size:448b/56B) */
+/* hwrm_func_vf_resource_cfg_input (size:512b/64B) */
 struct hwrm_func_vf_resource_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -2331,6 +2351,10 @@ struct hwrm_func_vf_resource_cfg_input {
 	__le16	max_hw_ring_grps;
 	__le16	flags;
 	#define FUNC_VF_RESOURCE_CFG_REQ_FLAGS_MIN_GUARANTEED     0x1UL
+	__le16	min_tx_key_ctxs;
+	__le16	max_tx_key_ctxs;
+	__le16	min_rx_key_ctxs;
+	__le16	max_rx_key_ctxs;
 	u8	unused_0[2];
 };
 
@@ -2348,7 +2372,9 @@ struct hwrm_func_vf_resource_cfg_output {
 	__le16	reserved_vnics;
 	__le16	reserved_stat_ctx;
 	__le16	reserved_hw_ring_grps;
-	u8	unused_0[7];
+	__le16	reserved_tx_key_ctxs;
+	__le16	reserved_rx_key_ctxs;
+	u8	unused_0[3];
 	u8	valid;
 };
 
@@ -4220,7 +4246,7 @@ struct hwrm_port_lpbk_clr_stats_output {
 	u8	valid;
 };
 
-/* hwrm_port_ts_query_input (size:256b/32B) */
+/* hwrm_port_ts_query_input (size:320b/40B) */
 struct hwrm_port_ts_query_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -4238,8 +4264,11 @@ struct hwrm_port_ts_query_input {
 	__le16	enables;
 	#define PORT_TS_QUERY_REQ_ENABLES_TS_REQ_TIMEOUT     0x1UL
 	#define PORT_TS_QUERY_REQ_ENABLES_PTP_SEQ_ID         0x2UL
+	#define PORT_TS_QUERY_REQ_ENABLES_PTP_HDR_OFFSET     0x4UL
 	__le16	ts_req_timeout;
 	__le32	ptp_seq_id;
+	__le16	ptp_hdr_offset;
+	u8	unused_1[6];
 };
 
 /* hwrm_port_ts_query_output (size:192b/24B) */
@@ -8172,6 +8201,7 @@ struct hwrm_fw_reset_input {
 	u8	host_idx;
 	u8	flags;
 	#define FW_RESET_REQ_FLAGS_RESET_GRACEFUL     0x1UL
+	#define FW_RESET_REQ_FLAGS_FW_ACTIVATION      0x2UL
 	u8	unused_0[4];
 };
 
@@ -8952,7 +8982,7 @@ struct hwrm_nvm_get_dir_info_output {
 	u8	valid;
 };
 
-/* hwrm_nvm_write_input (size:384b/48B) */
+/* hwrm_nvm_write_input (size:448b/56B) */
 struct hwrm_nvm_write_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -8968,7 +8998,11 @@ struct hwrm_nvm_write_input {
 	__le16	option;
 	__le16	flags;
 	#define NVM_WRITE_REQ_FLAGS_KEEP_ORIG_ACTIVE_IMG     0x1UL
+	#define NVM_WRITE_REQ_FLAGS_BATCH_MODE               0x2UL
+	#define NVM_WRITE_REQ_FLAGS_BATCH_LAST               0x4UL
 	__le32	dir_item_length;
+	__le32	offset;
+	__le32	len;
 	__le32	unused_0;
 };
 
-- 
2.18.1


--0000000000003214a305c8fccf6f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIB3oT+pP5Mus6XIOHtIQDNsXJEMeSGbs
IvoTOajQw27HMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgw
NzE5MDMzN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBgpjSPPyfmKTA7VSLGWYFbsJ/lxyvYxL8qkp3Vks1CmOVLYhtE
XuyZVeRp4ee3wqFZNFrC5HLobtQYU6TU6JfrOKdtn/5wlY569zhyot+QU3Pyjt9mFbiEGJSHeO1/
OvkQvzqOlbSDa0pVBX2fxtKtXDXvZh9BOSbU3QAleNR0SQaJaoOBhXED6WEm7FAQM+Eci9TMI4Ni
tXyBAF5CkmX8MU5mkP6o5JYaU2WuwOBqhNUA/NugbT5R/OT0TkKbVHFR6kYF4Jc6hqfg7tPUi99I
NvlXYVdVY7ej66hpge9WZxrejbGb//6xe2aTzl0EG0d9Po9exHailJxq+s1GB/lZ
--0000000000003214a305c8fccf6f--
