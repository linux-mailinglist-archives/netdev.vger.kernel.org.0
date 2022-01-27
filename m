Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D9249E2B2
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 13:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241437AbiA0MmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 07:42:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236655AbiA0MmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 07:42:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643287332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uNXpPtb2OXqXG9hmJBWkzD608J4s2s8/JsJidLVyecU=;
        b=dGDNS6mI9GPE3Sh2E80c0kXgtlr2Zav50yLqxVtOS1IWZxCe9ohpCQ+34eNt1dtS6ZjUdA
        MJIvez47mRYRVifwqnI9JpSs5gMydbMLA4cFdFe9s03Ob755HiRqKqz+lMCIngYUciZH5N
        CFSxk7vj/gvgwn9tYHVzH3VEqD1qUbo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-wI5Nayr3O_myUzE-YsaQaA-1; Thu, 27 Jan 2022 07:42:11 -0500
X-MC-Unique: wI5Nayr3O_myUzE-YsaQaA-1
Received: by mail-ej1-f69.google.com with SMTP id x16-20020a170906135000b006b5b4787023so1279299ejb.12
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 04:41:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uNXpPtb2OXqXG9hmJBWkzD608J4s2s8/JsJidLVyecU=;
        b=GSk9qhVEKSlyfzeZ1q7f6Fp12AyTKlIrnLsxf0Cj/1pnGYNU25aDehG1wd4hAPmwfi
         xZDBYi64PVdUXELZFQXF+8PK8GRoWFFzrJo8qTJHJY/PMXPHIYNbEHhnYBYhm9iSzzkL
         rqndBsE12omJqPyCjGSHPnPLaMqN9W0l/DFhc9zynkUhR7eNMT8gfaBDBeb+oUtyoRte
         ZzKMD1WwwhAEFTCVf4WAwJMvK4rS3ADjmbqol/Da/xYM7XdcRUzH4Fzi5QtPwg4usXLS
         LRxdrRxmBP6yICTJFyO+qlqSXYZ+PGZxnZwtNUMXH+liGcGT68veI9FDUn/3Z2vJOv23
         cCyg==
X-Gm-Message-State: AOAM533KDg/+tb8D7xxHZgCIb8DhfaiuUJ5QXE8MpX9tBb8kYfvgzFqS
        wEIa5zfRWf2CoI6lWQIwFPuw4/pX8qnCP+RHKPiL1D0CbjZbQbVgDiVkoClCccJKOjYYed6Ciuk
        eXa0+iu1ldf31DIAc
X-Received: by 2002:a17:907:7d89:: with SMTP id oz9mr2684963ejc.400.1643287308392;
        Thu, 27 Jan 2022 04:41:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyotloQ/8jLEyYVrL4x9QKTye3cSBEx1XpJh+giSQrDeyBAnixpRAjtIqNHOtrp8KFRexubOA==
X-Received: by 2002:a17:907:7d89:: with SMTP id oz9mr2684950ejc.400.1643287308220;
        Thu, 27 Jan 2022 04:41:48 -0800 (PST)
Received: from redhat.com ([2.55.140.126])
        by smtp.gmail.com with ESMTPSA id g9sm8674052ejf.98.2022.01.27.04.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 04:41:47 -0800 (PST)
Date:   Thu, 27 Jan 2022 07:41:44 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yin Xiujiang <yinxiujiang@kylinos.cn>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: Make use of the helper macro kthread_run()
Message-ID: <20220127074050-mutt-send-email-mst@kernel.org>
References: <20220127020807.844630-1-yinxiujiang@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127020807.844630-1-yinxiujiang@kylinos.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 10:08:07AM +0800, Yin Xiujiang wrote:
> Repalce kthread_create/wake_up_process() with kthread_run()
> to simplify the code.
> 
> Signed-off-by: Yin Xiujiang <yinxiujiang@kylinos.cn>
> ---
>  drivers/vhost/vhost.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..19e9eda9fc71 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -595,7 +595,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  
>  	dev->kcov_handle = kcov_common_handle();
>  	if (dev->use_worker) {
> -		worker = kthread_create(vhost_worker, dev,
> +		worker = kthread_run(vhost_worker, dev,
>  					"vhost-%d", current->pid);
>  		if (IS_ERR(worker)) {
>  			err = PTR_ERR(worker);
> @@ -603,7 +603,6 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  		}
>  
>  		dev->worker = worker;
> -		wake_up_process(worker); /* avoid contributing to loadavg */
>  
>  		err = vhost_attach_cgroups(dev);
>  		if (err)

I think if you do this, you need to set dev->worker earlier.

> -- 
> 2.30.0

