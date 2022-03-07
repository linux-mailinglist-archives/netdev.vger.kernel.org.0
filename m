Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A84D0B3F
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343804AbiCGWiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343809AbiCGWiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:38:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EB7D70841
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 14:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646692646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z8UjngamxI9B+AYkCciPjNfNT+6reXZ4EgmCRb4lE+4=;
        b=CDW/m6WWluNXHqt5ZGLDL8J93iH3W3jES8rvFLxvjnE2GRZtUqjqTE+bfABVzWEwx52HPO
        6LQeWvZ6yqtjsYyDW2pM4RBoLHgGZmL0hkMVgGWlOyDgtkuPgRTKIrwikK0rwXF3LQtb/f
        03N3+G6UvwdgWTh7iGb65AAYxq/l2pw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-LSy7IR79ORSWfbKNjvh-GQ-1; Mon, 07 Mar 2022 17:37:25 -0500
X-MC-Unique: LSy7IR79ORSWfbKNjvh-GQ-1
Received: by mail-ed1-f70.google.com with SMTP id n11-20020aa7c68b000000b0041641550e11so3085811edq.8
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 14:37:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z8UjngamxI9B+AYkCciPjNfNT+6reXZ4EgmCRb4lE+4=;
        b=IteyLyJxyNf0UUohsYGOuW9XriWLLJfhWZTeOxJgENUnhUoVI7RWw8CWotghQkjkKY
         firwsT/s7q9LWeNqo9FlplKbFLFfhrxk7hFelq63UKURkSuTBtB8Ew5OHVbTRKrfpasp
         QYn7XGcvAzUTpjuAatwccjWcCki4hO5nAs8tXp1g9k5NDc2LnjqCwANBLYYad1+Zs3O2
         CUbw55ph1cHBMg5EIrwNTLJ/JaIdZolnx+K8kR+t+0l7fc4ypMlUMPfLJkQd4jnTM+gV
         UAwVsjjsSst5Z3Nczb3mFzxTEHJZjcrmW8sKyeCdhafcXpK86nxb4Q9XFj2m7ArkIJ9O
         6rPQ==
X-Gm-Message-State: AOAM531RL4UnKCc8JdsHcF9KObh/I3QDSYzHHDp8CMyCR3E8pODPmGMu
        SEZFeXCj48WI5Nqq2Tkgp+3GZP4SVBVnvjWcU0ehncJCxC1Ac6aT0EO7OtZaD3VSv5ifmj+VlaA
        YCqjtLbf+f000Z+lD
X-Received: by 2002:a05:6402:644:b0:416:4ade:54e3 with SMTP id u4-20020a056402064400b004164ade54e3mr5993883edx.222.1646692642162;
        Mon, 07 Mar 2022 14:37:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDQfReYKCLxP7wgXRhk5w7cO+7IyYbZrZcsq5S+N9M32u3NyUw3dG6w3ZKY6BWETW8k6zHrA==
X-Received: by 2002:a05:6402:644:b0:416:4ade:54e3 with SMTP id u4-20020a056402064400b004164ade54e3mr5993869edx.222.1646692641977;
        Mon, 07 Mar 2022 14:37:21 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id w14-20020a170906d20e00b006cee22553f7sm5205644ejz.213.2022.03.07.14.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:37:21 -0800 (PST)
Date:   Mon, 7 Mar 2022 17:37:18 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220307173439-mutt-send-email-mst@kernel.org>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307191757.3177139-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> vhost_vsock_handle_tx_kick() already holds the mutex during its call
> to vhost_get_vq_desc().  All we have to do here is take the same lock
> during virtqueue clean-up and we mitigate the reported issues.

Pls just basically copy the code comment here. this is just confuses.

> Also WARN() as a precautionary measure.  The purpose of this is to
> capture possible future race conditions which may pop up over time.
> 
> Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00

And this is a bug we already fixed, right?

> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com

not really applicable anymore ...

> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/vhost/vhost.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe28..ef7e371e3e649 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  	int i;
>  
>  	for (i = 0; i < dev->nvqs; ++i) {
> +		/* No workers should run here by design. However, races have
> +		 * previously occurred where drivers have been unable to flush
> +		 * all work properly prior to clean-up.  Without a successful
> +		 * flush the guest will malfunction, but avoiding host memory
> +		 * corruption in those cases does seem preferable.
> +		 */
> +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> +
> +		mutex_lock(&dev->vqs[i]->mutex);
>  		if (dev->vqs[i]->error_ctx)
>  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
>  		if (dev->vqs[i]->kick)
> @@ -700,6 +709,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  		if (dev->vqs[i]->call_ctx.ctx)
>  			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
>  		vhost_vq_reset(dev, dev->vqs[i]);
> +		mutex_unlock(&dev->vqs[i]->mutex);
>  	}
>  	vhost_dev_free_iovecs(dev);
>  	if (dev->log_ctx)
> -- 
> 2.35.1.616.g0bdcbb4464-goog

