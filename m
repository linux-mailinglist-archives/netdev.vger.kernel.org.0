Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6550E60B193
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbiJXQ1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbiJXQ1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:27:25 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC74328E32;
        Mon, 24 Oct 2022 08:14:04 -0700 (PDT)
Received: by mail-qk1-f169.google.com with SMTP id a5so6237092qkl.6;
        Mon, 24 Oct 2022 08:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m4viJHxfacreRm9wTZHfw/EqLzaLhJI57ZF7n+4sesI=;
        b=lddOhnkSKqyV2/fbsZbKMLZdAwM9Y/gUuPCGVvtUPfVT/jTGajqv3g6uH7kAKNtS2T
         tFa6RmIdpi/lUs9ONaT9r20sWi2CmpUJ91rusL8/c/hSzUK2hh2fDoKNltiyypMfpsYz
         11EM+YAxQWKHidSXxqigA9UXaTlzmlT5vqXF9lKavWpXZPzQmy1iQxsKKCC/CN6+lDaI
         in79LpkqyLJWruosf+GiwUhTNhjGHG5aD50uSY6j8tKdrXHpTh8m4V90KIXKC+0telWQ
         LRUoS7FvixiekIDUQSQPGhhYFCreQHEA+6nfeGvmPhsvtWb7xzEB1vxsffzh9+AM9eCT
         MNGQ==
X-Gm-Message-State: ACrzQf16LyWeCKMPetNzTI2vEW3Zg3oPezbgo6UONIjDrOY5OgSUDkvA
        We9rF5lYQHvtutoxAlObWTiiwUlX2JcA7w==
X-Google-Smtp-Source: AMsMyM66KLH3yXhQf1WGFA8wXaMs+RlBpXmfGyKsiH1ejjEA5fUSplb+c2cRmWGIYbu9/1gNyDHzaA==
X-Received: by 2002:ac8:4e4f:0:b0:39c:e080:3643 with SMTP id e15-20020ac84e4f000000b0039ce0803643mr27954535qtw.426.1666623570029;
        Mon, 24 Oct 2022 07:59:30 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id cq13-20020a05622a424d00b003972790deb9sm32320qtb.84.2022.10.24.07.59.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 07:59:29 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id y72so11261489yby.13;
        Mon, 24 Oct 2022 07:59:29 -0700 (PDT)
X-Received: by 2002:a25:26c1:0:b0:6c3:bdae:c6d6 with SMTP id
 m184-20020a2526c1000000b006c3bdaec6d6mr30854658ybm.36.1666623568821; Mon, 24
 Oct 2022 07:59:28 -0700 (PDT)
MIME-Version: 1.0
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com> <20221022104357.1276740-7-biju.das.jz@bp.renesas.com>
In-Reply-To: <20221022104357.1276740-7-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Oct 2022 16:59:17 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV8MmTMMPnCGgXbZZ-gb4CVduAUBBG3BdAecBrc3J7RLQ@mail.gmail.com>
Message-ID: <CAMuHMdV8MmTMMPnCGgXbZZ-gb4CVduAUBBG3BdAecBrc3J7RLQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] can: rcar_canfd: Add has_gerfl_eef to struct rcar_canfd_hw_info
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

Hi Biju,

On Sat, Oct 22, 2022 at 1:03 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> R-Car has ECC error flags in global error interrupts whereas it is
> not available on RZ/G2L.
>
> Add has_gerfl_eef to struct rcar_canfd_hw_info so that rcar_canfd_
> global_error() will process ECC errors only for R-Car.
>
> whilst, this patch fixes the below checkpatch warnings
>   CHECK: Unnecessary parentheses around 'ch == 0'
>   CHECK: Unnecessary parentheses around 'ch == 1'
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -523,6 +523,7 @@ struct rcar_canfd_hw_info {
>         unsigned multi_global_irqs:1;   /* Has multiple global irqs  */
>         unsigned clk_postdiv:1;         /* Has CAN clk post divider  */
>         unsigned multi_channel_irqs:1;  /* Has multiple channel irqs  */
> +       unsigned has_gerfl_eef:1;       /* Has ECC Error Flag  */

Do you really need this flag? According to the RZ/G2L docs, the
corresponding register bits are always read as zero.

>  };
>
>  /* Channel priv data */

> @@ -947,17 +950,18 @@ static void rcar_canfd_global_error(struct net_device *ndev)
>  {
>         struct rcar_canfd_channel *priv = netdev_priv(ndev);
>         struct rcar_canfd_global *gpriv = priv->gpriv;
> +       const struct rcar_canfd_hw_info *info = gpriv->info;
>         struct net_device_stats *stats = &ndev->stats;
>         u32 ch = priv->channel;
>         u32 gerfl, sts;
>         u32 ridx = ch + RCANFD_RFFIFO_IDX;
>
>         gerfl = rcar_canfd_read(priv->base, RCANFD_GERFL);
> -       if ((gerfl & RCANFD_GERFL_EEF0) && (ch == 0)) {
> +       if (info->has_gerfl_eef && (gerfl & RCANFD_GERFL_EEF0) && ch == 0) {
>                 netdev_dbg(ndev, "Ch0: ECC Error flag\n");
>                 stats->tx_dropped++;
>         }
> -       if ((gerfl & RCANFD_GERFL_EEF1) && (ch == 1)) {
> +       if (info->has_gerfl_eef && (gerfl & RCANFD_GERFL_EEF1) && ch == 1) {
>                 netdev_dbg(ndev, "Ch1: ECC Error flag\n");
>                 stats->tx_dropped++;
>         }

Just wrap both checks inside a single "if (gpriv->info->has_gerfl) { ... }"?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
