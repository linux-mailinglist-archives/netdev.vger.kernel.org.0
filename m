Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5374FDDFB
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245227AbiDLLod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351888AbiDLLma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:42:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17C513D78
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 03:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7yNgO80/03lnD0Kqds8NpJPYxgBo16kU6kQWTts+KN8=; b=o5nsa/KLcwWKgOPE4A77u8g1W1
        kAdD6Ak8iUhnASXVHiUGLEi62j+mgjVGzJm34LDn6vd96dlCEKnQfeBZrfUU5oSFUhv0mpPx63dcz
        /ftgjBTGZQBO9w70i4pN1srsNROCi6/XPlYBwdKCFjNk5OtVRi1F3LkbET0vQMsVsKpNtWLRg5G7U
        WhJ8p9DCTD8H7rCYgYAp2ifokAIdvW6U6zNiqGKaaeuJzgS/0rGhJG9BXGCHwsht0x6OsMOy2vhvi
        OakFHM7mlyy3bzGIvyun7QCkAfNQqUORfSsfCAoGEXn9ZP4c2EvzjO/MWc4a7oz0misud08m81MFi
        aXrOhW+A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57174 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1neDgn-0001gv-7N; Tue, 12 Apr 2022 11:24:00 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1neDgm-005IBR-BW; Tue, 12 Apr 2022 11:24:00 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] net: phylink: remove phylink_helper_basex_speed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1neDgm-005IBR-BW@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 12 Apr 2022 11:24:00 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As there are now no users of phylink_helper_basex_speed(), we can
remove this obsolete functionality.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
The last user was the mt7530 driver which has just been merged.

 drivers/net/phy/phylink.c | 28 ----------------------------
 include/linux/phylink.h   |  6 ------
 2 files changed, 34 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 06943889d747..33c285252584 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2778,34 +2778,6 @@ static const struct sfp_upstream_ops sfp_phylink_ops = {
 
 /* Helpers for MAC drivers */
 
-/**
- * phylink_helper_basex_speed() - 1000BaseX/2500BaseX helper
- * @state: a pointer to a &struct phylink_link_state
- *
- * Inspect the interface mode, advertising mask or forced speed and
- * decide whether to run at 2.5Gbit or 1Gbit appropriately, switching
- * the interface mode to suit.  @state->interface is appropriately
- * updated, and the advertising mask has the "other" baseX_Full flag
- * cleared.
- */
-void phylink_helper_basex_speed(struct phylink_link_state *state)
-{
-	if (phy_interface_mode_is_8023z(state->interface)) {
-		bool want_2500 = state->an_enabled ?
-			phylink_test(state->advertising, 2500baseX_Full) :
-			state->speed == SPEED_2500;
-
-		if (want_2500) {
-			phylink_clear(state->advertising, 1000baseX_Full);
-			state->interface = PHY_INTERFACE_MODE_2500BASEX;
-		} else {
-			phylink_clear(state->advertising, 2500baseX_Full);
-			state->interface = PHY_INTERFACE_MODE_1000BASEX;
-		}
-	}
-}
-EXPORT_SYMBOL_GPL(phylink_helper_basex_speed);
-
 static void phylink_decode_c37_word(struct phylink_link_state *state,
 				    uint16_t config_reg, int speed)
 {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 223781622b33..6d06896fc20d 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -160,11 +160,6 @@ struct phylink_mac_ops {
  * clearing unsupported speeds and duplex settings. The port modes
  * should not be cleared; phylink_set_port_modes() will help with this.
  *
- * If the @state->interface mode is %PHY_INTERFACE_MODE_1000BASEX
- * or %PHY_INTERFACE_MODE_2500BASEX, select the appropriate mode
- * based on @state->advertising and/or @state->speed and update
- * @state->interface accordingly. See phylink_helper_basex_speed().
- *
  * When @config->supported_interfaces has been set, phylink will iterate
  * over the supported interfaces to determine the full capability of the
  * MAC. The validation function must not print errors if @state->interface
@@ -579,7 +574,6 @@ int phylink_speed_up(struct phylink *pl);
 #define phylink_test(bm, mode)	__phylink_do_bit(test_bit, bm, mode)
 
 void phylink_set_port_modes(unsigned long *bits);
-void phylink_helper_basex_speed(struct phylink_link_state *state);
 
 void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
 				      u16 bmsr, u16 lpa);
-- 
2.30.2

