Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064304A9592
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 09:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357197AbiBDIwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 03:52:15 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:38058
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357198AbiBDIwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 03:52:14 -0500
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1D7DD3F043
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 08:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643964733;
        bh=iqZrLHxxMKYXcwDk+JH/xBRKoG0uPSeGw2pYz3/v6kY=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=eBIHCkKi09tjJqdWDZBoh6iZZuDeagxiGhsi8PTmN4ZBY1JFJ1plEen9alndKBpaa
         rZa25r7WemVcr/Bx6NCtnLoPmcYSswxky+lK1Vprp5zULdncJTDlsj1jhr9unEL+37
         CgMZr3cuaInfjFgXPkhtTMkhf90SGkA4DcHjETpJOlai5o6oC6dhVu5GCEn7VKpEjI
         em2yORSiXEHkXjyJWrN9LxinOyu8AyEXoRk1zfMSqqqEq9EL0xS4kzuezxyQSLbgmG
         RXKUWjiTX6UVV2h+jy9Q48+0w78TVhk0SnYeH1JBQPaASjUrgyx5Z+aTKPi3YAcZ2c
         67T+4OKW7Zwzw==
Received: by mail-ej1-f70.google.com with SMTP id q21-20020a17090622d500b006bb15a59a68so2245269eja.18
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 00:52:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iqZrLHxxMKYXcwDk+JH/xBRKoG0uPSeGw2pYz3/v6kY=;
        b=Du5X+XGQnSYmEjBhVkc7gnhFt0lI1fWpx0mEkafVFTy41SwBcwLk3qBvbjNZJU4khj
         iie5I7G38J7iNTa6AtR7tkeqHvS57v4NzOOo6J5jX2Yx/yDqnxexUjHzjyfL6SNkAb2T
         9F9C0lQz1PP0YiMOaUl+1u77/LLi9CH4YzYC0vXW7z9VRz0PoF3H0ges0HX1WVzBwfRe
         YuwBdY0PQGmaLCPtGSZqHJ+/SeaM+ygFD5lZByqr04okDO/Ydfz3G4G6USZ81758N5C6
         pm2Jiy8yGAJxYsc2KNzM9uyAIJK4UpirsmUFLQw7/NyFDnKhuFX1ymnOpAxXX4tLbDwG
         ixyA==
X-Gm-Message-State: AOAM532ebv7H6lgBvIN3/+4rcHFdemSg2DhiPK+zBW1OFhJZ8ZNlaiEy
        0nXUaIPCixockCE2NXh7fjjAibfhz5W5NGTO5MAMuU6GJbx8E7PTsj8yIlCvW4Hhp19TLe9mT+9
        EZQCvLlK/+zypbTbouIOyKwPSP757y7jQ+Q==
X-Received: by 2002:a05:6402:3492:: with SMTP id v18mr1976632edc.345.1643964732807;
        Fri, 04 Feb 2022 00:52:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwVcZDvspQCzKUyW5YG8zjDVQmYqY/DEAG3sfjKSfnQIzLHqmc3NlVf9LlkkFskfuUgLPJavA==
X-Received: by 2002:a05:6402:3492:: with SMTP id v18mr1976597edc.345.1643964732578;
        Fri, 04 Feb 2022 00:52:12 -0800 (PST)
Received: from [192.168.0.81] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id z8sm418238ejc.197.2022.02.04.00.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 00:52:11 -0800 (PST)
Message-ID: <ed615fdb-5c30-697e-f197-a3a93c5336b9@canonical.com>
Date:   Fri, 4 Feb 2022 09:52:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] HPE BMC GXP SUPPORT
Content-Language: en-US
To:     "Verdun, Jean-Marie" <verdun@hpe.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Hawkins, Nick" <nick.hawkins@hpe.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Corey Minyard <minyard@acm.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        SoC Team <soc@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Stanislav Jakubek <stano.jakubek@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Hao Fang <fanghao11@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Wang Kefeng <wangkefeng.wang@huawei.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
        <openipmi-developer@lists.sourceforge.net>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        LINUX-WATCHDOG <linux-watchdog@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <nick.hawkins@hpe.com>
 <20220202165315.18282-1-nick.hawkins@hpe.com>
 <CAL_Jsq+K2t5WYE056so1iZgZr7CBKvDEjAwnJVTyUFQcK-VFSA@mail.gmail.com>
 <e79133f2-f872-3ed6-4038-526e94e84909@canonical.com>
 <1FEAAC19-1DD7-40D7-98FD-30C2659E7C0F@hpe.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <1FEAAC19-1DD7-40D7-98FD-30C2659E7C0F@hpe.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/02/2022 18:07, Verdun, Jean-Marie wrote:
> 
>    > Maybe it does not look like, but this is actually a v2. Nick was asked
>    > to change the naming for the nodes already in v1. Unfortunately it did
>    > not happen, so we have vuart, spifi, vic and more.
> 
>    > It is a waste of reviewers' time to ask them to perform the same review
>    > twice or to ignore their comments.
> 
>     Hi Krysztof,
> 
>     Accept our apologies if you think you lose your time, it is clearly not our
>     intent. 
> 
>     This is the first time that we (I mean the team) introduce a new arch into
>     the linux kernel and I must admit that we had hard time to understand
>     from which angle we needed to start.
> 
>     I will probably write a Documentation afterward, as it is easy to find doc
>     on how to introduce a patch or a driver, but not when you want to 
>     introduce a new chip. 
> 
>     We are trying to do our best, and clearly want to follow all of your inputs.
>     Mistakes happen and they are clearly not intentional and not driven in 
>     a way to make you lose your time.
> 
>     Helping others, and teaching something new is definitely a way to 
>     optimize your time and this is what you are currently doing with us.
> 
>     We appreciate it and hope you will too.

I understand, I also maybe over-reacted on this. Just please go through
the comments you got for first submission and either apply them or
respond why you disagree.

The next submissions (patchset split into several commits) should be a
v3, preferably with cover letter (git format-patch --cover-letter -v3
...) where you can document also changes you did to the patchset.

It looks for example like this:
https://lore.kernel.org/linux-samsung-soc/31da451b-a36c-74fb-5667-d4193284c6cd@canonical.com/T/#mf98d2ac27a8481dc69dd110f9861c8318cade252

or like this (where changelogs are in each patch, although ordering is
not correct because dt-bindings should be the first in the series):
https://lore.kernel.org/all/20220103233948.198119-1-Mr.Bossman075@gmail.com/


Best regards,
Krzysztof
