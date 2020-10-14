Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D5328DF43
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 12:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388142AbgJNKno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 06:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbgJNKna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 06:43:30 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A82C061755;
        Wed, 14 Oct 2020 03:43:30 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b26so1740344pff.3;
        Wed, 14 Oct 2020 03:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sPAYGcIoiwYGJtU1u+u/cPd9A4Ba8+dXydBae25ev0M=;
        b=Vr7ZPI9YDOaMDvNppRp5i5LarVyaFLKi785fo9bBVy5alFe/2YaoOjVMclZzewTQGj
         6pQsZJRAoMsEyf38B0sGUKF1hZF/tndmmPnHNvig6aajC9FC3myfxM+i5uiyZUPDuyl0
         3gLfTPzPImQ9hIhFVIJXIHWKIqPjXGSNBizFyzmwsCjWmoIK9aQyMY35eJcET5BNHp9n
         BA2+9Xt8tSg4DXAvAlLtvVHFSQeBiDLQv2RuCHQcOdZaavGHwqAthDD3LHztbzjh0RDo
         xMN9jZXtTMuu8Fj4KTaGufGsceepIvWE7BbWKnoDltqB6dqyw3pRt0761YFeD6nF78BY
         5Jzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sPAYGcIoiwYGJtU1u+u/cPd9A4Ba8+dXydBae25ev0M=;
        b=NBCh540g+idjU4xhFqD6NtnrbSOR2wtJvhEMHbYqzJiLolTjJ849ty0cLrAIMIq9iC
         /k9mnMxaj9KuCDee42jjmSrCgqYYjhjDKrV6SExOiHx1RYrDZuMrun/TI638RHlx/eqS
         TosL7u2h/LYcOwo6VWygvdk+yHgPI22jcBMVxXwl8Rj4an8oCOi3LYlO+1P4AeM9TJ43
         XeMBr9Uw2MrfIHLY37Q6mg9jpzU1D3YNcF0kCENCUeLwXnx2l6aGICmhZCMjrru3yvvW
         fQCTPhyLzRoLNdPcqBNWktd84RH0KL1/68e7Kn02o159a2AmCk3/uwoTnI7JNzSFb8o0
         NCnQ==
X-Gm-Message-State: AOAM533jWnUQTd9/yKCB4gv59VmMYj5Oju+pTtEQlS526btORWyCvxLL
        ut5i1iEqUwWnotIM+l1C9Og=
X-Google-Smtp-Source: ABdhPJxhOhTKZ4kZCrWNXf5Y0cQjs9I1sEpQ33Pw16BU4nanB0rQd7DEdCkV7WuFuU94+jJt9GqaYg==
X-Received: by 2002:aa7:9048:0:b029:152:883a:9a94 with SMTP id n8-20020aa790480000b0290152883a9a94mr3674740pfo.24.1602672209676;
        Wed, 14 Oct 2020 03:43:29 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id 3sm2800296pfg.125.2020.10.14.03.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 03:43:29 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER)
Subject: [PATCH v2 2/7] staging: qlge: Initialize devlink health dump framework
Date:   Wed, 14 Oct 2020 18:43:01 +0800
Message-Id: <20201014104306.63756-3-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201014104306.63756-1-coiby.xu@gmail.com>
References: <20201014104306.63756-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize devlink health dump framework for the qlge driver so the
coredump could be done via devlink.

struct qlge_adapter is now used as the private data struct of
struct devlink so it could exist independently of struct net_device
and devlink reload could be supported in the future.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/Kconfig        |  1 +
 drivers/staging/qlge/Makefile       |  2 +-
 drivers/staging/qlge/qlge.h         |  5 +++
 drivers/staging/qlge/qlge_devlink.c | 31 +++++++++++++++++++
 drivers/staging/qlge/qlge_devlink.h |  9 ++++++
 drivers/staging/qlge/qlge_main.c    | 48 +++++++++++++++++++++--------
 6 files changed, 82 insertions(+), 14 deletions(-)
 create mode 100644 drivers/staging/qlge/qlge_devlink.c
 create mode 100644 drivers/staging/qlge/qlge_devlink.h

diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
index a3cb25a3ab80..6d831ed67965 100644
--- a/drivers/staging/qlge/Kconfig
+++ b/drivers/staging/qlge/Kconfig
@@ -3,6 +3,7 @@
 config QLGE
 	tristate "QLogic QLGE 10Gb Ethernet Driver Support"
 	depends on ETHERNET && PCI
+	select NET_DEVLINK
 	help
 	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
 
diff --git a/drivers/staging/qlge/Makefile b/drivers/staging/qlge/Makefile
index 1dc2568e820c..07c1898a512e 100644
--- a/drivers/staging/qlge/Makefile
+++ b/drivers/staging/qlge/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_QLGE) += qlge.o
 
-qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o
+qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o qlge_devlink.o
diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 6ee83e7efd7c..4a48bcc88fbd 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2060,6 +2060,10 @@ struct nic_operations {
 	int (*port_initialize)(struct qlge_adapter *qdev);
 };
 
+struct qlge_netdev_priv {
+	struct ql_adapter *qdev;
+};
+
 /*
  * The main Adapter structure definition.
  * This structure has all fields relevant to the hardware.
@@ -2077,6 +2081,7 @@ struct qlge_adapter {
 	struct pci_dev *pdev;
 	struct net_device *ndev;	/* Parent NET device */
 
+	struct devlink_health_reporter *reporter;
 	/* Hardware information */
 	u32 chip_rev_id;
 	u32 fw_rev_id;
diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
new file mode 100644
index 000000000000..d9c71f45211f
--- /dev/null
+++ b/drivers/staging/qlge/qlge_devlink.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "qlge.h"
+#include "qlge_devlink.h"
+
+static int
+qlge_reporter_coredump(struct devlink_health_reporter *reporter,
+		       struct devlink_fmsg *fmsg, void *priv_ctx,
+		       struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+static const struct devlink_health_reporter_ops qlge_reporter_ops = {
+	.name = "dummy",
+	.dump = qlge_reporter_coredump,
+};
+
+void qlge_health_create_reporters(struct qlge_adapter *priv)
+{
+	struct devlink_health_reporter *reporter;
+	struct devlink *devlink;
+
+	devlink = priv_to_devlink(priv);
+	priv->reporter =
+		devlink_health_reporter_create(devlink, &qlge_reporter_ops,
+					       0, priv);
+	if (IS_ERR(priv->reporter))
+		netdev_warn(priv->ndev,
+			    "Failed to create reporter, err = %ld\n",
+			    PTR_ERR(reporter));
+}
diff --git a/drivers/staging/qlge/qlge_devlink.h b/drivers/staging/qlge/qlge_devlink.h
new file mode 100644
index 000000000000..19078e1ac694
--- /dev/null
+++ b/drivers/staging/qlge/qlge_devlink.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef QLGE_DEVLINK_H
+#define QLGE_DEVLINK_H
+
+#include <net/devlink.h>
+
+void qlge_health_create_reporters(struct qlge_adapter *priv);
+
+#endif /* QLGE_DEVLINK_H */
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 19e72279b0ce..7a4bae3c12d0 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -42,6 +42,7 @@
 #include <net/ip6_checksum.h>
 
 #include "qlge.h"
+#include "qlge_devlink.h"
 
 char qlge_driver_name[] = DRV_NAME;
 const char qlge_driver_version[] = DRV_VERSION;
@@ -4382,10 +4383,10 @@ static void qlge_release_all(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 }
 
-static int qlge_init_device(struct pci_dev *pdev, struct net_device *ndev,
+static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 			    int cards_found)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct net_device *ndev = qdev->ndev;
 	int err = 0;
 
 	memset((void *)qdev, 0, sizeof(*qdev));
@@ -4548,27 +4549,34 @@ static void qlge_timer(struct timer_list *t)
 	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 }
 
+static const struct devlink_ops qlge_devlink_ops;
+
 static int qlge_probe(struct pci_dev *pdev,
 		      const struct pci_device_id *pci_entry)
 {
 	struct net_device *ndev = NULL;
 	struct qlge_adapter *qdev = NULL;
+	struct devlink *devlink;
 	static int cards_found;
 	int err = 0;
 
-	ndev = alloc_etherdev_mq(sizeof(struct qlge_adapter),
+	devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_adapter));
+	if (!devlink)
+		return -ENOMEM;
+
+	qdev = devlink_priv(devlink);
+
+	ndev = alloc_etherdev_mq(sizeof(struct qlge_netdev_priv),
 				 min(MAX_CPUS,
 				     netif_get_num_default_rss_queues()));
 	if (!ndev)
-		return -ENOMEM;
+		goto devlink_free;
 
-	err = qlge_init_device(pdev, ndev, cards_found);
-	if (err < 0) {
-		free_netdev(ndev);
-		return err;
-	}
+	qdev->ndev = ndev;
+	err = qlge_init_device(pdev, qdev, cards_found);
+	if (err < 0)
+		goto devlink_free;
 
-	qdev = netdev_priv(ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 	ndev->hw_features = NETIF_F_SG |
 		NETIF_F_IP_CSUM |
@@ -4611,8 +4619,14 @@ static int qlge_probe(struct pci_dev *pdev,
 		qlge_release_all(pdev);
 		pci_disable_device(pdev);
 		free_netdev(ndev);
-		return err;
+		goto devlink_free;
 	}
+
+	err = devlink_register(devlink, &pdev->dev);
+	if (err)
+		goto devlink_free;
+
+	qlge_health_create_reporters(qdev);
 	/* Start up the timer to trigger EEH if
 	 * the bus goes dead
 	 */
@@ -4623,6 +4637,10 @@ static int qlge_probe(struct pci_dev *pdev,
 	atomic_set(&qdev->lb_count, 0);
 	cards_found++;
 	return 0;
+
+devlink_free:
+	devlink_free(devlink);
+	return err;
 }
 
 netdev_tx_t qlge_lb_send(struct sk_buff *skb, struct net_device *ndev)
@@ -4637,14 +4655,18 @@ int qlge_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget)
 
 static void qlge_remove(struct pci_dev *pdev)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = pci_get_drvdata(pdev);
+	struct net_device *ndev = qdev->ndev;
+	struct devlink *devlink = priv_to_devlink(qdev);
 
 	del_timer_sync(&qdev->timer);
 	qlge_cancel_all_work_sync(qdev);
 	unregister_netdev(ndev);
 	qlge_release_all(pdev);
 	pci_disable_device(pdev);
+	devlink_health_reporter_destroy(qdev->reporter);
+	devlink_unregister(devlink);
+	devlink_free(devlink);
 	free_netdev(ndev);
 }
 
-- 
2.28.0

