Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA6520E62E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403935AbgF2VpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgF2Sho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:37:44 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CCCC00F827
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:46:51 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id r5so9116524vso.11
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=verdurent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3mjyd6r9Z8NRgSnG+P9PSoNzsHa0OVoXa5dJDxRkCYk=;
        b=UI0fGaRCmq5A6fZ2aN3n8WBb3g7VvOCURSeOI/vJzfqMe8q0IkabtA9TAG27ldXDI4
         z+qW6f7rvAAhml7TWg3s6TCc3UwBj8qbwNL/MoBsGqaL93xt/lMkkNwHR7FZDnRdUe26
         IJTGZwp8wFrDid5i4wCANbEQxqmks/buB/LqOLygjOkSAS569gUFnJm1iu7wSqU6J4mi
         WaUPsQa5oFkBDxtSoUnrhRPFtXhTMn7YFowZMtA/btLIDP7fV053z75lagCKW3U3sf9y
         A8ESITsuDw5aZvkzmvkyodLVZ6crbpaei0phkK3XLxRzXsByhgG8E5nSjNXa6qVAk8Nh
         57xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3mjyd6r9Z8NRgSnG+P9PSoNzsHa0OVoXa5dJDxRkCYk=;
        b=oa2s+RN5lhZY+YgUwitDGxut4EaOllhJho7M+mcLMFnie0frF7QM/Ddyc0y2dN14o2
         MMyHlNfj4hD3HiRBB9Z2uBmUe+QLhSVkqqNGYDMpljr4CKoFyvKQEkNPEwiPHd/RyKCm
         vMhTLon9pXsUCxzeNWrNSpWIq+zG0Pv1kS7Wv/0oHwK7Sz1cjGpU7y8ozkBI4exm+GUS
         zjzVNh+MUeUKN0WGKjmgDj2ZMhcwm+u6kE97frAcjXfWBKxH/6x2s17m4820Yi1043+3
         iOyyS4WrIoG9swxqPHB86SDrtM5vMQnEmzyeSoWqNAZQIhWgD3mziqmfhrNdNcG+YD36
         E33A==
X-Gm-Message-State: AOAM533EXvaGvlpPVkoIKEWl6wWUxkBjqI8DY2IzUh3xpAzyEk9bfAHs
        GLZwcvzQcSAsDB6YmTKb6H3XX65lEj2tjRA5GGIMsQ==
X-Google-Smtp-Source: ABdhPJy1QcNgfU4ZI0hGPqS1qMQ8m9mfv0gvwG3ncZShGHd/Tn9b42wi7vNTUL7hBQwk2F/xnYQAVj7TYIYTHORozvE=
X-Received: by 2002:a67:ea98:: with SMTP id f24mr10128329vso.159.1593434810843;
 Mon, 29 Jun 2020 05:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200629122925.21729-1-andrzej.p@collabora.com> <20200629122925.21729-10-andrzej.p@collabora.com>
In-Reply-To: <20200629122925.21729-10-andrzej.p@collabora.com>
From:   Amit Kucheria <amit.kucheria@verdurent.com>
Date:   Mon, 29 Jun 2020 18:16:39 +0530
Message-ID: <CAHLCerNsXrkJqU5_Tw_PA8YQLGsHzDg7POrBRtvisBtJixU+CA@mail.gmail.com>
Subject: Re: [PATCH v7 09/11] thermal: core: Stop polling DISABLED thermal devices
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     Linux PM list <linux-pm@vger.kernel.org>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        lakml <linux-arm-kernel@lists.infradead.org>,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        kernel@collabora.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 6:00 PM Andrzej Pietrasiewicz
<andrzej.p@collabora.com> wrote:
>
> Polling DISABLED devices is not desired, as all such "disabled" devices
> are meant to be handled by userspace. This patch introduces and uses
> should_stop_polling() to decide whether the device should be polled or not.
>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>

> ---
>  drivers/thermal/thermal_core.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 52d136780577..e613f5c07bad 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -301,13 +301,22 @@ static void thermal_zone_device_set_polling(struct thermal_zone_device *tz,
>                 cancel_delayed_work(&tz->poll_queue);
>  }
>
> +static inline bool should_stop_polling(struct thermal_zone_device *tz)
> +{
> +       return !thermal_zone_device_is_enabled(tz);
> +}
> +
>  static void monitor_thermal_zone(struct thermal_zone_device *tz)
>  {
> +       bool stop;
> +
> +       stop = should_stop_polling(tz);
> +
>         mutex_lock(&tz->lock);
>
> -       if (tz->passive)
> +       if (!stop && tz->passive)
>                 thermal_zone_device_set_polling(tz, tz->passive_delay);
> -       else if (tz->polling_delay)
> +       else if (!stop && tz->polling_delay)
>                 thermal_zone_device_set_polling(tz, tz->polling_delay);
>         else
>                 thermal_zone_device_set_polling(tz, 0);
> @@ -517,6 +526,9 @@ void thermal_zone_device_update(struct thermal_zone_device *tz,
>  {
>         int count;
>
> +       if (should_stop_polling(tz))
> +               return;
> +
>         if (atomic_read(&in_suspend))
>                 return;
>
> --
> 2.17.1
>
