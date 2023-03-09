Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515D56B1F79
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 10:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjCIJJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 04:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjCIJJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 04:09:33 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C9B30B2E
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 01:09:30 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id v101so1200575ybi.2
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 01:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678352969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=As7r+GPHEmvAUFDtsvfEp735NwW2WEg6DbTgAlj58R0=;
        b=d5zPXnIdCSL8PFYhyYOeGqp/z4KLzRwZUDS5MQscn602dDdMFOICNvctZM6XgOSs/s
         Md7TYhkP3I4c8GUXNxi6ka8Hry0M3d8uw/UHhPRafzoTu+2lLo2QrAr4pyjwRTYQ4+CI
         07WNh/oBiql5KgaJDO8K1gDaGWu+DAsLRq2nU9Y9wj39MtMFMILC9ahu+4xt7cmhGPYd
         X90VtbPi3OMstH+/UqpSOwHHI+EYQ7LarXzbLBCDuMKzdMMFQ/UxUKKqVA7sa5cL0Uez
         IZChwC6FoLVRu2JgNXLPAG+SxViuz8t/Op2vZmpSB0iiljJXiJOhtcT6NmEsfqrkeFEw
         o0Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678352969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=As7r+GPHEmvAUFDtsvfEp735NwW2WEg6DbTgAlj58R0=;
        b=PJJTdMKRslR2N2rzuy9c/8+98GqnwoEVGkPEEZvvc6DTMCtViCo59yt1dy5pf+bi7E
         DjWXuJSCvw2IKWRJpy1a5V8p4eY3/Y7k0JJeJ34ZX0toHDoaxGpwTbHdhthkUHc0lSQ7
         WFD3gQ04OdUo4Rh9rEmYgRrUs/rwpSzNcrMl+ln8k6GZQ7ZEJ2bD4w+o9K3oN/0gemCl
         L4DItrCizpE4/5loot2Eq7l1E6z82W7DSeUVUqTXYEbBXkiyr5ZkbL2YrigiQ6GDcKq8
         gY7Xwe/gSruTQn873ACsIA+Khdi8NpaTEBv6bKilI1K/5FZjA3YvWI83xhGVSO0Pk+yY
         WEGQ==
X-Gm-Message-State: AO0yUKXGjiRYwo7sDMkPHPSV4R4ktNBkX+E3NxuV7gTLT0CZFPaiBDWf
        b9U4lVKcF/x96TpOmelhmd5uRYCIp6K+VVU+TlXTkw==
X-Google-Smtp-Source: AK7set9SxHJdstKtORUta6fNpFj7c3NC6Y9ep4Dfm8p9BxYEaHWCbrFjAqLaiUObiP3YlHYpudlhcELLtQQQOTOX9Yw=
X-Received: by 2002:a25:8c84:0:b0:b23:4649:7ef3 with SMTP id
 m4-20020a258c84000000b00b2346497ef3mr240804ybl.4.1678352969333; Thu, 09 Mar
 2023 01:09:29 -0800 (PST)
MIME-Version: 1.0
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
In-Reply-To: <20230216013230.22978-1-ansuelsmth@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 9 Mar 2023 10:09:18 +0100
Message-ID: <CACRpkda30Ky5oYPn_nGWGOzT5ntZYdE3gafrs7D27ZHxgGuO8A@mail.gmail.com>
Subject: Re: [PATCH v8 00/13] Adds support for PHY LEDs with offload triggers
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

thanks for your patch!

On Thu, Feb 16, 2023 at 2:36=E2=80=AFAM Christian Marangi <ansuelsmth@gmail=
.com> wrote:

> The current idea is:
> - LED driver implement 3 API (hw_control_status/start/stop).
>   They are used to put the LED in hardware mode and to configure the
>   various trigger.
> - We have hardware triggers that are used to expose to userspace the
>   supported hardware mode and set the hardware mode on trigger
>   activation.
> - We can also have triggers that both support hardware and software mode.
> - The LED driver will declare each supported hardware blink mode and
>   communicate with the trigger all the supported blink modes that will
>   be available by sysfs.
> - A trigger will use blink_set to configure the blink mode to active
>   in hardware mode.
> - On hardware trigger activation, only the hardware mode is enabled but
>   the blink modes are not configured. The LED driver should reset any
>   link mode active by default.

The series looks good as a start.
There are some drivers and HW definitions etc for switch-controlled
LEDs, which is great.

I am a bit reluctant on the ambition to rely on configuration from sysfs
for the triggers, and I am also puzzled to how a certain trigger on a
certain LED is going to associate itself with, say, a certain port.

I want to draw your attention to this recently merged patch series
from Hans de Goede:
https://lore.kernel.org/linux-leds/20230120114524.408368-1-hdegoede@redhat.=
com/

This adds the devm_led_get() API which works similar to getting
regulators, clocks, GPIOs or any other resources.

It is not yet (I think) hooked into the device tree framework, but it
supports software nodes so adding DT handling should be sort of
trivial.

I think the ambition should be something like this (conjured example)
for a DSA switch:

    platform {
            switch {
                    compatible =3D "foo";

                    leds {
                            #address-cells =3D <1>;
                            #size-cells =3D <0>;
                            led0: led@0 {
                                    reg =3D <0>;
                                    color =3D...
                                    function =3D ...
                                    function-enumerator =3D ...
                                    default-state =3D ...
                            };
                            led1: led@1 {
                                    reg =3D <1>;
                                    color =3D...
                                    function =3D ...
                                    function-enumerator =3D ...
                                    default-state =3D ...
                            };
                    };

                    ports {
                            #address-cells =3D <1>;
                            #size-cells =3D <0>;
                            port@0 {
                                    reg =3D <0>;
                                    label =3D "lan0";
                                    phy-handle =3D <&phy0>;
                                    leds =3D <&led0>;
                            };
                            port@1 {
                                    reg =3D <1>;
                                    label =3D "lan1";
                                    phy-handle =3D <&phy1>;
                                    leds =3D <&led0>;
                            };
                    };

                    mdio {
                            compatible =3D "foo-mdio";
                            #address-cells =3D <1>;
                            #size-cells =3D <0>;

                            phy0: ethernet-phy@0 {
                                    reg =3D <0>;
                            };
                            phy1: ethernet-phy@1 {
                                    reg =3D <1>;
                            };
                    };
            };
    };

I am not the man to tell whether the leds =3D <&led0>; phandle should be on
the port or actually on the phy, it may even vary. You guys know the answer
to this.

But certainly something like this resource phandle will be necessary to
assign the right LED to the right port or phy, I hope you were not going
to rely on strings and naming conventions?

Yours,
Linus Walleij
