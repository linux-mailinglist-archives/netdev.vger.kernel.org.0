Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0442ED2C2
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 15:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbhAGOhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 09:37:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55172 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729309AbhAGOhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 09:37:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxWP7-00GgZg-IT; Thu, 07 Jan 2021 15:36:45 +0100
Date:   Thu, 7 Jan 2021 15:36:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v7 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <X/ccfY+9a8R6wcJX@lunn.ch>
References: <20210107125613.19046-1-o.rempel@pengutronix.de>
 <20210107125613.19046-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107125613.19046-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void ar9331_get_stats64(struct dsa_switch *ds, int port,
> +			       struct rtnl_link_stats64 *s)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct ar9331_sw_port *p = &priv->port[port];
> +
> +	spin_lock(&p->stats_lock);
> +	memcpy(s, &p->stats, sizeof(*s));
> +	spin_unlock(&p->stats_lock);
> +}

This should probably wait until Vladimir's changes for stat64 are
merged, so this call can sleep. You can then return up to date
statistics.

	Andrew
