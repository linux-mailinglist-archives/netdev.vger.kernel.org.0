Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B642A5053
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgKCTqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:46:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727883AbgKCTqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:46:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604432778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hXGHvDYwh9NMkyXNB/mXiydEr8BiB4sd5uCcFnHHQZg=;
        b=chwpTUtqHwO02E0vi3/Q7iXNI88a/J1qSQNV/ZpXJ8DOipuh0xSFZjIo4qlN9FlCW1PLof
        P9mmx6hwaluMP2xkOYijiBlxSyka+bF+ZDW60DaeVcnBWPyeOCMlbg1ZjdPcII361h0IW2
        EyJRna6Q14KM5jGfCYZJuhUGVamgCQ8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-WZqrQo4gPaKcOHIoefnHOA-1; Tue, 03 Nov 2020 14:46:17 -0500
X-MC-Unique: WZqrQo4gPaKcOHIoefnHOA-1
Received: by mail-qk1-f197.google.com with SMTP id v134so11505595qka.19
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 11:46:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hXGHvDYwh9NMkyXNB/mXiydEr8BiB4sd5uCcFnHHQZg=;
        b=JUZ100t+NFvH+BQgdaAUIsfhpzG7R5xALcvtvRqzQzJSOVxYb620b6xmjaRTgQ6FJQ
         1fduhESAyLoIj+gaWEsMRcMSsxIqv9YlaIyq7ATjRdBx6sVfsNhI+EFeJruDat+Yxnfo
         gO2Hbi4saRFmMdbIl3Qu4s25jGw1kTWbyZun1qIfRVdXfZ+DMu83TGI8SeeIJB4jEsa2
         vgKB1lAfpaszrTF1fuc4moCmb22uNCPIiuB75Yp3GIW0eLtqCQTF7Mppceto2Ut68EM7
         FzTp+jrHNgLvWdgVeBWXLlaxq/8kELttr+iLpyp9U3flVzDcwOXyFle+w3B9diNQhbV6
         tt+w==
X-Gm-Message-State: AOAM531BcqzGYgrCTi2N+sZ4YduKsjWx1GPR6B95UDwpVog9Y8rNzSko
        UUYkzh1E64smENJVHQfFWAD759/o02Uvem89TKn0LVobTEXQUH6xZvMuuZF3wFOEHX3dtEpbM2G
        hfH4lhklajGp7kHxL
X-Received: by 2002:ae9:f402:: with SMTP id y2mr20621899qkl.459.1604432776431;
        Tue, 03 Nov 2020 11:46:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHrx/4K1ur2emSikIwCSW6QoSh0HGIlNgos3cwaHoIzJ12L9uFjx7qLeKQUNbiJ0RTQKVuVA==
X-Received: by 2002:ae9:f402:: with SMTP id y2mr20621874qkl.459.1604432776110;
        Tue, 03 Nov 2020 11:46:16 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id i70sm11572985qke.11.2020.11.03.11.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 11:46:15 -0800 (PST)
Date:   Tue, 3 Nov 2020 14:46:13 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>, mst@redhat.com,
        netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: add IOTLB API support
Message-ID: <20201103194613.GK20600@xz-x1>
References: <20201029174351.134173-1-sgarzare@redhat.com>
 <751cc074-ae68-72c8-71de-a42458058761@redhat.com>
 <20201030105422.ju2aj2bmwsckdufh@steredhat>
 <278f4732-e561-2b4f-03ee-b26455760b01@redhat.com>
 <20201102171104.eiovmkj23fle5ioj@steredhat>
 <8648a2e3-1052-3b5b-11ce-87628ac8dd33@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8648a2e3-1052-3b5b-11ce-87628ac8dd33@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 05:04:23PM +0800, Jason Wang wrote:
> 
> On 2020/11/3 上午1:11, Stefano Garzarella wrote:
> > On Fri, Oct 30, 2020 at 07:44:43PM +0800, Jason Wang wrote:
> > > 
> > > On 2020/10/30 下午6:54, Stefano Garzarella wrote:
> > > > On Fri, Oct 30, 2020 at 06:02:18PM +0800, Jason Wang wrote:
> > > > > 
> > > > > On 2020/10/30 上午1:43, Stefano Garzarella wrote:
> > > > > > This patch enables the IOTLB API support for vhost-vsock devices,
> > > > > > allowing the userspace to emulate an IOMMU for the guest.
> > > > > > 
> > > > > > These changes were made following vhost-net, in details this patch:
> > > > > > - exposes VIRTIO_F_ACCESS_PLATFORM feature and inits the iotlb
> > > > > >   device if the feature is acked
> > > > > > - implements VHOST_GET_BACKEND_FEATURES and
> > > > > >   VHOST_SET_BACKEND_FEATURES ioctls
> > > > > > - calls vq_meta_prefetch() before vq processing to prefetch vq
> > > > > >   metadata address in IOTLB
> > > > > > - provides .read_iter, .write_iter, and .poll callbacks for the
> > > > > >   chardev; they are used by the userspace to exchange IOTLB messages
> > > > > > 
> > > > > > This patch was tested with QEMU and a patch applied [1] to fix a
> > > > > > simple issue:
> > > > > >     $ qemu -M q35,accel=kvm,kernel-irqchip=split \
> > > > > >            -drive file=fedora.qcow2,format=qcow2,if=virtio \
> > > > > >            -device intel-iommu,intremap=on \
> > > > > >            -device vhost-vsock-pci,guest-cid=3,iommu_platform=on
> > > > > 
> > > > > 
> > > > > Patch looks good, but a question:
> > > > > 
> > > > > It looks to me you don't enable ATS which means vhost won't
> > > > > get any invalidation request or did I miss anything?
> > > > > 
> > > > 
> > > > You're right, I didn't see invalidation requests, only miss and
> > > > updates.
> > > > Now I have tried to enable 'ats' and 'device-iotlb' but I still
> > > > don't see any invalidation.
> > > > 
> > > > How can I test it? (Sorry but I don't have much experience yet
> > > > with vIOMMU)
> > > 
> > > 
> > > I guess it's because the batched unmap. Maybe you can try to use
> > > "intel_iommu=strict" in guest kernel command line to see if it
> > > works.
> > > 
> > > Btw, make sure the qemu contains the patch [1]. Otherwise ATS won't
> > > be enabled for recent Linux Kernel in the guest.
> > 
> > The problem was my kernel, it was built with a tiny configuration.
> > Using fedora stock kernel I can see the 'invalidate' requests, but I
> > also had the following issues.
> > 
> > Do they make you ring any bells?
> > 
> > $ ./qemu -m 4G -smp 4 -M q35,accel=kvm,kernel-irqchip=split \
> >     -drive file=fedora.qcow2,format=qcow2,if=virtio \
> >     -device intel-iommu,intremap=on,device-iotlb=on \
> >     -device vhost-vsock-pci,guest-cid=6,iommu_platform=on,ats=on,id=v1
> > 
> >     qemu-system-x86_64: vtd_iova_to_slpte: detected IOVA overflow    
> > (iova=0x1d40000030c0)
> 
> 
> It's a hint that IOVA exceeds the AW. It might be worth to check whether the
> missed IOVA reported from IOTLB is legal.

Yeah.  By default the QEMU vIOMMU should only support 39bits width for guest
iova address space.  To extend it, we can use:

  -device intel-iommu,aw-bits=48

So we'll enable 4-level iommu pgtable.

Here the iova is obvious longer than this, so it'll be interesting to know why
that iova is allocated in the guest driver since the driver should know somehow
that this iova is beyond what's supported (guest iommu driver should be able to
probe viommu capability on this width information too).

-- 
Peter Xu

