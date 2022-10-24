Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A8B60B3FE
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 19:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbiJXRXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 13:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiJXRXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 13:23:15 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEECB3137F;
        Mon, 24 Oct 2022 08:58:24 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id b25so6313442qkk.7;
        Mon, 24 Oct 2022 08:58:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rBAhu8NoGXuB555vSSAG6ujvGRVSYY8Ax/kYBoDzfrc=;
        b=RgfhSQOdRoPwH8uQ9Sqev3VRD/QPcGtEwrQ8wOGXJ23uWrVjwWXprsN2K1jb5jPaVB
         9U8FAv8lOnJfM+fADmH/J30hrJKq3qxg1yN4+p/yijJTTBjXObthNh9/GOIGFJQCm4p3
         TwwZQlaWktcICIWiI+WV4c5wJS0uMDLCBC99Q80b2pbH1NClWQs3DnpeKihfVy19lN34
         t4xs4EfcKFtW5rUdbvEj5XQifW8XfGzAY188Uvr375YPeW4e69WeRsUF5Rm/6CqadVnq
         x4KkN93GjrdvWQPJRWXTtY7vCRAj3s0mkdPGPGa6ff7tUtLoTn76Gvv1ClqDlYzHLXjv
         gr9w==
X-Gm-Message-State: ACrzQf1z+ODL1axlhMeT2cVOelapf83cIGXrHeBqHL23oTxIOcIf02Xc
        eOHrXG/aL3/TIi++aIqYYQ6JvXB7AOqH3Q==
X-Google-Smtp-Source: AMsMyM5HGSVCOB4uXsgihjAyOtr3nDTUXLaAa2l+l8t3ygQCwqtHG+bjN/MjZokHFsvRUaPqQPWftA==
X-Received: by 2002:a05:622a:15d1:b0:39c:f1da:fe0e with SMTP id d17-20020a05622a15d100b0039cf1dafe0emr27502191qty.662.1666622494858;
        Mon, 24 Oct 2022 07:41:34 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id cm21-20020a05622a251500b0039c72bb51f3sm13314qtb.86.2022.10.24.07.41.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 07:41:34 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id e62so11256143yba.6;
        Mon, 24 Oct 2022 07:41:33 -0700 (PDT)
X-Received: by 2002:a25:4fc2:0:b0:6be:afb4:d392 with SMTP id
 d185-20020a254fc2000000b006beafb4d392mr27409858ybb.604.1666622493666; Mon, 24
 Oct 2022 07:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com> <20221022104357.1276740-3-biju.das.jz@bp.renesas.com>
In-Reply-To: <20221022104357.1276740-3-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Oct 2022 16:41:22 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWczrC=WsDF6SchD=GwtG_OA+gAC4frF5i+qX5mpXEUfQ@mail.gmail.com>
Message-ID: <CAMuHMdWczrC=WsDF6SchD=GwtG_OA+gAC4frF5i+qX5mpXEUfQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] can: rcar_canfd: Add max_channels to struct rcar_canfd_hw_info
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

On Sat, Oct 22, 2022 at 1:13 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> R-Car V3U supports a maximum of 8 channels whereas rest of the SoCs
> support 2 channels.
>
> Add max_channels variable to struct rcar_canfd_hw_info to handle this
> difference.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -525,6 +525,7 @@ struct rcar_canfd_global;
>
>  struct rcar_canfd_hw_info {
>         enum rcanfd_chip_id chip_id;
> +       u32 max_channels;

Although I wouldn't mind "unsigned int" instead...

>  };
>
>  /* Channel priv data */

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
