Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4084C432E
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbiBYLR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbiBYLRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:17:25 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D8FAEF02
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:16:52 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z22so6952132edd.1
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T20PLi6orBUz4AmFsf1rEpLd9/Z5uYkC4QJJFz7mtxw=;
        b=iFnOay0GH/RviNPcrYPO+F8Vu3gMS7SrR8Lz42PPSBXfh20v1+uniytkDVp5XXoGJY
         ohJLa5ZYU7erEfpsIvY9cwE7UU3YiL7iLSSOpeiXrDONPPC3gAYeIMf7fRud9EBiAAN7
         EchZux5VRrrPEGTSXpZqMhglHoIYQWOGD7FLWpOv0fm68IsE/mgA0x2wGPvcOOhzcH0s
         XT5mXCotswzWg82OMAdJcO7uxcW7n4qPuTnbq7ttoq8DOhZQKcj6mqYkZhKdRQINjx7A
         u3sqq+gIWCca9RVh+I7rbxC8/x4eqGl7jFQv9O5I47fxG/SXxb6RE/++nnI6Bg6I0H4D
         EvGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T20PLi6orBUz4AmFsf1rEpLd9/Z5uYkC4QJJFz7mtxw=;
        b=sAUuB9qSq7spn1XTWl7xW8RPEKipzHw1exeADdNEnahEWcc8bJikNMNJ33eYMYsAAZ
         23OaA63lGyAfzeZR9XPNQTD53yE1LfFMM3W2BCkne492cvhI9LrqjJUjAyvFYCj/kXKm
         OiklTVtXUHZD3r190g8IHwMZ4KOfSz9V2l7PQ3C9d/BM6vVu+8Cecs6L+bshBOMWLUA9
         fJxNyAWCyFfQPnl3Ymy42EQsPOzxC+28mTEp+mtSF3APi3iIIBSHtWE8H6DEMOk9hRDY
         JPAKxsspmjXnJyPTUHjSNDhG6lW7h4Eq4YVx2gzUfsDe/bj/omB8LnjOD93hhpXlNmZj
         Z68w==
X-Gm-Message-State: AOAM533rYaoPw52jgvjCGqt6Lpgt8ka2HaaDWiqNftephLgvB7a88gwr
        8YrjpuXeoMCgIjqf+tMEnqs=
X-Google-Smtp-Source: ABdhPJxc5OGiEYSDvvHm9W6NKcxmHUL1+4eM+cHHAy59OVhlDU1Grejb0P16nszuXF/zE3oOMaijbQ==
X-Received: by 2002:a05:6402:34c2:b0:40f:f72e:ef4e with SMTP id w2-20020a05640234c200b0040ff72eef4emr6571227edc.147.1645787810753;
        Fri, 25 Feb 2022 03:16:50 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id cf10-20020a0564020b8a00b00412b19c1aaesm1191068edb.12.2022.02.25.03.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 03:16:50 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:16:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 6/6] net: dsa: sja1105: support switching
 between SGMII and 2500BASE-X
Message-ID: <20220225111649.pkmq3jxo6mm4qzfv@skbuf>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
 <E1nNGmL-00AOjC-HP@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nNGmL-00AOjC-HP@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 04:15:41PM +0000, Russell King (Oracle) wrote:
> Vladimir Oltean suggests that sla1105 can support switching between

s/sla1105/sja1105/

> SGMII and 2500BASE-X modes. Augment sja1105_phylink_get_caps() to
> fill in both interface modes if they can be supported.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 28 +++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index 5beef06d8ff7..36001b1d7968 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -1396,6 +1396,7 @@ static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
>  {
>  	struct sja1105_private *priv = ds->priv;
>  	struct sja1105_xmii_params_entry *mii;
> +	phy_interface_t phy_mode;
>  
>  	/* This driver does not make use of the speed, duplex, pause or the
>  	 * advertisement in its mac_config, so it is safe to mark this driver
> @@ -1403,11 +1404,28 @@ static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
>  	 */
>  	config->legacy_pre_march2020 = false;
>  
> -	/* The SJA1105 MAC programming model is through the static config
> -	 * (the xMII Mode table cannot be dynamically reconfigured), and
> -	 * we have to program that early.
> -	 */
> -	__set_bit(priv->phy_mode[port], config->supported_interfaces);
> +	phy_mode = priv->phy_mode[port];
> +	if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
> +	    phy_mode == PHY_INTERFACE_MODE_2500BASEX) {
> +		/* Changing the PHY mode on SERDES ports is possible and makes
> +		 * sense, because that is done through the XPCS. We allow
> +		 * changes between SGMII and 2500base-X (it is unknown whether
> +		 * 1000base-X is supported).
> +		 */

It is actually known (or so I think).
Bits 2:1 (PCS_MODE) of register VR_MII_AN_CTRL (MMD 0x1f, address 0x8001)
of the XPCS, as instantiated in SJA1105R/S, says:
00: Clause 37 auto-negotiation for 1000BASE-X mode
    *Not supported*
10: Clause 37 auto-negotiation for SGMII mode

When I look at the XPCS documentation for SJA1110, it doesn't say
"Not supported", however I don't have the setup to try it.
If it's anything like the XPCS instantiation from SJA1105 though, this
is possibly a documentation glitch and I wouldn't say it was implemented
just because the documentation doesn't say it isn't.

On the other hand, disabling SGMII in-band autoneg is possible, and the
resulting mode is electrically compatible with 1000Base-X without
in-band autoneg. Interpret this as you wish.

> +		if (priv->info->supports_sgmii[port])
> +			__set_bit(PHY_INTERFACE_MODE_SGMII,
> +				  config->supported_interfaces);
> +
> +		if (priv->info->supports_2500basex[port])
> +			__set_bit(PHY_INTERFACE_MODE_2500BASEX,
> +				  config->supported_interfaces);
> +	} else {
> +		/* The SJA1105 MAC programming model is through the static
> +		 * config (the xMII Mode table cannot be dynamically
> +		 * reconfigured), and we have to program that early.
> +		 */
> +		__set_bit(phy_mode, config->supported_interfaces);
> +	}
>  
>  	/* The MAC does not support pause frames, and also doesn't
>  	 * support half-duplex traffic modes.
> -- 
> 2.30.2
> 
