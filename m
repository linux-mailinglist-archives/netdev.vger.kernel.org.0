Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2174E56516B
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbiGDJzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiGDJzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:55:07 -0400
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854DDDEA4;
        Mon,  4 Jul 2022 02:55:06 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id l11so15909795ybu.13;
        Mon, 04 Jul 2022 02:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qiAOeDd02KCwRxop5BcVi801h68pbKkqNWQWg7cA2XA=;
        b=iV1Jlg/K9s4uWWldlpzhcMVTNx7UkkBkxW3E+LdCbtQV8POfQoCublV01gg6MxVHpM
         ZJrhIlmkKqX4EIKnMFEZW6oEBijEuNo0HwJWHovySu5RvCmbEs9gk4c60FoByCzZ1WZt
         W8+WvyM2U6r24ajkefPfFKULaNfBxtb9QnbczP/tyv/Qy5CtCFxIKBdz5EJVooovpaKf
         9SkXB38lNs7pzPMY+EegUhxWngLlLiNB4bNdRp3jzXHbPLfPKkFSeU+KHwpxrwcqXtBL
         8T4/ohc2pq0AZAMAzboL0CGXGKL7JRIgkZlaijZb1XuEltSHGJhHqK46ufAhCx7xzaBF
         P4GQ==
X-Gm-Message-State: AJIora+YUEbQlxxPsFehIWY2QVAz3aV+SJAeAHwbYxBj+v/Lc5Xcie7k
        dKaFhMYeaipAmp1Mb/Lj11Qps8yzm9/LWrmnxxU=
X-Google-Smtp-Source: AGRyM1tdWHftRuodpqw5nFQTrouLh5EhATjgxCSNc2ZsrXegndnEhhwr4M0M5Cn0n08MB66Pc1lhhussY1MavazIXXA=
X-Received: by 2002:a25:b74a:0:b0:66a:775d:a257 with SMTP id
 e10-20020a25b74a000000b0066a775da257mr30253834ybm.381.1656928505755; Mon, 04
 Jul 2022 02:55:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220704075032.383700-1-biju.das.jz@bp.renesas.com> <20220704075032.383700-4-biju.das.jz@bp.renesas.com>
In-Reply-To: <20220704075032.383700-4-biju.das.jz@bp.renesas.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 4 Jul 2022 18:54:54 +0900
Message-ID: <CAMZ6RqLr=eO_LFRtoDcd0eOr_JyX8eTJwsnqtg_veO_wNBN8Eg@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] can: sja1000: Add Quirk for RZ/N1 SJA1000 CAN controller
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Biju,

I gave a quick look to your series. Nothing odd to me, I just have a
single nitpick.

On Mon. 4 juil. 2022 at 16:51, Biju Das <biju.das.jz@bp.renesas.com> wrote:
> As per Chapter 6.5.16 of the RZ/N1 Peripheral Manual, The SJA1000
> CAN controller does not support Clock Divider Register compared to
> the reference Philips SJA1000 device.
>
> This patch adds a device quirk to handle this difference.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v2->v3:
>  * No Change
> v1->v2:
>  * Updated commit description
>  * Removed the quirk macro SJA1000_NO_HW_LOOPBACK_QUIRK
>  * Added prefix SJA1000_QUIRK_* for quirk macro.
> ---
>  drivers/net/can/sja1000/sja1000.c | 13 ++++++++-----
>  drivers/net/can/sja1000/sja1000.h |  3 ++-
>  2 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
> index 2e7638f98cf1..e9c55f5aa3c3 100644
> --- a/drivers/net/can/sja1000/sja1000.c
> +++ b/drivers/net/can/sja1000/sja1000.c
> @@ -183,8 +183,9 @@ static void chipset_init(struct net_device *dev)
>  {
>         struct sja1000_priv *priv = netdev_priv(dev);
>
> -       /* set clock divider and output control register */
> -       priv->write_reg(priv, SJA1000_CDR, priv->cdr | CDR_PELICAN);
> +       if (!(priv->flags & SJA1000_QUIRK_NO_CDR_REG))
> +               /* set clock divider and output control register */
> +               priv->write_reg(priv, SJA1000_CDR, priv->cdr | CDR_PELICAN);
>
>         /* set acceptance filter (accept all) */
>         priv->write_reg(priv, SJA1000_ACCC0, 0x00);
> @@ -208,9 +209,11 @@ static void sja1000_start(struct net_device *dev)
>         if (priv->can.state != CAN_STATE_STOPPED)
>                 set_reset_mode(dev);
>
> -       /* Initialize chip if uninitialized at this stage */
> -       if (!(priv->read_reg(priv, SJA1000_CDR) & CDR_PELICAN))
> -               chipset_init(dev);
> +       if (!(priv->flags & SJA1000_QUIRK_NO_CDR_REG)) {
> +               /* Initialize chip if uninitialized at this stage */
> +               if (!(priv->read_reg(priv, SJA1000_CDR) & CDR_PELICAN))

You can combine the two if in one:

|        /* Initialize chip if uninitialized at this stage */
|        if (!(priv->flags & SJA1000_QUIRK_NO_CDR_REG ||
|              priv->read_reg(priv, SJA1000_CDR) & CDR_PELICAN))
|                chipset_init(dev);

> +                       chipset_init(dev);
> +       }
>
>         /* Clear error counters and error code capture */
>         priv->write_reg(priv, SJA1000_TXERR, 0x0);
> diff --git a/drivers/net/can/sja1000/sja1000.h b/drivers/net/can/sja1000/sja1000.h
> index 9d46398f8154..7f736f1df547 100644
> --- a/drivers/net/can/sja1000/sja1000.h
> +++ b/drivers/net/can/sja1000/sja1000.h
> @@ -145,7 +145,8 @@
>  /*
>   * Flags for sja1000priv.flags
>   */
> -#define SJA1000_CUSTOM_IRQ_HANDLER 0x1
> +#define SJA1000_CUSTOM_IRQ_HANDLER     BIT(0)
> +#define SJA1000_QUIRK_NO_CDR_REG       BIT(1)
>
>  /*
>   * SJA1000 private data structure
