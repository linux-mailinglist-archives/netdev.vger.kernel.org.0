Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A86148F33F
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 00:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiANXuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 18:50:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229891AbiANXuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 18:50:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642204218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wQKAQp3punPuo3jodbvvWKcFENKeN8QBsPxGUfPzlv8=;
        b=D/jW+5ljzLLD4BBWt1d9r3Mz8OP1cjx0I62Ox4vp1axorkzI3lL4F60xdvMbxgJAd57R5L
        UzTwPa1d6Ht3tShx+tWEQ8KkfZFk75PLdr/E9eVCoqOElcGgNnmFcLIdVqZlxSnI1F2SwC
        Wj9Gz8mt3pvQjUYobz9IoxK8yJuSiv4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-qtu2bYDQMVWhMNn9Vip5zA-1; Fri, 14 Jan 2022 18:50:17 -0500
X-MC-Unique: qtu2bYDQMVWhMNn9Vip5zA-1
Received: by mail-wm1-f69.google.com with SMTP id c5-20020a1c3505000000b00345c92c27c6so8932967wma.2
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 15:50:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wQKAQp3punPuo3jodbvvWKcFENKeN8QBsPxGUfPzlv8=;
        b=WA61UtfgGelLLvzTc1V8UuUPxqbSbuL6k6hZ9xrEarMHUI2p1fYWRiX7p4NnWZTYXV
         Qa64cdp+CK9CdfNHBtGDw2eX7lcjkPjvlP6KFwuyo32vDBVjmMsbQdw6JzH3sMKXZIz/
         A/u5WugIYOvBG3O3JPA+5TCld5aVG81x8f+sjf2Fh8qg0ehQQI7iY4koZowLejUDJGF7
         BLr1nyiloDfWuYXHlg23Q1zpYZHfeyEDIFCIAt2O2B3CXPhKPaYuR5WSyIVKXiMslS53
         n9M3H2JIto3ngHm3ZQZsIS7tez+MFpP4SLtxnjnrruncfCtDJmN+Ro4dSbm4AuPi5w1+
         EPDQ==
X-Gm-Message-State: AOAM53106czFuoQ2vc2ZL7lfWz317xce4/AZrdauQLKFLnNL6Bhlq7d1
        WWQ6mFD/koKnInondgg+I6sMecrs1jmKBv4AGy1Gz4vXy1dsmdNlVm566hXjWokG517W5Ii8t/0
        ELrGJ/6N04WwB9IZM
X-Received: by 2002:a05:6000:2c8:: with SMTP id o8mr420808wry.366.1642204216483;
        Fri, 14 Jan 2022 15:50:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypJ87tcfmR3bXkhkalO7yqmUU3OIYhufRb3IdZu48YZ8Mj2eS/XA9CKPzuAUCrrnMJrp7WRw==
X-Received: by 2002:a05:6000:2c8:: with SMTP id o8mr420775wry.366.1642204216253;
        Fri, 14 Jan 2022 15:50:16 -0800 (PST)
Received: from redhat.com ([2.55.154.210])
        by smtp.gmail.com with ESMTPSA id r7sm15078419wmq.18.2022.01.14.15.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:50:15 -0800 (PST)
Date:   Fri, 14 Jan 2022 18:50:10 -0500
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
Message-ID: <20220114184916-mutt-send-email-mst@kernel.org>
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

It's weird that this wasn't detected, these have been in linux-next
for a long time now. I'l drop, though it's unfortunate as
hashes will not match with what was tested in linux-next.

-- 
MST

