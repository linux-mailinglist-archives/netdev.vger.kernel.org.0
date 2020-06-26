Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632CA20B035
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgFZLIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728232AbgFZLIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:08:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91111C08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sguC2IO+WS6y8vdHiPzB3Xzc4MNtCRW4hWq5VsWYfU8=; b=s0TDJ0hDx0gEaAqLFJw1crWmu
        hoNq6eQdEsO/MfStJnvLNfpmide33VqYrshlEe23w8k+YUyQXd2H9FmjvYv3soaM0ape4fRZSd95P
        u7sX7iO4QPH/GS53c0oulDGkmHjbFE+1NYIqv3ZVMQvc7OaHzuqqQUEHSAPDDSn78fw/rgxBi4KWJ
        yFzvnslxAjyJrEbLVbQkYvYcB2Cg2YWXGEQJzcFp2sLWLpzbZL0tyrqd27lTluXFxkVql/oXfkFVB
        G4Z3c1FOgacHZiXO5lsvdJW3qFJQZZaWfhf7tVzSHOI2R/1iFXdx0T1+11wxsZ/eycnuV6WvRHS9+
        HpvWPUecQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59992)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jomDg-0005Cv-Hd; Fri, 26 Jun 2020 12:08:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jomDc-00040h-NI; Fri, 26 Jun 2020 12:08:28 +0100
Date:   Fri, 26 Jun 2020 12:08:28 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 5/7] net: dsa: felix: delete
 .phylink_mac_an_restart code
Message-ID: <20200626110828.GO1551@shell.armlinux.org.uk>
References: <20200625152331.3784018-1-olteanv@gmail.com>
 <20200625152331.3784018-6-olteanv@gmail.com>
 <20200625165349.GI1551@shell.armlinux.org.uk>
 <CA+h21hqn0P6mVJd1o=P1qwmVw-E56-FbY0gkfq9KurkRuJ5_hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqn0P6mVJd1o=P1qwmVw-E56-FbY0gkfq9KurkRuJ5_hQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 11:53:24AM +0300, Vladimir Oltean wrote:
> Hi Russell,
> 
> On Thu, 25 Jun 2020 at 19:53, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Thu, Jun 25, 2020 at 06:23:29PM +0300, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > In hardware, the AN_RESTART field for these SerDes protocols (SGMII,
> > > USXGMII) clears the resolved configuration from the PCS's
> > > auto-negotiation state machine.
> > >
> > > But PHYLINK has a different interpretation of "AN restart". It assumes
> > > that this Linux system is capable of re-triggering an auto-negotiation
> > > sequence, something which is only possible with 1000Base-X and
> > > 2500Base-X, where the auto-negotiation is symmetrical. In SGMII and
> > > USXGMII, there's an AN master and an AN slave, and it isn't so much of
> > > "auto-negotiation" as it is "PHY passing the resolved link state on to
> > > the MAC".
> >
> > This is not "a different interpretation".
> >
> > The LX2160A documentation for this PHY says:
> >
> >   9             Restart Auto Negotiation
> >  Restart_Auto_N Self-clearing Read / Write command bit, set to '1' to
> >                 restart an auto negotiation sequence. Set to '0'
> >                 (Reset value) in normal operation mode. Note: Controls
> >                 the Clause 37 1000Base-X Auto-negotiation.
> >
> > It doesn't say anything about clearing anything for SGMII.
> >
> > Also, the Cisco SGMII specification does not indicate that it is
> > possible to restart the "autonegotiation" - the PHY is the controlling
> > end of the SGMII link.  There is no clause in the SGMII specification
> > that indicates that changing the MAC's tx_config word to the PHY will
> > have any effect on the PHY once the data path has been established.
> >
> > Finally, when a restart of negotiation is requested, and we have a PHY
> > attached in SGMII mode, we will talk to that PHY to cause a restart of
> > negotiation on the media side, which will implicitly cause the link
> > to drop and re-establish, causing the SGMII side to indicate link down
> > and subsequently re-establish according to the media side results.
> >
> > So, please, lay off your phylink bashing in your commit messages.
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 
> Sorry, I was in a bit of a hurry when writing this commit message, so it is a
> bit imprecise as you point out. How about:

This is going over the top - most of this content should have been in a
discussion on the topic several months ago when this was first raised.
I accept that the SGMII link can be renegotiated from the MAC end, but
I still assert that it is pointless.

I've tried it here on the LX2160 with a Copper SFP plugged in that has a
Marvell 88E1111 PHY on-board, which I can monitor both the media and
SGMII side at the 88E1111 PHY.

Sure enough, if I set bit 9 in the LX2160 PCS, and monitor the "fiber"
page in the 88E1111, it reports that the link did drop.  However, that's
as far as the "renegotiation" goes - the link on the media side (as I've
said multiple times) does not renegotiate.

People expect the media side to renegotiate when they issue
"ethtool -r $IFACE" and this is what the phylink_mac_an_restart() method
is there for.  It caters for the case where is no other PHY as there is
with a copper link, the media terminating PHY is the MAC PCS PHY, as it
is for 1000BASE-X, and therefore the only place that media negotiation
can be restarted is the MAC PCS PHY.

Also as I've said multiple times, if you trigger a renegotiation at the
PHY end, then you end up with the media side renegotiating, and a fresh
exchange (in fact, two exchanges) of link information over the SGMII
link.  This is what the user expects.

If we don't have access to the PHY, then restarting the SGMII link
config exchange doesn't provide any benefit - the inaccessible PHY
_still_ doesn't renegotiate on the media side just because the SGMII
side wanted to re-exchange the config information.

Everything I've covered above with respect to the usefulness of
restarting the SGMII exchange are points that I've previously brought
up.

So, what practical use does triggering a fresh exchange of the SGMII
link configuration from the MAC side have?  The only use I can see is
if the SGMII MAC PCS is unreliable due to some hardware issue, doesn't
receive the link information correctly from the PHY, and needs manual
intervention from the MAC PCS side to "pursuade" it to get the correct
link information.  At that point we're into a severly unreliable
implementation that would likely be unsuitable for production systems.

I have no problem allowing other interface types to pass through _if_ it
can be shown that there is a proper practical use and benefit for doing
so, rather than just "the hardware lets us do this".

If we start allowing it for SGMII, we would be triggering a restart of
that configuration passing from both ends of the SGMII at a very similar
time - we would request the PHY to renegotiate, which triggers a fresh
exchange on the SGMII side when the media link fails, and we will also
be hitting the MAC PCS with its own "AN restart".  That doesn't sound
sane.  Depending on the timing, that could mean we end up with the MAC
PCS reporting _three_ different results: one from the local AN restart,
one from the link dropping, and one from the subsequent link
re-establishment.

So, I ask again, what practical use and benefit does restarting the
configuration exchange on a SGMII or USXGMII link have?  Give me a real
life use case where there's a problem with a link that this can solve.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
