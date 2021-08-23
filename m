Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E653F4DB2
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 17:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhHWPnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 11:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhHWPnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 11:43:32 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF39DC061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 08:42:49 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s25so14147292edw.0
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 08:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mSUVJorn3ajyajnBl7ashP7dbpSJWBiU6/Ze/xxTFzo=;
        b=ha94Hyqt1JUL1oXarWXz5rM+Zm/vC4Q85DgtY22B1CQR8xlYxFWp0ja8MgTQ3UvI0x
         Gj+SXt8WCYg3V1J8+3r0vnqUOBGshMBLkN5MFhmLTYahM/CdihEYyrF2+NEmMEulG1Ki
         mqqpmN8J0vfRoJPZn7Ri68hFU2B9LlyuEqm1Wtm0L9MOiv5cjtHtKQ8NdPgQ6BF48RRo
         qlZyt1XQ0r2xYsuz/aN8V51BMKky8H0tp2UZpWpLZZ2k1aPFhqoEIH7XQb+to7KuytKK
         kmuzkYYQbc40CgGH8iHAHQkYWP1Gf3kNlHim6pVsV5I650auEsUxL/Mci4f3DTt1/TAU
         wPgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mSUVJorn3ajyajnBl7ashP7dbpSJWBiU6/Ze/xxTFzo=;
        b=WiRYlroUTMjA7FB7VVkt17q/9Ve4uAwYG7XuQhCEMOEiaf44l4eWm2U7vtsXcbLdMS
         7chqfVQejsBhvLubZ11Lmwlwg2YM6RiKi2N3B4B6PJAGIf2MXJJkbrZt+RoQwZjqBcz2
         I9t4ROy7PMpz5gc/1+5+fZvc7Fv1P5FEJfzvOUS0NRranDmRZkbDr98awjLYuVKO1eKm
         Qu15RVMam2nwEofeE4ft601B1IuL6yhPsqC2kQ8j8taaUBxpq6WS8+YdoqjZbjjd3zxX
         bOshh01YPObDbX0Zqy1akgzj4M9cOcVl+HcmWtdmFqcklCPgCrhzoMIHDKmeXi8WJObM
         lL4g==
X-Gm-Message-State: AOAM531wAui1K5rILS4EsnKFDHWEiEl1Pvyq2AsxH7+3OttauGxFBHhe
        xfYebMYt02VaaJm6EtTfLkk=
X-Google-Smtp-Source: ABdhPJxi74ZL6D97IYVvPvWbNb6A/VnkgePFBPRhORxMjqg3Z+mfxtnQ0xfHSqN89GYyeywKnWREzA==
X-Received: by 2002:aa7:c487:: with SMTP id m7mr18472822edq.62.1629733367588;
        Mon, 23 Aug 2021 08:42:47 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id m13sm57354edp.53.2021.08.23.08.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 08:42:47 -0700 (PDT)
Date:   Mon, 23 Aug 2021 18:42:44 +0300
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
Message-ID: <20210823154244.4a53faquqrljov7g@skbuf>
References: <YSHzLKpixhCrrgJ0@shredder>
 <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
 <20210822133145.jjgryhlkgk4av3c7@skbuf>
 <YSKD+DK4kavYJrRK@shredder>
 <20210822174449.nby7gmrjhwv3walp@skbuf>
 <YSN83d+wwLnba349@shredder>
 <20210823110046.xuuo37kpsxdbl6c2@skbuf>
 <YSORsKDOwklF19Gm@shredder>
 <20210823142953.gwapkdvwfgdvfrys@skbuf>
 <YSO8MK5Alv0yF9pr@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSO8MK5Alv0yF9pr@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 06:18:08PM +0300, Ido Schimmel wrote:
> On Mon, Aug 23, 2021 at 05:29:53PM +0300, Vladimir Oltean wrote:
> > On Mon, Aug 23, 2021 at 03:16:48PM +0300, Ido Schimmel wrote:
> > > I was thinking about the following case:
> > >
> > > t0 - <MAC1,VID1,P1> is added in syscall context under 'hash_lock'
> > > t1 - br_fdb_delete_by_port() flushes entries under 'hash_lock' in
> > >      response to STP state. Notifications are added to 'deferred' list
> > > t2 - switchdev_deferred_process() is called in syscall context
> > > t3 - <MAC1,VID1,P1> is notified as blocking
> > >
> > > Updates to the SW FDB are protected by 'hash_lock', but updates to the
> > > HW FDB are not. In this case, <MAC1,VID1,P1> does not exist in SW, but
> > > it will exist in HW.
> > >
> > > Another case assuming switchdev_deferred_process() is called first:
> > >
> > > t0 - switchdev_deferred_process() is called in syscall context
> > > t1 - <MAC1,VID,P1> is learned under 'hash_lock'. Notification is added
> > >      to 'deferred' list
> > > t2 - <MAC1,VID1,P1> is modified in syscall context under 'hash_lock' to
> > >      <MAC1,VID1,P2>
> > > t3 - <MAC1,VID1,P2> is notified as blocking
> > > t4 - <MAC1,VID1,P1> is notified as blocking (next time the 'deferred'
> > >      list is processed)
> > >
> > > In this case, the HW will have <MAC1,VID1,P1>, but SW will have
> > > <MAC1,VID1,P2>
> >
> > Ok, so if the hardware FDB entry needs to be updated under the same
> > hash_lock as the software FDB entry, then it seems that the goal of
> > updating the hardware FDB synchronously and in a sleepable manner is if
> > the data path defers the learning to sleepable context too. That in turn
> > means that there will be 'dead time' between the reception of a packet
> > from a given {MAC SA, VID} flow and the learning of that address. So I
> > don't think that is really desirable. So I don't know if it is actually
> > realistic to do this.
> >
> > Can we drop it from the requirements of this change, or do you feel like
> > it's not worth it to make my change if this problem is not solved?
>
> I didn't pose it as a requirement, but as a desirable goal that I don't
> know how to achieve w/o a surgery in the bridge driver that Nik and you
> (understandably) don't like.
>
> Regarding a more practical solution, earlier versions (not what you
> posted yesterday) have the undesirable properties of being both
> asynchronous (current state) and mandating RTNL to be held. If we are
> going with the asynchronous model, then I think we should have a model
> that doesn't force RTNL and allows batching.
>
> I have the following proposal, which I believe solves your problem and
> allows for batching without RTNL:
>
> The pattern of enqueuing a work item per-entry is not very smart.
> Instead, it is better to to add the notification info to a list
> (protected by a spin lock) and scheduling a single work item whose
> purpose is to dequeue entries from this list and batch process them.

I don't have hardware where FDB entries can be installed in bulk, so
this is new to me. Might make sense though where you are in fact talking
to firmware, and the firmware is in fact still committing to hardware
one by one, you are still reducing the number of round trips.

> Inside the work item you would do something like:
>
> spin_lock_bh()
> list_splice_init()
> spin_unlock_bh()
>
> mutex_lock() // rtnl or preferably private lock
> list_for_each_entry_safe()
> 	// process entry
> 	cond_resched()
> mutex_unlock()

When is the work item scheduled in your proposal? I assume not only when
SWITCHDEV_FDB_FLUSH_TO_DEVICE is emitted. Is there some sort of timer to
allow for some batching to occur?

>
> In del_nbp(), after br_fdb_delete_by_port(), the bridge will emit some
> new blocking event (e.g., SWITCHDEV_FDB_FLUSH_TO_DEVICE) that will
> instruct the driver to flush all its pending FDB notifications. You
> don't strictly need this notification because of the
> netdev_upper_dev_unlink() that follows, but it helps in making things
> more structured.
>
> Pros:
>
> 1. Solves your problem?
> 2. Pattern is not worse than what we currently have
> 3. Does not force RTNL
> 4. Allows for batching. For example, mlxsw has the ability to program up
> to 64 entries in one transaction with the device. I assume other devices
> in the same grade have similar capabilities
>
> Cons:
>
> 1. Asynchronous
> 2. Pattern we will see in multiple drivers? Can consider migrating it
> into switchdev itself at some point

I can already flush_workqueue(dsa_owq) in dsa_port_pre_bridge_leave()
and this will solve the problem in the same way, will it not?

It's not that I don't have driver-level solutions and hook points.
My concern is that there are way too many moving parts and the entrance
barrier for a new switchdev driver is getting higher and higher to
achieve even basic stuff.

For example, I need to maintain a DSA driver and a switchdev driver for
the exact same class of hardware (ocelot is switchdev, felix is DSA, but
the hardware is the same) and it is just so annoying that the interaction
with switchdev is so verbose and open-coded, it just leads to so much
duplication of basic patterns.
When I add support for SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE in ocelot I
really don't want to add a boatload of code, all copied from DSA.

> 3. Something I missed / overlooked
>
> > There is of course the option of going half-way too, just like for
> > SWITCHDEV_PORT_ATTR_SET. You notify it once, synchronously, on the
> > atomic chain, the switchdev throws as many errors as it can reasonably
> > can, then you defer the actual installation which means a hardware access.
>
> Yes, the above proposal has the same property. You can throw errors
> before enqueueing the notification info on your list.
