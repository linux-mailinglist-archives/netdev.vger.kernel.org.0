Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FD83F3F7E
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 15:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhHVNcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 09:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhHVNcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 09:32:32 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9685C061575
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 06:31:50 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s3so9515218edd.11
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 06:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VFbJACABlbvBp3S6zhU8J//IT7+98MKik/T0dGn0woc=;
        b=mDcam9X/kb7aCsEw3hQQbhpuHEeUzLIK8k0WRdyPxBXjffE0Z/NPiOyyLt+3RuTPZ8
         Gte226Hy94RH3PRRfqtccyPDJzTB0dwNixgnDSQlF8qYhKtmgSnvVzy+yGnZcONMoQMH
         QVhzAvFbrqLocDMmqunYvggPKvr6bHG9Fkc90iR2BmF95m13giFPeV9tsBnDLjIHhO6j
         jJx9ZkPugkfdAZZYwxXtMg8mIhA5QuEmJweLigtQ8zIAid1hRBOjUzog7Hcu48XZ8j/4
         o5eqIFc+2iCFkVVYXKptStPIKvGxcFBX9MNBw33bm9c3U/yjL4i3U2vDJcyMJN+L0FHJ
         BL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VFbJACABlbvBp3S6zhU8J//IT7+98MKik/T0dGn0woc=;
        b=OJEZt62pTVWpCaRJlLc/5YKGgaJB5Y08UHld5QahoYOt0G8xnFpSVmTPqcP4onXVtT
         k0hqLsAbjz2UqUlF+qh1q2RUML9s29JjBISgSNID76g+LRjbn5+Gn0oeH/+oz6CnZ7fK
         On6S6kenDH3FoSHoktbGdvqr59NKcgeM9S7vlQ5sHzGsTL2+1AOiT/k8+LRJvWzFcW1C
         S3+b8hsWtQQrNAzBGN3MC1NDmTRtxqvIk+czimw4GVz21W0VCi7MPjyZgdEGRI97DwkQ
         Bs5dCJIDIKXlrAePELxjmff2qt7B1j4UFmWzzNzDINxRxE/stg3tAxqMhdjuTtF9YLMX
         D8AQ==
X-Gm-Message-State: AOAM531s7+M78ItSFCLwWz9/KsNR8pk76gQstGe7H+pSxaFY3GpgdHie
        33yyAE3vYutjOXC7px/tl6Q=
X-Google-Smtp-Source: ABdhPJwsRea5ttDUjeXenx3GldPCqUdSQnCHow2yrc7qi/QvW8hFkGA/nUWr/UMa+wNoVhHFKOpZWA==
X-Received: by 2002:aa7:d613:: with SMTP id c19mr5452808edr.196.1629639109332;
        Sun, 22 Aug 2021 06:31:49 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id l16sm1300959ejg.42.2021.08.22.06.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 06:31:48 -0700 (PDT)
Date:   Sun, 22 Aug 2021 16:31:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
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
Message-ID: <20210822133145.jjgryhlkgk4av3c7@skbuf>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
 <20210820093723.qdvnvdqjda3m52v6@skbuf>
 <YR/TrkbhhN7QpRcQ@shredder>
 <20210820170639.rvzlh4b6agvrkv2w@skbuf>
 <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
 <YSHzLKpixhCrrgJ0@shredder>
 <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 12:12:02PM +0300, Nikolay Aleksandrov wrote:
> On 22/08/2021 09:48, Ido Schimmel wrote:
> > On Sat, Aug 21, 2021 at 02:36:26AM +0300, Nikolay Aleksandrov wrote:
> >> On 20/08/2021 20:06, Vladimir Oltean wrote:
> >>> On Fri, Aug 20, 2021 at 07:09:18PM +0300, Ido Schimmel wrote:
> >>>> On Fri, Aug 20, 2021 at 12:37:23PM +0300, Vladimir Oltean wrote:
> >>>>> On Fri, Aug 20, 2021 at 12:16:10PM +0300, Ido Schimmel wrote:
> >>>>>> On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
> >>>>>>> Problem statement:
> >>>>>>>
> >>>>>>> Any time a driver needs to create a private association between a bridge
> >>>>>>> upper interface and use that association within its
> >>>>>>> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> >>>>>>> entries deleted by the bridge when the port leaves. The issue is that
> >>>>>>> all switchdev drivers schedule a work item to have sleepable context,
> >>>>>>> and that work item can be actually scheduled after the port has left the
> >>>>>>> bridge, which means the association might have already been broken by
> >>>>>>> the time the scheduled FDB work item attempts to use it.
> >>>>>>
> >>>>>> This is handled in mlxsw by telling the device to flush the FDB entries
> >>>>>> pointing to the {port, FID} when the VLAN is deleted (synchronously).
> >>>>>
> >>>>> Again, central solution vs mlxsw solution.
> >>>>
> >>>> Again, a solution is forced on everyone regardless if it benefits them
> >>>> or not. List is bombarded with version after version until patches are
> >>>> applied. *EXHAUSTING*.
> >>>
> >>> So if I replace "bombarded" with a more neutral word, isn't that how
> >>> it's done though? What would you do if you wanted to achieve something
> >>> but the framework stood in your way? Would you work around it to avoid
> >>> bombarding the list?
> >>>
> >>>> With these patches, except DSA, everyone gets another queue_work() for
> >>>> each FDB entry. In some cases, it completely misses the purpose of the
> >>>> patchset.
> >>>
> >>> I also fail to see the point. Patch 3 will have to make things worse
> >>> before they get better. It is like that in DSA too, and made more
> >>> reasonable only in the last patch from the series.
> >>>
> >>> If I saw any middle-ground way, like keeping the notifiers on the atomic
> >>> chain for unconverted drivers, I would have done it. But what do you do
> >>> if more than one driver listens for one event, one driver wants it
> >>> blocking, the other wants it atomic. Do you make the bridge emit it
> >>> twice? That's even worse than having one useless queue_work() in some
> >>> drivers.
> >>>
> >>> So if you think I can avoid that please tell me how.
> >>>
> >>
> >> Hi,
> >> I don't like the double-queuing for each fdb for everyone either, it's forcing them
> >> to rework it asap due to inefficiency even though that shouldn't be necessary. In the
> >> long run I hope everyone would migrate to such scheme, but perhaps we can do it gradually.
> > 
> > The fundamental problem is that these operations need to be deferred in
> > the first place. It would have been much better if user space could get
> > a synchronous feedback.
> > 
> > It all stems from the fact that control plane operations need to be done
> > under a spin lock because the shared databases (e.g., FDB, MDB) or
> > states (e.g., STP) that they are updating can also be updated from the
> > data plane in softIRQ.
> > 
> 
> Right, but changing that, as you've noted below, would require moving
> the delaying to the bridge, I'd like to avoid that.
> 
> > I don't have a clean solution to this problem without doing a surgery in
> > the bridge driver. Deferring updates from the data plane using a work
> > queue and converting the spin locks to mutexes. This will also allow us
> > to emit netlink notifications from process context and convert
> > GFP_ATOMIC to GFP_KERNEL.
> > 
> > Is that something you consider as acceptable? Does anybody have a better
> > idea?
> > 
> 
> Moving the delays to the bridge for this purpose does not sound like a good solution,
> I'd prefer the delaying to be done by the interested third party as in this case rather
> than the bridge. If there's a solution that avoids delaying and doesn't hurt the software
> fast-path then of course I'll be ok with that.

Maybe emitting two notifiers, one atomic and one blocking, per FDB
add/del event is not such a stupid idea after all.

Here's an alternative I've been cooking. Obviously it still has pros and
cons. Hopefully by reading the commit message you get the basic idea and
I don't need to post the full series.

-----------------------------[ cut here ]-----------------------------
From 9870699f0fafeb6175af3462173a957ece551322 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Sat, 21 Aug 2021 15:57:40 +0300
Subject: [PATCH] net: switchdev: add an option for
 SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to be deferred

Most existing switchdev drivers either talk to firmware, or to a device
over a bus where the I/O is sleepable (SPI, I2C, MDIO etc). So there
exists a pattern where drivers make a sleepable context for offloading
the given FDB entry by registering an ordered workqueue and scheduling
work items on it, and doing all the work from there.

This solution works, but there are some issues with it:

1. It creates large amounts of duplication between switchdev drivers,
   and they don't even copy all the right patterns from each other.
   For example:

   * DSA, dpaa2-switch, rocker allocate an ordered workqueue with the
     WQ_MEM_RECLAIM flag and no one knows why.

   * dpaa2-switch, sparx5, am65_cpsw, cpsw, rocker, prestera, all have
     this check, or one very similar to it:

		if (!fdb_info->added_by_user || fdb_info->is_local)
			break; /* do nothing and exit */

     within the actually scheduled workqueue item. That is to say, they
     schedule and take the rtnl_mutex for nothing - every single time
     that an FDB entry is dynamically learned by the software bridge and
     they are not interested in it. Same thing for the *_dev_check
     function - the function which checks if an FDB entry was learned on
     a network interface owned by the driver.

2. The work items scheduled privately by the driver are not synchronous
   with bridge events (i.e. the bridge will not wait for the driver to
   finish deleting an FDB entry before e.g. calling del_nbp and deleting
   that interface as a bridge port). This might matter for middle layers
   like DSA which construct their own API to their downstream consumers
   on top of the switchdev primitives. With the current switchdev API
   design, it is not possible to guarantee that the bridge which
   generated an FDB entry deletion is still the upper interface by the
   time that the work item is scheduled and the FDB deletion is actually
   executed. To obtain this guarantee it would be necessary to introduce
   a refcounting system where the reference to the bridge is kept by DSA
   for as long as there are pending bridge FDB entry additions/deletions.
   Not really ideal if we look at the big picture.

3. There is a larger issue that SWITCHDEV_FDB_ADD_TO_DEVICE events are
   deferred by drivers even from code paths that are initially blocking
   (are running in process context):

br_fdb_add
-> __br_fdb_add
   -> fdb_add_entry
      -> fdb_notify
         -> br_switchdev_fdb_notify

    It seems fairly trivial to move the fdb_notify call outside of the
    atomic section of fdb_add_entry, but with switchdev offering only an
    API where the SWITCHDEV_FDB_ADD_TO_DEVICE is atomic, drivers would
    still have to defer these events and are unable to provide
    synchronous feedback to user space (error codes, extack).

The above issues would warrant an attempt to fix a central problem, and
make switchdev expose an API that is easier to consume rather than
having drivers implement lateral workarounds.

In this case, we must notice that

(a) switchdev already has the concept of notifiers emitted from the fast
    path that are still processed by drivers from blocking context. This
    is accomplished through the SWITCHDEV_F_DEFER flag which is used by
    e.g. SWITCHDEV_OBJ_ID_HOST_MDB.

(b) the bridge del_nbp() function already calls switchdev_deferred_process().
    So if we could hook into that, we could have a chance that the
    bridge simply waits for our FDB entry offloading procedure to finish
    before it calls netdev_upper_dev_unlink() - which is almost
    immediately afterwards, and also when switchdev drivers typically
    break their stateful associations between the bridge upper and
    private data.

So it is in fact possible to use switchdev's generic
switchdev_deferred_enqueue mechanism to get a sleepable callback, and
from there we can call_switchdev_blocking_notifiers().

To address all requirements:

- drivers that are unconverted from atomic to blocking still work
- drivers that currently have a private workqueue are not worse off
- drivers that want the bridge to wait for their deferred work can use
  the bridge's defer mechanism
- a SWITCHDEV_FDB_ADD_TO_DEVICE event which does not have any interested
  parties does not get deferred for no reason, because this takes the
  rtnl_mutex and schedules a worker thread for nothing

it looks like we can in fact start off by emitting
SWITCHDEV_FDB_ADD_TO_DEVICE on the atomic chain. But we add a new bit in
struct switchdev_notifier_fdb_info called "needs_defer", and any
interested party can set this to true.

This way:

- unconverted drivers do their work (i.e. schedule their private work
  item) based on the atomic notifier, and do not set "needs_defer"
- converted drivers only mark "needs_defer" and treat a separate
  notifier, on the blocking chain, called SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
- SWITCHDEV_FDB_ADD_TO_DEVICE events with no interested party do not
  generate any follow-up SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED

Additionally, code paths that are blocking right not, like br_fdb_replay,
could notify only SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED, as long as all
consumers of the replayed FDB events support that (right now, that is
DSA and dpaa2-switch).

Once all consumers of SWITCHDEV_FDB_ADD_TO_DEVICE are converted to set
needs_defer as appropriate, then the notifiers emitted from process
context by the bridge could call SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
directly, and we would also have fully blocking context all the way
down, with the opportunity for error propagation and extack.

Some disadvantages of this solution though:

- A driver now needs to check whether it is interested in an event
  twice: first on the atomic call chain, then again on the blocking call
  chain (because it is a notifier chain, it is potentially not the only
  driver subscribed to it, it may be listening to another driver's
  needs_defer request). The flip side: on sistems with mixed switchdev
  setups (dpaa2-switch + DSA, and DSA sniffs dynamically learned FDB
  entries on foreign interfaces), there are some "synergies", and the
  SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED event is only emitted once, as
  opposed to what would happen if each driver scheduled its own private
  work item.

- Right now drivers take rtnl_lock() as soon as their private work item
  runs. They need the rtnl_lock for the call to
  call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED). But it doesn't
  really seem necessary for them to perform the actual hardware
  manipulation (adding the FDB entry) with the rtnl_lock held (anyway
  most do that). But with the new option of servicing
  SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED, the rtnl_lock is taken top-level
  by switchdev, so even if these drivers wanted to be more self-conscious,
  they couldn't.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h   | 26 ++++++++++++++-
 net/bridge/br_switchdev.c |  6 ++--
 net/switchdev/switchdev.c | 69 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 5 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 6764fb7692e2..67ddb80c828f 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -193,6 +193,8 @@ enum switchdev_notifier_type {
 	SWITCHDEV_FDB_DEL_TO_BRIDGE,
 	SWITCHDEV_FDB_ADD_TO_DEVICE,
 	SWITCHDEV_FDB_DEL_TO_DEVICE,
+	SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED, /* Blocking. */
+	SWITCHDEV_FDB_DEL_TO_DEVICE_DEFERRED, /* Blocking. */
 	SWITCHDEV_FDB_OFFLOADED,
 	SWITCHDEV_FDB_FLUSH_TO_BRIDGE,
 
@@ -222,7 +224,8 @@ struct switchdev_notifier_fdb_info {
 	u16 vid;
 	u8 added_by_user:1,
 	   is_local:1,
-	   offloaded:1;
+	   offloaded:1,
+	   needs_defer:1;
 };
 
 struct switchdev_notifier_port_obj_info {
@@ -283,6 +286,13 @@ int switchdev_port_obj_add(struct net_device *dev,
 int switchdev_port_obj_del(struct net_device *dev,
 			   const struct switchdev_obj *obj);
 
+int
+switchdev_fdb_add_to_device(struct net_device *dev,
+			    struct switchdev_notifier_fdb_info *fdb_info);
+int
+switchdev_fdb_del_to_device(struct net_device *dev,
+			    struct switchdev_notifier_fdb_info *fdb_info);
+
 int register_switchdev_notifier(struct notifier_block *nb);
 int unregister_switchdev_notifier(struct notifier_block *nb);
 int call_switchdev_notifiers(unsigned long val, struct net_device *dev,
@@ -386,6 +396,20 @@ static inline int switchdev_port_obj_del(struct net_device *dev,
 	return -EOPNOTSUPP;
 }
 
+static inline int
+switchdev_fdb_add_to_device(struct net_device *dev,
+			    struct switchdev_notifier_fdb_info *fdb_info)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int
+switchdev_fdb_del_to_device(struct net_device *dev,
+			    struct switchdev_notifier_fdb_info *fdb_info)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int register_switchdev_notifier(struct notifier_block *nb)
 {
 	return 0;
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 7e62904089c8..687100ca7088 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -140,12 +140,10 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 
 	switch (type) {
 	case RTM_DELNEIGH:
-		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
-					 dev, &info.info, NULL);
+		switchdev_fdb_del_to_device(dev, &info);
 		break;
 	case RTM_NEWNEIGH:
-		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
-					 dev, &info.info, NULL);
+		switchdev_fdb_add_to_device(dev, &info);
 		break;
 	}
 }
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 0b2c18efc079..d2f0bfc8a0b4 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -378,6 +378,75 @@ int call_switchdev_blocking_notifiers(unsigned long val, struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(call_switchdev_blocking_notifiers);
 
+static void switchdev_fdb_add_deferred(struct net_device *dev, const void *data)
+{
+	const struct switchdev_notifier_fdb_info *fdb_info = data;
+	struct switchdev_notifier_fdb_info tmp = *fdb_info;
+	int err;
+
+	ASSERT_RTNL();
+	err = call_switchdev_blocking_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED,
+						dev, &tmp.info, NULL);
+	err = notifier_to_errno(err);
+	if (err && err != -EOPNOTSUPP)
+		netdev_err(dev, "failed to add FDB entry: %pe\n", ERR_PTR(err));
+}
+
+static void switchdev_fdb_del_deferred(struct net_device *dev, const void *data)
+{
+	const struct switchdev_notifier_fdb_info *fdb_info = data;
+	struct switchdev_notifier_fdb_info tmp = *fdb_info;
+	int err;
+
+	ASSERT_RTNL();
+	err = call_switchdev_blocking_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE_DEFERRED,
+						dev, &tmp.info, NULL);
+	err = notifier_to_errno(err);
+	if (err && err != -EOPNOTSUPP)
+		netdev_err(dev, "failed to delete FDB entry: %pe\n",
+			   ERR_PTR(err));
+}
+
+int
+switchdev_fdb_add_to_device(struct net_device *dev,
+			    struct switchdev_notifier_fdb_info *fdb_info)
+{
+	int err;
+
+	err = call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE, dev,
+				       &fdb_info->info, NULL);
+	err = notifier_to_errno(err);
+	if (err)
+		return err;
+
+	if (!fdb_info->needs_defer)
+		return 0;
+
+	return switchdev_deferred_enqueue(dev, fdb_info, sizeof(*fdb_info),
+					  switchdev_fdb_add_deferred);
+}
+EXPORT_SYMBOL_GPL(switchdev_fdb_add_to_device);
+
+int
+switchdev_fdb_del_to_device(struct net_device *dev,
+			    struct switchdev_notifier_fdb_info *fdb_info)
+{
+	int err;
+
+	err = call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE, dev,
+				       &fdb_info->info, NULL);
+	err = notifier_to_errno(err);
+	if (err)
+		return err;
+
+	if (!fdb_info->needs_defer)
+		return 0;
+
+	return switchdev_deferred_enqueue(dev, fdb_info, sizeof(*fdb_info),
+					  switchdev_fdb_del_deferred);
+}
+EXPORT_SYMBOL_GPL(switchdev_fdb_del_to_device);
+
 struct switchdev_nested_priv {
 	bool (*check_cb)(const struct net_device *dev);
 	bool (*foreign_dev_check_cb)(const struct net_device *dev,
-----------------------------[ cut here ]-----------------------------
