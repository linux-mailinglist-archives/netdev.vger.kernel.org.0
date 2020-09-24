Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FCB276B32
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgIXHuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:50:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727253AbgIXHuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 03:50:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600933817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sqHArwthT57JphmHaTiMSE/ABTSL+yhvvPSNJ4OWT20=;
        b=RFZF4p6ulQ0Hfp9QydZh+8u9zYUfDZ7Onk60mVy2gPkNKFcoym8WIoBDNunayCFbllpVSk
        f9xXmaMiFu+GsFKPu05EoVAfLE8+VpTuSYhbaC/AySqL0IDirHVqD8wYI5SiIWtc3TWO/f
        12boFnae1mMiF5+l+IX/QZkq+U3LRt8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-971OcuF_NIq7-RnPgwcthg-1; Thu, 24 Sep 2020 03:50:16 -0400
X-MC-Unique: 971OcuF_NIq7-RnPgwcthg-1
Received: by mail-wr1-f72.google.com with SMTP id v5so886900wrs.17
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 00:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sqHArwthT57JphmHaTiMSE/ABTSL+yhvvPSNJ4OWT20=;
        b=ck8y9PgVSm0xC1cOjZNEUQBt0RMA9fKYvk7dOok3mDHEd0Vrmj+hjn/v+VklS9dTnu
         Rbt88oJW+i7byePPEYNig3WwpvE2aNfso0PdOb6Umeco/m236BtkMD44gPLKzdmp/Nr6
         YraUsPDAiMuzkpXb1p6CTmpqtXLy1LqSUmoP+LivujbfAr9ndzEdLwP9MTOUizVgXCaT
         ZqHu0etuMzqptcpCKU5BH4ji4JAZX6P5F6qgz6feDhEPUBWZrvduRQulv0KonoY7sohT
         ugEQxsy1febgMU8Yn6tolidp8piz9cG1tKXRgTMoLVW/3lYiQBmB/zrOloP9IaxP7Lwl
         su+g==
X-Gm-Message-State: AOAM531XTJPLppKm54V+tlgQOmHjBsg9Og5zE7KT98s6AeHhRRpSLyc6
        +XT9jD6jHB7oUpUPeKLxbKljS81w/iRDf2VMGzFAFeikSSNUjcAR8hU682mOJYZSDgaYSbSIycQ
        fivaBeD7FU81xHurr
X-Received: by 2002:a1c:4d4:: with SMTP id 203mr3444742wme.102.1600933814577;
        Thu, 24 Sep 2020 00:50:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVfjv26Puupvq5kpzttvd3K18d03z40CEQlYqSb3TWLEs4O9kGbUJXSf4YGSZuLoHBXsvzKg==
X-Received: by 2002:a1c:4d4:: with SMTP id 203mr3444708wme.102.1600933814287;
        Thu, 24 Sep 2020 00:50:14 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id y1sm2301869wma.36.2020.09.24.00.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 00:50:13 -0700 (PDT)
Date:   Thu, 24 Sep 2020 03:50:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, Eli Cohen <elic@nvidia.com>
Subject: Re: [RFC PATCH 01/24] vhost-vdpa: fix backend feature ioctls
Message-ID: <20200924034940-mutt-send-email-mst@kernel.org>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-2-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924032125.18619-2-jasowang@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 11:21:02AM +0800, Jason Wang wrote:
> Commit 653055b9acd4 ("vhost-vdpa: support get/set backend features")
> introduces two malfunction backend features ioctls:
> 
> 1) the ioctls was blindly added to vring ioctl instead of vdpa device
>    ioctl
> 2) vhost_set_backend_features() was called when dev mutex has already
>    been held which will lead a deadlock
> 
> This patch fixes the above issues.
> 
> Cc: Eli Cohen <elic@nvidia.com>
> Reported-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Fixes: 653055b9acd4 ("vhost-vdpa: support get/set backend features")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Don't we want the fixes queued right now, as opposed to the rest of the
RFC?

> ---
>  drivers/vhost/vdpa.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 3fab94f88894..796fe979f997 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -353,8 +353,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  	struct vdpa_callback cb;
>  	struct vhost_virtqueue *vq;
>  	struct vhost_vring_state s;
> -	u64 __user *featurep = argp;
> -	u64 features;
>  	u32 idx;
>  	long r;
>  
> @@ -381,18 +379,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  
>  		vq->last_avail_idx = vq_state.avail_index;
>  		break;
> -	case VHOST_GET_BACKEND_FEATURES:
> -		features = VHOST_VDPA_BACKEND_FEATURES;
> -		if (copy_to_user(featurep, &features, sizeof(features)))
> -			return -EFAULT;
> -		return 0;
> -	case VHOST_SET_BACKEND_FEATURES:
> -		if (copy_from_user(&features, featurep, sizeof(features)))
> -			return -EFAULT;
> -		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
> -			return -EOPNOTSUPP;
> -		vhost_set_backend_features(&v->vdev, features);
> -		return 0;
>  	}
>  
>  	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
> @@ -440,8 +426,20 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  	struct vhost_vdpa *v = filep->private_data;
>  	struct vhost_dev *d = &v->vdev;
>  	void __user *argp = (void __user *)arg;
> +	u64 __user *featurep = argp;
> +	u64 features;
>  	long r;
>  
> +	if (cmd == VHOST_SET_BACKEND_FEATURES) {
> +		r = copy_from_user(&features, featurep, sizeof(features));
> +		if (r)
> +			return r;
> +		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
> +			return -EOPNOTSUPP;
> +		vhost_set_backend_features(&v->vdev, features);
> +		return 0;
> +	}
> +
>  	mutex_lock(&d->mutex);
>  
>  	switch (cmd) {
> @@ -476,6 +474,10 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  	case VHOST_VDPA_SET_CONFIG_CALL:
>  		r = vhost_vdpa_set_config_call(v, argp);
>  		break;
> +	case VHOST_GET_BACKEND_FEATURES:
> +		features = VHOST_VDPA_BACKEND_FEATURES;
> +		r = copy_to_user(featurep, &features, sizeof(features));
> +		break;
>  	default:
>  		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>  		if (r == -ENOIOCTLCMD)
> -- 
> 2.20.1

