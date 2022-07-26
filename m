Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4915817F8
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 18:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239493AbiGZQyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 12:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiGZQyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 12:54:01 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D924F2982E
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:54:00 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-31f41584236so40884767b3.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gavwKjhFQQ5TKsXOYCgufHF3sOURWM4HVXbr8TkyOzU=;
        b=Ob2roDwLgM1P2aK+MZeECsEN8nnVSznuA7P3anEdq9JkDGT8fOyvbYYDcRACznF1hg
         Yb5YSFP2Pk7qOYIWbq/dJIG/jkeTUeGbIlUQTg+Tlkrg6b9fKNNEVT7tJ6OW68y1XZFS
         zce7v+EmXtkcsSJZlZSQoOGpkN3nQFOxWm6Uu99hZMIjrIS6uDENpIyi5lEXQDwDJrOx
         5D2+MX80+lM2/haHfjobAdwAXfCt5LMx3SeRZf9Q8azZCy7OEvUockLwnpx+ZRBNaBdZ
         SqMU/YIinCToaG2HPWDGYszy0OtGpNPvuKlbTE3QC8n3LnsjKU8o7oWQcAe99GS1aA+s
         fchg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gavwKjhFQQ5TKsXOYCgufHF3sOURWM4HVXbr8TkyOzU=;
        b=8Pj6D2ghio9FHy1fNIRPjpXBmLHqX5xsSZNpHZo+i/ojJssaVMI7hxdg8uiU4/MuBW
         wx/fllmpyi1smN1ZDe6CQZbQRP+CcTNDp7JGUIH1WWSzQSs4OZsoemeE+qDRLi8YlnfW
         1KjIMS6wpsXUJmd6NXffQLsHhgCuvwpzq/bQpSaMUTgN3TBsPh07QYBdGhG6aMR8p2wY
         TLo+8DZV5OHL7ls7VLsoRgjcWzBhPlWxd6JxrIG0qrTspU5W5wKnqWy4m3b+JKZLZu2j
         Z5w/6vvXk+mOox8nLZYitcdm/3yYgWghPl17GEmQKmi10sUBVf6Z/sqqD9qLig7vAmtp
         Lh4Q==
X-Gm-Message-State: AJIora8+iAcjX/XuJD6X9xzEnvJ9Hh3M37adZQJttrJ8P525grvBP07h
        e3SrtZt6O5gohPPNoDzOPeArdEcCphpmjh4OXmMwEA==
X-Google-Smtp-Source: AGRyM1v/wwAZHGdxNJcM5ONf4lqp95m7J+9sdXk1yDLhmICdWv5A+Jeilea9cuwiRVGJhQCcITCaf7MrIjr8tVO08/4=
X-Received: by 2002:a81:394:0:b0:31e:7b3b:d74c with SMTP id
 142-20020a810394000000b0031e7b3bd74cmr15505971ywd.278.1658854439887; Tue, 26
 Jul 2022 09:53:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220709222029.297471-1-xiyou.wangcong@gmail.com>
 <CANn89iJSQh-5DAhEL4Fh5ZDrtY47y0Mo9YJbG-rnj17pdXqoXA@mail.gmail.com>
 <YtQ/Np8DZBJVFO3l@pop-os.localdomain> <CANn89iLLANJLHG+_uUu5Z+V64BMCsYHRgCHVHENhZiMOrVUtMw@mail.gmail.com>
 <Yt2IgGuqVi9BHc/g@pop-os.localdomain> <CANn89iLHg-D3q8jPFq_87mLFPh5L7arbaF2aNeY42s4VUv_D-Q@mail.gmail.com>
 <YuAS69C22HEi87qD@pop-os.localdomain> <CANn89iKy9bb2DFpTVosSV2-bpsoLgYPpz3Ep+Qf=EvAqYAWXxw@mail.gmail.com>
 <CANn89iLH1j-mNeNWUGKvwe55Wgv488X2WT-_Rry0vFN89sJjLQ@mail.gmail.com>
In-Reply-To: <CANn89iLH1j-mNeNWUGKvwe55Wgv488X2WT-_Rry0vFN89sJjLQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 26 Jul 2022 18:53:48 +0200
Message-ID: <CANn89iJ5yTX7f-Pv-yQs_kz+Xg7Ar7V_eF4cdeu6GimdVg-j9Q@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 6:49 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jul 26, 2022 at 6:47 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Jul 26, 2022 at 6:14 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > > If TCP really wants to queue a FIN with skb->len==0, then we have to
> > > adjust the return value for recv_actor(), because we currently use 0 as
> > > an error too (meaning no data is consumed):
> > >
> > >         if (sk_psock_verdict_apply(psock, skb, ret) < 0)
> > >                 len = 0;  // here!
> > > out:
> > >         rcu_read_unlock();
> > >         return len;
> > >
> > >
> > > BTW, what is wrong if we simply drop it before queueing to
> > > sk_receive_queue in TCP? Is it there just for collapse?
> >
> > Because an incoming segment can have payload and FIN.
> >
> > The consumer will need to consume the payload before FIN is considered/consumed,
> > with the complication of MSG_PEEK ...
> >
> > Right after tcp_read_skb() removes the skb from sk_receive_queue,
> > we need to update TCP state, regardless of recv_actor().
> >
> > Maybe like that:
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index ba2bdc81137490bd1748cde95789f8d2bff3ab0f..6e2c11cd921872e406baffc475c9870e147578a1
> > 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -1759,20 +1759,15 @@ int tcp_read_skb(struct sock *sk,
> > skb_read_actor_t recv_actor)
> >                 int used;
> >
> >                 __skb_unlink(skb, &sk->sk_receive_queue);
> > +               seq = TCP_SKB_CB(skb)->end_seq;
> >                 used = recv_actor(sk, skb);
> >                 if (used <= 0) {
> >                         if (!copied)
> >                                 copied = used;
> >                         break;
> >                 }
> > -               seq += used;
> >                 copied += used;
> >
> > -               if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> > -                       consume_skb(skb);
> > -                       ++seq;
> > -                       break;
> > -               }
> >                 consume_skb(skb);
> >                 break;
> >         }
>
> Or even better:
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index ba2bdc81137490bd1748cde95789f8d2bff3ab0f..66c187a2592c042565211565adb3f40a811dfd7d
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1759,21 +1759,15 @@ int tcp_read_skb(struct sock *sk,
> skb_read_actor_t recv_actor)
>                 int used;
>
>                 __skb_unlink(skb, &sk->sk_receive_queue);
> +               seq = TCP_SKB_CB(skb)->end_seq;
>                 used = recv_actor(sk, skb);
> +               consume_skb(skb);
>                 if (used <= 0) {
>                         if (!copied)
>                                 copied = used;
>                         break;
>                 }
> -               seq += used;
>                 copied += used;
> -
> -               if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> -                       consume_skb(skb);
> -                       ++seq;
> -                       break;
> -               }
> -               consume_skb(skb);
>                 break;
>         }
>         WRITE_ONCE(tp->copied_seq, seq);

Note that this code will still not behave properly if we have in
receive queues two skbs of 1000 bytes of payload like:

seq 1:1001
seq 501:1501

tcp_recvmsg() would copy 1000 bytes from the first skb, then 500 bytes
from second skb.
