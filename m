Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121EB2A6F2D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 21:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbgKDUuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 15:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbgKDUuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 15:50:37 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB830C0613D3;
        Wed,  4 Nov 2020 12:50:36 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id n142so23349ybf.7;
        Wed, 04 Nov 2020 12:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wDpBtkx/IQaLSwvU9IJBZpBWHgQXXfzDxZ7n4MKg6hQ=;
        b=IqFwuk35iIAnGCtNv7LEH2qb6XYrZRYW5oPYuAqsiozqKa4PKj2RYkUuYMrc68DwYv
         8vGcbo3o3tGut4kQkj7PDYYzthDnBYwR/BbXUnRTn1cld026r5G2bVGWndewsHSSWylH
         oUk7leDy0qPKdL17b4+xz1stgVCQm8mN93uG79NOMty+tQZ2OfGpCRnh4kTUlhKK+WvO
         r0YdL9WMDA5+6+0lpYE0R8LbqAMIOEqX8SkV+fSO5aBY15CWtDOQuzzYvHWSrtwwzRwY
         9xy117fB9xGsacwUsS7zpPmBz91pVlvj3qiVyWAhnConN1N2/lYIcTwc5ph/1VJT90Ec
         lyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wDpBtkx/IQaLSwvU9IJBZpBWHgQXXfzDxZ7n4MKg6hQ=;
        b=Tz9Qxlt6niru0AyuUM4NxsCaraYay81OR/NsH+F9vwBigNHBEpf4E3ilBJ4NTBKHRT
         lOzyp4qC7xVnfAblRJcZUOESXTmsGJrLD8P8PT+uK28WbZb1J2t7GZOne38SQs0Xoj8M
         m6qnLf8bavqM7oh1HOp19c+QQV+oiHTMwhHBwp+MOBsSzAZip+Ygz6U0qa2SZ0WWHyOT
         VOV6IVSWjAdF7HWCRwHmC4LGtvdY+vY58oQYtmx7BJvJ27B6u+Xcm9OJT4Viajr5EGKd
         pM8Uh6vuemTdZDA8lH6jRSI4DMUGuKvPrw6XXH6Qj2bpRgXRaCps0XIrW3hnhnidRhgj
         +L2A==
X-Gm-Message-State: AOAM532TkRISpgoeTlH0osbaZaLSOKr7WLHxmQdpW1AMy5+J85/ZtnSC
        3ADVTbSjiLSanZgEDqsUppCOKdGXi0SNNDjpAr0=
X-Google-Smtp-Source: ABdhPJyZQTun7PPm5sMWC7kS42O7xCAUXYmijtWjLcZP2MpK0sRKW5DWIwHcN5UCsKqQd6nYrydCjgtFC1uwDr9G/Tc=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr39602661ybl.347.1604523036195;
 Wed, 04 Nov 2020 12:50:36 -0800 (PST)
MIME-Version: 1.0
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-4-alexei.starovoitov@gmail.com> <20201013195622.GB1305928@krava>
 <CAADnVQLYSk0YgK7_dUSF-5Rau10vOdDgosVhE9xmEr1dp+=2vg@mail.gmail.com>
 <CAEf4BzbWO3fgWxAWQw4Pee=F7=UqU+N6LtKYV7V9ZZrfkPZ3gw@mail.gmail.com>
 <561A9F0C-BDAE-406A-8B93-011ECAB22B1C@fb.com> <20201104164215.GH3861143@krava>
In-Reply-To: <20201104164215.GH3861143@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Nov 2020 12:50:25 -0800
Message-ID: <CAEf4BzacV0TpXSk4giLKmLBCvARH-Jpgp6Pa5br2wHO3_A2-9w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 8:46 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Oct 15, 2020 at 06:09:14AM +0000, Song Liu wrote:
> >
> >
> > > On Oct 13, 2020, at 2:56 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > [...]
> >
> > >
> > > I'd go with Kconfig + bpf_core_enum_value(), as it's shorter and
> > > nicer. This compiles and works with my Kconfig, but I haven't checked
> > > with CONFIG_CGROUP_PIDS defined.
> >
> > Tested with CONFIG_CGROUP_PIDS, it looks good.
> >
> > Tested-by: Song Liu <songliubraving@fb.com>
>
> hi,
> I still need to apply my workaround to compile tests,
> so I wonder this fell through cracks


The fix was already applied ([0]). Do you still see issues?

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20201022202739.3667367-1-andrii@kernel.org/

>
> thanks,
> jirka
>
> >
> > >
> > >
> > > diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > b/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > index 00578311a423..79b8d2860a5c 100644
> > > --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > @@ -243,7 +243,11 @@ static ino_t get_inode_from_kernfs(struct
> > > kernfs_node* node)
> > >        }
> > > }
> > >
> > > -int pids_cgrp_id = 1;
> > > +extern bool CONFIG_CGROUP_PIDS __kconfig __weak;
> > > +
> > > +enum cgroup_subsys_id___local {
> > > +       pids_cgrp_id___local = 1, /* anything but zero */
> > > +};
> > >
> > > static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_data,
> > >                                         struct task_struct* task,
> > > @@ -253,7 +257,9 @@ static INLINE void* populate_cgroup_info(struct
> > > cgroup_data_t* cgroup_data,
> > >                BPF_CORE_READ(task, nsproxy, cgroup_ns, root_cset,
> > > dfl_cgrp, kn);
> > >        struct kernfs_node* proc_kernfs = BPF_CORE_READ(task, cgroups,
> > > dfl_cgrp, kn);
> > >
> > > -       if (ENABLE_CGROUP_V1_RESOLVER) {
> > > +       if (ENABLE_CGROUP_V1_RESOLVER && CONFIG_CGROUP_PIDS) {
> > > +               int cgrp_id = bpf_core_enum_value(enum
> > > cgroup_subsys_id___local, pids_cgrp_id___local);
> > > +
> > > #ifdef UNROLL
> > > #pragma unroll
> > > #endif
> > > @@ -262,7 +268,7 @@ static INLINE void* populate_cgroup_info(struct
> > > cgroup_data_t* cgroup_data,
> > >                                BPF_CORE_READ(task, cgroups, subsys[i]);
> > >                        if (subsys != NULL) {
> > >                                int subsys_id = BPF_CORE_READ(subsys, ss, id);
> > > -                               if (subsys_id == pids_cgrp_id) {
> > > +                               if (subsys_id == cgrp_id) {
> > >                                        proc_kernfs =
> > > BPF_CORE_READ(subsys, cgroup, kn);
> > >                                        root_kernfs =
> > > BPF_CORE_READ(subsys, ss, root, kf_root, kn);
> > >                                        break;
> >
>
