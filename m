Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0F72DEBA9
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 23:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgLRWhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 17:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgLRWhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 17:37:07 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF6DC0617A7
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 14:36:26 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id w1so5410275ejf.11
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 14:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xTXy3XpNAms3ekkwQw/otErW5WULs88likHcciGFXeM=;
        b=m3zOHE0w3r6ahzpcAgQfVzAPl2i6KJvip2SKXyaczrJEGZnlHaHWDc6Y6e6Ue/Fk3w
         conhoHW1dPczYVsQmj2eLqr1B0wAyqCg0qSM7LzF0bAk5x3WGRvz9e63oJoCLrRPxcAo
         NCup3hmGffugX6i074UpCmza+m0e4URw20OviQ33kIumJ5YVLEwK+806pVpfQefsT2xX
         +qBOFn99wzNCn8q6eC1jAdUSPLxRJcloKOs+Xtbapw/PIX8mOrEx3E5skNWYliCtMaLN
         OEAidGbLkRLvVIrKn49ZsuMwTg+JPymV16f3E3Q1jq0ujaCjujl+6wptrt/7u45O2l8Y
         TryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xTXy3XpNAms3ekkwQw/otErW5WULs88likHcciGFXeM=;
        b=qHlXXDo3TtdMwjB4NImEsYAKByvWOBFYj8Q74CnpWSsbg+kikCSEVhEXeWntEcNI0I
         /bft/2Kn77iMMWnPX1Quktvm6BO7HH+adlEBJbi/am8HdTWolkuyZV6uOG3ZgkyJiwdk
         eC6tPecEWc0G977IKbSYW4BAvfyow+UIL/41CsbyegyDeJTF7uLNJ1uExXnz5L1cK8jK
         vdGXo7U31PMYv0m6yu0dUggRxY+12KmLvjCLL+eAAygj4vkQz1sCnYRNA9KcKPl6wTkg
         zFsEBZWY3Kt/ZsHGn5t/d2pOcSV2UP0fD23IDZb02E+QJPTE1QBZNqFLE2C5Us9KKWyQ
         mTyA==
X-Gm-Message-State: AOAM531kVU5iph2lamvOIO8oSOCc6fDNsX6YX0pLt3J4en5YRxIGwSFw
        Z71S8gO372vWwT6Zw6y24h3pw4qBnPOBuz2MRL684dBeFUw=
X-Google-Smtp-Source: ABdhPJxVIJsNw1VhtEN2EC6NpPsqgkomLtwJyLMDGzQEDyQsVR1b9PxyeXfVm3r7ts5mggWcfo7h1ujtbU0n5AwKaRw=
X-Received: by 2002:a17:906:a29a:: with SMTP id i26mr6063250ejz.45.1608330985195;
 Fri, 18 Dec 2020 14:36:25 -0800 (PST)
MIME-Version: 1.0
References: <20201217211937.GA3177478@piout.net> <X9xV+8Mujo4dhfU4@kroah.com>
 <20201218131709.GA5333@sirena.org.uk> <20201218140854.GW552508@nvidia.com>
 <20201218155204.GC5333@sirena.org.uk> <20201218162817.GX552508@nvidia.com>
 <20201218180310.GD5333@sirena.org.uk> <20201218184150.GY552508@nvidia.com>
 <20201218203211.GE5333@sirena.org.uk> <20201218205856.GZ552508@nvidia.com> <20201218211658.GH3143569@piout.net>
In-Reply-To: <20201218211658.GH3143569@piout.net>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 18 Dec 2020 14:36:14 -0800
Message-ID: <CAPcyv4iruqY546kM68Dy_h4J5Qc6Ry-eGyVKhAp5eufsZcNksQ@mail.gmail.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
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

On Fri, Dec 18, 2020 at 1:17 PM Alexandre Belloni
<alexandre.belloni@bootlin.com> wrote:
>
> On 18/12/2020 16:58:56-0400, Jason Gunthorpe wrote:
> > On Fri, Dec 18, 2020 at 08:32:11PM +0000, Mark Brown wrote:
> >
> > > > So, I strongly suspect, MFD should create mfd devices on a MFD bus
> > > > type.
> > >
> > > Historically people did try to create custom bus types, as I have
> > > pointed out before there was then pushback that these were duplicating
> > > the platform bus so everything uses platform bus.
> >
> > Yes, I vaugely remember..
> >
> > I don't know what to say, it seems Greg doesn't share this view of
> > platform devices as a universal device.
> >
> > Reading between the lines, I suppose things would have been happier
> > with some kind of inheritance scheme where platform device remained as
> > only instantiated directly in board files, while drivers could bind to
> > OF/DT/ACPI/FPGA/etc device instantiations with minimal duplication &
> > boilerplate.
> >
> > And maybe that is exactly what we have today with platform devices,
> > though the name is now unfortunate.
> >
> > > I can't tell the difference between what it's doing and what SOF is
> > > doing, the code I've seen is just looking at the system it's running
> > > on and registering a fixed set of client devices.  It looks slightly
> > > different because it's registering a device at a time with some wrapper
> > > functions involved but that's what the code actually does.
> >
> > SOF's aux bus usage in general seems weird to me, but if you think
> > it fits the mfd scheme of primarily describing HW to partition vs
> > describing a SW API then maybe it should use mfd.
> >
> > The only problem with mfd as far as SOF is concerned was Greg was not
> > happy when he saw PCI stuff in the MFD subsystem.
> >
>
> But then again, what about non-enumerable devices on the PCI device? I
> feel this would exactly fit MFD. This is a collection of IPs that exist
> as standalone but in this case are grouped in a single device.
>
> Note that I then have another issue because the kernel doesn't support
> irq controllers on PCI and this is exactly what my SoC has. But for now,
> I can just duplicate the irqchip driver in the MFD driver.
>
> > This whole thing started when Intel first proposed to directly create
> > platform_device's in their ethernet driver and Greg had a quite strong
> > NAK to that.
>
> Let me point to drivers/net/ethernet/cadence/macb_pci.c which is a
> fairly recent example. It does exactly that and I'm not sure you could
> do it otherwise while still not having to duplicate most of macb_probe.
>

This still feels an orthogonal example to the problem auxiliary-bus is
solving. If a platform-device and a pci-device surface an IP with a
shared programming model that's an argument for a shared library, like
libata to house the commonality. In contrast auxiliary-bus is a
software model for software-defined sub-functionality to be wrapped in
a driver model. It assumes a parent-device / parent-driver hierarchy
that platform-bus and pci-bus do not imply.
