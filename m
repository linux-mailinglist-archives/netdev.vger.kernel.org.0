Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718721A99DF
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 12:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896124AbgDOKFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 06:05:50 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45166 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896125AbgDOKFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 06:05:47 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200415100544euoutp02acc15f4e2950eee6461d38a70d878935~F9jOBvPgq2867328673euoutp02G
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 10:05:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200415100544euoutp02acc15f4e2950eee6461d38a70d878935~F9jOBvPgq2867328673euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586945144;
        bh=jbNCtnfRBAFKgUuzv0KIEfDWAQjQVhjUG+x3ztvh+dM=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=EJtkvJNoRMar0GHhiwWM8RRqjM8DXldjUXc7UZEo5wNC+3syvFv/r27PPqdbDVPZL
         5aF7yAZw9XgLktiM3Girav+ZD5+t5RwZGsUuItndaVzzykHPz3VDORJUGGulckk8PT
         X/Cr2WIQAh68qHfbWHdcZvOGJ5benTAXpGsp/3nY=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200415100544eucas1p224d9d4ff6bfadc1542a469752de6612f~F9jNpIQDY2206722067eucas1p2d;
        Wed, 15 Apr 2020 10:05:44 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id BF.61.60679.87CD69E5; Wed, 15
        Apr 2020 11:05:44 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200415100543eucas1p24e24293da39844ca8791db86af5365a7~F9jNOqo0e0866108661eucas1p2T;
        Wed, 15 Apr 2020 10:05:43 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200415100543eusmtrp2144d6a2cc5190571debfac319489d52e~F9jNNjygq1123511235eusmtrp2X;
        Wed, 15 Apr 2020 10:05:43 +0000 (GMT)
X-AuditID: cbfec7f4-0e5ff7000001ed07-c6-5e96dc781b9e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 73.4E.07950.77CD69E5; Wed, 15
        Apr 2020 11:05:43 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200415100542eusmtip2a2c8c572db469eb5170c653c69afac17~F9jMLnmVy1701817018eusmtip2B;
        Wed, 15 Apr 2020 10:05:42 +0000 (GMT)
Subject: Re: [RFC 2/8] thermal: Properly handle mode values in .set_mode()
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
Message-ID: <be73e437-8913-25f5-4abe-cad2caedcf74@samsung.com>
Date:   Wed, 15 Apr 2020 12:05:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200407174926.23971-3-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH89x7e3tprLm2Yk+chtlFzTSjaI154gtxcctuNJua+EGNL3R4
        QSItpOVF+DAxatXODdQUXVOxAlLAbcWCQBlTUvCFAJ2yzaBBaqVZqKNGBF9AW9fLhYxvv3PO
        ///8z0kehlS00fOZDEMObzToMtW0jGq8Pe777FB/6d6kkogS19yNUviNb5zAVYMDFD574QOJ
        y0YXYvsfxyhsuZyEA39vwebRCxQOtG3ED4/8RmD7UB6u952W4Fqrh8KeQJjGzhvFCLsHH0iw
        ZaKGxKM/dCB82zEP37u3G19tHSJxd1evBAcDP9I40uSm8FCDCv9+/D6J691WcsMCrvlxJeIa
        ah4SXPVLDeexPZZy9dXLuIrWEMG5a0/RXP+DVpp77vPF+pWHuZHhoJT753w7wZW8CNPctefN
        BFccSeLe/jks2arcJVu3n8/MyOONmuQU2YFotDD7xSeHfB1maRFyLrSgOAbYVeDyNyELkjEK
        thrB064ySizGEJhHXLRYjCJwHq8mpy09A6+l4sCJwO95NlWEEVRVRCZVSnYT3Op4RQs8l9XC
        eGN4UkSyr6Xg/Ss0KaLZNXDmRC0SWM4mQ+h6r0Rgil0M9VdLJ83x7A54+aRdImrmQOdPQUrg
        OHY9HP23lxCYZFXwKHhpihOgKWwnhTBgv4+DS/1PCXHvL8Dyvk0ishKe3WmQirwAPngEs2D4
        FUHk5NCUuyl29bkoLarWQr9vIsZMLOJTcLVoBAT2c7jRniPibOgLzxF3mA1nG8+TYlsOJ80K
        8Y0lUFdVR0+nWjw1ZAlS22ZcZptxjW3GNbb/Yx2IqkUqPtekT+dNKw18fqJJpzflGtITU7P0
        bhT7113RO2PNqOX9t17EMkg9S/6xy7pXIdHlmQr0XgQMqZ4rd+ljLfl+XUEhb8zaZ8zN5E1e
        9BFDqVVybXloj4JN1+XwB3k+mzdOTwkmbn4ROuGG1Hatt1zbdbizryCtYORK5fKvhncrVhZv
        w4GiztPB9aUpW0c049cStRnlm1P8CRO/rP6u2ZG6lDDEV9xX5jtW3XT07fkm84msUZu1r+yN
        /6L9YHaPyp5Q8qU1NDbQkvZu0fb4JEt3XX5D2s5kZ/na7WbN4KafqUJr3YrEr4f9asp0QLdi
        GWk06f4D8yV/ZtMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+85tR2t13Cw/zC4swugy3dT2zWoKQh3KSBMiyrRRB63cJjvT
        tKALldXQtGKmS9TI8haIm1dSy0tZVGsZCeWFxCFaKZWZGmZtWrD/fjzv8zwvL7w0LrKTvvQx
        rYHTa9VJEsqTeDHb2b/pZG9uXOCnHyGo/NksgSZt0xi6P9hPoBt5f3BUOL4CFby+SCDjnUA0
        8G4PyhjPI9DA4wj0/vxDDBUMpyKrLZNEFaZGAjUOjFKotCUbIMtgN4mMv8pxNJ7VAdDT4mXI
        bo9FlU3DOHr5ootEjoFrFPpdbyHQcI0Par70BkdWiwkP92Mb+koAW1P+HmPLvgewjeY+AWst
        W8/ebRrBWEvFVYrt7W6i2DGbzamXnGW/fXEI2KFb7Rib83WUYqvHGjA2+3cgO/X2CxklPiDd
        qtelGLjViTresE1yUIbkUpkSSeXBSqksSHEoVB4iCVBtPcolHUvl9AGqw9LE2dlTyV/XpNk6
        MgTnQOkKI/CgIRMMX/X/FBiBJy1i7gHYXD1NGgHtHPjBzqrUeY8YznQbqXnPZwBzZ1oI10DM
        7IRPOiYoF3szQXC6bnSuCGemBHDiQxnuKhIxOljTG+3yUEwovH65ArhYyKjgSG0X6WKCWQut
        lblzPUuZ/bC9wfzP4wWf5zvmdnkw2+CFz12Yi3HGH84UduHz7AM/OIr+6atg/WgBngNEZre4
        2S1idouY3SLFgKgA3lwKr0nQ8HIpr9bwKdoE6RGdxgKc31T3dLqmARjHYtoAQwPJIuGzB6Y4
        EalO5dM1bQDSuMRbWKVxSsKj6vRTnF4Xr09J4vg2EOI87jruu/SIzvmbWkO8LESmQEqZIkgR
        tBlJfIRXmNZYEZOgNnAnOC6Z0//PYbSH7zlQqxxblPm6k41/FNHWU3g27xAXUWQWZpD2LU2b
        EhbK2l95Nn9sxbxMi8eb96r8NwZsmNp1si9/+75SXXBPWNqWocaSvOJ6Vevk6dCfWWnExoyV
        S7LPtFbp1034TR6XhpfcNqYbdmTS0fxViz3/baxdGRm1e0G3JidsuTrGK3JGfFNC8Ilq2Xpc
        z6v/AlCm9/ZjAwAA
X-CMS-MailID: 20200415100543eucas1p24e24293da39844ca8791db86af5365a7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200415100543eucas1p24e24293da39844ca8791db86af5365a7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200415100543eucas1p24e24293da39844ca8791db86af5365a7
References: <20200407174926.23971-1-andrzej.p@collabora.com>
        <20200407174926.23971-3-andrzej.p@collabora.com>
        <CGME20200415100543eucas1p24e24293da39844ca8791db86af5365a7@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/7/20 7:49 PM, Andrzej Pietrasiewicz wrote:
> Allow only THERMAL_DEVICE_ENABLED and THERMAL_DEVICE_DISABLED as valid
> states to transition to.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 8 ++++++--
>  drivers/platform/x86/acerhdf.c                     | 4 ++++
>  drivers/thermal/imx_thermal.c                      | 4 +++-
>  drivers/thermal/intel/intel_quark_dts_thermal.c    | 5 ++++-
>  drivers/thermal/of-thermal.c                       | 4 +++-
>  5 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index ce0a6837daa3..cd435ca7adbe 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -296,8 +296,10 @@ static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
>  
>  	if (mode == THERMAL_DEVICE_ENABLED)
>  		tzdev->polling_delay = thermal->polling_delay;
> -	else
> +	else if (mode == THERMAL_DEVICE_DISABLED)
>  		tzdev->polling_delay = 0;
> +	else
> +		return -EINVAL;

Making sure that the valid parameters are passed to driver specific
->set_mode method should be handled in the higher layer (callers).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
 
>  	mutex_unlock(&tzdev->lock);
>  
> @@ -486,8 +488,10 @@ static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
>  
>  	if (mode == THERMAL_DEVICE_ENABLED)
>  		tzdev->polling_delay = thermal->polling_delay;
> -	else
> +	else if (mode == THERMAL_DEVICE_DISABLED)
>  		tzdev->polling_delay = 0;
> +	else
> +		return -EINVAL;
>  
>  	mutex_unlock(&tzdev->lock);
>  
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 8cc86f4e3ac1..d5188c1d688b 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -431,6 +431,10 @@ static int acerhdf_get_mode(struct thermal_zone_device *thermal,
>  static int acerhdf_set_mode(struct thermal_zone_device *thermal,
>  			    enum thermal_device_mode mode)
>  {
> +	if (mode != THERMAL_DEVICE_DISABLED &&
> +	    mode != THERMAL_DEVICE_ENABLED)
> +		return -EINVAL;
> +
>  	if (mode == THERMAL_DEVICE_DISABLED && kernelmode)
>  		acerhdf_revert_to_bios_mode();
>  	else if (mode == THERMAL_DEVICE_ENABLED && !kernelmode)
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index bb6754a5342c..014512581918 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -368,7 +368,7 @@ static int imx_set_mode(struct thermal_zone_device *tz,
>  			data->irq_enabled = true;
>  			enable_irq(data->irq);
>  		}
> -	} else {
> +	} else if (mode == THERMAL_DEVICE_DISABLED) {
>  		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>  			     soc_data->measure_temp_mask);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
> @@ -381,6 +381,8 @@ static int imx_set_mode(struct thermal_zone_device *tz,
>  			disable_irq(data->irq);
>  			data->irq_enabled = false;
>  		}
> +	} else {
> +		return -EINVAL;
>  	}
>  
>  	data->mode = mode;
> diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
> index 5d33b350da1c..5f4bcc0e4fd3 100644
> --- a/drivers/thermal/intel/intel_quark_dts_thermal.c
> +++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
> @@ -328,8 +328,11 @@ static int sys_set_mode(struct thermal_zone_device *tzd,
>  	mutex_lock(&dts_update_mutex);
>  	if (mode == THERMAL_DEVICE_ENABLED)
>  		ret = soc_dts_enable(tzd);
> -	else
> +	else if (mode == THERMAL_DEVICE_DISABLED)
>  		ret = soc_dts_disable(tzd);
> +	else
> +		return -EINVAL;
> +
>  	mutex_unlock(&dts_update_mutex);
>  
>  	return ret;
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index ef0baa954ff0..b7621dfab17c 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -289,9 +289,11 @@ static int of_thermal_set_mode(struct thermal_zone_device *tz,
>  	if (mode == THERMAL_DEVICE_ENABLED) {
>  		tz->polling_delay = data->polling_delay;
>  		tz->passive_delay = data->passive_delay;
> -	} else {
> +	} else if (mode == THERMAL_DEVICE_DISABLED) {
>  		tz->polling_delay = 0;
>  		tz->passive_delay = 0;
> +	} else {
> +		return -EINVAL;
>  	}
>  
>  	mutex_unlock(&tz->lock);
> 
