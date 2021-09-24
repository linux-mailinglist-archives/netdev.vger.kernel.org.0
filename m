Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADFD4176CD
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 16:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346726AbhIXOcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 10:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbhIXOcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 10:32:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB5AC061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 07:30:33 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id r7so6539911pjo.3
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 07:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bCrHHBB0x2YwWlN7klYRKjz9g/GyJal2zkXw83z8Z/8=;
        b=SDtpE6yPCru66ZeWBr/6h9eH9shjub4dkBAotq3zrmk4ibdVlESzmBiihtfg9VIW8Y
         BX1KfmPgEATdAG/L3hFBYOKpW+YVloWbU7hkVYePRqSEGlrY6EENgvySnUkVQQxfjbbp
         XAm2hn5r8/f1uR6hZr3maz4MF0YpO+/rrd0LMAnGgjXolpYkTzFSgl+1BB4hEbwVnsfl
         /lppGIkzvpGsk1HH+gH+ct+mgITxjZAxSnKdFxdpUZGUPFZi9Sk6adQ93q4baovXbkRb
         dlcuAg/Cl9mFGIipt25JL62rZLaRjMzGK+s2JY8BFZNtvexP6a8HubLYyn0cuh6SrIkF
         54sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bCrHHBB0x2YwWlN7klYRKjz9g/GyJal2zkXw83z8Z/8=;
        b=N3L55e6v3AzVxpy3kYBf9hTyvewZV4zTa9hpDqOutR3rAVwyU6YH+kdjyjBKQeAZN9
         1zaIiMeYI/QesAsGuhtApQ92DHYEsloFDEiVxALHr9LDlCV5j24Aofs4N5FS+NQ5JfWS
         xLin8Z+IWd8reQUIE/Q+oUtV4pZlRzqmgxVguErCxoTZ9p9k8fwiw1XeSBxLh0CS6VK+
         X/uY8/2jyKg9MRa7bpPVGCDFtNsGg+/bPLiIf+186/6BPaBi4HFgmgb0l2PIE7OtDRi3
         /1KAglwzRE9Y7FmvLuTElcPS7o55yle26tvzr1IZyNW3us+s7FL/s0CFJM6KShkj1qYC
         7Ieg==
X-Gm-Message-State: AOAM531wQPsg4C/Cqgsc6gqdkryS1WQTYtRTKOlzeDipI5viz8+kG7aB
        E4p7nPHdisWBzD+nbpaUmHs=
X-Google-Smtp-Source: ABdhPJy7NJcfLaGJ9DIIQ8I/zxbHUXz7h77zpR2t7Ho1UfyNGjeSbjDAPv6JahJQonCNySkf8NR4Bw==
X-Received: by 2002:a17:90a:191a:: with SMTP id 26mr2624347pjg.118.1632493833354;
        Fri, 24 Sep 2021 07:30:33 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d24sm6361592pgv.52.2021.09.24.07.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 07:30:32 -0700 (PDT)
Subject: Re: [PATCH net-next] net: make napi_disable() symmetric with enable
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, weiwan@google.com,
        xuanzhuo@linux.alibaba.com
References: <20210924040251.901171-1-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <03648349-c74e-cafb-1dce-8cf7fab44089@gmail.com>
Date:   Fri, 24 Sep 2021 07:30:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924040251.901171-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/23/21 9:02 PM, Jakub Kicinski wrote:
> Commit 3765996e4f0b ("napi: fix race inside napi_enable") fixed
> an ordering bug in napi_enable() and made the napi_enable() diverge
> from napi_disable(). The state transitions done on disable are
> not symmetric to enable.
> 
> There is no known bug in napi_disable() this is just refactoring.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Does this look like a reasonable cleanup?
> 
> TBH my preference would be to stick to the code we have in
> disable, and refactor enable back to single ops just in the
> right order. I find the series of atomic ops far easier to read
> and cmpxchg is not really required here.

I think RT crowd does not like the cmpxchg(), but I guess now
we have them in fast path, we are a bit stuck.

> ---
>  net/core/dev.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 62ddd7d6e00d..0d297423b304 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6900,19 +6900,25 @@ EXPORT_SYMBOL(netif_napi_add);
>  
>  void napi_disable(struct napi_struct *n)
>  {
> +	unsigned long val, new;
> +
>  	might_sleep();
>  	set_bit(NAPI_STATE_DISABLE, &n->state);
>  
> -	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
> -		msleep(1);
> -	while (test_and_set_bit(NAPI_STATE_NPSVC, &n->state))
> -		msleep(1);
> +	do {
> +		val = READ_ONCE(n->state);
> +		if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
> +			msleep(1);

Patch seems good to me.

We also could replace this pessimistic msleep(1) with more opportunistic usleep_range(20, 200)

> +			continue;
> +		}
> +
> +		new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
> +		new &= ~(NAPIF_STATE_THREADED | NAPIF_STATE_PREFER_BUSY_POLL);
> +	} while (cmpxchg(&n->state, val, new) != val);
>  
>  	hrtimer_cancel(&n->timer);
>  
> -	clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
>  	clear_bit(NAPI_STATE_DISABLE, &n->state);
> -	clear_bit(NAPI_STATE_THREADED, &n->state);
>  }
>  EXPORT_SYMBOL(napi_disable);
>  
> 
