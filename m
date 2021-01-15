Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4200C2F7E94
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732476AbhAOOtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:49:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42840 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbhAOOtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 09:49:21 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0QOy-000lLr-Kt; Fri, 15 Jan 2021 15:48:36 +0100
Date:   Fri, 15 Jan 2021 15:48:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Provide dummy
 implementations for trunk setters
Message-ID: <YAGrRJYRpWg/4Yl5@lunn.ch>
References: <20210115105834.559-1-tobias@waldekranz.com>
 <20210115105834.559-2-tobias@waldekranz.com>
 <YAGnBqB08wwWQul8@lunn.ch>
 <20210115143649.envmn2ncazcikdmc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115143649.envmn2ncazcikdmc@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 04:36:49PM +0200, Vladimir Oltean wrote:
> On Fri, Jan 15, 2021 at 03:30:30PM +0100, Andrew Lunn wrote:
> > On Fri, Jan 15, 2021 at 11:58:33AM +0100, Tobias Waldekranz wrote:
> > > Support for Global 2 registers is build-time optional.
> > 
> > I was never particularly happy about that. Maybe we should revisit
> > what features we loose when global 2 is dropped, and see if it still
> > makes sense to have it as optional?
> 
> Marvell switch newbie here, what do you mean "global 2 is dropped"?

I was not aware detect() actually enforced it when needed. It used to
be, you could leave it out, and you would just get reduced
functionality for devices which had global2, but the code was not
compiled in.

At the beginning of the life of this driver, i guess it was maybe
25%/75% without/with global2, so it might of made sense to reduce the
binary size. But today the driver is much bigger with lots of other
things which those early chips don't have, SERDES for example. And
that ratio has dramatically reduced, there are very few devices
without those registers. This is why i think we can make our lives
easier and make global2 always compiled in.

       Andrew
