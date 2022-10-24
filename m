Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535A060AFD9
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 17:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbiJXP6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 11:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiJXP5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 11:57:53 -0400
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756144E601;
        Mon, 24 Oct 2022 07:52:51 -0700 (PDT)
Received: by mail-qv1-f51.google.com with SMTP id x15so6657704qvp.1;
        Mon, 24 Oct 2022 07:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hiV0wd0ZedNES78d4Qr6q5fHDOKQLstM4eFqxAJD9w8=;
        b=f+/FncwFwIMpY5lBJ3SQ2Pdp7bEUbGOl/Z5gvqYvLMvaVCsPhIm65lhoMiMrHjK1MH
         /JgElj45uSrKqRukD6OV5ll9647aV/3XFY6hbwTbwogbFCYV82jDBCY+8BMfpNjXlsUB
         wWhCvS84hlZq9Y5ESkgUGfceWrK2WTb3WC1/Lg5n7pNFeZwSijCblIYtLDFmx2ndf2S+
         Kf5mbuPf6tJXDtxZT2nK30WMGiNz+DX/XMEk5w0q2TTuvGaJXUDHSIMOP+wKOPJgIPek
         rQW4/7/XraKtNgqdltp0ZBPr0sBrBVgClvx3IY80xcWvO3YtkbRQrd9wLl3m5LCLaxI0
         FYIA==
X-Gm-Message-State: ACrzQf2N0+kTAOZuoUafJbtDrI4iygouWlGrBwoDbP6nzSiiprEUjbH1
        JQyoe9e5necLdbJkJZTuGuyJ7yM9lZ2IRw==
X-Google-Smtp-Source: AMsMyM5tJ67w9q1fOpANni5p4k7B6ERSOShsifk40QXrUs+6SsMpTTcPbCUSpIEl3e2oZ+cTkFcT8Q==
X-Received: by 2002:ad4:5f8d:0:b0:4bb:6d57:cfea with SMTP id jp13-20020ad45f8d000000b004bb6d57cfeamr5111139qvb.98.1666623042999;
        Mon, 24 Oct 2022 07:50:42 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id k1-20020a05620a142100b006ee949b8051sm81970qkj.51.2022.10.24.07.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 07:50:42 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id n130so11250888yba.10;
        Mon, 24 Oct 2022 07:50:41 -0700 (PDT)
X-Received: by 2002:a25:d24a:0:b0:6ca:4a7a:75cd with SMTP id
 j71-20020a25d24a000000b006ca4a7a75cdmr18864909ybg.89.1666623041678; Mon, 24
 Oct 2022 07:50:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com> <20221022104357.1276740-6-biju.das.jz@bp.renesas.com>
In-Reply-To: <20221022104357.1276740-6-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Oct 2022 16:50:30 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXz4eTcSF2obEZ2pSby+3++H0CD-YfL_weE=XxZrXqQ8A@mail.gmail.com>
Message-ID: <CAMuHMdXz4eTcSF2obEZ2pSby+3++H0CD-YfL_weE=XxZrXqQ8A@mail.gmail.com>
Subject: Re: [PATCH 5/6] can: rcar_canfd: Add multi_channel_irqs to struct rcar_canfd_hw_info
To:     biju.das.jz@bp.renesas.com
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 1:03 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> RZ/G2L has separate IRQ lines for tx and error interrupt for each
> channel whereas R-Car has a combined IRQ line for all the channel
> specific tx and error interrupts.
>
> Add multi_channel_irqs to struct rcar_canfd_hw_info to select the
> driver to choose between combined and separate irq registration for
> channel interrupts. This patch also removes enum rcanfd_chip_id and
> chip_id from both struct rcar_canfd_hw_info, as it is unused.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
