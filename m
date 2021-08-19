Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DB83F1195
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 05:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhHSD36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 23:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236048AbhHSD35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 23:29:57 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E2DC061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 20:29:22 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id z5so9615214ybj.2
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 20:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c4pDYFPjlLEjtQ5iIzYR9h7C88VPtVNj1fN2wsQJM8Q=;
        b=wEseyoUYjmTVapF+yJ4HyZ64ggUPq/p5djdXM11HJ/ynzx+Dz3Cc0lOPSU+pRkbdvS
         8tOksKOWP44zm+aeV8CS2N+JTEKwDpa0tUor8bTkFX+jRmDQwKrEK5OFDKvc2lsCkB8V
         PsA/JaaxgXPhm1YpKLeoBLpkD7OcU6I1JAM6qbgfkeZlWKiAgK439h7H7hfxdPz2nBUJ
         QqW8Hp0oTaHmPnMWdCYlHR6EAbWodmUcw+UxgIMlnMr+PhaYel5AKHTKvbOZ/NWTzTrG
         0bxwhnS0PCGLEJK9JbYebtuJRMDy2WcHV/mE1jg0CanrynZHvsraxuBgbpC1kKNu3h47
         XFUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c4pDYFPjlLEjtQ5iIzYR9h7C88VPtVNj1fN2wsQJM8Q=;
        b=A210tz5PtVEqZl/6GYlABXRWdjmKolYA3b/mGBAzkKgrHxunCubu0bgAbZ/s4G/jLr
         O5y8LadNtil20yaLXECFHQ3/UV4zQSNuxCf4xbU/AeeHpMEc3Wuwlrb5n6rsCViV0TNP
         RzcOgk6s92R8KTM1GmpeyzLx9JFD5y8TIBA+s1vRM2kQ8cp9zdqS1QDf+AYqAi/wUVYR
         NGSi1nqvz4ZMgqyl3pJSBF75UcLx+Mii/CHKOlbtNSvEn89ypKebpvuAczaY2eJcuzQU
         HAbx9Hpd88vxyPNyOu+iG/DMzEf9pQyqZyEgqJWyYCMHsoeUqHUHfzvRKSCdz6M9EDeX
         mbKw==
X-Gm-Message-State: AOAM53258XISFotrKRlxlOOoT+tO91N1loBUo+d2a0/pmk+dMviBe6YU
        E3Tz15Svd228xwiAU8QZC9T3hHuDVqy52iK21QjrQw==
X-Google-Smtp-Source: ABdhPJwWdz6jnuP0QstS/LASRSwWRbwj7JBtsLRwDJLaANoyAqMqawIO4xhOu7GVBMQZSkfbHvO/XPuShRZkXom14ao=
X-Received: by 2002:a25:bdc6:: with SMTP id g6mr15052663ybk.310.1629343761024;
 Wed, 18 Aug 2021 20:29:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk> <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com> <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk>
In-Reply-To: <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 18 Aug 2021 20:28:44 -0700
Message-ID: <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 3:18 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> w=
rote:
>
> Hi Saravana,
>
> On 8/18/21 4:46 AM, Saravana Kannan wrote:
> > On Tue, Aug 17, 2021 at 3:31 PM Vladimir Oltean <olteanv@gmail.com> wro=
te:
> >>
> >> Hi Alvin,
> >>
> >> On Tue, Aug 17, 2021 at 09:25:28PM +0000, Alvin =C5=A0ipraga wrote:
> >>> I have an observation that's slightly out of the scope of your patch,
> >>> but I'll post here on the off chance that you find it relevant.
> >>> Apologies if it's out of place.
> >>>
> >>> Do these integrated NXP PHYs use a specific PHY driver, or do they ju=
st
> >>> use the Generic PHY driver?
> >>
> >> They refuse to probe at all with the Generic PHY driver. I have been
> >> caught off guard a few times now when I had a kernel built with
> >> CONFIG_NXP_C45_TJA11XX_PHY=3Dn and their probing returns -22 in that c=
ase.
> >>
> >>> If the former is the case, do you experience that the PHY driver fail=
s
> >>> to get probed during mdiobus registration if the kernel uses
> >>> fw_devlink=3Don?
> >>
> >> I don't test with "fw_devlink=3Don" in /proc/cmdline, this is the firs=
t
> >> time I do it. It behaves exactly as you say.
> >>
> >>>
> >>> In my case I am writing a new subdriver for realtek-smi, a DSA driver
> >>> which registers an internal MDIO bus analogously to sja1105, which is
> >>> why I'm asking. I noticed a deferred probe of the PHY driver because =
the
> >>> supplier (ethernet-switch) is not ready - presumably because all of t=
his
> >>> is happening in the probe of the switch driver. See below:
> >>>
> >>> [   83.653213] device_add:3270: device: 'SMI-0': device_add
> >>> [   83.653905] device_pm_add:136: PM: Adding info for No Bus:SMI-0
> >>> [   83.654055] device_add:3270: device: 'platform:ethernet-switch--md=
io_bus:SMI-0': device_add
> >>> [   83.654224] device_link_add:843: mdio_bus SMI-0: Linked as a sync =
state only consumer to ethernet-switch
> >>> [   83.654291] libphy: SMI slave MII: probed
> >>> ...
> >>> [   83.659809] device_add:3270: device: 'SMI-0:00': device_add
> >>> [   83.659883] bus_add_device:447: bus: 'mdio_bus': add device SMI-0:=
00
> >>> [   83.659970] device_pm_add:136: PM: Adding info for mdio_bus:SMI-0:=
00
> >>> [   83.660122] device_add:3270: device: 'platform:ethernet-switch--md=
io_bus:SMI-0:00': device_add
> >>> [   83.660274] devices_kset_move_last:2701: devices_kset: Moving SMI-=
0:00 to end of list
> >>> [   83.660282] device_pm_move_last:203: PM: Moving mdio_bus:SMI-0:00 =
to end of list
> >>> [   83.660293] device_link_add:859: mdio_bus SMI-0:00: Linked as a co=
nsumer to ethernet-switch
> >>> [   83.660350] __driver_probe_device:736: bus: 'mdio_bus': __driver_p=
robe_device: matched device SMI-0:00 with driver RTL8365MB-VC Gigabit Ether=
net
> >>> [   83.660365] device_links_check_suppliers:1001: mdio_bus SMI-0:00: =
probe deferral - supplier ethernet-switch not ready
> >>> [   83.660376] driver_deferred_probe_add:138: mdio_bus SMI-0:00: Adde=
d to deferred list
> >>
> >> So it's a circular dependency? Switch cannot finish probing because it
> >> cannot connect to PHY, which cannot probe because switch has not
> >> finished probing, which....
> >
> > Hi Vladimir/Alvin,
> >
> > If there's a cyclic dependency between two devices, then fw_devlink=3Do=
n
> > is smart enough to notice that. Once it notices a cycle, it knows that
> > it can't tell which one is the real dependency and which one is the
> > false dependency and so stops enforcing ordering between the devices
> > in the cycle.
> >
> > But fw_devlink doesn't understand all the properties yet. Just most of
> > them and I'm always trying to add more. So when it only understands
> > the property that's causing the false dependency but not the property
> > that causes the real dependency, it can cause issues like this where
> > fw_devlink=3Don enforces the false dependency and the driver/code
> > enforces the real dependency. These are generally easy to fix -- you
> > just need to teach fw_devlink how to parse more properties.
> >
> > This is just a preliminary analysis since I don't have all the info
> > yet -- so I could be wrong. With that said, I happened to be working
> > on adding fw_devlink support for phy-handle property and I think it
> > should fix your issue with fw_devlink=3Don. Can you give [1] a shot?
>
> I tried [1] but it did not seem to have any effect.
>
> >
> > If it doesn't fix it, can one of you please point me to an upstream
> > dts (not dtsi) file for a platform in which you see this issue? And
> > ideally also the DT nodes and their drivers that are involved in this
> > cycle? With that info, I should be able to root cause this if the
> > patch above doesn't already fix it.
>
> I'm working with a non-upstream dts - maybe Vladimir is using an
> upstream one? The pattern among the drivers/dts is common between our
> two cases.

Ideally, I can get a fully upstream example where this issue is
happening so that I can look at the actual code that's hitting this
issue and be sure my analysis is right.

>
> But for the sake of this discussion, my dts is pretty much the same as
> what you will find in arch/arm/boot/dts/gemini-dlink-dir-685.dts. The
> nodes of interest from that dts file are below, and the driver is in
> drivers/net/ds/{realtek-smi-core.c,rtl8366rb.c}. It's expected that the
> Realtek PHY driver in drivers/net/phy/realtek.c will get probed as part
> of the mdiobus registration, but that never happens. See my previous
> reply for a debug log.

Your DTS might be similar to this, but the driver code also matters
for me to be sure. Anyway, I took a look at this, but my analysis
below is going to be sketchy because I'm not looking at the actual
code that's reproducing this issue.

Assuming this issue actually happens with the example you pointed to
(I don't know this yet), here's what is happening:

The main problem is that the parent device switch seems to be assuming
it's child/grandchild devices (mdiobus/PHYs) will have probed
successfully as soon as they are added. This assumption is not true
and can be broken for multiple reasons such as:

1. The driver for the child devices (PHYs in this case) could be
loaded as a module after the parent (switch) is probed. So when the
devices are added, the PHYs would not be probed.
2. The child devices could defer probe because one of their suppliers
isn't ready yet. Either because of fw_devlink=3Don or the framework
itself returning -EPROBE_DEFER.
3. The child devices could be getting probed asynchronously. So the
device_add() would kick off a thread to probe the child devices in a
separate thread.

(2) is what is happening in this case. fw_devlink=3Don sees that
"switch" implements the "switch_intc" and "switch" hasn't finished
probing yet. So it has no way of knowing that switch_intc is actually
ready. And even if switch_intc was registered as part of switch's
probe() by the time the PHYs are added, switch_intc could get
deregistered if the probe fails at a later point. So until probe()
returns 0, fw_devlink can't be fully sure the supplier (switch_intc)
is ready. Which is good in general because you won't have to
forcefully unbind (if that is even handled correctly in the first
place) the consumers of a device if it fails probe() half way through
registering a few services.

I don't fully understand the networking frameworks, but I think
Vladimir might have a point in his earlier reply [1]. If you can make
the switch driver not assume its child PHYs are ready during the
switch's probe and instead have the switch check if the PHYs are ready
when the switch is "opened" that'd be better.

We can come up with hacks that'll delete the dependency that
fw_devlink=3Don is trying to enforce, but IMHO the proper fix is to have
parent drivers not assume child devices will be probed as soon as
device_add(child) returns. That's not guaranteed at all.

Btw, I do know why things work when you do the module load/unload
thing you mention in [2]. That has to do with some forced deletion of
dependencies that happens when device_bind_driver() is called when the
Generic PHY driver is used. The reason for why that's done is kind of
unrelated to the issue at hand, but the comment for
device_links_force_bind() should tell you why.

Hope that helps.

[1] - https://lore.kernel.org/netdev/20210817224008.pzdomrjaw5ewmpdg@skbuf/
[2] - https://lore.kernel.org/netdev/0c3e8814-acce-5836-3b1a-6804c21e9bf0@b=
ang-olufsen.dk/

-Saravana

>
> / {
>         switch {
>                 compatible =3D "realtek,rtl8366rb";
>                 mdc-gpios =3D <&gpio0 21 GPIO_ACTIVE_HIGH>;
>                 mdio-gpios =3D <&gpio0 22 GPIO_ACTIVE_HIGH>;
>                 reset-gpios =3D <&gpio0 14 GPIO_ACTIVE_LOW>;
>                 realtek,disable-leds;
>
>                 switch_intc: interrupt-controller {
>                         /* GPIO 15 provides the interrupt */
>                         interrupt-parent =3D <&gpio0>;
>                         interrupts =3D <15 IRQ_TYPE_LEVEL_LOW>;
>                         interrupt-controller;
>                         #address-cells =3D <0>;
>                         #interrupt-cells =3D <1>;
>                 };
>
>                 ports {
>                         /* snip */
>                 };
>
>                 mdio {
>                         compatible =3D "realtek,smi-mdio";
>                         #address-cells =3D <1>;
>                         #size-cells =3D <0>;
>
>                         phy0: phy@0 {
>                                 reg =3D <0>;
>                                 interrupt-parent =3D <&switch_intc>;
>                                 interrupts =3D <0>;
>                         };
>                         phy1: phy@1 {
>                                 reg =3D <1>;
>                                 interrupt-parent =3D <&switch_intc>;
>                                 interrupts =3D <1>;
>                         };
>                         phy2: phy@2 {
>                                 reg =3D <2>;
>                                 interrupt-parent =3D <&switch_intc>;
>                                 interrupts =3D <2>;
>                         };
>                         phy3: phy@3 {
>                                 reg =3D <3>;
>                                 interrupt-parent =3D <&switch_intc>;
>                                 interrupts =3D <3>;
>                         };
>                         phy4: phy@4 {
>                                 reg =3D <4>;
>                                 interrupt-parent =3D <&switch_intc>;
>                                 interrupts =3D <12>;
>                         };
>                 };
>         };
> };
>
> Thanks for looking into this. Let me know if you need any other info or
> want something tested.
>
> Kind regards,
> Alvin
>
> >
> >>
> >> So how is it supposed to be solved then? Intuitively the 'mdio_bus SMI=
-0:00'
> >> device should not be added to the deferred list, it should have everyt=
hing
> >> it needs right now (after all, it works without fw_devlink). No?
> >>
> >> It might be the late hour over here too, but right now I just don't
> >> know. Let me add Saravana to the discussion too, he made an impressive
> >> analysis recently on a PHY probing issue with mdio-mux,
> >
> > Lol, thanks for the kind words.
> >
> >> so the PHY
> >> library probing dependencies should still be fresh in his mind, maybe =
he
> >> has an idea what's wrong.
> >
> > [1] - https://lore.kernel.org/lkml/20210818021717.3268255-1-saravanak@g=
oogle.com/T/#u>>
> > Thanks,
> > Saravana
> >
