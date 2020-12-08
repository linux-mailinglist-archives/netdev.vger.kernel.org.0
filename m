Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54592D2088
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbgLHCMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:12:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43306 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbgLHCMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 21:12:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kmSTT-00AjgY-LL; Tue, 08 Dec 2020 03:11:31 +0100
Date:   Tue, 8 Dec 2020 03:11:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jean Pihet <jean.pihet@newoldbits.com>
Cc:     netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>
Subject: Re: [PATCH v2] net: dsa: ksz8795: adjust CPU link to host interface
Message-ID: <20201208021131.GE2475764@lunn.ch>
References: <20201201083408.51006-1-jean.pihet@newoldbits.com>
 <20201201184100.GN2073444@lunn.ch>
 <CAORVsuXv5Gw18EeHwP36EkzF4nN5PeGerBQQa-6ruWAQRX+GoQ@mail.gmail.com>
 <20201201204516.GA2324545@lunn.ch>
 <CAORVsuXtVYKh_nCvCdA7PUWJeJbVJWD43jtkiFwXeg2Qo1mG+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAORVsuXtVYKh_nCvCdA7PUWJeJbVJWD43jtkiFwXeg2Qo1mG+A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 08:43:32PM +0100, Jean Pihet wrote:
> Hi Andrew,
> 
> On Tue, Dec 1, 2020 at 9:45 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Configure the host port of the switch to match the host interface
> > > settings. This is useful when the switch is directly connected to the
> > > host MAC interface.
> >
> > Why do you need this when no other board does? Why is your board
> > special?
> >
> > As i said before, i'm guessing your board has back to back PHYs
> > between the SoC and the switch and nobody else does. Is that the
> > reason why? Without this, nothing is configuring the switch MAC to the
> > results of the auto-neg between the two PHYs?
> 
> Yes that is the case. From here I see this patch is too specific to
> our setup, and so cannot be considered for merging.

Hi Jean

I never said i was too specific to your board. There are other boards
using different switches like this. This is where the commit message
is so important. Without understanding Why? it is hard to point you in
the right direction.

So you setup is:

SoC - MAC - PHY - PHY - MAC - Switch.

The SoC MAC driver is looking after the first PHY?

This patch is about the Switch MAC and PHY. You need the results of
auto-neg from the PHY to be programmed into the MAC of the switch.

If i remember correctly you just need a phy-handle in the CPU node,
pointing at the PHY. See for example imx6q-b450v3.dts

	 Andrew
