Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF684CD962
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240804AbiCDQrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbiCDQrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:47:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4A451C4B12
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 08:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646412409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=22jch4CQh+pTPL1FoGU31HpsJfvYTb0PvwQSeG+1PCc=;
        b=aWtDV/Fwu+nNQzUARr76PKqS/43D5qYOQSQ6GiGPtOUiNR/VDBt/BANQ+/9fza1TCvs0qz
        CZEbpsSMG7tej/YIc+Io0Isk/pBj7FNMHO5OZb5hwk+oZfWng/Bw3nftdu8VIetaJod42X
        hlqyHWCYQOmSTX1JUv9OEUZ0c5uK+aU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-Pi4mFxKENHCvj2Fcg1lmYA-1; Fri, 04 Mar 2022 11:46:48 -0500
X-MC-Unique: Pi4mFxKENHCvj2Fcg1lmYA-1
Received: by mail-wm1-f71.google.com with SMTP id h129-20020a1c2187000000b003898de01de4so29771wmh.7
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 08:46:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=22jch4CQh+pTPL1FoGU31HpsJfvYTb0PvwQSeG+1PCc=;
        b=XgZNrB4N2MMzq5K5HDgMKW5SZ4eDu9uP+7po3z4SR9pNvE1cJ85CiNOjdb/FtXHRmv
         /Fv2aDm/HgeRE58OqRBKGL2yjJxX302ufsax5zylvo9zSNrTMavFODicCpAe1Lb9RgPH
         LUvpNFmIIBeRaD/VLzoH1auxqh5j5XRIcVyZN4H1VQV9EysVo6eKlUYSXDJLsXLJa27Q
         0LX5ljJaJGb5bqcOedCYJpJ3wHGISV3SYmP9mfLQ23hF5GM7Bqyb1v41GGYnaNEfCDjH
         gRTNQpm4lYohZzVm1delo0pCv4qnbOQoRwswXy3XrU2tfpXVwZN7MX2lavS1d5LGDWSw
         krqA==
X-Gm-Message-State: AOAM530KMOHHrCqDbBavVCLZFxbraWiepHFmNDaOD1ZBH8dbBTTcrJCN
        9fEyPeC3mjkZNkvBmqFHtHUQR1XtAF0AYYziec7ZXian9OS/zibSKZmIpCVfP0OmclQzhIXSnVS
        WxNB5SSwcUhQw+FL7
X-Received: by 2002:a1c:2544:0:b0:381:18a:a46d with SMTP id l65-20020a1c2544000000b00381018aa46dmr8406743wml.26.1646412407387;
        Fri, 04 Mar 2022 08:46:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFF5fKg+gUWYVS+WLhpkqM4ArBwfkdD8eN2+pKg3LaCYfmdFOoWkfdheE2gdrSD+91b0K/VA==
X-Received: by 2002:a1c:2544:0:b0:381:18a:a46d with SMTP id l65-20020a1c2544000000b00381018aa46dmr8406732wml.26.1646412407138;
        Fri, 04 Mar 2022 08:46:47 -0800 (PST)
Received: from redhat.com ([2.52.16.157])
        by smtp.gmail.com with ESMTPSA id l26-20020a05600c1d1a00b00380def7d3desm5711411wms.17.2022.03.04.08.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 08:46:46 -0800 (PST)
Date:   Fri, 4 Mar 2022 11:46:42 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220304114606-mutt-send-email-mst@kernel.org>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302093446.pjq3djoqi434ehz4@sgarzare-redhat>
 <20220302083413-mutt-send-email-mst@kernel.org>
 <20220302141121.sohhkhtiiaydlv47@sgarzare-redhat>
 <20220302094946-mutt-send-email-mst@kernel.org>
 <20220302153643.glkmvnn2czrgpoyl@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302153643.glkmvnn2czrgpoyl@sgarzare-redhat>
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

On Wed, Mar 02, 2022 at 04:36:43PM +0100, Stefano Garzarella wrote:
> On Wed, Mar 02, 2022 at 09:50:38AM -0500, Michael S. Tsirkin wrote:
> > On Wed, Mar 02, 2022 at 03:11:21PM +0100, Stefano Garzarella wrote:
> > > On Wed, Mar 02, 2022 at 08:35:08AM -0500, Michael S. Tsirkin wrote:
> > > > On Wed, Mar 02, 2022 at 10:34:46AM +0100, Stefano Garzarella wrote:
> > > > > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > > > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > > > to vhost_get_vq_desc().  All we have to do is take the same lock
> > > > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > > >
> > > > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > >
> > > > > This issue is similar to [1] that should be already fixed upstream by [2].
> > > > >
> > > > > However I think this patch would have prevented some issues, because
> > > > > vhost_vq_reset() sets vq->private to NULL, preventing the worker from
> > > > > running.
> > > > >
> > > > > Anyway I think that when we enter in vhost_dev_cleanup() the worker should
> > > > > be already stopped, so it shouldn't be necessary to take the mutex. But in
> > > > > order to prevent future issues maybe it's better to take them, so:
> > > > >
> > > > > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > >
> > > > > [1]
> > > > > https://syzkaller.appspot.com/bug?id=993d8b5e64393ed9e6a70f9ae4de0119c605a822
> > > > > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9
> > > >
> > > >
> > > > Right. I want to queue this but I would like to get a warning
> > > > so we can detect issues like [2] before they cause more issues.
> > > 
> > > I agree, what about moving the warning that we already have higher up, right
> > > at the beginning of the function?
> > > 
> > > I mean something like this:
> > > 
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index 59edb5a1ffe2..1721ff3f18c0 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -692,6 +692,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > >  {
> > >         int i;
> > > +       WARN_ON(!llist_empty(&dev->work_list));
> > > +
> > >         for (i = 0; i < dev->nvqs; ++i) {
> > >                 if (dev->vqs[i]->error_ctx)
> > >                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > > @@ -712,7 +714,6 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > >         dev->iotlb = NULL;
> > >         vhost_clear_msg(dev);
> > >         wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
> > > -       WARN_ON(!llist_empty(&dev->work_list));
> > >         if (dev->worker) {
> > >                 kthread_stop(dev->worker);
> > >                 dev->worker = NULL;
> > > 
> > 
> > Hmm I'm not sure why it matters.
> 
> Because after this new patch, putting locks in the while loop, when we
> finish the loop the workers should be stopped, because vhost_vq_reset() sets
> vq->private to NULL.
> 
> But the best thing IMHO is to check that there is no backend set for each
> vq, so the workers have been stopped correctly at this point.
> 
> Thanks,
> Stefano

It's the list of workers waiting to run though. That is not affected by
vq lock at all.

-- 
MST

