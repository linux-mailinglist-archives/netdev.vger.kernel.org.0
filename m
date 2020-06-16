Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED561FA647
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 04:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgFPCGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 22:06:43 -0400
Received: from m12-16.163.com ([220.181.12.16]:37203 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgFPCGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 22:06:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=J11xe
        7BYRxCR09QvFEBcPQiPOjGNCAeRQ0ssUptR8+A=; b=f9IUQ+UKES9qzN8BsuJim
        7+gDo5IlUoF/KsQEJngFYaGTlIUcqmDzehoWZcAub0VdtjFhpJp3LSKkQR+v2Q8Z
        ZKubGJeG6B4f7TvbsBjm3FPjQPyrSfvbuAVJuD92o7Bmrz+mjfyzjlhOaOYMRNP4
        +IQDqzUa+c0kh5qEtcovCU=
Received: from SZA191027643-PM.china.huawei.com (unknown [139.159.170.21])
        by smtp12 (Coremail) with SMTP id EMCowAD3+RUDKehey52wIQ--.54773S2;
        Tue, 16 Jun 2020 10:05:58 +0800 (CST)
From:   yunaixin03610@163.com
To:     netdev@vger.kernel.org
Cc:     yunaixin <yunaixin@huawei.com>
Subject: [PATCH 5/5] Huawei BMA: Adding Huawei BMA driver: host_kbox_drv
Date:   Tue, 16 Jun 2020 10:05:54 +0800
Message-Id: <20200616020554.1443-1-yunaixin03610@163.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowAD3+RUDKehey52wIQ--.54773S2
X-Coremail-Antispam: 1Uf129KBjvAXoWkWryftFyDKFykZw43WryxGrg_yoWfAFyxGo
        WSya15Aw4rCr42yrWkKF17GF17Zasrtr45Jw4Fvr4DXFyrAr15XFnxKw4Yy3W7Wrs09r4r
        ua4xX3W3ur40qFn3n29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU2ZqXDUUUU
X-Originating-IP: [139.159.170.21]
X-CM-SenderInfo: 51xqtxx0lqijqwrqqiywtou0bp/1tbiDgdF5lXlws6qwwAAs-
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yunaixin <yunaixin@huawei.com>

The BMA software is a system management software offered by Huawei. It supports the status monitoring, performance monitoring, and event monitoring of various components, including server CPUs, memory, hard disks, NICs, IB cards, PCIe cards, RAID controller cards, and optical modules.

The host_kbox_drv driver serves the function of a black box. When a panic or mce event happen to the system, it will record the event time, system's status and system logs and send them to BMC before the OS shutdown. This driver depends on the host_edms_drv driver.

Signed-off-by: yunaixin <yunaixin@huawei.com>
---
 drivers/net/ethernet/huawei/bma/Kconfig       |   1 +
 drivers/net/ethernet/huawei/bma/Makefile      |   1 +
 .../net/ethernet/huawei/bma/kbox_drv/Kconfig  |  11 +
 .../net/ethernet/huawei/bma/kbox_drv/Makefile |   2 +
 .../ethernet/huawei/bma/kbox_drv/kbox_dump.c  | 122 +++
 .../ethernet/huawei/bma/kbox_drv/kbox_dump.h  |  33 +
 .../ethernet/huawei/bma/kbox_drv/kbox_hook.c  | 101 ++
 .../ethernet/huawei/bma/kbox_drv/kbox_hook.h  |  33 +
 .../huawei/bma/kbox_drv/kbox_include.h        |  42 +
 .../ethernet/huawei/bma/kbox_drv/kbox_main.c  | 168 +++
 .../ethernet/huawei/bma/kbox_drv/kbox_main.h  |  23 +
 .../ethernet/huawei/bma/kbox_drv/kbox_mce.c   | 264 +++++
 .../ethernet/huawei/bma/kbox_drv/kbox_mce.h   |  23 +
 .../ethernet/huawei/bma/kbox_drv/kbox_panic.c | 187 ++++
 .../ethernet/huawei/bma/kbox_drv/kbox_panic.h |  25 +
 .../huawei/bma/kbox_drv/kbox_printk.c         | 362 +++++++
 .../huawei/bma/kbox_drv/kbox_printk.h         |  33 +
 .../huawei/bma/kbox_drv/kbox_ram_drive.c      | 188 ++++
 .../huawei/bma/kbox_drv/kbox_ram_drive.h      |  31 +
 .../huawei/bma/kbox_drv/kbox_ram_image.c      | 135 +++
 .../huawei/bma/kbox_drv/kbox_ram_image.h      |  84 ++
 .../huawei/bma/kbox_drv/kbox_ram_op.c         | 986 ++++++++++++++++++
 .../huawei/bma/kbox_drv/kbox_ram_op.h         |  77 ++
 23 files changed, 2932 insertions(+)
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_include.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.h

diff --git a/drivers/net/ethernet/huawei/bma/Kconfig b/drivers/net/ethernet/huawei/bma/Kconfig
index 90b267c265e0..77041669d4b4 100644
--- a/drivers/net/ethernet/huawei/bma/Kconfig
+++ b/drivers/net/ethernet/huawei/bma/Kconfig
@@ -1,4 +1,5 @@
 source "drivers/net/ethernet/huawei/bma/edma_drv/Kconfig"
 source "drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig"
 source "drivers/net/ethernet/huawei/bma/veth_drv/Kconfig"
+source "drivers/net/ethernet/huawei/bma/kbox_drv/Kconfig"
 source "drivers/net/ethernet/huawei/bma/cdev_veth_drv/Kconfig"
\ No newline at end of file
diff --git a/drivers/net/ethernet/huawei/bma/Makefile b/drivers/net/ethernet/huawei/bma/Makefile
index c626618f47fb..5caa8290a1f7 100644
--- a/drivers/net/ethernet/huawei/bma/Makefile
+++ b/drivers/net/ethernet/huawei/bma/Makefile
@@ -5,4 +5,5 @@
 obj-$(CONFIG_BMA) += edma_drv/
 obj-$(CONFIG_BMA) += cdev_drv/
 obj-$(CONFIG_BMA) += veth_drv/
+obj-$(CONFIG_BMA) += kbox_drv/
 obj-$(CONFIG_BMA) += cdev_veth_drv/
\ No newline at end of file
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/Kconfig b/drivers/net/ethernet/huawei/bma/kbox_drv/Kconfig
new file mode 100644
index 000000000000..97829c5487c2
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/Kconfig
@@ -0,0 +1,11 @@
+#
+# Huawei BMA software driver configuration
+#
+
+config BMA
+	tristate "Huawei BMA Software Communication Driver"
+
+	---help---
+	  This driver supports Huawei BMA Software. It is used 
+	  to communication between Huawei BMA and BMC software.
+
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/Makefile b/drivers/net/ethernet/huawei/bma/kbox_drv/Makefile
new file mode 100644
index 000000000000..9565a00fee44
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_BMA) += host_kbox_drv.o
+host_kbox_drv-y := kbox_main.o kbox_ram_drive.o kbox_ram_image.o kbox_ram_op.o kbox_printk.o kbox_dump.o kbox_hook.o kbox_panic.o
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.c b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.c
new file mode 100644
index 000000000000..3ce6c099277d
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/utsname.h>		/* system_utsname */
+#include <linux/rtc.h>		/* struct rtc_time */
+#include "kbox_include.h"
+#include "kbox_main.h"
+#include "kbox_printk.h"
+#include "kbox_ram_image.h"
+#include "kbox_ram_op.h"
+#include "kbox_dump.h"
+#include "kbox_panic.h"
+
+#ifdef CONFIG_X86
+#include "kbox_mce.h"
+#endif
+
+#define THREAD_TMP_BUF_SIZE 256
+
+static DEFINE_SPINLOCK(g_dump_lock);
+
+static const char g_day_in_month[] = {
+	31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
+};
+
+#define LEAPS_THRU_END_OF(y) ((y) / 4 - (y) / 100 + (y) / 400)
+#define LEAP_YEAR(year) \
+	((!((year) % 4) && ((year) % 100)) || !((year) % 400))
+#define MONTH_DAYS(month, year) \
+	(g_day_in_month[(month)] + (int)(LEAP_YEAR(year) && (month == 1)))
+
+static void kbox_show_kernel_version(void)
+{
+	(void)kbox_dump_painc_info
+		("\nOS : %s,\nRelease : %s,\nVersion : %s,\n",
+		 init_uts_ns.name.sysname,
+		 init_uts_ns.name.release,
+		 init_uts_ns.name.version);
+	(void)kbox_dump_painc_info
+		("Machine : %s,\nNodename : %s\n",
+		 init_uts_ns.name.machine,
+		 init_uts_ns.name.nodename);
+}
+
+static void kbox_show_version(void)
+{
+	(void)kbox_dump_painc_info("\nKBOX_VERSION         : %s\n",
+				   KBOX_VERSION);
+}
+
+static void kbox_show_time_stamps(void)
+{
+	struct rtc_time rtc_time_val = { };
+	struct timeval time_value = { };
+
+	do_gettimeofday(&time_value);
+	time_value.tv_sec = time_value.tv_sec - sys_tz.tz_minuteswest * 60;
+	rtc_time_to_tm(time_value.tv_sec, &rtc_time_val);
+
+	(void)kbox_dump_painc_info
+		("Current time         : %04d-%02d-%02d %02d:%02d:%02d\n",
+		 rtc_time_val.tm_year + 1900, rtc_time_val.tm_mon + 1,
+		 rtc_time_val.tm_mday, rtc_time_val.tm_hour,
+		 rtc_time_val.tm_min, rtc_time_val.tm_sec);
+}
+
+void kbox_dump_event(enum kbox_error_type_e type, unsigned long event,
+		     const char *msg)
+{
+	if (!spin_trylock(&g_dump_lock))
+		return;
+
+	(void)kbox_dump_painc_info("\n====kbox begin dumping...====\n");
+
+	switch (type) {
+#ifdef CONFIG_X86
+	case KBOX_MCE_EVENT:
+
+		kbox_handle_mce_dump(msg);
+
+		break;
+#endif
+
+	case KBOX_OPPS_EVENT:
+
+		break;
+	case KBOX_PANIC_EVENT:
+		if (kbox_handle_panic_dump(msg) == KBOX_FALSE)
+			goto end;
+
+		break;
+	default:
+		break;
+	}
+
+	kbox_show_kernel_version();
+
+	kbox_show_version();
+
+	kbox_show_time_stamps();
+
+	(void)kbox_dump_painc_info("\n====kbox end dump====\n");
+
+	kbox_output_syslog_info();
+	kbox_output_printk_info();
+
+end:
+	spin_unlock(&g_dump_lock);
+}
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.h b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.h
new file mode 100644
index 000000000000..cba31377fbf3
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _KBOX_DUMP_H_
+#define _KBOX_DUMP_H_
+
+#define DUMPSTATE_MCE_RESET 1
+#define DUMPSTATE_OPPS_RESET 2
+#define DUMPSTATE_PANIC_RESET 3
+
+enum kbox_error_type_e {
+	KBOX_MCE_EVENT = 1,
+	KBOX_OPPS_EVENT,
+	KBOX_PANIC_EVENT
+};
+
+int kbox_dump_thread_info(const char *fmt, ...);
+void kbox_dump_event(enum kbox_error_type_e type, unsigned long event,
+		     const char *msg);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.c b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.c
new file mode 100644
index 000000000000..b2acdf24188b
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/notifier.h>
+#include "kbox_include.h"
+#include "kbox_dump.h"
+#include "kbox_hook.h"
+
+int panic_notify(struct notifier_block *this,
+		 unsigned long event, void *msg);
+
+static int die_notify(struct notifier_block *self,
+		      unsigned long val, void *data);
+
+static struct notifier_block g_panic_nb = {
+	.notifier_call = panic_notify,
+	.priority = 100,
+};
+
+static struct notifier_block g_die_nb = {
+	.notifier_call = die_notify,
+};
+
+int panic_notify(struct notifier_block *pthis, unsigned long event, void *msg)
+{
+	UNUSED(pthis);
+	UNUSED(event);
+
+	kbox_dump_event(KBOX_PANIC_EVENT, DUMPSTATE_PANIC_RESET,
+			(const char *)msg);
+
+	return NOTIFY_OK;
+}
+
+int die_notify(struct notifier_block *self, unsigned long val, void *data)
+{
+	struct kbox_die_args *args = (struct kbox_die_args *)data;
+
+	if (!args)
+		return NOTIFY_OK;
+
+	switch (val) {
+	case 1:
+		break;
+	case 5:
+		if (strcmp(args->str, "nmi") == 0)
+			return NOTIFY_OK;
+#ifdef CONFIG_X86
+		kbox_dump_event(KBOX_MCE_EVENT, DUMPSTATE_MCE_RESET, args->str);
+#endif
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+int kbox_register_hook(void)
+{
+	int ret = 0;
+
+	ret = atomic_notifier_chain_register(&panic_notifier_list, &g_panic_nb);
+	if (ret)
+		KBOX_MSG("atomic_notifier_chain_register g_panic_nb failed!\n");
+
+	ret = register_die_notifier(&g_die_nb);
+	if (ret)
+		KBOX_MSG("register_die_notifier g_die_nb failed!\n");
+
+	return ret;
+}
+
+void kbox_unregister_hook(void)
+{
+	int ret = 0;
+
+	ret =
+	    atomic_notifier_chain_unregister(&panic_notifier_list, &g_panic_nb);
+	if (ret < 0) {
+		KBOX_MSG
+		    ("atomic_notifier_chain_unregister g_panic_nb failed!\n");
+	}
+
+	ret = unregister_die_notifier(&g_die_nb);
+	if (ret < 0)
+		KBOX_MSG("unregister_die_notifier g_die_nb failed!\n");
+}
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.h b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.h
new file mode 100644
index 000000000000..00b3deb510b7
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _KBOX_PANIC_HOOK_H_
+#define _KBOX_PANIC_HOOK_H_
+
+struct kbox_die_args {
+	struct pt_regs *regs;
+	const char *str;
+	long err;
+	int trapnr;
+	int signr;
+};
+
+int register_die_notifier(struct notifier_block *nb);
+int unregister_die_notifier(struct notifier_block *nb);
+
+int kbox_register_hook(void);
+void kbox_unregister_hook(void);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_include.h b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_include.h
new file mode 100644
index 000000000000..d8424ea494b0
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_include.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _KBOX_INCLUDE_H_
+#define _KBOX_INCLUDE_H_
+
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/netdevice.h>
+
+#ifdef DRV_VERSION
+#define KBOX_VERSION MICRO_TO_STR(DRV_VERSION)
+#else
+#define KBOX_VERSION "0.3.4"
+#endif
+
+#define UNUSED(x) (x = x)
+#define KBOX_FALSE (-1)
+#define KBOX_TRUE 0
+
+#ifdef KBOX_DEBUG
+#define KBOX_MSG(fmt, args...) \
+	netdev_notice(0, "kbox: %s(), %d, " fmt, __func__, __LINE__, ## args)
+#else
+#define KBOX_MSG(fmt, args...)
+#endif
+
+#define BAD_FUNC_ADDR(x) ((0xFFFFFFFF == (x)) || (0 == (x)))
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.c b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.c
new file mode 100644
index 000000000000..374ce49d570e
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/processor.h>	/* for rdmsr and MSR_IA32_MCG_STATUS */
+#include <linux/fs.h>		/* everything... */
+#include <linux/file.h>		/* for fput */
+#include <linux/proc_fs.h>
+#include <linux/uaccess.h>		/* copy_*_user */
+#include <linux/version.h>
+#include "kbox_include.h"
+#include "kbox_panic.h"
+#include "kbox_main.h"
+#include "kbox_printk.h"
+#include "kbox_ram_image.h"
+#include "kbox_ram_op.h"
+#include "kbox_dump.h"
+#include "kbox_hook.h"
+#include "kbox_ram_drive.h"
+
+#ifdef CONFIG_X86
+#include <asm/msr.h>
+#include "kbox_mce.h"
+#endif
+
+#define KBOX_LOADED_FILE ("/proc/kbox")
+
+#define KBOX_ROOT_ENTRY_NAME ("kbox")
+
+static int kbox_is_loaded(void)
+{
+	struct file *fp = NULL;
+	mm_segment_t old_fs;
+
+	old_fs = get_fs();		/* save old flag */
+	set_fs(KERNEL_DS);	/* mark data from kernel space */
+
+	fp = filp_open(KBOX_LOADED_FILE, O_RDONLY, 0);
+
+	if (IS_ERR(fp)) {
+		set_fs(old_fs);
+		return KBOX_FALSE;
+	}
+
+	(void)filp_close(fp, NULL);
+
+	set_fs(old_fs);		/* restore old flag */
+
+	return KBOX_TRUE;
+}
+
+static int kbox_printk_proc_init(void)
+{
+	struct proc_dir_entry *kbox_entry = NULL;
+
+	if (kbox_is_loaded() != KBOX_TRUE) {
+		kbox_entry = proc_mkdir(KBOX_ROOT_ENTRY_NAME, NULL);
+		if (!kbox_entry) {
+			KBOX_MSG("can not create %s entry\n",
+				 KBOX_ROOT_ENTRY_NAME);
+			return -ENOMEM;
+		}
+	}
+
+	return KBOX_TRUE;
+}
+
+int __init kbox_init(void)
+{
+	int ret = KBOX_TRUE;
+	int kbox_proc_exist = 0;
+
+	if (!kbox_get_base_phy_addr())
+		return -ENXIO;
+
+	ret = kbox_super_block_init();
+	if (ret) {
+		KBOX_MSG("kbox_super_block_init failed!\n");
+		return ret;
+	}
+
+	if (kbox_is_loaded() == KBOX_TRUE)
+		kbox_proc_exist = 1;
+
+	ret = kbox_printk_init(kbox_proc_exist);
+	if (ret)
+		KBOX_MSG("kbox_printk_init failed!\n");
+
+	ret = kbox_panic_init();
+	if (ret) {
+		KBOX_MSG("kbox_panic_init failed!\n");
+		goto fail1;
+	}
+
+	ret = kbox_register_hook();
+	if (ret) {
+		KBOX_MSG("kbox_register_hook failed!\n");
+		goto fail2;
+	}
+
+#ifdef CONFIG_X86
+	(void)kbox_mce_init();
+#endif
+	ret = kbox_read_super_block();
+	if (ret) {
+		KBOX_MSG("update super block failed!\n");
+		goto fail3;
+	}
+
+	if (kbox_printk_proc_init() != 0) {
+		KBOX_MSG("kbox_printk_proc_init failed!\n");
+		goto fail4;
+	}
+
+	ret = kbox_drive_init();
+	if (ret) {
+		KBOX_MSG("kbox_drive_init failed!\n");
+		goto fail5;
+	}
+
+	return KBOX_TRUE;
+
+fail5:
+fail4:
+fail3:
+#ifdef CONFIG_X86
+	kbox_mce_exit();
+#endif
+	kbox_unregister_hook();
+fail2:
+	kbox_panic_exit();
+fail1:
+	kbox_printk_exit();
+
+	return ret;
+}
+
+void __exit kbox_cleanup(void)
+{
+	kbox_drive_cleanup();
+#ifdef CONFIG_X86
+	kbox_mce_exit();
+#endif
+	kbox_unregister_hook();
+	kbox_panic_exit();
+	kbox_printk_exit();
+}
+
+MODULE_AUTHOR("HUAWEI TECHNOLOGIES CO., LTD.");
+MODULE_DESCRIPTION("HUAWEI KBOX DRIVER");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(KBOX_VERSION);
+#ifndef _lint
+module_init(kbox_init);
+module_exit(kbox_cleanup);
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.h b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.h
new file mode 100644
index 000000000000..2ae02b736529
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _KBOX_MAIN_H_
+#define _KBOX_MAIN_H_
+
+#include "../edma_drv/bma_include.h"
+int kbox_init(void);
+void kbox_cleanup(void);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.c b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.c
new file mode 100644
index 000000000000..e9bd931b826e
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <linux/smp.h>
+#include <linux/notifier.h>
+#include <asm/mce.h>
+#include <asm/msr.h>
+
+#include "kbox_include.h"
+#include "kbox_mce.h"
+#include "kbox_dump.h"
+#include "kbox_printk.h"
+#include "kbox_panic.h"
+
+enum context {
+	KBOX_IN_KERNEL = 1, KBOX_IN_USER = 2
+};
+
+enum ser {
+	KBOX_SER_REQUIRED = 1, KBOX_NO_SER = 2
+};
+
+enum severity_level {
+	KBOX_MCE_NO_SEVERITY,
+	KBOX_MCE_KEEP_SEVERITY,
+	KBOX_MCE_SOME_SEVERITY,
+	KBOX_MCE_AO_SEVERITY,
+	KBOX_MCE_UC_SEVERITY,
+	KBOX_MCE_AR_SEVERITY,
+	KBOX_MCE_PANIC_SEVERITY,
+};
+
+static struct severity {
+	u64 kbox_mask;
+	u64 kbox_result;
+	unsigned char kbox_sev;
+	unsigned char kbox_mcgmask;
+	unsigned char kbox_mcgres;
+	unsigned char kbox_ser;
+	unsigned char kbox_context;
+	unsigned char kbox_covered;
+	char *kbox_msg;
+} kbox_severities[] = {
+#define KBOX_KERNEL .kbox_context = KBOX_IN_KERNEL
+#define KBOX_USER .kbox_context = KBOX_IN_USER
+#define KBOX_SER .kbox_ser      = KBOX_SER_REQUIRED
+#define KBOX_NOSER .kbox_ser    = KBOX_NO_SER
+#define KBOX_SEV(s) .kbox_sev   = KBOX_MCE_ ## s ## _SEVERITY
+#define KBOX_BITCLR(x, s, m, r...) \
+	{ .kbox_mask = x, .kbox_result = 0, KBOX_SEV(s), .kbox_msg = m, ## r }
+#define KBOX_BITSET(x, s, m, r...) \
+	{ .kbox_mask = x, .kbox_result = x, KBOX_SEV(s), .kbox_msg = m, ## r }
+#define KBOX_MCGMASK(x, res, s, m, r...) \
+	{ .kbox_mcgmask = x, .kbox_mcgres = res, KBOX_SEV(s),   \
+	  .kbox_msg = m, ## r }
+#define KBOX_MASK(x, y, s, m, r...) \
+	{ .kbox_mask = x, .kbox_result = y, KBOX_SEV(s), .kbox_msg = m, ## r }
+#define KBOX_MCI_UC_S (MCI_STATUS_UC | MCI_STATUS_S)
+#define KBOX_MCI_UC_SAR (MCI_STATUS_UC | MCI_STATUS_S | MCI_STATUS_AR)
+#define KBOX_MCACOD 0xffff
+
+KBOX_BITCLR(MCI_STATUS_VAL, NO, "Invalid"),
+KBOX_BITCLR(MCI_STATUS_EN, NO, "Not enabled"),
+KBOX_BITSET(MCI_STATUS_PCC, PANIC, "Processor context corrupt"),
+
+KBOX_MCGMASK(MCG_STATUS_MCIP, 0, PANIC, "MCIP not set in MCA handler"),
+
+KBOX_MCGMASK(MCG_STATUS_RIPV | MCG_STATUS_EIPV, 0, PANIC,
+	     "Neither restart nor error IP"),
+KBOX_MCGMASK(MCG_STATUS_RIPV, 0, PANIC, "In kernel and no restart IP",
+	     KBOX_KERNEL),
+KBOX_BITCLR(MCI_STATUS_UC, KEEP, "Corrected error", KBOX_NOSER),
+KBOX_MASK(MCI_STATUS_OVER | MCI_STATUS_UC | MCI_STATUS_EN, MCI_STATUS_UC, SOME,
+	  "Spurious not enabled", KBOX_SER),
+
+KBOX_MASK(KBOX_MCI_UC_SAR, MCI_STATUS_UC, KEEP,
+	  "Uncorrected no action required", KBOX_SER),
+KBOX_MASK(MCI_STATUS_OVER | KBOX_MCI_UC_SAR, MCI_STATUS_UC | MCI_STATUS_AR,
+	  PANIC, "Illegal combination (UCNA with AR=1)", KBOX_SER),
+KBOX_MASK(MCI_STATUS_S, 0, KEEP, "Non signalled machine check", KBOX_SER),
+
+KBOX_MASK(MCI_STATUS_OVER | KBOX_MCI_UC_SAR, MCI_STATUS_OVER | KBOX_MCI_UC_SAR,
+	  PANIC, "Action required with lost events", KBOX_SER),
+KBOX_MASK(MCI_STATUS_OVER | KBOX_MCI_UC_SAR | KBOX_MCACOD, KBOX_MCI_UC_SAR,
+	  PANIC, "Action required; unknown MCACOD", KBOX_SER),
+
+KBOX_MASK(KBOX_MCI_UC_SAR | MCI_STATUS_OVER | 0xfff0, KBOX_MCI_UC_S | 0xc0,
+	  AO, "Action optional: memory scrubbing error", KBOX_SER),
+KBOX_MASK(KBOX_MCI_UC_SAR | MCI_STATUS_OVER | KBOX_MCACOD,
+	  KBOX_MCI_UC_S | 0x17a, AO,
+	"Action optional: last level cache writeback error", KBOX_SER),
+
+KBOX_MASK(MCI_STATUS_OVER | KBOX_MCI_UC_SAR, KBOX_MCI_UC_S, SOME,
+	  "Action optional unknown MCACOD", KBOX_SER),
+KBOX_MASK(MCI_STATUS_OVER | KBOX_MCI_UC_SAR, KBOX_MCI_UC_S | MCI_STATUS_OVER,
+	  SOME, "Action optional with lost events", KBOX_SER),
+KBOX_BITSET(MCI_STATUS_UC | MCI_STATUS_OVER, PANIC, "Overflowed uncorrected"),
+KBOX_BITSET(MCI_STATUS_UC, UC, "Uncorrected"),
+KBOX_BITSET(0, SOME, "No match")
+};
+
+static unsigned int g_kbox_nr_mce_banks;
+static unsigned int g_kbox_mce_ser;
+static atomic_t g_mce_dump_state = ATOMIC_INIT(0);
+
+static int kbox_mce_severity(u64 mcgstatus, u64 status)
+{
+	struct severity *s;
+
+	for (s = kbox_severities;; s++) {
+		if ((status & s->kbox_mask) != s->kbox_result)
+			continue;
+
+		if ((mcgstatus & s->kbox_mcgmask) != s->kbox_mcgres)
+			continue;
+
+		if (s->kbox_ser == KBOX_SER_REQUIRED && !g_kbox_mce_ser)
+			continue;
+
+		if (s->kbox_ser == KBOX_NO_SER && g_kbox_mce_ser)
+			continue;
+
+		break;
+	}
+
+	return s->kbox_sev;
+}
+
+static u64 kbox_mce_rdmsrl(u32 ulmsr)
+{
+	u64 ullv = 0;
+
+	if (rdmsrl_safe(ulmsr, &ullv)) {
+		(void)kbox_dump_painc_info("mce: Unable to read msr %d!\n",
+					   ulmsr);
+		ullv = 0;
+	}
+
+	return ullv;
+}
+
+static int kbox_intel_machine_check(void)
+{
+	unsigned int idx = 0;
+	u64 mcgstatus = 0;
+	int worst = 0;
+
+	mcgstatus = kbox_mce_rdmsrl(MSR_IA32_MCG_STATUS);
+
+	(void)
+	    kbox_dump_painc_info
+	    ("CPU %d: Machine Check Exception MCG STATUS: 0x%016llx\n",
+	     smp_processor_id(), mcgstatus);
+
+	if (!(mcgstatus & MCG_STATUS_RIPV))
+		(void)kbox_dump_painc_info("Unable to continue\n");
+
+	for (idx = 0; idx < g_kbox_nr_mce_banks; idx++) {
+		u64 status = 0;
+		u64 misc = 0;
+		u64 addr = 0;
+		int lseverity = 0;
+
+		status = kbox_mce_rdmsrl(MSR_IA32_MCx_STATUS(idx));
+
+		(void)kbox_dump_painc_info("Bank %d STATUS: 0x%016llx\n", idx,
+					   status);
+
+		if (0 == (status & MCI_STATUS_VAL))
+			continue;
+
+		lseverity = kbox_mce_severity(mcgstatus, status);
+		if (lseverity == KBOX_MCE_KEEP_SEVERITY ||
+		    lseverity == KBOX_MCE_NO_SEVERITY)
+			continue;
+
+		(void)kbox_dump_painc_info("severity = %d\n", lseverity);
+
+		if (status & MCI_STATUS_MISCV) {
+			misc = kbox_mce_rdmsrl(MSR_IA32_MCx_MISC(idx));
+			(void)kbox_dump_painc_info("misc = 0x%016llx\n", misc);
+		}
+
+		if (status & MCI_STATUS_ADDRV) {
+			addr = kbox_mce_rdmsrl(MSR_IA32_MCx_ADDR(idx));
+			(void)kbox_dump_painc_info("addr = 0x%016llx\n", addr);
+		}
+
+		(void)kbox_dump_painc_info("\n");
+
+		if (lseverity > worst)
+			worst = lseverity;
+	}
+
+	if (worst >= KBOX_MCE_UC_SEVERITY)
+		return KBOX_FALSE;
+
+	(void)kbox_dump_painc_info("Attempting to continue.\n");
+
+	return KBOX_TRUE;
+}
+
+int kbox_handle_mce_dump(const char *msg)
+{
+	int mce_recoverable = KBOX_FALSE;
+
+	atomic_read(&g_mce_dump_state);
+
+	mce_recoverable = kbox_intel_machine_check();
+	if (mce_recoverable != KBOX_TRUE) {
+		static atomic_t mce_entry_tmp;
+		int flag = atomic_add_return(1, &mce_entry_tmp);
+
+		if (flag != 1)
+			return KBOX_FALSE;
+	}
+
+	atomic_set(&g_mce_dump_state, DUMPSTATE_MCE_RESET);
+
+	if (msg) {
+		(void)
+		    kbox_dump_painc_info
+		    ("-------[ System may reset by %s! ]-------\n\n", msg);
+	}
+
+	return KBOX_TRUE;
+}
+
+int kbox_mce_init(void)
+{
+	u64 cap = 0;
+
+	cap = kbox_mce_rdmsrl(MSR_IA32_MCG_CAP);
+	g_kbox_nr_mce_banks = cap & MCG_BANKCNT_MASK;
+
+	if (cap & MCG_SER_P)
+		g_kbox_mce_ser = 1;
+
+	KBOX_MSG("get nr_mce_banks:%d, g_kbox_mce_ser = %d, cap = 0x%016llx\n",
+		 g_kbox_nr_mce_banks, g_kbox_mce_ser, cap);
+
+	return KBOX_TRUE;
+}
+
+void kbox_mce_exit(void)
+{
+	g_kbox_nr_mce_banks = 0;
+	g_kbox_mce_ser = 0;
+}
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.h b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.h
new file mode 100644
index 000000000000..00d3b787c140
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _KBOX_MCE_H_
+#define _KBOX_MCE_H_
+
+int kbox_handle_mce_dump(const char *msg);
+int kbox_mce_init(void);
+void kbox_mce_exit(void);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.c b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.c
new file mode 100644
index 000000000000..0c17cd2bae49
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <asm/types.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include "kbox_include.h"
+#include "kbox_panic.h"
+#include "kbox_ram_op.h"
+
+#ifdef CONFIG_X86
+#include <asm/msr.h>
+#endif
+
+#define PANIC_TMP_BUF_SIZE 256
+
+static int g_panic_init_ok = KBOX_FALSE;
+
+static char *g_panic_info_buf_tmp;
+static char *g_panic_info_buf;
+
+static unsigned int g_panic_info_start;
+
+static unsigned int g_panic_info_end;
+
+static unsigned int g_panic_info_len;
+
+static DEFINE_SPINLOCK(g_panic_buf_lock);
+
+static void kbox_emit_syslog_char(const char c)
+{
+	if (unlikely(!g_panic_info_buf))
+		return;
+
+	*(g_panic_info_buf + (g_panic_info_end % SLOT_LENGTH)) = c;
+	g_panic_info_end++;
+
+	if (g_panic_info_end > SLOT_LENGTH)
+		g_panic_info_start++;
+
+	if (g_panic_info_len < SLOT_LENGTH)
+		g_panic_info_len++;
+}
+
+static int kbox_duplicate_syslog_info(const char *syslog_buf,
+				      unsigned int buf_len)
+{
+	unsigned int idx = 0;
+	unsigned long flags = 0;
+
+	if (!syslog_buf)
+		return 0;
+
+	spin_lock_irqsave(&g_panic_buf_lock, flags);
+
+	for (idx = 0; idx < buf_len; idx++)
+		kbox_emit_syslog_char(*syslog_buf++);
+
+	spin_unlock_irqrestore(&g_panic_buf_lock, flags);
+
+	return buf_len;
+}
+
+int kbox_dump_painc_info(const char *fmt, ...)
+{
+	va_list args;
+	int num = 0;
+	char tmp_buf[PANIC_TMP_BUF_SIZE] = { };
+
+	va_start(args, fmt);
+
+	num = vsnprintf(tmp_buf, sizeof(tmp_buf) - 1, fmt, args);
+	if (num >= 0)
+		(void)kbox_duplicate_syslog_info(tmp_buf, num);
+
+	va_end(args);
+
+	return num;
+}
+
+void kbox_output_syslog_info(void)
+{
+	unsigned int start_tmp = 0;
+	unsigned int end_tmp = 0;
+	unsigned int len_tmp = 0;
+	unsigned long flags = 0;
+
+	if (unlikely
+	    (!g_panic_info_buf || !g_panic_info_buf_tmp))
+		return;
+
+	spin_lock_irqsave(&g_panic_buf_lock, flags);
+	if (g_panic_info_len == 0) {
+		spin_unlock_irqrestore(&g_panic_buf_lock, flags);
+		return;
+	}
+
+	start_tmp = (g_panic_info_start % SLOT_LENGTH);
+	end_tmp = ((g_panic_info_end - 1) % SLOT_LENGTH);
+	len_tmp = g_panic_info_len;
+
+	if (start_tmp > end_tmp) {
+		memcpy(g_panic_info_buf_tmp,
+		       (g_panic_info_buf + start_tmp),
+			len_tmp - start_tmp);
+		memcpy((g_panic_info_buf_tmp + len_tmp - start_tmp),
+		       g_panic_info_buf,
+			end_tmp + 1);
+	} else {
+		memcpy(g_panic_info_buf_tmp,
+		       (char *)(g_panic_info_buf + start_tmp),
+			len_tmp);
+	}
+
+	spin_unlock_irqrestore(&g_panic_buf_lock, flags);
+
+	(void)kbox_write_panic_info(g_panic_info_buf_tmp, len_tmp);
+}
+
+int kbox_panic_init(void)
+{
+	int ret = KBOX_TRUE;
+
+	g_panic_info_buf = kmalloc(SLOT_LENGTH, GFP_KERNEL);
+	if (IS_ERR(g_panic_info_buf) || !g_panic_info_buf) {
+		KBOX_MSG("kmalloc g_panic_info_buf fail!\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	memset(g_panic_info_buf, 0, SLOT_LENGTH);
+
+	g_panic_info_buf_tmp = kmalloc(SLOT_LENGTH, GFP_KERNEL);
+	if (IS_ERR(g_panic_info_buf_tmp) || !g_panic_info_buf_tmp) {
+		KBOX_MSG("kmalloc g_panic_info_buf_tmp fail!\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	memset(g_panic_info_buf_tmp, 0, SLOT_LENGTH);
+
+	g_panic_init_ok = KBOX_TRUE;
+
+	return ret;
+fail:
+
+	kfree(g_panic_info_buf);
+	g_panic_info_buf = NULL;
+
+	kfree(g_panic_info_buf_tmp);
+	g_panic_info_buf_tmp = NULL;
+
+	return ret;
+}
+
+void kbox_panic_exit(void)
+{
+	if (g_panic_init_ok != KBOX_TRUE)
+		return;
+
+	kfree(g_panic_info_buf);
+	g_panic_info_buf = NULL;
+
+	kfree(g_panic_info_buf_tmp);
+	g_panic_info_buf_tmp = NULL;
+}
+
+int kbox_handle_panic_dump(const char *msg)
+{
+	if (msg)
+		(void)kbox_dump_painc_info("panic string: %s\n", msg);
+
+	return KBOX_TRUE;
+}
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.h b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.h
new file mode 100644
index 000000000000..5715b66c0659
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _KBOX_PANIC_H_
+#define _KBOX_PANIC_H_
+
+int kbox_handle_panic_dump(const char *msg);
+void kbox_output_syslog_info(void);
+int kbox_dump_painc_info(const char *fmt, ...);
+int kbox_panic_init(void);
+void kbox_panic_exit(void);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.c b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.c
new file mode 100644
index 000000000000..969c0c0cc630
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.c
@@ -0,0 +1,362 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/console.h>		/* struct console */
+#include <linux/slab.h>
+#include <linux/err.h>
+#include "kbox_include.h"
+#include "kbox_main.h"
+#include "kbox_printk.h"
+#include "kbox_ram_image.h"
+#include "kbox_ram_op.h"
+
+#define TMP_BUF_SIZE 256
+
+static int g_printk_init_ok = KBOX_FALSE;
+static char *g_printk_info_buf;
+static char *g_printk_info_buf_tmp;
+static struct printk_ctrl_block_tmp_s g_printk_ctrl_block_tmp = { };
+
+static DEFINE_SPINLOCK(g_printk_buf_lock);
+
+static void kbox_printk_info_write(struct console *console,
+				   const char *printk_buf,
+				   unsigned int buf_len);
+
+static struct console g_printk_console = {
+	.name = "k_prtk",
+	.flags = CON_ENABLED | CON_PRINTBUFFER,
+	.write = kbox_printk_info_write,
+};
+
+static int kbox_printk_format_is_order(struct printk_info_ctrl_block_s *
+				       printk_ctrl_blk_first,
+				       struct printk_info_ctrl_block_s *
+				       printk_ctrl_blk_second)
+{
+	if (!printk_ctrl_blk_first || !printk_ctrl_blk_second)
+		return KBOX_FALSE;
+
+	if (!memcmp(printk_ctrl_blk_first->flag, PRINTK_CURR_FLAG,
+		    PRINTK_FLAG_LEN) &&
+	    !memcmp(printk_ctrl_blk_second->flag, PRINTK_LAST_FLAG,
+		       PRINTK_FLAG_LEN)) {
+		return KBOX_TRUE;
+	}
+
+	return KBOX_FALSE;
+}
+
+static void kbox_printk_format(struct printk_info_ctrl_block_s *printk_ctrl_blk,
+			       const unsigned int len, const char *flag)
+{
+	if (!printk_ctrl_blk || !flag)
+		return;
+
+	memset(printk_ctrl_blk, 0, len);
+	memcpy(printk_ctrl_blk->flag, flag, PRINTK_FLAG_LEN);
+}
+
+static void kbox_printk_init_info_first
+				(struct image_super_block_s *kbox_super_block)
+{
+	KBOX_MSG("\n");
+	if (kbox_printk_format_is_order(kbox_super_block->printk_ctrl_blk,
+					kbox_super_block->printk_ctrl_blk +
+					1) == KBOX_TRUE) {
+		memcpy(kbox_super_block->printk_ctrl_blk[0].flag,
+		       PRINTK_LAST_FLAG, PRINTK_FLAG_LEN);
+		memcpy(kbox_super_block->printk_ctrl_blk[1].flag,
+		       PRINTK_CURR_FLAG, PRINTK_FLAG_LEN);
+		kbox_super_block->printk_ctrl_blk[1].len = 0;
+		g_printk_ctrl_block_tmp.printk_region = 1;
+		g_printk_ctrl_block_tmp.section = KBOX_SECTION_PRINTK2;
+		(void)kbox_clear_region(KBOX_SECTION_PRINTK2);
+	} else if (kbox_printk_format_is_order
+			(kbox_super_block->printk_ctrl_blk + 1,
+			kbox_super_block->printk_ctrl_blk) == KBOX_TRUE) {
+		memcpy(kbox_super_block->printk_ctrl_blk[1].flag,
+		       PRINTK_LAST_FLAG,
+			PRINTK_FLAG_LEN);
+		memcpy(kbox_super_block->printk_ctrl_blk[0].flag,
+		       PRINTK_CURR_FLAG,
+			PRINTK_FLAG_LEN);
+
+		kbox_super_block->printk_ctrl_blk[0].len = 0;
+		g_printk_ctrl_block_tmp.printk_region = 0;
+		g_printk_ctrl_block_tmp.section = KBOX_SECTION_PRINTK1;
+		(void)kbox_clear_region(KBOX_SECTION_PRINTK1);
+	} else {
+		kbox_printk_format(kbox_super_block->printk_ctrl_blk,
+				   sizeof(struct printk_info_ctrl_block_s),
+				   PRINTK_CURR_FLAG);
+		kbox_printk_format(kbox_super_block->printk_ctrl_blk + 1,
+				   sizeof(struct printk_info_ctrl_block_s),
+				   PRINTK_LAST_FLAG);
+		g_printk_ctrl_block_tmp.printk_region = 0;
+		g_printk_ctrl_block_tmp.section = KBOX_SECTION_PRINTK1;
+		(void)kbox_clear_region(KBOX_SECTION_PRINTK1);
+		(void)kbox_clear_region(KBOX_SECTION_PRINTK2);
+	}
+
+	g_printk_ctrl_block_tmp.start = 0;
+	g_printk_ctrl_block_tmp.end = 0;
+	g_printk_ctrl_block_tmp.valid_len = 0;
+}
+
+static void kbox_printk_init_info_not_first
+				(struct image_super_block_s *kbox_super_block)
+{
+	KBOX_MSG("\n");
+	if (KBOX_TRUE ==
+	    kbox_printk_format_is_order(kbox_super_block->printk_ctrl_blk,
+					kbox_super_block->printk_ctrl_blk +
+					1)) {
+		g_printk_ctrl_block_tmp.printk_region = 0;
+		g_printk_ctrl_block_tmp.section = KBOX_SECTION_PRINTK1;
+
+	} else if (KBOX_TRUE ==
+		   kbox_printk_format_is_order
+		   (kbox_super_block->printk_ctrl_blk + 1,
+		   kbox_super_block->printk_ctrl_blk)) {
+		g_printk_ctrl_block_tmp.printk_region = 1;
+		g_printk_ctrl_block_tmp.section = KBOX_SECTION_PRINTK2;
+
+	} else {
+		kbox_printk_format(kbox_super_block->printk_ctrl_blk,
+				   sizeof(struct printk_info_ctrl_block_s),
+				   PRINTK_CURR_FLAG);
+		kbox_printk_format(kbox_super_block->printk_ctrl_blk + 1,
+				   sizeof(struct printk_info_ctrl_block_s),
+				   PRINTK_LAST_FLAG);
+		g_printk_ctrl_block_tmp.printk_region = 0;
+		g_printk_ctrl_block_tmp.section = KBOX_SECTION_PRINTK1;
+		(void)kbox_clear_region(KBOX_SECTION_PRINTK1);
+		(void)kbox_clear_region(KBOX_SECTION_PRINTK2);
+	}
+
+	g_printk_ctrl_block_tmp.start = 0;
+}
+
+static int kbox_printk_init_info(int kbox_proc_exist)
+{
+	struct image_super_block_s kbox_super_block = { };
+	unsigned int read_len = 0;
+	unsigned int write_len = 0;
+
+	read_len =
+	    kbox_read_from_ram(SECTION_KERNEL_OFFSET,
+			       (unsigned int)sizeof(struct image_super_block_s),
+			       (char *)&kbox_super_block, KBOX_SECTION_KERNEL);
+	if (read_len != sizeof(struct image_super_block_s)) {
+		KBOX_MSG("fail to get superblock data!\n");
+		return KBOX_FALSE;
+	}
+
+	if (kbox_proc_exist) {
+		kbox_printk_init_info_not_first(&kbox_super_block);
+		if (KBOX_TRUE !=
+		    kbox_read_printk_info(g_printk_info_buf,
+					  &g_printk_ctrl_block_tmp)) {
+			g_printk_ctrl_block_tmp.end = 0;
+			g_printk_ctrl_block_tmp.valid_len = 0;
+		}
+	} else {
+		kbox_printk_init_info_first(&kbox_super_block);
+	}
+
+	kbox_super_block.checksum = 0;
+	kbox_super_block.checksum =
+	    ~((unsigned char)
+	      kbox_checksum((char *)&kbox_super_block,
+			    (unsigned int)sizeof(kbox_super_block))) + 1;
+	write_len =
+	    kbox_write_to_ram(SECTION_KERNEL_OFFSET,
+			      (unsigned int)sizeof(struct image_super_block_s),
+			      (char *)&kbox_super_block, KBOX_SECTION_KERNEL);
+	if (write_len <= 0) {
+		KBOX_MSG("fail to write superblock data!\n");
+		return KBOX_FALSE;
+	}
+
+	return KBOX_TRUE;
+}
+
+void kbox_output_printk_info(void)
+{
+	unsigned int start_tmp = 0;
+	unsigned int end_tmp = 0;
+	unsigned int len_tmp = 0;
+	unsigned long flags = 0;
+
+	if (unlikely(!g_printk_info_buf || !g_printk_info_buf_tmp))
+		return;
+
+	if (g_printk_init_ok != KBOX_TRUE)
+		return;
+
+	spin_lock_irqsave(&g_printk_buf_lock, flags);
+	if (g_printk_ctrl_block_tmp.valid_len == 0) {
+		spin_unlock_irqrestore(&g_printk_buf_lock, flags);
+		return;
+	}
+
+	start_tmp = (g_printk_ctrl_block_tmp.start % SECTION_PRINTK_LEN);
+	end_tmp = ((g_printk_ctrl_block_tmp.end - 1) % SECTION_PRINTK_LEN);
+	len_tmp = g_printk_ctrl_block_tmp.valid_len;
+
+	if (start_tmp > end_tmp) {
+		memcpy(g_printk_info_buf_tmp,
+		       g_printk_info_buf + start_tmp,
+			len_tmp - start_tmp);
+		memcpy(g_printk_info_buf_tmp + len_tmp - start_tmp,
+		       g_printk_info_buf,
+			end_tmp + 1);
+		memcpy(g_printk_info_buf_tmp,
+		       g_printk_info_buf + start_tmp,
+			len_tmp);
+	}
+
+	spin_unlock_irqrestore(&g_printk_buf_lock, flags);
+
+	(void)kbox_write_printk_info(g_printk_info_buf_tmp,
+				     &g_printk_ctrl_block_tmp);
+}
+
+static void kbox_emit_printk_char(const char c)
+{
+	if (unlikely(!g_printk_info_buf))
+		return;
+
+	*(g_printk_info_buf +
+	  (g_printk_ctrl_block_tmp.end % SECTION_PRINTK_LEN)) = c;
+	g_printk_ctrl_block_tmp.end++;
+
+	if (g_printk_ctrl_block_tmp.end > SECTION_PRINTK_LEN)
+		g_printk_ctrl_block_tmp.start++;
+
+	if (g_printk_ctrl_block_tmp.end < SECTION_PRINTK_LEN)
+		g_printk_ctrl_block_tmp.valid_len++;
+}
+
+static int kbox_duplicate_printk_info(const char *printk_buf,
+				      unsigned int buf_len)
+{
+	unsigned int idx = 0;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&g_printk_buf_lock, flags);
+	for (idx = 0; idx < buf_len; idx++)
+		kbox_emit_printk_char(*printk_buf++);
+
+	spin_unlock_irqrestore(&g_printk_buf_lock, flags);
+
+	return buf_len;
+}
+
+int kbox_dump_printk_info(const char *fmt, ...)
+{
+	va_list args;
+	int num = 0;
+	char tmp_buf[TMP_BUF_SIZE] = { };
+
+	if (g_printk_init_ok != KBOX_TRUE)
+		return 0;
+
+	va_start(args, fmt);
+	num = vsnprintf(tmp_buf, sizeof(tmp_buf) - 1, fmt, args);
+	if (num >= 0)
+		(void)kbox_duplicate_printk_info(tmp_buf, num);
+
+	va_end(args);
+
+	return num;
+}
+
+static void kbox_printk_info_write(struct console *pconsole,
+				   const char *printk_buf, unsigned int buf_len)
+{
+	UNUSED(pconsole);
+
+	if (unlikely(!printk_buf))
+		return;
+
+	(void)kbox_duplicate_printk_info(printk_buf, buf_len);
+}
+
+int kbox_printk_init(int kbox_proc_exist)
+{
+	int ret = KBOX_TRUE;
+
+	g_printk_info_buf = kmalloc(SECTION_PRINTK_LEN,
+				    GFP_KERNEL);
+	if (IS_ERR(g_printk_info_buf) || !g_printk_info_buf) {
+		KBOX_MSG("kmalloc g_printk_info_buf fail!\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	memset(g_printk_info_buf, 0, SECTION_PRINTK_LEN);
+
+	g_printk_info_buf_tmp = kmalloc(SECTION_PRINTK_LEN,
+					GFP_KERNEL);
+	if (IS_ERR(g_printk_info_buf_tmp) || !g_printk_info_buf_tmp) {
+		KBOX_MSG("kmalloc g_printk_info_buf_tmp fail!\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	memset(g_printk_info_buf_tmp, 0, SECTION_PRINTK_LEN);
+
+	ret = kbox_printk_init_info(kbox_proc_exist);
+	if (ret != KBOX_TRUE) {
+		KBOX_MSG("kbox_printk_init_info failed!\n");
+		goto fail;
+	}
+
+	register_console(&g_printk_console);
+
+	g_printk_init_ok = KBOX_TRUE;
+
+	return ret;
+fail:
+
+	kfree(g_printk_info_buf);
+	g_printk_info_buf = NULL;
+
+	kfree(g_printk_info_buf_tmp);
+	g_printk_info_buf_tmp = NULL;
+
+	return ret;
+}
+
+void kbox_printk_exit(void)
+{
+	int ret = 0;
+
+	if (g_printk_init_ok != KBOX_TRUE)
+		return;
+
+	kfree(g_printk_info_buf);
+	g_printk_info_buf = NULL;
+
+	kfree(g_printk_info_buf_tmp);
+	g_printk_info_buf_tmp = NULL;
+
+	ret = unregister_console(&g_printk_console);
+	if (ret)
+		KBOX_MSG("unregister_console failed!\n");
+}
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.h b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.h
new file mode 100644
index 000000000000..cece825626a8
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _KBOX_PRINTK_H_
+#define _KBOX_PRINTK_H_
+#include "kbox_ram_image.h"
+
+struct printk_ctrl_block_tmp_s {
+	int printk_region;
+	enum kbox_section_e section;
+	unsigned int start;
+	unsigned int end;
+	unsigned int valid_len;/* valid length of printk section */
+};
+
+int  kbox_printk_init(int kbox_proc_exist);
+void kbox_output_printk_info(void);
+int  kbox_dump_printk_info(const char *fmt, ...);
+void kbox_printk_exit(void);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive.c b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive.c
new file mode 100644
index 000000000000..829e2a498843
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive.c
@@ -0,0 +1,188 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/fs.h>		/* everything... */
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <asm/ioctls.h>
+#include <linux/slab.h>
+#include "kbox_include.h"
+#include "kbox_ram_drive.h"
+#include "kbox_main.h"
+#include "kbox_ram_image.h"
+#include "kbox_ram_op.h"
+
+#define KBOX_DEVICE_NAME "kbox"
+#define KBOX_DEVICE_MINOR 255
+
+static struct kbox_dev_s *g_kbox_dev;
+static ssize_t kbox_read(struct file *filp, char __user *data, size_t count,
+			 loff_t *ppos);
+static ssize_t kbox_write(struct file *filp, const char __user *data,
+			  size_t count, loff_t *ppos);
+
+static long kbox_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+static int kbox_mmap(struct file *filp, struct vm_area_struct *vma);
+static int kbox_open(struct inode *inode, struct file *filp);
+static int kbox_release(struct inode *inode, struct file *filp);
+
+const struct file_operations kbox_fops = {
+	.owner = THIS_MODULE,
+	.read = kbox_read,
+	.write = kbox_write,
+	.unlocked_ioctl = kbox_ioctl,
+	.mmap = kbox_mmap,
+	.open = kbox_open,
+	.release = kbox_release,
+};
+
+static struct miscdevice kbox_device = {
+	KBOX_DEVICE_MINOR,
+	KBOX_DEVICE_NAME,
+	&kbox_fops,
+};
+
+static ssize_t kbox_read(struct file *filp, char __user *data, size_t count,
+			 loff_t *ppos)
+{
+	int read_len = 0;
+
+	if (!filp || !data || !ppos) {
+		KBOX_MSG("input NULL point!\n");
+		return -EFAULT;
+	}
+
+	read_len = kbox_read_op((long long)(*ppos),
+				count,
+				data,
+				KBOX_SECTION_USER);
+	if (read_len < 0)
+		return -EFAULT;
+
+	*ppos += read_len;
+
+	return read_len;
+}
+
+static ssize_t kbox_write(struct file *filp, const char __user *data,
+			  size_t count, loff_t *ppos)
+{
+	int write_len = 0;
+
+	if (!filp || !data || !ppos) {
+		KBOX_MSG("input NULL point!\n");
+		return -EFAULT;
+	}
+
+	write_len = kbox_write_op((long long)(*ppos),
+				  count, data, KBOX_SECTION_USER);
+	if (write_len < 0)
+		return -EFAULT;
+
+	*ppos += write_len;
+
+	return write_len;
+}
+
+static long kbox_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	UNUSED(filp);
+
+	if (kbox_ioctl_detail(cmd, arg) < 0)
+		return -ENOTTY;
+
+	return 0;
+}
+
+static int kbox_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	if (!filp || !vma) {
+		KBOX_MSG("input NULL point!\n");
+		return -EFAULT;
+	}
+
+	if (kbox_mmap_ram(filp, vma, KBOX_SECTION_USER) < 0)
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kbox_open(struct inode *pinode, struct file *filp)
+{
+	UNUSED(pinode);
+
+	if ((g_kbox_dev) && (!atomic_dec_and_test(&g_kbox_dev->au_count))) {
+		atomic_inc(&g_kbox_dev->au_count);
+		KBOX_MSG("EBUSY\n");
+		return -EBUSY;
+	}
+
+	filp->private_data = (void *)g_kbox_dev;
+
+	return 0;
+}
+
+int kbox_release(struct inode *pinode, struct file *filp)
+{
+	struct kbox_dev_s *kbox_dev = (struct kbox_dev_s *)filp->private_data;
+
+	UNUSED(pinode);
+
+	KBOX_MSG("\n");
+
+	if (kbox_dev)
+		atomic_inc(&kbox_dev->au_count);
+
+	return 0;
+}
+
+int kbox_drive_init(void)
+{
+	int ret = 0;
+
+	KBOX_MSG("\n");
+
+	g_kbox_dev =
+	    kmalloc(sizeof(struct kbox_dev_s), GFP_KERNEL);
+	if (!g_kbox_dev)
+		return -ENOMEM;
+
+	ret = misc_register(&kbox_device);
+	if (ret)
+		goto fail;
+
+	atomic_set(&g_kbox_dev->au_count, 1);
+
+	KBOX_MSG("ok!\n");
+
+	return ret;
+
+fail:
+	kfree(g_kbox_dev);
+	g_kbox_dev = NULL;
+
+	return ret;
+}
+
+void kbox_drive_cleanup(void)
+{
+	if (!g_kbox_dev)
+		return;
+
+	misc_deregister(&kbox_device);
+
+	kfree(g_kbox_dev);
+	g_kbox_dev = NULL;
+}
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive.h b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive.h
new file mode 100644
index 000000000000..52707c4b82c5
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _KBOX_RAM_DRIVE_H_
+#define _KBOX_RAM_DRIVE_H_
+
+#include <linux/types.h>
+#include <linux/atomic.h>
+
+struct kbox_dev_s {
+	atomic_t au_count;
+
+	struct kbox_pci_dev_s *kbox_pci_dev;
+};
+
+int kbox_drive_init(void);
+void kbox_drive_cleanup(void);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image.c b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image.c
new file mode 100644
index 000000000000..f57083261983
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "kbox_include.h"
+#include "kbox_main.h"
+#include "kbox_ram_image.h"
+
+void __iomem *kbox_get_section_addr(enum kbox_section_e  kbox_section)
+{
+	void __iomem *kbox_addr = kbox_get_base_addr();
+	unsigned long kbox_len = kbox_get_io_len();
+
+	if (!kbox_addr || kbox_len == 0) {
+		KBOX_MSG("get kbox_addr or kbox_len failed!\n");
+		return NULL;
+	}
+
+	switch (kbox_section) {
+	case KBOX_SECTION_KERNEL:
+		return kbox_addr;
+
+	case KBOX_SECTION_PANIC:
+		return kbox_addr + SECTION_KERNEL_LEN;
+
+	case KBOX_SECTION_THREAD:
+		return kbox_addr + SECTION_KERNEL_LEN + SECTION_PANIC_LEN;
+
+	case KBOX_SECTION_PRINTK1:
+		return kbox_addr + (kbox_len - (2 * SECTION_PRINTK_LEN) -
+				    SECTION_USER_LEN);
+
+	case KBOX_SECTION_PRINTK2:
+		return kbox_addr + (kbox_len - SECTION_PRINTK_LEN -
+				    SECTION_USER_LEN);
+
+	case KBOX_SECTION_USER:
+		return kbox_addr + (kbox_len - SECTION_USER_LEN);
+
+	case KBOX_SECTION_ALL:
+		return kbox_addr;
+
+	default:
+		KBOX_MSG("input kbox_section error!\n");
+		return NULL;
+	}
+}
+
+unsigned long kbox_get_section_len(enum kbox_section_e  kbox_section)
+{
+	unsigned long kbox_len = kbox_get_io_len();
+
+	if (kbox_len == 0) {
+		KBOX_MSG("get kbox_len failed!\n");
+		return 0;
+	}
+
+	switch (kbox_section) {
+	case KBOX_SECTION_KERNEL:
+		return SECTION_KERNEL_LEN;
+
+	case KBOX_SECTION_PANIC:
+		return SECTION_PANIC_LEN;
+
+	case KBOX_SECTION_THREAD:
+		return (kbox_len - (2 * SECTION_PRINTK_LEN) -
+			SECTION_USER_LEN - SECTION_KERNEL_LEN -
+			SECTION_PANIC_LEN);
+
+	case KBOX_SECTION_PRINTK1:
+	case KBOX_SECTION_PRINTK2:
+		return SECTION_PRINTK_LEN;
+
+	case KBOX_SECTION_USER:
+		return SECTION_USER_LEN;
+
+	case KBOX_SECTION_ALL:
+		return kbox_len;
+
+	default:
+		KBOX_MSG("input kbox_section error!\n");
+		return 0;
+	}
+}
+
+unsigned long kbox_get_section_phy_addr(enum kbox_section_e  kbox_section)
+{
+	unsigned long kbox_phy_addr = kbox_get_base_phy_addr();
+	unsigned long kbox_len = kbox_get_io_len();
+
+	if (kbox_phy_addr == 0 || kbox_len == 0) {
+		KBOX_MSG("get kbox_phy_addr or kbox_len failed!\n");
+		return 0;
+	}
+
+	switch (kbox_section) {
+	case KBOX_SECTION_KERNEL:
+		return kbox_phy_addr;
+
+	case KBOX_SECTION_PANIC:
+		return kbox_phy_addr + SECTION_KERNEL_LEN;
+
+	case KBOX_SECTION_THREAD:
+		return kbox_phy_addr + SECTION_KERNEL_LEN + SECTION_PANIC_LEN;
+
+	case KBOX_SECTION_PRINTK1:
+		return kbox_phy_addr + (kbox_len - (2 * SECTION_PRINTK_LEN) -
+					SECTION_USER_LEN);
+
+	case KBOX_SECTION_PRINTK2:
+		return kbox_phy_addr + (kbox_len - SECTION_PRINTK_LEN -
+					SECTION_USER_LEN);
+
+	case KBOX_SECTION_USER:
+		return kbox_phy_addr + (kbox_len - SECTION_USER_LEN);
+
+	case KBOX_SECTION_ALL:
+		return kbox_phy_addr;
+
+	default:
+		KBOX_MSG("input kbox_section error!\n");
+		return 0;
+	}
+}
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image.h b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image.h
new file mode 100644
index 000000000000..d1b01bd9ea11
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _KBOX_RAM_IMAGE_H_
+#define _KBOX_RAM_IMAGE_H_
+
+enum kbox_section_e {
+	KBOX_SECTION_KERNEL = 1,
+	KBOX_SECTION_PANIC = 2,
+	KBOX_SECTION_THREAD = 3,
+	KBOX_SECTION_PRINTK1 = 4,
+	KBOX_SECTION_PRINTK2 = 5,
+	KBOX_SECTION_USER = 6,
+	KBOX_SECTION_ALL = 7
+};
+
+#define KBOX_BIG_ENDIAN (0x2B)
+#define KBOX_LITTLE_ENDIAN (0xB2)
+#define IMAGE_VER (0x0001)
+#define IMAGE_MAGIC (0xB202C086)
+#define VALID_IMAGE(x) (IMAGE_MAGIC == (x)->magic_flag)
+#define SLOT_NUM (8)
+#define SLOT_LENGTH (16 * 1024)
+#define MAX_RECORD_NO (0xFF)
+#define MAX_USE_NUMS (0xFF)
+
+#define PRINTK_NUM (2)
+#define PRINTK_CURR_FLAG ("curr")
+#define PRINTK_LAST_FLAG ("last")
+#define PRINTK_FLAG_LEN (4)
+
+struct panic_ctrl_block_s {
+	unsigned char use_nums;
+	unsigned char number;
+	unsigned short len;
+	unsigned int time;
+};
+
+struct thread_info_ctrl_block_s {
+	unsigned int thread_info_len;
+};
+
+struct printk_info_ctrl_block_s {
+	unsigned char flag[PRINTK_FLAG_LEN];
+	unsigned int len;
+};
+
+struct image_super_block_s {
+	unsigned char byte_order;
+	unsigned char checksum;
+	unsigned short version;
+	unsigned int magic_flag;
+	unsigned int panic_nums;
+	struct panic_ctrl_block_s panic_ctrl_blk[SLOT_NUM];
+	struct printk_info_ctrl_block_s printk_ctrl_blk[PRINTK_NUM];
+	struct thread_info_ctrl_block_s thread_ctrl_blk;
+};
+
+#define SECTION_KERNEL_LEN (sizeof(struct image_super_block_s))
+#define SECTION_PANIC_LEN (8 * SLOT_LENGTH)
+#define SECTION_PRINTK_LEN (512 * 1024)
+#define SECTION_USER_LEN (2 * 1024 * 1024)
+
+#define SECTION_KERNEL_OFFSET (0)
+#define SECTION_PANIC_OFFSET SECTION_KERNEL_LEN
+#define SECTION_THREAD_OFFSET (SECTION_KERNEL_LEN + SECTION_PANIC_LEN)
+
+void __iomem *kbox_get_section_addr(enum kbox_section_e  kbox_section);
+unsigned long kbox_get_section_len(enum kbox_section_e  kbox_section);
+unsigned long kbox_get_section_phy_addr(enum kbox_section_e  kbox_section);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.c b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.c
new file mode 100644
index 000000000000..49690bab1cef
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.c
@@ -0,0 +1,986 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/version.h>
+#include <linux/semaphore.h>
+#include <linux/slab.h>
+#include <linux/capability.h>
+#include <linux/uaccess.h>		/* copy_*_user */
+#include <linux/delay.h>		/* udelay */
+#include <linux/mm.h>
+#include "kbox_include.h"
+#include "kbox_main.h"
+#include "kbox_ram_image.h"
+#include "kbox_ram_op.h"
+
+#ifndef VM_RESERVED
+#define VM_RESERVED 0x00080000
+#endif
+
+static DEFINE_SPINLOCK(g_kbox_super_block_lock);
+static DEFINE_SEMAPHORE(user_sem);
+
+union char_int_transfer_u {
+	int data_int;
+	char data_char[KBOX_RW_UNIT];
+};
+
+static struct image_super_block_s g_kbox_super_block = { };
+
+void kbox_write_to_pci(void __iomem *dest, const void *src, int len,
+		       unsigned long offset)
+{
+	union char_int_transfer_u transfer = { };
+	int idx = 0;
+	int j = 0;
+	int four_byte_len = 0;
+	int left_len = 0;
+	char *src_temp = (char *)src;
+	char *dest_temp = (char *)dest;
+	int first_write_num = 0;
+
+	if ((offset % KBOX_RW_UNIT) != 0) {
+		transfer.data_int =
+		    *(int *)(dest_temp + offset - (offset % KBOX_RW_UNIT));
+
+		rmb();/* memory barriers. */
+		first_write_num =
+		    ((len + (offset % KBOX_RW_UNIT)) >
+		     KBOX_RW_UNIT) ? (KBOX_RW_UNIT -
+				      (offset % KBOX_RW_UNIT)) : len;
+		for (idx = (int)(offset % KBOX_RW_UNIT);
+		     idx < (int)(first_write_num + (offset % KBOX_RW_UNIT));
+		     idx++) {
+			if (!src_temp)
+				return;
+
+			transfer.data_char[idx] = *src_temp;
+			src_temp++;
+		}
+		*(int *)(dest_temp + offset - (offset % KBOX_RW_UNIT)) =
+		    transfer.data_int;
+		wmb();/* memory barriers. */
+		len -= first_write_num;
+		offset += first_write_num;
+	}
+
+	four_byte_len = (len / KBOX_RW_UNIT);
+	left_len = (len % KBOX_RW_UNIT);
+	for (idx = 0; idx < four_byte_len; idx++) {
+		for (j = 0; j < KBOX_RW_UNIT; j++) {
+			if (!src_temp)
+				return;
+
+			transfer.data_char[j] = *src_temp;
+			src_temp++;
+		}
+		*(int *)(dest_temp + offset) = transfer.data_int;
+		wmb();/* memory barriers. */
+		offset += KBOX_RW_UNIT;
+	}
+
+	if (left_len != 0) {
+		transfer.data_int = *(int *)(dest_temp + offset);
+		rmb();/* memory barriers. */
+		for (idx = 0; idx < left_len; idx++) {
+			if (!src_temp)
+				return;
+
+			transfer.data_char[idx] = *src_temp;
+			src_temp++;
+		}
+		*(int *)(dest_temp + offset) = transfer.data_int;
+		wmb();/* memory barriers. */
+	}
+
+	udelay(1);
+}
+
+void kbox_read_from_pci(void *dest, void __iomem *src, int len,
+			unsigned long offset)
+{
+	union char_int_transfer_u transfer = { };
+	int idx = 0;
+	int j = 0;
+	int four_byte_len = 0;
+	int left_len = 0;
+	char *dest_temp = (char *)dest;
+	char *src_temp = (char *)src;
+	int first_read_num = 0;
+
+	if ((offset % KBOX_RW_UNIT) != 0) {
+		transfer.data_int =
+		    *(int *)(src_temp + offset - (offset % KBOX_RW_UNIT));
+		first_read_num =
+		    ((len + (offset % KBOX_RW_UNIT)) >
+		     KBOX_RW_UNIT) ? (KBOX_RW_UNIT -
+				      (offset % KBOX_RW_UNIT)) : len;
+		rmb();/* memory barriers. */
+		for (idx = (int)(offset % KBOX_RW_UNIT);
+		     idx < (int)(first_read_num + (offset % KBOX_RW_UNIT));
+		     idx++) {
+			if (!dest_temp)
+				return;
+
+			*dest_temp = transfer.data_char[idx];
+			dest_temp++;
+		}
+		len -= first_read_num;
+		offset += first_read_num;
+	}
+
+	four_byte_len = (len / KBOX_RW_UNIT);
+	left_len = (len % KBOX_RW_UNIT);
+	for (idx = 0; idx < four_byte_len; idx++) {
+		transfer.data_int = *(int *)(src_temp + offset);
+		rmb();/* memory barriers. */
+		for (j = 0; j < KBOX_RW_UNIT; j++) {
+			if (!dest_temp)
+				return;
+
+			*dest_temp = transfer.data_char[j];
+			dest_temp++;
+		}
+		offset += KBOX_RW_UNIT;
+	}
+
+	if (left_len != 0) {
+		transfer.data_int = *(int *)(src_temp + offset);
+		rmb();/* memory barriers. */
+		for (idx = 0; idx < left_len; idx++) {
+			if (!dest_temp)
+				return;
+
+			*dest_temp = transfer.data_char[idx];
+			dest_temp++;
+		}
+	}
+}
+
+void kbox_memset_pci(void __iomem *dest, const char set_byte, int len,
+		     unsigned long offset)
+{
+	union char_int_transfer_u transfer = { };
+	int idx = 0;
+	int four_byte_len = 0;
+	int left_len = 0;
+	char *dest_temp = (char *)dest;
+	int first_memset_num = 0;
+
+	if ((offset % KBOX_RW_UNIT) != 0) {
+		transfer.data_int =
+		    *(int *)(dest_temp + offset - (offset % KBOX_RW_UNIT));
+		rmb();/* memory barriers. */
+		first_memset_num =
+		    ((len + (offset % KBOX_RW_UNIT)) >
+		     KBOX_RW_UNIT) ? (KBOX_RW_UNIT -
+				      (offset % KBOX_RW_UNIT)) : len;
+		for (idx = (int)(offset % KBOX_RW_UNIT);
+		     idx < (int)(first_memset_num + (offset % KBOX_RW_UNIT));
+		     idx++) {
+			transfer.data_char[idx] = set_byte;
+		}
+		*(int *)(dest_temp + offset - (offset % KBOX_RW_UNIT)) =
+		    transfer.data_int;
+		wmb();/* memory barriers. */
+		len -= first_memset_num;
+		offset += first_memset_num;
+	}
+
+	four_byte_len = (len / KBOX_RW_UNIT);
+	left_len = (len % KBOX_RW_UNIT);
+	for (idx = 0; idx < KBOX_RW_UNIT; idx++)
+		transfer.data_char[idx] = set_byte;
+
+	for (idx = 0; idx < four_byte_len; idx++) {
+		*(int *)(dest_temp + offset) = transfer.data_int;
+		wmb();/* memory barriers. */
+		offset += KBOX_RW_UNIT;
+	}
+
+	if (left_len != 0) {
+		transfer.data_int = *(int *)(dest_temp + offset);
+		rmb();/* memory barriers. */
+		for (idx = 0; idx < left_len; idx++)
+			transfer.data_char[idx] = set_byte;
+
+		*(int *)(dest_temp + offset) = transfer.data_int;
+		wmb();/* memory barriers. */
+	}
+
+	udelay(1);
+}
+
+int kbox_read_from_ram(unsigned long offset, unsigned int count, char *data,
+		       enum kbox_section_e  section)
+{
+	unsigned int read_len_total = count;
+	unsigned long offset_temp = offset;
+	void __iomem *kbox_section_addr = kbox_get_section_addr(section);
+	unsigned long kbox_section_len = kbox_get_section_len(section);
+	unsigned int read_len_real = 0;
+
+	if (!data) {
+		KBOX_MSG("input NULL point!\n");
+		return -EFAULT;
+	}
+
+	if (!kbox_section_addr || kbox_section_len == 0) {
+		KBOX_MSG("get kbox_section_addr or kbox_section_len failed!\n");
+		return -EFAULT;
+	}
+
+	if (offset >= kbox_section_len) {
+		KBOX_MSG("input offset is error!\n");
+		return -EFAULT;
+	}
+
+	if ((offset + count) > kbox_section_len)
+		read_len_total = (unsigned int)(kbox_section_len - offset);
+
+	while (1) {
+		unsigned int read_bytes = 0;
+
+		if (read_len_real >= count)
+			break;
+
+		read_bytes =
+		    (read_len_total >
+		     TEMP_BUF_SIZE) ? TEMP_BUF_SIZE : read_len_total;
+
+		kbox_read_from_pci(data, kbox_section_addr, read_bytes,
+				   offset_temp);
+
+		read_len_total -= read_bytes;
+		read_len_real += read_bytes;
+		data += read_bytes;
+		offset_temp += read_bytes;
+	}
+
+	return (int)read_len_real;
+}
+
+int kbox_write_to_ram(unsigned long offset, unsigned int count,
+		      const char *data, enum kbox_section_e  section)
+{
+	unsigned int write_len_total = count;
+	unsigned long offset_temp = offset;
+	void __iomem *kbox_section_addr = kbox_get_section_addr(section);
+	unsigned long kbox_section_len = kbox_get_section_len(section);
+	unsigned int write_len_real = 0;
+
+	if (!data) {
+		KBOX_MSG("input NULL point!\n");
+		return -EFAULT;
+	}
+
+	if (!kbox_section_addr || kbox_section_len == 0) {
+		KBOX_MSG("get kbox_section_addr or kbox_section_len failed!\n");
+		return -EFAULT;
+	}
+
+	if (offset >= kbox_section_len) {
+		KBOX_MSG("input offset is error!\n");
+		return -EFAULT;
+	}
+
+	if ((offset + count) > kbox_section_len)
+		write_len_total = (unsigned int)(kbox_section_len - offset);
+
+	KBOX_MSG("struct image_super_block_s = %x\n", count);
+	while (1) {
+		unsigned int write_bytes = 0;
+
+		if (write_len_real >= count) {
+			KBOX_MSG("write_len_real = %x\n", write_len_real);
+			break;
+		}
+		KBOX_MSG("write_len_total = %x\n", write_len_total);
+
+		write_bytes =
+		    (write_len_total >
+		     TEMP_BUF_SIZE) ? TEMP_BUF_SIZE : write_len_total;
+		KBOX_MSG("write_bytes = %x\n", write_bytes);
+
+		kbox_write_to_pci(kbox_section_addr, data, write_bytes,
+				  offset_temp);
+
+		write_len_total -= write_bytes;
+		write_len_real += write_bytes;
+		data += write_bytes;
+		offset_temp += write_bytes;
+	}
+
+	return (int)write_len_real;
+}
+
+int kbox_memset_ram(unsigned long offset, unsigned int count,
+		    const char set_byte, enum kbox_section_e  section)
+{
+	unsigned int memset_len = count;
+	void __iomem *kbox_section_addr = kbox_get_section_addr(section);
+	unsigned long kbox_section_len = kbox_get_section_len(section);
+
+	if (!kbox_section_addr || kbox_section_len == 0) {
+		KBOX_MSG("get kbox_section_addr or kbox_section_len failed!\n");
+		return -EFAULT;
+	}
+
+	if (offset >= kbox_section_len) {
+		KBOX_MSG("input offset is error!\n");
+		return -EFAULT;
+	}
+
+	if ((offset + count) > kbox_section_len)
+		memset_len = (unsigned int)(kbox_section_len - offset);
+
+	kbox_memset_pci(kbox_section_addr, set_byte, memset_len, offset);
+
+	return KBOX_TRUE;
+}
+
+int kbox_read_op(long long offset, unsigned int count, char __user *data,
+		 enum kbox_section_e  section)
+{
+	unsigned int read_bytes = 0;
+	unsigned int read_len = 0;
+	unsigned int left_len = count;
+	char *user_buf = data;
+	char *temp_buf_char = NULL;
+	unsigned long offset_tmp = offset;
+
+	if (!data) {
+		KBOX_MSG("input NULL point!\n");
+		return -EFAULT;
+	}
+
+	if (down_interruptible(&user_sem) != 0)
+		return KBOX_FALSE;
+
+	temp_buf_char = kmalloc(TEMP_BUF_DATA_SIZE, GFP_KERNEL);
+	if (!temp_buf_char) {
+		KBOX_MSG("kmalloc temp_buf_char fail!\n");
+		up(&user_sem);
+		return -ENOMEM;
+	}
+
+	memset((void *)temp_buf_char, 0, TEMP_BUF_DATA_SIZE);
+
+	while (1) {
+		if (read_len >= count)
+			break;
+
+		read_bytes =
+		    (left_len >
+		     TEMP_BUF_DATA_SIZE) ? TEMP_BUF_DATA_SIZE : left_len;
+
+		if (kbox_read_from_ram
+		    (offset_tmp, read_bytes, temp_buf_char, section) < 0) {
+			KBOX_MSG("kbox_read_from_ram fail!\n");
+			break;
+		}
+
+		if (copy_to_user(user_buf, temp_buf_char, read_bytes)) {
+			KBOX_MSG("copy_to_user fail!\n");
+			break;
+		}
+
+		left_len -= read_bytes;
+		read_len += read_bytes;
+		user_buf += read_bytes;
+
+		offset_tmp += read_bytes;
+		memset((void *)temp_buf_char, 0, TEMP_BUF_DATA_SIZE);
+
+		msleep(20);
+	}
+
+	kfree(temp_buf_char);
+
+	up(&user_sem);
+
+	return (int)read_len;
+}
+
+int kbox_write_op(long long offset, unsigned int count,
+		  const char __user *data, enum kbox_section_e  section)
+{
+	unsigned int write_len = 0;
+	unsigned int left_len = count;
+	const char *user_buf = data;
+	char *temp_buf_char = NULL;
+	unsigned long offset_tmp = offset;
+
+	if (!data) {
+		KBOX_MSG("input NULL point!\n");
+		return -EFAULT;
+	}
+
+	if (down_interruptible(&user_sem) != 0)
+		return KBOX_FALSE;
+
+	temp_buf_char = kmalloc(TEMP_BUF_DATA_SIZE, GFP_KERNEL);
+	if (!temp_buf_char || IS_ERR(temp_buf_char)) {
+		KBOX_MSG("kmalloc temp_buf_char fail!\n");
+		up(&user_sem);
+		return -ENOMEM;
+	}
+
+	memset((void *)temp_buf_char, 0, TEMP_BUF_DATA_SIZE);
+
+	while (1) {
+		unsigned int write_bytes = 0;
+
+		if (write_len >= count)
+			break;
+
+		write_bytes =
+		    (left_len >
+		     TEMP_BUF_DATA_SIZE) ? TEMP_BUF_DATA_SIZE : left_len;
+
+		if (copy_from_user(temp_buf_char, user_buf, write_bytes)) {
+			KBOX_MSG("copy_from_user fail!\n");
+			break;
+		}
+
+		if (kbox_write_to_ram
+		    (offset_tmp, write_bytes, temp_buf_char, section) < 0) {
+			KBOX_MSG("kbox_write_to_ram fail!\n");
+			break;
+		}
+
+		left_len -= write_bytes;
+		write_len += write_bytes;
+		user_buf += write_bytes;
+
+		offset_tmp += write_bytes;
+		memset((void *)temp_buf_char, 0, TEMP_BUF_DATA_SIZE);
+
+		msleep(20);
+	}
+
+	kfree(temp_buf_char);
+
+	up(&user_sem);
+
+	return (int)write_len;
+}
+
+char kbox_checksum(const char *input_buf, unsigned int len)
+{
+	unsigned int idx = 0;
+	char checksum = 0;
+
+	for (idx = 0; idx < len; idx++)
+		checksum += input_buf[idx];
+
+	return checksum;
+}
+
+static int kbox_update_super_block(void)
+{
+	int write_len = 0;
+
+	g_kbox_super_block.checksum = 0;
+	g_kbox_super_block.checksum =
+	    ~((unsigned char)
+	      kbox_checksum((char *)&g_kbox_super_block,
+			    (unsigned int)sizeof(g_kbox_super_block))) + 1;
+	write_len =
+	    kbox_write_to_ram(SECTION_KERNEL_OFFSET,
+			      (unsigned int)sizeof(struct image_super_block_s),
+			      (char *)&g_kbox_super_block, KBOX_SECTION_KERNEL);
+	if (write_len <= 0) {
+		KBOX_MSG("fail to write superblock data!\n");
+		return KBOX_FALSE;
+	}
+
+	return KBOX_TRUE;
+}
+
+int kbox_read_super_block(void)
+{
+	int read_len = 0;
+
+	read_len =
+	    kbox_read_from_ram(SECTION_KERNEL_OFFSET,
+			       (unsigned int)sizeof(struct image_super_block_s),
+			       (char *)&g_kbox_super_block,
+			       KBOX_SECTION_KERNEL);
+	if (read_len != sizeof(struct image_super_block_s)) {
+		KBOX_MSG("fail to get superblock data!\n");
+		return KBOX_FALSE;
+	}
+
+	return KBOX_TRUE;
+}
+
+static unsigned char kbox_get_byte_order(void)
+{
+	unsigned short data_short = 0xB22B;
+	unsigned char *data_char = (unsigned char *)&data_short;
+
+	return (unsigned char)((*data_char == 0xB2) ? KBOX_BIG_ENDIAN :
+			       KBOX_LITTLE_ENDIAN);
+}
+
+int kbox_super_block_init(void)
+{
+	int ret = 0;
+
+	ret = kbox_read_super_block();
+	if (ret != KBOX_TRUE) {
+		KBOX_MSG("kbox_read_super_block fail!\n");
+		return ret;
+	}
+
+	if (!VALID_IMAGE(&g_kbox_super_block) ||
+	    kbox_checksum((char *)&g_kbox_super_block,
+			  (unsigned int)sizeof(g_kbox_super_block)) != 0) {
+		if (!VALID_IMAGE(&g_kbox_super_block)) {
+			memset((void *)&g_kbox_super_block, 0x00,
+			       sizeof(struct image_super_block_s));
+		}
+
+		g_kbox_super_block.byte_order = kbox_get_byte_order();
+		g_kbox_super_block.version = IMAGE_VER;
+		g_kbox_super_block.magic_flag = IMAGE_MAGIC;
+	}
+
+	g_kbox_super_block.thread_ctrl_blk.thread_info_len = 0;
+
+	if (kbox_update_super_block() != KBOX_TRUE) {
+		KBOX_MSG("kbox_update_super_block failed!\n");
+		return KBOX_FALSE;
+	}
+
+	return KBOX_TRUE;
+}
+
+static unsigned char kbox_get_write_slot_num(void)
+{
+	struct panic_ctrl_block_s *panic_ctrl_block = NULL;
+	unsigned int idx = 0;
+	unsigned char slot_num = 0;
+	unsigned char min_use_nums = 0;
+
+	panic_ctrl_block = g_kbox_super_block.panic_ctrl_blk;
+	min_use_nums = panic_ctrl_block->use_nums;
+
+	for (idx = 1; idx < SLOT_NUM; idx++) {
+		panic_ctrl_block++;
+		if (panic_ctrl_block->use_nums < min_use_nums) {
+			min_use_nums = panic_ctrl_block->use_nums;
+			slot_num = (unsigned char)idx;
+		}
+	}
+
+	if (min_use_nums == MAX_USE_NUMS) {
+		panic_ctrl_block = g_kbox_super_block.panic_ctrl_blk;
+		for (idx = 0; idx < SLOT_NUM; idx++) {
+			panic_ctrl_block->use_nums = 1;
+			panic_ctrl_block++;
+		}
+	}
+
+	return slot_num;
+}
+
+static unsigned char kbox_get_new_record_number(void)
+{
+	struct panic_ctrl_block_s *panic_ctrl_block = NULL;
+	unsigned int idx = 0;
+	unsigned char max_number = 0;
+
+	panic_ctrl_block = g_kbox_super_block.panic_ctrl_blk;
+	for (idx = 0; idx < SLOT_NUM; idx++) {
+		if (panic_ctrl_block->number >= max_number)
+			max_number = panic_ctrl_block->number;
+
+		panic_ctrl_block++;
+	}
+
+	return (unsigned char)((max_number + 1) % MAX_RECORD_NO);
+}
+
+int kbox_write_panic_info(const char *input_data, unsigned int data_len)
+{
+	int write_len = 0;
+	unsigned int offset = 0;
+	struct panic_ctrl_block_s *panic_ctrl_block = NULL;
+	unsigned long time = get_seconds();
+	unsigned char slot_num = 0;
+	unsigned long flags = 0;
+
+	if (!input_data || data_len == 0) {
+		KBOX_MSG("input parameter error!\n");
+		return KBOX_FALSE;
+	}
+
+	if (data_len > SLOT_LENGTH)
+		data_len = SLOT_LENGTH;
+
+	spin_lock_irqsave(&g_kbox_super_block_lock, flags);
+
+	slot_num = kbox_get_write_slot_num();
+
+	panic_ctrl_block = &g_kbox_super_block.panic_ctrl_blk[slot_num];
+	panic_ctrl_block->use_nums++;
+
+	panic_ctrl_block->number = kbox_get_new_record_number();
+	panic_ctrl_block->len = 0;
+	panic_ctrl_block->time = (unsigned int)time;
+
+	g_kbox_super_block.panic_nums++;
+
+	spin_unlock_irqrestore(&g_kbox_super_block_lock, flags);
+
+	offset = slot_num * SLOT_LENGTH;
+	write_len =
+	    kbox_write_to_ram(offset, data_len, input_data, KBOX_SECTION_PANIC);
+	if (write_len <= 0) {
+		KBOX_MSG("fail to save panic information!\n");
+		return KBOX_FALSE;
+	}
+
+	spin_lock_irqsave(&g_kbox_super_block_lock, flags);
+
+	panic_ctrl_block->len += (unsigned short)write_len;
+
+	if (kbox_update_super_block() != KBOX_TRUE) {
+		KBOX_MSG("kbox_update_super_block failed!\n");
+		spin_unlock_irqrestore(&g_kbox_super_block_lock, flags);
+		return KBOX_FALSE;
+	}
+
+	spin_unlock_irqrestore(&g_kbox_super_block_lock, flags);
+
+	return KBOX_TRUE;
+}
+
+int kbox_write_thread_info(const char *input_data, unsigned int data_len)
+{
+	int write_len = 0;
+	unsigned int offset = 0;
+	unsigned long flags = 0;
+	unsigned int date_len_tmp = data_len;
+
+	if (!input_data || date_len_tmp == 0) {
+		KBOX_MSG("input parameter error!\n");
+		return KBOX_FALSE;
+	}
+
+	spin_lock_irqsave(&g_kbox_super_block_lock, flags);
+
+	offset = g_kbox_super_block.thread_ctrl_blk.thread_info_len;
+	write_len =
+	    kbox_write_to_ram(offset, date_len_tmp, input_data,
+			      KBOX_SECTION_THREAD);
+	if (write_len <= 0) {
+		KBOX_MSG("fail to save thread information!\n");
+		spin_unlock_irqrestore(&g_kbox_super_block_lock, flags);
+		return KBOX_FALSE;
+	}
+
+	g_kbox_super_block.thread_ctrl_blk.thread_info_len += write_len;
+
+	if (kbox_update_super_block() != KBOX_TRUE) {
+		KBOX_MSG("kbox_update_super_block failed!\n");
+		spin_unlock_irqrestore(&g_kbox_super_block_lock, flags);
+		return KBOX_FALSE;
+	}
+
+	spin_unlock_irqrestore(&g_kbox_super_block_lock, flags);
+
+	return KBOX_TRUE;
+}
+
+int kbox_read_printk_info(char *input_data,
+			  struct printk_ctrl_block_tmp_s *printk_ctrl_block_tmp)
+{
+	int read_len = 0;
+	int printk_region = printk_ctrl_block_tmp->printk_region;
+	unsigned int len = 0;
+
+	if (!input_data) {
+		KBOX_MSG("input parameter error!\n");
+		return KBOX_FALSE;
+	}
+
+	len = g_kbox_super_block.printk_ctrl_blk[printk_region].len;
+	if (len <= 0) {
+		printk_ctrl_block_tmp->end = 0;
+		printk_ctrl_block_tmp->valid_len = 0;
+		return KBOX_TRUE;
+	}
+
+	read_len =
+	    kbox_read_from_ram(0, len, input_data,
+			       printk_ctrl_block_tmp->section);
+	if (read_len < 0) {
+		KBOX_MSG("fail to read printk information!(1)\n");
+		return KBOX_FALSE;
+	}
+
+	printk_ctrl_block_tmp->end = len;
+	printk_ctrl_block_tmp->valid_len = len;
+
+	return KBOX_TRUE;
+}
+
+int kbox_write_printk_info(const char *input_data,
+			   struct printk_ctrl_block_tmp_s *
+			   printk_ctrl_block_tmp)
+{
+	int write_len = 0;
+	int printk_region = printk_ctrl_block_tmp->printk_region;
+	unsigned long flags = 0;
+	unsigned int len = 0;
+
+	if (!input_data) {
+		KBOX_MSG("input parameter error!\n");
+		return KBOX_FALSE;
+	}
+
+	len = printk_ctrl_block_tmp->valid_len;
+	write_len =
+	    kbox_write_to_ram(0, len, input_data,
+			      printk_ctrl_block_tmp->section);
+	if (write_len <= 0) {
+		KBOX_MSG("fail to save printk information!(1)\n");
+		return KBOX_FALSE;
+	}
+
+	spin_lock_irqsave(&g_kbox_super_block_lock, flags);
+
+	g_kbox_super_block.printk_ctrl_blk[printk_region].len = len;
+
+	if (kbox_update_super_block() != KBOX_TRUE) {
+		KBOX_MSG("kbox_update_super_block failed!\n");
+		spin_unlock_irqrestore(&g_kbox_super_block_lock, flags);
+		return KBOX_FALSE;
+	}
+
+	spin_unlock_irqrestore(&g_kbox_super_block_lock, flags);
+
+	return KBOX_TRUE;
+}
+
+static int kbox_read_region(unsigned long arg)
+{
+	unsigned int read_len = 0;
+	struct kbox_region_arg_s region_arg = { };
+
+	if (copy_from_user
+	    ((void *)&region_arg, (void __user *)arg,
+	     sizeof(struct kbox_region_arg_s))) {
+		KBOX_MSG("fail to copy_from_user!\n");
+		return KBOX_FALSE;
+	}
+
+	read_len = kbox_read_op((long long)region_arg.offset, region_arg.count,
+				(char __user *)region_arg.data,
+				KBOX_SECTION_ALL);
+	if (read_len <= 0) {
+		KBOX_MSG("fail to get kbox data!\n");
+		return KBOX_FALSE;
+	}
+
+	if (copy_to_user
+	    ((void __user *)arg, (void *)&region_arg,
+	     sizeof(struct kbox_region_arg_s))) {
+		KBOX_MSG("fail to copy_to_user!\n");
+		return KBOX_FALSE;
+	}
+
+	return KBOX_TRUE;
+}
+
+static int kbox_writer_region(unsigned long arg)
+{
+	unsigned int write_len = 0;
+	struct kbox_region_arg_s region_arg = { };
+
+	if (copy_from_user
+	    ((void *)&region_arg, (void __user *)arg,
+	     sizeof(struct kbox_region_arg_s))) {
+		KBOX_MSG("fail to copy_from_user!\n");
+		return KBOX_FALSE;
+	}
+
+	write_len = kbox_write_op((long long)region_arg.offset,
+				  region_arg.count,
+				  (char __user *)region_arg.data,
+				  KBOX_SECTION_ALL);
+	if (write_len <= 0) {
+		KBOX_MSG("fail to write kbox data!\n");
+		return KBOX_FALSE;
+	}
+
+	if (copy_to_user
+	    ((void __user *)arg, (void *)&region_arg,
+	     sizeof(struct kbox_region_arg_s))) {
+		KBOX_MSG("fail to copy_to_user!\n");
+		return KBOX_FALSE;
+	}
+
+	return KBOX_TRUE;
+}
+
+int kbox_clear_region(enum kbox_section_e  section)
+{
+	int ret = KBOX_TRUE;
+	unsigned long kbox_section_len = kbox_get_section_len(section);
+
+	if (kbox_section_len == 0) {
+		KBOX_MSG("get kbox_section_len failed!\n");
+		return -EFAULT;
+	}
+
+	ret = kbox_memset_ram(0, (unsigned int)kbox_section_len, 0, section);
+	if (ret != KBOX_TRUE) {
+		KBOX_MSG("kbox_memset_ram failed!\n");
+		return -EFAULT;
+	}
+
+	return KBOX_TRUE;
+}
+
+static int kbox_get_image_len(unsigned long arg)
+{
+	unsigned long __user *ptr = (unsigned long __user *)arg;
+	unsigned long kbox_len = 0;
+
+	kbox_len = kbox_get_section_len(KBOX_SECTION_ALL);
+	if (kbox_len == 0) {
+		KBOX_MSG("kbox_get_section_len section all fail!\n");
+		return -EFAULT;
+	}
+
+	return put_user(kbox_len, ptr);
+}
+
+static int kbox_get_user_region_len(unsigned long arg)
+{
+	unsigned long __user *ptr = (unsigned long __user *)arg;
+	unsigned long kbox_user_region_len = 0;
+
+	kbox_user_region_len = kbox_get_section_len(KBOX_SECTION_USER);
+	if (kbox_user_region_len == 0) {
+		KBOX_MSG("kbox_get_section_len section user fail!\n");
+		return -EFAULT;
+	}
+
+	return put_user(kbox_user_region_len, ptr);
+}
+
+static int kbox_ioctl_verify_cmd(unsigned int cmd, unsigned long arg)
+{
+	if (arg == 0 || (_IOC_TYPE(cmd) != KBOX_IOC_MAGIC))
+		return KBOX_FALSE;
+
+	if (_IOC_NR(cmd) > KBOX_IOC_MAXNR)
+		return KBOX_FALSE;
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		KBOX_MSG("permit error\n");
+		return KBOX_FALSE;
+	}
+
+	return KBOX_TRUE;
+}
+
+int kbox_ioctl_detail(unsigned int cmd, unsigned long arg)
+{
+	if (kbox_ioctl_verify_cmd(cmd, arg) != KBOX_TRUE)
+		return -EFAULT;
+
+	switch (cmd) {
+	case GET_KBOX_TOTAL_LEN:
+		return kbox_get_image_len(arg);
+
+	case GET_KBOX_REGION_USER_LEN:
+		return kbox_get_user_region_len(arg);
+
+	case KBOX_REGION_READ:
+		return kbox_read_region(arg);
+
+	case KBOX_REGION_WRITE:
+		return kbox_writer_region(arg);
+
+	case CLEAR_KBOX_REGION_ALL:
+		return kbox_clear_region(KBOX_SECTION_ALL);
+
+	case CLEAR_KBOX_REGION_USER:
+		return kbox_clear_region(KBOX_SECTION_USER);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+int kbox_mmap_ram(struct file *pfile, struct vm_area_struct *vma,
+		  enum kbox_section_e  section)
+{
+	unsigned long kbox_section_phy_addr =
+	    kbox_get_section_phy_addr(section);
+	unsigned long kbox_section_len = kbox_get_section_len(section);
+	unsigned long offset = 0;
+	unsigned long length = 0;
+	unsigned long vm_size = 0;
+	int ret = 0;
+
+	UNUSED(pfile);
+
+	if (kbox_section_phy_addr == 0 || kbox_section_len == 0) {
+		KBOX_MSG
+		    ("get kbox_section_phy_addr or kbox_section_len failed!\n");
+		return -EFAULT;
+	}
+
+	offset = vma->vm_pgoff << PAGE_SHIFT;
+	vm_size = vma->vm_end - vma->vm_start;
+
+	if (offset >= kbox_section_len) {
+		KBOX_MSG("vma offset is invalid!\n");
+		return -ESPIPE;
+	}
+
+	if (vma->vm_flags & VM_LOCKED) {
+		KBOX_MSG("vma is locked!\n");
+		return -EPERM;
+	}
+
+	length = kbox_section_len - offset;
+	if (vm_size > length) {
+		KBOX_MSG("vm_size is invalid!\n");
+		return -ENOSPC;
+	}
+
+	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_IO;
+
+	ret = remap_pfn_range(vma,
+			      vma->vm_start,
+			      (unsigned long)(kbox_section_phy_addr >>
+					      PAGE_SHIFT), vm_size,
+			      vma->vm_page_prot);
+	if (ret) {
+		KBOX_MSG("remap_pfn_range failed! ret = %d\n", ret);
+		return -EAGAIN;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.h b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.h
new file mode 100644
index 000000000000..4a92c87de139
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _KBOX_RAM_OP_H_
+#define _KBOX_RAM_OP_H_
+
+#include <asm/ioctls.h>
+#include <linux/fs.h>
+#include "kbox_printk.h"
+
+#define KBOX_IOC_MAGIC (0xB2)
+
+#define GET_KBOX_TOTAL_LEN _IOR(KBOX_IOC_MAGIC, 0, unsigned long)
+
+#define GET_KBOX_REGION_USER_LEN  _IOR(KBOX_IOC_MAGIC, 1, unsigned long)
+
+#define CLEAR_KBOX_REGION_ALL _IO(KBOX_IOC_MAGIC, 2)
+
+#define CLEAR_KBOX_REGION_USER _IO(KBOX_IOC_MAGIC, 3)
+
+#define KBOX_REGION_READ _IOR(KBOX_IOC_MAGIC, 4, struct kbox_region_arg_s)
+
+#define KBOX_REGION_WRITE _IOW(KBOX_IOC_MAGIC, 5, struct kbox_region_arg_s)
+
+#define KBOX_IOC_MAXNR 6
+
+#define TEMP_BUF_SIZE (32 * 1024)
+#define TEMP_BUF_DATA_SIZE (128 * 1024)
+#define KBOX_RW_UNIT 4
+
+struct kbox_region_arg_s {
+	unsigned long offset;
+	unsigned int count;
+	char *data;
+};
+
+enum kbox_section_e;
+
+int kbox_read_op(long long offset, unsigned int count, char __user *data,
+		 enum kbox_section_e section);
+int kbox_write_op(long long offset, unsigned int count,
+		  const char __user *data, enum kbox_section_e section);
+int kbox_read_super_block(void);
+int kbox_super_block_init(void);
+int kbox_write_panic_info(const char *input_data, unsigned int data_len);
+int kbox_write_thread_info(const char *input_data, unsigned int data_len);
+int kbox_write_printk_info(const char *input_data,
+			   struct printk_ctrl_block_tmp_s
+			   *printk_ctrl_block_tmp);
+int kbox_read_printk_info(char *input_data,
+			  struct printk_ctrl_block_tmp_s
+			  *printk_ctrl_block_tmp);
+int kbox_ioctl_detail(unsigned int cmd, unsigned long arg);
+int kbox_mmap_ram(struct file *file, struct vm_area_struct *vma,
+		  enum kbox_section_e section);
+char kbox_checksum(const char *input_buf, unsigned int len);
+int kbox_write_to_ram(unsigned long offset, unsigned int count,
+		      const char *data, enum kbox_section_e section);
+int kbox_read_from_ram(unsigned long offset, unsigned int count, char *data,
+		       enum kbox_section_e section);
+int kbox_clear_region(enum kbox_section_e section);
+int kbox_memset_ram(unsigned long offset, unsigned int count,
+		    const char set_byte, enum kbox_section_e section);
+
+#endif
-- 
2.26.2.windows.1


