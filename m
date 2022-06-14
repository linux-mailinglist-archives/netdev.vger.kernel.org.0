Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBCA54BB40
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 22:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358242AbiFNURx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357679AbiFNUR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:17:26 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85105B1E5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 13:17:14 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id p83so4575045vkf.6
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 13:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VsYappxLdOUCwkVdljxso7ZG/0ARTQehr3CV70flvW0=;
        b=M79Po5R00gTUMFdhbxJQzT3rU/mNesVLUS3nuFfmICv4zmohnfqaRhDwH6BfpNPggF
         t1c41v+RXm1u67VKlYnlqVWm5u8Tkv3NqweNjPOS2F2pOcgNRzKERXTtscRHDVMwLyw9
         mK+nhIZ3uSCPqqYH4l0K2v5pRErzeeKHu/EsOlGvaapTRqeAQ3VGH/d52SqZYrb/CnmA
         E77LQA3PCmJU6DrmRfXWwDa2FYrMic//6cHTTE4do2vTMwAyMsBrUXWyHr62tYKOw+tY
         mtjOw9FrFT1iWJD9G+vXxuJVATNYFxmPxaxfk7B5AGCDioY8sR0a5Zx4Hj4dohSHX4YY
         n+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VsYappxLdOUCwkVdljxso7ZG/0ARTQehr3CV70flvW0=;
        b=22zmowSgHiaqqM+4MTNZNEtCVnECY5j0puizLiaPqt8Yw9fy/1z00PGPLTjeZ9NDuC
         ivKyU42CcdS7Zs5WKtRyXySTtL9Ri03N+Y2cS6MwZBKo+aL4QQTfcKBWiIijEsX7E1eZ
         MY5ycCfXOEEQbs7xw6DiAg3ifU1GZwEEMQ6CisCwifINEg8NkT4GJe9aOn1gQ4UQdndf
         KOTpyF9kbDf1KrAH8/KW2C0VyNF81eU5RkUyoA4fDoVdQN897C4O7Jk0M66kSOvYb575
         SS+EtVD8GoKr5jN9CmZ0B10Yl10S7KDFuIYwTjZq0IP9OO+Zd0TcbopSGDs6lY9PUINc
         y05Q==
X-Gm-Message-State: AJIora/GuaiXIAFJG1qVDRWrgqd4ZGIlBPh/gwwBXznXU4uMKHOfChJT
        h3/06ZiUe//evLavo2MgR+hB7YLqQ4UHc14+KCnLGA==
X-Google-Smtp-Source: AGRyM1uIr6u5ABFG3TljC+l7kLpWL7KUIXcV7pcp93zRazsBWEl0c9paCxQiIhBeViR9lo7jmUJJmEyuEW9Ky2l6A1Y=
X-Received: by 2002:a1f:5185:0:b0:35e:147d:5b00 with SMTP id
 f127-20020a1f5185000000b0035e147d5b00mr3268761vkb.28.1655237833489; Tue, 14
 Jun 2022 13:17:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220614171734.1103875-1-eric.dumazet@gmail.com>
 <20220614171734.1103875-3-eric.dumazet@gmail.com> <CACSApvZPx8G8+TaZbxqS19M8tmBmcSq4uGtQskGxD=dGwm7T3A@mail.gmail.com>
 <CAEA6p_B43zQnuW6_C06RxMYUhvYdTyVgvshqqNu7+nJZzecWNQ@mail.gmail.com> <CANn89iJYwSoL-XvkcUK1am2wYQjToMnNRG-9pD9qY8+L=GyqaA@mail.gmail.com>
In-Reply-To: <CANn89iJYwSoL-XvkcUK1am2wYQjToMnNRG-9pD9qY8+L=GyqaA@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 14 Jun 2022 13:17:02 -0700
Message-ID: <CAEA6p_BXZgfep7kCyR2rbQ_jv-wKENzJk9QZRjfrL13gLjNyGA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] tcp: fix possible freeze in tx path under
 memory pressure
To:     Eric Dumazet <edumazet@google.com>
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
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

On Tue, Jun 14, 2022 at 12:10 PM Eric Dumazet <edumazet@google.com> wrote:
>
>
>
> On Tue, Jun 14, 2022, 11:41 AM Wei Wang <weiwan@google.com> wrote:
>>
>> On Tue, Jun 14, 2022 at 10:42 AM Soheil Hassas Yeganeh
>> <soheil@google.com> wrote:
>> >
>> > On Tue, Jun 14, 2022 at 1:17 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> > >
>> > > From: Eric Dumazet <edumazet@google.com>
>> > >
>> > > Blamed commit only dealt with applications issuing small writes.
>> > >
>> > > Issue here is that we allow to force memory schedule for the sk_buff
>> > > allocation, but we have no guarantee that sendmsg() is able to
>> > > copy some payload in it.
>> > >
>> > > In this patch, I make sure the socket can use up to tcp_wmem[0] bytes.
>> > >
>> > > For example, if we consider tcp_wmem[0] = 4096 (default on x86),
>> > > and initial skb->truesize being 1280, tcp_sendmsg() is able to
>> > > copy up to 2816 bytes under memory pressure.
>> > >
>> > > Before this patch a sendmsg() sending more than 2816 bytes
>> > > would either block forever (if persistent memory pressure),
>> > > or return -EAGAIN.
>> > >
>> > > For bigger MTU networks, it is advised to increase tcp_wmem[0]
>> > > to avoid sending too small packets.
>> > >
>> > > v2: deal with zero copy paths.
>> > >
>> > > Fixes: 8e4d980ac215 ("tcp: fix behavior for epoll edge trigger")
>> > > Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Wei Wang <weiwan@google.com>

>> >
>> > Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
>> >
>> > Very nice find! Thank you!
>> >
>> > > ---
>> > >  net/ipv4/tcp.c | 33 +++++++++++++++++++++++++++++----
>> > >  1 file changed, 29 insertions(+), 4 deletions(-)
>> > >
>> > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> > > index 14ebb4ec4a51f3c55501aa53423ce897599e8637..56083c2497f0b695c660256aa43f8a743d481697 100644
>> > > --- a/net/ipv4/tcp.c
>> > > +++ b/net/ipv4/tcp.c
>> > > @@ -951,6 +951,23 @@ static int tcp_downgrade_zcopy_pure(struct sock *sk, struct sk_buff *skb)
>> > >         return 0;
>> > >  }
>> > >
>> > > +static int tcp_wmem_schedule(struct sock *sk, int copy)
>> > > +{
>> > > +       int left;
>> > > +
>> > > +       if (likely(sk_wmem_schedule(sk, copy)))
>> > > +               return copy;
>> > > +
>> > > +       /* We could be in trouble if we have nothing queued.
>> > > +        * Use whatever is left in sk->sk_forward_alloc and tcp_wmem[0]
>> > > +        * to guarantee some progress.
>> > > +        */
>> > > +       left = sock_net(sk)->ipv4.sysctl_tcp_wmem[0] - sk->sk_wmem_queued;
>> > > +       if (left > 0)
>> > > +               sk_forced_mem_schedule(sk, min(left, copy));
>> > > +       return min(copy, sk->sk_forward_alloc);
>> > > +}
>> > > +
>> > >  static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
>> > >                                       struct page *page, int offset, size_t *size)
>> > >  {
>> > > @@ -986,7 +1003,11 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
>> > >                 tcp_mark_push(tp, skb);
>> > >                 goto new_segment;
>> > >         }
>> > > -       if (tcp_downgrade_zcopy_pure(sk, skb) || !sk_wmem_schedule(sk, copy))
>> > > +       if (tcp_downgrade_zcopy_pure(sk, skb))
>> > > +               return NULL;
>>
>> Do we need to take care of the call to sk_wmem_schedule() inside
>> tcp_downgrade_zcopy_pure()?
>
>
> We can not. Payload has been added already, and will be sent eventually.

Ack. Thanks for the explanation.


>>
>>
>> > > +
>> > > +       copy = tcp_wmem_schedule(sk, copy);
>> > > +       if (!copy)
>> > >                 return NULL;
>> > >
>> > >         if (can_coalesce) {
>> > > @@ -1334,8 +1355,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>> > >
>> > >                         copy = min_t(int, copy, pfrag->size - pfrag->offset);
>> > >
>> > > -                       if (tcp_downgrade_zcopy_pure(sk, skb) ||
>> > > -                           !sk_wmem_schedule(sk, copy))
>> > > +                       if (tcp_downgrade_zcopy_pure(sk, skb))
>> > > +                               goto wait_for_space;
>> > > +
>> > > +                       copy = tcp_wmem_schedule(sk, copy);
>> > > +                       if (!copy)
>> > >                                 goto wait_for_space;
>> > >
>> > >                         err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
>> > > @@ -1362,7 +1386,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>> > >                                 skb_shinfo(skb)->flags |= SKBFL_PURE_ZEROCOPY;
>> > >
>> > >                         if (!skb_zcopy_pure(skb)) {
>> > > -                               if (!sk_wmem_schedule(sk, copy))
>> > > +                               copy = tcp_wmem_schedule(sk, copy);
>> > > +                               if (!copy)
>> > >                                         goto wait_for_space;
>> > >                         }
>> > >
>> > > --
>> > > 2.36.1.476.g0c4daa206d-goog
>> > >
