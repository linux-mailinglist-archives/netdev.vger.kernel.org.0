Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6EE834335E
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 17:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhCUQQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 12:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhCUQPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 12:15:46 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81907C061574;
        Sun, 21 Mar 2021 09:15:46 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id y19-20020a0568301d93b02901b9f88a238eso13518346oti.11;
        Sun, 21 Mar 2021 09:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SGDgCsgqZ+Jm9MN6MAj/2oOtkuCICMDSOY6njb7Ulws=;
        b=HzHoSiCYzUfWRtNDzcfvb8HpqfXDLUfiLGZxLMeQzgIRELNIXgLj/JCVHPRy9SrtmI
         p/Yqg88dNJJz6rs7rOdZ4IHysRk/QORm3D67ZQM2ljfqv+Q5ScKSQ/p2/jvxjwz9I+Na
         +WkSU4xoDhSbHfE1OGIgDvbor58hQrtX67xL3RCmWd2/RGwBC48Du7AW+MZqsgFq1UVS
         NayHPpXzCoIFlmlE9ulGEXHZ/hYJSWVnykSwNROMhpPuO0u31ECXTuA0BsUTHOZMlSgZ
         mnttuoCTTKbEOzKYHPW4zcBZBg/BPNggbNrPbjEHv0p5OEq9CpEQZe3l0vbUUbd011Yx
         a3kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=SGDgCsgqZ+Jm9MN6MAj/2oOtkuCICMDSOY6njb7Ulws=;
        b=dIAxOQf1Ai6rO/zh4ShvS92LLZeyqpO9ucxTehlnHDyQOjhi8hZOKqF7DJdRksWaj9
         NFI0le95h+RvsOT8EtRMte0x6TsBC7GSZXTsjgVNOO74q6K0kX/vBVYDzuD79bxbKReP
         rJT6t+oO45PLOAsCLNN5rTuPy6ySSYKKc8s4ZRRES33kf+MuU+1O1cwN8OJI+cc3HRsp
         +0maecQsKSyIjtm55vlORxFZD9cBDe1DZmIh2y4acSUYNMyaeL4lhfMXMX5/olCV5mar
         12uC9QsJsv0AH8Em40SvlORN8xrUrYVRthQQ33qlR5TkqSS8a+/QndPhlMBs02EGHlDK
         FKEg==
X-Gm-Message-State: AOAM5316+QeXeSEtcMVnQ2D6kwYL9fFc8HIYcn8TOEla2TBeRh/DrtJw
        mO9D0hY7UVU8zqh0QuEIlGf3R+Wn1bY=
X-Google-Smtp-Source: ABdhPJzKeb/hA6C7+VitvJmDfjulbMSR7v+QQGzIP1QhlGHgkhlNLzpbJdwPKzLi6lafbRDFwsTO/A==
X-Received: by 2002:a9d:2f45:: with SMTP id h63mr8116195otb.372.1616343345728;
        Sun, 21 Mar 2021 09:15:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 44sm2710512otf.60.2021.03.21.09.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 09:15:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v2 net-next 1/2] net: socket: use BIT() for MSG_*
To:     menglong8.dong@gmail.com, herbert@gondor.apana.org.au,
        andy.shevchenko@gmail.com, kuba@kernel.org, David.Laight@aculab.com
Cc:     davem@davemloft.net, dong.menglong@zte.com.cn,
        viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20210321134357.148323-1-dong.menglong@zte.com.cn>
 <20210321134357.148323-2-dong.menglong@zte.com.cn>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <7b0e1c1e-b45a-4ae3-6e4f-aa7a3dccafdb@roeck-us.net>
Date:   Sun, 21 Mar 2021 09:15:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210321134357.148323-2-dong.menglong@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/21 6:43 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> The bit mask for MSG_* seems a little confused here. Replace it
> with BIT() to make it clear to understand.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

With this patch sent as patch 1/2, any code trying to bisect
a compat related network problem will fail at this commit.

Guenter

> ---
>  include/linux/socket.h | 71 ++++++++++++++++++++++--------------------
>  1 file changed, 37 insertions(+), 34 deletions(-)
> 
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 385894b4a8bb..d5ebfe30d96b 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -283,42 +283,45 @@ struct ucred {
>     Added those for 1003.1g not all are supported yet
>   */
>  
> -#define MSG_OOB		1
> -#define MSG_PEEK	2
> -#define MSG_DONTROUTE	4
> -#define MSG_TRYHARD     4       /* Synonym for MSG_DONTROUTE for DECnet */
> -#define MSG_CTRUNC	8
> -#define MSG_PROBE	0x10	/* Do not send. Only probe path f.e. for MTU */
> -#define MSG_TRUNC	0x20
> -#define MSG_DONTWAIT	0x40	/* Nonblocking io		 */
> -#define MSG_EOR         0x80	/* End of record */
> -#define MSG_WAITALL	0x100	/* Wait for a full request */
> -#define MSG_FIN         0x200
> -#define MSG_SYN		0x400
> -#define MSG_CONFIRM	0x800	/* Confirm path validity */
> -#define MSG_RST		0x1000
> -#define MSG_ERRQUEUE	0x2000	/* Fetch message from error queue */
> -#define MSG_NOSIGNAL	0x4000	/* Do not generate SIGPIPE */
> -#define MSG_MORE	0x8000	/* Sender will send more */
> -#define MSG_WAITFORONE	0x10000	/* recvmmsg(): block until 1+ packets avail */
> -#define MSG_SENDPAGE_NOPOLICY 0x10000 /* sendpage() internal : do no apply policy */
> -#define MSG_SENDPAGE_NOTLAST 0x20000 /* sendpage() internal : not the last page */
> -#define MSG_BATCH	0x40000 /* sendmmsg(): more messages coming */
> -#define MSG_EOF         MSG_FIN
> -#define MSG_NO_SHARED_FRAGS 0x80000 /* sendpage() internal : page frags are not shared */
> -#define MSG_SENDPAGE_DECRYPTED	0x100000 /* sendpage() internal : page may carry
> -					  * plain text and require encryption
> -					  */
> -
> -#define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
> -#define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
> -#define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exec for file
> -					   descriptor received through
> -					   SCM_RIGHTS */
> +#define MSG_OOB		BIT(0)
> +#define MSG_PEEK	BIT(1)
> +#define MSG_DONTROUTE	BIT(2)
> +#define MSG_TRYHARD	BIT(2)	/* Synonym for MSG_DONTROUTE for DECnet		*/
> +#define MSG_CTRUNC	BIT(3)
> +#define MSG_PROBE	BIT(4)	/* Do not send. Only probe path f.e. for MTU	*/
> +#define MSG_TRUNC	BIT(5)
> +#define MSG_DONTWAIT	BIT(6)	/* Nonblocking io		*/
> +#define MSG_EOR		BIT(7)	/* End of record		*/
> +#define MSG_WAITALL	BIT(8)	/* Wait for a full request	*/
> +#define MSG_FIN		BIT(9)
> +#define MSG_SYN		BIT(10)
> +#define MSG_CONFIRM	BIT(11)	/* Confirm path validity	*/
> +#define MSG_RST		BIT(12)
> +#define MSG_ERRQUEUE	BIT(13)	/* Fetch message from error queue */
> +#define MSG_NOSIGNAL	BIT(14)	/* Do not generate SIGPIPE	*/
> +#define MSG_MORE	BIT(15)	/* Sender will send more	*/
> +#define MSG_WAITFORONE	BIT(16)	/* recvmmsg(): block until 1+ packets avail */
> +#define MSG_SENDPAGE_NOPOLICY	BIT(16)	/* sendpage() internal : do no apply policy */
> +#define MSG_SENDPAGE_NOTLAST	BIT(17)	/* sendpage() internal : not the last page  */
> +#define MSG_BATCH		BIT(18)	/* sendmmsg(): more messages coming */
> +#define MSG_EOF	MSG_FIN
> +#define MSG_NO_SHARED_FRAGS	BIT(19)	/* sendpage() internal : page frags
> +					 * are not shared
> +					 */
> +#define MSG_SENDPAGE_DECRYPTED	BIT(20)	/* sendpage() internal : page may carry
> +					 * plain text and require encryption
> +					 */
> +
> +#define MSG_ZEROCOPY		BIT(26)	/* Use user data in kernel path */
> +#define MSG_FASTOPEN		BIT(29)	/* Send data in TCP SYN */
> +#define MSG_CMSG_CLOEXEC	BIT(30)	/* Set close_on_exec for file
> +					 * descriptor received through
> +					 * SCM_RIGHTS
> +					 */
>  #if defined(CONFIG_COMPAT)
> -#define MSG_CMSG_COMPAT	0x80000000	/* This message needs 32 bit fixups */
> +#define MSG_CMSG_COMPAT		BIT(31)	/* This message needs 32 bit fixups */
>  #else
> -#define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
> +#define MSG_CMSG_COMPAT		0	/* We never have 32 bit fixups */
>  #endif
>  
>  
> 

