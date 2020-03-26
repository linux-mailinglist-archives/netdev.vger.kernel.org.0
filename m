Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE5D8193F94
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgCZNRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:17:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56138 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgCZNRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 09:17:34 -0400
Received: by mail-wm1-f66.google.com with SMTP id z5so6415537wml.5
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 06:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BdrYZvQI/ASAnKPUEJMnCoQMXGSfuU9nqb8y3S28K6c=;
        b=gG+d7t5sr2eNgzPSJeOfExEHfGnkvXwLnO9IW+1JDcPlSFyB7NqAbiP4N0DIkQ+KdB
         91kgHgz5p5/Js3dhmyUDmsme94aiQu/QHK+yMGqx01UJIVcIaeUYRyFQi81CWnH7REIV
         pDcoE+Bcf/QLBjyswTSXweBj1Uhshjpx+Ub0RG5vj3oxUlG4fvTycsTZ7nhYs/oJOooF
         oRyPyEAH3cO/N49hmTml3rCEqP50XD1HUxa2S6CF06uYEsUP4YP9FFzPYPvydRpcB/kB
         F0fS6gx/hom/Ymi2odQY1z0xX/FXG1RHxpW1F6RDPcMVkl3uyBhlQQMsGu1m1upsU3Kr
         wN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BdrYZvQI/ASAnKPUEJMnCoQMXGSfuU9nqb8y3S28K6c=;
        b=seiH7/7A6cv4Dsg6EJT8SkRRjuBrWNE/i9+9dmyh/xvItDTgTeHGZsQPv8sjbOnZX/
         9shuX/5Ph1xhC3WzIYKD3d9lmk87fdnK/MYZ7IENpqVmcoTOxtvDTHdrn4C9Gzwn/OoB
         Mky1D63yE3CdPgD2CFpgbtIw+BDYDkGHfXyHXe49wh8kH1t2BPxphgBgzT7QNCiFMgPh
         aFXSa41iNAfjEY9/Np3ng0HPCKRi9jzlna6NFAUzykiWr1oH4LSymouLpgbolbm7zDe5
         iLEX3VFoh2UOgZgOJ/usljf40DQGRhShEqtYZn7CTisrU3IE/jCkdSWTFIhfuSEMfvUn
         +0jw==
X-Gm-Message-State: ANhLgQ2QbyYBRVDdN1VZ9ptgjcv/Ju+jtQ4fFv3yg0Ld9FkyjgHUe1RU
        593fDPT4iZypOZYNu3mRGyigng==
X-Google-Smtp-Source: ADFU+vtEhKH3SSY+ucUnKqjoBAVavjYCU68RkmQkPkZcA1BG71/Y42pIKHt7YnlHZ/HOsMUy0SmrYg==
X-Received: by 2002:a05:600c:2f90:: with SMTP id t16mr549558wmn.66.1585228650680;
        Thu, 26 Mar 2020 06:17:30 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id b187sm3522112wmb.42.2020.03.26.06.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 06:17:29 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH] net: core: provide devm_register_netdev()
Date:   Thu, 26 Mar 2020 14:17:21 +0100
Message-Id: <20200326131721.6404-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Create a new source file for networking devres helpers and provide
devm_register_netdev() - a managed variant of register_netdev().

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
I'm writing a new ethernet driver and I realized there's no devres
variant for register_netdev(). Since this is the only function I need
to get rid of the remove() callback, I thought I'll just go ahead and
add it and send it even before the driver to make it available to other
drivers.

 .../driver-api/driver-model/devres.rst        |  3 ++
 include/linux/netdevice.h                     |  1 +
 net/core/Makefile                             |  2 +-
 net/core/devres.c                             | 41 +++++++++++++++++++
 4 files changed, 46 insertions(+), 1 deletion(-)
 create mode 100644 net/core/devres.c

diff --git a/Documentation/driver-api/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
index 46c13780994c..11a03b65196e 100644
--- a/Documentation/driver-api/driver-model/devres.rst
+++ b/Documentation/driver-api/driver-model/devres.rst
@@ -372,6 +372,9 @@ MUX
   devm_mux_chip_register()
   devm_mux_control_get()
 
+NET
+  devm_register_netdev()
+
 PER-CPU MEM
   devm_alloc_percpu()
   devm_free_percpu()
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6c3f7032e8d9..710a7bcfc3dc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4196,6 +4196,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 			 count)
 
 int register_netdev(struct net_device *dev);
+int devm_register_netdev(struct device *dev, struct net_device *ndev);
 void unregister_netdev(struct net_device *dev);
 
 /* General hardware address lists handling functions */
diff --git a/net/core/Makefile b/net/core/Makefile
index 3e2c378e5f31..f530894068d2 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -8,7 +8,7 @@ obj-y := sock.o request_sock.o skbuff.o datagram.o stream.o scm.o \
 
 obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
 
-obj-y		     += dev.o dev_addr_lists.o dst.o netevent.o \
+obj-y		     += dev.o devres.o dev_addr_lists.o dst.o netevent.o \
 			neighbour.o rtnetlink.o utils.o link_watch.o filter.o \
 			sock_diag.o dev_ioctl.o tso.o sock_reuseport.o \
 			fib_notifier.o xdp.o flow_offload.o
diff --git a/net/core/devres.c b/net/core/devres.c
new file mode 100644
index 000000000000..3c080abd1935
--- /dev/null
+++ b/net/core/devres.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 BayLibre SAS
+ * Author: Bartosz Golaszewski <bgolaszewski@baylibre.com>
+ */
+
+#include <linux/device.h>
+#include <linux/netdevice.h>
+
+struct netdevice_devres {
+	struct net_device *ndev;
+};
+
+static void devm_netdev_release(struct device *dev, void *res)
+{
+	struct netdevice_devres *this = res;
+
+	unregister_netdev(this->ndev);
+}
+
+int devm_register_netdev(struct device *dev, struct net_device *ndev)
+{
+	struct netdevice_devres *devres;
+	int ret;
+
+	devres = devres_alloc(devm_netdev_release, sizeof(*devres), GFP_KERNEL);
+	if (!devres)
+		return -ENOMEM;
+
+	ret = register_netdev(ndev);
+	if (ret) {
+		devres_free(devres);
+		return ret;
+	}
+
+	devres->ndev = ndev;
+	devres_add(dev, devres);
+
+	return 0;
+}
+EXPORT_SYMBOL(devm_register_netdev);
-- 
2.25.0

