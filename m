Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E3A1E80C7
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 16:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgE2OsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 10:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgE2OsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 10:48:24 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23840C03E969;
        Fri, 29 May 2020 07:48:24 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v2so1450853pfv.7;
        Fri, 29 May 2020 07:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cO3a3cgUSH7rfKMtdpjcLP1JxlHk9vIs7cTHOKnLkaA=;
        b=SE/O4US4ueCIgLVnMUgPO2R0ai200vqjEkr73pw0iMLAxaQlBn1AD455akbOJhLGFw
         s0e9LFdcWptHf3WO+6HhYXhgns97/WVp4voUyAoGTIQLutOMEINeCI6GXMFY6inZXATs
         LcoYN4i6oSYYuS2UdHIPVMTEDCgbww0ppbniilSaElY2wvL/TABJdcrCnBQqEabwljeJ
         MNiPAkh3PRUmWrjnZKgvjtuSfPql8Kct5UFfQ6ljAkfhVz4IxZSinDvhGT51lVlbZ/0/
         Re2Nmze2SuWdDqURHjRU9fzOI8Ga00Xnb5fMhIJIV9ZcAN+XuJFQ2cGu8mbHV1DfjzKI
         K/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=cO3a3cgUSH7rfKMtdpjcLP1JxlHk9vIs7cTHOKnLkaA=;
        b=VptxHhu8Cbg9nljN5BvzGf1yhypV6FOspR9ny5TpIG8m6Dfhii54J/CWs/OEAy1ixH
         5vpQGg1VXL4ufm0beh0la7KIarJo1DL0SJHGrFqUOj78aWi0uA4TN2cnMR6anLr6ZYS4
         SVRTVkAV/zGy3go6CHVSP4k+hFDNhm165En/r5vDKTWOR7EVgy4RAVNAsWbMAfaOVxjR
         XRjXCkYEM3rct2oHEXKY+bgXtcYK0fq1KGF5kRgdjbkolsQUL6v2fo79fQOBotoMz+tQ
         F9fgYxLVybc5+LphKc9wce2ZVLm3xjIA+NkjUTprdroiJMLvKO1pI22h9swp5PLg0K+p
         oIfg==
X-Gm-Message-State: AOAM5325b6EchIOCvjPLEVwa58Hr0GoV9Ca2cGLLzfkL2fmIrXDqSd5l
        aeApIoDNd7sUiLGYiG3F2As=
X-Google-Smtp-Source: ABdhPJzsJ8Jgab8FprNGsq+IiLfPx1J45pSV3Y5EY3lJEXRD49UVOwc5O0C+oEJ2ZsOWPW6z0jLUEw==
X-Received: by 2002:aa7:8f27:: with SMTP id y7mr9299367pfr.19.1590763703583;
        Fri, 29 May 2020 07:48:23 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 192sm7123644pfz.198.2020.05.29.07.48.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 07:48:22 -0700 (PDT)
Date:   Fri, 29 May 2020 07:48:21 -0700
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
Subject: Re: [PATCH v4 02/11] thermal: Store thermal mode in a dedicated enum
Message-ID: <20200529144821.GA93994@roeck-us.net>
References: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
 <20200528192051.28034-1-andrzej.p@collabora.com>
 <20200528192051.28034-3-andrzej.p@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528192051.28034-3-andrzej.p@collabora.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 09:20:42PM +0200, Andrzej Pietrasiewicz wrote:
> Prepare for storing mode in struct thermal_zone_device.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
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

Personally I find this check unnecessary: The enum has no other values,
and it is verifyable that the callers provide the enum and not some other
value.

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

Same as above.

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
