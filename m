Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46A630746D
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhA1LIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhA1LIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:08:10 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B284C061573;
        Thu, 28 Jan 2021 03:07:30 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id b21so6105210edy.6;
        Thu, 28 Jan 2021 03:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ShvLSg8TcUv7NMdoxeoIAAQL8A+KbCkuTPD4+VWr/xw=;
        b=r20bWnHJcpDYrun7/+dblaBlkZmvrlfcUzFlVhAM/99ifcympYDgkFJyRa5qglBNVP
         lUgsevJEU/ojexhJyVjLCUuwaApmjfBSEBvK9aSkcLozLKy0Khac4ULZBqkqVui8/gnF
         KgMlIyc6wAoVSH/2z/Wwb8+lDP7m2v8wyFixfmUNRPNBDaXf/nHYjnT55FfYVQ2djsLj
         v7sWQ5NXFLPHIit4r7eXQXCouRZr69eKN7T8KUc1dR/IJuj4re4jHhKBYTa/AzZz7Mbh
         hikuSfhdiVyfxEArZrbdLnzBXy5MCbmaX97+0UIykVpxI0uwyAJduv1hS7xbXeXRKkjq
         z4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ShvLSg8TcUv7NMdoxeoIAAQL8A+KbCkuTPD4+VWr/xw=;
        b=g0hf9rOfPiQWBXgefTf/e/cDv0StQTUDr3xFRqQSgEpDmxtPX9Bb93yIntTfSrZ7zQ
         ctFUHru4YJOnA99CN33QiMKBVJQAB6coXW1m4OmkejRfNJ+iYUwyOZtA+gkUl6m1yX9M
         jT1ibMWDMu1gv1jPG7RxNwoGDFf7RoEr0ANjzm/IQc2NKkiK434zFqHn9cdpH74+mSBo
         ijnPDSk4tFx2g9ZKvKK4scrv4mMRWXu56Jcto+mMmkbgYwBmyfuE+07QEfhHgf2GYYXY
         I6KH7wUdSMSJhJQFWgC2vLRDhbnToIByxSXr0bfFpuXpv9khCzyhrId8CijeQxpGLpcl
         6YJw==
X-Gm-Message-State: AOAM532+Prrwgngkh+Gv6AmQZLrCFEOWYUFJEe1F0nrJZjXLHFHuzemR
        ELoQKZUQSzlW0m6gURvBCB0=
X-Google-Smtp-Source: ABdhPJwhYhYq0R/c5h8bydiP9Pk+wXe395h/cBdTuhpEq8mWvbd2dvjWgMBDjbMC7ld61pjcVKSJWA==
X-Received: by 2002:aa7:ce87:: with SMTP id y7mr13556149edv.211.1611832048909;
        Thu, 28 Jan 2021 03:07:28 -0800 (PST)
Received: from [192.168.0.101] ([77.124.61.116])
        by smtp.gmail.com with ESMTPSA id a22sm2793249edv.67.2021.01.28.03.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 03:07:28 -0800 (PST)
Subject: Re: [PATCH v3 net-next] net: Remove redundant calls of
 sk_tx_queue_clear().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Amit Shah <aams@amazon.de>, Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
References: <20210128021905.57471-1-kuniyu@amazon.co.jp>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <6f77d50f-b658-b751-5ac4-caaf9876f287@gmail.com>
Date:   Thu, 28 Jan 2021 13:07:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210128021905.57471-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/28/2021 4:19 AM, Kuniyuki Iwashima wrote:
> The commit 41b14fb8724d ("net: Do not clear the sock TX queue in
> sk_set_socket()") removes sk_tx_queue_clear() from sk_set_socket() and adds
> it instead in sk_alloc() and sk_clone_lock() to fix an issue introduced in
> the commit e022f0b4a03f ("net: Introduce sk_tx_queue_mapping"). On the
> other hand, the original commit had already put sk_tx_queue_clear() in
> sk_prot_alloc(): the callee of sk_alloc() and sk_clone_lock(). Thus
> sk_tx_queue_clear() is called twice in each path.
> 
> If we remove sk_tx_queue_clear() in sk_alloc() and sk_clone_lock(), it
> currently works well because (i) sk_tx_queue_mapping is defined between
> sk_dontcopy_begin and sk_dontcopy_end, and (ii) sock_copy() called after
> sk_prot_alloc() in sk_clone_lock() does not overwrite sk_tx_queue_mapping.
> However, if we move sk_tx_queue_mapping out of the no copy area, it
> introduces a bug unintentionally.
> 
> Therefore, this patch adds a runtime 

compile-time

> check to take care of the order of
> sock_copy() and sk_tx_queue_clear() and removes sk_tx_queue_clear() from
> sk_prot_alloc() so that it does the only allocation and its callers
> initialize fields.
> 
> v3:
> * Remove Fixes: tag
> * Add BUILD_BUG_ON
> * Remove sk_tx_queue_clear() from sk_prot_alloc()
>    instead of sk_alloc() and sk_clone_lock()
> 
> v2: https://lore.kernel.org/netdev/20210127132215.10842-1-kuniyu@amazon.co.jp/
> * Remove Reviewed-by: tag
> 
> v1: https://lore.kernel.org/netdev/20210127125018.7059-1-kuniyu@amazon.co.jp/
> 
> CC: Tariq Toukan <tariqt@mellanox.com>
> CC: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>   net/core/sock.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index bbcd4b97eddd..cfbd62a5e079 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1657,6 +1657,16 @@ static void sock_copy(struct sock *nsk, const struct sock *osk)
>   #ifdef CONFIG_SECURITY_NETWORK
>   	void *sptr = nsk->sk_security;
>   #endif
> +
> +	/* If we move sk_tx_queue_mapping out of the private section,
> +	 * we must check if sk_tx_queue_clear() is called after
> +	 * sock_copy() in sk_clone_lock().
> +	 */
> +	BUILD_BUG_ON(offsetof(struct sock, sk_tx_queue_mapping) <
> +		     offsetof(struct sock, sk_dontcopy_begin) ||
> +		     offsetof(struct sock, sk_tx_queue_mapping) >=
> +		     offsetof(struct sock, sk_dontcopy_end));
> +
>   	memcpy(nsk, osk, offsetof(struct sock, sk_dontcopy_begin));
>   
>   	memcpy(&nsk->sk_dontcopy_end, &osk->sk_dontcopy_end,
> @@ -1690,7 +1700,6 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
>   
>   		if (!try_module_get(prot->owner))
>   			goto out_free_sec;
> -		sk_tx_queue_clear(sk);
>   	}
>   
>   	return sk;
> 
