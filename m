Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B081836FF
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 18:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgCLRLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 13:11:13 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:35580 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbgCLRLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 13:11:12 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BC89DC108F;
        Thu, 12 Mar 2020 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584033071; bh=RUZ06YpRLzyaBlmEnxJDWqWGZVaL9x59tY1GJl9HBbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Bf1DO3jqgYszy2mwbkeiMoop+bCOYdFIKwc3AXAcHTa8KBhjXvcg7DtsKx+W8iZOU
         BI/w3ICCKGU1+8UpMJc/ZVUa61NeF08R84Ed4TNB6jTfU9Dwewej744jiSWpbbUtsf
         UM+O1m2em4Ni9UgoQZMu23aZaeET6JVequxiHbXhzZeqaQQcc6Q0JAPVhCSwreC/4O
         Wa8hc9p0onbEU8ojusC7a1OH9uoFFDyUO5WUNGSLEtEOfSFLehLF5QgQ0e6Fm22cbk
         fqN1v6Soi654A50WdFayJ25Fcw/GJrxyJJahJLQDOwwregKs1YKwhZgaaDKrmDxGx+
         XE0MmUKxIHhDg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id D7265A0066;
        Thu, 12 Mar 2020 17:11:08 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: phylink: Add XLGMII support
Date:   Thu, 12 Mar 2020 18:10:10 +0100
Message-Id: <93845427e483f2f0a31b48f2de00ce3208f5f50b.1584031294.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584031294.git.Jose.Abreu@synopsys.com>
References: <cover.1584031294.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584031294.git.Jose.Abreu@synopsys.com>
References: <cover.1584031294.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add XLGMII interface and the list of XLGMII speeds to PHYLINK.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/phylink.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 19db68d74cb4..2f592aa1a225 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -326,6 +326,33 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			phylink_set(pl->supported, 10000baseER_Full);
 			break;
 
+		case PHY_INTERFACE_MODE_XLGMII:
+			phylink_set(pl->supported, 25000baseCR_Full);
+			phylink_set(pl->supported, 25000baseKR_Full);
+			phylink_set(pl->supported, 25000baseSR_Full);
+			phylink_set(pl->supported, 40000baseKR4_Full);
+			phylink_set(pl->supported, 40000baseCR4_Full);
+			phylink_set(pl->supported, 40000baseSR4_Full);
+			phylink_set(pl->supported, 40000baseLR4_Full);
+			phylink_set(pl->supported, 50000baseCR2_Full);
+			phylink_set(pl->supported, 50000baseKR2_Full);
+			phylink_set(pl->supported, 50000baseSR2_Full);
+			phylink_set(pl->supported, 50000baseKR_Full);
+			phylink_set(pl->supported, 50000baseSR_Full);
+			phylink_set(pl->supported, 50000baseCR_Full);
+			phylink_set(pl->supported, 50000baseLR_ER_FR_Full);
+			phylink_set(pl->supported, 50000baseDR_Full);
+			phylink_set(pl->supported, 100000baseKR4_Full);
+			phylink_set(pl->supported, 100000baseSR4_Full);
+			phylink_set(pl->supported, 100000baseCR4_Full);
+			phylink_set(pl->supported, 100000baseLR4_ER4_Full);
+			phylink_set(pl->supported, 100000baseKR2_Full);
+			phylink_set(pl->supported, 100000baseSR2_Full);
+			phylink_set(pl->supported, 100000baseCR2_Full);
+			phylink_set(pl->supported, 100000baseLR2_ER2_FR2_Full);
+			phylink_set(pl->supported, 100000baseDR2_Full);
+			break;
+
 		default:
 			phylink_err(pl,
 				    "incorrect link mode %s for in-band status\n",
-- 
2.7.4

