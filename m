Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FDB3E5524
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbhHJI1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:27:30 -0400
Received: from mail-vs1-f53.google.com ([209.85.217.53]:35520 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbhHJI13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 04:27:29 -0400
Received: by mail-vs1-f53.google.com with SMTP id b138so11840170vsd.2;
        Tue, 10 Aug 2021 01:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vEsirkXQR9XRp+ESI/NxcQBZnW3vhj14fJ6I3VFuv8A=;
        b=UD91EvcN64Sn5cTlmapZjGWsk6y0y7UxLBoYUCY/5B2dh/9AHGEVGnfg8w2mlTSvpi
         oKkcKz7XnoZgUBXq1FRabu/PUictdty3Tp0ypOjFJifmZscNy4Oa9+vduuRQZQ7rxdyM
         xOkedV28ASTRmZNQddXahBCIuMll74ecCm6sKJpNrczMdttjfk8kQ9lDe70+wxa0+G93
         wcHeSjiIv0of8t4qZ+jOe9H+MjOE//F69awHM2kyy4ReDDSBKsNJYAhfBOsSowKOUxo9
         4xs3y476RL/MqWTFqNgDjPRYvf6LWORdkQwoRAGpXKi+NGwKV9unIcXyHTp0Qvyqm7AX
         jcnw==
X-Gm-Message-State: AOAM531/fbaB2CevqC8dCODysNQPCiwAPe/QbScQ5jd0nFAHm32lqaPN
        qPGPSgQENLJveDrd5zRPDLpCnejxnFyjNLDtPOM=
X-Google-Smtp-Source: ABdhPJwyqKTQQpPefbrJQBBtVL0JrZHJed0ystZSCbUas8Yc765XYNut1HHYKt7QAQ0qru2tK8FCEcPeuQXvb7ROTe4=
X-Received: by 2002:a05:6102:d9:: with SMTP id u25mr11249297vsp.42.1628584026679;
 Tue, 10 Aug 2021 01:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210727133022.634-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210727133022.634-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 10 Aug 2021 10:26:55 +0200
Message-ID: <CAMuHMdU7-AahJmKLabba_ZF2bcPwktU00Q_uBOYm+AdiBVGyTA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] can: rcar_canfd: Add support for RZ/G2L family
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Tue, Jul 27, 2021 at 3:30 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> CANFD block on RZ/G2L SoC is almost identical to one found on
> R-Car Gen3 SoC's. On RZ/G2L SoC interrupt sources for each channel
> are split into different sources and the IP doesn't divide (1/2)
> CANFD clock within the IP.
>
> This patch adds compatible string for RZ/G2L family and splits
> the irq handlers to accommodate both RZ/G2L and R-Car Gen3 SoC's.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

I've just noticed a set of silly typos:

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c

> +static void rcar_canfd_handle_global_recieve(struct rcar_canfd_global *gpriv, u32 ch)

receive (everywhere)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
