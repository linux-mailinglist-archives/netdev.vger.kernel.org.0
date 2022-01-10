Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED15489F18
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 19:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239083AbiAJSU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 13:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239111AbiAJSU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 13:20:57 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A675C061759;
        Mon, 10 Jan 2022 10:20:51 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id d3so21108714lfv.13;
        Mon, 10 Jan 2022 10:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VeKeCgQSENYHroPqzqm4kB6VsmqqTQVr5ftkF3/8tYk=;
        b=QO4l1uyfq/4qP8Ty9JJqNNrNwdDqMtWPzo5j7jQzJQy1ZX2djOp0C6Gl3UcEG90p1z
         qlMjQHIR7sWbl5lqGeOKTKq0RZbS3hq2iU3AdXjIjTtHIIid5dYHoLN5Ryh6tK+3FBYs
         3k9AkUYsA0iJ1kvr3yrsukhWKIk1LqZfF/RmPpKidj/5HPT73W+j2YimWhugw2XX6yj3
         Hb9XJcX9Q90RSDUCVqfDg39nklqnhBALiLuIYaJnA0Eb2IGR/ANIgGAbRtLlRjOXd3Ib
         yUrUInmbDJt3sYp8qPtNovKQIGfeHUCj57QzVK1Vkg/PpEqylAaJzgYM4Jib8SAy8QcS
         xszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VeKeCgQSENYHroPqzqm4kB6VsmqqTQVr5ftkF3/8tYk=;
        b=z8jKNLzFeQDMv2s09pRWkv2Ae2T//5uMBHje74CqEFdD2ehU/oomIPBchbUGlfHrYh
         NBz6/3Xn9hAyKJnyKU99BGx9S4njKNpMui5ylodbUhOlZPoSYaBlBmsvD8+8uzVPtpEh
         yM/WNUS4eQixt+IqNzIFzDYt4tBAKy1fEdign3jgGIePw1x0Y5KLWCv666cd7pArSBxx
         MHwS5UFRB4KXxV9c6sGHnJAkQ36ZgMChUVhIYlq8lBDtZ7vLtFIv2ifAKIjA+AIZ3LqV
         esxOcE2N73eV9b8d3GsnhYHfvwcb4URIrWiZTBZSgfReYWM7r7arbjQdwK2Ow8UgepNe
         JYPg==
X-Gm-Message-State: AOAM5315r/YJDqPHj9MNKKX2ktPvcpHzzQyWEBqduJO9GMutVThnmRjl
        Oy1OIeIjOGT8uFKj6okChjk0pXsV7cdvfQ==
X-Google-Smtp-Source: ABdhPJxoDHK7yCpUTNLVFz+Q81SpId9sEJYf/KHhl9Y8m/wjg5KOLY5QsXOPGy3R/atsEsKO/Orf6Q==
X-Received: by 2002:a05:6512:3bc:: with SMTP id v28mr669104lfp.576.1641838849392;
        Mon, 10 Jan 2022 10:20:49 -0800 (PST)
Received: from [192.168.8.103] (m91-129-111-207.cust.tele2.ee. [91.129.111.207])
        by smtp.gmail.com with ESMTPSA id v11sm517295lfg.57.2022.01.10.10.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 10:20:48 -0800 (PST)
Message-ID: <077d6843-bf14-f528-d9cd-9c5245687be5@gmail.com>
Date:   Mon, 10 Jan 2022 20:20:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next 19/32] netfilter: nft_connlimit: move stateful
 fields out of expression data
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
References: <20220109231640.104123-1-pablo@netfilter.org>
 <20220109231640.104123-20-pablo@netfilter.org>
From:   Julian Wiedmann <jwiedmann.dev@gmail.com>
In-Reply-To: <20220109231640.104123-20-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.01.22 01:16, Pablo Neira Ayuso wrote:
> In preparation for the rule blob representation.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_connlimit.c | 26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
> index 7d0761fad37e..58dcafe8bf79 100644
> --- a/net/netfilter/nft_connlimit.c
> +++ b/net/netfilter/nft_connlimit.c

[...]

>  
>  static int nft_connlimit_do_dump(struct sk_buff *skb,
> @@ -200,7 +205,11 @@ static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
>  	struct nft_connlimit *priv_dst = nft_expr_priv(dst);
>  	struct nft_connlimit *priv_src = nft_expr_priv(src);
>  
> -	nf_conncount_list_init(&priv_dst->list);
> +	priv_dst->list = kmalloc(sizeof(*priv_dst->list), GFP_ATOMIC);
> +	if (priv_dst->list)
> +		return -ENOMEM;
> +
> +	nf_conncount_list_init(priv_dst->list);
>  	priv_dst->limit	 = priv_src->limit;
>  	priv_dst->invert = priv_src->invert;
>  

Hi Pablo,

Coverity (CID 1510697) spotted a typo in this NULL check, it should be

	if (!priv_dst->list)
		return -ENOMEM;


Looks like the following patches also have this bug.
