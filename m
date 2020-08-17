Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34BD246210
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgHQJIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgHQJIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:08:11 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A47DC061389;
        Mon, 17 Aug 2020 02:08:11 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id f9so7384486pju.4;
        Mon, 17 Aug 2020 02:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+rEDgp4YGA9R1HriHFsXyzXz2mawGnxPe0arFuiO0Zc=;
        b=JLjuypKGX2u5yy1C0DonZ/t8FnMc2hcQDa5cqNXAswjJ9jticvJ7dNyDSIkikvU3N8
         qUf2/NzmT45szRLG6BRaCXCuYJ+8WerB2bJww+stYD9ho25QzJJvgSG2ZNOzUS5qnOhu
         jtFjGC5X/q/CzTDWXhli6EhVSVmDOhTTwkwNeUdPbz2teNB7iQgmM+XI7oobWf8dlf87
         0b1i31WO4/ezmxXt//sRBxXkcB7TzqFP4+5f05eE2mqzcLmc8C5vTjTXs39NzQrrystt
         2b3O0ufAluYrEpzqgXHxv299XQN3h4FervN12IYdU1d5m6P0Ruj6LiR2tDm0mBjtCtTL
         Y5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+rEDgp4YGA9R1HriHFsXyzXz2mawGnxPe0arFuiO0Zc=;
        b=mwZg9hRLR/MKYmrzZRdz+f+YFg2Ur43XSyZlezFC4egm3epZ2eSt/nXE0veHNr4a8i
         pMpD1ZwIW0SDqGuSX/32HwtktMTOKcU/k2OX1uDu1QgkgH3T7GEG+cEcUraOfftds8IT
         yeCbVfKzob26/yFYysp/sGsgpPEfK85YLN/uSHP+6Nw31zszT00XiAnl82nOM1Al41XF
         96OMolAAbGa5OdoIBAhBlOWITS/s6MMXT1RgrwBbhyq+abBNrCnJaNRhqcv5/4Jos+vk
         l555sRbQ0cKg3h+YSvt1v0cw7aJldDW3iN4/sKp1Z5DjpmIpY3Zzb7jinZa78Vsb8+CV
         Ugxg==
X-Gm-Message-State: AOAM531nY0Mi7E6veWYL5xzpkW787cOQQk8/hmpRs7qUYwkQOqamCAKw
        Jt4caGwPP/gL/z3OwvzHcG8=
X-Google-Smtp-Source: ABdhPJwW2Zolr0t7C/hp6Olz06ZaYa+bIXcgNSy12uYcQgLnah2aehX25oeVGB1Q+txYJRymWwXWaw==
X-Received: by 2002:a17:90b:358c:: with SMTP id mm12mr12109718pjb.154.1597655291001;
        Mon, 17 Aug 2020 02:08:11 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:08:10 -0700 (PDT)
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
Subject: [PATCH 10/16] wireless: intersil: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:31 +0530
Message-Id: <20200817090637.26887-11-allen.cryptic@gmail.com>
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
and from_tasklet() to pass the tasklet pointer explicitly
and remove .data field.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 .../net/wireless/intersil/hostap/hostap_hw.c   | 18 +++++++++---------
 drivers/net/wireless/intersil/orinoco/main.c   |  7 +++----
 drivers/net/wireless/intersil/p54/p54pci.c     |  8 ++++----
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index b6c497ce12e1..ba00a4d8a26f 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -2083,9 +2083,9 @@ static void hostap_rx_skb(local_info_t *local, struct sk_buff *skb)
 
 
 /* Called only as a tasklet (software IRQ) */
-static void hostap_rx_tasklet(unsigned long data)
+static void hostap_rx_tasklet(struct tasklet_struct *t)
 {
-	local_info_t *local = (local_info_t *) data;
+	local_info_t *local = from_tasklet(local, t, rx_tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->rx_list)) != NULL)
@@ -2288,9 +2288,9 @@ static void prism2_tx_ev(local_info_t *local)
 
 
 /* Called only as a tasklet (software IRQ) */
-static void hostap_sta_tx_exc_tasklet(unsigned long data)
+static void hostap_sta_tx_exc_tasklet(struct tasklet_struct *t)
 {
-	local_info_t *local = (local_info_t *) data;
+	local_info_t *local = from_tasklet(local, t, sta_tx_exc_tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->sta_tx_exc_list)) != NULL) {
@@ -2390,9 +2390,9 @@ static void prism2_txexc(local_info_t *local)
 
 
 /* Called only as a tasklet (software IRQ) */
-static void hostap_info_tasklet(unsigned long data)
+static void hostap_info_tasklet(struct tasklet_struct *t)
 {
-	local_info_t *local = (local_info_t *) data;
+	local_info_t *local = from_tasklet(local, t, info_tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->info_list)) != NULL) {
@@ -2469,9 +2469,9 @@ static void prism2_info(local_info_t *local)
 
 
 /* Called only as a tasklet (software IRQ) */
-static void hostap_bap_tasklet(unsigned long data)
+static void hostap_bap_tasklet(struct tasklet_struct *t)
 {
-	local_info_t *local = (local_info_t *) data;
+	local_info_t *local = from_tasklet(local, t, bap_tasklet);
 	struct net_device *dev = local->dev;
 	u16 ev;
 	int frames = 30;
@@ -3183,7 +3183,7 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 	/* Initialize tasklets for handling hardware IRQ related operations
 	 * outside hw IRQ handler */
 #define HOSTAP_TASKLET_INIT(q, f, d) \
-do { memset((q), 0, sizeof(*(q))); (q)->func = (f); (q)->data = (d); } \
+do { memset((q), 0, sizeof(*(q))); (q)->func = (void(*)(unsigned long))(f); } \
 while (0)
 	HOSTAP_TASKLET_INIT(&local->bap_tasklet, hostap_bap_tasklet,
 			    (unsigned long) local);
diff --git a/drivers/net/wireless/intersil/orinoco/main.c b/drivers/net/wireless/intersil/orinoco/main.c
index 00264a14e52c..78d3cb986c19 100644
--- a/drivers/net/wireless/intersil/orinoco/main.c
+++ b/drivers/net/wireless/intersil/orinoco/main.c
@@ -1062,9 +1062,9 @@ static void orinoco_rx(struct net_device *dev,
 	stats->rx_dropped++;
 }
 
-static void orinoco_rx_isr_tasklet(unsigned long data)
+static void orinoco_rx_isr_tasklet(struct tasklet_struct *t)
 {
-	struct orinoco_private *priv = (struct orinoco_private *) data;
+	struct orinoco_private *priv = from_tasklet(priv, t, rx_tasklet);
 	struct net_device *dev = priv->ndev;
 	struct orinoco_rx_data *rx_data, *temp;
 	struct hermes_rx_descriptor *desc;
@@ -2198,8 +2198,7 @@ struct orinoco_private
 	INIT_WORK(&priv->wevent_work, orinoco_send_wevents);
 
 	INIT_LIST_HEAD(&priv->rx_list);
-	tasklet_init(&priv->rx_tasklet, orinoco_rx_isr_tasklet,
-		     (unsigned long) priv);
+	tasklet_setup(&priv->rx_tasklet, orinoco_rx_isr_tasklet);
 
 	spin_lock_init(&priv->scan_lock);
 	INIT_LIST_HEAD(&priv->scan_list);
diff --git a/drivers/net/wireless/intersil/p54/p54pci.c b/drivers/net/wireless/intersil/p54/p54pci.c
index 9d96c8b8409d..94064d7cff52 100644
--- a/drivers/net/wireless/intersil/p54/p54pci.c
+++ b/drivers/net/wireless/intersil/p54/p54pci.c
@@ -278,10 +278,10 @@ static void p54p_check_tx_ring(struct ieee80211_hw *dev, u32 *index,
 	}
 }
 
-static void p54p_tasklet(unsigned long dev_id)
+static void p54p_tasklet(struct tasklet_struct *t)
 {
-	struct ieee80211_hw *dev = (struct ieee80211_hw *)dev_id;
-	struct p54p_priv *priv = dev->priv;
+	struct p54p_priv *priv = from_tasklet(priv, t, tasklet);
+	struct ieee80211_hw *dev = pci_get_drvdata(priv->pdev);
 	struct p54p_ring_control *ring_control = priv->ring_control;
 
 	p54p_check_tx_ring(dev, &priv->tx_idx_mgmt, 3, ring_control->tx_mgmt,
@@ -620,7 +620,7 @@ static int p54p_probe(struct pci_dev *pdev,
 	priv->common.tx = p54p_tx;
 
 	spin_lock_init(&priv->lock);
-	tasklet_init(&priv->tasklet, p54p_tasklet, (unsigned long)dev);
+	tasklet_setup(&priv->tasklet, p54p_tasklet);
 
 	err = request_firmware_nowait(THIS_MODULE, 1, "isl3886pci",
 				      &priv->pdev->dev, GFP_KERNEL,
-- 
2.17.1

