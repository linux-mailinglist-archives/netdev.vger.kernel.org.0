Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB51042D1B3
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 06:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhJNEpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 00:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhJNEpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 00:45:46 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2218C061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 21:43:42 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id i76so2242556pfe.13
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 21:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fxm8p9QcGGUtD4jyojlCu0v8CZVZbq2X19K5mqmVtNw=;
        b=IXACT6YQpEkbuzbcNZQTcmoDxBCGiUSWAuB+3WVNjM08XyiQZhtpkgJqxpwwJdwP4m
         piIHB0IMuh/rK2Snug+0PODBG3mHq4SwDfJMNqPB4AE8utonpHm4oFM7Ktl0MK2NEoy0
         8qXx+/f68TCcJrE3Hx2LxIGUrlYpiUCr0wbJdM7x5SQkiZ1c2/liFEf9t6k2FmGmiHHn
         xZYcD6pQbSrn7HUkbFTmCor+OlSQBNf6siI3l8r4mmB5q/mensmpGRvwd8JE2fSm7YRf
         QKFEhUenYlZkqUQ5eBebXLemXC5iaOBhe4bBbIzuhDufrRKMH6OraQ+7KJ5N/9PXIUkG
         U9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fxm8p9QcGGUtD4jyojlCu0v8CZVZbq2X19K5mqmVtNw=;
        b=eIyph3T4SsJmW6j0Yvx8O9/9W7lkvD4uT5QKpttAdDfT+aDbeeEDvzqL6YuGYkvadU
         ykHM65afkv1u01OC99kJH7tsBFrXOtrNjGkZAzm3k1ZFtVDScM2GUNoj3tI1x3pTGpQ6
         7X+XbcSHHfWkfJJ0nrCV659yKXoAIqvgz+hMFCl9JJ2hfopJENCcyMQFOAovYendAHZ7
         fAiTd1PWRJzB0suje09Ags6eft/PheYPxazusqXNbuOy5MsuTjab8TKfYQCTmsUKWZxY
         Ikrj6gsCyfZv36PA/IKgcxLghVwQjCGJDIxbZYgR/MI5A3qvLynxh+ZMGEq1HnJKz7BF
         oU0g==
X-Gm-Message-State: AOAM5302vzK1MFYkU1GkGKXFXriJPpe5FhD83dpXAEuQLvv9nRVs8cKH
        /mnlxNM5uQjpahy7OZbQuCzRcEskNZs=
X-Google-Smtp-Source: ABdhPJyJzMtNLvGxDTwe1oGVOKOo+Cw4scRdElRind2CUy78N7ERlPHiTodIX/PStyy72inYe9u/Pw==
X-Received: by 2002:a63:d94b:: with SMTP id e11mr2569138pgj.295.1634186622016;
        Wed, 13 Oct 2021 21:43:42 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e8sm1059073pfn.45.2021.10.13.21.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 21:43:41 -0700 (PDT)
Subject: Re: [PATCHv2 net] icmp: fix icmp_ext_echo_iio parsing in
 icmp_build_probe
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
References: <345b3f75bea482f7b3174297261db24cdf7e15e1.1634185497.git.lucien.xin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <46778adf-6a5c-17cd-94fd-285d954e8392@gmail.com>
Date:   Wed, 13 Oct 2021 21:43:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <345b3f75bea482f7b3174297261db24cdf7e15e1.1634185497.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/21 9:24 PM, Xin Long wrote:
> In icmp_build_probe(), the icmp_ext_echo_iio parsing should be done
> step by step and skb_header_pointer() return value should always be
> checked, this patch fixes 3 places in there:
> 
>   - On case ICMP_EXT_ECHO_CTYPE_NAME, it should only copy ident.name
>     from skb by skb_header_pointer(), its len is ident_len. Besides,
>     the return value of skb_header_pointer() should always be checked.
> 
>   - On case ICMP_EXT_ECHO_CTYPE_INDEX, move ident_len check ahead of
>     skb_header_pointer(), and also do the return value check for
>     skb_header_pointer().
> 
>   - On case ICMP_EXT_ECHO_CTYPE_ADDR, before accessing iio->ident.addr.
>     ctype3_hdr.addrlen, skb_header_pointer() should be called first,
>     then check its return value and ident_len.
>     On subcases ICMP_AFI_IP and ICMP_AFI_IP6, also do check for ident.
>     addr.ctype3_hdr.addrlen and skb_header_pointer()'s return value.
>     On subcase ICMP_AFI_IP, the len for skb_header_pointer() should be
>     "sizeof(iio->extobj_hdr) + sizeof(iio->ident.addr.ctype3_hdr) +
>     sizeof(struct in_addr)" or "ident_len".
> 
> v1->v2:
>   - To make it more clear, call skb_header_pointer() once only for
>     iio->indent's parsing as Jakub Suggested.
> 
> Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ipv4/icmp.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 8b30cadff708..bccb2132a464 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -1057,11 +1057,15 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
>  	if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
>  		goto send_mal_query;
>  	ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
> +	iio = skb_header_pointer(skb, sizeof(_ext_hdr),
> +				 sizeof(iio->extobj_hdr) + ident_len, &_iio);

??? How has this been tested ???

If you pass &_iio for last argument, then you _must_ use sizeof(__iio) (or smaller) too for third argument,
or risk stack overflow, in the case page frag bytes need to be copied into _iio

If the remote peer cooks a malicious packet so that ident_len is big like 1200,
then for sure the kernel will crash,
because sizeof(iio->extobj_hdr) + ident_len will be bigger than sizeof(_iio)


> +	if (!iio)
> +		goto send_mal_query;
> +
>  	status = 0;
>  	dev = NULL;
>  	switch (iio->extobj_hdr.class_type) {
