Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4AD34329A
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCUMuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:50:23 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33390 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229784AbhCUMtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 08:49:45 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lNxVy-0005mX-Nf; Sun, 21 Mar 2021 23:49:07 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 21 Mar 2021 23:49:06 +1100
Date:   Sun, 21 Mar 2021 23:49:06 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     menglong8.dong@gmail.com
Cc:     andy.shevchenko@gmail.com, kuba@kernel.org, linux@roeck-us.net,
        David.Laight@aculab.com, davem@davemloft.net,
        dong.menglong@zte.com.cn, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: socket: change MSG_CMSG_COMPAT to
 BIT(21)
Message-ID: <20210321124906.GA14333@gondor.apana.org.au>
References: <20210321123929.142838-1-dong.menglong@zte.com.cn>
 <20210321123929.142838-3-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210321123929.142838-3-dong.menglong@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 08:39:29PM +0800, menglong8.dong@gmail.com wrote:
>
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index d5ebfe30d96b..317b2933f499 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -312,17 +312,18 @@ struct ucred {
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

Shouldn't you add some comment here to stop people from trying to
use BIT(31) in the future?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
