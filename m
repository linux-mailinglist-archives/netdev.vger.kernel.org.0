Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DCD690347
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjBIJTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjBIJTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:19:14 -0500
Received: from mr85p00im-zteg06023901.me.com (mr85p00im-zteg06023901.me.com [17.58.23.192])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A716187C
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1675934342; bh=vRkQEzM2+9/tGet/QZk1zb8qFTBGI28OrtCRk+zgfWM=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=ZLcArdtuxHGtGcK5K9/XT3ysC3aVs8v+ADY0ltkJByc6/h2D3t1luQNSzMrcbNZNG
         Uq0Z6UQgasjTSvi9Fb9rYlUSl1Y6TKLj5ypuNZDHbwbTf5BSQk1BIr2n6MqvrxYZP+
         a+8BLwQXMGa6go0xKgTWNGzNevCeS8aa89488ZLekPzPlHp6+FDdeG0HU0mYD7fxDV
         3H9giQGTeosV1wCsdCimj9xjVeRFFaApQ2lpuIG8mLyj61TepRVfF5unYMByfWxVPf
         JAaRt4MICsf9Mm/7bOshKrWS6ALJQcSKuoIIq1ew7mqm2uNqog1tjNW6dn7ToBLZIu
         H6svtTqIwIBvQ==
Received: from localhost (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-zteg06023901.me.com (Postfix) with ESMTPSA id 5621F6E0E87;
        Thu,  9 Feb 2023 09:19:01 +0000 (UTC)
From:   Alain Volmat <avolmat@me.com>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org, Alain Volmat <avolmat@me.com>
Subject: [PATCH 06/11] thermal/drivers/st: remove syscfg based driver
Date:   Thu,  9 Feb 2023 10:16:54 +0100
Message-Id: <20230209091659.1409-7-avolmat@me.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209091659.1409-1-avolmat@me.com>
References: <20230209091659.1409-1-avolmat@me.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Mn4I-VDnLPHh3iky93NBkjJ0LUkZWiua
X-Proofpoint-GUID: Mn4I-VDnLPHh3iky93NBkjJ0LUkZWiua
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2302090088
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The syscfg based thermal driver is only supporting STiH415
STiH416 and STiD127 platforms which are all no more supported.
We can thus safely remove this driver since the remaining STi
platform STiH407/STiH410 and STiH418 are all using the memmap
based thermal driver.

Signed-off-by: Alain Volmat <avolmat@me.com>
---
 drivers/thermal/st/Kconfig             |   4 -
 drivers/thermal/st/Makefile            |   1 -
 drivers/thermal/st/st_thermal_syscfg.c | 174 -------------------------
 3 files changed, 179 deletions(-)
 delete mode 100644 drivers/thermal/st/st_thermal_syscfg.c

diff --git a/drivers/thermal/st/Kconfig b/drivers/thermal/st/Kconfig
index 58ece381956b..ecbdf4ef00f4 100644
--- a/drivers/thermal/st/Kconfig
+++ b/drivers/thermal/st/Kconfig
@@ -8,10 +8,6 @@ config ST_THERMAL
 	help
 	  Support for thermal sensors on STMicroelectronics STi series of SoCs.
 
-config ST_THERMAL_SYSCFG
-	select ST_THERMAL
-	tristate "STi series syscfg register access based thermal sensors"
-
 config ST_THERMAL_MEMMAP
 	select ST_THERMAL
 	tristate "STi series memory mapped access based thermal sensors"
diff --git a/drivers/thermal/st/Makefile b/drivers/thermal/st/Makefile
index c4cfa3c4a660..9bb0342b77f4 100644
--- a/drivers/thermal/st/Makefile
+++ b/drivers/thermal/st/Makefile
@@ -1,5 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_ST_THERMAL)		:= st_thermal.o
-obj-$(CONFIG_ST_THERMAL_SYSCFG)		+= st_thermal_syscfg.o
 obj-$(CONFIG_ST_THERMAL_MEMMAP)		+= st_thermal_memmap.o
 obj-$(CONFIG_STM32_THERMAL)		+= stm_thermal.o
diff --git a/drivers/thermal/st/st_thermal_syscfg.c b/drivers/thermal/st/st_thermal_syscfg.c
deleted file mode 100644
index 94efecf35cf8..000000000000
--- a/drivers/thermal/st/st_thermal_syscfg.c
+++ /dev/null
@@ -1,174 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * ST Thermal Sensor Driver for syscfg based sensors.
- * Author: Ajit Pal Singh <ajitpal.singh@st.com>
- *
- * Copyright (C) 2003-2014 STMicroelectronics (R&D) Limited
- */
-
-#include <linux/of.h>
-#include <linux/module.h>
-#include <linux/mfd/syscon.h>
-
-#include "st_thermal.h"
-
-/* STiH415 */
-#define STIH415_SYSCFG_FRONT(num)		((num - 100) * 4)
-#define STIH415_SAS_THSENS_CONF			STIH415_SYSCFG_FRONT(178)
-#define STIH415_SAS_THSENS_STATUS		STIH415_SYSCFG_FRONT(198)
-#define STIH415_SYSCFG_MPE(num)			((num - 600) * 4)
-#define STIH415_MPE_THSENS_CONF			STIH415_SYSCFG_MPE(607)
-#define STIH415_MPE_THSENS_STATUS		STIH415_SYSCFG_MPE(667)
-
-/* STiH416 */
-#define STIH416_SYSCFG_FRONT(num)		((num - 1000) * 4)
-#define STIH416_SAS_THSENS_CONF			STIH416_SYSCFG_FRONT(1552)
-#define STIH416_SAS_THSENS_STATUS1		STIH416_SYSCFG_FRONT(1554)
-#define STIH416_SAS_THSENS_STATUS2		STIH416_SYSCFG_FRONT(1594)
-
-/* STiD127 */
-#define STID127_SYSCFG_CPU(num)			((num - 700) * 4)
-#define STID127_THSENS_CONF			STID127_SYSCFG_CPU(743)
-#define STID127_THSENS_STATUS			STID127_SYSCFG_CPU(767)
-
-static const struct reg_field st_415sas_regfields[MAX_REGFIELDS] = {
-	[TEMP_PWR] = REG_FIELD(STIH415_SAS_THSENS_CONF,   9,  9),
-	[DCORRECT] = REG_FIELD(STIH415_SAS_THSENS_CONF,   4,  8),
-	[OVERFLOW] = REG_FIELD(STIH415_SAS_THSENS_STATUS, 8,  8),
-	[DATA] 	   = REG_FIELD(STIH415_SAS_THSENS_STATUS, 10, 16),
-};
-
-static const struct reg_field st_415mpe_regfields[MAX_REGFIELDS] = {
-	[TEMP_PWR] = REG_FIELD(STIH415_MPE_THSENS_CONF,   8,  8),
-	[DCORRECT] = REG_FIELD(STIH415_MPE_THSENS_CONF,   3,  7),
-	[OVERFLOW] = REG_FIELD(STIH415_MPE_THSENS_STATUS, 9,  9),
-	[DATA]     = REG_FIELD(STIH415_MPE_THSENS_STATUS, 11, 18),
-};
-
-static const struct reg_field st_416sas_regfields[MAX_REGFIELDS] = {
-	[TEMP_PWR] = REG_FIELD(STIH416_SAS_THSENS_CONF,    9,  9),
-	[DCORRECT] = REG_FIELD(STIH416_SAS_THSENS_CONF,    4,  8),
-	[OVERFLOW] = REG_FIELD(STIH416_SAS_THSENS_STATUS1, 8,  8),
-	[DATA]     = REG_FIELD(STIH416_SAS_THSENS_STATUS2, 10, 16),
-};
-
-static const struct reg_field st_127_regfields[MAX_REGFIELDS] = {
-	[TEMP_PWR] = REG_FIELD(STID127_THSENS_CONF,   7,  7),
-	[DCORRECT] = REG_FIELD(STID127_THSENS_CONF,   2,  6),
-	[OVERFLOW] = REG_FIELD(STID127_THSENS_STATUS, 9,  9),
-	[DATA]     = REG_FIELD(STID127_THSENS_STATUS, 11, 18),
-};
-
-/* Private OPs for System Configuration Register based thermal sensors */
-static int st_syscfg_power_ctrl(struct st_thermal_sensor *sensor,
-				enum st_thermal_power_state power_state)
-{
-	return regmap_field_write(sensor->pwr, power_state);
-}
-
-static int st_syscfg_alloc_regfields(struct st_thermal_sensor *sensor)
-{
-	struct device *dev = sensor->dev;
-
-	sensor->pwr = devm_regmap_field_alloc(dev, sensor->regmap,
-					sensor->cdata->reg_fields[TEMP_PWR]);
-
-	if (IS_ERR(sensor->pwr)) {
-		dev_err(dev, "failed to alloc syscfg regfields\n");
-		return PTR_ERR(sensor->pwr);
-	}
-
-	return 0;
-}
-
-static int st_syscfg_regmap_init(struct st_thermal_sensor *sensor)
-{
-	sensor->regmap =
-		syscon_regmap_lookup_by_compatible(sensor->cdata->sys_compat);
-	if (IS_ERR(sensor->regmap)) {
-		dev_err(sensor->dev, "failed to find syscfg regmap\n");
-		return PTR_ERR(sensor->regmap);
-	}
-
-	return 0;
-}
-
-static const struct st_thermal_sensor_ops st_syscfg_sensor_ops = {
-	.power_ctrl		= st_syscfg_power_ctrl,
-	.alloc_regfields	= st_syscfg_alloc_regfields,
-	.regmap_init		= st_syscfg_regmap_init,
-};
-
-/* Compatible device data for stih415 sas thermal sensor */
-static const struct st_thermal_compat_data st_415sas_cdata = {
-	.sys_compat		= "st,stih415-front-syscfg",
-	.reg_fields		= st_415sas_regfields,
-	.ops			= &st_syscfg_sensor_ops,
-	.calibration_val	= 16,
-	.temp_adjust_val	= 20,
-	.crit_temp		= 120,
-};
-
-/* Compatible device data for stih415 mpe thermal sensor */
-static const struct st_thermal_compat_data st_415mpe_cdata = {
-	.sys_compat		= "st,stih415-system-syscfg",
-	.reg_fields		= st_415mpe_regfields,
-	.ops			= &st_syscfg_sensor_ops,
-	.calibration_val	= 16,
-	.temp_adjust_val	= -103,
-	.crit_temp		= 120,
-};
-
-/* Compatible device data for stih416 sas thermal sensor */
-static const struct st_thermal_compat_data st_416sas_cdata = {
-	.sys_compat		= "st,stih416-front-syscfg",
-	.reg_fields		= st_416sas_regfields,
-	.ops			= &st_syscfg_sensor_ops,
-	.calibration_val	= 16,
-	.temp_adjust_val	= 20,
-	.crit_temp		= 120,
-};
-
-/* Compatible device data for stid127 thermal sensor */
-static const struct st_thermal_compat_data st_127_cdata = {
-	.sys_compat		= "st,stid127-cpu-syscfg",
-	.reg_fields		= st_127_regfields,
-	.ops			= &st_syscfg_sensor_ops,
-	.calibration_val	= 8,
-	.temp_adjust_val	= -103,
-	.crit_temp		= 120,
-};
-
-static const struct of_device_id st_syscfg_thermal_of_match[] = {
-	{ .compatible = "st,stih415-sas-thermal", .data = &st_415sas_cdata },
-	{ .compatible = "st,stih415-mpe-thermal", .data = &st_415mpe_cdata },
-	{ .compatible = "st,stih416-sas-thermal", .data = &st_416sas_cdata },
-	{ .compatible = "st,stid127-thermal",     .data = &st_127_cdata },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, st_syscfg_thermal_of_match);
-
-static int st_syscfg_probe(struct platform_device *pdev)
-{
-	return st_thermal_register(pdev, st_syscfg_thermal_of_match);
-}
-
-static int st_syscfg_remove(struct platform_device *pdev)
-{
-	return st_thermal_unregister(pdev);
-}
-
-static struct platform_driver st_syscfg_thermal_driver = {
-	.driver = {
-		.name	= "st_syscfg_thermal",
-		.pm     = &st_thermal_pm_ops,
-		.of_match_table =  st_syscfg_thermal_of_match,
-	},
-	.probe		= st_syscfg_probe,
-	.remove		= st_syscfg_remove,
-};
-module_platform_driver(st_syscfg_thermal_driver);
-
-MODULE_AUTHOR("STMicroelectronics (R&D) Limited <ajitpal.singh@st.com>");
-MODULE_DESCRIPTION("STMicroelectronics STi SoC Thermal Sensor Driver");
-MODULE_LICENSE("GPL v2");
-- 
2.34.1

