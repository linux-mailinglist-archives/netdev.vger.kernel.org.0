Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A4646AB41
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 23:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353293AbhLFWQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 17:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239517AbhLFWQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 17:16:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58640C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 14:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Jmr9hN1GkOWyHO5YKqbe3zLPVOEq+Bi0CKhGTeJVlnk=; b=1LJhwOUqV4+wRrWbXyQBCjmu22
        rOPf7nhkzyZJ78zokTtji4SWYSg+iiMWxpV1JBRQD9I6ozfFUuBwyMixuh7ofC78bRoKgkwmgL+w2
        BLl9ADiSp/TSPCqDxyCE+31w+yqXhqrVg7pYJQ21aRVAhJMtm37701Uz9bcbFWzxSWputVpdIGrXI
        PnxM46dEx2W6ijMJLrLPNMql5srAHQsWVKBfTb9DM0xqDCJAzDssgmRwKKAR9uk5EhjKj0g1Qm0CZ
        GFAYHM3sHIQ2IEaBmhtzxZPcZ0LP4ahZCroR7kosxjUx4le9QxKrJvyxQFJHFi/2w/T529BN7+1In
        oOFwNJlQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56122)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muMEd-0005SQ-6W; Mon, 06 Dec 2021 22:13:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muMEc-0004hq-8h; Mon, 06 Dec 2021 22:13:22 +0000
Date:   Mon, 6 Dec 2021 22:13:22 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya6LAmB3GswfYqB7@shell.armlinux.org.uk>
References: <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5qSoNhJRiSif/U@lunn.ch>
 <20211206200111.3n4mtfz25fglhw4y@skbuf>
 <Ya5wFvijUQVwvat7@shell.armlinux.org.uk>
 <20211206214428.qaavetaml2thggqo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206214428.qaavetaml2thggqo@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 11:44:28PM +0200, Vladimir Oltean wrote:
> On Mon, Dec 06, 2021 at 08:18:30PM +0000, Russell King (Oracle) wrote:
> > > If we're going to impersonate phylink we could at least provide the same
> > > arguments as phylink will.
> > 
> > What is going on here in terms of impersonation is entirely reasonable.
> > 
> > The only things in this respect that phylink guarantees are:
> > 
> > 1) The MAC/PCS configuration will not be substantially reconfigured
> >    unless a call to mac_link_down() was made if a call to mac_link_up()
> >    was previously made.
> 
> The wording here is unclear. Did you mean "When the MAC/PCS configuration
> is substantially reconfigured and the last call was a mac_link_up(), a
> follow-up call to mac_link_down() will also be made"?
> And what do you mean by "substantially reconfigured"?

I mean what the documentation refers to as a "full initialisation" of
the link, which happens if we have to change the interface mode or
MLO_AN mode. Only minor changes (advertisements or pause modes if under
manual control) will be changed without a prior call to mac_link_down().

For example, phylink will _never_ do:

mac_link_up()
mac_prepare()
mac_config()
pcs_config()
mac_finish()
mac_link_up()

However, with legacy (pre-March 2020) users, it _may_ do:

mac_link_up()
mac_config() (e.g. changing the in-band advertisement)
mac_an_restart()

The problem here is the legacy stuff which clouds the picture by making
extra calls to mac_config() when we're only changing things like the
in-band advert.

> phylink_major_config called from the paths that aren't phylink_mac_initial_config
> (because that happens with no preceding call to either mac_link_down or
> mac_link_up), right?

Where we call phylink_major_config(), we ensure that if we know the link
was previously up, we make a call to mac_link_down() first.

> > 2) The arguments to mac_link_down() will be the same as the preceeding
> >    mac_link_up() call - in other words, the "mode" and "interface".
> 
> Does this imply that "there will always be a preceding mac_link_up to
> every mac_link_down call"?

From the design of phylink, yes it does, since phylink assumes that the
link is initially down.

> Because if it does imply that, DSA violates it.

Yes, DSA violates that, but DSA is free to do that if it makes sense,
and from what I understand of DSA, this is a special case. From what
I've seen with Marvell DSA, they start off auto-configuring the
inter-switch and CPU ports in link-up mode, whereas phylink assumes
that the link is down.

When DSA sets stuff up and brings up the CPU port, the very first
thing that phylink does is reconfigure the port - but the port is in
link-up mode, and that can mess up the port. So Andrew introduced
this to fix it. See commit 3be98b2d5fbc.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
