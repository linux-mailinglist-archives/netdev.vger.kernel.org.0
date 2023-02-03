Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1558B68A703
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 00:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbjBCXrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 18:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBCXrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 18:47:47 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F91E402E7;
        Fri,  3 Feb 2023 15:47:46 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ud5so19666380ejc.4;
        Fri, 03 Feb 2023 15:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i6X9/xwkqgn5Kw5ShiY1ZePu7cbFs8mDmKUIHpAN6K8=;
        b=b6z9ByepgKFuDzxG6RbGs1uZ2kwZfU0US2oNDMn7HU5Z+ahUSGba/4a4nWuEAtyZje
         JDDHReAjqndo2RGdH47k3uQOKudDLlix4dW6VyMvX2guCAKc3cqxIOleWedH/tF8jXak
         5yMjIBHs6H45s8dWbg8ZkfNQimji2qN2R9WrmtJc17ESpH9uYCi4HNdaAgHVFygnliZh
         +24k3zlXRGZPAEGmn2hthAmHjATV9Tw2E9OoIYBXOnozXT2daaXwCi9OijyTqEaBYDHW
         636gBiZKS59apNYGl1xJ85q9CPKMzM6szc9SAzOaovPz8cQ8VwCh6yRZ1O8UbcBaLDA3
         MWpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6X9/xwkqgn5Kw5ShiY1ZePu7cbFs8mDmKUIHpAN6K8=;
        b=z8ys/JxxybBdkt0W0Mdf5Me9NXNWptfnmKf7uqqfLf4ceBO1TALUyvfmQAMTEia4Ma
         bTBAwgEQGk9mwXJPpFNy+CQYe2YeFHUAUxQDxpYFubhrZPQuN/bh7Fr9ppfFo59drBIG
         85EOSEX2n7QZMBFPwPL1aTkkFHX86c1XmCZLZHp3V+A1vCSz0B7cLdwicTAgduxZQmol
         z0tMs7uO6bZhAxOwW8ZKV2jhnnQwWlnYUiESfRreXxkQOrwhL0riNj2hPpnyKHuUZvf7
         FdSWb8P+4LGoXNbs9Buj2CRmLM5/qKeJsPgoIdOWNAxNVCkYu08QEJ46tG45NgBYX+1Y
         M7Ag==
X-Gm-Message-State: AO0yUKVTvK72ie2Njuc3TvPKsdc98ZG0TD5CesSNIFIlzcNAZbuh+cF9
        2SzoSYL1pdsB8GzNa/BlU0Y=
X-Google-Smtp-Source: AK7set+lXAlSmnUfBX62tJQ4tRVoyIdd3lGgF+Pi8DAFbeEaqQ3rse7q5ktumAJcukmoYTA7NnZCHA==
X-Received: by 2002:a17:907:2087:b0:87b:d594:5d38 with SMTP id pv7-20020a170907208700b0087bd5945d38mr11422724ejb.53.1675468065141;
        Fri, 03 Feb 2023 15:47:45 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id u7-20020a1709060b0700b0087bdae9a1ebsm2061491ejg.94.2023.02.03.15.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 15:47:44 -0800 (PST)
Date:   Sat, 4 Feb 2023 01:47:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Subject: Re: [RFC PATCH net-next 09/11] net: dsa: microchip: lan937x: update
 port membership with dsa port
Message-ID: <20230203234742.jpjxcmaulmk6vgvg@skbuf>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-10-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-10-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202125930.271740-10-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-10-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:29:28PM +0530, Rakesh Sankaranarayanan wrote:
> Like cpu port, cascaded port will act as host port in second switch. And
> all ports from both switches should be able to forward packets to cascaded
> ports. Add cascaded port (dev->dsa_port) to each port membership.
> 
> Current design add bit map of user ports as cpu port membership. Include
> cascaded port index as well to this group.
> 
> Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz_common.c   |  7 ++++---
>  drivers/net/dsa/microchip/lan937x_main.c |  2 +-
>  include/net/dsa.h                        | 15 +++++++++++++++
>  3 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 913296c5dd50..b8b7b5b7b52d 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -1748,9 +1748,9 @@ static void ksz_get_strings(struct dsa_switch *ds, int port,
>  
>  static void ksz_update_port_member(struct ksz_device *dev, int port)
>  {
> +	u8 port_member = 0, cpu_port, dsa_port;

Don't need these unimaginative names ("cpu_port", "dsa_port" for what is
actually a port *mask*). You can bitwise-OR the upstream port and the
downstream cascade port directly into "port_member", and the code in
ksz_update_port_member() would tolerate it just fine.

>  	struct ksz_port *p = &dev->ports[port];
>  	struct dsa_switch *ds = dev->ds;
> -	u8 port_member = 0, cpu_port;
>  	const struct dsa_port *dp;
>  	int i, j;
>  
> @@ -1759,6 +1759,7 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
>  
>  	dp = dsa_to_port(ds, port);
>  	cpu_port = BIT(dsa_upstream_port(ds, port));
> +	dsa_port = BIT(dev->dsa_port);

If dev->dsa_port is 0xff, what is BIT(0xff)?

>  
>  	for (i = 0; i < ds->num_ports; i++) {
>  		const struct dsa_port *other_dp = dsa_to_port(ds, i);
> @@ -1798,10 +1799,10 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
>  				val |= BIT(j);
>  		}
>  
> -		dev->dev_ops->cfg_port_member(dev, i, val | cpu_port);
> +		dev->dev_ops->cfg_port_member(dev, i, val | cpu_port | dsa_port);
>  	}
>  
> -	dev->dev_ops->cfg_port_member(dev, port, port_member | cpu_port);
> +	dev->dev_ops->cfg_port_member(dev, port, port_member | cpu_port | dsa_port);
>  }
>  
>  static int ksz_sw_mdio_read(struct mii_bus *bus, int addr, int regnum)
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index 5108a3f4bf76..b17bb1ea2a4a 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -198,7 +198,7 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
>  				 true);
>  
>  	if (cpu_port)
> -		member = dsa_user_ports(ds);
> +		member = dsa_user_ports(ds) | dsa_dsa_ports(ds);

I'm wondering if a single dsa_switch_for_each_port() list traversal plus
an "if ()" wouldn't be more efficient here.

>  	else
>  		member = BIT(dsa_upstream_port(ds, port));
>  
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 55651ad29193..939aa6ff1a38 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -591,6 +591,10 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
>  	dsa_switch_for_each_port((_dp), (_ds)) \
>  		if (dsa_port_is_cpu((_dp)))
>  
> +#define dsa_switch_for_each_dsa_port(_dp, _ds) \
> +	dsa_switch_for_each_port((_dp), (_ds)) \
> +		if (dsa_port_is_dsa((_dp)))
> +
>  #define dsa_switch_for_each_cpu_port_continue_reverse(_dp, _ds) \
>  	dsa_switch_for_each_port_continue_reverse((_dp), (_ds)) \
>  		if (dsa_port_is_cpu((_dp)))
> @@ -617,6 +621,17 @@ static inline u32 dsa_cpu_ports(struct dsa_switch *ds)
>  	return mask;
>  }
>  
> +static inline u32 dsa_dsa_ports(struct dsa_switch *ds)
> +{
> +	struct dsa_port *dsa_dp;

can name this just "dp"

> +	u32 mask = 0;
> +
> +	dsa_switch_for_each_dsa_port(dsa_dp, ds)
> +		mask |= BIT(dsa_dp->index);
> +
> +	return mask;
> +}
> +
>  /* Return the local port used to reach an arbitrary switch device */
>  static inline unsigned int dsa_routing_port(struct dsa_switch *ds, int device)
>  {
> -- 
> 2.34.1
> 

