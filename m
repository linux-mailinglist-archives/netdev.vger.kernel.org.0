Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9802333C8CC
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhCOVty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbhCOVts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:49:48 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925E3C06174A;
        Mon, 15 Mar 2021 14:49:47 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id r17so68795505ejy.13;
        Mon, 15 Mar 2021 14:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bdRYAsY27cE7OZ7dSGJejE/DzZtoI51iMsrMQPUfTHs=;
        b=Rl8EKpVAjhcwLsFNpQe6ZNrNBOFz3BOLjHLt1QTDZktP77CGB/WiRIb/XTjPvBzQZn
         dkWVA7jt3Epf9LWVORtvGq9v4OuHOwHJjuxGRFHMx62H0GkEQRgtpDsW4ElWuQEiNa/r
         u9Ay/sBmKIToeSoIRsQyFWiFplAMqU89DRPU2bU9bgmSt7p+C+WR7gCe229Mz3YrQVoF
         SuP+pj1jwhVpsPqAzpwN+Gp8kGFw1yCC3aSGTcmb+uT35XMEsq5qRhIfQAeZbFhCNCFC
         pFMS/Hb6/Sw9LugiXZzg8lvlmsXhWuJMnX9z9bqxJNbN0a77YHGRaV5D5LijGwTNgb/K
         aLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bdRYAsY27cE7OZ7dSGJejE/DzZtoI51iMsrMQPUfTHs=;
        b=NssP4KAYZTfcTrOH3heJ/q7a1VbJiFNwz/gFqHboC+uB5Z2meLOJ2k0QdQZdKLJ1ms
         f3EqfJXeg1EEWAHTQgf3LFJmhJ/w0FD2kMRaEZXVhF6EchZ97fV2eqzKN2jlA97UrS8h
         w1oxEVnuXsXr+XWHy2oa3d/cwY4SaHopy9BeNINSeN+Tse76Wsc5vU7kWhI/zuexy4MS
         F36v70dfKzoc+JMQ1lhmPKK031AXGcNdJv5F98O7dlhjxFBFs4/00X6/yOQ8qTw/6kPk
         jhk8Zhf/aZChukpu1s6DYehlqOlHdr0jn260xrqeVE2JbkqtEryNOdjgz/xpmGB7fz9Q
         LRqA==
X-Gm-Message-State: AOAM531N+26p8afDboXhXRCj/9iHjc3tMr1ZRfqmuhwWG+JeeLZzXCk2
        r8OTe7EuVHCOPsbL2KHTCyw=
X-Google-Smtp-Source: ABdhPJxEM61Wq2O8s7PxaC0HxLoMWZZq/L0qg0WRRCFCiyMx46sxM9J7JLzxZzMMwd8U79fOCp7WVw==
X-Received: by 2002:a17:907:2642:: with SMTP id ar2mr26035072ejc.145.1615844986388;
        Mon, 15 Mar 2021 14:49:46 -0700 (PDT)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id rs24sm8126249ejb.75.2021.03.15.14.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:49:46 -0700 (PDT)
Date:   Mon, 15 Mar 2021 23:49:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     LGA1150 <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH net-next] net: dsa: rtl8366rb: support bridge offloading
Message-ID: <20210315214944.vom3v75sy7qqmiu4@skbuf>
References: <20210315170144.2081099-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315170144.2081099-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 01:01:44AM +0800, LGA1150 wrote:
> From: DENG Qingfang <dqfext@gmail.com>
> 
> Use port isolation registers to configure bridge offloading.
> Remove the VLAN init, as we have proper CPU tag and bridge offloading
> support now.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> Changes since RFC:
>   Fix build error
> 
>  drivers/net/dsa/rtl8366rb.c | 71 +++++++++++++++++++++++++++++++++----
>  1 file changed, 65 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index a89093bc6c6a..bbcfdd84f0e9 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -300,6 +300,12 @@
>  #define RTL8366RB_INTERRUPT_STATUS_REG	0x0442
>  #define RTL8366RB_NUM_INTERRUPT		14 /* 0..13 */
>  
> +/* Port isolation registers */
> +#define RTL8366RB_PORT_ISO_BASE		0x0F08
> +#define RTL8366RB_PORT_ISO(pnum)	(RTL8366RB_PORT_ISO_BASE + (pnum))
> +#define RTL8366RB_PORT_ISO_EN		BIT(0)
> +#define RTL8366RB_PORT_ISO_PORTS_MASK	GENMASK(7, 1)
> +
>  /* bits 0..5 enable force when cleared */
>  #define RTL8366RB_MAC_FORCE_CTRL_REG	0x0F11
>  
> @@ -835,6 +841,15 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> +	/* Isolate user ports */
> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> +		ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
> +				   RTL8366RB_PORT_ISO_EN |
> +				   BIT(RTL8366RB_PORT_NUM_CPU + 1));

You have a RTL8366RB_PORT_ISO_PORTS_MASK that you don't use, and you
open-code a +1 here and everywhere below. Wouldn't it be more useful to
have a macro for RTL8366RB_PORT_ISO_PORTS(mask)?

> +		if (ret)
> +			return ret;
> +	}
> +
>  	/* Set up the "green ethernet" feature */
>  	ret = rtl8366rb_jam_table(rtl8366rb_green_jam,
>  				  ARRAY_SIZE(rtl8366rb_green_jam), smi, false);
> @@ -963,10 +978,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>  			return ret;
>  	}
>  
> -	ret = rtl8366_init_vlan(smi);
> -	if (ret)
> -		return ret;
> -

You can actually delete rtl8366_init_vlan now, it is unused.

>  	ret = rtl8366rb_setup_cascaded_irq(smi);
>  	if (ret)
>  		dev_info(smi->dev, "no interrupt support\n");
> @@ -977,8 +988,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>  		return -ENODEV;
>  	}
>  
> -	ds->configure_vlan_while_not_filtering = false;
> -
>  	return 0;
>  }
>  
> @@ -1127,6 +1136,54 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
>  	rb8366rb_set_port_led(smi, port, false);
>  }
>  
> +static int
> +rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
> +			   struct net_device *bridge)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	unsigned int port_bitmap = 0;
> +	int ret, i;
> +
> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {

Could you use ds->num_ports please?

> +		if (i == port)
> +			continue;
> +		if (dsa_to_port(ds, i)->bridge_dev != bridge)
> +			continue;
> +		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
> +					 0, BIT(port + 1));

You call regmap_update_bits with a mask of 0? What does it mean?
This is tested, right?

> +		if (ret)
> +			return ret;
> +
> +		port_bitmap |= BIT(i);
> +	}
> +
> +	return regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
> +				  0, port_bitmap << 1);
> +}
> +
> +static void
> +rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
> +			    struct net_device *bridge)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	unsigned int port_bitmap = 0;
> +	int i;
> +
> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> +		if (i == port)
> +			continue;
> +		if (dsa_to_port(ds, i)->bridge_dev != bridge)
> +			continue;
> +		regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
> +				   BIT(port + 1), 0);
> +
> +		port_bitmap |= BIT(i);
> +	}
> +
> +	regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
> +			   port_bitmap << 1, 0);
> +}
> +
