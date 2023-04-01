Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F46D33CE
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 22:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjDAU3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 16:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDAU3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 16:29:00 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D531BF50
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 13:28:56 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e18so25622167wra.9
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 13:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680380934;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=24uuoIvImerfhmwpshjVrRatNouisgokJvBC3oEiaZs=;
        b=aKzl2GwkFLmJg3c2tHmarRnWD+obdhbTVdQjO2WRq4d/5EhrUG3XauCMdTfNe7k3fv
         QW6b2p3luQN9Ph/pmTK3ybgO97OhcUmKMZrz9koIg8SHejwXgdqD2l35qGVKpnt/1OG2
         WhjAj4gEI1JjrdFwWepegj3s/lKvNGZqjTqNjW/4+NmtuvITAWnhWCblUT5XloWKc/OA
         0jebFFsNyLpqNUcwz105OtQ9FJrVIdJIzaeu4T9PBuTsVaFQDv6sOqpbKeaI3kO8Wq7+
         FfATA15TAmlb7nVHoYZ6HP+b/4vc6cCV7hN0i5+ZXN601cBhmJeY4M3Wpyidplr5GUGG
         mpAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680380934;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=24uuoIvImerfhmwpshjVrRatNouisgokJvBC3oEiaZs=;
        b=umd/SFOda2lBN7bAEzkFZM4loXOBbj8tBAYfnI75kHrPbv99N5TFFfrdQJTz5DR/nV
         UrPQY38zI5X2XZQcem9zWgKVCNLaB5VwzrfHagcIpQFfiwhtutcF8BnxczT9n5Z/BUPD
         M95RSwTYr5k44UX4sBQgxrhNycmemPde8Jjoh9qOTTJsR7CXDFKXpcsN2HhJtzGaFgBo
         49vFoD4GwDhfN1+ULxID+LzvdSOsLwSGcNp+eNPEODehZ7BxGk7xtp9EngfJqbR1HPR+
         PN1mtzI/hFtBICvR6APHCGt+Wjedh3dnMdddCeK7ZoxR2jI2RdlR3cjkGps6p8UdjGgD
         KCfQ==
X-Gm-Message-State: AAQBX9cmjNSkAPuSW44DL7J0J/4P+ZjUNSSpZBf/8arRtgYxIUtYbl3w
        Wqrj6qCodBS3D3KFquUdwoqEdg==
X-Google-Smtp-Source: AKy350bB7aNBM90V8cH03+WKQQIpm67tBcZogiGQBZyJcD4dzqKv8GDufbGsC2aSilR+TtuKu2E7ng==
X-Received: by 2002:a5d:5648:0:b0:2e4:b507:d274 with SMTP id j8-20020a5d5648000000b002e4b507d274mr6591335wrw.71.1680380933707;
        Sat, 01 Apr 2023 13:28:53 -0700 (PDT)
Received: from ?IPV6:2a05:6e02:1041:c10:b36a:1186:309c:1f9a? ([2a05:6e02:1041:c10:b36a:1186:309c:1f9a])
        by smtp.googlemail.com with ESMTPSA id z17-20020a5d4d11000000b002da75c5e143sm5643244wrt.29.2023.04.01.13.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Apr 2023 13:28:53 -0700 (PDT)
Message-ID: <26681360-45a5-cfcc-e1f0-1c2e16fafca5@linaro.org>
Date:   Sat, 1 Apr 2023 22:28:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 1/3] mlxsw: core_thermal: Use static trip points
 for transceiver modules
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>, mlxsw@nvidia.com
References: <cover.1680272119.git.petrm@nvidia.com>
 <051bffde8a638410eea98ac51cb3a429e0130889.1680272119.git.petrm@nvidia.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <051bffde8a638410eea98ac51cb3a429e0130889.1680272119.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/03/2023 16:17, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The driver registers a thermal zone for each transceiver module and
> tries to set the trip point temperatures according to the thresholds
> read from the transceiver. If a threshold cannot be read or if a
> transceiver is unplugged, the trip point temperature is set to zero,
> which means that it is disabled as far as the thermal subsystem is
> concerned.
> 
> A recent change in the thermal core made it so that such trip points are
> no longer marked as disabled, which lead the thermal subsystem to
> incorrectly set the associated cooling devices to the their maximum
> state [1]. A fix to restore this behavior was merged in commit
> f1b80a3878b2 ("thermal: core: Restore behavior regarding invalid trip
> points"). However, the thermal maintainer suggested to not rely on this
> behavior and instead always register a valid array of trip points [2].
> 
> Therefore, create a static array of trip points with sane defaults
> (suggested by Vadim) and register it with the thermal zone of each
> transceiver module. User space can choose to override these defaults
> using the thermal zone sysfs interface since these files are writeable.
> 
> Before:
> 
>   $ cat /sys/class/thermal/thermal_zone11/type
>   mlxsw-module11
>   $ cat /sys/class/thermal/thermal_zone11/trip_point_*_temp
>   65000
>   75000
>   80000
> 
> After:
> 
>   $ cat /sys/class/thermal/thermal_zone11/type
>   mlxsw-module11
>   $ cat /sys/class/thermal/thermal_zone11/trip_point_*_temp
>   55000
>   65000
>   80000
> 
> Also tested by reverting commit f1b80a3878b2 ("thermal: core: Restore
> behavior regarding invalid trip points") and making sure that the
> associated cooling devices are not set to their maximum state.
> 
> [1] https://lore.kernel.org/linux-pm/ZA3CFNhU4AbtsP4G@shredder/
> [2] https://lore.kernel.org/linux-pm/f78e6b70-a963-c0ca-a4b2-0d4c6aeef1fb@linaro.org/
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---

Sounds like the changes result in a nice cleanup :)

Thanks for taking care of doing these changes

   -- Daniel

>   .../ethernet/mellanox/mlxsw/core_thermal.c    | 110 ++++--------------
>   1 file changed, 25 insertions(+), 85 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index 09ed6e5fa6c3..ece5075b7dbf 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -19,6 +19,9 @@
>   #define MLXSW_THERMAL_ASIC_TEMP_NORM	75000	/* 75C */
>   #define MLXSW_THERMAL_ASIC_TEMP_HIGH	85000	/* 85C */
>   #define MLXSW_THERMAL_ASIC_TEMP_HOT	105000	/* 105C */
> +#define MLXSW_THERMAL_MODULE_TEMP_NORM	55000	/* 55C */
> +#define MLXSW_THERMAL_MODULE_TEMP_HIGH	65000	/* 65C */
> +#define MLXSW_THERMAL_MODULE_TEMP_HOT	80000	/* 80C */
>   #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
>   #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
>   #define MLXSW_THERMAL_MAX_STATE	10
> @@ -30,12 +33,6 @@ static char * const mlxsw_thermal_external_allowed_cdev[] = {
>   	"mlxreg_fan",
>   };
>   
> -enum mlxsw_thermal_trips {
> -	MLXSW_THERMAL_TEMP_TRIP_NORM,
> -	MLXSW_THERMAL_TEMP_TRIP_HIGH,
> -	MLXSW_THERMAL_TEMP_TRIP_HOT,
> -};
> -
>   struct mlxsw_cooling_states {
>   	int	min_state;
>   	int	max_state;
> @@ -59,6 +56,24 @@ static const struct thermal_trip default_thermal_trips[] = {
>   	},
>   };
>   
> +static const struct thermal_trip default_thermal_module_trips[] = {
> +	{	/* In range - 0-40% PWM */
> +		.type		= THERMAL_TRIP_ACTIVE,
> +		.temperature	= MLXSW_THERMAL_MODULE_TEMP_NORM,
> +		.hysteresis	= MLXSW_THERMAL_HYSTERESIS_TEMP,
> +	},
> +	{
> +		/* In range - 40-100% PWM */
> +		.type		= THERMAL_TRIP_ACTIVE,
> +		.temperature	= MLXSW_THERMAL_MODULE_TEMP_HIGH,
> +		.hysteresis	= MLXSW_THERMAL_HYSTERESIS_TEMP,
> +	},
> +	{	/* Warning */
> +		.type		= THERMAL_TRIP_HOT,
> +		.temperature	= MLXSW_THERMAL_MODULE_TEMP_HOT,
> +	},
> +};
> +
>   static const struct mlxsw_cooling_states default_cooling_states[] = {
>   	{
>   		.min_state	= 0,
> @@ -140,63 +155,6 @@ static int mlxsw_get_cooling_device_idx(struct mlxsw_thermal *thermal,
>   	return -ENODEV;
>   }
>   
> -static void
> -mlxsw_thermal_module_trips_reset(struct mlxsw_thermal_module *tz)
> -{
> -	tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temperature = 0;
> -	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temperature = 0;
> -	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temperature = 0;
> -}
> -
> -static int
> -mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
> -				  struct mlxsw_thermal_module *tz,
> -				  int crit_temp, int emerg_temp)
> -{
> -	int err;
> -
> -	/* Do not try to query temperature thresholds directly from the module's
> -	 * EEPROM if we got valid thresholds from MTMP.
> -	 */
> -	if (!emerg_temp || !crit_temp) {
> -		err = mlxsw_env_module_temp_thresholds_get(core, tz->slot_index,
> -							   tz->module,
> -							   SFP_TEMP_HIGH_WARN,
> -							   &crit_temp);
> -		if (err)
> -			return err;
> -
> -		err = mlxsw_env_module_temp_thresholds_get(core, tz->slot_index,
> -							   tz->module,
> -							   SFP_TEMP_HIGH_ALARM,
> -							   &emerg_temp);
> -		if (err)
> -			return err;
> -	}
> -
> -	if (crit_temp > emerg_temp) {
> -		dev_warn(dev, "%s : Critical threshold %d is above emergency threshold %d\n",
> -			 tz->tzdev->type, crit_temp, emerg_temp);
> -		return 0;
> -	}
> -
> -	/* According to the system thermal requirements, the thermal zones are
> -	 * defined with three trip points. The critical and emergency
> -	 * temperature thresholds, provided by QSFP module are set as "active"
> -	 * and "hot" trip points, "normal" trip point is derived from "active"
> -	 * by subtracting double hysteresis value.
> -	 */
> -	if (crit_temp >= MLXSW_THERMAL_MODULE_TEMP_SHIFT)
> -		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temperature = crit_temp -
> -					MLXSW_THERMAL_MODULE_TEMP_SHIFT;
> -	else
> -		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temperature = crit_temp;
> -	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temperature = crit_temp;
> -	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temperature = emerg_temp;
> -
> -	return 0;
> -}
> -
>   static int mlxsw_thermal_bind(struct thermal_zone_device *tzdev,
>   			      struct thermal_cooling_device *cdev)
>   {
> @@ -358,10 +316,8 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
>   	struct mlxsw_thermal_module *tz = tzdev->devdata;
>   	struct mlxsw_thermal *thermal = tz->parent;
>   	int temp, crit_temp, emerg_temp;
> -	struct device *dev;
>   	u16 sensor_index;
>   
> -	dev = thermal->bus_info->dev;
>   	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + tz->module;
>   
>   	/* Read module temperature and thresholds. */
> @@ -371,13 +327,6 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
>   						     &crit_temp, &emerg_temp);
>   	*p_temp = temp;
>   
> -	if (!temp)
> -		return 0;
> -
> -	/* Update trip points. */
> -	mlxsw_thermal_module_trips_update(dev, thermal->core, tz,
> -					  crit_temp, emerg_temp);
> -
>   	return 0;
>   }
>   
> @@ -527,10 +476,7 @@ mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
>   			  struct mlxsw_thermal_area *area, u8 module)
>   {
>   	struct mlxsw_thermal_module *module_tz;
> -	int dummy_temp, crit_temp, emerg_temp;
> -	u16 sensor_index;
>   
> -	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + module;
>   	module_tz = &area->tz_module_arr[module];
>   	/* Skip if parent is already set (case of port split). */
>   	if (module_tz->parent)
> @@ -538,19 +484,13 @@ mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
>   	module_tz->module = module;
>   	module_tz->slot_index = area->slot_index;
>   	module_tz->parent = thermal;
> -	memcpy(module_tz->trips, default_thermal_trips,
> +	BUILD_BUG_ON(ARRAY_SIZE(default_thermal_module_trips) !=
> +		     MLXSW_THERMAL_NUM_TRIPS);
> +	memcpy(module_tz->trips, default_thermal_module_trips,
>   	       sizeof(thermal->trips));
>   	memcpy(module_tz->cooling_states, default_cooling_states,
>   	       sizeof(thermal->cooling_states));
> -	/* Initialize all trip point. */
> -	mlxsw_thermal_module_trips_reset(module_tz);
> -	/* Read module temperature and thresholds. */
> -	mlxsw_thermal_module_temp_and_thresholds_get(core, area->slot_index,
> -						     sensor_index, &dummy_temp,
> -						     &crit_temp, &emerg_temp);
> -	/* Update trip point according to the module data. */
> -	return mlxsw_thermal_module_trips_update(dev, core, module_tz,
> -						 crit_temp, emerg_temp);
> +	return 0;
>   }
>   
>   static void mlxsw_thermal_module_fini(struct mlxsw_thermal_module *module_tz)

-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

