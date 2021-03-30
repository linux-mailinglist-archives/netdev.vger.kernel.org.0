Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED8F34DD75
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhC3B1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhC3B1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:27:12 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB46C061762;
        Mon, 29 Mar 2021 18:27:12 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v186so10561270pgv.7;
        Mon, 29 Mar 2021 18:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PWH5oyQoYLVXk+vtAoBXXGUnnkpKl0DDRh5VeQQiIwk=;
        b=U2f0uCv4xLn6JHzdROX1+ZV7ILenEY2gszlvKvH0iWLLXCttyjA+o/ZUVWudjuC0w6
         KQOfvwlUDGJCnji+lWc9jZ49YpHS928USY770zpf056R+0YphoWo9lQcaU2Uys011ims
         1ARuTt8IzAHNsKrlz+RvQfp/eY70O0p76IacH6nvNRD9L6TXf6CdeeQjOKmhwpDfrbHL
         rYigisHdhm/9dqqWxAD/uUa86scWJiXd+lRnWmfmsl6CH327x53GGWMwjFvs/EdkMGVc
         tqcfNU4E7XnJdTmFeNKMuho/jBq8BksOUBhKeogoTWICWX26jAmO+QJqcp0SpB0yn1/h
         GZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PWH5oyQoYLVXk+vtAoBXXGUnnkpKl0DDRh5VeQQiIwk=;
        b=HG3Dovb5JnCaHjJ9ZtRayqeTKNbmuw8YTtR/kzdc/OZxTdZXNTlF0GRejM6rBUfxqo
         bZ7VSCW3Yzxk0pYPh5Zft8uYK0iZJN7+1FrON4PBx06Dt4JoxYjKpYZynzz6Rzi+rzXN
         xskyF3BzgQ8Ydr0T/s/5CNcF+7QhZYry2ddhzdsNLtUPEP/PAe4SLfrlejlnqEOy3CCS
         grY5grb0fJMKOd2INGCbt1sqthEP5udpSzXGPinqKN9Dfd7KSMo+EzSswnp7x7srC7Mr
         cNYQrwyDIt7f17cPnj3cSHIfT4zH5GwQ0+C76kXdDww/0WbWTN3oAi5wwV3l7QJIkbgb
         C0Iw==
X-Gm-Message-State: AOAM533/R6+x1tB4f3IZfhIuTgSHdUn0guE8uBuIGBt80Gii+q0OfCn1
        OZw6VCLbHHbvz8I4ofyL18mVFIXF5TzXIXdtknjG0FAVvBahxA==
X-Google-Smtp-Source: ABdhPJwUj3PkYYRBLpHs9PV9G0Bu0NzSZwLPM1MBbgqNlJ80aY3zIC6HzXC4f4lmJpoBw41t36G2TFMr5OhadF94EHs=
X-Received: by 2002:a63:2ec7:: with SMTP id u190mr1031064pgu.18.1617067631610;
 Mon, 29 Mar 2021 18:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-8-xiyou.wangcong@gmail.com> <60623417fe3b_401fb20857@john-XPS-13-9370.notmuch>
In-Reply-To: <60623417fe3b_401fb20857@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Mar 2021 18:27:00 -0700
Message-ID: <CAM_iQpUsCc18rxn7HBx9L7494Y5arpKAkPHtpUSOqitYevMypA@mail.gmail.com>
Subject: Re: [Patch bpf-next v7 07/13] sock_map: introduce BPF_SK_SKB_VERDICT
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 1:10 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Reusing BPF_SK_SKB_STREAM_VERDICT is possible but its name is
> > confusing and more importantly we still want to distinguish them
> > from user-space. So we can just reuse the stream verdict code but
> > introduce a new type of eBPF program, skb_verdict. Users are not
> > allowed to set stream_verdict and skb_verdict at the same time.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
>
> [...]
>
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index 656eceab73bc..a045812d7c78 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -697,7 +697,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
> >       rcu_assign_sk_user_data(sk, NULL);
> >       if (psock->progs.stream_parser)
> >               sk_psock_stop_strp(sk, psock);
> > -     else if (psock->progs.stream_verdict)
> > +     else if (psock->progs.stream_verdict || psock->progs.skb_verdict)
> >               sk_psock_stop_verdict(sk, psock);
> >       write_unlock_bh(&sk->sk_callback_lock);
> >
> > @@ -1024,6 +1024,8 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
> >       }
> >       skb_set_owner_r(skb, sk);
> >       prog = READ_ONCE(psock->progs.stream_verdict);
> > +     if (!prog)
> > +             prog = READ_ONCE(psock->progs.skb_verdict);
>
> Trying to think through this case. User attachs skb_verdict program
> to map, then updates map with a bunch of TCP sockets. The above
> code will run the skb_verdict program with the TCP socket as far as
> I can tell.
>
> This is OK because there really is no difference, other than by name,
> between a skb_verdict and a stream_verdict program? Do we want something
> to block adding TCP sockets to maps with stream_verdict programs? It
> feels a bit odd in its current state to me.

Yes, it should work too. skb_verdict only extends stream_verdict beyond
TCP, it does not prohibit TCP.

>
> >       if (likely(prog)) {
> >               skb_dst_drop(skb);
> >               skb_bpf_redirect_clear(skb);
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index e564fdeaada1..c46709786a49 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -155,6 +155,8 @@ static void sock_map_del_link(struct sock *sk,
> >                               strp_stop = true;
> >                       if (psock->saved_data_ready && stab->progs.stream_verdict)
> >                               verdict_stop = true;
> > +                     if (psock->saved_data_ready && stab->progs.skb_verdict)
> > +                             verdict_stop = true;
> >                       list_del(&link->list);
> >                       sk_psock_free_link(link);
> >               }
> > @@ -227,7 +229,7 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
> >  static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
> >                        struct sock *sk)
> >  {
> > -     struct bpf_prog *msg_parser, *stream_parser, *stream_verdict;
> > +     struct bpf_prog *msg_parser, *stream_parser, *stream_verdict, *skb_verdict;
> >       struct sk_psock *psock;
> >       int ret;
> >
> > @@ -256,6 +258,15 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
> >               }
> >       }
> >
> > +     skb_verdict = READ_ONCE(progs->skb_verdict);
> > +     if (skb_verdict) {
> > +             skb_verdict = bpf_prog_inc_not_zero(skb_verdict);
> > +             if (IS_ERR(skb_verdict)) {
> > +                     ret = PTR_ERR(skb_verdict);
> > +                     goto out_put_msg_parser;
> > +             }
> > +     }
> > +
> >       psock = sock_map_psock_get_checked(sk);
> >       if (IS_ERR(psock)) {
> >               ret = PTR_ERR(psock);
> > @@ -265,6 +276,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
> >       if (psock) {
> >               if ((msg_parser && READ_ONCE(psock->progs.msg_parser)) ||
> >                   (stream_parser  && READ_ONCE(psock->progs.stream_parser)) ||
> > +                 (skb_verdict && READ_ONCE(psock->progs.skb_verdict)) ||
> >                   (stream_verdict && READ_ONCE(psock->progs.stream_verdict))) {
> >                       sk_psock_put(sk, psock);
> >                       ret = -EBUSY;
>
> Do we need another test here,
>
>    (skb_verdict && READ_ONCE(psock->progs.stream_verdict)
>
> this way we return EBUSY and avoid having both stream_verdict and
> skb_verdict attached on the same map?

Yes, good catch, we do need a check here. And I will see if I can add a small
test case for this too.

Thanks.
