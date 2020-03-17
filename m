Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D38F8187BD9
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 10:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgCQJTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 05:19:11 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:48658 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbgCQJTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 05:19:11 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A92B640213;
        Tue, 17 Mar 2020 09:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584436750; bh=4DNEwGa8x0Rtm2b3zdl8zHnej+ACHTHcSd04X1562/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=lVaBY62iQU0IwKS7oJaxdNs9A92AfJoD3CP62ZYxVx2FhDpwCSMpOk+qUKsWUmHk2
         pgxLDvvM9CB6oKcan5dOTF9H6ZtdxAz5nwCIOTR7VnR3auqIfL7HP0eT7zdTvNZtKN
         IQjGMIyZMN+5RYsr1aINNPnGC4QMgVeAX9Et3cjhDXSSMpmuaKYzlPrvoKzp8XEsnQ
         b5FXbZ0sfjbY8nVlOR+XnW7tGe5DwgNftfijRaO2FjF55sjyIYDh0w7JOxyAra7UjD
         oenwGZ+K/58dqY5fYpAAuSSkwoIjwCxK+sVbyxzx0mh84zWLz4JBC8ua4pTdH0GsFG
         t9zijbTNkt2/g==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 43E79A0063;
        Tue, 17 Mar 2020 09:19:08 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 2/4] net: stmmac: Add XLGMII support
Date:   Tue, 17 Mar 2020 10:18:51 +0100
Message-Id: <e15b19c4d91dcf648a0dcd738ebfe1b327f9c617.1584436401.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584436401.git.Jose.Abreu@synopsys.com>
References: <cover.1584436401.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584436401.git.Jose.Abreu@synopsys.com>
References: <cover.1584436401.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add XLGMII support for stmmac including the list of speeds and defines
for them.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/common.h      |  6 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 58 +++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 9bdbf589d93f..7fd073144bac 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -426,6 +426,12 @@ struct mac_link {
 		u32 speed5000;
 		u32 speed10000;
 	} xgmii;
+	struct {
+		u32 speed25000;
+		u32 speed40000;
+		u32 speed50000;
+		u32 speed100000;
+	} xlgmii;
 };
 
 struct mii_regs {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f26699d9a050..0e8c80f23557 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -849,6 +849,38 @@ static void stmmac_validate(struct phylink_config *config,
 			phylink_set(mac_supported, 10000baseKX4_Full);
 			phylink_set(mac_supported, 10000baseKR_Full);
 		}
+		if (!max_speed || (max_speed >= 25000)) {
+			phylink_set(mac_supported, 25000baseCR_Full);
+			phylink_set(mac_supported, 25000baseKR_Full);
+			phylink_set(mac_supported, 25000baseSR_Full);
+		}
+		if (!max_speed || (max_speed >= 40000)) {
+			phylink_set(mac_supported, 40000baseKR4_Full);
+			phylink_set(mac_supported, 40000baseCR4_Full);
+			phylink_set(mac_supported, 40000baseSR4_Full);
+			phylink_set(mac_supported, 40000baseLR4_Full);
+		}
+		if (!max_speed || (max_speed >= 50000)) {
+			phylink_set(mac_supported, 50000baseCR2_Full);
+			phylink_set(mac_supported, 50000baseKR2_Full);
+			phylink_set(mac_supported, 50000baseSR2_Full);
+			phylink_set(mac_supported, 50000baseKR_Full);
+			phylink_set(mac_supported, 50000baseSR_Full);
+			phylink_set(mac_supported, 50000baseCR_Full);
+			phylink_set(mac_supported, 50000baseLR_ER_FR_Full);
+			phylink_set(mac_supported, 50000baseDR_Full);
+		}
+		if (!max_speed || (max_speed >= 100000)) {
+			phylink_set(mac_supported, 100000baseKR4_Full);
+			phylink_set(mac_supported, 100000baseSR4_Full);
+			phylink_set(mac_supported, 100000baseCR4_Full);
+			phylink_set(mac_supported, 100000baseLR4_ER4_Full);
+			phylink_set(mac_supported, 100000baseKR2_Full);
+			phylink_set(mac_supported, 100000baseSR2_Full);
+			phylink_set(mac_supported, 100000baseCR2_Full);
+			phylink_set(mac_supported, 100000baseLR2_ER2_FR2_Full);
+			phylink_set(mac_supported, 100000baseDR2_Full);
+		}
 	}
 
 	/* Half-Duplex can only work with single queue */
@@ -929,6 +961,32 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 		default:
 			return;
 		}
+	} else if (interface == PHY_INTERFACE_MODE_XLGMII) {
+		switch (speed) {
+		case SPEED_100000:
+			ctrl |= priv->hw->link.xlgmii.speed100000;
+			break;
+		case SPEED_50000:
+			ctrl |= priv->hw->link.xlgmii.speed50000;
+			break;
+		case SPEED_40000:
+			ctrl |= priv->hw->link.xlgmii.speed40000;
+			break;
+		case SPEED_25000:
+			ctrl |= priv->hw->link.xlgmii.speed25000;
+			break;
+		case SPEED_10000:
+			ctrl |= priv->hw->link.xgmii.speed10000;
+			break;
+		case SPEED_2500:
+			ctrl |= priv->hw->link.speed2500;
+			break;
+		case SPEED_1000:
+			ctrl |= priv->hw->link.speed1000;
+			break;
+		default:
+			return;
+		}
 	} else {
 		switch (speed) {
 		case SPEED_2500:
-- 
2.7.4

