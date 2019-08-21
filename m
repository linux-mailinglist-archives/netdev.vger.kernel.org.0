Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43BB97629
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfHUJ1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 05:27:45 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:53778 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfHUJ1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 05:27:45 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 1fZPvctk3M5E6OBH/1XNx7MwexqUr1pyi08/BFFgG3fIzmxLB7YZF9+6gua8wu7j1VvWUoKYL/
 PElMhrlM76A8pBrGG+Ffwbs9UoMSaukahzYL8y5BC2zZdwqEJ3psZ8ElH2ImoSoZ2pqhYlnzz5
 lR5mdsNWe5PLIQx3yST6Tb7RbJmHhUrIhivNDDxFA7McNpsvyNLubHjYbOxEbv04siFmX/5lpE
 HFdur53dAUhHO8fVeJtP8Tc8/5jyIGDEW6I54c5F6tD7qmvMhVV7IxYntg0UwMx6ezL9hgu3Ni
 9SU=
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="47356862"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Aug 2019 02:27:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 21 Aug 2019 02:27:28 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 21 Aug 2019 02:27:27 -0700
Date:   Wed, 21 Aug 2019 11:27:27 +0200
From:   "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
CC:     Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Message-ID: <20190821092726.do4nmtimizqmagkh@lx-anielsen.microsemi.net>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
 <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
 <20190816132959.GC8697@bistromath.localdomain>
 <20190820100140.GA3292@kwain>
 <20190820144119.GA28714@bistromath.localdomain>
 <81ec0497-58cd-1f4c-faa3-c057693cd50e@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <81ec0497-58cd-1f4c-faa3-c057693cd50e@aquantia.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/21/2019 09:20, Igor Russkikh wrote:
> > Talking about packet numbers, can you describe how PN exhaustion is
> > handled?  I couldn't find much about packet numbers at all in the
> > driver patches (I hope the hw doesn't wrap around from 2^32-1 to 0 on
> > the same SA).  At some point userspace needs to know that we're
> > getting close to 2^32 and that it's time to re-key.  Since the whole
> > TX path of the software implementation is bypassed, it looks like the
> > PN (as far as drivers/net/macsec.c is concerned) never increases, so
> > userspace can't know when to negotiate a new SA.
> 
> I think there should be driver specific implementation of this functionality.
> As an example, our macsec HW issues an interrupt towards the host to indicate
> PN threshold has reached and it's time for userspace to change the keys.
> 
> In contrast, current SW macsec implementation just stops this SA/secy.
> 
> > I don't see how this implementation handles non-macsec traffic (on TX,
> > that would be packets sent directly through the real interface, for
> > example by wpa_supplicant - on RX, incoming MKA traffic for
> > wpa_supplicant). Unless I missed something, incoming MKA traffic will
> > end up on the macsec interface as well as the lower interface (not
> > entirely critical, as long as wpa_supplicant can grab it on the lower
> > device, but not consistent with the software implementation). How does
> > the driver distinguish traffic that should pass through unmodified
> > from traffic that the HW needs to encapsulate and encrypt?
> 
> I can comment on our HW engine - where it has special bypass rules
> for configured ethertypes. This way macsec engine skips encryption on TX and
> passes in RX unencrypted for the selected control packets.
In our case it is a TCAM which can look at various fields (including ethertype),
but is sounds like we have a vary similar design.

> But thats true, realdev driver is hard to distinguish encrypted/unencrypted
> packets. In case realdev should make a decision where to put RX packet,
> it only may do some heuristic (since after macsec decription all the
> macsec related info is dropped. Thats true at least for our HW implementation).
Same for ours.

> > If you look at IPsec offloading, the networking stack builds up the
> > ESP header, and passes the unencrypted data down to the driver. I'm
> > wondering if the same would be possible with MACsec offloading: the
> > macsec virtual interface adds the header (and maybe a dummy ICV), and
> > then the HW does the encryption. In case of HW that needs to add the
> > sectag itself, the driver would first strip the headers that the stack
> > created. On receive, the driver would recreate a sectag and the macsec
> > interface would just skip all verification (decrypt, PN).
> 
> I don't think this way is good, as driver have to do per packet header mangling.
> That'll harm linerate performance heavily.
Agree, and it will also prevent MACsec offload in offloaded bridge devices.

/Allan
