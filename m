Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB9A221993
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgGPBlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgGPBlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 21:41:39 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079F6C061755;
        Wed, 15 Jul 2020 18:41:39 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id j80so4060058qke.0;
        Wed, 15 Jul 2020 18:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f7bjYxU9cCjqSwiGwoNC4P7Y8nrE6WZ6NW7LLS7IVm8=;
        b=oXpSzycN13l0iNnh/JEb4J5SSZXRlWNlFF36YlB20LMxAoePJL9SOQqgbiwJoyckPQ
         XeCnAUE5pw7e3jf9LjXrYK42NP2NfLICcZp3ORaZbaPJviMNuQWNrA/gVj4AfHc8/yEY
         YOdkVVHoxVADjAit7sRoyVhhxlmh1ZcbzeoJIfBjmLej94KzqgvxduMKWfbvUXlKkqLw
         XSsEcxQJ710tFp5yvbcumza4myyVIsDIx41FKyYSfXYPsQu/ih0q4+iwdgLVDEZKY6xT
         F+uUPEyyv3qk6gMgSI6HKo+HrkkTf6XSVBrTPE6UbRUzih76V/a1t/3ncO/AlDQiaiT5
         W3Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f7bjYxU9cCjqSwiGwoNC4P7Y8nrE6WZ6NW7LLS7IVm8=;
        b=QRfq23q7ykiRPJKd/5QonxO45FVVuh5LgUF7UHSpBOVyoREinRh4s7/QCnHHPUV4js
         t6OLV+bj/8Ev6W0hDwygyLdcjAjvSWQf8oFksVKgxPvS41gTmZ+f9pBrewOIfVQwuQmB
         9r6YepS6KTMhx0dJ1vFY/oVQXjzNt9kpf37/Zfbw0eyjWpZNSvsjsJ3oB9mrFcoRHGwO
         V3eSyTteqrgQ77HvaGMBUbzOrWb5fAYLwiRTMrrTp2jffkfYMC0hXEtXyqGkK4TgLpKl
         9C6o4lTSZ+2t5tg06ERxQkiOQSPsC1hAlqUjWXkZrQ0oltN8wGlRw/+FxX9QZkQWSwQD
         dBow==
X-Gm-Message-State: AOAM531MSrvbjW8XanzDHxrY3M4GMN0efD+We/VhEErqdhPu/F26nxF5
        oUWc/t8xRgS2cXIXfDC/23yFmnHk4vepVVlBs4AXLzTt
X-Google-Smtp-Source: ABdhPJzsmyROsCdwexmwzBg62wm5gl/fmImq8vaNOBCH/jre09ZwrrKoLsEMwDX74bbr442JNUAJAcAFk6KDuDECFAA=
X-Received: by 2002:a37:7683:: with SMTP id r125mr1841115qkc.39.1594863697907;
 Wed, 15 Jul 2020 18:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200713174654.642628-1-jakub@cloudflare.com> <20200713174654.642628-3-jakub@cloudflare.com>
In-Reply-To: <20200713174654.642628-3-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 18:41:27 -0700
Message-ID: <CAEf4BzZd30RmiZaGvDju9X0jybkcdhgOk71fbcdySeJdPzmrAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 02/16] bpf: Introduce SK_LOOKUP program type
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

On Mon, Jul 13, 2020 at 10:47 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
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
>     v4:
>     - Reintroduce narrow load support for most BPF context fields. (Yonghong)
>     - Fix null-ptr-deref in BPF context access when IPv6 address not set.
>     - Unpack v4/v6 IP address union in bpf_sk_lookup context type.
>     - Add verifier support for ARG_PTR_TO_SOCKET_OR_NULL.
>     - Allow resetting socket selection with bpf_sk_assign(ctx, NULL).
>     - Document that bpf_sk_assign accepts a NULL socket.
>
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
>  include/linux/bpf.h        |   1 +
>  include/linux/bpf_types.h  |   2 +
>  include/linux/filter.h     |  17 ++++
>  include/uapi/linux/bpf.h   |  77 ++++++++++++++++
>  kernel/bpf/net_namespace.c |   5 ++
>  kernel/bpf/syscall.c       |   9 ++
>  kernel/bpf/verifier.c      |  10 ++-
>  net/core/filter.c          | 179 +++++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py |   9 +-
>  10 files changed, 308 insertions(+), 4 deletions(-)
>

Looks good, two suggestions below.

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]

> +
> +static const struct bpf_func_proto *
> +sk_lookup_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +       switch (func_id) {
> +       case BPF_FUNC_sk_assign:
> +               return &bpf_sk_lookup_assign_proto;
> +       case BPF_FUNC_sk_release:
> +               return &bpf_sk_release_proto;
> +       default:

Wouldn't it be useful to have functions like
get_current_comm/get_current_pid_tgid/perf_event_output as well?
Similarly how they were added to a bunch of other socket-related BPF
program types recently?


> +               return bpf_base_func_proto(func_id);
> +       }
> +}
> +

[...]

> +       case offsetof(struct bpf_sk_lookup, local_ip4):
> +               *insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +                                     bpf_target_off(struct bpf_sk_lookup_kern,
> +                                                    v4.daddr, 4, target_size));
> +               break;
> +
> +       case bpf_ctx_range_till(struct bpf_sk_lookup,
> +                               remote_ip6[0], remote_ip6[3]):
> +#if IS_ENABLED(CONFIG_IPV6)

nit: if you added {} to this case block, you could have combined the
above `int off` section with this one.

> +               off = si->off;
> +               off -= offsetof(struct bpf_sk_lookup, remote_ip6[0]);
> +               off += bpf_target_off(struct in6_addr, s6_addr32[0], 4, target_size);
> +               *insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
> +                                     offsetof(struct bpf_sk_lookup_kern, v6.saddr));
> +               *insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);
> +               *insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg, off);
> +#else
> +               *insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
> +#endif
> +               break;
> +

[...]
