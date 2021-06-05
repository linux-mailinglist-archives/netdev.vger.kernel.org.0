Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B6439CA31
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 19:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhFER0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 13:26:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229978AbhFER0p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 13:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Rb/7FWLnTAJZbXVyN6uKXRZaBP2+UHX3uFizerIdV+k=; b=Hx+4zQRsy3mBKDFMaqAsKRcMzg
        CJ+laIg1xzdNAaJ8hLeLaiqrrOp/O+Ww/u9qWkLJSjGFsfr9pVmI1T3RKG2mZKsvF4dFF5FHMKG69
        WTUc8LpUMHp600ZG3UPAu7ahHNDADSzFYZU3RDimBfhM1DCKvGknrHy9+DGwIbfT/zWA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpa2R-007wnO-P2; Sat, 05 Jun 2021 19:24:47 +0200
Date:   Sat, 5 Jun 2021 19:24:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YLuzX5EYfGNaosHT@lunn.ch>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <20210604194428.2276092-1-martin.blumenstingl@googlemail.com>
 <b01a8ac2-b77e-32aa-7c9b-57de4f2d3a95@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b01a8ac2-b77e-32aa-7c9b-57de4f2d3a95@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 03:32:39AM +0000, Liang Xu wrote:
> On 5/6/2021 3:44 am, Martin Blumenstingl wrote:
> > This email was sent from outside of MaxLinear.
> >
> >
> > Hello,
> >
> >> Add driver to support the Maxlinear GPY115, GPY211, GPY212, GPY215,
> >> GPY241, GPY245 PHYs.
> > to me this seems like an evolution of the Lantiq XWAY PHYs for which
> > we already have a driver: intel-xway.c.
> > Intel took over Lantiq some years ago and last year MaxLinear then
> > took over what was formerly Lantiq from Intel.
> >
> >  From what I can tell right away: the interrupt handling still seems
> > to be the same. Also the GPHY firmware version register also was there
> > on older SoCs (with two or more GPHYs embedded into the SoC). SGMII
> > support is new. And I am not sure about Wake-on-LAN.
> >
> > Have you considered adding support for these new PHYs to intel-xway.c?

The WOL interrupts are the same, which could imply WoL configuration
is the same? If it is the same, it would be good to also add WoL to
intel-xway.c.

What this new driver does not yet do is LEDs. It would be interesting
to see if the LED control is the same. Hopefully, one day, generic LED
support will get added. If this PHY and intel-xway.c has the same LED
code, we will want to share it.

> They are based on different IP and have many differences.

Please could you list the differences? Is the datasheet available?  I
found a datasheet for the XWAY, so it would be nice to be able to
compare them.

> The XWAY PHYs are going to EoL (or maybe already EoL).

That does not matter. They are going to be in use for the next 5 years
or more, until all the products using them have died or been
replaced. Linux supports hardware that is in use, not just what
vendors sell today.

> It creates difficulty for the test coverage to put together.

That also does not really matter. If somebody has both, does the work
to merge the drivers and overall we have less code and more features,
the patch will be accepted. 


	Andrew



