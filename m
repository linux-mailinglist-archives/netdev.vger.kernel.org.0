Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572055EE6F3
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 23:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiI1VBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 17:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiI1VBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 17:01:14 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A882D774
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:01:11 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id m4so7261428wrr.5
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=rzDboIf/0ZkplK5avMKmSlVoA8poTTgfjo85z32vUpw=;
        b=PXylRomthejoADML0IdWhQUGrmdli4X7Lz+BJkAfYAIG00MvIjUl3xr0rDM7Tp+c9E
         gERTEzX6OrmGxpSznrRYJVml/BbowAO721rEaCiF2ZRaNgXJ7o8FbpZQkgrjZXNIyM4T
         qZNAqp1UlAcp1VHjxAk6up9ZJhT0M9XaoYiwA8Lbv/DCcNKHW1lqBu7me6e6M0G5O9y5
         6elYYL8Br46BJy3ugJfzyt5TF6Kn3evoIrzIp8C3LQcSObibYdeDxG9YCabSAH16lf0w
         /qEmyrqU+YpieR9hy2GfcKRjUyNR5i8QsH8kAw0rn228woofdN32juEndUDd2mVi1Y5Y
         49XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=rzDboIf/0ZkplK5avMKmSlVoA8poTTgfjo85z32vUpw=;
        b=27dc8EQtHjGVVwwfvmUoqsu6QhfHcBqPjLxDMZUv0QYxk/q77DOM90VR7bnz5poeMc
         xHHSSkucXnEDdVkSOcG8IeIdc8l5tEdVyFfKjQtOmkke0046Okh2XxrhqNt0u+ePb2u8
         qPFM1QubVAQ+2icc7e9tGisnRQviQlwxvoAm9pc+3yXSRHeEP1HKnTJAzbpTbjUbGJ79
         iqpPl5lgAbIKTaU4450nPTBIcqHRzZSVJYSNxJYu0UTZH4gDi0qapNuhtJhUpskHbLV4
         HMCex+Dz2VddYZIVFHBXz2hwwEadczqS0ebCLvmpWB9zafqSMv9dUzJNMUuy8Mml/4eY
         Hsmg==
X-Gm-Message-State: ACrzQf37ElF6d4Aaqhomcp+Cniox4fi3zJXOMu9xkG7yuUIDB10vuBww
        RJhcOjsCWcrfOhyJQPH8fQ6v3Q==
X-Google-Smtp-Source: AMsMyM7phNWIVsHp55ggg5BnRcj1C06uD07FaHc0YVPmQtKh3wHiewzaoFstiqc0jphNe/Zmeu6ZVg==
X-Received: by 2002:a05:6000:1881:b0:22c:bee7:96e with SMTP id a1-20020a056000188100b0022cbee7096emr6855462wri.418.1664398869586;
        Wed, 28 Sep 2022 14:01:09 -0700 (PDT)
Received: from mai.. ([2a05:6e02:1041:c10:48a2:39eb:9d1b:8b8d])
        by smtp.gmail.com with ESMTPSA id g20-20020a05600c4ed400b003b4931eb435sm2874300wmq.26.2022.09.28.14.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 14:01:09 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org, rafael@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        rui.zhang@intel.com, Raju Rangoju <rajur@chelsio.com>,
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
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
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
Subject: [PATCH v7 00/29] Rework the trip points creation
Date:   Wed, 28 Sep 2022 23:00:30 +0200
Message-Id: <20220928210059.891387-1-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This work is the pre-requisite of handling correctly when the trip
point are crossed. For that we need to rework how the trip points are
declared and assigned to a thermal zone.

Even if it appears to be a common sense to have the trip points being
ordered, this no guarantee neither documentation telling that is the
case.

One solution could have been to create an ordered array of trips built
when registering the thermal zone by calling the different get_trip*
ops. However those ops receive a thermal zone pointer which is not
known as it is in the process of creating it.

This cyclic dependency shows we have to rework how we manage the trip
points.

Actually, all the trip points definition can be common to the backend
sensor drivers and we can factor out the thermal trip structure in all
of them.

Then, as we register the thermal trips array, they will be available
in the thermal zone structure and a core function can return the trip
given its id.

The get_trip_* ops won't be needed anymore and could be removed. The
resulting code will be another step forward to a self encapsulated
generic thermal framework.

Most of the drivers can be converted more or less easily. This series
does a first round with most of the drivers. Some remain and will be
converted but with a smaller set of changes as the conversion is a bit
more complex.

Changelog:
 v7:
    - Added missing return 0 in the x86_pkg_temp driver
 v6:
    - Improved the code for the get_crit_temp() function as suggested by Rafael
    - Removed inner parenthesis in the set_trip_temp() function and invert the
      conditions. Check the type of the trip point is unchanged
    - Folded patch 4 with 1
    - Add per thermal zone info message in the bang-bang governor
    - Folded the fix for an uninitialized variable in int340x_thermal_zone_add()
 v5:
    - Fixed a deadlock when calling thermal_zone_get_trip() while
      handling the thermal zone lock
    - Remove an extra line in the sysfs change
    - Collected tags
v4:
   - Remove extra lines on exynos changes as reported by Krzysztof Kozlowski
   - Collected tags
 v3:
   - Reorg the series to be git-bisect safe
   - Added the set_trip generic function
   - Added the get_crit_temp generic function
   - Removed more dead code in the thermal-of
   - Fixed the exynos changelog
   - Fixed the error check for the exynos drivers
   - Collected tags
 v2:
   - Added missing EXPORT_SYMBOL_GPL() for thermal_zone_get_trip()
   - Removed tab whitespace in the acerhdf driver
   - Collected tags

Cc: Raju Rangoju <rajur@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Peter Kaestle <peter@piie.net>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Gross <markgross@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Amit Kucheria <amitk@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Nicolas Saenz Julienne <nsaenz@kernel.org>
Cc: Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Ray Jui <rjui@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Support Opensource <support.opensource@diasemi.com>
Cc: Lukasz Luba <lukasz.luba@arm.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: "Niklas Söderlund" <niklas.soderlund@ragnatech.se>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Dmitry Osipenko <digetx@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: linux-omap@vger.kernel.org

Daniel Lezcano (29):
  thermal/core: Add a generic thermal_zone_get_trip() function
  thermal/sysfs: Always expose hysteresis attributes
  thermal/core: Add a generic thermal_zone_set_trip() function
  thermal/core/governors: Use thermal_zone_get_trip() instead of ops
    functions
  thermal/of: Use generic thermal_zone_get_trip() function
  thermal/of: Remove unused functions
  thermal/drivers/exynos: Use generic thermal_zone_get_trip() function
  thermal/drivers/exynos: of_thermal_get_ntrips()
  thermal/drivers/exynos: Replace of_thermal_is_trip_valid() by
    thermal_zone_get_trip()
  thermal/drivers/tegra: Use generic thermal_zone_get_trip() function
  thermal/drivers/uniphier: Use generic thermal_zone_get_trip() function
  thermal/drivers/hisi: Use generic thermal_zone_get_trip() function
  thermal/drivers/qcom: Use generic thermal_zone_get_trip() function
  thermal/drivers/armada: Use generic thermal_zone_get_trip() function
  thermal/drivers/rcar_gen3: Use the generic function to get the number
    of trips
  thermal/of: Remove of_thermal_get_ntrips()
  thermal/of: Remove of_thermal_is_trip_valid()
  thermal/of: Remove of_thermal_set_trip_hyst()
  thermal/of: Remove of_thermal_get_crit_temp()
  thermal/drivers/st: Use generic trip points
  thermal/drivers/imx: Use generic thermal_zone_get_trip() function
  thermal/drivers/rcar: Use generic thermal_zone_get_trip() function
  thermal/drivers/broadcom: Use generic thermal_zone_get_trip() function
  thermal/drivers/da9062: Use generic thermal_zone_get_trip() function
  thermal/drivers/ti: Remove unused macros ti_thermal_get_trip_value() /
    ti_thermal_trip_is_valid()
  thermal/drivers/acerhdf: Use generic thermal_zone_get_trip() function
  thermal/drivers/cxgb4: Use generic thermal_zone_get_trip() function
  thermal/intel/int340x: Replace parameter to simplify
  thermal/drivers/intel: Use generic thermal_zone_get_trip() function

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   2 -
 .../ethernet/chelsio/cxgb4/cxgb4_thermal.c    |  41 +----
 drivers/platform/x86/acerhdf.c                |  73 +++-----
 drivers/thermal/armada_thermal.c              |  39 ++---
 drivers/thermal/broadcom/bcm2835_thermal.c    |   8 +-
 drivers/thermal/da9062-thermal.c              |  52 +-----
 drivers/thermal/gov_bang_bang.c               |  39 +++--
 drivers/thermal/gov_fair_share.c              |  18 +-
 drivers/thermal/gov_power_allocator.c         |  51 +++---
 drivers/thermal/gov_step_wise.c               |  22 ++-
 drivers/thermal/hisi_thermal.c                |  11 +-
 drivers/thermal/imx_thermal.c                 |  72 +++-----
 .../int340x_thermal/int340x_thermal_zone.c    |  33 ++--
 .../int340x_thermal/int340x_thermal_zone.h    |   4 +-
 .../processor_thermal_device.c                |  10 +-
 drivers/thermal/intel/x86_pkg_temp_thermal.c  | 120 +++++++------
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c   |  39 ++---
 drivers/thermal/rcar_gen3_thermal.c           |   2 +-
 drivers/thermal/rcar_thermal.c                |  53 +-----
 drivers/thermal/samsung/exynos_tmu.c          |  57 +++----
 drivers/thermal/st/st_thermal.c               |  47 +----
 drivers/thermal/tegra/soctherm.c              |  33 ++--
 drivers/thermal/tegra/tegra30-tsensor.c       |  17 +-
 drivers/thermal/thermal_core.c                | 161 +++++++++++++++---
 drivers/thermal/thermal_core.h                |  24 +--
 drivers/thermal/thermal_helpers.c             |  28 +--
 drivers/thermal/thermal_netlink.c             |  21 +--
 drivers/thermal/thermal_of.c                  | 116 -------------
 drivers/thermal/thermal_sysfs.c               | 133 +++++----------
 drivers/thermal/ti-soc-thermal/ti-thermal.h   |  15 --
 drivers/thermal/uniphier_thermal.c            |  27 ++-
 include/linux/thermal.h                       |  10 ++
 32 files changed, 560 insertions(+), 818 deletions(-)

-- 
2.34.1

