Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E71C60B4F6
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiJXSKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiJXSJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:09:32 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E0926394C;
        Mon, 24 Oct 2022 09:51:04 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so3945150pjc.3;
        Mon, 24 Oct 2022 09:51:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5iddcD8kUmmW6hP3Cs10FvwozsOGIT1nNRTjAFjTwXw=;
        b=SZ3UPPsrkR17O+CgdG3A4mRrcZqEPZeVKGP/AMcZ+xKzd9HGVC6tl6iGr6XgknVnsd
         qiaUodjhH6hljFOSFvIuQnJAM9A+Og8feh94+ql+mGJ4ZjrD1JyOiWmL6F1yd84uceBc
         TMuqJmELdT9TPvU3W34mKZrKvfpYD6wyg76z7BSbV0wov10tAoOfNDvZ6CeKFU+WYDhj
         kAH5ITNINpH2Z1XXoDUdWahw2KM+2gONscIaZWx+KZUMfqJ8Y3pOHAR5kXdMmrUqG0sZ
         U30L0f7cokYfeWh7AZzzAO7h+HjgWxk12iZ/PFSJq9zYJbfP6B3ZxrMmDqt7rfF16zZr
         7WSQ==
X-Gm-Message-State: ACrzQf3HdoNHnl9pIZto5gU8snKdPWW0Y+w4yfO5IHDrAufw1pWvvWc9
        CTd28XKhY8pMhBD2MrmKlhnYFeAcSMmuzQ==
X-Google-Smtp-Source: AMsMyM5XiBavUdZuW7ixAZ3lm5DubiSyHSbYRDqiY4C77zk2euJ5VVKktvWbVKMekvkAB2hLe/jYFA==
X-Received: by 2002:a67:ca10:0:b0:398:a567:1070 with SMTP id z16-20020a67ca10000000b00398a5671070mr17791771vsk.47.1666623300624;
        Mon, 24 Oct 2022 07:55:00 -0700 (PDT)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id b129-20020a1fcb87000000b003b3b3ba0010sm1528152vkg.45.2022.10.24.07.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 07:55:00 -0700 (PDT)
Received: by mail-ua1-f54.google.com with SMTP id f12so4834800uae.3;
        Mon, 24 Oct 2022 07:55:00 -0700 (PDT)
X-Received: by 2002:a25:2:0:b0:6c4:dc1:d37c with SMTP id 2-20020a250002000000b006c40dc1d37cmr27671969yba.380.1666622879071;
 Mon, 24 Oct 2022 07:47:59 -0700 (PDT)
MIME-Version: 1.0
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com> <20221022104357.1276740-5-biju.das.jz@bp.renesas.com>
In-Reply-To: <20221022104357.1276740-5-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Oct 2022 16:47:47 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV-uG5Q6OQd+=HHTzOUuw_T4_2i6cNh5fcZCBWACcoptg@mail.gmail.com>
Message-ID: <CAMuHMdV-uG5Q6OQd+=HHTzOUuw_T4_2i6cNh5fcZCBWACcoptg@mail.gmail.com>
Subject: Re: [PATCH 4/6] can: rcar_canfd: Add clk_postdiv to struct rcar_canfd_hw_info
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
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
> R-Car has a clock divider for CAN FD clock within the IP, whereas
> it is not available on RZ/G2L.
>
> Add clk_postdiv to struct rcar_canfd_hw_info to take care of this
> difference.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -528,6 +528,7 @@ struct rcar_canfd_hw_info {
>         u32 max_channels;
>         /* hardware features */
>         unsigned multi_global_irqs:1;   /* Has multiple global irqs  */
> +       unsigned clk_postdiv:1;         /* Has CAN clk post divider  */

As this is not the actual post divider, I think this should be called
has_clk_postdiv. But see below...

>  };
>
>  /* Channel priv data */

> @@ -1948,7 +1951,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>         }
>         fcan_freq = clk_get_rate(gpriv->can_clk);
>
> -       if (gpriv->fcan == RCANFD_CANFDCLK && info->chip_id != RENESAS_RZG2L)
> +       if (gpriv->fcan == RCANFD_CANFDCLK && info->clk_postdiv)
>                 /* CANFD clock is further divided by (1/2) within the IP */
>                 fcan_freq /= 2;

If info->clk_postdiv would be the actual post divider, you could simplify to:

    if (gpriv->fcan == RCANFD_CANFDCLK)
            fcan_freq /= info->postdiv;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
