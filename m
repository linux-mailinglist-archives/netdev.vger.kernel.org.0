Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDC21A8EA0
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 00:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392001AbgDNWao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 18:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391991AbgDNWaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 18:30:35 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096D0C061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 15:30:35 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e26so14946798wmk.5
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 15:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=okVUGJ3ikrrEbdgJgp1xfbeReFhs19fwarQOs8B1AZk=;
        b=FEbTmIVNW0JoSjYjr3F58Dza+Cb1Ac/sA7nNj8BJjD5avga0CHKNryFlZnyWoMT1E2
         na8aftYRyJNOnjaU94xdsOPIs71//+sqT+bELBHBZIbzI3nbi3kByYX15ybKGjV8hqN8
         PxohgfpVVFNtgIAZ8+2c5mP0p6CodDxUFWMY4O2jSjXsEBQJo7J8DK9ftSUKzLWke7nn
         oAeGy3RkG0ySkJTzFv/BokwJwPVpqQYV+DSF2MSBBYwES8cAPcLFhiyABwkrSKDt1/Xd
         zIbH9mjT61r1ANGVDNH0HBZbSuIrs3gfbCaJ63UJPyZrYL+Xj0hS9iZs1617fg7qMyP9
         Bgww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=okVUGJ3ikrrEbdgJgp1xfbeReFhs19fwarQOs8B1AZk=;
        b=GjDnLHUNI0jgC9jCcr38E0JFKYQ+EFgcYLW8tEGtBs+Z0ETaUcjujbiE9C3np2k/wR
         TDxcrFSGGJ/DmwkIc3fLtPrAjqSSE1619xgo+ogUnPuy/t8qT+yGPtCJEURCDrp9YeTl
         7M24pzvYE6L7H8z51j21k1yt83KXEVg2HjmClW3/J2stIuzgnnt1/oO7GWQGIcPHPrwG
         F2U2L69TFHo7jCyAbPy2fzBdlJVV2sC7r6rtIUuxk16dZKwhVIuWeAtC7KqvpQXaTZCu
         5StxRwGRTXrMQ0gBnn+Qp+04Iw/nnvtyFUp70A+s/zbVvXtxv+vwBurMpLE54g+Ohxhq
         LYfQ==
X-Gm-Message-State: AGi0PuavUZw53vEXSNgcxvm/wZ6wImS+3hNOS4Hw6oIkrCnqXdolX1ao
        wYlkXLVjQS8pAN4oWD8GLI3Aqg==
X-Google-Smtp-Source: APiQypIbVYGNGOComyaA0BUnVsxnNYsocIyXxHF8/fexB9IRx/uxZhOitPNh1Qfq4Q5sjQ8E/NKUGA==
X-Received: by 2002:a1c:bd08:: with SMTP id n8mr1947813wmf.23.1586903433566;
        Tue, 14 Apr 2020 15:30:33 -0700 (PDT)
Received: from [192.168.0.41] (lns-bzn-59-82-252-135-148.adsl.proxad.net. [82.252.135.148])
        by smtp.googlemail.com with ESMTPSA id g186sm21701352wmg.36.2020.04.14.15.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 15:30:33 -0700 (PDT)
Subject: Re: [RFC v2 4/9] thermal: core: Let thermal zone device's mode be
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
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
 <20200414180105.20042-1-andrzej.p@collabora.com>
 <20200414180105.20042-5-andrzej.p@collabora.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <c053480c-8279-2a51-7a55-252ff723b432@linaro.org>
Date:   Wed, 15 Apr 2020 00:30:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200414180105.20042-5-andrzej.p@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2020 20:01, Andrzej Pietrasiewicz wrote:
> All the drivers which provide ->get_mode()/->set_mode() methods store their
> mode in a thermal_device_mode enum, so keep this information in struct
> thermal_zone_device rather than scattered all over the place.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---
>  drivers/thermal/thermal_core.c  | 28 +++++++++++++++++++
>  drivers/thermal/thermal_sysfs.c |  9 +++----
>  include/linux/thermal.h         | 48 +++++++++++++++++++++++++++++++++
>  3 files changed, 79 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 9a321dc548c8..cb0ff47f0dbe 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -469,6 +469,34 @@ static void thermal_zone_device_reset(struct thermal_zone_device *tz)
>  	thermal_zone_device_init(tz);
>  }
>  
> +int thermal_zone_device_get_mode(struct thermal_zone_device *tz,
> +				 enum thermal_device_mode *mode)
> +{
> +	if (tz->ops->get_mode)
> +		return tz->ops->get_mode(tz, mode);

I think we can get rid of the get_mode here.

locks missing.

and mode = tz->mode must be always set.

> +	*mode = tz->mode;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(thermal_zone_device_get_mode);
> +
> +int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
> +				 enum thermal_device_mode mode)
> +{
> +	if (mode != THERMAL_DEVICE_DISABLED &&
> +	    mode != THERMAL_DEVICE_ENABLED)
> +		return -EINVAL;

I'm not sure this is useful as 'mode' is an enum and this condition will
be always correct.

locks missing.

> +	if (tz->ops->set_mode)
> +		return tz->ops->set_mode(tz, mode);

> +	tz->mode = mode;

It should be like:

	int ret = 0;

	mutex_lock(&tz->lock);

	if (tz->ops->set_mode)
		ret = tz->ops->set_mode(tz, mode);

	*mode = tz->mode;

	mutex_unlock(&tz->lock);

	return ret;

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(thermal_zone_device_set_mode);
> +
>  void thermal_zone_device_update(struct thermal_zone_device *tz,
>  				enum thermal_notify_event event)
>  {
> diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
> index aa99edb4dff7..66d9691b8bd6 100644
> --- a/drivers/thermal/thermal_sysfs.c
> +++ b/drivers/thermal/thermal_sysfs.c
> @@ -52,10 +52,7 @@ mode_show(struct device *dev, struct device_attribute *attr, char *buf)
>  	enum thermal_device_mode mode;
>  	int result;
>  
> -	if (!tz->ops->get_mode)
> -		return -EPERM;
> -
> -	result = tz->ops->get_mode(tz, &mode);
> +	result = thermal_zone_device_get_mode(tz, &mode);
>  	if (result)
>  		return result;
>  
> @@ -74,9 +71,9 @@ mode_store(struct device *dev, struct device_attribute *attr,
>  		return -EPERM;
>  
>  	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
> -		result = tz->ops->set_mode(tz, THERMAL_DEVICE_ENABLED);
> +		result = thermal_zone_device_enable(tz);
>  	else if (!strncmp(buf, "disabled", sizeof("disabled") - 1))
> -		result = tz->ops->set_mode(tz, THERMAL_DEVICE_DISABLED);
> +		result = thermal_zone_device_disable(tz);
>  	else
>  		result = -EINVAL;
>  
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index c91b1e344d56..9ff8542b7e7d 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -143,6 +143,7 @@ struct thermal_attr {
>   * @trip_temp_attrs:	attributes for trip points for sysfs: trip temperature
>   * @trip_type_attrs:	attributes for trip points for sysfs: trip type
>   * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
> + * @mode:		current mode of this thermal zone
>   * @devdata:	private pointer for device private data
>   * @trips:	number of trip points the thermal zone supports
>   * @trips_disabled;	bitmap for disabled trips
> @@ -185,6 +186,7 @@ struct thermal_zone_device {
>  	struct thermal_attr *trip_temp_attrs;
>  	struct thermal_attr *trip_type_attrs;
>  	struct thermal_attr *trip_hyst_attrs;
> +	enum thermal_device_mode mode;
>  	void *devdata;
>  	int trips;
>  	unsigned long trips_disabled;	/* bitmap for disabled trips */
> @@ -437,6 +439,19 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *, int,
>  				     unsigned int);
>  int thermal_zone_unbind_cooling_device(struct thermal_zone_device *, int,
>  				       struct thermal_cooling_device *);
> +
> +int thermal_zone_device_get_mode(struct thermal_zone_device *tz,
> +				 enum thermal_device_mode *mode);
> +int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
> +				 enum thermal_device_mode mode);
> +
> +static inline void
> +thermal_zone_device_store_mode(struct thermal_zone_device *tz,
> +			       enum thermal_device_mode mode)
> +{
> +	tz->mode = mode;
> +}
> +

Please remove this store_mode function, it is not needed.

Just:

thermal_zone_device_get_mode()
thermal_zone_device_set_mode()
thermal_zone_device_disable()
thermal_zone_device_enable()

And all of them in drivers/thermal/thermal_core.h

>  void thermal_zone_device_update(struct thermal_zone_device *,
>  				enum thermal_notify_event);
>  void thermal_zone_set_trips(struct thermal_zone_device *);
> @@ -494,6 +509,17 @@ static inline int thermal_zone_unbind_cooling_device(
>  	struct thermal_zone_device *tz, int trip,
>  	struct thermal_cooling_device *cdev)
>  { return -ENODEV; }
> +static inline int thermal_zone_device_get_mode(struct thermal_zone_device *tz,
> +					       enum thermal_device_mode *mode)
> +{ return -ENODEV; }
> +static inline int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
> +					       enum thermal_device_mode mode)
> +{ return -ENODEV; }
> +static inline void
> +thermal_zone_device_store_mode(struct thermal_zone_device *tz,
> +			       enum thermal_device_mode mode)
> +{ }
> +
>  static inline void thermal_zone_device_update(struct thermal_zone_device *tz,
>  					      enum thermal_notify_event event)
>  { }
> @@ -543,4 +569,26 @@ static inline void thermal_notify_framework(struct thermal_zone_device *tz,
>  { }
>  #endif /* CONFIG_THERMAL */
>  
> +static inline int thermal_zone_device_enable(struct thermal_zone_device *tz)
> +{
> +	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_ENABLED);
> +}
> +
> +static inline int thermal_zone_device_disable(struct thermal_zone_device *tz)
> +{
> +	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_DISABLED);
> +}
> +
> +static inline void
> +thermal_zone_device_store_enabled(struct thermal_zone_device *tz)
> +{
> +	thermal_zone_device_store_mode(tz, THERMAL_DEVICE_ENABLED);
> +}
> +
> +static inline void
> +thermal_zone_device_store_disabled(struct thermal_zone_device *tz)
> +{
> +	thermal_zone_device_store_mode(tz, THERMAL_DEVICE_DISABLED);
> +}
> +
>  #endif /* __THERMAL_H__ */
> 


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
