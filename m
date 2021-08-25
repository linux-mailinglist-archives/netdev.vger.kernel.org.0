Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB93E3F7931
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 17:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbhHYPkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 11:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbhHYPkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 11:40:39 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED75C0613C1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 08:39:53 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id b64so13885026qkg.0
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 08:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zjssu5ahlXThFXNBjYOHJIYjJl60yuZstUx26e7TTp0=;
        b=htWC6Nv5ySrGX2xuBWtOPuyg8qgjrsPVrKobVhrtrKxoLrRSEB4K1lc40aUJHg2ypP
         U56wBsk5aHSqRUkpjcJvITpQY2S1UA7MfAVyasq7eXi60Yb2lR5hiZDyTH7cGG0e8GsK
         HXGkohxsud/vQcxA3d+AZxc5lZXEZF0ZbwGxGTVLHA1Fg/fX3IncH8hCvfRr228sKk+S
         jzeIuafPN2Y+Z/dhjVJetDHV86RaeywL9N6quKUo5Cg0lQkl6VjBRzICH36ln/btpO+d
         jqwDn2SguuR74G+yyizWIIrrO+iK6jSVQibR5CAmzeQN8ipll6onyre6ZyoaSj9F0L6M
         rsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zjssu5ahlXThFXNBjYOHJIYjJl60yuZstUx26e7TTp0=;
        b=sfn3qF94VoGhbE1b2HMSlg9D0fQbHVAfxP7bZ24JCqkMXtbrod3+TtBf5vHlp9E8gu
         pCmss4El+DlC6p+DRe1ms6yNm/L/rzWfm7pxeZJPI4j7N4NnE8CwZU5gVDg7i3WSrnt/
         zRD7/IdVWWJrBWEMDWB8mjSMMuzPnIueSLQz9NiK1fwNXlFFem01KyOoF6Who9hhr8mp
         KW4mVysYcWTuEupcEsIge4Kjat+07hEPbVBwxLaatKCTw9jQRRfBifYOfF+b7HAEy+EC
         TsHRJAcwvrOQD0VP2nlZB+ZQNauFNZpDqKRFPz/4mL0MoX0wiD0BnHFi9L124O3CN15U
         eIhQ==
X-Gm-Message-State: AOAM532QK2bdHIHTK8myBn/yIodO8+jDs/8bO+qEFt0XMhvUzmlPQ/Cm
        iynUYFkTwRDzpXs/apDs+aDYbihCY/CDvf5ZavAQww==
X-Google-Smtp-Source: ABdhPJwnx8VGSiF3ofmAzyFVczdtlbK+E3GAYoUX5PekX2iKCZs5fZ/8w/F5Hz+f6EBeOvVKSXQmmPFvFq6QTgUyPuY=
X-Received: by 2002:a25:d6d8:: with SMTP id n207mr20551970ybg.518.1629905991975;
 Wed, 25 Aug 2021 08:39:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210824125140.190253-1-yan2228598786@gmail.com>
 <20210824112957.3a780186@oasis.local.home> <CALcyL7icKx5RH9UXiEqLmZtP5MViip5Pn1yNyogbADA3Xeo3xw@mail.gmail.com>
In-Reply-To: <CALcyL7icKx5RH9UXiEqLmZtP5MViip5Pn1yNyogbADA3Xeo3xw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 25 Aug 2021 08:39:40 -0700
Message-ID: <CANn89iKCDkKTJxK2LuAXN7DmVMwE9zbemtKRAhrTpHR+Uc71SA@mail.gmail.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing
To:     Zhongya Yan <yan2228598786@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 5:08 PM Zhongya Yan <yan2228598786@gmail.com> wrote=
:
>
> Cool, thanks!
> i will do it

Since these drops are hardly hot path, why not simply use a string ?
An ENUM will not really help grep games.

tcp_drop(sk, skb, "csum error");

The const char * argument would not be used unless tracepoint is
active, but who cares.

(Speaking of csum errors, they are not currently calling tcp_drop(),
but we could unify all packet drops to use this tracepoint,
and get rid of adhoc ones, like trace_tcp_bad_csum()

>
> Steven Rostedt <rostedt@goodmis.org> =E4=BA=8E2021=E5=B9=B48=E6=9C=8824=
=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=8811:30=E5=86=99=E9=81=93=EF=BC=
=9A
>>
>> On Tue, 24 Aug 2021 05:51:40 -0700
>> Zhongya Yan <yan2228598786@gmail.com> wrote:
>>
>> > When using `tcp_drop(struct sock *sk, struct sk_buff *skb)` we can
>> > not tell why we need to delete `skb`. To solve this problem I updated =
the
>> > method `tcp_drop(struct sock *sk, struct sk_buff *skb, enum tcp_drop_r=
eason reason)`
>> > to include the source of the deletion when it is done, so you can
>> > get an idea of the reason for the deletion based on the source.
>> >
>> > The current purpose is mainly derived from the suggestions
>> > of `Yonghong Song` and `brendangregg`:
>> >
>> > https://github.com/iovisor/bcc/issues/3533.
>> >
>> > "It is worthwhile to mention the context/why we want to this
>> > tracepoint with bcc issue https://github.com/iovisor/bcc/issues/3533.
>> > Mainly two reasons: (1). tcp_drop is a tiny function which
>> > may easily get inlined, a tracepoint is more stable, and (2).
>> > tcp_drop does not provide enough information on why it is dropped.
>> > " by Yonghong Song
>> >
>> > Signed-off-by: Zhongya Yan <yan2228598786@gmail.com>
>> > ---
>> >  include/net/tcp.h          | 11 ++++++++
>> >  include/trace/events/tcp.h | 56 +++++++++++++++++++++++++++++++++++++=
+
>> >  net/ipv4/tcp_input.c       | 34 +++++++++++++++--------
>> >  3 files changed, 89 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/include/net/tcp.h b/include/net/tcp.h
>> > index 784d5c3ef1c5..dd8cd8d6f2f1 100644
>> > --- a/include/net/tcp.h
>> > +++ b/include/net/tcp.h
>> > @@ -254,6 +254,17 @@ extern atomic_long_t tcp_memory_allocated;
>> >  extern struct percpu_counter tcp_sockets_allocated;
>> >  extern unsigned long tcp_memory_pressure;
>> >
>> > +enum tcp_drop_reason {
>> > +     TCP_OFO_QUEUE =3D 1,
>> > +     TCP_DATA_QUEUE_OFO =3D 2,
>> > +     TCP_DATA_QUEUE =3D 3,
>> > +     TCP_PRUNE_OFO_QUEUE =3D 4,
>> > +     TCP_VALIDATE_INCOMING =3D 5,
>> > +     TCP_RCV_ESTABLISHED =3D 6,
>> > +     TCP_RCV_SYNSENT_STATE_PROCESS =3D 7,
>> > +     TCP_RCV_STATE_PROCESS =3D 8
>>
>> As enums increase by one, you could save yourself the burden of
>> updating the numbers and just have:
>>
>> enum tcp_drop_reason {
>>         TCP_OFO_QUEUE =3D 1,
>>         TCP_DATA_QUEUE_OFO,
>>         TCP_DATA_QUEUE,
>>         TCP_PRUNE_OFO_QUEUE,
>>         TCP_VALIDATE_INCOMING,
>>         TCP_RCV_ESTABLISHED,
>>         TCP_RCV_SYNSENT_STATE_PROCESS,
>>         TCP_RCV_STATE_PROCESS
>> };
>>
>> Which would do the same.
>>
>>
>> > +};
>> > +
>> >  /* optimized version of sk_under_memory_pressure() for TCP sockets */
>> >  static inline bool tcp_under_memory_pressure(const struct sock *sk)
>> >  {
>> > diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
>> > index 521059d8dc0a..a0d3d31eb591 100644
>> > --- a/include/trace/events/tcp.h
>> > +++ b/include/trace/events/tcp.h
>> > @@ -371,6 +371,62 @@ DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
>> >       TP_ARGS(skb)
>> >  );
>> >
>>
>> If you would like to see the english translation of what these
>> "reasons" are and not have to remember which number is which, you can
>> do the following:
>>
>> #define TCP_DROP_REASON                                                 =
\
>>         EM(TCP_OFO_QUEUE,               ofo_queue)                      =
\
>>         EM(TCP_DATA_QUEUE_OFO,          data_queue_ofo)                 =
\
>>         EM(TCP_DATA_QUEUE,              data_queue)                     =
\
>>         EM(TCP_PRUNE_OFO_QUEUE,         prune_ofo_queue)                =
\
>>         EM(TCP_VALIDATE_INCOMING,       validate_incoming)              =
\
>>         EM(TCP_RCV_ESTABLISHED,         rcv_established)                =
\
>>         EM(TCP_RCV_SYNSENT_STATE_PROCESS, rcv_synsent_state_process)    =
\
>>         EMe(TCP_RCV_STATE_PROCESS,      rcv_state_proces)
>>
>> #undef EM
>> #undef EMe
>>
>> #define EM(a,b) { a, #b },
>> #define EMe(a, b) { a, #b }
>>
>>
>> > +TRACE_EVENT(tcp_drop,
>> > +             TP_PROTO(struct sock *sk, struct sk_buff *skb, enum tcp_=
drop_reason reason),
>> > +
>> > +             TP_ARGS(sk, skb, reason),
>> > +
>> > +             TP_STRUCT__entry(
>> > +                     __array(__u8, saddr, sizeof(struct sockaddr_in6)=
)
>> > +                     __array(__u8, daddr, sizeof(struct sockaddr_in6)=
)
>> > +                     __field(__u16, sport)
>> > +                     __field(__u16, dport)
>> > +                     __field(__u32, mark)
>> > +                     __field(__u16, data_len)
>> > +                     __field(__u32, snd_nxt)
>> > +                     __field(__u32, snd_una)
>> > +                     __field(__u32, snd_cwnd)
>> > +                     __field(__u32, ssthresh)
>> > +                     __field(__u32, snd_wnd)
>> > +                     __field(__u32, srtt)
>> > +                     __field(__u32, rcv_wnd)
>> > +                     __field(__u64, sock_cookie)
>> > +                     __field(__u32, reason)
>> > +                     ),
>> > +
>> > +             TP_fast_assign(
>> > +                             const struct tcphdr *th =3D (const struc=
t tcphdr *)skb->data;
>> > +                             const struct inet_sock *inet =3D inet_sk=
(sk);
>> > +                             const struct tcp_sock *tp =3D tcp_sk(sk)=
;
>> > +
>> > +                             memset(__entry->saddr, 0, sizeof(struct =
sockaddr_in6));
>> > +                             memset(__entry->daddr, 0, sizeof(struct =
sockaddr_in6));
>> > +
>> > +                             TP_STORE_ADDR_PORTS(__entry, inet, sk);
>> > +
>> > +                             __entry->sport =3D ntohs(inet->inet_spor=
t);
>> > +                             __entry->dport =3D ntohs(inet->inet_dpor=
t);
>> > +                             __entry->mark =3D skb->mark;
>> > +
>> > +                             __entry->data_len =3D skb->len - __tcp_h=
drlen(th);
>> > +                             __entry->snd_nxt =3D tp->snd_nxt;
>> > +                             __entry->snd_una =3D tp->snd_una;
>> > +                             __entry->snd_cwnd =3D tp->snd_cwnd;
>> > +                             __entry->snd_wnd =3D tp->snd_wnd;
>> > +                             __entry->rcv_wnd =3D tp->rcv_wnd;
>> > +                             __entry->ssthresh =3D tcp_current_ssthre=
sh(sk);
>> > +             __entry->srtt =3D tp->srtt_us >> 3;
>> > +             __entry->sock_cookie =3D sock_gen_cookie(sk);
>> > +             __entry->reason =3D reason;
>> > +             ),
>> > +
>> > +             TP_printk("src=3D%pISpc dest=3D%pISpc mark=3D%#x data_le=
n=3D%d snd_nxt=3D%#x snd_una=3D%#x snd_cwnd=3D%u ssthresh=3D%u snd_wnd=3D%u=
 srtt=3D%u rcv_wnd=3D%u sock_cookie=3D%llx reason=3D%d",
>>
>> Then above you can have: "reason=3D%s"
>>
>> > +                             __entry->saddr, __entry->daddr, __entry-=
>mark,
>> > +                             __entry->data_len, __entry->snd_nxt, __e=
ntry->snd_una,
>> > +                             __entry->snd_cwnd, __entry->ssthresh, __=
entry->snd_wnd,
>> > +                             __entry->srtt, __entry->rcv_wnd, __entry=
->sock_cookie, __entry->reason)
>>
>> And here:
>>
>>         __print_symbolic(__entry->reason, TCP_DROP_REASON)
>>
>> -- Steve
>>
>>
>> > +);
>> > +
>> >  #endif /* _TRACE_TCP_H */
>> >
>> >  /* This part must be outside protection */
>> >
