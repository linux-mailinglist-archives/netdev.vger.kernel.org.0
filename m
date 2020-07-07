Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C5B217994
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgGGUkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 16:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbgGGUkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 16:40:25 -0400
Received: from embeddedor (unknown [200.39.26.250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8ECF20663;
        Tue,  7 Jul 2020 20:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594154422;
        bh=3m9Ts8ZdNbvP0zw56jNmt12LNCN6IZhjuKJU2GPO4Uo=;
        h=Date:From:To:Cc:Subject:From;
        b=ynGCoRUb9wYF/dEEu7ENvzMl35bhUmKW1p7wgjyypz95x6WCwlAGtMxfkivZ6DzKH
         YhNxuEXa7HJbck1hoLWSAKiB3yYpqd9AUktYD31PwSbuJ2gmAGhdEapbNiub8QL1cR
         ELdAV/8j2qMebKQ9mu3R39/8MmcP7YwS+92SAYeg=
Date:   Tue, 7 Jul 2020 15:45:48 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] mac80211: Use fallthrough pseudo-keyword
Message-ID: <20200707204548.GA9320@embeddedor>
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
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 net/mac80211/cfg.c                    |    6 +++---
 net/mac80211/chan.c                   |    2 +-
 net/mac80211/ht.c                     |    4 ++--
 net/mac80211/ibss.c                   |    4 ++--
 net/mac80211/iface.c                  |   10 +++++-----
 net/mac80211/key.c                    |    2 +-
 net/mac80211/mesh.c                   |    4 ++--
 net/mac80211/mesh_hwmp.c              |    2 +-
 net/mac80211/mesh_plink.c             |    2 +-
 net/mac80211/mlme.c                   |    4 ++--
 net/mac80211/offchannel.c             |    4 ++--
 net/mac80211/rx.c                     |    4 ++--
 net/mac80211/tdls.c                   |    8 ++++----
 net/mac80211/tx.c                     |   12 ++++++------
 net/mac80211/util.c                   |   15 +++++++--------
 net/mac80211/wme.c                    |    2 +-
 17 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 1356e8cbe617..9dd9d73f4484 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -4334,7 +4334,7 @@ static int __init init_mac80211_hwsim(void)
 			break;
 		case HWSIM_REGTEST_STRICT_ALL:
 			param.reg_strict = true;
-			/* fall through */
+			fallthrough;
 		case HWSIM_REGTEST_DRIVER_REG_ALL:
 			param.reg_alpha2 = hwsim_alpha2s[0];
 			break;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9b360544ad6f..b4a74064675e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -608,12 +608,12 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
 		BUILD_BUG_ON(offsetof(typeof(kseq), ccmp) !=
 			     offsetof(typeof(kseq), aes_cmac));
-		/* fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
 		BUILD_BUG_ON(offsetof(typeof(kseq), ccmp) !=
 			     offsetof(typeof(kseq), aes_gmac));
-		/* fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		BUILD_BUG_ON(offsetof(typeof(kseq), ccmp) !=
@@ -2336,7 +2336,7 @@ static int ieee80211_scan(struct wiphy *wiphy,
 		 * for now fall through to allow scanning only when
 		 * beaconing hasn't been configured yet
 		 */
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_AP:
 		/*
 		 * If the scan has been forced (and the driver supports
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index e6e192f53e4e..6ff177fb2324 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -743,7 +743,7 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 		default:
 			WARN_ONCE(1, "Invalid SMPS mode %d\n",
 				  sdata->smps_mode);
-			/* fall through */
+			fallthrough;
 		case IEEE80211_SMPS_OFF:
 			needed_static = sdata->needed_rx_chains;
 			needed_dynamic = sdata->needed_rx_chains;
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index e32906202575..3d62a80b5790 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -250,7 +250,7 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	switch (sdata->vif.bss_conf.chandef.width) {
 	default:
 		WARN_ON_ONCE(1);
-		/* fall through */
+		fallthrough;
 	case NL80211_CHAN_WIDTH_20_NOHT:
 	case NL80211_CHAN_WIDTH_20:
 		bw = IEEE80211_STA_RX_BW_20;
@@ -517,7 +517,7 @@ int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 	case IEEE80211_SMPS_AUTOMATIC:
 	case IEEE80211_SMPS_NUM_MODES:
 		WARN_ON(1);
-		/* fall through */
+		fallthrough;
 	case IEEE80211_SMPS_OFF:
 		action_frame->u.action.u.ht_smps.smps_control =
 				WLAN_HT_SMPS_CONTROL_DISABLED;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 81d26fef41e9..53632c2f5217 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -791,7 +791,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	case NL80211_CHAN_WIDTH_10:
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		sta_flags |= IEEE80211_STA_DISABLE_HT;
-		/* fall through */
+		fallthrough;
 	case NL80211_CHAN_WIDTH_20:
 		sta_flags |= IEEE80211_STA_DISABLE_40MHZ;
 		break;
@@ -1401,7 +1401,7 @@ ieee80211_ibss_setup_scan_channels(struct wiphy *wiphy,
 		break;
 	case NL80211_CHAN_WIDTH_80P80:
 		cf2 = chandef->center_freq2;
-		/* fall through */
+		fallthrough;
 	case NL80211_CHAN_WIDTH_80:
 		width = 80;
 		break;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f900c84fb40f..570f818384e8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -978,7 +978,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* relies on synchronize_rcu() below */
 		RCU_INIT_POINTER(local->p2p_sdata, NULL);
-		/* fall through */
+		fallthrough;
 	default:
 		cancel_work_sync(&sdata->work);
 		/*
@@ -1048,7 +1048,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		if (!(sdata->u.mntr.flags & MONITOR_FLAG_ACTIVE))
 			break;
 
-		/* fall through */
+		fallthrough;
 	default:
 		if (going_down)
 			drv_remove_interface(local, sdata);
@@ -1497,7 +1497,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		type = NL80211_IFTYPE_AP;
 		sdata->vif.type = type;
 		sdata->vif.p2p = true;
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_AP:
 		skb_queue_head_init(&sdata->u.ap.ps.bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
@@ -1507,7 +1507,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		type = NL80211_IFTYPE_STATION;
 		sdata->vif.type = type;
 		sdata->vif.p2p = true;
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_STATION:
 		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
 		ieee80211_sta_setup_sdata(sdata);
@@ -1703,7 +1703,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 				goto out_unlock;
 			}
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		/* assign a new address if possible -- try n_addresses first */
 		for (i = 0; i < local->hw.wiphy->n_addresses; i++) {
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 8f403c1bb908..9c2888004878 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -225,7 +225,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		 */
 		if (sdata->hw_80211_encap)
 			return -EINVAL;
-		/* Fall through */
+		fallthrough;
 
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5f1ca25b6c97..96f0323c0a3d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1094,10 +1094,10 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	switch (sdata->vif.bss_conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		sta_flags |= IEEE80211_STA_DISABLE_HT;
-		/* fall through */
+		fallthrough;
 	case NL80211_CHAN_WIDTH_20:
 		sta_flags |= IEEE80211_STA_DISABLE_40MHZ;
-		/* fall through */
+		fallthrough;
 	case NL80211_CHAN_WIDTH_40:
 		sta_flags |= IEEE80211_STA_DISABLE_VHT;
 		break;
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index aa5150929996..c71bd612740d 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1269,7 +1269,7 @@ void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 		break;
 	case IEEE80211_PROACTIVE_PREQ_WITH_PREP:
 		flags |= IEEE80211_PREQ_PROACTIVE_PREP_FLAG;
-		/* fall through */
+		fallthrough;
 	case IEEE80211_PROACTIVE_PREQ_NO_PREP:
 		interval = ifmsh->mshcfg.dot11MeshHWMPactivePathToRootTimeout;
 		target_flags |= IEEE80211_PREQ_TO_FLAG |
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 798e4b6b383f..15f2fc658f70 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -699,7 +699,7 @@ void mesh_plink_timer(struct timer_list *t)
 			break;
 		}
 		reason = WLAN_REASON_MESH_MAX_RETRIES;
-		/* fall through */
+		fallthrough;
 	case NL80211_PLINK_CNF_RCVD:
 		/* confirm timer */
 		if (!reason)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b2a9d47cf86d..1c1b3f6bc415 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -533,7 +533,7 @@ static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
 	case IEEE80211_SMPS_AUTOMATIC:
 	case IEEE80211_SMPS_NUM_MODES:
 		WARN_ON(1);
-		/* fall through */
+		fallthrough;
 	case IEEE80211_SMPS_OFF:
 		cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
 			IEEE80211_HT_CAP_SM_PS_SHIFT;
@@ -1529,7 +1529,7 @@ ieee80211_find_80211h_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	switch (channel->band) {
 	default:
 		WARN_ON_ONCE(1);
-		/* fall through */
+		fallthrough;
 	case NL80211_BAND_2GHZ:
 	case NL80211_BAND_60GHZ:
 		chan_increment = 1;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index db3b8bf75656..7b842aa903c3 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -808,13 +808,13 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		if (!sdata->vif.bss_conf.ibss_joined)
 			need_offchan = true;
 #ifdef CONFIG_MAC80211_MESH
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_MESH_POINT:
 		if (ieee80211_vif_is_mesh(&sdata->vif) &&
 		    !sdata->u.mesh.mesh_id_len)
 			need_offchan = true;
 #endif
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a88ab6fb16f2..83a6e52ba033 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3710,7 +3710,7 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 		I802_DEBUG_INC(rx->sdata->local->rx_handlers_drop);
 		if (rx->sta)
 			rx->sta->rx_stats.dropped++;
-		/* fall through */
+		fallthrough;
 	case RX_CONTINUE: {
 		struct ieee80211_rate *rate = NULL;
 		struct ieee80211_supported_band *sband;
@@ -4726,7 +4726,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 			break;
 		default:
 			WARN_ON_ONCE(1);
-			/* fall through */
+			fallthrough;
 		case RX_ENC_LEGACY:
 			if (WARN_ON(status->rate_idx >= sband->n_bitrates))
 				goto drop;
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 4b0cff4a07bd..e01e4daeb8cd 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -239,7 +239,7 @@ static enum ieee80211_ac_numbers ieee80211_ac_from_wmm(int ac)
 	switch (ac) {
 	default:
 		WARN_ON_ONCE(1);
-		/* fall through */
+		fallthrough;
 	case 0:
 		return IEEE80211_AC_BE;
 	case 1:
@@ -952,7 +952,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 			set_sta_flag(sta, WLAN_STA_TDLS_INITIATOR);
 			sta->sta.tdls_initiator = false;
 		}
-		/* fall-through */
+		fallthrough;
 	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_TDLS_DISCOVERY_REQUEST:
 		initiator = true;
@@ -967,7 +967,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 			clear_sta_flag(sta, WLAN_STA_TDLS_INITIATOR);
 			sta->sta.tdls_initiator = true;
 		}
-		/* fall-through */
+		fallthrough;
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
 		initiator = false;
 		break;
@@ -1222,7 +1222,7 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		 * by the AP.
 		 */
 		drv_mgd_protect_tdls_discover(sdata->local, sdata);
-		/* fall-through */
+		fallthrough;
 	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
 		/* no special handling */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9ce658141f5..92268501b757 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1739,7 +1739,7 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
 	case NL80211_IFTYPE_AP_VLAN:
 		sdata = container_of(sdata->bss,
 				     struct ieee80211_sub_if_data, u.ap);
-		/* fall through */
+		fallthrough;
 	default:
 		vif = &sdata->vif;
 		break;
@@ -2382,7 +2382,7 @@ int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 		} else if (sdata->wdev.use_4addr) {
 			return -ENOLINK;
 		}
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_ADHOC:
@@ -2552,7 +2552,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		band = chanctx_conf->def.chan->band;
 		if (sdata->wdev.use_4addr)
 			break;
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_AP:
 		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
@@ -2999,7 +2999,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 			build.hdr_len = 30;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_AP:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA BSSID SA */
@@ -3710,7 +3710,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_AP_VLAN:
 		tx.sdata = container_of(tx.sdata->bss,
 					struct ieee80211_sub_if_data, u.ap);
-		/* fall through */
+		fallthrough;
 	default:
 		vif = &tx.sdata->vif;
 		break;
@@ -4046,7 +4046,7 @@ static bool ieee80211_multicast_to_unicast(struct sk_buff *skb,
 			return false;
 		if (sdata->wdev.use_4addr)
 			return false;
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_AP:
 		/* check runtime toggle for this bss */
 		if (!sdata->bss->multicast_to_unicast)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 21c94094a699..33dd337de1e9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2347,10 +2347,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_ADHOC:
 			if (sdata->vif.bss_conf.ibss_joined)
 				WARN_ON(drv_join_ibss(local, sdata));
-			/* fall through */
+			fallthrough;
 		default:
 			ieee80211_reconfig_stations(sdata);
-			/* fall through */
+			fallthrough;
 		case NL80211_IFTYPE_AP: /* AP stations are handled later */
 			for (i = 0; i < IEEE80211_NUM_ACS; i++)
 				drv_conf_tx(local, sdata, i,
@@ -2399,7 +2399,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			break;
 		case NL80211_IFTYPE_ADHOC:
 			changed |= BSS_CHANGED_IBSS;
-			/* fall through */
+			fallthrough;
 		case NL80211_IFTYPE_AP:
 			changed |= BSS_CHANGED_SSID | BSS_CHANGED_P2P_PS;
 
@@ -2414,8 +2414,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 				if (rcu_access_pointer(sdata->u.ap.beacon))
 					drv_start_ap(local, sdata);
 			}
-
-			/* fall through */
+			fallthrough;
 		case NL80211_IFTYPE_MESH_POINT:
 			if (sdata->vif.bss_conf.enable_beacon) {
 				changed |= BSS_CHANGED_BEACON |
@@ -2885,7 +2884,7 @@ void ieee80211_ie_build_he_6ghz_cap(struct ieee80211_sub_if_data *sdata,
 	case IEEE80211_SMPS_AUTOMATIC:
 	case IEEE80211_SMPS_NUM_MODES:
 		WARN_ON(1);
-		/* fall through */
+		fallthrough;
 	case IEEE80211_SMPS_OFF:
 		cap |= u16_encode_bits(WLAN_HT_CAP_SM_PS_DISABLED,
 				       IEEE80211_HE_6GHZ_CAP_SM_PS);
@@ -3196,7 +3195,7 @@ bool ieee80211_chandef_vht_oper(struct ieee80211_hw *hw, u32 vht_cap_info,
 		break;
 	case 0x01:
 		support_80_80 = false;
-		/* fall through */
+		fallthrough;
 	case 0x02:
 	case 0x03:
 		ccf1 = ccfs2;
@@ -3566,7 +3565,7 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 		break;
 	default:
 		WARN_ON(1);
-		/* fall through */
+		fallthrough;
 	case RX_ENC_LEGACY: {
 		struct ieee80211_supported_band *sband;
 		int shift = 0;
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 72920d82928c..2fb99325135a 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -198,7 +198,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 		sta = rcu_dereference(sdata->u.vlan.sta);
 		if (sta)
 			break;
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_AP:
 		ra = skb->data;
 		break;

