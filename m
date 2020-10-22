Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C0C295DC7
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 13:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897594AbgJVLwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 07:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503592AbgJVLwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 07:52:05 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E8BC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 04:52:05 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m20so1602436ljj.5
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 04:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=n58NkZJzVjLKTzwsAFYxWlkrSZkVUrs3TijMJQaRZaw=;
        b=BGgoQiIiw616dMTyyW7cApnACOITd/H5Uv3QsRi1CuE7MXPFIiwiR5ifgzSIWAlbXm
         yfaFJFQygW6bW1e0ejnqIjxsPVMm2X2HnHBX5k65d296Dy+7pqpR4XajnHShMKH1nVhg
         dvEGGJAF9QnY+556uAX02Li8c0XYgaoIVCawY5Fb2pJYGXT5xfbhhcmR9dplM7/bUBj0
         FbfmeNfvhF4yKHzhTov8Y5MS4MfaGvX2J1mPO90Eg0RxsC1G/24LRC3fAFZad0AGQKWb
         eufdP+Wj51GbYfSiZFjXTu/G+SbckyIOihgilxynxJkRqAjbOvAVu7Narqqi6x5K2zyf
         Aunw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=n58NkZJzVjLKTzwsAFYxWlkrSZkVUrs3TijMJQaRZaw=;
        b=aE26wch1B25lpzwdeM3W4XYWE/WMoq3M6w2TCa1oSPjL+0Xzr2O4yOTJZTETiskv3c
         4Ge1ozV7+GgkxxVwxayWsNb6LaD76LEtFH289Bg3zLjdjbrCRlpuCgA1zGzBDZjJwxL2
         HsPwBzNVcKg/Fr9kH7LySNWPSTabco/pnZFEBBB9YK6Nmdt4PcrCcRf2PjLxMgTGPU3W
         fGSAyEjmml0eccn1/4p3YaiZ+35wa4FW9mPfpRShT58unLa8kv5zoiaQowgh/H/x1wQr
         iX3zZuKsLFP5lvkvgFfMi06Pat5UxCmBWnZTdb7OpykFVWy8z6mmVKQPxKPp/Hb0z45N
         Sevw==
X-Gm-Message-State: AOAM530qe3SqknJnq5DKPVeDg9/eQk2N478W9+I/bwE16WMWT/AsBozW
        hrMdsCXSRnJj/gSdzIKuwiu/Ta4VofOZIy+JGeFXrYsWeufvWw==
X-Google-Smtp-Source: ABdhPJydt35JWB5U9IzN9uBk2J3PwkBO83nW3P962A9uZ6ZZRNssGsSRj7EZu0WLLYbEz8jdaCuNsrdnHuwW3FnnffI=
X-Received: by 2002:a2e:504b:: with SMTP id v11mr784074ljd.138.1603367523180;
 Thu, 22 Oct 2020 04:52:03 -0700 (PDT)
MIME-Version: 1.0
From:   Charles Hsu <hsu.yuegteng@gmail.com>
Date:   Thu, 22 Oct 2020 19:51:51 +0800
Message-ID: <CAJArhDY9MYZ4UN1-=mmZRYj8zJ7JtF9=xtpLBiyPux6bjg-FaQ@mail.gmail.com>
Subject: [PATCH] hwmon: (pmbus) Add driver for STMicroelectronics PM6764TR
 Voltage Regulator
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the pmbus driver for the STMicroelectronics pm6764tr voltage regulator.

Signed-off-by: Charles Hsu <hsu.yungteng@gmail.com>
---
 drivers/hwmon/pmbus/Kconfig    |  8 ++++
 drivers/hwmon/pmbus/Makefile   |  1 +
 drivers/hwmon/pmbus/pm6764tr.c | 76 ++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)
 create mode 100644 drivers/hwmon/pmbus/pm6764tr.c

diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
index a25faf69fce3..e976997ee163 100644
--- a/drivers/hwmon/pmbus/Kconfig
+++ b/drivers/hwmon/pmbus/Kconfig
@@ -287,4 +287,12 @@ config SENSORS_ZL6100
   This driver can also be built as a module. If so, the module will
   be called zl6100.

+config SENSORS_PM6764TR
+ tristate "PM6764TR"
+ help
+  If you say yes here you get hardware monitoring support for PM6764TR.
+
+  This driver can also be built as a module. If so, the module will
+  be called pm6764tr.
+
 endif # PMBUS
diff --git a/drivers/hwmon/pmbus/Makefile b/drivers/hwmon/pmbus/Makefile
index 4c97ad0bd791..bb89fcf9544d 100644
--- a/drivers/hwmon/pmbus/Makefile
+++ b/drivers/hwmon/pmbus/Makefile
@@ -32,3 +32,4 @@ obj-$(CONFIG_SENSORS_UCD9000) += ucd9000.o
 obj-$(CONFIG_SENSORS_UCD9200) += ucd9200.o
 obj-$(CONFIG_SENSORS_XDPE122) += xdpe12284.o
 obj-$(CONFIG_SENSORS_ZL6100) += zl6100.o
+obj-$(CONFIG_SENSORS_PM6764TR) += pm6764tr.o
\ No newline at end of file
diff --git a/drivers/hwmon/pmbus/pm6764tr.c b/drivers/hwmon/pmbus/pm6764tr.c
new file mode 100644
index 000000000000..e03b1441268e
--- /dev/null
+++ b/drivers/hwmon/pmbus/pm6764tr.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/i2c.h>
+#include <linux/pmbus.h>
+#include "pmbus.h"
+
+#define PM6764TR_PMBUS_READ_VOUT 0xD4
+
+static int pm6764tr_read_word_data(struct i2c_client *client, int
page, int reg)
+{
+ int ret;
+
+ switch (reg) {
+ case PMBUS_VIRT_READ_VMON:
+ ret = pmbus_read_word_data(client, page,
+   PM6764TR_PMBUS_READ_VOUT);
+ break;
+ default:
+ ret = -ENODATA;
+ break;
+ }
+ return ret;
+}
+
+static struct pmbus_driver_info pm6764tr_info = {
+ .pages = 1,
+ .format[PSC_VOLTAGE_IN] = linear,
+ .format[PSC_VOLTAGE_OUT] = vid,
+ .format[PSC_TEMPERATURE] = linear,
+ .format[PSC_CURRENT_OUT] = linear,
+ .format[PSC_POWER] = linear,
+ .func[0] = PMBUS_HAVE_VIN | PMBUS_HAVE_IIN |  PMBUS_HAVE_PIN |
+    PMBUS_HAVE_IOUT | PMBUS_HAVE_POUT | PMBUS_HAVE_VMON |
+ PMBUS_HAVE_STATUS_IOUT | PMBUS_HAVE_STATUS_VOUT |
+ PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
+    .read_word_data = pm6764tr_read_word_data,
+};
+
+static int pm6764tr_probe(struct i2c_client *client,
+  const struct i2c_device_id *id)
+{
+ return pmbus_do_probe(client, id, &pm6764tr_info);
+}
+
+static const struct i2c_device_id pm6764tr_id[] = {
+ {"pm6764tr", 0},
+ {}
+};
+MODULE_DEVICE_TABLE(i2c, pm6764tr_id);
+
+static const struct of_device_id pm6764tr_of_match[] = {
+ {.compatible = "pm6764tr"},
+ {}
+};
+
+static struct i2c_driver pm6764tr_driver = {
+ .driver = {
+   .name = "pm6764tr",
+   .of_match_table = of_match_ptr(pm6764tr_of_match),
+   },
+ .probe = pm6764tr_probe,
+ .remove = pmbus_do_remove,
+ .id_table = pm6764tr_id,
+};
+
+module_i2c_driver(pm6764tr_driver);
+
+MODULE_AUTHOR("Charles Hsu");
+MODULE_DESCRIPTION("PMBus driver for ST PM6764TR");
+MODULE_LICENSE("GPL");
--
2.25.1
