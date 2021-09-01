Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275DE3FD12C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241521AbhIACVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238102AbhIACVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:21:13 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A802BC061760
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 19:20:17 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id z18so2212605ybg.8
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 19:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cvspoRIgI+MMnzS+lut3skPcghFh9IpL/4KqrjqeeCs=;
        b=HKPOM51KnHqKGwAahcwO0zpEbQCad8cPQqLcZBKLGqwebktFXFuZQ+8iR/H7oTYe4x
         I0P45yfTLhdodEI/L28sb1eAdUUecYqqASTsjAFnEDzCdpQ5rmtGR60PjKdiOG2/5+Qi
         PfCEETdk1yg1/MY+a0vag23cT/OzDaAoIuT72wrwCJzIi77w15bx2qNPO9MyxGLw6T+8
         tyKcxH26ewIVANWjPBG/FardNVZ/ktP0qE/v4j56HbWI0Ci0ntf4aNa3Ts7SWhRXGKdi
         cV2gs4I0zOOwmHjrgPTO+KpklzxggYWZOpVDTDRz7BA/BH72zTaOTJNKXk/W8+ec5dO1
         Qi5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cvspoRIgI+MMnzS+lut3skPcghFh9IpL/4KqrjqeeCs=;
        b=bJ2jMEBMsic1ZIeyx2CdNE7BWHCBYRc3AVdK0hyUnmPPZFgTCSHiNa2pVu5AHJxnLw
         7jQ+qSAiB8J3Z8UVNZjcxuk4WR29t/NJKKdsdsyKRz1srvOSjANtRFcLW7rI4vwe4l4p
         C6Ol3xftnVMyPWZp3985LWR+/oiZRO21gPIIrtO+s5pNbQgQijSFiVuo4oaahBV9/dx9
         zxhjpHkz1uXQ+MZT72fZjwmh3TPcc8C+wqsMb2UVhsWCHHqQXWVeVf8Q9VhM9LxKHebL
         DmAZCC3/RCvAuUwAnCdZQb62EtklZ8jKdJ3jR4sbwIsCxzRkYDbYLGtndZIQlXkRWSMZ
         b5Cw==
X-Gm-Message-State: AOAM531AGhTZhufaqvVuZOM11xkvGai85OGWW9ctoMq5zpA+sA5dzwpj
        7SaJq/1UEIzGPFk4446QpvsnIcuyH206bM0FRo0rAA==
X-Google-Smtp-Source: ABdhPJzkZUcGvzE3jRa2nbBTmGsv1kUOPwhmivRHZVstOFiCMLXZuF3a4IUDh5SKXs5QRE5VasKM34scovrhvlNijak=
X-Received: by 2002:a5b:50b:: with SMTP id o11mr34740462ybp.466.1630462816675;
 Tue, 31 Aug 2021 19:20:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch> <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch> <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch> <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch> <20210831231804.zozyenear45ljemd@skbuf>
 <20210901012826.iuy2bhvkrgahhrl7@skbuf> <20210901013830.yst73ubhsrlml54i@skbuf>
In-Reply-To: <20210901013830.yst73ubhsrlml54i@skbuf>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 31 Aug 2021 19:19:40 -0700
Message-ID: <CAGETcx8r7o9u9bveQx6TAXG8YLH+aiuz9VZ5pLACm=S6KxNpWQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 6:38 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, Sep 01, 2021 at 04:28:26AM +0300, Vladimir Oltean wrote:
> > On Wed, Sep 01, 2021 at 02:18:04AM +0300, Vladimir Oltean wrote:
> > > On Wed, Sep 01, 2021 at 01:02:09AM +0200, Andrew Lunn wrote:
> > > > Rev B is interesting because switch0 and switch1 got genphy, while
> > > > switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
> > > > interrupt properties, so don't loop back to their parent device.
> > >
> > > This is interesting and not what I really expected to happen. It goes to
> > > show that we really need more time to understand all the subtleties of
> > > device dependencies before jumping on patching stuff.
> >
> > There is an even more interesting variation which I would like to point
> > out. It seems like a very odd loophole in the device links.
> >
> > Take the example of the mv88e6xxx DSA driver. On my board
> > (arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts), even after I
> > had to declare the switches as interrupt controller and add interrupts
> > to their internal PHYs, I still need considerable force to 'break' this
> > board in the way discussed in this thread. The correct PHY driver insists
> > to probe, and not genphy. Let me explain.
> >
> > The automatic device links between the switch (supplier, as interrupt-controller)
> > and PHYs (consumers) are added by fwnode_link_add, called from of_link_to_phandle.
> >
> > Important note: fwnode_link_add does not link devices, it links OF nodes.
> >
> > Even more important node, in the form of a comment:
> >
> >  * The driver core will use the fwnode link to create a device link between the
> >  * two device objects corresponding to @con and @sup when they are created. The
> >  * driver core will automatically delete the fwnode link between @con and @sup
> >  * after doing that.
> >
> > Okay?!
> >
> > What seems to be omitted is that the DSA switch driver's probing itself
> > can be deferred. For example:
> >
> > dsa_register_switch
> > -> dsa_switch_probe
> >    -> dsa_switch_parse_of
> >       -> dsa_switch_parse_ports_of
> >          -> dsa_port_parse_of
> >             -> of_find_net_device_by_node(of_parse_phandle(dn, "ethernet", 0));
> >             -> not found => return -EPROBE_DEFER
> >
> > When dsa_register_switch() returns -EPROBE_DEFER, it is effectively
> > an error path. So the reverse of initialization is performed.
> >
> > The mv88e6xxx driver calls mv88e6xxx_mdios_register() right _before_
> > dsa_register_switch. So when dsa_register_switch returns error code,
> > mv88e6xxx_mdios_unregister() will be called.
> >
> > When mv88e6xxx_mdios_unregister() is called, the MDIO buses with
> > internal PHYs are destroyed. So the PHY devices themselves are destroyed
> > too. And the device links between the DSA switch and the internal PHYs,
> > those created based on the firmware node links created by fwnode_link_add,
> > are dropped too.
> >
> > Now remember the comment that the device links created based on
> > fwnode_link_add are not restored.
> >
> > So probing of the DSA switch finally resumes, and this time
> > device_links_check_suppliers() is effectively bypassed, the PHYs no
> > longer request probe deferral due to their supplier not being ready,
> > because the device link no longer exists.
> >
> > Isn't this self-sabotaging?!

Yeah, this is a known "issue". I'm saying "issue" because at worst
it'd allow a few unnecessary deferred probes. And if you want to break
or get fw_devlink to ignore your child devices or your consumers,
there are simpler APIs to do it without having to intentionally defer
a probe.  Fixing this "issue" would just use up more memory and
increase boot time for no meaningful benefit.

> >
> > Now generally, DSA drivers defer probing because they probe in parallel
> > with the DSA master. This is typical if the switch is on a SPI bus, or
> > I2C, or on an MDIO bus provided by a _standalone_ MDIO controller.
> >
> > If the MDIO controller is not standalone, but is provided by Ethernet
> > controller that is the DSA master itself, then things change a lot,
> > because probing can never be parallel. The DSA master probes,
> > initializes its MDIO bus, and this triggers the probing of the MDIO
> > devices on that bus, one of which is the DSA switch. So DSA can no
> > longer defer the probe due to that reason.
> >
> > Secondly, in DSA we even have variation between drivers as to where they
> > register their internal MDIO buses. The mv88e6xxx driver does this in
> > mv88e6xxx_probe (the probe function on the MDIO bus). The rtl8366rb
> > driver calls realtek_smi_setup_mdio() from rtl8366rb_setup(), and this
> > is important. DSA provides drivers with a .setup() callback, which is
> > guaranteed to take place after nothing can defer the switch's probe
> > anymore.
> >
> > So putting two and two together, sure enough, if I move mv88e6xxx_mdios_register
> > from mv88e6xxx_probe to mv88e6xxx_setup, then I can reliably break this
> > setup, because the device links framework isn't sabotaging itself anymore.
> >
> > Conversely, I am pretty sure that if rtl8366rb was to call of_mdiobus_register()
> > from the probe method and not the setup method, the entire design issue
> > with interrupts on internal DSA switch ports would have went absolutely
> > unnoticed for a few more years.
> >
> > I have not tested this, but it also seems plausible that DSA can
> > trivially and reliably bypass any fw_devlink=on restrictions by simply
> > moving all of_mdiobus_register() driver calls from the .setup() method
> > to their respective probe methods (prior to calling dsa_register_switch),
> > then effectively fabricate an -EPROBE_DEFER during the first probe attempt.
> > I mean, who will know whether that probe deferral request was justified
> > or not?
>
> Pushing the thought even further, it is not even necessary to move the
> of_mdiobus_register() call to the probe function. Where it is (in .setup)
> is already good enough. It is sufficient to return -EOPNOTSUPP once
> (the first time) immediately _after_ the call to of_mdiobus_register
> (and have a proper error path, i.e. call mdiobus_unregister too).

Right, there are plenty of ways to intentionally break fw_devlink. I
hope that's not the point :) And I don't think -EOPNOTSUPP would work
because your device wouldn't be probed again.

>
> > Anyway, I'm not sure everyone agrees with this type of "solution" (even
> > though it's worth pointing it out as a fw_devlink limitation). In any
> > case, we need some sort of lightweight "fix" to the chicken-and-egg
> > problem, which will give me enough time to think of something better.

I think the generic DSA patch I gave would be the lightweight fix to
address this chicken-and-egg issue.

As for the long term fix, I'd really suggest looking into using the
component device model. I'd even be happy to help make any driver
core/component device improvements you might need.

I'm also interested in looking into improving the PHY probing so that
the genphy never probes a device that has a driver that could probe
it. Even outside of all this fw_devlink thing, they way PHY is handled
now, if any of the supplier really isn't ready yet (say a clock), then
the genphy gets used -- which isn't good.

-Saravana

> > I hope it is at least clearer now that there are subtleties and nuances,
> > and we cannot just assess how many boards are broken by looking at the
> > device trees. By design, all are, sure, but they might still work, and
> > that's better than nothing...
