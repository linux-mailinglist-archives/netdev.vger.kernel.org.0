Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7E62F6930
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbhANSNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:13:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbhANSNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 13:13:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0773-000bdx-Ad; Thu, 14 Jan 2021 19:12:49 +0100
Date:   Thu, 14 Jan 2021 19:12:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v4 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <YACJobqwDavtg25C@lunn.ch>
References: <20210113145922.92848-1-george.mccollister@gmail.com>
 <20210113145922.92848-3-george.mccollister@gmail.com>
 <20210114015659.33shdlfthywqdla7@skbuf>
 <CAFSKS=NU4hrnXB5FcAFvnFnmAtK5HfYR8dAKyw3cd=5UKOBNfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=NU4hrnXB5FcAFvnFnmAtK5HfYR8dAKyw3cd=5UKOBNfg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static int xrs700x_detect(struct xrs700x *dev)
> > > +{
> > > +     const struct xrs700x_info *info;
> > > +     unsigned int id;
> > > +     int ret;
> > > +
> > > +     ret = regmap_read(dev->regmap, XRS_DEV_ID0, &id);
> > > +     if (ret) {
> > > +             dev_err(dev->dev, "error %d while reading switch id.\n",
> > > +                     ret);
> > > +             return ret;
> > > +     }
> > > +
> > > +     info = of_device_get_match_data(dev->dev);
> > > +     if (!info)
> > > +             return -EINVAL;
> > > +
> > > +     if (info->id == id) {
> > > +             dev->ds->num_ports = info->num_ports;
> > > +             dev_info(dev->dev, "%s detected.\n", info->name);
> > > +             return 0;
> > > +     }
> > > +
> > > +     dev_err(dev->dev, "expected switch id 0x%x but found 0x%x.\n",
> > > +             info->id, id);
> >
> > I've been there too, not the smartest of decisions in the long run. See
> > commit 0b0e299720bb ("net: dsa: sja1105: use detected device id instead
> > of DT one on mismatch") if you want a sneak preview of how this is going
> > to feel two years from now. If you can detect the device id you're
> > probably better off with a single compatible string.
> 
> Previously Andrew said:
> "Either you need to verify the compatible from day one so it is not
> wrong, or you just use a single compatible "arrow,xrs700x", which
> cannot be wrong."
> 
> I did it the first way he suggested, if you would have replied at that
> time to use a single that's the way I would have done it that way.
> 
> If you two can agree I should change it to a single string I'd be
> happy to do so.

I'm happy both ways. Marvell uses just on compatible, and has worked
fine. Other drivers have specific compatible strings, and enforce the
match, and that has also worked fine.

So it is really up to you.

   Andrew
