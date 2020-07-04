Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8602148A6
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 22:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgGDU3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 16:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbgGDU3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 16:29:23 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EE3C061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 13:29:22 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id f12so11837938eja.9
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 13:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=roSSi1NbABWU1l9/vT83v1/e0jAS/csMWNZBDqCpYNE=;
        b=IK/ot7mBpBfmPGgTszEvc1XmNWbpbM1fPUGPnPB9Bx0qtqsko/qxzDbkj5xq5LG/yL
         z8vkQRmMo/JoOOHdJDgmk6Y7RqTZGhKZZ1Pm6Ey3Z5w2N7l22XrxGeG/GMSPrRoBVpML
         J2GPFkL1ehcqGvH3WPJie3ri5Tq58cw2oA1SZPKx8ck6Nd9WtETo7mXBhWtW+EUmIJJ7
         i/D63GYRz3wLGmFnDF9L/vvacyMxMGCArOnKvy0Bml1Z1bcgWerMOc5zkayZfSBurtq8
         k0IHMlVFAM7oj4zg04ZKMQMNzTrmlalEAQsG5imQEOmJoZaN7JMGSWF1sm1FDMVbZ5ES
         3Y8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=roSSi1NbABWU1l9/vT83v1/e0jAS/csMWNZBDqCpYNE=;
        b=Hhw9GluGdR2xMDt4h6nDKqjs/eKOAO7Mes4BgYJcI7SnUPbzk1r8RljnAXU3k5BFyj
         Tw0o8gxbqznjEeAIFqa1xO7S2jCInYlou7kILrodG3o4qWwPvZzdCLJQWhvsUdwJUqiM
         M6vpk1YsXAlyE2tEBG4/GEXFRdEUrkZJuR5eoarozbwS3PMf7iMhjKRcT1ERUlYBLsXg
         YpByIqO1sBUI21HjaUEF1U7bSOwdPOuGZpGHtgthpUT0keenea53HtsUJf+L8p+NPODR
         B/VXgXAfJTsj1ojtDmUw3vNxABdaZr8I6f7UMJt8T5PBCT9DcNHUFx3tUQVVq/j5bDa0
         jKzA==
X-Gm-Message-State: AOAM5337oyObBs36hfqwG2rdDNBdJyBNg4gDQXU0fmnkioarf2M5ykY6
        Cz7KV/t1LConJSineCqRULo=
X-Google-Smtp-Source: ABdhPJyj7p/FXusAVYRiyzowdRxB8J/ULgzY805OaM2bAVzXdMsOMcEtrn/7R/WtgHJ+eRvDXfUwrA==
X-Received: by 2002:a17:906:2c18:: with SMTP id e24mr39563270ejh.335.1593894561068;
        Sat, 04 Jul 2020 13:29:21 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id e22sm7688025ejd.36.2020.07.04.13.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 13:29:20 -0700 (PDT)
Date:   Sat, 4 Jul 2020 23:29:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH v2 net-next 5/6] net: dsa: felix: delete
 .phylink_mac_an_restart code
Message-ID: <20200704202918.larwj762pwbephhb@skbuf>
References: <20200704124507.3336497-1-olteanv@gmail.com>
 <20200704124507.3336497-6-olteanv@gmail.com>
 <20200704145613.GR1551@shell.armlinux.org.uk>
 <20200704155048.nsrzn4byujvkab3q@skbuf>
 <20200704181401.GS1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200704181401.GS1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 04, 2020 at 07:14:01PM +0100, Russell King - ARM Linux admin wrote:
> On Sat, Jul 04, 2020 at 06:50:48PM +0300, Vladimir Oltean wrote:
> > On Sat, Jul 04, 2020 at 03:56:14PM +0100, Russell King - ARM Linux admin wrote:
> > 
> > [snip]
> > 
> > > 
> > > NAK for this description.  You know why.
> > > 
> > > -- 
> > > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> > 
> > Sorry, I cannot work with "too busy" (your feedback from v1) and "you
> > know why". If there's anything incorrect in the description of the
> > patch, please point it out and I will change it.
> 
> Let's recap.
> 
> I have explained to you on numerous instances that:
> 
> - as part of the ethtool program, there is the facility to restart
>   negotiation, which users expect to cause the media to renegotiate.
> 
> - when dealing with a link that involves a conventional copper PHY,
>   irrespective of how that PHY is connected, this has always resulted
>   in the copper PHY being requested to restart negotiation on the
>   media side.
> 
> - in order to provide this same capability for fibre links where
>   negotiation is supported, phylink provides the ability to pass that
>   request to the PCS, since that is the media facing hardware block
>   responsible for on-media negotiation.
> 
> - for SGMII, there is no advertisement from the MAC per-se, it is only
>   an acknowledgement that the MAC has received the configuration word
>   from the PHY.
> 
> It is also true that phylink uses this when there may be a change to
> the PCS advertisement - again, to support the ability for the user to
> change the media-side advertisement.  There is no media side
> advertisement in SGMII at the MAC PCS.
> 

No comment there, my revised commit message confirms indeed that there's
nothing to advertise from MAC side in SGMII/USXGMII mode. The initial
commit message leaves that piece of info up in the air.

> There has been code in phylink that avoids calling the an_restart
> methods since day one, as a result of the above.
> 
> Let's now look at the first version of your commit message:
> | In hardware, the AN_RESTART field for these SerDes protocols (SGMII,
> | USXGMII) clears the resolved configuration from the PCS's
> | auto-negotiation state machine.
> | 
> | But PHYLINK has a different interpretation of "AN restart". It assumes
> | that this Linux system is capable of re-triggering an auto-negotiation
> | sequence, something which is only possible with 1000Base-X and
> | 2500Base-X, where the auto-negotiation is symmetrical. In SGMII and
> | USXGMII, there's an AN master and an AN slave, and it isn't so much of
> | "auto-negotiation" as it is "PHY passing the resolved link state on to
> | the MAC".
> | 
> | So, in PHYLINK's interpretation of "AN restart", it doesn't make sense
> | to do anything for SGMII and USXGMII. In fact, PHYLINK won't even call
> | us for any other SerDes protocol than 1000Base-X and 2500Base-X. But we
> | are not supporting those. So just remove this code.
> 
> This comes over as blaming phylink for an interpretation of "AN
> restart" that does not conform to your ideas.  While it is true that
> phylink has a "different interpretation", that interpretation comes
> from the interface that this callback is implementing, which is for
> the user-level interface.  So, the "blame" that comes over in this
> commit message is completely unjustified.
> 

I also apologized for being imprecise, but you are NACK'ing v2 for v1's
wording here. But, there are also better reasons below.

> You also capitalised "PHYLINK" throughout this message for some reason,
> which comes over as a stressed word (capitals is generally interpreted
> as stress or shouting.)  Then there's "this Linux system" which sounds
> a bit spiteful.
> 

I've been using PHYLINK using capitals for a lot of time now, nothing to
do with shouting, just with the fact that I also spell "Ethernet PHY"
with capitals. I'll change to "Phylink" or "phylink", depending on the
word's location within the phrase, and I'll also ask the people I know
to use this notation.

> None of those things belong in a commit message, so I objected to it,
> explicitly asking you to (quote) "So, please, lay off your phylink
> bashing in your commit messages."
> 
> The replacement that you sent was worse - it continues this theme,
> taking it further:
> 
> | The point is, both Cisco standards make explicit reference that they
> | require an auto-negotiation state machine implemented as per "Figure
> | 37-6-Auto-Negotiation state diagram" from IEEE 802.3. In the SGMII spec,
> | it is very clearly pointed out that both the MAC PCS (Figure 3 MAC
> | Functional Block) and the PHY PCS (Figure 2 PHY Functional Block)
> | contain an auto-negotiation block defined by "Auto-Negotiation Figure
> | 37-6".
> 
> Specifically, "The point is, ..." and "very clearly pointed out" are
> completely unnecessary in a commit message, it gives a lecturing tone
> to this text.  The lecturing tone continues throughout the entire text.
> 

I ramble quite a lot in commit messages, it's nothing personal.
Sometimes, among the rambling I say something useful too. I'll try to
value maintainers' time more by using more succint phrases.

> | PHYLINK takes this fact a bit further, and since the fact that for
> | SGMII/USXGMII, the MAC PCS conveys no new information to the PHY PCS
> | (beyond acknowledging the received config word), does not have any use
> | for permitting the MAC PCS to trigger a restart of the clause 37
> | auto-negotiation.
> 
> Again, it is not phylink that "takes this fact a bit further".  Phylink
> is implementing the needs of userspace via this callback, which is to
> cause autonegotiation to restart on the media.
> 
> | The only SERDES protocols for which PHYLINK allows that are 1000Base-X
> | and 2500Base-X. For those, the control information exchange _is_
> | bidirectional (local PCS specifies its duplex and flow control
> | abilities) since the link partner is at the other side of the media.
> 
> This avoids the point that I have been making for a long time now
> about what phylink is doing here.
> 
> Let me re-cap: phylink implements what is required to support the
> network driver in implementing the what the user expects from the APIs
> exposed by the kernel. One of the APIs is to restart negotiation, which
> is generally accepted to mean the on-media negotiation, rather than
> whatever internal negotiation happens within their "network interface".
> 
> Hence, it is appropriate that phylink restricts this to situations
> where it is known that the media link is terminated on hardware that
> phylink is responsible for.
> 

It doesn't avoid that point. ACK, ethtool -r exists, and .mac_an_restart
can be used to implement it under some circumstances. More below.

> At the moment, the known cases are:
> - at the phylib PHY when dealing with conventional twisted pair cabling.
> - at the phylib PHY where one is involved in a fibre link.
> - at the PCS, where one is involved in a fibre link (which means
>   1000base-X or 2500base-X.)
> 
> Since SGMII and USXGMII are designed for use between a PHY and the
> host system (hence internal to the network interface), rather than over
> some user accessible media, there is little point universally making
> that call in response to a user request to restart the media
> negotiation.
> 
> There is two final points to make:
> 
> - if we discover a requirement where we need to restart SGMII or
>   USXGMII at the MAC PCS end (thank you for showing me that it is
>   possible) then, yes, we will have to revisit how we deal with this.
>   Yes, we may wish the callback to restart SGMII and USXGMII at that
>   point.  However, we do not want to do that if the user requests a
>   media side renegotiation.  As I have already explained, restarting
>   negotiation on the media side at the PHY will cause a fresh exchange
>   - not once, but twice - on the SGMII and USXGMII side anyway, which
>   will refresh the configuration.
> 
>   The exception to that is if we have a buggy SGMII or USXGMII
>   implementation - and, again, when we have such a scenario, that is
>   the time to adapt.
> 
> - changing the behaviour now that we have several users without good
>   reason is inviting regressions - there is the possibility for a state
>   machine error if both ends of the link are hit for a renegotiation.
>   Yes, I'm being cautious there, but there is always risk to change,
>   and if there is no benefit from making that change then it stands to
>   reason that there is no net benefit from making that change.
> 

Yes, I am definitely not suggesting a phylink API change or
reinterpretation of existing API at this point. That would be confusing,
and "confusing" is what I want to avoid, perhaps by using more words
than necessary. I will happily accept that I am the only one who
misunderstood the API on this particular aspect.

> So, to sum up, your commit message _only_ needs to describe the change
> you are making.  You should not lecture in a commit message, and you
> should use neutral language.
> 

Ok, I will try to keep it shorter in v3 and lose the lecturing tone.

> If there is something lacking in the understanding of the callback,
> the right place to fix that is in the documentation within the kernel,
> not buried in some commit message for some obscure driver that no one
> is going to even look at while developing their own driver.  Even so,
> such documentation should clearly but briefly explain what is going on.
> 

There were a number of other points you've made in this text, all of
which boil down to one idea: that restarting SGMII AN from MAC side does
not trigger an MDI-side auto-negotiation process, so it cannot be used
for implementing the behavior expected by the user for "ethtool -r".

I will try to address those points centrally, here, by asking 2
questions.

1. In various topics you have brought up a certain copper SFP module
   from Mikrotik which embeds an inaccessible Atheros SGMII PHY. Mind
   you, I have never interacted with that SFP, but, I have a question
   out of sheer curiosity. How does ethtool -r currently work for such a
   system?

   [ I am not going to use this argument to lean this particular
   discussion in either direction (read: even if my hunch is right and
   restarting AN on the MAC PCS _could_ be the only way to implement
   ethtool -r there, I still don't care enough about that one-off case
   to change the phylink API, for the time being), but I _would_ like
   to know ]

2. There are some 1000Base-T PHYs, such as VSC8234 (which I know from
   first-hand experience, in fact there's even a comment in
   felix_vsc9959.c about it), which restart their MDI-side AN when they
   detect a transition of the system side from data mode to
   configuration mode [ initiated by the MAC ].
   Is this behavior implied by any standard (probably IEEE)? That I
   didn't check. Is this behavior also at least consistent with the
   non-SFP SGMII Atheros PHYs I have? I didn't check that either.
   Anyway, food for thought.

> I have just spent the last 1h40 composing this message - I've put a lot
> of thought into it. I obviously do not have the capacity to do that all
> the time.
> 

Thank you, it shows that you've put some more time and thought into this
reply. Maybe some balance would work a lot better overall?

> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-Vladimir
