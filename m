Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DFD3F48EA
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 12:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbhHWKs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 06:48:59 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:54765 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236272AbhHWKs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 06:48:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7D524580A3F;
        Mon, 23 Aug 2021 06:48:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Aug 2021 06:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8BsjKM
        rZJzpgJ9BvUD6yU0uDxP47N/opIX0zWXJc7MA=; b=qCTIoVQMbGpbKy+e61xUdR
        fDmHpNjxR0MQ/DF2TkV2Ro8W6/cwp3EPs6WEHkj2zvCMyaqEtdXP/k/pO4cBuCZr
        XbL2bEeX0PP1oPwIicdcVPRpjTS6V+tFw1JRRzxt4q7BW2EI0hoYV/T9lGF2WvZg
        qkQVdpPKsM3fkx/tnrZRQCMAIiHnK+VCX4z0PPH0gF8UDVIFK5nCUt46RX0/uz8T
        E1vQLWo7bDQki9zcvY0Sw922+oMm7ryGAAi9REMiqz1qulZ3gf9ePzUXaNpftihI
        wfSEXX0VMg8Wxnkdw5AX15OCPT7bM+kaIMZ6gnF2IMmYq3wzjsMVrtafxH6tCVbw
        ==
X-ME-Sender: <xms:43wjYX1QhBmiIYlfE5HniHymIBivFA26oKCV-xcrllt5-3M3OUS5Nw>
    <xme:43wjYWGv2J5a0av7Y8d7XSw17iguYKn4zSPaDewYnA3HsD7XG2uhMN1eHn1jJWnhW
    3pFHzI5KHV5Fik>
X-ME-Received: <xmr:43wjYX4qoBLlnBlBSno9vfMc5NtJbvOcaKyaitr9vF678tTpKO3PGBDNWqfWrDeHhkC5An1W8tzJAhkfJN4eJmb9F2SLnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddthedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:43wjYc23aolT4RUBTBzYlc_x3EWVojuL5wVOP8p0vri7yLa3_TA84g>
    <xmx:43wjYaE00tZE_owZUogrGzO2SmyZuyTdC56WPen2YXZNePAdEpgDaQ>
    <xmx:43wjYd-qG_bO4eAb1qMJJ7YUA_8VoI5CBdAuogUob3ujJtNqlYSoUQ>
    <xmx:53wjYe36tV_DCRr0OAMps4U8qIVCplqWn8PwPtG2QiOgJIZYoh9sJQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Aug 2021 06:48:02 -0400 (EDT)
Date:   Mon, 23 Aug 2021 13:47:57 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <YSN83d+wwLnba349@shredder>
References: <YR9y2nwQWtGTumIS@shredder>
 <20210820093723.qdvnvdqjda3m52v6@skbuf>
 <YR/TrkbhhN7QpRcQ@shredder>
 <20210820170639.rvzlh4b6agvrkv2w@skbuf>
 <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
 <YSHzLKpixhCrrgJ0@shredder>
 <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
 <20210822133145.jjgryhlkgk4av3c7@skbuf>
 <YSKD+DK4kavYJrRK@shredder>
 <20210822174449.nby7gmrjhwv3walp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210822174449.nby7gmrjhwv3walp@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 08:44:49PM +0300, Vladimir Oltean wrote:
> On Sun, Aug 22, 2021 at 08:06:00PM +0300, Ido Schimmel wrote:
> > On Sun, Aug 22, 2021 at 04:31:45PM +0300, Vladimir Oltean wrote:
> > > 3. There is a larger issue that SWITCHDEV_FDB_ADD_TO_DEVICE events are
> > >    deferred by drivers even from code paths that are initially blocking
> > >    (are running in process context):
> > > 
> > > br_fdb_add
> > > -> __br_fdb_add
> > >    -> fdb_add_entry
> > >       -> fdb_notify
> > >          -> br_switchdev_fdb_notify
> > > 
> > >     It seems fairly trivial to move the fdb_notify call outside of the
> > >     atomic section of fdb_add_entry, but with switchdev offering only an
> > >     API where the SWITCHDEV_FDB_ADD_TO_DEVICE is atomic, drivers would
> > >     still have to defer these events and are unable to provide
> > >     synchronous feedback to user space (error codes, extack).
> > > 
> > > The above issues would warrant an attempt to fix a central problem, and
> > > make switchdev expose an API that is easier to consume rather than
> > > having drivers implement lateral workarounds.
> > > 
> > > In this case, we must notice that
> > > 
> > > (a) switchdev already has the concept of notifiers emitted from the fast
> > >     path that are still processed by drivers from blocking context. This
> > >     is accomplished through the SWITCHDEV_F_DEFER flag which is used by
> > >     e.g. SWITCHDEV_OBJ_ID_HOST_MDB.
> > > 
> > > (b) the bridge del_nbp() function already calls switchdev_deferred_process().
> > >     So if we could hook into that, we could have a chance that the
> > >     bridge simply waits for our FDB entry offloading procedure to finish
> > >     before it calls netdev_upper_dev_unlink() - which is almost
> > >     immediately afterwards, and also when switchdev drivers typically
> > >     break their stateful associations between the bridge upper and
> > >     private data.
> > > 
> > > So it is in fact possible to use switchdev's generic
> > > switchdev_deferred_enqueue mechanism to get a sleepable callback, and
> > > from there we can call_switchdev_blocking_notifiers().
> > > 
> > > To address all requirements:
> > > 
> > > - drivers that are unconverted from atomic to blocking still work
> > > - drivers that currently have a private workqueue are not worse off
> > > - drivers that want the bridge to wait for their deferred work can use
> > >   the bridge's defer mechanism
> > > - a SWITCHDEV_FDB_ADD_TO_DEVICE event which does not have any interested
> > >   parties does not get deferred for no reason, because this takes the
> > >   rtnl_mutex and schedules a worker thread for nothing
> > > 
> > > it looks like we can in fact start off by emitting
> > > SWITCHDEV_FDB_ADD_TO_DEVICE on the atomic chain. But we add a new bit in
> > > struct switchdev_notifier_fdb_info called "needs_defer", and any
> > > interested party can set this to true.
> > > 
> > > This way:
> > > 
> > > - unconverted drivers do their work (i.e. schedule their private work
> > >   item) based on the atomic notifier, and do not set "needs_defer"
> > > - converted drivers only mark "needs_defer" and treat a separate
> > >   notifier, on the blocking chain, called SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > > - SWITCHDEV_FDB_ADD_TO_DEVICE events with no interested party do not
> > >   generate any follow-up SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > > 
> > > Additionally, code paths that are blocking right not, like br_fdb_replay,
> > > could notify only SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED, as long as all
> > > consumers of the replayed FDB events support that (right now, that is
> > > DSA and dpaa2-switch).
> > > 
> > > Once all consumers of SWITCHDEV_FDB_ADD_TO_DEVICE are converted to set
> > > needs_defer as appropriate, then the notifiers emitted from process
> > > context by the bridge could call SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > > directly, and we would also have fully blocking context all the way
> > > down, with the opportunity for error propagation and extack.
> > 
> > IIUC, at this stage all the FDB notifications drivers get are blocking,
> > either from the work queue (because they were deferred) or directly from
> > process context. If so, how do we synchronize the two and ensure drivers
> > get the notifications at the correct order?
> 
> What does 'at this stage' mean? Does it mean 'assuming the patch we're
> discussing now gets accepted'? If that's what it means, then 'at this
> stage' all drivers would first receive the atomic FDB_ADD_TO_DEVICE,
> then would set needs_defer, then would receive the blocking
> FDB_ADD_TO_DEVICE.

I meant after:

"Once all consumers of SWITCHDEV_FDB_ADD_TO_DEVICE are converted to set
needs_defer as appropriate, then the notifiers emitted from process
context by the bridge could call SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
directly, and we would also have fully blocking context all the way
down, with the opportunity for error propagation and extack."

IIUC, after the conversion the 'needs_defer' is gone and all the FDB
events are blocking? Either from syscall context or the workqueue.

If so, I'm not sure how we synchronize the two. That is, making sure
that an event from syscall context does not reach drivers before an
earlier event that was added to the 'deferred' list.

I mean, in syscall context we are holding RTNL so whatever is already on
the 'deferred' list cannot be dequeued and processed.


> 
> Thinking a bit more - this two-stage notification process ends up being
> more efficient for br_fdb_replay too. We don't queue up FDB entries
> except if the driver tells us that it wants to process them in blocking
> context.
> 
> > I was thinking of adding all the notifications to the 'deferred' list
> > when 'hash_lock' is held and then calling switchdev_deferred_process()
> > directly in process context. It's not very pretty (do we return an error
> > only for the entry the user added or for any other entry we flushed from
> > the list?), but I don't have a better idea right now.
> 
> I was thinking to add a switchdev_fdb_add_to_device_now(). As opposed to
> the switchdev_fdb_add_to_device() which defers, this does not defer at
> all but just call_blocking_switchdev_notifiers(). So it would not go
> through switchdev_deferred_enqueue.  For the code path I talked above,
> we would temporarily drop the spin_lock, then call
> switchdev_fdb_add_to_device_now(), then if that fails, take the
> spin_lock again and delete the software fdb entry we've just added.
> 
> So as long as we use a _now() variant and don't resynchronize with the
> deferred work, we shouldn't have any ordering issues, or am I
> misunderstanding your question?

Not sure I'm following. I tried to explain above.

> 
> > 
> > > 
> > > Some disadvantages of this solution though:
> > > 
> > > - A driver now needs to check whether it is interested in an event
> > >   twice: first on the atomic call chain, then again on the blocking call
> > >   chain (because it is a notifier chain, it is potentially not the only
> > >   driver subscribed to it, it may be listening to another driver's
> > >   needs_defer request). The flip side: on sistems with mixed switchdev
> > >   setups (dpaa2-switch + DSA, and DSA sniffs dynamically learned FDB
> > >   entries on foreign interfaces), there are some "synergies", and the
> > >   SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED event is only emitted once, as
> > >   opposed to what would happen if each driver scheduled its own private
> > >   work item.
> > > 
> > > - Right now drivers take rtnl_lock() as soon as their private work item
> > >   runs. They need the rtnl_lock for the call to
> > >   call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED). 
> > 
> > I think RCU is enough?
> 
> Maybe, I haven't experimented with it. I thought br_fdb_offloaded_set
> would notify back rtnetlink, but it looks like it doesn't.

You mean emit a RTM_NEWNEIGH? This can be done even without RTNL (from
the data path, for example)

> 
> > >   But it doesn't really seem necessary for them to perform the actual
> > >   hardware manipulation (adding the FDB entry) with the rtnl_lock held
> > >   (anyway most do that). But with the new option of servicing
> > >   SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED, the rtnl_lock is taken
> > >   top-level by switchdev, so even if these drivers wanted to be more
> > >   self-conscious, they couldn't.
> > 
> > Yes, I want to remove this dependency in mlxsw assuming notifications
> > remain atomic. The more pressing issue is actually removing it from the
> > learning path.
> 
> Bah, I understand where you're coming from, but it would be tricky to
> remove the rtnl_lock from switchdev_deferred_process_work (that's what
> it boils down to). My switchdev_handle_fdb_add_to_device helper currently
> assumes rcu_read_lock(). With the blocking variant of SWITCHDEV_FDB_ADD_TO_DEVICE,
> it would still need to traverse the netdev adjacency lists, so it would
> need the rtnl_mutex for that. If we remove the rtnl_lock from
> switchdev_deferred_process_work we'd have to add it back in DSA and to
> any other callers of switchdev_handle_fdb_add_to_device.
