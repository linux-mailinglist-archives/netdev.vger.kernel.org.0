Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961A220E218
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390176AbgF2VCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731166AbgF2TMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:12:50 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6E7C0A54D8
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 00:20:15 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id s192so3495314vkh.3
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 00:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=verdurent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fu3sQwJ5qOR5mLJImi5eRMedDSAECuF/6qfNRH8Vib4=;
        b=TXOVRtnfTiIlmBW884xY+ir+T4v40AyzJ+d02wEKqYRDufwXuVweGTJKkCpv4342lb
         vFssqHkHjMk9FA6mRar/22+dISiC0p1DE9oHlzHLyt8yMEyAZy6oIwIneMgXfj/5sGw/
         3oYYqkxFaxw2ZOUyWPtxlpkfR7iPv3R3Z+Nz7BOQOuO2UTXRnypARGGqInGVL8LeNqmS
         HTaKoobnp0JXb/oBoYyqnYixQApteB7O4Dwe7PnYayfZXZk97GzMKjTrzlBxacpXSxqg
         evFJT30A3Op15lLhByyovlNOK1M1CO/RzpytjuR16RV5fzs63bpJOpUMPURmkErOiSYh
         /4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fu3sQwJ5qOR5mLJImi5eRMedDSAECuF/6qfNRH8Vib4=;
        b=g9fykB6QnWWjcFW35uRRiCIjgpGrOwo+iYUnUaTAGM6LWoBf6QEJIl6vliQde+Zx1n
         wtzC+1SZm/vuF95bcpMaV/sdeVQps+wvKC50/Alh2Tzp2Gfu+UlFwwA4sy2rumoTDLFy
         0Zjs6Huxdx3TdTeapxst4VvkWYD+FRh8IbObsuEWaIQw03EI1juryE4Xb9uHT4cqBM3N
         eAer+Z3Jk1JHrTs9vMGGrSyMNAj/89wjb+TYIyUB4PZP0j8lsh09hnu/9HQrUiVTOUNo
         R7iLGdPuhQdqrNcBJfArVDw9X99u0dlWAE/451B0SfuK8+06AwhyZA5R39R7poX7R1Zb
         IIlA==
X-Gm-Message-State: AOAM530PiS0blxcvsfjppoGK980a1nuOMDMEw0vVWpJwV8j5Wzq2APxP
        ILYMulOkCCpNuzUY+Q/w581U+qLcXC1LY+n4nB9gTA==
X-Google-Smtp-Source: ABdhPJzEMgWoGyaAnwAw2iISu61LLiVGXw2XzrL4I7vR7oZCQSUYGQeTET9bgjFH31QOwWyjfiDGmVj971CTGBxRoSo=
X-Received: by 2002:a1f:3602:: with SMTP id d2mr3502713vka.9.1593415214634;
 Mon, 29 Jun 2020 00:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <9cbffad6-69e4-0b33-4640-fde7c4f6a6e7@linaro.org>
 <20200626173755.26379-1-andrzej.p@collabora.com> <20200626173755.26379-6-andrzej.p@collabora.com>
In-Reply-To: <20200626173755.26379-6-andrzej.p@collabora.com>
From:   Amit Kucheria <amit.kucheria@verdurent.com>
Date:   Mon, 29 Jun 2020 12:50:03 +0530
Message-ID: <CAHLCerNUsnH0bhK_dg5NAq1NiSxsqTqZq9E2adG--RDSgbPozQ@mail.gmail.com>
Subject: Re: [PATCH v5 05/11] thermal: remove get_mode() operation of drivers
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
> get_mode() is now redundant, as the state is stored in struct
> thermal_zone_device.
>
> Consequently the "mode" attribute in sysfs can always be visible, because
> it is always possible to get the mode from struct tzd.
>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> [for acerhdf]
> Acked-by: Peter Kaestle <peter@piie.net>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>


> ---
>  drivers/acpi/thermal.c                        |  9 ------
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 19 ------------
>  drivers/platform/x86/acerhdf.c                | 12 --------
>  drivers/thermal/da9062-thermal.c              |  8 -----
>  drivers/thermal/imx_thermal.c                 |  9 ------
>  .../intel/int340x_thermal/int3400_thermal.c   |  9 ------
>  .../thermal/intel/intel_quark_dts_thermal.c   |  8 -----
>  drivers/thermal/thermal_core.c                |  7 +----
>  drivers/thermal/thermal_of.c                  |  9 ------
>  drivers/thermal/thermal_sysfs.c               | 30 ++-----------------
>  include/linux/thermal.h                       |  2 --
>  11 files changed, 3 insertions(+), 119 deletions(-)
>
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 4ba273f49d87..592be97c4456 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -525,14 +525,6 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
>         return 0;
>  }
>
> -static int thermal_get_mode(struct thermal_zone_device *thermal,
> -                               enum thermal_device_mode *mode)
> -{
> -       *mode = thermal->mode;
> -
> -       return 0;
> -}
> -
>  static int thermal_set_mode(struct thermal_zone_device *thermal,
>                                 enum thermal_device_mode mode)
>  {
> @@ -847,7 +839,6 @@ static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
>         .bind = acpi_thermal_bind_cooling_device,
>         .unbind = acpi_thermal_unbind_cooling_device,
>         .get_temp = thermal_get_temp,
> -       .get_mode = thermal_get_mode,
>         .set_mode = thermal_set_mode,
>         .get_trip_type = thermal_get_trip_type,
>         .get_trip_temp = thermal_get_trip_temp,
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index 51667ed99c21..ad61b2db30b8 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -275,14 +275,6 @@ static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
>         return 0;
>  }
>
> -static int mlxsw_thermal_get_mode(struct thermal_zone_device *tzdev,
> -                                 enum thermal_device_mode *mode)
> -{
> -       *mode = tzdev->mode;
> -
> -       return 0;
> -}
> -
>  static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
>                                   enum thermal_device_mode mode)
>  {
> @@ -402,7 +394,6 @@ static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_ops = {
>         .bind = mlxsw_thermal_bind,
>         .unbind = mlxsw_thermal_unbind,
> -       .get_mode = mlxsw_thermal_get_mode,
>         .set_mode = mlxsw_thermal_set_mode,
>         .get_temp = mlxsw_thermal_get_temp,
>         .get_trip_type  = mlxsw_thermal_get_trip_type,
> @@ -461,14 +452,6 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
>         return err;
>  }
>
> -static int mlxsw_thermal_module_mode_get(struct thermal_zone_device *tzdev,
> -                                        enum thermal_device_mode *mode)
> -{
> -       *mode = tzdev->mode;
> -
> -       return 0;
> -}
> -
>  static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
>                                          enum thermal_device_mode mode)
>  {
> @@ -606,7 +589,6 @@ static int mlxsw_thermal_module_trend_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
>         .bind           = mlxsw_thermal_module_bind,
>         .unbind         = mlxsw_thermal_module_unbind,
> -       .get_mode       = mlxsw_thermal_module_mode_get,
>         .set_mode       = mlxsw_thermal_module_mode_set,
>         .get_temp       = mlxsw_thermal_module_temp_get,
>         .get_trip_type  = mlxsw_thermal_module_trip_type_get,
> @@ -645,7 +627,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
>         .bind           = mlxsw_thermal_module_bind,
>         .unbind         = mlxsw_thermal_module_unbind,
> -       .get_mode       = mlxsw_thermal_module_mode_get,
>         .set_mode       = mlxsw_thermal_module_mode_set,
>         .get_temp       = mlxsw_thermal_gearbox_temp_get,
>         .get_trip_type  = mlxsw_thermal_module_trip_type_get,
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 6f21015e5fd9..58c4e1caaa09 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -413,17 +413,6 @@ static inline void acerhdf_enable_kernelmode(void)
>         pr_notice("kernel mode fan control ON\n");
>  }
>
> -static int acerhdf_get_mode(struct thermal_zone_device *thermal,
> -                           enum thermal_device_mode *mode)
> -{
> -       if (verbose)
> -               pr_notice("kernel mode fan control %d\n", kernelmode);
> -
> -       *mode = thermal->mode;
> -
> -       return 0;
> -}
> -
>  /*
>   * set operation mode;
>   * enabled: the thermal layer of the kernel takes care about
> @@ -490,7 +479,6 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
>         .bind = acerhdf_bind,
>         .unbind = acerhdf_unbind,
>         .get_temp = acerhdf_get_ec_temp,
> -       .get_mode = acerhdf_get_mode,
>         .set_mode = acerhdf_set_mode,
>         .get_trip_type = acerhdf_get_trip_type,
>         .get_trip_hyst = acerhdf_get_trip_hyst,
> diff --git a/drivers/thermal/da9062-thermal.c b/drivers/thermal/da9062-thermal.c
> index a14c7981c7c7..a7ac8afb063e 100644
> --- a/drivers/thermal/da9062-thermal.c
> +++ b/drivers/thermal/da9062-thermal.c
> @@ -120,13 +120,6 @@ static irqreturn_t da9062_thermal_irq_handler(int irq, void *data)
>         return IRQ_HANDLED;
>  }
>
> -static int da9062_thermal_get_mode(struct thermal_zone_device *z,
> -                                  enum thermal_device_mode *mode)
> -{
> -       *mode = z->mode;
> -       return 0;
> -}
> -
>  static int da9062_thermal_get_trip_type(struct thermal_zone_device *z,
>                                         int trip,
>                                         enum thermal_trip_type *type)
> @@ -179,7 +172,6 @@ static int da9062_thermal_get_temp(struct thermal_zone_device *z,
>
>  static struct thermal_zone_device_ops da9062_thermal_ops = {
>         .get_temp       = da9062_thermal_get_temp,
> -       .get_mode       = da9062_thermal_get_mode,
>         .get_trip_type  = da9062_thermal_get_trip_type,
>         .get_trip_temp  = da9062_thermal_get_trip_temp,
>  };
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index 9a1114d721b6..2c7ee5da608a 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -330,14 +330,6 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>         return 0;
>  }
>
> -static int imx_get_mode(struct thermal_zone_device *tz,
> -                       enum thermal_device_mode *mode)
> -{
> -       *mode = tz->mode;
> -
> -       return 0;
> -}
> -
>  static int imx_set_mode(struct thermal_zone_device *tz,
>                         enum thermal_device_mode mode)
>  {
> @@ -464,7 +456,6 @@ static struct thermal_zone_device_ops imx_tz_ops = {
>         .bind = imx_bind,
>         .unbind = imx_unbind,
>         .get_temp = imx_get_temp,
> -       .get_mode = imx_get_mode,
>         .set_mode = imx_set_mode,
>         .get_trip_type = imx_get_trip_type,
>         .get_trip_temp = imx_get_trip_temp,
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index f65b2fc09198..9a622aaf29dd 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -377,14 +377,6 @@ static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
>         return 0;
>  }
>
> -static int int3400_thermal_get_mode(struct thermal_zone_device *thermal,
> -                               enum thermal_device_mode *mode)
> -{
> -       *mode = thermal->mode;
> -
> -       return 0;
> -}
> -
>  static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>                                 enum thermal_device_mode mode)
>  {
> @@ -412,7 +404,6 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>
>  static struct thermal_zone_device_ops int3400_thermal_ops = {
>         .get_temp = int3400_thermal_get_temp,
> -       .get_mode = int3400_thermal_get_mode,
>         .set_mode = int3400_thermal_set_mode,
>  };
>
> diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
> index d77cb3df5ade..c4879b4bfbf1 100644
> --- a/drivers/thermal/intel/intel_quark_dts_thermal.c
> +++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
> @@ -308,13 +308,6 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd,
>         return 0;
>  }
>
> -static int sys_get_mode(struct thermal_zone_device *tzd,
> -                               enum thermal_device_mode *mode)
> -{
> -       *mode = tzd->mode;
> -       return 0;
> -}
> -
>  static int sys_set_mode(struct thermal_zone_device *tzd,
>                                 enum thermal_device_mode mode)
>  {
> @@ -336,7 +329,6 @@ static struct thermal_zone_device_ops tzone_ops = {
>         .get_trip_type = sys_get_trip_type,
>         .set_trip_temp = sys_set_trip_temp,
>         .get_crit_temp = sys_get_crit_temp,
> -       .get_mode = sys_get_mode,
>         .set_mode = sys_set_mode,
>  };
>
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index b71196eaf90e..14d3b1b94c4f 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1456,7 +1456,6 @@ static int thermal_pm_notify(struct notifier_block *nb,
>                              unsigned long mode, void *_unused)
>  {
>         struct thermal_zone_device *tz;
> -       enum thermal_device_mode tz_mode;
>
>         switch (mode) {
>         case PM_HIBERNATION_PREPARE:
> @@ -1469,11 +1468,7 @@ static int thermal_pm_notify(struct notifier_block *nb,
>         case PM_POST_SUSPEND:
>                 atomic_set(&in_suspend, 0);
>                 list_for_each_entry(tz, &thermal_tz_list, node) {
> -                       tz_mode = THERMAL_DEVICE_ENABLED;
> -                       if (tz->ops->get_mode)
> -                               tz->ops->get_mode(tz, &tz_mode);
> -
> -                       if (tz_mode == THERMAL_DEVICE_DISABLED)
> +                       if (tz->mode == THERMAL_DEVICE_DISABLED)
>                                 continue;
>
>                         thermal_zone_device_init(tz);
> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
> index c495b1e48ef2..ba65d48a48cb 100644
> --- a/drivers/thermal/thermal_of.c
> +++ b/drivers/thermal/thermal_of.c
> @@ -267,14 +267,6 @@ static int of_thermal_unbind(struct thermal_zone_device *thermal,
>         return 0;
>  }
>
> -static int of_thermal_get_mode(struct thermal_zone_device *tz,
> -                              enum thermal_device_mode *mode)
> -{
> -       *mode = tz->mode;
> -
> -       return 0;
> -}
> -
>  static int of_thermal_set_mode(struct thermal_zone_device *tz,
>                                enum thermal_device_mode mode)
>  {
> @@ -389,7 +381,6 @@ static int of_thermal_get_crit_temp(struct thermal_zone_device *tz,
>  }
>
>  static struct thermal_zone_device_ops of_thermal_ops = {
> -       .get_mode = of_thermal_get_mode,
>         .set_mode = of_thermal_set_mode,
>
>         .get_trip_type = of_thermal_get_trip_type,
> diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
> index aa99edb4dff7..096370977068 100644
> --- a/drivers/thermal/thermal_sysfs.c
> +++ b/drivers/thermal/thermal_sysfs.c
> @@ -49,18 +49,9 @@ static ssize_t
>  mode_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>         struct thermal_zone_device *tz = to_thermal_zone(dev);
> -       enum thermal_device_mode mode;
> -       int result;
> -
> -       if (!tz->ops->get_mode)
> -               return -EPERM;
>
> -       result = tz->ops->get_mode(tz, &mode);
> -       if (result)
> -               return result;
> -
> -       return sprintf(buf, "%s\n", mode == THERMAL_DEVICE_ENABLED ? "enabled"
> -                      : "disabled");
> +       return sprintf(buf, "%s\n", tz->mode == THERMAL_DEVICE_ENABLED ?
> +                      "enabled" : "disabled");
>  }
>
>  static ssize_t
> @@ -428,30 +419,13 @@ static struct attribute_group thermal_zone_attribute_group = {
>         .attrs = thermal_zone_dev_attrs,
>  };
>
> -/* We expose mode only if .get_mode is present */
>  static struct attribute *thermal_zone_mode_attrs[] = {
>         &dev_attr_mode.attr,
>         NULL,
>  };
>
> -static umode_t thermal_zone_mode_is_visible(struct kobject *kobj,
> -                                           struct attribute *attr,
> -                                           int attrno)
> -{
> -       struct device *dev = container_of(kobj, struct device, kobj);
> -       struct thermal_zone_device *tz;
> -
> -       tz = container_of(dev, struct thermal_zone_device, device);
> -
> -       if (tz->ops->get_mode)
> -               return attr->mode;
> -
> -       return 0;
> -}
> -
>  static struct attribute_group thermal_zone_mode_attribute_group = {
>         .attrs = thermal_zone_mode_attrs,
> -       .is_visible = thermal_zone_mode_is_visible,
>  };
>
>  /* We expose passive only if passive trips are present */
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 5f91d7f04512..a808f6fa2777 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -76,8 +76,6 @@ struct thermal_zone_device_ops {
>                        struct thermal_cooling_device *);
>         int (*get_temp) (struct thermal_zone_device *, int *);
>         int (*set_trips) (struct thermal_zone_device *, int, int);
> -       int (*get_mode) (struct thermal_zone_device *,
> -                        enum thermal_device_mode *);
>         int (*set_mode) (struct thermal_zone_device *,
>                 enum thermal_device_mode);
>         int (*get_trip_type) (struct thermal_zone_device *, int,
> --
> 2.17.1
>
