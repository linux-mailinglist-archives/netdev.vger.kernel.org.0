Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB1B2147E0
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 20:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgGDSOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 14:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgGDSOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 14:14:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F58C061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 11:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UcaNHsEOjFq/+ZFedT/sz/tTYppspY+Tb/1PBFAUQAk=; b=lnG4qiv6WnU4O9PvR2PAF+X5O
        QL1wlZZbaVBd9XAbZb4JQJi67+YlWGqkUHerStCiDYXofLmqKHeaUyyggKzYmm1ZhCaLzCnL2DlP9
        ASI6Yq2dEMtmvsvMtzv1eFglp8h1HBH9QnRSUTmOycDwmwwX/HKJjgymDkw2pf69XblegK4k9Zb++
        WlqQ0jaya+W4tBLMqX8XXfFYgZ1L2EJej5cq/j5adjAAVkx5eXyjN3RCvOBBXgtfoznT4Df2dkj74
        dafm3gGvGZz+xBPBbrSw/8/cwceX/QohEYcUFEfZsdhvN7XqdxAl80UYUB1h0EoMqk3fypQw5rJD6
        zOvfuQO/Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35306)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jrmft-0004lT-KY; Sat, 04 Jul 2020 19:14:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jrmfp-00045q-I8; Sat, 04 Jul 2020 19:14:01 +0100
Date:   Sat, 4 Jul 2020 19:14:01 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH v2 net-next 5/6] net: dsa: felix: delete
 .phylink_mac_an_restart code
Message-ID: <20200704181401.GS1551@shell.armlinux.org.uk>
References: <20200704124507.3336497-1-olteanv@gmail.com>
 <20200704124507.3336497-6-olteanv@gmail.com>
 <20200704145613.GR1551@shell.armlinux.org.uk>
 <20200704155048.nsrzn4byujvkab3q@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200704155048.nsrzn4byujvkab3q@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 04, 2020 at 06:50:48PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 04, 2020 at 03:56:14PM +0100, Russell King - ARM Linux admin wrote:
> 
> [snip]
> 
> > 
> > NAK for this description.  You know why.
> > 
> > -- 
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 
> Sorry, I cannot work with "too busy" (your feedback from v1) and "you
> know why". If there's anything incorrect in the description of the
> patch, please point it out and I will change it.

Let's recap.

I have explained to you on numerous instances that:

- as part of the ethtool program, there is the facility to restart
  negotiation, which users expect to cause the media to renegotiate.

- when dealing with a link that involves a conventional copper PHY,
  irrespective of how that PHY is connected, this has always resulted
  in the copper PHY being requested to restart negotiation on the
  media side.

- in order to provide this same capability for fibre links where
  negotiation is supported, phylink provides the ability to pass that
  request to the PCS, since that is the media facing hardware block
  responsible for on-media negotiation.

- for SGMII, there is no advertisement from the MAC per-se, it is only
  an acknowledgement that the MAC has received the configuration word
  from the PHY.

It is also true that phylink uses this when there may be a change to
the PCS advertisement - again, to support the ability for the user to
change the media-side advertisement.  There is no media side
advertisement in SGMII at the MAC PCS.

There has been code in phylink that avoids calling the an_restart
methods since day one, as a result of the above.

Let's now look at the first version of your commit message:
| In hardware, the AN_RESTART field for these SerDes protocols (SGMII,
| USXGMII) clears the resolved configuration from the PCS's
| auto-negotiation state machine.
| 
| But PHYLINK has a different interpretation of "AN restart". It assumes
| that this Linux system is capable of re-triggering an auto-negotiation
| sequence, something which is only possible with 1000Base-X and
| 2500Base-X, where the auto-negotiation is symmetrical. In SGMII and
| USXGMII, there's an AN master and an AN slave, and it isn't so much of
| "auto-negotiation" as it is "PHY passing the resolved link state on to
| the MAC".
| 
| So, in PHYLINK's interpretation of "AN restart", it doesn't make sense
| to do anything for SGMII and USXGMII. In fact, PHYLINK won't even call
| us for any other SerDes protocol than 1000Base-X and 2500Base-X. But we
| are not supporting those. So just remove this code.

This comes over as blaming phylink for an interpretation of "AN
restart" that does not conform to your ideas.  While it is true that
phylink has a "different interpretation", that interpretation comes
from the interface that this callback is implementing, which is for
the user-level interface.  So, the "blame" that comes over in this
commit message is completely unjustified.

You also capitalised "PHYLINK" throughout this message for some reason,
which comes over as a stressed word (capitals is generally interpreted
as stress or shouting.)  Then there's "this Linux system" which sounds
a bit spiteful.

None of those things belong in a commit message, so I objected to it,
explicitly asking you to (quote) "So, please, lay off your phylink
bashing in your commit messages."

The replacement that you sent was worse - it continues this theme,
taking it further:

| The point is, both Cisco standards make explicit reference that they
| require an auto-negotiation state machine implemented as per "Figure
| 37-6-Auto-Negotiation state diagram" from IEEE 802.3. In the SGMII spec,
| it is very clearly pointed out that both the MAC PCS (Figure 3 MAC
| Functional Block) and the PHY PCS (Figure 2 PHY Functional Block)
| contain an auto-negotiation block defined by "Auto-Negotiation Figure
| 37-6".

Specifically, "The point is, ..." and "very clearly pointed out" are
completely unnecessary in a commit message, it gives a lecturing tone
to this text.  The lecturing tone continues throughout the entire text.

| PHYLINK takes this fact a bit further, and since the fact that for
| SGMII/USXGMII, the MAC PCS conveys no new information to the PHY PCS
| (beyond acknowledging the received config word), does not have any use
| for permitting the MAC PCS to trigger a restart of the clause 37
| auto-negotiation.

Again, it is not phylink that "takes this fact a bit further".  Phylink
is implementing the needs of userspace via this callback, which is to
cause autonegotiation to restart on the media.

| The only SERDES protocols for which PHYLINK allows that are 1000Base-X
| and 2500Base-X. For those, the control information exchange _is_
| bidirectional (local PCS specifies its duplex and flow control
| abilities) since the link partner is at the other side of the media.

This avoids the point that I have been making for a long time now
about what phylink is doing here.

Let me re-cap: phylink implements what is required to support the
network driver in implementing the what the user expects from the APIs
exposed by the kernel. One of the APIs is to restart negotiation, which
is generally accepted to mean the on-media negotiation, rather than
whatever internal negotiation happens within their "network interface".

Hence, it is appropriate that phylink restricts this to situations
where it is known that the media link is terminated on hardware that
phylink is responsible for.

At the moment, the known cases are:
- at the phylib PHY when dealing with conventional twisted pair cabling.
- at the phylib PHY where one is involved in a fibre link.
- at the PCS, where one is involved in a fibre link (which means
  1000base-X or 2500base-X.)

Since SGMII and USXGMII are designed for use between a PHY and the
host system (hence internal to the network interface), rather than over
some user accessible media, there is little point universally making
that call in response to a user request to restart the media
negotiation.

There is two final points to make:

- if we discover a requirement where we need to restart SGMII or
  USXGMII at the MAC PCS end (thank you for showing me that it is
  possible) then, yes, we will have to revisit how we deal with this.
  Yes, we may wish the callback to restart SGMII and USXGMII at that
  point.  However, we do not want to do that if the user requests a
  media side renegotiation.  As I have already explained, restarting
  negotiation on the media side at the PHY will cause a fresh exchange
  - not once, but twice - on the SGMII and USXGMII side anyway, which
  will refresh the configuration.

  The exception to that is if we have a buggy SGMII or USXGMII
  implementation - and, again, when we have such a scenario, that is
  the time to adapt.

- changing the behaviour now that we have several users without good
  reason is inviting regressions - there is the possibility for a state
  machine error if both ends of the link are hit for a renegotiation.
  Yes, I'm being cautious there, but there is always risk to change,
  and if there is no benefit from making that change then it stands to
  reason that there is no net benefit from making that change.

So, to sum up, your commit message _only_ needs to describe the change
you are making.  You should not lecture in a commit message, and you
should use neutral language.

If there is something lacking in the understanding of the callback,
the right place to fix that is in the documentation within the kernel,
not buried in some commit message for some obscure driver that no one
is going to even look at while developing their own driver.  Even so,
such documentation should clearly but briefly explain what is going on.

I have just spent the last 1h40 composing this message - I've put a lot
of thought into it. I obviously do not have the capacity to do that all
the time.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
