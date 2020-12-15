Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCF02DAFA5
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 16:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbgLOPCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 10:02:18 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:41365 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729846AbgLOPCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 10:02:17 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id B3E701C0016;
        Tue, 15 Dec 2020 15:01:32 +0000 (UTC)
Date:   Tue, 15 Dec 2020 16:01:32 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 03/16] net: mscc: ocelot: rename
 ocelot_netdevice_port_event to ocelot_netdevice_changeupper
Message-ID: <20201215150132.GE1781038@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-4-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 08/12/2020 14:07:49+0200, Vladimir Oltean wrote:
> -static int ocelot_netdevice_port_event(struct net_device *dev,
> -				       unsigned long event,
> -				       struct netdev_notifier_changeupper_info *info)
> +static int ocelot_netdevice_changeupper(struct net_device *dev,
> +					struct netdev_notifier_changeupper_info *info)

[...]

> -		netdev_for_each_lower_dev(dev, slave, iter) {
> -			ret = ocelot_netdevice_port_event(slave, event, info);
> -			if (ret)
> -				goto notify;
> +			netdev_for_each_lower_dev(dev, slave, iter) {
> +				ret = ocelot_netdevice_changeupper(slave, event, info);
> +				if (ret)
> +					goto notify;
> +			}
> +		} else {
> +			ret = ocelot_netdevice_changeupper(dev, event, info);

Does that compile? Shouldn't event be dropped?


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
