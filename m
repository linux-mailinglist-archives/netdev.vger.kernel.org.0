Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727AF36DB9A
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240280AbhD1P0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:26:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44692 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233594AbhD1P00 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 11:26:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lbm4D-001Wdq-KL; Wed, 28 Apr 2021 17:25:33 +0200
Date:   Wed, 28 Apr 2021 17:25:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next 1/3] net: marvell: prestera: bump supported
 firmware version to 3.0
Message-ID: <YIl+bduYP1ySYC8N@lunn.ch>
References: <20210423155933.29787-1-vadym.kochan@plvision.eu>
 <20210423155933.29787-2-vadym.kochan@plvision.eu>
 <YIL6feaar8Y/yOaZ@lunn.ch>
 <20210423170437.GC17656@plvision.eu>
 <YIMLcsstbpY215oJ@lunn.ch>
 <20210428134724.GA405@plvision.eu>
 <YIluzFlPtSRvS/dR@lunn.ch>
 <20210428145434.GD9325@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428145434.GD9325@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 05:54:34PM +0300, Vadym Kochan wrote:
> On Wed, Apr 28, 2021 at 04:18:52PM +0200, Andrew Lunn wrote:
> > > Regarding the distribution issue when the driver version might be released
> > > earlier than the firmware, it looks like that the probability of such
> > > case is very low because the distributor of the target Linux system will
> > > keep track (actually this is how I see it) that driver and firmware
> > > versions are aligned.
> > 
> > You really expect Debian, Redhat, openWRT, SuSE to keep a close eye on
> > your kernel driver and update their packages at a time you suggest?
> > 
> 
> No, I don't think these distros will keep track it because they are
> targeted for wider usages).
> But I think that NOS specifc distro (which may be based on top of which
> you listed) will do it (sure this is just my assumption).

Mellanox/Nvidia says you can just run Debian on their
switches. Cumulus linux is Debian based. I've been to a few
conferences where data center managers have said they want there
switches to be just another linux machine they can upgrade whenever
they need, nothing special. So that is the TOR segment of the market.

If you look at the opposite end of the market, SOHO switches in Linux,
very few are actually used as plain boring switches. They are actually
embedded into something else. It is an inflight entertainment system
which also has a switch. It is a DSL, 4G, and Ethernet switch placed
along the side of a railway track. It is inside a bus controlling the
passenger information system, announcements, and also a switch. None
of these systems are using a NOS. They are using whatever distribution
best supports the range of devices and services the box needs to
offer.

Now, it could be Prestera will only ever be used as a plain boring
switch in a box. It never gets used for anything interesting. And
since it is a plain boring device, all it needs is a boring NOS? But
do you really want to design your driver aound the assumption nobody
will do anything interesting with Prestera?

> > I'm also not sure your management port argument is valid. This is an
> > enterprise switch, not a TOR. It is probably installed in some broom
> > cupboard at a satellite facility. The management port is not likely to
> > have its own dedicated link back to the central management
> > site. Upgrades are going to be applied over the network, and you have
> > a real danger of turning it into a remote brick, needing local access
> > to restore it.
> 
> I am just trying to clarify if it really worth of it because it will
> lead to the hairy code and keep structs for previous FW version.

Well, if you decide you really should support two generations of the
firmware, you are likely to throw away 3.0.0 and release a 3.0.1 which
is backwards compatible to 2.X.X, but adds additional calls for the
new functionality. Go look at how other drivers have handled this in
the past.

       Andrew
