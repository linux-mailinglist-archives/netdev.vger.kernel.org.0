Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE332612DB
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 16:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbgIHOjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 10:39:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54203 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729844AbgIHO0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 10:26:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599575163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uTbg/F8EMJz/zWHZGHElfxdFbIFaiE/jJsKyDwICFFY=;
        b=hkHT2HmkuGHo40OTKmRMTEF9oaIFN5uODhUQHWSOcP0h5AFbbAuojQZvOMpil8dw3zltXv
        fAZg7GUx5Gxe7M3xXWHQuVJGuD0Zy308GqRoGionQcem6nxAzA9QTDhsl+gMs1Bz8P3ec/
        1dVkwDe8iXC6/gYjie/y0ugHrpg0hEY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-l1LlA_F0NHq83EvrZIG2Ow-1; Tue, 08 Sep 2020 08:05:50 -0400
X-MC-Unique: l1LlA_F0NHq83EvrZIG2Ow-1
Received: by mail-wm1-f72.google.com with SMTP id w3so4662276wmg.4
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 05:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uTbg/F8EMJz/zWHZGHElfxdFbIFaiE/jJsKyDwICFFY=;
        b=j/Xz20sjhwqS0kL3MJt7qdpVBFrbGdciDWDVLWTs4ULn1OHvpL3lEdsBFWQStRYtEJ
         dbcbpQhYYKX3oOz6BrTtN+3r5orzAm80HEGaJfUGo627A3Cse3B7HZCcNjounsQk3z0E
         cD6SELX6uVBc9lXdt6PGMXqZ1Y7qNlpJ2gAEf0YIONnquXSbfeqKiiSMzQdrsoDGiyys
         H1N4IQblqSVIUl+W/QWZuBQ+ZaFhAdPWtRYTrnNYNeKSKDyFSokNxlLeCLM1fdIX7jPQ
         Z7vYNfthBG0KHfoB3aJTx1koo9wX5bdMSg1HbLbf1+R2OCLNo8v2Cw5vJuWSxQAK9SJF
         ruaA==
X-Gm-Message-State: AOAM5315t+8dON8JeLh5ksA7TcLRRso7h6JnkBFA3GCQZ7sjK3Nk5Vsy
        Vgjr4Ag0RlPejjUIDRyEFJJxDuKHVFvxkTbLiJzM6BsByKZxEOcwD3/GWaV8il5I2giVfTunTp4
        y8F8b1guWBUksJD0r
X-Received: by 2002:a1c:80d7:: with SMTP id b206mr4062491wmd.161.1599566749490;
        Tue, 08 Sep 2020 05:05:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1voR2aDQ/omOiAhnyNbh20XUmSq/vHolLDEZXQW14ePuREj8QwPqWOFx4FPXk1oqmTfQ+LA==
X-Received: by 2002:a1c:80d7:: with SMTP id b206mr4062476wmd.161.1599566749321;
        Tue, 08 Sep 2020 05:05:49 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-218-236.inter.net.il. [80.230.218.236])
        by smtp.gmail.com with ESMTPSA id l8sm34308524wrx.22.2020.09.08.05.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 05:05:48 -0700 (PDT)
Date:   Tue, 8 Sep 2020 08:05:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] vhost: remove mutex ops in vhost_set_backend_features
Message-ID: <20200908080513-mutt-send-email-mst@kernel.org>
References: <20200907105220.27776-1-lingshan.zhu@intel.com>
 <20200907105220.27776-2-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907105220.27776-2-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 06:52:19PM +0800, Zhu Lingshan wrote:
> In vhost_vdpa ioctl SET_BACKEND_FEATURES path, currect code
> would try to acquire vhost dev mutex twice
> (first shown in vhost_vdpa_unlocked_ioctl), which can lead
> to a dead lock issue.
> This commit removed mutex operations in vhost_set_backend_features.
> As a compensation for vhost_net, a followinig commit will add
> needed mutex lock/unlock operations in a new function
> vhost_net_set_backend_features() which is a wrap of
> vhost_set_backend_features().
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

I think you need to squash these two or reorder, we can't first
make code racy then fix it up.

> ---
>  drivers/vhost/vhost.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b45519ca66a7..e03c9e6f058f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2591,14 +2591,12 @@ void vhost_set_backend_features(struct vhost_dev *dev, u64 features)
>  	struct vhost_virtqueue *vq;
>  	int i;
>  
> -	mutex_lock(&dev->mutex);
>  	for (i = 0; i < dev->nvqs; ++i) {
>  		vq = dev->vqs[i];
>  		mutex_lock(&vq->mutex);
>  		vq->acked_backend_features = features;
>  		mutex_unlock(&vq->mutex);
>  	}
> -	mutex_unlock(&dev->mutex);
>  }
>  EXPORT_SYMBOL_GPL(vhost_set_backend_features);
>  
> -- 
> 2.18.4

