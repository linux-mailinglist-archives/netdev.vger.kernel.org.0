Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D052C21D3FF
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 12:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgGMKxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 06:53:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49659 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729602AbgGMKxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 06:53:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594637579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K2BTuXqkytux8nGd8zFoddd/yDMYv3cynNJyiItMdOQ=;
        b=DsB6lanIX0tUU4hcuyoGfafSpv8bHpFpRoqbdhfB1mPLtttMdOI8+bbfBuavT24Px04loC
        LvVhboE69cBjs9RuX5LdgRNS2e5NIQc27uAP545DStm8cq/mHXO2LMqBqQs+DO8RpSe0TU
        A/iXVgT5kyKxF7mpGo5RrU3ACSusbnY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-huIp73UKMyyj4CgnAVfEQw-1; Mon, 13 Jul 2020 06:52:58 -0400
X-MC-Unique: huIp73UKMyyj4CgnAVfEQw-1
Received: by mail-wm1-f70.google.com with SMTP id g138so18232202wme.7
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 03:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=K2BTuXqkytux8nGd8zFoddd/yDMYv3cynNJyiItMdOQ=;
        b=NAiolQSCoNWcrXAC6XK4SKjIER+hlDHq3DEuJiH2TigjhfuKcYzMZVSqUlQrZtmrox
         gCq7MLwd9aflJPEOVwUUVXipSoBaUKf2kKBgIir79A7gsCTe74uqb7/SucosyVGjk0bm
         ZzSTUIm+ljfjLcrQibwEXIqFJ0l8BfX4cs/2/LQo/K0B8l1GLC51xKl8qI0iUL54MNl/
         HhPOVP7VVkM/cUGgBvhJq39fD2SP9uCRhs79x1g8WEL+jbn6FchV3zcJbnsEH7iJx+5O
         8rwPFbaUk8239y/JhqaG96HQCD13jSGGW3hVIu+GZ6mE1LPB4QTd4nZ+i5mdFmmkdi/z
         drcw==
X-Gm-Message-State: AOAM53076MuB+dI9R5FmRa62oyMUFw3HqAdez3Qkww4u7V2ZEx+sBVXv
        wSFOwwqSSieKVUXWzL8NgoRA4sq5r1XuAVxXTeB7OSDhbfu+nciWzpLw+DmwG+0Sa1MwXJyyBRS
        Kc3MuNmmXX3B/oAap
X-Received: by 2002:a5d:4591:: with SMTP id p17mr79419833wrq.343.1594637577040;
        Mon, 13 Jul 2020 03:52:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVrPQrZLdPMoFP6Y7+3Bf29Fby18L0+X5fsE636sDnhwo/yCifhnwCRzf6ZJqCB//RlrCvBA==
X-Received: by 2002:a5d:4591:: with SMTP id p17mr79419819wrq.343.1594637576842;
        Mon, 13 Jul 2020 03:52:56 -0700 (PDT)
Received: from redhat.com (bzq-79-180-10-140.red.bezeqint.net. [79.180.10.140])
        by smtp.gmail.com with ESMTPSA id i6sm11748360wrp.92.2020.07.13.03.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 03:52:56 -0700 (PDT)
Date:   Mon, 13 Jul 2020 06:52:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, dan.daly@intel.com
Subject: Re: [PATCH 2/7] kvm/vfio: detect assigned device via irqbypass
 manager
Message-ID: <20200713065222-mutt-send-email-mst@kernel.org>
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-2-git-send-email-lingshan.zhu@intel.com>
 <20200712170518-mutt-send-email-mst@kernel.org>
 <bcb03e95-d8b9-6e19-5b0e-0119d3f43d6d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bcb03e95-d8b9-6e19-5b0e-0119d3f43d6d@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 04:13:35PM +0800, Jason Wang wrote:
> 
> On 2020/7/13 上午5:06, Michael S. Tsirkin wrote:
> > On Sun, Jul 12, 2020 at 10:49:21PM +0800, Zhu Lingshan wrote:
> > > We used to detect assigned device via VFIO manipulated device
> > > conters. This is less flexible consider VFIO is not the only
> > > interface for assigned device. vDPA devices has dedicated
> > > backed hardware as well. So this patch tries to detect
> > > the assigned device via irqbypass manager.
> > > 
> > > We will increase/decrease the assigned device counter in kvm/x86.
> > > Both vDPA and VFIO would go through this code path.
> > > 
> > > This code path only affect x86 for now.
> > > 
> > > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > 
> > I think it's best to leave VFIO alone. Add appropriate APIs for VDPA,
> > worry about converting existing users later.
> 
> 
> 
> Just to make sure I understand, did you mean:
> 
> 1) introduce another bridge for vDPA
> 
> or
> 
> 2) only detect vDPA via bypass manager? (we can leave VFIO code as is, then
> the assigned device counter may increase/decrease twice if VFIO use irq
> bypass manager which should be no harm).
> 
> Thanks

2 is probably easier to justify. 1 would depend on the specific bridge
proposed.

> 
> > 
> > > ---
> > >   arch/x86/kvm/x86.c | 10 ++++++++--
> > >   virt/kvm/vfio.c    |  2 --
> > >   2 files changed, 8 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 00c88c2..20c07d3 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -10624,11 +10624,17 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
> > >   {
> > >   	struct kvm_kernel_irqfd *irqfd =
> > >   		container_of(cons, struct kvm_kernel_irqfd, consumer);
> > > +	int ret;
> > >   	irqfd->producer = prod;
> > > +	kvm_arch_start_assignment(irqfd->kvm);
> > > +	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm,
> > > +					 prod->irq, irqfd->gsi, 1);
> > > +
> > > +	if (ret)
> > > +		kvm_arch_end_assignment(irqfd->kvm);
> > > -	return kvm_x86_ops.update_pi_irte(irqfd->kvm,
> > > -					   prod->irq, irqfd->gsi, 1);
> > > +	return ret;
> > >   }
> > >   void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
> > > diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> > > index 8fcbc50..111da52 100644
> > > --- a/virt/kvm/vfio.c
> > > +++ b/virt/kvm/vfio.c
> > > @@ -226,7 +226,6 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
> > >   		list_add_tail(&kvg->node, &kv->group_list);
> > >   		kvg->vfio_group = vfio_group;
> > > -		kvm_arch_start_assignment(dev->kvm);
> > >   		mutex_unlock(&kv->lock);
> > > @@ -254,7 +253,6 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
> > >   				continue;
> > >   			list_del(&kvg->node);
> > > -			kvm_arch_end_assignment(dev->kvm);
> > >   #ifdef CONFIG_SPAPR_TCE_IOMMU
> > >   			kvm_spapr_tce_release_vfio_group(dev->kvm,
> > >   							 kvg->vfio_group);
> > > -- 
> > > 1.8.3.1

