Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9BE3F4D3A
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 17:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhHWPTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 11:19:01 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:47807 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231156AbhHWPTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 11:19:00 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 960CA580444;
        Mon, 23 Aug 2021 11:18:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 23 Aug 2021 11:18:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Th+p3j
        80jGU+vkJZXThKQiI8s7/k5zmaONtsQrlZ2EY=; b=q6GtIDdsaf5daTcUij0yUf
        eSaG3R3Nan/FqPKzxlZFnZSsX/+Y3+eIF+fApP4njNH0i+gvyreh4aW13KWLleQ5
        3D0P1C1wzWlhuoEUi5aRS0RtGRu8V3PDX+qky4tvVwcrOHifwyyq7SsNSTkxJD18
        +EeLn9QLzQ/9GnMo96TtoYN+b/j3TEfskRi9cVJrgi+UfEs3g73QYaHZIbUlCCbV
        5yrnA5nTYfOmNSEDi9ey8YX6l605ZWdNrPxQ1zHUaNdzctX7RiPhO7vg9+CwCW8Q
        rBe5yFhbfrWKvQjDjYlCKZTIF4smKrX3Xdw++wZ8LcCpEr2Z+0CjChgdKUtSQ6mg
        ==
X-ME-Sender: <xms:NbwjYZYBImVXGMqIpIDlr56lekOEYIVu0lS8tNtdrjQS6d3Pgt8iMg>
    <xme:NbwjYQaNJW_wFIVtPhm1Vta3muBw_0Y1gTQwhoZNisbXiiR7VFDMWtF7QKn18vwPE
    rfJMzYs4QMrPjc>
X-ME-Received: <xmr:NbwjYb_HmDzN0IdLLb8PbRtpM3PrRUgh2RHn6pUBYYkYRluN9PMdAT10mGKkKP88CEC77bRjY4qL7KjJvv_0wQQfwMNKjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddthedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:NbwjYXoSehtCkKOOlBnPoShKjqY8OtkRDLb9WkMQBj3wD1vgm3zcww>
    <xmx:NbwjYUo-T3DtPm-XN5pO2D0HKtj1hL-FQT41_IUX8AgRHNh_FaWDlg>
    <xmx:NbwjYdSd0hwYMTUpysoL2taHh_oRT5DqNNzvhvkOEiPpNIMz296O8g>
    <xmx:ObwjYVrVTM7vzwULPYuzrDSWyHKRQWVLtWc4FP3X-HVcn6QAzqt7QA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Aug 2021 11:18:12 -0400 (EDT)
Date:   Mon, 23 Aug 2021 18:18:08 +0300
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
Message-ID: <YSO8MK5Alv0yF9pr@shredder>
References: <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
 <YSHzLKpixhCrrgJ0@shredder>
 <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
 <20210822133145.jjgryhlkgk4av3c7@skbuf>
 <YSKD+DK4kavYJrRK@shredder>
 <20210822174449.nby7gmrjhwv3walp@skbuf>
 <YSN83d+wwLnba349@shredder>
 <20210823110046.xuuo37kpsxdbl6c2@skbuf>
 <YSORsKDOwklF19Gm@shredder>
 <20210823142953.gwapkdvwfgdvfrys@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823142953.gwapkdvwfgdvfrys@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 05:29:53PM +0300, Vladimir Oltean wrote:
> On Mon, Aug 23, 2021 at 03:16:48PM +0300, Ido Schimmel wrote:
> > I was thinking about the following case:
> >
> > t0 - <MAC1,VID1,P1> is added in syscall context under 'hash_lock'
> > t1 - br_fdb_delete_by_port() flushes entries under 'hash_lock' in
> >      response to STP state. Notifications are added to 'deferred' list
> > t2 - switchdev_deferred_process() is called in syscall context
> > t3 - <MAC1,VID1,P1> is notified as blocking
> >
> > Updates to the SW FDB are protected by 'hash_lock', but updates to the
> > HW FDB are not. In this case, <MAC1,VID1,P1> does not exist in SW, but
> > it will exist in HW.
> >
> > Another case assuming switchdev_deferred_process() is called first:
> >
> > t0 - switchdev_deferred_process() is called in syscall context
> > t1 - <MAC1,VID,P1> is learned under 'hash_lock'. Notification is added
> >      to 'deferred' list
> > t2 - <MAC1,VID1,P1> is modified in syscall context under 'hash_lock' to
> >      <MAC1,VID1,P2>
> > t3 - <MAC1,VID1,P2> is notified as blocking
> > t4 - <MAC1,VID1,P1> is notified as blocking (next time the 'deferred'
> >      list is processed)
> >
> > In this case, the HW will have <MAC1,VID1,P1>, but SW will have
> > <MAC1,VID1,P2>
> 
> Ok, so if the hardware FDB entry needs to be updated under the same
> hash_lock as the software FDB entry, then it seems that the goal of
> updating the hardware FDB synchronously and in a sleepable manner is if
> the data path defers the learning to sleepable context too. That in turn
> means that there will be 'dead time' between the reception of a packet
> from a given {MAC SA, VID} flow and the learning of that address. So I
> don't think that is really desirable. So I don't know if it is actually
> realistic to do this.
> 
> Can we drop it from the requirements of this change, or do you feel like
> it's not worth it to make my change if this problem is not solved?

I didn't pose it as a requirement, but as a desirable goal that I don't
know how to achieve w/o a surgery in the bridge driver that Nik and you
(understandably) don't like.

Regarding a more practical solution, earlier versions (not what you
posted yesterday) have the undesirable properties of being both
asynchronous (current state) and mandating RTNL to be held. If we are
going with the asynchronous model, then I think we should have a model
that doesn't force RTNL and allows batching.

I have the following proposal, which I believe solves your problem and
allows for batching without RTNL:

The pattern of enqueuing a work item per-entry is not very smart.
Instead, it is better to to add the notification info to a list
(protected by a spin lock) and scheduling a single work item whose
purpose is to dequeue entries from this list and batch process them.

Inside the work item you would do something like:

spin_lock_bh()
list_splice_init()
spin_unlock_bh()

mutex_lock() // rtnl or preferably private lock
list_for_each_entry_safe() 
	// process entry
	cond_resched()
mutex_unlock()

In del_nbp(), after br_fdb_delete_by_port(), the bridge will emit some
new blocking event (e.g., SWITCHDEV_FDB_FLUSH_TO_DEVICE) that will
instruct the driver to flush all its pending FDB notifications. You
don't strictly need this notification because of the
netdev_upper_dev_unlink() that follows, but it helps in making things
more structured.

Pros:

1. Solves your problem?
2. Pattern is not worse than what we currently have
3. Does not force RTNL
4. Allows for batching. For example, mlxsw has the ability to program up
to 64 entries in one transaction with the device. I assume other devices
in the same grade have similar capabilities

Cons:

1. Asynchronous
2. Pattern we will see in multiple drivers? Can consider migrating it
into switchdev itself at some point
3. Something I missed / overlooked

> There is of course the option of going half-way too, just like for
> SWITCHDEV_PORT_ATTR_SET. You notify it once, synchronously, on the
> atomic chain, the switchdev throws as many errors as it can reasonably
> can, then you defer the actual installation which means a hardware access.

Yes, the above proposal has the same property. You can throw errors
before enqueueing the notification info on your list.
