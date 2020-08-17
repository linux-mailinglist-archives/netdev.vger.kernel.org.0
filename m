Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D2324620E
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgHQJJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728852AbgHQJI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:08:58 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028DCC061389;
        Mon, 17 Aug 2020 02:08:58 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mt12so7503716pjb.4;
        Mon, 17 Aug 2020 02:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D+11JrgXx7k4d/FBCFtyQxCBWxyvZCVFtXZuzuow0+s=;
        b=BuOgHzE28eNNZeAco81WMgtdeCy3BCMioAewuwDcPW9jxpWv0Fx583aJMZcCBWK7h6
         qh0oWohqomHQV8AGV515Ji7QHCKUsODKV6t/lJH/ZmUnggwMWtbBTKMj3Aj/J/V5RHyv
         EhKx3r4q+fYBg2EbYvIdf/XmSq5XK38tKOt++5XQkfShCQPPu7ucl+YhCqbxRw/Zen1L
         o2BCvZM1LsvcxdcnVhYEW3YsXG+DyZMCqdJ1yfF9K6OpCI/cxQV4L8mHlv4pMXJA3RcN
         Fo5zwoYoznOB4Alio5BN19B87afO8+TEEC4Gt0Nx/56CRQnRrHtdoq5ErrOYIso7P65A
         AUxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D+11JrgXx7k4d/FBCFtyQxCBWxyvZCVFtXZuzuow0+s=;
        b=ABANBWy8CXSlZisvNibhy2Qty1h4fC5m/8fW/lWbXa3pQ2AeLop3yjOVWtVO5Q0F/t
         t0UjCOhm4wYrHReT5aVOtUgmglNIKzSY982LJCrNCnxZ55iSvIWGXws647CJJXVlmZO/
         Cbu01uq4lk2yex+8ViRuUDvGVomFZTYWZtxAMqiO91mquSWYnp6m8zSJyr7YZhXt9YO/
         biF28B89l4erXBngbbc9qaM/135WGSeVfpbO3klBcao1dWfpqN3HhGfWjW3u07cyFY67
         /lRlZTCDqkW32k2agLKsDy/7dQLgomcYQqlxrlADz1eeu+JM+jUa3lVLSJUOXXXad4Lg
         eWzQ==
X-Gm-Message-State: AOAM530rN/X11j0/+AN7ump7aBsuzebJzSq93QLs8s7ZhvQXN9BgBxF0
        +EY1/Z2PxODeIZIC4+hetbk=
X-Google-Smtp-Source: ABdhPJys3AsmwHjPrNMuZrrc4BAN4yRcYm8S/SES9n5z7vXN5z3HTEzUCoo7hzUnU+Zzpgrz7BhseQ==
X-Received: by 2002:a17:90a:eb17:: with SMTP id j23mr11440313pjz.151.1597655337480;
        Mon, 17 Aug 2020 02:08:57 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:08:56 -0700 (PDT)
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
Subject: [PATCH 16/16] wireless: zydas: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:37 +0530
Message-Id: <20200817090637.26887-17-allen.cryptic@gmail.com>
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
and remove .data fieldd

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 65b5985ad402..8b3d248bac6e 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1140,9 +1140,9 @@ static void zd_rx_idle_timer_handler(struct work_struct *work)
 	zd_usb_reset_rx(usb);
 }
 
-static void zd_usb_reset_rx_idle_timer_tasklet(unsigned long param)
+static void zd_usb_reset_rx_idle_timer_tasklet(struct tasklet_struct *t)
 {
-	struct zd_usb *usb = (struct zd_usb *)param;
+	struct zd_usb *usb = from_tasklet(usb, t, rx.reset_timer_tasklet);
 
 	zd_usb_reset_rx_idle_timer(usb);
 }
@@ -1178,8 +1178,8 @@ static inline void init_usb_rx(struct zd_usb *usb)
 	}
 	ZD_ASSERT(rx->fragment_length == 0);
 	INIT_DELAYED_WORK(&rx->idle_work, zd_rx_idle_timer_handler);
-	rx->reset_timer_tasklet.func = zd_usb_reset_rx_idle_timer_tasklet;
-	rx->reset_timer_tasklet.data = (unsigned long)usb;
+	rx->reset_timer_tasklet.func = (void (*)(unsigned long))
+					zd_usb_reset_rx_idle_timer_tasklet;
 }
 
 static inline void init_usb_tx(struct zd_usb *usb)
-- 
2.17.1

