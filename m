Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46760100F0D
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 23:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfKRW5P convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 Nov 2019 17:57:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:6530 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727255AbfKRW5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 17:57:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Nov 2019 14:57:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,321,1569308400"; 
   d="scan'208";a="356925657"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga004.jf.intel.com with ESMTP; 18 Nov 2019 14:57:12 -0800
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 18 Nov 2019 14:57:12 -0800
Received: from orsmsx101.amr.corp.intel.com ([169.254.8.229]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.67]) with mapi id 14.03.0439.000;
 Mon, 18 Nov 2019 14:57:12 -0800
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATHptCZx1o750+cmj+dZwSi7aeRFzoAgABcY9A=
Date:   Mon, 18 Nov 2019 22:57:11 +0000
Message-ID: <2B0E3F215D1AB84DA946C8BEE234CCC97B3012A9@ORSMSX101.amr.corp.intel.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <20191118074834.GA130507@kroah.com>
In-Reply-To: <20191118074834.GA130507@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

        > -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Sunday, November 17, 2019 11:49 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Ertman, David M <david.m.ertman@intel.com>;
> netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; jgg@ziepe.ca;
> parav@mellanox.com; Patil, Kiran <kiran.patil@intel.com>
> Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
> 
> On Fri, Nov 15, 2019 at 02:33:55PM -0800, Jeff Kirsher wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > This is the initial implementation of the Virtual Bus, virtbus_device
> > and virtbus_driver.  The virtual bus is a software based bus intended
> > to support lightweight devices and drivers and provide matching
> > between them and probing of the registered drivers.
> >
> > The primary purpose of the virual bus is to provide matching services
> > and to pass the data pointer contained in the virtbus_device to the
> > virtbus_driver during its probe call.  This will allow two separate
> > kernel objects to match up and start communication.
> >
> > The bus will support probe/remove shutdown and suspend/resume
> > callbacks.
> >
> > Kconfig and Makefile alterations are included
> >
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > ---
> > v2: Cleaned up the virtual bus interface based on feedback from Greg KH
> >     and provided a test driver and test virtual bus device as an example
> >     of how to implement the virtual bus.
> >
> >  Documentation/driver-api/virtual_bus.rst      |  76 ++++
> >  drivers/bus/Kconfig                           |  14 +
> >  drivers/bus/Makefile                          |   1 +
> >  drivers/bus/virtual_bus.c                     | 326 ++++++++++++++++++
> >  include/linux/virtual_bus.h                   |  55 +++
> >  .../virtual_bus/virtual_bus_dev/Makefile      |   7 +
> >  .../virtual_bus_dev/virtual_bus_dev.c         |  67 ++++
> >  .../virtual_bus/virtual_bus_drv/Makefile      |   7 +
> >  .../virtual_bus_drv/virtual_bus_drv.c         | 101 ++++++
> >  9 files changed, 654 insertions(+)
> >  create mode 100644 Documentation/driver-api/virtual_bus.rst
> >  create mode 100644 drivers/bus/virtual_bus.c  create mode 100644
> > include/linux/virtual_bus.h  create mode 100644
> > tools/testing/selftests/virtual_bus/virtual_bus_dev/Makefile
> >  create mode 100644
> > tools/testing/selftests/virtual_bus/virtual_bus_dev/virtual_bus_dev.c
> >  create mode 100644
> > tools/testing/selftests/virtual_bus/virtual_bus_drv/Makefile
> >  create mode 100644
> > tools/testing/selftests/virtual_bus/virtual_bus_drv/virtual_bus_drv.c
> >
> > diff --git a/Documentation/driver-api/virtual_bus.rst
> > b/Documentation/driver-api/virtual_bus.rst
> > new file mode 100644
> > index 000000000000..970e06267284
> > --- /dev/null
> > +++ b/Documentation/driver-api/virtual_bus.rst
> > @@ -0,0 +1,76 @@
> > +===============================
> > +Virtual Bus Devices and Drivers
> > +===============================
> > +
> > +See <linux/virtual_bus.h> for the models for virtbus_device and
> virtbus_driver.
> > +This bus is meant to be a lightweight software based bus to attach
> > +generic devices and drivers to so that a chunk of data can be passed
> between them.
> > +
> > +One use case example is an rdma driver needing to connect with
> > +several different types of PCI LAN devices to be able to request
> > +resources from them (queue sets).  Each LAN driver that supports rdma
> > +will register a virtbus_device on the virtual bus for each physical
> > +function.  The rdma driver will register as a virtbus_driver on the
> > +virtual bus to be matched up with multiple virtbus_devices and
> > +receive a pointer to a struct containing the callbacks that the PCI
> > +LAN drivers support for registering with them.
> > +
> > +Sections in this document:
> > +        Virtbus devices
> > +        Virtbus drivers
> > +        Device Enumeration
> > +        Device naming and driver binding
> > +        Virtual Bus API entry points
> > +
> > +Virtbus devices
> > +~~~~~~~~~~~~~~~
> > +Virtbus_devices are lightweight objects that support the minimal
> > +device functionality.  Devices will accept a name, and then an
> > +automatically generated index is concatenated onto it for the
> virtbus_device->name.
> > +
> > +The memory backing the "void *data" element of the virtbus_device is
> > +expected to be allocated and freed outside the context of the bus
> > +operations.  This memory is also expected to remain viable for the
> > +duration of the time that the virtbus_device is registered to the
> > +virtual bus. (e.g. from before the virtbus_dev_register until after
> > +the paired virtbus_dev_unregister).
> > +
> > +The provided API for virtbus_dev_alloc is an efficient way of
> > +allocating the memory for the virtbus_device (except for the data
> > +element) and automatically freeing it when the device is removed from
> the bus.
> > +
> > +Virtbus drivers
> > +~~~~~~~~~~~~~~~
> > +Virtbus drivers register with the virtual bus to be matched with
> > +virtbus devices.  They expect to be registered with a probe and
> > +remove callback, and also support shutdown, suspend, and resume
> > +callbacks.  They otherwise follow the standard driver behavior of
> > +having discovery and enumeration handled in the bus infrastructure.
> > +
> > +Virtbus drivers register themselves with the API entry point
> > +virtbus_drv_reg and unregister with virtbus_drv_unreg.
> > +
> > +Device Enumeration
> > +~~~~~~~~~~~~~~~~~~
> > +Enumeration is handled automatically by the bus infrastructure via
> > +the ida_simple methods.
> > +
> > +Device naming and driver binding
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +The virtbus_device.dev.name is the canonical name for the device. It
> > +is built from two other parts:
> > +
> > +        - virtbus_device.name (also used for matching).
> > +        - virtbus_device.id (generated automatically from ida_simple
> > + calls)
> > +
> > +This allows for multiple virtbus_devices with the same name, which
> > +will all be matched to the same virtbus_driver. Driver binding is
> > +performed by the driver core, invoking driver probe() after finding a
> match between device and driver.
> > +
> > +Virtual Bus API entry points
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +struct virtbus_device *virtbus_dev_alloc(const char *name, void
> > +*data) int virtbus_dev_register(struct virtbus_device *vdev) void
> > +virtbus_dev_unregister(struct virtbus_device *vdev) int
> > +virtbus_drv_register(struct virtbus_driver *vdrv, struct module
> > +*owner) void virtbus_drv_unregister(struct virtbus_driver *vdrv)
> > diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig index
> > 6b331061d34b..30cef35b0c30 100644
> > --- a/drivers/bus/Kconfig
> > +++ b/drivers/bus/Kconfig
> > @@ -193,4 +193,18 @@ config DA8XX_MSTPRI
> >
> >  source "drivers/bus/fsl-mc/Kconfig"
> >
> > +config VIRTUAL_BUS
> > +       tristate "lightweight Virtual Bus"
> > +       depends on PM
> > +       help
> > +         Provides a lightweight bus for virtbus_devices to be added to it
> > +         and virtbus_drivers to be registered on it.  Will create a match
> > +         between the driver and device, then call the driver's probe with
> > +         the virtbus_device's struct (including a pointer for data).
> > +         One example is the irdma driver needing to connect with various
> > +         PCI LAN drivers to request resources (queues) to be able to perform
> > +         its function.  The data in the virtbus_device created by the
> > +         PCI LAN driver is a set of ops (function pointers) for the irdma
> > +         driver to use to register and communicate with the PCI LAN driver.
> > +
> >  endmenu
> > diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile index
> > 16b43d3468c6..0b0ba53cbe5b 100644
> > --- a/drivers/bus/Makefile
> > +++ b/drivers/bus/Makefile
> > @@ -33,3 +33,4 @@ obj-$(CONFIG_UNIPHIER_SYSTEM_BUS)	+=
> uniphier-system-bus.o
> >  obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o
> >
> >  obj-$(CONFIG_DA8XX_MSTPRI)	+= da8xx-mstpri.o
> > +obj-$(CONFIG_VIRTUAL_BUS)	+= virtual_bus.o
> > diff --git a/drivers/bus/virtual_bus.c b/drivers/bus/virtual_bus.c new
> > file mode 100644 index 000000000000..c6eab1658391
> > --- /dev/null
> > +++ b/drivers/bus/virtual_bus.c
> > @@ -0,0 +1,326 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * virtual_bus.c - lightweight software based bus for virtual devices
> > + *
> > + * Copyright (c) 2019-20 Intel Corporation
> > + *
> > + * Please see Documentation/driver-api/virtual_bus.rst for
> > + * more information
> > + */
> > +
> > +#include <linux/string.h>
> > +#include <linux/virtual_bus.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/pm_domain.h>
> > +#include <linux/acpi.h>
> > +#include <linux/device.h>
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_DESCRIPTION("Lightweight Virtual Bus");
> MODULE_AUTHOR("David
> > +Ertman <david.m.ertman@intel.com>"); MODULE_AUTHOR("Kiran Patil
> > +<kiran.patil@intel.com>");
> > +
> > +static DEFINE_IDA(virtbus_dev_ida);
> 
> Do you ever clean up this when unloaded?  I didn't see that happening but I
> might have missed it.

I have added a ida_destroy() call to the module exit function.  Good catch!

> 
> > +
> > +static const
> > +struct virtbus_dev_id *virtbus_match_id(const struct virtbus_dev_id *id,
> > +					struct virtbus_device *vdev)
> > +{
> > +	while (id->name[0]) {
> > +		if (!strcmp(vdev->name, id->name)) {
> > +			vdev->dev_id = id;
> 
> Why are you changing/setting the id?

This is not the main id of the device.  I chose a bad name for this field.

This is copying the pointer to the element out of the id_table that was matched
into the struct of the virtbus_device, so that when the virtbus_device struct is
passed as a parameter to the virtbus_driver's probe, the correct driver_data can
be accessed.

I will change the name of this field to "matched_element" and add a comment
as to what is going on here.

> 
> > +			return id;
> > +		}
> > +		id++;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +#define to_virtbus_dev(x)	(container_of((x), struct virtbus_device,
> dev))
> > +#define to_virtbus_drv(x)	(container_of((x), struct virtbus_driver, \
> > +				 driver))
> > +
> > +/**
> > + * virtbus_match - bind virtbus device to virtbus driver
> > + * @dev: device
> > + * @drv: driver
> > + *
> > + * Virtbus device IDs are always in "<name>.<instance>" format.
> > + * Instances are automatically selected through an ida_simple_get so
> > + * are positive integers. Names are taken from the device name field.
> > + * Driver IDs are simple <name>.  Need to extract the name from the
> > + * Virtual Device compare to name of the driver.
> > + */
> > +static int virtbus_match(struct device *dev, struct device_driver
> > +*drv) {
> > +	struct virtbus_driver *vdrv = to_virtbus_drv(drv);
> > +	struct virtbus_device *vdev = to_virtbus_dev(dev);
> > +
> > +	if (vdrv->id_table)
> > +		return virtbus_match_id(vdrv->id_table, vdev) != NULL;
> > +
> > +	return !strcmp(vdev->name, drv->name); }
> > +
> > +/**
> > + * virtbus_probe - call probe of the virtbus_drv
> > + * @dev: device struct
> > + */
> > +static int virtbus_probe(struct device *dev) {
> > +	if (dev->driver->probe)
> > +		return dev->driver->probe(dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static int virtbus_remove(struct device *dev) {
> > +	if (dev->driver->remove)
> > +		return dev->driver->remove(dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static void virtbus_shutdown(struct device *dev) {
> > +	if (dev->driver->shutdown)
> > +		dev->driver->shutdown(dev);
> > +}
> > +
> > +static int virtbus_suspend(struct device *dev, pm_message_t state) {
> > +	if (dev->driver->suspend)
> > +		return dev->driver->suspend(dev, state);
> > +
> > +	return 0;
> > +}
> > +
> > +static int virtbus_resume(struct device *dev) {
> > +	if (dev->driver->resume)
> > +		return dev->driver->resume(dev);
> > +
> > +	return 0;
> > +}
> > +
> > +struct bus_type virtual_bus_type = {
> > +	.name		= "virtbus",
> > +	.match		= virtbus_match,
> > +	.probe		= virtbus_probe,
> > +	.remove		= virtbus_remove,
> > +	.shutdown	= virtbus_shutdown,
> > +	.suspend	= virtbus_suspend,
> > +	.resume		= virtbus_resume,
> > +};
> > +
> > +/**
> > + * virtbus_dev_register - add a virtual bus device
> > + * @vdev: virtual bus device to add
> > + */
> > +int virtbus_dev_register(struct virtbus_device *vdev) {
> > +	int ret;
> > +
> > +	if (!vdev)
> > +		return -EINVAL;
> > +
> > +	device_initialize(&vdev->dev);
> > +
> > +	vdev->dev.bus = &virtual_bus_type;
> > +	/* All device IDs are automatically allocated */
> > +	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	vdev->id = ret;
> > +	dev_set_name(&vdev->dev, "%s.%d", vdev->name, vdev->id);
> > +
> > +	dev_dbg(&vdev->dev, "Registering VirtBus device '%s'\n",
> > +		dev_name(&vdev->dev));
> > +
> > +	ret = device_add(&vdev->dev);
> > +	if (!ret)
> > +		return ret;
> 
> This logic has tripped me up multiple times, it's an anti-pattern.
> Please do:
> 	if (ret)
> 		goto device_add_error;
> 
> 	return 0;
> 
> device_add_error:
> 	...
> 

Flow changed to match your example.

> > +
> > +	/* Error adding virtual device */
> > +	device_del(&vdev->dev);
> > +	ida_simple_remove(&virtbus_dev_ida, vdev->id);
> > +	vdev->id = VIRTBUS_DEVID_NONE;
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(virtbus_dev_register);
> > +
> > +/**
> > + * virtbus_dev_unregister - remove a virtual bus device
> > + * vdev: virtual bus device we are removing  */ void
> > +virtbus_dev_unregister(struct virtbus_device *vdev) {
> > +	if (!IS_ERR_OR_NULL(vdev)) {
> > +		device_del(&vdev->dev);
> > +
> > +		ida_simple_remove(&virtbus_dev_ida, vdev->id);
> > +		vdev->id = VIRTBUS_DEVID_NONE;
> 
> Why set the id?  What will care/check this?
> 

Removed, and removed the #define as well.  I had a thought on how I
was going to use this, but after further consideration, it didn't pan out
like I wanted.

> > +	}
> > +}
> > +EXPORT_SYMBOL_GPL(virtbus_dev_unregister);
> > +
> > +struct virtbus_object {
> > +	struct virtbus_device vdev;
> > +	char name[];
> > +};
> 
> Why not use the name in the device structure?
> 

I am implemting a change from Parav that will eliminate
the need for the entire virtbus_object.  So this name
field will be going away :)

> thanks,
> 
> greg k-h

-Dave E
