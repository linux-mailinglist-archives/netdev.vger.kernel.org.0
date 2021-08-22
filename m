Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DD63F409E
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhHVRGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 13:06:51 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:49903 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231549AbhHVRGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 13:06:50 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id B4B365803FA;
        Sun, 22 Aug 2021 13:06:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 22 Aug 2021 13:06:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ssQlpd
        fTR77ORoouI/8CClDmSjuV+Xv/DpdsxjZoVpg=; b=HZRQVNOYAD5NN45X15HurX
        Q2tjvtbQn4XPHtTZUmi+n10t+8D9jH6X3a4o9dt3qfnjP49yOJIrXPUv4wBGOX1G
        fYHfHLuhx77KbQYucP3tW7++RRrUTMOtyEMThSq2pTGLvuu3WYbj351/me1gIWFn
        UkTAKodhfUI0Bx/s1p/zORG2PovHEEn0D7uNO/O3yWrmGtdFU5QekqNvD/GRjlse
        EupxN5oH6noOAWXD8z/E+GM5u1Kwg6Mcjrgo2g8BGjrDeFozln4mbFFfWNVXneGx
        HhJ1keCp/L/71mUzEgSvXA3OIcLASOFhjzF5ewhMuOEe9q6KD9YzPlUYj8uAdSrg
        ==
X-ME-Sender: <xms:_YMiYXoNoCCRsn9OcUX1WJtTLapSNk7veg7MBRAjS5jWG0OsVP_H4A>
    <xme:_YMiYRp1rzDnTMhyfd_Ar591xP-Z9WgdJWav0Av3Fuke_nQU02LOSYJz0adLGGk06
    B5ZiAMYd9I8l4k>
X-ME-Received: <xmr:_YMiYUOQQtVgRaaKSb7BGMjk0BUK5_Z_eWI4-QukPAzYsy02HFGAob0BlDJtmF3Eqyh2cEGRbbbSoxpHgY5mW_izCH9u3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtfedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_YMiYa4Km_dIJLvGxQGSi3MfBQ1VNN_e5GJbvY024J_WXnJjNvvIXQ>
    <xmx:_YMiYW6kR7G1QvitfWdlaQcyFehSzVSWgjMBbWcRllZCH288vB4Xbg>
    <xmx:_YMiYShzilMS2rmL51amp2Xn_6RgHAzAkZA6gBm2uPjiPCscc83xEA>
    <xmx:AIQiYY7sjnEQL327s32daMgnD_40fpJ7JBTVxowGry9uTLoq_Z1jqw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 22 Aug 2021 13:06:04 -0400 (EDT)
Date:   Sun, 22 Aug 2021 20:06:00 +0300
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
Message-ID: <YSKD+DK4kavYJrRK@shredder>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
 <20210820093723.qdvnvdqjda3m52v6@skbuf>
 <YR/TrkbhhN7QpRcQ@shredder>
 <20210820170639.rvzlh4b6agvrkv2w@skbuf>
 <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
 <YSHzLKpixhCrrgJ0@shredder>
 <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
 <20210822133145.jjgryhlkgk4av3c7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210822133145.jjgryhlkgk4av3c7@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 04:31:45PM +0300, Vladimir Oltean wrote:
> 3. There is a larger issue that SWITCHDEV_FDB_ADD_TO_DEVICE events are
>    deferred by drivers even from code paths that are initially blocking
>    (are running in process context):
> 
> br_fdb_add
> -> __br_fdb_add
>    -> fdb_add_entry
>       -> fdb_notify
>          -> br_switchdev_fdb_notify
> 
>     It seems fairly trivial to move the fdb_notify call outside of the
>     atomic section of fdb_add_entry, but with switchdev offering only an
>     API where the SWITCHDEV_FDB_ADD_TO_DEVICE is atomic, drivers would
>     still have to defer these events and are unable to provide
>     synchronous feedback to user space (error codes, extack).
> 
> The above issues would warrant an attempt to fix a central problem, and
> make switchdev expose an API that is easier to consume rather than
> having drivers implement lateral workarounds.
> 
> In this case, we must notice that
> 
> (a) switchdev already has the concept of notifiers emitted from the fast
>     path that are still processed by drivers from blocking context. This
>     is accomplished through the SWITCHDEV_F_DEFER flag which is used by
>     e.g. SWITCHDEV_OBJ_ID_HOST_MDB.
> 
> (b) the bridge del_nbp() function already calls switchdev_deferred_process().
>     So if we could hook into that, we could have a chance that the
>     bridge simply waits for our FDB entry offloading procedure to finish
>     before it calls netdev_upper_dev_unlink() - which is almost
>     immediately afterwards, and also when switchdev drivers typically
>     break their stateful associations between the bridge upper and
>     private data.
> 
> So it is in fact possible to use switchdev's generic
> switchdev_deferred_enqueue mechanism to get a sleepable callback, and
> from there we can call_switchdev_blocking_notifiers().
> 
> To address all requirements:
> 
> - drivers that are unconverted from atomic to blocking still work
> - drivers that currently have a private workqueue are not worse off
> - drivers that want the bridge to wait for their deferred work can use
>   the bridge's defer mechanism
> - a SWITCHDEV_FDB_ADD_TO_DEVICE event which does not have any interested
>   parties does not get deferred for no reason, because this takes the
>   rtnl_mutex and schedules a worker thread for nothing
> 
> it looks like we can in fact start off by emitting
> SWITCHDEV_FDB_ADD_TO_DEVICE on the atomic chain. But we add a new bit in
> struct switchdev_notifier_fdb_info called "needs_defer", and any
> interested party can set this to true.
> 
> This way:
> 
> - unconverted drivers do their work (i.e. schedule their private work
>   item) based on the atomic notifier, and do not set "needs_defer"
> - converted drivers only mark "needs_defer" and treat a separate
>   notifier, on the blocking chain, called SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> - SWITCHDEV_FDB_ADD_TO_DEVICE events with no interested party do not
>   generate any follow-up SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> 
> Additionally, code paths that are blocking right not, like br_fdb_replay,
> could notify only SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED, as long as all
> consumers of the replayed FDB events support that (right now, that is
> DSA and dpaa2-switch).
> 
> Once all consumers of SWITCHDEV_FDB_ADD_TO_DEVICE are converted to set
> needs_defer as appropriate, then the notifiers emitted from process
> context by the bridge could call SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> directly, and we would also have fully blocking context all the way
> down, with the opportunity for error propagation and extack.

IIUC, at this stage all the FDB notifications drivers get are blocking,
either from the work queue (because they were deferred) or directly from
process context. If so, how do we synchronize the two and ensure drivers
get the notifications at the correct order?

I was thinking of adding all the notifications to the 'deferred' list
when 'hash_lock' is held and then calling switchdev_deferred_process()
directly in process context. It's not very pretty (do we return an error
only for the entry the user added or for any other entry we flushed from
the list?), but I don't have a better idea right now.

> 
> Some disadvantages of this solution though:
> 
> - A driver now needs to check whether it is interested in an event
>   twice: first on the atomic call chain, then again on the blocking call
>   chain (because it is a notifier chain, it is potentially not the only
>   driver subscribed to it, it may be listening to another driver's
>   needs_defer request). The flip side: on sistems with mixed switchdev
>   setups (dpaa2-switch + DSA, and DSA sniffs dynamically learned FDB
>   entries on foreign interfaces), there are some "synergies", and the
>   SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED event is only emitted once, as
>   opposed to what would happen if each driver scheduled its own private
>   work item.
> 
> - Right now drivers take rtnl_lock() as soon as their private work item
>   runs. They need the rtnl_lock for the call to
>   call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED). 

I think RCU is enough?

>   But it doesn't really seem necessary for them to perform the actual
>   hardware manipulation (adding the FDB entry) with the rtnl_lock held
>   (anyway most do that). But with the new option of servicing
>   SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED, the rtnl_lock is taken
>   top-level by switchdev, so even if these drivers wanted to be more
>   self-conscious, they couldn't.

Yes, I want to remove this dependency in mlxsw assuming notifications
remain atomic. The more pressing issue is actually removing it from the
learning path.
