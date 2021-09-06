Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBE340161D
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 07:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239262AbhIFF5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 01:57:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239193AbhIFF5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 01:57:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630907765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vovMbtPf5r3ofbG1k9TCSMxb7U8AijKtdOS/02BCPEA=;
        b=c/WB3cGs0VdQSYISTv5WAem0B6nQzF2kI1JZw2qhGii5AmF4PG9P199CHVQyZd24cfDaky
        vx6g2DLPMZccEg8BaEpULyEiOrl5Utx6XS+wmnHi7YOubtX06nxWKZAHpyETd3YRRzIMXk
        Gg8uNKUTlgfZq1ptk+mkYktRn3pI6YA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163--zYf1bDWOnWvxtbguYXczw-1; Mon, 06 Sep 2021 01:56:03 -0400
X-MC-Unique: -zYf1bDWOnWvxtbguYXczw-1
Received: by mail-wm1-f72.google.com with SMTP id r125-20020a1c2b830000b0290197a4be97b7so2796387wmr.9
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 22:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vovMbtPf5r3ofbG1k9TCSMxb7U8AijKtdOS/02BCPEA=;
        b=sX3Bk2tI7mwt+YP4A74U+9zJVyNk6F8CbrfLjkboEZzB/PvCTc9fe2fPmvleZaqy4/
         u9rWy0wQo4CnHQlGvyk+ngQ4lOyO0+gUoNn7h1O00LO46fmA7hQv8XSUKQpIefnSkyg9
         S4NPRD0wN+53VNchvtGR7QpjWX1zzQN8E5Djc8x4IWeJ+qjwvHpgXXQ0ZVsppwWuCMK9
         /Y9Kpj6UJn0fW+7N4M3JCzc4t5+m7Je8gdWGLKyLtjgvN3Ine9Ul83ZRFK6K5FZAR98I
         944oc97cSK68P2JfXVqtoqoTR9FggE8uXm/rFasQXCdrZmeNN0+0Y5iyfepxxlZS7Cy1
         hBKg==
X-Gm-Message-State: AOAM533sSFcs6T71ZPe7yplkOUbIFUn/TVQ3XAicBuvGPDbl0b4HWTku
        BO1lsKzNGHCG0sowwqDJyMg1vC85R6t31lFi/bx7t+rG0M7KjajVuwDr+xon3yKngq94fgI4ymE
        uQNVmK2MhTaRQjBLo
X-Received: by 2002:a1c:a50c:: with SMTP id o12mr9495377wme.4.1630907762366;
        Sun, 05 Sep 2021 22:56:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSohV4waNTUQh5Sb39O42c9OGim/c0J+8EbtpG04qEdzlJ16UAGsVC7V6aTmAbRvcBXz/LFQ==
X-Received: by 2002:a1c:a50c:: with SMTP id o12mr9495363wme.4.1630907762186;
        Sun, 05 Sep 2021 22:56:02 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id a133sm6174326wme.5.2021.09.05.22.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 22:56:01 -0700 (PDT)
Date:   Mon, 6 Sep 2021 01:55:56 -0400
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
Subject: Re: [PATCH v13 05/13] vdpa: Add reset callback in vdpa_config_ops
Message-ID: <20210906015524-mutt-send-email-mst@kernel.org>
References: <20210831103634.33-1-xieyongji@bytedance.com>
 <20210831103634.33-6-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831103634.33-6-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 06:36:26PM +0800, Xie Yongji wrote:
> This adds a new callback to support device specific reset
> behavior. The vdpa bus driver will call the reset function
> instead of setting status to zero during resetting.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


This does gloss over a significant change though:


> ---
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

