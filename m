Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8198D4BE7AA
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347198AbiBUOQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:16:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377452AbiBUOPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:15:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592B412754
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qCbD9ykSFPpGLmCjOscyw1pEI2DYJ+zVcvI5P/yrMTE=; b=sPgb4c8iEg5G0itd8TWRzv9aZX
        N9kYWpX/mhbduFdVGtbyQdvBjr4cArpYMCU8AUWovyNWwV9dcdIctxi8FUFzlvj369f0g2vjQqAg+
        JzJxzft9wgZkP9JxLwfpnasJGta+g90OHWEb4BSFf8v64jrNY1NttEVxicPEOIBdx28YzeQ3qcmtT
        W7JPDfyU+ixc+8VSvcrj1rqqdJihbAVmva0mdPzXnmv5+CH6sLTNNDdlLMkEe8E2WvH15Sc5vOhSO
        E0RBqiJpWFRpembg44DP0owLah6GFmQwfb6dx6ZPi6m/cu9J4l8au8ilBMTCyxVEu1+pyxEoZTSfh
        cAOUN3BA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57392)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nM9TL-0000UZ-9g; Mon, 21 Feb 2022 14:15:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nM9TK-0007N0-EL; Mon, 21 Feb 2022 14:15:26 +0000
Date:   Mon, 21 Feb 2022 14:15:26 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 1/6] net: dsa: add support for phylink
 mac_select_pcs()
Message-ID: <YhOeftlyzP0U9zR8@shell.armlinux.org.uk>
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
 <E1nKlY3-009aKs-Oo@rmk-PC.armlinux.org.uk>
 <20220219211241.beyajbwmuz7fg2bt@skbuf>
 <20220219212223.efd2mfxmdokvaosq@skbuf>
 <YhOT4WbZ1FHXDHIg@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhOT4WbZ1FHXDHIg@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 01:30:09PM +0000, Russell King (Oracle) wrote:
> On Sat, Feb 19, 2022 at 11:22:24PM +0200, Vladimir Oltean wrote:
> > On Sat, Feb 19, 2022 at 11:12:41PM +0200, Vladimir Oltean wrote:
> > > >  static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
> > > >  	.validate = dsa_port_phylink_validate,
> > > > +	.mac_select_pcs = dsa_port_phylink_mac_select_pcs,
> > > 
> > > This patch breaks probing on DSA switch drivers that weren't converted
> > > to supported_interfaces, due to this check in phylink_create():
> > 
> > And this is only the most superficial layer of breakage. Everywhere in
> > phylink.c where pl->mac_ops->mac_select_pcs() is used, its presence is
> > checked and non-zero return codes from it are treated as hard errors,
> > even -EOPNOTSUPP, even if this particular error code is probably
> > intended to behave identically as the absence of the function pointer,
> > for compatibility.
> 
> I don't understand what problem you're getting at here - and I don't
> think there is a problem.
> 
> While I know it's conventional in DSA to use EOPNOTSUPP to indicate
> that a called method is not implemented, this is not something that
> is common across the board - and is not necessary here.
> 
> The implementation of dsa_port_phylink_mac_select_pcs() returns a
> NULL PCS when the DSA operation for it is not implemented. This
> means that:
> 
> 1) phylink_validate_mac_and_pcs() won't fail due to mac_select_pcs()
>    being present but DSA drivers not implementing it.
> 
> 2) phylink_major_config() will not attempt to call phylink_set_pcs()
>    to change the PCS.
> 
> So, that much is perfectly safe.
> 
> As for your previous email reporting the problem with phylink_create(),
> thanks for the report and sorry for the breakage - the breakage was
> obviously not intended, and came about because of all the patch
> shuffling I've done over the last six months trying to get these
> changes in, and having forgotten about this dependency.
> 
> I imagine the reason you've raised EOPNOTSUPP is because you wanted to
> change dsa_port_phylink_mac_select_pcs() to return an error-pointer
> encoded with that error code rather than NULL, but you then (no
> surprises to me) caused phylink to fail.
> 
> Considering the idea of using EOPNOTSUPP, at the two places we call
> mac_select_pcs(), we would need to treat this the same way we currently
> treat NULL. We would also need phylink_create() to call
> mac_select_pcs() if the method is non-NULL to discover if the DSA
> sub-driver implements the method - but we would need to choose an
> interface at this point.
> 
> I think at this point, I'd rather:
> 
> 1) add a bool in struct phylink to indicate whether we should be calling
>    mac_select_pcs, and replace the
> 
> 	if (pl->mac_ops->mac_select_pcs)
> 
>    with
> 
>         if (pl->using_mac_select_pcs)
> 
> 2) have phylink_create() do:
> 
> 	bool using_mac_select_pcs = false;
> 
> 	if (mac_ops->mac_select_pcs &&
> 	    mac_ops->mac_select_pcs(config, PHY_INTERFACE_MODE_NA) != 
> 	      ERR_PTR(-EOPNOTSUPP))
> 		using_mac_select_pcs = true;
> 
> 	if (using_mac_select_pcs &&
> 	    phy_interface_empty(config->supported_interfaces)) {
> 		...
> 
> 	...
> 
> 	pl->using_mac_select_pcs = using_mac_select_pcs;
> 
> which should give what was intended until DSA drivers are all updated
> to fill in config->supported_interfaces.

Please try this patch, thanks:

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6c7ab4a7a3be..de0557bbd4a7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -74,6 +74,7 @@ struct phylink {
 	struct work_struct resolve;
 
 	bool mac_link_dropped;
+	bool using_mac_select_pcs;
 
 	struct sfp_bus *sfp_bus;
 	bool sfp_may_have_phy;
@@ -416,7 +417,7 @@ static int phylink_validate_mac_and_pcs(struct phylink *pl,
 	int ret;
 
 	/* Get the PCS for this interface mode */
-	if (pl->mac_ops->mac_select_pcs) {
+	if (pl->using_mac_select_pcs) {
 		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
 		if (IS_ERR(pcs))
 			return PTR_ERR(pcs);
@@ -791,7 +792,7 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 
 	phylink_dbg(pl, "major config %s\n", phy_modes(state->interface));
 
-	if (pl->mac_ops->mac_select_pcs) {
+	if (pl->using_mac_select_pcs) {
 		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
 		if (IS_ERR(pcs)) {
 			phylink_err(pl,
@@ -1204,11 +1205,17 @@ struct phylink *phylink_create(struct phylink_config *config,
 			       phy_interface_t iface,
 			       const struct phylink_mac_ops *mac_ops)
 {
+	bool using_mac_select_pcs = false;
 	struct phylink *pl;
 	int ret;
 
-	/* Validate the supplied configuration */
 	if (mac_ops->mac_select_pcs &&
+	    mac_ops->mac_select_pcs(config, PHY_INTERFACE_MODE_NA) !=
+	      ERR_PTR(-EOPNOTSUPP))
+		using_mac_select_pcs = true;
+
+	/* Validate the supplied configuration */
+	if (using_mac_select_pcs &&
 	    phy_interface_empty(config->supported_interfaces)) {
 		dev_err(config->dev,
 			"phylink: error: empty supported_interfaces but mac_select_pcs() method present\n");
@@ -1232,6 +1239,7 @@ struct phylink *phylink_create(struct phylink_config *config,
 		return ERR_PTR(-EINVAL);
 	}
 
+	pl->using_mac_select_pcs = using_mac_select_pcs;
 	pl->phy_state.interface = iface;
 	pl->link_interface = iface;
 	if (iface == PHY_INTERFACE_MODE_MOCA)
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 258782bf4271..367d141c6971 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1058,8 +1058,8 @@ dsa_port_phylink_mac_select_pcs(struct phylink_config *config,
 				phy_interface_t interface)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct phylink_pcs *pcs = ERR_PTR(-EOPNOTSUPP);
 	struct dsa_switch *ds = dp->ds;
-	struct phylink_pcs *pcs = NULL;
 
 	if (ds->ops->phylink_mac_select_pcs)
 		pcs = ds->ops->phylink_mac_select_pcs(ds, dp->index, interface);
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
