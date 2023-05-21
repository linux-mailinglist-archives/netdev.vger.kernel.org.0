Return-Path: <netdev+bounces-4094-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C4C370AD28
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 11:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 391F21C20959
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 09:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE5810EF;
	Sun, 21 May 2023 09:16:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F27510E8
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 09:16:27 +0000 (UTC)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E11CF;
	Sun, 21 May 2023 02:16:25 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-52867360efcso3377189a12.2;
        Sun, 21 May 2023 02:16:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684660585; x=1687252585;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Es75wE1TSD9/bxpBEraTqQGgh/2Yg3IpDVhaSa9N/Z8=;
        b=XkIYN9rgpERLMyhUOV+cMWlBUHjQYm7Rdx/JmysPFfsdpTNlN5ukWx0I61lv0b3V+o
         w/HqWt/6p86P9dd4oqboAbbX1HY9ZKPhlINmtYM04lh4UIaaP4ESQuwn/Y9wdXVGDfqA
         UKULTNS9Sm9r82MzzLJlep0ImpntZSYXRgmgbU+2sNk7BIgWQKh786CJBsWEWh3AgI1/
         vCLyQ1ASJIkJnFxY6gzhF7QFAUCuuHdUsHNo3NOTTNiOmXtif1cvGzpmDSnYSHWSLXeM
         L9rxXchfZYdr22kfWlfSB7zx2Og5+chK+bejy5WFi9Od3nbMI3vWkvDLEMlkQ8/vmw50
         fVDA==
X-Gm-Message-State: AC+VfDz/TyYeyQUlVEpq1huA07GhhvrAeKPLbk71foecoc+N5flJ7MMC
	rmsCIHltnBMUXSqZuHwj2dndTeTyfQh4U/QNd8g=
X-Google-Smtp-Source: ACHHUZ6xvmdUQ7UA8O/mJrSNvBDBD+JdVbnKgQYo2ZkCX5YaJgRtWvqNbFTWz7AM32S8Xrul2lID3OzeJEPgNIy1rPI=
X-Received: by 2002:a17:90a:9cf:b0:250:bb6:47ed with SMTP id
 73-20020a17090a09cf00b002500bb647edmr6796360pjo.33.1684660584928; Sun, 21 May
 2023 02:16:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230519195600.420644-1-frank.jungclaus@esd.eu> <20230519195600.420644-2-frank.jungclaus@esd.eu>
In-Reply-To: <20230519195600.420644-2-frank.jungclaus@esd.eu>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Sun, 21 May 2023 18:16:13 +0900
Message-ID: <CAMZ6Rq+V4HRLa2bzADnsvaKHuCwi6O5jKo39mhon_+OnMDEJbQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] can: esd_usb: Make use of existing kernel macros
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
> Make use of existing kernel macros:
> - Use the unit suffixes from linux/units.h for the controller clock
> frequencies
> - Use the BIT() and the GENMASK() macro to set specific bits in some
>   constants
> - Use CAN_MAX_DLEN (instead of directly using the value 8) for the
> maximum CAN payload length
>
> Additionally:
> - Spend some commenting for the previously changed constants
> - Add the current year to the copyright notice
> - While adding the header linux/units.h to the list of include files
> also sort that list alphabetically
>
> Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
> Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDFmqpd++aBzZQg@mail.gmail.com/
> Link: https://lore.kernel.org/all/CAMZ6RqKdg5YBufa0C+ttzJvoG=9yuti-8AmthCi4jBbd08JEtw@mail.gmail.com/
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Link: https://lore.kernel.org/all/20230518-grower-film-ea8b5f853f3e-mkl@pengutronix.de/
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> ---
>  drivers/net/can/usb/esd_usb.c | 40 ++++++++++++++++++-----------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> index d33bac3a6c10..32354cfdf151 100644
> --- a/drivers/net/can/usb/esd_usb.c
> +++ b/drivers/net/can/usb/esd_usb.c
> @@ -3,19 +3,20 @@
>   * CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro
>   *
>   * Copyright (C) 2010-2012 esd electronic system design gmbh, Matthias Fuchs <socketcan@esd.eu>
> - * Copyright (C) 2022 esd electronics gmbh, Frank Jungclaus <frank.jungclaus@esd.eu>
> + * Copyright (C) 2022-2023 esd electronics gmbh, Frank Jungclaus <frank.jungclaus@esd.eu>
>   */
> +#include <linux/can.h>
> +#include <linux/can/dev.h>
> +#include <linux/can/error.h>
> +
>  #include <linux/ethtool.h>
> -#include <linux/signal.h>
> -#include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
> +#include <linux/signal.h>
> +#include <linux/slab.h>
> +#include <linux/units.h>
>  #include <linux/usb.h>
>
> -#include <linux/can.h>
> -#include <linux/can/dev.h>
> -#include <linux/can/error.h>
> -
>  MODULE_AUTHOR("Matthias Fuchs <socketcan@esd.eu>");
>  MODULE_AUTHOR("Frank Jungclaus <frank.jungclaus@esd.eu>");
>  MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro interfaces");
> @@ -27,8 +28,8 @@ MODULE_LICENSE("GPL v2");
>  #define USB_CANUSBM_PRODUCT_ID 0x0011
>
>  /* CAN controller clock frequencies */
> -#define ESD_USB2_CAN_CLOCK     60000000
> -#define ESD_USBM_CAN_CLOCK     36000000
> +#define ESD_USB2_CAN_CLOCK     (60 * MEGA) /* Hz */
> +#define ESD_USBM_CAN_CLOCK     (36 * MEGA) /* Hz */
>
>  /* Maximum number of CAN nets */
>  #define ESD_USB_MAX_NETS       2
> @@ -42,20 +43,21 @@ MODULE_LICENSE("GPL v2");
>  #define CMD_IDADD              6 /* also used for IDADD_REPLY */
>
>  /* esd CAN message flags - dlc field */
> -#define ESD_RTR                        0x10
> +#define ESD_RTR        BIT(4)
> +
>
>  /* esd CAN message flags - id field */
> -#define ESD_EXTID              0x20000000
> -#define ESD_EVENT              0x40000000
> -#define ESD_IDMASK             0x1fffffff
> +#define ESD_EXTID      BIT(29)
> +#define ESD_EVENT      BIT(30)
> +#define ESD_IDMASK     GENMASK(28, 0)
>
>  /* esd CAN event ids */
>  #define ESD_EV_CAN_ERROR_EXT   2 /* CAN controller specific diagnostic data */
>
>  /* baudrate message flags */
> -#define ESD_USB_UBR            0x80000000
> -#define ESD_USB_LOM            0x40000000
> -#define ESD_USB_NO_BAUDRATE    0x7fffffff
> +#define ESD_USB_LOM    BIT(30) /* 0x40000000, Listen Only Mode */
> +#define ESD_USB_UBR    BIT(31) /* 0x80000000, User Bit Rate (controller BTR) in bits 0..27 */
                                     ^^^^^^^^^^

As pointented by Marc, no need for redundant comment with the hexadecimal value.

> +#define ESD_USB_NO_BAUDRATE    GENMASK(30, 0) /* bit rate unconfigured */
>
>  /* bit timing CAN-USB/2 */
>  #define ESD_USB2_TSEG1_MIN     1
> @@ -70,7 +72,7 @@ MODULE_LICENSE("GPL v2");
>  #define ESD_USB2_BRP_MIN       1
>  #define ESD_USB2_BRP_MAX       1024
>  #define ESD_USB2_BRP_INC       1
> -#define ESD_USB2_3_SAMPLES     0x00800000
> +#define ESD_USB2_3_SAMPLES     BIT(23)
>
>  /* esd IDADD message */
>  #define ESD_ID_ENABLE          0x80
> @@ -128,7 +130,7 @@ struct rx_msg {
>         __le32 ts;
>         __le32 id; /* upper 3 bits contain flags */
>         union {
> -               u8 data[8];
> +               u8 data[CAN_MAX_DLEN];
>                 struct {
>                         u8 status; /* CAN Controller Status */
>                         u8 ecc;    /* Error Capture Register */
> @@ -145,7 +147,7 @@ struct tx_msg {
>         u8 dlc;
>         u32 hnd;        /* opaque handle, not used by device */
>         __le32 id; /* upper 3 bits contain flags */
> -       u8 data[8];
> +       u8 data[CAN_MAX_DLEN];
>  };
>
>  struct tx_done_msg {
> --
> 2.25.1
>

