Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9225547B4
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348154AbiFVKwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 06:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348285AbiFVKwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 06:52:41 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E93A3BBC6;
        Wed, 22 Jun 2022 03:52:40 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id g25so33299003ejh.9;
        Wed, 22 Jun 2022 03:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oaXOVl5GbpzrwUwV/ImpOqO7sc14IuZ0zxyCyofIONY=;
        b=fAYTDojmK1smvHwGNsWw7YZE+c033Tr1yoX1+0von2aMoUv1c6u/lXSW342IrQcP4M
         xPN+GRDfDYCxmUIv6sDSqnaI8Em+Oh+JKrva7+3g/EzeKV1Ki583f+s9svwO4PTOK3VO
         FNBVAE15VZ93Za7cLKMBU9l53ej2lPfk32eNT2dPoL31kpXd5JF9QExrHJGiNWskQaoi
         GwbpG7yGkbThNaRXEKOmk3fTJtRnVtpyyhPasWlhFmRt+RC4liDaJM5tK4YKEVkPB0lZ
         cAhCT1RJZQYl9ir4lgrKLNKqAQifLqf1rW/MelSqXTepRExaSRDBPQAnc0kZG468DnbP
         an5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oaXOVl5GbpzrwUwV/ImpOqO7sc14IuZ0zxyCyofIONY=;
        b=GcNvLXcE9tW7G6nUDJS/2kjcjmbbny+Zq3c7NsD2s4nBR3mw/JNhKvQ/t27uZ2MQBl
         eD9wrKSLPmwfxY+00QAMbRQgiTJ/DnKJunbAVf4yFM0WGA9DuatGJeJpEGYh0PxuBfsB
         NQ3e3XSKbX/pdszk1TjsbZJvTSG49sM4572CiOw44sb7bNDT6OatrQYXw5krTGFVVkYo
         Tf2UfnAdLTvITHl4irZXu6G+LA9vBlsFZYUqqPryGV4hbvFJvUIFbd5/UH+d6wgVaPwl
         z6jSc5aPasya2aBs0MlaKtUiG95ZSO0a+PTHAk7mYRlH2TSz++XLhZQBeRX+A4yUa7NS
         BNkw==
X-Gm-Message-State: AJIora/7Nr30JaVIyIEoYOjCS2mn6KHl5Fzl8ZBlgMjg7pI6dlShVq/V
        YbpkyfV0EhK+lSITdzVeLAR+b2B+e8/pQ1aaERA=
X-Google-Smtp-Source: AGRyM1uyQ/Y01CLF3k0VqbSatCLy5utHlTkfRj9OEacTCqDgiOfz+58yhgtrbg6k3a0mp5dlHgOdAW0EC2clcTJB1Rg=
X-Received: by 2002:a17:906:149:b0:711:fca6:bc2f with SMTP id
 9-20020a170906014900b00711fca6bc2fmr2554745ejh.497.1655895158817; Wed, 22 Jun
 2022 03:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-8-saravanak@google.com> <20220622074756.GA1647@pengutronix.de>
 <CACRpkdYe=u9Ozj_dtLVr6GSau8yS5H7LnBNNrQHki1CJ1zST0A@mail.gmail.com>
In-Reply-To: <CACRpkdYe=u9Ozj_dtLVr6GSau8yS5H7LnBNNrQHki1CJ1zST0A@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 22 Jun 2022 12:52:02 +0200
Message-ID: <CAHp75VdqjCoWAHV4AyYrju0o8buREA8pM5wyf8TD=rCMTs-tEA@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] driver core: Set fw_devlink.strict=1 by default
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Sascha Hauer <sha@pengutronix.de>,
        Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 10:44 AM Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Jun 22, 2022 at 9:48 AM Sascha Hauer <sha@pengutronix.de> wrote:

...

> > This patch has the effect that console UART devices which have "dmas"
> > properties specified in the device tree get deferred for 10 to 20
> > seconds. This happens on i.MX and likely on other SoCs as well. On i.MX
> > the dma channel is only requested at UART startup time and not at probe
> > time. dma is not used for the console. Nevertheless with this driver probe
> > defers until the dma engine driver is available.
> >
> > It shouldn't go in as-is.
>
> This affects all machines with the PL011 UART and DMAs specified as
> well.
>
> It would be best if the console subsystem could be treated special and
> not require DMA devlink to be satisfied before probing.

In 8250 we force disable DMA and PM on kernel consoles, because it's
so-o PITA and has a lot of corner cases we may never chase down.

089b6d365491 serial: 8250_port: Disable DMA operations for kernel console
bedb404e91bb serial: 8250_port: Don't use power management for kernel console


> It seems devlink is not quite aware of the concept of resources that are
> necessary to probe vs resources that are nice to have and might be
> added after probe. We need a strong devlink for the first category
> and maybe a weak devlink for the latter category.
>
> I don't know if this is a generic hardware property for all operating
> systems so it could be a DT property such as dma-weak-dependency?
> Or maybe compromize and add a linux,dma-weak-dependency;
> property?


-- 
With Best Regards,
Andy Shevchenko
