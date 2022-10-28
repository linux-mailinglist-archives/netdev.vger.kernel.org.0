Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674B3610E2A
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiJ1KM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiJ1KMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:12:49 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8401B94CD;
        Fri, 28 Oct 2022 03:12:37 -0700 (PDT)
Received: by mail-qt1-f182.google.com with SMTP id bb5so3145564qtb.11;
        Fri, 28 Oct 2022 03:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sU7n8RJWrq05LFsyEviqLSOQlXMl11rcYr5H7H+djyc=;
        b=ReubLRcsxFKSXBxFHHlLxGgbzMb5XyNiK6Fri/z19X+5INwbB0nZ9AeSIVCZkV2SVV
         p3ICg6ys09H7lcj9zAZmMtkNI5/J8yx/aMnn7lpOGs9/Ih3RTfdMv2E/C9kT4P6s8xxy
         fydEKQbFSaWWEmmelqdw7BgkkRZD0DaEPvOuVtirYAx5JHBHqZ69l3DCC9wMkSjYmzFi
         5jfbcftTOt1MBOTNeDkMWcO3K7SDN0Ht8NkhpWesi3Iy4ZTioL0AWJVxYopbphj8C43H
         DbgQKReP8XZDa7F/4gTp6SJ4e1PU9FVnTFfbq7bPb2TVJ9r/Vx5GFIjjJmGHhPujqlxe
         Kc7Q==
X-Gm-Message-State: ACrzQf05zSmG4ADqWxHwqvpDL3SwrbMCwsFadU67Jb7JSfjI8ZSdLvD+
        FLF9kjwhHafRDyXztPX/VybpETsY8JLF1A==
X-Google-Smtp-Source: AMsMyM5WNRRinlhCoCk2Mg97aUBchru0VrWr5lxTx+c/pjygly4nlQOnFdLhDUNgjem4B1+pVmT2tw==
X-Received: by 2002:a05:622a:15c8:b0:39c:ea8a:82e3 with SMTP id d8-20020a05622a15c800b0039cea8a82e3mr44826081qty.146.1666951956581;
        Fri, 28 Oct 2022 03:12:36 -0700 (PDT)
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com. [209.85.128.172])
        by smtp.gmail.com with ESMTPSA id r9-20020a05620a298900b006b61b2cb1d2sm2711138qkp.46.2022.10.28.03.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 03:12:36 -0700 (PDT)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-367b8adf788so43122527b3.2;
        Fri, 28 Oct 2022 03:12:36 -0700 (PDT)
X-Received: by 2002:a81:ad09:0:b0:370:5b7:bef2 with SMTP id
 l9-20020a81ad09000000b0037005b7bef2mr6275336ywh.47.1666951955775; Fri, 28 Oct
 2022 03:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <20221027082158.95895-1-biju.das.jz@bp.renesas.com> <20221027082158.95895-7-biju.das.jz@bp.renesas.com>
In-Reply-To: <20221027082158.95895-7-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 28 Oct 2022 12:12:22 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXayck0o9=Oc2+X7pDSx=Y+SHHdi3QtmYz+U-rumpc92Q@mail.gmail.com>
Message-ID: <CAMuHMdXayck0o9=Oc2+X7pDSx=Y+SHHdi3QtmYz+U-rumpc92Q@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] can: rcar_canfd: Add has_gerfl_eef to struct rcar_canfd_hw_info
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

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -955,13 +958,15 @@ static void rcar_canfd_global_error(struct net_device *ndev)
>         u32 ridx = ch + RCANFD_RFFIFO_IDX;
>
>         gerfl = rcar_canfd_read(priv->base, RCANFD_GERFL);
> -       if ((gerfl & RCANFD_GERFL_EEF0) && (ch == 0)) {
> -               netdev_dbg(ndev, "Ch0: ECC Error flag\n");
> -               stats->tx_dropped++;
> -       }
> -       if ((gerfl & RCANFD_GERFL_EEF1) && (ch == 1)) {
> -               netdev_dbg(ndev, "Ch1: ECC Error flag\n");
> -               stats->tx_dropped++;
> +       if (gpriv->info->has_gerfl_eef) {
> +               if ((gerfl & RCANFD_GERFL_EEF0) && ch == 0) {
> +                       netdev_dbg(ndev, "Ch0: ECC Error flag\n");
> +                       stats->tx_dropped++;
> +               }
> +               if ((gerfl & RCANFD_GERFL_EEF1) && ch == 1) {
> +                       netdev_dbg(ndev, "Ch1: ECC Error flag\n");
> +                       stats->tx_dropped++;
> +               }

BTW, this fails to check the ECC error flags for channels 2-7 on R-Car
V3U, which is a pre-existing problem.  As that is a bug, I have sent
a fix[1], which unfortunately conflicts with your patch. Sorry for that.

>         }
>         if (gerfl & RCANFD_GERFL_MES) {
>                 sts = rcar_canfd_read(priv->base,

[1] "[PATCH] can: rcar_canfd: Add missing ECC error checks for channels 2-7"
    https://lore.kernel.org/r/4edb2ea46cc64d0532a08a924179827481e14b4f.1666951503.git.geert+renesas@glider.be

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
