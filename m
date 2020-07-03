Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A4F2139A1
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 13:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgGCL5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 07:57:20 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43562 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgGCL5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 07:57:19 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id F1F462A63DE
Subject: Re: [PATCH 0/3] Fixes for stop monitoring disabled devices series
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
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
References: <20200703104354.19657-1-andrzej.p@collabora.com>
 <fc1bb7f5-2096-a604-8c30-81d34bf5b737@linaro.org>
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Message-ID: <91db4c89-0615-4a69-9695-ed5d3c42e1b7@collabora.com>
Date:   Fri, 3 Jul 2020 13:57:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <fc1bb7f5-2096-a604-8c30-81d34bf5b737@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

W dniu 03.07.2020 o 13:06, Daniel Lezcano pisze:
> On 03/07/2020 12:43, Andrzej Pietrasiewicz wrote:
>> This short series contains fixes for "Stop monitoring disabled devices"
>> series https://www.spinics.net/lists/arm-kernel/msg817861.html
>>
>> Invocation of thermal_zone_device_is_enabled() in acpi/thermal is now
>> redundant, because thermal_zone_device_update() now is capable of
>> handling disabled devices.
>>
>> In imx's ->get_temp() the lock must not be taken, otherwise a deadlock
>> happens. The decision whether explicitly running a measurement cycle
>> is needed is taken based on driver's local irq_enabled variable.
>>
>> Finally, thermal_zone_device_is_enabled() is made available to the
>> core only, as there are no driver users of it.
>>
>> Andrzej Pietrasiewicz (3):
>>    acpi: thermal: Don't call thermal_zone_device_is_enabled()
>>    thermal: imx: Use driver's local data to decide whether to run a
>>      measurement
>>    thermal: Make thermal_zone_device_is_enabled() available to core only
>>
>>   drivers/acpi/thermal.c         | 3 ---
>>   drivers/thermal/imx_thermal.c  | 7 ++++---
>>   drivers/thermal/thermal_core.c | 1 -
>>   drivers/thermal/thermal_core.h | 2 ++
>>   include/linux/thermal.h        | 5 -----
>>   5 files changed, 6 insertions(+), 12 deletions(-)
> 
> Is this series easily merge-able with the other series?
> 

So-so.

Some simple conflicts needed to be resolved.

I have created a branch for you to look at and decide
how far off it is from the original and whether the
original Acked-by/Reviewed-by can be retained.

Note that I might have lost some portions of code
during conflict resolution. It seems to me I haven't
but you know.

The branch:

https://gitlab.collabora.com/andrzej.p/kernel-tests/-/tree/thermal-dont-poll-disabled-for-daniel

The code compiles at each stage on x86_64 + COMPILE_TEST.

Andrzej







