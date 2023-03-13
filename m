Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4156B747D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCMKpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjCMKpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:45:49 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B97952F62
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:45:46 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso10616118wmb.0
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678704345;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6YaG0SWzLbweQszAk60kBLdxmB/7i6RyPeQI10oAzV4=;
        b=LGtukpD/p9tW2HynhY3ArpOnq71vUNWspCHDXcqL9E0H12uUGwCrNnJ8M0RxmdNpeq
         pAeM7HgE3lC/iWS08/SNNgrlDNCkMeXQqRuX8cwlBg4zRVpNXPW3gDjtnKxALuceF78y
         NdVTDObibZ8R4EtyBNCPIMcq0OgaTbkZvAM49h3p8hUGXW7fJ7YGuhjTjqQdepEuEkoV
         cD7UbzHMLuWJXYr4Foe1gbFD2MHYxciKwANocceIkSdzewD4rowtkp2iwkioPH9TaNKp
         rEBkV5vvEN+FggyOIX39CDWbzc/iJhYRAVxAyxEi2kAEgx37tlorGCa+Sd08jrlENeFY
         mZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678704345;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6YaG0SWzLbweQszAk60kBLdxmB/7i6RyPeQI10oAzV4=;
        b=uv/fRTaJJgfkc2MI9/JdrRsR+zawo9uWGDY2nO/R/Y28lrcolVTTo0gDtT94/Exhy5
         kz7o5MBwlZD2xdWYTPNXCp8wYKPQV2Tp1NfopRaJM6Py7n562qeER58kVKC3J/57tgAy
         Vf+0bGxSwGbO1JnjcFLlRNhvq+gpM2GAgESPVH9bRZ2Luh5Sjko1rGAD+7Cqpikpq8Vs
         K5/Uzi5VYgjdpUT/ir3GtFkuVaKlJCHPF9HJKHnSXHVee6tZQvm/X5+gDtKIfTIMMwlI
         p6CCdGsLQUuITbfNx99HYNI8Q31eTgJ54xOQPMnFw53gz0k3onZ4WUw3EmH9tliDwQ0u
         d7Ow==
X-Gm-Message-State: AO0yUKXTcNsIxeV7eGFq4Dqed+8q+dY2Uvypny96NGzVtQQUHdEO0tkq
        bh5pM7n3zVD1ku93EkKfvcv6DQ==
X-Google-Smtp-Source: AK7set+0Oc4726DzdphLUKeZrWCln4A5vSwSav6cx8LjV/d2+4mI/5d3Gg6o/COIT9hrcw7T8dFWSQ==
X-Received: by 2002:a05:600c:3504:b0:3ea:d620:579b with SMTP id h4-20020a05600c350400b003ead620579bmr9852881wmq.0.1678704344899;
        Mon, 13 Mar 2023 03:45:44 -0700 (PDT)
Received: from ?IPV6:2a05:6e02:1041:c10:8522:ca6e:1db4:96c6? ([2a05:6e02:1041:c10:8522:ca6e:1db4:96c6])
        by smtp.googlemail.com with ESMTPSA id l4-20020a05600c4f0400b003dc4a47605fsm9523224wmq.8.2023.03.13.03.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 03:45:44 -0700 (PDT)
Message-ID: <f78e6b70-a963-c0ca-a4b2-0d4c6aeef1fb@linaro.org>
Date:   Mon, 13 Mar 2023 11:45:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v8 01/29] thermal/core: Add a generic
 thermal_zone_get_trip() function
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     rafael@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, rui.zhang@intel.com,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Kaestle <peter@piie.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Amit Kucheria <amitk@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Dmitry Osipenko <digetx@gmail.com>, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        danieller@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com
References: <20221003092602.1323944-1-daniel.lezcano@linaro.org>
 <20221003092602.1323944-2-daniel.lezcano@linaro.org>
 <ZA3CFNhU4AbtsP4G@shredder>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <ZA3CFNhU4AbtsP4G@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Ido,

On 12/03/2023 13:14, Ido Schimmel wrote:
> On Mon, Oct 03, 2022 at 11:25:34AM +0200, Daniel Lezcano wrote:
>> @@ -1252,9 +1319,10 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
>>   		goto release_device;
>>   
>>   	for (count = 0; count < num_trips; count++) {
>> -		if (tz->ops->get_trip_type(tz, count, &trip_type) ||
>> -		    tz->ops->get_trip_temp(tz, count, &trip_temp) ||
>> -		    !trip_temp)
>> +		struct thermal_trip trip;
>> +
>> +		result = thermal_zone_get_trip(tz, count, &trip);
>> +		if (result)
>>   			set_bit(count, &tz->trips_disabled);
>>   	}
> 
> Daniel, this change makes it so that trip points with a temperature of
> zero are no longer disabled. This behavior was originally added in
> commit 81ad4276b505 ("Thermal: Ignore invalid trip points"). The mlxsw
> driver relies on this behavior - see mlxsw_thermal_module_trips_reset()
> - and with this change I see that the thermal subsystem tries to
> repeatedly set the state of the associated cooling devices to the
> maximum state. Other drivers might also be affected by this.
> 
> Following patch solves the problem for me:
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 55679fd86505..b50931f84aaa 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1309,7 +1309,7 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
>                  struct thermal_trip trip;
>   
>                  result = thermal_zone_get_trip(tz, count, &trip);
> -               if (result)
> +               if (result || !trip.temperature)
>                          set_bit(count, &tz->trips_disabled);
>          }
> 
> Should I submit it or do you have a better idea?

Thanks for reporting this, I think the fix you are proposing is correct 
regarding the previous behavior.

However, I disagree with the commit 81ad4276b505, because it defines the 
zero as an invalid trip point. But some platforms have warming devices, 
when the temperature is too cold, eg 0°C, we enable the warming device 
in order to stay in the functioning temperature range.

Other devices can do the same with negative temperature values.

This feature is not yet upstream and the rework of the trip point should 
allow proper handling of cold trip points.

If you can send the change to fix the regression that would be great.

But keep in mind, the driver is assuming an internal thermal framework 
behavior. The trips_disabled is only to overcome a trip point 
description bug and you should not rely on it as well as not changing 
the trip points on the fly after they are registered.

Actually, the mlxsw driver should just build a valid array of trip 
points without 0°C trip point and pass it to 
thermal_zone_device_register_with_trips(). That would be a proper change 
without relying on a side effect of the thermal trip bug 0°C workaround.



-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

