Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F432FAA29
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437366AbhART2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:28:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46606 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437318AbhART0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 14:26:55 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l1aAG-001Kh2-Gf; Mon, 18 Jan 2021 20:26:12 +0100
Date:   Mon, 18 Jan 2021 20:26:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Chris Healy <cphealy@gmail.com>, Marek Behun <marek.behun@nic.cz>,
        netdev <netdev@vger.kernel.org>
Subject: Re: bug: net: dsa: mv88e6xxx: serdes Unable to communicate on fiber
 with vf610-zii-dev-rev-c
Message-ID: <YAXg1D7FEHpqNrfD@lunn.ch>
References: <CAFXsbZodM0W87aH=qeZCRDSwyNOAXwF=aO8zf1UpkhwNkSAczA@mail.gmail.com>
 <20200718164239.40ded692@nic.cz>
 <CAFXsbZoMcOQTY8HE+E359jT6Vsod3LiovTODpjndHKzhTBZcTg@mail.gmail.com>
 <20200718150514.GC1375379@lunn.ch>
 <20200718172244.59576938@nic.cz>
 <CAFXsbZrHRexg5zAsR1cah4p8HAZVc3tjKdMGKWO6Ha4jXux3QA@mail.gmail.com>
 <8735yykv88.fsf@waldekranz.com>
 <YAXILTCNepv8eZnj@lunn.ch>
 <87zh16jfxd.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh16jfxd.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> I am seeing the exact same issue. I have tried both a 1000base-x SFP and
> >> a copper 1000base-T and get the same result on both - transmit is fine
> >> but rx only works up to the SERDES, no rx MAC counters are moving.
> >
> > Hi Tobias
> >
> > We never tracked this down. I spent many hours bashing my head against
> > this. I could not bisect it, which did not help.
> 
> Well that is disheartening :) "I could not bisect it", does that mean
> that it did work at some point but your CPU platform was not supported
> far enough back, or has it never worked?

As far as i remember, Ports 9 and 10 did work once. I suspect it could
of been early on, before we had much support for the SERDES, it relied
on the strapping being correct, and the switch powering up in the
right mode.

We also do a dance with the cmode of ports 9 and 10, dropping them
down to slower speeds making the SERDES available for the other ports
and then changing the cmode again if the port is supposed to use a
higher speed and needs multiple SERDESes.

The board which had trouble and i was debugging on only has limited
support, not going back too far. I would probably need to reproduce
the issue on different hardware to have more scope for going backwards
and trying to find a setup where ports 9 or 10 did work, as a basis
for a bisect.

    Andrew
