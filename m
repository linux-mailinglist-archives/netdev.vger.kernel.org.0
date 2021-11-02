Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721F9443838
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 23:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhKBWJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 18:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhKBWJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 18:09:10 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFA9C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 15:06:34 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 127so356501pfu.1
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 15:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1yikQeqtiI0JZsCV4SFX8wbhKVZf5bHfeYArTFQzeRA=;
        b=aUazuI9sb6aaLyNMKJk1Bt7BOttNMoadxHivs7ZSsH46qDCaTwBEgXcC+V6vbnQPso
         ObBXhVQaI2ThZ21G/SKQr3LItrWPfE9uKkKtnBWw+ibH0Hz0jEJpkpWUkfKaxMne5Sdi
         82ZtXOtbAArebOVqqKHqWZ5SrAxoL1JeGG1RY596F/pO3q/Cl9fyG8kTEDsepHaNVCuV
         qt0yLYHSCctvTg549q5O3/2J/6HDqgdsmIonJnUAAOHthmK4La4EKEz1pwzSdVsTglSy
         pcx0tmaIvMp+kDt8CfBVOtD8C/eFCoy19FWT6ph1a6lIYnic51PZ/Q6g951nZuqpgnO1
         1wpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1yikQeqtiI0JZsCV4SFX8wbhKVZf5bHfeYArTFQzeRA=;
        b=J8YfBFJIHUrwSyMzvs9+hgJcBVQKMeuSUFKMpLDIjKOO8t4ba5HX4aba8Oh9a9LrtZ
         NfQFGG/zaqTTh1CTy5EwHFTtBTBl1Ex/GGDLLX+uDBg/JIt8S3gzjtuXrPyihniAni+d
         wxm4/Zn59VZRe884CcqbZ34ky8NCIxTSV9awYKGsdloW1MmWFQlTbYbrLGTuX8BRyJEQ
         AY2bACj8XIS6PocQ0OO6VGLcDos8t/5Ppx5/CTegQziDFhWIRiOeVcxoFk8r6XJoi6Gn
         evTHAIImyf2lyuETraV207zMao5Pr6b72PV8iihkiuJ6RogB+CGULXjum8kgd9Jkz8GQ
         XqbQ==
X-Gm-Message-State: AOAM532O/X0uGR1eFRmeAx1Df/o4VZcYCa5kaVlhPmBdoVrRxGJL3IpO
        C8xJGYc7/xqyoUj6v8h9ISY=
X-Google-Smtp-Source: ABdhPJzF2jSWezpPiNQLRM+9qqzXqkJFePdl/Zb/HfghE8AYvda5JwsNs1ap/eceULuYFJTeN98n+Q==
X-Received: by 2002:aa7:8d88:0:b0:47b:d965:fbb2 with SMTP id i8-20020aa78d88000000b0047bd965fbb2mr40443590pfr.16.1635890794553;
        Tue, 02 Nov 2021 15:06:34 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:222a:b43d:7197:aca3? ([2620:15c:2c1:200:222a:b43d:7197:aca3])
        by smtp.gmail.com with ESMTPSA id h3sm3429303pjz.43.2021.11.02.15.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 15:06:33 -0700 (PDT)
Subject: Re: [PATCH v2] tcp: Use BPF timeout setting for SYN ACK RTO
To:     Akhmat Karakotov <hmukos@yandex-team.ru>, eric.dumazet@gmail.com
Cc:     brakmo@fb.com, mitradir@yandex-team.ru, ncardwell@google.com,
        netdev@vger.kernel.org, ycheng@google.com, zeil@yandex-team.ru
References: <863fdf13-b1f4-f429-d8ac-269f9ceaa747@gmail.com>
 <20211102183235.14679-1-hmukos@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <eb593fea-b5a5-c871-a762-a48127e91f75@gmail.com>
Date:   Tue, 2 Nov 2021 15:06:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211102183235.14679-1-hmukos@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/21 11:32 AM, Akhmat Karakotov wrote:
> When setting RTO through BPF program, some SYN ACK packets were unaffected
> and continued to use TCP_TIMEOUT_INIT constant. This patch adds timeout
> option to struct request_sock. Option is initialized with TCP_TIMEOUT_INIT
> and is reassigned through BPF using tcp_timeout_init call. SYN ACK
> retransmits now use newly added timeout option.
> 
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>  include/net/request_sock.h      | 2 ++
>  net/ipv4/inet_connection_sock.c | 2 +-
>  net/ipv4/tcp_input.c            | 8 +++++---
>  net/ipv4/tcp_minisocks.c        | 4 ++--
>  4 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> index 29e41ff3ec93..144c39db9898 100644
> --- a/include/net/request_sock.h
> +++ b/include/net/request_sock.h
> @@ -70,6 +70,7 @@ struct request_sock {
>  	struct saved_syn		*saved_syn;
>  	u32				secid;
>  	u32				peer_secid;
> +	u32				timeout;
>  };
>  
>  static inline struct request_sock *inet_reqsk(const struct sock *sk)
> @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
>  	sk_node_init(&req_to_sk(req)->sk_node);
>  	sk_tx_queue_clear(req_to_sk(req));
>  	req->saved_syn = NULL;
> +	req->timeout = 0;
>  	req->num_timeout = 0;
>  	req->num_retrans = 0;
>  	req->sk = NULL;
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 0d477c816309..c43cc1f22092 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -870,7 +870,7 @@ static void reqsk_timer_handler(struct timer_list *t)
>  
>  		if (req->num_timeout++ == 0)
>  			atomic_dec(&queue->young);
> -		timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
> +		timeo = min(req->timeout << req->num_timeout, TCP_RTO_MAX);

I wonder how much time it will take to syzbot to trigger an overflow here and
other parts.

(Not sure BPF_SOCK_OPS_TIMEOUT_INIT has any sanity checks)

Maybe take the opportunity of this patch to use wider type

     timeo = min_t(unsigned long,
                   (unsigned long)req->timeout << req->num_timeout,
                   TCP_RTO_MAX);

Overall, your patch looks good to me, thanks.

