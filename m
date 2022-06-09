Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD430544E02
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 15:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244932AbiFINrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 09:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244194AbiFINrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 09:47:32 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39DA63CF
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 06:47:29 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3135519f95fso71414887b3.6
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 06:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CANwsuZ+/FfUoa7+NEGbAT/bvub08rzdBfpcv9TbzJ4=;
        b=YQ5kvphzv7Nxt9qx6e8jew0LM5CJcOp7JVra7GNinFZXxEnATYdfjDEXyg6d20tjJZ
         t1tjnvAeeV1Xwesru0dgZC0Xy1Y5rsVytxS1k/FwJVzSEfsimwY2kDTtfSNvU8NbKBsQ
         oPTmwzgVDNA9VaXPW93iPKw8gDcYHppKwHZAqPaxXXYRX5WF8gWmGe63YuWQD1cdoPSa
         q75fySZL0mz32Eb/OjvLifbfHIyQKWCaaRbCx5Jkv4mNJDkZUxV7MchQK7PIkHGLk1lQ
         57j0fa8b/VETwumreotZhD/nBp96UPuZ2kbDkyFjNjaKQcWCnC5B0W7SLsoMdKJ+y86F
         8bEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CANwsuZ+/FfUoa7+NEGbAT/bvub08rzdBfpcv9TbzJ4=;
        b=08Gx2ouqW5BBUTAIVSVDuvwVcu+y49XIXQ3n4HEnF+pfZNV+yYLQvG6UfHiGKsEK8X
         T2OSVrFpS/cBL0bpD+MJbKkttO7NFb5JDp6Jx3qsqySgT1N2A1tgBOpGZiXtD7yKh4N3
         posmY7pB/VgyDWMP/ZPZ0ZlbPpnA/3XFoc2o5UtJF0e4kc8ZPg76K4zRByOSc4bHlCvG
         51yWh0xyvWVCdpcEB4F6Xb8acBuyXuwp5t6d/DZqnwwwiJ7yotpPv4ocyWxecUzYbLv3
         HKT4I9qu2uL9PPqrVYdTsOFBxbqaqD+o2GS+yVqexxkA1lF+XDQAM57PjrmkhPFsLb6X
         khXA==
X-Gm-Message-State: AOAM530Gv6QrTCdcdy6ztVxBBc8//I61uIBMoXAHNDHUCewh5YYKX5aA
        xR988J9FG5z+S2WvmokR2NOm0DMnIKKRSJvnR3Z5Iw==
X-Google-Smtp-Source: ABdhPJxCx1oQzq2gg+Sg0gB8ekOHMmyL141cay7dPY5xHK6//ZgixYU3Jl7+TS8MqJASg2Ys6VXZ3/i6Ng5XlG+AtG4=
X-Received: by 2002:a81:4811:0:b0:30c:8021:4690 with SMTP id
 v17-20020a814811000000b0030c80214690mr43000175ywa.47.1654782448671; Thu, 09
 Jun 2022 06:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
 <20220609063412.2205738-5-eric.dumazet@gmail.com> <CACSApvYEwczGVvOxOfDXNHd_x5LDb1vXT03y-=6CcrTv1uR9Kw@mail.gmail.com>
In-Reply-To: <CACSApvYEwczGVvOxOfDXNHd_x5LDb1vXT03y-=6CcrTv1uR9Kw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Jun 2022 06:47:17 -0700
Message-ID: <CANn89iKbam05mjKCN4bS6H42x1_Jw1a=G3vbrNM3FTTjvXABWg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: implement per-cpu reserves for memory_allocated
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 6:34 AM Soheil Hassas Yeganeh <soheil@google.com> wrote:
>
> On Thu, Jun 9, 2022 at 2:34 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > We plan keeping sk->sk_forward_alloc as small as possible
> > in future patches.
> >
> > This means we are going to call sk_memory_allocated_add()
> > and sk_memory_allocated_sub() more often.
> >
> > Implement a per-cpu cache of +1/-1 MB, to reduce number
> > of changes to sk->sk_prot->memory_allocated, which
> > would otherwise be cause of false sharing.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
>
> > ---
> >  include/net/sock.h | 38 +++++++++++++++++++++++++++++---------
> >  1 file changed, 29 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 825f8cbf791f02d798f17dd4f7a2659cebb0e98a..59040fee74e7de8d63fbf719f46e172906c134bb 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1397,22 +1397,48 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
> >         return !!*sk->sk_prot->memory_pressure;
> >  }
> >
> > +static inline long
> > +proto_memory_allocated(const struct proto *prot)
> > +{
> > +       return max(0L, atomic_long_read(prot->memory_allocated));
> > +}
> > +
> >  static inline long
> >  sk_memory_allocated(const struct sock *sk)
> >  {
> > -       return atomic_long_read(sk->sk_prot->memory_allocated);
> > +       return proto_memory_allocated(sk->sk_prot);
> >  }
> >
> > +/* 1 MB per cpu, in page units */
> > +#define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
> > +
> >  static inline long
> >  sk_memory_allocated_add(struct sock *sk, int amt)
> >  {
> > -       return atomic_long_add_return(amt, sk->sk_prot->memory_allocated);
> > +       int local_reserve;
> > +
> > +       preempt_disable();
> > +       local_reserve = __this_cpu_add_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
> > +       if (local_reserve >= SK_MEMORY_PCPU_RESERVE) {
> > +               __this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
>
> This is just a nitpick, but we could
> __this_cpu_write(*sk->sk_prot->per_cpu_fw_alloc, 0) instead which
> should be slightly faster.

This would require us to block irqs, not only preempt_disable()/preempt_enable()

Otherwise when doing the write, there is no guarantee we replace the
intended value,
as an interrupt could have changed this cpu per_cpu_fw_alloc.

A __this_cpu_cmpxchg() would make sure of that, but would be more
expensive than __this_cpu_sub() and would require a loop.

 With my change, there is a tiny possibility that
*sk->sk_prot->per_cpu_fw_alloc, is not in the -1/+1 1MB range,
but no lasting consequences, next update will consolidate things, and
tcp_memory_allocated will not drift.

>
> > +               atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
> > +       }
> > +       preempt_enable();
> > +       return sk_memory_allocated(sk);
> >  }
> >
> >  static inline void
> >  sk_memory_allocated_sub(struct sock *sk, int amt)
> >  {
> > -       atomic_long_sub(amt, sk->sk_prot->memory_allocated);
> > +       int local_reserve;
> > +
> > +       preempt_disable();
> > +       local_reserve = __this_cpu_sub_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
> > +       if (local_reserve <= -SK_MEMORY_PCPU_RESERVE) {
> > +               __this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
> > +               atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
> > +       }
> > +       preempt_enable();
> >  }
> >
> >  #define SK_ALLOC_PERCPU_COUNTER_BATCH 16
> > @@ -1441,12 +1467,6 @@ proto_sockets_allocated_sum_positive(struct proto *prot)
> >         return percpu_counter_sum_positive(prot->sockets_allocated);
> >  }
> >
> > -static inline long
> > -proto_memory_allocated(struct proto *prot)
> > -{
> > -       return atomic_long_read(prot->memory_allocated);
> > -}
> > -
> >  static inline bool
> >  proto_memory_pressure(struct proto *prot)
> >  {
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
