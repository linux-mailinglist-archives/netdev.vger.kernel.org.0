Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5012EA3CB
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 04:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbhAEDNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 22:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbhAEDNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 22:13:36 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D087C061793
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 19:12:55 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id b9so39517386ejy.0
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 19:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yvoSzg344dN/N+DqfiYgrY7pc/I34P5dAbpEpkhBIJI=;
        b=rQJxNXH+GsHO6zvvAN5QlpD7RI9zvbxjhJhWT5bkV5oIVVbWJZULG+2WWV/lEPCGPb
         5LE9xwHUQp0sZ1hLMQf29jNLuIQZzVSzp8+Us0QEWtzd8y1GcaQ94MRaxCxsNS9qwF8U
         arYIf7Qri4YXmEU4dAVC5ouH+3+/w53ZK0cRc2Zgz5k5cI89Vmc2Bwn1F4cqsfRs7nHN
         ACSKhEPrnZS9J6vx+5lKjYWXuQ1gG6FXAXPsdtyEqEvKfkAacpVqZ1MHVWBPbOXHi7Zv
         an26E0lvekKWUDEGvpluK3itPhuYNM9RJIs9AkkkeMyy7TOAKGTfbWMrOsacHHDv4UP5
         FGXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yvoSzg344dN/N+DqfiYgrY7pc/I34P5dAbpEpkhBIJI=;
        b=U0UnVqrei7DqTHbgKxqXXsvrvAKsmanxOh7d/mGAfZrhgihJp3zMiFDvGUxKLSfslM
         PkO4sTeGXtJJeB5ohT1/zbUABWZrt2ALEiSRR9tfX2rlgbeDtPyFvMq13N+R4lyGo1Vk
         ozrAVKt/IpyJdRuJOUsAeBUJ9uaikg7HuuzbhFZ602VB37pA6pp4spZ3Ad8FllgIXvZe
         7MznAMJlsL4s35myPGpvYu5zP0Z5R2bYK9BaK6WqRC5hYi5L/V31CatpgHxGFIkiDMZV
         wPjtBNfCz8Di3HQrIMKdjsbWHbuGOlWzoCbgVrg7rnNWwrSPf9g0S2/SsdEA03TvOkeJ
         Ywcw==
X-Gm-Message-State: AOAM532IGhVLBdC3yyDZ109GHBlMbkO+LSEAA93XFYDfaxtw91HbhY5j
        /glUzSTPHe2X2gdHYjtz9tq2vjdNuem2eLu+YT3yBg==
X-Google-Smtp-Source: ABdhPJxWhopuC35KPwfnKawh6cLcwSxhekWmpZrV2rdkrXYdZ1KZfaRVhs2RbvUV5dzGgIZtqDT24zcxcDmDY6YjXwA=
X-Received: by 2002:a17:906:a3c7:: with SMTP id ca7mr71056515ejb.523.1609816374613;
 Mon, 04 Jan 2021 19:12:54 -0800 (PST)
MIME-Version: 1.0
References: <20201218162817.GX552508@nvidia.com> <20201218180310.GD5333@sirena.org.uk>
 <20201218184150.GY552508@nvidia.com> <20201218203211.GE5333@sirena.org.uk>
 <20201218205856.GZ552508@nvidia.com> <20201221185140.GD4521@sirena.org.uk>
 <20210104180831.GD552508@nvidia.com> <20210104211930.GI5645@sirena.org.uk>
 <20210105001341.GL552508@nvidia.com> <CAPcyv4gxprMo1LwGTqGDyN-z2TrXLcAvJ3AN9-fbUs6y-LwXeA@mail.gmail.com>
 <20210105015314.GM552508@nvidia.com>
In-Reply-To: <20210105015314.GM552508@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 4 Jan 2021 19:12:47 -0800
Message-ID: <CAPcyv4jAAC01rktNadUPv9jDRCOcDEO22uAOHXobpJ7TqAbp1w@mail.gmail.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 4, 2021 at 5:53 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Mon, Jan 04, 2021 at 04:51:51PM -0800, Dan Williams wrote:
> > On Mon, Jan 4, 2021 at 4:14 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > On Mon, Jan 04, 2021 at 09:19:30PM +0000, Mark Brown wrote:
> > >
> > >
> > > > > Regardless of the shortcut to make everything a struct
> > > > > platform_device, I think it was a mistake to put OF devices on
> > > > > platform_bus. Those should have remained on some of_bus even if they
> > > >
> > > > Like I keep saying the same thing applies to all non-enumerable buses -
> > > > exactly the same considerations exist for all the other buses like I2C
> > > > (including the ACPI naming issue you mention below), and for that matter
> > > > with enumerable buses which can have firmware info.
> > >
> > > And most busses do already have their own bus type. ACPI, I2C, PCI,
> > > etc. It is just a few that have been squished into platform, notably
> > > OF.
> > >
> >
> > I'll note that ACPI is an outlier that places devices on 2 buses,
> > where new acpi_driver instances are discouraged [1] in favor of
> > platform_drivers. ACPI scan handlers are awkwardly integrated into the
> > Linux device model.
> >
> > So while I agree with sentiment that an "ACPI bus" should
> > theoretically stand on its own there is legacy to unwind.
> >
> > I only bring that up to keep the focus on how to organize drivers
> > going forward, because trying to map some of these arguments backwards
> > runs into difficulties.
> >
> > [1]: http://lore.kernel.org/r/CAJZ5v0j_ReK3AGDdw7fLvmw_7knECCg2U_huKgJzQeLCy8smug@mail.gmail.com
>
> Well, this is the exact kind of thing I think we are talking about
> here..
>
> > > It should be split up based on the unique naming scheme and any bus
> > > specific API elements - like raw access to ACPI or OF data or what
> > > have you for other FW bus types.
> >
> > I agree that the pendulum may have swung too far towards "reuse
> > existing bus_type", and auxiliary-bus unwinds some of that, but does
> > the bus_type really want to be an indirection for driver apis outside
> > of bus-specific operations?
>
> If the bus is the "enumeration entity" and we define that things like
> name, resources, gpio's, regulators, etc are a generic part of what is
> enumerated, then it makes sense that the bus would have methods
> to handle those things too.
>
> In other words, the only way to learn what GPIO 'resource' is to ask
> the enumeration mechnism that is providing the bus. If the enumeration
> and bus are 1:1 then you can use a function pointer on the bus type
> instead of open coding a dispatch based on an indirect indication.
>

I get that, but I'm fearing a gigantic bus_ops structure that has
narrow helpers like ->gpio_count() that mean nothing to the many other
clients of the bus. Maybe I'm overestimating the pressure there will
be to widen the ops structure at the bus level.
