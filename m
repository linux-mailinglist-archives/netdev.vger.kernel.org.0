Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48215293F1B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 16:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394412AbgJTO6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 10:58:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394403AbgJTO6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 10:58:52 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUt5z-002g9m-64; Tue, 20 Oct 2020 16:58:39 +0200
Date:   Tue, 20 Oct 2020 16:58:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] net: dsa: mv88e6xxx: Don't force link when using
 in-band-status
Message-ID: <20201020145839.GG139700@lunn.ch>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
 <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
 <20201020101552.GB1551@shell.armlinux.org.uk>
 <20201020154940.60357b6c@nic.cz>
 <20201020140535.GE139700@lunn.ch>
 <20201020141525.GD1551@shell.armlinux.org.uk>
 <20201020165115.3ecfd601@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020165115.3ecfd601@nic.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > It's still there. The speed/duplex etc are read from the serdes PHY
> > via mv88e6390_serdes_pcs_get_state(). When the link comes up, we
> > pass the negotiated link parameters read from there to the link_up()
> > functions. For ports where mv88e6xxx_port_ppu_updates() returns false
> > (no external PHY) we update the port's speed and duplex setting and
> > (currently, before this patch) force the link up.
> > 
> > That was the behaviour before I converted the code, the one that you
> > referred to. I had assumed the code was correct, and _none_ of the
> > speed, duplex, nor link state was propagated from the serdes PCS to
> > the port on the 88E6390 - hence why the code you refer to existed.
> > 

Chris

Do you get an interrupt when the link goes up? Since there are no
SERDES registers, there is no specific SERDES interrupt. But maybe the
PHY interrupt in global 2 fires? If you can use that, you can then be
more in line with the other implementations and not need this change.

     Andrew
