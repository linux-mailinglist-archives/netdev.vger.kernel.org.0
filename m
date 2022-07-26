Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6826A5817E4
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 18:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbiGZQuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 12:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239541AbiGZQuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 12:50:10 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9306D68
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:50:08 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-31f41584236so40773687b3.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I7bCf/aBvPvdjsxMfixJF46/WCNW1Ng82IgsD4485HA=;
        b=jqVz0GIJ4HwuZGr3LLf0YmpbkRcBiu7oEVux6vqeu9kWxFwMfHMXMTua22ZGsn+Yxf
         etSZNulvgwLUM9HQ12zSCmmFqztIeKTNvL6xTsnQ/7JBHwZ7l9aI51mSGImmaSNtiahi
         GMoarTarfY9+zKpYxOYVb+TJemToXns/BPvSmuFg6MW+p2lVT1pLjUqlmQIbxQPMVY9R
         eBRHDQb19TfI5NdpkrBwTJBmluZDbCQNwJglux5/SJOC25qMdnKgFUHRziJYVywRQCfN
         QvsA0/iHytz17SV8qwVDU+eycFb0NQLch2imy1Z5CcwL+h710RZ/a0SeY5DBhuZMKX5+
         CMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I7bCf/aBvPvdjsxMfixJF46/WCNW1Ng82IgsD4485HA=;
        b=bor3OVucB6evJgZSUx4rdaj0zrRPUsKrIMxEZyTbChzE3ms0h5qCO52DLIqTmNqJ0F
         u/vd9YF7ZY9Qb5CZbe+Ot9s+P+0Zi1N6e45EpTBXlxHUIvBBk3rzi9xkimB6jUuj2Y/D
         aHW6CbZ7OfR3V/kwdi8CQmN8WLO10B492kVpzSZMh2jmO7QtwLpnJkm4u3ZmuIXN22vd
         Bc9lZaghMfs5SxzognRv2zF0a3+gQ6YSvsMXZI0/Fm0vYkGHnsZ+YVv6IHfQ7ME0TsOS
         ldVlUXrqkAs6NNH9R1vxCl6GQSZakRcwSuWFfQtbfWLJXFATZDl8k8D+pCMlT1P6SzGm
         DVeQ==
X-Gm-Message-State: AJIora8gibemwIC+nMUdrzo3vj3H1aK3pjuy3/xjHGSwveSJiCIQeNRZ
        ArdMY+ywAH15AH6LL684phYotJLxxaXcMP4xjB67zA==
X-Google-Smtp-Source: AGRyM1s2WffWIccLn9fKPqByVFkaTTkXmRF6hBKCpWw6fAYnTDiGGwi+2uUjejHpTVNZ8DDM4AWmg7JOs5UHifnw3+I=
X-Received: by 2002:a0d:dbc4:0:b0:31f:5b63:86d4 with SMTP id
 d187-20020a0ddbc4000000b0031f5b6386d4mr577203ywe.467.1658854207861; Tue, 26
 Jul 2022 09:50:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220709222029.297471-1-xiyou.wangcong@gmail.com>
 <CANn89iJSQh-5DAhEL4Fh5ZDrtY47y0Mo9YJbG-rnj17pdXqoXA@mail.gmail.com>
 <YtQ/Np8DZBJVFO3l@pop-os.localdomain> <CANn89iLLANJLHG+_uUu5Z+V64BMCsYHRgCHVHENhZiMOrVUtMw@mail.gmail.com>
 <Yt2IgGuqVi9BHc/g@pop-os.localdomain> <CANn89iLHg-D3q8jPFq_87mLFPh5L7arbaF2aNeY42s4VUv_D-Q@mail.gmail.com>
 <YuAS69C22HEi87qD@pop-os.localdomain> <CANn89iKy9bb2DFpTVosSV2-bpsoLgYPpz3Ep+Qf=EvAqYAWXxw@mail.gmail.com>
In-Reply-To: <CANn89iKy9bb2DFpTVosSV2-bpsoLgYPpz3Ep+Qf=EvAqYAWXxw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 26 Jul 2022 18:49:56 +0200
Message-ID: <CANn89iLH1j-mNeNWUGKvwe55Wgv488X2WT-_Rry0vFN89sJjLQ@mail.gmail.com>
Subject: Re: [Patch bpf-next] tcp: fix sock skb accounting in tcp_read_skb()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 6:47 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jul 26, 2022 at 6:14 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> > If TCP really wants to queue a FIN with skb->len==0, then we have to
> > adjust the return value for recv_actor(), because we currently use 0 as
> > an error too (meaning no data is consumed):
> >
> >         if (sk_psock_verdict_apply(psock, skb, ret) < 0)
> >                 len = 0;  // here!
> > out:
> >         rcu_read_unlock();
> >         return len;
> >
> >
> > BTW, what is wrong if we simply drop it before queueing to
> > sk_receive_queue in TCP? Is it there just for collapse?
>
> Because an incoming segment can have payload and FIN.
>
> The consumer will need to consume the payload before FIN is considered/consumed,
> with the complication of MSG_PEEK ...
>
> Right after tcp_read_skb() removes the skb from sk_receive_queue,
> we need to update TCP state, regardless of recv_actor().
>
> Maybe like that:
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index ba2bdc81137490bd1748cde95789f8d2bff3ab0f..6e2c11cd921872e406baffc475c9870e147578a1
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1759,20 +1759,15 @@ int tcp_read_skb(struct sock *sk,
> skb_read_actor_t recv_actor)
>                 int used;
>
>                 __skb_unlink(skb, &sk->sk_receive_queue);
> +               seq = TCP_SKB_CB(skb)->end_seq;
>                 used = recv_actor(sk, skb);
>                 if (used <= 0) {
>                         if (!copied)
>                                 copied = used;
>                         break;
>                 }
> -               seq += used;
>                 copied += used;
>
> -               if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> -                       consume_skb(skb);
> -                       ++seq;
> -                       break;
> -               }
>                 consume_skb(skb);
>                 break;
>         }

Or even better:

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ba2bdc81137490bd1748cde95789f8d2bff3ab0f..66c187a2592c042565211565adb3f40a811dfd7d
100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1759,21 +1759,15 @@ int tcp_read_skb(struct sock *sk,
skb_read_actor_t recv_actor)
                int used;

                __skb_unlink(skb, &sk->sk_receive_queue);
+               seq = TCP_SKB_CB(skb)->end_seq;
                used = recv_actor(sk, skb);
+               consume_skb(skb);
                if (used <= 0) {
                        if (!copied)
                                copied = used;
                        break;
                }
-               seq += used;
                copied += used;
-
-               if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
-                       consume_skb(skb);
-                       ++seq;
-                       break;
-               }
-               consume_skb(skb);
                break;
        }
        WRITE_ONCE(tp->copied_seq, seq);
