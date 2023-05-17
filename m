Return-Path: <netdev+bounces-3413-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 883ED706EFB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:05:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FD9328121C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BA62C747;
	Wed, 17 May 2023 17:04:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A92E442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 17:04:58 +0000 (UTC)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2A39E
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:04:56 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1ae3f74c98bso4455ad.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684343096; x=1686935096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gKr+V+2IZIYa6CpuFFeV8UF5upmdCKVs0jpk2D6+3kA=;
        b=MuHHRRywhO1aSHU/MEanLSNwrqTsXNgGhXpEHv+Gd8S0hwOcQL217X2Ki8tX/r2Mdp
         2NEszZRFQrKKEzSloCfMXL+YkCte1+2uEysd7xGefM+J+TWlNJh4TsRgeW77bhP6+kwO
         23Xi1rxMk2QV7bWUV4P//0NIZbIyeuqzNOBaUoMJ84HfZTnE1l5O2PUW2b+iG0T9/T13
         Z9V8t9i5e5YBLwx3c+4zXl3IlWl+5jSODWaiVlemT0TnZoahQxM7WN4iSLNmr5tFG0pH
         BwYPJYGxU7Ajkdyn4I8jL1bvPDyO1qrrHxoTcvahP6GpyH9bqqCWJIwkJRVeShq5tJLn
         LieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684343096; x=1686935096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gKr+V+2IZIYa6CpuFFeV8UF5upmdCKVs0jpk2D6+3kA=;
        b=Qe8k8FDPzgUopaIF9jCDbzP0LaHfWcE0KBMoCkkVk/HeFHkK8fgVVlxo1oFPeQgLdc
         +CtxB5FxjL3KRgTLC/EVd7XLFJLXfvR/0f5mq+sU9Cd7AEyGeDggrD6GZL5/1pQMnSDT
         vXUTLIz9df+MRMBU1oR/yFMualguFutjGk3Lq9vms291K7PbHxvp3kLtfXIjnSueZMQW
         kDHoNI3koMpwx7a2sD4fUxY4x6/7pFSVrPDiNsHNlvgLcLMHqE4AZbMq247SrP9P4n3h
         gAd2Bq1VmaoNt7NKSYrHRWC8oJcjyvV7H4XvLCLycSOcH5eDT9cQ4/9L/kBaPhDJFglv
         aGqg==
X-Gm-Message-State: AC+VfDxK/Juun2VlUwTMRqUw4XqA5Q6tHL9zx3D0cXDqcD6GYkor05xD
	mgJnfPGyAEtooHZR6U0CTC9pkpzkkwYuujRglkQ3Pw==
X-Google-Smtp-Source: ACHHUZ7KKUoCffZgSyGuzx7i3/4H3NPwhF7EzftKGDKe1OgKxOmnMBm6vVmgCSTa78JQT6bJzOPyyzJSIV0YwtBHRVU=
X-Received: by 2002:a17:902:d483:b0:1a9:bb1d:64e with SMTP id
 c3-20020a170902d48300b001a9bb1d064emr353009plg.15.1684343093602; Wed, 17 May
 2023 10:04:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com> <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
 <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020> <20230517162447.dztfzmx3hhetfs2q@google.com>
 <CANn89iL0SD=F69b=naEmzoKysscnHGX7tP6jF9MOvthSeZ53Pw@mail.gmail.com>
In-Reply-To: <CANn89iL0SD=F69b=naEmzoKysscnHGX7tP6jF9MOvthSeZ53Pw@mail.gmail.com>
From: Shakeel Butt <shakeelb@google.com>
Date: Wed, 17 May 2023 10:04:42 -0700
Message-ID: <CALvZod6LFdydR5Zdhx1SMgknxTUJgabewi5-Ux6U=nO105GPSg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
To: Eric Dumazet <edumazet@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Oliver Sang <oliver.sang@intel.com>, Zhang Cathy <cathy.zhang@intel.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, Feng Tang <feng.tang@intel.com>, 
	Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, 
	"kuba@kernel.org" <kuba@kernel.org>, Brandeburg Jesse <jesse.brandeburg@intel.com>, 
	Srinivas Suresh <suresh.srinivas@intel.com>, Chen Tim C <tim.c.chen@intel.com>, 
	You Lizhen <lizhen.you@intel.com>, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, philip.li@intel.com, yujie.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+Andrew

On Wed, May 17, 2023 at 9:33=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Wed, May 17, 2023 at 6:24=E2=80=AFPM Shakeel Butt <shakeelb@google.com=
> wrote:
> >
> > On Tue, May 16, 2023 at 01:46:55PM +0800, Oliver Sang wrote:
> > > hi Shakeel,
> > >
> > > On Mon, May 15, 2023 at 12:50:31PM -0700, Shakeel Butt wrote:
> > > > +Feng, Yin and Oliver
> > > >
> > > > >
> > > > > > Thanks a lot Cathy for testing. Do you see any performance impr=
ovement for
> > > > > > the memcached benchmark with the patch?
> > > > >
> > > > > Yep, absolutely :- ) RPS (with/without patch) =3D +1.74
> > > >
> > > > Thanks a lot Cathy.
> > > >
> > > > Feng/Yin/Oliver, can you please test the patch at [1] with other
> > > > workloads used by the test robot? Basically I wanted to know if it =
has
> > > > any positive or negative impact on other perf benchmarks.
> > >
> > > is it possible for you to resend patch with Signed-off-by?
> > > without it, test robot will regard the patch as informal, then it can=
not feed
> > > into auto test process.
> > > and could you tell us the base of this patch? it will help us apply i=
t
> > > correctly.
> > >
> > > on the other hand, due to resource restraint, we normally cannot supp=
ort
> > > this type of on-demand test upon a single patch, patch set, or a bran=
ch.
> > > instead, we try to merge them into so-called hourly-kernels, then dis=
tribute
> > > tests and auto-bisects to various platforms.
> > > after we applying your patch and merging it to hourly-kernels sccussf=
ully,
> > > if it really causes some performance changes, the test robot could sp=
ot out
> > > this patch as 'fbc' and we will send report to you. this could happen=
 within
> > > several weeks after applying.
> > > but due to the complexity of whole process (also limited resourse, su=
ch like
> > > we cannot run all tests on all platforms), we cannot guanrantee captu=
re all
> > > possible performance impacts of this patch. and it's hard for us to p=
rovide
> > > a big picture like what's the general performance impact of this patc=
h.
> > > this maybe is not exactly what you want. is it ok for you?
> > >
> > >
> >
> > Yes, that is fine and thanks for the help. The patch is below:
> >
> >
> > From 93b3b4c5f356a5090551519522cfd5740ae7e774 Mon Sep 17 00:00:00 2001
> > From: Shakeel Butt <shakeelb@google.com>
> > Date: Tue, 16 May 2023 20:30:26 +0000
> > Subject: [PATCH] memcg: skip stock refill in irq context
> >
> > The linux kernel processes incoming packets in softirq on a given CPU
> > and those packets may belong to different jobs. This is very normal on
> > large systems running multiple workloads. With memcg enabled, network
> > memory for such packets is charged to the corresponding memcgs of the
> > jobs.
> >
> > Memcg charging can be a costly operation and the memcg code implements
> > a per-cpu memcg charge caching optimization to reduce the cost of
> > charging. More specifically, the kernel charges the given memcg for mor=
e
> > memory than requested and keep the remaining charge in a local per-cpu
> > cache. The insight behind this heuristic is that there will be more
> > charge requests for that memcg in near future. This optimization works
> > well when a specific job runs on a CPU for long time and majority of th=
e
> > charging requests happen in process context. However the kernel's
> > incoming packet processing does not work well with this optimization.
> >
> > Recently Cathy Zhang has shown [1] that memcg charge flushing within th=
e
> > memcg charge path can become a performance bottleneck for the memcg
> > charging of network traffic.
> >
> > Perf profile:
> >
> > 8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter_canc=
el
> >     |
> >      --8.97%--page_counter_cancel
> >                |
> >                 --8.97%--page_counter_uncharge
> >                           drain_stock
> >                           __refill_stock
> >                           refill_stock
> >                           |
> >                            --8.91%--try_charge_memcg
> >                                      mem_cgroup_charge_skmem
> >                                      |
> >                                       --8.91%--__sk_mem_raise_allocated
> >                                                 __sk_mem_schedule
> >                                                 |
> >                                                 |--5.41%--tcp_try_rmem_=
schedule
> >                                                 |          tcp_data_que=
ue
> >                                                 |          tcp_rcv_esta=
blished
> >                                                 |          tcp_v4_do_rc=
v
> >                                                 |          tcp_v4_rcv
> >
> > The simplest way to solve this issue is to not refill the memcg charge
> > stock in the irq context. Since networking is the main source of memcg
> > charging in the irq context, other users will not be impacted. In
> > addition, this will preseve the memcg charge cache of the application
> > running on that CPU.
> >
> > There are also potential side effects. What if all the packets belong t=
o
> > the same application and memcg? More specifically, users can use Receiv=
e
> > Flow Steering (RFS) to make sure the kernel process the packets of the
> > application on the CPU where the application is running. This change ma=
y
> > cause the kernel to do slowpath memcg charging more often in irq
> > context.
>
> Could we have per-memcg per-cpu caches, instead of one set of per-cpu cac=
hes
> needing to be drained evertime a cpu deals with 'another memcg' ?
>

The hierarchical nature of memcg makes that a bit complicated. We have
something similar for memcg stats which is rstat infra where the stats
are saved per-memcg per-cpu and get accumulated hierarchically every 2
seconds. This works fine for stats but for limits there would be a
need for some additional restrictions.

Also sometime ago Andrew asked me to explore replacing the atomic
counter in page_counter with percpu_counter. Intuition is that most of
the time the usage is not hitting the limit, so we can use
__percpu_counter_compare for enforcement.

Let me spend some time to explore per-memcg per-cpu cache or if
percpu_counter would be better.

For now, this patch is more like an RFC.

