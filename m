Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B213B2CBDB4
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 14:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgLBNFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 08:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgLBNFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 08:05:22 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD9AC0613CF;
        Wed,  2 Dec 2020 05:04:42 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id 7so4191549ejm.0;
        Wed, 02 Dec 2020 05:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zr/Exg/tfJzpSU9TKnFRIU0wuKIFqXjZsNHFxj9LvHs=;
        b=kwlqxP2vN5yRrOr7qv0IpfOhGXMVVWunJ9P5Yz/w09pFErT2rNdiz/QsVxEIp4Q+gi
         RRjyIqQSBL1i6sWUz2EKomIDBzN6DnNVYs7tq/UH1RU6ca+HJvS+OaKhOE8vt0i3bVjm
         AJYVHlqg2Io+3fVJ0tlqEjlVsDxIReWE12X6ckfZyZdXyF8G0rA3LEffNdLIV+tzhFSk
         Ac0I331s+jz4iSyDetyVfYc1LTjUA2k3uSX+dE5ygFQ0WvU5H7rVgONjrypUN/ibhcm4
         JDvTIXq8uipwOAAdfofXy0BAOcJOJf5l4Th92i1K27bRhu96mipcm54z4B8MqKq8HLh2
         TsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zr/Exg/tfJzpSU9TKnFRIU0wuKIFqXjZsNHFxj9LvHs=;
        b=pnBQ/O5Vop2EyIzWVdsYREbSDC+kdsaSapO/DxgzA31QjfaS3Q/KxmoR9kC77i1D20
         4AKMJTQfdpK8tUsOAG15RSgHQOIxPd7K4130CJGhh+7I0DZ0jF1dBEfbptQlbg/ZoX4E
         FhM7q07UpnkGio/+sg6XyWmLgTJWLHDGHKsZAwswU7HqnhPHb1VWBqmhuDhoXKYEPZLM
         t7IW1a/9qu9WD7t+x0kdomhQgPOCy4ZvR13TpjOzAdqHMkcg48yyzhDsRAbuq/O6DnoQ
         U6xDbdRl+OXQWFajvbyd/00zvwzrIsm1UVc/Gd5crr7MFPVhx4OrLmkFk67ouwsi98lw
         bF7g==
X-Gm-Message-State: AOAM5309zfGHtRsXwDUuaFqIwVIUlrkY4nzBgOcy+74H6Gptu4xoBf8x
        tS366WFMW2zHneT05CY4zbo=
X-Google-Smtp-Source: ABdhPJx8vItRQCsHY3vPsOYkm/CAt+S+38kioejpQtPZAgGeXx+Uip7sezP+ot/1gsSZc0TbvFghIw==
X-Received: by 2002:a17:907:2108:: with SMTP id qn8mr2193200ejb.127.1606914280708;
        Wed, 02 Dec 2020 05:04:40 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id u17sm1160178eje.11.2020.12.02.05.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 05:04:40 -0800 (PST)
Date:   Wed, 2 Dec 2020 15:04:38 +0200
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
Subject: Re: [PATCH v2 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201202130438.vuhujicfcg2n2ih7@skbuf>
References: <20201202120712.6212-1-o.rempel@pengutronix.de>
 <20201202120712.6212-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202120712.6212-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 01:07:12PM +0100, Oleksij Rempel wrote:
> Add stats support for the ar9331 switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  /* Warning: switch reset will reset last AR9331_SW_MDIO_PHY_MODE_PAGE request
> @@ -422,6 +527,7 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
>  					    phy_interface_t interface)
>  {
>  	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct ar9331_sw_port *p = &priv->port[port];
>  	struct regmap *regmap = priv->regmap;
>  	int ret;
>  
> @@ -429,6 +535,8 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
>  				 AR9331_SW_PORT_STATUS_MAC_MASK, 0);
>  	if (ret)
>  		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +
> +	cancel_delayed_work_sync(&p->mib_read);

Is this sufficient? Do you get a guaranteed .phylink_mac_link_down event
on unbind? How do you ensure you don't race with the stats worker there?

> +static void ar9331_stats_update(struct ar9331_sw_port *port,
> +				struct rtnl_link_stats64 *stats)
> +{
> +	struct ar9331_sw_stats *s = &port->stats;
> +
> +	stats->rx_packets = s->rxbroad + s->rxmulti + s->rx64byte +
> +		s->rx128byte + s->rx256byte + s->rx512byte + s->rx1024byte +
> +		s->rx1518byte + s->rxmaxbyte;
> +	stats->tx_packets = s->txbroad + s->txmulti + s->tx64byte +
> +		s->tx128byte + s->tx256byte + s->tx512byte + s->tx1024byte +
> +		s->tx1518byte + s->txmaxbyte;
> +	stats->rx_bytes = s->rxgoodbyte;
> +	stats->tx_bytes = s->txbyte;
> +	stats->rx_errors = s->rxfcserr + s->rxalignerr + s->rxrunt +
> +		s->rxfragment + s->rxoverflow;
> +	stats->tx_errors = s->txoversize;
> +	stats->multicast = s->rxmulti;
> +	stats->collisions = s->txcollision;
> +	stats->rx_length_errors = s->rxrunt * s->rxfragment + s->rxtoolong;

Multiplication? Is this right?

> +	stats->rx_crc_errors = s->rxfcserr + s->rxalignerr + s->rxfragment;
> +	stats->rx_frame_errors = s->rxalignerr;
> +	stats->rx_missed_errors = s->rxoverflow;
> +	stats->tx_aborted_errors = s->txabortcol;
> +	stats->tx_fifo_errors = s->txunderrun;
> +	stats->tx_window_errors = s->txlatecol;
> +	stats->rx_nohandler = s->filtered;
> +}
> +
> +static void ar9331_do_stats_poll(struct work_struct *work)
> +{
> +

Could you remove this empty line.
