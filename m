Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A5DF5888
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbfKHUcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:32:14 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44895 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKHUcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 15:32:13 -0500
Received: by mail-qk1-f194.google.com with SMTP id m16so6438252qki.11
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 12:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qCQEt9epCNTEc/0w5fj01+GJUvFREV2TMWhrgChcDEk=;
        b=HglAdyWqFINPdsTYKBaBKNrM1Lo2oOUUZEZsQT4ith3qfqO9mHggwB9HDaL51NCpoE
         D9qjgL5iF11nm7WKrvVPqMvLUAWjyFd7UWHj1fFq5kj+6mV7toHZqpQYc7nVWNGTETX+
         0IBlM8CadMnysfWyKiBnH5vVNBufx/gVK/x+9DfeZQz7V4JkIkbGxSKBzUhvNCq2js/v
         rI+RdRzOShrJ7V/hWOMIADX83Tl3hFJf8tvZ1SDnglS+eQKCqFlSoAZpYYZLR9U0GnTr
         T63hIC8mxYHgnc2AzR8swA8RbJvQn8bKTQUC+uXGxpYHtO/zdKJrUJ++SQ7n5UPTNhxj
         BLtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qCQEt9epCNTEc/0w5fj01+GJUvFREV2TMWhrgChcDEk=;
        b=XSS7Vkw18N+sznR5j38RRzt8mU/VL/XDtpiPb4j4L6ff81SHHl9JDagO/qwixMPq4f
         wl/y16jk2xw/oXR0UAnCYrHSs8M0IsJuvk0AZKM/bvRA8ElT5umBJ8C0lV8o57Bwo9ag
         xOduUI7Va/v3U8Q/Ml99fdXrbNLGin8/AfrdOcpym8mNPbo5fR1IBWDuWBErhY9gZSVv
         KYCAs5m858QM+Rw9/3VAWw6HeoswFVRUSyPrHM+U3BnLJljTZKgS+tq0kr1/w869H3oi
         KtiMjmFIFXxjje9U+Fhc8NRfoLFCLkqFKkLwx3BvsoaOlDwvZIKFSXN3HszfaKHdu60T
         i6qQ==
X-Gm-Message-State: APjAAAUHMVoFnUUs4coPJa0bp34tMmEa0hof8Wdnn4OAOm6zFno7SShI
        Fi2sY6329ardh5vmK1q8coWDqA==
X-Google-Smtp-Source: APXvYqwHTPix2niu2CuvJVyCMGoWIo3sKB6z6GV1zr6xcOIZU/wV+JWwNj+eSLcNq3a7DxZJpHkBZw==
X-Received: by 2002:a05:620a:13dc:: with SMTP id g28mr10145366qkl.180.1573245130793;
        Fri, 08 Nov 2019 12:32:10 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id x25sm2889935qki.63.2019.11.08.12.32.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Nov 2019 12:32:10 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iTAvR-0005LJ-SE; Fri, 08 Nov 2019 16:32:09 -0400
Date:   Fri, 8 Nov 2019 16:32:09 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
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
Message-ID: <20191108203209.GF10956@ziepe.ca>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <AM0PR05MB4866299C3AE2448C8226DC00D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866299C3AE2448C8226DC00D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 08:20:43PM +0000, Parav Pandit wrote:
> 
> 
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > On Fri, Nov 08, 2019 at 11:12:38AM -0800, Jakub Kicinski wrote:
> > > On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote:
> > > > > The new intel driver has been having a very similar discussion
> > > > > about how to model their 'multi function device' ie to bind RDMA
> > > > > and other drivers to a shared PCI function, and I think that discussion
> > settled on adding a new bus?
> > > > >
> > > > > Really these things are all very similar, it would be nice to have
> > > > > a clear methodology on how to use the device core if a single PCI
> > > > > device is split by software into multiple different functional
> > > > > units and attached to different driver instances.
> > > > >
> > > > > Currently there is alot of hacking in this area.. And a consistent
> > > > > scheme might resolve the ugliness with the dma_ops wrappers.
> > > > >
> > > > > We already have the 'mfd' stuff to support splitting platform
> > > > > devices, maybe we need to create a 'pci-mfd' to support splitting PCI
> > devices?
> > > > >
> > > > > I'm not really clear how mfd and mdev relate, I always thought
> > > > > mdev was strongly linked to vfio.
> > > > >
> > > >
> > > > Mdev at beginning was strongly linked to vfio, but as I mentioned
> > > > above it is addressing more use case.
> > > >
> > > > I observed that discussion, but was not sure of extending mdev further.
> > > >
> > > > One way to do for Intel drivers to do is after series [9].
> > > > Where PCI driver says, MDEV_CLASS_ID_I40_FOO RDMA driver
> > > > mdev_register_driver(), matches on it and does the probe().
> > >
> > > Yup, FWIW to me the benefit of reusing mdevs for the Intel case vs
> > > muddying the purpose of mdevs is not a clear trade off.
> > 
> > IMHO, mdev has amdev_parent_ops structure clearly intended to link it to vfio,
> > so using a mdev for something not related to vfio seems like a poor choice.
> > 
> Splitting mdev_parent_ops{} is already in works for larger use case in series [1] for virtio.
> 
> [1] https://patchwork.kernel.org/patch/11233127/

Weird. So what is mdev actually providing and what does it represent
if the entire driver facing API surface is under a union?

This smells a lot like it is re-implementing a bus.. AFAIK bus is
supposed to represent the in-kernel API the struct device presents to
drivers.

Jason
