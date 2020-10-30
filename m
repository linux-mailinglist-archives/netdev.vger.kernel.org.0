Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9EA2A0AFA
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgJ3QUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:20:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726072AbgJ3QUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604074785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OcrYeen7idQg6fj59+qOuiD8Ij+RF++6T9svNJR2I70=;
        b=WFoIKu8bEgawaKpofPfpt75m424pwi8tumYuYah7rS1nkdbDkWlkA8KddGEXr/QQ5Xedum
        n+Ex1/aV7OWMViQvkjss2ByTB13kk49aMObzWY40/3jrF+ZMaBYqbOyrdoyOHbeihTvync
        cYJpC8APtle7r2TmC3DvVR2BlBlUOa8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-kG-yPjtzP2KvpR64R4xY8g-1; Fri, 30 Oct 2020 12:19:43 -0400
X-MC-Unique: kG-yPjtzP2KvpR64R4xY8g-1
Received: by mail-wm1-f70.google.com with SMTP id p7so782653wma.9
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:19:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OcrYeen7idQg6fj59+qOuiD8Ij+RF++6T9svNJR2I70=;
        b=cYVpftVt5tsHKK03kTntBnErLNwUyZnsLFkWs3XalWLRuzFAqSlwv34LFGY3iWoKtL
         aLPwjvuJL3TiDLJP7sKK2z+84MhJnVy/BqXE0n/pcaXJBsJO6yP+wwMBGCPXgTA1ZI5p
         XImSgW4MGtfNEJ90Tmn+BqP3jtBcwxsxT25e/ZnePCVzC5cOhrqzX8N86D41NgwM0n76
         pq4D9HiZ7mR1XPt0SmMyuIk3S8aPctCQbpKAiSttlJ2jC/RW+pBpnpM1xpX4IA8UVMDK
         Mgtj1t5Z5kc9uqPQcEs0qWCM1yOEnqH4dLG4E5019H5arhgAq2CwmxX22ohdeojRRPt6
         Jm9w==
X-Gm-Message-State: AOAM533DscIexab8HcbmyOdLbpZ+NXD0m3LTOL2CRycUNsv7y3tzPsfj
        9gXz9H+8PJDpYhM/kUvfqpdmfkafmOxw50a31by641cxopQpSySpvPQyfnfiGDm3Bo+2Nh0TrNk
        YOBqvO9i0J3P+qLxS
X-Received: by 2002:a5d:420d:: with SMTP id n13mr4159699wrq.196.1604074781982;
        Fri, 30 Oct 2020 09:19:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+DKWtX/KpuvIKWLXpz4cbRsYAjyJQ2MhSo5RnPibttiUk+A4yTfvDUDF0AaH/EFGWlo/yNg==
X-Received: by 2002:a5d:420d:: with SMTP id n13mr4159679wrq.196.1604074781780;
        Fri, 30 Oct 2020 09:19:41 -0700 (PDT)
Received: from steredhat (host-79-22-200-33.retail.telecomitalia.it. [79.22.200.33])
        by smtp.gmail.com with ESMTPSA id o4sm11021368wrv.8.2020.10.30.09.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 09:19:41 -0700 (PDT)
Date:   Fri, 30 Oct 2020 17:19:38 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: add IOTLB API support
Message-ID: <20201030161938.n7xqeu557dmsqpzv@steredhat>
References: <20201029174351.134173-1-sgarzare@redhat.com>
 <751cc074-ae68-72c8-71de-a42458058761@redhat.com>
 <20201030105422.ju2aj2bmwsckdufh@steredhat>
 <278f4732-e561-2b4f-03ee-b26455760b01@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <278f4732-e561-2b4f-03ee-b26455760b01@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 07:44:43PM +0800, Jason Wang wrote:
>
>On 2020/10/30 下午6:54, Stefano Garzarella wrote:
>>On Fri, Oct 30, 2020 at 06:02:18PM +0800, Jason Wang wrote:
>>>
>>>On 2020/10/30 上午1:43, Stefano Garzarella wrote:
>>>>This patch enables the IOTLB API support for vhost-vsock devices,
>>>>allowing the userspace to emulate an IOMMU for the guest.
>>>>
>>>>These changes were made following vhost-net, in details this patch:
>>>>- exposes VIRTIO_F_ACCESS_PLATFORM feature and inits the iotlb
>>>>  device if the feature is acked
>>>>- implements VHOST_GET_BACKEND_FEATURES and
>>>>  VHOST_SET_BACKEND_FEATURES ioctls
>>>>- calls vq_meta_prefetch() before vq processing to prefetch vq
>>>>  metadata address in IOTLB
>>>>- provides .read_iter, .write_iter, and .poll callbacks for the
>>>>  chardev; they are used by the userspace to exchange IOTLB messages
>>>>
>>>>This patch was tested with QEMU and a patch applied [1] to fix a
>>>>simple issue:
>>>>    $ qemu -M q35,accel=kvm,kernel-irqchip=split \
>>>>           -drive file=fedora.qcow2,format=qcow2,if=virtio \
>>>>           -device intel-iommu,intremap=on \
>>>>           -device vhost-vsock-pci,guest-cid=3,iommu_platform=on
>>>
>>>
>>>Patch looks good, but a question:
>>>
>>>It looks to me you don't enable ATS which means vhost won't get 
>>>any invalidation request or did I miss anything?
>>>
>>
>>You're right, I didn't see invalidation requests, only miss and updates.
>>Now I have tried to enable 'ats' and 'device-iotlb' but I still 
>>don't see any invalidation.
>>
>>How can I test it? (Sorry but I don't have much experience yet with 
>>vIOMMU)
>
>
>I guess it's because the batched unmap. Maybe you can try to use 
>"intel_iommu=strict" in guest kernel command line to see if it works.
>
>Btw, make sure the qemu contains the patch [1]. Otherwise ATS won't be 
>enabled for recent Linux Kernel in the guest.
>

I tried with "intel_iommu=strict" in the guest kernel and QEMU patch 
applied, but I didn't see any invalidation.

Maybe I did something wrong, you know it is friday, KVM Forum is ending, 
etc... ;-)

I'll investigate better next week.

Thanks for the useful info,
Stefano

