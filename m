Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC863C59C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiK2QuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236288AbiK2Qty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:49:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C0462057;
        Tue, 29 Nov 2022 08:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/97m3TMDE03+EpCbdrZ+c4M2zDEjrdJ2UQ5oeB+yWak=; b=V9Ffhkkfr1FpYeTscVOOF722Ln
        4dxu2cYN7BqgJu3fNVvttE4g1TqGup2Cvk3753m0bDQbMAm5Vo82b8C4r8BDXhds4PSTneD6SLk4Z
        PAk4VbRsvmu/nBcvakeyvXgIpHMgxq+4t4+hPhljw0CVnQcl9j2R5eLw5gyC5LsIsyB7ImAaiM3jq
        6WI4JTVTw7hUrePibi2Q2SxgiRq0kTrQE5RidsCdnlMkhg+JaoLnjyWeA72D6sGF363WByU9Pq31d
        w1hvMWG6pS5aq2w0tU0Wiep8Y1q7eSBB9N04c3QfqMpS14ReqalpwDMRaxdkmPdb1FczN9DPb2YcF
        XT0pNxjA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35482)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p03kI-0000w9-Ug; Tue, 29 Nov 2022 16:46:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p03kG-0001hE-V2; Tue, 29 Nov 2022 16:46:08 +0000
Date:   Tue, 29 Nov 2022 16:46:08 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v2 2/2] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y4Y3UGBCRtCopMva@shell.armlinux.org.uk>
References: <20221128195409.100873-1-sean.anderson@seco.com>
 <20221128195409.100873-2-sean.anderson@seco.com>
 <Y4VCz2i+kkK0z+XY@shell.armlinux.org.uk>
 <b25b1d9b-35dd-a645-a5f4-05eb0dbc6039@seco.com>
 <Y4VVhwQqk2iwBzao@shell.armlinux.org.uk>
 <9d4db6a2-5d3f-1e2a-b60a-9a051a61b7da@seco.com>
 <Y4Ywh+0p8tfTMt0f@shell.armlinux.org.uk>
 <10c0545d-d9aa-8d85-e3ba-ee739cb126ef@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10c0545d-d9aa-8d85-e3ba-ee739cb126ef@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 11:29:39AM -0500, Sean Anderson wrote:
> On 11/29/22 11:17, Russell King (Oracle) wrote:
> > On Tue, Nov 29, 2022 at 10:56:56AM -0500, Sean Anderson wrote:
> >> On 11/28/22 19:42, Russell King (Oracle) wrote:
> >> > On Mon, Nov 28, 2022 at 07:21:56PM -0500, Sean Anderson wrote:
> >> >> On 11/28/22 18:22, Russell King (Oracle) wrote:
> >> >> > This doesn't make any sense. priv->supported_speeds is the set of speeds
> >> >> > read from the PMAPMD. The only bits that are valid for this are the
> >> >> > MDIO_PMA_SPEED_* definitions, but teh above switch makes use of the
> >> >> > MDIO_PCS_SPEED_* definitions. To see why this is wrong, look at these
> >> >> > two definitions:
> >> >> > 
> >> >> > #define MDIO_PMA_SPEED_10               0x0040  /* 10M capable */
> >> >> > #define MDIO_PCS_SPEED_2_5G             0x0040  /* 2.5G capable */
> >> >> > 
> >> >> > Note that they are the same value, yet above, you're testing for bit 6
> >> >> > being clear effectively for both 10M and 2.5G speeds. I suspect this
> >> >> > is *not* what you want.
> >> >> > 
> >> >> > MDIO_PMA_SPEED_* are only valid for the PMAPMD MMD (MMD 1).
> >> >> > MDIO_PCS_SPEED_* are only valid for the PCS MMD (MMD 3).
> >> >> 
> >> >> Ugh. I almost noticed this from the register naming...
> >> >> 
> >> >> Part of the problem is that all the defines are right next to each other
> >> >> with no indication of what you just described.
> >> > 
> >> > That's because they all refer to the speed register which is at the same
> >> > address, but for some reason the 802.3 committees decided to make the
> >> > register bits mean different things depending on the MMD. That's why the
> >> > definition states the MMD name in it.
> >> 
> >> Well, then it's really a different register per MMD (and therefore the
> >> definitions should be better separated). Grouping them together implies
> >> that they share bits, when they do not (except for the 10G bit).
> > 
> > What about bits that are shared amongst the different registers.
> > Should we have multiple definitions for the link status bit in _all_
> > the different MMDs, despite it being the same across all status 1
> > registers?
> 
> No, but for registers which are 95% difference we should at least separate
> them and add a comment.
> 
> > Clause 45 is quite a trainwreck when it comes to these register
> > definitions.
> 
> Maybe they should have randomized the bit orders in the first place to discourage this sort of thing :)
> 
> > As I've stated, there is a pattern to the naming. Understand it,
> > and it isn't confusing.
> > 
> 
> I don't have a problem with the naming, just the organization of the
> source file.

The organisation is sane. There are some shared bits in the SPEED
register between different MMDs.

If we separate the PMA and PCS with a blink line, do we then seperate
the register groups with two blank lines? No, people will complain
about that (they already do if you think about doing that in source
files.)

Sorry, but... one has to pay attention to the whole of the macro name,
not just the last few characters... and think "is something that
contains "_PCS_" in its name really suitable for use with a PMA/PMD
MMD register when there's a PCS MMD? Now let me think... umm. no.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
