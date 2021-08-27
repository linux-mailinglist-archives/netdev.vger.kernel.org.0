Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C343F9363
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 06:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhH0EDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 00:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbhH0EDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 00:03:42 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08ECC0613CF
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 21:02:53 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id q70so10041763ybg.11
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 21:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5EX0Ib5T66NZEZQUvNen4rx8W6LbQAQc16oQp/aoMH8=;
        b=q2wz4tOPNUK/CXTrqsq327gnvpzMOo2L//zvFOMKtCAvsMZWguv+T8jRd35dUN7jm0
         3h7Vef3WRREfLGFp4HP9fb4AzB8oJNmS7Przcq/dfU5QgNU76mFG5ggqILgq63LH3fIw
         FJJZgu1FH3UTKcBOi0588DRyPPZ3DFo0mhdcqwy0wOutq9ZPY9LUBr4X/TAlMKlJ/iu1
         /EYSG7UnjZ+o2iHGPPeLeBrd0XmE5jHZICZcNESLQXv2idlHQxE2k4K4uZeRzUzfRprE
         orRrgVI+cydeAu181BPJa6GCZCIJ6URe6iQpA7AtfhvF2LI3x9HLALTjlR3cDed15lNV
         2HuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5EX0Ib5T66NZEZQUvNen4rx8W6LbQAQc16oQp/aoMH8=;
        b=pw3iPBEG77I8RW3V+S71NWHGdQzXBuHTFWh8fvytRt5hTneAjTGXMB0RJ4ShFUsgdJ
         nzT3awQq2fQKVfvAdu/n+Yz9xYCZVLNKwSpFNHwogjHosqUfnr5EbbV5e11gxIRyp3bq
         65l4Ca2WRR8gPAgWiec2HZPp3Ga5e1bkVIEo6OJF6pE7biuWWPco4UwmlrQSaxqlecjF
         zFTYQ+68HkinDuixJecwFX1sCWggpw73hWuX4lWtJ6p384kjv9X8ZasEOeiQKHHxZqAg
         wv6+nFCRN/2HCNBXGjyhPUwGx3eEGyjKhouH03a6QQCbTKKk3u+eUPeM/Ce3RCnbnc8t
         OjVA==
X-Gm-Message-State: AOAM530gqqGsfwfADogww/Kpfib9/Q9gfejTB/4LtJVadZ9uFK6Bh081
        FF7EIAaI/g0wQPAyjP3UGYDOMlIZSja2zdaaDxhiTA==
X-Google-Smtp-Source: ABdhPJyM0ggNxJXeHokAmTYi2nyU/dC2IeiojBgwYL1tAXquHUrAImkrDV6i+MVdfHqIjbkB7k+XWvdvv8LmFN6fZEU=
X-Received: by 2002:a25:d213:: with SMTP id j19mr2860896ybg.20.1630036972958;
 Thu, 26 Aug 2021 21:02:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210826074526.825517-1-saravanak@google.com> <20210826074526.825517-2-saravanak@google.com>
 <YSeTdb6DbHbBYabN@lunn.ch> <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
 <YSf/Mps9E77/6kZX@lunn.ch> <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch>
In-Reply-To: <YSg+dRPSX9/ph6tb@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 26 Aug 2021 21:02:16 -0700
Message-ID: <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
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

On Thu, Aug 26, 2021 at 6:23 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Doesn't add much to the discussion. In the example I gave, the driver
> > already does synchronous probing. If the device can't probe
> > successfully because a supplier isn't ready, it doesn't matter if it's
> > a synchronous probe. The probe would still be deferred and we'll hit
> > the same issue. Even in the situation the commit [5] describes, if
> > parallelized probing is done and the PHY depended on something (say a
> > clock), you'd still end up not probing the PHY even if the driver is
> > present and the generic PHY would end up force probing it.
>
>
> genphy is meant to be used when there is no other driver available.
> It is a best effort, better than nothing, might work. And quite a few
> boards rely on it. However, it should not be used when there is a
> specific driver.

Agreed, that's what we are trying to ensure.

> So if the PHY device has been probed, and -EPROBE_DEFER was returned,
> we also need to return -EPROBE_DEFER here when deciding if genphy
> should be used. It should then all unwind and try again later.

Yes, I think dsa_register_switch() returning -EPROBE_DEFER if the PHYs
returned -EPROBE_DEFER might be okay (I think we should do it), but
that doesn't solve the problem for this driver.

fw_devlink=on/device links short circuits the probe() call of a
consumer (in this case the PHY) and returns -EPROBE_DEFER if the
supplier's (in this case switch) probe hasn't finished without an
error. fw_devlink/device links effectively does the probe in graph
topological order and there's a ton of good reasons to do it that way
-- what's why fw_devlink=on was implemented.

In this specific case though, since the PHY depends on the parent
device, if we fail the parent's probe realtek_smi_probe() because the
PHYs failed to probe, we'll get into a catch-22/chicken-n-egg
situation and the switch/PHYs will never probe.

I think a clean way to fix this at the driver level is to do what I
said in [6]. Copy pasting it here and expanding it a bit:

1. The IRQ registration and mdio bus registration should get moved to
realtek_smi_probe() which probes "realtek,rtl8366rb". So
realtek_smi_probe() succeeding doesn't depend on its child devices
probing successfully (which makes sense for any parent device).
2. realtek_smi_probe() should also create/register a
component-master/aggregate device that's "made up of"
realtek,rtl8366rb and all the PHYs. So the component-master will wait
for all of them to finish probing before it's initialized.
3. PHYs will probe successfully now because realtek,rtl8366rb probe()
which is the supplier's probe has finished probing without problems.
4. The component device's init (the .bind op) would call
dsa_register_switch() which kinda makes sense because the rtl8366rb
and all the PHYs combined together is what makes up the logical DSA
switch. The dsa_register_switch() will succeed and will be using the
right/specific PHY driver.

The same applies for any switch that has the PHYs as it's child device
AND (this is the key part) the PHYs depend on the switch as a supplier
(remember, if we didn't have the interrupt dependency, this would not
be an issue).

> I don't know the device core, but it looks like dev->can_match tells
> us what we need to know. If true, we know there is a driver for this
> device. But i'm hesitant to make use of this outside of driver/base.

can_match is never cleared once it's set and it's meant as an
optimization/preserving some probe order stuff. I wouldn't depend on
it for this case. We can just have a phy_has_driver()  function that
searches all the currently registered PHY drivers to check if there's
a matching driver. And dsa_register_switch() or phy_attach_direct()
can return -EPROBE_DEFER if there is a driver but it isn't bound yet.
Again, this is orthogonal to the realtek driver fix though because of
the catch-22 situation above.

-Saravana

[6] - https://lore.kernel.org/netdev/CAGETcx8_vxxPxF8WrXqk=PZYfEggsozP+z9KyOu5C2bEW0VW8g@mail.gmail.com/
