Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B90D20709F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390153AbgFXKDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:03:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38535 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387647AbgFXKDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:03:16 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200624100312euoutp01bbd7c56351dfeacb59b0ccddc16c8393~bcq_u7fFI0656706567euoutp01g;
        Wed, 24 Jun 2020 10:03:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200624100312euoutp01bbd7c56351dfeacb59b0ccddc16c8393~bcq_u7fFI0656706567euoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592992992;
        bh=cCW+UgHBBzB5VWHHLiL46LjocgSI+U1V2Qr39jkdZzo=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=jxd4VQh/q0AOMIO4wYzyW8B6tHJgbYYNyXR6PvjVzuKw4lk/Y8ni4DY7CtGw5ghCk
         /Q6+XKUFGhkuh5lxPeQQalD68B9xPQsm+DrOJxESUvrrKngpCuG8DuZNBGWPr58t9B
         CyGa12HJHEuEx8/wBlG28O+C4uErBAZX7+VdSn7U=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200624100311eucas1p29743071ec0ce82b1873e96249e0d9078~bcq_iUxSA1289412894eucas1p2E;
        Wed, 24 Jun 2020 10:03:11 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 4E.0B.06318.FD423FE5; Wed, 24
        Jun 2020 11:03:11 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200624100311eucas1p2d5290340cb2f1be2f2367437f81da389~bcq9_BEdt2317423174eucas1p2Q;
        Wed, 24 Jun 2020 10:03:11 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200624100311eusmtrp1e449e380f75783ab170f23cd3e21afea~bcq98s3K_0753007530eusmtrp1j;
        Wed, 24 Jun 2020 10:03:11 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-d8-5ef324df45fc
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 96.F5.06314.FD423FE5; Wed, 24
        Jun 2020 11:03:11 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200624100309eusmtip27dda4679c1e65ef25b2a0c6538619a5e~bcq8Sipj92653526535eusmtip2c;
        Wed, 24 Jun 2020 10:03:09 +0000 (GMT)
Subject: Re: [PATCH v4 10/11] thermal: Simplify or eliminate unnecessary
 set_mode() methods
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
Message-ID: <4fb7bb2c-a61f-8dbc-c0da-31e6a72214e1@samsung.com>
Date:   Wed, 24 Jun 2020 12:03:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200528192051.28034-11-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxTZxTG8957e29pVnMpTt6xkS3dZhxDwMDMyTbJ3Jc3JGYkM2bZBlun
        VzRSwBZQtmxKMtQ28h3BVaZFK6WMaC1QPtc4uoFaVtmcREzZWj4mnVxX6cjEaF3bCxn//c45
        z/M+5/zxSklFFZMg3VNQzGsKVPlKWkbZhxavrf/jhWBuWmVoA1guhyj4171IQMvU7xTUnXhM
        wsVyHwGngonQdO1rCvTNaVBhn5CA78Z7cDh4goLHk3fC1aW3YLy8n4Cm2VKYbDUw0OE+JoG2
        470UnLE009DrE2gwO6oR2KbGJKB/YCEhWPkjgi7/XQLmveGguVYPA7qOWgTOLiMBziMOCQwZ
        18BwQ5UEGgMnEYyOfgzfDcySMOL6VQLTvioaHnXbKJjtjAdXfzF8X/ELCR224ySMGYMUmL19
        zBvJ3Kn2L7iZniYJd72qkuB6JkyI67SME1zrfCrXa5hguI7WJO7sgJ/gbG06mvOMDdDcXbc7
        3Dcd5O7NTTPcn41OgqsJCHQ2/lD2+k4+f08pr0nN/FS2e8Z5ERU1vnPgenUDfQjNgB7FSDGb
        gf9uOYkirGBbEQ6VZ+iRLMz/IGzyWpFYBBG2/NBALjuEviZSdJgRdnieEkUCwoE7RiIyiGNz
        cHNXKPrsajYdL9oFJiIiWb0cC7cdTGRAs6/i2iNtUZGczcT+8ftUhCn2RXz1nD2qeZL9AM97
        nRJRE4uvfDMd1cSE9bWmlmifZOPxrenThMjP4m4hsp0svOl8DPaaJpfWfht3na6mRY7Dfw13
        MiI/g131xyjRcB7hR0dnl9zdCJvrQ0uO17DH/SDM0nDES/hCX2oEMbsZz+myRFyFbwqx4g6r
        cJ29kRTbcnz0sEJ8Yy22tljp5VR9r4WsQUrDissMK64xrLjG8H+sEVFtKJ4v0arzeG16Ab8/
        RatSa0sK8lJ2FKptKPxLXKHhhR7kePjZIGKlSPmE3Oq9l6uQqEq1ZepBhKWkcrX8zZ9duQr5
        TlXZ57ym8BNNST6vHURPSyllvDz9jD9Hweapivm9PF/Ea5anhDQm4RBKSj7Yvi+9cEtO/1dr
        PiLcmT99m5JbtzWxLHn9w3WyhaztWbt0C/sPMAmMAk/VJF7a5IvddN+28ebm8+0cERgSyuey
        PNvPCWnbRjZuMY+M1l+OvXVhX/rLV6tNFbcDcRXWK1vfTfxy2w712oxsQSjslKN1u3TP5d94
        5fls/29FJWff36uktLtVG5JIjVb1HxVD164hBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTdxTH/d1Xb8maXCvITzKz5QbjYrZiedhTo2TqnHf7xy37Zyqind60
        bpSS3paI/jHNfDaC4qJgraxV5CXJRiuVpw+6WSejOtQmDHG0FALBMqV/OJzDtXQm/Pc953w+
        OTnJYUnlRSaD3VNsEc3FuiKeSaF6Z/1PPvgzM1a4sj0sh8Y7sxS8CMwQUDfyhILT1a9JaDkY
        IqAmthQc9w5RYHOthMPeIRpCjzbDkVg1Ba/Dk/Hq5gYYONhJgGO8FMINdhl4AidoaDrTTsHF
        RhcD7aEoA/XXTyJwjwRpsL1sJCFW/jOC1okpAqaH44ueNjyWwXFPJQJfq5MA39HrNNx2Lgb/
        2Qoaqp6dR3D/fgFc6Ron4bfefhoioQoG/r3mpmD8ajr0dlqg+/DvJHjcZ0gIOmMU1A93yD58
        X6hp3i+Mtjlo4UFFOSG0DdUi4WrjACE0TGcJ7fYhmeBpWCFc6pogBHfTcUZ4HOxihKlAIN6v
        /VZ4/jQiE8aqfIRw6lmU+QxvVa0xm6wW8V2DSbKs5bepIVul1oIqO1erUudotq/OzuOz8tfs
        Fov2lIrmrPydKsOorwWVVG3c++DkWeYAGgUbkrOYy8XRDgdpQymskruMcPfgGGFDbHzwNvb/
        WJpkFuFXQRuTZCYRvnXjPEoMFnHbsat1di6ncjl4xhuVJSCSq1DgzrFmWdI4QuA+/xSVoBhu
        Na482jRnKLh8PDHw91yf4pbhu5e9skRO477Evjb7/8xC/Ou5yBwjj/OVtXV0IpPccvyqpp9M
        5nT8R+QHIpnfwdeiDvIUUtrn6fZ5in2eYp+nOBHVhFJFq2TUGyW1StIZJWuxXrXLZHSj+H96
        b8942lB/yxc9iGMR/5bip+HnhUpaVyqVGXsQZkk+VbG+r7dQqditK9snmk07zNYiUepBefHj
        KsmMtF2m+LcXW3ao89Qa0Ko1OZqcVcCnK45xtwqUnF5nEb8RxRLR/MYjWHnGAfT517qH1Abn
        xk3WzKWrPFzavemP9S+VrM2Qu7zE/VXNFfavwbU7L1RVHyrUz2iXTWgXmL53hS91azvI0Dn2
        0/qySTLQx9+o854Wiu5u4f0j733U/M+dskHWR+dpvgPNupt7X1hcwc3yxes/MWz6ZYEqPLSk
        IJKycH/5rHOrKTPWw1OSQadeQZol3X+I8aLmtQMAAA==
X-CMS-MailID: 20200624100311eucas1p2d5290340cb2f1be2f2367437f81da389
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528192220eucas1p1ad262eb3b5218bf247b720068094efbe
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528192220eucas1p1ad262eb3b5218bf247b720068094efbe
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
        <20200528192051.28034-1-andrzej.p@collabora.com>
        <CGME20200528192220eucas1p1ad262eb3b5218bf247b720068094efbe@eucas1p1.samsung.com>
        <20200528192051.28034-11-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
> Setting polling_delay is now done at thermal_core level (by not polling
> DISABLED devices), so no need to repeat this code.
> 
> int340x: Checking for an impossible enum value is unnecessary.
> acpi/thermal: It only prints debug messages.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

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
>  	return 0;
>  }
>  
> -static int thermal_set_mode(struct thermal_zone_device *thermal,
> -				enum thermal_device_mode mode)
> -{
> -	struct acpi_thermal *tz = thermal->devdata;
> -
> -	if (!tz)
> -		return -EINVAL;
> -
> -	if (mode != THERMAL_DEVICE_DISABLED &&
> -	    mode != THERMAL_DEVICE_ENABLED)
> -		return -EINVAL;
> -	/*
> -	 * enable/disable thermal management from ACPI thermal driver
> -	 */
> -	if (mode == THERMAL_DEVICE_DISABLED)
> -		pr_warn("thermal zone will be disabled\n");
> -
> -	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -		"%s kernel ACPI thermal control\n",
> -		mode == THERMAL_DEVICE_ENABLED ?
> -		"Enable" : "Disable"));
> -
> -	return 0;
> -}
> -
>  static int thermal_get_trip_type(struct thermal_zone_device *thermal,
>  				 int trip, enum thermal_trip_type *type)
>  {
> @@ -836,7 +811,6 @@ static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
>  	.bind = acpi_thermal_bind_cooling_device,
>  	.unbind	= acpi_thermal_unbind_cooling_device,
>  	.get_temp = thermal_get_temp,
> -	.set_mode = thermal_set_mode,
>  	.get_trip_type = thermal_get_trip_type,
>  	.get_trip_temp = thermal_get_trip_temp,
>  	.get_crit_temp = thermal_get_crit_temp,
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index e1d800be8bb4..c7f334383912 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -275,19 +275,6 @@ static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
>  	return 0;
>  }
>  
> -static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
> -				  enum thermal_device_mode mode)
> -{
> -	struct mlxsw_thermal *thermal = tzdev->devdata;
> -
> -	if (mode == THERMAL_DEVICE_ENABLED)
> -		tzdev->polling_delay = thermal->polling_delay;
> -	else
> -		tzdev->polling_delay = 0;
> -
> -	return 0;
> -}
> -
>  static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
>  				  int *p_temp)
>  {
> @@ -388,7 +375,6 @@ static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_ops = {
>  	.bind = mlxsw_thermal_bind,
>  	.unbind = mlxsw_thermal_unbind,
> -	.set_mode = mlxsw_thermal_set_mode,
>  	.get_temp = mlxsw_thermal_get_temp,
>  	.get_trip_type	= mlxsw_thermal_get_trip_type,
>  	.get_trip_temp	= mlxsw_thermal_get_trip_temp,
> @@ -446,20 +432,6 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
>  	return err;
>  }
>  
> -static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
> -					 enum thermal_device_mode mode)
> -{
> -	struct mlxsw_thermal_module *tz = tzdev->devdata;
> -	struct mlxsw_thermal *thermal = tz->parent;
> -
> -	if (mode == THERMAL_DEVICE_ENABLED)
> -		tzdev->polling_delay = thermal->polling_delay;
> -	else
> -		tzdev->polling_delay = 0;
> -
> -	return 0;
> -}
> -
>  static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
>  					 int *p_temp)
>  {
> @@ -559,7 +531,6 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
>  static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
>  	.bind		= mlxsw_thermal_module_bind,
>  	.unbind		= mlxsw_thermal_module_unbind,
> -	.set_mode	= mlxsw_thermal_module_mode_set,
>  	.get_temp	= mlxsw_thermal_module_temp_get,
>  	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
>  	.get_trip_temp	= mlxsw_thermal_module_trip_temp_get,
> @@ -597,7 +568,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
>  	.bind		= mlxsw_thermal_module_bind,
>  	.unbind		= mlxsw_thermal_module_unbind,
> -	.set_mode	= mlxsw_thermal_module_mode_set,
>  	.get_temp	= mlxsw_thermal_gearbox_temp_get,
>  	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
>  	.get_trip_temp	= mlxsw_thermal_module_trip_temp_get,
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 3efe749dc5a0..d33a70af0869 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -397,8 +397,6 @@ static inline void acerhdf_revert_to_bios_mode(void)
>  {
>  	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>  	kernelmode = 0;
> -	if (thz_dev)
> -		thz_dev->polling_delay = 0;
>  
>  	pr_notice("kernel mode fan control OFF\n");
>  }
> @@ -406,7 +404,6 @@ static inline void acerhdf_enable_kernelmode(void)
>  {
>  	kernelmode = 1;
>  
> -	thz_dev->polling_delay = interval*1000;
>  	pr_notice("kernel mode fan control ON\n");
>  }
>  
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index 53abb1be1cba..a02398118d88 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -338,9 +338,6 @@ static int imx_set_mode(struct thermal_zone_device *tz,
>  	const struct thermal_soc_data *soc_data = data->socdata;
>  
>  	if (mode == THERMAL_DEVICE_ENABLED) {
> -		tz->polling_delay = IMX_POLLING_DELAY;
> -		tz->passive_delay = IMX_PASSIVE_DELAY;
> -
>  		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>  			     soc_data->power_down_mask);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
> @@ -356,9 +353,6 @@ static int imx_set_mode(struct thermal_zone_device *tz,
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
>  			     soc_data->power_down_mask);
>  
> -		tz->polling_delay = 0;
> -		tz->passive_delay = 0;
> -
>  		if (data->irq_enabled) {
>  			disable_irq(data->irq);
>  			data->irq_enabled = false;
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index 8e8c9af7e5f4..9af862ab9f65 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -386,10 +386,6 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>  	if (!priv)
>  		return -EINVAL;
>  
> -	if (mode != THERMAL_DEVICE_ENABLED &&
> -	    mode != THERMAL_DEVICE_DISABLED)
> -		return -EINVAL;
> -
>  	if (mode != thermal->mode)
>  		result = int3400_thermal_run_osc(priv->adev->handle,
>  						priv->current_uuid_index,
> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
> index 011fd7f0a01e..8a6272570347 100644
> --- a/drivers/thermal/thermal_of.c
> +++ b/drivers/thermal/thermal_of.c
> @@ -267,22 +267,6 @@ static int of_thermal_unbind(struct thermal_zone_device *thermal,
>  	return 0;
>  }
>  
> -static int of_thermal_set_mode(struct thermal_zone_device *tz,
> -			       enum thermal_device_mode mode)
> -{
> -	struct __thermal_zone *data = tz->devdata;
> -
> -	if (mode == THERMAL_DEVICE_ENABLED) {
> -		tz->polling_delay = data->polling_delay;
> -		tz->passive_delay = data->passive_delay;
> -	} else {
> -		tz->polling_delay = 0;
> -		tz->passive_delay = 0;
> -	}
> -
> -	return 0;
> -}
> -
>  static int of_thermal_get_trip_type(struct thermal_zone_device *tz, int trip,
>  				    enum thermal_trip_type *type)
>  {
> @@ -374,8 +358,6 @@ static int of_thermal_get_crit_temp(struct thermal_zone_device *tz,
>  }
>  
>  static struct thermal_zone_device_ops of_thermal_ops = {
> -	.set_mode = of_thermal_set_mode,
> -
>  	.get_trip_type = of_thermal_get_trip_type,
>  	.get_trip_temp = of_thermal_get_trip_temp,
>  	.set_trip_temp = of_thermal_set_trip_temp,
> 
