Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5272461EA
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgHQJHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgHQJHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:07:10 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CFDC061389;
        Mon, 17 Aug 2020 02:07:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y6so7193071plt.3;
        Mon, 17 Aug 2020 02:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XcVaL6jGfhFSxrDyrsbWGAsDNySY/sWbGAZGLU3gyzk=;
        b=JY3V9Xh556SzkVgVMCirZFhDu2U+XAm5skIQXkLG+L/smjkx+BWJly7LRdp6Vb41/6
         HO10YgVp4jj+yrEsicrpr55/dlYX+/DhF4LNX1SfUoVLXHc6P8T6JQwx6v28ApzRnrqw
         AFMD5OD2kYe3py4u2EMpS1KVbuqCYXk6C//XuqI0HlHCXJnCt9fChM1WZkxhoDqb2+fE
         mNxlktDTrtBdr/Qt5v2WT/4TfgN4EkIlGGc9w0fuV6S40IDhrEkQ9sQ9bOxjtw4ho+Kj
         mwjisCeV8lTUQnfNSBoe3GtyTZ2RQQ/AzhonUEsDp9cUkNzico58Rua6ROy1iEyV+hiC
         EgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XcVaL6jGfhFSxrDyrsbWGAsDNySY/sWbGAZGLU3gyzk=;
        b=I7bQgbOEjmQ/LfPYqgwA9niO+5pRERxWdMCyN/U/nBxG+zh4q6sCWPiR4fQT+a1PW3
         DXar1Gze3098V1sYXxy6qCJv9i1TqkTT47Zvhc5JErnq2fPQEv9YO9/4cj5s2QHGuuzW
         WzId5GytRr826IGR0lptFOHHICWddEGh5KTtcNrU/NzvHTG9RBuLbIEMHnZJRC1JS2pY
         miCgEya3lno8IkNZY1X9wzZXdgI3jjPv9XpWvYU3rEQ2m2HprWuTjUcCvy+R6M+FriKy
         o7y7Zk1BzcSukNL9Oe6fo+8JE8KBzV8KoyEOf7XPnYEcsbVxyMa8tvWVDqRVlYyV7AFY
         l4Pw==
X-Gm-Message-State: AOAM532VFQpmgOiFSUa0W2aSYwWQSk+88SIp5347McrFJZ1pSo7+bfuz
        2UEGHdgi0eH+d2xmX66tYPo=
X-Google-Smtp-Source: ABdhPJzCW10KMVHwyUEG2ej9tlzap4atUtwsiqdBwmbw5fh9/J72Qn/L3y9ivQV1+VkPFCXzzo0Gmw==
X-Received: by 2002:a17:90a:3948:: with SMTP id n8mr8769780pjf.156.1597655229969;
        Mon, 17 Aug 2020 02:07:09 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:07:09 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     kvalo@codeaurora.org, kuba@kernel.org, jirislaby@kernel.org,
        mickflemm@gmail.com, mcgrof@kernel.org, chunkeey@googlemail.com,
        Larry.Finger@lwfinger.net, stas.yakovlev@gmail.com,
        helmut.schaa@googlemail.com, pkshih@realtek.com,
        yhchuang@realtek.com, dsd@gentoo.org, kune@deine-taler.de
Cc:     keescook@chromium.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 02/16] wireless: ath9k: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:23 +0530
Message-Id: <20200817090637.26887-3-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817090637.26887-1-allen.cryptic@gmail.com>
References: <20200817090637.26887-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h        | 4 ++--
 drivers/net/wireless/ath/ath9k/beacon.c       | 4 ++--
 drivers/net/wireless/ath/ath9k/htc.h          | 4 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 6 ++----
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 8 ++++----
 drivers/net/wireless/ath/ath9k/init.c         | 5 ++---
 drivers/net/wireless/ath/ath9k/main.c         | 4 ++--
 drivers/net/wireless/ath/ath9k/wmi.c          | 7 +++----
 drivers/net/wireless/ath/ath9k/wmi.h          | 2 +-
 9 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a412b352182c..e06b74a54a69 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -713,7 +713,7 @@ struct ath_beacon {
 	bool tx_last;
 };
 
-void ath9k_beacon_tasklet(unsigned long data);
+void ath9k_beacon_tasklet(struct tasklet_struct *t);
 void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *main_vif,
 			 bool beacons);
 void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
@@ -1117,7 +1117,7 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 	common->bus_ops->read_cachesize(common, csz);
 }
 
-void ath9k_tasklet(unsigned long data);
+void ath9k_tasklet(struct tasklet_struct *t);
 int ath_cabq_update(struct ath_softc *);
 u8 ath9k_parse_mpdudensity(u8 mpdudensity);
 irqreturn_t ath_isr(int irq, void *dev);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index e36f947e19fc..4876bff2dc2c 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -385,9 +385,9 @@ void ath9k_csa_update(struct ath_softc *sc)
 						   ath9k_csa_update_vif, sc);
 }
 
-void ath9k_beacon_tasklet(unsigned long data)
+void ath9k_beacon_tasklet(struct tasklet_struct *t)
 {
-	struct ath_softc *sc = (struct ath_softc *)data;
+	struct ath_softc *sc = from_tasklet(sc, t, bcon_tasklet);
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_buf *bf = NULL;
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 9f64e32381f9..0a1634238e67 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -583,14 +583,14 @@ int ath9k_htc_tx_get_slot(struct ath9k_htc_priv *priv);
 void ath9k_htc_tx_clear_slot(struct ath9k_htc_priv *priv, int slot);
 void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv);
 void ath9k_htc_txstatus(struct ath9k_htc_priv *priv, void *wmi_event);
-void ath9k_tx_failed_tasklet(unsigned long data);
+void ath9k_tx_failed_tasklet(struct tasklet_struct *t);
 void ath9k_htc_tx_cleanup_timer(struct timer_list *t);
 bool ath9k_htc_csa_is_finished(struct ath9k_htc_priv *priv);
 
 int ath9k_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_cleanup(struct ath9k_htc_priv *priv);
 void ath9k_host_rx_init(struct ath9k_htc_priv *priv);
-void ath9k_rx_tasklet(unsigned long data);
+void ath9k_rx_tasklet(struct tasklet_struct *t);
 u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv);
 
 void ath9k_htc_ps_wakeup(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 1d6ad8d46607..8136291791d6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -645,10 +645,8 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	spin_lock_init(&priv->tx.tx_lock);
 	mutex_init(&priv->mutex);
 	mutex_init(&priv->htc_pm_lock);
-	tasklet_init(&priv->rx_tasklet, ath9k_rx_tasklet,
-		     (unsigned long)priv);
-	tasklet_init(&priv->tx_failed_tasklet, ath9k_tx_failed_tasklet,
-		     (unsigned long)priv);
+	tasklet_setup(&priv->rx_tasklet, ath9k_rx_tasklet);
+	tasklet_setup(&priv->tx_failed_tasklet, ath9k_tx_failed_tasklet);
 	INIT_DELAYED_WORK(&priv->ani_work, ath9k_htc_ani_work);
 	INIT_WORK(&priv->ps_work, ath9k_ps_work);
 	INIT_WORK(&priv->fatal_work, ath9k_fatal_work);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index b353995bdd45..bdfa22fdc867 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -570,9 +570,9 @@ void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv)
 	spin_unlock_bh(&priv->tx.tx_lock);
 }
 
-void ath9k_tx_failed_tasklet(unsigned long data)
+void ath9k_tx_failed_tasklet(struct tasklet_struct *t)
 {
-	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
+	struct ath9k_htc_priv *priv = from_tasklet(priv, t, tx_failed_tasklet);
 
 	spin_lock(&priv->tx.tx_lock);
 	if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
@@ -1062,9 +1062,9 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 /*
  * FIXME: Handle FLUSH later on.
  */
-void ath9k_rx_tasklet(unsigned long data)
+void ath9k_rx_tasklet(struct tasklet_struct *t)
 {
-	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
+	struct ath9k_htc_priv *priv = from_tasklet(priv, t, rx_tasklet);
 	struct ath9k_htc_rxbuf *rxbuf = NULL, *tmp_buf = NULL;
 	struct ieee80211_rx_status rx_status;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 4d72cd7daaa2..42eefdfc58d1 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -728,9 +728,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	spin_lock_init(&sc->sc_pm_lock);
 	spin_lock_init(&sc->chan_lock);
 	mutex_init(&sc->mutex);
-	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
-	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
-		     (unsigned long)sc);
+	tasklet_setup(&sc->intr_tq, ath9k_tasklet);
+	tasklet_setup(&sc->bcon_tasklet, ath9k_beacon_tasklet);
 
 	timer_setup(&sc->sleep_timer, ath_ps_full_sleep, 0);
 	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a47f6e978095..3d44552fb534 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -368,9 +368,9 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 	ath_dynack_node_deinit(sc->sc_ah, an);
 }
 
-void ath9k_tasklet(unsigned long data)
+void ath9k_tasklet(struct tasklet_struct *t)
 {
-	struct ath_softc *sc = (struct ath_softc *)data;
+	struct ath_softc *sc = from_tasklet(sc, t, intr_tq);
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	enum ath_reset_type type;
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index e7a3127395be..fb82c0910d5d 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -106,8 +106,7 @@ struct wmi *ath9k_init_wmi(struct ath9k_htc_priv *priv)
 	mutex_init(&wmi->multi_rmw_mutex);
 	init_completion(&wmi->cmd_wait);
 	INIT_LIST_HEAD(&wmi->pending_tx_events);
-	tasklet_init(&wmi->wmi_event_tasklet, ath9k_wmi_event_tasklet,
-		     (unsigned long)wmi);
+	tasklet_setup(&wmi->wmi_event_tasklet, ath9k_wmi_event_tasklet);
 
 	return wmi;
 }
@@ -136,9 +135,9 @@ void ath9k_wmi_event_drain(struct ath9k_htc_priv *priv)
 	spin_unlock_irqrestore(&priv->wmi->wmi_lock, flags);
 }
 
-void ath9k_wmi_event_tasklet(unsigned long data)
+void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 {
-	struct wmi *wmi = (struct wmi *)data;
+	struct wmi *wmi = from_tasklet(wmi, t, wmi_event_tasklet);
 	struct ath9k_htc_priv *priv = wmi->drv_priv;
 	struct wmi_cmd_hdr *hdr;
 	void *wmi_event;
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index d8b912206232..be1f126d0306 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -185,7 +185,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 		  u8 *cmd_buf, u32 cmd_len,
 		  u8 *rsp_buf, u32 rsp_len,
 		  u32 timeout);
-void ath9k_wmi_event_tasklet(unsigned long data);
+void ath9k_wmi_event_tasklet(struct tasklet_struct *t);
 void ath9k_fatal_work(struct work_struct *work);
 void ath9k_wmi_event_drain(struct ath9k_htc_priv *priv);
 void ath9k_stop_wmi(struct ath9k_htc_priv *priv);
-- 
2.17.1

