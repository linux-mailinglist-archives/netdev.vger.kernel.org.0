Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4AE44422F
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhKCNKF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Nov 2021 09:10:05 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:34629 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhKCNKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:10:04 -0400
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 809B01BF203;
        Wed,  3 Nov 2021 13:07:23 +0000 (UTC)
Date:   Wed, 3 Nov 2021 14:07:22 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 4/6] net: ocelot: add support for ndo_change_mtu
Message-ID: <20211103140722.75a729e1@fixe.home>
In-Reply-To: <20211103124054.pcgruuipw5cpup6v@skbuf>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
        <20211103091943.3878621-5-clement.leger@bootlin.com>
        <20211103124054.pcgruuipw5cpup6v@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 3 Nov 2021 12:40:55 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> > +static int ocelot_change_mtu(struct net_device *dev, int new_mtu)
> > +{
> > +	struct ocelot_port_private *priv = netdev_priv(dev);
> > +	struct ocelot_port *ocelot_port = &priv->port;
> > +	struct ocelot *ocelot = ocelot_port->ocelot;
> > +
> > +	ocelot_port_set_maxlen(ocelot, priv->chip_port, new_mtu);
> > +	WRITE_ONCE(dev->mtu, new_mtu);  
> 
> The WRITE_ONCE seems absolutely gratuitous to me.

I applied what is recommended in netdevice.h for the mtu field of the
netdev.
(https://elixir.bootlin.com/linux/v5.15/source/include/linux/netdevice.h#L1989)
And used in __dev_set_mtu
(https://elixir.bootlin.com/linux/v5.15/source/net/core/dev.c#L8849)

> 
> > +
> > +	return 0;
> > +}
> > +
> >  enum ocelot_action_type {
> >  	OCELOT_MACT_LEARN,
> >  	OCELOT_MACT_FORGET,


-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
