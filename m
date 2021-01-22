Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B1A30102B
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbhAVWkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730160AbhAVTpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 14:45:52 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1F2C06174A;
        Fri, 22 Jan 2021 11:45:11 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id h192so7298459oib.1;
        Fri, 22 Jan 2021 11:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c7xlz7Z1JljLKtR/zNo7rLUK2hDyfKzLGvAVUeTC7sM=;
        b=pY0I+BN96QSz9mJgTsM3ecrN9l31DORCKjM8MhZwQs8vfKaU1GYC5+vvd8jhWCk+Et
         /Jo5lmPwJm77Bk6XjSFKSTt2mJPPlvHUpmt5K4J7sbEopu22x6PV08nEWy6IA8jnmI/+
         UZQdUXCr9ktnAsdMdqfx90JZt7C8N43kvkTcQGiEf0SoRpXc0OJxvnFRGcxjUqU2e4yN
         uLlKwQCL8KGEGFkB+ZfwfYke/0VqEZuYENosLRSYO6pxXqFrAQfpQrA1x1JCcfZRyoyL
         n9aFBtyvpdqJ5YWGmYU0bzPLh0+IowfsHCUPY8iD0VrtaB0tLX/H2Urlsr9u+77Yu7Q1
         vviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c7xlz7Z1JljLKtR/zNo7rLUK2hDyfKzLGvAVUeTC7sM=;
        b=goDLTJmgy/5iUPtKDHsgxA8oU0+PYnww+2g2LGSRXWzKX30Ej+v27fGqvEV/ANHVIE
         0oiqM5OW3dmj62Mi0uDhhelvBwLciX2KGC+HtqgTbJKo0odkN4v7DLgbIdmm2EidPl2q
         od7rgVNmIP3k2UhWNL630vRpoYAIAiCG//HGXfS4ANLyIithpVQyhaE/bnALatUmo0Km
         aTpLwMPAswBqfv3wl7ap1DCwFid6WRNd9aalsmtDsxAB7iMJoIZvc0gHoJQYCfqowdn+
         o6quSz0pB2g1M08KxyY3mYOev6VYRhFqMUBz9MEohL+207WCAE+NDDbxTp6e6OMYeat3
         TWdQ==
X-Gm-Message-State: AOAM530IIqNRKkVbPWmT8aZP2Zz0B1I6/I6kqZZcsTqeIJtGvblEx9c6
        dc9vQumzwm0y2tKyVk3LKAw=
X-Google-Smtp-Source: ABdhPJzuDBwBHXkPJycXXSymAJku1jhhJhcZqkIR4+xQBz6Txxo+stOLhiH0h7GWAFUsp1dPHeNalA==
X-Received: by 2002:a05:6808:3aa:: with SMTP id n10mr4364978oie.16.1611344711179;
        Fri, 22 Jan 2021 11:45:11 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id m16sm1937232otr.27.2021.01.22.11.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 11:45:10 -0800 (PST)
Date:   Fri, 22 Jan 2021 11:45:08 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>, enkechen2020@gmail.com
Subject: Re: [PATCH] tcp: keepalive fixes
Message-ID: <20210122194508.GB99540@localhost.localdomain>
References: <20210112192544.GA12209@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112192544.GA12209@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Folks:

Please ignore this patch. I will split it into separate ones as suggested
off-list by Neal Cardwell <ncardwell@google.com>.

Thanks.  -- Enke

On Tue, Jan 12, 2021 at 11:25:44AM -0800, Enke Chen wrote:
> From: Enke Chen <enchen@paloaltonetworks.com>
> 
> In this patch two issues with TCP keepalives are fixed:
> 
> 1) TCP keepalive does not timeout when there are data waiting to be
>    delivered and then the connection got broken. The TCP keepalive
>    timeout is not evaluated in that condition.
> 
>    The fix is to remove the code that prevents TCP keepalive from
>    being evaluated for timeout.
> 
> 2) With the fix for #1, TCP keepalive can erroneously timeout after
>    the 0-window probe kicks in. The 0-window probe counter is wrongly
>    applied to TCP keepalives.
> 
>    The fix is to use the elapsed time instead of the 0-window probe
>    counter in evaluating TCP keepalive timeout.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
> ---
>  net/ipv4/tcp_timer.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index 6c62b9ea1320..40953aa40d53 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -696,12 +696,6 @@ static void tcp_keepalive_timer (struct timer_list *t)
>  	    ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_SYN_SENT)))
>  		goto out;
>  
> -	elapsed = keepalive_time_when(tp);
> -
> -	/* It is alive without keepalive 8) */
> -	if (tp->packets_out || !tcp_write_queue_empty(sk))
> -		goto resched;
> -
>  	elapsed = keepalive_time_elapsed(tp);
>  
>  	if (elapsed >= keepalive_time_when(tp)) {
> @@ -709,16 +703,15 @@ static void tcp_keepalive_timer (struct timer_list *t)
>  		 * to determine when to timeout instead.
>  		 */
>  		if ((icsk->icsk_user_timeout != 0 &&
> -		    elapsed >= msecs_to_jiffies(icsk->icsk_user_timeout) &&
> -		    icsk->icsk_probes_out > 0) ||
> +		     elapsed >= msecs_to_jiffies(icsk->icsk_user_timeout)) ||
>  		    (icsk->icsk_user_timeout == 0 &&
> -		    icsk->icsk_probes_out >= keepalive_probes(tp))) {
> +		     (elapsed >= keepalive_time_when(tp) +
> +		      keepalive_intvl_when(tp) * keepalive_probes(tp)))) {
>  			tcp_send_active_reset(sk, GFP_ATOMIC);
>  			tcp_write_err(sk);
>  			goto out;
>  		}
>  		if (tcp_write_wakeup(sk, LINUX_MIB_TCPKEEPALIVE) <= 0) {
> -			icsk->icsk_probes_out++;
>  			elapsed = keepalive_intvl_when(tp);
>  		} else {
>  			/* If keepalive was lost due to local congestion,
> @@ -732,8 +725,6 @@ static void tcp_keepalive_timer (struct timer_list *t)
>  	}
>  
>  	sk_mem_reclaim(sk);
> -
> -resched:
>  	inet_csk_reset_keepalive_timer (sk, elapsed);
>  	goto out;
>  
> -- 
> 2.29.2
> 
