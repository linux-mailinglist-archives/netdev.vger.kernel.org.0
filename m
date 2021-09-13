Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B51140A189
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 01:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343540AbhIMXWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 19:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344750AbhIMXV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 19:21:56 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B439C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 16:20:27 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id l18so20166473lji.12
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 16:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U6q60luroQ7UZC6Euxt8OCPmZy5L5NmejgZz68qC/E4=;
        b=wgXVSQsZgf8wSAfQWWpNQ9tCAIjnqKZIT+4QydYpKL/pDFsUjQAfo6pVvLOjl0pKBn
         0W5VnitMy6KIdtBIZ3vfD7gN6xJn77bGDgYyZUEreWW4+nb3tRjzqTrbkRK+nFNiUok/
         sCgigLO31e3h57RJ6PBbotkzT1D6VKWOzGpiytG7CyPQ3E2wRQe7noAOk8MeeX3Pdb/4
         uQpMr2HEal/PZTe+MdgKEj/lc+dCWazFWlXC+UNpdeR07Ym1W8TIUFS2rzgf2X7D+CkE
         1HfYlXjV7wXUWuTlUCzvYwXNOuBcJ6XUxlVCS0OmQf/fWnzOpc3BfePvwhCrHBF3+t2W
         tmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U6q60luroQ7UZC6Euxt8OCPmZy5L5NmejgZz68qC/E4=;
        b=0J6t58QsFWzXnUhnxS8m741CQlaQUtrLm4gZv+4BcosjuGfWcHS9MQgIbbQySnzy6T
         cy0XMzy86XMd/EDBPKNknrEFKcWi14f+K9PgC14veEu3TiGJh8namBUskrz5v1POLeR1
         +gQHaEYbYtB9xKjfcAdOZYw8oeBNaNn35Lvi+BDT1R4SqM7S4V7Rx+ETjcAQAaThavud
         Jp8y6u08ivIUrzU0GxHnyMMT2y422xYK0HMVzJny9yvJsBnYIjfWUB2TYAB+jID6EeW9
         kwb3PJpde4Qw/Fbybg+0Xa+uEBeEo6dxX54Egutb613n8/3JoHbHtx/0kTh7qlmezBEH
         T4Dw==
X-Gm-Message-State: AOAM532E0PIkzcXaQNCIycxNtaSgomwh5+BVQ4tYFVEfMnFLRWp73dAj
        5hrnGhbHQY0boDOBXQJvUhkORVg3ikzI9dzLVPTWoA==
X-Google-Smtp-Source: ABdhPJzkQysEtHRj9GljDyF4WRUp71XLtgO9rCvxSjxj+TZAjA6uATbHuADqRoM00ZSyATH0Yq1CfKPQvIr83V/UJF0=
X-Received: by 2002:a05:651c:11c7:: with SMTP id z7mr12504403ljo.288.1631575225736;
 Mon, 13 Sep 2021 16:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
 <20210913144300.1265143-6-linus.walleij@linaro.org> <20210913153425.pgm2zs4vgtnzzyps@skbuf>
In-Reply-To: <20210913153425.pgm2zs4vgtnzzyps@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 14 Sep 2021 01:20:14 +0200
Message-ID: <CACRpkdYUp2m8LXfngi05O=ro5-8vicpkNJa=PUGzc4KDBsuMyA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/8] net: dsa: rtl8366: Disable "4K" VLANs
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

first, thanks for your help and patience. I learned a lot the recent
weeks, much thanks to your questions and explanations!

On Mon, Sep 13, 2021 at 5:34 PM Vladimir Oltean <olteanv@gmail.com> wrote:

> > This was discovered when testing with OpenWrt that join
> > the LAN ports lan0 ... lan3 into a bridge and then assign
> > each of them into VLAN 1 with PVID set on each port: without
> > this patch this will not work and the bridge goes numb.
>
> It is important to explain _why_ the switch will go "numb" and not pass
> packets if the Linux bridge assigns all ports to VLAN ID 1 as pvid. It
> is certainly not expected for that to happen.

Yeah it is pretty weird. What happens now is that this is a regression
when using OpenWrt userspace as it sets up the VLANs like this,
but if I boot a clean system and just manually do e.g.
ifconfig lan0 169.254.1.2 netmask 255.255.255.0 up
it works fine because the default VLANs that were set up by the
driver (removed by patch 2/8) will tag all packets using PVID and
send packets on 5 ingress and 1 egress VLANs.

> The purpose of the PVID feature is specifically to classify untagged
> packets to a port-based VLAN ID. So "everything is a VLAN" even for
> Linux user space, not sure what you're talking about.

I think what happens is that OpenWrts userspace sets VLAN 1
for all ingress ports with PVID, so all packets from ingress ports
get tagged nicely with VID 1.

But as the CPU port is hidden inside the bridge
it can't join the CPU port into that VLAN (userspace does not
know it exist I think?) and thus no packets
can go into or out of the CPU port. But you can still pass packets
between the lan ports.

> When the Linux bridge has the vlan_filtering attribute set to 1, the
> hardware should follow suit by making untagged packets get classified to
> the VLAN ID that the software bridge wants to see, on the ports that are
> members of that bridge.

This is what it does, I think.

But the "4K" VLAN feature is so strict that it will restrict also the CPU
port from this (in hardware) with no way to turn it off.

It seems the "4K" mode is a "VLAN with filtering only mode" so no
matter whether we turned on filtering or not, the CPU port
will not see any packets from any other ports unless we add also
that port (port 5) into the VLAN.

One solution I could try would be to just add the CPU port to all
VLANs by default, but .. is that right?

I suppose this would work as software will add the right
VID to the packets so they will only propagate to the right
ports anyway. It could test it.

> When the Linux bridge has the vlan_filtering attribute set to 0, the
> software bridge very much ignores any VLAN tags from packets, and does
> not perform any VLAN-based ingress admission checks. If the hardware
> classifies all packets to a VLAN even when VLAN "filtering" (i.e.
> ingress dropping on mismatch) is disabled, that is perfectly fine too,

I think this is what happens in this hardware.

> although the software bridge doesn't care. You need to set up a private
> VLAN ID for your VLAN-unaware ports, and make it the pvid on those ports,

Would the CPU port be a VLAN-unaware port?

My problem is that in the "4K" mode, the CPU port will not see packets
from any VLAN it is not a member of.

> and somehow force the hardware to classify any packet towards that pvid
> on those VLAN-unaware ports, regardless of whether the packets are
> untagged or 802.1Q-tagged or 802.1ad-tagged or whatever. That is simply
> the way things are supposed to work.
>
> VLAN ID 0 and 4095 are good candidates to use privately within your
> driver as the pvid on VLAN-unaware ports, and you can/must manually
> bring up these VLANs, since the bridge will refuse to install these
> VLANs in its database.
>
> Other VLAN IDs like the range 4000-4094 are also potentially ok as long
> as you document the fact that your driver crops that range out of the
> usable range of the bridge, and you make sure that no packet leaks
> inside or outside of those private VLANs are possible ("attackers" could
> still try to send a packet tagged with VLAN ID 4094 towards a port that
> is under a VLAN-aware bridge. Since that port is VLAN-aware, it will
> recognize the VLAN ID as 4094, so unless you configure that port to drop
> VLAN ID 4094, it might well leak into the VLAN domain 4094 which is
> privately used by your driver to ensure VLAN-unaware forwarding between
> the ports of a nearby VLAN-unaware bridge.

I don't have any VLAN-unaware ports other than the CPU
port.

What happened before patch 2/8 was that it was given its own VLAN
with PVID and all other ports were assigned members of that VLAN as
well, and thus egress traffic from the CPU port could go out.

For ingress traffic, the CPU port was member of all ingress
VLANs. (Also removed by patch 2/8)

> I know there are lots of things to think about, but this patch is way
> too simplistic and does not really offer solid explanations.

I'm trying my best and learning along the way :)
It's fine, no hurry and let's get this right so that the other
RTL switches can look at this a good example.

Yours,
Linus Walleij
