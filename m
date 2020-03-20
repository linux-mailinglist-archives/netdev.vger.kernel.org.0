Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 610AC18CADB
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgCTJx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:53:56 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42798 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727302AbgCTJxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:53:54 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AFAC8C0F91;
        Fri, 20 Mar 2020 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584698034; bh=rM1MFF/KqlI5E67w4k50vtl46f5JYXf2zwsUKsu4MlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Hw5YrFFkEckCI7xE7E+GhH8qQzuzu7Kry4v7xxcYzt9a+DihwvoJCGhVqihywoj0i
         mXr5ZWHVfMiFcufENPvHEiNVl8bCM1cp25ctzE4l8XRFpTQA8mkCE0N/rb50rNZn84
         g0xJX1ru2MDm5Qptn80ZDUeh5jgNdKvuWJq2/UGBC4GKOZbyTkJONHbEGS4qP5gOM1
         QIKvy1BwsdHrclNuBD4kmmcFRIUviT2WzDQgB7caVS/vI1AC+j0pqcPYByqeN0rx1E
         XAWi19zehkbU9jqsm81/GhlTI+lOdW1xXYfEeTIIFqt1fcxUsK7nefTkLHr3+it5WR
         AnY2QX9TDFC4w==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id EF48EA0065;
        Fri, 20 Mar 2020 09:53:48 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: phy: xpcs: Reset XPCS upon probe
Date:   Fri, 20 Mar 2020 10:53:35 +0100
Message-Id: <7704477e54a88cde1ca48f860974ce8378c1615d.1584697754.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584697754.git.Jose.Abreu@synopsys.com>
References: <cover.1584697754.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584697754.git.Jose.Abreu@synopsys.com>
References: <cover.1584697754.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reset the XPCS upon probe stage so that we start it from well known
state.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/mdio-xpcs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio-xpcs.c b/drivers/net/phy/mdio-xpcs.c
index c04e9bf40180..54976047dcb9 100644
--- a/drivers/net/phy/mdio-xpcs.c
+++ b/drivers/net/phy/mdio-xpcs.c
@@ -688,7 +688,7 @@ static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
 			match = entry;
 
 			if (xpcs_check_features(xpcs, match, interface))
-				return 0;
+				return xpcs_soft_reset(xpcs, MDIO_MMD_PCS);
 		}
 	}
 
-- 
2.7.4

