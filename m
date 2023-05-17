Return-Path: <netdev+bounces-3399-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 159A4706E39
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:33:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C03F3281799
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C77F848B;
	Wed, 17 May 2023 16:33:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA2E4421
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:33:38 +0000 (UTC)
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D2E8693
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:33:36 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-33828a86ee2so1295ab.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684341216; x=1686933216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YGCTJkjb+BkBWhgl9nkCivR/yxXltKo5X5s56+BQds8=;
        b=ICxeJ4TRj0Aa912CHQqgpNLoLbhTEMQAjIlNLTt0p2NM9VeYmoid36yRYdHRJmkrSV
         id3QBB4TohYYolGYjdav6TEgp9WRM8G9HcoFmBzh8mDTpkseEIlx3Ue0SCUNZR0hJcKu
         RDmAHgGZny6lAq6/4J0GIsPcNf7Z6BCrWt2O2T16aUTbsFtPgN54lRb9oIktSbJwdbAZ
         q0YY5qoO4vRfV5C/f4cPfx2e9TwuktWeDHyXbPjPR6OgY3BEqOXkIpO1WU5fDrcAm8PD
         tbQuukIo8WN0jofAcuhdtDJScPXXh4puE1NnuUwbBqSWsKOcLFr+TatAOah9SidYGTja
         cRsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684341216; x=1686933216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YGCTJkjb+BkBWhgl9nkCivR/yxXltKo5X5s56+BQds8=;
        b=B/kB3sCuxpPXcFrObFMlhNZtTayKiRqxzj6mkQ3NkwjfIOnHalizry7eC0reUszV6L
         Dx3hu/sU6eJlzdK4IKpHLbC+RfhEKZpPMJRN9s3vyEEsiQd7CZeLtWqghGcfte/09oI5
         XfxecTMrwNfRGIY2eyR/wjk9IdgOJGv5sWO1bTC0GHuhQzEfwaw6+slQjrq0665yg+70
         wm6XPnoRc9hH9Cmj3b6I+nBhdvjB1UiHzAxccN2XLmyArAfchMypKVE9fhdFKIvU7U5t
         WBQrEBpobL84xeuKWVSvJlLXh1YnaXrqmc0mKkGanbsXgzf3JqpAdxKkI8HggjgMrL/N
         XrGw==
X-Gm-Message-State: AC+VfDzO6Wy02/KfCecxRi/BMDQwDlQpWu+kfvpUeImo/0pNLCnoIDK+
	Tb2tLHegTlP2Stu1OPeWFOdcepPnTvGtEfLBe2ikmw==
X-Google-Smtp-Source: ACHHUZ55tKP7LoNajakx4E0yARHVP7p25x16TwzLqiz9gUfuRnaj4ppiBBfCnsVdhpZik4FydQALsG+RoaaSSAYkz3g=
X-Received: by 2002:a05:6e02:20ce:b0:338:13f1:8c0c with SMTP id
 14-20020a056e0220ce00b0033813f18c0cmr355316ilq.16.1684341216148; Wed, 17 May
 2023 09:33:36 -0700 (PDT)
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
In-Reply-To: <20230517162447.dztfzmx3hhetfs2q@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 17 May 2023 18:33:24 +0200
Message-ID: <CANn89iL0SD=F69b=naEmzoKysscnHGX7tP6jF9MOvthSeZ53Pw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
To: Shakeel Butt <shakeelb@google.com>
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

On Wed, May 17, 2023 at 6:24=E2=80=AFPM Shakeel Butt <shakeelb@google.com> =
wrote:
>
> On Tue, May 16, 2023 at 01:46:55PM +0800, Oliver Sang wrote:
> > hi Shakeel,
> >
> > On Mon, May 15, 2023 at 12:50:31PM -0700, Shakeel Butt wrote:
> > > +Feng, Yin and Oliver
> > >
> > > >
> > > > > Thanks a lot Cathy for testing. Do you see any performance improv=
ement for
> > > > > the memcached benchmark with the patch?
> > > >
> > > > Yep, absolutely :- ) RPS (with/without patch) =3D +1.74
> > >
> > > Thanks a lot Cathy.
> > >
> > > Feng/Yin/Oliver, can you please test the patch at [1] with other
> > > workloads used by the test robot? Basically I wanted to know if it ha=
s
> > > any positive or negative impact on other perf benchmarks.
> >
> > is it possible for you to resend patch with Signed-off-by?
> > without it, test robot will regard the patch as informal, then it canno=
t feed
> > into auto test process.
> > and could you tell us the base of this patch? it will help us apply it
> > correctly.
> >
> > on the other hand, due to resource restraint, we normally cannot suppor=
t
> > this type of on-demand test upon a single patch, patch set, or a branch=
.
> > instead, we try to merge them into so-called hourly-kernels, then distr=
ibute
> > tests and auto-bisects to various platforms.
> > after we applying your patch and merging it to hourly-kernels sccussful=
ly,
> > if it really causes some performance changes, the test robot could spot=
 out
> > this patch as 'fbc' and we will send report to you. this could happen w=
ithin
> > several weeks after applying.
> > but due to the complexity of whole process (also limited resourse, such=
 like
> > we cannot run all tests on all platforms), we cannot guanrantee capture=
 all
> > possible performance impacts of this patch. and it's hard for us to pro=
vide
> > a big picture like what's the general performance impact of this patch.
> > this maybe is not exactly what you want. is it ok for you?
> >
> >
>
> Yes, that is fine and thanks for the help. The patch is below:
>
>
> From 93b3b4c5f356a5090551519522cfd5740ae7e774 Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeelb@google.com>
> Date: Tue, 16 May 2023 20:30:26 +0000
> Subject: [PATCH] memcg: skip stock refill in irq context
>
> The linux kernel processes incoming packets in softirq on a given CPU
> and those packets may belong to different jobs. This is very normal on
> large systems running multiple workloads. With memcg enabled, network
> memory for such packets is charged to the corresponding memcgs of the
> jobs.
>
> Memcg charging can be a costly operation and the memcg code implements
> a per-cpu memcg charge caching optimization to reduce the cost of
> charging. More specifically, the kernel charges the given memcg for more
> memory than requested and keep the remaining charge in a local per-cpu
> cache. The insight behind this heuristic is that there will be more
> charge requests for that memcg in near future. This optimization works
> well when a specific job runs on a CPU for long time and majority of the
> charging requests happen in process context. However the kernel's
> incoming packet processing does not work well with this optimization.
>
> Recently Cathy Zhang has shown [1] that memcg charge flushing within the
> memcg charge path can become a performance bottleneck for the memcg
> charging of network traffic.
>
> Perf profile:
>
> 8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter_cancel
>     |
>      --8.97%--page_counter_cancel
>                |
>                 --8.97%--page_counter_uncharge
>                           drain_stock
>                           __refill_stock
>                           refill_stock
>                           |
>                            --8.91%--try_charge_memcg
>                                      mem_cgroup_charge_skmem
>                                      |
>                                       --8.91%--__sk_mem_raise_allocated
>                                                 __sk_mem_schedule
>                                                 |
>                                                 |--5.41%--tcp_try_rmem_sc=
hedule
>                                                 |          tcp_data_queue
>                                                 |          tcp_rcv_establ=
ished
>                                                 |          tcp_v4_do_rcv
>                                                 |          tcp_v4_rcv
>
> The simplest way to solve this issue is to not refill the memcg charge
> stock in the irq context. Since networking is the main source of memcg
> charging in the irq context, other users will not be impacted. In
> addition, this will preseve the memcg charge cache of the application
> running on that CPU.
>
> There are also potential side effects. What if all the packets belong to
> the same application and memcg? More specifically, users can use Receive
> Flow Steering (RFS) to make sure the kernel process the packets of the
> application on the CPU where the application is running. This change may
> cause the kernel to do slowpath memcg charging more often in irq
> context.

Could we have per-memcg per-cpu caches, instead of one set of per-cpu cache=
s
needing to be drained evertime a cpu deals with 'another memcg' ?

>
> Link: https://lore.kernel.org/all/IA0PR11MB73557DEAB912737FD61D2873FC749@=
IA0PR11MB7355.namprd11.prod.outlook.com [1]
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
>  mm/memcontrol.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5abffe6f8389..2635aae82b3e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2652,6 +2652,14 @@ static int try_charge_memcg(struct mem_cgroup *mem=
cg, gfp_t gfp_mask,
>         bool raised_max_event =3D false;
>         unsigned long pflags;
>
> +       /*
> +        * Skip the refill in irq context as it may flush the charge cach=
e of
> +        * the process running on the CPUs or the kernel may have to proc=
ess
> +        * incoming packets for different memcgs.
> +        */
> +       if (!in_task())
> +               batch =3D nr_pages;
> +
>  retry:
>         if (consume_stock(memcg, nr_pages))
>                 return 0;
> --
> 2.40.1.606.ga4b1b128d6-goog
>

