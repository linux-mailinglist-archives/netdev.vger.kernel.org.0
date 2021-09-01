Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2593FE2D6
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 21:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344484AbhIATSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 15:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhIATSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 15:18:31 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F46C061575;
        Wed,  1 Sep 2021 12:17:34 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e7so266094plh.8;
        Wed, 01 Sep 2021 12:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KOMwbR/9rrcQFWuafJynxLkaMDZnl4TQi3Qh9Kzxi28=;
        b=ZnsrP5zqcYlGL2y0fi6Bn9h5YuAFufMEtnfTzAQ/bV8vROK7S53bVfJ3mt4pjqWIat
         iK8OnHso/UQijBImKAdqOoGOgKZGXatXMvh7MVCmor8wIV19yaFduBMSW+8mXcPYfEUv
         TSIIklb/sUx1ZOEig06bbzHOiOZhxXl01qaUKGgKoOoOV8Cy72baI8sBGKTGLY+2DNW3
         0iHud9mQgSPLISrfw/pO9jnRV1L0/0yP5Ap1Jb8Vqi34f/zPxCpvHPnjhqMAU8X8EqHs
         8TZsu9/7UC1tRzfIwp4CLLUaAkwbc5VHu/qrETs8niLOj6pONsEZM0fwWySN9cd2njFp
         JXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KOMwbR/9rrcQFWuafJynxLkaMDZnl4TQi3Qh9Kzxi28=;
        b=GcF2RuspP1wHQ+kIWt1yOzNWxn7vMKcD8JsAejUi9pjXOt6ETHKItVh6yq1/Al4prP
         GJhxbgLmL5LGuPhZtYtO38wd3xHoi5aib1CYIcOZV7iazlU64YfomimilO5mVxqDgFB9
         gaOBWMMCLGLO8od4sB9lbvHmyTJlqk9HyKW/zmIQ9s4kfa/HpB9uh+/eS7GD2J0vqBQ4
         ne59ultL39IEVNtv6qn9agWsLvZN7nDG+esmPqz+vXBQSWXl/knWdYEmZQp3xry7/1Q0
         bhiIGm/uGuU+asxcDyApT2Pu1d3eexLiCKnYWJW2EMAOp4jNG4Imhm+xVqsSE3rVy1Kh
         V+Jg==
X-Gm-Message-State: AOAM532hJmVzZUIHvQT3eOc0ppeCpGjXIcglLeckQmz7hbEr5ZD7LT0R
        L4Du0KgL3hQe8tjoChBC1B3H3beZsc0=
X-Google-Smtp-Source: ABdhPJz0HwjPmf44/r/9IZfLVYKcG4OcxSen4253KY5NnsYS6xgz1Z7ZgjZvlPW2YaUdnTd8CCPAbA==
X-Received: by 2002:a17:902:bd42:b0:138:d3ca:c387 with SMTP id b2-20020a170902bd4200b00138d3cac387mr975254plx.51.1630523853615;
        Wed, 01 Sep 2021 12:17:33 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z131sm236830pfc.159.2021.09.01.12.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 12:17:33 -0700 (PDT)
Subject: Re: [PATCH net-next v4] skb_expand_head() adjust skb->truesize
 incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <b653692b-1550-e17a-6c51-894832c56065@virtuozzo.com>
 <ee5b763a-c39d-80fd-3dd4-bca159b5f5ac@virtuozzo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ce783b33-c81f-4760-1f9e-90b7d8c51fd7@gmail.com>
Date:   Wed, 1 Sep 2021 12:17:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ee5b763a-c39d-80fd-3dd4-bca159b5f5ac@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/21 1:11 AM, Vasily Averin wrote:
> Christoph Paasch reports [1] about incorrect skb->truesize
> after skb_expand_head() call in ip6_xmit.
> This may happen because of two reasons:
> - skb_set_owner_w() for newly cloned skb is called too early,
> before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
> - pskb_expand_head() does not adjust truesize in (skb->sk) case.
> In this case sk->sk_wmem_alloc should be adjusted too.
> 
> [1] https://lkml.org/lkml/2021/8/20/1082
> 
> Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")
> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
> v4: decided to use is_skb_wmem() after pskb_expand_head() call
>     fixed 'return (EXPRESSION);' in os_skb_wmem according to Eric Dumazet
> v3: removed __pskb_expand_head(),
>     added is_skb_wmem() helper for skb with wmem-compatible destructors
>     there are 2 ways to use it:
>      - before pskb_expand_head(), to create skb clones
>      - after successfull pskb_expand_head() to change owner on extended skb.
> v2: based on patch version from Eric Dumazet,
>     added __pskb_expand_head() function, which can be forced
>     to adjust skb->truesize and sk->sk_wmem_alloc.
> ---
>  include/net/sock.h |  1 +
>  net/core/skbuff.c  | 35 ++++++++++++++++++++++++++---------
>  net/core/sock.c    |  8 ++++++++
>  3 files changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 95b2577..173d58c 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1695,6 +1695,7 @@ struct sk_buff *sock_wmalloc(struct sock *sk, unsigned long size, int force,
>  			     gfp_t priority);
>  void __sock_wfree(struct sk_buff *skb);
>  void sock_wfree(struct sk_buff *skb);
> +bool is_skb_wmem(const struct sk_buff *skb);
>  struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
>  			     gfp_t priority);
>  void skb_orphan_partial(struct sk_buff *skb);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f931176..09991cb 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1804,28 +1804,45 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>  {
>  	int delta = headroom - skb_headroom(skb);
> +	int osize = skb_end_offset(skb);
> +	struct sk_buff *oskb = NULL;
> +	struct sock *sk = skb->sk;
>  
>  	if (WARN_ONCE(delta <= 0,
>  		      "%s is expecting an increase in the headroom", __func__))
>  		return skb;
>  
> -	/* pskb_expand_head() might crash, if skb is shared */
> +	delta = SKB_DATA_ALIGN(delta);
> +	/* pskb_expand_head() might crash, if skb is shared.
> +	 * Also we should clone skb if its destructor does
> +	 * not adjust skb->truesize and sk->sk_wmem_alloc
> + 	 */
>  	if (skb_shared(skb)) {
>  		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>  
> -		if (likely(nskb)) {
> -			if (skb->sk)
> -				skb_set_owner_w(nskb, skb->sk);
> -			consume_skb(skb);
> -		} else {
> +		if (unlikely(!nskb)) {
>  			kfree_skb(skb);
> +			return NULL;
>  		}
> +		oskb = skb;
>  		skb = nskb;
>  	}
> -	if (skb &&
> -	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> +	if (pskb_expand_head(skb, delta, 0, GFP_ATOMIC)) {
>  		kfree_skb(skb);
> -		skb = NULL;
> +		kfree_skb(oskb);
> +		return NULL;
> +	}
> +	if (oskb) {
> +		if (sk)

if (is_skb_wmem(oskb))

Again, it is not valid to call skb_set_owner_w(skb, sk) on all kind of sockets.

> +			skb_set_owner_w(skb, sk);
> +		consume_skb(oskb);
> +	} else if (sk) {

&& (skb->destructor != sock_edemux)

(Because in this case , pskb_expand_head() already adjusted skb->truesize)

> +		delta = osize - skb_end_offset(skb);

> +		if (!is_skb_wmem(skb))
> +			skb_set_owner_w(skb, sk);

This is dangerous, even if a socket is there, its sk->sk_wmem_alloc could be zero.

We can not add skb->truesize to a refcount_t that already reached 0 (sk_free())


If is_skb_wmem() is false, you probably should do nothing, and leave
current destructor as it is.
(skb->truesize can be adjusted without issue)

> +		skb->truesize += delta;
> +		if (sk_fullsock(sk))

if (is_skb_wmem(skb))

> +			refcount_add(delta, &sk->sk_wmem_alloc);
>  	}
>  	return skb;
>  }
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 950f1e7..6cbda43 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2227,6 +2227,14 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
>  }
>  EXPORT_SYMBOL(skb_set_owner_w);
>  
> +bool is_skb_wmem(const struct sk_buff *skb)
> +{
> +	return skb->destructor == sock_wfree ||
> +	       skb->destructor == __sock_wfree ||
> +	       (IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree);
> +}
> +EXPORT_SYMBOL(is_skb_wmem);
> +
>  static bool can_skb_orphan_partial(const struct sk_buff *skb)
>  {
>  #ifdef CONFIG_TLS_DEVICE
> 
