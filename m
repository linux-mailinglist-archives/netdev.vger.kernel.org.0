Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B542A608B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgKDJdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:33:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726029AbgKDJdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:33:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604482423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S67mblvp8BDDbDS1GLfHleJupRJCu9AfMSH9PH8i7Jg=;
        b=Gybab4cNh+GmsIr7HARA67O3RgU5pgb4coY7m5TxZbFL154G8Vz1ZPx8WI1nGQz4pbTMim
        jXNgR0wNR8S7GoVZ9o+fley2r1I0Lf57CkIabc3gLr3ZUDr0kZyz0t6n5E79FBLu87hTHK
        yPiB1FzbtASO4TT83FzFlT1uXbHNjq8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-7ctqhpK_NC-8UakEa7jFYQ-1; Wed, 04 Nov 2020 04:33:42 -0500
X-MC-Unique: 7ctqhpK_NC-8UakEa7jFYQ-1
Received: by mail-wm1-f72.google.com with SMTP id y26so439824wmj.7
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 01:33:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=S67mblvp8BDDbDS1GLfHleJupRJCu9AfMSH9PH8i7Jg=;
        b=mL6g2VmO9s+jD3IYt9rk++gUgF4MzVprKahRDEJAzacXavkmgktB3OhV7MxUGIQ957
         MwB/OqL2YobX4GOpjPe4f23LAV3QSvBTnpZpX4mYuzxNAbJD6qTkeAfDvc98N4Lm68mU
         tqPYTDKiA+bwR8qytX9knjYwI3nI0a4Dks5S5ZZgky2JtuE5P7bVcMeNJNft/1Nns17o
         TKkkCz2xUcFhv2Q6dgJth9Ou2z0+tb4UV9SIqtf4su5OGCvD8GW8FP2MA3N897jj8gWX
         wSQAm4/jrdYNcuUS1oPC+Zn9uzq6NX670HPbBIM6rVCwZHCTjF3Grf6U2sj29/odi866
         hx6w==
X-Gm-Message-State: AOAM533OdAGBL7quH5cxXoYDSASJFU2JtoFlchB4ACjMgqkv3qgU9k1m
        f8H62FvcpJTP2yQ9yaGJzI64WjB0hjRasxObK5MFLGl3Q/nwdbVOOU+qSOUv86wuURIr070ZLO9
        OfFT/nrs8RIMvK7Rx
X-Received: by 2002:adf:9b95:: with SMTP id d21mr5997458wrc.335.1604482420757;
        Wed, 04 Nov 2020 01:33:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLnqhRSqhTc7S9kSWg6N6gWOKIWH0uIfnUrQUkHUqik23WMt5c8lft5ls5BYqlcfZ+saqWZQ==
X-Received: by 2002:adf:9b95:: with SMTP id d21mr5997433wrc.335.1604482420530;
        Wed, 04 Nov 2020 01:33:40 -0800 (PST)
Received: from steredhat (host-79-22-200-33.retail.telecomitalia.it. [79.22.200.33])
        by smtp.gmail.com with ESMTPSA id q2sm1690836wrw.40.2020.11.04.01.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:33:39 -0800 (PST)
Date:   Wed, 4 Nov 2020 10:33:37 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: add IOTLB API support
Message-ID: <20201104093337.ge3qtlfhkjjkx4ax@steredhat>
References: <20201029174351.134173-1-sgarzare@redhat.com>
 <751cc074-ae68-72c8-71de-a42458058761@redhat.com>
 <20201030105422.ju2aj2bmwsckdufh@steredhat>
 <278f4732-e561-2b4f-03ee-b26455760b01@redhat.com>
 <20201102171104.eiovmkj23fle5ioj@steredhat>
 <8648a2e3-1052-3b5b-11ce-87628ac8dd33@redhat.com>
 <20201103194613.GK20600@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201103194613.GK20600@xz-x1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 02:46:13PM -0500, Peter Xu wrote:
>On Tue, Nov 03, 2020 at 05:04:23PM +0800, Jason Wang wrote:
>>
>> On 2020/11/3 上午1:11, Stefano Garzarella wrote:
>> > On Fri, Oct 30, 2020 at 07:44:43PM +0800, Jason Wang wrote:
>> > >
>> > > On 2020/10/30 下午6:54, Stefano Garzarella wrote:
>> > > > On Fri, Oct 30, 2020 at 06:02:18PM +0800, Jason Wang wrote:
>> > > > >
>> > > > > On 2020/10/30 上午1:43, Stefano Garzarella wrote:
>> > > > > > This patch enables the IOTLB API support for vhost-vsock devices,
>> > > > > > allowing the userspace to emulate an IOMMU for the guest.
>> > > > > >
>> > > > > > These changes were made following vhost-net, in details this patch:
>> > > > > > - exposes VIRTIO_F_ACCESS_PLATFORM feature and inits the iotlb
>> > > > > >   device if the feature is acked
>> > > > > > - implements VHOST_GET_BACKEND_FEATURES and
>> > > > > >   VHOST_SET_BACKEND_FEATURES ioctls
>> > > > > > - calls vq_meta_prefetch() before vq processing to prefetch vq
>> > > > > >   metadata address in IOTLB
>> > > > > > - provides .read_iter, .write_iter, and .poll callbacks for the
>> > > > > >   chardev; they are used by the userspace to exchange IOTLB messages
>> > > > > >
>> > > > > > This patch was tested with QEMU and a patch applied [1] to fix a
>> > > > > > simple issue:
>> > > > > >     $ qemu -M q35,accel=kvm,kernel-irqchip=split \
>> > > > > >            -drive file=fedora.qcow2,format=qcow2,if=virtio \
>> > > > > >            -device intel-iommu,intremap=on \
>> > > > > >            -device vhost-vsock-pci,guest-cid=3,iommu_platform=on
>> > > > >
>> > > > >
>> > > > > Patch looks good, but a question:
>> > > > >
>> > > > > It looks to me you don't enable ATS which means vhost won't
>> > > > > get any invalidation request or did I miss anything?
>> > > > >
>> > > >
>> > > > You're right, I didn't see invalidation requests, only miss and
>> > > > updates.
>> > > > Now I have tried to enable 'ats' and 'device-iotlb' but I still
>> > > > don't see any invalidation.
>> > > >
>> > > > How can I test it? (Sorry but I don't have much experience yet
>> > > > with vIOMMU)
>> > >
>> > >
>> > > I guess it's because the batched unmap. Maybe you can try to use
>> > > "intel_iommu=strict" in guest kernel command line to see if it
>> > > works.
>> > >
>> > > Btw, make sure the qemu contains the patch [1]. Otherwise ATS won't
>> > > be enabled for recent Linux Kernel in the guest.
>> >
>> > The problem was my kernel, it was built with a tiny configuration.
>> > Using fedora stock kernel I can see the 'invalidate' requests, but I
>> > also had the following issues.
>> >
>> > Do they make you ring any bells?
>> >
>> > $ ./qemu -m 4G -smp 4 -M q35,accel=kvm,kernel-irqchip=split \
>> >     -drive file=fedora.qcow2,format=qcow2,if=virtio \
>> >     -device intel-iommu,intremap=on,device-iotlb=on \
>> >     -device vhost-vsock-pci,guest-cid=6,iommu_platform=on,ats=on,id=v1
>> >
>> >     qemu-system-x86_64: vtd_iova_to_slpte: detected IOVA overflow    
>> > (iova=0x1d40000030c0)
>>
>>
>> It's a hint that IOVA exceeds the AW. It might be worth to check whether the
>> missed IOVA reported from IOTLB is legal.
>
>Yeah.  By default the QEMU vIOMMU should only support 39bits width for guest
>iova address space.  To extend it, we can use:
>
>  -device intel-iommu,aw-bits=48
>
>So we'll enable 4-level iommu pgtable.
>
>Here the iova is obvious longer than this, so it'll be interesting to know why
>that iova is allocated in the guest driver since the driver should know somehow
>that this iova is beyond what's supported (guest iommu driver should be able to
>probe viommu capability on this width information too).
>

Peter, Jason, thanks for the hints!

I'll try to understand what is going on in the guest driver.

Stefano

