Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43A758AC9B
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 16:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240977AbiHEO5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 10:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238489AbiHEO5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 10:57:46 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640CE4D807
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 07:57:44 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id p8-20020a05600c05c800b003a50311d75cso3608649wmd.4
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 07:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=o4qJMXGfl1V64TlbGvBfcm+LN8g9SJYD1xysElPFV+w=;
        b=eZBBQdzncTXK3CK4MNTJG2M8VMM9rVBloXv1jN1nCd/+1qkQTnhO/efbCMPGsHhhR+
         LkPnBwv6SEuDRRqbP4CWHuoWPe0LYtlwAYHYzu7nLu2RQ9eNKs31G4BO00vnBeVluRHm
         F6lVr3xKzO4OJNDhthOsWntpeK8XfnlCsYPqlu1GNRnUqZRmjQMxSMITM3i8NmDgkJiw
         N9jyAaTL78pezdHS7VG3xL+31qb/AMCztVGDnaoGR20Pd9fOLaGgv6/4Bb9YfWYQaAXU
         hMshzCDOxdv7JGUkwANk9lJ+Ptm+ejVa54gcxN8sJptA+2GYUfqVUuglLeC1A/aFJV8i
         ttqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=o4qJMXGfl1V64TlbGvBfcm+LN8g9SJYD1xysElPFV+w=;
        b=kSfEau5Mi6SJDD8BBYUUI0Q1LVFVa5LcMLG4zDvDYx64kjaL8HKTMEHgqa/FeYRmFu
         XrxDcrXYbzCqMhUksDuZJpZfuAwL++2RdE+sbFwxA5LCYd7t9Le6PIWc1B+mj6OmbrPU
         uyUjt7fdtS6O1jvi6s5naEwaV0pv9whShRdI+7ST1xlYbUcyh9C3/086OATqpksdntPl
         7od3au8wJJnWF9xZRyoDGHpOprg8dPBQQZd5nQWIpcEnP7QyoV4nrQJ84qGDGVxXOJLO
         h7IU83DOeu+vbhxS/Ii2BvyeVckMzbjTmnqzlWLP3QxGn9QUMoWkd2Bur4Evc6z9TQlL
         6gSg==
X-Gm-Message-State: ACgBeo0XjLukNnEldfBNQDjOOMGwCMNhSRaymOuF9CShd8sNjzyzsxkz
        UBDwxF2NjQSAYmiiZ7a04NNWOA==
X-Google-Smtp-Source: AA6agR5vgKZ1scONDwjrANviaKFae/NRN/p3900F4LwCunVN/wiI0liT70nfxxj9L1NFTeuSjjFQYQ==
X-Received: by 2002:a7b:c3c6:0:b0:3a3:2065:e022 with SMTP id t6-20020a7bc3c6000000b003a32065e022mr5079223wmj.117.1659711462808;
        Fri, 05 Aug 2022 07:57:42 -0700 (PDT)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:aef0:8606:da6b:79ef])
        by smtp.gmail.com with ESMTPSA id y1-20020adfd081000000b0022159d92004sm3102448wrh.82.2022.08.05.07.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 07:57:42 -0700 (PDT)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     daniel.lezcano@linaro.org, rafael@kernel.org
Cc:     rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
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
Subject: [PATCH v1 00/26] Rework the trip points creation
Date:   Fri,  5 Aug 2022 16:57:03 +0200
Message-Id: <20220805145729.2491611-1-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Daniel Lezcano (26):
  thermal/core: encapsulate ops->get_trip_* ops into a function
  thermal/sysfs: Do not make get_trip_hyst optional
  thermal/core/governors: Use thermal_zone_get_trip() instead of ops
    functions
  thermal/drivers/st: Use generic trip points
  thermal/drivers/tegra: Use generic thermal_zone_get_trip() function
  thermal/drivers/imx: Use generic thermal_zone_get_trip() function
  thermal/drivers/exynos: Use generic thermal_zone_get_trip() function
  thermal/drivers/rcar: Use generic thermal_zone_get_trip() function
  thermal/drivers/uniphier: Use generic thermal_zone_get_trip() function
  thermal/drivers/hisi: Use generic thermal_zone_get_trip() function
  thermal/drivers/qcom: Use generic thermal_zone_get_trip() function
  thermal/drivers/OF: Use generic thermal_zone_get_trip() function
  thermal/drivers/armada: Use generic thermal_zone_get_trip() function
  thermal/core/OF: Remove unused functions
  thermal/drivers/rcar_gen3: Use the generic function to get the number
    of trips
  thermal/drivers/exynos: of_thermal_get_ntrips()
  thermal/core/of: Remove of_thermal_get_ntrips()
  thermal/drivers/exynos: Replace of_thermal_is_trip_valid() by
    thermal_zone_get_trip()
  thermal/core/of: Remove of_thermal_is_trip_valid()
  thermal/drivers/broadcom: Use generic thermal_zone_get_trip() function
  thermal/drivers/da9062: Use generic thermal_zone_get_trip() function
  thermal/drivers/ti: Remove unused macros ti_thermal_get_trip_value() /
    ti_thermal_trip_is_valid()
  thermal/drivers/acerhdf: Use generic thermal_zone_get_trip() function
  thermal/drivers/cxgb4: Use generic thermal_zone_get_trip() function
  thermal/intel/int340x: Replace parameter to simplify
  thermal/drivers/intel: Use generic thermal_zone_get_trip() function

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   2 -
 .../ethernet/chelsio/cxgb4/cxgb4_thermal.c    |  41 ++----
 drivers/platform/x86/acerhdf.c                |  73 ++++-------
 drivers/thermal/armada_thermal.c              |  39 +++---
 drivers/thermal/broadcom/bcm2835_thermal.c    |   8 +-
 drivers/thermal/da9062-thermal.c              |  52 ++------
 drivers/thermal/gov_bang_bang.c               |  23 ++--
 drivers/thermal/gov_fair_share.c              |  18 +--
 drivers/thermal/gov_power_allocator.c         |  51 ++++----
 drivers/thermal/gov_step_wise.c               |  22 ++--
 drivers/thermal/hisi_thermal.c                |  11 +-
 drivers/thermal/imx_thermal.c                 |  72 ++++-------
 .../int340x_thermal/int340x_thermal_zone.c    |  31 ++---
 .../int340x_thermal/int340x_thermal_zone.h    |   4 +-
 .../processor_thermal_device.c                |  10 +-
 drivers/thermal/intel/x86_pkg_temp_thermal.c  | 120 ++++++++++--------
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c   |  39 +++---
 drivers/thermal/rcar_gen3_thermal.c           |   2 +-
 drivers/thermal/rcar_thermal.c                |  49 +------
 drivers/thermal/samsung/exynos_tmu.c          |  60 ++++-----
 drivers/thermal/st/st_thermal.c               |  47 +------
 drivers/thermal/tegra/soctherm.c              |  33 ++---
 drivers/thermal/tegra/tegra30-tsensor.c       |  17 ++-
 drivers/thermal/thermal_core.c                |  68 ++++++----
 drivers/thermal/thermal_core.h                |  30 ++---
 drivers/thermal/thermal_helpers.c             |  28 ++--
 drivers/thermal/thermal_netlink.c             |  21 ++-
 drivers/thermal/thermal_of.c                  |  88 -------------
 drivers/thermal/thermal_sysfs.c               |  91 +++++--------
 drivers/thermal/ti-soc-thermal/ti-thermal.h   |  15 ---
 drivers/thermal/uniphier_thermal.c            |  26 ++--
 31 files changed, 434 insertions(+), 757 deletions(-)

-- 
2.25.1

