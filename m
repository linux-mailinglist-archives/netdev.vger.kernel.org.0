Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CE43076CC
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 14:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhA1NKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 08:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbhA1NKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 08:10:35 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBE9C061756;
        Thu, 28 Jan 2021 05:09:55 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a10so7630759ejg.10;
        Thu, 28 Jan 2021 05:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CdHrZZKCFGbRw7B5b9fj5zGmhgaPbbkoPZv2x5b3J7o=;
        b=IvGKLCyZfj99YBUzT5iluG/lUsUVkiH2ItSUJdxken6550pj5eJ2uWtZ5gasF+pNMv
         VeURcKIg8OpMrdzBNQwxunPsuxTI54zvMvYeqqeRNU0h/UYLuZbrr06YWKZ9zHUEGmnX
         W8oxubR828pVuVmKeajgoIRL8Pguu93AQI2sXqNd7U7uUYNYbrh2sPTO5dmBt+3h9srA
         /K3aQyvOIhUu9MxCp/va5Sd0rR+/amxa1qc650I0p3J0pAXXqoRlgO0YmZgpdYJ28+JG
         Y4aN+shrWTXU7LAQCAE3LqSU3NHDjguOnHkgXV2BLuTRxPERb9RYUTrPnpbczKgtIDyl
         bHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CdHrZZKCFGbRw7B5b9fj5zGmhgaPbbkoPZv2x5b3J7o=;
        b=mM8d7ZQLkizZOurgY4N2LIvcK0N6CDPgiiDeKqH/yF9beq6Lwa2OJjoBPDBUaMTz28
         VWnW63khVjhq7/7+hB7KqtlcvUaHpAQ9nkfz1oQraw253qHUZP2O7JKkP0pfwIjeMlhI
         +cUWQsLKe76gYaOeWfHbiGx9pvQlgYoGD4pmBX8HqZtBiKIMc6XGKEMqt/Pu0sBSMJzM
         YJBhGllqh+nEwWB0M5P3Wx2K0FjkE2UgciryKMtUT8LxkPjCDLFfNnSMuHQ5IVUmfCB+
         k75ookh8Euewlu+uDvz//PPKDRJmeX4zseEBKP2g7MhOpTW/0XvK0g/nJT9PtqmuT5D0
         /AKQ==
X-Gm-Message-State: AOAM532fv9lP5Y/ykSQWaF9lioxS1wnHd7Pt6NJhrN53N/bUuPdOXnva
        7sYQFdkFKxl1cxDW49OYfg8=
X-Google-Smtp-Source: ABdhPJxBNXZE6rL2hNwD6LVXA79HcYy2S3Puzk0YxZD8gsKML539+nNAG1cr5zTuFzHfmdfRqFjyJg==
X-Received: by 2002:a17:906:941a:: with SMTP id q26mr11346434ejx.266.1611839394293;
        Thu, 28 Jan 2021 05:09:54 -0800 (PST)
Received: from [192.168.0.101] ([77.124.61.116])
        by smtp.gmail.com with ESMTPSA id v15sm2277913ejj.4.2021.01.28.05.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 05:09:53 -0800 (PST)
Subject: Re: [PATCH v4 net-next] net: Remove redundant calls of
 sk_tx_queue_clear().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Amit Shah <aams@amazon.de>, Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
References: <20210128124229.78315-1-kuniyu@amazon.co.jp>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <fad76e94-ca1f-41f6-f1aa-f9853f64d36d@gmail.com>
Date:   Thu, 28 Jan 2021 15:09:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210128124229.78315-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/28/2021 2:42 PM, Kuniyuki Iwashima wrote:
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
> Therefore, this patch adds a compile-time check to take care of the order
> of sock_copy() and sk_tx_queue_clear() and removes sk_tx_queue_clear() from
> sk_prot_alloc() so that it does the only allocation and its callers
> initialize fields.
> 
> v4:
> * Fix typo in the changelog (runtime -> compile-time)
> 
> v3: https://lore.kernel.org/netdev/20210128021905.57471-1-kuniyu@amazon.co.jp/
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

Sorry for not pointing this out earlier, but shouldn't the changelog 
come after the --- separator? Unless you want it to appear as part of 
the commit message.

Other than that, I think now I'm fine with the patch.

Acked-by: Tariq Toukan <tariqt@nvidia.com>

Thanks,
Tariq

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
