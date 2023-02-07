Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B42F68E055
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbjBGSn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjBGSnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:43:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06221E1D5;
        Tue,  7 Feb 2023 10:43:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 856E1B81AB2;
        Tue,  7 Feb 2023 18:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D06C433D2;
        Tue,  7 Feb 2023 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675795429;
        bh=z46LV0K67pYt+9sG+8XPfphcBy3wjoS4vl+j+OOVUvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=icQIS6QVs3SIYrh/ewyBWxOXyRdTzSi5iQLtHvNEjG7lvYhQ+DvHhk+3KEs5qU2sU
         TMTqOav5kG8GY5JR22dKb78qqMAt/Bg2JYkWEyM+MGuclGw0hQvMcVEtbzsmiJlItD
         IEGaquWuCLNILvUo5685guZahlOFm7IGWB2GaIQ6/vE/h0SUH8mRyEHQMupAISjrjW
         fnVVq+bZn0SaHzKt6ZHA6LtwE38N/APEa35C82I5WgacjEtf/+fE+N1kuSQDae5KOg
         NbPJHolFeXjK9+XKnt9280QC9hb68ZWPxwLnKvG03l5612lhbMN4Z8sBFUzc9BZ9vj
         q3xPIHrd6PLJg==
Date:   Tue, 7 Feb 2023 10:43:45 -0800
From:   Lee Jones <lee@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Devarsh Thakkar <devarsht@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
        Jonathan Corbet <corbet@lwn.net>, Alex Shi <alexs@kernel.org>,
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
Subject: Re: [PATCH v3 06/12] gpiolib: split linux/gpio/driver.h out of
 linux/gpio.h
Message-ID: <Y+Kb4Ql+I7/Abm48@google.com>
References: <20230207142952.51844-1-andriy.shevchenko@linux.intel.com>
 <20230207142952.51844-7-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230207142952.51844-7-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Feb 2023, Andy Shevchenko wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> Almost all gpio drivers include linux/gpio/driver.h, and other
> files should not rely on includes from this header.
> 
> Remove the indirect include from here and include the correct
> headers directly from where they are used.
> 
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  arch/arm/mach-omap1/irq.c                              | 1 +
>  arch/arm/mach-orion5x/board-rd88f5182.c                | 1 +
>  arch/arm/mach-s3c/s3c64xx.c                            | 1 +
>  arch/arm/mach-sa1100/assabet.c                         | 1 +
>  arch/arm/plat-orion/gpio.c                             | 1 +
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/led.c | 1 +
>  include/linux/gpio.h                                   | 2 --
>  include/linux/mfd/ucb1x00.h                            | 1 +

Acked-by: Lee Jones <lee@kernel.org>

>  8 files changed, 7 insertions(+), 2 deletions(-)

-- 
Lee Jones [李琼斯]
