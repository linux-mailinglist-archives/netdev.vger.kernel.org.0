Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974F6141B5C
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 04:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgASDFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 22:05:35 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:34119 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbgASDFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 22:05:35 -0500
Received: by mail-il1-f194.google.com with SMTP id s15so24606287iln.1;
        Sat, 18 Jan 2020 19:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=n3sQnPV5P4Dr0uJ9ZFnl9Qoydg7+mXVXqkjddrSlvNk=;
        b=Y9vlOvfyxZQH8kjXVsNy9IHanYXXuJIgbMqjWDUafKAFFb/oAXT31u9zadEaNvFmBM
         izmIFfi+wb58TcMmR8NTVzpXacW2JDRzu+ow4cuzLiIheGf8C9DXaVZy+6nvktHakFgx
         9+qOPR/c42eRyVXjANiCw2sg4n1Ps41gwFf0JpUzAFH12gfHnVa9SJLFu2ZwZuNzU0gK
         /SruEP4hFpq5xIy69wrhm7M2jbj7FKt60UDKVL5XlgBiXWOyJkrG7Pe6xi0h7FVmtkMh
         5QcpZ59bLc4DXb12WwMWU7YjL0NxONeZffXwriaVvZL8HG+KAqFl8BVenuwQNq2XTcgd
         +IUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=n3sQnPV5P4Dr0uJ9ZFnl9Qoydg7+mXVXqkjddrSlvNk=;
        b=b99K5K7rWdWZCsmO6wYu9Ig+oL7D4imIsYqsCu5fcdMz55StlnvhrxiFexKNYNhG2t
         XWBRftMHCzUdrLFjDN8LM+RQB9MDsmEHb0kJucgMT6l8NzUlpeNbL1LByOzARRCSW1qK
         91lX40rbk6EW0x+JNRqam0Nvbj1+BvpT32zEkFCWaJ4sigTCEjMSg6HpWIplOml2B4yK
         Oxie2MXT4E4KoL8BQrP0iWuBxkkR6lJHWQ0oEajs2M70ssIEAa3B/J66gEkBTLPToErA
         lrBCoHgi3C6VbbR+0p75MO1mZG4Q0fIY5z+KSrNee8ltzjjJaohZeAc02YQmIvMbMJbY
         auQQ==
X-Gm-Message-State: APjAAAWINHy6ox7mOdaCobKgX5sIqpV1TFl6XacL7hakcVQj0qEDaAb6
        AgTM5qSwmpwevmJLJtVg4qo=
X-Google-Smtp-Source: APXvYqxWuKWcs0AsvcKgPStRrg83SlH4ftkzD1EfmbBE4mFGlBGDSheKgXKpyNKOr29SQ2+M/4wHyA==
X-Received: by 2002:a05:6e02:102c:: with SMTP id o12mr5403922ilj.165.1579403134019;
        Sat, 18 Jan 2020 19:05:34 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h3sm9732151ilh.6.2020.01.18.19.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 19:05:33 -0800 (PST)
Date:   Sat, 18 Jan 2020 19:05:23 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Matthew Cover <werekraken@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jiong Wang <jiong.wang@netronome.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Message-ID: <5e23c773d7a67_13602b2359ea05b824@john-XPS-13-9370.notmuch>
In-Reply-To: <20200118000128.15746-1-matthew.cover@stackpath.com>
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
Subject: RE: [PATCH bpf-next] bpf: add bpf_ct_lookup_{tcp,udp}() helpers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthew Cover wrote:
> Allow looking up an nf_conn. This allows eBPF programs to leverage
> nf_conntrack state for similar purposes to socket state use cases,
> as provided by the socket lookup helpers. This is particularly
> useful when nf_conntrack state is locally available, but socket
> state is not.
> 
> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> ---

Couple coding comments below. Also looks like a couple build errors
so fix those up. I'm still thinking over this though.

Also I prefer the tests in their own patch. So make it a two patch
series.

fwiw I think we could build a native xdp lib for connection tracking
but maybe there are reasons to pull in core conn tracking. Seems like 
a separate discussion.

> + * struct bpf_nf_conn *bpf_ct_lookup_udp(void *ctx, struct bpf_nf_conntrack_tuple *tuple, u32 tuple_size, u64 netns, u64 flags)
> + *	Description
> + *		Look for UDP nf_conntrack entry matching *tuple*, optionally in
> + *		a child network namespace *netns*. The return value must be
> + *		checked, and if non-**NULL**, released via
> + *		**bpf_ct_release**\ ().
> + *
> + *		The *ctx* should point to the context of the program, such as
> + *		the skb or xdp_md (depending on the hook in use). This is used
> + *		to determine the base network namespace for the lookup.
> + *
> + *		*tuple_size* must be one of:
> + *
> + *		**sizeof**\ (*tuple*\ **->ipv4**)
> + *			Look for an IPv4 nf_conn.
> + *		**sizeof**\ (*tuple*\ **->ipv6**)
> + *			Look for an IPv6 nf_conn.
> + *
> + *		If the *netns* is a negative signed 32-bit integer, then the
> + *		nf_conn lookup table in the netns associated with the *ctx* will
> + *		will be used. For the TC hooks, this is the netns of the device
> + *		in the skb. For XDP hooks, this is the netns of the device in
> + *		the xdp_md. If *netns* is any other signed 32-bit value greater
> + *		than or equal to zero then it specifies the ID of the netns
> + *		relative to the netns associated with the *ctx*. *netns* values
> + *		beyond the range of 32-bit integers are reserved for future
> + *		use.

I find the usage of netns a bit awkward. Its being passed as a u64 and
then used as a signed int with the pivot depending on negative?

How about pivot on a flag instead of the signed bit of netns here.

> + *
> + *		All values for *flags* are reserved for future usage, and must
> + *		be left at zero.
> + *
> + *		This helper is available only if the kernel was compiled with
> + *		**CONFIG_NF_CONNTRACK=y** configuration option.

I suspect this should be,

"This helper will return NULL if the kernel was compiled with ..."

Same comment for the earlier _tcp helper.

> + *	Return
> + *		Pointer to **struct bpf_nf_conn**, or **NULL** in case of
> + *		failure.
> + *
> + * int bpf_ct_release(struct bpf_nf_conn *ct)
> + *	Description
> + *		Release the reference held by *ct*. *ct* must be a
> + *		non-**NULL** pointer that was returned from
> + *		**bpf_ct_lookup_xxx**\ ().
> + *	Return
> + *		0 on success, or a negative error in case of failure.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\

[...]
  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> @@ -3278,6 +3363,30 @@ struct bpf_sock_tuple {
>  	};
>  };
>  
> +struct bpf_nf_conn {
> +	__u32 cpu;
> +	__u32 mark;
> +	__u32 status;
> +	__u32 timeout;
> +};
> +
> +struct bpf_nf_conntrack_tuple {
> +	union {
> +		struct {
> +			__be32 saddr;
> +			__be32 daddr;
> +			__be16 sport;
> +			__be16 dport;
> +		} ipv4;
> +		struct {
> +			__be32 saddr[4];
> +			__be32 daddr[4];
> +			__be16 sport;
> +			__be16 dport;
> +		} ipv6;
> +	};
> +};
> +

[...]

> +static int check_nf_ct_access(struct bpf_verifier_env *env, int insn_idx,
> +			     u32 regno, int off, int size,
> +			     enum bpf_access_type t)
> +{
> +	struct bpf_reg_state *regs = cur_regs(env);
> +	struct bpf_reg_state *reg = &regs[regno];
> +	struct bpf_insn_access_aux info = {};
> +	bool valid;
> +
> +	switch (reg->type) {
> +	case PTR_TO_NF_CONN:
> +		valid = bpf_nf_conn_is_valid_access(off, size, t, &info);
> +		break;
> +	default:
> +		valid = false;
> +	}
> +
> +	if (valid) {
> +		env->insn_aux_data[insn_idx].ctx_field_size =
> +			info.ctx_field_size;
> +		return 0;
> +	}
> +
> +	verbose(env, "R%d invalid %s access off=%d size=%d\n",
> +		regno, reg_type_str[reg->type], off, size);
> +
> +	return -EACCES;

nit, but this construction feels odd to me. How about,

 if (reg->type != PTR_TO_NF_CONN) {
	verbose(...)
	return -EACCES;
 }

 env-> ...
 return 0;

The switch sort of implies you have some ideas on future types? What would
those be?

> +}
> +
>  static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
>  			     u32 regno, int off, int size,
>  			     enum bpf_access_type t)
> @@ -2511,6 +2556,13 @@ static bool is_ctx_reg(struct bpf_verifier_env *env, int regno)
>  	return reg->type == PTR_TO_CTX;
>  }

[...]


> diff --git a/net/core/filter.c b/net/core/filter.c
> index 17de674..39ba965 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -74,6 +74,12 @@

[...]

> +static struct nf_conn *
> +__bpf_ct_lookup(struct sk_buff *skb, struct bpf_nf_conntrack_tuple *tuple, u32 len,
> +		struct net *caller_net, u8 proto, u64 netns_id, u64 flags)

Why not just make netns an int instead of pulling a unsigned from the helper and
then converting it into an int?

> +{
> +	struct nf_conn *ct = NULL;
> +	u8 family = AF_UNSPEC;
> +	struct net *net;
> +
> +	if (len == sizeof(tuple->ipv4))
> +		family = AF_INET;
> +	else if (len == sizeof(tuple->ipv6))
> +		family = AF_INET6;
> +	else
> +		goto out;
> +
> +	if (unlikely(family == AF_UNSPEC || flags ||
> +		     !((s32)netns_id < 0 || netns_id <= S32_MAX)))
                                            ^^^^^^^^^^^^^^^^^^^^
If you pass an int here and use flags to set the type I think you avoid this
check.

> +		goto out;
> +
> +	if ((s32)netns_id < 0) {

I don't like this casting here again fallout from u64->int conversion.

> +		net = caller_net;
> +		ct = ct_lookup(net, tuple, family, proto);
> +	} else {
> +		net = get_net_ns_by_id(caller_net, netns_id);
> +		if (unlikely(!net))
> +			goto out;
> +		ct = ct_lookup(net, tuple, family, proto);
> +		put_net(net);
> +	}
> +
> +out:
> +	return ct;
> +}
> +

[...]

Thanks!
John
