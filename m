Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CA25846C9
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiG1T4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiG1T4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:56:14 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045911EAF8;
        Thu, 28 Jul 2022 12:56:13 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id l23so4906967ejr.5;
        Thu, 28 Jul 2022 12:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=23Sd2xIN82EOQiIuRt3XKUvtySER7Ov5KCo8A2pZCxQ=;
        b=eRc66/m/Ka3NjiL1/fpNSKWbDrz+VmeP2irbB7BFtueB5plSi8IreX3VViYAs79GqE
         lNj55MGf567i22ireDjqURmbbcVE7o3R3za0lnOYgQoKQMPRq+2lRe2M9RdzIeZ879Zv
         eUeocDrC1PTlLxOHua1f3+XZwNbbdLf5sQjkt1SkA3JeNOjMrZsnr6s6wfl8Y8k+VsOi
         RSIVyGcfuyAoNHYumDf55wwvmZ2Gug+JugboqXDstgaH6+xnTixm4rJ9gGfCHxCY9ZZQ
         2qCZxvcLtZdtsIOrPG8IXKwWsWpCKwVQgcyOGx8aVPL0vhz+o0ZW2/gf8rwTQUNMa/vj
         UrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=23Sd2xIN82EOQiIuRt3XKUvtySER7Ov5KCo8A2pZCxQ=;
        b=f0X8ehdC9vW9hu1vqACt+CjgwxaDrkOJoEJWEvnQo7CYJgxXYWyIDW0ztCZU+HPh0h
         QuVei8qyfUjmUdxQxr3ZBSNmDzv4waWvdBMCywFj5jviqyT6bhYRW8/fnPjJNf99Bpkr
         U1iOv2Wh08A4UB5prVmIiwaKj+VtT1Hntia4KHvOSUjXeEDvPSMOMR9yzPnsG9PZwpL1
         CLSppXVt0ezKbT+igBx4dDnKXA3E18eFqIQwgXsi9pMt3RA65iIW8j/A1T6o3rN+c6b7
         pCUWHyshezu3hhwPUxxhUH/NSuUMrd/d0z6pflPprBbOoorFFQ6nLK1TTB4Tn6aXME21
         VBlg==
X-Gm-Message-State: AJIora8aDQUsW/882o9sdyh0KY8wNVO/2OrSexHohTXj9FDXP/j2zhTO
        RI5UM2hXuxBO/kp+8Qh52/o=
X-Google-Smtp-Source: AGRyM1tEQQwG4tTrX1oCSTbRWTjQdzqZ1trLdx4tt/8E8oLonnzoxo+N6/fwnicyr8jg4L+itB0Y0Q==
X-Received: by 2002:a17:907:3e0e:b0:72b:568f:7fa7 with SMTP id hp14-20020a1709073e0e00b0072b568f7fa7mr379038ejc.119.1659038171184;
        Thu, 28 Jul 2022 12:56:11 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id k10-20020aa7d8ca000000b0043cb1a83c9fsm1197998eds.71.2022.07.28.12.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 12:56:10 -0700 (PDT)
Date:   Thu, 28 Jul 2022 22:56:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to
 fwnode_find_net_device_by_node()
Message-ID: <20220728195607.co75o3k2ggjlszlw@skbuf>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf>
 <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf>
 <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
 <20220727211112.kcpbxbql3tw5q5sx@skbuf>
 <CAPv3WKcc2i6HsraP3OSrFY0YiBOAHwBPxJUErg_0p7mpGjn3Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKcc2i6HsraP3OSrFY0YiBOAHwBPxJUErg_0p7mpGjn3Ug@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 08:47:58AM +0200, Marcin Wojtas wrote:
> > The 'label' property of a port was optional, you've made it mandatory by accident.
> > It is used only by DSA drivers that register using platform data.
> 
> Thanks for spotting that, I will make it optional again.
> 
> > (side note, I can't believe you actually have a 'label' property for the
> > CPU port and how many people are in the same situation as you; you know
> > it isn't used for anything, right? how do we stop the cargo cult?)
> 
> Well, given these results:
> ~/git/linux : git grep 'label = \"cpu\"' arch/arm/boot/dts/ | wc -l
> 79
> ~/git/linux : git grep 'label = \"cpu\"' arch/arm64/boot/dts/ | wc -l
> 14
> 
> It's not a surprise I also have it defined in the platforms I test. I
> agree it doesn't serve any purpose in terms of creating the devices in
> DSA with DT, but it IMO increases readability of the description at
> least.

We've glided over this way too easily, so I'll repeat this thing I've said:

| One can have udev rules that assign names to Ethernet ports. I think
| that is even encouraged; some of the things in DSA predate the
| establishment of some best practices.

I know I'm not exactly "upfront" by saying this at v3 rather than earlier,
but I haven't had the time and I still don't have as much as I'd like.
Sorry for that.

Please don't jump to sending v4 just yet, and please don't expect that
this patch set will make it for the upcoming 5.20 release candidates.

ACPI is a whole new world and I don't think we want to mass-migrate each
and every OF binding that DSA has to the generic fwnode form, at least
not without having a serious discussion about it.

The 'label' thing is actually one of the things that I'm seriously
considering skipping parsing if this is an ACPI system, simply because
best practices are different today than they were when the OF bindings
were created.

There's also the change that validates that phylink has the fwnode
properties it needs to work properly:
https://patchwork.kernel.org/project/netdevbpf/patch/20220723164635.1621911-1-vladimir.oltean@nxp.com/

Please don't even think that the DSA fwnode conversion will be merged
before the validation patch (sorry, I'm not saying this to block you,
I'm saying this because I don't want DSA to start with zero-day baggage
on ACPI).

And even when the validation patch gets merged, you'll need to adapt it
to fwnode because that's what will be required syntactically, but we'll
only go through the motions of calling of_device_compatible_match() for
the OF case. With ACPI, every driver will opt into strict validation,
that's non negotiable.

And then there are some other issues we've learned about, with the DT
bindings that specific drivers such as mv88e6xxx and realtek-smi have.
I'll give you more details once we get to the actual mv88e6xxx
conversion to ACPI; currently my memory lacks some of the precise
details of how come mv88e6xxx came to not observe the issue but
realtek-smi did. Anyway, the issue was that fw_devlink causes the
internal PHYs to probe with the generic rather than the specific PHY
driver, if interrupts are being used (and provided by the switch as
'interrupt-controller').

It can be debated what exactly is at fault there, although one
interpretation can be that the DT bindings themselves are to blame,
for describing a circular dependency between a parent and a child.
I've been suggesting the authors of new drivers to take an alternative
approach and describe the switch chip as a MFD, with only the actual
switching component being probed by DSA and the rest being separate
drivers:
https://lore.kernel.org/all/20211204022037.dkipkk42qet4u7go@skbuf/T/

You'll say, ok but don't we have to keep maintaining mv8e6xxx OF bindings
functional with fw_devlink too anyway, so what benefit would there be if
for ACPI we'd split the exact same monolithic driver into a MFD?
And maybe you have a point, I don't know, I haven't actually tried to
look at the code and see if it could be restructured cleanly to probe
and work in both cases.

The bottom line is that if you haven't received too much review for your
series until now, I suspect it's because none of the DSA maintainers
cropped a large enough chunk of time yet to actually clarify things for
themselves. I don't consider the things I've pointed out here to be a
'review' in the proper sense, they're just cases I'm thinking about in
the back of my mind where we should learn from past mistakes.
I'll revisit when I will have come to some conclusions.
