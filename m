Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5135939D83D
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 11:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhFGJGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 05:06:41 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33508 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230173AbhFGJGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 05:06:40 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lqBBX-0004lK-Pa; Mon, 07 Jun 2021 17:04:39 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lqBBT-0002rF-P6; Mon, 07 Jun 2021 17:04:35 +0800
Date:   Mon, 7 Jun 2021 17:04:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] xfrm: use BUG_ON instead of if condition
 followed by BUG
Message-ID: <20210607090435.GA10960@gondor.apana.org.au>
References: <20210607091121.2766815-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607091121.2766815-1-zhengyongjun3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 05:11:21PM +0800, Zheng Yongjun wrote:
> Use BUG_ON instead of if condition followed by BUG.
> 
> This issue was detected with the help of Coccinelle.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/xfrm/xfrm_policy.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index ce500f847b99..532314578151 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -421,8 +421,7 @@ void xfrm_policy_destroy(struct xfrm_policy *policy)
>  {
>  	BUG_ON(!policy->walk.dead);
>  
> -	if (del_timer(&policy->timer) || del_timer(&policy->polq.hold_timer))
> -		BUG();
> +	BUG_ON(del_timer(&policy->timer) || del_timer(&policy->polq.hold_timer));

Nack.  Do not put statements with side effects within BUG_ON.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
