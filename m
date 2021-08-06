Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB4E3E3238
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 01:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhHFX4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 19:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhHFX4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 19:56:41 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26248C061798
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 16:56:25 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id p145so18061452ybg.6
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 16:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GqYzADmVgO8eu/I7MSORCLeA3yiZUEks8OI+aWsxxtY=;
        b=FmRQO5jvt5NDkhWtxA1+RCBsrvV/6jAabOMVBUgVL1Kr4vkEI+ttrkR1GFAxSEwPCk
         /jXZG9P10zlijBANWFhg328mmGyJu8ymGuu3h3NtLkktrn+qHkVv5foJED/B9HGcofjN
         7Xfldrdc0SX9Uwc3FQB890l5vXQIvJeALFyUK8Ug0wPVyemf9VBC2VgN+8k9cHOF1CQJ
         z1dnKv7CPjFypmWXmlobZDB4gokTuiMt/d/d35j3rP68RVtOke4ZAd2IhEB8P5dgapDb
         WDXZQDXyD+quR+253hfE8iC68d2k9cZvl06Lc+m1+Od1rYvYTpltRIcUYgIuTLRdP5Ck
         GYxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GqYzADmVgO8eu/I7MSORCLeA3yiZUEks8OI+aWsxxtY=;
        b=DZflfP8Gp4YCRTZhpHS/0g0s37+ih7e67XbUnw9u8CBMr3iVsZZZZ/mFzXiMoBn/m6
         gwCeDk3wJnlD8/Yp5Dcbg0qI5sgI63Eu1YL+pgoWqA6yVVirGxSSb1SZjlzGTbyIdOM5
         EKb9L12tvt1rsEs6uQAIOJ+yXaZH7nZ0AgAGQIWr3QdWIiT9cKCnxKvddxEFUUX8foZG
         Xc8GIehIObbSXjIKvY9LrRFUcYl+Z0OEaDy1HQmmtgvZswfCl8QuFDdwJw9j/TITbHHv
         zWOQdhCkc+Y6FiAwHWCbar2aE7e2u3qorsr5lhjinuKWRie8YfjRjnPq6PVvem+tjpcY
         OteA==
X-Gm-Message-State: AOAM532wlM6785fn2GhIDO3U8gLmA3ylqRUmKyWcULozvav/9+TK0rgH
        zfOJG8iLzfG++mywHV52eIBRLTD3/opXXUCDipkWHQ==
X-Google-Smtp-Source: ABdhPJzljeFfuWYYUag/S7LEKjXqAFFjo3NggF/Dt0FdNl6ebzVVtr304gIIC460ujpBvbhrLl8XdcUBuwJp3JtbDV8=
X-Received: by 2002:a25:53c9:: with SMTP id h192mr15299393ybb.310.1628294184035;
 Fri, 06 Aug 2021 16:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <20201020072532.949137-1-narmstrong@baylibre.com>
 <20201020072532.949137-2-narmstrong@baylibre.com> <7hsga8kb8z.fsf@baylibre.com>
 <CAF2Aj3g6c8FEZb3e1by6sd8LpKLaeN5hsKrrQkZUvh8hosiW9A@mail.gmail.com>
 <87r1hwwier.wl-maz@kernel.org> <7h7diwgjup.fsf@baylibre.com>
 <87im0m277h.wl-maz@kernel.org> <CAGETcx9OukoWM_qprMse9aXdzCE=GFUgFEkfhhNjg44YYsOQLw@mail.gmail.com>
 <87sfzpwq4f.wl-maz@kernel.org> <CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com>
 <CAGETcx8bpWQEnkpJ0YW9GqX8WE0ewT45zqkbWWdZ0ktJBhG4yQ@mail.gmail.com> <4e98d876-330f-21a4-846e-94e1f01f0eed@baylibre.com>
In-Reply-To: <4e98d876-330f-21a4-846e-94e1f01f0eed@baylibre.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 6 Aug 2021 16:55:48 -0700
Message-ID: <CAGETcx95gQ4820Xz+MCxFS4Bi6yiHsfro2vdc2EqqrQNZ6caRg@mail.gmail.com>
Subject: Re: [PATCH 1/2] irqchip: irq-meson-gpio: make it possible to build as
 a module
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 4, 2021 at 11:31 PM Neil Armstrong <narmstrong@baylibre.com> wr=
ote:
>
> Hi Saravana,
>
> On 04/08/2021 23:47, Saravana Kannan wrote:
> > On Wed, Aug 4, 2021 at 11:20 AM Saravana Kannan <saravanak@google.com> =
wrote:
> >>
> >> On Wed, Aug 4, 2021 at 1:50 AM Marc Zyngier <maz@kernel.org> wrote:
> >>>
> >>> On Wed, 04 Aug 2021 02:36:45 +0100,
> >>> Saravana Kannan <saravanak@google.com> wrote:
> >>>
> >>> Hi Saravana,
> >>>
> >>> Thanks for looking into this.
> >>
> >> You are welcome. I just don't want people to think fw_devlink is broke=
n :)
> >>
> >>>
> >>> [...]
> >>>
> >>>>> Saravana, could you please have a look from a fw_devlink perspectiv=
e?
> >>>>
> >>>> Sigh... I spent several hours looking at this and wrote up an analys=
is
> >>>> and then realized I might be looking at the wrong DT files.
> >>>>
> >>>> Marc, can you point me to the board file in upstream that correspond=
s
> >>>> to the platform in which you see this issue? I'm not asking for [1],
> >>>> but the actual final .dts (not .dtsi) file that corresponds to the
> >>>> platform/board/system.
> >>>
> >>> The platform I can reproduce this on is described in
> >>> arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts. It is an
> >>> intricate maze of inclusion, node merge and other DT subtleties. I
> >>> suggest you look at the decompiled version to get a view of the
> >>> result.
> >>
> >> Thanks. After decompiling it, it looks something like (stripped a
> >> bunch of reg and address properties and added the labels back):
> >>
> >> eth_phy: mdio-multiplexer@4c000 {
> >>         compatible =3D "amlogic,g12a-mdio-mux";
> >>         clocks =3D <0x02 0x13 0x1e 0x02 0xb1>;
> >>         clock-names =3D "pclk\0clkin0\0clkin1";
> >>         mdio-parent-bus =3D <0x22>;
> >>
> >>         ext_mdio: mdio@0 {
> >>                 reg =3D <0x00>;
> >>
> >>                 ethernet-phy@0 {
> >>                         max-speed =3D <0x3e8>;
> >>                         interrupt-parent =3D <0x23>;
> >>                         interrupts =3D <0x1a 0x08>;
> >>                         phandle =3D <0x16>;
> >>                 };
> >>         };
> >>
> >>         int_mdio: mdio@1 {
> >>                 ...
> >>         }
> >> }
> >>
> >> And phandle 0x23 refers to the gpio_intc interrupt controller with the
> >> modular driver.
> >>
> >>>> Based on your error messages, it's failing for mdio@0 which
> >>>> corresponds to ext_mdio. But none of the board dts files in upstream
> >>>> have a compatible property for "ext_mdio". Which means fw_devlink
> >>>> _should_ propagate the gpio_intc IRQ dependency all the way up to
> >>>> eth_phy.
> >>>>
> >>>> Also, in the failing case, can you run:
> >>>> ls -ld supplier:*
> >>>>
> >>>> in the /sys/devices/....<something>/ folder that corresponds to the
> >>>> "eth_phy: mdio-multiplexer@4c000" DT node and tell me what it shows?
> >>>
> >>> Here you go:
> >>>
> >>> root@tiger-roach:~# find /sys/devices/ -name 'supplier*'|grep -i mdio=
 | xargs ls -ld
> >>> lrwxrwxrwx 1 root root 0 Aug  4 09:47 /sys/devices/platform/soc/ff600=
000.bus/ff64c000.mdio-multiplexer/supplier:platform:ff63c000.system-control=
ler:clock-controller -> ../../../../virtual/devlink/platform:ff63c000.syste=
m-controller:clock-controller--platform:ff64c000.mdio-multiplexer
> >>
> >> As we discussed over chat, this was taken after the mdio-multiplexer
> >> driver "successfully" probes this device. This will cause
> >> SYNC_STATE_ONLY device links created by fw_devlink to be deleted
> >> (because they are useless after a device probes). So, this doesn't
> >> show the info I was hoping to demonstrate.
> >>
> >> In any case, one can see that fw_devlink properly created the device
> >> link for the clocks dependency. So fw_devlink is parsing this node
> >> properly. But it doesn't create a similar probe order enforcing device
> >> link between the mdio-multiplexer and the gpio_intc because the
> >> dependency is only present in a grand child DT node (ethernet-phy@0
> >> under ext_mdio). So fw_devlink is working as intended.
> >>
> >> I spent several hours squinting at the code/DT yesterday. Here's what
> >> is going on and causing the problem:
> >>
> >> The failing driver in this case is
> >> drivers/net/mdio/mdio-mux-meson-g12a.c. And the only DT node it's
> >> handling is what I pasted above in this email. In the failure case,
> >> the call flow is something like this:
> >>
> >> g12a_mdio_mux_probe()
> >> -> mdio_mux_init()
> >> -> of_mdiobus_register(ext_mdio DT node)
> >> -> of_mdiobus_register_phy(ext_mdio DT node)
> >> -> several calls deep fwnode_mdiobus_phy_device_register(ethernet_phy =
DT node)
> >> -> Tried to get the IRQ listed in ethernet_phy and fails with
> >> -EPROBE_DEFER because the IRQ driver isn't loaded yet.
> >>
> >> The error is propagated correctly all the way up to of_mdiobus_registe=
r(), but
> >> mdio_mux_init() ignores the -EPROBE_DEFER from of_mdiobus_register() a=
nd just
> >> continues on with the rest of the stuff and returns success as long as
> >> one of the child nodes (in this case int_mdio) succeeds.
> >>
> >> Since the probe returns 0 without really succeeding, networking stuff
> >> just fails badly after this. So, IMO, the real problem is with
> >> mdio_mux_init() not propagating up the -EPROBE_DEFER. I gave Marc a
> >> quick hack (pasted at the end of this email) to test my theory and he
> >> confirmed that it fixes the issue (a few deferred probes later, things
> >> work properly).
> >>
> >> Andrew, I don't see any good reason for mdio_mux_init() not
> >> propagating the errors up correctly (at least for EPROBE_DEFER). I'll
> >> send a patch to fix this. Please let me know if there's a reason it
> >> has to stay as-is.
> >
> > I sent out the proper fix as a series:
> > https://lore.kernel.org/lkml/20210804214333.927985-1-saravanak@google.c=
om/T/#t
>
> Thanks a lot for digging here and providing the appropriate fixes !

You are welcome!

Btw, 'm too lazy to download the mbox for your original patch
(justifiably not cc'ed in it) and reply to it. I made this comment
earlier too.

Can you please use the IRQCHIP_PLATFORM_DRIVER_BEGIN and
IRQCHIP_PLATFORM_DRIVER_END macros? They avoid boilerplate code every
irqchip driver has to implement, adds some restrictions to avoid
unbinding these drivers/unloading these modules, and also makes it
easy to convert from IRQCHIP_DECLARE to a platform driver. It'll also
allow you to drop the of_irq_find_parent() call in your probe.

Cheers,
Saravana

>
> Neil
>
> >
> > Marc, can you give it a shot please?
> >
> > -Saravana
> >
> >>
> >> -Saravana
> >>
> >> index 110e4ee85785..d973a267151f 100644
> >> --- a/drivers/net/mdio/mdio-mux.c
> >> +++ b/drivers/net/mdio/mdio-mux.c
> >> @@ -170,6 +170,9 @@ int mdio_mux_init(struct device *dev,
> >>                                 child_bus_node);
> >>                         mdiobus_free(cb->mii_bus);
> >>                         devm_kfree(dev, cb);
> >> +                       /* Not a final fix. I think it can cause UAF i=
ssues. */
> >> +                       mdio_mux_uninit(pb);
> >> +                       return r;
> >>                 } else {
> >>                         cb->next =3D pb->children;
> >>                         pb->children =3D cb;
>
