Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691A957EC64
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 09:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiGWHNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 03:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiGWHNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 03:13:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA3CE0F9;
        Sat, 23 Jul 2022 00:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/yFpbi2PQFvsU2FBSncbCiZSApnDaiRDxq8vxsMzG4M=; b=D7BwgEjIPeVQoCQNqC/aSIZVNa
        iTgki+jmrXsv1lmX7tfDaeNCg7RdFKwVhfBlLIcpjcdgCJhlFOTUsiDvD5yYdOin/6ji+ZNCX0UTl
        NN0nKrQqN5nJipwGHTjVRiFSOEPksOL7VJKMMZV7pPMZtylItMhLel+c+/6LyNPXW7hJlSWCLmPSQ
        QV6THsKQTfC8cVe0Jvrqh3+xFZRKdQXZvCzDeSMG9o520botVn+oKzBBHoIdjDpBZSaremsYU88p1
        AFCuvO84DD+zil+QEl5y+usTZ3/XRJDcFc5X3k2NS18lhcF0dSUNQcw0I/OVR/f/Ov5j8OeUXMQ+Y
        5G0pKfMQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33526)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oF9JR-00009k-IZ; Sat, 23 Jul 2022 08:12:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oF9Iy-0006aw-KH; Sat, 23 Jul 2022 08:12:04 +0100
Date:   Sat, 23 Jul 2022 08:12:04 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <YtufRO+oeQgmQi57@shell.armlinux.org.uk>
References: <20220721213645.57ne2jf7f6try4ec@skbuf>
 <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
 <20220722105238.qhfq5myqa4ixkvy4@skbuf>
 <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
 <20220722124629.7y3p7nt6jmm5hecq@skbuf>
 <YtqjFKUTsH4CK0L+@shell.armlinux.org.uk>
 <20220722165600.lldukpdflv7cjp4j@skbuf>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
 <20220722223932.poxim3sxz62lhcuf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722223932.poxim3sxz62lhcuf@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 01:39:32AM +0300, Vladimir Oltean wrote:
> On Fri, Jul 22, 2022 at 10:20:05PM +0100, Russell King (Oracle) wrote:
> > > > > What is hard for me to comprehend is how we ever came to conclude that
> > > > > for SERDES protocols where clause 37 is possible (2500base-x should be
> > > > > part of this group), managed = "in-band-status" does not imply in-band
> > > > > autoneg, considering the mvneta precedent.
> > > > 
> > > > That is a recent addition, since the argument was made that when using
> > > > a 1000base-X fibre transceiver, using ethtool to disable autoneg is a
> > > > reasonable thing to do - and something that was supported with
> > > > mvneta_ethtool_set_link_ksettings() as it stands at the point in the
> > > > commit above.
> > > 
> > > I'm sorry, I don't understand. What is the recent addition, and recent
> > > relative to what? The 2500base-x link mode? Ok, but this is only
> > > tangentially related to the point overall, more below.
> > 
> > I'm talking about how we handle 1000base-X autoneg - specifically this
> > commit:
> > 
> > 92817dad7dcb net: phylink: Support disabling autonegotiation for PCS
> > 
> > where we can be in 1000base-X with managed = "in-band-status" but we
> > have autoneg disabled. I thought that is what you were referring to.
> 
> So the correction you're persistently trying to make is:
> managed = "in-band-status" does *not* necessarily imply in-band autoneg
> being enabled, because the user can still run "ethtool -s eth0 autoneg off"
> ?

Correct.

> | | The way I understand what you're saying is that there is no guarantee
> | | that the DSA master and CPU port will agree whether to use in-band
> | | autoneg or not here (and implicitly, there is no guarantee that this
> | | link will work):
> | |
> | |       &eth0 {
> | |               phy-mode = "2500base-x";
> | |               managed = "in-band-status";
> | |       };
> | |
> | |       &switch_cpu_port {
> | |               ethernet = <&eth0>;
> | |               phy-mode = "2500base-x";
> | |               managed = "in-band-status";
> | |       };
> | 
> | Today, there is no guarantee - because it depends on how people have
> | chosen to implement 2500base-X, and whether the hardware requires the
> | use of in-band AN or prohibits it. This is what happens when stuff
> | isn't standardised - one ends up with differing implementations doing
> | different things, and this has happened not _only_ at hardware level
> | but also software level as well.
> 
> If there is no guarantee that the above will (at least try) to use in-band
> autoneg, it means that there is someone who decided, when he coded up
> the driver, that managed = "in-band-status" doesn't imply using in-band
> autoneg. That's what I was complaining about: I don't understand how we
> got here. In turn, this came from an observation about the inband/10gbase-r
> not having any actual in-band autoneg (more about this at the very end).

We got here through cases such as the one I pointed out where I tried
to highlight the issue. Maybe something happened in the pcs-lynx case,
it's pretty hard to find the history via google now, because searching
there does not give all the different versions of the patch set.

Maybe it was some other PCS, I don't know. Same problem, searching
google is very patchy at finding the various versions of patchsets
that were submitted.

All I know is that at some point I gave up pointing the issue out.

pcs-lynx today does issue an error. pcs-xpcs doesn't, it just turns
off AN no matter what. I can't find the history via google for that.

> > and eventually I stopped caring about it, as it became pointless to
> > raise it anymore when we had an established mixture of behaviours. This
> > is why we have ended up with PCS drivers configuring for no AN for a
> > firmware description of:
> > 
> > 	managed = "in-band-status";
> > 	phy-mode = "2500base-x";
> 
> Sorry, I don't get why?

Why what? Why I stopped caring about this issue? Or Why we ended up
with drivers configuring the above without AN? I think for the latter
I've explained how we got here. For the former, it's the feeling that
my comments were being ignored or just lead to arguments, so I stopped
bothering.

> > I still don't understand your point - because you seem to be conflating
> > two different things (at least as I understand it.)
> > 
> > We have this:
> > 
> > 		port@N {
> > 			reg = <N>;
> > 			label = "cpu";
> > 			ethernet = <&ethX>;
> > 		};
> > 
> > This specifies that the port operates at whatever interface mode and
> > settings gives the maximum speed. There is no mention of a "managed"
> > property, and therefore (Andrew, correct me if I'm wrong) in-band
> > negotiation is not expected to be used.
> > 
> > The configuration of the ethX parameters on the other end of the link
> > are up to the system integrator to get right, and the actual behaviour
> > would depend on the ethernet driver. As I've said in previous emails,
> > there is such a thing as "AN bypass" that can be implemented,
> 
> Not everyone has AN bypass, try to assume that no one except mvneta does.

I think I said "can be implemented", meaning not everyone does.

> > and it can default to be enabled, and drivers can ignore that such a
> > bit even exists. So, it's possible that even with "managed" set to
> > "in-band-status" in DT, a link to such a DSA switch will still come up
> > even though we've requested in DT for AN to be used.
> > 
> > If an ethernet driver is implemented to strictly require in-band AN in
> > this case, then the link won't come up, and the system integrator would
> > have to debug the problem.
> > 
> > I think this is actually true on Clearfog - if one specifies the CPU
> > port as I have above, and requests in-band on the host ethernet, then
> > the link doesn't come up, because mvneta turns off AN bypass.
> 
> So what am I conflating in this case?

You seem to think that the above DT stanza can end up with in-band AN
enabled.

> > > Thanks for this explanation, if nothing else, it seems to support the
> > > way in which I was interpreting managed = "in-band-status" to mean
> > > "enable in-band autoneg", but to be clear, I wasn't debating something
> > > about the way in which mvneta was doing things. But rather, I was
> > > debating why would *other* drivers do things differently such as to come
> > > to expect that a fixed-link master + an in-band-status CPU port, or the
> > > other way around, may be compatible with each other.
> > 
> > Please note that phylink makes a DT specification including both a
> > fixed-link descriptor and a managed in-band-status property illegal
> > because these are two different modes of operating the link, and they
> > conflict with each other.
> 
> Ok, thank you for this information which I already knew, what is the context?

FFS. You're the one who's writing emails to me that include *both*
"fixed-link" and "in-band-status" together. I'm pointing out that
specifying that in DT for a port together is not permitted.

And here I give up reading this email. Sorry, I'm too frustrated
with this nitpicking, and too frustrated with spending hours writing a
reply only to have it torn apart.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
