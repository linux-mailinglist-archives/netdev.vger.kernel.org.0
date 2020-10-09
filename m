Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AFF2891AC
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388609AbgJITW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388541AbgJITW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 15:22:56 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B364C0613D5
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 12:22:55 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id qp15so14683997ejb.3
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 12:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Etip+WdOg9WWZyxC9ekGwfWh8aAI6IBoMSdcjzYIQHo=;
        b=i3nkO0VO7rXIFqipfgGnmbMIthlTj+qlaXBfkHJOlE8jkFNU0C2a+bm/g7YKDw4+dx
         5KT3wwz4Lprnt8OIV4fGuPQPoNE31DjMvaQOccxvSEB2S5zeb7tIBOJs9yAIrnUmTFUI
         HLEM6UyDN8rgA4BO003+hWWFeCPscdnLZm7vez0omGjZfZTmQg4cdMdDz7MEW234nZ5d
         ZE5KFOVedvoAUBtDTyIcSOmtpP2CzeelB4tWgsUstjP6KAo0aDijBPHZR92j0LuWec6H
         Kz1550g2ZTti8VKmScoRmEImVdvP5AWSJ4lZBro68rdgHvk1j/uYE4LWBcRtIA1wli5X
         zqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Etip+WdOg9WWZyxC9ekGwfWh8aAI6IBoMSdcjzYIQHo=;
        b=qSwYJMFxZkIhM7IFbndJuqRaRCcn0PLKMJprwfHXQbsSF+JMw69TKVb2x3q1cGbtYG
         Y2848FPMFobDkwQHcOKD6E+xKjcrl+j4aKfT7/J9WUMBBbF5DBDZmz4T+cW8P8rbrajl
         ff59HjHw1LVO6tWuQG2H3cTvZrG+P8VHwsGQggFUrG1iqecMf1D8ngldq3HdLYs25aRR
         QZEimiIT5773Oa5Dww5ilGP8lG3aYhuFyTWWgInT9H7Cs/Kivwy0E1CAOPky+gub7lxU
         xMG9JBFjnXoBQCGkdpLUfZDKhh8JpIDZsCo6s+eJk+/V5a67Qm4IdJCwUhd11UCPVwrI
         B/sA==
X-Gm-Message-State: AOAM533kJ6Ne8z6wwNYqU5YC2avm0Ry+xllICmErx5lhdHoba0dBNn93
        88N6S4cDtLoAdkdwX3jjXe4uoTV3FfRCvnp3YjVLxQ==
X-Google-Smtp-Source: ABdhPJy3E7TeahGnh8WAxn4QJnBvewqJpkGSdodnb8948tFEGT1JBPJIMUc2qZew8w0MyFKMi3t/mx3WTUjOPaIS62Y=
X-Received: by 2002:a17:906:4306:: with SMTP id j6mr16565774ejm.523.1602271373050;
 Fri, 09 Oct 2020 12:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com> <20201006172317.GN1874917@unreal>
 <DM6PR11MB2841976B8E89C980CCC29AD2DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <CAPcyv4hoS7ZT_PPrXqFBzEHBKL-O4x1jHtY8x9WWesCPA=2E0g@mail.gmail.com> <7dbbc51c-2cbd-a7c5-69de-76f190f1d130@linux.intel.com>
In-Reply-To: <7dbbc51c-2cbd-a7c5-69de-76f190f1d130@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 9 Oct 2020 12:22:41 -0700
Message-ID: <CAPcyv4h24md531OYTVkHqzK7Nb0dJc5PHkLDSDywh8mYgrXBjg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 7:27 AM Pierre-Louis Bossart
<pierre-louis.bossart@linux.intel.com> wrote:
>
>
>
> >>>> +
> >>>> +   ancildrv->driver.owner = owner;
> >>>> +   ancildrv->driver.bus = &ancillary_bus_type;
> >>>> +   ancildrv->driver.probe = ancillary_probe_driver;
> >>>> +   ancildrv->driver.remove = ancillary_remove_driver;
> >>>> +   ancildrv->driver.shutdown = ancillary_shutdown_driver;
> >>>> +
> >>>
> >>> I think that this part is wrong, probe/remove/shutdown functions should
> >>> come from ancillary_bus_type.
> >>
> >>  From checking other usage cases, this is the model that is used for probe, remove,
> >> and shutdown in drivers.  Here is the example from Greybus.
> >>
> >> int greybus_register_driver(struct greybus_driver *driver, struct module *owner,
> >>                              const char *mod_name)
> >> {
> >>          int retval;
> >>
> >>          if (greybus_disabled())
> >>                  return -ENODEV;
> >>
> >>          driver->driver.bus = &greybus_bus_type;
> >>          driver->driver.name = driver->name;
> >>          driver->driver.probe = greybus_probe;
> >>          driver->driver.remove = greybus_remove;
> >>          driver->driver.owner = owner;
> >>          driver->driver.mod_name = mod_name;
> >>
> >>
> >>> You are overwriting private device_driver
> >>> callbacks that makes impossible to make container_of of ancillary_driver
> >>> to chain operations.
> >>>
> >>
> >> I am sorry, you lost me here.  you cannot perform container_of on the callbacks
> >> because they are pointers, but if you are referring to going from device_driver
> >> to the auxiliary_driver, that is what happens in auxiliary_probe_driver in the
> >> very beginning.
> >>
> >> static int auxiliary_probe_driver(struct device *dev)
> >> 145 {
> >> 146         struct auxiliary_driver *auxdrv = to_auxiliary_drv(dev->driver);
> >> 147         struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
> >>
> >> Did I miss your meaning?
> >
> > I think you're misunderstanding the cases when the
> > bus_type.{probe,remove} is used vs the driver.{probe,remove}
> > callbacks. The bus_type callbacks are to implement a pattern where the
> > 'probe' and 'remove' method are typed to the bus device type. For
> > example 'struct pci_dev *' instead of raw 'struct device *'. See this
> > conversion of dax bus as an example of going from raw 'struct device
> > *' typed probe/remove to dax-device typed probe/remove:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=75797273189d
>
> Thanks Dan for the reference, very useful. This doesn't look like a a
> big change to implement, just wondering about the benefits and
> drawbacks, if any? I am a bit confused here.
>
> First, was the initial pattern wrong as Leon asserted it? Such code
> exists in multiple examples in the kernel and there's nothing preventing
> the use of container_of that I can think of. Put differently, if this
> code was wrong then there are other existing buses that need to be updated.
>
> Second, what additional functionality does this move from driver to
> bus_type provide? The commit reference just states 'In preparation for
> introducing seed devices the dax-bus core needs to be able to intercept
> ->probe() and ->remove() operations", but that doesn't really help me
> figure out what 'intercept' means. Would you mind elaborating?
>
> And last, the existing probe function does calls dev_pm_domain_attach():
>
> static int ancillary_probe_driver(struct device *dev)
> {
>         struct ancillary_driver *ancildrv = to_ancillary_drv(dev->driver);
>         struct ancillary_device *ancildev = to_ancillary_dev(dev);
>         int ret;
>
>         ret = dev_pm_domain_attach(dev, true);
>
> So the need to access the raw device still exists. Is this still legit
> if the probe() is moved to the bus_type structure?

Sure, of course.

>
> I have no objection to this change if it preserves the same
> functionality and possibly extends it, just wanted to better understand
> the reasons for the change and in which cases the bus probe() makes more
> sense than a driver probe().
>
> Thanks for enlightening the rest of us!

tl;dr: The ops set by the device driver should never be overwritten by
the bus, the bus can only wrap them in its own ops.

The reason to use the bus_type is because the bus type is the only
agent that knows both how to convert a raw 'struct device *' to the
bus's native type, and how to convert a raw 'struct device_driver *'
to the bus's native driver type. The driver core does:

        if (dev->bus->probe) {
                ret = dev->bus->probe(dev);
        } else if (drv->probe) {
                ret = drv->probe(dev);
        }

...so that the bus has the first priority for probing a device /
wrapping the native driver ops. The bus ->probe, in addition to
optionally performing some bus specific pre-work, lets the bus upcast
the device to bus-native type.

The bus also knows the types of drivers that will be registered to it,
so the bus can upcast the dev->driver to the native type.

So with bus_type based driver ops driver authors can do:

struct auxiliary_device_driver auxdrv {
    .probe = fn(struct auxiliary_device *, <any aux bus custom probe arguments>)
};

auxiliary_driver_register(&auxdrv); <-- the core code can hide bus details

Without bus_type the driver author would need to do:

struct auxiliary_device_driver auxdrv {
    .drv = {
        .probe = fn(struct device *), <-- no opportunity for bus
specific probe args
        .bus = &auxilary_bus_type, <-- unnecessary export to device drivers
    },
};

driver_register(&auxdrv.drv)
