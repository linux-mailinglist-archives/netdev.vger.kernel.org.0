Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB3231C261
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 20:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhBOTVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 14:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhBOTVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 14:21:04 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888A3C061574;
        Mon, 15 Feb 2021 11:20:23 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id q9so6396199ilo.1;
        Mon, 15 Feb 2021 11:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=QAju3LaJKwujWvlvDk+izIeIsqjA8sdwLDYNVniZBDo=;
        b=NhnIOjrqGJWU5I8jYG5SzfqH3oVNlXY1QLGAiJm0z7+cevaJRJIvBlaDRDD0IwWw9W
         gyJg2W/DcYVzANsaDVq99dSxXffPoN3k8xfb6MPwPuP9XxuqLLINkF+xsKUa5CGXrTyN
         PnNiIIZyhdDgFwfv1wFo+XPvChLKDznbRbPLQXgm8xHaKGtSwoGZl7JL3sEum1mF9vhq
         +hOjtCSilN+4Tcf3vnDu8zyu2rG+JZZebqQQz0RG+gKVypNHoqy9GcYRugnz3xCZuFjK
         oAK+Ka2UMLuiswn6EhkfdKaY7ZZgYmjoUCBfcACO6FlhcXM9+gVnbqCRGVsFGQrbPNKl
         6Myg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=QAju3LaJKwujWvlvDk+izIeIsqjA8sdwLDYNVniZBDo=;
        b=BIzRpNo321uJZi3jCUmB85irF9Wjs5OZ7JBZmlIG4sPimo1f+ByphbA92MMVnEdoaY
         4pgtWOQKPbgD5gfC9U9rjxh++SnCealljo+4cIl4PMiobT1NJtmbdwhUFVlF16PryGlq
         nRbfseFa+XWGJrYwY6vUTU0KolLRl33oy/0xFXpSxGBOgLelKlRAaqQ2ku6ebKfGPEW0
         VLi20ooYHKC1+kbKAze5tfa90mb+P3ozk5fCKKv+at1VbGFqu9td1cwJIK9ZWNICRPz1
         QPXkRbDcdrukq5E1eOzkGjZeDwTMOz257Sd9bXJAc+3mtsUhoz5ELp04RcQISD8gHRVC
         Bhbw==
X-Gm-Message-State: AOAM5304fizYpv/CCzuVtkpXamCX/LD/m0MmsQweYygjD+K+x9pplVx9
        2ax1+JIBPNPAT4x3PPaNxj0cSMqBmvI=
X-Google-Smtp-Source: ABdhPJzWnjhQ04A6r9rc+DWe/515EIfIt2vKCefm3P5wNmkSOnzucb6ByezXd2eWvqp2yyTXw06+Tw==
X-Received: by 2002:a05:6e02:154d:: with SMTP id j13mr14312381ilu.153.1613416823082;
        Mon, 15 Feb 2021 11:20:23 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id w3sm9452247ill.80.2021.02.15.11.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 11:20:22 -0800 (PST)
Date:   Mon, 15 Feb 2021 11:20:15 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
In-Reply-To: <20210213214421.226357-5-xiyou.wangcong@gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-5-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v3 4/5] skmsg: use skb ext instead of TCP_SKB_CB
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> does not work for any other non-TCP protocols. We can move them to
> skb ext instead of playing with skb cb, which is harder to make
> correct.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

I'm not seeing the advantage of doing this at the moment. We can
continue to use cb[] here, which is simpler IMO and use the ext
if needed for the other use cases. This is adding a per packet
alloc cost that we don't have at the moment as I understand it.

[...]

> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index e3bb712af257..d5c711ef6d4b 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -459,4 +459,44 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
>  		return false;
>  	return !!psock->saved_data_ready;
>  }
> +
> +struct skb_bpf_ext {
> +	__u32 flags;
> +	struct sock *sk_redir;
> +};
> +
> +#if IS_ENABLED(CONFIG_NET_SOCK_MSG)
> +static inline
> +bool skb_bpf_ext_ingress(const struct sk_buff *skb)
> +{
> +	struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> +
> +	return ext->flags & BPF_F_INGRESS;
> +}
> +
> +static inline
> +void skb_bpf_ext_set_ingress(const struct sk_buff *skb)
> +{
> +	struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> +
> +	ext->flags |= BPF_F_INGRESS;
> +}
> +
> +static inline
> +struct sock *skb_bpf_ext_redirect_fetch(struct sk_buff *skb)
> +{
> +	struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> +
> +	return ext->sk_redir;
> +}
> +
> +static inline
> +void skb_bpf_ext_redirect_clear(struct sk_buff *skb)
> +{
> +	struct skb_bpf_ext *ext = skb_ext_find(skb, SKB_EXT_BPF);
> +
> +	ext->flags = 0;
> +	ext->sk_redir = NULL;
> +}
> +#endif /* CONFIG_NET_SOCK_MSG */

So we will have some slight duplication for cb[] variant and ext
variant above. I'm OK with that to avoid an allocation.

[...]

> @@ -1003,11 +1008,17 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
>  		goto out;
>  	}
>  	skb_set_owner_r(skb, sk);
> +	if (!skb_ext_add(skb, SKB_EXT_BPF)) {
> +		len = 0;
> +		kfree_skb(skb);
> +		goto out;
> +	}
> +

per packet cost here. Perhaps you can argue small alloc will usually not be 
noticable in such a large stack, but once we convert over it will be very
hard to go back. And I'm looking at optimizing this path now.

>  	prog = READ_ONCE(psock->progs.skb_verdict);
>  	if (likely(prog)) {
> -		tcp_skb_bpf_redirect_clear(skb);
> +		skb_bpf_ext_redirect_clear(skb);
>  		ret = sk_psock_bpf_run(psock, prog, skb);
> -		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> +		ret = sk_psock_map_verd(ret, skb_bpf_ext_redirect_fetch(skb));
>  	}
>  	sk_psock_verdict_apply(psock, skb, ret);

Thanks for the series Cong. Drop this patch and resubmit carry ACKs forward
and then lets revisit this later.

Thanks,
John
