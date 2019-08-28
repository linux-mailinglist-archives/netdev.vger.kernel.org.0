Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A840BA0B7D
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfH1U32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:29:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36193 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfH1U30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:29:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so1127043wrd.3
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mP0oWuvYIIai4oGQm0JXIEO1a6KCIGfpdj9/FpSZJUk=;
        b=PpOChrVDOzp/mWn+9faGVH8jY+RaLdKoSXuFHrTKeOwXnkJL502k5Qk3CotnCqObkA
         6lwPbuEqv/2lRaCPoe8Bu4jIjnXUPPwV5EEQxqa7xXpm2Y1zlsMNcQr30R+YHlAEEVw4
         oWKR+jOSLTdhQg1gUvT2DqBoqJV+zsBkFsAoagrR7Z4SHwCx4nkXMMEergVxkmy/iGdb
         RXNgxYf8W+y4xHx4FOK6gmCUr9zzsfwrqp0cLYK6JfePPWoW1U5/1WNrPSD2iXVHNQz8
         cWcnlUHl7rsuzNAdbtOJ6VNyeXx/0/CCPLu3MKdS5JKXkT3eJiEM3lS7RbvQw4ysg8JF
         ggLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mP0oWuvYIIai4oGQm0JXIEO1a6KCIGfpdj9/FpSZJUk=;
        b=Vt/hwd62tm4cOMWr1+TjjihcGelb0pz66RwjR+b/sGgRiqPwksehbD0ISDKIo/jBk2
         IsvrkPTvprSiAeW/lpYfrdibbwh+SL4K5/NOO85/PGa/fwQWgdmEGIh8G8NmojJaCSJ1
         idRoPmBZZpsegWCVrqX8qMymXGKsPfKZV5qJkVpTtomgHm/VmyfEIMZih0tIic48bYGl
         9+1wvvFfJFIXX2uDjxBpLi1thC8maeTMK/z08GLKRCdjT+D8ebB8wicZMaTBYTaVwDNY
         sX/d+NHgZ6Ubo9niyv10UTitiqMbXg7cRO6QWKK5RDhHT4ScOaGkVES39UQ3cMDQ15XW
         Qf9g==
X-Gm-Message-State: APjAAAXZLp7a8ZsX8ccWPzph2Fp5rUeKmjsQBW3meRes/k0B+Ussd3hJ
        rFw0NuGniblMTqIhhBBqOHs=
X-Google-Smtp-Source: APXvYqzVO2S/47elQdtSvpQMs1CaVZjwQJtxNO6YZmEvlY2WSEUUIcRvoOAzzHqXpeok4kDfEk+mTw==
X-Received: by 2002:adf:f1cc:: with SMTP id z12mr6852385wro.125.1567024164994;
        Wed, 28 Aug 2019 13:29:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9? (p200300EA8F047C00AC08EFF5E9D677A9.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9])
        by smtp.googlemail.com with ESMTPSA id m23sm503776wml.41.2019.08.28.13.29.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 13:29:24 -0700 (PDT)
Subject: [PATCH net-next v2 2/9] r8169: restrict rtl_is_8168evl_up to RTL8168
 chip versions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Message-ID: <06dccc41-712f-0eec-3304-8f82c296aa4b@gmail.com>
Date:   Wed, 28 Aug 2019 22:24:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend helper rtl_is_8168evl_up to properly work once we add
mac version numbers >51 for RTL8125.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bf00c3d8f..e9d900c11 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -730,7 +730,8 @@ static void rtl_tx_performance_tweak(struct rtl8169_private *tp, u16 force)
 static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
-	       tp->mac_version != RTL_GIGA_MAC_VER_39;
+	       tp->mac_version != RTL_GIGA_MAC_VER_39 &&
+	       tp->mac_version <= RTL_GIGA_MAC_VER_51;
 }
 
 static bool rtl_supports_eee(struct rtl8169_private *tp)
-- 
2.23.0


