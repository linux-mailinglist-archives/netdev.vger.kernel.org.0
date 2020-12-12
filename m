Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2436C2D86F6
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 14:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437530AbgLLNth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 08:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgLLNtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 08:49:36 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA46C0613CF;
        Sat, 12 Dec 2020 05:48:56 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id lt17so16271596ejb.3;
        Sat, 12 Dec 2020 05:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UeOL99dHWPdGyzF/DJ2PQxzHVXvHObzNByHOUU8Y348=;
        b=qjnVG6uFlae73ZhENCcvW3Uii2J0iWarm9IpuxuOcnLUkVmgxdsVYNJSfMcZa/Vlcc
         A3v/i+Giwyo3/wYO2eZATqX2p0DdBpUDvvzrdybpHqzrLzW9r3YRy0Tw1QmQ4CXbaX0v
         YA/U/bmLU0j+ZWmwGfnuwgU0VLYOo5GWfd4Tny3ep+wBtJVXSQ0xjnhf3SuA2gxIy+t4
         YfGvnAv0hy6DoQhoznKmVQNi0pFaKWzOMY2Do56upYc3OvX0MA82bPYAEapMK46vAPr4
         kOzhCno6BOr7/E0z9g+YbpiAxY24AOLNQroTf+3xjl18oQDELj/xBh15YwHE18oZ0pHV
         csYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UeOL99dHWPdGyzF/DJ2PQxzHVXvHObzNByHOUU8Y348=;
        b=ZXqGg5q3S6wxKvoqRDh3ezTSMspOd/+8R+L3aM0MT0mZs+/aodVMdy3mh80M84AmnX
         JcQqrm1ln5SiNkDIo4StM7Ntu8AejvcdWgQqg4CTwP6o+eqdbaaRH1m3e2dk1NLTf3UC
         dN42eAuVVEl4G3yHu5hRJVhoBtbkrbTvnEEKzljmOaVqnjPd8QEdqSGVCfZ34XacBn4O
         ii5uJfLsvvzaxPjGsE/MZwlhUY5KVQ5B6mYDad3MYC/m8CVOcqo6q2/Dvf/2eGooDuxu
         sj5TpAkB3eogwehXqT4tYtBalOwfNNiRgrI/btRxQY9CCBudaNUuztdswA8IJvOqHtSg
         wEqg==
X-Gm-Message-State: AOAM5324LnoSQAjJrTiFy9bhcvvxiAp9BBnflKI4FFgeKc3jNrdOvZ64
        3HYD0mq1/JNhmQI9zYaVo4A=
X-Google-Smtp-Source: ABdhPJwdnkRZDg7oDL/XVy125sEpR2tleOgHmJmHiS0L5cjDQcR2ocMwFIyI8Pq7qpUjg65q69JFvg==
X-Received: by 2002:a17:906:dc1:: with SMTP id p1mr15500418eji.9.1607780934873;
        Sat, 12 Dec 2020 05:48:54 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id l1sm9074041eje.12.2020.12.12.05.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 05:48:54 -0800 (PST)
Date:   Sat, 12 Dec 2020 15:48:52 +0200
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
Subject: Re: [PATCH v5 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201212134852.gwkugi372afazcd5@skbuf>
References: <20201211105322.7818-1-o.rempel@pengutronix.de>
 <20201211105322.7818-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211105322.7818-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 11:53:22AM +0100, Oleksij Rempel wrote:
> Add stats support for the ar9331 switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/qca/ar9331.c | 256 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 255 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index 4d49c5f2b790..5baef0ec6410 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -101,6 +101,9 @@
>  	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
>  	 AR9331_SW_PORT_STATUS_SPEED_M)
>  
> +/* MIB registers */
> +#define AR9331_MIB_COUNTER(x)			(0x20000 + ((x) * 0x100))
> +
>  /* Phy bypass mode
>   * ------------------------------------------------------------------------
>   * Bit:   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |13 |14 |15 |
> @@ -154,6 +157,111 @@
>  #define AR9331_SW_MDIO_POLL_SLEEP_US		1
>  #define AR9331_SW_MDIO_POLL_TIMEOUT_US		20
>  
> +/* The interval should be small enough to avoid overflow of 32bit MIBs */
> +/*
> + * FIXME: as long as we can't read MIBs from stats64 call directly, we should
> + * poll stats more frequently then it is actually needed. In normal case
> + * 100 sec interval should be OK.
> + */
> +#define STATS_INTERVAL_JIFFIES			(3 * HZ)
> +
> +struct ar9331_sw_stats_raw {
> +	u32 rxbroad;			/* 0x00 */

You should probably use all tabs, or all spaces.

> +	u32 rxpause;                    /* 0x04 */
> +	u32 rxmulti;                    /* 0x08 */
> +	u32 rxfcserr;                   /* 0x0c */
> +	u32 rxalignerr;                 /* 0x10 */
> +	u32 rxrunt;                     /* 0x14 */
> +	u32 rxfragment;                 /* 0x18 */
> +	u32 rx64byte;                   /* 0x1c */
> +	u32 rx128byte;                  /* 0x20 */
> +	u32 rx256byte;                  /* 0x24 */
> +	u32 rx512byte;                  /* 0x28 */
> +	u32 rx1024byte;                 /* 0x2c */
> +	u32 rx1518byte;                 /* 0x30 */
> +	u32 rxmaxbyte;                  /* 0x34 */
> +	u32 rxtoolong;                  /* 0x38 */
> +	u32 rxgoodbyte;                 /* 0x3c */
> +	u32 rxgoodbyte_hi;
> +	u32 rxbadbyte;                  /* 0x44 */
> +	u32 rxbadbyte_hi;
> +	u32 rxoverflow;                 /* 0x4c */
> +	u32 filtered;                   /* 0x50 */
> +	u32 txbroad;                    /* 0x54 */
> +	u32 txpause;                    /* 0x58 */
> +	u32 txmulti;                    /* 0x5c */
> +	u32 txunderrun;                 /* 0x60 */
> +	u32 tx64byte;                   /* 0x64 */
> +	u32 tx128byte;                  /* 0x68 */
> +	u32 tx256byte;                  /* 0x6c */
> +	u32 tx512byte;                  /* 0x70 */
> +	u32 tx1024byte;                 /* 0x74 */
> +	u32 tx1518byte;                 /* 0x78 */
> +	u32 txmaxbyte;                  /* 0x7c */
> +	u32 txoversize;                 /* 0x80 */
> +	u32 txbyte;                     /* 0x84 */
> +	u32 txbyte_hi;
> +	u32 txcollision;                /* 0x8c */
> +	u32 txabortcol;                 /* 0x90 */
> +	u32 txmulticol;                 /* 0x94 */
> +	u32 txsinglecol;                /* 0x98 */
> +	u32 txexcdefer;                 /* 0x9c */
> +	u32 txdefer;                    /* 0xa0 */
> +	u32 txlatecol;                  /* 0xa4 */
> +};
> +
> +struct ar9331_sw_stats {
> +	u64_stats_t rxbroad;
> +	u64_stats_t rxpause;
> +	u64_stats_t rxmulti;
> +	u64_stats_t rxfcserr;
> +	u64_stats_t rxalignerr;
> +	u64_stats_t rxrunt;
> +	u64_stats_t rxfragment;
> +	u64_stats_t rx64byte;
> +	u64_stats_t rx128byte;
> +	u64_stats_t rx256byte;
> +	u64_stats_t rx512byte;
> +	u64_stats_t rx1024byte;
> +	u64_stats_t rx1518byte;
> +	u64_stats_t rxmaxbyte;
> +	u64_stats_t rxtoolong;
> +	u64_stats_t rxgoodbyte;
> +	u64_stats_t rxbadbyte;
> +	u64_stats_t rxoverflow;
> +	u64_stats_t filtered;
> +	u64_stats_t txbroad;
> +	u64_stats_t txpause;
> +	u64_stats_t txmulti;
> +	u64_stats_t txunderrun;
> +	u64_stats_t tx64byte;
> +	u64_stats_t tx128byte;
> +	u64_stats_t tx256byte;
> +	u64_stats_t tx512byte;
> +	u64_stats_t tx1024byte;
> +	u64_stats_t tx1518byte;
> +	u64_stats_t txmaxbyte;
> +	u64_stats_t txoversize;
> +	u64_stats_t txbyte;
> +	u64_stats_t txcollision;
> +	u64_stats_t txabortcol;
> +	u64_stats_t txmulticol;
> +	u64_stats_t txsinglecol;
> +	u64_stats_t txexcdefer;
> +	u64_stats_t txdefer;
> +	u64_stats_t txlatecol;
> +
> +	struct u64_stats_sync syncp;
> +};
> +
> +struct ar9331_sw_priv;
> +struct ar9331_sw_port {
> +	int idx;
> +	struct ar9331_sw_priv *priv;
> +	struct delayed_work mib_read;
> +	struct ar9331_sw_stats stats;
> +};
> +
>  struct ar9331_sw_priv {
>  	struct device *dev;
>  	struct dsa_switch ds;
> @@ -165,6 +273,7 @@ struct ar9331_sw_priv {
>  	struct mii_bus *sbus; /* mdio slave */
>  	struct regmap *regmap;
>  	struct reset_control *sw_reset;
> +	struct ar9331_sw_port port[AR9331_SW_PORTS];
>  };
>  
>  /* Warning: switch reset will reset last AR9331_SW_MDIO_PHY_MODE_PAGE request
> @@ -424,6 +533,7 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
>  					    phy_interface_t interface)
>  {
>  	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct ar9331_sw_port *p = &priv->port[port];
>  	struct regmap *regmap = priv->regmap;
>  	int ret;
>  
> @@ -431,6 +541,8 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
>  				 AR9331_SW_PORT_STATUS_MAC_MASK, 0);
>  	if (ret)
>  		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +
> +	cancel_delayed_work_sync(&p->mib_read);
>  }
>  
>  static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
> @@ -441,10 +553,13 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
>  					  bool tx_pause, bool rx_pause)
>  {
>  	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct ar9331_sw_port *p = &priv->port[port];
>  	struct regmap *regmap = priv->regmap;
>  	u32 val;
>  	int ret;
>  
> +	schedule_delayed_work(&p->mib_read, 0);
> +
>  	val = AR9331_SW_PORT_STATUS_MAC_MASK;
>  	switch (speed) {
>  	case SPEED_1000:
> @@ -477,6 +592,128 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
>  		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
>  }
>  
> +#define AR9331_STATS_ADD(_stats, _raw, _reg) \
> +{ \
> +	u64_stats_add(&_stats->_reg, _raw._reg); \
> +}
> +
> +static void ar9331_read_stats(struct ar9331_sw_port *port)
> +{
> +	struct ar9331_sw_stats *stats = &port->stats;
> +	struct ar9331_sw_priv *priv = port->priv;

You can probably avoid a backpointer to *priv as long as you already
have int idx.

#define ar9331_port_to_priv(p) \
	container_of((p) - (p)->idx, struct ar9331_sw_port, port)

	struct ar9331_sw_priv *priv = ar9331_port_to_priv(p);

> +	struct ar9331_sw_stats_raw raw;
> +	int ret;
> +
> +	/* Do the slowest part first, to avoid needles locking for long time */

Unless this is needles as in "needles and pins", it should probably be
spelled "needless".

> +	ret = regmap_bulk_read(priv->regmap, AR9331_MIB_COUNTER(port->idx),
> +			       &raw, sizeof(raw) / sizeof(u32));
> +	if (ret) {
> +		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +		return;
> +	}
> +	/* All MIB counters are cleared automatically on read */
> +
> +	u64_stats_update_begin(&stats->syncp);
> +
> +	AR9331_STATS_ADD(stats, raw, rxgoodbyte);
> +	AR9331_STATS_ADD(stats, raw, rxbroad);
> +	AR9331_STATS_ADD(stats, raw, rxpause);
> +	AR9331_STATS_ADD(stats, raw, rxmulti);
> +	AR9331_STATS_ADD(stats, raw, rxfcserr);
> +	AR9331_STATS_ADD(stats, raw, rxalignerr);
> +	AR9331_STATS_ADD(stats, raw, rxrunt);
> +	AR9331_STATS_ADD(stats, raw, rxfragment);
> +	AR9331_STATS_ADD(stats, raw, rx64byte);
> +	AR9331_STATS_ADD(stats, raw, rx128byte);
> +	AR9331_STATS_ADD(stats, raw, rx256byte);
> +	AR9331_STATS_ADD(stats, raw, rx512byte);
> +	AR9331_STATS_ADD(stats, raw, rx1024byte);
> +	AR9331_STATS_ADD(stats, raw, rx1518byte);
> +	AR9331_STATS_ADD(stats, raw, rxmaxbyte);
> +	AR9331_STATS_ADD(stats, raw, rxtoolong);
> +	AR9331_STATS_ADD(stats, raw, rxbadbyte);
> +	AR9331_STATS_ADD(stats, raw, rxoverflow);
> +	AR9331_STATS_ADD(stats, raw, filtered);
> +	AR9331_STATS_ADD(stats, raw, txbroad);
> +	AR9331_STATS_ADD(stats, raw, txpause);
> +	AR9331_STATS_ADD(stats, raw, txmulti);
> +	AR9331_STATS_ADD(stats, raw, txunderrun);
> +	AR9331_STATS_ADD(stats, raw, tx64byte);
> +	AR9331_STATS_ADD(stats, raw, tx128byte);
> +	AR9331_STATS_ADD(stats, raw, tx256byte);
> +	AR9331_STATS_ADD(stats, raw, tx512byte);
> +	AR9331_STATS_ADD(stats, raw, tx1024byte);
> +	AR9331_STATS_ADD(stats, raw, tx1518byte);
> +	AR9331_STATS_ADD(stats, raw, txmaxbyte);
> +	AR9331_STATS_ADD(stats, raw, txoversize);
> +	AR9331_STATS_ADD(stats, raw, txbyte);
> +	AR9331_STATS_ADD(stats, raw, txcollision);
> +	AR9331_STATS_ADD(stats, raw, txabortcol);
> +	AR9331_STATS_ADD(stats, raw, txmulticol);
> +	AR9331_STATS_ADD(stats, raw, txsinglecol);
> +	AR9331_STATS_ADD(stats, raw, txexcdefer);
> +	AR9331_STATS_ADD(stats, raw, txdefer);
> +	AR9331_STATS_ADD(stats, raw, txlatecol);
> +
> +	u64_stats_update_end(&stats->syncp);
> +}
> +
> +static void ar9331_stats_update(struct ar9331_sw_port *port,
> +				struct rtnl_link_stats64 *stats)
> +{
> +	struct ar9331_sw_stats *s = &port->stats;
> +
> +	stats->rx_packets = u64_stats_read(&s->rx64byte) +
> +		u64_stats_read(&s->rx128byte) + u64_stats_read(&s->rx256byte) +
> +		u64_stats_read(&s->rx512byte) + u64_stats_read(&s->rx1024byte) +
> +		u64_stats_read(&s->rx1518byte) + u64_stats_read(&s->rxmaxbyte);
> +	stats->tx_packets = u64_stats_read(&s->tx64byte) +
> +		u64_stats_read(&s->tx128byte) + u64_stats_read(&s->tx256byte) +
> +		u64_stats_read(&s->tx512byte) + u64_stats_read(&s->tx1024byte) +
> +		u64_stats_read(&s->tx1518byte) + u64_stats_read(&s->txmaxbyte);
> +	stats->rx_bytes = u64_stats_read(&s->rxgoodbyte);
> +	stats->tx_bytes = u64_stats_read(&s->txbyte);
> +	stats->rx_errors = u64_stats_read(&s->rxfcserr) +
> +		u64_stats_read(&s->rxalignerr) + u64_stats_read(&s->rxrunt) +
> +		u64_stats_read(&s->rxfragment) + u64_stats_read(&s->rxoverflow);
> +	stats->tx_errors = u64_stats_read(&s->txoversize);

Should tx_errors not also include tx_aborted_errors, tx_fifo_errors,
tx_window_errors?

> +	stats->multicast = u64_stats_read(&s->rxmulti);
> +	stats->collisions = u64_stats_read(&s->txcollision);
> +	stats->rx_length_errors = u64_stats_read(&s->rxrunt) +
> +		u64_stats_read(&s->rxfragment) + u64_stats_read(&s->rxtoolong);
> +	stats->rx_crc_errors = u64_stats_read(&s->rxfcserr) +
> +		u64_stats_read(&s->rxalignerr) + u64_stats_read(&s->rxfragment);
> +	stats->rx_frame_errors = u64_stats_read(&s->rxalignerr);
> +	stats->rx_missed_errors = u64_stats_read(&s->rxoverflow);
> +	stats->tx_aborted_errors = u64_stats_read(&s->txabortcol);
> +	stats->tx_fifo_errors = u64_stats_read(&s->txunderrun);
> +	stats->tx_window_errors = u64_stats_read(&s->txlatecol);
> +	stats->rx_nohandler = u64_stats_read(&s->filtered);

Should rx_nohandler not be also included in rx_errors?
You can probably avoid reading a few of these twice by assigning the
more specific ones first, then the rx_errors and tx_errors at the end.

> +}
> +
> +static void ar9331_do_stats_poll(struct work_struct *work)
> +{
> +	struct ar9331_sw_port *port = container_of(work, struct ar9331_sw_port,
> +						   mib_read.work);
> +
> +	ar9331_read_stats(port);
> +
> +	schedule_delayed_work(&port->mib_read, STATS_INTERVAL_JIFFIES);
> +}
> +
> +static void ar9331_get_stats64(struct dsa_switch *ds, int port,
> +			       struct rtnl_link_stats64 *s)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct ar9331_sw_port *p = &priv->port[port];
> +	unsigned int start;
> +
> +	do {
> +		start = u64_stats_fetch_begin(&p->stats.syncp);
> +		ar9331_stats_update(p, s);
> +	} while (u64_stats_fetch_retry(&p->stats.syncp, start));
> +}
> +
>  static const struct dsa_switch_ops ar9331_sw_ops = {
>  	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
>  	.setup			= ar9331_sw_setup,
> @@ -485,6 +722,7 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
>  	.phylink_mac_config	= ar9331_sw_phylink_mac_config,
>  	.phylink_mac_link_down	= ar9331_sw_phylink_mac_link_down,
>  	.phylink_mac_link_up	= ar9331_sw_phylink_mac_link_up,
> +	.get_stats64		= ar9331_get_stats64,
>  };
>  
>  static irqreturn_t ar9331_sw_irq(int irq, void *data)
> @@ -796,7 +1034,7 @@ static int ar9331_sw_probe(struct mdio_device *mdiodev)
>  {
>  	struct ar9331_sw_priv *priv;
>  	struct dsa_switch *ds;
> -	int ret;
> +	int ret, i;
>  
>  	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
> @@ -831,6 +1069,15 @@ static int ar9331_sw_probe(struct mdio_device *mdiodev)
>  	ds->ops = &priv->ops;
>  	dev_set_drvdata(&mdiodev->dev, priv);
>  
> +	for (i = 0; i < ARRAY_SIZE(priv->port); i++) {
> +		struct ar9331_sw_port *port = &priv->port[i];
> +
> +		port->idx = i;
> +		port->priv = priv;
> +		u64_stats_init(&port->stats.syncp);
> +		INIT_DELAYED_WORK(&port->mib_read, ar9331_do_stats_poll);
> +	}
> +
>  	ret = dsa_register_switch(ds);
>  	if (ret)
>  		goto err_remove_irq;
> @@ -846,6 +1093,13 @@ static int ar9331_sw_probe(struct mdio_device *mdiodev)
>  static void ar9331_sw_remove(struct mdio_device *mdiodev)
>  {
>  	struct ar9331_sw_priv *priv = dev_get_drvdata(&mdiodev->dev);
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(priv->port); i++) {
> +		struct ar9331_sw_port *port = &priv->port[i];
> +
> +		cancel_delayed_work_sync(&port->mib_read);
> +	}
>  
>  	irq_domain_remove(priv->irqdomain);
>  	mdiobus_unregister(priv->mbus);
> -- 
> 2.29.2
> 
