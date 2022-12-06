Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E1E644C4B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiLFTOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiLFTOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:14:04 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5590263DD
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 11:14:03 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id i186so7694025ybc.9
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 11:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nsGstoMegH9NCBA+9S++kT1eq+4LgLp/g5jcJesallk=;
        b=XYKeMYNurkuR6sR3Bimkf7Sn8dHGUPB/zyUAi5+51h+e/3eKyuQGNJmkMVJA2I8mIO
         CRj1XB6I+6aa93zGfB/XreNSlmTLe7W5eHZVi/gq5zyZ7EEkjk4q49HSkidWnAE7J2UZ
         yhegxEOwEF91TJJvN5JjZ1tgaxWE7Z0j3VlZWiVxWL3QhIxeqHNLGUahLLYMgnMWo6m7
         LWQBrrP98g3lSPdohibAd0RZqtMzH2ASNda0/fz+SLByFsys48P+q9qh3dZu1Okmq1jf
         RtZC+vv238QR0AXfwTzcUPRCnYQP38SscsXB3ILVgMfK8CzeVP8pxS7S6iPEzQGHWcIP
         fdBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nsGstoMegH9NCBA+9S++kT1eq+4LgLp/g5jcJesallk=;
        b=IRW93dMpcy5oxxtkaSN72ztItobKHewVF3/T3OjpU54aU3c5v2mMS6Q6YJVocjOnrX
         pY18saJ046LDBEKzCZrwTiqBK4QTHgnWmGgaOYsYgpZUi8XmIdo4FEKKOGkkuE8BG+Ym
         TA+ICuIdnTtCx14HWAg/acWSzqiHk4j0HiV2b/rPnIxv7as+LRNTHcgmFCDG9WRtD9VL
         /T7H44h59ga+XLKj1xiEQ+7r2lSpkwo11cuZHfAYqVD5esrYIWxdcMzieKIJhCxYX/I4
         Xc4PTsuiItpjf4rRgeS2/aU9Ap8EUZ0gKUIIUjs069HkFnhnqzX5J3DRBJkIs0ZcWrl9
         qfEQ==
X-Gm-Message-State: ANoB5pkaOAATyc8S+S+JHNzyr0IZP80ZX8LS9RnYg1b2wI255pcHB44O
        UNSP7Dcxxj7Ib+X1wokqTA/zeYeS/rJKmNHLikcHYA==
X-Google-Smtp-Source: AA0mqf7m6QMPk8QvSd5EosLtYWGKojHXXveXDH0jx2Rge6XwaoiwkjiHmCyuNB2B6z2oCDVoagQzgUk1NRNWwoi5oyU=
X-Received: by 2002:a25:24d:0:b0:6fd:2917:cf60 with SMTP id
 74-20020a25024d000000b006fd2917cf60mr18389766ybc.427.1670354042180; Tue, 06
 Dec 2022 11:14:02 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org> <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
 <Y4T43Tc54vlKjTN0@cmpxchg.org> <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
 <CABWYdi25hricmGUqaK1K0EB-pAm04vGTg=eiqRF99RJ7hM7Gyg@mail.gmail.com> <Y4+RPry2tfbWFdSA@cmpxchg.org>
In-Reply-To: <Y4+RPry2tfbWFdSA@cmpxchg.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Dec 2022 20:13:50 +0100
Message-ID: <CANn89iJfx4QdVBqJ23oFJoz5DJKou=ZwVBNNXFNDJRNAqNvzwQ@mail.gmail.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Ivan Babrou <ivan@cloudflare.com>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 8:00 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Mon, Dec 05, 2022 at 04:50:46PM -0800, Ivan Babrou wrote:
> > And now I can see plenty of this:
> >
> > [  108.156707][ T5175] socket pressure[2]: 4294673429
> > [  108.157050][ T5175] socket pressure[2]: 4294673429
> > [  108.157301][ T5175] socket pressure[2]: 4294673429
> > [  108.157581][ T5175] socket pressure[2]: 4294673429
> > [  108.157874][ T5175] socket pressure[2]: 4294673429
> > [  108.158254][ T5175] socket pressure[2]: 4294673429
> >
> > I think the first result below is to blame:
> >
> > $ rg '.->socket_pressure' mm
> > mm/memcontrol.c
> > 5280: memcg->socket_pressure = jiffies;
> > 7198: memcg->socket_pressure = 0;
> > 7201: memcg->socket_pressure = 1;
> > 7211: memcg->socket_pressure = 0;
> > 7215: memcg->socket_pressure = 1;
>
> Hoo boy, that's a silly mistake indeed. Thanks for tracking it down.
>
> > While we set socket_pressure to either zero or one in
> > mem_cgroup_charge_skmem, it is still initialized to jiffies on memcg
> > creation. Zero seems like a more appropriate starting point. With that
> > change I see it working as expected with no TCP speed bumps. My
> > ebpf_exporter program also looks happy and reports zero clamps in my
> > brief testing.
>
> Excellent, now this behavior makes sense.
>
> > I also think we should downgrade socket_pressure from "unsigned long"
> > to "bool", as it only holds zero and one now.
>
> Sounds good to me!
>
> Attaching the updated patch below. If nobody has any objections, I'll
> add a proper changelog, reported-bys, sign-off etc and send it out.
>
> ---
>  include/linux/memcontrol.h |  8 +++---
>  include/linux/vmpressure.h |  7 ++---
>  mm/memcontrol.c            | 20 +++++++++----
>  mm/vmpressure.c            | 58 ++++++--------------------------------
>  mm/vmscan.c                | 15 +---------
>  5 files changed, 30 insertions(+), 78 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e1644a24009c..ef1c388be5b3 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -283,11 +283,11 @@ struct mem_cgroup {
>         atomic_long_t           memory_events[MEMCG_NR_MEMORY_EVENTS];
>         atomic_long_t           memory_events_local[MEMCG_NR_MEMORY_EVENTS];
>
> -       unsigned long           socket_pressure;
> +       /* Socket memory allocations have failed */
> +       bool                    socket_pressure;
>
>         /* Legacy tcp memory accounting */
>         bool                    tcpmem_active;
> -       int                     tcpmem_pressure;
>
>  #ifdef CONFIG_MEMCG_KMEM
>         int kmemcg_id;
> @@ -1701,10 +1701,10 @@ void mem_cgroup_sk_alloc(struct sock *sk);
>  void mem_cgroup_sk_free(struct sock *sk);
>  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
>  {
> -       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->socket_pressure)

&& READ_ONCE(memcg->socket_pressure))

>                 return true;
>         do {
> -               if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
> +               if (memcg->socket_pressure)

if (READ_ONCE(...))

>                         return true;
>         } while ((memcg = parent_mem_cgroup(memcg)));
>         return false;
> diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
> index 6a2f51ebbfd3..20d93de37a17 100644
> --- a/include/linux/vmpressure.h
> +++ b/include/linux/vmpressure.h
> @@ -11,9 +11,6 @@
>  #include <linux/eventfd.h>
>
>  struct vmpressure {
> -       unsigned long scanned;
> -       unsigned long reclaimed;
> -
>         unsigned long tree_scanned;
>         unsigned long tree_reclaimed;
>         /* The lock is used to keep the scanned/reclaimed above in sync. */
> @@ -30,7 +27,7 @@ struct vmpressure {
>  struct mem_cgroup;
>
>  #ifdef CONFIG_MEMCG
> -extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
> +extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
>                        unsigned long scanned, unsigned long reclaimed);
>  extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
>
> @@ -44,7 +41,7 @@ extern int vmpressure_register_event(struct mem_cgroup *memcg,
>  extern void vmpressure_unregister_event(struct mem_cgroup *memcg,
>                                         struct eventfd_ctx *eventfd);
>  #else
> -static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
> +static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
>                               unsigned long scanned, unsigned long reclaimed) {}
>  static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg,
>                                    int prio) {}
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2d8549ae1b30..0d4b9dbe775a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5277,7 +5277,6 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>         vmpressure_init(&memcg->vmpressure);
>         INIT_LIST_HEAD(&memcg->event_list);
>         spin_lock_init(&memcg->event_list_lock);
> -       memcg->socket_pressure = jiffies;
>  #ifdef CONFIG_MEMCG_KMEM
>         memcg->kmemcg_id = -1;
>         INIT_LIST_HEAD(&memcg->objcg_list);
> @@ -7195,10 +7194,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
>                 struct page_counter *fail;
>
>                 if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
> -                       memcg->tcpmem_pressure = 0;

Orthogonal to your patch, but:

Maybe avoid touching this cache line too often and use READ/WRITE_ONCE() ?

    if (READ_ONCE(memcg->socket_pressure))
      WRITE_ONCE(memcg->socket_pressure, false);


> +                       memcg->socket_pressure = false;
>                         return true;
>                 }
> -               memcg->tcpmem_pressure = 1;
> +               memcg->socket_pressure = true;

Same remark.

>                 if (gfp_mask & __GFP_NOFAIL) {
>                         page_counter_charge(&memcg->tcpmem, nr_pages);
>                         return true;
> @@ -7206,12 +7205,21 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
>                 return false;
>         }
>
> -       if (try_charge(memcg, gfp_mask, nr_pages) == 0) {
> -               mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
> -               return true;
> +       if (try_charge(memcg, gfp_mask & ~__GFP_NOFAIL, nr_pages) == 0) {
> +               memcg->socket_pressure = false;

same remark.

> +               goto success;
> +       }
> +       memcg->socket_pressure = true;

same remark.

> +       if (gfp_mask & __GFP_NOFAIL) {
> +               try_charge(memcg, gfp_mask, nr_pages);
> +               goto success;
>         }
>
>         return false;
> +
> +success:
> +       mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
> +       return true;
>  }
>
>  /**
