Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C774CA6C6
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 14:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237809AbiCBN50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 08:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236819AbiCBN5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 08:57:23 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68682BF6C
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 05:56:39 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id b5so2946731wrr.2
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 05:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=W8D01UtJzG2MACA/9shiZ9rVVg2i2NMp5ocse6f4EOY=;
        b=DSob74kIJdRyA0VbXhRgyMD02C0hMXBzKN/Fhe1vuNvwexgeHsxu1/6cQhFmdIekKj
         NXZ6PvMUfl7oWv0bzCPKv+fo6fihSNCPXKIA76Z5C43Gpb7i2d3ecW8dLwk7pz2rln31
         +wKtzYYIl/l5TqmkbNZ7CeOCoFYnbZV7qC2rDjZ3FWiRcWsVNeJH+THOnH7Ld4gWlSbX
         n3dhyr7AckXvsUx3I5YwQhvskLgWfc8f39bKKB8mufkykzlyGGSAKtPmsQaMn7OldVcv
         zPHVqUGG7osZzohrjoPERFRQTbXak8QgdGKXGl0wo03Oe7LhcET/FBK7t8dI7VKRWsIa
         +DPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=W8D01UtJzG2MACA/9shiZ9rVVg2i2NMp5ocse6f4EOY=;
        b=PA1Mr5GLu9NPxYTEcTrj7fIQ+QrTOw5Hy2fjJSh+BQGJaX5+rQjId/pM1Z1wDJG7Bw
         VYiiVJHaN7GEGCFpx13dhP+CgSp//mZirv8ZtLgJJSKZKZ4dlfzP2uw73I+/Pvm0UFV5
         FGHVWkV6WAUMvpCmtwjC6I4hgcMBqkN0rCKiIDJyad18z8aVkAX5kjNQOsdIwhhnlL8t
         Ylh3o0rlx7PzCIYx+WyP9YPvzILTIR9vMKG6valPy0nLbS7vOaC6Mld8qEiIyFbmJgR7
         F8g3aF0KLkhQvM0etZoJ4aJBJoDK2AbqRW2xNtJT9yG2/RY90307fKZMSQq8NrGf6BIk
         +zXA==
X-Gm-Message-State: AOAM532+/3yaoBmC135+Vl8GRPpHMgMe9KYAAOsJGkv+F7yaisM3bEc3
        PTB2lqUGKyQ+M1RBNIU3h9njPA==
X-Google-Smtp-Source: ABdhPJxvTB4fYUTHq6Q8F0qC+lDtXJO6IvJq9fq5nJHg1+J4qLgqtVZgkoL1Is298lR5PX1g1c4yUQ==
X-Received: by 2002:adf:a109:0:b0:1ed:c2bd:8a57 with SMTP id o9-20020adfa109000000b001edc2bd8a57mr22607510wro.612.1646229397976;
        Wed, 02 Mar 2022 05:56:37 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id t15-20020adfe44f000000b001edbea974cesm16473010wrm.53.2022.03.02.05.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 05:56:37 -0800 (PST)
Date:   Wed, 2 Mar 2022 13:56:35 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <Yh93k2ZKJBIYQJjp@google.com>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302082021-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220302082021-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:

> On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > to vhost_get_vq_desc().  All we have to do is take the same lock
> > during virtqueue clean-up and we mitigate the reported issues.
> > 
> > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > 
> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/vhost/vhost.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 59edb5a1ffe28..bbaff6a5e21b8 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >  	int i;
> >  
> >  	for (i = 0; i < dev->nvqs; ++i) {
> > +		mutex_lock(&dev->vqs[i]->mutex);
> >  		if (dev->vqs[i]->error_ctx)
> >  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
> >  		if (dev->vqs[i]->kick)
> > @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >  		if (dev->vqs[i]->call_ctx.ctx)
> >  			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> >  		vhost_vq_reset(dev, dev->vqs[i]);
> > +		mutex_unlock(&dev->vqs[i]->mutex);
> >  	}
> 
> So this is a mitigation plan but the bug is still there though
> we don't know exactly what it is.  I would prefer adding something like
> WARN_ON(mutex_is_locked(vqs[i]->mutex) here - does this make sense?

As a rework to this, or as a subsequent patch?

Just before the first lock I assume?

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
