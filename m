Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8180C496353
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380356AbiAUQ5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380350AbiAUQ44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:56:56 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE6CC061775;
        Fri, 21 Jan 2022 08:55:51 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id s9so14319296oib.11;
        Fri, 21 Jan 2022 08:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JWwCA6Os6ufO2OamoDdA1VpkWXg1qWYv/gpuXYzvEa0=;
        b=MjAl/2d7hFcNgyCHuaDhSHTjyebU3drd8M3jU8y2IQsqE6Okaz0WRef5nk97QClDqB
         dvRMz5ydDfyCVO7XtDrt7BlmMK8yIEirVQKVXa4Ab0p+oKDAgX92r7pE+hkI77CSUetS
         MH/DYXn1WvTkPKI+tE5gsImAWrq+f6bwAihvF9Zrbyyajq/ZWrGOG31AcvN0xvHHsQ/a
         76Zbei7//5h/FF2ZDZo4d56PGsZXeyiJsEbzfQNDCrF7XS9IcXprwm/icw8/L0rshHl1
         SNFx7oImgsZ6tDJvJDrHND4vFRrTq7IlAxO8d9ISxYF3yqUI1B4MhMf2hN48A52BFZM4
         0oSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JWwCA6Os6ufO2OamoDdA1VpkWXg1qWYv/gpuXYzvEa0=;
        b=PxZNcHG/qr/KxQvSQ1Z9i/Ov/3ZWXQQV57z6Hde1O73TuAe56EUWAIHv+/D4NSLYxH
         gF/MOXhjuzR3vrTETsC9D3rbz9FC/IG0EswFyqKE1wnVgqT8MZxbXlh5pt7kS35q46Az
         hC/zNMnZmvNm5+zl4MBWgmZG1PfPxThqIUynx7fq31dWXf49PYxkjxsQre9tubgCmVwd
         XWN45CZ5h7TlJdOIu8XSQYIOJtDbRuYCrSVW7BtOb/Z7hZpqocefiQCkAj1q0JVz6tBq
         yYJwNKToy60bjwXNxee7ORLWfkAt56c1QhVd6SUTudwJ4ETv2tLm8NcBtMvEZIQChkaP
         LnBQ==
X-Gm-Message-State: AOAM530DTZW9qPeXPJHeZmcgvj4F48d0hh8/+HtBjC8ID8AA9Xs3bUro
        ViGcXU20Mrstl/VKD7oQ1t0=
X-Google-Smtp-Source: ABdhPJy/+XAmfEonekRvbRYH2yUx5daOlccr8uacmMOv+0HVuWMPQYm2UMLY4TsXH0dx9xykQjzivA==
X-Received: by 2002:a05:6808:1442:: with SMTP id x2mr1217003oiv.166.1642784150774;
        Fri, 21 Jan 2022 08:55:50 -0800 (PST)
Received: from thinkpad.localdomain ([2804:14d:5cd1:5d03:cf72:4317:3105:f6e5])
        by smtp.gmail.com with ESMTPSA id y8sm1089271oou.23.2022.01.21.08.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 08:55:50 -0800 (PST)
From:   Luiz Sampaio <sampaio.ime@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 27/31] net: mac80211 : changing LED_* from enum led_brightness to actual value
Date:   Fri, 21 Jan 2022 13:54:32 -0300
Message-Id: <20220121165436.30956-28-sampaio.ime@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220121165436.30956-1-sampaio.ime@gmail.com>
References: <20220121165436.30956-1-sampaio.ime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enum led_brightness, which contains the declaration of LED_OFF,
LED_ON, LED_HALF and LED_FULL is obsolete, as the led class now supports
max_brightness.
---
 net/mac80211/led.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index 6de8d0ad5497..ac36579636bb 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -14,9 +14,9 @@ void ieee80211_led_assoc(struct ieee80211_local *local, bool associated)
 	if (!atomic_read(&local->assoc_led_active))
 		return;
 	if (associated)
-		led_trigger_event(&local->assoc_led, LED_FULL);
+		led_trigger_event(&local->assoc_led, 255);
 	else
-		led_trigger_event(&local->assoc_led, LED_OFF);
+		led_trigger_event(&local->assoc_led, 0);
 }
 
 void ieee80211_led_radio(struct ieee80211_local *local, bool enabled)
@@ -24,9 +24,9 @@ void ieee80211_led_radio(struct ieee80211_local *local, bool enabled)
 	if (!atomic_read(&local->radio_led_active))
 		return;
 	if (enabled)
-		led_trigger_event(&local->radio_led, LED_FULL);
+		led_trigger_event(&local->radio_led, 255);
 	else
-		led_trigger_event(&local->radio_led, LED_OFF);
+		led_trigger_event(&local->radio_led, 0);
 }
 
 void ieee80211_alloc_led_names(struct ieee80211_local *local)
@@ -344,7 +344,7 @@ static void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local)
 	tpt_trig->running = false;
 	del_timer_sync(&tpt_trig->timer);
 
-	led_trigger_event(&local->tpt_led, LED_OFF);
+	led_trigger_event(&local->tpt_led, 0);
 }
 
 void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
-- 
2.34.1

