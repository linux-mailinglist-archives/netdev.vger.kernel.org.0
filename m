Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0995C52F074
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351559AbiETQUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351538AbiETQUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:20:50 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD75559F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:20:45 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j25so12137982wrc.9
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GarL2Kn/zNIJwCptfjfJ4swfJzGY6bIsUnYiG/oxiuI=;
        b=TtgVg9kR94FReHMcINrx3ZC/s6A7a4psy4/9RGzmCb8xCqRJZPWW8LNcgsK1sWrGU5
         ho2BYDZmtkjRspH22M5aAr+RU9dkyIOmWM4MwgpfWKF/iGU0tz/r5P67ilQptFsP60xT
         Q3gKb4yQ1eQudnLBQXSua2hijgHXcJ97MVbOBBeKTXZ3SHjyElxW0IrGEgvIles1NlSY
         zYVejH5s8+UGST9GpZVVizOO2UpSavsx1LEFhvf99w/sp5+VrNr/M6yaapC2S09Vbn0u
         YALTWwv9FeqDgRBHzzPava+DO/9LNGzsLNp0LCHcsRE5JDGH6JkMH01Az6bZ7IeMUK6f
         0OUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GarL2Kn/zNIJwCptfjfJ4swfJzGY6bIsUnYiG/oxiuI=;
        b=bQzAU6xCwc/WWFKkPu1uBT0+VV62GQgYAYJ8j/4N0ynFIM04OFA7HpMu7xAUpoMMu7
         IDMmDu0dV23ZjSuwGffe0he79A1jnKyYVusSNfYzrrob9NSgDGxoCXRVDB04Ui/dGOh/
         4pt8wHYsVxVLuHcE02gkoFX7do+zv4AGXsgoR6khePUJUU7/R+VJbcoVH6EBKB+PkBT0
         +joVZL0ZyfyyyVi7am/xGqg1JTIh1wscATHMW+KhPFAWmzJDNmD21PP1LUp2efhIjs6C
         LHe6WuMEO9KQ5WaT3ElP5suJOHiNcOa/k/bO1UZAh3nmIGymYLp8LSfmAXDZp4csGjfJ
         HbUg==
X-Gm-Message-State: AOAM533pmKHi0u2PpxWG8G5U63dou4wxN/Uvnozm7DtNkQ0KorMggtrc
        7LwOXqWfUAAtnUUubusGRk15viqQp+tzIIRTzEb52w==
X-Google-Smtp-Source: ABdhPJwXihn6Eo/eN5yZSzV0l8oNjnwxVa2GX1v/ldHoA3ps70mSdd2dNpogTkqoScf7BEeYJR9EV+TAX3/KMcgAu7o=
X-Received: by 2002:adf:f042:0:b0:20e:5be7:f473 with SMTP id
 t2-20020adff042000000b0020e5be7f473mr8983437wro.80.1653063643790; Fri, 20 May
 2022 09:20:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com> <fa3b35a6-5c3c-42a1-23f0-a8143b4eaa57@fb.com>
 <CAJD7tkanipJ7-9H_L6KMUjpD2qS29-YCrnMXw+8BAKfbOk5P9Q@mail.gmail.com> <eca39189-9258-b1cc-0a1d-a0d7e6027861@fb.com>
In-Reply-To: <eca39189-9258-b1cc-0a1d-a0d7e6027861@fb.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 20 May 2022 09:20:07 -0700
Message-ID: <CAJD7tkZq_GE-nR3UUwXJ+iE9WCDv9HN2MtT8as4bg2NKcNc3xQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
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
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, May 20, 2022 at 9:16 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/20/22 9:08 AM, Yosry Ahmed wrote:
> > On Fri, May 20, 2022 at 8:15 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 5/19/22 6:21 PM, Yosry Ahmed wrote:
> >>> Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
> >>> tracing programs. bpf programs that make use of rstat can use these
> >>> functions to inform rstat when they update stats for a cgroup, and wh=
en
> >>> they need to flush the stats.
> >>>
> >>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> >>> ---
> >>>    kernel/cgroup/rstat.c | 35 ++++++++++++++++++++++++++++++++++-
> >>>    1 file changed, 34 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> >>> index e7a88d2600bd..a16a851bc0a1 100644
> >>> --- a/kernel/cgroup/rstat.c
> >>> +++ b/kernel/cgroup/rstat.c
> >>> @@ -3,6 +3,11 @@
> >>>
> >>>    #include <linux/sched/cputime.h>
> >>>
> >>> +#include <linux/bpf.h>
> >>> +#include <linux/btf.h>
> >>> +#include <linux/btf_ids.h>
> >>> +
> >>> +
> >>>    static DEFINE_SPINLOCK(cgroup_rstat_lock);
> >>>    static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
> >>>
> >>> @@ -141,7 +146,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updat=
ed(struct cgroup *pos,
> >>>        return pos;
> >>>    }
> >>>
> >>> -/* A hook for bpf stat collectors to attach to and flush their stats=
 */
> >>> +/*
> >>> + * A hook for bpf stat collectors to attach to and flush their stats=
.
> >>> + * Together with providing bpf kfuncs for cgroup_rstat_updated() and
> >>> + * cgroup_rstat_flush(), this enables a complete workflow where bpf =
progs that
> >>> + * collect cgroup stats can integrate with rstat for efficient flush=
ing.
> >>> + */
> >>>    __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
> >>>                                     struct cgroup *parent, int cpu)
> >>>    {
> >>> @@ -476,3 +486,26 @@ void cgroup_base_stat_cputime_show(struct seq_fi=
le *seq)
> >>>                   "system_usec %llu\n",
> >>>                   usage, utime, stime);
> >>>    }
> >>> +
> >>> +/* Add bpf kfuncs for cgroup_rstat_updated() and cgroup_rstat_flush(=
) */
> >>> +BTF_SET_START(bpf_rstat_check_kfunc_ids)
> >>> +BTF_ID(func, cgroup_rstat_updated)
> >>> +BTF_ID(func, cgroup_rstat_flush)
> >>> +BTF_SET_END(bpf_rstat_check_kfunc_ids)
> >>> +
> >>> +BTF_SET_START(bpf_rstat_sleepable_kfunc_ids)
> >>> +BTF_ID(func, cgroup_rstat_flush)
> >>> +BTF_SET_END(bpf_rstat_sleepable_kfunc_ids)
> >>> +
> >>> +static const struct btf_kfunc_id_set bpf_rstat_kfunc_set =3D {
> >>> +     .owner          =3D THIS_MODULE,
> >>> +     .check_set      =3D &bpf_rstat_check_kfunc_ids,
> >>> +     .sleepable_set  =3D &bpf_rstat_sleepable_kfunc_ids,
> >>
> >> There is a compilation error here:
> >>
> >> kernel/cgroup/rstat.c:503:3: error: =E2=80=98const struct btf_kfunc_id=
_set=E2=80=99 has
> >> no member named =E2=80=98sleepable_set=E2=80=99; did you mean =E2=80=
=98release_set=E2=80=99?
> >>       503 |  .sleepable_set =3D &bpf_rstat_sleepable_kfunc_ids,
> >>           |   ^~~~~~~~~~~~~
> >>           |   release_set
> >>     kernel/cgroup/rstat.c:503:19: warning: excess elements in struct
> >> initializer
> >>       503 |  .sleepable_set =3D &bpf_rstat_sleepable_kfunc_ids,
> >>           |                   ^
> >>     kernel/cgroup/rstat.c:503:19: note: (near initialization for
> >> =E2=80=98bpf_rstat_kfunc_set=E2=80=99)
> >>     make[3]: *** [scripts/Makefile.build:288: kernel/cgroup/rstat.o] E=
rror 1
> >>
> >> Please fix.
> >
> > This patch series is rebased on top of 2 patches in the mailing list:
> > - bpf/btf: also allow kfunc in tracing and syscall programs
> > - btf: Add a new kfunc set which allows to mark a function to be
> >    sleepable
> >
> > I specified this in the cover letter, do I need to do something else
> > in this situation? Re-send the patches as part of my series?
>
> At least put a link in the cover letter for the above two patches?
> This way, people can easily find them to double check.

Right. Will do this in the next version. Sorry for the inconvenience.

>
> >
> >
> >
> >>
> >>> +};
> >>> +
> >>> +static int __init bpf_rstat_kfunc_init(void)
> >>> +{
> >>> +     return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
> >>> +                                      &bpf_rstat_kfunc_set);
> >>> +}
> >>> +late_initcall(bpf_rstat_kfunc_init);
