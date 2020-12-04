Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74D82CF14B
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgLDPwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgLDPwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 10:52:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EC6C0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 07:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KzIvSp1jZhxnKmB0cQKgKlu72v34I4hyKbDN7VJr4LI=; b=sWk0D1fkwpyoxIG9uBXwe9aiS
        Noht/h7CKsCRpnhHnYZdwx9kHVC9JAVSUTvHDLGQtpHTzxcCzaWXkgHMThWwR0diOipWXw1rZJafM
        oTkLN8iXBm7mgVFuVy8+L0NroD3/lwYOF/Vrfizko+02uHZxrrXuxwiYKGvytAGrs8C+AWLyxwPdQ
        q/Zc3UDz9SH2NuFeBhQIs0tgR7ZVDYsKdA6XIBjmkTCQspAZhpoLiufgu9DIVdaS/qE/Nx27U4mVl
        SuDO/PVihmNJ+mSCuuHEnKIegoGQGnwx1O/BIpk35AboPW1oYuVeQYunkXxzeJ0S1eLeJXazEVTa1
        VotGu3lVA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39722)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1klDNI-0004Yp-Kt; Fri, 04 Dec 2020 15:52:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1klDNH-0000mz-GE; Fri, 04 Dec 2020 15:51:59 +0000
Date:   Fri, 4 Dec 2020 15:51:59 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: sfp: relax bitrate-derived mode check
Message-ID: <20201204155159.GN1551@shell.armlinux.org.uk>
References: <20201204143451.GL1551@shell.armlinux.org.uk>
 <E1klCBD-0001si-Qj@rmk-PC.armlinux.org.uk>
 <20201204153850.GD2400258@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204153850.GD2400258@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 04:38:50PM +0100, Andrew Lunn wrote:
> On Fri, Dec 04, 2020 at 02:35:27PM +0000, Russell King wrote:
> > Do not check the encoding when deriving 1000BASE-X from the bitrate
> > when no other modes are discovered. Some GPON modules (VSOL V2801F
> > and CarlitoxxPro CPGOS03-0490 v2.0) indicate NRZ encoding with a
> > 1200Mbaud bitrate, but should be driven with 1000BASE-X on the host
> > side.
> 
> Seems like somebody could make a nice side line writing SFP EEPROM
> validation tools. There obviously are none in widespread use!

Definitely. Here's an example of another module:

  Identifier                                : 0x02 (module soldered to motherboard)

This is incorrect, it's a plug-in module.

  Transceiver codes                         : 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0x00
  Transceiver type                          : 10G Ethernet: 10G Base-ER [SFF-8472 rev10.4 onwards]
  Transceiver type                          : 10G Ethernet: 10G Base-LRM
  Transceiver type                          : 10G Ethernet: 10G Base-LR
  Transceiver type                          : 10G Ethernet: 10G Base-SR
  Transceiver type                          : Infiniband: 1X SX
  Transceiver type                          : Infiniband: 1X LX
  Transceiver type                          : Infiniband: 1X Copper Active        Transceiver type                          : Infiniband: 1X Copper Passive
  Transceiver type                          : ESCON: ESCON MMF, 1310nm LED        Transceiver type                          : ESCON: ESCON SMF, 1310nm Laser
  Transceiver type                          : SONET: OC-192, short reach
  Transceiver type                          : SONET: SONET reach specifier bit 1
  Transceiver type                          : SONET: SONET reach specifier        Transceiver type                          : SONET: SONET reach specifier bit 2
  Transceiver type                          : SONET: OC-48, long reach
  Transceiver type                          : SONET: OC-48, intermediate reach
  Transceiver type                          : SONET: OC-48, short reach
  Transceiver type                          : SONET: OC-12, single mode, long reach
  Transceiver type                          : SONET: OC-12, single mode, inter. reach
  Transceiver type                          : SONET: OC-12, short reach
  Transceiver type                          : SONET: OC-3, single mode, long reach
  Transceiver type                          : SONET: OC-3, single mode, inter. reach
  Transceiver type                          : SONET: OC-3, short reach
  Transceiver type                          : Ethernet: BASE-PX
  Transceiver type                          : Ethernet: BASE-BX10
  Transceiver type                          : Ethernet: 100BASE-FX
  Transceiver type                          : Ethernet: 100BASE-LX/LX10
  Transceiver type                          : Ethernet: 1000BASE-T
  Transceiver type                          : Ethernet: 1000BASE-CX
  Transceiver type                          : Ethernet: 1000BASE-LX
  Transceiver type                          : Ethernet: 1000BASE-SX
  Transceiver type                          : FC: very long distance (V)
  Transceiver type                          : FC: short distance (S)
  Transceiver type                          : FC: intermediate distance (I)
  Transceiver type                          : FC: long distance (L)
  Transceiver type                          : FC: medium distance (M)
  Transceiver type                          : FC: Shortwave laser, linear
Rx (SA)
  Transceiver type                          : FC: Longwave laser (LC)
  Transceiver type                          : FC: Electrical inter-enclosure (EL)
  Transceiver type                          : FC: Electrical intra-enclosure (EL)
  Transceiver type                          : FC: Shortwave laser w/o OFC
(SN)
  Transceiver type                          : FC: Shortwave laser with OFC (SL)
  Transceiver type                          : FC: Longwave laser (LL)
  Transceiver type                          : Active Cable
  Transceiver type                          : Passive Cable
  Transceiver type                          : FC: Copper FC-BaseT
  Transceiver type                          : FC: Twin Axial Pair (TW)
  Transceiver type                          : FC: Twisted Pair (TP)
  Transceiver type                          : FC: Miniature Coax (MI)
  Transceiver type                          : FC: Video Coax (TV)
  Transceiver type                          : FC: Multimode, 62.5um (M6)
  Transceiver type                          : FC: Multimode, 50um (M5)
  Transceiver type                          : FC: Single Mode (SM)
  Transceiver type                          : FC: 1200 MBytes/sec
  Transceiver type                          : FC: 800 MBytes/sec
  Transceiver type                          : FC: 400 MBytes/sec
  Transceiver type                          : FC: 200 MBytes/sec
  Transceiver type                          : FC: 100 MBytes/sec

This, of course, _really_ messes up our current EEPROM parsing code.
I can only think that this SFP module is very very large externally
to support all those different connectors for all those capabilities!

I think it's safe to assume all SFP GPON modules are broken in one
way or another, and sadly no manufacturer cares one iota what they
stuff into their EEPROM. So far, every GPON module I've heard of has
had some problem or another. This is a really sad state of affairs.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
