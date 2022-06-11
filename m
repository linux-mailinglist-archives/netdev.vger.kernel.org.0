Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E1E5473CF
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 12:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiFKKiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 06:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiFKKiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 06:38:06 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A5367D13;
        Sat, 11 Jun 2022 03:38:05 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b8so1711779edj.11;
        Sat, 11 Jun 2022 03:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TL01zc1wHBLAGsEfDb4Hq71GrxMg8CwLyZooSJWIhuQ=;
        b=QtMJWb1UWXwOslP4l+K17Z3gPpguIKDzqP/AcqYwPBpC9m4HNdrAjx8i0yHIs3Jr81
         T+JWJK6hUr31ohqOEfqY2jE6+afIfHuPKmSFsVHEQwRoq2HS0BakWDReEK31a4xLWKvh
         HPtQxyskTRUBnBwAVtoWMBjdJ/+qSVbZEBUt7Xbbq6uFY4l0eKXbR2XeYQPB26nt7sTg
         gKdrjJQ/SB6iyg/q6jT0XNZ1e9+gnB6bgwYTPEI1UHJ7nX0MN0JQ3865pCeA02GV5cYX
         rjZa83ux9I4Jnsvh2vEcZwVkKMXC85eUejoUYIGlcftYfJSFZqYe6Misg/Hg1zXYK/uq
         eqfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TL01zc1wHBLAGsEfDb4Hq71GrxMg8CwLyZooSJWIhuQ=;
        b=Erpc6IYTjF1ZZsnAumCcffnwE3GO5r/qfHKu+0mzQRg6QR0c8vgVL1QbH/KNVSSL5h
         s8B4Jojgd3YvSdcRLtJWgwb5qzEYgYRjDbDnqtCis8jXff4XfJBEbwUSdvsFvDw5Iquv
         m00JEIS9zTC4VL70V1kg27wycj1Wu6s/sqIaQc/LSlp5fLWMNql0dTzMHg0bfniRbwZR
         A8LNt3Yb1ztlfEQfg0LhlCS65v1jp+9LI8k+jtZTKqn6ta75XILFbntdg+9PQs5rMRqc
         PnwvWhvQovn0j9HvINj/r64D3C0c5sdR6Vk/DUTMzW9D6XVB4i7JDa/CcUUwBa58FH+X
         p95g==
X-Gm-Message-State: AOAM530VzFzugfYXmHJP6lPoN47pnUF6/Ja8xjQTcPlgAcXS3nwNfMsu
        HrUloqJRgLHZ/Ua0DDSphbQZZ1pHZe9/Pa1ES+U=
X-Google-Smtp-Source: ABdhPJxOKZWJKsTpPKPkSmo+fc5cRoKy2TeJYcjjoqHFnLmWCxs8wNug/URbpvWmB5zAg4RAjyWV7Q2UqWlqDbnMnIQ=
X-Received: by 2002:aa7:d481:0:b0:42d:d5fd:f963 with SMTP id
 b1-20020aa7d481000000b0042dd5fdf963mr55696954edr.209.1654943883982; Sat, 11
 Jun 2022 03:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220610202330.799510-1-colin.foster@in-advantage.com> <20220610202330.799510-2-colin.foster@in-advantage.com>
In-Reply-To: <20220610202330.799510-2-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 11 Jun 2022 12:37:26 +0200
Message-ID: <CAHp75Vc+V3APvBO8rJ0awu65iPbEoYKn5bn4GhC0DEvC4DiKiw@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 1/7] mfd: ocelot: add helper to get regmap
 from a resource
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>
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

On Fri, Jun 10, 2022 at 10:23 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> Several ocelot-related modules are designed for MMIO / regmaps. As such,
> they often use a combination of devm_platform_get_and_ioremap_resource and
> devm_regmap_init_mmio.
>
> Operating in an MFD might be different, in that it could be memory mapped,
> or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
> instead of IORESOURCE_MEM becomes necessary.
>
> When this happens, there's redundant logic that needs to be implemented in
> every driver. In order to avoid this redundancy, utilize a single function
> that, if the MFD scenario is enabled, will perform this fallback logic.

v10 has the same issues I have pointed out in v9.

Please, take your time and instead of bombing mailing lists with new
versions try to look how other (most recent) drivers have been done.

Also pay attention to the API design.

-- 
With Best Regards,
Andy Shevchenko
