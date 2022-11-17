Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2D962DCF5
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240167AbiKQNjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240154AbiKQNjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:39:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E266312D1E;
        Thu, 17 Nov 2022 05:39:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75F9561E27;
        Thu, 17 Nov 2022 13:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5066C4314B;
        Thu, 17 Nov 2022 13:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668692348;
        bh=/UK+9sDrGPjgYtOOoh910+Ifr/UWpMEvVanzIq+snBo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iM5BRIb4wuR5k4Un53xb27JuddLigAwQBtkaGctVlq6BYa4RLyWlNA8DGL9rPM249
         wi+pLcecfJZOq0WDMGmCgHVksj5jTqKr0Qliy/4zbtVUv5t49Lybv2iO83ulkwxrLO
         CCEzZNqIIUgtHDBsJag5UxyXwEKOi3tFakAtSGA+wr/cwrowHb3f20aOZ50fkJEtWm
         rZ0MEjQsoauuoCiGVSlelELIDxMtVXcZVV/71GnM7lD1MWP6XqR6QlNAr/rWJIrZHK
         WrRgdkVhhTpiV+v4SKZAo9ZxyJCD4FCh29vtEv6y43om+vR7uhlbYyFLzqaVn6G7Rj
         dlUqzsb/FQeyA==
Received: by mail-lj1-f182.google.com with SMTP id l8so2688784ljh.13;
        Thu, 17 Nov 2022 05:39:08 -0800 (PST)
X-Gm-Message-State: ANoB5pllpQAgGs+Z11h5PvmN4GJ0Pp+n90shTblZ/IYGOW5/kqmfIwqF
        UlTnI9tMgV9MOH/7wLuYbnS2p1EGMXVayDn2Iw==
X-Google-Smtp-Source: AA0mqf68l6JlfMAOxB9IAZotx0gr19b4kW6puUPFGWYKGLd9TbYZHrsir62Is5Ol46Kkm065jI97tYyYf0dpuvBsM3M=
X-Received: by 2002:a05:651c:2328:b0:277:14cf:6da2 with SMTP id
 bi40-20020a05651c232800b0027714cf6da2mr960398ljb.94.1668692346755; Thu, 17
 Nov 2022 05:39:06 -0800 (PST)
MIME-Version: 1.0
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221109224110.erfaftzja4fybdbc@skbuf> <bcb87445-d80d-fea0-82f2-a15b20baaf06@seco.com>
 <20221110152925.3gkkp5opf74oqrxb@skbuf> <7b4fb14f-1ca0-e4f8-46ca-3884392627c2@seco.com>
 <20221110160008.6t53ouoxqeu7w7qr@skbuf> <ce6d6a26-4867-6385-8c64-0f374d027754@seco.com>
 <20221114172357.hdzua4xo7wixtbgs@skbuf> <209a0d25-f109-601f-d6f6-1adc44103aee@seco.com>
 <20221114195321.uludij5x747uzcxr@skbuf>
In-Reply-To: <20221114195321.uludij5x747uzcxr@skbuf>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 17 Nov 2022 07:38:58 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK+NFL-K6TF+chEFSLh9OuvV+nKUAF5KtO=aBsvqqpd4w@mail.gmail.com>
Message-ID: <CAL_JsqK+NFL-K6TF+chEFSLh9OuvV+nKUAF5KtO=aBsvqqpd4w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 1:53 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Nov 14, 2022 at 01:08:03PM -0500, Sean Anderson wrote:
> > On 11/14/22 12:23, Vladimir Oltean wrote:
> > > On Thu, Nov 10, 2022 at 11:56:15AM -0500, Sean Anderson wrote:
> > >> these will probably be in device trees for a year before the kernel
> > >> starts using them. But once that is done, we are free to require them.
> > >
> > > Sorry, you need to propose something that is not "we can break compatibility
> > > with today's device trees one year from now".
> >
> > But only if the kernel gets updated and not the device tree. When can
> > such a situation occur? Are we stuck with this for the next 10 years all
> > because someone may have a device tree which they compiled in 2017, and
> > *insist* on using the latest kernel with? Is this how you run your
> > systems?
>
> I'm a developer (and I work on other platforms than the ones you're
> planning to break), so the answer to this question doesn't mean a thing.
>
> > We don't get the device tree from firmware on this platform; usually it
> > is bundled with the kernel in a FIT or loaded from the same disk
> > partition as the kernel. I can imagine that they might not always be
> > updated at exactly the same time, but this is nuts.
>
> What does "this" platform mean exactly? There are many platforms to
> which you've added compatible strings to keep things working assuming a
> dtb update, many of them very old. And those to which you did are not by
> far all that exist. There is no requirement that all platform device
> trees are upstreamed to the Linux kernel.
>
> > The original device tree is broken because it doesn't include compatible
> > strings for devices on a generic bus. There's no way to fix that other
> > than hard-coding the driver. This can be done for some buses, but this
> > is an MDIO bus and we already assume devices without compatibles are
> > PHYs.
>
> Let's be clear about this. It's "broken" in the sense that you don't like
> the way in which it works, not in the sense that it results in a system
> that doesn't work. And not having a compatible string is just as broken
> as it is for other devices with detectable device IDs, like Ethernet
> PHYs in general, PCI devices, etc.
>
> The way in which that works here, specifically, is that a generic PHY driver
> is bound to the Lynx PCS devices, driver which does nothing since nobody
> calls phy_attach_direct() to it. Then, using fwnode_mdio_find_device(),
> you follow the pcsphy-handle and you get a reference to the mdio_device
> (parent class of phy_device) object that resulted from the generic PHY
> driver probing on the PCS, and you program the PCS to do what you want.
>
> The PHY core does assume that mdio_devices without compatible strings
> are phy_devices, but also makes exceptions (and warns about it) - see
> commit ae461131960b ("of: of_mdio: Add a whitelist of PHY compatibilities.").
> Maybe the reverse exception could also be made, and a warning for that
> be added as well.
>
> > In the next version of this series, I will include a compatibility
> > function which can bind a driver automatically if one is missing when
> > looking up a phy. But I would really like to have an exit strategy.
>
> You'll have to get agreement from higher level maintainers than me that
> the strategy "wait one year, break old device trees" is okay. Generally
> we wouldn't have answers to this kind of questions that depend on whom
> you ask. Otherwise.. we would all know whom to ask and whom not to ;)

A window of time can work, but only when there's other reasons
everyone must update the firmware/DT.

> Sadly I haven't found anything "official" in either Documentation/devicetree/usage-model.rst
> or Documentation/process/submitting-patches.rst. Maybe I missed it?

Documentation/devicetree/bindings/ABI.rst

The exact policy depends on the platform (or family of platforms). In
short, if *anyone* cares, then compatibility should not be broken.
Vladimir uses platforms in question and cares, so don't break the
platforms.

Rob
