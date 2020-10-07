Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82B9285CB0
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgJGKSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbgJGKSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:18:00 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F194FC0613D2;
        Wed,  7 Oct 2020 03:17:59 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k10so1494313wru.6;
        Wed, 07 Oct 2020 03:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PrZHgoHwx+8u1/cy9dkjn6c9rWW6kI8dskt+mlUcuL4=;
        b=YAyNSKmrlZECEsQsYfztmczdbHiXVB5bsPiFmxOFIAET6TjdLpos+HyIAD4Kv2cRe8
         IWVu0sRjgw1Js4O0XN/Vq0FUIEkmWomBagBwjpNtm2UU/sCNyGdsQfVv4H5+Gq+/ZnsL
         oyS6P20zqcuK8B0XUgB4rv9/1BLgV18WC8KbzUSd4gdomsM4SGJ2JyC31B9N8Ye4Gbvd
         0tqf5FwqTYqVeGQchpY/FdITDu4FZxEeIgxGRqLc/9qPMpIUi4Yng7mv4Zjb73cQrFGD
         3b0Bcd/SGDCuDII31KeENjDHLHwxHp1rlULWnhzJvbVRJfifaX0iv0By9uTg+aNF1jMo
         YNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PrZHgoHwx+8u1/cy9dkjn6c9rWW6kI8dskt+mlUcuL4=;
        b=QwmOuf9GdD3g5aHKalneWnAvmH8xEylGJldrwNaD9vCWpyrqSQD59HmRUZjKfPAigq
         1UNXxAVKZdHUFINNBoEUFEgYjMNnVHSZAFGY7DiN4+ZDzgDCAMCVC0wStyZ5Rep5UD+P
         v1074mhpryK95uVOeHYivjYhk5iLRxQYeh8J1IG1scYmZwVsRtFawybVBbYFakGFBtbr
         OTEaAgp6CLRC+CQsO+8oe7UjJWb7t0njPLIxzgaseT2QabBkcXZg9kuI3QhFxWg/WRAT
         0+YWz2rbx58fpU3trF9uXBCQVdJmWlUkCnNZHnSUeZEcHzL6xmomdKrcWMPnj60c5Uy4
         eokA==
X-Gm-Message-State: AOAM532O1ugc06wKUMHpMt2cmPEQ5D48VcMD5DiR+l5J0EAVjC4lJgxR
        0CdeVSGlOF+1loW1YDVFDaPFTTByrcU4Rdpj
X-Google-Smtp-Source: ABdhPJxQJLHjvhwq4UaVCUsIgyqBcpYW8JqyymbOZ+t6Ge87O3Ej71NY2tzRxuf6sYSJePvKpM4cjg==
X-Received: by 2002:adf:f508:: with SMTP id q8mr2546894wro.233.1602065878650;
        Wed, 07 Oct 2020 03:17:58 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id u12sm2249168wrt.81.2020.10.07.03.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:17:58 -0700 (PDT)
From:   Aleksandr Nogikh <a.nogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Subject: [PATCH 2/2] mac80211: add KCOV remote annotations to incoming frame processing
Date:   Wed,  7 Oct 2020 10:17:26 +0000
Message-Id: <20201007101726.3149375-3-a.nogikh@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
In-Reply-To: <20201007101726.3149375-1-a.nogikh@gmail.com>
References: <20201007101726.3149375-1-a.nogikh@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

Add KCOV remote annotations to ieee80211_iface_work and
ieee80211_tasklet_handler. This will enable coverage-guided fuzzing of
mac80211 code that processes incoming 802.11 frames.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
---
 net/mac80211/iface.c | 2 ++
 net/mac80211/main.c  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 240862a74a0f..482d2ae46e71 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1377,6 +1377,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
 		struct ieee80211_mgmt *mgmt = (void *)skb->data;
 
+		kcov_remote_start_common(skb_get_kcov_handle(skb));
 		if (ieee80211_is_action(mgmt->frame_control) &&
 		    mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
@@ -1486,6 +1487,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 		}
 
 		kfree_skb(skb);
+		kcov_remote_stop();
 	}
 
 	/* then other type-dependent work */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 523380aed92e..d7eebafc14e0 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -227,6 +227,7 @@ static void ieee80211_tasklet_handler(unsigned long data)
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
+		kcov_remote_start_common(skb_get_kcov_handle(skb));
 		switch (skb->pkt_type) {
 		case IEEE80211_RX_MSG:
 			/* Clear skb->pkt_type in order to not confuse kernel
@@ -244,6 +245,7 @@ static void ieee80211_tasklet_handler(unsigned long data)
 			dev_kfree_skb(skb);
 			break;
 		}
+		kcov_remote_stop();
 	}
 }
 
-- 
2.28.0.806.g8561365e88-goog

