Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFF12B64F1
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 14:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbgKQNu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 08:50:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731050AbgKQNu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 08:50:58 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4D4C24199;
        Tue, 17 Nov 2020 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605621057;
        bh=C+5bG4KX3/fZGLs0+wIdBpnRG2mZUL+RUp21th58uXs=;
        h=Date:From:To:Cc:Subject:From;
        b=WUGfnv6OkDCxe5QIl45uawBGqaWIoCU7WWypvi4DsMvMH1rVJeP3kh7wtD3I2kS1m
         R+c+E0g61uvM94jeXzXvbH0r0mWRS6kBYEhjQ7laJZV2w0riwil0VcT1ba3bafklcV
         zWwB9/2AWoXgWqsSus+WNPyl/gKgJn7oOsA27Yow=
Date:   Tue, 17 Nov 2020 07:50:53 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] iwlwifi: mvm: Fix fall-through warnings for Clang
Message-ID: <20201117135053.GA13248@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly using the fallthrough pseudo-keyword as a
replacement for a number of "fall through" markings.

Notice that Clang doesn't recognize "fall through" comments as
implicit fall-through.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/led.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 10 +++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |  4 ++--
 9 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/led.c b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
index 72c4b2b8399d..6c910d681a92 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
@@ -115,7 +115,7 @@ int iwl_mvm_leds_init(struct iwl_mvm *mvm)
 	switch (mode) {
 	case IWL_LED_BLINK:
 		IWL_ERR(mvm, "Blink led mode not supported, used default\n");
-		/* fall through */
+		fallthrough;
 	case IWL_LED_DEFAULT:
 	case IWL_LED_RF_STATE:
 		mode = IWL_LED_RF_STATE;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 8698ca4d30de..5fa76ed09c37 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -287,7 +287,7 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	case NL80211_IFTYPE_STATION:
 		if (!vif->p2p)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		__clear_bit(0, data.available_mac_ids);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index b627e7da7ac9..77a14a2fc281 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4102,7 +4102,7 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 			mvmvif->ap_ibss_active = true;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_ADHOC:
 		/*
 		 * The AP binding flow is handled as part of the start_ap flow
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index bf2fc44dcb8d..5bbcc8f082c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -109,7 +109,7 @@ u8 iwl_mvm_get_ctrl_pos(struct cfg80211_chan_def *chandef)
 		return PHY_VHT_CTRL_POS_4_ABOVE;
 	default:
 		WARN(1, "Invalid channel definition");
-		/* fall through */
+		fallthrough;
 	case 0:
 		/*
 		 * The FW is expected to check the control channel position only
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 0059c83c2783..15ee8d2feaf7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -226,7 +226,7 @@ static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
 		    !(rx_pkt_status & RX_MPDU_RES_STATUS_TTAK_OK))
 			return 0;
 		*crypt_len = IEEE80211_TKIP_IV_LEN;
-		/* fall through */
+		fallthrough;
 
 	case RX_MPDU_RES_STATUS_SEC_WEP_ENC:
 		if (!(rx_pkt_status & RX_MPDU_RES_STATUS_ICV_OK))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 838734fec502..05edc02a0063 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -379,7 +379,7 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			stats->flag |= RX_FLAG_MMIC_ERROR;
 
 		*crypt_len = IEEE80211_TKIP_IV_LEN;
-		/* fall through */
+		fallthrough;
 	case IWL_RX_MPDU_STATUS_SEC_WEP:
 		if (!(status & IWL_RX_MPDU_STATUS_ICV_OK))
 			return -1;
@@ -1314,7 +1314,7 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d2,
 							    IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE4),
 					      IEEE80211_RADIOTAP_HE_DATA4_TB_SPTL_REUSE4);
-		/* fall through */
+		fallthrough;
 	case IWL_RX_PHY_INFO_TYPE_HE_SU:
 	case IWL_RX_PHY_INFO_TYPE_HE_MU:
 	case IWL_RX_PHY_INFO_TYPE_HE_MU_EXT:
@@ -1387,7 +1387,7 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 						       IWL_RX_PHY_DATA4_HE_MU_EXT_PREAMBLE_PUNC_TYPE_MASK),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW);
 		iwl_mvm_decode_he_mu_ext(mvm, phy_data, rate_n_flags, he_mu);
-		/* fall through */
+		fallthrough;
 	case IWL_RX_PHY_INFO_TYPE_HE_MU:
 		he_mu->flags2 |=
 			le16_encode_bits(le32_get_bits(phy_data->d1,
@@ -1397,7 +1397,7 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 			le16_encode_bits(le32_get_bits(phy_data->d1,
 						       IWL_RX_PHY_DATA1_HE_MU_SIGB_COMPRESSION),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_COMP);
-		/* fall through */
+		fallthrough;
 	case IWL_RX_PHY_INFO_TYPE_HE_TB:
 	case IWL_RX_PHY_INFO_TYPE_HE_TB_EXT:
 		iwl_mvm_decode_he_phy_ru_alloc(phy_data, rate_n_flags,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 875281cf7fc0..4b21f27bd19d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2148,7 +2148,7 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 		/* Something is wrong if no scan was running but we
 		 * ran out of scans.
 		 */
-		/* fall through */
+		fallthrough;
 	default:
 		WARN_ON(1);
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 799d8219463c..d2f2a95a34fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -144,13 +144,13 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	switch (sta->bandwidth) {
 	case IEEE80211_STA_RX_BW_160:
 		add_sta_cmd.station_flags |= cpu_to_le32(STA_FLG_FAT_EN_160MHZ);
-		/* fall through */
+		fallthrough;
 	case IEEE80211_STA_RX_BW_80:
 		add_sta_cmd.station_flags |= cpu_to_le32(STA_FLG_FAT_EN_80MHZ);
-		/* fall through */
+		fallthrough;
 	case IEEE80211_STA_RX_BW_40:
 		add_sta_cmd.station_flags |= cpu_to_le32(STA_FLG_FAT_EN_40MHZ);
-		/* fall through */
+		fallthrough;
 	case IEEE80211_STA_RX_BW_20:
 		if (sta->ht_cap.ht_supported)
 			add_sta_cmd.station_flags |=
@@ -3286,14 +3286,14 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_WEP_13BYTES);
-		/* fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_WEP40:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_WEP);
 		memcpy(u.cmd.common.key + 3, key->key, key->keylen);
 		break;
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_KEY_32BYTES);
-		/* fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_GCMP:
 		key_flags |= cpu_to_le16(STA_KEY_FLG_GCMP);
 		memcpy(u.cmd.common.key, key->key, key->keylen);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index fe1c538cd718..761e9e25c34b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -459,7 +459,7 @@ static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
 
 	case WLAN_CIPHER_SUITE_WEP104:
 		tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
-		/* fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_WEP40:
 		tx_cmd->sec_ctl |= TX_CMD_SEC_WEP |
 			((keyconf->keyidx << TX_CMD_SEC_WEP_KEY_IDX_POS) &
@@ -470,7 +470,7 @@ static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		type = TX_CMD_SEC_GCMP;
-		/* Fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_CCMP_256:
 		/* TODO: Taking the key from the table might introduce a race
 		 * when PTK rekeying is done, having an old packets with a PN
-- 
2.27.0

