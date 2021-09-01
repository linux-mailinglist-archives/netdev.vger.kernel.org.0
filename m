Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7F43FD61E
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbhIAJDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243336AbhIAJDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 05:03:10 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DCAC061575;
        Wed,  1 Sep 2021 02:02:13 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u15-20020a05600c19cf00b002f6445b8f55so1018181wmq.0;
        Wed, 01 Sep 2021 02:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PD5wfgfnh77RuRP2uKllqFvkE7i4Iu1qornbBmeqn3I=;
        b=M2t8dZQyO7K+Y2KlQQOyoZSztsorIhedH5Z+ynVfPL84/9ZleT/3AvceUhTTovZ7Mp
         Q7+d/HTQdELYQCUlQ8B+FuhDag4sWpbH050h1pOsIhjfOqxCE9IlGu3d+5/vNZbBLCh+
         nP6w5y4Phvz/jO22O7N2o9SeUgqDr2XNpUMP5Eg/lz9EAv8KJskJA08eo6VALn0jWLvv
         vZ0KvWH97VagDoY3l0dr7fmHvnRYy/+OJI2DnSW5Kb59q1MhQ48asq9DK3a3v6ySmd6h
         gyVEaMkQZOhME9pEebPtT/HRRzhR1Iym7O4i1l8n9GIHBjbT5qFMfvQnxdXcGnnnA5y8
         TFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PD5wfgfnh77RuRP2uKllqFvkE7i4Iu1qornbBmeqn3I=;
        b=R9cVMXfqOXJeIxswAZCPbCqTcQKCEmv+pZJUGx+aBol2j08f2WOOZfx6s1lVHyA5bT
         O42zWfUPnMHUlBtyHwzjUZ9Jua4rFQ7Wsvuh/Me/UtOO9k1PW+8QttW0JDr+JwnLQUxB
         CkJnkSOQOeBRjIXNvdBfobE0uaxFDEXxHzhOFW1xzSHxqGk3mumf9gdY+xilaT1MRz0V
         Fwt1gXJ/Ii8KArWBZ7rea/A7ReElzPJaAaebvn+X3S8dIi70QyteiN4AOuF4JmwyRMau
         MJ0L7rDz9Ie7QjvIuRmN7nbpLmFCyVlZglQi+juyfWs/apHjVL/ztKRxA8rY9LTJUdaw
         +hAw==
X-Gm-Message-State: AOAM530hhRVCzbPawlZk+GUS+ItPpx9QH3ueIovRuW1KQZNyuJKkjrf4
        v8Y7gs13XGgksswpTfTq1v8=
X-Google-Smtp-Source: ABdhPJxtT//6ZtQ2O7IF7mVRyWnkykls5bXT0fm0DhUns5lzocjHsmT8hFLdj5HESvKGEnQZPz/8uw==
X-Received: by 2002:a7b:c014:: with SMTP id c20mr8503914wmb.81.1630486931446;
        Wed, 01 Sep 2021 02:02:11 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id n15sm20903742wrv.48.2021.09.01.02.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 02:02:10 -0700 (PDT)
Date:   Wed, 1 Sep 2021 12:02:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saravana Kannan <saravanak@google.com>
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
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <20210901090209.f4na6cwu7lsa57pv@skbuf>
References: <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
 <20210831231804.zozyenear45ljemd@skbuf>
 <20210901012826.iuy2bhvkrgahhrl7@skbuf>
 <20210901013830.yst73ubhsrlml54i@skbuf>
 <CAGETcx8r7o9u9bveQx6TAXG8YLH+aiuz9VZ5pLACm=S6KxNpWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8r7o9u9bveQx6TAXG8YLH+aiuz9VZ5pLACm=S6KxNpWQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 07:19:40PM -0700, Saravana Kannan wrote:
> On Tue, Aug 31, 2021 at 6:38 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Wed, Sep 01, 2021 at 04:28:26AM +0300, Vladimir Oltean wrote:
> > > On Wed, Sep 01, 2021 at 02:18:04AM +0300, Vladimir Oltean wrote:
> > > > On Wed, Sep 01, 2021 at 01:02:09AM +0200, Andrew Lunn wrote:
> > > > > Rev B is interesting because switch0 and switch1 got genphy, while
> > > > > switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
> > > > > interrupt properties, so don't loop back to their parent device.
> > > >
> > > > This is interesting and not what I really expected to happen. It goes to
> > > > show that we really need more time to understand all the subtleties of
> > > > device dependencies before jumping on patching stuff.
> > >
> > > There is an even more interesting variation which I would like to point
> > > out. It seems like a very odd loophole in the device links.
> > >
> > > Take the example of the mv88e6xxx DSA driver. On my board
> > > (arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts), even after I
> > > had to declare the switches as interrupt controller and add interrupts
> > > to their internal PHYs, I still need considerable force to 'break' this
> > > board in the way discussed in this thread. The correct PHY driver insists
> > > to probe, and not genphy. Let me explain.
> > >
> > > The automatic device links between the switch (supplier, as interrupt-controller)
> > > and PHYs (consumers) are added by fwnode_link_add, called from of_link_to_phandle.
> > >
> > > Important note: fwnode_link_add does not link devices, it links OF nodes.
> > >
> > > Even more important node, in the form of a comment:
> > >
> > >  * The driver core will use the fwnode link to create a device link between the
> > >  * two device objects corresponding to @con and @sup when they are created. The
> > >  * driver core will automatically delete the fwnode link between @con and @sup
> > >  * after doing that.
> > >
> > > Okay?!
> > >
> > > What seems to be omitted is that the DSA switch driver's probing itself
> > > can be deferred. For example:
> > >
> > > dsa_register_switch
> > > -> dsa_switch_probe
> > >    -> dsa_switch_parse_of
> > >       -> dsa_switch_parse_ports_of
> > >          -> dsa_port_parse_of
> > >             -> of_find_net_device_by_node(of_parse_phandle(dn, "ethernet", 0));
> > >             -> not found => return -EPROBE_DEFER
> > >
> > > When dsa_register_switch() returns -EPROBE_DEFER, it is effectively
> > > an error path. So the reverse of initialization is performed.
> > >
> > > The mv88e6xxx driver calls mv88e6xxx_mdios_register() right _before_
> > > dsa_register_switch. So when dsa_register_switch returns error code,
> > > mv88e6xxx_mdios_unregister() will be called.
> > >
> > > When mv88e6xxx_mdios_unregister() is called, the MDIO buses with
> > > internal PHYs are destroyed. So the PHY devices themselves are destroyed
> > > too. And the device links between the DSA switch and the internal PHYs,
> > > those created based on the firmware node links created by fwnode_link_add,
> > > are dropped too.
> > >
> > > Now remember the comment that the device links created based on
> > > fwnode_link_add are not restored.
> > >
> > > So probing of the DSA switch finally resumes, and this time
> > > device_links_check_suppliers() is effectively bypassed, the PHYs no
> > > longer request probe deferral due to their supplier not being ready,
> > > because the device link no longer exists.
> > >
> > > Isn't this self-sabotaging?!
> 
> Yeah, this is a known "issue". I'm saying "issue" because at worst
> it'd allow a few unnecessary deferred probes. And if you want to break
> or get fw_devlink to ignore your child devices or your consumers,
> there are simpler APIs to do it without having to intentionally defer
> a probe.  Fixing this "issue" would just use up more memory and
> increase boot time for no meaningful benefit.

But I mean, if the goal of fw_devlink is to infer a probing order based
on phandles, and it is faced with a long chain of devices, then any
-EPROBE_DEFER of a device on top of the chain will break the probing
order for all devices beneath it. It is self-defeating, it is already
memory used for nothing.

> > >
> > > Now generally, DSA drivers defer probing because they probe in parallel
> > > with the DSA master. This is typical if the switch is on a SPI bus, or
> > > I2C, or on an MDIO bus provided by a _standalone_ MDIO controller.
> > >
> > > If the MDIO controller is not standalone, but is provided by Ethernet
> > > controller that is the DSA master itself, then things change a lot,
> > > because probing can never be parallel. The DSA master probes,
> > > initializes its MDIO bus, and this triggers the probing of the MDIO
> > > devices on that bus, one of which is the DSA switch. So DSA can no
> > > longer defer the probe due to that reason.
> > >
> > > Secondly, in DSA we even have variation between drivers as to where they
> > > register their internal MDIO buses. The mv88e6xxx driver does this in
> > > mv88e6xxx_probe (the probe function on the MDIO bus). The rtl8366rb
> > > driver calls realtek_smi_setup_mdio() from rtl8366rb_setup(), and this
> > > is important. DSA provides drivers with a .setup() callback, which is
> > > guaranteed to take place after nothing can defer the switch's probe
> > > anymore.
> > >
> > > So putting two and two together, sure enough, if I move mv88e6xxx_mdios_register
> > > from mv88e6xxx_probe to mv88e6xxx_setup, then I can reliably break this
> > > setup, because the device links framework isn't sabotaging itself anymore.
> > >
> > > Conversely, I am pretty sure that if rtl8366rb was to call of_mdiobus_register()
> > > from the probe method and not the setup method, the entire design issue
> > > with interrupts on internal DSA switch ports would have went absolutely
> > > unnoticed for a few more years.
> > >
> > > I have not tested this, but it also seems plausible that DSA can
> > > trivially and reliably bypass any fw_devlink=on restrictions by simply
> > > moving all of_mdiobus_register() driver calls from the .setup() method
> > > to their respective probe methods (prior to calling dsa_register_switch),
> > > then effectively fabricate an -EPROBE_DEFER during the first probe attempt.
> > > I mean, who will know whether that probe deferral request was justified
> > > or not?
> >
> > Pushing the thought even further, it is not even necessary to move the
> > of_mdiobus_register() call to the probe function. Where it is (in .setup)
> > is already good enough. It is sufficient to return -EOPNOTSUPP once
> > (the first time) immediately _after_ the call to of_mdiobus_register
> > (and have a proper error path, i.e. call mdiobus_unregister too).
> 
> Right, there are plenty of ways to intentionally break fw_devlink. I
> hope that's not the point :) And I don't think -EOPNOTSUPP would work
> because your device wouldn't be probed again.

Yes, -EPROBE_DEFER is what I meant.

> >
> > > Anyway, I'm not sure everyone agrees with this type of "solution" (even
> > > though it's worth pointing it out as a fw_devlink limitation). In any
> > > case, we need some sort of lightweight "fix" to the chicken-and-egg
> > > problem, which will give me enough time to think of something better.
> 
> I think the generic DSA patch I gave would be the lightweight fix to
> address this chicken-and-egg issue.
> 
> As for the long term fix, I'd really suggest looking into using the
> component device model. I'd even be happy to help make any driver
> core/component device improvements you might need.
> 
> I'm also interested in looking into improving the PHY probing so that
> the genphy never probes a device that has a driver that could probe
> it. Even outside of all this fw_devlink thing, they way PHY is handled
> now, if any of the supplier really isn't ready yet (say a clock), then
> the genphy gets used -- which isn't good.

I think this is the real problem which needs to be addressed. The
trouble is, I don't know if phy_attach_direct can find out the reason
for which d->driver is NULL, i.e. that there was a driver which matched
and attempted the probe, but returned -EPROBE_DEFER.

> -Saravana
> 
> > > I hope it is at least clearer now that there are subtleties and nuances,
> > > and we cannot just assess how many boards are broken by looking at the
> > > device trees. By design, all are, sure, but they might still work, and
> > > that's better than nothing...
