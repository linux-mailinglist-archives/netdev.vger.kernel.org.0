Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014395844FD
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 19:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbiG1RZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 13:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiG1RZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 13:25:21 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1D3636C
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 10:25:16 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id b25so1903505qka.11
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 10:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJljmSyv8w2VGn14si1kaNQ7bWs8OfRzJatRimvQO6Y=;
        b=CfRo5oBkcztfAwLnAzZIUzpKexeCvxCHJMUJKzRww2U7OEoRyVjvJpexbqWSjQxBdA
         qL+OEIx8n0OE+R6HQ4z2++cp1adc9RBIWZpjQHxCC6IXy0soY1sQQL21u8IFjIR7oNjt
         JugLaK4fjGaz2dR3U1bSiPhJUDOVj70Y5UW7dUzdzA2kYz8qFBSUen71AWX+ctzp6S65
         vzIcqCTDPa37qDWAmKNZegbLDxgy4fW2TAybnzYvDfd2nJsqc6WNRYsccjdZiJb3Q1uO
         WxYfnaOByYHvcmwd1Wql+a+RKDG/g4/EN2QSmOiTsp20OWZa9UL2gZbXDZtGnJ1v2b4E
         ulhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJljmSyv8w2VGn14si1kaNQ7bWs8OfRzJatRimvQO6Y=;
        b=b15vO4lNgvddUZptAwQLG5/+Z7w9gyfZxXqGoXHI5WV+EXDk4ReZMo3dB4hW3rBtQO
         kz92zmJiJnvRYZBM2Vm5s8VbCO0dDOBmgXlAt+qEffx8MDzVubQEBrC4Z4ZssGo0CPPy
         REF4VOsUyRZMUTzg8BSBrhOmgJR/p5Rq/1bHFdZRLZ2vvp5xK3+wCWrQY94ldBx+k1MR
         TXYMEoDKgHOAIyVTOJ8PtV2z4M1h2R4/aSxR4enBimYrSI7mvo/OeL3k6wg6BrlarIZs
         ZaO8+0q08sZj9cj9AUme2ytJ/pFJOGPrIxvl9sJ9u2o/H3gOFu7I1QZ6uTxgBIpYdHEt
         t1eQ==
X-Gm-Message-State: AJIora/IklME/zr50LK/pjM6YN3Tjrbfz6L9Lt9Hjf2LT2BSmYcv2o1w
        SSmZ1DIdDjoFnf1PSxOcEgB5JPOjjcKLY+LCHkC50Q==
X-Google-Smtp-Source: AGRyM1s34s2C8L8L6uMgqt3nFoWY9qyNFbZJMALBMfTBELK21q7kEDV7vlTw/azuCicE0iNfwcdKVXQ2Ze0M8BZdk3k=
X-Received: by 2002:a05:620a:1927:b0:6b5:fe70:9acc with SMTP id
 bj39-20020a05620a192700b006b5fe709accmr21200732qkb.669.1659029115045; Thu, 28
 Jul 2022 10:25:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com> <c7ebc0c6-b301-de70-b5ae-1f62d360acb6@fb.com>
In-Reply-To: <c7ebc0c6-b301-de70-b5ae-1f62d360acb6@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 28 Jul 2022 10:25:04 -0700
Message-ID: <CA+khW7hvLgCKVA0kiKhREW-PZ4aOYvkGHoEqKAggEdyY9TRp7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
To:     Yonghong Song <yhs@fb.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
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
        bpf@vger.kernel.org, cgroups@vger.kernel.org
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

On Wed, Jul 27, 2022 at 10:49 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/22/22 10:48 AM, Yosry Ahmed wrote:
> > From: Hao Luo <haoluo@google.com>
> >
> > Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
> >
> >   - walking a cgroup's descendants in pre-order.
> >   - walking a cgroup's descendants in post-order.
> >   - walking a cgroup's ancestors.
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
>
> PAGE_SIZE needs to be 4KB in order to conclude that the total number of
> walked cgroups is 512.
>

Sure. Will change that.

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
> >   include/linux/bpf.h                           |   8 +
> >   include/uapi/linux/bpf.h                      |  30 +++
> >   kernel/bpf/Makefile                           |   3 +
> >   kernel/bpf/cgroup_iter.c                      | 252 ++++++++++++++++++
> >   tools/include/uapi/linux/bpf.h                |  30 +++
> >   .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
> >   6 files changed, 325 insertions(+), 2 deletions(-)
> >   create mode 100644 kernel/bpf/cgroup_iter.c
>
> This patch cannot apply to bpf-next cleanly, so please rebase
> and post again.
>

Sorry about that. Will do.

> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index a97751d845c9..9061618fe929 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -47,6 +47,7 @@ struct kobject;
> >   struct mem_cgroup;
> >   struct module;
> >   struct bpf_func_state;
> > +struct cgroup;
> >
> >   extern struct idr btf_idr;
> >   extern spinlock_t btf_idr_lock;
> > @@ -1717,7 +1718,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
> >       int __init bpf_iter_ ## target(args) { return 0; }
> >
> >   struct bpf_iter_aux_info {
> > +     /* for map_elem iter */
> >       struct bpf_map *map;
> > +
> > +     /* for cgroup iter */
> > +     struct {
> > +             struct cgroup *start; /* starting cgroup */
> > +             int order;
> > +     } cgroup;
> >   };
> >
> >   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index ffcbf79a556b..fe50c2489350 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -87,10 +87,30 @@ struct bpf_cgroup_storage_key {
> >       __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
> >   };
> >
> > +enum bpf_iter_cgroup_traversal_order {
> > +     BPF_ITER_CGROUP_PRE = 0,        /* pre-order traversal */
> > +     BPF_ITER_CGROUP_POST,           /* post-order traversal */
> > +     BPF_ITER_CGROUP_PARENT_UP,      /* traversal of ancestors up to the root */
> > +};
> > +
> >   union bpf_iter_link_info {
> >       struct {
> >               __u32   map_fd;
> >       } map;
> > +
> > +     /* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> > +      * ancestors of a given cgroup.
> > +      */
> > +     struct {
> > +             /* Cgroup file descriptor. This is root of the subtree if walking
> > +              * descendants; it's the starting cgroup if walking the ancestors.
> > +              * If it is left 0, the traversal starts from the default cgroup v2
> > +              * root. For walking v1 hierarchy, one should always explicitly
> > +              * specify the cgroup_fd.
> > +              */
>
> I did see how the above cgroup v1/v2 scenarios are enforced.
>

Do you mean _not_ see? Yosry and I experimented a bit. We found even
on systems where v2 is not enabled, cgroup v2 root always exists and
can be attached to, and can be iterated on (only trivially). We didn't
find a way to tell v1 and v2 apart and deemed a comment to instruct v1
users is fine?

> > +             __u32   cgroup_fd;
> > +             __u32   traversal_order;
> > +     } cgroup;
> >   };
> >
> >   /* BPF syscall commands, see bpf(2) man-page for more details. */
> > @@ -6136,6 +6156,16 @@ struct bpf_link_info {
> >                                       __u32 map_id;
> >                               } map;
> >                       };
> > +                     union {
> > +                             struct {
> > +                                     __u64 cgroup_id;
> > +                                     __u32 traversal_order;
> > +                             } cgroup;
> > +                     };
> > +                     /* For new iters, if the first field is larger than __u32,
> > +                      * the struct should be added in the second union. Otherwise,
> > +                      * it will create holes before map_id, breaking uapi.
> > +                      */
>
> Please put the comment above the union. Let us just say, if
> the iter specific field is __u32, it can be put in the first or
> second union. Otherwise, it is put in second union.
>

Ok.

> >               } iter;
> >               struct  {
> >                       __u32 netns_ino;
> > diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> > index 057ba8e01e70..00e05b69a4df 100644
> > --- a/kernel/bpf/Makefile
> > +++ b/kernel/bpf/Makefile
> > @@ -24,6 +24,9 @@ endif
> >   ifeq ($(CONFIG_PERF_EVENTS),y)
> >   obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
> >   endif
> > +ifeq ($(CONFIG_CGROUPS),y)
> > +obj-$(CONFIG_BPF_SYSCALL) += cgroup_iter.o
> > +endif
> >   obj-$(CONFIG_CGROUP_BPF) += cgroup.o
> >   ifeq ($(CONFIG_INET),y)
> >   obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
> > diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
> > new file mode 100644
> > index 000000000000..1027faed0b8b
> > --- /dev/null
> > +++ b/kernel/bpf/cgroup_iter.c
> > @@ -0,0 +1,252 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (c) 2022 Google */
> > +#include <linux/bpf.h>
> > +#include <linux/btf_ids.h>
> > +#include <linux/cgroup.h>
> > +#include <linux/kernel.h>
> > +#include <linux/seq_file.h>
> > +
> > +#include "../cgroup/cgroup-internal.h"  /* cgroup_mutex and cgroup_is_dead */
> > +
> > +/* cgroup_iter provides three modes of traversal to the cgroup hierarchy.
> > + *
> > + *  1. Walk the descendants of a cgroup in pre-order.
> > + *  2. Walk the descendants of a cgroup in post-order.
> > + *  2. Walk the ancestors of a cgroup.
> > + *
> > + * For walking descendants, cgroup_iter can walk in either pre-order or
> > + * post-order. For walking ancestors, the iter walks up from a cgroup to
> > + * the root.
> > + *
> > + * The iter program can terminate the walk early by returning 1. Walk
> > + * continues if prog returns 0.
> > + *
> > + * The prog can check (seq->num == 0) to determine whether this is
> > + * the first element. The prog may also be passed a NULL cgroup,
> > + * which means the walk has completed and the prog has a chance to
> > + * do post-processing, such as outputing an epilogue.
> > + *
> > + * Note: the iter_prog is called with cgroup_mutex held.
> > + *
> > + * Currently only one session is supported, which means, depending on the
> > + * volume of data bpf program intends to send to user space, the number
> > + * of cgroups that can be walked is limited. For example, given the current
> > + * buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> > + * cgroup, the total number of cgroups that can be walked is 512. This is
>
> Again, let us specify PAGE_SIZE = 4KB here.
>

Ok.

> > + * a limitation of cgroup_iter. If the output data is larger than the
> > + * buffer size, the second read() will signal EOPNOTSUPP. In order to work
> > + * around, the user may have to update their program to reduce the volume
> > + * of data sent to output. For example, skip some uninteresting cgroups.
> > + */
> > +
> > +struct bpf_iter__cgroup {
> > +     __bpf_md_ptr(struct bpf_iter_meta *, meta);
> > +     __bpf_md_ptr(struct cgroup *, cgroup);
> > +};
> > +
> > +struct cgroup_iter_priv {
> > +     struct cgroup_subsys_state *start_css;
> > +     bool terminate;
> > +     int order;
> > +};
> > +
> > +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> > +{
> > +     struct cgroup_iter_priv *p = seq->private;
> > +
> > +     mutex_lock(&cgroup_mutex);
> > +
> > +     /* cgroup_iter doesn't support read across multiple sessions. */
> > +     if (*pos > 0)
> > +             return ERR_PTR(-EOPNOTSUPP);
>
> This is not quite right. Let us say, the number of cgroups is 1,
> after bpf program run, pos = 1, and the control return to user
> space. Now the second read() will return -EOPNOTSUPP which is not
> right. -EOPNOTSUPP should be returned ONLY if the previous cgroup
> iterations do not traverse all cgroups.
> So you might need to record additional information in cgroup_iter_priv
> to record such information.
>

Oh, I missed seeing this scenario. Then we need a flag in
cgroup_iter_priv indicating whether iter is happening. Only when
during iter hasn't ended, we return -EOPNOTSUPP.

> > +
> > +     ++*pos;
> > +     p->terminate = false;
> > +     if (p->order == BPF_ITER_CGROUP_PRE)
> > +             return css_next_descendant_pre(NULL, p->start_css);
> > +     else if (p->order == BPF_ITER_CGROUP_POST)
> > +             return css_next_descendant_post(NULL, p->start_css);
> > +     else /* BPF_ITER_CGROUP_PARENT_UP */
> > +             return p->start_css;
> > +}
> > +
> > +static int __cgroup_iter_seq_show(struct seq_file *seq,
> > +                               struct cgroup_subsys_state *css, int in_stop);
> > +
> > +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
> > +{
> > +     /* pass NULL to the prog for post-processing */
> > +     if (!v)
> > +             __cgroup_iter_seq_show(seq, NULL, true);
> > +     mutex_unlock(&cgroup_mutex);
> > +}
> > +
> > +static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > +{
> > +     struct cgroup_subsys_state *curr = (struct cgroup_subsys_state *)v;
> > +     struct cgroup_iter_priv *p = seq->private;
> > +
> > +     ++*pos;
> > +     if (p->terminate)
> > +             return NULL;
> > +
> > +     if (p->order == BPF_ITER_CGROUP_PRE)
> > +             return css_next_descendant_pre(curr, p->start_css);
> > +     else if (p->order == BPF_ITER_CGROUP_POST)
> > +             return css_next_descendant_post(curr, p->start_css);
> > +     else
> > +             return curr->parent;
> > +}
> > +
> [...]
