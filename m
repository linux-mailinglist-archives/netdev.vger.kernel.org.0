Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748AE609480
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiJWPr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 11:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiJWPr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 11:47:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25BE31EEB;
        Sun, 23 Oct 2022 08:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jkbZ9V5ZoXt5szJJ38R/LDP9dSqAPwHUZDRfsWCRqOE=; b=FB1z7RXPvga68n+c9yVqZJLMCt
        L4/q1vfh2sJJU1q7T/eKH9SWFt4+GrA5Zpuy0muQ+K54Niaox9z2i85xSKOB06mQ+jDkiLc8Iw7Ne
        h/zKfE8fV6xFXbX702WjNlCf4VXLyKlAT/zueh5Zkz05StCR33lZtAx2NtLXcetTJugivhiFlxEh7
        V/ue1cCghwb0o3I/c84xmVE3qWbPXvGCVuQId9qxCG0fyw7G32BYAUOIS0vt0KWR3nfbdYY1ccGVq
        odeTs1Wd4Ge7942VXVcCNbZei5uoi5+hWMzJm8v6nQwZ698dLzaJF/k4t3uvNAJoXcFcyuVhOclqp
        AYyqfvCA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34906)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1omdBi-00025r-Fr; Sun, 23 Oct 2022 16:46:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1omdBV-0006CN-T3; Sun, 23 Oct 2022 16:46:45 +0100
Date:   Sun, 23 Oct 2022 16:46:45 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y1Vh5U96W2u/GCnx@shell.armlinux.org.uk>
References: <Y1MO6cyuVtFxTGuP@shell.armlinux.org.uk>
 <9BC397B2-3E0B-4687-99E5-B15472A1762B@fw-web.de>
 <Y1Ozp2ASm2Y+if3Q@shell.armlinux.org.uk>
 <trinity-4470b00b-771b-466e-9f3a-a3df72758208-1666435920485@3c-app-gmx-bs49>
 <Y1Qi55IwJZulL1X/@shell.armlinux.org.uk>
 <trinity-164dc5a6-98ce-464c-a43d-b00b91ca69e5-1666461195968@3c-app-gmx-bs49>
 <Y1RCA+l2OHkrFfhB@shell.armlinux.org.uk>
 <trinity-ff9bb15b-b10c-46d6-8af2-09a03563c3c8-1666509999435@3c-app-gmx-bap20>
 <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
 <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 05:05:30PM +0200, Frank Wunderlich wrote:
> > Gesendet: Sonntag, 23. Oktober 2022 um 11:43 Uhr
> > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> 
> > On Sun, Oct 23, 2022 at 09:26:39AM +0200, Frank Wunderlich wrote:
> > > > Gesendet: Samstag, 22. Oktober 2022 um 21:18 Uhr
> > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > > Hi,
> > > >
> > > > On Sat, Oct 22, 2022 at 07:53:16PM +0200, Frank Wunderlich wrote:
> > > > > > Gesendet: Samstag, 22. Oktober 2022 um 19:05 Uhr
> > > > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > > > > On Sat, Oct 22, 2022 at 12:52:00PM +0200, Frank Wunderlich wrote:
> > > > > > > > Gesendet: Samstag, 22. Oktober 2022 um 11:11 Uhr
> > > > > > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > > >
> > > > > > > this patch breaks connectivity at least on the sfp-port (eth1).
> > > > >
> > > > > > > pcs_get_state
> > > > > > > [   65.522936] offset:0 0x2c1140
> > > > > > > [   65.522950] offset:4 0x4d544950
> > > > > > > [   65.525914] offset:8 0x40e041a0
> > > > > > > [  177.346183] offset:0 0x2c1140
> > > > > > > [  177.346202] offset:4 0x4d544950
> > > > > > > [  177.349168] offset:8 0x40e041a0
> > > > > > > [  177.352477] offset:0 0x2c1140
> > > > > > > [  177.356952] offset:4 0x4d544950
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > Thanks. Well, the results suggest that the register at offset 8 is
> > > > > > indeed the advertisement and link-partner advertisement register. So
> > > > > > we have a bit of progress and a little more understanding of this
> > > > > > hardware.
> > > > > >
> > > > > > Do you know if your link partner also thinks the link is up?
> > > > >
> > > > > yes link is up on my switch, cannot enable autoneg for fibre-port, so port is fixed to 1000M/full flowcontrol enabled.
> > > > >
> > > > > > What I notice is:
> > > > > >
> > > > > > mtk_soc_eth 15100000.ethernet eth1: Link is Up - 1Gbps/Unknown - flow control off
> > > > > >
> > > > > > The duplex is "unknown" which means you're not filling in the
> > > > > > state->duplex field in your pcs_get_state() function. Given the
> > > > > > link parter adverisement is 0x00e0, this means the link partner
> > > > > > supports PAUSE, 1000base-X/Half and 1000base-X/Full. The resolution
> > > > > > is therefore full duplex, so can we hack that in to your
> > > > > > pcs_get_state() so we're getting that right for this testing please?
> > > > >
> > > > > 0xe0 is bits 5-7 are set (in lower byte from upper word)..which one is for duplex?
> > > > >
> > > > > so i should set state->duplex/pause based on this value (maybe compare with own caps)?
> > > > >
> > > > > found a documentation where 5=full,6=half, and bits 7+8 are for pause (symetric/asymetric)
> > > > >
> > > > > regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1+8, &val);
> > > > > partner_advertising = (val & 0x00ff0000) >> 16;
> > > >
> > > > Not quite :) When we have the link partner's advertisement and the BMSR,
> > > > we have a helper function in phylink to do all the gritty work:
> > > >
> > > > 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
> > > > 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1 + 8, &adv);
> > > >
> > > > 	phylink_mii_c22_pcs_decode_state(state, bm >> 16, adv >> 16);
> > > >
> > > > will do all the work for you without having to care about whether
> > > > you're operating at 2500base-X, 1000base-X or SGMII mode.
> > > >
> > > > > > Now, I'm wondering what SGMII_IF_MODE_BIT0 and SGMII_IF_MODE_BIT5 do
> > > > > > in the SGMSYS_SGMII_MODE register. Does one of these bits set the
> > > > > > format for the 16-bit control word that's used to convey the
> > > > > > advertisements. I think the next step would be to play around with
> > > > > > these and see what effect setting or clearing these bits has -
> > > > > > please can you give that a go?
> > > > >
> > > > > these is not clear to me...should i blindly set these and how to
> > > > > verify what they do?
> > > >
> > > > Yes please - I don't think anyone knows what they do.
> > >
> > > i guess BIT0 is the SGMII_EN flag like in other sgmii implementations.
> > > Bit5 is "reserved" in all docs i've found....maybe it is related to HSGMII
> > > or for 1G vs. 2G5.
> >
> > "other sgmii implementations" ?
> 
> yes i googled for sgmii and found register definition for different vendor...
> i don't know if sgmii is a standard for each vendor, afair trgmii was not.
> 
> > If this is the SGMII_EN flag, maybe SGMII_IF_MODE_BIT0 should be
> > renamed to SGMII_IF_SGMII_EN ? Maybe it needs to be set for SGMII
> > and clear for base-X ?
> >
> > > but how to check what has changed...i guess only the register itself changed
> > > and i have to readout another to check whats changed.
> > >
> > > do we really need these 2 bits? reading/setting duplex/pause from/to the register
> > > makes sense, but digging into undocumented bits is much work and we still only guess.
> >
> > I don't know - I've no idea about this hardware, or what the PCS is,
> > and other people over the years I've talked to have said "we're not
> > using it, we can't help". The mediatek driver has been somewhat of a
> > pain for phylink as a result.
> >
> > > so i would first want to get sgmii working again and then strip the pause/duplex from it.
> >
> > I think I'd need more information on your setup - is this dev 0? Are
> > you using in-band mode or fixed-link mode?
> 
> i only test with dev1 which is the sfp-port/eth1/gmac1...dev0 is the fixed-link to switch-chip.

Okay, so when you're using SGMII, how are you testing it? With a copper
SFP plugged in?

> > I don't think you've updated me with register values for this since
> > the patch. With the link timer adjusted back to 1.6ms, that should
> > result in it working again, but if not, I think there's some
> > possibilities.
> 
> sorry for that, have debugged timing and it was wrong because if-
> condition had not included 1000baseX and 2500baseX. only sgmii

SGMII's link timer is specified to be 1.6ms - the SGMII v1.8 spec
doesn't specify the margins for this.

802.3z (1000base-X) is 10ms +10ms -0s.

This is what we should be using, and what I tried to implement.

The hex values programmed into the register should be 0x186A0 for
SGMII and 0x98968 for 1000base-X and 2500base-X - both values
should fit because the link timer is apparently 20 bits wide.

> > The addition of SGMII_AN_ENABLE for SGMSYS_PCS_CONTROL_1 could have
> > broken your setup if there is no actual in-band signalling, which
> > basically means that your firmware description is wrong - and you've
> > possibly been led astray by the poor driver implementation.
> 
> disabled it, but makes no change.
> 
> but i've noticed that timing is wrong
> 
> old value: 0x186a0
> new value: 0x98968
> 
> so it takes the 10000000 and not the 1600000. so it looks like interface-mode is not (yet) SGMII.
> 
> debugged it and got 1000baseX (21),in dts i have
> phy-mode = "2500base-x";
> but SFP only supports 1G so mode 1000baseX is right
> 
> set the old value with your calculation, but still not working, also with disabled AN_ENABLE-flag ;(

I'm getting the impression that there's some confusing terminology going
on here... can we clear this up please?

SGMII is a proprietary modification of the 802.3z 1000base-X standard
which:
- reduces the link timer from 10ms to 1.6ms
- implements data replication by 10x and 100x to achieve 100M and 10M
  speeds over a link operating at a fixed speed of 1.25Gbaud.
- changes the control word format to allow a SGMII PHY to signal to the
  MAC in a timely manner which speed it is operating at.

So, if you're using a fibre SFP to another device that is operating in
1000base-X mode, then you're wanting 1000base-X and not SGMII, and
referring to this as SGMII is technically misleading.

> root@bpi-r3:~# ip link set eth1 up
> [   44.287442] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/1000be
> [   44.295902] interface-mode 21 (sgmii:4)
> root@bpi-r3:~# [   44.295907] timer 0x186a0
> [   44.352872] offset:0 0x2c1140
> [   44.355507] offset:4 0x4d544950
> [   44.358462] offset:8 0x40e041a0
> [   44.361609] mtk_soc_eth 15100000.ethernet eth1: Link is Up - 1Gbps/Full - flf
> [   44.373042] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> 
> root@bpi-r3:~# ip a a 192.168.0.19/24 dev eth1
> root@bpi-r3:~# ping 192.168.0.10
> PING 192.168.0.10 (192.168.0.10) 56(84) bytes of data.
> ^C

This is where I postulated that the PCS is trying to interpret the
advertisements as if they are SGMII formatted control words rather than
1000base-X formatted control words - and by doing so, it is trying to
operate at 10Mbps (100x data replication) with the remote end trying to
operate at 1000Mbps. If that is what it is doing, then you will have
link-up but no communication.

The solution to this is likely trying to find a bit that tells the
PCS whether it should be expecting a 1000base-X (or 802.3z) formatted
control word (aka 1000base-X mode) or a SGMII formatted control word.

You mentioned that bit 0 in SGMSYS_SGMII_MODE is a "SGMII_EN" bit.
Any ideas exactly what this bit does? Does it enable the PCS as a
whole, or could that be the bit which switches between 1000base-X
mode and SGMII mode? (More on this below).

Note that the "old way" used to work because even in 1000base-X
mode, the code would (technically incorrectly) force the PCS to
use a fixed configuration of 1000Mbps and force the duplex bit -
basically no 802.3 specified autonegotiation.

However, 1000base-X with in-band signalling _should_ be using
the autonegotiation - as everything else that uses phylink does.

> > Can you confirm that the device on the other end for dev 0 does in
> > actual fact use in-band signalling please?
> >
> > > > If it's interpreting a link partner advertisement of 0x00e0 using
> > > > SGMII rules, then it will be looking at bits 11 and 10 for the
> > > > speed, both of which are zero, which means 10Mbps - and 1000base-X
> > > > doesn't operate at 10Mbps!
> > >
> > > so maybe this breaks sgmii? have you changed this behaviour with your Patch?
> >
> > Nope, but not setting the duplex properly is yet another buggy and poor
> > quality of implementation that afficts this driver. I've said about
> > setting the duplex value when reviewing your patch to add .pcs_get_state
> > and I'm disappointed that you seemingly haven't yet corrected it in the
> > code you're testing despite those review comments.
> 
> sorry, i thought we want to read out the values from registers to set it based on them.
> 
> currently i test only with the dev 1 (in-band-managed with 1GBit/s SFP)
> 
> [    1.088310] dev: 0 offset:0 0x40140
> [    1.088331] dev: 0 offset:4 0x4d544950
> [    1.091827] dev: 0 offset:8 0x1
> [    1.095607] dev: 1 offset:0 0x81140
> [    1.098739] dev: 1 offset:4 0x4d544950
> [    1.102214] dev: 1 offset:8 0x1
> 
> after bring device up (disabled AN and set duplex to full):
> 
> [   34.615926] timer 0x98968
> [   34.672888] offset:0 0x2c1140
> [   34.675518] offset:4 0x4d544950
> [   34.678473] offset:8 0x40e041a0
> 
> codebase:
> 
> https://github.com/frank-w/BPI-R2-4.14/commits/6.1-r3-sgmii

I think it would also be useful to print the register at offset 32
as well, which is the SGMSYS_SGMII_MODE register, so we can discover
what the initial and current values of these IF_MODE_BITs are. I
may then be able to provide you an updated patch.

> > If duplex remains as "unknown", then the MAC will be programmed to
> > operate in _half_ _duplex_ mode (read mtk_mac_link_up()) which is not
> > what you likely want. Many MACs don't support half duplex at 1G speed,
> > so it's likely that without setting state->duplex, the result is that
> > the MAC hardware is programmed incorrectly.
> 
> wonder why it was working with only my patch which had duplex also not set.

It depends entirely on the MAC implementation and why the manufacturer
decides to state that 1000 half-duplex isn't supported by the hardware!
I don't think we can guess. However, configuring the hardware correctly
eliminates potential issues.

It is in entirely possible for devices configured with dissimilar
duplex settings to communicate, but there will be packet loss - since
the end operating in full duplex will transmit while the receiving
end could also be transmitting, and the receving end could interpret
that as a collision.

> > > > So my hunch is that one of those two IF_MODE_BIT{0,5} _might_ change
> > > > the way the PCS interprets the control word, but as we don't have
> > > > any documentation to go on, only experimentation will answer this
> > > > question.
> 
> the bits were in offset 0/4/8? are they now different than before?
> if yes maybe these break it.
> 
> as offset 4 is the phy-id and 8 is the advertisement from local and far
> interface i guesss IF_MODE_* is in offset 0.

They're in the register at offset 32:

/* Register to control remote fault */
#define SGMSYS_SGMII_MODE               0x20
#define SGMII_IF_MODE_BIT0              BIT(0)
...
#define SGMII_IF_MODE_BIT5              BIT(5)

So, I think the first step should be to print the value of this register
along side the other three you've been providing me and update me with
its value. I'll then provide you a replacement patch to try.

Russell.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
