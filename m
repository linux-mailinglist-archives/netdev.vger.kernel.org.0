Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E434042FCA8
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 21:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242883AbhJOUBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 16:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhJOUBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 16:01:09 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A72BC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 12:59:03 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lk8-20020a17090b33c800b001a0a284fcc2so10100810pjb.2
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 12:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jeCsJzc7qx5OCn43bBbSxHSYOv9Vb3deZK8CzTFOVHg=;
        b=K94Fyw3cHw3pLDQ7nET81VCqQjultWoZIienGTCgFOrYJGY/8oznRL1QvqO31W/KAV
         S+4fYIEDDj8D/cbXH6qSf5NLCuWGn+gHvdlVYNHckbN9f7TLn4p/jAtKlXSlgXJmfSDI
         bFePDkDPS6EstkcdqWO64YqY5bCA8zEg9Om60EHIlYKu45yC+LuX/jEzHZWY78CyIuzR
         AyoY2GfOJvT9nM+p0n1IoR1kkWQEibuOA/czsDWwO01UL6dRPod0tV1uGn95AhxS7MwY
         m/9ysr1ju7x56HTHXDd58CPdwMHdZCa/J/bazccULNnJyvq3AkodytoFSNFp6755YYzb
         lqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jeCsJzc7qx5OCn43bBbSxHSYOv9Vb3deZK8CzTFOVHg=;
        b=Db/8GHB8+J7cxpXdAUX2ZYzCcnZgTj1Y4SEglhFAT9dKc7smt6c8aDwhxO2ogpNuGd
         y15d9NQ6k30cgWkc51qLofKByHsMP8vm2A75F04eSX0WEiWTfhF8jV5Z5ds3EqVEarNA
         j1+6emnsa4Fnb2kRC0L2nFT7fnoVIuxmXqsCwKyCJadgbL7na6jlyj9UfqGM1kKHtzb3
         ffrHsjXvC4QiMrsK6xKWK6COXgDiU+E5VqK8AHNIhisl8lEs6SlqHewT8vTHAmVallgo
         zOM2tZMjxKxK5OfPJH0lXE7avtMhbOcvsGlkpWX/VHCSmK7JcvUFFNoe6CMmOeCAgL25
         bt3g==
X-Gm-Message-State: AOAM532flUhvcEN74Xl7YD/zF+b/7iVW663XjWbFspjiApov2QDomTMs
        e+vKChO9urja2dqQbuLM5eqjLDlgZII=
X-Google-Smtp-Source: ABdhPJwpOM4Ylqtp9k0FmDgthrXDkH9oAv+yqeqRe/9tPg3IzRXFsUaCTLHGoMqaTneWg/PsJQT06w==
X-Received: by 2002:a17:90a:4290:: with SMTP id p16mr29918243pjg.112.1634327942171;
        Fri, 15 Oct 2021 12:59:02 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t2sm12000668pjf.1.2021.10.15.12.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 12:59:01 -0700 (PDT)
Subject: Re: [PATCH net-next] net: stream: don't purge sk_error_queue in
 sk_stream_kill_queues()
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20211015133739.672915-1-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bb4e66df-7639-0797-49ed-0909fb83a85a@gmail.com>
Date:   Fri, 15 Oct 2021 12:59:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211015133739.672915-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/15/21 6:37 AM, Jakub Kicinski wrote:
> sk_stream_kill_queues() can be called on close when there are
> still outstanding skbs to transmit. Those skbs may try to queue
> notifications to the error queue (e.g. timestamps).
> If sk_stream_kill_queues() purges the queue without taking
> its lock the queue may get corrupted, and skbs leaked.
> 
> This shows up as a warning about an rmem leak:
> 
> WARNING: CPU: 24 PID: 0 at net/ipv4/af_inet.c:154 inet_sock_destruct+0x...
> 
> The leak is always a multiple of 0x300 bytes (the value is in
> %rax on my builds, so RAX: 0000000000000300). 0x300 is truesize of
> an empty sk_buff. Indeed if we dump the socket state at the time
> of the warning the sk_error_queue is often (but not always)
> corrupted. The ->next pointer points back at the list head,
> but not the ->prev pointer. Indeed we can find the leaked skb
> by scanning the kernel memory for something that looks like
> an skb with ->sk = socket in question, and ->truesize = 0x300.
> The contents of ->cb[] of the skb confirms the suspicion that
> it is indeed a timestamp notification (as generated in
> __skb_complete_tx_timestamp()).
> 
> Removing purging of sk_error_queue should be okay, since
> inet_sock_destruct() does it again once all socket refs
> are gone. Eric suggests this may cause sockets that go
> thru disconnect() to maintain notifications from the
> previous incarnations of the socket, but that should be
> okay since the race was there anyway, and disconnect()
> is not exactly dependable.
> 
> Thanks to Jonathan Lemon and Omar Sandoval for help at various
> stages of tracing the issue.
> 
> Fixes: cb9eff097831 ("net: new user space API for time stamping of incoming and outgoing packets")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v1: delete the purge completely
> 
> Sorry for the delay from RFC, took a while to get enough
> production signal to confirm the fix.
> ---
>  net/core/stream.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/net/core/stream.c b/net/core/stream.c
> index e09ffd410685..06b36c730ce8 100644
> --- a/net/core/stream.c
> +++ b/net/core/stream.c
> @@ -195,9 +195,6 @@ void sk_stream_kill_queues(struct sock *sk)
>  	/* First the read buffer. */
>  	__skb_queue_purge(&sk->sk_receive_queue);
>  
> -	/* Next, the error queue. */
> -	__skb_queue_purge(&sk->sk_error_queue);
> -
>  	/* Next, the write queue. */
>  	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
>  
> 

Thanks Jakub !

Reviewed-by: Eric Dumazet <edumazet@google.com>
