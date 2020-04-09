Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35FA1A3275
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 12:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgDIK3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 06:29:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35155 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDIK3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 06:29:41 -0400
Received: by mail-wr1-f67.google.com with SMTP id g3so11356175wrx.2
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 03:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jkRgOsveN5qmBJ0M4R1dAo5UKj2A3MYQ96PvB4Jc5CE=;
        b=IS2IOiCnk4iXdbES0KEBbw/6SOqjQFLsN7lNB5d2C7/qoY2xTbXshqURo/fi5dG5Iz
         GXidyQ9Yw4Y3rzMWM9+RlALOsdgTx1qBDnDGPUGOQecWQ1sYCpxC2ivVw5pvJQ5HWy7+
         F18RqGaCzpTT+BZ+Bs3FwV62hWNomqyVufK9NA0jJ90/UHeK50PV54czICyTNPXNxHrh
         I/07xFpmOdYw/7Iu29LSylka2lsyVgLOHmsu/dg36kOhGJg7F/qKmNlyCvcb5WNa/AeP
         DE2LLRmoXYB60pusRlUwULBGHPbFo0FfIEq5jTWr15i6N8eVjZJYIdKyf7qdCfXZcq9s
         2GEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jkRgOsveN5qmBJ0M4R1dAo5UKj2A3MYQ96PvB4Jc5CE=;
        b=OS9KibQ05iyf72Dg51x3FCOlC2KxgSqt6pg4Bj+wNi2G8VHoBLynoAee7ZfY0vvmX/
         9L0+qXmZbdDQF7h5s46iS76YALozUl3lX7eG8y0nEdSnwqb5+aji3G3nv3a966ZN4/PU
         u2NUWH+wJnszJB8a5MjxSr28HbehRFIOobcDTi6K4PhVrJFlhyulnaT89t9a5yHm70Ca
         07oW+TBSwktBkDBRPA2NHUg9UrwGYUNi2C51DsHYGlEuLwA5Z/HNk7nEEYIKXaDrzwIV
         PjgcN1LvPMhFetnhEzgLAQiQn4QJOE0t13J+uaFjykEfk3Ah6YYNFl5eFoX29VekOrD8
         3CtA==
X-Gm-Message-State: AGi0PuYR+h1MyObRRFiC5Qq13k3ZGMxUG56nvmKhcG90VqXSKTIIFcjf
        lWHQDwAlGUxVlB6FpuxaTczVpA==
X-Google-Smtp-Source: APiQypJ5A9CM3Ob4OXn4XWWblUTVqk+zAuAyVWAIgpRUXU7di1gR50JYOWdb6bfOss/zcEyE+jw/ig==
X-Received: by 2002:adf:fe03:: with SMTP id n3mr195558wrr.315.1586428179858;
        Thu, 09 Apr 2020 03:29:39 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:e1dc:4371:fecd:8292? ([2a01:e34:ed2f:f020:e1dc:4371:fecd:8292])
        by smtp.googlemail.com with ESMTPSA id e2sm6240723wrr.84.2020.04.09.03.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 03:29:39 -0700 (PDT)
Subject: Re: [RFC 0/8] Stop monitoring disabled devices
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org
Cc:     Zhang Rui <rui.zhang@intel.com>,
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
References: <20200407174926.23971-1-andrzej.p@collabora.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
Date:   Thu, 9 Apr 2020 12:29:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200407174926.23971-1-andrzej.p@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/04/2020 19:49, Andrzej Pietrasiewicz wrote:
> The current kernel behavior is to keep polling the thermal zone devices
> regardless of their current mode. This is not desired, as all such "disabled"
> devices are meant to be handled by userspace,> so polling them makes no sense.

Thanks for proposing these changes.

I've been (quickly) through the series and the description below. I have
the feeling the series makes more complex while the current code which
would deserve a cleanup.

Why not first:

 - Add a 'mode' field in the thermal zone device
 - Kill all set/get_mode callbacks in the drivers which are duplicated code.
 - Add a function:

 enum thermal_device_mode thermal_zone_get_mode( *tz)
 {
	...
	if (tz->ops->get_mode)
		return tz->ops->get_mode();

	return tz->mode;
 }


 int thermal_zone_set_mode(..*tz, enum thermal_device_mode mode)
 {
	...
	if (tz->ops->set_mode)
		return tz->ops->set_mode(tz, mode);

	tz->mode = mode;

	return 0;
 }

 static inline thermal_zone_enable(... *tz)
 {
	thermal_zone_set_mode(tz, THERMAL_DEVICE_ENABLED);
 }

 static inline thermal_zone_disable(... *tz) {
	thermal_zone_set_mode(tz, THERMAL_DEVICE_DISABLED);
 }

And then when the code is consolidated, use the mode to enable/disable
the polling and continue killing the duplicated code in of-thermal.c and
anywhere else.


> There was an attempt to solve this issue:
> 
> https://lkml.org/lkml/2018/2/26/498
> 
> and it ultimately has not succeeded:
> 
> https://lkml.org/lkml/2018/2/27/910
> 
> This is a new attempt addressing all the relevant drivers, and I have
> identified them with:
> 
> $ git grep "thermal_zone_device_ops" | grep "= {" | cut -f1 -d: | sort | uniq
> 
> The idea is to modify thermal_zone_device_update() and monitor_thermal_zone()
> in such a way that they stop polling a disabled device. To do decide what to
> do they should call ->get_mode() operation of the specialized thermal zone
> device in question (e.g. drivers/acpi/thermal.c's). But here comes problem:
> sometimes a thermal zone device must be initially disabled and becomes enabled
> only after its sensors appear on the system. If such thermal zone's
> ->get_mode() /* in the context of thermal_zone_device_update() or
> monitor_thermal_zone() */ is called _before_ the sensors are available, it will
> be reported as "disabled" and consequently polling it will be ceased. This is
> a change in behavior from userspace's perspective.
> 
> To solve the above described problem I want to introduce the third mode of a
> thermal_zone_device: initial. The idea is that when the device is in its
> initial mode, then its polling will be handled as it is now. This is a good
> thing: should the temperature be just about hitting the critical treshnold
> early during the boot process, it might be too late if we wait for the
> userspace to run to save the system from overheating. The initial mode should
> be reported in sysfs as "enabled" to keep the userspace interface intact.
> From the initial mode there will be two possible transitions: to enabled or
> disabled mode, but there will be no transition back to initial. If the
> transition is from initial to enabled, then keep polling. If the transition is
> from initial to disabled, then stop polling. If the transition is from enabled
> to disabled, then stop polling. The transition from disabled to enabled must
> be handled in a special way: there must be a mandatory call to
> monitor_thermal_zone(), otherwise the polling will not start. If this
> transition is triggeted from sysfs, then it can be easily handled at the
> thermal framework level. However, if drivers call their own ->set_mode()
> operation then they must also call "monitor_thermal_zone()" afterwards.
> The latter being a sensible thing anyway, so perhaps all/most of the drivers
> in question do. The plan for implementation is this:
> 
> - ensure ALL users use symbolic enum names (THERMAL_DEVICE_DISABLED,
> THERMAL_DEVICE_ENABLED) for thermal device mode rather than the numeric
> values of enum thermal_device_mode elements
> - add THERMAL_DEVICE_INITIAL to the said enum making its value 0 (so that
> kzalloc() results in the initial state)
> - modify thermal zone device's mode_show() (thermal framework level) so that
> it reports "enabled" for THERMAL_DEVICE_INITIAL
> - modify thermal zone device's mode_store() (thermal framework level) so that
> it calls monitor_thermal_zone() upon mode change
> - modify ALL thermal drivers so that their code is prepared to return
> THERMAL_DEVICE_INITIAL before they call thermal_zone_device_register(); when
> the invocation of the latter completes then polling is expected to be started
> - verify ALL drivers which call their own ->set_mode() to ensure they do call
> monitor_thermal_zone() afterwards
> - modify thermal_zone_device_update() and monitor_thermal_zone() so that they
> cancel polling for disabled thermal zone devices (but not for those in
> THERMAL_DEVICE_INITIAL mode)
> 
> This RFC series does all the above steps in more or less that order.
> 
> I kindly ask for comments/suggestions/improvements.
> 
> Rebased onto v5.6.
> 
> Andrzej Pietrasiewicz (8):
>   thermal: int3400_thermal: Statically initialize
>     .get_mode()/.set_mode() ops
>   thermal: Properly handle mode values in .set_mode()
>   thermal: Store thermal mode in a dedicated enum
>   thermal: core: Introduce THERMAL_DEVICE_INITIAL
>   thermal: core: Monitor thermal zone after mode change
>   thermal: Set initial state to THERMAL_DEVICE_INITIAL
>   thermal: of: Monitor thermal zone after enabling it
>   thermal: Stop polling DISABLED thermal devices
> 
>  drivers/acpi/thermal.c                        | 28 +++++-----
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 11 +++-
>  drivers/platform/x86/acerhdf.c                | 17 ++++--
>  drivers/thermal/da9062-thermal.c              |  2 +-
>  drivers/thermal/imx_thermal.c                 |  5 +-
>  .../intel/int340x_thermal/int3400_thermal.c   | 24 ++++-----
>  .../thermal/intel/intel_quark_dts_thermal.c   |  6 ++-
>  drivers/thermal/of-thermal.c                  |  9 +++-
>  drivers/thermal/thermal_core.c                | 52 ++++++++++++++++++-
>  drivers/thermal/thermal_core.h                |  2 +
>  drivers/thermal/thermal_sysfs.c               | 12 +++--
>  include/linux/thermal.h                       |  3 +-
>  12 files changed, 123 insertions(+), 48 deletions(-)
> 


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
