Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5585E12F638
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 10:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgACJmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 04:42:12 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38526 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgACJmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 04:42:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hSd+k6iEqKzmVNrZP+DHV8Hbt5OZ637hPUdUGMwBIcY=; b=ECEROtfhmTzdfVvRP6/P7P38t
        YLZuVw7ZpfleLYEmPUhvtbGyVDEH2cxEaLM+er9zuOJkxxxGO6OBr2ELCJw7TW1tAud0NiyeCXlii
        ZWI5eo1yUb0Hq/b2x5YnCmlXheqmrbf2EuI4spM019wIwiD+tzOGU7didPvNiV3tuQDtxihOscWS1
        5eOLFv8uNWfu1Me75HI/FZtzEPhhKzUUYm5irjkLrxjmJe/vyo9HWYcg79MDAAnp7hslJUGNDYaBX
        hDjKlc+uiJl41DmOk9V7FUDY2LI1MlyWhVIB7Jv2Ji/P4Ckz0bpAEK9pUvhu8kdTU1vZusq5Uf4Ps
        O8wlbLr5w==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:57482)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1inJT4-0001Jq-Io; Fri, 03 Jan 2020 09:42:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1inJT2-00031p-VS; Fri, 03 Jan 2020 09:42:04 +0000
Date:   Fri, 3 Jan 2020 09:42:04 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20200103094204.GA18808@shell.armlinux.org.uk>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
 <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103092718.GB25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200103092718.GB25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 09:27:18AM +0000, Russell King - ARM Linux admin wrote:
> Merely specifying "xfi" does not tell you what you need to do to achieve
> XFI compliance at the point defined in INF8077i.  Plus, XFI can also be
> protocols _other_ than 10GBASE-R.
> 
> Claiming that "XFI" properly defines the interface is utter rubbish. It
> does not. XFI defines the electrical characteristics *only* and not
> the underlying protocol. It is not limited to 10GBASE-R, but includes
> other protocols as well.

Let me quote from INF-8077i, which is the XFP MSA, the document
responsible for defining XFI:

3.1 INTRODUCTION
   XFI signaling is based on high speed low voltage logic, with nominal 100
   Ohms differential impedance and AC coupled in the module. XFI was de-
   veloped with the primary goal of low power and low Electro-Magnetic-In-

   terference (EMI). To satisfy this requirement the nominal differential signal   levels are 500 mV p-p with edge speed control to reduce EMI.

3.2 XFI APPLICATIONS DEFINITION
   The application reference model for XFI, which connects a high speed
   ASIC/SERDES to the XFP module is shown in Figure 4. The XFI interface
   is designed to support SONET OC-192, IEEE.Std-802.3ae, 10GFC and
   G.709(OTU-2) applications. The SERDES is required to meet the applica-
   tion requirements for jitter generation and transfer when interfaced with a
   compliant XFP module through an XFP compliant channel. Modules or

   hosts designed only for 10 Gigabit Ethernet or 10GFC are not required to
   meet more stringent Telecom jitter requirements. XFI supported data
   rates are listed in Table 5. XFP compliant module are not required to sup-
   port all the rates listed in Table 5 in simultaneously.

   Standard                            Description           Nominal Bit Rate     Units
   OC-192/SDH-64                         SONET                     9.95         Gigabaud
   IEEE std-802.3ae             10 Gb/s Ethernet LAN PHY           10.31        Gigabaud
   INCITS/T11 Project 1413-D             10GFC                     10.52        Gigabaud
   ITU G.709(OTU-2)                 OC-192 Over FEC                10.70        Gigabaud
   Emerging                     10Gb/s Ethernet Over G.709         11.09        Gigabaud

So here, we can clearly see that it's possible to run SONET, 10GBASE-R,
10G Fiberchannel, OC-192, and G.709 over XFI, so XFI does not describe
_just_ ethernet. If we're going to be configuring a serdes to output
XFI, we need to know a lot more than just "XFI".

   XFI Compliance points are defined as the following:

   •   A: SerDes transmitter output at ASIC/SerDes package pin on a DUT
       board 3.6 and A.1
   •   B: Host system SerDes output across the host board and connector
       at the Host Compliance Test Card 3.7.1 and A.2
   •   B': XFP transmitter input across the Module Compliance Test Board
       3.8.1 and A.3.
   •   C: Host system input at the Host Compliance Test Card input 3.7.2
       and A.2
   •   C': XFP module output across the Module Compliance Test Board
       3.8.2 and A.3.

   •   D: ASIC/SerDes input package pin on the DUT board 3.6.2 and A.1.

   ASIC/SerDes compliance points are informative.

So the electrical points that count are B, B', C and C'. A and D
are merely "informative".  Hence, compliance with XFI is required
to take the entire platform into account, not just the output of
the serdes/asic.  That means the performance of the PCB needs to
be described in DT if you want to achieve compliance with XFI.
phy_interface_t can't do that.

So, let me re-iterate: neither XFI nor SFI are suitable for
phy_interface_t. XFI defines merely a group of possible protocols
and an electrical specification. It doesn't tell you which of those
protocols you should be using.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
