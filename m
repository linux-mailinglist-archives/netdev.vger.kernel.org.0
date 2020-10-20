Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA84293CBA
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406906AbgJTM7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:59:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406283AbgJTM7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 08:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603198752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Qw1F19yZpnDVsqc+HFG0m1crxeHycCzf6HaecBeRc7s=;
        b=X3Ugqf+dL8F6xthsh8xEzOI8D2eD/OUX0Xzl3L3mWSzE9x41MvtgwGVtqhRH8hKYtHR/Mx
        w0khEiYo4T8Awvmcod6q7C2z4rBP+o7SCjbzhx32znE/1MHrGwE2uBW5Y9wtinBopIZ9VJ
        nwVC6uYBCJrWPOE4Ax4QWQw/JlQF0sM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-HnzgmWsbMY26zKQyQOluXA-1; Tue, 20 Oct 2020 08:59:09 -0400
X-MC-Unique: HnzgmWsbMY26zKQyQOluXA-1
Received: by mail-qk1-f199.google.com with SMTP id x85so1625793qka.14
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 05:59:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Qw1F19yZpnDVsqc+HFG0m1crxeHycCzf6HaecBeRc7s=;
        b=jyxXBn2Dc0x8bTgQx+MYmH4Upy5RJNwzN1mQPD/IuadwS2sSRBsjRJG9nDqIJNb7rY
         6fZaXAYijExtoQAkdZCkASkpspI/sR+Yib2E05SiWr+PwlOxjAJA2inCWkaUDnQULH/5
         GH+SOrnS2yu6Vugl/XURja0XEm0Re5MRrMYLzLlQiZL7dyvq2vblWrIerrbQaI3WMqhR
         bEW2CzOYSRtre9Ee1sEwThr5SZyypnZts+kScnGQ8SoS5kDgAazc0+MGlC1BxzpULK5n
         o9YnvMGnzM4oe7Z6ziXziS1GGYQkZ3stX8vmfk0OIsFWgEhGhVCWmiACrj5Vl4OJWOx5
         U6ZA==
X-Gm-Message-State: AOAM530XM7UAQR/8/rNEGdn1lJiXwystNJUoQ6DjkqhDBEi+uL1Fgiha
        eKnyqhv+tIyfvyrQkZywT+iea47UGGW0BTucCUsnBCajgQzlbP2El5wm2gKpDd2k8tjsWJojHBW
        zof1uIcnokXs9ErHr
X-Received: by 2002:ac8:1ab4:: with SMTP id x49mr2308782qtj.39.1603198749167;
        Tue, 20 Oct 2020 05:59:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSYG8X66Ps2XgHiXhXkimRB74ySBTCmyKFNySnJWuGJUoj6A5ZTEg0bhWDVOn/3M0lAtzsnA==
X-Received: by 2002:ac8:1ab4:: with SMTP id x49mr2308752qtj.39.1603198748879;
        Tue, 20 Oct 2020 05:59:08 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id a128sm698132qkc.92.2020.10.20.05.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 05:59:07 -0700 (PDT)
From:   trix@redhat.com
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        ath9k-devel@qca.qualcomm.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, pkshih@realtek.com, lior2.cohen@intel.com,
        sara.sharon@intel.com, shahar.s.matityahu@intel.com,
        nathan.errera@intel.com, tova.mussai@intel.com,
        shaul.triebitz@intel.com, john@phrozen.org,
        Larry.Finger@lwfinger.net, christophe.jaillet@wanadoo.fr,
        zhengbin13@huawei.com, yanaijie@huawei.com, gustavoars@kernel.org,
        saurav.girepunje@gmail.com, joe@perches.com
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] wireless: remove unneeded break
Date:   Tue, 20 Oct 2020 05:58:41 -0700
Message-Id: <20201020125841.26791-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A break is not needed if it is preceded by a return

Signed-off-by: Tom Rix <trix@redhat.com>
---

v2: remove intersil/p54/eeprom.c

---
 drivers/net/wireless/ath/ath10k/htt_rx.c             | 1 -
 drivers/net/wireless/ath/ath6kl/testmode.c           | 1 -
 drivers/net/wireless/ath/ath9k/hw.c                  | 1 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c    | 2 --
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c  | 1 -
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c  | 1 -
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 3 ---
 7 files changed, 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 5c1af2021883..9c4e6cf2137a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -3878,7 +3878,6 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		return ath10k_htt_rx_proc_rx_frag_ind(htt,
 						      &resp->rx_frag_ind,
 						      skb);
-		break;
 	}
 	case HTT_T2H_MSG_TYPE_TEST:
 		break;
diff --git a/drivers/net/wireless/ath/ath6kl/testmode.c b/drivers/net/wireless/ath/ath6kl/testmode.c
index f3906dbe5495..89c7c4e25169 100644
--- a/drivers/net/wireless/ath/ath6kl/testmode.c
+++ b/drivers/net/wireless/ath/ath6kl/testmode.c
@@ -94,7 +94,6 @@ int ath6kl_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 		return 0;
 
-		break;
 	case ATH6KL_TM_CMD_RX_REPORT:
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6609ce122e6e..b66eeb577272 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2308,7 +2308,6 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 		ath_dbg(ath9k_hw_common(ah), BEACON,
 			"%s: unsupported opmode: %d\n", __func__, ah->opmode);
 		return;
-		break;
 	}
 
 	REG_WRITE(ah, AR_BEACON_PERIOD, beacon_period);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index cbdebefb854a..8698ca4d30de 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1202,13 +1202,11 @@ static int iwl_mvm_mac_ctx_send(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return iwl_mvm_mac_ctxt_cmd_sta(mvm, vif, action,
 						force_assoc_off,
 						bssid_override);
-		break;
 	case NL80211_IFTYPE_AP:
 		if (!vif->p2p)
 			return iwl_mvm_mac_ctxt_cmd_ap(mvm, vif, action);
 		else
 			return iwl_mvm_mac_ctxt_cmd_go(mvm, vif, action);
-		break;
 	case NL80211_IFTYPE_MONITOR:
 		return iwl_mvm_mac_ctxt_cmd_listener(mvm, vif, action);
 	case NL80211_IFTYPE_P2P_DEVICE:
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 63f9ea21962f..bd9160b166c5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -1226,7 +1226,6 @@ static int _rtl88ee_set_media_status(struct ieee80211_hw *hw,
 	default:
 		pr_err("Network type %d not support!\n", type);
 		return 1;
-		break;
 	}
 
 	/* MSR_INFRA == Link in infrastructure network;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index a36dc6e726d2..f8a1de6e9849 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -1132,7 +1132,6 @@ static int _rtl8723e_set_media_status(struct ieee80211_hw *hw,
 	default:
 		pr_err("Network type %d not support!\n", type);
 		return 1;
-		break;
 	}
 
 	/* MSR_INFRA == Link in infrastructure network;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index f41a7643b9c4..225b8cd44f23 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -2085,12 +2085,10 @@ bool rtl8812ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 		return __rtl8821ae_phy_config_with_headerfile(hw,
 				radioa_array_table_a, radioa_arraylen_a,
 				_rtl8821ae_config_rf_radio_a);
-		break;
 	case RF90_PATH_B:
 		return __rtl8821ae_phy_config_with_headerfile(hw,
 				radioa_array_table_b, radioa_arraylen_b,
 				_rtl8821ae_config_rf_radio_b);
-		break;
 	case RF90_PATH_C:
 	case RF90_PATH_D:
 		pr_err("switch case %#x not processed\n", rfpath);
@@ -2116,7 +2114,6 @@ bool rtl8821ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 		return __rtl8821ae_phy_config_with_headerfile(hw,
 			radioa_array_table, radioa_arraylen,
 			_rtl8821ae_config_rf_radio_a);
-		break;
 
 	case RF90_PATH_B:
 	case RF90_PATH_C:
-- 
2.18.1

