Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05ADA357FAD
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhDHJpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:45:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32493 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231475AbhDHJpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 05:45:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617875134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x7I3DmGLXrsRyzlHfy6cDu8vSs80M025TjfxeEvur9E=;
        b=GA1MUk3d7A4vewTEhaorEibiLIH2v6VKGE67hyC/g9kpo9UfPbjWv11VJMN3WV08HfYOG5
        7zhBK8FddrPvsUXq9o+nmCrznH6a26qqxMsTyqK7b/DRF29UZ9uHV3kk9qBpV9WyKDt+Og
        1YvZcfOY8pgGiuOBJhEWJeLYlwCLJMQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-Xl-Ef9tEPrWyv8Gfc99AZA-1; Thu, 08 Apr 2021 05:45:32 -0400
X-MC-Unique: Xl-Ef9tEPrWyv8Gfc99AZA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02FBA6D241;
        Thu,  8 Apr 2021 09:45:31 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-53.pek2.redhat.com [10.72.13.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E52CF5D9CA;
        Thu,  8 Apr 2021 09:45:23 +0000 (UTC)
Subject: Re: [PATCH 3/5] vdpa/mlx5: Retrieve BAR address suitable any function
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com, parav@nvidia.com,
        si-wei.liu@oracle.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210408091047.4269-1-elic@nvidia.com>
 <20210408091047.4269-4-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <67feb53c-91dc-f299-0c83-ce459cb0da5e@redhat.com>
Date:   Thu, 8 Apr 2021 17:45:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210408091047.4269-4-elic@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/8 ÏÂÎç5:10, Eli Cohen Ð´µÀ:
> struct mlx5_core_dev has a bar_addr field that contains the correct bar
> address for the function regardless of whether it is pci function or sub
> function. Use it.
>
> Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/mlx5/core/resources.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
> index 96e6421c5d1c..6521cbd0f5c2 100644
> --- a/drivers/vdpa/mlx5/core/resources.c
> +++ b/drivers/vdpa/mlx5/core/resources.c
> @@ -246,7 +246,8 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
>   	if (err)
>   		goto err_key;
>   
> -	kick_addr = pci_resource_start(mdev->pdev, 0) + offset;
> +	kick_addr = mdev->bar_addr + offset;
> +
>   	res->kick_addr = ioremap(kick_addr, PAGE_SIZE);
>   	if (!res->kick_addr) {
>   		err = -ENOMEM;

