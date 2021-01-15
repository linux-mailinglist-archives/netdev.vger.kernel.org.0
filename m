Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EB72F712D
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 04:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbhAODvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 22:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbhAODvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 22:51:41 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E95CC061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 19:51:01 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id 2so5190708qtt.10
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 19:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gd5arU55eFy4mR+ko12IByJgXdFVu7Y6hozWm/XStQA=;
        b=wVdRM4+k+0k37tocvVeYVw0rvL/m8dD9wfYoPFgfDbFr9hFlA2a/xCFwzvPimDBR2d
         2xk37hX+E3nmKVmbSesGeoejxCmrXj1v7iFYmp2u8LAH8ZvDqAKCr70NAMjegXH5Gvbb
         Dn3CiBviXEk2o/l28VvXBJqJUKBVER3PXbXOeH2RSlqgyh1EZ8SC0iAYYlhHXmV+op3j
         MSDJ/xSJ6Iiir3a7hqLvcH+MOlRxCP6GGDSqqysLe/8O+we0f7FavNehNrdZqf9SiCEg
         fYdym4INdW+olCoth0R6a4rnfh8EKyjHh9WruzpAvagrxdtqvZroqy0zohBwEaaTbGSR
         CBHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gd5arU55eFy4mR+ko12IByJgXdFVu7Y6hozWm/XStQA=;
        b=U9CXsVMgc3SfKK6YL2Cqopg7zTgb49E3U79TxkCp4EL+6qin0IN1eMXh72cnjaQacV
         m1wdDbeAHgpxJElTbFjYgxaLcLH3C6P+Ma9YBx5+qOaX+lZVo02zPReR72tFRX0frP4y
         0ANf1HdpnqBhO+LuZLVRFreLlhE9rmYz10Nq192Cg7YR0mBD3cWzuXjuJlFdrBZgxp7w
         PCiDfxRBIpLkzsN/4Rie6edGdmdrHok8HxD/mG3TZav6G9xKSwJCq8qsKKGTaxu3ftbZ
         XozHu1MEutyRkNgiv2Nfctlnv+TZSrdpFAUsT5LFzkIxVpzauZmK3tyhi7whwWFIhBwM
         RqAA==
X-Gm-Message-State: AOAM530EJehvIlBM7gkpmuUO6rkcI6kMk9+JH1S1S/IezhBh8el13VM7
        lJo8A0yhTa91MZnToLUg7fYZzD+LzSsUJ7S1e8O57Q==
X-Google-Smtp-Source: ABdhPJzM4/XU1xf1l/WUnhdrcHPHF9wwxMV8ivphpQ5EQxIHp0yBorKyzf644GmJhI55DZqrC3Vq5QcW8xaLOzQCGe8=
X-Received: by 2002:ac8:41cf:: with SMTP id o15mr10158214qtm.98.1610682660402;
 Thu, 14 Jan 2021 19:51:00 -0800 (PST)
MIME-Version: 1.0
References: <1627e0f688c7de7fe291b09c524c7fbb55cfe367.1610669653.git.sdf@google.com>
 <CAEf4BzZOt-VZPwHZ4uGxG_mZYb7NX3wJv1UiAnnt3+dOSkkqtA@mail.gmail.com>
In-Reply-To: <CAEf4BzZOt-VZPwHZ4uGxG_mZYb7NX3wJv1UiAnnt3+dOSkkqtA@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 14 Jan 2021 19:50:49 -0800
Message-ID: <CAKH8qBuvbRa0qSbYBqJ0cz5vcQ-8XQA8k6B4FS-TNE1QUEnH8Q@mail.gmail.com>
Subject: Re: [RPC PATCH bpf-next] bpf: implement new BPF_CGROUP_INET_SOCK_POST_CONNECT
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 6:38 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jan 14, 2021 at 4:19 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > We are playing with doing hybrid conntrack where BPF generates
> > connect/disconnect/etc events and puts them into perfbuf (or, later,
> > new ringbuf). We can get most of the functionality out of
> > existing hooks:
> > - BPF_CGROUP_SOCK_OPS fully covers TCP
> > - BPF_CGROUP_UDP4_SENDMSG covers unconnected UDP (with sampling, etc)
> >
> > The only missing bit is connected UDP where we can get some
> > information from the existing BPF_CGROUP_INET{4,6}_CONNECT if the caller
> > did explicit bind(); otherwise, in an autobind case, we get
> > only destination addr/port and no source port because this hook
> > triggers prior to that.
> >
> > We'd really like to avoid the cost of BPF_CGROUP_INET_EGRESS
> > and filtering UDP (which covers both connected and unconnected UDP,
> > but loses that connect/disconnect pseudo signal).
> >
> > The proposal is to add a new BPF_CGROUP_INET_SOCK_POST_CONNECT which
> > triggers right before sys_connect exits in the AF_INET{,6} case.
> > The context is bpf_sock which lets BPF examine the socket state.
> > There is really no reason for it to trigger for all inet socks,
> > I've considered adding BPF_CGROUP_UDP_POST_CONNECT, but decided
> > that it might be better to have a generic inet case.
> >
> > New hook triggers right before sys_connect() returns and gives
> > BPF an opportunity to explore source & destination addresses
> > as well as ability to return EPERM to the user.
> >
> > This is somewhat analogous to the existing BPF_CGROUP_INET{4,6}_POST_BIND
> > hooks with the intention to log the connection addresses (after autobind).
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > Change-Id: I46d0122f93c58b17bfae5ba5040b0b0343908c19
> > ---
> >  include/linux/bpf-cgroup.h | 17 +++++++++++++++++
> >  include/uapi/linux/bpf.h   |  1 +
> >  kernel/bpf/syscall.c       |  3 +++
> >  net/core/filter.c          |  4 ++++
> >  net/ipv4/af_inet.c         |  7 ++++++-
> >  5 files changed, 31 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > index 72e69a0e1e8c..f110935258b9 100644
> > --- a/include/linux/bpf-cgroup.h
> > +++ b/include/linux/bpf-cgroup.h
> > @@ -213,12 +213,29 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
> >         __ret;                                                                 \
> >  })
> >
> > +#define BPF_CGROUP_RUN_SK_PROG_LOCKED(sk, type)                                       \
> > +({                                                                            \
> > +       int __ret = 0;                                                         \
> > +       if (cgroup_bpf_enabled) {                                              \
> > +               lock_sock(sk);                                                 \
> > +               __ret = __cgroup_bpf_run_filter_sk(sk, type);                  \
> > +               release_sock(sk);                                              \
> > +       }                                                                      \
> > +       __ret;                                                                 \
> > +})
> > +
> >  #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk)                                     \
> >         BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_CREATE)
> >
> >  #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk)                             \
> >         BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_RELEASE)
> >
> > +#define BPF_CGROUP_RUN_PROG_INET_SOCK_POST_CONNECT(sk)                        \
> > +       BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_POST_CONNECT)
> > +
> > +#define BPF_CGROUP_RUN_PROG_INET_SOCK_POST_CONNECT_LOCKED(sk)                 \
> > +       BPF_CGROUP_RUN_SK_PROG_LOCKED(sk, BPF_CGROUP_INET_SOCK_POST_CONNECT)
> > +
> >  #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk)                                       \
> >         BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET4_POST_BIND)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index a1ad32456f89..3235f7bd131f 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -241,6 +241,7 @@ enum bpf_attach_type {
> >         BPF_XDP_CPUMAP,
> >         BPF_SK_LOOKUP,
> >         BPF_XDP,
> > +       BPF_CGROUP_INET_SOCK_POST_CONNECT,
>
> Adding new bpf_attach_type enums keeps blowing up the size of struct
> cgroup_bpf. Right now we have 38 different values, of which 15 values
> are not related to cgroups (judging by their name). That results in 15
> * (8 + 16 + 4) = 420 extra bytes wasted for each struct cgroup_bpf
> (and thus struct cgroup). Probably not critical, but it would be nice
> to not waste space unnecessarily.
>
> Would anyone be interested in addressing this? Basically, instead of
> using MAX_BPF_ATTACH_TYPE from enum bpf_attach_type, we'd need to have
> cgroup-specific enumeration and mapping bpf_attach_type to that
> bpf_cgroup_attach_type to compactly store information in struct
> cgroup_bpf. Thoughts?
Sure, I can get to that at some point if nobody beats me to it.
Assuming we have 10k cgroups on the machine, it would save about 4mb,
which doesn't look alarming.

> >         __MAX_BPF_ATTACH_TYPE
> >  };
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index c3bb03c8371f..7d6fd1e32d22 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -1958,6 +1958,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
> >                 switch (expected_attach_type) {
> >                 case BPF_CGROUP_INET_SOCK_CREATE:
> >                 case BPF_CGROUP_INET_SOCK_RELEASE:
> > +               case BPF_CGROUP_INET_SOCK_POST_CONNECT:
> >                 case BPF_CGROUP_INET4_POST_BIND:
> >                 case BPF_CGROUP_INET6_POST_BIND:
> >                         return 0;
> > @@ -2910,6 +2911,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
> >                 return BPF_PROG_TYPE_CGROUP_SKB;
> >         case BPF_CGROUP_INET_SOCK_CREATE:
> >         case BPF_CGROUP_INET_SOCK_RELEASE:
> > +       case BPF_CGROUP_INET_SOCK_POST_CONNECT:
> >         case BPF_CGROUP_INET4_POST_BIND:
> >         case BPF_CGROUP_INET6_POST_BIND:
> >                 return BPF_PROG_TYPE_CGROUP_SOCK;
> > @@ -3063,6 +3065,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
> >         case BPF_CGROUP_INET_EGRESS:
> >         case BPF_CGROUP_INET_SOCK_CREATE:
> >         case BPF_CGROUP_INET_SOCK_RELEASE:
> > +       case BPF_CGROUP_INET_SOCK_POST_CONNECT:
> >         case BPF_CGROUP_INET4_BIND:
> >         case BPF_CGROUP_INET6_BIND:
> >         case BPF_CGROUP_INET4_POST_BIND:
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 9ab94e90d660..d955321d3415 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -7683,12 +7683,14 @@ static bool __sock_filter_check_attach_type(int off,
> >                 switch (attach_type) {
> >                 case BPF_CGROUP_INET_SOCK_CREATE:
> >                 case BPF_CGROUP_INET_SOCK_RELEASE:
> > +               case BPF_CGROUP_INET_SOCK_POST_CONNECT:
> >                         goto full_access;
> >                 default:
> >                         return false;
> >                 }
> >         case bpf_ctx_range(struct bpf_sock, src_ip4):
> >                 switch (attach_type) {
> > +               case BPF_CGROUP_INET_SOCK_POST_CONNECT:
> >                 case BPF_CGROUP_INET4_POST_BIND:
> >                         goto read_only;
> >                 default:
> > @@ -7696,6 +7698,7 @@ static bool __sock_filter_check_attach_type(int off,
> >                 }
> >         case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
> >                 switch (attach_type) {
> > +               case BPF_CGROUP_INET_SOCK_POST_CONNECT:
> >                 case BPF_CGROUP_INET6_POST_BIND:
> >                         goto read_only;
> >                 default:
> > @@ -7703,6 +7706,7 @@ static bool __sock_filter_check_attach_type(int off,
> >                 }
> >         case bpf_ctx_range(struct bpf_sock, src_port):
> >                 switch (attach_type) {
> > +               case BPF_CGROUP_INET_SOCK_POST_CONNECT:
> >                 case BPF_CGROUP_INET4_POST_BIND:
> >                 case BPF_CGROUP_INET6_POST_BIND:
> >                         goto read_only;
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index b94fa8eb831b..568654cafa48 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -574,7 +574,10 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
> >
> >         if (!inet_sk(sk)->inet_num && inet_autobind(sk))
> >                 return -EAGAIN;
> > -       return sk->sk_prot->connect(sk, uaddr, addr_len);
> > +       err = sk->sk_prot->connect(sk, uaddr, addr_len);
> > +       if (!err)
> > +               err = BPF_CGROUP_RUN_PROG_INET_SOCK_POST_CONNECT_LOCKED(sk);
> > +       return err;
> >  }
> >  EXPORT_SYMBOL(inet_dgram_connect);
> >
>
> Have you tried attaching the fexit program to inet_dgram_connect?
> Doesn't it give all the information you need?
>
> > @@ -723,6 +726,8 @@ int inet_stream_connect(struct socket *sock, struct sockaddr *uaddr,
> >
> >         lock_sock(sock->sk);
> >         err = __inet_stream_connect(sock, uaddr, addr_len, flags, 0);
>
> Similarly here, attaching fexit to __inet_stream_connect would execute
> your BPF program at exactly the same time (and then you can check for
> err value).
>
> Or the point here is to have a more "stable" BPF program type?
Good suggestion, I can try to play with it, I think it should give me
all the info I need (I only need sock).
But yeah, I'd rather prefer a stable interface against stable
__sk_buff, but maybe fexit will also work.
