Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DB935D41B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344157AbhDLXpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:45:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46918 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238646AbhDLXpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 19:45:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lW6F9-00GNgC-9G; Tue, 13 Apr 2021 01:45:23 +0200
Date:   Tue, 13 Apr 2021 01:45:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, olteanv@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH net-next] net: dsa: lantiq_gswip: Add support for dumping
 the registers
Message-ID: <YHTbk3g2rM8zZZ5h@lunn.ch>
References: <20210411205511.417085-1-martin.blumenstingl@googlemail.com>
 <YHODYWgHQOuwoTf4@lunn.ch>
 <CAFBinCD9TV3F_AEMwH8WvqH=g2vw+1YAwGBr4M9_mnNwVuhwBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCD9TV3F_AEMwH8WvqH=g2vw+1YAwGBr4M9_mnNwVuhwBw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 12:24:49AM +0200, Martin Blumenstingl wrote:
> Hi Andrew,
> 
> On Mon, Apr 12, 2021 at 1:16 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Sun, Apr 11, 2021 at 10:55:11PM +0200, Martin Blumenstingl wrote:
> > > Add support for .get_regs_len and .get_regs so it is easier to find out
> > > about the state of the ports on the GSWIP hardware. For this we
> > > specifically add the GSWIP_MAC_PSTATp(port) and GSWIP_MDIO_STATp(port)
> > > register #defines as these contain the current port status (as well as
> > > the result of the auto polling mechanism). Other global and per-port
> > > registers which are also considered useful are included as well.
> >
> > Although this is O.K, there has been a trend towards using devlink
> > regions for this, and other register sets in the switch. Take a look
> > at drivers/net/dsa/mv88e6xxx/devlink.c.
> >
> > There is a userspace tool for the mv88e6xxx devlink regions here:
> >
> > https://github.com/lunn/mv88e6xxx_dump
> >
> > and a few people have forked it and modified it for other DSA
> > switches. At some point we might want to try to merge the forks back
> > together so we have one tool to dump any switch.
> actually I was wondering if there is some way to make the registers
> "easier to read" in userspace.

You can add decoding to ethtool. The marvell chips have this, to some
extent. But the ethtool API is limited to just port registers, and
there can be a lot more registers which are not associated to a
port. devlink gives you access to these additional registers.

      Andrew
