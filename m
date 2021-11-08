Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344BD449EF1
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 00:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240869AbhKHXNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 18:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234561AbhKHXNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 18:13:11 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B232EC061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 15:10:26 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id t21so17374914plr.6
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 15:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/Ay63S8d10HEdKoP+Heo7oqqUjs6Y+DaTFxf0YkFOgM=;
        b=dtxQ4wzXh1/8tjuNeS402FgNHe95Rq+2l7NUO1WgNtwml6527UxU77601IOIYcl6xE
         pN/pVM0J5REKqJ2y6wHXRnDcs2x1SWUYh7RbQ6zOyAHQDxFv9a3qM6iQ+5gBxDL2KGnl
         7kHZGg7yeGMXYU9muHPjlTPncvn5BoHigxc2tyM5oAjd8yIr1/HnyhfKOxVqkYAHdQMe
         OAoHT8JobgpcAzNKPjzaG/i0NQqJtH6f86rYHkv2rk0mxRiN6eMpFlyq2ci11F94j9aU
         suqy6oDZ5Kp7hGg/UIIwp3/nh1JEmPuh4qKUTdAQUjmuxQDJm9t66VJoeC3ZBNBeoEu5
         rk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Ay63S8d10HEdKoP+Heo7oqqUjs6Y+DaTFxf0YkFOgM=;
        b=6Nmt7JzATpNIZ4+l2XvUIvgKgF75zWeW8ZUTVoauqG0Sg6z1qR7Cwan/NlwbHXWMoh
         PCpcbR7fK4yGrEFTN3PBD+r1xcJlBQiWBH3eDM0/nVK8MfrW/Yjid3RZtQQEhvN6fmxk
         yDs4oH2n4SnvhQjGmGPpftaySkm5GZB2SNAnDFiqlGoCtwkY7f+GkVtkAnGB6lH/RLab
         Zxz5dYaFFTJNWdTzUcpBvWkQwyRKC8QfAqOpoC5eG286TD0+nNeh13djZzdmVNobciwu
         TtQI8eZIqPEZemmXxOHuCv+XlVxmCgKngCYlZLUZ5Fql/4ibEPrQ9KAp9QWgtqf4mYO+
         YKDA==
X-Gm-Message-State: AOAM530PwMRfi1BBoAxBLcIfzj/T2E/SAS0pZqtaPr9AGAoyHAqgJEIV
        iKRYqeY7Tq71LQkZqzi4yQNYBhChNvw=
X-Google-Smtp-Source: ABdhPJwghgo4+4eSVzYXRc9Drqsw9ezSiXUYvOUghC9UBjUH0d8VKklF+Lnj5RS7rFNTxDMbZ/l2EQ==
X-Received: by 2002:a17:903:245:b0:13f:7872:9382 with SMTP id j5-20020a170903024500b0013f78729382mr2638571plh.26.1636413026049;
        Mon, 08 Nov 2021 15:10:26 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j10sm17418681pfu.164.2021.11.08.15.10.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 15:10:25 -0800 (PST)
Subject: Re: [PATCH net-next 13/13] af_unix: Relax race in unix_autobind().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        netdev@vger.kernel.org
References: <20211106091712.15206-1-kuniyu@amazon.co.jp>
 <20211106091712.15206-14-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1d2e0a47-a486-0991-91e2-fed54163898e@gmail.com>
Date:   Mon, 8 Nov 2021 15:10:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211106091712.15206-14-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/6/21 2:17 AM, Kuniyuki Iwashima wrote:
> When we bind an AF_UNIX socket without a name specified, the kernel selects
> an available one from 0x00000 to 0xFFFFF.  unix_autobind() starts searching
> from a number in the 'static' variable and increments it after acquiring
> two locks.
> 
> If multiple processes try autobind, they obtain the same lock and check if
> a socket in the hash list has the same name.  If not, one process uses it,
> and all except one end up retrying the _next_ number (actually not, it may
> be incremented by the other processes).  The more we autobind sockets in
> parallel, the longer the latency gets.  We can avoid such a race by
> searching for a name from a random number.
> 
> These show latency in unix_autobind() while 64 CPUs are simultaneously
> autobind-ing 1024 sockets for each.
> 
>   Without this patch:
> 
>      usec          : count     distribution
>         0          : 1176     |***                                     |
>         2          : 3655     |***********                             |
>         4          : 4094     |*************                           |
>         6          : 3831     |************                            |
>         8          : 3829     |************                            |
>         10         : 3844     |************                            |
>         12         : 3638     |***********                             |
>         14         : 2992     |*********                               |
>         16         : 2485     |*******                                 |
>         18         : 2230     |*******                                 |
>         20         : 2095     |******                                  |
>         22         : 1853     |*****                                   |
>         24         : 1827     |*****                                   |
>         26         : 1677     |*****                                   |
>         28         : 1473     |****                                    |
>         30         : 1573     |*****                                   |
>         32         : 1417     |****                                    |
>         34         : 1385     |****                                    |
>         36         : 1345     |****                                    |
>         38         : 1344     |****                                    |
>         40         : 1200     |***                                     |
> 
>   With this patch:
> 
>      usec          : count     distribution
>         0          : 1855     |******                                  |
>         2          : 6464     |*********************                   |
>         4          : 9936     |********************************        |
>         6          : 12107    |****************************************|
>         8          : 10441    |**********************************      |
>         10         : 7264     |***********************                 |
>         12         : 4254     |**************                          |
>         14         : 2538     |********                                |
>         16         : 1596     |*****                                   |
>         18         : 1088     |***                                     |
>         20         : 800      |**                                      |
>         22         : 670      |**                                      |
>         24         : 601      |*                                       |
>         26         : 562      |*                                       |
>         28         : 525      |*                                       |
>         30         : 446      |*                                       |
>         32         : 378      |*                                       |
>         34         : 337      |*                                       |
>         36         : 317      |*                                       |
>         38         : 314      |*                                       |
>         40         : 298      |                                        |
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  net/unix/af_unix.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 643f0358bf7a..55d570b23475 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1075,8 +1075,7 @@ static int unix_autobind(struct sock *sk)
>  	unsigned int new_hash, old_hash = sk->sk_hash;
>  	struct unix_sock *u = unix_sk(sk);
>  	struct unix_address *addr;
> -	unsigned int retries = 0;
> -	static u32 ordernum = 1;
> +	u32 initnum, ordernum;
>  	int err;
>  
>  	err = mutex_lock_interruptible(&u->bindlock);
> @@ -1091,31 +1090,33 @@ static int unix_autobind(struct sock *sk)
>  	if (!addr)
>  		goto out;
>  
> +	addr->len = offsetof(struct sockaddr_un, sun_path) + 6;
>  	addr->name->sun_family = AF_UNIX;
>  	refcount_set(&addr->refcnt, 1);
>  
> +	initnum = ordernum = prandom_u32();
>  retry:
> -	addr->len = sprintf(addr->name->sun_path + 1, "%05x", ordernum) +
> -		offsetof(struct sockaddr_un, sun_path) + 1;
> +	ordernum = (ordernum + 1) & 0xFFFFF;
> +	sprintf(addr->name->sun_path + 1, "%05x", ordernum);
>  
>  	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
>  	unix_table_double_lock(old_hash, new_hash);
> -	ordernum = (ordernum+1)&0xFFFFF;
>  
>  	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len, new_hash)) {
>  		unix_table_double_unlock(old_hash, new_hash);
>  
> -		/*
> -		 * __unix_find_socket_byname() may take long time if many names
> +		/* __unix_find_socket_byname() may take long time if many names
>  		 * are already in use.
>  		 */
>  		cond_resched();
> -		/* Give up if all names seems to be in use. */
> -		if (retries++ == 0xFFFFF) {
> +
> +		if (ordernum == initnum) {

Infinite loop alert, in the likely case initnum >= 2^16

> +			/* Give up if all names seems to be in use. */
>  			err = -ENOSPC;
> -			kfree(addr);
> +			unix_release_addr(addr);
>  			goto out;
>  		}
> +
>  		goto retry;
>  	}
>  
> 
