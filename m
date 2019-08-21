Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E567E975FC
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfHUJYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 05:24:11 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:57294 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfHUJYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 05:24:11 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: TfNkMrrhyb5EUx6EAOB9ixd9sS3OljjA7sRu8k4UZmEVWsl82OLRm6hrDKs+IGJkG6lUjN5RYm
 T1YhQTZfG3iaK5glTcfdoDyhRr6Ocnm7k5V/4Wb2i6k+dskoDtRKIsburhyXOfIBVN0bbXmoO8
 M5jdkGo5jsSf/kH/31SB4LzCv2NwMCU29ufrKhyDVA+wOal+EGaZ+the1y8mP/yP8wbB6Tz7na
 DP0lLlHXnm7XvnlcRvqt9rdj5pr3qNan9ps1Yd2knqUF4W+No3k/76MjZCaK4RNVnRJgxhmgsj
 PHY=
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="45953286"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Aug 2019 02:24:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 21 Aug 2019 02:24:09 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 21 Aug 2019 02:24:08 -0700
Date:   Wed, 21 Aug 2019 11:24:08 +0200
From:   "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
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
Message-ID: <20190821092406.p66uto4kuozakels@lx-anielsen.microsemi.net>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain>
 <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
 <20190816132959.GC8697@bistromath.localdomain>
 <20190820100140.GA3292@kwain>
 <20190820144119.GA28714@bistromath.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190820144119.GA28714@bistromath.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I can add some information to the HW Antoine is working on, general design of it
and the thoughts behind it. See below.

The 08/20/2019 16:41, Sabrina Dubroca wrote:
> 2019-08-20, 12:01:40 +0200, Antoine Tenart wrote:
> > So it seems the ability to enable or disable the offloading on a given
> > interface is the main missing feature. I'll add that, however I'll
> > probably (at least at first):
> > 
> > - Have the interface to be fully offloaded or fully handled in s/w (with
> >   errors being thrown if a given configuration isn't supported). Having
> >   both at the same time on a given interface would be tricky because of
> >   the MACsec validation parameter.
> > 
> > - Won't allow to enable/disable the offloading of there are rules in
> >   place, as we're not sure the same rules would be accepted by the other
> >   implementation.
> 
> That's probably quite problematic actually, because to do that you
> need to be able to resync the state between software and hardware,
> particularly packet numbers. So, yeah, we're better off having it
> completely blocked until we have a working implementation (if that
> ever happens).
> 
> However, that means in case the user wants to set up something that's
> not offloadable, they'll have to:
>  - configure the offloaded version until EOPNOTSUPP
>  - tear everything down
>  - restart from scratch without offloading
> 
> That's inconvenient.
> 
> Talking about packet numbers, can you describe how PN exhaustion is
> handled?  I couldn't find much about packet numbers at all in the
> driver patches (I hope the hw doesn't wrap around from 2^32-1 to 0 on
> the same SA).
New SA's are suppose to be installed ahead of time. The HW will automatic move
to the next SA and reset the PN.

> At some point userspace needs to know that we're
> getting close to 2^32 and that it's time to re-key.  Since the whole
> TX path of the software implementation is bypassed, it looks like the
> PN (as far as drivers/net/macsec.c is concerned) never increases, so
> userspace can't know when to negotiate a new SA.
> 
> > I'm not sure if we should allow to mix the implementations on a given
> > physical interface (by having two MACsec interfaces attached) as the
> > validation would be impossible to do (we would have no idea if a
> > packet was correctly handled by the offloading part or just not being
> > a MACsec packet in the first place, in Rx).
> 
> That's something that really bothers me with this proposal. Quoting
> from the commit message:
> 
> > the packets seen by the networking stack on both the physical and
> > MACsec virtual interface are exactly the same
> 
> If the HW/driver is expected to strip the sectag, I don't see how we
> could ever have multiple secy's at the same time and demultiplex
> properly between them. That's part of the reason why I chose to have
> virtual interfaces: without them, picking the right secy on TX gets
> weird.

The HW does frame clasification, and use the claisfication to associate frames
to a given secy.

We we in SW have eth0, with 2 vlan-sub interfaces, and enable macsec on those,
then we have:

eth0
eth0.10
eth0.10.macsec
eth0.20
eth0.20.macsec

In this case the HW needs to be configured to match vlan 10 to one secy, and
vlan 20 to an other one.

This is nor supported in the current patch, but is something we can add later.
We just wanted to get the basic functionallity done right before moving on to
this.

But in the current design, there is nothing that prevent us from adding this.

If anyone is interested in the details of this then it is described in section
3.6.3 in http://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10455.pdf

It is possible to construct an encapsulation that the HW can not classify
correctly. If that is the case, then we should reject the HW offload, and use
the SW.

But it is a good point, which I think is missing. We should properly reject
MACsec HW offload (with this driver, in this state) on virtual interfaces, if
the encapsulation can not be handled (could start by reject all virtual
interfaces)

> AFAICT, it means that any filters (tc, tcpdump) need to be different
> between offloaded and non-offloaded cases.
It will see the result of the offloaded operation. But I guess that this is no
different from when 'tc' operations are offloaded to HW.

> How does the driver distinguish traffic that should pass through unmodified
> from traffic that the HW needs to encapsulate and encrypt?
It relay on frame classification (I think Antoine is missing a flow
configuration to bypass all MKA traffic).

> If you look at IPsec offloading, the networking stack builds up the
> ESP header, and passes the unencrypted data down to the driver. I'm
> wondering if the same would be possible with MACsec offloading: the
> macsec virtual interface adds the header (and maybe a dummy ICV), and
> then the HW does the encryption. In case of HW that needs to add the
> sectag itself, the driver would first strip the headers that the stack
> created. On receive, the driver would recreate a sectag and the macsec
> interface would just skip all verification (decrypt, PN).
I do not think this is possible with this HW, nor do I think this is desirable.

One of the big differences between MACsec and IPsec, is the fact that it is a L2
protocol, designed to be running on switches (this is how MACsec claims to limit
key-distributions issues, as all frames are decrypted when entering a switch,
and encrypted with a new key when leaving).

If a SW stack needs to add a tag to the frame, then we cannot offload traffic
being bridged in HW, and never goes to the CPU.

/Allan
