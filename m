Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D3B78E19
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfG2OfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:35:12 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:33507 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfG2OfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 10:35:11 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: PvxHzyGMjwszKpUYApDD/v/JSkAUvEiJfnAnWccnM0ZPnZ8QcbwU7efZpX8HIZYIsrFxgmfpjU
 hBS2g0B29MVca5KPRZuOep1ROkpbsqcB6qy7ghXd75fMES9ulZmjR4TLLdhQ9TLlUHhHh+yuW3
 nb0jC2PJLntUZ9EzdcSUbFIoDFI96JrD3jpFGcUAZb6GPmHqukCosyqrMCI9O5kD8HqsTRz5zh
 NVYa0v+XBL34PmZxzMkFGekYyx9nPB8/YUHejphmd/oaq4AOHqs7mNpHWM0+OqntROR3Hcy/VV
 0oA=
X-IronPort-AV: E=Sophos;i="5.64,323,1559545200"; 
   d="scan'208";a="40097631"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jul 2019 07:35:10 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex01.mchp-main.com (10.10.87.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jul 2019 07:35:09 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 29 Jul 2019 07:35:09 -0700
Date:   Mon, 29 Jul 2019 16:35:09 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190729143508.tcyebbvleppa242d@lx-anielsen.microsemi.net>
References: <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
 <e6ad982f-4706-46f9-b8f0-1337b09de350@cumulusnetworks.com>
 <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
 <b755f613-e6d8-a2e6-16cd-6f13ec0a6ddc@cumulusnetworks.com>
 <20190729121409.wa47uelw5f6l4vs4@lx-anielsen.microsemi.net>
 <95315f9e-0d31-2d34-ba50-11e1bbc1465c@cumulusnetworks.com>
 <20190729131420.tqukz55tz26jkg73@lx-anielsen.microsemi.net>
 <3cc69103-d194-2eca-e7dd-e2fa6a730223@cumulusnetworks.com>
 <20190729135205.oiuthcyesal4b4ct@lx-anielsen.microsemi.net>
 <e4cd0db9-695a-82a7-7dc0-623ded66a4e5@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <e4cd0db9-695a-82a7-7dc0-623ded66a4e5@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/29/2019 17:21, Nikolay Aleksandrov wrote:
> On 29/07/2019 16:52, Allan W. Nielsen wrote:
> > The 07/29/2019 15:50, Nikolay Aleksandrov wrote:
> >> On 29/07/2019 15:22, Nikolay Aleksandrov wrote:
> >>> Hi Allan,
> >>> On 29/07/2019 15:14, Allan W. Nielsen wrote:
> >>>> First of all, as mentioned further down in this thread, I realized that our
> >>>> implementation of the multicast floodmasks does not align with the existing SW
> >>>> implementation. We will change this, such that all multicast packets goes to the
> >>>> SW bridge.
> >>>>
> >>>> This changes things a bit, not that much.
> >>>>
> >>>> I actually think you summarized the issue we have (after changing to multicast
> >>>> flood-masks) right here:
> >>>>
> >>>> The 07/26/2019 12:26, Nikolay Aleksandrov wrote:
> >>>>>>> Actually you mentioned non-IP traffic, so the querier stuff is not a problem. This
> >>>>>>> traffic will always be flooded by the bridge (and also a copy will be locally sent up).
> >>>>>>> Thus only the flooding may need to be controlled.
> >>>>
> >>>> This seems to be exactly what we need.
> >>>>
> >>>> Assuming we have a SW bridge (br0) with 4 slave interfaces (eth0-3). We use this
> >>>> on a network where we want to limit the flooding of frames with dmac
> >>>> 01:21:6C:00:00:01 (which is non IP traffic) to eth0 and eth1.
> >>>>
> >>>> One way of doing this could potentially be to support the following command:
> >>>>
> >>>> bridge fdb add    01:21:6C:00:00:01 port eth0
> >>>> bridge fdb append 01:21:6C:00:00:01 port eth1
> >> And the fdbs become linked lists?
> > Yes, it will most likely become a linked list
> > 
> >> So we'll increase the complexity for something that is already supported by
> >> ACLs (e.g. tc) and also bridge per-port multicast flood flag ?
> > I do not think it can be supported with the facilities we have today in tc.
> > 
> > We can do half of it (copy more fraems to the CPU) with tc, but we can not limit
> > the floodmask of a frame with tc (say we want it to flood to 2 out of 4 slave
> > ports).
> Why not ? You attach an egress filter for the ports and allow that dmac on only
> 2 of the ports.
Because we want a solution which we eventually can offload in HW. And the HW
facilities we have is doing ingress processing (we have no egress ACLs in this
design), and if we try to offload an egress rule, with an ingress HW facility,
then we will run into other issues.

/Allan
