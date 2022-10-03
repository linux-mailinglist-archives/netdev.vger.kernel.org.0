Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615835F2FE8
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 13:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiJCL4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 07:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJCL43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 07:56:29 -0400
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C30D4F1A5;
        Mon,  3 Oct 2022 04:56:28 -0700 (PDT)
Received: by mail-qk1-f175.google.com with SMTP id k12so6355263qkj.8;
        Mon, 03 Oct 2022 04:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WitNOf6WBeNmu77lsn7kACwTyf0tIcs7nBCxwgdcQsc=;
        b=JblJdVZJHNu6dAYBd986ggG1XshqKu8jN1X+Qn2hlyLhPN2gS8TNzbZtbaNFNjDzcv
         EtLliRJuX+F7coOo30/Gz1iuALGngevAgNUuNAdIrSBVGTEGui87K3UYIuA5e2whJoIo
         YZoRVWjGSJOtVqpV5mRuv9PNPkJLGaTLhvbrib9u1xEtS1bqGI1aDIQiANXk0yHOOQds
         kdnD2elzyBnFlY4ioj2Li2n4un8Q3j/T0NjgDOoQlllUClVdsZ1AYsjafjrOr9iNftog
         1/1tdRWufXIiCzkPJjobiHrgAMieARYDijI6vz4NpU6xzCaN05JgRUMhN4/mBc6JyoWd
         7d8w==
X-Gm-Message-State: ACrzQf3kTj098frc7SX25UM5LpS63QIKdIflauM+RFYJY8QtL66c+tNx
        u0suCzAEHebQ8P8SeMhVxBcIf7YV0RuYjoZNdhY=
X-Google-Smtp-Source: AMsMyM6gK4Lpk9U29mVa1xe8BWRFfH9VFbqDWp91XeWepB1sC9vs6HtLeg7T4HHwhuWsguU1iWWGBGWooT36YUjNN0U=
X-Received: by 2002:a37:a907:0:b0:6cb:be29:ac72 with SMTP id
 s7-20020a37a907000000b006cbbe29ac72mr13323935qke.505.1664798187356; Mon, 03
 Oct 2022 04:56:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221003092602.1323944-1-daniel.lezcano@linaro.org> <20221003092602.1323944-4-daniel.lezcano@linaro.org>
In-Reply-To: <20221003092602.1323944-4-daniel.lezcano@linaro.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 3 Oct 2022 13:56:16 +0200
Message-ID: <CAJZ5v0jjHH1S=+i2i=TOERtgEmxFmm_SAJBXEwoJunQATH3pLQ@mail.gmail.com>
Subject: Re: [PATCH v8 03/29] thermal/core: Add a generic thermal_zone_set_trip()
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

On Mon, Oct 3, 2022 at 11:26 AM Daniel Lezcano
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

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  V8:
>    - pretty one line condition and parenthesis removal (Rafael J. Wysocki)
> ---
>  drivers/thermal/thermal_core.c  | 46 +++++++++++++++++++++++++++++
>  drivers/thermal/thermal_sysfs.c | 52 +++++++++++----------------------
>  include/linux/thermal.h         |  3 ++
>  3 files changed, 66 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 16ef91dc102f..3a9915824e67 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1211,6 +1211,52 @@ int thermal_zone_get_trip(struct thermal_zone_device *tz, int trip_id,
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
> +       if (tz->trips && (t.temperature != trip->temperature || t.hysteresis != trip->hysteresis))
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
