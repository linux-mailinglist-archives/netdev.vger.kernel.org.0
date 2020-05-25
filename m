Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B64E1E1797
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgEYWIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729183AbgEYWIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 18:08:43 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38529C08C5C1
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 15:08:43 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r9so1314375wmh.2
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 15:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B1HW4u5LJKYDF9KUNg/7Plr8B/Znc0iT47gyM0yG2iU=;
        b=cX6QZ9y5aiks4vwrtxOkDbQEjk/dF9h25k22Jg+APG/88UZFshwzTAu+JwmS5qpazX
         Cqz3FVk7wDfM85nq29VU+qwUgFCHz+86sPNm6IiOlFH+jmyY3aZNMNAYBxdX/Hs9iHXK
         OnOE+QDH3rYDn51T/D2mlcKuHBEmk6NS1vPg1cCbn3rSopGbBPpAw51DLh23pF5ptpmh
         iqw+d2VaYJr89ghY3lQCj9xT9UI/Ygi6I00HUuHCAZMbL7dK8LmvkLcJXxLnB/JY5FDf
         J+DnU3jAc0Vbb4DJIe5gBh9rxLCchse5DC264bgZvZGpn1owvQc1LAipt5FwR8jULpUF
         cqDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B1HW4u5LJKYDF9KUNg/7Plr8B/Znc0iT47gyM0yG2iU=;
        b=ITgMPFifIPSJn+SEvwwNKGKVzBxEz3+sGVyFWqG+e58Bywfn3nGBF8oCXJgpkUQrEk
         WuR+pd7ZlaygPe6xbPcefoHEf7xVQdVscwBABYPBhCJ0grI/RpX2byoLW07Jioj8cC/9
         zszP/k+EcnBJ/1941micloPTFgTharVLjD5UPeifzjbwmJ8WW8VrEytsQTBc0P0m9YQG
         LZG5MP+vTcZ5QCKxLBt/Vjb4Rbr8Bkt/vxQILEzntV/MWKTTpQKWcwQs3IVFg5mHugui
         ve1g0w4edU0cR9YMLG5tz5dfloYJyIgpqebCXwCfi/F9tfxSqURrpm0k6zOA5bp+JLvl
         MbSw==
X-Gm-Message-State: AOAM530YpOrYQWekZpMWdr7sLrgkdbszY7FQA+k+cFU4bQmLJZGYrtic
        jgnHolm5fh9NbPxcwnWS48IDzA==
X-Google-Smtp-Source: ABdhPJw9Rxu8ps0O9Ohw9wOXynvpYrr9Dk3yASRBFsmg5cRbkDT4TwOGptGM9LwM8pEcGCRK28UFRA==
X-Received: by 2002:a7b:cd06:: with SMTP id f6mr8591078wmj.8.1590444521387;
        Mon, 25 May 2020 15:08:41 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:f482:8f0b:7244:7a1b? ([2a01:e34:ed2f:f020:f482:8f0b:7244:7a1b])
        by smtp.googlemail.com with ESMTPSA id f11sm4457423wrm.13.2020.05.25.15.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 15:08:40 -0700 (PDT)
Subject: Re: [RFC v3 1/2] thermal: core: Let thermal zone device's mode be
 stored in its struct
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
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        Barlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
References: <9ac3b37a-8746-b8ee-70e1-9c876830ac83@linaro.org>
 <20200417162020.19980-1-andrzej.p@collabora.com>
 <20200417162020.19980-2-andrzej.p@collabora.com>
 <f39c5ca6-5efa-889c-21f5-632dfd24715e@linaro.org>
 <802b4bd5-07c9-de3a-2ac6-5905b12d6adc@collabora.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <b8b69bf3-07bf-8747-dce6-65a73c02fb88@linaro.org>
Date:   Tue, 26 May 2020 00:08:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <802b4bd5-07c9-de3a-2ac6-5905b12d6adc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/05/2020 21:35, Andrzej Pietrasiewicz wrote:
> Hi Daniel,
> 
> W dniu 23.05.2020 o 23:24, Daniel Lezcano pisze:
>> Hi Andrzej,
>>
>> On 17/04/2020 18:20, Andrzej Pietrasiewicz wrote:
>>> Thermal zone devices' mode is stored in individual drivers. This patch
>>> changes it so that mode is stored in struct thermal_zone_device instead.
>>>
>>> As a result all driver-specific variables storing the mode are not
>>> needed
>>> and are removed. Consequently, the get_mode() implementations have
>>> nothing
>>> to operate on and need to be removed, too.
>>>
>>> Some thermal framework specific functions are introduced:
>>>
>>> thermal_zone_device_get_mode()
>>> thermal_zone_device_set_mode()
>>> thermal_zone_device_enable()
>>> thermal_zone_device_disable()
>>>
>>> thermal_zone_device_get_mode() and its "set" counterpart take tzd's lock
>>> and the "set" calls driver's set_mode() if provided, so the latter must
>>> not take this lock again. At the end of the "set"
>>> thermal_zone_device_update() is called so drivers don't need to
>>> repeat this
>>> invocation in their specific set_mode() implementations.
>>>
>>> The scope of the above 4 functions is purposedly limited to the thermal
>>> framework and drivers are not supposed to call them. This encapsulation
>>> does not fully work at the moment for some drivers, though:
>>>
>>> - platform/x86/acerhdf.c
>>> - drivers/thermal/imx_thermal.c
>>> - drivers/thermal/intel/intel_quark_dts_thermal.c
>>> - drivers/thermal/of-thermal.c
>>>
>>> and they manipulate struct thermal_zone_device's members directly.
>>>
>>> struct thermal_zone_params gains a new member called initial_mode, which
>>> is used to set tzd's mode at registration time.
>>>
>>> The sysfs "mode" attribute is always exposed from now on, because all
>>> thermal zone devices now have their get_mode() implemented at the
>>> generic
>>> level and it is always available. Exposing "mode" doesn't hurt the
>>> drivers
>>> which don't provide their own set_mode(), because writing to "mode" will
>>> result in -EPERM, as expected.
>>
>> The result is great, that is a nice cleanup of the thermal framework.
>>
>> After review it appears there are still problems IMO, especially with
>> the suspend / resume path. The patch is big, it is a bit complex to
>> comment. I suggest to re-org the changes as following:
>>
>>   - patch 1 : Add the four functions:
>>
>>   * thermal_zone_device_set_mode()
>>   * thermal_zone_device_enable()
>>   * thermal_zone_device_disable()
>>   * thermal_zone_device_is_enabled()
>>
>> *but* do not export thermal_zone_device_set_mode(), it must stay private
>> to the thermal framework ATM.
> 
> Not exporting thermal_zone_device_set_mode() implies not exporting
> thermal_zone_device_enable()/thermal_zone_device_disable() because they
> are implemented in terms of the former. Or do you have a different idea?

I meant no inline for them but as below:

in .h

extern int thermal_zone_device_enable();
extern int thermal_zone_device_disable();
extern int thermal_zone_device_is_enabled();

in .c

static int thermal_zone_device_set_mode()
{
	...
}

int thermal_zone_device_enable()
{
	thermal_zone_device_set_mode();
}
EXPORT_SYMBOL_GPL(thermal_zone_device_enable);


>>   - patch 2 : Add the mode THERMAL_DEVICE_SUSPENDED
>>
>> In the thermal_pm_notify() in the:
>>
>>   - PM_SUSPEND_PREPARE case, set the mode to THERMAL_DEVICE_SUSPENDED if
>> the mode is THERMAL_DEVICE_ENABLED
>>
>>   - PM_POST_SUSPEND case, set the mode to THERMAL_DEVICE_ENABLED, if the
>> mode is THERMAL_DEVICE_SUSPENDED
>>
>>   - patch 3 : Change the monitor function
>>
>> Change monitor_thermal_zone() function to set the polling to zero if the
>> mode is THERMAL_DEVICE_DISABLED
> 
> So we assume this: if a driver creates a tz which is initially ENABLED,
> it will be polled. If a driver creates a tz which is initially DISABLED
> (which is what you suggest the drivers should be doing, but not all of them
> do), it won't be polled unless the driver explicitly enables its tz.

Yes.

> Am I concluding right that a suspended device will remain polled? Is it ok?

Actually it is not ok but AFAICT, it is the current behavior. The
polling do not stop but the 'in_suspend' prevent an update. I thought we
can post-pone the suspend case later when the ENABLED/DISABLED changes
are consolidated, so SUSPENDED will act as DISABLED.

>>   - patch 4 : Do the changes to remove get_mode() ops
>>
>> Make sure there is no access to tz->mode from the drivers anymore but
>> use of the functions of patch 1. IMO, this is the tricky part because a
>> part of the drivers are not calling the update after setting the mode
>> while the function thermal_zone_device_enable()/disable() call update
>> via the thermal_zone_device_set_mode(), so we must be sure to not break
>> anything.
> 
> Ah, I guess now is the time to make the functions from patch 1 exported?

Yes :)

> Ensuring no driver accesses tz->mode directly might be tricky, indeed.
> If it can be shown that calling the update doesn't hurt a particular
> driver,
> it can be converted to use the helpers instead of manipulating tz->mode
> directly. If, however, it does make a difference then it all depends and
> getting rid of accessing tz->mode directly might require help from the
> respective maintainers.

Agree.

> This also calls for storing tz's mode in struct thermal_zone_device
> rather than in individual drivers. In fact it seems the purpose
> of ->get_mode() is to produce the state stored internally in drivers.
> Removing ->get_mode() requires changing the place where the state is
> stored. struct thermal_zone_device seems most appropriate. So this patch
> is not going to be small.

Yes, the patch can be big. It is fine if the changes are only to replace
tz->mode by their respective disable/enable/is_enabled functions. More
complex changes can be separate.

> Once we start storing tz's state in struct thermal_zone_device the
> ->set_mode() implementations need to be changed, too. To me it seems
> awkward to split this change in two patches: if we keep the changes
> split then in patch 4 we need to introduce code which implements
> ->set_mode() in terms of the new state location, only to remove it
> in the very next patch.

Yes, it is a valid point. May be you can do the changes in two patches
to see the results in terms of complexity for the review process, then
decide if it is worth to merge them before sending.

> While we are at it some drivers, namely acpi/thermal and int3400 store
> their mode in an int rather than enum thermal_device_mode. So maybe
> changing this should go even before patch 4?

I agree.

> acerhdf does not store
> its mode at all and on top of it it wants to manipulate the polling
> delay directly and it has a module parameter which specifies it.



>>   - patch 5 : Do the changes to remove set_mode() ops users
>>
>> As the patch 3 sets the polling to zero, the routine in the driver
>> setting the polling to zero is no longer needed (eg. in the mellanox
>> driver). I expect int300 to be the last user of this ops, hopefully we
>> can find a way to get rid of the specific call done inside and then
>> remove the ops.
> 
> acerhdf wants ->set_mode() desperately.

Yes, there is a couple of drivers which requires for the moment to keep
the ops->set_mode to be called: int3400 and acerhdf. Both of them will
be greatly simplified with the DISABLED / ENABLED changes.

>> The initial_mode approach looks hackish, I suggest to make the default
>> the thermal zone disabled after creating and then explicitly enable it.
> 
> Is it needed in drivers which create their thermal zone enabled?

IMO, yes. We are doing changes with a code prone to issues, so making
the steps: creation + enable will make things more clear. For instance,
the clk framework do the same.


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
