Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDED2D3312
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbgLHUQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731149AbgLHUPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:15:08 -0500
Date:   Tue, 8 Dec 2020 11:18:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607455113;
        bh=/Q0LizOTWDdWMFl9Lai3EjKIXaMONeKDuC9xc/e4lOo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=egVhILeeWUuHpyaJDjstjQ+WgMSJ4wI4WuJ5S+m6X9oTM4vouxdKFUVmXbbA8z8xz
         0yyl4b0wui9MyYr5qtV5I3TkWHCp1FN7dRiJY70MkmKQhhgPJyebhTpUEhaWBcJLEL
         2OnlwQ76Vq0kVpttx6mxDzE85OMBb9vtR6/C8VESgaOI/XGdgPCRgDHF+Cb6IL4YVd
         Zw5KcLe1k4URJZj9V1Y6S2ic6KrBd+MGQM0D4z1eoBq6FwYw1/3RESu+YSuk3QI5aq
         smGPGy+6wG8xSi+7OEkai/ndW3rp52FOvZyasO+SzuOb11vHwXm2/8WwCDefdwDMdK
         7YQTlDMkUSjvg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx4: simplify the return expression of
 mlx4_init_cq_table()
Message-ID: <20201208111832.28f4a173@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208135543.11820-1-zhengyongjun3@huawei.com>
References: <20201208135543.11820-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 21:55:43 +0800 Zheng Yongjun wrote:
> diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
> index 3b8576b9c2f9..68bd18ee6ee3 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/cq.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
> @@ -462,19 +462,14 @@ EXPORT_SYMBOL_GPL(mlx4_cq_free);
>  int mlx4_init_cq_table(struct mlx4_dev *dev)
>  {
>  	struct mlx4_cq_table *cq_table = &mlx4_priv(dev)->cq_table;
> -	int err;
>  
>  	spin_lock_init(&cq_table->lock);
>  	INIT_RADIX_TREE(&cq_table->tree, GFP_ATOMIC);
>  	if (mlx4_is_slave(dev))
>  		return 0;
>  
> -	err = mlx4_bitmap_init(&cq_table->bitmap, dev->caps.num_cqs,
> -			       dev->caps.num_cqs - 1, dev->caps.reserved_cqs, 0);
> -	if (err)
> -		return err;
> -
> -	return 0;
> +	return mlx4_bitmap_init(&cq_table->bitmap, dev->caps.num_cqs,
> +			        dev->caps.num_cqs - 1, dev->caps.reserved_cqs, 0);
>  }
>  
>  void mlx4_cleanup_cq_table(struct mlx4_dev *dev)

Checkpatch reports the indentation is off here:

ERROR: code indent should use tabs where possible
#37: FILE: drivers/net/ethernet/mellanox/mlx4/cq.c:472:
+^I^I^I        dev->caps.num_cqs - 1, dev->caps.reserved_cqs, 0);$
