Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E087207027
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389816AbgFXJig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:38:36 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57036 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388031AbgFXJie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:38:34 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200624093830euoutp01e323434da08f93c0e0c61d01791cdced~bcVa00iom1808518085euoutp01l;
        Wed, 24 Jun 2020 09:38:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200624093830euoutp01e323434da08f93c0e0c61d01791cdced~bcVa00iom1808518085euoutp01l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592991510;
        bh=9pTBGlOaDXUW+NcRIdEvrseTLrOWVNwTObt7dXRD848=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=ejeW96VRUfWKVetl6ZNG4BuesZCcr+ld1rLUFf94PgFbNn4+45Tzy7llWZ1+Xo58t
         o1pjphztop/w3gLCAqD3b8iWx5n00sU3Pi205TScRZTLMa2fOqvStrgEnIBRr//7oC
         h3a4WDo1yaWPGUq/lRgytQwRPcR1TYysM0gwaytg=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200624093830eucas1p1971dfe292df7766ce9417b2f3908f1fc~bcVanoNhL2828028280eucas1p1J;
        Wed, 24 Jun 2020 09:38:30 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 2F.BB.05997.61F13FE5; Wed, 24
        Jun 2020 10:38:30 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200624093829eucas1p2954a62270260216a849d4fe205e9c21a~bcVaOCk_H1540115401eucas1p2v;
        Wed, 24 Jun 2020 09:38:29 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200624093829eusmtrp17885e4059727ea87f6afd15a3982d552~bcVaMkxx62344323443eusmtrp1H;
        Wed, 24 Jun 2020 09:38:29 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-be-5ef31f166ccd
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id CD.D0.06017.51F13FE5; Wed, 24
        Jun 2020 10:38:29 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200624093826eusmtip13394060a77a06b8b8f2d583a9d4921e8~bcVWxcATH0455504555eusmtip1M;
        Wed, 24 Jun 2020 09:38:26 +0000 (GMT)
Subject: Re: [PATCH v4 02/11] thermal: Store thermal mode in a dedicated
 enum
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
Message-ID: <076c3999-f6fa-cc12-7ede-433ccc3e82b6@samsung.com>
Date:   Wed, 24 Jun 2020 11:38:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200528192051.28034-3-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0yTZxjd+90hq/ssKG9UwtJEFs3GZS7Zk80Zpsv8lhlvi3FZHFuHX4BI
        EVvAOc0mmwo0XASmaMcQkEFbwWGBQqFjCwwYKRZwgckCs9WKZVgnlF1gAmv5IOPfec5zznue
        8+PlSHk+u45LTE4V1cnKJAUTSJm7ZvpeWBvmjY2yjNNg+Gmegr/tMwRU3fuNgsJLCyTcyHAS
        UOoNhZK+MxRoy6PgrHmUBufgHjjnvUTBwt0J3/TDDhjOaCWgxJ0Od/U6FurtOTQYL1goqDCU
        M2BxehiobstHYLo3RIN21kCCN/dHBI3jjwiYcviCHupHWMiuL0DQ0VhGQEdmGw1dZWuh+2Ie
        DcWPv0LQ338IrlndJPTabtHgcuYxMNdkosDdEAK21lT47uwACfWmCyQMlXkpqHa0sDHPC6U1
        J4X7zSW08HNeLiE0j1YiocEwTAj6qUjBohtlhXr9ZuGqdZwQTMZsRhgZsjLCI7vdx1d+Jkw+
        dLHCWHEHIZx/7GH24vcCtx4WkxLTRXXktg8DE3JNrUxKXdTHtn9qyNOoNlyLAjjMv4QrzUWk
        FgVycl6P8PT3Q0gaphHOGKgl/So570XY6vx02WH4K29JVI1w6+e1jCTyIHxzLsWPg/g9ePBB
        J+3HwfwWPGP2sH4DyWtl2POgjfUvGP4VXJBpRH4s47fhWdc3hB9T/Ebs0VoXH13Dv4unHB20
        pFmNey67KD8O4F/DGbr7i9eRfAj+1XWFkHAYbvKULPbB/GwAvlY7xUpnv4G/vlOIJByEf+9u
        WOI3YFtRDiUZriM8l+VecjchXF00z0iqV/GIfdaHOV/EJvxtS6REv47H+sZoP435Vfi2Z7V0
        xCpcaC4mJVqGs87JJXU4rquqY5ZjtRYDeR4pdCuq6VbU0a2oo/s/twxRRhQipmlU8aLmxWTx
        eIRGqdKkJcdHxB1VmZDvm9jmu6ebUcuTj9oRzyHF07I6x2SsnFama06o2hHmSEWwbPtNW6xc
        dlh54hNRffQDdVqSqGlH6zlKESLbUjH+vpyPV6aKR0QxRVQvbwkuYN1pVHNqV/Dw8a3XrV+4
        R2TP7fvzLVP0wXZ79I2wQz2RE1eyu/btfTKp642wPrtzU/HOU5oCfGs8tP9Yzctv7m7kdmT+
        ki44StmFuO5j24MGE/Y3bNgf/k5oxUDnH6asqomcQdW/Pbe/3NUZs0anOnLyzMFngnKMMW8f
        SLzT+9TYxotx9Pr88t0KSpOgjN5MqjXK/wBtk7u9IgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTVxiAc+5Xi7HJtcI4I1s0XXSJ0UIpXV+csGVGc/8s0yxTo4hr4Aps
        lGpvaeZkE7Ih80I7MPGrElYVtC3goGApljkFA5huncPZhcUawOJw2AZtcMM5XSua8O85532e
        c3KSIyXlp5k0aUmZiTeW6UoVzCLK/3QotCZlWSw/Y866ApzDTyn4OzBHwNk7tyk4fPwZCZ1V
        4wQ0xV6Hxl++pkA8lQHVnhAN4zc/gIOx4xQ8m5iOry6vh9EqHwGNU2aYcNgk0BWoo8F1pJeC
        085TDPSORxg4d+lbBO47QRrEx04SYparCC7cixLwcCx+0X3HLQkc6mpAMHDBTsBAzSUaBu2v
        wNBRKw3HZk4iuH49D1r7pkj4yT9CQ3jcysB/PW4KprpTwe8zwQ/Vv5LQ5T5CQtAeo+Dc2EXJ
        u6u5prb93KS3keZuWC0E5w01I67bOUpwjofpXK8tJOG6HKu4M333CM7tOsRwt4J9DBcNBOL7
        zQe4B/fDEu7usQGCq5+JMJvwduU6o6HcxC8vNgimHMUOFWQqVdmgzMzKVqrU2p1rMzWK9Nx1
        hXxpiZk3pud+rCy2uH3Mno6Mz/z/tJGVqH2liJKkmM3CzkdWJKJFUjnbgvBt0U2ISBofvIaH
        vjfPO0vxk6DIzDvTCLvO1BKJwVL2fWyZHaYTnMyq8ZwnIklIJGuVYd/dNsl8UU3g9toqJmEx
        7FrcUONCCZaxufhxuOX5SRS7AkfEvudOCrsND3htL5wl+NqJMJXgJDYHV9kmyQST7Jv4SdPI
        C07Ff4S/I+Z5Ge6JNJL1SG5bkNsWJLYFiW1BYkeUCyXz5YK+SC9kKgWdXigvK1IWGPRuFP+f
        nsG5bi8Sox/2I1aKFItlHWMP8uW0zizs0/cjLCUVybL3fvbny2WFun2f80bDLmN5KS/0I038
        cQ1kWkqBIf7by0y7VBqVFrJVWrVW/RYoUmXfsFfy5GyRzsR/yvN7eOPLjpAmpVWi3W8X1Jk3
        3/zto8n0f3+kk5Ys/2p0uH3n3kcb1l+9dn76i01NKys3emf3DlYcrpO3aYvVHs1frTmOi7Ge
        ki2es+9cOdDZS1nVzbISdNkwVGOPtrhmLLPZE3mBwuGs3b7tWxZnVdQf3PpJR3fojY1/nng1
        eiNYuE3Z+nvFl5WdI5r9a2rDCkoo1qlWkUZB9z+wh1hStQMAAA==
X-CMS-MailID: 20200624093829eucas1p2954a62270260216a849d4fe205e9c21a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528192138eucas1p1f0e641f46080d52ae4d459745398ef03
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528192138eucas1p1f0e641f46080d52ae4d459745398ef03
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
        <20200528192051.28034-1-andrzej.p@collabora.com>
        <CGME20200528192138eucas1p1f0e641f46080d52ae4d459745398ef03@eucas1p1.samsung.com>
        <20200528192051.28034-3-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
> Prepare for storing mode in struct thermal_zone_device.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

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
>  	struct acpi_thermal_trips trips;
>  	struct acpi_handle_list devices;
>  	struct thermal_zone_device *thermal_zone;
> -	int tz_enabled;
> +	enum thermal_device_mode mode;
>  	int kelvin_offset;	/* in millidegrees */
>  	struct work_struct thermal_check_work;
>  };
> @@ -500,7 +500,7 @@ static void acpi_thermal_check(void *data)
>  {
>  	struct acpi_thermal *tz = data;
>  
> -	if (!tz->tz_enabled)
> +	if (tz->mode != THERMAL_DEVICE_ENABLED)
>  		return;
>  
>  	thermal_zone_device_update(tz->thermal_zone,
> @@ -534,8 +534,7 @@ static int thermal_get_mode(struct thermal_zone_device *thermal,
>  	if (!tz)
>  		return -EINVAL;
>  
> -	*mode = tz->tz_enabled ? THERMAL_DEVICE_ENABLED :
> -		THERMAL_DEVICE_DISABLED;
> +	*mode = tz->mode;
>  
>  	return 0;
>  }
> @@ -544,27 +543,25 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
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
> +	if (mode != tz->mode) {
> +		tz->mode = mode;
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>  			"%s kernel ACPI thermal control\n",
> -			tz->tz_enabled ? "Enable" : "Disable"));
> +			tz->mode == THERMAL_DEVICE_ENABLED ?
> +			"Enable" : "Disable"));
>  		acpi_thermal_check(tz);
>  	}
>  	return 0;
> @@ -915,7 +912,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>  		goto remove_dev_link;
>  	}
>  
> -	tz->tz_enabled = 1;
> +	tz->mode = THERMAL_DEVICE_ENABLED;
>  
>  	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
>  		 tz->thermal_zone->id);
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 8cc86f4e3ac1..830a8b060e74 100644
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
>  	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>  	kernelmode = 0;
> +	thermal_mode = THERMAL_DEVICE_DISABLED;
>  	if (thz_dev)
>  		thz_dev->polling_delay = 0;
>  	pr_notice("kernel mode fan control OFF\n");
> @@ -404,6 +406,7 @@ static inline void acerhdf_revert_to_bios_mode(void)
>  static inline void acerhdf_enable_kernelmode(void)
>  {
>  	kernelmode = 1;
> +	thermal_mode = THERMAL_DEVICE_ENABLED;
>  
>  	thz_dev->polling_delay = interval*1000;
>  	thermal_zone_device_update(thz_dev, THERMAL_EVENT_UNSPECIFIED);
> @@ -416,8 +419,7 @@ static int acerhdf_get_mode(struct thermal_zone_device *thermal,
>  	if (verbose)
>  		pr_notice("kernel mode fan control %d\n", kernelmode);
>  
> -	*mode = (kernelmode) ? THERMAL_DEVICE_ENABLED
> -			     : THERMAL_DEVICE_DISABLED;
> +	*mode = thermal_mode;
>  
>  	return 0;
>  }
> @@ -739,6 +741,8 @@ static int __init acerhdf_register_thermal(void)
>  	if (IS_ERR(cl_dev))
>  		return -EINVAL;
>  
> +	thermal_mode = kernelmode ?
> +		THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED;
>  	thz_dev = thermal_zone_device_register("acerhdf", 2, 0, NULL,
>  					      &acerhdf_dev_ops,
>  					      &acerhdf_zone_params, 0,
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index 0b3a62655843..e84faaadff87 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -48,7 +48,7 @@ struct int3400_thermal_priv {
>  	struct acpi_device *adev;
>  	struct platform_device *pdev;
>  	struct thermal_zone_device *thermal;
> -	int mode;
> +	enum thermal_device_mode mode;
>  	int art_count;
>  	struct art *arts;
>  	int trt_count;
> @@ -395,24 +395,20 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
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
>  
> -	if (enable != priv->mode) {
> -		priv->mode = enable;
> +	if (mode != priv->mode) {
> +		priv->mode = mode;
>  		result = int3400_thermal_run_osc(priv->adev->handle,
> -						 priv->current_uuid_index,
> -						 enable);
> +						priv->current_uuid_index,
> +						mode == THERMAL_DEVICE_ENABLED);
>  	}
>  
>  	evaluate_odvp(priv);
> 
