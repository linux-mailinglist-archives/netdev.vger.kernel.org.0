Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433174A8A27
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352900AbiBCRdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352902AbiBCRdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:33:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22B9C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cnHzcZWWo2B1XYeox8Tga+hw1M3rf/ODvVizUxJgqgA=; b=TP/oO30avlju1A0zfey/FXelhC
        onT50rC6B+Bf6bRFWmNkNkNSUad+ua02F4Mjr0Pg9p69hBZ0o6W92zgIHJC8rq6tvTpCePzWWglGk
        wd6uTyfeVegFa0WbnFTFM6qCyAEL4OrRk7nc0/RDWe3B07V4D+XXVkQPLFPW2xaHzW2R4TE9Lp8AD
        urnYhj31y3xuI4Kp3EF3Q1cgyVRve4M1LN42Uwfza81TAhZDp9ly1soP8muwqvvNDpNqA7Uh5Asqx
        +hb4jgcke7HA2QhR/eX2rAnz7xncOnwafYb8PlmAT57an/x4qBYJSLGgF1ysy++oQfAeguzce3viE
        HVBI/J2A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57020)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nFfyn-00030t-88; Thu, 03 Feb 2022 17:33:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nFfym-0004BX-Jw; Thu, 03 Feb 2022 17:33:08 +0000
Date:   Thu, 3 Feb 2022 17:33:08 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: b53: clean up if() condition
 to be more readable
Message-ID: <YfwR1Ix5UG7MppKP@shell.armlinux.org.uk>
References: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
 <E1nFfwa-006X66-Dd@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nFfwa-006X66-Dd@rmk-PC.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the unintentional re-send, please ignore the second set.

On Thu, Feb 03, 2022 at 05:30:52PM +0000, Russell King (Oracle) wrote:
> I've stared at this if() statement for a while trying to work out if
> it really does correspond with the comment above, and it does seem to.
> However, let's make it more readable and phrase it in the same way as
> the comment.
> 
> Also add a FIXME into the comment - we appear to deny Gigabit modes for
> 802.3z interface modes, but 802.3z interface modes only operate at
> gigabit and above.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/b53/b53_common.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index a3b98992f180..7d62b0aeaae9 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1327,11 +1327,14 @@ void b53_phylink_validate(struct dsa_switch *ds, int port,
>  
>  	/* With the exclusion of 5325/5365, MII, Reverse MII and 802.3z, we
>  	 * support Gigabit, including Half duplex.
> +	 *
> +	 * FIXME: this is weird - 802.3z is always Gigabit, but we exclude
> +	 * it here. Why? This makes no sense.
>  	 */
> -	if (state->interface != PHY_INTERFACE_MODE_MII &&
> -	    state->interface != PHY_INTERFACE_MODE_REVMII &&
> -	    !phy_interface_mode_is_8023z(state->interface) &&
> -	    !(is5325(dev) || is5365(dev))) {
> +	if (!(state->interface == PHY_INTERFACE_MODE_MII ||
> +	      state->interface == PHY_INTERFACE_MODE_REVMII ||
> +	      phy_interface_mode_is_8023z(state->interface) ||
> +	      is5325(dev) || is5365(dev))) {
>  		phylink_set(mask, 1000baseT_Full);
>  		phylink_set(mask, 1000baseT_Half);
>  	}
> -- 
> 2.30.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
