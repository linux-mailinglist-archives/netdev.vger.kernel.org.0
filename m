Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546B52B753B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 05:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgKREFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 23:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgKREFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 23:05:24 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A816EC0613D4;
        Tue, 17 Nov 2020 20:05:22 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id l10so814188lji.4;
        Tue, 17 Nov 2020 20:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CZhqyZmckvjcs7xWjJLkAF+sgWiuWgot+oKaPs72D+k=;
        b=U1PQNi13mW0OBhBaI4JKj0sK9l4wIWzsyA/l3wdF1N9l0Hz6RAkFJFPupmBCEDBjek
         DEuOPNTwg6W06zL9A9lWk3mYmyXGl5iCfzue00MmNCQjlJkrGfGrZHBYMwyJ8EwEuT2Z
         Nz7p8PE5pCIjx10dbG8uISxeNS3dCOMFUeeWGksE789cqjjO8VOw71Bn2Dvu5NX4g7pS
         xeOOn9bmD7eFHWmGlMyX104HwDpWtLf9SUd8a6w7Iz2QQmKn842xY7VaboiaPP7ieejZ
         d5HlEH3tA/aHrZv8swNdU/oh+y/N/CELmbx3WWln1ieqf9J969RVxfrW1pqn7/uOlHcu
         mp1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CZhqyZmckvjcs7xWjJLkAF+sgWiuWgot+oKaPs72D+k=;
        b=p55cH2/5d/ODKBNfDDiHAlrCaf9PZtDfMvq/crw+URicQz/x5mQA+Nno8KhslSwllp
         3NuFcRBdoFmBUeogK5oXnHgwr+0Rq0D+9Ux20hTpf8xbdYMilB7FhuL8406Rx1lzuZTe
         5CteBkDcWc5jn47/AarBWNuJUe4idbiKRIiZQFbJ83dOF8CY6Y+C1rJlaNhqZNO/BaLS
         EU0JM7Mf6M6kZFT3/YYq4NvsBTIhE3cdP6UV+tO3vSw85DmBMx4M3Uel1JAPemmG94yI
         +1z2StF4V5VYJ2K0qHdSUXx4uwBiDMjFFLUzTLnwHq3weIxGoUP2L+ZsNoBoGyP+uxum
         YbAw==
X-Gm-Message-State: AOAM530XPxXhoQ4k3yMEdSDOuSAqMgw6YUOShs8ZXBhdeCPVInfml+lP
        PUNNs+PuCWQnCUbIGewRc4ohYd1yI08XNbZzeos=
X-Google-Smtp-Source: ABdhPJwcCpVXFC3PY64KS/CmkMc6nxxdf5JHnCTkuCntQ62RFFKBFD/jQz04Kt7aIe6o4Ho6/z0yPmrCJH36WQ1/sU4=
X-Received: by 2002:a2e:9681:: with SMTP id q1mr3458491lji.2.1605672321117;
 Tue, 17 Nov 2020 20:05:21 -0800 (PST)
MIME-Version: 1.0
References: <20201118001742.85005-1-sdf@google.com> <20201118001742.85005-3-sdf@google.com>
In-Reply-To: <20201118001742.85005-3-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 17 Nov 2020 20:05:09 -0800
Message-ID: <CAADnVQLxt11Zx8553fegoSWCtt0SQ_6uYViMtuhGxA7sv1YSxA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: allow bpf_{s,g}etsockopt from cgroup
 bind{4,6} hooks
To:     Stanislav Fomichev <sdf@google.com>, Andrey Ignatov <rdna@fb.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 4:17 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> I have to now lock/unlock socket for the bind hook execution.
> That shouldn't cause any overhead because the socket is unbound
> and shouldn't receive any traffic.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf-cgroup.h | 12 ++++++------
>  net/core/filter.c          |  4 ++++
>  net/ipv4/af_inet.c         |  2 +-
>  net/ipv6/af_inet6.c        |  2 +-
>  4 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index ed71bd1a0825..72e69a0e1e8c 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -246,11 +246,11 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>         __ret;                                                                 \
>  })
>
> -#define BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr)                             \
> -       BPF_CGROUP_RUN_SA_PROG(sk, uaddr, BPF_CGROUP_INET4_BIND)
> +#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr)                        \
> +       BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET4_BIND, NULL)
>
> -#define BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr)                             \
> -       BPF_CGROUP_RUN_SA_PROG(sk, uaddr, BPF_CGROUP_INET6_BIND)
> +#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)                        \
> +       BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
>
>  #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (cgroup_bpf_enabled && \
>                                             sk->sk_prot->pre_connect)
> @@ -434,8 +434,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
>  #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk) ({ 0; })
> -#define BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr) ({ 0; })
> -#define BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr) ({ 0; })
> +#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr) ({ 0; })
> +#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET4_CONNECT(sk, uaddr) ({ 0; })
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2ca5eecebacf..21d91dcf0260 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6995,6 +6995,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_sk_storage_delete_proto;
>         case BPF_FUNC_setsockopt:
>                 switch (prog->expected_attach_type) {
> +               case BPF_CGROUP_INET4_BIND:
> +               case BPF_CGROUP_INET6_BIND:
>                 case BPF_CGROUP_INET4_CONNECT:
>                 case BPF_CGROUP_INET6_CONNECT:
>                         return &bpf_sock_addr_setsockopt_proto;
> @@ -7003,6 +7005,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 }
>         case BPF_FUNC_getsockopt:
>                 switch (prog->expected_attach_type) {
> +               case BPF_CGROUP_INET4_BIND:
> +               case BPF_CGROUP_INET6_BIND:
>                 case BPF_CGROUP_INET4_CONNECT:
>                 case BPF_CGROUP_INET6_CONNECT:
>                         return &bpf_sock_addr_getsockopt_proto;
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index b7260c8cef2e..b94fa8eb831b 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -450,7 +450,7 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>         /* BPF prog is run before any checks are done so that if the prog
>          * changes context in a wrong way it will be caught.
>          */
> -       err = BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr);
> +       err = BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr);

I think it is ok, but I need to go through the locking paths more.
Andrey,
please take a look as well.

>         if (err)
>                 return err;
>
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index e648fbebb167..a7e3d170af51 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -451,7 +451,7 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>         /* BPF prog is run before any checks are done so that if the prog
>          * changes context in a wrong way it will be caught.
>          */
> -       err = BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr);
> +       err = BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr);
>         if (err)
>                 return err;
>
> --
> 2.29.2.299.gdc1121823c-goog
>
