Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFE9697FE4
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 16:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBOPwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 10:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjBOPwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 10:52:44 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4E7367F2
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 07:52:41 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id 30so2743882uab.8
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 07:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QHEckESBmtanHoXNoCvk3gYsaCb3mmNnsjrBL0CHXHo=;
        b=uFE2tcYXYvgsB0sRGahu4i6/jR0i1fWRumRbB6+LOj6E4ZTQeoJQKY+uir8dwyQAPf
         0tFSiyKW/Fnvdx7G9YqrFDzJ5rpovQR98oqoI9mDNOHpQoG6qkudJ1v0/vpv9DTZyvHu
         2FZ5pBhMrW+AwLQ0UHgvstufkVnkWswfeG6NT/qsFhsMW+RqE4zXszDTo9BrlFUTp25+
         B7HTBOKfeZtBkRm441r7YFaJc0rXVKo3xjPJcpiXV6JNc9DsILiJLKJHBFrcxHls+m2Y
         ZP+U/dMUytGegPXffNuxumCFe0jCae7w9HsecNZLfJZoIChNvNanAquRYPfNiHANjZr/
         6auA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QHEckESBmtanHoXNoCvk3gYsaCb3mmNnsjrBL0CHXHo=;
        b=D+YrjvnbRgGr3K+vn7zdE1IRa3o659MzRJNg8iCp2qLHAfjEvpG8dtcrZ6vQ+icReM
         taq9icHihxyM1irAwuSXYveJKGTG+VcFEeiV7rVzfXCrBmRQEFFiiSfzYDGmZ+x42qSc
         zfvo28hEFwaHXnhT2W1ItYamij6xiqhilSCbH7YvKT4XyyduuljjRG1Lm3D/sYu7zja+
         8ggDdRkU34IUkotV8jro/PZAuoL/wy4wHdsMnToguJkcl/8a0VOX/NNQQJpakv+dw7fM
         QW0gBWYehX5wjspO+nL6pRhEesStPbBda2sxZ01hWRwuBDU3jrMe0Ypjlga8Pc4HehoY
         j/sA==
X-Gm-Message-State: AO0yUKUNDG/DE/vcEJWBhoJQ9XEBj/OSpp6/YgRWPIYZFDKTdKLkKBpz
        CSlVqfaKLUpaKhYXscuc+kZqAw011X9z4kXezY3Rog==
X-Google-Smtp-Source: AK7set+vnGRn5VJvyu0QxjkbABjPQvrEocRoV7wexNKYGw75YkBBJD0qPPmjAkmta0f6ajtUkrNDoiyJSIKAB5KOn4A=
X-Received: by 2002:ab0:654d:0:b0:68a:7054:58a6 with SMTP id
 x13-20020ab0654d000000b0068a705458a6mr367631uap.22.1676476360679; Wed, 15 Feb
 2023 07:52:40 -0800 (PST)
MIME-Version: 1.0
References: <20230208173343.37582-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230208173343.37582-1-andriy.shevchenko@linux.intel.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Wed, 15 Feb 2023 16:52:29 +0100
Message-ID: <CAMRc=MdsCZKh12QcqdWk+Zht5UDpA_G1+rx6+_3dzwjDYe6L+Q@mail.gmail.com>
Subject: Re: [PATCH v4 00/18] gpiolib cleanups
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Devarsh Thakkar <devarsht@ti.com>,
        Michael Walle <michael@walle.cc>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dipen Patel <dipenp@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Lee Jones <lee@kernel.org>, linux-gpio@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Keerthy <j-keerthy@ti.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, Qiang Zhao <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 8, 2023 at 6:34 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> These are some older patches Arnd did last year, rebased to
> linux-next-20230208. On top there are Andy's patches regarding
> similar topic. The series starts with Linus Walleij's patches.
>
> The main goal is to remove some of the legacy bits of the gpiolib
> interfaces, where the corner cases are easily avoided or replaced
> with gpio descriptor based interfaces.
>
> The idea is to get an immutable branch and route the whole series
> via GPIO tree.
>

Andy,

looks like this series has all the acks it needs but I decided to not
send it in the upcoming merge window, I'd prefer it gets some time in
next so I'll let it sit until the next release cycle.

Bart
