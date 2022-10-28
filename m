Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA61610D49
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiJ1Jbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiJ1Jbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:31:35 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639D51C2EA6;
        Fri, 28 Oct 2022 02:31:35 -0700 (PDT)
Received: by mail-qt1-f182.google.com with SMTP id g16so3132556qtu.2;
        Fri, 28 Oct 2022 02:31:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TUPxAxBOedpCe3uto+qLKu/zGMsAA1ebYp0ttjtv2+4=;
        b=lzLgncB/duPcdvCa9Ifng/36a+Lw+yPTmXb3IyHQa9F322IEE4jSAfQhmCnXVTapi3
         LuGvzZfgjRn8i5Bjyo7IGfsxlVIxKU1AVMhHPqT+E2M9CxzyT+gLGpAlprNNPK1ln5gL
         YNf2XOmp7UoWtuxOev/9VV5LTs8PfynaL1yekKuqq4lTLDR7YlmDnARIaP0maeU0hUTL
         5Xw7Nt2PyzFe4QzGGNCmvLtMS4JT3KvfFs5jJompB0aSBrcwYqgTsjkbNqK9bmDS3La7
         d2qBpwfmGdEfleOAx33X42zpczN2qoKOtF+76e9jWtQ8ruhvtVrKda9U3YARlp1OTJ50
         KGCw==
X-Gm-Message-State: ACrzQf0yVAgQXJ5yvEjAiPggXOElEZlJCWGamHFYHcamXJyMRbh7/EdN
        tgjeXCRP930zWy2zDF0pYssyPGipim2tXw==
X-Google-Smtp-Source: AMsMyM4Tvi9LFBQU6xjP2m95knridKLBQPfwDQfdY2W0+znveVF2+MaRkL74UvKbfsk1jsv5bzt15Q==
X-Received: by 2002:a05:622a:1a19:b0:39c:d550:6ac3 with SMTP id f25-20020a05622a1a1900b0039cd5506ac3mr43709545qtb.204.1666949494217;
        Fri, 28 Oct 2022 02:31:34 -0700 (PDT)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id w29-20020a05620a095d00b006eecc4a0de9sm2553527qkw.62.2022.10.28.02.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 02:31:33 -0700 (PDT)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-368edbc2c18so41973907b3.13;
        Fri, 28 Oct 2022 02:31:33 -0700 (PDT)
X-Received: by 2002:a81:5a57:0:b0:353:6de6:3263 with SMTP id
 o84-20020a815a57000000b003536de63263mr48432888ywb.358.1666949493320; Fri, 28
 Oct 2022 02:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20221027082158.95895-1-biju.das.jz@bp.renesas.com> <20221027082158.95895-5-biju.das.jz@bp.renesas.com>
In-Reply-To: <20221027082158.95895-5-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 28 Oct 2022 11:31:21 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVf8R8JHM8jay2LiGGb8gLn1W0N8Q901ADcaNWv4hmAvQ@mail.gmail.com>
Message-ID: <CAMuHMdVf8R8JHM8jay2LiGGb8gLn1W0N8Q901ADcaNWv4hmAvQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] can: rcar_canfd: Add postdiv to struct rcar_canfd_hw_info
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Biju,

On Thu, Oct 27, 2022 at 10:22 AM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> R-Car has a clock divider for CAN FD clock within the IP, whereas
> it is not available on RZ/G2L.
>
> Add postdiv variable to struct rcar_canfd_hw_info to take care of this
> difference.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v2->v3:
>  * Replaced data type of postdiv from unsigned int->u8 to save memory.

Thanks for the update!

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -1943,9 +1947,9 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>         }
>         fcan_freq = clk_get_rate(gpriv->can_clk);
>
> -       if (gpriv->fcan == RCANFD_CANFDCLK && info->chip_id != RENESAS_RZG2L)
> +       if (gpriv->fcan == RCANFD_CANFDCLK)
>                 /* CANFD clock is further divided by (1/2) within the IP */

may be further divided?

> -               fcan_freq /= 2;
> +               fcan_freq /= info->postdiv;
>
>         addr = devm_platform_ioremap_resource(pdev, 0);
>         if (IS_ERR(addr)) {

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
