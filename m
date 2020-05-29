Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526BD1E8285
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgE2PwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgE2PwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:52:08 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6D4C03E969;
        Fri, 29 May 2020 08:52:08 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f3so1515752pfd.11;
        Fri, 29 May 2020 08:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Kr2DFnvRW9808DjObzViZreH2QLKCskc9zy5dtQmZdI=;
        b=calztOD7MAQYZJLZ6WlEsjCp2RnV/0HiXuizF4nZHL9DybyCEERhbozciRw3D78NKL
         vUQ00WTLbGwfhAjfdRq/0M+cyXi0zgLtB9PsEBoWv36Cvdw2VgDG3GX7xMtarrSpSUIH
         8nX0SsqLpX2eqT2Qy1dRy9csYEEyXxgxRS1QMnQYfq7MIKgm63Q4D4nHxBn2S3/LE7PW
         tnahKzvdEKXyg5oWiu8DmsR+hq6Jf7EQ72D23nX24ZZFNHnhyHRpTzEQsThwtuQWyOmZ
         ZMn8vWEGY7fOkBpsj5HCmAGHZ2ASS0GfXqG6JHl+vHiFca5CCJdTFUOg+bL3MMY8wTnk
         NmCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=Kr2DFnvRW9808DjObzViZreH2QLKCskc9zy5dtQmZdI=;
        b=mBQ6qOIQMPtb9I7rmy8xNkZUzr6pazYZ2dBy3I5ubHVJUABGswXBDdGtTr/HoC/5DF
         /jFUvf5DYT9Qhgp8BN68UUviyH3rvfNyyBv4uJ7OY/Z8pa1oLa61E+QPmc1nMtx9/MnI
         h5elsbVkvrRG4y9Jjt6ep1zUMejcoUfIJsz+sG2fwI+xDFpGdDfJMnC9ikyYgUItoJmC
         y95xAeAgDGaMi99GyRBgxEm0QvDsTL4PDXNx4f8nD/NcLD2CWSPxT7ZQKPVIV0uKByx8
         4h6pVE9AJaR6axs+FtyLCIr/KgDb/g0EPiXfRaE0nV0F6AaYjAlrYHAQWk6bGifIScs1
         GkqA==
X-Gm-Message-State: AOAM531VDNfVM5G7uN7lu05UeRAajeIJ6ENYCHmbeu1pNetNGIVTVwB5
        RmuWwzxYjcygZVDGEQp8Q54=
X-Google-Smtp-Source: ABdhPJxB71OKpoh+MwI4lnPVWPMWtTaTiNLX8800beLrNOo1twtsI/3nlAS7CbCEk6IwxGp4GEUUUg==
X-Received: by 2002:a62:174c:: with SMTP id 73mr9027078pfx.71.1590767527890;
        Fri, 29 May 2020 08:52:07 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z23sm7074614pga.86.2020.05.29.08.52.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 08:52:07 -0700 (PDT)
Date:   Fri, 29 May 2020 08:52:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel@collabora.com, Fabio Estevam <festevam@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Allison Randal <allison@lohutok.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Darren Hart <dvhart@infradead.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Len Brown <lenb@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ido Schimmel <idosch@mellanox.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Enrico Weigelt <info@metux.net>,
        Peter Kaestle <peter@piie.net>,
        Sebastian Reichel <sre@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>, Shawn Guo <shawnguo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy@infradead.org>
Subject: Re: [PATCH v4 06/11] thermal: Add mode helpers
Message-ID: <20200529155206.GA158553@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 09:20:46PM +0200, Andrzej Pietrasiewicz wrote:
> Prepare for making the drivers not access tzd's private members.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---
>  drivers/thermal/thermal_core.c | 53 ++++++++++++++++++++++++++++++++++
>  include/linux/thermal.h        | 13 +++++++++
>  2 files changed, 66 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 14d3b1b94c4f..f2a5c5ee3455 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -459,6 +459,59 @@ static void thermal_zone_device_reset(struct thermal_zone_device *tz)
>  	thermal_zone_device_init(tz);
>  }
>  
> +int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
> +				 enum thermal_device_mode mode)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&tz->lock);
> +
> +	/* do nothing if mode isn't changing */
> +	if (mode == tz->mode) {
> +		mutex_unlock(&tz->lock);
> +
Nit: unnecessary empty line.

> +		return ret;
> +	}
> +
> +	if (tz->ops->set_mode)
> +		ret = tz->ops->set_mode(tz, mode);
> +
> +	if (!ret)
> +		tz->mode = mode;
> +
> +	mutex_unlock(&tz->lock);
> +
> +	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
> +
> +	return ret;
> +}
> +
> +int thermal_zone_device_enable(struct thermal_zone_device *tz)
> +{
> +	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_ENABLED);
> +}
> +EXPORT_SYMBOL(thermal_zone_device_enable);

Other exports in thermal/ use EXPORT_SYMBOL_GPL.

> +
> +int thermal_zone_device_disable(struct thermal_zone_device *tz)
> +{
> +	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_DISABLED);
> +}
> +EXPORT_SYMBOL(thermal_zone_device_disable);
> +
> +int thermal_zone_device_is_enabled(struct thermal_zone_device *tz)
> +{
> +	enum thermal_device_mode mode;
> +
> +	mutex_lock(&tz->lock);
> +
> +	mode = tz->mode;
> +
> +	mutex_unlock(&tz->lock);
> +
> +	return mode == THERMAL_DEVICE_ENABLED;
> +}
> +EXPORT_SYMBOL(thermal_zone_device_is_enabled);
> +
>  void thermal_zone_device_update(struct thermal_zone_device *tz,
>  				enum thermal_notify_event event)
>  {
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index a808f6fa2777..df013c39ba9b 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -416,6 +416,9 @@ int thermal_zone_get_offset(struct thermal_zone_device *tz);
>  
>  void thermal_cdev_update(struct thermal_cooling_device *);
>  void thermal_notify_framework(struct thermal_zone_device *, int);
> +int thermal_zone_device_enable(struct thermal_zone_device *tz);
> +int thermal_zone_device_disable(struct thermal_zone_device *tz);
> +int thermal_zone_device_is_enabled(struct thermal_zone_device *tz);
>  #else
>  static inline struct thermal_zone_device *thermal_zone_device_register(
>  	const char *type, int trips, int mask, void *devdata,
> @@ -463,6 +466,16 @@ static inline void thermal_cdev_update(struct thermal_cooling_device *cdev)
>  static inline void thermal_notify_framework(struct thermal_zone_device *tz,
>  	int trip)
>  { }
> +
> +static inline int thermal_zone_device_enable(struct thermal_zone_device *tz)
> +{ return -ENODEV; }
> +
> +static inline int thermal_zone_device_disable(struct thermal_zone_device *tz)
> +{ return -ENODEV; }
> +
> +static inline int
> +thermal_zone_device_is_enabled(struct thermal_zone_device *tz)
> +{ return -ENODEV; }
>  #endif /* CONFIG_THERMAL */
>  
>  #endif /* __THERMAL_H__ */
