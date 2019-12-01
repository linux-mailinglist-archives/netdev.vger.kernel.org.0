Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECAE10E150
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 10:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfLAJwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 04:52:05 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54395 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfLAJwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 04:52:04 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so18442961wmj.4
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 01:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=8pa2R/liC5BywK5zETT1NjHyjyb3C7QT1kjvUgqk8Oo=;
        b=F4fX8+0JRLi6U6IP6CQaBiZSQGJVQilUCMWjp9NuiGUljMsG/OcEBgH7LoHb/Z1fKH
         0g+5JJLzEAkO+gLaBj2lm4OajNE1PeytNAk3uO0rVgTG/hvWuVeZ39XMXDisne1t8t6t
         /chZPJbcmxpOxOd2gES2wBTTLLbd5ZEW4sC4/jqAHNrXUxbq8uQtlGtcV8car6dEuVxy
         1nnXvghNh0zl85GtwPsdVoEHOQJmcCHRXirSQzDSdaKHTMdqpiMJwmBO6hVFhm/obfQc
         pwASOBTFkSIeY5rRU+INzWjvn0+Mqb3ER4zUTMaeJcxufoBPpaNBGxG5dtFvaNU10Asq
         BT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8pa2R/liC5BywK5zETT1NjHyjyb3C7QT1kjvUgqk8Oo=;
        b=qnZAzX8H6qnIrW/miiyh4kQ9k+t3sexVEPcCDaC7mBKlkmQ+sH/dfziFwRIf8G7Age
         t/CHkmY6LJ+SXrO0ynkN0jC4nVI5sM5fdaD0qWp2jAQoca9oYKtlUFCZqBCUybvvLuvI
         uj8RDLazXm1UWY1baH47jlVsgdv5/ZqwLkrXuLcjrEslxNP1318vs5RjiHwtU6ElK8dM
         CvLDPdGzXEJXJUNEl9kJjDJDnPX7uPc8a84vfISXPvXTzsSoeV4TtUmzWX7A14eIkv9J
         Zr3ZVyGqhwM2koKfz5yXyhO52JsbrexJbtJLr0d0cw1h9QPiDEFu9RuAtS5QZAJhZZRr
         SBtw==
X-Gm-Message-State: APjAAAWbyhxuYWdVtjNOKesaUfja2MCyo+8E8kz14BPqKvrSf7n1RPDL
        kXUlbc+dcoR7CjsGPwLgMws=
X-Google-Smtp-Source: APXvYqyqlLYiiT5o5HnE4eUDwjG6ua5KJXBFye9oLerWH30iQd0bqmKKtAiAHRvHS5XQfiNxnlNpww==
X-Received: by 2002:a05:600c:2911:: with SMTP id i17mr22307835wmd.83.1575193922742;
        Sun, 01 Dec 2019 01:52:02 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:1159:8f18:7fad:7ef1? (p200300EA8F4A630011598F187FAD7EF1.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:1159:8f18:7fad:7ef1])
        by smtp.googlemail.com with ESMTPSA id x10sm34452965wrv.60.2019.12.01.01.52.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Dec 2019 01:52:02 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix jumbo configuration for RTL8168evl
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Alan J. Wylie" <alan@wylie.me.uk>
Message-ID: <a5348ef4-24be-ece0-c9b2-27c8dc7e0c06@gmail.com>
Date:   Sun, 1 Dec 2019 10:27:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alan reported [0] that network is broken since the referenced commit
when using jumbo frames. This commit isn't wrong, it just revealed
another issue that has been existing before. According to the vendor
driver the RTL8168e-specific jumbo config doesn't apply for RTL8168evl.

[0] https://lkml.org/lkml/2019/11/30/119

Fixes: 4ebcb113edcc ("r8169: fix jumbo packet handling on resume from suspend")
Reported-by: Alan J. Wylie <alan@wylie.me.uk>
Tested-by: Alan J. Wylie <alan@wylie.me.uk>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0b47db2ff..38d212686 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3873,7 +3873,7 @@ static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
 		r8168dp_hw_jumbo_enable(tp);
 		break;
-	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
 		r8168e_hw_jumbo_enable(tp);
 		break;
 	default:
-- 
2.24.0

