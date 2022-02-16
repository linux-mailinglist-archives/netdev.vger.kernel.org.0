Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C345A4B917B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbiBPTlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:41:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237789AbiBPTlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:41:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637A82B04AB;
        Wed, 16 Feb 2022 11:41:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8755CE288B;
        Wed, 16 Feb 2022 19:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5529CC340E8;
        Wed, 16 Feb 2022 19:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645040457;
        bh=wETB63wkrW29pVFYDN5iqpi8/oDhPHZmrk8FQPS0BWs=;
        h=Date:From:To:Cc:Subject:From;
        b=ote3JCvMRwxXqsDm/YtHXL8w+ORYSsLHwssTRh5GDO5OWiRL4g51gYlhF78pQ41jR
         x7bq0RKH0ewLko5LxIkFuqTTwhcxohgkp8brgRhB4hWcC6GkezNR+mTdu9ArqCay8r
         NMPMwxQbWotYhGG8GWO9kJpc252HrW+BUqo6X75WYi4kwQFrilmU5N6M9Qr3gBAR9F
         hph5DKQfDKtuR3WFpBxeiv5Fi5N8XO6CNwOigFTSwC2GXxxfbJXt+rEnwopX0MV0kt
         lHkujyIrYA3C1566mrjxd1o7t0i1qgPqJL8zD/b77sgOdzJhPzP6bEf1PSBD2lmfCm
         UWRlckcB7+GLA==
Date:   Wed, 16 Feb 2022 13:48:36 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ath11k: Replace zero-length arrays with flexible-array
 members
Message-ID: <20220216194836.GA904035@embeddedor>
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
 drivers/net/wireless/ath/ath11k/ce.h       |  2 +-
 drivers/net/wireless/ath/ath11k/core.h     |  2 +-
 drivers/net/wireless/ath/ath11k/dp.h       | 10 +++++-----
 drivers/net/wireless/ath/ath11k/rx_desc.h  |  6 +++---
 drivers/net/wireless/ath/ath11k/spectral.c |  2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ce.h b/drivers/net/wireless/ath/ath11k/ce.h
index 8255b6cfab0c..9644ff909502 100644
--- a/drivers/net/wireless/ath/ath11k/ce.h
+++ b/drivers/net/wireless/ath/ath11k/ce.h
@@ -145,7 +145,7 @@ struct ath11k_ce_ring {
 	u32 hal_ring_id;
 
 	/* keep last */
-	struct sk_buff *skb[0];
+	struct sk_buff *skb[];
 };
 
 struct ath11k_ce_pipe {
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index 9e88ccca5ca7..e5cc007b6feb 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -806,7 +806,7 @@ struct ath11k_base {
 	} id;
 
 	/* must be last */
-	u8 drv_priv[0] __aligned(sizeof(void *));
+	u8 drv_priv[] __aligned(sizeof(void *));
 };
 
 struct ath11k_fw_stats_pdev {
diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index 409d6cc5a1d5..b644e4675818 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -1170,12 +1170,12 @@ struct ath11k_htt_ppdu_stats_msg {
 	u32 ppdu_id;
 	u32 timestamp;
 	u32 rsvd;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct htt_tlv {
 	u32 header;
-	u8 value[0];
+	u8 value[];
 } __packed;
 
 #define HTT_TLV_TAG			GENMASK(11, 0)
@@ -1362,7 +1362,7 @@ struct htt_ppdu_stats_usr_cmn_array {
 	 * tx_ppdu_stats_info is variable length, with length =
 	 *     number_of_ppdu_stats * sizeof (struct htt_tx_ppdu_stats_info)
 	 */
-	struct htt_tx_ppdu_stats_info tx_ppdu_info[0];
+	struct htt_tx_ppdu_stats_info tx_ppdu_info[];
 } __packed;
 
 struct htt_ppdu_user_stats {
@@ -1424,7 +1424,7 @@ struct htt_ppdu_stats_info {
  */
 struct htt_pktlog_msg {
 	u32 hdr;
-	u8 payload[0];
+	u8 payload[];
 };
 
 /**
@@ -1645,7 +1645,7 @@ struct ath11k_htt_extd_stats_msg {
 	u32 info0;
 	u64 cookie;
 	u32 info1;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #define	HTT_MAC_ADDR_L32_0	GENMASK(7, 0)
diff --git a/drivers/net/wireless/ath/ath11k/rx_desc.h b/drivers/net/wireless/ath/ath11k/rx_desc.h
index 79c50804d7dc..26ecc1bcd9d5 100644
--- a/drivers/net/wireless/ath/ath11k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath11k/rx_desc.h
@@ -1445,7 +1445,7 @@ struct hal_rx_desc_ipq8074 {
 	__le32 hdr_status_tag;
 	__le32 phy_ppdu_id;
 	u8 hdr_status[HAL_RX_DESC_HDR_STATUS_LEN];
-	u8 msdu_payload[0];
+	u8 msdu_payload[];
 } __packed;
 
 struct hal_rx_desc_qcn9074 {
@@ -1464,7 +1464,7 @@ struct hal_rx_desc_qcn9074 {
 	__le32 hdr_status_tag;
 	__le32 phy_ppdu_id;
 	u8 hdr_status[HAL_RX_DESC_HDR_STATUS_LEN];
-	u8 msdu_payload[0];
+	u8 msdu_payload[];
 } __packed;
 
 struct hal_rx_desc_wcn6855 {
@@ -1483,7 +1483,7 @@ struct hal_rx_desc_wcn6855 {
 	__le32 hdr_status_tag;
 	__le32 phy_ppdu_id;
 	u8 hdr_status[HAL_RX_DESC_HDR_STATUS_LEN];
-	u8 msdu_payload[0];
+	u8 msdu_payload[];
 } __packed;
 
 struct hal_rx_desc {
diff --git a/drivers/net/wireless/ath/ath11k/spectral.c b/drivers/net/wireless/ath/ath11k/spectral.c
index 4100cc1449a2..2b18871d5f7c 100644
--- a/drivers/net/wireless/ath/ath11k/spectral.c
+++ b/drivers/net/wireless/ath/ath11k/spectral.c
@@ -107,7 +107,7 @@ struct spectral_search_fft_report {
 	__le32 info1;
 	__le32 info2;
 	__le32 reserve0;
-	u8 bins[0];
+	u8 bins[];
 } __packed;
 
 struct ath11k_spectral_search_report {
-- 
2.27.0

