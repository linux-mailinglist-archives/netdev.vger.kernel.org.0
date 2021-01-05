Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F7A2EA1A1
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 01:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbhAEAwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 19:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbhAEAwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 19:52:40 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA58C061793
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 16:51:59 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id dk8so29372056edb.1
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 16:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WBmAQEVK+d4iAJti2GEvFbY9xySgwvFGBDCdqOb6r0o=;
        b=VH4YB3KAxYrKdsAEQNP8eGJvmHZPYEIOL/Wk5c1jc1CaDg0kbcYFUxsMzIIdMEw6NJ
         roxcZmJiCU51O0ZrSmD2phPcmySG3sPOi2M/NJaZw8gPK2V+eyGY97r+oS8igSd+voqd
         OrjM6uXZUYzkHrzjGNWvYIoBvw/O7+aNi51H0LOmgcljqkAbT7kzzANZKl4fVSqiQRaM
         eNMgYm4AiYljDOm5/K05WqyKJZuZnYwAidOXCdsSgvEM7cdb02iEWL6u4Ey+rE8v2mwz
         +2McsRVPDBLvpXX9Y87Bd8pdQw19z/iCdiYH2EqAk28vs1SHisBJsjZAo4M50pvK4S4K
         YC9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WBmAQEVK+d4iAJti2GEvFbY9xySgwvFGBDCdqOb6r0o=;
        b=kQfLBzQGaxQaDxukvC8lEdxWUWq5aYJzPWDMaPRSrIU/c/ccTcSF+ONm/WYMKb5dcl
         zvAeALfMEEXf5bErFEA3eqtyjD6rE2/WRbBbe3xVVt3l6+/ELDlylZ9rgTLA/5Ld8EJ1
         btqjxeGtDXHGOHmrpAiI0BX39Z/9YWKof0z9ANoe1TInjS4wOs0JAUwimciqF6F9DxOd
         GWlEh+YhBz8ybxUjf0+S8NX9VKKCZ3iaUiqfkiuqTngk3FKSdQelB2Ddh40lUPTVAZTX
         Ewvq/UOgiNRPKw27wiDxMuiYOPCyevIBSy65AMNHAicTAZW+YedJkKuBOBre3P0Q57Hj
         oXSQ==
X-Gm-Message-State: AOAM533XHa8jNIFf7u5LYukD3WH1CcwqcnfyBoCG9rtabu5krt+mEcUv
        IcWL3cPs+oy4HmPzOltB+st1ZtlegMNWMX1gpbTrSw==
X-Google-Smtp-Source: ABdhPJx/xFK6oHnwbgHxjjQstwquyCH8dZKA1eVEWKIXofDnOHNlD62w60xu2i4e02Nc/f/wfco70KpV1hZ/ILyBB1k=
X-Received: by 2002:aa7:c3cd:: with SMTP id l13mr72431946edr.97.1609807918552;
 Mon, 04 Jan 2021 16:51:58 -0800 (PST)
MIME-Version: 1.0
References: <20201218140854.GW552508@nvidia.com> <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com> <20201218180310.GD5333@sirena.org.uk>
 <20201218184150.GY552508@nvidia.com> <20201218203211.GE5333@sirena.org.uk>
 <20201218205856.GZ552508@nvidia.com> <20201221185140.GD4521@sirena.org.uk>
 <20210104180831.GD552508@nvidia.com> <20210104211930.GI5645@sirena.org.uk> <20210105001341.GL552508@nvidia.com>
In-Reply-To: <20210105001341.GL552508@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 4 Jan 2021 16:51:51 -0800
Message-ID: <CAPcyv4gxprMo1LwGTqGDyN-z2TrXLcAvJ3AN9-fbUs6y-LwXeA@mail.gmail.com>
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

On Mon, Jan 4, 2021 at 4:14 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Mon, Jan 04, 2021 at 09:19:30PM +0000, Mark Brown wrote:
>
>
> > > Regardless of the shortcut to make everything a struct
> > > platform_device, I think it was a mistake to put OF devices on
> > > platform_bus. Those should have remained on some of_bus even if they
> >
> > Like I keep saying the same thing applies to all non-enumerable buses -
> > exactly the same considerations exist for all the other buses like I2C
> > (including the ACPI naming issue you mention below), and for that matter
> > with enumerable buses which can have firmware info.
>
> And most busses do already have their own bus type. ACPI, I2C, PCI,
> etc. It is just a few that have been squished into platform, notably
> OF.
>

I'll note that ACPI is an outlier that places devices on 2 buses,
where new acpi_driver instances are discouraged [1] in favor of
platform_drivers. ACPI scan handlers are awkwardly integrated into the
Linux device model.

So while I agree with sentiment that an "ACPI bus" should
theoretically stand on its own there is legacy to unwind.

I only bring that up to keep the focus on how to organize drivers
going forward, because trying to map some of these arguments backwards
runs into difficulties.

[1]: http://lore.kernel.org/r/CAJZ5v0j_ReK3AGDdw7fLvmw_7knECCg2U_huKgJzQeLCy8smug@mail.gmail.com

> > > are represented by struct platform_device and fiddling in the core
> > > done to make that work OK.
> >
> > What exactly is the fiddling in the core here, I'm a bit unclear?
>
> I'm not sure, but I bet there is a small fall out to making bus_type
> not 1:1 with the struct device type.. Would have to attempt it to see
>
> > > This feels like a good conference topic someday..
> >
> > We should have this discussion *before* we get too far along with trying
> > to implement things, we should at least have some idea where we want to
> > head there.
>
> Well, auxillary bus is clearly following the original bus model
> intention with a dedicated bus type with a controlled naming
> scheme. The debate here seems to be "what about platform bus" and
> "what to do with mfd"?
>
> > Those APIs all take a struct device for lookup so it's the same call for
> > looking things up regardless of the bus the device is on or what
> > firmware the system is using - where there are firmware specific lookup
> > functions they're generally historical and shouldn't be used for new
> > code.  It's generally something in the form
> >
> >       api_type *api_get(struct device *dev, const char *name);
>
> Well, that is a nice improvement since a few years back when I last
> worked on this stuff.
>
> But now it begs the question, why not push harder to make 'struct
> device' the generic universal access point and add some resource_get()
> API along these lines so even a platform_device * isn't needed?
>
> Then the path seems much clearer, add a multi-bus-type device_driver
> that has a probe(struct device *) and uses the 'universal api_get()'
> style interface to find the generic 'resources'.
>
> The actual bus types and bus structs can then be split properly
> without the boilerplate that caused them all to be merged to platform,
> even PCI could be substantially merged like this.
>
> Bonus points to replace the open coded method disptach:
>
> int gpiod_count(struct device *dev, const char *con_id)
> {
>         int count = -ENOENT;
>
>         if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
>                 count = of_gpio_get_count(dev, con_id);
>         else if (IS_ENABLED(CONFIG_ACPI) && dev && ACPI_HANDLE(dev))
>                 count = acpi_gpio_count(dev, con_id);
>
>         if (count < 0)
>                 count = platform_gpio_count(dev, con_id);
>
> With an actual bus specific virtual function:
>
>     return dev->bus->gpio_count(dev);
>
> > ...and then do the same thing for every other bus with firmware
> > bindings.  If it's about the firmware interfaces it really isn't a
> > platform bus specific thing.  It's not clear to me if that's what it is
> > though or if this is just some tangent.
>
> It should be split up based on the unique naming scheme and any bus
> specific API elements - like raw access to ACPI or OF data or what
> have you for other FW bus types.

I agree that the pendulum may have swung too far towards "reuse
existing bus_type", and auxiliary-bus unwinds some of that, but does
the bus_type really want to be an indirection for driver apis outside
of bus-specific operations?
