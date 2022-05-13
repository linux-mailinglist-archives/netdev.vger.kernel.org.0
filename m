Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6400952595B
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 03:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376306AbiEMBYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 21:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352238AbiEMBYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 21:24:21 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E4F5468A;
        Thu, 12 May 2022 18:24:18 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2f7c57ee6feso75856857b3.2;
        Thu, 12 May 2022 18:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n6FjrnvCK2Re1ZT/L6LoW1fbg7qWZwjX3yuF4qzb42s=;
        b=PYszdDos7XwDKhxXFWDOdB2ZNMd0E4WRDf5qZHDiwaGGzkYYhLumNRzbZD6Npdalu1
         D8FLDcReyqjl4jVsbL4vgyN4GjZuu2S8Et/8eGuExuAJnxk/lwheJ++C4b2KY+az3xRs
         TurhsS+rym3qtBeJRndX/arJfTqMXSazhvt5fvnYSLEFUHwvLpYf4cV4y4UtkOx2KpoP
         HyTH0djK8nQTNusKMQbnuraSoAQ3UQrTdobdryiDw5H5gKb2eSh6Quk+aUcZKQZ08d4o
         RwuMu+Ce1hb8jAGhrp5t7JAiSEAfGzW8BY2eCWuebLXdpbrNSmz6IWxiIqP96ZpE9hVO
         v2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n6FjrnvCK2Re1ZT/L6LoW1fbg7qWZwjX3yuF4qzb42s=;
        b=vLpS0rKQVAj2ONtBIGpkC/lFva+AQCbyRC2kKCSdperKfQmrgRAEdDzOOaldfHhJwa
         TXUmNrRo5wcuWjGbj51cuWC3S+i18fV6N8Ct6Eevd+jtNWc+o0luLoq0S+t2bYDcWdye
         EvgW/oYy7Gd+mZCA5m/ISbdmcQnRErzwLexmefRn3OfE9aIuehWV8R0Gk68gTXLrmn+6
         ZS1x4/rpo1BqmyVI7mTJn+44QuqLZ8N9RZViATAiGw06ZwFe61iURDMoHtFBI+BETBMg
         W8ptb5zYLhRTrY95JbGSgSIU1bT8nYyW7JoQIzIlNMDXj+cRweI9eASIVqwPkpZeEz3m
         HATg==
X-Gm-Message-State: AOAM5332xoZD2u4fiQo3QmP3E6PvnZbyKNu04X1Pvh5Z2OwyKgHQjCOA
        719BDMLTP3TAMxklotgkBRlo059RS1WFkWD/TJM=
X-Google-Smtp-Source: ABdhPJy74fAs696VKs+XfZzSEt2KCMLWfUB9gsmKtVuBSOT4J9RBmZeP8+JWiOG8ISeYZOFvOcC0SteZLL/3jH2DdeA=
X-Received: by 2002:a81:1948:0:b0:2f7:cf75:2517 with SMTP id
 69-20020a811948000000b002f7cf752517mr3146144ywz.392.1652405057311; Thu, 12
 May 2022 18:24:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220512135901.1377087-1-srinivas.neeli@xilinx.com>
In-Reply-To: <20220512135901.1377087-1-srinivas.neeli@xilinx.com>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Fri, 13 May 2022 10:24:06 +0900
Message-ID: <CAMZ6Rq+z69CTY6Ec0n9d0-ri6pcyHtKH917M1eTD6hgkmyvGDQ@mail.gmail.com>
Subject: Re: [PATCH] can: xilinx_can: Add Transmitter delay compensation (TDC)
 feature support
To:     Srinivas Neeli <srinivas.neeli@xilinx.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, appana.durga.rao@xilinx.com, sgoud@xilinx.com,
        michal.simek@xilinx.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 13 May 2022 at 07:30, Srinivas Neeli <srinivas.neeli@xilinx.com> wrote:
> Added Transmitter delay compensation (TDC) feature support.
> In the case of higher measured loop delay with higher baud rates, observed
> bit stuff errors.
> By enabling the TDC feature in a controller, will compensate for
> the measure loop delay in the receive path.
> TDC feature requires BRP values can be 1 or 2.
> The current CAN framework does not limit the brp so while using TDC,
> have to restrict BRP values.
> Ex:
> ip link set can0 type can tq 12 prop-seg 39 phase-seg1 20 phase-seg2 20
> sjw 20 dtq 12 dprop-seg 5 dphase-seg1 6 dphase-seg2 4 dsjw 4 fd on
> loopback on tdco 12 tdc-mode auto

Did you experience some cases in which you had BRP > 2 and saw
transmission errors due to the absence of delay compensation? Could
you show the calculated values?
Usually, you start to observe but stuff error at high bitrates (e.g.
~5MBPS), and for such bitrates, time quanta has to be small which then
results in a small BRP.

> Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
> ---
>  drivers/net/can/xilinx_can.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> index e2b15d29d15e..7af518fbed02 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-or-later
>  /* Xilinx CAN device driver
>   *
> - * Copyright (C) 2012 - 2014 Xilinx, Inc.
> + * Copyright (C) 2012 - 2022 Xilinx, Inc.
>   * Copyright (C) 2009 PetaLogix. All rights reserved.
>   * Copyright (C) 2017 - 2018 Sandvik Mining and Construction Oy
>   *
> @@ -133,6 +133,8 @@ enum xcan_reg {
>  #define XCAN_DLCR_BRS_MASK             0x04000000 /* BRS Mask in DLC */
>
>  /* CAN register bit shift - XCAN_<REG>_<BIT>_SHIFT */
> +#define XCAN_BRPR_TDCO_SHIFT_CANFD     8  /* Transmitter Delay Compensation Offset */

Having CANFD in the name is redundant (TDC implies CANFD).
#define XCAN_BRPR_TDCO_SHIFT 8

> +#define XCAN_BRPR_TDCE_SHIFT_CANFD     16 /* Transmitter Delay Compensation (TDC) Enable */

Why not:
#define XCAN_BRPR_TDC_ENABLE BIT(16)

>  #define XCAN_BTR_SJW_SHIFT             7  /* Synchronous jump width */
>  #define XCAN_BTR_TS2_SHIFT             4  /* Time segment 2 */
>  #define XCAN_BTR_SJW_SHIFT_CANFD       16 /* Synchronous jump width */
> @@ -259,7 +261,7 @@ static const struct can_bittiming_const xcan_bittiming_const_canfd2 = {
>         .tseg2_min = 1,
>         .tseg2_max = 128,
>         .sjw_max = 128,
> -       .brp_min = 2,
> +       .brp_min = 1,

Was there any reason to have brp_min = 2 in the first place?
I think this change  should be a different patch. If the brp_min = 2
is just a typo, you might also want to backport it to stable branches.

>         .brp_max = 256,
>         .brp_inc = 1,
>  };
> @@ -272,11 +274,21 @@ static struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
>         .tseg2_min = 1,
>         .tseg2_max = 16,
>         .sjw_max = 16,
> -       .brp_min = 2,
> +       .brp_min = 1,
>         .brp_max = 256,
>         .brp_inc = 1,
>  };
>
> +/* Transmission Delay Compensation constants for CANFD2.0 and Versal  */
> +static const struct can_tdc_const xcan_tdc_const = {
> +       .tdcv_min = 0,
> +       .tdcv_max = 0, /* Manual mode not supported. */

Right, had a look at the datasheet and xilinx indeed does not support
setting TDCV.
However, xilinx still has a TDCV register to report the measured
transmission delay.

Socket CAN's TDC framework provides can_priv::do_get_auto_tdcv() to
report the measured value through the netlink interface:
https://elixir.bootlin.com/linux/v5.17/source/include/linux/can/dev.h#L87

Can you implement this call back function?

> +       .tdco_min = 0,
> +       .tdco_max = 64,
> +       .tdcf_min = 0, /* Filter window not supported */
> +       .tdcf_max = 0,
> +};
> +
>  /**
>   * xcan_write_reg_le - Write a value to the device register little endian
>   * @priv:      Driver private data structure
> @@ -425,6 +437,11 @@ static int xcan_set_bittiming(struct net_device *ndev)
>             priv->devtype.cantype == XAXI_CANFD_2_0) {
>                 /* Setting Baud Rate prescalar value in F_BRPR Register */
>                 btr0 = dbt->brp - 1;
> +               if (can_tdc_is_enabled(&priv->can)) {
> +                       btr0 = btr0 |
> +                       (priv->can.tdc.tdco) << XCAN_BRPR_TDCO_SHIFT_CANFD |
> +                       1 << XCAN_BRPR_TDCE_SHIFT_CANFD;

I don't think the parenthesis around (priv->can.tdc.tdco) are needed.

                       btr0 = btr0 |
                       priv->can.tdc.tdco << XCAN_BRPR_TDCO_SHIFT |
                      XCAN_BRPR_TDC_ENABLE

(c.f. above for macro names)

> +               }
>
>                 /* Setting Time Segment 1 in BTR Register */
>                 btr1 = dbt->prop_seg + dbt->phase_seg1 - 1;
> @@ -1747,13 +1764,16 @@ static int xcan_probe(struct platform_device *pdev)
>                 priv->can.data_bittiming_const =
>                         &xcan_data_bittiming_const_canfd;
>
> -       if (devtype->cantype == XAXI_CANFD_2_0)
> +       if (devtype->cantype == XAXI_CANFD_2_0) {
>                 priv->can.data_bittiming_const =
>                         &xcan_data_bittiming_const_canfd2;
> +               priv->can.tdc_const = &xcan_tdc_const;
> +       }
>
>         if (devtype->cantype == XAXI_CANFD ||
>             devtype->cantype == XAXI_CANFD_2_0)
> -               priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
> +               priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
> +                                               CAN_CTRLMODE_TDC_AUTO;
>
>         priv->reg_base = addr;
>         priv->tx_max = tx_max;
> --
> 2.25.1
>
