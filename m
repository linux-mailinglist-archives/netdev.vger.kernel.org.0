Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA6A57E853
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 22:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiGVUeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 16:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbiGVUeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 16:34:10 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B683AE5D
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 13:34:09 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id h18so4240007qvr.12
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 13:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hvLylXowG1GfsIqTvKwqcLz1Ag0GJexcuXjizvpMPq8=;
        b=bxfj665HUGlRJcOgFw5+3Bv2bh+GceeopwN+vbcm37JdCSFUaWy1x4UMJGTDSERv4S
         /C2HYm1/xkwiZHr93Xmg5SRk13tGZJJt0HBYuU42gZUcfbcUUFDDI+4o0Ghx3Q3w9Kpk
         7yXNiMyZg6iCRSWSFJ9aOqLpl2D/fb4p+pGN+UnhZKkmIukvjB7SyvzrUjUnqglqBEcr
         pRIMnFGeSLexUCfqk4YczJgzzlZ/1nE1z//77NMYFmgWFVEA4DtgArVdD2Lx9prg4Gph
         ECjKs9TO6Uq88zXQDhCK6kQZnZrp0zwzcc4btWq7WV+WD023aYbHSdaNeylAPuxy1zdw
         JfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hvLylXowG1GfsIqTvKwqcLz1Ag0GJexcuXjizvpMPq8=;
        b=iyLSrqeS9+6e4D6jzlYTFgblffLT8zTyoQFWNdmmnGxudyL+Sl5wDaQRhyOzx2VjxR
         xaV5iDeNiz3HhteKVG9d78M/oZ2D5lVkpmO4fe1mWpt2oTy2gcwYKC4XY1kU3JdPqMmf
         L1eA867HvAc8mLreLwsRd4uumohAT1a0ITkBJUGnD2CekPwazIFn7PDVq+V7EzAjzixQ
         Ob9z8RFdYiUwSkJ1ckgDPzumGhwrPnMmn4VVIgjuOouwHr/IpqoVwQbpg30OmJiCc4Zg
         +GyfN0HaX7yIB3XH/2zp6wgbjtZnPfNwJs8oqrNKLi+TfjrG/CzENolgNTKFA+3vyCfr
         Z57w==
X-Gm-Message-State: AJIora/nMoQtSlsKKdhB1QgLLAYWOhd9b7/87He5xQHSPH46Ds5JAfKy
        MfiPU8lZMYN1wjIizT7RMqPX4coh8sn3MRIQeU4muw==
X-Google-Smtp-Source: AGRyM1s8GwPX9P8LaNxdPHcvvEL2Ky7NdO2HHvMCYsOp0FqEOVBEDg9juL/Bhzv9DZiIbp0kPDd1M+nfYRxfwQiKr7Q=
X-Received: by 2002:a05:6214:202f:b0:432:4810:1b34 with SMTP id
 15-20020a056214202f00b0043248101b34mr1734796qvf.35.1658522047550; Fri, 22 Jul
 2022 13:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com> <CAP01T76p7CCj2i4X7PmZiG3G3-Bfx_ygnO0Eg+DnfwLHQiEPbA@mail.gmail.com>
In-Reply-To: <CAP01T76p7CCj2i4X7PmZiG3G3-Bfx_ygnO0Eg+DnfwLHQiEPbA@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Fri, 22 Jul 2022 13:33:56 -0700
Message-ID: <CA+khW7g2kriOb7on0u_UpGpS2A0bftrQowTB0+AJ=S7rpLKaZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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

On Fri, Jul 22, 2022 at 11:36 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, 22 Jul 2022 at 19:52, Yosry Ahmed <yosryahmed@google.com> wrote:
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
> > +               __u32   traversal_order;
> > +       } cgroup;
> >  };
> >
> >  /* BPF syscall commands, see bpf(2) man-page for more details. */
> > @@ -6136,6 +6156,16 @@ struct bpf_link_info {
> >                                         __u32 map_id;
> >                                 } map;
> >                         };
> > +                       union {
> > +                               struct {
> > +                                       __u64 cgroup_id;
> > +                                       __u32 traversal_order;
> > +                               } cgroup;
> > +                       };
> > +                       /* For new iters, if the first field is larger than __u32,
> > +                        * the struct should be added in the second union. Otherwise,
> > +                        * it will create holes before map_id, breaking uapi.
> > +                        */
> >                 } iter;
> >                 struct  {
> >                         __u32 netns_ino;
> > diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> > index 057ba8e01e70..00e05b69a4df 100644
> > --- a/kernel/bpf/Makefile
> > +++ b/kernel/bpf/Makefile
> > @@ -24,6 +24,9 @@ endif
> >  ifeq ($(CONFIG_PERF_EVENTS),y)
> >  obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
> >  endif
> > +ifeq ($(CONFIG_CGROUPS),y)
> > +obj-$(CONFIG_BPF_SYSCALL) += cgroup_iter.o
> > +endif
> >  obj-$(CONFIG_CGROUP_BPF) += cgroup.o
> >  ifeq ($(CONFIG_INET),y)
> >  obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
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
> > + * a limitation of cgroup_iter. If the output data is larger than the
> > + * buffer size, the second read() will signal EOPNOTSUPP. In order to work
> > + * around, the user may have to update their program to reduce the volume
> > + * of data sent to output. For example, skip some uninteresting cgroups.
> > + */
> > +
> > +struct bpf_iter__cgroup {
> > +       __bpf_md_ptr(struct bpf_iter_meta *, meta);
> > +       __bpf_md_ptr(struct cgroup *, cgroup);
> > +};
> > +
> > +struct cgroup_iter_priv {
> > +       struct cgroup_subsys_state *start_css;
> > +       bool terminate;
> > +       int order;
> > +};
> > +
> > +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> > +{
> > +       struct cgroup_iter_priv *p = seq->private;
> > +
> > +       mutex_lock(&cgroup_mutex);
> > +
> > +       /* cgroup_iter doesn't support read across multiple sessions. */
> > +       if (*pos > 0)
> > +               return ERR_PTR(-EOPNOTSUPP);
> > +
> > +       ++*pos;
> > +       p->terminate = false;
> > +       if (p->order == BPF_ITER_CGROUP_PRE)
> > +               return css_next_descendant_pre(NULL, p->start_css);
> > +       else if (p->order == BPF_ITER_CGROUP_POST)
> > +               return css_next_descendant_post(NULL, p->start_css);
> > +       else /* BPF_ITER_CGROUP_PARENT_UP */
> > +               return p->start_css;
> > +}
> > +
> > +static int __cgroup_iter_seq_show(struct seq_file *seq,
> > +                                 struct cgroup_subsys_state *css, int in_stop);
> > +
> > +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
> > +{
> > +       /* pass NULL to the prog for post-processing */
> > +       if (!v)
> > +               __cgroup_iter_seq_show(seq, NULL, true);
> > +       mutex_unlock(&cgroup_mutex);
>
> I'm just curious, but would it be a good optimization (maybe in a
> follow up) to move this mutex_unlock before the check on v? That
> allows you to store/buffer some info you want to print as a compressed
> struct in a map, then write the full text to the seq_file outside the
> cgroup_mutex lock in the post-processing invocation.
>
> It probably also allows you to walk the whole hierarchy, if one
> doesn't want to run into seq_file buffer limit (or it can decide what
> to print within the limit in the post processing invocation), or it
> can use some out of band way (ringbuf, hashmap, etc.) to send the data
> to userspace. But all of this can happen without holding cgroup_mutex
> lock.

Thanks Kumar.

It sounds like an idea, but the key thing is not about moving
cgroup_mutex unlock before the check IMHO. The user can achieve
compression using the current infra. Compression could actually be
done in the bpf program. user can define and output binary content and
implement a userspace library to parse/decompress when reading out the
data.
