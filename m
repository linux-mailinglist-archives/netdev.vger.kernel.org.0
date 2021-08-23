Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71293F4A75
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 14:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbhHWMRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 08:17:49 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42041 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236080AbhHWMRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 08:17:48 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7B0B9580A2E;
        Mon, 23 Aug 2021 08:16:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 23 Aug 2021 08:16:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wjZ1Ab
        3tT/gw6i3R6kDawbC7G4Vz4VHhTxsGWTGUDG8=; b=pfVnaAHNd58uLPax7rftEg
        9vlYkcZb95W1KKAnNYR5Gg5zWR324nmezhQfz4VttC2lhmqlS/1ZHukLQn0pt2G7
        vQassDGDi53E4IM4SZGq3v0Sm6MFo2X2k2NnyVqd+oqLm0nYKmfmG25PoS/yYZKr
        0D5ynm5q3sadQv0UaTAVwKQOoyBC6z9KRWDPYYu56Ixx/j7yyvdpgSmP5h27vMMB
        v7oe3Zm2dcgl9xub5s04eFxqiKU3POFyr8Fzhg8aWcBsAOsyd3gnklFLVHIg3UZI
        MYrq8Dd28HTu8XNpRwDzqJWgkKdFEjjUo2iuhdY+wx4uHDEXUbYrTkRRfkZZovYA
        ==
X-ME-Sender: <xms:tZEjYdrLR9PUFiT6K5hLSipPIgZRBl3BfclKVhvBm1RSkqn1cT7e3Q>
    <xme:tZEjYfrDpbcnKprHov9k7SRe7A5ckpUgcPmWXVJZ5ab8zpIYuu-86xCsSCpMFkk82
    Pfxs5_bFcmlDYw>
X-ME-Received: <xmr:tZEjYaNlf42xlHcudIlY8AvpU7aixt30Z-oMDRARlu_ccKvzciQlAhZLC7VA8Ai8G3NJx71kwceFVQ73kPmxmu3Rnmqa0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddthedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:tZEjYY4ktgXOMEqFpEU-8eP7uOtie0xmWovaSiMRHsZLb70vJWxt6A>
    <xmx:tZEjYc7okCaHwQuMXggTcsaB92PJO8b7jWryip3ZAi7YkFRZaWRPQg>
    <xmx:tZEjYQjQql8JpyByfPGGkJpyo1L4PLAjm0Gc4AnC8DW4f09xXD855Q>
    <xmx:upEjYW6uknflZHSezfNFu0X5Uw10nAduqJEGe_U9XhsAZfl-4vIigw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Aug 2021 08:16:52 -0400 (EDT)
Date:   Mon, 23 Aug 2021 15:16:48 +0300
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
Message-ID: <YSORsKDOwklF19Gm@shredder>
References: <YR/TrkbhhN7QpRcQ@shredder>
 <20210820170639.rvzlh4b6agvrkv2w@skbuf>
 <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
 <YSHzLKpixhCrrgJ0@shredder>
 <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
 <20210822133145.jjgryhlkgk4av3c7@skbuf>
 <YSKD+DK4kavYJrRK@shredder>
 <20210822174449.nby7gmrjhwv3walp@skbuf>
 <YSN83d+wwLnba349@shredder>
 <20210823110046.xuuo37kpsxdbl6c2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823110046.xuuo37kpsxdbl6c2@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 02:00:46PM +0300, Vladimir Oltean wrote:
> On Mon, Aug 23, 2021 at 01:47:57PM +0300, Ido Schimmel wrote:
> > On Sun, Aug 22, 2021 at 08:44:49PM +0300, Vladimir Oltean wrote:
> > > On Sun, Aug 22, 2021 at 08:06:00PM +0300, Ido Schimmel wrote:
> > > > On Sun, Aug 22, 2021 at 04:31:45PM +0300, Vladimir Oltean wrote:
> > > > > 3. There is a larger issue that SWITCHDEV_FDB_ADD_TO_DEVICE events are
> > > > >    deferred by drivers even from code paths that are initially blocking
> > > > >    (are running in process context):
> > > > >
> > > > > br_fdb_add
> > > > > -> __br_fdb_add
> > > > >    -> fdb_add_entry
> > > > >       -> fdb_notify
> > > > >          -> br_switchdev_fdb_notify
> > > > >
> > > > >     It seems fairly trivial to move the fdb_notify call outside of the
> > > > >     atomic section of fdb_add_entry, but with switchdev offering only an
> > > > >     API where the SWITCHDEV_FDB_ADD_TO_DEVICE is atomic, drivers would
> > > > >     still have to defer these events and are unable to provide
> > > > >     synchronous feedback to user space (error codes, extack).
> > > > >
> > > > > The above issues would warrant an attempt to fix a central problem, and
> > > > > make switchdev expose an API that is easier to consume rather than
> > > > > having drivers implement lateral workarounds.
> > > > >
> > > > > In this case, we must notice that
> > > > >
> > > > > (a) switchdev already has the concept of notifiers emitted from the fast
> > > > >     path that are still processed by drivers from blocking context. This
> > > > >     is accomplished through the SWITCHDEV_F_DEFER flag which is used by
> > > > >     e.g. SWITCHDEV_OBJ_ID_HOST_MDB.
> > > > >
> > > > > (b) the bridge del_nbp() function already calls switchdev_deferred_process().
> > > > >     So if we could hook into that, we could have a chance that the
> > > > >     bridge simply waits for our FDB entry offloading procedure to finish
> > > > >     before it calls netdev_upper_dev_unlink() - which is almost
> > > > >     immediately afterwards, and also when switchdev drivers typically
> > > > >     break their stateful associations between the bridge upper and
> > > > >     private data.
> > > > >
> > > > > So it is in fact possible to use switchdev's generic
> > > > > switchdev_deferred_enqueue mechanism to get a sleepable callback, and
> > > > > from there we can call_switchdev_blocking_notifiers().
> > > > >
> > > > > To address all requirements:
> > > > >
> > > > > - drivers that are unconverted from atomic to blocking still work
> > > > > - drivers that currently have a private workqueue are not worse off
> > > > > - drivers that want the bridge to wait for their deferred work can use
> > > > >   the bridge's defer mechanism
> > > > > - a SWITCHDEV_FDB_ADD_TO_DEVICE event which does not have any interested
> > > > >   parties does not get deferred for no reason, because this takes the
> > > > >   rtnl_mutex and schedules a worker thread for nothing
> > > > >
> > > > > it looks like we can in fact start off by emitting
> > > > > SWITCHDEV_FDB_ADD_TO_DEVICE on the atomic chain. But we add a new bit in
> > > > > struct switchdev_notifier_fdb_info called "needs_defer", and any
> > > > > interested party can set this to true.
> > > > >
> > > > > This way:
> > > > >
> > > > > - unconverted drivers do their work (i.e. schedule their private work
> > > > >   item) based on the atomic notifier, and do not set "needs_defer"
> > > > > - converted drivers only mark "needs_defer" and treat a separate
> > > > >   notifier, on the blocking chain, called SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > > > > - SWITCHDEV_FDB_ADD_TO_DEVICE events with no interested party do not
> > > > >   generate any follow-up SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > > > >
> > > > > Additionally, code paths that are blocking right not, like br_fdb_replay,
> > > > > could notify only SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED, as long as all
> > > > > consumers of the replayed FDB events support that (right now, that is
> > > > > DSA and dpaa2-switch).
> > > > >
> > > > > Once all consumers of SWITCHDEV_FDB_ADD_TO_DEVICE are converted to set
> > > > > needs_defer as appropriate, then the notifiers emitted from process
> > > > > context by the bridge could call SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > > > > directly, and we would also have fully blocking context all the way
> > > > > down, with the opportunity for error propagation and extack.
> > > >
> > > > IIUC, at this stage all the FDB notifications drivers get are blocking,
> > > > either from the work queue (because they were deferred) or directly from
> > > > process context. If so, how do we synchronize the two and ensure drivers
> > > > get the notifications at the correct order?
> > >
> > > What does 'at this stage' mean? Does it mean 'assuming the patch we're
> > > discussing now gets accepted'? If that's what it means, then 'at this
> > > stage' all drivers would first receive the atomic FDB_ADD_TO_DEVICE,
> > > then would set needs_defer, then would receive the blocking
> > > FDB_ADD_TO_DEVICE.
> >
> > I meant after:
> >
> > "Once all consumers of SWITCHDEV_FDB_ADD_TO_DEVICE are converted to set
> > needs_defer as appropriate, then the notifiers emitted from process
> > context by the bridge could call SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > directly, and we would also have fully blocking context all the way
> > down, with the opportunity for error propagation and extack."
> >
> > IIUC, after the conversion the 'needs_defer' is gone and all the FDB
> > events are blocking? Either from syscall context or the workqueue.
> 
> We would not delete 'needs_defer'. It still offers a useful preliminary
> filtering mechanism for the fast path (and for br_fdb_replay). In
> retrospect, the SWITCHDEV_OBJ_ID_HOST_MDB would also benefit from 'needs_defer'
> instead of jumping to blocking context (if we care so much about performance).
> 
> If a FDB event does not need to be processed by anyone (dynamically
> learned entry on a switchdev port), the bridge notifies the atomic call
> chain for the sake of it, but not the blocking chain.
> 
> > If so, I'm not sure how we synchronize the two. That is, making sure
> > that an event from syscall context does not reach drivers before an
> > earlier event that was added to the 'deferred' list.
> >
> > I mean, in syscall context we are holding RTNL so whatever is already on
> > the 'deferred' list cannot be dequeued and processed.
> 
> So switchdev_deferred_process() has ASSERT_RTNL. If we call
> switchdev_deferred_process() right before adding the blocking FDB entry
> in process context (and we already hold rtnl_mutex), I though that would
> be enough to ensure we have a synchronization point: Everything that was
> scheduled before is flushed now, everything that is scheduled while we
> are running will run after we unlock the rtnl_mutex. Is that not the
> order we expect? I mean, if there is a fast path FDB entry being learned
> / deleted while user space say adds that same FDB entry as static, how
> is the relative ordering ensured between the two?

I was thinking about the following case:

t0 - <MAC1,VID1,P1> is added in syscall context under 'hash_lock'
t1 - br_fdb_delete_by_port() flushes entries under 'hash_lock' in
     response to STP state. Notifications are added to 'deferred' list
t2 - switchdev_deferred_process() is called in syscall context
t3 - <MAC1,VID1,P1> is notified as blocking

Updates to the SW FDB are protected by 'hash_lock', but updates to the
HW FDB are not. In this case, <MAC1,VID1,P1> does not exist in SW, but
it will exist in HW.

Another case assuming switchdev_deferred_process() is called first:

t0 - switchdev_deferred_process() is called in syscall context
t1 - <MAC1,VID,P1> is learned under 'hash_lock'. Notification is added
     to 'deferred' list
t2 - <MAC1,VID1,P1> is modified in syscall context under 'hash_lock' to
     <MAC1,VID1,P2>
t3 - <MAC1,VID1,P2> is notified as blocking
t4 - <MAC1,VID1,P1> is notified as blocking (next time the 'deferred'
     list is processed)

In this case, the HW will have <MAC1,VID1,P1>, but SW will have
<MAC1,VID1,P2>
