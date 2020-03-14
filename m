Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064501856B5
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgCOB3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:29:20 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgCOB3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ACGAoZhw+ANkGVhoWbrdmavkSgI2xOQJI8fAWxfbhV8=; b=N0iBHPDTH5oSWmuqL8NT8P5UF
        PnTyL8M+ECHath7WdMFB7pN86AM8LRXZHgcX/gWCc1Ds7LRwZB8xl0LmDOQikaVPh+7Z9vpXtSEDV
        HlDNFfuEJlREX3RqKGAT6k9s3t/wwunW/lmf274cMRIgivA+lBA1POLwEO/L7XBivlrofO1BV7XSB
        CDu5vg+tn8SJBBnIlUS2Lo6BTekYjK0fvfKgf1Rs1cOUkRU99HcJ9WdS+53COiELHIFrPE2OiLf/R
        5q/L9YM0kqYqyhnzjYcUHPFc57bVYoT8GV7xUNi0tdtDX9ljCJmURolj0yGqNy30Bxd1qWBym2k9X
        BiOvdzizg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60390)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jD42h-0006Kr-EB; Sat, 14 Mar 2020 10:29:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jD42g-0008Eh-UI; Sat, 14 Mar 2020 10:29:18 +0000
Date:   Sat, 14 Mar 2020 10:29:18 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: phylink: rename 'ops' to 'mac_ops'
Message-ID: <20200314102918.GH25745@shell.armlinux.org.uk>
References: <20200314102721.GG25745@shell.armlinux.org.uk>
 <E1jD41p-0006KE-Ie@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jD41p-0006KE-Ie@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel development is hard... neither this patch nor the following one
is supposed to be part of this series.

On Sat, Mar 14, 2020 at 10:28:25AM +0000, Russell King wrote:
> Rename the bland 'ops' member of struct phylink to be a more
> descriptive 'mac_ops' - this is necessary as we're about to introduce
> another set of operations.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index bff570f59d5c..805fec9f1c3f 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -40,7 +40,7 @@ enum {
>  struct phylink {
>  	/* private: */
>  	struct net_device *netdev;
> -	const struct phylink_mac_ops *ops;
> +	const struct phylink_mac_ops *mac_ops;
>  	struct phylink_config *config;
>  	struct device *dev;
>  	unsigned int old_link_state:1;
> @@ -154,7 +154,7 @@ static const char *phylink_an_mode_str(unsigned int mode)
>  static int phylink_validate(struct phylink *pl, unsigned long *supported,
>  			    struct phylink_link_state *state)
>  {
> -	pl->ops->validate(pl->config, supported, state);
> +	pl->mac_ops->validate(pl->config, supported, state);
>  
>  	return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
>  }
> @@ -388,7 +388,7 @@ static void phylink_mac_config(struct phylink *pl,
>  		    __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
>  		    state->pause, state->link, state->an_enabled);
>  
> -	pl->ops->mac_config(pl->config, pl->cur_link_an_mode, state);
> +	pl->mac_ops->mac_config(pl->config, pl->cur_link_an_mode, state);
>  }
>  
>  static void phylink_mac_config_up(struct phylink *pl,
> @@ -402,7 +402,7 @@ static void phylink_mac_an_restart(struct phylink *pl)
>  {
>  	if (pl->link_config.an_enabled &&
>  	    phy_interface_mode_is_8023z(pl->link_config.interface))
> -		pl->ops->mac_an_restart(pl->config);
> +		pl->mac_ops->mac_an_restart(pl->config);
>  }
>  
>  static void phylink_mac_pcs_get_state(struct phylink *pl,
> @@ -418,7 +418,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
>  	state->an_complete = 0;
>  	state->link = 1;
>  
> -	pl->ops->mac_pcs_get_state(pl->config, state);
> +	pl->mac_ops->mac_pcs_get_state(pl->config, state);
>  }
>  
>  /* The fixed state is... fixed except for the link state,
> @@ -485,11 +485,11 @@ static void phylink_mac_link_up(struct phylink *pl,
>  	struct net_device *ndev = pl->netdev;
>  
>  	pl->cur_interface = link_state.interface;
> -	pl->ops->mac_link_up(pl->config, pl->phydev,
> -			     pl->cur_link_an_mode, pl->cur_interface,
> -			     link_state.speed, link_state.duplex,
> -			     !!(link_state.pause & MLO_PAUSE_TX),
> -			     !!(link_state.pause & MLO_PAUSE_RX));
> +	pl->mac_ops->mac_link_up(pl->config, pl->phydev,
> +				 pl->cur_link_an_mode, pl->cur_interface,
> +				 link_state.speed, link_state.duplex,
> +				 !!(link_state.pause & MLO_PAUSE_TX),
> +				 !!(link_state.pause & MLO_PAUSE_RX));
>  
>  	if (ndev)
>  		netif_carrier_on(ndev);
> @@ -507,8 +507,8 @@ static void phylink_mac_link_down(struct phylink *pl)
>  
>  	if (ndev)
>  		netif_carrier_off(ndev);
> -	pl->ops->mac_link_down(pl->config, pl->cur_link_an_mode,
> -			       pl->cur_interface);
> +	pl->mac_ops->mac_link_down(pl->config, pl->cur_link_an_mode,
> +				   pl->cur_interface);
>  	phylink_info(pl, "Link is Down\n");
>  }
>  
> @@ -639,7 +639,7 @@ static int phylink_register_sfp(struct phylink *pl,
>   * @fwnode: a pointer to a &struct fwnode_handle describing the network
>   *	interface
>   * @iface: the desired link mode defined by &typedef phy_interface_t
> - * @ops: a pointer to a &struct phylink_mac_ops for the MAC.
> + * @mac_ops: a pointer to a &struct phylink_mac_ops for the MAC.
>   *
>   * Create a new phylink instance, and parse the link parameters found in @np.
>   * This will parse in-band modes, fixed-link or SFP configuration.
> @@ -652,7 +652,7 @@ static int phylink_register_sfp(struct phylink *pl,
>  struct phylink *phylink_create(struct phylink_config *config,
>  			       struct fwnode_handle *fwnode,
>  			       phy_interface_t iface,
> -			       const struct phylink_mac_ops *ops)
> +			       const struct phylink_mac_ops *mac_ops)
>  {
>  	struct phylink *pl;
>  	int ret;
> @@ -685,7 +685,7 @@ struct phylink *phylink_create(struct phylink_config *config,
>  	pl->link_config.speed = SPEED_UNKNOWN;
>  	pl->link_config.duplex = DUPLEX_UNKNOWN;
>  	pl->link_config.an_enabled = true;
> -	pl->ops = ops;
> +	pl->mac_ops = mac_ops;
>  	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
>  	timer_setup(&pl->link_poll, phylink_fixed_poll, 0);
>  
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
