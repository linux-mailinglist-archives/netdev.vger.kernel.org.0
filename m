Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAC74CA8A1
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 15:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243307AbiCBO6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 09:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243303AbiCBO6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 09:58:18 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0F913D4A
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 06:57:33 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so1400862wmp.5
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 06:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wGGyr8F/4yesRnDkleDkSeBi9/XbD7YGJTcIBLykmxo=;
        b=YAWW5HKlB7Eey/hbn/tEyKoY+Ej9P8bjmKwFJpG4WIH2K/pus2hP+RvzIjDv6V3z5p
         k6x5v3LHFzzK0yNYVc3/6rqsj7QQzSFP9PqTvboq8Gd2h2U5akBPL3gjR8Gis5rXW7a5
         f5Wj0QWjydNWVbiao3cyHkss6w5fRltrK3+kbwT6yAe/CdOFs42vPOp9Mksavp1FhfDg
         b+8kmdCZBXU7N1sbqbnIx9h7JeO+bMDEWXRboAhQXSO6FrQS9Y2kIONVMIQBVPZeWrO0
         GsIgMsxoTCsl6Mtqj6TTCwunX0DqqFgLwCazwzkBeT0HF1oYRmofMt0ZOyXz8dF5vh/a
         nxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wGGyr8F/4yesRnDkleDkSeBi9/XbD7YGJTcIBLykmxo=;
        b=rDnnTn75hUEQu1slO5PMUf24+Z0JKZiPv2yC0Gh/4SQE9Sac9mFbY8Djbml2rkLpGB
         KM5RJ57XV1vT8MiuXa/OK9koh1jTxq7VsoNdFiL6wcXlQrigqX1Y2bhohx1cpvLRdY9I
         Vws0H71U7j0UZEZmHNB4IVCCtwsClz1rX2LWHcGMtRC3ja8ztPcSSTO2ntOQ8bJGjHnl
         Oxf1kIc3VZBJ/fLUpBQMF+1/jMED/ACjMoIrzpgq8rFGrsTyW5ZmVKRcskx9I+JRyTR+
         5kVk9KAlIM+bf3Zj0Bk/p52AQdJ6v6wtobmdvQxWZHvFIcMFZc72AmHH3eSWp3YCcSpf
         a8yQ==
X-Gm-Message-State: AOAM533ujL3/4X6/A+q8+haRgKGTQ8R2KZIrzKXWNo9Kb+FYpfxm41BK
        jwnkf+dl62t86WvVGEY0JNd3C3m6oji94XsS
X-Google-Smtp-Source: ABdhPJxDjgY35zlNFNM4bX0OTXrJd0JfiswPqCzf7heVkctOxPWyBqq7cmIrMgVAjnLfYiYdzW+RlQ==
X-Received: by 2002:a05:600c:40cf:b0:381:1f87:84c4 with SMTP id m15-20020a05600c40cf00b003811f8784c4mr102404wmh.181.1646233051757;
        Wed, 02 Mar 2022 06:57:31 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id o204-20020a1ca5d5000000b0038331f2f951sm4751221wme.0.2022.03.02.06.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 06:57:31 -0800 (PST)
Date:   Wed, 2 Mar 2022 14:57:26 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <Yh+F1gkCGoYF2lMV@google.com>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302082021-mutt-send-email-mst@kernel.org>
 <Yh93k2ZKJBIYQJjp@google.com>
 <20220302095045-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220302095045-mutt-send-email-mst@kernel.org>
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

> On Wed, Mar 02, 2022 at 01:56:35PM +0000, Lee Jones wrote:
> > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
> > 
> > > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > to vhost_get_vq_desc().  All we have to do is take the same lock
> > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > 
> > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > 
> > > > Cc: <stable@vger.kernel.org>
> > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  drivers/vhost/vhost.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index 59edb5a1ffe28..bbaff6a5e21b8 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > >  	int i;
> > > >  
> > > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > > +		mutex_lock(&dev->vqs[i]->mutex);
> > > >  		if (dev->vqs[i]->error_ctx)
> > > >  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > > >  		if (dev->vqs[i]->kick)
> > > > @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > >  		if (dev->vqs[i]->call_ctx.ctx)
> > > >  			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> > > >  		vhost_vq_reset(dev, dev->vqs[i]);
> > > > +		mutex_unlock(&dev->vqs[i]->mutex);
> > > >  	}
> > > 
> > > So this is a mitigation plan but the bug is still there though
> > > we don't know exactly what it is.  I would prefer adding something like
> > > WARN_ON(mutex_is_locked(vqs[i]->mutex) here - does this make sense?
> > 
> > As a rework to this, or as a subsequent patch?
> 
> Can be a separate patch.
> 
> > Just before the first lock I assume?
> 
> I guess so, yes.

No problem.  Patch to follow.

I'm also going to attempt to debug the root cause, but I'm new to this
subsystem to it might take a while for me to get my head around.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
