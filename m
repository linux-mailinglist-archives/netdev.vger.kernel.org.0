Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C8551DE06
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444036AbiEFREk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444035AbiEFREj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:04:39 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE8240934;
        Fri,  6 May 2022 10:00:53 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id k2so6437374qtp.1;
        Fri, 06 May 2022 10:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=nrBMd2+FiEnjzKcF02L9jjByTEcFe0FqntGwnTkyn10=;
        b=klCiEmicxlT0XCSTq3ULGWtic2pwRtGLCti5rM3ANFvO6tYuUg6BujVqQpGq8eYh1/
         1odMupV3uDT9uqRw9vhRlWfcLkwfFyAHWvr/GQlzH9DexNbr8IgmGHepgukWEwLEo+fG
         lhUyf4aQskTLm5Ui7LZzVIHyul4s1gWjyyNwXnLU7XF900HDlUEt0+AkcRpSAbpbKqYk
         +K6H+u1VKWTLw5dFSrMd1rPIqo3awPDSx1n4HKKjPHHRcB7va9gnj8/zEDz4jJLDXon7
         4eBNznIOgZnltVb7yqElXZt2lW5UBQSi63LaCeTkAVMxXJIjdu42lpRNMycxk89l/s4i
         aRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=nrBMd2+FiEnjzKcF02L9jjByTEcFe0FqntGwnTkyn10=;
        b=loNwpOeNeE4JUzbm9A99939vVKwMhXULu9dTwRhedIMgZsq/g0vquV28VrOMwyQPSw
         M+PpRpopyV3ERJaHUDR8lsQfstYW2gTzo2W1F5si0SLup92Zwpcw0spLqs1ExY3Cnrla
         /2frEP/bWld9Coqh+jkrqBYSU+Kw+sER7YI/UDLIxaGLFT/KLR1ksydqU+0FsydEFFmG
         YX0t/D+vSKqLTITcC9GHILujL70vGi5HKQxuz1XLiAw7Ywhhu40220RQqWVAa7vAxXDk
         2u+MhfDdn4pVxB/FCFsJOrzGKx4bj/aKCW4Fgom5+bQV4MxDL1rf+pLu3KNgPYa3D6qS
         CMOQ==
X-Gm-Message-State: AOAM5320FsWGtKndaLcI4DAI1oCMg9+zRDHKm9zMTgURGIaoF8HkJqWJ
        uOUKC2ZpbdxRC0E68k9xZ7sn3vOUN0UyhQ==
X-Google-Smtp-Source: ABdhPJzmXcE52gL07zalV1ygkLcK/s3zBgcGp8gMEqWKHmdM9hOyZd7h+j2zIjPklc+lLBY7EXXTOQ==
X-Received: by 2002:ac8:4e4d:0:b0:2f1:f986:6b62 with SMTP id e13-20020ac84e4d000000b002f1f9866b62mr3698537qtw.585.1651856451480;
        Fri, 06 May 2022 10:00:51 -0700 (PDT)
Received: from jaehee-ThinkPad-X1-Extreme ([4.34.18.218])
        by smtp.gmail.com with ESMTPSA id g25-20020a05620a109900b0069fc13ce1e3sm2651741qkk.20.2022.05.06.10.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 10:00:50 -0700 (PDT)
Date:   Fri, 6 May 2022 13:00:46 -0400
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
Subject: [PATCH v6] wfx: use container_of() to get vif
Message-ID: <20220506170046.GA1297231@jaehee-ThinkPad-X1-Extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
v2
- Sequenced the wfx.h file (with the new defines) to show up first on 
the diff, which makes the ordering of the diff more logical.
 
v3
- Made edits to the commit message.
- Shortened the macro name from wvif_to_vif to to_vif.
- For functions that had more than one instance of vif, defined one
reference vif at the beginning of the function and used that instead.
- Broke the if-statements that ran long into two lines.

v4
- Changed macro into function and named it back to wvif_to_vif
- Fit all lines in patch to 80 columns
- Decared a reference to vif at the beginning of all the functions
where it's being used

v5
- Placed longest declaration first 

v6
- Set vif after wvif is modified (in the wfx_configure_filter function)


 drivers/net/wireless/silabs/wfx/wfx.h     |  6 +-
 drivers/net/wireless/silabs/wfx/data_rx.c |  5 +-
 drivers/net/wireless/silabs/wfx/data_tx.c |  3 +-
 drivers/net/wireless/silabs/wfx/key.c     |  4 +-
 drivers/net/wireless/silabs/wfx/queue.c   |  3 +-
 drivers/net/wireless/silabs/wfx/scan.c    | 11 ++--
 drivers/net/wireless/silabs/wfx/sta.c     | 76 ++++++++++++++---------
 7 files changed, 68 insertions(+), 40 deletions(-)

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
index a4b5ffe158e4..e099a9e65bae 100644
--- a/drivers/net/wireless/silabs/wfx/data_rx.c
+++ b/drivers/net/wireless/silabs/wfx/data_rx.c
@@ -15,6 +15,7 @@
 
 static void wfx_rx_handle_ba(struct wfx_vif *wvif, struct ieee80211_mgmt *mgmt)
 {
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 	int params, tid;
 
 	if (wfx_api_older_than(wvif->wdev, 3, 6))
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
index e07381b2ff4d..6a5e52a96d18 100644
--- a/drivers/net/wireless/silabs/wfx/data_tx.c
+++ b/drivers/net/wireless/silabs/wfx/data_tx.c
@@ -212,11 +212,12 @@ static u8 wfx_tx_get_link_id(struct wfx_vif *wvif, struct ieee80211_sta *sta,
 			     struct ieee80211_hdr *hdr)
 {
 	struct wfx_sta_priv *sta_priv = sta ? (struct wfx_sta_priv *)&sta->drv_priv : NULL;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 	const u8 *da = ieee80211_get_DA(hdr);
 
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
index 729825230db2..37f492e5d3be 100644
--- a/drivers/net/wireless/silabs/wfx/queue.c
+++ b/drivers/net/wireless/silabs/wfx/queue.c
@@ -205,9 +205,10 @@ unsigned int wfx_pending_get_pkt_us_delay(struct wfx_dev *wdev, struct sk_buff *
 
 bool wfx_tx_queues_has_cab(struct wfx_vif *wvif)
 {
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 	int i;
 
-	if (wvif->vif->type != NL80211_IFTYPE_AP)
+	if (vif->type != NL80211_IFTYPE_AP)
 		return false;
 	for (i = 0; i < IEEE80211_NUM_ACS; ++i)
 		/* Note: since only AP can have mcast frames in queue and only one vif can be AP,
diff --git a/drivers/net/wireless/silabs/wfx/scan.c b/drivers/net/wireless/silabs/wfx/scan.c
index 7f34f0d322f9..16f619ed22e0 100644
--- a/drivers/net/wireless/silabs/wfx/scan.c
+++ b/drivers/net/wireless/silabs/wfx/scan.c
@@ -23,9 +23,11 @@ static void wfx_ieee80211_scan_completed_compat(struct ieee80211_hw *hw, bool ab
 
 static int update_probe_tmpl(struct wfx_vif *wvif, struct cfg80211_scan_request *req)
 {
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 	struct sk_buff *skb;
 
-	skb = ieee80211_probereq_get(wvif->wdev->hw, wvif->vif->addr, NULL, 0, req->ie_len);
+	skb = ieee80211_probereq_get(wvif->wdev->hw, vif->addr, NULL, 0,
+				     req->ie_len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -37,8 +39,9 @@ static int update_probe_tmpl(struct wfx_vif *wvif, struct cfg80211_scan_request
 
 static int send_scan_req(struct wfx_vif *wvif, struct cfg80211_scan_request *req, int start_idx)
 {
-	int i, ret;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 	struct ieee80211_channel *ch_start, *ch_cur;
+	int i, ret;
 
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
index 3297d73c327a..e551fa284a43 100644
--- a/drivers/net/wireless/silabs/wfx/sta.c
+++ b/drivers/net/wireless/silabs/wfx/sta.c
@@ -98,9 +98,10 @@ static void wfx_filter_beacon(struct wfx_vif *wvif, bool filter_beacon)
 void wfx_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 			  unsigned int *total_flags, u64 unused)
 {
-	struct wfx_vif *wvif = NULL;
-	struct wfx_dev *wdev = hw->priv;
 	bool filter_bssid, filter_prbreq, filter_beacon;
+	struct ieee80211_vif *vif = NULL;
+	struct wfx_dev *wdev = hw->priv;
+	struct wfx_vif *wvif = NULL;
 
 	/* Notes:
 	 *   - Probe responses (FIF_BCN_PRBRESP_PROMISC) are never filtered
@@ -131,8 +132,9 @@ void wfx_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 		else
 			filter_bssid = true;
 
+		vif = wvif_to_vif(wvif);
 		/* In AP mode, chip can reply to probe request itself */
-		if (*total_flags & FIF_PROBE_REQ && wvif->vif->type == NL80211_IFTYPE_AP) {
+		if (*total_flags & FIF_PROBE_REQ && vif->type == NL80211_IFTYPE_AP) {
 			dev_dbg(wdev->dev, "do not forward probe request in AP mode\n");
 			*total_flags &= ~FIF_PROBE_REQ;
 		}
@@ -152,19 +154,28 @@ static int wfx_get_ps_timeout(struct wfx_vif *wvif, bool *enable_ps)
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
@@ -177,8 +188,8 @@ static int wfx_get_ps_timeout(struct wfx_vif *wvif, bool *enable_ps)
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
@@ -186,10 +197,11 @@ static int wfx_get_ps_timeout(struct wfx_vif *wvif, bool *enable_ps)
 
 int wfx_update_pm(struct wfx_vif *wvif)
 {
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 	int ps_timeout;
 	bool ps;
 
-	if (!wvif->vif->bss_conf.assoc)
+	if (!vif->bss_conf.assoc)
 		return 0;
 	ps_timeout = wfx_get_ps_timeout(wvif, &ps);
 	if (!ps)
@@ -215,7 +227,8 @@ int wfx_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_lock(&wdev->conf_mutex);
 	assign_bit(queue, &wvif->uapsd_mask, params->uapsd);
 	wfx_hif_set_edca_queue_params(wvif, queue, params);
-	if (wvif->vif->type == NL80211_IFTYPE_STATION && old_uapsd != wvif->uapsd_mask) {
+	if (vif->type == NL80211_IFTYPE_STATION &&
+	    old_uapsd != wvif->uapsd_mask) {
 		wfx_hif_set_uapsd_info(wvif, wvif->uapsd_mask);
 		wfx_update_pm(wvif);
 	}
@@ -238,24 +251,26 @@ void wfx_event_report_rssi(struct wfx_vif *wvif, u8 raw_rcpi_rssi)
 	/* RSSI: signed Q8.0, RCPI: unsigned Q7.1
 	 * RSSI = RCPI / 2 - 110
 	 */
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 	int rcpi_rssi;
 	int cqm_evt;
 
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
 
@@ -321,15 +336,16 @@ int wfx_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif, struct ie
 
 static int wfx_upload_ap_templates(struct wfx_vif *wvif)
 {
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 	struct sk_buff *skb;
 
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
@@ -339,7 +355,8 @@ static int wfx_upload_ap_templates(struct wfx_vif *wvif)
 
 static void wfx_set_mfp_ap(struct wfx_vif *wvif)
 {
-	struct sk_buff *skb = ieee80211_beacon_get(wvif->wdev->hw, wvif->vif);
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
+	struct sk_buff *skb = ieee80211_beacon_get(wvif->wdev->hw, vif);
 	const int ieoffset = offsetof(struct ieee80211_mgmt, u.beacon.variable);
 	const u16 *ptr = (u16 *)cfg80211_find_ie(WLAN_EID_RSN, skb->data + ieoffset,
 						 skb->len - ieoffset);
@@ -388,12 +405,13 @@ void wfx_stop_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 static void wfx_join(struct wfx_vif *wvif)
 {
-	int ret;
-	struct ieee80211_bss_conf *conf = &wvif->vif->bss_conf;
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
+	struct ieee80211_bss_conf *conf = &vif->bss_conf;
 	struct cfg80211_bss *bss = NULL;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	const u8 *ssidie = NULL;
 	int ssidlen = 0;
+	int ret;
 
 	wfx_tx_lock_flush(wvif->wdev);
 
@@ -420,7 +438,7 @@ static void wfx_join(struct wfx_vif *wvif)
 	wvif->join_in_progress = true;
 	ret = wfx_hif_join(wvif, conf, wvif->channel, ssid, ssidlen);
 	if (ret) {
-		ieee80211_connection_loss(wvif->vif);
+		ieee80211_connection_loss(vif);
 		wfx_reset(wvif);
 	} else {
 		/* Due to beacon filtering it is possible that the AP's beacon is not known for the
@@ -434,13 +452,14 @@ static void wfx_join(struct wfx_vif *wvif)
 
 static void wfx_join_finalize(struct wfx_vif *wvif, struct ieee80211_bss_conf *info)
 {
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 	struct ieee80211_sta *sta = NULL;
 	int ampdu_density = 0;
 	bool greenfield = false;
 
 	rcu_read_lock(); /* protect sta */
 	if (info->bssid && !info->ibss_joined)
-		sta = ieee80211_find_sta(wvif->vif, info->bssid);
+		sta = ieee80211_find_sta(vif, info->bssid);
 	if (sta && sta->deflink.ht_cap.ht_supported)
 		ampdu_density = sta->deflink.ht_cap.ampdu_density;
 	if (sta && sta->deflink.ht_cap.ht_supported &&
@@ -561,11 +580,13 @@ void wfx_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 static int wfx_update_tim(struct wfx_vif *wvif)
 {
+	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 	struct sk_buff *skb;
 	u16 tim_offset, tim_length;
 	u8 *tim_ptr;
 
-	skb = ieee80211_beacon_get_tim(wvif->wdev->hw, wvif->vif, &tim_offset, &tim_length);
+	skb = ieee80211_beacon_get_tim(wvif->wdev->hw, vif, &tim_offset,
+				       &tim_length);
 	if (!skb)
 		return -ENOENT;
 	tim_ptr = skb->data + tim_offset;
@@ -707,8 +728,6 @@ int wfx_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		return -EOPNOTSUPP;
 	}
 
-	/* FIXME: prefer use of container_of() to get vif */
-	wvif->vif = vif;
 	wvif->wdev = wdev;
 
 	wvif->link_id_map = 1; /* link-id 0 is reserved for multicast */
@@ -767,7 +786,6 @@ void wfx_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	cancel_delayed_work_sync(&wvif->beacon_loss_work);
 	wdev->vif[wvif->id] = NULL;
-	wvif->vif = NULL;
 
 	mutex_unlock(&wdev->conf_mutex);
 
-- 
2.25.1

