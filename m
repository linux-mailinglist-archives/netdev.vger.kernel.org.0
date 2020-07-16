Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95812225D4
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgGPOiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:38:04 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44979 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgGPOiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:38:02 -0400
Received: by mail-ot1-f65.google.com with SMTP id 5so4323541oty.11;
        Thu, 16 Jul 2020 07:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cFt6Ih4dR+9bhvF4Z3Iyf+2RottXHRxHsSc8BPG3n+E=;
        b=ICQpLaNGHYXZ6OwEY0O4U1XxZ9MZ+dYPwjco8/MOdtYg/sEmEkq4I5GDmgaGYfbdri
         sldOgwedtQa3K6GvcQi8jWncsUNtPyupuzoYiocgbT8+zFJua4ox7zx1uZut1S7sHgD5
         yA8K2g6iz9J8nercYJPdP8VF1vBtUswIwTlZt0Oh+PmR5TRcou1vi0EuQKv1MpH7Ss1W
         +FVs5TPCkjOPfS6wCw0Q1jhBabdRDvvNIn6zKRW/Bd0QEBSFW1IBvnxIKAtqus+lKKmE
         9Ze+HwmXyKiQWUHTJDW9JuqvkhE9UntCQowy18A8ttsHSC5hZSgiURf3vBOKwJmeWnil
         +UZg==
X-Gm-Message-State: AOAM531aXd/VvTXk0N53XkA5QO9OzW3G/BMzdH5XMyhNuKNSc+YhfSLT
        I3qqWjM4lq7LzWaI7z+m85ssH84FZbHGhICfxt8=
X-Google-Smtp-Source: ABdhPJwkPkeL5c/hqJtoC1wZ2AAYrBSLb4X8g8cBn+I7fUNaNR8wo2Ics7CsuC8wJT1X2HzPdN2+2dOWg7q7F3mH9cc=
X-Received: by 2002:a9d:2646:: with SMTP id a64mr4463700otb.107.1594910281539;
 Thu, 16 Jul 2020 07:38:01 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 16:37:50 +0200
Message-ID: <CAMuHMdX3F0He8gxUpF3Z+wTUqX2hBzs+0RRgL1Wzyn-gfzTyDg@mail.gmail.com>
Subject: Re: [PATCH 03/20] thermal: rcar_gen3_thermal: Add r8a774e1 support
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 1:09 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
>
> Add r8a774e1 specific compatible string.
>
> Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
