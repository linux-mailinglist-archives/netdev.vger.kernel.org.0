Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C10D2A1D94
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 12:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgKAL1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 06:27:38 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:37423 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726341AbgKAL1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 06:27:38 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D14095800D2;
        Sun,  1 Nov 2020 06:27:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 01 Nov 2020 06:27:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PWU7VA
        DTBB+XJAwk7hp5E/tqVLikrW3MKGjjJTyw+V4=; b=N/P+Wl/1obCc5l0jSEu5Ar
        M67Vw84bapIu6IqbS8pT3r3iN+IPW4J9SxeWCGcPeFeA8jr2t8SjG1U7kXGOPCd5
        qEwpZ0pHQtb9CCZG6Vywv609fN3yxbcgZ68LzoL6sjFomh28vA7rRf+OLDFuFz3j
        kxZBseVGQ1H3bBRjfuNtNp1cN3H6sxCy9aXvbS63MhwMqhE32hlxl/z1FdkYKE5k
        zKWuLJafzwATBhn4hGrHfygHHcb9FRdgvI8+LA/Sv3YvHvImKsH2FM78/mj2DveN
        CcgV/f1yAKLQNUu503cnkeaas/MLagCtt0T0oIgF/c8YKR8CgcWaEA0H3D7JlGzA
        ==
X-ME-Sender: <xms:p5ueX_kFtP9XvEnCcGooxGYbzK9Db3gMrgdgQ1jFQz7Pt5exUWZBwQ>
    <xme:p5ueXy1dhlTvhJD3-6hcKOfhQ9dtnM_dSbaBng3eEQpT9bj4xXry_JOBFBWTFkyBl
    HCGwt2MXK4QTXI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleelgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepuedtkefggeeihffgjeeiveehfefftefgveekledthfffjeelfeehhfetteehgeef
    necuffhomhgrihhnpehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhgihhthhhusg
    drtghomhdptghumhhulhhushhnvghtfihorhhkshdrtghomhenucfkphepkeegrddvvdel
    rdduheehrddukedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:p5ueX1pyyJe9V8TIfuNrn6wJH7_NT6kmM0rNKFCpd4Ca792JBNBWPw>
    <xmx:p5ueX3n48HLUY_bOblW15rCAaSUS3ffwjG6wcke1YWY3-t2Ej268WA>
    <xmx:p5ueX91Fpqm8sxyQrMVvn49mibq7I25n70qctBM3K3T6_oq5ykADtQ>
    <xmx:qJueX3wpCSUeaC_UAbSUK2Pm5C686S5Iw3TRY1hpJ16hSN07X-h6OQ>
Received: from localhost (igld-84-229-155-182.inter.net.il [84.229.155.182])
        by mail.messagingengine.com (Postfix) with ESMTPA id A15C0328005D;
        Sun,  1 Nov 2020 06:27:34 -0500 (EST)
Date:   Sun, 1 Nov 2020 13:27:31 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>, vyasevich@gmail.com,
        netdev <netdev@vger.kernel.org>, UNGLinuxDriver@microchip.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
Message-ID: <20201101112731.GA698347@shredder>
References: <20200525194808.GA1449199@splinter>
 <CA+h21hq+TULBNRHJRN-_UwR8weBxgzT5v762yNzzkRaM2iGx9A@mail.gmail.com>
 <20200526140159.GA1485802@splinter>
 <CA+h21hqTxbPyQGcfm3qWeD80qAZ_c3xf2FNdSBBdtOu2Hz9FTw@mail.gmail.com>
 <20200528143718.GA1569168@splinter>
 <20200720100037.vsb4kqcgytyacyhz@skbuf>
 <20200727165638.GA1910935@shredder>
 <20201027115249.hghcrzomx7oknmoq@skbuf>
 <20201028144338.GA487915@shredder>
 <20201028184644.p6zm4apo7v4g2xqn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028184644.p6zm4apo7v4g2xqn@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 08:46:44PM +0200, Vladimir Oltean wrote:
> On Wed, Oct 28, 2020 at 04:43:38PM +0200, Ido Schimmel wrote:
> > In "standalone" mode your netdev is like any other netdev and if it does
> > not support Rx filtering, then pass everything to the CPU and let it
> > filter what it does not want to see. I don't see the problem.  This is
> > exactly what mlxsw did before L3 forwarding was introduced. As soon as
> > you removed a netdev from a bridge we created an internal bridge between
> > the port and the CPU port and flooded everything to the CPU.
> 
> Of course I was thinking about the better case where the netdev would
> implement NETIF_F_UNICAST_FLT. If it would support filtering when
> bridged, it would seem natural to me to also support it when not bridged.

Please see below

> 
> > > > > My interpretation of the meaning of dev_uc_add() for switchdev (and
> > > > > therefore, of its opposite - promiscuous mode) is at odds with previous
> > > > > work done for non-switchdev. Take Vlad Yasevich's work "[Bridge] [PATCH
> > > > > net-next 0/8] Non-promisc bidge ports support" for example:
> > > > > 
> > > > > https://lists.linuxfoundation.org/pipermail/bridge/2014-May/008940.html
> > > > > 
> > > > > He is arguing that a bridge port without flood&learn doesn't need
> > > > > promiscuous mode, because all addresses can be statically known, and
> > > > > therefore, he added code to the bridge that does the following:
> > > > > 
> > > > > - syncs the bridge MAC address to all non-promisc bridge slaves, via
> > > > >   dev_uc_add()
> > > > > - syncs the MAC addresses of all static FDB entries on all ingress
> > > > >   non-promisc bridge slave ports, via dev_uc_add()
> > > > > 
> > > > > with the obvious goal that "the bridge slave shouldn't drop these
> > > > > packets".
> > > > 
> > > > Lets say all the ports are not automatic (using Vlad's terminology),
> > > > then packets can only be forwarded based on FDB entries. Any packets
> > > > with a destination MAC not in the FDB will be dropped by the bridge.
> > > > Agree?
> > > > 
> > > > Now, if this is the case, then you know in advance which MACs will not
> > > > be dropped by the bridge. Therefore, you can program only these MACs to
> > > > the Rx filters of the bridge slaves (simple NICs). That way, instead of
> > > > having the bridge (the CPU) waste cycles on dropping packets you can
> > > > drop them in hardware using the NIC's Rx filters.
> > > 
> > > _if_ there is a bridge.
> > 
> > But he is talking about a bridge... I don't follow. You even wrote "He
> > is arguing that a bridge port". So how come there is no bridge?
> 
> Well, my problem is with the bridge's use of dev_uc_add, I'm sure you
> got that by now. I would be forced to treat dev_uc_add differently
> depending on whether or not I am bridged, I don't particularly like
> that.

See below

> 
> > > But if we are to introduce a new SWITCHDEV_OBJ_ID_HOST_FDB, then we
> > > would be working around the problem, and the non-bridged switchdev
> > > interfaces would still have no proper way of doing RX filtering.
> > 
> > What prevents you from implementing ndo_set_rx_mode() in your driver?
> 
> Nothing, that's exactly what I did here...
> 
> > Let me re-iterate my point again. Rx filtering determines which packets
> > can be received by the port. In "standalone" mode where you do not
> > support L3 forwarding I agree that the Rx filter determines which
> > packets the CPU should see.
> > 
> > However, in the "non-standalone" mode where your netdevs are enslaved to
> > a bridge that you offload, then the bridge's FDB determines which
> > packets the CPU should see. The ports themselves are in promiscuous mode
> > because the bridge (either SW one or HW one) wants to see all the
> > received packets.
> 
> Agree. We all agree on this. However, the specifics are a bit fuzzy.

Vladimir,

The fundamental issue here is that you try to overload Rx filtering with
filtering towards the CPU port. These are two different things that are
only the same when the netdev is in "standalone" mode. If every received
packet is flooded to the CPU, then yes, Rx filtering means CPU
filtering. However, if received packets are forwarded to other ports,
then Rx filtering is not equivalent to CPU filtering.

You can implement filtering towards the CPU via ndo_set_rx_mode() if you
expose netdevs for the CPU port:

+---------+                           +----------+
|         +------+ PCI / Eth   +------+          |
|   CPU   | cpu1 +-------------+ cpu0 |   ASIC   |
|         +------+             +------+          |
+---------+                           +----------+

And implement ndo_set_rx_mode() on 'cpu1'. Personally, I wouldn't go in
this direction.

> 
> > > Take the case of IEEE 1588 packets. They should be trapped to the CPU
> > > and not forwarded. But the destination address at which PTP packets are
> > > sent is not set in stone, it is something that the profile decides.
> > > 
> > > How to ensure these packets are trapped to the CPU?
> > > You're probably going to say "devlink trap", but:
> > 
> > I would say that it is up to the driver to configure this among all the
> > rest of the PTP configuration that it needs to do. mlxsw registers the
> > PTP trap during init because it is easy, but I assume we could also do
> > it when PTP is enabled.
> 
> So based on the 
> 
> > > - I don't want the PTP packets to be unconditionally trapped. I see it
> > >   as a perfectly valid use case for a switch to be PTP-unaware and just
> > >   let somebody else terminate those packets. But "devlink trap" only
> > >   gives you an option to see what the traps are, not to turn them off.
> > > - The hardware I'm working with doesn't even trap PTP to the CPU by
> > >   default. I would need to hardcode trapping rules in the driver, to
> > >   some multicast addresses I can just guess, then I would report them as
> > >   non-disableable devlink traps.
> > > 
> > > Applications do call setsockopt with IP_ADD_MEMBERSHIP, IPV6_ADD_MEMBERSHIP
> > > or PACKET_ADD_MEMBERSHIP. However I don't see how that is turning into a
> > > notification that the driver can use, except through dev_mc_add.
> > > 
> > > Therefore, it simply looks easier to me to stub out the extraneous calls
> > > to dev_uc_add and dev_mc_add, rather than add parallel plumbing into
> > > net/ipv4/igmp.c, for ports that are "promiscuous by default".
> > > 
> > > What do you think about this example? Isn't it something that should be
> > > supported by design?
> > 
> > I believe it's already supported. Lets look at the "standalone" and
> > "non-standalone" cases:
> > 
> > 1. Standalone: Your ndo_set_rx_mode() will be called and if you support
> > Rx filtering, you can program your filters accordingly. If not, then you
> > need to send everything to the CPU
> 
> Right, this is kind of what the patch set that we're commenting on is
> doing.
> 
> > 2. Non-standalone and bridge is multicast aware: An IGMP membership
> > report is supposed to be sent via the bridge device (I assume you are
> > calling IP_ADD_MEMBERSHIP on the bridge device). This will cause the
> > bridge to create an MDB entry indicating that packets to this multicast
> > IP should be locally received. Drivers get it via the switchdev
> > operation Andrew added.
> 
> I am not calling *_ADD_MEMBERSHIP on the bridge device, but on the slave
> ports.
> 
> For PACKET_ADD_MEMBERSHIP, this should work as-is on swpN even if it's
> bridged.
> 
> For IP_ADD_MEMBERSHIP, you would need to add some ebtables rules in
> order for the bridge data path to not steal traffic on UDP ports 319 and
> 320 from the slave's data path.
> 
> But nonetheless, you get my point. Who will notify me of these multicast
> addresses if I'm bridged and I need to terminate L2 or L4 PTP through
> the data path of the slave interfaces and not of the bridge.

IIRC, getting PTP to work on bridged interfaces is tricky and this is
something that is not currently supported by mlxsw or Cumulus:
https://github.com/Mellanox/mlxsw/wiki/Precision-Time-Protocol#configuring-ptp
https://docs.cumulusnetworks.com/cumulus-linux-42/System-Configuration/Setting-Date-and-Time/#configure-the-ptp-boundary-clock

If the purpose of this discussion is to get PTP working in this
scenario, then lets have a separate discussion about that. This is
something we looked at in the past, but didn't make any progress (mainly
because we only got requirements for PTP over routed ports).

Anyway, opening packet sockets on interfaces (bridged or not) that pass
offloaded traffic will not get you this traffic to the packet sockets.
There was already a discussion about this last year (I think Microchip
guys started it) in the context of tcpdump.
