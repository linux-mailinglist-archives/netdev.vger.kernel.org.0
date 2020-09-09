Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8E263941
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 00:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgIIWjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 18:39:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53618 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgIIWjo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 18:39:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG8kX-00DzJD-0p; Thu, 10 Sep 2020 00:39:33 +0200
Date:   Thu, 10 Sep 2020 00:39:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 0/7] PLEASE REVIEW: Add support for
 LEDs on Marvell PHYs
Message-ID: <20200909223933.GM3290129@lunn.ch>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909214259.GL3290129@lunn.ch>
 <20200910001152.34de9a2d@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910001152.34de9a2d@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> They are in /sys/class/net/eth0/phydev/leds by default, because they
> are children of the PHY device and are of `leds` class, and the PHY
> subsystem creates a symlink `phydev` when PHY is attached to the
> interface.
> They are in /sys/class/leds/ as symlinks, because AFAIK everything in
> /sys/class/<CLASS>/ is a symlink...
> 
> > Have you played with network namespaces? What happens with
> > 
> > ip netns add ns1
> > 
> > ip link set eth0 netns ns1
> > 
> >    Andrew
> 
> If you move eth0 to other network namespace, naturally the
> /sys/class/net/eth0 symlink will disappear, as will the directory it
> pointed to.
> 
> The symlink phydev does will disappear from /sys/class/net/eth0/
> directory after eth0 is moved to ns1, and is lost. It does not return
> even if eth0 is moved back to root namespace.

Yes, i just played with this. I would say that is an existing bug. The
link would still work in the namespace, since the mdio_bus is not net
namespace aware and remains accessible from all namespaces.

	Andrew
