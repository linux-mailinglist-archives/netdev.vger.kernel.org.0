Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA17206ECB
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389108AbgFXIQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:16:15 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52790 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388048AbgFXIQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:16:14 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200624081611euoutp01537180a859292b0c073d831d2b55e9ad~bbNi2URUA1103511035euoutp01S;
        Wed, 24 Jun 2020 08:16:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200624081611euoutp01537180a859292b0c073d831d2b55e9ad~bbNi2URUA1103511035euoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592986571;
        bh=EHndB5QzgamLkOVrkzrSmd1+bAEHOFM//FEnnR45Bo4=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Ttjv3W55vyImYB59xCPQGIkn8zbRLXBGasQGUJiz/6sVRQB/SP1QXjVJV0rckcjIA
         DzXxc/v4LaHLIL3c/8BbMl1q6vOp/OqLyPvixrG6e7B85XhSnhZ0nQBi0A7oVwzy0v
         fSncipZy8duCvq/9fJ6GPWB8OH792pT13dKUEuTA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200624081611eucas1p226b8963e5ae702345134f941d6b96727~bbNisDFHe0174401744eucas1p2H;
        Wed, 24 Jun 2020 08:16:11 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 86.DD.05997.ACB03FE5; Wed, 24
        Jun 2020 09:16:10 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200624081610eucas1p1fb83289f3916bf59400b2ea737c124d1~bbNiOoyMc2767127671eucas1p1U;
        Wed, 24 Jun 2020 08:16:10 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200624081610eusmtrp1ab30ef185830ae9fc608a966fd014c18~bbNiNZNoB3260232602eusmtrp1X;
        Wed, 24 Jun 2020 08:16:10 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-3a-5ef30bcaa20a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 67.73.06017.ACB03FE5; Wed, 24
        Jun 2020 09:16:10 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200624081608eusmtip1aca323a1e91aaac71dd2e364feb4b059~bbNgn-YNL1894018940eusmtip1J;
        Wed, 24 Jun 2020 08:16:08 +0000 (GMT)
Subject: Re: [PATCH v4 01/11] acpi: thermal: Fix error handling in the
 register function
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
Message-ID: <ecaae46b-5ba5-3c08-2451-34d0dba46143@samsung.com>
Date:   Wed, 24 Jun 2020 10:16:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200528192051.28034-2-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TbUxTZxTH89x7e9syyi5F7BO2xaVxMzMT3NzYiaLRwYf7bX5Uoow6bpBI
        q2uhTGUbkvHWKeMlglZ0KMa+oBsWKBSQELrJsFLBZagbb1VAcJa3diIOytpeyPj2O/9z/s//
        nA+PiJSWCKNEaaoMTq1SpMvpEMp6e8G55c5rnqStvvE4MP3mo2DeuUDAtSdDFJSdWybh5ikX
        AZc8b0HVve8o0F3eCnnWQQG4/vgM8j3nKFh+/Le/6oiHR6daCaia0MJjo14I9c7TAjCftVFw
        xXSZBpvLTYOh/QcElif9AtC9MpHgOfMLgsbJKQLmRvxBz40DQiiqL0Vgb6wmwF7QLoDb1euh
        q6JYAJUzFxD09h6A2rYJEu467gtg1FVMw1KThYKJBhk4WjPgVl4fCfWWsyT0V3soMIy0CHe/
        z166fpIda64SsL8XnyHY5sGriG0wPSJY41wMa9MPCtl642a2pm2SYC3mIpod6G+j2Smn069f
        /ZadfT4qZMcr7QRbMuOm9+LEkLgULj1Ny6ljdiWHHK7puUEdmw37auGeF+WgilAdEosw8xEu
        KHwg1KEQkZQxItxtOY/4wovwsO+ZgC88CHfmPiRWLc4cCxVgKWNAeMhE8ENuhG858oONCCYR
        T04VBXkdsw0vWN3BDJLRSbD7absw0KCZ7bi0wIwCLGF24daCf+kAU8w72Do/HtQjmX14bsQu
        4GfCcff50eCjYmYnrmj8PrgRycjwn6M/rvAG3OSuIgNhmHkhxqXTdppfOwFb/xmjeI7Az7oa
        hDy/iR3lpyne8BPCS4UTK+4mhA3lvhX3DjzgfOVnkT/iPfxzSwwv78FN5psoIGMmDD90h/NL
        hOEyayXJyxJcmC/lp9/Fddfq6NVYnc1EliC5fs1p+jXn6Neco/8/txpRZiTjMjXKVE7zoYrL
        itYolJpMVWr0F0eVFuT/Jw5fl7cZtSwe6kSMCMlDJXUjs0lSgUKrOa7sRFhEytdJPu1xJEkl
        KYrjJzj10c/VmemcphO9IaLkMsm2K5MHpUyqIoM7wnHHOPVqlxCJo3JQdF+WzHN/w+t7cvfP
        fD12JDbP21OjiPjypUqzsTd7i/TF3evDF3Ofbu84WGUafvDJ9F9LsPOiNSFRHDpkOZB2qFeb
        Ipo+ERepXVbGRyVIyy/seNnVXbup4U7H7vbYt5cM2b747CnvRl+ycn/Wx2G28Njkxb4yV23z
        N+W/zp/0rY/cuyinNIcVH2wm1RrFf9z+H0sjBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTVxiHd+69vS1il7OC4wRFXRNCNFuxXLAvBrtFY7zxD1lmtiyO4Tq4
        AzJKTW9p5kwUpwh0yocG0K5BkG5C12Wu5aMMZrQssg0twrJmEFn46AhEacCaGLYObMEl/Pc7
        v/M8581JXhmtaGETZUUlJsFYoitWshuYweWB8Td+iw3l7vrTsxnaf1lm4JlviYJvpv9i4NKV
        FRp+ODNJQVMoCWxD5xiwtOyC8q5xCUz+kQ3nQ1cYWJl6FDnd3g+jZ3opsM2aYarNKgW374IE
        HPU9DFxvb2GhZ3KehRu3ahC4pv0SsPzTTkPo4s8IOueCFDyZiAx63PZQClXuOgT9nc0U9Ffc
        ksDd5ldhoKFaAo0LXyF48CAHvu2bpeHe4IgEApPVLPzX7WJgtiMBBntN8FP5MA1uVz0N/uYQ
        AzcmfpS+9Trf5DzJ/+2xSfjfqy9SvGfcjviO9lGKb3uSyvdYx6W8u20n39o3R/EuRxXLP/T3
        sXzQ54v09tP84uOAlJ9p7Kf42oV59m1yVJVlNJSahO2FBtG0V/mBGtJU6kxQpaVnqtSc5sM9
        aRnKVG1WvlBcZBaMqdqPVIWt979jji++/NnS0FNUhho2WlCMjOB04itzMdGswF8jcu2LTyxI
        Fum3kIHvzWtIHAn7LawFbYggjxCpnHJKoxdx+CiZC1atuvGYI0td89IoRONqOemdcUrXjHKK
        eIa9VJRi8R5SV+FA0SzHWtJb8S8bzQxOJl3PZlb7Tfh90u+xvmBeIb9eDaxOiMF7SUPnl6vv
        0DiFhJtG6LWcQMYC117020j3vI2uRQrrOt26TrGuU6zrlGbEOFC8UCrqC/RimkrU6cXSkgJV
        nkHvQpH17Lq71OFBluARL8IypNwovzmxmKuQ6MziCb0XERmtjJfvuz+Yq5Dn6058LhgNx4yl
        xYLoRRmRz9XRiZvyDJFlLzEdU2eoNZCp1nAabjcoE+SV+E6OAhfoTMKngnBcMP7vUbKYxDKU
        GW8fGuFS/O9dbfHm67vvaVeGZnbgg7G3L52drV1IOmWoDC9ypw3DzsuOOa6e+9h/+KWE5Jxl
        Ma/Qbd8W+67ulMf8jrmIzcGdgcrdjW9qRs014XJn9gF72JekNG6tiMtKDuKxovSasZs7FvSX
        s++EDpW9ZoNAyuh0nauV0yoZsVCn3kkbRd1z33/Dy7QDAAA=
X-CMS-MailID: 20200624081610eucas1p1fb83289f3916bf59400b2ea737c124d1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528192122eucas1p29d209ad5a885b31deb04dcad13f98ad5
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528192122eucas1p29d209ad5a885b31deb04dcad13f98ad5
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
        <20200528192051.28034-1-andrzej.p@collabora.com>
        <CGME20200528192122eucas1p29d209ad5a885b31deb04dcad13f98ad5@eucas1p2.samsung.com>
        <20200528192051.28034-2-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
> The acpi_thermal_register_thermal_zone() is missing any error handling.
> This needs to be fixed.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

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
> 

