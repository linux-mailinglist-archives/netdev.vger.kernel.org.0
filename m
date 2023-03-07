Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67C46AF87E
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjCGWWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjCGWWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:22:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FECF96D;
        Tue,  7 Mar 2023 14:22:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B11EB81A40;
        Tue,  7 Mar 2023 22:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF9EC433EF;
        Tue,  7 Mar 2023 22:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678227732;
        bh=hep12z65/htc8VobV1reqBOHqul0NinommIACH39giU=;
        h=Date:From:To:Cc:Subject:From;
        b=ldLwEkbOPvId1SGhV49JymfWZJ4wtC1cB1ISU8VtHRd6mgfBM4VJqByD8C6rSfEl+
         oVMB5vsm8ffgDNJ8ydcbfH7o+aK9pRJ87QDnxtGspc3bcNUImPb403UxwDmtZ9gxI0
         xWZ02PpOSKMaL1k5I71nBxuM6Fi6+loXhYHI/KSULt3RYJXHfJjHFqGToS6IVgyr3/
         u+35JFk1nXXWx3QzmGK3dWZtldE9q5qfHMkzG7jHVGPYNEj762Pj/0A+cl50FISavT
         fQLC1i3yqJGcn2DQIbv2XpJ56P7irz1XT9i9pGTQA2xFOAIALi05rhVUGuxD7eENhY
         +8pUG/+qSzZUg==
Date:   Tue, 7 Mar 2023 16:22:39 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] wifi: ath11k: Replace fake flex-array with
 flexible-array member
Message-ID: <ZAe5L5DtmsQxzqRH@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays as fake flexible arrays are deprecated and we are
moving towards adopting C99 flexible-array members instead.

Address 25 of the following warnings found with GCC-13 and
-fstrict-flex-arrays=3 enabled:
drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c:30:51: warning: array subscript <unknown> is outside array bounds of ‘const u32[0]’ {aka ‘const unsigned int[]’} [-Warray-bounds=]

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/266
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 .../wireless/ath/ath11k/debugfs_htt_stats.h   | 50 +++++++++----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h
index 2b97cbbd28cb..db5c176e2e5b 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h
+++ b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h
@@ -143,7 +143,7 @@ enum htt_tx_pdev_underrun_enum {
 /* Bytes stored in little endian order */
 /* Length should be multiple of DWORD */
 struct htt_stats_string_tlv {
-	u32 data[0]; /* Can be variable length */
+	DECLARE_FLEX_ARRAY(u32, data); /* Can be variable length */
 } __packed;
 
 #define HTT_STATS_MAC_ID	GENMASK(7, 0)
@@ -205,27 +205,27 @@ struct htt_tx_pdev_stats_cmn_tlv {
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_tx_pdev_stats_urrn_tlv_v {
-	u32 urrn_stats[0]; /* HTT_TX_PDEV_MAX_URRN_STATS */
+	DECLARE_FLEX_ARRAY(u32, urrn_stats); /* HTT_TX_PDEV_MAX_URRN_STATS */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_tx_pdev_stats_flush_tlv_v {
-	u32 flush_errs[0]; /* HTT_TX_PDEV_MAX_FLUSH_REASON_STATS */
+	DECLARE_FLEX_ARRAY(u32, flush_errs); /* HTT_TX_PDEV_MAX_FLUSH_REASON_STATS */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_tx_pdev_stats_sifs_tlv_v {
-	u32 sifs_status[0]; /* HTT_TX_PDEV_MAX_SIFS_BURST_STATS */
+	DECLARE_FLEX_ARRAY(u32, sifs_status); /* HTT_TX_PDEV_MAX_SIFS_BURST_STATS */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_tx_pdev_stats_phy_err_tlv_v {
-	u32  phy_errs[0]; /* HTT_TX_PDEV_MAX_PHY_ERR_STATS */
+	DECLARE_FLEX_ARRAY(u32, phy_errs); /* HTT_TX_PDEV_MAX_PHY_ERR_STATS */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_tx_pdev_stats_sifs_hist_tlv_v {
-	u32 sifs_hist_status[0]; /* HTT_TX_PDEV_SIFS_BURST_HIST_STATS */
+	DECLARE_FLEX_ARRAY(u32, sifs_hist_status); /* HTT_TX_PDEV_SIFS_BURST_HIST_STATS */
 };
 
 struct htt_tx_pdev_stats_tx_ppdu_stats_tlv_v {
@@ -591,19 +591,19 @@ struct htt_tx_hwq_difs_latency_stats_tlv_v {
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_tx_hwq_cmd_result_stats_tlv_v {
 	/* Histogram of sched cmd result */
-	u32 cmd_result[0]; /* HTT_TX_HWQ_MAX_CMD_RESULT_STATS */
+	DECLARE_FLEX_ARRAY(u32, cmd_result); /* HTT_TX_HWQ_MAX_CMD_RESULT_STATS */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_tx_hwq_cmd_stall_stats_tlv_v {
 	/* Histogram of various pause conitions */
-	u32 cmd_stall_status[0]; /* HTT_TX_HWQ_MAX_CMD_STALL_STATS */
+	DECLARE_FLEX_ARRAY(u32, cmd_stall_status); /* HTT_TX_HWQ_MAX_CMD_STALL_STATS */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_tx_hwq_fes_result_stats_tlv_v {
 	/* Histogram of number of user fes result */
-	u32 fes_result[0]; /* HTT_TX_HWQ_MAX_FES_RESULT_STATS */
+	DECLARE_FLEX_ARRAY(u32, fes_result); /* HTT_TX_HWQ_MAX_FES_RESULT_STATS */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size
@@ -636,7 +636,7 @@ struct htt_tx_hwq_tried_mpdu_cnt_hist_tlv_v {
  */
 struct htt_tx_hwq_txop_used_cnt_hist_tlv_v {
 	/* Histogram of txop used cnt */
-	u32 txop_used_cnt_hist[0]; /* HTT_TX_HWQ_TXOP_USED_CNT_HIST */
+	DECLARE_FLEX_ARRAY(u32, txop_used_cnt_hist); /* HTT_TX_HWQ_TXOP_USED_CNT_HIST */
 };
 
 /* == TX SELFGEN STATS == */
@@ -804,17 +804,17 @@ struct htt_tx_pdev_mpdu_stats_tlv {
 /* == TX SCHED STATS == */
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_sched_txq_cmd_posted_tlv_v {
-	u32 sched_cmd_posted[0]; /* HTT_TX_PDEV_SCHED_TX_MODE_MAX */
+	DECLARE_FLEX_ARRAY(u32, sched_cmd_posted); /* HTT_TX_PDEV_SCHED_TX_MODE_MAX */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_sched_txq_cmd_reaped_tlv_v {
-	u32 sched_cmd_reaped[0]; /* HTT_TX_PDEV_SCHED_TX_MODE_MAX */
+	DECLARE_FLEX_ARRAY(u32, sched_cmd_reaped); /* HTT_TX_PDEV_SCHED_TX_MODE_MAX */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_sched_txq_sched_order_su_tlv_v {
-	u32 sched_order_su[0]; /* HTT_TX_PDEV_NUM_SCHED_ORDER_LOG */
+	DECLARE_FLEX_ARRAY(u32, sched_order_su); /* HTT_TX_PDEV_NUM_SCHED_ORDER_LOG */
 };
 
 enum htt_sched_txq_sched_ineligibility_tlv_enum {
@@ -842,7 +842,7 @@ enum htt_sched_txq_sched_ineligibility_tlv_enum {
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_sched_txq_sched_ineligibility_tlv_v {
 	/* indexed by htt_sched_txq_sched_ineligibility_tlv_enum */
-	u32 sched_ineligibility[0];
+	DECLARE_FLEX_ARRAY(u32, sched_ineligibility);
 };
 
 #define	HTT_TX_PDEV_STATS_SCHED_PER_TXQ_MAC_ID	GENMASK(7, 0)
@@ -888,17 +888,17 @@ struct htt_stats_tx_sched_cmn_tlv {
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_tx_tqm_gen_mpdu_stats_tlv_v {
-	u32 gen_mpdu_end_reason[0]; /* HTT_TX_TQM_MAX_GEN_MPDU_END_REASON */
+	DECLARE_FLEX_ARRAY(u32, gen_mpdu_end_reason); /* HTT_TX_TQM_MAX_GEN_MPDU_END_REASON */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_tx_tqm_list_mpdu_stats_tlv_v {
-	u32 list_mpdu_end_reason[0]; /* HTT_TX_TQM_MAX_LIST_MPDU_END_REASON */
+	DECLARE_FLEX_ARRAY(u32, list_mpdu_end_reason); /* HTT_TX_TQM_MAX_LIST_MPDU_END_REASON */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_tx_tqm_list_mpdu_cnt_tlv_v {
-	u32 list_mpdu_cnt_hist[0];
+	DECLARE_FLEX_ARRAY(u32, list_mpdu_cnt_hist);
 			/* HTT_TX_TQM_MAX_LIST_MPDU_CNT_HISTOGRAM_BINS */
 };
 
@@ -1098,7 +1098,7 @@ struct htt_tx_de_compl_stats_tlv {
  *                               ENTRIES_PER_BIN_COUNT)
  */
 struct htt_tx_de_fw2wbm_ring_full_hist_tlv {
-	u32 fw2wbm_ring_full_hist[0];
+	DECLARE_FLEX_ARRAY(u32, fw2wbm_ring_full_hist);
 };
 
 struct htt_tx_de_cmn_stats_tlv {
@@ -1151,7 +1151,7 @@ struct htt_ring_if_cmn_tlv {
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_sfm_client_user_tlv_v {
 	/* Number of DWORDS used per user and per client */
-	u32 dwords_used_by_user_n[0];
+	DECLARE_FLEX_ARRAY(u32, dwords_used_by_user_n);
 };
 
 struct htt_sfm_client_tlv {
@@ -1436,12 +1436,12 @@ struct htt_rx_soc_fw_stats_tlv {
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_rx_soc_fw_refill_ring_empty_tlv_v {
-	u32 refill_ring_empty_cnt[0]; /* HTT_RX_STATS_REFILL_MAX_RING */
+	DECLARE_FLEX_ARRAY(u32, refill_ring_empty_cnt); /* HTT_RX_STATS_REFILL_MAX_RING */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_rx_soc_fw_refill_ring_num_refill_tlv_v {
-	u32 refill_ring_num_refill[0]; /* HTT_RX_STATS_REFILL_MAX_RING */
+	DECLARE_FLEX_ARRAY(u32, refill_ring_num_refill); /* HTT_RX_STATS_REFILL_MAX_RING */
 };
 
 /* RXDMA error code from WBM released packets */
@@ -1473,7 +1473,7 @@ enum htt_rx_rxdma_error_code_enum {
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_rx_soc_fw_refill_ring_num_rxdma_err_tlv_v {
-	u32 rxdma_err[0]; /* HTT_RX_RXDMA_MAX_ERR_CODE */
+	DECLARE_FLEX_ARRAY(u32, rxdma_err); /* HTT_RX_RXDMA_MAX_ERR_CODE */
 };
 
 /* REO error code from WBM released packets */
@@ -1505,7 +1505,7 @@ enum htt_rx_reo_error_code_enum {
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_rx_soc_fw_refill_ring_num_reo_err_tlv_v {
-	u32 reo_err[0]; /* HTT_RX_REO_MAX_ERR_CODE */
+	DECLARE_FLEX_ARRAY(u32, reo_err); /* HTT_RX_REO_MAX_ERR_CODE */
 };
 
 /* == RX PDEV STATS == */
@@ -1622,13 +1622,13 @@ struct htt_rx_pdev_fw_stats_phy_err_tlv {
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_rx_pdev_fw_ring_mpdu_err_tlv_v {
 	/* Num error MPDU for each RxDMA error type  */
-	u32 fw_ring_mpdu_err[0]; /* HTT_RX_STATS_RXDMA_MAX_ERR */
+	DECLARE_FLEX_ARRAY(u32, fw_ring_mpdu_err); /* HTT_RX_STATS_RXDMA_MAX_ERR */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
 struct htt_rx_pdev_fw_mpdu_drop_tlv_v {
 	/* Num MPDU dropped  */
-	u32 fw_mpdu_drop[0]; /* HTT_RX_STATS_FW_DROP_REASON_MAX */
+	DECLARE_FLEX_ARRAY(u32, fw_mpdu_drop); /* HTT_RX_STATS_FW_DROP_REASON_MAX */
 };
 
 #define HTT_PDEV_CCA_STATS_TX_FRAME_INFO_PRESENT               (0x1)
-- 
2.34.1

