Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B4AF5C7D
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfKIAo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:44:29 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37102 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfKIAo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 19:44:29 -0500
Received: by mail-qt1-f195.google.com with SMTP id g50so8653016qtb.4
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 16:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B6AsAEdaQP+BADPdj+87hUO8mEGZVKONB4VdpSE05BI=;
        b=FSc7UwXCD3bvLowUhAX89Fk/5Ce7sEUxZvmDEhlz88K+/19IIPk5VrPpnJLG4bhZHx
         GS88IN6livKx7/XAOeuh6bOldTL+a8I74sXiV3PX27y5pX5a6yr2QU6U+2UzDglihwaU
         acak4xwA475aKzTkXdpac0xlHG7l3LWh6isv7FObYXkQGqvz7WY5XpGte7YhYl8juY3i
         4Vpp6zeWjO//faK4qhJ25im44LZPFdJ0G8idlBaLivKb6E/nlCuAgM9D+cpwUbUl16qe
         10sij2KhSyDjdKMv92Qtzu0lijBffvV1wjCovlOpgTVbR9jFppJj1hVd313UIh1CMdTe
         ynKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B6AsAEdaQP+BADPdj+87hUO8mEGZVKONB4VdpSE05BI=;
        b=sCV5WWdQmVeF8SUoXc7d3IfOHjGehLkXEePzLVNco0E8QC/hWkRMgyO/OGhel+0C36
         8HTeE6BYt4Oqx/ZSg/wRGSSEtadmnk9hRXbqUglliHJTdde0MGSpuwgO2/C0M9RcZT6+
         sHX4fRPqh6NFKHC5OlGK/j8ncD1aTy4cGIepF+ZyouQkQ4m9cx3KU44+esgLA4/uRlB6
         HauKMHYdGORj9uOCcFHxFcAbR+CyMiL+aMMIyGRYqalkkf5eqeouiCWLGOOjIwyLe2W6
         xal5YEDjjoKGhMWvWfz0djHSKosAfKX7ZIDpVcSEpNBvxsqMZeD1yL+63CbYz5CIBQto
         EMHg==
X-Gm-Message-State: APjAAAX/hLtk0CtreR7gGicYSid3OS0bApA6WHgIqFcFW04HE/DmG883
        qdNjuRs83HE1G2JsB4oKZO+Thw==
X-Google-Smtp-Source: APXvYqyjH10GtddZY+zdXrWmlMbrPO+o8D5JUuta2XMWxmidoRFUkNkKBPTlCLDB3VSLLOT2txA9FQ==
X-Received: by 2002:aed:2041:: with SMTP id 59mr14065684qta.79.1573260267815;
        Fri, 08 Nov 2019 16:44:27 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id o3sm4799180qta.3.2019.11.08.16.44.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Nov 2019 16:44:27 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iTEra-00018v-RE; Fri, 08 Nov 2019 20:44:26 -0400
Date:   Fri, 8 Nov 2019 20:44:26 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Message-ID: <20191109004426.GB31761@ziepe.ca>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108134559.42fbceff@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108134559.42fbceff@cakuba>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 01:45:59PM -0800, Jakub Kicinski wrote:

> > IMHO, mdev has amdev_parent_ops structure clearly intended to link it
> > to vfio, so using a mdev for something not related to vfio seems like
> > a poor choice.
> 
> Yes, my suggestion to use mdev was entirely based on the premise that
> the purpose of this work is to get vfio working.. otherwise I'm unclear
> as to why we'd need a bus in the first place. If this is just for
> containers - we have macvlan offload for years now, with no need for a
> separate device.

This SF thing is a full fledged VF function, it is not at all like
macvlan. This is perhaps less important for the netdev part of the
world, but the difference is very big for the RDMA side, and should
enable VFIO too..
 
> On the RDMA/Intel front, would you mind explaining what the main
> motivation for the special buses is? I'm a little confurious.

Well, the issue is driver binding. For years we have had these
multi-function netdev drivers that have a single PCI device which must
bind into multiple subsystems, ie mlx5 does netdev and RDMA, the cxgb
drivers do netdev, RDMA, SCSI initiator, SCSI target, etc. [And I
expect when NVMe over TCP rolls out we will have drivers like cxgb4
binding to 6 subsytems in total!]

Today most of this is a big hack where the PCI device binds to the
netdev driver and then the other drivers in different subsystems
'discover' that an appropriate netdev is plugged in using various
unique, hacky and ugly means. For instance cxgb4 duplicates a chunk of
the device core, see cxgb4_register_uld() for example. Other drivers
try to use netdev notifiers, and various other wild things.

So, the general concept is to use the driver model to manage driver
binding. A multi-subsystem driver would have several parts:

- A pci_driver which binds to the pci_device (the core)
  It creates, on a bus, struct ??_device's for the other subsystems
  that this HW supports. ie if the chip supports netdev then a 
  ??_device that binds to the netdev driver is created, same for RDMA

- A ??_driver in netdev binds to the device and accesses the core API
- A ??_driver in RDMA binds to the device and accesses the core API
- A ??_driver in SCSI binds to the device and accesses the core API

Now the driver model directly handles all binding, autoloading,
discovery, etc, and 'netdev' is just another consumer of 'core'
functionality.

For something like mlx5 the 'core' is the stuff in
drivers/net/ethernet/mellanox/mlx5/core/*.c, give or take. It is
broadly generic stuff like send commands, create queues, manage HW
resources, etc.

There has been some lack of clarity on what the ?? should be. People
have proposed platform and MFD, and those seem to be no-goes. So, it
looks like ?? will be a mlx5_driver on a mlx5_bus, and Intel will use
an ice_driver on a ice_bus, ditto for cxgb4, if I understand Greg's
guidance.

Though I'm wondering if we should have a 'multi_subsystem_device' that
was really just about passing a 'void *core_handle' from the 'core'
(ie the bus) to the driver (ie RDMA, netdev, etc). 

It seems weakly defined, but also exactly what every driver doing this
needs.. It is basically what this series is abusing mdev to accomplish.

> My understanding is MFD was created to help with cases where single
> device has multiple pieces of common IP in it. 

MFD really seems to be good at splitting a device when the HW is
orthogonal at the register level. Ie you might have regs 100-200 for
ethernet and 200-300 for RDMA.

But this is not how modern HW works, the functional division is more
subtle and more software based. ie on most devices a netdev and rdma
queue are nearly the same, just a few settings make them function
differently.

So what is needed isn't a split of register set like MFD specializes
in, but a unique per-driver API between the 'core' and 'subsystem'
parts of the multi-subsystem device.

> Do modern RDMA cards really share IP across generations? 

What is a generation? Mellanox has had a stable RDMA driver across
many sillicon generations. Intel looks like their new driver will
support at least the last two or more sillicon generations..

RDMA drivers are monstrous complex things, there is a big incentive to
not respin them every time a new chip comes out.

> Is there a need to reload the drivers for the separate pieces (I
> wonder if the devlink reload doesn't belong to the device model :().

Yes, it is already done, but without driver model support the only way
to reload the rdma driver is to unload the entire module as there is
no 'unbind'

Jason
