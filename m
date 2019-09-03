Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912D9A63A0
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 10:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfICIOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 04:14:14 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:18446 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfICIOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 04:14:14 -0400
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
IronPort-SDR: BRsUDvl5TSXR8I1Tvk6+ZsNj4kGdNLerSJhcHH3iNyRmymJQoXbWjT3ZV8Cx/LmgnvA3EClsOw
 JVjD1tZAFYV9h5Rs3Lo0i5FULxmOUHOmKgPOst5tfPZbEjxm5Tmw7XMjaUaCfKfICsbxy6c39r
 irqSfxqPlQkXta+X4RSgBztBJJ7/zK9dp7uthII83Em41arZdJYbwdctrc6MKp7TtZnM/MtBSS
 t1dH8mysEhSy3Ij80CTBN3dkZSWeyixkDeCB2hE51mNkynnMut2691Rditz/DDU9lVbhPfd9E9
 Yug=
X-IronPort-AV: E=Sophos;i="5.64,462,1559545200"; 
   d="scan'208";a="48978944"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Sep 2019 01:14:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 3 Sep 2019 01:14:12 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 3 Sep 2019 01:14:12 -0700
Date:   Tue, 3 Sep 2019 10:14:12 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        <andrew@lunn.ch>, <horatiu.vultur@microchip.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <ivecera@redhat.com>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190903081410.zpcdm2dzqrxyg43c@lx-anielsen.microsemi.net>
References: <20190829193613.GA23259@splinter>
 <20190829.151201.940681219080864052.davem@davemloft.net>
 <20190830053940.GL2312@nanopsycho>
 <20190829.230233.287975311556641534.davem@davemloft.net>
 <20190830063624.GN2312@nanopsycho>
 <20190902174229.uur7r7duq4dvbnqq@lx-anielsen.microsemi.net>
 <20190903061324.GA6149@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190903061324.GA6149@splinter>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

The 09/03/2019 09:13, Ido Schimmel wrote:
> On Mon, Sep 02, 2019 at 07:42:31PM +0200, Allan W. Nielsen wrote:
> > I have been reading through this thread several times and I still do not get it.
> I kept thinking about this and I want to make sure that I correctly
> understand the end result.
So do I, and regardless of this being merged or not, I'm really happy that we
have the discussion as there are clearly a need for synchronizing the meaning of
promiscuity.

One of the reasons why we started working on this patch was the comments we got
when requesting comments on the "[PATCH] net: bridge: Allow bridge to join
multicast groups" where we want to be able to setup mac-entries for L2 multicast
MAC addresses. Here it is important for us to be able to control which ports a
static configured multicast address needs to be forwarded to (including the
CPU). When working on this patch it was pointed out that the interfaces are in
promisc mode anyway (if member of a bridge, and if flooding and learning are
enabled), and it therefore this optimization should not matter anyway.

I found that this was a fair comment, and it has been on the list of things we
wanted to "fix" for a long time.

The optimization does matter to us, as we have until now worked around the issue
by not implementing promisc mode.

When debugging, it is very useful for us to be able to see all the traffic RXed
on the interface, and to us it did make a lot of sense to "just" make promisc
mode work like we was used to.

But, this is for debugging, it is not the most important patch we have on the
backlog, and I would therefore prefer finding a solution which we are all happy
with.

> With these patches applied I assume I will see the following traffic
> when running tcpdump on one of the netdevs exposed by the ocelot driver:
> 
> - Ingress: All
> - Egress: Only locally generated traffic and traffic forwarded by the
>   kernel from interfaces not belonging to the ocelot driver
> 
> The above means I will not see any offloaded traffic transmitted by the
> port. Is that correct?
Correct - but maybe we should change this.

In Ocelot and in LANxxxx (the part we are working on now), we can come pretty
close. We can get the offloaded TX traffic to the CPU, but it will not be
re-written (it will look like the ingress frame, which is not always the same as
the egress frame, vlan tags an others may be re-written).

In some of our chips we can actually do this (not Ocelot, and not the LANxxxx
part we are working on now) after the frame as been re-written.

> I see that the driver is setting 'offload_fwd_mark' for any traffic trapped
> from bridged ports, which means the bridge will drop it before it traverses
> the packet taps on egress.
Correct.

> Large parts of the discussion revolve around the fact that switch ports
> are not any different than other ports. Dave wrote "Please stop
> portraying switches as special in this regard" and Andrew wrote "[The
> user] just wants tcpdump to work like on their desktop."
And we are trying to get as close to this as practical possible, knowing that it
may not be exactly the same.

> But if anything, this discussion proves that switch ports are special in
> this regard and that tcpdump will not work like on the desktop.
I think it can come really close. Some drivers may be able to fix the TX issue
you point out, others may not.

> Beside the fact that I don't agree (but gave up) with the new
> interpretation of promisc mode, I wonder if we're not asking for trouble
> with this patchset. Users will see all offloaded traffic on ingress, but
> none of it on egress. This is in contrast to the sever/desktop, where
> Linux is much more dominant in comparison to switches (let alone hw
> accelerated ones) and where all the traffic is visible through tcpdump.
> I can already see myself having to explain this over and over again to
> confused users.
> 
> Now, I understand that showing egress traffic is inherently difficult.
> It means one of two things:
> 
> 1. We allow packets to be forwarded by both the software and the
> hardware
> 2. We trap all ingressing traffic from all the ports
If the HW cannot copy the egress traffic to the CPU (which our HW cannot), then
you need to do both. All ingress traffic needs to go to the CPU, you need to
make all the forwarding decisions in the CPU, to figure out what traffic happens
to go to the port you want to monitor.

I really doubt this will work in real life. Too much traffic, and HW may make
different forwarding decision that the SW (tc rules in HW but not in SW), which
means that it will not be good for debugging anyway.

> Both options can have devastating effects on the network and therefore
> should not be triggered by a supposedly innocent invocation of tcpdump.
Agree.

> I again wonder if it would not be wiser to solve this by introducing two
> new flags to tcpdump for ingress/egress (similar to -Q in/out) capturing
> of offloaded traffic. The capturing of egress offloaded traffic can be
> documented with the appropriate warnings.
Not sure I agree, but I will try to spend some more time considering it.

In the mean while, what TC action was it that Jiri suggestion we should use? The
trap action is no good, and it prevents the forwarding in silicon, and I'm not
aware of a "COPY-TO-CPU" action.

> Anyway, I don't want to hold you up, I merely want to make sure that the
> above (assuming it's correct) is considered before the patches are
> applied.
Sounds good, and thanks for all the time spend on reviewing and asking the
critical questions.

/Allan

