Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DF04772CC
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 14:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbhLPNMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 08:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbhLPNMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 08:12:41 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA8FC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 05:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OPfKFy/szpY0RaDDUP7SsTUVXXb/TfcCcpLjZBI2ZhU=; b=dldhhP1l/KU4I+Qe5z8r/f2lL5
        UEE2HcE6EAaehVakcaUNRQH3JTJ6EM6PqnSTEfkEhhWB1x7gZI86Mz/cT9yCwZLeOs62rAH7PSTm+
        el54Y00VmKGB3351Ehz+qYmsX0aeewPEyeM+Z5KkfuwinK+DevJLjOmmXiLf0ixEvNLPhv8pLUcEu
        /Dg4PyjmNIDYrlEAkM/6TUp5u8MhPwz1rV9YSJ+5Z4nSs/RvjerhA513f4kUtGlpvy0k8HRpqsrDP
        rIyCq/bRv1MrS4Namc7RCtYTVUVzCc/YHUm5yGjvtk9iwACjHmPvWLe0eqmel4MuSPKVNdBY/LkWK
        bT2CVA9g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49908 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxqYo-0007tP-7q; Thu, 16 Dec 2021 13:12:38 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxqYn-00GYYv-PG; Thu, 16 Dec 2021 13:12:37 +0000
In-Reply-To: <Ybs7DNDkBrf73jDi@shell.armlinux.org.uk>
References: <Ybs7DNDkBrf73jDi@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH CFT net-next 5/6] net: stmmac: remove phylink_config.pcs_poll
 usage
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mxqYn-00GYYv-PG@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 16 Dec 2021 13:12:37 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink will use PCS polling whenever the PCS's poll member is set, so
setting phylink_config.pcs_poll as well is redundant.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6f35ea30823c..94f7282da006 100644
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

