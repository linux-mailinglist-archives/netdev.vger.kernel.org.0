Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780A126EDA3
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgIRCWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:22:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729185AbgIRCRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:17:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600395430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ku+sICGKzWJ9hbk/lDryotAHNAcONZujUxBnYspdRTU=;
        b=Fjn5NYgscaLzBZ6FN8sKBSmHnI/WMoDdmHlolpOGkrjbf5Q+cpPux7UCoeCB7I7fj+A++V
        Nmj7l+wxDQjEdU5lT3gYTTlMmBH6WqzPtY9GSewOJ3qRILKSQNZ89+/71hTqoe6b1j60kk
        aI90lrhALptljSN76WqronQMioeIkYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-wx2RmR3bNLelwWeZZ_RbzQ-1; Thu, 17 Sep 2020 22:17:06 -0400
X-MC-Unique: wx2RmR3bNLelwWeZZ_RbzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B88110BBEE6;
        Fri, 18 Sep 2020 02:17:05 +0000 (UTC)
Received: from [10.72.13.167] (ovpn-13-167.pek2.redhat.com [10.72.13.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4314510013C1;
        Fri, 18 Sep 2020 02:16:58 +0000 (UTC)
Subject: Re: [PATCH v2 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
To:     Randy Dunlap <rdunlap@infradead.org>,
        virtualization@lists.linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
References: <22a2bd60-d895-2bfb-50be-4ac3d131ed82@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f306fbfb-2984-d52d-b7be-7d65db643955@redhat.com>
Date:   Fri, 18 Sep 2020 10:16:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <22a2bd60-d895-2bfb-50be-4ac3d131ed82@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/18 上午3:45, Randy Dunlap wrote:
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
> v2: change from select to depends (Saeed)
>
>   drivers/vdpa/Kconfig |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20200917.orig/drivers/vdpa/Kconfig
> +++ linux-next-20200917/drivers/vdpa/Kconfig
> @@ -31,7 +31,7 @@ config IFCVF
>   
>   config MLX5_VDPA
>   	bool "MLX5 VDPA support library for ConnectX devices"
> -	depends on MLX5_CORE
> +	depends on VHOST && MLX5_CORE


It looks to me that depending on VHOST is too heavyweight.

I guess what it really needs is VHOST_IOTLB. So we can use select 
VHOST_IOTLB here.

Thanks


>   	default n
>   	help
>   	  Support library for Mellanox VDPA drivers. Provides code that is
>

