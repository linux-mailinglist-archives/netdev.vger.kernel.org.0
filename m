Return-Path: <netdev+bounces-1688-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD286FED22
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:50:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C0441C20E50
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2041B8F8;
	Thu, 11 May 2023 07:50:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BC9371
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:50:46 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B3046A6
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:50:44 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f4234f67feso178895e9.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683791443; x=1686383443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybwF8qJFWAbvIvu+SC1YZHKFpjOW6AAAy4k7z/ztuq8=;
        b=TpTvOo69AQQX6ckCLnMGs2C1Ya6+FtQsvhiEZukT0WOHLPa07jBGET3X+nbAMr1oII
         R527Pl+B48yYnKtX27XeGJfugo+z5bSUH/sqfd0dIjeUa2XBeE4EFu2rts/BQl3iVIHv
         zqBO4Z1XEHk40zwW6plDhl55btXvYaBAbhZBcW+ElbgJjm1k8mQoq42qjt14t2ZS4HNz
         zVt5v/M/buMkXDJYdtgaXtOOYZDXh4FaSoDQTV5QSDy5hstp+KI+/WouYOz7vbw6Jjxb
         bqYabyihtnyc6iqaudJsjdtgibb89uBOxRZNM3ODJMMgZSAsSYA8FuO80G5H2zzEAbwR
         9l4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683791443; x=1686383443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ybwF8qJFWAbvIvu+SC1YZHKFpjOW6AAAy4k7z/ztuq8=;
        b=FJ5cFuv4BSnaAdNRpchhi/PvCQkUQ5F42LJ2aCaMlDcynMx4m/gQCGVHyzBgwcIs/F
         aOASRcA4bOKh7rUpb9kW5XykwvUQGLM3hxgbqjGpDWG70DB3WANUwJIF2AQViCgJFcQf
         M4xlgvA84IUBsG/O2pKgXSFZEmUOqyjiPBugfmXDbF9SG2+HvxH6NgrbtCf0mB6bpDKZ
         rHAllYrqWB/M/hZtFLoy3WfigRpYpnRn9mQImCgz68XBAxm19Lcwe+BZkrEGS1L3cl8B
         H+di8pv7Dfy3hU//EgxgifUvb764rXFgfzvehrXBDaLQ9Oim4WTQhWOadcmckWGG4FEW
         QGuQ==
X-Gm-Message-State: AC+VfDwsC3CnIDIp7d90SNs6GO4pHoNcZi+BQE8z23ent/NzDGNpPKZI
	fTheLCqUKCARW643O+wm8cFGi1PhDLqlKQXWRfBvLg==
X-Google-Smtp-Source: ACHHUZ6TXJOO2RDr71ETxHJyDOo5G2bNSt1XGb8zhwZ5Dinr0Sv66xDTHCGvLoBiO697s04PMDeyCI7fzks/g6or/OE=
X-Received: by 2002:a05:600c:1c8b:b0:3f1:664a:9a52 with SMTP id
 k11-20020a05600c1c8b00b003f1664a9a52mr81948wms.7.1683791443152; Thu, 11 May
 2023 00:50:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
 <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
 <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
In-Reply-To: <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 11 May 2023 09:50:30 +0200
Message-ID: <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
To: "Zhang, Cathy" <cathy.zhang@intel.com>
Cc: Shakeel Butt <shakeelb@google.com>, Linux MM <linux-mm@kvack.org>, 
	Cgroups <cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, 
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>, 
	"Chen, Tim C" <tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>, 
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 9:00=E2=80=AFAM Zhang, Cathy <cathy.zhang@intel.com=
> wrote:
>
>
>
> > -----Original Message-----
> > From: Zhang, Cathy
> > Sent: Thursday, May 11, 2023 8:53 AM
> > To: Shakeel Butt <shakeelb@google.com>
> > Cc: Eric Dumazet <edumazet@google.com>; Linux MM <linux-
> > mm@kvack.org>; Cgroups <cgroups@vger.kernel.org>; Paolo Abeni
> > <pabeni@redhat.com>; davem@davemloft.net; kuba@kernel.org;
> > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> > Lizhen <Lizhen.You@intel.com>; eric.dumazet@gmail.com;
> > netdev@vger.kernel.org
> > Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> >
> >
> > > -----Original Message-----
> > > From: Shakeel Butt <shakeelb@google.com>
> > > Sent: Thursday, May 11, 2023 3:00 AM
> > > To: Zhang, Cathy <cathy.zhang@intel.com>
> > > Cc: Eric Dumazet <edumazet@google.com>; Linux MM <linux-
> > > mm@kvack.org>; Cgroups <cgroups@vger.kernel.org>; Paolo Abeni
> > > <pabeni@redhat.com>; davem@davemloft.net; kuba@kernel.org;
> > Brandeburg,
> > > Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> > > Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a
> > > proper size
> > >
> > > On Wed, May 10, 2023 at 9:09=E2=80=AFAM Zhang, Cathy <cathy.zhang@int=
el.com>
> > > wrote:
> > > >
> > > >
> > > [...]
> > > > > > >
> > > > > > > Have you tried to increase batch sizes ?
> > > > > >
> > > > > > I jus picked up 256 and 1024 for a try, but no help, the
> > > > > > overhead still
> > > exists.
> > > > >
> > > > > This makes no sense at all.
> > > >
> > > > Eric,
> > > >
> > > > I added a pr_info in try_charge_memcg() to print nr_pages if
> > > > nr_pages
> > > > >=3D MEMCG_CHARGE_BATCH, except it prints 64 during the initializat=
ion
> > > > of instances, there is no other output during the running. That
> > > > means nr_pages is not over 64, I guess that might be the reason why
> > > > to increase MEMCG_CHARGE_BATCH doesn't affect this case.
> > > >
> > >
> > > I am assuming you increased MEMCG_CHARGE_BATCH to 256 and 1024
> > but
> > > that did not help. To me that just means there is a different
> > > bottleneck in the memcg charging codepath. Can you please share the
> > > perf profile? Please note that memcg charging does a lot of other
> > > things as well like updating memcg stats and checking (and enforcing)
> > > memory.high even if you have not set memory.high.
> >
> > Thanks Shakeel! I will check more details on what you mentioned. We use
> > "sudo perf top -p $(docker inspect -f '{{.State.Pid}}' memcached_2)" to
> > monitor one of those instances, and also use "sudo perf top" to check t=
he
> > overhead from system wide.
>
> Here is the annotate output of perf top for the three memcg hot paths:
>
> Showing cycles for page_counter_try_charge
>   Events  Pcnt (>=3D5%)
>  Percent |      Source code & Disassembly of elf for cycles (543288 sampl=
es, percent: local period)
> -------------------------------------------------------------------------=
--------------------------
>     0.00 :   ffffffff8141388d:       mov    %r12,%rax
>    76.82 :   ffffffff81413890:       lock xadd %rax,(%rbx)
>    22.10 :   ffffffff81413895:       lea    (%r12,%rax,1),%r15
>
>
> Showing cycles for page_counter_cancel
>   Events  Pcnt (>=3D5%)
>  Percent |      Source code & Disassembly of elf for cycles (1004744 samp=
les, percent: local period)
> -------------------------------------------------------------------------=
---------------------------
>          : 160              return i + xadd(&v->counter, i);
>    77.42 :   ffffffff81413759:       lock xadd %rax,(%rdi)
>    22.34 :   ffffffff8141375e:       sub    %rsi,%rax
>
>
> Showing cycles for try_charge_memcg
>   Events  Pcnt (>=3D5%)
>  Percent |      Source code & Disassembly of elf for cycles (256531 sampl=
es, percent: local period)
> -------------------------------------------------------------------------=
--------------------------
>          : 22               return __READ_ONCE((v)->counter);
>    77.53 :   ffffffff8141df86:       mov    0x100(%r13),%rdx
>          : 2826             READ_ONCE(memcg->memory.high);
>    19.45 :   ffffffff8141df8d:       mov    0x190(%r13),%rcx

This is rephrasing the info you gave earlier ?

  16.77%  [kernel]            [k] page_counter_try_charge
    16.56%  [kernel]            [k] page_counter_cancel
    15.65%  [kernel]            [k] try_charge_memcg

What matters here is a call graph.

perf record -a -g sleep 5 # While the test is running
perf report --no-children --stdio

What precise kernel are you using btw ?

