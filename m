Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB78551B857
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 08:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242125AbiEEHDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 03:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbiEEHDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 03:03:11 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6B147542;
        Wed,  4 May 2022 23:59:33 -0700 (PDT)
Received: by mail-qt1-f178.google.com with SMTP id fu47so2550439qtb.5;
        Wed, 04 May 2022 23:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1kyfcH624YObu9U2EDyv5UgsEw2pZgVLfORpPmEDwV0=;
        b=nWWUsf1bTJ+CMZZR5AU2u+FV/aybBvUyJCs+xDgnGh2TzZlfUParIuyftqeoDAok/b
         RT8Lhl9o014I77zuR8NenXQeojLARxbXAn/OQPE/kQDaF9YZpglfGfINRC8AoLpD7ctX
         UClm4ry34tJBAZABMAF10YjIYw7k2aRdMNFNFv9GW/U1RtKraEodAM2rSp47qHZDqEiV
         0wsps8xVODiMZJp4SDShCbYblS4wWMardvB0b7Kih9SfEzSYVdtr5rL+jdCWaP6tORAP
         qsY3NhZK+cqfQm7N2k94EhP5IfC/ORkdvLRPfMikIZ+5/WPgDXswu35MQJRZwCkmaPQl
         PdfQ==
X-Gm-Message-State: AOAM532/yJVEWlfp1l/QmtTWu+u2cUEV9zSAxzjs/l6wa5LyhvoJxn7l
        FyGBQV6jwwKpn0nekQ1blkbAeMTSJdazQg==
X-Google-Smtp-Source: ABdhPJw3MVPc9LHMVwPOhabxZSORgomuFxm6Jt5ZC7fVqXJn/7fBzffvKV3zHZL95VgCt2Amnn0lBA==
X-Received: by 2002:a05:622a:1649:b0:2f3:a6bc:73ea with SMTP id y9-20020a05622a164900b002f3a6bc73eamr16029240qtj.506.1651733971970;
        Wed, 04 May 2022 23:59:31 -0700 (PDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id x74-20020a37634d000000b0069ff51425a2sm392481qkb.120.2022.05.04.23.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 23:59:31 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id y76so6146666ybe.1;
        Wed, 04 May 2022 23:59:31 -0700 (PDT)
X-Received: by 2002:a05:6902:389:b0:633:31c1:d0f7 with SMTP id
 f9-20020a056902038900b0063331c1d0f7mr19881851ybs.543.1651733970778; Wed, 04
 May 2022 23:59:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220504145454.71287-1-phil.edworthy@renesas.com> <20220504175757.0a3c1a6a@kernel.org>
In-Reply-To: <20220504175757.0a3c1a6a@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 5 May 2022 08:59:19 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXKUpHa0SGGQUbepAHoS3evEBSzF4RYqA8B09eq1CtBUw@mail.gmail.com>
Message-ID: <CAMuHMdXKUpHa0SGGQUbepAHoS3evEBSzF4RYqA8B09eq1CtBUw@mail.gmail.com>
Subject: Re: [PATCH 0/9] Add Renesas RZ/V2M Ethernet support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Phil Edworthy <phil.edworthy@renesas.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-clk <linux-clk@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
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

Hi Jakub,

On Thu, May 5, 2022 at 2:58 AM Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed,  4 May 2022 15:54:45 +0100 Phil Edworthy wrote:
> > The RZ/V2M Ethernet is very similar to R-Car Gen3 Ethernet-AVB, though
> > some small parts are the same as R-Car Gen2.
> > Other differences are:
> > * It has separate data (DI), error (Line 1) and management (Line 2) irqs
> >   rather than one irq for all three.
> > * Instead of using the High-speed peripheral bus clock for gPTP, it has
> >   a separate gPTP reference clock.
> >
> > The dts patches depend on v4 of the following patch set:
> > "Add new Renesas RZ/V2M SoC and Renesas RZ/V2M EVK support"
> >
> > Phil Edworthy (9):
> >   clk: renesas: r9a09g011: Add eth clock and reset entries
> >   dt-bindings: net: renesas,etheravb: Document RZ/V2M SoC
> >   ravb: Separate use of GIC reg for PTME from multi_irqs
> >   ravb: Separate handling of irq enable/disable regs into feature
> >   ravb: Support separate Line0 (Desc), Line1 (Err) and Line2 (Mgmt) irqs
> >   ravb: Use separate clock for gPTP
> >   ravb: Add support for RZ/V2M
> >   arm64: dts: renesas: r9a09g011: Add ethernet nodes
> >   arm64: dts: renesas: rzv2m evk: Enable ethernet
>
> How are you expecting this to be merged?
>
> I think you should drop the first (clk) patch from this series
> so we can apply the series to net-next. And route the clk patch
> thru Geert's tree separately?

Same for the last two DTS patches, they should go through the
renesas-devel and SoC trees.

> Right now patchwork thinks the series is incomplete because it
> hasn't received patch 1.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
