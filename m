Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013403687A8
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbhDVUGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVUGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 16:06:44 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5D3C06174A;
        Thu, 22 Apr 2021 13:06:09 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id e9so7115813plj.2;
        Thu, 22 Apr 2021 13:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0gYZl4F54Ri1q9oiH8D45tiOdCQRDka+ek5p5055zFc=;
        b=BOJKHPhRbPgvXD8tqeo7dKO3SyemrX6wpnxt0aSnwIuGlEi0HsP3HiqIzR+Mx3ZqVC
         mrzdVaP5BvF5nknqbJ/ichPg9wgld2w4XEuh5anw+3xA/XwEftIY8Pklu/622t9ua+j7
         UCctU4UhjwJmahNCPCSV479r7XJ2vJqtQTS1SPFzQm/GaDFN0cjUBYnPczojPYxpHOUY
         IGAOX+Hl+9uV76dzZusOfyFbJE9MFZ0/76/ygWyJk7i3tVydNagmSYThKTJVUJ0hnOzf
         fD0KVcgtE/icWtNOpXKJu5Fa3XlSEXgzDhL1d9Gr+3XRKFVI4giYm5TsvSG852aV0xzf
         0GsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0gYZl4F54Ri1q9oiH8D45tiOdCQRDka+ek5p5055zFc=;
        b=fUV8PVZzxXo9l9Qsm942GaELrg4SfUQQO9EcIsUZpegf52gDDuo1S48W5pTxtxHc1V
         PBMPDdB+eEeqXbfXGkzvtIGAVZvJxcCQCTIsLRfyuE13NiZhowFjU1V/vbrNsnK7DJ0p
         Dd2JBvxdWf7z8gGLIWlNS2iMFpcmLHj80A7+i1Sm6ZTmHhO/n/cujhX1ybTiV/tBEqU7
         dCLrodcuLtrYBE73SKcSiu06fEzDgQeq+7oyY54y4rqr9B38ncq8TTw0MbIntfthRGdL
         YRX83qPKRu+PxlyHoil38hcbvsfhnIJOOBFs+yhd9YGQZ3utF6aTNDFPOYdha3kV4IkJ
         O3FQ==
X-Gm-Message-State: AOAM530gsGNE4+O36/nf8eky1ugmd54sgIPX4tbhvZFdcKeHt6Nytxfs
        Z0iE0rGbXCvH27sztNEAeEM=
X-Google-Smtp-Source: ABdhPJz08nUjKgyjIimH6B3dM63FJQb3tx+wH5dO6hzZxx8TOxoIMnV5J9kAxhmAS0wyUHT/MScHNQ==
X-Received: by 2002:a17:902:122:b029:e8:bde2:7f6c with SMTP id 31-20020a1709020122b02900e8bde27f6cmr511746plb.29.1619121969196;
        Thu, 22 Apr 2021 13:06:09 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id gc15sm5513291pjb.2.2021.04.22.13.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 13:06:08 -0700 (PDT)
Date:   Thu, 22 Apr 2021 23:05:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 5/9] net: dsa: microchip: add support for
 phylink management
Message-ID: <20210422200557.34lwobnmvhtba3wj@skbuf>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-6-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422094257.1641396-6-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 03:12:53PM +0530, Prasanna Vengateshan wrote:
> Support for phylink_validate() and reused KSZ commmon API for
> phylink_mac_link_down() operation
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  drivers/net/dsa/microchip/lan937x_main.c | 42 ++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index 944c6f4d6d60..93c392081423 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -312,6 +312,46 @@ static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
>  	return FR_MAX_SIZE;
>  }
>  
> +static void lan937x_phylink_validate(struct dsa_switch *ds, int port,
> +				     unsigned long *supported,
> +			  struct phylink_link_state *state)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	if (phy_interface_mode_is_rgmii(state->interface) ||
> +	    state->interface == PHY_INTERFACE_MODE_SGMII ||
> +		state->interface == PHY_INTERFACE_MODE_RMII ||
> +		state->interface == PHY_INTERFACE_MODE_MII ||
> +		lan937x_is_internal_100BTX_phy_port(dev, port)) {
> +		phylink_set(mask, 10baseT_Half);
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Half);
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, Autoneg);
> +		phylink_set_port_modes(mask);
> +		phylink_set(mask, Pause);
> +		phylink_set(mask, Asym_Pause);

Why do you advertise pause if you don't react to it (I commented on the
previous patch that you force flow control off)?

And the Microchip KSZ DSA phylink integration is the strangest I've ever
seen, bar none.

Do your RGMII ports work at 10/100/1000 Mbps? If yes, how?

Do your SGMII ports work in fixed-link, at 10/100/1000? How about with a
PHY that expects in-band autoneg?

> +	}
> +
> +	/*  For RGMII & SGMII interfaces */
> +	if (phy_interface_mode_is_rgmii(state->interface) ||
> +	    state->interface == PHY_INTERFACE_MODE_SGMII) {
> +		phylink_set(mask, 1000baseT_Full);
> +	}
> +
> +	/* For T1 PHY */
> +	if (lan937x_is_internal_t1_phy_port(dev, port)) {
> +		phylink_set(mask, 100baseT1_Full);
> +		phylink_set_port_modes(mask);
> +	}
> +
> +	bitmap_and(supported, supported, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +}
> +
>  static int	lan937x_port_pre_bridge_flags(struct dsa_switch *ds, int port,
>  					      struct switchdev_brport_flags flags,
>  					 struct netlink_ext_ack *extack)
> @@ -340,6 +380,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
>  	.port_fast_age		= ksz_port_fast_age,
>  	.port_max_mtu		= lan937x_get_max_mtu,
>  	.port_change_mtu	= lan937x_change_mtu,
> +	.phylink_validate	= lan937x_phylink_validate,
> +	.phylink_mac_link_down	= ksz_mac_link_down,
>  };
>  
>  int lan937x_switch_register(struct ksz_device *dev)
> -- 
> 2.27.0
> 

Fundamentally, what is the purpose of this patch?
