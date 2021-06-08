Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735D639ED57
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhFHEF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:05:59 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:47070 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhFHEF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:05:58 -0400
Received: by mail-lf1-f45.google.com with SMTP id m21so14134681lfg.13;
        Mon, 07 Jun 2021 21:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NgZj1BbnXzcQI0hCaHfsE+MOSxkyGzszbyYkCnu9Th0=;
        b=nXlktMmHRd95mu5YWER2k1hcldsPTe2ffqVG/L36UXe+ruX1EwUejfS5H8V5lpcyF+
         HiNWFv6Rd/VN2gUS1M6DF4rQcmhWZ5SE6c42SgbvGuVmwYgG6rLImhoUlR3aiYyFJynZ
         fY1hCSgpgWzvNhEW79f/AYWLFnWOtsRUE0IWGfK7YUOq7qGF+uK4E+LFRK+j5oUkp5fy
         IrtjzKW4a4Bs4Zm3mv+LWkFTy4x6XrUjqWUgy9GlRguCo47MCfTweso9cfTUOwBxvynH
         klxDU8ppebi+7EfNmovg9fL57NtL7GlKy+hpZROyToqbY92sO1H0ddLryHSWtuFtcR1J
         oQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NgZj1BbnXzcQI0hCaHfsE+MOSxkyGzszbyYkCnu9Th0=;
        b=WmrmQJNY/EaVIDkJmSpe4N0zocgySXLNMDigqPuqNQCytQ1/VsoYUekaX0TGFfg8tH
         hpn+UPKn+WRYBQBz+4VdNkQw7I70NmGD01TWN2VUS23je55+/7yienLDiYh+T4k1DPnO
         AnpSM+0GqF2roF7BEzp6IAo55roHyBPM7m9oT+Q7VGSkLsy3kYOkI+BtfPtlGlHQGewP
         WFC+S9UXG/jMYDEVJsaklfKgEnxVaUA/hSvuEo7cb05Gt1Hf66rRqnexZYrH/1wXchn0
         V1cauwon1hdN69zQclLpIBPt7ac9pj9/h/osJ/OazjdskEIdXRNkXL8sM8Hj9MapQHqI
         lMcA==
X-Gm-Message-State: AOAM5336qEGnHCkESFrOrdyE6JTqr8FSJcpShu3xi0dZ4xWgnetl9qo/
        6NUmzmClDtCMGyFh7jyb+iE=
X-Google-Smtp-Source: ABdhPJwQnluFnuEaRCH3dKtbCOx9lTqD75x17SNW3YD7bJE/SCQBUC1sW7hQDpmE2gpbn1EzGjEXpQ==
X-Received: by 2002:a05:6512:2096:: with SMTP id t22mr14410816lfr.272.1623124970017;
        Mon, 07 Jun 2021 21:02:50 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l23sm1729096lfj.26.2021.06.07.21.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:02:49 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/10] wwan_hwsim: WWAN device simulator
Date:   Tue,  8 Jun 2021 07:02:32 +0300
Message-Id: <20210608040241.10658-2-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver simulates a set of WWAN device with a set of AT control
ports. It can be used to test WWAN kernel framework as well as user
space tools.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/Kconfig      |  10 ++
 drivers/net/wwan/Makefile     |   2 +
 drivers/net/wwan/wwan_hwsim.c | 318 ++++++++++++++++++++++++++++++++++
 3 files changed, 330 insertions(+)
 create mode 100644 drivers/net/wwan/wwan_hwsim.c

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 7ad1920120bc..ec0b194a373c 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -20,6 +20,16 @@ config WWAN_CORE
 	  To compile this driver as a module, choose M here: the module will be
 	  called wwan.
 
+config WWAN_HWSIM
+	tristate "Simulated WWAN device"
+	depends on WWAN_CORE
+	help
+	  This driver is a developer testing tool that can be used to test WWAN
+	  framework.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called wwan_hwsim.  If unsure, say N.
+
 config MHI_WWAN_CTRL
 	tristate "MHI WWAN control driver for QCOM-based PCIe modems"
 	select WWAN_CORE
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
index 556cd90958ca..f33f77ca1021 100644
--- a/drivers/net/wwan/Makefile
+++ b/drivers/net/wwan/Makefile
@@ -6,4 +6,6 @@
 obj-$(CONFIG_WWAN_CORE) += wwan.o
 wwan-objs += wwan_core.o
 
+obj-$(CONFIG_WWAN_HWSIM) += wwan_hwsim.o
+
 obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
new file mode 100644
index 000000000000..96d25d7e5bb8
--- /dev/null
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -0,0 +1,318 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * WWAN device simulator for WWAN framework testing.
+ *
+ * Copyright (c) 2021, Sergey Ryazanov <ryazanov.s.a@gmail.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/skbuff.h>
+#include <linux/wwan.h>
+
+static int wwan_hwsim_devsnum = 2;
+module_param_named(devices, wwan_hwsim_devsnum, int, 0444);
+MODULE_PARM_DESC(devices, "Number of simulated devices");
+
+static struct class *wwan_hwsim_class;
+
+static DEFINE_SPINLOCK(wwan_hwsim_devs_lock);
+static LIST_HEAD(wwan_hwsim_devs);
+static unsigned int wwan_hwsim_dev_idx;
+
+struct wwan_hwsim_dev {
+	struct list_head list;
+	unsigned int id;
+	struct device dev;
+	spinlock_t ports_lock;	/* Serialize ports creation/deletion */
+	unsigned int port_idx;
+	struct list_head ports;
+};
+
+struct wwan_hwsim_port {
+	struct list_head list;
+	unsigned int id;
+	struct wwan_hwsim_dev *dev;
+	struct wwan_port *wwan;
+	enum {			/* AT command parser state */
+		AT_PARSER_WAIT_A,
+		AT_PARSER_WAIT_T,
+		AT_PARSER_WAIT_TERM,
+		AT_PARSER_SKIP_LINE,
+	} pstate;
+};
+
+static int wwan_hwsim_port_start(struct wwan_port *wport)
+{
+	struct wwan_hwsim_port *port = wwan_port_get_drvdata(wport);
+
+	port->pstate = AT_PARSER_WAIT_A;
+
+	return 0;
+}
+
+static void wwan_hwsim_port_stop(struct wwan_port *wport)
+{
+}
+
+/* Implements a minimalistic AT commands parser that echo input back and
+ * reply with 'OK' to each input command. See AT command protocol details in the
+ * ITU-T V.250 recomendations document.
+ *
+ * Be aware that this processor is not fully V.250 compliant.
+ */
+static int wwan_hwsim_port_tx(struct wwan_port *wport, struct sk_buff *in)
+{
+	struct wwan_hwsim_port *port = wwan_port_get_drvdata(wport);
+	struct sk_buff *out;
+	int i, n, s;
+
+	/* Estimate a max possible number of commands by counting the number of
+	 * termination chars (S3 param, CR by default). And then allocate the
+	 * output buffer that will be enough to fit the echo and result codes of
+	 * all commands.
+	 */
+	for (i = 0, n = 0; i < in->len; ++i)
+		if (in->data[i] == '\r')
+			n++;
+	n = in->len + n * (2 + 2 + 2);	/* Output buffer size */
+	out = alloc_skb(n, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	for (i = 0, s = 0; i < in->len; ++i) {
+		char c = in->data[i];
+
+		if (port->pstate == AT_PARSER_WAIT_A) {
+			if (c == 'A' || c == 'a')
+				port->pstate = AT_PARSER_WAIT_T;
+			else if (c != '\n')	/* Ignore formating char */
+				port->pstate = AT_PARSER_SKIP_LINE;
+		} else if (port->pstate == AT_PARSER_WAIT_T) {
+			if (c == 'T' || c == 't')
+				port->pstate = AT_PARSER_WAIT_TERM;
+			else
+				port->pstate = AT_PARSER_SKIP_LINE;
+		} else if (port->pstate == AT_PARSER_WAIT_TERM) {
+			if (c != '\r')
+				continue;
+			/* Consume the trailing formatting char as well */
+			if ((i + 1) < in->len && in->data[i + 1] == '\n')
+				i++;
+			n = i - s + 1;
+			memcpy(skb_put(out, n), &in->data[s], n);/* Echo */
+			memcpy(skb_put(out, 6), "\r\nOK\r\n", 6);
+			s = i + 1;
+			port->pstate = AT_PARSER_WAIT_A;
+		} else if (port->pstate == AT_PARSER_SKIP_LINE) {
+			if (c != '\r')
+				continue;
+			port->pstate = AT_PARSER_WAIT_A;
+		}
+	}
+
+	if (i > s) {
+		/* Echo the processed portion of a not yet completed command */
+		n = i - s;
+		memcpy(skb_put(out, n), &in->data[s], n);
+	}
+
+	consume_skb(in);
+
+	wwan_port_rx(wport, out);
+
+	return 0;
+}
+
+static const struct wwan_port_ops wwan_hwsim_port_ops = {
+	.start = wwan_hwsim_port_start,
+	.stop = wwan_hwsim_port_stop,
+	.tx = wwan_hwsim_port_tx,
+};
+
+static struct wwan_hwsim_port *wwan_hwsim_port_new(struct wwan_hwsim_dev *dev)
+{
+	struct wwan_hwsim_port *port;
+	int err;
+
+	port = kzalloc(sizeof(*port), GFP_KERNEL);
+	if (!port)
+		return ERR_PTR(-ENOMEM);
+
+	port->dev = dev;
+
+	spin_lock(&dev->ports_lock);
+	port->id = dev->port_idx++;
+	spin_unlock(&dev->ports_lock);
+
+	port->wwan = wwan_create_port(&dev->dev, WWAN_PORT_AT,
+				      &wwan_hwsim_port_ops,
+				      port);
+	if (IS_ERR(port->wwan)) {
+		err = PTR_ERR(port->wwan);
+		goto err_free_port;
+	}
+
+	return port;
+
+err_free_port:
+	kfree(port);
+
+	return ERR_PTR(err);
+}
+
+static void wwan_hwsim_port_del(struct wwan_hwsim_port *port)
+{
+	wwan_remove_port(port->wwan);
+	kfree(port);
+}
+
+static void wwan_hwsim_dev_release(struct device *sysdev)
+{
+	struct wwan_hwsim_dev *dev = container_of(sysdev, typeof(*dev), dev);
+
+	kfree(dev);
+}
+
+static struct wwan_hwsim_dev *wwan_hwsim_dev_new(void)
+{
+	struct wwan_hwsim_dev *dev;
+	int err;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock(&wwan_hwsim_devs_lock);
+	dev->id = wwan_hwsim_dev_idx++;
+	spin_unlock(&wwan_hwsim_devs_lock);
+
+	dev->dev.release = wwan_hwsim_dev_release;
+	dev->dev.class = wwan_hwsim_class;
+	dev_set_name(&dev->dev, "hwsim%u", dev->id);
+
+	spin_lock_init(&dev->ports_lock);
+	INIT_LIST_HEAD(&dev->ports);
+
+	err = device_register(&dev->dev);
+	if (err)
+		goto err_free_dev;
+
+	return dev;
+
+err_free_dev:
+	kfree(dev);
+
+	return ERR_PTR(err);
+}
+
+static void wwan_hwsim_dev_del(struct wwan_hwsim_dev *dev)
+{
+	spin_lock(&dev->ports_lock);
+	while (!list_empty(&dev->ports)) {
+		struct wwan_hwsim_port *port;
+
+		port = list_first_entry(&dev->ports, struct wwan_hwsim_port,
+					list);
+		list_del(&port->list);
+		spin_unlock(&dev->ports_lock);
+		wwan_hwsim_port_del(port);
+		spin_lock(&dev->ports_lock);
+	}
+	spin_unlock(&dev->ports_lock);
+
+	device_unregister(&dev->dev);
+	/* Memory will be freed in the device release callback */
+}
+
+static int __init wwan_hwsim_init_devs(void)
+{
+	struct wwan_hwsim_dev *dev;
+	int i, j;
+
+	for (i = 0; i < wwan_hwsim_devsnum; ++i) {
+		dev = wwan_hwsim_dev_new();
+		if (IS_ERR(dev))
+			return PTR_ERR(dev);
+
+		spin_lock(&wwan_hwsim_devs_lock);
+		list_add_tail(&dev->list, &wwan_hwsim_devs);
+		spin_unlock(&wwan_hwsim_devs_lock);
+
+		/* Create a couple of ports per each device to accelerate
+		 * the simulator readiness time.
+		 */
+		for (j = 0; j < 2; ++j) {
+			struct wwan_hwsim_port *port;
+
+			port = wwan_hwsim_port_new(dev);
+			if (IS_ERR(port))
+				return PTR_ERR(port);
+
+			spin_lock(&dev->ports_lock);
+			list_add_tail(&port->list, &dev->ports);
+			spin_unlock(&dev->ports_lock);
+		}
+	}
+
+	return 0;
+}
+
+static void wwan_hwsim_free_devs(void)
+{
+	struct wwan_hwsim_dev *dev;
+
+	spin_lock(&wwan_hwsim_devs_lock);
+	while (!list_empty(&wwan_hwsim_devs)) {
+		dev = list_first_entry(&wwan_hwsim_devs, struct wwan_hwsim_dev,
+				       list);
+		list_del(&dev->list);
+		spin_unlock(&wwan_hwsim_devs_lock);
+		wwan_hwsim_dev_del(dev);
+		spin_lock(&wwan_hwsim_devs_lock);
+	}
+	spin_unlock(&wwan_hwsim_devs_lock);
+}
+
+static int __init wwan_hwsim_init(void)
+{
+	int err;
+
+	if (wwan_hwsim_devsnum < 0 || wwan_hwsim_devsnum > 128)
+		return -EINVAL;
+
+	wwan_hwsim_class = class_create(THIS_MODULE, "wwan_hwsim");
+	if (IS_ERR(wwan_hwsim_class))
+		return PTR_ERR(wwan_hwsim_class);
+
+	err = wwan_hwsim_init_devs();
+	if (err)
+		goto err_clean_devs;
+
+	return 0;
+
+err_clean_devs:
+	wwan_hwsim_free_devs();
+	class_destroy(wwan_hwsim_class);
+
+	return err;
+}
+
+static void __exit wwan_hwsim_exit(void)
+{
+	wwan_hwsim_free_devs();
+	class_destroy(wwan_hwsim_class);
+}
+
+module_init(wwan_hwsim_init);
+module_exit(wwan_hwsim_exit);
+
+MODULE_AUTHOR("Sergey Ryazanov");
+MODULE_DESCRIPTION("Device simulator for WWAN framework");
+MODULE_LICENSE("GPL");
-- 
2.26.3

