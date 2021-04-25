Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D137C36A7CE
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 16:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhDYOeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 10:34:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39878 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229906AbhDYOeV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 10:34:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lafpD-000zu0-0c; Sun, 25 Apr 2021 16:33:31 +0200
Date:   Sun, 25 Apr 2021 16:33:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] drivers: net: dsa: qca8k: apply switch revision fix
Message-ID: <YIV9unMmDMROD4sp@lunn.ch>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-12-ansuelsmth@gmail.com>
 <e644aba9-a092-3825-b55b-e0cca158d28b@gmail.com>
 <YISLHNK8binc9T1N@Ansuel-xps.localdomain>
 <20210425044554.194770-1-dqfext@gmail.com>
 <YIVZl9qbXLcCrqNl@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIVZl9qbXLcCrqNl@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 01:59:19PM +0200, Ansuel Smith wrote:
> On Sun, Apr 25, 2021 at 12:45:54PM +0800, DENG Qingfang wrote:
> > Hi Ansuel,
> > 
> > On Sat, Apr 24, 2021 at 11:18:20PM +0200, Ansuel Smith wrote:
> > > 
> > > I'm starting to do some work with this and a problem arised. Since these
> > > value are based on the switch revision, how can I access these kind of
> > > data from the phy driver? It's allowed to declare a phy driver in the
> > > dsa directory? (The idea would be to create a qca8k dir with the dsa
> > > driver and the dedicated internal phy driver.) This would facilitate the
> > > use of normal qca8k_read/write (to access the switch revision from the
> > > phy driver) using common function?
> > 
> > In case of different switch revision, the PHY ID should also be different.
> > I think you can reuse the current at803x.c PHY driver, as they seem to
> > share similar registers.
> >
> 
> Is this really necessary? Every PHY has the same ID linked to the switch
> id but the revision can change across the same switch id. Isn't the phy
> dev flag enought to differiante one id from another? 

Just as general background information: A PHY ID generally consists of
three parts.

1) OUI - Identifies the manufacture - 22 bits
2) device - Generally 6 bits
3) revision - Generally 4 bits

The 22 bits of OUI is standardized. But the last 10 bits the vendor
can use as they wish. But generally, this is how it is used.

Loading the PHY driver is generally based on matching the OUI and
device ID. The revision is ignored. But it is available to the driver
if needed.

It could be, the switch revision is also reflected in the PHY
revision.

	Andrew
