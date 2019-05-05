Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01FED14149
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfEERD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:03:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34722 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEERD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:03:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id f7so3898844wrq.1
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 10:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gYLJth6xSX/5u2JKvRJw87pSGIGzdYWMzx7n+oe98so=;
        b=k2BylEy5A/wXijnyrPYDNFhzxSYqo9W2b0Y0wcCPeNEk9M5F5kQLYCFH9jbsm6e79E
         rHPZj4VZSPvdQhZBQ10bllviw06fJKNxhKVm62t5dvInxIwLgN1KprHhyfOrjaIvHHFX
         Wr1Hgmabr7bwhDceXX5OcQZGo28Qqvs1/Bp6qvtVFeckKcptoBCm32YSBu6iYRraCzK5
         5XNzDwO+o6kZEri4nEoJ/YQRweIbXLY6zfwMmyRQ5AtrKJQcLjplkC9Zedlmjatfc2Zb
         hPFdkLbEMXg6tSVJ4q46dI5R8yhURXxo+TwTCnrr4eIvBIz+pQuJJYqejzAYs+wri/sS
         kdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gYLJth6xSX/5u2JKvRJw87pSGIGzdYWMzx7n+oe98so=;
        b=MC5DLL0KHg4fK/AymGKOz7/HrGs5R+GceDPM4y2z2HlCMiTsfW4j0w4gJdAt+UUYLd
         UADY6ZPG52T/ChxY4nRzYBkOQUYmPT1ZCsaxKOv40pT4YVai6B/ycG/NfvunMXI1tcXg
         rpAUYzuL39bngrLWNTQSaurxl/ECXIvpl5Iz6G6qubh64k5h0XIuyPNU3kR8WOOIjBUs
         d32p2O8HD+FOsOqzCzDwOozkY8RttpSRtOesVE8lT7nEp6Rxk83cw4M6TaGadgKT3p9z
         Dl07RGuaLzY8tW/VZLGNyR3SXyp+y3swuyfaNEmxeFBDGQVl/FBR2SAAGUpNEaDgHQts
         qYDw==
X-Gm-Message-State: APjAAAWtm1N/tjk5aaEsDVQqAPId4rhWSornwnIWSjwSe3cqFJ0sOG7h
        i7tQcLPvDXi6thG2krqPTvvJa8NVIuo=
X-Google-Smtp-Source: APXvYqzo9jomqiZJBTo85uJJ+fe11F66d/QN0W3NaBRjo6577lIXn2pXF3nwOIf6S+VYi71Ofh2+hw==
X-Received: by 2002:adf:80c3:: with SMTP id 61mr15458933wrl.123.1557075836872;
        Sun, 05 May 2019 10:03:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:d9a7:917c:8564:c504? (p200300EA8BD45700D9A7917C8564C504.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:d9a7:917c:8564:c504])
        by smtp.googlemail.com with ESMTPSA id x14sm6314471wmj.3.2019.05.05.10.03.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 10:03:56 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: improve pause mode reporting in
 phy_print_status
Message-ID: <1ea97344-6971-44dd-2191-9a8db0d2c10d@gmail.com>
Date:   Sun, 5 May 2019 19:03:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far we report symmetric pause only, and we don't consider the local
pause capabilities. Let's properly consider local and remote
capabilities, and report also asymmetric pause.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 1a146c5c5..e88854292 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -60,6 +60,32 @@ static void phy_link_down(struct phy_device *phydev, bool do_carrier)
 	phy_led_trigger_change_speed(phydev);
 }
 
+static const char *phy_pause_str(struct phy_device *phydev)
+{
+	bool local_pause, local_asym_pause;
+
+	if (phydev->autoneg == AUTONEG_DISABLE)
+		goto no_pause;
+
+	local_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+					phydev->advertising);
+	local_asym_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+					     phydev->advertising);
+
+	if (local_pause && phydev->pause)
+		return "rx/tx";
+
+	if (local_asym_pause && phydev->asym_pause) {
+		if (local_pause)
+			return "rx";
+		if (phydev->pause)
+			return "tx";
+	}
+
+no_pause:
+	return "off";
+}
+
 /**
  * phy_print_status - Convenience function to print out the current phy status
  * @phydev: the phy_device struct
@@ -71,7 +97,7 @@ void phy_print_status(struct phy_device *phydev)
 			"Link is Up - %s/%s - flow control %s\n",
 			phy_speed_to_str(phydev->speed),
 			phy_duplex_to_str(phydev->duplex),
-			phydev->pause ? "rx/tx" : "off");
+			phy_pause_str(phydev));
 	} else	{
 		netdev_info(phydev->attached_dev, "Link is Down\n");
 	}
-- 
2.21.0

