Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BC24347D7
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhJTJXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhJTJXm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 05:23:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CADA360F9E;
        Wed, 20 Oct 2021 09:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634721688;
        bh=FNi0gv59TSHJ+dDXba/R1ZQh+Fy3b7uknpRZNj19rzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=keG6yS6i8TlAKosrleGcMh2k70MnA6xRNqq2LdTHxqEtUGV1wfvuxcz7Lxp2xbHd0
         8hDIvhGkC1z9e0288RB0LFdO7doVWTy2HbM2K9gc1bbFQDdVIEgCCmgSEChMr+G7fQ
         rRoCH83r8qjtJlY4r8/qOGRysfvxwEP1l5I4GJHQDe1W7Y2PTJe+KG0PUDCxuIpawG
         qfy+2QXleAS/NI3oS3kYUj+ORnn8CUKehOuCBuIX5gczBXmoSof8lOtwIfhNT68XwI
         jO20OzAm/I9gYIm5r4Bc1LVDJYjljF06W+eHNOnwLDADPpmojuYt0MxTJO+upd3Q5W
         BvifslsH4TDAQ==
Date:   Wed, 20 Oct 2021 11:21:25 +0200
From:   Simon Horman <horms@kernel.org>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        penghao luo <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] net/core: Remove unused assignment operations
 and variable
Message-ID: <20211020092124.GE3935@kernel.org>
References: <20211018091356.858036-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018091356.858036-1-luo.penghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 09:13:56AM +0000, luo penghao wrote:
> From: penghao luo <luo.penghao@zte.com.cn>

I think the correct patch prefix for this patch would be:

[PATCH net-next] rtnetlink:

> Although if_info_size is assigned, it has not been used. And the variable
> should also be deleted.
> 
> The clang_analyzer complains as follows:
> 
> net/core/rtnetlink.c:3806: warning:
> 
> Although the value stored to 'if_info_size' is used in the enclosing expression,
> the value is never actually read from 'if_info_size'.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: penghao luo <luo.penghao@zte.com.cn>
> ---
>  net/core/rtnetlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 327ca6b..52dc51a 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -3804,9 +3804,9 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
>  	struct net *net = dev_net(dev);
>  	struct sk_buff *skb;
>  	int err = -ENOBUFS;
> -	size_t if_info_size;
>  
> -	skb = nlmsg_new((if_info_size = if_nlmsg_size(dev, 0)), flags);
> +
> +	skb = nlmsg_new((if_nlmsg_size(dev, 0)), flags);

I think you can also drop the parentheses around the call to if_nlmsg_size.

>  	if (skb == NULL)
>  		goto errout;
>  
> -- 
> 2.15.2
> 
