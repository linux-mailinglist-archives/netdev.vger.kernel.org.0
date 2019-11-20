Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31DCD103144
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfKTBq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 20:46:56 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44504 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfKTBq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 20:46:56 -0500
Received: by mail-qk1-f194.google.com with SMTP id m16so19864094qki.11
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 17:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5+9Fvs2hHnzXGmSYo5rNZCdiEPrUh/cYU0evbRShhoY=;
        b=HCjWIOddtnoHmPWRf4FzneGGvTFt4lt0Qnwga3HxP9l9r/953SslWwymUKuceNII1r
         C8Kxob0b9+5Sjz0axlf4AS/Uc63tSVTvJ1UjuW5tulQheCsX0XvegdE8AR6qW7lZGtju
         s65UneWZvkeVDcahTklL0F8vASvaxvsLqq+zQGNvFkEFhmhaq5iJSeXfPapYw11HTuCE
         3I5OJMBEV/nDeSpfY8MmkQwqsIFet2Jk4Ex8zMkUQY4JQylT737h9l/BJzRfyjtIrG4D
         Ptf+fgNplP2jFar6Zim8tZBH1+jvsIcfukVoMcQwthWb7HMUJQIm63MNRosLysAUHddb
         JYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5+9Fvs2hHnzXGmSYo5rNZCdiEPrUh/cYU0evbRShhoY=;
        b=LYJQ0d+LkTOSM/L9eMiJwqXDq7zHzMZm52yoDOuQ1/lBiDtI26IQQMvtuH4PUMiPWC
         DRCSiL/lwZrrDNZamvCsYOPfjzCkyntDzHH/A4iUbEAhDbsNVyhMzGmzdD6B+T1OS4rt
         b6/+cuLmGI2GYvZuIQH6fkvlZ8+P2ckxWekqvoB9s3sNBf5PAoNH3q7pk6z7GfNA4pVW
         9jTG9lKDNO7pniwFF92UsI2u4e/4K7ui2nxcRDjWOg5DySc4ZFw5OH+NRZ5h0VzkgnX5
         bMm2dO/jyG0EqdxlHwF4TuNiFwPCHcewnXdmc9bhgxqfJY6u99qnnRZaVWqpYA5yxnHO
         RgFA==
X-Gm-Message-State: APjAAAUtqmZBHohse41Wl+tUsDFOLAJ6vGPh1+BhJDW1SrZxFkGOEZau
        U0mSFOUyYcRh2AbkyFfx0V8kvQ==
X-Google-Smtp-Source: APXvYqx8E56BaWuEeGzlaFj2QPwWrGbJ2KjCH4Yd7AqNKfpF9dUI7xm0d+mnVrpQXXqyTrxGBZV10g==
X-Received: by 2002:a37:f605:: with SMTP id y5mr270283qkj.288.1574214415103;
        Tue, 19 Nov 2019 17:46:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id k27sm10562991qkj.30.2019.11.19.17.46.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 17:46:54 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXF53-0003Yu-SS; Tue, 19 Nov 2019 21:46:53 -0400
Date:   Tue, 19 Nov 2019 21:46:53 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191120014653.GR4991@ziepe.ca>
References: <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119191053-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 07:16:21PM -0500, Michael S. Tsirkin wrote:
> On Tue, Nov 19, 2019 at 07:10:23PM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 19, 2019 at 04:33:40PM -0500, Michael S. Tsirkin wrote:
> > > On Tue, Nov 19, 2019 at 03:15:47PM -0400, Jason Gunthorpe wrote:
> > > > On Tue, Nov 19, 2019 at 01:58:42PM -0500, Michael S. Tsirkin wrote:
> > > > > On Tue, Nov 19, 2019 at 12:46:32PM -0400, Jason Gunthorpe wrote:
> > > > > > As always, this is all very hard to tell without actually seeing real
> > > > > > accelerated drivers implement this. 
> > > > > > 
> > > > > > Your patch series might be a bit premature in this regard.
> > > > > 
> > > > > Actually drivers implementing this have been posted, haven't they?
> > > > > See e.g. https://lwn.net/Articles/804379/
> > > > 
> > > > Is that a real driver? It looks like another example quality
> > > > thing. 
> > > > 
> > > > For instance why do we need any of this if it has '#define
> > > > IFCVF_MDEV_LIMIT 1' ?
> > > > 
> > > > Surely for this HW just use vfio over the entire PCI function and be
> > > > done with it?
> > > 
> > > What this does is allow using it with unmodified virtio drivers
> > > within guests.  You won't get this with passthrough as it only
> > > implements parts of virtio in hardware.
> > 
> > I don't mean use vfio to perform passthrough, I mean to use vfio to
> > implement the software parts in userspace while vfio to talk to the
> > hardware.
> 
> You repeated vfio twice here, hard to decode what you meant actually.

'while using vifo to talk to the hardware'

> >   kernel -> vfio -> user space virtio driver -> qemu -> guest
>
> Exactly what has been implemented for control path.

I do not mean the modified mediated vfio this series proposes, I mean
vfio-pci, on a full PCI VF, exactly like we have today.

> The interface between vfio and userspace is
> based on virtio which is IMHO much better than
> a vendor specific one. userspace stays vendor agnostic.

Why is that even a good thing? It is much easier to provide drivers
via qemu/etc in user space then it is to make kernel upgrades. We've
learned this lesson many times.

This is why we have had the philosophy that if it doesn't need to be
in the kernel it should be in userspace.

> > Generally we don't want to see things in the kernel that can be done
> > in userspace, and to me, at least for this driver, this looks
> > completely solvable in userspace.
> 
> I don't think that extends as far as actively encouraging userspace
> drivers poking at hardware in a vendor specific way.  

Yes, it does, if you can implement your user space requirements using
vfio then why do you need a kernel driver?

The kernel needs to be involved when there are things only the kernel
can do. If IFC has such things they should be spelled out to justify
using a mediated device.

> That has lots of security and portability implications and isn't
> appropriate for everyone. 

This is already using vfio. It doesn't make sense to claim that using
vfio properly is somehow less secure or less portable.

What I find particularly ugly is that this 'IFC VF NIC' driver
pretends to be a mediated vfio device, but actually bypasses all the
mediated device ops for managing dma security and just directly plugs
the system IOMMU for the underlying PCI device into vfio.

I suppose this little hack is what is motivating this abuse of vfio in
the first place?

Frankly I think a kernel driver touching a PCI function for which vfio
is now controlling the system iommu for is a violation of the security
model, and I'm very surprised AlexW didn't NAK this idea.

Perhaps it is because none of the patches actually describe how the
DMA security model for this so-called mediated device works? :(

Or perhaps it is because this submission is split up so much it is
hard to see what is being proposed? (I note this IFC driver is the
first user of the mdev_set_iommu_device() function)

> It is kernel's job to abstract hardware away and present a unified
> interface as far as possible.

Sure, you could create a virtio accelerator driver framework in our
new drivers/accel I hear was started. That could make some sense, if
we had HW that actually required/benefited from kernel involvement.

Jason
