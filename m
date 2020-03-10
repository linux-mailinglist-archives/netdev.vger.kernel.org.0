Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AED017EF89
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 05:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgCJEF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 00:05:28 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53090 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgCJEF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 00:05:28 -0400
Received: by mail-pj1-f65.google.com with SMTP id f15so827916pjq.2
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 21:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FIXZWkLWjcldgS9NI+luv0U91MQgejqSX4i1PgBtp2g=;
        b=sBRmd/elcU7DYE99JzUVY8wpmeddUBjle0lhLrLSEcS4hxl0tACwVgqpmSi87BWRNj
         dnAkxsukIfhy8K8MFfDzcoV24tudjz4Fk5sQJXiCx2uFydXAYa6JKfKkZ1ESC1f0g6lt
         sbeznCe6RETqiLRR58BIy/kMKMrzwIqN9/PALH+emsdc9BXG8WWxJPS0h7lRfi6d+xKc
         qLmGCiY1QgugA37qIrQ4lFXgfeMyppgjU65B08UlmYwHhO6HDiDNBnUwez0SsQVHMAq8
         IH4tzqEj4F6Ycq8gx0rtL3NdHL8xdr2UO3e1HHpr2/zMzhIZNIo6MUpvcXh0sgzSS9Rn
         GYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FIXZWkLWjcldgS9NI+luv0U91MQgejqSX4i1PgBtp2g=;
        b=LblJAL2hmU764xwHbQdRaC6U8zv1xjPulkAhHiIJ3MIRC8ybJP79uigmS29fO2ULta
         5w6QUEporCveI2ZkTMUfdm9Y0TvIu1bhrByPC+RYvwq61oOu91s7mXW9TIwjfkEbPvSk
         aHKDD8x1CVw0Y5sD9llQxvlQFROKqDZrDdrsWwvw2qzbRP5AHe9TGnUmmpC31q9EGN/R
         /adHDi5wjLG+IOp6v14iRQVaxEcg6Cz6XZtgkcbywZR7bPNqn05ygTS29RlWRhrnFjyP
         P/ZkSMJC2vUq3PHsmmCeFvwRaga7wOs4ObJGAAEiD2V4BHw7SAlH1FulIlJbBKV24lHj
         Bhmg==
X-Gm-Message-State: ANhLgQ0dPlGfqBgs8LIgwxx7dGNLaRqQ27HyU08nvBfkbV2w9g33ob17
        CBJEEhA51hvLIv6Lgs5l42Y=
X-Google-Smtp-Source: ADFU+vuJrfhjAcVNw50OcvuXJtcAuzgWBgP2CcHCS09/SMGfUAKIhK9DP5cNNamLoHlAI3VNRg/rgQ==
X-Received: by 2002:a17:90a:7345:: with SMTP id j5mr2623669pjs.69.1583813126841;
        Mon, 09 Mar 2020 21:05:26 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x9sm15496154pfa.188.2020.03.09.21.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 21:05:25 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 4/5] net: Add net.ipv4.ip_autobind_reuse
 option.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     kuni1840@gmail.com, netdev@vger.kernel.org,
        osa-contribution-log@amazon.com
References: <20200308181615.90135-1-kuniyu@amazon.co.jp>
 <20200308181615.90135-5-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <50c321f8-1563-2b7a-4b14-f71f48858bfd@gmail.com>
Date:   Mon, 9 Mar 2020 21:05:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200308181615.90135-5-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/20 11:16 AM, Kuniyuki Iwashima wrote:
> The two commits("tcp: bind(addr, 0) remove the SO_REUSEADDR restriction
> when ephemeral ports are exhausted" and "tcp: Forbid to automatically bind
> more than one sockets haveing SO_REUSEADDR and SO_REUSEPORT per EUID")
> introduced the new feature to reuse ports with SO_REUSEADDR when all
> ephemeral pors are exhausted. They allow connect() and listen() to share
> ports in the following way.
> 
>   1. setsockopt(sk1, SO_REUSEADDR)
>   2. setsockopt(sk2, SO_REUSEADDR)
>   3. bind(sk1, saddr, 0)
>   4. bind(sk2, saddr, 0)
>   5. connect(sk1, daddr)
>   6. listen(sk2)

Honestly, IP_BIND_ADDRESS_NO_PORT makes all these problems go away.


> 
> In this situation, new socket cannot be bound to the port, but sharing
> port between connect() and listen() may break some applications. The
> ip_autobind_reuse option is false (0) by default and disables the feature.
> If it is set true, we can fully utilize the 4-tuples.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  Documentation/networking/ip-sysctl.txt | 7 +++++++
>  include/net/netns/ipv4.h               | 1 +
>  net/ipv4/inet_connection_sock.c        | 2 +-
>  net/ipv4/sysctl_net_ipv4.c             | 7 +++++++
>  4 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index 5f53faff4e25..9506a67a33c4 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -958,6 +958,13 @@ ip_nonlocal_bind - BOOLEAN
>  	which can be quite useful - but may break some applications.
>  	Default: 0
>  
> +ip_autobind_reuse - BOOLEAN
> +	By default, bind() does not select the ports automatically even if
> +	the new socket and all sockets bound to the port have SO_REUSEADDR.
> +	ip_autobind_reuse allows bind() to reuse the port and this is useful
> +	when you use bind()+connect(), but may break some applications.

I would mention that the preferred solution is to use IP_BIND_ADDRESS_NO_PORT,
which is fully supported, and that this sysctl should only be set by experts.

> +	Default: 0
> +
>  ip_dynaddr - BOOLEAN
>  	If set non-zero, enables support for dynamic addresses.
>  	If set to a non-zero value larger than 1, a kernel log
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index 08b98414d94e..154b8f01499b 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -101,6 +101,7 @@ struct netns_ipv4 {
>  	int sysctl_ip_fwd_use_pmtu;
>  	int sysctl_ip_fwd_update_priority;
>  	int sysctl_ip_nonlocal_bind;
> +	int sysctl_ip_autobind_reuse;
>  	/* Shall we try to damage output packets if routing dev changes? */
>  	int sysctl_ip_dynaddr;
>  	int sysctl_ip_early_demux;
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index d27ed5fe7147..3b4f81790e3e 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -246,7 +246,7 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
>  		goto other_half_scan;
>  	}
>  
> -	if (!relax) {
> +	if (net->ipv4.sysctl_ip_autobind_reuse && !relax) {
>  		/* We still have a chance to connect to different destinations */
>  		relax = true;
>  		goto ports_exhausted;
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 9684af02e0a5..3b191764718b 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -775,6 +775,13 @@ static struct ctl_table ipv4_net_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec
>  	},
> +	{
> +		.procname	= "ip_autobind_reuse",
> +		.data		= &init_net.ipv4.sysctl_ip_autobind_reuse,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec

.proc_handler = proc_dointvec_minmax,
.extra1         = SYSCTL_ZERO,
.extra2         = SYSCTL_ONE,



> +	},
>  	{
>  		.procname	= "fwmark_reflect",
>  		.data		= &init_net.ipv4.sysctl_fwmark_reflect,
> 
