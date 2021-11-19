Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52346456724
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 01:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhKSBBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhKSBB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:01:29 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3BCC061574;
        Thu, 18 Nov 2021 16:58:28 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w1so35176618edc.6;
        Thu, 18 Nov 2021 16:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mSqcJbaYAFA7vrNk0Axws3hCvBSWHqi0Rr0Z9Q1FoSQ=;
        b=AkD67amu9zWoOCfcgczw33j+DQa8AVKgHnjpzHLxp/6f92NnlBkYAlmWp+83m2BuIN
         Mvx25ChncjeMOlKFdCfBcOuRv4avzd17th1f+3Jvj5upNwUqicUOo+s7O+2f2wB/Bq11
         QDx+McZ7tBbMM4sn296XP6UC2h1Jlf8UYQuWkzpumwcxGl+Lccj6PEXCwfdfLkwNlGRq
         JSodH+t/ecFzf4gHs2aYUVjxVDQ1Tz9iMUNhwNGyX0Jbj9EZw2YAkgYHEVT7lC7LWCaL
         6BUR3bBQkh8JMqB5lz1ZmO1JjQCOz9B2STrE5w/6pDo3RnjqnJzDpDqlbI3SeTMDKqIy
         ibcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mSqcJbaYAFA7vrNk0Axws3hCvBSWHqi0Rr0Z9Q1FoSQ=;
        b=UeqRCxY9XSst6n3ilHSUAiFXanNqavUOIdCVrcslw7vfhy2N2rHlArU9t+BHWG1+38
         1xm448AXYX7P/L9rjVN4fii1oLRjantdiR6aP3b3owqtjWJcNFkjZ4XFVSGZoJv2r7H+
         TMf7ByO5wcbqu6HkN7L5w/UJslDFvgRK794mRpxrOH8kDeula9zSE+1INuoBCEbY40kn
         Bthli+35zz7QbjQFJ5X4XJidSAya83os7v7oi525UPrwOwt4w7D+xsQYFrsWM2/oPz0i
         quQUq9fr0HDznaDj7+sIqkVHdQHUyxfYT0g97hdOGACDFx2DiSvLIdcyj8zjtlYgbI6L
         Fwcw==
X-Gm-Message-State: AOAM533Qs7OEp87mZaUb99+QvIa0xOVzKwCbt86jJ/sB5PD0+GDplQtb
        s8su37iPCD5sV6BpIrIP4NQ=
X-Google-Smtp-Source: ABdhPJxo67+OzNAj8qpz572vVVACkgeo+Qe5Alw39BLCobKOdzQDqZbgadRqHvqOqZYhTOSMIjSxXw==
X-Received: by 2002:a17:906:2e97:: with SMTP id o23mr2157010eji.541.1637283507499;
        Thu, 18 Nov 2021 16:58:27 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id u23sm699437edi.88.2021.11.18.16.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 16:58:27 -0800 (PST)
Date:   Fri, 19 Nov 2021 02:58:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 03/19] net: dsa: qca8k: skip sgmii delay on
 double cpu conf
Message-ID: <20211119005826.omgn7pj3cx3lwwr7@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-4-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:35PM +0100, Ansuel Smith wrote:
> With a dual cpu configuration rgmii+sgmii, skip configuring sgmii delay
> as it does cause no traffic. Configure only rgmii delay in this
> specific configuration.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

I feel that you owe a serious explanation about this SGMII delay
business, it's getting stranger and stranger. I chalked it up to the
fact that maybe QCA8334 has a strange SGMII implementation, where the
clock it is source-synchronous, as opposed to the data lanes themselves
being self-clocking. But the fact is, I don't really know, I never was
sure, never got an explanation, and now I am even less sure. And now
that I look in the datasheet for the pinout, I see a regular pair of
pins (SOP, SON) for the TX differential pair, and a regular pair of pins
(SIP, SIN) for the RX differential pair. No pin for any source
synchronous clock. So where is this SGMII_CLK125M clock localized, and
if it's inside the switch, and why do you need to configure its sampling
edge and delay, what is different between one board and another?

The RGMII and the SGMII CPU ports are different physical ports, are they not?
Why would the configuration of one affect the other? Do they share any
physical resource?

>  drivers/net/dsa/qca8k.c | 12 ++++++++++--
>  drivers/net/dsa/qca8k.h |  1 +
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index bfffc1fb7016..ace465c878f8 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1041,8 +1041,13 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
>  			if (mode == PHY_INTERFACE_MODE_RGMII ||
>  			    mode == PHY_INTERFACE_MODE_RGMII_ID ||
>  			    mode == PHY_INTERFACE_MODE_RGMII_TXID ||
> -			    mode == PHY_INTERFACE_MODE_RGMII_RXID)
> +			    mode == PHY_INTERFACE_MODE_RGMII_RXID) {
> +				if (priv->ports_config.rgmii_tx_delay[cpu_port_index] ||
> +				    priv->ports_config.rgmii_rx_delay[cpu_port_index])
> +					priv->ports_config.skip_sgmii_delay = true;
> +
>  				break;
> +			}
>  
>  			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
>  				priv->ports_config.sgmii_tx_clk_falling_edge = true;
> @@ -1457,8 +1462,11 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  
>  		/* From original code is reported port instability as SGMII also
>  		 * require delay set. Apply advised values here or take them from DT.
> +		 * In dual CPU configuration, apply only delay to rgmii as applying
> +		 * it also to the SGMII line cause no traffic to the entire switch.
>  		 */
> -		if (state->interface == PHY_INTERFACE_MODE_SGMII)
> +		if (state->interface == PHY_INTERFACE_MODE_SGMII &&
> +		    !priv->ports_config.skip_sgmii_delay)

I thought that the deal was that with the new "tx-internal-delay-ps" and
"rx-internal-delay-ps" properties, you would not enable any delays by
default in their absence. So if system is broken by the fact that delays
are applied on the SGMII port when they shouldn't have, the issue is in
the device tree and the fix is also there. This "skip_sgmii_delay" logic
on the other hand is fixing up the default delays that get applied in
lack of device tree properties.

>  			qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
>  
>  		break;
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 128b8cf85e08..57c4c0d93558 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -275,6 +275,7 @@ struct qca8k_ports_config {
>  	bool sgmii_rx_clk_falling_edge;
>  	bool sgmii_tx_clk_falling_edge;
>  	bool sgmii_enable_pll;
> +	bool skip_sgmii_delay;
>  	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
>  	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
>  };
> -- 
> 2.32.0
> 

