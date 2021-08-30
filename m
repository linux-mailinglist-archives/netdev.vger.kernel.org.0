Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094813FBF11
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 00:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbhH3WlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 18:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbhH3WlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 18:41:16 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6123C061764
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:40:21 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m2so9832176wmm.0
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KEnDASVTvyavT1N9HkLdH51Nd7qd6AyiFQvfkXk+zPI=;
        b=TKFGPwlEYNaRoEmJV9ptIhar/pU08C6jJ3dePq7uBnyK+6n5taRmWUf7MmVuAseYzt
         a8MeZ32ebEDGhPXOe9ZVtA4SJ2nNSSMmlY/m09IoWzIB1mROhMeHK9fGzQFRbj8ye6wO
         0gXpD4/NH084amuoRmcwekhiAExHhRzapxkxNOd8gV/vHODuLUXZVksRlrNP2CwABd7v
         iO6bMYQxtSitOtJ5LyjWPXQA9382ddpl0BeqeFOenGSXyICaxMUzjSU++AE1R8yJmKHm
         cikO/SxkMGnqb5xTCcK4C3HARdtwdG6BRXGqMVQ4QvEJo688oHutc0TCrnUrVITIPdUu
         zlhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KEnDASVTvyavT1N9HkLdH51Nd7qd6AyiFQvfkXk+zPI=;
        b=Yh1I4/l6yiFqtMcY8GHj+400rJmfBJQMbq1xmyc9dzAUyCoWzTqSX0eMipuw4Lb8ey
         xxFfq/vOD1r/pA+iFtqXShRSdGOODoSh/a6bNru8dPv+eancccuP18gP7OPB/32Myi54
         AqUeFn9bdTyBu6G72t+aMs181NgaFxsyCL007+LTymYUYePTHWsoJlvBcIsnaGEM29il
         1tSzwUfPIveVr+/f7CWAVfxRkWWBQPZqaNvdUf/3i5CqzrV7pUrSphu5eRR/SxHP61Ui
         QWecyB6AC8bHzkEXePfrJyaQQSvtKDsx6ztVqttQp9nIK0eB591KM6xSQBeftoy7SPF2
         P8SA==
X-Gm-Message-State: AOAM531n0F+CVe9R5fDwbduxkbjlnybg8OzwF4jMoR3DkVO7ZmbAlPCH
        2KatHAbPWW8j9bL4e4AXgBvCzYENaLw=
X-Google-Smtp-Source: ABdhPJz5DNH9MzDTLjNDc8y3QXN6TImudWcjqlLjW38oCdwyebVw8gCyxQon8Ks7AoQiNcxHQkcF8Q==
X-Received: by 2002:a05:600c:230a:: with SMTP id 10mr1127082wmo.79.1630363220573;
        Mon, 30 Aug 2021 15:40:20 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id c14sm736864wme.6.2021.08.30.15.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 15:40:20 -0700 (PDT)
Date:   Tue, 31 Aug 2021 01:40:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 3/5 v2] net: dsa: rtl8366rb: Support disabling
 learning
Message-ID: <20210830224019.d7lzral6zejdfl5t@skbuf>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-4-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210830214859.403100-4-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:48:57PM +0200, Linus Walleij wrote:
> The RTL8366RB hardware supports disabling learning per-port
> so let's make use of this feature. Rename some unfortunately
> named registers in the process.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - New patch suggested by Vladimir.
> ---
>  drivers/net/dsa/rtl8366rb.c | 47 +++++++++++++++++++++++++++++++++----
>  1 file changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index 8b040440d2d4..2cadd3e57e8b 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -14,6 +14,7 @@
>  
>  #include <linux/bitops.h>
>  #include <linux/etherdevice.h>
> +#include <linux/if_bridge.h>
>  #include <linux/interrupt.h>
>  #include <linux/irqdomain.h>
>  #include <linux/irqchip/chained_irq.h>
> @@ -42,9 +43,12 @@
>  /* Port Enable Control register */
>  #define RTL8366RB_PECR				0x0001
>  
> -/* Switch Security Control registers */
> -#define RTL8366RB_SSCR0				0x0002
> -#define RTL8366RB_SSCR1				0x0003
> +/* Switch per-port learning disablement register */
> +#define RTL8366RB_PORT_LEARNDIS_CTRL		0x0002
> +
> +/* Security control, actually aging register */
> +#define RTL8366RB_SECURITY_CTRL			0x0003
> +
>  #define RTL8366RB_SSCR2				0x0004
>  #define RTL8366RB_SSCR2_DROP_UNKNOWN_DA		BIT(0)
>  
> @@ -912,12 +916,12 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>  		rb->max_mtu[i] = 1532;
>  
>  	/* Enable learning for all ports */
> -	ret = regmap_write(smi->map, RTL8366RB_SSCR0, 0);
> +	ret = regmap_write(smi->map, RTL8366RB_PORT_LEARNDIS_CTRL, 0);

So the expected behavior for standalone ports would be to _disable_
learning. In rtl8366rb_setup, they are standalone.

>  	if (ret)
>  		return ret;
>  
>  	/* Enable auto ageing for all ports */
> -	ret = regmap_write(smi->map, RTL8366RB_SSCR1, 0);
> +	ret = regmap_write(smi->map, RTL8366RB_SECURITY_CTRL, 0);
>  	if (ret)
>  		return ret;
>  
> @@ -1148,6 +1152,37 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
>  	rb8366rb_set_port_led(smi, port, false);
>  }
>  
> +static int
> +rtl8366rb_port_pre_bridge_flags(struct dsa_switch *ds, int port,
> +				struct switchdev_brport_flags flags,
> +				struct netlink_ext_ack *extack)
> +{
> +	/* We support enabling/disabling learning */
> +	if (flags.mask & ~(BR_LEARNING))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int
> +rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
> +			    struct switchdev_brport_flags flags,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	int ret;
> +
> +	if (flags.mask & BR_LEARNING) {
> +		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_LEARNDIS_CTRL,
> +					 BIT(port),
> +					 (flags.val & BR_LEARNING) ? 0 : BIT(port));
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int
>  rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
>  			   struct net_device *bridge)
> @@ -1600,6 +1635,8 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
>  	.port_vlan_del = rtl8366_vlan_del,
>  	.port_enable = rtl8366rb_port_enable,
>  	.port_disable = rtl8366rb_port_disable,
> +	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
> +	.port_bridge_flags = rtl8366rb_port_bridge_flags,
>  	.port_change_mtu = rtl8366rb_change_mtu,
>  	.port_max_mtu = rtl8366rb_max_mtu,
>  };
> -- 
> 2.31.1
> 

