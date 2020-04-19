Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C948D1AF99B
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 13:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgDSLim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 07:38:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35440 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgDSLij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 07:38:39 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200419113835euoutp01569ba9d69e5d21323536d84f8cc5ece9~HNZbPYRhV2037420374euoutp01K
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:38:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200419113835euoutp01569ba9d69e5d21323536d84f8cc5ece9~HNZbPYRhV2037420374euoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587296315;
        bh=UQ6xIjzgjYSU/WEKN4wOlwDKtVJQv4wESvwT+7/Mjzo=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=uj1xCpgezzu5iD7C4bIFagsKwpuXBFUMaxAq14foUT1WUB/0EsZ8FdF0JJeexJG1n
         BI6bmRa4AM8IeQZjvQPx2p0BBsMA3hGaIHud209/M5JOzlTsKfkPDmom9bTdlv1goF
         BUrFkM1/DPy++pIg7raP4Wlx5FnWWc3RfD/O/GUk=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200419113834eucas1p28694a403e01878d23331bea59cdc94da~HNZaAzti10762307623eucas1p2b;
        Sun, 19 Apr 2020 11:38:34 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 2F.5B.60679.A383C9E5; Sun, 19
        Apr 2020 12:38:34 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200419113833eucas1p23a97eb2cdd5f43e7b51cb2086c99fba7~HNZZo-BTt0653306533eucas1p2o;
        Sun, 19 Apr 2020 11:38:33 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200419113833eusmtrp1f28b4422f7dd62de040f53ffc2559882~HNZZoAVIG0660806608eusmtrp1V;
        Sun, 19 Apr 2020 11:38:33 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-73-5e9c383afb56
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id E8.64.08375.9383C9E5; Sun, 19
        Apr 2020 12:38:33 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200419113832eusmtip2749b85e5f65bd9fe59a04851ac77f62f~HNZYVeA2n2062920629eusmtip28;
        Sun, 19 Apr 2020 11:38:32 +0000 (GMT)
Subject: Re: [RFC v3 1/2] thermal: core: Let thermal zone device's mode be
 stored in its struct
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
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <4b97e46a-e7ef-ee22-227e-d35ebef458b0@samsung.com>
Date:   Sun, 19 Apr 2020 13:38:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200417162020.19980-2-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTdxjG/Z9bD2Qlx6L2jWDcummiRkBd2D/ijblsJ2aJfpuZip7pCZBx
        Ma3F6RcvUSxFBW0QqIB4CaUsorakUOhMqYJallq8VDBlW5UYQKuuJShEUNoDkW+/PO/75Hmf
        5GVJhYuZz2bn7RPVeUKOiomlbJ2j95evxlUZKUef0dh8d4LC7zyjBK57/g+Fz1Z8JHFNeAGu
        un+MwvqLKTjweDMuDFdQOODciHuPtBG4aqAAWz0nadxQZqewPRBksOlmCcKW5z4a68fMJA6f
        uo1wZ+087PVux386Bkj8d9cDGvcHTjN4vNlC4YEmJf7reDeJrZYyckMi39J3BfFN5l6Crw8l
        83Zjn4y31i/lLzsGCd7SUMTwfp+D4V97PJP6lUP8/6/6ZfyL8lsEX/o2yPA3XrcQfMl4Cv/+
        4St6S/yvsWv2iDnZBaI6ed2u2KwnJhOz900j8cdjj444jGxhpEcxLHDfwhO3l9ajWFbB1SPo
        toZkkYGCG0bg1uVIHEbgP/PVtKHCeE4mGUwIegOhKXcQQXG1IeqO5wQob3YyEZ7DrYJRWzDq
        ILkRGbgeDZKRAcOthjMnGqJ3yLl1MHbOEGWKWwRtL/1EhOdyWyH03y1a2pkN9yr7qQjHcGuh
        2j0c1UlOCU/7LxASL4TmYBUZCQOuOAZc7TWkdPcP0DPSLpM4HobuNE1xInQZTlKSoRHBuG5g
        yt2MwGSYYKStNPB7xiaZnYxYAtdakyU5HWxePxWRgYuDnuBs6Yg4OGsrJyVZDrpChbS9GK7X
        XWemY/V2M1mKVMYZ1Ywz6hhn1DF+zq1FVANSilpNbqaoWZkn7k/SCLkabV5m0u78XAua/Oyu
        iTvDLaj1w28uxLFI9YXcmXo+Q0ELBZoDuS4ELKmaI2//sTJDId8jHDgoqvN3qrU5osaFElhK
        pZSvujS4Q8FlCvvE30Vxr6ienhJszPzDqHK50OFeZj/ft8D8LjXBO+ubLM+Nr9Oc5Yxr/S+U
        w1ekOrXQTGd/l6b72VG68yetdd72DllCXWLPv4YXxUdrP64gauxxvk3Fp1vTNzZqZ2VdGO6m
        9Onb2rDdl/6gqGzIXejctKb6y7nZ2supyo4jnqbQ1dv3TElDbZ3535fcPESOqChNlrBiKanW
        CJ8AyM4zKtUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTcRTH+d17d3dnLm6b5i8xilEERnNz6c5CrQjkUkRCED1Xt7pMy7nY
        3aSid1Y2Ku1h2VplZakLCmf4KIvU3soqS8vKSJOwUss0fGTW5gr878M53885HDgMqWiQhDMp
        aTbBmsanquggqnb44fsZBnAZNY9fRkLRo2EK+rwDBFz5+J6CY7l/SDjXMxFcTzMocFzQQEvD
        Itjfk0tBy9150LT7FgGu9nQo8R6SgDungoKKlk4aCu5kIfB8bJSAY7CIhJ7D9xA8yBsPz56t
        hKuV7STU1dZLoK3lCA2/yzwUtN8Ig9v7npNQ4skh50Rw5c35iLtR1ERwhT+iuApns5QrKYzk
        LlV+JjiP+yDNvWuspLkur9dXz9/JdXe0SblPp2oILvt7J80Vd5UTXNZvDdf/okOSpFyujrNa
        7DZhcrJFtMWrVmghWq01gDp6pkGt1elXzYqOUUUlxK0XUlPSBWtUwhp18quCAnrTt2vE5gZv
        JrELlfYgB5IxmJ2Jc50npQ4UxCjYywi3fnYTDsT4GhH44fX0QEaJhxoddCDzFeH7WXul/oaS
        5fGpsru0n0NYHR4o7RwZRLL9UvzzTSEZMPoQrjt0WeJP0ewsfPSAe2S1nE3AgyePjzDFTsW3
        vr4j/BzKLsU15c5/mXH48ek2ys8yNh6ffdI7Modkp+Ghc/VkgMPwm7bzRIAn4bJOF5mNFM5R
        unOU4hylOEcpeYhyoxDBLppNZlGrFnmzaE8zqddZzB7ke6nSBwMl5ai+eHE1YhmkCpZjwxmj
        QsKni1vM1QgzpCpEXpV42qiQr+e3bBWsltVWe6ogVqMY33FHyfDQdRbfg6bZVmtjtHowaPU6
        vS4WVGHyTLZqpYI18TZhoyBsEqz/PYKRhe9CcXv6XBHKboo5Fh8uS/BcWTZlYUXozgvNa+Zn
        aAZ3dKyd/dp00fVFjJYlKhNrXxqXLDpsObFqzK9sw+ZWXnckdHpU0vacurmertgJNb3HMz3B
        +WN/JRZj+wcCJXUvbyJT2C/m+8VklXHB0NObG1rp3UE7NPq8BlPt2/3bhr/Fvl6sosRkXhtJ
        WkX+LzzI48RoAwAA
X-CMS-MailID: 20200419113833eucas1p23a97eb2cdd5f43e7b51cb2086c99fba7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200417162037eucas1p11663f116fd9844d38c0b5d4d7ebe9f1c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200417162037eucas1p11663f116fd9844d38c0b5d4d7ebe9f1c
References: <9ac3b37a-8746-b8ee-70e1-9c876830ac83@linaro.org>
        <20200417162020.19980-1-andrzej.p@collabora.com>
        <CGME20200417162037eucas1p11663f116fd9844d38c0b5d4d7ebe9f1c@eucas1p1.samsung.com>
        <20200417162020.19980-2-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Andrzej,

On 4/17/20 6:20 PM, Andrzej Pietrasiewicz wrote:
> Thermal zone devices' mode is stored in individual drivers. This patch
> changes it so that mode is stored in struct thermal_zone_device instead.
> 
> As a result all driver-specific variables storing the mode are not needed
> and are removed. Consequently, the get_mode() implementations have nothing
> to operate on and need to be removed, too.
> 
> Some thermal framework specific functions are introduced:
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
> The scope of the above 4 functions is purposedly limited to the thermal
> framework and drivers are not supposed to call them. This encapsulation

This should be true only for thermal_zone_device_{get,set}_mode().

thermal_zone_device_{en,dis}able() should be available for device drivers:

* of/thermal device drivers need to enable thermal device itself
  (please refer to my patchset for details)

* device drivers need to call them on ->suspend and ->resume operations

> does not fully work at the moment for some drivers, though:
> 
> - platform/x86/acerhdf.c
> - drivers/thermal/imx_thermal.c
> - drivers/thermal/intel/intel_quark_dts_thermal.c
> - drivers/thermal/of-thermal.c
> 
> and they manipulate struct thermal_zone_device's members directly.
> 
> struct thermal_zone_params gains a new member called initial_mode, which
> is used to set tzd's mode at registration time.
> 
> The sysfs "mode" attribute is always exposed from now on, because all
> thermal zone devices now have their get_mode() implemented at the generic
> level and it is always available. Exposing "mode" doesn't hurt the drivers
> which don't provide their own set_mode(), because writing to "mode" will
> result in -EPERM, as expected.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---
>  drivers/acpi/thermal.c                        | 46 +++++----------
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 57 ++++---------------
>  drivers/platform/x86/acerhdf.c                | 17 +-----
>  drivers/thermal/da9062-thermal.c              | 16 ++----
>  drivers/thermal/imx_thermal.c                 | 29 +++-------
>  .../intel/int340x_thermal/int3400_thermal.c   | 30 ++--------
>  .../thermal/intel/intel_quark_dts_thermal.c   | 22 ++-----
>  drivers/thermal/of-thermal.c                  | 30 +++-------
>  drivers/thermal/thermal_core.c                | 44 +++++++++++++-
>  drivers/thermal/thermal_core.h                | 16 ++++++
>  drivers/thermal/thermal_sysfs.c               | 29 +---------
>  include/linux/thermal.h                       |  7 ++-
>  12 files changed, 125 insertions(+), 218 deletions(-)
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 19067a5e5293..67bc263332a5 100644
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
> @@ -526,46 +525,29 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
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
>  
> +	if (mode != THERMAL_DEVICE_DISABLED &&
> +	    mode != THERMAL_DEVICE_ENABLED)
> +		return -EINVAL;

These checks should be removed as they are already done in the caller
of ->set_mode method (thermal_zone_device_set_mode()).

> +
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
> @@ -856,7 +838,6 @@ static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
>  	.bind = acpi_thermal_bind_cooling_device,
>  	.unbind	= acpi_thermal_unbind_cooling_device,
>  	.get_temp = thermal_get_temp,
> -	.get_mode = thermal_get_mode,
>  	.set_mode = thermal_set_mode,
>  	.get_trip_type = thermal_get_trip_type,
>  	.get_trip_temp = thermal_get_trip_temp,
> @@ -870,6 +851,9 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>  	int trips = 0;
>  	int result;
>  	acpi_status status;
> +	struct thermal_zone_params prms = {
> +		.initial_mode = THERMAL_DEVICE_ENABLED,
> +	};
>  	int i;
>  
>  	if (tz->trips.critical.flags.valid)
> @@ -887,13 +871,13 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>  	if (tz->trips.passive.flags.valid)
>  		tz->thermal_zone =
>  			thermal_zone_device_register("acpitz", trips, 0, tz,
> -						&acpi_thermal_zone_ops, NULL,
> +						&acpi_thermal_zone_ops, &prms,
>  						     tz->trips.passive.tsp*100,
>  						     tz->polling_frequency*100);
>  	else
>  		tz->thermal_zone =
>  			thermal_zone_device_register("acpitz", trips, 0, tz,
> -						&acpi_thermal_zone_ops, NULL,
> +						&acpi_thermal_zone_ops, &prms,
>  						0, tz->polling_frequency*100);
>  	if (IS_ERR(tz->thermal_zone))
>  		return -ENODEV;
> @@ -913,8 +897,6 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>  	if (ACPI_FAILURE(status))
>  		return -ENODEV;
>  
> -	tz->tz_enabled = 1;
> -
>  	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
>  		 tz->thermal_zone->id);
>  	return 0;
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index ce0a6837daa3..50518048b86d 100644
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
> @@ -749,6 +710,9 @@ static const struct thermal_cooling_device_ops mlxsw_cooling_ops = {
>  static int
>  mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
>  {
> +	struct thermal_zone_params tzp = {
> +		.initial_mode = THERMAL_DEVICE_ENABLED,
> +	};
>  	char tz_name[MLXSW_THERMAL_ZONE_MAX_NAME];
>  	int err;
>  
> @@ -759,13 +723,12 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
>  							MLXSW_THERMAL_TRIP_MASK,
>  							module_tz,
>  							&mlxsw_thermal_module_ops,
> -							NULL, 0, 0);
> +							&tzp, 0, 0);
>  	if (IS_ERR(module_tz->tzdev)) {
>  		err = PTR_ERR(module_tz->tzdev);
>  		return err;
>  	}
>  
> -	module_tz->mode = THERMAL_DEVICE_ENABLED;
>  	return 0;
>  }
>  
> @@ -868,6 +831,9 @@ mlxsw_thermal_modules_fini(struct mlxsw_thermal *thermal)
>  static int
>  mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
>  {
> +	struct thermal_zone_params tzp = {
> +		.initial_mode = THERMAL_DEVICE_ENABLED,
> +	};
>  	char tz_name[MLXSW_THERMAL_ZONE_MAX_NAME];
>  
>  	snprintf(tz_name, sizeof(tz_name), "mlxsw-gearbox%d",
> @@ -877,11 +843,10 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
>  						MLXSW_THERMAL_TRIP_MASK,
>  						gearbox_tz,
>  						&mlxsw_thermal_gearbox_ops,
> -						NULL, 0, 0);
> +						&tzp, 0, 0);
>  	if (IS_ERR(gearbox_tz->tzdev))
>  		return PTR_ERR(gearbox_tz->tzdev);
>  
> -	gearbox_tz->mode = THERMAL_DEVICE_ENABLED;
>  	return 0;
>  }
>  
> @@ -960,6 +925,9 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
>  		       const struct mlxsw_bus_info *bus_info,
>  		       struct mlxsw_thermal **p_thermal)
>  {
> +	struct thermal_zone_params tzp = {
> +		.initial_mode = THERMAL_DEVICE_ENABLED,
> +	};
>  	char mfcr_pl[MLXSW_REG_MFCR_LEN] = { 0 };
>  	enum mlxsw_reg_mfcr_pwm_frequency freq;
>  	struct device *dev = bus_info->dev;
> @@ -1034,7 +1002,7 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
>  						      MLXSW_THERMAL_TRIP_MASK,
>  						      thermal,
>  						      &mlxsw_thermal_ops,
> -						      NULL, 0,
> +						      &tzp, 0,
>  						      thermal->polling_delay);
>  	if (IS_ERR(thermal->tzdev)) {
>  		err = PTR_ERR(thermal->tzdev);
> @@ -1050,7 +1018,6 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
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
> index c32709badeda..4bdb6f9621c1 100644
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
> @@ -199,6 +189,9 @@ MODULE_DEVICE_TABLE(of, da9062_compatible_reg_id_table);
>  
>  static int da9062_thermal_probe(struct platform_device *pdev)
>  {
> +	struct thermal_zone_params tzp = {
> +		.initial_mode = THERMAL_DEVICE_ENABLED,
> +	};
>  	struct da9062 *chip = dev_get_drvdata(pdev->dev.parent);
>  	struct da9062_thermal *thermal;
>  	unsigned int pp_tmp = DA9062_DEFAULT_POLLING_MS_PERIOD;
> @@ -233,7 +226,6 @@ static int da9062_thermal_probe(struct platform_device *pdev)
>  
>  	thermal->config = match->data;
>  	thermal->hw = chip;
> -	thermal->mode = THERMAL_DEVICE_ENABLED;
>  	thermal->dev = &pdev->dev;
>  
>  	INIT_DELAYED_WORK(&thermal->work, da9062_thermal_poll_on);
> @@ -241,7 +233,7 @@ static int da9062_thermal_probe(struct platform_device *pdev)
>  
>  	thermal->zone = thermal_zone_device_register(thermal->config->name,
>  					1, 0, thermal,
> -					&da9062_thermal_ops, NULL, pp_tmp,
> +					&da9062_thermal_ops, &tzp, pp_tmp,
>  					0);
>  	if (IS_ERR(thermal->zone)) {
>  		dev_err(&pdev->dev, "Cannot register thermal zone device\n");
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index e761c9b42217..3e02323c938b 100644
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
> @@ -691,6 +676,9 @@ static inline void imx_thermal_unregister_legacy_cooling(struct imx_thermal_data
>  
>  static int imx_thermal_probe(struct platform_device *pdev)
>  {
> +	struct thermal_zone_params tzp = {
> +		.initial_mode = THERMAL_DEVICE_ENABLED,
> +	};
>  	struct imx_thermal_data *data;
>  	struct regmap *map;
>  	int measure_freq;
> @@ -799,7 +787,7 @@ static int imx_thermal_probe(struct platform_device *pdev)
>  	data->tz = thermal_zone_device_register("imx_thermal_zone",
>  						IMX_TRIP_NUM,
>  						BIT(IMX_TRIP_PASSIVE), data,
> -						&imx_tz_ops, NULL,
> +						&imx_tz_ops, &tzp,
>  						IMX_PASSIVE_DELAY,
>  						IMX_POLLING_DELAY);
>  	if (IS_ERR(data->tz)) {
> @@ -831,7 +819,6 @@ static int imx_thermal_probe(struct platform_device *pdev)
>  		     data->socdata->measure_temp_mask);
>  
>  	data->irq_enabled = true;
> -	data->mode = THERMAL_DEVICE_ENABLED;
>  
>  	ret = devm_request_threaded_irq(&pdev->dev, data->irq,
>  			imx_thermal_alarm_irq, imx_thermal_alarm_irq_thread,
> @@ -885,7 +872,7 @@ static int __maybe_unused imx_thermal_suspend(struct device *dev)
>  		     data->socdata->measure_temp_mask);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->power_down_mask);
> -	data->mode = THERMAL_DEVICE_DISABLED;
> +	data->tz->mode = THERMAL_DEVICE_DISABLED;
>  	clk_disable_unprepare(data->thermal_clk);
>  
>  	return 0;
> @@ -905,7 +892,7 @@ static int __maybe_unused imx_thermal_resume(struct device *dev)
>  		     data->socdata->power_down_mask);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->measure_temp_mask);
> -	data->mode = THERMAL_DEVICE_ENABLED;
> +	data->tz->mode = THERMAL_DEVICE_ENABLED;
>  
>  	return 0;
>  }
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index e802922a13cf..86a00598ed09 100644
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
> @@ -230,48 +229,29 @@ static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
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
> +	if (mode != THERMAL_DEVICE_ENABLED &&
> +	    mode != THERMAL_DEVICE_DISABLED)
>  		return -EINVAL;

These checks should be removed as they are already done in the caller
of ->set_mode method (thermal_zone_device_set_mode()).

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
>  
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index 874a47d6923f..863b89546f81 100644
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
> @@ -553,8 +533,14 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id, void *data,
>  		if (id == sensor_id) {
>  			tzd = thermal_zone_of_add_sensor(child, sensor_np,
>  							 data, ops);
> -			if (!IS_ERR(tzd))
> +			if (!IS_ERR(tzd)) {
> +				mutex_lock(&tzd->lock);
>  				tzd->ops->set_mode(tzd, THERMAL_DEVICE_ENABLED);
> +				tzd->mode = THERMAL_DEVICE_ENABLED;
> +				mutex_unlock(&tzd->lock);
> +				thermal_zone_device_update(tzd,
> +						THERMAL_EVENT_UNSPECIFIED);
> +			}

This should use thermal_zone_device_enable() instead of open-coding it:

			if (!IS_ERR(tzd))
				thermal_zone_device_enable(tzd);

Also because of of_thermal_set_mode() modifications following of/thermal
device drivers (which use ->set_mode directly):

drivers/thermal/hisi_thermal.c: tzd->ops->set_mode(tzd,
drivers/thermal/rockchip_thermal.c:     tzd->ops->set_mode(tzd,
drivers/thermal/sprd_thermal.c: tzd->ops->set_mode(tzd,

need to be converted to use thermal_zone_device_{en,dis}able() instead.

>  			of_node_put(child);
>  			goto exit;
> @@ -979,7 +965,6 @@ __init *thermal_of_build_thermal_zone(struct device_node *np)
>  
>  finish:
>  	of_node_put(child);
> -	tz->mode = THERMAL_DEVICE_DISABLED;
>  
>  	return tz;
>  
> @@ -1120,6 +1105,7 @@ int __init of_parse_thermal_zones(void)
>  		/* these two are left for temperature drivers to use */
>  		tzp->slope = tz->slope;
>  		tzp->offset = tz->offset;
> +		tzp->initial_mode = THERMAL_DEVICE_DISABLED;
>  
>  		zone = thermal_zone_device_register(child->name, tz->ntrips,
>  						    mask, tz,
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index c06550930979..5ff98fcc0f6a 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -463,6 +463,43 @@ static void thermal_zone_device_reset(struct thermal_zone_device *tz)
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

No need for these checks as enum thermal_device_mode has only two
possible values (we don't do "defensive coding" in the kernel).

> +	mutex_lock(&tz->lock);
> +
> +	if (tz->ops->set_mode)
> +		ret = tz->ops->set_mode(tz, mode);
> +
> +	tz->mode = mode;
> +
> +	mutex_unlock(&tz->lock);
> +
> +	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
> +
> +	return ret;
> +}

Please add:

EXPORT_SYMBOL_GPL(thermal_zone_device_set_mode);

here so device drivers can use thermal_zone_device_{en,dis}able().

>  void thermal_zone_device_update(struct thermal_zone_device *tz,
>  				enum thermal_notify_event event)
>  {
> @@ -1344,6 +1381,9 @@ thermal_zone_device_register(const char *type, int trips, int mask,
>  	if (atomic_cmpxchg(&tz->need_update, 1, 0))
>  		thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
>  
> +	if (tzp)
> +		thermal_zone_device_set_mode(tz, tzp->initial_mode);

Please note that currently some device drivers don't access ->mode
at all so their default ->mode value is THERMAL_DEVICE_DISABLED but
in reality they are enabled (IOW after changes in this patch they
should default to THERMAL_DEVICE_ENABLED to reflect real device state
in "mode" sysfs attribue and not break after applying patch #2).

Therefore we should always call thermal_zone_device_set_mode() and
use the default value of THERMAL_DEVICE_ENABLED if tzp is NULL:

	mode = tzp ? tzp->initial_mode : THERMAL_DEVICE_ENABLED;
	thermal_zone_device_set_mode(tz, mode);

This would also simplify the patch further:

* setting tz->need_update and calling thermal_zone_device_update()
  directly can be removed from thermal_zone_device_register()

* tzp-s with only .initial_mode = THERMAL_DEVICE_ENABLED set can
  be removed from:

  drivers/thermal/acpi.c
  drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
  drivers/thermal/da9062-thermal.c
  drivers/thermal/imx_thermal.c

The rest of the patch looks fine, thank you for working on this!

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> +
>  	return tz;
>  
>  unregister:
> @@ -1473,9 +1513,7 @@ static int thermal_pm_notify(struct notifier_block *nb,
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
> index c95689586e19..8e561bac3133 100644
> --- a/drivers/thermal/thermal_core.h
> +++ b/drivers/thermal/thermal_core.h
> @@ -141,6 +141,22 @@ thermal_cooling_device_stats_update(struct thermal_cooling_device *cdev,
>  				    unsigned long new_state) {}
>  #endif /* CONFIG_THERMAL_STATISTICS */
>  
> +enum thermal_device_mode
> +thermal_zone_device_get_mode(struct thermal_zone_device *tz);
> +
> +int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
> +				 enum thermal_device_mode mode);
> +
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
> index 216185bb3014..da4141697e2e 100644
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
> 
