Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC0B3380DC
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhCKWsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:48:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhCKWsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:48:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93ECD64F26;
        Thu, 11 Mar 2021 22:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502905;
        bh=YQ7sKWMjLFENB0F0uZS21DUq7mds7ydrbZt7pYqXU6Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R6+rjzPpK3p2c+PEffgXrFvPMqJM0N2oq47+/f2jFkibfmBTw9wP6YSjNVu0syjkK
         FrBuHCnKB42XkQsSo1chdDuqQ7tEGyxwxskUfBo7Igm1LSlMdQ44oT6r5RRrefPAwa
         lu+/4f7hGS//eDqfTtQFQRwkLiHhMtMYqmLqQfovOTRIlucSh9e58uo+70GI2l2jFC
         7QBhIFwEEJj8vobJeWkHvelEMUpR62H6FgNaGyr5J3Z0yRaJrI7GGHK2x+K5gJ/nzC
         bm5TI0lwflToW1cQf01idxUgH+BEapD+uCsTH2OU+quKfU3FcPZfcVmijEzb/oX5Xb
         8szzZyNw7myYQ==
Message-ID: <ac6955443a4aa5d0a72e6f2bf15c494f36b78f5c.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: include net/nexthop.h where needed
From:   Saeed Mahameed <saeed@kernel.org>
To:     Roi Dayan <roid@nvidia.com>, Arnd Bergmann <arnd@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 11 Mar 2021 14:48:23 -0800
In-Reply-To: <5fd5e630-0db2-f83b-63c8-265c4ac372e8@nvidia.com>
References: <20210308153143.2392122-1-arnd@kernel.org>
         <5fd5e630-0db2-f83b-63c8-265c4ac372e8@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-08 at 20:23 +0200, Roi Dayan wrote:
> 
> 
> On 2021-03-08 5:31 PM, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1510:12:
> > error: implicit declaration of function 'fib_info_nh' [-Werror,-
> > Wimplicit-function-declaration]
> >          fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
> >                    ^
> > drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1510:12:
> > note: did you mean 'fib_info_put'?
> > include/net/ip_fib.h:529:20: note: 'fib_info_put' declared here
> > static inline void fib_info_put(struct fib_info *fi)
> >                     ^
> > 
> > Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel
> > endpoint device")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git
> > a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> > index 6a116335bb21..32d06fe94acc 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> > @@ -2,6 +2,7 @@
> >   /* Copyright (c) 2021 Mellanox Technologies. */
> >   
> >   #include <net/fib_notifier.h>
> > +#include <net/nexthop.h>
> >   #include "tc_tun_encap.h"
> >   #include "en_tc.h"
> >   #include "tc_tun.h"
> > 
> 
> Hi,
> 
> I see internally we have a pending commit from Vlad fixing this
> already,
> with few more fixes. "net/mlx5e: Add missing include"
> 
> I'll check why it's being held.

Just submitted to net-next. 
Thanks!


