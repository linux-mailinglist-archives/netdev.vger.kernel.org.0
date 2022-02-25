Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A194C4296
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239683AbiBYKjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbiBYKjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:39:49 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0981CABE9
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:39:16 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x5so6752511edd.11
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RECIZe9k17V+L+zC2QJKOfLhHN5EkB2j1Jlu/WlSYhE=;
        b=iCizq9bM3iHkrzn0TzIBqrrE/aTKI4/Rjb2qwusMp5feZiNO3T2dSHh7GKwAg22/13
         jK0YtJJweQIwbbZZMHu40iCms8YdL8Zb9InmMxRbh0LjJB6jpttT48Hzvg2I1t6gyFYj
         23hQfLyBKmFt0OQQ0ld5KLzpLgM010lE2YubxHk9ScLAIywqSfGULlJsE+RnBo8zGtZh
         gxhUleaQbfRBx1/XRNUw37c6j9Kofccm0KXNUav2MN7h4Gyj7nPdKrDeRalyLJIGuDQL
         3PPWz8sAcgQ3+EGKq4s2Jqr8EkqQiSsazJvi9SslJKfIyyXjwJSrMRJUQAzJbaptHrIp
         ipCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RECIZe9k17V+L+zC2QJKOfLhHN5EkB2j1Jlu/WlSYhE=;
        b=0q002t4jqTcQJ6ptUO3i/SzQGEov8OGO69ljHWokj0+C8S1Hd1Cpbw72xGTW+WfoSE
         AZD8CqisKti9EJ/wvcuukSb+NvJCEJjHOj16ICkG9+N4FIjpiMYy9cUvcfiIkeBqlNl5
         URowrT60RActS5oC2c2reJyVyLyGUgOHOrRkBz/SOcztRRYFpoG3Ah8TZs87JJiEWV5k
         H4BBTZHip4DjPhulLwLz0KAvzAro1O54kOIZS85DjwYhT7jOZ9MsbUtSUC7+/WHN0tYI
         8pde0YzJXwpb+l4TI7aBta0hdQGmWjQFbG8CaAbMkJV4xP8z0YcSIIWpwV0urEUY4G7H
         uk4Q==
X-Gm-Message-State: AOAM531UlA5m11xp3/QNA4XyGiuodifNuA9GFKxlacq2/+1wnfntPT07
        bXtyZEL8WABoZKJ7HMhasSM=
X-Google-Smtp-Source: ABdhPJybDYb9MyPVJgtcerbT5bH0ZLun3V0cSo3kaGqw3hIk2ha0GY/8kzQPpf6oZJ4vGMIlyMSplg==
X-Received: by 2002:aa7:c948:0:b0:413:2bed:e82e with SMTP id h8-20020aa7c948000000b004132bede82emr6534050edt.394.1645785555294;
        Fri, 25 Feb 2022 02:39:15 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id bx1-20020a0564020b4100b00410f01a91f0sm1164999edb.73.2022.02.25.02.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 02:39:14 -0800 (PST)
Date:   Fri, 25 Feb 2022 12:39:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 3/6] net: dsa: sja1105: use
 .mac_select_pcs() interface
Message-ID: <20220225103913.abn4pc57ow6dy2m6@skbuf>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
 <E1nNGm6-00AOip-6r@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nNGm6-00AOip-6r@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 04:15:26PM +0000, Russell King (Oracle) wrote:
> Convert the PCS selection to use mac_select_pcs, which allows the PCS
> to perform any validation it needs, and removes the need to set the PCS
> in the mac_config() callback, delving into the higher DSA levels to do
> so.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/sja1105/sja1105_main.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index e278bd86e3c6..b5c36f808df1 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -1358,18 +1358,16 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
>  	return sja1105_clocking_setup_port(priv, port);
>  }
>  
> -static void sja1105_mac_config(struct dsa_switch *ds, int port,
> -			       unsigned int mode,
> -			       const struct phylink_link_state *state)
> +static struct phylink_pcs *
> +sja1105_mac_select_pcs(struct dsa_switch *ds, int port, phy_interface_t iface)
>  {
> -	struct dsa_port *dp = dsa_to_port(ds, port);
>  	struct sja1105_private *priv = ds->priv;
> -	struct dw_xpcs *xpcs;
> -
> -	xpcs = priv->xpcs[port];
> +	struct dw_xpcs *xpcs = priv->xpcs[port];
>  
>  	if (xpcs)
> -		phylink_set_pcs(dp->pl, &xpcs->pcs);
> +		return &xpcs->pcs;
> +
> +	return NULL;
>  }
>  
>  static void sja1105_mac_link_down(struct dsa_switch *ds, int port,
> @@ -3137,7 +3135,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
>  	.port_max_mtu		= sja1105_get_max_mtu,
>  	.phylink_get_caps	= sja1105_phylink_get_caps,
>  	.phylink_validate	= sja1105_phylink_validate,
> -	.phylink_mac_config	= sja1105_mac_config,

Deleting sja1105_mac_config() here is safe not because
phylink_mac_config() stops calling pl->mac_ops->mac_config(), but
because dsa_port_phylink_mac_config() first checks whether
ds->ops->phylink_mac_config is implemented, and that is purely an
artefact of providing a phylib-style ds->ops->adjust_link, right?

Maybe it's worth mentioning.

> +	.phylink_mac_select_pcs	= sja1105_mac_select_pcs,
>  	.phylink_mac_link_up	= sja1105_mac_link_up,
>  	.phylink_mac_link_down	= sja1105_mac_link_down,
>  	.get_strings		= sja1105_get_strings,
> -- 
> 2.30.2
> 

