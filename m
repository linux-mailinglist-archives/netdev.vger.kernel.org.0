Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2084184854
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 14:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgCMNkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 09:40:13 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59800 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbgCMNkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 09:40:11 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 16DD1C0FAF;
        Fri, 13 Mar 2020 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584106810; bh=ST+X4UnqMFXVp07BI90fmUYVsZvY74GXZgG0KxD/zzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Pzqo3QBNM0LemVYxpUtRn2N/8EqcdycybF+g2FeQZyJOc6Pkjg94j8E2di9eawu6n
         rWpsts3DEYiUT6i9lsB2D7zBzcHTGaRTcV95Knvxe3Zjv7CBJTl27oWiNZTUL2n5xG
         hoIgTe5gZRjd72BdUY1mPqkxLGYK3AI9Iv8Nxx3a7HkUTEpTiFW7OhVVgSnMmjKrZA
         0TkFpPTDywkPfwSCcDFWdLNHj4Q3Jez67fW8uYEBlwUMKAcFOp0wMS08nUDocWPZEi
         czBs235OhaAbK+E59Ja/JP7oUybKnJMWy9H0WhFeBvCTzn88QETWq/8Ilc3ktK+7f/
         KDaTAUgarqdqQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 9D85BA0067;
        Fri, 13 Mar 2020 13:40:08 +0000 (UTC)
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
Subject: [PATCH net-next 4/4] net: phy: xpcs: Reset XPCS upon probe
Date:   Fri, 13 Mar 2020 14:39:43 +0100
Message-Id: <422e8e739c9a2a2e64ac5eac44436e20f2a03174.1584106347.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584106347.git.Jose.Abreu@synopsys.com>
References: <cover.1584106347.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584106347.git.Jose.Abreu@synopsys.com>
References: <cover.1584106347.git.Jose.Abreu@synopsys.com>
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
index 83ced7180a44..7960dc52c4bd 100644
--- a/drivers/net/phy/mdio-xpcs.c
+++ b/drivers/net/phy/mdio-xpcs.c
@@ -595,7 +595,7 @@ static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
 			match = entry;
 
 			if (xpcs_check_features(xpcs, match, interface))
-				return 0;
+				return xpcs_soft_reset(xpcs, MDIO_MMD_PCS);
 		}
 	}
 
-- 
2.7.4

