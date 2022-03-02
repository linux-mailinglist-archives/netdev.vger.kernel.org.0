Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF0D4CA0EB
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 10:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240540AbiCBJfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 04:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236415AbiCBJfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 04:35:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44448BAB92
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 01:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646213698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4AbAW59nDe9iXOUa0NZzg+mzBzM1DTimtc+hATy3tFU=;
        b=W2jXBPy60sgnNOKWmSFqcEFRWt4SXLAzCxekHBkaPKpSdK7kB/0W/FVgwcCkeYa6xtZ062
        LGvOcCJkSwaaZcPua/3mZx9hReA3d6uZ/iKQetFC/HKjZvaO6o1tq99JP2dpYrkXCiHqcZ
        4rMaP0v33NM0Eo8wmquNj/+67sQrADI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-lTsq0ByzOpKkURKTsTSlDA-1; Wed, 02 Mar 2022 04:34:57 -0500
X-MC-Unique: lTsq0ByzOpKkURKTsTSlDA-1
Received: by mail-qt1-f200.google.com with SMTP id g12-20020ac870cc000000b002deadca844eso883761qtp.6
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 01:34:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4AbAW59nDe9iXOUa0NZzg+mzBzM1DTimtc+hATy3tFU=;
        b=hF4214K5PdmbRSDXCfmSz0pR3qReHyidUKsi1a6wwLwBpIHE+ImmFakxmYIlQypYi5
         xIP1VmogNIl2CcmtvOSRUivgjggBmolx+5KhxzQWvqM1vv7tQAb9k11q9tzYHvZCKG8R
         EDoW9rO9PlvnzmGzS4flrpkRi6qD/bKvpDCRIPa9HgkOXC4QRP00qh3CVHKknlmXaqFO
         Hs83GVMtATC5WwDw/jNoIiismpUUCB5jCMhE/615JPMqm5GzOWEVx/RknJ5SkOvo/7qe
         +hPfLeSLid+OWO0ix++lyLMDnrd2U/qJa4FyRUpocMy9CthJquayw1II6QgwFyYMVu6/
         UQvw==
X-Gm-Message-State: AOAM532nCYXqUFSzceRoTV+1tIVwSnQd57m5cdiRDWfhaxSIaxN9D497
        hA6vuBFMsjfET7Fk62WDIluijC/Dlt9vCsMoBtDBvUCN73STwaGTkeaebZXs+JXE3V6AUo3qOuV
        bsYzIDtrmkb90ZTIm
X-Received: by 2002:a05:622a:589:b0:2de:9437:a380 with SMTP id c9-20020a05622a058900b002de9437a380mr22719618qtb.593.1646213695548;
        Wed, 02 Mar 2022 01:34:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyC7INR2ARPeT61tUoT3peU6aDKB65/ufMp14UgRUKuFsJtDC2iNl/gqIBFpEUP3M458d4Gpw==
X-Received: by 2002:a05:622a:589:b0:2de:9437:a380 with SMTP id c9-20020a05622a058900b002de9437a380mr22719598qtb.593.1646213695279;
        Wed, 02 Mar 2022 01:34:55 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id h3-20020a05622a170300b002e008a93f8fsm6551504qtk.91.2022.03.02.01.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 01:34:54 -0800 (PST)
Date:   Wed, 2 Mar 2022 10:34:46 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220302093446.pjq3djoqi434ehz4@sgarzare-redhat>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220302075421.2131221-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
>vhost_vsock_handle_tx_kick() already holds the mutex during its call
>to vhost_get_vq_desc().  All we have to do is take the same lock
>during virtqueue clean-up and we mitigate the reported issues.
>
>Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00

This issue is similar to [1] that should be already fixed upstream by 
[2].

However I think this patch would have prevented some issues, because 
vhost_vq_reset() sets vq->private to NULL, preventing the worker from 
running.

Anyway I think that when we enter in vhost_dev_cleanup() the worker 
should be already stopped, so it shouldn't be necessary to take the 
mutex. But in order to prevent future issues maybe it's better to take 
them, so:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

[1] 
https://syzkaller.appspot.com/bug?id=993d8b5e64393ed9e6a70f9ae4de0119c605a822
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9

>
>Cc: <stable@vger.kernel.org>
>Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
>Signed-off-by: Lee Jones <lee.jones@linaro.org>
>---
> drivers/vhost/vhost.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>index 59edb5a1ffe28..bbaff6a5e21b8 100644
>--- a/drivers/vhost/vhost.c
>+++ b/drivers/vhost/vhost.c
>@@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> 	int i;
>
> 	for (i = 0; i < dev->nvqs; ++i) {
>+		mutex_lock(&dev->vqs[i]->mutex);
> 		if (dev->vqs[i]->error_ctx)
> 			eventfd_ctx_put(dev->vqs[i]->error_ctx);
> 		if (dev->vqs[i]->kick)
>@@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> 		if (dev->vqs[i]->call_ctx.ctx)
> 			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> 		vhost_vq_reset(dev, dev->vqs[i]);
>+		mutex_unlock(&dev->vqs[i]->mutex);
> 	}
> 	vhost_dev_free_iovecs(dev);
> 	if (dev->log_ctx)
>-- 
>2.35.1.574.g5d30c73bfb-goog
>

