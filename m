Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D6C21970F
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 06:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgGIEJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 00:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgGIEJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 00:09:08 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDD3C061A0B;
        Wed,  8 Jul 2020 21:09:08 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id j80so633009qke.0;
        Wed, 08 Jul 2020 21:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4T0B1JNM/xfIf6XmjXBdKP/42DB3QZSBsE93ncBiJ54=;
        b=kMY/5+QHHhCB6b9pDdnWJPNCfZlG979ODrxstjfIh80Dd9xVrgLhi8aBhdp1muT/gI
         qTZ1ANu3aqltClYPODMQfA/IxnmBUPujA8kmRYop/bKzeL5Iw2wS1/3WeuWX9qFanaAY
         rbAQkEQA0UWZRlJAWUL/hdWQYGZ1MzO8EdyLTHynSn143lWyOPmcN7YPNMsdZOiWQgHw
         g3PBu6HDMWC9pZmJigxce2roSJuanBwSdn7MFtz9haUD6Eq17oztmFraqq3R+iMPzUYE
         1pnviMQuEiW2BgWQ//FxYaJO5jROPazNMEGyJJXpP+LIGXW/pef8U5oiMA89bX4GC2G0
         68Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4T0B1JNM/xfIf6XmjXBdKP/42DB3QZSBsE93ncBiJ54=;
        b=aW+t77VslprgV+PLKbBIwehLn4ZQ2pfujipmnC4R0quFeu0cWowbZ9fKk99z8vSBeX
         Ac3JFB0tVtNTjCs3lSuRCJ4ZLd7y5nSKnJw7YSsM93R0EDr9oOS5SmKTMu/HAKMm3kUT
         qeA3rT+EzmvxF8UX/Xxwn4sn2jKsXmqRE6emjIVRo+s7fkXGRRMPoC30f3thZZN81B8w
         xNwZ2hK1Hhtz3zRchmKKsxx+BUEFi9Pc95agGZrF2W+jWbPpKpznyo4LrKtkivYGO5BD
         qq298ic3/5lquHy1st13MKIK3ker4x05oXUc0x4KaYoyTWPSlFQoDlIzaQakahVCzZuz
         znYQ==
X-Gm-Message-State: AOAM531P50r62WRNNwi55a/Mw8lNWQPo+Jy/c6RqXYbi9z3L+lIGMLzA
        Dfg9MpfWi95efrDnrAQitxIGp2z25k2sRL/Zbzw=
X-Google-Smtp-Source: ABdhPJzorzByhLzmq+OOz6FlHzXOOX33AXpRe21AxVtiqoNjFnHUj4udrUvVp9gvqltQlUwtYxAIuiWeyQUDNGGjoYY=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr51106154qkg.437.1594267747788;
 Wed, 08 Jul 2020 21:09:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-3-jakub@cloudflare.com>
In-Reply-To: <20200702092416.11961-3-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Jul 2020 21:08:56 -0700
Message-ID: <CAEf4BzZ7-0TFD4+NqpK9X=Yuiem89Ug27v90fev=nn+3anCTpA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 02/16] bpf: Introduce SK_LOOKUP program type
 with a dedicated attach point
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 2:25 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Add a new program type BPF_PROG_TYPE_SK_LOOKUP with a dedicated attach type
> BPF_SK_LOOKUP. The new program kind is to be invoked by the transport layer
> when looking up a listening socket for a new connection request for
> connection oriented protocols, or when looking up an unconnected socket for
> a packet for connection-less protocols.
>
> When called, SK_LOOKUP BPF program can select a socket that will receive
> the packet. This serves as a mechanism to overcome the limits of what
> bind() API allows to express. Two use-cases driving this work are:
>
>  (1) steer packets destined to an IP range, on fixed port to a socket
>
>      192.0.2.0/24, port 80 -> NGINX socket
>
>  (2) steer packets destined to an IP address, on any port to a socket
>
>      198.51.100.1, any port -> L7 proxy socket
>
> In its run-time context program receives information about the packet that
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
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>
> Notes:
>     v3:
>     - Allow bpf_sk_assign helper to replace previously selected socket only
>       when BPF_SK_LOOKUP_F_REPLACE flag is set, as a precaution for multiple
>       programs running in series to accidentally override each other's verdict.
>     - Let BPF program decide that load-balancing within a reuseport socket group
>       should be skipped for the socket selected with bpf_sk_assign() by passing
>       BPF_SK_LOOKUP_F_NO_REUSEPORT flag. (Martin)
>     - Extend struct bpf_sk_lookup program context with an 'sk' field containing
>       the selected socket with an intention for multiple attached program
>       running in series to see each other's choices. However, currently the
>       verifier doesn't allow checking if pointer is set.
>     - Use bpf-netns infra for link-based multi-program attachment. (Alexei)
>     - Get rid of macros in convert_ctx_access to make it easier to read.
>     - Disallow 1-,2-byte access to context fields containing IP addresses.
>
>     v2:
>     - Make bpf_sk_assign reject sockets that don't use RCU freeing.
>       Update bpf_sk_assign docs accordingly. (Martin)
>     - Change bpf_sk_assign proto to take PTR_TO_SOCKET as argument. (Martin)
>     - Fix broken build when CONFIG_INET is not selected. (Martin)
>     - Rename bpf_sk_lookup{} src_/dst_* fields remote_/local_*. (Martin)
>     - Enforce BPF_SK_LOOKUP attach point on load & attach. (Martin)
>
>  include/linux/bpf-netns.h  |   3 +
>  include/linux/bpf_types.h  |   2 +
>  include/linux/filter.h     |  19 ++++
>  include/uapi/linux/bpf.h   |  74 +++++++++++++++
>  kernel/bpf/net_namespace.c |   5 +
>  kernel/bpf/syscall.c       |   9 ++
>  net/core/filter.c          | 186 +++++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py |   9 +-
>  8 files changed, 306 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
> index 4052d649f36d..cb1d849c5d4f 100644
> --- a/include/linux/bpf-netns.h
> +++ b/include/linux/bpf-netns.h
> @@ -8,6 +8,7 @@
>  enum netns_bpf_attach_type {
>         NETNS_BPF_INVALID = -1,
>         NETNS_BPF_FLOW_DISSECTOR = 0,
> +       NETNS_BPF_SK_LOOKUP,
>         MAX_NETNS_BPF_ATTACH_TYPE
>  };
>

[...]

> +struct bpf_sk_lookup_kern {
> +       u16             family;
> +       u16             protocol;
> +       union {
> +               struct {
> +                       __be32 saddr;
> +                       __be32 daddr;
> +               } v4;
> +               struct {
> +                       const struct in6_addr *saddr;
> +                       const struct in6_addr *daddr;
> +               } v6;
> +       };
> +       __be16          sport;
> +       u16             dport;
> +       struct sock     *selected_sk;
> +       bool            no_reuseport;
> +};
> +
>  #endif /* __LINUX_FILTER_H__ */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 0cb8ec948816..8dd6e6ce5de9 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -189,6 +189,7 @@ enum bpf_prog_type {
>         BPF_PROG_TYPE_STRUCT_OPS,
>         BPF_PROG_TYPE_EXT,
>         BPF_PROG_TYPE_LSM,
> +       BPF_PROG_TYPE_SK_LOOKUP,
>  };
>
>  enum bpf_attach_type {
> @@ -226,6 +227,7 @@ enum bpf_attach_type {
>         BPF_CGROUP_INET4_GETSOCKNAME,
>         BPF_CGROUP_INET6_GETSOCKNAME,
>         BPF_XDP_DEVMAP,
> +       BPF_SK_LOOKUP,


Point not specific to your changes, but I wanted to bring it up for a
while now, so thought this one might be as good an opportunity as any.

It seems like enum bpf_attach_type originally was intended for only
cgroup BPF programs. To that end, cgroup_bpf has a bunch of fields
with sizes proportional to MAX_BPF_ATTACH_TYPE. It costs at least
8+4+16=28 bytes for each different type *per each cgroup*. At this
point, we have 22 cgroup-specific attach types, and this will be the
13th non-cgroup attach type. So cgroups pay a price for each time we
extend bpf_attach_type with a new non-cgroup attach type. cgroup_bpf
is now 336 bytes bigger than it needs to be.

So I wanted to propose that we do the same thing for cgroup_bpf as you
did for net_ns with netns_bpf_attach_type: have a densely-packed enum
just for cgroup attach types and translate now generic bpf_attach_type
to cgroup-specific cgroup_bpf_attach_type.

I wonder what people think? Is that a good idea? Is anyone up for doing this?

>         __MAX_BPF_ATTACH_TYPE
>  };
>

[...]

> +
> +static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
> +                                       const struct bpf_insn *si,
> +                                       struct bpf_insn *insn_buf,
> +                                       struct bpf_prog *prog,
> +                                       u32 *target_size)

Would it be too extreme to rely on BTF and direct memory access
(similar to tp_raw, fentry/fexit, etc) for accessing context fields,
instead of all this assembly rewrites? So instead of having
bpf_sk_lookup and bpf_sk_lookup_kern, it will always be a full variant
(bpf_sk_lookup_kern, or however we'd want to name it then) and
verifier will just ensure that direct memory reads go to the right
field boundaries?

> +{
> +       struct bpf_insn *insn = insn_buf;
> +#if IS_ENABLED(CONFIG_IPV6)
> +       int off;
> +#endif
> +

[...]
