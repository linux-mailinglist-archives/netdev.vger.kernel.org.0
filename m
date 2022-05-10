Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A3A5224AC
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242337AbiEJTWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239148AbiEJTWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:22:34 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFF141FBF
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:22:32 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t6so5716wra.4
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Fl8o9vqQHXkRhUTsCQTt0ZwmTbCavxp1lBY7KQiqEg=;
        b=pkDBIQ1JUSjCleZwrCt2twDTUFGkjIiJdVzHRqsAFXYvU6t3uG3j9YEIViHc1bLVZ0
         xmGV58tfipuAmPW6p2t+DuGRAOG7tkEU5Qb5+9XUmjus9jZgLhdHz7IfuIC6Y86Lqsdf
         Bl1r4bSO9g+1dm9xehEclH8k/9oVpuSpJS5mpVOuw5qvAJvkEcTWZnmDAzP7p/rRDxqG
         i6lZZDHsR4hjFrH3O6DOSaO/MJzIt6gQAa/HgkYpXK6oJ2qcP4A0QKaEThwxiUwEspwy
         IeasyHDjxpI1m/oCNWRrL2t1TNBBaEKzDzga5zP9tmXkf98N5lS1Uimpkgsu47CQ7zhb
         RuPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Fl8o9vqQHXkRhUTsCQTt0ZwmTbCavxp1lBY7KQiqEg=;
        b=JqxBTg2/3UhJDpC+/KU2Ttrwwk8KBrIdcD0G/ryYaQUYJ15QfpaZpdFg5/9xFMjJGf
         EVAYkezxPkrjFvlDE3FX4ufwZkBUonWMNU/uKD60BtrIOFnH/sLX3vXs3u3SRjad2mEl
         fkFW/9ACMYI/ItQ6UMTtnnitIRb6WBnTu7bxaprCDiPTQNOnrqEb89OQwuHtWTqbFGaP
         sUndpdwyF4p5vD4+/OArfb5NB6Ce7cWDizJP3upK/dtcRvt02LhRWBzzZwjOti8YvELA
         KnctFInVO7Ob6JlE7+n/sFOKAOkvlp+6Iw3RZDucSmpJ23wnV1BPI5Ro1wZ8spudSSt5
         UZoA==
X-Gm-Message-State: AOAM531tE0Kty365NSI5hpDkp1ZrCSwPIB+SSW2uxNHiKtdiaTvsfquS
        9z1uE0UfYa6CyO1Clf+BC+ZFdTrulbmcU7IpDR7iEA==
X-Google-Smtp-Source: ABdhPJyZnQDpgfxwzi9pPMAY3OAG3r6SkU6RhijFLHdLaYzcXNiwHcp/YCCKUM0F9rdqDaQAia6Q9raCLSuhGql5zAU=
X-Received: by 2002:a05:6000:154a:b0:20c:7e65:c79e with SMTP id
 10-20020a056000154a00b0020c7e65c79emr19981471wry.582.1652210550757; Tue, 10
 May 2022 12:22:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com> <CAJD7tkYHGE1h2jJ7xT9CN7Bbf4+YJ86CoieAv_gmD+Ho=jNrcg@mail.gmail.com>
In-Reply-To: <CAJD7tkYHGE1h2jJ7xT9CN7Bbf4+YJ86CoieAv_gmD+Ho=jNrcg@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 10 May 2022 12:21:54 -0700
Message-ID: <CAJD7tkYF8W_MaWuWJmy+g-aU=kGm5=BWyHtkV-0FmGJ7xqB=rg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 11:07 AM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Mon, May 9, 2022 at 5:18 PM Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > This patch introduces a new bpf program type CGROUP_SUBSYS_RSTAT,
> > with new corresponding link and attach types.
> >
> > The main purpose of these programs is to allow BPF programs to collect
> > and maintain hierarchical cgroup stats easily and efficiently by making
> > using of the rstat framework in the kernel.
> >
> > Those programs attach to a cgroup subsystem. They typically contain logic
> > to aggregate per-cpu and per-cgroup stats collected by other BPF programs.
> >
> > Currently, only rstat flusher programs can be attached to cgroup
> > subsystems, but this can be extended later if a use-case arises.
> >
> > See the selftest in the final patch for a practical example.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >  include/linux/bpf-cgroup-subsys.h |  30 ++++++
> >  include/linux/bpf_types.h         |   2 +
> >  include/linux/cgroup-defs.h       |   4 +
> >  include/uapi/linux/bpf.h          |  12 +++
> >  kernel/bpf/Makefile               |   1 +
> >  kernel/bpf/cgroup_subsys.c        | 166 ++++++++++++++++++++++++++++++
> >  kernel/bpf/syscall.c              |   6 ++
> >  kernel/cgroup/cgroup.c            |   1 +
> >  tools/include/uapi/linux/bpf.h    |  12 +++
> >  9 files changed, 234 insertions(+)
> >  create mode 100644 include/linux/bpf-cgroup-subsys.h
> >  create mode 100644 kernel/bpf/cgroup_subsys.c
> >
> > diff --git a/include/linux/bpf-cgroup-subsys.h b/include/linux/bpf-cgroup-subsys.h
> > new file mode 100644
> > index 000000000000..4dcde06b5599
> > --- /dev/null
> > +++ b/include/linux/bpf-cgroup-subsys.h
> > @@ -0,0 +1,30 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright 2022 Google LLC.
> > + */
> > +#ifndef _BPF_CGROUP_SUBSYS_H_
> > +#define _BPF_CGROUP_SUBSYS_H_
> > +
> > +#include <linux/bpf.h>
> > +
> > +struct cgroup_subsys_bpf {
> > +       /* Head of the list of BPF rstat flushers attached to this subsystem */
> > +       struct list_head rstat_flushers;
> > +       spinlock_t flushers_lock;
> > +};
> > +
> > +struct bpf_subsys_rstat_flusher {
> > +       struct bpf_prog *prog;
> > +       /* List of BPF rtstat flushers, anchored at subsys->bpf */
> > +       struct list_head list;
> > +};
> > +
> > +struct bpf_cgroup_subsys_link {
> > +       struct bpf_link link;
> > +       struct cgroup_subsys *ss;
> > +};
> > +
> > +int cgroup_subsys_bpf_link_attach(const union bpf_attr *attr,
> > +                                 struct bpf_prog *prog);
> > +
>
> In the next version I will make sure everything here is also defined
> for when CONFIG_BPF_SYSCALL is not set, and move the structs that can
> be moved to the cc file there.
>
> > +#endif  // _BPF_CGROUP_SUBSYS_H_
> > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> > index 3e24ad0c4b3c..854ee958b0e4 100644
> > --- a/include/linux/bpf_types.h
> > +++ b/include/linux/bpf_types.h
> > @@ -56,6 +56,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SYSCTL, cg_sysctl,
> >               struct bpf_sysctl, struct bpf_sysctl_kern)
> >  BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCKOPT, cg_sockopt,
> >               struct bpf_sockopt, struct bpf_sockopt_kern)
> > +BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SUBSYS_RSTAT, cgroup_subsys_rstat,
> > +             struct bpf_rstat_ctx, struct bpf_rstat_ctx)
> >  #endif
> >  #ifdef CONFIG_BPF_LIRC_MODE2
> >  BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2,
> > diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> > index 1bfcfb1af352..3bd6eed1fa13 100644
> > --- a/include/linux/cgroup-defs.h
> > +++ b/include/linux/cgroup-defs.h
> > @@ -20,6 +20,7 @@
> >  #include <linux/u64_stats_sync.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/bpf-cgroup-defs.h>
> > +#include <linux/bpf-cgroup-subsys.h>
> >  #include <linux/psi_types.h>
> >
> >  #ifdef CONFIG_CGROUPS
> > @@ -706,6 +707,9 @@ struct cgroup_subsys {
> >          * specifies the mask of subsystems that this one depends on.
> >          */
> >         unsigned int depends_on;
> > +
> > +       /* used to store bpf programs.*/
> > +       struct cgroup_subsys_bpf bpf;
> >  };
> >
> >  extern struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index d14b10b85e51..0f4855fa85db 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -952,6 +952,7 @@ enum bpf_prog_type {
> >         BPF_PROG_TYPE_LSM,
> >         BPF_PROG_TYPE_SK_LOOKUP,
> >         BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> > +       BPF_PROG_TYPE_CGROUP_SUBSYS_RSTAT,
> >  };
> >
> >  enum bpf_attach_type {
> > @@ -998,6 +999,7 @@ enum bpf_attach_type {
> >         BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> >         BPF_PERF_EVENT,
> >         BPF_TRACE_KPROBE_MULTI,
> > +       BPF_CGROUP_SUBSYS_RSTAT,
> >         __MAX_BPF_ATTACH_TYPE
> >  };
> >
> > @@ -1013,6 +1015,7 @@ enum bpf_link_type {
> >         BPF_LINK_TYPE_XDP = 6,
> >         BPF_LINK_TYPE_PERF_EVENT = 7,
> >         BPF_LINK_TYPE_KPROBE_MULTI = 8,
> > +       BPF_LINK_TYPE_CGROUP_SUBSYS = 9,
> >
> >         MAX_BPF_LINK_TYPE,
> >  };
> > @@ -1482,6 +1485,9 @@ union bpf_attr {
> >                                  */
> >                                 __u64           bpf_cookie;
> >                         } perf_event;
> > +                       struct {
> > +                               __u64           name;
> > +                       } cgroup_subsys;
> >                         struct {
> >                                 __u32           flags;
> >                                 __u32           cnt;
> > @@ -6324,6 +6330,12 @@ struct bpf_cgroup_dev_ctx {
> >         __u32 minor;
> >  };
> >
> > +struct bpf_rstat_ctx {
> > +       __u64 cgroup_id;
> > +       __u64 parent_cgroup_id; /* 0 if root */
> > +       __s32 cpu;
> > +};
> > +
> >  struct bpf_raw_tracepoint_args {
> >         __u64 args[0];
> >  };
> > diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> > index c1a9be6a4b9f..6caf4a61e543 100644
> > --- a/kernel/bpf/Makefile
> > +++ b/kernel/bpf/Makefile
> > @@ -25,6 +25,7 @@ ifeq ($(CONFIG_PERF_EVENTS),y)
> >  obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
> >  endif
> >  obj-$(CONFIG_CGROUP_BPF) += cgroup.o
> > +obj-$(CONFIG_CGROUP_BPF) += cgroup_subsys.o
>
> In the next version I will replace this with:
> ifeq ($(CONFIG_CGROUP),y)
> obj-$(CONFIG_BPF_SYSCALL) += cgroup_subsys.o
> endif
>
> , as this program type doesn't attach to cgroups and does not depend
> on CONFIG_CGROUP_BPF, only CONFIG_CGROUP and CONFIG_BPF_SYSCALL.

On second thought it might be simpler and cleaner to leave this code
under CONFIG_CGROUP_BPF.

>
> >  ifeq ($(CONFIG_INET),y)
> >  obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
> >  endif
> > diff --git a/kernel/bpf/cgroup_subsys.c b/kernel/bpf/cgroup_subsys.c
> > new file mode 100644
> > index 000000000000..9673ce6aa84a
> > --- /dev/null
> > +++ b/kernel/bpf/cgroup_subsys.c
> > @@ -0,0 +1,166 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Functions to manage eBPF programs attached to cgroup subsystems
> > + *
> > + * Copyright 2022 Google LLC.
> > + */
> > +
> > +#include <linux/bpf-cgroup-subsys.h>
> > +#include <linux/filter.h>
> > +
> > +#include "../cgroup/cgroup-internal.h"
> > +
> > +
> > +static int cgroup_subsys_bpf_attach(struct cgroup_subsys *ss, struct bpf_prog *prog)
> > +{
> > +       struct bpf_subsys_rstat_flusher *rstat_flusher;
> > +
> > +       rstat_flusher = kmalloc(sizeof(*rstat_flusher), GFP_KERNEL);
> > +       if (!rstat_flusher)
> > +               return -ENOMEM;
> > +       rstat_flusher->prog = prog;
> > +
> > +       spin_lock(&ss->bpf.flushers_lock);
> > +       list_add(&rstat_flusher->list, &ss->bpf.rstat_flushers);
> > +       spin_unlock(&ss->bpf.flushers_lock);
> > +
> > +       return 0;
> > +}
> > +
> > +static void cgroup_subsys_bpf_detach(struct cgroup_subsys *ss, struct bpf_prog *prog)
> > +{
> > +       struct bpf_subsys_rstat_flusher *rstat_flusher = NULL;
> > +
> > +       spin_lock(&ss->bpf.flushers_lock);
> > +       list_for_each_entry(rstat_flusher, &ss->bpf.rstat_flushers, list)
> > +               if (rstat_flusher->prog == prog)
> > +                       break;
> > +
> > +       if (rstat_flusher) {
> > +               list_del(&rstat_flusher->list);
> > +               bpf_prog_put(rstat_flusher->prog);
> > +               kfree(rstat_flusher);
> > +       }
> > +       spin_unlock(&ss->bpf.flushers_lock);
> > +}
> > +
> > +static void bpf_cgroup_subsys_link_release(struct bpf_link *link)
> > +{
> > +       struct bpf_cgroup_subsys_link *ss_link = container_of(link,
> > +                                                      struct bpf_cgroup_subsys_link,
> > +                                                      link);
> > +       if (ss_link->ss) {
> > +               cgroup_subsys_bpf_detach(ss_link->ss, ss_link->link.prog);
> > +               ss_link->ss = NULL;
> > +       }
> > +}
> > +
> > +static int bpf_cgroup_subsys_link_detach(struct bpf_link *link)
> > +{
> > +       bpf_cgroup_subsys_link_release(link);
> > +       return 0;
> > +}
> > +
> > +static void bpf_cgroup_subsys_link_dealloc(struct bpf_link *link)
> > +{
> > +       struct bpf_cgroup_subsys_link *ss_link = container_of(link,
> > +                                                      struct bpf_cgroup_subsys_link,
> > +                                                      link);
> > +       kfree(ss_link);
> > +}
> > +
> > +static const struct bpf_link_ops bpf_cgroup_subsys_link_lops = {
> > +       .detach = bpf_cgroup_subsys_link_detach,
> > +       .release = bpf_cgroup_subsys_link_release,
> > +       .dealloc = bpf_cgroup_subsys_link_dealloc,
> > +};
> > +
> > +int cgroup_subsys_bpf_link_attach(const union bpf_attr *attr,
> > +                                 struct bpf_prog *prog)
> > +{
> > +       struct bpf_link_primer link_primer;
> > +       struct bpf_cgroup_subsys_link *link;
> > +       struct cgroup_subsys *ss, *attach_ss = NULL;
> > +       const char __user *ss_name_user;
> > +       char ss_name[MAX_CGROUP_TYPE_NAMELEN];
> > +       int ssid, err;
> > +
> > +       if (attr->link_create.target_fd || attr->link_create.flags)
> > +               return -EINVAL;
> > +
> > +       ss_name_user = u64_to_user_ptr(attr->link_create.cgroup_subsys.name);
> > +       if (strncpy_from_user(ss_name, ss_name_user, sizeof(ss_name) - 1) < 0)
> > +               return -EFAULT;
> > +
> > +       for_each_subsys(ss, ssid)
> > +               if (!strcmp(ss_name, ss->name) ||
> > +                   !strcmp(ss_name, ss->legacy_name))
> > +                       attach_ss = ss;
> > +
> > +       if (!attach_ss)
> > +               return -EINVAL;
> > +
> > +       link = kzalloc(sizeof(*link), GFP_USER);
> > +       if (!link)
> > +               return -ENOMEM;
> > +
> > +       bpf_link_init(&link->link, BPF_LINK_TYPE_CGROUP_SUBSYS,
> > +                     &bpf_cgroup_subsys_link_lops,
> > +                     prog);
> > +       link->ss = attach_ss;
> > +
> > +       err = bpf_link_prime(&link->link, &link_primer);
> > +       if (err) {
> > +               kfree(link);
> > +               return err;
> > +       }
> > +
> > +       err = cgroup_subsys_bpf_attach(attach_ss, prog);
> > +       if (err) {
> > +               bpf_link_cleanup(&link_primer);
> > +               return err;
> > +       }
> > +
> > +       return bpf_link_settle(&link_primer);
> > +}
> > +
> > +static const struct bpf_func_proto *
> > +cgroup_subsys_rstat_func_proto(enum bpf_func_id func_id,
> > +                              const struct bpf_prog *prog)
> > +{
> > +       return bpf_base_func_proto(func_id);
> > +}
> > +
> > +static bool cgroup_subsys_rstat_is_valid_access(int off, int size,
> > +                                          enum bpf_access_type type,
> > +                                          const struct bpf_prog *prog,
> > +                                          struct bpf_insn_access_aux *info)
> > +{
> > +       if (type == BPF_WRITE)
> > +               return false;
> > +
> > +       if (off < 0 || off + size > sizeof(struct bpf_rstat_ctx))
> > +               return false;
> > +       /* The verifier guarantees that size > 0 */
> > +       if (off % size != 0)
> > +               return false;
> > +
> > +       switch (off) {
> > +       case offsetof(struct bpf_rstat_ctx, cgroup_id):
> > +               return size == sizeof(__u64);
> > +       case offsetof(struct bpf_rstat_ctx, parent_cgroup_id):
> > +               return size == sizeof(__u64);
> > +       case offsetof(struct bpf_rstat_ctx, cpu):
> > +               return size == sizeof(__s32);
> > +       default:
> > +               return false;
> > +       }
> > +}
> > +
> > +const struct bpf_prog_ops cgroup_subsys_rstat_prog_ops = {
> > +};
> > +
> > +const struct bpf_verifier_ops cgroup_subsys_rstat_verifier_ops = {
> > +       .get_func_proto         = cgroup_subsys_rstat_func_proto,
> > +       .is_valid_access        = cgroup_subsys_rstat_is_valid_access,
> > +};
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index cdaa1152436a..48149c54d969 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -3,6 +3,7 @@
> >   */
> >  #include <linux/bpf.h>
> >  #include <linux/bpf-cgroup.h>
> > +#include <linux/bpf-cgroup-subsys.h>
> >  #include <linux/bpf_trace.h>
> >  #include <linux/bpf_lirc.h>
> >  #include <linux/bpf_verifier.h>
> > @@ -3194,6 +3195,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
> >                 return BPF_PROG_TYPE_SK_LOOKUP;
> >         case BPF_XDP:
> >                 return BPF_PROG_TYPE_XDP;
> > +       case BPF_CGROUP_SUBSYS_RSTAT:
> > +               return BPF_PROG_TYPE_CGROUP_SUBSYS_RSTAT;
> >         default:
> >                 return BPF_PROG_TYPE_UNSPEC;
> >         }
> > @@ -4341,6 +4344,9 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
> >                 else
> >                         ret = bpf_kprobe_multi_link_attach(attr, prog);
> >                 break;
> > +       case BPF_PROG_TYPE_CGROUP_SUBSYS_RSTAT:
> > +               ret = cgroup_subsys_bpf_link_attach(attr, prog);
> > +               break;
> >         default:
> >                 ret = -EINVAL;
> >         }
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index adb820e98f24..7b1448013009 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -5745,6 +5745,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
> >
> >         idr_init(&ss->css_idr);
> >         INIT_LIST_HEAD(&ss->cfts);
> > +       INIT_LIST_HEAD(&ss->bpf.rstat_flushers);
> >
> >         /* Create the root cgroup state for this subsystem */
> >         ss->root = &cgrp_dfl_root;
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index d14b10b85e51..0f4855fa85db 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -952,6 +952,7 @@ enum bpf_prog_type {
> >         BPF_PROG_TYPE_LSM,
> >         BPF_PROG_TYPE_SK_LOOKUP,
> >         BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> > +       BPF_PROG_TYPE_CGROUP_SUBSYS_RSTAT,
> >  };
> >
> >  enum bpf_attach_type {
> > @@ -998,6 +999,7 @@ enum bpf_attach_type {
> >         BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> >         BPF_PERF_EVENT,
> >         BPF_TRACE_KPROBE_MULTI,
> > +       BPF_CGROUP_SUBSYS_RSTAT,
> >         __MAX_BPF_ATTACH_TYPE
> >  };
> >
> > @@ -1013,6 +1015,7 @@ enum bpf_link_type {
> >         BPF_LINK_TYPE_XDP = 6,
> >         BPF_LINK_TYPE_PERF_EVENT = 7,
> >         BPF_LINK_TYPE_KPROBE_MULTI = 8,
> > +       BPF_LINK_TYPE_CGROUP_SUBSYS = 9,
> >
> >         MAX_BPF_LINK_TYPE,
> >  };
> > @@ -1482,6 +1485,9 @@ union bpf_attr {
> >                                  */
> >                                 __u64           bpf_cookie;
> >                         } perf_event;
> > +                       struct {
> > +                               __u64           name;
> > +                       } cgroup_subsys;
> >                         struct {
> >                                 __u32           flags;
> >                                 __u32           cnt;
> > @@ -6324,6 +6330,12 @@ struct bpf_cgroup_dev_ctx {
> >         __u32 minor;
> >  };
> >
> > +struct bpf_rstat_ctx {
> > +       __u64 cgroup_id;
> > +       __u64 parent_cgroup_id; /* 0 if root */
> > +       __s32 cpu;
> > +};
> > +
> >  struct bpf_raw_tracepoint_args {
> >         __u64 args[0];
> >  };
> > --
> > 2.36.0.512.ge40c2bad7a-goog
> >
