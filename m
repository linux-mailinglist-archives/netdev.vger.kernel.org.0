Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F873286EB5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 08:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgJHGcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 02:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgJHGcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 02:32:25 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB24C0613D2
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 23:32:24 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l24so4637548edj.8
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 23:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T6WCoZxdckvRKJGdL/C3+abKBroTkwq+Cv2M9Ea/Upw=;
        b=J4wJLz4nBMEzbf100ACCB/Bd6uCESFEe6h/ytp/fArQhp+PqEe6wDNBMpvMNG7tPm1
         8IlEZA152jqzUOs6tnpnlk9r5hco7RRH8D3Ys47wsFfBqr0vAGaDNpOcdp75K6zTdqUO
         btR7tlOjqlvspO/XktdBts7wPM3RD3JTzWTMNiBYXpck7KJ8h1FFQ9JBx8hhH999iEiZ
         Xou5bS/nlxSA6PeH3Q6IFmiNZ4Yu2ZTrgVuCE+7/rjIZyGork2J185AvO0JaKNF/L5nR
         0BFJ48dVKdHw+UF20XqPOYqKkwKoP/y6pTGI3uWQcL5BuVVbvl4tfwaK/ldWnnLsteDB
         akYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T6WCoZxdckvRKJGdL/C3+abKBroTkwq+Cv2M9Ea/Upw=;
        b=mdPXVnH9uThP1CMi/AhjUxUw2FdqJbdkU0LKexRZpbMYnB6xEIXctoD1X3mBuYNj2H
         i92hFVmZGMsl1K2s4bo55NxuIxL0mIIs5TCjjiXSZyP+BWFm9YSZQezR9xXcRx9F7ocb
         KZ9+oARu/RRY4lS4C7CSS62HCkIIVW1WAt5rTMHaPlpEflupzb4kTeIt/ef9bZtoBjxx
         xgvXwmUdWEfOIB+deGvMWJQP2yGewsT+UCa2npl5fzvPMKKoAgz5jYEqYA0g6QU+065v
         c/psdgitnBdqgwuW6c4ReDZ7KoxgFJXNWlepU1Od/x0pTZuOw372npJOZqB80az3sXuu
         PGyg==
X-Gm-Message-State: AOAM532sYoPCgl56PuruIA17ByhBTjL41BO+15u/eWoBK4+7S6k6xLyv
        80lpQjP02KxFzDdcggX/0KkkTuBhQlBuS9/mdI/Fnw==
X-Google-Smtp-Source: ABdhPJwgpM7H3h1DInduR4J71279wEVfVZ4kQCu4JvRNed2XMja6KyKSjQxlhH+H4bkYZVxCQ6SA/D1UOI3UnDXcONQ=
X-Received: by 2002:a50:9fa8:: with SMTP id c37mr7437375edf.233.1602138743085;
 Wed, 07 Oct 2020 23:32:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com> <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com> <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal> <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201008052137.GA13580@unreal>
In-Reply-To: <20201008052137.GA13580@unreal>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 7 Oct 2020 23:32:11 -0700
Message-ID: <CAPcyv4gz=mMTfLO4mAa34MEEXgg77o1AWrT6aguLYODAWxbQDQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 10:21 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Oct 07, 2020 at 08:46:45PM +0000, Ertman, David M wrote:
> > > -----Original Message-----
> > > From: Parav Pandit <parav@nvidia.com>
> > > Sent: Wednesday, October 7, 2020 1:17 PM
> > > To: Leon Romanovsky <leon@kernel.org>; Ertman, David M
> > > <david.m.ertman@intel.com>
> > > Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>; alsa-
> > > devel@alsa-project.org; parav@mellanox.com; tiwai@suse.de;
> > > netdev@vger.kernel.org; ranjani.sridharan@linux.intel.com;
> > > fred.oh@linux.intel.com; linux-rdma@vger.kernel.org;
> > > dledford@redhat.com; broonie@kernel.org; Jason Gunthorpe
> > > <jgg@nvidia.com>; gregkh@linuxfoundation.org; kuba@kernel.org; Williams,
> > > Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> > > <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> > > <kiran.patil@intel.com>
> > > Subject: RE: [PATCH v2 1/6] Add ancillary bus support
> > >
> > >
> > > > From: Leon Romanovsky <leon@kernel.org>
> > > > Sent: Thursday, October 8, 2020 12:56 AM
> > > >
> > > > > > This API is partially obscures low level driver-core code and needs
> > > > > > to provide clear and proper abstractions without need to remember
> > > > > > about put_device. There is already _add() interface why don't you do
> > > > > > put_device() in it?
> > > > > >
> > > > >
> > > > > The pushback Pierre is referring to was during our mid-tier internal
> > > > > review.  It was primarily a concern of Parav as I recall, so he can speak to
> > > his
> > > > reasoning.
> > > > >
> > > > > What we originally had was a single API call
> > > > > (ancillary_device_register) that started with a call to
> > > > > device_initialize(), and every error path out of the function performed a
> > > > put_device().
> > > > >
> > > > > Is this the model you have in mind?
> > > >
> > > > I don't like this flow:
> > > > ancillary_device_initialize()
> > > > if (ancillary_ancillary_device_add()) {
> > > >   put_device(....)
> > > >   ancillary_device_unregister()
> > > Calling device_unregister() is incorrect, because add() wasn't successful.
> > > Only put_device() or a wrapper ancillary_device_put() is necessary.
> > >
> > > >   return err;
> > > > }
> > > >
> > > > And prefer this flow:
> > > > ancillary_device_initialize()
> > > > if (ancillary_device_add()) {
> > > >   ancillary_device_unregister()
> > > This is incorrect and a clear deviation from the current core APIs that adds the
> > > confusion.
> > >
> > > >   return err;
> > > > }
> > > >
> > > > In this way, the ancillary users won't need to do non-intuitive put_device();
> > >
> > > Below is most simple, intuitive and matching with core APIs for name and
> > > design pattern wise.
> > > init()
> > > {
> > >     err = ancillary_device_initialize();
> > >     if (err)
> > >             return ret;
> > >
> > >     err = ancillary_device_add();
> > >     if (ret)
> > >             goto err_unwind;
> > >
> > >     err = some_foo();
> > >     if (err)
> > >             goto err_foo;
> > >     return 0;
> > >
> > > err_foo:
> > >     ancillary_device_del(adev);
> > > err_unwind:
> > >     ancillary_device_put(adev->dev);
> > >     return err;
> > > }
> > >
> > > cleanup()
> > > {
> > >     ancillary_device_de(adev);
> > >     ancillary_device_put(adev);
> > >     /* It is common to have a one wrapper for this as
> > > ancillary_device_unregister().
> > >      * This will match with core device_unregister() that has precise
> > > documentation.
> > >      * but given fact that init() code need proper error unwinding, like
> > > above,
> > >      * it make sense to have two APIs, and no need to export another
> > > symbol for unregister().
> > >      * This pattern is very easy to audit and code.
> > >      */
> > > }
> >
> > I like this flow +1
> >
> > But ... since the init() function is performing both device_init and
> > device_add - it should probably be called ancillary_device_register,
> > and we are back to a single exported API for both register and
> > unregister.
> >
> > At that point, do we need wrappers on the primitives init, add, del,
> > and put?
>
> Let me summarize.
> 1. You are not providing driver/core API but simplification and obfuscation
> of basic primitives and structures. This is new layer. There is no room for
> a claim that we must to follow internal API.

Yes, this a driver core api, Greg even questioned why it was in
drivers/bus instead of drivers/base which I think makes sense.

> 2. API should be symmetric. If you call to _register()/_add(), you will need
> to call to _unregister()/_del(). Please don't add obscure _put().

It's not obscure it's a long standing semantic for how to properly
handle device_add() failures. Especially in this case where there is
no way to have something like a common auxiliary_device_alloc() that
will work for everyone the only other option is require all device
destruction to go through the provided release method (put_device())
after a device_add() failure.

> 3. You can't "ask" from users to call internal calls (put_device) over internal
> fields in ancillary_device.

Sure it can. platform_device_add() requires a put_device() on failure,
but also note how platform_device_add() *requires*
platform_device_alloc() be used to create the device. That
inflexibility is something this auxiliary bus is trying to avoid.

> 4. This API should be clear to drivers authors, "device_add()" call (and
> semantic) is not used by the drivers (git grep " device_add(" drivers/).

This shows 141 instances for me, so I'm not sure what you're getting at?

Look, this api is meant to be a replacement for places where platform
devices were being abused. The device_initialize() + customize device
+ device_add() organization has the flexibility needed to let users
customize naming and other parts of device creation in a way that a
device_register() flow, or platform_device_{register,add} in
particular, did not.

If the concern is that you'd like to have an auxiliary_device_put()
for symmetry that would need to come with the same warning as
commented on platform_device_put(), i.e. that's it's really only
vanity symmetry to be used in error paths. The semantics of
device_add() and device_put() on failure are long established, don't
invent new behavior for auxiliary_device_add() and
auxiliary_device_put() / put_device().
