Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D263FD0D1
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbhIABjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241332AbhIABja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:39:30 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154E8C061575;
        Tue, 31 Aug 2021 18:38:34 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u15-20020a05600c19cf00b002f6445b8f55so422187wmq.0;
        Tue, 31 Aug 2021 18:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c49lwdNA/4qGxRGlAzlwlSfsQDVL/K1bY/Nkb8zzaXg=;
        b=AbMa/KUyypBDufyOqz4wJPuw2x+lZdQCoFLpvgMy1W6uw5FFb47QtRwmaXdxHZbxFu
         yTlJNChjDVVFqfqwjQFL5Zfa78dJ1b7lLidnPy7/L9zAOTi6cH+eUquKvfbqACP7b4yR
         TV9U8Jlx6XXKJaf6IDRSKBa8NDrqn/e0SavG3eDPxb2VyAxOPyW3QI7tMixIB64rzVNh
         5yhSLKd5Nou51cWoeSN4tHvbnoDSPg8FTB952BWNazDjQbcCjZkn7m0iMfcCrjs5840V
         1o5/ctKk7SdhfXEemg0a03wUd4ldy39qYRiiQ4G6KDGBVhNl5HtpsW26i0nYp13en3tt
         tOzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c49lwdNA/4qGxRGlAzlwlSfsQDVL/K1bY/Nkb8zzaXg=;
        b=OD96m+yMFoy1CrpSEaKygsLRPu2JrD/bvIkrPFLfxBvenIDyCU+dTHXGgwEUHR6UxD
         xjZ7IFlF5u1r998C52r0X1GOSqgNYJMuiu4/5+VNxg6IyrVi0qZka7KtfcIuCLoPIm2A
         WEYh/1N3KCzK1JRNQaV5rzOMCCGM3FpVYNQ42n0xeJ5qJlPl8C/v7nnzw2o5LpQjCdjn
         o+5JglkYcETwu3y3RUiDQ682aJTdRxhid0tNuH4tHhydlMlq3aY2Bv0Xw0bBVivV/Vu+
         qqhl3RPfiO3AiorP2kXqnbNpb450OUXJlGoeStnW71viQSiNGcxn9duZCeUEsc+V/MsK
         W9sQ==
X-Gm-Message-State: AOAM530B1WWvR4CqyUaI/0I8gjekcWSOgIjljt0Vp8qlF/9os5BRn7qW
        v6JWobzwqMjXzfouzr5wb5o=
X-Google-Smtp-Source: ABdhPJzKmvo340pSwM8AWaBWhIsp3haAr5eQW7IdhXgF35mMM0RkJysBNtGnwqClIIBpbb/2TR7A4A==
X-Received: by 2002:a05:600c:219:: with SMTP id 25mr6838668wmi.157.1630460312645;
        Tue, 31 Aug 2021 18:38:32 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id d6sm17752023wra.5.2021.08.31.18.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 18:38:32 -0700 (PDT)
Date:   Wed, 1 Sep 2021 04:38:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Saravana Kannan <saravanak@google.com>,
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
Message-ID: <20210901013830.yst73ubhsrlml54i@skbuf>
References: <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
 <20210831231804.zozyenear45ljemd@skbuf>
 <20210901012826.iuy2bhvkrgahhrl7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901012826.iuy2bhvkrgahhrl7@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 04:28:26AM +0300, Vladimir Oltean wrote:
> On Wed, Sep 01, 2021 at 02:18:04AM +0300, Vladimir Oltean wrote:
> > On Wed, Sep 01, 2021 at 01:02:09AM +0200, Andrew Lunn wrote:
> > > Rev B is interesting because switch0 and switch1 got genphy, while
> > > switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
> > > interrupt properties, so don't loop back to their parent device.
> > 
> > This is interesting and not what I really expected to happen. It goes to
> > show that we really need more time to understand all the subtleties of
> > device dependencies before jumping on patching stuff.
> 
> There is an even more interesting variation which I would like to point
> out. It seems like a very odd loophole in the device links.
> 
> Take the example of the mv88e6xxx DSA driver. On my board
> (arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts), even after I
> had to declare the switches as interrupt controller and add interrupts
> to their internal PHYs, I still need considerable force to 'break' this
> board in the way discussed in this thread. The correct PHY driver insists
> to probe, and not genphy. Let me explain.
> 
> The automatic device links between the switch (supplier, as interrupt-controller)
> and PHYs (consumers) are added by fwnode_link_add, called from of_link_to_phandle.
> 
> Important note: fwnode_link_add does not link devices, it links OF nodes.
> 
> Even more important node, in the form of a comment:
> 
>  * The driver core will use the fwnode link to create a device link between the
>  * two device objects corresponding to @con and @sup when they are created. The
>  * driver core will automatically delete the fwnode link between @con and @sup
>  * after doing that.
> 
> Okay?!
> 
> What seems to be omitted is that the DSA switch driver's probing itself
> can be deferred. For example:
> 
> dsa_register_switch
> -> dsa_switch_probe
>    -> dsa_switch_parse_of
>       -> dsa_switch_parse_ports_of
>          -> dsa_port_parse_of
>             -> of_find_net_device_by_node(of_parse_phandle(dn, "ethernet", 0));
>             -> not found => return -EPROBE_DEFER
> 
> When dsa_register_switch() returns -EPROBE_DEFER, it is effectively
> an error path. So the reverse of initialization is performed.
> 
> The mv88e6xxx driver calls mv88e6xxx_mdios_register() right _before_
> dsa_register_switch. So when dsa_register_switch returns error code,
> mv88e6xxx_mdios_unregister() will be called.
> 
> When mv88e6xxx_mdios_unregister() is called, the MDIO buses with
> internal PHYs are destroyed. So the PHY devices themselves are destroyed
> too. And the device links between the DSA switch and the internal PHYs,
> those created based on the firmware node links created by fwnode_link_add,
> are dropped too.
> 
> Now remember the comment that the device links created based on
> fwnode_link_add are not restored.
> 
> So probing of the DSA switch finally resumes, and this time
> device_links_check_suppliers() is effectively bypassed, the PHYs no
> longer request probe deferral due to their supplier not being ready,
> because the device link no longer exists.
> 
> Isn't this self-sabotaging?!
> 
> Now generally, DSA drivers defer probing because they probe in parallel
> with the DSA master. This is typical if the switch is on a SPI bus, or
> I2C, or on an MDIO bus provided by a _standalone_ MDIO controller.
> 
> If the MDIO controller is not standalone, but is provided by Ethernet
> controller that is the DSA master itself, then things change a lot,
> because probing can never be parallel. The DSA master probes,
> initializes its MDIO bus, and this triggers the probing of the MDIO
> devices on that bus, one of which is the DSA switch. So DSA can no
> longer defer the probe due to that reason.
> 
> Secondly, in DSA we even have variation between drivers as to where they
> register their internal MDIO buses. The mv88e6xxx driver does this in
> mv88e6xxx_probe (the probe function on the MDIO bus). The rtl8366rb
> driver calls realtek_smi_setup_mdio() from rtl8366rb_setup(), and this
> is important. DSA provides drivers with a .setup() callback, which is
> guaranteed to take place after nothing can defer the switch's probe
> anymore.
> 
> So putting two and two together, sure enough, if I move mv88e6xxx_mdios_register
> from mv88e6xxx_probe to mv88e6xxx_setup, then I can reliably break this
> setup, because the device links framework isn't sabotaging itself anymore.
> 
> Conversely, I am pretty sure that if rtl8366rb was to call of_mdiobus_register()
> from the probe method and not the setup method, the entire design issue
> with interrupts on internal DSA switch ports would have went absolutely
> unnoticed for a few more years.
> 
> I have not tested this, but it also seems plausible that DSA can
> trivially and reliably bypass any fw_devlink=on restrictions by simply
> moving all of_mdiobus_register() driver calls from the .setup() method
> to their respective probe methods (prior to calling dsa_register_switch),
> then effectively fabricate an -EPROBE_DEFER during the first probe attempt.
> I mean, who will know whether that probe deferral request was justified
> or not?

Pushing the thought even further, it is not even necessary to move the
of_mdiobus_register() call to the probe function. Where it is (in .setup)
is already good enough. It is sufficient to return -EOPNOTSUPP once
(the first time) immediately _after_ the call to of_mdiobus_register
(and have a proper error path, i.e. call mdiobus_unregister too).

> Anyway, I'm not sure everyone agrees with this type of "solution" (even
> though it's worth pointing it out as a fw_devlink limitation). In any
> case, we need some sort of lightweight "fix" to the chicken-and-egg
> problem, which will give me enough time to think of something better.
> I hope it is at least clearer now that there are subtleties and nuances,
> and we cannot just assess how many boards are broken by looking at the
> device trees. By design, all are, sure, but they might still work, and
> that's better than nothing...
