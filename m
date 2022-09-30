Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E435F10B9
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiI3RXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiI3RXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:23:49 -0400
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DA22AE3C;
        Fri, 30 Sep 2022 10:23:49 -0700 (PDT)
Received: by mail-qk1-f182.google.com with SMTP id o7so3216849qkj.10;
        Fri, 30 Sep 2022 10:23:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ui8EFm5NTKuQbi8UWg/wBnjAdOfU+URgnKuB1M1rDDM=;
        b=w4EnO4r4IQckU9lGGnuZhF1zUh7or7R+9MTyiJpvRoKNfIrrD5VZqy+m6E/KrMsXG5
         MuJ1mSmjZbN5O3cGwJPMDx1Izf1HV3APJS4xzvU3V71+7T9bBg2+4hjvIUrmIbDD7NWE
         ppeYO440zZ1JOpcjl+D7gwZK7eAQk7Ad+fT8q1GeWOSHT+LP02gn7iq+KqYkM4RfFCy3
         q0YkluS7gLB/7kszvGFu3K/zeHPXyI4GZ4wYjrZNLD4VH071IIUo7prbo3L6iWi4R39d
         a+jzZOLGLM3IzhCdFIj7WIqq9ib82XQSC+nFuEdnBm4TWU0wH2sPfOf5RSZFIYbBVD/W
         LKRQ==
X-Gm-Message-State: ACrzQf1S+e5fjQs79fK+jz8yugZP7AGAoHKcW+nP5UMHaww0OTqdlsoP
        ltMulp/rpvkGVAbn0tYFPdZOAxg3hU76tL/Q+/Kq3FaQ9nuZoQ==
X-Google-Smtp-Source: AMsMyM6d/4T6yn81hjd6C4Vuw2vny1GJ9T6qtqKEGK7p+vvo211JPB9N/rVkz+xkaJuvCSyUERGtjZg30uA1SNdml5I=
X-Received: by 2002:a05:620a:290d:b0:6b6:1a92:d88a with SMTP id
 m13-20020a05620a290d00b006b61a92d88amr6994486qkp.58.1664558627730; Fri, 30
 Sep 2022 10:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220928210059.891387-1-daniel.lezcano@linaro.org> <20220928210059.891387-3-daniel.lezcano@linaro.org>
In-Reply-To: <20220928210059.891387-3-daniel.lezcano@linaro.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 30 Sep 2022 19:23:36 +0200
Message-ID: <CAJZ5v0iyD-6OM1V3oUXbLL2gT5XjD-N8TOfWQTK+P4MN25RcMQ@mail.gmail.com>
Subject: Re: [PATCH v7 02/29] thermal/sysfs: Always expose hysteresis attributes
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
> Instead of avoiding to expose the hysteresis attributes of a thermal
> zone when its get_trip_hyst() operation is not defined, which is
> confusing, expose them always and use the default
> thermal_zone_get_trip() function returning 0 hysteresis when that
> operation is not present.
>
> The hysteresis of 0 is perfectly valid, so this change should not
> introduce any backwards compatibility issues.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/thermal/thermal_sysfs.c | 25 +++++++++----------------
>  1 file changed, 9 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
> index d093d7aa64c6..6c45194aaabb 100644
> --- a/drivers/thermal/thermal_sysfs.c
> +++ b/drivers/thermal/thermal_sysfs.c
> @@ -426,23 +426,20 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
>                 return -ENOMEM;
>         }
>
> -       if (tz->ops->get_trip_hyst) {
> -               tz->trip_hyst_attrs = kcalloc(tz->num_trips,
> -                                             sizeof(*tz->trip_hyst_attrs),
> -                                             GFP_KERNEL);
> -               if (!tz->trip_hyst_attrs) {
> -                       kfree(tz->trip_type_attrs);
> -                       kfree(tz->trip_temp_attrs);
> -                       return -ENOMEM;
> -               }
> +       tz->trip_hyst_attrs = kcalloc(tz->num_trips,
> +                                     sizeof(*tz->trip_hyst_attrs),
> +                                     GFP_KERNEL);
> +       if (!tz->trip_hyst_attrs) {
> +               kfree(tz->trip_type_attrs);
> +               kfree(tz->trip_temp_attrs);
> +               return -ENOMEM;
>         }
>
>         attrs = kcalloc(tz->num_trips * 3 + 1, sizeof(*attrs), GFP_KERNEL);
>         if (!attrs) {
>                 kfree(tz->trip_type_attrs);
>                 kfree(tz->trip_temp_attrs);
> -               if (tz->ops->get_trip_hyst)
> -                       kfree(tz->trip_hyst_attrs);
> +               kfree(tz->trip_hyst_attrs);
>                 return -ENOMEM;
>         }
>
> @@ -475,9 +472,6 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
>                 }
>                 attrs[indx + tz->num_trips] = &tz->trip_temp_attrs[indx].attr.attr;
>
> -               /* create Optional trip hyst attribute */
> -               if (!tz->ops->get_trip_hyst)
> -                       continue;
>                 snprintf(tz->trip_hyst_attrs[indx].name, THERMAL_NAME_LENGTH,
>                          "trip_point_%d_hyst", indx);
>
> @@ -514,8 +508,7 @@ static void destroy_trip_attrs(struct thermal_zone_device *tz)
>
>         kfree(tz->trip_type_attrs);
>         kfree(tz->trip_temp_attrs);
> -       if (tz->ops->get_trip_hyst)
> -               kfree(tz->trip_hyst_attrs);
> +       kfree(tz->trip_hyst_attrs);
>         kfree(tz->trips_attribute_group.attrs);
>  }
>
> --
> 2.34.1
>
