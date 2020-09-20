Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AAD2711AC
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 03:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgITBW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 21:22:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45692 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgITBW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 21:22:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJo3U-00FRHl-F7; Sun, 20 Sep 2020 03:22:16 +0200
Date:   Sun, 20 Sep 2020 03:22:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     ansuelsmth@gmail.com
Cc:     'Miquel Raynal' <miquel.raynal@bootlin.com>,
        'Richard Weinberger' <richard@nod.at>,
        'Vignesh Raghavendra' <vigneshr@ti.com>,
        'Rob Herring' <robh+dt@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Heiner Kallweit' <hkallweit1@gmail.com>,
        'Russell King' <linux@armlinux.org.uk>,
        'Frank Rowand' <frowand.list@gmail.com>,
        'Boris Brezillon' <bbrezillon@kernel.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: R: [PATCH v2 4/4] dt-bindings: net: Document use of
 mac-address-increment
Message-ID: <20200920012216.GE3673389@lunn.ch>
References: <20200919223026.20803-1-ansuelsmth@gmail.com>
 <20200919223026.20803-5-ansuelsmth@gmail.com>
 <20200920003128.GC3673389@lunn.ch>
 <006301d68ee6$87fcc400$97f64c00$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <006301d68ee6$87fcc400$97f64c00$@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 02:39:39AM +0200, ansuelsmth@gmail.com wrote:
> 
> 
> > -----Messaggio originale-----
> > Da: Andrew Lunn <andrew@lunn.ch>
> > Inviato: domenica 20 settembre 2020 02:31
> > A: Ansuel Smith <ansuelsmth@gmail.com>
> > Cc: Miquel Raynal <miquel.raynal@bootlin.com>; Richard Weinberger
> > <richard@nod.at>; Vignesh Raghavendra <vigneshr@ti.com>; Rob Herring
> > <robh+dt@kernel.org>; David S. Miller <davem@davemloft.net>; Jakub
> > Kicinski <kuba@kernel.org>; Heiner Kallweit <hkallweit1@gmail.com>;
> > Russell King <linux@armlinux.org.uk>; Frank Rowand
> > <frowand.list@gmail.com>; Boris Brezillon <bbrezillon@kernel.org>; linux-
> > mtd@lists.infradead.org; devicetree@vger.kernel.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org
> > Oggetto: Re: [PATCH v2 4/4] dt-bindings: net: Document use of mac-
> > address-increment
> > 
> > > +  mac-address-increment:
> > > +    description:
> > > +      The MAC address can optionally be increased (or decreased using
> > > +      negative values) from the original value readed (from a nvmem
> cell
> > 
> > Read is irregular, there is no readed, just read.
> > 
> > > +      for example). This can be used if the mac is readed from a
> dedicated
> > > +      partition and must be increased based on the number of device
> > > +      present in the system.
> > 
> > You should probably add there is no underflow/overflow to other bytes
> > of the MAC address. 00:01:02:03:04:ff + 1 == 00:01:02:03:04:00.
> > 
> > > +    minimum: -255
> > > +    maximum: 255
> > > +
> > > +  mac-address-increment-byte:
> > > +    description:
> > > +      If 'mac-address-increment' is defined, this will tell what byte
> of
> > > +      the mac-address will be increased. If 'mac-address-increment' is
> > > +      not defined, this option will do nothing.
> > > +    default: 5
> > > +    minimum: 0
> > > +    maximum: 5
> > 
> > Is there a real need for this? A value of 0 seems like a bad idea,
> > since a unicast address could easily become a multicast address, which
> > is not valid for an interface address. It also does not seem like a
> > good idea to allow the OUI to be changed. So i think only bytes 3-5
> > should be allowed, but even then, i don't think this is needed, unless
> > you do have a clear use case.
> > 
> >     Andrew
> 
> Honestly the mac-address-increment-byte is added to give user some control
> but I
> don't really have a use case for it. Should I limit it to 3 or just remove
> the function?

If you have no use case, just remove it and document that last byte
will be incremented. I somebody does need it, it can be added in a
backwards compatible way.

     Andrew
