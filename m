Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724716C46B8
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjCVJmb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Mar 2023 05:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjCVJm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:42:27 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62245BD94;
        Wed, 22 Mar 2023 02:42:25 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id i15so6665805pfo.8;
        Wed, 22 Mar 2023 02:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679478145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhZUtTtMRX3iHKSkNc847opMuxtybiEK1qLunXYiYUg=;
        b=zcNJ+eVs8nEDLyQlYr1Dc3lIF/xLuMbS5fGXHBpWTy66GJv6XReMEnpCEqhAKsUKVF
         FwjZvs4td0HJLTnUldItZ//0GAmtTd4DSbse0VqNK5TpqmdvQP9rvXjhuMMW7TNbXEXK
         6FbL6SK9M8NKERlhMkuFa5Xjxds7BN7839U4aCPNLBCjg+9fMeRFeCtpoGdyEZn8e/wm
         71S9w+qY3diNekbTc4PGYz1/JDrRobRWRYpc3yJCq0SLMCtmoZlMd2/7vrL3gN421mJU
         886ubgHzDDW254ziKTS3sUmqUtxn6Fi+rtPasR/I3PMfoG45V2u7FqwB3bG7Yp30KMnf
         8/cg==
X-Gm-Message-State: AO0yUKXYZLNNQ3GAc7rYtFR6WhUf9DoJ6W0py+cfB4VZR6AyTqcFzDOg
        1UAERPGYtssL7dzDMVKpH5weT0fdd4+ljp74Aig=
X-Google-Smtp-Source: AK7set8tTSoGJeYe9Juyd5/U1PJ1GRZCIYADXwoDW4axal2mDpbqDwLspDVA+ZWO0YRlKoX7aMnpZWiCV4VachuvlWc=
X-Received: by 2002:a05:6a00:174c:b0:628:123c:99be with SMTP id
 j12-20020a056a00174c00b00628123c99bemr1453184pfc.2.1679478144816; Wed, 22 Mar
 2023 02:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1679414936.git.geert+renesas@glider.be> <4162cc46f72257ec191007675933985b6df394b9.1679414936.git.geert+renesas@glider.be>
In-Reply-To: <4162cc46f72257ec191007675933985b6df394b9.1679414936.git.geert+renesas@glider.be>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 22 Mar 2023 18:42:13 +0900
Message-ID: <CAMZ6Rq+KxHxT_vm1rVW0Q6UZpfKo=63mmgn5pSwn40M-Dke9PA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] can: rcar_canfd: Improve error messages
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 22 Mar 2023 à 01:26, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> Improve printed error messages:
>   - Replace numerical error codes by mnemotechnic error codes, to
>     improve the user experience in case of errors,
>   - Drop parentheses around printed numbers, cfr.
>     Documentation/process/coding-style.rst,
>   - Drop printing of an error message in case of out-of-memory, as the
>     core memory allocation code already takes care of this.
>
> Suggested-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

I added a nitpick. If you prefer to keep as-is, OK for me.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

> ---
> v4:
>   - Reviewed-by: Simon Horman <simon.horman@corigine.com>,
>
> v3:
>   - Add missing SoB,
>
> v2:
>   - This is v2 of "[PATCH] can: rcar_canfd: Print mnemotechnic error
>     codes".  I haven't added any tags given on v1, as half of the
>     printed message changed.
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 43 +++++++++++++++----------------
>  1 file changed, 21 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
> index 6df9a259e5e4f92c..ecdb8ffe2f670c9b 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -1417,20 +1417,20 @@ static int rcar_canfd_open(struct net_device *ndev)
>
>         err = phy_power_on(priv->transceiver);
>         if (err) {
> -               netdev_err(ndev, "failed to power on PHY, error %d\n", err);
> +               netdev_err(ndev, "failed to power on PHY, %pe\n", ERR_PTR(err));
                                                          ^

Nitpick, consider a colon instead of the coma:

                 netdev_err(ndev, "failed to power on PHY: %pe\n",
ERR_PTR(err));

N.B. This is more a personal preference than an official Linux style.
If you prefer the coma, you can ignore my nitpick and keep it as it is
:)

>                 return err;
>         }
>
>         /* Peripheral clock is already enabled in probe */
>         err = clk_prepare_enable(gpriv->can_clk);
>         if (err) {
> -               netdev_err(ndev, "failed to enable CAN clock, error %d\n", err);
> +               netdev_err(ndev, "failed to enable CAN clock, %pe\n", ERR_PTR(err));
>                 goto out_phy;
>         }
>
>         err = open_candev(ndev);
>         if (err) {
> -               netdev_err(ndev, "open_candev() failed, error %d\n", err);
> +               netdev_err(ndev, "open_candev() failed, %pe\n", ERR_PTR(err));
>                 goto out_can_clock;
>         }
>
> @@ -1731,10 +1731,9 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>         int err = -ENODEV;
>
>         ndev = alloc_candev(sizeof(*priv), RCANFD_FIFO_DEPTH);
> -       if (!ndev) {
> -               dev_err(dev, "alloc_candev() failed\n");
> +       if (!ndev)
>                 return -ENOMEM;
> -       }
> +
>         priv = netdev_priv(ndev);
>
>         ndev->netdev_ops = &rcar_canfd_netdev_ops;
> @@ -1777,8 +1776,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>                                        rcar_canfd_channel_err_interrupt, 0,
>                                        irq_name, priv);
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq CH Err(%d) failed, error %d\n",
> -                               err_irq, err);
> +                       dev_err(dev, "devm_request_irq CH Err %d failed, %pe\n",
> +                               err_irq, ERR_PTR(err));
>                         goto fail;
>                 }
>                 irq_name = devm_kasprintf(dev, GFP_KERNEL, "canfd.ch%d_trx",
> @@ -1791,8 +1790,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>                                        rcar_canfd_channel_tx_interrupt, 0,
>                                        irq_name, priv);
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq Tx (%d) failed, error %d\n",
> -                               tx_irq, err);
> +                       dev_err(dev, "devm_request_irq Tx %d failed, %pe\n",
> +                               tx_irq, ERR_PTR(err));
>                         goto fail;
>                 }
>         }
> @@ -1823,7 +1822,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>         gpriv->ch[priv->channel] = priv;
>         err = register_candev(ndev);
>         if (err) {
> -               dev_err(dev, "register_candev() failed, error %d\n", err);
> +               dev_err(dev, "register_candev() failed, %pe\n", ERR_PTR(err));
>                 goto fail_candev;
>         }
>         dev_info(dev, "device registered (channel %u)\n", priv->channel);
> @@ -1967,16 +1966,16 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>                                        rcar_canfd_channel_interrupt, 0,
>                                        "canfd.ch_int", gpriv);
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
> -                               ch_irq, err);
> +                       dev_err(dev, "devm_request_irq %d failed, %pe\n",
> +                               ch_irq, ERR_PTR(err));
>                         goto fail_dev;
>                 }
>
>                 err = devm_request_irq(dev, g_irq, rcar_canfd_global_interrupt,
>                                        0, "canfd.g_int", gpriv);
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
> -                               g_irq, err);
> +                       dev_err(dev, "devm_request_irq %d failed, %pe\n",
> +                               g_irq, ERR_PTR(err));
>                         goto fail_dev;
>                 }
>         } else {
> @@ -1985,8 +1984,8 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>                                        "canfd.g_recc", gpriv);
>
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
> -                               g_recc_irq, err);
> +                       dev_err(dev, "devm_request_irq %d failed, %pe\n",
> +                               g_recc_irq, ERR_PTR(err));
>                         goto fail_dev;
>                 }
>
> @@ -1994,8 +1993,8 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>                                        rcar_canfd_global_err_interrupt, 0,
>                                        "canfd.g_err", gpriv);
>                 if (err) {
> -                       dev_err(dev, "devm_request_irq(%d) failed, error %d\n",
> -                               g_err_irq, err);
> +                       dev_err(dev, "devm_request_irq %d failed, %pe\n",
> +                               g_err_irq, ERR_PTR(err));
>                         goto fail_dev;
>                 }
>         }
> @@ -2012,14 +2011,14 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>         /* Enable peripheral clock for register access */
>         err = clk_prepare_enable(gpriv->clkp);
>         if (err) {
> -               dev_err(dev, "failed to enable peripheral clock, error %d\n",
> -                       err);
> +               dev_err(dev, "failed to enable peripheral clock, %pe\n",
> +                       ERR_PTR(err));
>                 goto fail_reset;
>         }
>
>         err = rcar_canfd_reset_controller(gpriv);
>         if (err) {
> -               dev_err(dev, "reset controller failed\n");
> +               dev_err(dev, "reset controller failed, %pe\n", ERR_PTR(err));
>                 goto fail_clk;
>         }
>
> --
> 2.34.1
>
