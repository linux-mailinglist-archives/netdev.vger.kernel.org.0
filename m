Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F280143B289
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhJZMlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:41:12 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:56153 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231224AbhJZMlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 08:41:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id E04C05805DF;
        Tue, 26 Oct 2021 08:38:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 26 Oct 2021 08:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NNyOC9
        mSG6Hn5Lq3ejq08HvV/uqvKLAHE+WrKa76DZc=; b=XJPV8Bk/mpo7ZxSssAEboK
        j4HwVSWwpn1U+SbJa01zThvHkInRvJJrNuulSsJmlfvNKBmpYIJ0PFpQPLrc/9x/
        SNeJhZmS+NOuGMaSnxTBdKx4BQcm9fwoisfnevNMAMYg9LtD0qxUWNMPiz2enLQX
        VQyh0n+9W1DoJ6lqUBWKzmFX/Qpm7M5h1ip/IX1t4CwdMxta1+7igKp9JMT7vg3u
        HiK4YoBU1Ke5S8ngi9wlSW9fXU93WNj84YfubSChi0gLgGY40lWoQdf/baeW87P5
        3LjmxJta/b5Y4ASWKsfVL1DxGS+7ai6W1+RVDGfo2US+zLksVENWJEqk3K3iPW+Q
        ==
X-ME-Sender: <xms:1fZ3YXA-xTSxM1goCxyN5EkfQtVuisZtSXdWsO6aKBWQV6-a0KijQQ>
    <xme:1fZ3YdhRSqVfnHhIb14FxceOhO2heocCbLdvnZMQLwbH6mnBnIkVuEcjEbiLJnSA-
    oJmPstqoJUkHM4>
X-ME-Received: <xmr:1fZ3YSlBreBLK2TTdKDH-cfwucf5doBapP5D6rtDBq-gqMwx1ZiWzOPAUxzFaZm-Ugb3rrlQF89MQ5MIDw82H4_pSdmkyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefkedgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1fZ3YZwA_zaPexmoxCUBwVoAdf4WCZFEcPfiTGpBZ72Hay2jAEhDyw>
    <xmx:1fZ3YcQuM5lUIxy7kQOGhwLDQuU9ut4C3L30reX6t_oJvCrwJ84Kkw>
    <xmx:1fZ3YcadZcyGEmauHeO9_sZUzge_b-n-eYSdzGHQ92a2rB1RmCwFgw>
    <xmx:1fZ3YV-AhdhIWI3uCID5CdBWvqXafklKkCFnxqd78tstkFL8z7xIXg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 08:38:44 -0400 (EDT)
Date:   Tue, 26 Oct 2021 15:38:34 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Message-ID: <YXf2ylbMUhJWcTjR@shredder>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
 <531e75e8-d5d1-407b-d665-aec2a66bf432@nvidia.com>
 <20211026112525.glv7n2fk27sjqubj@skbuf>
 <1d9c3666-4b29-17e6-1b65-8c64c5eed726@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d9c3666-4b29-17e6-1b65-8c64c5eed726@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 03:20:03PM +0300, Nikolay Aleksandrov wrote:
> On 26/10/2021 14:25, Vladimir Oltean wrote:
> > On Tue, Oct 26, 2021 at 01:40:15PM +0300, Nikolay Aleksandrov wrote:
> >> Hi,
> >> Interesting way to work around the asynchronous notifiers. :) I went over
> >> the patch-set and given that we'll have to support and maintain this fragile
> >> solution (e.g. playing with locking, possible races with fdb changes etc) I'm
> >> inclined to go with Ido's previous proposition to convert the hash_lock into a mutex
> >> with delayed learning from the fast-path to get a sleepable context where we can
> >> use synchronous switchdev calls and get feedback immediately.
> > 
> > Delayed learning means that we'll receive a sequence of packets like this:
> > 
> >             br0--------\
> >           /    \        \
> >          /      \        \
> >         /        \        \
> >      swp0         swp1    swp2
> >       |            |        |
> >    station A   station B  station C
> > 
> > station A sends request to B, station B sends reply to A.
> > Since the learning of station A's MAC SA races with the reply sent by
> > station B, it now becomes theoretically possible for the reply packet to
> > be flooded to station C as well, right? And that was not possible before
> > (at least assuming an ageing time longer than the round-trip time of these packets).
> > 
> > And that will happen regardless of whether switchdev is used or not.
> > I don't want to outright dismiss this (maybe I don't fully understand
> > this either), but it seems like a pretty heavy-handed change.
> > 
> 
> It will depending on lock contention, I plan to add a fast/uncontended case with
> trylock from fast-path and if that fails then queue the fdb, but yes - in general
> you are correct that the traffic could get flooded in the queue case before the delayed
> learning processes the entry, it's a trade off if we want sleepable learning context.
> Ido noted privately that's usually how hw acts anyway, also if people want guarantees

To be clear, I was referring to Spectrum where that hardware doesn't
learn automatically, but instead notifies the CPU about entries that can
be learned / aged. It is then up to the software to program the entries.

I don't know how it works in other devices, but I assume Spectrum is not
special in this regard.

> that the reply won't get flooded there are other methods to achieve that (ucast flood
> disable, firewall rules etc). Today the reply could get flooded if the entry can't be programmed
> as well, e.g. the atomic allocation might fail and we'll flood it again, granted it's much less likely
> but still there haven't been any such guarantees. I think it's generally a good improvement and
> will simplify a lot of processing complexity. We can bite the bullet and get the underlying delayed
> infrastructure correct once now, then the locking rules and other use cases would be easier to enforce
> and reason about in the future.

Yes, I agree. Moving processing away from the data path has
disadvantages (Vladimir's example), but it also has advantages, such as
synchronous feedback, improved performance (e.g., netlink notifications
no longer sent from the data path), etc.

> 
> >> That would be the
> >> cleanest and most straight-forward solution, it'd be less error-prone and easier
> >> to maintain long term. I plan to convert the bridge hash_lock to a mutex and then
> >> you can do the synchronous switchdev change if you don't mind and agree of course.
> > 
> > I agree that there are races and implications I haven't fully thought of,
> > with this temporary dropping of the br->hash_lock. It doesn't appear ideal.
> > 
> > For example,
> > 
> > /* Delete an FDB entry and notify switchdev. */
> > static int __br_fdb_delete(struct net_bridge *br,
> > 			   const struct net_bridge_port *p,
> > 			   const u8 *addr, u16 vlan,
> > 			   struct netlink_ext_ack *extack)
> > {
> > 	struct br_switchdev_fdb_wait_ctx wait_ctx;
> > 	struct net_bridge_fdb_entry *fdb;
> > 	int err;
> > 
> > 	br_switchdev_fdb_wait_ctx_init(&wait_ctx);
> > 
> > 	spin_lock_bh(&br->hash_lock);
> > 
> > 	fdb = br_fdb_find(br, addr, vlan);
> > 	if (!fdb || READ_ONCE(fdb->dst) != p) {
> > 		spin_unlock_bh(&br->hash_lock);
> > 		return -ENOENT;
> > 	}
> > 
> > 	br_fdb_notify_async(br, fdb, RTM_DELNEIGH, extack, &wait_ctx);
> > 
> > 	spin_unlock_bh(&br->hash_lock);
> > 
> > 	err = br_switchdev_fdb_wait(&wait_ctx); <- at this stage (more comments below)
> > 	if (err)
> > 		return err;
> > 
> > 	/* We've notified rtnl and switchdev once, don't do it again,
> > 	 * just delete.
> > 	 */
> > 	return fdb_delete_by_addr_and_port(br, p, addr, vlan, false);
> > }
> > 
> > the software FDB still contains the entry, while the hardware doesn't.
> > And we are no longer holding the lock, so somebody can either add or
> > delete that entry.
> > 
> > If somebody else tries to concurrently add that entry, it should not
> > notify switchdev again because it will see that the FDB entry exists,
> > and we should finally end up deleting it and result in a consistent
> > state.
> > 
> > If somebody else tries to concurrently delete that entry, it will
> > probably be from a code path that ignores errors (because the code paths
> > that don't are serialized by the rtnl_mutex). Switchdev will say "hey,
> > but I don't have this FDB entry, you've just deleted it", but that will
> > again be fine.
> > 
> > There seems to be a problem if somebody concurrently deletes that entry,
> > _and_then_ it gets added back again, all that before we call
> > fdb_delete_by_addr_and_port(). Because we don't notify switchdev the
> > second time around, we'll end up with an address in hardware but no
> > software counterpart.
> > 
> > I don't really know how to cleanly deal with that.
> > 
> 
> Right, I'm sure new cases will come up and it won't be easy to reason about these
> races when changes need to be made. I'd rather stick to a more straight-forward
> and simpler approach.

I think we should either convert to mutex or stay with the current
behavior. I think the bridge is going to be really hard to maintain
otherwise.

> 
> >> By the way patches 1-6 can stand on their own, feel free to send them separately. 
> > 
> > Thanks, I will.
> > 
> 
