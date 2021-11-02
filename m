Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D8E443314
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 17:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhKBQkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 12:40:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235064AbhKBQjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 12:39:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635870988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=39wLrKe9Oq3pcEjpduAiQZ3+L5GazI7AIIHG7sUcGnc=;
        b=cmiudYz5qeRgQhHuAf+fRvlI7ND5IZai72qhWEdOQuhtC5w7QLl2udF1sXSW0ddzQCuGm8
        BZssG6zCx9+02W3fyX6SQs53HUf6Q4GnNiDoubALpbZ4ezMJtHL45uHg49u6azpVkEQ2ps
        YdFawhqUaSEd4E1Fb5Nuk+6H0rV14TI=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-rsIkHYplOb20iyGim6O0-w-1; Tue, 02 Nov 2021 12:22:40 -0400
X-MC-Unique: rsIkHYplOb20iyGim6O0-w-1
Received: by mail-ot1-f70.google.com with SMTP id l35-20020a0568302b2300b00559a5376a9bso3880568otv.6
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 09:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39wLrKe9Oq3pcEjpduAiQZ3+L5GazI7AIIHG7sUcGnc=;
        b=bwGROa5pBW74AD39ZQPOS6XHdY9FnQ53nnPp+fegKA7B50CUJ3IkMB9X52XKv5FkJX
         eBzYWRwhjzRmxjp2MyMsHwbAGSyFWMR48rtYtF3faUwOBEisVfCnmUD8+4rSYQ+JTr5q
         r/etAqlbLtwM/cIQJHxVzYfi3KAGYPyut+PI41ztzdOYRNJO6Wd+OXusCY+ruypz5JV+
         q5s3omoEK8yHVRimdckMZrK5XMspdNWOqt3oBJa3qtQR6JHG2AGpNu1JB/gebKH680na
         Y0p40a5OtYwrUDvLoO27ywfcgXcw2Uh/Y9AFS24xQFfR/4AuAlhTQ5pFM6RhNekqJmO8
         d0kw==
X-Gm-Message-State: AOAM533ExiSPj+RABDhNrw7m8QnZz+iWIviVmPzg0sa40usYiMO5BPXE
        MIvC6T+4DrTt5SukDXuIyLKzlDV+UvgLxJPZbDDNw5JYaTUE0m4SPJHPu2RnA9lcTQgZWPB55H9
        moC2j3Bv8Cbk0IET5
X-Received: by 2002:a05:6830:238f:: with SMTP id l15mr28169211ots.83.1635870159519;
        Tue, 02 Nov 2021 09:22:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ5tVmFV1vGaAn4hO9rkE+/oPBx9f1jgKrda4qDaWnPkCtc66YQYOzrhBmWlYb1oXdsaZPLA==
X-Received: by 2002:a05:6830:238f:: with SMTP id l15mr28169188ots.83.1635870159301;
        Tue, 02 Nov 2021 09:22:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f23sm2034401oou.21.2021.11.02.09.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 09:22:38 -0700 (PDT)
Date:   Tue, 2 Nov 2021 10:22:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211102102236.711dc6b5.alex.williamson@redhat.com>
In-Reply-To: <20211102155420.GK2744544@nvidia.com>
References: <20211026151851.GW2744544@nvidia.com>
        <20211026135046.5190e103.alex.williamson@redhat.com>
        <20211026234300.GA2744544@nvidia.com>
        <20211027130520.33652a49.alex.williamson@redhat.com>
        <20211027192345.GJ2744544@nvidia.com>
        <20211028093035.17ecbc5d.alex.williamson@redhat.com>
        <20211028234750.GP2744544@nvidia.com>
        <20211029160621.46ca7b54.alex.williamson@redhat.com>
        <20211101172506.GC2744544@nvidia.com>
        <20211102085651.28e0203c.alex.williamson@redhat.com>
        <20211102155420.GK2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 12:54:20 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Nov 02, 2021 at 08:56:51AM -0600, Alex Williamson wrote:
> 
> > > Still, this is something that needs clear definition, I would expect
> > > the SET_IRQS to happen after resuming clears but before running sets
> > > to give maximum HW flexibility and symmetry with saving.  
> > 
> > There's no requirement that the device enters a null state (!_RESUMING
> > | !_SAVING | !_RUNNING), the uAPI even species the flows as _RESUMING
> > transitioning to _RUNNING.    
> 
> If the device saves the MSI-X state inside it's migration data (as
> apparently would be convenient for other OSs) then when RESUMING
> clears and the migration data is de-serialized the device will
> overwrite the MSI-X data.
> 
> Since Linux as an OS wants to control the MSI-X it needs to load it
> after RESUMING, but before RUNNING.

This is not how it works today, QEMU enables MSI/X based on the config
space information, which is also outside of the device migration stream.

> > There's no point at which we can do SET_IRQS other than in the
> > _RESUMING state.  Generally SET_IRQS ioctls are coordinated with the
> > guest driver based on actions to the device, we can't be mucking
> > with IRQs while the device is presumed running and already
> > generating interrupt conditions.  
> 
> We need to do it in state 000
> 
> ie resume should go 
> 
>   000 -> 100 -> 000 -> 001
> 
> With SET_IRQS and any other fixing done during the 2nd 000, after the
> migration data has been loaded into the device.

Again, this is not how QEMU works today.

> > > And we should really define clearly what a device is supposed to do
> > > with the interrupt vectors during migration. Obviously there are races
> > > here.  
> > 
> > The device should not be generating interrupts while !_RUNNING, pending
> > interrupts should be held until the device is _RUNNING.  To me this
> > means the sequence must be that INTx/MSI/MSI-X are restored while in
> > the !_RUNNING state.  
> 
> Yes

Except I suppose them to be restored while _RESUMING is set.

> > > > In any case, it requires that the device cannot be absolutely static
> > > > while !_RUNNING.  Does (_RESUMING) have different rules than
> > > > (_SAVING)?    
> > > 
> > > I'd prever to avoid all device touches during both resuming and
> > > saving, and do them during !RUNNING  
> > 
> > There's no such state required by the uAPI.  
> 
> The uAPI comment does not define when to do the SET_IRQS, it seems
> this has been missed.
> 
> We really should fix it, unless you feel strongly that the
> experimental API in qemu shouldn't be changed.

I think the QEMU implementation fills in some details of how the uAPI
is expected to work.  MSI/X is expected to be restored while _RESUMING
based on the config space of the device, there is no intermediate step
between _RESUMING and _RUNNING.  Introducing such a requirement
precludes the option of a post-copy implementation of (_RESUMING |
_RUNNING).  Thanks,

Alex

