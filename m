Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0E145DBC2
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 14:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354072AbhKYOAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:00:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:34336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355056AbhKYN6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 08:58:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E67F60E73;
        Thu, 25 Nov 2021 13:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637848532;
        bh=MdBq6Fuj8r+gsoMpv6GqozLN04RZF57Zlx9xi2N4Tgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pjARsvJI9ooGAik4w4367M2TS6IQd4S7aEQk79Ec7wR8aRQAj/I8D8LTmAGBOn3Xm
         u8rG0hVgMh+vdpXWb58ZqS61HRW6pYxjq5dNIcPoDTw+mm761Pg+dwoUWcAWuNiq/Y
         w/8U1KDNe1FuQ7hGejyU7xnP//jYcTvwIsXMCCk2SP6kRnl5vxYrR17KV6Sa0pG1J3
         AHbvVEZn0qIXbrPHTZ+59W2ikXKdyOwSZP27RXfsXN5e8WK872vkEr9l2DRD1NFlC9
         KTagLCzZa7Y9RFiDcdv42ERJ/NgM0EvFAlV9ZHNxJtOcrdfbrCizKGUl2tYluOsqLg
         D0p9OpeJyVhiQ==
Date:   Thu, 25 Nov 2021 15:55:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] ifb: support ethtools driver info
Message-ID: <YZ+V0DjXTnUmi51R@unreal>
References: <20211125020155.6488-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125020155.6488-1-xiangxia.m.yue@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 10:01:54AM +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> ifb netdev may be created by others prefix, not ifbX.
> For getting netdev driver info, add ifb ethtools callback.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  drivers/net/ifb.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
> index 31f522b8e54e..d9078ce041c4 100644
> --- a/drivers/net/ifb.c
> +++ b/drivers/net/ifb.c
> @@ -26,6 +26,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> +#include <linux/ethtool.h>
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
>  #include <linux/init.h>
> @@ -35,7 +36,10 @@
>  #include <net/pkt_sched.h>
>  #include <net/net_namespace.h>
>  
> -#define TX_Q_LIMIT    32
> +#define DRV_NAME	"ifb"
> +#define DRV_VERSION	"1.0"

Please don't add this line too.

Thanks
