Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F23352ADB2
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiEQVwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiEQVw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:52:29 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3F74E3AE
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:52:27 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m1so117050wrb.8
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aMzWkBZQL9aXbZvmMQEZqAkqSC2fGMMdXYlck3K8ttk=;
        b=lRZ5GxxxrkWxHuTV9nhyvyTmdpz78TOI1zQA1xl82f7kTLOB3C3gakvuMQbXDJXl2J
         fogZI6IRq2L0TyIBR/A2xVS650k799Zw2lpmLrIq6BDVqOgi8hE7V6afS8zj/ASXKIML
         hBwLR1q4KHyqWqK02TMxkkTUfiMmnIqO/KZQUBnZY7i4cpePrAZ7IcaqWfDjdYjhsEuv
         CETs/qZ6oMbCJA3bXYsZ1e739HI5xqLkrgtNhwmuDCLZtqFcXquVY4QfqTGpKwF+W/p1
         5Nqm7UL1nc1wjchOez5kkQqqyoXFBp6pKjpGucj3YGrBFFJ489gN2zLQOxiFk0KMwXRv
         IEIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aMzWkBZQL9aXbZvmMQEZqAkqSC2fGMMdXYlck3K8ttk=;
        b=z5Dg+FLOxBKau4EJ9CRfmNfaWGOtmDVs7KirSrn6xDmN+WXjZvEhShkcFZm2Xp9Zn8
         sGjO0dAgiynfmwwK5g+5SAmzo8jOJNLHwamxVdU43UJEz9vIqiLhrtTpovWNf2UEHh11
         0aQT6ZGi1/WmjIKAz+syTAnnORk08/5nkkc4svUuExBShPZzO+8lrV+xmgdh2lyzZKxl
         v5baywP1mSOoJgaApDp4wOuMT2PBiSBLWfnyXEpVn6UKAPDdFDYxs7Z0ARfl+8PaiELt
         GO2VXPcXMKjhqbb9PGHUvU6WtoKuMVBxo8G71RsBp8RhZAydMJJOzEEjMbHZhbkY4QJ9
         XWew==
X-Gm-Message-State: AOAM530PufelgicdZLOZzyFdbE/v0RkQftuArE4J2S/oIpJ4x+moXRII
        IAqv0QUswe2ITCBd2cg8Z4X6me6Q/XXj1xjHbQYEKw==
X-Google-Smtp-Source: ABdhPJwkD4NBCsYJCrEGudQHrl3n4XCoQFQunN5fD0Av9+UeGss5C/xYh6EoMYvlQ2BTtWl6HgiteKNolpbFPYtmWKA=
X-Received: by 2002:adf:fb05:0:b0:20a:e113:8f3f with SMTP id
 c5-20020adffb05000000b0020ae1138f3fmr20501121wrr.534.1652824345517; Tue, 17
 May 2022 14:52:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220515023504.1823463-1-yosryahmed@google.com>
 <20220515023504.1823463-3-yosryahmed@google.com> <20220517020840.vyfp5cit66fs2k2o@MBP-98dd607d3435.dhcp.thefacebook.com>
In-Reply-To: <20220517020840.vyfp5cit66fs2k2o@MBP-98dd607d3435.dhcp.thefacebook.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 17 May 2022 14:51:49 -0700
Message-ID: <CAJD7tkbDtO=wDXFDDmnPLDnEeXG6JQXr=xqqeim+OEC6xTOCew@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v2 2/7] cgroup: bpf: flush bpf stats on rstat flush
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 7:08 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, May 15, 2022 at 02:34:59AM +0000, Yosry Ahmed wrote:
> > +
> > +void bpf_rstat_flush(struct cgroup *cgrp, int cpu)
> > +{
> > +     struct bpf_rstat_flusher *flusher;
> > +     struct bpf_rstat_flush_ctx ctx = {
> > +             .cgrp = cgrp,
> > +             .parent = cgroup_parent(cgrp),
> > +             .cpu = cpu,
> > +     };
> > +
> > +     rcu_read_lock();
> > +     migrate_disable();
> > +     spin_lock(&bpf_rstat_flushers_lock);
> > +
> > +     list_for_each_entry(flusher, &bpf_rstat_flushers, list)
> > +             (void) bpf_prog_run(flusher->prog, &ctx);
> > +
> > +     spin_unlock(&bpf_rstat_flushers_lock);
> > +     migrate_enable();
> > +     rcu_read_unlock();
> > +}
> > diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> > index 24b5c2ab5598..0285d496e807 100644
> > --- a/kernel/cgroup/rstat.c
> > +++ b/kernel/cgroup/rstat.c
> > @@ -2,6 +2,7 @@
> >  #include "cgroup-internal.h"
> >
> >  #include <linux/sched/cputime.h>
> > +#include <linux/bpf-rstat.h>
> >
> >  static DEFINE_SPINLOCK(cgroup_rstat_lock);
> >  static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
> > @@ -168,6 +169,7 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
> >                       struct cgroup_subsys_state *css;
> >
> >                       cgroup_base_stat_flush(pos, cpu);
> > +                     bpf_rstat_flush(pos, cpu);
>
> Please use the following approach instead:
>
> __weak noinline void bpf_rstat_flush(struct cgroup *cgrp, struct cgroup *parent, int cpu)
> {
> }
>
> and change above line to:
>   bpf_rstat_flush(pos, cgroup_parent(pos), cpu);
>
> Then tracing bpf fentry progs will be able to attach to bpf_rstat_flush.
> Pretty much the patches 1, 2, 3 are not necessary.
> In patch 4 add bpf_cgroup_rstat_updated/flush as two kfuncs instead of stable helpers.
>
> This way patches 1,2,3,4 will become 2 trivial patches and we will be
> able to extend the interface between cgroup rstat and bpf whenever we need
> without worrying about uapi stability.
>
> We had similar discusison with HID subsystem that plans to use bpf in HID
> with the same approach.
> See this patch set:
> https://lore.kernel.org/bpf/20220421140740.459558-2-benjamin.tissoires@redhat.com/
> You'd need patch 1 from it to enable kfuncs for tracing.
>
> Your patch 5 is needed as-is.
> Yonghong,
> please review it.
> Different approach for patch 1-4 won't affect patch 5.
> Patches 6 and 7 look good.
>
> With this approach that patch 7 will mostly stay as-is. Instead of:
> +SEC("rstat/flush")
> +int vmscan_flush(struct bpf_rstat_flush_ctx *ctx)
> +{
> +       struct vmscan_percpu *pcpu_stat;
> +       struct vmscan *total_stat, *parent_stat;
> +       struct cgroup *cgrp = ctx->cgrp, *parent = ctx->parent;
>
> it will become
>
> SEC("fentry/bpf_rstat_flush")
> int BPF_PROG(vmscan_flush, struct cgroup *cgrp, struct cgroup *parent, int cpu)

Thanks so much for taking the time to look into this.

Indeed, this approach looks cleaner and simpler. I will incorporate
that into a V1 and send it. Thanks!
