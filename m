Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F213EDEA9
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 22:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhHPU2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 16:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhHPU2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 16:28:16 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B168DC061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 13:27:44 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id z18so35217324ybg.8
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 13:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qNg/GX6UTjDIl7oF+x+/YFK4sn62S5tBOd2b2dnw+fU=;
        b=I73TD2Rn9QBg0HjC4Fa44cxb5Ven2z8iOfr8WIYOVBia2dDdDG+g6UrGWOKMFnSlTh
         awu5VL35rGcl2qrFupuW9Ow3p2JTGzksvYtUqKzZptAYmwChTtiIfEAQK4S4z+KP9jww
         IxK9UV1IscIEp+fv+7xOUyKXWhgz9CgmZ9lXAq6B8mf9cRqYPKOkEUszq+MAxfH/jaDt
         fechKWmv/3TrCJpknZfpApOKCmbd23Cy9C11iQeKDs90HnxXG/zLHlPezHY12i6ZGGts
         QMU6fyDdIkllnJKpB+qimhQdwpdToXaUNcVwY86ztQRXAiqd5oN2JH3wPS+j8q8TnSCX
         DoAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qNg/GX6UTjDIl7oF+x+/YFK4sn62S5tBOd2b2dnw+fU=;
        b=aE7YqnF5zYIUg373EsTU39hsd9uEUmzDaDkTZIbGGIhbbB+CRuPqd09ezcH9pWoIcM
         qGqVrMT/VR7EF8BhzrpEGe1mL9XGOCGt22f01UyhVowdRdswaQbdNaa45QUjsjaFkrFS
         eEtTGqC1u7dtBo8b6hSGbFeVN9ePHOrgDZzoQ9Ze8dBLYj+XCeFUTfpPLKO1mUJGFF2M
         ZCtZk/QFcsWlZMAQUuaUraj4sPeL8UFQKQDi1hc+SvZ0EdL5SBXY4YdrkQlOZBWKgO6u
         2PrD1hz2zmraJhTOO6zWWdme+F337RXyB84XLa3UF/dLGjdrB9NKB2xz2+PVSCZFrQEc
         kqng==
X-Gm-Message-State: AOAM533hscVumXunJOrGg3kPBFrZhlb+1nalEkXAln+IiWmu13VYhYG8
        yLwXK+StnHRlA7EnGK89Dnqqho1gpOFKtamJuQw0dw==
X-Google-Smtp-Source: ABdhPJyU9dW7EAVtL+Is9ddxqf3flWsu+/7498Z2kNVUZKQXDTikMHXYcPEE0Oruta0vFH2KLZ88KpIwZPd2xKsrg/Y=
X-Received: by 2002:a25:8445:: with SMTP id r5mr349687ybm.20.1629145663712;
 Mon, 16 Aug 2021 13:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <7hsga8kb8z.fsf@baylibre.com> <CAF2Aj3g6c8FEZb3e1by6sd8LpKLaeN5hsKrrQkZUvh8hosiW9A@mail.gmail.com>
 <87r1hwwier.wl-maz@kernel.org> <7h7diwgjup.fsf@baylibre.com>
 <87im0m277h.wl-maz@kernel.org> <CAGETcx9OukoWM_qprMse9aXdzCE=GFUgFEkfhhNjg44YYsOQLw@mail.gmail.com>
 <87sfzpwq4f.wl-maz@kernel.org> <CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com>
 <CAGETcx8bpWQEnkpJ0YW9GqX8WE0ewT45zqkbWWdZ0ktJBhG4yQ@mail.gmail.com>
 <YQuZ2cKVE+3Os25Z@google.com> <YRpeVLf18Z+1R7WE@google.com>
In-Reply-To: <YRpeVLf18Z+1R7WE@google.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 16 Aug 2021 13:27:07 -0700
Message-ID: <CAGETcx-gSJD0Ra=U_55k3Anps11N_3Ev9gEQV6NaXOvqwP0J3g@mail.gmail.com>
Subject: Re: [PATCH 1/2] irqchip: irq-meson-gpio: make it possible to build as
 a module
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
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

On Mon, Aug 16, 2021 at 5:47 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Thu, 05 Aug 2021, Lee Jones wrote:
>
> > On Wed, 04 Aug 2021, Saravana Kannan wrote:
> >
> > > On Wed, Aug 4, 2021 at 11:20 AM Saravana Kannan <saravanak@google.com=
> wrote:
> > > >
> > > > On Wed, Aug 4, 2021 at 1:50 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > >
> > > > > On Wed, 04 Aug 2021 02:36:45 +0100,
> > > > > Saravana Kannan <saravanak@google.com> wrote:
> > > > >
> > > > > Hi Saravana,
> > > > >
> > > > > Thanks for looking into this.
> > > >
> > > > You are welcome. I just don't want people to think fw_devlink is br=
oken :)
> > > >
> > > > >
> > > > > [...]
> > > > >
> > > > > > > Saravana, could you please have a look from a fw_devlink pers=
pective?
> > > > > >
> > > > > > Sigh... I spent several hours looking at this and wrote up an a=
nalysis
> > > > > > and then realized I might be looking at the wrong DT files.
> > > > > >
> > > > > > Marc, can you point me to the board file in upstream that corre=
sponds
> > > > > > to the platform in which you see this issue? I'm not asking for=
 [1],
> > > > > > but the actual final .dts (not .dtsi) file that corresponds to =
the
> > > > > > platform/board/system.
> > > > >
> > > > > The platform I can reproduce this on is described in
> > > > > arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts. It is an
> > > > > intricate maze of inclusion, node merge and other DT subtleties. =
I
> > > > > suggest you look at the decompiled version to get a view of the
> > > > > result.
> > > >
> > > > Thanks. After decompiling it, it looks something like (stripped a
> > > > bunch of reg and address properties and added the labels back):
> > > >
> > > > eth_phy: mdio-multiplexer@4c000 {
> > > >         compatible =3D "amlogic,g12a-mdio-mux";
> > > >         clocks =3D <0x02 0x13 0x1e 0x02 0xb1>;
> > > >         clock-names =3D "pclk\0clkin0\0clkin1";
> > > >         mdio-parent-bus =3D <0x22>;
> > > >
> > > >         ext_mdio: mdio@0 {
> > > >                 reg =3D <0x00>;
> > > >
> > > >                 ethernet-phy@0 {
> > > >                         max-speed =3D <0x3e8>;
> > > >                         interrupt-parent =3D <0x23>;
> > > >                         interrupts =3D <0x1a 0x08>;
> > > >                         phandle =3D <0x16>;
> > > >                 };
> > > >         };
> > > >
> > > >         int_mdio: mdio@1 {
> > > >                 ...
> > > >         }
> > > > }
> > > >
> > > > And phandle 0x23 refers to the gpio_intc interrupt controller with =
the
> > > > modular driver.
> > > >
> > > > > > Based on your error messages, it's failing for mdio@0 which
> > > > > > corresponds to ext_mdio. But none of the board dts files in ups=
tream
> > > > > > have a compatible property for "ext_mdio". Which means fw_devli=
nk
> > > > > > _should_ propagate the gpio_intc IRQ dependency all the way up =
to
> > > > > > eth_phy.
> > > > > >
> > > > > > Also, in the failing case, can you run:
> > > > > > ls -ld supplier:*
> > > > > >
> > > > > > in the /sys/devices/....<something>/ folder that corresponds to=
 the
> > > > > > "eth_phy: mdio-multiplexer@4c000" DT node and tell me what it s=
hows?
> > > > >
> > > > > Here you go:
> > > > >
> > > > > root@tiger-roach:~# find /sys/devices/ -name 'supplier*'|grep -i =
mdio | xargs ls -ld
> > > > > lrwxrwxrwx 1 root root 0 Aug  4 09:47 /sys/devices/platform/soc/f=
f600000.bus/ff64c000.mdio-multiplexer/supplier:platform:ff63c000.system-con=
troller:clock-controller -> ../../../../virtual/devlink/platform:ff63c000.s=
ystem-controller:clock-controller--platform:ff64c000.mdio-multiplexer
> > > >
> > > > As we discussed over chat, this was taken after the mdio-multiplexe=
r
> > > > driver "successfully" probes this device. This will cause
> > > > SYNC_STATE_ONLY device links created by fw_devlink to be deleted
> > > > (because they are useless after a device probes). So, this doesn't
> > > > show the info I was hoping to demonstrate.
> > > >
> > > > In any case, one can see that fw_devlink properly created the devic=
e
> > > > link for the clocks dependency. So fw_devlink is parsing this node
> > > > properly. But it doesn't create a similar probe order enforcing dev=
ice
> > > > link between the mdio-multiplexer and the gpio_intc because the
> > > > dependency is only present in a grand child DT node (ethernet-phy@0
> > > > under ext_mdio). So fw_devlink is working as intended.
> > > >
> > > > I spent several hours squinting at the code/DT yesterday. Here's wh=
at
> > > > is going on and causing the problem:
> > > >
> > > > The failing driver in this case is
> > > > drivers/net/mdio/mdio-mux-meson-g12a.c. And the only DT node it's
> > > > handling is what I pasted above in this email. In the failure case,
> > > > the call flow is something like this:
> > > >
> > > > g12a_mdio_mux_probe()
> > > > -> mdio_mux_init()
> > > > -> of_mdiobus_register(ext_mdio DT node)
> > > > -> of_mdiobus_register_phy(ext_mdio DT node)
> > > > -> several calls deep fwnode_mdiobus_phy_device_register(ethernet_p=
hy DT node)
> > > > -> Tried to get the IRQ listed in ethernet_phy and fails with
> > > > -EPROBE_DEFER because the IRQ driver isn't loaded yet.
> > > >
> > > > The error is propagated correctly all the way up to of_mdiobus_regi=
ster(), but
> > > > mdio_mux_init() ignores the -EPROBE_DEFER from of_mdiobus_register(=
) and just
> > > > continues on with the rest of the stuff and returns success as long=
 as
> > > > one of the child nodes (in this case int_mdio) succeeds.
> > > >
> > > > Since the probe returns 0 without really succeeding, networking stu=
ff
> > > > just fails badly after this. So, IMO, the real problem is with
> > > > mdio_mux_init() not propagating up the -EPROBE_DEFER. I gave Marc a
> > > > quick hack (pasted at the end of this email) to test my theory and =
he
> > > > confirmed that it fixes the issue (a few deferred probes later, thi=
ngs
> > > > work properly).
> > > >
> > > > Andrew, I don't see any good reason for mdio_mux_init() not
> > > > propagating the errors up correctly (at least for EPROBE_DEFER). I'=
ll
> > > > send a patch to fix this. Please let me know if there's a reason it
> > > > has to stay as-is.
> > >
> > > I sent out the proper fix as a series:
> > > https://lore.kernel.org/lkml/20210804214333.927985-1-saravanak@google=
.com/T/#t
> > >
> > > Marc, can you give it a shot please?
> > >
> > > -Saravana
> >
> > Superstar!  Thanks for taking the time to rectify this for all of us.
>
> Just to clarify:
>
>   Are we waiting on a subsequent patch submission at this point?

Not that I'm aware of. Andrew added a "Reviewed-by" to all 3 of my
proper fix patches. I didn't think I needed to send any newer patches.
Is there some reason you that I needed to?
https://lore.kernel.org/lkml/20210804214333.927985-1-saravanak@google.com/T=
/#t

-Saravana


>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> Senior Technical Lead - Developer Services
> Linaro.org =E2=94=82 Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
