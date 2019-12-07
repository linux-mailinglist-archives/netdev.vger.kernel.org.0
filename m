Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14AE8115EED
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 23:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfLGWWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 17:22:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51108 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfLGWWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 17:22:00 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so11635449wmg.0
        for <netdev@vger.kernel.org>; Sat, 07 Dec 2019 14:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9eN0UlcceLB+02/NR1bfFO3qLnGIg50B9s9GenSzY2w=;
        b=QJC+xAuQ7884+wQyIiocnJGLDtpRCT5F4iJf6m382urf7PWc2J/aORttHzKVWYXyvt
         P3z7y3vMNXTvCS2tPfy+S0C4FO39ZXF8vvB8ZPBCFRnRxHxAPw7YfqRV4AXi/uWfHVd0
         c8dCiGn2TvZFgZyRH04wDbj29w89p+AdEIkBXsKKjBZmW+wW2VFbO05vIq9VRIBytKY0
         Q1W7Dg5BV7bC0dhC6Cz7/3TfQIf4PNshKENvuB0Kdb/UtEGJnWfIXFJdB9bZzJ061xa7
         +iH7q6NXZXP0TPb6iYbYDVaMlJgGCu8FjYzlp/TmNWFrRwm3yg8dhgxLklv2dPRGdcHe
         rZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9eN0UlcceLB+02/NR1bfFO3qLnGIg50B9s9GenSzY2w=;
        b=hDHiInVTgDzCZqd6ml6pIUEPWgUmGC1DgL0r/bcHkeU7xcUh/p/cT+AMJlNGjvR+vZ
         UyDKSASYQ278iJ8Nzrs3MT9airAn3eHzISZCOPN2vm4A0pEfhE9OUtS74V9Ro/4G7/cM
         OWzEry7u1zgrNf3Mm+uxIUj5T/eJMaOnbXLhsxhp2IQpvXBHE8o9udiw5yApAQN5wmAl
         F69UZGFN8zGl21Hqv2O4V5Tm1XsI+YV2ou3cyCekd2RtYbh/CAc90SHL27QMX2IMj495
         g8OLNV8lOyGC+RjbzWjojDzmFutexIJPKDtO4+8JgaRfWS4+SNNXFiooemyL8GDKlU3G
         RJ5A==
X-Gm-Message-State: APjAAAVIdVyhTY4zI81p28iYdHMZZVgodiJ8B/PnjHQku2ggplnrBtLW
        s4ttlCKZIiud+xy0DFIKRJprCc5v
X-Google-Smtp-Source: APXvYqzYW/J3aubOxWLPOSxn4RpwS9lzbpt5kNfDteLJ6pABWkyz5UF4kBkQSa8XlBG4Zv8nlJHehg==
X-Received: by 2002:a05:600c:2207:: with SMTP id z7mr16629617wml.138.1575757317424;
        Sat, 07 Dec 2019 14:21:57 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:4590:2172:4cf5:2ac? (p200300EA8F4A6300459021724CF502AC.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:4590:2172:4cf5:2ac])
        by smtp.googlemail.com with ESMTPSA id h97sm22682554wrh.56.2019.12.07.14.21.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Dec 2019 14:21:56 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net] r8169: fix rtl_hw_jumbo_disable for RTL8168evl
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <32cb0ca8-3a90-1b95-b928-af00c603876f@gmail.com>
Date:   Sat, 7 Dec 2019 22:21:52 +0100
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

In referenced fix we removed the RTL8168e-specific jumbo config for
RTL8168evl in rtl_hw_jumbo_enable(). We have to do the same in
rtl_hw_jumbo_disable().

v2: fix referenced commit id

Fixes: 14012c9f3bb9 ("r8169: fix jumbo configuration for RTL8168evl")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 38d212686..46a492229 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3896,7 +3896,7 @@ static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
 		r8168dp_hw_jumbo_disable(tp);
 		break;
-	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
 		r8168e_hw_jumbo_disable(tp);
 		break;
 	default:
-- 
2.24.0

