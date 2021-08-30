Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BB63FBC70
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbhH3SbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238803AbhH3SbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 14:31:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BC9C0613D9
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 11:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PuBw3HNhofc4619eaZTfae2vuvIs3qvYJ/JZs0AF3Uo=; b=Z/xU+vNIJj9nK30xFO0NXVPSO
        5aPxFkLoy6CX4r6JzI0tz5YWo4LztYN42Xs5WJfcsdM6QmnRVNg+V7tP4aX0IulwG2NOCdoGPc6PN
        pjt6cUtpubj3LPRKcgP8+D9eRsPZJA4FG3sQH4F1s2ALIxLRsbqwsiSY05WBs0bvoVpirfrY5BtTa
        qOFlWEu9a0U/i5tNJKDjG8sP0g7hwK8O+MgMJP6tj9UirlxhpyS/gymVo68ucqUBGqh40OOWTNid9
        GgLtl+Wfemgf+d23fUMX+kH/wyuCpQZIk8gMtk4vfv4Wp3+QCauYvG/7PLjdl1omyXN1QwCBCaRYn
        CBThSxovg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47886)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mKm33-0005Sg-1r; Mon, 30 Aug 2021 19:30:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mKm2x-00056a-VK; Mon, 30 Aug 2021 19:30:15 +0100
Date:   Mon, 30 Aug 2021 19:30:15 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [RFC PATCH v2 net-next 0/5] Let phylink manage in-band AN for
 the PHY
Message-ID: <20210830183015.GY22278@shell.armlinux.org.uk>
References: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Can we postpone this after this merge window please, so I've got time
to properly review this. Thanks.

On Mon, Aug 30, 2021 at 06:52:45PM +0300, Vladimir Oltean wrote:
> This small series creates a configuration knob for PHY drivers which use
> serial MII-side interfaces and support clause 37 in-band auto-negotiation
> there.
> 
> Changes in v2:
> Incorporated feedback from Russell, which was to consider PHYs on SFP
> modules too, and unify phylink's detection of PHYs with broken in-band
> autoneg with the newly introduced PHY driver methods.
> https://patchwork.kernel.org/project/netdevbpf/cover/20210212172341.3489046-1-olteanv@gmail.com/
> 
> This change set is only superficially tested, hence the RFC tag. It does
> what I need on the NXP boards with on-board PHYs that I have, and also
> seems to behave the same as before when I use a 1G SGMII SFP module with
> the Marvell 88E1111 PHY (the only thing I have). I do not have the
> ability to test the Methode DM7052 SFP module for the bcm84881.c driver
> change, since I don't have that.
> 
> Posting the patch series mostly to figure out whether I understood the
> change request correctly.
> 
> Vladimir Oltean (5):
>   net: phylink: pass the phy argument to phylink_sfp_config
>   net: phylink: introduce a generic method for querying PHY in-band
>     autoneg capability
>   net: phy: bcm84881: move the in-band capability check where it belongs
>   net: phylink: explicitly configure in-band autoneg for PHYs that
>     support it
>   net: phy: mscc: configure in-band auto-negotiation for VSC8514
> 
>  drivers/net/phy/bcm84881.c       | 10 ++++
>  drivers/net/phy/mscc/mscc.h      |  2 +
>  drivers/net/phy/mscc/mscc_main.c | 20 +++++++
>  drivers/net/phy/phy.c            | 25 +++++++++
>  drivers/net/phy/phylink.c        | 93 +++++++++++++++++++++++++-------
>  include/linux/phy.h              | 24 +++++++++
>  6 files changed, 154 insertions(+), 20 deletions(-)
> 
> -- 
> 2.25.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
