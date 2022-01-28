Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFE549F0ED
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345311AbiA1CZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345221AbiA1CZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:25:08 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7DDC06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:25:07 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id c6so14371078ybk.3
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ATmoHVlBD0VCiYLSkpSLZVx9DF3vSOsZcS/Gfn721cA=;
        b=oSHYThw9nT7Vj4MU4wqq1Lyk75UxanwpaOwc1jAdOh1MesFRpel8FcElAMjOXqtnRQ
         Ru5mdwbD3b2Z3mXris1Iq/XAvaeOOR6YBdiFvS3C+86wsOu/GWVw2aWUW6OmzexJ7tN7
         eC+2GfHlzSsqjNVU6xY3S6FMZglSY98pENs+2qR+wwnd9ircS9EmkvScbjjBd15itZHv
         mDCMWsuvLyM40jOAiqc9O0QAKKVcIvyXQeYEyyL0WLz/L69RdRsw1XIZ6H2iSBsVM2Wr
         nNrhqm8Rlxs9a64AaKF1kBsyYcAz0Ke6joKTXJwHCpFCHUbXcmOHWulGKsC4WMj5HXNE
         RH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ATmoHVlBD0VCiYLSkpSLZVx9DF3vSOsZcS/Gfn721cA=;
        b=iS3Q561jJgoDx1xa9yseRc9wJYfqYW23U7vVsGqwsE/mv+KXxN+4aH+AIHZTdHL1qo
         JdmtBh8Ck97Yka7R/ZNiYh9hWvHhT8Q7G8cITtAaAI0YZxPx3IJ8+VqUG/fV3bWJqzxU
         zeP2IViKYhHWxtWJRJTjfcLIUHwZx2K8dlTNF6iaYckzciTDwQeIlRKNuTHq/N7gsetg
         ksAqUBjI4ZUj6mJlR78QjOJO9v3XTGCGyYlCaRQeFB8AAJjjnHaYDj3qWYlS+ArwwNp3
         FHgoIGFyXY+36STXFuEbfBhgL3QPFFwsjPXogvyEujBtrZdOv3AIT1oXf6kKsovcbQGf
         l07g==
X-Gm-Message-State: AOAM5320spyDt3yC1Swlq/VbJ5vA7/n9ExcVvyH+hjAs15anmq0TWCy/
        JVsdOVFp0GZsEvivt60AOUuMaOFWQLFArEDf0bOPXaWOTHXAEw==
X-Google-Smtp-Source: ABdhPJwUFE2YIXZKQUv8AVXKckyZT+MlKPPVqlfWSkGSqfj0HPTfbCIjBswEtQ/s1Xf6Vc+OHfasvFP0qHeWvi47VG8=
X-Received: by 2002:a25:4f41:: with SMTP id d62mr9986485ybb.156.1643336706558;
 Thu, 27 Jan 2022 18:25:06 -0800 (PST)
MIME-Version: 1.0
References: <20220128014303.2334568-1-jannh@google.com> <CANn89iKWaERfs1iW8jVyRZT8K1LwWM9efiRsx8E1U3CDT39dyw@mail.gmail.com>
 <CAG48ez0sXEjePefCthFdhDskCFhgcnrecEn2jFfteaqa2qwDnQ@mail.gmail.com>
In-Reply-To: <CAG48ez0sXEjePefCthFdhDskCFhgcnrecEn2jFfteaqa2qwDnQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Jan 2022 18:24:55 -0800
Message-ID: <CANn89iKmCYq+WBu_S4OvKOXqRSagTg=t8xKq0WC_Rrw+TpKsbw@mail.gmail.com>
Subject: Re: [PATCH net] net: dev: Detect dev_hold() after netdev_wait_allrefs()
To:     Jann Horn <jannh@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 6:14 PM Jann Horn <jannh@google.com> wrote:
>
> On Fri, Jan 28, 2022 at 3:09 AM Eric Dumazet <edumazet@google.com> wrote:
> > On Thu, Jan 27, 2022 at 5:43 PM Jann Horn <jannh@google.com> wrote:
> > >
> > > I've run into a bug where dev_hold() was being called after
> > > netdev_wait_allrefs(). But at that point, the device is already going
> > > away, and dev_hold() can't stop that anymore.
> > >
> > > To make such problems easier to diagnose in the future:
> > >
> > >  - For CONFIG_PCPU_DEV_REFCNT builds: Recheck in free_netdev() whether
> > >    the net refcount has been elevated. If this is detected, WARN() and
> > >    leak the object (to prevent worse consequences from a
> > >    use-after-free).
> > >  - For builds without CONFIG_PCPU_DEV_REFCNT: Set the refcount to zero.
> > >    This signals to the generic refcount infrastructure that any attempt
> > >    to increment the refcount later is a bug.
> > >
> > > Signed-off-by: Jann Horn <jannh@google.com>
> > > ---
> > >  net/core/dev.c | 18 +++++++++++++++++-
> > >  1 file changed, 17 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 1baab07820f6..f7916c0d226d 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -9949,8 +9949,18 @@ void netdev_run_todo(void)
> > >
> > >                 netdev_wait_allrefs(dev);
> > >
> > > +               /* Drop the netdev refcount (which should be 1 at this point)
> > > +                * to zero. If we're using the generic refcount code, this will
> > > +                * tell it that any dev_hold() after this point is a bug.
> > > +                */
> > > +#ifdef CONFIG_PCPU_DEV_REFCNT
> > > +               this_cpu_dec(*dev->pcpu_refcnt);
> > > +               BUG_ON(netdev_refcnt_read(dev) != 0);
> > > +#else
> > > +               BUG_ON(!refcount_dec_and_test(&dev->dev_refcnt));
> > > +#endif
> > > +
> > >                 /* paranoia */
> > > -               BUG_ON(netdev_refcnt_read(dev) != 1);
> > >                 BUG_ON(!list_empty(&dev->ptype_all));
> > >                 BUG_ON(!list_empty(&dev->ptype_specific));
> > >                 WARN_ON(rcu_access_pointer(dev->ip_ptr));
> > > @@ -10293,6 +10303,12 @@ void free_netdev(struct net_device *dev)
> > >         free_percpu(dev->xdp_bulkq);
> > >         dev->xdp_bulkq = NULL;
> > >
> > > +       /* Recheck in case someone called dev_hold() between
> > > +        * netdev_wait_allrefs() and here.
> > > +        */
> >
> > At this point, dev->pcpu_refcnt per-cpu data has been freed already
> > (CONFIG_PCPU_DEV_REFCNT=y)
> >
> > So this should probably crash, or at least UAF ?
>
> Oh. Whoops. That's what I get for only testing without CONFIG_PCPU_DEV_REFCNT...
>
> I guess a better place to put the new check would be directly after
> checking for "dev->reg_state == NETREG_UNREGISTERING"? Like this?
>
>         if (dev->reg_state == NETREG_UNREGISTERING) {
>                 ASSERT_RTNL();
>                 dev->needs_free_netdev = true;
>                 return;
>         }
>
>         /* Recheck in case someone called dev_hold() between
>          * netdev_wait_allrefs() and here.
>          */
>         if (WARN_ON(netdev_refcnt_read(dev) != 0))
>                 return; /* leak memory, otherwise we might get UAF */
>
>         netif_free_tx_queues(dev);
>         netif_free_rx_queues(dev);

Maybe another solution would be to leverage the recent dev_hold_track().

We could add a  dead boolean to 'struct  ref_tracker_dir ' (dev->refcnt_tracker)

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
index c11c9db5825cf933acf529c83db441a818135f29..d907759b2fa1dd6b2ef22f883d55963c410dc71b
100644
--- a/include/linux/ref_tracker.h
+++ b/include/linux/ref_tracker.h
@@ -12,6 +12,7 @@ struct ref_tracker_dir {
        spinlock_t              lock;
        unsigned int            quarantine_avail;
        refcount_t              untracked;
+       bool                    dead;
        struct list_head        list; /* List of active trackers */
        struct list_head        quarantine; /* List of dead trackers */
 #endif
@@ -24,6 +25,7 @@ static inline void ref_tracker_dir_init(struct
ref_tracker_dir *dir,
        INIT_LIST_HEAD(&dir->list);
        INIT_LIST_HEAD(&dir->quarantine);
        spin_lock_init(&dir->lock);
+       dir->dead = false;
        dir->quarantine_avail = quarantine_count;
        refcount_set(&dir->untracked, 1);
 }
diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index a6789c0c626b0f68ad67c264cd19177a63fb82d2..cbc798e5b97674a389ea3bbf17d9bb39fbf63328
100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -20,6 +20,7 @@ void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
        unsigned long flags;
        bool leak = false;

+       dir->dead = true;
        spin_lock_irqsave(&dir->lock, flags);
        list_for_each_entry_safe(tracker, n, &dir->quarantine, head) {
                list_del(&tracker->head);
@@ -72,6 +73,8 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
        gfp_t gfp_mask = gfp;
        unsigned long flags;

+       WARN_ON_ONCE(dir->dead);
+
        if (gfp & __GFP_DIRECT_RECLAIM)
                gfp_mask |= __GFP_NOFAIL;
        *trackerp = tracker = kzalloc(sizeof(*tracker), gfp_mask);
