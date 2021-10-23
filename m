Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B624384FC
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 21:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhJWTfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 15:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbhJWTe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 15:34:59 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80200C061764
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:39 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so8251913pjl.2
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jn8oSa4OEveeUdRaHbWwvrF97LfrKb6SNJ2LynCTjYE=;
        b=K6ptvJAMMd5il2a4+82xMgPDj9ZvTrwVQzMHUxvgO4OP5YtyTnw9Kk1yYsW1dbHGBG
         EpNrK+kHJjKbekv2u2DWjccZy7IA++n9kZXa4FrkFYel2EOlQ/i0IprRtOLB6ZVtl59T
         WXRVGpKPkvDp6onnV2nBCGW84+GcDzf/suc6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jn8oSa4OEveeUdRaHbWwvrF97LfrKb6SNJ2LynCTjYE=;
        b=1Zfsa0bM6ZZQCi6lMLguBHvftIff6qmm0sXBZl6MAhyesTh0LyC2PXwsRG0Kkphn5s
         MYbKcM89yLfLA8l06dKiHdcO3PYa5TVo7nitbNioSudZJnUNM6HpDCUFTzUfVJ8HxuOV
         w4LHasftd3spdJgvCbei7Lkx4QYx9+o7+s1QZL92QX+dKElXeiXT/hjWGrO9Bs4AWyfa
         v2xJbe9FmfnMj8MFIJc2n8eg4iKkWatOMF1csXKQMgwqjhDoDm0cUNUDJJ+oNt/9Z077
         26aU60Jp+7dR2pOMrURTf/X8zMrLT6sr3kUxyMzieMABCOUHkufKOU5YHQrQ8JQKtzeR
         rkEw==
X-Gm-Message-State: AOAM530jmBrgM7ingCSGZyWkwnqja1L6w4HPLlta6rdRqzPqVDKzTW9q
        TGmwg1Ypltj890UT2B3pdyIs2Q==
X-Google-Smtp-Source: ABdhPJwY3daKR1J4sv0zkyK//23iQcOI21ulL2LORMYt/xWaMkpcT8GFBfEXbiAsO57yKqWaGM34Ig==
X-Received: by 2002:a17:90a:fd0f:: with SMTP id cv15mr9046094pjb.177.1635017558674;
        Sat, 23 Oct 2021 12:32:38 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f7sm2461532pfv.152.2021.10.23.12.32.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Oct 2021 12:32:38 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next 16/19] bnxt_en: Update firmware interface to 1.10.2.63
Date:   Sat, 23 Oct 2021 15:32:03 -0400
Message-Id: <1635017526-16963-17-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
References: <1635017526-16963-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d2431205cf0a30a9"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d2431205cf0a30a9

The main changes are firmware live patch support and 2 additional FEC
standard counters.

Add the matching FEC counters to ethtool counter array.  Firmware older
than 220 does not return the proper size of the extended RX counters so
we need to cap it at the smaller legacy size.  Otherwise the new FEC
counters may show up with garbage values.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   3 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 155 +++++++++++++++++-
 4 files changed, 156 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4b6a291bb392..137734cd585d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8210,6 +8210,10 @@ static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp, u8 flags)
 	if (!rc) {
 		bp->fw_rx_stats_ext_size =
 			le16_to_cpu(resp_qs->rx_stat_size) / 8;
+		if (BNXT_FW_MAJ(bp) < 220 &&
+		    bp->fw_rx_stats_ext_size > BNXT_RX_STATS_EXT_NUM_LEGACY)
+			bp->fw_rx_stats_ext_size = BNXT_RX_STATS_EXT_NUM_LEGACY;
+
 		bp->fw_tx_stats_ext_size = tx_stat_size ?
 			le16_to_cpu(resp_qs->tx_stat_size) / 8 : 0;
 	} else {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 4165fffec886..4fecfdb430b3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2174,6 +2174,9 @@ struct bnxt {
 #define BNXT_RX_STATS_EXT_OFFSET(counter)		\
 	(offsetof(struct rx_port_stats_ext, counter) / 8)
 
+#define BNXT_RX_STATS_EXT_NUM_LEGACY                   \
+	BNXT_RX_STATS_EXT_OFFSET(rx_fec_corrected_blocks)
+
 #define BNXT_TX_STATS_EXT_OFFSET(counter)		\
 	(offsetof(struct tx_port_stats_ext, counter) / 8)
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index bb3f3529987b..334ada053246 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -427,6 +427,8 @@ static const struct {
 	BNXT_RX_STATS_EXT_ENTRY(rx_pcs_symbol_err),
 	BNXT_RX_STATS_EXT_ENTRY(rx_corrected_bits),
 	BNXT_RX_STATS_EXT_DISCARD_COS_ENTRIES,
+	BNXT_RX_STATS_EXT_ENTRY(rx_fec_corrected_blocks),
+	BNXT_RX_STATS_EXT_ENTRY(rx_fec_uncorrectable_blocks),
 };
 
 static const struct {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 94d07a9f7034..ea86c54247c7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -532,8 +532,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 2
-#define HWRM_VERSION_RSVD 52
-#define HWRM_VERSION_STR "1.10.2.52"
+#define HWRM_VERSION_RSVD 63
+#define HWRM_VERSION_STR "1.10.2.63"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -1587,6 +1587,8 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_DFLT_VLAN_TPID_PCP_SUPPORTED           0x200000UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_KTLS_SUPPORTED                         0x400000UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_EP_RATE_CONTROL                        0x800000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_MIN_BW_SUPPORTED                       0x1000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_TX_COAL_CMPL_CAP                       0x2000000UL
 	u8	max_schqs;
 	u8	mpc_chnls_cap;
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_TCE         0x1UL
@@ -1956,6 +1958,18 @@ struct hwrm_func_cfg_output {
 	u8	valid;
 };
 
+/* hwrm_func_cfg_cmd_err (size:64b/8B) */
+struct hwrm_func_cfg_cmd_err {
+	u8	code;
+	#define FUNC_CFG_CMD_ERR_CODE_UNKNOWN                      0x0UL
+	#define FUNC_CFG_CMD_ERR_CODE_PARTITION_MIN_BW_RANGE       0x1UL
+	#define FUNC_CFG_CMD_ERR_CODE_PARTITION_MIN_MORE_THAN_MAX  0x2UL
+	#define FUNC_CFG_CMD_ERR_CODE_PARTITION_MIN_BW_UNSUPPORTED 0x3UL
+	#define FUNC_CFG_CMD_ERR_CODE_PARTITION_BW_PERCENT         0x4UL
+	#define FUNC_CFG_CMD_ERR_CODE_LAST                        FUNC_CFG_CMD_ERR_CODE_PARTITION_BW_PERCENT
+	u8	unused_0[7];
+};
+
 /* hwrm_func_qstats_input (size:192b/24B) */
 struct hwrm_func_qstats_input {
 	__le16	req_type;
@@ -3601,7 +3615,15 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_PHY_TYPE_200G_BASESR4     0x1dUL
 	#define PORT_PHY_QCFG_RESP_PHY_TYPE_200G_BASELR4     0x1eUL
 	#define PORT_PHY_QCFG_RESP_PHY_TYPE_200G_BASEER4     0x1fUL
-	#define PORT_PHY_QCFG_RESP_PHY_TYPE_LAST            PORT_PHY_QCFG_RESP_PHY_TYPE_200G_BASEER4
+	#define PORT_PHY_QCFG_RESP_PHY_TYPE_50G_BASECR       0x20UL
+	#define PORT_PHY_QCFG_RESP_PHY_TYPE_50G_BASESR       0x21UL
+	#define PORT_PHY_QCFG_RESP_PHY_TYPE_50G_BASELR       0x22UL
+	#define PORT_PHY_QCFG_RESP_PHY_TYPE_50G_BASEER       0x23UL
+	#define PORT_PHY_QCFG_RESP_PHY_TYPE_100G_BASECR2     0x24UL
+	#define PORT_PHY_QCFG_RESP_PHY_TYPE_100G_BASESR2     0x25UL
+	#define PORT_PHY_QCFG_RESP_PHY_TYPE_100G_BASELR2     0x26UL
+	#define PORT_PHY_QCFG_RESP_PHY_TYPE_100G_BASEER2     0x27UL
+	#define PORT_PHY_QCFG_RESP_PHY_TYPE_LAST            PORT_PHY_QCFG_RESP_PHY_TYPE_100G_BASEER2
 	u8	media_type;
 	#define PORT_PHY_QCFG_RESP_MEDIA_TYPE_UNKNOWN 0x0UL
 	#define PORT_PHY_QCFG_RESP_MEDIA_TYPE_TP      0x1UL
@@ -4040,7 +4062,7 @@ struct tx_port_stats_ext {
 	__le64	pfc_pri7_tx_transitions;
 };
 
-/* rx_port_stats_ext (size:3648b/456B) */
+/* rx_port_stats_ext (size:3776b/472B) */
 struct rx_port_stats_ext {
 	__le64	link_down_events;
 	__le64	continuous_pause_events;
@@ -4099,6 +4121,8 @@ struct rx_port_stats_ext {
 	__le64	rx_discard_packets_cos5;
 	__le64	rx_discard_packets_cos6;
 	__le64	rx_discard_packets_cos7;
+	__le64	rx_fec_corrected_blocks;
+	__le64	rx_fec_uncorrectable_blocks;
 };
 
 /* hwrm_port_qstats_ext_input (size:320b/40B) */
@@ -4372,7 +4396,10 @@ struct hwrm_port_phy_qcaps_output {
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_PAM4_SPEEDS_FORCE_MODE_50G      0x1UL
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_PAM4_SPEEDS_FORCE_MODE_100G     0x2UL
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_PAM4_SPEEDS_FORCE_MODE_200G     0x4UL
-	u8	unused_0[3];
+	__le16	flags2;
+	#define PORT_PHY_QCAPS_RESP_FLAGS2_PAUSE_UNSUPPORTED     0x1UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS2_PFC_UNSUPPORTED       0x2UL
+	u8	unused_0[1];
 	u8	valid;
 };
 
@@ -6076,6 +6103,11 @@ struct hwrm_vnic_qcaps_output {
 	#define VNIC_QCAPS_RESP_FLAGS_VIRTIO_NET_VNIC_ALLOC_CAP           0x800UL
 	#define VNIC_QCAPS_RESP_FLAGS_METADATA_FORMAT_CAP                 0x1000UL
 	#define VNIC_QCAPS_RESP_FLAGS_RSS_STRICT_HASH_TYPE_CAP            0x2000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_HASH_TYPE_DELTA_CAP             0x4000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_HASH_FUNCTION_TOEPLITZ_CAP      0x8000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_HASH_FUNCTION_XOR_CAP           0x10000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_HASH_FUNCTION_CHKSM_CAP         0x20000UL
+	#define VNIC_QCAPS_RESP_FLAGS_RSS_IPV6_FLOW_LABEL_CAP             0x40000UL
 	__le16	max_aggs_supported;
 	u8	unused_1[5];
 	u8	valid;
@@ -6206,7 +6238,15 @@ struct hwrm_vnic_rss_cfg_input {
 	__le64	ring_grp_tbl_addr;
 	__le64	hash_key_tbl_addr;
 	__le16	rss_ctx_idx;
-	u8	unused_1[6];
+	u8	flags;
+	#define VNIC_RSS_CFG_REQ_FLAGS_HASH_TYPE_INCLUDE     0x1UL
+	#define VNIC_RSS_CFG_REQ_FLAGS_HASH_TYPE_EXCLUDE     0x2UL
+	u8	rss_hash_function;
+	#define VNIC_RSS_CFG_REQ_RSS_HASH_FUNCTION_TOEPLITZ 0x0UL
+	#define VNIC_RSS_CFG_REQ_RSS_HASH_FUNCTION_XOR      0x1UL
+	#define VNIC_RSS_CFG_REQ_RSS_HASH_FUNCTION_CHECKSUM 0x2UL
+	#define VNIC_RSS_CFG_REQ_RSS_HASH_FUNCTION_LAST    VNIC_RSS_CFG_REQ_RSS_HASH_FUNCTION_CHECKSUM
+	u8	unused_1[4];
 };
 
 /* hwrm_vnic_rss_cfg_output (size:128b/16B) */
@@ -6331,7 +6371,24 @@ struct hwrm_ring_alloc_input {
 	#define RING_ALLOC_REQ_RING_TYPE_RX_AGG    0x4UL
 	#define RING_ALLOC_REQ_RING_TYPE_NQ        0x5UL
 	#define RING_ALLOC_REQ_RING_TYPE_LAST     RING_ALLOC_REQ_RING_TYPE_NQ
-	u8	unused_0;
+	u8	cmpl_coal_cnt;
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_OFF 0x0UL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_4   0x1UL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_8   0x2UL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_12  0x3UL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_16  0x4UL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_24  0x5UL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_32  0x6UL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_48  0x7UL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_64  0x8UL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_96  0x9UL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_128 0xaUL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_192 0xbUL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_256 0xcUL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_320 0xdUL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_384 0xeUL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_MAX 0xfUL
+	#define RING_ALLOC_REQ_CMPL_COAL_CNT_LAST    RING_ALLOC_REQ_CMPL_COAL_CNT_COAL_MAX
 	__le16	flags;
 	#define RING_ALLOC_REQ_FLAGS_RX_SOP_PAD     0x1UL
 	__le64	page_tbl_addr;
@@ -7099,6 +7156,7 @@ struct hwrm_cfa_ntuple_filter_alloc_input {
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_DEST_FID              0x8UL
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_ARP_REPLY             0x10UL
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_DEST_RFS_RING_IDX     0x20UL
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_NO_L2_CONTEXT         0x40UL
 	__le32	enables;
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_ENABLES_L2_FILTER_ID         0x1UL
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_ENABLES_ETHERTYPE            0x2UL
@@ -7234,6 +7292,7 @@ struct hwrm_cfa_ntuple_filter_cfg_input {
 	__le32	flags;
 	#define CFA_NTUPLE_FILTER_CFG_REQ_FLAGS_DEST_FID              0x1UL
 	#define CFA_NTUPLE_FILTER_CFG_REQ_FLAGS_DEST_RFS_RING_IDX     0x2UL
+	#define CFA_NTUPLE_FILTER_CFG_REQ_FLAGS_NO_L2_CONTEXT         0x4UL
 	__le64	ntuple_filter_id;
 	__le32	new_dst_id;
 	__le32	new_mirror_vnic_id;
@@ -7834,11 +7893,11 @@ struct hwrm_cfa_adv_flow_mgnt_qcaps_output {
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_TRUFLOW_CAPABLE                              0x8000UL
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_L2_FILTER_TRAFFIC_TYPE_L2_ROCE_SUPPORTED     0x10000UL
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_LAG_SUPPORTED                                0x20000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_NO_L2CTX_SUPPORTED               0x40000UL
 	u8	unused_0[3];
 	u8	valid;
 };
 
-/* hwrm_tunnel_dst_port_query_input (size:192b/24B) */
 struct hwrm_tunnel_dst_port_query_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -8414,6 +8473,86 @@ struct hwrm_fw_get_structured_data_cmd_err {
 	u8	unused_0[7];
 };
 
+/* hwrm_fw_livepatch_query_input (size:192b/24B) */
+struct hwrm_fw_livepatch_query_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	u8	fw_target;
+	#define FW_LIVEPATCH_QUERY_REQ_FW_TARGET_COMMON_FW 0x1UL
+	#define FW_LIVEPATCH_QUERY_REQ_FW_TARGET_SECURE_FW 0x2UL
+	#define FW_LIVEPATCH_QUERY_REQ_FW_TARGET_LAST     FW_LIVEPATCH_QUERY_REQ_FW_TARGET_SECURE_FW
+	u8	unused_0[7];
+};
+
+/* hwrm_fw_livepatch_query_output (size:640b/80B) */
+struct hwrm_fw_livepatch_query_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	char	install_ver[32];
+	char	active_ver[32];
+	__le16	status_flags;
+	#define FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_INSTALL     0x1UL
+	#define FW_LIVEPATCH_QUERY_RESP_STATUS_FLAGS_ACTIVE      0x2UL
+	u8	unused_0[5];
+	u8	valid;
+};
+
+/* hwrm_fw_livepatch_input (size:256b/32B) */
+struct hwrm_fw_livepatch_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	u8	opcode;
+	#define FW_LIVEPATCH_REQ_OPCODE_ACTIVATE   0x1UL
+	#define FW_LIVEPATCH_REQ_OPCODE_DEACTIVATE 0x2UL
+	#define FW_LIVEPATCH_REQ_OPCODE_LAST      FW_LIVEPATCH_REQ_OPCODE_DEACTIVATE
+	u8	fw_target;
+	#define FW_LIVEPATCH_REQ_FW_TARGET_COMMON_FW 0x1UL
+	#define FW_LIVEPATCH_REQ_FW_TARGET_SECURE_FW 0x2UL
+	#define FW_LIVEPATCH_REQ_FW_TARGET_LAST     FW_LIVEPATCH_REQ_FW_TARGET_SECURE_FW
+	u8	loadtype;
+	#define FW_LIVEPATCH_REQ_LOADTYPE_NVM_INSTALL   0x1UL
+	#define FW_LIVEPATCH_REQ_LOADTYPE_MEMORY_DIRECT 0x2UL
+	#define FW_LIVEPATCH_REQ_LOADTYPE_LAST         FW_LIVEPATCH_REQ_LOADTYPE_MEMORY_DIRECT
+	u8	flags;
+	__le32	patch_len;
+	__le64	host_addr;
+};
+
+/* hwrm_fw_livepatch_output (size:128b/16B) */
+struct hwrm_fw_livepatch_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	unused_0[7];
+	u8	valid;
+};
+
+/* hwrm_fw_livepatch_cmd_err (size:64b/8B) */
+struct hwrm_fw_livepatch_cmd_err {
+	u8	code;
+	#define FW_LIVEPATCH_CMD_ERR_CODE_UNKNOWN         0x0UL
+	#define FW_LIVEPATCH_CMD_ERR_CODE_INVALID_OPCODE  0x1UL
+	#define FW_LIVEPATCH_CMD_ERR_CODE_INVALID_TARGET  0x2UL
+	#define FW_LIVEPATCH_CMD_ERR_CODE_NOT_SUPPORTED   0x3UL
+	#define FW_LIVEPATCH_CMD_ERR_CODE_NOT_INSTALLED   0x4UL
+	#define FW_LIVEPATCH_CMD_ERR_CODE_NOT_PATCHED     0x5UL
+	#define FW_LIVEPATCH_CMD_ERR_CODE_AUTH_FAIL       0x6UL
+	#define FW_LIVEPATCH_CMD_ERR_CODE_INVALID_HEADER  0x7UL
+	#define FW_LIVEPATCH_CMD_ERR_CODE_INVALID_SIZE    0x8UL
+	#define FW_LIVEPATCH_CMD_ERR_CODE_ALREADY_PATCHED 0x9UL
+	#define FW_LIVEPATCH_CMD_ERR_CODE_LAST           FW_LIVEPATCH_CMD_ERR_CODE_ALREADY_PATCHED
+	u8	unused_0[7];
+};
+
 /* hwrm_exec_fwd_resp_input (size:1024b/128B) */
 struct hwrm_exec_fwd_resp_input {
 	__le16	req_type;
-- 
2.18.1


--000000000000d2431205cf0a30a9
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJIPsVblFeAVz7LIyOGa5CjjvGBghExz
iC8vwN7s1z9DMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
MzE5MzIzOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBEq979tWfPs5KC47qsZsUoxm8B0lkYskeiokfatdFpxBF2Qxvu
EGQcCYabC/z0lbK4XWSvm9IfZz1Bd13Bk119nyWSCeoUkrcSXOLa+s4yXJs0P602qXbVDkaNthdv
2gxVVs0IuzxiUuKMwhXNc1eTaev3eRSq0bmE9BM+SHp+Yc5ZXqfuOb/4z5HaJduduf5evGiNQG48
meSWDfjrN4fr4GdrZ4EUUazGyYrdkJI1TuUuV7BoST9MAuRPIaf+GOiYELuAzVlWotq003nCjHen
qwk3PxNfiuS5OB6SGJNN0jahBmPmclLqSf6ndI0PRcRFTxB2kzdNScS8vWY5P2YE
--000000000000d2431205cf0a30a9--
