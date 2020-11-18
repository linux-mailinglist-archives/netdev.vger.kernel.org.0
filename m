Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29E22B7E0F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 14:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgKRNHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 08:07:03 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56199 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726238AbgKRNHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 08:07:03 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9E2DA5C01AA;
        Wed, 18 Nov 2020 08:07:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 18 Nov 2020 08:07:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=12xliv
        0GVWXgapT/p3BTVZF0wsvcSjjUYvHuS2IMINc=; b=kCQHGR6PhmLlWPiDTqqQlY
        nNY6nFtEXnuIXYx5wIH9CSC3dq5he13GuTgUAzpwfeWuQ0mS8F3iIEYXgP1x2Ah0
        GY4jlSUuiIk61OXik/tSZ2fJLs+jmKT9kOENRWRaKjzGy3Edl+D/ueajNGU/JdaN
        xjBP1tlXM9VmG6xT8Yo6Wl0I+BqrPohO/czjuAfL0JKZlFoIudft04n/rHpZqV3B
        IDmyPSWR7ZIrRkF5COTGFD1aZNL8ctquAnRj1fPrE+mXeFuVYOZXSeZtdCugVKYz
        +QWyTGOj5bIQS5GT9bU/DCblsI4loQ1o/J3EEEHsKAHaV/lqRx3PMOp2PpCBsyTg
        ==
X-ME-Sender: <xms:dRy1X-AqwNHBH4cVfskYn_-j_oUQzJeLb0GYrD92Fi0ptfGa5d9-Wg>
    <xme:dRy1X4idzQN48T5odrNfJDsUYv_dEKgB4_n0m8mrkv6WdijCzyE1WpFFChzIl4nRO
    NITO2eZtpMmfKI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefhedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekgedrvddvledrudehge
    drudegjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:dRy1Xxmb1Hp_QagnuuVya-Ygg2L2el9CwS6AXPDZO0_OsGJ1eJoe_Q>
    <xmx:dRy1X8zrzT3_jCcJp4XEdGnXuGH-YhmYCLI1GNAUm06LfQiOYekfJQ>
    <xmx:dRy1XzRy2tbBx4yAYdwR-zEzOJAOiY_tvopgyH2ulOYeNcNGQ3YtPA>
    <xmx:dRy1X9cyfvZoOpIAJ8TmSxllb3Gi1Tc5VFqw6LViHzh5UEx3cZ5KnQ>
Received: from localhost (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E2F23064AAA;
        Wed, 18 Nov 2020 08:07:00 -0500 (EST)
Date:   Wed, 18 Nov 2020 15:06:57 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] mlxsw: spectrum_router: Fix a double free on
 error
Message-ID: <20201118130657.GA335481@shredder.lan>
References: <20201118130048.GA334813@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118130048.GA334813@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 04:00:48PM +0300, Dan Carpenter wrote:
> There is a double free here because mlxsw_sp_nexthop6_group_create() and
> mlxsw_sp_nexthop6_group_info_init() free "nh_grp".  It should only be
> freed in the create function.
> 
> Fixes: 7f7a417e6a11 ("mlxsw: spectrum_router: Split nexthop group configuration to a different struct")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index a2e81ad5790f..fde8667a2f60 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -5423,7 +5423,6 @@ mlxsw_sp_nexthop6_group_info_init(struct mlxsw_sp *mlxsw_sp,
>  		nh = &nhgi->nexthops[i];
>  		mlxsw_sp_nexthop6_fini(mlxsw_sp, nh);
>  	}
> -	kfree(nh_grp);

Thanks for the patch, Dan.

I already sent a patch yesterday:
https://patchwork.kernel.org/project/netdevbpf/patch/20201117174704.291990-2-idosch@idosch.org/

Note that it is different than yours. It frees 'nhgi' instead of
'nh_grp'. It was a typo.

>  	return err;
>  }
>  
> -- 
> 2.29.2
> 
