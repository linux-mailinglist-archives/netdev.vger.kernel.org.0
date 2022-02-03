Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB0B4A8A16
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352880AbiBCRbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352882AbiBCRbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:31:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2646C06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LT0yR0PeUj3iS0pQ3EBNu1UcT2mKQB/wbY+eKASwNJk=; b=A0yJIJIhVxdH0g3AoJ54Z5XZFx
        iUWMv6wVmNVAaFWkmEZXNI/fa2EQCclfVlMierJD3r92+7ke63gFql2msvqAa38R4GBDRMLBiUANh
        h7dkEcfCvsuu7405HhmL6F6EdTXLM5J4PZlA1ssV36XG61sHo7KQyOEuxLdA3oAWgxG6Fxez3DTr5
        gHUnSnvmFYKk53UeOT20zX4oZiygc3ANZBh+PF2wL9w+yr0dhM8XQ25/+pA0mAxRczwBFHfKcY6KD
        VO9kWLMdsQMGo+HlhYGW3RcwA1soVi0SZtoiwVNvXkTu0cflXMzvwayTVFFuei5g7lr4TPbdGnpua
        3ayyz5BQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54888 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFfxL-000303-1v; Thu, 03 Feb 2022 17:31:39 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFfxK-006X72-Es; Thu, 03 Feb 2022 17:31:38 +0000
In-Reply-To: <YfwRN2ObqFbrw/fF@shell.armlinux.org.uk>
References: <YfwRN2ObqFbrw/fF@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 5/7] net: dsa: mt7530: RGMII can support
 1000base-X
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFfxK-006X72-Es@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Feb 2022 17:31:38 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using an external PHY connected using RGMII to mt7531 port 5, the
PHY can be used to used support 1000baseX connections. Therefore, it
makes no sense to exclude this from the linkmodes permitted for mt7531
port 5, so allow 1000baseX.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index cbdf4a58e507..a2fa629cccc0 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2523,9 +2523,6 @@ static void mt7531_sgmii_validate(struct mt7530_priv *priv, int port,
 	 */
 	switch (port) {
 	case 5:
-		if (mt7531_is_rgmii_port(priv, port))
-			break;
-		fallthrough;
 	case 6:
 		if (interface == PHY_INTERFACE_MODE_2500BASEX) {
 			phylink_set(supported, 2500baseX_Full);
-- 
2.30.2

