Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2425A4D81A0
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 12:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239620AbiCNLui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 07:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239589AbiCNLuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 07:50:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7708A3F312
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 04:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647258566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2OV+JMiHtDmU80bd8QdGrPwVuVFZHYuiIn55+GlQmhk=;
        b=X9iG2BRZhp0tUxW9OLTwpp2FWKrOPP4X8rpaVEEo9CUwVMIcsE0IhDNwEnK/2vC+aE1tAo
        cNaw186OgSMOgK59GeFXNcBQdEd0UV0T5U1OXwwnZzel9iFTW2TrE9Q2Mh8unswb9nM2nA
        YJqq7CJ1SENtQiplR+rzGgV1to4unt4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-4rzBAC8GPXuGv17WieX13Q-1; Mon, 14 Mar 2022 07:49:25 -0400
X-MC-Unique: 4rzBAC8GPXuGv17WieX13Q-1
Received: by mail-wr1-f70.google.com with SMTP id x15-20020a5d6b4f000000b001ee6c0aa287so4271004wrw.9
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 04:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2OV+JMiHtDmU80bd8QdGrPwVuVFZHYuiIn55+GlQmhk=;
        b=1w7PkEIP/GbwgmBxwHAA37QOVgBp44cCGGAP/vB/BpaQ/s/ZOrGE59oZdS3V4fColJ
         bAr/DbYg7LmGSz6Cn/ncbt43HtLdKIz1mBl2H4qpd/JwC+KGibTevOQJPL5sQeUqqlWR
         Zd6D37PhLsEPNYTklEmszc4+v81rXSQANwQvGTQifgak2XFiyFGXwBi6kPrGAdl7GGmM
         gMegyET99nJD+q65rZPo/Q4FvXxrvXXhvyPbdR4zI4g71V1/F4GoVUZ86MqDu4odVbNV
         +QhsEGfQJ9tiGV8JFrJ/uNfOXezD8KHWTOoBM04ofp3VjAcWCondxBjEO0IgVk6EWPfG
         owBw==
X-Gm-Message-State: AOAM530HiMzQIdTSviaPbizc2Z3qaiRb0CwgTqlPBqnnaLegeSTrmzum
        Kn9P6rqRd+aGSkxjD09igPNCNhhgQRJvFOF/0qO6jZFHq155GM/RSBLIvL5xWqcV4prqUg96tP4
        eHn11hqkD7XsPW479
X-Received: by 2002:a7b:c4d9:0:b0:382:a5cb:ff2f with SMTP id g25-20020a7bc4d9000000b00382a5cbff2fmr24926185wmk.193.1647258563830;
        Mon, 14 Mar 2022 04:49:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0vEUQerg7rtj1M60xY/4WI1a07DNC4tgLgIhZzRrnktkhTqSbm6C/0HM52Wm6/8e4NBhRaQ==
X-Received: by 2002:a7b:c4d9:0:b0:382:a5cb:ff2f with SMTP id g25-20020a7bc4d9000000b00382a5cbff2fmr24926169wmk.193.1647258563574;
        Mon, 14 Mar 2022 04:49:23 -0700 (PDT)
Received: from redhat.com ([2.55.183.53])
        by smtp.gmail.com with ESMTPSA id v25-20020a05600c215900b0038117f41728sm18037161wml.43.2022.03.14.04.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:49:22 -0700 (PDT)
Date:   Mon, 14 Mar 2022 07:49:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220314072137-mutt-send-email-mst@kernel.org>
References: <20220314084302.2933167-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314084302.2933167-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 08:43:02AM +0000, Lee Jones wrote:
> vhost_vsock_handle_tx_kick() already holds the mutex during its call
> to vhost_get_vq_desc().  All we have to do here is take the same lock
> during virtqueue clean-up and we mitigate the reported issues.
> 
> Also WARN() as a precautionary measure.  The purpose of this is to
> capture possible future race conditions which may pop up over time.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Pls refer to my previous responses to this patch.  I'd like to see an
argument for why this will make future bugs less and not more likely.


> ---
>  drivers/vhost/vhost.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe28..bbaff6a5e21b8 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  	int i;
>  
>  	for (i = 0; i < dev->nvqs; ++i) {
> +		mutex_lock(&dev->vqs[i]->mutex);
>  		if (dev->vqs[i]->error_ctx)
>  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
>  		if (dev->vqs[i]->kick)
> @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  		if (dev->vqs[i]->call_ctx.ctx)
>  			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
>  		vhost_vq_reset(dev, dev->vqs[i]);
> +		mutex_unlock(&dev->vqs[i]->mutex);
>  	}
>  	vhost_dev_free_iovecs(dev);
>  	if (dev->log_ctx)
> -- 
> 2.35.1.723.g4982287a31-goog

