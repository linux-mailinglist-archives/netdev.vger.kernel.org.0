Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766D255C334
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238647AbiF0Ly2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238189AbiF0Lva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:51:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F8865C6
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NgZ1jiznNa2GJB/i+Iv8XujiVJxtgZsHyRtQGD5URa0=; b=ouhFKaQp7vD/S+QxuwQoKAy3O/
        MryK4T47WsAd5Wr9lsKDRGP9RAf/PaAj7EMIIb4gZclvDJsh6fQfzjYH5cfvfuINUfXWv/djeOegs
        rsMxZbI3VTJcvYGF/nNSIExEhxvspraEwZWkynYuN8VYNuwipPMjTunDJcBJPRR+8Ajr1AjPLMHGL
        y763Zy9Uk09521aOkwLavR6xuBeTeis/ZwZVGOGQxGPACT1Ww1/n1i0j4eZI3lA4wktd+atkIrIRZ
        KQI/c8Mf+vRTQC6oDIKS1CmAo1axVdGLzvXvMc5sr8FAsgoj2v6uONPlZu2eT0U8ASubswidqn7Q6
        fy1M/6Fw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53978 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o5nAV-0000HO-BH; Mon, 27 Jun 2022 12:44:39 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o5nAU-004RR7-Oh; Mon, 27 Jun 2022 12:44:38 +0100
In-Reply-To: <YrmYEC2N9mVpg9g6@shell.armlinux.org.uk>
References: <YrmYEC2N9mVpg9g6@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/2] net: phylink: remove pcs_ops member
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o5nAU-004RR7-Oh@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 27 Jun 2022 12:44:38 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the pcs_ops member from struct phylink, using the one stored in
struct phylink_pcs instead.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e20cdab824db..0216ea978261 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -43,7 +43,6 @@ struct phylink {
 	/* private: */
 	struct net_device *netdev;
 	const struct phylink_mac_ops *mac_ops;
-	const struct phylink_pcs_ops *pcs_ops;
 	struct phylink_config *config;
 	struct phylink_pcs *pcs;
 	struct device *dev;
@@ -779,8 +778,8 @@ static void phylink_mac_pcs_an_restart(struct phylink *pl)
 	if (pl->link_config.an_enabled &&
 	    phy_interface_mode_is_8023z(pl->link_config.interface) &&
 	    phylink_autoneg_inband(pl->cur_link_an_mode)) {
-		if (pl->pcs_ops)
-			pl->pcs_ops->pcs_an_restart(pl->pcs);
+		if (pl->pcs)
+			pl->pcs->ops->pcs_an_restart(pl->pcs);
 		else if (pl->config->legacy_pre_march2020)
 			pl->mac_ops->mac_an_restart(pl->config);
 	}
@@ -819,7 +818,6 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 	 */
 	if (pcs) {
 		pl->pcs = pcs;
-		pl->pcs_ops = pcs->ops;
 
 		if (!pl->phylink_disable_state &&
 		    pl->cfg_link_an_mode == MLO_AN_INBAND) {
@@ -832,12 +830,12 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 
 	phylink_mac_config(pl, state);
 
-	if (pl->pcs_ops) {
-		err = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
-					      state->interface,
-					      state->advertising,
-					      !!(pl->link_config.pause &
-						 MLO_PAUSE_AN));
+	if (pl->pcs) {
+		err = pl->pcs->ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
+					       state->interface,
+					       state->advertising,
+					       !!(pl->link_config.pause &
+						  MLO_PAUSE_AN));
 		if (err < 0)
 			phylink_err(pl, "pcs_config failed: %pe\n",
 				    ERR_PTR(err));
@@ -869,7 +867,7 @@ static int phylink_change_inband_advert(struct phylink *pl)
 	if (test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state))
 		return 0;
 
-	if (!pl->pcs_ops && pl->config->legacy_pre_march2020) {
+	if (!pl->pcs && pl->config->legacy_pre_march2020) {
 		/* Legacy method */
 		phylink_mac_config(pl, &pl->link_config);
 		phylink_mac_pcs_an_restart(pl);
@@ -886,10 +884,11 @@ static int phylink_change_inband_advert(struct phylink *pl)
 	 * restart negotiation if the pcs_config() helper indicates that
 	 * the programmed advertisement has changed.
 	 */
-	ret = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
-				      pl->link_config.interface,
-				      pl->link_config.advertising,
-				      !!(pl->link_config.pause & MLO_PAUSE_AN));
+	ret = pl->pcs->ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
+				       pl->link_config.interface,
+				       pl->link_config.advertising,
+				       !!(pl->link_config.pause &
+					  MLO_PAUSE_AN));
 	if (ret < 0)
 		return ret;
 
@@ -918,8 +917,8 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	state->an_complete = 0;
 	state->link = 1;
 
-	if (pl->pcs_ops)
-		pl->pcs_ops->pcs_get_state(pl->pcs, state);
+	if (pl->pcs)
+		pl->pcs->ops->pcs_get_state(pl->pcs, state);
 	else if (pl->mac_ops->mac_pcs_get_state &&
 		 pl->config->legacy_pre_march2020)
 		pl->mac_ops->mac_pcs_get_state(pl->config, state);
@@ -992,8 +991,8 @@ static void phylink_link_up(struct phylink *pl,
 
 	pl->cur_interface = link_state.interface;
 
-	if (pl->pcs_ops && pl->pcs_ops->pcs_link_up)
-		pl->pcs_ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
+	if (pl->pcs && pl->pcs->ops->pcs_link_up)
+		pl->pcs->ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
 					 pl->cur_interface,
 					 link_state.speed, link_state.duplex);
 
@@ -1115,7 +1114,7 @@ static void phylink_resolve(struct work_struct *w)
 			}
 			phylink_major_config(pl, false, &link_state);
 			pl->link_config.interface = link_state.interface;
-		} else if (!pl->pcs_ops && pl->config->legacy_pre_march2020) {
+		} else if (!pl->pcs && pl->config->legacy_pre_march2020) {
 			/* The interface remains unchanged, only the speed,
 			 * duplex or pause settings have changed. Call the
 			 * old mac_config() method to configure the MAC/PCS
-- 
2.30.2

