Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61FA1DFB28
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 23:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388048AbgEWVY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 17:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388041AbgEWVY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 17:24:57 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818DDC08C5C1
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 14:24:57 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q11so1553536wrp.3
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 14:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NJ2Ob42mu1WcRBs7giOQLAtPZNJHbaZp1BDqey6K7MI=;
        b=RvXOPwQzi7tDJl6BuuNT+y72w1UWlBT6YIY4n4BW+N7mx1s25eT3SOYL0a9pqn8cC2
         /nBPem4vYFxmNYxWOqBWQBkn3sVJxdNgMXqEsPliPARPwF9s1cdC6EouAUyE7h3v+/a8
         y7iuF1oFpiLB+H18PuRb2HBsjEZ7Al9v6hTytkZV30xIf2RzrCZP/3duuJBeLAIbe50W
         JGL21qYqGJkk+wBcQh0h57UPVoK44bFcGk23ReI5MpTWxGaNgIq/69hQjTbr1mt1RCDh
         3zd7UC8LF7I/OMuKyUjUIQAVnrx3hLIapw5/dhAbfjTiqjhZqLkatPCYeJqpWjOkqGRD
         eEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NJ2Ob42mu1WcRBs7giOQLAtPZNJHbaZp1BDqey6K7MI=;
        b=etKHQnjkxfLhPFS8asXtaVFgTJfJXDLYbyf+s1LADj2UcHqWTc69hwY9OeJzBy5w2O
         7PpaStoWpjt1FbudJTD48dgG/EIYcrPRyM1Y25dzHxiF7tMQ+lecR6V/kxpJ+9fQtD+q
         AlLg3DWmGDzSBW3ZA9HYlPsBOCWJnlZAtUD/kwU1hhwZwcKWRPvz7OABJr58zeqkiA1b
         QUJjFS/o1fq9TBi76PIOLCVVwR+lpuUWO15gjPd3CQH6kwVNUY1J9iWsNLpa8PZvent9
         Q7OKbSsuY4Z5bpl+LyVevoE5/bVDdObVEVLmGaQltk7QSjWtqtWDHZ9H3oaRKe+xbc90
         orEg==
X-Gm-Message-State: AOAM5323s+odZFM/RkDiAZyAcbdwp2iDJ6n4hWFjkgvkSgBTDfeWpQnI
        BPOMCcfIH4547LMA0ihicVPJAA==
X-Google-Smtp-Source: ABdhPJwe47bVscxaAhr9Nhu8+OAH/5API+xE2Yx2xK6omje0soqamC1EaKrcSCHT/ZrAugOuc2Jm7w==
X-Received: by 2002:a5d:6601:: with SMTP id n1mr793011wru.23.1590269095882;
        Sat, 23 May 2020 14:24:55 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:c871:e070:f68d:a4f7? ([2a01:e34:ed2f:f020:c871:e070:f68d:a4f7])
        by smtp.googlemail.com with ESMTPSA id c25sm12849479wmb.44.2020.05.23.14.24.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 14:24:55 -0700 (PDT)
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
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <f39c5ca6-5efa-889c-21f5-632dfd24715e@linaro.org>
Date:   Sat, 23 May 2020 23:24:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200417162020.19980-2-andrzej.p@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

On 17/04/2020 18:20, Andrzej Pietrasiewicz wrote:
> Thermal zone devices' mode is stored in individual drivers. This patch
> changes it so that mode is stored in struct thermal_zone_device instead.
> 
> As a result all driver-specific variables storing the mode are not needed
> and are removed. Consequently, the get_mode() implementations have nothing
> to operate on and need to be removed, too.
> 
> Some thermal framework specific functions are introduced:
> 
> thermal_zone_device_get_mode()
> thermal_zone_device_set_mode()
> thermal_zone_device_enable()
> thermal_zone_device_disable()
> 
> thermal_zone_device_get_mode() and its "set" counterpart take tzd's lock
> and the "set" calls driver's set_mode() if provided, so the latter must
> not take this lock again. At the end of the "set"
> thermal_zone_device_update() is called so drivers don't need to repeat this
> invocation in their specific set_mode() implementations.
> 
> The scope of the above 4 functions is purposedly limited to the thermal
> framework and drivers are not supposed to call them. This encapsulation
> does not fully work at the moment for some drivers, though:
> 
> - platform/x86/acerhdf.c
> - drivers/thermal/imx_thermal.c
> - drivers/thermal/intel/intel_quark_dts_thermal.c
> - drivers/thermal/of-thermal.c
> 
> and they manipulate struct thermal_zone_device's members directly.
> 
> struct thermal_zone_params gains a new member called initial_mode, which
> is used to set tzd's mode at registration time.
> 
> The sysfs "mode" attribute is always exposed from now on, because all
> thermal zone devices now have their get_mode() implemented at the generic
> level and it is always available. Exposing "mode" doesn't hurt the drivers
> which don't provide their own set_mode(), because writing to "mode" will
> result in -EPERM, as expected.

The result is great, that is a nice cleanup of the thermal framework.

After review it appears there are still problems IMO, especially with
the suspend / resume path. The patch is big, it is a bit complex to
comment. I suggest to re-org the changes as following:

 - patch 1 : Add the four functions:

 * thermal_zone_device_set_mode()
 * thermal_zone_device_enable()
 * thermal_zone_device_disable()
 * thermal_zone_device_is_enabled()

*but* do not export thermal_zone_device_set_mode(), it must stay private
to the thermal framework ATM.

 - patch 2 : Add the mode THERMAL_DEVICE_SUSPENDED

In the thermal_pm_notify() in the:

 - PM_SUSPEND_PREPARE case, set the mode to THERMAL_DEVICE_SUSPENDED if
the mode is THERMAL_DEVICE_ENABLED

 - PM_POST_SUSPEND case, set the mode to THERMAL_DEVICE_ENABLED, if the
mode is THERMAL_DEVICE_SUSPENDED

 - patch 3 : Change the monitor function

Change monitor_thermal_zone() function to set the polling to zero if the
mode is THERMAL_DEVICE_DISABLED

 - patch 4 : Do the changes to remove get_mode() ops

Make sure there is no access to tz->mode from the drivers anymore but
use of the functions of patch 1. IMO, this is the tricky part because a
part of the drivers are not calling the update after setting the mode
while the function thermal_zone_device_enable()/disable() call update
via the thermal_zone_device_set_mode(), so we must be sure to not break
anything.

 - patch 5 : Do the changes to remove set_mode() ops users

As the patch 3 sets the polling to zero, the routine in the driver
setting the polling to zero is no longer needed (eg. in the mellanox
driver). I expect int300 to be the last user of this ops, hopefully we
can find a way to get rid of the specific call done inside and then
remove the ops.

The initial_mode approach looks hackish, I suggest to make the default
the thermal zone disabled after creating and then explicitly enable it.
Note that is what do a lot of drivers already.

Hopefully, these changes are git-bisect safe.

Does it make sense ?












-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
