Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7B13F3130
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhHTQK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:10:29 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:55209 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240455AbhHTQKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 12:10:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0EF2C580B97;
        Fri, 20 Aug 2021 12:09:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 20 Aug 2021 12:09:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9lJMAF
        cJgkkTv4dQmjOgQl26x5lrkq2A3j4esjrD8L8=; b=FApNAxLGRjCZRcPhJe3oVI
        QKpspHAW4ja1fdrM6j66nxcFTuQLm+iR5L78o/hGDrjKs2vdQv9F6lp2o5IMIA8D
        uNiGkuhGJptcydVCKJf2OjnfgxwWLBbZnnx98ljKfPlh25/hPWRwGAk0AuXD9mGe
        OJnfXdUwVzmmlPToZP0xFky6uSxQsoc8vEyIlGfAsww0yWTDy3BROCURqt1S8YzI
        BGH80BHZmfz+eF+vX5Au9WZ2Nu97yLA+VD4U2QCaKPP3ssuMcpi6AK4Uz2ooxH/w
        w4QzUMjkXMmKvTDQgMX3+Eb9+gpgPqaq89mJNp0WMUNJ01A8KcO6PVFbDw8JlNhg
        ==
X-ME-Sender: <xms:s9MfYVeLllgeXFvrcS1-a2RcBH2ofv1hCOoHbIC9XbFlASH9SIDkLA>
    <xme:s9MfYTOacydQofAXTRgQwTBrSt24OxCvCWWgy_Deh3M2Fi1CFQGOUrT0oxeLgOnSA
    mnN5ZSEdGuTtu8>
X-ME-Received: <xmr:s9MfYejRJgECGQlWJwnFHj8cigwG0wa7odXEfs7UX3SpgaLkENPjkJF4WTgW44MQzhp9mwo3qxGv41ycWmkGMQ65SvLuPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleelgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfgkeev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:s9MfYe874VSf_X-wULucjUdoSrNXsAgPqQMj5ADxR_KP6bYM1NmigA>
    <xmx:s9MfYRsDVz7pCTfvr1TqWgXJvp55ghyXxlJXO5AKhDB0q2dwtdxz6g>
    <xmx:s9MfYdEwoX9kKH2MFQz5iEccsubGZtse2p1TbQgG5SnuCgKO5xA4WQ>
    <xmx:uNMfYY_EbO8xTim3lv2BUN6T19sHm37uu74Mzi7Gmk6tN_u2S0AoJA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Aug 2021 12:09:22 -0400 (EDT)
Date:   Fri, 20 Aug 2021 19:09:18 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
Message-ID: <YR/TrkbhhN7QpRcQ@shredder>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
 <20210820093723.qdvnvdqjda3m52v6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820093723.qdvnvdqjda3m52v6@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 12:37:23PM +0300, Vladimir Oltean wrote:
> On Fri, Aug 20, 2021 at 12:16:10PM +0300, Ido Schimmel wrote:
> > On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
> > > Problem statement:
> > > 
> > > Any time a driver needs to create a private association between a bridge
> > > upper interface and use that association within its
> > > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> > > entries deleted by the bridge when the port leaves. The issue is that
> > > all switchdev drivers schedule a work item to have sleepable context,
> > > and that work item can be actually scheduled after the port has left the
> > > bridge, which means the association might have already been broken by
> > > the time the scheduled FDB work item attempts to use it.
> > 
> > This is handled in mlxsw by telling the device to flush the FDB entries
> > pointing to the {port, FID} when the VLAN is deleted (synchronously).
> 
> Again, central solution vs mlxsw solution.

Again, a solution is forced on everyone regardless if it benefits them
or not. List is bombarded with version after version until patches are
applied. *EXHAUSTING*.

With these patches, except DSA, everyone gets another queue_work() for
each FDB entry. In some cases, it completely misses the purpose of the
patchset.

Want a central solution? Make sure it is properly integrated. "Don't
have the energy"? Ask for help. Do not try to force a solution on
everyone and motivate them to change the code by doing a poor conversion
yourself.

I don't accept "this will have to do".

> 
> If a port leaves a LAG that is offloaded but the LAG does not leave the
> bridge, the driver still needs to initiate the VLAN deletion. I really
> don't like that, it makes switchdev drivers bloated.
> 
> As long as you call switchdev_bridge_port_unoffload and you populate the
> blocking notifier pointer, you will get replays of item deletion from
> the bridge.
> 
> > > The solution is to modify switchdev to use its embedded SWITCHDEV_F_DEFER
> > > mechanism to make the FDB notifiers emitted from the fastpath be
> > > scheduled in sleepable context. All drivers are converted to handle
> > > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE from their blocking notifier block
> > > handler (or register a blocking switchdev notifier handler if they
> > > didn't have one). This solves the aforementioned problem because the
> > > bridge waits for the switchdev deferred work items to finish before a
> > > port leaves (del_nbp calls switchdev_deferred_process), whereas a work
> > > item privately scheduled by the driver will obviously not be waited upon
> > > by the bridge, leading to the possibility of having the race.
> > 
> > How the problem is solved if after this patchset drivers still queue a
> > work item?
> 
> It's only a problem if you bank on any stateful association between FDB
> entries and your ports (aka you expect that port->bridge_dev still holds
> the same value in the atomic handler as in the deferred work item). I
> think drivers don't do this at the moment, otherwise they would be
> broken.
> 
> When they need that, they will convert to synchronous handling and all
> will be fine.
> 
> > DSA supports learning, but does not report the entries to the bridge.
> 
> Why is this relevant exactly?

Because I wanted to make sure that FDB entries that are not present in
the bridge are also flushed.

> 
> > How are these entries deleted when a port leaves the bridge?
> 
> dsa_port_fast_age does the following
> (a) deletes the hardware learned entries on a port, in all VLANs
> (b) notifies the bridge to also flush its software FDB on that port
> 
> It is called
> (a) when the STP state changes from a learning-capable state (LEARNING,
>     FORWARDING) to a non-learning capable state (BLOCKING, LISTENING)
> (b) when learning is turned off by the user
> (c) when learning is turned off by the port becoming standalone after
>     leaving a bridge (actually same code path as b)
> 
> So the FDB of a port is also flushed when a single switch port leaves a
> LAG that is the actual bridge port (maybe not ideal, but I don't know
> any better).
> 
> > > This is a dependency for the "DSA FDB isolation" posted here. It was
> > > split out of that series hence the numbering starts directly at v2.
> > > 
> > > https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/
> > 
> > What is FDB isolation? Cover letter says: "There are use cases which
> > need FDB isolation between standalone ports and bridged ports, as well
> > as isolation between ports of different bridges".
> 
> FDB isolation means exactly what it says: that the hardware FDB lookup
> of ports that are standalone, or under one bridge, is unable to find FDB entries
> (same MAC address, same VID) learned on another port from another bridge.
> 
> > Does it mean that DSA currently forwards packets between ports even if
> > they are member in different bridges or standalone?
> 
> No, that is plain forwarding isolation in my understanding of terms, and
> we have had that for many years now.

So if I have {00:01:02:03:04:05, 5} in br0, but not in br1 and now a
packet with this DMAC/VID needs to be forwarded in br1 it will be
dropped instead of being flooded?
