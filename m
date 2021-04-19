Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3710363D66
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 10:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbhDSIVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 04:21:00 -0400
Received: from mail-vs1-f51.google.com ([209.85.217.51]:38652 "EHLO
        mail-vs1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhDSIU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 04:20:56 -0400
Received: by mail-vs1-f51.google.com with SMTP id s184so6761409vss.5;
        Mon, 19 Apr 2021 01:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ltv54OOOgcKhPoH7oRaigoXMRi+Z2QqH7bQ4dTNkEvU=;
        b=Ms0SsPF9J+tPj990DTLxJSvXO3Pmul5WCyeOMIDCVJ6fXcWAb6uJsC52eqzmbxUtMJ
         Ul7GxKCbZ7tvkEEqDB5miyVfuIPIZ6Wf2fLEOnYrnyzAq9BFRVgE5tawuQnZZ1KvmiLL
         EF/Qi81vkqZN75KRE3I2Ub033NMXNbhyaWlBPnaDUI/smGHJ8UPy9vAoTfFqPZVmpcjG
         u+1xfNjeAWaCtnBNzLs677wnayVF3agzAGavKRFiZLiJM0DQwfElLwqOkGkNXKPR+lsq
         TJLnDZHeX994hG8+Gw6qi4xtQrZg2dB0UisZo4zpBSW648ZZkTOPfDD7+avHhtZh59RH
         iISg==
X-Gm-Message-State: AOAM531bR0AI7GyosdsIXdtavR8bqUCmY3mDWUO7awITMHICVomqNNgB
        TnOox77RR3JpNHchfmmIyY7YFvqX5Aujc9OIMxU=
X-Google-Smtp-Source: ABdhPJw0QI7XOFx1TPnFrXWAlR/QW1v6zaWS/KnYbAtB/CEX2DsVVO2yNBv9r1VAA3kWmuOXuQwF2fQGH/J1go6B4oc=
X-Received: by 2002:a67:f503:: with SMTP id u3mr12373252vsn.3.1618820424835;
 Mon, 19 Apr 2021 01:20:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210419042722.27554-1-alice.guo@oss.nxp.com> <20210419042722.27554-2-alice.guo@oss.nxp.com>
In-Reply-To: <20210419042722.27554-2-alice.guo@oss.nxp.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 19 Apr 2021 10:20:13 +0200
Message-ID: <CAMuHMdUbrPxtJ9DCP0_nFrReuuO4vFY2J79LrKY82D7bCOfzRw@mail.gmail.com>
Subject: Re: [RFC v1 PATCH 1/3] drivers: soc: add support for soc_device_match
 returning -EPROBE_DEFER
To:     "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
Cc:     gregkh@linuxfoundation.org, rafael@kernel.org,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, tony@atomide.com,
        geert+renesas@glider.be, mturquette@baylibre.com, sboyd@kernel.org,
        vkoul@kernel.org, peter.ujfalusi@gmail.com, a.hajda@samsung.com,
        narmstrong@baylibre.com, robert.foss@linaro.org, airlied@linux.ie,
        daniel@ffwll.ch, khilman@baylibre.com, tomba@kernel.org,
        jyri.sarha@iki.fi, joro@8bytes.org, will@kernel.org,
        mchehab@kernel.org, ulf.hansson@linaro.org,
        adrian.hunter@intel.com, kishon@ti.com, kuba@kernel.org,
        linus.walleij@linaro.org, Roy.Pledge@nxp.com, leoyang.li@nxp.com,
        ssantosh@kernel.org, matthias.bgg@gmail.com, edubezval@gmail.com,
        j-keerthy@ti.com, balbi@kernel.org, linux@prisktech.co.nz,
        stern@rowland.harvard.edu, wim@linux-watchdog.org,
        linux@roeck-us.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-staging@lists.linux.dev,
        linux-mediatek@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alice,

CC Arnd (soc_device_match() author)

On Mon, Apr 19, 2021 at 6:28 AM Alice Guo (OSS) <alice.guo@oss.nxp.com> wrote:
> From: Alice Guo <alice.guo@nxp.com>
>
> In i.MX8M boards, the registration of SoC device is later than caam
> driver which needs it. Caam driver needs soc_device_match to provide
> -EPROBE_DEFER when no SoC device is registered and no
> early_soc_dev_attr.

I'm wondering if this is really a good idea: soc_device_match() is a
last-resort low-level check, and IMHO should be made available early on,
so there is no need for -EPROBE_DEFER.

>
> Signed-off-by: Alice Guo <alice.guo@nxp.com>

Thanks for your patch!

> --- a/drivers/base/soc.c
> +++ b/drivers/base/soc.c
> @@ -110,6 +110,7 @@ static void soc_release(struct device *dev)
>  }
>
>  static struct soc_device_attribute *early_soc_dev_attr;
> +static bool soc_dev_attr_init_done = false;

Do you need this variable?

>
>  struct soc_device *soc_device_register(struct soc_device_attribute *soc_dev_attr)
>  {
> @@ -157,6 +158,7 @@ struct soc_device *soc_device_register(struct soc_device_attribute *soc_dev_attr
>                 return ERR_PTR(ret);
>         }
>
> +       soc_dev_attr_init_done = true;
>         return soc_dev;
>
>  out3:
> @@ -246,6 +248,9 @@ const struct soc_device_attribute *soc_device_match(
>         if (!matches)
>                 return NULL;
>
> +       if (!soc_dev_attr_init_done && !early_soc_dev_attr)

if (!soc_bus_type.p && !early_soc_dev_attr)

> +               return ERR_PTR(-EPROBE_DEFER);
> +
>         while (!ret) {
>                 if (!(matches->machine || matches->family ||
>                       matches->revision || matches->soc_id))

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
