Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99BA20E603
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgF2Vnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727853AbgF2Sht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:37:49 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42012C00F838
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:48:03 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id m25so9149053vsp.8
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=verdurent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sinEnS6z0XptgBEvEcK3MVQ+LTLUCuUM67IGB48+uOQ=;
        b=yXWQZyxv3Tuid2rMLdkiiqPqO771/LUhGpTuZO7tN1lCQvALpqAXD6QDLbcVJdR2DJ
         /NPqfsSrNnYOgvRHpQaNAZ4aqjyp4oHfKnfhjmq78WXV1756CXcVm/4dWP1AzJuA5/ox
         7ywP5FU8VnODuq75PVQVtv6u5sRujs0EY8pIwLtzjNllqTpxdu6/FoOHTmQBWiC390jn
         Bcn1nz/GPyqqn5oBysRBz+SFvJwLZS7HNAF9/m+gIqbPsvCOfzMJIASBApYkdAR3eaU5
         ogssMmkIDK2r6MXGaicZV0/WI5tfJ6n2VqmdQHmHpapNFZtQZ24bkM0owtL2IkL9jPv2
         j2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sinEnS6z0XptgBEvEcK3MVQ+LTLUCuUM67IGB48+uOQ=;
        b=HG5sU8X9r16mfwxhvHRPcQEee3viKxxUUMaeaKhsEbdnIlzVYOG6+TmVkfBxh9fivy
         Yw1narxiu95rCE2x/Rc3l0OeYZLQgiwk4P3f8ESWA2MXnnAAjCQLPjyfXMpVJ/2LUL+6
         Qxe+DIt3EVoLyWgYOs7fWRYmO2A43lfBXtJBuTufeUaFBr7VJp2z6BkZNVPZQysvz4KP
         HDNr9+NgpQeDkFQ+B6AyqgfsZAFx0cZYvhk8yirFOOLKRMh9DuPdBnqI3erYZHAVJUba
         31zkhJHghcvfa4GsKtIKCOu6dWZyGui88RZLKM4y9A4VAXOo6W/tx5M858QtO8QheVvm
         Ok4g==
X-Gm-Message-State: AOAM533DpbUniXc6+/FqgLXLYKxSylzCT7w57HBEhXCSdUMsUc+Fbq/9
        H9Lb/r+UN+be/N/QC7gRAv7BqW+MA4AxnC9p5NQWZZX2gkcqeA==
X-Google-Smtp-Source: ABdhPJz5y4gYixUUu743AouZ4iPhyVkpUcLHjnbxyNRQtJI4Joc90JTCn7lsZ28Q7GeTrTlI2ZxCvGHDHBtVZEeY4WU=
X-Received: by 2002:a67:7f04:: with SMTP id a4mr5835962vsd.9.1593434882284;
 Mon, 29 Jun 2020 05:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200629122925.21729-1-andrzej.p@collabora.com> <20200629122925.21729-11-andrzej.p@collabora.com>
In-Reply-To: <20200629122925.21729-11-andrzej.p@collabora.com>
From:   Amit Kucheria <amit.kucheria@verdurent.com>
Date:   Mon, 29 Jun 2020 18:17:51 +0530
Message-ID: <CAHLCerMixUyWRoTrDhzYoaVGL31Qg0+v+J_4j4j1ui6qGyehdA@mail.gmail.com>
Subject: Re: [PATCH v7 10/11] thermal: Simplify or eliminate unnecessary
 set_mode() methods
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
> Setting polling_delay is now done at thermal_core level (by not polling
> DISABLED devices), so no need to repeat this code.
>
> int340x: Checking for an impossible enum value is unnecessary.
> acpi/thermal: It only prints debug messages.
>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> [for acerhdf]
> Acked-by: Peter Kaestle <peter@piie.net>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>

> ---
>  drivers/acpi/thermal.c                        | 26 ----------------
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 30 -------------------
>  drivers/platform/x86/acerhdf.c                |  3 --
>  drivers/thermal/imx_thermal.c                 |  6 ----
>  .../intel/int340x_thermal/int3400_thermal.c   |  4 ---
>  drivers/thermal/thermal_of.c                  | 18 -----------
>  6 files changed, 87 deletions(-)
>
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 52b6cda1bcc3..29a2b73fe035 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -525,31 +525,6 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
>         return 0;
>  }
>
> -static int thermal_set_mode(struct thermal_zone_device *thermal,
> -                               enum thermal_device_mode mode)
> -{
> -       struct acpi_thermal *tz = thermal->devdata;
> -
> -       if (!tz)
> -               return -EINVAL;
> -
> -       if (mode != THERMAL_DEVICE_DISABLED &&
> -           mode != THERMAL_DEVICE_ENABLED)
> -               return -EINVAL;
> -       /*
> -        * enable/disable thermal management from ACPI thermal driver
> -        */
> -       if (mode == THERMAL_DEVICE_DISABLED)
> -               pr_warn("thermal zone will be disabled\n");
> -
> -       ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -               "%s kernel ACPI thermal control\n",
> -               mode == THERMAL_DEVICE_ENABLED ?
> -               "Enable" : "Disable"));
> -
> -       return 0;
> -}
> -
>  static int thermal_get_trip_type(struct thermal_zone_device *thermal,
>                                  int trip, enum thermal_trip_type *type)
>  {
> @@ -836,7 +811,6 @@ static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
>         .bind = acpi_thermal_bind_cooling_device,
>         .unbind = acpi_thermal_unbind_cooling_device,
>         .get_temp = thermal_get_temp,
> -       .set_mode = thermal_set_mode,
>         .get_trip_type = thermal_get_trip_type,
>         .get_trip_temp = thermal_get_trip_temp,
>         .get_crit_temp = thermal_get_crit_temp,
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index 4fb73d0fd167..8fa286ccdd6b 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -275,19 +275,6 @@ static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
>         return 0;
>  }
>
> -static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
> -                                 enum thermal_device_mode mode)
> -{
> -       struct mlxsw_thermal *thermal = tzdev->devdata;
> -
> -       if (mode == THERMAL_DEVICE_ENABLED)
> -               tzdev->polling_delay = thermal->polling_delay;
> -       else
> -               tzdev->polling_delay = 0;
> -
> -       return 0;
> -}
> -
>  static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
>                                   int *p_temp)
>  {
> @@ -387,7 +374,6 @@ static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_ops = {
>         .bind = mlxsw_thermal_bind,
>         .unbind = mlxsw_thermal_unbind,
> -       .set_mode = mlxsw_thermal_set_mode,
>         .get_temp = mlxsw_thermal_get_temp,
>         .get_trip_type  = mlxsw_thermal_get_trip_type,
>         .get_trip_temp  = mlxsw_thermal_get_trip_temp,
> @@ -445,20 +431,6 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
>         return err;
>  }
>
> -static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
> -                                        enum thermal_device_mode mode)
> -{
> -       struct mlxsw_thermal_module *tz = tzdev->devdata;
> -       struct mlxsw_thermal *thermal = tz->parent;
> -
> -       if (mode == THERMAL_DEVICE_ENABLED)
> -               tzdev->polling_delay = thermal->polling_delay;
> -       else
> -               tzdev->polling_delay = 0;
> -
> -       return 0;
> -}
> -
>  static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
>                                          int *p_temp)
>  {
> @@ -574,7 +546,6 @@ static int mlxsw_thermal_module_trend_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
>         .bind           = mlxsw_thermal_module_bind,
>         .unbind         = mlxsw_thermal_module_unbind,
> -       .set_mode       = mlxsw_thermal_module_mode_set,
>         .get_temp       = mlxsw_thermal_module_temp_get,
>         .get_trip_type  = mlxsw_thermal_module_trip_type_get,
>         .get_trip_temp  = mlxsw_thermal_module_trip_temp_get,
> @@ -612,7 +583,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
>         .bind           = mlxsw_thermal_module_bind,
>         .unbind         = mlxsw_thermal_module_unbind,
> -       .set_mode       = mlxsw_thermal_module_mode_set,
>         .get_temp       = mlxsw_thermal_gearbox_temp_get,
>         .get_trip_type  = mlxsw_thermal_module_trip_type_get,
>         .get_trip_temp  = mlxsw_thermal_module_trip_temp_get,
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 8fe0ecb6a626..76323855c80c 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -397,8 +397,6 @@ static inline void acerhdf_revert_to_bios_mode(void)
>  {
>         acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>         kernelmode = 0;
> -       if (thz_dev)
> -               thz_dev->polling_delay = 0;
>
>         pr_notice("kernel mode fan control OFF\n");
>  }
> @@ -406,7 +404,6 @@ static inline void acerhdf_enable_kernelmode(void)
>  {
>         kernelmode = 1;
>
> -       thz_dev->polling_delay = interval*1000;
>         pr_notice("kernel mode fan control ON\n");
>  }
>
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index 53abb1be1cba..a02398118d88 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -338,9 +338,6 @@ static int imx_set_mode(struct thermal_zone_device *tz,
>         const struct thermal_soc_data *soc_data = data->socdata;
>
>         if (mode == THERMAL_DEVICE_ENABLED) {
> -               tz->polling_delay = IMX_POLLING_DELAY;
> -               tz->passive_delay = IMX_PASSIVE_DELAY;
> -
>                 regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>                              soc_data->power_down_mask);
>                 regmap_write(map, soc_data->sensor_ctrl + REG_SET,
> @@ -356,9 +353,6 @@ static int imx_set_mode(struct thermal_zone_device *tz,
>                 regmap_write(map, soc_data->sensor_ctrl + REG_SET,
>                              soc_data->power_down_mask);
>
> -               tz->polling_delay = 0;
> -               tz->passive_delay = 0;
> -
>                 if (data->irq_enabled) {
>                         disable_irq(data->irq);
>                         data->irq_enabled = false;
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index 3c0397a29b8c..ce49d3b100d5 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -386,10 +386,6 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>         if (!priv)
>                 return -EINVAL;
>
> -       if (mode != THERMAL_DEVICE_ENABLED &&
> -           mode != THERMAL_DEVICE_DISABLED)
> -               return -EINVAL;
> -
>         if (mode != thermal->mode)
>                 result = int3400_thermal_run_osc(priv->adev->handle,
>                                                 priv->current_uuid_index,
> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
> index 43a516a35d64..69ef12f852b7 100644
> --- a/drivers/thermal/thermal_of.c
> +++ b/drivers/thermal/thermal_of.c
> @@ -267,22 +267,6 @@ static int of_thermal_unbind(struct thermal_zone_device *thermal,
>         return 0;
>  }
>
> -static int of_thermal_set_mode(struct thermal_zone_device *tz,
> -                              enum thermal_device_mode mode)
> -{
> -       struct __thermal_zone *data = tz->devdata;
> -
> -       if (mode == THERMAL_DEVICE_ENABLED) {
> -               tz->polling_delay = data->polling_delay;
> -               tz->passive_delay = data->passive_delay;
> -       } else {
> -               tz->polling_delay = 0;
> -               tz->passive_delay = 0;
> -       }
> -
> -       return 0;
> -}
> -
>  static int of_thermal_get_trip_type(struct thermal_zone_device *tz, int trip,
>                                     enum thermal_trip_type *type)
>  {
> @@ -374,8 +358,6 @@ static int of_thermal_get_crit_temp(struct thermal_zone_device *tz,
>  }
>
>  static struct thermal_zone_device_ops of_thermal_ops = {
> -       .set_mode = of_thermal_set_mode,
> -
>         .get_trip_type = of_thermal_get_trip_type,
>         .get_trip_temp = of_thermal_get_trip_temp,
>         .set_trip_temp = of_thermal_set_trip_temp,
> --
> 2.17.1
>
