Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA6249B914
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585798AbiAYQo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584921AbiAYQkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:40:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B273C06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sgQTf3Bfl9cn09Ojhu07RwFf7vIlmxYLBPzINy2DEi0=; b=jgXgRtVOrV+Z+14OpQo2cGWl9j
        Vw6SJ0YiHm+zshJQxjaEKN4JUMEonW7wPwYRgNE6q+fwUVnADJpYKD++GWE1VE6xuoQEln/+0HQfO
        hiIn+aRS0VO90Mff5w2ob+OV5E53TG6PuKfIyzcjB9ycaXD3KcRqg+fvP5luv8wKXrP5duyQ+W8ch
        Hc07BTsrW7boMmXoYzFUMcfjUTqAJzK+ce62L/qiis3dodqCJhP1NBQd0sXqlpII62jgK1261bhcu
        NJm/LcIgG3GJHoAbXdYhHGLcDT+dUfKwSbRS96YlDPnIiVmjIF5GDVgrnqo8aJeNyM4HJw3bc2T57
        SePXxODQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57420 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCOsA-0002C1-6m; Tue, 25 Jan 2022 16:40:46 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCOs9-005LSz-KX; Tue, 25 Jan 2022 16:40:45 +0000
In-Reply-To: <YfAnkuhiMoeFcVnb@shell.armlinux.org.uk>
References: <YfAnkuhiMoeFcVnb@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [PATCH net-next 5/7] net: stmmac: remove phylink_config.pcs_poll
 usage
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCOs9-005LSz-KX@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 25 Jan 2022 16:40:45 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink will use PCS polling whenever the PCS's poll member is set, so
setting phylink_config.pcs_poll as well is redundant.

Tested-by: Wong Vee Khee <vee.khee.wong@linux.intel.com> # Intel EHL            Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6c270785cf68..243016400aba 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1182,7 +1182,6 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 
 	priv->phylink_config.dev = &priv->dev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
-	priv->phylink_config.pcs_poll = true;
 	if (priv->plat->mdio_bus_data)
 		priv->phylink_config.ovr_an_inband =
 			mdio_bus_data->xpcs_an_inband;
-- 
2.30.2

