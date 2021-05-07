Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A3D375E29
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 03:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhEGBBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 21:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhEGBBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 21:01:40 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C64C061574;
        Thu,  6 May 2021 18:00:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id l10-20020a17090a850ab0290155b06f6267so4404143pjn.5;
        Thu, 06 May 2021 18:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WsWTUkLXFNBBxzttpPmRLuZU49HD6DSnqNuGJ7orDEU=;
        b=aRrhNdOTINO0NHJW6bMnkU3RdEm3k4kM6PirdIdv0xWS1enAC1/i9Qq5GH+WAtaRIO
         InLBvGrqRBHagUtsR1f/fP+x6Zp2W1Om9A+K9BnC0q9bx8MNjHVU4rPNNIMqcZCW4R1F
         LdZRDA73gfdecLQ+NIJbl1hr/NgMtZ/ULv0X2nkvZ+K6a1BDEOQKMzXKvxptIuNJUk+W
         J5gbWV2dlImad5W6OIeddlUkU0gj81hOXGmWXu3Ldcdj0KeVesJXP0vKvh/+h1p/JDdD
         FxeKBtjcXU1rwQrnclNg05xdnf0Q+SMvcbNLjZVC1LPmy7qczSd3aXS85ADXFNeTcw7B
         lllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WsWTUkLXFNBBxzttpPmRLuZU49HD6DSnqNuGJ7orDEU=;
        b=BE5SoFOvrP2VtAxifB9wVgYTW6opxHS78I/TlAmsKKEKK3EkddgRPDHwvEiNjDdNbi
         hvtjRUwaARpD8vDZHZDNdh+cdwPx4Hasdq4Dzm9g5VDiDwleYdE1+ve3tGsI4+EOhbpR
         Bk9ToJrn1wnSd3wUusSd4xpkqzRRNfDkKn9aW3jI4TT+l5BY+CnDFa9CkUY/lS3vW5eQ
         6NjGSsP+rAt87tuQZHdt7PwfQ1uT8jqcHvKSxFeFKSVn+gQoe+v0ZPNfEgrr1ZmEwHLf
         jqReoF3AB8ElgavrPo87wQcLzVJ7h7s0dIVFN0CHxwCcuRBa0/WdygA5lCoviElCGPPl
         lAbg==
X-Gm-Message-State: AOAM533iI8SyU+q3iOoN600ebEbJ+9wyoqOpYDBZIzobar5vMPPOy4WK
        gvmN/bCSY3Om5GrlPtk47jWcnWcciDsPZYglLD4=
X-Google-Smtp-Source: ABdhPJx1z0wWxjWosr1KX7slEbCl3tqgXIeJlJVQm0l7li4OC5hXkqVw2F1SAgyh2kNSFto0fWbSXmGDK/+qX5KpJNo=
X-Received: by 2002:a17:902:10b:b029:ed:2b3e:beb4 with SMTP id
 11-20020a170902010bb02900ed2b3ebeb4mr7757311plb.64.1620349239552; Thu, 06 May
 2021 18:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
 <20210426025001.7899-3-xiyou.wangcong@gmail.com> <87pmy5umqp.fsf@cloudflare.com>
In-Reply-To: <87pmy5umqp.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 6 May 2021 18:00:28 -0700
Message-ID: <CAM_iQpVS9BL_NPPX3L=8ka9nn1WtyYb9VMP0MU6gKi70WvdPbQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 02/10] af_unix: implement ->read_sock() for sockmap
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiang Wang <jiang.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 5, 2021 at 10:14 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Mon, Apr 26, 2021 at 04:49 AM CEST, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Implement ->read_sock() for AF_UNIX datagram socket, it is
> > pretty much similar to udp_read_sock().
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/unix/af_unix.c | 38 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 38 insertions(+)
> >
> > diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> > index 5a31307ceb76..f4dc22db371d 100644
> > --- a/net/unix/af_unix.c
> > +++ b/net/unix/af_unix.c
> > @@ -661,6 +661,8 @@ static ssize_t unix_stream_splice_read(struct socket *,  loff_t *ppos,
> >                                      unsigned int flags);
> >  static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
> >  static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
> > +static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
> > +                       sk_read_actor_t recv_actor);
> >  static int unix_dgram_connect(struct socket *, struct sockaddr *,
> >                             int, int);
> >  static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
> > @@ -738,6 +740,7 @@ static const struct proto_ops unix_dgram_ops = {
> >       .listen =       sock_no_listen,
> >       .shutdown =     unix_shutdown,
> >       .sendmsg =      unix_dgram_sendmsg,
> > +     .read_sock =    unix_read_sock,
> >       .recvmsg =      unix_dgram_recvmsg,
> >       .mmap =         sock_no_mmap,
> >       .sendpage =     sock_no_sendpage,
> > @@ -2183,6 +2186,41 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> >       return err;
> >  }
> >
> > +static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
> > +                       sk_read_actor_t recv_actor)
> > +{
> > +     int copied = 0;
> > +
> > +     while (1) {
> > +             struct unix_sock *u = unix_sk(sk);
> > +             struct sk_buff *skb;
> > +             int used, err;
> > +
> > +             mutex_lock(&u->iolock);
> > +             skb = skb_recv_datagram(sk, 0, 1, &err);
> > +             if (!skb) {
> > +                     mutex_unlock(&u->iolock);
> > +                     return err;
> > +             }
> > +
> > +             used = recv_actor(desc, skb, 0, skb->len);
> > +             if (used <= 0) {
> > +                     if (!copied)
> > +                             copied = used;
> > +                     mutex_unlock(&u->iolock);
> > +                     break;
> > +             } else if (used <= skb->len) {
> > +                     copied += used;
> > +             }
> > +             mutex_unlock(&u->iolock);
>
> Do we need hold the mutex for recv_actor to process the skb?

Hm, it does look like we can just release it after dequeuing the
skb. Let me double check.

Thanks.
