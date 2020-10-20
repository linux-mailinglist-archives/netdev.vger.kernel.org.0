Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E790C293E1A
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 16:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407825AbgJTOFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 10:05:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36698 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407816AbgJTOFx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 10:05:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUsGd-002ftA-OS; Tue, 20 Oct 2020 16:05:35 +0200
Date:   Tue, 20 Oct 2020 16:05:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] net: dsa: mv88e6xxx: Don't force link when using
 in-band-status
Message-ID: <20201020140535.GE139700@lunn.ch>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
 <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
 <20201020101552.GB1551@shell.armlinux.org.uk>
 <20201020154940.60357b6c@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020154940.60357b6c@nic.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 03:49:40PM +0200, Marek Behun wrote:
> On Tue, 20 Oct 2020 11:15:52 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > On Tue, Oct 20, 2020 at 04:45:56PM +1300, Chris Packham wrote:
> > > When a port is configured with 'managed = "in-band-status"' don't force
> > > the link up, the switch MAC will detect the link status correctly.
> > > 
> > > Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>  
> > 
> > I thought we had issues with the 88E6390 where the PCS does not
> > update the MAC with its results. Isn't this going to break the
> > 6390? Andrew?
> > 
> 
> Russell, I tested this patch on Turris MOX with 6390 on port 9 (cpu
> port) which is configured in devicetree as 2500base-x, in-band-status,
> and it works...
> 
> Or will this break on user ports?

User ports is what needs testing, ideally with an SFP.

There used to be explicit code which when the SERDES reported link up,
the MAC was configured in software with the correct speed etc. With
the move to pcs APIs, it is less obvious how this works now, does it
still software configure the MAC, or do we have the right magic so
that the hardware updates itself.

     Andrew
