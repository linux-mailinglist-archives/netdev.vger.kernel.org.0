Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CED96A87DD
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 18:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjCBR0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 12:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCBR0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 12:26:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF574E5D7
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 09:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eO9U5Ujbz2o9KxX0Uc2XpkleuC/oIlBGm6sF9tx5xKA=; b=aTtsYUZW+r5drcI5HHvHtMEPNx
        b1ttb9VVfO5WS/IUnr6OkzqvbJa/IZRQuRb0rKBQX/pVYDtMLQ7pHkWa4VZrZI/N7ec+htfhIn9Bd
        Ygmqgv/YEtYnDVuFHGjFZoXHfDTdD1uoSnBK0RY0BVpUSEZcacLav+yQPvU/jgwCSoD167v2I8pzs
        pwixsi1PdqnNEL+yfKrBAuceTc2z0GvJ47xYH/xPdXGvR5zq++Zs9sRX8Y/Hfadsmq95dRRY/LsK3
        beMVVXsxKyCuOVXpK5VNSPF1UYmGKZn9ackvbKqESyrbvjbXUGoUWkwYGgXdUAZJ5xiXGxNC4eLNi
        XCbqnjcg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43572)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pXmhR-00088j-BD; Thu, 02 Mar 2023 17:26:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pXmhP-0004zC-Fp; Thu, 02 Mar 2023 17:26:35 +0000
Date:   Thu, 2 Mar 2023 17:26:35 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <ZADcSwvmwt8jYxWD@shell.armlinux.org.uk>
References: <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
 <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
 <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
 <20230228142648.408f26c4@kernel.org>
 <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
 <20230228145911.2df60a9f@kernel.org>
 <20230301170408.0cc0519d@kmaincent-XPS-13-7390>
 <ZAAn1deCtR0BoVAm@hoboy.vegasvil.org>
 <ZACNRjCojuK6tcnl@shell.armlinux.org.uk>
 <20230302084932.4e242f71@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302084932.4e242f71@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 08:49:32AM -0800, Jakub Kicinski wrote:
> On Thu, 2 Mar 2023 11:49:26 +0000 Russell King (Oracle) wrote:
> > (In essence, because of all the noise when trying the Marvell PHY with
> > ptp4l, I came to the conlusion that NTP was a far better solution to
> > time synchronisation between machines than PTP would ever be due to
> > the nose induced by MDIO access. However, I should also state that I
> > basically gave up with PTP in the end because hardware support is
> > overall poor, and NTP just works - and I'd still have to run NTP for
> > the machines that have no PTP capabilities. PTP probably only makes
> > sense if one has a nice expensive grand master PTP clock on ones
> > network, and all the machines one wants to synchronise have decent
> > PTP implementations.)
> 
> Don't wanna waste too much of your time with the questions since
> I haven't done much research but - wouldn't MAC timestamp be a better
> choice more often (as long as it's a real, to-spec PTP stamp)? 
> Are we picking PHY for historical reasons?
> 
> Not that flipping the default would address the problem of regressing
> some setups..

There is the argument in PTP that having the PHY do the timestamping
results in the timestamps being "closer to the wire" meaning that
they will not be subject to any delays between the packet leaving
the MAC and being transmitted on the wire. Some PHYs have FIFOs or
other buffering which introduces a delay which PTP doesn't desire.

TI has a blog on this:

https://e2e.ti.com/blogs_/b/analogwire/posts/how-to-implement-ieee-1588-time-stamping-in-an-ethernet-transceiver

However, what is failed to be mentioned there is that yes, doing
PTP at the PHY means one can accurately trigger a capture of the
timestamp from the PHC when the SFD is detected on the media. That
is a great advantage, but is really only half the story.

If the PHC (hardware counter) in the PHY can't be accurately
synchronised, for example, it has a 1.5ppm second-to-second
variability, then the resulting timestamps will also have that
same variability. Another way to look at it is they will appear to
have 1.5ppm of noise. If this noise is random, then it becomes
difficult to filter that noise out, and results in jitter.

However, timestamping at the MAC may have only 40ppb of variability,
but have a resulting delay through the PHY. The delay through the
PHY will likely be constant, so the timestamps gathered at the MAC
will have a constant error but have much less noise.

Things change if one can use hardware signals to synchronise the
PHC, because then we become less reliant on a variable latency
accessing the PHY over the MDIO bus. The hardware event capture
allows the PHC to be captured on a hardware signal, software can
then read that timestamp, and if the hardware event is a PPS,
then that can be used to ensure that the PHC is ticking at the
correct rate. If the PPS is also aligned to a second boundary,
then the hardware PHC can also be aligned. With both, the latency
of the MDIO bus becomes irrelevant, and PTP at the PHY becomes a
far more preferable option.

Note that things which can influence the latency over the MDIO bus
include how many PHYs or other devices are also on it, and the
rate at which accesses to those PHYs are performed. Then there's
latency from kernel locking and scheduling. Maybe interrupt
latency if the MDIO bus driver uses interrupts.

When I created the generic Marvell PHY PTP layer (my patch set
for Marvell PHYs) I tried very hard to eliminate as many of these
sources of variable latency as possible - such as avoiding taking
and releasing locks on every MDIO bus access. Even with that, I
could not get the PHY's PHC to synchronise any better than 1.5ppm,
vs 40ppb for the PP2 MAC's PHC.

The last bit of consideration is whether the PHCs can be synchronised
in hardware. If one has multiple ethernet interfaces, no hardware
synchronisation of PHY PHCs, but also have MAC PTP support which is
shared across the ethernet interfaces, why would one want to use the
PHY with software based synchronisation of their individual PHCs.

So, to wrap this email up... if one has hardware purposely designed
for PTP support, which uses the PTP hardware signals from the
various PHCs, then one would want to use the PHY based timestamping.
If one doesn't have that, then one would want to use something that
gives the best timestamps, which may not necessarily be the PHY.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
