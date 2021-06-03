Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875FB39AACF
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 21:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFCTTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 15:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhFCTTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 15:19:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB883613F4;
        Thu,  3 Jun 2021 19:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622747860;
        bh=u0oJXFE+S/xUgS/1dYHPMtGebJ6LFWc8AtAfGtgTMG0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DkZRlfVQrtj7slJi7errot4QKWDz/HNlczNmo9mKYz7+PfSATe8N0Q0KD5F2VI1oP
         /Isb4W2rc5f2n+TLmcErxSlxQ36WXTb1tq/qnJQEU4yNHwpP+dWAgbRDBZwoZ30xI2
         HDImANT6et69PkTPKgJApyUxunn5HW7BCBOPFrgFPfPJidtE7ZDy95L+cTQkpWU7AZ
         rjx40iAtVzuRn7ld0ZcKDtVyKt++iy6/6+NZek+q1MWqyGjb8XOvNDBPt13kiaL9xd
         E6CDsBhxIR2jvYHiLfxgIG5l90vHvl9W22wf8Plgt/4hgjAhwAK+0VzaMcBWEZeYCs
         r/VfLOi/0X+PQ==
Message-ID: <1b6a19b9b0d0e5977b7b8671bbd4f9d05ca3a62f.camel@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: check for allocation failure in
 mlx5_ft_pool_init()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Paul Blakey <paulb@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Thu, 03 Jun 2021 12:17:39 -0700
In-Reply-To: <YLjNfHuTQ817oUtX@mwanda>
References: <YLjNfHuTQ817oUtX@mwanda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-03 at 15:39 +0300, Dan Carpenter wrote:
> Add a check for if the kzalloc() fails.
> 
> Fixes: 4a98544d1827 ("net/mlx5: Move chains ft pool to be used by all
> firmware steering")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
> b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
> index 526fbb669142..c14590acc772 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
> @@ -27,6 +27,8 @@ int mlx5_ft_pool_init(struct mlx5_core_dev *dev)
>         int i;
>  
>         ft_pool = kzalloc(sizeof(*ft_pool), GFP_KERNEL);
> +       if (!ft_pool)
> +               return -ENOMEM;
>  
>         for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--)
>                 ft_pool->ft_left[i] = FT_SIZE / FT_POOLS[i];

applied to net-next-mlx5,
thanks

