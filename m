Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ADD3754B6
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 15:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbhEFN37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 09:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbhEFN36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 09:29:58 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31524C061574;
        Thu,  6 May 2021 06:28:59 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id n25so6169435edr.5;
        Thu, 06 May 2021 06:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=74ChUD6HJI2TgnSM1puxxANbsX8ma3NOUnlM3YinyR8=;
        b=Eh4RBQtC966Kt5QtohrxxO8Rr/Vk1dv/q+Lb92zus6SDOx9JcMM9pcYCIMdkg81tEX
         S0NnAa+awCKNyrEnesK/YdImQc/bGdrLkXcVx4gp5ns40bK3KT47jLRtFZSqq7h3Fv3y
         tJd88Pxfjm1C5ymwefuX/mnTjAhWgncF0p+IAM2RzvEsRcdyaupWyK3ZKjgvH+n/QVCv
         poVin0P8cXogG8cvW/c+c5Lv1qDjdjEbF8qUwkAU4dIwImUKyYXn05ULwc3k8z9hxtKn
         8zdnQz2cS8Ru2trooZFTMWVLPdUrAR6GMPT7vujHAJ0rAb4lu66Z0ZBGfEreewYfCsGp
         IFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=74ChUD6HJI2TgnSM1puxxANbsX8ma3NOUnlM3YinyR8=;
        b=Vhew5tm+uRRmfjP+t3u1tVI5zmel7BdK56yoUxs8VB2KNQdtHPzm0Kelqa45aW0ZJD
         x6il6KUlNmqsHhQzmz682/VOPQxeQtIz9HsK2gCaeybfK8CR9/5B58K+jA1sd/Y4cbaf
         mKYWSqbKmuH39/82kezdnJi0CLUXyOeISsOtRSmrjzorQFWGD90PAfGk3x1yUrCvDuWy
         nNsbsv68O1eZ8KIiIcK2bGtsKTN4nVyx/TvPrmohpiATnKDs3we3e548KFrSe0j94vtI
         tTjuwu7ad3qUHhaSyhOkJPUXgx8XaPei+KR6Aq1M6qT2jjLWpYZKUZMtdDS3uDC5q4/a
         oivA==
X-Gm-Message-State: AOAM531NlpzO3BFU1f0jwwfBuRyxve/jfUGG7qOl2Bqrl4YYxVoHjIeC
        hFwpcTK5x0HAuVZzXZDoERw=
X-Google-Smtp-Source: ABdhPJwz8rAe4+5lZwGX4TiKruxjBFOoHONsfQNIOmhV/WobnJVOFdn3ySJuNp7KYfqusR+iaInwvw==
X-Received: by 2002:a05:6402:12c6:: with SMTP id k6mr5158693edx.372.1620307737886;
        Thu, 06 May 2021 06:28:57 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id l11sm1610608eds.75.2021.05.06.06.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:28:57 -0700 (PDT)
Date:   Thu, 6 May 2021 16:28:55 +0300
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
Message-ID: <20210506132855.fv4dqagjg3zfue3i@skbuf>
References: <20210505092025.8785-1-o.rempel@pengutronix.de>
 <20210505092025.8785-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505092025.8785-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

How does the port know the speed?

> +
> +static void ksz_validate(struct dsa_switch *ds, int port,
> +			       unsigned long *supported,
> +			       struct phylink_link_state *state)

Indentation looks odd.
Also, I expect that not all KSZ PHYs to have the same validation
function, so maybe you should call this ksz8_phylink_validate.

> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +	struct ksz_device *dev = ds->priv;
> +
> +	if (port == dev->cpu_port) {
> +		if ((state->interface != PHY_INTERFACE_MODE_RMII) &&
> +		   (state->interface != PHY_INTERFACE_MODE_MII))
> +			goto unsupported;

The phylink API says that when .validate is called with state->interface
as PHY_INTERFACE_MODE_NA, you should report all supported capabilities.

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

The code doesn't seem to match the comment? If the switch is a KSZ88x3,
ASM_DIR will be advertised for all ports except port 0, is this what you
want?

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

%s, phy_modes(state->interface)

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

