Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22182519BA
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgHYNdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:33:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49194 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgHYNdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 09:33:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kAZ4V-00Bm6q-Ec; Tue, 25 Aug 2020 15:33:07 +0200
Date:   Tue, 25 Aug 2020 15:33:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Scott Dial <scott@scottdial.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Ryan Cox <ryan_cox@byu.edu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: Re: Severe performance regression in "net: macsec: preserve ingress
 frame ordering"
Message-ID: <20200825133307.GP2588906@lunn.ch>
References: <1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu>
 <a335c8eb-0450-1274-d1bf-3908dcd9b251@scottdial.com>
 <20200810133427.GB1128331@bistromath.localdomain>
 <7663cbb1-7a55-6986-7d5d-8fab55887a80@scottdial.com>
 <20200812100443.GF1128331@bistromath.localdomain>
 <CY4PR0401MB36524B348358B23A8DFB741AC3420@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200812124201.GF2154440@lunn.ch>
 <CY4PR0401MB365240B04FC43F7F8AAE6A0CC3560@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200824130142.GN2588906@lunn.ch>
 <CY4PR0401MB3652AB8C5DC2FEA09A6F2BECC3570@CY4PR0401MB3652.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR0401MB3652AB8C5DC2FEA09A6F2BECC3570@CY4PR0401MB3652.namprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 01:09:31PM +0000, Van Leeuwen, Pascal wrote:
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Monday, August 24, 2020 3:02 PM
> > To: Van Leeuwen, Pascal <pvanleeuwen@rambus.com>
> > Cc: Sabrina Dubroca <sd@queasysnail.net>; Scott Dial <scott@scottdial.com>; linux-crypto@vger.kernel.org; Ryan Cox
> > <ryan_cox@byu.edu>; netdev@vger.kernel.org; davem@davemloft.net; Antoine Tenart <antoine.tenart@bootlin.com>;
> > ebiggers@google.com
> > Subject: Re: Severe performance regression in "net: macsec: preserve ingress frame ordering"
> >
> > <<< External Email >>>
> > On Mon, Aug 24, 2020 at 09:07:26AM +0000, Van Leeuwen, Pascal wrote:
> > > No need to point this out to me as we're the number one supplier of inline MACsec IP :-)
> > > In fact, the Microsemi PHY solution you mention is ours, major parts of that design were
> > > even created by these 2 hands here.
> >
> > Oh,  O.K.
> >
> > Do you know of other silicon vendors which are using the same IP?
> >
> I do, there are many. But unfortunately, I cannot disclose our customers unless this is already
> public information, e.g. due to some press release or whatever.

O.K. Maybe i should flip the question around. If somebody was to
submit a driver, how would i quickly determine it is your IP? Any
particularly patterns i should look for.

> > Maybe we can encourage them to share the driver, rather than re-invent
> > the wheel, which often happens when nobody realises it is basically
> > the same core with a different wrapper.
> >
> Yes, that could save a lot of duplication of code and effort.

It would save a lot of effort. But not code duplication. Because if i
or one of the other maintainers notices it is just your IP with a
different wrapper, we would NACK the patch and tell them to refactor
the MSCC driver. There is a long established precedence for that.

> The problem is: who will do it? We can't do it, because we have no
> access to the actual HW.

Microsemi are very friendly. If you ask them, i'm sure they would send
you a board. I assume you also have some sort of FPGA setup you use
for your own testing? That gives you two platforms. And if there are
many PHYs using your IP, it should not be too hard to just go buy a
reference design kit from a vendor.

And there is the marketing aspect for Rambus. You can say your IP is
easy to use, the core code is already in the kernel, supported and
well tested, you just need to add a few wrapper functions in your
driver. No vendor crap driver needed.

	Andrew
