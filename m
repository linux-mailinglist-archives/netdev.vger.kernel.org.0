Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C4A48EB51
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241349AbiANOLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbiANOLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 09:11:23 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C672FC061574;
        Fri, 14 Jan 2022 06:11:23 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id s21-20020a05683004d500b0058f585672efso10181230otd.3;
        Fri, 14 Jan 2022 06:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OqXp6FSmKgc0z6i7RF/QS3rpMyZYN1W7IG808LQ9N7g=;
        b=gZaPmLRpt5ADuKS7BrKvgrydE5soqbsKLQY3ANO2ylDCn8hPVS94CgkQ+/sIgCC8km
         xXHgKXZ+NYyQvrWR3R52TIxynmtpJ9/A+suqV/3Dbm7R+fRj+gOWG8V4P7z5wAaPJYWa
         95oDc2hWUIBtYlwELQUX7ORvJXjqoCFaEJRwzeL/MCrLWTu3MbGuQgUJr9arA4+PdRpm
         NWkOeDJrJNt22BCseVQwQkZn3Z/yBTgiBfBJ7if9Ixy8+iiWLLRTrzCqq8qvFzd5l31c
         qaVr71sDP3AlIjTUJIvAVWRDfCAJSgL/A06uf16BfdHCXpAxTDrFdT79Pgqk/JrFAPh8
         Lo2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OqXp6FSmKgc0z6i7RF/QS3rpMyZYN1W7IG808LQ9N7g=;
        b=DFrQppwp/xchFZ+RcT852eGlL8DOpWcl1ueUP8haO8FgzDFE6h2VccEfDHgm6yOhOa
         Hc60qNMZNMvK4baKTNvC8i437dA7YY4vs1gtHhkpGWzStGIWeE1DasfoV/JEREnHVeE3
         6+JpDwtIMUHOhxaMMqUOA2PfRPhzhmd0tdqzbHyr3QeeJtFOHLB4+ytFdx/XO7o3cuzq
         IEGG/coXAuGKzzDXrgYXsSuZ9kNg+qcd8I9bh74j27vwPcXizEOrgP8i1/XzADNZ4O9a
         coiypi2/EIghnOcSDJclXboyOdX8I1lZEMkgbuImUVcSEWrzHWAi7g4HlmKAPZ7HkkAq
         tCVw==
X-Gm-Message-State: AOAM532+T3yUHIK9ZWFgTYw5Vbmf1duuJF8yq6P7RzVjLswR6ASZYbFJ
        h0KKKrM0eQlUf4s2VwfPbgIHrqUmn+K7D7Uxi2G6PZoJIig=
X-Google-Smtp-Source: ABdhPJy34Tl2qE9uJ+ibg4eyDIERWFifKWzw1SWvcwQhwEDzHsAOW4JXud5UAzIq2Ohcy2T8eE1pP4WKWbZFAoPZa4g=
X-Received: by 2002:a05:6830:802:: with SMTP id r2mr309167ots.298.1642169482975;
 Fri, 14 Jan 2022 06:11:22 -0800 (PST)
MIME-Version: 1.0
References: <388098b2c03fbf0a732834fc01b2d875c335bc49.1642169368.git.lucien.xin@gmail.com>
In-Reply-To: <388098b2c03fbf0a732834fc01b2d875c335bc49.1642169368.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 14 Jan 2022 22:11:10 +0800
Message-ID: <CADvbK_dgYbutQ-Ormpgk0qPuZi8c8oTHmN_rxoiYAbgCvCAO7g@mail.gmail.com>
Subject: Re: [PATCH net] mm: slub: fix a deadlock warning in kmem_cache_destroy
To:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sorry, please drop this, it's in the wrong mail-list.

On Fri, Jan 14, 2022 at 10:09 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> cpus_read_lock() is introduced into kmem_cache_destroy() by
> commit 5a836bf6b09f ("mm: slub: move flush_cpu_slab() invocations
> __free_slab() invocations out of IRQ context"), and it could cause
> a deadlock.
>
> As Antoine pointed out, when one thread calls kmem_cache_destroy(), it is
> blocking until kn->active becomes 0 in kernfs_drain() after holding
> cpu_hotplug_lock. While in another thread, when calling kernfs_fop_write(),
> it may try to hold cpu_hotplug_lock after incrementing kn->active by
> calling kernfs_get_active():
>
>         CPU0                        CPU1
>         ----                        ----
>   cpus_read_lock()
>                                    kn->active++
>                                    cpus_read_lock() [a]
>   wait until kn->active == 0
>
> Although cpu_hotplug_lock is a RWSEM, [a] will not block in there. But as
> lockdep annotations are added for cpu_hotplug_lock, a deadlock warning
> would be detected:
>
>   ======================================================
>   WARNING: possible circular locking dependency detected
>   ------------------------------------------------------
>   dmsetup/1832 is trying to acquire lock:
>   ffff986f5a0f9f20 (kn->count#144){++++}-{0:0}, at: kernfs_remove+0x1d/0x30
>
>   but task is already holding lock:
>   ffffffffa43817c0 (slab_mutex){+.+.}-{3:3}, at: kmem_cache_destroy+0x2a/0x120
>
>   which lock already depends on the new lock.
>
>   the existing dependency chain (in reverse order) is:
>
>   -> #2 (slab_mutex){+.+.}-{3:3}:
>          lock_acquire+0xe8/0x470
>          mutex_lock_nested+0x47/0x80
>          kmem_cache_destroy+0x2a/0x120
>          bioset_exit+0xb5/0x100
>          cleanup_mapped_device+0x26/0xf0 [dm_mod]
>          free_dev+0x43/0xb0 [dm_mod]
>          __dm_destroy+0x153/0x1b0 [dm_mod]
>          dev_remove+0xe4/0x1a0 [dm_mod]
>          ctl_ioctl+0x1af/0x3f0 [dm_mod]
>          dm_ctl_ioctl+0xa/0x10 [dm_mod]
>          do_vfs_ioctl+0xa5/0x760
>          ksys_ioctl+0x60/0x90
>          __x64_sys_ioctl+0x16/0x20
>          do_syscall_64+0x8c/0x240
>          entry_SYSCALL_64_after_hwframe+0x6a/0xdf
>
>   -> #1 (cpu_hotplug_lock){++++}-{0:0}:
>          lock_acquire+0xe8/0x470
>          cpus_read_lock+0x39/0x100
>          cpu_partial_store+0x44/0x80
>          slab_attr_store+0x20/0x30
>          kernfs_fop_write+0x101/0x1b0
>          vfs_write+0xd4/0x1e0
>          ksys_write+0x52/0xc0
>          do_syscall_64+0x8c/0x240
>          entry_SYSCALL_64_after_hwframe+0x6a/0xdf
>
>   -> #0 (kn->count#144){++++}-{0:0}:
>          check_prevs_add+0x185/0xb80
>          __lock_acquire+0xd8f/0xe90
>          lock_acquire+0xe8/0x470
>          __kernfs_remove+0x25e/0x320
>          kernfs_remove+0x1d/0x30
>          kobject_del+0x28/0x60
>          kmem_cache_destroy+0xf1/0x120
>          bioset_exit+0xb5/0x100
>          cleanup_mapped_device+0x26/0xf0 [dm_mod]
>          free_dev+0x43/0xb0 [dm_mod]
>          __dm_destroy+0x153/0x1b0 [dm_mod]
>          dev_remove+0xe4/0x1a0 [dm_mod]
>          ctl_ioctl+0x1af/0x3f0 [dm_mod]
>          dm_ctl_ioctl+0xa/0x10 [dm_mod]
>          do_vfs_ioctl+0xa5/0x760
>          ksys_ioctl+0x60/0x90
>          __x64_sys_ioctl+0x16/0x20
>          do_syscall_64+0x8c/0x240
>          entry_SYSCALL_64_after_hwframe+0x6a/0xdf
>
>   other info that might help us debug this:
>
>   Chain exists of:
>     kn->count#144 --> cpu_hotplug_lock --> slab_mutex
>
>    Possible unsafe locking scenario:
>
>          CPU0                    CPU1
>          ----                    ----
>     lock(slab_mutex);
>                                  lock(cpu_hotplug_lock);
>                                  lock(slab_mutex);
>     lock(kn->count#144);
>
>    *** DEADLOCK ***
>
>   3 locks held by dmsetup/1832:
>    #0: ffffffffa43fe5c0 (bio_slab_lock){+.+.}-{3:3}, at: bioset_exit+0x62/0x100
>    #1: ffffffffa3e87c20 (cpu_hotplug_lock){++++}-{0:0}, at: kmem_cache_destroy+0x1c/0x120
>    #2: ffffffffa43817c0 (slab_mutex){+.+.}-{3:3}, at: kmem_cache_destroy+0x2a/0x120
>
>   stack backtrace:
>   Call Trace:
>    dump_stack+0x5c/0x80
>    check_noncircular+0xff/0x120
>    check_prevs_add+0x185/0xb80
>    __lock_acquire+0xd8f/0xe90
>    lock_acquire+0xe8/0x470
>    __kernfs_remove+0x25e/0x320
>    kernfs_remove+0x1d/0x30
>    kobject_del+0x28/0x60
>    kmem_cache_destroy+0xf1/0x120
>    bioset_exit+0xb5/0x100
>    cleanup_mapped_device+0x26/0xf0 [dm_mod]
>    free_dev+0x43/0xb0 [dm_mod]
>    __dm_destroy+0x153/0x1b0 [dm_mod]
>    dev_remove+0xe4/0x1a0 [dm_mod]
>    ctl_ioctl+0x1af/0x3f0 [dm_mod]
>    dm_ctl_ioctl+0xa/0x10 [dm_mod]
>    do_vfs_ioctl+0xa5/0x760
>    ksys_ioctl+0x60/0x90
>    __x64_sys_ioctl+0x16/0x20
>    do_syscall_64+0x8c/0x240
>    entry_SYSCALL_64_after_hwframe+0x6a/0xdf
>
> Since cpus_read_lock() is supposed to protect the cpu related data, it
> makes sense to fix this issue by moving cpus_read_lock() from
> kmem_cache_destroy() to __kmem_cache_shutdown(). While at it,
> add the missing cpus_read_lock() in slab_mem_going_offline_callback().
>
> Fixes: 5a836bf6b09f ("mm: slub: move flush_cpu_slab() invocations __free_slab() invocations out of IRQ context")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  mm/slab_common.c | 2 --
>  mm/slub.c        | 4 ++--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index e5d080a93009..06ec3fa585e6 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -494,7 +494,6 @@ void kmem_cache_destroy(struct kmem_cache *s)
>         if (unlikely(!s))
>                 return;
>
> -       cpus_read_lock();
>         mutex_lock(&slab_mutex);
>
>         s->refcount--;
> @@ -509,7 +508,6 @@ void kmem_cache_destroy(struct kmem_cache *s)
>         }
>  out_unlock:
>         mutex_unlock(&slab_mutex);
> -       cpus_read_unlock();
>  }
>  EXPORT_SYMBOL(kmem_cache_destroy);
>
> diff --git a/mm/slub.c b/mm/slub.c
> index abe7db581d68..754f020235ee 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4311,7 +4311,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
>         int node;
>         struct kmem_cache_node *n;
>
> -       flush_all_cpus_locked(s);
> +       flush_all(s);
>         /* Attempt to free all objects */
>         for_each_kmem_cache_node(s, node, n) {
>                 free_partial(s, n);
> @@ -4646,7 +4646,7 @@ static int slab_mem_going_offline_callback(void *arg)
>
>         mutex_lock(&slab_mutex);
>         list_for_each_entry(s, &slab_caches, list) {
> -               flush_all_cpus_locked(s);
> +               flush_all(s);
>                 __kmem_cache_do_shrink(s);
>         }
>         mutex_unlock(&slab_mutex);
> --
> 2.27.0
>
