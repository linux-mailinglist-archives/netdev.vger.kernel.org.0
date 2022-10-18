Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADEE6033D7
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 22:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiJRUTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 16:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiJRUTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 16:19:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18874655F
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 13:19:32 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b14-20020a170902d50e00b001854f631c4eso5048171plg.8
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 13:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e++9QBKymCk6GbONADV6RM6byWvm5vQbN9+OXTXTuWA=;
        b=EVCur8anPPEc+yk+78UuB1RqYq1WqPLpwC16itWhkhkFmgcJwVEyjIF2F2DGRqioMy
         fYF/4cDsjWlBFnSuowj7JivNj5n3lzSERjgOljqe7GmXaA3dvz4bJjlesQK9KYyJN3s6
         SODIeTzl8+ziv/AU9+cJaQRubDKykPMvOS/2iDXOKE67t2JqJyMKPiWEOjZioDOxfs4C
         +Xire59bMAHoHwZ+7jgBLleUJDXiQkNSNxEoh8qNpbdBs3/5oZg39TlJrjMki58koDRF
         hWWQ6EQ82NwywiobH70t0Fj30duGddl3TPHZC8KnnWrIgEtEvZ1QFRrhfwdENett2HjW
         +UYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e++9QBKymCk6GbONADV6RM6byWvm5vQbN9+OXTXTuWA=;
        b=amA0WHBkbLSJ9UqtqkQuDt14BMPu7R9zO43f1Qjs563A3BZ4+u9eRJIjSQ7QmZhk/O
         DsmByR79M0zZc6zSjIU7PkxYW7bahbP7jopRPXzv6lTw1VaVvJrP3y0cuNSx/3drIDFu
         F+4ouE0b/84sQDnzMDZEe37uUZq0JALDOhc0/C9RVWnw9pbS1Yv5t62ftwkvV/u7gNbf
         OoSIzklK3Dt8r1Jypd/aLwl9psGeYL+XL2wnekWOqdXCxAzlAqJelbED5dugSpASQp5y
         bf3dJr1Do9uPk/jY4nWRTE8telV6tMScy5gDhox2pknv8Kje81nlBgIUKKNVJNRmvZUz
         evuQ==
X-Gm-Message-State: ACrzQf2Dc7LgHXv3egTUBE/i1L5zrlQManObaKd0T6S69VolWEsiydT/
        2wJ90FI7rQqAwowgU71hxITDYMA=
X-Google-Smtp-Source: AMsMyM7TgwizijO+HNNR7cVX7Op8LrqgFSJe5g5sGHGJaJkidIBqZ2qXuW9N1vyQ7mqurcVmC+N4Dn8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:5408:b0:20a:d6b1:a2a7 with SMTP id
 z8-20020a17090a540800b0020ad6b1a2a7mr1856349pjh.2.1666124370756; Tue, 18 Oct
 2022 13:19:30 -0700 (PDT)
Date:   Tue, 18 Oct 2022 13:19:29 -0700
In-Reply-To: <20221018090205.never.090-kees@kernel.org>
Mime-Version: 1.0
References: <20221018090205.never.090-kees@kernel.org>
Message-ID: <Y08KUZbmHdvtE3Ih@google.com>
Subject: Re: [PATCH] bpf, test_run: Track allocation size of data
From:   sdf@google.com
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18, Kees Cook wrote:
> In preparation for requiring that build_skb() have a non-zero size
> argument, track the data allocation size explicitly and pass it into
> build_skb(). To retain the original result of using the ksize()
> side-effect on the skb size, explicitly round up the size during
> allocation.

Can you share more on the end goal? Is the plan to remove ksize(data)
from build_skb and pass it via size argument?

> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Song Liu <song@kernel.org>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Hao Luo <haoluo@google.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: bpf@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   net/bpf/test_run.c | 84 +++++++++++++++++++++++++---------------------
>   1 file changed, 46 insertions(+), 38 deletions(-)

> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 13d578ce2a09..299ff102f516 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -762,28 +762,38 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref,  
> KF_TRUSTED_ARGS)
>   BTF_ID_FLAGS(func, bpf_kfunc_call_test_destructive, KF_DESTRUCTIVE)
>   BTF_SET8_END(test_sk_check_kfunc_ids)

> -static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
> -			   u32 size, u32 headroom, u32 tailroom)
> +struct bpfalloc {
> +	size_t len;
> +	void  *data;
> +};
> +
> +static int bpf_test_init(struct bpfalloc *alloc,
> +			 const union bpf_attr *kattr, u32 user_size,
> +			 u32 size, u32 headroom, u32 tailroom)
>   {
>   	void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
> -	void *data;

>   	if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom)
> -		return ERR_PTR(-EINVAL);
> +		return -EINVAL;

>   	if (user_size > size)
> -		return ERR_PTR(-EMSGSIZE);
> +		return -EMSGSIZE;

> -	data = kzalloc(size + headroom + tailroom, GFP_USER);
> -	if (!data)
> -		return ERR_PTR(-ENOMEM);

[..]

> +	alloc->len = kmalloc_size_roundup(size + headroom + tailroom);
> +	alloc->data = kzalloc(alloc->len, GFP_USER);

I still probably miss something. Here, why do we need to do
kmalloc_size_roundup+kzalloc vs doing kzalloc+ksize?

	data = bpf_test_init(kattr, kattr->test.data_size_in,
			     size, NET_SKB_PAD + NET_IP_ALIGN,
			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));

	skb = build_skb(data, ksize(data));

> +	if (!alloc->data) {
> +		alloc->len = 0;
> +		return -ENOMEM;
> +	}

> -	if (copy_from_user(data + headroom, data_in, user_size)) {
> -		kfree(data);
> -		return ERR_PTR(-EFAULT);
> +	if (copy_from_user(alloc->data + headroom, data_in, user_size)) {
> +		kfree(alloc->data);
> +		alloc->data = NULL;
> +		alloc->len = 0;
> +		return -EFAULT;
>   	}

> -	return data;
> +	return 0;
>   }

>   int bpf_prog_test_run_tracing(struct bpf_prog *prog,
> @@ -1086,25 +1096,25 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog,  
> const union bpf_attr *kattr,
>   	u32 size = kattr->test.data_size_in;
>   	u32 repeat = kattr->test.repeat;
>   	struct __sk_buff *ctx = NULL;
> +	struct bpfalloc alloc = { };
>   	u32 retval, duration;
>   	int hh_len = ETH_HLEN;
>   	struct sk_buff *skb;
>   	struct sock *sk;
> -	void *data;
>   	int ret;

>   	if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
>   		return -EINVAL;

> -	data = bpf_test_init(kattr, kattr->test.data_size_in,
> -			     size, NET_SKB_PAD + NET_IP_ALIGN,
> -			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
> -	if (IS_ERR(data))
> -		return PTR_ERR(data);
> +	ret = bpf_test_init(&alloc, kattr, kattr->test.data_size_in,
> +			    size, NET_SKB_PAD + NET_IP_ALIGN,
> +			    SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
> +	if (ret)
> +		return ret;

>   	ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
>   	if (IS_ERR(ctx)) {
> -		kfree(data);
> +		kfree(alloc.data);
>   		return PTR_ERR(ctx);
>   	}

> @@ -1124,15 +1134,15 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog,  
> const union bpf_attr *kattr,

>   	sk = sk_alloc(net, AF_UNSPEC, GFP_USER, &bpf_dummy_proto, 1);
>   	if (!sk) {
> -		kfree(data);
> +		kfree(alloc.data);
>   		kfree(ctx);
>   		return -ENOMEM;
>   	}
>   	sock_init_data(NULL, sk);

> -	skb = build_skb(data, 0);
> +	skb = build_skb(alloc.data, alloc.len);
>   	if (!skb) {
> -		kfree(data);
> +		kfree(alloc.data);
>   		kfree(ctx);
>   		sk_free(sk);
>   		return -ENOMEM;
> @@ -1283,10 +1293,10 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog,  
> const union bpf_attr *kattr,
>   	u32 repeat = kattr->test.repeat;
>   	struct netdev_rx_queue *rxqueue;
>   	struct skb_shared_info *sinfo;
> +	struct bpfalloc alloc = {};
>   	struct xdp_buff xdp = {};
>   	int i, ret = -EINVAL;
>   	struct xdp_md *ctx;
> -	void *data;

>   	if (prog->expected_attach_type == BPF_XDP_DEVMAP ||
>   	    prog->expected_attach_type == BPF_XDP_CPUMAP)
> @@ -1329,16 +1339,14 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog,  
> const union bpf_attr *kattr,
>   		size = max_data_sz;
>   	}

> -	data = bpf_test_init(kattr, size, max_data_sz, headroom, tailroom);
> -	if (IS_ERR(data)) {
> -		ret = PTR_ERR(data);
> +	ret = bpf_test_init(&alloc, kattr, size, max_data_sz, headroom,  
> tailroom);
> +	if (ret)
>   		goto free_ctx;
> -	}

>   	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev,  
> 0);
>   	rxqueue->xdp_rxq.frag_size = headroom + max_data_sz + tailroom;
>   	xdp_init_buff(&xdp, rxqueue->xdp_rxq.frag_size, &rxqueue->xdp_rxq);
> -	xdp_prepare_buff(&xdp, data, headroom, size, true);
> +	xdp_prepare_buff(&xdp, alloc.data, headroom, size, true);
>   	sinfo = xdp_get_shared_info_from_buff(&xdp);

>   	ret = xdp_convert_md_to_buff(ctx, &xdp);
> @@ -1410,7 +1418,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog,  
> const union bpf_attr *kattr,
>   free_data:
>   	for (i = 0; i < sinfo->nr_frags; i++)
>   		__free_page(skb_frag_page(&sinfo->frags[i]));
> -	kfree(data);
> +	kfree(alloc.data);
>   free_ctx:
>   	kfree(ctx);
>   	return ret;
> @@ -1441,10 +1449,10 @@ int bpf_prog_test_run_flow_dissector(struct  
> bpf_prog *prog,
>   	u32 repeat = kattr->test.repeat;
>   	struct bpf_flow_keys *user_ctx;
>   	struct bpf_flow_keys flow_keys;
> +	struct bpfalloc alloc = {};
>   	const struct ethhdr *eth;
>   	unsigned int flags = 0;
>   	u32 retval, duration;
> -	void *data;
>   	int ret;

>   	if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
> @@ -1453,18 +1461,18 @@ int bpf_prog_test_run_flow_dissector(struct  
> bpf_prog *prog,
>   	if (size < ETH_HLEN)
>   		return -EINVAL;

> -	data = bpf_test_init(kattr, kattr->test.data_size_in, size, 0, 0);
> -	if (IS_ERR(data))
> -		return PTR_ERR(data);
> +	ret = bpf_test_init(&alloc, kattr, kattr->test.data_size_in, size, 0,  
> 0);
> +	if (ret)
> +		return ret;

> -	eth = (struct ethhdr *)data;
> +	eth = (struct ethhdr *)alloc.data;

>   	if (!repeat)
>   		repeat = 1;

>   	user_ctx = bpf_ctx_init(kattr, sizeof(struct bpf_flow_keys));
>   	if (IS_ERR(user_ctx)) {
> -		kfree(data);
> +		kfree(alloc.data);
>   		return PTR_ERR(user_ctx);
>   	}
>   	if (user_ctx) {
> @@ -1475,8 +1483,8 @@ int bpf_prog_test_run_flow_dissector(struct  
> bpf_prog *prog,
>   	}

>   	ctx.flow_keys = &flow_keys;
> -	ctx.data = data;
> -	ctx.data_end = (__u8 *)data + size;
> +	ctx.data = alloc.data;
> +	ctx.data_end = (__u8 *)alloc.data + size;

>   	bpf_test_timer_enter(&t);
>   	do {
> @@ -1496,7 +1504,7 @@ int bpf_prog_test_run_flow_dissector(struct  
> bpf_prog *prog,

>   out:
>   	kfree(user_ctx);
> -	kfree(data);
> +	kfree(alloc.data);
>   	return ret;
>   }

> --
> 2.34.1

