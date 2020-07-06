Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E48E2156A4
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 13:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgGFLpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 07:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728859AbgGFLpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 07:45:03 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B03C08C5DF
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 04:45:02 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id s9so44841846ljm.11
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 04:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=x6jNmfo5wUzGgUH61nZ4XnyBlEReBCMz84hGW6wPk2U=;
        b=G+3itNsXgKaUfhJtbNbD+nGuyj7F3BwAedwNO5mDtDuee4mEDMxu27klTqtIlZJNMF
         Lo6jI2FFOiNhab02SCLmhATdFpnyCHDhiSQwzDRJgI/TOt4/eua/2NtL0tXMP192FctV
         BRJDq/6D6Wox3/MtGKsmAtTWqB2QBwbudKY38=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=x6jNmfo5wUzGgUH61nZ4XnyBlEReBCMz84hGW6wPk2U=;
        b=cmJNIfHfeAGu3nAb5WLIqtkJbSExdK4IVyJ7diXGCstzS0vzavImceh4GhXRY2LsZu
         JGQAw2c7C07PD4q3aOXPqhWHXVp3dYD+tPhG0/wx/bE/sSO4f7aOhyf8GZjR9UQ2AhRa
         QDSy+Izzt47v19SrAfae+87jXTp4u01THxHHp9ZaSTLmFPWgAw4GpESrpnhNerNnvLt1
         I6juA1LvuwDnYz19I0Sirbnx7hO0pxIGtgczXCx80fznJjUDvCoZtiyENki7FaRs7OpT
         lBewTpx7ESVm9gWQ7E9O4Z0ErowEDvloP16/ho3ZfELpdA/Zt2kKyrj+9NIcPLyseIim
         tmfg==
X-Gm-Message-State: AOAM532cwYH7f0Dn7iUZ+up0STMnSmJ8VhcjtaX3tVOU+R8gwIfHrNQ+
        0e6dVuXdqbV6dlsToZ2EEJBxsw==
X-Google-Smtp-Source: ABdhPJyyG4FiYsAOG5C529yDGzTyUS9Ju2DOzDe1Az07dJX+4TutDvl5gdX1ZWchkUL2BU2Dln3RGw==
X-Received: by 2002:a2e:874a:: with SMTP id q10mr27296505ljj.149.1594035900538;
        Mon, 06 Jul 2020 04:45:00 -0700 (PDT)
Received: from cloudflare.com (apn-31-0-46-84.dynamic.gprs.plus.pl. [31.0.46.84])
        by smtp.gmail.com with ESMTPSA id f18sm7756357ljn.73.2020.07.06.04.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 04:44:59 -0700 (PDT)
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-3-jakub@cloudflare.com> <e9aab68e-def7-1216-c1cc-c001f70b3e02@fb.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 02/16] bpf: Introduce SK_LOOKUP program type with a dedicated attach point
In-reply-to: <e9aab68e-def7-1216-c1cc-c001f70b3e02@fb.com>
Date:   Mon, 06 Jul 2020 13:44:58 +0200
Message-ID: <87imf0j29x.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 04, 2020 at 08:42 PM CEST, Yonghong Song wrote:
> On 7/2/20 2:24 AM, Jakub Sitnicki wrote:
>> Add a new program type BPF_PROG_TYPE_SK_LOOKUP with a dedicated attach type
>> BPF_SK_LOOKUP. The new program kind is to be invoked by the transport layer
>> when looking up a listening socket for a new connection request for
>> connection oriented protocols, or when looking up an unconnected socket for
>> a packet for connection-less protocols.
>>
>> When called, SK_LOOKUP BPF program can select a socket that will receive
>> the packet. This serves as a mechanism to overcome the limits of what
>> bind() API allows to express. Two use-cases driving this work are:
>>
>>   (1) steer packets destined to an IP range, on fixed port to a socket
>>
>>       192.0.2.0/24, port 80 -> NGINX socket
>>
>>   (2) steer packets destined to an IP address, on any port to a socket
>>
>>       198.51.100.1, any port -> L7 proxy socket
>>
>> In its run-time context program receives information about the packet that
>> triggered the socket lookup. Namely IP version, L4 protocol identifier, and
>> address 4-tuple. Context can be further extended to include ingress
>> interface identifier.
>>
>> To select a socket BPF program fetches it from a map holding socket
>> references, like SOCKMAP or SOCKHASH, and calls bpf_sk_assign(ctx, sk, ...)
>> helper to record the selection. Transport layer then uses the selected
>> socket as a result of socket lookup.
>>
>> This patch only enables the user to attach an SK_LOOKUP program to a
>> network namespace. Subsequent patches hook it up to run on local delivery
>> path in ipv4 and ipv6 stacks.
>>
>> Suggested-by: Marek Majkowski <marek@cloudflare.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>
>> Notes:
>>      v3:
>>      - Allow bpf_sk_assign helper to replace previously selected socket only
>>        when BPF_SK_LOOKUP_F_REPLACE flag is set, as a precaution for multiple
>>        programs running in series to accidentally override each other's verdict.
>>      - Let BPF program decide that load-balancing within a reuseport socket group
>>        should be skipped for the socket selected with bpf_sk_assign() by passing
>>        BPF_SK_LOOKUP_F_NO_REUSEPORT flag. (Martin)
>>      - Extend struct bpf_sk_lookup program context with an 'sk' field containing
>>        the selected socket with an intention for multiple attached program
>>        running in series to see each other's choices. However, currently the
>>        verifier doesn't allow checking if pointer is set.
>>      - Use bpf-netns infra for link-based multi-program attachment. (Alexei)
>>      - Get rid of macros in convert_ctx_access to make it easier to read.
>>      - Disallow 1-,2-byte access to context fields containing IP addresses.
>>           v2:
>>      - Make bpf_sk_assign reject sockets that don't use RCU freeing.
>>        Update bpf_sk_assign docs accordingly. (Martin)
>>      - Change bpf_sk_assign proto to take PTR_TO_SOCKET as argument. (Martin)
>>      - Fix broken build when CONFIG_INET is not selected. (Martin)
>>      - Rename bpf_sk_lookup{} src_/dst_* fields remote_/local_*. (Martin)
>>      - Enforce BPF_SK_LOOKUP attach point on load & attach. (Martin)
>>
>>   include/linux/bpf-netns.h  |   3 +
>>   include/linux/bpf_types.h  |   2 +
>>   include/linux/filter.h     |  19 ++++
>>   include/uapi/linux/bpf.h   |  74 +++++++++++++++
>>   kernel/bpf/net_namespace.c |   5 +
>>   kernel/bpf/syscall.c       |   9 ++
>>   net/core/filter.c          | 186 +++++++++++++++++++++++++++++++++++++
>>   scripts/bpf_helpers_doc.py |   9 +-
>>   8 files changed, 306 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
>> index 4052d649f36d..cb1d849c5d4f 100644
>> --- a/include/linux/bpf-netns.h
>> +++ b/include/linux/bpf-netns.h
>> @@ -8,6 +8,7 @@
>>   enum netns_bpf_attach_type {
>>   	NETNS_BPF_INVALID = -1,
>>   	NETNS_BPF_FLOW_DISSECTOR = 0,
>> +	NETNS_BPF_SK_LOOKUP,
>>   	MAX_NETNS_BPF_ATTACH_TYPE
>>   };
>>   @@ -17,6 +18,8 @@ to_netns_bpf_attach_type(enum bpf_attach_type attach_type)
>>   	switch (attach_type) {
>>   	case BPF_FLOW_DISSECTOR:
>>   		return NETNS_BPF_FLOW_DISSECTOR;
>> +	case BPF_SK_LOOKUP:
>> +		return NETNS_BPF_SK_LOOKUP;
>>   	default:
>>   		return NETNS_BPF_INVALID;
>>   	}
>> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
>> index a18ae82a298a..a52a5688418e 100644
>> --- a/include/linux/bpf_types.h
>> +++ b/include/linux/bpf_types.h
>> @@ -64,6 +64,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2,
>>   #ifdef CONFIG_INET
>>   BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport,
>>   	      struct sk_reuseport_md, struct sk_reuseport_kern)
>> +BPF_PROG_TYPE(BPF_PROG_TYPE_SK_LOOKUP, sk_lookup,
>> +	      struct bpf_sk_lookup, struct bpf_sk_lookup_kern)
>>   #endif
>>   #if defined(CONFIG_BPF_JIT)
>>   BPF_PROG_TYPE(BPF_PROG_TYPE_STRUCT_OPS, bpf_struct_ops,
>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> index 259377723603..ba4f8595fa54 100644
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -1278,4 +1278,23 @@ struct bpf_sockopt_kern {
>>   	s32		retval;
>>   };
>>   +struct bpf_sk_lookup_kern {
>> +	u16		family;
>> +	u16		protocol;
>> +	union {
>> +		struct {
>> +			__be32 saddr;
>> +			__be32 daddr;
>> +		} v4;
>> +		struct {
>> +			const struct in6_addr *saddr;
>> +			const struct in6_addr *daddr;
>> +		} v6;
>> +	};
>> +	__be16		sport;
>> +	u16		dport;
>> +	struct sock	*selected_sk;
>> +	bool		no_reuseport;
>> +};
>> +
>>   #endif /* __LINUX_FILTER_H__ */
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 0cb8ec948816..8dd6e6ce5de9 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -189,6 +189,7 @@ enum bpf_prog_type {
>>   	BPF_PROG_TYPE_STRUCT_OPS,
>>   	BPF_PROG_TYPE_EXT,
>>   	BPF_PROG_TYPE_LSM,
>> +	BPF_PROG_TYPE_SK_LOOKUP,
>>   };
>>     enum bpf_attach_type {
>> @@ -226,6 +227,7 @@ enum bpf_attach_type {
>>   	BPF_CGROUP_INET4_GETSOCKNAME,
>>   	BPF_CGROUP_INET6_GETSOCKNAME,
>>   	BPF_XDP_DEVMAP,
>> +	BPF_SK_LOOKUP,
>>   	__MAX_BPF_ATTACH_TYPE
>>   };
>>   @@ -3067,6 +3069,10 @@ union bpf_attr {
>>    *
>>    * long bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
>>    *	Description
>> + *		Helper is overloaded depending on BPF program type. This
>> + *		description applies to **BPF_PROG_TYPE_SCHED_CLS** and
>> + *		**BPF_PROG_TYPE_SCHED_ACT** programs.
>> + *
>>    *		Assign the *sk* to the *skb*. When combined with appropriate
>>    *		routing configuration to receive the packet towards the socket,
>>    *		will cause *skb* to be delivered to the specified socket.
>> @@ -3092,6 +3098,53 @@ union bpf_attr {
>>    *		**-ESOCKTNOSUPPORT** if the socket type is not supported
>>    *		(reuseport).
>>    *
>> + * int bpf_sk_assign(struct bpf_sk_lookup *ctx, struct bpf_sock *sk, u64 flags)
>
> recently, we have changed return value from "int" to "long" if the helper
> intends to return a negative error. See above
>    long bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)

Thanks. I missed that one. Will fix in v4.

>
>> + *	Description
>> + *		Helper is overloaded depending on BPF program type. This
>> + *		description applies to **BPF_PROG_TYPE_SK_LOOKUP** programs.
>> + *
>> + *		Select the *sk* as a result of a socket lookup.
>> + *
>> + *		For the operation to succeed passed socket must be compatible
>> + *		with the packet description provided by the *ctx* object.
>> + *
>> + *		L4 protocol (**IPPROTO_TCP** or **IPPROTO_UDP**) must
>> + *		be an exact match. While IP family (**AF_INET** or
>> + *		**AF_INET6**) must be compatible, that is IPv6 sockets
>> + *		that are not v6-only can be selected for IPv4 packets.
>> + *
>> + *		Only TCP listeners and UDP unconnected sockets can be
>> + *		selected.
>> + *
>> + *		*flags* argument can combination of following values:
>> + *
>> + *		* **BPF_SK_LOOKUP_F_REPLACE** to override the previous
>> + *		  socket selection, potentially done by a BPF program
>> + *		  that ran before us.
>> + *
>> + *		* **BPF_SK_LOOKUP_F_NO_REUSEPORT** to skip
>> + *		  load-balancing within reuseport group for the socket
>> + *		  being selected.
>> + *
>> + *	Return
>> + *		0 on success, or a negative errno in case of failure.
>> + *
>> + *		* **-EAFNOSUPPORT** if socket family (*sk->family*) is
>> + *		  not compatible with packet family (*ctx->family*).
>> + *
>> + *		* **-EEXIST** if socket has been already selected,
>> + *		  potentially by another program, and
>> + *		  **BPF_SK_LOOKUP_F_REPLACE** flag was not specified.
>> + *
>> + *		* **-EINVAL** if unsupported flags were specified.
>> + *
>> + *		* **-EPROTOTYPE** if socket L4 protocol
>> + *		  (*sk->protocol*) doesn't match packet protocol
>> + *		  (*ctx->protocol*).
>> + *
>> + *		* **-ESOCKTNOSUPPORT** if socket is not in allowed
>> + *		  state (TCP listening or UDP unconnected).
>> + *
> [...]
>> +static bool sk_lookup_is_valid_access(int off, int size,
>> +				      enum bpf_access_type type,
>> +				      const struct bpf_prog *prog,
>> +				      struct bpf_insn_access_aux *info)
>> +{
>> +	if (off < 0 || off >= sizeof(struct bpf_sk_lookup))
>> +		return false;
>> +	if (off % size != 0)
>> +		return false;
>> +	if (type != BPF_READ)
>> +		return false;
>> +
>> +	switch (off) {
>> +	case bpf_ctx_range(struct bpf_sk_lookup, family):
>> +	case bpf_ctx_range(struct bpf_sk_lookup, protocol):
>> +	case bpf_ctx_range(struct bpf_sk_lookup, remote_ip4):
>> +	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
>> +	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
>> +	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
>> +	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
>> +	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
>> +		return size == sizeof(__u32);
>
> Maybe some of the above forcing 4-byte access too restrictive?
> For example, if user did
>    __u16 *remote_port = ctx->remote_port;
>    __u16 *local_port = ctx->local_port;
> compiler is likely to generate a 2-byte load and the verifier
> will reject the program. The same for protocol, family, ...
> Even for local_ip4, user may just want to read one byte to
> do something ...
>
> One example, bpf_sock_addr->user_port.
>
> We have numerous instances like this and kernel has to be
> patched to permit it later.
>
> I think for read we should allow 1/2/4 byte accesses
> whenever possible. pointer of course not allowed.

You have a point. I've tried to keep it simple, but did not consider
that this is creating a pain-point for users and can lead to fights with
the compiler.

Will revert to having 1,2,4-byte reads in v4.

Thanks for comments.

>
>> +
>> +	case offsetof(struct bpf_sk_lookup, sk):
>> +		info->reg_type = PTR_TO_SOCKET;
>> +		return size == sizeof(__u64);
>> +
>> +	default:
>> +		return false;
>> +	}
>> +}
>> +
>> +static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
>> +					const struct bpf_insn *si,
>> +					struct bpf_insn *insn_buf,
>> +					struct bpf_prog *prog,
>> +					u32 *target_size)
>> +{
>> +	struct bpf_insn *insn = insn_buf;
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +	int off;
>> +#endif
>> +
>> +	switch (si->off) {
>> +	case offsetof(struct bpf_sk_lookup, family):
>> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, family) != 2);
>> +
>> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
>> +				      offsetof(struct bpf_sk_lookup_kern, family));
>> +		break;
>> +
>> +	case offsetof(struct bpf_sk_lookup, protocol):
>> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, protocol) != 2);
>> +
>> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
>> +				      offsetof(struct bpf_sk_lookup_kern, protocol));
>> +		break;
>> +
>> +	case offsetof(struct bpf_sk_lookup, remote_ip4):
>> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, v4.saddr) != 4);
>> +
>> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
>> +				      offsetof(struct bpf_sk_lookup_kern, v4.saddr));
>> +		break;
>> +
>> +	case offsetof(struct bpf_sk_lookup, local_ip4):
>> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, v4.daddr) != 4);
>> +
>> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
>> +				      offsetof(struct bpf_sk_lookup_kern, v4.daddr));
>> +		break;
>> +
>> +	case bpf_ctx_range_till(struct bpf_sk_lookup,
>> +				remote_ip6[0], remote_ip6[3]):
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +		BUILD_BUG_ON(sizeof_field(struct in6_addr, s6_addr32[0]) != 4);
>> +
>> +		off = si->off;
>> +		off -= offsetof(struct bpf_sk_lookup, remote_ip6[0]);
>> +		off += offsetof(struct in6_addr, s6_addr32[0]);
>> +		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
>> +				      offsetof(struct bpf_sk_lookup_kern, v6.saddr));
>> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg, off);
>> +#else
>> +		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
>> +#endif
>> +		break;
>> +
>> +	case bpf_ctx_range_till(struct bpf_sk_lookup,
>> +				local_ip6[0], local_ip6[3]):
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +		BUILD_BUG_ON(sizeof_field(struct in6_addr, s6_addr32[0]) != 4);
>> +
>> +		off = si->off;
>> +		off -= offsetof(struct bpf_sk_lookup, local_ip6[0]);
>> +		off += offsetof(struct in6_addr, s6_addr32[0]);
>> +		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
>> +				      offsetof(struct bpf_sk_lookup_kern, v6.daddr));
>> +		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg, off);
>> +#else
>> +		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
>> +#endif
>> +		break;
>> +
>> +	case offsetof(struct bpf_sk_lookup, remote_port):
>> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, sport) != 2);
>> +
>> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
>> +				      offsetof(struct bpf_sk_lookup_kern, sport));
>> +		break;
>> +
>> +	case offsetof(struct bpf_sk_lookup, local_port):
>> +		BUILD_BUG_ON(sizeof_field(struct bpf_sk_lookup_kern, dport) != 2);
>> +
>> +		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
>> +				      offsetof(struct bpf_sk_lookup_kern, dport));
>> +		break;
>> +
>> +	case offsetof(struct bpf_sk_lookup, sk):
>> +		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
>> +				      offsetof(struct bpf_sk_lookup_kern, selected_sk));
>> +		break;
>> +	}
>> +
>> +	return insn - insn_buf;
>> +}
>> +
>> +const struct bpf_prog_ops sk_lookup_prog_ops = {
>> +};
>> +
>> +const struct bpf_verifier_ops sk_lookup_verifier_ops = {
>> +	.get_func_proto		= sk_lookup_func_proto,
>> +	.is_valid_access	= sk_lookup_is_valid_access,
>> +	.convert_ctx_access	= sk_lookup_convert_ctx_access,
>> +};
>> +
>>   #endif /* CONFIG_INET */
>>     DEFINE_BPF_DISPATCHER(xdp)
> [...]
