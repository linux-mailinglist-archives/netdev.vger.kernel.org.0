Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D857B2F2
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388046AbfG3TI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:08:57 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:47123 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387996AbfG3TI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 15:08:57 -0400
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
IronPort-SDR: FVWau1FL+BdSstz+rb4YYnQzfGgcu8B+5qDHSBUHkR8H3UFjmMy9b1sfZ1xqa29K5FyhXngNr3
 yUZvr9NnInPpgqSkv8/rgGPf1B1IDF791s4Du0A+rgrGXKxmuUGrCVLqMx0nJTZ40BOVmZxFXN
 K9SkEmScVW6zXTE+CBxQVc5L4Z1hD4xXowKx4Y1jWPyldFfZFMa9ffX2ePQgVruqcwSrnXEN7H
 F33pDVKcEMheDEj5DuIX9xMa6Gd8M7geoykd9c0sduulfy1wywJLrnWpydqIkM6BOXVFevud4x
 OIA=
X-IronPort-AV: E=Sophos;i="5.64,327,1559545200"; 
   d="scan'208";a="43283969"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jul 2019 12:08:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 12:00:00 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 30 Jul 2019 12:00:00 -0700
Date:   Tue, 30 Jul 2019 21:00:01 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190730190000.diacyjw6owqkf7uf@lx-anielsen.microsemi.net>
References: <20190729121409.wa47uelw5f6l4vs4@lx-anielsen.microsemi.net>
 <95315f9e-0d31-2d34-ba50-11e1bbc1465c@cumulusnetworks.com>
 <20190729131420.tqukz55tz26jkg73@lx-anielsen.microsemi.net>
 <3cc69103-d194-2eca-e7dd-e2fa6a730223@cumulusnetworks.com>
 <20190729135205.oiuthcyesal4b4ct@lx-anielsen.microsemi.net>
 <e4cd0db9-695a-82a7-7dc0-623ded66a4e5@cumulusnetworks.com>
 <20190729143508.tcyebbvleppa242d@lx-anielsen.microsemi.net>
 <20190729175136.GA28572@splinter>
 <20190730062721.p4vrxo5sxbtulkrx@lx-anielsen.microsemi.net>
 <20190730143400.GO28552@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190730143400.GO28552@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/30/2019 16:34, Andrew Lunn wrote:
> The whole offloading story has been you use the hardware to accelerate
> what the Linux stack can already do.
It is true, I have been quite keen on finding a way to control the forwarding of
L2-multicast which will work in the same way with and without HW acceleration
(and which we can HW offlaod with the HW I'm working on).

> In this case, you want to accelerate Device Level Ring, DLR.
It is actually not only for DLR, there are other ring protocols which has the
same needs the same MRP (media redundancy protocol) is an other example.

I just used DLR as an example because this is the one we expect to implement the
protocol for first. There are other just as important use-cases.

> But i've not yet seen a software implementation of DLR. Should we really be
> considering first adding DLR to the SW bridge?
We have actually (slowly) stared to work on a DLR SW implementation. We want to
do this as a Linux driver instead of a user-space implementation, because there
are other HW facilities we would like to offload (the HW has a automatic frame
generator, which can generate the beacon frames, and a unit which can terminate
the beacon frames, and generate an interrupt if the beacon frames are not
received).

Our plan was to implement this in pure SW, and then look at how to HW offload
it.

But this will take some time before we have anything meaning full to show.

> Make it an alternative to the STP code?
I'm still working on learning the details of DLR, but I actually believe that it
in some situations may co-exists with STP ;-)

DLR only works on ring topologies, but it is possible to connect a ring to a
classic STP network. If doing so, then you are suppose to run DLR on the two
ring ports, and (M)STP on the ports connecting to the remaining part of the
network.

As far as I recall, this is called a gateway node. But supporting this is
optional, and will properly not be supported in the first implementation.

> Once we have a generic implementation we can then look at how it can
> be accelerated using switchdev.
I agree with you that we need a SW implementation of DLR because we can offload
the DLR protocol to HW.

But what we are looking at here, is to offload a
non-aware-(DLR|MRP)-switch which happens to be placed in a network with
these protocols running.

It is not really DLR specific, which is why it seems reasonable to implement
this without a DLR SW implementation up front.

-- 
/Allan
