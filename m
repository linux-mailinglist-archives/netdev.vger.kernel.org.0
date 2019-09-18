Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16493B6A8E
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 20:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388861AbfIRSgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 14:36:02 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38581 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388842AbfIRSgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 14:36:01 -0400
Received: by mail-io1-f67.google.com with SMTP id k5so1575526iol.5;
        Wed, 18 Sep 2019 11:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GKgnywCkKmSTq/e0QreLPvGEikmWmR0pjLn7CwFHdMw=;
        b=AJt5Kg3lSF3W7dIZdsRfNWghvGegv60LVKNMZULbpFCZAWNM0D2pYrMgXkrsug+t4H
         5Zd7X2VCJJ2mKZky6cClZK3TwB+GRq4anZp9NsqzPD0+9+3qrhJGhn+yLYJYFHGJW6T5
         WASpF5qQRA4oLwIk+5v+SefyJnrRDurCFPQ7l0fVEmp8pFOywhUI0XyljCb5kG3aSRmo
         gF3wOrquMZR8iYgMxlhllR+psHeRN7XAzg3eYHiCHrWh6iSC33oE7b16npjkFu0vNUol
         0xfgcnrKWjBwrvJeXXcrfLHhuFyayNvy1QZaE8LiRQCOCjIvUCK3JZgM6dywQKbJ+ehq
         ckHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GKgnywCkKmSTq/e0QreLPvGEikmWmR0pjLn7CwFHdMw=;
        b=DEHjiWSqGwsXWZrpdjG66Z1nxIK0FfofP98EBDVCaMiq3ST/jR0V/HAQK9rUCnd3/P
         MX/LB5TH5nK2BdEm3PHrL4Fr8ovPjC+mgou3cwO102/rCpxP1iriIaDoA8cE3Pr1n7J/
         Vxnv9RFrUznkzS5GFq/pfVkTpnWHELd4OdX0/sXue+Y2nG+VjwOneNc3Qr/vCJmzLjoU
         46AheuRA+tPGChd2T+pZoscnVqb3yPKHxwL7ZnGu++3gNOFYxpXTDOjXaVHq0JrRsAgU
         FsvFntTDkPV8qNWn1eIhJz2DKBghKRiQX4zelqZ8zfk4w4rb4SHnAuTSTd1QxohlunGq
         udvw==
X-Gm-Message-State: APjAAAWIJSC7B6MEXBxm6tLQszvih+Z4plRC4fX/MJbCfJMStmpfcdTC
        rkZ+wrYsEi5iM9nU8Aqwg/M=
X-Google-Smtp-Source: APXvYqx93FD4q4dp1vrXJr+LU8KrC2R81Mr/DY8OpNAJisAC5ZfULAzn6D/CEOhy5+jjdaHJQ7DOpw==
X-Received: by 2002:a5e:8b43:: with SMTP id z3mr660750iom.114.1568831759866;
        Wed, 18 Sep 2019 11:35:59 -0700 (PDT)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id s201sm8348190ios.83.2019.09.18.11.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 11:35:59 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Enrico Weigelt <lkml@metux.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        jan.kiszka@siemens.com, Frank Iwanitz <friw@hms-networks.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 3/5] staging: fieldbus core: add support for device configuration
Date:   Wed, 18 Sep 2019 14:35:50 -0400
Message-Id: <20190918183552.28959-4-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190918183552.28959-1-TheSven73@gmail.com>
References: <20190918183552.28959-1-TheSven73@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support device configuration by adding

- an in-kernel driver config API, and
- a configfs-based userspace config ABI

In short, drivers pick a subset from a set of standardized config
properties. This is exposed by the fieldbus core as configfs files.
Userspace may then configure the device by writing to these configfs
files, prior to enabling the device.

For more details, refer to the included documentation.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---
 .../Documentation/ABI/configfs-fieldbus-dev   |  90 ++++
 .../fieldbus/Documentation/fieldbus_dev.txt   |  60 ++-
 drivers/staging/fieldbus/Kconfig              |  14 +
 drivers/staging/fieldbus/Makefile             |   5 +-
 drivers/staging/fieldbus/dev_config.c         | 383 ++++++++++++++++++
 drivers/staging/fieldbus/dev_config.h         |  41 ++
 drivers/staging/fieldbus/dev_core.c           |  22 +
 drivers/staging/fieldbus/fieldbus_dev.h       |  49 +++
 8 files changed, 654 insertions(+), 10 deletions(-)
 create mode 100644 drivers/staging/fieldbus/Documentation/ABI/configfs-fieldbus-dev
 create mode 100644 drivers/staging/fieldbus/dev_config.c
 create mode 100644 drivers/staging/fieldbus/dev_config.h

diff --git a/drivers/staging/fieldbus/Documentation/ABI/configfs-fieldbus-dev b/drivers/staging/fieldbus/Documentation/ABI/configfs-fieldbus-dev
new file mode 100644
index 000000000000..fc60460b62f9
--- /dev/null
+++ b/drivers/staging/fieldbus/Documentation/ABI/configfs-fieldbus-dev
@@ -0,0 +1,90 @@
+What: 		/config/fieldbus_dev/fieldbus_dev<num>
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description: 	Interface used to configure and enable/disable fieldbus devices.
+
+		Attributes are visible only when configfs is mounted. To mount
+		configfs in /config directory use:
+		# mount -t configfs none /config/
+
+What: 		/config/fieldbus_dev/fieldbus_dev<num>/enable
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description:
+		Whether the device is enabled (power on) or
+			disabled (power off).
+		Possible values:
+			'1' meaning enabled
+			'0' meaning disabled
+		Writing '1' enables the device (power on) with settings
+			described by the configfs properties in this directory.
+		Writing '0' disables the card (power off).
+
+What: 		/config/fieldbus_dev/fieldbus_dev<num>/macaddr
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description:
+		mac address of the device, eg. E8:B3:1F:0C:6D:19
+
+What: 		/config/fieldbus_dev/fieldbus_dev<num>/ipaddr
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description:
+		IPv4 address of the device, in dotted notation
+			(eg. 192.168.22.50).
+
+What: 		/config/fieldbus_dev/fieldbus_dev<num>/offline_mode
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description:
+		Behaviour of the process data memory when the fieldbus goes
+			offline.
+		Possible values:
+			'clear'  meaning 'All data is cleared'.
+			'freeze' meaning 'All data is frozen in its current
+					state'.
+			'set'	 meaning 'All data is set'.
+
+What: 		/config/fieldbus_dev/fieldbus_dev<num>/rev_number
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description:
+		Revision number of the device.
+
+What: 		/config/fieldbus_dev/fieldbus_dev<num>/rev_date_year
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description:
+		Year of revision for the device.
+
+What: 		/config/fieldbus_dev/fieldbus_dev<num>/rev_date_month
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description:
+		Month of revision for the device.
+
+What: 		/config/fieldbus_dev/fieldbus_dev<num>/rev_date_day
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description:
+		Day of revision for the device.
+
+What: 		/config/fieldbus_dev/fieldbus_dev<num>/id_type
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description:
+		The type id by which the card identifies itself on the network.
+
+What: 		/config/fieldbus_dev/fieldbus_dev<num>/id_vendor
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description:
+		The vendor id by which the card identifies itself on the
+		network.
+
+What: 		/config/fieldbus_dev/fieldbus_dev<num>/id_product
+KernelVersion:	5.4 (staging)
+Contact:	Sven Van Asbroeck <TheSven73@gmail.com>
+Description:
+		The product id by which the card identifies itself on the
+		network.
diff --git a/drivers/staging/fieldbus/Documentation/fieldbus_dev.txt b/drivers/staging/fieldbus/Documentation/fieldbus_dev.txt
index 89fb8e14676f..a7d1ffc5e3a6 100644
--- a/drivers/staging/fieldbus/Documentation/fieldbus_dev.txt
+++ b/drivers/staging/fieldbus/Documentation/fieldbus_dev.txt
@@ -50,17 +50,61 @@ Part III - How can userspace use the subsystem?
 -----------------------------------------------
 
 Fieldbus protocols and adapters are diverse and varied. However, they share
-a limited few common behaviours and properties. This allows us to define
-a simple interface consisting of a character device and a set of sysfs files:
+a limited few common behaviours and properties. This allows us to define a
+simple interface to a running device:
+
+- a set of read-only sysfs properties, which allows userspace to query the
+  operating properties of a running device, such as online status, enabled,
+  ip address currently in use, etc.
+- a character device which allows read-write access to process data memory.
 
 See:
 drivers/staging/fieldbus/Documentation/ABI/sysfs-class-fieldbus-dev
 drivers/staging/fieldbus/Documentation/ABI/fieldbus-dev-cdev
 
-Note that this simple interface does not provide a way to modify adapter
-configuration settings. It is therefore useful only for adapters that get their
-configuration settings some other way, e.g. non-volatile memory on the adapter,
-through the network, ...
+Note: this simple interface does not provide a way to enable/disable the
+device, nor to provide configuration settings.
+
+Some types of fieldbus devices do not require any configuration settings from
+userspace at all. These are typically determined by some other way, e.g. via the
+network, or from non-volatile memory on the adapter. In this case, the driver
+may choose to make the 'enabled' sysfs property (above) read-write, so userspace
+can enable/disable the device with a simple write to the sysfs property. See the
+sysfs docs above for more details.
 
-At a later phase, this simple interface can easily co-exist with a future
-(netlink-based ?) configuration settings interface.
+To receive configuration settings from userspace, we define a simple configfs
+interface, which contains a (sub)set of standardized properties, and an 'enable'
+property.
+
+See:
+drivers/staging/fieldbus/Documentation/ABI/configfs-fieldbus-dev
+
+The driver chooses the subset of standardized properties it requires. It may
+optionally initialize these with defaults. Prior to enabling the device,
+userspace must provide suitable values for each property in the subset. It does
+so by writing to the corresponding configfs properties - or by keeping the
+driver-provided default. When userspace enables the device, the configfs
+property values are used as the device's startup configuration.
+
+Example: consider a hypothetical fieldbus card with a single config property:
+its mac address.
+
+# assume configfs is mounted on /config
+$ cd /config/fieldbus_dev/fieldbus_dev5/
+$ ls
+enable  macaddr
+# check device is disabled now
+$ cat enable
+0
+# check driver provided defaults
+$ cat macaddr
+E8:B3:1F:0C:6D:19
+# override the mac address
+$ echo 93:FB:E5:3D:0E:BF > macaddr
+# enable the device, this will use the provided mac address
+$ echo 1 > enable
+$ cat enable
+1
+# we can change the mac address property, but this will have no
+# effect on the device itself - because it's already enabled
+$ echo E8:B3:1F:0C:6D:19 > macaddr
diff --git a/drivers/staging/fieldbus/Kconfig b/drivers/staging/fieldbus/Kconfig
index b0b865acccfb..26df88a32895 100644
--- a/drivers/staging/fieldbus/Kconfig
+++ b/drivers/staging/fieldbus/Kconfig
@@ -15,5 +15,19 @@ menuconfig FIELDBUS_DEV
 
 	  If unsure, say no.
 
+if FIELDBUS_DEV
+
+config FIELDBUS_DEV_CONFIG
+	tristate "Fieldbus Device configuration support"
+	select CONFIGFS_FS
+	help
+	  Select this option to enable support for Fieldbus Device
+	  configuration. The configurable groups will be visible under
+	  /config/fieldbus_dev, assuming configfs is mounted under /config.
+
+	  If unsure, say no.
+
+endif	# FIELDBUS_DEV
+
 source "drivers/staging/fieldbus/anybuss/Kconfig"
 
diff --git a/drivers/staging/fieldbus/Makefile b/drivers/staging/fieldbus/Makefile
index bdf645d41344..6dbb9d398390 100644
--- a/drivers/staging/fieldbus/Makefile
+++ b/drivers/staging/fieldbus/Makefile
@@ -3,5 +3,6 @@
 # Makefile for fieldbus_dev drivers.
 #
 
-obj-$(CONFIG_FIELDBUS_DEV)	+= fieldbus_dev.o anybuss/
-fieldbus_dev-y			:= dev_core.o
+obj-$(CONFIG_FIELDBUS_DEV)		+= fieldbus_dev.o anybuss/
+fieldbus_dev-y				:= dev_core.o
+obj-$(CONFIG_FIELDBUS_DEV_CONFIG)	+= dev_config.o
diff --git a/drivers/staging/fieldbus/dev_config.c b/drivers/staging/fieldbus/dev_config.c
new file mode 100644
index 000000000000..266e3ca19d84
--- /dev/null
+++ b/drivers/staging/fieldbus/dev_config.c
@@ -0,0 +1,383 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Fieldbus Device Core - configuration via configfs
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/configfs.h>
+
+/* move to <linux/fieldbus_dev.h> when taking this out of staging */
+#include "fieldbus_dev.h"
+
+#include "dev_config.h"
+
+struct fieldbus_dev_config {
+	struct fieldbus_dev *fb;
+	struct config_group group;
+	struct configfs_attribute **fb_attrs;
+	struct config_item_type fb_item_type;
+};
+
+static struct fieldbus_dev_config *to_config(struct config_item *item)
+{
+	return container_of(to_config_group(item), struct fieldbus_dev_config,
+			    group);
+}
+
+enum prop_type {
+	PROP_TYPE_UNKNOWN = 0,
+	PROP_TYPE_MAC_ADDR,
+	PROP_TYPE_IP_ADDR,
+	PROP_TYPE_OFFLINE_MODE,
+	PROP_TYPE_INT,
+	PROP_TYPE_STRING
+};
+
+static enum prop_type to_prop_type(enum fieldbus_dev_cfgprop prop)
+{
+	enum prop_type t;
+
+	switch (prop) {
+	case FIELDBUS_DEV_PROP_OFFLINE_MODE:
+		t = PROP_TYPE_OFFLINE_MODE;
+		break;
+	case FIELDBUS_DEV_PROP_MAC_ADDR:
+		t = PROP_TYPE_MAC_ADDR;
+		break;
+	case FIELDBUS_DEV_PROP_IP_ADDR:
+		t = PROP_TYPE_IP_ADDR;
+		break;
+	case FIELDBUS_DEV_PROP_A1_IN_START:
+	case FIELDBUS_DEV_PROP_A1_IN_SIZE:
+	case FIELDBUS_DEV_PROP_A1_OUT_START:
+	case FIELDBUS_DEV_PROP_A1_OUT_SIZE:
+	case FIELDBUS_DEV_PROP_A2_IN_START:
+	case FIELDBUS_DEV_PROP_A2_IN_SIZE:
+	case FIELDBUS_DEV_PROP_A2_OUT_START:
+	case FIELDBUS_DEV_PROP_A2_OUT_SIZE:
+	case FIELDBUS_DEV_PROP_REV_NUMBER:
+	case FIELDBUS_DEV_PROP_REV_DATE_YEAR:
+	case FIELDBUS_DEV_PROP_REV_DATE_MONTH:
+	case FIELDBUS_DEV_PROP_REV_DATE_DAY:
+		t = PROP_TYPE_INT;
+		break;
+	case FIELDBUS_DEV_PROP_ID_TYPE:
+	case FIELDBUS_DEV_PROP_ID_VENDOR:
+	case FIELDBUS_DEV_PROP_ID_PRODUCT:
+		t = PROP_TYPE_STRING;
+		break;
+	default:
+		t = PROP_TYPE_UNKNOWN;
+		break;
+	}
+
+	return t;
+}
+
+static ssize_t
+_set_cfgprop(struct config_item *item, enum fieldbus_dev_cfgprop prop,
+	     const char *page, size_t count)
+{
+	struct fieldbus_dev_config *cfg = to_config(item);
+	enum prop_type t = to_prop_type(prop);
+	struct fieldbus_dev *fb = cfg->fb;
+	char buf[PROP_TYPE_STRING_BUFSZ];
+	union fieldbus_dev_propval val;
+	u8 addr[6];
+	int n, err;
+
+	switch (t) {
+	case PROP_TYPE_OFFLINE_MODE:
+		if (!strcmp(page, "clear\n"))
+			val.intval = FIELDBUS_DEV_OFFL_MODE_CLEAR;
+		else if (!strcmp(page, "freeze\n"))
+			val.intval = FIELDBUS_DEV_OFFL_MODE_FREEZE;
+		else if (!strcmp(page, "set\n"))
+			val.intval = FIELDBUS_DEV_OFFL_MODE_SET;
+		else
+			return -EINVAL;
+		break;
+	case PROP_TYPE_MAC_ADDR:
+		n = sscanf(page,
+			   "%02hhX:%02hhX:%02hhX:%02hhX:%02hhX:%02hhX\n",
+			   &addr[0], &addr[1], &addr[2], &addr[3], &addr[4],
+			   &addr[5]);
+		if (n != 6)
+			return -EINVAL;
+		val.addrval = addr;
+		break;
+	case PROP_TYPE_IP_ADDR:
+		n = sscanf(page, "%hhd.%hhd.%hhd.%hhd\n", &addr[0], &addr[1],
+			   &addr[2], &addr[3]);
+		if (n != 4)
+			return -EINVAL;
+		val.addrval = addr;
+		break;
+	case PROP_TYPE_INT:
+		n = sscanf(page, "%d\n", &val.intval);
+		if (n != 1)
+			return -EINVAL;
+		break;
+	case PROP_TYPE_STRING:
+		n = strlcpy(buf, page, sizeof(buf));
+		if (n >= sizeof(buf))
+			return -ENAMETOOLONG;
+		/* strip trailing \n if present */
+		if (n > 0 && buf[n - 1] == '\n')
+			buf[n - 1] = '\0';
+		val.strval = buf;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	err = fb->set_cfgprop(fb, prop, &val);
+	if (err)
+		return err;
+
+	return count;
+}
+
+static ssize_t
+_get_cfgprop(struct config_item *item, enum fieldbus_dev_cfgprop prop,
+	     char *page)
+{
+	struct fieldbus_dev_config *cfg = to_config(item);
+	enum prop_type t = to_prop_type(prop);
+	struct fieldbus_dev *fb = cfg->fb;
+	char buf[PROP_TYPE_STRING_BUFSZ];
+	union fieldbus_dev_propval val;
+	const char *mode;
+	u8 addr[6];
+	int err;
+
+	switch (t) {
+	case PROP_TYPE_OFFLINE_MODE:
+	case PROP_TYPE_INT:
+		break;
+	case PROP_TYPE_MAC_ADDR:
+	case PROP_TYPE_IP_ADDR:
+		val.addrval = addr;
+		break;
+	case PROP_TYPE_STRING:
+		val.strval = buf;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	err = fb->get_cfgprop(fb, prop, &val);
+	if (err)
+		return err;
+
+	switch (t) {
+	case PROP_TYPE_OFFLINE_MODE:
+		switch (val.intval) {
+		case FIELDBUS_DEV_OFFL_MODE_CLEAR:
+			mode = "clear";
+			break;
+		case FIELDBUS_DEV_OFFL_MODE_FREEZE:
+			mode = "freeze";
+			break;
+		case FIELDBUS_DEV_OFFL_MODE_SET:
+			mode = "set";
+			break;
+		default:
+			return -EINVAL;
+		}
+		return sprintf(page, "%s\n", mode);
+	case PROP_TYPE_MAC_ADDR:
+		return sprintf(page, "%02X:%02X:%02X:%02X:%02X:%02X\n",
+			       addr[0], addr[1], addr[2], addr[3], addr[4],
+			       addr[5]);
+	case PROP_TYPE_IP_ADDR:
+		return sprintf(page, "%pI4\n", addr);
+	case PROP_TYPE_INT:
+		return sprintf(page, "%d\n", val.intval);
+	case PROP_TYPE_STRING:
+		return sprintf(page, "%s\n", val.strval);
+	default:
+		return -EINVAL;
+	}
+
+	return -EINVAL;
+}
+
+/*
+ * Only those cfgprops supported by the device should be visible / accessible.
+ * The way this is implemented is quite ugly. I'd appreciate feedback on
+ * a more elegant way to do this with configfs.
+ */
+
+#define FIELDBUS_CONFIG_ITEM(_name, _prop)				\
+static ssize_t fb_##_name##_show(struct config_item *item, char *page)	\
+{									\
+	return _get_cfgprop(item, _prop, page);				\
+}									\
+static ssize_t fb_##_name##_store(struct config_item *item,		\
+				  const char *page, size_t count)	\
+{									\
+	return _set_cfgprop(item, _prop, page, count);			\
+}									\
+CONFIGFS_ATTR(fb_, _name)
+
+FIELDBUS_CONFIG_ITEM(macaddr, FIELDBUS_DEV_PROP_MAC_ADDR);
+FIELDBUS_CONFIG_ITEM(ipaddr, FIELDBUS_DEV_PROP_IP_ADDR);
+FIELDBUS_CONFIG_ITEM(offline_mode, FIELDBUS_DEV_PROP_OFFLINE_MODE);
+FIELDBUS_CONFIG_ITEM(a1_in_start, FIELDBUS_DEV_PROP_A1_IN_START);
+FIELDBUS_CONFIG_ITEM(a1_in_size, FIELDBUS_DEV_PROP_A1_IN_SIZE);
+FIELDBUS_CONFIG_ITEM(a1_out_start, FIELDBUS_DEV_PROP_A1_OUT_START);
+FIELDBUS_CONFIG_ITEM(a1_out_size, FIELDBUS_DEV_PROP_A1_OUT_SIZE);
+FIELDBUS_CONFIG_ITEM(a2_in_start, FIELDBUS_DEV_PROP_A2_IN_START);
+FIELDBUS_CONFIG_ITEM(a2_in_size, FIELDBUS_DEV_PROP_A2_IN_SIZE);
+FIELDBUS_CONFIG_ITEM(a2_out_start, FIELDBUS_DEV_PROP_A2_OUT_START);
+FIELDBUS_CONFIG_ITEM(a2_out_size, FIELDBUS_DEV_PROP_A2_OUT_SIZE);
+FIELDBUS_CONFIG_ITEM(rev_number, FIELDBUS_DEV_PROP_REV_NUMBER);
+FIELDBUS_CONFIG_ITEM(rev_date_year, FIELDBUS_DEV_PROP_REV_DATE_YEAR);
+FIELDBUS_CONFIG_ITEM(rev_date_month, FIELDBUS_DEV_PROP_REV_DATE_MONTH);
+FIELDBUS_CONFIG_ITEM(rev_date_day, FIELDBUS_DEV_PROP_REV_DATE_DAY);
+FIELDBUS_CONFIG_ITEM(id_type, FIELDBUS_DEV_PROP_ID_TYPE);
+FIELDBUS_CONFIG_ITEM(id_vendor, FIELDBUS_DEV_PROP_ID_VENDOR);
+FIELDBUS_CONFIG_ITEM(id_product, FIELDBUS_DEV_PROP_ID_PRODUCT);
+
+static struct configfs_attribute *fb_all_attrs[] = {
+	[FIELDBUS_DEV_PROP_MAC_ADDR] = &fb_attr_macaddr,
+	[FIELDBUS_DEV_PROP_IP_ADDR] = &fb_attr_ipaddr,
+	[FIELDBUS_DEV_PROP_OFFLINE_MODE] = &fb_attr_offline_mode,
+	[FIELDBUS_DEV_PROP_A1_IN_START] = &fb_attr_a1_in_start,
+	[FIELDBUS_DEV_PROP_A1_IN_SIZE] = &fb_attr_a1_in_size,
+	[FIELDBUS_DEV_PROP_A1_OUT_START] = &fb_attr_a1_out_start,
+	[FIELDBUS_DEV_PROP_A1_OUT_SIZE] = &fb_attr_a1_out_size,
+	[FIELDBUS_DEV_PROP_A2_IN_START] = &fb_attr_a2_in_start,
+	[FIELDBUS_DEV_PROP_A2_IN_SIZE] = &fb_attr_a2_in_size,
+	[FIELDBUS_DEV_PROP_A2_OUT_START] = &fb_attr_a2_out_start,
+	[FIELDBUS_DEV_PROP_A2_OUT_SIZE] = &fb_attr_a2_out_size,
+	[FIELDBUS_DEV_PROP_REV_NUMBER] = &fb_attr_rev_number,
+	[FIELDBUS_DEV_PROP_REV_DATE_YEAR] = &fb_attr_rev_date_year,
+	[FIELDBUS_DEV_PROP_REV_DATE_MONTH] = &fb_attr_rev_date_month,
+	[FIELDBUS_DEV_PROP_REV_DATE_DAY] = &fb_attr_rev_date_day,
+	[FIELDBUS_DEV_PROP_ID_TYPE] = &fb_attr_id_type,
+	[FIELDBUS_DEV_PROP_ID_VENDOR] = &fb_attr_id_vendor,
+	[FIELDBUS_DEV_PROP_ID_PRODUCT] = &fb_attr_id_product,
+};
+
+static ssize_t fb_enable_show(struct config_item *item, char *page)
+{
+	struct fieldbus_dev_config *cfg = to_config(item);
+	struct fieldbus_dev *fb = cfg->fb;
+
+	return sprintf(page, "%d\n", !!fb->enable_get(fb));
+}
+
+static ssize_t
+fb_enable_store(struct config_item *item, const char *page, size_t count)
+{
+	struct fieldbus_dev_config *cfg = to_config(item);
+	struct fieldbus_dev *fb = cfg->fb;
+	bool value;
+	int ret;
+
+	ret = kstrtobool(page, &value);
+	if (ret)
+		return ret;
+	ret = fb->enable_set(fb, value);
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+CONFIGFS_ATTR(fb_, enable);
+
+static struct configfs_attribute **fb_create_attrs(struct fieldbus_dev *fb)
+{
+	struct configfs_attribute **attrs;
+	int i;
+
+	/* cherry-pick the cfgprops we want, plus 'enable' and trailing NULL */
+	attrs = kcalloc(fb->num_cfgprops + 2, sizeof(*attrs), GFP_KERNEL);
+	if (!attrs)
+		return NULL;
+	for (i = 0; i < fb->num_cfgprops; i++)
+		attrs[i] = fb_all_attrs[fb->cfgprops[i]];
+	attrs[fb->num_cfgprops] = &fb_attr_enable;
+
+	return attrs;
+}
+
+static const struct config_item_type fb_root_group_type = {
+	.ct_owner       = THIS_MODULE,
+};
+
+static struct configfs_subsystem fieldbus_dev_subsys = {
+	.su_group = {
+		.cg_item = {
+			.ci_namebuf = "fieldbus_dev",
+			.ci_type = &fb_root_group_type,
+		},
+	},
+	.su_mutex = __MUTEX_INITIALIZER(fieldbus_dev_subsys.su_mutex),
+};
+
+struct fieldbus_dev_config *
+fieldbus_dev_config_register(struct fieldbus_dev *fb)
+{
+	struct config_group *group;
+	struct fieldbus_dev_config *cfg;
+	struct config_item *cg_item;
+	int err;
+
+	/* some configuration info not filled in? return error */
+	if (!fb || !fb->cfgprops || !fb->num_cfgprops || !fb->get_cfgprop ||
+	    !fb->set_cfgprop || !fb->enable_set)
+		return ERR_PTR(-EINVAL);
+	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!cfg)
+		return ERR_PTR(-ENOMEM);
+	cfg->fb = fb;
+	group = &cfg->group;
+	cg_item = &group->cg_item;
+	config_item_set_name(cg_item, "%s", dev_name(fb->dev));
+	cfg->fb_attrs = fb_create_attrs(fb);
+	if (!cfg->fb_attrs) {
+		kfree(cfg);
+		return ERR_PTR(-ENOMEM);
+	}
+	cfg->fb_item_type.ct_owner = THIS_MODULE;
+	cfg->fb_item_type.ct_attrs = cfg->fb_attrs;
+	cg_item->ci_type = &cfg->fb_item_type;
+	config_group_init(group);
+	err = configfs_register_group(&fieldbus_dev_subsys.su_group, group);
+	if (err) {
+		kfree(cfg->fb_attrs);
+		kfree(cfg);
+		return ERR_PTR(err);
+	}
+
+	return cfg;
+}
+EXPORT_SYMBOL_GPL(fieldbus_dev_config_register);
+
+void fieldbus_dev_config_unregister(struct fieldbus_dev_config *cfg)
+{
+	if (cfg) {
+		configfs_unregister_group(&cfg->group);
+		kfree(cfg->fb_attrs);
+		kfree(cfg);
+	}
+}
+EXPORT_SYMBOL_GPL(fieldbus_dev_config_unregister);
+
+int fieldbus_dev_config_init(void)
+{
+	config_group_init(&fieldbus_dev_subsys.su_group);
+
+	return configfs_register_subsystem(&fieldbus_dev_subsys);
+}
+EXPORT_SYMBOL_GPL(fieldbus_dev_config_init);
+
+void fieldbus_dev_config_exit(void)
+{
+	configfs_unregister_subsystem(&fieldbus_dev_subsys);
+}
+EXPORT_SYMBOL_GPL(fieldbus_dev_config_exit);
diff --git a/drivers/staging/fieldbus/dev_config.h b/drivers/staging/fieldbus/dev_config.h
new file mode 100644
index 000000000000..4ead6464d541
--- /dev/null
+++ b/drivers/staging/fieldbus/dev_config.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Fieldbus Device Core - configuration
+ *
+ */
+
+#ifndef __FIELDBUS_DEV_CONFIG_H
+#define __FIELDBUS_DEV_CONFIG_H
+
+struct fieldbus_dev_config;
+struct fieldbus_dev;
+
+#if IS_ENABLED(CONFIG_FIELDBUS_DEV_CONFIG)
+
+struct fieldbus_dev_config *
+fieldbus_dev_config_register(struct fieldbus_dev *fb);
+
+void fieldbus_dev_config_unregister(struct fieldbus_dev_config *cfg);
+
+int fieldbus_dev_config_init(void);
+void fieldbus_dev_config_exit(void);
+
+#else /* IS_ENABLED(CONFIG_FIELDBUS_DEV_CONFIG) */
+
+struct fieldbus_dev_config *
+fieldbus_dev_config_register(struct fieldbus_dev *fb)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+void fieldbus_dev_config_unregister(struct fieldbus_dev_config *cfg) {}
+
+int fieldbus_dev_config_init(void)
+{
+	return 0;
+}
+
+void fieldbus_dev_config_exit(void) {}
+
+#endif /* IS_ENABLED(CONFIG_FIELDBUS_DEV_CONFIG) */
+#endif /* __FIELDBUS_DEV_CONFIG_H */
diff --git a/drivers/staging/fieldbus/dev_core.c b/drivers/staging/fieldbus/dev_core.c
index 1ba0234cc60d..9903c4f3cba9 100644
--- a/drivers/staging/fieldbus/dev_core.c
+++ b/drivers/staging/fieldbus/dev_core.c
@@ -15,6 +15,8 @@
 /* move to <linux/fieldbus_dev.h> when taking this out of staging */
 #include "fieldbus_dev.h"
 
+#include "dev_config.h"
+
 /* Maximum number of fieldbus devices */
 #define MAX_FIELDBUSES		32
 
@@ -249,6 +251,7 @@ static void __fieldbus_dev_unregister(struct fieldbus_dev *fb)
 {
 	if (!fb)
 		return;
+	fieldbus_dev_config_unregister(fb->cfg);
 	device_destroy(&fieldbus_class, fb->cdev.dev);
 	cdev_del(&fb->cdev);
 	ida_simple_remove(&fieldbus_ida, fb->id);
@@ -289,8 +292,19 @@ static int __fieldbus_dev_register(struct fieldbus_dev *fb)
 		err = PTR_ERR(fb->dev);
 		goto err_dev_create;
 	}
+	/* configuration interface required? */
+	if (fb->cfgprops || fb->num_cfgprops || fb->get_cfgprop ||
+	    fb->set_cfgprop || fb->enable_set) {
+		fb->cfg = fieldbus_dev_config_register(fb);
+		if (IS_ERR(fb->cfg)) {
+			err = PTR_ERR(fb->cfg);
+			goto err_cfg_create;
+		}
+	}
 	return 0;
 
+err_cfg_create:
+	device_destroy(&fieldbus_class, fb->cdev.dev);
 err_dev_create:
 	cdev_del(&fb->cdev);
 err_cdev:
@@ -325,8 +339,15 @@ static int __init fieldbus_init(void)
 		pr_err("fieldbus_dev: unable to allocate char dev region\n");
 		goto err_alloc;
 	}
+	err = fieldbus_dev_config_init();
+	if (err < 0) {
+		pr_err("fieldbus_dev: unable to init config");
+		goto err_config;
+	}
 	return 0;
 
+err_config:
+	unregister_chrdev_region(fieldbus_devt, MAX_FIELDBUSES);
 err_alloc:
 	class_unregister(&fieldbus_class);
 	return err;
@@ -334,6 +355,7 @@ static int __init fieldbus_init(void)
 
 static void __exit fieldbus_exit(void)
 {
+	fieldbus_dev_config_exit();
 	unregister_chrdev_region(fieldbus_devt, MAX_FIELDBUSES);
 	class_unregister(&fieldbus_class);
 	ida_destroy(&fieldbus_ida);
diff --git a/drivers/staging/fieldbus/fieldbus_dev.h b/drivers/staging/fieldbus/fieldbus_dev.h
index 301dca3b8d71..3b00315600e5 100644
--- a/drivers/staging/fieldbus/fieldbus_dev.h
+++ b/drivers/staging/fieldbus/fieldbus_dev.h
@@ -10,6 +10,8 @@
 #include <linux/cdev.h>
 #include <linux/wait.h>
 
+struct fieldbus_dev_config;
+
 enum fieldbus_dev_type {
 	FIELDBUS_DEV_TYPE_UNKNOWN = 0,
 	FIELDBUS_DEV_TYPE_PROFINET,
@@ -21,6 +23,38 @@ enum fieldbus_dev_offl_mode {
 	FIELDBUS_DEV_OFFL_MODE_SET
 };
 
+enum fieldbus_dev_cfgprop {
+	/* property of type 'u8 *' (addrval in fieldbus_dev_propval) */
+	FIELDBUS_DEV_PROP_MAC_ADDR = 0,
+	FIELDBUS_DEV_PROP_IP_ADDR,
+	/* properties of type 'int' (intval in fieldbus_dev_propval) */
+	FIELDBUS_DEV_PROP_OFFLINE_MODE,
+	FIELDBUS_DEV_PROP_A1_IN_START,
+	FIELDBUS_DEV_PROP_A1_IN_SIZE,
+	FIELDBUS_DEV_PROP_A1_OUT_START,
+	FIELDBUS_DEV_PROP_A1_OUT_SIZE,
+	FIELDBUS_DEV_PROP_A2_IN_START,
+	FIELDBUS_DEV_PROP_A2_IN_SIZE,
+	FIELDBUS_DEV_PROP_A2_OUT_START,
+	FIELDBUS_DEV_PROP_A2_OUT_SIZE,
+	FIELDBUS_DEV_PROP_REV_NUMBER,
+	FIELDBUS_DEV_PROP_REV_DATE_YEAR,
+	FIELDBUS_DEV_PROP_REV_DATE_MONTH,
+	FIELDBUS_DEV_PROP_REV_DATE_DAY,
+	/* properties of type 'char *' (strval in fieldbus_dev_propval) */
+	FIELDBUS_DEV_PROP_ID_TYPE,
+	FIELDBUS_DEV_PROP_ID_VENDOR,
+	FIELDBUS_DEV_PROP_ID_PRODUCT
+};
+
+#define PROP_TYPE_STRING_BUFSZ	128
+
+union fieldbus_dev_propval {
+	int intval;
+	u8 *addrval;
+	char *strval; /* buffer size: PROP_TYPE_STRING_BUFSZ */
+};
+
 /**
  * struct fieldbus_dev - Fieldbus device
  * @read_area:		[DRIVER] function to read the process data area of the
@@ -41,6 +75,13 @@ enum fieldbus_dev_offl_mode {
  *				 return value follows the snprintf convention
  * @simple_enable_set	[DRIVER] (optional) function to enable the device
  *				 according to its default settings
+ * @enable_set		[DRIVER] (optional) function to enable the device
+ *				 according to its config properties (see below)
+ * @cfgprops		[DRIVER] (optional) list of supported config properties
+ * @num_cfgprops	[DRIVER] (optional) number of supported config
+ *				 properties
+ * @get_cfgprop		[DRIVER] (optional) function to get a config property
+ * @set_cfgprop		[DRIVER] (optional) function to set a config property
  * @parent		[DRIVER] (optional) the device's parent device
  */
 struct fieldbus_dev {
@@ -56,6 +97,13 @@ struct fieldbus_dev {
 	int (*fieldbus_id_get)(struct fieldbus_dev *fbdev, char *buf,
 			       size_t max_size);
 	int (*simple_enable_set)(struct fieldbus_dev *fbdev, bool enable);
+	int (*enable_set)(struct fieldbus_dev *fbdev, bool enable);
+	const enum fieldbus_dev_cfgprop *cfgprops;
+	size_t num_cfgprops;
+	int (*get_cfgprop)(struct fieldbus_dev *fb, enum fieldbus_dev_cfgprop,
+			   union fieldbus_dev_propval *val);
+	int (*set_cfgprop)(struct fieldbus_dev *fb, enum fieldbus_dev_cfgprop,
+			   const union fieldbus_dev_propval *val);
 	struct device *parent;
 
 	/* private data */
@@ -65,6 +113,7 @@ struct fieldbus_dev {
 	int dc_event;
 	wait_queue_head_t dc_wq;
 	bool online;
+	struct fieldbus_dev_config *cfg;
 };
 
 #if IS_ENABLED(CONFIG_FIELDBUS_DEV)
-- 
2.17.1

