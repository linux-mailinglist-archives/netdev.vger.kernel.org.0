Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49766BB66C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbjCOOq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjCOOqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:46:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8DD90B4B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AN4iBnNKz0Qia5AGLUhdF7eeihJhEnlPi/mqdx98IN8=; b=0C8tUk8btRVybT4bMLYR4OWO9P
        T+rNuChw11J3lpLfNTzzBi+HOnGAUtK/bQ1TzzAcVKrzLe0OZdQswhusFDp0kWJIt4F0F8a4IGLjS
        Ab/6H7XYG1XR6GbtwZ/AK8v4USrc7yUQmupK7Rtar8SzTsc62YJfGe/R1OZjT9P6TjZ4pPxlZ6XGv
        S/hCS2ypYx7188LpbOHJ4AZ5Y8ySNF/CmNMsQeM6iVBT7fkUNvPuc5BjXYXY2zJwe3oMTI9KOjyKh
        Fe2SuVoEL9Hak6bF5QLxdf2GfFGj4m0bANipsn+P1KLcYEB2CcJuTRBS7dR0++mD650qLRkBBiWWn
        EytkBBuA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45632 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pcSOv-0007Mj-O7; Wed, 15 Mar 2023 14:46:49 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pcSOv-00DiAu-2D; Wed, 15 Mar 2023 14:46:49 +0000
In-Reply-To: <ZBHaQDM+G/o/UW3i@shell.armlinux.org.uk>
References: <ZBHaQDM+G/o/UW3i@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan McDowell <noodles@earth.li>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: pcs: lynx: don't print an_enabled in
 pcs_get_state()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pcSOv-00DiAu-2D@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 15 Mar 2023 14:46:49 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

an_enabled will be going away, and in any case, pcs_get_state() should
not be updating this member. Remove the print.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 3903f3baba2b..622c3de3f3a8 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -112,11 +112,11 @@ static void lynx_pcs_get_state(struct phylink_pcs *pcs,
 	}
 
 	dev_dbg(&lynx->mdio->dev,
-		"mode=%s/%s/%s link=%u an_enabled=%u an_complete=%u\n",
+		"mode=%s/%s/%s link=%u an_complete=%u\n",
 		phy_modes(state->interface),
 		phy_speed_to_str(state->speed),
 		phy_duplex_to_str(state->duplex),
-		state->link, state->an_enabled, state->an_complete);
+		state->link, state->an_complete);
 }
 
 static int lynx_pcs_config_giga(struct mdio_device *pcs, unsigned int mode,
-- 
2.30.2

