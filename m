Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2194046BEA8
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238458AbhLGPLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:11:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233627AbhLGPLA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 10:11:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/OdLoZjTTMJDDfgYw0OkpvRERft5RL+TCCydK9N7Vd4=; b=K1ltR7VwYZ867fnJK52t1aG0DJ
        ejZMG6Y/v8MeSfRlEga9QDmFhbggR0cVrUv9kSRP3POygMM25/8PHZwr7ewekTwCy3jrUTe2VJKZs
        rgOBEnju8VRQdcHlQf3rpUbtpn0Bkgexyd+U/lWg3FV+enxlvT2e6/HaMJfDC5l2rCYg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muc3y-00Fmkv-GF; Tue, 07 Dec 2021 16:07:26 +0100
Date:   Tue, 7 Dec 2021 16:07:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net] net: dsa: mv88e6xxx: allow use of PHYs on CPU
 and DSA ports
Message-ID: <Ya94roatTK0y7t70@lunn.ch>
References: <E1muYBr-00EwOF-9C@rmk-PC.armlinux.org.uk>
 <Ya91rX5acIKQk7W0@lunn.ch>
 <Ya92klnTqoUpFvpo@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya92klnTqoUpFvpo@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 02:58:26PM +0000, Russell King (Oracle) wrote:
> On Tue, Dec 07, 2021 at 03:54:37PM +0100, Andrew Lunn wrote:
> > On Tue, Dec 07, 2021 at 10:59:19AM +0000, Russell King (Oracle) wrote:
> > > Martyn Welch reports that his CPU port is unable to link where it has
> > > been necessary to use one of the switch ports with an internal PHY for
> > > the CPU port. The reason behind this is the port control register is
> > > left forcing the link down, preventing traffic flow.
> > > 
> > > This occurs because during initialisation, phylink expects the link to
> > > be down, and DSA forces the link down by synthesising a call to the
> > > DSA drivers phylink_mac_link_down() method, but we don't touch the
> > > forced-link state when we later reconfigure the port.
> > > 
> > > Resolve this by also unforcing the link state when we are operating in
> > > PHY mode and the PPU is set to poll the PHY to retrieve link status
> > > information.
> > > 
> > > Reported-by: Martyn Welch <martyn.welch@collabora.com>
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > 
> > Hi Russell
> > 
> > It would be good to have a Fixes: tag here, to help with back porting.
> 
> Oh, I thought this was a new development, not a regression. Do you have
> a pointer to the earlier bits of the thread please, e.g. the message ID
> of the original report.

This all seems to be part of:

b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com

It looks like 5.15-rc3 has issues, but i suspect it goes back further.
I'm also assuming it is a regression, not that it never worked in the
first place. Maybe i'm wrong?

   Andrew
