Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2E43F494F
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbhHWLCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236835AbhHWLCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 07:02:19 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED15C06129E
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 04:00:51 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s3so13315738edd.11
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 04:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5/Ty8f+dp3W1PqWv6xshddPbyv9DYMg33/KCUQclvxg=;
        b=f0iHsuS9KnlrDQ2eTJwCnXhOq/P5ANAOzJ1Bhrq4TebXQVZwCOGDUJWQPxiHTX0o76
         52DD14g59Eq4q4zt1OD3BeucQzOdoWN/PG/tmnVzVYj7GVGaNvtAXLelP2ve3g09lYcP
         qB4jHShdKSgAZqXaUgeXfIgO1DHzXeg0DL53sZZEm+d2vYYWlyM9lzchbxvohV2qf3b3
         NFxRp2B1ROft4PwLpaB0wJ4tuDH5fmI/Ug8geqe0l1Z5HQ5HsIY4O8I409XWBdazrqzx
         Zad6LvxT/Ob5a/lW11lcKGVuZb8hEMk7ZTOUA4hRuMonnh8eCAiMYNFvkscciQBHZHH+
         ZzQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5/Ty8f+dp3W1PqWv6xshddPbyv9DYMg33/KCUQclvxg=;
        b=DWeOmyQSp1Kp6/9r+SjOuTiNiHPIBd4kxdaeUXnSl8spV6eOaf7OcOpdN+q9SN/qvB
         1C/iDWrW6neMtz+jU5ZVY9NcaPhKNdHUAWk4Hv3TodfK6yRGAFPXyz4MsqZ5MN9nEKCo
         1Mg58XedD6h04kKJJs3Y8m24glVVrZKUSNCRpPnj7ZXbrJrwkzlVugixYvggHyFHPQqY
         hFTAeLznxG9Ptoic0hxLsGUivgql58LOjrstnkLmqWz9aZYqacHscrARSQ+FSBwLEqzz
         QY5Th+f80GlWjUFD+E5dr7ki2hhxEyws14aRiQpTo69yuUoMP4TjyKxS3SwPTOFWRqJD
         keXg==
X-Gm-Message-State: AOAM530ns91Vn7r2d2qOUCkGgkhP8OwpIWZFqjDrMzkVtwzy2AMK7lon
        iT4l9KwSkcOZbcr6p15mr44=
X-Google-Smtp-Source: ABdhPJxOmn/5sL3EbrPrKgnOG4ma9DJU4/NmeBs30xhNuVQS4+3hfw1ckAf2dap2W5zbQZ+ocDzcmA==
X-Received: by 2002:aa7:c844:: with SMTP id g4mr3711976edt.37.1629716449708;
        Mon, 23 Aug 2021 04:00:49 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id ck17sm9035196edb.88.2021.08.23.04.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 04:00:49 -0700 (PDT)
Date:   Mon, 23 Aug 2021 14:00:46 +0300
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
Message-ID: <20210823110046.xuuo37kpsxdbl6c2@skbuf>
References: <20210820093723.qdvnvdqjda3m52v6@skbuf>
 <YR/TrkbhhN7QpRcQ@shredder>
 <20210820170639.rvzlh4b6agvrkv2w@skbuf>
 <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
 <YSHzLKpixhCrrgJ0@shredder>
 <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
 <20210822133145.jjgryhlkgk4av3c7@skbuf>
 <YSKD+DK4kavYJrRK@shredder>
 <20210822174449.nby7gmrjhwv3walp@skbuf>
 <YSN83d+wwLnba349@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSN83d+wwLnba349@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 01:47:57PM +0300, Ido Schimmel wrote:
> On Sun, Aug 22, 2021 at 08:44:49PM +0300, Vladimir Oltean wrote:
> > On Sun, Aug 22, 2021 at 08:06:00PM +0300, Ido Schimmel wrote:
> > > On Sun, Aug 22, 2021 at 04:31:45PM +0300, Vladimir Oltean wrote:
> > > > 3. There is a larger issue that SWITCHDEV_FDB_ADD_TO_DEVICE events are
> > > >    deferred by drivers even from code paths that are initially blocking
> > > >    (are running in process context):
> > > >
> > > > br_fdb_add
> > > > -> __br_fdb_add
> > > >    -> fdb_add_entry
> > > >       -> fdb_notify
> > > >          -> br_switchdev_fdb_notify
> > > >
> > > >     It seems fairly trivial to move the fdb_notify call outside of the
> > > >     atomic section of fdb_add_entry, but with switchdev offering only an
> > > >     API where the SWITCHDEV_FDB_ADD_TO_DEVICE is atomic, drivers would
> > > >     still have to defer these events and are unable to provide
> > > >     synchronous feedback to user space (error codes, extack).
> > > >
> > > > The above issues would warrant an attempt to fix a central problem, and
> > > > make switchdev expose an API that is easier to consume rather than
> > > > having drivers implement lateral workarounds.
> > > >
> > > > In this case, we must notice that
> > > >
> > > > (a) switchdev already has the concept of notifiers emitted from the fast
> > > >     path that are still processed by drivers from blocking context. This
> > > >     is accomplished through the SWITCHDEV_F_DEFER flag which is used by
> > > >     e.g. SWITCHDEV_OBJ_ID_HOST_MDB.
> > > >
> > > > (b) the bridge del_nbp() function already calls switchdev_deferred_process().
> > > >     So if we could hook into that, we could have a chance that the
> > > >     bridge simply waits for our FDB entry offloading procedure to finish
> > > >     before it calls netdev_upper_dev_unlink() - which is almost
> > > >     immediately afterwards, and also when switchdev drivers typically
> > > >     break their stateful associations between the bridge upper and
> > > >     private data.
> > > >
> > > > So it is in fact possible to use switchdev's generic
> > > > switchdev_deferred_enqueue mechanism to get a sleepable callback, and
> > > > from there we can call_switchdev_blocking_notifiers().
> > > >
> > > > To address all requirements:
> > > >
> > > > - drivers that are unconverted from atomic to blocking still work
> > > > - drivers that currently have a private workqueue are not worse off
> > > > - drivers that want the bridge to wait for their deferred work can use
> > > >   the bridge's defer mechanism
> > > > - a SWITCHDEV_FDB_ADD_TO_DEVICE event which does not have any interested
> > > >   parties does not get deferred for no reason, because this takes the
> > > >   rtnl_mutex and schedules a worker thread for nothing
> > > >
> > > > it looks like we can in fact start off by emitting
> > > > SWITCHDEV_FDB_ADD_TO_DEVICE on the atomic chain. But we add a new bit in
> > > > struct switchdev_notifier_fdb_info called "needs_defer", and any
> > > > interested party can set this to true.
> > > >
> > > > This way:
> > > >
> > > > - unconverted drivers do their work (i.e. schedule their private work
> > > >   item) based on the atomic notifier, and do not set "needs_defer"
> > > > - converted drivers only mark "needs_defer" and treat a separate
> > > >   notifier, on the blocking chain, called SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > > > - SWITCHDEV_FDB_ADD_TO_DEVICE events with no interested party do not
> > > >   generate any follow-up SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > > >
> > > > Additionally, code paths that are blocking right not, like br_fdb_replay,
> > > > could notify only SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED, as long as all
> > > > consumers of the replayed FDB events support that (right now, that is
> > > > DSA and dpaa2-switch).
> > > >
> > > > Once all consumers of SWITCHDEV_FDB_ADD_TO_DEVICE are converted to set
> > > > needs_defer as appropriate, then the notifiers emitted from process
> > > > context by the bridge could call SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> > > > directly, and we would also have fully blocking context all the way
> > > > down, with the opportunity for error propagation and extack.
> > >
> > > IIUC, at this stage all the FDB notifications drivers get are blocking,
> > > either from the work queue (because they were deferred) or directly from
> > > process context. If so, how do we synchronize the two and ensure drivers
> > > get the notifications at the correct order?
> >
> > What does 'at this stage' mean? Does it mean 'assuming the patch we're
> > discussing now gets accepted'? If that's what it means, then 'at this
> > stage' all drivers would first receive the atomic FDB_ADD_TO_DEVICE,
> > then would set needs_defer, then would receive the blocking
> > FDB_ADD_TO_DEVICE.
>
> I meant after:
>
> "Once all consumers of SWITCHDEV_FDB_ADD_TO_DEVICE are converted to set
> needs_defer as appropriate, then the notifiers emitted from process
> context by the bridge could call SWITCHDEV_FDB_ADD_TO_DEVICE_DEFERRED
> directly, and we would also have fully blocking context all the way
> down, with the opportunity for error propagation and extack."
>
> IIUC, after the conversion the 'needs_defer' is gone and all the FDB
> events are blocking? Either from syscall context or the workqueue.

We would not delete 'needs_defer'. It still offers a useful preliminary
filtering mechanism for the fast path (and for br_fdb_replay). In
retrospect, the SWITCHDEV_OBJ_ID_HOST_MDB would also benefit from 'needs_defer'
instead of jumping to blocking context (if we care so much about performance).

If a FDB event does not need to be processed by anyone (dynamically
learned entry on a switchdev port), the bridge notifies the atomic call
chain for the sake of it, but not the blocking chain.

> If so, I'm not sure how we synchronize the two. That is, making sure
> that an event from syscall context does not reach drivers before an
> earlier event that was added to the 'deferred' list.
>
> I mean, in syscall context we are holding RTNL so whatever is already on
> the 'deferred' list cannot be dequeued and processed.

So switchdev_deferred_process() has ASSERT_RTNL. If we call
switchdev_deferred_process() right before adding the blocking FDB entry
in process context (and we already hold rtnl_mutex), I though that would
be enough to ensure we have a synchronization point: Everything that was
scheduled before is flushed now, everything that is scheduled while we
are running will run after we unlock the rtnl_mutex. Is that not the
order we expect? I mean, if there is a fast path FDB entry being learned
/ deleted while user space say adds that same FDB entry as static, how
is the relative ordering ensured between the two?
