Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C33F2D2CE3
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbgLHOQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:16:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729377AbgLHOQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 09:16:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kmdm3-00ApGj-QR; Tue, 08 Dec 2020 15:15:27 +0100
Date:   Tue, 8 Dec 2020 15:15:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jean Pihet <jean.pihet@newoldbits.com>
Cc:     netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>
Subject: Re: [PATCH v2] net: dsa: ksz8795: adjust CPU link to host interface
Message-ID: <20201208141527.GI2475764@lunn.ch>
References: <20201201083408.51006-1-jean.pihet@newoldbits.com>
 <20201201184100.GN2073444@lunn.ch>
 <CAORVsuXv5Gw18EeHwP36EkzF4nN5PeGerBQQa-6ruWAQRX+GoQ@mail.gmail.com>
 <20201201204516.GA2324545@lunn.ch>
 <CAORVsuXtVYKh_nCvCdA7PUWJeJbVJWD43jtkiFwXeg2Qo1mG+A@mail.gmail.com>
 <20201208021131.GE2475764@lunn.ch>
 <CAORVsuX9w_JHjM88YhT02k93vbF3SZmxwYt-E_Tth8xTP04V2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAORVsuX9w_JHjM88YhT02k93vbF3SZmxwYt-E_Tth8xTP04V2w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Jean
> >
> > I never said i was too specific to your board. There are other boards
> > using different switches like this. This is where the commit message
> > is so important. Without understanding Why? it is hard to point you in
> > the right direction.
> >
> > So you setup is:
> >
> > SoC - MAC - PHY - PHY - MAC - Switch.
> >
> > The SoC MAC driver is looking after the first PHY?
> 
> No, the connection is at the MAC level, via RGMII but it is missing the MDC/
> MDIO signals. That means we have to fix the auto-neg parameters from the DT.

So the PHY is there, but you cannot talk to it? It has strapping
resisters to make it auto-neg to the other PHY?

Some switches default their CPU port to the maximum speed the port can
do. But not all do. It is worth checking that.

> On the 4.14 LTS kernel we are working with, the setup of the parameters is done
> via adjust_link. Since the phylink conversion adjust_link is not required
> anymore, is this correct?

4.14 is dead in terms of development. Anything you contribute needs to
be for net-next, and then you need to figure out how to backport
it. Using v5.4 will help with that, since it is much closer, and v5.10
will be LTS. Given the change to phylink, you probably want as new a
kernel as possible. If you put a fixed-link property in the "CPU"
node, phylink should do the right thing for you.

      Andrew
