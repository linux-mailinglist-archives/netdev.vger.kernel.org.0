Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499A6558C37
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 02:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiFXAY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 20:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiFXAYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 20:24:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE072522F9;
        Thu, 23 Jun 2022 17:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rj4fNq4dsD4RucdU9q2oXV1dsLBQIM0KGDC67E3P3Bw=; b=YcqONt6bkbgauMcaGozlppn8Z4
        jKvT67nUjBgVJGmKloswod+VIAUtS8HpOJuvU0yebcKg/Ug/ywLR9cWoHAhjJVlA5/00YJH2XCXKZ
        pMx1KXV7Lqe1r/t+Gr5heEsIn86xLwcDe6XQfQ1gJzsS1EzHetGebHBGcF13JEoVOKr46MbP2QXoQ
        Vx3ZpYmnUU1BkLO1UrVeSpVaM6GL6c78G2TCXx8eVWtywGHBE43OHw2z0MScofzR4gZ5voajkGYV8
        t1O8KGu9kkgMkTn7xJyI51OJCaIioSMhE36RRY3KSccRKInqIsc3AIqzerefsv3QJCB4PLxTBu99F
        g4iD4suQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33014)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o4X7N-0005Kv-Ii; Fri, 24 Jun 2022 01:24:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o4X7K-0000Rl-Gz; Fri, 24 Jun 2022 01:24:10 +0100
Date:   Fri, 24 Jun 2022 01:24:10 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 25/28] [RFC] net: dpaa: Convert to phylink
Message-ID: <YrUEKmQzXC1OXrHV@shell.armlinux.org.uk>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-26-sean.anderson@seco.com>
 <Yqz5wHy9zAQL1ddg@shell.armlinux.org.uk>
 <dde1fcc4-4ee8-6426-4f1f-43277e88d406@seco.com>
 <Yq2LLW5twHaHtRBY@shell.armlinux.org.uk>
 <84c2aaaf-6efb-f170-e6d3-76774f3fa98a@seco.com>
 <8becaec4-6dc3-8a45-081a-1a1e8e5f9a45@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8becaec4-6dc3-8a45-081a-1a1e8e5f9a45@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 06:39:08PM -0400, Sean Anderson wrote:
> Hi Russell,
> 
> On 6/18/22 11:58 AM, Sean Anderson wrote:
> > Hi Russell,
> > 
> > On 6/18/22 4:22 AM, Russell King (Oracle) wrote:
> >> On Fri, Jun 17, 2022 at 08:45:38PM -0400, Sean Anderson wrote:
> >>> Hi Russell,
> >>>
> >>> Thanks for the quick response.
> >>> ...
> >>> Yes, I've been using the debug prints in phylink extensively as part of
> >>> debugging :)
> >>>
> >>> In this case, I added a debug statement to phylink_resolve printing out
> >>> cur_link_state, link_state.link, and pl->phy_state.link. I could see that
> >>> the phy link state was up and the mac (pcs) state was down. By inspecting
> >>> the PCS's registers, I determined that this was because AN had not completed
> >>> (in particular, the link was up in BMSR). I believe that forcing in-band-status
> >>> (by setting ovr_an_inband) shouldn't be necessary, but I was unable to get a link
> >>> up on any interface without it. In particular, the pre-phylink implementation
> >>> disabled PCS AN only for fixed links (which you can see in patch 23).
> >>
> >> I notice that prior to patch 23, the advertisment register was set to
> >> 0x4001, but in phylink_mii_c22_pcs_encode_advertisement() we set it to
> >> 0x0001 (bit 14 being the acknowledge bit from the PCS to the PHY, which
> >> is normally managed by hardware.
> >>
> >> It may be worth testing whether setting bit 14 changes the behaviour.
> > 
> > Thanks for the tip. I'll try that out on Monday.
> 
> Well, I was playing around with this some more, and I found that I could enable
> it if I set one of the 10G lanes to SGMII. Not sure what's going on there. It's
> possible one of the lanes is mismatched, but I'm still looking into it.
> 
> ---
> 
> How is rate adaptation in the phy supposed to work? One of the 10G interfaces on
> the RDB is hooked up to an AQR113 which can adapt rates below 10G to XFI using
> pause frames.

Rate adaption support isn't something that phylink officially supports.
It can be bodged around (and some drivers do) but that's the official
line - there is no code in phylink to make it work.

For example, if you have a PHY that's doing rate adaption, and the PHY
reports what has been negotiated on the media side. That gets reported
back to the PCS and MAC. The only way these blocks can tell that there's
something going on is if they say "hey, but the link to the PHY is
operating at 10G and the media speed is 100M, so something fishy is
going on, the PHY must be doing rate adaption."

That's the bottom line to this - phylink doesn't yet support rate
adaption by any of the blocks - mainly because there is no way for
any of those blocks to indicate that they're doing rate adaption.

The implementation of phylink_generic_validate() assumes there is no
rate adaption (as per the current design of phylink).

The reason phylink_generic_validate() has come into existence recently
is to (1) get rid of the numerous almost identical but buggy
implementations of the validate() method, and (2) to eventually allow
me to get rid of the validate() method. The validate() method is not
very well suited to systems with rate adaption - as validate() stands,
every MAC today that _could_ be connected with something that does rate
adaption needs to have special handling in that method when that is
true - that clearly isn't a good idea when it's dependent on the
properties of the devices towards the media from the MAC.

Ocelot does make rate adaption work by doing exactly this - it has its
own validate() method that returns all the link modes that it wishes
the system to support, and it ignores some of what phylink communicates
via the link_up() callbacks such as rx_pause. This means this MAC driver
wouldn't behave correctly as a system if rate adaption wasn't present.


Now, the thing about rate adaption is there are several different ways
to do it - and Marvell 88x3310 illustrates them both, because this PHY
supports rate adaption but depending on whether the PHY has MACSEC
hardware support or not depende on its behaviour:

- If no MACSEC, then the PHY requires that the MAC paces the rate at
  which packets are sent, otherwise the PHYs FIFOs will overflow.
  Therefore, the MAC must know: (1) the speed of the media side, and
  (2) that the PHY requires this behaviour. Marvell even go as far as
  stating that the way to achieve this is to extend the IPG in the MACs
  settings.

- If MACSEC, then the PHY sends pause frames back to the MAC to rate
  limit the packet rate from the MAC. Therefore, the MAC must accept
  pause frames to throttle the transmit rate whether or not pause
  frames were negotiated on the media side.

So, doing this right, you need knowledge of the rate adaption
implementation - there isn't a "generic" solution to this. It isn't
just a case of "allow all speeds at the media side at or below PHY
interface speed" although that is part of it. (More on this below.)

> This is nice and all, but the problem is that phylink_get_linkmodes
> sees that we're using PHY_INTERFACE_MODE_10GKR and doesn't add any
> of the lower link speeds (just MAC_10000).

Do you really have a 10GBASE-KR link - a backplane link? This has
negotiation embedded in it. Or do you have a link that is using the
10GBASE-R protocol? (Please don't use PHY_INTERFACE_MODE_10GKR unless
you really have a 10GBASE-KR link as defined by 802.3).

> This results in ethtool output of
> 
> Settings for eth6:
> 	Supported ports: [  ]
> 	Supported link modes:   10000baseT/Full
> 	                        10000baseKX4/Full
> 	                        10000baseKR/Full
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: Yes
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  10000baseT/Full
> 	                        10000baseKX4/Full
> 	                        10000baseKR/Full
> 	Advertised pause frame use: Symmetric Receive-only
> 	Advertised auto-negotiation: Yes
> 	Advertised FEC modes: Not reported
> 	Link partner advertised link modes:  10baseT/Half 10baseT/Full
> 	                                     100baseT/Half 100baseT/Full
> 	Link partner advertised pause frame use: Symmetric
> 	Link partner advertised auto-negotiation: Yes
> 	Link partner advertised FEC modes: Not reported
> 	Speed: Unknown!
> 	Duplex: Unknown! (255)
> 	Auto-negotiation: on
> 	Port: MII
> 	PHYAD: 0
> 	Transceiver: external
>         Current message level: 0x00002037 (8247)
>                                drv probe link ifdown ifup hw
> 	Link detected: yes
> 
> The speed and duplex are "Unknown!" because the negotiated link mode (100Base-TX)
> doesn't intersect with the advertised link modes (10000Base-T etc). This is
> currently using genphy; does there need to be driver support for this sort of thing?

Without knowing whether this is a clause 22 or clause 45 PHY, I'd just
be guessing, but...

genphy's C45 support is rudimentary and should not be used.
genphy's C22 support is better for basic control of PHYs but should not
be used if there's a more specific driver.

If this is a C22 PHY, I'm surprised that it managed to link with its
partner - we should have cleared anything but the 10000M modes in the
PHY which should have caused the media side autonegotiation to fail.

However, with the Ocelot-style workaround I mentioned above, that would
allow the 100M speeds to be advertised, and phylib would then be able
to resolve them to the appropriate speed/duplex. I don't condone doing
that though, I'd prefer a proper solution to this problem.

> Should the correct speed even be reported here? The MAC and PCS still need to be
> configured for XFI.
> 
> Another problem is that the rate adaptation is supposed to happen with pause frames.
> Unfortunately, pause frames are disabled:
> 
> Pause parameters for eth6:
> Autonegotiate:	on
> RX:		off
> TX:		off
> RX negotiated: on
> TX negotiated: on

I think you're misreading that - don't worry, I don't think you're the
only one.

"Autonegotiate" is the value of ethtool's pauseparam "autoneg" setting
which determines whether the resutl of autonegotiation is used or
whether manual settings are used.

"RX" and "TX" are the manual settings, which will force pause frame
reception and transmission gating when "Autonegotiate" is off. These
can be read-modify-written (and are by ethtool) so it's important
that they return what was previously configured, not what the hardware
is doing. See do_spause() in the ethtool source code.

"RX negotiated" and "TX negotiated" are ethtool's own derivation from
our and link-partner advertisements and in no way reflect what the
hardware is actually doing. These reflect what was negotiated on the
media between the PHYs.

See dump_pause() in the ethtool source code for the function that
produces the output you quoted above.

Phylink's "Link is Up" message gives the details for the link - the
speed and duplex will be the media side of the link (which is what gets
passed in all the link_up() methods). The pause settings come from the
media side negotiation if pause autoneg is enabled, otherwise they come
from the pauseparam forced modes. I think this should only ever report
the media-negotiated settings.

If we need support for rate adaption with pause frames, then you are
right that we need the MAC to be open to receive those frames, and
right now, as I said above, there is no support in phylink at present
to make that happen. I'm not saying there shouldn't be, I'm just saying
that's how it is today.

In order to do this, we would need to have some way of knowing that:
(a) the PHY is a rate adapting PHY (which means it must not use genphy.)
(b) the PHY is will send pause frames towards the MAC to pace it.

This would need to be added to phylib, and then phylink can query
phylib for that information and, when telling the MAC that the link
is up, also enable rx_pause.

The same is true at the PCS level - we don't have any way to know if
a PCS is doing rate adaption, so until we have a way to know that,
phylink can't enable rx_pause.

There is one final issue that needs to be considered - what if the
PHY is a rate adapting PHY which sends pause frames, but it has been
coupled with a MAC that doesn't have support to act on those pause
frames? Do we print a warning? Do we refuse to bring the link up?
Do we fall back to requiring the MAC to increase the IPG? What if the
MAC isn't capable of increasing the IPG? How do we tell the MAC to
increase the IPG, another flag in its link_up() method?

> Maybe this is because phylink_mii_c45_pcs_get_state doesn't check for pause modes?

With a 10GBASE-R PCS, there is no in-band status on the link, and so
there is no communication of pause frame negotiation status to the
PCS - meaning, there is no way to read it from the PCS.

Let me be clear about this: this is a shortcoming of phylink, but
phylink had to start somewhere, and all the hardware I have does not
support rate adaption.

I'd like this problem to get solved - I have some experimental patches
that allow a PCS to say "hey, I'm doing rate adaption, don't bother
with the MAC validation" but I get the feeling that's not really
sufficient.

Anyway, I'm afraid it's very late here, so I can't put any more
thought into this tonight, but I hope the above is at least helpful
and gives some ideas what needs to be done to solve this.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
