Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C21A24E664
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 10:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgHVIYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 04:24:41 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10310 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbgHVIYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 04:24:41 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DAFA4C68FD912D3A5FC6;
        Sat, 22 Aug 2020 16:24:37 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sat, 22 Aug 2020
 16:24:30 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] net: wireless: Convert to use the preferred fallthrough macro
Date:   Sat, 22 Aug 2020 04:23:23 -0400
Message-ID: <20200822082323.45495-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the uses of fallthrough comments to fallthrough macro.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/wireless/chan.c        |  4 ++--
 net/wireless/mlme.c        |  2 +-
 net/wireless/nl80211.c     | 20 ++++++++++----------
 net/wireless/scan.c        |  2 +-
 net/wireless/sme.c         |  4 ++--
 net/wireless/util.c        |  4 ++--
 net/wireless/wext-compat.c |  4 ++--
 7 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 90f0f82cd9ca..e97a4f0c32a3 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -957,7 +957,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 		if (!ht_cap->ht_supported &&
 		    chandef->chan->band != NL80211_BAND_6GHZ)
 			return false;
-		/* fall through */
+		fallthrough;
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		prohibited_flags |= IEEE80211_CHAN_NO_20MHZ;
 		width = 20;
@@ -983,7 +983,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 		if (chandef->chan->band != NL80211_BAND_6GHZ &&
 		    cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
 			return false;
-		/* fall through */
+		fallthrough;
 	case NL80211_CHAN_WIDTH_80:
 		prohibited_flags |= IEEE80211_CHAN_NO_80MHZ;
 		width = 80;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index a6c61a2e6569..db7333e20dd7 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -941,7 +941,7 @@ void cfg80211_cac_event(struct net_device *netdev,
 		       sizeof(struct cfg80211_chan_def));
 		queue_work(cfg80211_wq, &rdev->propagate_cac_done_wk);
 		cfg80211_sched_dfs_chan_update(rdev);
-		/* fall through */
+		fallthrough;
 	case NL80211_RADAR_CAC_ABORTED:
 		wdev->cac_started = false;
 		break;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c04fc6cf6583..fde420af3f00 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2107,7 +2107,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
-		/* fall through */
+		fallthrough;
 	case 1:
 		if (nla_put(msg, NL80211_ATTR_CIPHER_SUITES,
 			    sizeof(u32) * rdev->wiphy.n_cipher_suites,
@@ -2154,7 +2154,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
-		/* fall through */
+		fallthrough;
 	case 2:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SUPPORTED_IFTYPES,
 					rdev->wiphy.interface_modes))
@@ -2162,7 +2162,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
-		/* fall through */
+		fallthrough;
 	case 3:
 		nl_bands = nla_nest_start_noflag(msg,
 						 NL80211_ATTR_WIPHY_BANDS);
@@ -2189,7 +2189,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				state->chan_start++;
 				if (state->split)
 					break;
-				/* fall through */
+				fallthrough;
 			default:
 				/* add frequencies */
 				nl_freqs = nla_nest_start_noflag(msg,
@@ -2244,7 +2244,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			state->split_start++;
 		if (state->split)
 			break;
-		/* fall through */
+		fallthrough;
 	case 4:
 		nl_cmds = nla_nest_start_noflag(msg,
 						NL80211_ATTR_SUPPORTED_COMMANDS);
@@ -2273,7 +2273,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
-		/* fall through */
+		fallthrough;
 	case 5:
 		if (rdev->ops->remain_on_channel &&
 		    (rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL) &&
@@ -2291,7 +2291,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
-		/* fall through */
+		fallthrough;
 	case 6:
 #ifdef CONFIG_PM
 		if (nl80211_send_wowlan(msg, rdev, state->split))
@@ -2302,7 +2302,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 #else
 		state->split_start++;
 #endif
-		/* fall through */
+		fallthrough;
 	case 7:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SOFTWARE_IFTYPES,
 					rdev->wiphy.software_iftypes))
@@ -2315,7 +2315,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
-		/* fall through */
+		fallthrough;
 	case 8:
 		if ((rdev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
 		    nla_put_u32(msg, NL80211_ATTR_DEVICE_AP_SME,
@@ -5207,7 +5207,7 @@ bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info, int attr)
 		break;
 	default:
 		WARN_ON(1);
-		/* fall through */
+		fallthrough;
 	case RATE_INFO_BW_20:
 		rate_flg = 0;
 		break;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index e67a74488bbe..04f2d198c215 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1433,7 +1433,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 	switch (ftype) {
 	case CFG80211_BSS_FTYPE_BEACON:
 		ies->from_beacon = true;
-		/* fall through */
+		fallthrough;
 	case CFG80211_BSS_FTYPE_UNKNOWN:
 		rcu_assign_pointer(tmp.pub.beacon_ies, ies);
 		break;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 985f3c23f054..079ce320dc1e 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -205,7 +205,7 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev,
 		return err;
 	case CFG80211_CONN_ASSOC_FAILED_TIMEOUT:
 		*treason = NL80211_TIMEOUT_ASSOC;
-		/* fall through */
+		fallthrough;
 	case CFG80211_CONN_ASSOC_FAILED:
 		cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 				     NULL, 0,
@@ -215,7 +215,7 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev,
 		cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 				     NULL, 0,
 				     WLAN_REASON_DEAUTH_LEAVING, false);
-		/* fall through */
+		fallthrough;
 	case CFG80211_CONN_ABANDON:
 		/* free directly, disconnected event already sent */
 		cfg80211_sme_free(wdev);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index dfad1c0f57ad..7c5d5365a5eb 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -198,7 +198,7 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband)
 				sband->bitrates[i].flags |=
 					IEEE80211_RATE_MANDATORY_G;
 				want--;
-				/* fall through */
+				fallthrough;
 			default:
 				sband->bitrates[i].flags |=
 					IEEE80211_RATE_ERP_G;
@@ -1008,7 +1008,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		case NL80211_IFTYPE_STATION:
 			if (dev->ieee80211_ptr->use_4addr)
 				break;
-			/* fall through */
+			fallthrough;
 		case NL80211_IFTYPE_OCB:
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_ADHOC:
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index aa918d7ff6bd..4d2160c989a3 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1334,7 +1334,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 			wstats.qual.qual = sig + 110;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case CFG80211_SIGNAL_TYPE_UNSPEC:
 		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_SIGNAL)) {
 			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
@@ -1343,7 +1343,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 			wstats.qual.qual = sinfo.signal;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		wstats.qual.updated |= IW_QUAL_LEVEL_INVALID;
 		wstats.qual.updated |= IW_QUAL_QUAL_INVALID;
-- 
2.19.1

