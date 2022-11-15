Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FAB62978E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiKOLhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKOLhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:37:34 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC9924BEB
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:37:32 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id k8so23794020wrh.1
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YiLRB+no6Obv7jh7c1l04K32ySwQNOr1SFbZK57JYcE=;
        b=Iud274mEKb6gZLmUkIMS0HEBSJoqBMdOKEfk8qwd2MtJLczLjJRzoaL8507alqoL3D
         Ov+cYEcS0L3k3LmCx17JcRv/B0ThjUgCbfaVyFM4lj77nww8ID8Ub2JJEDSRF43PDVYm
         GUPab/bDvGz/S+KHx2O9YWpKHqF/3mmrIzJydxoJW3zQmciG7vttQrlhepL07+p8+iHr
         q+k6sgMxuo+ajcoNjwpOwEMi0wL3CqwP8zTBTZ3oh5PH1l2wxHZwcP5QMoaCGP3t4HpB
         m67QPaxcrGiGeb3aEyZ4QVK4Fv7XfllRt14Nm1YzBk9ydpIXMzvX5LNDhOCmfBb28fYX
         EzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YiLRB+no6Obv7jh7c1l04K32ySwQNOr1SFbZK57JYcE=;
        b=O4lQuPLMcd/eTRmqFwvMY/p12KRouOvN4whhD+SlNvWd5PgRHRLKGqUjBgxPoLu+ZT
         zEMkE0fmzA87SVlAInEu8HuZ8MPjiZVvqPMNA2ZmYigBSv0q7So5In099TfCw9wGT1HF
         m/zUx7FEunaTbqYVVziFUXVbFMNfRTF/2KlJj78Mj0L+2ejIqf4VhtH8tLSfTNld5rSJ
         Ic8f7LCbhF1NzGz73RE5RLYJ4lYsab6PwN/sVn7L7flRnGBHvrXENy0R3oSma4ULoz4S
         f4T6aMg2qH9v6eOt4R8zfJSEc9Y1rCALabdSP/YR6CfVtWG0ca7hGx1dl7ImKWYHAdHc
         8XMQ==
X-Gm-Message-State: ANoB5plSgRaxK6vUwEtGff2PyP7AvfutWVr6Lmwu4KV+lT51M0h7k7hC
        IwwpGn9bv8d5YvOy79QFbux6RA==
X-Google-Smtp-Source: AA0mqf5qQyE4X+bB4glzYTYH+BISGK/zPAZumkOCxi5PxxgM1BHiuI2Ydnt36gENgeklnQHyuR9VNQ==
X-Received: by 2002:a5d:49c9:0:b0:236:73fa:c56e with SMTP id t9-20020a5d49c9000000b0023673fac56emr10351544wrs.432.1668512251354;
        Tue, 15 Nov 2022 03:37:31 -0800 (PST)
Received: from ?IPV6:2a02:578:8593:1200:765b:95ed:f124:a78a? ([2a02:578:8593:1200:765b:95ed:f124:a78a])
        by smtp.gmail.com with ESMTPSA id u12-20020adfdb8c000000b002417ed67bfdsm9112478wri.5.2022.11.15.03.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 03:37:30 -0800 (PST)
Message-ID: <f3765a0c-1f57-e244-002e-148c88407f31@tessares.net>
Date:   Tue, 15 Nov 2022 12:37:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH net-next] tcp: Fix tcp_syn_flood_action() if CONFIG_IPV6=n
Content-Language: en-GB
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Down <chris@chrisdown.name>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On 15/11/2022 11:12, Geert Uytterhoeven wrote:
> If CONFIG_IPV6=n:
> 
>     net/ipv4/tcp_input.c: In function ‘tcp_syn_flood_action’:
>     include/net/sock.h:387:37: error: ‘const struct sock_common’ has no member named ‘skc_v6_rcv_saddr’; did you mean ‘skc_rcv_saddr’?
>       387 | #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
> 	  |                                     ^~~~~~~~~~~~~~~~
>     include/linux/printk.h:429:19: note: in definition of macro ‘printk_index_wrap’
>       429 |   _p_func(_fmt, ##__VA_ARGS__);    \
> 	  |                   ^~~~~~~~~~~
>     include/linux/printk.h:530:2: note: in expansion of macro ‘printk’
>       530 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
> 	  |  ^~~~~~
>     include/linux/net.h:272:3: note: in expansion of macro ‘pr_info’
>       272 |   function(__VA_ARGS__);    \
> 	  |   ^~~~~~~~
>     include/linux/net.h:288:2: note: in expansion of macro ‘net_ratelimited_function’
>       288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
> 	  |  ^~~~~~~~~~~~~~~~~~~~~~~~
>     include/linux/net.h:288:43: note: in expansion of macro ‘sk_v6_rcv_saddr’
>       288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
> 	  |                                           ^~~~~~~~~~~
>     net/ipv4/tcp_input.c:6847:4: note: in expansion of macro ‘net_info_ratelimited’
>      6847 |    net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
> 	  |    ^~~~~~~~~~~~~~~~~~~~
> 
> Fix this by using "#if" instead of "if", like is done for all other
> checks for CONFIG_IPV6.

Thank you for the patch!

Our CI validating MPTCP also found the issue. I was going to suggest a
similar one before I saw yours :)

Everything is fixed on my side after having applied the patch!

Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>

> Fixes: d9282e48c6088105 ("tcp: Add listening address to SYN flood message")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  net/ipv4/tcp_input.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 94024fdc2da1b28a..e5d7a33fac6666bb 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6843,11 +6843,14 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
>  
>  	if (!queue->synflood_warned && syncookies != 2 &&
>  	    xchg(&queue->synflood_warned, 1) == 0) {
> -		if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
> +#if IS_ENABLED(CONFIG_IPV6)
> +		if (sk->sk_family == AF_INET6) {
>  			net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
>  					proto, &sk->sk_v6_rcv_saddr,
>  					sk->sk_num, msg);
> -		} else {
> +		} else
> +#endif
> +		{

I was going to suggest to remove the unneeded braces here and just
before + eventually fix the indentation under net_info_ratelimited()
while at it but that's just some details not directly linked to the fix
here.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
