Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE44A6B3AD5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCJJkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCJJjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:39:36 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F92615551
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:37:38 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id t4so4644227ybg.11
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678441057;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dkaa33xZucHUmrkT5EKmd+RR2GnIarbPW3jBS/IXiH4=;
        b=ILgy/F6/c0pxMeQ/+6TFJeeOwNTnmur/K+JvQ701v0qAA0vS7Fs3hSM2WV0r7T71AR
         7iyHIC6BKS6Txkgct7txGB9X1f9a5XW4YC4NUMtvVFayyucjCMRJWfK7Ml/3TEFIjoFV
         V041ltbDeIdKFbE82x/frnGpKAk2ItooSDnmIwrBF0QnLTPC89Yo9wveO6wvD3WF0KtY
         8WaWDVmLxFEWWA4uCYz5a/N6jiSA17yEwUyo9tEcTCEAWwyVVBd3K1utC5G7tXhiTF0j
         71o7KVhFV0JvVVATu5MVkEh9usoL3P5lcfP10ng4cRA1ZwckPPEYmC1gjgqURqCJ/G+a
         JyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678441057;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dkaa33xZucHUmrkT5EKmd+RR2GnIarbPW3jBS/IXiH4=;
        b=TWWmXNpy4+uMQVQ5M6K3AiOq/wJ5DbAOPSCUKWYegmunGmQFNZXrfMPJUWwDsVG/Y3
         NwrmlMO00s74kulABtlAPjXMh6nLDRxne1oXIMeRGeigdsRPfg3XzGcD/RnW8jBHVWgs
         lBm2VPWgxr1x2CujjGnwnZYGEW7KT3gM6weeYd7vhy891UtnnQlYtkZEOjCKVhOsN3EI
         Ow9un0V02ZZsZro5MZM/cSH/Ym+k5QINMS/37SZPNzK4123vhV/oAAwK3ljFBtlhogzR
         arr+EO7SiwjtKpZpt7eYogO4xutUxJujCRT/veZe8NkH0bsciFqxb8bimKvdgPjmvXDC
         ZX2g==
X-Gm-Message-State: AO0yUKWaqnOHkWSAoYKgtMoAr5GAmNcxZ5WezeHmiRyLgxmrVEUfnsQN
        I9ile2UnNfJr6xRjsUs14fP14acXQ1s5YhVecaiwHg==
X-Google-Smtp-Source: AK7set+5e6x1wi7MIweB5TOI7S3BjN5EW/S43FwJZUJkRYmGqWqeeshxKBdvJTlMBkQWSrF6TT50wquIIlxgcDtOgIE=
X-Received: by 2002:a25:e201:0:b0:b2e:f387:b428 with SMTP id
 h1-20020a25e201000000b00b2ef387b428mr1178326ybe.5.1678441057179; Fri, 10 Mar
 2023 01:37:37 -0800 (PST)
MIME-Version: 1.0
References: <20230216013230.22978-1-ansuelsmth@gmail.com> <CACRpkda30Ky5oYPn_nGWGOzT5ntZYdE3gafrs7D27ZHxgGuO8A@mail.gmail.com>
 <8226f000-dd9c-4774-b972-a7f1113f0986@lunn.ch>
In-Reply-To: <8226f000-dd9c-4774-b972-a7f1113f0986@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 10 Mar 2023 10:37:25 +0100
Message-ID: <CACRpkdapuk39vcdNhmsMN0tbTPTSYUgY9r+EBJ-O+v2dsB=wNA@mail.gmail.com>
Subject: Re: [PATCH v8 00/13] Adds support for PHY LEDs with offload triggers
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 9, 2023 at 4:22 PM Andrew Lunn <andrew@lunn.ch> wrote:

> As to 'how a certain trigger on a certain LED is going to associate
> itself with, say, a certain port' is clearly a property of the
> hardware, when offloading is supported. I've not seen a switch you can
> arbitrarily assign LEDs to ports. The Marvell switches have the LED
> registers within the port registers, for example, two LEDs per port.

Aha so there is an implicit HW dependency between the port and the
LED, that we just cannot see in the device tree. Okay, it makes sense.

I think there will be a day when a switch without LED controller appears,
but the system has a few LEDs for the ports connected to an
arbitrary GPIO controller, and then we will need this. But we have
not seen that yet :)

Yours,
Linus Walleij
