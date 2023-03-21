Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E906C3666
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjCUP7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbjCUP7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:59:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102583E0A7
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=v0h1EwFjEcQIOmX4C2rRLVnoxXNfnqNVWYC6YxP51Ro=; b=ZLlzx9ri+eE/otr3tmsUHAWdlk
        jepS7Q968ZQoazOVqFpLafXYxIqn8mUXWxzPuDA11IZs+WvO/o7B4AvhWEYU2W9cMYeY0TXu/Sxqx
        cJa3RJBjoRdby736wRB5V52SqC6JqKx3bpuD/LcMFru9R6v+54nhHk9DW4KapQaDqe5u25pkDyftL
        YQsGHJ+sNzOWC9LzAdafLvbccO13CA53aGJMuTHAqF7aezsWfK+2tXvK9f0tuDAGLUJHzuSSBhNeB
        jKYDfYIyLkoa2Cj8Q6byL2GHvvFlzmkBJV2c/MI1UaW1bQJrOAcmgBvx7V6rNQZXSz7C4szxj0+2U
        dhRZCljg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58130 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1peeNz-0001UO-4S; Tue, 21 Mar 2023 15:58:55 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1peeNy-00DmhV-E6; Tue, 21 Mar 2023 15:58:54 +0000
In-Reply-To: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
References: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 3/3] net: phylink: remove an_enabled
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1peeNy-00DmhV-E6@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 21 Mar 2023 15:58:54 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Autoneg bit in the advertising bitmap and state->an_enabled are
always identical. state->an_enabled is now no longer used by any
drivers, so lets kill this duplication.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 37 +++++++++++++++++--------------------
 include/linux/phylink.h   |  2 --
 2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1a2f074685fa..f7da96f0c75b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -843,7 +843,6 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 		phylink_set(pl->supported, Autoneg);
 		phylink_set(pl->supported, Asym_Pause);
 		phylink_set(pl->supported, Pause);
-		pl->link_config.an_enabled = true;
 		pl->cfg_link_an_mode = MLO_AN_INBAND;
 
 		switch (pl->link_config.interface) {
@@ -945,9 +944,6 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 				    "failed to validate link configuration for in-band status\n");
 			return -EINVAL;
 		}
-
-		/* Check if MAC/PCS also supports Autoneg. */
-		pl->link_config.an_enabled = phylink_test(pl->supported, Autoneg);
 	}
 
 	return 0;
@@ -957,7 +953,8 @@ static void phylink_apply_manual_flow(struct phylink *pl,
 				      struct phylink_link_state *state)
 {
 	/* If autoneg is disabled, pause AN is also disabled */
-	if (!state->an_enabled)
+	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			       state->advertising))
 		state->pause &= ~MLO_PAUSE_AN;
 
 	/* Manual configuration of pause modes */
@@ -997,21 +994,22 @@ static void phylink_mac_config(struct phylink *pl,
 			       const struct phylink_link_state *state)
 {
 	phylink_dbg(pl,
-		    "%s: mode=%s/%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
+		    "%s: mode=%s/%s/%s/%s/%s adv=%*pb pause=%02x link=%u\n",
 		    __func__, phylink_an_mode_str(pl->cur_link_an_mode),
 		    phy_modes(state->interface),
 		    phy_speed_to_str(state->speed),
 		    phy_duplex_to_str(state->duplex),
 		    phy_rate_matching_to_str(state->rate_matching),
 		    __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
-		    state->pause, state->link, state->an_enabled);
+		    state->pause, state->link);
 
 	pl->mac_ops->mac_config(pl->config, pl->cur_link_an_mode, state);
 }
 
 static void phylink_mac_pcs_an_restart(struct phylink *pl)
 {
-	if (pl->link_config.an_enabled &&
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			      pl->link_config.advertising) &&
 	    phy_interface_mode_is_8023z(pl->link_config.interface) &&
 	    phylink_autoneg_inband(pl->cur_link_an_mode)) {
 		if (pl->pcs)
@@ -1138,9 +1136,9 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	linkmode_copy(state->advertising, pl->link_config.advertising);
 	linkmode_zero(state->lp_advertising);
 	state->interface = pl->link_config.interface;
-	state->an_enabled = pl->link_config.an_enabled;
 	state->rate_matching = pl->link_config.rate_matching;
-	if (state->an_enabled) {
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			      state->advertising)) {
 		state->speed = SPEED_UNKNOWN;
 		state->duplex = DUPLEX_UNKNOWN;
 		state->pause = MLO_PAUSE_NONE;
@@ -1531,7 +1529,6 @@ struct phylink *phylink_create(struct phylink_config *config,
 	pl->link_config.pause = MLO_PAUSE_AN;
 	pl->link_config.speed = SPEED_UNKNOWN;
 	pl->link_config.duplex = DUPLEX_UNKNOWN;
-	pl->link_config.an_enabled = true;
 	pl->mac_ops = mac_ops;
 	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
 	timer_setup(&pl->link_poll, phylink_fixed_poll, 0);
@@ -2136,8 +2133,9 @@ static void phylink_get_ksettings(const struct phylink_link_state *state,
 		kset->base.speed = state->speed;
 		kset->base.duplex = state->duplex;
 	}
-	kset->base.autoneg = state->an_enabled ? AUTONEG_ENABLE :
-				AUTONEG_DISABLE;
+	kset->base.autoneg = linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					       state->advertising) ?
+				AUTONEG_ENABLE : AUTONEG_DISABLE;
 }
 
 /**
@@ -2284,9 +2282,8 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	/* We have ruled out the case with a PHY attached, and the
 	 * fixed-link cases.  All that is left are in-band links.
 	 */
-	config.an_enabled = kset->base.autoneg == AUTONEG_ENABLE;
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising,
-			 config.an_enabled);
+			 kset->base.autoneg == AUTONEG_ENABLE);
 
 	/* If this link is with an SFP, ensure that changes to advertised modes
 	 * also cause the associated interface to be selected such that the
@@ -2320,13 +2317,14 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	}
 
 	/* If autonegotiation is enabled, we must have an advertisement */
-	if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			      config.advertising) &&
+	    phylink_is_empty_linkmode(config.advertising))
 		return -EINVAL;
 
 	mutex_lock(&pl->state_mutex);
 	pl->link_config.speed = config.speed;
 	pl->link_config.duplex = config.duplex;
-	pl->link_config.an_enabled = config.an_enabled;
 
 	if (pl->link_config.interface != config.interface) {
 		/* The interface changed, e.g. 1000base-X <-> 2500base-X */
@@ -2932,7 +2930,6 @@ static int phylink_sfp_config_phy(struct phylink *pl, u8 mode,
 	config.speed = SPEED_UNKNOWN;
 	config.duplex = DUPLEX_UNKNOWN;
 	config.pause = MLO_PAUSE_AN;
-	config.an_enabled = pl->link_config.an_enabled;
 
 	/* Ignore errors if we're expecting a PHY to attach later */
 	ret = phylink_validate(pl, support, &config);
@@ -3001,7 +2998,6 @@ static int phylink_sfp_config_optical(struct phylink *pl)
 	config.speed = SPEED_UNKNOWN;
 	config.duplex = DUPLEX_UNKNOWN;
 	config.pause = MLO_PAUSE_AN;
-	config.an_enabled = true;
 
 	/* For all the interfaces that are supported, reduce the sfp_support
 	 * mask to only those link modes that can be supported.
@@ -3300,7 +3296,8 @@ void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
 	/* If there is no link or autonegotiation is disabled, the LP advertisement
 	 * data is not meaningful, so don't go any further.
 	 */
-	if (!state->link || !state->an_enabled)
+	if (!state->link || !linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					       state->advertising))
 		return;
 
 	switch (state->interface) {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index c492c26202b5..9ff56b050584 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -93,7 +93,6 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
  *   the medium link mode (@speed and @duplex) and the speed/duplex of the phy
  *   interface mode (@interface) are different.
  * @link: true if the link is up.
- * @an_enabled: true if autonegotiation is enabled/desired.
  * @an_complete: true if autonegotiation has completed.
  */
 struct phylink_link_state {
@@ -105,7 +104,6 @@ struct phylink_link_state {
 	int pause;
 	int rate_matching;
 	unsigned int link:1;
-	unsigned int an_enabled:1;
 	unsigned int an_complete:1;
 };
 
-- 
2.30.2

