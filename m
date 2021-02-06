Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF2B311F9F
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 20:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBFTUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 14:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhBFTUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 14:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8FD164E34;
        Sat,  6 Feb 2021 19:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612639203;
        bh=ZkLTlDftPY4xAsKwZ0tc366qMPHIVGtucQmFT2nJBhw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qFDOjiBCaNwxeTCzBHR/4vVA8OLtWe6NQyk2ulDV/DCwNlGZ9Fi7YrWKSAS4L6x4M
         O5d4f2AJCdnK3QOJUwDY3pNjR2ijdxLTpwizaRClu9tkqbYmUPYY7TSDcYwIKTuYYe
         Dl2KRcA/J1s2XugBt6bu69E9LJzayrRMjgrVkibfNmgf+Y9OChNsdVt4NFU0YVd6ah
         HeIM7mrigCWg/EKJur/2jt8HzIe+cIemAmCFjs6vxwRRHPApU24jDzOpaB4/nZMv5D
         WTw+7ffZVdnAhbs4Bc3PeD2NifgvoWgrU6VmF/LbGI0AkoJElCls7OLNVNCwm4st60
         DSCHKJrLUQJUw==
Date:   Sat, 6 Feb 2021 11:20:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: core: Return the correct errno code
Message-ID: <20210206112002.4d08516d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210204031923.15264-1-zhengyongjun3@huawei.com>
References: <20210204031923.15264-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 11:19:23 +0800 Zheng Yongjun wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/core/rtnetlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 7d7223691783..6df8fb25668b 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -177,7 +177,7 @@ static int rtnl_register_internal(struct module *owner,
>  	struct rtnl_link *link, *old;
>  	struct rtnl_link __rcu **tab;
>  	int msgindex;
> -	int ret = -ENOBUFS;
> +	int ret = -ENOMEM;

while at it please move the line above int msgindex; so that variable
lines are sorted longest to shortest.

>  	BUG_ON(protocol < 0 || protocol > RTNL_FAMILY_MAX);
>  	msgindex = rtm_msgindex(msgtype);

