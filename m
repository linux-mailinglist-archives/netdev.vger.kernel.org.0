Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD845FAF14
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 11:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJKJIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 05:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiJKJH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 05:07:58 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15A56FA3F
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 02:07:52 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a67so9834526edf.12
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 02:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b/ZgLQmwlLpR7BP/HZx0/elrquvDc9b0uAx+8zCGxg8=;
        b=YULsQdqKRwxDtfbd+UwayqrR6/D5/QJXMMM+TzRdt6JV1sI8vZ2W8lImEuBaCVYxsL
         3A1PjGQF63PiSRnGt+vi3t5U7hx1q+WSx4CZWZR7uBp9POm1qCB3LwcFYD2bWA6Y8y71
         l6dUVa+WsQpvURk3afJ8MLWxfkhV5ZsU0Yy7zJIDUWT0oxEJW/WUpjGMirO18quV+fmN
         eDCZ6q5ZZhPR8mvJBWim8ahs4Kzmz4XnVXBtJZgjVzPfSCEeQWyO9jkPyMT2WAOdgoAl
         wZJyDL/f2JCthJK/BfB509XerxhTpYObL+CyXmZYC0pNpB5u9WKMV0yu0GZ4CyS0ZHBN
         5opA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/ZgLQmwlLpR7BP/HZx0/elrquvDc9b0uAx+8zCGxg8=;
        b=twyAHYKdFadVyb1vdF/kHKImuvnx8NpQ3RWnB4WqrR8yzfiRTteHD1Ox9O30IFSdsH
         VnsuMidMQ9+FZb7E/PGaz9/G8wmIkcq6f2KrdcNTc8wAA/1aNgWZhEGb1GhaNxwIp1LG
         CdY1t+AAT/hxwTd4WPWcKyZu4Qhn8Jbw+uno2J1+kJg/Wh/XIQPG9KhRwt8y3oEnVkJt
         WsIhqa7PNVV+/odL/tgHjtXaGYV1JD4eTpe+RT0+5IEhvDkU4y5V/Olh1lyQMFzpYQpD
         +1bBQZSSDOYPVPug1GHyo03mvO4NVt+7UTfv5tIG2lal6NYlv3dABBjr/PM1GG1Efpzf
         pnRQ==
X-Gm-Message-State: ACrzQf3CJACwM8nB7fznn4RSzBCXfjL6lfukQ3yDGRXPL821jNQKzH6g
        htp0LVqniNirmdARvCl8Uf07UA==
X-Google-Smtp-Source: AMsMyM7MG0fWzRVIv4pvKfKvWW83ZWU2A/ckdbwacSE3yaGM9sapVpPmeg83bdb0GGlIjHNw3u1LKw==
X-Received: by 2002:a05:6402:50d1:b0:45a:fc:86f4 with SMTP id h17-20020a05640250d100b0045a00fc86f4mr22345173edb.344.1665479270986;
        Tue, 11 Oct 2022 02:07:50 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v8-20020aa7d9c8000000b00458478a4295sm8713180eds.9.2022.10.11.02.07.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 02:07:50 -0700 (PDT)
Message-ID: <6b7dda54-bf07-4784-d675-2db26eec3ddf@blackwall.org>
Date:   Tue, 11 Oct 2022 12:07:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH ipsec] xfrm: lwtunnel: squelch kernel warning in case XFRM
 encap type is not available
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, idosch@idosch.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org
References: <20221011080137.440419-1-eyal.birger@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221011080137.440419-1-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/2022 11:01, Eyal Birger wrote:
> Ido reported that a kernel warning [1] can be triggered from
> user space when the kernel is compiled with CONFIG_MODULES=y and
> CONFIG_XFRM=n when adding an xfrm encap type route, e.g:
> 
> $ ip route add 198.51.100.0/24 dev dummy1 encap xfrm if_id 1
> Error: lwt encapsulation type not supported.
> 
> The reason for the warning is that the LWT infrastructure has an
> autoloading feature which is meant only for encap types that don't
> use a net device,  which is not the case in xfrm encap.
> 
> Mute this warning for xfrm encap as there's no encap module to autoload
> in this case.
> 
> [1]
>  WARNING: CPU: 3 PID: 2746262 at net/core/lwtunnel.c:57 lwtunnel_valid_encap_type+0x4f/0x120
> [...]
>  Call Trace:
>   <TASK>
>   rtm_to_fib_config+0x211/0x350
>   inet_rtm_newroute+0x3a/0xa0
>   rtnetlink_rcv_msg+0x154/0x3c0
>   netlink_rcv_skb+0x49/0xf0
>   netlink_unicast+0x22f/0x350
>   netlink_sendmsg+0x208/0x440
>   ____sys_sendmsg+0x21f/0x250
>   ___sys_sendmsg+0x83/0xd0
>   __sys_sendmsg+0x54/0xa0
>   do_syscall_64+0x35/0x80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Fixes: 2c2493b9da91 ("xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> ---
>  net/core/lwtunnel.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
> index 6fac2f0ef074..711cd3b4347a 100644
> --- a/net/core/lwtunnel.c
> +++ b/net/core/lwtunnel.c
> @@ -48,9 +48,11 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
>  		return "RPL";
>  	case LWTUNNEL_ENCAP_IOAM6:
>  		return "IOAM6";
> +	case LWTUNNEL_ENCAP_XFRM:
> +		/* module autoload not supported for encap type */
> +		return NULL;
>  	case LWTUNNEL_ENCAP_IP6:
>  	case LWTUNNEL_ENCAP_IP:
> -	case LWTUNNEL_ENCAP_XFRM:
>  	case LWTUNNEL_ENCAP_NONE:
>  	case __LWTUNNEL_ENCAP_MAX:
>  		/* should not have got here */

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

