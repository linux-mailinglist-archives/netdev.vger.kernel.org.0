Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C35F48F34C
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 00:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiANX6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 18:58:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229554AbiANX6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 18:58:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642204711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z96rFxjaZq03HF+/4vSJxCOyIeHO3mdhR6fuB13CdmU=;
        b=Ulcq29WqJT6meBAZAorRupUx5xbw6/cifjPH5jzJh5f3xmvzuCCy4DO0YepZO7BN072ipw
        xIkQpQfItsNcHS89jC9L1E5ChL/b7poI/WF+MHO34dYJ2vgMDmtlBjNNDQMn8B9LwMr1uB
        NhM3dCKGkZ6+ohGhCPy5wjLOzj58p20=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-HXiQ4NBuMw6wPCf00kIQfQ-1; Fri, 14 Jan 2022 18:58:30 -0500
X-MC-Unique: HXiQ4NBuMw6wPCf00kIQfQ-1
Received: by mail-ed1-f71.google.com with SMTP id y18-20020a056402271200b003fa16a5debcso9467368edd.14
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 15:58:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z96rFxjaZq03HF+/4vSJxCOyIeHO3mdhR6fuB13CdmU=;
        b=XrH8Ce2U1iq8LCKgVfDZj0nvhAMFUPFaGf60WVzUIJGUKy4BC4jYGRSVor/6G6ZkNt
         5oOEsJ7AYpZbnwfOBwRG1LaPxGVdvQoQUn5eDZYkF2oUFrGqEFkYmgbU32zCdqy0UNig
         b/Hb2MFs3vERra5LoiIxnQ7+rUtQW0lGIxrwFsmZzFTdeFj0DrAaRUanHWgjbZZyKMsC
         IboQs2nvmLJ1cFyaTZRreNUd2Kxb+vqDcyZkwhmi9wH/JoGTJMIkHPdg8BxLKzvWCShH
         mplTfzCZUwwN5Rqj174dVlltZ/FMdOrlNVuYQnf3oUKyz2nzd/vFXB2q4O8DKnjwGCFI
         hGKQ==
X-Gm-Message-State: AOAM532g5u8U3j3znreBDCIc0rWPUk2Cdj95CKWdVOsZy2Hp3daRGCXl
        EL2Yi5leFihWGymepx69RjcR0f6fjpe5RRk4lmLEU3brWV7sbPx2SAYd+eJrEW07B7cnDD1sf8G
        Fh0VcTUcGYMGpIFSv
X-Received: by 2002:a17:907:2d0c:: with SMTP id gs12mr8944367ejc.4.1642204709502;
        Fri, 14 Jan 2022 15:58:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxW2fvrNZm9/TYOc8HE5c1s8HuiVecialuIVfXhWTkeTLHQJd93BZCE8SXVRzIjzngp0E7DEQ==
X-Received: by 2002:a17:907:2d0c:: with SMTP id gs12mr8944357ejc.4.1642204709309;
        Fri, 14 Jan 2022 15:58:29 -0800 (PST)
Received: from redhat.com ([2.55.154.210])
        by smtp.gmail.com with ESMTPSA id f27sm1466917ejd.95.2022.01.14.15.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:58:28 -0800 (PST)
Date:   Fri, 14 Jan 2022 18:58:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christophe.jaillet@wanadoo.fr, dapeng1.mi@intel.com,
        david@redhat.com, elic@nvidia.com, eperezma@redhat.com,
        flyingpenghao@gmail.com, flyingpeng@tencent.com,
        gregkh@linuxfoundation.org, guanjun@linux.alibaba.com,
        jasowang@redhat.com, jiasheng@iscas.ac.cn, johan@kernel.org,
        keescook@chromium.org, labbott@kernel.org, lingshan.zhu@intel.com,
        lkp@intel.com, luolikang@nsfocus.com, lvivier@redhat.com,
        pasic@linux.ibm.com, sgarzare@redhat.com, somlo@cmu.edu,
        trix@redhat.com, wu000273@umn.edu, xianting.tian@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, yun.wang@linux.alibaba.com
Subject: Re: [GIT PULL] virtio,vdpa,qemu_fw_cfg: features, cleanups, fixes
Message-ID: <20220114185801-mutt-send-email-mst@kernel.org>
References: <20220114153515-mutt-send-email-mst@kernel.org>
 <YeHjbqjY8Dd+3o1E@larix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeHjbqjY8Dd+3o1E@larix>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 08:56:14PM +0000, Jean-Philippe Brucker wrote:
> Hi,
> 
> On Fri, Jan 14, 2022 at 03:35:15PM -0500, Michael S. Tsirkin wrote:
> > Jean-Philippe Brucker (5):
> >       iommu/virtio: Add definitions for VIRTIO_IOMMU_F_BYPASS_CONFIG
> >       iommu/virtio: Support bypass domains
> >       iommu/virtio: Sort reserved regions
> >       iommu/virtio: Pass end address to viommu_add_mapping()
> >       iommu/virtio: Support identity-mapped domains
> 
> Please could you drop these patches, they are from an old version of the
> series. The newer version was already in Joerg's pull request and was
> merged, so this will conflict.
> 
> Thanks,
> Jean

I just sent v2 without your changes, thanks.

-- 
MST

