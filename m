Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF3310543A
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 15:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKUORg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 09:17:36 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:40104 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKUORf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 09:17:35 -0500
Received: by mail-qv1-f66.google.com with SMTP id i3so1445705qvv.7
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 06:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=agBODkzT+W0qPTCQ+/+UJ/ZKDf5jP2A3l9SEsgbCJ4U=;
        b=gbPlV/lckezHpPzNjYhnz7CIUywInlEGe7Eg9cr+eaDD9Xs3y0zUFu4D/Y/q2+GJ10
         5L6nO0gmHRfkZEnjgn5eNjePTuCJrK79bZSJGEa5DJnn9DDvJbhwYKLNMiRb06gt/0NN
         nCQ4/own9eBbSzTv/xMADW0sELHYMT/eqQ4Y+MbFLWghuN71OgI9sZ5HjPo8IQQd+/l6
         THWDXAf16C5ResAXJEVj+X1WhnwpPWat1j+w5gJc5y6d+mh67YSiuzXMV3wxbxSAXBvk
         0jeHr9XdQgM4fDIGf4FXM/SBKcz9UoCy9CVJGa/AtG8pjqO16zsg7i4Nh/kpRbeAHSr5
         H1HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=agBODkzT+W0qPTCQ+/+UJ/ZKDf5jP2A3l9SEsgbCJ4U=;
        b=D7VkMGVFfXhwM74nTag6pep4paicWOKU/2xek9Ez+ib6j70TAcIzQGNzI8W3cesP5l
         YbW0vwdCWdsOlJdV+e5xUZ6sX4qkMARAXxrYYHGNkUr10kOp+1wWnJNInBdQeeFKlMfl
         Y6lRvAINT/9epPev1bjWZdHDgn7qEJrvZNjXI0pC/3HaKl3aWjjwKJW8WpIT41xzinCT
         Pg5pZddrGpv2n4L0E3iVFe03L3MXMLlgYHvou/aRPMtx8vjPKlVYW5F+3WLjiC3Nze6C
         LkQhDo0xfO/Msz7Th3XkUjtWeC7ncIPmcvDBhglcchqszbem+8KksP4+FrByE23pgZzK
         McBQ==
X-Gm-Message-State: APjAAAUV1q+IyQtcip7WfiEf60qvXIQ718IV9ov6jC2VjD0PbQ03QBih
        ttXEZEwyJW9kK4t2StFsT9ZToQ==
X-Google-Smtp-Source: APXvYqwjQb6dEZhgLoZjBrGg8ljYT2ChD5nb0FrpWAKIrF9K+ftfmlsUeqCfC93VJRlEnKpQ2vNliQ==
X-Received: by 2002:a0c:9838:: with SMTP id c53mr3341955qvd.250.1574345853329;
        Thu, 21 Nov 2019 06:17:33 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id a2sm1390947qkl.71.2019.11.21.06.17.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Nov 2019 06:17:32 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXnH2-0002Yg-7X; Thu, 21 Nov 2019 10:17:32 -0400
Date:   Thu, 21 Nov 2019 10:17:32 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191121141732.GB7448@ziepe.ca>
References: <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca>
 <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
 <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 03:21:29PM +0800, Jason Wang wrote:
> > The role of vfio has traditionally been around secure device
> > assignment of a HW resource to a VM. I'm not totally clear on what the
> > role if mdev is seen to be, but all the mdev drivers in the tree seem
> > to make 'and pass it to KVM' a big part of their description.
> > 
> > So, looking at the virtio patches, I see some intended use is to map
> > some BAR pages into the VM.
> 
> Nope, at least not for the current stage. It still depends on the
> virtio-net-pci emulatio in qemu to work. In the future, we will allow such
> mapping only for dorbell.

There has been a lot of emails today, but I think this is the main
point I want to respond to.

Using vfio when you don't even assign any part of the device BAR to
the VM is, frankly, a gigantic misuse, IMHO.

Just needing userspace DMA is not, in any way, a justification to use
vfio.

We have extensive library interfaces in the kernel to do userspace DMA
and subsystems like GPU and RDMA are full of example uses of this kind
of stuff. Everything from on-device IOMMU to system IOMMU to PASID. If
you find things missing then we need to improve those library
interfaces, not further abuse VFIO.

Further, I do not think it is wise to design the userspace ABI around
a simplistict implementation that can't do BAR assignment, and can't
support multiple virtio rings on single PCI function. This stuff is
clearly too premature.

My advice is to proceed as a proper subsystem with your own chardev,
own bus type, etc and maybe live in staging for a bit until 2-3
drivers are implementing the ABI (or at the very least agreeing with),
as is the typical process for Linux.

Building a new kernel ABI is hard (this is why I advised to use a
userspace driver). It has to go through the community process at the
usual pace.

Jason
