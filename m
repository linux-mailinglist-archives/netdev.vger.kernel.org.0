Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D91E115952
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 23:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfLFW10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 17:27:26 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55494 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfLFW10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 17:27:26 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so9389001wmj.5
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 14:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=C414LO0vb/jXmNgdngCgv5AXjEhFw32BbWIul5HUb/A=;
        b=BAADm3HykBLw2Kn39jRO2dKo1U/7jP3FsNHdj9vPE3uixkfm95GAefAICof5jwRH0Y
         HLVLr14Cf/0rjHCxBctJrQsuhVvr3SQKb4wo92clyame8HHe9SFhA49dgZ3SLtVRRFfG
         cgXr97UGCdf0NbnP3hWLd0WIk2eOYDN2M+GeM1Orfn6psespc/ceDnNJLgXG8f1gK1s/
         fCMLOGGnZC0Ks5pAUTRLeTjZEhn2mvwV69s6Toc3i0Ewf3uiNc9b9CsWClTaIaRu/ZcG
         P2gvnfh0fEj1cVCGiEAcAABe+Nkzh0Vd8PbUgIm2nP/Ml6YH8qApN27z6bhe/DKP5gDc
         OGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=C414LO0vb/jXmNgdngCgv5AXjEhFw32BbWIul5HUb/A=;
        b=l9LaRGAoBBfJwciWGcmnqAdOgLw0yz5rpQk3TUUlJvUYhsl3CECKybsP2xCTHSQgGR
         7H/hYyBgc2G2Llqb6jBI9ZSifZEl8kMgJnRkIAhqknbdZjqJRrsmMOm5FnQG1vUaVlNH
         R38ntfFHqu1Xu8lVg2uo5SYraA9G1F9J2f7rLPiabRopzrn7GFSFX5SBnv3ne7uCrqC4
         qYXLcA1oXdlk3l7tT6VZJ/NgmouOawPcIcdruy+Rz6NjaV15f1MGleFm9/eqWhBpaX/m
         ChJ6RKbggqEVw5+d/Tt3JfcO2X4oGq98OAtbVyO8iDmxZrgEQF8MzCRq1Tl9DuXb4CSq
         CMGg==
X-Gm-Message-State: APjAAAWV13V/FUzO36YUelTgKmv+jIlpm9pWs0/FnQSisZsVqb4Xacr4
        L7S1SJqU2iQaJ/CAp5gn8587xbcA
X-Google-Smtp-Source: APXvYqwN5MU3pQkaN9ZkOjucSn0EgpsLX2LTO8FHzsQnO5S8DfS7Yo4BSZfQiIBAKi+pEGVhpL7kUg==
X-Received: by 2002:a7b:c01a:: with SMTP id c26mr12372221wmb.160.1575671243912;
        Fri, 06 Dec 2019 14:27:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:386f:a543:2f50:333c? (p200300EA8F4A6300386FA5432F50333C.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:386f:a543:2f50:333c])
        by smtp.googlemail.com with ESMTPSA id f1sm17466240wru.6.2019.12.06.14.27.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Dec 2019 14:27:23 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net] r8169: add missing RX enabling for WoL on RTL8125
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <fa53c5df-61ef-9e35-a3a3-406e5ef59d2e@gmail.com>
Date:   Fri, 6 Dec 2019 23:27:15 +0100
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

RTL8125 also requires to enable RX for WoL.

v2: add missing Fixes tag

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
This fix won't apply cleanly to 5.4 because RTL_GIGA_MAC_VER_52
was added for 5.5.
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 46a492229..67a4d5d45 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3695,7 +3695,7 @@ static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_32:
 	case RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_52:
+	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_61:
 		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
 			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
 		break;
-- 
2.24.0

