Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C27401616
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 07:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238941AbhIFF4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 01:56:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45431 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231271AbhIFF4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 01:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630907696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uXUj74/nW7Dop13kd56Tk5oKTffqICUe0M10X4WaPl4=;
        b=GUdZ1eZQlzCOGh1NwV8LtGH2T8rzYVbjGWgYpiIJXoRpQ92bQe12hhNowOqoFXtPMxzW5u
        aP3PYHxyAmwSjUySiwvrIceX1TPdj2cz/H7djZxQi1eHPdnARmD4QnZmPJUGR8BF2LTKWC
        5MAZc/xWES7JWGitNVqcR86RsKXi2zg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-1z0ZaUuwNyuGdiWlLRL0WQ-1; Mon, 06 Sep 2021 01:54:55 -0400
X-MC-Unique: 1z0ZaUuwNyuGdiWlLRL0WQ-1
Received: by mail-wm1-f69.google.com with SMTP id u1-20020a05600c210100b002e74fc5af71so1931134wml.1
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 22:54:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uXUj74/nW7Dop13kd56Tk5oKTffqICUe0M10X4WaPl4=;
        b=j0R7uy/pD1EVb4DpL7qf1Iqd+f4AbTPtSDPOpIn0znkZdCoASC/6WHc07w42h7ippX
         KT0bONx15hLv7GiY4bb5VlLEpBTmp3+QxoZ/vRHgf7KfC6cLNO9n8o2ccL/mjlgAWtzl
         jt68nC7cIM3ED3qh6/0qFT7UieJo+JOYHkUQIVXJqIZEl4E67/1jwwrDOFeWx3x+5Rjv
         Z+aYZX2M7oVzlHZ14VNsdC1MzXLcuNAc8JPuOyQOGu5WTuICwAif93wI08pPJZruiWCE
         QpNkKVcFbN+AUO9It3PRIiozOdubQ6+Uu+GNpwOPeph9YzOs/90Sro6J9Q4/Ei5t5hgv
         L+jQ==
X-Gm-Message-State: AOAM5337zJAKr5lCxqYcZqzul3zq9F7rVvsV+67Z3Yqk3cEzFUEs5581
        30cqVTsdvNB+npBys6UO4VATN0gnN4344HLZzAU1SkEm1Uqg8btID+XvKU41Zhg1D7YDcsEHU4j
        ifC0oo852E48PrVId
X-Received: by 2002:adf:c14c:: with SMTP id w12mr11478515wre.115.1630907694559;
        Sun, 05 Sep 2021 22:54:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR1O2bgM/VI9yvbWaSh3BRtvaI+DJ+X6rHFaklEn67szHR3xlYEE2NCPwCA7NsX4rJPFqdkg==
X-Received: by 2002:adf:c14c:: with SMTP id w12mr11478480wre.115.1630907694360;
        Sun, 05 Sep 2021 22:54:54 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id h8sm6166143wmb.35.2021.09.05.22.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 22:54:53 -0700 (PDT)
Date:   Mon, 6 Sep 2021 01:54:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 05/13] vdpa: Add reset callback in vdpa_config_ops
Message-ID: <20210906015243-mutt-send-email-mst@kernel.org>
References: <20210830141737.181-1-xieyongji@bytedance.com>
 <20210830141737.181-6-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830141737.181-6-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 10:17:29PM +0800, Xie Yongji wrote:
> This adds a new callback to support device specific reset
> behavior. The vdpa bus driver will call the reset function
> instead of setting status to zero during resetting.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>

This does gloss over a significant change though:

> @@ -348,12 +352,12 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
>  	return vdev->dma_dev;
>  }
>  
> -static inline void vdpa_reset(struct vdpa_device *vdev)
> +static inline int vdpa_reset(struct vdpa_device *vdev)
>  {
>  	const struct vdpa_config_ops *ops = vdev->config;
>  
>  	vdev->features_valid = false;
> -	ops->set_status(vdev, 0);
> +	return ops->reset(vdev);
>  }
>  
>  static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)

Unfortunately this breaks virtio_vdpa:


static void virtio_vdpa_reset(struct virtio_device *vdev)
{
        struct vdpa_device *vdpa = vd_get_vdpa(vdev);

        vdpa_reset(vdpa);
}


and there's no easy way to fix this, kernel can't recover
from a reset failure e.g. during driver unbind.

Find a way to disable virtio_vdpa for now?

> -- 
> 2.11.0

