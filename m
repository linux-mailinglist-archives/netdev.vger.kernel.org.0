Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEB018581B
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgCOByh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727524AbgCOByg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Q6HsoUxqZ7cmilY5PPiATijboZRquEoRu5alamEt44k=; b=3yK5v0Qp+MHG/GuiZ60Qk0oBVb
        MKcypxiAuuNzqfvH051si8SedtaM2/MqWvVoykupp3bc5cOwUSyuWTjGpvOc/w4irOCfSerVv38h6
        Gd5aCkf05VRj4Gj6OOFc+2N91oRC+r6aGAaecNnk0McZ4z70UXSXBU4KCYUIjZFqtNHA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDBfy-0001cP-OX; Sat, 14 Mar 2020 19:38:22 +0100
Date:   Sat, 14 Mar 2020 19:38:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 3/8] net: dsa: mv88e6xxx: configure interface
 settings in mac_config
Message-ID: <20200314183822.GG5388@lunn.ch>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
 <E1jD3pS-0006DU-DV@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jD3pS-0006DU-DV@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:15:38AM +0000, Russell King wrote:
> Only configure the interface settings in mac_config(), leaving the
> speed and duplex settings to mac_link_up to deal with.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> @@ -603,33 +613,26 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
>  				 const struct phylink_link_state *state)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
> -	int speed, duplex, link, pause, err;
> +	int err;
>  
> +	/* FIXME: is this the correct test? If we're in fixed mode on an
> +	 * internal port, why should we process this any different from
> +	 * PHY mode? On the other hand, the port may be automedia between
> +	 * an internal PHY and the serdes...
> +	 */

> -	err = mv88e6xxx_port_setup_mac(chip, port, link, speed, duplex, pause,
> -				       state->interface);
> +	/* FIXME: should we force the link down here - but if we do, how
> +	 * do we restore the link force/unforce state? The driver layering
> +	 * gets in the way.
> +	 */
> +	err = mv88e6xxx_port_config_interface(chip, port, state->interface);

Hi Russell

I'm not too keen on these FIXMEs, but i don't have time at the moment
to take a closer look.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
