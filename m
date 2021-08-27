Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC15D3F9E81
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhH0SHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhH0SHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 14:07:33 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205FDC061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:06:43 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id k78so10866611ybf.10
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O3s9f2E13tixtnr2/bSCIqrGke2AT2NqpZMSk6hvRH4=;
        b=iuYQyFkQ5/TL5cX/RcHE6ZJmiwGbWZOTcby02j5+FDFOpAACobkcqWsDgAQ7tN+f8D
         6aRyKMt2ni6tx77v9wCE1vdEYmTnaErgw7VkZkQbwI0upEDvlH5rL8ZQG4t+oCYG6n7Q
         el48MNbJC9GRrvaG7fasRjdlNOmR6VkLbusayWLOiR2xhTkBOV+RG67F+C1QvcsU/mxS
         Wud9BnYML+OwIFs9Ocol/fyDnW3vc1j51BKg3tjXO9g/ayDj8HoyNNMvt0bHQkjdFV0z
         PaNy4akTzhgelUE3DUaD0nH88K2a8KH0620tunULdaMbUu+fkWCkDzg/m27KBduBXcpM
         eu8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O3s9f2E13tixtnr2/bSCIqrGke2AT2NqpZMSk6hvRH4=;
        b=pCSjaV2nwCyQDxzSOhBmw/kpyZvIokPNoQVo0zdPAcwmbKbHcHR+r1uV3q582Zaqe+
         b6H7aJ3M44jKfRHl5YuPqCHUyc2nFjgp1PpXqm5bhzo8QwflLtStHEIzZ2nvEeMQYFpZ
         RXL27CuRlfzJYzUOye+bapuNTSKvfIdEnm3L2xLWAxMHtle/XgyRZ6DLu+/xvcT4yThU
         pIbVwF0HiOjT3a9ul6Qis4utH5C0s+3vHOjeHiQWs4/n9x2de3P4OnwAiuwzO7pDWjng
         IpY6Yuleyk8DYnVQtPGmUS0NO6em+Owp6VFuEC0WX6NnKl7sei+DOosG3uo2USVhJydO
         Bpkg==
X-Gm-Message-State: AOAM533hruKhATcQk6XWFHtgr1MQ9ho3/Qoaqvs1CCU/zMNkeyuofH6p
        6qhpqzag2+n45zbRoOiza1uF83FPJACB3VayXkPlVA==
X-Google-Smtp-Source: ABdhPJw4/QH4Iv/xsSGLNMlZDjMdvel/IZrlut9sCt20+4zJjDhDXplBmcxT9YWjQWNStv1ojMkU3KS4MPKveBIYXys=
X-Received: by 2002:a5b:50b:: with SMTP id o11mr6910997ybp.466.1630087602090;
 Fri, 27 Aug 2021 11:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210826074526.825517-1-saravanak@google.com> <20210826074526.825517-2-saravanak@google.com>
 <YSeTdb6DbHbBYabN@lunn.ch> <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
 <YSf/Mps9E77/6kZX@lunn.ch> <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch> <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch>
In-Reply-To: <YSjsQmx8l4MXNvP+@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 27 Aug 2021 11:06:06 -0700
Message-ID: <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 6:44 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > fw_devlink=on/device links short circuits the probe() call of a
> > consumer (in this case the PHY) and returns -EPROBE_DEFER if the
> > supplier's (in this case switch) probe hasn't finished without an
> > error. fw_devlink/device links effectively does the probe in graph
> > topological order and there's a ton of good reasons to do it that way
> > -- what's why fw_devlink=on was implemented.
> >
> > In this specific case though, since the PHY depends on the parent
> > device, if we fail the parent's probe realtek_smi_probe() because the
> > PHYs failed to probe, we'll get into a catch-22/chicken-n-egg
> > situation and the switch/PHYs will never probe.
>
> So lets look at:
>
> arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
>
>        mdio-mux {
>                 compatible = "mdio-mux-gpio";
>                 pinctrl-0 = <&pinctrl_mdio_mux>;
>                 pinctrl-names = "default";
>                 gpios = <&gpio0 8  GPIO_ACTIVE_HIGH
>                          &gpio0 9  GPIO_ACTIVE_HIGH
>                          &gpio0 24 GPIO_ACTIVE_HIGH
>                          &gpio0 25 GPIO_ACTIVE_HIGH>;
>                 mdio-parent-bus = <&mdio1>;
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>
>
> We have an MDIO multiplexor
>
>
>                 mdio_mux_1: mdio@1 {
>                         reg = <1>;
>                         #address-cells = <1>;
>                         #size-cells = <0>;
>
>                         switch0: switch@0 {
>                                 compatible = "marvell,mv88e6085";
>                                 pinctrl-0 = <&pinctrl_gpio_switch0>;
>                                 pinctrl-names = "default";
>                                 reg = <0>;
>                                 dsa,member = <0 0>;
>                                 interrupt-parent = <&gpio0>;
>                                 interrupts = <27 IRQ_TYPE_LEVEL_LOW>;
>
> On the first bus, we have a Ethernet switch.
>
>                                 interrupt-controller;
>                                 #interrupt-cells = <2>;
>                                 eeprom-length = <512>;
>
>                                 ports {
>                                         #address-cells = <1>;
>                                         #size-cells = <0>;
>
>                                         port@0 {
>                                                 reg = <0>;
>                                                 label = "lan0";
>                                                 phy-handle = <&switch0phy0>;
>                                         };
>
> The first port of that switch has a pointer to a PHY.
>
>                                mdio {
>                                         #address-cells = <1>;
>                                         #size-cells = <0>;
>
> That Ethernet switch also has an MDIO bus,
>
>                                         switch0phy0: switch0phy0@0 {
>                                                 reg = <0>;
>
> On that bus is the PHY.
>
>                                                 interrupt-parent = <&switch0>;
>                                                 interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;
>
> And that PHY has an interrupt. And that interrupt is provided by the switch.
>
> Given your description, it sounds like this is also go to break.

Based on what you pasted here (I didn't look any closer), I think it
will break too.

>
> vf610-zii-dev-rev-c.dts is the same pattern, and there are more
> examples for mv88e6xxx.
>
> It is a common pattern, e.g. the mips ar9331.dtsi follows it.

Then I think this should be solved at the DSA framework level. Make a
component-master/aggregate device made up of the switches and
ports/PHYs. Then wait for all of them to not -EPROBE_DEFER and then
initialize the DSA?

> I've not yet looked at plain Ethernet drivers. This pattern could also
> exist there. And i wonder about other complex structures, i2c bus
> multiplexors, you can have interrupt controllers as i2c devices,
> etc. So the general case could exist in other places.

I haven't seen any generic issues like this reported so far. It's only
after adding phy-handle that we are hitting these issues with DSA
switches.

> I don't think we should be playing whack-a-mole by changing drivers as
> we find they regress and break. We need a generic fix. I think the
> solution is pretty clear. As you said the device depends on its
> parent. DT is a tree, so it is easy to walk up the tree to detect this
> relationship, and not fail the probe.

It's easy to do, but it is the wrong behavior for fw_devlink=on. There
are plenty of cases where it's better to delay the child device's
probe until the parent finishes. You even gave an example[7] where it
would help avoid unnecessary deferred probes. There are plenty of
other cases like this too -- there's actually a USB driver that had an
infinite deferred probe loop that fw_devlink=on fixes. Also, the whole
point of fw_devlink=on is to enforce ordering like this -- so just
blanket ignoring dependencies on parent devices doesn't make sense.

But a parent device's probe depending on a child device's probe to
succeed as soon as it's added is never right though. So I think that's
what needs to be addresses.

So we have a couple of options:
1. Use a component driver model to initialize switches. I think it
could be doable at the DSA framework level.
2. Ask fw_devlink=on to ignore it for all switch devices -- it might
be possible to move my "quick fix" to the DSA framework.
3. Remove fw_devlink support for phy-handle.

I honestly think (1) is the best option and makes sense logically too.
Not saying it's a trivial work or a one liner, but it actually makes
sense. (2) might not be possible -- I need to take a closer look. I'd
prefer not doing (3), but I'd take that over breaking the whole point
of fw_devlink=on.

-Saravana

[7] - https://lore.kernel.org/netdev/YR5eMeKzcuYtB6Tk@lunn.ch/
