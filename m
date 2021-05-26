Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C391392294
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 00:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbhEZWOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 18:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhEZWOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 18:14:40 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD46C061574;
        Wed, 26 May 2021 15:13:07 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id j10so3333355edw.8;
        Wed, 26 May 2021 15:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R2jm1lfL3BDu/0kcu1MwjvVxVzlXq6FHF0naPljkBAw=;
        b=IE1D51aHXSoqmonLyTIFa5Al/8wgBo9g+v5V2jASMRB/hQAU+9qnbaTDTMeF5rSuSx
         9Dezjh6yak7QnMjrAQvDD50x5W/TBbGvmqEvgfO6Z2xm8g98OdfkTlvPpMei5knj7lxx
         LeZyOYEcN9kdutH9gmG6F0YWdHsivNtPRseZ2AZ43i5jBmOCcb+iYJvQ7HGfPJcKEuct
         X0UllqSq2d9f6q4pOnunPSsd62JXf4EBaSBR+qyaEFe4Y9GuG7L1khNmZuEvu45TmxYM
         M5J3kcHeLpx7KyEkXCsAp9KS+3AuvnCjNFa392SJSJdoMt3E1yF3sOQGqnHgiR7DALyP
         KpOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R2jm1lfL3BDu/0kcu1MwjvVxVzlXq6FHF0naPljkBAw=;
        b=LypZ4+Ixpt6Z132XswJ2KMvenrhqMMpx1JpI3jd/EfMRJcC36zFdSrj7T5hnPvXtIq
         ELRv2L/jSEYIc2z7yCngsZoZlXLC8PWsl1IAMlWnlcrub0KXjQYY4LBfD0Dl/CXEPLZn
         WAKqWpjvpnu9J1eqaOZ5NV1h+MEsxteLUjbaDRzQ+DoQLMOVg6aUzg3zuGmRgqq0A6Lq
         uV1VrT71+7rYPlTdXPQvQ1tMxUknsNOp7OLw/A4ZwMsRSlMADnFOnF+5r2KYQNZSmSw8
         1UQvBvsl4XXfXSW3m0gOoEYqFITOeON+G0Z6x4EE+HMzVvjdj1PB53hUlAauHDCSqolT
         dfDA==
X-Gm-Message-State: AOAM532so+ByNd8pvc7jnRpDxJBV5dBNMT+XKcJu1jGYNd5lkxtyivFQ
        cBRtNfQo8mbQkrPWwmf3jig=
X-Google-Smtp-Source: ABdhPJx3o5Y7U6GoGAEuWOqgtMbdhU89+ixWwouZ017/1wRYVxwB0GLXmOKxw0Zs8r/sAmVDQsITDQ==
X-Received: by 2002:a05:6402:4313:: with SMTP id m19mr386265edc.263.1622067186468;
        Wed, 26 May 2021 15:13:06 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id bm24sm82226edb.45.2021.05.26.15.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 15:13:06 -0700 (PDT)
Date:   Thu, 27 May 2021 01:13:04 +0300
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
Subject: Re: [PATCH net-next v3 2/9] net: dsa: microchip: ksz8795: add
 phylink support
Message-ID: <20210526221304.5njeoa7plhn2i2gn@skbuf>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526043037.9830-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 06:30:30AM +0200, Oleksij Rempel wrote:
> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> This patch adds the phylink support to the ksz8795 driver to provide
> configuration exceptions on quirky KSZ8863 and KSZ8873 ports.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz8795.c | 59 +++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index ba065003623f..cf81ae87544d 100644
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
> @@ -1420,11 +1421,69 @@ static int ksz8_setup(struct dsa_switch *ds)
>  	return 0;
>  }
>  
> +static void ksz8_validate(struct dsa_switch *ds, int port,
> +			  unsigned long *supported,
> +			  struct phylink_link_state *state)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +	struct ksz_device *dev = ds->priv;
> +
> +	if (port == dev->cpu_port) {
> +		if (state->interface != PHY_INTERFACE_MODE_RMII &&
> +		    state->interface != PHY_INTERFACE_MODE_MII &&
> +		    state->interface != PHY_INTERFACE_MODE_NA)
> +			goto unsupported;
> +	} else if (port > dev->port_cnt) {
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		dev_err(ds->dev, "Unsupported port: %i\n", port);
> +		return;

Is this possible or do we just like to invent things to check?
Unless I'm missing something, ksz8_switch_init() does:

	dev->ds->num_ports = dev->port_cnt;

and dsa_port_phylink_validate() does:

	ds->ops->phylink_validate(ds, dp->index, supported, state);

where dp->index is set to @port by dsa_port_touch() in this loop:

	for (port = 0; port < ds->num_ports; port++) {
		dp = dsa_port_touch(ds, port);
		if (!dp)
			return -ENOMEM;
	}

So, if 0 <= dp->index < ds->num_ports == dev->port_cnt, what is the point?

> +	} else {
> +		if (state->interface != PHY_INTERFACE_MODE_INTERNAL &&
> +		    state->interface != PHY_INTERFACE_MODE_NA)
> +			goto unsupported;
> +	}
> +
> +	/* Allow all the expected bits */
> +	phylink_set_port_modes(mask);
> +	phylink_set(mask, Autoneg);
> +
> +	/* Silicon Errata Sheet (DS80000830A):
> +	 * "Port 1 does not respond to received flow control PAUSE frames"
> +	 * So, disable Pause support on "Port 1" (port == 0) for all ksz88x3
> +	 * switches.
> +	 */
> +	if (!ksz_is_ksz88x3(dev) || port)
> +		phylink_set(mask, Pause);
> +
> +	/* Asym pause is not supported on KSZ8863 and KSZ8873 */
> +	if (!ksz_is_ksz88x3(dev))
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
> +	dev_err(ds->dev, "Unsupported interface: %s, port: %d\n",
> +		phy_modes(state->interface), port);
> +}
> +
>  static const struct dsa_switch_ops ksz8_switch_ops = {
>  	.get_tag_protocol	= ksz8_get_tag_protocol,
>  	.setup			= ksz8_setup,
>  	.phy_read		= ksz_phy_read16,
>  	.phy_write		= ksz_phy_write16,
> +	.phylink_validate	= ksz8_validate,
>  	.phylink_mac_link_down	= ksz_mac_link_down,
>  	.port_enable		= ksz_enable_port,
>  	.get_strings		= ksz8_get_strings,
> -- 
> 2.29.2
> 

