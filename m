Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C593DDBA4
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbhHBOzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbhHBOzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:55:43 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E84C06175F;
        Mon,  2 Aug 2021 07:55:32 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id f13so24798835edq.13;
        Mon, 02 Aug 2021 07:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dtAFJPGGRC1OAs/UpUGONi/1fbxzDEgF9VkLhjC66NA=;
        b=OSCme6HglColyLeMFxLq2zu6U4a0l9ykMXPOd2EaLzDklwFhaVcP6aUy+TqeJWqCy/
         7TP30y288YTHN8HlfhzTIAikI+jEs2zDXXDui30jgXD9qb4efjbCCZekVTiwbPZpRArK
         zY4Vl1OySqlD5wkUPZNxOWLmjbp7E5JzumpBy0VYXcikmeA/6oPLxyu6Kc/vyAl+Xq/j
         KRrxsLseBzjSmaqKP+2syQrIni0ayGjqCuq9bolpPDYFpzmRTCuJKzvM2YlXPqeI/Jyt
         6hsEVTsizl3q0HMT770+rcp7vxxGpzZlagTj6C4KGiq/a/tgN+IjRmcPvPm51RC/k833
         M2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dtAFJPGGRC1OAs/UpUGONi/1fbxzDEgF9VkLhjC66NA=;
        b=dSXSAUfF48Q2AaxmA5nY/Mec+qB4mlWFCs+BWtPPSAYAWcK3A9cKtpYo17BT7NKTH6
         ioz2ih97CinZse+U4Rfi00MHBwueD+06prp94a8d84ft/2qWcRX5WLP/ddOZ3kwlAuaR
         IA1eJpq41s/kkz5FgqUA4mStYh1HndiSAcrLGPRGT4J7MldxRMPbIOrEz+NcQnmjMXbW
         crOHuT8sVVZO85k0wfCGacPk5kkFDpXPv139XrmekRRQd2zEU1rj8/TdHsEc03bC9/z0
         Bj1gVRRtcFx0dzGLxVibQbVgbTGsfFe0XS4ED3J3dKl/t/r554p/HcLEkhCqgP+Pa5sb
         5juA==
X-Gm-Message-State: AOAM530AM9XM83T9PFdG8ZEGaFinlyhPBfWEO7h/PetBHwbbV4wtG701
        3NakqdJ79XPBW4fxOIq27sU=
X-Google-Smtp-Source: ABdhPJyzlyz6oa1+v/7RlYqWfai2bvNMoysier911Baj62ifT5lWTwrb++r0IJP6IAwalod15fSgpQ==
X-Received: by 2002:a50:8713:: with SMTP id i19mr19857360edb.310.1627916131104;
        Mon, 02 Aug 2021 07:55:31 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id x12sm3545694edv.96.2021.08.02.07.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 07:55:30 -0700 (PDT)
Date:   Mon, 2 Aug 2021 17:55:29 +0300
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
Subject: Re: [PATCH net-next v3 5/6] net: dsa: qca: ar9331: add bridge support
Message-ID: <20210802145529.5k57qhsp7i43wmff@skbuf>
References: <20210802131037.32326-1-o.rempel@pengutronix.de>
 <20210802131037.32326-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802131037.32326-6-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 03:10:36PM +0200, Oleksij Rempel wrote:
> This switch is providing forwarding matrix, with it we can configure
> individual bridges. Potentially we can configure more than one not VLAN
> based bridge on this HW.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/qca/ar9331.c | 53 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index d726d2f223ea..a0324fed2136 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -40,6 +40,7 @@
>   */
>  
>  #include <linux/bitfield.h>
> +#include <linux/if_bridge.h>
>  #include <linux/module.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_mdio.h>
> @@ -1093,6 +1094,56 @@ static int ar9331_sw_set_ageing_time(struct dsa_switch *ds,
>  				  val);
>  }
>  
> +static int ar9331_sw_port_bridge_mod(struct dsa_switch *ds, int port,
> +				     struct net_device *br, bool join)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;

Reverse Christmas tree notation..

> +	int port_mask = BIT(dsa_to_port(ds, port)->cpu_dp->index);

Could you use dsa_upstream_port(ds, port) instead of raw access to cpu_dp?
Or alternatively, you can add another condition in your "for" loop, for
dsa_is_cpu_port(ds, port) => port_mask |= BIT(i);

> +	int i, ret;
> +	u32 val;
> +
> +	for (i = 0; i < ds->num_ports; i++) {
> +		if (dsa_to_port(ds, i)->bridge_dev != br)
> +			continue;
> +
> +		if (!dsa_is_user_port(ds, port))
> +			continue;

Only user ports can have a ->bridge_dev pointer populated in the first place.
Also, did you mean dsa_is_user_port(ds, i)? The "port" variable is an
invariant as far as this loop is concerned.

> +
> +		val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, BIT(port));
> +		ret = regmap_set_bits(regmap, AR9331_SW_REG_PORT_VLAN(i), val);
> +		if (ret)
> +			goto error;
> +
> +		if (join && i != port)
> +			port_mask |= BIT(i);
> +	}
> +
> +	val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, port_mask);
> +	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_VLAN(port),
> +				 AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, val);
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
> +static int ar9331_sw_port_bridge_join(struct dsa_switch *ds, int port,
> +				      struct net_device *br)
> +{
> +	return ar9331_sw_port_bridge_mod(ds, port, br, true);
> +}
> +
> +static void ar9331_sw_port_bridge_leave(struct dsa_switch *ds, int port,
> +					struct net_device *br)
> +{
> +	ar9331_sw_port_bridge_mod(ds, port, br, false);
> +}
> +
>  static const struct dsa_switch_ops ar9331_sw_ops = {
>  	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
>  	.setup			= ar9331_sw_setup,
> @@ -1109,6 +1160,8 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
>  	.port_mdb_add           = ar9331_sw_port_mdb_add,
>  	.port_mdb_del           = ar9331_sw_port_mdb_del,
>  	.set_ageing_time	= ar9331_sw_set_ageing_time,
> +	.port_bridge_join	= ar9331_sw_port_bridge_join,
> +	.port_bridge_leave	= ar9331_sw_port_bridge_leave,
>  };
>  
>  static irqreturn_t ar9331_sw_irq(int irq, void *data)
> -- 
> 2.30.2
> 
