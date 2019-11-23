Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84AD31080FD
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 00:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfKWXJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 18:09:52 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43307 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbfKWXJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 18:09:52 -0500
Received: by mail-qt1-f196.google.com with SMTP id q8so9876960qtr.10
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 15:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=QUKMDS+SD49m7VZLfzH9P44dw/EqmARrwz8HhZZaElQ=;
        b=cNkJNbyAl16DROUBXLPus9MoFSX2b+v5mrC1huoFuIPbPNqcxLUcBBvcyTWwob1/Oa
         LhV6FITLF2T0Nf4gK8nckmwZyPpWAwh+uq91xUqTnl5xuA0INYxMGkHNBUqYX1IrlyjM
         HkwiQANXqPKUiNjEe369Yw/lGc6IvOD1bAucs2uaYJRjo72akB0ww6FFqP6wmGHsezya
         347O1wj5PzuZWzDZirS300CZzuwgkgM4rSJb6z1Y32BnLf9y8GESxl6iMRFl1OwXFz+g
         cNsDhqTus9IcxgTe9KMwbO8TXEXMOs/PMRelw1puH0RpOYJYm+pmAQN9tDB8MeQIwENp
         Tr/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=QUKMDS+SD49m7VZLfzH9P44dw/EqmARrwz8HhZZaElQ=;
        b=Ng2SO0LBjyt8DWNtoQzpMf7pnA83cdhYM+EW5XlQTSMfmBS2LkrcSktoTbiDBIpqtl
         iw+mkPWNywM64GhX4KTHNcIX5GH1pQhVUSlgIDuaamv4v6Jr0H/qixz32nWIxdf+Bu+L
         v9GTrxREQIwDnVwxVG+0gBx5ygeMvhl7hUE29SSg53XISBdgHuCjbHoXmwZq3f/bfV+T
         NOaBvmznWcJPxmpcUgzJvzXjK9tdGHqKEcD3tI1flUsuAbJPsIGiIBM300Dqu8yHJ/jf
         uIn4uG85tWZSOcQ01FB3Qy274kltOaRxk8HWCNTaVtjey7K1NkMrqK/81SPOButs2gvg
         CL8w==
X-Gm-Message-State: APjAAAWc5zFoqG4wnDQmTUvc0QPTJkSZTcKJoHzNzrA7NDff9uojZk6x
        MHqtdB685GnjDDfnfEPjgCMTOw==
X-Google-Smtp-Source: APXvYqx99DfDccErQ7Wk72kTbrFwA6HWXUk6CZmWF24dpLPXyC4iSn+fW8B46GNZlFTGLpGj/pF4/Q==
X-Received: by 2002:ac8:2279:: with SMTP id p54mr3948523qtp.368.1574550590916;
        Sat, 23 Nov 2019 15:09:50 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id a62sm1020273qkf.81.2019.11.23.15.09.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Nov 2019 15:09:49 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iYeXE-0006hw-V3; Sat, 23 Nov 2019 19:09:48 -0400
Date:   Sat, 23 Nov 2019 19:09:48 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191123230948.GF7448@ziepe.ca>
References: <20191120133835.GC22515@ziepe.ca>
 <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
 <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
 <20191121141732.GB7448@ziepe.ca>
 <721e49c2-a2e1-853f-298b-9601c32fcf9e@redhat.com>
 <20191122180214.GD7448@ziepe.ca>
 <20191123043951.GA364267@___>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191123043951.GA364267@___>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 12:39:51PM +0800, Tiwei Bie wrote:
> On Fri, Nov 22, 2019 at 02:02:14PM -0400, Jason Gunthorpe wrote:
> > On Fri, Nov 22, 2019 at 04:45:38PM +0800, Jason Wang wrote:
> > > On 2019/11/21 下午10:17, Jason Gunthorpe wrote:
> > > > On Thu, Nov 21, 2019 at 03:21:29PM +0800, Jason Wang wrote:
> > > > > > The role of vfio has traditionally been around secure device
> > > > > > assignment of a HW resource to a VM. I'm not totally clear on what the
> > > > > > role if mdev is seen to be, but all the mdev drivers in the tree seem
> > > > > > to make 'and pass it to KVM' a big part of their description.
> > > > > > 
> > > > > > So, looking at the virtio patches, I see some intended use is to map
> > > > > > some BAR pages into the VM.
> > > > > Nope, at least not for the current stage. It still depends on the
> > > > > virtio-net-pci emulatio in qemu to work. In the future, we will allow such
> > > > > mapping only for dorbell.
> > > > There has been a lot of emails today, but I think this is the main
> > > > point I want to respond to.
> > > > 
> > > > Using vfio when you don't even assign any part of the device BAR to
> > > > the VM is, frankly, a gigantic misuse, IMHO.
> > > 
> > > That's not a compelling point. 
> > 
> > Well, this discussion is going nowhere.
> 
> You removed JasonW's other reply in above quote. He said it clearly
> that we do want/need to assign parts of device BAR to the VM.

Generally we don't look at patches based on stuff that isn't in them.

> > I mean the library functions in the kernel that vfio uses to implement
> > all the user dma stuff. Other subsystems use them too, it is not
> > exclusive to vfio.
> 
> IIUC, your point is to suggest us invent new DMA API for userspace to
> use instead of leveraging VFIO's well defined DMA API. Even if we don't
> use VFIO at all, I would imagine it could be very VFIO-like (e.g. caps
> for BAR + container/group for DMA) eventually.

None of the other user dma subsystems seem to have the problems you
are imagining here. Perhaps you should try it first?
 
> > > > Further, I do not think it is wise to design the userspace ABI around
> > > > a simplistict implementation that can't do BAR assignment,
> > > 
> > > Again, the vhost-mdev follow the VFIO ABI, no new ABI is invented, and
> > > mmap() was kept their for mapping device regions.
> > 
> > The patches have a new file in include/uapi.
> 
> I guess you didn't look at the code. Just to clarify, there is no
> new file introduced in include/uapi. Only small vhost extensions to
> the existing vhost uapi are involved in vhost-mdev.

You know, I review alot of patches every week, and sometimes I make
mistakes, but not this time. From the ICF cover letter:

https://lkml.org/lkml/2019/11/7/62

 drivers/vfio/mdev/mdev_core.c    |  21 ++
 drivers/vhost/Kconfig            |  12 +
 drivers/vhost/Makefile           |   3 +
 drivers/vhost/mdev.c             | 556 +++++++++++++++++++++++++++++++
 include/linux/mdev.h             |   5 +
 include/uapi/linux/vhost.h       |  21 ++
 include/uapi/linux/vhost_types.h |   8 +
      ^^^^^^^^^^^^^^

Perhaps you thought I ment ICF was adding uapi? My remarks cover all
three of the series involved here.

Jason
