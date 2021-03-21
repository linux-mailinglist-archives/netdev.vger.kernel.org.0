Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C541343368
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 17:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCUQVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 12:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhCUQUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 12:20:46 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C1BC061574;
        Sun, 21 Mar 2021 09:20:46 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id l79so10558523oib.1;
        Sun, 21 Mar 2021 09:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cfcUNLePtW8MPQQ2B7OfYoM3P1f+j0I9OKeJbS48TwQ=;
        b=PMtNIBY+Ocru/4Xdd5QdbsKW7hFgvTMs4aP0ooLbCH7TzT5B7jCm2GQdDFkjlGqDOu
         /7bvsKjeh+GqH2z8kB1XJIesP86MN0NV7YgYLzVdO3icrQ2T6NwV9/yvwf7tHp1r+N42
         sNCZU3SYjn3y61VNArOYY+fJ4APpSU1nAo1Q2YDG7DCM1j7Ycs3mRGT+aoHg4pN9H6zm
         PAWsyc1e1Y5AFt+Enx9P+XsKjPHbk7zbfj0qQbXGQsfRlNUnqNJuPgUBkgyOqJSDRa/k
         4stfYCpKm98kMef3yZdZRAQ5jWvlO23qHfqwXf19j8DGZF+3gxHXvo+lDBH4Cl4I67Yt
         gOYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cfcUNLePtW8MPQQ2B7OfYoM3P1f+j0I9OKeJbS48TwQ=;
        b=J/W6kMkxsqAO8w4D/rSGTvVXZioLC5DkfIjVeK0zwC4kQ84+YhUy6QDcR5o77de/CI
         CQHZygnP7s0eZBxVTsmdxIgiihXb/jVAHEIpwbBaFlDzHCQhUAj62dvif0nZfJ+md3xu
         UfC5KA/82FKAK4uDFBlGu8ttJV9fIQtf5G0qwhgnxL8LUESNkhEqH6pEvpx1/5pIBFN+
         iXJLjWFjCckai0n9WnpgvplUA+beNtOyl0o0jZX2eLaNRSivKVTi4UkFu9NLGKlohk11
         7iQwrWGAwUZhSywm8Wmo1OsS57MDrJyv0h+udDM8+guCIZJFcPmufLRRUypL3VnD6aJr
         Oe/Q==
X-Gm-Message-State: AOAM531RirNGn6M+/aRsFEOqJ47gQEZCiVyqvJQVHHgwLgaKvE/04GlL
        JlsDZ2nNlgWw+g0QOu1rhztitWgbtc0=
X-Google-Smtp-Source: ABdhPJx+EZobCNzJOEDjnzy9+H8HPtGRCIrOP0WLgS1dT2z9q35/LOdxZHeriwdvWsDYpn9wnFWswA==
X-Received: by 2002:a05:6808:1482:: with SMTP id e2mr7467227oiw.138.1616343645620;
        Sun, 21 Mar 2021 09:20:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g6sm2537848ooh.29.2021.03.21.09.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 09:20:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] net: socket: change MSG_CMSG_COMPAT to
 BIT(21)
To:     menglong8.dong@gmail.com, herbert@gondor.apana.org.au,
        andy.shevchenko@gmail.com, kuba@kernel.org, David.Laight@aculab.com
Cc:     davem@davemloft.net, dong.menglong@zte.com.cn,
        viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20210321134357.148323-1-dong.menglong@zte.com.cn>
 <20210321134357.148323-3-dong.menglong@zte.com.cn>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <c9d708cd-f38a-01bf-2b1a-d3047a2248b1@roeck-us.net>
Date:   Sun, 21 Mar 2021 09:20:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210321134357.148323-3-dong.menglong@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/21 6:43 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> Currently, MSG_CMSG_COMPAT is defined as '1 << 31'. However, 'msg_flags'
> is defined with type of 'int' somewhere, such as 'packet_recvmsg' and
> other recvmsg functions:
> 
> static int packet_recvmsg(struct socket *sock, struct msghdr *msg,
> 			  size_t len,
> 			  int flags)
> 
> If MSG_CMSG_COMPAT is set in 'flags', it's value will be negative.
> Once it perform bit operations with MSG_*, the upper 32 bits of
> the result will be set, just like what Guenter Roeck explained
> here:
> 
> https://lore.kernel.org/netdev/20210317013758.GA134033@roeck-us.net
> 
> As David Laight suggested, fix this by change MSG_CMSG_COMPAT to
> some value else. MSG_CMSG_COMPAT is an internal value, which is't
> used in userspace, so this change works.
> 

Maybe I am overly concerned (or maybe call it pessimistic),
but I do wonder if this change is worth the added risk. Personally
I'd rather start changing all 'int flag' uses to 'unsigned int flag'
and, only after that is complete, make the switch to BIT().

Of course, that is just my personal opinion, and, as I said,
I may be overly concerned.

Guenter

> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> ---
> v2:
> - add comment to stop people from trying to use BIT(31)
> ---
>  include/linux/socket.h | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index d5ebfe30d96b..61b2694d68dd 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -312,17 +312,21 @@ struct ucred {
>  					 * plain text and require encryption
>  					 */
>  
> +#if defined(CONFIG_COMPAT)
> +#define MSG_CMSG_COMPAT		BIT(21)	/* This message needs 32 bit fixups */
> +#else
> +#define MSG_CMSG_COMPAT		0	/* We never have 32 bit fixups */
> +#endif
> +
>  #define MSG_ZEROCOPY		BIT(26)	/* Use user data in kernel path */
>  #define MSG_FASTOPEN		BIT(29)	/* Send data in TCP SYN */
>  #define MSG_CMSG_CLOEXEC	BIT(30)	/* Set close_on_exec for file
>  					 * descriptor received through
>  					 * SCM_RIGHTS
>  					 */
> -#if defined(CONFIG_COMPAT)
> -#define MSG_CMSG_COMPAT		BIT(31)	/* This message needs 32 bit fixups */
> -#else
> -#define MSG_CMSG_COMPAT		0	/* We never have 32 bit fixups */
> -#endif
> +/* Attention: Don't use BIT(31) for MSG_*, as 'msg_flags' is defined
> + * as 'int' somewhere and BIT(31) will make it become negative.
> + */
>  
>  
>  /* Setsockoptions(2) level. Thanks to BSD these must match IPPROTO_xxx */
> 

