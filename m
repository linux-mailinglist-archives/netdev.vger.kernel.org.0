Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F224658843B
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 00:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbiHBW2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 18:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiHBW2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 18:28:06 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6802154CBE
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 15:27:55 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id i4so11728913qvv.7
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 15:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9SA1GeBCwPiGvsrnnwBDw1nYIHiUSNtHqCw5JUNeRyk=;
        b=tN7USoFfowYqaOA3Zg7kBgDk9uh8FMrZP5UPHQpQgQA49sW+iNiHFS0Ua7puhPUvQV
         y23XyuYrkE8cRYDz/Za/oub0X6hP/u2391ShPfSH6nuX3nku04d1N71G7JBwsqgFMBCL
         svXUhAvY2hQc8Ot26TnHY2JyRLD7XFvGuqJeGRvQUqiEV3WxSZh4lwAFNPaW1v4k8i0s
         9S8eVIpf0+8pemcv6MCpwmd7tlpfmxitnptjmQJDw8HPZMXMt3IPtJpk4KfIeDScYyBn
         pcM3gNEYo0bAOeb3/VY4KxpyGtKfutMGciY6RE5pFf22fS/4Ng9+Ypqtwqw6Om+9t8at
         ta0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9SA1GeBCwPiGvsrnnwBDw1nYIHiUSNtHqCw5JUNeRyk=;
        b=SrvfOWLhP/Pdkbj6wbk3pvcODqO3YBa3bluDQmJwYBVqCCz9g7+lwKp2Akn7sbnHWT
         zMIPyhcUCxnAtuc98xK8th5anPzUNP5zUsZtszh6BivdtRx2p2PysOpgi//0POK/k66F
         piqCZ6HSWuHVcDHRVQAQkdEVUMl5rdFSPcH37oHEuAb3RlW6sP/0/fqXrYn09bbrmtc3
         rbq/DeYMn+3IjVR80eXVGgU3kjHchaN9iDaxgGWnKZ5m5j8YBpkLu+9Yl3Lp3y0RYQe5
         7RXntpErtdnupVR+vIaCu2pjI+1p+MORL3RrEcLMUMkZ5v2s8jQxLCvc69Xf5JIHjesH
         1pAg==
X-Gm-Message-State: ACgBeo0MU6amiwqH4bMGPEvGXEUnFxpYGB/TXXlxA8of54or4nONAX2x
        AvZ5b1lQ5eM+9cU99IpovssbC8RAOGFXr4C+Ex2ZHA==
X-Google-Smtp-Source: AA6agR5+Y3zN3DuMsHNU5t2COkNkCwWZBkoftegn99gL+qMDMiI/AiRmHr5ptn4jQrA3+/lO3hRhX33eBXJdbM5Cocw=
X-Received: by 2002:a0c:9101:0:b0:473:9b:d92a with SMTP id q1-20020a0c9101000000b00473009bd92amr19932398qvq.17.1659479274234;
 Tue, 02 Aug 2022 15:27:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com> <CAEf4BzbD38XFVxMy5crO-=+Xg7U3Vc_fB4Ntug4BEbmdLpvuDQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbD38XFVxMy5crO-=+Xg7U3Vc_fB4Ntug4BEbmdLpvuDQ@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 2 Aug 2022 15:27:43 -0700
Message-ID: <CA+khW7jftQikVsc8moM6rNRqBerUHDM6WRDjb33exdbogDc7aQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Kui-Feng Lee <kuifeng@fb.com>
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

Hi Andrii,

On Mon, Aug 1, 2022 at 8:43 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jul 22, 2022 at 10:48 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > From: Hao Luo <haoluo@google.com>
> >
> > Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
> >
> >  - walking a cgroup's descendants in pre-order.
> >  - walking a cgroup's descendants in post-order.
> >  - walking a cgroup's ancestors.
> >
> > When attaching cgroup_iter, one can set a cgroup to the iter_link
> > created from attaching. This cgroup is passed as a file descriptor and
> > serves as the starting point of the walk. If no cgroup is specified,
> > the starting point will be the root cgroup.
> >
> > For walking descendants, one can specify the order: either pre-order or
> > post-order. For walking ancestors, the walk starts at the specified
> > cgroup and ends at the root.
> >
> > One can also terminate the walk early by returning 1 from the iter
> > program.
> >
> > Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> > program is called with cgroup_mutex held.
> >
> > Currently only one session is supported, which means, depending on the
> > volume of data bpf program intends to send to user space, the number
> > of cgroups that can be walked is limited. For example, given the current
> > buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> > cgroup, the total number of cgroups that can be walked is 512. This is
> > a limitation of cgroup_iter. If the output data is larger than the
> > buffer size, the second read() will signal EOPNOTSUPP. In order to work
> > around, the user may have to update their program to reduce the volume
> > of data sent to output. For example, skip some uninteresting cgroups.
> > In future, we may extend bpf_iter flags to allow customizing buffer
> > size.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > Acked-by: Yonghong Song <yhs@fb.com>
> > ---
> >  include/linux/bpf.h                           |   8 +
> >  include/uapi/linux/bpf.h                      |  30 +++
> >  kernel/bpf/Makefile                           |   3 +
> >  kernel/bpf/cgroup_iter.c                      | 252 ++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h                |  30 +++
> >  .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
> >  6 files changed, 325 insertions(+), 2 deletions(-)
> >  create mode 100644 kernel/bpf/cgroup_iter.c
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index a97751d845c9..9061618fe929 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -47,6 +47,7 @@ struct kobject;
> >  struct mem_cgroup;
> >  struct module;
> >  struct bpf_func_state;
> > +struct cgroup;
> >
> >  extern struct idr btf_idr;
> >  extern spinlock_t btf_idr_lock;
> > @@ -1717,7 +1718,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
> >         int __init bpf_iter_ ## target(args) { return 0; }
> >
> >  struct bpf_iter_aux_info {
> > +       /* for map_elem iter */
> >         struct bpf_map *map;
> > +
> > +       /* for cgroup iter */
> > +       struct {
> > +               struct cgroup *start; /* starting cgroup */
> > +               int order;
> > +       } cgroup;
> >  };
> >
> >  typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index ffcbf79a556b..fe50c2489350 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -87,10 +87,30 @@ struct bpf_cgroup_storage_key {
> >         __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
> >  };
> >
> > +enum bpf_iter_cgroup_traversal_order {
> > +       BPF_ITER_CGROUP_PRE = 0,        /* pre-order traversal */
> > +       BPF_ITER_CGROUP_POST,           /* post-order traversal */
> > +       BPF_ITER_CGROUP_PARENT_UP,      /* traversal of ancestors up to the root */
>
> I've just put up my arguments why it's a good idea to also support a
> "trivial" mode of only traversing specified cgroup and no descendants
> or parents. Please see [0].

cc Kui-Feng in this thread.

Yeah, I think it's a good idea. It's useful when we only want to show
a single object, which can be common. Going further, I think we may
want to restructure bpf_iter to optimize for this case.

> I think the same applies here, especially
> considering that it seems like a good idea to support
> task/task_vma/task_files iteration within a cgroup.

I have reservations on these use cases. I don't see immediate use of
iterating vma or files within a cgroup. Tasks within a cgroup? Maybe.
:)

> So depending on
> how successful I am in arguing for supporting task iterator with
> target cgroup, I think we should reuse *exactly* this
> bpf_iter_cgroup_traversal_order and how we specify cgroup (FD or ID,
> see some more below) *as is* in task iterators as well. In the latter
> case, having an ability to say "iterate task for only given cgroup" is
> very useful, and for such mode all the PRE/POST/PARENT_UP is just an
> unnecessary nuisance.
>
> So please consider also adding and supporting BPF_ITER_CGROUP_SELF (or
> whatever naming makes most sense).
>

PRE/POST/UP can be reused for iter of tree-structured containers, like
rbtree [1]. SELF can be reused for any iters like iter/task,
iter/cgroup, etc. Promoting all of them out of cgroup-specific struct
seems valuable.

[1] https://lwn.net/Articles/902405/

>
> Some more naming nits. I find BPF_ITER_CGROUP_PRE and
> BPF_ITER_CGROUP_POST a bit confusing. Even internally in kernel we
> have css_next_descendant_pre/css_next_descendant_post, so why not
> reflect the fact that we are going to iterate descendants:
> BPF_ITER_CGROUP_DESCENDANTS_{PRE,POST}. And now that we use
> "descendants" terminology, PARENT_UP should be ANCESTORS. ANCESTORS_UP
> probably is fine, but seems a bit redundant (unless we consider a
> somewhat weird ANCESTORS_DOWN, where we find the furthest parent and
> then descend through preceding parents until we reach specified
> cgroup; seems a bit exotic).
>

BPF_ITER_CGROUP_DESCENDANTS_PRE is too verbose. If there is a
possibility of merging rbtree and supporting walk order of rbtree
iter, maybe the name here could be general, like
BPF_ITER_DESCENDANTS_PRE, which seems better.

>   [0] https://lore.kernel.org/bpf/f92e20e9961963e20766e290ee6668edd4bacf06.camel@fb.com/T/#m5ce50632aa550dd87a99241efb168cbcde1ee98f
>
> > +};
> > +
> >  union bpf_iter_link_info {
> >         struct {
> >                 __u32   map_fd;
> >         } map;
> > +
> > +       /* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> > +        * ancestors of a given cgroup.
> > +        */
> > +       struct {
> > +               /* Cgroup file descriptor. This is root of the subtree if walking
> > +                * descendants; it's the starting cgroup if walking the ancestors.
> > +                * If it is left 0, the traversal starts from the default cgroup v2
> > +                * root. For walking v1 hierarchy, one should always explicitly
> > +                * specify the cgroup_fd.
> > +                */
> > +               __u32   cgroup_fd;
>
> Now, similar to what I argued in regard of pidfd vs pid, I think the
> same applied to cgroup_fd vs cgroup_id. Why can't we support both?
> cgroup_fd has some benefits, but cgroup_id is nice due to simplicity
> and not having to open/close/keep extra FDs (which can add up if we
> want to periodically query something about a large set of cgroups).
> Please see my arguments from [0] above.
>
> Thoughts?
>

We can support both, it's a good idea IMO. But what exactly is the
interface going to look like? Can you be more specific about that?
Below is something I tried based on your description.

@@ -91,6 +91,18 @@ union bpf_iter_link_info {
        struct {
                __u32   map_fd;
        } map;
+       struct {
+               /* PRE/POST/UP/SELF */
+               __u32 order;
+               struct {
+                       __u32 cgroup_fd;
+                       __u64 cgroup_id;
+               } cgroup;
+               struct {
+                       __u32 pid_fd;
+                       __u64 pid;
+               } task;
+       };
 };

> > +               __u32   traversal_order;
> > +       } cgroup;
> >  };
> >
> >  /* BPF syscall commands, see bpf(2) man-page for more details. */
>
> [...]
