Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7A520E0E1
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387813AbgF2Uuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731443AbgF2TNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:35 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311A2C08EE7B
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 00:19:57 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id i8so4977848uak.9
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 00:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=verdurent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XpYnh8gMYavfYLlo546wBFKAR4SvsyOyU3BwpCQr48Y=;
        b=13O1W6B1WoYn8RPzdruP1UsaIJjpCs+IyOvzq9Hz0Cb2k6EwAvj3Zp/jB0S6Kft7Nl
         o4TQYqPUgOaEo/uWqotQ66eV2QrtibbA4DUDHE4leNZi23M9bAJKxke54zBwxNB72yYi
         1O6c/zqJ69Y0NMv25Jca9Nu60iNQgRing2YBd00Vu1VRiFE+o5C8fEjhIvHwTKKwq+kA
         fpWvKQy++uWsEtjukRFnzGgeMUDntbJSBHd+6Hkxej1CLrJHk44FNNfa207qLIA+LrNj
         FTqRgy04tivPRI1OV065nQpiXGXPJtXkPiSp1G1mTd7pzIbU9k8IrQ90x16surkpuXdC
         r/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XpYnh8gMYavfYLlo546wBFKAR4SvsyOyU3BwpCQr48Y=;
        b=ehHJvpfTfJcwppuOiTFXJiAg+fmOg2D4O9ECWXFYqCS/Zz32+fAV6GmcMmozYuGoTf
         Nj69svaZRW4y3LEIlm3FwEazorRRW6BC6xV2vXMp4+yUmNarhvcbFDkt/IsqOuaPMk36
         xeYIq+syGa5OF50MAbWwlFY7XdVG/ZwPfSwNTKjb8eg27dKhwNzeZ1Y/yAyY6RKzb2BQ
         Z43WgMbfOaH7SDoK7cmhr2t/uXmP/ZEqLRXr17pq+p9w8iUJR5vejwJaZoqDeUqDCyuh
         YxJ9ea4GsSMLw3rD4jIladFtDJaGot61H6wjeup/j/QbPhRjLspjWUiHlMUyRlA6dN+b
         HJLg==
X-Gm-Message-State: AOAM530hvFWulZ51wKRxljENW3BKeqwryOFUVlYVIGnxf4K36TsvXi6G
        D4vkKQDwBcSiVzi6Qb5HP/HUxSIqM1FjEHhea/YBHQ==
X-Google-Smtp-Source: ABdhPJxuIMc3AKl58RR5BB2o4v6o+LuGqoOO72B8HIckh2GgWrvSrRyjWB3ObkuGZltyeo/65xaFDUvMh18+fu68Jl8=
X-Received: by 2002:a9f:3113:: with SMTP id m19mr553540uab.77.1593415196293;
 Mon, 29 Jun 2020 00:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <9cbffad6-69e4-0b33-4640-fde7c4f6a6e7@linaro.org>
 <20200626173755.26379-1-andrzej.p@collabora.com> <20200626173755.26379-3-andrzej.p@collabora.com>
In-Reply-To: <20200626173755.26379-3-andrzej.p@collabora.com>
From:   Amit Kucheria <amit.kucheria@verdurent.com>
Date:   Mon, 29 Jun 2020 12:49:45 +0530
Message-ID: <CAHLCerMF3AusmmUUiE21mAV293fBU5vCxJ0K-dPcVNZBSHtMBg@mail.gmail.com>
Subject: Re: [PATCH v5 02/11] thermal: Store thermal mode in a dedicated enum
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

On Fri, Jun 26, 2020 at 11:08 PM Andrzej Pietrasiewicz
<andrzej.p@collabora.com> wrote:
>
> Prepare for storing mode in struct thermal_zone_device.
>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> [for acerhdf]
> Acked-by: Peter Kaestle <peter@piie.net>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>


> ---
>  drivers/acpi/thermal.c                        | 27 +++++++++----------
>  drivers/platform/x86/acerhdf.c                |  8 ++++--
>  .../intel/int340x_thermal/int3400_thermal.c   | 18 +++++--------
>  3 files changed, 25 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 6de8066ca1e7..fb46070c66d8 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -172,7 +172,7 @@ struct acpi_thermal {
>         struct acpi_thermal_trips trips;
>         struct acpi_handle_list devices;
>         struct thermal_zone_device *thermal_zone;
> -       int tz_enabled;
> +       enum thermal_device_mode mode;
>         int kelvin_offset;      /* in millidegrees */
>         struct work_struct thermal_check_work;
>  };
> @@ -500,7 +500,7 @@ static void acpi_thermal_check(void *data)
>  {
>         struct acpi_thermal *tz = data;
>
> -       if (!tz->tz_enabled)
> +       if (tz->mode != THERMAL_DEVICE_ENABLED)
>                 return;
>
>         thermal_zone_device_update(tz->thermal_zone,
> @@ -534,8 +534,7 @@ static int thermal_get_mode(struct thermal_zone_device *thermal,
>         if (!tz)
>                 return -EINVAL;
>
> -       *mode = tz->tz_enabled ? THERMAL_DEVICE_ENABLED :
> -               THERMAL_DEVICE_DISABLED;
> +       *mode = tz->mode;
>
>         return 0;
>  }
> @@ -544,27 +543,25 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
>                                 enum thermal_device_mode mode)
>  {
>         struct acpi_thermal *tz = thermal->devdata;
> -       int enable;
>
>         if (!tz)
>                 return -EINVAL;
>
> +       if (mode != THERMAL_DEVICE_DISABLED &&
> +           mode != THERMAL_DEVICE_ENABLED)
> +               return -EINVAL;
>         /*
>          * enable/disable thermal management from ACPI thermal driver
>          */
> -       if (mode == THERMAL_DEVICE_ENABLED)
> -               enable = 1;
> -       else if (mode == THERMAL_DEVICE_DISABLED) {
> -               enable = 0;
> +       if (mode == THERMAL_DEVICE_DISABLED)
>                 pr_warn("thermal zone will be disabled\n");
> -       } else
> -               return -EINVAL;
>
> -       if (enable != tz->tz_enabled) {
> -               tz->tz_enabled = enable;
> +       if (mode != tz->mode) {
> +               tz->mode = mode;
>                 ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>                         "%s kernel ACPI thermal control\n",
> -                       tz->tz_enabled ? "Enable" : "Disable"));
> +                       tz->mode == THERMAL_DEVICE_ENABLED ?
> +                       "Enable" : "Disable"));
>                 acpi_thermal_check(tz);
>         }
>         return 0;
> @@ -915,7 +912,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>                 goto remove_dev_link;
>         }
>
> -       tz->tz_enabled = 1;
> +       tz->mode = THERMAL_DEVICE_ENABLED;
>
>         dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
>                  tz->thermal_zone->id);
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 4df7609b4aa9..9d1030b1a4f4 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -68,6 +68,7 @@ static int kernelmode = 1;
>  #else
>  static int kernelmode;
>  #endif
> +static enum thermal_device_mode thermal_mode;
>
>  static unsigned int interval = 10;
>  static unsigned int fanon = 60000;
> @@ -397,6 +398,7 @@ static inline void acerhdf_revert_to_bios_mode(void)
>  {
>         acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>         kernelmode = 0;
> +       thermal_mode = THERMAL_DEVICE_DISABLED;
>         if (thz_dev)
>                 thz_dev->polling_delay = 0;
>         pr_notice("kernel mode fan control OFF\n");
> @@ -404,6 +406,7 @@ static inline void acerhdf_revert_to_bios_mode(void)
>  static inline void acerhdf_enable_kernelmode(void)
>  {
>         kernelmode = 1;
> +       thermal_mode = THERMAL_DEVICE_ENABLED;
>
>         thz_dev->polling_delay = interval*1000;
>         thermal_zone_device_update(thz_dev, THERMAL_EVENT_UNSPECIFIED);
> @@ -416,8 +419,7 @@ static int acerhdf_get_mode(struct thermal_zone_device *thermal,
>         if (verbose)
>                 pr_notice("kernel mode fan control %d\n", kernelmode);
>
> -       *mode = (kernelmode) ? THERMAL_DEVICE_ENABLED
> -                            : THERMAL_DEVICE_DISABLED;
> +       *mode = thermal_mode;
>
>         return 0;
>  }
> @@ -739,6 +741,8 @@ static int __init acerhdf_register_thermal(void)
>         if (IS_ERR(cl_dev))
>                 return -EINVAL;
>
> +       thermal_mode = kernelmode ?
> +               THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED;
>         thz_dev = thermal_zone_device_register("acerhdf", 2, 0, NULL,
>                                               &acerhdf_dev_ops,
>                                               &acerhdf_zone_params, 0,
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index 0b3a62655843..e84faaadff87 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -48,7 +48,7 @@ struct int3400_thermal_priv {
>         struct acpi_device *adev;
>         struct platform_device *pdev;
>         struct thermal_zone_device *thermal;
> -       int mode;
> +       enum thermal_device_mode mode;
>         int art_count;
>         struct art *arts;
>         int trt_count;
> @@ -395,24 +395,20 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>                                 enum thermal_device_mode mode)
>  {
>         struct int3400_thermal_priv *priv = thermal->devdata;
> -       bool enable;
>         int result = 0;
>
>         if (!priv)
>                 return -EINVAL;
>
> -       if (mode == THERMAL_DEVICE_ENABLED)
> -               enable = true;
> -       else if (mode == THERMAL_DEVICE_DISABLED)
> -               enable = false;
> -       else
> +       if (mode != THERMAL_DEVICE_ENABLED &&
> +           mode != THERMAL_DEVICE_DISABLED)
>                 return -EINVAL;
>
> -       if (enable != priv->mode) {
> -               priv->mode = enable;
> +       if (mode != priv->mode) {
> +               priv->mode = mode;
>                 result = int3400_thermal_run_osc(priv->adev->handle,
> -                                                priv->current_uuid_index,
> -                                                enable);
> +                                               priv->current_uuid_index,
> +                                               mode == THERMAL_DEVICE_ENABLED);
>         }
>
>         evaluate_odvp(priv);
> --
> 2.17.1
>
