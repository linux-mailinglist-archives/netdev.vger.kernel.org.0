Return-Path: <netdev+bounces-4095-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 052FB70AD2C
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 11:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C02DC1C2095C
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 09:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A789810EF;
	Sun, 21 May 2023 09:16:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5C710E8
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 09:16:30 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D21CF;
	Sun, 21 May 2023 02:16:29 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso2035527b3a.0;
        Sun, 21 May 2023 02:16:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684660589; x=1687252589;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KHIw7JGPsQWr9sfK8pf8whE7OIvCqL302ZlVYFFtHzk=;
        b=EiW9f9bmO+FQZAhkkEdXsP0FA6mIbNTWvEGhFr2kB4sD99zUkNN7lyQbOpuwbScjG3
         zSFXUJA4TFGMW/7huhnZLpxeCCdG96a2qSWtL1qlcjduDJ09MfEOzvHben+qNgh6ir+u
         duIGog8SMBniaHmTTWMJWzMogQ4RMmHDWnC9fDpBPwvfDD47fSjN6O4Kse2uqkgTnibr
         0Z6agHRJ++fXEVv3JYeo8CPg9DBkhQceqZUlrqcQIWcXJz/oXMxaJi1DYNEZRVqMh5sG
         OC6US2nZh9l3vsXkxClOSG71lhpebjVgXxZGEK7RiWhhIYLt0ZTsemxxtetZt3o22j0j
         OO3w==
X-Gm-Message-State: AC+VfDzfCM9XHZcQvnL3e6RhIRcHkaWQ0NLwJK/Xybo3tkjDnDmfH8xv
	pnMFRbotdyGKPsJAPNxhPgI7nAeTZLN34QXXIrI=
X-Google-Smtp-Source: ACHHUZ7fMKxiJ2y7Pl6IaCFH5VD2rbG7Utn6oWaSJg1ig0JcRvWSsDnrtoHdJRGRAB8R2iYVskFm0yRWjjJQ5utYPoY=
X-Received: by 2002:a05:6a20:e615:b0:102:2de7:ee1d with SMTP id
 my21-20020a056a20e61500b001022de7ee1dmr7751637pzb.6.1684660588725; Sun, 21
 May 2023 02:16:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230519195600.420644-1-frank.jungclaus@esd.eu> <20230519195600.420644-3-frank.jungclaus@esd.eu>
In-Reply-To: <20230519195600.420644-3-frank.jungclaus@esd.eu>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Sun, 21 May 2023 18:16:17 +0900
Message-ID: <CAMZ6RqL-2qB=kLPd84rWHd3=xPcspSNXvNYpR9Fyx+4-Ft16gQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] can: esd_usb: Replace initializer macros used for
 struct can_bittiming_const
To: Frank Jungclaus <frank.jungclaus@esd.eu>
Cc: linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>, 
	Wolfgang Grandegger <wg@grandegger.com>, =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thanks for the patch.

On Sat. 20 May 2023 at 04:57, Frank Jungclaus <frank.jungclaus@esd.eu> wrote:
> Replace the macros used to initialize the members of struct
> can_bittiming_const with direct values. Then also use those struct
> members to do the calculations in esd_usb2_set_bittiming().
>
> Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDFmqpd++aBzZQg@mail.gmail.com/
> Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> ---
>  drivers/net/can/usb/esd_usb.c | 33 +++++++++++++--------------------
>  1 file changed, 13 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> index 32354cfdf151..2eecf352ec47 100644
> --- a/drivers/net/can/usb/esd_usb.c
> +++ b/drivers/net/can/usb/esd_usb.c
> @@ -60,18 +60,10 @@ MODULE_LICENSE("GPL v2");
>  #define ESD_USB_NO_BAUDRATE    GENMASK(30, 0) /* bit rate unconfigured */
>
>  /* bit timing CAN-USB/2 */
> -#define ESD_USB2_TSEG1_MIN     1
> -#define ESD_USB2_TSEG1_MAX     16
>  #define ESD_USB2_TSEG1_SHIFT   16
> -#define ESD_USB2_TSEG2_MIN     1
> -#define ESD_USB2_TSEG2_MAX     8
>  #define ESD_USB2_TSEG2_SHIFT   20
> -#define ESD_USB2_SJW_MAX       4
>  #define ESD_USB2_SJW_SHIFT     14
>  #define ESD_USBM_SJW_SHIFT     24
> -#define ESD_USB2_BRP_MIN       1
> -#define ESD_USB2_BRP_MAX       1024
> -#define ESD_USB2_BRP_INC       1
>  #define ESD_USB2_3_SAMPLES     BIT(23)
>
>  /* esd IDADD message */
> @@ -909,19 +901,20 @@ static const struct ethtool_ops esd_usb_ethtool_ops = {
>
>  static const struct can_bittiming_const esd_usb2_bittiming_const = {
>         .name = "esd_usb2",
> -       .tseg1_min = ESD_USB2_TSEG1_MIN,
> -       .tseg1_max = ESD_USB2_TSEG1_MAX,
> -       .tseg2_min = ESD_USB2_TSEG2_MIN,
> -       .tseg2_max = ESD_USB2_TSEG2_MAX,
> -       .sjw_max = ESD_USB2_SJW_MAX,
> -       .brp_min = ESD_USB2_BRP_MIN,
> -       .brp_max = ESD_USB2_BRP_MAX,
> -       .brp_inc = ESD_USB2_BRP_INC,
> +       .tseg1_min = 1,
> +       .tseg1_max = 16,
> +       .tseg2_min = 1,
> +       .tseg2_max = 8,
> +       .sjw_max = 4,
> +       .brp_min = 1,
> +       .brp_max = 1024,
> +       .brp_inc = 1,
>  };
>
>  static int esd_usb2_set_bittiming(struct net_device *netdev)
>  {
>         struct esd_usb_net_priv *priv = netdev_priv(netdev);
> +       const struct can_bittiming_const *btc = priv->can.bittiming_const;

I initially suggested doing:

          const struct can_bittiming_const *btc = priv->can.bittiming_const;

But now that I think again about it, doing:

          const struct can_bittiming_const *btc = &esd_usb2_bittiming_const;

is slightly better as it will allow the compiler to fold the integer
constant expressions such as btc->brp_max - 1. The compiler is not
smart enough to figure out what values are held in
priv->can.bittiming_const at compile time.

Sorry for not figuring this the first time.

>         struct can_bittiming *bt = &priv->can.bittiming;
>         union esd_usb_msg *msg;
>         int err;
> @@ -932,7 +925,7 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
>         if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
>                 canbtr |= ESD_USB_LOM;
>
> -       canbtr |= (bt->brp - 1) & (ESD_USB2_BRP_MAX - 1);
> +       canbtr |= (bt->brp - 1) & (btc->brp_max - 1);
>
>         if (le16_to_cpu(priv->usb->udev->descriptor.idProduct) ==
>             USB_CANUSBM_PRODUCT_ID)
> @@ -940,12 +933,12 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
>         else
>                 sjw_shift = ESD_USB2_SJW_SHIFT;
>
> -       canbtr |= ((bt->sjw - 1) & (ESD_USB2_SJW_MAX - 1))
> +       canbtr |= ((bt->sjw - 1) & (btc->sjw_max - 1))
>                 << sjw_shift;
>         canbtr |= ((bt->prop_seg + bt->phase_seg1 - 1)
> -                  & (ESD_USB2_TSEG1_MAX - 1))
> +                  & (btc->tseg1_max - 1))
>                 << ESD_USB2_TSEG1_SHIFT;
> -       canbtr |= ((bt->phase_seg2 - 1) & (ESD_USB2_TSEG2_MAX - 1))
> +       canbtr |= ((bt->phase_seg2 - 1) & (btc->tseg2_max - 1))
>                 << ESD_USB2_TSEG2_SHIFT;
>         if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
>                 canbtr |= ESD_USB2_3_SAMPLES;
> --
> 2.25.1
>

