Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A9A3F40B9
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 19:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhHVRpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 13:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhHVRpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 13:45:35 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EC9C061575
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 10:44:54 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id n12so22444923edx.8
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 10:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dhLlvCekxFQEAwwbWLwQEh3EHDW7kZtKCwZsVPhy/BA=;
        b=Sgc0XqQpsHVncoypUhYsZ+8ZX3JxvZcQ5YlVhi2gbIHQ2z84bT/KAhe6FyWQbv/3r2
         N7knK42iGXIm6+UJTv1TNH8HyeLlrVOsx3GA5Yclml3JkyMHKqN60POqvqJod/YC33AX
         LFOxaaN26NIEbUQ+HH2NnTcz9Qhf9CQBOqTuzlW6HHIfpIs3vGsBr0g7W5bx/zBV+FtI
         Y3Zm6Og8gVYgVcgwG+Z01SXSf3KaHXOoqNWf9Ub4/G8NleNC8hB9wyczB9l08B8pn2JI
         xtpH+VuZ/FkBdBhfSTZ5tmTXst8tN2NdRDFuSjmeq1jRnjL9xPymoCqNqiEwkPTW/Czz
         7utA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dhLlvCekxFQEAwwbWLwQEh3EHDW7kZtKCwZsVPhy/BA=;
        b=IYhx4hRpj/szvxM0pYQAbyyP2EHXLr6ay2uEeaTKqDphU0ZT94jQX8G9mKZ6Du75zx
         E+QCIeuVvFpMkSXUtmQ0lU39zYEF5Ljz/LjSWeItqxc+m3n+VmkMtxkM5uDuyZT9t8xe
         woP1ewLjUtBOdAaYFuLTbHkDUcRhAfNYEHtjAXmaEwxrC+GkLnl4IdXumcLDK359d/WP
         4wX6Qt8GsEyR2Haa8ciewEt+/Tc4lG0jjuoeD7m/IChJCMfp7T7Rod21wy0oNWyzsazh
         hEBhbMeoznFzGI7pOBtcHKn53r3IhnsOZJ6hPdYwJCrcdecot5dI6kr6WY1HUBICvD8f
         KqfA==
X-Gm-Message-State: AOAM5313h3I2o9YMe4r9lEqzSMzdEIPQ/vcnjXHmmGUCSa2NQ+QFSlls
        2AZHKGdL7PD5REUTrernVvQ=
X-Google-Smtp-Source: ABdhPJxidSKYbXMDfvh97x25ZlcYIm+qgDNHkv5ezEVjrwuHm7vUqoZtTPEhI9nJMO9w2BCWKK82kQ==
X-Received: by 2002:aa7:d40f:: with SMTP id z15mr33178057edq.113.1629654292633;
        Sun, 22 Aug 2021 10:44:52 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id mb14sm3618990ejb.81.2021.08.22.10.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 10:44:52 -0700 (PDT)
Date:   Sun, 22 Aug 2021 20:44:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
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
Message-ID: <20210822174449.nby7gmrjhwv3walp@skbuf>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
 <20210820093723.qdvnvdqjda3m52v6@skbuf>
 <YR/TrkbhhN7QpRcQ@shredder>
 <20210820170639.rvzlh4b6agvrkv2w@skbuf>
 <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
 <YSHzLKpixhCrrgJ0@shredder>
 <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
 <20210822133145.jjgryhlkgk4av3c7@skbuf>
 <YSKD+DK4kavYJrRK@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSKD+DK4kavYJrRK@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 08:06:00PM +0300, Ido Schimmel wrote:
> On Sun, Aug 22, 2021 at 04:31:45PM +0300, Vladimir Oltean wrote:
> > 3. There is a larger issue that SWITCHDEV_FDB_ADD_TO_DEVICE events are
> >    deferred by drivers even from code paths that are initially blocking
> >    (are running in process context):
> > 
> > br_fdb_add
> > -> __br_fdb_add
> >    -> fdb_add_entry
> >       -> fdb_notify
> >          -> br_switchdev_fdb_notify
> > 
> >     It seems fairly trivial to move the fdb_notify call outside of the
> >     atomic section of fdb_add_entry, but with switchdev offering only an
> >     API where the SWITCHDEV_FDB_ADD_TO_DEVICE is atomic, drivers would
> >     still have to defer these events and are unable to provide
> >     synchronous feedback to user space (error codes, extack).
> > 
> > The above issues would warrant an attempt to fix a central problem, and
> > make switchdev expose an API that is easier to consume rather than
> > having drivers implement lateral workarounds.
> > 
> > In this case, we must notice that
> > 
> > (a) switchdev already has the concept of notifiers emitted from the fast
> >     path that are still processed by drivers from blocking context. This
> >     is accomplished through the SWITCHDEV_F_DEFER flag which is used by
> >     e.g. SWITCHDEV_OBJ_ID_HOST_MDB.
> > 
> > (b) the bridge del_nbp() function already calls switchdev_deferred_process().
> >     So if we could hook into that, we could have a chance that the
> >     bridge simply waits for our FDB entry offloading procedure to finish
> >     before it calls netdev_upper_dev_unlink() - which is almost
> >     immediately afterwards, and also when switchdev drivers typically
> >     break their stateful associations between the bridge upper and
> >     private data.
> > 
> > So it is in fact possible to use switchdev's generic
> > switchdev_deferred_enqueue mechanism to get a sleepable callback, and
> > from there we can call_switchdev_blocking_notifiers().
> > 
> > To address all requirements:
> > 
> > - drivers that are unconverted from atomic to blocking still work
> > - drivers that currently have a private workqueue are not worse off
> > - drivers that want the bridge to wait for their deferred work can use
> >   the bridge's defer mechanism
> > - a SWITCHDEV_FDB_ADD_TO_DEVICE event which does not have any interested
> >   parties does not get deferred for no reason, because this takes the
> >   rtnl_mutex and schedules a worker thread for nothing
> > 
> > it looks like we can in fact start off by emitting
> > SWITCHDEV_FDB_ADD_TO_DEVICE on the atomic chain. But we add a new bit in
> > struct switchdev_notifier_fdb_info called "needs_defer", and any
> > interested party can set this to true.
> > 
> > This way:
> > 
> > - unconverted drivers do their work (i.e. schedule their private work
> >   item) based on the atomic notifier, and do not set "needs_defer"
> > - converted drivers only mark "needs_defer" and treat a separate
> >   notifier, on the blocking chain, called SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > - SWITCHDEV_FDB_ADD_TO_DEVICE events with no interested party do not
> >   generate any follow-up SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > 
> > Additionally, code paths that are blocking right not, like br_fdb_replay,
> > could notify only SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED, as long as all
> > consumers of the replayed FDB events support that (right now, that is
> > DSA and dpaa2-switch).
> > 
> > Once all consumers of SWITCHDEV_FDB_ADD_TO_DEVICE are converted to set
> > needs_defer as appropriate, then the notifiers emitted from process
> > context by the bridge could call SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > directly, and we would also have fully blocking context all the way
> > down, with the opportunity for error propagation and extack.
> 
> IIUC, at this stage all the FDB notifications drivers get are blocking,
> either from the work queue (because they were deferred) or directly from
> process context. If so, how do we synchronize the two and ensure drivers
> get the notifications at the correct order?

What does 'at this stage' mean? Does it mean 'assuming the patch we're
discussing now gets accepted'? If that's what it means, then 'at this
stage' all drivers would first receive the atomic FDB_ADD_TO_DEVICE,
then would set needs_defer, then would receive the blocking
FDB_ADD_TO_DEVICE.

Thinking a bit more - this two-stage notification process ends up being
more efficient for br_fdb_replay too. We don't queue up FDB entries
except if the driver tells us that it wants to process them in blocking
context.

> I was thinking of adding all the notifications to the 'deferred' list
> when 'hash_lock' is held and then calling switchdev_deferred_process()
> directly in process context. It's not very pretty (do we return an error
> only for the entry the user added or for any other entry we flushed from
> the list?), but I don't have a better idea right now.

I was thinking to add a switchdev_fdb_add_to_device_now(). As opposed to
the switchdev_fdb_add_to_device() which defers, this does not defer at
all but just call_blocking_switchdev_notifiers(). So it would not go
through switchdev_deferred_enqueue.  For the code path I talked above,
we would temporarily drop the spin_lock, then call
switchdev_fdb_add_to_device_now(), then if that fails, take the
spin_lock again and delete the software fdb entry we've just added.

So as long as we use a _now() variant and don't resynchronize with the
deferred work, we shouldn't have any ordering issues, or am I
misunderstanding your question?

> 
> > 
> > Some disadvantages of this solution though:
> > 
> > - A driver now needs to check whether it is interested in an event
> >   twice: first on the atomic call chain, then again on the blocking call
> >   chain (because it is a notifier chain, it is potentially not the only
> >   driver subscribed to it, it may be listening to another driver's
> >   needs_defer request). The flip side: on sistems with mixed switchdev
> >   setups (dpaa2-switch + DSA, and DSA sniffs dynamically learned FDB
> >   entries on foreign interfaces), there are some "synergies", and the
> >   SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED event is only emitted once, as
> >   opposed to what would happen if each driver scheduled its own private
> >   work item.
> > 
> > - Right now drivers take rtnl_lock() as soon as their private work item
> >   runs. They need the rtnl_lock for the call to
> >   call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED). 
> 
> I think RCU is enough?

Maybe, I haven't experimented with it. I thought br_fdb_offloaded_set
would notify back rtnetlink, but it looks like it doesn't.

> >   But it doesn't really seem necessary for them to perform the actual
> >   hardware manipulation (adding the FDB entry) with the rtnl_lock held
> >   (anyway most do that). But with the new option of servicing
> >   SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED, the rtnl_lock is taken
> >   top-level by switchdev, so even if these drivers wanted to be more
> >   self-conscious, they couldn't.
> 
> Yes, I want to remove this dependency in mlxsw assuming notifications
> remain atomic. The more pressing issue is actually removing it from the
> learning path.

Bah, I understand where you're coming from, but it would be tricky to
remove the rtnl_lock from switchdev_deferred_process_work (that's what
it boils down to). My switchdev_handle_fdb_add_to_device helper currently
assumes rcu_read_lock(). With the blocking variant of SWITCHDEV_FDB_ADD_TO_DEVICE,
it would still need to traverse the netdev adjacency lists, so it would
need the rtnl_mutex for that. If we remove the rtnl_lock from
switchdev_deferred_process_work we'd have to add it back in DSA and to
any other callers of switchdev_handle_fdb_add_to_device.
