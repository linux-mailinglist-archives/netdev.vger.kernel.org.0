Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7DF47197A
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 10:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhLLJ0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 04:26:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229888AbhLLJ0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 04:26:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639301172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iOXcr6pHx2dTcXC87fAYLtq4NSmVsSlQxlt3kaDLk48=;
        b=ZIvcv8drU6jW+85nnVwBZBkygEs8cujoQgjhXMRqvbwG0DNjeNqcZ/swibDOpyKntupGxN
        XT6mWXnJhEmyNKSfKmRfYlzhwVYVeTZfneFaXGhCuxAZmoEhQnGzBZqPtAHNIHbUikkanl
        9qZeBcNJvPPpU7BwjpyFSzZY6UOLhHI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-w4CMWzEaOu-wD-UihGeAzQ-1; Sun, 12 Dec 2021 04:26:10 -0500
X-MC-Unique: w4CMWzEaOu-wD-UihGeAzQ-1
Received: by mail-wr1-f72.google.com with SMTP id q5-20020a5d5745000000b00178abb72486so3201929wrw.9
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 01:26:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iOXcr6pHx2dTcXC87fAYLtq4NSmVsSlQxlt3kaDLk48=;
        b=FSZl2J0sWAP88BHB23sHFimBkDMGdqTnLkSxa3LVQvM3GVcr3vTUTz+ADl8c0oATIB
         h+vJzN/E5e2comlBJ2+N5B0eOPfQuO7tNk6VGFxX2oq6A3HpKgeLwX/XFRHOraNXWJoa
         kWV7HmfibWQdRk1aRAzTlFiZBgtY2+pyJIi4XeoPO3Psf9S2ASVQADeBBbT2gLd3TPe+
         JeMbHqRxISeHaMoP50wTjjtmOtnGPJmJrlF/yRZ0Km7u9bjuYSPql+AutIav24b2T0Zl
         BZJfO9thZZ+TecvTWK9Rl9KRLw4wdvCW1/7pWLaiwIJ7yQhnH1NU6t0gqTSpcuyifYIs
         OxBQ==
X-Gm-Message-State: AOAM532oiUpNha319jhQRuhE0b2QrXvbWM7JblasLKN6WtvUe6OdeAni
        cWnA1SFKRwc/6LLgb4AQ+4UZLOE7tSMN2j3k87LuSnvqJOTR3dHIiuNVcJIz/yITHbCiagfLbLc
        kdqFqxLYamzS2G2Qe
X-Received: by 2002:adf:f352:: with SMTP id e18mr24921186wrp.39.1639301169219;
        Sun, 12 Dec 2021 01:26:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxtqXoz8hDbJjLt2rbzhBOfaD5dc4meh/BYw1JmqhXFGUH5XhglF+PBQQDu4hLMN81ueRNuRg==
X-Received: by 2002:adf:f352:: with SMTP id e18mr24921175wrp.39.1639301169009;
        Sun, 12 Dec 2021 01:26:09 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107e:eefb:294:6ac8:eff6:22df])
        by smtp.gmail.com with ESMTPSA id 9sm9707263wry.0.2021.12.12.01.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 01:26:08 -0800 (PST)
Date:   Sun, 12 Dec 2021 04:26:04 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Message-ID: <20211212042311-mutt-send-email-mst@kernel.org>
References: <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
> Sorry for reviving this ancient thread. I was kinda lost for the conclusion
> it ended up with. I have the following questions,
> 
> 1. legacy guest support: from the past conversations it doesn't seem the
> support will be completely dropped from the table, is my understanding
> correct? Actually we're interested in supporting virtio v0.95 guest for x86,
> which is backed by the spec at
> https://ozlabs.org/~rusty/virtio-spec/virtio-0.9.5.pdf. Though I'm not sure
> if there's request/need to support wilder legacy virtio versions earlier
> beyond.

I personally feel it's less work to add in kernel than try to
work around it in userspace. Jason feels differently.
Maybe post the patches and this will prove to Jason it's not
too terrible?

> 2. suppose some form of legacy guest support needs to be there, how do we
> deal with the bogus assumption below in vdpa_get_config() in the short term?
> It looks one of the intuitive fix is to move the vdpa_set_features call out
> of vdpa_get_config() to vdpa_set_config().
> 
>         /*
>          * Config accesses aren't supposed to trigger before features are
> set.
>          * If it does happen we assume a legacy guest.
>          */
>         if (!vdev->features_valid)
>                 vdpa_set_features(vdev, 0);
>         ops->get_config(vdev, offset, buf, len);
> 
> I can post a patch to fix 2) if there's consensus already reached.
> 
> Thanks,
> -Siwei

I'm not sure how important it is to change that.
In any case it only affects transitional devices, right?
Legacy only should not care ...


> On 3/2/2021 2:53 AM, Jason Wang wrote:
> > 
> > On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
> > > On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
> > > > On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
> > > > > On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> > > > > > > Detecting it isn't enough though, we will need a new ioctl to notify
> > > > > > > the kernel that it's a legacy guest. Ugh :(
> > > > > > Well, although I think adding an ioctl is doable, may I
> > > > > > know what the use
> > > > > > case there will be for kernel to leverage such info
> > > > > > directly? Is there a
> > > > > > case QEMU can't do with dedicate ioctls later if there's indeed
> > > > > > differentiation (legacy v.s. modern) needed?
> > > > > BTW a good API could be
> > > > > 
> > > > > #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > 
> > > > > we did it per vring but maybe that was a mistake ...
> > > > 
> > > > Actually, I wonder whether it's good time to just not support
> > > > legacy driver
> > > > for vDPA. Consider:
> > > > 
> > > > 1) It's definition is no-normative
> > > > 2) A lot of budren of codes
> > > > 
> > > > So qemu can still present the legacy device since the config
> > > > space or other
> > > > stuffs that is presented by vhost-vDPA is not expected to be
> > > > accessed by
> > > > guest directly. Qemu can do the endian conversion when necessary
> > > > in this
> > > > case?
> > > > 
> > > > Thanks
> > > > 
> > > Overall I would be fine with this approach but we need to avoid breaking
> > > working userspace, qemu releases with vdpa support are out there and
> > > seem to work for people. Any changes need to take that into account
> > > and document compatibility concerns.
> > 
> > 
> > Agree, let me check.
> > 
> > 
> > >   I note that any hardware
> > > implementation is already broken for legacy except on platforms with
> > > strong ordering which might be helpful in reducing the scope.
> > 
> > 
> > Yes.
> > 
> > Thanks
> > 
> > 
> > > 
> > > 
> > 

