Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72F4496343
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380555AbiAUQ47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379251AbiAUQ4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:56:19 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A10EC06175C;
        Fri, 21 Jan 2022 08:55:14 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id n22-20020a9d2016000000b0059bd79f7777so12086472ota.2;
        Fri, 21 Jan 2022 08:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q356TySGpOi9cm8C15uJYgLdKIpPtBrszItNMB5sdtA=;
        b=d08sxUH3eK/+C4ImWey5IwRNyFJty2X4q2Fcg6n7ZHmZN9ctajF8uw1GBf1L5BH5I7
         V/kKVyFpnQavgkZlPTK9Wg7ngEaOyGBjaq09IRMK1VTXfYANVnxMFNgSagNRfAPoAH+D
         fFY6QEbafaDPfAMdRL/B0VVisl/qar+seAQrHGkmlFelczDkuQ0RWymHEGujEWGDcOje
         y3S9LAVnu7DcuX+DlLtdGeeYGobgEUea6WaaNt5Zq0xv1Pwt6Gcu5v1UvbeK3I45x6SX
         AeuEz12eggrSCViDGacZEm47IFancwGQ4otY0iBDgahmOIf5w5EazCIq7c1CRKotuRJh
         eoqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q356TySGpOi9cm8C15uJYgLdKIpPtBrszItNMB5sdtA=;
        b=sqCq7pT1GmeFygG2d28OyL5iaiu4ZrISrlZhZEczb7mhrfb8lBSUCgZW0jRfargdGl
         oiV6VLaEx/NAyI03+ZoIivfs9geh9Pn1WWvYqPBrBsLduak97hD3x7vftiyHERM5VaJQ
         YTm4uBaFsQWM6Si2X2umo/+fJAbkvtgpn/mfOunaxoN6hNEV4EIWgNmdOyH/3HlQJKmi
         Aq/byVl4mTN4seCztL2S/GLInssYO2FSfg0RElGntP8DjY4XM/hViv/HuVucRV/V11ro
         6FralrpgW/gT9xlOsEEgfEoMHgadcnmI8Nv3/pp927+DpjCPkBGJwuFSZhZxo3Lf9lTI
         0/HQ==
X-Gm-Message-State: AOAM532ahF59RFHp0a1A+78slma53tN4kOrh1ZlTVz+ot+hiReST0Qf7
        HZiXY0QA7pEieVxVccuIaZY=
X-Google-Smtp-Source: ABdhPJxMLXhmV3f3kN56sohiz2YckqgwjTMJ0RtIqk/x215sI8lHLYXhQHyVMgC8DtQbU8bte5FllA==
X-Received: by 2002:a05:6830:1047:: with SMTP id b7mr3285242otp.197.1642784113714;
        Fri, 21 Jan 2022 08:55:13 -0800 (PST)
Received: from thinkpad.localdomain ([2804:14d:5cd1:5d03:cf72:4317:3105:f6e5])
        by smtp.gmail.com with ESMTPSA id y8sm1089271oou.23.2022.01.21.08.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 08:55:13 -0800 (PST)
From:   Luiz Sampaio <sampaio.ime@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-kernel@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH 16/31] net: broadcom: changing LED_* from enum led_brightness to actual value
Date:   Fri, 21 Jan 2022 13:54:21 -0300
Message-Id: <20220121165436.30956-17-sampaio.ime@gmail.com>
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
 drivers/net/wireless/broadcom/b43/leds.c       | 2 +-
 drivers/net/wireless/broadcom/b43legacy/leds.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/leds.c b/drivers/net/wireless/broadcom/b43/leds.c
index 982a772a9d87..bdb46168e019 100644
--- a/drivers/net/wireless/broadcom/b43/leds.c
+++ b/drivers/net/wireless/broadcom/b43/leds.c
@@ -59,7 +59,7 @@ static void b43_led_update(struct b43_wldev *dev,
 	 * with the brightness_set handler, we will be called again soon
 	 * to fixup our state. */
 	if (radio_enabled)
-		turn_on = atomic_read(&led->state) != LED_OFF;
+		turn_on = atomic_read(&led->state) != 0;
 	else
 		turn_on = false;
 	if (turn_on == led->hw_state)
diff --git a/drivers/net/wireless/broadcom/b43legacy/leds.c b/drivers/net/wireless/broadcom/b43legacy/leds.c
index 38b5be3a84e2..5803d41185e7 100644
--- a/drivers/net/wireless/broadcom/b43legacy/leds.c
+++ b/drivers/net/wireless/broadcom/b43legacy/leds.c
@@ -66,7 +66,7 @@ static void b43legacy_led_brightness_set(struct led_classdev *led_dev,
 	 * whether the LED has the wrong state for a second. */
 	radio_enabled = (dev->phy.radio_on && dev->radio_hw_enable);
 
-	if (brightness == LED_OFF || !radio_enabled)
+	if (brightness == 0 || !radio_enabled)
 		b43legacy_led_turn_off(dev, led->index, led->activelow);
 	else
 		b43legacy_led_turn_on(dev, led->index, led->activelow);
-- 
2.34.1

