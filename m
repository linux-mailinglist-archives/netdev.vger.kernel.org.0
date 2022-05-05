Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65EFA51C013
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378466AbiEENEg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 May 2022 09:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378489AbiEENEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:04:34 -0400
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAC452E7B;
        Thu,  5 May 2022 06:00:48 -0700 (PDT)
Received: by mail-qk1-f176.google.com with SMTP id b20so3062848qkc.6;
        Thu, 05 May 2022 06:00:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZlNgXSwILcEbA0TzwSgffqQ9c6KRlsAYre6fYSWbxKU=;
        b=kzhcQUprjhgZd37XulTGo1bzlJoi71HVa7DhdwEeBd/HvsbR2Qw2WoFytSgEs+FHSB
         QX+3BY36LH2ZvsKbX2yBVj4FAnGjh6cIa4xTB6PpCiFBsi/UzmJWr6NsnM5fm3xz7X/+
         awt5ex7cCaaJWcNFO3TpZzW3jF0ctzNdZVFT8oEvpMp5NirPe+o82yjIm3e51DnVm7+M
         H7ofnTazq/TIN07QKS5FwDVmTDXTy5ZlgF9VKfV/898NC2pfxRP9G89YiBXxYcgyKeLK
         25FMzf477VtO3zyMdxzTmGs5ByDSL/P09hrz0kbI1f3JK5qP5uu8+IeKgLdUwGvlpx1D
         2tzA==
X-Gm-Message-State: AOAM532brV1ecb5DVXZekzX8940vZALJtGArnriQjUKwJ82As4FUw8/F
        fM5AFL4m+68t6Lizz5+xILLG9OwUsuM87Q==
X-Google-Smtp-Source: ABdhPJzL2MGiGi+EeRP7s8f+pCkwWx+GoWkAYbWOGaYLI1GRugaWllrtFX758bU6zHFL4w6M4g7yYQ==
X-Received: by 2002:a37:9243:0:b0:69b:6009:856d with SMTP id u64-20020a379243000000b0069b6009856dmr19033735qkd.274.1651755641548;
        Thu, 05 May 2022 06:00:41 -0700 (PDT)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id o28-20020a05620a0d5c00b0069fc167df92sm733004qkl.82.2022.05.05.06.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 06:00:40 -0700 (PDT)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2ef5380669cso47198277b3.9;
        Thu, 05 May 2022 06:00:40 -0700 (PDT)
X-Received: by 2002:a0d:d953:0:b0:2f7:d5ce:f204 with SMTP id
 b80-20020a0dd953000000b002f7d5cef204mr23313149ywe.502.1651755639797; Thu, 05
 May 2022 06:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220504093000.132579-1-clement.leger@bootlin.com>
 <20220504093000.132579-5-clement.leger@bootlin.com> <CAMuHMdU1dF25eKeihBO3xRarW-acG0vUSggWfKOwG3v=7eN+bg@mail.gmail.com>
 <20220505143236.31fc6b58@fixe.home>
In-Reply-To: <20220505143236.31fc6b58@fixe.home>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 5 May 2022 15:00:28 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU1DZeigT1ES4FMrtLpnRA0fMp6k4ZhDs7U0=CvAuOxgA@mail.gmail.com>
Message-ID: <CAMuHMdU1DZeigT1ES4FMrtLpnRA0fMp6k4ZhDs7U0=CvAuOxgA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 04/12] net: pcs: add Renesas MII converter driver
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Thu, May 5, 2022 at 2:33 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Le Thu, 5 May 2022 09:16:38 +0200,
> Geert Uytterhoeven <geert@linux-m68k.org> a écrit :
> > On Wed, May 4, 2022 at 11:31 AM Clément Léger <clement.leger@bootlin.com> wrote:
> > > Add a PCS driver for the MII converter that is present on the Renesas
> > > RZ/N1 SoC. This MII converter is reponsible for converting MII to
> > > RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
> > > reuse it in both the switch driver and the stmmac driver. Currently,
> > > this driver only allows the PCS to be used by the dual Cortex-A7
> > > subsystem since the register locking system is not used.
> > >
> > > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> >
> > Thanks for your patch!
> >
> > > --- /dev/null
> > > +++ b/drivers/net/pcs/pcs-rzn1-miic.c
> >
> > > +static int miic_probe(struct platform_device *pdev)
> > > +{
> > > +       struct device *dev = &pdev->dev;
> > > +       struct miic *miic;
> > > +       u32 mode_cfg;
> > > +       int ret;
> > > +
> > > +       ret = miic_parse_dt(dev, &mode_cfg);
> > > +       if (ret < 0)
> > > +               return -EINVAL;
> > > +
> > > +       miic = devm_kzalloc(dev, sizeof(*miic), GFP_KERNEL);
> > > +       if (!miic)
> > > +               return -ENOMEM;
> > > +
> > > +       spin_lock_init(&miic->lock);
> > > +       miic->dev = dev;
> > > +       miic->base = devm_platform_ioremap_resource(pdev, 0);
> > > +       if (!miic->base)
> > > +               return -EINVAL;
> > > +
> > > +       pm_runtime_enable(dev);
> > > +       ret = pm_runtime_resume_and_get(dev);
> > > +       if (ret < 0)
> >
> > Missing pm_runtime_disable(dev).
>
> Maybe using devm_pm_runtime_enable() would be sufficient and avoid such
> calls.

That's an option.
Note that that still won't allow you to get rid of the .remove() callback,
as you still have to call pm_runtime_put() manually.

> >
> > > +               return ret;
> > > +
> > > +       ret = miic_init_hw(miic, mode_cfg);
> > > +       if (ret)
> > > +               goto disable_runtime_pm;
> > > +
> > > +       /* miic_create() relies on that fact that data are attached to the
> > > +        * platform device to determine if the driver is ready so this needs to
> > > +        * be the last thing to be done after everything is initialized
> > > +        * properly.
> > > +        */
> > > +       platform_set_drvdata(pdev, miic);
> > > +
> > > +       return 0;
> > > +
> > > +disable_runtime_pm:
> > > +       pm_runtime_put(dev);
> >
> > Missing pm_runtime_disable(dev).
> >
> > > +
> > > +       return ret;
> > > +}
> > > +
> > > +static int miic_remove(struct platform_device *pdev)
> > > +{
> > > +       pm_runtime_put(&pdev->dev);
> >
> > Missing pm_runtime_disable(dev).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
