Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793016B0D6C
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 16:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjCHPxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 10:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCHPxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 10:53:24 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FA45B41C;
        Wed,  8 Mar 2023 07:53:23 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id u5so18050655plq.7;
        Wed, 08 Mar 2023 07:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678290802;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ERPte+GLfYGNUQKc38j5roO9NGI1HxeNMKiYrmWUlXw=;
        b=qaMwRlCwSijTyKp3Ko45Pr5e8WKRVmkg/VTmJlMslvXucCm7TcC7q5uBeHcvROo4T4
         mVqn6u+V19tLzdRFgpoNgRnXAzMghGpstb89cnPX/T1yUSMSfaC80QlhBSrW2v1hP3/W
         zAQ6MGDFFC1QCXWjRs55AZAGLn8rcjRaSAC467+4lqSZfNethlMm7ExrsuYJ3dHPk/Gc
         QkFXXT47F+BpP54zGO6qc4X/OkVsZXg+ZSck7Rha718WDhabAhyF7IWL7GOyxKqsjy9U
         6KpYDc8JIy5hJoDMvP0sU32j84h5U4vzTihT4RVpzJ+sBTlYa/EpyQ3RtS5g6jDv17KZ
         Hjqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678290802;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ERPte+GLfYGNUQKc38j5roO9NGI1HxeNMKiYrmWUlXw=;
        b=vPuBZVhUqPVz6Teoeb6gl6v43mTnvxyPZBnV7cvL5NxG1zTvvhtXtKL+xrGYEQlvLp
         UR6oTj/0N6q+kJyM+Z9/zZPYgYY4XMyFHK8QBGTC1hvkJfm9poINhp24wcHFTRa0F9Kz
         qlzTyRqrwvz4aUFEek7WPkKqJBcaPXSXcLpqGngU1wT8Esp6Z0TRRtPU5PBMcdCksMRD
         o4ltATYoVwb3BPMXegzsCdyfe0Jd5CYW2B9pywrKpBgKnCXiI+JQfme4KIGaWG9s64xX
         82pfNXXOGnA1Ai1bIsHsaw0adh8cV5hfP8CnQDh4G6DWe+hB2v5I4KWRdrr8L30DUx8x
         /erA==
X-Gm-Message-State: AO0yUKXcM2sOE7004c5tBrTub/sTctXkbJdH7vZ0Zar1UU3znTlZyADu
        ulF8JfqwloFSBJBers04IKx33iuv3pPr8fFjpK0On97YphM=
X-Google-Smtp-Source: AK7set80cozO5AtE2fAewN604E9TLifg4kLOn5BU89f5fABOnEqXgZCcTCaIPHQoguw0Ky62vebKUUJgaXViBHeJ+Uo=
X-Received: by 2002:a17:902:f812:b0:19c:140d:aad7 with SMTP id
 ix18-20020a170902f81200b0019c140daad7mr7175448plb.4.1678290802552; Wed, 08
 Mar 2023 07:53:22 -0800 (PST)
MIME-Version: 1.0
References: <e825b50a843ffe40e33f34e4d858c07c1b2ff259.1678280913.git.geert+renesas@glider.be>
In-Reply-To: <e825b50a843ffe40e33f34e4d858c07c1b2ff259.1678280913.git.geert+renesas@glider.be>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Thu, 9 Mar 2023 00:53:11 +0900
Message-ID: <CAMZ6RqJ-3fyLFMjuyq4euNB-1sz0sBU5YswMeRduXO4TJ1QmLw@mail.gmail.com>
Subject: Re: [PATCH v2] can: rcar_canfd: Add transceiver support
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 8 Mar. 2023 at 22:20, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Add support for CAN transceivers described as PHYs.
>
> While simple CAN transceivers can do without, this is needed for CAN
> transceivers like NXP TJR1443 that need a configuration step (like
> pulling standby or enable lines), and/or impose a bitrate limit.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

I have one nitpick (see below). Aside from that:
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

> ---
> v2:
>   - Add Reviewed-by.
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
> index ef4e1b9a9e1ee280..6df9a259e5e4f92c 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -35,6 +35,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
>  #include <linux/reset.h>
>  #include <linux/types.h>
> @@ -530,6 +531,7 @@ struct rcar_canfd_channel {
>         struct net_device *ndev;
>         struct rcar_canfd_global *gpriv;        /* Controller reference */
>         void __iomem *base;                     /* Register base address */
> +       struct phy *transceiver;                /* Optional transceiver */
>         struct napi_struct napi;
>         u32 tx_head;                            /* Incremented on xmit */
>         u32 tx_tail;                            /* Incremented on xmit done */
> @@ -1413,11 +1415,17 @@ static int rcar_canfd_open(struct net_device *ndev)
>         struct rcar_canfd_global *gpriv = priv->gpriv;
>         int err;
>
> +       err = phy_power_on(priv->transceiver);
> +       if (err) {
> +               netdev_err(ndev, "failed to power on PHY, error %d\n", err);
> +               return err;
> +       }
> +
>         /* Peripheral clock is already enabled in probe */
>         err = clk_prepare_enable(gpriv->can_clk);
>         if (err) {
>                 netdev_err(ndev, "failed to enable CAN clock, error %d\n", err);
                                                                      ^^

Nitpick: can you print the mnemotechnic instead of the error value?

                netdev_err(ndev, "failed to enable CAN clock, error
%pe\n", ERR_PTR(err));

> -               goto out_clock;
> +               goto out_phy;
>         }
>
>         err = open_candev(ndev);
> @@ -1437,7 +1445,8 @@ static int rcar_canfd_open(struct net_device *ndev)
>         close_candev(ndev);
>  out_can_clock:
>         clk_disable_unprepare(gpriv->can_clk);
> -out_clock:
> +out_phy:
> +       phy_power_off(priv->transceiver);
>         return err;
>  }
>
> @@ -1480,6 +1489,7 @@ static int rcar_canfd_close(struct net_device *ndev)
>         napi_disable(&priv->napi);
>         clk_disable_unprepare(gpriv->can_clk);
>         close_candev(ndev);
> +       phy_power_off(priv->transceiver);
>         return 0;
>  }
>
> @@ -1711,7 +1721,7 @@ static const struct ethtool_ops rcar_canfd_ethtool_ops = {
>  };
>
>  static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
> -                                   u32 fcan_freq)
> +                                   u32 fcan_freq, struct phy *transceiver)
>  {
>         const struct rcar_canfd_hw_info *info = gpriv->info;
>         struct platform_device *pdev = gpriv->pdev;
> @@ -1732,8 +1742,11 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
>         ndev->flags |= IFF_ECHO;
>         priv->ndev = ndev;
>         priv->base = gpriv->base;
> +       priv->transceiver = transceiver;
>         priv->channel = ch;
>         priv->gpriv = gpriv;
> +       if (transceiver)
> +               priv->can.bitrate_max = transceiver->attrs.max_link_rate;
>         priv->can.clock.freq = fcan_freq;
>         dev_info(dev, "can_clk rate is %u\n", priv->can.clock.freq);
>
> @@ -1836,6 +1849,7 @@ static void rcar_canfd_channel_remove(struct rcar_canfd_global *gpriv, u32 ch)
>
>  static int rcar_canfd_probe(struct platform_device *pdev)
>  {
> +       struct phy *transceivers[RCANFD_NUM_CHANNELS] = { 0, };
>         const struct rcar_canfd_hw_info *info;
>         struct device *dev = &pdev->dev;
>         void __iomem *addr;
> @@ -1857,9 +1871,14 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>         for (i = 0; i < info->max_channels; ++i) {
>                 name[7] = '0' + i;
>                 of_child = of_get_child_by_name(dev->of_node, name);
> -               if (of_child && of_device_is_available(of_child))
> +               if (of_child && of_device_is_available(of_child)) {
>                         channels_mask |= BIT(i);
> +                       transceivers[i] = devm_of_phy_optional_get(dev,
> +                                                       of_child, NULL);
> +               }
>                 of_node_put(of_child);
> +               if (IS_ERR(transceivers[i]))
> +                       return PTR_ERR(transceivers[i]);
>         }
>
>         if (info->shared_global_irqs) {
> @@ -2035,7 +2054,8 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>         }
>
>         for_each_set_bit(ch, &gpriv->channels_mask, info->max_channels) {
> -               err = rcar_canfd_channel_probe(gpriv, ch, fcan_freq);
> +               err = rcar_canfd_channel_probe(gpriv, ch, fcan_freq,
> +                                              transceivers[ch]);
>                 if (err)
>                         goto fail_channel;
>         }
> --
> 2.34.1
>
