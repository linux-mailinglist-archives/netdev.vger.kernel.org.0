Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9116A221C69
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 08:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgGPGNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 02:13:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59715 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725913AbgGPGNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 02:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594879987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1M+pW97CHknoejGWyybKRR4Skij2QdcP792WLZ7CQAc=;
        b=F7bjhcsSOsZuU1Qn1BK7I8yfage2J7weWng/NowNtsB0jxOXTO4W1jELSMxleYmYo1FOYw
        kj0NZphNi6mx1b2/GEOAPYboLJgVzCJNSCZExHQJbrhUxH3RCWkGxujNF7Q2kiQkPsnRAH
        gQM8KQQNtIz53PyGkZRbdiYaca5FvMA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-rNFMMGAxP4eIjqNcnqm7tw-1; Thu, 16 Jul 2020 02:13:05 -0400
X-MC-Unique: rNFMMGAxP4eIjqNcnqm7tw-1
Received: by mail-wr1-f71.google.com with SMTP id g14so4615517wrp.8
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 23:13:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1M+pW97CHknoejGWyybKRR4Skij2QdcP792WLZ7CQAc=;
        b=WeN3as9/hsG9R4A8ZjJIFfj1OylRiX3/jkvN+CSvvZJ4lrRKvViylAE4M5xGil3Ps+
         0dmgA8E4B6wCh6tTyJrnDEY+DjaNR5Z9+S+bsGq63LQOpyhg30esNUh2Op9BA41jFCEy
         bipmHXE0VTKuodj85ttrSGc44e690wNA3tsZ7LwGR1WSLfYL2L8cKKEwq5I3FcmrO7FS
         rAm+amHArRKtRAxunCzsvTKp8CXoXnDiAx+sQw3zPTpXiBBhtrSg1YG2dm70FOo43KS3
         xpQCat2LyL+CGjpK3gH3By2r/N00hzAN9lyLotgBE8cySmJt9JCRa+FyFd8gVYeSLBrp
         rmBg==
X-Gm-Message-State: AOAM530Po37XsU1SxAPGjx4PcuJc/r4Ex6k66xMCacZYq6QQdkLKrAt7
        khP27SXlshXj/36T8LUHVZsVtMndWKHRhOmNFcJRq1S7gNT8knMqUBzYDwzxqJJVD6F+SMa2POl
        B6wL/vZvcLaFM0QZt
X-Received: by 2002:a1c:9a81:: with SMTP id c123mr2755136wme.46.1594879984219;
        Wed, 15 Jul 2020 23:13:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzT8cU5kZjDJ+n5Z01Aw/B3E42nszir+5RtL0b0T6rIbKUWMpod41qWfNHCANmeyj9AKRZROw==
X-Received: by 2002:a1c:9a81:: with SMTP id c123mr2755118wme.46.1594879983933;
        Wed, 15 Jul 2020 23:13:03 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id p29sm7031185wmi.43.2020.07.15.23.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 23:13:03 -0700 (PDT)
Date:   Thu, 16 Jul 2020 02:13:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>, alex.williamson@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, dan.daly@intel.com
Subject: Re: [PATCH 0/7] *** IRQ offloading for vDPA ***
Message-ID: <20200716021111-mutt-send-email-mst@kernel.org>
References: <1594565524-3394-1-git-send-email-lingshan.zhu@intel.com>
 <70244d80-08a4-da91-3226-7bfd2019467e@redhat.com>
 <97032c51-3265-c94a-9ce1-f42fcc6d3075@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97032c51-3265-c94a-9ce1-f42fcc6d3075@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 09:39:17AM +0800, Zhu, Lingshan wrote:
> 
> On 7/15/2020 9:43 PM, Jason Wang wrote:
> 
> 
>     On 2020/7/12 下午10:52, Zhu Lingshan wrote:
> 
>         Hi All,
> 
>         This series intends to implement IRQ offloading for
>         vhost_vdpa.
> 
>         By the feat of irq forwarding facilities like posted
>         interrupt on X86, irq bypass can  help deliver
>         interrupts to vCPU directly.
> 
>         vDPA devices have dedicated hardware backends like VFIO
>         pass-throughed devices. So it would be possible to setup
>         irq offloading(irq bypass) for vDPA devices and gain
>         performance improvements.
> 
>         In my testing, with this feature, we can save 0.1ms
>         in a ping between two VFs on average.
> 
> 
> 
>     Hi Lingshan:
> 
>     During the virtio-networking meeting, Michael spots two possible issues:
> 
>     1) do we need an new uAPI to stop the irq offloading?
>     2) can interrupt lost during the eventfd ctx?
> 
>     For 1) I think we probably not, we can allocate an independent eventfd
>     which does not map to MSIX. So the consumer can't match the producer and we
>     fallback to eventfd based irq.
> 
> Hi Jason,
> 
> I wonder why we need to stop irq offloading, but if we need to do so, maybe a new uAPI would be more intuitive to me,
> but why and who(user? qemu?) shall initialize this process, based on what kinda of basis to make the decision?
> 
>     For 2) it looks to me guest should deal with the irq synchronization when
>     mask or unmask MSIX vectors.
> 
> Agreed!

Well we need to make sure during a switch each interrupt is reported
*somewhere*: either irq or eventfd - and not lost.


> Thanks,
> BR
> Zhu Lingshan
> 
> 
>     What's your thought?
> 
>     Thanks
> 
> 
> 
> 
> 
>         Zhu Lingshan (7):
>            vhost: introduce vhost_call_ctx
>            kvm/vfio: detect assigned device via irqbypass manager
>            vhost_vdpa: implement IRQ offloading functions in vhost_vdpa
>            vDPA: implement IRQ offloading helpers in vDPA core
>            virtio_vdpa: init IRQ offloading function pointers to NULL.
>            ifcvf: replace irq_request/free with helpers in vDPA core.
>            irqbypass: do not start consumer or producer when failed to connect
> 
>           arch/x86/kvm/x86.c              | 10 ++++--
>           drivers/vdpa/ifcvf/ifcvf_main.c | 11 +++---
>           drivers/vdpa/vdpa.c             | 46 +++++++++++++++++++++++++
>           drivers/vhost/Kconfig           |  1 +
>           drivers/vhost/vdpa.c            | 75
>         +++++++++++++++++++++++++++++++++++++++--
>           drivers/vhost/vhost.c           | 22 ++++++++----
>           drivers/vhost/vhost.h           |  9 ++++-
>           drivers/virtio/virtio_vdpa.c    |  2 ++
>           include/linux/vdpa.h            | 11 ++++++
>           virt/kvm/vfio.c                 |  2 --
>           virt/lib/irqbypass.c            | 16 +++++----
>           11 files changed, 181 insertions(+), 24 deletions(-)
> 
> 
> 
> 

