Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4FF212B99
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgGBRw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgGBRwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:52:25 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6824FC08C5E1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 10:52:24 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g75so28048014wme.5
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oglYmDMJJsMPIXYV1ITcnNL4FWv5Lg95ZCqCfgcjHUs=;
        b=eCKvFL3ymp9ODmh1kib4C/AcPrCHfUe4eQkI84tWMNstC588Mcs/UzyYV+30IgEPIB
         lfn4BGs06fAPfloAK0p40cJ3BQEuYzsfHY7d9o5Wr4ZrXyQrqXhtnG6F3jFX42w8e/2m
         weKvXoukAneezHhMB60mGihkb8pcI/kk8sZmWoEft2bkOnM2yQyw4RX50kJPE3J+9MnN
         fQinPrGJq2HYROL7Dl9fLIK+uTW325NDPRzeAtAAM2vhot8J8DATGO6hnDZGucHe9Jjs
         qXs+mG8rCVEuhGXBHfDtewoYJIa2KlLkJMQg70p6vJf/FdlJAKW6C6ggeDUiANRQMAFK
         P1Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oglYmDMJJsMPIXYV1ITcnNL4FWv5Lg95ZCqCfgcjHUs=;
        b=YBIQlnDQXFcYALze32STqvU77cjx6HPPt0j0fIY0a/ZXPy9QhMdfOXqIPCuPY8ezos
         9itQbz8rdd4Wxzn4tqOZpIvVObvcYYn+5VW0P7qjcnKoPvQL3WVpxEhXV9zJ1jIej4BV
         JvYrVyNywQ5KU5+Vqqshoeb/0sS+LHjgQQeA7nUAQicgTDqj6Hlx2F6Zq8VTt7ZWrJY5
         X+0euXTE3tifUTHT6VrYykM0FGeIsti3+/ppeuc9P238KXy9IC5r0HRCQCBPayuTUJKV
         FX8cVIpI9lifX4Ewy32p5xF2/b4oyNKdKos3c09gUHdtsjpPbeJeF9C4B6tBxtzewcl4
         jMcA==
X-Gm-Message-State: AOAM531FWFkDBdkvKvhAS3jzIvqmDpzM3HoWRzLhoYk6PG3q6HX2iHoF
        Uxc0MXS3R7Tbq0XMOzYkdJgehQ==
X-Google-Smtp-Source: ABdhPJwGnT2w1T0cKggQNb65VkNrkBamKBA/sNFXDWMPWvMyn5BHS1CuhDAFIDm0ZukJhYYRAkgr9A==
X-Received: by 2002:a7b:c041:: with SMTP id u1mr34629911wmc.56.1593712342780;
        Thu, 02 Jul 2020 10:52:22 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:c88a:7b2b:a4a1:46d0? ([2a01:e34:ed2f:f020:c88a:7b2b:a4a1:46d0])
        by smtp.googlemail.com with ESMTPSA id h2sm11232487wrw.62.2020.07.02.10.52.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 10:52:22 -0700 (PDT)
Subject: Re: [PATCH v7 00/11] Stop monitoring disabled devices
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
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
        Thomas Gleixner <tglx@linutronix.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        kernel@collabora.com
References: <20200629122925.21729-1-andrzej.p@collabora.com>
 <aab40d90-3f72-657c-5e14-e53a34c4b420@linaro.org>
 <3d03d1a2-ac06-b69b-93cb-e0203be62c10@collabora.com>
 <47111821-d691-e71d-d740-e4325e290fa4@linaro.org>
 <be9b7ee3-cad0-e462-126d-08de9b226285@collabora.com>
 <4353a939-3f5e-8369-5bc0-ad8162b5ffc7@linaro.org>
 <a531d80f-afd1-2dec-6c77-ed984e97595c@collabora.com>
 <db1ff4e1-cbf8-89b3-5d64-b91a1fd88a41@linaro.org>
 <73942aea-ae79-753c-fe90-d4a99423d548@collabora.com>
 <374dddd9-b600-3a30-d6c3-8cfcefc944d9@linaro.org>
 <5a28deb7-f307-8b03-faad-ab05cb8095d1@collabora.com>
 <8aeb4f51-1813-63c1-165b-06640af5968f@linaro.org>
 <685ef627-e377-bbf1-da11-7f7556ca2dd7@collabora.com>
 <d41bf28f-ee91-6946-2334-f11ec81f96fe@linaro.org>
Message-ID: <b773a49d-c26e-9e20-2a5e-647eb771d617@linaro.org>
Date:   Thu, 2 Jul 2020 19:52:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d41bf28f-ee91-6946-2334-f11ec81f96fe@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2020 19:49, Daniel Lezcano wrote:

[ ... ]

>> Thanks!
>>
>> That confirms your suspicions.
>>
>> So the reason is that ->get_temp() is called while the mutex is held and
>> thermal_zone_device_is_enabled() wants to take the same mutex.
> 
> Yes, that's correct.
> 
>> Is adding a comment to thermal_zone_device_is_enabled() to never call
>> it while the mutex is held and adding another version of it which does
>> not take the mutex ok?
> 
> The thermal_zone_device_is_enabled() is only used in two places, acpi
> and this imx driver, and given:
> 
> 1. as soon as the mutex is released, there is no guarantee the thermal
> zone won't be changed right after, the lock is pointless, thus the
> information also.
> 
> 2. from a design point of view, I don't see why a driver should know if
> a thermal zone is disabled or not
> 
> It would make sense to end with this function and do not give the
> different drivers an opportunity to access this information.
> 
> Why not add change_mode for the acpi in order to enable or disable the
> events and for imx_thermal use irq_enabled flag instead of the thermal
> zone mode? Moreover it is very unclear why this function is needed in
> imx_get_temp(), and I suspect we should be able to get rid of it.

If you agree with that you can send a patch on top of your series so I
can test it fixes the imx platform.


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
