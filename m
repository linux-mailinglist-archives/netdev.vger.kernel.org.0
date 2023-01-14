Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A96166ADD7
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 21:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjANUtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 15:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjANUtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 15:49:49 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D227C5586;
        Sat, 14 Jan 2023 12:49:47 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id 18so35775329edw.7;
        Sat, 14 Jan 2023 12:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DvZ3HDWEbSKbM8raiD/XH7gqGZhbY908ZCMh75F2fsQ=;
        b=JlvR5ilk61BKQptQmY6ItOyU8nzaIPRXm2aJnextJTZmtULbCswL8rIK7aqyjxcyaZ
         NCzsOMSwnwbqNcnR6mOctf0uvR14Q5UXozJnLXJ+klVjVw46yy3PZ9vcyqEPI9N7vh+3
         W/NnBObK6ZAZ/EypxLI/4Idh0tDoX/qiA2g1gnl5O/UIUcGKsbjg6lt+9aTePMwc6CjG
         bDTLmcMvVMYRHrWFoBirQvnmlziTkVu8O+opJwOKdV5I14SoII+fiWZUlDsjjO7Eu0nT
         qzBa7PLh8qPkD2J73CwV8CFi7p2JGyz7MtSJcR3BdEBWtxHEwgnMgkYGJBkzHzNAA6AA
         kH4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvZ3HDWEbSKbM8raiD/XH7gqGZhbY908ZCMh75F2fsQ=;
        b=KWSoymMcZAnq/j1F+L7LCVMoDET1j+Jq4/8d+9E4Kf6DM/m2IC/DqnbYVD1pF+xqin
         nw/5BPDdiIjZL3Lm2i6aWDS0JN+fru9DZPjy8em5u5ESsl0OsDzQlMxVpiJT/9POuUnD
         oyr9EzNpuvVyHXdkNtqQTGmMnu/nsOhzi3hx0L9pF/Cn/OQqZ0JRKlr2ejIj4OaZVE12
         WjZ/t8zi8Abk2OWI5G8msICq53ELepqEIh0a2nOgfhsyUUJ1NWJMqWab6ln3cXk5x0m0
         xr85kuXFiSWe8spcditU2NRKKkQtFv3KL9Mmx8Z9/ixJ1mJpcc1lwbSbCyuyh3YgmtEJ
         yMug==
X-Gm-Message-State: AFqh2kokGQmwmldWFTIQ/w9WPUUpqTLXTwcAFKI5P6CDI0PQovXHfM+L
        0Pown2v8bJhN9c42FGVaMxc=
X-Google-Smtp-Source: AMrXdXtk+7nUv1cs0FbuNaIip/FCPofZ9H1JbLbFwm01iT4P2Nhprq4ur4KoBrOhWALNr2dPnJ1QNg==
X-Received: by 2002:a05:6402:5515:b0:491:6ea2:e875 with SMTP id fi21-20020a056402551500b004916ea2e875mr33029792edb.35.1673729386276;
        Sat, 14 Jan 2023 12:49:46 -0800 (PST)
Received: from skbuf ([188.27.184.249])
        by smtp.gmail.com with ESMTPSA id el14-20020a056402360e00b00458b41d9460sm9331281edb.92.2023.01.14.12.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 12:49:45 -0800 (PST)
Date:   Sat, 14 Jan 2023 22:49:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, jbe@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/6] dsa: lan9303: move Turbo Mode bit init
Message-ID: <20230114204943.jncpislrqjqvinie@skbuf>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-3-jerry.ray@microchip.com>
 <20230109211849.32530-3-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109211849.32530-3-jerry.ray@microchip.com>
 <20230109211849.32530-3-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 03:18:45PM -0600, Jerry Ray wrote:
> In preparing to remove the .adjust_link api, I am moving the one-time
> initialization of the device's Turbo Mode bit into a different execution
> path. This code clears (disables) the Turbo Mode bit which is never used
> by this driver. Turbo Mode is a non-standard mode that would allow the
> 100Mbps RMII interface to run at 200Mbps.
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
>  drivers/net/dsa/lan9303-core.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index 5a21fc96d479..50470fb09cb4 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -886,6 +886,12 @@ static int lan9303_check_device(struct lan9303 *chip)
>  		return ret;
>  	}
>  
> +	/* Virtual Phy: Remove Turbo 200Mbit mode */
> +	lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
> +
> +	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
> +	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
> +

Isn't a function whose name is lan9303_check_device() being abused for
this purpose (device initialization)?

>  	return 0;
>  }
>  
> @@ -1050,7 +1056,6 @@ static int lan9303_phy_write(struct dsa_switch *ds, int phy, int regnum,
>  static void lan9303_adjust_link(struct dsa_switch *ds, int port,
>  				struct phy_device *phydev)
>  {
> -	struct lan9303 *chip = ds->priv;
>  	int ctl;
>  
>  	if (!phy_is_pseudo_fixed_link(phydev))
> @@ -1073,14 +1078,6 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
>  		ctl &= ~BMCR_FULLDPLX;
>  
>  	lan9303_phy_write(ds, port, MII_BMCR, ctl);
> -
> -	if (port == chip->phy_addr_base) {
> -		/* Virtual Phy: Remove Turbo 200Mbit mode */
> -		lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ctl);
> -
> -		ctl &= ~LAN9303_VIRT_SPECIAL_TURBO;
> -		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl);
> -	}
>  }
>  
>  static int lan9303_port_enable(struct dsa_switch *ds, int port,
> -- 
> 2.17.1
> 

