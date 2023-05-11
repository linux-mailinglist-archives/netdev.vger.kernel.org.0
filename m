Return-Path: <netdev+bounces-1962-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F906FFBC2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 985891C20F57
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7C41642A;
	Thu, 11 May 2023 21:18:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1A48F7C
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 21:18:46 +0000 (UTC)
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FF42D5A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:18:45 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-24e16918391so5025808a91.3
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683839925; x=1686431925;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wFv5ci7ov6TO/nbE/lFV0e8LOwHUTHRp5fyIeOp00NI=;
        b=DRDZQiesqpSkMtadBPnXaSLFftLOF2tRVveccLBHVnBfk/IjvUoQA1Vknb0qgMsFbd
         ul40I6todx42bog/6ILqg96UcxIK20g7/qxVXO8QgOpBrtxjLfYfJ3yb7AbTA509nJ45
         vVEgVqAVXuEAW3i7m6KpNZ8E7yUqe9DG3mXiQ3HPPZBITzC95+Q2dKAzmolVjjK8pwj6
         a9Cs5cxJHtaEZmMYpeJlaDWPHHQqqVCMIVRPH7naWvhq4An6q1xPYDSHdHn8VQ1eQ3Qq
         1xo4xpza4/4wjkUjYkP6SbE4ymEBfN6VGHOcKr1q1VYLux/W7k50O5Jteg6uKDtjsnQ8
         c8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683839925; x=1686431925;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wFv5ci7ov6TO/nbE/lFV0e8LOwHUTHRp5fyIeOp00NI=;
        b=lq2lB1GqV9tC9/3Wfe//17TRnp3DZi+RLECav+iAr8dajw9JhIZ7asxyiF4kngfqJz
         fwKXA+VrNSa0ljgUPolOa3egCB7ghbWMPnP97N29f7yeYVX/io3eC7gu1WmHGIZeAGRI
         +sLToSkbpb9goUJLr9AXEb1TqjSqkfi4BI7V88Ux6qz+P30xR7HWChrMVhz9/EydLrZS
         /WmuOW1dXx4Y1/x1u4EplWQj+9cF6J2A2bV8dS5dd3y87capwB8zCr3NgjbHhYYn4SpD
         tyFhwNc9djrsINskrJoL/2cbcbh+zJDQL2phoArCNIHVhJEnbAQSVplVCZ4xH+G2B/ez
         6W/A==
X-Gm-Message-State: AC+VfDyerwmtNJflm4VmrcmrjFNWDRA7kqnsT9Nwdc2K72M0YxEB5TaX
	N+Cu1F/FoxjRQOlGS1/ZkVQkVDOd+GgXeQ==
X-Google-Smtp-Source: ACHHUZ4PXc23wNbZ57OaYuyrz4g91w8e/qPsy9n7oPI4nIMZ/vilFYfLVvhoPfhYvHpXoc9YoMMWey8UgDoT4A==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a17:90a:ff95:b0:24e:2288:6d with SMTP id
 hf21-20020a17090aff9500b0024e2288006dmr6663468pjb.0.1683839924818; Thu, 11
 May 2023 14:18:44 -0700 (PDT)
Date: Thu, 11 May 2023 21:18:42 +0000
In-Reply-To: <IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
 <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com> <IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com>
Message-ID: <20230511211338.oi4xwoueqmntsuna@google.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
From: Shakeel Butt <shakeelb@google.com>
To: Zhang@google.com, Cathy <cathy.zhang@intel.com>
Cc: Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, 
	Cgroups <cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, Brandeburg@google.com, 
	Jesse <jesse.brandeburg@intel.com>, Srinivas@google.com, 
	Suresh <suresh.srinivas@intel.com>, Chen@google.com, Tim C <tim.c.chen@intel.com>, 
	You@google.com, Lizhen <lizhen.you@intel.com>, 
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 09:26:46AM +0000, Zhang, Cathy wrote:
> 
[...]
> 
>      8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter_cancel
>             |
>              --8.97%--page_counter_cancel
>                        |
>                         --8.97%--page_counter_uncharge
>                                   drain_stock
>                                   __refill_stock
>                                   refill_stock
>                                   |
>                                    --8.91%--try_charge_memcg
>                                              mem_cgroup_charge_skmem

I do want to understand for above which specific condition in
__refill_stock is causing to drain stock in the charge code path. Can
you please re-run and profile your test with following code snippet (or
use any other mechanism which can answer the question)?

From f1d91043f21f4b29717c78615b374d79fc021d1f Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeelb@google.com>
Date: Thu, 11 May 2023 20:00:19 +0000
Subject: [PATCH] Debug drain on charging.

---
 mm/memcontrol.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d31fb1e2cb33..4c1c3d90a4a3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2311,6 +2311,16 @@ static void drain_local_stock(struct work_struct *dummy)
 		obj_cgroup_put(old);
 }
 
+static noinline void drain_stock_1(struct memcg_stock_pcp *stock)
+{
+	drain_stock(stock);
+}
+
+static noinline void drain_stock_2(struct memcg_stock_pcp *stock)
+{
+	drain_stock(stock);
+}
+
 /*
  * Cache charges(val) to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
@@ -2321,14 +2331,14 @@ static void __refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (READ_ONCE(stock->cached) != memcg) { /* reset if necessary */
-		drain_stock(stock);
+		drain_stock_1(stock);
 		css_get(&memcg->css);
 		WRITE_ONCE(stock->cached, memcg);
 	}
 	stock->nr_pages += nr_pages;
 
 	if (stock->nr_pages > MEMCG_CHARGE_BATCH)
-		drain_stock(stock);
+		drain_stock_2(stock);
 }
 
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-- 
2.40.1.606.ga4b1b128d6-goog


