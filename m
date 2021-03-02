Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98EB32A319
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381839AbhCBIqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241077AbhCBCwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:52:22 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35751C061788
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 18:50:41 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c16so1683969ply.0
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 18:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SzsqJhnliez1tKlON8yLC5F6USIx2iyCxc12/4u/r+c=;
        b=I4jmhul4Z5yg+xo9mAznhlNQXfF9s8TJskKTSIYrPYUwxVyIOcIlOkHWTsBaQVpGvf
         zDfHR7YnJY4d4j+veaCOxSfnf0WdJ3ID5HmWGdqqfn4X9IRnN3/RLi+lxjq9EkL/uYJg
         Ok1k3/niPacZp26eNMSpbDoq3GpfxW/XQqR6xZjE05+hd3yztSnH3lGoSdP8q0vzU8mV
         ti376Ul89wmAe/aqsDWlTzuj21DVQu/MYm6lieeS66zGszHG8yOjJilhLpYNAckcid0b
         vaMpKvLB8/KzK02Oz61Wzk23FWx6sno07D+PyBkHlLt9mXti8KpMz9jXfJ37NeirOLtu
         9sVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SzsqJhnliez1tKlON8yLC5F6USIx2iyCxc12/4u/r+c=;
        b=eFDciXkp8LIjIKLWoc1WTSwMHffH+bisI6j+1ASHAy45a8Nf20ky+sbrGtoE6GF408
         7LWn9oMRd/Xfl2NH86wkhQBaX0v/xihMJ8IOfOZeGkqAacFtt9qyvE6Ea7qxB5EE63Zg
         zm8BBVbqtNGSxMQw/rxSC0HGV8rZ3fdTcYvg1I8eydPFw/YHmJVfMWFsy8sMhoH9Yf4M
         N6wUY897Q5W9sQnxRXHxu/eCIL3aQYhwEYHtudiHtNQ9PZxOD8321pOIHczsF4uYGSSY
         6QyXpNLWJFo5UBffZ6oOPqPsNSpaksHhuTLaSupew6a/EQszQcanLKUKlGUohqKZ03XC
         BJUg==
X-Gm-Message-State: AOAM53220bOr1TDwg+f3WwcnXZCR+CQ8vx0ygg5BbVX/EViL2Zlpx6gy
        Zj+EuS5c4zd5H5XzQpP0vuv375KvIFtoB92+Y1dBNA==
X-Google-Smtp-Source: ABdhPJwO4U6Vuif29dmFk6pc2ND9DlOcJXGnqC3Sy0dnPR0PpJ3LuKt8LwGDKRqjDVvzgWiY/91mipCndD5BXqlSM8E=
X-Received: by 2002:a17:902:e54e:b029:e3:9f84:db8e with SMTP id
 n14-20020a170902e54eb02900e39f84db8emr1508267plf.24.1614653440529; Mon, 01
 Mar 2021 18:50:40 -0800 (PST)
MIME-Version: 1.0
References: <20210301062227.59292-1-songmuchun@bytedance.com> <YD2Q5q2HfKXPnDte@carbon.dhcp.thefacebook.com>
In-Reply-To: <YD2Q5q2HfKXPnDte@carbon.dhcp.thefacebook.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 2 Mar 2021 10:50:04 +0800
Message-ID: <CAMZfGtUzB1duVS+pSEHvB-g6BSQ25mQMvUjopcADx0v2go3Q0g@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 0/5] Use obj_cgroup APIs to change kmem pages
To:     Roman Gushchin <guro@fb.com>
Cc:     viro@zeniv.linux.org.uk, Jan Kara <jack@suse.cz>,
        amir73il@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        juri.lelli@redhat.com,
        Vincent Guittot <vincent.guittot@linaro.org>,
        dietmar.eggemann@arm.com, Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Segall <bsegall@google.com>, mgorman@suse.de,
        bristot@redhat.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Chris Down <chris@chrisdown.name>, richard.weiyang@gmail.com,
        Vlastimil Babka <vbabka@suse.cz>,
        mathieu.desnoyers@efficios.com, posk@google.com,
        Jann Horn <jannh@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, longman@redhat.com,
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

On Tue, Mar 2, 2021 at 9:12 AM Roman Gushchin <guro@fb.com> wrote:
>
> Hi Muchun!
>
> On Mon, Mar 01, 2021 at 02:22:22PM +0800, Muchun Song wrote:
> > Since Roman series "The new cgroup slab memory controller" applied. All
> > slab objects are changed via the new APIs of obj_cgroup. This new APIs
> > introduce a struct obj_cgroup instead of using struct mem_cgroup directly
> > to charge slab objects. It prevents long-living objects from pinning the
> > original memory cgroup in the memory. But there are still some corner
> > objects (e.g. allocations larger than order-1 page on SLUB) which are
> > not charged via the API of obj_cgroup. Those objects (include the pages
> > which are allocated from buddy allocator directly) are charged as kmem
> > pages which still hold a reference to the memory cgroup.
>
> Yes, this is a good idea, large kmallocs should be treated the same
> way as small ones.
>
> >
> > E.g. We know that the kernel stack is charged as kmem pages because the
> > size of the kernel stack can be greater than 2 pages (e.g. 16KB on x86_64
> > or arm64). If we create a thread (suppose the thread stack is charged to
> > memory cgroup A) and then move it from memory cgroup A to memory cgroup
> > B. Because the kernel stack of the thread hold a reference to the memory
> > cgroup A. The thread can pin the memory cgroup A in the memory even if
> > we remove the cgroup A. If we want to see this scenario by using the
> > following script. We can see that the system has added 500 dying cgroups.
> >
> >       #!/bin/bash
> >
> >       cat /proc/cgroups | grep memory
> >
> >       cd /sys/fs/cgroup/memory
> >       echo 1 > memory.move_charge_at_immigrate
> >
> >       for i in range{1..500}
> >       do
> >               mkdir kmem_test
> >               echo $$ > kmem_test/cgroup.procs
> >               sleep 3600 &
> >               echo $$ > cgroup.procs
> >               echo `cat kmem_test/cgroup.procs` > cgroup.procs
> >               rmdir kmem_test
> >       done
> >
> >       cat /proc/cgroups | grep memory
>
> Well, moving processes between cgroups always created a lot of issues
> and corner cases and this one is definitely not the worst. So this problem
> looks a bit artificial, unless I'm missing something. But if it doesn't
> introduce any new performance costs and doesn't make the code more complex,
> I have nothing against.

OK. I just want to show that large kmallocs are charged as kmem pages.
So I constructed this test case.

>
> Btw, can you, please, run the spell-checker on commit logs? There are many
> typos (starting from the title of the series, I guess), which make the patchset
> look less appealing.

Sorry for my poor English. I will do that. Thanks for your suggestions.


>
> Thank you!
>
> >
> > This patchset aims to make those kmem pages drop the reference to memory
> > cgroup by using the APIs of obj_cgroup. Finally, we can see that the number
> > of the dying cgroups will not increase if we run the above test script.
> >
> > Patch 1-3 are using obj_cgroup APIs to charge kmem pages. The remote
> > memory cgroup charing APIs is a mechanism to charge kernel memory to a
> > given memory cgroup. So I also make it use the APIs of obj_cgroup.
> > Patch 4-5 are doing this.
> >
> > Muchun Song (5):
> >   mm: memcontrol: introduce obj_cgroup_{un}charge_page
> >   mm: memcontrol: make page_memcg{_rcu} only applicable for non-kmem
> >     page
> >   mm: memcontrol: reparent the kmem pages on cgroup removal
> >   mm: memcontrol: move remote memcg charging APIs to CONFIG_MEMCG_KMEM
> >   mm: memcontrol: use object cgroup for remote memory cgroup charging
> >
> >  fs/buffer.c                          |  10 +-
> >  fs/notify/fanotify/fanotify.c        |   6 +-
> >  fs/notify/fanotify/fanotify_user.c   |   2 +-
> >  fs/notify/group.c                    |   3 +-
> >  fs/notify/inotify/inotify_fsnotify.c |   8 +-
> >  fs/notify/inotify/inotify_user.c     |   2 +-
> >  include/linux/bpf.h                  |   2 +-
> >  include/linux/fsnotify_backend.h     |   2 +-
> >  include/linux/memcontrol.h           | 109 +++++++++++---
> >  include/linux/sched.h                |   6 +-
> >  include/linux/sched/mm.h             |  30 ++--
> >  kernel/bpf/syscall.c                 |  35 ++---
> >  kernel/fork.c                        |   4 +-
> >  mm/memcontrol.c                      | 276 ++++++++++++++++++++++-------------
> >  mm/page_alloc.c                      |   4 +-
> >  15 files changed, 324 insertions(+), 175 deletions(-)
> >
> > --
> > 2.11.0
> >
