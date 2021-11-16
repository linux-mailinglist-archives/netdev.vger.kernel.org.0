Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74BE452EAA
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhKPKJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbhKPKJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:09:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D44C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/xVCdcDW8Mbm2vM87DhKbJgb/YxbcKCCa5R3z5x+TQM=; b=A2CMIytkS9zbOYYtzLVOC6emci
        r6ySneX9dY8Abwi8MHJ3ieDwErIvk9Cbhfrdcx2zy4jHiqj+wjDvk/UQjIv+P9jbBGu2iQJWkrKsU
        4iXpSTZeoaXUkfiMJnDdBq06CzPVD4Qz0PnhiVyOy3QwTmI5Kbp/1mcHeDtC5cJyEvDLC87l2V0I5
        svX+dxpQsuQfkzRyz/TVurtPbUCbn7cOis4KyQXlZOV45j4vmWpxPY1le1mhba9Zm45B5uVIN9MN3
        8j9NyWQn20AC2QgvEqu87HZGr2JCpM13U9lqwb1pOZBbTgYLa897+0TH5ZCxfNcuj4oJOxq7WuEjw
        iOf3gvmA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39838 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvMR-0000Ln-Ve; Tue, 16 Nov 2021 10:06:43 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvMR-0078bF-Hd; Tue, 16 Nov 2021 10:06:43 +0000
In-Reply-To: <YZOCn1vMUAbhq3j0@shell.armlinux.org.uk>
References: <YZOCn1vMUAbhq3j0@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 1/4] net: mtk_eth_soc: populate supported_interfaces
 member
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvMR-0078bF-Hd@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 10:06:43 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the phy interface mode bitmap for the Mediatek driver with
interfaces modes supported by the MAC.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 75d67d1b5f6b..7f62298bc983 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3009,6 +3009,26 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 
 	mac->phylink_config.dev = &eth->netdev[id]->dev;
 	mac->phylink_config.type = PHYLINK_NETDEV;
+	__set_bit(PHY_INTERFACE_MODE_MII,
+		  mac->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_GMII,
+		  mac->phylink_config.supported_interfaces);
+
+	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_RGMII))
+		phy_interface_set_rgmii(mac->phylink_config.supported_interfaces);
+
+	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_TRGMII) && !mac->id)
+		__set_bit(PHY_INTERFACE_MODE_TRGMII,
+			  mac->phylink_config.supported_interfaces);
+
+	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_SGMII)) {
+		__set_bit(PHY_INTERFACE_MODE_SGMII,
+			  mac->phylink_config.supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+			  mac->phylink_config.supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+			  mac->phylink_config.supported_interfaces);
+	}
 
 	phylink = phylink_create(&mac->phylink_config,
 				 of_fwnode_handle(mac->of_node),
-- 
2.30.2

