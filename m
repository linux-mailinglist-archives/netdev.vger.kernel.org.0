Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3196496D6
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 23:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiLKWqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 17:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKWqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 17:46:14 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28722766C;
        Sun, 11 Dec 2022 14:46:13 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id m18so23727575eji.5;
        Sun, 11 Dec 2022 14:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4t+X1ewQyAaXS2c2ACdajj+xeIxzg+vp3V44N0XagV8=;
        b=n54w8brFwQo67dkCuLOsjZdB2okCesNd2rz1IIWKwpe/yp+cju8bagq/K9LfDxVC+b
         ueRngrE3PQ+vLl2JKHfti6Uvj1GMXKOBwX+HRP+0UXcGovyEV/B0gdV3PHvimW6AURjv
         AG/4EyEAhD0GxywtmL7YqNn4/RFi+7asdf3OQp2EWNiNnHqS5tFA6QLQQC3GzrmrQbj2
         rZPQfaf9mxvYrGnd9f2n9/xVg2YYT8z9vYpgtnz7jDlq3GN1jBZJ4DQaGa1MUTullprM
         bHd0hcbUOCq4GQlw3macaCVpNht/Y9wu4uG7x7qJ5YT0e0RQa5n0iTawbc1dFXQymOkQ
         BmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4t+X1ewQyAaXS2c2ACdajj+xeIxzg+vp3V44N0XagV8=;
        b=OSkcrhSiEoNM9vvoZzP3etlbrHi/FLsWd0od1+eu18cBCirGlkyez4+lDoUNH+tkIl
         EAvoqXSDw8G0QRCnPlr81vp71Eg20zkN5j1zambKrpb2drdBcIGakNCAqEffi1NhsnL8
         OeEL3CCNC1P7NSaksNNAiZvpTDXDlDmr0N1AplhnuzHHDf/+q4uLDDl7D1xcuJuNbqSC
         17x+t6YX89R9jYq23cgin0iTCppNFnODZ+JbKpn8py/dj05TwBOqw6rASveu2ppJURmL
         /aibqMkAFhdvGMelcGr+Dchh72fUpuKg0n5MLGvtaZdC252CbFrW6BOLHRvB2MxowtPk
         9U6A==
X-Gm-Message-State: ANoB5pm7mcir6rLMDDf+nSQAvZVNcAunu29oBA+37gQwxQf1W8DepDFe
        v6g78bHqLiVbfKDOf5FGBTs=
X-Google-Smtp-Source: AA0mqf47ZjbNJLGyTHeT7V1X0QmDFj6n/dDSVy7vCwi2mLpGAV2slI1nrz9qJkvjJXaL7auHn27big==
X-Received: by 2002:a17:906:3157:b0:7c0:8fde:e008 with SMTP id e23-20020a170906315700b007c08fdee008mr11472988eje.35.1670798771566;
        Sun, 11 Dec 2022 14:46:11 -0800 (PST)
Received: from skbuf ([188.27.185.175])
        by smtp.gmail.com with ESMTPSA id u18-20020a1709061db200b007c1651aeeacsm1246341ejh.181.2022.12.11.14.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 14:46:11 -0800 (PST)
Date:   Mon, 12 Dec 2022 00:46:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, jbe@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v5 5/6] dsa: lan9303: Determine CPU port based
 on dsa_switch ptr
Message-ID: <20221211224608.rdlcuqg4d37f7z66@skbuf>
References: <20221209224713.19980-1-jerry.ray@microchip.com>
 <20221209224713.19980-6-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209224713.19980-6-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 04:47:12PM -0600, Jerry Ray wrote:
> In preparing to move the adjust_link logic into the phylink_mac_link_up
> api, change the macro used to check for the cpu port.

No justification given for why this change is made.

As a counter argument, I could point out that DSA can support configurations
where the CPU port is one of the 100BASE-TX PHY ports, and the MII port
can be used as a regular user port where a PHY has been connected. Some
people are already doing this, for example connecting a Beaglebone Black
(can also be Raspberry Pi or what have you) over SPI to a VSC7512 switch
evaluation board.

The LAN9303 documentation makes it rather clear to me that such a
configuration would be possible, because the Switch Engine Ingress Port
Type Register allows any of the 3 switch ports to expect DSA tags. It's
lan9303_setup_tagging() the one who hardcodes the driver configuration
to be that where port 0 is the only acceptable CPU port (as well as the
early check from lan9303_setup()).

DSA's understanding of a CPU port is only that - a port which carries
DSA-tagged traffic, and is not exposed as a net_device to user space.
Nothing about MII vs internal PHY ports - that is a separate classification,
and a dsa_is_cpu_port() test is simply not something relevant from
phylink's perspective, to put it simply.

What we see in other device drivers for phylink handling is that there
is driver-level knowledge as to which ports have internal PHYs and which
have xMII pins. See priv->info->supports_mii[] in sja1105, dev->info->supports_mii[]
in the ksz drivers, mv88e6xxx_phy_is_internal() in mv88e6xxx,
felix->info->port_modes[] in the ocelot drivers, etc etc. Hardcoding
port number 0 is also better from my perspective than looking for the
CPU port. That's because the switch IP was built with the idea in mind
that port 0 is MII.

I would very much appreciate if this driver did not make any assumptions
that the internal PHY ports cannot carry DSA-tagged traffic. This
assumption was true when the driver was introduced, but it changed with
commit 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports").
Coincidentally, that is also the commit which started prompting the
lan9303 driver for an update, via the dmesg warnings you are seeing.

It looks like there is potentially more code to unlock than this simple
API change, which is something you could look at.

> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
>  drivers/net/dsa/lan9303-core.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index 694249aa1f19..1d22e4b74308 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -1064,7 +1064,11 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
>  	struct lan9303 *chip = ds->priv;
>  	int ctl;
>  
> -	if (!phy_is_pseudo_fixed_link(phydev))
> +	/* On this device, we are only interested in doing something here if
> +	 * this is the CPU port. All other ports are 10/100 phys using MDIO
> +	 * to control there link settings.
> +	 */
> +	if (!dsa_is_cpu_port(ds, port))
>  		return;
>  
>  	ctl = lan9303_phy_read(ds, port, MII_BMCR);
> -- 
> 2.17.1
> 
