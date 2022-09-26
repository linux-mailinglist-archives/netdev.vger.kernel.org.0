Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762635EAA25
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 17:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbiIZPTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 11:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbiIZPSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 11:18:50 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEF6814E9
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 07:06:17 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t7so10367115wrm.10
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 07:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=eCLgw6DVFbSTGoI9qj9IIEXgogUtP4RUj12TjUJu8eM=;
        b=joDs8XqC+N66WNbkGMvZ5beINjS5duHHpB/xs4Y+w4HvaDH2pd9FSU1iElDBBUtIMy
         dXCobQuk+iW6gFXfmiqaX1puWddDPq6aU0SJcbdM8Snx4ouCX+TfN731fqvZuJ6GdZMP
         X87ZmzEemo7I6H6NIBEy+l/I6AFyiM0VQJ/JgBcfJHWD7628f9xMlaoy4ND9z6hHZxma
         DzQYpUli1RRkMOzoaOE0oPByvLibJQCdRl8c+EqURfR/4MXN62e+1CeokZjJ8k2bFo7h
         qOzZPSrOa6+FobbLZ6lYHJHKeAfr0s6vDv52RwgH5nPQn8PwZ5N7BeqVRekPZsynlydN
         OxKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=eCLgw6DVFbSTGoI9qj9IIEXgogUtP4RUj12TjUJu8eM=;
        b=koRWZs/IQz035bcQBHHj6CjOowxhglJZQEDCzHR9fLtqpl3lLpZD9uWJXdgyU7jDt1
         QUonPyubPnxZPaa9aFA0f1nD4jW+3PLzAw99SbkzEupPy038qVNi6Xmjne+d2AX6QqM3
         kS2jYLwYSenviVaZ1x23+eXJofr+FlEDuBSQKyvDEc56sLyVIS6yJLlk7mNHj5pgRZrn
         xQsPrVLVdtO2tVLhg//btQhxPSD03nKmaVihut0lmIcQDacR/BZA6ySH1wggGledlf7P
         qfx7m0vDVHRff7r5LzHmO9jjuuf8EnFI6T3PIWRsOKc3xCIqPuPfbsipQDoygFDJW9nS
         t/qA==
X-Gm-Message-State: ACrzQf01gbcNxZK+dSjxfWdRT1dNyE2CRYd1wZ2Tl9AKOIaaH5MDX1LI
        k2272nhRhlg0Wk60MOF+BG8X/Q==
X-Google-Smtp-Source: AMsMyM7d6uz2QOBhraN3AiBmiJKHPqc7TLo82asj6WdY62740LYHAGNd9QlC3F68f7LCOrhq7otlMQ==
X-Received: by 2002:a5d:6a07:0:b0:228:dba4:2138 with SMTP id m7-20020a5d6a07000000b00228dba42138mr13235530wru.346.1664201175053;
        Mon, 26 Sep 2022 07:06:15 -0700 (PDT)
Received: from mai.. (146725694.box.freepro.com. [130.180.211.218])
        by smtp.gmail.com with ESMTPSA id v3-20020adfebc3000000b0022adf321d22sm14310731wrn.92.2022.09.26.07.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 07:06:14 -0700 (PDT)
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
Subject: [PATCH v5 00/30] Rework the trip points creation
Date:   Mon, 26 Sep 2022 16:05:34 +0200
Message-Id: <20220926140604.4173723-1-daniel.lezcano@linaro.org>
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

Daniel Lezcano (30):
  thermal/core: Add a generic thermal_zone_get_trip() function
  thermal/sysfs: Do not make get_trip_hyst optional
  thermal/core: Add a generic thermal_zone_set_trip() function
  thermal/core: Add a generic thermal_zone_get_crit_temp() function
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
 drivers/thermal/gov_bang_bang.c               |  29 ++--
 drivers/thermal/gov_fair_share.c              |  18 +-
 drivers/thermal/gov_power_allocator.c         |  51 +++---
 drivers/thermal/gov_step_wise.c               |  22 ++-
 drivers/thermal/hisi_thermal.c                |  11 +-
 drivers/thermal/imx_thermal.c                 |  72 +++-----
 .../int340x_thermal/int340x_thermal_zone.c    |  31 ++--
 .../int340x_thermal/int340x_thermal_zone.h    |   4 +-
 .../processor_thermal_device.c                |  10 +-
 drivers/thermal/intel/x86_pkg_temp_thermal.c  | 120 +++++++------
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c   |  39 ++---
 drivers/thermal/rcar_gen3_thermal.c           |   2 +-
 drivers/thermal/rcar_thermal.c                |  49 +-----
 drivers/thermal/samsung/exynos_tmu.c          |  57 +++----
 drivers/thermal/st/st_thermal.c               |  47 +----
 drivers/thermal/tegra/soctherm.c              |  33 ++--
 drivers/thermal/tegra/tegra30-tsensor.c       |  17 +-
 drivers/thermal/thermal_core.c                | 160 +++++++++++++++---
 drivers/thermal/thermal_core.h                |  24 +--
 drivers/thermal/thermal_helpers.c             |  28 +--
 drivers/thermal/thermal_netlink.c             |  21 +--
 drivers/thermal/thermal_of.c                  | 116 -------------
 drivers/thermal/thermal_sysfs.c               | 127 +++++---------
 drivers/thermal/ti-soc-thermal/ti-thermal.h   |  15 --
 drivers/thermal/uniphier_thermal.c            |  27 ++-
 include/linux/thermal.h                       |  10 ++
 32 files changed, 545 insertions(+), 810 deletions(-)

-- 
2.34.1

