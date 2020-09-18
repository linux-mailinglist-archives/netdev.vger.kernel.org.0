Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD99D26F809
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 10:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgIRIWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 04:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgIRIWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 04:22:51 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77A472176B;
        Fri, 18 Sep 2020 08:22:49 +0000 (UTC)
Date:   Fri, 18 Sep 2020 11:22:45 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
Message-ID: <20200918082245.GP869610@unreal>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 07:35:03PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> drivers/vdpa/mlx5/ uses vhost_iotlb*() interfaces, so add a dependency
> on VHOST to eliminate build errors.
>
> ld: drivers/vdpa/mlx5/core/mr.o: in function `add_direct_chain':
> mr.c:(.text+0x106): undefined reference to `vhost_iotlb_itree_first'
> ld: mr.c:(.text+0x1cf): undefined reference to `vhost_iotlb_itree_next'
> ld: mr.c:(.text+0x30d): undefined reference to `vhost_iotlb_itree_first'
> ld: mr.c:(.text+0x3e8): undefined reference to `vhost_iotlb_itree_next'
> ld: drivers/vdpa/mlx5/core/mr.o: in function `_mlx5_vdpa_create_mr':
> mr.c:(.text+0x908): undefined reference to `vhost_iotlb_itree_first'
> ld: mr.c:(.text+0x9e6): undefined reference to `vhost_iotlb_itree_next'
> ld: drivers/vdpa/mlx5/core/mr.o: in function `mlx5_vdpa_handle_set_map':
> mr.c:(.text+0xf1d): undefined reference to `vhost_iotlb_itree_first'
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: netdev@vger.kernel.org
> ---
> v2: change from select to depends on VHOST (Saeed)
> v3: change to depends on VHOST_IOTLB (Jason)
>
>  drivers/vdpa/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20200917.orig/drivers/vdpa/Kconfig
> +++ linux-next-20200917/drivers/vdpa/Kconfig
> @@ -31,7 +31,7 @@ config IFCVF
>
>  config MLX5_VDPA
>  	bool "MLX5 VDPA support library for ConnectX devices"
> -	depends on MLX5_CORE
> +	depends on VHOST_IOTLB && MLX5_CORE
>  	default n

While we are here, can anyone who apply this patch delete the "default n" line?
It is by default "n".

Thanks

>  	help
>  	  Support library for Mellanox VDPA drivers. Provides code that is
>
