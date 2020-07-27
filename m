Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C1A22F933
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgG0TiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:38:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728436AbgG0TiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 15:38:23 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4720220738;
        Mon, 27 Jul 2020 19:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595878703;
        bh=Wq926jdm0qwwvAC3QIT0XJ7thvtdaun3hyPXfStCGm0=;
        h=Date:From:To:Cc:Subject:From;
        b=fxEOeMTuILuZD+uLNj6MiSlImq32eKs+LD3abs1ZtIdaQ+zahdlVncsVBlGsccf8D
         qyQOjLWhX2JUJB0gwA5QbCqVPF9B//B1hYAHL2jZZeJnDJoWgYrAAniHPpTxffelm5
         PYTgOxshxEmSeJNG4hgCdgBWC21ClS+dvwtRdtHg=
Date:   Mon, 27 Jul 2020 14:44:15 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] ath11k: Use fallthrough pseudo-keyword
Message-ID: <20200727194415.GA1275@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
fall-through markings when it is the case.

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c  |  2 +-
 drivers/net/wireless/ath/ath11k/dp.c    |  2 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c |  3 +--
 drivers/net/wireless/ath/ath11k/mac.c   | 22 +++++++++++-----------
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 905cd8beaf28..2fbcb2259fd9 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -706,7 +706,7 @@ static void ath11k_core_restart(struct work_struct *work)
 			break;
 		case ATH11K_STATE_RESTARTED:
 			ar->state = ATH11K_STATE_WEDGED;
-			/* fall through */
+			fallthrough;
 		case ATH11K_STATE_WEDGED:
 			ath11k_warn(ab,
 				    "device is wedged, will not restart radio %d\n", i);
diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index 1d64c3c51ac9..141a046b9269 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -159,7 +159,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 			break;
 		}
 		/* follow through when ring_num >= 3 */
-		/* fall through */
+		fallthrough;
 	case HAL_REO_EXCEPTION:
 	case HAL_REO_REINJECT:
 	case HAL_REO_CMD:
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 791d971784ce..97137507a0bd 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3709,8 +3709,7 @@ static bool ath11k_dp_rx_h_reo_err(struct ath11k *ar, struct sk_buff *msdu,
 		 * instead, it is good to drop such packets in mac80211
 		 * after incrementing the replay counters.
 		 */
-
-		/* fall through */
+		fallthrough;
 	default:
 		/* TODO: Review other errors and process them to mac80211
 		 * as appropriate.
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 07d3e031c75a..648eabadc094 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1138,13 +1138,13 @@ ath11k_peer_assoc_h_vht_limit(u16 tx_mcs_set,
 			idx_limit = -1;
 
 		switch (idx_limit) {
-		case 0: /* fall through */
-		case 1: /* fall through */
-		case 2: /* fall through */
-		case 3: /* fall through */
-		case 4: /* fall through */
-		case 5: /* fall through */
-		case 6: /* fall through */
+		case 0:
+		case 1:
+		case 2:
+		case 3:
+		case 4:
+		case 5:
+		case 6:
 		case 7:
 			mcs = IEEE80211_VHT_MCS_SUPPORT_0_7;
 			break;
@@ -1156,7 +1156,7 @@ ath11k_peer_assoc_h_vht_limit(u16 tx_mcs_set,
 			break;
 		default:
 			WARN_ON(1);
-			/* fall through */
+			fallthrough;
 		case -1:
 			mcs = IEEE80211_VHT_MCS_NOT_SUPPORTED;
 			break;
@@ -1339,7 +1339,7 @@ static void ath11k_peer_assoc_h_he(struct ath11k *ar,
 		arg->peer_he_tx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_160] = v;
 
 		arg->peer_he_mcs_count++;
-		/* fall through */
+		fallthrough;
 
 	default:
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.rx_mcs_80);
@@ -2114,7 +2114,7 @@ void __ath11k_mac_scan_finish(struct ath11k *ar)
 		} else if (ar->scan.roc_notify) {
 			ieee80211_remain_on_channel_expired(ar->hw);
 		}
-		/* fall through */
+		fallthrough;
 	case ATH11K_SCAN_STARTING:
 		ar->scan.state = ATH11K_SCAN_IDLE;
 		ar->scan_channel = NULL;
@@ -4368,7 +4368,7 @@ static int ath11k_mac_op_add_interface(struct ieee80211_hw *hw,
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		arvif->vdev_subtype = WMI_VDEV_SUBTYPE_MESH_11S;
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_AP:
 		arvif->vdev_type = WMI_VDEV_TYPE_AP;
 		break;
-- 
2.27.0

