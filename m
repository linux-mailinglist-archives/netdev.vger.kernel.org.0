Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8059F3922DD
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 00:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhEZWpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 18:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbhEZWpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 18:45:06 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D21C061574;
        Wed, 26 May 2021 15:43:33 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gb17so4945758ejc.8;
        Wed, 26 May 2021 15:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MwRPB/VM+frBaYFa1eJH/kFwAVj7WGK7DRXENl2xvIE=;
        b=k1UakxAGnblNS+0o4x/+AeiuAV3jTtNAAESXkueto3MTUvKuQLS/SxpzSz3SJmUfHs
         70k70XDJtpWhRKDD/2ya36ygOLW3Cy9HZkGumI5xDLQ/VYOLgGGA40IXPz+JcgVvQnVh
         HMPutfnT0EKFIKQisJGmNDnni/KfNokrY/8rH2OWYuHlS54bdibFHzJO3vWfQ+dtwzhz
         5b3pRD4lxPPTJtIemuutfGIz4oQ9jcwAnG26KHCk3CE2KuP0bw7CNzEYlyiXsDLtPJ0I
         ui4lX4U1Ecy/NtsqUP5ZQ6wIPYmAt2ZD9ltm+TFGTcQ15aC/CqBLd5jG3j2IPndKOjoG
         SQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MwRPB/VM+frBaYFa1eJH/kFwAVj7WGK7DRXENl2xvIE=;
        b=GtnV53rmjMgek+B/FBfs67aaQ+nfyl1AcnLskYntVrnDNpn8pvrwyY7bU9FqBeibSM
         zkT/p2JAnJXZceI56Nc/FIu4ZE447iB7oCGIWXsN1JJZiGp8k2cn+Qu+a2aTeqOqjaax
         2Q2s6D7QiCWAlGSArB3eYr624EmX+5DWkyf2wrruvSqz7KEDGBCmBk4eWlPqFGsSXQfV
         XBY4rCUxhLYaqgl3EydMUshUjGwEGI3dVtfUVnjtbC5fwYka8Q7RRLX/lk0RvelAF8U9
         qNP3QOazEsDn5Yp5SFYiS6cNpxMMNzjfT/9ufqNECApcURWTvxMlGJrHBpIeIE4nugCd
         sq5A==
X-Gm-Message-State: AOAM5305VrIuGSEG701M7rdfXXAees3R+ZwoSIRdR3Y8+ApcoU8kh3rn
        bYfVA7vN9VBdhWWCG9hy7gk=
X-Google-Smtp-Source: ABdhPJzfgv17rFF09ImjZ0+lmzhc7paYRwXS6NnsKDS736b1JPomOCCCIu8n6tCJ4jg5FAcOfKDjsw==
X-Received: by 2002:a17:907:961e:: with SMTP id gb30mr608278ejc.58.1622069010835;
        Wed, 26 May 2021 15:43:30 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id u6sm171511ejr.55.2021.05.26.15.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 15:43:30 -0700 (PDT)
Date:   Thu, 27 May 2021 01:43:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v3 4/9] net: phy: micrel: apply resume errata
 workaround for ksz8873 and ksz8863
Message-ID: <20210526224329.raaxr6b2s2uid4dw@skbuf>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526043037.9830-5-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 06:30:32AM +0200, Oleksij Rempel wrote:
> The ksz8873 and ksz8863 switches are affected by following errata:
> 
> | "Receiver error in 100BASE-TX mode following Soft Power Down"
> |
> | Some KSZ8873 devices may exhibit receiver errors after transitioning
> | from Soft Power Down mode to Normal mode, as controlled by register 195
> | (0xC3) bits [1:0]. When exiting Soft Power Down mode, the receiver
> | blocks may not start up properly, causing the PHY to miss data and
> | exhibit erratic behavior. The problem may appear on either port 1 or
> | port 2, or both ports. The problem occurs only for 100BASE-TX, not
> | 10BASE-T.
> |
> | END USER IMPLICATIONS
> | When the failure occurs, the following symptoms are seen on the affected
> | port(s):
> | - The port is able to link
> | - LED0 blinks, even when there is no traffic
> | - The MIB counters indicate receive errors (Rx Fragments, Rx Symbol
> |   Errors, Rx CRC Errors, Rx Alignment Errors)
> | - Only a small fraction of packets is correctly received and forwarded
> |   through the switch. Most packets are dropped due to receive errors.
> |
> | The failing condition cannot be corrected by the following:
> | - Removing and reconnecting the cable
> | - Hardware reset
> | - Software Reset and PCS Reset bits in register 67 (0x43)
> |
> | Work around:
> | The problem can be corrected by setting and then clearing the Port Power
> | Down bits (registers 29 (0x1D) and 45 (0x2D), bit 3). This must be done
> | separately for each affected port after returning from Soft Power Down
> | Mode to Normal Mode. The following procedure will ensure no further
> | issues due to this erratum. To enter Soft Power Down Mode, set register
> | 195 (0xC3), bits [1:0] = 10.
> |
> | To exit Soft Power Down Mode, follow these steps:
> | 1. Set register 195 (0xC3), bits [1:0] = 00 // Exit soft power down mode
> | 2. Wait 1ms minimum
> | 3. Set register 29 (0x1D), bit [3] = 1 // Enter PHY port 1 power down mode
> | 4. Set register 29 (0x1D), bit [3] = 0 // Exit PHY port 1 power down mode
> | 5. Set register 45 (0x2D), bit [3] = 1 // Enter PHY port 2 power down mode
> | 6. Set register 45 (0x2D), bit [3] = 0 // Exit PHY port 2 power down mode
> 
> This patch implements steps 2...6 of the suggested workaround. The first
> step needs to be implemented in the switch driver.

Am I right in understanding that register 195 (0xc3) is not a port register?

To hit the erratum, you have to enter Soft Power Down in the first place,
presumably by writing register 0xc3 from somewhere, right?

Where does Linux write this register from?

Once we find that place that enters/exits Soft Power Down mode, can't we
just toggle the Port Power Down bits for each port, exactly like the ERR
workaround says, instead of fooling around with a PHY driver?

> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/micrel.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 227d88db7d27..f03188ed953a 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1048,6 +1048,26 @@ static int ksz8873mll_config_aneg(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int ksz886x_resume(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	/* Apply errata workaround for KSZ8863 and KSZ8873:
> +	 * Receiver error in 100BASE-TX mode following Soft Power Down
> +	 *
> +	 * When exiting Soft Power Down mode, the receiver blocks may not start
> +	 * up properly, causing the PHY to miss data and exhibit erratic
> +	 * behavior.
> +	 */
> +	usleep_range(1000, 2000);
> +
> +	ret = phy_set_bits(phydev, MII_BMCR, BMCR_PDOWN);
> +	if (ret)
> +		return ret;
> +
> +	return phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);
> +}
> +
>  static int kszphy_get_sset_count(struct phy_device *phydev)
>  {
>  	return ARRAY_SIZE(kszphy_hw_stats);
> @@ -1401,7 +1421,7 @@ static struct phy_driver ksphy_driver[] = {
>  	/* PHY_BASIC_FEATURES */
>  	.config_init	= kszphy_config_init,
>  	.suspend	= genphy_suspend,
> -	.resume		= genphy_resume,
> +	.resume		= ksz886x_resume,

Are you able to explain the relation between the call paths of
phy_resume() and the lifetime of the Soft Power Down setting of the
switch? How do we know that the PHYs are resumed after the switch has
exited Soft Power Down mode?

>  }, {
>  	.name		= "Micrel KSZ87XX Switch",
>  	/* PHY_BASIC_FEATURES */
> -- 
> 2.29.2
> 
