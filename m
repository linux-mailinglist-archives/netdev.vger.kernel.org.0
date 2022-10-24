Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DB260AFA4
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 17:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiJXPyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 11:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJXPxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 11:53:32 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B0F55C66;
        Mon, 24 Oct 2022 07:48:46 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id cr19so5760414qtb.0;
        Mon, 24 Oct 2022 07:48:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qn7hWSl7ND7GLCfJFInGX0M2pfhxY3XLan5iDEurKFo=;
        b=l/MoBZFC19822F886Xa17PlEPmsipHp6CeqLQ00O+BbPYrNbiVeptoNlg7WrKqZOWv
         fLJKH+LlN9uCU6X3F7bWWgzw9Q0TWA7CWnOASjjFcZBkOn5yCrJxfq6FO+ckuiYm3PtU
         ga+Jh04lTmGgiOBF6N37cVFH1LYI6SXbjA22GvgMzewDA3R/Gb8HIHcGAyJTscF3ysdx
         xc/uDEhfGudzjcS8bGKkQwWhXSIdlwcnGAeFDIWT67sbIKZB7z2z3CAjYZ2viYqNFiO0
         JavIt3ieHbD65m86Khon+UtVtNFRCOyGje2VzP+OJzSGIfluVxRznPszEJZS1EFCchhW
         npMA==
X-Gm-Message-State: ACrzQf2FxXw840Rm2W+3tGkZk895m46bfh0J2r+CNMlvBTzdSKXymv7w
        rdD5yuX/CNk6XXKIpcc23NWdeEQ9fGb2wA==
X-Google-Smtp-Source: AMsMyM6rUV23xNiGQ/WdP+m5C1iW8zErJkjK2v5JYoX7szLT4O2j7YaPH0CccsQuU8oC0wf7eQRLFA==
X-Received: by 2002:a05:622a:3:b0:39c:e2d9:2fa2 with SMTP id x3-20020a05622a000300b0039ce2d92fa2mr28216778qtw.582.1666622722850;
        Mon, 24 Oct 2022 07:45:22 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id g3-20020ac87d03000000b00342f8984348sm21065qtb.87.2022.10.24.07.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 07:45:22 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id f205so11303918yba.2;
        Mon, 24 Oct 2022 07:45:22 -0700 (PDT)
X-Received: by 2002:a25:26c1:0:b0:6c3:bdae:c6d6 with SMTP id
 m184-20020a2526c1000000b006c3bdaec6d6mr30798241ybm.36.1666622721899; Mon, 24
 Oct 2022 07:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com> <20221022104357.1276740-4-biju.das.jz@bp.renesas.com>
In-Reply-To: <20221022104357.1276740-4-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Oct 2022 16:45:09 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVeVSdk1-gZ9Fv+kPSJ2q8hyjBArjKpqtfRyXjuTmMFsQ@mail.gmail.com>
Message-ID: <CAMuHMdVeVSdk1-gZ9Fv+kPSJ2q8hyjBArjKpqtfRyXjuTmMFsQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] can: rcar_canfd: Add multi_global_irqs to struct rcar_canfd_hw_info
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Biju,

On Sat, Oct 22, 2022 at 1:03 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> RZ/G2L has separate IRQ lines for receive FIFO and global error interrupt
> whereas R-Car has combined IRQ line.
>
> Add multi_global_irqs to struct rcar_canfd_hw_info to select the driver to
> choose between combined and separate irq registration for global
> interrupts.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -526,6 +526,8 @@ struct rcar_canfd_global;
>  struct rcar_canfd_hw_info {
>         enum rcanfd_chip_id chip_id;
>         u32 max_channels;
> +       /* hardware features */
> +       unsigned multi_global_irqs:1;   /* Has multiple global irqs  */

I'm not sure this is the best name for this flag (especially considering
the other flag being added in [5/6])...

>  };
>
>  /* Channel priv data */
> @@ -603,6 +605,7 @@ static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
>  static const struct rcar_canfd_hw_info rzg2l_hw_info = {
>         .chip_id = RENESAS_RZG2L,
>         .max_channels = 2,
> +       .multi_global_irqs = 1,
>  };
>
>  static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
> @@ -1874,7 +1877,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>                 of_node_put(of_child);
>         }
>
> -       if (info->chip_id != RENESAS_RZG2L) {
> +       if (!info->multi_global_irqs) {
>                 ch_irq = platform_get_irq_byname_optional(pdev, "ch_int");
>                 if (ch_irq < 0) {
>                         /* For backward compatibility get irq by index */
> @@ -1957,7 +1960,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>         gpriv->base = addr;
>
>         /* Request IRQ that's common for both channels */
> -       if (info->chip_id != RENESAS_RZG2L) {
> +       if (!info->multi_global_irqs) {

All checks for this flag are negative checks.  What about inverting
the meaning of the flag, so these can become positive checks?

>                 err = devm_request_irq(&pdev->dev, ch_irq,
>                                        rcar_canfd_channel_interrupt, 0,
>                                        "canfd.ch_int", gpriv);

As the patch itself is correct:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
