Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2283A11594D
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 23:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfLFWYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 17:24:32 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40589 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfLFWYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 17:24:31 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so9411109wrn.7
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 14:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=62BUaUTqER0bWDhgnRz3x9musjFMNFEn6xGnNqmXpds=;
        b=GhyZjgTvwtljZxPlEX8T7MoWWdNzTzFgUF8UpqUMoUiZfKRpUTMxLfUCwbQvPLkNoZ
         Vx8eBZ5hcVWujeyU8VUXzx6GwYwHCPfQnpkn7U9LdgEC+CT8IfhCoxqmL9Haj0G3s5LM
         w22XrNzmOplE1zo7mb6IczWTIMAFdpIzhM6XpytcYC/SScjhcPyIpuBnn2RxmC9Blz4W
         QQcukpkSlrDkk8tQGo4HcXqFEXeVG+QVwzxuDW47SZ5WRH09OV/ImXVplDDsIU1AfTKb
         zgnYQYeqU1iSi3Cn7KLoC4kZ2ic4ZZBmWELo+Z9WXqhX/GFy/l2PlEsHzeto7ZDzIqQV
         VU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=62BUaUTqER0bWDhgnRz3x9musjFMNFEn6xGnNqmXpds=;
        b=EssmwnliU24jnfjKJR9z21UTxL9P7iMZgNGMp2uuaoiN/+uPIq0hH5z/sQGAmYSFtO
         bVMEdUJN+Dbn0JAQOGEEn1MwnVeva2wUIC+ZB23jUZI7c7DVWEKR05n3qXuAZxkVCmVJ
         GBJLSgYAZjwThdGv6epJ/jFLHLOS0/HwUc5QLmvQl0ZDdFAF93i+2a0a3AOadeSjQBS6
         ZTmOldfRSpa+K02SrFF2MUBe7LtPUc0z9Ck0JJTQELFETVYfwFoxJ3XhuQhWjH49nBQE
         l4anN3xr9YGv6N5sJ1ifWOGefNdYK4mlDMDSrdYIvPEQu7Kxv2umWBl29QaRH0z14FzU
         /KZA==
X-Gm-Message-State: APjAAAXwgWmf8mX0nNJWP3raA1kgIgl0VdHPMx51P2hFLIJfOpUZFw0F
        6aWD+6PvlrkRxBBB/jFgPcCGY0Gp
X-Google-Smtp-Source: APXvYqyQJOG9pr4W5E+IJwUiP0DYkHmUVdFu68HbBJ4jvea9bLc9XB55eg71O7b0/CIR17Q6pRLDQA==
X-Received: by 2002:a5d:5452:: with SMTP id w18mr17131853wrv.333.1575671069215;
        Fri, 06 Dec 2019 14:24:29 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:386f:a543:2f50:333c? (p200300EA8F4A6300386FA5432F50333C.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:386f:a543:2f50:333c])
        by smtp.googlemail.com with ESMTPSA id w17sm17955646wrt.89.2019.12.06.14.24.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Dec 2019 14:24:28 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: add missing RX enabling for WoL on RTL8125
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <9254c6fd-1cbf-c17b-ef16-2e4749b1bbf3@gmail.com>
Date:   Fri, 6 Dec 2019 23:24:06 +0100
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

