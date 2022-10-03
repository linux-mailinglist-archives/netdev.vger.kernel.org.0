Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C3A5F31C7
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 16:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJCOKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 10:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiJCOKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 10:10:47 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10373EA57
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 07:10:39 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221003141035euoutp02a21b379fb4c86a637e7ea54ddc92dd3a~alHNbnif02691726917euoutp02Z
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 14:10:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221003141035euoutp02a21b379fb4c86a637e7ea54ddc92dd3a~alHNbnif02691726917euoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664806235;
        bh=yt469ix5RxkGfzZbIfwXCSrXGeFu2GhZ2/1YRC4+wWI=;
        h=Date:From:Subject:To:Cc:In-Reply-To:References:From;
        b=uT4ha5NoODu5IHj8LWIn7L9sTuwi2vTG7s9tligRAv+j8cFSkUVHEv9H+tTOvjEM+
         LROE0uRHcUt2O1Lmb2QCJHdTospAsfQF54dXOJ9NWSAt42eLuMfKA1+azFqSqQr4/H
         zGLvwtXSUJzezeJdslsSy2AEbGhsQNrjRTfl6S10=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221003141035eucas1p17c5977c0ff278d7f81862506c720d6a1~alHNC-ajn2898128981eucas1p1e;
        Mon,  3 Oct 2022 14:10:35 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id E3.09.07817.A5DEA336; Mon,  3
        Oct 2022 15:10:34 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20221003141034eucas1p1d6f80828f25dc593be48459e3cd39be5~alHMTtCF02904029040eucas1p1f;
        Mon,  3 Oct 2022 14:10:34 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221003141034eusmtrp1bc866307f35f01c1a3a2bc51dae8ef82~alHMSrcUi2976429764eusmtrp1F;
        Mon,  3 Oct 2022 14:10:34 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-61-633aed5a0cd9
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 6C.62.07473.A5DEA336; Mon,  3
        Oct 2022 15:10:34 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221003141033eusmtip16bc31e2af8980ab2616d5779b6ac3887~alHLMlvTy2253422534eusmtip1e;
        Mon,  3 Oct 2022 14:10:33 +0000 (GMT)
Message-ID: <8cdd1927-da38-c23e-fa75-384694724b1c@samsung.com>
Date:   Mon, 3 Oct 2022 16:10:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.13.1
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v8 00/29] Rework the trip points creation
To:     Daniel Lezcano <daniel.lezcano@linaro.org>, rafael@kernel.org
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
Content-Language: en-US
In-Reply-To: <20221003092602.1323944-1-daniel.lezcano@linaro.org>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZduzned2ot1bJBv8XWlmce/ybxeLBvG1s
        Fmt7j7JYfN9yncli3mdZi1VTd7JY7H29ld1i0+NrrBYT959lt+j6tZLZ4vKuOWwWs5f0s1h8
        7j3CaLH15Tsmi4m3N7BbzDi/j8mi88ssNotjC8QsVu95wWwx98tUZosnD/vYLPa2XmR2EPOY
        df8sm8eKT/oeO2fdZfdYvOclk8emVZ1sHneu7WHz2Lyk3mPjux1MHv1/DTz6tqxi9Pi8SS6A
        O4rLJiU1J7MstUjfLoErY2rXEeaCI4UVHbfOMzUwHkjqYuTkkBAwkZg/p4Oli5GLQ0hgBaPE
        xwNLGSGcL4wSO44/gMp8ZpS42/qcBabl4f2rUFXLGSX2rf/OBuF8ZJS4euQUWBWvgJ3EzPbN
        TCA2i4CKxKlXe5kg4oISJ2c+AasRFUiW+Nl1gA3EZhMwlOh62wVmCwvYSrz/0ckOYosIOEp8
        +buIHWQBs0Ajm8SinmawImYBcYlbT+aDDeUEKuppncMKEZeXaN46mxmkQULgHafE02fz2CHu
        dpHY27qbDcIWlnh1fAtUXEbi9OQeFoiGdkaJBb/vM0E4ExglGp7fYoSospa4c+4XUDcH0ApN
        ifW79EFMCaDN9//5Q5h8EjfeCkLcwCcxadt0Zogwr0RHmxDEDDWJWcfXwW09eOES8wRGpVlI
        wTILyWezkHwzC2HtAkaWVYziqaXFuempxUZ5qeV6xYm5xaV56XrJ+bmbGIHp9PS/4192MC5/
        9VHvECMTB+MhRgkOZiUR3jmPrJKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ87LN0EoWEkhPLEnN
        Tk0tSC2CyTJxcEo1MOW0dm+4fzj8zTx/ZdP/4VeVT3Wejznbr7Pxl5a28PXvj7VYWU0Pniu8
        8uYZp11v49fFFp6qK12u/DS22fvArfZzs9HHKz1rtnzp259cd2nLupVJvYtm1T9Qetq3ZnFq
        875VBWluHps76jc1P/noLbNU7OyUE3NfbNpmK6IYY+oyYYNQ3IdbV05OvsPd7Ra0Zg/HEWe9
        19k5sU+XfY15Lnw0quB2sN7/B+tVVVa6mHnbXpuZP/vqGr8jWpd7rTkYV/Q2/OQOTTmqG5js
        x7u4kl3svTvz1sOBfsefu9q8VX9R+HTHxAytD58XRDk/PVB8/umdiEj7d0HbXFga7+dcjVKJ
        Eypmyz80/8MB5vXepj+VWIozEg21mIuKEwG+dl6MFgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t/xu7pRb62SDe7fY7Y49/g3i8WDedvY
        LNb2HmWx+L7lOpPFvM+yFqum7mSx2Pt6K7vFpsfXWC0m7j/LbtH1ayWzxeVdc9gsZi/pZ7H4
        3HuE0WLry3dMFhNvb2C3mHF+H5NF55dZbBbHFohZrN7zgtli7pepzBZPHvaxWextvcjsIOYx
        6/5ZNo8Vn/Q9ds66y+6xeM9LJo9NqzrZPO5c28PmsXlJvcfGdzuYPPr/Gnj0bVnF6PF5k1wA
        d5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZapG+XYJextSu
        I8wFRworOm6dZ2pgPJDUxcjJISFgIvHw/lXGLkYuDiGBpYwS/58/ZoJIyEicnNbACmELS/y5
        1sUGUfSeUaJx4io2kASvgJ3EzPbNYA0sAioSp17tZYKIC0qcnPmEBcQWFUiWePlnIjuIzSZg
        KNH1tgusV1jAVuL9j06wuIiAo8SXv4vYQRYwCzSzSXx6OokFYtsURol/H3Yxg1QxC4hL3Hoy
        H2wDJ1BHT+scVoi4mUTX1i5GCFteonnrbOYJjEKzkBwyC0n7LCQts5C0LGBkWcUoklpanJue
        W2yoV5yYW1yal66XnJ+7iRGYQLYd+7l5B+O8Vx/1DjEycTAeYpTgYFYS4Z3zyCpZiDclsbIq
        tSg/vqg0J7X4EKMpMDQmMkuJJucDU1heSbyhmYGpoYmZpYGppZmxkjivZ0FHopBAemJJanZq
        akFqEUwfEwenVAPTBGtTrvNxU367BeYq5CYZJSuteKtemcpUv5HR/2Ivc8yzNu6mSqF1garc
        lhOOXF/Uw3T6TvS7jgmbbjt8qU49FfZG9G5V7OqlH57IKOyeYJ0lb8tn3aQuv1xXXonLWmBW
        3pLpzK09B197+E2/UOrzcsr3LRO/LGVJ8Ir9pKGlWPM+8wXjBJ1F0u//r+OMZ2hOURA2SQnj
        lwp70XrpyI/z1ktuuq2O+2/U9a5iFk9ANOuZ/onOz1a1PaiaYWH8oaAvNtBNd0HS3x0WeyNb
        y+rbO0r/9ea5VHDM+vPzWtvXj7zpBRMl+Rf09Fv0emmYcZlzqjy/9feTtqNtml2W8sR9Ezum
        6Vn/7c4/pblkiRJLcUaioRZzUXEiAJnr022pAwAA
X-CMS-MailID: 20221003141034eucas1p1d6f80828f25dc593be48459e3cd39be5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb
References: <CGME20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb@eucas1p2.samsung.com>
        <20221003092602.1323944-1-daniel.lezcano@linaro.org>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On 03.10.2022 11:25, Daniel Lezcano wrote:
> This work is the pre-requisite of handling correctly when the trip
> point are crossed. For that we need to rework how the trip points are
> declared and assigned to a thermal zone.
>
> Even if it appears to be a common sense to have the trip points being
> ordered, this no guarantee neither documentation telling that is the
> case.
>
> One solution could have been to create an ordered array of trips built
> when registering the thermal zone by calling the different get_trip*
> ops. However those ops receive a thermal zone pointer which is not
> known as it is in the process of creating it.
>
> This cyclic dependency shows we have to rework how we manage the trip
> points.
>
> Actually, all the trip points definition can be common to the backend
> sensor drivers and we can factor out the thermal trip structure in all
> of them.
>
> Then, as we register the thermal trips array, they will be available
> in the thermal zone structure and a core function can return the trip
> given its id.
>
> The get_trip_* ops won't be needed anymore and could be removed. The
> resulting code will be another step forward to a self encapsulated
> generic thermal framework.
>
> Most of the drivers can be converted more or less easily. This series
> does a first round with most of the drivers. Some remain and will be
> converted but with a smaller set of changes as the conversion is a bit
> more complex.
>
> Changelog:
> v8:
> - Pretty oneline change and parenthesis removal (Rafael)
> - Collected tags
> v7:
> - Added missing return 0 in the x86_pkg_temp driver
> v6:
> - Improved the code for the get_crit_temp() function as suggested by 
> Rafael
> - Removed inner parenthesis in the set_trip_temp() function and invert the
> conditions. Check the type of the trip point is unchanged
> - Folded patch 4 with 1
> - Add per thermal zone info message in the bang-bang governor
> - Folded the fix for an uninitialized variable in 
> int340x_thermal_zone_add()
> v5:
> - Fixed a deadlock when calling thermal_zone_get_trip() while
> handling the thermal zone lock
> - Remove an extra line in the sysfs change
> - Collected tags
> v4:
> - Remove extra lines on exynos changes as reported by Krzysztof Kozlowski
> - Collected tags
> v3:
> - Reorg the series to be git-bisect safe
> - Added the set_trip generic function
> - Added the get_crit_temp generic function
> - Removed more dead code in the thermal-of
> - Fixed the exynos changelog
> - Fixed the error check for the exynos drivers
> - Collected tags
> v2:
> - Added missing EXPORT_SYMBOL_GPL() for thermal_zone_get_trip()
> - Removed tab whitespace in the acerhdf driver
> - Collected tags
>
> Cc: Raju Rangoju <rajur@chelsio.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Peter Kaestle <peter@piie.net>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Mark Gross <markgross@kernel.org>
> Cc: Miquel Raynal <miquel.raynal@bootlin.com>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Amit Kucheria <amitk@kernel.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Nicolas Saenz Julienne <nsaenz@kernel.org>
> Cc: Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Ray Jui <rjui@broadcom.com>
> Cc: Scott Branden <sbranden@broadcom.com>
> Cc: Support Opensource <support.opensource@diasemi.com>
> Cc: Lukasz Luba <lukasz.luba@arm.com>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: Thara Gopinath <thara.gopinath@linaro.org>
> Cc: Andy Gross <agross@kernel.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: "Niklas Söderlund" <niklas.soderlund@ragnatech.se>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Cc: Keerthy <j-keerthy@ti.com>
> Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: Dmitry Osipenko <digetx@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: platform-driver-x86@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-rpi-kernel@lists.infradead.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-arm-msm@vger.kernel.org
> Cc: linux-renesas-soc@vger.kernel.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-tegra@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
>
> Daniel Lezcano (29):
> thermal/core: Add a generic thermal_zone_get_trip() function
> thermal/sysfs: Always expose hysteresis attributes
> thermal/core: Add a generic thermal_zone_set_trip() function
> thermal/core/governors: Use thermal_zone_get_trip() instead of ops
> functions
> thermal/of: Use generic thermal_zone_get_trip() function
> thermal/of: Remove unused functions
> thermal/drivers/exynos: Use generic thermal_zone_get_trip() function
> thermal/drivers/exynos: of_thermal_get_ntrips()
> thermal/drivers/exynos: Replace of_thermal_is_trip_valid() by
> thermal_zone_get_trip()
> thermal/drivers/tegra: Use generic thermal_zone_get_trip() function
> thermal/drivers/uniphier: Use generic thermal_zone_get_trip() function
> thermal/drivers/hisi: Use generic thermal_zone_get_trip() function
> thermal/drivers/qcom: Use generic thermal_zone_get_trip() function
> thermal/drivers/armada: Use generic thermal_zone_get_trip() function
> thermal/drivers/rcar_gen3: Use the generic function to get the number
> of trips
> thermal/of: Remove of_thermal_get_ntrips()
> thermal/of: Remove of_thermal_is_trip_valid()
> thermal/of: Remove of_thermal_set_trip_hyst()
> thermal/of: Remove of_thermal_get_crit_temp()
> thermal/drivers/st: Use generic trip points
> thermal/drivers/imx: Use generic thermal_zone_get_trip() function
> thermal/drivers/rcar: Use generic thermal_zone_get_trip() function
> thermal/drivers/broadcom: Use generic thermal_zone_get_trip() function
> thermal/drivers/da9062: Use generic thermal_zone_get_trip() function
> thermal/drivers/ti: Remove unused macros ti_thermal_get_trip_value() /
> ti_thermal_trip_is_valid()
> thermal/drivers/acerhdf: Use generic thermal_zone_get_trip() function
> thermal/drivers/cxgb4: Use generic thermal_zone_get_trip() function
> thermal/intel/int340x: Replace parameter to simplify
> thermal/drivers/intel: Use generic thermal_zone_get_trip() function

I've tested this v8 patchset after fixing the issue with Exynos TMU with 
https://lore.kernel.org/all/20221003132943.1383065-1-daniel.lezcano@linaro.org/ 
patch and I got the following lockdep warning on all Exynos-based boards:


======================================================
WARNING: possible circular locking dependency detected
6.0.0-rc1-00083-ge5c9d117223e #12945 Not tainted
------------------------------------------------------
swapper/0/1 is trying to acquire lock:
c1ce66b0 (&data->lock#2){+.+.}-{3:3}, at: exynos_get_temp+0x3c/0xc8

but task is already holding lock:
c2979b94 (&tz->lock){+.+.}-{3:3}, at: 
thermal_zone_device_update.part.0+0x3c/0x528

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&tz->lock){+.+.}-{3:3}:
        mutex_lock_nested+0x1c/0x24
        thermal_zone_get_trip+0x20/0x44
        exynos_tmu_initialize+0x144/0x1e0
        exynos_tmu_probe+0x2b0/0x728
        platform_probe+0x5c/0xb8
        really_probe+0xe0/0x414
        __driver_probe_device+0xa0/0x208
        driver_probe_device+0x30/0xc0
        __driver_attach+0xf0/0x1f0
        bus_for_each_dev+0x70/0xb0
        bus_add_driver+0x174/0x218
        driver_register+0x88/0x11c
        do_one_initcall+0x64/0x380
        kernel_init_freeable+0x1c0/0x224
        kernel_init+0x18/0x12c
        ret_from_fork+0x14/0x2c
        0x0

-> #0 (&data->lock#2){+.+.}-{3:3}:
        lock_acquire+0x124/0x3e4
        __mutex_lock+0x90/0x948
        mutex_lock_nested+0x1c/0x24
        exynos_get_temp+0x3c/0xc8
        __thermal_zone_get_temp+0x5c/0x12c
        thermal_zone_device_update.part.0+0x78/0x528
        __thermal_cooling_device_register.part.0+0x298/0x354
        __cpufreq_cooling_register.constprop.0+0x138/0x218
        of_cpufreq_cooling_register+0x48/0x8c
        cpufreq_online+0x8d0/0xb2c
        cpufreq_add_dev+0xb0/0xec
        subsys_interface_register+0x108/0x118
        cpufreq_register_driver+0x15c/0x380
        dt_cpufreq_probe+0x2e4/0x434
        platform_probe+0x5c/0xb8
        really_probe+0xe0/0x414
        __driver_probe_device+0xa0/0x208
        driver_probe_device+0x30/0xc0
        __driver_attach+0xf0/0x1f0
        bus_for_each_dev+0x70/0xb0
        bus_add_driver+0x174/0x218
        driver_register+0x88/0x11c
        do_one_initcall+0x64/0x380
        kernel_init_freeable+0x1c0/0x224
        kernel_init+0x18/0x12c
        ret_from_fork+0x14/0x2c
        0x0

other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&tz->lock);
                                lock(&data->lock#2);
                                lock(&tz->lock);
   lock(&data->lock#2);

  *** DEADLOCK ***

5 locks held by swapper/0/1:
  #0: c1c8648c (&dev->mutex){....}-{3:3}, at: __driver_attach+0xe4/0x1f0
  #1: c1210434 (cpu_hotplug_lock){++++}-{0:0}, at: 
cpufreq_register_driver+0xc4/0x380
  #2: c1ed8298 (subsys mutex#8){+.+.}-{3:3}, at: 
subsys_interface_register+0x4c/0x118
  #3: c131f944 (thermal_list_lock){+.+.}-{3:3}, at: 
__thermal_cooling_device_register.part.0+0x238/0x354
  #4: c2979b94 (&tz->lock){+.+.}-{3:3}, at: 
thermal_zone_device_update.part.0+0x3c/0x528

stack backtrace:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc1-00083-ge5c9d117223e 
#12945
Hardware name: Samsung Exynos (Flattened Device Tree)
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x58/0x70
  dump_stack_lvl from check_noncircular+0xf0/0x158
  check_noncircular from __lock_acquire+0x15e8/0x2a7c
  __lock_acquire from lock_acquire+0x124/0x3e4
  lock_acquire from __mutex_lock+0x90/0x948
  __mutex_lock from mutex_lock_nested+0x1c/0x24
  mutex_lock_nested from exynos_get_temp+0x3c/0xc8
  exynos_get_temp from __thermal_zone_get_temp+0x5c/0x12c
  __thermal_zone_get_temp from thermal_zone_device_update.part.0+0x78/0x528
  thermal_zone_device_update.part.0 from 
__thermal_cooling_device_register.part.0+0x298/0x354
  __thermal_cooling_device_register.part.0 from 
__cpufreq_cooling_register.constprop.0+0x138/0x218
  __cpufreq_cooling_register.constprop.0 from 
of_cpufreq_cooling_register+0x48/0x8c
  of_cpufreq_cooling_register from cpufreq_online+0x8d0/0xb2c
  cpufreq_online from cpufreq_add_dev+0xb0/0xec
  cpufreq_add_dev from subsys_interface_register+0x108/0x118
  subsys_interface_register from cpufreq_register_driver+0x15c/0x380
  cpufreq_register_driver from dt_cpufreq_probe+0x2e4/0x434
  dt_cpufreq_probe from platform_probe+0x5c/0xb8
  platform_probe from really_probe+0xe0/0x414
  really_probe from __driver_probe_device+0xa0/0x208
  __driver_probe_device from driver_probe_device+0x30/0xc0
  driver_probe_device from __driver_attach+0xf0/0x1f0
  __driver_attach from bus_for_each_dev+0x70/0xb0
  bus_for_each_dev from bus_add_driver+0x174/0x218
  bus_add_driver from driver_register+0x88/0x11c
  driver_register from do_one_initcall+0x64/0x380
  do_one_initcall from kernel_init_freeable+0x1c0/0x224
  kernel_init_freeable from kernel_init+0x18/0x12c
  kernel_init from ret_from_fork+0x14/0x2c
Exception stack(0xf082dfb0 to 0xf082dff8)
...

Let me know if You need anything more to test.


> drivers/net/ethernet/chelsio/cxgb4/cxgb4.h | 2 -
> .../ethernet/chelsio/cxgb4/cxgb4_thermal.c | 41 +----
> drivers/platform/x86/acerhdf.c | 73 +++-----
> drivers/thermal/armada_thermal.c | 39 ++---
> drivers/thermal/broadcom/bcm2835_thermal.c | 8 +-
> drivers/thermal/da9062-thermal.c | 52 +-----
> drivers/thermal/gov_bang_bang.c | 39 +++--
> drivers/thermal/gov_fair_share.c | 18 +-
> drivers/thermal/gov_power_allocator.c | 51 +++---
> drivers/thermal/gov_step_wise.c | 22 ++-
> drivers/thermal/hisi_thermal.c | 11 +-
> drivers/thermal/imx_thermal.c | 72 +++-----
> .../int340x_thermal/int340x_thermal_zone.c | 33 ++--
> .../int340x_thermal/int340x_thermal_zone.h | 4 +-
> .../processor_thermal_device.c | 10 +-
> drivers/thermal/intel/x86_pkg_temp_thermal.c | 120 +++++++------
> drivers/thermal/qcom/qcom-spmi-temp-alarm.c | 39 ++---
> drivers/thermal/rcar_gen3_thermal.c | 2 +-
> drivers/thermal/rcar_thermal.c | 53 +-----
> drivers/thermal/samsung/exynos_tmu.c | 57 +++----
> drivers/thermal/st/st_thermal.c | 47 +----
> drivers/thermal/tegra/soctherm.c | 33 ++--
> drivers/thermal/tegra/tegra30-tsensor.c | 17 +-
> drivers/thermal/thermal_core.c | 160 +++++++++++++++---
> drivers/thermal/thermal_core.h | 24 +--
> drivers/thermal/thermal_helpers.c | 28 +--
> drivers/thermal/thermal_netlink.c | 21 +--
> drivers/thermal/thermal_of.c | 116 -------------
> drivers/thermal/thermal_sysfs.c | 133 +++++----------
> drivers/thermal/ti-soc-thermal/ti-thermal.h | 15 --
> drivers/thermal/uniphier_thermal.c | 27 ++-
> include/linux/thermal.h | 10 ++
> 32 files changed, 559 insertions(+), 818 deletions(-)
>
Best regards

-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

