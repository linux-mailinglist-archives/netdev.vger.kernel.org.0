Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E801E10DD0
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfEAUO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:14:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39694 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfEAUO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 16:14:27 -0400
Received: by mail-wr1-f67.google.com with SMTP id a9so62900wrp.6
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 13:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=32W3Gfp3AWj7QrnOygUDmDsEehpBVtRIs4X65zNip/I=;
        b=SiKN7VTvKJScx7pkeGA5i0REcsdxcfWg31PTErsdaDOPH4p7naMFXtm4pGpgXnu+dN
         26k4s+UZ/IchtZqqtHvv94i80Y/zg5TRxnPpx7QzaFpsu/ZIPyQ+sXnGGeVH5Nqc61nw
         wej1UV6jwuS+hNd+xnVJP1d343tFzS6bqZi5LiTtCOOBTidyv5UrRu50XlLagrmkVC9j
         wqyYBlUTFhQmAD8DZCcn4bN5jTfh5aBnhKOVyB2RCJEsrZTyktJfNkv7hFpnJX80758J
         ReVz5L+Fu5yOBb0N6HsotDTc6fWIZ84jI4o9MWWcbzAVtnF3DX5cSuQwh0DZXkJjkI7A
         vysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=32W3Gfp3AWj7QrnOygUDmDsEehpBVtRIs4X65zNip/I=;
        b=SDt4bmYP62ZVeZEMGP9uZjvXa2xAE9/ne3Od6NlgXqhDufAI+vAv9jAEhfN/1lSMGp
         DQiJ0bSmDJ7WabtXv0Hxa8lLho3zgUydjBrEOPzA9YNBS5MFIx01rx1s8o3HR5CDDYOY
         BEHRqA0hBkJcF4xf/gegSwPkP3htMzKgJKKJeyDwQSi05rY257UfuG5+ThiOWj130pi3
         LJOz9u4PvbXMyDqjbKyfMGYUdfUXUTJ9lS5CuKQsWX9p3KJtwStXTMoFctUnh+nIl4Nb
         x7P1LIiQFjURNZ7zUpTBA/mnPiLVfmkuhYnoQaI+1zwZV+l7Q6u8Ix161zPsoUxeBrj4
         ZXGQ==
X-Gm-Message-State: APjAAAWt831k56/E5/ZEC2xle3lPz32aNZKOMZJqPyhW7PuFycdHoJ0J
        JGKVk4MMkpKck5+oJTO+tNcviBwhpnY=
X-Google-Smtp-Source: APXvYqx0HpE1qZbkQL6FkXundsHc+KuJGu4aKKV7fOIMffjN08TJKxfolK7eWqF2Svgh3E1t4AqsXA==
X-Received: by 2002:adf:fb0d:: with SMTP id c13mr23527wrr.214.1556741665783;
        Wed, 01 May 2019 13:14:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:a160:62e9:d01f:fc0a? (p200300EA8BD45700A16062E9D01FFC0A.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:a160:62e9:d01f:fc0a])
        by smtp.googlemail.com with ESMTPSA id o5sm5273659wmc.16.2019.05.01.13.14.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 13:14:25 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: improve resuming from hibernation
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <1b6fc016-b4cd-a27a-216b-d17441072809@gmail.com>
Date:   Wed, 1 May 2019 22:14:21 +0200
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

I got an interesting report [0] that after resuming from hibernation
the link has 100Mbps instead of 1Gbps. Reason is that another OS has
been used whilst Linux was hibernated. And this OS speeds down the link
due to WoL. Therefore, when resuming, we shouldn't expect that what
the PHY advertises is what it did when hibernating.
Easiest way to do this is removing state PHY_RESUMING. Instead always
go via PHY_UP that configures PHY advertisement.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=202851

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 7 +------
 include/linux/phy.h   | 9 +--------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 984de9872..1a146c5c5 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -43,7 +43,6 @@ static const char *phy_state_to_str(enum phy_state st)
 	PHY_STATE_STR(NOLINK)
 	PHY_STATE_STR(FORCING)
 	PHY_STATE_STR(HALTED)
-	PHY_STATE_STR(RESUMING)
 	}
 
 	return NULL;
@@ -859,10 +858,7 @@ void phy_start(struct phy_device *phydev)
 			goto out;
 	}
 
-	if (phydev->state == PHY_READY)
-		phydev->state = PHY_UP;
-	else
-		phydev->state = PHY_RESUMING;
+	phydev->state = PHY_UP;
 
 	phy_start_machine(phydev);
 out:
@@ -897,7 +893,6 @@ void phy_state_machine(struct work_struct *work)
 		break;
 	case PHY_NOLINK:
 	case PHY_RUNNING:
-	case PHY_RESUMING:
 		err = phy_check_link_status(phydev);
 		break;
 	case PHY_FORCING:
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 4a03f8a46..073fb151b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -308,13 +308,7 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
  *
  * HALTED: PHY is up, but no polling or interrupts are done. Or
  * PHY is in an error state.
- *
- * - phy_start moves to RESUMING
- *
- * RESUMING: PHY was halted, but now wants to run again.
- * - If we are forcing, or aneg is done, timer moves to RUNNING
- * - If aneg is not done, timer moves to AN
- * - phy_stop moves to HALTED
+ * - phy_start moves to UP
  */
 enum phy_state {
 	PHY_DOWN = 0,
@@ -324,7 +318,6 @@ enum phy_state {
 	PHY_RUNNING,
 	PHY_NOLINK,
 	PHY_FORCING,
-	PHY_RESUMING
 };
 
 /**
-- 
2.21.0

