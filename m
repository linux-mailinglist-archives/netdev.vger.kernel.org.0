Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053225735BE
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbiGMLpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiGMLpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:45:49 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07992FC980;
        Wed, 13 Jul 2022 04:45:48 -0700 (PDT)
Received: by mail-oi1-f180.google.com with SMTP id w184so7770374oie.3;
        Wed, 13 Jul 2022 04:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QW3oqiCBvV/mmmfK9tpRDVl5ot7G1y1i5VioSZJ8QMk=;
        b=mDPjbAC7RvvYsCf+WvNNqRFO//Ex0CvUezMgNWizoodlxe5aQALnE2V/W5IhaWPqSb
         2Jt25mE4jJap+7ns1/eeRkbZrmrxEP6Sq2jy8WG43orYlb3NGBWKFF1stLj/+qQwWRpc
         oxb7g70HNUjTn9hPgFRh+y5TeuxBTgyJLKB3NCTM4905fbS9P2G8BHO9LZOc/yDqQEhv
         oFRYxbPYHjT8bm/nUL6LLyQKAyRgMupyOndKyKI4yn4ojMHqEMLMBCKtv1f7jgys5cLd
         /53lMT3Qxq+zbjeepLaxgtmEiEBLn9EDzIiC5NZ7l6EgTePhWxrV2Q79O/pSwyGci3Mq
         kZMQ==
X-Gm-Message-State: AJIora8HSC50kD7YDeXXjlXv42+XsjEHf5AManBGirt+WRkye6a7X4At
        hs9oxLFpV3OjLj8jicjiSMc5sDuLZYgn+A==
X-Google-Smtp-Source: AGRyM1sHlMlHvD5RCxq842CtnAuvkBsVaNQJbrsSaLwKs4hFJfzoJDpzLOXnnFtEuOts0BRfa4ZNOQ==
X-Received: by 2002:a05:6808:d48:b0:339:b862:3abb with SMTP id w8-20020a0568080d4800b00339b8623abbmr1594893oik.22.1657712747044;
        Wed, 13 Jul 2022 04:45:47 -0700 (PDT)
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com. [209.85.161.52])
        by smtp.gmail.com with ESMTPSA id d8-20020a056870e24800b0010490c6b552sm5993344oac.35.2022.07.13.04.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 04:45:46 -0700 (PDT)
Received: by mail-oo1-f52.google.com with SMTP id x128-20020a4a4186000000b0043558a8e208so731928ooa.4;
        Wed, 13 Jul 2022 04:45:46 -0700 (PDT)
X-Received: by 2002:a05:6902:154f:b0:66e:e2d3:ce1 with SMTP id
 r15-20020a056902154f00b0066ee2d30ce1mr2997263ybu.365.1657712357596; Wed, 13
 Jul 2022 04:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-4-saravanak@google.com> <CAMuHMdWo_wRwV-i_iyTxVnEsf3Th9GBAG+wxUQMQGnw1t2ijTg@mail.gmail.com>
 <CAGETcx-jU5+Tc0Qkt1e4QY0YprYSp-4A+MoaSRjpdPp_8tZm5g@mail.gmail.com>
In-Reply-To: <CAGETcx-jU5+Tc0Qkt1e4QY0YprYSp-4A+MoaSRjpdPp_8tZm5g@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 13 Jul 2022 13:39:05 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUrpnsvc_G33FQA6GtqNowidMrjjYBEZW-_biBMYvqjgQ@mail.gmail.com>
Message-ID: <CAMuHMdUrpnsvc_G33FQA6GtqNowidMrjjYBEZW-_biBMYvqjgQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/9] net: mdio: Delete usage of driver_deferred_probe_check_state()
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On Wed, Jul 13, 2022 at 3:40 AM Saravana Kannan <saravanak@google.com> wrote:
> On Tue, Jul 5, 2022 at 2:11 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Jun 1, 2022 at 2:44 PM Saravana Kannan <saravanak@google.com> wrote:
> > > Now that fw_devlink=on by default and fw_devlink supports interrupt
> > > properties, the execution will never get to the point where
> > > driver_deferred_probe_check_state() is called before the supplier has
> > > probed successfully or before deferred probe timeout has expired.
> > >
> > > So, delete the call and replace it with -ENODEV.
> > >
> > > Signed-off-by: Saravana Kannan <saravanak@google.com>
> >
> > Thanks for your patch, which is now commit f8217275b57aa48d ("net:
> > mdio: Delete usage of driver_deferred_probe_check_state()") in
> > driver-core/driver-core-next.
> >
> > Seems like I missed something when providing my T-b for this series,
> > sorry for that.
>
> > arch/arm/boot/dts/r8a7791-koelsch.dts has:
> >
> >     &ether {
> >             pinctrl-0 = <&ether_pins>, <&phy1_pins>;
> >             pinctrl-names = "default";
> >
> >             phy-handle = <&phy1>;
> >             renesas,ether-link-active-low;
> >             status = "okay";
> >
> >             phy1: ethernet-phy@1 {
> >                     compatible = "ethernet-phy-id0022.1537",
> >                                  "ethernet-phy-ieee802.3-c22";
> >                     reg = <1>;
> >                     interrupt-parent = <&irqc0>;
> >                     interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
> >                     micrel,led-mode = <1>;
> >                     reset-gpios = <&gpio5 22 GPIO_ACTIVE_LOW>;
> >             };
> >     };
> >
> > Despite the interrupts property, &ether is now probed before irqc0
> > (interrupt-controller@e61c0000 in arch/arm/boot/dts/r8a7791.dtsi),
> > causing the PHY not finding its interrupt, and resorting to polling:
>
> I'd still expect the device link to have been created properly for
> this phy device. Could you enable the logging in device_link_add() to
> check the link is created between the phy and the IRQ?
>
> My guess is that this probably has something to do with phys being
> attached to drivers differently.

Comparison of dmesg before/after enabling debugging, for
related nodes:

    +interrupt-controller@e61c0000 Linked as a fwnode consumer to
clock-controller@e6150000

    +pmic@58 Linked as a fwnode consumer to interrupt-controller@e61c0000
    +regulator@68 Linked as a fwnode consumer to interrupt-controller@e61c0000

Other user of irqc

    +ethernet@ee700000 Linked as a fwnode consumer to clock-controller@e6150000
    +ethernet@ee700000 Linked as a fwnode consumer to pinctrl@e6060000
    +ethernet-phy@1 Linked as a fwnode consumer to interrupt-controller@e61c0000
    +ethernet-phy@1 Linked as a fwnode consumer to gpio@e6055000

PHY linked correctly to consumers

    +device: 'e61c0000.interrupt-controller': device_add
    +device: 'platform:e6150000.clock-controller--platform:e61c0000.interrupt-controller':
device_add
    +devices_kset: Moving e61c0000.interrupt-controller to end of list
    +platform e61c0000.interrupt-controller: Linked as a consumer to
e6150000.clock-controller
    +interrupt-controller@e61c0000 Dropping the fwnode link to
clock-controller@e6150000
    +platform e61c0000.interrupt-controller: error -EPROBE_DEFER:
supplier e6150000.clock-controller not ready

Tried to probe irqc (why? consumer not ready), deferred.

    +device: 'platform:e61c0000.interrupt-controller--platform:e60b0000.i2c':
device_add
    +platform e60b0000.i2c: Linked as a sync state only consumer to
e61c0000.interrupt-controller

I guess sync state means through other (child) consumers (pmic,
regulator) above?

    +device: 'ee700000.ethernet': device_add
    +device: 'platform:e6060000.pinctrl--platform:ee700000.ethernet': device_add
    +devices_kset: Moving ee700000.ethernet to end of list
    +platform ee700000.ethernet: Linked as a consumer to e6060000.pinctrl
    +ethernet@ee700000 Dropping the fwnode link to pinctrl@e6060000
    +device: 'platform:e6150000.clock-controller--platform:ee700000.ethernet':
device_add
    +devices_kset: Moving ee700000.ethernet to end of list
    +platform ee700000.ethernet: Linked as a consumer to
e6150000.clock-controller
    +ethernet@ee700000 Dropping the fwnode link to clock-controller@e6150000
    +device: 'platform:e6055000.gpio--platform:ee700000.ethernet': device_add
    +platform ee700000.ethernet: Linked as a sync state only consumer
to e6055000.gpio
    +device: 'platform:e61c0000.interrupt-controller--platform:ee700000.ethernet':
device_add
    +platform ee700000.ethernet: Linked as a sync state only consumer
to e61c0000.interrupt-controller

Hence linking ethernet to child (phy) consumers.

    +device: 'ee700000.ethernet-ffffffff': device_add

Probing ethernet...

     libphy: fwnode_get_phy_id: fwnode
/soc/ethernet@ee700000/ethernet-phy@1 phy_id = 0x00221537
     libphy: fwnode_get_phy_id: fwnode
/soc/ethernet@ee700000/ethernet-phy@1 phy_id = 0x00221537
    +fwnode_mdiobus_phy_device_register: fwnode_irq_get() returned -517
    +fwnode_mdiobus_phy_device_register: ignoring -EPROBE_DEFER

This is the part that got changed by this patch.

    +device: 'ee700000.ethernet-ffffffff:01': device_add
    +device: 'platform:e6055000.gpio--mdio_bus:ee700000.ethernet-ffffffff:01':
device_add
    +devices_kset: Moving ee700000.ethernet-ffffffff:01 to end of list
    +mdio_bus ee700000.ethernet-ffffffff:01: Linked as a consumer to
e6055000.gpio
    +ethernet-phy@1 Dropping the fwnode link to gpio@e6055000
    +device: 'platform:e61c0000.interrupt-controller--mdio_bus:ee700000.ethernet-ffffffff:01':
device_add
    +devices_kset: Moving ee700000.ethernet-ffffffff:01 to end of list
    +mdio_bus ee700000.ethernet-ffffffff:01: Linked as a consumer to
e61c0000.interrupt-controller
    +ethernet-phy@1 Dropping the fwnode link to interrupt-controller@e61c0000
    +mdio_bus ee700000.ethernet-ffffffff:01: error -EPROBE_DEFER:
supplier e61c0000.interrupt-controller not ready

Why was ethernet probed this early?
We knew the supplier of the phy was still missing?

    +device: 'eth1': device_add
     sh-eth ee700000.ethernet eth1: Base address at 0xee700000,
2e:09:0a:00:6d:85, IRQ 104.
    +sh-eth ee700000.ethernet: Dropping the link to e6055000.gpio
    +device: 'platform:e6055000.gpio--platform:ee700000.ethernet':
device_unregister
    +sh-eth ee700000.ethernet: Dropping the link to
e61c0000.interrupt-controller
    +device: 'platform:e61c0000.interrupt-controller--platform:ee700000.ethernet':
device_unregister

    +devices_kset: Moving e61c0000.interrupt-controller to end of list
    +devices_kset: Moving ee700000.ethernet-ffffffff:01 to end of list
     renesas_irqc e61c0000.interrupt-controller: driving 10 irqs

Finally, irqc is probed.

    +device: '6-0058': device_add
    +device: 'platform:e61c0000.interrupt-controller--i2c:6-0058': device_add
    +devices_kset: Moving 6-0058 to end of list
    +i2c 6-0058: Linked as a consumer to e61c0000.interrupt-controller
    +pmic@58 Dropping the fwnode link to interrupt-controller@e61c0000

    +device: '6-0068': device_add
    +device: 'platform:e61c0000.interrupt-controller--i2c:6-0068': device_add
    +devices_kset: Moving 6-0068 to end of list
    +i2c 6-0068: Linked as a consumer to e61c0000.interrupt-controller
    +regulator@68 Dropping the fwnode link to interrupt-controller@e61c0000

Propagating other irqc suppliers to the parent of their consumers

    +i2c-sh_mobile e60b0000.i2c: Dropping the link to
e61c0000.interrupt-controller
    +device: 'platform:e61c0000.interrupt-controller--platform:e60b0000.i2c':
device_unregister

    +devices_kset: Moving ee700000.ethernet-ffffffff:01 to end of list

     Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: attached PHY
driver (mii_bus:phy_addr=ee700000.ethernet-ffffffff:01, irq=POLL)
     sh-eth ee700000.ethernet eth1: Link is Up - 100Mbps/Full - flow control off
     Sending DHCP requests ., OK

> >     -Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: attached PHY
> > driver (mii_bus:phy_addr=ee700000.ethernet-ffffffff:01, irq=185)
> >     +Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: attached PHY
> > driver (mii_bus:phy_addr=ee700000.ethernet-ffffffff:01, irq=POLL)
>
> Can you drop a WARN() where this is printed to get the stack trace to
> check my hypothesis?

That didn't help much, as this is the messenger, not the cause.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
