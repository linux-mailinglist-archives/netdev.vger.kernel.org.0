Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE0242FC95
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 21:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242868AbhJOT4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 15:56:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242805AbhJOT4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 15:56:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634327669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjEbcwJXPeNzawEznVGMrMsBe5Mx657awI84UVBQf88=;
        b=iHWOckWWGPPGoVH6yYfy6cYBQnKnlVdrqMc1qGPgoKUr9toIngDwbMm5p8HXKMHFxVwZ6K
        f2ef6fre5YyM8iK2fPyMNsz6S7gEt65/WieBtqtKZG9OPXo/GuXjaKVErhYeMeHV7HHgl3
        ne9sf7nW+GN8sfLJO2zCS+9YXvIfn4U=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513--uw_IDYcPJi2npnb-HJcFA-1; Fri, 15 Oct 2021 15:54:26 -0400
X-MC-Unique: -uw_IDYcPJi2npnb-HJcFA-1
Received: by mail-ot1-f71.google.com with SMTP id i19-20020a9d6113000000b0054d959c7498so6168908otj.23
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 12:54:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NjEbcwJXPeNzawEznVGMrMsBe5Mx657awI84UVBQf88=;
        b=CpFhpjek1ymUQKaWrGipy7aI6QbLIQj5r+o8cN8GValiEJZqOU8XBdB1zC4AuvDgAW
         JvNPzpBYOtC7fs+j7Rbe6pq+QZgenQw1NHOF2RCHWen7a3oCCwHIYGDgwcSPArNpYvmk
         QXOF0id8X0SyCB0hy02YcV7JZdNfULr+RO3GTbqhDZkgnxeFUlYG61PLJ2VbkZYrGJjj
         vEB7FjGZzBfG8KQuiNwZvwRFqpDZr7RWrculh9Wu7kwJmGcWSy7ztIhPA+zLos5zjnva
         HnZ67osyGuaQ8wL7oBYEKgr7T1KSz/ZPVyTKWsoMZO9vJBQy5giOnHcOOrb8zTkZN/j+
         x3lA==
X-Gm-Message-State: AOAM530NsxqrkIzrWVh8nvfGfgHm0XbFQbxTU6QUdkY1zAwA67hyAXfy
        UDxwmTdcsbG+3T+aQ9nXciRS+FtAbV8rUey6edVzD+umx5UlEAAv64JYXSGgRFXsO+QXbnbnkM7
        TH8CGmRxSv25Fcv12
X-Received: by 2002:a05:6830:31b3:: with SMTP id q19mr9345826ots.2.1634327665458;
        Fri, 15 Oct 2021 12:54:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6NoACyVD6ADSV4rkjsWjJ5hmWgFi3c/Z4bw4ieq9WBxteAkcQmlbzt7SDuxoRkXcjpCp2Jw==
X-Received: by 2002:a05:6830:31b3:: with SMTP id q19mr9345819ots.2.1634327665303;
        Fri, 15 Oct 2021 12:54:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f14sm1163491oop.8.2021.10.15.12.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 12:54:24 -0700 (PDT)
Date:   Fri, 15 Oct 2021 13:54:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, <bhelgaas@google.com>,
        <saeedm@nvidia.com>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <kwankhede@nvidia.com>,
        <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 mlx5-next 13/13] vfio/mlx5: Trap device RESET and
 update state accordingly
Message-ID: <20211015135423.5f8db5d7.alex.williamson@redhat.com>
In-Reply-To: <cae3309e-4175-b134-c1f6-5ec02f352078@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
        <20211013094707.163054-14-yishaih@nvidia.com>
        <20211013180651.GM2744544@nvidia.com>
        <cae3309e-4175-b134-c1f6-5ec02f352078@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 12:18:30 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 10/13/2021 9:06 PM, Jason Gunthorpe wrote:
> > On Wed, Oct 13, 2021 at 12:47:07PM +0300, Yishai Hadas wrote:  
> >> Trap device RESET and update state accordingly, it's done by registering
> >> the matching callbacks.
> >>
> >> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >>   drivers/vfio/pci/mlx5/main.c | 17 ++++++++++++++++-
> >>   1 file changed, 16 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> >> index e36302b444a6..8fe44ed13552 100644
> >> +++ b/drivers/vfio/pci/mlx5/main.c
> >> @@ -613,6 +613,19 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
> >>   	.match = vfio_pci_core_match,
> >>   };
> >>   
> >> +static void mlx5vf_reset_done(struct vfio_pci_core_device *core_vdev)
> >> +{
> >> +	struct mlx5vf_pci_core_device *mvdev = container_of(
> >> +			core_vdev, struct mlx5vf_pci_core_device,
> >> +			core_device);
> >> +
> >> +	mvdev->vmig.vfio_dev_state = VFIO_DEVICE_STATE_RUNNING;  
> > This should hold the state mutex too
> >  
> Thanks Jason, I'll add as part of V2.
> 
> Alex,
> 
> Any feedback from your side before that we'll send V2 ?
> 
> We already got ACK for the PCI patches, there are some minor changes to 
> be done so far.

Provided.  Thanks,

Alex

