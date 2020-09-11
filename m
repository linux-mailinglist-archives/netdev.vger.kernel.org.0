Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29981265FC4
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 14:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgIKMrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 08:47:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgIKMnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 08:43:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGiOI-00EE62-Lc; Fri, 11 Sep 2020 14:42:58 +0200
Date:   Fri, 11 Sep 2020 14:42:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200911124258.GB3390477@lunn.ch>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-7-marek.behun@nic.cz>
 <20200910122341.GC7907@duo.ucw.cz>
 <20200910131541.GD3316362@lunn.ch>
 <20200910161522.3cf3ad63@dellmb.labs.office.nic.cz>
 <20200910150040.GB3354160@lunn.ch>
 <3d4dd05f2597c66fb429580095eed91c2b3be76a.camel@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d4dd05f2597c66fb429580095eed91c2b3be76a.camel@ew.tq-group.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - Do all PHYs support manual setting of the LED level, or are the PHYs
> that can only work with HW triggers?

There are PHYs with do not have simple on/off.

> - Is setting PHY registers always efficiently possible, or should SW
> triggers be avoided in certain cases? I'm thinking about setups like
> mdio-gpio. I guess this can only become an issue for triggers that
> blink.

There are uses cases where not using software frequently writing
registers would be good. PTP time stamping is one, where the extra
jitter can reduce the accuracy of the clock.

I also think activity blinking in software is unlikely to be
accepted. Nothing extra is allowed in the hot path, when you can be
dealing with a million or more packets per second.

So i would say limit software fallback to link and speed, and don't
assume that is even possible depending on the hardware.

	Andrew
