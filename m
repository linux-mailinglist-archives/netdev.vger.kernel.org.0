Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78131E8274
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgE2PtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgE2PtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:49:12 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A09CC03E969;
        Fri, 29 May 2020 08:49:12 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id n15so1552616pfd.0;
        Fri, 29 May 2020 08:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=RhpQQssuk+Knf4fyhN+qtTSTQBS5KGSZRIH6/e/jtwM=;
        b=IdKj2MIL8Ro8m5n5ZJ8/cOmYzdGRbW4Rm6XShoZ3uAY08Xis7MTsZVL6Vc4zji3AIu
         emhC2ysqJsIP/xr7G0NFev3pkHbQJ3Lb3/ZQxSY2zGf8NaBppxytzqFi1Mh152dNG/cV
         ELtMoFSjyvUeyhps8ekB5rrqzpKP2Y4kbbAXOW183AmKkvEP12j3BjCK8VBhWKnpnBA/
         sHxQ4EzPQdMaJW6faO0nMMd9zEOCdseXoEnMavLN+TWQtc0olBkDs6CCI/XrTk8HbbhK
         9hrhZ+YHMcHDFibldIZfdu9u+torCVCemMs427ISPCweuzlU4ulhAmPY1WeglUtXMpct
         wMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=RhpQQssuk+Knf4fyhN+qtTSTQBS5KGSZRIH6/e/jtwM=;
        b=o54SpVmnTjSc33KW7fw4artCoKGSw7/luihVnpv0vcroCxGu1rnpvnQX1lWt1C/gmB
         L2Me/gvAVNon/nI3Gzz3U/KmLiGMD8jzE7i8jWGL/7gU2Xu7SKOVLp4zKcZ2DT2KWDaO
         LoQGneFgYIkHWhCW/mfTMCMshjZk7nm8hboLg6orA+9L0np6i+cEUkF/IXen/ciy8xWb
         1kUnEGuCj4lxGXY+IlVKvNhpFsRrcEfBlmcYbQDOu5Ji6PeiOHPi45Jd9uKyF12zraY3
         hm4ifH/36vb7blXVsxLQpvEeM8Vbk1CIwAzJzMsI9sGHPvi995XCCDo3rRK6YtEqLBkf
         u0UA==
X-Gm-Message-State: AOAM53345C7089M5iRsLxkVM+KnUT6P5sfHsCISxpiMXr9cwU9VVvE7r
        kIcZoHYCr7OayqXFpnC8qZ4=
X-Google-Smtp-Source: ABdhPJzrpxFrHPoyA26Q6Jir3pCc5y5z0Pb+9C1DlrXqsixh1dTR4tbf1qLVTxDPvsjKHEvgUUZsSg==
X-Received: by 2002:a65:43cb:: with SMTP id n11mr8761225pgp.160.1590767351958;
        Fri, 29 May 2020 08:49:11 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s123sm7912037pfs.170.2020.05.29.08.49.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 08:49:11 -0700 (PDT)
Date:   Fri, 29 May 2020 08:49:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel@collabora.com, Fabio Estevam <festevam@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Allison Randal <allison@lohutok.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Darren Hart <dvhart@infradead.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Len Brown <lenb@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ido Schimmel <idosch@mellanox.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Enrico Weigelt <info@metux.net>,
        Peter Kaestle <peter@piie.net>,
        Sebastian Reichel <sre@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>, Shawn Guo <shawnguo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy@infradead.org>
Subject: Re: [PATCH v4 05/11] thermal: remove get_mode() operation of drivers
Message-ID: <20200529154910.GA158174@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 09:20:45PM +0200, Andrzej Pietrasiewicz wrote:
> get_mode() is now redundant, as the state is stored in struct
> thermal_zone_device.
> 
> Consequently the "mode" attribute in sysfs can always be visible, because
> it is always possible to get the mode from struct tzd.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

There is a slight semantic change for the two drivers which still have
a local copy of enum thermal_device_mode: Previously trying to read the
mode for those would return -EPERM since they don't have a get_mode
function. Now the global value for mode is returned, but I am not sure
if it matches the local value.

Guenter

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
>  	return 0;
>  }
>  
> -static int thermal_get_mode(struct thermal_zone_device *thermal,
> -				enum thermal_device_mode *mode)
> -{
> -	*mode = thermal->mode;
> -
> -	return 0;
> -}
> -
>  static int thermal_set_mode(struct thermal_zone_device *thermal,
>  				enum thermal_device_mode mode)
>  {
> @@ -847,7 +839,6 @@ static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
>  	.bind = acpi_thermal_bind_cooling_device,
>  	.unbind	= acpi_thermal_unbind_cooling_device,
>  	.get_temp = thermal_get_temp,
> -	.get_mode = thermal_get_mode,
>  	.set_mode = thermal_set_mode,
>  	.get_trip_type = thermal_get_trip_type,
>  	.get_trip_temp = thermal_get_trip_temp,
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index aa082e8a0b13..6e26678ac312 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -275,14 +275,6 @@ static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
>  	return 0;
>  }
>  
> -static int mlxsw_thermal_get_mode(struct thermal_zone_device *tzdev,
> -				  enum thermal_device_mode *mode)
> -{
> -	*mode = tzdev->mode;
> -
> -	return 0;
> -}
> -
>  static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
>  				  enum thermal_device_mode mode)
>  {
> @@ -403,7 +395,6 @@ static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_ops = {
>  	.bind = mlxsw_thermal_bind,
>  	.unbind = mlxsw_thermal_unbind,
> -	.get_mode = mlxsw_thermal_get_mode,
>  	.set_mode = mlxsw_thermal_set_mode,
>  	.get_temp = mlxsw_thermal_get_temp,
>  	.get_trip_type	= mlxsw_thermal_get_trip_type,
> @@ -462,14 +453,6 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
>  	return err;
>  }
>  
> -static int mlxsw_thermal_module_mode_get(struct thermal_zone_device *tzdev,
> -					 enum thermal_device_mode *mode)
> -{
> -	*mode = tzdev->mode;
> -
> -	return 0;
> -}
> -
>  static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
>  					 enum thermal_device_mode mode)
>  {
> @@ -591,7 +574,6 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
>  static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
>  	.bind		= mlxsw_thermal_module_bind,
>  	.unbind		= mlxsw_thermal_module_unbind,
> -	.get_mode	= mlxsw_thermal_module_mode_get,
>  	.set_mode	= mlxsw_thermal_module_mode_set,
>  	.get_temp	= mlxsw_thermal_module_temp_get,
>  	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
> @@ -630,7 +612,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
>  	.bind		= mlxsw_thermal_module_bind,
>  	.unbind		= mlxsw_thermal_module_unbind,
> -	.get_mode	= mlxsw_thermal_module_mode_get,
>  	.set_mode	= mlxsw_thermal_module_mode_set,
>  	.get_temp	= mlxsw_thermal_gearbox_temp_get,
>  	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 97b288485837..32c5fe16b7f7 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -413,17 +413,6 @@ static inline void acerhdf_enable_kernelmode(void)
>  	pr_notice("kernel mode fan control ON\n");
>  }
>  
> -static int acerhdf_get_mode(struct thermal_zone_device *thermal,
> -			    enum thermal_device_mode *mode)
> -{
> -	if (verbose)
> -		pr_notice("kernel mode fan control %d\n", kernelmode);
> -
> -	*mode = thermal->mode;
> -
> -	return 0;
> -}
> -
>  /*
>   * set operation mode;
>   * enabled: the thermal layer of the kernel takes care about
> @@ -490,7 +479,6 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
>  	.bind = acerhdf_bind,
>  	.unbind = acerhdf_unbind,
>  	.get_temp = acerhdf_get_ec_temp,
> -	.get_mode = acerhdf_get_mode,
>  	.set_mode = acerhdf_set_mode,
>  	.get_trip_type = acerhdf_get_trip_type,
>  	.get_trip_hyst = acerhdf_get_trip_hyst,
> diff --git a/drivers/thermal/da9062-thermal.c b/drivers/thermal/da9062-thermal.c
> index a14c7981c7c7..a7ac8afb063e 100644
> --- a/drivers/thermal/da9062-thermal.c
> +++ b/drivers/thermal/da9062-thermal.c
> @@ -120,13 +120,6 @@ static irqreturn_t da9062_thermal_irq_handler(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> -static int da9062_thermal_get_mode(struct thermal_zone_device *z,
> -				   enum thermal_device_mode *mode)
> -{
> -	*mode = z->mode;
> -	return 0;
> -}
> -
>  static int da9062_thermal_get_trip_type(struct thermal_zone_device *z,
>  					int trip,
>  					enum thermal_trip_type *type)
> @@ -179,7 +172,6 @@ static int da9062_thermal_get_temp(struct thermal_zone_device *z,
>  
>  static struct thermal_zone_device_ops da9062_thermal_ops = {
>  	.get_temp	= da9062_thermal_get_temp,
> -	.get_mode	= da9062_thermal_get_mode,
>  	.get_trip_type	= da9062_thermal_get_trip_type,
>  	.get_trip_temp	= da9062_thermal_get_trip_temp,
>  };
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index 9a1114d721b6..2c7ee5da608a 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -330,14 +330,6 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  	return 0;
>  }
>  
> -static int imx_get_mode(struct thermal_zone_device *tz,
> -			enum thermal_device_mode *mode)
> -{
> -	*mode = tz->mode;
> -
> -	return 0;
> -}
> -
>  static int imx_set_mode(struct thermal_zone_device *tz,
>  			enum thermal_device_mode mode)
>  {
> @@ -464,7 +456,6 @@ static struct thermal_zone_device_ops imx_tz_ops = {
>  	.bind = imx_bind,
>  	.unbind = imx_unbind,
>  	.get_temp = imx_get_temp,
> -	.get_mode = imx_get_mode,
>  	.set_mode = imx_set_mode,
>  	.get_trip_type = imx_get_trip_type,
>  	.get_trip_temp = imx_get_trip_temp,
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index f65b2fc09198..9a622aaf29dd 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -377,14 +377,6 @@ static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
>  	return 0;
>  }
>  
> -static int int3400_thermal_get_mode(struct thermal_zone_device *thermal,
> -				enum thermal_device_mode *mode)
> -{
> -	*mode = thermal->mode;
> -
> -	return 0;
> -}
> -
>  static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>  				enum thermal_device_mode mode)
>  {
> @@ -412,7 +404,6 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>  
>  static struct thermal_zone_device_ops int3400_thermal_ops = {
>  	.get_temp = int3400_thermal_get_temp,
> -	.get_mode = int3400_thermal_get_mode,
>  	.set_mode = int3400_thermal_set_mode,
>  };
>  
> diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
> index d77cb3df5ade..c4879b4bfbf1 100644
> --- a/drivers/thermal/intel/intel_quark_dts_thermal.c
> +++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
> @@ -308,13 +308,6 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd,
>  	return 0;
>  }
>  
> -static int sys_get_mode(struct thermal_zone_device *tzd,
> -				enum thermal_device_mode *mode)
> -{
> -	*mode = tzd->mode;
> -	return 0;
> -}
> -
>  static int sys_set_mode(struct thermal_zone_device *tzd,
>  				enum thermal_device_mode mode)
>  {
> @@ -336,7 +329,6 @@ static struct thermal_zone_device_ops tzone_ops = {
>  	.get_trip_type = sys_get_trip_type,
>  	.set_trip_temp = sys_set_trip_temp,
>  	.get_crit_temp = sys_get_crit_temp,
> -	.get_mode = sys_get_mode,
>  	.set_mode = sys_set_mode,
>  };
>  
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index b71196eaf90e..14d3b1b94c4f 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1456,7 +1456,6 @@ static int thermal_pm_notify(struct notifier_block *nb,
>  			     unsigned long mode, void *_unused)
>  {
>  	struct thermal_zone_device *tz;
> -	enum thermal_device_mode tz_mode;
>  
>  	switch (mode) {
>  	case PM_HIBERNATION_PREPARE:
> @@ -1469,11 +1468,7 @@ static int thermal_pm_notify(struct notifier_block *nb,
>  	case PM_POST_SUSPEND:
>  		atomic_set(&in_suspend, 0);
>  		list_for_each_entry(tz, &thermal_tz_list, node) {
> -			tz_mode = THERMAL_DEVICE_ENABLED;
> -			if (tz->ops->get_mode)
> -				tz->ops->get_mode(tz, &tz_mode);
> -
> -			if (tz_mode == THERMAL_DEVICE_DISABLED)
> +			if (tz->mode == THERMAL_DEVICE_DISABLED)
>  				continue;
>  
>  			thermal_zone_device_init(tz);
> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
> index c495b1e48ef2..ba65d48a48cb 100644
> --- a/drivers/thermal/thermal_of.c
> +++ b/drivers/thermal/thermal_of.c
> @@ -267,14 +267,6 @@ static int of_thermal_unbind(struct thermal_zone_device *thermal,
>  	return 0;
>  }
>  
> -static int of_thermal_get_mode(struct thermal_zone_device *tz,
> -			       enum thermal_device_mode *mode)
> -{
> -	*mode = tz->mode;
> -
> -	return 0;
> -}
> -
>  static int of_thermal_set_mode(struct thermal_zone_device *tz,
>  			       enum thermal_device_mode mode)
>  {
> @@ -389,7 +381,6 @@ static int of_thermal_get_crit_temp(struct thermal_zone_device *tz,
>  }
>  
>  static struct thermal_zone_device_ops of_thermal_ops = {
> -	.get_mode = of_thermal_get_mode,
>  	.set_mode = of_thermal_set_mode,
>  
>  	.get_trip_type = of_thermal_get_trip_type,
> diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
> index aa99edb4dff7..096370977068 100644
> --- a/drivers/thermal/thermal_sysfs.c
> +++ b/drivers/thermal/thermal_sysfs.c
> @@ -49,18 +49,9 @@ static ssize_t
>  mode_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>  	struct thermal_zone_device *tz = to_thermal_zone(dev);
> -	enum thermal_device_mode mode;
> -	int result;
> -
> -	if (!tz->ops->get_mode)
> -		return -EPERM;
>  
> -	result = tz->ops->get_mode(tz, &mode);
> -	if (result)
> -		return result;
> -
> -	return sprintf(buf, "%s\n", mode == THERMAL_DEVICE_ENABLED ? "enabled"
> -		       : "disabled");
> +	return sprintf(buf, "%s\n", tz->mode == THERMAL_DEVICE_ENABLED ?
> +		       "enabled" : "disabled");
>  }
>  
>  static ssize_t
> @@ -428,30 +419,13 @@ static struct attribute_group thermal_zone_attribute_group = {
>  	.attrs = thermal_zone_dev_attrs,
>  };
>  
> -/* We expose mode only if .get_mode is present */
>  static struct attribute *thermal_zone_mode_attrs[] = {
>  	&dev_attr_mode.attr,
>  	NULL,
>  };
>  
> -static umode_t thermal_zone_mode_is_visible(struct kobject *kobj,
> -					    struct attribute *attr,
> -					    int attrno)
> -{
> -	struct device *dev = container_of(kobj, struct device, kobj);
> -	struct thermal_zone_device *tz;
> -
> -	tz = container_of(dev, struct thermal_zone_device, device);
> -
> -	if (tz->ops->get_mode)
> -		return attr->mode;
> -
> -	return 0;
> -}
> -
>  static struct attribute_group thermal_zone_mode_attribute_group = {
>  	.attrs = thermal_zone_mode_attrs,
> -	.is_visible = thermal_zone_mode_is_visible,
>  };
>  
>  /* We expose passive only if passive trips are present */
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 5f91d7f04512..a808f6fa2777 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -76,8 +76,6 @@ struct thermal_zone_device_ops {
>  		       struct thermal_cooling_device *);
>  	int (*get_temp) (struct thermal_zone_device *, int *);
>  	int (*set_trips) (struct thermal_zone_device *, int, int);
> -	int (*get_mode) (struct thermal_zone_device *,
> -			 enum thermal_device_mode *);
>  	int (*set_mode) (struct thermal_zone_device *,
>  		enum thermal_device_mode);
>  	int (*get_trip_type) (struct thermal_zone_device *, int,
