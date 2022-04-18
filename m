Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F2C504B66
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 05:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbiDRDxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 23:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiDRDxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 23:53:54 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A866E17068;
        Sun, 17 Apr 2022 20:51:15 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id j9so3007430qkg.1;
        Sun, 17 Apr 2022 20:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=lHG528Ot+Gm26ZY4TwxH4i2UrD///fw3uZsOgGhEAOs=;
        b=LGaWlbNKFzBlO40ytEdhydgtIQQKWymV/UEpIgaDmEkVHs6Cj6al1bdZaE0QUZBJTA
         s3yiFS1qAEZZUGf9zwDX8VGgDUKwkaJ0HqGofs8sfY2XTvNoAQh082bbKN8SOJAZlZky
         KFK/Cn8sCXqxCfaEUkQMza+bggazrW1VX9GTBU0GM5L/j/RZ+D4I/W+ofUpj5NGxAZDB
         mKqguWIJW88GfmgCKKviFkVRxj36yKBioETr89xRm/oGG1RWzXhD3hkWwaz5iL/rnVVv
         nhGkMhKexN2KlGCG6CviTIMec4QTZpgJUdxUfIWLTPZn2+pk3V41pf13X2grMp0rc6da
         COhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=lHG528Ot+Gm26ZY4TwxH4i2UrD///fw3uZsOgGhEAOs=;
        b=whk1UePaKRXqfWuVVgd1T1ks/gCaQTabuNaAprittOOA7iujG/9xXXkk1tIGhB+C5O
         +7z1EombA6FqI8S2LS737EbXOLftBWsPk79sZCdIeoPNXcszGmA7Ux9OydPp0f0m3vjC
         3/01pN+NByf6Tr6oCjZlg9vEc4hbpny7z4qjgi+lzxbC639y70FoQPm56JjcbhOTJ3ru
         1C8TSChSTJmMY4mRDf/2C5fZnhovpu3MyC0y00hwF4KpOZF1QFhf3EEN5lbHErnHazz+
         uFOxINJnhFkMEGwGnXpegBsXFHaNi6tqAXyNj8ltdO/JlXobyalCLJSB1aOb4AUNFQ6H
         kt/Q==
X-Gm-Message-State: AOAM531n4JQ1D4KP93ZM/rTFpnRYlV6KEjphtbJDOmQ7jWt9qGpNY6DU
        lRPupx+IUeIs0tgKbWAOwgg=
X-Google-Smtp-Source: ABdhPJzRbDfTA9SZs+va4+Mi2ML4pGbRhQf9JRMhf3lsT2/vFqQQmp/kjrSirwGXo+qoX7NM3hx8Ag==
X-Received: by 2002:a05:620a:4487:b0:69c:160c:48ae with SMTP id x7-20020a05620a448700b0069c160c48aemr5571726qkp.430.1650253874685;
        Sun, 17 Apr 2022 20:51:14 -0700 (PDT)
Received: from jaehee-ThinkPad-X1-Extreme ([2607:fb90:50e6:61ed:4df2:ed9f:52ea:476e])
        by smtp.gmail.com with ESMTPSA id v65-20020a376144000000b0069e7842f2f5sm2804375qkb.52.2022.04.17.20.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 20:51:14 -0700 (PDT)
Date:   Sun, 17 Apr 2022 23:51:10 -0400
From:   Jaehee Park <jhpark1013@gmail.com>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        outreachy@lists.linux.dev, Jaehee Park <jhpark1013@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH] wfx: use container_of() to get vif
Message-ID: <20220418035110.GA937332@jaehee-ThinkPad-X1-Extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, upon virtual interface creation, wfx_add_interface() stores
a reference to the corresponding struct ieee80211_vif in private data,
for later usage. This is not needed when using the container_of
construct. This construct already has all the info it needs to retrieve
the reference to the corresponding struct from the offset that is
already available, inherent in container_of(), between its type and
member inputs (struct ieee80211_vif and drv_priv, respectively).
Remove vif (which was previously storing the reference to the struct
ieee80211_vif) from the struct wfx_vif, define a function
wvif_to_vif(wvif) for container_of(), and replace all wvif->vif with
the newly defined container_of construct.

Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
---

Changes from staging to wireless-next tree
- changed macro into function and named it back to wvif_to_vif
- fit all lines in patch to 80 columns
- decared a reference to vif at the beginning of the functions

NOTE: Jérôme is going to be testing this patch on his hardware


 drivers/net/wireless/silabs/wfx/wfx.h     |  6 +-
 drivers/net/wireless/silabs/wfx/data_rx.c |  5 +-
 drivers/net/wireless/silabs/wfx/data_tx.c |  3 +-
 drivers/net/wireless/silabs/wfx/key.c     |  4 +-
 drivers/net/wireless/silabs/wfx/queue.c   |  3 +-
 drivers/net/wireless/silabs/wfx/scan.c    |  9 ++-
 drivers/net/wireless/silabs/wfx/sta.c     | 69 ++++++++++++++---------
 7 files changed, 63 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/silabs/wfx/wfx.h b/drivers/net/wireless/silabs/wfx/wfx.h
index 6594cc647c2f..718693a4273d 100644
--- a/drivers/net/wireless/silabs/wfx/wfx.h
+++ b/drivers/net/wireless/silabs/wfx/wfx.h
@@ -61,7 +61,6 @@ struct wfx_dev {
 
 struct wfx_vif {
 	struct wfx_dev             *wdev;
-	struct ieee80211_vif       *vif;
 	struct ieee80211_channel   *channel;
 	int                        id;
 
@@ -91,6 +90,11 @@ struct wfx_vif {
 	struct completion          set_pm_mode_complete;
 };
 
+static inline struct ieee80211_vif *wvif_to_vif(struct wfx_vif *wvif)
+{
+	return container_of((void *)wvif, struct ieee80211_vif, drv_priv);
+}
+
 static inline struct wfx_vif *wdev_to_wvif(struct wfx_dev *wdev, int vif_id)
 {
 	if (vif_id >= ARRAY_SIZE(wdev->vif)) {
diff --git a/drivers/net/wireless/silabs/wfx/data_rx.c b/drivers/net/wireless/silabs/wfx/data_rx.c
index a4b5ffe158e4..342b9cd0e74c 100644
--- a/drivers/net/wireless/silabs/wfx/data_rx.c
+++ b/drivers/net/wireless/silabs/wfx/data_rx.c
@@ -16,6 +16,7 @@
 static void wfx_rx_handle_ba(struct wfx_vif *wvif, struct ieee80211_mgmt *mgmt)
 {
 	int params, tid;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
 	if (wfx_api_older_than(wvif->wdev, 3, 6))
 		return;
@@ -24,12 +25,12 @@ static void wfx_rx_handle_ba(struct wfx_vif *wvif, struct ieee80211_mgmt *mgmt)
 	case WLAN_ACTION_ADDBA_REQ:
 		params = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
 		tid = (params & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
-		ieee80211_start_rx_ba_session_offl(wvif->vif, mgmt->sa, tid);
+		ieee80211_start_rx_ba_session_offl(vif, mgmt->sa, tid);
 		break;
 	case WLAN_ACTION_DELBA:
 		params = le16_to_cpu(mgmt->u.action.u.delba.params);
 		tid = (params &  IEEE80211_DELBA_PARAM_TID_MASK) >> 12;
-		ieee80211_stop_rx_ba_session_offl(wvif->vif, mgmt->sa, tid);
+		ieee80211_stop_rx_ba_session_offl(vif, mgmt->sa, tid);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/silabs/wfx/data_tx.c b/drivers/net/wireless/silabs/wfx/data_tx.c
index e07381b2ff4d..db99142e8e8f 100644
--- a/drivers/net/wireless/silabs/wfx/data_tx.c
+++ b/drivers/net/wireless/silabs/wfx/data_tx.c
@@ -213,10 +213,11 @@ static u8 wfx_tx_get_link_id(struct wfx_vif *wvif, struct ieee80211_sta *sta,
 {
 	struct wfx_sta_priv *sta_priv = sta ? (struct wfx_sta_priv *)&sta->drv_priv : NULL;
 	const u8 *da = ieee80211_get_DA(hdr);
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
 	if (sta_priv && sta_priv->link_id)
 		return sta_priv->link_id;
-	if (wvif->vif->type != NL80211_IFTYPE_AP)
+	if (vif->type != NL80211_IFTYPE_AP)
 		return 0;
 	if (is_multicast_ether_addr(da))
 		return 0;
diff --git a/drivers/net/wireless/silabs/wfx/key.c b/drivers/net/wireless/silabs/wfx/key.c
index 8f23e8d42bd4..196d64ef68f3 100644
--- a/drivers/net/wireless/silabs/wfx/key.c
+++ b/drivers/net/wireless/silabs/wfx/key.c
@@ -156,6 +156,7 @@ static int wfx_add_key(struct wfx_vif *wvif, struct ieee80211_sta *sta,
 	struct wfx_dev *wdev = wvif->wdev;
 	int idx = wfx_alloc_key(wvif->wdev);
 	bool pairwise = key->flags & IEEE80211_KEY_FLAG_PAIRWISE;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
 	WARN(key->flags & IEEE80211_KEY_FLAG_PAIRWISE && !sta, "inconsistent data");
 	ieee80211_get_key_rx_seq(key, 0, &seq);
@@ -174,7 +175,7 @@ static int wfx_add_key(struct wfx_vif *wvif, struct ieee80211_sta *sta,
 			k.type = fill_tkip_pair(&k.key.tkip_pairwise_key, key, sta->addr);
 		else
 			k.type = fill_tkip_group(&k.key.tkip_group_key, key, &seq,
-						 wvif->vif->type);
+						 vif->type);
 	} else if (key->cipher == WLAN_CIPHER_SUITE_CCMP) {
 		if (pairwise)
 			k.type = fill_ccmp_pair(&k.key.aes_pairwise_key, key, sta->addr);
@@ -224,4 +225,3 @@ int wfx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd, struct ieee80211_
 	mutex_unlock(&wvif->wdev->conf_mutex);
 	return ret;
 }
-
diff --git a/drivers/net/wireless/silabs/wfx/queue.c b/drivers/net/wireless/silabs/wfx/queue.c
index 729825230db2..fa1837a00a74 100644
--- a/drivers/net/wireless/silabs/wfx/queue.c
+++ b/drivers/net/wireless/silabs/wfx/queue.c
@@ -206,8 +206,9 @@ unsigned int wfx_pending_get_pkt_us_delay(struct wfx_dev *wdev, struct sk_buff *
 bool wfx_tx_queues_has_cab(struct wfx_vif *wvif)
 {
 	int i;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
-	if (wvif->vif->type != NL80211_IFTYPE_AP)
+	if (vif->type != NL80211_IFTYPE_AP)
 		return false;
 	for (i = 0; i < IEEE80211_NUM_ACS; ++i)
 		/* Note: since only AP can have mcast frames in queue and only one vif can be AP,
diff --git a/drivers/net/wireless/silabs/wfx/scan.c b/drivers/net/wireless/silabs/wfx/scan.c
index 7f34f0d322f9..d2dd9829351a 100644
--- a/drivers/net/wireless/silabs/wfx/scan.c
+++ b/drivers/net/wireless/silabs/wfx/scan.c
@@ -24,8 +24,10 @@ static void wfx_ieee80211_scan_completed_compat(struct ieee80211_hw *hw, bool ab
 static int update_probe_tmpl(struct wfx_vif *wvif, struct cfg80211_scan_request *req)
 {
 	struct sk_buff *skb;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
-	skb = ieee80211_probereq_get(wvif->wdev->hw, wvif->vif->addr, NULL, 0, req->ie_len);
+	skb = ieee80211_probereq_get(wvif->wdev->hw, vif->addr, NULL, 0,
+				     req->ie_len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -39,6 +41,7 @@ static int send_scan_req(struct wfx_vif *wvif, struct cfg80211_scan_request *req
 {
 	int i, ret;
 	struct ieee80211_channel *ch_start, *ch_cur;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
 	for (i = start_idx; i < req->n_channels; i++) {
 		ch_start = req->channels[start_idx];
@@ -75,8 +78,8 @@ static int send_scan_req(struct wfx_vif *wvif, struct cfg80211_scan_request *req
 	} else {
 		ret = wvif->scan_nb_chan_done;
 	}
-	if (req->channels[start_idx]->max_power != wvif->vif->bss_conf.txpower)
-		wfx_hif_set_output_power(wvif, wvif->vif->bss_conf.txpower);
+	if (req->channels[start_idx]->max_power != vif->bss_conf.txpower)
+		wfx_hif_set_output_power(wvif, vif->bss_conf.txpower);
 	wfx_tx_unlock(wvif->wdev);
 	return ret;
 }
diff --git a/drivers/net/wireless/silabs/wfx/sta.c b/drivers/net/wireless/silabs/wfx/sta.c
index 3297d73c327a..97fcbad23c94 100644
--- a/drivers/net/wireless/silabs/wfx/sta.c
+++ b/drivers/net/wireless/silabs/wfx/sta.c
@@ -101,6 +101,7 @@ void wfx_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	struct wfx_vif *wvif = NULL;
 	struct wfx_dev *wdev = hw->priv;
 	bool filter_bssid, filter_prbreq, filter_beacon;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
 	/* Notes:
 	 *   - Probe responses (FIF_BCN_PRBRESP_PROMISC) are never filtered
@@ -132,7 +133,7 @@ void wfx_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 			filter_bssid = true;
 
 		/* In AP mode, chip can reply to probe request itself */
-		if (*total_flags & FIF_PROBE_REQ && wvif->vif->type == NL80211_IFTYPE_AP) {
+		if (*total_flags & FIF_PROBE_REQ && vif->type == NL80211_IFTYPE_AP) {
 			dev_dbg(wdev->dev, "do not forward probe request in AP mode\n");
 			*total_flags &= ~FIF_PROBE_REQ;
 		}
@@ -152,19 +153,28 @@ static int wfx_get_ps_timeout(struct wfx_vif *wvif, bool *enable_ps)
 {
 	struct ieee80211_channel *chan0 = NULL, *chan1 = NULL;
 	struct ieee80211_conf *conf = &wvif->wdev->hw->conf;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
-	WARN(!wvif->vif->bss_conf.assoc && enable_ps,
+	WARN(!vif->bss_conf.assoc && enable_ps,
 	     "enable_ps is reliable only if associated");
-	if (wdev_to_wvif(wvif->wdev, 0))
-		chan0 = wdev_to_wvif(wvif->wdev, 0)->vif->bss_conf.chandef.chan;
-	if (wdev_to_wvif(wvif->wdev, 1))
-		chan1 = wdev_to_wvif(wvif->wdev, 1)->vif->bss_conf.chandef.chan;
-	if (chan0 && chan1 && wvif->vif->type != NL80211_IFTYPE_AP) {
+	if (wdev_to_wvif(wvif->wdev, 0)) {
+		struct wfx_vif *wvif_ch0 = wdev_to_wvif(wvif->wdev, 0);
+		struct ieee80211_vif *vif_ch0 = wvif_to_vif(wvif_ch0);
+
+		chan0 = vif_ch0->bss_conf.chandef.chan;
+	}
+	if (wdev_to_wvif(wvif->wdev, 1)) {
+		struct wfx_vif *wvif_ch1 = wdev_to_wvif(wvif->wdev, 1);
+		struct ieee80211_vif *vif_ch1 = wvif_to_vif(wvif_ch1);
+
+		chan1 = vif_ch1->bss_conf.chandef.chan;
+	}
+	if (chan0 && chan1 && vif->type != NL80211_IFTYPE_AP) {
 		if (chan0->hw_value == chan1->hw_value) {
 			/* It is useless to enable PS if channels are the same. */
 			if (enable_ps)
 				*enable_ps = false;
-			if (wvif->vif->bss_conf.assoc && wvif->vif->bss_conf.ps)
+			if (vif->bss_conf.assoc && vif->bss_conf.ps)
 				dev_info(wvif->wdev->dev, "ignoring requested PS mode");
 			return -1;
 		}
@@ -177,8 +187,8 @@ static int wfx_get_ps_timeout(struct wfx_vif *wvif, bool *enable_ps)
 			return 30;
 	}
 	if (enable_ps)
-		*enable_ps = wvif->vif->bss_conf.ps;
-	if (wvif->vif->bss_conf.assoc && wvif->vif->bss_conf.ps)
+		*enable_ps = vif->bss_conf.ps;
+	if (vif->bss_conf.assoc && vif->bss_conf.ps)
 		return conf->dynamic_ps_timeout;
 	else
 		return -1;
@@ -188,8 +198,9 @@ int wfx_update_pm(struct wfx_vif *wvif)
 {
 	int ps_timeout;
 	bool ps;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
-	if (!wvif->vif->bss_conf.assoc)
+	if (!vif->bss_conf.assoc)
 		return 0;
 	ps_timeout = wfx_get_ps_timeout(wvif, &ps);
 	if (!ps)
@@ -215,7 +226,8 @@ int wfx_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_lock(&wdev->conf_mutex);
 	assign_bit(queue, &wvif->uapsd_mask, params->uapsd);
 	wfx_hif_set_edca_queue_params(wvif, queue, params);
-	if (wvif->vif->type == NL80211_IFTYPE_STATION && old_uapsd != wvif->uapsd_mask) {
+	if (vif->type == NL80211_IFTYPE_STATION &&
+	    old_uapsd != wvif->uapsd_mask) {
 		wfx_hif_set_uapsd_info(wvif, wvif->uapsd_mask);
 		wfx_update_pm(wvif);
 	}
@@ -240,22 +252,24 @@ void wfx_event_report_rssi(struct wfx_vif *wvif, u8 raw_rcpi_rssi)
 	 */
 	int rcpi_rssi;
 	int cqm_evt;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
 	rcpi_rssi = raw_rcpi_rssi / 2 - 110;
-	if (rcpi_rssi <= wvif->vif->bss_conf.cqm_rssi_thold)
+	if (rcpi_rssi <= vif->bss_conf.cqm_rssi_thold)
 		cqm_evt = NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW;
 	else
 		cqm_evt = NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
-	ieee80211_cqm_rssi_notify(wvif->vif, cqm_evt, rcpi_rssi, GFP_KERNEL);
+	ieee80211_cqm_rssi_notify(vif, cqm_evt, rcpi_rssi, GFP_KERNEL);
 }
 
 static void wfx_beacon_loss_work(struct work_struct *work)
 {
 	struct wfx_vif *wvif = container_of(to_delayed_work(work), struct wfx_vif,
 					    beacon_loss_work);
-	struct ieee80211_bss_conf *bss_conf = &wvif->vif->bss_conf;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
-	ieee80211_beacon_loss(wvif->vif);
+	ieee80211_beacon_loss(vif);
 	schedule_delayed_work(to_delayed_work(work), msecs_to_jiffies(bss_conf->beacon_int));
 }
 
@@ -322,14 +336,15 @@ int wfx_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif, struct ie
 static int wfx_upload_ap_templates(struct wfx_vif *wvif)
 {
 	struct sk_buff *skb;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
-	skb = ieee80211_beacon_get(wvif->wdev->hw, wvif->vif);
+	skb = ieee80211_beacon_get(wvif->wdev->hw, vif);
 	if (!skb)
 		return -ENOMEM;
 	wfx_hif_set_template_frame(wvif, skb, HIF_TMPLT_BCN, API_RATE_INDEX_B_1MBPS);
 	dev_kfree_skb(skb);
 
-	skb = ieee80211_proberesp_get(wvif->wdev->hw, wvif->vif);
+	skb = ieee80211_proberesp_get(wvif->wdev->hw, vif);
 	if (!skb)
 		return -ENOMEM;
 	wfx_hif_set_template_frame(wvif, skb, HIF_TMPLT_PRBRES, API_RATE_INDEX_B_1MBPS);
@@ -339,7 +354,8 @@ static int wfx_upload_ap_templates(struct wfx_vif *wvif)
 
 static void wfx_set_mfp_ap(struct wfx_vif *wvif)
 {
-	struct sk_buff *skb = ieee80211_beacon_get(wvif->wdev->hw, wvif->vif);
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
+	struct sk_buff *skb = ieee80211_beacon_get(wvif->wdev->hw, vif);
 	const int ieoffset = offsetof(struct ieee80211_mgmt, u.beacon.variable);
 	const u16 *ptr = (u16 *)cfg80211_find_ie(WLAN_EID_RSN, skb->data + ieoffset,
 						 skb->len - ieoffset);
@@ -389,7 +405,8 @@ void wfx_stop_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 static void wfx_join(struct wfx_vif *wvif)
 {
 	int ret;
-	struct ieee80211_bss_conf *conf = &wvif->vif->bss_conf;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
+	struct ieee80211_bss_conf *conf = &vif->bss_conf;
 	struct cfg80211_bss *bss = NULL;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	const u8 *ssidie = NULL;
@@ -420,7 +437,7 @@ static void wfx_join(struct wfx_vif *wvif)
 	wvif->join_in_progress = true;
 	ret = wfx_hif_join(wvif, conf, wvif->channel, ssid, ssidlen);
 	if (ret) {
-		ieee80211_connection_loss(wvif->vif);
+		ieee80211_connection_loss(vif);
 		wfx_reset(wvif);
 	} else {
 		/* Due to beacon filtering it is possible that the AP's beacon is not known for the
@@ -437,10 +454,11 @@ static void wfx_join_finalize(struct wfx_vif *wvif, struct ieee80211_bss_conf *i
 	struct ieee80211_sta *sta = NULL;
 	int ampdu_density = 0;
 	bool greenfield = false;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
 	rcu_read_lock(); /* protect sta */
 	if (info->bssid && !info->ibss_joined)
-		sta = ieee80211_find_sta(wvif->vif, info->bssid);
+		sta = ieee80211_find_sta(vif, info->bssid);
 	if (sta && sta->deflink.ht_cap.ht_supported)
 		ampdu_density = sta->deflink.ht_cap.ampdu_density;
 	if (sta && sta->deflink.ht_cap.ht_supported &&
@@ -564,8 +582,10 @@ static int wfx_update_tim(struct wfx_vif *wvif)
 	struct sk_buff *skb;
 	u16 tim_offset, tim_length;
 	u8 *tim_ptr;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 
-	skb = ieee80211_beacon_get_tim(wvif->wdev->hw, wvif->vif, &tim_offset, &tim_length);
+	skb = ieee80211_beacon_get_tim(wvif->wdev->hw, vif, &tim_offset,
+				       &tim_length);
 	if (!skb)
 		return -ENOENT;
 	tim_ptr = skb->data + tim_offset;
@@ -707,8 +727,6 @@ int wfx_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		return -EOPNOTSUPP;
 	}
 
-	/* FIXME: prefer use of container_of() to get vif */
-	wvif->vif = vif;
 	wvif->wdev = wdev;
 
 	wvif->link_id_map = 1; /* link-id 0 is reserved for multicast */
@@ -767,7 +785,6 @@ void wfx_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	cancel_delayed_work_sync(&wvif->beacon_loss_work);
 	wdev->vif[wvif->id] = NULL;
-	wvif->vif = NULL;
 
 	mutex_unlock(&wdev->conf_mutex);
 
-- 
2.25.1

