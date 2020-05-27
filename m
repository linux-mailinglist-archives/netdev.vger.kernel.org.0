Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A3C1E43AD
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388138AbgE0Nah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:30:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59633 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388131AbgE0Nag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 09:30:36 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200527133033euoutp0108eace2b8479e178f855ec1911c3a885~S5cCe1kzA0073100731euoutp01f
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 13:30:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200527133033euoutp0108eace2b8479e178f855ec1911c3a885~S5cCe1kzA0073100731euoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590586233;
        bh=CYlzgtqHvZcBnMBlxSq2yhphICoXSVRCbRiaI8m1Ov4=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=SrJVXHJL031kvUKOX0SK/rQYDDslUl+zbUlIUW2emHm7kRiDW05EY/Q69ekfZo0uh
         yTaTIk2lZeedFilrXBeh8UeHszdFFae4TDhu01QsNemedxo8dXxDsQjIysR2XKKeMK
         76Xp6inYb6HItdo9LN0l+N/hOS5nqN9heT0Funo0=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200527133033eucas1p2dd415e6f83435068e2b4754a44340876~S5cB_m0ba0416504165eucas1p2X;
        Wed, 27 May 2020 13:30:33 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 7B.A5.60679.97B6ECE5; Wed, 27
        May 2020 14:30:33 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200527133032eucas1p263f0403633f2c53cce0b5a7164d44bcb~S5cBjURAz2115421154eucas1p2F;
        Wed, 27 May 2020 13:30:32 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200527133032eusmtrp14e8451d2a52b4f967f27cbd029f1ec07~S5cBiD6jD1539415394eusmtrp1O;
        Wed, 27 May 2020 13:30:32 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-b0-5ece6b79c13c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 48.E0.07950.87B6ECE5; Wed, 27
        May 2020 14:30:32 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200527133031eusmtip1a5bf7c1448ee307dd1eeb757bb7201d7~S5cAWbKgJ3098830988eusmtip1a;
        Wed, 27 May 2020 13:30:31 +0000 (GMT)
Subject: Re: [RFC v3 1/2] thermal: core: Let thermal zone device's mode be
 stored in its struct
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
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
Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
Date:   Wed, 27 May 2020 15:30:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f39c5ca6-5efa-889c-21f5-632dfd24715e@linaro.org>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0wTaRTNNzOdDmjNWFSur6hVjKuRh4/ki6/4zqAxPn4Z47LbXWbRSNG0
        gqI/fGGFShGpvJqKUtECbhALaamySsoG14BtgdWIgrFaTVWKSjUICsgwGPl37r3n3HPPl48h
        5XX0FGZv0kFenaRMVNChlK2h170wdZ8rLtp8isVl/w1QuMfVS+BrL59ROKdgkMRFwenY5E6j
        sK44GnsfbsXaYAGFvXXrcNuJ2wQ2+VNwlStTgstzHRR2eAM0ttw5h7D15SMJ1vWVkTio/xfh
        hsuTsMezG1+v9ZO4qbFFgn3eLBr3260U9leH439ON5O4yppLrp7G1XSUIK66rI3gSrujOIex
        Q8pVlc7nrtS+IThreQbNtT+qpbkul2uoX3KM+9jpk3Kv8+sJLvtDgOZudtUQ3Ln+aO5La6dk
        W9iu0BXxfOLeFF4dter30D0WbR1xoGPe4cGvDdRx1DtTh0IYYJdAnqUA6VAoI2dLEbj1PZRY
        fELQWvFAKhZBBJd8FaQOMcOSPluK2LcgaH93Y0QeQPDiYgYp7A1jlZBvr6MFPIGNhBPvtYRA
        ItmvUrit7xke0OwyOH+mHAlYxq6CCzmGYTHFRkCnNl0i4InsTuh+Xi8ROePhfqGPEnDIEN/3
        2iEVMMmGwxPfJULEM8AeMJGCGbBnQ6D58zcknr0eXlXOE0OHwdt71VIRT4NGQyYl8isQ9Kf7
        R8R2BBbDAC2ylkO7q48WFpHsL3DjVpTYXgMnbWZC3D8OHgfGizeMgxxb/shrySBdKxfZc6Hy
        WiX9w1bnKCOzkcI4KplxVBrjqDTGn76XEVWOwvlkjSqB1yxK4g9FapQqTXJSQuSf+1VWNPSv
        GwfufapBt7794UQsgxRjZembXHFyiTJFk6pyImBIxQTZ2geNcXJZvDL1CK/e/5s6OZHXONFU
        hlKEyxab3/wqZxOUB/l9PH+AV/+YEkzIlONowZf4Sdb6mr8IfbS9kDoqtzkNd7vSNm+bavJ8
        Ln574frp4ti4waxS1d8QsftpyYYWbbB5ovl5wbOmou0l6vs3syd77+QvdRd1B9vdTdkb9WM9
        aXMSY/MWZIyJWWJ++gJ3O/3yFV1PFktcsszOq562jphZp6pad5hWGiJmZ22x/9+ioDR7lDHz
        SbVG+R184Gcn0wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHfc85O05pcpyab2JlozKEjtvMfDWzm9JJhAy/SJa27OQst8nO
        tBREpVq1rNTy0hA1skzDomk6y8y0rLCWFUk3s+ESI10XK+/WlgV++/F//r8HHnj4uPAZz4uf
        rNSwaqUsRUQ6E10zD3pXHtxvihefvyFFNQ9nCDRqGsfQpf73BCos/Y2j8pGFqOzpYQLpzouR
        +eVWpB0pJZC5bRN6nXsLQ2WD6ajelMdDtUXNBGo2D5OouvU0QIb+Hh7STdTgaOTkPYA6K+ej
        7u4d6ErLII4edz3nIYv5FImmmwwEGmzwRLePPMNRvaEIX+/NGHurANNQ8xpjLn/3Z5r1vY5M
        /WU/5kLLJ4wx1B4nmXc9LSRjNZlseVU2823I4sgMlHRgTP7XYZK5bjVizOlpMTP2YogX7bad
        DlWr0jSsj1zFadaK4iRISkuCES1dFUxLAoJ2hkgDRf5hoXvYlOR0Vu0ftouWV2vbsNTeFQd/
        T3YSOWDcRwf4fEitghON6TrgzBdSFwG82qMlZ3Nv+OCaLXeyoRuc6tGRs53PABaXNPLsAzdK
        Bkua2kg7u1M0zP2ixewlnJp2hHX6438HQuoKBj8+3mdnkgqBBUdrgZ0FVBg8W3gGtzNBLYND
        2mN/l3pQsbDDqP/XcYWPzlkIOzvZ+paBZkc745QvnCp/js+yJ3xjqcBmeTFsGi7D84FQP0fX
        z1H0cxT9HKUSELXAnU3jFEkKTkpzMgWXpkyiE1UKA7C9U2PneIMR6Kwx7YDiA9E8gZgxxQt5
        snQuQ9EOIB8XuQs2PumKFwr2yDIyWbUqQZ2WwnLtINB2XAHu5ZGosj2nUpMgCZQEoWBJUEBQ
        wGok8hQco+7uEFJJMg27n2VTWfV/D+M7eeUA+Y8trfcLQyLpYpepmYq6ykzXsZUd0eKSVpfq
        mERiOubEgqxwLe6w7tVu46FteT4RwGXM9EaztNAl9cBG5a7JJbFO4xFvve6E90VF/Yy8KY8O
        i88xDnrofqnvLkpozLZWmT9wF/20WurwhTVZcX1CB8no3oRLG3RTvsu/Hohx3+wqIji5TOKH
        qznZH/T4alxkAwAA
X-CMS-MailID: 20200527133032eucas1p263f0403633f2c53cce0b5a7164d44bcb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200523212502eucas1p27c01e46512cd6b38c2bb605fad01026f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200523212502eucas1p27c01e46512cd6b38c2bb605fad01026f
References: <9ac3b37a-8746-b8ee-70e1-9c876830ac83@linaro.org>
        <20200417162020.19980-1-andrzej.p@collabora.com>
        <20200417162020.19980-2-andrzej.p@collabora.com>
        <CGME20200523212502eucas1p27c01e46512cd6b38c2bb605fad01026f@eucas1p2.samsung.com>
        <f39c5ca6-5efa-889c-21f5-632dfd24715e@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Daniel,

On 5/23/20 11:24 PM, Daniel Lezcano wrote:
> Hi Andrzej,
> 
> On 17/04/2020 18:20, Andrzej Pietrasiewicz wrote:
>> Thermal zone devices' mode is stored in individual drivers. This patch
>> changes it so that mode is stored in struct thermal_zone_device instead.
>>
>> As a result all driver-specific variables storing the mode are not needed
>> and are removed. Consequently, the get_mode() implementations have nothing
>> to operate on and need to be removed, too.
>>
>> Some thermal framework specific functions are introduced:
>>
>> thermal_zone_device_get_mode()
>> thermal_zone_device_set_mode()
>> thermal_zone_device_enable()
>> thermal_zone_device_disable()
>>
>> thermal_zone_device_get_mode() and its "set" counterpart take tzd's lock
>> and the "set" calls driver's set_mode() if provided, so the latter must
>> not take this lock again. At the end of the "set"
>> thermal_zone_device_update() is called so drivers don't need to repeat this
>> invocation in their specific set_mode() implementations.
>>
>> The scope of the above 4 functions is purposedly limited to the thermal
>> framework and drivers are not supposed to call them. This encapsulation
>> does not fully work at the moment for some drivers, though:
>>
>> - platform/x86/acerhdf.c
>> - drivers/thermal/imx_thermal.c
>> - drivers/thermal/intel/intel_quark_dts_thermal.c
>> - drivers/thermal/of-thermal.c
>>
>> and they manipulate struct thermal_zone_device's members directly.
>>
>> struct thermal_zone_params gains a new member called initial_mode, which
>> is used to set tzd's mode at registration time.
>>
>> The sysfs "mode" attribute is always exposed from now on, because all
>> thermal zone devices now have their get_mode() implemented at the generic
>> level and it is always available. Exposing "mode" doesn't hurt the drivers
>> which don't provide their own set_mode(), because writing to "mode" will
>> result in -EPERM, as expected.
> 
> The result is great, that is a nice cleanup of the thermal framework.
> 
> After review it appears there are still problems IMO, especially with
> the suspend / resume path. The patch is big, it is a bit complex to
> comment. I suggest to re-org the changes as following:

There are still issues with the related existing thermal code but this
patch seems to be a step in the right direction.

For the latest version posted ("v3" one, your mail was replied to the
older "RFC v3" one):

https://lore.kernel.org/linux-pm/20200423165705.13585-2-andrzej.p@collabora.com/

I couldn't find the problems with the patch itself (no new issues
being introduced, all changes seem to be improvements over the current
situation).

Also the patch is not small but it also not that big and it mostly
removes the code:

17 files changed, 105 insertions(+), 244 deletions(-)

I worry that since the original code is intertwined in the interesting
ways the cost of work on splitting the patch on smaller changes may be
higher than its benefits.

>  - patch 1 : Add the four functions:
> 
>  * thermal_zone_device_set_mode()
>  * thermal_zone_device_enable()
>  * thermal_zone_device_disable()
>  * thermal_zone_device_is_enabled()
> 
> *but* do not export thermal_zone_device_set_mode(), it must stay private
> to the thermal framework ATM.
> 
>  - patch 2 : Add the mode THERMAL_DEVICE_SUSPENDED
> 
> In the thermal_pm_notify() in the:
> 
>  - PM_SUSPEND_PREPARE case, set the mode to THERMAL_DEVICE_SUSPENDED if
> the mode is THERMAL_DEVICE_ENABLED
> 
>  - PM_POST_SUSPEND case, set the mode to THERMAL_DEVICE_ENABLED, if the
> mode is THERMAL_DEVICE_SUSPENDED
> 
>  - patch 3 : Change the monitor function
> 
> Change monitor_thermal_zone() function to set the polling to zero if the
> mode is THERMAL_DEVICE_DISABLED
> 
>  - patch 4 : Do the changes to remove get_mode() ops
> 
> Make sure there is no access to tz->mode from the drivers anymore but
> use of the functions of patch 1. IMO, this is the tricky part because a
> part of the drivers are not calling the update after setting the mode
> while the function thermal_zone_device_enable()/disable() call update
> via the thermal_zone_device_set_mode(), so we must be sure to not break
> anything.
> 
>  - patch 5 : Do the changes to remove set_mode() ops users
> 
> As the patch 3 sets the polling to zero, the routine in the driver
> setting the polling to zero is no longer needed (eg. in the mellanox
> driver). I expect int300 to be the last user of this ops, hopefully we
> can find a way to get rid of the specific call done inside and then
> remove the ops.
> 
> The initial_mode approach looks hackish, I suggest to make the default
> the thermal zone disabled after creating and then explicitly enable it.
> Note that is what do a lot of drivers already.
> 
> Hopefully, these changes are git-bisect safe.
> 
> Does it make sense ?

Besides the requirement to split the patch it seems that the above
list contains a lot of problematic areas with the existing thermal
code yet to be addressed..

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
