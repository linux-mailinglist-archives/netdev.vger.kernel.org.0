Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3073338AED
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 12:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhCLLD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 06:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbhCLLDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 06:03:53 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AADCC061761
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:03:53 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so10901033pjb.0
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b8dblWCmMen2mJ/vK+IaoikcPuuBlCMe+NK6ht5ox7k=;
        b=tcfU+QWwc7XHsA1jFZv7bSnCIHpjK6wp8KzeKwRV6kvEZTDxGzH7+iQjxJCHx0we9V
         LTaklK85yE3D6mLdhbhwFX76QmHMAcdt4J6SrZvjmQbAgpjGKBxeLnxd4Sk9kox0z8pw
         aMfm0bsU0Z7OAIofq1kcQq8YyoUlSDOjkJMx54v4wnyOqUr6i1ZQrkzRp+qTYK0+yIZF
         4QECs59E+Ph2XvrLL5rqe+umXOtfm78eUbcHFlLMZ+j8iA+RjVZnAUz8X/kE12kx9Trb
         KYdzjX3DZ5b73OcdQ+CHPGG5PfpnzEVcVV+1ZipwZ/6zJ+G/1lFImeoOCbygV0Ayc1OV
         XcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b8dblWCmMen2mJ/vK+IaoikcPuuBlCMe+NK6ht5ox7k=;
        b=B0aJU0g01pTFkspzj8oVQwWRJnL8hMcFf2lFJmrPeHqxCr0pMoRz5pWij/F6y/aeG7
         53trZMccQO5AcGZBoVm9+9Cj8AP9+5ML8piwyH5MGMwLucal7/4RHybVCczKBTWS7WMQ
         sOcdJOmx4dfAmYrZgcJ0sDVRgUeHLsMIl3rkIO33S2jEo1inkuIMmUtwmFE1Bcd+PHcg
         q0qx5geEoNNIPM/Xk7d9WYGD2yvpgdfsXIRTFzg5/3zY0FEpm5Rll32DLl5vyHdTbDg/
         U5cxOcZLAFSPi5wNwDddb9Grq3p0fz91M8GOllmBjWMDjyHEIHA4nM1ab4HhkexyX3UB
         varQ==
X-Gm-Message-State: AOAM532zdKBBLAfRyv9EX1wDy8YQPmbHxDEiXdpnzhSq4AFjbe+60eIp
        AJCoSS/L6qRbSBVSiAekoU595pTYXGWXacgWZi51IQ==
X-Google-Smtp-Source: ABdhPJyRZ55VpyITwBwJ9lR1xEN5J8TVjPt54vx1MBjT9CMjbCVGyAOFKvhpj2QqiLxFArDcRHcU1UU2XGkGlbfvhxc=
X-Received: by 2002:a17:902:7287:b029:e5:bd05:4a97 with SMTP id
 d7-20020a1709027287b02900e5bd054a97mr12795627pll.27.1615547031566; Fri, 12
 Mar 2021 03:03:51 -0800 (PST)
MIME-Version: 1.0
References: <1615495264-6816-1-git-send-email-loic.poulain@linaro.org> <YEsQobygYgKRQlgC@kroah.com>
In-Reply-To: <YEsQobygYgKRQlgC@kroah.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 12 Mar 2021 12:11:50 +0100
Message-ID: <CAMZdPi-EHirVg7k5XQ2hmZ5O0BT6dLh46crCv4EMwZTHDNC_tg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 1/2] net: Add a WWAN subsystem
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        open list <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Fri, 12 Mar 2021 at 07:56, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Mar 11, 2021 at 09:41:03PM +0100, Loic Poulain wrote:
> > This change introduces initial support for a WWAN subsystem. Given the
> > complexity and heterogeneity of existing WWAN hardwares and interfaces,
> > there is no strict definition of what a WWAN device is and how it should
> > be represented. It's often a collection of multiple components/devices
> > that perform the global WWAN feature (netdev, tty, chardev, etc).
> >
> > One usual way to expose modem controls and configuration is via high
> > level protocols such as the well known AT command protocol, MBIM or
> > QMI. The USB modems started to expose that as character devices, and
> > user daemons such as ModemManager learnt how to deal with that. This
> > initial version adds the concept of WWAN port, which can be registered
> > by any driver to expose one of these protocols. The WWAN core takes
> > care of the generic part, including character device creation and lets
> > the driver implementing access (fops) to the selected protocol.
> >
> > Since the different components/devices do no necesserarly know about
> > each others, and can be created/removed in different orders, the
> > WWAN core ensures that devices being part of the same hardware are
> > also represented as a unique WWAN device, relying on the provided
> > parent device (e.g. mhi controller, USB device). It's a 'trick' I
> > copied from Johannes's earlier WWAN subsystem proposal.
> >
> > This initial version is purposely minimalist, it's essentially moving
> > the generic part of the previously proposed mhi_wwan_ctrl driver inside
> > a common WWAN framework, but the implementation is open and flexible
> > enough to allow extension for further drivers.
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
[...]
> > +#include <linux/err.h>
> > +#include <linux/errno.h>
> > +#include <linux/init.h>
> > +#include <linux/fs.h>
> > +#include <linux/idr.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +#include <linux/wwan.h>
> > +
> > +#include "wwan_core.h"
> > +
> > +static LIST_HEAD(wwan_list); /* list of registered wwan devices */
>
> Why do you need a list as you already have a list of them all in the
> class structure?

Thanks, indeed, I can use class helpers for that.

>
> > +static DEFINE_IDA(wwan_ida);
> > +static DEFINE_MUTEX(wwan_global_lock);
>
> What is this lock for?  I don't think you need a lock for a ida/idr
> structure if you use it in the "simple" mode, right?
>
> > +struct class *wwan_class;
>
> Why is this a global structure?

It's also used inside wwan_port.c, but we can also retrieve the class
directly from wwandev->dev.class, so yes it's not strictly necessary
to have it global.

>
> > +
> > +static struct wwan_device *__wwan_find_by_parent(struct device *parent)
> > +{
> > +     struct wwan_device *wwandev;
> > +
> > +     if (!parent)
> > +             return NULL;
> > +
> > +     list_for_each_entry(wwandev, &wwan_list, list) {
> > +             if (wwandev->dev.parent == parent)
> > +                     return wwandev;
>
> Nice, no locking!
>
> :(
>
> Again, why not use the driver core bits for this?
>
> Also, no reference counting is used here, sure way to cause problems :(
>
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +static void wwan_dev_release(struct device *dev)
> > +{
> > +     struct wwan_device *wwandev = to_wwan_dev(dev);
> > +
> > +     kfree(wwandev);
> > +}
> > +
> > +static const struct device_type wwan_type = {
> > +     .name    = "wwan",
> > +     .release = wwan_dev_release,
> > +};
> > +
> > +struct wwan_device *wwan_create_dev(struct device *parent)
> > +{
> > +     struct wwan_device *wwandev;
> > +     int err, id;
> > +
> > +     mutex_lock(&wwan_global_lock);
> > +
> > +     wwandev = __wwan_find_by_parent(parent);
> > +     if (wwandev) {
> > +             get_device(&wwandev->dev);
>
> Ah, you lock outside of the function, and increment the reference count,
> that's a sure way to cause auditing problems over time.  Don't do that,
> you know better.

Ok, that makes sense.

>
> > +             wwandev->usage++;
>
> Hah, why?  You now have 2 reference counts for the same structure?

'usage' is probably not the right term, but this counter tracks device
registration life to determine when the device must be unregistered
from the system (several wwan drivers can be exposed as a unique wwan
device), while device kref tracks the wwan device life. They are kind
of coupled, but a device can not be released if not priorly
unregistered.

>
> > +             goto done_unlock;
> > +     }
> > +
> > +     id = ida_alloc(&wwan_ida, GFP_KERNEL);
>
> Again, I do not think you need a lock if you use this structure in a
> safe way.
>
> > +     if (id < 0)
> > +             goto done_unlock;
> > +
> > +     wwandev = kzalloc(sizeof(*wwandev), GFP_KERNEL);
> > +     if (!wwandev) {
> > +             ida_free(&wwan_ida, id);
> > +             goto done_unlock;
> > +     }
> > +
> > +     wwandev->dev.parent = parent;
> > +     wwandev->dev.class = wwan_class;
> > +     wwandev->dev.type = &wwan_type;
> > +     wwandev->id = id;
> > +     dev_set_name(&wwandev->dev, "wwan%d", wwandev->id);
> > +     wwandev->usage = 1;
> > +     INIT_LIST_HEAD(&wwandev->ports);
> > +
> > +     err = device_register(&wwandev->dev);
> > +     if (err) {
> > +             put_device(&wwandev->dev);
> > +             ida_free(&wwan_ida, id);
> > +             wwandev = NULL;
> > +             goto done_unlock;
> > +     }
> > +
> > +     list_add_tail(&wwandev->list, &wwan_list);
> > +
> > +done_unlock:
> > +     mutex_unlock(&wwan_global_lock);
> > +
> > +     return wwandev;
> > +}
> > +EXPORT_SYMBOL_GPL(wwan_create_dev);
> > +
> > +void wwan_destroy_dev(struct wwan_device *wwandev)
> > +{
> > +     mutex_lock(&wwan_global_lock);
> > +     wwandev->usage--;
>
> Nice, 2 references!  :(
>
> > +
> > +     if (wwandev->usage)
> > +             goto done_unlock;
>
> No, you don't need this.
>
> > +
> > +     /* Someone destroyed the wwan device without removing ports */
> > +     WARN_ON(!list_empty(&wwandev->ports));
>
> why?
>
> Did you just reboot a system?
>
> > +
> > +     list_del(&wwandev->list);
> > +     device_unregister(&wwandev->dev);
> > +     ida_free(&wwan_ida, wwandev->id);
> > +     put_device(&wwandev->dev);
> > +
> > +done_unlock:
> > +     mutex_unlock(&wwan_global_lock);
> > +}
> > +EXPORT_SYMBOL_GPL(wwan_destroy_dev);
> > +
> > +static int __init wwan_init(void)
> > +{
> > +     int err;
> > +
> > +     wwan_class = class_create(THIS_MODULE, "wwan");
> > +     if (IS_ERR(wwan_class))
> > +             return PTR_ERR(wwan_class);
> > +
> > +     err = wwan_port_init();
> > +     if (err)
> > +             goto err_class_destroy;
> > +
> > +     return 0;
> > +
> > +err_class_destroy:
> > +     class_destroy(wwan_class);
> > +     return err;
> > +}
> > +
> > +static void __exit wwan_exit(void)
> > +{
> > +     wwan_port_deinit();
> > +     class_destroy(wwan_class);
> > +}
> > +
> > +//subsys_initcall(wwan_init);
>
> ???
>
> Debugging code left around?
>
> > +module_init(wwan_init);
> > +module_exit(wwan_exit);
> > +
> > +MODULE_AUTHOR("Loic Poulain <loic.poulain@linaro.org>");
> > +MODULE_DESCRIPTION("WWAN core");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/net/wwan/wwan_core.h b/drivers/net/wwan/wwan_core.h
> > new file mode 100644
> > index 0000000..21d187a
> > --- /dev/null
> > +++ b/drivers/net/wwan/wwan_core.h
> > @@ -0,0 +1,20 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
> > +
> > +#ifndef __WWAN_CORE_H
> > +#define __WWAN_CORE_H
> > +
> > +#include <linux/device.h>
> > +#include <linux/wwan.h>
> > +
> > +#define to_wwan_dev(d) container_of(d, struct wwan_device, dev)
> > +
> > +struct wwan_device *wwan_create_dev(struct device *parent);
> > +void wwan_destroy_dev(struct wwan_device *wwandev);
> > +
> > +int wwan_port_init(void);
> > +void wwan_port_deinit(void);
> > +
> > +extern struct class *wwan_class;
> > +
> > +#endif /* WWAN_CORE_H */
> > diff --git a/drivers/net/wwan/wwan_port.c b/drivers/net/wwan/wwan_port.c
> > new file mode 100644
> > index 0000000..b32da8f
> > --- /dev/null
> > +++ b/drivers/net/wwan/wwan_port.c
> > @@ -0,0 +1,136 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
> > +
> > +#include <linux/err.h>
> > +#include <linux/errno.h>
> > +#include <linux/fs.h>
> > +#include <linux/idr.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/wwan.h>
> > +
> > +#include "wwan_core.h"
> > +
> > +#define WWAN_MAX_MINORS 32
>
> Why only 32?

It's an arbitrary value, 32 wwan ports seem enough.

>
> > +
> > +static int wwan_major;
> > +static DEFINE_IDR(wwan_port_idr);
> > +static DEFINE_MUTEX(wwan_port_idr_lock);
>
> More idrs?

These idrs are used for getting wwan_port minors (more below).

> > +
> > +static const char * const wwan_port_type_str[] = {
> > +     "AT",
> > +     "MBIM",
> > +     "QMI",
> > +     "QCDM",
> > +     "FIREHOSE"
> > +};
[...]
> > +static int wwan_port_open(struct inode *inode, struct file *file)
> > +{
> > +     const struct file_operations *new_fops;
> > +     unsigned int minor = iminor(inode);
> > +     struct wwan_port *port;
> > +     int err = 0;
> > +
> > +     mutex_lock(&wwan_port_idr_lock);
> > +     port = idr_find(&wwan_port_idr, minor);
> > +     if (!port) {
> > +             mutex_unlock(&wwan_port_idr_lock);
> > +             return -ENODEV;
> > +     }
> > +     mutex_unlock(&wwan_port_idr_lock);
> > +
> > +     file->private_data = port->private_data ? port->private_data : port;
> > +     stream_open(inode, file);
> > +
> > +     new_fops = fops_get(port->fops);
> > +     replace_fops(file, new_fops);
>
> Why replace the fops?

WWAN port behaves a bit like the misc framework here, allowing a wwan
driver to register its own file ops. When the user opens a wwan cdev
port, we simply switch from generic wwan no-op to the specific
driver's registered fops. The sound subsystem also does that
(snd_open). Another way would be to define generic wwan file
operations in the core, and forward them to a set of wwan port ops
(e.g. wwan_port->ops.read), but I don't think it brings too much
benefit for now.

>
> > +     if (file->f_op->open)
> > +             err = file->f_op->open(inode, file);
> > +
> > +     return err;
> > +}
> > +
> > +static const struct file_operations wwan_port_fops = {
> > +     .owner  = THIS_MODULE,
> > +     .open   = wwan_port_open,
> > +     .llseek = noop_llseek,
> > +};
> > +
> > +int wwan_port_init(void)
> > +{
> > +     wwan_major = register_chrdev(0, "wwanport", &wwan_port_fops);
> > +     if (wwan_major < 0)
> > +             return wwan_major;
> > +
> > +     return 0;
> > +}
> > +
> > +void wwan_port_deinit(void)
> > +{
> > +     unregister_chrdev(wwan_major, "wwanport");
> > +     idr_destroy(&wwan_port_idr);
> > +}
>
>
> I'm confused, you have 1 class, but 2 different major numbers for this
> class?  You have a device and ports with different numbers, how are they
> all tied together?

There is one wwan class with different device types (wwan devices and
wwan control ports), a port is a child of a wwan device. Only wwan
ports are exposed as character devices and IDR is used for getting a
minor. wwan device IDA is just used to alloc unique wwan device ID.

> > diff --git a/include/linux/wwan.h b/include/linux/wwan.h
> > new file mode 100644
> > index 0000000..6caca5c
> > --- /dev/null
> > +++ b/include/linux/wwan.h
> > @@ -0,0 +1,121 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
> > +
> > +#ifndef __WWAN_H
> > +#define __WWAN_H
> > +
> > +#include <linux/device.h>
> > +#include <linux/kernel.h>
> > +
> > +/**
> > + * struct wwan_device - The structure that defines a WWAN device
> > + *
> > + * @id:              WWAN device unique ID.
> > + * @usage:   WWAN device usage counter.
> > + * @dev:     underlying device.
> > + * @list:    list to chain WWAN devices.
> > + * @ports:   list of attached wwan_port.
> > + * @port_idx:        port index counter.
> > + * @lock:    mutex protecting members of this structure.
> > + */
> > +struct wwan_device {
> > +     int id;
> > +     unsigned int usage;
>
> Again, not needed.
>
> > +
> > +     struct device dev;
> > +     struct list_head list;
>
> You should use the list in the class instead.

Will do.

>
> > +
> > +     struct list_head ports;
>
> Are you sure you need this?

No, indeed, I can just rely on the wwan device child list.

>
> > +     unsigned int port_idx;
> > +
> > +     struct mutex lock;
> > +};
> > +
> > +/**
> > + * enum wwan_port_type - WWAN port types
> > + * @WWAN_PORT_AT:    AT commands.
> > + * @WWAN_PORT_MBIM:  Mobile Broadband Interface Model control.
> > + * @WWAN_PORT_QMI:   Qcom modem/MSM interface for modem control.
> > + * @WWAN_PORT_QCDM:  Qcom Modem diagnostic interface.
> > + * @WWAN_PORT_FIREHOSE: XML based command protocol.
> > + * @WWAN_PORT_MAX
> > + */
> > +enum wwan_port_type {
> > +     WWAN_PORT_AT,
> > +     WWAN_PORT_MBIM,
> > +     WWAN_PORT_QMI,
> > +     WWAN_PORT_QCDM,
> > +     WWAN_PORT_FIREHOSE,
> > +     WWAN_PORT_MAX,
> > +};
> > +
> > +/**
> > + * struct wwan_port - The structure that defines a WWAN port
> > + *
> > + * @wwandev:         WWAN device this port belongs to.
> > + * @fops:            Port file operations.
> > + * @private_data:    underlying device.
> > + * @type:            port type.
> > + * @id:                      port allocated ID.
> > + * @minor:           port allocated minor ID for cdev.
> > + * @list:            list to chain WWAN ports.
> > + */
> > +struct wwan_port {
> > +     struct wwan_device *wwandev;
> > +     const struct file_operations *fops;
> > +     void *private_data;
> > +     enum wwan_port_type type;
> > +
> > +     /* private */
> > +     unsigned int id;
> > +     int minor;
> > +     struct list_head list;
>
> So a port is not a device?  Why not?

A port is represented as a device, device_create is called when port
is attached to wwan core, but it indeed would make more sense to
simply make wwan_port a device.

Thanks,
Loic
