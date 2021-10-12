Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE7242A739
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhJLOdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237332AbhJLOdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:33:38 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CEEC061749;
        Tue, 12 Oct 2021 07:31:36 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id w12-20020a056830410c00b0054e7ceecd88so8247301ott.2;
        Tue, 12 Oct 2021 07:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ntByl3yL69ayPFySEWGhMVyiDKp3/n8OkE5ZPob4QtE=;
        b=SFdQMwQheTlmzkvFp16aq9jcsFK6arQ7CbyLFsIQ2S+nyiHE2Nnlafd2/T/94M/u1X
         /PnR9RK3/rdx//VKs1WLt1cci8jTNcjfOAouZDHOh23d+X84ugTPatrXU7dy4kM247M4
         GLBAPUAzbDYPvNtqUmDNVl9Zzs0BDI+7bsLNa+URSdborTefgdsOOhC5rnPKYBg1ldaw
         yoZvm1phfsjmhLtrJV6ZLJe8NrfYdcBjhxKAGjrAtcTT737E+a4y6dsUlcIp25hrUlz/
         WIXLio9INs3pOqQ5AXcaHT4XTYjBedLC7QIHi1xU7AKPBLJ4sk62jaPb0mOUWbj48LRd
         89sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ntByl3yL69ayPFySEWGhMVyiDKp3/n8OkE5ZPob4QtE=;
        b=mNCnnckWndtDEKZZ6njhIYhXuEVtsZ46rha1bhtA2SGu+aG77y26sUXVxjW+zMpNAj
         7KAM3SfBJMjyitaWptuTAPbRvyrD15ZmvhsbHTZ6rjWke6qL+tdLV2n8uu53bPqe30DF
         Xj+r5glgNvlz/O6Pf6eAUqrM1W2pxyvWuNCHl/6WYxa+f4NVU7FoL8rP+1Kyy8NkAZ+U
         gJRicQ7zc63cPZJuNpZATF+YG8lPQiloLZWZ3yHumAZ5H1TUqpIaeFaWqZTXoq8i5uZG
         rupHPbKFKV/kA5m+mY7RKK8TCPZUQjjBXqh90kjOWU+a+/Rbc/08FCCYbd0iJ9EJhdMJ
         ZyXg==
X-Gm-Message-State: AOAM532Ezrd1MrYMWwFXi8dr5EJneMCBF9WSS90CLmgU2UFP9FHRWjrx
        zgKK1jnTg/3b4QhMiOKxAMzZQ8NQwtE+Jw==
X-Google-Smtp-Source: ABdhPJxVtF1K0Pv4OBXkkKYApOesdVV+kB/7x7UI3sIgBYQHBd9c8HNSA4B9SbOGTLjEOqVEPpmnsw==
X-Received: by 2002:a05:6830:2424:: with SMTP id k4mr22441291ots.210.1634049095832;
        Tue, 12 Oct 2021 07:31:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id q133sm2319537oia.55.2021.10.12.07.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 07:31:35 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net, neigh: Extend neigh->flags to 32 bit to
 allow for extensions
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-4-daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <018673d2-6745-47ef-6586-53ddf8aed9b2@gmail.com>
Date:   Tue, 12 Oct 2021 08:31:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211011121238.25542-4-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/21 6:12 AM, Daniel Borkmann wrote:
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index eb2a7c03a5b0..26d4ada0aea9 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -144,11 +144,11 @@ struct neighbour {
>  	struct timer_list	timer;
>  	unsigned long		used;
>  	atomic_t		probes;
> -	__u8			flags;
> -	__u8			nud_state;
> -	__u8			type;
> -	__u8			dead;
> +	u8			nud_state;
> +	u8			type;
> +	u8			dead;
>  	u8			protocol;
> +	u32			flags;
>  	seqlock_t		ha_lock;
>  	unsigned char		ha[ALIGN(MAX_ADDR_LEN, sizeof(unsigned long))] __aligned(8);
>  	struct hh_cache		hh;
> @@ -172,7 +172,7 @@ struct pneigh_entry {
>  	struct pneigh_entry	*next;
>  	possible_net_t		net;
>  	struct net_device	*dev;
> -	u8			flags;
> +	u32			flags;
>  	u8			protocol;
>  	u8			key[];
>  };
> @@ -258,6 +258,10 @@ static inline void *neighbour_priv(const struct neighbour *n)
>  #define NEIGH_UPDATE_F_ISROUTER			0x40000000
>  #define NEIGH_UPDATE_F_ADMIN			0x80000000
>  
> +/* In-kernel representation for NDA_FLAGS_EXT flags: */
> +#define NTF_OLD_MASK		0xff
> +#define NTF_EXT_SHIFT		8

so only 24 EXT flags can be added. That should be documented; far off
today, but that's an easy overflow to miss.

Reviewed-by: David Ahern <dsahern@kernel.org>


