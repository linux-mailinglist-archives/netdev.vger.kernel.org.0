Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59ED68C3A3
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfHMV1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:27:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36987 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfHMV1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:27:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so7172236wrt.4
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 14:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RTskLAPvDb7EatTWvjmN3VlIPt7mYqxXmueT9MNt1yQ=;
        b=Wl1r2AV6iObpC+QL+nyOkA5XTTHpHZwesUvs6ImG7ZCZwchs4bAnXngosk7SMJnhVx
         vY0qtpf/F3ByLq/3kzpeCGthhms0mL4FCXwLqGobAK4jkZ7oUovHlc5u2pcF9d25uxyX
         gC/kKF2sogJYgC4NMMJXHrlnTirXftuioTy0R60e0cLElXq+V9r62vBrNLt03To7dHn/
         4Yw4gQSlMi19P/2B+SExWHLXxJg0S/SgnkzyjEctOjHLEtB/ZWoYmB3FuYp2EN1/26Te
         0TBrBpCy4GX44/6I0TudMukJ2l1yvE537OglYdiy+2dHGkuwBmzWc2JJ7Bq/IX8LMYwi
         f09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RTskLAPvDb7EatTWvjmN3VlIPt7mYqxXmueT9MNt1yQ=;
        b=NrBoRrlGYZrd4+wXrRY1C7Ez74kkBYrlVNLyRyaj5Y/maQHCEFDxee4Y/64qdU1sG8
         9Yn5YaiKY/UPSBiKXZ2dt5ppT1jpC3o4HLknNAsLev/1TRYQySc5xOQbgINc3xfUgxaa
         9KLpbIi1aJgF1WH22j5GYe5NXxGc3FboSozBcOYpGnpsN9o3vLdfrbuXsQEiR1e+ipbV
         KrPWn9wrVeX8rJer/Xwn/ER8JZQWKMoLZ3MNsV7bnTNzNLOQnuSbxAi7KthuF2BhNurt
         B+hBqPaI3sV5VTQ+/U9wb9nxAdcl4z6lU8xS4B6wCPUtgXVsOtNhVYF/XWII0lINOaeT
         m/bg==
X-Gm-Message-State: APjAAAXPyHgCcWl45JFyzsG7SZefC+SjKkjIHoX6L4ltnebEejJEd2QO
        iD5foepE8Se8QhRJw3yNim8TrDpP
X-Google-Smtp-Source: APXvYqxzNdq82S/w2vxf1Z97MSLWS/X4H1IeQYSKzyE7I69PhCueXyJGQF9wpvZ6poFG0meH2NhNTA==
X-Received: by 2002:adf:eec5:: with SMTP id a5mr25633399wrp.352.1565731617603;
        Tue, 13 Aug 2019 14:26:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a? (p200300EA8F2F3200E1E264B7EE242D4A.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a])
        by smtp.googlemail.com with ESMTPSA id o126sm4567187wmo.1.2019.08.13.14.26.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 14:26:57 -0700 (PDT)
Subject: [PATCH RFC 4/4] net: phy: fixed_phy: let genphy driver set supported
 and advertised modes
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marek Behun <marek.behun@nic.cz>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
Message-ID: <38040623-d599-815e-6545-5c2138331fc2@gmail.com>
Date:   Tue, 13 Aug 2019 23:26:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A fixed phy as special swphy binds to the genphy driver that calls
genphy_read_abilities(). This function populates the supported and
advertised modes, so we don't have to do it manually.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/fixed_phy.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 7c5265fd2..db4d96f2f 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -282,29 +282,6 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 	phy->mdio.dev.of_node = np;
 	phy->is_pseudo_fixed_link = true;
 
-	switch (status->speed) {
-	case SPEED_1000:
-		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
-				 phy->supported);
-		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
-				 phy->supported);
-		/* fall through */
-	case SPEED_100:
-		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
-				 phy->supported);
-		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
-				 phy->supported);
-		/* fall through */
-	case SPEED_10:
-	default:
-		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
-				 phy->supported);
-		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
-				 phy->supported);
-	}
-
-	phy_advertise_supported(phy);
-
 	ret = phy_device_register(phy);
 	if (ret) {
 		phy_device_free(phy);
-- 
2.22.0


