Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A17E13CE0F
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgAOUYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:24:10 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53095 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgAOUYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:24:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EBF8A21DC7;
        Wed, 15 Jan 2020 15:24:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 15 Jan 2020 15:24:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=aVS0mP
        fRmuP0R7y1XHUZoq8rFwY4gbd55zY5PSr0Ncw=; b=sfmFrwx+wy7qBYOMUZsSDL
        xlueMhKhboLuzpAPqNrshaevcaAGrUrrIKhlxXAcE97ned/+5fEDgc1y7lPhExuA
        n7v7vm9JXcjSjrRqf8VG4MdwyBAPjgkbsBmzch4m/9jWpdxgpVe1ldHHiajkyJiC
        rH1/7vY23BTW84WSqGcBbWKP1scQTWoJeMW6iet4ZIdmMY/O6t64Vq0W2O4aTFte
        5n3uXLH20zYhGPmkUDwcvqGtWqvlpp7IxJRzDdbJ4HiESs6i6u3YvUu6rAVOGGRD
        w/2Y0Rwp01BhrF5kB+GCu21oIu5GeFkeoBqyyMgQwEX6UIAlLyBc/qUTkoIrfCRg
        ==
X-ME-Sender: <xms:6HQfXgoI2QPVuNGlcWSyVE2IUwFHgzEIS9ECEOlywIs6-eiSFYKu0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgddufeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    eptggrnhguvghlrghtvggthhdrtghomhenucfkphepjeejrddufeekrddvgeelrddvtdel
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgne
    cuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6HQfXojAneAqp1NvsJWaqsGDJLDEPptdWjdeKbIKbnVJlsW_T63xfg>
    <xmx:6HQfXqVb47xJgxyerC61jyqpGCLG9u88j4DbyWZpfj656mxRH3k-og>
    <xmx:6HQfXoGsEY0RiHsRvskMmUmnMksxVIYOm4f72Fpk8Y16HlCFSnMKLQ>
    <xmx:6HQfXn71TjYwiTtUcI5cDV17XkTzc34WAfIUhDA0xtScMYCXLyAW0A>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 34A2730607D0;
        Wed, 15 Jan 2020 15:24:07 -0500 (EST)
Date:   Wed, 15 Jan 2020 22:23:54 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: vrf and multicast is broken in some cases
Message-ID: <20200115202354.GB1513116@splinter>
References: <e439bcae-7d20-801c-007d-a41e8e9cd5f5@candelatech.com>
 <3906c6fe-e7a7-94c1-9d7d-74050084b56e@gmail.com>
 <dbefe9b1-c846-6cc6-3819-520fd084a447@candelatech.com>
 <20200115191920.GA1490933@splinter>
 <2b5cae7b-598a-8874-f9e9-5721099b9b6d@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b5cae7b-598a-8874-f9e9-5721099b9b6d@candelatech.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 12:00:08PM -0800, Ben Greear wrote:
> 
> 
> On 01/15/2020 11:19 AM, Ido Schimmel wrote:
> > On Wed, Jan 15, 2020 at 11:02:26AM -0800, Ben Greear wrote:
> > > 
> > > 
> > > On 01/15/2020 10:45 AM, David Ahern wrote:
> > > > On 1/15/20 10:57 AM, Ben Greear wrote:
> > > > > Hello,
> > > > > 
> > > > > We put two different ports into their own VRF, and then tried to run a
> > > > > multicast
> > > > > sender on one and receiver on the other.  The receiver does not receive
> > > > > anything.
> > > > > 
> > > > > Is this a known problem?
> > > > > 
> > > > > If we do a similar setup with policy based routing rules instead of VRF,
> > > > > then the multicast
> > > > > test works.
> > > > > 
> > > > 
> > > > It works for OSPF for example. I have lost track of FRR features that
> > > > use it, so you will need to specify more details.
> > > > 
> > > > Are the sender / receiver on the same host?
> > > 
> > > Yes, like eth2 sending to eth3, eth2 is associated with _vrf2, eth3 with _vrf3.
> > 
> > Two questions:
> > 
> > 1. Did you re-order the FIB rules so that l3mdev rule is before the main
> > table?
> 
> That seems OK:
> 
> [root@lf0313-6477 lanforge]# ip ru show
> 1000:	from all lookup [l3mdev-table]
> 1512:	from all lookup local
> 32766:	from all lookup main
> 32767:	from all lookup default
> 
> 
> > 2. Did you configure a default unreachable route in the VRF?
> 
> I did not have this, so maybe that is the issue.  This is my mcast
> transmitter table.
> 
> [root@lf0313-6477 lanforge]# ip route show table 10
> broadcast 7.7.1.0 dev rddVR0  proto kernel  scope link  src 7.7.1.2
> 7.7.1.0/24 dev rddVR0  scope link  src 7.7.1.2
> local 7.7.1.2 dev rddVR0  proto kernel  scope host  src 7.7.1.2
> broadcast 7.7.1.255 dev rddVR0  proto kernel  scope link  src 7.7.1.2
> 
> When sniffing, I see IGMP group add/delete messages sent from the receiver
> towards the sender, but transmitted mcast frames are not seen on the rddVR0
> (veth mcast sender port).
> 
> > 
> > IIRC, locally generated multicast packets are forwarded according to the
> > unicast FIB rules, so if you don't have the unreachable route, it is
> > possible the packet is forwarded according to the default route in the
> > main table.
> 
> And now that is interesting.  When I sniff on eth0, which holds the default
> route outside of the VRFs, then I do see the mcast frames sent there.
> 
> I tried adding default routes, and now sure enough it starts working!

I'm not sure this is the correct way (David?). Can you try to delete
this default route and instead add a default unreachable route with an
high metric according to step 3 in Documentation/networking/vrf.txt:

"
3. Set the default route for the table (and hence default route for the VRF).
       ip route add table 10 unreachable default metric 4278198272

   This high metric value ensures that the default unreachable route can
   be overridden by a routing protocol suite.  FRRouting interprets
   kernel metrics as a combined admin distance (upper byte) and priority
   (lower 3 bytes).  Thus the above metric translates to [255/8192].
"

If I'm reading ip_route_output_key_hash_rcu() correctly, then the error
returned from fib_lookup() because of the unreachable route should allow
you to route the packet via the requested interface.

> 
> [root@lf0313-6477 lanforge]# ip route show table 10
> default via 7.7.1.1 dev rddVR0
> broadcast 7.7.1.0 dev rddVR0  proto kernel  scope link  src 7.7.1.2
> 7.7.1.0/24 dev rddVR0  scope link  src 7.7.1.2
> local 7.7.1.2 dev rddVR0  proto kernel  scope host  src 7.7.1.2
> broadcast 7.7.1.255 dev rddVR0  proto kernel  scope link  src 7.7.1.2
> 
> 
> I'll work on adding an un-reachable route when a real gateway is not
> configured...
> 
> Thanks for the hint, saved me lots of work!
> 
> --Ben
> 
> > 
> > > 
> > > I'll go poking at the code.
> > > 
> > > Thanks,
> > > Ben
> > > 
> > > --
> > > Ben Greear <greearb@candelatech.com>
> > > Candela Technologies Inc  http://www.candelatech.com
> > 
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
