Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4401C409AAE
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 19:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbhIMRa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 13:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbhIMRa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 13:30:26 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEA1C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 10:29:10 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n18so6299010plp.7
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 10:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TNYwvXzlGBd5piyPpMQVKuV6DCGV5gv6LpOuWReLvyc=;
        b=RYfvUhqxsFiCeBKSgDaXypkhTJ8sJtqNx3BMvXK/OkVlC1Hw1GwTW7eiOII+KxG/Tq
         K8ecLUJYCyjDzs7cgptgZCTIpvsTZwjG08NfsBGw7WYaFl+UxuKP+3oG1ZCtYPBAHcxq
         J+f2bVISD0zu/Weu0kM30pQl85qK4coSq+cgP1RBoUrAJI3MikpCN1d2fA2HwgUxe08E
         ftqrazzsRriD7hrpI8QcXFdTZWbVK0lNQkBXBbirjDqCZ4hhSVDopSkq2dfzcsVLvGS4
         FuPzTHgB1ZYkr0yTYuoTdYbSWpJftLQysXJxPnwjAAdrzqKZzN7YAZ7XJOTq8E0+Muxk
         HjaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TNYwvXzlGBd5piyPpMQVKuV6DCGV5gv6LpOuWReLvyc=;
        b=57GUJfDSK2J5KMmCgvuU0bqB+UCFZOlHO5sx9HEZBKggm5OWnSd4uQpQDO9rfv6VRN
         7uBWRqNjDneZz07N5c38ARTiJfMCMpUo/J3ZgHyiYroyV0d8Xyva0k0ct6yQTWCSrjYV
         qiw5F6eWZsmJ0Z52nv//DrdEDDHkLqcemorFw8d78FMay14/F60nxin3miQOj60lf42J
         m25kDs+/5ErIJSkc5LZwknhgXHcQ/gAWa9emAS6L/o2sPWODEHaip3FitmiWDajQzYPx
         +AnRTnYNv9rbn+/7IzHPbApfcSe1yKvlKqTbDo64lIwwusg2qjPdi43BMG7yDn+q/Pm2
         gg8g==
X-Gm-Message-State: AOAM531N9bVk1BwSMKHM7g8ouvz6ezAybfD0nZj4752eg/gx7iQQgJUB
        3Pk4pOz28ipvtX8yvt0m11U=
X-Google-Smtp-Source: ABdhPJz1lbHg6I+0Lh702l/e285MAXgtbswNHe6VrseYTkHTBrG6QT1gw2DkFw0bCDSHo0hRB4Vaaw==
X-Received: by 2002:a17:902:e846:b0:13b:8b77:6cf8 with SMTP id t6-20020a170902e84600b0013b8b776cf8mr7734940plg.33.1631554149930;
        Mon, 13 Sep 2021 10:29:09 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y195sm3638283pfc.7.2021.09.13.10.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 10:29:09 -0700 (PDT)
Message-ID: <36e74f93-0800-70bb-3d30-2fac1db092fd@gmail.com>
Date:   Mon, 13 Sep 2021 10:29:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 3/8] net: dsa: rtl8366rb: Rewrite weird VLAN
 filering enablement
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
 <20210913144300.1265143-4-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210913144300.1265143-4-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/13/2021 7:42 AM, Linus Walleij wrote:
> While we were defining one VLAN per port for isolating the ports
> the port_vlan_filtering() callback was implemented to enable a
> VLAN on the port + 1. This function makes no sense, not only is
> it incomplete as it only enables the VLAN, it doesn't do what
> the callback is supposed to do, which is to selectively enable
> and disable filtering on a certain port.
> 
> Implement the correct callback: we have two registers dealing
> with filtering on the RTL9366RB, so we implement an ASIC-specific
> callback, describe these and activate both.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v4:
> - New patch after discovering that this weirdness of mine is
>    causing problems.
> ---
>   drivers/net/dsa/realtek-smi-core.h |  2 --
>   drivers/net/dsa/rtl8366.c          | 35 -----------------------------
>   drivers/net/dsa/rtl8366rb.c        | 36 +++++++++++++++++++++++++-----
>   3 files changed, 30 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
> index c8fbd7b9fd0b..214f710d7dd5 100644
> --- a/drivers/net/dsa/realtek-smi-core.h
> +++ b/drivers/net/dsa/realtek-smi-core.h
> @@ -129,8 +129,6 @@ int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
>   int rtl8366_enable_vlan4k(struct realtek_smi *smi, bool enable);
>   int rtl8366_enable_vlan(struct realtek_smi *smi, bool enable);
>   int rtl8366_reset_vlan(struct realtek_smi *smi);
> -int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
> -			   struct netlink_ext_ack *extack);
>   int rtl8366_vlan_add(struct dsa_switch *ds, int port,
>   		     const struct switchdev_obj_port_vlan *vlan,
>   		     struct netlink_ext_ack *extack);
> diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
> index 59c5bc4f7b71..0672dd56c698 100644
> --- a/drivers/net/dsa/rtl8366.c
> +++ b/drivers/net/dsa/rtl8366.c
> @@ -292,41 +292,6 @@ int rtl8366_reset_vlan(struct realtek_smi *smi)
>   }
>   EXPORT_SYMBOL_GPL(rtl8366_reset_vlan);
>   
> -int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
> -			   struct netlink_ext_ack *extack)
> -{
> -	struct realtek_smi *smi = ds->priv;
> -	struct rtl8366_vlan_4k vlan4k;
> -	int ret;
> -
> -	/* Use VLAN nr port + 1 since VLAN0 is not valid */
> -	if (!smi->ops->is_vlan_valid(smi, port + 1))
> -		return -EINVAL;
> -
> -	dev_info(smi->dev, "%s filtering on port %d\n",
> -		 vlan_filtering ? "enable" : "disable",
> -		 port);
> -
> -	/* TODO:
> -	 * The hardware support filter ID (FID) 0..7, I have no clue how to
> -	 * support this in the driver when the callback only says on/off.
> -	 */
> -	ret = smi->ops->get_vlan_4k(smi, port + 1, &vlan4k);
> -	if (ret)
> -		return ret;
> -
> -	/* Just set the filter to FID 1 for now then */
> -	ret = rtl8366_set_vlan(smi, port + 1,
> -			       vlan4k.member,
> -			       vlan4k.untag,
> -			       1);
> -	if (ret)
> -		return ret;
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(rtl8366_vlan_filtering);
> -
>   int rtl8366_vlan_add(struct dsa_switch *ds, int port,
>   		     const struct switchdev_obj_port_vlan *vlan,
>   		     struct netlink_ext_ack *extack)
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index a5b7d7ff8884..6c35e1ed49aa 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -143,6 +143,8 @@
>   #define RTL8366RB_PHY_NO_OFFSET			9
>   #define RTL8366RB_PHY_NO_MASK			(0x1f << 9)
>   
> +/* VLAN Ingress Control Register */
> +#define RTL8366RB_VLAN_INGRESS_CTRL1_REG	0x037E
>   #define RTL8366RB_VLAN_INGRESS_CTRL2_REG	0x037f
>   
>   /* LED control registers */
> @@ -933,11 +935,13 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>   	if (ret)
>   		return ret;
>   
> -	/* Discard VLAN tagged packets if the port is not a member of
> -	 * the VLAN with which the packets is associated.
> -	 */
> +	/* Accept all packets by default, we enable filtering on-demand */
> +	ret = regmap_write(smi->map, RTL8366RB_VLAN_INGRESS_CTRL1_REG,
> +			   0);
> +	if (ret)
> +		return ret;
>   	ret = regmap_write(smi->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
> -			   RTL8366RB_PORT_ALL);
> +			   0);
>   	if (ret)
>   		return ret;
>   
> @@ -1209,6 +1213,26 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
>   			   RTL8366RB_PORT_ISO_PORTS(port_bitmap), 0);
>   }
>   
> +static int rtl8366rb_vlan_filtering(struct dsa_switch *ds, int port,
> +				    bool vlan_filtering,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	int ret;
> +
> +	dev_dbg(smi->dev, "port %d: %s VLAN filtering\n", port,
> +		vlan_filtering ? "enable" : "disable");
> +
> +	/* Any incoming frames without VID (untagged) will be dropped */

But this is not exactly what you want though, an untagged frame for 
which there is a VLAN entry should be accepted, think about the bridge's 
default_pvid. Is the code wrong or the comment wrong?

> +	ret = regmap_update_bits(smi->map, RTL8366RB_VLAN_INGRESS_CTRL1_REG,
> +				 BIT(port), vlan_filtering ? BIT(port) : 0);
> +	if (ret)
> +		return ret;
> +	/* If the port is not in the member set, the frame will be dropped */

OK that part does make sense and is how it should behave.

> +	return regmap_update_bits(smi->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
> +				  BIT(port), vlan_filtering ? BIT(port) : 0);
> +}
> +
>   static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>   {
>   	struct realtek_smi *smi = ds->priv;
> @@ -1437,7 +1461,7 @@ static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
>   	if (smi->vlan4k_enabled)
>   		max = RTL8366RB_NUM_VIDS - 1;
>   
> -	if (vlan == 0 || vlan > max)
> +	if (vlan > max)
>   		return false;
>   
>   	return true;
> @@ -1594,7 +1618,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
>   	.get_sset_count = rtl8366_get_sset_count,
>   	.port_bridge_join = rtl8366rb_port_bridge_join,
>   	.port_bridge_leave = rtl8366rb_port_bridge_leave,
> -	.port_vlan_filtering = rtl8366_vlan_filtering,
> +	.port_vlan_filtering = rtl8366rb_vlan_filtering,
>   	.port_vlan_add = rtl8366_vlan_add,
>   	.port_vlan_del = rtl8366_vlan_del,
>   	.port_enable = rtl8366rb_port_enable,
> 

-- 
Florian
