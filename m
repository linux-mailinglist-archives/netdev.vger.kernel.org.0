Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FF93E06AE
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 19:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbhHDRU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 13:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhHDRUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 13:20:54 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B0CC061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 10:20:42 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id y18so3686121oiv.3
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 10:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SsLjeKiLuliSZOE+wUaPOjaCl3gVgPx+PNBKHSFfAc0=;
        b=hVC8CZtsjkFOsvIinLJF30LOuTeXy5igNSPk7hFv9p92XBKklcEs4hRIgS5etqqoyk
         Ex95PKSsiEj/BIIpSYMCXBpJJqiH/5bSpUtu467tZBV8HYK5j+gEiLPcsWBFOX+A76Bz
         JQ70k6t5f/6C/3n/OaC5HAKi3bKsajwSq0Tl1GgURhePM/VohVmGQ8oqkiXqAisNMjXn
         eeHuS+zUQmQd6Fd1jtrlFXGp45uGhY89q+X9Iye1mtthZzGL2CodxGIT+vCYy9ESHOca
         nzkl3F/QNRx10oWyG57E0AG0qj+C3s6cveoKrfI/8lgHfHl936IVjVr+tKTpkIlR6IYn
         KIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SsLjeKiLuliSZOE+wUaPOjaCl3gVgPx+PNBKHSFfAc0=;
        b=L0XVuva50ZsJKa7C2mqhZIWb8nOP5Io/WdtPldBAoOjVLWsyK6wvEkeZIHxYM/5+md
         z55y4ute1LN6rae7bGAqd62FFsXJW7q0uzh/febQcc6lCgI1CdvV/FYgJC/RFYeE+uKc
         6c0omLNHxH4iVHNQU8Ew+0mkFsj11rltpuHBxx4BxSmvkpD9A2t+AM1In594bQv4nIA8
         SKJm9po1qgkfe9HI7RfPCy1h8LOLVYnHPNVtskFkN4adD6eF1yY9QdYAZROz9EmpG9dl
         XQh83J/XMK3RhT7eXiE+LfP/rESpDRMOnyT9Zm0kXIAybC9Bd0w/4q2KWoTaXDYg+p3l
         ZlAA==
X-Gm-Message-State: AOAM530qdNiLJKnncLU7OpYB1neeGwGDPdrJ1upXA9NzQgTa7o0WA1v1
        eSQPGEfvDBJY20+mqi2wUK2sYPVFlZ8rbaQcDNvVwg==
X-Google-Smtp-Source: ABdhPJydHT8T09LV2c5tCC/zHhUe+u5O3+JdHKYpJP9RhhU+4ivVPQngJmG/KHsv0HSdDX7wN70cCyRdKW8apbASMIk=
X-Received: by 2002:a05:6808:d53:: with SMTP id w19mr447537oik.48.1628097641355;
 Wed, 04 Aug 2021 10:20:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210802211912.116329-1-jiang.wang@bytedance.com>
 <20210802211912.116329-3-jiang.wang@bytedance.com> <87zgtxcfig.fsf@cloudflare.com>
In-Reply-To: <87zgtxcfig.fsf@cloudflare.com>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Wed, 4 Aug 2021 10:20:30 -0700
Message-ID: <CAP_N_Z_c5CidNPdnaf=M=Vpm9-rJvODi+-5rZ0DNO+mwOpKJpw@mail.gmail.com>
Subject: Re: Re: [PATCH bpf-next v3 2/5] af_unix: add unix_stream_proto for sockmap
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?UTF-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 4, 2021 at 9:59 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Mon, Aug 02, 2021 at 11:19 PM CEST, Jiang Wang wrote:
>
> [...]
>
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index ae5fa4338..42f50ea7a 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -517,9 +517,15 @@ static bool sk_is_tcp(const struct sock *sk)
> >              sk->sk_protocol == IPPROTO_TCP;
> >  }
> >
> > +static bool sk_is_unix_stream(const struct sock *sk)
> > +{
> > +     return sk->sk_type == SOCK_STREAM &&
> > +            sk->sk_protocol == PF_UNIX;
> > +}
> > +
> >  static bool sock_map_redirect_allowed(const struct sock *sk)
> >  {
> > -     if (sk_is_tcp(sk))
> > +     if (sk_is_tcp(sk) || sk_is_unix_stream(sk))
> >               return sk->sk_state != TCP_LISTEN;
> >       else
> >               return sk->sk_state == TCP_ESTABLISHED;
>
> Let me provide some context.
>
> The reason why we check != TCP_LISTEN for TCP sockets is that we want to
> allow redirect redirect to sockets that are about to transition from
> TCP_SYN_RECV to TCP_ESTABLISHED, in addition to sockets already in
> TCP_ESTABLISHED state.
>
> That's because BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB callback happens when
> socket is still in TCP_SYN_RECV state. With BPF sockops program, we can
> insert such socket into a sockmap. Hence, there is a short window of
> opportunity when we could redirect to a socket in TCP_SYN_RECV.
>
> UNIX sockets can be only in TCP_{CLOSE,LISTEN,ESTABLISHED} state,
> AFAIK. So it is sufficient to rely on the default == TCP_ESTABLISHED
> check.
>
Got it. Thanks for the explanation. I will change unix sockets to only
check == TCP_ESTABLISHED condition.

> > diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> > index 0ae3fc4c8..9c1711c67 100644
> > --- a/net/unix/af_unix.c
> > +++ b/net/unix/af_unix.c
> > @@ -791,17 +791,35 @@ static void unix_close(struct sock *sk, long timeout)
> >        */
> >  }
> >
> > -struct proto unix_proto = {
> > -     .name                   = "UNIX",
> > +static void unix_unhash(struct sock *sk)
> > +{
> > +     /* Nothing to do here, unix socket does not need a ->unhash().
> > +      * This is merely for sockmap.
> > +      */
> > +}
> > +
> > +struct proto unix_dgram_proto = {
> > +     .name                   = "UNIX-DGRAM",
> > +     .owner                  = THIS_MODULE,
> > +     .obj_size               = sizeof(struct unix_sock),
> > +     .close                  = unix_close,
> > +#ifdef CONFIG_BPF_SYSCALL
> > +     .psock_update_sk_prot   = unix_dgram_bpf_update_proto,
> > +#endif
> > +};
> > +
> > +struct proto unix_stream_proto = {
> > +     .name                   = "UNIX-STREAM",
> >       .owner                  = THIS_MODULE,
> >       .obj_size               = sizeof(struct unix_sock),
> >       .close                  = unix_close,
> > +     .unhash                 = unix_unhash,
> >  #ifdef CONFIG_BPF_SYSCALL
> > -     .psock_update_sk_prot   = unix_bpf_update_proto,
> > +     .psock_update_sk_prot   = unix_stream_bpf_update_proto,
> >  #endif
> >  };
> >
> > -static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
> > +static struct sock *unix_create1(struct net *net, struct socket *sock, int kern, int type)
> >  {
> >       struct sock *sk = NULL;
> >       struct unix_sock *u;
> > @@ -810,7 +828,11 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
> >       if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files())
> >               goto out;
> >
> > -     sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_proto, kern);
> > +     if (type == SOCK_STREAM)
> > +             sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_stream_proto, kern);
> > +     else /*dgram and  seqpacket */
> > +             sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_dgram_proto, kern);
> > +
> >       if (!sk)
> >               goto out;
> >
> > @@ -872,7 +894,7 @@ static int unix_create(struct net *net, struct socket *sock, int protocol,
> >               return -ESOCKTNOSUPPORT;
> >       }
> >
> > -     return unix_create1(net, sock, kern) ? 0 : -ENOMEM;
> > +     return unix_create1(net, sock, kern, sock->type) ? 0 : -ENOMEM;
> >  }
> >
> >  static int unix_release(struct socket *sock)
> > @@ -1286,7 +1308,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
> >       err = -ENOMEM;
> >
> >       /* create new sock for complete connection */
> > -     newsk = unix_create1(sock_net(sk), NULL, 0);
> > +     newsk = unix_create1(sock_net(sk), NULL, 0, sock->type);
> >       if (newsk == NULL)
> >               goto out;
> >
> > @@ -2214,7 +2236,7 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
> >       struct sock *sk = sock->sk;
> >
> >  #ifdef CONFIG_BPF_SYSCALL
> > -     if (sk->sk_prot != &unix_proto)
> > +     if (sk->sk_prot != &unix_dgram_proto)
> >               return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
> >                                           flags & ~MSG_DONTWAIT, NULL);
> >  #endif
>
>
> KASAN might be unhappy about access to sk->sk_prot not annotated with
> READ_ONCE. In unix_bpf we have WRITE_ONCE(sk->sk_prot, ...) [1]
>
Got it.  Will check and add READ_ONCE if necessary.

> [...]
>
> [1] https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#why-kernel-code-should-use-read_once-and-write_once-for-shared-memory-accesses
