Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3870D592C07
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbiHOIjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 04:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiHOIjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 04:39:04 -0400
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63B5201BA;
        Mon, 15 Aug 2022 01:39:01 -0700 (PDT)
Received: by mail-qk1-f177.google.com with SMTP id g21so1397525qka.5;
        Mon, 15 Aug 2022 01:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=JtDCKm0cVxqAL7Pu8sRszUiFCITK99XhKJIX5xTH4x0=;
        b=3BB7Wj5T6mz4vS17/lP3TNxbEKXpueP/U3C8QyBb1FS/Eu3B8PXeDUpD7O5B2tWmYo
         e631E5FMoH/PS1Sssg6N9lRq4TNsFk/UVHoIyzJUoA0lLnZhaxJCqwRSzqfl+h7borgW
         14uLnnnMOmqRzp3X5UzvkiMqjkmMgB8m7R9e+i1F4Q+ZBJ4HJAw9rSHisa2v5sU9yWZR
         3VCrqTesfI/pk2XS1nBXdz1pUKnuSX4ml32Wm3defOknoa7dFaXv2mdUWdj4YlQMu4SS
         VF6sxKRpynmHkCVmFjzTeqRaDokk9lwSpCCD2+zbb9/eQa7aTZGBanv1NFypryEGGQwW
         9Ipw==
X-Gm-Message-State: ACgBeo1Fs70PWQHacVhkoPb0WPfV9DJVixwOC8HGJt2crzJIsgPwKL/5
        A4DYDVtUdWgK3YYt8IETi8Oujd9Ubbu1hkad
X-Google-Smtp-Source: AA6agR5upkmc5Dx24BWnn3EskKFRinEPCDYjXf0T4LusHMjh/JWLPSCLJcFeHX7+waaB4dXKIYnMpw==
X-Received: by 2002:a05:620a:458b:b0:6b6:aa5:1d59 with SMTP id bp11-20020a05620a458b00b006b60aa51d59mr10670876qkb.525.1660552740759;
        Mon, 15 Aug 2022 01:39:00 -0700 (PDT)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id z3-20020a05622a124300b003437a694049sm6559964qtx.96.2022.08.15.01.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 01:38:59 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-31f443e276fso60835197b3.1;
        Mon, 15 Aug 2022 01:38:58 -0700 (PDT)
X-Received: by 2002:a81:502:0:b0:32f:dcc4:146e with SMTP id
 2-20020a810502000000b0032fdcc4146emr5686051ywf.316.1660552738763; Mon, 15 Aug
 2022 01:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-4-saravanak@google.com> <CAMuHMdWo_wRwV-i_iyTxVnEsf3Th9GBAG+wxUQMQGnw1t2ijTg@mail.gmail.com>
In-Reply-To: <CAMuHMdWo_wRwV-i_iyTxVnEsf3Th9GBAG+wxUQMQGnw1t2ijTg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 15 Aug 2022 10:38:47 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV0buz9JOHGs7_vMtV4GbLb+gmdpPihDu5B4ypqUDfAXQ@mail.gmail.com>
Message-ID: <CAMuHMdV0buz9JOHGs7_vMtV4GbLb+gmdpPihDu5B4ypqUDfAXQ@mail.gmail.com>
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

On Tue, Jul 5, 2022 at 11:11 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Wed, Jun 1, 2022 at 2:44 PM Saravana Kannan <saravanak@google.com> wrote:
> > Now that fw_devlink=on by default and fw_devlink supports interrupt
> > properties, the execution will never get to the point where
> > driver_deferred_probe_check_state() is called before the supplier has
> > probed successfully or before deferred probe timeout has expired.
> >
> > So, delete the call and replace it with -ENODEV.
> >
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
>
> Thanks for your patch, which is now commit f8217275b57aa48d ("net:
> mdio: Delete usage of driver_deferred_probe_check_state()") in
> driver-core/driver-core-next.
>
> Seems like I missed something when providing my T-b for this series,
> sorry for that.
>
> arch/arm/boot/dts/r8a7791-koelsch.dts has:
>
>     &ether {
>             pinctrl-0 = <&ether_pins>, <&phy1_pins>;
>             pinctrl-names = "default";
>
>             phy-handle = <&phy1>;
>             renesas,ether-link-active-low;
>             status = "okay";
>
>             phy1: ethernet-phy@1 {
>                     compatible = "ethernet-phy-id0022.1537",
>                                  "ethernet-phy-ieee802.3-c22";
>                     reg = <1>;
>                     interrupt-parent = <&irqc0>;
>                     interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
>                     micrel,led-mode = <1>;
>                     reset-gpios = <&gpio5 22 GPIO_ACTIVE_LOW>;
>             };
>     };
>
> Despite the interrupts property, &ether is now probed before irqc0
> (interrupt-controller@e61c0000 in arch/arm/boot/dts/r8a7791.dtsi),
> causing the PHY not finding its interrupt, and resorting to polling:
>
>     -Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: attached PHY
> driver (mii_bus:phy_addr=ee700000.ethernet-ffffffff:01, irq=185)
>     +Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: attached PHY
> driver (mii_bus:phy_addr=ee700000.ethernet-ffffffff:01, irq=POLL)
>
> Reverting this commit, and commit 9cbffc7a59561be9 ("driver core:
> Delete driver_deferred_probe_check_state()") fixes that.

FTR, this issue is now present in v6.0-rc1.
I haven't tried your newest series yet.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
