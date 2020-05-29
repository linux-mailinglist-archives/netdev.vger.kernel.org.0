Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1AF1E80DF
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgE2OuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 10:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgE2OuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 10:50:16 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD75C03E969;
        Fri, 29 May 2020 07:50:15 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id z15so3197369pjb.0;
        Fri, 29 May 2020 07:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ckAKropeOCUm1zmt0HIr3BWF9IN5QnUNbPwdDc91gQM=;
        b=VApd29jCPL4t/dmJjYuL4RaTRnmPGPnedoBqJignh4pwfT+adxmEfTg6KII8hVU3+y
         P+HgN3s66RdiqfaK5p5d5Yb+BT/bbTfelEz53DfeySa6BOi8Nz7ffDOzXCWc89PjESDx
         j6npuyY26G43teVevipd+CCGm4HtCtJrWRFgp4B5iTes87Z/DOyGYha+cTN2aS6Yq7+g
         UIcmEP7iCNmgbhNY34/sjXKt1JDcShF6tnfO6arWC71pCNhSjMtPj7a+U0UGOqyJbLTn
         eXE2kLLF08hY0We0hSvVFKsCyOel7J8thLG3PvUb5jL/2Zf8PvzV6kVN8vl8lNQ2kvTd
         uw2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ckAKropeOCUm1zmt0HIr3BWF9IN5QnUNbPwdDc91gQM=;
        b=Ro0Z7dKA/vW9+GESF3bpxdJpnI9qUr/aK+oiwkKtCHZq5eSEhvTAemaiZdH7EnmKLF
         s65CbNuHUwh312KwJ4OpYb5l/j6rNJam9mUkx2tfbqTEstx84Td+a4Ecm7hpARydi9yj
         24b2a3VamncBCgOkvcMleFhK86+IaQHaddxYn8vhXhsdae8T4zfHKPtcyYmH0fOFgJmu
         kRRFadJCkOoiAvd6Zs+JtVFV+L8Mz7YENBXMtDaa4DqFhqZlU859V/RTNTsqOZTpOjYg
         mmI9CVJwMCwBWvaIV4mIMKH4AILbWVUnXUomNVl8ir/+zCFtQeEK269+CEDOFl4DWcVn
         L5Sg==
X-Gm-Message-State: AOAM533YGeGnWJQ1KOD5kEP+6wIQDvGOgBkYSG0/bNqW0RNbkKCz9QTe
        7TNpOk2kG+RSfaP5aZZGwUMJoxqSjpE=
X-Google-Smtp-Source: ABdhPJxKeEIcZPHMl4KTv3Kl/4nwkc/Lyd2ImrMkBUvZkzIyDKXQUYsPEnihKLG8uevhr4cQxpz+iw==
X-Received: by 2002:a17:90a:4805:: with SMTP id a5mr4970593pjh.22.1590763815238;
        Fri, 29 May 2020 07:50:15 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 140sm4674978pfy.95.2020.05.29.07.50.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 07:50:14 -0700 (PDT)
Date:   Fri, 29 May 2020 07:50:13 -0700
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
Subject: Re: [PATCH v4 01/11] acpi: thermal: Fix error handling in the
 register function
Message-ID: <20200529145013.GA125062@roeck-us.net>
References: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
 <20200528192051.28034-1-andrzej.p@collabora.com>
 <20200528192051.28034-2-andrzej.p@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528192051.28034-2-andrzej.p@collabora.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 09:20:41PM +0200, Andrzej Pietrasiewicz wrote:
> The acpi_thermal_register_thermal_zone() is missing any error handling.
> This needs to be fixed.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/acpi/thermal.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 19067a5e5293..6de8066ca1e7 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -901,23 +901,35 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>  	result = sysfs_create_link(&tz->device->dev.kobj,
>  				   &tz->thermal_zone->device.kobj, "thermal_zone");
>  	if (result)
> -		return result;
> +		goto unregister_tzd;
>  
>  	result = sysfs_create_link(&tz->thermal_zone->device.kobj,
>  				   &tz->device->dev.kobj, "device");
>  	if (result)
> -		return result;
> +		goto remove_tz_link;
>  
>  	status =  acpi_bus_attach_private_data(tz->device->handle,
>  					       tz->thermal_zone);
> -	if (ACPI_FAILURE(status))
> -		return -ENODEV;
> +	if (ACPI_FAILURE(status)) {
> +		result = -ENODEV;
> +		goto remove_dev_link;
> +	}
>  
>  	tz->tz_enabled = 1;
>  
>  	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
>  		 tz->thermal_zone->id);
> +
>  	return 0;
> +
> +remove_dev_link:
> +	sysfs_remove_link(&tz->thermal_zone->device.kobj, "device");
> +remove_tz_link:
> +	sysfs_remove_link(&tz->device->dev.kobj, "thermal_zone");
> +unregister_tzd:
> +	thermal_zone_device_unregister(tz->thermal_zone);
> +
> +	return result;
>  }
>  
>  static void acpi_thermal_unregister_thermal_zone(struct acpi_thermal *tz)
