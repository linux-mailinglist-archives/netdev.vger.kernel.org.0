Return-Path: <netdev+bounces-3398-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A54706E09
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76ABE28148F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFD21EA65;
	Wed, 17 May 2023 16:24:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B61F111A1
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:24:52 +0000 (UTC)
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B32FB
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:24:51 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-24e147c206eso670106a91.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684340690; x=1686932690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uhj13WmifJa2aeKhbFLQzqbb2EDANf9eZoINWvtSE2A=;
        b=bornvmoKTbwKLAGdqyP8wPwI3RCChOb5qwKBQ0fDlVktzwYmhxPBqaW0/eIvuj3T+K
         ImF5TtiPn4AsUtOKiIVELZWbayvn1TgApAq+JIhcSsJM82IR6qqp8r9VIbQYDtT8z4+2
         onCxpRR/l9r0C5Nn8aANiK50xxasfIQPKTx7Q+Za7SNHVQRpUBstEeFe0XiC3tfX8fTc
         p5BdtY8jsudGxUql8beUeGSM+AcbsgzAcPQB0rCvwDPdten8h1jULfvYOKcqlAEI4jGZ
         jaavH0l4P5S3a6QzksSnrZ+hYobEf8O+BpVpeZFBLoLHTn+l8JLujpqbk2UsYecq6Kit
         vqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684340690; x=1686932690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uhj13WmifJa2aeKhbFLQzqbb2EDANf9eZoINWvtSE2A=;
        b=L/unjy7NgSZGRbMr+dYE+gT+vBOtwAmETCrkjDW/pB1Gwno2x+bjGqPMydwW69IO/G
         FrV1//gfPfNiG44R1LTslGnivC3OaHTaBvZhf0b/ufI9q/uvwCyYUGtYJdQoHlD+dtUT
         xofnyR7OVsZ8wr4ai+o2JytK+gaPCbfxJ8YXzDqXQCy0X7XmT0xxJck96+AN3A1FcpEi
         Pj5mGeRAwPACrgJU2x5LRucDRL2RwLOYJg1pxL/35vKX91iMTLSP4Oj5c2wrj1JYtJX2
         y/2YZH9hY6JU/CguTch930OIr3Rt34haadPBaPZUigigDKk2M7GbJ13s69AKueGHfSQk
         vM8Q==
X-Gm-Message-State: AC+VfDyUgifYHzqmUJ219a+OGUXq26c16wcM2tuV4fdmHBnPlrbu/Uof
	4b0FHyhCmP1Sc39MN/cJ2i90d9jnm6OzEA==
X-Google-Smtp-Source: ACHHUZ7zFcQiC3H4iYl2GxelKoQrZbRMuimFsIc0Q+CPOEISLhvFpSJ45HZ4JcoZXUAnsWbz1B9rl5iVnhwgzQ==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a17:90b:103:b0:253:1ddb:6ab7 with SMTP id
 p3-20020a17090b010300b002531ddb6ab7mr69193pjz.7.1684340690517; Wed, 17 May
 2023 09:24:50 -0700 (PDT)
Date: Wed, 17 May 2023 16:24:47 +0000
In-Reply-To: <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com> <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com> <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020>
Message-ID: <20230517162447.dztfzmx3hhetfs2q@google.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
From: Shakeel Butt <shakeelb@google.com>
To: Oliver Sang <oliver.sang@intel.com>
Cc: Zhang Cathy <cathy.zhang@intel.com>, Yin Fengwei <fengwei.yin@intel.com>, 
	Feng Tang <feng.tang@intel.com>, Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, 
	Cgroups <cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, 
	Brandeburg Jesse <jesse.brandeburg@intel.com>, Srinivas Suresh <suresh.srinivas@intel.com>, 
	Chen Tim C <tim.c.chen@intel.com>, You Lizhen <lizhen.you@intel.com>, 
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, philip.li@intel.com, 
	yujie.liu@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 01:46:55PM +0800, Oliver Sang wrote:
> hi Shakeel,
> 
> On Mon, May 15, 2023 at 12:50:31PM -0700, Shakeel Butt wrote:
> > +Feng, Yin and Oliver
> > 
> > >
> > > > Thanks a lot Cathy for testing. Do you see any performance improvement for
> > > > the memcached benchmark with the patch?
> > >
> > > Yep, absolutely :- ) RPS (with/without patch) = +1.74
> > 
> > Thanks a lot Cathy.
> > 
> > Feng/Yin/Oliver, can you please test the patch at [1] with other
> > workloads used by the test robot? Basically I wanted to know if it has
> > any positive or negative impact on other perf benchmarks.
> 
> is it possible for you to resend patch with Signed-off-by?
> without it, test robot will regard the patch as informal, then it cannot feed
> into auto test process.
> and could you tell us the base of this patch? it will help us apply it
> correctly.
> 
> on the other hand, due to resource restraint, we normally cannot support
> this type of on-demand test upon a single patch, patch set, or a branch.
> instead, we try to merge them into so-called hourly-kernels, then distribute
> tests and auto-bisects to various platforms.
> after we applying your patch and merging it to hourly-kernels sccussfully,
> if it really causes some performance changes, the test robot could spot out
> this patch as 'fbc' and we will send report to you. this could happen within
> several weeks after applying.
> but due to the complexity of whole process (also limited resourse, such like
> we cannot run all tests on all platforms), we cannot guanrantee capture all
> possible performance impacts of this patch. and it's hard for us to provide
> a big picture like what's the general performance impact of this patch.
> this maybe is not exactly what you want. is it ok for you?
> 
> 

Yes, that is fine and thanks for the help. The patch is below:


From 93b3b4c5f356a5090551519522cfd5740ae7e774 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeelb@google.com>
Date: Tue, 16 May 2023 20:30:26 +0000
Subject: [PATCH] memcg: skip stock refill in irq context

The linux kernel processes incoming packets in softirq on a given CPU
and those packets may belong to different jobs. This is very normal on
large systems running multiple workloads. With memcg enabled, network
memory for such packets is charged to the corresponding memcgs of the
jobs.

Memcg charging can be a costly operation and the memcg code implements
a per-cpu memcg charge caching optimization to reduce the cost of
charging. More specifically, the kernel charges the given memcg for more
memory than requested and keep the remaining charge in a local per-cpu
cache. The insight behind this heuristic is that there will be more
charge requests for that memcg in near future. This optimization works
well when a specific job runs on a CPU for long time and majority of the
charging requests happen in process context. However the kernel's
incoming packet processing does not work well with this optimization.

Recently Cathy Zhang has shown [1] that memcg charge flushing within the
memcg charge path can become a performance bottleneck for the memcg
charging of network traffic.

Perf profile:

8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter_cancel
    |
     --8.97%--page_counter_cancel
	       |
		--8.97%--page_counter_uncharge
			  drain_stock
			  __refill_stock
			  refill_stock
			  |
			   --8.91%--try_charge_memcg
				     mem_cgroup_charge_skmem
				     |
				      --8.91%--__sk_mem_raise_allocated
						__sk_mem_schedule
						|
						|--5.41%--tcp_try_rmem_schedule
						|          tcp_data_queue
						|          tcp_rcv_established
						|          tcp_v4_do_rcv
						|          tcp_v4_rcv

The simplest way to solve this issue is to not refill the memcg charge
stock in the irq context. Since networking is the main source of memcg
charging in the irq context, other users will not be impacted. In
addition, this will preseve the memcg charge cache of the application
running on that CPU.

There are also potential side effects. What if all the packets belong to
the same application and memcg? More specifically, users can use Receive
Flow Steering (RFS) to make sure the kernel process the packets of the
application on the CPU where the application is running. This change may
cause the kernel to do slowpath memcg charging more often in irq
context.

Link: https://lore.kernel.org/all/IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com [1]
Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 mm/memcontrol.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5abffe6f8389..2635aae82b3e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2652,6 +2652,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 
+	/*
+	 * Skip the refill in irq context as it may flush the charge cache of
+	 * the process running on the CPUs or the kernel may have to process
+	 * incoming packets for different memcgs.
+	 */
+	if (!in_task())
+		batch = nr_pages;
+
 retry:
 	if (consume_stock(memcg, nr_pages))
 		return 0;
-- 
2.40.1.606.ga4b1b128d6-goog


