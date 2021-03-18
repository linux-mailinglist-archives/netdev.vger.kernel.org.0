Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F370833FDC4
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhCRDYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:24:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230527AbhCRDY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 23:24:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616037866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sk99JE96HUPSTLu/4JDMtH8mhmtCcHHNeKecLnAG+NE=;
        b=hbkEy4e4gzO0lf3fZMdx+5koTXY+AYY0cZMug/uzBGRp7FlHV84W0ZAIUbbeFAUKJ+8Mh/
        /KQc3B28+nIoBYysnNEnS8QHO1cHBpakrtKhvAtIIbWKXpkruI8wbokdb+UarGwl4CacBN
        NjVsV9LZL7M2AcS/5IZkev/BdHRMi4Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-9PzC1WQ9N_6YW8Wemxs-EQ-1; Wed, 17 Mar 2021 23:24:25 -0400
X-MC-Unique: 9PzC1WQ9N_6YW8Wemxs-EQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7641B81744F;
        Thu, 18 Mar 2021 03:24:23 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-131.pek2.redhat.com [10.72.13.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 192966C330;
        Thu, 18 Mar 2021 03:24:06 +0000 (UTC)
Subject: Re: [PATCH v4 10/14] vhost/vdpa: Remove the restriction that only
 supports virtio-net devices
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
References: <20210315163450.254396-1-sgarzare@redhat.com>
 <20210315163450.254396-11-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <011fb2bf-bee5-7fb6-0abc-17ddf7026476@redhat.com>
Date:   Thu, 18 Mar 2021 11:24:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315163450.254396-11-sgarzare@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/16 ÉÏÎç12:34, Stefano Garzarella Ð´µÀ:
> From: Xie Yongji <xieyongji@bytedance.com>
>
> Since the config checks are done by the vDPA drivers, we can remove the
> virtio-net restriction and we should be able to support all kinds of
> virtio devices.
>
> <linux/virtio_net.h> is not needed anymore, but we need to include
> <linux/slab.h> to avoid compilation failures.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/vdpa.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 7ae4080e57d8..850ed4b62942 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -16,12 +16,12 @@
>   #include <linux/cdev.h>
>   #include <linux/device.h>
>   #include <linux/mm.h>
> +#include <linux/slab.h>
>   #include <linux/iommu.h>
>   #include <linux/uuid.h>
>   #include <linux/vdpa.h>
>   #include <linux/nospec.h>
>   #include <linux/vhost.h>
> -#include <linux/virtio_net.h>
>   
>   #include "vhost.h"
>   
> @@ -1018,10 +1018,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>   	int minor;
>   	int r;
>   
> -	/* Currently, we only accept the network devices. */
> -	if (ops->get_device_id(vdpa) != VIRTIO_ID_NET)
> -		return -ENOTSUPP;
> -
>   	v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>   	if (!v)
>   		return -ENOMEM;

