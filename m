Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D8A37740D
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 22:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhEHUo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 16:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhEHUo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 16:44:26 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED1FC061574;
        Sat,  8 May 2021 13:43:24 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id lj11-20020a17090b344bb029015bc3073608so8111334pjb.3;
        Sat, 08 May 2021 13:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/10WpTpOUTNoDlN8z3Lt320qLUXcqwLi95mmkTJjCSs=;
        b=SjJffrdg4RQUgYsava/O4r3c71drPc8SILKQhX+asUW2jdWvi+qHkKazP/8tEfFPaV
         jhPMzTB82Rl0D4jm40I5352skb5UDEVGFcjYc0OfbAmoPIFtB4g4b3CK62/IMpTWzBxw
         XyfLM1EEUvB17DQc+Fn8yxc2RG+x1sOmRMWQuxAIu76yloecIuNq/BY66+VEn5/xpi7Q
         g4bZepyFytFUA7Evo5ojYqBA2IlKfEJvA97RRngxz1h5ujXwQ1Qmuu9FtuWymrNmUObI
         Vr6MpIyZtfp4pQk7ZIqNDl34NanRO/1XfZz9Nfic7/dLVelwJkecfrW3zsegT0pR5Dxn
         EOwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/10WpTpOUTNoDlN8z3Lt320qLUXcqwLi95mmkTJjCSs=;
        b=sHbZ1GUSQkjk3T5rT/SIdAi4vpQItJbjReXtdeVWLR/2CCojltbuJiVaSbdo7LEgwr
         Re/V2OUIp1YoXNLHzB41+N/+Fq/1hjepCvF6t5oydgGFt93FYAJuo6ddJkTsW774F11r
         SNrUoGCW4AePfSKrTK3TInPMJ4A5jkq+Q24Pc03dbLE1uR2oTQF1FTUUmCc4rCUDYHKh
         odR3+t5J4ZlssIxJSqLhadhFGRCcds6cpmNAMtAaaDt4C+VQXWfG2SvNwIDTjn3ejc0U
         lk/vfscDs+IHe//ImDKP7gp44k+MQv1/0m1aaLIFn6bX86YyxU8HBihEWk6U21V5RreS
         p2KQ==
X-Gm-Message-State: AOAM531UTOqd4a8h0uTjjTppG/0D7854bDimdK6DfHi8wYx9PrmEpLnj
        +J/SMsoTJvdzVCQGEfOee6M/KJfUPWcbAUxEjYg=
X-Google-Smtp-Source: ABdhPJwh8/l411TZAz5HchCfEjT+Tg7AjFln4VSGWS+kmrX7yFAQ08wKz7zt8cSUFXNHdMmAbndllxdkMGqZKCTZlsk=
X-Received: by 2002:a17:902:56d:b029:ee:9129:e5e8 with SMTP id
 100-20020a170902056db02900ee9129e5e8mr16416873plf.70.1620506604359; Sat, 08
 May 2021 13:43:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
 <20210426025001.7899-6-xiyou.wangcong@gmail.com> <87lf8qvfi0.fsf@cloudflare.com>
In-Reply-To: <87lf8qvfi0.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 8 May 2021 13:43:13 -0700
Message-ID: <CAM_iQpWQMj-pAc3rqAZDv9GpnhOqB9vJf1wRxeNnDT9GxrnKmQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 05/10] af_unix: implement unix_dgram_bpf_recvmsg()
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

On Fri, May 7, 2021 at 6:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Mon, Apr 26, 2021 at 04:49 AM CEST, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > We have to implement unix_dgram_bpf_recvmsg() to replace the
> > original ->recvmsg() to retrieve skmsg from ingress_msg.
> >
> > AF_UNIX is again special here because the lack of
> > sk_prot->recvmsg(). I simply add a special case inside
> > unix_dgram_recvmsg() to call sk->sk_prot->recvmsg() directly.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/net/af_unix.h |  3 +++
> >  net/unix/af_unix.c    | 21 ++++++++++++++++---
> >  net/unix/unix_bpf.c   | 49 +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 70 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/net/af_unix.h b/include/net/af_unix.h
> > index cca645846af1..e524c82794c9 100644
> > --- a/include/net/af_unix.h
> > +++ b/include/net/af_unix.h
> > @@ -82,6 +82,9 @@ static inline struct unix_sock *unix_sk(const struct sock *sk)
> >  long unix_inq_len(struct sock *sk);
> >  long unix_outq_len(struct sock *sk);
> >
> > +int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
> > +                      int nonblock, int flags, int *addr_len);
> > +
> >  #ifdef CONFIG_SYSCTL
> >  int unix_sysctl_register(struct net *net);
> >  void unix_sysctl_unregister(struct net *net);
> > diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> > index c4afc5fbe137..08458fa9f48b 100644
> > --- a/net/unix/af_unix.c
> > +++ b/net/unix/af_unix.c
> > @@ -2088,11 +2088,11 @@ static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
> >       }
> >  }
> >
> > -static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> > -                           size_t size, int flags)
> > +int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
> > +                      int nonblock, int flags, int *addr_len)
> >  {
> >       struct scm_cookie scm;
> > -     struct sock *sk = sock->sk;
> > +     struct socket *sock = sk->sk_socket;
> >       struct unix_sock *u = unix_sk(sk);
> >       struct sk_buff *skb, *last;
> >       long timeo;
> > @@ -2195,6 +2195,21 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> >       return err;
> >  }
> >
> > +static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
> > +                           int flags)
> > +{
> > +     struct sock *sk = sock->sk;
> > +     int addr_len = 0;
> > +
> > +#ifdef CONFIG_BPF_SYSCALL
> > +     if (sk->sk_prot != &unix_proto)
> > +             return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
> > +                                         flags & ~MSG_DONTWAIT, &addr_len);
> > +#endif
> > +     return __unix_dgram_recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
> > +                                 flags, &addr_len);
> > +}
> > +
>
> Nit: We can just pass NULL instead of &addr_len here it seems.

Yeah, we can actually remove this parameter for __unix_dgram_recvmsg().
Only unix_dgram_bpf_recvmsg() needs it as it is enforced by sk_prot.

Thanks.
