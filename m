Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2E32245D2
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 23:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgGQV0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 17:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgGQV0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 17:26:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE0CC0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 14:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gEFphdCL42n8bbkybedKWhFQY8U80WEnIYyFDmvTZ3E=; b=0m1trrAvUZnMRxMAy3xFnBkVt
        tETfnoKoKPmMiswcWymU8ijv0xGtUDBlUGBOErziXuUXNvhMbFzvyn+27TO0bhejmPzBGycBhYR3W
        h0AJx+Xy30dHil/qrXcnU8WwJThu19utTvSVqtrdA5VHpEdwuJSdoDlKn7ZR4KY58FBbXoOJeSyr7
        nfD3orEwXpTUwA3X11vD5/L9+GQpDpfwLX0rj4L5rkplmmDwyJNHAKvNUik2z3mujh/T0dIIFML/t
        v1WsNsaj8iAxN3m+8U2jSID83L2CYLMlKmvUpR86pktlxlXDCc2EKbzkBBH7KlL4LkaBG2m1jWoTb
        3d4jkTQjA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40788)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jwXrr-00016D-S1; Fri, 17 Jul 2020 22:26:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jwXrp-0002EK-I3; Fri, 17 Jul 2020 22:26:05 +0100
Date:   Fri, 17 Jul 2020 22:26:05 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>, Martin Rowe <martin.p.rowe@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vivien.didelot@gmail.com
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
Message-ID: <20200717212605.GM1551@shell.armlinux.org.uk>
References: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
 <20200711162349.GL1014141@lunn.ch>
 <20200711192255.GO1551@shell.armlinux.org.uk>
 <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com>
 <20200712132554.GS1551@shell.armlinux.org.uk>
 <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
 <20200717092153.GK1551@shell.armlinux.org.uk>
 <CAOAjy5RNz8mGi4XjP_8x-aZo5VhXRFF446R7NgcQGEKWVpUV1Q@mail.gmail.com>
 <20200717185119.GL1551@shell.armlinux.org.uk>
 <20200717194237.GE1339445@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717194237.GE1339445@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 09:42:37PM +0200, Andrew Lunn wrote:
> On Fri, Jul 17, 2020 at 07:51:19PM +0100, Russell King - ARM Linux admin wrote:
> > On Fri, Jul 17, 2020 at 12:50:07PM +0000, Martin Rowe wrote:
> > > On Fri, 17 Jul 2020 at 09:22, Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > > The key file is /sys/kernel/debug/mv88e6xxx.0/regs - please send the
> > > > contents of that file.
> > > 
> > > $ cat regs.broken
> > >     GLOBAL GLOBAL2 SERDES     0    1    2    3    4    5
> > >  0:  c800       0    ffff  9e07 9e4f 100f 100f 9e4f 170b
> > >  1:     0    803e    ffff     3    3    3    3    3 201f
> >                                                       ^^^^
> > This is where the problem is.
> > 
> > >  1:     0    803e    ffff     3    3    3    3    3 203f
> >                                                       ^^^^
> > 
> > In the broken case, the link is forced down, in the working case, the
> > link is forced up.
> > 
> > What seems to be happening is:
> > 
> > dsa_port_link_register_of() gets called, and we do this:
> > 
> >                 phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
> >                 if (of_phy_is_fixed_link(dp->dn) || phy_np) {
> >                         if (ds->ops->phylink_mac_link_down)
> >                                 ds->ops->phylink_mac_link_down(ds, port,
> >                                         MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
> >                         return dsa_port_phylink_register(dp);
> > 
> > which forces the link down, and for some reason the link never comes
> > back up.
> >
> > One of the issues here is of_phy_is_fixed_link() - it is dangerous.
> > The function name leads you astray - it suggests that if it returns
> > true, then you have a fixed link, but it also returns true of you
> > have managed!="auto" in DT, so it's actually fixed-or-inband-link.
> > 
> > Andrew, any thoughts?
> 
> 
> Hi Russell
> 
> I think that is my change, if i remember correctly. Something to do
> with phylink assuming all interfaces are down to begin with. But DSA
> and CPU links were defaulting to up. When phylink later finds the
> fixed-link it then configures the interface up again, and because the
> interface is up, nothing actually happens, or it ends up in the wrong
> mode. So i think my intention was, if there is a fixed link in DT,
> down the interface before registering it with phylink, so its
> assumptions are true, and it will later be correctly configured up.
> 
> So in this case, do you think we are falling into the trap of
> managed!="auto" ?

Yes, it looks that way to me.  The DT description for the port is:

                        port@5 {
                                reg = <5>;
                                label = "cpu";
                                ethernet = <&cp1_eth2>;
                                phy-mode = "2500base-x";
                                managed = "in-band-status";
                        };

So, of_phy_is_fixed_link() will return true, but as far as phylink is
concerned, it's in in-band status mode rather than fixed-link mode.
Hmm.

Digging out the serdes PHY status on my GT8k (C45 address 21, PHYXS):

 2000  1140 0145 0141 0c00 00a0 0000 0004 2001
 2008  0000 0000 0000 0000 0000 0000 0000 8000
...
 a000  2000 0600 0000 a420 5100 2000 0000 0000

Remembering that it's a C22 register layout for this PHY starting at
0x2000, with the Marvell status register at 0xa003.

BMCR = 0x1140 = BMCR_ANENABLE | BMCR_FULLDPLX | BMCR_SPEED1000
BMSR = 0x0145 = BMSR_ESTATEN | reserved_bit(6) | BMSR_LSTATUS | BMSR_ERCAP
Status = 0xa420 = MV88E6390_SGMII_PHY_STATUS_SPEED_1000 |
		  MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL |
		  MV88E6390_SGMII_PHY_STATUS_LINK |
		  bit(5)

Note that MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID is missing, so the
results of the speed, duplex and pause are not valid.  The only reason
the link is up is because we're forcing it up.

The other end of the link is not allowing the BASE-X configuration to
complete, which is not that surprising when you notice it is:

&cp1_eth2 {
        status = "okay";
        phy-mode = "2500base-x";
        phys = <&cp1_comphy5 2>;
        fixed-link {
                speed = <2500>;
                full-duplex;
        };
};

in fixed-link mode rather than in-band mode.

So, each end of the link has been configured differently in DT.  One
end has been told to use in-band AN, whereas the other end has been
told not to, which means when we start interpreting in-band correctly
in DSA, this dis-similar setup breaks.

Both ends really need to agree, and I'd suggest cp1_eth2 needs to drop
the fixed-link stanza and instead use ``managed = "in-band";'' to be
in agreement with the configuration at the switch.

Martin, can you modify
arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts to test
that please?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
