Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD8D86F01D
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 19:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfGTRBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 13:01:30 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45312 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfGTRB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 13:01:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so35135856wre.12
        for <netdev@vger.kernel.org>; Sat, 20 Jul 2019 10:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=A297uUmkgdX8xVlQW8I51h56lDl+uO/4ErVuA7L5MSs=;
        b=afVyEecQacS/Ze0nDT34ppZyb0RKa8+7DcFiKh4xZKJWfB7o3p186F6Kg0ZJUE3N2m
         2jMB6Hdzosm8eaO+UHoZ8mB2p+xgbL8bgzNE0g8TTiRW0/9se3CoMg0cmJYn7fCc5Vv/
         uU+3Pp64vADW3+LeStsxErsdU5+zDRpJd3kN+o4lH8Ix+xmpIRJr6HNBXMyt2TDRaApb
         9txCXa/Rwc2BQy3nPFh4wc5ycJ04z0LUs3iQ41xnQ5nLgAcgcD1aZ94smHKId4NhjVuq
         oCmiZGoTw2fqvRogBE2hhM7MPOjfY2lPZBNHNw2Bm5AC7T9QTpp2sz5mbYtqOmC6wXEB
         k4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=A297uUmkgdX8xVlQW8I51h56lDl+uO/4ErVuA7L5MSs=;
        b=YQIyQMEJQgh2V4ikiEvHa7jCVKHFdbVUfEfnrtBi8TqxSLDWQmAXG7yTFREbrc4Bia
         IXlb5+cfy8xAZtrktS0eZ6J9aZM/AfgZbX4f8YhpwjVJ8+JHjiHI6uXGKqKK/yOfVnvu
         1n8p/vXJV3sddKfLYaomFeF0p6VWp4fVVoY39AGeHfaBYSwLMjVbHX5jdFDXlBrJO8XL
         Jg/E7KVhwAZ//KUcnuzJxs2NCVHkJPnRmM9JtyiM5X2Ke3AOZ3rkwRRSBEeEMf4epR//
         GeBcB7toV+SBGday24Q8hpJs6LMKmmDfVEkYQGiE3DM3da5vxz3kVQSg9C8icjfW0XFB
         dg2A==
X-Gm-Message-State: APjAAAX7PITsFShS7QaRAK7DroelVcU30653aVFOm03UWKqdcWoOKB9s
        2B1jBeuIrtoqwJS9K6G0N7x7Vzxt
X-Google-Smtp-Source: APXvYqxLdZgRKUj469uAIQEEEKSX8fLq19c3DwX/3EnA9xkJ1jP91WmIkRkE9l7BjKr94RGey1lXJw==
X-Received: by 2002:a05:6000:112:: with SMTP id o18mr37493436wrx.153.1563642087532;
        Sat, 20 Jul 2019 10:01:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:7490:a073:b68b:c51c? ([2003:ea:8bd6:c00:7490:a073:b68b:c51c])
        by smtp.googlemail.com with ESMTPSA id c78sm48985990wmd.16.2019.07.20.10.01.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jul 2019 10:01:26 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix RTL8168g PHY init
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Voegtle <tv@lio96.de>
Message-ID: <eeb20312-1418-24c3-6482-09c051075b9e@gmail.com>
Date:   Sat, 20 Jul 2019 19:01:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Voegtle <tv@lio96.de>
This fixes a copy&paste error in the original patch. Setting the wrong
register resulted in massive packet loss on some systems.

Fixes: a2928d28643e ("r8169: use paged versions of phylib MDIO access functions")
Tested-by: Thomas Voegtle <tv@lio96.de>
Signed-off-by: Thomas Voegtle <tv@lio96.de>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0637c6752..6272115b2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3251,9 +3251,9 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
 
 	ret = phy_read_paged(tp->phydev, 0x0a46, 0x13);
 	if (ret & BIT(8))
-		phy_modify_paged(tp->phydev, 0x0c41, 0x12, 0, BIT(1));
+		phy_modify_paged(tp->phydev, 0x0c41, 0x15, 0, BIT(1));
 	else
-		phy_modify_paged(tp->phydev, 0x0c41, 0x12, BIT(1), 0);
+		phy_modify_paged(tp->phydev, 0x0c41, 0x15, BIT(1), 0);
 
 	/* Enable PHY auto speed down */
 	phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
-- 
2.22.0

