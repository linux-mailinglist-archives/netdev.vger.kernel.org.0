Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AFA33828E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhCLAsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhCLAr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 19:47:56 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D0AC061574;
        Thu, 11 Mar 2021 16:47:56 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id t85so680168pfc.13;
        Thu, 11 Mar 2021 16:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8jF4BBILvpMCqxeTP59FZP35W4rYtEFzKE1e1FVJwEA=;
        b=ssHGks0ADqwCvXQjP/LxHGitf67U31lDxxY6OVn7co47DGTdCbKj4LZz2E0oomTLiF
         SeJoULqQVjQkZ4TscdDbOOcc+zEXEPcXwvxIwym+v087ENl4+rwQi48Hset6HRdjA5Wp
         BLZj6WTpJbN5z0h+bUMd8LBAYdKHEWNZKF4m09qbr+wVW0w2GO/Fsnukv6pTppcS5p4d
         QJUxwduyT2ztUAdGgsaWagV92QBW6TtSbsWrcmAEcs3+R/J6m4Y/fA3S3EYj7hfZ+OME
         RVlGytNCECeN/IfJgnrg9C9B+3bZ8Vv8zn5aBXD+7ml8Jj2OdTlaWcFJCuMn9WUsmv/s
         bwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8jF4BBILvpMCqxeTP59FZP35W4rYtEFzKE1e1FVJwEA=;
        b=Bf0ZuRfKQQp9PS05tm83Rx0AhJm9dQq/vlnoBimrymWQn9i+HlR7VwiQWdrEiNAuUg
         h5V+VbpBUU0hdFjHb7gNj9dNevBIDz2pqBfG2N5jtBT2NV+LWYAkoKrQSyEiW9TB3kMx
         WgTm23YIvIqYPFiaE4KB4wlQbHMeIDSkyluQ8fg153Qq3rWoUh1d1ltuv3hxUNiaIzre
         I6kD5fRJzztdb/qir2LGja3F2ga+JHNH2gPxGtgzTnEgE6fdJR9McId1Wo6ZBNTM6L2R
         F9D68ago75PG2DJb0wuLDCaV+3opy4cF591zLsWSHAdKnzOsQfBpQu2pKWjhBvOR2HCq
         jzfA==
X-Gm-Message-State: AOAM531axGH86V7ZO9jlXxkHfB1+f/sOea2hVGpo+H1IEH9F/BG/yCZF
        vyIZ3fz/tfbSz6yn06z1hwWtas/k0JGfydqv9u0=
X-Google-Smtp-Source: ABdhPJx+255rr1f+VGyB5pAwOi2ZDUtIn+p/75z6I5TgQXklmsly5ifzjGpjmg0PbJB/hO5cte+r5cfVT6hG406OgAc=
X-Received: by 2002:a63:c74b:: with SMTP id v11mr9243470pgg.336.1615510076146;
 Thu, 11 Mar 2021 16:47:56 -0800 (PST)
MIME-Version: 1.0
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
 <20210310053222.41371-4-xiyou.wangcong@gmail.com> <87zgz93oiv.fsf@cloudflare.com>
In-Reply-To: <87zgz93oiv.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 11 Mar 2021 16:47:45 -0800
Message-ID: <CAM_iQpVT5=yptx-Q-e5hKvyOJ7+gi1uRLX_KXzcczSrDSA_6Dw@mail.gmail.com>
Subject: Re: [Patch bpf-next v4 03/11] skmsg: introduce skb_send_sock() for sock_map
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 3:42 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Mar 10, 2021 at 06:32 AM CET, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > We only have skb_send_sock_locked() which requires callers
> > to use lock_sock(). Introduce a variant skb_send_sock()
> > which locks on its own, callers do not need to lock it
> > any more. This will save us from adding a ->sendmsg_locked
> > for each protocol.
> >
> > To reuse the code, pass function pointers to __skb_send_sock()
> > and build skb_send_sock() and skb_send_sock_locked() on top.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/linux/skbuff.h |  1 +
> >  net/core/skbuff.c      | 52 ++++++++++++++++++++++++++++++++++++------
> >  2 files changed, 46 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 0503c917d773..2fc8c3657c53 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -3626,6 +3626,7 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
> >                   unsigned int flags);
> >  int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
> >                        int len);
> > +int skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset, int len);
> >  void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to);
> >  unsigned int skb_zerocopy_headlen(const struct sk_buff *from);
> >  int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 545a472273a5..396586bd6ae3 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -2500,9 +2500,12 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
> >  }
> >  EXPORT_SYMBOL_GPL(skb_splice_bits);
> >
> > -/* Send skb data on a socket. Socket must be locked. */
> > -int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
> > -                      int len)
> > +typedef int (*sendmsg_func)(struct sock *sk, struct msghdr *msg,
> > +                         struct kvec *vec, size_t num, size_t size);
> > +typedef int (*sendpage_func)(struct sock *sk, struct page *page, int offset,
> > +                        size_t size, int flags);
> > +static int __skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset,
> > +                        int len, sendmsg_func sendmsg, sendpage_func sendpage)
> >  {
> >       unsigned int orig_len = len;
> >       struct sk_buff *head = skb;
> > @@ -2522,7 +2525,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
> >               memset(&msg, 0, sizeof(msg));
> >               msg.msg_flags = MSG_DONTWAIT;
> >
> > -             ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
> > +             ret = sendmsg(sk, &msg, &kv, 1, slen);
>
>
> Maybe use INDIRECT_CALLABLE_DECLARE() and INDIRECT_CALL_2() since there
> are just two possibilities? Same for sendpage below.

Yeah. Actually I wanted to call __skb_send_sock() in espintcp for
tcp_sendmsg(), but it actually could be TCP over IPv6 too, so I decided
not to  touch it.

Thanks.
