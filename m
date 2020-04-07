Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526701A1302
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 19:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDGRtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 13:49:47 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42962 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgDGRtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 13:49:47 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 53C822972A7
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
To:     linux-pm@vger.kernel.org
Cc:     Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Subject: [RFC 4/8] thermal: core: Introduce THERMAL_DEVICE_INITIAL
Date:   Tue,  7 Apr 2020 19:49:22 +0200
Message-Id: <20200407174926.23971-5-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200407174926.23971-1-andrzej.p@collabora.com>
References: <20200407174926.23971-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new mode: THERMAL_DEVICE_INITIAL. It is dedicated to handle devices
which must be initially DISABLED, but which are polled at startup
nonetheless. THERMAL_DEVICE_INITIAL shall be reported as "enabled" in
sysfs to keep the userspace interface intact.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/thermal/thermal_sysfs.c | 4 ++--
 include/linux/thermal.h         | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index aa99edb4dff7..6bfef21abce4 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -59,8 +59,8 @@ mode_show(struct device *dev, struct device_attribute *attr, char *buf)
 	if (result)
 		return result;
 
-	return sprintf(buf, "%s\n", mode == THERMAL_DEVICE_ENABLED ? "enabled"
-		       : "disabled");
+	return sprintf(buf, "%s\n", mode == THERMAL_DEVICE_DISABLED ? "disabled"
+		       : "enabled");
 }
 
 static ssize_t
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 126913c6a53b..1bc6b7998093 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -48,8 +48,9 @@ struct thermal_cooling_device;
 struct thermal_instance;
 
 enum thermal_device_mode {
-	THERMAL_DEVICE_DISABLED = 0,
+	THERMAL_DEVICE_INITIAL = 0,
 	THERMAL_DEVICE_ENABLED,
+	THERMAL_DEVICE_DISABLED,
 };
 
 enum thermal_trip_type {
-- 
2.17.1

