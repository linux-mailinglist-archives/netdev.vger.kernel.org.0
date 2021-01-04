Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1312E93B7
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 11:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbhADKwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 05:52:23 -0500
Received: from mail-oo1-f45.google.com ([209.85.161.45]:34674 "EHLO
        mail-oo1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbhADKwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 05:52:23 -0500
Received: by mail-oo1-f45.google.com with SMTP id x23so6181519oop.1;
        Mon, 04 Jan 2021 02:52:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q0c1Y3LPa+ARd4G//BxkyHoz21dY5cJnRVsgk53Tbn0=;
        b=W2qolnfRpSNOO2OPET4j501GZ6Fbc3ix9/s35u7f2ncBvczG8Kuep0IsneSeOvRgbM
         LHJe1xNLSIF+3rPwk37OCQKnanEsCckhOJHRdFhCPgrOLruGpfZRBK9+GvxM/hkdmCfz
         DkiIM1qGywXwkhOxgUzQgNZGJDHyoHsdlLjq4UYUNEcTmQCODczWIus72CpYNdOOO7vu
         zFMEp0Juq80U/0fdPv7qtEN8yBLuRt0HlcDc6h8u5KiAtctNbqsQ9+3YEE6Ny/v/sSWt
         uX8TC+ZW0nwJOVOrDkYKw5MT5mDYa7+aLW5O+JZX7cX7RrsisHeZhIzytloZvyaL8pj4
         EPfw==
X-Gm-Message-State: AOAM530a99uL6vF7UTuXVr4D0qYlWN2ocgbfSUT97D54nKcDX4MJ+C3k
        aGzFRMG5vMAFmevVG2picUnPZR5K6MT+iXsLQkk=
X-Google-Smtp-Source: ABdhPJzvxPnIglxjOoytlJMwE5oDPJlVBKkIU/bFGP9uDfDV7fCPuik4jToHwv9sqFHZKPyvpQob0nH+8q9/7XJ4cV4=
X-Received: by 2002:a4a:ca14:: with SMTP id w20mr48712009ooq.11.1609757502401;
 Mon, 04 Jan 2021 02:51:42 -0800 (PST)
MIME-Version: 1.0
References: <20201231155957.31165-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20201231155957.31165-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 4 Jan 2021 11:51:31 +0100
Message-ID: <CAMuHMdX2ruikh4voRrHPmi=ti+eHVxXh6N05s1XH6+r5MeeqQw@mail.gmail.com>
Subject: Re: [PATCH] can: rcar: Update help description for CAN_RCAR_CANFD config
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Thu, Dec 31, 2020 at 5:00 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> The rcar_canfd driver supports R-Car Gen3 and RZ/G2 SoC's, update the
> description to reflect this.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

> --- a/drivers/net/can/rcar/Kconfig
> +++ b/drivers/net/can/rcar/Kconfig
> @@ -10,13 +10,13 @@ config CAN_RCAR
>           be called rcar_can.
>
>  config CAN_RCAR_CANFD
> -       tristate "Renesas R-Car CAN FD controller"
> +       tristate "Renesas R-Car Gen3 and RZ/G2 CAN FD controller"
>         depends on ARCH_RENESAS || ARM

Not introduced by this patch, but the "|| ARM" looks strange to me.
Is this meant for compile-testing? Doesn't the driver compile on all
platforms (it does on m68k), so "|| COMPILE_TEST" is not appropriate?
Is the CAN FD controller present on some Renesas arm32 SoCs (but
not yet supported by this driver)?

>         help
>           Say Y here if you want to use CAN FD controller found on
> -         Renesas R-Car SoCs. The driver puts the controller in CAN FD only
> -         mode, which can interoperate with CAN2.0 nodes but does not support
> -         dedicated CAN 2.0 mode.
> +         Renesas R-Car Gen3 and RZ/G2 SoCs. The driver puts the
> +         controller in CAN FD only mode, which can interoperate with
> +         CAN2.0 nodes but does not support dedicated CAN 2.0 mode.
>
>           To compile this driver as a module, choose M here: the module will
>           be called rcar_canfd.

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
