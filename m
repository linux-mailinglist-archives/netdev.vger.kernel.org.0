Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBEF2FB8C0
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389734AbhASNpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:45:45 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62837 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732156AbhASJRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 04:17:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611047831; x=1642583831;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i+vMsq82uY+xpZi3BX/oAoS/cnt8ABc7p9is8zR8TA4=;
  b=MRBHsBaIdzhgUzE3IIjj1qXI8Hh5R89jNlfGHtjE8yTV3UuDRkw1/ve0
   gFr7yQlm2U9cjwggyuaf1TVyS7CE/aU4UDtYOT9HCWBmGUlfILtPtGdqq
   vYLASH5j0XFootv6yzQbHLZMhWpgqgVYmL7fmg/X7Q43fOCY/ME58Awxr
   99j01hgnBez3SoHlMGJOQyDyFkt2kwSWJdzODIyQR0VSxO36lPQMWPQ/M
   420osxNf8Q1Kpe2V31EikM6p3E63fWtbQF1FJtw22gm+qhG0L3x+hcyB8
   cjg/6pG/eSW8/af6tHs4m0C8RvMoooNbHpmQ1JG2A13t1fTuWOFJjv0j0
   g==;
IronPort-SDR: RRfs+QxxtP8Td6IOJu0cbSLfBIb73M0gh11lZ+u7Zeu11HYs062hRbOwiQHAAqFTeC1/QPn3aq
 YhkRSZguRNecy4BFlCC6WYEU7gPqmzKIS1y9XD6B5RpJznWBiWp4A1nfx2hNGX0RBKq2B/WDw3
 dLeBJ3mes70hNG7NxpuHLIXNh9vWG+YHLLfzAnR3Sm0PQIwJ/fAGPlje2hSko5K7lDHR219fYs
 oSsTrIDoE3OIuvZbyJXy3nXDu71NqBhpRqAf51H2G2qJRS/BBw1hropOiDXe7dh0q026PiDKPZ
 LRo=
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="106456981"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jan 2021 02:15:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 19 Jan 2021 02:15:36 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 19 Jan 2021 02:15:35 -0700
Date:   Tue, 19 Jan 2021 10:15:35 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: commit 4c7ea3c0791e (net: dsa: mv88e6xxx: disable SA learning
 for DSA and CPU ports)
Message-ID: <20210119091535.4spupcyupwepmopl@soft-dev3.localdomain>
References: <6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk>
 <87h7nhlksr.fsf@waldekranz.com>
 <20210118211924.u2bl6ynmo5kdyyff@skbuf>
 <5c5b243e-389d-cca8-cf3f-7e2833d24c29@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5c5b243e-389d-cca8-cf3f-7e2833d24c29@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/18/2021 23:07, Rasmus Villemoes wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 18/01/2021 22.19, Vladimir Oltean wrote:
> > On Sat, Jan 16, 2021 at 02:42:12AM +0100, Tobias Waldekranz wrote:
> >>> What I'm _really_ trying to do is to get my mv88e6250 to participate in
> >>> an MRP ring, which AFAICT will require that the master device's MAC gets
> >>> added as a static entry in the ATU: Otherwise, when the ring goes from
> >>> open to closed, I've seen the switch wrongly learn the node's own mac
> >>> address as being in the direction of one of the normal ports, which
> >>> obviously breaks all traffic. So if the topology is
> >>>
> >>>    M
> >>>  /   \
> >>> C1 *** C2
> >>>
> >>> with the link between C1 and C2 being broken, both M-C1 and M-C2 links
> >>> are in forwarding (hence learning) state, so when the C1-C2 link gets
> >>> reestablished, it will take at least one received test packet for M to
> >>> decide to put one of the ports in blocking state - by which time the
> >>> damage is done, and the ATU now has a broken entry for M's own mac address.
> >
> > What hardware offload features do you need to use for MRP on mv88e6xxx?
> > If none, then considering that Tobias's bridge series may stall, I think
> > by far the easiest approach would be for DSA to detect that it can't
> > offload the bridge+MRP configuration, and keep all ports as standalone.
> > When in standalone mode, the ports don't offload any bridge flags, i.e.
> > they don't do address learning, and the only forwarding destination
> > allowed is the CPU. The only disadvantage is that this is software-based
> > forwarding.
> 
> Which would be an unacceptable regression for my customer's use case. We
> really need some ring redundancy protocol, while also having the switch
> act as, well, a switch and do most forwarding in hardware. We used to
> use ERPS with some gross out-of-tree patches to set up the switch as
> required (much of the same stuff we're discussing here).

I think we can do better than just do the forwarding in software.

> 
> Then when MRP got added to the kernel, and apparently some switches with
> hardware support for that are in the pipeline somewhere, we decided to
> try to switch to that - newer revisions of the hardware might include an
> MRP-capable switch, but the existing hardware with the marvell switches
> would (with a kernel and userspace upgrade) be able to coexist with that
> newer hardware.
> 
> I took it for granted that MRP had been tested with existing
> switches/switchdev/DSA, but AFAICT (Horatiu, correct me if I'm wrong),
> currently MRP only works with a software bridge and with some
> out-of-tree driver for some not-yet-released hardware?

Well, it works out of box with software bridge. But if you do the
forwarding in HW(which is expected) then you need to extend your driver
to implement MRP callbacks. I have tested with a pure software bridge
and I have tested it with a switchdev driver that has special HW to
process MRP frames and a switchdev driver, that doesn't have special HW
to process MRP frames but in this case I have tested MRC role. And I
have not tested it with a DSA driver.

The reason why the driver needs to be extended is that, if a MRP frame
with DMAC 01:15:e4:00:00:01 comes to the HW, it would just be flooded
which is the wrong behaviour.

> I think I've
> identified what is needed to make it work with mv88e6xxx (and likely
> also other switchdev switches):
> 
> (1) the port state as set on the software bridge must be
> offloaded/synchronized to the switch.
> 
> (2) the bridge's hardware address must be made a static entry in the
> switch's database to avoid the switch accidentally learning a wrong port
> for that when the ring becomes closed.
> 
> (3) the cpu must be made the only recipient of frames with an MRP
> multicast DA, 01:15:e4:...
> 
> For (1), I think the only thing we need is to agree on where in the
> stack we translate from MRP to STP, because the like-named states in the
> two protocols really do behave exactly the same, AFAICT. So it can be
> done all the way up in MRP, perhaps even by getting completely rid of
> the distinction, or anywhere down the notifier stack, towards the actual
> switch driver.

I agree with you, we might just remove and use the STP callback or
implement it in your driver. Lets see what the maintainers think. I am
OK with any of these.

> 
> For (2), I still have to see how far Tobias' patches will get me, but at
> least there's some reason independent of MRP to do that.
> 
> Rasmus

-- 
/Horatiu
