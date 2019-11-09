Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 365B2F5C39
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfKIAMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:12:30 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37134 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfKIAMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 19:12:30 -0500
Received: by mail-qt1-f193.google.com with SMTP id g50so8552279qtb.4
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 16:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V+15hNGWzZ5qdAfugIMzQNocbiPB7oellkFZJC8HU+Q=;
        b=CUHMKRDJ5tIhmsKfKQcIrK1q4kMvL7T0lx88oBNrL++oHEg04jkrk1YwQdycyyHz5E
         a4XpiwUbzcKOA62eo2pCGiGNdruvP+b23CNQvntc5MgIpuHvxRj3gjuZ96c1BjdzFvVJ
         UgjuohFfwdIhlb94wMtwp4VRynfYFZPO0GuwdmuPOgdgAqU2QL+Dy4x9PgKMFuhrTYrv
         avtj+1MHl+sn3QFnvC9dm/lGI/HbUDcqGz2ikMgfDNBM4+TkBiq33oqOHUK9oka1Fn2f
         QJDMmHHEEYpbtsbhn1c4JejANZZPCUOG3TfjTn6vF/HTt5w+ad2lv4xcuyL5I+Sxy7iM
         8SJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V+15hNGWzZ5qdAfugIMzQNocbiPB7oellkFZJC8HU+Q=;
        b=sox6ibh+V21QAmuq4KQ2XUv5V5PPUABizK95jF/bXGj2r0lv3Blldi6r4JosKATZ7T
         Q1dxRVw1H/xK/EvvmEiMqp9tOmhun8xu58sg9GR3C2t124C+W7A1ojF38L7QcmL68IOf
         2RGGKwdor5tl7+Yoa7YAa63DgxOLunzj3AY0baDeaMqwM0Tla+DPRpCnl0bUU279XxRQ
         73X1Dbhq3wY2M/tA282d49PGT/1BTPRSoMPt6wP8oUjlf8YWW4Ewjxu/O06zVH/IeP26
         9MjMkJVgWpX3PyUMzpj3PdWYdc1yZSa1lfmt4CjDzmWi6Zd0vqC+o+dQdKgxpCirts9Y
         seTA==
X-Gm-Message-State: APjAAAVArphZ5QcFFT9O98kMkW1isBX+fcol4N86ENIU7RBxwA5CBGVb
        QfSZEeq3VlYT0LW72uejwFugCQ==
X-Google-Smtp-Source: APXvYqwGjEX/efryjqRxpApNrzdHA5Q4BXecu4pIPdHnxbnFY0nysNKTeSjPWN0g6MMd7lX1mc1Bvg==
X-Received: by 2002:ac8:28c7:: with SMTP id j7mr14729514qtj.4.1573258347052;
        Fri, 08 Nov 2019 16:12:27 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id m22sm3400409qka.28.2019.11.08.16.12.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Nov 2019 16:12:26 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iTEMb-0000r5-TV; Fri, 08 Nov 2019 20:12:25 -0400
Date:   Fri, 8 Nov 2019 20:12:25 -0400
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
        Or Gerlitz <gerlitz.or@gmail.com>,
        "Jason Wang (jasowang@redhat.com)" <jasowang@redhat.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191109001225.GA31761@ziepe.ca>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home>
 <20191108210545.GG10956@ziepe.ca>
 <20191108145210.7ad6351c@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108145210.7ad6351c@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 02:52:10PM -0700, Alex Williamson wrote:
> > > 
> > > Unless there's some opposition, I'm intended to queue this for v5.5:
> > > 
> > > https://www.spinics.net/lists/kvm/msg199613.html
> > > 
> > > mdev has started out as tied to vfio, but at it's core, it's just a
> > > device life cycle infrastructure with callbacks between bus drivers
> > > and vendor devices.  If virtio is on the wrong path with the above
> > > series, please speak up.  Thanks,  
> > 
> > Well, I think Greg just objected pretty strongly.
> > 
> > IMHO it is wrong to turn mdev into some API multiplexor. That is what
> > the driver core already does and AFAIK your bus type is supposed to
> > represent your API contract to your drivers.
> > 
> > Since the bus type is ABI, 'mdev' is really all about vfio I guess?
> > 
> > Maybe mdev should grow by factoring the special GUID life cycle stuff
> > into a helper library that can make it simpler to build proper API
> > specific bus's using that lifecycle model? ie the virtio I saw
> > proposed should probably be a mdev-virtio bus type providing this new
> > virtio API contract using a 'struct mdev_virtio'?
> 
> I see, the bus:API contract is more clear when we're talking about
> physical buses and physical devices following a hardware
> specification.

Well, I don't think it matters, this is a software contract inside the
kernel between the 'struct foo_device' (as provided by the foo_bus)
and the 'struct foo_driver'

This contract is certainly easier to define when a HW specification
dictates basically how it works.

> But if we take PCI for example, each PCI device has it's own internal
> API that operates on the bus API.  PCI bus drivers match devices based
> on vendor and device ID, which defines that internal API, not the bus
> API.  

Yes, this matching is part of the API contract between the bus and
device driver.

But all of the pci_* functions that accept a 'struct pci_device *' are
also part of this API contract toward the driver.

> The bus API is pretty thin when we're talking virtual devices and
> virtual buses though.  The bus "API" is essentially that lifecycle
> management, so I'm having a bit of a hard time differentiating this

But Parav just pointed out to a virtio SW API that had something like
20 API entry points.

> instead?"  Essentially for virtual devices, we're dictating a bus per
> device type, whereas it seemed like a reasonable idea at the time to

Well, what does a driver binding to a virtual device need to know?

The virtual device API should provide all of that information.

I think things like vfio and virtio APIs are very reasonable bus
types. virtio in particular has a published 'hw-like' specification
with some good layers that can build a bus API.

Not so sure about the very HW specific things like the Intel driver and
these SFs. These will really only ever bind to one driver and seem to
have no commonalities.

For those we either create a bus per driver-specific proprietary API
(feels kind of wrong) or we have a generic bus essentially for managed
multi-function hardware that uses a simple 'void *hw_data' as the
driver API and some matching logic to support that.

> create a common virtual device bus, but maybe it went into the weeds
> when trying to figure out how device drivers match to devices on that
> bus and actually interact with them.

I think it is important to focus on the the SW API the 'struct
foo_device' is supposed to provide toward the driver that binds to it.

It should be a sensible API covering some well defined area..

Jason
