Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5980D231B70
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgG2IoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgG2IoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:44:13 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0828C0619D2
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:44:12 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id d6so9635113ejr.5
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCoNUycTrM4vcpQSgsvv2FwvRrAmJTb7jLCe3nuW21w=;
        b=QbhJ7OtKj27I0Iwkb+5wLaBP42uI3VKl5Q8x+1Vd2TgSqICxN9XtRVe087WKz5foQi
         RPOamogt7NNz4OTm8iYiSnt9SQf3LGlpZJvAPzVgs0GZfpzuisJkYDtkIAoKHB2O73FV
         r8e/mqHNn7o7+CAuTLQcYE9HovamR0Pwh6v0Y9EBke9ETOMuQXeEa+FPiiRWzkYZ0Fap
         vV//LJVAr4yZnvVCEIx1oJeKdQgp5ZziNEmZlo6ybCiSbmOGZOlAtyH47ztD+w2LQsuH
         YQOgDHv7QdRM3SF+y9W+K2oSLej18oozdEyWRop0Q691cUEkBI4lsOe3aBalEkzeiv1B
         soCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCoNUycTrM4vcpQSgsvv2FwvRrAmJTb7jLCe3nuW21w=;
        b=WkWQyDg/UKfzJkP2sAN9PZfGgjwiX8vI8AAg8CLFczKJrwWQQ7ddqkXbjLkbnj8PIS
         PS6QbAzJ/V0h635Vpr4BMeUeVp+R7Z2EUtReF1ZmabxUU23db6/350XTdT04zFHgKeah
         Ku7MfchvNQIMV7Q31ZcdcSDESPnVELDs1k3oLnKD+WWvVSOWCBFuwiHvECEr/+Ht0MyL
         TpJtON6d8Z2AHT453b4yu01UHbM/XcXbylU4pQqIKTj9oD3V72XVO7OQkSLnQYLy1NJW
         zrJ2M78qzb6rTApWusGcwBS4BRbVvRIatSc2fHQ/xQHEPTqgvoR6BRGnLa+dXiPEY+Jy
         HSuA==
X-Gm-Message-State: AOAM532s32oXQDjIHqKirJtJd64M1K7g/Qj6SkS4fsQKYhWgTtv0C7A2
        supy2UcYd6UFptwTJO00VuWwtDJJIPijUcBNpqmPWg==
X-Google-Smtp-Source: ABdhPJz+a2kHS9w6Cu6BZhrxmUNP8ct9fmRZi1X04ifbX565s7qpvY5KIPIdAG91G8k8g+rbtWNluSiVpfaIuZ1xzv0=
X-Received: by 2002:a17:906:36d7:: with SMTP id b23mr5113220ejc.149.1596012251564;
 Wed, 29 Jul 2020 01:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com> <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch> <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch> <1595922651-sup-5323@galangal.danc.bne.opengear.com>
 <9e63aabf-8993-9ce0-1274-c29d7a5fc267@arm.com> <1e4301bf-cbf2-a96b-0b76-611ed08aa39a@gmail.com>
 <f046fa8b-6bac-22c3-0d9f-9afb20877fc9@arm.com>
In-Reply-To: <f046fa8b-6bac-22c3-0d9f-9afb20877fc9@arm.com>
From:   Jon Nettleton <jon@solid-run.com>
Date:   Wed, 29 Jul 2020 10:43:34 +0200
Message-ID: <CABdtJHvcaR_J86at-eMYPmNXEno8_CwUkSpLmF4HHba_AQ4A2Q@mail.gmail.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Dan Callaghan <dan.callaghan@opengear.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 4:53 AM Jeremy Linton <jeremy.linton@arm.com> wrote:
>
> Hi,
>
> On 7/28/20 7:39 PM, Florian Fainelli wrote:
> > On 7/28/2020 3:30 PM, Jeremy Linton wrote:
> >> Hi,
> >>
> >> On 7/28/20 3:06 AM, Dan Callaghan wrote:
> >>> Excerpts from Andrew Lunn's message of 2020-07-24 21:14:36 +02:00:
> >>>> Now i could be wrong, but are Ethernet switches something you expect
> >>>> to see on ACPI/SBSA platforms? Or is this a legitimate use of the
> >>>> escape hatch?
> >>>
> >>> As an extra data point: right now I am working on an x86 embedded
> >>> appliance (ACPI not Device Tree) with 3x integrated Marvell switches.
> >>> I have been watching this patch series with great interest, because
> >>> right now there is no way for me to configure a complex switch topology
> >>> in DSA without Device Tree.
> >>
> >> DSA though, the switch is hung off a normal MAC/MDIO, right? (ignoring
> >> whether that NIC/MAC is actually hug off PCIe for the moment).
> >
> > There is no specific bus, we have memory mapped, MDIO, SPI, I2C swiches
> > all supported within the driver framework right now.
> >
> >>
> >> It just has a bunch of phy devices strung out on that single MAC/MDIO.
> >
> > It has a number of built-in PHYs that typically appear on a MDIO bus,
> > whether that bus is the switch's internal MDIO bus, or another MDIO bus
> > (which could be provided with just two GPIOs) depends on how the switch
> > is connected to its management host.
> >
> > When the switch is interfaced via MDIO the switch also typically has a
> > MDIO interface called the pseudo-PHY which is how you can actually tap
> > into the control interface of the switch, as opposed to reading its
> > internal PHYs from the MDIO bus.
> >
> >> So in ACPI land it would still have a relationship similar to the one
> >> Andrew pointed out with his DT example where the eth0->mdio->phy are all
> >> contained in their physical parent. The phy in that case associated with
> >> the parent adapter would be the first direct decedent of the mdio, the
> >> switch itself could then be represented with another device, with a
> >> further string of device/phys representing the devices. (I dislike
> >> drawing acsii art, but if this isn't clear I will, its also worthwhile
> >> to look at the dpaa2 docs for how the mac/phys work on this device for
> >> contrast.).
> >
> > The eth0->mdio->phy relationship you describe is the simple case that
> > you are well aware of which is say what we have on the Raspberry Pi 4
> > with GENET and the external Broadcom PHY.
> >
> > For an Ethernet switch connected to an Ethernet MAC, we have 4 different
> > types of objects:
> >
> > - the Ethernet MAC which sits on its specific bus
> >
> > - the Ethernet switch which also sits on its specific bus
> >
> > - the built-in PHYs of the Ethernet switch which sit on whatever
> > bus/interface the switch provides to make them accessible
> >
> > - the specific bus controller that provides access to the Ethernet switch
> >
> > and this is a simplification that does not take into account Physical
> > Coding Sublayer devices, pure MDIO devices (with no foot in the Ethernet
> > land such as PCIe, USB3 or SATA PHYs), SFP, SFF and other pluggable modules.
>
> Which is why I've stayed away from much of the switch discussion. There
> are a lot of edge cases to fall into, because for whatever reason
> networking seems to be unique in all this non-enumerable customization
> vs many other areas of the system. Storage, being an example i'm more
> familiar with which has very similar problems yet, somehow has managed
> to avoid much of this, despite having run on fabrics significantly more
> complex than basic ethernet (including running on a wide range of hot
> pluggable GBIC/SFP/QSFP/etc media layers).
>
> ACPI's "problem" here is that its strongly influenced by the "Plug and
> Play" revolution of the 1990's where the industry went from having
> humans describing hardware using machine readable languages, to hardware
> which was enumerable using standard protocols. ACPI's device
> descriptions are there as a crutch for the remaining non plug an play
> hardware in the system.
>
> So at a basic level, if your describing hardware in ACPI rather than
> abstracting it, that is a problem.
>
This is also my first run with ACPI and this discussion needs to be
brought back to the powers that be regarding sorting this out.  This
is where I see it from an Armada and Layerscape perspective.  This
isn't a silver bullet fix but the small things I think that need to be
done to move this forward.

From Microsoft's documentation.

Device dependencies

Typically, there are hardware dependencies between devices on a
particular platform. Windows requires that all such dependencies be
described so that it can ensure that all devices function correctly as
things change dynamically in the system (device power is removed,
drivers are stopped and started, and so on). In ACPI, dependencies
between devices are described in the following ways:

1) Namespace hierarchy. Any device that is a child device (listed as a
device within the namespace of another device) is dependent on the
parent device. For example, a USB HSIC device is dependent on the port
(parent) and controller (grandparent) it is connected to. Similarly, a
GPU device listed within the namespace of a system memory-management
unit (MMU) device is dependent on the MMU device.

2) Resource connections. Devices connected to GPIO or SPB controllers
are dependent on those controllers. This type of dependency is
described by the inclusion of Connection Resources in the device's
_CRS.

3) OpRegion dependencies. For ASL control methods that use OpRegions
to perform I/O, dependencies are not implicitly known by the operating
system because they are only determined during control method
evaluation. This issue is particularly applicable to GeneralPurposeIO
and GenericSerialBus OpRegions in which Plug and Play drivers provide
access to the region. To mitigate this issue, ACPI defines the
OpRegion Dependency (_DEP) object. _DEP should be used in any device
namespace in which an OpRegion (HW resource) is referenced by a
control method, and neither 1 nor 2 above already applies for the
referenced OpRegion's connection resource. For more information, see
section 6.5.8, "_DEP (Operation Region Dependencies)", of the ACPI 5.0
specification.

We can forget about 3 because even though _DEP would solve many of our
problems, and Intel has kind of used it for some of their
architectures, according to the ACPI spec it should not be used this
way.

1) can be achievable on some platforms like the LX2160a.  We have the
mcbin firmware which is the bus (the ACPI spec does allow you to
define a platform defined bus), which has MACs as the children, which
then can have phy's or SFP modules as their children.  This works okay
for enumeration and parenting but how do they talk?

This is where 2) comes into play.  The big problem is that MDIO isn't
designated as a SPB
(https://docs.microsoft.com/en-us/windows-hardware/drivers/bringup/simple-peripheral-bus--spb-)
We have GPIO, I2C, SPI, UART, MIPI and a couple of others.  While not
a silver bullet I think getting MDIO added to the spec would be the
next step forward to being able to implement this in Linux with
phylink / phylib in a sane manner.  Currently SFP definitions are
using the SPB to designate the various GPIO and I2C interfaces that
are needed to probe devices and handle interrupts.

The other alternatives is the ACPI maintainers agree on the _DSD
method (would be quickest and should be easy to migrate to SBP if MDIO
were adopter), or nothing is done at all (which I know seems to be a
popular opinion).

-Jon
