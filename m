Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9143A802E
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhFONgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:36:43 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:32051 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhFONgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:36:19 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623764034; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=LKQbTHNqzpOtsllBPwaFXZ4L+d/LADSN0/o/WAyhIquL90C2iuF/iWSB/ITJClmZ4Z
    XZ7C7CPluhGjqiX5mijQkMvvwFK9+asw/+G6AviTtM9Y0CBQxrcPjwt8jEIyIUf5QLyf
    yTPevGqKW7wt0NxUKi6FLxMB+/LHXEeAZZoyXigvfvjC1ALXqXNewcNH0o4IRVr1Btt9
    yv41Snp7SjUQr++j2mPXRv7lOp6hDp+EkNLQZUHZcSzV+NDb0OZELWlVJD8RRnUO6CUk
    7B4J8F7U9LK6E/q5mXV5b7TL7JrommN5wcrYYozkP8mFANsqwpQICB+LDUg7/jxwhfQv
    AZbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623764034;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=NqICQXwnZAhPsgoVzAPzRmT3Y44ZEBOSxoWfs0ionFg=;
    b=UywDFfdZHMLgmnt7g9GqA+7zVRHdTPzOU0rJ+og+e4R3/qlaO96QS2fQ2BafJlUYj7
    C5Vyq129geyD2391jjjnsANICOY9Wm2JFD82M337m7raPHvmsXdwAirLXWRinuRYqpfM
    r4HcU+zvWYDiAoIWpweQZlZ3Rx9YjNr+vx+XPmKv6cBVvdMslMVnR7EpAIOmKOcGmVbp
    fN0honVAdARJ8pxw+SMri/fgvXNv0myvmnUMwLr/iNV2hnrd0YZD0LP+YKDzEW7xfipX
    hH+E8W3nIgfOxihEF69KEvPPQ811/mcrCAnBc5enYWwt8R2yZK5QPDYXt5/xoPA14jX1
    9BXw==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623764034;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=NqICQXwnZAhPsgoVzAPzRmT3Y44ZEBOSxoWfs0ionFg=;
    b=qYEDAniwkYby8NBZtKxJyJGh7kz/C6HpLRlnb9Y/SbHKUv+z+s3BuA64RIkuSNG8Xi
    xVTqC8kWKL3WqYOnxcLW0p2Bk0zVXLhA8WQ0/ovEFsiZTaLgbOrVyhL7EiptsmuyMFLI
    pEbOFP6SAdabhdL7UR0Vn0/X/Awgj2g/9uYozhiT9YF2orAaGvQIFPgMY1pqTvlyIaNy
    37eFoHyWptCY/Le1sD4mcy6IsaO/n1K45hoknw/CEbVW2NOdxb5GG+VsJtHcbXKuRjYZ
    IDxiULG6vttU/eq3z/tmn2GhwzeLw2kqd5EbjyfDxLP5iIauFW0dctg/lrsyYN0F6j8L
    omIA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxA6m6NutzT"
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id y01375x5FDXrOso
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 15 Jun 2021 15:33:53 +0200 (CEST)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, phone-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next 2/3] net: wwan: Add RPMSG WWAN CTRL driver
Date:   Tue, 15 Jun 2021 15:32:28 +0200
Message-Id: <20210615133229.213064-3-stephan@gerhold.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210615133229.213064-1-stephan@gerhold.net>
References: <20210615133229.213064-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The remote processor messaging (rpmsg) subsystem provides an interface
to communicate with other remote processors. On many Qualcomm SoCs this
is used to communicate with an integrated modem DSP that implements most
of the modem functionality and provides high-level protocols like
QMI or AT to allow controlling the modem.

For QMI, most older Qualcomm SoCs (e.g. MSM8916/MSM8974) have
a standalone "DATA5_CNTL" channel that allows exchanging QMI messages.
Note that newer SoCs (e.g. SDM845) only allow exchanging QMI messages
via a shared QRTR channel that is available via a socket API on Linux.

For AT, the "DATA4" channel accepts at least a limited set of AT
commands, on many older and newer Qualcomm SoCs, although QMI is
typically the preferred control protocol.

Note that the data path (network interface) is entirely separate
from the control path and varies between Qualcomm SoCs, e.g. "IPA"
on newer Qualcomm SoCs or "BAM-DMUX" on some older ones.

The RPMSG WWAN CTRL driver exposes the QMI/AT control ports via the
WWAN subsystem, and therefore allows userspace like ModemManager to
set up the modem. Until now, ModemManager had to use the RPMSG-specific
rpmsg-char where the channels must be explicitly exposed as a char
device first and don't show up directly in sysfs.

The driver is a fairly simple glue layer between WWAN and RPMSG
and is mostly based on the existing mhi_wwan_ctrl.c and rpmsg_char.c.

Cc: Loic Poulain <loic.poulain@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
I have mainly tested this driver on Qualcomm MSM8916 with the qcom_smd
RPMSG provider, together with both ModemManager and oFono in userspace.

Note that this driver can also work somewhat with the "glink" RPMSG provider
on newer SoCs (mainly for AT ports), but for some reason dynamically opening
and closing channels like this driver and rpmsg-char do is horribly broken
there. I'm hoping someone with more experience and hardware can fix that later.
---
 MAINTAINERS                        |   7 ++
 drivers/net/wwan/Kconfig           |  18 ++++
 drivers/net/wwan/Makefile          |   1 +
 drivers/net/wwan/rpmsg_wwan_ctrl.c | 143 +++++++++++++++++++++++++++++
 4 files changed, 169 insertions(+)
 create mode 100644 drivers/net/wwan/rpmsg_wwan_ctrl.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 183cc61e2dc0..fbf792962d7b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15587,6 +15587,13 @@ F:	include/linux/rpmsg/
 F:	include/uapi/linux/rpmsg.h
 F:	samples/rpmsg/
 
+REMOTE PROCESSOR MESSAGING (RPMSG) WWAN CONTROL DRIVER
+M:	Stephan Gerhold <stephan@gerhold.net>
+L:	netdev@vger.kernel.org
+L:	linux-remoteproc@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wwan/rpmsg_wwan_ctrl.c
+
 RENESAS CLOCK DRIVERS
 M:	Geert Uytterhoeven <geert+renesas@glider.be>
 L:	linux-renesas-soc@vger.kernel.org
diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 249b3f1ed62b..de9384326bc8 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -38,6 +38,24 @@ config MHI_WWAN_CTRL
 	  To compile this driver as a module, choose M here: the module will be
 	  called mhi_wwan_ctrl.
 
+config RPMSG_WWAN_CTRL
+	tristate "RPMSG WWAN control driver"
+	depends on RPMSG
+	help
+	  RPMSG WWAN CTRL allows modems available via RPMSG channels to expose
+	  different modem protocols/ports to userspace, including AT and QMI.
+	  These protocols can be accessed directly from userspace
+	  (e.g. AT commands) or via libraries/tools (e.g. libqmi, libqcdm...).
+
+	  This is mainly used for modems integrated into many Qualcomm SoCs,
+	  e.g. for AT and QMI on Qualcomm MSM8916 or MSM8974. Note that many
+	  newer Qualcomm SoCs (e.g. SDM845) still provide an AT port through
+	  this driver but the QMI messages can only be sent through
+	  QRTR network sockets (CONFIG_QRTR).
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called rpmsg_wwan_ctrl.
+
 config IOSM
 	tristate "IOSM Driver for Intel M.2 WWAN Device"
 	depends on INTEL_IOMMU
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
index 83dd3482ffc3..d90ac33abaef 100644
--- a/drivers/net/wwan/Makefile
+++ b/drivers/net/wwan/Makefile
@@ -9,4 +9,5 @@ wwan-objs += wwan_core.o
 obj-$(CONFIG_WWAN_HWSIM) += wwan_hwsim.o
 
 obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
+obj-$(CONFIG_RPMSG_WWAN_CTRL) += rpmsg_wwan_ctrl.o
 obj-$(CONFIG_IOSM) += iosm/
diff --git a/drivers/net/wwan/rpmsg_wwan_ctrl.c b/drivers/net/wwan/rpmsg_wwan_ctrl.c
new file mode 100644
index 000000000000..de226cdb69fd
--- /dev/null
+++ b/drivers/net/wwan/rpmsg_wwan_ctrl.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021, Stephan Gerhold <stephan@gerhold.net> */
+#include <linux/kernel.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/rpmsg.h>
+#include <linux/wwan.h>
+
+struct rpmsg_wwan_dev {
+	/* Lower level is a rpmsg dev, upper level is a wwan port */
+	struct rpmsg_device *rpdev;
+	struct wwan_port *wwan_port;
+	struct rpmsg_endpoint *ept;
+};
+
+static int rpmsg_wwan_ctrl_callback(struct rpmsg_device *rpdev,
+				    void *buf, int len, void *priv, u32 src)
+{
+	struct rpmsg_wwan_dev *rpwwan = priv;
+	struct sk_buff *skb;
+
+	skb = alloc_skb(len, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_put_data(skb, buf, len);
+	wwan_port_rx(rpwwan->wwan_port, skb);
+	return 0;
+}
+
+static int rpmsg_wwan_ctrl_start(struct wwan_port *port)
+{
+	struct rpmsg_wwan_dev *rpwwan = wwan_port_get_drvdata(port);
+	struct rpmsg_channel_info chinfo = {
+		.src = rpwwan->rpdev->src,
+		.dst = RPMSG_ADDR_ANY,
+	};
+
+	strncpy(chinfo.name, rpwwan->rpdev->id.name, RPMSG_NAME_SIZE);
+	rpwwan->ept = rpmsg_create_ept(rpwwan->rpdev, rpmsg_wwan_ctrl_callback,
+				       rpwwan, chinfo);
+	if (!rpwwan->ept)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static void rpmsg_wwan_ctrl_stop(struct wwan_port *port)
+{
+	struct rpmsg_wwan_dev *rpwwan = wwan_port_get_drvdata(port);
+
+	rpmsg_destroy_ept(rpwwan->ept);
+	rpwwan->ept = NULL;
+}
+
+static int rpmsg_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
+{
+	struct rpmsg_wwan_dev *rpwwan = wwan_port_get_drvdata(port);
+	int ret;
+
+	ret = rpmsg_trysend(rpwwan->ept, skb->data, skb->len);
+	if (ret)
+		return ret;
+
+	consume_skb(skb);
+	return 0;
+}
+
+static const struct wwan_port_ops rpmsg_wwan_pops = {
+	.start = rpmsg_wwan_ctrl_start,
+	.stop = rpmsg_wwan_ctrl_stop,
+	.tx = rpmsg_wwan_ctrl_tx,
+};
+
+static struct device *rpmsg_wwan_find_parent(struct device *dev)
+{
+	/* Select first platform device as parent for the WWAN ports.
+	 * On Qualcomm platforms this is usually the platform device that
+	 * represents the modem remote processor. This might need to be
+	 * adjusted when adding device IDs for other platforms.
+	 */
+	for (dev = dev->parent; dev; dev = dev->parent) {
+		if (dev_is_platform(dev))
+			return dev;
+	}
+	return NULL;
+}
+
+static int rpmsg_wwan_ctrl_probe(struct rpmsg_device *rpdev)
+{
+	struct rpmsg_wwan_dev *rpwwan;
+	struct wwan_port *port;
+	struct device *parent;
+
+	parent = rpmsg_wwan_find_parent(&rpdev->dev);
+	if (!parent)
+		return -ENODEV;
+
+	rpwwan = devm_kzalloc(&rpdev->dev, sizeof(*rpwwan), GFP_KERNEL);
+	if (!rpwwan)
+		return -ENOMEM;
+
+	rpwwan->rpdev = rpdev;
+	dev_set_drvdata(&rpdev->dev, rpwwan);
+
+	/* Register as a wwan port, id.driver_data contains wwan port type */
+	port = wwan_create_port(parent, rpdev->id.driver_data,
+				&rpmsg_wwan_pops, rpwwan);
+	if (IS_ERR(port))
+		return PTR_ERR(port);
+
+	rpwwan->wwan_port = port;
+
+	return 0;
+};
+
+static void rpmsg_wwan_ctrl_remove(struct rpmsg_device *rpdev)
+{
+	struct rpmsg_wwan_dev *rpwwan = dev_get_drvdata(&rpdev->dev);
+
+	wwan_remove_port(rpwwan->wwan_port);
+}
+
+static const struct rpmsg_device_id rpmsg_wwan_ctrl_id_table[] = {
+	/* RPMSG channels for Qualcomm SoCs with integrated modem */
+	{ .name = "DATA5_CNTL", .driver_data = WWAN_PORT_QMI },
+	{ .name = "DATA4", .driver_data = WWAN_PORT_AT },
+	{},
+};
+MODULE_DEVICE_TABLE(rpmsg, rpmsg_wwan_ctrl_id_table);
+
+static struct rpmsg_driver rpmsg_wwan_ctrl_driver = {
+	.drv.name = "rpmsg_wwan_ctrl",
+	.id_table = rpmsg_wwan_ctrl_id_table,
+	.probe = rpmsg_wwan_ctrl_probe,
+	.remove = rpmsg_wwan_ctrl_remove,
+};
+module_rpmsg_driver(rpmsg_wwan_ctrl_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("RPMSG WWAN CTRL Driver");
+MODULE_AUTHOR("Stephan Gerhold <stephan@gerhold.net>");
-- 
2.32.0

