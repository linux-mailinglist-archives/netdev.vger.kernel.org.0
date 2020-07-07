Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4782179A7
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgGGUol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 16:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgGGUol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 16:44:41 -0400
Received: from embeddedor (unknown [200.39.26.250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E3AE206BE;
        Tue,  7 Jul 2020 20:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594154680;
        bh=tJBEwIuAEjIsyirFdQYzQ0iGOP0Xcox8l2SwuHIBd0Y=;
        h=Date:From:To:Cc:Subject:From;
        b=gaFKrSmxLBiJd3SPNCFwyYnAqbgfCL44BAHh97Ik5SMXqsArwRdO+F4FUa94Aht36
         kNhe7PlE4sH5KbxpIuhcp46H3jblGZK8pqA1YjQ3KgMvIHSbnHCes1Ihnk2EZH6CN5
         36/iEnbk2SspHjWu4raBIv2WAN7elFoGQWvJ3rXM=
Date:   Tue, 7 Jul 2020 15:50:05 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] iwlwifi: Use fallthrough pseudo-keyword
Message-ID: <20200707205005.GA11619@embeddedor>
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

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c       |    6 +++---
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c     |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c      |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c      |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c      |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     |    8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |   10 +++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |    4 ++--
 15 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 6512d25e3563..9ffcd0ec4116 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -618,7 +618,7 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-		/* fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 673d60784bfa..e16589018ebb 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -582,7 +582,7 @@ static int iwlagn_set_decrypted_flag(struct iwl_priv *priv,
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_BAD_KEY_TTAK)
 			break;
-		/* fall through */
+		fallthrough;
 	case RX_RES_STATUS_SEC_TYPE_WEP:
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_BAD_ICV_MIC) {
@@ -591,7 +591,7 @@ static int iwlagn_set_decrypted_flag(struct iwl_priv *priv,
 			IWL_DEBUG_RX(priv, "Packet destroyed\n");
 			return -1;
 		}
-		/* fall through */
+		fallthrough;
 	case RX_RES_STATUS_SEC_TYPE_CCMP:
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_DECRYPT_OK) {
@@ -720,7 +720,7 @@ static u32 iwlagn_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
 			decrypt_out |= RX_RES_STATUS_BAD_KEY_TTAK;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		if (!(decrypt_in & RX_MPDU_RES_STATUS_ICV_OK))
 			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
index 1d8590046ff7..0eecc2afcf4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
@@ -406,7 +406,7 @@ static u16 iwl_limit_dwell(struct iwl_priv *priv, u16 dwell_time)
 		limit = (limits[1] * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
 		limit /= 2;
 		dwell_time = min(limit, dwell_time);
-		/* fall through */
+		fallthrough;
 	case 1:
 		limit = (limits[0] * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
 		limit /= n_active;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
index 51158edce15b..d49c46914275 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
@@ -1109,7 +1109,7 @@ static int iwlagn_send_sta_key(struct iwl_priv *priv,
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
 		key_flags |= STA_KEY_FLG_KEY_SIZE_MSK;
-		/* fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_WEP40:
 		key_flags |= STA_KEY_FLG_WEP;
 		memcpy(&sta_cmd.key.key[3], keyconf->key, keyconf->keylen);
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
index fd454836adbe..52c682dd5957 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -210,7 +210,7 @@ static void iwlagn_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 
 	case WLAN_CIPHER_SUITE_WEP104:
 		tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
-		/* fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_WEP40:
 		tx_cmd->sec_ctl |= (TX_CMD_SEC_WEP |
 			(keyconf->keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 04f14bfdd091..1a7bc29d1a72 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1561,7 +1561,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		break;
 	default:
 		WARN(1, "Invalid fw type %d\n", fw->type);
-		/* fall through */
+		fallthrough;
 	case IWL_FW_MVM:
 		op = &iwlwifi_opmode_table[MVM_OP_MODE];
 		break;
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
index b78992e341d5..4581edcecd64 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -289,7 +289,7 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	case NL80211_IFTYPE_STATION:
 		if (!vif->p2p)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		__clear_bit(0, data.available_mac_ids);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 77916231ff7d..6ca21e39fe68 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4051,7 +4051,7 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 			mvmvif->ap_ibss_active = true;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_ADHOC:
 		/*
 		 * The AP binding flow is handled as part of the start_ap flow
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index 0243dbe8ac49..103294969a26 100644
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
index 77b8def26edb..9cf4c8e12a82 100644
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
index c15f7dbc9516..78f4cc11e2eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -354,7 +354,7 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			stats->flag |= RX_FLAG_MMIC_ERROR;
 
 		*crypt_len = IEEE80211_TKIP_IV_LEN;
-		/* fall through */
+		fallthrough;
 	case IWL_RX_MPDU_STATUS_SEC_WEP:
 		if (!(status & IWL_RX_MPDU_STATUS_ICV_OK))
 			return -1;
@@ -1275,7 +1275,7 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d2,
 							    IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE4),
 					      IEEE80211_RADIOTAP_HE_DATA4_TB_SPTL_REUSE4);
-		/* fall through */
+		fallthrough;
 	case IWL_RX_PHY_INFO_TYPE_HE_SU:
 	case IWL_RX_PHY_INFO_TYPE_HE_MU:
 	case IWL_RX_PHY_INFO_TYPE_HE_MU_EXT:
@@ -1348,7 +1348,7 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 						       IWL_RX_PHY_DATA4_HE_MU_EXT_PREAMBLE_PUNC_TYPE_MASK),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW);
 		iwl_mvm_decode_he_mu_ext(mvm, phy_data, rate_n_flags, he_mu);
-		/* fall through */
+		fallthrough;
 	case IWL_RX_PHY_INFO_TYPE_HE_MU:
 		he_mu->flags2 |=
 			le16_encode_bits(le32_get_bits(phy_data->d1,
@@ -1358,7 +1358,7 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 			le16_encode_bits(le32_get_bits(phy_data->d1,
 						       IWL_RX_PHY_DATA1_HE_MU_SIGB_COMPRESSION),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_COMP);
-		/* fall through */
+		fallthrough;
 	case IWL_RX_PHY_INFO_TYPE_HE_TB:
 	case IWL_RX_PHY_INFO_TYPE_HE_TB_EXT:
 		iwl_mvm_decode_he_phy_ru_alloc(phy_data, rate_n_flags,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 51a061b138ba..04ee18e565ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2149,7 +2149,7 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 		/* Something is wrong if no scan was running but we
 		 * ran out of scans.
 		 */
-		/* fall through */
+		fallthrough;
 	default:
 		WARN_ON(1);
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index fee01cbbd3ac..bed5c5bd67cf 100644
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
@@ -3268,14 +3268,14 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
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
index 2f6484e0d726..b536e04a35e6 100644
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

