Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C6B2168E8
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 11:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgGGJV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 05:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGGJV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 05:21:26 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68312C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 02:21:26 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id s16so18851089lfp.12
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 02:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=HJr9LhqyMQXqf+LV8MxkvGH0oBFP5TNlhtG5mgpxnu4=;
        b=vl1xXaeXYHJMb6iua0OzzmcWSXu/oMcc07eNiv6ArIqf7WYwr6BfFHoAf4SpEBl+s4
         FSBxxZ2bQyjBg6MHz5io8FT9+nhWYr9B2bKJEeaQbrUJxpw8tQwT0C8pMKMOYY1orAv8
         T9EDd5ngfyDctOPGGXUon3HTQkFeOM8YLmKGg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=HJr9LhqyMQXqf+LV8MxkvGH0oBFP5TNlhtG5mgpxnu4=;
        b=E/RFKug7ihv6/Hy75AQIOvxuYvIe+FwvswHWdBxT9eaKcdLjhGhZ9oGgF1zNhPFKTf
         ViTJKLp5zQVtR1QC4uPra6qn0VnJdXx6hXULE4QfEcg45yJ+1jvVz6aLI6FDrxEoTfDM
         ITI9K8LBNEzpYxqPGyOKaj94zuC4VJqkRgFfQPQhmt5qktDyS4m8GEMAUVMoz1SDEqO2
         vmLojbm979dOxJzm8A6LRKj3zU0bgna118G8jilki5GTAhMwdizS9BpfULARDF7BPua9
         EXrdDICKeeigwnYWCuVzFoYE2yA2egwUZwWnCt2uzjRgSP8yv6D7Gsvn26tgB+aQyimi
         3ScA==
X-Gm-Message-State: AOAM530h3DItzEbUkl1YipW/5S5Rs98+QS7yGGl2uHU9puW/L0AlqOwA
        jAjIiCp5z7vU8+IJnGvS5Q24VQ==
X-Google-Smtp-Source: ABdhPJzHIZMbY2eRqvT8/2aE2AqMRfnj0jXb+i8GddzUohlBZuSbGLJGbgtD0xHIvSlxeTIRtytUEg==
X-Received: by 2002:a05:6512:64:: with SMTP id i4mr32555737lfo.113.1594113684710;
        Tue, 07 Jul 2020 02:21:24 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id q1sm9409742lfp.42.2020.07.07.02.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 02:21:24 -0700 (PDT)
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-3-jakub@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 02/16] bpf: Introduce SK_LOOKUP program type with a dedicated attach point
In-reply-to: <20200702092416.11961-3-jakub@cloudflare.com>
Date:   Tue, 07 Jul 2020 11:21:23 +0200
Message-ID: <87lfjvadf0.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 11:24 AM CEST, Jakub Sitnicki wrote:
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

[...]

> diff --git a/net/core/filter.c b/net/core/filter.c
> index c796e141ea8e..286f90e0c824 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -9219,6 +9219,192 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
>
>  const struct bpf_prog_ops sk_reuseport_prog_ops = {
>  };
> +
> +BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
> +	   struct sock *, sk, u64, flags)
> +{
> +	if (unlikely(flags & ~(BPF_SK_LOOKUP_F_REPLACE |
> +			       BPF_SK_LOOKUP_F_NO_REUSEPORT)))
> +		return -EINVAL;
> +	if (unlikely(sk_is_refcounted(sk)))
> +		return -ESOCKTNOSUPPORT; /* reject non-RCU freed sockets */
> +	if (unlikely(sk->sk_state == TCP_ESTABLISHED))
> +		return -ESOCKTNOSUPPORT; /* reject connected sockets */
> +
> +	/* Check if socket is suitable for packet L3/L4 protocol */
> +	if (sk->sk_protocol != ctx->protocol)
> +		return -EPROTOTYPE;
> +	if (sk->sk_family != ctx->family &&
> +	    (sk->sk_family == AF_INET || ipv6_only_sock(sk)))
> +		return -EAFNOSUPPORT;
> +
> +	if (ctx->selected_sk && !(flags & BPF_SK_LOOKUP_F_REPLACE))
> +		return -EEXIST;
> +
> +	/* Select socket as lookup result */
> +	ctx->selected_sk = sk;
> +	ctx->no_reuseport = flags & BPF_SK_LOOKUP_F_NO_REUSEPORT;
> +	return 0;
> +}
> +
> +static const struct bpf_func_proto bpf_sk_lookup_assign_proto = {
> +	.func		= bpf_sk_lookup_assign,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg2_type	= ARG_PTR_TO_SOCKET,
> +	.arg3_type	= ARG_ANYTHING,
> +};
> +
> +static const struct bpf_func_proto *
> +sk_lookup_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +	switch (func_id) {
> +	case BPF_FUNC_sk_assign:
> +		return &bpf_sk_lookup_assign_proto;
> +	case BPF_FUNC_sk_release:
> +		return &bpf_sk_release_proto;
> +	default:
> +		return bpf_base_func_proto(func_id);
> +	}
> +}
> +
> +static bool sk_lookup_is_valid_access(int off, int size,
> +				      enum bpf_access_type type,
> +				      const struct bpf_prog *prog,
> +				      struct bpf_insn_access_aux *info)
> +{
> +	if (off < 0 || off >= sizeof(struct bpf_sk_lookup))
> +		return false;
> +	if (off % size != 0)
> +		return false;
> +	if (type != BPF_READ)
> +		return false;
> +
> +	switch (off) {
> +	case bpf_ctx_range(struct bpf_sk_lookup, family):
> +	case bpf_ctx_range(struct bpf_sk_lookup, protocol):
> +	case bpf_ctx_range(struct bpf_sk_lookup, remote_ip4):
> +	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
> +	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
> +	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
> +	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
> +	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
> +		return size == sizeof(__u32);
> +
> +	case offsetof(struct bpf_sk_lookup, sk):
> +		info->reg_type = PTR_TO_SOCKET;

There's a bug here. bpf_sk_lookup 'sk' field is initially NULL.
reg_type should be PTR_TO_SOCKET_OR_NULL to inform the verifier.
Will fix in v4.

> +		return size == sizeof(__u64);
> +
> +	default:
> +		return false;
> +	}
> +}
> +
> +static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
> +					const struct bpf_insn *si,
> +					struct bpf_insn *insn_buf,
> +					struct bpf_prog *prog,
> +					u32 *target_size)
> +{
> +	struct bpf_insn *insn = insn_buf;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	int off;
> +#endif
> +
> +	switch (si->off) {
> +	case offsetof(struct bpf_sk_lookup, family):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, family) != 2);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, family));
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, protocol):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, protocol) != 2);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, protocol));
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, remote_ip4):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, v4.saddr) != 4);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, v4.saddr));
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, local_ip4):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, v4.daddr) != 4);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, v4.daddr));
> +		break;
> +
> +	case bpf_ctx_range_till(struct bpf_sk_lookup,
> +				remote_ip6[0], remote_ip6[3]):
> +#if IS_ENABLED(CONFIG_IPV6)
> +		BUILD_BUG_ON(sizeof_field(struct in6_addr, s6_addr32[0]) != 4);
> +
> +		off = si->off;
> +		off -= offsetof(struct bpf_sk_lookup, remote_ip6[0]);
> +		off += offsetof(struct in6_addr, s6_addr32[0]);
> +		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, v6.saddr));
> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg, off);
> +#else
> +		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
> +#endif
> +		break;
> +
> +	case bpf_ctx_range_till(struct bpf_sk_lookup,
> +				local_ip6[0], local_ip6[3]):
> +#if IS_ENABLED(CONFIG_IPV6)
> +		BUILD_BUG_ON(sizeof_field(struct in6_addr, s6_addr32[0]) != 4);
> +
> +		off = si->off;
> +		off -= offsetof(struct bpf_sk_lookup, local_ip6[0]);
> +		off += offsetof(struct in6_addr, s6_addr32[0]);
> +		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, v6.daddr));
> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg, off);
> +#else
> +		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
> +#endif
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, remote_port):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, sport) != 2);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, sport));
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, local_port):
> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, dport) != 2);
> +
> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, dport));
> +		break;
> +
> +	case offsetof(struct bpf_sk_lookup, sk):
> +		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sk_lookup_kern, selected_sk));
> +		break;
> +	}
> +
> +	return insn - insn_buf;
> +}
> +
> +const struct bpf_prog_ops sk_lookup_prog_ops = {
> +};
> +
> +const struct bpf_verifier_ops sk_lookup_verifier_ops = {
> +	.get_func_proto		= sk_lookup_func_proto,
> +	.is_valid_access	= sk_lookup_is_valid_access,
> +	.convert_ctx_access	= sk_lookup_convert_ctx_access,
> +};
> +
>  #endif /* CONFIG_INET */
>
>  DEFINE_BPF_DISPATCHER(xdp)

[...]
