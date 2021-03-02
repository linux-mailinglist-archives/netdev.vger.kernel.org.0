Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5609232A32A
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382013AbhCBIsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239262AbhCBENe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 23:13:34 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA37C0617A7
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 20:12:53 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id c19so1042306pjq.3
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 20:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pJaPLF9X1F6hvOBAXTHBgh9HYMVdoLjPILjLEfD7bkc=;
        b=YEZ1cocgpsBHNkw0q+n3c+WrJ0f5ZYMWZ5GgZymplzz/JjXP3J3GP3MQPyOD+t7hxj
         AsK2COA53kOesfdd7nTgEuKuQJ7B+1JaLSiIWqINpSswz1f453uWWv5cf5Zy9QVnSZdd
         X0vMaEoLsxLAVk5K6hSFHHKSylttTe535bfBlRj9YLzzI2p9d5SVShpMsGrjNw3iULbC
         +mik6ICMk5ltsWjqpAmuGCd/qH7Pw0q8Y8kTUadbUjZeBEzXHeBTNP0c+D7LqoTso/Yu
         kjJIpeToFr5LIiD+nTQahXyU61ghaF6X5hl9rGGDki1aC/DUcXPcY0IZd4brRdl8pXp+
         iUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pJaPLF9X1F6hvOBAXTHBgh9HYMVdoLjPILjLEfD7bkc=;
        b=s6CV1C9NV1X/Ra6IJ/J7OY399huA20G6utfyguiLN3ycu3i00M0ZF5U5MH3pRLIa5n
         X1j4KHHz1sVp8nqfvsV/s3gVr+Q+vRx3475b+u43SydQtT/lmcaAsc2dzKFJlQ3cSCjk
         uTR1pqm91PU9fkYSq/ruLscNpQgmgi9qv3mfmL53qL2VnxTXvamz3aGFRPbo+qNNz/s9
         LuaaS0akwPW0GdFUAFyHq1UO6d4atbKXeyQh4etXABj5PZd2V2UkIqK9c7X7zoo9cmGJ
         zZHrshCHB7cJDulMgKiby7Xiub9Z357G2bgy0x4YoK5cGaJfZzFqteFo5ZLSTVS5SiVd
         dzxA==
X-Gm-Message-State: AOAM532Hq/IxwLb8sBqj5K9E1jUUnZpJ9yn4GEpb9gHywQveCiZGODwE
        hV7I90J7Na3Iop/jcLIbXklcowR6PRpmnZ9eCAaYPA==
X-Google-Smtp-Source: ABdhPJw4yPDMdM9rw5cTzxwrZpXy5wEJz7YfOZ5x9bGXhm1fMxZCHjNMKhVkXo1trQ0xr49A64GmU+RJmU/bXtSc/g0=
X-Received: by 2002:a17:902:d4c2:b029:e3:cb77:e51 with SMTP id
 o2-20020a170902d4c2b02900e3cb770e51mr18426342plg.20.1614658372860; Mon, 01
 Mar 2021 20:12:52 -0800 (PST)
MIME-Version: 1.0
References: <20210301062227.59292-1-songmuchun@bytedance.com>
 <20210301062227.59292-5-songmuchun@bytedance.com> <YD2RuPzikjPnI82h@carbon.dhcp.thefacebook.com>
In-Reply-To: <YD2RuPzikjPnI82h@carbon.dhcp.thefacebook.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 2 Mar 2021 12:12:16 +0800
Message-ID: <CAMZfGtXdPw41iFUjDbkkAwm+D3ut-U+GpZC3Zz9cvS2FTCCYzw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 4/5] mm: memcontrol: move remote memcg
 charging APIs to CONFIG_MEMCG_KMEM
To:     Roman Gushchin <guro@fb.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Amir Goldstein <amir73il@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        dietmar.eggemann@arm.com, Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, bristot@redhat.com,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        alexander.h.duyck@linux.intel.com,
        Chris Down <chris@chrisdown.name>,
        Wei Yang <richard.weiyang@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Oskolkov <posk@google.com>, Jann Horn <jannh@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Waiman Long <longman@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, krisman@collabora.com,
        esyr@redhat.com, Suren Baghdasaryan <surenb@google.com>,
        Marco Elver <elver@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Xiongchun duan <duanxiongchun@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 9:15 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Mon, Mar 01, 2021 at 02:22:26PM +0800, Muchun Song wrote:
> > The remote memcg charing APIs is a mechanism to charge kernel memory
> > to a given memcg. So we can move the infrastructure to the scope of
> > the CONFIG_MEMCG_KMEM.
>
> This is not a good idea, because there is nothing kmem-specific
> in the idea of remote charging, and we definitely will see cases
> when user memory is charged to the process different from the current.

Got it. Thanks for your reminder.


>
> >
> > As a bonus, on !CONFIG_MEMCG_KMEM build some functions and variables
> > can be compiled out.
> >
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> >  include/linux/sched.h    | 2 ++
> >  include/linux/sched/mm.h | 2 +-
> >  kernel/fork.c            | 2 +-
> >  mm/memcontrol.c          | 4 ++++
> >  4 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index ee46f5cab95b..c2d488eddf85 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1314,7 +1314,9 @@ struct task_struct {
> >
> >       /* Number of pages to reclaim on returning to userland: */
> >       unsigned int                    memcg_nr_pages_over_high;
> > +#endif
> >
> > +#ifdef CONFIG_MEMCG_KMEM
> >       /* Used by memcontrol for targeted memcg charge: */
> >       struct mem_cgroup               *active_memcg;
> >  #endif
> > diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> > index 1ae08b8462a4..64a72975270e 100644
> > --- a/include/linux/sched/mm.h
> > +++ b/include/linux/sched/mm.h
> > @@ -294,7 +294,7 @@ static inline void memalloc_nocma_restore(unsigned int flags)
> >  }
> >  #endif
> >
> > -#ifdef CONFIG_MEMCG
> > +#ifdef CONFIG_MEMCG_KMEM
> >  DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
> >  /**
> >   * set_active_memcg - Starts the remote memcg charging scope.
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index d66cd1014211..d66718bc82d5 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -942,7 +942,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
> >       tsk->use_memdelay = 0;
> >  #endif
> >
> > -#ifdef CONFIG_MEMCG
> > +#ifdef CONFIG_MEMCG_KMEM
> >       tsk->active_memcg = NULL;
> >  #endif
> >       return tsk;
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 39cb8c5bf8b2..092dc4588b43 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -76,8 +76,10 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
> >
> >  struct mem_cgroup *root_mem_cgroup __read_mostly;
> >
> > +#ifdef CONFIG_MEMCG_KMEM
> >  /* Active memory cgroup to use from an interrupt context */
> >  DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
> > +#endif
> >
> >  /* Socket memory accounting disabled? */
> >  static bool cgroup_memory_nosocket;
> > @@ -1054,6 +1056,7 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
> >  }
> >  EXPORT_SYMBOL(get_mem_cgroup_from_mm);
> >
> > +#ifdef CONFIG_MEMCG_KMEM
> >  static __always_inline struct mem_cgroup *active_memcg(void)
> >  {
> >       if (in_interrupt())
> > @@ -1074,6 +1077,7 @@ static __always_inline bool memcg_kmem_bypass(void)
> >
> >       return false;
> >  }
> > +#endif
> >
> >  /**
> >   * mem_cgroup_iter - iterate over memory cgroup hierarchy
> > --
> > 2.11.0
> >
