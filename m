Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0369925822C
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgHaTyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728724AbgHaTyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:54:17 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790DEC061573;
        Mon, 31 Aug 2020 12:54:17 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x2so221319ilm.0;
        Mon, 31 Aug 2020 12:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Faln3K+IvdWOjbeYMwsyYC3WPhW1jvtjWxGsIa7S4Bw=;
        b=oRvPT/gyGQX726B70nPfF2QZeDAblEPb2aDrw/XMzqiUINh3mBS4oTqSSRjFzK/FeS
         bBkHc3WF77KDyUHOZabtCe8YZ38Ph2Eo1l4LLMJ5xHyGTGonsvapfcnYmUa2HcX80DPJ
         Co+PgUWky9NI9TFBQkYmRuKkxx/ezT4TqyV406EJUB2REkRh0guBaHnAfxvZBTZs46cQ
         C8r9/b/GGr7a+tEQW1FkjbE0HeUGsMZdxRr8HjFZDeHJlGfTiwLRKx0iinV7T6ha7PN3
         yk6IkJkSengB7V8xVDlpVjF8y9fCJdXyrD8SPzvmrzj4PNikWHe08hbiC22tLE7Zk0vH
         H1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Faln3K+IvdWOjbeYMwsyYC3WPhW1jvtjWxGsIa7S4Bw=;
        b=qIjZgnjQKJsmaJb2JMItNEGWi+3a83UjNw/jmzhtsQ8HFArriP4C8LKOsjTH+PzNkT
         W9rYAoWXBEHzNk2juBLPPF56d1hUnBf66ZdQtPolXM/pVg9qSVo2cGJqnYaXFZr+6lCK
         zhlXoiq0J7AcQp0wYPcC/qTU2qwVfr0GHEEagx7Ie+wWoAp/4R4p0OYt0YuLJkOTG6wW
         tWCeRhTvcisXdfGbwlmm1+7styKBMhBHbQfFOYk4FrO7YZkwBtwoqGXcDSlqftUy1wtN
         BceoXu6ZzAONGQ1l4Lnmg1j3or/n1gUUaxF9kNUG7lEqVRX0VdzhmHizcEvJEP+Jc89q
         G/3A==
X-Gm-Message-State: AOAM532vJLdgquDBIKcIHsLXhIfGZ2ABf5kT2S7XsVWBZuFu00OdRoGH
        nTum7YOmJybTgDtb1ADndnQ=
X-Google-Smtp-Source: ABdhPJzgBRCtxZNFHFvqbeA9OxotGnpb5qB8X24GIyInO2g9tLM8P36RnbkHnz9DHaq/5ZP5ClOzpA==
X-Received: by 2002:a92:a1c5:: with SMTP id b66mr2748547ill.71.1598903656829;
        Mon, 31 Aug 2020 12:54:16 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4c46:c3b0:e367:75b2])
        by smtp.googlemail.com with ESMTPSA id r9sm5009648iln.18.2020.08.31.12.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 12:54:16 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpf: add bpf_get_xdp_hash helper function
To:     Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org
Cc:     alexander.h.duyck@intel.com, tom.herbert@intel.com
References: <20200831192506.28896-1-harshitha.ramamurthy@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <04856bca-0952-4dd7-3313-a13be6b2e95a@gmail.com>
Date:   Mon, 31 Aug 2020 13:54:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200831192506.28896-1-harshitha.ramamurthy@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 1:25 PM, Harshitha Ramamurthy wrote:
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a613750d5515..bffe93b526e7 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3576,6 +3576,14 @@ union bpf_attr {
>   * 		the data in *dst*. This is a wrapper of copy_from_user().
>   * 	Return
>   * 		0 on success, or a negative error in case of failure.
> + *
> + * u32 bpf_get_xdp_hash(struct xdp_buff *xdp_md)

I thought there was a change recently making the uapi reference xdp_md;
xdp_buff is not exported as part of the uapi.


> + *	Description
> + *		Return the hash for the xdp context passed. This function
> + *		calls skb_flow_dissect in non-skb mode to calculate the
> + *		hash for the packet.
> + *	Return
> + *		The 32-bit hash.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3727,6 +3735,7 @@ union bpf_attr {
>  	FN(inode_storage_delete),	\
>  	FN(d_path),			\
>  	FN(copy_from_user),		\
> +	FN(get_xdp_hash),		\
>  	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 47eef9a0be6a..cfb5a6aea6c3 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3765,6 +3765,33 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
>  	.arg3_type      = ARG_ANYTHING,
>  };
>  
> +BPF_CALL_1(bpf_get_xdp_hash, struct xdp_buff *, xdp)
> +{
> +	void *data_end = xdp->data_end;
> +	struct ethhdr *eth = xdp->data;
> +	void *data = xdp->data;
> +	struct flow_keys keys;
> +	u32 ret = 0;
> +	int len;
> +
> +	len = data_end - data;
> +	if (len <= 0)
> +		return ret;

you should verify len covers the ethernet header. Looking at
__skb_flow_dissect use of hlen presumes it exists.

> +	memset(&keys, 0, sizeof(keys));
> +	__skb_flow_dissect(dev_net(xdp->rxq->dev), NULL, &flow_keys_dissector,
> +			   &keys, data, eth->h_proto, sizeof(*eth), len,
> +			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);

By STOP_AT_FLOW_LABEL I take it you want this to be an L3 hash. Why not
add a flags argument to the helper and let the hash be L3 or L4?


you should add test cases and have them cover the permutations - e.g.,
vlan, Q-in-Q, ipv4, ipv6, non-IP packet for L3 hash and then udp, tcp
for L4 hash.

