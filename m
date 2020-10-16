Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50111290408
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 13:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406523AbgJPLbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 07:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406353AbgJPLbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 07:31:09 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A634C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 04:31:09 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id n141so540073vke.9
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 04:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VfR2k3sQxdqJVPvkLHgRVDpnfd48L/sAbfIZJJQVUGU=;
        b=U3arh0PpNKrL1ViPiMAT0p2E0sl1OdJBhyvUHT4isXu6+XcRLSALuWaqK3qkJaGkEy
         t8bLEKQge3lIp5OeEMAmTMP3eHUZOfzzoYTvA+hKG5gzjJ6jBJwXNnuAODzY7/gqLhDg
         pprH6HvpZvmUmEi3fYOlqSuW8lbgPlNp2+o8TswEl5CIop61UyNKvxY/My5zTTEmkTL7
         wn7UUyyNWiq7oamyFJrfUF8XrsQme69ZI9KAaHUTjCnMWs6AcYLhu3MzDdEDy0r1G8ki
         SwesbK5trA8dGyyUxob6ItDYO0XA4TU9d9EUSvSHSmSxKVk3Jb3n/Z9s606yVsheLKJl
         +YBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VfR2k3sQxdqJVPvkLHgRVDpnfd48L/sAbfIZJJQVUGU=;
        b=Zcz9edpWjGzqZVx8iHMGhjtXc+VUo979LYR1VIupYYxzJlWwyRSL6D42j756sN/kKH
         lT7uIY9K7uaGTAYMgkPdqfIDO+T+ihGhr3MzNmPGAe3A+jh4xuJgkC3FIIUjNy3iVBVb
         cKYOOi480D5T2kkNGTpZ3Qzf6gbHVP6yCmLXA4q9CyOuGGy3zzEQTVD5G1kkFKtsU1GD
         7TN67XxrmK7i+LZt34w7WwuOAuzZ1FetTermPv7K2iWuctbmbAm/ykQ1nx6Pxsqsn9Hs
         O9yaY4OFU1JUUfNCtXBjaUJ2TklHAqhQspUZ1tQHX2m6n3fdsfW0q++k8Wxe7LpaYqDL
         ERtg==
X-Gm-Message-State: AOAM533hohmuVe6NfAaiMEhEDXWdZtPH9SY/3oM+pKSPXsRD7iHyhuPE
        dMSVJnFNF6uUlNJE2s8+9eOYU5eWljyccFZdc3eBDg==
X-Google-Smtp-Source: ABdhPJxYAVqNSgwSx1Eoge43VUADHeCK6li9b/4u8o1NT7/3wN77SDJYFQCZnpPpHiOo14iB/Ng7q8JPB3TjsN9qSbg=
X-Received: by 2002:a1f:ae85:: with SMTP id x127mr1798903vke.8.1602847868573;
 Fri, 16 Oct 2020 04:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com> <20201012104648.985256-8-Jerome.Pouiller@silabs.com>
In-Reply-To: <20201012104648.985256-8-Jerome.Pouiller@silabs.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 16 Oct 2020 13:30:30 +0200
Message-ID: <CAPDyKFpP6xBru79Xh2oe=J8HWO3uk1VpcMzEiG6X7WX-AOvgkA@mail.gmail.com>
Subject: Re: [PATCH 07/23] wfx: add bus_sdio.c
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 at 12:47, Jerome Pouiller
<Jerome.Pouiller@silabs.com> wrote:
>
> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>

Please fill out this commit message to explain a bit more about the
patch and the HW it enables support for.

>
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/net/wireless/silabs/wfx/bus_sdio.c | 269 +++++++++++++++++++++
>  1 file changed, 269 insertions(+)
>  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
>
> diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c b/drivers/net/wir=
eless/silabs/wfx/bus_sdio.c
> new file mode 100644
> index 000000000000..e06d7e1ebe9c

[...]

> +
> +static int wfx_sdio_irq_subscribe(void *priv)
> +{
> +       struct wfx_sdio_priv *bus =3D priv;
> +       u32 flags;
> +       int ret;
> +       u8 cccr;
> +

I would appreciate a comment about an out-of-band IRQ line. If it's
supported, that is the preferred option to use, else the SDIO IRQs.

> +       if (!bus->of_irq) {
> +               sdio_claim_host(bus->func);
> +               ret =3D sdio_claim_irq(bus->func, wfx_sdio_irq_handler);
> +               sdio_release_host(bus->func);
> +               return ret;
> +       }
> +
> +       sdio_claim_host(bus->func);
> +       cccr =3D sdio_f0_readb(bus->func, SDIO_CCCR_IENx, NULL);
> +       cccr |=3D BIT(0);
> +       cccr |=3D BIT(bus->func->num);
> +       sdio_f0_writeb(bus->func, cccr, SDIO_CCCR_IENx, NULL);
> +       sdio_release_host(bus->func);
> +       flags =3D irq_get_trigger_type(bus->of_irq);
> +       if (!flags)
> +               flags =3D IRQF_TRIGGER_HIGH;
> +       flags |=3D IRQF_ONESHOT;
> +       return devm_request_threaded_irq(&bus->func->dev, bus->of_irq, NU=
LL,
> +                                        wfx_sdio_irq_handler_ext, flags,
> +                                        "wfx", bus);
> +}
> +

[...]

> +
> +#define SDIO_VENDOR_ID_SILABS        0x0000
> +#define SDIO_DEVICE_ID_SILABS_WF200  0x1000
> +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> +       { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200)=
 },
> +       // FIXME: ignore VID/PID and only rely on device tree
> +       // { SDIO_DEVICE(SDIO_ANY_ID, SDIO_ANY_ID) },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);

I will comment about the sdio IDs separately, replying to the other
thread between you and Pali.

> +
> +struct sdio_driver wfx_sdio_driver =3D {
> +       .name =3D "wfx-sdio",
> +       .id_table =3D wfx_sdio_ids,
> +       .probe =3D wfx_sdio_probe,
> +       .remove =3D wfx_sdio_remove,
> +       .drv =3D {
> +               .owner =3D THIS_MODULE,
> +               .of_match_table =3D wfx_sdio_of_match,
> +       }
> +};

I couldn't find where you call sdio_register|unregister_driver(), but
maybe that's done from another patch in series?

Kind regards
Uffe
