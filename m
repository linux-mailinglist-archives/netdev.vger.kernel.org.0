Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6136D1530AD
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 13:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgBEM1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 07:27:53 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37902 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727965AbgBEM1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 07:27:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BOW5KZykxI349ZwRVvxHRZ+Lw+4S+aeevegHK214C94=; b=q9KTEEJH599k/P0x11SS7ayg4
        L0jenCNDR9Y+41TF9olCN0RGMhGGMfF1wNh1KyWIR/npJ7yX72i6h+c9Pf8RvVDbYd9CZLXFVglHC
        eqjBzgFo/zhnRXaS6hrIfG3Wqjd3kXPn9gvb9gmzEEWrnue4KuyMiJtm/ZaSjJsd95YVX+mwb46De
        4RrfB6rGoFMsCL3ra5SVHz0bbJPEqhMPCOV9Z4qXOqdzlakTjGR+G73D+/Mn9lru7np6ATjEBQUwA
        q0FlTWlTEgMy6RHdDVUdajcHzH+IZgMtRgAo+f8PBglLJZ9aBnvHnuMxhwYXlt2BSyT3/vqFtzXkU
        VG+Jm69dQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:36278)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1izJmN-0000RR-6U; Wed, 05 Feb 2020 12:27:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1izJmH-0001t4-Sd; Wed, 05 Feb 2020 12:27:33 +0000
Date:   Wed, 5 Feb 2020 12:27:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Message-ID: <20200205122733.GU25745@shell.armlinux.org.uk>
References: <20200127140038.GD13647@lunn.ch>
 <20200127140834.GW25745@shell.armlinux.org.uk>
 <20200127145107.GE13647@lunn.ch>
 <20200127161132.GX25745@shell.armlinux.org.uk>
 <20200127162206.GJ13647@lunn.ch>
 <c3e863b8-2143-fee3-bb0b-65699661d7ab@gmail.com>
 <BN8PR12MB3266B69DA09E1CC215843C3CD30A0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200204172603.GS25745@shell.armlinux.org.uk>
 <20200204174318.GB1364@lunn.ch>
 <20200204193230.GT25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204193230.GT25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 04, 2020 at 07:32:30PM +0000, Russell King - ARM Linux admin wrote:
> On Tue, Feb 04, 2020 at 06:43:18PM +0100, Andrew Lunn wrote:
> > > There, there is one MAC, but there are multiple different PCS - one
> > > for SGMII and 1000base-X, another for 10G, another for 25G, etc.
> > > These PCS are accessed via a MDIO adapter embedded in each of the
> > > MAC hardware blocks.
> > 
> > Hi Russell
> > 
> > Marvell mv88e6390X switches are like this is a well. There is a PCS
> > for SGMII and 1000Base-X, and a second one for 10G. And it dynamically
> > swaps between them depending on the port mode, the so called cmode.
> > 
> > So a generic solution is required, and please take your time to build
> > one.
> 
> Well, DSA is quite a mixed bag...
> 
> As far as I can work out, the situation with the CPU and DSA ports is
> quite hopeless - you've claimed that a change in phylink has broken it,
> I can't find what that may be.  The fact is, phylink has never had any
> link information for DSA links when no fixed-link property has been
> specified in DT.  As I've already said in a previous email about this,
> I can't see *any* sane way to fix that - but there was no response.
> 
> 
> On a more positive note...
> 
> The mac_link_up() changes that I've talked about should work for DSA,
> if only there was a reasonable way to reconfigure the ports.  If you
> look at the "phy" branch, you will notice that there's a patch there -
> "net: mv88e6xxx: use resolved link config in mac_link_up()" which adds
> the support to configure the MAC manually.  It's rather messy, and I
> see no way to deal with the pause settings.  There is support in some
> Marvell DSA switches to force flow control but that's not supported
> through the current mid-layer at all (port_set_pause doesn't do it.)
> I'm not sure whether the "mv88e6xxx_phy_is_internal()" check there is
> the right test for every DSA switch correct either.
> 
> What is missing is reading the results from the PCS (aka serdes) and
> forwarding them into phylink - I did have a quick look at how that might
> be possible, but the DSA code structure (consisting of multiple
> mid-layers) makes it hard without rewriting quite a lot of code.  That's
> fine if you know all the DSA chips inside out, but I don't - and that's
> where we need someone who has the knowledge of all DSA switches that we
> support.  Or, we get rid of the multiple mid-layers and switch to a
> library approach, so that we can modify support for one DSA switch
> without affecting everything.  It may be a simple matter of dropping the
> existing serdes workaround, but I'm not sure at the moment.
> 
> I've tried this code out on the ZII rev B, I haven't tried it on the rev
> C which has the 6390 switches yet.

Well, it seems GPIO hogging with the sx1503q (for the 3310 PHY, which
is a local change) has broken sometime between v4.20 and v5.5, which
prevents the sx1503q driver probing:

[   23.378706] gpio gpiochip7: (sx1503q): setup of own GPIO 10g-rstn failed
[   23.394858] requesting hog GPIO 10g-rstn (chip sx1503q, offset 9) failed, -517
[   23.402512] gpiochip_add_data_with_key: GPIOs 480..495 (sx1503q) failed to register, -517

Without the hog, the 3310 PHY doesn't come out of reset, so I lose
port 9 on the first switch.

With that removed, I can boot, and if I bring up sff2, I see the port 9
on the second switch status report 0xef4b and control 0x303f without
fiber connected.  I'm out of time to do anything further on this today
(not even decode those), because its taken all morning to get the board
to this point, and I won't have any time tomorrow either.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
