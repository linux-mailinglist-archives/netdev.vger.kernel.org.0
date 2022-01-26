Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29FB49C10A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 03:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbiAZCKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 21:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiAZCKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 21:10:45 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D13C06161C;
        Tue, 25 Jan 2022 18:10:45 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id e79so25971290iof.13;
        Tue, 25 Jan 2022 18:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0H9aOk8QYoiNSHNr3RfzkCP3wW9BTsxs9UCx1zYQcCY=;
        b=BS9htBOBXR7UCNQZ6l6e/ME0oV3SbLxazRfCdy0Dlw9n09qPf+h2QFaqJdv4U+XgEk
         k6R5Y3ZWMQ5W9JcAQmkFC0AbG+sw7pTEHh3Zs4LbEBpBJnQ+3pdCPipAIClWH9siak7J
         /gxbSEbcrLB7u5pcGnGjlrpPr1GiYO6fVRv7f06P1yEmT3qNnmRqMQleSCJnmHy3rY0k
         CHKmPf0K3mZA5uc0Pd2h7i/3Bz0Hrfe0ta+kf2SYXVT3wh9l+8n3NxFJ2kfxxEKOcCFL
         gbq1t/bsTpSQt3gDNuYQxvMKnDEeyfWbAF/kxvEvthS49mOv/k6RvlIzwO5UOZUNr6fc
         0BTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0H9aOk8QYoiNSHNr3RfzkCP3wW9BTsxs9UCx1zYQcCY=;
        b=PQD5giH97eAZwC6fZq6iuKAMNPBhk2Aq7ZFXeVUs8sbwVqc0r5bYiiooDfNcAIpo2G
         BLrg5ndE/z2PlzAA4TUM2JIp32YsF1b7bJsLAs+PLy/kTX+cUYG7Iqkl4outRsOQSH9C
         tnte6Gcn4kx8pZhzjQUG0evMKWvRytWNHuWbaUproKaJezfyfKE+wCinTtW2wautl/cu
         k+wvohR4NDIqGdi7XAv69Z7VrWdNgLM+QItyXmSDlu5GWVqwhrFCEHCaXQvoomLKM+4v
         UobLAm+yQZIcB4BfANzKM6KrX/jQHF5MFRp3XCzP9/xmEPMgK4Sj72kZez8r++YEVICD
         VJ/A==
X-Gm-Message-State: AOAM531ZNr+h26CBedMgXv33H9eV/OSZ/o1YZCk8SHNjSiZuhmpcZf9H
        0w+tgcZdf2JmmD7M3E9CUbQ=
X-Google-Smtp-Source: ABdhPJynpBuSEXNxaL55RYds4r+FvCet3RP1B6slwXEKbiSvQ6QRiewXH7BLxLm8T6UFKpcQlFuWPA==
X-Received: by 2002:a02:a155:: with SMTP id m21mr9864184jah.0.1643163045006;
        Tue, 25 Jan 2022 18:10:45 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id f13sm8666626ion.18.2022.01.25.18.10.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 18:10:44 -0800 (PST)
Message-ID: <b7834377-eb0f-f5df-f3b6-10525de7afca@gmail.com>
Date:   Tue, 25 Jan 2022 19:10:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 2/6] net: ipv4: use kfree_skb_reason() in
 ip_rcv_core()
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
 <20220124131538.1453657-3-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220124131538.1453657-3-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/22 6:15 AM, menglong8.dong@gmail.com wrote:
> @@ -478,7 +483,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
>  		       IPSTATS_MIB_NOECTPKTS + (iph->tos & INET_ECN_MASK),
>  		       max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));
>  
> -	if (!pskb_may_pull(skb, iph->ihl*4))
> +	if (!pskb_may_pull(skb, iph->ihl * 4))

unrelated cleanup

>  		goto inhdr_error;
>  
>  	iph = ip_hdr(skb);
> @@ -490,7 +495,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
>  	if (skb->len < len) {
>  		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
>  		goto drop;
> -	} else if (len < (iph->ihl*4))
> +	} else if (len < (iph->ihl * 4))

ditto

>  		goto inhdr_error;
>  
>  	/* Our transport medium may have padded the buffer out. Now we know it

