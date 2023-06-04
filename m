Return-Path: <netdev+bounces-7752-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1EF721623
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 12:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE7A21C209D0
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 10:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65ACF23C6;
	Sun,  4 Jun 2023 10:37:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEF823AE
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 10:37:09 +0000 (UTC)
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511A4C1;
	Sun,  4 Jun 2023 03:37:06 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id ada2fe7eead31-43b148975e0so1135366137.0;
        Sun, 04 Jun 2023 03:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685875025; x=1688467025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+cW+W+2ToTmL5Y4D5MrCTf7iqNWcTE2j9X0ITTZBzs=;
        b=JExgNb84ODfc1n2XYy4S5jPF5F4lLgn7e28BYdaq3YfVbJndWp2rO96Rdh2dExcsHU
         o6OARLsIs0cAT76nDYzVxjtwNmLABQakff6/4TpMI/yozfxXxqm6sFLyqf/w5LZIXBbJ
         zC+DbBMB32zQiqJxDneHHS2/E0CYotb8OIUKI+V5VTIv2lWE148GMOVcB3Sz6inUchTf
         5S7GFwgSCoO5P0QRbPejsO+0c74YvVvfAxGr0+h5lK3heEBzYzXCSo+dzGKndszXGaVs
         IA/ycRfW5pKCmGcjO/I0uEXZ0x0f1bvZpRvY9SSAGseCrXor94SjXYofHsJViBEkHaHA
         FT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685875025; x=1688467025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+cW+W+2ToTmL5Y4D5MrCTf7iqNWcTE2j9X0ITTZBzs=;
        b=PwvDFW2X9EzaeO8vFkUZqGrOBqv3R1yqh39nS8ul0TyoFOB0CVEB3M2J11Giyo2Iz2
         KHWu6GSP0q20t94vqw64JO3fTy/BXhi08cFuIsK6UgqOZLbpn/zUEC52gN/qqj14BzF3
         5jC+AHfRjfy4s5iJ6Po/8rhEVKMEOXJX91Znh3acAl1n778uZz/TpKy6LG7BmuNo/Est
         KxHFmJtlqvIOewr4RsKmKT4l1Sa6Q0czd4xgI4iWDp3cWi/G/8VxywtXABO+3NuByi2o
         mbzoZjSiWgD7VVxPkYqtLeWAAIXLqnwXQEiMZ7aAcLa2KopkRkh/oOFEGoMDhA7YHqzN
         uEuA==
X-Gm-Message-State: AC+VfDyB2NPD6FgPfZsWnvhXA3FGHniBBTjq95s91WCAnRH/FqocZjmH
	HhdMgjdRIfVk/hUopH8HaLfD1/R5BLgsmxtusTk=
X-Google-Smtp-Source: ACHHUZ513qxEIwWk8MOPLcnOJPrO/Wo2Uzw+66oaJBk/NI2yjIIxpjaDAYLrj9ZkQ4LfwiupswBKzQbJRpPjBu09Eu4=
X-Received: by 2002:a1f:c10f:0:b0:463:12f:d38e with SMTP id
 r15-20020a1fc10f000000b00463012fd38emr1281952vkf.1.1685875025217; Sun, 04 Jun
 2023 03:37:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602081135.75424-1-wuyun.abel@bytedance.com>
 <20230602081135.75424-3-wuyun.abel@bytedance.com> <20230602204159.vo7fmuvh3y2pdfi5@google.com>
In-Reply-To: <20230602204159.vo7fmuvh3y2pdfi5@google.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sun, 4 Jun 2023 12:36:25 +0200
Message-ID: <CAF=yD-LFQRreWq1RMkvLw9Nj3NQpJwbDSCfECUhh-aVchR-jsg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/3] sock: Always take memcg pressure into consideration
To: Shakeel Butt <shakeelb@google.com>
Cc: Abel Wu <wuyun.abel@bytedance.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Vladimir Davydov <vdavydov.dev@gmail.com>, Muchun Song <muchun.song@linux.dev>, 
	Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 10:42=E2=80=AFPM Shakeel Butt <shakeelb@google.com> =
wrote:
>
> On Fri, Jun 02, 2023 at 04:11:34PM +0800, Abel Wu wrote:
> > The sk_under_memory_pressure() is called to check whether there is
> > memory pressure related to this socket. But now it ignores the net-
> > memcg's pressure if the proto of the socket doesn't care about the
> > global pressure, which may put burden on its memcg compaction or
> > reclaim path (also remember that socket memory is un-reclaimable).
> >
> > So always check the memcg's vm status to alleviate memstalls when
> > it's in pressure.
> >
>
> This is interesting. UDP is the only protocol which supports memory
> accounting (i.e. udp_memory_allocated) but it does not define
> memory_pressure. In addition, it does have sysctl_udp_mem. So
> effectively UDP supports a hard limit and ignores memcg pressure at the
> moment. This patch will change its behavior to consider memcg pressure
> as well. I don't have any objection but let's get opinion of UDP
> maintainer.

Others have more experience with memory pressure on UDP, for the
record. Paolo worked on UDP memory pressure in
https://lore.kernel.org/netdev/cover.1579281705.git.pabeni@redhat.com/

It does seem odd to me to modify sk_under_memory_pressure only. See
for instance its use in __sk_mem_raise_allocated:

        if (sk_has_memory_pressure(sk)) {
                u64 alloc;

                if (!sk_under_memory_pressure(sk))
                        return 1;

This is not even reached as sk_has_memory_pressure is false for UDP.
So this commit only affects the only other protocol-independent
caller, __sk_mem_reduce_allocated, to possibly call
sk_leave_memory_pressure if now under the global limit.

What is the expected behavioral change in practice of this commit?


> > Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> > ---
> >  include/net/sock.h | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 3f63253ee092..ad1895ffbc4a 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1411,13 +1411,11 @@ static inline bool sk_has_memory_pressure(const=
 struct sock *sk)
> >
> >  static inline bool sk_under_memory_pressure(const struct sock *sk)
> >  {
> > -     if (!sk->sk_prot->memory_pressure)
> > -             return false;
> > -
> >       if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
> >               return true;
> >
> > -     return !!*sk->sk_prot->memory_pressure;
> > +     return sk->sk_prot->memory_pressure &&
> > +             *sk->sk_prot->memory_pressure;
> >  }
> >
> >  static inline long
> > --
> > 2.37.3
> >

