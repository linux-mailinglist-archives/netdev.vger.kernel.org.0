Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12BB2723F6
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIUMfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:35:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27488 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726689AbgIUMfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:35:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600691722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rwqqgkk5n+jk3i2GLt6oUS3tq+OlXcmqXoPG/Cpdq0s=;
        b=g9bXgVhzBwYlYiIJzoNqhdS8okCejX4QfL1XwjLlanQh5VWh2cNafbfnMcz+pU9myaatI7
        S+Hiwyq1rVmTjn0Hn86RVXdO46/FaC608GrzxCS0Ra1x1exD9JICvCjgSqvfYX8KP9w0fl
        34fwSYG0DjvurJtLZNvQYDOccI83vYA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-YfL0KiIqPO-lPK_elnAk7Q-1; Mon, 21 Sep 2020 08:35:20 -0400
X-MC-Unique: YfL0KiIqPO-lPK_elnAk7Q-1
Received: by mail-wr1-f72.google.com with SMTP id n15so5782449wrv.23
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rwqqgkk5n+jk3i2GLt6oUS3tq+OlXcmqXoPG/Cpdq0s=;
        b=YwwgCzQjTwAu0z8iRbKaNcIH+hRhedQunlPrN+t/+2vu3psU/Pnr+5cJrde2sDDuIG
         UgSixe/4ybLakDT4a9LIyzgTVwh7Uy2g1FsfQc0muV+H+dIwAGdUvM4RHEOaxgvW8Opg
         6aAYILktOKLF/k3l0sQJUDwZQtoJKlRVZWU1xqV9OT1d3nBDCwfqR87r8MBRWKqxUaQo
         H7g3XFK0h3VKAmC2siM10KChMEDvy74uBEltWsgct0y/oqmLmbRrVoLngfNfioArVV/N
         vTzbSV2nbU0VihMrl+RMWibWa0AI7x7BPmBGJ5a9wzm4wyAUuT8N0SAF8CBm2fTcgrlw
         Lc5Q==
X-Gm-Message-State: AOAM531xmbVJTg2erd/F6qIALBgE5B9mugu0sLvsA5Rc17N8FFmylPoN
        +egN9CaNU+Cp2z4pTS8tAotV5bKeAh9nOw/drlhV0EhyFSbuW5wPhHfoP2FfA46l0kkjf81nRDo
        +qv71KqICVn0qhxWt
X-Received: by 2002:a7b:c38f:: with SMTP id s15mr30608515wmj.16.1600691719646;
        Mon, 21 Sep 2020 05:35:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk8SI4MxU+bTgGCiPisNoMYNBLevVyLRA9Cuhq7q4wZQLmwfsI5OpJ5XpRgd2fRnEGpQ1TYA==
X-Received: by 2002:a7b:c38f:: with SMTP id s15mr30608497wmj.16.1600691719495;
        Mon, 21 Sep 2020 05:35:19 -0700 (PDT)
Received: from redhat.com (bzq-109-65-116-225.red.bezeqint.net. [109.65.116.225])
        by smtp.gmail.com with ESMTPSA id f6sm20641849wro.5.2020.09.21.05.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:35:18 -0700 (PDT)
Date:   Mon, 21 Sep 2020 08:35:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] vhost: remove mutex ops in vhost_set_backend_features
Message-ID: <20200921083506-mutt-send-email-mst@kernel.org>
References: <20200907105220.27776-1-lingshan.zhu@intel.com>
 <20200907105220.27776-2-lingshan.zhu@intel.com>
 <20200908080513-mutt-send-email-mst@kernel.org>
 <34c0bc00-e5f1-1306-d705-72758c50872e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34c0bc00-e5f1-1306-d705-72758c50872e@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 09:00:19PM +0800, Zhu, Lingshan wrote:
> 
> On 9/8/2020 8:05 PM, Michael S. Tsirkin wrote:
> 
>     On Mon, Sep 07, 2020 at 06:52:19PM +0800, Zhu Lingshan wrote:
> 
>         In vhost_vdpa ioctl SET_BACKEND_FEATURES path, currect code
>         would try to acquire vhost dev mutex twice
>         (first shown in vhost_vdpa_unlocked_ioctl), which can lead
>         to a dead lock issue.
>         This commit removed mutex operations in vhost_set_backend_features.
>         As a compensation for vhost_net, a followinig commit will add
>         needed mutex lock/unlock operations in a new function
>         vhost_net_set_backend_features() which is a wrap of
>         vhost_set_backend_features().
> 
>         Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> 
>     I think you need to squash these two or reorder, we can't first
>     make code racy then fix it up.
> 
> OK, I will send a V2 series with Jason's fixes tomorrow (handle SET/GET_BACKEND_FEATURES in vhost_vdpa ioctl than vring ioctl).
> 
> Thanks,
> BR
> Zhu Lingshan


this never materialized ...

> 
> 
>         ---
>          drivers/vhost/vhost.c | 2 --
>          1 file changed, 2 deletions(-)
> 
>         diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>         index b45519ca66a7..e03c9e6f058f 100644
>         --- a/drivers/vhost/vhost.c
>         +++ b/drivers/vhost/vhost.c
>         @@ -2591,14 +2591,12 @@ void vhost_set_backend_features(struct vhost_dev *dev, u64 features)
>                 struct vhost_virtqueue *vq;
>                 int i;
> 
>         -       mutex_lock(&dev->mutex);
>                 for (i = 0; i < dev->nvqs; ++i) {
>                         vq = dev->vqs[i];
>                         mutex_lock(&vq->mutex);
>                         vq->acked_backend_features = features;
>                         mutex_unlock(&vq->mutex);
>                 }
>         -       mutex_unlock(&dev->mutex);
>          }
>          EXPORT_SYMBOL_GPL(vhost_set_backend_features);
> 
>         --
>         2.18.4
> 

