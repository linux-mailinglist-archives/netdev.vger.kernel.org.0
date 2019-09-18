Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487F7B6A92
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 20:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388879AbfIRSgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 14:36:04 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36202 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388852AbfIRSgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 14:36:03 -0400
Received: by mail-io1-f67.google.com with SMTP id b136so1609464iof.3;
        Wed, 18 Sep 2019 11:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ceH7V4gJ41xQfvzmCXW+ZuYzVS2GovbuO0nBvHMQ4TQ=;
        b=ElqVsB9lRkhlvXeqDM3X7x4/dgwy2RTnip58JDQzDY8/5+qeHPyTyQM4oA9cNayZWU
         /W9eLq3Wx0tNxRhkNRFFi8XKpYlfIP6/eILGpIRvNNR5fwVlpeK/ynR4gAL8xMaVSTlz
         ow7CR52cdo/dv1jppfoghW5ybAJRzRFahrlbzBSHjkxb+oHMfrxyzojoPlBzB81f4N/g
         H4YcEE1279xDa1M74NWxr0d7tRSh6NH0IOZoJ+l5cOuwVKojMuSHIv7Zlv6lsukRh8QF
         r8Lihdxmwk48mkM48NSbCbn1Yb6mp+EZ5bJc6PXN7V5AEVUggwS5nCkLCx/zOtZDRhQ5
         LDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ceH7V4gJ41xQfvzmCXW+ZuYzVS2GovbuO0nBvHMQ4TQ=;
        b=O+uLWQ+JLH26sH8whysB4wp7XxEC/0w5YY9oC1QcT0iyN6gOrYKIbld9tbC7k6EASO
         nfgZCDcZdupt5nw/4b1rp3s20icqXEkZw1MuqFLUpUeAMLUWvgIhflTX8zoxVYT1aBdX
         N5vlMFbdqk29XjlBrf4kle67B9ghRPrtuT18afHtHVm5iGy0MbKuUCSszTMBb7J0TkLR
         VZy7o2VM4h/Ys6Y7s/35lFO+iIDfauuCdWxAHB2ZeUj+jygy4axnha4iENSuz3FkLfzq
         shadBiiRam8tNVXoTtw7iUn+2ExzjM95th9xUn+2IVYNtG5sDgtNWizhTK9I/Wl6s4hX
         IlpQ==
X-Gm-Message-State: APjAAAXrGbTCq0A6cv3PgMreXRINb9BTY0pAIIzxbc0BamA5N9ejVpMr
        jt2YhCeXVtNIYXDEZr3k6uU=
X-Google-Smtp-Source: APXvYqyVBHzpmS860hcn9/BT9U7RDIapdUUmHHQN7v6AKfz0BUnzB+dtxLtziB5QfuFR/kM4paEWOw==
X-Received: by 2002:a6b:d208:: with SMTP id q8mr3583806iob.47.1568831761669;
        Wed, 18 Sep 2019 11:36:01 -0700 (PDT)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id s201sm8348190ios.83.2019.09.18.11.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 11:36:01 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Enrico Weigelt <lkml@metux.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        jan.kiszka@siemens.com, Frank Iwanitz <friw@hms-networks.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 5/5] staging: fieldbus: add support for HMS FL-NET industrial controller
Date:   Wed, 18 Sep 2019 14:35:52 -0400
Message-Id: <20190918183552.28959-6-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190918183552.28959-1-TheSven73@gmail.com>
References: <20190918183552.28959-1-TheSven73@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Anybus-S FL-NET provides full FL-NET Class 1 functionality via the
patented Anybus-S application interface. Any device supporting this
standard can take advantage of the features offered by the module,
providing seamless network integration regardless of network type.

FL-NET is a control network, primarily used for interconnection of devices
such as PLCs, Robot Controllers and Numerical Control Devices. It features
both cyclic and acyclic data exchange capabilities, and uses a token-based
communication scheme for data transmission. The Anybus module is classified
as a 'Class 1'-node, which means that it supports cyclic data exchange in
both directions.

Official documentation:
https://www.anybus.com/docs/librariesprovider7/default-document-library
/manuals-design-guides/hms-scm_1200_073.pdf

This implementation is an Anybus-S client driver, designed to be
instantiated by the Anybus-S bus driver when it discovers the FL-NET
card.

If loaded successfully, the driver registers itself as a fieldbus_dev,
and userspace can access it through the fieldbus_dev interface.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---
 drivers/staging/fieldbus/anybuss/Kconfig     |  17 +
 drivers/staging/fieldbus/anybuss/Makefile    |   1 +
 drivers/staging/fieldbus/anybuss/hms-flnet.c | 520 +++++++++++++++++++
 3 files changed, 538 insertions(+)
 create mode 100644 drivers/staging/fieldbus/anybuss/hms-flnet.c

diff --git a/drivers/staging/fieldbus/anybuss/Kconfig b/drivers/staging/fieldbus/anybuss/Kconfig
index 635a0a7b7dd2..8441c6ac210b 100644
--- a/drivers/staging/fieldbus/anybuss/Kconfig
+++ b/drivers/staging/fieldbus/anybuss/Kconfig
@@ -38,4 +38,21 @@ config HMS_PROFINET
 
 	  If unsure, say N.
 
+config HMS_FLNET
+	tristate "HMS FL-Net Controller (Anybus-S)"
+	depends on FIELDBUS_DEV && HMS_ANYBUSS_BUS
+	select FIELDBUS_DEV_CONFIG
+	help
+	  If you say yes here you get support for the HMS Industrial
+	  Networks FL-Net Controller.
+
+	  It will be registered with the kernel as a fieldbus_dev,
+	  so userspace can interact with it via the fieldbus_dev userspace
+	  interface(s).
+
+	  This driver can also be built as a module. If so, the module
+	  will be called hms-flnet.
+
+	  If unsure, say N.
+
 endif
diff --git a/drivers/staging/fieldbus/anybuss/Makefile b/drivers/staging/fieldbus/anybuss/Makefile
index 3ad3dcc6be56..79c4083508f4 100644
--- a/drivers/staging/fieldbus/anybuss/Makefile
+++ b/drivers/staging/fieldbus/anybuss/Makefile
@@ -8,3 +8,4 @@ anybuss_core-y			+= host.o
 
 obj-$(CONFIG_ARCX_ANYBUS_CONTROLLER) += arcx-anybus.o
 obj-$(CONFIG_HMS_PROFINET)	+= hms-profinet.o
+obj-$(CONFIG_HMS_FLNET)		+= hms-flnet.o
diff --git a/drivers/staging/fieldbus/anybuss/hms-flnet.c b/drivers/staging/fieldbus/anybuss/hms-flnet.c
new file mode 100644
index 000000000000..4dd0f66fe8ce
--- /dev/null
+++ b/drivers/staging/fieldbus/anybuss/hms-flnet.c
@@ -0,0 +1,520 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * HMS FL-Net Client Driver
+ *
+ * Copyright (C) 2019 Arcx Inc
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+
+/* move to <linux/fieldbus_dev.h> when taking this out of staging */
+#include "../fieldbus_dev.h"
+
+/* move to <linux/anybuss-client.h> when taking this out of staging */
+#include "anybuss-client.h"
+
+#define FL_DPRAM_SIZE	512
+
+/*
+ * ---------------------------------------------------------------
+ * Anybus FL-Net mailbox messages - definitions
+ * ---------------------------------------------------------------
+ * note that we're depending on the layout of these structures being
+ * exactly as advertised.
+ */
+
+struct msg_ip_addr {
+	u8 addr[4];
+};
+
+struct msg_map {
+	__be16 start;
+	__be16 size;
+};
+
+struct msg_map_io {
+	struct msg_map a1_in;
+	struct msg_map a2_in;
+	struct msg_map a1_out;
+	struct msg_map a2_out;
+};
+
+#define FL_ID_BUFSZ	10
+
+struct msg_set_profile {
+	u8	rev_number;
+	u8	rev_year_hi;
+	u8	rev_year_lo;
+	u8	rev_month;
+	u8	rev_day;
+	/* id_XXX must be space-padded and not null terminated */
+	char	id_type[FL_ID_BUFSZ];
+	char	null0;
+	char	id_vendor[FL_ID_BUFSZ];
+	char	null1;
+	char	id_product[FL_ID_BUFSZ];
+	char	null2;
+};
+
+struct fl_priv {
+	struct fieldbus_dev fbdev;
+	struct anybuss_client *client;
+	struct mutex enable_lock; /* serializes card enable */
+	bool power_on;
+	/* configuration properties */
+	enum fieldbus_dev_offl_mode offl_mode;
+	struct msg_ip_addr ip;
+	struct msg_map_io mapio;
+	u8 rev_number;
+	u16 rev_year;
+	u8 rev_month;
+	u8 rev_day;
+	char id_type[FL_ID_BUFSZ + 1];
+	char id_vendor[FL_ID_BUFSZ + 1];
+	char id_product[FL_ID_BUFSZ + 1];
+};
+
+static void fl_on_area_updated(struct anybuss_client *client)
+{
+	struct fl_priv *priv = anybuss_get_drvdata(client);
+
+	fieldbus_dev_area_updated(&priv->fbdev);
+}
+
+static void fl_on_online_changed(struct anybuss_client *client, bool online)
+{
+	struct fl_priv *priv = anybuss_get_drvdata(client);
+
+	fieldbus_dev_online_changed(&priv->fbdev, online);
+}
+
+static ssize_t
+fl_read_area(struct fieldbus_dev *fbdev, char __user *buf, size_t size,
+	     loff_t *offset)
+{
+	struct fl_priv *priv = container_of(fbdev, struct fl_priv, fbdev);
+
+	return anybuss_read_output(priv->client, buf, size, offset);
+}
+
+static ssize_t
+fl_write_area(struct fieldbus_dev *fbdev, const char __user *buf,
+	      size_t size, loff_t *offset)
+{
+	struct fl_priv *priv = container_of(fbdev, struct fl_priv, fbdev);
+
+	return anybuss_write_input(priv->client, buf, size, offset);
+}
+
+static int fl_id_get(struct fieldbus_dev *fbdev, char *buf, size_t max_size)
+{
+	struct fl_priv *priv = container_of(fbdev, struct fl_priv, fbdev);
+	struct msg_ip_addr response;
+	int ret;
+
+	ret = anybuss_recv_msg(priv->client, 0x0002, &response,
+			       sizeof(response));
+	if (ret < 0)
+		return ret;
+	return sprintf(buf, "%pI4\n", response.addr);
+}
+
+static bool fl_enable_get(struct fieldbus_dev *fbdev)
+{
+	struct fl_priv *priv = container_of(fbdev, struct fl_priv, fbdev);
+	bool power_on;
+
+	mutex_lock(&priv->enable_lock);
+	power_on = priv->power_on;
+	mutex_unlock(&priv->enable_lock);
+
+	return power_on;
+}
+
+static bool ip_is_null(struct msg_ip_addr *ip)
+{
+	return !ip->addr[0] && !ip->addr[1] && !ip->addr[2] && !ip->addr[3];
+}
+
+static bool map_is_empty(struct msg_map_io *map)
+{
+	return !map->a1_in.size && !map->a1_out.size && !map->a2_in.size &&
+	       !map->a2_out.size;
+}
+
+static void fl_id_copy_pad(char *id, const char *src)
+{
+	memset(id, ' ', FL_ID_BUFSZ);
+	memcpy(id, src, min_t(size_t, strlen(src), FL_ID_BUFSZ));
+}
+
+static int __fl_enable(struct fl_priv *priv)
+{
+	int ret;
+	size_t len;
+	struct anybuss_client *client = priv->client;
+	/* Initialization Sequence, Generic Anybus Mode */
+	struct anybuss_memcfg mem_cfg = {
+		.input_io = FL_DPRAM_SIZE,
+		.input_dpram = FL_DPRAM_SIZE,
+		.input_total = FL_DPRAM_SIZE,
+		.output_io = FL_DPRAM_SIZE,
+		.output_dpram = FL_DPRAM_SIZE,
+		.output_total = FL_DPRAM_SIZE,
+		.offl_mode = priv->offl_mode,
+	};
+	struct msg_set_profile profile = {
+		.rev_number = priv->rev_number,
+		.rev_day = priv->rev_day,
+		.rev_month = priv->rev_month,
+		.rev_year_hi = priv->rev_year >> 8,
+		.rev_year_lo = priv->rev_year & 0xFF,
+	};
+
+	if (map_is_empty(&priv->mapio)) {
+		dev_err(&client->dev, "empty I/O area mapping");
+		return -EINVAL;
+	}
+	len = be16_to_cpu(priv->mapio.a1_in.size) +
+			be16_to_cpu(priv->mapio.a2_in.size);
+	if (len > FL_DPRAM_SIZE) {
+		dev_err(&client->dev, "I/O input area mapping too large");
+		return -EINVAL;
+	}
+	len = be16_to_cpu(priv->mapio.a1_out.size) +
+			be16_to_cpu(priv->mapio.a2_out.size);
+	if (len > FL_DPRAM_SIZE) {
+		dev_err(&client->dev, "I/O output area mapping too large");
+		return -EINVAL;
+	}
+	if (ip_is_null(&priv->ip)) {
+		dev_err(&client->dev, "null ip address");
+		return -EINVAL;
+	}
+
+	/*
+	 * switch anybus off then on, this ensures we can do a complete
+	 * configuration cycle in case anybus was already on.
+	 */
+	anybuss_set_power(client, false);
+	ret = anybuss_set_power(client, true);
+	if (ret)
+		goto err;
+	ret = anybuss_start_init(client, &mem_cfg);
+	if (ret)
+		goto err;
+	/* set ip address */
+	ret = anybuss_send_msg(client, 0x0001, &priv->ip,
+			       sizeof(priv->ip));
+	if (ret)
+		goto err;
+	/* map io */
+	ret = anybuss_send_msg(client, 0x0020, &priv->mapio,
+			       sizeof(priv->mapio));
+	if (ret)
+		goto err;
+	/* set profile */
+	fl_id_copy_pad(profile.id_type, priv->id_type);
+	fl_id_copy_pad(profile.id_vendor, priv->id_vendor);
+	fl_id_copy_pad(profile.id_product, priv->id_product);
+	ret = anybuss_send_msg(client, 0x0023, &profile, sizeof(profile));
+	if (ret)
+		goto err;
+	ret = anybuss_finish_init(client);
+	if (ret)
+		goto err;
+	priv->power_on = true;
+	return 0;
+
+err:
+	anybuss_set_power(client, false);
+	priv->power_on = false;
+	return ret;
+}
+
+static int __fl_disable(struct fl_priv *priv)
+{
+	struct anybuss_client *client = priv->client;
+
+	anybuss_set_power(client, false);
+	priv->power_on = false;
+	return 0;
+}
+
+static int fl_enable(struct fieldbus_dev *fbdev, bool enable)
+{
+	int ret;
+	struct fl_priv *priv = container_of(fbdev, struct fl_priv, fbdev);
+
+	mutex_lock(&priv->enable_lock);
+	if (enable)
+		ret = __fl_enable(priv);
+	else
+		ret = __fl_disable(priv);
+	mutex_unlock(&priv->enable_lock);
+
+	return ret;
+}
+
+static const enum fieldbus_dev_cfgprop config_props[] = {
+	FIELDBUS_DEV_PROP_IP_ADDR,
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
+	FIELDBUS_DEV_PROP_ID_TYPE,
+	FIELDBUS_DEV_PROP_ID_VENDOR,
+	FIELDBUS_DEV_PROP_ID_PRODUCT
+};
+
+static int fl_get_cfgprop(struct fieldbus_dev *fbdev,
+			  enum fieldbus_dev_cfgprop prop,
+			  union fieldbus_dev_propval *val)
+{
+	struct fl_priv *priv = container_of(fbdev, struct fl_priv, fbdev);
+	struct msg_map_io *mapio = &priv->mapio;
+
+	switch (prop) {
+	case FIELDBUS_DEV_PROP_OFFLINE_MODE:
+		val->intval = priv->offl_mode;
+		break;
+	case FIELDBUS_DEV_PROP_IP_ADDR:
+		memcpy(val->addrval, &priv->ip.addr, sizeof(priv->ip.addr));
+		break;
+	case FIELDBUS_DEV_PROP_A1_IN_START:
+		val->intval = be16_to_cpu(mapio->a1_in.start);
+		break;
+	case FIELDBUS_DEV_PROP_A1_IN_SIZE:
+		val->intval = be16_to_cpu(mapio->a1_in.size);
+		break;
+	case FIELDBUS_DEV_PROP_A1_OUT_START:
+		val->intval = be16_to_cpu(mapio->a1_out.start);
+		break;
+	case FIELDBUS_DEV_PROP_A1_OUT_SIZE:
+		val->intval = be16_to_cpu(mapio->a1_out.size);
+		break;
+	case FIELDBUS_DEV_PROP_A2_IN_START:
+		val->intval = be16_to_cpu(mapio->a2_in.start);
+		break;
+	case FIELDBUS_DEV_PROP_A2_IN_SIZE:
+		val->intval = be16_to_cpu(mapio->a2_in.size);
+		break;
+	case FIELDBUS_DEV_PROP_A2_OUT_START:
+		val->intval = be16_to_cpu(mapio->a2_out.start);
+		break;
+	case FIELDBUS_DEV_PROP_A2_OUT_SIZE:
+		val->intval = be16_to_cpu(mapio->a2_out.size);
+		break;
+	case FIELDBUS_DEV_PROP_REV_NUMBER:
+		val->intval = priv->rev_number;
+		break;
+	case FIELDBUS_DEV_PROP_REV_DATE_YEAR:
+		val->intval = priv->rev_year;
+		break;
+	case FIELDBUS_DEV_PROP_REV_DATE_MONTH:
+		val->intval = priv->rev_month;
+		break;
+	case FIELDBUS_DEV_PROP_REV_DATE_DAY:
+		val->intval = priv->rev_day;
+		break;
+	case FIELDBUS_DEV_PROP_ID_TYPE:
+		strcpy(val->strval, priv->id_type);
+		break;
+	case FIELDBUS_DEV_PROP_ID_VENDOR:
+		strcpy(val->strval, priv->id_vendor);
+		break;
+	case FIELDBUS_DEV_PROP_ID_PRODUCT:
+		strcpy(val->strval, priv->id_product);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int fl_set_cfgprop(struct fieldbus_dev *fbdev,
+			  enum fieldbus_dev_cfgprop prop,
+			  const union fieldbus_dev_propval *val)
+{
+	struct fl_priv *priv = container_of(fbdev, struct fl_priv, fbdev);
+	struct msg_map_io *mapio = &priv->mapio;
+
+	/* validate userspace inputs */
+	switch (prop) {
+	case FIELDBUS_DEV_PROP_A1_IN_START:
+	case FIELDBUS_DEV_PROP_A1_IN_SIZE:
+	case FIELDBUS_DEV_PROP_A1_OUT_START:
+	case FIELDBUS_DEV_PROP_A1_OUT_SIZE:
+	case FIELDBUS_DEV_PROP_A2_IN_START:
+	case FIELDBUS_DEV_PROP_A2_IN_SIZE:
+	case FIELDBUS_DEV_PROP_A2_OUT_START:
+	case FIELDBUS_DEV_PROP_A2_OUT_SIZE:
+	case FIELDBUS_DEV_PROP_REV_DATE_YEAR:
+		/* must be u16 */
+		if (val->intval & ~0xFFFF)
+			return -EINVAL;
+		break;
+	case FIELDBUS_DEV_PROP_REV_NUMBER:
+	case FIELDBUS_DEV_PROP_REV_DATE_MONTH:
+	case FIELDBUS_DEV_PROP_REV_DATE_DAY:
+		/* must be u8 */
+		if (val->intval & ~0xFF)
+			return -EINVAL;
+		break;
+	case FIELDBUS_DEV_PROP_ID_TYPE:
+	case FIELDBUS_DEV_PROP_ID_VENDOR:
+	case FIELDBUS_DEV_PROP_ID_PRODUCT:
+		if (strlen(val->strval) > FL_ID_BUFSZ)
+			return -EINVAL;
+		break;
+	default:
+		break;
+	}
+
+	switch (prop) {
+	case FIELDBUS_DEV_PROP_OFFLINE_MODE:
+		priv->offl_mode = val->intval;
+		break;
+	case FIELDBUS_DEV_PROP_IP_ADDR:
+		memcpy(&priv->ip.addr, val->addrval, sizeof(priv->ip.addr));
+		break;
+	case FIELDBUS_DEV_PROP_A1_IN_START:
+		mapio->a1_in.start = cpu_to_be16(val->intval);
+		break;
+	case FIELDBUS_DEV_PROP_A1_IN_SIZE:
+		mapio->a1_in.size = cpu_to_be16(val->intval);
+		break;
+	case FIELDBUS_DEV_PROP_A1_OUT_START:
+		mapio->a1_out.start = cpu_to_be16(val->intval);
+		break;
+	case FIELDBUS_DEV_PROP_A1_OUT_SIZE:
+		mapio->a1_out.size = cpu_to_be16(val->intval);
+		break;
+	case FIELDBUS_DEV_PROP_A2_IN_START:
+		mapio->a2_in.start = cpu_to_be16(val->intval);
+		break;
+	case FIELDBUS_DEV_PROP_A2_IN_SIZE:
+		mapio->a2_in.size = cpu_to_be16(val->intval);
+		break;
+	case FIELDBUS_DEV_PROP_A2_OUT_START:
+		mapio->a2_out.start = cpu_to_be16(val->intval);
+		break;
+	case FIELDBUS_DEV_PROP_A2_OUT_SIZE:
+		mapio->a2_out.size = cpu_to_be16(val->intval);
+		break;
+	case FIELDBUS_DEV_PROP_REV_NUMBER:
+		priv->rev_number = val->intval;
+		break;
+	case FIELDBUS_DEV_PROP_REV_DATE_YEAR:
+		priv->rev_year = val->intval;
+		break;
+	case FIELDBUS_DEV_PROP_REV_DATE_MONTH:
+		priv->rev_month = val->intval;
+		break;
+	case FIELDBUS_DEV_PROP_REV_DATE_DAY:
+		priv->rev_day = val->intval;
+		break;
+	case FIELDBUS_DEV_PROP_ID_TYPE:
+		strcpy(priv->id_type, val->strval);
+		break;
+	case FIELDBUS_DEV_PROP_ID_VENDOR:
+		strcpy(priv->id_vendor, val->strval);
+		break;
+	case FIELDBUS_DEV_PROP_ID_PRODUCT:
+		strcpy(priv->id_product, val->strval);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int flnet_probe(struct anybuss_client *client)
+{
+	struct fl_priv *priv;
+	struct device *dev = &client->dev;
+	int err;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	mutex_init(&priv->enable_lock);
+	priv->offl_mode = FIELDBUS_DEV_OFFL_MODE_CLEAR;
+	priv->rev_year = 2005;
+	priv->rev_month = 7;
+	priv->rev_day = 1;
+	strcpy(priv->id_type, "OTHER");
+	strcpy(priv->id_vendor, "HMS");
+	strcpy(priv->id_product, "ABS-FLN");
+	client->on_area_updated = fl_on_area_updated;
+	client->on_online_changed = fl_on_online_changed;
+	priv->client = client;
+	priv->fbdev.read_area_sz = FL_DPRAM_SIZE;
+	priv->fbdev.write_area_sz = FL_DPRAM_SIZE;
+	priv->fbdev.card_name = "HMS FL-Net (Anybus-S)";
+	priv->fbdev.fieldbus_type = FIELDBUS_DEV_TYPE_FLNET;
+	priv->fbdev.read_area = fl_read_area;
+	priv->fbdev.write_area = fl_write_area;
+	priv->fbdev.fieldbus_id_get = fl_id_get;
+	priv->fbdev.enable_get = fl_enable_get;
+	priv->fbdev.cfgprops = config_props;
+	priv->fbdev.num_cfgprops = ARRAY_SIZE(config_props);
+	priv->fbdev.get_cfgprop = fl_get_cfgprop;
+	priv->fbdev.set_cfgprop = fl_set_cfgprop;
+	priv->fbdev.enable_set = fl_enable;
+	priv->fbdev.parent = dev;
+	err = fieldbus_dev_register(&priv->fbdev);
+	if (err < 0)
+		return err;
+	dev_info(dev, "card detected, registered as %s",
+		 dev_name(priv->fbdev.dev));
+	anybuss_set_drvdata(client, priv);
+
+	return 0;
+}
+
+static int flnet_remove(struct anybuss_client *client)
+{
+	struct fl_priv *priv = anybuss_get_drvdata(client);
+
+	fieldbus_dev_unregister(&priv->fbdev);
+	return 0;
+}
+
+static struct anybuss_client_driver flnet_driver = {
+	.probe = flnet_probe,
+	.remove = flnet_remove,
+	.driver		= {
+		.name   = "hms-flnet",
+		.owner	= THIS_MODULE,
+	},
+	.anybus_id = 0x0086,
+};
+
+static int __init flnet_init(void)
+{
+	return anybuss_client_driver_register(&flnet_driver);
+}
+module_init(flnet_init);
+
+static void __exit flnet_exit(void)
+{
+	return anybuss_client_driver_unregister(&flnet_driver);
+}
+module_exit(flnet_exit);
+
+MODULE_AUTHOR("Sven Van Asbroeck <TheSven73@gmail.com>");
+MODULE_DESCRIPTION("HMS FL-Net Driver (Anybus-S)");
+MODULE_LICENSE("GPL v2");
-- 
2.17.1

