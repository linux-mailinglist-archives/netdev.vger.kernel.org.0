Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36A7265007
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgIJT7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:59:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55268 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730378AbgIJPAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:00:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGO40-00E5DD-26; Thu, 10 Sep 2020 17:00:40 +0200
Date:   Thu, 10 Sep 2020 17:00:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
Message-ID: <20200910150040.GB3354160@lunn.ch>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-7-marek.behun@nic.cz>
 <20200910122341.GC7907@duo.ucw.cz>
 <20200910131541.GD3316362@lunn.ch>
 <20200910161522.3cf3ad63@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910161522.3cf3ad63@dellmb.labs.office.nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I propose that at least these HW modes should be available (and
> documented) for ethernet PHY controlled LEDs:
>   mode to determine link on:
>     - `link`
>   mode for activity (these should blink):
>     - `activity` (both rx and tx), `rx`, `tx`
>   mode for link (on) and activity (blink)
>     - `link/activity`, maybe `link/rx` and `link/tx`
>   mode for every supported speed:
>     - `1Gbps`, `100Mbps`, `10Mbps`, ...
>   mode for every supported cable type:
>     - `copper`, `fiber`, ... (are there others?)

In theory, there is AUI and BNC, but no modern device will have these.

>   mode that allows the user to determine link speed
>     - `speed` (or maybe `linkspeed` ?)
>     - on some Marvell PHYs the speed can be determined by how fast
>       the LED is blinking (ie. 1Gbps blinks with default blinking
>       frequency, 100Mbps with half blinking frequeny of 1Gbps, 10Mbps
>       of half blinking frequency of 100Mbps)
>     - on other Marvell PHYs this is instead:
>       1Gpbs blinks 3 times, pause, 3 times, pause, ...
>       100Mpbs blinks 2 times, pause, 2 times, pause, ...
>       10Mpbs blinks 1 time, pause, 1 time, pause, ...
>     - we don't need to differentiate these modes with different names,
>       because the important thing is just that this mode allows the
>       user to determine the speed from how the LED blinks
>   mode to just force blinking
>     - `blink`
> The nice thing is that all this can be documented and done in software
> as well.

Have you checked include/dt-bindings/net/microchip-lan78xx.h and
mscc-phy-vsc8531.h ? If you are defining something generic, we need to
make sure the majority of PHYs can actually do it. There is no
standardization in this area. I'm sure there is some similarity, there
is only so many ways you can blink an LED, but i suspect we need a
mixture of standardized modes which we hope most PHYs implement, and
the option to support hardware specific modes.

    Andrew
