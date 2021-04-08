Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0D4357FC6
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhDHJrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:47:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230322AbhDHJrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 05:47:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617875218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+mPdPPkL2uexbS0eM20lasDqx05OgOBYtjBXonlsDAo=;
        b=MgrdRP9tGavW3AzLqwB7U1dRnpJKE3szDwCr4qa5lEbW+579bYoZsnyLmptZ+LhvzVRYuc
        pIPyqQAWFd0jlB/5Jq46dVd+Br6SurM4SGcLKJjDzHFzg4Gj0MQj652qcv5x2erTPhdpir
        IYX9nxZFW0CGMbcCuwLnUKpnCQYtXDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-bCSOr24NM8yqrpMNEqdq9Q-1; Thu, 08 Apr 2021 05:46:57 -0400
X-MC-Unique: bCSOr24NM8yqrpMNEqdq9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D325C80364C;
        Thu,  8 Apr 2021 09:46:55 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-53.pek2.redhat.com [10.72.13.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BC985C5E1;
        Thu,  8 Apr 2021 09:46:46 +0000 (UTC)
Subject: Re: [PATCH 4/5] vdpa/mlx5: Fix wrong use of bit numbers
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com, parav@nvidia.com,
        si-wei.liu@oracle.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210408091047.4269-1-elic@nvidia.com>
 <20210408091047.4269-5-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f2ffac98-2ce7-f9c1-de93-09e9347d0991@redhat.com>
Date:   Thu, 8 Apr 2021 17:46:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210408091047.4269-5-elic@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/8 ÏÂÎç5:10, Eli Cohen Ð´µÀ:
> VIRTIO_F_VERSION_1 is a bit number. Use BIT_ULL() with mask
> conditionals.
>
> Also, in mlx5_vdpa_is_little_endian() use BIT_ULL for consistency with
> the rest of the code.
>
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Eli Cohen <elic@nvidia.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index a49ebb250253..6fe61fc57790 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -820,7 +820,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
>   	MLX5_SET(virtio_q, vq_ctx, event_qpn_or_msix, mvq->fwqp.mqp.qpn);
>   	MLX5_SET(virtio_q, vq_ctx, queue_size, mvq->num_ent);
>   	MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0,
> -		 !!(ndev->mvdev.actual_features & VIRTIO_F_VERSION_1));
> +		 !!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_F_VERSION_1)));
>   	MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
>   	MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
>   	MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
> @@ -1554,7 +1554,7 @@ static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
>   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
>   {
>   	return virtio_legacy_is_little_endian() ||
> -		(mvdev->actual_features & (1ULL << VIRTIO_F_VERSION_1));
> +		(mvdev->actual_features & BIT_ULL(VIRTIO_F_VERSION_1));
>   }
>   
>   static __virtio16 cpu_to_mlx5vdpa16(struct mlx5_vdpa_dev *mvdev, u16 val)

