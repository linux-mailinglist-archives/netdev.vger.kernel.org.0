Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C942461E7
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgHQJHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgHQJHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:07:01 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB21C061389;
        Mon, 17 Aug 2020 02:07:00 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c6so7507405pje.1;
        Mon, 17 Aug 2020 02:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=73OEUlzheqIr65mDZYXuVcZPnRGe22jWdsxi0fOe4yw=;
        b=tsfmRDS7/ZwPrkBLeeJVYo7rbSBfGZR8cuQarVTYp2KBssYvgGNOpYHX8hZNbc7rlU
         xVVWBiO67fgAByG4DH9fnKstotFNHJGyd4iAYokm3UGvYRQENrtHwAJ41fRpFMlZvo+9
         pG2sreBnGZ8m41lyDp4iugkgW6Cm8/51bRk0u9/NEAQFpyFLjUC7ZkDgMmSbo0Hj6Afd
         NoarQT9/b8O0xGHKLWNLD0QUuEzW/P4iBU1inazN0IVcOpMO8KknUsVId7NiFvGn8IUx
         MPmYJLdITw3DTnZ88DicJeAHmjpXgWxTxPK7SRxVFsnjI8RKs6vNQNrxBIntwEvW8ZcM
         Tf4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=73OEUlzheqIr65mDZYXuVcZPnRGe22jWdsxi0fOe4yw=;
        b=UzyqHKC/UgiD2/MsYLMGM0Gh3Ro20l2d3SbX5RLqoAieUCDar1DFTcreuP6FcfDyr4
         udhl37oycsGWqkHs++u1or+Bio5IMzMwY/RsFm+tevsUnWn0oze4zJBs5SKLOGi5PUiW
         j1rS/AyOsKtVy59imqGGUD95ljTZz2HJKGxY5bNbC2wBZsxKMUv5V4j56ESvnSNy5jV1
         tB8gohYV9+fiXcEEyjJq99DorNKgPN/itc63TKPrGmFbEiQtuo9ahSMxO5B1ChixMNEt
         g5Qsmg310N4oPF2iHrZgc8fPhNi3Yt9QuBoLPyF2e04C+xMzGTk85kI+qyNbajbRPzOU
         AKog==
X-Gm-Message-State: AOAM533g3FpO5dXvCG2i/4cjzNEoyqdPGvqCeK3jWjObx6DH5f/U8PvK
        GIZIxO1J3Q6dMyfrVrDvLB0ZCk1+jrsWZg==
X-Google-Smtp-Source: ABdhPJxahlAjTcIFdW6z0ysUPrm1Yr8wdrpdQtZoWr4mGMWgf/X4V//25uccjoU3huBe+x3AYVgxgg==
X-Received: by 2002:a17:90a:7345:: with SMTP id j5mr11274057pjs.168.1597655220434;
        Mon, 17 Aug 2020 02:07:00 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:06:59 -0700 (PDT)
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
Subject: [PATCH 01/16] wireless: ath5k: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:22 +0530
Message-Id: <20200817090637.26887-2-allen.cryptic@gmail.com>
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
 drivers/net/wireless/ath/ath5k/base.c   | 24 ++++++++++++------------
 drivers/net/wireless/ath/ath5k/rfkill.c |  7 +++----
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 65a4c142640d..2781dcd534a9 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1536,12 +1536,12 @@ ath5k_set_current_imask(struct ath5k_hw *ah)
 }
 
 static void
-ath5k_tasklet_rx(unsigned long data)
+ath5k_tasklet_rx(struct tasklet_struct *t)
 {
 	struct ath5k_rx_status rs = {};
 	struct sk_buff *skb, *next_skb;
 	dma_addr_t next_skb_addr;
-	struct ath5k_hw *ah = (void *)data;
+	struct ath5k_hw *ah = from_tasklet(ah, t, rxtq);
 	struct ath_common *common = ath5k_hw_common(ah);
 	struct ath5k_buf *bf;
 	struct ath5k_desc *ds;
@@ -1784,10 +1784,10 @@ ath5k_tx_processq(struct ath5k_hw *ah, struct ath5k_txq *txq)
 }
 
 static void
-ath5k_tasklet_tx(unsigned long data)
+ath5k_tasklet_tx(struct tasklet_struct *t)
 {
 	int i;
-	struct ath5k_hw *ah = (void *)data;
+	struct ath5k_hw *ah = from_tasklet(ah, t, txtq);
 
 	for (i = 0; i < AR5K_NUM_TX_QUEUES; i++)
 		if (ah->txqs[i].setup && (ah->ah_txq_isr_txok_all & BIT(i)))
@@ -2176,9 +2176,9 @@ ath5k_beacon_config(struct ath5k_hw *ah)
 	spin_unlock_bh(&ah->block);
 }
 
-static void ath5k_tasklet_beacon(unsigned long data)
+static void ath5k_tasklet_beacon(struct tasklet_struct *t)
 {
-	struct ath5k_hw *ah = (struct ath5k_hw *) data;
+	struct ath5k_hw *ah = from_tasklet(ah, t, beacontq);
 
 	/*
 	 * Software beacon alert--time to send a beacon.
@@ -2447,9 +2447,9 @@ ath5k_calibrate_work(struct work_struct *work)
 
 
 static void
-ath5k_tasklet_ani(unsigned long data)
+ath5k_tasklet_ani(struct tasklet_struct *t)
 {
-	struct ath5k_hw *ah = (void *)data;
+	struct ath5k_hw *ah = from_tasklet(ah, t, ani_tasklet);
 
 	ah->ah_cal_mask |= AR5K_CALIBRATION_ANI;
 	ath5k_ani_calibration(ah);
@@ -3069,10 +3069,10 @@ ath5k_init(struct ieee80211_hw *hw)
 		hw->queues = 1;
 	}
 
-	tasklet_init(&ah->rxtq, ath5k_tasklet_rx, (unsigned long)ah);
-	tasklet_init(&ah->txtq, ath5k_tasklet_tx, (unsigned long)ah);
-	tasklet_init(&ah->beacontq, ath5k_tasklet_beacon, (unsigned long)ah);
-	tasklet_init(&ah->ani_tasklet, ath5k_tasklet_ani, (unsigned long)ah);
+	tasklet_setup(&ah->rxtq, ath5k_tasklet_rx);
+	tasklet_setup(&ah->txtq, ath5k_tasklet_tx);
+	tasklet_setup(&ah->beacontq, ath5k_tasklet_beacon);
+	tasklet_setup(&ah->ani_tasklet, ath5k_tasklet_ani);
 
 	INIT_WORK(&ah->reset_work, ath5k_reset_work);
 	INIT_WORK(&ah->calib_work, ath5k_calibrate_work);
diff --git a/drivers/net/wireless/ath/ath5k/rfkill.c b/drivers/net/wireless/ath/ath5k/rfkill.c
index 270a319f3aeb..855ed7fc720d 100644
--- a/drivers/net/wireless/ath/ath5k/rfkill.c
+++ b/drivers/net/wireless/ath/ath5k/rfkill.c
@@ -73,9 +73,9 @@ ath5k_is_rfkill_set(struct ath5k_hw *ah)
 }
 
 static void
-ath5k_tasklet_rfkill_toggle(unsigned long data)
+ath5k_tasklet_rfkill_toggle(struct tasklet_struct *t)
 {
-	struct ath5k_hw *ah = (void *)data;
+	struct ath5k_hw *ah = from_tasklet(ah, t, rf_kill.toggleq);
 	bool blocked;
 
 	blocked = ath5k_is_rfkill_set(ah);
@@ -90,8 +90,7 @@ ath5k_rfkill_hw_start(struct ath5k_hw *ah)
 	ah->rf_kill.gpio = ah->ah_capabilities.cap_eeprom.ee_rfkill_pin;
 	ah->rf_kill.polarity = ah->ah_capabilities.cap_eeprom.ee_rfkill_pol;
 
-	tasklet_init(&ah->rf_kill.toggleq, ath5k_tasklet_rfkill_toggle,
-		(unsigned long)ah);
+	tasklet_setup(&ah->rf_kill.toggleq, ath5k_tasklet_rfkill_toggle);
 
 	ath5k_rfkill_disable(ah);
 
-- 
2.17.1

