Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D509A5665F4
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 11:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiGEJSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 05:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiGEJSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 05:18:38 -0400
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9928110C;
        Tue,  5 Jul 2022 02:18:37 -0700 (PDT)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-10bffc214ffso5617001fac.1;
        Tue, 05 Jul 2022 02:18:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8zMI7hf4Fvo1gks6+DJgLH8iax3WJOoRMgpJl0b4G5s=;
        b=GReoJw8YWx8gBUWb3QJsnMh9IQoyJBpx0+Qt6TwuJOdkt6BVxl2571g41BP+9ej5K8
         zR33myHI4bCD+wgQMIE+S1IN9UtGBJ1mFWEZ1Plej1qLHQvkhzyk1qE/5JYsroamqFgI
         tEayFU6yMd5ahuZGMF6JvriHyogOie+J/dkC0ZRB5t86izfGUuJRKhExXUepculBzMr4
         5rQ6t+XBhTVz0MMAV3F7+oUR5jI7WCDL7g4OykM7L3QWl6iMybzTw+aFMExYTXZa7m25
         I5nPsdOKoIv8rqpUelZjNXHqGZXNKw0lwnHlRBuEVy55qVJk16fpw2vbwLyORGHMm7KX
         KgzQ==
X-Gm-Message-State: AJIora+GcZGVkrQYQNEDAZrEb0E+AMIg5ODXYfw5ii9IojFeejG8Ym7y
        lhZVbdq+3AIhoHVKMLDmmoQthYZig93X9g==
X-Google-Smtp-Source: AGRyM1uGa/3l1fVNu6+dlHIjmG/OIbyvoDSYlukAwjYeIGkNc7XVajBKi2XvW2WcMmbLHjgjWZi0PQ==
X-Received: by 2002:a05:6870:5b91:b0:108:374a:96b0 with SMTP id em17-20020a0568705b9100b00108374a96b0mr19731432oab.126.1657012716872;
        Tue, 05 Jul 2022 02:18:36 -0700 (PDT)
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id y27-20020a544d9b000000b0032b99637366sm11862308oix.25.2022.07.05.02.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 02:18:36 -0700 (PDT)
Received: by mail-oo1-f48.google.com with SMTP id n11-20020a4ad12b000000b00425b01c3326so2271519oor.8;
        Tue, 05 Jul 2022 02:18:36 -0700 (PDT)
X-Received: by 2002:a81:9209:0:b0:31c:b1b7:b063 with SMTP id
 j9-20020a819209000000b0031cb1b7b063mr6920267ywg.383.1657012293585; Tue, 05
 Jul 2022 02:11:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com> <20220601070707.3946847-4-saravanak@google.com>
In-Reply-To: <20220601070707.3946847-4-saravanak@google.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Jul 2022 11:11:21 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWo_wRwV-i_iyTxVnEsf3Th9GBAG+wxUQMQGnw1t2ijTg@mail.gmail.com>
Message-ID: <CAMuHMdWo_wRwV-i_iyTxVnEsf3Th9GBAG+wxUQMQGnw1t2ijTg@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On Wed, Jun 1, 2022 at 2:44 PM Saravana Kannan <saravanak@google.com> wrote:
> Now that fw_devlink=on by default and fw_devlink supports interrupt
> properties, the execution will never get to the point where
> driver_deferred_probe_check_state() is called before the supplier has
> probed successfully or before deferred probe timeout has expired.
>
> So, delete the call and replace it with -ENODEV.
>
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Thanks for your patch, which is now commit f8217275b57aa48d ("net:
mdio: Delete usage of driver_deferred_probe_check_state()") in
driver-core/driver-core-next.

Seems like I missed something when providing my T-b for this series,
sorry for that.

arch/arm/boot/dts/r8a7791-koelsch.dts has:

    &ether {
            pinctrl-0 = <&ether_pins>, <&phy1_pins>;
            pinctrl-names = "default";

            phy-handle = <&phy1>;
            renesas,ether-link-active-low;
            status = "okay";

            phy1: ethernet-phy@1 {
                    compatible = "ethernet-phy-id0022.1537",
                                 "ethernet-phy-ieee802.3-c22";
                    reg = <1>;
                    interrupt-parent = <&irqc0>;
                    interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
                    micrel,led-mode = <1>;
                    reset-gpios = <&gpio5 22 GPIO_ACTIVE_LOW>;
            };
    };

Despite the interrupts property, &ether is now probed before irqc0
(interrupt-controller@e61c0000 in arch/arm/boot/dts/r8a7791.dtsi),
causing the PHY not finding its interrupt, and resorting to polling:

    -Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: attached PHY
driver (mii_bus:phy_addr=ee700000.ethernet-ffffffff:01, irq=185)
    +Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: attached PHY
driver (mii_bus:phy_addr=ee700000.ethernet-ffffffff:01, irq=POLL)

Reverting this commit, and commit 9cbffc7a59561be9 ("driver core:
Delete driver_deferred_probe_check_state()") fixes that.

> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -47,9 +47,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>          * just fall back to poll mode
>          */
>         if (rc == -EPROBE_DEFER)
> -               rc = driver_deferred_probe_check_state(&phy->mdio.dev);
> -       if (rc == -EPROBE_DEFER)
> -               return rc;
> +               rc = -ENODEV;
>
>         if (rc > 0) {
>                 phy->irq = rc;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
