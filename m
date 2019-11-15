Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71AE1FE670
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKOUfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:35:30 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35510 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKOUf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:35:29 -0500
Received: by mail-wr1-f66.google.com with SMTP id s5so12346399wrw.2
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 12:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ElhWqKdjI+HiU40uFjrs/L/wObbz0ARJd/MX6NEX3nE=;
        b=Mgcw9VusAK8x3P60rEUtTa1H5Rf8Su6KfltYt7GVHk2fFr9fh/Qu8NU51cEiY0R0kY
         7XzSRZVQIfcZ0qhw74r5iZFISPf4jCit3tun+v0Tn6dUfO6v5QcvkQ6kKgSKeutZFUDC
         rQ2b1E4TibcnR6RDO7vwRvU8JDHvUL3zJbCyOhu8/9nDkmVcM7x9V/FkpZuMi+u9hZjk
         teRqWqm9qXN4izQUuHdqGq7B/0/jRMrKAsMb0szFNRbfVtHz2j+6v0ljFm/6sJNX2Wxc
         i7HEET9tEv0fluQM2WyljOqdL3T1gudhmHDobET1k+EErcoo4asSk9hbHmNp0RUjcpxx
         s28A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ElhWqKdjI+HiU40uFjrs/L/wObbz0ARJd/MX6NEX3nE=;
        b=rnGsuwOEWLoVHrp2Z12OlCI/yIGhqoRvAuJYbmG139cvsdbH8a+HeMtCIbG48UhId7
         rx54BbxJUU0bEdEsPuAXZyuUVkz+cOYyGv32nB5gbWCW1iiUbkrwCtbExVaJE0BVs1Cs
         iFwi4yo8Zr0YfQux5IaEepnAvZlNwP0IGXg7NHip1PDPibJFkNXsvxZldAdXfLRSvMpC
         ieWfvkS6obbQ059PB7QBlXtQND2P5haglOZ67A6MBWv/95toqqFDcMbDYD/SlTvJ1MQd
         488yQL9MBlC4sq2xYkWzVA+KZeDxP4/p9PlAiBjl5PnUu6ya4bX7I1Uw8hD8lLURxxMY
         NlEg==
X-Gm-Message-State: APjAAAVS2tP60/Z7H4oX3kRJkTeYcPRvDmNeDMzwm7xgbUx9yjzYIZ+G
        moMfscIcPbTsSHQPP44j9vFHk9lc
X-Google-Smtp-Source: APXvYqzNlpkbvDUtedO09s3TcfTSRh2WL8Q8WxNjoiXESbD1mt4s9pnfeH+71bG3FLo+un6TOfT9WA==
X-Received: by 2002:a5d:4a10:: with SMTP id m16mr16316576wrq.294.1573850127625;
        Fri, 15 Nov 2019 12:35:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:a4ca:7f51:f03b:b2bd? (p200300EA8F2D7D00A4CA7F51F03BB2BD.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:a4ca:7f51:f03b:b2bd])
        by smtp.googlemail.com with ESMTPSA id 17sm10226108wmg.19.2019.11.15.12.35.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 12:35:27 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve conditional firmware loading for
 RTL8168d
Message-ID: <e825e699-9397-663c-4863-d6e4e8e1fc92@gmail.com>
Date:   Fri, 15 Nov 2019 21:35:22 +0100
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

Using constant MII_EXPANSION is misleading here because register 0x06
has a different meaning on page 0x0005. Here a proprietary PHY
parameter is read by writing the parameter id to register 0x05 on page
0x0005, followed by reading the parameter value from register 0x06.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 39 +++++++++++------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8b33c1aa3..04c82cd0d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2297,14 +2297,6 @@ static void rtl_apply_firmware(struct rtl8169_private *tp)
 		rtl_fw_write_firmware(tp, tp->rtl_fw);
 }
 
-static void rtl_apply_firmware_cond(struct rtl8169_private *tp, u8 reg, u16 val)
-{
-	if (rtl_readphy(tp, reg) != val)
-		netif_warn(tp, hw, tp->dev, "chipset not ready for firmware\n");
-	else
-		rtl_apply_firmware(tp);
-}
-
 static void rtl8168_config_eee_mac(struct rtl8169_private *tp)
 {
 	/* Adjust EEE LED frequency */
@@ -2691,6 +2683,21 @@ static const struct phy_reg rtl8168d_1_phy_reg_init_1[] = {
 	{ 0x1f, 0x0002 }
 };
 
+static void rtl8168d_apply_firmware_cond(struct rtl8169_private *tp, u16 val)
+{
+	u16 reg_val;
+
+	rtl_writephy(tp, 0x1f, 0x0005);
+	rtl_writephy(tp, 0x05, 0x001b);
+	reg_val = rtl_readphy(tp, 0x06);
+	rtl_writephy(tp, 0x1f, 0x0000);
+
+	if (reg_val != val)
+		netif_warn(tp, hw, tp->dev, "chipset not ready for firmware\n");
+	else
+		rtl_apply_firmware(tp);
+}
+
 static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
 {
 	rtl_writephy_batch(tp, rtl8168d_1_phy_reg_init_0);
@@ -2737,13 +2744,9 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0002);
 	rtl_w0w1_phy(tp, 0x02, 0x0100, 0x0600);
 	rtl_w0w1_phy(tp, 0x03, 0x0000, 0xe000);
-
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x001b);
-
-	rtl_apply_firmware_cond(tp, MII_EXPANSION, 0xbf00);
-
 	rtl_writephy(tp, 0x1f, 0x0000);
+
+	rtl8168d_apply_firmware_cond(tp, 0xbf00);
 }
 
 static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp)
@@ -2782,13 +2785,9 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp)
 	/* Switching regulator Slew rate */
 	rtl_writephy(tp, 0x1f, 0x0002);
 	rtl_patchphy(tp, 0x0f, 0x0017);
-
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x001b);
-
-	rtl_apply_firmware_cond(tp, MII_EXPANSION, 0xb300);
-
 	rtl_writephy(tp, 0x1f, 0x0000);
+
+	rtl8168d_apply_firmware_cond(tp, 0xb300);
 }
 
 static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp)
-- 
2.24.0

