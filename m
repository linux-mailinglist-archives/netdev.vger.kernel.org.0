Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D307188903
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgCQPTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:19:41 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54508 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgCQPTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:19:41 -0400
Received: by mail-wm1-f68.google.com with SMTP id n8so21888453wmc.4
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UqBWm8xd9SUSRufJWAYy00zKYQbiUSz8TQQSMV12eK4=;
        b=d0rJuqZ4lnl7Ghrh2arAtLpnncAy5v8d5b0c4XaklPMKA3dutqRCtweMja25m8TFZl
         qX1PlQa/vXBfNC7QH5soGh1UiI6MZ1fR3luu4Ka/W+UMJlzRBECINxABjCtWe/xZ1Phn
         CjVmG0fiMKEOpOuGBSXgtLI77UwikBs7PtAqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UqBWm8xd9SUSRufJWAYy00zKYQbiUSz8TQQSMV12eK4=;
        b=bKMm6PSznOJY00blMHT0Qrpmot4O75sQ2nbktZb9B6hnhMQWgQbIezrH9bAHukpi8P
         znK8cTbkzvjrn/jOzf/p98S+ysGM0cvhN5nlS7+sapkGY3EMnNDbbUaRh4BWwoIQ4tXH
         EPyV9a6/CySo1mY1tJWpJ5uSwxKrsCQ6MUMR8FIYgkKJBsbFTRQWCtnDyBPHUW40083C
         vlOJNZ4bJF9+ggPk7fEclpYAWxIh8F2HMzw8xg4FtGr6VnKr0g2CE50OOMA+XkFJCcwJ
         FCyNQ90Vpq1pGEKYt7SQwH/Qk1BjRupQ936uD7eVsSycs69YYLcHncJP0/BKuPWSF0F1
         Jb9g==
X-Gm-Message-State: ANhLgQ208vzdP2mh4PjNCeKD/9pWuz6QV0Zm7rjDoUgI3vBdoU1XyC8D
        d6FOFQ6Nhvg+W+B8KitkAsLfLQ==
X-Google-Smtp-Source: ADFU+vsmQxhMczpM6DVa7jeW5QhEdXBCItbyI1Iiv4XqFu+MqyDsZVTi+Q1KqlDx0lo2wkHhWTK2uQ==
X-Received: by 2002:a1c:491:: with SMTP id 139mr5994805wme.21.1584458377748;
        Tue, 17 Mar 2020 08:19:37 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z19sm4363534wma.41.2020.03.17.08.19.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:19:37 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 10/11] bnxt_en: Update firmware interface spec to 1.10.1.26.
Date:   Tue, 17 Mar 2020 20:47:25 +0530
Message-Id: <1584458246-29370-4-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ECN and ECN statistics firmware commands support, PFC watchdog
support and few minor changes to the spec.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 307 +++++++++++++++++++++++---
 1 file changed, 282 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 7cf27df..0f080b9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -2,7 +2,7 @@
  *
  * Copyright (c) 2014-2016 Broadcom Corporation
  * Copyright (c) 2014-2018 Broadcom Limited
- * Copyright (c) 2018-2019 Broadcom Inc.
+ * Copyright (c) 2018-2020 Broadcom Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -207,6 +207,8 @@ struct cmd_nums {
 	#define HWRM_PORT_PHY_MDIO_READ                   0xb6UL
 	#define HWRM_PORT_PHY_MDIO_BUS_ACQUIRE            0xb7UL
 	#define HWRM_PORT_PHY_MDIO_BUS_RELEASE            0xb8UL
+	#define HWRM_PORT_QSTATS_EXT_PFC_WD               0xb9UL
+	#define HWRM_PORT_ECN_QSTATS                      0xbaUL
 	#define HWRM_FW_RESET                             0xc0UL
 	#define HWRM_FW_QSTATUS                           0xc1UL
 	#define HWRM_FW_HEALTH_CHECK                      0xc2UL
@@ -220,6 +222,8 @@ struct cmd_nums {
 	#define HWRM_FW_SET_STRUCTURED_DATA               0xcaUL
 	#define HWRM_FW_GET_STRUCTURED_DATA               0xcbUL
 	#define HWRM_FW_IPC_MAILBOX                       0xccUL
+	#define HWRM_FW_ECN_CFG                           0xcdUL
+	#define HWRM_FW_ECN_QCFG                          0xceUL
 	#define HWRM_EXEC_FWD_RESP                        0xd0UL
 	#define HWRM_REJECT_FWD_RESP                      0xd1UL
 	#define HWRM_FWD_RESP                             0xd2UL
@@ -341,6 +345,9 @@ struct cmd_nums {
 	#define HWRM_MFG_OTP_CFG                          0x207UL
 	#define HWRM_MFG_OTP_QCFG                         0x208UL
 	#define HWRM_MFG_HDMA_TEST                        0x209UL
+	#define HWRM_MFG_FRU_EEPROM_WRITE                 0x20aUL
+	#define HWRM_MFG_FRU_EEPROM_READ                  0x20bUL
+	#define HWRM_SV                                   0x400UL
 	#define HWRM_DBG_READ_DIRECT                      0xff10UL
 	#define HWRM_DBG_READ_INDIRECT                    0xff11UL
 	#define HWRM_DBG_WRITE_DIRECT                     0xff12UL
@@ -356,6 +363,7 @@ struct cmd_nums {
 	#define HWRM_DBG_RING_INFO_GET                    0xff1cUL
 	#define HWRM_DBG_CRASHDUMP_HEADER                 0xff1dUL
 	#define HWRM_DBG_CRASHDUMP_ERASE                  0xff1eUL
+	#define HWRM_DBG_DRV_TRACE                        0xff1fUL
 	#define HWRM_NVM_FACTORY_DEFAULTS                 0xffeeUL
 	#define HWRM_NVM_VALIDATE_OPTION                  0xffefUL
 	#define HWRM_NVM_FLUSH                            0xfff0UL
@@ -429,8 +437,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 1
-#define HWRM_VERSION_RSVD 12
-#define HWRM_VERSION_STR "1.10.1.12"
+#define HWRM_VERSION_RSVD 26
+#define HWRM_VERSION_STR "1.10.1.26"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -647,6 +655,7 @@ struct hwrm_async_event_cmpl {
 	#define ASYNC_EVENT_CMPL_EVENT_ID_TFLIB_LINK_STATUS_CHANGE   0x3eUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_QUIESCE_DONE               0x3fUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_DEFERRED_RESPONSE          0x40UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_PFC_WATCHDOG_CFG_CHANGE    0x41UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FW_TRACE_MSG               0xfeUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR                 0xffUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_LAST                      ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR
@@ -1089,7 +1098,7 @@ struct hwrm_func_qcaps_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_func_qcaps_output (size:640b/80B) */
+/* hwrm_func_qcaps_output (size:704b/88B) */
 struct hwrm_func_qcaps_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -1126,6 +1135,9 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_ERR_RECOVER_RELOAD                    0x2000000UL
 	#define FUNC_QCAPS_RESP_FLAGS_NOTIFY_VF_DEF_VNIC_CHNG_SUPPORTED     0x4000000UL
 	#define FUNC_QCAPS_RESP_FLAGS_VLAN_ACCELERATION_TX_DISABLED         0x8000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_COREDUMP_CMD_SUPPORTED                0x10000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_CRASHDUMP_CMD_SUPPORTED               0x20000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_PFC_WD_STATS_SUPPORTED                0x40000000UL
 	u8	mac_address[6];
 	__le16	max_rsscos_ctx;
 	__le16	max_cmpl_rings;
@@ -1146,7 +1158,11 @@ struct hwrm_func_qcaps_output {
 	__le32	max_flow_id;
 	__le32	max_hw_ring_grps;
 	__le16	max_sp_tx_rings;
-	u8	unused_0;
+	u8	unused_0[2];
+	__le32	flags_ext;
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_MARK_SUPPORTED      0x1UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_STATS_SUPPORTED     0x2UL
+	u8	unused_1[3];
 	u8	valid;
 };
 
@@ -1161,7 +1177,7 @@ struct hwrm_func_qcfg_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_func_qcfg_output (size:704b/88B) */
+/* hwrm_func_qcfg_output (size:768b/96B) */
 struct hwrm_func_qcfg_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -1267,7 +1283,11 @@ struct hwrm_func_qcfg_output {
 	u8	always_1;
 	__le32	reset_addr_poll;
 	__le16	legacy_l2_db_size_kb;
-	u8	unused_2[1];
+	__le16	svif_info;
+	#define FUNC_QCFG_RESP_SVIF_INFO_SVIF_MASK      0x7fffUL
+	#define FUNC_QCFG_RESP_SVIF_INFO_SVIF_SFT       0
+	#define FUNC_QCFG_RESP_SVIF_INFO_SVIF_VALID     0x8000UL
+	u8	unused_2[7];
 	u8	valid;
 };
 
@@ -1808,7 +1828,7 @@ struct hwrm_func_backing_store_qcaps_output {
 	u8	ctx_kind_initializer;
 	__le32	rsvd;
 	__le16	rsvd1;
-	u8	rsvd2;
+	u8	tqm_fp_rings_count;
 	u8	valid;
 };
 
@@ -2231,7 +2251,17 @@ struct hwrm_error_recovery_qcfg_output {
 	#define ERROR_RECOVERY_QCFG_RESP_RESET_REG_ADDR_SFT           2
 	__le32	reset_reg_val[16];
 	u8	delay_after_reset[16];
-	u8	unused_1[7];
+	__le32	err_recovery_cnt_reg;
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_MASK    0x3UL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_SFT     0
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_PCIE_CFG  0x0UL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_GRC       0x1UL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_BAR0      0x2UL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_BAR1      0x3UL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_LAST     ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_BAR1
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_MASK          0xfffffffcUL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SFT           2
+	u8	unused_1[3];
 	u8	valid;
 };
 
@@ -3048,6 +3078,90 @@ struct rx_port_stats_ext {
 	__le64	rx_discard_packets_cos7;
 };
 
+/* rx_port_stats_ext_pfc_wd (size:5120b/640B) */
+struct rx_port_stats_ext_pfc_wd {
+	__le64	rx_pfc_watchdog_storms_detected_pri0;
+	__le64	rx_pfc_watchdog_storms_detected_pri1;
+	__le64	rx_pfc_watchdog_storms_detected_pri2;
+	__le64	rx_pfc_watchdog_storms_detected_pri3;
+	__le64	rx_pfc_watchdog_storms_detected_pri4;
+	__le64	rx_pfc_watchdog_storms_detected_pri5;
+	__le64	rx_pfc_watchdog_storms_detected_pri6;
+	__le64	rx_pfc_watchdog_storms_detected_pri7;
+	__le64	rx_pfc_watchdog_storms_reverted_pri0;
+	__le64	rx_pfc_watchdog_storms_reverted_pri1;
+	__le64	rx_pfc_watchdog_storms_reverted_pri2;
+	__le64	rx_pfc_watchdog_storms_reverted_pri3;
+	__le64	rx_pfc_watchdog_storms_reverted_pri4;
+	__le64	rx_pfc_watchdog_storms_reverted_pri5;
+	__le64	rx_pfc_watchdog_storms_reverted_pri6;
+	__le64	rx_pfc_watchdog_storms_reverted_pri7;
+	__le64	rx_pfc_watchdog_storms_rx_packets_pri0;
+	__le64	rx_pfc_watchdog_storms_rx_packets_pri1;
+	__le64	rx_pfc_watchdog_storms_rx_packets_pri2;
+	__le64	rx_pfc_watchdog_storms_rx_packets_pri3;
+	__le64	rx_pfc_watchdog_storms_rx_packets_pri4;
+	__le64	rx_pfc_watchdog_storms_rx_packets_pri5;
+	__le64	rx_pfc_watchdog_storms_rx_packets_pri6;
+	__le64	rx_pfc_watchdog_storms_rx_packets_pri7;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_pri0;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_pri1;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_pri2;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_pri3;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_pri4;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_pri5;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_pri6;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_pri7;
+	__le64	rx_pfc_watchdog_storms_rx_packets_dropped_pri0;
+	__le64	rx_pfc_watchdog_storms_rx_packets_dropped_pri1;
+	__le64	rx_pfc_watchdog_storms_rx_packets_dropped_pri2;
+	__le64	rx_pfc_watchdog_storms_rx_packets_dropped_pri3;
+	__le64	rx_pfc_watchdog_storms_rx_packets_dropped_pri4;
+	__le64	rx_pfc_watchdog_storms_rx_packets_dropped_pri5;
+	__le64	rx_pfc_watchdog_storms_rx_packets_dropped_pri6;
+	__le64	rx_pfc_watchdog_storms_rx_packets_dropped_pri7;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_dropped_pri0;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_dropped_pri1;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_dropped_pri2;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_dropped_pri3;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_dropped_pri4;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_dropped_pri5;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_dropped_pri6;
+	__le64	rx_pfc_watchdog_storms_rx_bytes_dropped_pri7;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_pri0;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_pri1;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_pri2;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_pri3;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_pri4;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_pri5;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_pri6;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_pri7;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_pri0;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_pri1;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_pri2;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_pri3;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_pri4;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_pri5;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_pri6;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_pri7;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_dropped_pri0;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_dropped_pri1;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_dropped_pri2;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_dropped_pri3;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_dropped_pri4;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_dropped_pri5;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_dropped_pri6;
+	__le64	rx_pfc_watchdog_last_storm_rx_packets_dropped_pri7;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_dropped_pri0;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_dropped_pri1;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_dropped_pri2;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_dropped_pri3;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_dropped_pri4;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_dropped_pri5;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_dropped_pri6;
+	__le64	rx_pfc_watchdog_last_storm_rx_bytes_dropped_pri7;
+};
+
 /* hwrm_port_qstats_ext_input (size:320b/40B) */
 struct hwrm_port_qstats_ext_input {
 	__le16	req_type;
@@ -3077,6 +3191,31 @@ struct hwrm_port_qstats_ext_output {
 	u8	valid;
 };
 
+/* hwrm_port_qstats_ext_pfc_wd_input (size:256b/32B) */
+struct hwrm_port_qstats_ext_pfc_wd_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	port_id;
+	__le16	pfc_wd_stat_size;
+	u8	unused_0[4];
+	__le64	pfc_wd_stat_host_addr;
+};
+
+/* hwrm_port_qstats_ext_pfc_wd_output (size:128b/16B) */
+struct hwrm_port_qstats_ext_pfc_wd_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le16	pfc_wd_stat_size;
+	u8	flags;
+	u8	valid;
+	u8	unused_0[4];
+};
+
 /* hwrm_port_lpbk_qstats_input (size:128b/16B) */
 struct hwrm_port_lpbk_qstats_input {
 	__le16	req_type;
@@ -3106,6 +3245,36 @@ struct hwrm_port_lpbk_qstats_output {
 	u8	valid;
 };
 
+/* hwrm_port_ecn_qstats_input (size:192b/24B) */
+struct hwrm_port_ecn_qstats_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	port_id;
+	u8	unused_0[6];
+};
+
+/* hwrm_port_ecn_qstats_output (size:384b/48B) */
+struct hwrm_port_ecn_qstats_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le32	mark_cnt_cos0;
+	__le32	mark_cnt_cos1;
+	__le32	mark_cnt_cos2;
+	__le32	mark_cnt_cos3;
+	__le32	mark_cnt_cos4;
+	__le32	mark_cnt_cos5;
+	__le32	mark_cnt_cos6;
+	__le32	mark_cnt_cos7;
+	u8	mark_en;
+	u8	unused_0[6];
+	u8	valid;
+};
+
 /* hwrm_port_clr_stats_input (size:192b/24B) */
 struct hwrm_port_clr_stats_input {
 	__le16	req_type;
@@ -3840,14 +4009,22 @@ struct hwrm_queue_pfcenable_qcfg_output {
 	__le16	seq_id;
 	__le16	resp_len;
 	__le32	flags;
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI0_PFC_ENABLED     0x1UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI1_PFC_ENABLED     0x2UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI2_PFC_ENABLED     0x4UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI3_PFC_ENABLED     0x8UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI4_PFC_ENABLED     0x10UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI5_PFC_ENABLED     0x20UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI6_PFC_ENABLED     0x40UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI7_PFC_ENABLED     0x80UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI0_PFC_ENABLED              0x1UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI1_PFC_ENABLED              0x2UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI2_PFC_ENABLED              0x4UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI3_PFC_ENABLED              0x8UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI4_PFC_ENABLED              0x10UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI5_PFC_ENABLED              0x20UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI6_PFC_ENABLED              0x40UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI7_PFC_ENABLED              0x80UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI0_PFC_WATCHDOG_ENABLED     0x100UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI1_PFC_WATCHDOG_ENABLED     0x200UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI2_PFC_WATCHDOG_ENABLED     0x400UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI3_PFC_WATCHDOG_ENABLED     0x800UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI4_PFC_WATCHDOG_ENABLED     0x1000UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI5_PFC_WATCHDOG_ENABLED     0x2000UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI6_PFC_WATCHDOG_ENABLED     0x4000UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI7_PFC_WATCHDOG_ENABLED     0x8000UL
 	u8	unused_0[3];
 	u8	valid;
 };
@@ -3860,14 +4037,22 @@ struct hwrm_queue_pfcenable_cfg_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le32	flags;
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI0_PFC_ENABLED     0x1UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI1_PFC_ENABLED     0x2UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI2_PFC_ENABLED     0x4UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI3_PFC_ENABLED     0x8UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI4_PFC_ENABLED     0x10UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI5_PFC_ENABLED     0x20UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI6_PFC_ENABLED     0x40UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI7_PFC_ENABLED     0x80UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI0_PFC_ENABLED              0x1UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI1_PFC_ENABLED              0x2UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI2_PFC_ENABLED              0x4UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI3_PFC_ENABLED              0x8UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI4_PFC_ENABLED              0x10UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI5_PFC_ENABLED              0x20UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI6_PFC_ENABLED              0x40UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI7_PFC_ENABLED              0x80UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI0_PFC_WATCHDOG_ENABLED     0x100UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI1_PFC_WATCHDOG_ENABLED     0x200UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI2_PFC_WATCHDOG_ENABLED     0x400UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI3_PFC_WATCHDOG_ENABLED     0x800UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI4_PFC_WATCHDOG_ENABLED     0x1000UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI5_PFC_WATCHDOG_ENABLED     0x2000UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI6_PFC_WATCHDOG_ENABLED     0x4000UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI7_PFC_WATCHDOG_ENABLED     0x8000UL
 	__le16	port_id;
 	u8	unused_0[2];
 };
@@ -7222,6 +7407,49 @@ struct hwrm_temp_monitor_query_output {
 	u8	valid;
 };
 
+/* hwrm_fw_ecn_cfg_input (size:192b/24B) */
+struct hwrm_fw_ecn_cfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	flags;
+	#define FW_ECN_CFG_REQ_FLAGS_ENABLE_ECN     0x1UL
+	u8	unused_0[6];
+};
+
+/* hwrm_fw_ecn_cfg_output (size:128b/16B) */
+struct hwrm_fw_ecn_cfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	unused_0[7];
+	u8	valid;
+};
+
+/* hwrm_fw_ecn_qcfg_input (size:128b/16B) */
+struct hwrm_fw_ecn_qcfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+};
+
+/* hwrm_fw_ecn_qcfg_output (size:128b/16B) */
+struct hwrm_fw_ecn_qcfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le16	flags;
+	#define FW_ECN_QCFG_RESP_FLAGS_ENABLE_ECN     0x1UL
+	u8	unused_0[5];
+	u8	valid;
+};
+
 /* hwrm_wol_filter_alloc_input (size:512b/64B) */
 struct hwrm_wol_filter_alloc_input {
 	__le16	req_type;
@@ -7501,6 +7729,35 @@ struct hwrm_dbg_ring_info_get_output {
 	u8	valid;
 };
 
+/* hwrm_dbg_drv_trace_input (size:1024b/128B) */
+struct hwrm_dbg_drv_trace_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	u8	severity;
+	#define DBG_DRV_TRACE_REQ_SEVERITY_TRACE_LEVEL_FATAL   0x0UL
+	#define DBG_DRV_TRACE_REQ_SEVERITY_TRACE_LEVEL_ERROR   0x1UL
+	#define DBG_DRV_TRACE_REQ_SEVERITY_TRACE_LEVEL_WARNING 0x2UL
+	#define DBG_DRV_TRACE_REQ_SEVERITY_TRACE_LEVEL_INFO    0x3UL
+	#define DBG_DRV_TRACE_REQ_SEVERITY_TRACE_LEVEL_DEBUG   0x4UL
+	#define DBG_DRV_TRACE_REQ_SEVERITY_LAST               DBG_DRV_TRACE_REQ_SEVERITY_TRACE_LEVEL_DEBUG
+	u8	write_len;
+	u8	unused_0[6];
+	char	trace_data[104];
+};
+
+/* hwrm_dbg_drv_trace_output (size:128b/16B) */
+struct hwrm_dbg_drv_trace_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	unused_0[7];
+	u8	valid;
+};
+
 /* hwrm_nvm_read_input (size:320b/40B) */
 struct hwrm_nvm_read_input {
 	__le16	req_type;
-- 
1.8.3.1

