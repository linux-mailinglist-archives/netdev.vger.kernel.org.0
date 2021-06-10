Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B896A3A324B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhFJRlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFJRlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:41:00 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6337AC061574;
        Thu, 10 Jun 2021 10:38:50 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c5so3220745wrq.9;
        Thu, 10 Jun 2021 10:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tUXqSeEZXltOhPTHiAdqKtvdjZ0xLSS8jzn9c1dkxjY=;
        b=pjfRdjx4L/QnD58wtcJ6TM/aLvwpHmU8YQJfsqmj8xb85HSGjgBfshNjR/j9kr4yVj
         OMYST3l5aaJQ1VCSksnoUJfqWNPfT4epA7pIrymzyp6AZWuDodv1/WXkF74xTrD+4rx+
         MEWljkHKYzkZyNj/naudRBHTLluWido3OoIKMQGZtqj+u3DUETqIAMedUNDhFjfIiGDy
         mm6QfrmcSGDNqvZH6R/yE0SFsTHRbGVn15qSzvSS4i76ObSDml5+0IkxMhBQm/85sRuP
         B2NsbCtgPsq3WceqC+hzgWSSp6K/LBSjVbfVGEn7UOVeuhT4ybflbbnXLVXSmjsiJdzI
         LCCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tUXqSeEZXltOhPTHiAdqKtvdjZ0xLSS8jzn9c1dkxjY=;
        b=d06oyO8dvSjkHi/e1fwh2b6aWG/QFLvF9RnYoCA26MFUGTOOLOmTg+u3MPU1MgtCBa
         7km0gVSaOvWj+HuLAVYbQ/sXh3AhTS8gCKrjysAN9Kxt4NB70YqEEIPTHU7Xo80SucEH
         T3dbM/xcVs/tbbaTZSaLgAf3vrR+ETu1yP7Fux6fon/OAtjHDqTXNZmb/v52u3FyQSXv
         ALB0Zn2kzS4x0+nzaxqcFcGmDQUPsljCwCyoUSx6Idoo6veFEG6vl0nFmojwh7jqIt8g
         ZXL9Aj6AGWKy4xWmXvXpjomdPderrpYwzDRARlBUBkv4C49QsmlnF3OKP9fAaRh4VWHs
         H+Qg==
X-Gm-Message-State: AOAM5303wy736Kr3AB7Sv1KTdywhUa/WcDDGlAiYJnKXGLOL4nDLudpA
        1RLjUu0g4r74TKq7ivRuFST6F/nCZsDAqQ==
X-Google-Smtp-Source: ABdhPJyW3em1GAoiY1cGwoDdGbzEerrtlDApG0CGW8yDf/p5nnK70PRh4ID0ShpihZuNsXMyeFUd5g==
X-Received: by 2002:adf:de03:: with SMTP id b3mr6724701wrm.15.1623346728707;
        Thu, 10 Jun 2021 10:38:48 -0700 (PDT)
Received: from [192.168.181.98] (228.18.23.93.rev.sfr.net. [93.23.18.228])
        by smtp.gmail.com with ESMTPSA id f14sm9074150wmq.10.2021.06.10.10.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 10:38:48 -0700 (PDT)
Subject: Re: [PATCH v7 bpf-next 02/11] tcp: Add num_closed_socks to struct
 sock_reuseport.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210521182104.18273-1-kuniyu@amazon.co.jp>
 <20210521182104.18273-3-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <942283cd-4b8a-5127-b047-0e26031adc6c@gmail.com>
Date:   Thu, 10 Jun 2021 19:38:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521182104.18273-3-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> As noted in the following commit, a closed listener has to hold the
> reference to the reuseport group for socket migration. This patch adds a
> field (num_closed_socks) to struct sock_reuseport to manage closed sockets
> within the same reuseport group. Moreover, this and the following commits
> introduce some helper functions to split socks[] into two sections and keep
> TCP_LISTEN and TCP_CLOSE sockets in each section. Like a double-ended
> queue, we will place TCP_LISTEN sockets from the front and TCP_CLOSE
> sockets from the end.
> 
>   TCP_LISTEN---------->       <-------TCP_CLOSE
>   +---+---+  ---  +---+  ---  +---+  ---  +---+
>   | 0 | 1 |  ...  | i |  ...  | j |  ...  | k |
>   +---+---+  ---  +---+  ---  +---+  ---  +---+
> 
>   i = num_socks - 1
>   j = max_socks - num_closed_socks
>   k = max_socks - 1
> 
> This patch also extends reuseport_add_sock() and reuseport_grow() to
> support num_closed_socks.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/net/sock_reuseport.h |  5 ++-
>  net/core/sock_reuseport.c    | 76 +++++++++++++++++++++++++++---------
>  2 files changed, 60 insertions(+), 21 deletions(-)
> 
> diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> index 505f1e18e9bf..0e558ca7afbf 100644
> --- a/include/net/sock_reuseport.h
> +++ b/include/net/sock_reuseport.h
> @@ -13,8 +13,9 @@ extern spinlock_t reuseport_lock;
>  struct sock_reuseport {
>  	struct rcu_head		rcu;
>  
> -	u16			max_socks;	/* length of socks */
> -	u16			num_socks;	/* elements in socks */
> +	u16			max_socks;		/* length of socks */
> +	u16			num_socks;		/* elements in socks */
> +	u16			num_closed_socks;	/* closed elements in socks */
>  	/* The last synq overflow event timestamp of this
>  	 * reuse->socks[] group.
>  	 */
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index b065f0a103ed..079bd1aca0e7 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -18,6 +18,49 @@ DEFINE_SPINLOCK(reuseport_lock);
>  
>  static DEFINE_IDA(reuseport_ida);
>  
> +static int reuseport_sock_index(struct sock *sk,
> +				struct sock_reuseport *reuse,
> +				bool closed)


const struct sock_reuseport *reuse


> +{
> +	int left, right;
> +
> +	if (!closed) {
> +		left = 0;
> +		right = reuse->num_socks;
> +	} else {
> +		left = reuse->max_socks - reuse->num_closed_socks;
> +		right = reuse->max_socks;
> +	}



> +
> +	for (; left < right; left++)
> +		if (reuse->socks[left] == sk)
> +			return left;


Is this even possible (to return -1) ?

> +	return -1;
> +}
> +
> +static void __reuseport_add_sock(struct sock *sk,
> +				 struct sock_reuseport *reuse)
> +{
> +	reuse->socks[reuse->num_socks] = sk;
> +	/* paired with smp_rmb() in reuseport_select_sock() */
> +	smp_wmb();
> +	reuse->num_socks++;
> +}
> +
> +static bool __reuseport_detach_sock(struct sock *sk,
> +				    struct sock_reuseport *reuse)
> +{
> +	int i = reuseport_sock_index(sk, reuse, false);
> +
> +	if (i == -1)
> +		return false;
> +
> +	reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
> +	reuse->num_socks--;
> +
> +	return true;
> +}
> +
>  static struct sock_reuseport *__reuseport_alloc(unsigned int max_socks)
>  {
>  	unsigned int size = sizeof(struct sock_reuseport) +
> @@ -72,9 +115,8 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
>  	}
>  
>  	reuse->reuseport_id = id;
> -	reuse->socks[0] = sk;
> -	reuse->num_socks = 1;
>  	reuse->bind_inany = bind_inany;
> +	__reuseport_add_sock(sk, reuse);

Not sure why you changed this part, really no smp_wmb() is needed at this point ?

>  	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
>  
>  out:
> @@ -98,6 +140,7 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
>  		return NULL;
>  
>  	more_reuse->num_socks = reuse->num_socks;
> +	more_reuse->num_closed_socks = reuse->num_closed_socks;
>  	more_reuse->prog = reuse->prog;
>  	more_reuse->reuseport_id = reuse->reuseport_id;
>  	more_reuse->bind_inany = reuse->bind_inany;
> @@ -105,9 +148,13 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
>  
>  	memcpy(more_reuse->socks, reuse->socks,
>  	       reuse->num_socks * sizeof(struct sock *));
> +	memcpy(more_reuse->socks +
> +	       (more_reuse->max_socks - more_reuse->num_closed_socks),
> +	       reuse->socks + reuse->num_socks,

The second memcpy() is to copy the closed sockets,
they should start at reuse->socks + (reuse->max_socks - reuse->num_closed_socks) ?


> +	       reuse->num_closed_socks * sizeof(struct sock *));
>  	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
>  
> -	for (i = 0; i < reuse->num_socks; ++i)
> +	for (i = 0; i < reuse->max_socks; ++i)
>  		rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
>  				   more_reuse);
>  
> @@ -158,7 +205,7 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
>  		return -EBUSY;
>  	}
>  
> -	if (reuse->num_socks == reuse->max_socks) {
> +	if (reuse->num_socks + reuse->num_closed_socks == reuse->max_socks) {
>  		reuse = reuseport_grow(reuse);
>  		if (!reuse) {
>  			spin_unlock_bh(&reuseport_lock);
> @@ -166,10 +213,7 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
>  		}
>  	}
>  
> -	reuse->socks[reuse->num_socks] = sk;
> -	/* paired with smp_rmb() in reuseport_select_sock() */
> -	smp_wmb();
> -	reuse->num_socks++;
> +	__reuseport_add_sock(sk, reuse);
>  	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
>  
>  	spin_unlock_bh(&reuseport_lock);
> @@ -183,7 +227,6 @@ EXPORT_SYMBOL(reuseport_add_sock);
>  void reuseport_detach_sock(struct sock *sk)
>  {
>  	struct sock_reuseport *reuse;
> -	int i;
>  
>  	spin_lock_bh(&reuseport_lock);
>  	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> @@ -200,16 +243,11 @@ void reuseport_detach_sock(struct sock *sk)
>  	bpf_sk_reuseport_detach(sk);
>  
>  	rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
> +	__reuseport_detach_sock(sk, reuse);
> +
> +	if (reuse->num_socks + reuse->num_closed_socks == 0)
> +		call_rcu(&reuse->rcu, reuseport_free_rcu);
>  
> -	for (i = 0; i < reuse->num_socks; i++) {
> -		if (reuse->socks[i] == sk) {
> -			reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
> -			reuse->num_socks--;
> -			if (reuse->num_socks == 0)
> -				call_rcu(&reuse->rcu, reuseport_free_rcu);
> -			break;
> -		}
> -	}
>  	spin_unlock_bh(&reuseport_lock);
>  }
>  EXPORT_SYMBOL(reuseport_detach_sock);
> @@ -274,7 +312,7 @@ struct sock *reuseport_select_sock(struct sock *sk,
>  	prog = rcu_dereference(reuse->prog);
>  	socks = READ_ONCE(reuse->num_socks);
>  	if (likely(socks)) {
> -		/* paired with smp_wmb() in reuseport_add_sock() */
> +		/* paired with smp_wmb() in __reuseport_add_sock() */
>  		smp_rmb();
>  
>  		if (!prog || !skb)
> 
