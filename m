Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B461A52A746
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350630AbiEQPoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350495AbiEQPof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:44:35 -0400
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDA1517C3;
        Tue, 17 May 2022 08:42:54 -0700 (PDT)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2fefb051547so63696677b3.5;
        Tue, 17 May 2022 08:42:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ih99ClvoAeqjGYS9QU/k2msQKrRE+HtIf5pCOCjsnKg=;
        b=S6HykbWBR44YSkt63OB0vtxiaDCWfdeP5wg0lwRiIuqjr3bX/MR6hXjUdJsPdybzyY
         219k87DDTBACyKpPjkOmwBZv8Wq1wKm4mrcRxgdvjNLplnJDK+Q35XX3p/nMQ6MG6QmN
         zMU9D++gs0erEkMI2dUC8qThSxsAIwU/nthfg51LQJCRQZziwtL8eFRFkR7PWo/mPQWn
         qkzWIjE9tXBuu0bk9shZKBkZifbZWKCuqsEkt9HKeascLL3DhHuW4kAG6zFi7UzUCGxJ
         Q2I7EY1JdbTXXFCUNrkUU3Wy4zq0SjjL7ZoX89LNl9/VdDGm3HNYxSz5lS/VB/E6LIDx
         CxMA==
X-Gm-Message-State: AOAM531QS6lz5g4SwRl6gUYKS0bokiVh299knPqAEMhHxvPIMf0eoBCp
        MdfjZqWjQBTh66K7+WOdOtKyDzvRi8Mi+Kc5B2Q=
X-Google-Smtp-Source: ABdhPJw+IFfD9QLRka+RlaDlPyTO9zp9vrwr4b9R/6wrJEYajaNeGitZUWVkuCAg7gGsuxWz7+CRNZCCFawuylcycrc=
X-Received: by 2002:a81:91d4:0:b0:2fe:e300:3581 with SMTP id
 i203-20020a8191d4000000b002fee3003581mr14868030ywg.7.1652802159726; Tue, 17
 May 2022 08:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220507125443.2766939-1-daniel.lezcano@linexp.org> <20220507125443.2766939-2-daniel.lezcano@linexp.org>
In-Reply-To: <20220507125443.2766939-2-daniel.lezcano@linexp.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 17 May 2022 17:42:28 +0200
Message-ID: <CAJZ5v0ik_JQ4Awtw7iR68W4-9ZL8FRDsDd-kWmL-n09fgg3reg@mail.gmail.com>
Subject: Re: [PATCH v2 01/14] thermal/core: Change thermal_zone_ops to thermal_sensor_ops
To:     Daniel Lezcano <daniel.lezcano@linexp.org>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Len Brown <lenb@kernel.org>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Peter Kaestle <peter@piie.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Antoine Tenart <atenart@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:ACPI THERMAL DRIVER" <linux-acpi@vger.kernel.org>,
        "open list:CXGB4 ETHERNET DRIVER (CXGB4)" <netdev@vger.kernel.org>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)" 
        <linux-wireless@vger.kernel.org>,
        "open list:ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER" 
        <platform-driver-x86@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:RENESAS R-CAR THERMAL DRIVERS" 
        <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 7, 2022 at 2:55 PM Daniel Lezcano <daniel.lezcano@linexp.org> wrote:
>
> A thermal zone is software abstraction of a sensor associated with
> properties and cooling devices if any.
>
> The fact that we have thermal_zone and thermal_zone_ops mixed is
> confusing and does not clearly identify the different components
> entering in the thermal management process. A thermal zone appears to
> be a sensor while it is not.

Well, the majority of the operations in thermal_zone_ops don't apply
to thermal sensors.  For example, ->set_trips(), ->get_trip_type(),
->get_trip_temp().

> In order to set the scene for multiple thermal sensors aggregated into
> a single thermal zone. Rename the thermal_zone_ops to
> thermal_sensor_ops, that will appear clearyl the thermal zone is not a
> sensor but an abstraction of one [or multiple] sensor(s).

So I'm not convinced that the renaming mentioned above is particularly
clean either.

IMV the way to go would be to split the thermal sensor operations,
like ->get_temp(), out of thermal_zone_ops.

But then it is not clear what a thermal zone with multiple sensors in
it really means.  I guess it would require an aggregation function to
combine the thermal sensors in it that would produce an effective
temperature to check against the trip points.

Honestly, I don't think that setting a separate set of trips for each
sensor in a thermal zone would make a lot of sense.
