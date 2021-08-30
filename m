Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2D43FBF01
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 00:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbhH3Wej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 18:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhH3Wei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 18:34:38 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CA7C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:33:43 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o39-20020a05600c512700b002e74638b567so1018452wms.2
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ExDNOYwMBVU6qurQDKvYdWz7yBJj8Hetrhcn1y3lbvA=;
        b=dGoED3kROV1noD19YzdGiySadRY6OwImIJl+bYJHzZvWiQQviwI5CvPsj1fLn3eVdM
         DHiiWIK+vdRQKcn4mruvlrACDRkFkzhn3/3vCZT8Hs+H+Ni9oyVqfd+8Bqoo17VNzQrf
         ytKywTP+S+Rta6xyu7EZH00uzNBIIjbfqiZuL2aSa9UEIP6Sdd/qNsM+Je0wBOdC/eYl
         VXZFKFN/cvGbUnmmi1MoqNH0oTA+kmoJ0WJFG71RRL20DQw4dCOLMM6oxfFhXZUGgO5m
         g7sHqEYYbELfmtO5EHmzUGxPG8OfR6e7NJOu6mRhm8un3ucxnMpVrfcjGyWhO7qJ+Gyf
         lIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ExDNOYwMBVU6qurQDKvYdWz7yBJj8Hetrhcn1y3lbvA=;
        b=Y7oVPfdCEgQY1eYcgFvX6Id1h8wmsF/xoEPmG2L+nf6jama7JFwFmKwec+6JkZ9gYK
         U1idMKGB1BtW0HeIhuogL/j7n2CYjXzonHLWoD5/os0UlRD6nlxCpLQE+Trz45kd0uPB
         SDs6+7WKsVIWdHKR98mohUQStrSJE63wYJagRxQ0hcrYVYWe98WtK0ck5heKNst+CXEN
         KBhF2uTKgk68Oxw6PbM9XO153EzOCq7VxGcYXLOT2lwXKkhoeLgZryf23zrvWPOo3/Lz
         ZrMgz7byZupvZtGWwFsZfe/qI/WJ3nDqlZCN//VwAXC/56MK41uL3lIC6qlWAIzWO3Xs
         R4/A==
X-Gm-Message-State: AOAM530md2jBQVTylcyh2kTw8ZvpHTWjf1NIOhMCOqdXNAo+koGxoUpn
        gRSTy+MxVbvdUoGOVH7bH+8=
X-Google-Smtp-Source: ABdhPJw4cjX+Ep05vVNcMiMxOtnxTblZUFopWLQN333SbJ7gkFco7xrEBezRF2SMQzlbdm6DrIohfA==
X-Received: by 2002:a1c:28b:: with SMTP id 133mr1134258wmc.138.1630362822524;
        Mon, 30 Aug 2021 15:33:42 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id t14sm16423755wrw.59.2021.08.30.15.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 15:33:42 -0700 (PDT)
Date:   Tue, 31 Aug 2021 01:33:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [PATCH net-next 1/5 v2] net: dsa: rtl8366rb: support bridge
 offloading
Message-ID: <20210830223341.e73wee3nnzl3qedq@skbuf>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-2-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210830214859.403100-2-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:48:55PM +0200, Linus Walleij wrote:
> From: DENG Qingfang <dqfext@gmail.com>
> 
> Use port isolation registers to configure bridge offloading.
> 
> Tested on the D-Link DIR-685, switching between ports and
> sniffing ports to make sure no packets leak.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - introduce RTL8366RB_PORT_ISO_PORTS() to shift the port
>   mask into place so we are not confused by the enable
>   bit.
> - Use this with dsa_user_ports() to isolate the CPU port
>   from itself.
> ---
>  drivers/net/dsa/rtl8366rb.c | 87 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index a89093bc6c6a..50ee7cd62484 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -300,6 +300,13 @@
>  #define RTL8366RB_INTERRUPT_STATUS_REG	0x0442
>  #define RTL8366RB_NUM_INTERRUPT		14 /* 0..13 */
>  
> +/* Port isolation registers */
> +#define RTL8366RB_PORT_ISO_BASE		0x0F08
> +#define RTL8366RB_PORT_ISO(pnum)	(RTL8366RB_PORT_ISO_BASE + (pnum))
> +#define RTL8366RB_PORT_ISO_EN		BIT(0)
> +#define RTL8366RB_PORT_ISO_PORTS_MASK	GENMASK(7, 1)
> +#define RTL8366RB_PORT_ISO_PORTS(pmask)	(pmask << 1)

Would be nice to enclose pmask between a set of parentheses.

> +
>  /* bits 0..5 enable force when cleared */
>  #define RTL8366RB_MAC_FORCE_CTRL_REG	0x0F11
>  
> @@ -835,6 +842,22 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> +	/* Isolate all user ports so only the CPU port can access them */
> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> +		ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
> +				   RTL8366RB_PORT_ISO_EN |
> +				   RTL8366RB_PORT_ISO_PORTS(BIT(RTL8366RB_PORT_NUM_CPU)));
> +		if (ret)
> +			return ret;
> +	}
> +	/* CPU port can access all ports */
> +	dev_info(smi->dev, "DSA user port mask: %08x\n", dsa_user_ports(ds));
> +	ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(RTL8366RB_PORT_NUM_CPU),
> +			   RTL8366RB_PORT_ISO_PORTS(dsa_user_ports(ds))|

For beauty you can add the missing space here between ) and |.

> +			   RTL8366RB_PORT_ISO_EN);
> +	if (ret)
> +		return ret;
> +
>  	/* Set up the "green ethernet" feature */
>  	ret = rtl8366rb_jam_table(rtl8366rb_green_jam,
>  				  ARRAY_SIZE(rtl8366rb_green_jam), smi, false);
> @@ -1127,6 +1150,68 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
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
> +	/* Loop over all other ports than this one */
> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> +		/* Handled last */
> +		if (i == port)
> +			continue;
> +		/* Not on this bridge */
> +		if (dsa_to_port(ds, i)->bridge_dev != bridge)
> +			continue;
> +		/* Join this port to each other port on the bridge */
> +		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
> +					 RTL8366RB_PORT_ISO_PORTS(BIT(port)),
> +					 RTL8366RB_PORT_ISO_PORTS(BIT(port)));
> +		if (ret)
> +			return ret;
> +
> +		port_bitmap |= BIT(i);
> +	}
> +
> +	/* Set the bits for the ports we can access */
> +	return regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
> +				  RTL8366RB_PORT_ISO_PORTS_MASK,
> +				  RTL8366RB_PORT_ISO_PORTS(port_bitmap));
> +}
> +
> +static void
> +rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
> +			    struct net_device *bridge)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	unsigned int port_bitmap = 0;
> +	int ret, i;
> +
> +	/* Loop over all other ports than this one */
> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> +		/* Handled last */
> +		if (i == port)
> +			continue;
> +		/* Not on this bridge */
> +		if (dsa_to_port(ds, i)->bridge_dev != bridge)
> +			continue;
> +		/* Remove this port from any other port on the bridge */
> +		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
> +					 RTL8366RB_PORT_ISO_PORTS(BIT(port)), 0);
> +		if (ret)
> +			return;

I don't think it is beneficial here to catch the error and return early?
We don't even have a print, it is a rather silent failure. I think if a
function that returns void fails, we should limp on and finish...
unbridging... the... port...

> +
> +		port_bitmap |= BIT(i);
> +	}
> +
> +	/* Clear the bits for the ports we can access */
> +	regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
> +			   RTL8366RB_PORT_ISO_PORTS(port_bitmap), 0);
> +}
> +
>  static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>  {
>  	struct realtek_smi *smi = ds->priv;
> @@ -1510,6 +1595,8 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
>  	.get_strings = rtl8366_get_strings,
>  	.get_ethtool_stats = rtl8366_get_ethtool_stats,
>  	.get_sset_count = rtl8366_get_sset_count,
> +	.port_bridge_join = rtl8366rb_port_bridge_join,
> +	.port_bridge_leave = rtl8366rb_port_bridge_leave,
>  	.port_vlan_filtering = rtl8366_vlan_filtering,
>  	.port_vlan_add = rtl8366_vlan_add,
>  	.port_vlan_del = rtl8366_vlan_del,
> -- 
> 2.31.1
> 

