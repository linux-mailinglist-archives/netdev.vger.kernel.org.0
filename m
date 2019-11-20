Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76284104308
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 19:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfKTSLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 13:11:11 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40921 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbfKTSLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 13:11:11 -0500
Received: by mail-qt1-f195.google.com with SMTP id o49so516839qta.7
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 10:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vo33mvOdIBVwdbi/zp6EAjbvy6FDvq9aw43Ml6yjZ2A=;
        b=g1C+cXPLqZidOvbA+sNdc6fv4dHqqQoFBLHTRyK1KotsleyXpj8HEK1Gnsx5kmq0sG
         fS+tcSooC4hWKZTWZqUBcnWoh98NYq+0Nl9L0cBdYCG5nImbUQBKrfjefDq/hH3zpF9y
         ALQ3oIbxXOi/0oz10S75GQJMT3AEt7dBXYmBWnvCpSReg+I2ajQWm9e99dNIcK+ZDvBx
         TKFcbTn2BVto4+Axu67NvKPUKm46peO7oIT2CyVWLqMGTTVT4ec81k+JTlx9+UrWqbGq
         zFNusAQ/g6zyE4hUFzRedSI2p4IBpWQTzV1wRI4qKlfBMB2IS+5p7LEVNQL8muRV7bAv
         oEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vo33mvOdIBVwdbi/zp6EAjbvy6FDvq9aw43Ml6yjZ2A=;
        b=lqwp9DjtOHnUX3bU6Yg/Ya2oPw7u/CHWjB2rYbqI/id5sHG+cJj66UiE44pDdlAFNL
         4mgoxpvZruKcvdQYoUGPTex6qndAbBt3Dil+FFuZkLJpL0jQGRZtR6jBpgxePyiNYFmC
         GE2Fm90VbZkzvnBws43Zn/MBUPkKH8bEakOQoJ3bmJh1LwI4FmIS7zpzFdQjL+l8KjCw
         lITHCny71ngShXh2mBShpZ9mMrF1lqRiavmjwwZCe9fy4vtFDxNCi6+7m+Gwe/N54TDC
         agVGZJCBcEtg3oNRepqcq4jU2VH3EKPBRC9RQW4rsUElkrMN+NFT1ElEQ770Eyt2Modj
         Pm8w==
X-Gm-Message-State: APjAAAUHGSLq51Gs7WGU+SrwSBfHUToo8qFCw4wtbyACn5G2RLyzqdCE
        eW3vo8vkYqqYdok7zcgKxl9gQw==
X-Google-Smtp-Source: APXvYqwVzVio3KUjbooubC21c9kEbruFWe7zxNFcJREryi0+l1imlxXI3hyp/LCI8xcYcTCNTFku8Q==
X-Received: by 2002:ac8:31c5:: with SMTP id i5mr4047242qte.33.1574273470036;
        Wed, 20 Nov 2019 10:11:10 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id w5sm11988292qkf.43.2019.11.20.10.11.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Nov 2019 10:11:09 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXURY-000096-KP; Wed, 20 Nov 2019 14:11:08 -0400
Date:   Wed, 20 Nov 2019 14:11:08 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191120181108.GJ22515@ziepe.ca>
References: <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca>
 <20191120102856.7e01e2e2@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120102856.7e01e2e2@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 10:28:56AM -0700, Alex Williamson wrote:
> > > Are you objecting the mdev_set_iommu_deivce() stuffs here?  
> > 
> > I'm questioning if it fits the vfio PCI device security model, yes.
> 
> The mdev IOMMU backing device model is for when an mdev device has
> IOMMU based isolation, either via the PCI requester ID or via requester
> ID + PASID.  For example, an SR-IOV VF may be used by a vendor to
> provide IOMMU based translation and isolation, but the VF may not be
> complete otherwise to provide a self contained device.  It might
> require explicit coordination and interaction with the PF driver, ie.
> mediation.  

In this case the PF does not look to be involved, the ICF kernel
driver is only manipulating registers in the same VF that the vfio
owns the IOMMU for.

This is why I keep calling it a "so-called mediated device" because it
is absolutely not clear what the kernel driver is mediating. Nearly
all its work is providing a subsystem-style IOCTL interface under the
existing vfio multiplexer unrelated to vfio requirements for DMA.

> The IOMMU backing device is certainly not meant to share an IOMMU
> address space with host drivers, except as necessary for the
> mediation of the device.  The vfio model manages the IOMMU domain of
> the backing device exclusively, any attempt to dual-host the device
> respective to the IOMMU should fault in the dma/iommu-ops.  Thanks,

Sounds more reasonable if the kernel dma_ops are prevented while vfio
is using the device.

However, to me it feels wrong that just because a driver wishes to use
PASID or IOMMU features it should go through vfio and mediated
devices.

It is not even necessary as we have several examples already of
drivers using these features without vfio.

I feel like mdev is suffering from mission creep. I see people
proposing to use mdev for many wild things, the Mellanox SF stuff in
the other thread and this 'virtio subsystem' being the two that have
come up publicly this month.

Putting some boundaries on mdev usage would really help people know
when to use it. My top two from this discussion would be:

- mdev devices should only bind to vfio. It is not a general kernel
  driver matcher mechanism. It is not 'virtual-bus'.

- mdev & vfio are not a substitute for a proper kernel subsystem. We
  shouldn't export a complex subsystem-like ioctl API through
  vfio ioctl extensions. Make a proper subsystem, it is not so hard.

Maybe others agree?

Thanks,
Jason
