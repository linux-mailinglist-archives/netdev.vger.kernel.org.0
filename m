Return-Path: <netdev+bounces-2682-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7AE703198
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:32:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57DA21C20BE7
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD193DF4C;
	Mon, 15 May 2023 15:32:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08EAC8E5
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 15:32:15 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D0F13A;
	Mon, 15 May 2023 08:32:14 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50db7f0a1b4so11812761a12.3;
        Mon, 15 May 2023 08:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684164732; x=1686756732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p/xJaRrGicp79wX9w9s9DfNXJxYDEt3Qvdi5M9U6HGU=;
        b=A0r68nB4CFAXaCaBrrDvie+gu4E0bgetGWIyATwxN2q6MNsJgsiIkuPEJShGRlQ3ZZ
         citozDCtZk7/trAPGSdloPOgzs7uwokSwh4i9GkQfFor7zMQb7Pz8UOQYCKF7rKbHp0m
         2lNjqmbFHAEsAfsREuQ9FkTpeQZ2yWmLyQqLWXoRvnlGKKhB1AkLbpUb0Sdwz+ec4hlA
         D/IPRaXwDNkQV/p2cOcTNdrHkKWlrUgKU+h4ocQBbzv2+wHlJfLMaVI7wxDN1TnV6QKL
         Z3wF5/xnmpI4Q4C/nRqP2umbUdB+vC151BwBBWRxpSOBJXT8ikNCIvh+sPQ/IKDM7/Ry
         eI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684164732; x=1686756732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p/xJaRrGicp79wX9w9s9DfNXJxYDEt3Qvdi5M9U6HGU=;
        b=DcuMAPzXkkyXUwxfDAp68YHM9ZFEkdB2lszX0E+14j00OFFJcMsxbdL1zFcOJVeiGJ
         2bbXsXC/Xia8GhALPwYJ8VW33R6XF+S59ntusdRwDWnjJG903G6/tpem1nJPOASVQA3c
         tdE/5uHlj4F5fhm+XxvBSpSLi22l8M3R5AHQEB88iJEoN/T7hj0p7YBWOqPPbyyH8maj
         Uzn4N2IYZaH+odzclfhOTXjxZ9MR6d+6SvSfdO5HWdEFH8eR/+/TIt8R7pFzBZfsIXNm
         KVkB79vOBwH1DhlKS9YrHcqL3xUsxkHjYsDtRvOVkoSfnYX74DJqMWCNSBCBc8bdHLMj
         vBuA==
X-Gm-Message-State: AC+VfDwxGQpIUl7bPcRWqX0azH1NPy/PmcQnTDVL2XEoghFLoFXIEAY8
	OPa8qpifpG1U92CkE8U/0a0=
X-Google-Smtp-Source: ACHHUZ5qkoBH0ut0vUGQgdHs8biS9Z/+zCmWLhGEkvep7Pj1fXfh+WaLm/hgjr4/XvaerXm47mE+oQ==
X-Received: by 2002:a17:907:a0c:b0:962:582d:89c8 with SMTP id bb12-20020a1709070a0c00b00962582d89c8mr32443545ejc.45.1684164732287;
        Mon, 15 May 2023 08:32:12 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:6366])
        by smtp.gmail.com with ESMTPSA id ig13-20020a1709072e0d00b0096623c00727sm9742390ejc.136.2023.05.15.08.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 08:32:12 -0700 (PDT)
Message-ID: <994ac583-ea4f-2dca-45df-a76d4957b2b2@gmail.com>
Date: Mon, 15 May 2023 16:31:13 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] net: skbuff: update comment about pfmemalloc
 propagating
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230515050107.46397-1-linyunsheng@huawei.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230515050107.46397-1-linyunsheng@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/15/23 06:01, Yunsheng Lin wrote:
> __skb_fill_page_desc_noacc() is not doing any pfmemalloc
> propagating, and yet it has a comment about that, commit
> 84ce071e38a6 ("net: introduce __skb_fill_page_desc_noacc")
> may have accidentally moved it to __skb_fill_page_desc_noacc(),
> so move it back to __skb_fill_page_desc() which is supposed
> to be doing pfmemalloc propagating.

Looks good,

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> CC: Pavel Begunkov <asml.silence@gmail.com>
> ---
> Also maybe we need a better name for 'noacc' or add some
> comment about that, as 'noacc' seems a little confusing
> for __skb_fill_page_desc_noacc().

It's a known pattern bur in block/ and should be "noacct",
but yeah, it can be more specific.

> ---
>   include/linux/skbuff.h | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 00e8c435fa1a..4b8d55247198 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2426,11 +2426,6 @@ static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
>   {
>   	skb_frag_t *frag = &shinfo->frags[i];
>   
> -	/*
> -	 * Propagate page pfmemalloc to the skb if we can. The problem is
> -	 * that not all callers have unique ownership of the page but rely
> -	 * on page_is_pfmemalloc doing the right thing(tm).
> -	 */
>   	skb_frag_fill_page_desc(frag, page, off, size);
>   }
>   
> @@ -2463,6 +2458,11 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
>   					struct page *page, int off, int size)
>   {
>   	__skb_fill_page_desc_noacc(skb_shinfo(skb), i, page, off, size);
> +
> +	/* Propagate page pfmemalloc to the skb if we can. The problem is
> +	 * that not all callers have unique ownership of the page but rely
> +	 * on page_is_pfmemalloc doing the right thing(tm).
> +	 */
>   	page = compound_head(page);
>   	if (page_is_pfmemalloc(page))
>   		skb->pfmemalloc	= true;

-- 
Pavel Begunkov

