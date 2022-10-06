Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3685F6BA7
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 18:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiJFQ0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 12:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbiJFQZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 12:25:45 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D869C7F0
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 09:25:40 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20221006162537euoutp0172e6ea52f2524cc3c00071debfa5e45d~bh49-41lN2532425324euoutp015
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 16:25:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20221006162537euoutp0172e6ea52f2524cc3c00071debfa5e45d~bh49-41lN2532425324euoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1665073537;
        bh=ImkWCxrft+8A0CCbLgq7IX5h2Sh9xPmozUhnHMtY+jk=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=FJsUUFJT964geyLNAQ2P0Px4X557LDNHc8WhBU1/+CLRMIKX/Zt5DzAEq804L/xdO
         ehDtoI2obNoZY2zBrU3tjgGQej1nyKA44zv/rxflcecWv6qBxDvcpslWo365SKC0KU
         b0U9NvmIdQ764FGqwPWYGjaNbR4Sps3tRmqRocds=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221006162537eucas1p2234855e46d24d17733a2167b8fe40ed3~bh49oF1Rw3151231512eucas1p2w;
        Thu,  6 Oct 2022 16:25:37 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id D2.29.07817.1810F336; Thu,  6
        Oct 2022 17:25:37 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221006162536eucas1p24cebd1ee749c5d96d5d48ab9ede40380~bh49QG9pB1597115971eucas1p2q;
        Thu,  6 Oct 2022 16:25:36 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221006162536eusmtrp1c203c28b20c277cc7ea5ea0a685cbe03~bh49PEL3b0054400544eusmtrp1j;
        Thu,  6 Oct 2022 16:25:36 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-48-633f01811286
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id DD.C5.07473.0810F336; Thu,  6
        Oct 2022 17:25:36 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221006162535eusmtip2e34d1a19e873ba728dcbb60ee3e998b8~bh48QHMJs0707807078eusmtip2i;
        Thu,  6 Oct 2022 16:25:35 +0000 (GMT)
Message-ID: <c7772dd5-f081-426a-5443-5ebf32b7c7c0@samsung.com>
Date:   Thu, 6 Oct 2022 18:25:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0)
        Gecko/20100101 Thunderbird/102.3.1
Subject: Re: [PATCH v8 00/29] Rework the trip points creation
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
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
        linux-omap@vger.kernel.org, rafael@kernel.org
Content-Language: en-US
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <97201878-3bb8-eac5-7fac-a690322ac43a@linaro.org>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf1CTdRi/7/u+fPduNXyZCN9D7Mf0yrD4ddl9LxXxynov86jgouu6co0X
        9BqgG4TVXYALguEUEYQmwg6ljS0F1iA2mdhSCIw1tCMEPOikFBIWbJcEiLm9/eC/z+d5Ps/z
        eZ7nHpqUHIIR9L6sHE6ZJVNIoYhq7/7L9Uwh2C6P1bmF2HVzkcLjde0Qn9VepvBd688ErvOu
        w6YqG4Udv7cJsOXmYBA+1tUvwJqFJhJfs9dCfPLMUQp7tZcAbpucIfCxkRYBrvnxAoFLfTqI
        u/Vh2Nx5m8SnfFUknvjlCMSOogEyMYzVjfVD1jgXw9p0NwTs6c5JgrWYSiE7OtgJ2a/P5LOt
        Mx0Ee/ReLHvEagKs1/LIaw+9Ldqaxin2fcgpYxL2iPbeP68m989EHhwvOwwLgCNcA2gaMc+i
        6dZNGiCiJYwRoBumOsATH0BDLccpnngBGnDZBRogDFScvugO4hMGgLxz5wmezAJkHW+g/Cox
        k4A+05oJP6aYDaivdUTAx0NQ7xcTAc0aJg31ehYDeDWzDXnmSwOaUCYaFXqKA01JphKi74yO
        IH+CZMLR8ER9oClk4pBmWgP9WPjArPn6AMVrHkXqtpOkvxgxU0JUfnuO4ud+ERXpByCPV6Op
        Hus/+0SiK8cPU3zB5wDpF8cInpQDVHBrGPCqLWjUtQD9NyOZp1CzPYY/3w40tpzEw2A0NB3C
        zxCMKtqrST4sRiXFEr7HE0jXc+4/12/dV8lyINWtOItuxZa6Fdvo/rfVA8oEwrlcVWYGp4rP
        4vKiVbJMVW5WRrQ8O9MCHrzpleUeXwcwTM1GOwFBAydANCkNFdtsCXKJOE320cecMvs9Za6C
        UznBWpqShothTZRcwmTIcrgPOG4/p/w3S9DCiAJi7bC8ceQn90v2N6qTrSfEqelrfisqK3Gu
        esua7v5q6f20ZkVx2LZ4l6u2OiTfLB5UGw7VXo0xpypOLGyuMXhi6N1Nqet3dPcx2vFsUYqk
        Cti3JNbl/mDcWFHWC2/5ltR5Q1ZjnzyuvrL2XUh9medoSG8ZaegQf39d8efTm7oqypPhRmqp
        8Vf4apDi3LX8gy+f3dm1cyG22NU/z6x6/Y8Dl3Ief/OVie2z+hlt2eI3ScbH5h3a59kXdjcG
        e96xRM6uT3TdiYrfrNmV9KmzUG+LSLnYX+k23FmXvlX/8GBvxbJ6qn2PY/JuU+gnIl9KzYUn
        6+3PjSanyEwl95rMB+5fbjDsklKqvbK4KFKpkv0Njl+bNRUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t/xe7oNjPbJBrdv6lqce/ybxeLBvG1s
        Fmt7j7JYfN9yncli3mdZi1VTd7JY7H29ld1i0+NrrBYT959lt+j6tZLZ4vKuOWwWs5f0s1h8
        7j3CaLH15Tsmi4m3N7BbzDi/j8mi88ssNotjC8QsVu95wWwx98tUZosnD/vYLPa2XmR2EPOY
        df8sm8eKT/oeO2fdZfdYvOclk8emVZ1sHneu7WHz2Lyk3mPjux1MHv1/DTz6tqxi9Pi8SS6A
        O0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1J7MstUjfLkEv4//u
        ZuaCdzIVD7p72BoY94p3MXJySAiYSCw+cIG1i5GLQ0hgKaPEmv6DTBAJGYmT0xpYIWxhiT/X
        utggit4zStw5Mw+siFfATqKldzWYzSKgInFq4212iLigxMmZT1hAbFGBFIl3E++ygdjCArYS
        7390gtWICOhJNL5vA+tlFpjGJvH5czzEglnMEg2td1kgEuISt57MBytiEzCU6HrbBTaIE2jx
        +psXoWrMJLq2djFC2PISzVtnM09gFJqF5I5ZSEbNQtIyC0nLAkaWVYwiqaXFuem5xYZ6xYm5
        xaV56XrJ+bmbGIHpY9uxn5t3MM579VHvECMTB+MhRgkOZiUR3p077ZKFeFMSK6tSi/Lji0pz
        UosPMZoCA2Mis5Rocj4wgeWVxBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQx
        cXBKNTDNl9No7PN+ePPoZh7r+2q9b3WUzFn/BWvr5tnqv+5g+GR6pYstLqvz9d7sEve3Ahvn
        PFpsJ/gkTObzwzWJutcvJacIld1jDyxieM148+lhuXU+EzdeyFh+7PTF2zamComfVQp7Tqf2
        LtgscuP1nkkPeaXFGpx7jrR4rfW+Krncdk5jkvP2U5fOrgtK/j/zYdWyGt+Axvn6b/pEjrHG
        vLFk7LPUKTVZ45naXK/btmGHxfRNolVNEoHzHpuIdXy4bs3PaTZxW7A006b7H6S+nnlx5/9Z
        kQclkW6zri6OvaFmF3TmpvLnxrQ7h99O/ThzapbzSsN7nPWue2fcLvc49/38yV0JLcJ/F1tZ
        fv4vNOGfEktxRqKhFnNRcSIAo1FZ2agDAAA=
X-CMS-MailID: 20221006162536eucas1p24cebd1ee749c5d96d5d48ab9ede40380
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb
References: <CGME20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb@eucas1p2.samsung.com>
        <20221003092602.1323944-1-daniel.lezcano@linaro.org>
        <8cdd1927-da38-c23e-fa75-384694724b1c@samsung.com>
        <c3258cb2-9a56-d048-5738-1132331a157d@linaro.org>
        <851008bf-145d-224c-87a8-cb6ec1e9addb@linaro.org>
        <207c1979-0da2-b05d-fead-6880ad956b90@samsung.com>
        <97201878-3bb8-eac5-7fac-a690322ac43a@linaro.org>
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On 06.10.2022 08:55, Daniel Lezcano wrote:
>
> On 05/10/2022 15:05, Marek Szyprowski wrote:
>>
>> On 05.10.2022 14:37, Daniel Lezcano wrote:
>>>
>>> On 03/10/2022 23:18, Daniel Lezcano wrote:
>>>
>>> [ ... ]
>>>
>>>>> I've tested this v8 patchset after fixing the issue with Exynos TMU
>>>>> with
>>>>> https://lore.kernel.org/all/20221003132943.1383065-1-daniel.lezcano@linaro.org/ 
>>>>>
>>>>>
>>>>> patch and I got the following lockdep warning on all Exynos-based
>>>>> boards:
>>>>>
>>>>>
>>>>> ======================================================
>>>>> WARNING: possible circular locking dependency detected
>>>>> 6.0.0-rc1-00083-ge5c9d117223e #12945 Not tainted
>>>>> ------------------------------------------------------
>>>>> swapper/0/1 is trying to acquire lock:
>>>>> c1ce66b0 (&data->lock#2){+.+.}-{3:3}, at: exynos_get_temp+0x3c/0xc8
>>>>>
>>>>> but task is already holding lock:
>>>>> c2979b94 (&tz->lock){+.+.}-{3:3}, at:
>>>>> thermal_zone_device_update.part.0+0x3c/0x528
>>>>>
>>>>> which lock already depends on the new lock.
>>>>
>>>> I'm wondering if the problem is not already there and related to
>>>> data->lock ...
>>>>
>>>> Doesn't the thermal zone lock already prevent racy access to the data
>>>> structure?
>>>>
>>>> Another question: if the sensor clock is disabled after reading it,
>>>> how does the hardware update the temperature and detect the programed
>>>> threshold is crossed?
>>>
>>> just a gentle ping, as the fix will depend on your answer ;)
>>>
>> Sorry, I've been busy with other stuff. I thought I will fix this once I
>> find a bit of spare time.
>
> Ok, that is great if you can find time to fix it up because I've other 
> drivers to convert to the generic thermal trips.
>
>
>> IMHO the clock management is a bit over-engineered, as there is little
>> (if any) benefit from such fine grade clock management. That clock is
>> needed only for the AHB related part of the TMU (reading/writing the
>> registers). The IRQ generation and temperature measurement is clocked
>> from so called 'sclk' (special clock).
>>
>> I also briefly looked at the code and the internal lock doesn't look to
>> be really necessary assuming that the thermal core already serializes
>> all the calls.
>
> I looked at the code and I think the driver can be simplified (fixed?) 
> even more.
>
> IIUC, the sensor has multiple trip point interrupts, so if the device 
> tree is describing more trip points than the sensor supports, there is 
> a warning and the number of trip point is capped.
>
> IMO that can be simplified by using two trip point interrupt because 
> the thermal_zone_device_update() will call the set_trips callback with 
> the new boundaries. IOW, the thermal framework sets a new trip point 
> interrupt when one is crossed.
>
> That should result in the simplification of the tmu_control as well as 
> the tmu_probe function. As well as removing the limitation of the 
> number of trip points.
>
> In order to have that correctly working, the 'set_trips' ops must be 
> used to call the tmu_control callback instead of calling it in tmu_probe.
>
> The intialization workflow should be:
>
> probe->...
>  ->thermal_zone_device_register()
>   ->thermal_zone_device_update()
>    ->update_trip_points()
>     ->ops->set_trips()
>       ->tmu_control()
>
> Also, replace the workqueue by a threaded interrupt.
>
> Does it make sense?

Yes, definitely. Frankly speaking I've never looked into that code, so I 
was not aware that it needs some cleanup.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

