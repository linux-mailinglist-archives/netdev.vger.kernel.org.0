Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9067EE82
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403917AbfHBINa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:13:30 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:9453 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403892AbfHBIN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:13:29 -0400
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJU8h5kksl"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id k05d3bv728AQ7DF
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 2 Aug 2019 10:10:26 +0200 (CEST)
Subject: Re: [PATCH net-next] net: can: Fix compiling warning
To:     Mao Wenan <maowenan@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190802033643.84243-1-maowenan@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <0050efdb-af9f-49b9-8d83-f574b3d46a2e@hartkopp.net>
Date:   Fri, 2 Aug 2019 10:10:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802033643.84243-1-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/08/2019 05.36, Mao Wenan wrote:
> There are two warings in net/can, fix them by setting bcm_sock_no_ioctlcmd
> and raw_sock_no_ioctlcmd as static.
> 
> net/can/bcm.c:1683:5: warning: symbol 'bcm_sock_no_ioctlcmd' was not declared. Should it be static?
> net/can/raw.c:840:5: warning: symbol 'raw_sock_no_ioctlcmd' was not declared. Should it be static?
> 
> Fixes: 473d924d7d46 ("can: fix ioctl function removal")
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks Mao!

Btw. what kind of compiler/make switches are you using so that I can see 
these warnings myself the next time?

Best regards,
Oliver

> ---
>   net/can/bcm.c | 2 +-
>   net/can/raw.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/can/bcm.c b/net/can/bcm.c
> index bf1d0bbecec8..b8a32b4ac368 100644
> --- a/net/can/bcm.c
> +++ b/net/can/bcm.c
> @@ -1680,7 +1680,7 @@ static int bcm_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>   	return size;
>   }
>   
> -int bcm_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
> +static int bcm_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
>   			 unsigned long arg)
>   {
>   	/* no ioctls for socket layer -> hand it down to NIC layer */
> diff --git a/net/can/raw.c b/net/can/raw.c
> index da386f1fa815..a01848ff9b12 100644
> --- a/net/can/raw.c
> +++ b/net/can/raw.c
> @@ -837,7 +837,7 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>   	return size;
>   }
>   
> -int raw_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
> +static int raw_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
>   			 unsigned long arg)
>   {
>   	/* no ioctls for socket layer -> hand it down to NIC layer */
> 
