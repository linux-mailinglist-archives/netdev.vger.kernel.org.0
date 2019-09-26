Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4656EBF787
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 19:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfIZRYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 13:24:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44307 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbfIZRYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 13:24:40 -0400
Received: by mail-pl1-f193.google.com with SMTP id q15so1321135pll.11
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 10:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JO1szATWTVq6P9jByV19nI8Azzc/AOfERPTUa2HW7h8=;
        b=TN4mLTdKOigcC2W4r+0p2bV5BNegu7A7meKCqiMIqiMfi4xf15MCrhEFsFqpoIjU6a
         PAtrsdvQmMAYsmwbf2ANmPpSPI+jQJArt+1uzEoHEdDR9Dq8+jJnb+d0HX33n+QGtJJf
         9SxJVlJcBOxXN1co3YTvNm2x+bY54Cekw9FvGR4afVYKenz1aMPvYOE0E8DNLeO9i0O2
         hM3jY/0SO+pRtEo0i3J3GQizCfuLIhOuIJYkgjN16eNH8g2GQtLRMTarlCmnyf7/DWir
         GZLbrPLjbEJOfr3RffJ0Qk6cYTkr8S0bSuoHvpi5On7D3aHgIUP4CRZSvM9l/9LdQb9N
         +H/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JO1szATWTVq6P9jByV19nI8Azzc/AOfERPTUa2HW7h8=;
        b=n5SxcU89c4LtpEfIqaabmHTrx+5sTONjS47daaKExYo4nkzALLluYR/ZPbwCclOgRM
         yO2cz88r61WIZo2Yvb5L7dQeHZRSRo4mR2QtZY7gRB3p+a6+5oF+dTxGPb21PcFHMhGv
         K3RE5bTHGYmtelxExTeriHgSZmdYu4ocu7UETx0Jyv3VQylGrRzeNQU3vS1H5+xz9qC6
         5E+XZQtqFBjCXTtnGV0PQsIsKQQXgN6w6Ow1rYbPyE74eXzM5VyoRY3qzAtvZJOfffvr
         bVUYrQsgZkN6C5UbrEn4YkehbQg0sjN0zsU8nPX7fFFTVjWAs+iqOTe0Kib+n2q9EZjY
         9P/A==
X-Gm-Message-State: APjAAAXGS11Wyo3gXIyDLVZZtxjAgyZOlInPyI9uKEIfaY4lM7W1Alg3
        A5Z4vAzdtU6SyGlzS192/PY=
X-Google-Smtp-Source: APXvYqwFo3lGV1dc53G+wF6SNm7L0485ZwWVo1jbV1c8ZjImHXqgbdDAGkXBa9jkAkyqKKcYWME0Ag==
X-Received: by 2002:a17:902:7001:: with SMTP id y1mr4966493plk.49.1569518679665;
        Thu, 26 Sep 2019 10:24:39 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id 18sm3066328pfp.100.2019.09.26.10.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 10:24:38 -0700 (PDT)
Subject: Re: [PATCH net] sk_buff: drop all skb extensions on free and skb
 scrubbing
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, paulb@mellanox.com,
        vladbu@mellanox.com
References: <20190926141840.31952-1-fw@strlen.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <76c10ba7-5fc8-e9e8-769f-fc4d5cada7a2@gmail.com>
Date:   Thu, 26 Sep 2019 10:24:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190926141840.31952-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/26/19 7:18 AM, Florian Westphal wrote:
> Now that we have a 3rd extension, add a new helper that drops the
> extension space and use it when we need to scrub an sk_buff.
> 
> At this time, scrubbing clears secpath and bridge netfilter data, but
> retains the tc skb extension, after this patch all three get cleared.
> 
> NAPI reuse/free assumes we can only have a secpath attached to skb, but
> it seems better to clear all extensions there as well.
> 
> Fixes: 95a7233c452a ("net: openvswitch: Set OvS recirc_id from tc chain index")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/skbuff.h | 9 +++++++++
>  net/core/dev.c         | 4 ++--
>  net/core/skbuff.c      | 2 +-
>  3 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 907209c0794e..4debdd58a0ce 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4144,8 +4144,17 @@ static inline void *skb_ext_find(const struct sk_buff *skb, enum skb_ext_id id)
>  
>  	return NULL;
>  }
> +
> +static inline void skb_ext_reset(struct sk_buff *skb)
> +{
> +	if (skb->active_extensions) {

This deserves an unlikely(skb->active_extensions) hint here ?

> +		__skb_ext_put(skb->extensions);
> +		skb->active_extensions = 0;
> +	}
> +}
>  #else
>  static inline void skb_ext_put(struct sk_buff *skb) {}
> +static inline void skb_ext_reset(struct sk_buff *skb) {}
>  static inline void skb_ext_del(struct sk_buff *skb, int unused) {}
>  static inline void __skb_ext_copy(struct sk_buff *d, const struct sk_buff *s) {}
>  static inline void skb_ext_copy(struct sk_buff *dst, const struct sk_buff *s) {}
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 71b18e80389f..bf3ed413abaf 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5666,7 +5666,7 @@ EXPORT_SYMBOL(gro_find_complete_by_type);
>  static void napi_skb_free_stolen_head(struct sk_buff *skb)
>  {
>  	skb_dst_drop(skb);
> -	secpath_reset(skb);
> +	skb_ext_put(skb);
>  	kmem_cache_free(skbuff_head_cache, skb);
>  }
>  
> @@ -5733,7 +5733,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
>  	skb->encapsulation = 0;
>  	skb_shinfo(skb)->gso_type = 0;
>  	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
> -	secpath_reset(skb);
> +	skb_ext_reset(skb);
>  
>  	napi->skb = skb;
>  }
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f12e8a050edb..01d65206f4fb 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5119,7 +5119,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
>  	skb->skb_iif = 0;
>  	skb->ignore_df = 0;
>  	skb_dst_drop(skb);
> -	secpath_reset(skb);
> +	skb_ext_reset(skb);
>  	nf_reset(skb);
>  	nf_reset_trace(skb);
>  
> 
