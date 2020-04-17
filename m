Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DFA1AE645
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730847AbgDQTvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730623AbgDQTvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 15:51:52 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2D2C061A0F
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 12:51:52 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c63so3783517qke.2
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 12:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QsboIvVURmTR0BmfWCJJmXeAuxXxNIQbnqjQgwzXdnE=;
        b=mv0hcJ5kSi1M98Z9J9fiXiPK8mqVwtqLV7T6qP6PpvVqvG0auCKwADAERzxxPOK55B
         pyuYtQT7nrtXRdGs+6b0Ffn3Rc1Rav+/8rbvdAzpJxT+Kq+ttX/pf1668Rrr0YyW6F5q
         BXT7gO2SxyjzDYw7gUOtew8TToZKbHXCIJAYwXUUGgjc8eXzjaFRLj2iKjc/AFhxDNfQ
         AkAsubrmfOP71Zr/SCcDISCdpnZkZT01b8vYSnPyxuLRQjyJ0vHimkC68iB4rKyAsplw
         EEFT+g3+7J1MiezqTdTyQNxL/LllYAk2a8INPDto9DjoAU5p7qdEimvDN83IpNV8UFWj
         pSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QsboIvVURmTR0BmfWCJJmXeAuxXxNIQbnqjQgwzXdnE=;
        b=r2QsFdmHvAVnsfqKsf78v5P74HIFryZqd/mzpZO0n8k6JYUq5WkUUN0fHvFWGUSJw5
         yGspu/vPYl1yopoN5pZZUlSPSIAvaIpU+o/4kBNTczEr6qNUN0MVyjeeWZeX0mUIc8xV
         /pKaFHYbMUcHgrIHrfJuqTO1a3gQxHj8YFlGUdqQGuoWk5G5VeWw1LdbHOzS/ZtRV8p1
         9cOcaFvtvltQikA2zEnZk2SvBbXZe77eIIQFkG9i7kxMvMIZHc5UdDWrPKy4UXGGNzXI
         pxTQ9OXvbpqah2nU9vkQZWJlNjKCkYo6Zlk9J26zK6AbsJ9PAXx28BYmaie/ruGWQ0X+
         rRtA==
X-Gm-Message-State: AGi0PuanTeaQHsEpqh94vzypTRQ+SSof9XJwGePvEbbYzZMKmlP8gXU8
        0gWJwBXbenxMFMOTPLT60cqNIA==
X-Google-Smtp-Source: APiQypIIQhp+HWn/39vv2Q3PIGScU5HMZ8KSz1/6e0Sw9Roo8GntuhglAFFciKtHtz/g0C/jc+eEqA==
X-Received: by 2002:a37:5c44:: with SMTP id q65mr5137552qkb.454.1587153111237;
        Fri, 17 Apr 2020 12:51:51 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id v37sm1799562qtc.7.2020.04.17.12.51.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 Apr 2020 12:51:49 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jPX1h-00054l-09; Fri, 17 Apr 2020 16:51:49 -0300
Date:   Fri, 17 Apr 2020 16:51:48 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, parav@mellanox.com, galpress@amazon.com,
        selvin.xavier@broadcom.com, sriharsha.basavapatna@broadcom.com,
        benve@cisco.com, bharat@chelsio.com, xavier.huwei@huawei.com,
        yishaih@mellanox.com, leonro@mellanox.com, mkalderon@marvell.com,
        aditr@vmware.com, ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/9] Implementation of Virtual Bus
Message-ID: <20200417195148.GL26002@ziepe.ca>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
 <20200417171034.1533253-2-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417171034.1533253-2-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:10:26AM -0700, Jeff Kirsher wrote:

> +/**
> + * virtbus_release_device - Destroy a virtbus device
> + * @_dev: device to release
> + */
> +static void virtbus_release_device(struct device *_dev)
> +{
> +	struct virtbus_device *vdev = to_virtbus_dev(_dev);
> +
> +	ida_simple_remove(&virtbus_dev_ida, vdev->id);
> +	vdev->release(vdev);

This order should probably be swapped (store vdev->id on the stack)

> +/**
> + * virtbus_register_device - add a virtual bus device
> + * @vdev: virtual bus device to add
> + */
> +int virtbus_register_device(struct virtbus_device *vdev)
> +{
> +	int ret;
> +
> +	/* Do this first so that all error paths perform a put_device */
> +	device_initialize(&vdev->dev);
> +
> +	if (!vdev->release) {
> +		ret = -EINVAL;
> +		dev_err(&vdev->dev, "virtbus_device MUST have a .release callback that does something.\n");
> +		goto device_pre_err;

This does put_device but the release() hasn't been set yet. Doesn't it
leak memory?

> +	}
> +
> +	/* All device IDs are automatically allocated */
> +	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> +	if (ret < 0) {
> +		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
> +		goto device_pre_err;

Do this before device_initialize()

> +	}
> +
> +
> +	vdev->dev.bus = &virtual_bus_type;
> +	vdev->dev.release = virtbus_release_device;

And this immediately after

> +
> +	vdev->id = ret;
> +	dev_set_name(&vdev->dev, "%s.%d", vdev->name, vdev->id);

Missing check of return code

Can't understand why vdev->name is being passed in with the struct,
why not just a function argument?

> +	dev_dbg(&vdev->dev, "Registering virtbus device '%s'\n",
> +		dev_name(&vdev->dev));
> +
> +	ret = device_add(&vdev->dev);
> +	if (ret)
> +		goto device_add_err;

This looks like it does ida_simple_remove twice, once in the goto and
once from the release function called by put_device.

> +/**
> + * virtbus_unregister_device - remove a virtual bus device
> + * @vdev: virtual bus device we are removing
> + */
> +void virtbus_unregister_device(struct virtbus_device *vdev)
> +{
> +	device_del(&vdev->dev);
> +	put_device(&vdev->dev);
> +}
> +EXPORT_SYMBOL_GPL(virtbus_unregister_device);

Just inline this as wrapper around device_unregister

> +/**
> + * __virtbus_register_driver - register a driver for virtual bus devices
> + * @vdrv: virtbus_driver structure
> + * @owner: owning module/driver
> + */
> +int __virtbus_register_driver(struct virtbus_driver *vdrv, struct module *owner)
> +{
> +	if (!vdrv->probe || !vdrv->remove || !vdrv->shutdown || !vdrv->id_table)
> +		return -EINVAL;
> +
> +	vdrv->driver.owner = owner;
> +	vdrv->driver.bus = &virtual_bus_type;
> +	vdrv->driver.probe = virtbus_probe_driver;
> +	vdrv->driver.remove = virtbus_remove_driver;
> +	vdrv->driver.shutdown = virtbus_shutdown_driver;
> +	vdrv->driver.suspend = virtbus_suspend_driver;
> +	vdrv->driver.resume = virtbus_resume_driver;
> +
> +	return driver_register(&vdrv->driver);
> +}
> +EXPORT_SYMBOL_GPL(__virtbus_register_driver);
> +
> +/**
> + * virtbus_unregister_driver - unregister a driver for virtual bus devices
> + * @vdrv: virtbus_driver structure
> + */
> +void virtbus_unregister_driver(struct virtbus_driver *vdrv)
> +{
> +	driver_unregister(&vdrv->driver);
> +}
> +EXPORT_SYMBOL_GPL(virtbus_unregister_driver);

Also just inline this

> diff --git a/include/linux/virtual_bus.h b/include/linux/virtual_bus.h
> new file mode 100644
> index 000000000000..4df06178e72f
> +++ b/include/linux/virtual_bus.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * virtual_bus.h - lightweight software bus
> + *
> + * Copyright (c) 2019-20 Intel Corporation
> + *
> + * Please see Documentation/driver-api/virtual_bus.rst for more information
> + */
> +
> +#ifndef _VIRTUAL_BUS_H_
> +#define _VIRTUAL_BUS_H_
> +
> +#include <linux/device.h>
> +
> +struct virtbus_device {
> +	struct device dev;
> +	const char *name;
> +	void (*release)(struct virtbus_device *);
> +	int id;

id can't be negative

> +int virtbus_register_device(struct virtbus_device *vdev);
> +void virtbus_unregister_device(struct virtbus_device *vdev);

I continue to think the alloc/register pattern, eg as demonstrated by
vdpa_alloc_device() and vdpa_register_device() is easier for drivers
to implement correctly.

> +int
> +__virtbus_register_driver(struct virtbus_driver *vdrv, struct module *owner);
> +void virtbus_unregister_driver(struct virtbus_driver *vdrv);
> +
> +#define virtbus_register_driver(vdrv) \
> +	__virtbus_register_driver(vdrv, THIS_MODULE)
> +

It is reasonable to also provide a module_driver() macro.

Jason
