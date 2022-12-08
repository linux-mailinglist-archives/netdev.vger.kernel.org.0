Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8416474F3
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiLHRVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiLHRVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:21:10 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E0A8C68A;
        Thu,  8 Dec 2022 09:21:09 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id qk9so5659182ejc.3;
        Thu, 08 Dec 2022 09:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D8/R1/2d8c9xPYVkIv9LxljcgnWSN3NN1komdbPL1GU=;
        b=H/QRB+v56VVl6U6d0A3E23nnO2UGs1dDyT5YliMHUerlkaDZxVPfJyk0rsORByp/JE
         JwK3OXIBlJAz4+SHyeOHjq1B05pGw9Er/oi0ieahHBkBxCsCV+EbAC6LcprKDju7zQgO
         pX95w3cewoaJ9XfjBicFG/Bi2uSL9hCfwKbL7N2H2+zT8JWYu7qK88LqoipX3vye6Brf
         SmloPtgXYGfbOEH6OHmDbXK7slH54syD6jtB3U/TFoagf+Dphh+VhK5NM2bC6lZ49rq/
         FtHCU7XFUiMI55/2um2AMz8QxxDnV0MM2pERR570QSaSTZQleEsIMVl4tdOiFuUOAKtn
         /SFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8/R1/2d8c9xPYVkIv9LxljcgnWSN3NN1komdbPL1GU=;
        b=NUeqpjjfE7HFBwwAU08qtza5cFtlxmsFZDi7dh2hZ+amPoSxq3HH78VirI1GGK/K09
         akLD4GEuUpWelW+aCgnBmrahTLYC4WU5EtzJBIREbBt2BVgBtk7a1cNKnrbFqWAlxoAf
         T71/2+GTVn1I+b7dKKSSKekq7WQxvl9UFz/uVQV/u4EF0XkjMHS5b9slAueeUIuqF8m6
         fhnhPnC4ecRnGJARd5w0281JXsbM2FLicQ3FKG24+MSFoHO2QbhZXcgpQ8v6DsE9miCp
         5zGCIcqU/2499d+FpqBuH+revY9GoD5LiJpGbYNgBhSz+Ty2Ez/vPxnj8Jso6086TlA3
         kt5w==
X-Gm-Message-State: ANoB5pku4XC4DhhfGnDp/ypspDfUBxKiczpzqcYMkJEH92oGKuzk7ihP
        7FRzRBSwSZ00b33kPdQ499Y=
X-Google-Smtp-Source: AA0mqf4G9PqyiGJMqG52lilLKzTopaULnLryZvyhROFygbVmbR27JD6tqTiKWJCiILN/5ZjEVY7b7g==
X-Received: by 2002:a17:906:70d0:b0:7c0:8371:97aa with SMTP id g16-20020a17090670d000b007c0837197aamr2471721ejk.28.1670520067504;
        Thu, 08 Dec 2022 09:21:07 -0800 (PST)
Received: from skbuf ([188.26.185.87])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906219200b0078d22b0bcf2sm9856027eju.168.2022.12.08.09.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 09:21:07 -0800 (PST)
Date:   Thu, 8 Dec 2022 19:21:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v4 2/2] dsa: lan9303: Migrate to PHYLINK
Message-ID: <20221208172105.4736qmzfckottfvm@skbuf>
References: <20221207232828.7367-1-jerry.ray@microchip.com>
 <20221207232828.7367-1-jerry.ray@microchip.com>
 <20221207232828.7367-3-jerry.ray@microchip.com>
 <20221207232828.7367-3-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207232828.7367-3-jerry.ray@microchip.com>
 <20221207232828.7367-3-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 05:28:28PM -0600, Jerry Ray wrote:
> This patch replaces the adjust_link api with the phylink apis to provide
> equivalent functionality.
> 
> The functionality from the adjust_link is moved to the phylink_mac_link_up
> api.  The code being removed only affected the cpu port.
> 
> Removes:
> .adjust_link
> Adds:
> .phylink_get_caps
> .phylink_mac_link_up
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
> v3-> v4:
>   - Reworked the implementation to preserve the adjust_link functionality
>     by including it in the phylink_mac_link_up api.
> v2-> v3:
>   Added back in disabling Turbo Mode on the CPU MII interface.
>   Removed the unnecessary clearing of the phy supported interfaces.
> ---
>  drivers/net/dsa/lan9303-core.c | 123 +++++++++++++++++++++++----------
>  1 file changed, 86 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index d9f7b554a423..a800448c9433 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -1047,42 +1047,6 @@ static int lan9303_phy_write(struct dsa_switch *ds, int phy, int regnum,
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

We discourage code movement which also changes the code in question.
Code movement should be just that, movement. If you don't like this
check and want to replace it with dsa_port_is_cpu(), do so in a
preparatory patch.

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
> @@ -1279,13 +1243,98 @@ static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
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
> +	if (dsa_is_cpu_port(ds, port)) {
> +		__set_bit(PHY_INTERFACE_MODE_RMII,
> +			  config->supported_interfaces);
> +		__set_bit(PHY_INTERFACE_MODE_MII,
> +			  config->supported_interfaces);
> +	} else {
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
> +static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int port,
> +					unsigned int mode,
> +					phy_interface_t interface,
> +					struct phy_device *phydev, int speed,
> +					int duplex, bool tx_pause,
> +					bool rx_pause)
> +{
> +	struct lan9303 *chip = ds->priv;
> +	u32 ctl;
> +	int ret;
> +
> +	dev_dbg(chip->dev, "%s(%d) entered - %s.", __func__, port,
> +		phy_modes(interface));
> +
> +	/* if this is not the cpu port, then simply return. */

As a reader, I find my intelligence insulted by self-evident comments such as this.

Especially in contrast with the writes below to the MII_BMCR of the
Virtual PHY, which would certainly deserve a bit more of an explanation,
yet there is none there.

> +	if (!dsa_port_is_cpu(dsa_to_port(ds, port)))
> +		return;
> +
> +	ctl = lan9303_phy_read(ds, port, MII_BMCR);
> +
> +	ctl &= ~BMCR_ANENABLE;
> +
> +	if (speed == SPEED_100)
> +		ctl |= BMCR_SPEED100;
> +	else if (speed == SPEED_10)
> +		ctl &= ~BMCR_SPEED100;
> +	else
> +		dev_err(ds->dev, "unsupported speed: %d\n", speed);
> +
> +	if (duplex == DUPLEX_FULL)
> +		ctl |= BMCR_FULLDPLX;
> +	else
> +		ctl &= ~BMCR_FULLDPLX;
> +
> +	lan9303_phy_write(ds, port, MII_BMCR, ctl);
> +
> +	if (port == chip->phy_addr_base) {
> +		/* Virtual Phy: Remove Turbo 200Mbit mode */
> +		ret = lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL,
> +				   &ctl);
> +		if (ret)
> +			return;
> +
> +		/* Clear the TURBO Mode bit if it was set. */
> +		if (ctl & LAN9303_VIRT_SPECIAL_TURBO) {
> +			ctl &= ~LAN9303_VIRT_SPECIAL_TURBO;
> +			regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL,
> +				     ctl);
> +		}
> +	}

You actually had something good going in the previous patch. The action
of disabling Turbo MII mode seems invariant of the negotiated link
settings. So it would be better to do it just once, during switch setup.
It would be good if you could add one more preparatory patch which does
just that. Assuming, of course, that the reordering in register writes
between LAN9303_VIRT_SPECIAL_CTRL and MII_BMCR will not cause a problem,
and that the link still works.

> +}
> +
>  static const struct dsa_switch_ops lan9303_switch_ops = {
>  	.get_tag_protocol	= lan9303_get_tag_protocol,
>  	.setup			= lan9303_setup,
>  	.get_strings		= lan9303_get_strings,
>  	.phy_read		= lan9303_phy_read,
>  	.phy_write		= lan9303_phy_write,
> -	.adjust_link		= lan9303_adjust_link,
> +	.phylink_get_caps	= lan9303_phylink_get_caps,
> +	.phylink_mac_link_up	= lan9303_phylink_mac_link_up,
>  	.get_ethtool_stats	= lan9303_get_ethtool_stats,
>  	.get_sset_count		= lan9303_get_sset_count,
>  	.port_enable		= lan9303_port_enable,
> -- 
> 2.17.1
> 

