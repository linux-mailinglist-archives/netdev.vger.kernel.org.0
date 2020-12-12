Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183942D86FB
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 14:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439111AbgLLNwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 08:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgLLNwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 08:52:36 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9141CC0613CF;
        Sat, 12 Dec 2020 05:51:55 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id q16so12348827edv.10;
        Sat, 12 Dec 2020 05:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GdCAdrNEE8PWhes1DSGHTYC+4KCgFsskUOtBzLjjGEw=;
        b=aqPk2uakYos17HgvWgFbQT37aeEHTMi36KN8z/kjJg1LSL6Ktms6npBzQ/ZPgbZGhf
         A5lyEENwI6BNJjVMP3z08+PZxS9H2EH37g9CdjZScDBF9i/WeW48JOLgrfMeLgsTMkAo
         pzSp/E/dQVq8Z5vio+0RxBJN3jHGPOdXEJJsdRMxLCNa6cSaeuPF4SWnfqAVJGQnJQgv
         zZ16tdiMZmYMSfeaEFCr0hwlRJTUnFdx46jsmTUwY3wN4KX8OuI0rqbY55Sa5hvGNFEa
         vZOCcujE43Cisg6QbFbt3xIea9Ex8JWqpO4xKrp4EoEK0AcrUFkB4sS8uOuVd6v1tc2T
         J48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GdCAdrNEE8PWhes1DSGHTYC+4KCgFsskUOtBzLjjGEw=;
        b=eHujxa5RF55YXc7P2YlNEP3l/n+t2nEPwi8juGGRhhJP85jj00iiQA0hLefcVDGD6n
         CeJrEyGGw0JEp5fZ4YQ5Y4Dqux5nQgcba+eRqZ5MLLgiv6hm3ho8uIqp7iqEHoGbnbny
         g9XZfKYNeMIh8/SDc9eFspOlFCdxcrRTUp+ebnrvlPNnXMWKnnORJOH52zBxJJ0k06b0
         HPBc2nBqGP8o66Ba+3leix6+qYez6AN76Mk9misK3huIvPxpq2Qm5mpGQE16qZhMQXsd
         euvBiCrmezSXxx60MjrMrSToW1q9f5CZhA/Jrx5Z8ANa1p5P+EHYUCRYibokxcK/TEWb
         RGLw==
X-Gm-Message-State: AOAM533iMMJnh5Gi6u1KLJ9ceGNwkcFa/24KWRjOd+f8JXCgJ8K78k1X
        A8wtPX1rvI2sOngqw+GSAMw=
X-Google-Smtp-Source: ABdhPJzlFfP5oZgeSsfe2ReUCHAYT12b8ONDKtsJF719yGy7eHpKhdXpigDkrvJMy8xVbQ0hKZXN1Q==
X-Received: by 2002:a50:9b58:: with SMTP id a24mr16304057edj.22.1607781114311;
        Sat, 12 Dec 2020 05:51:54 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id l5sm10932345edl.48.2020.12.12.05.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 05:51:53 -0800 (PST)
Date:   Sat, 12 Dec 2020 15:51:52 +0200
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
Subject: Re: [PATCH v5 1/2] net: dsa: add optional stats64 support
Message-ID: <20201212135152.fj5mfovcwzux6rek@skbuf>
References: <20201211105322.7818-1-o.rempel@pengutronix.de>
 <20201211105322.7818-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211105322.7818-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 11:53:21AM +0100, Oleksij Rempel wrote:
> Allow DSA drivers to export stats64
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  include/net/dsa.h |  3 +++
>  net/dsa/slave.c   | 14 +++++++++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 4e60d2610f20..457b89143875 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -655,6 +655,9 @@ struct dsa_switch_ops {
>  	int	(*port_change_mtu)(struct dsa_switch *ds, int port,
>  				   int new_mtu);
>  	int	(*port_max_mtu)(struct dsa_switch *ds, int port);
> +
> +	void	(*get_stats64)(struct dsa_switch *ds, int port,
> +				   struct rtnl_link_stats64 *s);

Nitpick: I would have probably put it under the "ethtool hardware
statistics." category, at the same time renaming it into "Port
statistics counters."

>  };
>  
>  #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index ff2266d2b998..6e1a4dc18a97 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1602,6 +1602,18 @@ static struct devlink_port *dsa_slave_get_devlink_port(struct net_device *dev)
>  	return dp->ds->devlink ? &dp->devlink_port : NULL;
>  }
>  
> +static void dsa_slave_get_stats64(struct net_device *dev,
> +				  struct rtnl_link_stats64 *s)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!ds->ops->get_stats64)
> +		return dev_get_tstats64(dev, s);
> +
> +	return ds->ops->get_stats64(ds, dp->index, s);
> +}
> +
>  static const struct net_device_ops dsa_slave_netdev_ops = {
>  	.ndo_open	 	= dsa_slave_open,
>  	.ndo_stop		= dsa_slave_close,
> @@ -1621,7 +1633,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
>  #endif
>  	.ndo_get_phys_port_name	= dsa_slave_get_phys_port_name,
>  	.ndo_setup_tc		= dsa_slave_setup_tc,
> -	.ndo_get_stats64	= dev_get_tstats64,
> +	.ndo_get_stats64	= dsa_slave_get_stats64,
>  	.ndo_get_port_parent_id	= dsa_slave_get_port_parent_id,
>  	.ndo_vlan_rx_add_vid	= dsa_slave_vlan_rx_add_vid,
>  	.ndo_vlan_rx_kill_vid	= dsa_slave_vlan_rx_kill_vid,
> -- 
> 2.29.2
> 
