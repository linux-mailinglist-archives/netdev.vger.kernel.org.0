Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FEB246219
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgHQJJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728786AbgHQJHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:07:49 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0CFC061342;
        Mon, 17 Aug 2020 02:07:48 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id d4so7383714pjx.5;
        Mon, 17 Aug 2020 02:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n+X9d5vT8SC5Pz64vMe7g5tLMlNwSaXJUm4aDGP4qA4=;
        b=HklbjWKAcCZdZeoSN/XgxzMU8/wRR2Auy4T9VjyP8XL3EIQu/B9o+zT6u5qH1TWRTO
         au79B2xEPMbiU4xrZ7zXzCQg2VLDMdMpeFEnijkByJRFPZk21pfGl8pTIGNrHe4rZ0ni
         dYqi+t1m58tLfCir+Phy7Nl8KTdaT/s097e8/hTweB1PlagUBuFpF8aWswX9j0LeZKWC
         SWAUNzK2TtD0qVupQ4jErl5/7mwh5liwf091mhsSzuXH9r+7nJpo8ac6gvpD2+63nUd0
         leTlsxBQRsRxUbOwtInPSxCIdbsoxDt1COqkjCjyv37RC5EcRiqk8ywMT1xhU2a9+yso
         deDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n+X9d5vT8SC5Pz64vMe7g5tLMlNwSaXJUm4aDGP4qA4=;
        b=YsltANe3mtkQ1ThVLUTf3gt3s8H1WY5KDpftSzSKsY8fVHEac3T+FmGu5+RoNRsTsa
         o+RYtl2xA1+lFC5SMKu48h2arsXJFR2VO857xYTMANwLMLE/xS/PRuZFeaBQ1IdHoHxO
         tOi8jVv8DMYRyCqiJMI6E6bmcefC5gyfQU4t99Hxasmaf3C44MZwD0rhacQjB5TubVSt
         t3xyDdU90WIOlP/gcyLJDJCZGCkZ9qDpid+oER003CZExF478IlKbQByp/OtugHTpY3H
         XCxdDQHPrAGlfPDK+meZldKWj889VI4VSicHcahpA/+6CzcIIxvhOHwVq9dx/Wo7I9SF
         1tdw==
X-Gm-Message-State: AOAM530s5DiV5PxAhNnSmx36E5gLF/jrgUQq/gJOWsc8XIGlatoxr8Pw
        Jmg1TskVqkdJOAU84c9QOi8=
X-Google-Smtp-Source: ABdhPJyi1nfjNr696xImaFKXbCsrOUzUKLp19qvJx/y7bR1RGilmldIE98IAYhPWvrOKTAjfe6rlfA==
X-Received: by 2002:a17:902:7484:: with SMTP id h4mr10089195pll.139.1597655268400;
        Mon, 17 Aug 2020 02:07:48 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:07:47 -0700 (PDT)
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
Subject: [PATCH 07/16] wireless: brcm80211: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:28 +0530
Message-Id: <20200817090637.26887-8-allen.cryptic@gmail.com>
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
 .../net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c  | 6 +++---
 .../net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.h  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index 648efcbc819f..521abe5ce5b8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -982,11 +982,11 @@ static const struct ieee80211_ops brcms_ops = {
 	.set_tim = brcms_ops_beacon_set_tim,
 };
 
-void brcms_dpc(unsigned long data)
+void brcms_dpc(struct tasklet_struct *t)
 {
 	struct brcms_info *wl;
 
-	wl = (struct brcms_info *) data;
+	wl = from_tasklet(wl, t, tasklet);
 
 	spin_lock_bh(&wl->lock);
 
@@ -1149,7 +1149,7 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 	init_waitqueue_head(&wl->tx_flush_wq);
 
 	/* setup the bottom half handler */
-	tasklet_init(&wl->tasklet, brcms_dpc, (unsigned long) wl);
+	tasklet_setup(&wl->tasklet, brcms_dpc);
 
 	spin_lock_init(&wl->lock);
 	spin_lock_init(&wl->isr_lock);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.h
index 198053dfc310..eaf926a96a88 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.h
@@ -106,7 +106,7 @@ struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 void brcms_free_timer(struct brcms_timer *timer);
 void brcms_add_timer(struct brcms_timer *timer, uint ms, int periodic);
 bool brcms_del_timer(struct brcms_timer *timer);
-void brcms_dpc(unsigned long data);
+void brcms_dpc(struct tasklet_struct *t);
 void brcms_timer(struct brcms_timer *t);
 void brcms_fatal_error(struct brcms_info *wl);
 
-- 
2.17.1

