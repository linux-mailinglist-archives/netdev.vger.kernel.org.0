Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF67B276D84
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 11:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgIXJbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 05:31:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727351AbgIXJbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 05:31:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600939910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IivbX2PeE0RzW/9tWIJCPda1plSHGjAQvAPPVLRLJpk=;
        b=JwtkIEv82m8D5mbXzCLCSNpao7dJkjolNmTiqUaEZ3NWGU/Wh5iTpXwGIKzLvOuFmPPMWF
        xopS9jnJX80nztXJYYHmS/7Eh0/YUYWnhT3hMctl6orEMMbWDI598J4YTXRvF39oi8Hb+J
        NrgzOjlZ1uquOYwzQM8/KgVco5Jrgt4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-ZoDXV5MhOqShoYmXojpIJQ-1; Thu, 24 Sep 2020 05:31:48 -0400
X-MC-Unique: ZoDXV5MhOqShoYmXojpIJQ-1
Received: by mail-wm1-f72.google.com with SMTP id m19so1005229wmg.6
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 02:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IivbX2PeE0RzW/9tWIJCPda1plSHGjAQvAPPVLRLJpk=;
        b=E7OO+Z+RZIw/qFPrNwv+kpFbLazxfx+Rj/OLNahd/wnzJuHMcszj11CRnmHzotr8wG
         xI8Wln8VqcfOzIVkhM6G1u5xf7DRtkI+CksvzmOSPqePKKu7Ptiwzuei/3VDtMqVPnDi
         Szvz4XMJGCQrQMe+3V8QiC9fb0wZJAxKqGJM1pvLkO5pFKFuIxUPF1M718jvibLziJa9
         nEE3W9epf52H2/AMceupFB/ng6cjItUSseCOI6w5J3RMYTsVCwPvFHIubLtC7PZq+Wcz
         WXcoB8MTUQvzvLF6yONyC/euE6qSt0eJRdMMPo0hivlHaMZ8ZfBN0PkJts7Fll5V8vHm
         xRbw==
X-Gm-Message-State: AOAM530zUjkVVnmNuwJJ/Z+6OZu6UL83Dmy85Fr3QMdGP++w4iIIUMdk
        Gg3tCK93L+8jjo/SyT+9FVmTWYGA/xbnW/VppkX7SuU7d+fRxBITVcmgjePwl09vpRO0SyCAoP9
        BWzWn3EyThSvnQ2nh
X-Received: by 2002:adf:ec90:: with SMTP id z16mr3884968wrn.145.1600939906694;
        Thu, 24 Sep 2020 02:31:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz692FbM28SSNAgRM+pmYBV1x3+0U+/VUYbSIXGAG9tNcRIQZ9ScUUpWmMjwo9LJkxBth6P1g==
X-Received: by 2002:adf:ec90:: with SMTP id z16mr3884952wrn.145.1600939906533;
        Thu, 24 Sep 2020 02:31:46 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id v17sm3144042wrc.23.2020.09.24.02.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 02:31:45 -0700 (PDT)
Date:   Thu, 24 Sep 2020 05:31:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: Re: [RFC PATCH 02/24] vhost-vdpa: fix vqs leak in vhost_vdpa_open()
Message-ID: <20200924053119-mutt-send-email-mst@kernel.org>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-3-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924032125.18619-3-jasowang@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 11:21:03AM +0800, Jason Wang wrote:
> We need to free vqs during the err path after it has been allocated
> since vhost won't do that for us.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

This is a bugfix too right? I don't see it posted separately ...

> ---
>  drivers/vhost/vdpa.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 796fe979f997..9c641274b9f3 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -764,6 +764,12 @@ static void vhost_vdpa_free_domain(struct vhost_vdpa *v)
>  	v->domain = NULL;
>  }
>  
> +static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
> +{
> +	vhost_dev_cleanup(&v->vdev);
> +	kfree(v->vdev.vqs);
> +}
> +
>  static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>  {
>  	struct vhost_vdpa *v;
> @@ -809,7 +815,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>  	return 0;
>  
>  err_init_iotlb:
> -	vhost_dev_cleanup(&v->vdev);
> +	vhost_vdpa_cleanup(v);
>  err:
>  	atomic_dec(&v->opened);
>  	return r;
> @@ -840,8 +846,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>  	vhost_vdpa_free_domain(v);
>  	vhost_vdpa_config_put(v);
>  	vhost_vdpa_clean_irq(v);
> -	vhost_dev_cleanup(&v->vdev);
> -	kfree(v->vdev.vqs);
> +	vhost_vdpa_cleanup(v);
>  	mutex_unlock(&d->mutex);
>  
>  	atomic_dec(&v->opened);
> -- 
> 2.20.1

