Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0086A8184
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 12:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjCBLth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 06:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCBLtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 06:49:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6F813DF7
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 03:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=feCINtbNdSorlHYIeJZVC6gKrhaFB4cNR6bn4bxBWmI=; b=k5xkEXcWngn9Z5H1bL+OjXQsVR
        /ayNRBgqjcKcEC6EyIjC6zTXiEdPUdNVw40rL6oe5MZ45n1Ui2vzy65jqdaEqus0tNQwaSyRvVWZG
        kvZA3upSC5MTfapVEjxN0FTkEZD+AY5Vd+iVq5PoMMcqSOCMbcyd5UPvAuA0nGymX6T37/M0BoDK4
        S/73UBB5qjsmE06ZrFR8P53FbQxQMbHs/GY3/su1mAQM+gD1y4iJTXPjE/iKoyxqSZBt6EOAhpGSo
        T2yKuIi6x3I4xlaXTCNJ7D7hp/ImGGaDrVc/VXpaog2IvMIgghQt1TY36bdllH8H3OWNXa/tofvh2
        gs2ijbPg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57904)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pXhRB-0007lI-22; Thu, 02 Mar 2023 11:49:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pXhR8-0004m8-VH; Thu, 02 Mar 2023 11:49:27 +0000
Date:   Thu, 2 Mar 2023 11:49:26 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <ZACNRjCojuK6tcnl@shell.armlinux.org.uk>
References: <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
 <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
 <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
 <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
 <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
 <20230228142648.408f26c4@kernel.org>
 <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
 <20230228145911.2df60a9f@kernel.org>
 <20230301170408.0cc0519d@kmaincent-XPS-13-7390>
 <ZAAn1deCtR0BoVAm@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZAAn1deCtR0BoVAm@hoboy.vegasvil.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 08:36:37PM -0800, Richard Cochran wrote:
> On Wed, Mar 01, 2023 at 05:04:08PM +0100, Köry Maincent wrote:
> > I suppose the idea of Russell to rate each PTP clocks may be the best one, as
> > all others solutions have drawbacks. Does using the PTP clock period value (in
> > picoseconds) is enough to decide which PTP is the best one? It is hardware
> > specific therefore it is legitimate to be set by the MAC and PHY drivers.
> 
> It is not that simple.  In fact, I've never seen an objective
> comparision of different HW.  The vendors surely have no reason to
> conduct such a study.  Also, the data sheets never make any claim
> about synchronization quality.

mvpp2 (MAC) hardware has a counter in hardware that we can read the
timestamps from, and it supports being fine-tuned and stepped in
hardware. So the hardware gives us the timestamps with no shenanigans.
The hardware timestamp is incremented by a programmable amount
(including a 32-bit fractional part) every 3ns.

The mvpp2 hardware captures the timestamp when receiving packets, and
places the timestamp in the buffer descriptors - there is no filtering
and this timestamping essentially comes for free from the software
perspective. There is no requirement to read any registers before the
next packet that needs to be timestamped, and the timestamps can not
be confused which packet they are intended for. Since these timestamps
are in the buffer descriptors, they are available as soon as the packet
is ready to be passed to the networking layers.

Timestamps can be inserted into transmitted packets and the checksums
updated by the hardware. The hardware has capability to do a number
of operations on the packets when inserting the timestamp, although
I never wrote software support for this (I wanted some way to
positively test these but I don't think I had a way to do that.)
Multiple transmit packets can be queued for timestamping and the
hardware will cope.

Hardware signals are supported. The hardware has event capture,
capabilities, which snapshots the counter, and this should give high
accuracy. However, for generation of events, e.g. PPS, I have observed
that there is no way to ensure that the PPS signal is aligned to the
start of a second. That said, the signal is subject to the fine
adjustments of the hardware counter - so increasing the hardware
counter's increment correctly shortens the PPS signal period.

All accesses to the hardware are fast, being MMIO, which gives a
very stable reading when the hardware clock is adjusted by ptp4l.

The hardware timestamp counter is shared across all three ethernet
interfaces of the CP110 die, and there can be more than one CP110
die in a SoC.


Marvell PHY hardware is qutie different. The counter is updated every
8ns, and merely increments by one each time. There is no fractional
adjustment, meaning that there is no fine adjustment of the hardware.
Fine adjustment is performed by using the kernel's timecounter
infrastructure.

The counter is accessed over MDIO which appears to introduce a lot of
variability in latency, which transfers over to read accesses to the
counter, and thus the read timestamp. This makes it harder for ptp4l to
synchronise the counter, and from my testing, introduces a lot of
noise.

The PHY can't modify the packet in any way, but merely captures the
counter when the packet is transmitted. The PHY needs to be programmed
with the byte offset from the start of the packet to the ethernet
protocol, and the ethernet protocol to the IP header - suggesting
that the PTP hardware needs to know whether packets will or will not
be incorporating a VLAN header (this is explicitly mentioned in e.g.
the 88e151x manual.)

The PHY's filtering applies to both the transmit and receive paths,
and as there is only one set of capture registers for a transmit
packet, this may become a problem, especially if we are not using
interrupts for the PHY. Without interrupts, at best we poll the PHY
every 2ms (but could be longer due to MDIO access times.)

For receive, the PHY implement two capture register sets. The PHY
needs to parse the packet (using the offsets into the packet above)
in order to retrieve the MessageID field which is then used to work
out which receive capture register to write the packet's counter
value to. This means if one receives several PTP packets in quick
succession, there is a chance to lose timestamps.

The situation with hardware signals will be similar to PP2, in that
event capture takes a snapshot of the hardware counter, which can
then be translated. However, as the hardware counter does not get
adjusted, signal generation is tied to the unadjusted rate at which
the hardware ticks at, which means that asking for a PPS, the
generated signal will drift as the PHY 125MHz clock drifts.


In conclusion, not only does PP2 have a 3ns tick vs 8ns for PHY, PP2
can more reliably capture the timestamps, reading the hardware counter
value has less noise, and thus can be synchronised by ptp4l with far
less random variance than the PHY implementation.

Therefore, I believe that the Marvell PHY PTP implementation is all
round inferior to that found in the Marvell PP2 MAC, and hence why I
believe that the PP2 MAC implementation should be used by default over
the PHY.


(In essence, because of all the noise when trying the Marvell PHY with
ptp4l, I came to the conlusion that NTP was a far better solution to
time synchronisation between machines than PTP would ever be due to
the nose induced by MDIO access. However, I should also state that I
basically gave up with PTP in the end because hardware support is
overall poor, and NTP just works - and I'd still have to run NTP for
the machines that have no PTP capabilities. PTP probably only makes
sense if one has a nice expensive grand master PTP clock on ones
network, and all the machines one wants to synchronise have decent
PTP implementations.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
