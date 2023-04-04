Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FFC6D6B4F
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 20:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbjDDSQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 14:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbjDDSQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 14:16:29 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28B1AC;
        Tue,  4 Apr 2023 11:16:28 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 6-20020a9d0106000000b006a177038dfeso8628453otu.7;
        Tue, 04 Apr 2023 11:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680632188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wj8PXWAmTuOXHq3ZdjGm6iKJRw+n67Yim1cKc3MwFow=;
        b=FlgWiyhWS/Z62YgiwwEcy45OhWJk0ZAdHGvpJGysbxqW22WQZTxAppbXURImKGC4R8
         xt+gZVb/frQ9B4pEDRzV7JPXRT2fYjljZ9DNKDYr0ykr1kM4WbXbH5dwaMDUbbBT+J9/
         BWxmQZJE0DQU90WOuaWN+4eTkgwFLc+AZ8BXnxL2ji+ig6FWc48wTyl2NxxIeev++oNn
         qbrs36Xq7Tgcler19P4pVW8YOfBpN4rQZih9Qs+G1iYmTmIBbIgEAUmbyXeqq/vlcP4Z
         TQT+YqqVhqd1aOrmcsthZYrv9HYjoZWh1h1lGryTjrMo9x61FE0cGxlHj8evka1S5drW
         Qs5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wj8PXWAmTuOXHq3ZdjGm6iKJRw+n67Yim1cKc3MwFow=;
        b=w0qze1ylDLUiI1fHudWAb8+uUoUNLoXLlvdoGUX1kk2+H+WuYAVvUHIcSFKSy/m2qx
         ea0bfdCNjWl6eOp5ewk7TFFl2EV58c4pNBwAoLpUFXnDr0mZyRW+/HvTRr0r8nHPmXGk
         WxyoVLqkmB9TOnrby6jhAjr27fa0QPtF/f4OVXfzzQHA/PxiSK90SGMMD+O5ZjNBdluB
         B/Jo63v1YLg+M9WYnOEDMmEsNp6GkMTRbgKVRDVqknEC2orL112K8bRSms78czsfupp+
         KKzG7xA8CtAAfqzvN3cPb08+iI4GavJLudASDZnL721jxf9uwTgInq+kWnDIvUGCkMGL
         TL/g==
X-Gm-Message-State: AAQBX9fuX0qYgJu1qLk6MyfqSgdMhlFZTbH3a2GQPa+2Gu4FHQsMKpXR
        qwSaTiRz5lQPmfXYp++Yg0BNT8qkZthdkyu3N6CKvlbb
X-Google-Smtp-Source: AKy350YTQR9oKSWUCxtq2io1+IEGnkpVqtgOnuCgcswdh9HwLc51x/aKAnYsX2t1Si7lgsXOacEEiNEiB0BjGrF2XaI=
X-Received: by 2002:a9d:6a5a:0:b0:69f:8fa8:1a4f with SMTP id
 h26-20020a9d6a5a000000b0069f8fa81a4fmr1180132otn.2.1680632187890; Tue, 04 Apr
 2023 11:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
 <20230403202440.276757-10-martin.blumenstingl@googlemail.com> <642c609d.050a0220.46d72.9a10@mx.google.com>
In-Reply-To: <642c609d.050a0220.46d72.9a10@mx.google.com>
From:   Chris Morgan <macroalpha82@gmail.com>
Date:   Tue, 4 Apr 2023 13:16:16 -0500
Message-ID: <CADcbR4LMY3BF_aNZ-gAWsvYHnRjV=qgWW_qmJhH339L_NgmqUQ@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] wifi: rtw88: Add support for the SDIO based
 RTL8821CS chipset
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please disregard. I was building against linux main not wireless-next.
I have tested and it appears to be working well, even suspend works now.

On Tue, Apr 4, 2023 at 12:38=E2=80=AFPM Chris Morgan <macroalpha82@gmail.co=
m> wrote:
>
> On Mon, Apr 03, 2023 at 10:24:40PM +0200, Martin Blumenstingl wrote:
> > Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
> > well as the existing RTL8821C chipset code.
> >
> > Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > ---
>
> Unfortunately this version isn't working for me currently. When I try
> to probe the driver I get an error of "mac power on failed". After some
> debugging it looks like there are some SDIO bits in the
> rtw_pwr_seq_parser() function that are missing, causing it to return
> -EINVAL. I tried to add those specific bits back based on your latest
> github, but then I get additonal errors like "failed to read efuse map"
> and other errors. I'm wondering if there are bits that might be missing
> for the rtl8821cs in this revision.
>
> Thank you,
> Chris Morgan.
>
> > Changes since v3:
> > - add Ping-Ke's reviewed-by
> >
> > Changes since v2:
> > - sort includes alphabetically as suggested by Ping-Ke
> > - add missing #include "main.h" (after it has been removed from sdio.h
> >   in patch 2 from this series)
> >
> > Changes since v1:
> > - use /* ... */ style for copyright comments
> >
> >
> >  drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
> >  drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
> >  .../net/wireless/realtek/rtw88/rtw8821cs.c    | 36 +++++++++++++++++++
> >  3 files changed, 50 insertions(+)
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/w=
ireless/realtek/rtw88/Kconfig
> > index 6b65da81127f..29eb2f8e0eb7 100644
> > --- a/drivers/net/wireless/realtek/rtw88/Kconfig
> > +++ b/drivers/net/wireless/realtek/rtw88/Kconfig
> > @@ -133,6 +133,17 @@ config RTW88_8821CE
> >
> >         802.11ac PCIe wireless network adapter
> >
> > +config RTW88_8821CS
> > +     tristate "Realtek 8821CS SDIO wireless network adapter"
> > +     depends on MMC
> > +     select RTW88_CORE
> > +     select RTW88_SDIO
> > +     select RTW88_8821C
> > +     help
> > +       Select this option will enable support for 8821CS chipset
> > +
> > +       802.11ac SDIO wireless network adapter
> > +
> >  config RTW88_8821CU
> >       tristate "Realtek 8821CU USB wireless network adapter"
> >       depends on USB
> > diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/=
wireless/realtek/rtw88/Makefile
> > index 6105c2745bda..82979b30ae8d 100644
> > --- a/drivers/net/wireless/realtek/rtw88/Makefile
> > +++ b/drivers/net/wireless/realtek/rtw88/Makefile
> > @@ -59,6 +59,9 @@ rtw88_8821c-objs            :=3D rtw8821c.o rtw8821c_=
table.o
> >  obj-$(CONFIG_RTW88_8821CE)   +=3D rtw88_8821ce.o
> >  rtw88_8821ce-objs            :=3D rtw8821ce.o
> >
> > +obj-$(CONFIG_RTW88_8821CS)   +=3D rtw88_8821cs.o
> > +rtw88_8821cs-objs            :=3D rtw8821cs.o
> > +
> >  obj-$(CONFIG_RTW88_8821CU)   +=3D rtw88_8821cu.o
> >  rtw88_8821cu-objs            :=3D rtw8821cu.o
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821cs.c b/drivers/n=
et/wireless/realtek/rtw88/rtw8821cs.c
> > new file mode 100644
> > index 000000000000..a359413369a4
> > --- /dev/null
> > +++ b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> > @@ -0,0 +1,36 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> > +/* Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.co=
m>
> > + */
> > +
> > +#include <linux/mmc/sdio_func.h>
> > +#include <linux/mmc/sdio_ids.h>
> > +#include <linux/module.h>
> > +#include "main.h"
> > +#include "rtw8821c.h"
> > +#include "sdio.h"
> > +
> > +static const struct sdio_device_id rtw_8821cs_id_table[] =3D  {
> > +     {
> > +             SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK,
> > +                         SDIO_DEVICE_ID_REALTEK_RTW8821CS),
> > +             .driver_data =3D (kernel_ulong_t)&rtw8821c_hw_spec,
> > +     },
> > +     {}
> > +};
> > +MODULE_DEVICE_TABLE(sdio, rtw_8821cs_id_table);
> > +
> > +static struct sdio_driver rtw_8821cs_driver =3D {
> > +     .name =3D "rtw_8821cs",
> > +     .probe =3D rtw_sdio_probe,
> > +     .remove =3D rtw_sdio_remove,
> > +     .id_table =3D rtw_8821cs_id_table,
> > +     .drv =3D {
> > +             .pm =3D &rtw_sdio_pm_ops,
> > +             .shutdown =3D rtw_sdio_shutdown,
> > +     }
> > +};
> > +module_sdio_driver(rtw_8821cs_driver);
> > +
> > +MODULE_AUTHOR("Martin Blumenstingl <martin.blumenstingl@googlemail.com=
>");
> > +MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821cs driver");
> > +MODULE_LICENSE("Dual BSD/GPL");
