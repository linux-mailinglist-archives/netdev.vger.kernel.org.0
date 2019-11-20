Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5916C103BDE
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfKTNim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:38:42 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41937 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbfKTNij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 08:38:39 -0500
Received: by mail-qt1-f195.google.com with SMTP id o3so28918981qtj.8
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 05:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4OKdlCvG6Irt6gF/stpzu4dcseCj7CKN7JZOIuS0gmw=;
        b=Ij4PPlXdXcSmHBykyE/g17baW/VZ5t9zv5k1dkMqNe9RyvxewwHyKqGJu7g8m73svX
         gcRofvLGYDLbGmszshTl5ntem0C2ZzcnZCql6Wr5D+DpFdtK4Cuw4RdJIbg6130WQpp2
         Mo7zUhUd27mD6JkfHwNvICB9fJH+Jt2zuifwH/ET+Y3I0bfub2UjCGBxWBiPKOKihQy/
         uIPzFFEnC1PjD85sPLDMDdvZoTD+QCVNbHhXjuX7rLflrl4TqgdJhwNzjpL6NLqXh9An
         XUVmtoccFK4D22veEsPeR2A+8lQMoMD7Wk+0MqkrMUeRbNMuHJG13U02fNb4xkpD9IJ0
         4Ulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4OKdlCvG6Irt6gF/stpzu4dcseCj7CKN7JZOIuS0gmw=;
        b=RdIU2uLqwo0P/G3rqTCARjtcvem8mIgTHoVhOnvts0f3IDe+K6bo7SRl+gStPZZQlv
         RAfxuVeSxnfqqjUUlRbqYaoaq5pphkTk4M/FqCcqFnZTBcdmoEMGCFOyG1Ftsa3K6OIg
         4dxwcwXOktlm5GjcxYL78g32Ih/t9lomcTw+pivkLDU3gNRysVQy3W1UW3eXK7H+b8ov
         U2lK2ZpCXCg6RPbDvD9Lx2vh/UcfULG6dQjpC/rBCqEP36+d4EwHIMlqNKRd1mvhr/1k
         NafChZBC1kLc4ZCNNz6qA2EWVc/6UZET/4Cen3vWekLDMGD0iCq/VWadd2cIreiRS1kn
         5DOg==
X-Gm-Message-State: APjAAAVug96JLXK8uG9PXSCnrfaat4kXVGtM4ZHUbE1zGICMTS/VlD+b
        rSe9IRM7omTE7MU7Hpo3eCYGD3mvc6g=
X-Google-Smtp-Source: APXvYqxSArb+hhsFYDWia8+zcqG+UsoY28ldBu49ak+blsj9fn73nHer/XHPgdgMUPwx9ApJTQ50EQ==
X-Received: by 2002:ac8:46cd:: with SMTP id h13mr2597459qto.101.1574257116905;
        Wed, 20 Nov 2019 05:38:36 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id 132sm11725517qki.114.2019.11.20.05.38.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Nov 2019 05:38:36 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXQBn-0006aC-Vu; Wed, 20 Nov 2019 09:38:35 -0400
Date:   Wed, 20 Nov 2019 09:38:35 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191120133835.GC22515@ziepe.ca>
References: <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 10:59:20PM -0500, Jason Wang wrote:

> > > The interface between vfio and userspace is
> > > based on virtio which is IMHO much better than
> > > a vendor specific one. userspace stays vendor agnostic.
> > 
> > Why is that even a good thing? It is much easier to provide drivers
> > via qemu/etc in user space then it is to make kernel upgrades. We've
> > learned this lesson many times.
> 
> For upgrades, since we had a unified interface. It could be done
> through:
> 
> 1) switch the datapath from hardware to software (e.g vhost)
> 2) unload and load the driver
> 3) switch teh datapath back
> 
> Having drivers in user space have other issues, there're a lot of
> customers want to stick to kernel drivers.

So you want to support upgrade of kernel modules, but runtime
upgrading the userspace part is impossible? Seems very strange to me.

> > This is why we have had the philosophy that if it doesn't need to be
> > in the kernel it should be in userspace.
> 
> Let me clarify again. For this framework, it aims to support both
> kernel driver and userspce driver. For this series, it only contains
> the kernel driver part. What it did is to allow kernel virtio driver
> to control vDPA devices. Then we can provide a unified interface for
> all of the VM, containers and bare metal. For this use case, I don't
> see a way to leave the driver in userspace other than injecting
> traffic back through vhost/TAP which is ugly.

Binding to the other kernel virtio drivers is a reasonable
justification, but none of this comes through in the patch cover
letters or patch commit messages.

> > > That has lots of security and portability implications and isn't
> > > appropriate for everyone.
> > 
> > This is already using vfio. It doesn't make sense to claim that using
> > vfio properly is somehow less secure or less portable.
> > 
> > What I find particularly ugly is that this 'IFC VF NIC' driver
> > pretends to be a mediated vfio device, but actually bypasses all the
> > mediated device ops for managing dma security and just directly plugs
> > the system IOMMU for the underlying PCI device into vfio.
> 
> Well, VFIO have multiple types of API. The design is to stick the VFIO
> DMA model like container work for making DMA API work for userspace
> driver.

Well, it doesn't, that model, for security, is predicated on vfio
being the exclusive owner of the device. For instance if the kernel
driver were to perform DMA as well then security would be lost.

> > I suppose this little hack is what is motivating this abuse of vfio in
> > the first place?
> > 
> > Frankly I think a kernel driver touching a PCI function for which vfio
> > is now controlling the system iommu for is a violation of the security
> > model, and I'm very surprised AlexW didn't NAK this idea.
> >
> > Perhaps it is because none of the patches actually describe how the
> > DMA security model for this so-called mediated device works? :(
> >
> > Or perhaps it is because this submission is split up so much it is
> > hard to see what is being proposed? (I note this IFC driver is the
> > first user of the mdev_set_iommu_device() function)
> 
> Are you objecting the mdev_set_iommu_deivce() stuffs here?

I'm questioning if it fits the vfio PCI device security model, yes.

> > > It is kernel's job to abstract hardware away and present a unified
> > > interface as far as possible.
> > 
> > Sure, you could create a virtio accelerator driver framework in our
> > new drivers/accel I hear was started. That could make some sense, if
> > we had HW that actually required/benefited from kernel involvement.
> 
> The framework is not designed specifically for your card. It tries to be
> generic to support every types of virtio hardware devices, it's not
> tied to any bus (e.g PCI) and any vendor. So it's not only a question
> of how to slice a PCIE ethernet device.

That doesn't explain why this isn't some new driver subsystem and
instead treats vfio as a driver multiplexer.

Jason
