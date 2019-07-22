Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECE270BAB
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732852AbfGVVkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:40:55 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46455 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732826AbfGVVkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:40:49 -0400
Received: by mail-pg1-f196.google.com with SMTP id i8so18263376pgm.13
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=9AXfLJ/l7/Ljtbbyk3JNOQihMM6pJKvAj22BwT+oiTI=;
        b=2tR5ZGb/FCkKYbzXwtsgVdvVkjFeMmlOxKIro3PAThGyPaYiykXktgjmThbblpwYu4
         UY0560T/rT7a2B1UE1vFFvTOcF2SO98hZLztOKjS1wnF8fJofRxSL597ifv8S9WdMpN6
         kRpEiO+rihT+SvKKNtbSjjveFKY3K1OrR4Cu8fXjUpiequ65vlPMI4nhQgMVAzYNMaOP
         EIlCAfR3/YT0HIqrIjEGlmfx2scNPOtxg4BIvRxTikUj/vAUHunnNG8IwVydQWThMt6d
         K+jpP8w7jsUXlKNBwhGL0EHfwMBnVFpg7BHho2daKGAQVnMUq/YSMyxpZWpEflUJT36v
         nK+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=9AXfLJ/l7/Ljtbbyk3JNOQihMM6pJKvAj22BwT+oiTI=;
        b=sPtWOnsoaJNWq97PT7SUjI2oAdGgYHociEZOvthqD1jJSkFDlgzbBtClKynepjHxG9
         H2EENBfNrIvFd9nJ3dsV/V7LNVg//bp/Da2MslrzqCPoIJaKUl/pFMZBGoqEUITAHf4G
         QaaOHVycHCWS45lgJkddBkd/RFYVyVyVRL3C+kEJMv1ZlIlr7wxn4CUALUBVrzdxbeuz
         evsMxxjd3OM7VuePlpj2DQ9jYzVeisHHBNnh+yKI2YNAVBCrWsGKeHBvfmY3FDJadDfO
         ksWVi0JMCbDhKShDuI+mDjn1b3sd3PtgriWw9T3KLyhiW7S4ah+VbNwqImDmbnL+vHcL
         KjuA==
X-Gm-Message-State: APjAAAVDRK9hZYs9+UK+06UL7whAyB4Pb95vDfoXzkwsKjcrmRMR4x03
        c7cq8CtFI1pjIhcLqIloWvLU+g==
X-Google-Smtp-Source: APXvYqzgduTjcs9uAOsfVcL3eVvADD231uo4lEAek1p4VoN1u0Dx7Q0PNapUfYZ3sWFL6fPhWQqjng==
X-Received: by 2002:a62:14c4:: with SMTP id 187mr2226767pfu.241.1563831648910;
        Mon, 22 Jul 2019 14:40:48 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p65sm40593714pfp.58.2019.07.22.14.40.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:40:48 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v4 net-next 19/19] ionic: Add basic devlink interface
Date:   Mon, 22 Jul 2019 14:40:23 -0700
Message-Id: <20190722214023.9513-20-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722214023.9513-1-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a devlink interface for access to information that isn't
normally available through ethtool or the iplink interface.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |  2 +-
 drivers/net/ethernet/pensando/ionic/ionic.h   |  3 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 12 ++-
 .../ethernet/pensando/ionic/ionic_devlink.c   | 93 +++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_devlink.h   | 14 +++
 5 files changed, 120 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.h

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 4f3cfbf36c23..ce187c7b33a8 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -5,4 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
 
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o ionic_ethtool.o \
 	   ionic_lif.o ionic_rx_filter.o ionic_txrx.o ionic_debugfs.o \
-	   ionic_stats.o
+	   ionic_stats.o ionic_devlink.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index cd08166f73a9..728dfb42a52a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -8,6 +8,7 @@ struct lif;
 
 #include "ionic_if.h"
 #include "ionic_dev.h"
+#include "ionic_devlink.h"
 
 #define DRV_NAME		"ionic"
 #define DRV_DESCRIPTION		"Pensando Ethernet NIC Driver"
@@ -44,6 +45,8 @@ struct ionic {
 	DECLARE_BITMAP(intrs, INTR_CTRL_REGS_MAX);
 	struct work_struct nb_work;
 	struct notifier_block nb;
+	struct devlink *dl;
+	struct devlink_port dl_port;
 };
 
 struct ionic_admin_ctx {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 98c12b770c7f..dfc0df2c8c8f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -10,6 +10,7 @@
 #include "ionic_bus.h"
 #include "ionic_lif.h"
 #include "ionic_debugfs.h"
+#include "ionic_devlink.h"
 
 /* Supported devices */
 static const struct pci_device_id ionic_id_table[] = {
@@ -110,7 +111,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ionic *ionic;
 	int err;
 
-	ionic = devm_kzalloc(dev, sizeof(*ionic), GFP_KERNEL);
+	ionic = ionic_devlink_alloc(dev);
 	if (!ionic)
 		return -ENOMEM;
 
@@ -212,6 +213,10 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_deinit_lifs;
 	}
 
+	err = ionic_devlink_register(ionic);
+	if (err)
+		dev_err(dev, "Cannot register devlink: %d\n", err);
+
 	return 0;
 
 err_out_deinit_lifs:
@@ -237,6 +242,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ionic_debugfs_del_dev(ionic);
 err_out_clear_drvdata:
 	mutex_destroy(&ionic->dev_cmd_lock);
+	ionic_devlink_free(ionic);
 	pci_set_drvdata(pdev, NULL);
 
 	return err;
@@ -247,6 +253,7 @@ static void ionic_remove(struct pci_dev *pdev)
 	struct ionic *ionic = pci_get_drvdata(pdev);
 
 	if (ionic) {
+		ionic_devlink_unregister(ionic);
 		ionic_lifs_unregister(ionic);
 		ionic_lifs_deinit(ionic);
 		ionic_lifs_free(ionic);
@@ -261,8 +268,7 @@ static void ionic_remove(struct pci_dev *pdev)
 		pci_disable_device(pdev);
 		ionic_debugfs_del_dev(ionic);
 		mutex_destroy(&ionic->dev_cmd_lock);
-
-		devm_kfree(&pdev->dev, ionic);
+		ionic_devlink_free(ionic);
 	}
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
new file mode 100644
index 000000000000..a30a61e51c71
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+
+#include "ionic.h"
+#include "ionic_bus.h"
+#include "ionic_lif.h"
+#include "ionic_devlink.h"
+
+static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
+			     struct netlink_ext_ack *extack)
+{
+	struct ionic *ionic = devlink_priv(dl);
+	struct ionic_dev *idev = &ionic->idev;
+	char buf[16];
+
+	devlink_info_driver_name_put(req, DRV_NAME);
+
+	devlink_info_version_running_put(req,
+					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
+					 idev->dev_info.fw_version);
+
+	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_type);
+	devlink_info_version_fixed_put(req,
+				       DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
+				       buf);
+
+	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_rev);
+	devlink_info_version_fixed_put(req,
+				       DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
+				       buf);
+
+	devlink_info_serial_number_put(req, idev->dev_info.serial_num);
+
+	return 0;
+}
+
+static const struct devlink_ops ionic_dl_ops = {
+	.info_get	= ionic_dl_info_get,
+};
+
+struct ionic *ionic_devlink_alloc(struct device *dev)
+{
+	struct devlink *dl;
+	struct ionic *ionic;
+
+	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic));
+	if (!dl) {
+		dev_warn(dev, "devlink_alloc failed");
+		return NULL;
+	}
+
+	ionic = devlink_priv(dl);
+	ionic->dl = dl;
+
+	return ionic;
+}
+
+void ionic_devlink_free(struct ionic *ionic)
+{
+	devlink_free(ionic->dl);
+}
+
+int ionic_devlink_register(struct ionic *ionic)
+{
+	int err;
+
+	err = devlink_register(ionic->dl, ionic->dev);
+	if (err)
+		dev_warn(ionic->dev, "devlink_register failed: %d\n", err);
+
+	devlink_port_attrs_set(&ionic->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
+			       0, false, 0, NULL, 0);
+	err = devlink_port_register(ionic->dl, &ionic->dl_port, 0);
+	if (err)
+		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
+	else
+		devlink_port_type_eth_set(&ionic->dl_port,
+					  ionic->master_lif->netdev);
+
+	return err;
+}
+
+void ionic_devlink_unregister(struct ionic *ionic)
+{
+	if (!ionic || !ionic->dl)
+		return;
+
+	devlink_port_unregister(&ionic->dl_port);
+	devlink_unregister(ionic->dl);
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
new file mode 100644
index 000000000000..0690172fc57a
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_DEVLINK_H_
+#define _IONIC_DEVLINK_H_
+
+#include <net/devlink.h>
+
+struct ionic *ionic_devlink_alloc(struct device *dev);
+void ionic_devlink_free(struct ionic *ionic);
+int ionic_devlink_register(struct ionic *ionic);
+void ionic_devlink_unregister(struct ionic *ionic);
+
+#endif /* _IONIC_DEVLINK_H_ */
-- 
2.17.1

