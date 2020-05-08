Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF941CA87C
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 12:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgEHKpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 06:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726325AbgEHKpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 06:45:18 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C92C05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 03:45:18 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id m12so4804747wmc.0
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 03:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=rwvajfsW5sZscp2s9GSoMPfy+gOpRUxXtKM/5JGT1Kg=;
        b=EjhUIAoag1Sdh5mCdjnokDkO5Lrhqss9S3q8lRmp2U4/dUqhX9AFNNmeRKBvkjWfqg
         WBD5or0XhVmFTVcnuWRHMs52lsLogOa1lKdGXjktFWgNrhLnLV4ld+RxOlqkp+txOURm
         GZjan31zzvndAUQpoVYOQpMTbQDPCNVFppANQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=rwvajfsW5sZscp2s9GSoMPfy+gOpRUxXtKM/5JGT1Kg=;
        b=PSn3JikvfetyAQBUxBZKwa/vb0xBIoTlypJ7Iqj8erNjQN2xmWFNAKZ41/cY5c9Wwc
         kzCCDKURrFtOTwQ0tbjYyf/s3S7XxArJ27LxhVEc1dmN52RaHPNhb8UPVwp5m+LahsTp
         SSz5g1Fkdg7cn2cw0RBpmnPLzeWJWdaNZBjYtpaxsOgriVDaF4K+0ZXnbUsntvfoJOlF
         vRiWtwBkU7DevgF/IR+I60fA4HyYhzsJU3IGdUuwSTqFQo3BG0aywAInfmb3LFbUNI7f
         RPQXEG3/ZQh91U0AkJTXiGGF1TGfVUniffDHDsYZlO5CXLrWZ0qj4GbMkQZsSzQeECc9
         ZAAw==
X-Gm-Message-State: AGi0PuYyR4RBrJwPL4roPbddowZpr8GHtAbtn3E6wEn244lcZf4HbqHL
        ErrDqUhsUSW7Ty2LpNF2Gc3WWQ==
X-Google-Smtp-Source: APiQypKmczEyd76PJaI9JXg+nviReAhe+uwyKgRb9cCZL5wfrYc62AvMJb/PguBCKgAnaI/TLhWMwg==
X-Received: by 2002:a05:600c:21d6:: with SMTP id x22mr16280503wmj.95.1588934716886;
        Fri, 08 May 2020 03:45:16 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id z18sm2277770wrw.41.2020.05.08.03.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 03:45:16 -0700 (PDT)
References: <20200506125514.1020829-1-jakub@cloudflare.com> <20200506125514.1020829-3-jakub@cloudflare.com> <20200508070638.pqe73q4v3paxpkq5@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, dccp@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next 02/17] bpf: Introduce SK_LOOKUP program type with a dedicated attach point
In-reply-to: <20200508070638.pqe73q4v3paxpkq5@kafai-mbp.dhcp.thefacebook.com>
Date:   Fri, 08 May 2020 12:45:14 +0200
Message-ID: <87a72ivh6t.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 09:06 AM CEST, Martin KaFai Lau wrote:
> On Wed, May 06, 2020 at 02:54:58PM +0200, Jakub Sitnicki wrote:
>> Add a new program type BPF_PROG_TYPE_SK_LOOKUP and a dedicated attach type
>> called BPF_SK_LOOKUP. The new program kind is to be invoked by the
>> transport layer when looking up a socket for a received packet.
>>
>> When called, SK_LOOKUP program can select a socket that will receive the
>> packet. This serves as a mechanism to overcome the limits of what bind()
>> API allows to express. Two use-cases driving this work are:
>>
>>  (1) steer packets destined to an IP range, fixed port to a socket
>>
>>      192.0.2.0/24, port 80 -> NGINX socket
>>
>>  (2) steer packets destined to an IP address, any port to a socket
>>
>>      198.51.100.1, any port -> L7 proxy socket
>>
>> In its run-time context, program receives information about the packet that
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
>> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---

[...]

>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index bb1ab7da6103..26d643c171fd 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -2729,6 +2729,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>>  	case BPF_CGROUP_GETSOCKOPT:
>>  	case BPF_CGROUP_SETSOCKOPT:
>>  		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
>> +	case BPF_SK_LOOKUP:
> It may be a good idea to enforce the "expected_attach_type ==
> BPF_SK_LOOKUP" during prog load time in bpf_prog_load_check_attach().
> The attr->expected_attach_type could be anything right now if I read
> it correctly.

I'll extend bpf_prog_attach_check_attach_type to enforce it for SK_LOOKUP.

>
>> +		return BPF_PROG_TYPE_SK_LOOKUP;
>>  	default:
>>  		return BPF_PROG_TYPE_UNSPEC;
>>  	}
>> @@ -2778,6 +2780,9 @@ static int bpf_prog_attach(const union bpf_attr *attr)
>>  	case BPF_PROG_TYPE_FLOW_DISSECTOR:
>>  		ret = skb_flow_dissector_bpf_prog_attach(attr, prog);
>>  		break;
>> +	case BPF_PROG_TYPE_SK_LOOKUP:
>> +		ret = sk_lookup_prog_attach(attr, prog);
>> +		break;
>>  	case BPF_PROG_TYPE_CGROUP_DEVICE:
>>  	case BPF_PROG_TYPE_CGROUP_SKB:
>>  	case BPF_PROG_TYPE_CGROUP_SOCK:
>> @@ -2818,6 +2823,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>>  		return lirc_prog_detach(attr);
>>  	case BPF_PROG_TYPE_FLOW_DISSECTOR:
>>  		return skb_flow_dissector_bpf_prog_detach(attr);
>> +	case BPF_PROG_TYPE_SK_LOOKUP:
>> +		return sk_lookup_prog_detach(attr);
>>  	case BPF_PROG_TYPE_CGROUP_DEVICE:
>>  	case BPF_PROG_TYPE_CGROUP_SKB:
>>  	case BPF_PROG_TYPE_CGROUP_SOCK:
>> @@ -2867,6 +2874,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
>>  		return lirc_prog_query(attr, uattr);
>>  	case BPF_FLOW_DISSECTOR:
>>  		return skb_flow_dissector_prog_query(attr, uattr);
>> +	case BPF_SK_LOOKUP:
>> +		return sk_lookup_prog_query(attr, uattr);
> "# CONFIG_NET is not set" needs to be taken care.

Sorry, embarassing mistake. Will add stubs returning -EINVAL like
flow_dissector and cgroup_bpf progs have.

>
>>  	default:
>>  		return -EINVAL;
>>  	}
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index bc25bb1085b1..a00bdc70041c 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -9054,6 +9054,253 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
>>
>>  const struct bpf_prog_ops sk_reuseport_prog_ops = {
>>  };
>> +
>> +static DEFINE_MUTEX(sk_lookup_prog_mutex);
>> +
>> +int sk_lookup_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>> +{
>> +	struct net *net = current->nsproxy->net_ns;
>> +	int ret;
>> +
>> +	if (unlikely(attr->attach_flags))
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&sk_lookup_prog_mutex);
>> +	ret = bpf_prog_attach_one(&net->sk_lookup_prog,
>> +				  &sk_lookup_prog_mutex, prog,
>> +				  attr->attach_flags);
>> +	mutex_unlock(&sk_lookup_prog_mutex);
>> +
>> +	return ret;
>> +}
>> +
>> +int sk_lookup_prog_detach(const union bpf_attr *attr)
>> +{
>> +	struct net *net = current->nsproxy->net_ns;
>> +	int ret;
>> +
>> +	if (unlikely(attr->attach_flags))
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&sk_lookup_prog_mutex);
>> +	ret = bpf_prog_detach_one(&net->sk_lookup_prog,
>> +				  &sk_lookup_prog_mutex);
>> +	mutex_unlock(&sk_lookup_prog_mutex);
>> +
>> +	return ret;
>> +}
>> +
>> +int sk_lookup_prog_query(const union bpf_attr *attr,
>> +			 union bpf_attr __user *uattr)
>> +{
>> +	struct net *net;
>> +	int ret;
>> +
>> +	net = get_net_ns_by_fd(attr->query.target_fd);
>> +	if (IS_ERR(net))
>> +		return PTR_ERR(net);
>> +
>> +	ret = bpf_prog_query_one(&net->sk_lookup_prog, attr, uattr);
>> +
>> +	put_net(net);
>> +	return ret;
>> +}
>> +
>> +BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
>> +	   struct sock *, sk, u64, flags)
>> +{
>> +	if (unlikely(flags != 0))
>> +		return -EINVAL;
>> +	if (unlikely(!sk_fullsock(sk)))
> May be ARG_PTR_TO_SOCKET instead?

I had ARG_PTR_TO_SOCKET initially, then switched to SOCK_COMMON to match
the TC bpf_sk_assign proto. Now that you point it out, it makes more
sense to be more specific in the helper proto.

>
>> +		return -ESOCKTNOSUPPORT;
>> +
>> +	/* Check if socket is suitable for packet L3/L4 protocol */
>> +	if (sk->sk_protocol != ctx->protocol)
>> +		return -EPROTOTYPE;
>> +	if (sk->sk_family != ctx->family &&
>> +	    (sk->sk_family == AF_INET || ipv6_only_sock(sk)))
>> +		return -EAFNOSUPPORT;
>> +
>> +	/* Select socket as lookup result */
>> +	ctx->selected_sk = sk;
> Could sk be a TCP_ESTABLISHED sk?

Yes, and what's worse, it could be ref-counted. This is a bug. I should
be rejecting ref counted sockets here.

Callers of __inet_lookup_listener() and inet6_lookup_listener() expect
an RCU-freed socket on return.

For UDP lookup, returning a TCP_ESTABLISHED (connected) socket is okay.


Thank you for valuable comments. Will fix all of the above in v2.
