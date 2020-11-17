Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805F42B5600
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731637AbgKQBJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbgKQBJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 20:09:57 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB33C0613CF;
        Mon, 16 Nov 2020 17:09:57 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id e21so14810736pgr.11;
        Mon, 16 Nov 2020 17:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e/IegTC1nzz3ON1xySPtjDRJgwT23h4pdg52sOpqi/E=;
        b=QsmgCf+C4J16pGh4GVPXMB5KWc+eiDU/VoNlfPiIm5CGBCDYSdxESDXHb1SvTZ7XlR
         16KHDJh71/Wy2h6O0hL+3w7NL/pmNnoBK62FIbtHnegMzzur0LSc3kSV2cE/cE65qzms
         RQ1hn3rxcdIIoblc2rySdxPpi7NUhnl/zqMJmSwzPIGB047PGo0L7sK92IhRIrDwxU+I
         Gmg96LLTFZLkuVoFS1HgzXg3LUZu6onEncNGnFZiNkVZGAO+78Da8IFn6pQiNzoIlgrn
         ksVqueIXNgQ1ZOluALHNY5n735xBq7jb8YDHUiO9gW+ezVzwD8X0osg8M+rZO0U43WM5
         17TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e/IegTC1nzz3ON1xySPtjDRJgwT23h4pdg52sOpqi/E=;
        b=sQRYEC1zpSOf7Ca4XpKcCJg4k8JV8rP0CXZRxo0yhNPEgvT0zPj3Smqe/xVXriTSOn
         2qMifbE4R6kZM+bE2QYNxu1v4K6YKCMlrlW9pqVuQZVEzmE4xtXtaaN2mGfH7TbKF5n/
         Co9QFzJBxFF2JXbVJBbMs4/hrTPJPaITa34fkxMzt5JKiqn3tVSGSZHOijwwe7QWIS7J
         Y9HJEs9wBocGoTBtzgLZlbdBknzOt5vXu7/kzUdDJegjnZd2b7XH0yLu/Q5GkUzN94VK
         imsAdQyL3h6RV1Xe740/+apmXA2NEBiVBKngTU3xt7WKXcf40DJeqEh1PaUI4pbbIcnP
         tilg==
X-Gm-Message-State: AOAM532K6hi/pI+9piG9oPmcweBT1TPLStB9RUoMpwepioNhssYrtmCC
        13mjisCGxB/842McIYbgLBk=
X-Google-Smtp-Source: ABdhPJwh+NYZnw/7oS4tjiV0DxVXKfIRhqstbwjasDhD41C2oIwGuEzBfF35TYbB1FVQZGJCOnvuUg==
X-Received: by 2002:a65:6219:: with SMTP id d25mr1475293pgv.1.1605575396591;
        Mon, 16 Nov 2020 17:09:56 -0800 (PST)
Received: from taoren-ubuntu-R90MNF91.thefacebook.com (c-73-252-146-110.hsd1.ca.comcast.net. [73.252.146.110])
        by smtp.gmail.com with ESMTPSA id m23sm7362091pfo.136.2020.11.16.17.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 17:09:56 -0800 (PST)
From:   rentao.bupt@gmail.com
To:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Cc:     Tao Ren <rentao.bupt@gmail.com>
Subject: [PATCH 1/2] hwmon: (max127) Add Maxim MAX127 hardware monitoring driver
Date:   Mon, 16 Nov 2020 17:09:43 -0800
Message-Id: <20201117010944.28457-2-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117010944.28457-1-rentao.bupt@gmail.com>
References: <20201117010944.28457-1-rentao.bupt@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

Add hardware monitoring driver for the Maxim MAX127 chip.

MAX127 min/max range handling code is inspired by the max197 driver.

Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
---
 drivers/hwmon/Kconfig  |   9 ++
 drivers/hwmon/Makefile |   1 +
 drivers/hwmon/max127.c | 286 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 296 insertions(+)
 create mode 100644 drivers/hwmon/max127.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 9d600e0c5584..716df51edc87 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -950,6 +950,15 @@ config SENSORS_MAX1111
 	  This driver can also be built as a module. If so, the module
 	  will be called max1111.
 
+config SENSORS_MAX127
+	tristate "Maxim MAX127 12-bit 8-channel Data Acquisition System"
+	depends on I2C
+	help
+	  Say y here to support Maxim's MAX127 DAS chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called max127.
+
 config SENSORS_MAX16065
 	tristate "Maxim MAX16065 System Manager and compatibles"
 	depends on I2C
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 1083bbfac779..01ca5d3fbad4 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -127,6 +127,7 @@ obj-$(CONFIG_SENSORS_LTC4260)	+= ltc4260.o
 obj-$(CONFIG_SENSORS_LTC4261)	+= ltc4261.o
 obj-$(CONFIG_SENSORS_LTQ_CPUTEMP) += ltq-cputemp.o
 obj-$(CONFIG_SENSORS_MAX1111)	+= max1111.o
+obj-$(CONFIG_SENSORS_MAX127)	+= max127.o
 obj-$(CONFIG_SENSORS_MAX16065)	+= max16065.o
 obj-$(CONFIG_SENSORS_MAX1619)	+= max1619.o
 obj-$(CONFIG_SENSORS_MAX1668)	+= max1668.o
diff --git a/drivers/hwmon/max127.c b/drivers/hwmon/max127.c
new file mode 100644
index 000000000000..df74a95bcf28
--- /dev/null
+++ b/drivers/hwmon/max127.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Hardware monitoring driver for MAX127.
+ *
+ * Copyright (c) 2020 Facebook Inc.
+ */
+
+#include <linux/err.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sysfs.h>
+
+/* MAX127 Control Byte. */
+#define MAX127_CTRL_START	BIT(7)
+#define MAX127_CTRL_SEL_OFFSET	4
+#define MAX127_CTRL_RNG		BIT(3)
+#define MAX127_CTRL_BIP		BIT(2)
+#define MAX127_CTRL_PD1		BIT(1)
+#define MAX127_CTRL_PD0		BIT(0)
+
+#define MAX127_NUM_CHANNELS	8
+#define MAX127_SET_CHANNEL(ch)	(((ch) & 7) << (MAX127_CTRL_SEL_OFFSET))
+
+#define MAX127_INPUT_LIMIT	10	/* 10V */
+
+/*
+ * MAX127 returns 2 bytes at read:
+ *   - the first byte contains data[11:4].
+ *   - the second byte contains data[3:0] (MSB) and 4 dummy 0s (LSB).
+ */
+#define MAX127_DATA1_SHIFT	4
+
+struct max127_data {
+	struct mutex lock;
+	struct i2c_client *client;
+	int input_limit;
+	u8 ctrl_byte[MAX127_NUM_CHANNELS];
+};
+
+static int max127_select_channel(struct max127_data *data, int channel)
+{
+	int status;
+	struct i2c_client *client = data->client;
+	struct i2c_msg msg = {
+		.addr = client->addr,
+		.flags = 0,
+		.len = 1,
+		.buf = &data->ctrl_byte[channel],
+	};
+
+	status = i2c_transfer(client->adapter, &msg, 1);
+	if (status != 1)
+		return status;
+
+	return 0;
+}
+
+static int max127_read_channel(struct max127_data *data, int channel, u16 *vin)
+{
+	int status;
+	u8 i2c_data[2];
+	struct i2c_client *client = data->client;
+	struct i2c_msg msg = {
+		.addr = client->addr,
+		.flags = I2C_M_RD,
+		.len = 2,
+		.buf = i2c_data,
+	};
+
+	status = i2c_transfer(client->adapter, &msg, 1);
+	if (status != 1)
+		return status;
+
+	*vin = ((i2c_data[0] << 8) | i2c_data[1]) >> MAX127_DATA1_SHIFT;
+	return 0;
+}
+
+static ssize_t max127_input_show(struct device *dev,
+				 struct device_attribute *dev_attr,
+				 char *buf)
+{
+	u16 vin;
+	int status;
+	struct max127_data *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(dev_attr);
+
+	if (mutex_lock_interruptible(&data->lock))
+		return -ERESTARTSYS;
+
+	status = max127_select_channel(data, attr->index);
+	if (status)
+		goto exit;
+
+	status = max127_read_channel(data, attr->index, &vin);
+	if (status)
+		goto exit;
+
+	status = sprintf(buf, "%u", vin);
+
+exit:
+	mutex_unlock(&data->lock);
+	return status;
+}
+
+static ssize_t max127_range_show(struct device *dev,
+				 struct device_attribute *dev_attr,
+				 char *buf)
+{
+	u8 ctrl, rng_bip;
+	struct max127_data *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(dev_attr);
+	int rng_type = attr->nr;	/* 0 for min, 1 for max */
+	int channel = attr->index;
+	int full = data->input_limit;
+	int half = full / 2;
+	int range_table[4][2] = {
+		[0] = {0, half},	/* RNG=0, BIP=0 */
+		[1] = {-half, half},	/* RNG=0, BIP=1 */
+		[2] = {0, full},	/* RNG=1, BIP=0 */
+		[3] = {-full, full},	/* RNG=1, BIP=1 */
+	};
+
+	if (mutex_lock_interruptible(&data->lock))
+		return -ERESTARTSYS;
+	ctrl = data->ctrl_byte[channel];
+	mutex_unlock(&data->lock);
+
+	rng_bip = (ctrl >> 2) & 3;
+	return sprintf(buf, "%d", range_table[rng_bip][rng_type]);
+}
+
+static void max127_set_range(struct max127_data *data, int channel)
+{
+	data->ctrl_byte[channel] |= MAX127_CTRL_RNG;
+}
+
+static void max127_clear_range(struct max127_data *data, int channel)
+{
+	data->ctrl_byte[channel] &= ~MAX127_CTRL_RNG;
+}
+
+static void max127_set_polarity(struct max127_data *data, int channel)
+{
+	data->ctrl_byte[channel] |= MAX127_CTRL_BIP;
+}
+
+static void max127_clear_polarity(struct max127_data *data, int channel)
+{
+	data->ctrl_byte[channel] &= ~MAX127_CTRL_BIP;
+}
+
+static ssize_t max127_range_store(struct device *dev,
+				  struct device_attribute *devattr,
+				  const char *buf,
+				  size_t count)
+{
+	struct max127_data *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	int rng_type = attr->nr;	/* 0 for min, 1 for max */
+	int channel = attr->index;
+	int full = data->input_limit;
+	int half = full / 2;
+	long input, output;
+
+	if (kstrtol(buf, 0, &input))
+		return -EINVAL;
+
+	if (rng_type == 0) {	/* min input */
+		if (input <= -full)
+			output = -full;
+		else if (input < 0)
+			output = -half;
+		else
+			output = 0;
+	} else {		/* max input */
+		output = (input >= full) ? full : half;
+	}
+
+	if (mutex_lock_interruptible(&data->lock))
+		return -ERESTARTSYS;
+
+	if (output == -full) {
+		max127_set_polarity(data, channel);
+		max127_set_range(data, channel);
+	} else if (output == -half) {
+		max127_set_polarity(data, channel);
+		max127_clear_range(data, channel);
+	} else if (output == 0) {
+		max127_clear_polarity(data, channel);
+	} else if (output == half) {
+		max127_clear_range(data, channel);
+	} else {
+		max127_set_range(data, channel);
+	}
+
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+#define MAX127_SENSOR_DEV_ATTR_DEF(ch)					   \
+	static SENSOR_DEVICE_ATTR_RO(in##ch##_input, max127_input, ch);	   \
+	static SENSOR_DEVICE_ATTR_2_RW(in##ch##_min, max127_range, 0, ch); \
+	static SENSOR_DEVICE_ATTR_2_RW(in##ch##_max, max127_range, 1, ch)
+
+MAX127_SENSOR_DEV_ATTR_DEF(0);
+MAX127_SENSOR_DEV_ATTR_DEF(1);
+MAX127_SENSOR_DEV_ATTR_DEF(2);
+MAX127_SENSOR_DEV_ATTR_DEF(3);
+MAX127_SENSOR_DEV_ATTR_DEF(4);
+MAX127_SENSOR_DEV_ATTR_DEF(5);
+MAX127_SENSOR_DEV_ATTR_DEF(6);
+MAX127_SENSOR_DEV_ATTR_DEF(7);
+
+#define MAX127_SENSOR_DEVICE_ATTR(ch)			\
+	&sensor_dev_attr_in##ch##_input.dev_attr.attr,	\
+	&sensor_dev_attr_in##ch##_min.dev_attr.attr,	\
+	&sensor_dev_attr_in##ch##_max.dev_attr.attr
+
+static struct attribute *max127_attrs[] = {
+	MAX127_SENSOR_DEVICE_ATTR(0),
+	MAX127_SENSOR_DEVICE_ATTR(1),
+	MAX127_SENSOR_DEVICE_ATTR(2),
+	MAX127_SENSOR_DEVICE_ATTR(3),
+	MAX127_SENSOR_DEVICE_ATTR(4),
+	MAX127_SENSOR_DEVICE_ATTR(5),
+	MAX127_SENSOR_DEVICE_ATTR(6),
+	MAX127_SENSOR_DEVICE_ATTR(7),
+	NULL,
+};
+
+ATTRIBUTE_GROUPS(max127);
+
+static const struct attribute_group max127_attr_groups = {
+	.attrs = max127_attrs,
+};
+
+static int max127_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	int i;
+	struct device *hwmon_dev;
+	struct max127_data *data;
+	struct device *dev = &client->dev;
+
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->client = client;
+	mutex_init(&data->lock);
+	data->input_limit = MAX127_INPUT_LIMIT;
+	for (i = 0; i < ARRAY_SIZE(data->ctrl_byte); i++)
+		data->ctrl_byte[i] = (MAX127_CTRL_START |
+				      MAX127_SET_CHANNEL(i));
+
+	hwmon_dev = devm_hwmon_device_register_with_groups(dev,
+				client->name, data, max127_groups);
+
+	return PTR_ERR_OR_ZERO(hwmon_dev);
+}
+
+static const struct i2c_device_id max127_id[] = {
+	{ "max127", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max127_id);
+
+static struct i2c_driver max127_driver = {
+	.class		= I2C_CLASS_HWMON,
+	.driver = {
+		.name	= "max127",
+	},
+	.probe		= max127_probe,
+	.id_table	= max127_id,
+};
+
+module_i2c_driver(max127_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mike Choi <mikechoi@fb.com>");
+MODULE_AUTHOR("Tao Ren <rentao.bupt@gmail.com>");
+MODULE_DESCRIPTION("MAX127 Hardware Monitoring driver");
-- 
2.17.1

