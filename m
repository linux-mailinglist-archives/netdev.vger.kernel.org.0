Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8E7420AB3
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhJDMQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:16:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47352 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhJDMQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 08:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=y9gJFRgNrteitCd4kkOXtex5hLsUmIyfQnurIve3L0k=; b=W86s9xhZTbrqNDQ/5PEYGx3y6M
        brNvSwel+cHOSYVQ8n49TrO6WfrJLpScgYjbQC473yfhbn6GloWh77tiJCRwiZUDLgce8QMWjyi/S
        giUCTYFtIfH965Fq330ejem1rdPQv+Eat25tCbwA6JQSDXcWwp2sUgBo+D+Q/Ycx0Rmg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXMr7-009XEZ-QU; Mon, 04 Oct 2021 14:14:05 +0200
Date:   Mon, 4 Oct 2021 14:14:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: are device names part of sysfs ABI? (was Re: devicename part of
 LEDs under ethernet MAC / PHY)
Message-ID: <YVrwDbZYqs05d1wu@lunn.ch>
References: <20211001133057.5287f150@thinkpad>
 <YVb/HSLqcOM6drr1@lunn.ch>
 <20211001144053.3952474a@thinkpad>
 <20211003225338.76092ec3@thinkpad>
 <YVqhMeuDI0IZL/zY@kroah.com>
 <20211004090438.588a8a89@thinkpad>
 <YVqo64vS4ox9P9hk@kroah.com>
 <20211004073841.GA20163@amd>
 <YVq7oTTv5URYKVJb@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVq7oTTv5URYKVJb@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 10:30:25AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Oct 04, 2021 at 09:38:41AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > > > Are device names (as returned by dev_name() function) also part of
> > > > > > sysfs ABI? Should these names be stable across reboots / kernel
> > > > > > upgrades?  
> > > > > 
> > > > > Stable in what exact way?
> > > > 
> > > > Example:
> > > > - Board has an ethernet PHYs that is described in DT, and therefore
> > > >   has stable sysfs path (derived from DT path), something like
> > > >     /sys/devices/.../mdio_bus/f1072004.mdio-mii/f1072004.mdio-mii:01
> > > 
> > > None of the numbers there are "stable", right?
> > 
> > At least f1072004 part is stable (and probably whole path). DT has
> > advantages here, and we should provide stable paths when we can.
> 
> The kernel should enumerate the devices as best that it can, but it
> never has the requirement of always enumerating them in the same way
> each time as many busses are not deterministic.

And for this particular SoC, it is possible to map the memory mapped
IO at a different address range. It is the bootloader which determines
this. There are some Marvell uboot's which use 0xd0000000, not
0xf0000000.  So strictly speaking, f1072004 is not stable, it is not
hard wired in the silicon.

   Andrew
