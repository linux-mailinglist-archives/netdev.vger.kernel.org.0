Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D9B3EF7F8
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 04:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbhHRCPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 22:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbhHRCPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 22:15:10 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6D9C0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 19:14:36 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id l144so2152648ybl.12
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 19:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SfPD/quo7sa0Dpo/U3uNktkHfuBQTUg1wsbvhIPD8nQ=;
        b=o0TIRwNL6dImpqI20vNESL3ayW0bE6P7cLXb57bn4NGNNHs+dYOeTtIhJw43QMl6fY
         qB8FFz/oHrBw4e4FCmQbC4BxpnSkMMJGSpyefrmMkM3QsztsWx2nHDkASoM1paPpt3Pi
         CdyeLrticS2SC4lT92o9Aq6br7dqYsc5I1R62I5bw6yeZ1G8Wjzk4Wh0ADRhnRGLPFZa
         TpIVsjqY2sBRLY0+E6SS52q/IG8C3SxK8yQw2Sikv5gvtUT0srSFTP3aMART6oX/BIh4
         SDEPvFPpub6YnSmIwQa5UuId3Xq9gpKcxNofa2pzV4fSr0nIOY+W6a9ZRkmtVu73ctUi
         IX4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SfPD/quo7sa0Dpo/U3uNktkHfuBQTUg1wsbvhIPD8nQ=;
        b=SwZ00xY2wr8P61hYb5DJgBp6msX2cZYGwbp7UbNTdkcwZybCVPxWr8VeoU3M/jVXaX
         EZN5hLs2nBLCZw38XdH+R6Q2BsSMVVAq4QoK8XSxauswtGsykMUeJNdxX1xc3hJyHILe
         CwsicQLND1bta5Ky8UXCOe9+PErCm9+m3iJh9lOjwqvWaMHYRY1if1uRC7nBhqsNJ/zR
         rzkXUDKUIzYIks5vNkK0YqNLZpjnStnHvCg6gXaSAbU9QBMjJ/3f64s+h7pdSfWtCShk
         pQ1tWy1Snf7l8ZK1LCrn+7rzHFrylhcydNSpEU9rq9umPl/hajh1kngKZ0TR5mVzXQyy
         ctNA==
X-Gm-Message-State: AOAM530apRzbzDQ5mhP0haTCH62C/qyTQG8jY+q/ENSxH8Wdc0T2Y2GT
        CaurXiSF2nwgCE6UBZZ79PNxOHMLUl61crk+OtmU7g==
X-Google-Smtp-Source: ABdhPJwsTi8md73+61thZhdX1FQ93d+S0urkqVdZduz0ednIv+UpLnakUoTxxmi9y/Zmz/zFN882OGjRHAspi6DnGzw=
X-Received: by 2002:a25:614c:: with SMTP id v73mr8694727ybb.96.1629252875453;
 Tue, 17 Aug 2021 19:14:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210814023132.2729731-1-saravanak@google.com>
 <20210814023132.2729731-3-saravanak@google.com> <YRffzVgP2eBw7HRz@lunn.ch>
 <CAGETcx-ETuH_axMF41PzfmKmT-M7URiua332WvzzzXQHg=Hj0w@mail.gmail.com> <YRrVYNi1E2QO+XSY@lunn.ch>
In-Reply-To: <YRrVYNi1E2QO+XSY@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 17 Aug 2021 19:13:59 -0700
Message-ID: <CAGETcx9Yc6PAyrhzu4JN9fuVvHnOYOUnwgGhJ0kPdOBFe9eLbw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] of: property: fw_devlink: Add support for
 "phy-handle" property
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, kernel-team@android.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 2:15 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Aug 16, 2021 at 01:43:19PM -0700, Saravana Kannan wrote:
> > On Sat, Aug 14, 2021 at 8:22 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > Hi Saravana
> > >
> > > > Hi Andrew,
> > > >
> > >
> > > > Also there
> > > > are so many phy related properties that my head is spinning. Is there a
> > > > "phy" property (which is different from "phys") that treated exactly as
> > > > "phy-handle"?
> > >
> > > Sorry, i don't understand your question.
> >
> > Sorry. I was just saying I understand the "phy-handle" DT property
> > (seems specific to ethernet PHY) and "phys" DT property (seems to be
> > for generic PHYs -- used mostly by display and USB?). But I noticed
> > there's yet another "phy" DT property which I'm not sure I understand.
> > It seems to be used by display and ethernet and seems to be a
> > deprecated property. If you can explain that DT property in the
> > context of networking and how to interpret it as a human, that'd be
> > nice.
>
> Ah, i think i understand:
>
> Documentation/devicetree/bindings/net/ethernet-controller.yaml
>
>   phy:
>     $ref: "#/properties/phy-handle"
>     deprecated: true
>
> So it is used the same as phy-handle. I doubt there are many examples
> of it, it has been deprecated a long time. Maybe look in the powerpc
> dts files?
>
> > > > +     /*
> > > > +      * Device tree nodes pointed to by phy-handle never have struct devices
> > > > +      * created for them even if they have a "compatible" property. So
> > > > +      * return the parent node pointer.
> > > > +      */
> > >
> > > We have a classic bus with devices on it. The bus master is registers
> > > with linux using one of the mdiobus_register() calls. That then
> > > enumerates the bus, looking at the 32 possible address on the bus,
> > > using mdiobus_scan. It then gets a little complex, due to
> > > history.
> > >
> > > Originally, the only thing you could have on an MDIO bus was a
> > > PHY. But devices on MDIO busses are more generic, and Linux gained
> > > support for Ethernet switches on an MDIO bus, and there are a few
> > > other sort device. So to keep the PHY API untouched, but to add these
> > > extra devices, we added the generic struct mdio_device which
> > > represents any sort of device on an MDIO bus. This has a struct device
> > > embedded in it.
> > >
> > > When we scan the bus and find a PHY, a struct phy_device is created,
> > > which has an embedded struct mdio_device. The struct device in that is
> > > then registered with the driver core.
> > >
> > > So a phy-handle does point to a device, but you need to do an object
> > > orientated style look at the base class to find it.
> >
> > Thanks for the detailed explanation. I didn't notice a phy_device had
> > an mdio_device inside it. Makes sense. I think my comment is not
> > worded accurately and it really should be:
> >
> > Device tree nodes pointed to by phy-handle (even if they have a
> > "compatible" property) will never have struct devices probed and bound
> > to a driver through the driver framework. It's the parent node/device
> > that gets bound to a driver and initializes the PHY. So return the
> > parent node pointer instead.
> >
> > Does this sound right? As opposed to PHYs the other generic mdio
> > devices seem to actually have drivers that'll bind to them through the
> > driver framework.
>
> That sounds wrong. The MDIO bus master is a linux device and has a
> driver. Same as an I2C bus master, or an SPI bus master, or a USB
> host. All these busses have devices on them, same as an MDIO bus. The
> devices on the bus are found and registered with the driver
> framework. The driver framework, with some help from the mdio bus
> class, with then find the correct driver of the device, and probe
> it. During probe, it gets initialized by the PHY driver.
>
> So for me, the parent of a PHY would be the MDIO bus master, and the
> bus master is not driving the PHY, in the same way an I2C bus master
> does not drive the tmp100 temperature sensor on an i2c bus.
>
> But maybe i don't understand your terminology here?
>
> Maybe this will help:
>
> root@370rd:/sys/class/mdio_bus# ls -l
> total 0
> lrwxrwxrwx 1 root root 0 Jan  2  2021 '!soc!internal-regs!mdio@72004!switch@10!mdio' -> '../../devices/platform/soc/soc:internal-regs/f1072004.mdio/mdio_bus/f1072004.mdio-mii/f1072004.mdio-mii:10/mdio_bus/!soc!internal-regs!mdio@72004!switch@10!mdio'
> lrwxrwxrwx 1 root root 0 Jan  2  2021  f1072004.mdio-mii -> ../../devices/platform/soc/soc:internal-regs/f1072004.mdio/mdio_bus/f1072004.mdio-mii
> lrwxrwxrwx 1 root root 0 Jan  2  2021  fixed-0 -> '../../devices/platform/Fixed MDIO bus.0/mdio_bus/fixed-0'
>
> So there are three MDIO bus masters.
>
> Going into f1072004.mdio-mii, we see there are two PHYs on this bus:
>
> root@370rd:/sys/class/mdio_bus/f1072004.mdio-mii# ls -l
> total 0
> lrwxrwxrwx 1 root root    0 Aug 16 21:03 device -> ../../../f1072004.mdio
> drwxr-xr-x 5 root root    0 Jan  2  2021 f1072004.mdio-mii:00
> drwxr-xr-x 6 root root    0 Jan  2  2021 f1072004.mdio-mii:10
> lrwxrwxrwx 1 root root    0 Aug 16 21:03 of_node -> ../../../../../../../firmware/devicetree/base/soc/internal-regs/mdio@72004
> drwxr-xr-x 2 root root    0 Aug 16 21:03 power
> drwxr-xr-x 2 root root    0 Aug 16 21:03 statistics
> lrwxrwxrwx 1 root root    0 Jan  2  2021 subsystem -> ../../../../../../../class/mdio_bus
> -rw-r--r-- 1 root root 4096 Jan  2  2021 uevent
> -r--r--r-- 1 root root 4096 Aug 16 21:03 waiting_for_supplier
>
> and going into one of the PHYs f1072004.mdio-mii:00
>
> lrwxrwxrwx 1 root root    0 Aug 16 20:54 attached_dev -> ../../../../f1070000.ethernet/net/eth0
> lrwxrwxrwx 1 root root    0 Aug 16 20:54 driver -> '../../../../../../../../bus/mdio_bus/drivers/Marvell 88E1510'
> drwxr-xr-x 3 root root    0 Jan  2  2021 hwmon
> lrwxrwxrwx 1 root root    0 Aug 16 20:54 of_node -> ../../../../../../../../firmware/devicetree/base/soc/internal-regs/mdio@72004/ethernet-phy@0
> -r--r--r-- 1 root root 4096 Aug 16 20:54 phy_dev_flags
> -r--r--r-- 1 root root 4096 Aug 16 20:54 phy_has_fixups
> -r--r--r-- 1 root root 4096 Aug 16 20:54 phy_id
> -r--r--r-- 1 root root 4096 Aug 16 20:54 phy_interface
> drwxr-xr-x 2 root root    0 Aug 16 20:54 power
> drwxr-xr-x 2 root root    0 Aug 16 20:54 statistics
> lrwxrwxrwx 1 root root    0 Jan  2  2021 subsystem -> ../../../../../../../../bus/mdio_bus
> -rw-r--r-- 1 root root 4096 Jan  2  2021 uevent
>
> The phy-handle in the MAC node points to ethernet-phy@0.

Thanks! Looks like I got confused a bit based on some misconceptions I
got when working on unrelated patches. I read through the code and now
understand how this works. I'll fix up this patch and send out a v2
(it actually makes the patch simpler).

On an unrelated note, I'm still a bit confused on what's going on in
get_phy_device() when one PHY C45 device has multiple IDs found by
get_phy_c45_ids(). Based on the comments, it looks like each of those
IDs might be separate devices? Or am I misunderstanding the comment?
If they are separate devices, how is one phy_device representing them
all?

-Saravana
