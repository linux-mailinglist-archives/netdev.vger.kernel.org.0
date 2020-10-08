Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C43287EC3
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 00:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbgJHWlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 18:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgJHWle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 18:41:34 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441E8C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 15:41:34 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x7so210588eje.8
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 15:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WKAAq4D39s8StG/M1lO07+d0CiCysI9oSAC/9fh4N/g=;
        b=y0e6dbaEHBOEaWBMLIsBwYXUrCmlIkVZjzL674Ojaz3MoNegh7jFicauDQc7uBzpmV
         I8yR3KOjLE9xrw+FQgK0qsWXwBXab8/hiy0NJqBkldVk/7XjIM1+v4qGGG+xtHxNVUb8
         crL5loR9gnnIkU1SFWJPBsRrF7Kp4uEsLLC/Mby2tx47G9iLQJERgds1HG9c2nbm3WHp
         vABJiB/JlPYSjmkLQ98xiY4tHPb3+htluy89bDn32BMR9eaxVeghDrvlGCI+GnSmNopp
         ez5qNI+eYRxA7+EXip3YNmdPasWUqPYcfMJ7oJE3r4lJ8nzmaelpH7HOajw6gPobWE0C
         daig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WKAAq4D39s8StG/M1lO07+d0CiCysI9oSAC/9fh4N/g=;
        b=fRgr6CT9OOFzMVBVcEun90YQxs+rLg3ZREMftlqzSoid9K4TfRK+LN6mypkl1j1mft
         w21kLYcjuB9NAR2wNJTJXSHKkuH/n05skQIGqz4pGylFiUfjiPnyW4NDmTPtFMBf+beZ
         9P1AQeKwyFA1r0Ra7m237d5vLp7v7j8kTZaD2ldBGrxkNO1cHHnf1ScSpvOG1UgcpYSX
         Cu3AGaQrDtqY9nFP2XG33JV4D647//l8JY/yH2qXszh3YzIQGo+UBPMbRIul/P8//Cd0
         ZPjxj6M9h2vE68Dp33APkJU7MNwqmjPVKKM/FgrqMu89AOyqSiGRn+mOqQd/OC1y0zEd
         gI4g==
X-Gm-Message-State: AOAM530y/Z2OUfsaLsXsYLp60Wqm0MbjfzJ8uwSd6RtfjEHC+AYwNkP+
        Jqd9kUBjT4TKu6MsDEjpVXqyZ+zkiIYRPnPn9QQzgg==
X-Google-Smtp-Source: ABdhPJzn83obXIaxacWoR+1oBmm3WlzAU5EGjnIfldcPJdG8BK/orzWfCwt859OcsJxummItwWCyBowjIZCEM2ZM9Ow=
X-Received: by 2002:a17:906:4306:: with SMTP id j6mr11588545ejm.523.1602196892931;
 Thu, 08 Oct 2020 15:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com> <20201006172317.GN1874917@unreal>
 <DM6PR11MB2841976B8E89C980CCC29AD2DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB2841976B8E89C980CCC29AD2DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 8 Oct 2020 15:41:21 -0700
Message-ID: <CAPcyv4hoS7ZT_PPrXqFBzEHBKL-O4x1jHtY8x9WWesCPA=2E0g@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 3:04 PM Ertman, David M <david.m.ertman@intel.com> wrote:
>
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, October 6, 2020 10:23 AM
> > To: Ertman, David M <david.m.ertman@intel.com>
> > Cc: alsa-devel@alsa-project.org; tiwai@suse.de; broonie@kernel.org; linux-
> > rdma@vger.kernel.org; jgg@nvidia.com; dledford@redhat.com;
> > netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org;
> > gregkh@linuxfoundation.org; ranjani.sridharan@linux.intel.com; pierre-
> > louis.bossart@linux.intel.com; fred.oh@linux.intel.com;
> > parav@mellanox.com; Saleem, Shiraz <shiraz.saleem@intel.com>; Williams,
> > Dan J <dan.j.williams@intel.com>; Patil, Kiran <kiran.patil@intel.com>
> > Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> >
> > On Mon, Oct 05, 2020 at 11:24:41AM -0700, Dave Ertman wrote:
> > > Add support for the Ancillary Bus, ancillary_device and ancillary_driver.
> > > It enables drivers to create an ancillary_device and bind an
> > > ancillary_driver to it.
> > >
> > > The bus supports probe/remove shutdown and suspend/resume callbacks.
> > > Each ancillary_device has a unique string based id; driver binds to
> > > an ancillary_device based on this id through the bus.
> > >
> > > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > > Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > > Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > > ---
> >
> > <...>
> >
> > > +/**
> > > + * __ancillary_driver_register - register a driver for ancillary bus devices
> > > + * @ancildrv: ancillary_driver structure
> > > + * @owner: owning module/driver
> > > + */
> > > +int __ancillary_driver_register(struct ancillary_driver *ancildrv, struct
> > module *owner)
> > > +{
> > > +   if (WARN_ON(!ancildrv->probe) || WARN_ON(!ancildrv->remove)
> > ||
> > > +       WARN_ON(!ancildrv->shutdown) || WARN_ON(!ancildrv-
> > >id_table))
> > > +           return -EINVAL;
> >
> > In our driver ->shutdown is empty, it will be best if ancillary bus will
> > do "if (->remove) ..->remove()" pattern.
> >
>
> Yes, looking it over, only the probe needs to mandatory.  I will change the others to the
> conditional model, and adjust the WARN_ONs.
>
>
> > > +
> > > +   ancildrv->driver.owner = owner;
> > > +   ancildrv->driver.bus = &ancillary_bus_type;
> > > +   ancildrv->driver.probe = ancillary_probe_driver;
> > > +   ancildrv->driver.remove = ancillary_remove_driver;
> > > +   ancildrv->driver.shutdown = ancillary_shutdown_driver;
> > > +
> >
> > I think that this part is wrong, probe/remove/shutdown functions should
> > come from ancillary_bus_type.
>
> From checking other usage cases, this is the model that is used for probe, remove,
> and shutdown in drivers.  Here is the example from Greybus.
>
> int greybus_register_driver(struct greybus_driver *driver, struct module *owner,
>                             const char *mod_name)
> {
>         int retval;
>
>         if (greybus_disabled())
>                 return -ENODEV;
>
>         driver->driver.bus = &greybus_bus_type;
>         driver->driver.name = driver->name;
>         driver->driver.probe = greybus_probe;
>         driver->driver.remove = greybus_remove;
>         driver->driver.owner = owner;
>         driver->driver.mod_name = mod_name;
>
>
> > You are overwriting private device_driver
> > callbacks that makes impossible to make container_of of ancillary_driver
> > to chain operations.
> >
>
> I am sorry, you lost me here.  you cannot perform container_of on the callbacks
> because they are pointers, but if you are referring to going from device_driver
> to the auxiliary_driver, that is what happens in auxiliary_probe_driver in the
> very beginning.
>
> static int auxiliary_probe_driver(struct device *dev)
> 145 {
> 146         struct auxiliary_driver *auxdrv = to_auxiliary_drv(dev->driver);
> 147         struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
>
> Did I miss your meaning?

I think you're misunderstanding the cases when the
bus_type.{probe,remove} is used vs the driver.{probe,remove}
callbacks. The bus_type callbacks are to implement a pattern where the
'probe' and 'remove' method are typed to the bus device type. For
example 'struct pci_dev *' instead of raw 'struct device *'. See this
conversion of dax bus as an example of going from raw 'struct device
*' typed probe/remove to dax-device typed probe/remove:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=75797273189d
