Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7519301E55
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 20:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbhAXTEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 14:04:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57012 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbhAXTEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 14:04:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l3kfs-002PbZ-3d; Sun, 24 Jan 2021 20:03:48 +0100
Date:   Sun, 24 Jan 2021 20:03:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH v2 RFC net-next 04/18] net: mvpp2: add PPv23
 version definition
Message-ID: <YA3ElJbfk9Km2HiF@lunn.ch>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-5-git-send-email-stefanc@marvell.com>
 <20210124131810.GZ1551@shell.armlinux.org.uk>
 <CO6PR18MB387343A510B3C5A9C5E004B2B0BE9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB387343A510B3C5A9C5E004B2B0BE9@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 01:55:42PM +0000, Stefan Chulski wrote:
> > > Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> > > ---
> > >  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 24 ++++++++++++------
> > --
> > >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 17 +++++++++-----
> > >  2 files changed, 25 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > > b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > > index aec9179..89b3ede 100644
> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > > @@ -60,6 +60,9 @@
> > >  /* Top Registers */
> > >  #define MVPP2_MH_REG(port)			(0x5040 + 4 * (port))
> > >  #define MVPP2_DSA_EXTENDED			BIT(5)
> > > +#define MVPP2_VER_ID_REG			0x50b0
> > > +#define MVPP2_VER_PP22				0x10
> > > +#define MVPP2_VER_PP23				0x11
> > 
> > Looking at the Armada 8040 docs, it seems this register exists on
> > PPv2.1 as well, and holds the value zero there.
> > 
> > I wonder whether we should instead read it's value directly into hw_version,
> > and test against these values, rather than inventing our own verison enum.
> > 
> > I've also been wondering whether your != MVPP21 comparisons should
> > instead be >= MVPP22.
> > 
> > Any thoughts?
> 
> We cannot access PPv2 register space before enabling clocks(done in mvpp2_probe) , PP21 and PP22/23 have different sets of clocks.

> So diff between PP21 and PP22/23 should be stored in device tree(in
> of_device_id), with MVPP22 and MVPP21 stored as .data

Hi Stefan

As far as i can see, you are not adding a new compatible. So
'marvell,armada-7k-pp2' means PPv2.2 and PPv2.3? It would be good to
update the comment at the beginning of marvell-pp2.txt to indicate
this.

	Andrew
