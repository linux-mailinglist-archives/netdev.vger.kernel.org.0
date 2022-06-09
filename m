Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD8054502B
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343645AbiFIPHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241180AbiFIPHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:07:47 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFA7140A2
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 08:07:46 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so21271746pjq.2
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 08:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0KrY227oU07VwF06wfMzozGFOTiDnRFrMaZf80tnZ/A=;
        b=Ep//Y+hIlZwPzFZ+7wgH1zrS+gCH0D/8dSQix5Pkljx1EPLhYhLpkSwM1WxKp9Eq1L
         sxpLKppmFtYAGbdgQVXCPTDhAFw36nE3E/ZSyoHT8OEzaV8xe/uWolUZytN3xbg7EvFN
         04gfWxpHJwTRtq+OF/+8vBEwvI410mdwlULXCe7YrkMQyWElAdfcJ1Q/iaxg/m5FUM3i
         hWJxW/q1gqd4eBiOJWzmLcVKTt29qjYTPM5j4psDKJsh6F9DT2fYo3Jx6wYVyTPtjuLf
         I+AiDzWAgxOnrmqATlZqJVVzx2ts+VMME/0KEKdVHkCT9I8NfWC/T32znbOC9ALwNFiI
         WXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0KrY227oU07VwF06wfMzozGFOTiDnRFrMaZf80tnZ/A=;
        b=thvJAJysl4HLLSxTBzPlaDRcNjEsSTtM/m4ZmwQmTPTOvOibfO2Qerl21YTCotRtf2
         2yJR19ofNpSVtxN4fDuNSSPqELxFcp3x+LX9+K6D3S85iRBkE/GEHA2l9JpJvJ91oAO6
         D4vCg1FFSJ2E08QhVUfP6eYKOR0xJ6frQN5En8zg5qVbZcLBVwApZIuW9Puug4RnkdAm
         ieg/bsDCAR/k7567cw5NCiKCTg56xXINz9d1CfLBJzq8d9xXCeq2hZn8TIC8654Yhxdl
         pHn1524M3yqGHMNNlQqZ6yd05zSYP0FL0VR3iAmIpYWIAJ6+QjFwhrOC7V8GcZT5BJRf
         C/tQ==
X-Gm-Message-State: AOAM5313igf1mkq1LxLhtT9+MqjYs9kWyc1vRWZ9UjNgNLSJjteAlPbX
        QxZwGoMVsNr60prYYcV03WWsJ3fgD3LIsL/RHUiW8A==
X-Google-Smtp-Source: ABdhPJx6dATKqF5qj49H7FrsfvhDzY/DunCnvvx3LEC83Qy0PCgOqiTBnLJugrRHsaDY5Q3Im30CkszuwNRMG90UD0A=
X-Received: by 2002:a17:90b:1d90:b0:1e8:5a98:d591 with SMTP id
 pf16-20020a17090b1d9000b001e85a98d591mr3885123pjb.126.1654787265407; Thu, 09
 Jun 2022 08:07:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
 <20220609063412.2205738-5-eric.dumazet@gmail.com> <CADVnQynuQjbi67or7E_6JRy3SDznyp+9dT-hGbnAuqOSVJ+PUA@mail.gmail.com>
In-Reply-To: <CADVnQynuQjbi67or7E_6JRy3SDznyp+9dT-hGbnAuqOSVJ+PUA@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 9 Jun 2022 08:07:34 -0700
Message-ID: <CALvZod78+NA+x4Fd2rwytCyf4rBQd8aGbWa=-kQ=zFGGTjcp-w@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: implement per-cpu reserves for memory_allocated
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>
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

On Thu, Jun 9, 2022 at 7:46 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> /
>
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
>
> I would have thought these last two lines would be:
>
>                __this_cpu_add(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
>                atomic_long_sub(local_reserve, sk->sk_prot->memory_allocated);
>
> Otherwise I don't see how sk->sk_prot->memory_allocated) ever
> decreases in these sk_memory_allocated_add/sk_memory_allocated_sub
> functions?
>
> That is, is there a copy-and-paste/typo issue in these two lines? Or
> is my understanding backwards? (In which case I apologize for the
> noise!)

local_reserve is negative in that case and adding a negative number is
subtraction.
