Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A652F70AA
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732241AbhAOCjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbhAOCjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:39:19 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A53C0613D3;
        Thu, 14 Jan 2021 18:38:39 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id r63so3736289ybf.5;
        Thu, 14 Jan 2021 18:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nb+VkVdFaH66YXBIqvGNaJfDslxfLalcdKzflhEJ+Eg=;
        b=pP7tyuH7SNNzh/5Br5tnMJoyz0VmM577CkxGlmLXKwsHDIHg3Ou6/gndUcOmW5lioI
         meca/AkYqpqcuB6oe/NnON7IbhFeHwYwzzC9WfMj/CtelrIEvrsHj217//bBheIy/2zQ
         aNY1E5qg5IjNXDcCsYQIuKm+SUY+f9dlj3IR44N0MM6bwxAC6scE5A8Zt6n2YY8sy+zX
         XqOyb0a/fMY0LfwTPlL1x1ZfzxMpyvWxFvPOXW3Vhh6EL/0EGMfsIhethjjAXPBz6PMr
         eS9C0HzBHqdEkxHSH5yh9aiLTxuJBSlGQqG7GfzKKoeTl5myf27l4i4SgYkFxrmIeOMe
         PE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nb+VkVdFaH66YXBIqvGNaJfDslxfLalcdKzflhEJ+Eg=;
        b=XlFgLIT6nyZHKi9tJTMebqkeDJuUCWRvxJDDP8KOJBmkLMUFJQjmvUD4fSvxGUcBQX
         0Z+d5iXumuKgv+E0WzWu28CQMPhIwEXZ+5x47LW0jyCL8tSxD8Ij1BTkPBAsYnhMWlSV
         RcKlMMHqNXHnWvQtohDxQoqhSA58YEO8BK5ZHh97gsaiSxQSAM3kFp43au5/BmkzhfI3
         aQRxHrRQ5OJNLDlim7LQaGyPX7y8ikJlOrakQ1kld6t1t5PXIiyiUv71vE3t/Oyyutov
         UXCjxkwUda2gS+uLEIFyIEtvUS3KVjjqzZmi7m9dM7BhzNdLBJDuPiT6FH97mNTyEp4f
         ggFg==
X-Gm-Message-State: AOAM533Fv0DIItxB+P+qJje+21aQe2yTdtg7cAF+3JRAVAuxZfscZBnX
        oGvHQL7yqUkgKV91h5CyESDg5SLbsRCgAOQoqWQ=
X-Google-Smtp-Source: ABdhPJx2ekvMWzhn01+xwdkcD8gNSSeAMhnRek4l9xTX61Xs+fgeYWJaSwg7h6Y2h0c0EGL3al070mnP2VTEntvfMTw=
X-Received: by 2002:a25:4107:: with SMTP id o7mr14456783yba.459.1610678318417;
 Thu, 14 Jan 2021 18:38:38 -0800 (PST)
MIME-Version: 1.0
References: <1627e0f688c7de7fe291b09c524c7fbb55cfe367.1610669653.git.sdf@google.com>
In-Reply-To: <1627e0f688c7de7fe291b09c524c7fbb55cfe367.1610669653.git.sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 Jan 2021 18:38:27 -0800
Message-ID: <CAEf4BzZOt-VZPwHZ4uGxG_mZYb7NX3wJv1UiAnnt3+dOSkkqtA@mail.gmail.com>
Subject: Re: [RPC PATCH bpf-next] bpf: implement new BPF_CGROUP_INET_SOCK_POST_CONNECT
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 4:19 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> We are playing with doing hybrid conntrack where BPF generates
> connect/disconnect/etc events and puts them into perfbuf (or, later,
> new ringbuf). We can get most of the functionality out of
> existing hooks:
> - BPF_CGROUP_SOCK_OPS fully covers TCP
> - BPF_CGROUP_UDP4_SENDMSG covers unconnected UDP (with sampling, etc)
>
> The only missing bit is connected UDP where we can get some
> information from the existing BPF_CGROUP_INET{4,6}_CONNECT if the caller
> did explicit bind(); otherwise, in an autobind case, we get
> only destination addr/port and no source port because this hook
> triggers prior to that.
>
> We'd really like to avoid the cost of BPF_CGROUP_INET_EGRESS
> and filtering UDP (which covers both connected and unconnected UDP,
> but loses that connect/disconnect pseudo signal).
>
> The proposal is to add a new BPF_CGROUP_INET_SOCK_POST_CONNECT which
> triggers right before sys_connect exits in the AF_INET{,6} case.
> The context is bpf_sock which lets BPF examine the socket state.
> There is really no reason for it to trigger for all inet socks,
> I've considered adding BPF_CGROUP_UDP_POST_CONNECT, but decided
> that it might be better to have a generic inet case.
>
> New hook triggers right before sys_connect() returns and gives
> BPF an opportunity to explore source & destination addresses
> as well as ability to return EPERM to the user.
>
> This is somewhat analogous to the existing BPF_CGROUP_INET{4,6}_POST_BIND
> hooks with the intention to log the connection addresses (after autobind).
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> Change-Id: I46d0122f93c58b17bfae5ba5040b0b0343908c19
> ---
>  include/linux/bpf-cgroup.h | 17 +++++++++++++++++
>  include/uapi/linux/bpf.h   |  1 +
>  kernel/bpf/syscall.c       |  3 +++
>  net/core/filter.c          |  4 ++++
>  net/ipv4/af_inet.c         |  7 ++++++-
>  5 files changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 72e69a0e1e8c..f110935258b9 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -213,12 +213,29 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>         __ret;                                                                 \
>  })
>
> +#define BPF_CGROUP_RUN_SK_PROG_LOCKED(sk, type)                                       \
> +({                                                                            \
> +       int __ret = 0;                                                         \
> +       if (cgroup_bpf_enabled) {                                              \
> +               lock_sock(sk);                                                 \
> +               __ret = __cgroup_bpf_run_filter_sk(sk, type);                  \
> +               release_sock(sk);                                              \
> +       }                                                                      \
> +       __ret;                                                                 \
> +})
> +
>  #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk)                                     \
>         BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_CREATE)
>
>  #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk)                             \
>         BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_RELEASE)
>
> +#define BPF_CGROUP_RUN_PROG_INET_SOCK_POST_CONNECT(sk)                        \
> +       BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_POST_CONNECT)
> +
> +#define BPF_CGROUP_RUN_PROG_INET_SOCK_POST_CONNECT_LOCKED(sk)                 \
> +       BPF_CGROUP_RUN_SK_PROG_LOCKED(sk, BPF_CGROUP_INET_SOCK_POST_CONNECT)
> +
>  #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk)                                       \
>         BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET4_POST_BIND)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a1ad32456f89..3235f7bd131f 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -241,6 +241,7 @@ enum bpf_attach_type {
>         BPF_XDP_CPUMAP,
>         BPF_SK_LOOKUP,
>         BPF_XDP,
> +       BPF_CGROUP_INET_SOCK_POST_CONNECT,

Adding new bpf_attach_type enums keeps blowing up the size of struct
cgroup_bpf. Right now we have 38 different values, of which 15 values
are not related to cgroups (judging by their name). That results in 15
* (8 + 16 + 4) = 420 extra bytes wasted for each struct cgroup_bpf
(and thus struct cgroup). Probably not critical, but it would be nice
to not waste space unnecessarily.

Would anyone be interested in addressing this? Basically, instead of
using MAX_BPF_ATTACH_TYPE from enum bpf_attach_type, we'd need to have
cgroup-specific enumeration and mapping bpf_attach_type to that
bpf_cgroup_attach_type to compactly store information in struct
cgroup_bpf. Thoughts?


>         __MAX_BPF_ATTACH_TYPE
>  };
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index c3bb03c8371f..7d6fd1e32d22 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1958,6 +1958,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
>                 switch (expected_attach_type) {
>                 case BPF_CGROUP_INET_SOCK_CREATE:
>                 case BPF_CGROUP_INET_SOCK_RELEASE:
> +               case BPF_CGROUP_INET_SOCK_POST_CONNECT:
>                 case BPF_CGROUP_INET4_POST_BIND:
>                 case BPF_CGROUP_INET6_POST_BIND:
>                         return 0;
> @@ -2910,6 +2911,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>                 return BPF_PROG_TYPE_CGROUP_SKB;
>         case BPF_CGROUP_INET_SOCK_CREATE:
>         case BPF_CGROUP_INET_SOCK_RELEASE:
> +       case BPF_CGROUP_INET_SOCK_POST_CONNECT:
>         case BPF_CGROUP_INET4_POST_BIND:
>         case BPF_CGROUP_INET6_POST_BIND:
>                 return BPF_PROG_TYPE_CGROUP_SOCK;
> @@ -3063,6 +3065,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
>         case BPF_CGROUP_INET_EGRESS:
>         case BPF_CGROUP_INET_SOCK_CREATE:
>         case BPF_CGROUP_INET_SOCK_RELEASE:
> +       case BPF_CGROUP_INET_SOCK_POST_CONNECT:
>         case BPF_CGROUP_INET4_BIND:
>         case BPF_CGROUP_INET6_BIND:
>         case BPF_CGROUP_INET4_POST_BIND:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 9ab94e90d660..d955321d3415 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7683,12 +7683,14 @@ static bool __sock_filter_check_attach_type(int off,
>                 switch (attach_type) {
>                 case BPF_CGROUP_INET_SOCK_CREATE:
>                 case BPF_CGROUP_INET_SOCK_RELEASE:
> +               case BPF_CGROUP_INET_SOCK_POST_CONNECT:
>                         goto full_access;
>                 default:
>                         return false;
>                 }
>         case bpf_ctx_range(struct bpf_sock, src_ip4):
>                 switch (attach_type) {
> +               case BPF_CGROUP_INET_SOCK_POST_CONNECT:
>                 case BPF_CGROUP_INET4_POST_BIND:
>                         goto read_only;
>                 default:
> @@ -7696,6 +7698,7 @@ static bool __sock_filter_check_attach_type(int off,
>                 }
>         case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
>                 switch (attach_type) {
> +               case BPF_CGROUP_INET_SOCK_POST_CONNECT:
>                 case BPF_CGROUP_INET6_POST_BIND:
>                         goto read_only;
>                 default:
> @@ -7703,6 +7706,7 @@ static bool __sock_filter_check_attach_type(int off,
>                 }
>         case bpf_ctx_range(struct bpf_sock, src_port):
>                 switch (attach_type) {
> +               case BPF_CGROUP_INET_SOCK_POST_CONNECT:
>                 case BPF_CGROUP_INET4_POST_BIND:
>                 case BPF_CGROUP_INET6_POST_BIND:
>                         goto read_only;
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index b94fa8eb831b..568654cafa48 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -574,7 +574,10 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
>
>         if (!inet_sk(sk)->inet_num && inet_autobind(sk))
>                 return -EAGAIN;
> -       return sk->sk_prot->connect(sk, uaddr, addr_len);
> +       err = sk->sk_prot->connect(sk, uaddr, addr_len);
> +       if (!err)
> +               err = BPF_CGROUP_RUN_PROG_INET_SOCK_POST_CONNECT_LOCKED(sk);
> +       return err;
>  }
>  EXPORT_SYMBOL(inet_dgram_connect);
>

Have you tried attaching the fexit program to inet_dgram_connect?
Doesn't it give all the information you need?

> @@ -723,6 +726,8 @@ int inet_stream_connect(struct socket *sock, struct sockaddr *uaddr,
>
>         lock_sock(sock->sk);
>         err = __inet_stream_connect(sock, uaddr, addr_len, flags, 0);

Similarly here, attaching fexit to __inet_stream_connect would execute
your BPF program at exactly the same time (and then you can check for
err value).

Or the point here is to have a more "stable" BPF program type?

> +       if (!err)
> +               err = BPF_CGROUP_RUN_PROG_INET_SOCK_POST_CONNECT(sock->sk);
>         release_sock(sock->sk);
>         return err;
>  }
> --
> 2.30.0.284.gd98b1dd5eaa7-goog
>
