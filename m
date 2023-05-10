Return-Path: <netdev+bounces-1519-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4EBF6FE126
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:07:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81417281555
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE321640B;
	Wed, 10 May 2023 15:07:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837A412B6F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:07:38 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE0110E6
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:07:36 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f2548256d0so117035e9.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683731255; x=1686323255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+TNYqcSs6PC6BWjv/cKNCEBTiGNlpvDG9qZWo/NwWgk=;
        b=VHa+zJPx3Vz6wytMa3SIhZzYfgU2/Niwh71tnoKAYIeWA2H5epFTFhHSQvFN43kk6B
         cFDZen9tkH7p0WZnnrOzwIENa38J8Y14PbDUEwOakn8Oj0yZBW9fs6jWD/rDzE/vB43V
         Qz1d1XAKURN9MomiGhS9L4fJncNHQsNIPFngC2R0ThLp3yRrL/r6pOGWoH0IgAa/XqMm
         CVNitkcf2R+0SqHeNhSZUmYJ8hLSdPSSfbH8jGOIcZpl6IWOPynuR1hReNmhPg5z0teg
         5Ktw1dOsG4oFDuFWcd42P5fNifriJTDIeKvlkgfQQq0BmKMypIUJTRWWVWw1yJyVBdFh
         vP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683731255; x=1686323255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+TNYqcSs6PC6BWjv/cKNCEBTiGNlpvDG9qZWo/NwWgk=;
        b=SnUtfBFkwBfIxqUNwHpC2sh7iclNdh5SjL+ySxxesTzWLdBy+b9qd64spHcAZougTS
         w+EtuqEOsHJq3Sr7qvhAAfr9OsxUfRhL65lAKNnGNwqt9Mi+GNEcm0DTsetDNz6Ulw/v
         HgaTytOC7Ucw7xmkR8zpinV7XrTL1wAR1PPIvoH+YbLfCeVf2OZa+tvBqDn6X9bz92AC
         K8DlzBAmJE/Rt55+kX3Po9ZyVX3JxhwnuUAFhUwVxV6kdUHGmOtrJpa3X8Xo7p8HrRJv
         XgE0HdKQkKPr1cYKJY58yS9zgNYmd5CCINdn+oVu89MkfiR387kUOF/y1U7TN0rt0iYh
         lEBg==
X-Gm-Message-State: AC+VfDxYFHfNTA699H6AlkpAUvf4gtlL34yIeSCnP3qn/40IyXxr7r9/
	01tzIiuSbmxgcNon+YIF8luQXfinwA9/N9qIjY2hQw==
X-Google-Smtp-Source: ACHHUZ7ReeeiFKcAq8guOqqbvtXHzsH9pveN7COQFJ9sbuKpLeN4UdPfY8kTUiKY5rf8VminXW7vGdnkqTnUKbnBebE=
X-Received: by 2002:a05:600c:4f42:b0:3f4:2594:118a with SMTP id
 m2-20020a05600c4f4200b003f42594118amr226785wmq.2.1683731254627; Wed, 10 May
 2023 08:07:34 -0700 (PDT)
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
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com> <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
In-Reply-To: <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 17:07:22 +0200
Message-ID: <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
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

On Wed, May 10, 2023 at 3:54=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel.com=
> wrote:
>
>
>
> > -----Original Message-----
> > From: Eric Dumazet <edumazet@google.com>
> > Sent: Wednesday, May 10, 2023 7:25 PM
> > To: Zhang, Cathy <cathy.zhang@intel.com>
> > Cc: Shakeel Butt <shakeelb@google.com>; Linux MM <linux-mm@kvack.org>;
> > Cgroups <cgroups@vger.kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > davem@davemloft.net; kuba@kernel.org; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> > Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> > On Wed, May 10, 2023 at 1:11=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel=
.com>
> > wrote:
> > >
> > > Hi Shakeel, Eric and all,
> > >
> > > How about adding memory pressure checking in sk_mem_uncharge() to
> > > decide if keep part of memory or not, which can help avoid the issue
> > > you fixed and the problem we find on the system with more CPUs.
> > >
> > > The code draft is like this:
> > >
> > > static inline void sk_mem_uncharge(struct sock *sk, int size) {
> > >         int reclaimable;
> > >         int reclaim_threshold =3D SK_RECLAIM_THRESHOLD;
> > >
> > >         if (!sk_has_account(sk))
> > >                 return;
> > >         sk->sk_forward_alloc +=3D size;
> > >
> > >         if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
> > >             mem_cgroup_under_socket_pressure(sk->sk_memcg)) {
> > >                 sk_mem_reclaim(sk);
> > >                 return;
> > >         }
> > >
> > >         reclaimable =3D sk->sk_forward_alloc -
> > > sk_unused_reserved_mem(sk);
> > >
> > >         if (reclaimable > reclaim_threshold) {
> > >                 reclaimable -=3D reclaim_threshold;
> > >                 __sk_mem_reclaim(sk, reclaimable);
> > >         }
> > > }
> > >
> > > I've run a test with the new code, the result looks good, it does not
> > > introduce latency, RPS is the same.
> > >
> >
> > It will not work for sockets that are idle, after a burst.
> > If we restore per socket caches, we will need a shrinker.
> > Trust me, we do not want that kind of big hammer, crushing latencies.
> >
> > Have you tried to increase batch sizes ?
>
> I jus picked up 256 and 1024 for a try, but no help, the overhead still e=
xists.

This makes no sense at all.

I suspect a plain bug in mm/memcontrol.c

I will let mm experts work on this.

>
> >
> > Any kind of cache (even per-cpu) might need some adjustment when core
> > count or expected traffic is increasing.
> > This was somehow hinted in
> > commit 1813e51eece0ad6f4aacaeb738e7cced46feb470
> > Author: Shakeel Butt <shakeelb@google.com>
> > Date:   Thu Aug 25 00:05:06 2022 +0000
> >
> >     memcg: increase MEMCG_CHARGE_BATCH to 64
> >
> >
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h in=
dex
> > 222d7370134c73e59fdbdf598ed8d66897dbbf1d..0418229d30c25d114132a1e
> > d46ac01358cf21424
> > 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -334,7 +334,7 @@ struct mem_cgroup {
> >   * TODO: maybe necessary to use big numbers in big irons or dynamic ba=
sed
> > of the
> >   * workload.
> >   */
> > -#define MEMCG_CHARGE_BATCH 64U
> > +#define MEMCG_CHARGE_BATCH 128U
> >
> >  extern struct mem_cgroup *root_mem_cgroup;
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h index
> > 656ea89f60ff90d600d16f40302000db64057c64..82f6a288be650f886b207e6a
> > 5e62a1d5dda808b0
> > 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1433,8 +1433,8 @@ sk_memory_allocated(const struct sock *sk)
> >         return proto_memory_allocated(sk->sk_prot);
> >  }
> >
> > -/* 1 MB per cpu, in page units */
> > -#define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
> > +/* 2 MB per cpu, in page units */
> > +#define SK_MEMORY_PCPU_RESERVE (1 << (21 - PAGE_SHIFT))
> >
> >  static inline void
> >  sk_memory_allocated_add(struct sock *sk, int amt)
> >
> >
> >
> >
> >
> >
> > > > -----Original Message-----
> > > > From: Shakeel Butt <shakeelb@google.com>
> > > > Sent: Wednesday, May 10, 2023 12:10 AM
> > > > To: Eric Dumazet <edumazet@google.com>; Linux MM <linux-
> > > > mm@kvack.org>; Cgroups <cgroups@vger.kernel.org>
> > > > Cc: Zhang, Cathy <cathy.zhang@intel.com>; Paolo Abeni
> > > > <pabeni@redhat.com>; davem@davemloft.net; kuba@kernel.org;
> > > > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > > > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>;
> > > > You, Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > > > netdev@vger.kernel.org
> > > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as
> > > > a proper size
> > > >
> > > > +linux-mm & cgroup
> > > >
> > > > Thread: https://lore.kernel.org/all/20230508020801.10702-1-
> > > > cathy.zhang@intel.com/
> > > >
> > > > On Tue, May 9, 2023 at 8:43=E2=80=AFAM Eric Dumazet <edumazet@googl=
e.com>
> > > > wrote:
> > > > >
> > > > [...]
> > > > > Some mm experts should chime in, this is not a networking issue.
> > > >
> > > > Most of the MM folks are busy in LSFMM this week. I will take a loo=
k
> > > > at this soon.

