Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47AF20F5FE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387941AbgF3Nn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387429AbgF3Nn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:43:27 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63520C061755;
        Tue, 30 Jun 2020 06:43:27 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id EDD2D2A4A92
Subject: Re: [PATCH v7 00/11] Stop monitoring disabled devices
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
References: <20200629122925.21729-1-andrzej.p@collabora.com>
 <aab40d90-3f72-657c-5e14-e53a34c4b420@linaro.org>
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Message-ID: <3d03d1a2-ac06-b69b-93cb-e0203be62c10@collabora.com>
Date:   Tue, 30 Jun 2020 15:43:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <aab40d90-3f72-657c-5e14-e53a34c4b420@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

I am reading the logs and can't find anything specific to thermal.

What I can see is

"random: crng init done"

with large times (~200s) and then e.g.

'auto-login-action timed out after 283 seconds'

I'm looking at e.g. 
https://storage.kernelci.org/thermal/testing/v5.8-rc3-11-gf5e50bf4d3ef/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-sabrelite.html

Is there anywhere else I can look at?

Andrzej

W dniu 30.06.2020 o 14:57, Daniel Lezcano pisze:
> 
> Hi Andrzej,
> 
> I've tested your series with kernelci and there are 3 regressions for
> the imx6.
> 
> https://kernelci.org/test/job/thermal/branch/testing/kernel/v5.8-rc3-11-gf5e50bf4d3ef/plan/baseline/
> 
> 
> On 29/06/2020 14:29, Andrzej Pietrasiewicz wrote:
>> A respin of v6 with these changes:
>>
>> v6..v7:
>> - removed duplicate S-o-b line from patch 6/11
>>
>> v5..v6:
>> - staticized thermal_zone_device_set_mode() (kbuild test robot)
>>
>> v4..v5:
>>
>> - EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL (Daniel)
>> - dropped unnecessary thermal_zone_device_enable() in int3400_thermal.c
>> and in thermal_of.c (Bartlomiej)
>>
>> Andrzej Pietrasiewicz (11):
>>    acpi: thermal: Fix error handling in the register function
>>    thermal: Store thermal mode in a dedicated enum
>>    thermal: Add current mode to thermal zone device
>>    thermal: Store device mode in struct thermal_zone_device
>>    thermal: remove get_mode() operation of drivers
>>    thermal: Add mode helpers
>>    thermal: Use mode helpers in drivers
>>    thermal: Explicitly enable non-changing thermal zone devices
>>    thermal: core: Stop polling DISABLED thermal devices
>>    thermal: Simplify or eliminate unnecessary set_mode() methods
>>    thermal: Rename set_mode() to change_mode()
>>
>>   drivers/acpi/thermal.c                        | 75 +++++----------
>>   .../ethernet/chelsio/cxgb4/cxgb4_thermal.c    |  8 ++
>>   .../ethernet/mellanox/mlxsw/core_thermal.c    | 91 ++++---------------
>>   drivers/net/wireless/intel/iwlwifi/mvm/tt.c   |  9 +-
>>   drivers/platform/x86/acerhdf.c                | 33 +++----
>>   drivers/platform/x86/intel_mid_thermal.c      |  6 ++
>>   drivers/power/supply/power_supply_core.c      |  9 +-
>>   drivers/thermal/armada_thermal.c              |  6 ++
>>   drivers/thermal/da9062-thermal.c              | 16 +---
>>   drivers/thermal/dove_thermal.c                |  6 ++
>>   drivers/thermal/hisi_thermal.c                |  6 +-
>>   drivers/thermal/imx_thermal.c                 | 57 ++++--------
>>   .../intel/int340x_thermal/int3400_thermal.c   | 38 ++------
>>   .../int340x_thermal/int340x_thermal_zone.c    |  5 +
>>   drivers/thermal/intel/intel_pch_thermal.c     |  5 +
>>   .../thermal/intel/intel_quark_dts_thermal.c   | 34 ++-----
>>   drivers/thermal/intel/intel_soc_dts_iosf.c    |  3 +
>>   drivers/thermal/intel/x86_pkg_temp_thermal.c  |  6 ++
>>   drivers/thermal/kirkwood_thermal.c            |  7 ++
>>   drivers/thermal/rcar_thermal.c                |  9 +-
>>   drivers/thermal/rockchip_thermal.c            |  6 +-
>>   drivers/thermal/spear_thermal.c               |  7 ++
>>   drivers/thermal/sprd_thermal.c                |  6 +-
>>   drivers/thermal/st/st_thermal.c               |  5 +
>>   drivers/thermal/thermal_core.c                | 76 ++++++++++++++--
>>   drivers/thermal/thermal_of.c                  | 41 +--------
>>   drivers/thermal/thermal_sysfs.c               | 37 +-------
>>   include/linux/thermal.h                       | 19 +++-
>>   28 files changed, 275 insertions(+), 351 deletions(-)
>>
>>
>> base-commit: 9ebcfadb0610322ac537dd7aa5d9cbc2b2894c68
>>
> 
> 

