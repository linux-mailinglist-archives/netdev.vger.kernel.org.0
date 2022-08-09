Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1F358E25A
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiHIWFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiHIWE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:04:57 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2D4B862
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 15:04:54 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id l4so15719311wrm.13
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 15:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Rw24++d83FmAECgGTZW39DAbfqy/56dqD/fDiTijUrQ=;
        b=rMTBq9ACieo5nHODpK1yV6lFY5Gr3qFBvd5TQahkTrYj93QYMzvIUmet3zT+hQbKSm
         KfnG5KomGsCXRC4ulJcpEEkH+HmC9PXyunjeNhFeAIv1W+yyPInUO4sKsoeiDadjruMD
         6SLwGtBPrnjx/mr8McA6IZTHOyMyQRIJS7YBGgoBNj/O4lSVsxzrLjHoNa4qB4yx1nmN
         XUMS8MyuG1ZJa5PUt/E4VNZ6Y/6fM1OK6AJATGCnqVckiP8FhBkoI9ciCpsEx9tZpcph
         Y1d6Uu5bJ4AtHY+7dRAf2hJxA2xCsr5Rjg+kA9Aqk1tWywaclphebmFFb7pJy2F46rPx
         RzMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Rw24++d83FmAECgGTZW39DAbfqy/56dqD/fDiTijUrQ=;
        b=QUZUbWSZ95KBJ23zUrgB/uY8BUUDmYsZy/bESyiOxqSW4FyLDBrty6yqdWRiv0HwPI
         AB5PA/2/+2kwk0kKxI7y16WqURulOhbHHghG/gPHr++QsDQBJp8pEc7fKc5/0aHighKO
         0/W7o5FW0+vESQ5XPoJWYZThq1kU9jhQgOapAYBondmuGYKwmUcoUqWpcOgSw1a6nOpV
         VMYX0Ud6IsoQbM4R4HLXRAAHPyn7aOFHHeoh/5yEkwss3mqjn8jF0ty789rao5LkPzH3
         /UARmxYVG+tAncPLKuoUvAzK6Zu36N3qlCo6fchuvLqgalLK44kXhSlvzR0gQAmfSdc4
         iKFA==
X-Gm-Message-State: ACgBeo1tKZOnuInZxyhER2XDej0adQ1KAq5pK+UotfV9m0n0p4KjD72K
        JjMO8uiLeZihKbDM9WL1t4tOHg==
X-Google-Smtp-Source: AA6agR6sgfbhJu5TDdeSbXk5JZdaJJEaWGyCp0X6VkOIngem/8Da23ZHTsdbWhLJaT65xJe8tSS/+w==
X-Received: by 2002:a5d:6dad:0:b0:221:b7dd:9be7 with SMTP id u13-20020a5d6dad000000b00221b7dd9be7mr11394238wrs.190.1660082693008;
        Tue, 09 Aug 2022 15:04:53 -0700 (PDT)
Received: from localhost.localdomain (146725694.box.freepro.com. [130.180.211.218])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c3b1500b003a317ee3036sm293583wms.2.2022.08.09.15.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 15:04:52 -0700 (PDT)
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
Subject: [PATCH v2 00/26] Rework the trip points creation
Date:   Wed, 10 Aug 2022 00:04:10 +0200
Message-Id: <20220809220436.711020-1-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
 drivers/thermal/thermal_core.c                |  69 ++++++----
 drivers/thermal/thermal_core.h                |  30 ++---
 drivers/thermal/thermal_helpers.c             |  28 ++--
 drivers/thermal/thermal_netlink.c             |  21 ++-
 drivers/thermal/thermal_of.c                  |  88 -------------
 drivers/thermal/thermal_sysfs.c               |  91 +++++--------
 drivers/thermal/ti-soc-thermal/ti-thermal.h   |  15 ---
 drivers/thermal/uniphier_thermal.c            |  26 ++--
 31 files changed, 435 insertions(+), 757 deletions(-)

-- 
2.34.1

