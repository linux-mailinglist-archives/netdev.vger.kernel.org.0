Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6165454B5
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 21:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiFITMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 15:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbiFITMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 15:12:38 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7713A2DC203;
        Thu,  9 Jun 2022 12:12:37 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id f12so19466244ilj.1;
        Thu, 09 Jun 2022 12:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=WshwSktjr4ExHmT7Y051X+8piGlXZxU0WO6vy/mEFlM=;
        b=f8qg9Zif98yq6z2+YHbzSPJu+zUQ/biZnqzhbm92xQd9DChcTw548jyomskbv0ICCM
         Ic5ab0/1sTIlKl823PbPDbQwuoznTjG3NnUfeuho7hu3z/4FqHpskiU457BqYQ/9yGdE
         +14e8JBJfvS0P6wMchrSBDpSqMdEdDnOjdVIA6enSJ+iVbbtlCQhoBvvCzbLS4oxDaeJ
         OL8JJL606Wf1zuYvBTUXMzcoIVdaNU8LC/EQ7oNZhojkvhELKqX3fnIV32DT/VIxiA77
         2wVUVQV/Vk2WAkO4ivAW+b6GVB596HVLOE1+ZqIlauKUydBKGntWEkedPvqMfcUZyzGJ
         Tpyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=WshwSktjr4ExHmT7Y051X+8piGlXZxU0WO6vy/mEFlM=;
        b=X2sjQiGsGwNrL2g4CZ3Fb4ilK2WLWceY4aft7Fo022eUa3De+jQL8r2FL8wi/e6v+T
         tWgcGbj4U4Jr31akhaujWrFQ7Jup2IaEKUQhRnYtI99GSVH911ZX3sqQdM735rjL4X9N
         6va+FgZs3gZ6PGkzxYFXRL7QZYVdO3E6fPbGwMZ6WeNf6rHe+el7dMrUP0lHuKbGROU+
         EIHXiS5D5JtpnX0sQhvicEtmaD8bgkqR8QXXKV2b7Mx72iw+KQ1K6FLzZP7yE4jQx7Yc
         tr8t+XVBV23dlhUP/+3rx226bg0fLdilMDMOiKwz31QSy6xdNR850J450D34dChKiQOX
         LM4A==
X-Gm-Message-State: AOAM531xTj7fp3P+/+QZxev7p2fTID43okSU/TemWnqqkYsW9irKyg26
        KBwQdbUFkPtpyeDOWPL2JgM=
X-Google-Smtp-Source: ABdhPJxEZ2e7Q8qYK50DUYfa9umQkfi3jO06g8LQ5g5XTQQiQZ5KxgKWtW+MpQrL4tOzUQSeKuTyJA==
X-Received: by 2002:a05:6e02:b23:b0:2d1:b62a:d9ae with SMTP id e3-20020a056e020b2300b002d1b62ad9aemr21863319ilu.291.1654801956857;
        Thu, 09 Jun 2022 12:12:36 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id k23-20020a5e9317000000b006696754eef5sm4566283iom.13.2022.06.09.12.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 12:12:36 -0700 (PDT)
Date:   Thu, 09 Jun 2022 12:12:28 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <62a2461c2688b_bb7f820876@john.notmuch>
In-Reply-To: <CAM_iQpWN-PidFerX+2jdKNaNpx4wTVRbp+gGDow=1qKx12i4qA@mail.gmail.com>
References: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
 <20220602012105.58853-2-xiyou.wangcong@gmail.com>
 <62a20ceaba3d4_b28ac2082c@john.notmuch>
 <CAM_iQpWN-PidFerX+2jdKNaNpx4wTVRbp+gGDow=1qKx12i4qA@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 1/4] tcp: introduce tcp_read_skb()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Thu, Jun 9, 2022 at 8:08 AM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > This patch inroduces tcp_read_skb() based on tcp_read_sock(),
> > > a preparation for the next patch which actually introduces
> > > a new sock ops.
> > >
> > > TCP is special here, because it has tcp_read_sock() which is
> > > mainly used by splice(). tcp_read_sock() supports partial read
> > > and arbitrary offset, neither of them is needed for sockmap.
> > >
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  include/net/tcp.h |  2 ++
> > >  net/ipv4/tcp.c    | 47 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 49 insertions(+)
> > >
> > > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > > index 1e99f5c61f84..878544d0f8f9 100644
> > > --- a/include/net/tcp.h
> > > +++ b/include/net/tcp.h
> > > @@ -669,6 +669,8 @@ void tcp_get_info(struct sock *, struct tcp_info *);
> > >  /* Read 'sendfile()'-style from a TCP socket */
> > >  int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > >                 sk_read_actor_t recv_actor);
> > > +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> > > +              sk_read_actor_t recv_actor);
> > >
> > >  void tcp_initialize_rcv_mss(struct sock *sk);
> > >
> > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > index 9984d23a7f3e..a18e9ababf54 100644
> > > --- a/net/ipv4/tcp.c
> > > +++ b/net/ipv4/tcp.c
> > > @@ -1709,6 +1709,53 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > >  }
> > >  EXPORT_SYMBOL(tcp_read_sock);
> > >
> > > +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> > > +              sk_read_actor_t recv_actor)
> > > +{
> > > +     struct tcp_sock *tp = tcp_sk(sk);
> > > +     u32 seq = tp->copied_seq;
> > > +     struct sk_buff *skb;
> > > +     int copied = 0;
> > > +     u32 offset;
> > > +
> > > +     if (sk->sk_state == TCP_LISTEN)
> > > +             return -ENOTCONN;
> > > +
> > > +     while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
> > > +             int used;
> > > +
> > > +             __skb_unlink(skb, &sk->sk_receive_queue);
> > > +             used = recv_actor(desc, skb, 0, skb->len);
> > > +             if (used <= 0) {
> > > +                     if (!copied)
> > > +                             copied = used;
> > > +                     break;
> > > +             }
> > > +             seq += used;
> > > +             copied += used;
> > > +
> > > +             if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> > > +                     kfree_skb(skb);
> >
> > Hi Cong, can you elaborate here from v2 comment.
> >
> > "Hm, it is tricky here, we use the skb refcount after this patchset, so
> > it could be a real drop from another kfree_skb() in net/core/skmsg.c
> > which initiates the drop."
> 
> Sure.
> 
> This is the source code of consume_skb():
> 
>  911 void consume_skb(struct sk_buff *skb)
>  912 {
>  913         if (!skb_unref(skb))
>  914                 return;
>  915
>  916         trace_consume_skb(skb);
>  917         __kfree_skb(skb);
>  918 }
> 
> and this is kfree_skb (or kfree_skb_reason()):
> 
>  770 void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
>  771 {
>  772         if (!skb_unref(skb))
>  773                 return;
>  774
>  775         DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >=
> SKB_DROP_REASON_MAX);
>  776
>  777         trace_kfree_skb(skb, __builtin_return_address(0), reason);
>  778         __kfree_skb(skb);
>  779 }
> 
> So, both do refcnt before tracing, very clearly.
> 
> Now, let's do a simple case:
> 
> tcp_read_skb():
>  -> tcp_recv_skb() // Let's assume skb refcnt == 1 here
>   -> recv_actor()
>    -> skb_get() // refcnt == 2
>    -> kfree_skb() // Let's assume users drop it intentionally
>  ->kfree_skb() // refcnt == 0 here, if we had consume_skb() it would
> not be counted as a drop

OK great thanks for that it matches what I was thinking as well.

> 
> Of course you can give another example where consume_skb() is
> correct, but the point here is it is very tricky when refcnt, I even doubt
> we can do anything here, maybe moving trace before refcnt.

Considering, the other case where we do kfree_skb when consume_skb()
is correct. We have logic in the Cilium tracing tools (tetragon) to
trace kfree_skb's and count them. So in the good case here
we end up tripping that logic even though its expected.

The question is which is better noisy kfree_skb even when
expected or missing kfree_skb on the drops. I'm leaning
to consume_skb() is safer instead of noisy kfree_skb().

> 
> >
> > The tcp_read_sock() hook is using tcp_eat_recv_skb(). Are we going
> > to kick tracing infra even on good cases with kfree_skb()? In
> > sk_psock_verdict_recv() we do an skb_clone() there.
> 
> I don't get your point here, are you suggesting we should sacrifice
> performance just to make the drop tracing more accurate??

No lets not sacrifice the performance. I'm suggesting I would
rather go with skb_consume() and miss some kfree_skb() than
the other way around and have extra kfree_skb() that will
trip monitoring. Does the question make sense? I guess we
have to pick one.

> 
> Thanks.


