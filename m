Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED94B49C11D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 03:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbiAZCST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 21:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236206AbiAZCSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 21:18:18 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA2AC061747;
        Tue, 25 Jan 2022 18:18:18 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id x52-20020a05683040b400b0059ea92202daso12344032ott.7;
        Tue, 25 Jan 2022 18:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=z32uZyvOYuzf5afvLBijV3xi40g9PYvi2kcQNtZvyA0=;
        b=Oa5yRHaTo6B+o/mFxFov/dGYf4WNcChdyTIONo2fqg6yj3khimgAkqIwUQuGnVRqU/
         Nlzk20FTxQBzqua10X2Kuu1T817mCHYivTvsHXH3G1+Ep1N771CPahS8TQFng+8Y9gvZ
         tO29rIhdzgUlSMcmoYgXz9AXDoqo+9zrCk3Vqnn8o9dog/ynpodKfHiyKwusTj05zW3y
         LkJ/a6KsdfbM90ONRVJhjhZEDZXr20wEzPNDynGxaqLIOUsN4sgYH6jxlwKpq9uh1mQT
         RCFgFRWBwi7uGPfGFD5OF7zpvlGKydnMnvx9cU308K0/KD0ugoyzZqQuo3YcwAR2pslA
         NBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z32uZyvOYuzf5afvLBijV3xi40g9PYvi2kcQNtZvyA0=;
        b=dVnaCcBFgAvLAqYPHpnV8B2zcP5vN4J+RlKQcW7sgSFiK3BW66sCnoB6xAedYyRkHT
         U6OvEtDM4CGzo+9riHRAUz1DvmCzMVFmsyZuCJOeJujIbGPrCp6eH7AL1ShQyxbhsIu2
         XlxS5MlM1//gFjy3+iQbeKzZ/2UUSLgvNbGTpLe9yYmRhnupFb2e1X0LundsCg8tvNGq
         k0j7OvreqDuF3V4eHmJP96/TX/jimkN64VegaCcT0lEtWQ0vUwjvXbg45bQaCW5VLCoy
         P/XKLBPTXO7BQTZF34CpvjORfvic/NcClHafwUxr61bVKUKul5S4Ne9jUj7RWqXQiPyv
         4cIQ==
X-Gm-Message-State: AOAM532XIiaF8jKHiq0gE3CNS3gEIhYju4k109eyTDFWJnx7sHXM34IO
        jHyAXBOEhaJ7RneLFbUhKqk=
X-Google-Smtp-Source: ABdhPJy3NJiFNhXbBCK+BfS0lNY7C8hzWxAugXAqpr6XaK2w19flLDXoe+Uilaw0HqW7XM6WLGdP/w==
X-Received: by 2002:a9d:281:: with SMTP id 1mr5902753otl.187.1643163497853;
        Tue, 25 Jan 2022 18:18:17 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id s3sm4232061otg.67.2022.01.25.18.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 18:18:17 -0800 (PST)
Message-ID: <5201dd8b-e84c-89a0-568f-47a2211b88cb@gmail.com>
Date:   Tue, 25 Jan 2022 19:18:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 3/6] net: ipv4: use kfree_skb_reason() in
 ip_rcv_finish_core()
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, paulb@nvidia.com,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        keescook@chromium.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-4-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220124131538.1453657-4-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/22 6:15 AM, menglong8.dong@gmail.com wrote:
> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index ab9bee4bbf0a..77bb9ddc441b 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -318,8 +318,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
>  {
>  	const struct iphdr *iph = ip_hdr(skb);
>  	int (*edemux)(struct sk_buff *skb);
> +	int err, drop_reason;
>  	struct rtable *rt;
> -	int err;
> +
> +	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
>  
>  	if (ip_can_use_hint(skb, iph, hint)) {
>  		err = ip_route_use_hint(skb, iph->daddr, iph->saddr, iph->tos,
> @@ -339,8 +341,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
>  		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
>  			err = INDIRECT_CALL_2(edemux, tcp_v4_early_demux,
>  					      udp_v4_early_demux, skb);
> -			if (unlikely(err))
> +			if (unlikely(err)) {
> +				drop_reason = SKB_DROP_REASON_EARLY_DEMUX;

is there really value in this one? You ignore the error case from
ip_route_use_hint which is a similar, highly unlikely error path so why
care about this one? The only failure case is ip_mc_validate_source from
udp_v4_early_demux and 'early demux' drops really mean nothing to the user.


>  				goto drop_error;
> +			}
>  			/* must reload iph, skb->head might have changed */
>  			iph = ip_hdr(skb);
>  		}
> @@ -353,8 +357,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
>  	if (!skb_valid_dst(skb)) {
>  		err = ip_route_input_noref(skb, iph->daddr, iph->saddr,
>  					   iph->tos, dev);
> -		if (unlikely(err))
> +		if (unlikely(err)) {
> +			drop_reason = SKB_DROP_REASON_IP_ROUTE_INPUT;

The reason codes should be meaningful to users and not derived from a
code path. What does SKB_DROP_REASON_IP_ROUTE_INPUT mean as a failure?


>  			goto drop_error;
> +		}
>  	}
>  
>  #ifdef CONFIG_IP_ROUTE_CLASSID
