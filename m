Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E886120703A
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389863AbgFXJkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:40:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57809 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388031AbgFXJkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:40:22 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200624094019euoutp01c22ce6db0bd57d134ad5b3130856c9ae~bcXAzoJ1g1896718967euoutp015;
        Wed, 24 Jun 2020 09:40:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200624094019euoutp01c22ce6db0bd57d134ad5b3130856c9ae~bcXAzoJ1g1896718967euoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592991619;
        bh=Ct+poZblF6q/DbL6WZ332O51gLnb+fEADhFwlTzvJng=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=KnSepGIOpQoXVLELf2RknugsSBbrE0ElnnXP8XTA6444r0P1swf09D/uIsSXpXhwU
         gT/7KmCGWXnVKxqGr33RPZkELCSGtvY7nyiigp80t43JnVjxsnK0WoxqAwiXNosrQs
         c44cAYaWya0dm5nmVZDnbs+HItEzDRrC/X3oYI7Q=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200624094019eucas1p2d6378152839e69ab8acc76462c754a1e~bcXArA7vO1544215442eucas1p2K;
        Wed, 24 Jun 2020 09:40:19 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 27.0C.05997.38F13FE5; Wed, 24
        Jun 2020 10:40:19 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200624094019eucas1p225c55c3d72ba553eca73ada3283401c8~bcXAHztP01544215442eucas1p2J;
        Wed, 24 Jun 2020 09:40:19 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200624094019eusmtrp2a2d2edd1ca5f469598e3f0faa6320813~bcXAGEcyf1817018170eusmtrp2n;
        Wed, 24 Jun 2020 09:40:19 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-23-5ef31f8363d3
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 61.52.06314.28F13FE5; Wed, 24
        Jun 2020 10:40:19 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200624094017eusmtip124d7264c988a38d49c6239d4dd12f135~bcW_M9yez0057600576eusmtip1d;
        Wed, 24 Jun 2020 09:40:17 +0000 (GMT)
Subject: Re: [PATCH v4 04/11] thermal: Store device mode in struct
 thermal_zone_device
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
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
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, kernel@collabora.com
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <bcdb1c77-97f0-bcad-8c28-6b849d7fde9f@samsung.com>
Date:   Wed, 24 Jun 2020 11:40:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200528192051.28034-5-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTZxTOe7+LK7lWHO+ci0mnZLpJdS7LGSrZV5Ybo9mWZQnRWa14h26A
        rAU2tx/KFJVOQcqw2hEFJLbFRVkLLUUkG3XgwHU4MpgGFrCsFmf5qhtpp2W9XMz49zznnOc8
        53mTlyNVZewSbm9uvqjP1WWrmQTK1RHxrT60LKxdMxp5DuzXYxRM+yIEXPD/QYHp9AwJ3xUN
        E3A2/AxU/XKYAmPNGih2DdIw/NvbcCR8moKZO3/F2fdvwK2iKwRUBQvhjs3CgtN3nIb6Sg8F
        tfYaBjzDIQasbWUIHP4+GoxROwnhE9cQNI2OETA1FDe6bxtgocRZjsDbVE2A92gbDR3VT0Ln
        qVIazBPfIOjp+QAutgZJuNH9Kw0jw6UMPHI7KAg2JkP3lXy4WnyTBKejkoS+6jAF1qEW9tUX
        hLPffiH82VxFC72lJwihebAOCY32W4Rgm9IIHssgKzhtq4TzraOE4KgvYYSBvlZGGPP54vW6
        A8Lk/RFWCJi9hHByIsS8g7cmbNgtZu8tFPWa9J0Je25UMHmRr9BngV4/dRCN5xkRx2H+JTwW
        SzeiBE7F2xCervyXkckDhGv7j8+RMMLmaB1hRIpZhcnhnmtYER6vuUnLJIRwX1cNK+1dxGfg
        gEMhCZL4dTjiCrHSDMkblTh0t42VGgyfhsuP1iMJK/l0bJ3uncUUvwLfHgrREl4c3zM15KXl
        mYX4pzMjlIQV/Eb80NU/Wyf5ZHx75Bwh42XYHaoiJTPM/6PA49FDlHz2m3gi5GdkvAjf62xk
        ZbwUz3gksSS4hPCjY8E5tRtha0VsTrEeD/iijBSN5Ffiyy0aufwa/jpqYuWXTMS/hxbKRyRi
        k8tMymUlPnZEJU+n4IYLDcxjW6PHTp5Easu8aJZ5cSzz4lj+961GVD1KFgsMOVmi4cVc8dNU
        gy7HUJCblZq5L8eB4t+kO9b5oBm1PNzVjngOqZ9QNgxNalW0rtCwP6cdYY5UJylf/7lbq1Lu
        1u3/XNTv26EvyBYN7ehpjlInK9fVjm5X8Vm6fPFjUcwT9Y+7BKdYchBd2vruqTPapuiCNH7T
        ytTVPW/t+CH1/aRwTOHa/ve9jzTntpXQKtMrO9uXp1wP1HFlGm+atrSr40vzFvWzpqda1i9f
        +/JV44qK/g2Jlw9s9m/zTx7+xF1e/OFGcvGCHycMgWDWe2O+bG1FY2RTyt2lXY7zmWm7nNd6
        MzwXNz8fyajNtBepKcMe3dpVpN6g+w8UNF7lIgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTVxiAd+5Xb5nN7iqOE4Jxqy4mTIvl88UI+0q2myVuJvzZmEM7vAEj
        bUnvhaFs0W6iWLSjbAorhNWBo0UzR6tQxkcUVLbgOlZcF40sfK3BQB3aH9LJZLewJfx7zpvn
        OScneVlS7WQS2f1GSTAb9SUaJo4afjI0tvWzDZGCbV0LBLh/fELBI3+UgG+n/qCgrmGJhA7L
        BAHNkfXQ9MtRCqxnt0FV5xgNE7+9A8ciDRQsTc7Kpyuvw21LDwFNM+Uw6XIowOs/SUP76W4K
        vnGfZaB7IsxAW//nCDxTQRqsf7tJiJy6huDyvfsEPByXH5pz3VXACa8dweBlJwGDx/tpuOF8
        DobO2Gion29EMDKyG873zpBwczhAw/SEjYF/ujwUzFxKgOEeCfqqfiXB6zlNQtAZoaBt/AfF
        K1v45guV/J++JpoftZ0ieN9YK+IvuW8TvOthCt/tGFPwXlcy39J7j+A97ScY/m6wl+Hv+/3y
        vPUw/2BuWsGH6gcJvnY+zOzC+dodZlOZJDxfbBKlHM37OkjV6rJBm5qerdWlZX2wPTVDk5K7
        Y59Qsr9cMKfk7tUW3/yCKY3WoIrQ6BR1BP1VakVKFnPpuM7TxcRYzZ1DuNVVaUWsPE/CQxfL
        V5S1eDFolZU4WZlF+FZjGMWctdy7OORRxpx4Lg1HO8OKmENyNhXuCV1QrARVBJ6cPbb8AMNt
        x/bj7SjGKi4Xtz0aXWaKexHfGQ/TMV4nXzroc/znPIt/+mqairGSy8GLnb8vOyS3GS82B8gV
        TsB3pr8mVngD7go3kbVI7ViVO1YljlWJY1XiRFQ7ihfKREORQdRpRb1BLDMWaQtNBg+St7Pz
        RtTrQ4GOvAHEsUizRvX9+IMCNa0vFw8aBhBmSU286rWfhwvUqn36g4cEs2mPuaxEEAdQhvw5
        O5m4rtAk77pR2qPL0GVBti4rLSstEzQJqmru6m41V6SXhAOCUCqY/+8IVpl4BBn6Lrbar+4k
        7Ec/bDxnkbQvfXmlbmP1C4feqEiyGYOBgGVTy9KI1HHgk8cvz62vycxvY32FT1+rb8m/9bjy
        vYLM6hp/QIq7XssOva1c0705p4F1RJMq+mzu68nf1fUuLPTvfSr705B3UmkefeuZNz/6OC/9
        vJfc9Kq372Rl3twuy/xhDSUW63XJpFnU/wsVWqYZswMAAA==
X-CMS-MailID: 20200624094019eucas1p225c55c3d72ba553eca73ada3283401c8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528192159eucas1p2c6eecd9a88366d3ba94c62e896a2d130
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528192159eucas1p2c6eecd9a88366d3ba94c62e896a2d130
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
        <20200528192051.28034-1-andrzej.p@collabora.com>
        <CGME20200528192159eucas1p2c6eecd9a88366d3ba94c62e896a2d130@eucas1p2.samsung.com>
        <20200528192051.28034-5-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
> Prepare for eliminating get_mode().
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
>  drivers/acpi/thermal.c                        | 18 ++++++----------
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 21 +++++++------------
>  drivers/platform/x86/acerhdf.c                | 15 ++++++-------
>  drivers/thermal/da9062-thermal.c              |  6 ++----
>  drivers/thermal/imx_thermal.c                 | 17 +++++++--------
>  .../intel/int340x_thermal/int3400_thermal.c   | 12 +++--------
>  .../thermal/intel/intel_quark_dts_thermal.c   | 16 +++++++-------
>  drivers/thermal/thermal_of.c                  | 10 +++------
>  8 files changed, 44 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index fb46070c66d8..4ba273f49d87 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -172,7 +172,6 @@ struct acpi_thermal {
>  	struct acpi_thermal_trips trips;
>  	struct acpi_handle_list devices;
>  	struct thermal_zone_device *thermal_zone;
> -	enum thermal_device_mode mode;
>  	int kelvin_offset;	/* in millidegrees */
>  	struct work_struct thermal_check_work;
>  };
> @@ -500,7 +499,7 @@ static void acpi_thermal_check(void *data)
>  {
>  	struct acpi_thermal *tz = data;
>  
> -	if (tz->mode != THERMAL_DEVICE_ENABLED)
> +	if (tz->thermal_zone->mode != THERMAL_DEVICE_ENABLED)
>  		return;
>  
>  	thermal_zone_device_update(tz->thermal_zone,
> @@ -529,12 +528,7 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
>  static int thermal_get_mode(struct thermal_zone_device *thermal,
>  				enum thermal_device_mode *mode)
>  {
> -	struct acpi_thermal *tz = thermal->devdata;
> -
> -	if (!tz)
> -		return -EINVAL;
> -
> -	*mode = tz->mode;
> +	*mode = thermal->mode;
>  
>  	return 0;
>  }
> @@ -556,11 +550,11 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
>  	if (mode == THERMAL_DEVICE_DISABLED)
>  		pr_warn("thermal zone will be disabled\n");
>  
> -	if (mode != tz->mode) {
> -		tz->mode = mode;
> +	if (mode != tz->thermal_zone->mode) {
> +		tz->thermal_zone->mode = mode;
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>  			"%s kernel ACPI thermal control\n",
> -			tz->mode == THERMAL_DEVICE_ENABLED ?
> +			tz->thermal_zone->mode == THERMAL_DEVICE_ENABLED ?
>  			"Enable" : "Disable"));
>  		acpi_thermal_check(tz);
>  	}
> @@ -912,7 +906,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>  		goto remove_dev_link;
>  	}
>  
> -	tz->mode = THERMAL_DEVICE_ENABLED;
> +	tz->thermal_zone->mode = THERMAL_DEVICE_ENABLED;
>  
>  	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
>  		 tz->thermal_zone->id);
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index ce0a6837daa3..aa082e8a0b13 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -98,7 +98,6 @@ struct mlxsw_thermal_module {
>  	struct mlxsw_thermal *parent;
>  	struct thermal_zone_device *tzdev;
>  	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
> -	enum thermal_device_mode mode;
>  	int module; /* Module or gearbox number */
>  };
>  
> @@ -110,7 +109,6 @@ struct mlxsw_thermal {
>  	struct thermal_cooling_device *cdevs[MLXSW_MFCR_PWMS_MAX];
>  	u8 cooling_levels[MLXSW_THERMAL_MAX_STATE + 1];
>  	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
> -	enum thermal_device_mode mode;
>  	struct mlxsw_thermal_module *tz_module_arr;
>  	u8 tz_module_num;
>  	struct mlxsw_thermal_module *tz_gearbox_arr;
> @@ -280,9 +278,7 @@ static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
>  static int mlxsw_thermal_get_mode(struct thermal_zone_device *tzdev,
>  				  enum thermal_device_mode *mode)
>  {
> -	struct mlxsw_thermal *thermal = tzdev->devdata;
> -
> -	*mode = thermal->mode;
> +	*mode = tzdev->mode;
>  
>  	return 0;
>  }
> @@ -299,9 +295,9 @@ static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
>  	else
>  		tzdev->polling_delay = 0;
>  
> +	tzdev->mode = mode;
>  	mutex_unlock(&tzdev->lock);
>  
> -	thermal->mode = mode;
>  	thermal_zone_device_update(tzdev, THERMAL_EVENT_UNSPECIFIED);
>  
>  	return 0;
> @@ -469,9 +465,7 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
>  static int mlxsw_thermal_module_mode_get(struct thermal_zone_device *tzdev,
>  					 enum thermal_device_mode *mode)
>  {
> -	struct mlxsw_thermal_module *tz = tzdev->devdata;
> -
> -	*mode = tz->mode;
> +	*mode = tzdev->mode;
>  
>  	return 0;
>  }
> @@ -489,9 +483,10 @@ static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
>  	else
>  		tzdev->polling_delay = 0;
>  
> +	tzdev->mode = mode;
> +
>  	mutex_unlock(&tzdev->lock);
>  
> -	tz->mode = mode;
>  	thermal_zone_device_update(tzdev, THERMAL_EVENT_UNSPECIFIED);
>  
>  	return 0;
> @@ -765,7 +760,7 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
>  		return err;
>  	}
>  
> -	module_tz->mode = THERMAL_DEVICE_ENABLED;
> +	module_tz->tzdev->mode = THERMAL_DEVICE_ENABLED;
>  	return 0;
>  }
>  
> @@ -881,7 +876,7 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
>  	if (IS_ERR(gearbox_tz->tzdev))
>  		return PTR_ERR(gearbox_tz->tzdev);
>  
> -	gearbox_tz->mode = THERMAL_DEVICE_ENABLED;
> +	gearbox_tz->tzdev->mode = THERMAL_DEVICE_ENABLED;
>  	return 0;
>  }
>  
> @@ -1050,7 +1045,7 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
>  	if (err)
>  		goto err_unreg_modules_tzdev;
>  
> -	thermal->mode = THERMAL_DEVICE_ENABLED;
> +	thermal->tzdev->mode = THERMAL_DEVICE_ENABLED;
>  	*p_thermal = thermal;
>  	return 0;
>  
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 830a8b060e74..97b288485837 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -68,7 +68,6 @@ static int kernelmode = 1;
>  #else
>  static int kernelmode;
>  #endif
> -static enum thermal_device_mode thermal_mode;
>  
>  static unsigned int interval = 10;
>  static unsigned int fanon = 60000;
> @@ -398,15 +397,16 @@ static inline void acerhdf_revert_to_bios_mode(void)
>  {
>  	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>  	kernelmode = 0;
> -	thermal_mode = THERMAL_DEVICE_DISABLED;
> -	if (thz_dev)
> +	if (thz_dev) {
> +		thz_dev->mode = THERMAL_DEVICE_DISABLED;
>  		thz_dev->polling_delay = 0;
> +	}
>  	pr_notice("kernel mode fan control OFF\n");
>  }
>  static inline void acerhdf_enable_kernelmode(void)
>  {
>  	kernelmode = 1;
> -	thermal_mode = THERMAL_DEVICE_ENABLED;
> +	thz_dev->mode = THERMAL_DEVICE_ENABLED;
>  
>  	thz_dev->polling_delay = interval*1000;
>  	thermal_zone_device_update(thz_dev, THERMAL_EVENT_UNSPECIFIED);
> @@ -419,7 +419,7 @@ static int acerhdf_get_mode(struct thermal_zone_device *thermal,
>  	if (verbose)
>  		pr_notice("kernel mode fan control %d\n", kernelmode);
>  
> -	*mode = thermal_mode;
> +	*mode = thermal->mode;
>  
>  	return 0;
>  }
> @@ -741,8 +741,6 @@ static int __init acerhdf_register_thermal(void)
>  	if (IS_ERR(cl_dev))
>  		return -EINVAL;
>  
> -	thermal_mode = kernelmode ?
> -		THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED;
>  	thz_dev = thermal_zone_device_register("acerhdf", 2, 0, NULL,
>  					      &acerhdf_dev_ops,
>  					      &acerhdf_zone_params, 0,
> @@ -750,6 +748,9 @@ static int __init acerhdf_register_thermal(void)
>  	if (IS_ERR(thz_dev))
>  		return -EINVAL;
>  
> +	thz_dev->mode = kernelmode ?
> +		THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED;
> +
>  	if (strcmp(thz_dev->governor->name,
>  				acerhdf_zone_params.governor_name)) {
>  		pr_err("Didn't get thermal governor %s, perhaps not compiled into thermal subsystem.\n",
> diff --git a/drivers/thermal/da9062-thermal.c b/drivers/thermal/da9062-thermal.c
> index c32709badeda..a14c7981c7c7 100644
> --- a/drivers/thermal/da9062-thermal.c
> +++ b/drivers/thermal/da9062-thermal.c
> @@ -49,7 +49,6 @@ struct da9062_thermal {
>  	struct da9062 *hw;
>  	struct delayed_work work;
>  	struct thermal_zone_device *zone;
> -	enum thermal_device_mode mode;
>  	struct mutex lock; /* protection for da9062_thermal temperature */
>  	int temperature;
>  	int irq;
> @@ -124,8 +123,7 @@ static irqreturn_t da9062_thermal_irq_handler(int irq, void *data)
>  static int da9062_thermal_get_mode(struct thermal_zone_device *z,
>  				   enum thermal_device_mode *mode)
>  {
> -	struct da9062_thermal *thermal = z->devdata;
> -	*mode = thermal->mode;
> +	*mode = z->mode;
>  	return 0;
>  }
>  
> @@ -233,7 +231,6 @@ static int da9062_thermal_probe(struct platform_device *pdev)
>  
>  	thermal->config = match->data;
>  	thermal->hw = chip;
> -	thermal->mode = THERMAL_DEVICE_ENABLED;
>  	thermal->dev = &pdev->dev;
>  
>  	INIT_DELAYED_WORK(&thermal->work, da9062_thermal_poll_on);
> @@ -248,6 +245,7 @@ static int da9062_thermal_probe(struct platform_device *pdev)
>  		ret = PTR_ERR(thermal->zone);
>  		goto err;
>  	}
> +	thermal->zone->mode = THERMAL_DEVICE_ENABLED;
>  
>  	dev_dbg(&pdev->dev,
>  		"TJUNC temperature polling period set at %d ms\n",
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index e761c9b42217..9a1114d721b6 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -197,7 +197,6 @@ struct imx_thermal_data {
>  	struct cpufreq_policy *policy;
>  	struct thermal_zone_device *tz;
>  	struct thermal_cooling_device *cdev;
> -	enum thermal_device_mode mode;
>  	struct regmap *tempmon;
>  	u32 c1, c2; /* See formula in imx_init_calib() */
>  	int temp_passive;
> @@ -256,7 +255,7 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  	bool wait;
>  	u32 val;
>  
> -	if (data->mode == THERMAL_DEVICE_ENABLED) {
> +	if (tz->mode == THERMAL_DEVICE_ENABLED) {
>  		/* Check if a measurement is currently in progress */
>  		regmap_read(map, soc_data->temp_data, &val);
>  		wait = !(val & soc_data->temp_valid_mask);
> @@ -283,7 +282,7 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  
>  	regmap_read(map, soc_data->temp_data, &val);
>  
> -	if (data->mode != THERMAL_DEVICE_ENABLED) {
> +	if (tz->mode != THERMAL_DEVICE_ENABLED) {
>  		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>  			     soc_data->measure_temp_mask);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
> @@ -334,9 +333,7 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  static int imx_get_mode(struct thermal_zone_device *tz,
>  			enum thermal_device_mode *mode)
>  {
> -	struct imx_thermal_data *data = tz->devdata;
> -
> -	*mode = data->mode;
> +	*mode = tz->mode;
>  
>  	return 0;
>  }
> @@ -376,7 +373,7 @@ static int imx_set_mode(struct thermal_zone_device *tz,
>  		}
>  	}
>  
> -	data->mode = mode;
> +	tz->mode = mode;
>  	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
>  
>  	return 0;
> @@ -831,7 +828,7 @@ static int imx_thermal_probe(struct platform_device *pdev)
>  		     data->socdata->measure_temp_mask);
>  
>  	data->irq_enabled = true;
> -	data->mode = THERMAL_DEVICE_ENABLED;
> +	data->tz->mode = THERMAL_DEVICE_ENABLED;
>  
>  	ret = devm_request_threaded_irq(&pdev->dev, data->irq,
>  			imx_thermal_alarm_irq, imx_thermal_alarm_irq_thread,
> @@ -885,7 +882,7 @@ static int __maybe_unused imx_thermal_suspend(struct device *dev)
>  		     data->socdata->measure_temp_mask);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->power_down_mask);
> -	data->mode = THERMAL_DEVICE_DISABLED;
> +	data->tz->mode = THERMAL_DEVICE_DISABLED;
>  	clk_disable_unprepare(data->thermal_clk);
>  
>  	return 0;
> @@ -905,7 +902,7 @@ static int __maybe_unused imx_thermal_resume(struct device *dev)
>  		     data->socdata->power_down_mask);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->measure_temp_mask);
> -	data->mode = THERMAL_DEVICE_ENABLED;
> +	data->tz->mode = THERMAL_DEVICE_ENABLED;
>  
>  	return 0;
>  }
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index e84faaadff87..f65b2fc09198 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -48,7 +48,6 @@ struct int3400_thermal_priv {
>  	struct acpi_device *adev;
>  	struct platform_device *pdev;
>  	struct thermal_zone_device *thermal;
> -	enum thermal_device_mode mode;
>  	int art_count;
>  	struct art *arts;
>  	int trt_count;
> @@ -381,12 +380,7 @@ static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
>  static int int3400_thermal_get_mode(struct thermal_zone_device *thermal,
>  				enum thermal_device_mode *mode)
>  {
> -	struct int3400_thermal_priv *priv = thermal->devdata;
> -
> -	if (!priv)
> -		return -EINVAL;
> -
> -	*mode = priv->mode;
> +	*mode = thermal->mode;
>  
>  	return 0;
>  }
> @@ -404,8 +398,8 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>  	    mode != THERMAL_DEVICE_DISABLED)
>  		return -EINVAL;
>  
> -	if (mode != priv->mode) {
> -		priv->mode = mode;
> +	if (mode != thermal->mode) {
> +		thermal->mode = mode;
>  		result = int3400_thermal_run_osc(priv->adev->handle,
>  						priv->current_uuid_index,
>  						mode == THERMAL_DEVICE_ENABLED);
> diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
> index d704fc104cfd..d77cb3df5ade 100644
> --- a/drivers/thermal/intel/intel_quark_dts_thermal.c
> +++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
> @@ -103,7 +103,6 @@ struct soc_sensor_entry {
>  	bool locked;
>  	u32 store_ptps;
>  	u32 store_dts_enable;
> -	enum thermal_device_mode mode;
>  	struct thermal_zone_device *tzone;
>  };
>  
> @@ -128,7 +127,7 @@ static int soc_dts_enable(struct thermal_zone_device *tzd)
>  		return ret;
>  
>  	if (out & QRK_DTS_ENABLE_BIT) {
> -		aux_entry->mode = THERMAL_DEVICE_ENABLED;
> +		tzd->mode = THERMAL_DEVICE_ENABLED;
>  		return 0;
>  	}
>  
> @@ -139,9 +138,9 @@ static int soc_dts_enable(struct thermal_zone_device *tzd)
>  		if (ret)
>  			return ret;
>  
> -		aux_entry->mode = THERMAL_DEVICE_ENABLED;
> +		tzd->mode = THERMAL_DEVICE_ENABLED;
>  	} else {
> -		aux_entry->mode = THERMAL_DEVICE_DISABLED;
> +		tzd->mode = THERMAL_DEVICE_DISABLED;
>  		pr_info("DTS is locked. Cannot enable DTS\n");
>  		ret = -EPERM;
>  	}
> @@ -161,7 +160,7 @@ static int soc_dts_disable(struct thermal_zone_device *tzd)
>  		return ret;
>  
>  	if (!(out & QRK_DTS_ENABLE_BIT)) {
> -		aux_entry->mode = THERMAL_DEVICE_DISABLED;
> +		tzd->mode = THERMAL_DEVICE_DISABLED;
>  		return 0;
>  	}
>  
> @@ -173,9 +172,9 @@ static int soc_dts_disable(struct thermal_zone_device *tzd)
>  		if (ret)
>  			return ret;
>  
> -		aux_entry->mode = THERMAL_DEVICE_DISABLED;
> +		tzd->mode = THERMAL_DEVICE_DISABLED;
>  	} else {
> -		aux_entry->mode = THERMAL_DEVICE_ENABLED;
> +		tzd->mode = THERMAL_DEVICE_ENABLED;
>  		pr_info("DTS is locked. Cannot disable DTS\n");
>  		ret = -EPERM;
>  	}
> @@ -312,8 +311,7 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd,
>  static int sys_get_mode(struct thermal_zone_device *tzd,
>  				enum thermal_device_mode *mode)
>  {
> -	struct soc_sensor_entry *aux_entry = tzd->devdata;
> -	*mode = aux_entry->mode;
> +	*mode = tzd->mode;
>  	return 0;
>  }
>  
> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
> index ddf88dbe7ba2..c495b1e48ef2 100644
> --- a/drivers/thermal/thermal_of.c
> +++ b/drivers/thermal/thermal_of.c
> @@ -51,7 +51,6 @@ struct __thermal_bind_params {
>  
>  /**
>   * struct __thermal_zone - internal representation of a thermal zone
> - * @mode: current thermal zone device mode (enabled/disabled)
>   * @passive_delay: polling interval while passive cooling is activated
>   * @polling_delay: zone polling interval
>   * @slope: slope of the temperature adjustment curve
> @@ -65,7 +64,6 @@ struct __thermal_bind_params {
>   */
>  
>  struct __thermal_zone {
> -	enum thermal_device_mode mode;
>  	int passive_delay;
>  	int polling_delay;
>  	int slope;
> @@ -272,9 +270,7 @@ static int of_thermal_unbind(struct thermal_zone_device *thermal,
>  static int of_thermal_get_mode(struct thermal_zone_device *tz,
>  			       enum thermal_device_mode *mode)
>  {
> -	struct __thermal_zone *data = tz->devdata;
> -
> -	*mode = data->mode;
> +	*mode = tz->mode;
>  
>  	return 0;
>  }
> @@ -296,7 +292,7 @@ static int of_thermal_set_mode(struct thermal_zone_device *tz,
>  
>  	mutex_unlock(&tz->lock);
>  
> -	data->mode = mode;
> +	tz->mode = mode;
>  	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
>  
>  	return 0;
> @@ -979,7 +975,6 @@ __init *thermal_of_build_thermal_zone(struct device_node *np)
>  
>  finish:
>  	of_node_put(child);
> -	tz->mode = THERMAL_DEVICE_DISABLED;
>  
>  	return tz;
>  
> @@ -1134,6 +1129,7 @@ int __init of_parse_thermal_zones(void)
>  			of_thermal_free_zone(tz);
>  			/* attempting to build remaining zones still */
>  		}
> +		zone->mode = THERMAL_DEVICE_DISABLED;
>  	}
>  	of_node_put(np);
>  
> 
