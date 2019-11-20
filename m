Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902CC104133
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 17:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbfKTQp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 11:45:29 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44961 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729901AbfKTQp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 11:45:28 -0500
Received: by mail-qt1-f193.google.com with SMTP id o11so182609qtr.11
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 08:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q1Cjbt1crzEAWmbqF8+hcYqt5jaBaZcCfokyHmlm+ZE=;
        b=jN7A5asvd6GYVcpqiyvx4PrQ1taaPGc3wWST/UZf8modwzUdyuMV0Ldym4k2MugPls
         HQGQEGZW00LzrXy5HPuVBjwRuFbWfU05hdBTEbZToMwdUTNdTtQVj9m9puaZqvHH9X+G
         PpYEvEeWGvR0B2vA2WQxgPP/FveyyT1eaa0ztp0oUEspEXqYKgckX4NMcMjP96niJEAp
         jyHu2bSeQYhrFisDhP3b6+zkyFisrMbchDyzNS/kCGNg18LHkBSiK3UDoRnjeLP+mec5
         UBzUGa3NKhNWggwMX1DpWnhkqtejG3/1lW4JohsNw9UuCU9O0kfLL5EZhGqUyRDFoFtN
         MpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=q1Cjbt1crzEAWmbqF8+hcYqt5jaBaZcCfokyHmlm+ZE=;
        b=VPJTuOOtxFMAZpruPZVk4oHUPRA0zK+TqjeN908Nn7eR7hftFZmcVl4R10FQXGniWk
         TByvU2WLy6BY13OEc1uYpA+agi+gurIB3SYNCC7KlpKDvaM472WrVipZ8Y6Df0/8O9Xp
         LhZGovT7UzZuPNIJofOWHOaJ777EPhb8YD7iCZHKVwAKlIfSG9BRPER426psf6wU5PqQ
         jr4oroz9Gxp8Qr9jvv1zybW/InzONb8hK0eox2xDXEazyBq/VhdJT+a++X4zPvdw3o9W
         vtur4lAytafrTI59/4RGBVFgIJsVeUupTsRd4fyzdtutf2Z086QNMPWNlC2Pg1zatEWu
         9C8A==
X-Gm-Message-State: APjAAAUcNYTVY47WgwDLO59HeOf5O4xVntcGxGOBVz+dyz0dj6tg+3xU
        HffNmDhcl98h2G/iVto9HDmubg==
X-Google-Smtp-Source: APXvYqwbHsjBsBVLwFNKQge8I0L4IlOfNnRWURPlA6eW2epxh/y9TADVEeZ/MKxrIQtLu9b5PHBosA==
X-Received: by 2002:ac8:641:: with SMTP id e1mr3584184qth.319.1574268326456;
        Wed, 20 Nov 2019 08:45:26 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id j89sm14324797qte.72.2019.11.20.08.45.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Nov 2019 08:45:25 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXT6b-0007oA-2a; Wed, 20 Nov 2019 12:45:25 -0400
Date:   Wed, 20 Nov 2019 12:45:25 -0400
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
Message-ID: <20191120164525.GH22515@ziepe.ca>
References: <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <20191120022141-mutt-send-email-mst@kernel.org>
 <20191120130319.GA22515@ziepe.ca>
 <20191120083908-mutt-send-email-mst@kernel.org>
 <20191120143054.GF22515@ziepe.ca>
 <20191120093607-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120093607-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 09:57:17AM -0500, Michael S. Tsirkin wrote:
> On Wed, Nov 20, 2019 at 10:30:54AM -0400, Jason Gunthorpe wrote:
> > On Wed, Nov 20, 2019 at 08:43:20AM -0500, Michael S. Tsirkin wrote:
> > > On Wed, Nov 20, 2019 at 09:03:19AM -0400, Jason Gunthorpe wrote:
> > > > On Wed, Nov 20, 2019 at 02:38:08AM -0500, Michael S. Tsirkin wrote:
> > > > > > > I don't think that extends as far as actively encouraging userspace
> > > > > > > drivers poking at hardware in a vendor specific way.  
> > > > > > 
> > > > > > Yes, it does, if you can implement your user space requirements using
> > > > > > vfio then why do you need a kernel driver?
> > > > > 
> > > > > People's requirements differ. You are happy with just pass through a VF
> > > > > you can already use it. Case closed. There are enough people who have
> > > > > a fixed userspace that people have built virtio accelerators,
> > > > > now there's value in supporting that, and a vendor specific
> > > > > userspace blob is not supporting that requirement.
> > > > 
> > > > I have no idea what you are trying to explain here. I'm not advocating
> > > > for vfio pass through.
> > > 
> > > You seem to come from an RDMA background, used to userspace linking to
> > > vendor libraries to do basic things like push bits out on the network,
> > > because users live on the performance edge and rebuild their
> > > userspace often anyway.
> > > 
> > > Lots of people are not like that, they would rather have the
> > > vendor-specific driver live in the kernel, with userspace being
> > > portable, thank you very much.
> > 
> > You are actually proposing a very RDMA like approach with a split
> > kernel/user driver design. Maybe the virtio user driver will turn out
> > to be 'portable'.
> > 
> > Based on the last 20 years of experience, the kernel component has
> > proven to be the larger burden and drag than the userspace part. I
> > think the high interest in DPDK, SPDK and others show this is a common
> > principle.
> 
> And I guess the interest in BPF shows the opposite?

There is room for both, I wouldn't discount either approach entirely
out of hand.

> > At the very least for new approaches like this it makes alot of sense
> > to have a user space driver until enough HW is available that a
> > proper, well thought out kernel side can be built.
> 
> But hardware is available, driver has been posted by Intel.
> Have you looked at that?

I'm not sure pointing at that driver is so helpful, it is very small
and mostly just reflects virtio ops into some undocumented register
pokes.

There is no explanation at all for the large scale architecture
choices:
 - Why vfio
 - Why mdev without providing a device IOMMU
 - Why use GUID lifecycle management for singlton function PF/VF
   drivers
 - Why not use devlink
 - Why not use vfio-pci with a userspace driver

These are legitimate questions and answers like "because we like it
this way" or "this is how the drivers are written today" isn't very
satisfying at all.

> > For instance, this VFIO based approach might be very suitable to the
> > intel VF based ICF driver, but we don't yet have an example of non-VF
> > HW that might not be well suited to VFIO.
>
> I don't think we should keep moving the goalposts like this.

It is ABI, it should be done as best we can as we have to live with it
for a long time. Right now HW is just starting to come to market with
VDPA and it feels rushed to design a whole subsystem style ABI around
one, quite simplistic, driver example.

> If people write drivers and find some infrastruture useful,
> and it looks more or less generic on the outset, then I don't
> see why it's a bad idea to merge it.

Because it is userspace ABI, caution is always justified when defining
new ABI.

Jason
