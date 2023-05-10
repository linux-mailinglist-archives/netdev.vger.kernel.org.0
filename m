Return-Path: <netdev+bounces-1443-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AAE36FDCB0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61D6E2803FF
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7148C1B;
	Wed, 10 May 2023 11:25:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB553D60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:25:44 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3E07296
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:25:11 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f2548256d0so101555e9.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683717905; x=1686309905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yCUB8//jyn0v6VuC0Mv1gAetwatciCjYaByO0V5N8x4=;
        b=glDScdM+b+Eq4bPgyBFONs+ujCqj0fUTzb2C1b7YC9k0bX00m378sp+jClAFSCEYIj
         7GQmW5yCYlh8ljWEw+78HDoWFDW3woBXw6OWf3sutdWuRau9RpJTBeFzr5rniNgwu8B1
         RXeBFJvwdpWuXrQNRVHHeJxrfM+4flHaskwNjG8OzWaUKrYT8zOnmkjN6UEowshjdkVX
         PiEWdYsuLY3ObbHKdPzefSLUPMZzXEQ/uJ8/dDTSaTJaCz/lXYPUOCVsKTIZMN5k1a3O
         fhKq0sDR4DzxKg5KKy/y8r4CgHK0FDtbgeUmotkf4M6TOF0GI1bPRq/wwfAJEGhj4ODp
         eilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683717905; x=1686309905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yCUB8//jyn0v6VuC0Mv1gAetwatciCjYaByO0V5N8x4=;
        b=ATLjMEGVq7tp9gRnY713JJojTSDa6RZSYb2KreIIeWcojPFH1tdJKmXzBsiK1bfy2n
         RzFUeoAvgHWdL65hu+b/QPEqJuatKeCPl2x1ZsLnwo6+E6J6b9YUIx4QqZhUklAM9h3N
         qftf65/5LzyXK7rp026I5Z7SpKIY99wNW74gSRgwEfeOnz4pqAA+XYbigObhVbv5eKVO
         kk9CHT3lsexDx+yzG09UsOuDjqmeo0wHWu2CcimQqWfZB1+IIQkdJkGVkdFvP/MItnA/
         HWrX5W9NTG+/StXs7AoVDceiICr/eNe2bY/5wFtp/H6UpaZrXP1fLceJI8r37DLNSvE3
         QYEA==
X-Gm-Message-State: AC+VfDysUt2NHNfFflt4EgmllyR7r4+RJvkimUvneoshzqQOOsBJP9bQ
	Wa7prmVMTqowap7KmlbyfzhUJHVFnjaOUPx3J+AaCQ==
X-Google-Smtp-Source: ACHHUZ69T1gYDKpF4OjPKZJnBUCAEzKCno/ZJPDxW3EBm1g/1xeKp6EIRTP5+AunUAnDep3VHzalXh6IrmgpZ6uKBGI=
X-Received: by 2002:a05:600c:3d98:b0:3f1:9396:6fbf with SMTP id
 bi24-20020a05600c3d9800b003f193966fbfmr177026wmb.4.1683717905062; Wed, 10 May
 2023 04:25:05 -0700 (PDT)
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
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com> <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
In-Reply-To: <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 13:24:53 +0200
Message-ID: <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
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
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 1:11=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel.com=
> wrote:
>
> Hi Shakeel, Eric and all,
>
> How about adding memory pressure checking in sk_mem_uncharge()
> to decide if keep part of memory or not, which can help avoid the issue
> you fixed and the problem we find on the system with more CPUs.
>
> The code draft is like this:
>
> static inline void sk_mem_uncharge(struct sock *sk, int size)
> {
>         int reclaimable;
>         int reclaim_threshold =3D SK_RECLAIM_THRESHOLD;
>
>         if (!sk_has_account(sk))
>                 return;
>         sk->sk_forward_alloc +=3D size;
>
>         if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
>             mem_cgroup_under_socket_pressure(sk->sk_memcg)) {
>                 sk_mem_reclaim(sk);
>                 return;
>         }
>
>         reclaimable =3D sk->sk_forward_alloc - sk_unused_reserved_mem(sk)=
;
>
>         if (reclaimable > reclaim_threshold) {
>                 reclaimable -=3D reclaim_threshold;
>                 __sk_mem_reclaim(sk, reclaimable);
>         }
> }
>
> I've run a test with the new code, the result looks good, it does not int=
roduce
> latency, RPS is the same.
>

It will not work for sockets that are idle, after a burst.
If we restore per socket caches, we will need a shrinker.
Trust me, we do not want that kind of big hammer, crushing latencies.

Have you tried to increase batch sizes ?

Any kind of cache (even per-cpu) might need some adjustment when core
count or expected traffic is increasing.
This was somehow hinted in
commit 1813e51eece0ad6f4aacaeb738e7cced46feb470
Author: Shakeel Butt <shakeelb@google.com>
Date:   Thu Aug 25 00:05:06 2022 +0000

    memcg: increase MEMCG_CHARGE_BATCH to 64



diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 222d7370134c73e59fdbdf598ed8d66897dbbf1d..0418229d30c25d114132a1ed46a=
c01358cf21424
100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -334,7 +334,7 @@ struct mem_cgroup {
  * TODO: maybe necessary to use big numbers in big irons or dynamic
based of the
  * workload.
  */
-#define MEMCG_CHARGE_BATCH 64U
+#define MEMCG_CHARGE_BATCH 128U

 extern struct mem_cgroup *root_mem_cgroup;

diff --git a/include/net/sock.h b/include/net/sock.h
index 656ea89f60ff90d600d16f40302000db64057c64..82f6a288be650f886b207e6a5e6=
2a1d5dda808b0
100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1433,8 +1433,8 @@ sk_memory_allocated(const struct sock *sk)
        return proto_memory_allocated(sk->sk_prot);
 }

-/* 1 MB per cpu, in page units */
-#define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
+/* 2 MB per cpu, in page units */
+#define SK_MEMORY_PCPU_RESERVE (1 << (21 - PAGE_SHIFT))

 static inline void
 sk_memory_allocated_add(struct sock *sk, int amt)






> > -----Original Message-----
> > From: Shakeel Butt <shakeelb@google.com>
> > Sent: Wednesday, May 10, 2023 12:10 AM
> > To: Eric Dumazet <edumazet@google.com>; Linux MM <linux-
> > mm@kvack.org>; Cgroups <cgroups@vger.kernel.org>
> > Cc: Zhang, Cathy <cathy.zhang@intel.com>; Paolo Abeni
> > <pabeni@redhat.com>; davem@davemloft.net; kuba@kernel.org;
> > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> > Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> > +linux-mm & cgroup
> >
> > Thread: https://lore.kernel.org/all/20230508020801.10702-1-
> > cathy.zhang@intel.com/
> >
> > On Tue, May 9, 2023 at 8:43=E2=80=AFAM Eric Dumazet <edumazet@google.co=
m>
> > wrote:
> > >
> > [...]
> > > Some mm experts should chime in, this is not a networking issue.
> >
> > Most of the MM folks are busy in LSFMM this week. I will take a look at=
 this
> > soon.

