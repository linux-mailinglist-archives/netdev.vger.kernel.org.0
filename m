Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CBD2B693A
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 16:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgKQP7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 10:59:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbgKQP7J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 10:59:09 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2030238E6;
        Tue, 17 Nov 2020 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605628748;
        bh=OeZuhpRt7mealRHY0C4vDv9bs04SbwLGlMifQU9q21Q=;
        h=Date:From:To:Cc:Subject:From;
        b=iXspfp0YYZB3UouRnWw9JZQ4X+0k4ynTPNvptBdnPZdooEs7Qvz8Xi8N/guy5w9Sz
         LeqRFFspORqE9S0+xSjjhyf4JpkTVTyvhdUADPX98zPocReedbjiwQ3YdcTLb8dHqT
         TtWCpNpgcttz5lIaPjH/9YbnCjGKqFjwYZcyvxJA=
Date:   Tue, 17 Nov 2020 09:59:04 -0600
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
Subject: [PATCH][next] iwlwifi: dvm: Fix fall-through warnings for Clang
Message-ID: <20201117155904.GA14551@embeddedor>
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
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c       | 6 +++---
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c     | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c       | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 423d3c396b2d..75e7665773c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -619,7 +619,7 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-		/* fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 9d55ece05020..dd251190f68e 100644
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
index 832fcbb787e9..c4ecf6ed2186 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
@@ -405,7 +405,7 @@ static u16 iwl_limit_dwell(struct iwl_priv *priv, u16 dwell_time)
 		limit = (limits[1] * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
 		limit /= 2;
 		dwell_time = min(limit, dwell_time);
-		/* fall through */
+		fallthrough;
 	case 1:
 		limit = (limits[0] * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
 		limit /= n_active;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
index e622948661fa..ddc14059b07d 100644
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
index e3962bb52328..847b8e07f81c 100644
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
-- 
2.27.0

