Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43AD220120
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 01:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgGNXq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 19:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgGNXq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 19:46:57 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609B0C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 16:46:57 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id w6so277959ejq.6
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 16:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ITtt5xCKLLydDGlNqBptMvRkeRTTrNx4Jtjb5LKFVBU=;
        b=IUfm+oFBVswO8fIQNZi4RO3+FH8zQ+oZY9p/k8P8F28hSAfA5CFfmp1E3mnt1BDbB/
         qFlkjoPYxaBpoxD5+i3PGhtPs2p9VQL8etZqLab5MrsvIxt77P6CN6HpsP8W92MrVwY1
         8jYuXqtOELNWgrX7hokCaOD1empPaSme9bT+V4zADAGVW9i9mL5zGK+mw/iMZftyflGH
         QROSgN00cG9MNApeB2sxiZAyoM1+yeVYx4aF67g6Bh6wFQuIGD8qv0AOcxCq37dX1dj7
         IqqPO31o4hRgVnMlWtWAro922xOz1B0pTOKZn4hDXoC2aYv7+HrH9snFUi+UW/QDfBu7
         WeFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ITtt5xCKLLydDGlNqBptMvRkeRTTrNx4Jtjb5LKFVBU=;
        b=tqlqZS5X0ghjer3QvLHBEpdaUCV91LGsBGMNCDOGSSSkCCByL51yKho677ims0IpEs
         TBSGxHuvS9nl8Z1aTs+C9uzHso+9FV0HHq9EmVvCAol38B5pYBOrebFLDh+tYaQgkfab
         YfZkim7+m4cMTTyJpOQt5TzqhAyKrQGdxdNZVA8JX0x5HcPFu7L4D2ym7o8ouHWFCzsf
         H2rN3hVeyXGlmxBhneXhEDw7d3uYSJMruQx8ULNTiRNhZ70T+R7mS+8GYaiuXHVk+njA
         kCKBxDDUVEEFKixsfDBT8IE0Six5Ku1WH5Gf4wpWBn0IltTC4PnrDfaImPmE79woi36C
         tfoA==
X-Gm-Message-State: AOAM530/AHPJk65lZ0FTjoL7ogks9y9c6JVKU3pLN/KTiG3fwtNGFXAK
        7haojL33uBZKHaIU8XVH2A3mOG/f
X-Google-Smtp-Source: ABdhPJxjppEGHdDKo3Inyqvh2LnURNJfMQB0+7Fqhizn3x56AG8yruthD4Wic0mZjG1z8gsARW/kYA==
X-Received: by 2002:a17:906:8392:: with SMTP id p18mr7166422ejx.24.1594770415696;
        Tue, 14 Jul 2020 16:46:55 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id h10sm288035eds.0.2020.07.14.16.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 16:46:54 -0700 (PDT)
Date:   Wed, 15 Jul 2020 02:46:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "michael@walle.cc" <michael@walle.cc>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 00/13] Phylink PCS updates
Message-ID: <20200714234652.w2pw3osynbuqw3m4@skbuf>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <20200714084958.to4n52cnk32prn4v@skbuf>
 <20200714131832.GC1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714131832.GC1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'll preface my reply by stating that this is my opinion and that it is
not representative of what you might be visualizing as "NXP".
It's not that I am trying to evade responsibility by saying this, but
rather that backplane Ethernet is simply not my responsibility, in fact
I have no saying at all when it comes to decision making there. I am
simply trying to get a better understanding for myself, especially of
the design goals of phylink.

On Tue, Jul 14, 2020 at 02:18:32PM +0100, Russell King - ARM Linux admin wrote:
> 
> I'd actually given up pushing this further; I've seen patches go by that
> purpetuate the idea that the PCS is handled by phylib.  I feel like I'm
> wasting my time with this.
> 

By this I think you are aiming squarely at "[PATCH net-next v3 0/9] net:
ethernet backplane support on DPAA1". If I understand you correctly, you
are saying that because of the non-phylink models used to represent that
system comprised of a clause 49 PCS + clause 72 PMD + clause 73 AN/LT,
it is not worth pursuing this phylink-based representation of a clause
37 PCS.

> > Where I have some doubts is a
> > clause 49 PCS which uses a clause 73 auto-negotiation system, I would
> > like to understand your vision of how deep phylink is going to go into
> > the PMD layer, especially where it is not obvious that said layer is
> > integrated with the MAC.
> 
> I have only considered up to 10GBASE-R based systems as that is the
> limit of what I can practically test here.  I have one system that
> offers a QSFP+ cage, and I have a QSFP+ to 4x SFP+ (10G) splitter
> cable - so that's basically 4x 10GBASE-CR rather than 40GBASE-CR.
> 

Ok, no problem here, we can keep this discussion at principle level.

> I am anticipating that clause 73 will be handled in a very similar way
> to clause 37.

This is "Figure 37-1-Location of the Auto-Negotiation function" (clause
37 is "Auto-Negotiation function, type 1000BASE-X").

  OSI
  REFERENCE
  MODEL
  LAYERS

 +--------------+
 | APPLICATION  |
 +--------------+
 | PRESENTATION |
 +--------------+
 | SESSION      |
 +--------------+
 | TRANSPORT    |
 +--------------+
 | NETWORK      |
 +--------------+   +----------------------------------------------------+
 | DATA LINK    |   |    LLC (LOGICAL LINK CONTROL) OR OTHER MAC CLIENT  |
 |              |   +----------------------------------------------------+
 |              |   |              MAC CONTROL (OPTIONAL)                |
 |              |   +----------------------------------------------------+
 |              |   |            MAC - MEDIA ACCESS CONTROL              |
 +--------------+   +----------------------------------------------------+
 | PHYSICAL     |   |                  RECONCILIATION                    |
 |              |   +----------------------------------------------------+
 |              |                         |       |
 |              |                   GMII  |       |
 |              |   +----------------------------------------------------+\
 |              |   |          PCS, INCLUDING AUTO-NEGOTIATION           | \
 |              |   +----------------------------------------------------+ |
 |              |   |                        PMA                         | |
 |              |   +----------------------------------------------------+ /
 |              |    |   LX-PMD   |     |   SX-PMD   |    |   CX-PMD   |  / PHY
 |              |    +------------+     +------------+    +------------+ /
 |              |        |    | LX MDI      |    | SX MDI     |    | CX MDI
 +--------------+      +---------+        +---------+       +---------+
                       | MEDIUM  |        | MEDIUM  |       | MEDIUM  |

This is "Figure 28-2-Location of Auto-Negotiation function within the
ISO/IEC OSI reference model" (clause 28 is "Physical Layer link
signaling for Auto-Negotiation on twisted pair", aka BASE-T).

  OSI
  REFERENCE
  MODEL
  LAYERS

 +--------------+
 | APPLICATION  |
 +--------------+
 | PRESENTATION |
 +--------------+
 | SESSION      |
 +--------------+
 | TRANSPORT    |
 +--------------+
 | NETWORK      |
 +--------------+   +------------------------------------------------------+
 | DATA LINK    |   |               LLC (LOGICAL LINK CONTROL)             |
 |              |   +------------------------------------------------------+
 |              |   |               MAC - MEDIA ACCESS CONTROL             |
 +--------------+   +------------------------------------------------------+
 | PHYSICAL     |           |            RECONCILIATION            |
 |              |           +--------------------------------------+
 |              |                          |       |
 |              |                     MII  |       |
 |              |          /+--------------------------------------+
 |              |         / |                 PCS                  |
 |              |         | +--------------------------------------+
 |              |         | |                 PMA                  |
 |              |     PHY | +--------------------------------------+
 |              |         | |                 PMD                  |
 |              |         \ +--------------------------------------+
 |              |          \|               AUTONEG                |
 |              |           +--------------------------------------+
 |              |                           |    | MDI
 +--------------+                         +---------+
                                          | MEDIUM  |

This is "Figure 73-1-Location of Auto-Negotiation function within the
ISO/IEC OSI reference model" (clause 73 is "Auto-Negotiation for
backplane and copper cable assembly").

  OSI
  REFERENCE
  MODEL
  LAYERS

 +--------------+
 | APPLICATION  |
 +--------------+
 | PRESENTATION |
 +--------------+
 | SESSION      |
 +--------------+
 | TRANSPORT    |
 +--------------+
 | NETWORK      |
 +--------------+   +------------------------------------------------------+
 | DATA LINK    |   |  LLC (LOGICAL LINK CONTROL) OR ANY OTHER MAC CLIENT  |
 |              |   +------------------------------------------------------+
 |              |   |               MAC - MEDIA ACCESS CONTROL             |
 +--------------+   +------------------------------------------------------+
 | PHYSICAL     |           |            RECONCILIATION            |
 |              |           +--------------------------------------+
 |              |                          |       | GMII, XGMII, 25GMII,
 |              |                          |       | XLGMII or CGMII
 |              |          /+--------------------------------------+
 |              |         / |                 PCS                  |
 |              |         | +--------------------------------------+
 |              |         | |                 PMA                  |
 |              |     PHY | +--------------------------------------+
 |              |         | |                 PMD                  |
 |              |         \ +--------------------------------------+
 |              |          \|               AUTONEG                |
 |              |           +--------------------------------------+
 |              |                           |    | MDI
 +--------------+                         +---------+
                                          | MEDIUM  |

Identify the position of the auto-negotiation function in these 3
diagrams.

To me, the backplane auto-negotiation look closer to BASE-T than it does
to BASE-X. This auto-negotiation is performed by the PMD, not by the
PCS.

But you are right that clause 28 AN is treated very similarly to clause
37 AN... in phylib.

> The clause 73 "technology ability" field defines the
> capabilities of the link,

Yes.

> but as we are finding with 10GBASE-R based
> setups with copper PHYs, the capabilities of the link may not be what
> we want to report to the user, especially if the copper PHY is capable
> of rate adaption.

Explain?
By "copper PHY" I think you mean "compliant to 10GBASE-T". 10GBASE-KR
serves the same purpose, in the OSI model, as that. Do we not report the
capabilities of the 10GBASE-T link to the user?
Also, on a separate note, is rate adaptation supported by mainline
Linux? Last time I looked, for 2500BASE-X plus the Aquantia PHYs, it
wasn't.

> Hence, it may be possible to have a backplane link
> that connects to a copper PHY that does rate adaption:
> 
> MAC <--> Clause 73 PCS <--backplane--> PHY <--base-T--> remote system
> 
> This is entirely possible from what I've seen in one NBASE-T PHY
> datasheet.  The PHY is documented as being capable of negotiating a
> 10GBASE-KR link with the host system, while offering 10GBASE-R,
> 1000BASE-X, 10GBASE-T, 5GBASE-T, 2.5GBASE-T, 1GBASE-T, 100BASE-T, and
> 10BASE-T on the media side.  The follow-on question is whether that
> PHY is likely to be accessible to the system on the other end of the
> backplane link somehow - either through some kind of firmware link
> or direct access.  That is not possible to know without having
> experience with such systems.
> 

I have not seen said datasheet. That being said, I don't question the
existence of such a device. Because NGBASE-T and 10GBASE-KR are both
media-side protocols, such device would be called a "media converter".
To me this is no different than a 1000BASE-T to 1000BASE-X media
converter. How is that modeled in Linux? Is it?

> That said, with the splitting of the PCS from the MAC in phylink, there
> is the possibility for the PCS to be implemented as an entirely
> separate driver to the MAC driver, although there needs to be some
> infrastructure to make that work sanely.  Right now, it is the MAC
> responsibility to attach the PCS to phylink, which is the right way
> to handle it for setups where the PCS is closely tied to the MAC, such
> as Marvell NETA and PP2 where the PCS is indistinguishable from the
> MAC, and will likely remain so for such setups.  However, if we need
> to also support entirely separate PCS, I don't see any big issues
> with that now that we have this split.
> 

Absolutely.

There is code in phylink for managing a "MAC-side PCS", a concept
introduced by Cisco for SGMII and USXGMII. Because of the implementation
details of this "MAC-side PCS", support for 1000BASE-X comes basically
for free, because hardware speaking, the same state machines are
required for both, just different advertisement parsing logic. So it
makes sense for phylink to manage this 1000BASE-X PCS that comes "for
free" with the MAC-side requirements of SGMII/USXGMII.
But nonetheless, the exact same hardware state machine, i.e. the one
described in "Figure 37-6-Auto-Negotiation state diagram", is managed
twice in the Linux kernel: once in phylib, for any fiber PHY, and once
in phylink. This is fine to me. Yet, in another thread, you are bringing
the argument that:

	If we're not careful, we're going to end up with the Lynx PCS
	being implemented one way, and backplane PCS being implemented
	completely differently and preventing any hope of having a
	backplane PCS connected to a conventional copper PHY.

even though, for SGMII/USXGMII/BASE-X, the auto-negotiation function is
implemented by a completely different part of the OSI model than for
10GBASE-KR, so it is not immediately obvious how you are ok with one but
not the other.

But back to your argument: a backplane PHY could be described as a
phylink MAC-side PCS, and this would have the benefit that the phylib
slot would be free for a 10GBASE-T PHY, were that ever necessary.
That is true, but that is akin to saying that any media converter should
be modeled as a MAC-side phylink PCS and another, singular, phylib PHY
(the converter itself). Why is this the best solution? Because it works?
Sure it does, but is that not a layering violation of sorts? What are
the boundaries of phylink? I am asking because I genuinely don't know.
Is it supposed to manage a SERDES data eye?

To me, it is not obvious at all that a backplane PHY (an integrated one,
at that, but there are integrated BASE-T PHYs as well) shouldn't be
modeled using phylib. If you read carefully through the standard, you'll
notice that the most significant portion of backplane Ethernet is in
"72.6.10.4 State diagrams", for link training. My fear is that phylink
will need to acquire a lot of junk in order to support one
software-driven implementation of 10GBASE-KR AN/LT, just to prove a
point. We have zero other implementations to compare with, but we can
just imagine that others might either do it software-driven, like NXP,
or software-driven but hidden in firmware, or completely in hardware.
Either way, phylib provides just the necessary abstractions for this to
be hidden away. Whereas phylink might need some extra timers apart from
the existing .pcs_get_state() to get this link training job done.

As for that BASE-KR to BASE-T PHY: you've used the argument before that
we should avoid "over-designing for situations that we don't know". When
the time comes that such a system must be supported, the people who'll
need to support it will figure out what the options are. They can range
from:
- do nothing, if the MDIO side of the PHY is not accessible
- do nothing, even if the MDIO side of the PHY is accessible. Things
  might 'just work' even if we completely ignore the existence of this
  PHY.
- extend the phylib to do something about media converters, if things
  get really ugly
- move the backplane PCS/PMA/PMD to phylink, as a workaround more than
  anything else, in my opinion

Basically, the whole reason I've written this email is that I don't
understand why you see such a blocker in the fact that not everybody
warms up to the "phylink should control the backplane PCS/PMA/PMD" idea.
There are situations where phylink is appropriate, and it is not obvious
to me that this is one of them. When it will be, I'm sure people will
react differently too.
Last but not least, a phylink-based solution for non-backplane can
co-exist with a phylib-based solution for backplane. So I really, really
don't see where the problem is, maybe you could clarify.

Thanks,
-Vladimir
