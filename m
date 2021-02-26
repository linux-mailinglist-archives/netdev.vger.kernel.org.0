Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D99326465
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 15:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhBZOuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 09:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhBZOut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 09:50:49 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70232C061574;
        Fri, 26 Feb 2021 06:50:09 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id p3so7656726wmc.2;
        Fri, 26 Feb 2021 06:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LdEBsmIol4lYaUKgOfszO6JPThDEGi6WWZVW4HjYNtE=;
        b=G9tJfY7VzYw3bA/YGgE8LWUXom6n+Kz0f/yOXp8KklqhP7VmYK9LHp8pGfYiT76tGS
         2NPlryjSLLUEfHlC+s4k03FAM/tUXlQsxMtBwHWmjbJBEQxFePxxz72YaoOEQX7gIIY/
         Vu9hRdPS2DIL3E2OlfO0d3G95BON/xUsf0YbrfcggjK7QJAJVvcBlKNAlzRUENCgZMEf
         GlaO1DOS9FzclcjvXlRLiLJAaPRWacPpCQ5iZPCbxV4d/ZOrs5TpbswG7AgzN8ddvS3u
         2oCa20qSsDAvdxNrj9wKxHFWGNsd0q5mZghAkq2DRM5dU51v5sMaODFmOSptZSvFFDOq
         wrxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LdEBsmIol4lYaUKgOfszO6JPThDEGi6WWZVW4HjYNtE=;
        b=GwxhnS78v90qdTY+egfEWrTPTBt6Vcz9Vx7ItL1zmwrwRTo+/w1URgjVxSSgSgMsxH
         6z/aXP3tYU7a5yiB67Tj+1uiCzBZ0stPt7QPos66UBJXYMh0jvrzNRl8rDY/nX4hnzQ2
         H40cId0yWnFAhU+2NYbok8gleFpIWsECD4kfzxQH8JudEfsElkPmAOzihZlAUXNnknks
         u87RerIiqcW/KjV/W4gqnrvO9Cl1U6i6mn/ycw8Z3NxomPdfoMFVhXBZz8vm64lYmXdZ
         yF+NINNpjV7nrA1F0hLYD0ce0BCsZoIe8HQ1FqvXjcBBCV1h2kly8h4aFL03SWNGHNxW
         XOMQ==
X-Gm-Message-State: AOAM532mGgLmWRlRq+klhJ7ZH7oLbWEWojsLzAmdQ9Yj14pG7T9DdF8n
        TLZM7mDnSqvUcDHe0B6aKhtP+j9np2s=
X-Google-Smtp-Source: ABdhPJyK80dXEbhPF3KyJoziC7kBbEAitZUZuMwjuVJXd2+zoH8/P74wduFfoIMD0v/fMMtz5B6dXw==
X-Received: by 2002:a05:600c:2cb9:: with SMTP id h25mr3261677wmc.110.1614351007844;
        Fri, 26 Feb 2021 06:50:07 -0800 (PST)
Received: from [192.168.1.101] ([37.173.153.69])
        by smtp.gmail.com with ESMTPSA id m24sm13299739wmc.18.2021.02.26.06.50.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 06:50:06 -0800 (PST)
Subject: Re: [PATCH] inetpeer: use else if instead of if to reduce judgment
To:     Yejune Deng <yejune.deng@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210226105746.29240-1-yejune.deng@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d16327f3-33c0-61c1-3adf-78f7edcbec6a@gmail.com>
Date:   Fri, 26 Feb 2021 15:38:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210226105746.29240-1-yejune.deng@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/26/21 11:57 AM, Yejune Deng wrote:
> In inet_initpeers(), if si.totalram <= (8192*1024)/PAGE_SIZE, it will
> be judged three times. Use else if instead of if, it only needs to be
> judged once.
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  net/ipv4/inetpeer.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
> index ff327a62c9ce..07cd1f8204b3 100644
> --- a/net/ipv4/inetpeer.c
> +++ b/net/ipv4/inetpeer.c
> @@ -81,12 +81,12 @@ void __init inet_initpeers(void)
>  	 * <kuznet@ms2.inr.ac.ru>.  I don't have any opinion about the values
>  	 * myself.  --SAW
>  	 */
> -	if (si.totalram <= (32768*1024)/PAGE_SIZE)
> +	if (si.totalram <= (8192 * 1024) / PAGE_SIZE)
> +		inet_peer_threshold >>= 4; /* about 128KB */
> +	else if (si.totalram <= (16384 * 1024) / PAGE_SIZE)
> +		inet_peer_threshold >>= 2; /* about 512KB */
> +	else if (si.totalram <= (32768 * 1024) / PAGE_SIZE)
>  		inet_peer_threshold >>= 1; /* max pool size about 1MB on IA32 */


If you really want to change this stuff, I would suggest updating comments,
because nowadays, struct inet_peer on IA32 uses 128 bytes.

So 32768 entries would consume 4 MB,
   16384 entries would consume 2 MB

and 4096 entries would consume 512KB

Another idea would be to get rid of the cascade and use something that
will not need to be adjusted in the future.

diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index ff327a62c9ce9b1794104c3c924f5f2b9820ac8b..d5f486bd8c35234f99b22842e756a10531e070d6 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -65,7 +65,7 @@ EXPORT_SYMBOL_GPL(inet_peer_base_init);
 #define PEER_MAX_GC 32
 
 /* Exported for sysctl_net_ipv4.  */
-int inet_peer_threshold __read_mostly = 65536 + 128;   /* start to throw entries more
+int inet_peer_threshold __read_mostly; /* start to throw entries more
                                         * aggressively at this stage */
 int inet_peer_minttl __read_mostly = 120 * HZ; /* TTL under high load: 120 sec */
 int inet_peer_maxttl __read_mostly = 10 * 60 * HZ;     /* usual time to live: 10 min */
@@ -73,20 +73,13 @@ int inet_peer_maxttl __read_mostly = 10 * 60 * HZ;  /* usual time to live: 10 min
 /* Called from ip_output.c:ip_init  */
 void __init inet_initpeers(void)
 {
-       struct sysinfo si;
+       u64 nr_entries;
 
-       /* Use the straight interface to information about memory. */
-       si_meminfo(&si);
-       /* The values below were suggested by Alexey Kuznetsov
-        * <kuznet@ms2.inr.ac.ru>.  I don't have any opinion about the values
-        * myself.  --SAW
-        */
-       if (si.totalram <= (32768*1024)/PAGE_SIZE)
-               inet_peer_threshold >>= 1; /* max pool size about 1MB on IA32 */
-       if (si.totalram <= (16384*1024)/PAGE_SIZE)
-               inet_peer_threshold >>= 1; /* about 512KB */
-       if (si.totalram <= (8192*1024)/PAGE_SIZE)
-               inet_peer_threshold >>= 2; /* about 128KB */
+       /* 1% of physical memory */
+       nr_entries = div64_ul((u64)totalram_pages() << PAGE_SHIFT,
+                             100 * L1_CACHE_ALIGN(sizeof(struct inet_peer)));
+
+       inet_peer_threshold = clamp_val(nr_entries, 4096, 65536 + 128);
 
        peer_cachep = kmem_cache_create("inet_peer_cache",
                        sizeof(struct inet_peer),






