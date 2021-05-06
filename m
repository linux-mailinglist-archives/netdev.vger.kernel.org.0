Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C9B375373
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 14:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhEFMO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 08:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhEFMOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 08:14:23 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A261C061574;
        Thu,  6 May 2021 05:13:25 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a4so5371422wrr.2;
        Thu, 06 May 2021 05:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q9o9NzEH0HWRhRlgDnvHDI5Oua6Yl2Z2jXCoH/k+/6g=;
        b=okSdPb3Y/xc2NOLktn/wE3yhXjeKhVdzpRAtoPNCkC+6FnyF88PsnGdKWk6F6iTF5W
         9qyggk45YnkgvpPZxesHHGyAQ/1QvwLp30N5U2dABtiSc8EfQrQQcpRjKDzWbTet1ipf
         hCRYXxTPiGnkF5J3pYg4VG4tqF8Hm9NFuo5n+FJjXZ/4VIp5NITmkpFHsT++J7CrGcVW
         u1gwWwFPo4Kj5XWMrg3pmiC2jl3/9Jhc7CBx3RKnXmpa2NBElTcVrXcA3pzvzALltryc
         SoTPx4V2YUvWpmUL/t9OaG7YVoeHpOMnw7bZmsD/tVuDgww9Xk7VYZwncyEtTBbKxG5d
         FAJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q9o9NzEH0HWRhRlgDnvHDI5Oua6Yl2Z2jXCoH/k+/6g=;
        b=gH4GUArf7dZRVl3g0wbJX5XXGySLHC0MmuHLyArRAQE/4seBi1HMIIVUmzdILAUN1F
         90fH0D7I7GsSiP+FDM0rnsqt6W2MdJ4xaSWhHVM3cRSC0ZTCOTX9kAfFjyJMb9SR3DQK
         +qBLLsHliVj9Y5daf8YmKTgoeNfJj5V5/WpZQsKqhYFJx8u0s2REkeU/g322PvOwqYi8
         Js0T0FS/KMoa8tOUxPXpf9+dRp52MiFd+l03k0aRT51V9cp4SRaBm/AN+4nrRFue1Pxe
         tbGYQ2Yf8eqXAa0V3pij5/LtX6n5asRbkECoChNfAMfSBDnKA8XRmuqgvvJeu6YyJtnR
         3fOA==
X-Gm-Message-State: AOAM531DbWE6STnlaXQcRFP4/8aTe237KEWkgzcIz9VTtLeKp5Lx08F1
        Nv6/OuEyGZGy26qjeASfWho=
X-Google-Smtp-Source: ABdhPJwOcEb+5ATsbjQGxKZGN+dbZk3MpgybfUl/pQeRTRIuTOgwIiGMXfP9g3Ew+ANnkikVmmzkxQ==
X-Received: by 2002:a5d:5488:: with SMTP id h8mr4625679wrv.81.1620303203726;
        Thu, 06 May 2021 05:13:23 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id w22sm10168321wmc.13.2021.05.06.05.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 05:13:23 -0700 (PDT)
Date:   Thu, 6 May 2021 15:13:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH v1 2/9] net: dsa: microchip: ksz8795: add phylink
 support
Message-ID: <20210506121321.kny72yc5gx35pyms@skbuf>
References: <20210505092025.8785-1-o.rempel@pengutronix.de>
 <20210505092025.8785-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505092025.8785-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Wed, May 05, 2021 at 11:20:18AM +0200, Oleksij Rempel wrote:
> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> This patch adds the phylink support to the ksz8795 driver, since
> phylib is obsolete for dsa drivers.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz8795.c | 73 +++++++++++++++++++++++++++++
>  1 file changed, 73 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 4ca352fbe81c..0ddaf2547f18 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -18,6 +18,7 @@
>  #include <linux/micrel_phy.h>
>  #include <net/dsa.h>
>  #include <net/switchdev.h>
> +#include <linux/phylink.h>
>  
>  #include "ksz_common.h"
>  #include "ksz8795_reg.h"
> @@ -1420,11 +1421,83 @@ static int ksz8_setup(struct dsa_switch *ds)
>  	return 0;
>  }
>  
> +static int ksz_get_state(struct dsa_switch *ds, int port,
> +					  struct phylink_link_state *state)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz8 *ksz8 = dev->priv;
> +	const u8 *regs = ksz8->regs;
> +	u8 speed, link;
> +
> +	ksz_pread8(dev, port, regs[P_LINK_STATUS], &link);
> +	ksz_pread8(dev, port, regs[P_SPEED_STATUS], &speed);
> +
> +	state->link = !!(link & PORT_STAT_LINK_GOOD);
> +	if (state->link) {
> +		state->speed =
> +			(speed & PORT_STAT_SPEED_100MBIT) ? SPEED_100 : SPEED_10;
> +		state->duplex =
> +			(speed & PORT_STAT_FULL_DUPLEX) ? DUPLEX_FULL : DUPLEX_HALF;
> +	}
> +
> +	return 0;
> +}
> +
> +static void ksz_validate(struct dsa_switch *ds, int port,
> +			       unsigned long *supported,
> +			       struct phylink_link_state *state)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +	struct ksz_device *dev = ds->priv;
> +
> +	if (port == dev->cpu_port) {
> +		if ((state->interface != PHY_INTERFACE_MODE_RMII) &&
> +		   (state->interface != PHY_INTERFACE_MODE_MII))
> +			goto unsupported;
> +	} else if (port > dev->port_cnt) {
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		dev_err(ds->dev, "Unsupported port: %i\n", port);
> +		return;
> +	} else {
> +		if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
> +			goto unsupported;
> +	}
> +
> +	/* Allow all the expected bits */
> +	phylink_set_port_modes(mask);
> +	phylink_set(mask, Autoneg);
> +
> +	phylink_set(mask, Pause);
> +	/* Silicon Errata Sheet (DS80000830A): Asym_Pause limit to port 2 */
> +	if (port || !ksz_is_ksz88x3(dev))
> +		phylink_set(mask, Asym_Pause);
> +
> +	/* 10M and 100M are only supported */
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);
> +
> +	bitmap_and(supported, supported, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +
> +	return;
> +
> +unsupported:
> +	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	dev_err(ds->dev, "Unsupported interface: %d, port: %d\n",
> +		state->interface, port);
> +}
> +
>  static const struct dsa_switch_ops ksz8_switch_ops = {
>  	.get_tag_protocol	= ksz8_get_tag_protocol,
>  	.setup			= ksz8_setup,
>  	.phy_read		= ksz_phy_read16,
>  	.phy_write		= ksz_phy_write16,
> +	.phylink_validate	= ksz_validate,
> +	.phylink_mac_link_state	= ksz_get_state,
>  	.phylink_mac_link_down	= ksz_mac_link_down,
>  	.port_enable		= ksz_enable_port,
>  	.get_strings		= ksz8_get_strings,
> -- 
> 2.29.2
> 

I've asked Prasanna about this too, but for one reason or another I am
still not edified. Is this change a compliance thing, or do you actually
gain anything at all from phylink?
https://patchwork.kernel.org/project/netdevbpf/patch/20210422094257.1641396-6-prasanna.vengateshan@microchip.com/
What made you submit the patch?
