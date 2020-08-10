Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F9B240D65
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgHJTCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbgHJTCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 15:02:46 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38791C061756;
        Mon, 10 Aug 2020 12:02:46 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id 93so8192808otx.2;
        Mon, 10 Aug 2020 12:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qLNpaiZRi8l7uJADO7PIlZwY+lgQcKOoTViSg3qPdCo=;
        b=WolB+N9CI2MAW0WcfcIXRV3m1FOdzbPgTGHjqJmxTLDr13dLaiNSSa4il3d2F9rYHk
         jhH3atS4xl17vCMe3NIibSAzoF0K6vqapznwD/5K7go9nzcjqxJJziK/5S4xEakbFIE1
         hgvsXn4g0+maiwLa88JbqArTb2q6QtGr+Eymzxgp3ncCfC85hdkXpqzfpL0b0rno3xVH
         D7IWjleklCcoSXOfdNNB4VcFkB7FziRBQTfEXbO0HO3Ui99gRfDIWHzDCRwBZjPZkvpQ
         c+SPURkoV8+GGfsQfIMo39znl/0v/tvaCGBWzmOwfgzUEqmISbk6EVBfyp0da14tb143
         dIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qLNpaiZRi8l7uJADO7PIlZwY+lgQcKOoTViSg3qPdCo=;
        b=br9ZPF44Zw3XGcwNU4pQ3GhtGpzYCLdG1dGBKQLMLDI/fUdjwCvWr1EobZKJAimbD3
         AFOBfZp3IU5HFLG6m3nt/Yrjtzf38pekIOPsqZjXmzXnncn2X2GOohc/Tc2NSFHB/GqG
         NAY+tzcdR48o8xi9m/KSc1oM/v+aVrcloAdkOeHGEQcekc+C63tfjXi7IDTzf87Dx/U6
         x9s0hWhldIt0eO0vWQ/ywf4Yr+ZxF1g/h5FEnnaFjSSvEslXIGJzqomEes+wYLhxxqJh
         GPA/gUl4jlgF8RXksNXUMt1KaSIG2OGB7xKAe8K6Iz/7izuRZSTcvG8KOMvcZeP0XaLV
         KuQg==
X-Gm-Message-State: AOAM533qYKUS+WAS0Gco1LS2SsvkMfZpf/fkPqZt059Ru3X06s1HaUFM
        dMYQufA6kSGpYewLZd0vGXup/sQ0
X-Google-Smtp-Source: ABdhPJzY75gbQSip4H4jP3xhWoYbYrqpqxzq/OkeFByc9S0jkq8VKD/hu1PvTWwZx8XOVwuGj7LBbg==
X-Received: by 2002:a9d:2784:: with SMTP id c4mr2033580otb.30.1597086165308;
        Mon, 10 Aug 2020 12:02:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9a0:71b5:d4b3:a253])
        by smtp.googlemail.com with ESMTPSA id c3sm639080oov.17.2020.08.10.12.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 12:02:44 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next] bpf: add bpf_get_skb_hash helper function
To:     Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, hawk@kernel.org
Cc:     tom.herbert@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@intel.com, carolyn.wyborny@intel.com
References: <20200810182841.10953-1-harshitha.ramamurthy@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bf183ea6-7b68-3416-2a61-9d3bbf084230@gmail.com>
Date:   Mon, 10 Aug 2020 13:02:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200810182841.10953-1-harshitha.ramamurthy@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/20 12:28 PM, Harshitha Ramamurthy wrote:
> This patch adds a helper function called bpf_get_skb_hash to calculate
> the skb hash for a packet at the XDP layer. In the helper function,

Why? i.e., expected use case?

Pulling this from hardware when possible is better. e.g., Saeed's
hardware hints proposal includes it.

> a local skb is allocated and we populate the fields needed in the skb
> before calling skb_get_hash. To avoid memory allocations for each packet,
> we allocate an skb per CPU and use the same buffer for subsequent hash
> calculations on the same CPU.
> 
> Signed-off-by: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
> ---
>  include/uapi/linux/bpf.h       |  8 ++++++
>  net/core/filter.c              | 50 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  8 ++++++
>  3 files changed, 66 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b134e679e9db..25aa850c8a40 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3394,6 +3394,13 @@ union bpf_attr {
>   *		A non-negative value equal to or less than *size* on success,
>   *		or a negative error in case of failure.
>   *
> + * u32 bpf_get_skb_hash(struct xdp_buff *xdp_md)
> + *	Description
> + *		Return the skb hash for the xdp context passed. This function
> + *		allocates a temporary skb and populates the fields needed. It
> + *		then calls skb_get_hash to calculate the skb hash for the packet.
> + *	Return
> + *		The 32-bit hash.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3538,6 +3545,7 @@ union bpf_attr {
>  	FN(skc_to_tcp_request_sock),	\
>  	FN(skc_to_udp6_sock),		\
>  	FN(get_task_stack),		\
> +	FN(get_skb_hash),		\
>  	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7124f0fe6974..9f6ad7209b44 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3765,6 +3765,54 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
>  	.arg3_type      = ARG_ANYTHING,
>  };
>  
> +static DEFINE_PER_CPU(struct sk_buff *, hash_skb);
> +
> +BPF_CALL_1(bpf_get_skb_hash, struct xdp_buff *, xdp)
> +{
> +	void *data_end = xdp->data_end;
> +	struct ethhdr *eth = xdp->data;
> +	void *data = xdp->data;
> +	unsigned long flags;
> +	struct sk_buff *skb;
> +	int nh_off, len;
> +	u32 ret = 0;
> +
> +	/* disable interrupts to get the correct skb pointer */
> +	local_irq_save(flags);
> +
> +	len = data_end - data;
> +	skb = this_cpu_read(hash_skb);
> +	if (!skb) {
> +		skb = alloc_skb(len, GFP_ATOMIC);
> +		if (!skb)
> +			goto out;
> +		this_cpu_write(hash_skb, skb);
> +	}
> +
> +	nh_off = sizeof(*eth);

vlans?

> +	if (data + nh_off > data_end)
> +		goto out;
> +
> +	skb->data = data;
> +	skb->head = data;
> +	skb->network_header = nh_off;
> +	skb->protocol = eth->h_proto;
> +	skb->len = len;
> +	skb->dev = xdp->rxq->dev;
> +
> +	ret = skb_get_hash(skb);

static inline __u32 skb_get_hash(struct sk_buff *skb)
{
        if (!skb->l4_hash && !skb->sw_hash)
                __skb_get_hash(skb);

        return skb->hash;
}

__skb_get_hash -> __skb_set_sw_hash -> __skb_set_hash which sets
sw_hash as a minimum, so it seems to me you will always be returning the
hash of the first packet since you do not clear relevant fields of the skb.
