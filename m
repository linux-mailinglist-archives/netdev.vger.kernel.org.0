Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D94749634B
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381605AbiAUQ5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379719AbiAUQ46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:56:58 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092DFC061779;
        Fri, 21 Jan 2022 08:55:58 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id a12-20020a0568301dcc00b005919e149b4cso12496259otj.8;
        Fri, 21 Jan 2022 08:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=si2C+vA2MagtGvM7KQVl7R4c/GkdTJnQxP83OLRcJVk=;
        b=UQGLTtt5LSEMTK67FS1ihHCiUCpYDCH9lpQphiGsNhgiy4hAmw4ejccESomUBNnmB/
         aYQ+4LcEArvrDIG0KkSm+4Ai3oIf2AnPCZ0KVnCMpAPm6NmRJ/V03BR5V/c4yIjI3kSu
         sf6hDb0a5KoXclLLT2u8NhgaTaHM4G9x5Lf3cyL3IBsm9HRi8O4LZ3+tvWjCf5BpyHa6
         tU4u/eRjs08GGNLHGtmpGMVnxgQAQF8uuASICG2GeIA2YhrzNxE2VccrdIUVKCESgwuU
         PYiTQH7jFNvJ3TyAuWIk3er2Op6E1kVZTdCJ/oh+lDvRopzfcAndcm2pPBfLGRlGJea9
         iWwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=si2C+vA2MagtGvM7KQVl7R4c/GkdTJnQxP83OLRcJVk=;
        b=TF8vtws4ovSk2Ph1+ialGaKJTCekWhIt7+A+Ez/PYTh8h6q93Fjr9Mp8j3u4fnyglg
         WutzMcXr7NZ32CAFDYlDu46yNu9nQ8ZNdYlZy8w+hV3iaX+125QB0wfEYbyn5vh8xXpc
         eCm/iftbiEkV6AYgbxpX5R8iQhWbAVLxzzq5W/gR/r6YC7iCTR2FpG3OgDeMuuJs+iTV
         wUYofeQkRiK4AsglCypFopW8zvUHBbPe2w60jL3oIMWcpNhBMmzBRZYrkNrOCSF68Fvo
         KblIIFnMN1f+KGhzMlIJlMINIMXAdmztRHxYVWUImyqHB54ZlFp8IlV/ROsk+c/vN/+g
         c8sg==
X-Gm-Message-State: AOAM5323k6zYq7sQm0gwr66qpBeIFkQ4sDi3Gp61XtyfYU/kbEJkSXsb
        UKhICewCqFVShGR7xRMSLsA=
X-Google-Smtp-Source: ABdhPJx1jT0kqIhJYUFQF5ZtfKDl8S9daCIITgVVP8nCR1xY42JaZ2RR+AijgO/vDQjpBB6+OFVyIA==
X-Received: by 2002:a05:6830:1047:: with SMTP id b7mr3287296otp.197.1642784157446;
        Fri, 21 Jan 2022 08:55:57 -0800 (PST)
Received: from thinkpad.localdomain ([2804:14d:5cd1:5d03:cf72:4317:3105:f6e5])
        by smtp.gmail.com with ESMTPSA id y8sm1089271oou.23.2022.01.21.08.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 08:55:57 -0800 (PST)
From:   Luiz Sampaio <sampaio.ime@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 29/31] net: rfkill: changing LED_* from enum led_brightness to actual value
Date:   Fri, 21 Jan 2022 13:54:34 -0300
Message-Id: <20220121165436.30956-30-sampaio.ime@gmail.com>
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
 net/rfkill/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 5b1927d66f0d..68b4c3a71513 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -125,9 +125,9 @@ static void rfkill_led_trigger_event(struct rfkill *rfkill)
 	trigger = &rfkill->led_trigger;
 
 	if (rfkill->state & RFKILL_BLOCK_ANY)
-		led_trigger_event(trigger, LED_OFF);
+		led_trigger_event(trigger, 0);
 	else
-		led_trigger_event(trigger, LED_FULL);
+		led_trigger_event(trigger, 255);
 }
 
 static int rfkill_led_trigger_activate(struct led_classdev *led)
@@ -180,7 +180,7 @@ static void rfkill_global_led_trigger_worker(struct work_struct *work)
 	mutex_lock(&rfkill_global_mutex);
 	list_for_each_entry(rfkill, &rfkill_list, node) {
 		if (!(rfkill->state & RFKILL_BLOCK_ANY)) {
-			brightness = LED_FULL;
+			brightness = 255;
 			break;
 		}
 	}
@@ -188,7 +188,7 @@ static void rfkill_global_led_trigger_worker(struct work_struct *work)
 
 	led_trigger_event(&rfkill_any_led_trigger, brightness);
 	led_trigger_event(&rfkill_none_led_trigger,
-			  brightness == LED_OFF ? LED_FULL : LED_OFF);
+			  brightness == 0 ? 255 : 0);
 }
 
 static void rfkill_global_led_trigger_event(void)
-- 
2.34.1

