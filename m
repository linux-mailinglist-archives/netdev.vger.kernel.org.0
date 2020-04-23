Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1F51B5E02
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgDWOjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:39:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35733 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbgDWOjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:39:12 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200423143908euoutp01f40b5b70d0b221816e7ecb7ac1d38e7c~IecNmu3FY1844818448euoutp01U
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 14:39:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200423143908euoutp01f40b5b70d0b221816e7ecb7ac1d38e7c~IecNmu3FY1844818448euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587652748;
        bh=SBNF20hI8SSQxjG4D8UoygigIhAA2aGDZeup/Cj3UhU=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=qckrouHnx2R8RY2FQQEP/b+C8kbbBjV327Af1XJyhKqtj1346fw8Ln0o8wH57FKhd
         std9XeJMZlk01jr3HRaMA4ck39L7H3D+mSXToUU7dIcul7Wq3jkZwvQsAeQDyS8eHb
         GyqTL5FNwEtUzsUrSX4/hv0Rz6Og/lxMj3buBdRE=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200423143908eucas1p2ae7d84b3bb372478828dd9e610f87c68~IecNHa1ST3268732687eucas1p2z;
        Thu, 23 Apr 2020 14:39:08 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 1E.58.61286.C88A1AE5; Thu, 23
        Apr 2020 15:39:08 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200423143907eucas1p2dfe666eaad64c76f5526e6bb59319136~IecMh7zh43272532725eucas1p2J;
        Thu, 23 Apr 2020 14:39:07 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200423143907eusmtrp1301c7ada3d16c41128a88c3cdcc2c256~IecMg9YRC0045300453eusmtrp1N;
        Thu, 23 Apr 2020 14:39:07 +0000 (GMT)
X-AuditID: cbfec7f2-f0bff7000001ef66-4b-5ea1a88c4a2b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id CE.36.07950.B88A1AE5; Thu, 23
        Apr 2020 15:39:07 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200423143906eusmtip26f37ee83e28eddf8a389606f1dc08e05~IecLR4e201824218242eusmtip2b;
        Thu, 23 Apr 2020 14:39:06 +0000 (GMT)
Subject: Re: [PATCH RESEND 1/2] thermal: core: Let thermal zone device's
 mode be stored in its struct
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <a3998ad2-19bc-0893-a10d-2bb5adf7d99f@samsung.com>
Date:   Thu, 23 Apr 2020 16:39:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200422161235.5243-1-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUzMcRzHfX9Pd8Xx68R9VMZu89RGGebrYcY87Df+YPzjMQ4/1fRgdzrV
        bGpKdTtKljjpQXFXSHfl6lK0k047ikxC0qUROqxjelil61fTf6/v5/N5f9/vz/YRk9Iaxkcc
        GnGSV0YowuSMJ2Wu62tYrDXkBQXWFk/Gfxv6CHzrUxuF068Mk9gY7yBwtms2zmpMoLAmLxA7
        Xm/Hwx3faeyo2YizutS4tEFL46IMC4UtDieD9Q9TETZ9aqaxpr+QxK7ztQjX5c7Emb+uIfzi
        xX58u6qLxM/sTTTudFxg8GC5icJdZTJcnfiSxPr2StF6P67iQwHiygrfEpyhJ4Cz6D6IuFKD
        P5df9ZXgTEUpDNfaXMVwpQVnuM+ZjwnO+KOC4FIHA7neV900V/Y6ieLKm7NJLtkWs8Nrr+fa
        o3xYqJpXBqw75BmisTwnThhMRHRdcSIdh0p7kQZ5iIFdDk3Xcyg3S1kDgjf2EA3yHOHfCAaM
        9bTwcCEYyuwgxxUt5ypFQkOPIOHjyzG5E4E919fN09lgqG/NItzszS6DPrNT5GaS7RbBUOIC
        NzPsariYVDQaQ8KuA93lP6MGFDsPvjT+HuUZ7G7oaX9MCzNeUH+1c9TLg10LX9JcjPCnDN51
        5hACz4FyZxbpDgdsqgc8eu8YS70J0u6m0AJPh2+2MpHAfmC/pKUEQTGCweSuMXU5Av2lIUaY
        WgOtDf0jLB6xWAT3KgOE8gYo1rbR7jKwU6HF6SWEmArp5kxSKEsg+ZxUmJ4PJbdKmHFbjaWQ
        TENy3YTVdBPW0U1YR/ffNxdRRUjGR6nCg3nV0gj+1BKVIlwVFRG85EhkuAmN3LV9yNZTgf40
        HbYiVozkUyQtyrwgKa1Qq2LCrQjEpNxbUuLIDpJKjipiYnll5EFlVBivsiJfMSWXSZbd+HpA
        ygYrTvLHef4ErxzvEmIPnzgUO+DTnWF7nl8dl6v+G3vsdmXToLVHVnAgr+L093xz+sUnO9sW
        as9b7/8c6EjZ92DarNMrzhwaXn1VbUU3nyQQm/vP+r0L9Y9MfHXnftLceO8rvshkWcObn2ZM
        it4V6lppkMVXL4quoura0/Zv27OKcm3t31JzLKrRWGucYWs3Rvbq5ZQqRLHUn1SqFP8ArRAq
        AtMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec9lHqXBaVq+SFEsojCam5d8LTNNqDf6YBJWlM2WHtRyrna2
        kUZ0v80uVuRl2cquy6BsjtxkRVlpZakpSWaTTkmtcnYxSUurbRb47QfP//dc4GFISTsdxuTm
        6zhtvipPKgqimn43ds8uslQq5XWHpehH8xCBLr3tptDxsj8kurFTIJC5fzKqaNlDIWOlHAnP
        U9CfN59oJNxJRhVuA6ppPkSjqpMOCjkEjwhdvn0UIOvbDhoZf14hUf/h+wA1nJ2ISr+cAqi1
        NR1ddbpJ9KSpjUY9whERGqm1UshtC0W39j4j0eXXdQGJk7DddQFg25VOAlu+RWCHyRWAayzh
        +LzzA4GtVQdF+FWHU4RrLmzH70rvEfhGn53AR0fkeLC9l8a25/spXNthJvGBxoJl41fL4rUa
        vY6bmqPhdfOlaxQoUqaIQ7LI6DiZIip27dzIGGlEQnwWl5dr4LQRCetkOUbHU2KTxUpsabi2
        l94BagaBEQQykI2GL/bVBRhBECNhLwL4q9VJGQHjLUyCjdcNo5lgONxhFPlYwn4C8GFziI+D
        2WxY0nWb8nEIGwWHbnr8fUi2LwB27SqnRpvWA+i+bid8KRE7Fx7bX+WfLGYToKlkgPQxxU6H
        71u++3kCuwres5v+ZcbDR+U9/gmBbDx8X9zv34JkZ8Bhcxs5yqHwZc8ZYpSnwFpPBVkMJKYx
        ummMYhqjmMYoZwFVBUI4Pa/OVvORMl6l5vX52bJMjdoKvA91s2HIZgfGvuX1gGWAdJxYrq9U
        SmiVgS9Qew9kSGmIuFowKyXiLFVBIafVZGj1eRxfD2K8xx0jwyZkarzvma/LUMQoYlGcIjYq
        NmoOkoaKD7B30yVstkrHbeS4TZz2v0cwgWE7gIURN7kW7UsS2takLFhyp/q8PIZSujuTPyrb
        tyVtKAy39Ro6T6cWueg0oaUs/dKPjJmu1FuJhZkrtxd60s5d7cazH5DDiVkDOtu8xbbq34MT
        BaFxt3Pk8+b2n73m6qyiWZ6F4oiCaSced7U56geC8+YvLV5RIh9IXR+dk7T1a/EyKcXnqBTh
        pJZX/QWUop/BZgMAAA==
X-CMS-MailID: 20200423143907eucas1p2dfe666eaad64c76f5526e6bb59319136
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200422161252eucas1p1cd75fe80301162354d962ee708d99eeb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200422161252eucas1p1cd75fe80301162354d962ee708d99eeb
References: <20200420181741.13167-1-andrzej.p@collabora.com>
        <CGME20200422161252eucas1p1cd75fe80301162354d962ee708d99eeb@eucas1p1.samsung.com>
        <20200422161235.5243-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thank you for updating the patch, some more comments below.

On 4/22/20 6:12 PM, Andrzej Pietrasiewicz wrote:
> Thermal zone devices' mode is stored in individual drivers. This patch
> changes it so that mode is stored in struct thermal_zone_device instead.
> 
> As a result all driver-specific variables storing the mode are not needed
> and are removed. Consequently, the get_mode() implementations have nothing
> to operate on and need to be removed, too.
> 
> Some thermal framework functions are introduced:
> 
> thermal_zone_device_get_mode()
> thermal_zone_device_set_mode()
> thermal_zone_device_enable()
> thermal_zone_device_disable()
> 
> thermal_zone_device_get_mode() and its "set" counterpart take tzd's lock
> and the "set" calls driver's set_mode() if provided, so the latter must
> not take this lock again. At the end of the "set"
> thermal_zone_device_update() is called so drivers don't need to repeat this
> invocation in their specific set_mode() implementations.
> 
> struct thermal_zone_params gains a new member called initial_mode, which
> is used to set tzd's mode at registration time and if tzp is not provided
> to thermal_zone_device_register() then it is assumed that the initial
> mode is THERMAL_DEVICE_ENABLED.
> 
> The sysfs "mode" attribute is always exposed from now on, because all
> thermal zone devices now have their get_mode() implemented at the generic
> level and it is always available. Exposing "mode" doesn't hurt the drivers
> which don't provide their own set_mode(), because writing to "mode" will
> result in -EPERM, as expected.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---
> 
> Fixed two typos:
> 
> - one found by kbuild test robot <lkp@intel.com> (missing semicolon
> in dummy implementation of thermal_zone_device_set_mode()
> 
> - one found by myself (.initial_mode in int3400_thermal_params set to
> a nonexistent THERMAL_ZONE_DISABLED - should be THERMAL_DEVICE_DISABLED)

BTW Due to the above fixes the patch should have been be marked as v2,
not RESEND (please use RESEND only when posting again unchanged patch).

>  drivers/acpi/thermal.c                        | 35 ++-----------
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 42 ----------------
>  drivers/platform/x86/acerhdf.c                | 17 ++-----
>  drivers/thermal/da9062-thermal.c              | 11 -----
>  drivers/thermal/hisi_thermal.c                |  6 ++-
>  drivers/thermal/imx_thermal.c                 | 24 ++-------
>  .../intel/int340x_thermal/int3400_thermal.c   | 31 ++----------
>  .../int340x_thermal/int340x_thermal_zone.c    |  1 +
>  .../thermal/intel/intel_quark_dts_thermal.c   | 22 +++------
>  drivers/thermal/intel/x86_pkg_temp_thermal.c  |  1 +
>  drivers/thermal/of-thermal.c                  | 24 +--------
>  drivers/thermal/rockchip_thermal.c            |  6 ++-
>  drivers/thermal/sprd_thermal.c                |  6 ++-
>  drivers/thermal/thermal_core.c                | 49 ++++++++++++++++---
>  drivers/thermal/thermal_core.h                |  3 ++
>  drivers/thermal/thermal_sysfs.c               | 29 ++---------
>  include/linux/thermal.h                       | 22 ++++++++-
>  17 files changed, 107 insertions(+), 222 deletions(-)
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 19067a5e5293..d1f352ed5241 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -172,7 +172,6 @@ struct acpi_thermal {
>  	struct acpi_thermal_trips trips;
>  	struct acpi_handle_list devices;
>  	struct thermal_zone_device *thermal_zone;
> -	int tz_enabled;
>  	int kelvin_offset;	/* in millidegrees */
>  	struct work_struct thermal_check_work;
>  };
> @@ -500,7 +499,7 @@ static void acpi_thermal_check(void *data)
>  {
>  	struct acpi_thermal *tz = data;
>  
> -	if (!tz->tz_enabled)
> +	if (tz->thermal_zone->mode != THERMAL_DEVICE_ENABLED)
>  		return;
>  
>  	thermal_zone_device_update(tz->thermal_zone,
> @@ -526,25 +525,10 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
>  	return 0;
>  }
>  
> -static int thermal_get_mode(struct thermal_zone_device *thermal,
> -				enum thermal_device_mode *mode)
> -{
> -	struct acpi_thermal *tz = thermal->devdata;
> -
> -	if (!tz)
> -		return -EINVAL;
> -
> -	*mode = tz->tz_enabled ? THERMAL_DEVICE_ENABLED :
> -		THERMAL_DEVICE_DISABLED;
> -
> -	return 0;
> -}
> -
>  static int thermal_set_mode(struct thermal_zone_device *thermal,
>  				enum thermal_device_mode mode)
>  {
>  	struct acpi_thermal *tz = thermal->devdata;
> -	int enable;
>  
>  	if (!tz)
>  		return -EINVAL;
> @@ -552,20 +536,14 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
>  	/*
>  	 * enable/disable thermal management from ACPI thermal driver
>  	 */
> -	if (mode == THERMAL_DEVICE_ENABLED)
> -		enable = 1;
> -	else if (mode == THERMAL_DEVICE_DISABLED) {
> -		enable = 0;
> +	if (mode == THERMAL_DEVICE_DISABLED)
>  		pr_warn("thermal zone will be disabled\n");
> -	} else
> -		return -EINVAL;
>  
> -	if (enable != tz->tz_enabled) {
> -		tz->tz_enabled = enable;
> +	if (mode != thermal->mode) {
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>  			"%s kernel ACPI thermal control\n",
> -			tz->tz_enabled ? "Enable" : "Disable"));
> -		acpi_thermal_check(tz);
> +			mode == THERMAL_DEVICE_ENABLED ?
> +			"Enable" : "Disable"));
>  	}
>  	return 0;
>  }
> @@ -856,7 +834,6 @@ static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
>  	.bind = acpi_thermal_bind_cooling_device,
>  	.unbind	= acpi_thermal_unbind_cooling_device,
>  	.get_temp = thermal_get_temp,
> -	.get_mode = thermal_get_mode,
>  	.set_mode = thermal_set_mode,
>  	.get_trip_type = thermal_get_trip_type,
>  	.get_trip_temp = thermal_get_trip_temp,
> @@ -913,8 +890,6 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>  	if (ACPI_FAILURE(status))
>  		return -ENODEV;
>  
> -	tz->tz_enabled = 1;
> -
>  	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
>  		 tz->thermal_zone->id);
>  	return 0;
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index ce0a6837daa3..5d28384046da 100644
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
> @@ -277,33 +275,16 @@ static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
>  	return 0;
>  }
>  
> -static int mlxsw_thermal_get_mode(struct thermal_zone_device *tzdev,
> -				  enum thermal_device_mode *mode)
> -{
> -	struct mlxsw_thermal *thermal = tzdev->devdata;
> -
> -	*mode = thermal->mode;
> -
> -	return 0;
> -}
> -
>  static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
>  				  enum thermal_device_mode mode)
>  {
>  	struct mlxsw_thermal *thermal = tzdev->devdata;
>  
> -	mutex_lock(&tzdev->lock);
> -
>  	if (mode == THERMAL_DEVICE_ENABLED)
>  		tzdev->polling_delay = thermal->polling_delay;
>  	else
>  		tzdev->polling_delay = 0;
>  
> -	mutex_unlock(&tzdev->lock);
> -
> -	thermal->mode = mode;
> -	thermal_zone_device_update(tzdev, THERMAL_EVENT_UNSPECIFIED);
> -
>  	return 0;
>  }
>  
> @@ -407,7 +388,6 @@ static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_ops = {
>  	.bind = mlxsw_thermal_bind,
>  	.unbind = mlxsw_thermal_unbind,
> -	.get_mode = mlxsw_thermal_get_mode,
>  	.set_mode = mlxsw_thermal_set_mode,
>  	.get_temp = mlxsw_thermal_get_temp,
>  	.get_trip_type	= mlxsw_thermal_get_trip_type,
> @@ -466,34 +446,17 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
>  	return err;
>  }
>  
> -static int mlxsw_thermal_module_mode_get(struct thermal_zone_device *tzdev,
> -					 enum thermal_device_mode *mode)
> -{
> -	struct mlxsw_thermal_module *tz = tzdev->devdata;
> -
> -	*mode = tz->mode;
> -
> -	return 0;
> -}
> -
>  static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
>  					 enum thermal_device_mode mode)
>  {
>  	struct mlxsw_thermal_module *tz = tzdev->devdata;
>  	struct mlxsw_thermal *thermal = tz->parent;
>  
> -	mutex_lock(&tzdev->lock);
> -
>  	if (mode == THERMAL_DEVICE_ENABLED)
>  		tzdev->polling_delay = thermal->polling_delay;
>  	else
>  		tzdev->polling_delay = 0;
>  
> -	mutex_unlock(&tzdev->lock);
> -
> -	tz->mode = mode;
> -	thermal_zone_device_update(tzdev, THERMAL_EVENT_UNSPECIFIED);
> -
>  	return 0;
>  }
>  
> @@ -596,7 +559,6 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
>  static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
>  	.bind		= mlxsw_thermal_module_bind,
>  	.unbind		= mlxsw_thermal_module_unbind,
> -	.get_mode	= mlxsw_thermal_module_mode_get,
>  	.set_mode	= mlxsw_thermal_module_mode_set,
>  	.get_temp	= mlxsw_thermal_module_temp_get,
>  	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
> @@ -635,7 +597,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
>  	.bind		= mlxsw_thermal_module_bind,
>  	.unbind		= mlxsw_thermal_module_unbind,
> -	.get_mode	= mlxsw_thermal_module_mode_get,
>  	.set_mode	= mlxsw_thermal_module_mode_set,
>  	.get_temp	= mlxsw_thermal_gearbox_temp_get,
>  	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
> @@ -765,7 +726,6 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
>  		return err;
>  	}
>  
> -	module_tz->mode = THERMAL_DEVICE_ENABLED;
>  	return 0;
>  }
>  
> @@ -881,7 +841,6 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
>  	if (IS_ERR(gearbox_tz->tzdev))
>  		return PTR_ERR(gearbox_tz->tzdev);
>  
> -	gearbox_tz->mode = THERMAL_DEVICE_ENABLED;
>  	return 0;
>  }
>  
> @@ -1050,7 +1009,6 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
>  	if (err)
>  		goto err_unreg_modules_tzdev;
>  
> -	thermal->mode = THERMAL_DEVICE_ENABLED;
>  	*p_thermal = thermal;
>  	return 0;
>  
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 8cc86f4e3ac1..aaf8b845be90 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -406,22 +406,9 @@ static inline void acerhdf_enable_kernelmode(void)
>  	kernelmode = 1;
>  
>  	thz_dev->polling_delay = interval*1000;
> -	thermal_zone_device_update(thz_dev, THERMAL_EVENT_UNSPECIFIED);
>  	pr_notice("kernel mode fan control ON\n");
>  }
>  
> -static int acerhdf_get_mode(struct thermal_zone_device *thermal,
> -			    enum thermal_device_mode *mode)
> -{
> -	if (verbose)
> -		pr_notice("kernel mode fan control %d\n", kernelmode);
> -
> -	*mode = (kernelmode) ? THERMAL_DEVICE_ENABLED
> -			     : THERMAL_DEVICE_DISABLED;
> -
> -	return 0;
> -}
> -
>  /*
>   * set operation mode;
>   * enabled: the thermal layer of the kernel takes care about
> @@ -488,7 +475,6 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
>  	.bind = acerhdf_bind,
>  	.unbind = acerhdf_unbind,
>  	.get_temp = acerhdf_get_ec_temp,
> -	.get_mode = acerhdf_get_mode,
>  	.set_mode = acerhdf_set_mode,
>  	.get_trip_type = acerhdf_get_trip_type,
>  	.get_trip_hyst = acerhdf_get_trip_hyst,
> @@ -554,6 +540,7 @@ static int acerhdf_set_cur_state(struct thermal_cooling_device *cdev,
>  
>  err_out:
>  	acerhdf_revert_to_bios_mode();
> +	thz_dev->mode = THERMAL_DEVICE_DISABLED;
>  	return -EINVAL;
>  }
>  
> @@ -739,6 +726,8 @@ static int __init acerhdf_register_thermal(void)
>  	if (IS_ERR(cl_dev))
>  		return -EINVAL;
>  
> +	acerhdf_zone_params.initial_mode =
> +		kernelmode ? THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED;
>  	thz_dev = thermal_zone_device_register("acerhdf", 2, 0, NULL,
>  					      &acerhdf_dev_ops,
>  					      &acerhdf_zone_params, 0,
> diff --git a/drivers/thermal/da9062-thermal.c b/drivers/thermal/da9062-thermal.c
> index c32709badeda..c3075d038095 100644
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
> @@ -121,14 +120,6 @@ static irqreturn_t da9062_thermal_irq_handler(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> -static int da9062_thermal_get_mode(struct thermal_zone_device *z,
> -				   enum thermal_device_mode *mode)
> -{
> -	struct da9062_thermal *thermal = z->devdata;
> -	*mode = thermal->mode;
> -	return 0;
> -}
> -
>  static int da9062_thermal_get_trip_type(struct thermal_zone_device *z,
>  					int trip,
>  					enum thermal_trip_type *type)
> @@ -181,7 +172,6 @@ static int da9062_thermal_get_temp(struct thermal_zone_device *z,
>  
>  static struct thermal_zone_device_ops da9062_thermal_ops = {
>  	.get_temp	= da9062_thermal_get_temp,
> -	.get_mode	= da9062_thermal_get_mode,
>  	.get_trip_type	= da9062_thermal_get_trip_type,
>  	.get_trip_temp	= da9062_thermal_get_trip_temp,
>  };
> @@ -233,7 +223,6 @@ static int da9062_thermal_probe(struct platform_device *pdev)
>  
>  	thermal->config = match->data;
>  	thermal->hw = chip;
> -	thermal->mode = THERMAL_DEVICE_ENABLED;
>  	thermal->dev = &pdev->dev;
>  
>  	INIT_DELAYED_WORK(&thermal->work, da9062_thermal_poll_on);
> diff --git a/drivers/thermal/hisi_thermal.c b/drivers/thermal/hisi_thermal.c
> index 2d26ae80e202..ee05950afd2f 100644
> --- a/drivers/thermal/hisi_thermal.c
> +++ b/drivers/thermal/hisi_thermal.c
> @@ -549,8 +549,10 @@ static void hisi_thermal_toggle_sensor(struct hisi_thermal_sensor *sensor,
>  {
>  	struct thermal_zone_device *tzd = sensor->tzd;
>  
> -	tzd->ops->set_mode(tzd,
> -		on ? THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED);
> +	if (on)
> +		thermal_zone_device_enable(tzd);
> +	else
> +		thermal_zone_device_disable(tzd);
>  }
>  
>  static int hisi_thermal_probe(struct platform_device *pdev)
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index e761c9b42217..edbcb30815dc 100644
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
> @@ -331,16 +330,6 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  	return 0;
>  }
>  
> -static int imx_get_mode(struct thermal_zone_device *tz,
> -			enum thermal_device_mode *mode)
> -{
> -	struct imx_thermal_data *data = tz->devdata;
> -
> -	*mode = data->mode;
> -
> -	return 0;
> -}
> -
>  static int imx_set_mode(struct thermal_zone_device *tz,
>  			enum thermal_device_mode mode)
>  {
> @@ -376,9 +365,6 @@ static int imx_set_mode(struct thermal_zone_device *tz,
>  		}
>  	}
>  
> -	data->mode = mode;
> -	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
> -
>  	return 0;
>  }
>  
> @@ -467,7 +453,6 @@ static struct thermal_zone_device_ops imx_tz_ops = {
>  	.bind = imx_bind,
>  	.unbind = imx_unbind,
>  	.get_temp = imx_get_temp,
> -	.get_mode = imx_get_mode,
>  	.set_mode = imx_set_mode,
>  	.get_trip_type = imx_get_trip_type,
>  	.get_trip_temp = imx_get_trip_temp,
> @@ -831,7 +816,6 @@ static int imx_thermal_probe(struct platform_device *pdev)
>  		     data->socdata->measure_temp_mask);
>  
>  	data->irq_enabled = true;
> -	data->mode = THERMAL_DEVICE_ENABLED;
>  
>  	ret = devm_request_threaded_irq(&pdev->dev, data->irq,
>  			imx_thermal_alarm_irq, imx_thermal_alarm_irq_thread,
> @@ -885,7 +869,7 @@ static int __maybe_unused imx_thermal_suspend(struct device *dev)
>  		     data->socdata->measure_temp_mask);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->power_down_mask);
> -	data->mode = THERMAL_DEVICE_DISABLED;
> +	thermal_zone_device_disable(data->tz);

Since we now also (indirectly) call ->set_mode here the following code:

	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
		     data->socdata->measure_temp_mask);
	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
		     data->socdata->power_down_mask);

should be removed from imx_thermal_suspend().

>  	clk_disable_unprepare(data->thermal_clk);
>  
>  	return 0;
> @@ -905,7 +889,7 @@ static int __maybe_unused imx_thermal_resume(struct device *dev)
>  		     data->socdata->power_down_mask);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->measure_temp_mask);
> -	data->mode = THERMAL_DEVICE_ENABLED;
> +	thermal_zone_device_enable(data->tz);

Since we now also (indirectly) call ->set_mode here the following code:

	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
		     data->socdata->power_down_mask);
	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
		     data->socdata->measure_temp_mask);

should be removed from imx_thermal_resume().

>  
>  	return 0;
>  }
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index e802922a13cf..1751d4b103b1 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -44,7 +44,6 @@ static char *int3400_thermal_uuids[INT3400_THERMAL_MAXIMUM_UUID] = {
>  struct int3400_thermal_priv {
>  	struct acpi_device *adev;
>  	struct thermal_zone_device *thermal;
> -	int mode;
>  	int art_count;
>  	struct art *arts;
>  	int trt_count;
> @@ -230,54 +229,32 @@ static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
>  	return 0;
>  }
>  
> -static int int3400_thermal_get_mode(struct thermal_zone_device *thermal,
> -				enum thermal_device_mode *mode)
> -{
> -	struct int3400_thermal_priv *priv = thermal->devdata;
> -
> -	if (!priv)
> -		return -EINVAL;
> -
> -	*mode = priv->mode;
> -
> -	return 0;
> -}
> -
>  static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>  				enum thermal_device_mode mode)
>  {
>  	struct int3400_thermal_priv *priv = thermal->devdata;
> -	bool enable;
>  	int result = 0;
>  
>  	if (!priv)
>  		return -EINVAL;
>  
> -	if (mode == THERMAL_DEVICE_ENABLED)
> -		enable = true;
> -	else if (mode == THERMAL_DEVICE_DISABLED)
> -		enable = false;
> -	else
> -		return -EINVAL;
> -
> -	if (enable != priv->mode) {
> -		priv->mode = enable;
> +	if (mode != thermal->mode) {
>  		result = int3400_thermal_run_osc(priv->adev->handle,
> -						 priv->current_uuid_index,
> -						 enable);
> +						priv->current_uuid_index,
> +						mode == THERMAL_DEVICE_ENABLED);
>  	}
>  	return result;
>  }
>  
>  static struct thermal_zone_device_ops int3400_thermal_ops = {
>  	.get_temp = int3400_thermal_get_temp,
> -	.get_mode = int3400_thermal_get_mode,
>  	.set_mode = int3400_thermal_set_mode,
>  };
>  
>  static struct thermal_zone_params int3400_thermal_params = {
>  	.governor_name = "user_space",
>  	.no_hwmon = true,
> +	.initial_mode = THERMAL_DEVICE_DISABLED,
>  };
>  
>  static int int3400_thermal_probe(struct platform_device *pdev)
> diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> index 432213272f1e..b36da9bfbf8a 100644
> --- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> +++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> @@ -208,6 +208,7 @@ EXPORT_SYMBOL_GPL(int340x_thermal_read_trips);
>  static struct thermal_zone_params int340x_thermal_params = {
>  	.governor_name = "user_space",
>  	.no_hwmon = true,
> +	.initial_mode = THERMAL_DEVICE_ENABLED,
>  };
>  
>  struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
> diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
> index d704fc104cfd..c4879b4bfbf1 100644
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
> @@ -309,14 +308,6 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd,
>  	return 0;
>  }
>  
> -static int sys_get_mode(struct thermal_zone_device *tzd,
> -				enum thermal_device_mode *mode)
> -{
> -	struct soc_sensor_entry *aux_entry = tzd->devdata;
> -	*mode = aux_entry->mode;
> -	return 0;
> -}
> -
>  static int sys_set_mode(struct thermal_zone_device *tzd,
>  				enum thermal_device_mode mode)
>  {
> @@ -338,7 +329,6 @@ static struct thermal_zone_device_ops tzone_ops = {
>  	.get_trip_type = sys_get_trip_type,
>  	.set_trip_temp = sys_set_trip_temp,
>  	.get_crit_temp = sys_get_crit_temp,
> -	.get_mode = sys_get_mode,
>  	.set_mode = sys_set_mode,
>  };

Please take a look at sys_set_mode():

static int sys_set_mode(struct thermal_zone_device *tzd,
				enum thermal_device_mode mode)
{
	int ret;

	mutex_lock(&dts_update_mutex);
	if (mode == THERMAL_DEVICE_ENABLED)
		ret = soc_dts_enable(tzd);
	else
		ret = soc_dts_disable(tzd);
	mutex_unlock(&dts_update_mutex);

	return ret;
}

and alloc_soc_dts():

static struct soc_sensor_entry *alloc_soc_dts(void)
{
...
	aux_entry->tzone = thermal_zone_device_register("quark_dts",
			QRK_MAX_DTS_TRIPS,
			wr_mask,
			aux_entry, &tzone_ops, NULL, 0, polling_delay);
	if (IS_ERR(aux_entry->tzone)) {
		err = PTR_ERR(aux_entry->tzone);
		goto err_ret;
	}

	mutex_lock(&dts_update_mutex);
	err = soc_dts_enable(aux_entry->tzone);
	mutex_unlock(&dts_update_mutex);
	if (err)
		goto err_aux_status;
...
}

Since ->set_mode is now called through thermal_zone_device_register()
the following code should be removed:

	mutex_lock(&dts_update_mutex);
	err = soc_dts_enable(aux_entry->tzone);
	mutex_unlock(&dts_update_mutex);
	if (err)
		goto err_aux_status;

> diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
> index a006b9fd1d72..cb810a02aab0 100644
> --- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
> +++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
> @@ -56,6 +56,7 @@ struct zone_device {
>  
>  static struct thermal_zone_params pkg_temp_tz_params = {
>  	.no_hwmon	= true,
> +	.initial_mode	= THERMAL_DEVICE_ENABLED,
>  };
>  
>  /* Keep track of how many zone pointers we allocated in init() */
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index 874a47d6923f..48787a5576d8 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
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
> @@ -269,23 +267,11 @@ static int of_thermal_unbind(struct thermal_zone_device *thermal,
>  	return 0;
>  }
>  
> -static int of_thermal_get_mode(struct thermal_zone_device *tz,
> -			       enum thermal_device_mode *mode)
> -{
> -	struct __thermal_zone *data = tz->devdata;
> -
> -	*mode = data->mode;
> -
> -	return 0;
> -}
> -
>  static int of_thermal_set_mode(struct thermal_zone_device *tz,
>  			       enum thermal_device_mode mode)
>  {
>  	struct __thermal_zone *data = tz->devdata;
>  
> -	mutex_lock(&tz->lock);
> -
>  	if (mode == THERMAL_DEVICE_ENABLED) {
>  		tz->polling_delay = data->polling_delay;
>  		tz->passive_delay = data->passive_delay;
> @@ -294,11 +280,6 @@ static int of_thermal_set_mode(struct thermal_zone_device *tz,
>  		tz->passive_delay = 0;
>  	}
>  
> -	mutex_unlock(&tz->lock);
> -
> -	data->mode = mode;
> -	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
> -
>  	return 0;
>  }
>  
> @@ -393,7 +374,6 @@ static int of_thermal_get_crit_temp(struct thermal_zone_device *tz,
>  }
>  
>  static struct thermal_zone_device_ops of_thermal_ops = {
> -	.get_mode = of_thermal_get_mode,
>  	.set_mode = of_thermal_set_mode,
>  
>  	.get_trip_type = of_thermal_get_trip_type,
> @@ -554,7 +534,7 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id, void *data,
>  			tzd = thermal_zone_of_add_sensor(child, sensor_np,
>  							 data, ops);
>  			if (!IS_ERR(tzd))
> -				tzd->ops->set_mode(tzd, THERMAL_DEVICE_ENABLED);
> +				thermal_zone_device_enable(tzd);
>  
>  			of_node_put(child);
>  			goto exit;
> @@ -979,7 +959,6 @@ __init *thermal_of_build_thermal_zone(struct device_node *np)
>  
>  finish:
>  	of_node_put(child);
> -	tz->mode = THERMAL_DEVICE_DISABLED;
>  
>  	return tz;
>  
> @@ -1120,6 +1099,7 @@ int __init of_parse_thermal_zones(void)
>  		/* these two are left for temperature drivers to use */
>  		tzp->slope = tz->slope;
>  		tzp->offset = tz->offset;
> +		tzp->initial_mode = THERMAL_DEVICE_DISABLED;
>  
>  		zone = thermal_zone_device_register(child->name, tz->ntrips,
>  						    mask, tz,
> diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
> index 15a71ecc916c..aa9e0e31ef98 100644
> --- a/drivers/thermal/rockchip_thermal.c
> +++ b/drivers/thermal/rockchip_thermal.c
> @@ -1068,8 +1068,10 @@ rockchip_thermal_toggle_sensor(struct rockchip_thermal_sensor *sensor, bool on)
>  {
>  	struct thermal_zone_device *tzd = sensor->tzd;
>  
> -	tzd->ops->set_mode(tzd,
> -		on ? THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED);
> +	if (on)
> +		thermal_zone_device_enable(tzd);
> +	else
> +		thermal_zone_device_disable(tzd);
>  }
>  
>  static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
> diff --git a/drivers/thermal/sprd_thermal.c b/drivers/thermal/sprd_thermal.c
> index a340374e8c51..58f995b0f804 100644
> --- a/drivers/thermal/sprd_thermal.c
> +++ b/drivers/thermal/sprd_thermal.c
> @@ -322,8 +322,10 @@ static void sprd_thm_toggle_sensor(struct sprd_thermal_sensor *sen, bool on)
>  {
>  	struct thermal_zone_device *tzd = sen->tzd;
>  
> -	tzd->ops->set_mode(tzd,
> -		on ? THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED);
> +	if (on)
> +		thermal_zone_device_enable(tzd);
> +	else
> +		thermal_zone_device_disable(tzd);
>  }
>  
>  static int sprd_thm_probe(struct platform_device *pdev)
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index c06550930979..a012d77dd602 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -463,6 +463,44 @@ static void thermal_zone_device_reset(struct thermal_zone_device *tz)
>  	thermal_zone_device_init(tz);
>  }
>  
> +enum thermal_device_mode
> +thermal_zone_device_get_mode(struct thermal_zone_device *tz)
> +{
> +	enum thermal_device_mode mode;
> +
> +	mutex_lock(&tz->lock);
> +
> +	mode = tz->mode;
> +
> +	mutex_unlock(&tz->lock);
> +
> +	return mode;
> +}
> +
> +int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
> +				 enum thermal_device_mode mode)
> +{
> +	int ret = 0;
> +
> +	if (mode != THERMAL_DEVICE_DISABLED &&
> +	    mode != THERMAL_DEVICE_ENABLED)
> +		return -EINVAL;

Please remove above checks, they really are redundant.

> +	mutex_lock(&tz->lock);
> +
> +	if (tz->ops->set_mode)
> +		ret = tz->ops->set_mode(tz, mode);
> +
> +	tz->mode = mode;

This should be:

	if (!ret)
		tz->mode = mode;

as we shouldn't change the mode information if ->set_mode has failed.

> +
> +	mutex_unlock(&tz->lock);
> +
> +	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(thermal_zone_device_set_mode);
> +
>  void thermal_zone_device_update(struct thermal_zone_device *tz,
>  				enum thermal_notify_event event)
>  {
> @@ -1236,6 +1274,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
>  	int result;
>  	int count;
>  	struct thermal_governor *governor;
> +	enum thermal_device_mode mode;
>  
>  	if (!type || strlen(type) == 0) {
>  		pr_err("Error: No thermal zone type defined\n");
> @@ -1340,9 +1379,9 @@ thermal_zone_device_register(const char *type, int trips, int mask,
>  	INIT_DELAYED_WORK(&tz->poll_queue, thermal_zone_device_check);
>  
>  	thermal_zone_device_reset(tz);
> -	/* Update the new thermal zone and mark it as already updated. */
> -	if (atomic_cmpxchg(&tz->need_update, 1, 0))
> -		thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
> +
> +	mode = tzp ? tzp->initial_mode : THERMAL_DEVICE_ENABLED;
> +	thermal_zone_device_set_mode(tz, mode);

The setting of tz->need_update earlier in thermal_zone_device_register():

	/* A new thermal zone needs to be updated anyway. */
	atomic_set(&tz->need_update, 1);

should also be removed now.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

>  
>  	return tz;
>  
> @@ -1473,9 +1512,7 @@ static int thermal_pm_notify(struct notifier_block *nb,
>  	case PM_POST_SUSPEND:
>  		atomic_set(&in_suspend, 0);
>  		list_for_each_entry(tz, &thermal_tz_list, node) {
> -			tz_mode = THERMAL_DEVICE_ENABLED;
> -			if (tz->ops->get_mode)
> -				tz->ops->get_mode(tz, &tz_mode);
> +			tz_mode = thermal_zone_device_get_mode(tz);
>  
>  			if (tz_mode == THERMAL_DEVICE_DISABLED)
>  				continue;
> diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
> index c95689586e19..ff5519adb68a 100644
> --- a/drivers/thermal/thermal_core.h
> +++ b/drivers/thermal/thermal_core.h
> @@ -141,6 +141,9 @@ thermal_cooling_device_stats_update(struct thermal_cooling_device *cdev,
>  				    unsigned long new_state) {}
>  #endif /* CONFIG_THERMAL_STATISTICS */
>  
> +enum thermal_device_mode
> +thermal_zone_device_get_mode(struct thermal_zone_device *tz);
> +
>  /* device tree support */
>  #ifdef CONFIG_THERMAL_OF
>  int of_parse_thermal_zones(void);
> diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
> index aa99edb4dff7..cbb27b3c96d2 100644
> --- a/drivers/thermal/thermal_sysfs.c
> +++ b/drivers/thermal/thermal_sysfs.c
> @@ -50,14 +50,8 @@ mode_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>  	struct thermal_zone_device *tz = to_thermal_zone(dev);
>  	enum thermal_device_mode mode;
> -	int result;
> -
> -	if (!tz->ops->get_mode)
> -		return -EPERM;
>  
> -	result = tz->ops->get_mode(tz, &mode);
> -	if (result)
> -		return result;
> +	mode = thermal_zone_device_get_mode(tz);
>  
>  	return sprintf(buf, "%s\n", mode == THERMAL_DEVICE_ENABLED ? "enabled"
>  		       : "disabled");
> @@ -74,9 +68,9 @@ mode_store(struct device *dev, struct device_attribute *attr,
>  		return -EPERM;
>  
>  	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
> -		result = tz->ops->set_mode(tz, THERMAL_DEVICE_ENABLED);
> +		result = thermal_zone_device_enable(tz);
>  	else if (!strncmp(buf, "disabled", sizeof("disabled") - 1))
> -		result = tz->ops->set_mode(tz, THERMAL_DEVICE_DISABLED);
> +		result = thermal_zone_device_disable(tz);
>  	else
>  		result = -EINVAL;
>  
> @@ -428,30 +422,13 @@ static struct attribute_group thermal_zone_attribute_group = {
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
> index 216185bb3014..c789d4ff6e63 100644
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
> @@ -128,6 +126,7 @@ struct thermal_cooling_device {
>   * @trip_temp_attrs:	attributes for trip points for sysfs: trip temperature
>   * @trip_type_attrs:	attributes for trip points for sysfs: trip type
>   * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
> + * @mode:		current mode of this thermal zone
>   * @devdata:	private pointer for device private data
>   * @trips:	number of trip points the thermal zone supports
>   * @trips_disabled;	bitmap for disabled trips
> @@ -170,6 +169,7 @@ struct thermal_zone_device {
>  	struct thermal_attr *trip_temp_attrs;
>  	struct thermal_attr *trip_type_attrs;
>  	struct thermal_attr *trip_hyst_attrs;
> +	enum thermal_device_mode mode;
>  	void *devdata;
>  	int trips;
>  	unsigned long trips_disabled;	/* bitmap for disabled trips */
> @@ -264,6 +264,9 @@ struct thermal_zone_params {
>  	int num_tbps;	/* Number of tbp entries */
>  	struct thermal_bind_params *tbp;
>  
> +	/* Initial mode of this thermal zone device */
> +	enum thermal_device_mode initial_mode;
> +
>  	/*
>  	 * Sustainable power (heat) that this thermal zone can dissipate in
>  	 * mW
> @@ -395,6 +398,8 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *, int,
>  				     unsigned int);
>  int thermal_zone_unbind_cooling_device(struct thermal_zone_device *, int,
>  				       struct thermal_cooling_device *);
> +int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
> +				 enum thermal_device_mode mode);
>  void thermal_zone_device_update(struct thermal_zone_device *,
>  				enum thermal_notify_event);
>  
> @@ -426,6 +431,9 @@ static inline struct thermal_zone_device *thermal_zone_device_register(
>  static inline void thermal_zone_device_unregister(
>  	struct thermal_zone_device *tz)
>  { }
> +int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
> +				 enum thermal_device_mode mode)
> +{ return -EINVAL; }
>  static inline struct thermal_cooling_device *
>  thermal_cooling_device_register(char *type, void *devdata,
>  	const struct thermal_cooling_device_ops *ops)
> @@ -465,4 +473,14 @@ static inline void thermal_notify_framework(struct thermal_zone_device *tz,
>  { }
>  #endif /* CONFIG_THERMAL */
>  
> +static inline int thermal_zone_device_enable(struct thermal_zone_device *tz)
> +{
> +	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_ENABLED);
> +}
> +
> +static inline int thermal_zone_device_disable(struct thermal_zone_device *tz)
> +{
> +	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_DISABLED);
> +}
> +
>  #endif /* __THERMAL_H__ */
> 
