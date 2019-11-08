Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F083CF5925
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731878AbfKHVFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:05:48 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41686 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731837AbfKHVFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:05:48 -0500
Received: by mail-qk1-f195.google.com with SMTP id m125so6530985qkd.8
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MT/LY/XgFSJdf41oOOrhevuJKKJ8QyaowUuyyauvEB4=;
        b=S3W0WVKg61O3wdCan3sBSH25msasI778xeQivDFRYbUn37LKqhN0hULZcApsbDa45g
         JbHEoEGLFWc3hNPNr61qqCa89hxSA+wo1ImqI93HkX3gq/CXIKz/xd0/qeMLnTqQzFNp
         KtyRNtOvPCKRIP0VDBd4uHha5U1fV53w1I4FqOysZfFlsCk4EChQMIh7ThHnC7i9zqGt
         J3WFoua7ssvszaCyaKuDgx4pwoKbORWQgeeonhqq1KQVAzxbieaaTPMCUUd9lTIAZXpB
         jiDs79EZye1oc/lW+p2h20fu6gKr0IovwB3u6MDtq+XbTHziKAmjesknB392DnzXENO8
         1XAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MT/LY/XgFSJdf41oOOrhevuJKKJ8QyaowUuyyauvEB4=;
        b=TYDkCUtkczIaN5DZXijkvHpS9fR9bZyrPc10Eq8xkAZdolMCoWgnneTbnRpBzgq/w6
         ENYF8zA8paBzCmEvKzHMZEh6RzkI9aAQ4zlFIX/Qfdq4n+DV0/CP0tkxtFCLi/G1RH3E
         L9qLfzmeGcZbLJzlmeCgTdMNzVbg6gZ5OqZNHvN82Nj7iuduPcyk3cdyL1CggySDnAvI
         4ZYZVLD2+zYn7GZJHCFo6lQgB9vj1QLYKXdjEletDmYgMSMSETNHb6DQUnqC+ki1iyt/
         YvEzG43Na6WhPh/HqItQVf45cWRE+4UzzMVLnYDJjbonWNg1GHP6BgCVKZiJ/eGl9wA1
         HSig==
X-Gm-Message-State: APjAAAUJQ4WFa3JKtNnD/ZEEAcpAT6sWj74IoP0Gc7/jWrVQ3/IX4Wfq
        0lW7I3H4OiFE0zKu1GRuZmXyRw==
X-Google-Smtp-Source: APXvYqzQCDP5uvAgzIXZTDyoCjjQ5STGt5nb+qLD8/SkU7C35PUxocQ3qBcHamvrNh90Yo5LLJJBNQ==
X-Received: by 2002:a37:4752:: with SMTP id u79mr7777126qka.456.1573247146585;
        Fri, 08 Nov 2019 13:05:46 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id n185sm3368873qkd.32.2019.11.08.13.05.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Nov 2019 13:05:46 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iTBRx-0007ha-JA; Fri, 08 Nov 2019 17:05:45 -0400
Date:   Fri, 8 Nov 2019 17:05:45 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Parav Pandit <parav@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108210545.GG10956@ziepe.ca>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108133435.6dcc80bd@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 01:34:35PM -0700, Alex Williamson wrote:
> On Fri, 8 Nov 2019 16:12:53 -0400
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Fri, Nov 08, 2019 at 11:12:38AM -0800, Jakub Kicinski wrote:
> > > On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote:  
> > > > > The new intel driver has been having a very similar discussion about how to
> > > > > model their 'multi function device' ie to bind RDMA and other drivers to a
> > > > > shared PCI function, and I think that discussion settled on adding a new bus?
> > > > > 
> > > > > Really these things are all very similar, it would be nice to have a clear
> > > > > methodology on how to use the device core if a single PCI device is split by
> > > > > software into multiple different functional units and attached to different
> > > > > driver instances.
> > > > > 
> > > > > Currently there is alot of hacking in this area.. And a consistent scheme
> > > > > might resolve the ugliness with the dma_ops wrappers.
> > > > > 
> > > > > We already have the 'mfd' stuff to support splitting platform devices, maybe
> > > > > we need to create a 'pci-mfd' to support splitting PCI devices?
> > > > > 
> > > > > I'm not really clear how mfd and mdev relate, I always thought mdev was
> > > > > strongly linked to vfio.
> > > > >  
> > > >
> > > > Mdev at beginning was strongly linked to vfio, but as I mentioned
> > > > above it is addressing more use case.
> > > > 
> > > > I observed that discussion, but was not sure of extending mdev further.
> > > > 
> > > > One way to do for Intel drivers to do is after series [9].
> > > > Where PCI driver says, MDEV_CLASS_ID_I40_FOO
> > > > RDMA driver mdev_register_driver(), matches on it and does the probe().  
> > > 
> > > Yup, FWIW to me the benefit of reusing mdevs for the Intel case vs
> > > muddying the purpose of mdevs is not a clear trade off.  
> > 
> > IMHO, mdev has amdev_parent_ops structure clearly intended to link it
> > to vfio, so using a mdev for something not related to vfio seems like
> > a poor choice.
> 
> Unless there's some opposition, I'm intended to queue this for v5.5:
> 
> https://www.spinics.net/lists/kvm/msg199613.html
> 
> mdev has started out as tied to vfio, but at it's core, it's just a
> device life cycle infrastructure with callbacks between bus drivers
> and vendor devices.  If virtio is on the wrong path with the above
> series, please speak up.  Thanks,

Well, I think Greg just objected pretty strongly.

IMHO it is wrong to turn mdev into some API multiplexor. That is what
the driver core already does and AFAIK your bus type is supposed to
represent your API contract to your drivers.

Since the bus type is ABI, 'mdev' is really all about vfio I guess?

Maybe mdev should grow by factoring the special GUID life cycle stuff
into a helper library that can make it simpler to build proper API
specific bus's using that lifecycle model? ie the virtio I saw
proposed should probably be a mdev-virtio bus type providing this new
virtio API contract using a 'struct mdev_virtio'?

I only looked briefly but mdev seems like an unusual way to use the
driver core. *generally* I would expect that if a driver wants to
provide a foo_device (on a foo bus, providing the foo API contract) it
looks very broadly like:

  struct foo_device {
       struct device dev;
       const struct foo_ops *ops;
  };
  struct my_foo_device {
      struct foo_device fdev;
  };

  foo_device_register(&mydev->fdev);

Which means we can use normal container_of() patterns, while mdev
seems to want to allocate all the structs internally.. I guess this is
because of how the lifecycle stuff works? From a device core view it
looks quite unnatural.

Jason
