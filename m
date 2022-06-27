Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145CF55C277
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiF0LL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234463AbiF0LLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:11:55 -0400
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A08A64FF;
        Mon, 27 Jun 2022 04:11:51 -0700 (PDT)
Received: by mail-qk1-f173.google.com with SMTP id z16so1716949qkj.7;
        Mon, 27 Jun 2022 04:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+ZRxW1YKi5NLQExbgi/2LRM6yY1JhReqBKCutrudz4=;
        b=N2CIcCqgLL+kTpT9cr9LaIN/eKcnK5VPw1Y02fzweKIFvg83Isjg93jRzZGixrMqfB
         p7BhCznTVUZ7xkuhVsXkHHiEiMYjOafkFYE94FYyaVenGxAM2QWC+u8C3/hMvbtNFjJV
         sU5AdhoSoF38LyJvXeH3bOrsAd3UYFgNxGB6p9It/z1vwqMiq/cQp0qULPF86ITHF5C0
         yUCQioycWkdmCX0AQDfJp3G88W2PZKKMwzGdga6SbT/6DlSbzc22/ZtyIOV6MJFTI9pg
         hZ4L8oFvbinHLslhNKMZTzw51tBf3224gZ66PPdPcRj3pHNMFmThfomsMjR1iFkcceE3
         pQKg==
X-Gm-Message-State: AJIora+TxZtDPkac0Nd64K+HEC9oE0n+u8XlIaZVzkfJLaVsdBbjZ5gA
        L76LfeLwQmJRAo6O2OZ5tgZAahI/zol+TQ==
X-Google-Smtp-Source: AGRyM1shltW4EfDw4YxXU9L5mZQQZHwGgRm/IrH5LsU85eThjMH2RvwWgysYkoiQDK+jNfoRzYoqtw==
X-Received: by 2002:a37:2756:0:b0:6ae:f7c2:ae4a with SMTP id n83-20020a372756000000b006aef7c2ae4amr7694171qkn.504.1656328310185;
        Mon, 27 Jun 2022 04:11:50 -0700 (PDT)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id k12-20020a05620a414c00b006aefe22d75bsm7139684qko.80.2022.06.27.04.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 04:11:50 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-3137316bb69so81467997b3.10;
        Mon, 27 Jun 2022 04:11:49 -0700 (PDT)
X-Received: by 2002:a81:74c5:0:b0:31b:ca4b:4bc4 with SMTP id
 p188-20020a8174c5000000b0031bca4b4bc4mr3924783ywc.358.1656328309540; Mon, 27
 Jun 2022 04:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220624144001.95518-1-clement.leger@bootlin.com> <165632701762.8538.13185906941735942250.git-patchwork-notify@kernel.org>
In-Reply-To: <165632701762.8538.13185906941735942250.git-patchwork-notify@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 27 Jun 2022 13:11:37 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUvSLFU56gsp1a9isOiP9otdCJ2-BqhbrffcoHuA6JNig@mail.gmail.com>
Message-ID: <CAMuHMdUvSLFU56gsp1a9isOiP9otdCJ2-BqhbrffcoHuA6JNig@mail.gmail.com>
Subject: Re: [PATCH net-next v9 00/16] add support for Renesas RZ/N1 ethernet
 subsystem devices
To:     "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Mon, Jun 27, 2022 at 12:50 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
>
> On Fri, 24 Jun 2022 16:39:45 +0200 you wrote:
> > The Renesas RZ/N1 SoCs features an ethernet subsystem which contains
> > (most notably) a switch, two GMACs, and a MII converter [1]. This
> > series adds support for the switch and the MII converter.
> >
> > The MII converter present on this SoC has been represented as a PCS
> > which sit between the MACs and the PHY. This PCS driver is probed from
> > the device-tree since it requires to be configured. Indeed the MII
> > converter also contains the registers that are handling the muxing of
> > ports (Switch, MAC, HSR, RTOS, etc) internally to the SoC.
> >
> > [...]
>
> Here is the summary with links:

>   - [net-next,v9,12/16] ARM: dts: r9a06g032: describe MII converter
>     https://git.kernel.org/netdev/net-next/c/066c3bd35835
>   - [net-next,v9,13/16] ARM: dts: r9a06g032: describe GMAC2
>     https://git.kernel.org/netdev/net-next/c/3f5261f1c2a8
>   - [net-next,v9,14/16] ARM: dts: r9a06g032: describe switch
>     https://git.kernel.org/netdev/net-next/c/cf9695d8a7e9
>   - [net-next,v9,15/16] ARM: dts: r9a06g032-rzn1d400-db: add switch description
>     https://git.kernel.org/netdev/net-next/c/9aab31d66ec9

Please do not apply DTS patches to the netdev tree.
These should go in through the platform and soc trees instead.

Thanks for reverting!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
