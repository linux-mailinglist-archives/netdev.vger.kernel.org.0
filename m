Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD932DF221
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 00:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgLSXcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 18:32:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34496 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgLSXcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 18:32:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kqlgt-00Cud8-6i; Sun, 20 Dec 2020 00:31:11 +0100
Date:   Sun, 20 Dec 2020 00:31:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 7/8] net: sparx5: add ethtool configuration and
 statistics support
Message-ID: <20201219233111.GF3008889@lunn.ch>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-8-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217075134.919699-8-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +void sparx5_get_stats64(struct net_device *ndev,
> +			struct rtnl_link_stats64 *stats)
> +{
> +	struct sparx5_port *port = netdev_priv(ndev);
> +	struct sparx5 *sparx5 = port->sparx5;
> +	u64 *portstats;
> +
> +	if (!sparx5->stats)
> +		return;		/* Not initialized yet */
> +
> +	portstats = &sparx5->stats[port->portno * sparx5->num_stats];
> +
> +	mutex_lock(&sparx5->stats_lock);

There was a big discussion about stats64 not being able to take a lock
a few weeks ago. You probably want to go read the thread. The aim was
to allow sleeping, but i don't know if that as been achieved yet.

   Andrew
