Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD96544E05
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 15:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245012AbiFINsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 09:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238119AbiFINso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 09:48:44 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ECCF5D
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 06:48:42 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id o7so14309682eja.1
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 06:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ab9n2DdESSJpQ0b0br3k8UCrFg30AxA5ilFTDz+zsc=;
        b=khvo6ahNN36LOgOgeMIjubG2FFbVjkGWku0JV00uwn4cA5BWvLL/dNcSye5gs0wb6l
         JOBX3mr8W6jOo/NypiiuF/Ja13OFBdtkKa6muYift0ywFAa/oNax0oa6ygy1Da7/iUOY
         cNCNWEgWsRSNaMEjMmG3gvgLTzKopv0FgWQshyP4HU9zqxaiXYy1FcLu+0bxugels7FF
         2wjPMXE1Dx2crG3iBzKQ9eB7Bh89wwP2CxHFJU7PSNZLAWtT2Ay/gIFl0pcY/3Trkl63
         CfmMQRTNVbK+8lh2f8k/VqIWJ/UJT7xeK+pZx9+xumxEtKeL4ova9Ub0r6Jc0Xi5/Roz
         /xHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ab9n2DdESSJpQ0b0br3k8UCrFg30AxA5ilFTDz+zsc=;
        b=RL12bHYYZ6NlcJsS2a0BumceE0HH4KXzk6cDvyYaFdXJxVst6+TMrq8Ca4e/oSs9Wk
         3vpe6GYMiW2cEjMFdZT2v2it3/jAlmefjWup4GOKZI3lrmAJ78A6vVTm3IUhnxN/xmDC
         D8o3XOe0y9KAERV/cCiDiATc0vRN2czfKHfnpzrAo6UbF92eICMPtOsP+0xBcUY+Zlh1
         Mbrfi1uCgtEdDKMcCRiV6wK6t28M7TnLi1oKGnoGuEGO/1fO+FeXmPPUSmWBl8yqLGlF
         46jlsR1PWQWwBHvKgHQix74aA+7J3qKXBMqE6ioER7MuByIenD8InH/k6uPvR2X0XuGE
         CYFQ==
X-Gm-Message-State: AOAM53281yNcGRu9MebeKj39DWdofH8/CD+oIgwZ4mGz6XuHGQZCueH6
        j1qqETvBGWzo79XTNjWCshx5RQkxTyYelkq+Kv78Ig==
X-Google-Smtp-Source: ABdhPJwmOReHTwbETJ5huBXV523AuDL5Uj160nXyvyH6/krbSHVMyGJ3yPN/v7cfhPyuw/dXNdZaFqAvL/o386WYRYI=
X-Received: by 2002:a17:907:7da5:b0:711:c9cd:61e0 with SMTP id
 oz37-20020a1709077da500b00711c9cd61e0mr21000761ejc.443.1654782520340; Thu, 09
 Jun 2022 06:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
 <20220609063412.2205738-5-eric.dumazet@gmail.com> <CACSApvYEwczGVvOxOfDXNHd_x5LDb1vXT03y-=6CcrTv1uR9Kw@mail.gmail.com>
 <CANn89iKbam05mjKCN4bS6H42x1_Jw1a=G3vbrNM3FTTjvXABWg@mail.gmail.com>
In-Reply-To: <CANn89iKbam05mjKCN4bS6H42x1_Jw1a=G3vbrNM3FTTjvXABWg@mail.gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 9 Jun 2022 09:48:03 -0400
Message-ID: <CACSApvYGhsswH6yJQDbrT0FYLwm6ost057_7uu+H1TWVY8JkjA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: implement per-cpu reserves for memory_allocated
To:     Eric Dumazet <edumazet@google.com>
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

On Thu, Jun 9, 2022 at 9:47 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jun 9, 2022 at 6:34 AM Soheil Hassas Yeganeh <soheil@google.com> wrote:
> >
> > On Thu, Jun 9, 2022 at 2:34 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > We plan keeping sk->sk_forward_alloc as small as possible
> > > in future patches.
> > >
> > > This means we are going to call sk_memory_allocated_add()
> > > and sk_memory_allocated_sub() more often.
> > >
> > > Implement a per-cpu cache of +1/-1 MB, to reduce number
> > > of changes to sk->sk_prot->memory_allocated, which
> > > would otherwise be cause of false sharing.
> > >
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> >
> > Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> >
> > > ---
> > >  include/net/sock.h | 38 +++++++++++++++++++++++++++++---------
> > >  1 file changed, 29 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/include/net/sock.h b/include/net/sock.h
> > > index 825f8cbf791f02d798f17dd4f7a2659cebb0e98a..59040fee74e7de8d63fbf719f46e172906c134bb 100644
> > > --- a/include/net/sock.h
> > > +++ b/include/net/sock.h
> > > @@ -1397,22 +1397,48 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
> > >         return !!*sk->sk_prot->memory_pressure;
> > >  }
> > >
> > > +static inline long
> > > +proto_memory_allocated(const struct proto *prot)
> > > +{
> > > +       return max(0L, atomic_long_read(prot->memory_allocated));
> > > +}
> > > +
> > >  static inline long
> > >  sk_memory_allocated(const struct sock *sk)
> > >  {
> > > -       return atomic_long_read(sk->sk_prot->memory_allocated);
> > > +       return proto_memory_allocated(sk->sk_prot);
> > >  }
> > >
> > > +/* 1 MB per cpu, in page units */
> > > +#define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
> > > +
> > >  static inline long
> > >  sk_memory_allocated_add(struct sock *sk, int amt)
> > >  {
> > > -       return atomic_long_add_return(amt, sk->sk_prot->memory_allocated);
> > > +       int local_reserve;
> > > +
> > > +       preempt_disable();
> > > +       local_reserve = __this_cpu_add_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
> > > +       if (local_reserve >= SK_MEMORY_PCPU_RESERVE) {
> > > +               __this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
> >
> > This is just a nitpick, but we could
> > __this_cpu_write(*sk->sk_prot->per_cpu_fw_alloc, 0) instead which
> > should be slightly faster.
>
> This would require us to block irqs, not only preempt_disable()/preempt_enable()
>
> Otherwise when doing the write, there is no guarantee we replace the
> intended value,
> as an interrupt could have changed this cpu per_cpu_fw_alloc.
>
> A __this_cpu_cmpxchg() would make sure of that, but would be more
> expensive than __this_cpu_sub() and would require a loop.
>
>  With my change, there is a tiny possibility that
> *sk->sk_prot->per_cpu_fw_alloc, is not in the -1/+1 1MB range,
> but no lasting consequences, next update will consolidate things, and
> tcp_memory_allocated will not drift.

Ah that makes sense. Thank you for the explanation!

> >
> > > +               atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
> > > +       }
> > > +       preempt_enable();
> > > +       return sk_memory_allocated(sk);
> > >  }
> > >
> > >  static inline void
> > >  sk_memory_allocated_sub(struct sock *sk, int amt)
> > >  {
> > > -       atomic_long_sub(amt, sk->sk_prot->memory_allocated);
> > > +       int local_reserve;
> > > +
> > > +       preempt_disable();
> > > +       local_reserve = __this_cpu_sub_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
> > > +       if (local_reserve <= -SK_MEMORY_PCPU_RESERVE) {
> > > +               __this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
> > > +               atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
> > > +       }
> > > +       preempt_enable();
> > >  }
> > >
> > >  #define SK_ALLOC_PERCPU_COUNTER_BATCH 16
> > > @@ -1441,12 +1467,6 @@ proto_sockets_allocated_sum_positive(struct proto *prot)
> > >         return percpu_counter_sum_positive(prot->sockets_allocated);
> > >  }
> > >
> > > -static inline long
> > > -proto_memory_allocated(struct proto *prot)
> > > -{
> > > -       return atomic_long_read(prot->memory_allocated);
> > > -}
> > > -
> > >  static inline bool
> > >  proto_memory_pressure(struct proto *prot)
> > >  {
> > > --
> > > 2.36.1.255.ge46751e96f-goog
> > >
