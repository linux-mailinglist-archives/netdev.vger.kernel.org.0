Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE5D695EDF
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjBNJVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjBNJV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:21:27 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6D23599;
        Tue, 14 Feb 2023 01:21:25 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id g6-20020a05600c310600b003e1f6dff952so524130wmo.1;
        Tue, 14 Feb 2023 01:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qGBo33gA3VOs4P7ZpdD1DTo4eRF/BVq4idcUn6bf9Wg=;
        b=YTi+mTeDZ0inBBZTj11TBffIo5BxmwujJE9SsJF0OrTeLWQP2cwYGm8Qy0JS6N0vIR
         69iyyb8XDeMTJ+9q2iy5taCFnQMLEZS6Q/7PPsQzvEVldgadBDIESOgfar91QEYw7cjr
         qWzdBnUM7A4erGwWdpM/jnX7x2WEL4HXdCid24CpC0bFOYGvsbMu6YGyriv7/zO73MTL
         2VsDbK9RQaBLyElXJI6hegDyBBNsKSA9DeeWxIIAPxRbDwjIMW0MCjSF5DF1CBudmPMD
         8ThGlvGg2XG2ZLcaTEhKr4QScUsRwwiY1YKkbgXdSEjOlIUNS5YMwgWT1bKaDYb0IE0O
         czRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qGBo33gA3VOs4P7ZpdD1DTo4eRF/BVq4idcUn6bf9Wg=;
        b=ayD+Z74nEOtVgPSwlJniLpt6GwqgKDn5Kng6sEFA+v5S6R9LLxeJ/82A8IadZ9fr/7
         u7U95JaxuQ3uRK84BC8rxA8FngwfU045jujckEsIww2SffgvatnYf6s++9EpNTQS8pKb
         d0UAE4xVOtOjGy8NfPFcvhIB8dafvVRoRbh19Q6dBEQ5/K75n8ThZoITnYD1RG+HiEpF
         bCSMxWSuHij/6aBUUXYHhFINKkznqVRiQWK0a2y2XaIEUJz5tWbgwRiyClqZl976uYwc
         rr4+4b5sBIPDv4j0mVnUYrmOfEIG1f+SrDpYGD0j0cya6WWb++oLXqnme+1U+CK5ep52
         J6DA==
X-Gm-Message-State: AO0yUKVkaINFwivpA8P7Dho43IKyieMIle8mBnbYSgUU3BePvlrinPka
        gIZ6LQTlJhi5vAK0FKMnuxA=
X-Google-Smtp-Source: AK7set+gdde3GoKEGyrlYLiotkZWRCDdhXo8Z4TIlvlDoISOV/Q4Fg17bkgOpeltxU8b0+TCwH3Z2w==
X-Received: by 2002:a05:600c:4a9a:b0:3dd:1b6f:4f30 with SMTP id b26-20020a05600c4a9a00b003dd1b6f4f30mr1445880wmp.3.1676366483781;
        Tue, 14 Feb 2023 01:21:23 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id bg23-20020a05600c3c9700b003dd1bd66e0dsm18364033wmb.3.2023.02.14.01.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 01:21:23 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] wifi: ath12k: Fix spelling mistakes in warning messages and comments
Date:   Tue, 14 Feb 2023 09:21:22 +0000
Message-Id: <20230214092122.265336-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are quite a few spelling mistakes in warning messages and a lot
of the comments. Fix these.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/ath/ath12k/ce.c       |  2 +-
 drivers/net/wireless/ath/ath12k/core.h     |  2 +-
 drivers/net/wireless/ath/ath12k/dp.c       |  2 +-
 drivers/net/wireless/ath/ath12k/dp.h       |  6 +++---
 drivers/net/wireless/ath/ath12k/dp_mon.c   | 10 +++++-----
 drivers/net/wireless/ath/ath12k/dp_rx.c    |  8 ++++----
 drivers/net/wireless/ath/ath12k/hal.c      |  2 +-
 drivers/net/wireless/ath/ath12k/hal.h      | 12 ++++++------
 drivers/net/wireless/ath/ath12k/hal_desc.h | 10 +++++-----
 drivers/net/wireless/ath/ath12k/rx_desc.h  |  2 +-
 drivers/net/wireless/ath/ath12k/wmi.c      |  6 +++---
 drivers/net/wireless/ath/ath12k/wmi.h      |  4 ++--
 12 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ce.c b/drivers/net/wireless/ath/ath12k/ce.c
index aed6987804bf..be0d669d31fc 100644
--- a/drivers/net/wireless/ath/ath12k/ce.c
+++ b/drivers/net/wireless/ath/ath12k/ce.c
@@ -946,7 +946,7 @@ int ath12k_ce_alloc_pipes(struct ath12k_base *ab)
 
 		ret = ath12k_ce_alloc_pipe(ab, i);
 		if (ret) {
-			/* Free any parial successful allocation */
+			/* Free any partial successful allocation */
 			ath12k_ce_free_pipes(ab);
 			return ret;
 		}
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index a54ae74543c1..dffa687ee40e 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -691,7 +691,7 @@ struct ath12k_base {
 
 	/* Below regd's are protected by ab->data_lock */
 	/* This is the regd set for every radio
-	 * by the firmware during initializatin
+	 * by the firmware during initialization
 	 */
 	struct ieee80211_regdomain *default_regd[MAX_RADIOS];
 	/* This regd is set during dynamic country setting
diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index eb0261500ab0..9926d81c5fe4 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1429,7 +1429,7 @@ static int ath12k_dp_cc_init(struct ath12k_base *ab)
 		}
 
 		if (dp->spt_info[i].paddr & ATH12K_SPT_4K_ALIGN_CHECK) {
-			ath12k_warn(ab, "SPT allocated memoty is not 4K aligned");
+			ath12k_warn(ab, "SPT allocated memory is not 4K aligned");
 			ret = -EINVAL;
 			goto free;
 		}
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 36a876d7f61d..7c5dafce5a68 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -371,7 +371,7 @@ struct ath12k_dp {
 
 #define HTT_TX_WBM_COMP_STATUS_OFFSET 8
 
-/* HTT tx completion is overlayed in wbm_release_ring */
+/* HTT tx completion is overlaid in wbm_release_ring */
 #define HTT_TX_WBM_COMP_INFO0_STATUS		GENMASK(16, 13)
 #define HTT_TX_WBM_COMP_INFO1_REINJECT_REASON	GENMASK(3, 0)
 #define HTT_TX_WBM_COMP_INFO1_EXCEPTION_FRAME	BIT(4)
@@ -545,7 +545,7 @@ enum htt_srng_ring_id {
  *                     3'b010: 4 usec
  *                     3'b011: 8 usec (default)
  *                     3'b100: 16 usec
- *                     Others: Reserverd
+ *                     Others: Reserved
  *           b'19    - response_required:
  *                     Host needs HTT_T2H_MSG_TYPE_SRING_SETUP_DONE as response
  *           b'20:31 - reserved:  reserved for future use
@@ -1126,7 +1126,7 @@ struct htt_tx_ring_selection_cfg_cmd {
 	__le32 tlv_filter_mask_in1;
 	__le32 tlv_filter_mask_in2;
 	__le32 tlv_filter_mask_in3;
-	__le32 reserverd[3];
+	__le32 reserved[3];
 } __packed;
 
 #define HTT_TX_RING_TLV_FILTER_MGMT_DMA_LEN	GENMASK(3, 0)
diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index a214797c96a2..4f93e4c95fed 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -813,7 +813,7 @@ ath12k_dp_mon_rx_parse_status_tlv(struct ath12k_base *ab,
 		spin_unlock_bh(&buf_ring->idr_lock);
 
 		if (unlikely(!msdu)) {
-			ath12k_warn(ab, "montior destination with invalid buf_id %d\n",
+			ath12k_warn(ab, "monitor destination with invalid buf_id %d\n",
 				    buf_id);
 			return HAL_RX_MON_STATUS_PPDU_NOT_DONE;
 		}
@@ -1124,7 +1124,7 @@ static void ath12k_dp_mon_rx_deliver_msdu(struct ath12k *ar, struct napi_struct
 
 	/* PN for multicast packets are not validate in HW,
 	 * so skip 802.3 rx path
-	 * Also, fast_rx expectes the STA to be authorized, hence
+	 * Also, fast_rx expects the STA to be authorized, hence
 	 * eapol packets are sent in slow path.
 	 */
 	if (decap == DP_RX_DECAP_TYPE_ETHERNET2_DIX && !is_eapol_tkip &&
@@ -1917,7 +1917,7 @@ ath12k_dp_mon_tx_parse_status_tlv(struct ath12k_base *ab,
 		spin_unlock_bh(&buf_ring->idr_lock);
 
 		if (unlikely(!msdu)) {
-			ath12k_warn(ab, "montior destination with invalid buf_id %d\n",
+			ath12k_warn(ab, "monitor destination with invalid buf_id %d\n",
 				    buf_id);
 			return DP_MON_TX_STATUS_PPDU_NOT_DONE;
 		}
@@ -2110,7 +2110,7 @@ int ath12k_dp_mon_srng_process(struct ath12k *ar, int mac_id, int *budget,
 		spin_unlock_bh(&buf_ring->idr_lock);
 
 		if (unlikely(!skb)) {
-			ath12k_warn(ab, "montior destination with invalid buf_id %d\n",
+			ath12k_warn(ab, "monitor destination with invalid buf_id %d\n",
 				    buf_id);
 			goto move_next;
 		}
@@ -2511,7 +2511,7 @@ int ath12k_dp_mon_rx_process_stats(struct ath12k *ar, int mac_id,
 		spin_unlock_bh(&buf_ring->idr_lock);
 
 		if (unlikely(!skb)) {
-			ath12k_warn(ab, "montior destination with invalid buf_id %d\n",
+			ath12k_warn(ab, "monitor destination with invalid buf_id %d\n",
 				    buf_id);
 			goto move_next;
 		}
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 83a43ad48c51..eb67b3409f85 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2443,7 +2443,7 @@ static void ath12k_dp_rx_deliver_msdu(struct ath12k *ar, struct napi_struct *nap
 
 	/* PN for multicast packets are not validate in HW,
 	 * so skip 802.3 rx path
-	 * Also, fast_rx expectes the STA to be authorized, hence
+	 * Also, fast_rx expects the STA to be authorized, hence
 	 * eapol packets are sent in slow path.
 	 */
 	if (decap == DP_RX_DECAP_TYPE_ETHERNET2_DIX && !is_eapol &&
@@ -2611,7 +2611,7 @@ int ath12k_dp_rx_process(struct ath12k_base *ab, int ring_id,
 		if (!desc_info) {
 			desc_info = ath12k_dp_get_rx_desc(ab, cookie);
 			if (!desc_info) {
-				ath12k_warn(ab, "Invalid cookie in manual desc retrival");
+				ath12k_warn(ab, "Invalid cookie in manual desc retrieval");
 				continue;
 			}
 		}
@@ -3297,7 +3297,7 @@ ath12k_dp_process_rx_err_buf(struct ath12k *ar, struct hal_reo_dest_ring *desc,
 	if (!desc_info) {
 		desc_info = ath12k_dp_get_rx_desc(ab, cookie);
 		if (!desc_info) {
-			ath12k_warn(ab, "Invalid cookie in manual desc retrival");
+			ath12k_warn(ab, "Invalid cookie in manual desc retrieval");
 			return -EINVAL;
 		}
 	}
@@ -3718,7 +3718,7 @@ int ath12k_dp_rx_process_wbm_err(struct ath12k_base *ab,
 		if (!desc_info) {
 			desc_info = ath12k_dp_get_rx_desc(ab, err_info.cookie);
 			if (!desc_info) {
-				ath12k_warn(ab, "Invalid cookie in manual desc retrival");
+				ath12k_warn(ab, "Invalid cookie in manual desc retrieval");
 				continue;
 			}
 		}
diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
index 95d04819083f..0ec53afe9915 100644
--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -609,7 +609,7 @@ static int ath12k_hal_srng_create_config_qcn9274(struct ath12k_base *ab)
 		HAL_WBM0_RELEASE_RING_BASE_LSB(ab);
 	s->reg_size[1] = HAL_WBM1_RELEASE_RING_HP - HAL_WBM0_RELEASE_RING_HP;
 
-	/* Some LMAC rings are not accesed from the host:
+	/* Some LMAC rings are not accessed from the host:
 	 * RXDMA_BUG, RXDMA_DST, RXDMA_MONITOR_BUF, RXDMA_MONITOR_STATUS,
 	 * RXDMA_MONITOR_DST, RXDMA_MONITOR_DESC, RXDMA_DIR_BUF_SRC,
 	 * RXDMA_RX_MONITOR_BUF, TX_MONITOR_BUF, TX_MONITOR_DST, SW2RXDMA
diff --git a/drivers/net/wireless/ath/ath12k/hal.h b/drivers/net/wireless/ath/ath12k/hal.h
index dfbd8bce70e5..0d4fa12ea622 100644
--- a/drivers/net/wireless/ath/ath12k/hal.h
+++ b/drivers/net/wireless/ath/ath12k/hal.h
@@ -270,7 +270,7 @@ struct ath12k_base;
 #define HAL_WBM_SW_COOKIE_CONV_CFG_WBM2SW4_EN		BIT(5)
 #define HAL_WBM_SW_COOKIE_CONV_CFG_GLOBAL_EN		BIT(8)
 
-/* TCL ring feild mask and offset */
+/* TCL ring field mask and offset */
 #define HAL_TCL1_RING_BASE_MSB_RING_SIZE		GENMASK(27, 8)
 #define HAL_TCL1_RING_BASE_MSB_RING_BASE_ADDR_MSB	GENMASK(7, 0)
 #define HAL_TCL1_RING_ID_ENTRY_SIZE			GENMASK(7, 0)
@@ -296,7 +296,7 @@ struct ath12k_base;
 #define HAL_TCL1_RING_FIELD_DSCP_TID_MAP6		GENMASK(20, 18)
 #define HAL_TCL1_RING_FIELD_DSCP_TID_MAP7		GENMASK(23, 21)
 
-/* REO ring feild mask and offset */
+/* REO ring field mask and offset */
 #define HAL_REO1_RING_BASE_MSB_RING_SIZE		GENMASK(27, 8)
 #define HAL_REO1_RING_BASE_MSB_RING_BASE_ADDR_MSB	GENMASK(7, 0)
 #define HAL_REO1_RING_ID_RING_ID			GENMASK(15, 8)
@@ -738,7 +738,7 @@ struct hal_srng {
 	} u;
 };
 
-/* Interrupt mitigation - Batch threshold in terms of numer of frames */
+/* Interrupt mitigation - Batch threshold in terms of number of frames */
 #define HAL_SRNG_INT_BATCH_THRESHOLD_TX 256
 #define HAL_SRNG_INT_BATCH_THRESHOLD_RX 128
 #define HAL_SRNG_INT_BATCH_THRESHOLD_OTHER 1
@@ -813,7 +813,7 @@ enum hal_rx_buf_return_buf_manager {
 #define HAL_REO_CMD_FLG_UNBLK_RESOURCE		BIT(7)
 #define HAL_REO_CMD_FLG_UNBLK_CACHE		BIT(8)
 
-/* Should be matching with HAL_REO_UPD_RX_QUEUE_INFO0_UPD_* feilds */
+/* Should be matching with HAL_REO_UPD_RX_QUEUE_INFO0_UPD_* fields */
 #define HAL_REO_CMD_UPD0_RX_QUEUE_NUM		BIT(8)
 #define HAL_REO_CMD_UPD0_VLD			BIT(9)
 #define HAL_REO_CMD_UPD0_ALDC			BIT(10)
@@ -838,7 +838,7 @@ enum hal_rx_buf_return_buf_manager {
 #define HAL_REO_CMD_UPD0_PN_VALID		BIT(29)
 #define HAL_REO_CMD_UPD0_PN			BIT(30)
 
-/* Should be matching with HAL_REO_UPD_RX_QUEUE_INFO1_* feilds */
+/* Should be matching with HAL_REO_UPD_RX_QUEUE_INFO1_* fields */
 #define HAL_REO_CMD_UPD1_VLD			BIT(16)
 #define HAL_REO_CMD_UPD1_ALDC			GENMASK(18, 17)
 #define HAL_REO_CMD_UPD1_DIS_DUP_DETECTION	BIT(19)
@@ -854,7 +854,7 @@ enum hal_rx_buf_return_buf_manager {
 #define HAL_REO_CMD_UPD1_PN_HANDLE_ENABLE	BIT(30)
 #define HAL_REO_CMD_UPD1_IGNORE_AMPDU_FLG	BIT(31)
 
-/* Should be matching with HAL_REO_UPD_RX_QUEUE_INFO2_* feilds */
+/* Should be matching with HAL_REO_UPD_RX_QUEUE_INFO2_* fields */
 #define HAL_REO_CMD_UPD2_SVLD			BIT(10)
 #define HAL_REO_CMD_UPD2_SSN			GENMASK(22, 11)
 #define HAL_REO_CMD_UPD2_SEQ_2K_ERR		BIT(23)
diff --git a/drivers/net/wireless/ath/ath12k/hal_desc.h b/drivers/net/wireless/ath/ath12k/hal_desc.h
index 2250ca2d19a3..6c17adc6d60b 100644
--- a/drivers/net/wireless/ath/ath12k/hal_desc.h
+++ b/drivers/net/wireless/ath/ath12k/hal_desc.h
@@ -706,7 +706,7 @@ struct rx_msdu_desc {
  *
  * msdu_continuation
  *		When set, this MSDU buffer was not able to hold the entire MSDU.
- *		The next buffer will therefor contain additional information
+ *		The next buffer will therefore contain additional information
  *		related to this MSDU.
  *
  * msdu_length
@@ -1294,7 +1294,7 @@ struct hal_tcl_data_cmd {
  *		link descriptor.
  *
  * tcl_cmd_type
- *		used to select the type of TCL Command decriptor
+ *		used to select the type of TCL Command descriptor
  *
  * desc_type
  *		Indicates the type of address provided in the buf_addr_info.
@@ -1408,7 +1408,7 @@ struct hal_tcl_data_cmd {
  * index_loop_override
  *		When set, address search and packet routing is forced to use
  *		'search_index' instead of following the register configuration
- *		seleced by Bank_id.
+ *		selected by Bank_id.
  *
  * ring_id
  *		The buffer pointer ring ID.
@@ -1990,7 +1990,7 @@ struct hal_wbm_release_ring {
  *	Producer: SW/TQM/RXDMA/REO/SWITCH
  *	Consumer: WBM/SW/FW
  *
- * HTT tx status is overlayed on wbm_release ring on 4-byte words 2, 3, 4 and 5
+ * HTT tx status is overlaid on wbm_release ring on 4-byte words 2, 3, 4 and 5
  * for software based completions.
  *
  * buf_addr_info
@@ -2552,7 +2552,7 @@ struct hal_reo_status_hdr {
  *		commands.
  *
  * execution_time (in us)
- *		The amount of time REO took to excecute the command. Note that
+ *		The amount of time REO took to execute the command. Note that
  *		this time does not include the duration of the command waiting
  *		in the command ring, before the execution started.
  *
diff --git a/drivers/net/wireless/ath/ath12k/rx_desc.h b/drivers/net/wireless/ath/ath12k/rx_desc.h
index 5feaff6450ad..f99556a253e5 100644
--- a/drivers/net/wireless/ath/ath12k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath12k/rx_desc.h
@@ -1072,7 +1072,7 @@ struct rx_msdu_end_qcn9274 {
  *
  * l4_offset
  *		Depending upon mode bit, this field either indicates the
- *		L4 offset nin bytes from the start of RX_HEADER (only valid
+ *		L4 offset in bytes from the start of RX_HEADER (only valid
  *		if either ipv4_proto or ipv6_proto is set to 1) or indicates
  *		the offset in bytes to the start of TCP or UDP header from
  *		the start of the IP header after decapsulation (Only valid if
diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index f6df14149531..3e6991120e53 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -494,7 +494,7 @@ ath12k_pull_mac_phy_cap_svc_ready_ext(struct ath12k_wmi_pdev *wmi_handle,
 
 	/* tx/rx chainmask reported from fw depends on the actual hw chains used,
 	 * For example, for 4x4 capable macphys, first 4 chains can be used for first
-	 * mac and the remaing 4 chains can be used for the second mac or vice-versa.
+	 * mac and the remaining 4 chains can be used for the second mac or vice-versa.
 	 * In this case, tx/rx chainmask 0xf will be advertised for first mac and 0xf0
 	 * will be advertised for second mac or vice-versa. Compute the shift value
 	 * for tx/rx chainmask which will be used to advertise supported ht/vht rates to
@@ -1743,7 +1743,7 @@ int ath12k_wmi_vdev_install_key(struct ath12k *ar,
 	int ret, len, key_len_aligned;
 
 	/* WMI_TAG_ARRAY_BYTE needs to be aligned with 4, the actual key
-	 * length is specifed in cmd->key_len.
+	 * length is specified in cmd->key_len.
 	 */
 	key_len_aligned = roundup(arg->key_len, 4);
 
@@ -5995,7 +5995,7 @@ static void ath12k_service_available_event(struct ath12k_base *ab, struct sk_buf
 	}
 
 	/* TODO: Use wmi_service_segment_offset information to get the service
-	 * especially when more services are advertised in multiple sevice
+	 * especially when more services are advertised in multiple service
 	 * available events.
 	 */
 	for (i = 0, j = WMI_MAX_SERVICE;
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index 84e3fb918e43..08a8c9e0f59f 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -4002,7 +4002,7 @@ struct ath12k_wmi_pdev_radar_event {
 } __packed;
 
 struct wmi_pdev_temperature_event {
-	/* temperature value in Celcius degree */
+	/* temperature value in Celsius degree */
 	a_sle32 temp;
 	__le32 pdev_id;
 } __packed;
@@ -4192,7 +4192,7 @@ enum wmi_sta_ps_param_tx_wake_threshold {
  */
 enum wmi_sta_ps_param_pspoll_count {
 	WMI_STA_PS_PSPOLL_COUNT_NO_MAX = 0,
-	/* Values greater than 0 indicate the maximum numer of PS-Poll frames
+	/* Values greater than 0 indicate the maximum number of PS-Poll frames
 	 * FW will send before waking up.
 	 */
 };
-- 
2.30.2

