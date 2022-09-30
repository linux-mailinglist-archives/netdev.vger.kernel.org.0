Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37A35F1502
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 23:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiI3Vg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 17:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiI3Vgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 17:36:50 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C7811E5F3
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:36:49 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-3573ed7cc15so12112707b3.1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=6sn70rRmS7mS4KDy7S1SZgIm6wKjvUIRO8EySG3kFVo=;
        b=KRkoKKDc2aASy0Kr0W6Lqow1Jzjojpypx6v+u+m8r+Y3N13AD9dN+yvouGy1z4qp6G
         UsRP85P1+WPH5Qb2ypRW0z/Tea6IbRcaNfrNX8LnQiANyvaDv2KIOU4x+OtpBlhe8jK6
         0zEnoV86Uw3mgfO/kGPwsPl5gq3/spDQJqYZsCQbGKwSonyntj5CbL1sPhxssiEbAUCn
         OKjid6EODIimfc3pYvaeec6iIYSADeUHs2dxYguNJ20tonQg2b9IgAHQgdc28fd1FHyW
         todtLscWHfU6fh7ndW7KGvMcYXkpJQHj3ZihoEXNp1wJbGtK+iVtoUmzAhUPPeAZG0yu
         aiLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6sn70rRmS7mS4KDy7S1SZgIm6wKjvUIRO8EySG3kFVo=;
        b=qcnCW+xPgXw5ZWdrq9o1HBjIZQzfCDJcBPrGpxp4DGoO+MZ2MaxY+8aGuEn8Wzj7ll
         h0oKmvBiiAI6mvAazp+ZFs4Hc47s3fL4bPr0awHkDQWKLQWamvEPI2EuzOM4EHodfNu4
         ajprYk7rb76IQ+O5t+bInnq7hC5oXBnAXeS4qq5nN1JaapYJnrTumAFEK36HP3zzYzda
         X6Nq50TFRanK+Lv5ky+V9jH3w/XdDL1ahJfh9GsA7RcKOnxTmbh/HHemqkQJRm+Y/rqt
         bwgp2GWQjOgxxoEPUq8dhfbCmjRZ3j92HHX+ME4k2nI7sFvTQyNuAoIGBi12f3uHBI9z
         riZw==
X-Gm-Message-State: ACrzQf2b/h7VmAeKI+Vav3NwGLiITgsM/tSKLMy2o52gXh5KxQPOjEfj
        0oxdUiQilYCyPBg6O5Ki86jZahYeZwU2uZ0cjYXwMw==
X-Google-Smtp-Source: AMsMyM4/ITw1/JkXIdlwvvcrTFLnBlB51eHgyQFig255oghN8iyOHQpSI1a9cSHOfkd/PmJinS8kesVIShxR6He9Z6M=
X-Received: by 2002:a0d:d607:0:b0:348:a519:fbb7 with SMTP id
 y7-20020a0dd607000000b00348a519fbb7mr10480847ywd.255.1664573808687; Fri, 30
 Sep 2022 14:36:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220930014458.1219217-1-eric.dumazet@gmail.com>
 <82d7338e085c156f044ec7bc55c7d78418439963.camel@redhat.com>
 <CANn89iL-ZE48i59A93Y4qfyZCL45uR6rHqZQ84n3TcRK8e_g=g@mail.gmail.com>
 <CANn89iLXrCUjKw55i8Q6Sqwou0RjnuV2uVJLRqDOyMkcCaPvYg@mail.gmail.com>
 <CANn89iK4zFYMQDpnT-QKeRtnMzx+YWi+10KeRr2N0zAZ9nB2-Q@mail.gmail.com> <39ec7558865e4353251b6a863a681897221bfa82.camel@redhat.com>
In-Reply-To: <39ec7558865e4353251b6a863a681897221bfa82.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 30 Sep 2022 14:36:37 -0700
Message-ID: <CANn89iKesUZB=R04Xqp4HL82v3oka6JMDLmZdenv-N_m+sXVvw@mail.gmail.com>
Subject: Re: [PATCH net-next] gro: add support of (hw)gro packets to gro stack
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
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

On Fri, Sep 30, 2022 at 2:02 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Fri, 2022-09-30 at 13:19 -0700, Eric Dumazet wrote:
> > On Fri, Sep 30, 2022 at 1:00 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Fri, Sep 30, 2022 at 12:53 PM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Fri, Sep 30, 2022 at 1:45 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > >
> > > > > On Thu, 2022-09-29 at 18:44 -0700, Eric Dumazet wrote:
> > > > > > From: Coco Li <lixiaoyan@google.com>
> > > > > >
> > > > > > Current GRO stack only supports incoming packets containing
> > > > > > one frame/MSS.
> > > > > >
> > > > > > This patch changes GRO to accept packets that are already GRO.
> > > > > >
> > > > > > HW-GRO (aka RSC for some vendors) is very often limited in presence
> > > > > > of interleaved packets. Linux SW GRO stack can complete the job
> > > > > > and provide larger GRO packets, thus reducing rate of ACK packets
> > > > > > and cpu overhead.
> > > > > >
> > > > > > This also means BIG TCP can be used, even if HW-GRO/RSC was
> > > > > > able to cook ~64 KB GRO packets.
> > > > > >
> > > > > > Co-Developed-by: Eric Dumazet <edumazet@google.com>
> > > > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > > > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > > > > > ---
> > > > > >  net/core/gro.c         | 13 +++++++++----
> > > > > >  net/ipv4/tcp_offload.c |  7 ++++++-
> > > > > >  2 files changed, 15 insertions(+), 5 deletions(-)
> > > > > >
> > > > > > diff --git a/net/core/gro.c b/net/core/gro.c
> > > > > > index b4190eb084672fb4f2be8b437eccb4e8507ff63f..d8e159c4bdf553508cd123bee4f5251908ede9fe 100644
> > > > > > --- a/net/core/gro.c
> > > > > > +++ b/net/core/gro.c
> > > > > > @@ -160,6 +160,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > > > > >       unsigned int gro_max_size;
> > > > > >       unsigned int new_truesize;
> > > > > >       struct sk_buff *lp;
> > > > > > +     int segs;
> > > > > >
> > > > > >       /* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
> > > > > >       gro_max_size = READ_ONCE(p->dev->gro_max_size);
> > > > > > @@ -175,6 +176,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > > > > >                       return -E2BIG;
> > > > > >       }
> > > > > >
> > > > > > +     segs = NAPI_GRO_CB(skb)->count;
> > > > > >       lp = NAPI_GRO_CB(p)->last;
> > > > > >       pinfo = skb_shinfo(lp);
> > > > > >
> > > > > > @@ -265,7 +267,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > > > > >       lp = p;
> > > > > >
> > > > > >  done:
> > > > > > -     NAPI_GRO_CB(p)->count++;
> > > > > > +     NAPI_GRO_CB(p)->count += segs;
> > > > > >       p->data_len += len;
> > > > > >       p->truesize += delta_truesize;
> > > > > >       p->len += len;
> > > > > > @@ -496,8 +498,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
> > > > > >               BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
> > > > > >                                        sizeof(u32))); /* Avoid slow unaligned acc */
> > > > > >               *(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
> > > > > > -             NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
> > > > > > +             NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
> > > > > >               NAPI_GRO_CB(skb)->is_atomic = 1;
> > > > > > +             NAPI_GRO_CB(skb)->count = max_t(u16, 1,
> > > > > > +                                             skb_shinfo(skb)->gso_segs);
> > > > > >
> > > > > >               /* Setup for GRO checksum validation */
> > > > > >               switch (skb->ip_summed) {
> > > > > > @@ -545,10 +549,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
> > > > > >       else
> > > > > >               gro_list->count++;
> > > > > >
> > > > > > -     NAPI_GRO_CB(skb)->count = 1;
> > > > > >       NAPI_GRO_CB(skb)->age = jiffies;
> > > > > >       NAPI_GRO_CB(skb)->last = skb;
> > > > > > -     skb_shinfo(skb)->gso_size = skb_gro_len(skb);
> > > > > > +     if (!skb_is_gso(skb))
> > > > > > +             skb_shinfo(skb)->gso_size = skb_gro_len(skb);
> > > > > >       list_add(&skb->list, &gro_list->list);
> > > > > >       ret = GRO_HELD;
> > > > > >
> > > > > > @@ -660,6 +664,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
> > > > > >
> > > > > >       skb->encapsulation = 0;
> > > > > >       skb_shinfo(skb)->gso_type = 0;
> > > > > > +     skb_shinfo(skb)->gso_size = 0;
> > > > > >       if (unlikely(skb->slow_gro)) {
> > > > > >               skb_orphan(skb);
> > > > > >               skb_ext_reset(skb);
> > > > > > diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> > > > > > index a844a0d38482d916251f3aca4555c75c9770820c..0223bbfe9568064b47bc6227d342a4d25c9edfa7 100644
> > > > > > --- a/net/ipv4/tcp_offload.c
> > > > > > +++ b/net/ipv4/tcp_offload.c
> > > > > > @@ -255,7 +255,12 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
> > > > > >
> > > > > >       mss = skb_shinfo(p)->gso_size;
> > > > > >
> > > > > > -     flush |= (len - 1) >= mss;
> > > > > > +     if (skb_is_gso(skb)) {
> > > > > > +             flush |= (mss != skb_shinfo(skb)->gso_size);
> > > > > > +             flush |= ((skb_gro_len(p) % mss) != 0);
> > > > >
> > > > > If I read correctly, the '(skb_gro_len(p) % mss) != 0' codition can be
> > > > > true only if 'p' was an HW GRO packet (or at least a gso packet before
> > > > > entering the GRO engine), am I correct? In that case 'p' staged into
> > > > > the GRO hash up to the next packet (skb), just to be flushed.
> > > > >
> > > > > Should the above condition be instead:
> > > > >
> > > > >                 flush |= ((skb_gro_len(skb) % mss) != 0);
> > > >
> > > > Yes, probable typo.
> > > >
> > > > > ?
> > > > >
> > > > > And possibly use that condition while initializing
> > > > > NAPI_GRO_CB(skb)->flush in dev_gro_receive() ?
> > > >
> > > > Not sure, this would add an extra test in dev_gro_receive()
> > > >
> > > > It seems better to leave the test here, because the prior condition
> > > > needs to stay here.
> > > >
> > > > if (skb_is_gso(skb)) {
> > > >              flush |= (mss != skb_shinfo(skb)->gso_size);
> > > >
> > >
> > > Oh well, I think Coco missed the fact that the  ((skb_gro_len(skb) % mss) != 0)
> > > condition needs to be put after label out_check_final.
> > >
> > > For example, if MSS==1000, and p has 4 segments, we still want to
> > > aggregate skb into p
> > > if skb payload is not a multiple of MSS.
> > >
> >
> > Relative diff would be:
> >
> > diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> > index 0223bbfe9568064b47bc6227d342a4d25c9edfa7..79996b007bd64635aea27e3fddf291abe10ceca1
> > 100644
> > --- a/net/ipv4/tcp_offload.c
> > +++ b/net/ipv4/tcp_offload.c
> > @@ -255,26 +255,27 @@ struct sk_buff *tcp_gro_receive(struct list_head
> > *head, struct sk_buff *skb)
> >
> >         mss = skb_shinfo(p)->gso_size;
> >
> > -       if (skb_is_gso(skb)) {
> > +       if (unlikely(skb_is_gso(skb)))
> >                 flush |= (mss != skb_shinfo(skb)->gso_size);
> > -               flush |= ((skb_gro_len(p) % mss) != 0);
> > -       } else {
> > +       else
> >                 flush |= (len - 1) >= mss;
> > -       }
> > +
> >         flush |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
> >  #ifdef CONFIG_TLS_DEVICE
> >         flush |= p->decrypted ^ skb->decrypted;
> >  #endif
> >
> >         if (flush || skb_gro_receive(p, skb)) {
> > -               mss = 1;
> > -               goto out_check_final;
> > +               flush = 0;
> > +               goto check_flags;
> >         }
> >
> >         tcp_flag_word(th2) |= flags & (TCP_FLAG_FIN | TCP_FLAG_PSH);
> >
> >  out_check_final:
> > -       flush = len < mss;
> > +       flush = len != NAPI_GRO_CB(skb)->count * mss;
>
> Not sure if it's worthy, perhaps mss can be updated under the
> unlikely(skb_is_gso(skb)) a few lines above:
>
>         mss *= NAPI_GRO_CB(skb)->count;
>
> so that here we can avoid the additional operation for the non gso
> case? - just:
>         flush = len != mss;
>

Yes, but we still need a check even if the above code was not run
(because of earlier goto out_check_final)

I am thinking of:

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index a844a0d38482d916251f3aca4555c75c9770820c..ba8e6cfb3852fc609afe3022efa10f7a06fb4c12
100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -255,7 +255,11 @@ struct sk_buff *tcp_gro_receive(struct list_head
*head, struct sk_buff *skb)

        mss = skb_shinfo(p)->gso_size;

-       flush |= (len - 1) >= mss;
+       if (unlikely(skb_is_gso(skb)))
+               flush |= (mss != skb_shinfo(skb)->gso_size);
+       else
+               flush |= (len - 1) >= mss;
+
        flush |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
 #ifdef CONFIG_TLS_DEVICE
        flush |= p->decrypted ^ skb->decrypted;
@@ -269,7 +273,11 @@ struct sk_buff *tcp_gro_receive(struct list_head
*head, struct sk_buff *skb)
        tcp_flag_word(th2) |= flags & (TCP_FLAG_FIN | TCP_FLAG_PSH);

 out_check_final:
-       flush = len < mss;
+       if (unlikely(skb_is_gso(skb)))
+               flush = len != NAPI_GRO_CB(skb)->count *
skb_shinfo(skb)->gso_size;
+       else
+               flush = len < mss;
+
        flush |= (__force int)(flags & (TCP_FLAG_URG | TCP_FLAG_PSH |
                                        TCP_FLAG_RST | TCP_FLAG_SYN |
                                        TCP_FLAG_FIN));
