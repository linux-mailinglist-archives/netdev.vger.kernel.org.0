Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1168C1C717C
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 15:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgEFNQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 09:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728081AbgEFNQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 09:16:23 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619CBC061A10
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 06:16:23 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id z17so1286275oto.4
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 06:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KrCFI2V2zqe/qTnzRWbkcI40W2/tBAB9TinB/lQS1J8=;
        b=X/Ltb2t5BtIOrXLmRQ/hwMdr0Pf5LN60EnL62Nckcfqm76otbOxNRerwSrhrLVYmGC
         bMDIujIBkFddi1t2kEqHBkKEwv70eyRh3YN1TRlJpkgc9L8R8s8SOeI6R+WbgNU5ecqS
         mAF62hBgIA4ZQQFSWMerK3T3DEmpQAsdpkS/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KrCFI2V2zqe/qTnzRWbkcI40W2/tBAB9TinB/lQS1J8=;
        b=sW2UOt3kMz39H+/o58rZuxam8vh1J4IcOFh8jkeMDUnBD63AwMq9UZ3BNX508+RiIN
         Rv33Y47ydsbOc1ny/r9+uI99b5YyXJdQhlnHEpGJGRMcEjVPDswRwUgywjYBRWXpD66D
         accIg1ViGkA2sEmNitDIf0HGUbYXccY5HARVZRp4PYnaFgKavaN3+vIAxVg+EqabY5jR
         bNEz9HYVv3BV98qBeQBq5SSJcwPC2Nb0vxNGuRp1TxshE8+xgYdA1T4MOWfV7YZaWB0h
         hmcZt7vs2N0nxDAqXSeOcKA/Si+K/rJ0+skdsbS82uPBPMe7HFMLzPKmAY6PV2cgpAZD
         eGNw==
X-Gm-Message-State: AGi0PuazkGP1G6Sy3ddAi+dCuKlsKbKkmwYBahS5n0k0zRcBhHpW1om6
        YZyTojCautsnejhv9YAYg0NMNxiSTkv0trz6sZWQBg==
X-Google-Smtp-Source: APiQypKprbkmxFzuWK2QhKyTV/WjrwWW2p/N9kAOgo96dFdwan2eDoZSjI4Ta6R8YWyM/xKNAlSZvPSUZyDOEeU5Eos=
X-Received: by 2002:a9d:629a:: with SMTP id x26mr5619177otk.147.1588770982497;
 Wed, 06 May 2020 06:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200506125514.1020829-1-jakub@cloudflare.com> <20200506125514.1020829-3-jakub@cloudflare.com>
In-Reply-To: <20200506125514.1020829-3-jakub@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 6 May 2020 14:16:10 +0100
Message-ID: <CACAyw9-ro_Dit=3M46=JSrkuc8y+UcsvJgVQuG98KdtmM9mCCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/17] bpf: Introduce SK_LOOKUP program type with
 a dedicated attach point
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        dccp@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 May 2020 at 13:55, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Add a new program type BPF_PROG_TYPE_SK_LOOKUP and a dedicated attach type
> called BPF_SK_LOOKUP. The new program kind is to be invoked by the
> transport layer when looking up a socket for a received packet.
>
> When called, SK_LOOKUP program can select a socket that will receive the
> packet. This serves as a mechanism to overcome the limits of what bind()
> API allows to express. Two use-cases driving this work are:
>
>  (1) steer packets destined to an IP range, fixed port to a socket
>
>      192.0.2.0/24, port 80 -> NGINX socket
>
>  (2) steer packets destined to an IP address, any port to a socket
>
>      198.51.100.1, any port -> L7 proxy socket
>
> In its run-time context, program receives information about the packet that
> triggered the socket lookup. Namely IP version, L4 protocol identifier, and
> address 4-tuple. Context can be further extended to include ingress
> interface identifier.
>
> To select a socket BPF program fetches it from a map holding socket
> references, like SOCKMAP or SOCKHASH, and calls bpf_sk_assign(ctx, sk, ...)
> helper to record the selection. Transport layer then uses the selected
> socket as a result of socket lookup.
>
> This patch only enables the user to attach an SK_LOOKUP program to a
> network namespace. Subsequent patches hook it up to run on local delivery
> path in ipv4 and ipv6 stacks.
>
> Suggested-by: Marek Majkowski <marek@cloudflare.com>
> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/linux/bpf_types.h   |   2 +
>  include/linux/filter.h      |  23 ++++
>  include/net/net_namespace.h |   1 +
>  include/uapi/linux/bpf.h    |  53 ++++++++
>  kernel/bpf/syscall.c        |   9 ++
>  net/core/filter.c           | 247 ++++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py  |   9 +-
>  7 files changed, 343 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index 8345cdf553b8..08c2aef674ac 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -64,6 +64,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2,
>  #ifdef CONFIG_INET
>  BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport,
>               struct sk_reuseport_md, struct sk_reuseport_kern)
> +BPF_PROG_TYPE(BPF_PROG_TYPE_SK_LOOKUP, sk_lookup,
> +             struct bpf_sk_lookup, struct bpf_sk_lookup_kern)
>  #endif
>  #if defined(CONFIG_BPF_JIT)
>  BPF_PROG_TYPE(BPF_PROG_TYPE_STRUCT_OPS, bpf_struct_ops,
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index af37318bb1c5..33254e840c8d 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1280,4 +1280,27 @@ struct bpf_sockopt_kern {
>         s32             retval;
>  };
>
> +struct bpf_sk_lookup_kern {
> +       unsigned short  family;
> +       u16             protocol;
> +       union {
> +               struct {
> +                       __be32 saddr;
> +                       __be32 daddr;
> +               } v4;
> +               struct {
> +                       struct in6_addr saddr;
> +                       struct in6_addr daddr;
> +               } v6;
> +       };
> +       __be16          sport;
> +       u16             dport;
> +       struct sock     *selected_sk;
> +};
> +
> +int sk_lookup_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog);
> +int sk_lookup_prog_detach(const union bpf_attr *attr);
> +int sk_lookup_prog_query(const union bpf_attr *attr,
> +                        union bpf_attr __user *uattr);
> +
>  #endif /* __LINUX_FILTER_H__ */
> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index ab96fb59131c..70bf4888c94d 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -163,6 +163,7 @@ struct net {
>         struct net_generic __rcu        *gen;
>
>         struct bpf_prog __rcu   *flow_dissector_prog;
> +       struct bpf_prog __rcu   *sk_lookup_prog;
>
>         /* Note : following structs are cache line aligned */
>  #ifdef CONFIG_XFRM
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b3643e27e264..e4c61b63d4bc 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -187,6 +187,7 @@ enum bpf_prog_type {
>         BPF_PROG_TYPE_STRUCT_OPS,
>         BPF_PROG_TYPE_EXT,
>         BPF_PROG_TYPE_LSM,
> +       BPF_PROG_TYPE_SK_LOOKUP,
>  };
>
>  enum bpf_attach_type {
> @@ -218,6 +219,7 @@ enum bpf_attach_type {
>         BPF_TRACE_FEXIT,
>         BPF_MODIFY_RETURN,
>         BPF_LSM_MAC,
> +       BPF_SK_LOOKUP,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> @@ -3041,6 +3043,10 @@ union bpf_attr {
>   *
>   * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
>   *     Description
> + *             Helper is overloaded depending on BPF program type. This
> + *             description applies to **BPF_PROG_TYPE_SCHED_CLS** and
> + *             **BPF_PROG_TYPE_SCHED_ACT** programs.
> + *
>   *             Assign the *sk* to the *skb*. When combined with appropriate
>   *             routing configuration to receive the packet towards the socket,
>   *             will cause *skb* to be delivered to the specified socket.
> @@ -3061,6 +3067,39 @@ union bpf_attr {
>   *                                     call from outside of TC ingress.
>   *             * **-ESOCKTNOSUPPORT**  Socket type not supported (reuseport).
>   *
> + * int bpf_sk_assign(struct bpf_sk_lookup *ctx, struct bpf_sock *sk, u64 flags)
> + *     Description
> + *             Helper is overloaded depending on BPF program type. This
> + *             description applies to **BPF_PROG_TYPE_SK_LOOKUP** programs.
> + *
> + *             Select the *sk* as a result of a socket lookup.
> + *
> + *             For the operation to succeed passed socket must be compatible
> + *             with the packet description provided by the *ctx* object.
> + *
> + *             L4 protocol (*IPPROTO_TCP* or *IPPROTO_UDP*) must be an exact
> + *             match. While IP family (*AF_INET* or *AF_INET6*) must be
> + *             compatible, that is IPv6 sockets that are not v6-only can be
> + *             selected for IPv4 packets.
> + *
> + *             Only full sockets can be selected. However, there is no need to
> + *             call bpf_fullsock() before passing a socket as an argument to
> + *             this helper.
> + *
> + *             The *flags* argument must be zero.
> + *     Return
> + *             0 on success, or a negative errno in case of failure.
> + *
> + *             **-EAFNOSUPPORT** is socket family (*sk->family*) is not
> + *             compatible with packet family (*ctx->family*).
> + *
> + *             **-EINVAL** if unsupported flags were specified.
> + *
> + *             **-EPROTOTYPE** if socket L4 protocol (*sk->protocol*) doesn't
> + *             match packet protocol (*ctx->protocol*).
> + *
> + *             **-ESOCKTNOSUPPORT** if socket is not a full socket.
> + *
>   * u64 bpf_ktime_get_boot_ns(void)
>   *     Description
>   *             Return the time elapsed since system boot, in nanoseconds.
> @@ -4012,4 +4051,18 @@ struct bpf_pidns_info {
>         __u32 pid;
>         __u32 tgid;
>  };
> +
> +/* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
> +struct bpf_sk_lookup {
> +       __u32 family;           /* AF_INET, AF_INET6 */
> +       __u32 protocol;         /* IPPROTO_TCP, IPPROTO_UDP */
> +       /* IP addresses allows 1, 2, and 4 bytes access */
> +       __u32 src_ip4;
> +       __u32 src_ip6[4];
> +       __u32 src_port;         /* network byte order */
> +       __u32 dst_ip4;
> +       __u32 dst_ip6[4];
> +       __u32 dst_port;         /* host byte order */

Jakub and I have discussed this off-list, but we couldn't come to an
agreement and decided to invite
your opinion.

I think that dst_port should be in network byte order, since it's one
less exception to the
rule to think about when writing BPF programs.

Jakub's argument is that this follows __sk_buff->local_port precedent,
which is also in host
byte order.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
