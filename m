Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722BD496362
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381965AbiAUQ5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379623AbiAUQ4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:56:48 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF27C061747;
        Fri, 21 Jan 2022 08:55:25 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id x31-20020a056830245f00b00599111c8b20so12504870otr.7;
        Fri, 21 Jan 2022 08:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JlNCFKNGzNdKjL5cT/OHwG1B8Niqq4wld0y5z7aO8fE=;
        b=P3ZOxoBv55viB3dAfzKSRe+1LS/DMWgFmA6bqUxm/ovvkTeWR7NZqhHJARZwrUpfYV
         uAFpzChQtQvMYNxvF/wyh4OHPqWPfCq47VgxTMbA+mzmCT96pCpWnZBa03Ixea6CK5f7
         g3Xcg6Y0PlXxcUVkWZi/CoU+wO7N81b5NqB7KfvZjp0AmELclzB6hax5OLTKOVulGG6Z
         lgOqc9YMRKttH758573dUWbIihX69VAZTXTSbwZNlq57Dr6V2KTAWzbRH8q9gdyGW900
         VR5DVtQcVujUJMM10ZSPz7SGbf3C6tr9N2vjIDMDUlBgkW3HC4bxfmNHIFxq/Bwaimgt
         EMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JlNCFKNGzNdKjL5cT/OHwG1B8Niqq4wld0y5z7aO8fE=;
        b=1qlWrfh/+87e68oCeGiBHiw22UWOyIRzE7xa3+zziEhEKbenVk7LBRFpDVQU7Ws168
         LyivcYWSFqS3a1of0sfemCS+RwEB8FBm7JTJdWoD7ZT0bnCl8NGrOUwbSPtIU0NDElpp
         HtWmFij8RizE7KZYBwFslGhdfG1qhlAPcG/V9YYvZ/pAN2zPPBrhc96eV8HJAVLrzFFd
         5hvVC7y0jEvdztKTjnlvl9K0oSI7s2ysnTqtntBNav3Uz07GAJXt15C39xLuVmupr/Ui
         gIwfFzpx80mKmpsuItwAfPMLSdSqh5JkuPrKTISE8pCkmWnJWLn47LcItAgbjLBtaQIS
         DfSA==
X-Gm-Message-State: AOAM530pVEnp+zYYqqSvTXSBH95dYicEpZmSVuDNFdGQ6A3mgdWZN2eq
        EPAfCTYWSedEHMKCGRzc327432z8Q0I=
X-Google-Smtp-Source: ABdhPJzLLejlyKQ1rc8bYS0Xd9Akuzio8gSFpnxClDl2uhTyxnM4hGeyoWTzSS5u4eKTAtH0DLZGSg==
X-Received: by 2002:a05:6830:3152:: with SMTP id c18mr3444071ots.244.1642784125013;
        Fri, 21 Jan 2022 08:55:25 -0800 (PST)
Received: from thinkpad.localdomain ([2804:14d:5cd1:5d03:cf72:4317:3105:f6e5])
        by smtp.gmail.com with ESMTPSA id y8sm1089271oou.23.2022.01.21.08.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 08:55:24 -0800 (PST)
From:   Luiz Sampaio <sampaio.ime@gmail.com>
To:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 19/31] net: realtek: changing LED_* from enum led_brightness to actual value
Date:   Fri, 21 Jan 2022 13:54:24 -0300
Message-Id: <20220121165436.30956-20-sampaio.ime@gmail.com>
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
 drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
index 49421d10e22b..6ddbdb5e3fa5 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
@@ -109,7 +109,7 @@ static void rtl8187_led_brightness_set(struct led_classdev *led_dev,
 		return;
 	priv = hw->priv;
 	if (led->is_radio) {
-		if (brightness == LED_FULL) {
+		if (brightness == 255) {
 			ieee80211_queue_delayed_work(hw, &priv->led_on, 0);
 			radio_on = true;
 		} else if (radio_on) {
@@ -118,7 +118,7 @@ static void rtl8187_led_brightness_set(struct led_classdev *led_dev,
 			ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
 		}
 	} else if (radio_on) {
-		if (brightness == LED_OFF) {
+		if (brightness == 0) {
 			ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
 			/* The LED is off for 1/20 sec - it just blinks. */
 			ieee80211_queue_delayed_work(hw, &priv->led_on,
-- 
2.34.1

