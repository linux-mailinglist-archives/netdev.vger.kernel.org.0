Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2858CEDC
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 10:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfHNI5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 04:57:14 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:59752 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbfHNI5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 04:57:14 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: +g4SNxAm9w1IwWEE755hpBtq9x3kxSPWhhRFBWPBzttOpYhliK4vmuv7clDZbWEhyvq4mdb4Gu
 Ap6dfG0r74tGhENe7jZlzuwkdDwVXCly8/PjZoxsmsSzcoZrxyu4FUjX+MAF5Fq08Dyb9s8mOb
 tfCtfY/f9NwgqCkfWMZXQjnBKnjAU4LI0hRzqEIhDfuXgq4DCc0yu+L79KI8lmnlW9VMDFfyE5
 Yv/xDNtkLann1JOkP5s/XstJmIJviSST72hXQSXDJp5FEya47uvem8sc+tsJCKpK50esiTEr9o
 2mk=
X-IronPort-AV: E=Sophos;i="5.64,384,1559545200"; 
   d="scan'208";a="43548978"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Aug 2019 01:57:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 14 Aug 2019 01:57:13 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 14 Aug 2019 01:57:12 -0700
Date:   Wed, 14 Aug 2019 10:57:12 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
Message-ID: <20190814085711.7654bff2u66o4yjj@lx-anielsen.microsemi.net>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-4-yangbo.lu@nxp.com>
 <20190812123147.6jjd3kocityxbvcg@lx-anielsen.microsemi.net>
 <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190813134236.GG15047@lunn.ch>
 <VI1PR0401MB2237D9358AA17400E72A776EF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB2237D9358AA17400E72A776EF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Y.b. and Andrew,

The 08/14/2019 04:28, Y.b. Lu wrote:
> > > I'd like to trap all IEEE 1588 PTP Ethernet frames to CPU through etype
> > 0x88f7.
> > 
> > Is this the correct way to handle PTP for this switch? For other switches we
> > don't need such traps. The switch itself identifies PTP frames and forwards
> > them to the CPU so it can process them.
> > 
> > I'm just wondering if your general approach is wrong?
> 
> [Y.b. Lu] PTP messages over Ethernet will use two multicast addresses.
> 01-80-C2-00-00-0E for peer delay messages.
Yes, and as you write, this is a BPDU which must not be forwarded (and they are
not).

> 01-1B-19-00-00-00 for other messages.
Yes, this is a normal L2 multicast address, which by default are broadcastet.

> But only 01-80-C2-00-00-0E could be handled by hardware filter for BPDU frames
> (01-80-C2-00-00-0x).  For PTP messages handling, trapping them to CPU through
> VCAP IS2 is the suggested way by Ocelot/Felix.
As I see it there are at least 3 scenarios which needs to be considered and
ideally supported:

1) Operate as a PTP-unaware switch. This means that Peer-delays messages are
   trapped to the CPU and not handled. End-to-End PTP sessions can still run on
   the network as 01-1B-19-00-00-00 frames are forwarded normally.

   This is what we have by default today.

2) A "passive" PTP switch (in MSCC/MCHP we call this an end-to-end transparent
   clock) where 01-80-C2-00-00-0E frames are still trapped to the CPU (and not
   handled), 01-1B-19-00-00-00 frames are forwarded, but we use the TCAM to add
   the residence time to the correction field in Sync and Delay request
   messages.

   This is a simple mechanism which allow end-to-end PTP sessions to synchronize
   their time, and compensate for the variable delay caused by the switch.

   Compared to implement a complete boundary clock, this is much simpler, and
   cause a much lower work load on the CPU (even small switches may be serving
   many many PTP sessions).

3) Full PTP aware switch. In this mode we need all PTP frames trapped (on the
   ports where PTP are running) to the CPU, and we need a PTP daemon in
   user-space to process them in-order for things to work.

   I guess this is what you are trying to achieve.

Eventually, I hope we can get to a point where all (and maybe more) scenarios
are supported.

Lets consider them case by case:

1) This is what we have today.

2) To support this, we need a SW implementation of this, and then we can add
   hooks to offload this in HW.

   We would certainly be interested in supporting this in both SW and HW.

3) It can be done via 'tc' using the trap action, but I do not know if this is
   the desired way of doing it. Ocelot will be using a TCAM rule to do this,
   which align nicely with the 'tc' approach, but other chips may be have
   dedicated HW for doing this.

   Also, in the current implementation we will be using a rule per port, and
   ideally we could have done it with a single rule (this is what Y.B. prepared
   in this patch series).

I'm very much against configuring option 3 in the driver initialization, as it
will prevent us from having a conforming switch if a PTP daemon is not running
in user-space, and it give us very little room for supporting other ways in the
future without breaking backwards compatibility.

> I have a question since you are experts.
I'm not really an expert on this, but I have access to some good guidance from
collages knowing PTP very well :-D

> For other switches, whether they are always trapping PTP messages to CPU?
Good question, I could not find anything in the SW bridge forcing option 3.

My understanding is that the SW bridge is implementing option 1, but I could be
wrong.

> Is there any common method in linux to configure switch to select trapping or
> just forwarding PTP messages?
You should be able to use TC for this. But due to the port vs port-mask
limitation you will need to install a rule per port.

I do not know if this is what others are doing, but would like to learn about
that.

/Allan

