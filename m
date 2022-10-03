Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9DC5F32AB
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 17:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiJCPhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 11:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJCPgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 11:36:45 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20262ED47
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 08:36:38 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f11so14669504wrm.6
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 08:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=XNKN62ufy1+xZwjokTiFAK6DG0fkYs2uyoDmdXUsmfk=;
        b=joStem3d8drVJs049ako4kuE59txaO6NDwV0bfhPO1a6au6KSg1jl9JsQbZC3bw7u+
         FD6FayZuGqdzNjFvhzr644aHDEG6eCiaS9OElKxDfveQgku8qAOD+P94IxzfUncnx8IO
         RK+0MVu0VdhcKkFmQsLSyILE5TNyJbkDMhEFSgk6kG9xiR+G48J4fbd7Ydqu9lfNyuxm
         tvzmrPwJsIDRpFq4+XQKhrZjD3+bkaJPRtm2Df97oP5CxhB+whhXaMyK76P9RB4KrQx9
         WR8EWkAW9tn/Zis7k+FaXmzNAPD5b79QWJRpBzgishcYEQtk6m/FkQliHjtVn56Kmtc7
         3OuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=XNKN62ufy1+xZwjokTiFAK6DG0fkYs2uyoDmdXUsmfk=;
        b=umL+43GIusNaU9iW174cKvXV3HFP0W2b4luEStRZsEwGIzF0Hj1FmoJHAEMWamJBwF
         dJfAfYt4jqCUsNK50TAMyj4dROGCX89XVtikbZY4awAg21FdAoskbqYpu+dE2INJploM
         I8oIAVucBvk0Au1Ip6WVY+rYssU32phxR/HNzg0Rk/2Q1p9I4LdHEtgAasxKXchcAYKg
         DEpiFaRZT8Ov/OJEMM2SH0Coq3tAG4RiDoNJqo9wSMxks2+L4oZkoWP32VKeTaJ31xsx
         j/giOW8qvF7YYeYxe0EHZ1bM1mpngrcqBylcatRXuMpoFmlUZxajZ7SkC6lZ/sor1EEL
         QxMg==
X-Gm-Message-State: ACrzQf3kqKnr+D/ERwOHtJlpRuVPXp0hQwz0th2hjGFMz6mIMK0/k7yX
        0Et6A71j6nS8OAxHtebkfJCHZA==
X-Google-Smtp-Source: AMsMyM5sZ5raF+DNJ/cTSf5EVIWxvlZeClNcXX2TDk8N8PojssLE59qDPC1gOPTXuAj69kjJPYFesg==
X-Received: by 2002:a05:6000:1c0e:b0:22e:2c39:1da6 with SMTP id ba14-20020a0560001c0e00b0022e2c391da6mr7285770wrb.588.1664811396754;
        Mon, 03 Oct 2022 08:36:36 -0700 (PDT)
Received: from ?IPV6:2a05:6e02:1041:c10:f3a:9f5e:1605:a75a? ([2a05:6e02:1041:c10:f3a:9f5e:1605:a75a])
        by smtp.googlemail.com with ESMTPSA id v17-20020a5d43d1000000b0022e049586c5sm8599784wrr.28.2022.10.03.08.36.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 08:36:36 -0700 (PDT)
Message-ID: <d8533a76-9626-dcc2-f3fb-de878d2603df@linaro.org>
Date:   Mon, 3 Oct 2022 17:36:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 00/29] Rework the trip points creation
Content-Language: en-US
To:     Marek Szyprowski <m.szyprowski@samsung.com>, rafael@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        rui.zhang@intel.com,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org
References: <CGME20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb@eucas1p2.samsung.com>
 <20221003092602.1323944-1-daniel.lezcano@linaro.org>
 <8cdd1927-da38-c23e-fa75-384694724b1c@samsung.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <8cdd1927-da38-c23e-fa75-384694724b1c@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/10/2022 16:10, Marek Szyprowski wrote:
> Hi Daniel,
> 
> On 03.10.2022 11:25, Daniel Lezcano wrote:
>> This work is the pre-requisite of handling correctly when the trip
>> point are crossed. For that we need to rework how the trip points are
>> declared and assigned to a thermal zone.
>>
>> Even if it appears to be a common sense to have the trip points being
>> ordered, this no guarantee neither documentation telling that is the
>> case.
>>
>> One solution could have been to create an ordered array of trips built
>> when registering the thermal zone by calling the different get_trip*
>> ops. However those ops receive a thermal zone pointer which is not
>> known as it is in the process of creating it.
>>
>> This cyclic dependency shows we have to rework how we manage the trip
>> points.
>>
>> Actually, all the trip points definition can be common to the backend
>> sensor drivers and we can factor out the thermal trip structure in all
>> of them.
>>
>> Then, as we register the thermal trips array, they will be available
>> in the thermal zone structure and a core function can return the trip
>> given its id.
>>
>> The get_trip_* ops won't be needed anymore and could be removed. The
>> resulting code will be another step forward to a self encapsulated
>> generic thermal framework.
>>
>> Most of the drivers can be converted more or less easily. This series
>> does a first round with most of the drivers. Some remain and will be
>> converted but with a smaller set of changes as the conversion is a bit
>> more complex.
>>
>> Changelog:
>> v8:
>> - Pretty oneline change and parenthesis removal (Rafael)
>> - Collected tags
>> v7:
>> - Added missing return 0 in the x86_pkg_temp driver
>> v6:
>> - Improved the code for the get_crit_temp() function as suggested by
>> Rafael
>> - Removed inner parenthesis in the set_trip_temp() function and invert the
>> conditions. Check the type of the trip point is unchanged
>> - Folded patch 4 with 1
>> - Add per thermal zone info message in the bang-bang governor
>> - Folded the fix for an uninitialized variable in
>> int340x_thermal_zone_add()
>> v5:
>> - Fixed a deadlock when calling thermal_zone_get_trip() while
>> handling the thermal zone lock
>> - Remove an extra line in the sysfs change
>> - Collected tags
>> v4:
>> - Remove extra lines on exynos changes as reported by Krzysztof Kozlowski
>> - Collected tags
>> v3:
>> - Reorg the series to be git-bisect safe
>> - Added the set_trip generic function
>> - Added the get_crit_temp generic function
>> - Removed more dead code in the thermal-of
>> - Fixed the exynos changelog
>> - Fixed the error check for the exynos drivers
>> - Collected tags
>> v2:
>> - Added missing EXPORT_SYMBOL_GPL() for thermal_zone_get_trip()
>> - Removed tab whitespace in the acerhdf driver
>> - Collected tags
>>
>> Cc: Raju Rangoju <rajur@chelsio.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Paolo Abeni <pabeni@redhat.com>
>> Cc: Peter Kaestle <peter@piie.net>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> Cc: Mark Gross <markgross@kernel.org>
>> Cc: Miquel Raynal <miquel.raynal@bootlin.com>
>> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Cc: Amit Kucheria <amitk@kernel.org>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: Nicolas Saenz Julienne <nsaenz@kernel.org>
>> Cc: Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>> Cc: Ray Jui <rjui@broadcom.com>
>> Cc: Scott Branden <sbranden@broadcom.com>
>> Cc: Support Opensource <support.opensource@diasemi.com>
>> Cc: Lukasz Luba <lukasz.luba@arm.com>
>> Cc: Shawn Guo <shawnguo@kernel.org>
>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>> Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
>> Cc: Fabio Estevam <festevam@gmail.com>
>> Cc: NXP Linux Team <linux-imx@nxp.com>
>> Cc: Thara Gopinath <thara.gopinath@linaro.org>
>> Cc: Andy Gross <agross@kernel.org>
>> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
>> Cc: "Niklas Söderlund" <niklas.soderlund@ragnatech.se>
>> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Cc: Alim Akhtar <alim.akhtar@samsung.com>
>> Cc: Thierry Reding <thierry.reding@gmail.com>
>> Cc: Jonathan Hunter <jonathanh@nvidia.com>
>> Cc: Eduardo Valentin <edubezval@gmail.com>
>> Cc: Keerthy <j-keerthy@ti.com>
>> Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>> Cc: Masami Hiramatsu <mhiramat@kernel.org>
>> Cc: Antoine Tenart <atenart@kernel.org>
>> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>> Cc: Dmitry Osipenko <digetx@gmail.com>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: platform-driver-x86@vger.kernel.org
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-rpi-kernel@lists.infradead.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-arm-msm@vger.kernel.org
>> Cc: linux-renesas-soc@vger.kernel.org
>> Cc: linux-samsung-soc@vger.kernel.org
>> Cc: linux-tegra@vger.kernel.org
>> Cc: linux-omap@vger.kernel.org
>>
>> Daniel Lezcano (29):
>> thermal/core: Add a generic thermal_zone_get_trip() function
>> thermal/sysfs: Always expose hysteresis attributes
>> thermal/core: Add a generic thermal_zone_set_trip() function
>> thermal/core/governors: Use thermal_zone_get_trip() instead of ops
>> functions
>> thermal/of: Use generic thermal_zone_get_trip() function
>> thermal/of: Remove unused functions
>> thermal/drivers/exynos: Use generic thermal_zone_get_trip() function
>> thermal/drivers/exynos: of_thermal_get_ntrips()
>> thermal/drivers/exynos: Replace of_thermal_is_trip_valid() by
>> thermal_zone_get_trip()
>> thermal/drivers/tegra: Use generic thermal_zone_get_trip() function
>> thermal/drivers/uniphier: Use generic thermal_zone_get_trip() function
>> thermal/drivers/hisi: Use generic thermal_zone_get_trip() function
>> thermal/drivers/qcom: Use generic thermal_zone_get_trip() function
>> thermal/drivers/armada: Use generic thermal_zone_get_trip() function
>> thermal/drivers/rcar_gen3: Use the generic function to get the number
>> of trips
>> thermal/of: Remove of_thermal_get_ntrips()
>> thermal/of: Remove of_thermal_is_trip_valid()
>> thermal/of: Remove of_thermal_set_trip_hyst()
>> thermal/of: Remove of_thermal_get_crit_temp()
>> thermal/drivers/st: Use generic trip points
>> thermal/drivers/imx: Use generic thermal_zone_get_trip() function
>> thermal/drivers/rcar: Use generic thermal_zone_get_trip() function
>> thermal/drivers/broadcom: Use generic thermal_zone_get_trip() function
>> thermal/drivers/da9062: Use generic thermal_zone_get_trip() function
>> thermal/drivers/ti: Remove unused macros ti_thermal_get_trip_value() /
>> ti_thermal_trip_is_valid()
>> thermal/drivers/acerhdf: Use generic thermal_zone_get_trip() function
>> thermal/drivers/cxgb4: Use generic thermal_zone_get_trip() function
>> thermal/intel/int340x: Replace parameter to simplify
>> thermal/drivers/intel: Use generic thermal_zone_get_trip() function
> 
> I've tested this v8 patchset after fixing the issue with Exynos TMU with
> https://lore.kernel.org/all/20221003132943.1383065-1-daniel.lezcano@linaro.org/
> patch and I got the following lockdep warning on all Exynos-based boards:
>
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.0.0-rc1-00083-ge5c9d117223e #12945 Not tainted
> ------------------------------------------------------
> swapper/0/1 is trying to acquire lock:
> c1ce66b0 (&data->lock#2){+.+.}-{3:3}, at: exynos_get_temp+0x3c/0xc8
> 
> but task is already holding lock:
> c2979b94 (&tz->lock){+.+.}-{3:3}, at:
> thermal_zone_device_update.part.0+0x3c/0x528
> 
> which lock already depends on the new lock.

Investigating ...



-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
