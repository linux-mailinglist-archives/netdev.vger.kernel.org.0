Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355593E0779
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 20:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbhHDSVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 14:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238225AbhHDSVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 14:21:44 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E35CC0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 11:21:30 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id a93so5222597ybi.1
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 11:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Tz1GuAJC1Dcc2Cwp31XbAVFfgoTWTu5esvYRUihyGEQ=;
        b=uxvxWPBoJsSiQbs/0t2u5kZG8l3rzz2f1UaMtJkaUQy7CiOS35QXMPD6+CZGCnjhe/
         5CVdWAuHiWarpgAlAi4oEHxWOikmVxIxyuFzIL5pYDOMDYZ8S8vYgSeMbUHQiEZfB/YO
         7pS6g3oR2UAWP9Zx8n7Q+ZnydrTgCUJB3nsZZXnE21XgJm9CySut4zo3FCo6ikQyBVuU
         X3ue6/X4199OOh2pHbJBWI59uU+FSBidzj77oyqrYdlVzijBfkwW0GpaehH6zmDh/i2B
         kL54eGC+exkHVOPELDzSTzj/8XhtqscwchuQMPTr/7B42FnPg9TOicwnujwBsa8RDsIN
         Ht4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Tz1GuAJC1Dcc2Cwp31XbAVFfgoTWTu5esvYRUihyGEQ=;
        b=g5FIQv0E6aZn/cWz58W2SYrbgivyj/XyXqta7pS9fBSzLj3yUOEpCOF3GoHntHWBlQ
         1isdVwikIWtZFh7tCqVUkf7AlQd18eW/JSkHS70iSVndFyOpnAx5IWylYAP5V3r3Pppp
         BPEAnhStdkQP80oEhWelidz4RqlWh86YXnr9ZHveiTVDE6gg15pb4OamzhEd5hEmNGDf
         ukarNI6tZd+H9KJXQZS0LRLe9hAlVvsh/Qq4xAXJsBfHYY4LWLVIDfpwetrJO6W/Cmvf
         7KcKio/KGnjL29vnoxZVVs+2uVzqzKKXZcc8ij8BlWvk2QbneCtSFdF3+jlZN33Y1+Od
         Y75A==
X-Gm-Message-State: AOAM533q5kk7IxP7lJvtyA126kE6ZlETTsKMdEKpy0H9Sq0uzPQtywpN
        6vAg53ROxsOQa3IirbAkWlPGoO2pa/XHAeFC7WPelQ==
X-Google-Smtp-Source: ABdhPJzcJcTQds3brNmFJ2jD3HuCgcog5CVxkfq2/DZ5es0w7fTU3EquuDayTJy2dBu/+gS8DdfjnJBBrxv9eVLkV/w=
X-Received: by 2002:a25:81ce:: with SMTP id n14mr935619ybm.32.1628101289301;
 Wed, 04 Aug 2021 11:21:29 -0700 (PDT)
MIME-Version: 1.0
References: <20201020072532.949137-1-narmstrong@baylibre.com>
 <20201020072532.949137-2-narmstrong@baylibre.com> <7hsga8kb8z.fsf@baylibre.com>
 <CAF2Aj3g6c8FEZb3e1by6sd8LpKLaeN5hsKrrQkZUvh8hosiW9A@mail.gmail.com>
 <87r1hwwier.wl-maz@kernel.org> <7h7diwgjup.fsf@baylibre.com>
 <87im0m277h.wl-maz@kernel.org> <CAGETcx9OukoWM_qprMse9aXdzCE=GFUgFEkfhhNjg44YYsOQLw@mail.gmail.com>
 <87sfzpwq4f.wl-maz@kernel.org>
In-Reply-To: <87sfzpwq4f.wl-maz@kernel.org>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 4 Aug 2021 11:20:52 -0700
Message-ID: <CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com>
Subject: Re: [PATCH 1/2] irqchip: irq-meson-gpio: make it possible to build as
 a module
To:     Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Kevin Hilman <khilman@baylibre.com>,
        Lee Jones <lee.jones@linaro.org>,
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

On Wed, Aug 4, 2021 at 1:50 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 04 Aug 2021 02:36:45 +0100,
> Saravana Kannan <saravanak@google.com> wrote:
>
> Hi Saravana,
>
> Thanks for looking into this.

You are welcome. I just don't want people to think fw_devlink is broken :)

>
> [...]
>
> > > Saravana, could you please have a look from a fw_devlink perspective?
> >
> > Sigh... I spent several hours looking at this and wrote up an analysis
> > and then realized I might be looking at the wrong DT files.
> >
> > Marc, can you point me to the board file in upstream that corresponds
> > to the platform in which you see this issue? I'm not asking for [1],
> > but the actual final .dts (not .dtsi) file that corresponds to the
> > platform/board/system.
>
> The platform I can reproduce this on is described in
> arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts. It is an
> intricate maze of inclusion, node merge and other DT subtleties. I
> suggest you look at the decompiled version to get a view of the
> result.

Thanks. After decompiling it, it looks something like (stripped a
bunch of reg and address properties and added the labels back):

eth_phy: mdio-multiplexer@4c000 {
        compatible =3D "amlogic,g12a-mdio-mux";
        clocks =3D <0x02 0x13 0x1e 0x02 0xb1>;
        clock-names =3D "pclk\0clkin0\0clkin1";
        mdio-parent-bus =3D <0x22>;

        ext_mdio: mdio@0 {
                reg =3D <0x00>;

                ethernet-phy@0 {
                        max-speed =3D <0x3e8>;
                        interrupt-parent =3D <0x23>;
                        interrupts =3D <0x1a 0x08>;
                        phandle =3D <0x16>;
                };
        };

        int_mdio: mdio@1 {
                ...
        }
}

And phandle 0x23 refers to the gpio_intc interrupt controller with the
modular driver.

> > Based on your error messages, it's failing for mdio@0 which
> > corresponds to ext_mdio. But none of the board dts files in upstream
> > have a compatible property for "ext_mdio". Which means fw_devlink
> > _should_ propagate the gpio_intc IRQ dependency all the way up to
> > eth_phy.
> >
> > Also, in the failing case, can you run:
> > ls -ld supplier:*
> >
> > in the /sys/devices/....<something>/ folder that corresponds to the
> > "eth_phy: mdio-multiplexer@4c000" DT node and tell me what it shows?
>
> Here you go:
>
> root@tiger-roach:~# find /sys/devices/ -name 'supplier*'|grep -i mdio | x=
args ls -ld
> lrwxrwxrwx 1 root root 0 Aug  4 09:47 /sys/devices/platform/soc/ff600000.=
bus/ff64c000.mdio-multiplexer/supplier:platform:ff63c000.system-controller:=
clock-controller -> ../../../../virtual/devlink/platform:ff63c000.system-co=
ntroller:clock-controller--platform:ff64c000.mdio-multiplexer

As we discussed over chat, this was taken after the mdio-multiplexer
driver "successfully" probes this device. This will cause
SYNC_STATE_ONLY device links created by fw_devlink to be deleted
(because they are useless after a device probes). So, this doesn't
show the info I was hoping to demonstrate.

In any case, one can see that fw_devlink properly created the device
link for the clocks dependency. So fw_devlink is parsing this node
properly. But it doesn't create a similar probe order enforcing device
link between the mdio-multiplexer and the gpio_intc because the
dependency is only present in a grand child DT node (ethernet-phy@0
under ext_mdio). So fw_devlink is working as intended.

I spent several hours squinting at the code/DT yesterday. Here's what
is going on and causing the problem:

The failing driver in this case is
drivers/net/mdio/mdio-mux-meson-g12a.c. And the only DT node it's
handling is what I pasted above in this email. In the failure case,
the call flow is something like this:

g12a_mdio_mux_probe()
-> mdio_mux_init()
-> of_mdiobus_register(ext_mdio DT node)
-> of_mdiobus_register_phy(ext_mdio DT node)
-> several calls deep fwnode_mdiobus_phy_device_register(ethernet_phy DT no=
de)
-> Tried to get the IRQ listed in ethernet_phy and fails with
-EPROBE_DEFER because the IRQ driver isn't loaded yet.

The error is propagated correctly all the way up to of_mdiobus_register(), =
but
mdio_mux_init() ignores the -EPROBE_DEFER from of_mdiobus_register() and ju=
st
continues on with the rest of the stuff and returns success as long as
one of the child nodes (in this case int_mdio) succeeds.

Since the probe returns 0 without really succeeding, networking stuff
just fails badly after this. So, IMO, the real problem is with
mdio_mux_init() not propagating up the -EPROBE_DEFER. I gave Marc a
quick hack (pasted at the end of this email) to test my theory and he
confirmed that it fixes the issue (a few deferred probes later, things
work properly).

Andrew, I don't see any good reason for mdio_mux_init() not
propagating the errors up correctly (at least for EPROBE_DEFER). I'll
send a patch to fix this. Please let me know if there's a reason it
has to stay as-is.

-Saravana

index 110e4ee85785..d973a267151f 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
@@ -170,6 +170,9 @@ int mdio_mux_init(struct device *dev,
                                child_bus_node);
                        mdiobus_free(cb->mii_bus);
                        devm_kfree(dev, cb);
+                       /* Not a final fix. I think it can cause UAF issues=
. */
+                       mdio_mux_uninit(pb);
+                       return r;
                } else {
                        cb->next =3D pb->children;
                        pb->children =3D cb;
