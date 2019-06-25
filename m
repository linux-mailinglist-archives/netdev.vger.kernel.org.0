Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FFE55818
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfFYTrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:47:20 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40790 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfFYTrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:47:20 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so61085wmj.5
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 12:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=N3sY+fRZCTLKpuSsQf2h7bzl/M1SsrL0vN2rwYA+rW0=;
        b=KinjB5wqzwM75GOVGgKLJPtCRZ3TBATF0eUu9hIExcegai5XQwguncHxspiMez0CrZ
         EQaFn9kwz2ejldDYYk/38w6zWNTZ3giDjwS5GneltTDK0EHNOrTWZCgY5VRb/QHeoLrA
         knSZf/Q/NlobekW4jzErv0Sctq5d28Kn8Q60Mx7kwdxVpPsVDbJRshJgZLDL+RXj3XgP
         DoYDnDbFzVfv4GI3f/wE7RcfUEWzwemmGzR2D3rvCazgKvMjVhSwZR+G9T+vPRlOgKdH
         N23cYRgz+TVcGGvf7B+kd20MouJnEes2h84Ob4b2vMxnGg97CT7emhEekhN/UcanCR3I
         yzww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N3sY+fRZCTLKpuSsQf2h7bzl/M1SsrL0vN2rwYA+rW0=;
        b=W8gXvlRARfWvyrODLcTKr9GuPgk9vrT07PJe1lYD+YnOJEVu2GN3hdT9f6eISzl9jt
         +XMI0HKs75AZ6uA8DXW8bk5I+qWnLjzJaDe/sQtO4dVQfWv5ivlN6go2agkjrucIWHIB
         3DkkiKMPTN+p5BNe9EU+K5nCgBGOMu9T9+0VPx5UwaQGpG9svSAjqiwLLEHKtodx7BBi
         Q8L3upIddFONPpmId1TUsv63oexSu32VszQbV6FDXCDeyLMAFcaq4ADrpaes+miBfr5S
         XLt1hSKzrbX0lY1sdU8xCZu61esN/y4ZZDx8bOA9J3Tzgv2whr5kKQeYuPHKbm4p/QNW
         3Lxg==
X-Gm-Message-State: APjAAAUDI/1GpJursxG6dYCXuweHBn29X6uD5jW8S1UeXzDEZA2/c3Lq
        +vWRmtw3FRPKEKPHEnb/gmjd7T3u
X-Google-Smtp-Source: APXvYqyThPXtGWNZls+d65BAIvzHEYFQCiz987oXDblSL2OjP/3NSqYxbCTAhUxgU7LH78pK1xA0/w==
X-Received: by 2002:a1c:1d83:: with SMTP id d125mr96695wmd.63.1561492038221;
        Tue, 25 Jun 2019 12:47:18 -0700 (PDT)
Received: from [192.168.8.147] (104.84.136.77.rev.sfr.net. [77.136.84.104])
        by smtp.gmail.com with ESMTPSA id b9sm12426253wrm.11.2019.06.25.12.47.17
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 12:47:17 -0700 (PDT)
Subject: Re: [PATCH net] net: make skb_dst_force return false when dst was
 cleared
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
References: <20190625192209.6250-1-fw@strlen.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8483d4dc-1ef6-20b5-735f-8d78da579a28@gmail.com>
Date:   Tue, 25 Jun 2019 21:47:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625192209.6250-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/19 12:22 PM, Florian Westphal wrote:
> XFRM and netfilter don't expect that skb_dst_force() can cause skb to lose
> its dst entry.
> 
> I got a bug report with a skb->dst NULL dereference in netfilter
> output path.  The backtrace contains nf_reinject(), so the dst
> might have been cleared when skb got queued to userspace.
> 
> The xfrm part of this change was done after code inspection,
> it looks like similar crash could happen here too.
> 
> One way to fix this is to add a skb_dst() check right after
> skb_dst_force() call, but I think its preferable to make the
> 'dst might get cleared' part of the function explicit.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/dst.h        | 6 +++++-
>  net/netfilter/nf_queue.c | 6 +++++-
>  net/xfrm/xfrm_policy.c   | 5 ++++-
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/dst.h b/include/net/dst.h
> index 12b31c602cb0..42cd53d51364 100644
> --- a/include/net/dst.h
> +++ b/include/net/dst.h
> @@ -302,8 +302,9 @@ static inline bool dst_hold_safe(struct dst_entry *dst)
>   * @skb: buffer
>   *
>   * If dst is not yet refcounted and not destroyed, grab a ref on it.
> + * Returns false if skb had a destroyed dst.

>   */
> -static inline void skb_dst_force(struct sk_buff *skb)
> +static inline bool skb_dst_force(struct sk_buff *skb)
>  {
>  	if (skb_dst_is_noref(skb)) {
>  		struct dst_entry *dst = skb_dst(skb);
> @@ -313,7 +314,10 @@ static inline void skb_dst_force(struct sk_buff *skb)
>  			dst = NULL;
>  
>  		skb->_skb_refdst = (unsigned long)dst;
> +		return dst != NULL;
>  	}
> +
> +	return true;

This will return true, even if skb has a NULL dst.

Say if we have two skb_dst_force() calls for some reason
on the same skb, only the first one will return false.

