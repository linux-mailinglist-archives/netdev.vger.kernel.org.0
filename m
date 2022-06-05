Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8030453D96F
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 05:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347813AbiFEDll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 23:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347599AbiFEDlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 23:41:40 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5C84EDC9
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 20:41:39 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2ef5380669cso115476597b3.9
        for <netdev@vger.kernel.org>; Sat, 04 Jun 2022 20:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8D/HSJdgvaLuLG5xNuCfkPKEmuWt/pvFegiJ6KrnY3I=;
        b=mKSUfps2jQlGQKb0Pj23vVrDLYVfTCLfU2eGOHO0w5RekTl50sZCBIWYc422QqsHPk
         /XxL89nyYHDRl97kUmDpzp8WH5h11lP4O0uUOKfMu2TnxilV4Z3H1a8ixh/gPQip4l40
         wv9fe46cZQak2RrkCbgmMKFh6esgjYM7h7RAsIe8vxQcm5WHJgj462Nkln6ihNULbmh5
         yKfql9QWwKpLtxGT6bBf9EVswVowh7YRTqi2uL7N1OXTRp8+5RQKQQC4NnLd+bozSnNH
         FjM1/Y2XwKhaUsQuFhdiKo8uc4DelbeZzUjCAGel2Nl/dlbPYYEsMvzYu7ek9W7Wbjzm
         hm/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8D/HSJdgvaLuLG5xNuCfkPKEmuWt/pvFegiJ6KrnY3I=;
        b=l8oMPuD2E0YvIEcbs+wV56rPshpgJBmCTVJcdK8t1pGtubnoBAgvjF4xAj0D8RmY10
         zoStnlhFLS++R/8enGd7AbqwNSbz1TUG+JRdmBgMMGH6tBAEIsYg3z2zNx4CN17bEhxO
         vgO60/KS8jpYH41Syg+zRJ/rj8LUlpPddHcIfiqPHvLo7/Ece9ET9EkeO1/oZIA0Gerw
         JGrqEeo6+UgIyf3QRnkTvi0cdzNWbwpNdf/8QuPzHFwidndfh6aHNsfprexyX8A+sBuE
         qhHl/lzwHU1tSRYSl9Z42ImoAt/ADNdr3aNhsULmacfvi4LVlsRcgXFeW7mroUheGnrR
         ydrA==
X-Gm-Message-State: AOAM533KsGyz1z4wLEFRyiwMT+cJgjHqeViGwEMlKqFu8sj1F47L/1WJ
        shdawGvCxPwWuGCxg7/esNf1VgPfCQ9t7dg7DwY+LQ==
X-Google-Smtp-Source: ABdhPJw562eb7reVPGNJbod3DV69zufo9T9SJHMXkVI4U3mBg/CR3ExMEoEaOQg+VaLP57X91Nj9UD9yZKT138G+/JQ=
X-Received: by 2002:a81:1a4c:0:b0:30c:8363:e170 with SMTP id
 a73-20020a811a4c000000b0030c8363e170mr18860130ywa.455.1654400497941; Sat, 04
 Jun 2022 20:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com>
 <20220526081550.1089805-3-saravanak@google.com> <CAMuHMdV4Uzfg8aBY=tKnRcig=Npebd158J7UK3zg5_DtHwAR5w@mail.gmail.com>
In-Reply-To: <CAMuHMdV4Uzfg8aBY=tKnRcig=Npebd158J7UK3zg5_DtHwAR5w@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Sat, 4 Jun 2022 20:41:01 -0700
Message-ID: <CAGETcx-=kAJp282OvG4yd830fhQowN7-yXifERqiHRi2w0bGFw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/9] pinctrl: devicetree: Delete usage of driver_deferred_probe_check_state()
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 2:22 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Saravana,
>
> Thanks for your patch!
>
> On Thu, May 26, 2022 at 10:16 AM Saravana Kannan <saravanak@google.com> wrote:
> > Now that fw_devlink=on by default and fw_devlink supports
> > "pinctrl-[0-8]" property, the execution will never get to the point
>
> 0-9?
>
> oh, it's really 0-8:
>
>     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl0, "pinctrl-0", NULL)
>     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl1, "pinctrl-1", NULL)
>     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl2, "pinctrl-2", NULL)
>     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl3, "pinctrl-3", NULL)
>     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl4, "pinctrl-4", NULL)
>     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl5, "pinctrl-5", NULL)
>     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl6, "pinctrl-6", NULL)
>     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
>     drivers/of/property.c:DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
>
> Looks fragile, especially since we now have:
>
>     arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi:
> pinctrl-9 = <&i2cmux_9>;
>     arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi: pinctrl-10
> = <&i2cmux_10>;
>     arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi: pinctrl-11
> = <&i2cmux_11>;
>     arch/arm64/boot/dts/microchip/sparx5_pcb134_board.dtsi: pinctrl-12
> = <&i2cmux_pins_i>;

Checking for pinctrl-* and then verifying if * matches %d would be
more complicated and probably more expensive compared to listing
pinctrl-[0-8]. Especially because more than 50% of pinctrl-*
properties in DT files are NOT pinctrl-%d. So back when we merged
this, Rob and I agreed [0-8] was good enough for now and we can add
more if we needed to. Also, when I checked back then, all the
pinctrl-5+ properties ended up pointing to the same suppliers as the
lower numbered ones. So it didn't make a difference.

Ok, I just checked linux-next all the pinctrl-9+ instances and it's
still true that they all point to the same supplier pointed to by
pinctrl-[0-8].

So yeah, it looks fragile, but is not broken and it's more efficient
than looking for pinctrl-%d or adding more pinctrl-xx entries. So,
let's fix it if it actually breaks? Not going to oppose a patch if
anyone wants to make it more complete.


-Saravana

>
> > where driver_deferred_probe_check_state() is called before the supplier
> > has probed successfully or before deferred probe timeout has expired.
> >
> > So, delete the call and replace it with -ENODEV.
> >
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
