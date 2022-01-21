Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB025496349
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380401AbiAUQ5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380361AbiAUQ46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:56:58 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA4DC061778;
        Fri, 21 Jan 2022 08:55:55 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id s127so14386942oig.2;
        Fri, 21 Jan 2022 08:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X1prsGZ36V3LEOTvvkMgk2CqZfwnDb5j2wczkknGbpY=;
        b=M7T75cltulYZ8dLhgYXj6Dqlc+gxskyEj1qidzGRzta8A7Ws3Zr9QSTdP2w/UtNCH7
         1QfX8VMaNiOeO+aJ43N06CEVr1qHaj21QOWCh66A0Szq1y/o6Oho0NI9zlUO9u8pGT59
         EtP8QRnBXkMWCZlGNXKyV/jcv7iIlxRmyq2P2drG6x93IlqH8s6xSoTS+N5MiAShuOnK
         SlwWVtPdq0Td7Ppi3b0Y9dJHAl1tIlUGE7SGv5WstOM27x3MWNCgph2FW0eLWUqoCkHb
         AHjTTNndE/ulSBROV/tV651tAmVP3ndCfgP7y8g9poS1Z2rpgmJo+BmCTYa/riabA7NJ
         VVwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X1prsGZ36V3LEOTvvkMgk2CqZfwnDb5j2wczkknGbpY=;
        b=pqq4I2WsK6LMCR52KFx3dYLimgloQDgMER59HG7/85zl9r0CumgBCR9XpWGYnxW04M
         +LXHBkyU9no/epRg0UwbBmX2Osw93MMJQRUMJA22mQdry/HoFo/10nklRvmIHk8DQTVK
         MYQXYzldlvZfHMkXSufHv172uwqOBuSIfZSPKcvPfw4OJwTflqLTsgx4jhQMkPqDmKeo
         13dGJNjInHukhacbSnjanQLzhdAfdrWBqBDmUtafm9gxX2HnWHEgucQG/eaKoIpcdO2J
         R8CAQhyFE9S9MLmdH/L+lCjSjfjZc2sgCKFTDTXlvRp10aY2dG0sXts4C7sYofjx5cwM
         bKeQ==
X-Gm-Message-State: AOAM532XaQykolbg6b6pXgEVh8HrGOJxLnrIJJV+/+RYZE6QvLO7WPzY
        EMrGlN6Jl2ST5Z9P6i1Adm0=
X-Google-Smtp-Source: ABdhPJz8BK3W/Oh4kBRyv2FuNLqsoZfq+UPcczheQf1w5dq3RrySWoTvNPIRVTRDXq4pSGHlxozTVA==
X-Received: by 2002:a54:4097:: with SMTP id i23mr1255843oii.115.1642784154379;
        Fri, 21 Jan 2022 08:55:54 -0800 (PST)
Received: from thinkpad.localdomain ([2804:14d:5cd1:5d03:cf72:4317:3105:f6e5])
        by smtp.gmail.com with ESMTPSA id y8sm1089271oou.23.2022.01.21.08.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 08:55:54 -0800 (PST)
From:   Luiz Sampaio <sampaio.ime@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH 28/31] net: netfilter: changing LED_* from enum led_brightness to actual value
Date:   Fri, 21 Jan 2022 13:54:33 -0300
Message-Id: <20220121165436.30956-29-sampaio.ime@gmail.com>
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
 net/netfilter/xt_LED.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 0371c387b0d1..eb66e12c7ff7 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -54,7 +54,7 @@ led_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		led_trigger_blink_oneshot(&ledinternal->netfilter_led_trigger,
 					  &led_delay, &led_delay, 1);
 	else
-		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);
+		led_trigger_event(&ledinternal->netfilter_led_trigger, 255);
 
 	/* If there's a positive delay, start/update the timer */
 	if (ledinfo->delay > 0) {
@@ -63,7 +63,7 @@ led_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 	/* Otherwise if there was no delay given, blink as fast as possible */
 	} else if (ledinfo->delay == 0) {
-		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
+		led_trigger_event(&ledinternal->netfilter_led_trigger, 0);
 	}
 
 	/* else the delay is negative, which means switch on and stay on */
@@ -76,7 +76,7 @@ static void led_timeout_callback(struct timer_list *t)
 	struct xt_led_info_internal *ledinternal = from_timer(ledinternal, t,
 							      timer);
 
-	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
+	led_trigger_event(&ledinternal->netfilter_led_trigger, 0);
 }
 
 static struct xt_led_info_internal *led_trigger_lookup(const char *name)
-- 
2.34.1

