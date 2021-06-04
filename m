Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896DC39AFE9
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 03:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhFDBgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 21:36:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37384 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229820AbhFDBgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 21:36:42 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1loyjS-0002cE-GK; Fri, 04 Jun 2021 09:34:42 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1loyjQ-0003EW-4i; Fri, 04 Jun 2021 09:34:40 +0800
Date:   Fri, 4 Jun 2021 09:34:40 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] xfrm: Return the correct errno code
Message-ID: <20210604013440.GA12407@gondor.apana.org.au>
References: <20210604014652.2087406-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604014652.2087406-1-zhengyongjun3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 09:46:52AM +0800, Zheng Yongjun wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/xfrm/xfrm_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> index f0aecee4d539..4f9c86807bc4 100644
> --- a/net/xfrm/xfrm_user.c
> +++ b/net/xfrm/xfrm_user.c
> @@ -3159,7 +3159,7 @@ static struct xfrm_policy *xfrm_compile_policy(struct sock *sk, int opt,
>  
>  	xp = xfrm_policy_alloc(net, GFP_ATOMIC);
>  	if (xp == NULL) {
> -		*dir = -ENOBUFS;
> +		*dir = -ENOMEM;

Nack.  ENOBUFS has a specific meaning in the network stack.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
