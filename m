Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE2848C028
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351723AbiALIoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:44:46 -0500
Received: from mail-vk1-f176.google.com ([209.85.221.176]:46658 "EHLO
        mail-vk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351576AbiALIoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:44:46 -0500
Received: by mail-vk1-f176.google.com with SMTP id bj47so1149924vkb.13;
        Wed, 12 Jan 2022 00:44:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LjeL6LehGBaC//OQBhfg2Gh/QedR10SATiGZ4ftla+8=;
        b=L0mdX8iVw5XOohnCowVrl8W+ABq0oVo7CCtAQJso+xAcFlOsOJqM8O9ncx9l4jQ++S
         9oj6EAG58lXhbZ6gYSqDN2W5WLCFlUNAOJmrIFzehnP8SsWdUcJLXAxkCovuWYRRgUXz
         EiIoRz1+qTAwgBVnB2TmU1ubwOet/1HtFgGbF9gUoqthBZV/EJ7Up7Ba7wuf7xy0BK7n
         FWEWjrfYR047xHukUAucH4yZpJbPQtBX5U3i35yvIL4cHWW/8EX1rVdaI9JkZ6OX3Net
         dwGLy39wS5ngWGinekgVFVtt/Bs4GTgIm1gz/lEqK6pHSTMfn2RZ4Xepw8c6y9hwtYYx
         cOow==
X-Gm-Message-State: AOAM532l26YnCIesrautGA4C0M9+kl0voOLb5COPGKUy8nfN+JKOvFgz
        TpxP1zVUhHqic2qEnXSE+Up+J3BnGSZoRYX9
X-Google-Smtp-Source: ABdhPJwq0VAN6WUQ7EMEeUxeNu6OpL90ARgsmB+j0sGLhwa8UeLeF+59LjgHU+jFFbTUrqReBQLgEg==
X-Received: by 2002:a05:6122:84c:: with SMTP id 12mr4150017vkk.4.1641977085230;
        Wed, 12 Jan 2022 00:44:45 -0800 (PST)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id n9sm7233455uaj.11.2022.01.12.00.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 00:44:44 -0800 (PST)
Received: by mail-ua1-f41.google.com with SMTP id i5so3331532uaq.10;
        Wed, 12 Jan 2022 00:44:44 -0800 (PST)
X-Received: by 2002:ab0:1861:: with SMTP id j33mr3953412uag.14.1641977084327;
 Wed, 12 Jan 2022 00:44:44 -0800 (PST)
MIME-Version: 1.0
References: <20220111162231.10390-1-uli+renesas@fpond.eu> <20220111162231.10390-2-uli+renesas@fpond.eu>
In-Reply-To: <20220111162231.10390-2-uli+renesas@fpond.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 12 Jan 2022 09:44:33 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVs=NWR1bRuTku09nWT+PyyVCM6Fp1GVu5brCj=VjZZ-g@mail.gmail.com>
Message-ID: <CAMuHMdVs=NWR1bRuTku09nWT+PyyVCM6Fp1GVu5brCj=VjZZ-g@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] clk: renesas: r8a779a0: add CANFD module clock
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uli,

On Tue, Jan 11, 2022 at 5:22 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> Adds "canfd0" to mod clocks.
>
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Thanks for your patch!

> --- a/drivers/clk/renesas/r8a779a0-cpg-mssr.c
> +++ b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
> @@ -136,6 +136,7 @@ static const struct mssr_mod_clk r8a779a0_mod_clks[] __initconst = {
>         DEF_MOD("avb3",         214,    R8A779A0_CLK_S3D2),
>         DEF_MOD("avb4",         215,    R8A779A0_CLK_S3D2),
>         DEF_MOD("avb5",         216,    R8A779A0_CLK_S3D2),
> +       DEF_MOD("canfd0",       328,    R8A779A0_CLK_CANFD),

The datasheet calls this "canfd".

>         DEF_MOD("csi40",        331,    R8A779A0_CLK_CSI0),
>         DEF_MOD("csi41",        400,    R8A779A0_CLK_CSI0),
>         DEF_MOD("csi42",        401,    R8A779A0_CLK_CSI0),

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-clk-for-v5.18 with the above fixed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
