Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848D43F2421
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 02:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbhHTAiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 20:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbhHTAiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 20:38:01 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED28BC061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 17:37:23 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id b10so16445613eju.9
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 17:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0WrBzrFdMHpISpwkt85R9ymOlUXjjFjCXeXiJBYzAgg=;
        b=W9gB40yG2GImQpvTgu7QQx5YCOpfPHGoxtb2C1FjKIjI+QtH5Ork5Rt6iJFJNp+TXM
         sJS7InCqRVFK2NF8tlq7psDRWWwnVzgpMSa3gGToxQ3uLddXZcXWsomy1Xk4WztpHHY3
         e/711cOANfN1s5m1Lbqxn9FMtH5wwPxRUwm0kqjd5d7nHJ832V8Q6kBXzdM1idrH+Qlk
         HLCuZ7YBTjZZF41VW3A7Q5KQHHREtQQS1aDW7k6ZQal+vjSW6OFeqaj773iT4WOT4F9m
         XlE5GWiRyjvZEdI6324rqRFh/wPGIEJRetkCl/nITwP0ZGB2ouJYXmmNj76ZXxkbi5Np
         WR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0WrBzrFdMHpISpwkt85R9ymOlUXjjFjCXeXiJBYzAgg=;
        b=KAnBr9ddl23EWGAIcFnIaAjrNpuMNqfz60RWMgMoAutKIHtG/sBkqf6lhQPW6Vm8Dm
         8zgr5a/AqKXeIB4EoD1fibWG2YndXwS82CT1ZhTWFQc1a0u9qWfZbew95X5a+hFe3zgn
         C2OrOU/2zvnd10JyyUwZQYSioXiVZv5I/oak23MicB9C5YY00DFlzULGSffKeGHdSiAz
         Dc33Rxog7L/4ZlM1vhmsTJMgV7swFLvVwZpkTge4/76AKNHqds1efT/mM0X4gqJyLMw+
         nGpetfrJsfo5qsQfWsWL3qctWdxRW5/nbA1wWh1bsIo4c1pQxhlmRFMSsNhshDzBcF1C
         zyYQ==
X-Gm-Message-State: AOAM5333nuU3BtVpC0NxW/H2FhTt3PBvCGXU+OGmAs1I1G7HzI4vkxbY
        ghs47YQhkZ1iUPv/X7ggkqc=
X-Google-Smtp-Source: ABdhPJxfXb++REcisDtE8vgRXBFHITCwrgEMdKDXWWTcoFQCOD5rQ50xI59ulTKkDK/ZbVVmTUgvTQ==
X-Received: by 2002:a17:906:eda3:: with SMTP id sa3mr19003940ejb.451.1629419842549;
        Thu, 19 Aug 2021 17:37:22 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id z6sm2580575edc.52.2021.08.19.17.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 17:37:22 -0700 (PDT)
Date:   Fri, 20 Aug 2021 03:37:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Message-ID: <20210820003720.fieifa5sa457q76r@skbuf>
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
 <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk>
 <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <YR5eMeKzcuYtB6Tk@lunn.ch>
 <CAGETcx9=AyEfjX_-adgRuX=8a0MkLnj8sy2KJGhxpNCinJu4yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx9=AyEfjX_-adgRuX=8a0MkLnj8sy2KJGhxpNCinJu4yA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 04:52:43PM -0700, Saravana Kannan wrote:
> On Thu, Aug 19, 2021 at 6:35 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > (2) is what is happening in this case. fw_devlink=on sees that
> > > "switch" implements the "switch_intc" and "switch" hasn't finished
> > > probing yet. So it has no way of knowing that switch_intc is actually
> > > ready. And even if switch_intc was registered as part of switch's
> > > probe() by the time the PHYs are added, switch_intc could get
> > > deregistered if the probe fails at a later point. So until probe()
> > > returns 0, fw_devlink can't be fully sure the supplier (switch_intc)
> > > is ready. Which is good in general because you won't have to
> > > forcefully unbind (if that is even handled correctly in the first
> > > place) the consumers of a device if it fails probe() half way through
> > > registering a few services.
> 
> I had to read your email a couple of times before I understood it. I
> think I do now, but apologies if I'm not making sense.
> 
> >
> > There are actually a few different circular references with the way
> > switches work. Take for example:
> >
> > &fec1 {
> >         phy-mode = "rmii";
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&pinctrl_fec1>;
> >         status = "okay";
> >
> >         fixed-link {
> >                 speed = <100>;
> >                 full-duplex;
> >         };
> >
> >         mdio1: mdio {
> >                 #address-cells = <1>;
> >                 #size-cells = <0>;
> >                 clock-frequency = <12500000>;
> >                 suppress-preamble;
> >                 status = "okay";
> >
> >                 switch0: switch0@0 {
> >                         compatible = "marvell,mv88e6190";
> >                         pinctrl-0 = <&pinctrl_gpio_switch0>;
> >                         pinctrl-names = "default";
> >                         reg = <0>;
> >                         eeprom-length = <65536>;
> >                         interrupt-parent = <&gpio3>;
> >                         interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
> >                         interrupt-controller;
> >                         #interrupt-cells = <2>;
> >
> >                         ports {
> >                                 #address-cells = <1>;
> >                                 #size-cells = <0>;
> >
> >                                 port@0 {
> >                                         reg = <0>;
> >                                         label = "cpu";
> >                                         ethernet = <&fec1>;
> >
> >                                         fixed-link {
> >                                                 speed = <100>;
> >                                                 full-duplex;
> >                                         };
> >                                 };
> >
> > FEC is an ethernet controller. It has an MDIO bus, and on the bus is
> > an Ethernet switch. port 0 of the Ethernet switch is connected to the
> > FEC ethernet controller.
> >
> > While the FEC probes, it will at some point register its MDIO bus. At
> > that point, the MDIO bus is probed, the switch is found, and
> > registered with the switch core. The switch core looks for the port
> > with an ethernet property and goes looking for that ethernet
> > interface. But that this point in time, the FEC probe has only got as
> > far as registering the MDIO bus. The interface itself is not
> > registered. So finding the interface fails, and we go into
> > EPROBE_DEFER for probing the switch.
> 
> Ok, I understood up to here. Couple of questions:
> Is this EPROBE_DEFER causing an issue? Wouldn't the switch then
> probe successfully when it's reattempted? And then things work
> normally? I don't see what the problem is.

It's not an issue per se, since it's not a fully circular dependency:
the DSA master (the FEC controller) does not have any dependency on the
switch beneath it to probe (there's nothing like a phy-handle from the
FEC to the switch or to something provided by it).

A few EPROBE_DEFER iterations later the switch will finally find its DSA
master fully probed via of_find_net_device_by_node.

Andrew is wondering how to avoid those extra EPROBE_DEFER iterations.
It is weird that the entire functionality of the system depends on those
EPROBE_DEFERs, typically you'd expect that EPROBE_DEFER just serializes
asynchronous probing of drivers with interdependencies. But in this case
it serializes synchronous probing.

> > It is pretty hard to solve. An Ethernet interface can be used by the
> > kernel itself, e.g. NFS root. At the point you call register_netdev()
> > in the probe function, to register the interface with the core,
> 
> Are you using "ethernet interface" and "ethernet controller"
> interchangeably? Looking at some other drivers, it looks like the
> ethernet controlled (FEC) is what would call register_netdev(). So
> what's wrong with that happening if switch0 has not probed
> successfully?

The "interface" and "controller" terms are not really interchangeable,
an interface can also be virtual (stacked interfaces on top of physical
ones, like VLAN or DSA) while network controllers are typically physical
(unless emulated). But that is not of importance.

The context here is that you cannot solve the interdependency by
registering the DSA master (FEC) first, then its MDIO bus second (the
DSA switch probes on the DSA master's MDIO bus => if you do this,
of_find_net_device_by_node from the DSA layer would find its master the
first time). The reason you cannot do that is because you need the MDIO
bus for really basic stuff: you also have your Ethernet PHY on it, and
you need to initialize that in order to send traffic. And you need to be
able to send traffic as soon as register_netdev() completes.

So since the driver initialization sequence has a single written order
regardless of whether DSA switches are attached or not, that order is
picked to be the one where traffic works as soon as register_netdev completes.

> > it
> > needs to be fully ready to go.  The networking stack can start using
> > the interface before register_netdev() even returns. So you cannot
> > first register the interface and then register the MDIO bus.
> >
> > I once looked to see if it was possible to tell the driver core to not
> > even bother probing a bus as soon as it is registered, go straight to
> > defer probe handling. Because this is one case we know it cannot
> > work. But it does not seem possible.
> 
> fw_devlink doesn't understand the "ethernet" property. If I add that,
> then in the example you state above, switch0's probe won't even be
> called until the FEC probe returns. The change is pretty trivial
> (pasted below) -- can you try it out and tell me if it does what you
> need/want?
> 
> -Saravana
> 
> +++ b/drivers/of/property.c
> @@ -1292,6 +1292,7 @@ DEFINE_SIMPLE_PROP(resets, "resets", "#reset-cells")
>  DEFINE_SIMPLE_PROP(leds, "leds", NULL)
>  DEFINE_SIMPLE_PROP(backlight, "backlight", NULL)
>  DEFINE_SIMPLE_PROP(phy_handle, "phy-handle", NULL)
> +DEFINE_SIMPLE_PROP(ethernet, "ethernet", NULL)
>  DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
>  DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
> 
> @@ -1381,6 +1382,7 @@ static const struct supplier_bindings
> of_supplier_bindings[] = {
>         { .parse_prop = parse_leds, },
>         { .parse_prop = parse_backlight, },
>         { .parse_prop = parse_phy_handle, },
> +       { .parse_prop = parse_ethernet, },
>         { .parse_prop = parse_gpio_compat, },
>         { .parse_prop = parse_interrupts, },
>         { .parse_prop = parse_regulators, },

I don't have this exact setup to test, so I'll let Andrew do it, but I
have a question: DSA sets up a device link to its master in dsa_master_setup.
It does this to autoremove itself when the DSA master gets removed, but
fundamentally it does it after the entire EPROBE_DEFER shebang discussed
above has already happened. If your patch works, we can drop the manually
added device link, right?

There's also the question of what to do in case of multiple DSA masters
(multiple "ethernet" properties). Right now, if you describe two DSA
masters in the device tree, DSA will pick the first DSA master and use
just that (it doesn't have full support for more than one). But even
though the second DSA master is not used for anything, with your change,
unbinding it will also unbind the switch, will it not?
