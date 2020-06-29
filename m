Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901B920D3E4
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbgF2TC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:02:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43846 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730569AbgF2TC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:02:57 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200629141406euoutp02aad02b09f9f720d691db8aa6530047ef~dCUe77E5p0514705147euoutp021;
        Mon, 29 Jun 2020 14:14:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200629141406euoutp02aad02b09f9f720d691db8aa6530047ef~dCUe77E5p0514705147euoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593440046;
        bh=4j80Bcpngo1Pzs6K4L++vo7tMK52/mOkyGe2x3SZ4Z0=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=FJKvIc+RVgPwc7KDahNXtpBpeizbZYPD5b1op0iKU9PFq6N+7qNSSRoDP8LZMaU6N
         lG/dfDaxSRONWnHX8AC1sbsAiwLpHFPGFDOY+5CRsNcBItxlluGTSaMccK38DgPzPB
         ZNkrG7858jArVrCDBi+1gt5jRZaZ40w8LCVqstaw=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200629141406eucas1p11b333790afb03afea4da32e237bc5af1~dCUewjpEV1478014780eucas1p1Q;
        Mon, 29 Jun 2020 14:14:06 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 73.F5.06456.E27F9FE5; Mon, 29
        Jun 2020 15:14:06 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200629141406eucas1p252ec194e179b36544c76497c4f37f01c~dCUeRClVx1287012870eucas1p2x;
        Mon, 29 Jun 2020 14:14:06 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200629141406eusmtrp22d184af3cb065d238232b9c77ac79744~dCUePnLSN3124031240eusmtrp2x;
        Mon, 29 Jun 2020 14:14:06 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-c6-5ef9f72e0c9e
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 9C.4B.06314.D27F9FE5; Mon, 29
        Jun 2020 15:14:05 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200629141404eusmtip13abf5194c0437d4694434c0b2c604f1e~dCUcagJCR0804808048eusmtip1M;
        Mon, 29 Jun 2020 14:14:04 +0000 (GMT)
Subject: Re: [PATCH v7 07/11] thermal: Use mode helpers in drivers
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
Message-ID: <c4977387-0f70-f9c5-f543-61ce7501fb12@samsung.com>
Date:   Mon, 29 Jun 2020 16:14:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200629122925.21729-8-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1DTdRjH7/P9vdXs6zD3OcrqdodengGeXfecpWfWXd+/Kos/yity5lfk
        GuhtgBl/hBcy3cFyyA+bnA4xtkFnugFjSpwM40fIJLpmGijoQjC+pFuho3O07QsX/72e53m/
        P+/n+ePDkepjbCqXm18gGvJ1ei2jpNp6oldfSn8Yzc60NGrB1Rej4GEgSkDjnZsUVB6fJ+H8
        wXECTkZWQd3VUgrM9ZlwqG2UhvFf34GyyHEK5m//Ga8uvQHXD14koG6yCG47bSx4AuU0NFX7
        KDjtqmfANy4x4Oj8GoH7TpAG85yLhEjFZQStUzMEhMfiQdPOERaOeKwIulvtBHSbOmnosa+E
        3hoLDbX3TyAYGvoImjsmSbgyMExDaNzCwGOvm4LJFg0MXCyAHw79TILHXU1C0B6hwDF2gd2y
        Tjj5XbHwR3sdLfxiqSCE9tEzSGhxXScEZzhD8NlGWcHjXCs0dEwRgrvpCCOMBDsYYSYQiPfP
        fCk8mA6xwkRtNyEcvS8x7+Ltytd2ifrcItGQsXmHck/VdAOzr7kBfX6vOUSXoHApMiMFh/mX
        sWumP85KTs07Ee40x2i5+Bth69AjUi4iCFf8NUMsWsI9VkoeOBA2BfsWLBLC7mh/8uEUfiv2
        z0bJBK/gN+Bom8QmRCRvVmHpbiebGDD8Rmw1NSUNKn4zbvWUJSMoPg17fV1Jfpr/AIfHumlZ
        sxz3fxOiEqzgN+ERS0uSSV6Db4ROETI/j71SXXJvzM8qcMmNakre+018QjItcAq+19vCyvws
        nvclzAnDWYQfH55ccHsRdhyLMbLqVTwSmIszF494EX9/IUNuv46vBUvIRBvzy/Bv0nJ5iWW4
        sq12oa3Ch8vUsno1Ptd4jlmMNftc5FGktS05zbbkHNuSc2z/59oR1YQ0YqExL0c0rs8X96cb
        dXnGwvyc9E/35rlR/KsMxHrD7eif4Z1+xHNI+6RqRyCaraZ1RcYDeX6EOVK7QrV1cCBbrdql
        O/CFaNj7iaFQLxr96BmO0mpUG05Pfazmc3QF4meiuE80LE4JTpFagmxz6YOm8+XFlXOnUoO7
        V7oHd//4reDx2iayskL2ritb3k675a/X60vXabrS+v/1vJKrvFWzrXJVX9/7127OZr73U9U2
        j7N4k3rjE9a0ibvMfO/v2Skdl0pfWKNstDnPCmOpDwxvbZccq4dTdlpqLu9/7lHVUyFd1pqv
        FNPRD2MF5ZoJLWXco1u/ljQYdf8Bc0RL4yYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTZxjH955bD2Z1ZxXlXTPjUt2WECyW64MK8bIs58MSt5gYsyFY4QQU
        SrWnkDk+IIkCNqMrqFNrw7g5oZgsttwqaCZdYBOtihsZo12odIhCHaOZ2MllLdWEb7/3/f9/
        efIkD0vKmhk5e7hIL+iK1IUKZhU1uDjg2bx5Lpi1xVaeDq0/L1Iw5woS8P34nxTUXlgi4Vq5
        l4C6wHqw3DtJgaFhC5zq9NDg/W0PVAQuULD0aCr0+nE3jJT3EGCZLIFHLWYJ2F1f02A956Cg
        sbWBAYfXz8CVm98gsI0P02D4r5WEQPVPCDqePCNgdiw0aLrFLYHT9hoEzo56ApyVN2nor18H
        A98aaTg/cwnB/fuZ0NY7ScKdwSEafF4jAwtdNgom22NgsEcPN049IMFuO0fCcH2Agitj1yU7
        4vi6q6X8X90Wmn9orCb4bk8z4ttbRwi+ZTaed5g9Et7eEss39T4heJv1NMO7h3sZ/pnLFfpv
        LuP/mfZJ+InzToI3zfiZT/Hnyu06bbFeeC9fK+rTFV+oIEGpSgNlQlKaUpWYemBrQrIiPmN7
        rlB4uETQxWccVOafnW5ijrY1oS+ftvnoE2j2JDKgKBZzSXi2v4YyoFWsjLuM8OiLS6GADQXv
        4oEfSiKdNXh+2MBEOlMI1/oW6HCwhtuF+54HyTBHc4k42OmXhEskZ5TinomrkojhRPj3uX+Z
        cIvhtuKaSuvyaCmXgTvsFUSYKe593OW4tcxruf3Y2W1+1Xkb/3LRR4U5ikvHbmP7MpPch3i+
        boiMcAz+w/cdEeENuMtvIU1IZl6hm1co5hWKeYVSjygrihaKRU2eRlQpRbVGLC7KU+ZoNTYU
        utDO/qC9Gw1d29uHOBYp3pQedAWzZLS6RDyu6UOYJRXR0l13B7Nk0lz18a8EnTZbV1woiH0o
        ObRcDSlfm6MN3XuRPluVrEqFNFVqYmpiCihipFXcrUwZl6fWCwWCcFTQvfYINkp+AlXTSR5L
        8ztL5NimTO/jtI8NO85YJ0wLxxr3vrwxV3BnQ1vK0w+OlE0J1S8aP1oKmKJod/m+xdHSdbUP
        Nsb9ujq2YV/ZJ+acfPmIz3Nopu6t4F2/Z/w5e2xnTtztmdKqbGVW5TTVPppdkXJIyPv7sckx
        7/5sfdW2jDMX5+UFb4zF7M9VUGK+WhVL6kT1/wKGOT63AwAA
X-CMS-MailID: 20200629141406eucas1p252ec194e179b36544c76497c4f37f01c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200629123002eucas1p2a1f3a734d320fff4d1a38f994201f8f3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200629123002eucas1p2a1f3a734d320fff4d1a38f994201f8f3
References: <20200629122925.21729-1-andrzej.p@collabora.com>
        <CGME20200629123002eucas1p2a1f3a734d320fff4d1a38f994201f8f3@eucas1p2.samsung.com>
        <20200629122925.21729-8-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/29/20 2:29 PM, Andrzej Pietrasiewicz wrote:
> Use thermal_zone_device_{en|dis}able() and thermal_zone_device_is_enabled().
> 
> Consequently, all set_mode() implementations in drivers:
> 
> - can stop modifying tzd's "mode" member,
> - shall stop taking tzd's lock, as it is taken in the helpers
> - shall stop calling thermal_zone_device_update() as it is called in the
> helpers
> - can assume they are called when the mode truly changes, so checks to
> verify that can be dropped
> 
> Not providing set_mode() by a driver no longer prevents the core from
> being able to set tzd's mode, so the relevant check in mode_store() is
> removed.
> 
> Other comments:
> 
> - acpi/thermal.c: tz->thermal_zone->mode will be updated only after we
> return from set_mode(), so use function parameter in thermal_set_mode()
> instead, no need to call acpi_thermal_check() in set_mode()
> - thermal/imx_thermal.c: regmap writes and mode assignment are done in
> thermal_zone_device_{en|dis}able() and set_mode() callback
> - thermal/intel/intel_quark_dts_thermal.c: soc_dts_{en|dis}able() are a
> part of set_mode() callback, so they don't need to modify tzd->mode, and
> don't need to fall back to the opposite mode if unsuccessful, as the return
> value will be propagated to thermal_zone_device_{en|dis}able() and
> ultimately tzd's member will not be changed in thermal_zone_device_set_mode().
> - thermal/of-thermal.c: no need to set zone->mode to DISABLED in
> of_parse_thermal_zones() as a tzd is kzalloc'ed so mode is DISABLED anyway
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> [for acerhdf]
> Acked-by: Peter Kaestle <peter@piie.net>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
>  drivers/acpi/thermal.c                        | 21 ++++++-----
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 37 +++++++++----------
>  drivers/platform/x86/acerhdf.c                | 17 +++++----
>  drivers/thermal/da9062-thermal.c              |  6 ++-
>  drivers/thermal/hisi_thermal.c                |  6 ++-
>  drivers/thermal/imx_thermal.c                 | 33 +++++++----------
>  .../intel/int340x_thermal/int3400_thermal.c   |  5 +--
>  .../thermal/intel/intel_quark_dts_thermal.c   | 18 ++-------
>  drivers/thermal/rockchip_thermal.c            |  6 ++-
>  drivers/thermal/sprd_thermal.c                |  6 ++-
>  drivers/thermal/thermal_core.c                |  2 +-
>  drivers/thermal/thermal_of.c                  | 10 +----
>  drivers/thermal/thermal_sysfs.c               | 11 ++----
>  13 files changed, 80 insertions(+), 98 deletions(-)
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 592be97c4456..52b6cda1bcc3 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -499,7 +499,7 @@ static void acpi_thermal_check(void *data)
>  {
>  	struct acpi_thermal *tz = data;
>  
> -	if (tz->thermal_zone->mode != THERMAL_DEVICE_ENABLED)
> +	if (!thermal_zone_device_is_enabled(tz->thermal_zone))
>  		return;
>  
>  	thermal_zone_device_update(tz->thermal_zone,
> @@ -542,14 +542,11 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
>  	if (mode == THERMAL_DEVICE_DISABLED)
>  		pr_warn("thermal zone will be disabled\n");
>  
> -	if (mode != tz->thermal_zone->mode) {
> -		tz->thermal_zone->mode = mode;
> -		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -			"%s kernel ACPI thermal control\n",
> -			tz->thermal_zone->mode == THERMAL_DEVICE_ENABLED ?
> -			"Enable" : "Disable"));
> -		acpi_thermal_check(tz);
> -	}
> +	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +		"%s kernel ACPI thermal control\n",
> +		mode == THERMAL_DEVICE_ENABLED ?
> +		"Enable" : "Disable"));
> +
>  	return 0;
>  }
>  
> @@ -897,13 +894,17 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>  		goto remove_dev_link;
>  	}
>  
> -	tz->thermal_zone->mode = THERMAL_DEVICE_ENABLED;
> +	result = thermal_zone_device_enable(tz->thermal_zone);
> +	if (result)
> +		goto acpi_bus_detach;
>  
>  	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
>  		 tz->thermal_zone->id);
>  
>  	return 0;
>  
> +acpi_bus_detach:
> +	acpi_bus_detach_private_data(tz->device->handle);
>  remove_dev_link:
>  	sysfs_remove_link(&tz->thermal_zone->device.kobj, "device");
>  remove_tz_link:
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index ad61b2db30b8..4fb73d0fd167 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -280,18 +280,11 @@ static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
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
> -	tzdev->mode = mode;
> -	mutex_unlock(&tzdev->lock);
> -
> -	thermal_zone_device_update(tzdev, THERMAL_EVENT_UNSPECIFIED);
> -
>  	return 0;
>  }
>  
> @@ -458,19 +451,11 @@ static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
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
> -	tzdev->mode = mode;
> -
> -	mutex_unlock(&tzdev->lock);
> -
> -	thermal_zone_device_update(tzdev, THERMAL_EVENT_UNSPECIFIED);
> -
>  	return 0;
>  }
>  
> @@ -756,8 +741,11 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
>  		return err;
>  	}
>  
> -	module_tz->tzdev->mode = THERMAL_DEVICE_ENABLED;
> -	return 0;
> +	err = thermal_zone_device_enable(module_tz->tzdev);
> +	if (err)
> +		thermal_zone_device_unregister(module_tz->tzdev);
> +
> +	return err;
>  }
>  
>  static void mlxsw_thermal_module_tz_fini(struct thermal_zone_device *tzdev)
> @@ -860,6 +848,7 @@ static int
>  mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
>  {
>  	char tz_name[MLXSW_THERMAL_ZONE_MAX_NAME];
> +	int ret;
>  
>  	snprintf(tz_name, sizeof(tz_name), "mlxsw-gearbox%d",
>  		 gearbox_tz->module + 1);
> @@ -872,8 +861,11 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
>  	if (IS_ERR(gearbox_tz->tzdev))
>  		return PTR_ERR(gearbox_tz->tzdev);
>  
> -	gearbox_tz->tzdev->mode = THERMAL_DEVICE_ENABLED;
> -	return 0;
> +	ret = thermal_zone_device_enable(gearbox_tz->tzdev);
> +	if (ret)
> +		thermal_zone_device_unregister(gearbox_tz->tzdev);
> +
> +	return ret;
>  }
>  
>  static void
> @@ -1041,10 +1033,15 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
>  	if (err)
>  		goto err_unreg_modules_tzdev;
>  
> -	thermal->tzdev->mode = THERMAL_DEVICE_ENABLED;
> +	err = thermal_zone_device_enable(thermal->tzdev);
> +	if (err)
> +		goto err_unreg_gearboxes;
> +
>  	*p_thermal = thermal;
>  	return 0;
>  
> +err_unreg_gearboxes:
> +	mlxsw_thermal_gearboxes_fini(thermal);
>  err_unreg_modules_tzdev:
>  	mlxsw_thermal_modules_fini(thermal);
>  err_unreg_tzdev:
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 58c4e1caaa09..8fe0ecb6a626 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -397,19 +397,16 @@ static inline void acerhdf_revert_to_bios_mode(void)
>  {
>  	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>  	kernelmode = 0;
> -	if (thz_dev) {
> -		thz_dev->mode = THERMAL_DEVICE_DISABLED;
> +	if (thz_dev)
>  		thz_dev->polling_delay = 0;
> -	}
> +
>  	pr_notice("kernel mode fan control OFF\n");
>  }
>  static inline void acerhdf_enable_kernelmode(void)
>  {
>  	kernelmode = 1;
> -	thz_dev->mode = THERMAL_DEVICE_ENABLED;
>  
>  	thz_dev->polling_delay = interval*1000;
> -	thermal_zone_device_update(thz_dev, THERMAL_EVENT_UNSPECIFIED);
>  	pr_notice("kernel mode fan control ON\n");
>  }
>  
> @@ -723,6 +720,8 @@ static void acerhdf_unregister_platform(void)
>  
>  static int __init acerhdf_register_thermal(void)
>  {
> +	int ret;
> +
>  	cl_dev = thermal_cooling_device_register("acerhdf-fan", NULL,
>  						 &acerhdf_cooling_ops);
>  
> @@ -736,8 +735,12 @@ static int __init acerhdf_register_thermal(void)
>  	if (IS_ERR(thz_dev))
>  		return -EINVAL;
>  
> -	thz_dev->mode = kernelmode ?
> -		THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED;
> +	if (kernelmode)
> +		ret = thermal_zone_device_enable(thz_dev);
> +	else
> +		ret = thermal_zone_device_disable(thz_dev);
> +	if (ret)
> +		return ret;
>  
>  	if (strcmp(thz_dev->governor->name,
>  				acerhdf_zone_params.governor_name)) {
> diff --git a/drivers/thermal/da9062-thermal.c b/drivers/thermal/da9062-thermal.c
> index a7ac8afb063e..4d74994f160a 100644
> --- a/drivers/thermal/da9062-thermal.c
> +++ b/drivers/thermal/da9062-thermal.c
> @@ -237,7 +237,11 @@ static int da9062_thermal_probe(struct platform_device *pdev)
>  		ret = PTR_ERR(thermal->zone);
>  		goto err;
>  	}
> -	thermal->zone->mode = THERMAL_DEVICE_ENABLED;
> +	ret = thermal_zone_device_enable(thermal->zone);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Cannot enable thermal zone device\n");
> +		goto err_zone;
> +	}
>  
>  	dev_dbg(&pdev->dev,
>  		"TJUNC temperature polling period set at %d ms\n",
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
> index 2c7ee5da608a..53abb1be1cba 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -255,7 +255,7 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  	bool wait;
>  	u32 val;
>  
> -	if (tz->mode == THERMAL_DEVICE_ENABLED) {
> +	if (thermal_zone_device_is_enabled(tz)) {
>  		/* Check if a measurement is currently in progress */
>  		regmap_read(map, soc_data->temp_data, &val);
>  		wait = !(val & soc_data->temp_valid_mask);
> @@ -282,7 +282,7 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  
>  	regmap_read(map, soc_data->temp_data, &val);
>  
> -	if (tz->mode != THERMAL_DEVICE_ENABLED) {
> +	if (!thermal_zone_device_is_enabled(tz)) {
>  		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>  			     soc_data->measure_temp_mask);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
> @@ -365,9 +365,6 @@ static int imx_set_mode(struct thermal_zone_device *tz,
>  		}
>  	}
>  
> -	tz->mode = mode;
> -	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
> -
>  	return 0;
>  }
>  
> @@ -819,7 +816,9 @@ static int imx_thermal_probe(struct platform_device *pdev)
>  		     data->socdata->measure_temp_mask);
>  
>  	data->irq_enabled = true;
> -	data->tz->mode = THERMAL_DEVICE_ENABLED;
> +	ret = thermal_zone_device_enable(data->tz);
> +	if (ret)
> +		goto thermal_zone_unregister;
>  
>  	ret = devm_request_threaded_irq(&pdev->dev, data->irq,
>  			imx_thermal_alarm_irq, imx_thermal_alarm_irq_thread,
> @@ -861,19 +860,18 @@ static int imx_thermal_remove(struct platform_device *pdev)
>  static int __maybe_unused imx_thermal_suspend(struct device *dev)
>  {
>  	struct imx_thermal_data *data = dev_get_drvdata(dev);
> -	struct regmap *map = data->tempmon;
> +	int ret;
>  
>  	/*
>  	 * Need to disable thermal sensor, otherwise, when thermal core
>  	 * try to get temperature before thermal sensor resume, a wrong
>  	 * temperature will be read as the thermal sensor is powered
> -	 * down.
> +	 * down. This is done in set_mode() operation called from
> +	 * thermal_zone_device_disable()
>  	 */
> -	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
> -		     data->socdata->measure_temp_mask);
> -	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
> -		     data->socdata->power_down_mask);
> -	data->tz->mode = THERMAL_DEVICE_DISABLED;
> +	ret = thermal_zone_device_disable(data->tz);
> +	if (ret)
> +		return ret;
>  	clk_disable_unprepare(data->thermal_clk);
>  
>  	return 0;
> @@ -882,18 +880,15 @@ static int __maybe_unused imx_thermal_suspend(struct device *dev)
>  static int __maybe_unused imx_thermal_resume(struct device *dev)
>  {
>  	struct imx_thermal_data *data = dev_get_drvdata(dev);
> -	struct regmap *map = data->tempmon;
>  	int ret;
>  
>  	ret = clk_prepare_enable(data->thermal_clk);
>  	if (ret)
>  		return ret;
>  	/* Enabled thermal sensor after resume */
> -	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
> -		     data->socdata->power_down_mask);
> -	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
> -		     data->socdata->measure_temp_mask);
> -	data->tz->mode = THERMAL_DEVICE_ENABLED;
> +	ret = thermal_zone_device_enable(data->tz);
> +	if (ret)
> +		return ret;
>  
>  	return 0;
>  }
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index 9a622aaf29dd..3c0397a29b8c 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -390,12 +390,11 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>  	    mode != THERMAL_DEVICE_DISABLED)
>  		return -EINVAL;
>  
> -	if (mode != thermal->mode) {
> -		thermal->mode = mode;
> +	if (mode != thermal->mode)
>  		result = int3400_thermal_run_osc(priv->adev->handle,
>  						priv->current_uuid_index,
>  						mode == THERMAL_DEVICE_ENABLED);
> -	}
> +
>  
>  	evaluate_odvp(priv);
>  
> diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
> index c4879b4bfbf1..e29c3e330b17 100644
> --- a/drivers/thermal/intel/intel_quark_dts_thermal.c
> +++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
> @@ -126,10 +126,8 @@ static int soc_dts_enable(struct thermal_zone_device *tzd)
>  	if (ret)
>  		return ret;
>  
> -	if (out & QRK_DTS_ENABLE_BIT) {
> -		tzd->mode = THERMAL_DEVICE_ENABLED;
> +	if (out & QRK_DTS_ENABLE_BIT)
>  		return 0;
> -	}
>  
>  	if (!aux_entry->locked) {
>  		out |= QRK_DTS_ENABLE_BIT;
> @@ -137,10 +135,7 @@ static int soc_dts_enable(struct thermal_zone_device *tzd)
>  				     QRK_DTS_REG_OFFSET_ENABLE, out);
>  		if (ret)
>  			return ret;
> -
> -		tzd->mode = THERMAL_DEVICE_ENABLED;
>  	} else {
> -		tzd->mode = THERMAL_DEVICE_DISABLED;
>  		pr_info("DTS is locked. Cannot enable DTS\n");
>  		ret = -EPERM;
>  	}
> @@ -159,10 +154,8 @@ static int soc_dts_disable(struct thermal_zone_device *tzd)
>  	if (ret)
>  		return ret;
>  
> -	if (!(out & QRK_DTS_ENABLE_BIT)) {
> -		tzd->mode = THERMAL_DEVICE_DISABLED;
> +	if (!(out & QRK_DTS_ENABLE_BIT))
>  		return 0;
> -	}
>  
>  	if (!aux_entry->locked) {
>  		out &= ~QRK_DTS_ENABLE_BIT;
> @@ -171,10 +164,7 @@ static int soc_dts_disable(struct thermal_zone_device *tzd)
>  
>  		if (ret)
>  			return ret;
> -
> -		tzd->mode = THERMAL_DEVICE_DISABLED;
>  	} else {
> -		tzd->mode = THERMAL_DEVICE_ENABLED;
>  		pr_info("DTS is locked. Cannot disable DTS\n");
>  		ret = -EPERM;
>  	}
> @@ -404,9 +394,7 @@ static struct soc_sensor_entry *alloc_soc_dts(void)
>  		goto err_ret;
>  	}
>  
> -	mutex_lock(&dts_update_mutex);
> -	err = soc_dts_enable(aux_entry->tzone);
> -	mutex_unlock(&dts_update_mutex);
> +	err = thermal_zone_device_enable(aux_entry->tzone);
>  	if (err)
>  		goto err_aux_status;
>  
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
> index f02c57c986f0..52d136780577 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1521,7 +1521,7 @@ static int thermal_pm_notify(struct notifier_block *nb,
>  	case PM_POST_SUSPEND:
>  		atomic_set(&in_suspend, 0);
>  		list_for_each_entry(tz, &thermal_tz_list, node) {
> -			if (tz->mode == THERMAL_DEVICE_DISABLED)
> +			if (!thermal_zone_device_is_enabled(tz))
>  				continue;
>  
>  			thermal_zone_device_init(tz);
> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
> index ba65d48a48cb..43a516a35d64 100644
> --- a/drivers/thermal/thermal_of.c
> +++ b/drivers/thermal/thermal_of.c
> @@ -272,8 +272,6 @@ static int of_thermal_set_mode(struct thermal_zone_device *tz,
>  {
>  	struct __thermal_zone *data = tz->devdata;
>  
> -	mutex_lock(&tz->lock);
> -
>  	if (mode == THERMAL_DEVICE_ENABLED) {
>  		tz->polling_delay = data->polling_delay;
>  		tz->passive_delay = data->passive_delay;
> @@ -282,11 +280,6 @@ static int of_thermal_set_mode(struct thermal_zone_device *tz,
>  		tz->passive_delay = 0;
>  	}
>  
> -	mutex_unlock(&tz->lock);
> -
> -	tz->mode = mode;
> -	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
> -
>  	return 0;
>  }
>  
> @@ -541,7 +534,7 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id, void *data,
>  			tzd = thermal_zone_of_add_sensor(child, sensor_np,
>  							 data, ops);
>  			if (!IS_ERR(tzd))
> -				tzd->ops->set_mode(tzd, THERMAL_DEVICE_ENABLED);
> +				thermal_zone_device_enable(tzd);
>  
>  			of_node_put(child);
>  			goto exit;
> @@ -1120,7 +1113,6 @@ int __init of_parse_thermal_zones(void)
>  			of_thermal_free_zone(tz);
>  			/* attempting to build remaining zones still */
>  		}
> -		zone->mode = THERMAL_DEVICE_DISABLED;
>  	}
>  	of_node_put(np);
>  
> diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
> index 096370977068..c23d67c4dc4e 100644
> --- a/drivers/thermal/thermal_sysfs.c
> +++ b/drivers/thermal/thermal_sysfs.c
> @@ -49,9 +49,9 @@ static ssize_t
>  mode_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>  	struct thermal_zone_device *tz = to_thermal_zone(dev);
> +	int enabled = thermal_zone_device_is_enabled(tz);
>  
> -	return sprintf(buf, "%s\n", tz->mode == THERMAL_DEVICE_ENABLED ?
> -		       "enabled" : "disabled");
> +	return sprintf(buf, "%s\n", enabled ? "enabled" : "disabled");
>  }
>  
>  static ssize_t
> @@ -61,13 +61,10 @@ mode_store(struct device *dev, struct device_attribute *attr,
>  	struct thermal_zone_device *tz = to_thermal_zone(dev);
>  	int result;
>  
> -	if (!tz->ops->set_mode)
> -		return -EPERM;
> -
>  	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
> -		result = tz->ops->set_mode(tz, THERMAL_DEVICE_ENABLED);
> +		result = thermal_zone_device_enable(tz);
>  	else if (!strncmp(buf, "disabled", sizeof("disabled") - 1))
> -		result = tz->ops->set_mode(tz, THERMAL_DEVICE_DISABLED);
> +		result = thermal_zone_device_disable(tz);
>  	else
>  		result = -EINVAL;
>  
> 

