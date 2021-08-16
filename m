Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D233ED3AC
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbhHPMHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbhHPMHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 08:07:35 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A96C061764;
        Mon, 16 Aug 2021 05:07:03 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j1so26118704pjv.3;
        Mon, 16 Aug 2021 05:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3XH+hAXLsnjPgNeGfopQI25eSsQDjMM+EKsYX2dX9go=;
        b=Xbg2TtaidYz/v3B7/WuPbVCXcBGYOPetmljCxQ6T3qOpIYqKnxuviytIL/8SNUIwPV
         Ztnv3jeb9Eb82oOjgMBCpfZkHq7cwVCSniPTgXcYhRdROVK3jlj6mvUMq91FA1fbqrjp
         EdeLANA6UNUjCuMc9rrxflSB/sVi8ViCN9WsaiDWY4xFVtBz900L+v/XHoSzKZ69BoCi
         UXJ3A89PtMuX/5eD/69/JyqRqxvEkTPsLFxL5PtA1GyMDL592R9i03M21zj2p2odFt8T
         lk2mVWSl1D5e4YtiO94U8SsxBYu5vz/ZklRLZuvmmIQYjbvLPeQk/WzIbjFaNoAto2IQ
         yL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3XH+hAXLsnjPgNeGfopQI25eSsQDjMM+EKsYX2dX9go=;
        b=boZi0Lrxh2N5RyPCkMUMCKyZs+5kFpNJqZQ418voLkIMQrn2Nf7euX6P0xNYeZQHNw
         aTdH+5BJHFohIQvI+8X2qGOye8IjV4nz4lgzPeaX/OZN00AXs9JeDaSCvMhwWLdBn7Bw
         q5OC4gM5MCT/GHjHirECl6eeoVU+XJHdc07deYEsJwhccx9siIQTMJs1m7MsqbPeQsrn
         rwezO/nhlx2Go4D1059L9YErc3ldPgDTAOmA7tWr0rKYWl2W4HWVFYLdOMpFzmPIBA1H
         04fLiLjps2+0gBsYUr8gZABvchcFMjFTmUq/aDIsTDLEPGtNXtPDM7nNzrI0dY2FeN3N
         AFjg==
X-Gm-Message-State: AOAM533BmH0qcoMT1UEXrKjqCwYRs1m+/B5/lcYB8slfEppd3PnOYc3f
        buFqaB7GtUB71KWzywRIYVM0LNsqTVNXiFQucAI=
X-Google-Smtp-Source: ABdhPJzD/BdoSe8IpCKOam9wtqMZiVHkA44BuzI8Pf5H8Pkqo+pQ0YlITieVj1DRtlkeo1hUSAe7j2xJlzFgL3u1ztU=
X-Received: by 2002:a05:6a00:d41:b0:3e1:3316:2ef with SMTP id
 n1-20020a056a000d4100b003e1331602efmr12432821pfv.40.1629115622813; Mon, 16
 Aug 2021 05:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 16 Aug 2021 15:06:23 +0300
Message-ID: <CAHp75Vc2Hpdk715R3=JPp==tUX394ZWLp96BJHHkarj9TpJ0FQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/6] gpio: mlxbf2: Introduce proper interrupt handling
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     David Thompson <davthompson@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Liming Sun <limings@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 3:01 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> This is just a WIP / TODO series based on the discussion [1].
> I hope nVidia will finish it and fix the initial problem sooner than later.
>
> Bart, Linus, First 4 patches may be directly applied to the tree (they are
> at least compile-tested, but I believe they won't change any functionality.
>
> Patch 5 is some stubs that should have been done in the driver.
> Patch 6 is follow up removal of custom GPIO IRQ handling from
> Mellanox GBE driver. Both of them are quite far from finishing,
> but it's a start for nVidia to develop and test proper solution.
>
> In any case, I will probably sent end this week the ACPI IRQ abuse
> part from the GBE driver (I won't touch OF path).
>
> ARs for nVidia:
> 0) review this series;
> 1) properly develop GPIO driver;
> 2) replace custom code with correct one;
> 3) send the work for review to GPIO and ACPI maintainers (basically list
>    of this series).
>
> On my side I will help you if you have any questions regarding to GPIO
> and ACPI.

Missed link

[1]: https://x-lore.kernel.org/linux-acpi/YRUskkALrPLa2cSf@smile.fi.intel.com/T/#u

> Andy Shevchenko (6):
>   gpio: mlxbf2: Convert to device PM ops
>   gpio: mlxbf2: Drop wrong use of ACPI_PTR()
>   gpio: mlxbf2: Use devm_platform_ioremap_resource()
>   gpio: mlxbf2: Use DEFINE_RES_MEM_NAMED() helper macro
>   TODO: gpio: mlxbf2: Introduce IRQ support
>   TODO: net: mellanox: mlxbf_gige: Replace non-standard interrupt
>     handling
>
>  drivers/gpio/gpio-mlxbf2.c                    | 151 ++++++++++---
>  .../mellanox/mlxbf_gige/mlxbf_gige_gpio.c     | 212 ------------------
>  2 files changed, 120 insertions(+), 243 deletions(-)
>  delete mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_gpio.c
>
> --
> 2.30.2
>


-- 
With Best Regards,
Andy Shevchenko
