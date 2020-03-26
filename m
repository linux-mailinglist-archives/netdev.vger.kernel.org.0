Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB54E193E02
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 12:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgCZLft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 07:35:49 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:41325 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbgCZLft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 07:35:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1354F5800E3;
        Thu, 26 Mar 2020 07:35:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 26 Mar 2020 07:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HaiL5X
        C3Oi+DbieZ4M7G/6ZmlDjG3Fd3bSYBEWR2yZw=; b=etnmg/T6OHIJER2wxfQBt8
        eTt/JEMU9FGkScDVSWBYVWJ+dWhJyHH1TjVsUSovVIkfasa/CosPipUchQLzX1oT
        pHvFQCJHbEB90v6KVgJl3Igcs4TF8nZ/c0ApRKMoY0q3ylM70FKieQIk0SNE7TyM
        BrFzjP6taA7SUwmgWLql/4B4VTj7YkAPYUdPqlZ1mSJKiSNTIyU3TgYYphenvBV8
        N2eYf3YufOvX3lI+G9ODZMAqgm6JwBWG53QrWU3zHyotieq+bqi6T4Uz14UvIThn
        t+xjifvczEAbqDJBl3J8HmDrXWXefNUuww4ZTik6Odq7UPNbl8doAI/IyjLYbE/Q
        ==
X-ME-Sender: <xms:kJN8Xrq7ba7F6WpAaLYoJzd98dJ2EPcWT8LBq2hkwTW-Nil4KBYVdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehiedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    epohiilhgrsghsrdhorhhgnecukfhppeejledrudekuddrudefvddrudeludenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesih
    guohhstghhrdhorhhg
X-ME-Proxy: <xmx:kJN8Xp7__tfUA6S0yipE0iE7f8GzgLTWuTBAIoudF5W8q0qTSVivLw>
    <xmx:kJN8XjO3jXyUBHHepdvV4UwXkLJ1Lxxp8qU14oZUD_vRwOjWckOeow>
    <xmx:kJN8XjPc8YbSIjowoW03jvVZGWRhwUviuH9VWCBli5vMaUKJE45mZg>
    <xmx:k5N8Xg1IgbsNuWtObrA8JAYChxuq8oMZTakAFlAqr3BlVvkXjysCSQ>
Received: from localhost (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E91F30696B6;
        Thu, 26 Mar 2020 07:35:44 -0400 (EDT)
Date:   Thu, 26 Mar 2020 13:35:42 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
Message-ID: <20200326113542.GA1383155@splinter>
References: <20200325152209.3428-1-olteanv@gmail.com>
 <20200325152209.3428-11-olteanv@gmail.com>
 <20200326101752.GA1362955@splinter>
 <CA+h21hq2K__kY9Pi4-23x7aA+4TPXAV4evfi1tR=0bZRcZDiQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hq2K__kY9Pi4-23x7aA+4TPXAV4evfi1tR=0bZRcZDiQA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 12:25:20PM +0200, Vladimir Oltean wrote:
> Hi Ido,
> 
> On Thu, 26 Mar 2020 at 12:17, Ido Schimmel <idosch@idosch.org> wrote:
> >
> > Hi Vladimir,
> >
> > On Wed, Mar 25, 2020 at 05:22:09PM +0200, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > In the initial attempt to add MTU configuration for DSA:
> > >
> > > https://patchwork.ozlabs.org/cover/1199868/
> > >
> > > Florian raised a concern about the bridge MTU normalization logic (when
> > > you bridge an interface with MTU 9000 and one with MTU 1500). His
> > > expectation was that the bridge would automatically change the MTU of
> > > all its slave ports to the minimum MTU, if those slaves are part of the
> > > same hardware bridge. However, it doesn't do that, and for good reason,
> > > I think. What br_mtu_auto_adjust() does is it adjusts the MTU of the
> > > bridge net device itself, and not that of any slave port.  If it were to
> > > modify the MTU of the slave ports, the effect would be that the user
> > > wouldn't be able to increase the MTU of any bridge slave port as long as
> > > it was part of the bridge, which would be a bit annoying to say the
> > > least.
> > >
> > > The idea behind this behavior is that normal termination from Linux over
> > > the L2 forwarding domain described by DSA should happen over the bridge
> > > net device, which _is_ properly limited by the minimum MTU. And
> > > termination over individual slave device is possible even if those are
> > > bridged. But that is not "forwarding", so there's no reason to do
> > > normalization there, since only a single interface sees that packet.
> > >
> > > The real problem is with the offloaded data path, where of course, the
> > > bridge net device MTU is ignored. So a packet received on an interface
> > > with MTU 9000 would still be forwarded to an interface with MTU 1500.
> > > And that is exactly what this patch is trying to prevent from happening.
> >
> > How is that different from the software data path where the CPU needs to
> > forward the packet between port A with MTU X and port B with MTU X/2 ?
> >
> > I don't really understand what problem you are trying to solve here. It
> > seems like the user did some misconfiguration and now you're introducing
> > a policy to mitigate it? If so, it should be something the user can
> > disable. It also seems like something that can be easily handled by a
> > user space application. You get netlink notifications for all these
> > operations.
> >
> 
> Actually I think the problem can be better understood if I explain
> what the switches I'm dealing with look like.
> None of them really has a 'MTU' register. They perform length-based
> admission control on RX.

IIUC, by that you mean that these switches only perform length-based
filtering on RX, but not on TX?

> At this moment in time I don't think anybody wants to introduce an MRU
> knob in iproute2, so we're adjusting that maximum ingress length
> through the MTU. But it becomes an inverted problem, since the 'MTU'
> needs to be controlled for all possible sources of traffic that are
> going to egress on this port, in order for the real MTU on the port
> itself to be observed.

Looking at your example from the changelog:

ip link set dev sw0p0 master br0
ip link set dev sw0p1 mtu 1400
ip link set dev sw0p1 master br0

Without your patch, after these commands sw0p0 has an MTU of 1500 and
sw0p1 has an MTU of 1400. Are you saying that a frame with a length of
1450 bytes received on sw0p0 will be able to egress sw0p1 (assuming it
should be forwarded there)?

If so, then I think I understand the problem. However, I don't think
such code belongs in the bridge driver as this restriction does not
apply to all switches. Also, I think that having the kernel change MTU
of port A following MTU change of port B is a bit surprising and not
intuitive.

I think you should be more explicit about it. Did you consider listening
to 'NETDEV_PRECHANGEMTU' notifications in relevant drivers and vetoing
unsupported configurations with an appropriate extack message? If you
can't veto (in order not to break user space), you can still emit an
extack message.
