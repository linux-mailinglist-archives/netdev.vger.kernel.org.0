Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39353F23DD
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 01:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236930AbhHSXx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 19:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhHSXx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 19:53:57 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D609C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 16:53:20 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id a93so15525179ybi.1
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 16:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=63KoA8xIsswXJCIPxal5wud/3rJsIkh+dfypiPGVen8=;
        b=mlykyyb6YJvqMKagkxuCgLAdk6feKw2XukuuLJkb7ooouUPNwG3MQiKpx91oqCRdFW
         eYpKMmQEGPK6zYwmlz8OpsVFekJupgtMUGxRNnNWn8YoE2l8ZHqFrN1Ec2WA+cCvy6nf
         TQkMQIMmiOjWOqbdL9ym+VXFMYmZ9JiQnDHwYbYXkE0rA337bUXwxIpKMpZZeO8rz4bx
         uc3ZmsUFdRqmEw73XPUU0TWeXn+MwtnRPFVd1HaQyPEw94FinOBJci/2ktQZ5t5dVq2i
         9pt8cgByPT47q69rkBd093dkMyb8CLJCeKyKK0bIzMUTfL259QWPsdGQAJMaKFI/gOjH
         wPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=63KoA8xIsswXJCIPxal5wud/3rJsIkh+dfypiPGVen8=;
        b=D5XPjdp6U+OTdAuK0ZZWKKSQ/miS9YlUkjMasnUdxNc9DS1UofDEL/I0ESxl5gX4Si
         tcRwkLB3YPwayz1gVmC6K5XJCSYO5y44ZcirhpZ2JyEJTflUcy9edYZZ4lfEw0BYUTu9
         cW/xVfXkXMyqUTrbkEGSF48WwnhJDlhd2nSgpeO9onSULUeBgg6TPFDDmV50dAah/UGQ
         WRX9xsdjUeEu7M1LfqZP/O0c4KGAwtE6C2HUuwqYz/YI5IcnV7hwPrqggy5ZQa+Ly9c+
         WgfeYf3VrHyrvt1jacecXWTVFAlg87oB+Sc8GJTPJzf11mYmhpJY+dC1m1N/CO6YqUKc
         gQkQ==
X-Gm-Message-State: AOAM531Rr0KJbXaXlZnvJ2l31V51qMkH9AfYRPTod1GXp3MvQj3hnozY
        oh5Qj7QVc09a1HYJ3Atrc7B5zQsbEWKZ0xY3IPVPhQ==
X-Google-Smtp-Source: ABdhPJwPOsNqUv86h/852FiFKeo/J0LYEBAGf1X3wQ5FrVYMusXbXeN0XPy5EXkM7zPrxwkij/lu115h8GAKCUL9nOU=
X-Received: by 2002:a25:804:: with SMTP id 4mr20289745ybi.346.1629417199619;
 Thu, 19 Aug 2021 16:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk> <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk> <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <YR5eMeKzcuYtB6Tk@lunn.ch>
In-Reply-To: <YR5eMeKzcuYtB6Tk@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 19 Aug 2021 16:52:43 -0700
Message-ID: <CAGETcx9=AyEfjX_-adgRuX=8a0MkLnj8sy2KJGhxpNCinJu4yA@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 6:35 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > (2) is what is happening in this case. fw_devlink=on sees that
> > "switch" implements the "switch_intc" and "switch" hasn't finished
> > probing yet. So it has no way of knowing that switch_intc is actually
> > ready. And even if switch_intc was registered as part of switch's
> > probe() by the time the PHYs are added, switch_intc could get
> > deregistered if the probe fails at a later point. So until probe()
> > returns 0, fw_devlink can't be fully sure the supplier (switch_intc)
> > is ready. Which is good in general because you won't have to
> > forcefully unbind (if that is even handled correctly in the first
> > place) the consumers of a device if it fails probe() half way through
> > registering a few services.

I had to read your email a couple of times before I understood it. I
think I do now, but apologies if I'm not making sense.

>
> There are actually a few different circular references with the way
> switches work. Take for example:
>
> &fec1 {
>         phy-mode = "rmii";
>         pinctrl-names = "default";
>         pinctrl-0 = <&pinctrl_fec1>;
>         status = "okay";
>
>         fixed-link {
>                 speed = <100>;
>                 full-duplex;
>         };
>
>         mdio1: mdio {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>                 clock-frequency = <12500000>;
>                 suppress-preamble;
>                 status = "okay";
>
>                 switch0: switch0@0 {
>                         compatible = "marvell,mv88e6190";
>                         pinctrl-0 = <&pinctrl_gpio_switch0>;
>                         pinctrl-names = "default";
>                         reg = <0>;
>                         eeprom-length = <65536>;
>                         interrupt-parent = <&gpio3>;
>                         interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
>                         interrupt-controller;
>                         #interrupt-cells = <2>;
>
>                         ports {
>                                 #address-cells = <1>;
>                                 #size-cells = <0>;
>
>                                 port@0 {
>                                         reg = <0>;
>                                         label = "cpu";
>                                         ethernet = <&fec1>;
>
>                                         fixed-link {
>                                                 speed = <100>;
>                                                 full-duplex;
>                                         };
>                                 };
>
> FEC is an ethernet controller. It has an MDIO bus, and on the bus is
> an Ethernet switch. port 0 of the Ethernet switch is connected to the
> FEC ethernet controller.
>
> While the FEC probes, it will at some point register its MDIO bus. At
> that point, the MDIO bus is probed, the switch is found, and
> registered with the switch core. The switch core looks for the port
> with an ethernet property and goes looking for that ethernet
> interface. But that this point in time, the FEC probe has only got as
> far as registering the MDIO bus. The interface itself is not
> registered. So finding the interface fails, and we go into
> EPROBE_DEFER for probing the switch.

Ok, I understood up to here. Couple of questions:
Is this EPROBE_DEFER causing an issue? Wouldn't the switch then
probe successfully when it's reattempted? And then things work
normally? I don't see what the problem is.

> It is pretty hard to solve. An Ethernet interface can be used by the
> kernel itself, e.g. NFS root. At the point you call register_netdev()
> in the probe function, to register the interface with the core,

Are you using "ethernet interface" and "ethernet controller"
interchangeably? Looking at some other drivers, it looks like the
ethernet controlled (FEC) is what would call register_netdev(). So
what's wrong with that happening if switch0 has not probed
successfully?

> it
> needs to be fully ready to go.  The networking stack can start using
> the interface before register_netdev() even returns. So you cannot
> first register the interface and then register the MDIO bus.
>
> I once looked to see if it was possible to tell the driver core to not
> even bother probing a bus as soon as it is registered, go straight to
> defer probe handling. Because this is one case we know it cannot
> work. But it does not seem possible.

fw_devlink doesn't understand the "ethernet" property. If I add that,
then in the example you state above, switch0's probe won't even be
called until the FEC probe returns. The change is pretty trivial
(pasted below) -- can you try it out and tell me if it does what you
need/want?

-Saravana

+++ b/drivers/of/property.c
@@ -1292,6 +1292,7 @@ DEFINE_SIMPLE_PROP(resets, "resets", "#reset-cells")
 DEFINE_SIMPLE_PROP(leds, "leds", NULL)
 DEFINE_SIMPLE_PROP(backlight, "backlight", NULL)
 DEFINE_SIMPLE_PROP(phy_handle, "phy-handle", NULL)
+DEFINE_SIMPLE_PROP(ethernet, "ethernet", NULL)
 DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
 DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")

@@ -1381,6 +1382,7 @@ static const struct supplier_bindings
of_supplier_bindings[] = {
        { .parse_prop = parse_leds, },
        { .parse_prop = parse_backlight, },
        { .parse_prop = parse_phy_handle, },
+       { .parse_prop = parse_ethernet, },
        { .parse_prop = parse_gpio_compat, },
        { .parse_prop = parse_interrupts, },
        { .parse_prop = parse_regulators, },
