Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDFC46E8DD
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 14:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237643AbhLINPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 08:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbhLINPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 08:15:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD61C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 05:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5xLY/Uq2n6j9WqqUWofdWwPwDBeOzhpbijMK8F238lU=; b=rSBLqGbhMvA8coIWg55xvhK5yl
        /YE/AjPPrBbxt1soxzhFwiCj+LzkuslXYJ+Dag0TPZFIzdvE1RsEeQ5n6n6HuTG3kBxurTlIKDfs0
        PCdt0Z4zsekygLx+XoBItpYXYykfAQbZi2S4yRuJ9NACFIUOZGct/4TT9QwmMMi6GRDcx1SS64y4Z
        jvPJkBjXbXl1EugPymwUAfSl+1nRFx22RL1gpFr3LVWjQI6kbuwL9Oo1lucfmNvREHWEs9oXcRRf0
        ZcHDd34/vypJqIh3XdT0Hk2ulYr0Who8smdVwHrkKZiw3lXbd/LQE4u4zq2mAj0RG3xeK8gbTi5kQ
        lrzM4WpA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45532 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mvJD5-0008T5-J3; Thu, 09 Dec 2021 13:11:43 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mvJD5-00F943-5N; Thu, 09 Dec 2021 13:11:43 +0000
In-Reply-To: <Ya+DGaGmGgWrlVkW@shell.armlinux.org.uk>
References: <Ya+DGaGmGgWrlVkW@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/5] net: mtk_eth_soc: mark as a legacy_pre_march2020
 driver
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mvJD5-00F943-5N@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 09 Dec 2021 13:11:43 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mtk_eth_soc has not been updated for commit 7cceb599d15d ("net: phylink:
avoid mac_config calls"), and makes use of state->speed and
state->duplex in contravention of the phylink documentation. This makes
reliant on the legacy behaviours, so mark it as a legacy driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
Resent with the correct cover-letter message-ID.

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index de4152e2e3e4..a068cf5c970f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2923,6 +2923,10 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 
 	mac->phylink_config.dev = &eth->netdev[id]->dev;
 	mac->phylink_config.type = PHYLINK_NETDEV;
+	/* This driver makes use of state->speed/state->duplex in
+	 * mac_config
+	 */
+	mac->phylink_config.legacy_pre_march2020 = true;
 	mac->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
 		MAC_10 | MAC_100 | MAC_1000 | MAC_2500FD;
 
-- 
2.30.2

