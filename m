Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50753643F85
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbiLFJPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbiLFJPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:15:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D06B1F63E;
        Tue,  6 Dec 2022 01:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670318099; x=1701854099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fMQg/B5zWTFCfmtxohSQOhRXBQA3hpnPSwjHWyBygKo=;
  b=rxf7P3VPjpOgm2rxvmkhPhWY8nj+zULVUAQ4dWXdrWlMBiLsljzeinN+
   pvM+DMrvbpA580ZNln45WOvhJp+ZX92J3d/HDxEwI1LKF4pg9WNVClgSO
   gmP0NqcPpk67W5M6QDEftvygaEg3iztmdj2efx0OhT3u/HsbCkAe7ctmK
   Gb6AlqHjqdmLqyaHDqN+k6epnc+EL/O+/uoAiPhhjstpePPDh7iA5el0i
   KiH4v9+LxpYSflfEfOSRHcCpzrW4kmZ4M5HrpGubDmAQIQ11tIVx/x/8/
   xl7OG3rk95eebYaDRztR10vOc/KHwBxIoJTIpt+hcvqAftIbNLaeETO1C
   A==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="126697356"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 02:14:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 02:14:57 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 02:14:51 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v2 01/13] net: dsa: microchip: ptp: add the posix clock support
Date:   Tue, 6 Dec 2022 14:44:16 +0530
Message-ID: <20221206091428.28285-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221206091428.28285-1-arun.ramadoss@microchip.com>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

This patch implement routines (adjfine, adjtime, gettime and settime)
for manipulating the chip's PTP clock. It registers the ptp caps
to posix clock register.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

---
v1 -> v2
- added arri in copyright message
- Deleted setting 8021_1as bit and added P2P bit in ksz_ptp_clock_register()
- Renamed error_return label to unlock
- Assigned the ptp_clock_info directly instead of const struct
- moved the semicolon in ksz_rmw16 after 0x%x:
- moved ts_info to next patch

RFC v2 -> Patch v1
- Repharsed the Kconfig help text
- Removed IS_ERR_OR_NULL check in ptp_clock_unregister
- Add the check for ptp_data->clock in ksz_ptp_ts_info
- Renamed MAX_DRIFT_CORR to KSZ_MAX_DRIFT_CORR
- Removed the comments
- Variables declaration in reverse christmas tree
- Added the ptp_clock_optional
---
 drivers/net/dsa/microchip/Kconfig       |  11 ++
 drivers/net/dsa/microchip/Makefile      |   5 +
 drivers/net/dsa/microchip/ksz_common.c  |  13 +-
 drivers/net/dsa/microchip/ksz_common.h  |  16 ++
 drivers/net/dsa/microchip/ksz_ptp.c     | 237 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |  42 +++++
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  52 ++++++
 7 files changed, 375 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.h
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp_reg.h

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 913f83ef013c..0546c573668a 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -11,6 +11,7 @@ menuconfig NET_DSA_MICROCHIP_KSZ_COMMON
 config NET_DSA_MICROCHIP_KSZ9477_I2C
 	tristate "KSZ series I2C connected switch driver"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON && I2C
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select REGMAP_I2C
 	help
 	  Select to enable support for registering switches configured through I2C.
@@ -18,10 +19,20 @@ config NET_DSA_MICROCHIP_KSZ9477_I2C
 config NET_DSA_MICROCHIP_KSZ_SPI
 	tristate "KSZ series SPI connected switch driver"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON && SPI
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select REGMAP_SPI
 	help
 	  Select to enable support for registering switches configured through SPI.
 
+config NET_DSA_MICROCHIP_KSZ_PTP
+	bool "Support for the PTP clock on the KSZ9563/LAN937x Ethernet Switch"
+	depends on NET_DSA_MICROCHIP_KSZ_COMMON && PTP_1588_CLOCK
+	help
+	  Select to enable support for timestamping & PTP clock manipulation in
+	  KSZ8563/KSZ9563/LAN937x series of switches. KSZ9563/KSZ8563 supports
+	  only one step timestamping. LAN937x switch supports both one step and
+	  two step timestamping.
+
 config NET_DSA_MICROCHIP_KSZ8863_SMI
 	tristate "KSZ series SMI connected switch driver"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 28873559efc2..48360cc9fc68 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -4,6 +4,11 @@ ksz_switch-objs := ksz_common.o
 ksz_switch-objs += ksz9477.o
 ksz_switch-objs += ksz8795.o
 ksz_switch-objs += lan937x_main.o
+
+ifdef CONFIG_NET_DSA_MICROCHIP_KSZ_PTP
+ksz_switch-objs += ksz_ptp.o
+endif
+
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_SPI)		+= ksz_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8c8db315317d..da717feca30a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -24,6 +24,7 @@
 #include <net/switchdev.h>
 
 #include "ksz_common.h"
+#include "ksz_ptp.h"
 #include "ksz8.h"
 #include "ksz9477.h"
 #include "lan937x.h"
@@ -2016,10 +2017,16 @@ static int ksz_setup(struct dsa_switch *ds)
 		}
 	}
 
+	ret = ksz_ptp_clock_register(ds);
+	if (ret) {
+		dev_err(dev->dev, "Failed to register PTP clock: %d\n", ret);
+		goto out_pirq;
+	}
+
 	ret = ksz_mdio_register(dev);
 	if (ret < 0) {
 		dev_err(dev->dev, "failed to register the mdio");
-		goto out_pirq;
+		goto out_ptp_clock_unregister;
 	}
 
 	/* start switch */
@@ -2028,6 +2035,8 @@ static int ksz_setup(struct dsa_switch *ds)
 
 	return 0;
 
+out_ptp_clock_unregister:
+	ksz_ptp_clock_unregister(ds);
 out_pirq:
 	if (dev->irq > 0)
 		dsa_switch_for_each_user_port(dp, dev->ds)
@@ -2044,6 +2053,8 @@ static void ksz_teardown(struct dsa_switch *ds)
 	struct ksz_device *dev = ds->priv;
 	struct dsa_port *dp;
 
+	ksz_ptp_clock_unregister(ds);
+
 	if (dev->irq > 0) {
 		dsa_switch_for_each_user_port(dp, dev->ds)
 			ksz_irq_free(&dev->ports[dp->index].pirq);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c6726cbd5465..78b4101553c6 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -15,6 +15,8 @@
 #include <net/dsa.h>
 #include <linux/irq.h>
 
+#include "ksz_ptp.h"
+
 #define KSZ_MAX_NUM_PORTS 8
 
 struct ksz_device;
@@ -141,6 +143,7 @@ struct ksz_device {
 	u16 port_mask;
 	struct mutex lock_irq;		/* IRQ Access */
 	struct ksz_irq girq;
+	struct ksz_ptp_data ptp_data;
 };
 
 /* List of supported models */
@@ -444,6 +447,19 @@ static inline int ksz_write32(struct ksz_device *dev, u32 reg, u32 value)
 	return ret;
 }
 
+static inline int ksz_rmw16(struct ksz_device *dev, u32 reg, u16 mask,
+			    u16 value)
+{
+	int ret;
+
+	ret = regmap_update_bits(dev->regmap[1], reg, mask, value);
+	if (ret)
+		dev_err(dev->dev, "can't rmw 16bit reg 0x%x: %pe\n", reg,
+			ERR_PTR(ret));
+
+	return ret;
+}
+
 static inline int ksz_write64(struct ksz_device *dev, u32 reg, u64 value)
 {
 	u32 val[2];
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
new file mode 100644
index 000000000000..68b1770da6ca
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Microchip KSZ PTP Implementation
+ *
+ * Copyright (C) 2020 ARRI Lighting
+ * Copyright (C) 2022 Microchip Technology Inc.
+ */
+
+#include <linux/kernel.h>
+#include <linux/ptp_classify.h>
+#include <linux/ptp_clock_kernel.h>
+
+#include "ksz_common.h"
+#include "ksz_ptp.h"
+#include "ksz_ptp_reg.h"
+
+#define ptp_caps_to_data(d) container_of((d), struct ksz_ptp_data, caps)
+#define ptp_data_to_ksz_dev(d) container_of((d), struct ksz_device, ptp_data)
+
+/* Sub-nanoseconds-adj,max * sub-nanoseconds / 40ns * 1ns
+ * = (2^30-1) * (2 ^ 32) / 40 ns * 1 ns = 6249999
+ */
+#define KSZ_MAX_DRIFT_CORR 6249999
+
+#define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
+#define KSZ_PTP_SUBNS_BITS 32
+
+static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
+{
+	u32 nanoseconds;
+	u32 seconds;
+	u8 phase;
+	int ret;
+
+	/* Copy current PTP clock into shadow registers and read */
+	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_READ_TIME, PTP_READ_TIME);
+	if (ret)
+		return ret;
+
+	ret = ksz_read8(dev, REG_PTP_RTC_SUB_NANOSEC__2, &phase);
+	if (ret)
+		return ret;
+
+	ret = ksz_read32(dev, REG_PTP_RTC_NANOSEC, &nanoseconds);
+	if (ret)
+		return ret;
+
+	ret = ksz_read32(dev, REG_PTP_RTC_SEC, &seconds);
+	if (ret)
+		return ret;
+
+	ts->tv_sec = seconds;
+	ts->tv_nsec = nanoseconds + phase * 8;
+
+	return 0;
+}
+
+static int ksz_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	int ret;
+
+	mutex_lock(&ptp_data->lock);
+	ret = _ksz_ptp_gettime(dev, ts);
+	mutex_unlock(&ptp_data->lock);
+
+	return ret;
+}
+
+static int ksz_ptp_settime(struct ptp_clock_info *ptp,
+			   const struct timespec64 *ts)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	int ret;
+
+	mutex_lock(&ptp_data->lock);
+
+	/* Write to shadow registers and Load PTP clock */
+	ret = ksz_write16(dev, REG_PTP_RTC_SUB_NANOSEC__2, PTP_RTC_0NS);
+	if (ret)
+		goto unlock;
+
+	ret = ksz_write32(dev, REG_PTP_RTC_NANOSEC, ts->tv_nsec);
+	if (ret)
+		goto unlock;
+
+	ret = ksz_write32(dev, REG_PTP_RTC_SEC, ts->tv_sec);
+	if (ret)
+		goto unlock;
+
+	ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_LOAD_TIME, PTP_LOAD_TIME);
+
+unlock:
+	mutex_unlock(&ptp_data->lock);
+
+	return ret;
+}
+
+static int ksz_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	int ret;
+
+	mutex_lock(&ptp_data->lock);
+
+	if (scaled_ppm) {
+		s64 ppb, adj;
+		u32 data32;
+
+		/* see scaled_ppm_to_ppb() in ptp_clock.c for details */
+		ppb = 1 + scaled_ppm;
+		ppb *= 125;
+		ppb *= KSZ_PTP_INC_NS;
+		ppb <<= KSZ_PTP_SUBNS_BITS - 13;
+		adj = div_s64(ppb, NSEC_PER_SEC);
+
+		data32 = abs(adj);
+		data32 &= PTP_SUBNANOSEC_M;
+		if (adj >= 0)
+			data32 |= PTP_RATE_DIR;
+
+		ret = ksz_write32(dev, REG_PTP_SUBNANOSEC_RATE, data32);
+		if (ret)
+			goto unlock;
+
+		ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ADJ_ENABLE,
+				PTP_CLK_ADJ_ENABLE);
+		if (ret)
+			goto unlock;
+	} else {
+		ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ADJ_ENABLE, 0);
+		if (ret)
+			goto unlock;
+	}
+
+unlock:
+	mutex_unlock(&ptp_data->lock);
+	return ret;
+}
+
+static int ksz_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
+	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
+	s32 sec, nsec;
+	u16 data16;
+	int ret;
+
+	mutex_lock(&ptp_data->lock);
+
+	/* do not use ns_to_timespec64(),
+	 * both sec and nsec are subtracted by hw
+	 */
+	sec = div_s64_rem(delta, NSEC_PER_SEC, &nsec);
+
+	ret = ksz_write32(dev, REG_PTP_RTC_NANOSEC, abs(nsec));
+	if (ret)
+		goto unlock;
+
+	ret = ksz_write32(dev, REG_PTP_RTC_SEC, abs(sec));
+	if (ret)
+		goto unlock;
+
+	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data16);
+	if (ret)
+		goto unlock;
+
+	data16 |= PTP_STEP_ADJ;
+
+	/* PTP_STEP_DIR -- 0: subtract, 1: add */
+	if (delta < 0)
+		data16 &= ~PTP_STEP_DIR;
+	else
+		data16 |= PTP_STEP_DIR;
+
+	ret = ksz_write16(dev, REG_PTP_CLK_CTRL, data16);
+
+unlock:
+	mutex_unlock(&ptp_data->lock);
+	return ret;
+}
+
+static int ksz_ptp_start_clock(struct ksz_device *dev)
+{
+	return ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ENABLE, PTP_CLK_ENABLE);
+}
+
+int ksz_ptp_clock_register(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_ptp_data *ptp_data;
+	int ret;
+
+	ptp_data = &dev->ptp_data;
+	mutex_init(&ptp_data->lock);
+
+	ptp_data->caps.owner		= THIS_MODULE;
+	snprintf(ptp_data->caps.name, 16, "Microchip Clock");
+	ptp_data->caps.max_adj		= KSZ_MAX_DRIFT_CORR;
+	ptp_data->caps.gettime64	= ksz_ptp_gettime;
+	ptp_data->caps.settime64	= ksz_ptp_settime;
+	ptp_data->caps.adjfine		= ksz_ptp_adjfine;
+	ptp_data->caps.adjtime		= ksz_ptp_adjtime;
+
+	ret = ksz_ptp_start_clock(dev);
+	if (ret)
+		return ret;
+
+	/* Currently only P2P mode is supported */
+	ret = ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_TC_P2P, PTP_TC_P2P);
+	if (ret)
+		return ret;
+
+	ptp_data->clock = ptp_clock_register(&ptp_data->caps, dev->dev);
+	if (IS_ERR_OR_NULL(ptp_data->clock))
+		return PTR_ERR(ptp_data->clock);
+
+	return 0;
+}
+
+void ksz_ptp_clock_unregister(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_ptp_data *ptp_data;
+
+	ptp_data = &dev->ptp_data;
+
+	if (ptp_data->clock)
+		ptp_clock_unregister(ptp_data->clock);
+}
+
+MODULE_AUTHOR("Christian Eggers <ceggers@arri.de>");
+MODULE_AUTHOR("Arun Ramadoss <arun.ramadoss@microchip.com>");
+MODULE_DESCRIPTION("PTP support for KSZ switch");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
new file mode 100644
index 000000000000..8930047da764
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip KSZ PTP Implementation
+ *
+ * Copyright (C) 2020 ARRI Lighting
+ * Copyright (C) 2022 Microchip Technology Inc.
+ */
+
+#ifndef _NET_DSA_DRIVERS_KSZ_PTP_H
+#define _NET_DSA_DRIVERS_KSZ_PTP_H
+
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
+
+#include <linux/ptp_clock_kernel.h>
+
+struct ksz_ptp_data {
+	struct ptp_clock_info caps;
+	struct ptp_clock *clock;
+	/* Serializes all operations on the PTP hardware clock */
+	struct mutex lock;
+};
+
+int ksz_ptp_clock_register(struct dsa_switch *ds);
+
+void ksz_ptp_clock_unregister(struct dsa_switch *ds);
+
+#else
+
+struct ksz_ptp_data {
+	/* Serializes all operations on the PTP hardware clock */
+	struct mutex lock;
+};
+
+static inline int ksz_ptp_clock_register(struct dsa_switch *ds)
+{
+	return 0;
+}
+
+static inline void ksz_ptp_clock_unregister(struct dsa_switch *ds) { }
+
+#endif	/* End of CONFIG_NET_DSA_MICROCHIP_KSZ_PTP */
+
+#endif
diff --git a/drivers/net/dsa/microchip/ksz_ptp_reg.h b/drivers/net/dsa/microchip/ksz_ptp_reg.h
new file mode 100644
index 000000000000..4ca4ad4bba7e
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz_ptp_reg.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip KSZ PTP register definitions
+ * Copyright (C) 2022 Microchip Technology Inc.
+ */
+
+#ifndef __KSZ_PTP_REGS_H
+#define __KSZ_PTP_REGS_H
+
+/* 5 - PTP Clock */
+#define REG_PTP_CLK_CTRL		0x0500
+
+#define PTP_STEP_ADJ			BIT(6)
+#define PTP_STEP_DIR			BIT(5)
+#define PTP_READ_TIME			BIT(4)
+#define PTP_LOAD_TIME			BIT(3)
+#define PTP_CLK_ADJ_ENABLE		BIT(2)
+#define PTP_CLK_ENABLE			BIT(1)
+#define PTP_CLK_RESET			BIT(0)
+
+#define REG_PTP_RTC_SUB_NANOSEC__2	0x0502
+
+#define PTP_RTC_SUB_NANOSEC_M		0x0007
+#define PTP_RTC_0NS			0x00
+
+#define REG_PTP_RTC_NANOSEC		0x0504
+
+#define REG_PTP_RTC_SEC			0x0508
+
+#define REG_PTP_SUBNANOSEC_RATE		0x050C
+
+#define PTP_SUBNANOSEC_M		0x3FFFFFFF
+#define PTP_RATE_DIR			BIT(31)
+#define PTP_TMP_RATE_ENABLE		BIT(30)
+
+#define REG_PTP_SUBNANOSEC_RATE_L	0x050E
+
+#define REG_PTP_RATE_DURATION		0x0510
+#define REG_PTP_RATE_DURATION_H		0x0510
+#define REG_PTP_RATE_DURATION_L		0x0512
+
+#define REG_PTP_MSG_CONF1		0x0514
+
+#define PTP_802_1AS			BIT(7)
+#define PTP_ENABLE			BIT(6)
+#define PTP_ETH_ENABLE			BIT(5)
+#define PTP_IPV4_UDP_ENABLE		BIT(4)
+#define PTP_IPV6_UDP_ENABLE		BIT(3)
+#define PTP_TC_P2P			BIT(2)
+#define PTP_MASTER			BIT(1)
+#define PTP_1STEP			BIT(0)
+
+#endif
-- 
2.36.1

