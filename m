Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D761392275
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 00:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbhEZWDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 18:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbhEZWDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 18:03:09 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05457C061574;
        Wed, 26 May 2021 15:01:36 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id c20so4837893ejm.3;
        Wed, 26 May 2021 15:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fd0E4dpZJC0IhjIKKgvDeaxi/o35axbNnti6ekz+C3g=;
        b=ggjM5PVipqpMgL+/+0B8/jAS6xD9+Jo8+BXE5iS3VVKpEPHtIKB3S8h5uoSB8Mf3jk
         YBgdazJa7xGt8LFm919m3TcKEq08uqCiETnT9kshQ3FrzYLO/sCw0jHBZZVuWC/wWuuW
         Uat3xDB0XVoxZ/tWLnuRsFqblfYqNNsUXzmDXFhra7KxLEwAayB78YiOabvJwk21N7oz
         v3B1365/fvO9gD+PQvrwUh2qdBNPLl1Sqk5+gS+TZ/iSSrhrPz1vYQMECbZx5nHc8ofS
         KHbC2doHGMjpxTEOOWpJVC+fJWMY5OURw7zJEBG2cHlMKo3J3VhyEpkOvKu2vfgA53KH
         pijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fd0E4dpZJC0IhjIKKgvDeaxi/o35axbNnti6ekz+C3g=;
        b=UFIKn9b8Fy5ZSllxMSH+uYsqGUlgGqcCd38c0vhDfpnqukBMMSUw+lEN+GUEdaVemv
         1d/4NIdyxDYY2gg9nZVV+JWjG9wzj9CtW8dcZP/kgtkqK+c8EAC4sUbRW+jE+i5rqZ3a
         S9QgcJ8fBJkckEQD8NGl5hCurhF7f9jJNP+sBUrKXLLwQ9uUdQrVz5hFAyloWTWmmbRV
         mTP1exPtm6k0usWmVhBHm+PkzhVAAXRHhybgZUFZ9SPRkSqV2CMiyywPTp+iFoACE02p
         EIp/Qcw3IKbVZbW/+/pb2BmY99PmvzorTEDn0RNKbaNwHNnEZgYq27TgV1KAS7NNHPqQ
         bvUw==
X-Gm-Message-State: AOAM530O6y/7Dv/LYalaUQ9tLsxmgqAcBEyVocCvYNopJn7+PqST9vgB
        JvPGFAFC9KP/pBGicmjGcaA=
X-Google-Smtp-Source: ABdhPJzsymHXOL28OkabAVbsgzsYcnE8LKwP/mDsGZUGfc4uOpA+BNynyCF6EHP4zR9Gjgw+5MqdBw==
X-Received: by 2002:a17:906:6009:: with SMTP id o9mr399705ejj.204.1622066494626;
        Wed, 26 May 2021 15:01:34 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id s26sm70783eds.73.2021.05.26.15.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 15:01:34 -0700 (PDT)
Date:   Thu, 27 May 2021 01:01:32 +0300
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
Subject: Re: [PATCH net-next v3 1/9] net: phy: micrel: move phy reg offsets
 to common header
Message-ID: <20210526220132.stfahc4mrwfiu6yn@skbuf>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526043037.9830-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 06:30:29AM +0200, Oleksij Rempel wrote:
> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> Some micrel devices share the same PHY register defines. This patch
> moves them to one common header so other drivers can reuse them.
> And reuse generic MII_* defines where possible.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz8795.c     | 119 ++++++++++++------------
>  drivers/net/dsa/microchip/ksz8795_reg.h |  62 ------------
>  drivers/net/ethernet/micrel/ksz884x.c   | 105 +++------------------
>  include/linux/micrel_phy.h              |  13 +++
>  4 files changed, 88 insertions(+), 211 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index ad509a57a945..ba065003623f 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -15,6 +15,7 @@
>  #include <linux/phy.h>
>  #include <linux/etherdevice.h>
>  #include <linux/if_bridge.h>
> +#include <linux/micrel_phy.h>
>  #include <net/dsa.h>
>  #include <net/switchdev.h>
>  
> @@ -731,88 +732,88 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
>  	u8 p = phy;
>  
>  	switch (reg) {
> -	case PHY_REG_CTRL:
> +	case MII_BMCR:
>  		ksz_pread8(dev, p, regs[P_NEG_RESTART_CTRL], &restart);
>  		ksz_pread8(dev, p, regs[P_SPEED_STATUS], &speed);
>  		ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
>  		if (restart & PORT_PHY_LOOPBACK)
> -			data |= PHY_LOOPBACK;
> +			data |= BMCR_LOOPBACK;
>  		if (ctrl & PORT_FORCE_100_MBIT)
> -			data |= PHY_SPEED_100MBIT;
> +			data |= BMCR_SPEED100;
>  		if (ksz_is_ksz88x3(dev)) {
>  			if ((ctrl & PORT_AUTO_NEG_ENABLE))
> -				data |= PHY_AUTO_NEG_ENABLE;
> +				data |= BMCR_ANENABLE;
>  		} else {
>  			if (!(ctrl & PORT_AUTO_NEG_DISABLE))
> -				data |= PHY_AUTO_NEG_ENABLE;
> +				data |= BMCR_ANENABLE;
>  		}
>  		if (restart & PORT_POWER_DOWN)
> -			data |= PHY_POWER_DOWN;
> +			data |= BMCR_PDOWN;
>  		if (restart & PORT_AUTO_NEG_RESTART)
> -			data |= PHY_AUTO_NEG_RESTART;
> +			data |= BMCR_ANRESTART;
>  		if (ctrl & PORT_FORCE_FULL_DUPLEX)
> -			data |= PHY_FULL_DUPLEX;
> +			data |= BMCR_FULLDPLX;
>  		if (speed & PORT_HP_MDIX)
> -			data |= PHY_HP_MDIX;
> +			data |= KSZ886X_BMCR_HP_MDIX;
>  		if (restart & PORT_FORCE_MDIX)
> -			data |= PHY_FORCE_MDIX;
> +			data |= KSZ886X_BMCR_FORCE_MDI;
>  		if (restart & PORT_AUTO_MDIX_DISABLE)
> -			data |= PHY_AUTO_MDIX_DISABLE;
> +			data |= KSZ886X_BMCR_DISABLE_AUTO_MDIX;
>  		if (restart & PORT_TX_DISABLE)
> -			data |= PHY_TRANSMIT_DISABLE;
> +			data |= KSZ886X_BMCR_DISABLE_TRANSMIT;
>  		if (restart & PORT_LED_OFF)
> -			data |= PHY_LED_DISABLE;
> +			data |= KSZ886X_BMCR_DISABLE_LED;
>  		break;

I am deeply confused as to what this function is doing. It is reading
the 8-bit port registers P_NEG_RESTART_CTRL, P_SPEED_STATUS and
P_FORCE_CTRL and stitching them into a 16-bit "MII_BMCR"?

What layout does this control register even have? Seeing as this is the
implementation of ksz_phy_read16(), I expect that MII_BMCR has the
layout specified in clause 22.2.4.1?

But clause 22 says register 0.5 is "Unidirectional enable", not
"PHY_HP_MDIX" (whatever that might be), and bits 0.4:0 are reserved and
must be written as zero and ignored on read.

> -	case PHY_REG_STATUS:
> +	case MII_BMSR:
>  		ksz_pread8(dev, p, regs[P_LINK_STATUS], &link);
> -		data = PHY_100BTX_FD_CAPABLE |
> -		       PHY_100BTX_CAPABLE |
> -		       PHY_10BT_FD_CAPABLE |
> -		       PHY_10BT_CAPABLE |
> -		       PHY_AUTO_NEG_CAPABLE;
> +		data = BMSR_100FULL |
> +		       BMSR_100HALF |
> +		       BMSR_10FULL |
> +		       BMSR_10HALF |
> +		       BMSR_ANEGCAPABLE;
>  		if (link & PORT_AUTO_NEG_COMPLETE)
> -			data |= PHY_AUTO_NEG_ACKNOWLEDGE;
> +			data |= BMSR_ANEGCOMPLETE;
>  		if (link & PORT_STAT_LINK_GOOD)
> -			data |= PHY_LINK_STATUS;
> +			data |= BMSR_LSTATUS;
>  		break;
> -	case PHY_REG_ID_1:
> +	case MII_PHYSID1:
>  		data = KSZ8795_ID_HI;
>  		break;
> -	case PHY_REG_ID_2:
> +	case MII_PHYSID2:
>  		if (ksz_is_ksz88x3(dev))
>  			data = KSZ8863_ID_LO;
>  		else
>  			data = KSZ8795_ID_LO;
>  		break;
> -	case PHY_REG_AUTO_NEGOTIATION:
> +	case MII_ADVERTISE:
>  		ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
> -		data = PHY_AUTO_NEG_802_3;
> +		data = ADVERTISE_CSMA;
>  		if (ctrl & PORT_AUTO_NEG_SYM_PAUSE)
> -			data |= PHY_AUTO_NEG_SYM_PAUSE;
> +			data |= ADVERTISE_PAUSE_CAP;
>  		if (ctrl & PORT_AUTO_NEG_100BTX_FD)
> -			data |= PHY_AUTO_NEG_100BTX_FD;
> +			data |= ADVERTISE_100FULL;
>  		if (ctrl & PORT_AUTO_NEG_100BTX)
> -			data |= PHY_AUTO_NEG_100BTX;
> +			data |= ADVERTISE_100HALF;
>  		if (ctrl & PORT_AUTO_NEG_10BT_FD)
> -			data |= PHY_AUTO_NEG_10BT_FD;
> +			data |= ADVERTISE_10FULL;
>  		if (ctrl & PORT_AUTO_NEG_10BT)
> -			data |= PHY_AUTO_NEG_10BT;
> +			data |= ADVERTISE_10HALF;
>  		break;
> -	case PHY_REG_REMOTE_CAPABILITY:
> +	case MII_LPA:
>  		ksz_pread8(dev, p, regs[P_REMOTE_STATUS], &link);
> -		data = PHY_AUTO_NEG_802_3;
> +		data = LPA_SLCT;
>  		if (link & PORT_REMOTE_SYM_PAUSE)
> -			data |= PHY_AUTO_NEG_SYM_PAUSE;
> +			data |= LPA_PAUSE_CAP;
>  		if (link & PORT_REMOTE_100BTX_FD)
> -			data |= PHY_AUTO_NEG_100BTX_FD;
> +			data |= LPA_100FULL;
>  		if (link & PORT_REMOTE_100BTX)
> -			data |= PHY_AUTO_NEG_100BTX;
> +			data |= LPA_100HALF;
>  		if (link & PORT_REMOTE_10BT_FD)
> -			data |= PHY_AUTO_NEG_10BT_FD;
> +			data |= LPA_10FULL;
>  		if (link & PORT_REMOTE_10BT)
> -			data |= PHY_AUTO_NEG_10BT;
> -		if (data & ~PHY_AUTO_NEG_802_3)
> -			data |= PHY_REMOTE_ACKNOWLEDGE_NOT;
> +			data |= LPA_10HALF;
> +		if (data & ~LPA_SLCT)
> +			data |= LPA_LPACK;
>  		break;
>  	default:
>  		processed = false;
