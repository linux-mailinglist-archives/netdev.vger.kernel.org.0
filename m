Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389211E87D6
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgE2TbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgE2TbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 15:31:22 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A14AC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 12:31:22 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id c35so2589181edf.5
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 12:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uhuxW8lRHGejGy34+laSiwOWnN8MuzwhQglsvWQi0tY=;
        b=akLN/BHymf1n/nShUsk9yzERKnrcb2K765mqiUrHFwsAHoU1WJVajHQJE3WBSbOP2U
         UdnSOAtMFPCdHcozafHJAGwVaSAlNbcZG2ofidFUhhr3YPq7iasZ8UXfwRXV8g10P9Ey
         NCIQhReADEVh4EgWt4zFWD3LfenCYNt2XPLfyJVfgrRuHyVEl9FTtP4+jgSp50x+qkUe
         7katu/AWJ8cV/BHi9LVRMW5XekQ7hyM8DdxhmfWYgfu/9l2gCzs+1C8tLmONZy0FkA5e
         fjSvRbE2B4QgUiDaoeB1azQB54wU8zzbT16871h1/spexgylux4z3PGb/o4WMlNKwida
         Bb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uhuxW8lRHGejGy34+laSiwOWnN8MuzwhQglsvWQi0tY=;
        b=mtHcUF8rNm+v9lvuZWup6YnOqfuxeopq8YnnBoy3e8vm+f3xIwTCGxeta1mgISIaEs
         kVy93aTarhoz5kQhrQ4Lw4PF5TQXTCudg1AcQIk2qq5x1tZiFVTwG83gdkJhgpx/SCzk
         5cPRwEmheDTmYuFMKGAibQVsfSoi5rLiIGp7fodMEp05A+OeLqkTq2xmGb5PuyYAJ4AE
         k9yDOYl1bqfQcMgAdaHFozN2r5AhJxCCuy6S4yo44z6G3ZQ8AiO8KjT4Bj5soj7BUgyU
         khF8yjtMCvSRjfdRefB/Z+8GA2n3cT9RHFOxSEp7/DSJWjtAvgCtpKEhefNBa7NaSfSt
         5lRA==
X-Gm-Message-State: AOAM530vnymEAXogGp41kEsxQhShdySJQvGgveSD9VMeq21FNiXL0ltC
        o9qZA4Mr8IhC0Mh6I1Zqi3KnDwDbgmIhc91Tp/c=
X-Google-Smtp-Source: ABdhPJy478Kti5Gd0YO27mN/ae3+kRr8ilJGq4PP7/qhwkwHenFGtsmWiUPH3IC3xfq3Nn66tA9bCHv2sr/lfreRR3s=
X-Received: by 2002:a50:bf03:: with SMTP id f3mr10199296edk.368.1590780681060;
 Fri, 29 May 2020 12:31:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200527234113.2491988-1-olteanv@gmail.com> <20200527234113.2491988-7-olteanv@gmail.com>
 <20200528145058.GA840827@lunn.ch>
In-Reply-To: <20200528145058.GA840827@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 29 May 2020 22:31:09 +0300
Message-ID: <CA+h21hqpiV1sp3+tXVuQoy95bXQ5DD6nvEKK1Mw72TutdoX-Bg@mail.gmail.com>
Subject: Re: [PATCH net-next 06/11] net: dsa: ocelot: create a template for
 the DSA tags on xmit
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, 28 May 2020 at 17:51, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, May 28, 2020 at 02:41:08AM +0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > With this patch we try to kill 2 birds with 1 stone.
> >
> > First of all, some switches that use tag_ocelot.c don't have the exact
> > same bitfield layout for the DSA tags. The destination ports field is
> > different for Seville VSC9953 for example. So the choices are to either
> > duplicate tag_ocelot.c into a new tag_seville.c (sub-optimal) or somehow
> > take into account a supposed ocelot->dest_ports_offset when packing this
> > field into the DSA injection header (again not ideal).
> >
> > Secondly, tag_ocelot.c already needs to memset a 128-bit area to zero
> > and call some packing() functions of dubious performance in the
> > fastpath. And most of the values it needs to pack are pretty much
> > constant (BYPASS=1, SRC_PORT=CPU, DEST=port index). So it would be good
> > if we could improve that.
> >
> > The proposed solution is to allocate a memory area per port at probe
> > time, initialize that with the statically defined bits as per chip
> > hardware revision, and just perform a simpler memcpy in the fastpath.
>
> Hi Vladimir
>
> We try to keep the taggers independent of the DSA drivers. I think
> tag_ocelot.c is the only one that breaks this.
>
> tag drivers are kernel modules. They have all the options of a kernel
> module, such as init and exit functions. You could create these
> templates in the module init function, and clean them up in the exit
> function. You can also register multiple taggers in one
> driver. tag_brcm.c does this as an example. So you can have a Seville
> tagger which uses different templates to ocelot.
>
>        Andrew

I don't particularly like that tag_brcm.c is riddled with #if /
#endif, they make it difficult to follow.

And if I allocate/free the xmit template in the
dsa_tag_driver_module_init / dsa_tag_driver_module_exit, how can I
reach the pointer to the correct per-switch-per-port template in the
ocelot_xmit function?

Please note that ocelot_xmit is already stateful, and it _needs_ to be
stateful: for 1588, it saves and increments the TX timestamp ID which
will be matched to the data that is received in felix_irq_handler.

And sja1105 also breaks the tagger/driver separation, and in even
"worse" ways - see sja1105_xmit_tpid which transmits a different frame
depending on which state the driver is in; also sja1105_decode_subvlan
which on RX looks up a table populated by the driver.

Generally speaking, I don't see any good reason why keeping the tagger
and the driver separated should be a design goal, especially when the
hotpath depends on stateful information (and the tagging driver can't
do anything at all without a backing switch driver anyway). Separation
could be done only in the simplest of cases, but as more advanced
features are necessary (not arguing that the template I'm adding here
is "advanced" stuff), this becomes practically impossible. Please also
see this tag_ocelot.c patch which needs to take the classified VLAN
from the DSA tag, or not, depending on the VLAN awareness state of the
port:
https://patchwork.ozlabs.org/project/netdev/patch/20200506074900.28529-7-xiaoliang.yang_1@nxp.com/

Thanks,
-Vladimir
