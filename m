Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4896D5F10D3
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbiI3R2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbiI3R1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:27:46 -0400
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5406D120860;
        Fri, 30 Sep 2022 10:27:45 -0700 (PDT)
Received: by mail-qv1-f47.google.com with SMTP id jy22so2666977qvb.4;
        Fri, 30 Sep 2022 10:27:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=i5RR2mIhCd7B8XXmK/TsyP8TyBQJcYl7/B6Q6gA7Pyc=;
        b=ycNc3xqcKFr/j23BLR0uHWY5WpL5PqHulqhE/Vb6iOachwii2IRGVPwfTkLXGOEGMa
         8TV+SM3iHkArpb41+GFiHvoKCMtOxRkr8DstVrDqoR9UexLOvPMUEt05mCluTVBFbvpK
         1YgrfA8Us/8cHnotIO9WpoNEpIiQ6alq2QkPWYbG7+QnU9XbMZvnvAjOZnYc/eAel+AM
         FmcWduklg6/UQhol9TX2aBaZU8aan5fiJYmvtR8oMeVVVnvLEfPn6Hyd8EIEq8uoa3do
         AlUW5I9JKWgg2Tu+g0zS01Z0qAVyk4TTjO/8Op+pJbqZ3HMWlGkE+idDIk+RvRn6XAOv
         t+qA==
X-Gm-Message-State: ACrzQf3T3dxdhNsrbaNpSPKXaIGgMsxJvLmoNWbsm99F5X3ucfX8VFwP
        51NSYg9TLaER3gR16gW4mCqMPZAbwK2PtbauQPk=
X-Google-Smtp-Source: AMsMyM4EZXtb3Jx090trboU3bAGyU4ukeUO73mjqvxjy3bE5rff7w8VBEyzGCYt6MyIZiIZ7WQ8twW510nGFyTdqv5I=
X-Received: by 2002:ad4:4ea3:0:b0:4af:646a:9787 with SMTP id
 ed3-20020ad44ea3000000b004af646a9787mr7672861qvb.15.1664558863545; Fri, 30
 Sep 2022 10:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220928210059.891387-1-daniel.lezcano@linaro.org> <20220928210059.891387-4-daniel.lezcano@linaro.org>
In-Reply-To: <20220928210059.891387-4-daniel.lezcano@linaro.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 30 Sep 2022 19:27:32 +0200
Message-ID: <CAJZ5v0juBfjuGDHy1Y3PP0M=mYuXyL5YwGpKi9Zrvrwr6bv8-g@mail.gmail.com>
Subject: Re: [PATCH v7 03/29] thermal/core: Add a generic thermal_zone_set_trip()
 function
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
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
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
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
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 11:01 PM Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
>
> The thermal zone ops defines a set_trip callback where we can invoke
> the backend driver to set an interrupt for the next trip point
> temperature being crossed the way up or down, or setting the low level
> with the hysteresis.
>
> The ops is only called from the thermal sysfs code where the userspace
> has the ability to modify a trip point characteristic.
>
> With the effort of encapsulating the thermal framework core code,
> let's create a thermal_zone_set_trip() which is the writable side of
> the thermal_zone_get_trip() and put there all the ops encapsulation.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  drivers/thermal/thermal_core.c  | 47 +++++++++++++++++++++++++++++
>  drivers/thermal/thermal_sysfs.c | 52 +++++++++++----------------------
>  include/linux/thermal.h         |  3 ++
>  3 files changed, 67 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 16ef91dc102f..2675671781cd 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1211,6 +1211,53 @@ int thermal_zone_get_trip(struct thermal_zone_device *tz, int trip_id,
>  }
>  EXPORT_SYMBOL_GPL(thermal_zone_get_trip);
>
> +int thermal_zone_set_trip(struct thermal_zone_device *tz, int trip_id,
> +                         const struct thermal_trip *trip)
> +{
> +       struct thermal_trip t;
> +       int ret = -EINVAL;
> +
> +       mutex_lock(&tz->lock);
> +
> +       if (!tz->ops->set_trip_temp && !tz->ops->set_trip_hyst && !tz->trips)
> +               goto out;
> +
> +       ret = __thermal_zone_get_trip(tz, trip_id, &t);
> +       if (ret)
> +               goto out;
> +
> +       if (t.type != trip->type) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +       if (t.temperature != trip->temperature && tz->ops->set_trip_temp) {
> +               ret = tz->ops->set_trip_temp(tz, trip_id, trip->temperature);
> +               if (ret)
> +                       goto out;
> +       }
> +
> +       if (t.hysteresis != trip->hysteresis && tz->ops->set_trip_hyst) {
> +               ret = tz->ops->set_trip_hyst(tz, trip_id, trip->hysteresis);
> +               if (ret)
> +                       goto out;
> +       }
> +
> +       if (tz->trips && ((t.temperature != trip->temperature) ||
> +                         (t.hysteresis != trip->hysteresis)))

if (tz->trips && (t.temperature != trip->temperature || t.hysteresis
!= trip->hysteresis))

pretty please, and I don't think that it is necessary to break this line.

> +               tz->trips[trip_id] = *trip;
> +out:
> +       mutex_unlock(&tz->lock);
> +
> +       if (!ret) {
> +               thermal_notify_tz_trip_change(tz->id, trip_id, trip->type,
> +                                             trip->temperature, trip->hysteresis);
> +               thermal_zone_device_update(tz, THERMAL_TRIP_CHANGED);
> +       }
> +
> +       return ret;
> +}
> +
>  /**
>   * thermal_zone_device_register_with_trips() - register a new thermal zone device
>   * @type:      the thermal zone device type
> diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
> index 6c45194aaabb..8d7b25ab67c2 100644
> --- a/drivers/thermal/thermal_sysfs.c
> +++ b/drivers/thermal/thermal_sysfs.c
> @@ -115,32 +115,19 @@ trip_point_temp_store(struct device *dev, struct device_attribute *attr,
>         struct thermal_trip trip;
>         int trip_id, ret;
>
> -       if (!tz->ops->set_trip_temp && !tz->trips)
> -               return -EPERM;
> -
>         if (sscanf(attr->attr.name, "trip_point_%d_temp", &trip_id) != 1)
>                 return -EINVAL;
>
> -       if (kstrtoint(buf, 10, &trip.temperature))
> -               return -EINVAL;
> -
> -       if (tz->ops->set_trip_temp) {
> -               ret = tz->ops->set_trip_temp(tz, trip_id, trip.temperature);
> -               if (ret)
> -                       return ret;
> -       }
> -
> -       if (tz->trips)
> -               tz->trips[trip_id].temperature = trip.temperature;
> -
>         ret = thermal_zone_get_trip(tz, trip_id, &trip);
>         if (ret)
>                 return ret;
>
> -       thermal_notify_tz_trip_change(tz->id, trip_id, trip.type,
> -                                     trip.temperature, trip.hysteresis);
> +       if (kstrtoint(buf, 10, &trip.temperature))
> +               return -EINVAL;
>
> -       thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
> +       ret = thermal_zone_set_trip(tz, trip_id, &trip);
> +       if (ret)
> +               return ret;
>
>         return count;
>  }
> @@ -168,29 +155,24 @@ trip_point_hyst_store(struct device *dev, struct device_attribute *attr,
>                       const char *buf, size_t count)
>  {
>         struct thermal_zone_device *tz = to_thermal_zone(dev);
> -       int trip, ret;
> -       int temperature;
> -
> -       if (!tz->ops->set_trip_hyst)
> -               return -EPERM;
> +       struct thermal_trip trip;
> +       int trip_id, ret;
>
> -       if (sscanf(attr->attr.name, "trip_point_%d_hyst", &trip) != 1)
> +       if (sscanf(attr->attr.name, "trip_point_%d_hyst", &trip_id) != 1)
>                 return -EINVAL;
>
> -       if (kstrtoint(buf, 10, &temperature))
> -               return -EINVAL;
> +       ret = thermal_zone_get_trip(tz, trip_id, &trip);
> +       if (ret)
> +               return ret;
>
> -       /*
> -        * We are not doing any check on the 'temperature' value
> -        * here. The driver implementing 'set_trip_hyst' has to
> -        * take care of this.
> -        */
> -       ret = tz->ops->set_trip_hyst(tz, trip, temperature);
> +       if (kstrtoint(buf, 10, &trip.hysteresis))
> +               return -EINVAL;
>
> -       if (!ret)
> -               thermal_zone_set_trips(tz);
> +       ret = thermal_zone_set_trip(tz, trip_id, &trip);
> +       if (ret)
> +               return ret;
>
> -       return ret ? ret : count;
> +       return count;
>  }
>
>  static ssize_t
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index feb8b61df746..66373f872237 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -338,6 +338,9 @@ static inline void devm_thermal_of_zone_unregister(struct device *dev,
>  int thermal_zone_get_trip(struct thermal_zone_device *tz, int trip_id,
>                           struct thermal_trip *trip);
>
> +int thermal_zone_set_trip(struct thermal_zone_device *tz, int trip_id,
> +                         const struct thermal_trip *trip);
> +
>  int thermal_zone_get_num_trips(struct thermal_zone_device *tz);
>
>  int thermal_zone_get_crit_temp(struct thermal_zone_device *tz, int *temp);
> --
> 2.34.1
>
