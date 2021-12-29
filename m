Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C0148169F
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 21:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhL2USk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 15:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhL2USj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 15:18:39 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C1AC061574;
        Wed, 29 Dec 2021 12:18:39 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id s6so18404373ioj.0;
        Wed, 29 Dec 2021 12:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mdewPX2NhL5XIdAH2F9gutx5cIX0YtwI8mJR330IoW0=;
        b=cg7tzT+4xZAt+T/9NeXhseUnCMgrBQ2dT3SxbAQP2f9QdLAdHDvDGUJkHQcC36qgl3
         Cb0V/9gjGdfVqrPvmv/CM/X04n0fUQme42HN4vx544HxcGBnZ+3aYx/o8gEyz4sDU1PK
         RC2I4z/TWMr6OBBefHRCPaBwZADsuEzZb51x1oN4QzVDzwCH68UKWRtUJFlTd0/mpX2i
         WkzicnedpEkoJWaLbDKSgQEifTHyq92nThx1GFqpITmDmeE8+dypANQhM79aQsvpM+O0
         7x/ZQWWUa6cRL8q6LgGlSmtme0dTqh0zZ43ZnhLK9CSw22euovyarzyBD/wLZD/fsIWO
         N3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mdewPX2NhL5XIdAH2F9gutx5cIX0YtwI8mJR330IoW0=;
        b=R9qDZdXfd6AheY9GvNr6MZgdH3kFVkxHy1esUrvt0YtoaB45c0fwhnCHBtr9hZ2uSE
         GYVfIapmmqiRGGVoqpwsvY5yLJLOtPPbVmcYvWptFJBiPlq8qa3V3T/Pm4w4YkEuYHJ2
         AqVqX1QMkBmqqMoUkvBb1+1sjQwGcUeCUNdvpXbct1Mij7GUKLgoNXXXfjG2K73kNO1K
         GpYKTvyUnWLX7bYJWLrJ3LIFZH61/Na2POqNwdln+UfvWUUHQ9Nqy7+ahLWMeU1K6WnF
         qVfDQWSH3mXnLyPLPjOdTI05vnkjox9Zr5z4dtjV9MnfJG+QF9MioICRgBZLEL1FU8BZ
         r3cQ==
X-Gm-Message-State: AOAM530+4x9twSwAMTp00iGIvRxXShecncgOSC0vluuEhYcywyES4iGv
        rt+hZAAjHXqcgyZK489UtJQ=
X-Google-Smtp-Source: ABdhPJyu4sJLiQSYwYQSNinYTFNUkOwaowb2bmDvTdQSBUTrjqaCukeiE0mDfTpzBftZSf4lmr+ypQ==
X-Received: by 2002:a02:cf39:: with SMTP id s25mr11735675jar.17.1640809119139;
        Wed, 29 Dec 2021 12:18:39 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id n2sm13690620ioc.0.2021.12.29.12.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Dec 2021 12:18:38 -0800 (PST)
Message-ID: <c3582b56-905c-b6bf-e92e-e6d81ae9f2e0@gmail.com>
Date:   Wed, 29 Dec 2021 13:18:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH net-next 2/2] net: skb: use kfree_skb_with_reason() in
 tcp_v4_rcv()
Content-Language: en-US
To:     menglong8.dong@gmail.com, rostedt@goodmis.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        cong.wang@bytedance.com, pabeni@redhat.com, talalahmad@google.com,
        haokexin@gmail.com, keescook@chromium.org, imagedong@tencent.com,
        atenart@kernel.org, bigeasy@linutronix.de, weiwan@google.com,
        arnd@arndb.de, vvs@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211229143205.410731-1-imagedong@tencent.com>
 <20211229143205.410731-3-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211229143205.410731-3-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/29/21 7:32 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() with kfree_skb_with_reason() in tcp_v4_rcv().
> Following drop reason are added:
> 
> SKB_DROP_REASON_NO_SOCK
> SKB_DROP_REASON_BAD_PACKET
> SKB_DROP_REASON_TCP_CSUM
> 
> After this patch, 'kfree_skb' event will print message like this:
> 
> $           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
> $              | |         |   |||||     |         |
>           <idle>-0       [000] ..s1.    36.113438: kfree_skb: skbaddr=(____ptrval____) protocol=2048 location=(____ptrval____) reason: NO_SOCK
> 
> The reason of skb drop is printed too.
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/skbuff.h     |  3 +++
>  include/trace/events/skb.h |  3 +++
>  net/ipv4/tcp_ipv4.c        | 10 ++++++++--

your first patch set was targeting UDP and now you are starting with tcp?


>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 3620b3ff2154..f85db6c035d1 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -313,6 +313,9 @@ struct sk_buff;
>   */
>  enum skb_drop_reason {
>  	SKB_DROP_REASON_NOT_SPECIFIED,
> +	SKB_DROP_REASON_NO_SOCK,

SKB_DROP_REASON_NO_SOCKET

> +	SKB_DROP_REASON_BAD_PACKET,

SKB_DROP_REASON_PKT_TOO_SMALL

User oriented messages, not code based.


> +	SKB_DROP_REASON_TCP_CSUM,
>  	SKB_DROP_REASON_MAX,
>  };
>  
> diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> index cab1c08a30cd..b9ea6b4ed7ec 100644
> --- a/include/trace/events/skb.h
> +++ b/include/trace/events/skb.h
> @@ -11,6 +11,9 @@
>  
>  #define TRACE_SKB_DROP_REASON					\
>  	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
> +	EM(SKB_DROP_REASON_NO_SOCK, NO_SOCK)			\
> +	EM(SKB_DROP_REASON_BAD_PACKET, BAD_PACKET)		\
> +	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
>  	EMe(SKB_DROP_REASON_MAX, HAHA_MAX)
>  
>  #undef EM
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index ac10e4cdd8d0..03dc4c79b84b 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1971,8 +1971,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
>  	const struct tcphdr *th;
>  	bool refcounted;
>  	struct sock *sk;
> +	int drop_reason;
>  	int ret;
>  
> +	drop_reason = 0;

	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;

