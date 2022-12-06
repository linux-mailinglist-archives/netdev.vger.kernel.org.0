Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81A0644C8B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiLFTcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLFTc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:32:29 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31EF3F04F;
        Tue,  6 Dec 2022 11:32:28 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id kw15so5336927ejc.10;
        Tue, 06 Dec 2022 11:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/l5Z9enoqLShnhsSAopI3P6y+/eGWTTXx1Yr1p8Q0ys=;
        b=TlOenE/Q3FlyWE91yvfKQVDzZfqs/a7o9cacFvNbAbvIrZoV1uW+kWP2ckpr+HEq0P
         +5LiG8wUoayk0A78OUZRgf1k64q/DsOzT1uEHul0hOX1PvB5pOyoBsJ/dWzlNBj1pWVm
         tJinrQ+4+OUEv/+vOXuiLlOVed6FmXM+nCkrT/uAj/LiEWRTTbqaFysAi8Nf3quUaQ+s
         3da6TxKKOiNwpxAyiBlbbWOTM7Ps0wF47lZVp3vVOQ3iDq18uWs4sw80j8Ki8K6ArSK6
         n6YCoGEQUbhQMAoAmKi8FOiO4LLmjAc0y3ioHRMbKlYV2ftXnItHz8FE95RI+lTiJC7K
         fhOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/l5Z9enoqLShnhsSAopI3P6y+/eGWTTXx1Yr1p8Q0ys=;
        b=5fO+/XZ5Rs7Rlp4ZL4WRMHHgYOfHqcRue5TYhyc1rCt5nH11Vh38VJD+z+eVe4RayI
         /30j7eAm2/B+O+6DLvbOvVOr0Am6y5fRzRqk3kuNh1Fco8RWwPDsGpSoAyaRTNLBINIY
         Pz0MNL6A1Q8uMdkT9xJNMv06Rqp4B+ffyurInmYwVarrQplMt/FGcWql2wTD5MBufRex
         NoRzYK2zpVXEs6g+5f6NZfG8mzdroNMtm+O5RiaHcIYhpzLfXjntVQAtYGjumpMCUWe4
         WttLMMg1bo+M3hVPNLnTlVFxpPsGzBLEQHnk80q617q0yU/YoTsQavyrGAyYSlteKFMU
         0zbA==
X-Gm-Message-State: ANoB5pmBomo7XOhpeN2AFyxwiVFIWo8FcL1Ya9N4WFn7gk4JjVMl1+v4
        Os6USSYWWSYvng97DZarsXM=
X-Google-Smtp-Source: AA0mqf7h1pLcfQlO+yvCe5ftl9C+y7VZUOhiJo/ZvdQfqKy8ilr+t9HActuPkkAdJvrnqfLKTKYbFw==
X-Received: by 2002:a17:906:49c2:b0:7aa:23ac:608e with SMTP id w2-20020a17090649c200b007aa23ac608emr57127813ejv.450.1670355147009;
        Tue, 06 Dec 2022 11:32:27 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id vk2-20020a170907cbc200b007bf5250b515sm7722041ejc.29.2022.12.06.11.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 11:32:26 -0800 (PST)
Date:   Tue, 6 Dec 2022 21:32:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v3 2/2] dsa: lan9303: Move to PHYLINK
Message-ID: <20221206193224.f3obnsjtphbxole4@skbuf>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-3-jerry.ray@microchip.com>
 <20221206183500.6898-3-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206183500.6898-3-jerry.ray@microchip.com>
 <20221206183500.6898-3-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 12:35:00PM -0600, Jerry Ray wrote:
> This patch replaces the .adjust_link api with the .phylink_get_caps api.

Am I supposed to read this commit description and understand what the
change does?

You can't "replace" adjust_link with phylink_get_caps, since they don't
do the same thing. The equivalent set of operations are roughly
phylink_mac_config and phylink_mac_link_up, probably just the latter in
your case.

By deleting adjust_link and not replacing with any of the above, the
change is telling me that nothing from adjust_link was needed?

> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
> v2-> v3:
>   Added back in disabling Turbo Mode on the CPU MII interface.
>   Removed the unnecessary clearing of the phy supported interfaces.
> ---
>  drivers/net/dsa/lan9303-core.c | 79 ++++++++++++++++++----------------
>  1 file changed, 42 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index baa336bb9d15..c6236b328ed8 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -886,6 +886,13 @@ static int lan9303_check_device(struct lan9303 *chip)
>  		return ret;
>  	}
>  
> +	/* Virtual Phy: Always disable Turbo 200Mbit mode */
> +	ret = lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
> +	if (ret)
> +		return ret;
> +	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
> +	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);

Separate patch which moves this, please.

> +
>  	return 0;
>  }
>  
> @@ -1047,42 +1054,6 @@ static int lan9303_phy_write(struct dsa_switch *ds, int phy, int regnum,
>  	return chip->ops->phy_write(chip, phy, regnum, val);
>  }
>  
> -static void lan9303_adjust_link(struct dsa_switch *ds, int port,
> -				struct phy_device *phydev)
> -{
> -	struct lan9303 *chip = ds->priv;
> -	int ctl;
> -
> -	if (!phy_is_pseudo_fixed_link(phydev))
> -		return;
> -
> -	ctl = lan9303_phy_read(ds, port, MII_BMCR);
> -
> -	ctl &= ~BMCR_ANENABLE;
> -
> -	if (phydev->speed == SPEED_100)
> -		ctl |= BMCR_SPEED100;
> -	else if (phydev->speed == SPEED_10)
> -		ctl &= ~BMCR_SPEED100;
> -	else
> -		dev_err(ds->dev, "unsupported speed: %d\n", phydev->speed);
> -
> -	if (phydev->duplex == DUPLEX_FULL)
> -		ctl |= BMCR_FULLDPLX;
> -	else
> -		ctl &= ~BMCR_FULLDPLX;
> -
> -	lan9303_phy_write(ds, port, MII_BMCR, ctl);

Are you going to explain why modifying this register is no longer needed?

> -
> -	if (port == chip->phy_addr_base) {
> -		/* Virtual Phy: Remove Turbo 200Mbit mode */
> -		lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ctl);
> -
> -		ctl &= ~LAN9303_VIRT_SPECIAL_TURBO;
> -		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl);
> -	}
> -}
> -
>  static int lan9303_port_enable(struct dsa_switch *ds, int port,
>  			       struct phy_device *phy)
>  {
> @@ -1279,6 +1250,40 @@ static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> +static void lan9303_phylink_get_caps(struct dsa_switch *ds, int port,
> +				     struct phylink_config *config)
> +{
> +	struct lan9303 *chip = ds->priv;
> +
> +	dev_dbg(chip->dev, "%s(%d) entered.", __func__, port);
> +
> +	config->mac_capabilities = MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
> +				   MAC_SYM_PAUSE;
> +
> +	if (dsa_port_is_cpu(dsa_to_port(ds, port))) {
> +		/* cpu port */

This comment and the "internal ports" are absolutely redundant, they
bring nothing to the understanding of the code.

> +		__set_bit(PHY_INTERFACE_MODE_RMII,
> +			  config->supported_interfaces);
> +		__set_bit(PHY_INTERFACE_MODE_MII,
> +			  config->supported_interfaces);
> +	} else {
> +		/* internal ports */
> +		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +			  config->supported_interfaces);
> +		/* Compatibility for phylib's default interface type when the
> +		 * phy-mode property is absent
> +		 */
> +		__set_bit(PHY_INTERFACE_MODE_GMII,
> +			  config->supported_interfaces);
> +	}
> +
> +	/* This driver does not make use of the speed, duplex, pause or the
> +	 * advertisement in its mac_config, so it is safe to mark this driver
> +	 * as non-legacy.
> +	 */
> +	config->legacy_pre_march2020 = false;
> +}
> +
>  /* For non-cpu ports, the max frame size is 1518.
>   * The CPU port supports a max frame size of 1522.
>   * There is a JUMBO flag to make the max size 2048, but this driver
> @@ -1304,7 +1309,7 @@ static const struct dsa_switch_ops lan9303_switch_ops = {
>  	.get_strings = lan9303_get_strings,
>  	.phy_read = lan9303_phy_read,
>  	.phy_write = lan9303_phy_write,
> -	.adjust_link = lan9303_adjust_link,
> +	.phylink_get_caps	= lan9303_phylink_get_caps,

Some of the lan9303_switch_ops are not aligned, and some are aligned
with spaces. None with tabs. Please be consistent with something that
exists, or create a preparatory patch which brings some more consistence
with the way in which you want things to be.

>  	.get_ethtool_stats = lan9303_get_ethtool_stats,
>  	.get_sset_count = lan9303_get_sset_count,
>  	.port_enable = lan9303_port_enable,
> -- 
> 2.17.1
> 

