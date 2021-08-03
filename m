Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BD83DE936
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhHCJGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbhHCJGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:06:20 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEABC06175F;
        Tue,  3 Aug 2021 02:06:08 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id go31so35216290ejc.6;
        Tue, 03 Aug 2021 02:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=INnv+spyTk+SGu5OHn+pnMwsPBvYCp73sTB4fgZVCgo=;
        b=G/rD+aBKvMf8tOXU3FAihJiDqYmtjN/MJbXWjo+1EbasqfVwkNnJD3RB9s9/FDMBG6
         nPrtxL1aNjCZaSXf0pG1BtFvOiTit3uj0kn4Ibq9RbipAucnDgw+GadsyJUNfAF2mcv4
         KABW3ELJ9cjrfs/ZZJ0kps2BwYj3mqiXddfdeYio9yRoQJKtI6l78p+qrZaPnAJJs7SZ
         N0fcaURG/ViIHVPbBEFCTty1ZCWcg2X3KcvyLtZOD0UzUvjZrY9gQoeu61ZO6Y/C4+og
         nVNqKXNpFJAPg677G6dJRtSjPGJaf+phZPesXeZO3lwJYcOXBRn4lgb8Bf+OY5vdVI8l
         dVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=INnv+spyTk+SGu5OHn+pnMwsPBvYCp73sTB4fgZVCgo=;
        b=PSsx15vkwUWYJG3kceH93TXj7JXeoXxrNleiXpzuy/69QssYepi15ZtgXH7yOpZOjS
         59Pg56n4xIe28x98NvObxRCChCQYdcfrnQUOxKGvTI+Svcx8P5nFxw3rkx7CuLpBamxq
         acoqIkggwruiwycoYMGJHD9glF0Bjr4umxQY1iqRZAuSftCqhK2NU//7ney0CdkYNSqm
         e404kmF/QnOR16FWfQwBdTRvkS4VKKUdHoHafCG8BVk7QpZzxDMSMOC1bLGJem8Hzv+e
         k2Ai+uxP8nfNxVOwhrVmJaKXZvYfPvITBODX/V22ZSSZUnMKqVqPcZycVnBkwKRzJ/qm
         GQ6w==
X-Gm-Message-State: AOAM532pBjyZTg9UUjFOGlMkUgfotTCDHFwP9BvH6ctgPn5/xYCuEKKc
        r8SfGtiBFgGZqOPWiBV6uwk=
X-Google-Smtp-Source: ABdhPJyQJDVBKjAl1e1SMRPCe44uH1oJeDfHIJUgmWpCnKkv70AJqnTh0BSvANFJtwjo+BGyGQ8arQ==
X-Received: by 2002:a17:906:9c84:: with SMTP id fj4mr19536839ejc.274.1627981567401;
        Tue, 03 Aug 2021 02:06:07 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id v8sm4827706ejy.79.2021.08.03.02.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 02:06:06 -0700 (PDT)
Date:   Tue, 3 Aug 2021 12:06:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net v2 1/1] net: dsa: qca: ar9331: make proper initial
 port defaults
Message-ID: <20210803090605.bud4ocr4siz3jl7r@skbuf>
References: <20210803085320.23605-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803085320.23605-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 10:53:20AM +0200, Oleksij Rempel wrote:
> Make sure that all external port are actually isolated from each other,
> so no packets are leaked.
> 
> Fixes: ec6698c272de ("net: dsa: add support for Atheros AR9331 built-in switch")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
> changes v2:
> - do not enable address learning by default
> 
>  drivers/net/dsa/qca/ar9331.c | 98 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 97 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index 6686192e1883..de7c06b6c85f 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -101,6 +101,46 @@
>  	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
>  	 AR9331_SW_PORT_STATUS_SPEED_M)
>  
> +#define AR9331_SW_REG_PORT_CTRL(_port)			(0x104 + (_port) * 0x100)
> +#define AR9331_SW_PORT_CTRL_ING_MIRROR_EN		BIT(17)

not used

> +#define AR9331_SW_PORT_CTRL_EG_MIRROR_EN		BIT(16)

not used

> +#define AR9331_SW_PORT_CTRL_DOUBLE_TAG_VLAN		BIT(15)

not used

> +#define AR9331_SW_PORT_CTRL_LEARN_EN			BIT(14)

not used

> +#define AR9331_SW_PORT_CTRL_SINGLE_VLAN_EN		BIT(13)

not used

> +#define AR9331_SW_PORT_CTRL_MAC_LOOP_BACK		BIT(12)

not used

> +#define AR9331_SW_PORT_CTRL_HEAD_EN			BIT(11)
> +#define AR9331_SW_PORT_CTRL_IGMP_MLD_EN			BIT(10)

not used

> +#define AR9331_SW_PORT_CTRL_EG_VLAN_MODE		GENMASK(9, 8)

not used

> +#define AR9331_SW_PORT_CTRL_EG_VLAN_MODE_KEEP		0

not used

> +#define AR9331_SW_PORT_CTRL_EG_VLAN_MODE_STRIP		1

not used

> +#define AR9331_SW_PORT_CTRL_EG_VLAN_MODE_ADD		2

not used

> +#define AR9331_SW_PORT_CTRL_EG_VLAN_MODE_DOUBLE		3

not used

> +#define AR9331_SW_PORT_CTRL_LEARN_ONE_LOCK		BIT(7)

not used

> +#define AR9331_SW_PORT_CTRL_PORT_LOCK_EN		BIT(6)

not used

> +#define AR9331_SW_PORT_CTRL_LOCK_DROP_EN		BIT(5)

not used

> +#define AR9331_SW_PORT_CTRL_PORT_STATE			GENMASK(2, 0)
> +#define AR9331_SW_PORT_CTRL_PORT_STATE_DISABLED		0
> +#define AR9331_SW_PORT_CTRL_PORT_STATE_BLOCKING		1
> +#define AR9331_SW_PORT_CTRL_PORT_STATE_LISTENING	2
> +#define AR9331_SW_PORT_CTRL_PORT_STATE_LEARNING		3
> +#define AR9331_SW_PORT_CTRL_PORT_STATE_FORWARD		4
> +
> +#define AR9331_SW_REG_PORT_VLAN(_port)			(0x108 + (_port) * 0x100)
> +#define AR9331_SW_PORT_VLAN_8021Q_MODE			GENMASK(31, 30)
> +#define AR9331_SW_8021Q_MODE_SECURE			3
> +#define AR9331_SW_8021Q_MODE_CHECK			2
> +#define AR9331_SW_8021Q_MODE_FALLBACK			1
> +#define AR9331_SW_8021Q_MODE_NONE			0
> +#define AR9331_SW_PORT_VLAN_ING_PORT_PRI		GENMASK(29, 27)
> +#define AR9331_SW_PORT_VLAN_FORCE_PORT_VLAN_EN		BIT(26)
> +#define AR9331_SW_PORT_VLAN_PORT_VID_MEMBER		GENMASK(25, 16)
> +#define AR9331_SW_PORT_VLAN_ARP_LEAKY_EN		BIT(15)
> +#define AR9331_SW_PORT_VLAN_UNI_LEAKY_EN		BIT(14)
> +#define AR9331_SW_PORT_VLAN_MULTI_LEAKY_EN		BIT(13)
> +#define AR9331_SW_PORT_VLAN_FORCE_DEFALUT_VID_EN	BIT(12)
> +#define AR9331_SW_PORT_VLAN_PORT_VID			GENMASK(11, 0)
> +#define AR9331_SW_PORT_VLAN_PORT_VID_DEF		1
> +
>  /* MIB registers */
>  #define AR9331_MIB_COUNTER(x)			(0x20000 + ((x) * 0x100))
>  
> @@ -371,12 +411,62 @@ static int ar9331_sw_mbus_init(struct ar9331_sw_priv *priv)
>  	return 0;
>  }
>  
> -static int ar9331_sw_setup(struct dsa_switch *ds)
> +static int ar9331_sw_setup_port(struct dsa_switch *ds, int port)
>  {
>  	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
>  	struct regmap *regmap = priv->regmap;
> +	u32 port_mask, port_ctrl, val;
>  	int ret;
>  
> +	/* Generate default port settings */
> +	port_ctrl = FIELD_PREP(AR9331_SW_PORT_CTRL_PORT_STATE,
> +			       AR9331_SW_PORT_CTRL_PORT_STATE_DISABLED);

PORT_STATE_DISABLED? why? Can you ping over any interface after applying
this patch?

> +
> +	if (dsa_is_cpu_port(ds, port)) {
> +		/* CPU port should be allowed to communicate with all user
> +		 * ports.
> +		 */
> +		port_mask = dsa_user_ports(ds);
> +		/* Enable Atheros header on CPU port. This will allow us
> +		 * communicate with each port separately
> +		 */
> +		port_ctrl |= AR9331_SW_PORT_CTRL_HEAD_EN;
> +	} else if (dsa_is_user_port(ds, port)) {
> +		/* User ports should communicate only with the CPU port.
> +		 */
> +		port_mask = BIT(dsa_to_port(ds, port)->cpu_dp->index);

You can use "port_mask = BIT(dsa_upstream_port(ds, port));", looks nicer
at least to me.

> +	} else {
> +		/* Other ports do not need to communicate at all */
> +		port_mask = 0;
> +	}
> +
> +	val = FIELD_PREP(AR9331_SW_PORT_VLAN_8021Q_MODE,
> +			 AR9331_SW_8021Q_MODE_NONE) |
> +		FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, port_mask) |
> +		FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID,
> +			   AR9331_SW_PORT_VLAN_PORT_VID_DEF);
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_PORT_VLAN(port), val);
> +	if (ret)
> +		goto error;
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_PORT_CTRL(port), port_ctrl);
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +error:
> +	dev_err(priv->dev, "%s: error: %i\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +static int ar9331_sw_setup(struct dsa_switch *ds)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int ret, i;
> +
>  	ret = ar9331_sw_reset(priv);
>  	if (ret)
>  		return ret;
> @@ -402,6 +492,12 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
>  	if (ret)
>  		goto error;
>  
> +	for (i = 0; i < ds->num_ports; i++) {
> +		ret = ar9331_sw_setup_port(ds, i);
> +		if (ret)
> +			goto error;
> +	}
> +
>  	ds->configure_vlan_while_not_filtering = false;
>  
>  	return 0;
> -- 
> 2.30.2
> 

