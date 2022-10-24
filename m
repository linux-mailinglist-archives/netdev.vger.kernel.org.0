Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130E060AF75
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 17:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJXPuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 11:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiJXPtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 11:49:41 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B068E793;
        Mon, 24 Oct 2022 07:43:39 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id h10so6606464qvq.7;
        Mon, 24 Oct 2022 07:43:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cZyL56Sbu/ZWWcsErYyFXiu/xf4YYzA6jTkDhDIScPI=;
        b=VbXu9B4qMToIMPmi1nP/Sm04V6i0zW6nqpG8UDgCT1zyf6zzp0BW9A73wwoc2ivV0a
         gmiwq532E/ZkIbsiMOIkj1+08sziI/psDVcSa7f4o9Wwou4b08j7CpBgMocgc5j4csfz
         zGOFOy7WS4fnPzYgFVD2OFa9CMj7P4KtkC3k7yGFtwyKBA0gxxRPCjwa+7nWFPie8InM
         Y6QAzWyAM+BvzZFdnVsxMITfxaleYlCDbEgXJEjTfIIaVjovoZIJaHaFIxcW1UfXi9S2
         ecQPkZwPqIp62M3wMyJ3gfhwoXhBAr+V+PE7e2CEzrQqha91GeQ/PTsBJfBBC1wuEzN9
         1aZw==
X-Gm-Message-State: ACrzQf0/kTgSuqokmGqbk2OfKj1f8W7W6OHfM1pNNd+ZiSe620NeTGGZ
        /YPX42zT99DJOm5VMbYPnDi6JuEeyZYL6Q==
X-Google-Smtp-Source: AMsMyM4tNxAyC8nkgKTG745OwU4bAZpAqLbk29eICes5kel5rT0ZxbHyTxhOShjWUn9ByJWDnALJGw==
X-Received: by 2002:a05:6214:21e9:b0:4bb:65c5:c989 with SMTP id p9-20020a05621421e900b004bb65c5c989mr7223231qvj.97.1666622436254;
        Mon, 24 Oct 2022 07:40:36 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id a1-20020a05620a438100b006cea2984c9bsm39168qkp.100.2022.10.24.07.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 07:40:36 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id 63so11256904ybq.4;
        Mon, 24 Oct 2022 07:40:35 -0700 (PDT)
X-Received: by 2002:a25:d24a:0:b0:6ca:4a7a:75cd with SMTP id
 j71-20020a25d24a000000b006ca4a7a75cdmr18825244ybg.89.1666622435491; Mon, 24
 Oct 2022 07:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com> <20221022104357.1276740-2-biju.das.jz@bp.renesas.com>
In-Reply-To: <20221022104357.1276740-2-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Oct 2022 16:40:24 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUThOzOKoQGbK4cRNrfPeHvv5RsRFQnAhudR0U8eD_zBw@mail.gmail.com>
Message-ID: <CAMuHMdUThOzOKoQGbK4cRNrfPeHvv5RsRFQnAhudR0U8eD_zBw@mail.gmail.com>
Subject: Re: [PATCH 1/6] can: rcar_canfd: rcar_canfd_probe: Add struct
 rcar_canfd_hw_info to driver data
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

On Sat, Oct 22, 2022 at 1:02 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> The CAN FD IP found on RZ/G2L SoC has some HW features different to that
> of R-Car. For example, it has multiple resets and multiple IRQs for global
> and channel interrupts. Also, it does not have ECC error flag registers
> and clk post divider present on R-Car. Similarly, R-Car V3U has 8 channels
> whereas other SoCs has only 2 channels.
>
> This patch adds the struct rcar_canfd_hw_info to take care of the
> HW feature differences and driver data present on both IPs. It also
> replaces the driver data chip type with struct rcar_canfd_hw_info by
> moving chip type to it.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c

> @@ -591,10 +595,22 @@ static const struct can_bittiming_const rcar_canfd_bittiming_const = {
>         .brp_inc = 1,
>  };
>
> +static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
> +       .chip_id = RENESAS_RCAR_GEN3,
> +};
> +
> +static const struct rcar_canfd_hw_info rzg2l_hw_info = {
> +       .chip_id = RENESAS_RZG2L,
> +};
> +
> +static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
> +       .chip_id = RENESAS_R8A779A0,
> +};
> +
>  /* Helper functions */
>  static inline bool is_v3u(struct rcar_canfd_global *gpriv)
>  {
> -       return gpriv->chip_id == RENESAS_R8A779A0;
> +       return gpriv->info == &r8a779a0_hw_info;

"return gpriv->info->chip_id == RENESAS_R8A779A0;" would match all
the other changes you make. But I see why you did it this way...
((most) users of is_v3u() are not converted to feature flags (yet) ;-)

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
