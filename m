Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB583F8F53
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243442AbhHZT5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhHZT5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:57:32 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6B0C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:56:44 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id a93so8186432ybi.1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JFAHUDZyyahIcWw7Cvy/uu3QfGKT8k+W/eOL0ZhDFn8=;
        b=c+HL58Mpu2qY6DsQ+9tdT8HIhGv/o4TXrZcytK40XxfLh9zT8seGs3u5kCCzTcU003
         jdsJW57wCClGc++F1QNvfZVWckvIeVg0m3pgIollN6wnDlvbpKmO8/miYyJzHVAHwqkC
         ldYQc3mdQaenCOiXecR7PJH7eRuc9AjV1o6RuGNLGz2YZSD0qVK/7TQkQxmbQ/jkgT+X
         nmeaxdvhysNcdyvv/ANfl53RKclFCFliPC8zLxzi7YT8FGBuC4lw7koeJKvbpeSD68dK
         4ztpfrk9xmB5hKJEKdcjcSrd9O+IUErBt0tovr4zKJC8W60FqaavUtcgHQDOAEdV9KqE
         EGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JFAHUDZyyahIcWw7Cvy/uu3QfGKT8k+W/eOL0ZhDFn8=;
        b=hvwpulH47JQWZWAV/fYr5GNRgEr4lO9/TgnwnamBpXda2ysaIkj4qua55uCQfOKcpf
         9JH/QEZso7f/mLs7fNn+BEL0xGdAmtP/UUVtwpk1MnHwQruv749cmAwYh28CqC5NPVMC
         jDluS/dCylZ8didBYB2B8IvEgFTqb/rG9OQ3HN3ydR4zbgyNPmT8J/AV1u/JawlGyo/B
         FTDkSucR52zgcd8HPezbMLX1KAeoQpN01ARBlXAeXfVteT0ZW8fOP79nxQc/ARAyXAGH
         y0yvtCa1rpasJIYdPfA9SlO7JzdAtblXFbA2UQgFasxW1JhcI1MeX6N4N/yXf+42w27a
         K+mw==
X-Gm-Message-State: AOAM531Xx1753Rw9inv52avAhjyJpnLwocz8Q7VbjFZQPRIt6OcsK1Tr
        meSMiO83BJQmQa4V3B6eEpcbIel19SN3z4BZAVPBGQ==
X-Google-Smtp-Source: ABdhPJzBanXg7oKhlkUNt9M+hgCQcqMj4csOvmzyt41Q9AP5DJSOE8icqZgGfMzxdnGjwp2AlOc5gP15GOVzMlQ6fHQ=
X-Received: by 2002:a25:bdc6:: with SMTP id g6mr552373ybk.310.1630007803595;
 Thu, 26 Aug 2021 12:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210826074526.825517-1-saravanak@google.com> <20210826074526.825517-2-saravanak@google.com>
 <YSeTdb6DbHbBYabN@lunn.ch>
In-Reply-To: <YSeTdb6DbHbBYabN@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 26 Aug 2021 12:56:07 -0700
Message-ID: <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
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

Greg, Florian, Vladimir, Alvin,

Let's continue the rest of the discussion here.

On Thu, Aug 26, 2021 at 6:13 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Aug 26, 2021 at 12:45:24AM -0700, Saravana Kannan wrote:
> > If a parent device is also a supplier to a child device, fw_devlink=on
> > (correctly) delays the probe() of the child device until the probe() of
> > the parent finishes successfully.
> >
> > However, some drivers of such parent devices (where parent is also a
> > supplier) incorrectly expect the child device to finish probing
> > successfully as soon as they are added using device_add() and before the
> > probe() of the parent device has completed successfully.
>
> Please can you point at the code making this assumption. It sounds
> like we are missing some EPROBE_DEFER handling in the driver, or maybe
> the DSA framework.

For context, this was discussed and explained in [1] and subsequent
replies. But let me summarize it here.

Alvin reported an issue that with fw_devlink=on, his downstream
hardware which is very similar to [2] doesn't have its PHYs probed
correctly. Instead of the PHYs being probed by the specific driver, it
gets probed by the "Generic PHY" driver. For those who aren't very
familiar with PHYs/networking (this is based on what Andrew explained
to me earlier), Ethernet PHYs follow a specific standard and can have
some extended functionality. The specific driver would give the full
functionality, but if it's not available when the PHY needs to be
used/connected, the generic PHY driver is force bound to the PHY and
it gives the basic functionality.

So upon digging into this, this is what I found and where I think we
have some bad assumptions about the driver core are present:

The  DT node in [2] is probed by realtek_smi_probe() [3]. The call flow is:
realtek_smi_probe()
  -> dsa_register_switch()
    -> dsa_switch_probe()
      -> dsa_tree_setup()
        -> dsa_tree_setup_switches()
          -> dsa_switch_setup()
            -> ds->ops->setup(ds)
              -> rtl8366rb_setup()
                -> realtek_smi_setup_mdio()
                  -> of_mdiobus_register()
                     This scans the MDIO bus/DT and device_add()s the PHYs
          -> dsa_port_setup()
            -> dsa_port_link_register_of()
              -> dsa_port_phylink_register()
                -> phylink_of_phy_connect()
                  -> phylink_fwnode_phy_connect()
                    -> phy_attach_direct()
                       This checks if PHY device has already probed (by
                       checking for dev->driver). If not, it forces the
                       probe of the PHY using one of the generic PHY
                       drivers.

So within dsa_register_switch() the PHY device is added and then
expected to have probed in the same thread/calling context. As stated
earlier, this is not guaranteed by the driver core. And this is what
needs fixing. This works as long as the PHYs don't have dependencies
on any other devices/suppliers and never defer probe. In the issue
Alvin reported, the PHYs have a dependency and things fall apart. I
don't have a strong opinion on whether this is a framework level fix
or fixes in a few drivers.

In the specific instance of [2] (providing snippet below to make it
easier to follow), the "phy0" device [4] depends on the "switch"
device [2] since "switch_intc" (the interrupt provider for phy0) is
initialized by the "switch" driver. And fw_devlink=on delays the probe
of phy0 until switch[2] finishes probing successfully (i.e. after
dsa_register_switch() <- realtek_smi_probe() returns) -- this is the
whole point of fw_devlink=on this is what reduces the useless deferred
probes/probe attempts of consumers before the suppliers finish probing
successfully.

Since dsa_register_switch() assumes the PHYs would have been probed as
soon as they are added, but they aren't probed in this case, the PHY
is force bound to the generic PHY driver. Which is the original issue
Alvin reported. Hope this clears things up for everyone.

-Saravana

switch {
        compatible = "realtek,rtl8366rb";
...

        switch_intc: interrupt-controller {
...
        };

        ports {
...
                port@0 {
                        phy-handle = <&phy0>;
                };
                port@1 {
                };
...
        };

        mdio {
                compatible = "realtek,smi-mdio";
...
                phy0: phy@0 {
...
                        interrupt-parent = <&switch_intc>;
                        interrupts = <0>;
                };
...
        };
};

[1] - https://lore.kernel.org/netdev/CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com/
[2] - https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/gemini-dlink-dir-685.dts?id=73f3af7b4611d77bdaea303fb639333eb28e37d7#n190
[3] - https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/dsa/realtek-smi-core.c?id=73f3af7b4611d77bdaea303fb639333eb28e37d7#n386
[4] - https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/gemini-dlink-dir-685.dts?id=73f3af7b4611d77bdaea303fb639333eb28e37d7#n255
