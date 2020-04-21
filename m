Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410251B1F40
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 08:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgDUGw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 02:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbgDUGw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 02:52:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 346802072D;
        Tue, 21 Apr 2020 06:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587451945;
        bh=OHlqcF306QhYIeTd9bYZQ5LtHbsOIHrlGcnT1sqQsKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EqZ1nHxwagrKTX0o/mqD6JUX0yUnRx6L644kP2uXi8mO3IvDEcYhpWkRBgsmD/Mc6
         mPk6juFXZ9W3fsGVZucDJ5nkwAz9sJfRZBzeKz5pWeAjXXx2Z4wAGfZyc6W8/rTRHT
         p+Y2cpeHpiKSCCFpay6Or4E81YF6/syoMK1cfVRw=
Date:   Tue, 21 Apr 2020 08:52:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/9] Implementation of Virtual Bus
Message-ID: <20200421065223.GB347130@kroah.com>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
 <20200417171034.1533253-2-jeffrey.t.kirsher@intel.com>
 <20200418125051.GA3473692@kroah.com>
 <DM6PR11MB28418BEB2385E7E2929C2FF6DDD40@DM6PR11MB2841.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB28418BEB2385E7E2929C2FF6DDD40@DM6PR11MB2841.namprd11.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 10:59:12PM +0000, Ertman, David M wrote:
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Saturday, April 18, 2020 5:51 AM
> > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> > Cc: davem@davemloft.net; Ertman, David M <david.m.ertman@intel.com>;
> > netdev@vger.kernel.org; linux-rdma@vger.kernel.org; nhorman@redhat.com;
> > sassmann@redhat.com; jgg@ziepe.ca; parav@mellanox.com;
> > galpress@amazon.com; selvin.xavier@broadcom.com;
> > sriharsha.basavapatna@broadcom.com; benve@cisco.com;
> > bharat@chelsio.com; xavier.huwei@huawei.com; yishaih@mellanox.com;
> > leonro@mellanox.com; mkalderon@marvell.com; aditr@vmware.com;
> > ranjani.sridharan@linux.intel.com; pierre-louis.bossart@linux.intel.com; Patil,
> > Kiran <kiran.patil@intel.com>; Bowers, AndrewX <andrewx.bowers@intel.com>
> > Subject: Re: [net-next 1/9] Implementation of Virtual Bus
> > 
> > On Fri, Apr 17, 2020 at 10:10:26AM -0700, Jeff Kirsher wrote:
> > > @@ -0,0 +1,53 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > +/*
> > > + * virtual_bus.h - lightweight software bus
> > > + *
> > > + * Copyright (c) 2019-20 Intel Corporation
> > > + *
> > > + * Please see Documentation/driver-api/virtual_bus.rst for more information
> > > + */
> > > +
> > > +#ifndef _VIRTUAL_BUS_H_
> > > +#define _VIRTUAL_BUS_H_
> > > +
> > > +#include <linux/device.h>
> > > +
> > > +struct virtbus_device {
> > > +	struct device dev;
> > > +	const char *name;
> > 
> > struct device already has a name, why do you need another one?
> 
> The name in dev is the base name appended with the id to make sure each device
> has unique name.  The name in vdev is the abbreviated one (without the id) which
> will be used in the matching function, so that a driver can claim to support
> <name> and will be matched with all <name>.<id> devices for all id's.
> 
> This is similar logic to platform_device's name field.

Don't treat platform_device as a good example of much :)

I still think this is duplicated stuff, but I'll let it go for now...

> > > +	void (*release)(struct virtbus_device *);
> > 
> > A bus should have the release function, not the actual device itself.  A
> > device should not need function pointers.
> > 
> 
> The bus does have a release function, but it is a wrapper to call the release defined by
> the device.

odd.  That is normally handled by the bus, not by the device itself.

> This is where the KO registering the virtbus_device is expected to clean up
> the resources allocated for this device (e.g. free memory, etc).  Having the virtual_bus_release
> call a release callback in the virtual_device allows for extra cleanup from the originating KO
> if necessary.
> 
> The memory model of virtual bus is for the originating KO to manage the lifespan of the
> memory for the virtual_device.  The virtual_bus expects the KO defining the virtbus_device
> have the memory allocated before registering a virtbus_device and to clean up that memory
> when the release is called.
> 
> The platform_device also has function pointers in it, by including a MFD object, but the
> platform_bus is managing the memory for the platform_bus_object that contains the
> platform_device which it why it using a generic kref_put to free memory.

Again, platform_devices are not good things to emulate, they have grown
into a total mess.

Ok, given that you are going to be putting lots of different things on
this "generic" type of bus, a release function for the device can make
sense.  Still feels odd, I wonder if you should just do something with
the type of the device instead.

thanks,

greg k-h
