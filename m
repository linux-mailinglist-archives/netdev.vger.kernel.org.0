Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9653496350
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381825AbiAUQ5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380343AbiAUQ44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:56:56 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81043C061773;
        Fri, 21 Jan 2022 08:55:48 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id bb37so14392661oib.1;
        Fri, 21 Jan 2022 08:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/hFEnKfQJiIAaQ2mjd4rxrXqXcThyAji37idZyhsBAY=;
        b=HEDrhGVj7yfZqvkjCw8k1/FNEXYzOGPmv9dNN2Hn6Ih3y+FbsyD2K4jPUpYbNauJT8
         bhUbA4IVknUbh6oM8nQDN5aFYvnp1bOdR0zYfUmbmVsSTNpmSF+ydgzjS2IjIvPFwvOi
         wm5++I3D8YKAJmsKDWrCqlQBb21YPA7Z0xNV/ft/YJNfpkRdkRTm3j2l3quXGaU2npIV
         qgGxPa2AU2MyfCpmiy+eBEn6LQ+z89Kp3A8rlk7IcSJCOA3XTiiSHqGWRCR4V1McJOKW
         1L+0wi/MNWYT1AuruOViuur8pCfx+lF/oFLKZH6fHOCNEZbY1AHof/Dlsq16lwsVaZUh
         r9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/hFEnKfQJiIAaQ2mjd4rxrXqXcThyAji37idZyhsBAY=;
        b=LD/ZRy5MlWFyv4U850/TZ/BlHnADzbQUmrAn5Vwa6GedMbqdfRPWrLcHSbpou/bVvb
         7qKIek8LORHeBtbRIf4KtkvgHkG61FqfQ0teUWxabOASx5yh+3DytZNZ+vQmk/Mq8PXG
         OUqoySn5+SgqyKWTCg7+5bAzQwPDFtDWE3zN7ZgQROiXSqgmVLcN4jC7vQhSq3pZOJ8g
         7tL7ASlFT1/c8cv0EcJHUlHgkd/NMbvg5mS+sivLTrexBxu+kyxQ6U0LLzZPvO5HAbZc
         qU7JNADXRpAhvkWtQnjQsxhLxX3Jv70ew06UQ/1B+LtNy3Jm07YF3OTXAowLfH526Ry+
         pPlA==
X-Gm-Message-State: AOAM532u1f+O5Y9zPiYTKfoPwN7PRhxDeXghqds6Maqrr9WaQRPVbgzt
        BPmBNKNRugxp8B8E40n+S0E=
X-Google-Smtp-Source: ABdhPJxuroa+LmFuxwX8sb8C/C6iB0kFXUlik7h0Gj12vxUub1iXO+HFMA6PEGE12EVI32ETMI7pNg==
X-Received: by 2002:a05:6808:1147:: with SMTP id u7mr1261723oiu.117.1642784147933;
        Fri, 21 Jan 2022 08:55:47 -0800 (PST)
Received: from thinkpad.localdomain ([2804:14d:5cd1:5d03:cf72:4317:3105:f6e5])
        by smtp.gmail.com with ESMTPSA id y8sm1089271oou.23.2022.01.21.08.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 08:55:47 -0800 (PST)
From:   Luiz Sampaio <sampaio.ime@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 26/31] net: bluetooth: changing LED_* from enum led_brightness to actual value
Date:   Fri, 21 Jan 2022 13:54:31 -0300
Message-Id: <20220121165436.30956-27-sampaio.ime@gmail.com>
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
 net/bluetooth/leds.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/leds.c b/net/bluetooth/leds.c
index f46847632ffa..7f7e3eed9407 100644
--- a/net/bluetooth/leds.c
+++ b/net/bluetooth/leds.c
@@ -22,7 +22,7 @@ void hci_leds_update_powered(struct hci_dev *hdev, bool enabled)
 {
 	if (hdev->power_led)
 		led_trigger_event(hdev->power_led,
-				  enabled ? LED_FULL : LED_OFF);
+				  enabled ? 255 : 0);
 
 	if (!enabled) {
 		struct hci_dev *d;
@@ -37,7 +37,7 @@ void hci_leds_update_powered(struct hci_dev *hdev, bool enabled)
 		read_unlock(&hci_dev_list_lock);
 	}
 
-	led_trigger_event(bt_power_led_trigger, enabled ? LED_FULL : LED_OFF);
+	led_trigger_event(bt_power_led_trigger, enabled ? 255 : 0);
 }
 
 static int power_activate(struct led_classdev *led_cdev)
@@ -48,7 +48,7 @@ static int power_activate(struct led_classdev *led_cdev)
 	htrig = to_hci_basic_led_trigger(led_cdev->trigger);
 	powered = test_bit(HCI_UP, &htrig->hdev->flags);
 
-	led_trigger_event(led_cdev->trigger, powered ? LED_FULL : LED_OFF);
+	led_trigger_event(led_cdev->trigger, powered ? 255 : 0);
 
 	return 0;
 }
-- 
2.34.1

