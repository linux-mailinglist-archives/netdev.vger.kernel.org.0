Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AE7381DC7
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 11:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhEPJzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 05:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229661AbhEPJzU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 May 2021 05:55:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D994B61183;
        Sun, 16 May 2021 09:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621158845;
        bh=x4mAmOQ3bS62UQ0vggyykS8w7giU9rdGau+C+3JrO98=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=S81PODVFpaz5wdASUOVITxJ40DoAV1AKwAtG0mZRROCdHeWo0af+yFokNnieVXY8G
         MhWKJeW/wCPTrI/dHWy4jQlkUbdAeFT4jsyFGN55OuCvytqY4Sb2treif9U7IsbalN
         S4emhrTTRkvtGuLlKhgu/QS1+X9LVKRotUlya20sZKZIhpY8q7br12FOHEnivDISEm
         6Ee+LFaL6qKv2QM7+x5PaVAMX1YTZtEdBLuOuB5n4hetzkpvWBPKkJ1khUIKmB2UkP
         YwlGMQcSxwKEUY1XtX/17SSNUJYINzJIZ921oxrbVaJet3B7ZB+5nbI0c46QqEql3T
         pVUUofUiDFOJg==
Received: by mail-oi1-f177.google.com with SMTP id b25so3913653oic.0;
        Sun, 16 May 2021 02:54:05 -0700 (PDT)
X-Gm-Message-State: AOAM5326gg6olqEg8HBEKPtnt6XRg5CYRlQnuRTRg6cwdQelyH2ZJ66A
        J8AENrd95k2MGTlsrJmYNZXBeX9RGpj2HkmKF18=
X-Google-Smtp-Source: ABdhPJzMlKuXo356CSH09rt0kOrSVzLbOky255qYlXgAFIksVXqpXl8TxKelEIy6T9w1280nD6FgFNdtOgN7zJg7dXk=
X-Received: by 2002:aca:3389:: with SMTP id z131mr11986472oiz.11.1621158845163;
 Sun, 16 May 2021 02:54:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAMuHMdVfjE=+YiqCrPfGObeYYkQwKGiQEWyprQr-n9z7J9-X-A@mail.gmail.com>
 <1528604559-972-3-git-send-email-schmitzmic@gmail.com>
In-Reply-To: <1528604559-972-3-git-send-email-schmitzmic@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 16 May 2021 11:52:59 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0pH0V_y-Ayt0rTNgZGR+Rm6tVRSzjCbo_vuA97c4shkA@mail.gmail.com>
Message-ID: <CAK8P3a0pH0V_y-Ayt0rTNgZGR+Rm6tVRSzjCbo_vuA97c4shkA@mail.gmail.com>
Subject: Re: [PATCH 2/2] net-next: xsurf100: drop include of lib8390.c
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        kernel@mkarcher.dialup.fu-berlin.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 10, 2018 at 6:23 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>
> Now that ax88796.c exports the ax_NS8390_reinit() symbol, we can
> include 8390.h instead of lib8390.c, avoiding duplication of that
> function and killing a few compile warnings in the bargain.
>
> Fixes: 861928f4e60e826c ("net-next: New ax88796 platform
> driver for Amiga X-Surf 100 Zorro board (m68k)")
>
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
> ---
>  drivers/net/ethernet/8390/xsurf100.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)

Geert noticed that a patch I just sent is similar to this one. Since I assume
you have verified this version works, it would be nice if you could resend
both patches.

Alternatively, I can include them in my series if you like.

Reviewed-by: Arnd Bergmann <arnd@arndb.de

> diff --git a/drivers/net/ethernet/8390/xsurf100.c b/drivers/net/ethernet/8390/xsurf100.c
> index e2c9638..1c3e8d1 100644
> --- a/drivers/net/ethernet/8390/xsurf100.c
> +++ b/drivers/net/ethernet/8390/xsurf100.c
> @@ -22,8 +22,6 @@
>  #define XS100_8390_DATA_WRITE32_BASE 0x0C80
>  #define XS100_8390_DATA_AREA_SIZE 0x80
>
> -#define __NS8390_init ax_NS8390_init
> -
>  /* force unsigned long back to 'void __iomem *' */
>  #define ax_convert_addr(_a) ((void __force __iomem *)(_a))
>
> @@ -42,10 +40,11 @@
>  /* Ensure we have our RCR base value */
>  #define AX88796_PLATFORM
>
> -static unsigned char version[] =
> -               "ax88796.c: Copyright 2005,2007 Simtec Electronics\n";
> +#define NS8390_CORE
> +#include "8390.h"

I don't see that #define being referenced anywhere, can that be dropped?

        Arnd
